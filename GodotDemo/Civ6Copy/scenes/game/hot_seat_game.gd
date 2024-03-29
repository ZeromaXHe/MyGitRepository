class_name HotSeatGame
extends Node2D


signal turn_changed(num: int, year: int)
signal player_changed
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


const BUY_CELL_NODE_2D_SCENE: PackedScene = preload("res://scenes/game/buy_cell_node_2d.tscn")
const CITIZEN_NODE_2D_SCENE: PackedScene = preload("res://scenes/game/citizen_node_2d.tscn")

static var singleton: HotSeatGame

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
@onready var buy_cell_nodes: Node2D = $BuyCellNodes
@onready var citizen_nodes: Node2D = $CitizenNodes
@onready var camera: CameraManager = $Camera2D


func _ready() -> void:
	singleton = self
	GameController.set_mode(GameController.Mode.HOT_SEAT_GAME)
	# 初始化 A*
	MapService.init_move_astar()
	MapService.init_sight_astar()
	# 将所有玩家的领土 TileMap 放到场景中
	for player in Player.id_dict.values():
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
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				chosen_city = null
				chosen_unit = null


func _process(delta: float) -> void:
	handle_mouse_hover_tile(delta)


func initiate_turn_status() -> void:
	refresh_turn_status()
	if turn_status == TurnStatus.CITY_NEED_PRODUCT:
		chose_city_and_camera_focus(PlayerService.get_next_productable_city(-1 if chosen_city == null else chosen_city.id))
	elif turn_status == TurnStatus.UNIT_NEED_MOVE:
		chose_unit_and_camera_focus(PlayerService.get_next_need_move_unit(-1 if chosen_unit == null else chosen_unit.id))
	else:
		# 其他情况下，随便找个城市或者单位作为摄像机焦点
		var player_id = PlayerService.get_current_player_id()
		var units: Array = UnitService.get_unit_dos_of_player(player_id)
		if not units.is_empty():
			handle_clicked_on_minimap_tile((units[0] as UnitDO).coord)
		else:
			var citys: Array = CityService.get_city_dos_of_player(player_id)
			# 城市一定有，不然文明就灭亡了……
			handle_clicked_on_minimap_tile((citys[0] as CityDO).coord)


func refresh_turn_status() -> void:
	if PlayerService.get_next_productable_city(-1 if chosen_city == null else chosen_city.id) != null:
		turn_status = TurnStatus.CITY_NEED_PRODUCT
	elif PlayerService.get_next_need_move_unit(-1 if chosen_unit == null else chosen_unit.id) != null:
		turn_status = TurnStatus.UNIT_NEED_MOVE
	else:
		turn_status = TurnStatus.END_TURN


func paint_player_sight() -> void:
	var player: PlayerDO = PlayerService.get_current_player()
	var size_vec: Vector2i = MapService.get_map_tile_size_vec()
	for i in range(size_vec.x):
		for j in range(size_vec.y):
			map_shower.paint_out_sight_tile_areas(Vector2i(i, j), PlayerSightTable.Sight.UNSEEN)
	var seens: Array = PlayerSightService.get_player_sight_dos_by_sight(player.id, PlayerSightTable.Sight.SEEN)
	for seen in seens:
		map_shower.paint_out_sight_tile_areas(seen.coord, PlayerSightTable.Sight.SEEN)
	var in_sights: Array = PlayerSightService.get_player_sight_dos_by_sight(player.id, PlayerSightTable.Sight.IN_SIGHT)
	var in_sight_coords: Array[Vector2i] = []
	for in_sight in in_sights:
		in_sight_coords.append(in_sight.coord)
	map_shower.paint_in_sight_tile_areas(in_sight_coords)


func test_add_unit() -> void:
	GlobalScript.load_info = "初始化单位..."
	# TODO: 现在坐标和单位玩家 id 都是写死的，后续优化
	add_unit(1, UnitTypeTable.Enum.SETTLER, Vector2i(14, 14))
	add_unit(1, UnitTypeTable.Enum.WARRIOR, Vector2i(14, 13))
	add_unit(2, UnitTypeTable.Enum.SETTLER, Vector2i(18, 11))
	add_unit(2, UnitTypeTable.Enum.WARRIOR, Vector2i(17, 11))


