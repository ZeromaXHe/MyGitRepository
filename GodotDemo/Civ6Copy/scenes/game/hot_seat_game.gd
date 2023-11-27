class_name HotSeatGame
extends Node2D


signal turn_changed(num: int, year: int)
signal chosen_unit_changed(unit: Unit)
signal chosen_city_changed(city: City)
signal turn_status_changed(stats: TurnStatus)
# GUI 相关信号
signal gui_reverse_city_product_panel_visible
signal gui_hide_city_product_panel
signal gui_show_city_product_panel
signal gui_show_mouse_hover_tile_info(map_coord: Vector2i)
signal gui_hide_mouse_hover_tile_info


enum TurnStatus {
	END_TURN,
	UNIT_NEED_MOVE,
	CITY_NEED_PRODUCT,
	TECH_NEED_CHOOSE,
}


var chosen_unit: Unit = null:
	set = set_chosen_unit
var chosen_city: City = null:
	set = set_chosen_city
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


func _ready() -> void:
	GameController.set_mode(GameController.Mode.HOT_SEAT_GAME)
	# 初始化 A*
	MapController.init_astar()
	# 连接信号
	ViewSignalsEmitter.connect_game_signals(self)
	# 将所有玩家的领土 TileMap 放到场景中
	for player in ViewHolder.get_all_players():
		territory_borders.add_child((player as Player).territory_border)
	paint_player_sight()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_released():
				if chosen_unit == null:
					return
				# 移动单位
				var click_coord: Vector2i = map_shower.get_mouse_map_coord()
				if map_shower.is_in_move_tile_areas(click_coord):
					map_shower.clear_move_tile_areas()
					chosen_unit.move_to(click_coord)


func _process(delta: float) -> void:
	handle_mouse_hover_tile(delta)


func get_minimap_camera() -> CameraManager:
	return camera


func refresh_turn_status() -> void:
	if PlayerController.get_next_productable_city(-1 if chosen_city == null else chosen_city.id) != null:
		turn_status = TurnStatus.CITY_NEED_PRODUCT
	elif PlayerController.get_next_need_move_unit(-1 if chosen_unit == null else chosen_unit.id) != null:
		turn_status = TurnStatus.UNIT_NEED_MOVE
	else:
		turn_status = TurnStatus.END_TURN


func paint_player_sight() -> void:
	var player: PlayerDO = PlayerController.get_current_player()
	var unseens: Array = PlayerSightController.get_player_sight_dos_by_sight(PlayerSightTable.Sight.UNSEEN)
	for unseen in unseens:
		map_shower.paint_out_sight_tile_areas(unseen.coord, PlayerSightTable.Sight.UNSEEN)
	var seens: Array = PlayerSightController.get_player_sight_dos_by_sight(PlayerSightTable.Sight.SEEN)
	for seen in seens:
		map_shower.paint_out_sight_tile_areas(seen.coord, PlayerSightTable.Sight.SEEN)
	var in_sights: Array = PlayerSightController.get_player_sight_dos_by_sight(PlayerSightTable.Sight.IN_SIGHT)
	var in_sight_coords: Array[Vector2i] = []
	for in_sight in in_sights:
		in_sight_coords.append(in_sight.coord)
	map_shower.paint_in_sight_tile_areas(in_sight_coords)


func test_add_unit() -> void:
	GlobalScript.load_info = "初始化单位..."
	var settler: Unit = add_unit(UnitTypeTable.Enum.SETTLER, Vector2i(22, 13))
	var warrior: Unit = add_unit(UnitTypeTable.Enum.WARRIOR, Vector2i(21, 13))


func add_unit(type: UnitTypeTable.Enum, coord: Vector2i) -> Unit:
	var req_dto := CreateUnitReqDTO.new()
	req_dto.coord = coord
	req_dto.player_id = PlayerController.get_current_player().id
	req_dto.type = type
	var unit: Unit = UnitController.create_unit(req_dto)
	units.add_child(unit)
	unit.initiate()
	# 处理单位信号
	unit.unit_clicked.connect(handle_unit_clicked)
	ViewSignalsEmitter.get_instance().unit_move_depleted.connect(handle_unit_move_depleted)
	# 新的单位需要移动，更新一下回合状态
	refresh_turn_status()
	return unit


func build_city(coord: Vector2i) -> void:
	var city: City = CityController.create_city(coord)
	cities.add_child(city)
	city.initiate()
	city.city_clicked.connect(handle_city_clicked)
	city.city_name_button_pressed.connect(handle_city_clicked)
	city.city_product_button_pressed.connect(handle_city_product_button_pressed)
	# 新的城市需要选择建造项目，更新一下回合状态
	refresh_turn_status()


