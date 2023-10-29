class_name HotSeatGame
extends Node2D


var unit_scene: PackedScene = preload("res://scenes/game/unit.tscn")
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


func _ready() -> void:
	load_map()
	initialize_camera(_map.size)
	
	var settler: Unit = unit_scene.instantiate()
	units.add_child(settler)
	settler.initiate(Unit.Type.SETTLER, GlobalScript.get_current_player())
	settler.global_position = map_shower.map_coord_to_global_position(Vector2i(22, 13))
	
	var warrior: Unit = unit_scene.instantiate()
	units.add_child(warrior)
	warrior.initiate(Unit.Type.WARRIOR, GlobalScript.get_current_player())
	warrior.global_position = map_shower.map_coord_to_global_position(Vector2i(21, 13))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_viewport().set_input_as_handled()
			if event.is_pressed():
				#print("clicked mouse left button")
				# 开始拖拽镜头
				camera.start_drag(event.position)
				# 选取图块
				_from_camera_position = camera.to_local(get_global_mouse_position())
			else:
				camera.end_drag()
	elif event is InputEventMouseMotion:
		# 拖拽镜头过程中
		get_viewport().set_input_as_handled()
		camera.drag(event.position)


func _process(delta: float) -> void:
	handle_mouse_hover_tile(delta)


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
	var size: Vector2i = Map.SIZE_DICT[_map.size]
	# 读取地块
	for i in range(0, size.x):
		for j in range(0, size.y):
			var coord := Vector2i(i, j)
			var tile_info: Map.TileInfo = _map.get_map_tile_info_at(coord)
			map_shower.paint_tile(coord, tile_info)
	# 读取边界
	for i in range(size.x * 2 + 2):
		for j in range(size.y * 2 + 2):
			var coord := Vector2i(i, j)
			map_shower.paint_border(coord, _map.get_border_tile_info_at(coord).type)


func initialize_camera(map_size: Map.Size) -> void:
	var size: Vector2i = Map.SIZE_DICT[map_size]
	var tile_x: int = map_shower.get_map_tile_size().x
	var tile_y: int = map_shower.get_map_tile_size().y
	# 小心 int 溢出
	var max_x = size.x * tile_x + (tile_x / 2)
	var max_y = (size.y * tile_y * 3 + tile_y)/ 4
	camera.set_max_x(max_x)
	camera.set_min_x(0)
	camera.set_max_y(max_y)
	camera.set_min_y(0)
	# 摄像头默认居中
	camera.global_position = Vector2(max_x / 2, max_y / 2)