func add_unit(player_id: int, type: UnitTypeTable.Enum, coord: Vector2i) -> Unit:
	var req_dto := CreateUnitReqDTO.new()
	req_dto.coord = coord
	req_dto.player_id = player_id
	req_dto.type = type
	var unit: Unit = Unit.create_unit(req_dto)
	units.add_child(unit)
	unit.initiate()
	# 处理单位信号
	unit.unit_clicked.connect(handle_unit_clicked)
	unit.unit_move_depleted.connect(handle_unit_move_depleted)
	# 新的单位需要移动，更新一下回合状态
	refresh_turn_status()
	return unit


func build_city(coord: Vector2i) -> void:
	if MapTileService.get_map_tile_do_by_coord(coord).city_id > 0:
		# 已经被占领的地块不能建城
		return
	var city: City = City.create_city(coord)
	cities.add_child(city)
	city.initiate()
	city.city_clicked.connect(handle_city_clicked)
	city.city_production_changed.connect(handle_city_production_changed)
	city.city_production_completed.connect(handle_city_production_completed)
	city.city_name_button_pressed.connect(handle_city_clicked)
	city.city_product_button_pressed.connect(handle_city_product_button_pressed)
	# 新的城市需要选择建造项目，更新一下回合状态
	refresh_turn_status()


func handle_city_product_button_pressed(city: City) -> void:
	handle_city_clicked(city)
	gui_reverse_city_product_panel_visible.emit()


func chose_unit_and_camera_focus(unit: UnitDO) -> void:
	handle_unit_clicked(Unit.id_dict[unit.id])
	camera.global_position = map_shower.map_coord_to_global_position(unit.coord)


func chose_city_and_camera_focus(city: CityDO) -> void:
	handle_city_clicked(City.id_dict[city.id])
	camera.global_position = map_shower.map_coord_to_global_position(city.coord)


func set_chosen_city(city: City) -> void:
	chosen_city = city
	chosen_city_changed.emit(city)
	if city == null:
		clear_buy_cell_nodes()
		clear_citizen_nodes()


func set_chosen_unit(unit: Unit) -> void:
	if chosen_unit != null:
		map_shower.clear_move_tile_areas()
	var current_player_not_null_unit: bool = unit != null and UnitService.get_unit_do(unit.id).player_id == PlayerService.get_current_player_id()
	if current_player_not_null_unit:
		# 点的是当前玩家的单位，才会显示移动框
		unit.show_move_range()
	chosen_unit = unit
	chosen_unit_changed.emit(unit)
	if current_player_not_null_unit:
		UnitService.wake_unit(unit.id)


func handle_city_clicked(city: City) -> void:
	chosen_city = city
	chosen_unit = null


func handle_unit_clicked(unit: Unit) -> void:
	chosen_city = null
	chosen_unit = unit


func handle_city_production_completed(unit_type: UnitTypeTable.Enum, city_coord: Vector2i) -> void:
	add_unit(PlayerService.get_current_player().id, unit_type, city_coord)


func handle_unit_city_button_pressed() -> void:
	# 建立城市
	build_city(UnitService.get_unit_do(chosen_unit.id).coord)
	# 删除开拓者
	chosen_unit.delete()
	chosen_unit = null
	map_shower.clear_move_tile_areas()


func handle_unit_skip_button_pressed() -> void:
	UnitService.skip_unit(chosen_unit.id)
	chosen_unit = null
	# 跳过后可能没有单位需要移动了，需要更新回合状态
	refresh_turn_status()


func handle_unit_sleep_button_pressed() -> void:
	UnitService.sleep_unit(chosen_unit.id)
	chosen_unit = null
	# 睡眠后可能没有单位需要移动了，需要更新回合状态
	refresh_turn_status()


func handle_city_product_settler_button_pressed() -> void:
	if chosen_city == null:
		printerr("handle_city_product_settler_button_pressed | weird, no chosen city")
		return
	gui_hide_city_product_panel.emit()
	CityService.choose_producing_unit(chosen_city.id, UnitTypeTable.Enum.SETTLER)


func handle_buy_cell_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		initiate_buy_cell_nodes()
	else:
		clear_buy_cell_nodes()


func handle_buy_cell_node_pressed() -> void:
	clear_buy_cell_nodes()
	initiate_buy_cell_nodes()
	# 如果正在显示市民管理按钮，需要刷新一下
	if citizen_nodes.get_child_count() > 0:
		clear_citizen_nodes()
		initiate_citizen_nodes()