func handle_city_product_button_pressed(city: City) -> void:
	handle_city_clicked(city)
	gui_reverse_city_product_panel_visible.emit()


func chose_unit_and_camera_focus(unit: UnitDO) -> void:
	handle_unit_clicked(ViewHolder.get_unit(unit.id))
	camera.global_position = map_shower.map_coord_to_global_position(unit.coord)


func chose_city_and_camera_focus(city: CityDO) -> void:
	handle_city_clicked(ViewHolder.get_city(city.id))
	camera.global_position = map_shower.map_coord_to_global_position(city.coord)


func set_chosen_city(city: City) -> void:
	chosen_city = city
	chosen_city_changed.emit(city)


func set_chosen_unit(unit: Unit) -> void:
	if chosen_unit != null:
		map_shower.clear_move_tile_areas()
	if unit != null:
		# 显示移动框
		unit.show_move_range()
	chosen_unit = unit
	chosen_unit_changed.emit(unit)
	if unit != null:
		UnitController.wake_unit(unit.id)


func handle_city_clicked(city: City) -> void:
	chosen_city = city
	chosen_unit = null


func handle_unit_clicked(unit: Unit) -> void:
	chosen_city = null
	chosen_unit = unit


func handle_city_production_completed(unit_type: UnitTypeTable.Enum, city_coord: Vector2i) -> void:
	add_unit(unit_type, city_coord)


func handle_unit_city_button_pressed() -> void:
	# 建立城市
	build_city(UnitController.get_unit_do(chosen_unit.id).coord)
	# 删除开拓者
	chosen_unit.delete()
	chosen_unit = null
	map_shower.clear_move_tile_areas()


func handle_unit_skip_button_pressed() -> void:
	UnitController.skip_unit(chosen_unit.id)
	chosen_unit = null
	# 跳过后可能没有单位需要移动了，需要更新回合状态
	refresh_turn_status()


func handle_unit_sleep_button_pressed() -> void:
	UnitController.sleep_unit(chosen_unit.id)
	chosen_unit = null
	# 睡眠后可能没有单位需要移动了，需要更新回合状态
	refresh_turn_status()


func handle_city_product_settler_button_pressed() -> void:
	if chosen_city == null:
		printerr("handle_city_product_settler_button_pressed | weird, no chosen city")
		return
	gui_hide_city_product_panel.emit()
	CityController.choose_producing_unit(chosen_city.id, UnitTypeTable.Enum.SETTLER)


func handle_turn_button_clicked() -> void:
	match turn_status:
		TurnStatus.END_TURN:
			chosen_unit = null
			# 增加回合数
			turn_num += 1
			# 刷新单位移动力、跳过状态等
			PlayerController.refresh_units()
			# 更新城市生产进度
			PlayerController.update_citys_product_val()
			refresh_turn_status()
		TurnStatus.UNIT_NEED_MOVE:
			var movable_unit: UnitDO = PlayerController.get_next_need_move_unit(-1 if chosen_unit == null else chosen_unit.id)
			if movable_unit == null:
				printerr("handle_turn_button_clicked | UNIT_NEED_MOVE | no movable unit found")
			else:
				chose_unit_and_camera_focus(movable_unit)
		TurnStatus.CITY_NEED_PRODUCT:
			var productable_city: CityDO = PlayerController.get_next_productable_city(-1 if chosen_city == null else chosen_city.id)
			if productable_city == null:
				printerr("handle_turn_button_clicked | CITY_NEED_PRODUCT | no productable city found")
			else:
				chose_city_and_camera_focus(productable_city)
				gui_show_city_product_panel.emit()


func handle_unit_move_depleted(_unit_id: int) -> void:
	# 单位的移动力耗尽时，更新回合状态
	refresh_turn_status()


func handle_city_production_changed(id: int) -> void:
	ViewHolder.get_city(id).update_production_ui()
	# 城市选择了新的生产项目，需要刷新一下回合状态
	refresh_turn_status()


func handle_clicked_on_minimap_tile(coord: Vector2i) -> void:
	camera.global_position = map_shower.map_coord_to_global_position(coord)


func handle_mouse_hover_tile(delta: float) -> void:
	var map_coord: Vector2i = map_shower.get_mouse_map_coord()
	if map_coord == _mouse_hover_tile_coord:
		_mouse_hover_tile_time += delta
		if map_shower.is_in_sight_tile_area(map_coord) and _mouse_hover_tile_time > 2 \
				and MapController.is_in_map_tile(map_coord):
			gui_show_mouse_hover_tile_info.emit(map_coord)
		return
	_mouse_hover_tile_coord = map_coord
	_mouse_hover_tile_time = 0
	gui_hide_mouse_hover_tile_info.emit()
