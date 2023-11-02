class_name HotSeatGame
extends Node2D


var unit_scene: PackedScene = preload("res://scenes/game/unit.tscn")
var chosen_unit: Unit = null
# 记录地图
var _map: Map
# 左键点击开始时相对镜头的本地坐标
var _from_camera_position := Vector2(-1, -1)
# 鼠标悬浮的图块坐标和时间
var _mouse_hover_tile_coord: Vector2i = GlobalScript.NULL_COORD
var _mouse_hover_tile_time: float = 0

@onready var map_shower: MapShower = $MapShower
@onready var units: Node2D = $Units
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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# get_viewport().set_input_as_handled()
			if event.is_pressed():
				#print("clicked mouse left button")
				# 开始拖拽镜头
				camera.start_drag(event.position)
				# 选取图块
				_from_camera_position = camera.to_local(get_global_mouse_position())
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
			else:
				camera.end_drag()
	elif event is InputEventMouseMotion:
		# 拖拽镜头过程中
		get_viewport().set_input_as_handled()
		camera.drag(event.position)


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
	var unit: Unit = unit_scene.instantiate()
	units.add_child(unit)
	unit.initiate(type, GlobalScript.get_current_player(), coord, _map, map_shower)
	unit.unit_clicked.connect(handle_unit_clicked)
	return unit


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

