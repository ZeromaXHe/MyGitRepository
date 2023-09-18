class_name MapEditor
extends Node2D


enum MapType {
	BLANK,
}


enum MapSize {
	DUAL,
}

const size_dict: Dictionary = {
	0: Vector2i(40, 20),
}

var _from_camera_position := Vector2(-1, -1)

@onready var tile_map: TileMap = $TileMap
@onready var camera: CameraManager = $Camera2D
@onready var gui: MapEditorGUI = $MapEditorGUI


func _ready() -> void:
	initialize_map(MapType.BLANK, MapSize.DUAL)
	initialize_camera(MapSize.DUAL)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_viewport().set_input_as_handled()
			if event.is_pressed():
				print("clicked mouse left button")
				# 开始拖拽镜头
				camera.start_drag(event.position)
				# 选取图块
				_from_camera_position = camera.to_local(get_global_mouse_position())
			else:
				get_viewport().set_input_as_handled()
				camera.end_drag()
				if camera.to_local(get_global_mouse_position()).distance_to(_from_camera_position) < 20:
					var map_coord = tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))
					gui.set_info_label_text("选中 (" + str(map_coord.x) + "，" + str(map_coord.y) + ")")
	elif event is InputEventMouseMotion:
		# 拖拽镜头过程中
		get_viewport().set_input_as_handled()
		camera.drag(event.position)


func initialize_map(map_type: MapType, map_size: MapSize) -> void:
	if map_type == MapType.BLANK:
		var size: Vector2i = size_dict[map_size]
		for i in range(0, size.x, 1):
			for j in range(0, size.y, 1):
				tile_map.set_cell(0, Vector2i(i, j), 2, Vector2i(0, 0))


func initialize_camera(map_size: MapSize) -> void:
	var size: Vector2i = size_dict[map_size]
	var tile_x: int = tile_map.tile_set.tile_size.x
	var tile_y: int = tile_map.tile_set.tile_size.y
	# 小心 int 溢出
	var max_x = size.x * tile_x + (tile_x / 2)
	var max_y = (size.y * tile_y * 3 + tile_y)/ 4
	camera.set_max_x(max_x)
	camera.set_min_x(0)
	camera.set_max_y(max_y)
	camera.set_min_y(0)
	# 摄像头默认居中
	camera.global_position = Vector2(max_x / 2, max_y / 2)