func initiate_buy_cell_nodes() -> void:
	var rims: Array[Vector2i] = CityService.get_city_rims(chosen_city.id)
	var city_coord: Vector2i = CityService.get_city_do(chosen_city.id).coord
	for rim in rims:
		if HexagonUtils.OffsetCoord.odd_r(rim.x, rim.y).distance_to(HexagonUtils.OffsetCoord.odd_r(city_coord.x, city_coord.y)) > 3 \
				or MapTileService.get_map_tile_do_by_coord(rim).city_id > 0:
			continue
		var buy_cell_node_2d: BuyCellNode2D = BUY_CELL_NODE_2D_SCENE.instantiate()
		buy_cell_node_2d.global_position = map_shower.map_coord_to_global_position(rim)
		buy_cell_node_2d.city_id = chosen_city.id
		buy_cell_node_2d.coord = rim
		buy_cell_node_2d.node_pressed.connect(handle_buy_cell_node_pressed)
		buy_cell_nodes.add_child(buy_cell_node_2d)


func clear_buy_cell_nodes() -> void:
	for node in buy_cell_nodes.get_children():
		node.queue_free()


func handle_citizen_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		initiate_citizen_nodes()
	else:
		clear_citizen_nodes()


func initiate_citizen_nodes() -> void:
	var territories: Array[Vector2i] = CityService.get_city_territories(chosen_city.id)
	for territory in territories:
		var citizen_node_2d: CitizenNode2D = CITIZEN_NODE_2D_SCENE.instantiate()
		citizen_node_2d.global_position = map_shower.map_coord_to_global_position(territory)
		citizen_node_2d.city_id = chosen_city.id
		citizen_node_2d.coord = territory
		citizen_nodes.add_child(citizen_node_2d)


func clear_citizen_nodes() -> void:
	for node in citizen_nodes.get_children():
		node.queue_free()


func handle_turn_button_clicked() -> void:
	match turn_status:
		TurnStatus.END_TURN:
			chosen_unit = null
			chosen_city = null
			# 刷新单位移动力、跳过状态等
			PlayerService.refresh_units()
			# 更新城市生产进度
			PlayerService.update_citys_product_val()
			# 切换下一个玩家
			if PlayerService.current_player_end_turn():
				# 如果所有玩家都已经轮替完毕，增加回合数
				turn_num += 1
			player_changed.emit()
			initiate_turn_status()
			paint_player_sight()
		TurnStatus.UNIT_NEED_MOVE:
			var movable_unit: UnitDO = PlayerService.get_next_need_move_unit(-1 if chosen_unit == null else chosen_unit.id)
			if movable_unit == null:
				printerr("handle_turn_button_clicked | UNIT_NEED_MOVE | no movable unit found")
			else:
				chose_unit_and_camera_focus(movable_unit)
		TurnStatus.CITY_NEED_PRODUCT:
			var productable_city: CityDO = PlayerService.get_next_productable_city(-1 if chosen_city == null else chosen_city.id)
			if productable_city == null:
				printerr("handle_turn_button_clicked | CITY_NEED_PRODUCT | no productable city found")
			else:
				chose_city_and_camera_focus(productable_city)
				gui_show_city_product_panel.emit()


func handle_unit_move_depleted(_unit_id: int) -> void:
	# 单位的移动力耗尽时，更新回合状态
	refresh_turn_status()


func handle_city_production_changed(id: int) -> void:
	City.id_dict[id].update_production_ui()
	# 城市选择了新的生产项目，需要刷新一下回合状态
	refresh_turn_status()


func handle_clicked_on_minimap_tile(coord: Vector2i) -> void:
	camera.global_position = map_shower.map_coord_to_global_position(coord)


func handle_mouse_hover_tile(delta: float) -> void:
	var map_coord: Vector2i = map_shower.get_mouse_map_coord()
	if map_coord == _mouse_hover_tile_coord:
		_mouse_hover_tile_time += delta
		if map_shower.is_in_sight_tile_area(map_coord) and _mouse_hover_tile_time > 2 \
				and MapService.is_in_map_tile(map_coord):
			gui_show_mouse_hover_tile_info.emit(map_coord)
		return
	_mouse_hover_tile_coord = map_coord
	_mouse_hover_tile_time = 0
	gui_hide_mouse_hover_tile_info.emit()
