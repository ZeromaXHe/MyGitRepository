extends Camera2D


@export var MIN_ZOOM := Vector2(0.5, 0.5)
@export var MAX_ZOOM := Vector2(2, 2)

var _previous_position := Vector2(0, 0)
var _move_camera: bool = false
var _final_zoom: Vector2 = zoom


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# 开始拖拽镜头
			get_viewport().set_input_as_handled()
			if event.is_pressed():
				_previous_position = event.position
				_move_camera = true
			else:
				_move_camera = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
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
	elif event is InputEventMouseMotion && _move_camera:
		# 拖拽镜头过程中
		get_viewport().set_input_as_handled()
		position += (_previous_position - event.position)
		# 限制镜头移动范围
		var diff_x = get_viewport().size.x / zoom.x / 2
		var diff_y = get_viewport().size.y / zoom.y / 2
		# 直接对 Vector2 而不分别对 x、y 进行 clamp() 的话，貌似会 bug。
		# 因为 Vector2 的大小判断逻辑是 x 处于范围内的话，就不会处理 y 了。
		position.x = clamp(position.x, -1500 + diff_x, 1500 - diff_x)
		position.y = clamp(position.y, -500 + diff_y, 500 - diff_y)
		_previous_position = event.position

