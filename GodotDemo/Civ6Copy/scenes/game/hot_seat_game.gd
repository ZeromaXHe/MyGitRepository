class_name HotSeatGame
extends Node2D


signal turn_changed(num: int, year: int)
signal chosen_unit_changed(unit: Unit)
signal chosen_city_changed(city: City)
signal turn_status_changed(stats: TurnStatus)


enum TurnStatus {
	END_TURN,
	UNIT_NEED_MOVE,
	CITY_NEED_PRODUCT,
}

const UNIT_SCENE: PackedScene = preload("res://scenes/game/unit.tscn")
const CITY_SCENE: PackedScene = preload("res://scenes/game/city.tscn")

var chosen_unit: Unit = null:
	set(unit):
		chosen_unit = unit
		chosen_unit_changed.emit(unit)
		if unit == null:
			game_gui.hide_unit_info()
		else:
			game_gui.show_unit_info()
var chosen_city: City = null:
	set(city):
		chosen_city = city
		chosen_city_changed.emit(city)
		if city == null:
			game_gui.hide_city_info()
		else:
			game_gui.show_city_info()
# 左键点击开始时相对镜头的本地坐标
var _from_camera_position := Vector2(-1, -1)
# 鼠标悬浮的图块坐标和时间
var _mouse_hover_tile_coord: Vector2i = GlobalScript.NULL_COORD
var _mouse_hover_tile_time: float = 0
# 回合相关
var turn_status: TurnStatus = TurnStatus.END_TURN:
	set(status):
		turn_status = status
		turn_status_changed.emit(status)
var turn_num: int = 1:
	set(turn):
		turn_num = turn
		turn_year = -4100 + 100 * turn
		turn_changed.emit(turn_num, turn_year)
var turn_year: int = -4000

@onready var map_shower: MapShower = $MapShower
@onready var territory_borders: Node2D = $TerritoryBorders
@onready var units: Node2D = $Units
@onready var cities: Node2D = $Cities
@onready var camera: CameraManager = $Camera2D
@onready var game_gui: GameGUI = $GameGUI


func _ready() -> void:
	map_shower.initialize()
	camera.initialize(map_shower._map.get_map_tile_size(), map_shower.get_map_tile_xy())
	# 绑定 game_gui 和游戏之间的所有信号（双向）
	game_gui.signal_binding_with_game(self)
	# 将所有玩家的领土 TileMap 放到场景中
	for player in GlobalScript.player_arr:
		territory_borders.add_child(player.territory_border)
	initialize_sight_tile()
	# 增加测试单位
	test_add_unit()
	# 初始化回合状态
	initialize_turn_status()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# get_viewport().set_input_as_handled()
			if event.is_pressed():
				# 选取图块
				_from_camera_position = camera.to_local(get_global_mouse_position())
			elif event.is_released():
				# 移动单位
				if chosen_unit != null:
					var click_coord: Vector2i = map_shower.get_map_coord()
					if click_coord == chosen_unit.coord:
						return
					if map_shower.is_in_move_tile_areas(click_coord):
						map_shower.clear_move_tile_areas()
						chosen_unit.move_to(click_coord, map_shower)
					else:
						map_shower.clear_move_tile_areas()
					chosen_unit = null
				# 取消城市选择
				if chosen_city != null:
					chosen_city = null


func _process(delta: float) -> void:
	handle_mouse_hover_tile(delta)


func initialize_turn_status() -> void:
	if GlobalScript.get_current_player().get_next_movable_unit() != null:
		turn_status = TurnStatus.UNIT_NEED_MOVE
	else:
		turn_status = TurnStatus.END_TURN


func initialize_sight_tile() -> void:
	var player: Player = GlobalScript.get_current_player()
	var map_size: Vector2i = map_shower._map.get_map_tile_size()
	player.map_sight_info.initialize(map_size)
	paint_player_sight(player)


