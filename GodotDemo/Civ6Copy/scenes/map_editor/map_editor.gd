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
# 地块类型到 TileSet 信息映射
var _terrain_type_to_tile_dict : Dictionary = {
	MapEditorGUI.TerrainType.GRASS: MapTileCell.new(0, Vector2i(5, 1)),
	MapEditorGUI.TerrainType.GRASS_HILL: MapTileCell.new(0, Vector2i(4, 4)),
	MapEditorGUI.TerrainType.GRASS_MOUNTAIN: MapTileCell.new(0, Vector2i(4, 6)),
	MapEditorGUI.TerrainType.PLAIN: MapTileCell.new(0, Vector2i(6, 5)),
	MapEditorGUI.TerrainType.PLAIN_HILL: MapTileCell.new(0, Vector2i(5, 8)),
	MapEditorGUI.TerrainType.PLAIN_MOUNTAIN: MapTileCell.new(0, Vector2i(5, 7)),
	MapEditorGUI.TerrainType.DESERT: MapTileCell.new(0, Vector2i(2, 3)),
	MapEditorGUI.TerrainType.DESERT_HILL: MapTileCell.new(0, Vector2i(1, 6)),
	MapEditorGUI.TerrainType.DESERT_MOUNTAIN: MapTileCell.new(0, Vector2i(1, 8)),
	MapEditorGUI.TerrainType.TUNDRA: MapTileCell.new(0, Vector2i(0, 12)),
	MapEditorGUI.TerrainType.TUNDRA_HILL: MapTileCell.new(0, Vector2i(0, 5)),
	MapEditorGUI.TerrainType.TUNDRA_MOUNTAIN: MapTileCell.new(0, Vector2i(10, 5)),
	MapEditorGUI.TerrainType.SNOW: MapTileCell.new(3, Vector2i(1, 2)),
	MapEditorGUI.TerrainType.SNOW_HILL: MapTileCell.new(3, Vector2i(2, 1)),
	MapEditorGUI.TerrainType.SNOW_MOUNTAIN: MapTileCell.new(3, Vector2i(2, 2)),
	MapEditorGUI.TerrainType.SHORE: MapTileCell.new(1, Vector2i(0, 0)),
	MapEditorGUI.TerrainType.OCEAN: MapTileCell.new(2, Vector2i(0, 0)),
}
var _map_size: MapSize
var _map_type: MapType
# 记录地图图块数据
var _map_tile_info: Array = []
# 恢复和取消，记录操作的栈
var _before_step_stack: Array[PaintStep] = []
var _after_step_stack: Array[PaintStep] = []

@onready var tile_map: TileMap = $TileMap
@onready var camera: CameraManager = $Camera2D
@onready var gui: MapEditorGUI = $MapEditorGUI


func _ready() -> void:
	_map_size = MapSize.DUAL
	_map_type = MapType.BLANK
	initialize_map(MapType.BLANK, MapSize.DUAL)
	initialize_camera(MapSize.DUAL)
	gui.restore_btn_pressed.connect(handle_restore)
	gui.cancel_btn_pressed.connect(handle_cancel)


func _process(delta: float) -> void:
	var map_coord: Vector2i = tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))
	paint_new_green_chosen_area(map_coord)


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


func handle_restore() -> void:
	if _after_step_stack.is_empty():
		printerr("之后操作为空，异常！")
		return
	var step: PaintStep = _after_step_stack.pop_back()
	if _after_step_stack.is_empty():
		gui.set_restore_button_disable(true)
	for change in step.changed_arr:
		# 恢复 TileMap 到操作后的状态
		var cell_info: MapTileCell = _terrain_type_to_tile_dict[change.after.type]
		tile_map.set_cell(0, change.coord, cell_info.source_id, cell_info.atlas_coords)
		# 恢复地图地块信息
		_map_tile_info[change.coord.x][change.coord.y] = change.after
	# 把操作存到之前的取消栈中
	_before_step_stack.push_back(step)
	gui.set_cancel_button_disable(false)


func handle_cancel() -> void:
	if _before_step_stack.is_empty():
		printerr("历史操作为空，异常！")
		return
	var step: PaintStep = _before_step_stack.pop_back()
	if _before_step_stack.is_empty():
		gui.set_cancel_button_disable(true)
	for change in step.changed_arr:
		# 还原 TileMap 到操作前的状态
		var cell_info: MapTileCell = _terrain_type_to_tile_dict[change.before.type]
		tile_map.set_cell(0, change.coord, cell_info.source_id, cell_info.atlas_coords)
		# 还原地图地块信息
		_map_tile_info[change.coord.x][change.coord.y] = change.before
	# 把操作存到之后的恢复栈中
	_after_step_stack.push_back(step)
	gui.set_restore_button_disable(false)


