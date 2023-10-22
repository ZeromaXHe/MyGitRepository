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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# 镜头放大
			get_viewport().set_input_as_handled()
			_final_zoom = clamp(_final_zoom + Vector2(0.05, 0.05), MIN_ZOOM, MAX_ZOOM)
			var tween = get_tree().create_tween()
			tween.tween_property(self, "zoom", _final_zoom, 0.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# 镜头缩小
			get_viewport().set_input_as_handled()
			_final_zoom = clamp(_final_zoom - Vector2(0.05, 0.05), MIN_ZOOM, MAX_ZOOM)
			var tween = get_tree().create_tween()
			tween.tween_property(self, "zoom", _final_zoom, 0.1)


func start_drag(start_position: Vector2):
	_previous_position = start_position
	_move_camera = true


func end_drag():
	_move_camera = false



func drag(to_position: Vector2):
	if not _move_camera:
		return
	position += _previous_position - to_position
	# 限制镜头移动范围
	var diff_x = get_viewport().size.x / zoom.x / 2
	var diff_y = get_viewport().size.y / zoom.y / 2
	# 直接对 Vector2 而不分别对 x、y 进行 clamp() 的话，貌似会 bug。
	# 因为 Vector2 的大小判断逻辑是 x 处于范围内的话，就不会处理 y 了。
	position.x = clamp(position.x, MIN_X + diff_x, MAX_X - diff_x)
	position.y = clamp(position.y, MIN_Y + diff_y, MAX_Y - diff_y)
	_previous_position = to_position


func set_max_x(x: int):
	MAX_X = x


func set_min_x(x: int):
	MIN_X = x


func set_max_y(y: int):
	MAX_Y = y


func set_min_y(y: int):
	MIN_Y = y
