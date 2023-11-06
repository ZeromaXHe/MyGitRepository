class_name HotSeatGame
extends Node2D


const UNIT_SCENE: PackedScene = preload("res://scenes/game/unit.tscn")
const CITY_SCENE: PackedScene = preload("res://scenes/game/city.tscn")

var chosen_unit: Unit = null:
	set(unit):
		chosen_unit = unit
		if unit == null:
			game_gui.hide_unit_info()
		else:
			game_gui.show_unit_info(unit)
# 记录地图
var _map: Map
# 左键点击开始时相对镜头的本地坐标
var _from_camera_position := Vector2(-1, -1)
# 鼠标悬浮的图块坐标和时间
var _mouse_hover_tile_coord: Vector2i = GlobalScript.NULL_COORD
var _mouse_hover_tile_time: float = 0
# 回合相关
var turn_num: int = 1
var turn_year: int = -4000

@onready var map_shower: MapShower = $MapShower
@onready var territory_borders: Node2D = $TerritoryBorders
@onready var units: Node2D = $Units
@onready var cities: Node2D = $Cities
@onready var camera: CameraManager = $Camera2D
@onready var game_gui: GameGUI = $GameGUI


func _init() -> void:
	load_map()


func _ready() -> void:
	map_shower.initialize(_map)
	camera.initialize(_map.get_map_tile_size(), map_shower.get_map_tile_xy())
	initialize_sight_tile()
	# 增加测试单位
	test_add_unit()
	# 将所有玩家的领土 TileMap 放到场景中
	for player in GlobalScript.player_arr:
		territory_borders.add_child(player.territory_border)
	# 处理回合按钮信号
	game_gui.turn_button_clicked.connect(handle_turn_button_clicked)
	# 处理建立城市按钮的信号
	game_gui.city_button_pressed.connect(handle_city_button_pressed)


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
						chosen_unit.move_to(click_coord, _map, map_shower)
					else:
						map_shower.clear_move_tile_areas()
					chosen_unit = null


func _process(delta: float) -> void:
	handle_mouse_hover_tile(delta)


func initialize_sight_tile() -> void:
	# 临时测试视野范围显示
	var player: Player = GlobalScript.get_current_player()
	var map_size: Vector2i = _map.get_map_tile_size()
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
	unit.initiate(type, GlobalScript.get_current_player(), coord, _map, map_shower)
	# 处理单位信号
	unit.unit_clicked.connect(handle_unit_clicked)
	unit.unit_move_capability_depleted.connect(handle_unit_move_capability_depleted)
	return unit


func build_city(coord: Vector2i) -> void:
	var city: City = CITY_SCENE.instantiate()
	cities.add_child(city)
	city.initiate(coord, _map, map_shower)


func handle_city_button_pressed() -> void:
	# 建立城市
	build_city(chosen_unit.coord)
	# 删除开拓者
	chosen_unit.delete(_map, map_shower)
	chosen_unit = null
	map_shower.clear_move_tile_areas()


func handle_turn_button_clicked(end_turn: bool) -> void:
	if end_turn:
		chosen_unit = null
		# 增加回合数
		turn_num += 1
		turn_year += 100
		game_gui.update_turn_and_year_label(turn_num, turn_year)
		# 刷新单位移动力
		GlobalScript.get_current_player().refresh_units_move_capabilities()
		game_gui.show_turn_unit_need_move()
	else:
		var player: Player = GlobalScript.get_current_player()
		if player.units[0].move_capability > 0:
			chose_unit_and_camera_focus(player.units[0])
		else:
			chose_unit_and_camera_focus(player.get_next_movable_unit(player.units[0]))


func handle_unit_move_capability_depleted(unit: Unit) -> void:
	# 当玩家所有单位的移动力都耗尽了，则可以下一回合
	if GlobalScript.get_current_player().get_next_movable_unit(unit) == null:
		game_gui.show_turn_end_turn()
	chosen_unit = null


func chose_unit_and_camera_focus(unit: Unit):
	handle_unit_clicked(unit)
	camera.global_position = map_shower.map_coord_to_global_position(unit.coord)


func handle_unit_clicked(unit: Unit) -> void:
	print("handle_unit_clicked | ", unit.coord, " is clicked")
	if chosen_unit != null:
		print("handle_unit_clicked | hide chosen_unit move range", chosen_unit.coord)
		map_shower.clear_move_tile_areas()
	# 显示移动框
	unit.show_move_range(_map, map_shower)
	# TODO: 显示右下角信息栏
	chosen_unit = unit


func handle_mouse_hover_tile(delta: float) -> bool:
	var map_coord: Vector2i = map_shower.get_map_coord()
	if map_coord == _mouse_hover_tile_coord:
		_mouse_hover_tile_time += delta
		if not game_gui.is_mouse_hover_info_shown() and _mouse_hover_tile_time > 2 and _map.is_in_map_tile(map_coord):
			game_gui.show_mouse_hover_tile_info(map_coord, _map.get_map_tile_info_at(map_coord))
		return false
	_mouse_hover_tile_coord = map_coord
	_mouse_hover_tile_time = 0
	game_gui.hide_mouse_hover_tile_info()
	return true


func load_map() -> void:
	_map = Map.load_from_save()
	if _map == null:
		printerr("you have no map save")
		return