func paint_new_green_chosen_area(map_coord: Vector2i, renew: bool = false) -> void:
	# 只在放置模式下绘制鼠标悬浮地块
	if gui.get_rt_tab_status() != MapEditorGUI.TabStatus.PLACE:
		return
	if not renew and map_coord == _mouse_hover_tile_coord:
		return
	# 按最大笔刷的范围擦除原来图块
	var old_inside: Array[Vector2i] = get_surrounding_cells(_mouse_hover_tile_coord, 2, true)
	for coord in old_inside:
		# 擦除原图块
		tile_map.set_cell(1, coord)
	
	var dist: int = gui.get_painter_size_dist()
	var new_inside: Array[Vector2i] = get_surrounding_cells(map_coord, dist, true)
	for coord in new_inside:
		# 新增新图块
		tile_map.set_cell(1, coord,
				tile_map.get_cell_source_id(0, coord),
				tile_map.get_cell_atlas_coords(0, coord))
	
	_mouse_hover_tile_coord = map_coord


func paint_map(map_coord: Vector2i) -> void:
	if gui.place_mode != MapEditorGUI.PlaceMode.TERRAIN:
		return
	if not _terrain_type_to_tile_dict.has(gui.terrain_type):
		printerr("can't paint unknown tile!")
		return
	var dist: int = gui.get_painter_size_dist()
	# 地图大小
	var size: Vector2i = size_dict[_map_size]
	var inside: Array[Vector2i] = get_surrounding_cells(map_coord, dist, true)
	var step: PaintStep = PaintStep.new()
	for coord in inside:
		# 超出地图范围的不处理
		if coord.x < 0 or coord.x >= size.x or coord.y < 0 or coord.y >= size.y:
			continue
		paint_tile(coord, step, gui.terrain_type)
	# 围绕陆地地块绘制浅海
	if gui.terrain_type != MapEditorGUI.TerrainType.SHORE and gui.terrain_type != MapEditorGUI.TerrainType.OCEAN:
		var out_ring: Array[Vector2i] = get_surrounding_cells(map_coord, dist + 1, false)
		for coord in out_ring:
			# 超出地图范围的不处理
			if coord.x < 0 or coord.x >= size.x or coord.y < 0 or coord.y >= size.y:
				continue
			# 仅深海需要改为浅海
			if tile_map.get_cell_source_id(0, coord) != 2:
				continue
			paint_tile(coord, step, MapEditorGUI.TerrainType.SHORE)
	
	_before_step_stack.push_back(step)
	# 最多只记录 30 个历史操作
	if _before_step_stack.size() > 30:
		_before_step_stack.pop_front()
	gui.set_cancel_button_disable(false)
	# 每次操作后也就意味着不能向后恢复了
	_after_step_stack.clear()
	gui.set_restore_button_disable(true)
	
	# 强制重绘选择区域
	paint_new_green_chosen_area(map_coord, true)


func paint_tile(coord: Vector2i, step: PaintStep, terrain_type: MapEditorGUI.TerrainType):
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = coord
	change.before = _map_tile_info[coord.x][coord.y]
	change.after = TileInfo.new(terrain_type)
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map_tile_info[coord.x][coord.y] = change.after
	# 真正绘制 TileMap 地块
	var cell_info: MapTileCell = _terrain_type_to_tile_dict[terrain_type]
	tile_map.set_cell(0, coord, cell_info.source_id, cell_info.atlas_coords)


## TODO: 目前基于 TileMap 既有 API 实现的，所以效率比较低，未来可以自己实现这个逻辑
func get_surrounding_cells(map_coord: Vector2i, dist: int, include_inside: bool) -> Array[Vector2i]:
	if dist < 0:
		return []
	# 从坐标到是否边缘的布尔值的映射
	var dict: Dictionary = {map_coord: true}
	for i in range(0, dist):
		var dup_dict: Dictionary = dict.duplicate()
		for k in dup_dict:
			if not dict[k]:
				continue
			var surroundings: Array[Vector2i] = tile_map.get_surrounding_cells(k)
			for surround in surroundings:
				if dict.has(surround):
					continue
				dict[surround] = true
			dict[k] = false
	var result: Array[Vector2i] = []
	for k in dict:
		if not include_inside and not dict[k]:
			continue
		result.append(k)
	return result


func initialize_map(map_type: MapType, map_size: MapSize) -> void:
	if map_type == MapType.BLANK:
		# 修改 TileMap 图块
		var size: Vector2i = size_dict[map_size]
		var ocean_cell: MapTileCell = _terrain_type_to_tile_dict[MapEditorGUI.TerrainType.OCEAN]
		for i in range(0, size.x, 1):
			for j in range(0, size.y, 1):
				tile_map.set_cell(0, Vector2i(i, j), ocean_cell.source_id, ocean_cell.atlas_coords)
		# 记录地图地块信息
		for i in range(size.x):
			_map_tile_info.append([])
			for j in range(size.y):
				_map_tile_info[i].append(TileInfo.new(MapEditorGUI.TerrainType.OCEAN))


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


class MapTileCell:
	var source_id: int = -1
	var atlas_coords: Vector2i = Vector2i(-1, -1)
	
	func _init(source_id: int, atlas_coords: Vector2i) -> void:
		self.source_id = source_id
		self.atlas_coords = atlas_coords


class PaintStep:
	var changed_arr: Array[PaintChange] = []


class PaintChange:
	var coord: Vector2i
	var before: TileInfo
	var after: TileInfo


class TileInfo:
	var type: MapEditorGUI.TerrainType = MapEditorGUI.TerrainType.OCEAN
	
	func _init(type: MapEditorGUI.TerrainType) -> void:
		self.type = type