func paint_player_sight(player: Player) -> void:
	for coord in player.map_sight_info.unseen_dict:
		map_shower.paint_out_sight_tile_areas(coord, Map.SightType.UNSEEN)
	for coord in player.map_sight_info.seen_dict:
		map_shower.paint_out_sight_tile_areas(coord, Map.SightType.SEEN)
	map_shower.paint_in_sight_tile_areas(player.map_sight_info.get_in_sight_cells())


func test_add_unit() -> void:
	GlobalScript.load_info = "初始化单位..."
	var settler: Unit = add_unit(Unit.Type.SETTLER, Vector2i(22, 13))
	var warrior: Unit = add_unit(Unit.Type.WARRIOR, Vector2i(21, 13))


func add_unit(type: Unit.Type, coord: Vector2i) -> Unit:
	var unit: Unit = UNIT_SCENE.instantiate()
	units.add_child(unit)
	unit.initiate(type, GlobalScript.get_current_player(), coord, map_shower)
	# 处理单位信号
	unit.unit_clicked.connect(handle_unit_clicked)
	unit.unit_move_capability_depleted.connect(handle_unit_move_capability_depleted)
	return unit


func build_city(coord: Vector2i) -> void:
	var city: City = CITY_SCENE.instantiate()
	cities.add_child(city)
	city.initiate(coord, map_shower)
	city.city_clicked.connect(handle_city_clicked)


func handle_city_button_pressed() -> void:
	# 建立城市
	build_city(chosen_unit.coord)
	# 删除开拓者
	chosen_unit.delete(map_shower)
	chosen_unit = null
	map_shower.clear_move_tile_areas()


func handle_city_product_settler_button_pressed() -> void:
	if chosen_city == null:
		printerr("handle_city_product_settler_button_pressed | weird, no chosen city")
		return
	chosen_city.producing_unit_type = Unit.Type.SETTLER


func handle_turn_button_clicked() -> void:
	match turn_status:
		TurnStatus.END_TURN:
			chosen_unit = null
			# 增加回合数
			turn_num += 1
			# 刷新单位移动力
			GlobalScript.get_current_player().refresh_units_move_capabilities()
			initialize_turn_status()
		TurnStatus.UNIT_NEED_MOVE:
			var movable_unit: Unit = GlobalScript.get_current_player().get_next_movable_unit()
			if movable_unit == null:
				printerr("handle_turn_button_clicked | UNIT_NEED_MOVE | no movable unit found")
			else:
				chose_unit_and_camera_focus(movable_unit)


func handle_unit_move_capability_depleted(unit: Unit) -> void:
	# 当玩家所有单位的移动力都耗尽了，则可以下一回合
	if GlobalScript.get_current_player().get_next_movable_unit(unit) == null:
		game_gui.show_turn_end_turn()
	chosen_unit = null


func chose_unit_and_camera_focus(unit: Unit):
	handle_unit_clicked(unit)
	camera.global_position = map_shower.map_coord_to_global_position(unit.coord)


func handle_city_clicked(city: City) -> void:
	chosen_city = city


func handle_unit_clicked(unit: Unit) -> void:
	print("handle_unit_clicked | ", unit.coord, " is clicked")
	if chosen_unit != null:
		print("handle_unit_clicked | hide chosen_unit move range", chosen_unit.coord)
		map_shower.clear_move_tile_areas()
	# 显示移动框
	unit.show_move_range(map_shower)
	chosen_unit = unit


func handle_mouse_hover_tile(delta: float) -> bool:
	var map_coord: Vector2i = map_shower.get_map_coord()
	if map_coord == _mouse_hover_tile_coord:
		_mouse_hover_tile_time += delta
		if not game_gui.is_mouse_hover_info_shown() and _mouse_hover_tile_time > 2 and map_shower._map.is_in_map_tile(map_coord):
			game_gui.show_mouse_hover_tile_info(map_coord, map_shower._map.get_map_tile_info_at(map_coord))
		return false
	_mouse_hover_tile_coord = map_coord
	_mouse_hover_tile_time = 0
	game_gui.hide_mouse_hover_tile_info()
	return true

