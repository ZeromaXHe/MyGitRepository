class_name MapEditor
extends Node2D


# 地图类型
enum MapType {
	BLANK, # 空白地图
}

# 地图尺寸
enum MapSize {
	DUAL, # 决斗
}

# 地图尺寸和格子数的映射字典
const size_dict: Dictionary = {
	0: Vector2i(44, 26),
}

# 左键点击开始时相对镜头的本地坐标
var _from_camera_position := Vector2(-1, -1)
# 鼠标悬浮的图块坐标
var _mouse_hover_tile_coord := Vector2i(-1, -1)
var _map_size: MapSize
var _map_type: MapType

@onready var tile_map: TileMap = $TileMap
@onready var camera: CameraManager = $Camera2D
@onready var gui: MapEditorGUI = $MapEditorGUI


func _ready() -> void:
	_map_size = MapSize.DUAL
	_map_type = MapType.BLANK
	initialize_map(MapType.BLANK, MapSize.DUAL)
	initialize_camera(MapSize.DUAL)


func _process(delta: float) -> void:
	var map_coord: Vector2i = tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))
	paint_new_green_chosen_area(map_coord)
	

func paint_new_green_chosen_area(map_coord: Vector2i) -> void:
	# 只在放置模式下绘制鼠标悬浮地块
	if gui.get_rt_tab_status() != MapEditorGUI.TabStatus.PLACE:
		return
	if map_coord == _mouse_hover_tile_coord:
		return
	if gui.painter_size == MapEditorGUI.PainterSize.SMALL:
		# 擦除原图块
		tile_map.set_cell(1, _mouse_hover_tile_coord)
		# 新增新图块
		tile_map.set_cell(1, map_coord,
				tile_map.get_cell_source_id(0, map_coord),
				tile_map.get_cell_atlas_coords(0, map_coord))
		_mouse_hover_tile_coord = map_coord

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
				get_viewport().set_input_as_handled()
				camera.end_drag()
				if camera.to_local(get_global_mouse_position()).distance_to(_from_camera_position) < 20:
					var map_coord: Vector2i = tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))
					gui.set_info_label_text("选中 (" + str(map_coord.x) + "，" + str(map_coord.y) + ")")
					paint_map(map_coord)
	elif event is InputEventMouseMotion:
		# 拖拽镜头过程中
		get_viewport().set_input_as_handled()
		camera.drag(event.position)


func paint_map(map_coord: Vector2i) -> void:
	if gui.place_mode != MapEditorGUI.PlaceMode.TERRAIN \
			or gui.terrain_type != MapEditorGUI.TerrainType.GRASS \
			or gui.painter_size != MapEditorGUI.PainterSize.SMALL:
		return
	# 绘制草原
	tile_map.set_cell(0, map_coord, 0, Vector2i(5, 1))
	var surroundings: Array[Vector2i] = tile_map.get_surrounding_cells(map_coord)
	var size: Vector2i = size_dict[_map_size]
	for coord in surroundings:
		# 超出地图范围的不处理
		if coord.x < 0 and coord.x >= size.x and coord.y < 0 and coord.y >= size.y:
			continue
		# 仅深海需要改为浅海
		if tile_map.get_cell_source_id(0, coord) != 2:
			continue
		# 绘制浅海海岸
		tile_map.set_cell(0, coord, 1, Vector2i(0, 0))


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
