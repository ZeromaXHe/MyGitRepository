extends Camera2D


var _previous_position: Vector2 = Vector2(0, 0)
var _move_camera: bool = false


func _unhandled_input(event: InputEvent) -> void:
	# 拖拽镜头的实现
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		if event.is_pressed():
			_previous_position = event.position
			_move_camera = true
		else:
			_move_camera = false
	elif event is InputEventMouseMotion && _move_camera:
		get_viewport().set_input_as_handled()
		position += (_previous_position - event.position)
		# 限制镜头移动范围
		var diff_x = zoom.x * get_viewport().size.x / 2
		var diff_y = zoom.y * get_viewport().size.y / 2
		position.x = clamp(position.x, -1500 + diff_x, 1500 - diff_x)
		position.y = clamp(position.y, -500 + diff_y, 500 - diff_y)
		_previous_position = event.position

