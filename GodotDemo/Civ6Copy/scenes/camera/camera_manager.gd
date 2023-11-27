class_name CameraManager
extends Camera2D


@export var MIN_ZOOM := Vector2(0.3, 0.3)
@export var MAX_ZOOM := Vector2(1.5, 1.5)
@export var MAX_X: int = 1500
@export var MIN_X: int = -1500
@export var MAX_Y: int = 500
@export var MIN_Y: int = -500

var _previous_position := Vector2(0, 0)
var _move_camera: bool = false
var _final_zoom: Vector2 = zoom

@onready var minimap_transform: RemoteTransform2D = $MinimapTransform2D


func _ready() -> void:
	zoom = Vector2(0.8, 0.8)
	scale = Vector2.ONE / zoom
	
	initialize(MapController.get_map_tile_size_vec(), ViewHolder.get_map_shower().get_map_tile_xy())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				# 开始拖拽镜头
				start_drag(event.position)
			else:
				end_drag()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# 镜头放大
			get_viewport().set_input_as_handled()
			_final_zoom = clamp(_final_zoom + Vector2(0.05, 0.05), MIN_ZOOM, MAX_ZOOM)
			var tween = get_tree().create_tween()
			tween.tween_property(self, "zoom", _final_zoom, 0.1)
			tween.tween_property(self, "scale", Vector2.ONE / _final_zoom, 0.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# 镜头缩小
			get_viewport().set_input_as_handled()
			_final_zoom = clamp(_final_zoom - Vector2(0.05, 0.05), MIN_ZOOM, MAX_ZOOM)
			var tween = get_tree().create_tween()
			tween.tween_property(self, "zoom", _final_zoom, 0.1)
			tween.tween_property(self, "scale", Vector2.ONE / _final_zoom, 0.1)
	elif event is InputEventMouseMotion:
		# 拖拽镜头过程中
#		get_viewport().set_input_as_handled()
		drag(event.position)


func initialize(map_size: Vector2i, tile_xy: Vector2i) -> void:
	var tile_x: int = tile_xy.x
	var tile_y: int = tile_xy.y
	# 小心 int 溢出
	var max_x = map_size.x * tile_x + (tile_x / 2)
	var max_y = (map_size.y * tile_y * 3 + tile_y)/ 4
	set_max_x(max_x)
	set_min_x(0)
	set_max_y(max_y)
	set_min_y(0)
	# 摄像头默认居中
	global_position = Vector2(max_x / 2, max_y / 2)


func set_minimap_transform_path(node_path: NodePath) -> void:
	minimap_transform.remote_path = node_path


func start_drag(start_position: Vector2):
	_previous_position = start_position
	_move_camera = true


func end_drag():
	_move_camera = false



func drag(to_position: Vector2):
	if not _move_camera:
		return
	global_position += (_previous_position - to_position) / zoom.x
	# 限制镜头移动范围
	var diff_x = get_viewport().size.x / zoom.x / 2
	var diff_y = get_viewport().size.y / zoom.y / 2
	# 直接对 Vector2 而不分别对 x、y 进行 clamp() 的话，貌似会 bug。
	# 因为 Vector2 的大小判断逻辑是 x 处于范围内的话，就不会处理 y 了。
	global_position.x = clamp(global_position.x, MIN_X + diff_x, MAX_X - diff_x)
	global_position.y = clamp(global_position.y, MIN_Y + diff_y, MAX_Y - diff_y)
	_previous_position = to_position


func set_max_x(x: int):
	MAX_X = x


func set_min_x(x: int):
	MIN_X = x


func set_max_y(y: int):
	MAX_Y = y


func set_min_y(y: int):
	MIN_Y = y
