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

enum BorderDirection {
	LEFT_TOP,
	RIGHT_TOP,
	LEFT,
	CENTER,
	RIGHT,
	LEFT_DOWN,
	RIGHT_DOWN,
}

enum BorderType {
	SLASH,
	BACK_SLASH,
	CENTER,
	VERTICAL,
}

enum BorderTileType {
	EMPTY,
	RIVER,
	CLIFF,
}

# 地图尺寸和格子数的映射字典
const size_dict: Dictionary = {
	0: Vector2i(44, 26),
}

const NULL_COORD := Vector2i(-10000, -10000)

# 左键点击开始时相对镜头的本地坐标
var _from_camera_position := Vector2(-1, -1)
# 鼠标悬浮的图块坐标
var _mouse_hover_tile_coord := NULL_COORD
# 鼠标悬浮的边界坐标
var _mouse_hover_border_coord := NULL_COORD
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
var _border_tile_info: Array = []
# 恢复和取消，记录操作的栈
var _before_step_stack: Array[PaintStep] = []
var _after_step_stack: Array[PaintStep] = []

@onready var border_tile_map: TileMap = $BorderTileMap
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
	
#	test_get_border_type()
#	print("-------------")
#	test_get_tile_coord_directed_border()


func _process(delta: float) -> void:
	paint_new_green_chosen_area()


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
				if camera.to_local(get_global_mouse_position()).distance_to(_from_camera_position) < 20:
					paint_map()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_released():
				get_viewport().set_input_as_handled()
				depaint_map()
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
		if change.tile_change:
			# 恢复 TileMap 到操作后的状态
			var cell_info: MapTileCell = _terrain_type_to_tile_dict[change.after.type]
			tile_map.set_cell(0, change.coord, cell_info.source_id, cell_info.atlas_coords)
			# 恢复地图地块信息
			_map_tile_info[change.coord.x][change.coord.y] = change.after
		else:
			# 恢复 BorderTileMap 到操作后的状态
			match change.after_border.type:
				BorderTileType.EMPTY:
					border_tile_map.set_cell(0, change.coord, -1)
				BorderTileType.RIVER:
					paint_river(change.coord)
				BorderTileType.CLIFF:
					paint_cliff(change.coord)
			# 恢复地图地块信息
			_border_tile_info[change.coord.x][change.coord.y] = change.after_border
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
		if change.tile_change:
			# 还原 TileMap 到操作前的状态
			var cell_info: MapTileCell = _terrain_type_to_tile_dict[change.before.type]
			tile_map.set_cell(0, change.coord, cell_info.source_id, cell_info.atlas_coords)
			# 还原地图地块信息
			_map_tile_info[change.coord.x][change.coord.y] = change.before
		else:
			# 恢复 BorderTileMap 到操作前的状态
			match change.before_border.type:
				BorderTileType.EMPTY:
					border_tile_map.set_cell(0, change.coord, -1)
				BorderTileType.RIVER:
					paint_river(change.coord)
				BorderTileType.CLIFF:
					paint_cliff(change.coord)
			# 恢复地图地块信息
			_border_tile_info[change.coord.x][change.coord.y] = change.before_border
	# 把操作存到之后的恢复栈中
	_after_step_stack.push_back(step)
	gui.set_restore_button_disable(false)


func get_border_coord() -> Vector2i:
	return border_tile_map.local_to_map(border_tile_map.to_local(get_global_mouse_position()))


func get_map_coord() -> Vector2i:
	return tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))


func paint_new_green_chosen_area(renew: bool = false) -> void:
	var map_coord: Vector2i = get_map_coord()
	var border_coord: Vector2i = get_border_coord()
	# 只在放置模式下绘制鼠标悬浮地块
	if gui.get_rt_tab_status() != MapEditorGUI.TabStatus.PLACE:
		return
	if not renew and (map_coord == _mouse_hover_tile_coord or border_coord == _mouse_hover_border_coord):
		return
	# 按最大笔刷的范围擦除原来图块
	if _mouse_hover_tile_coord != NULL_COORD:
		var old_inside: Array[Vector2i] = get_surrounding_cells(_mouse_hover_tile_coord, 2, true)
		for coord in old_inside:
			# 擦除原图块
			tile_map.set_cell(1, coord)
	# 清理之前的边界图块
	if _mouse_hover_border_coord != NULL_COORD:
		border_tile_map.set_cell(1, _mouse_hover_border_coord)
	
	if gui.place_mode == MapEditorGUI.PlaceMode.RIVER:
		if is_in_map_border(border_coord) <= 0:
			return
		match get_border_type(border_coord):
			BorderType.VERTICAL:
				if is_river_placable(border_coord):
					border_tile_map.set_cell(1, border_coord, 8, Vector2i(0, 0))
				else:
					border_tile_map.set_cell(1, border_coord, 11, Vector2i(0, 0))
			BorderType.SLASH:
				if is_river_placable(border_coord):
					border_tile_map.set_cell(1, border_coord, 7, Vector2i(0, 0))
				else:
					border_tile_map.set_cell(1, border_coord, 10, Vector2i(0, 0))
			BorderType.BACK_SLASH:
				if is_river_placable(border_coord):
					border_tile_map.set_cell(1, border_coord, 6, Vector2i(0, 0))
				else:
					border_tile_map.set_cell(1, border_coord, 9, Vector2i(0, 0))
		
		_mouse_hover_border_coord = border_coord
		_mouse_hover_tile_coord = NULL_COORD
	elif gui.place_mode == MapEditorGUI.PlaceMode.CLIFF:
		if is_in_map_border(border_coord) <= 0:
			return
		match get_border_type(border_coord):
			BorderType.VERTICAL:
				if is_cliff_placable(border_coord):
					border_tile_map.set_cell(1, border_coord, 8, Vector2i(0, 0))
				else:
					border_tile_map.set_cell(1, border_coord, 11, Vector2i(0, 0))
			BorderType.SLASH:
				if is_cliff_placable(border_coord):
					border_tile_map.set_cell(1, border_coord, 7, Vector2i(0, 0))
				else:
					border_tile_map.set_cell(1, border_coord, 10, Vector2i(0, 0))
			BorderType.BACK_SLASH:
				if is_cliff_placable(border_coord):
					border_tile_map.set_cell(1, border_coord, 6, Vector2i(0, 0))
				else:
					border_tile_map.set_cell(1, border_coord, 9, Vector2i(0, 0))
		
		_mouse_hover_border_coord = border_coord
		_mouse_hover_tile_coord = NULL_COORD
	else:
		var dist: int = gui.get_painter_size_dist()
		var new_inside: Array[Vector2i] = get_surrounding_cells(map_coord, dist, true)
		for coord in new_inside:
			# 新增新图块
			tile_map.set_cell(1, coord, 4, Vector2i(0, 0))
		
		_mouse_hover_tile_coord = map_coord
		_mouse_hover_border_coord = NULL_COORD


func is_in_map_border(border_coord: Vector2i) -> int:
	var neighbor_tile_coords: Array[Vector2i] = get_neighbor_tile_of_border(border_coord)
	var count_empty: int = 0
	var count_exist: int = 0
	for coord in neighbor_tile_coords:
		var src_id: int = tile_map.get_cell_source_id(0, coord)
		if src_id == -1:
			# 地图外为空图块
			count_empty += 1
		else:
			count_exist += 1
	if count_exist > 0:
		if count_empty == 0 and count_exist <= 2:
			# 表示在地图里
			return 1
		elif count_empty == 1 and count_exist == 1:
			# 表示在地图边界上
			return 0
		else:
			# 莫名其妙的情况
			return -999
	elif count_exist == 0 and count_empty <= 2:
		# 地图外
		return -1
	else:
		return -999


func is_river_placable(border_coord: Vector2i) -> bool:
	if is_in_map_border(border_coord) <= 0 or get_border_type(border_coord) == BorderType.CENTER:
		return false
	var neighbor_tile_coords: Array[Vector2i] = get_neighbor_tile_of_border(border_coord)
	for coord in neighbor_tile_coords:
		var src_id: int = tile_map.get_cell_source_id(0, coord)
		if src_id == 1 || src_id == 2:
			# 和浅海或者深海相邻
			return false
	var end_tile_coords: Array[Vector2i] = get_end_tile_of_border(border_coord)
	for coord in end_tile_coords:
		var src_id: int = tile_map.get_cell_source_id(0, coord)
		if src_id == 1 || src_id == 2:
			# 末端是浅海或者深海
			return true
	var connect_border_coords: Array[Vector2i] = get_connect_border_of_border(border_coord)
	for coord in connect_border_coords:
		var src_id: int = border_tile_map.get_cell_source_id(0, coord)
		if src_id >= 3 and src_id <= 5:
			# 连接的边界有河流
			return true
	return false


func is_cliff_placable(border_coord: Vector2i) -> bool:
	if is_in_map_border(border_coord) <= 0 or get_border_type(border_coord) == BorderType.CENTER:
		return false
	var neighbor_tile_coords: Array[Vector2i] = get_neighbor_tile_of_border(border_coord)
	var neighbor_sea: bool = false
	var neighbor_land: bool = false
	for coord in neighbor_tile_coords:
		var src_id: int = tile_map.get_cell_source_id(0, coord)
		if src_id == 1 || src_id == 2:
			# 和浅海或者深海相邻
			neighbor_sea = true
		else:
			neighbor_land = true
	return neighbor_land and neighbor_sea


func depaint_map() -> void:
	var step: PaintStep = PaintStep.new()
	if gui.place_mode == MapEditorGUI.PlaceMode.CLIFF or gui.place_mode == MapEditorGUI.PlaceMode.RIVER:
		var border_coord: Vector2i = get_border_coord()
		if gui.place_mode == MapEditorGUI.PlaceMode.CLIFF \
				and _border_tile_info[border_coord.x][border_coord.y].type != BorderTileType.CLIFF:
			return
		if gui.place_mode == MapEditorGUI.PlaceMode.RIVER \
				and _border_tile_info[border_coord.x][border_coord.y].type != BorderTileType.RIVER:
			return
		paint_border(border_coord, step, BorderTileType.EMPTY)
		
		# 强制重绘选择区域
		paint_new_green_chosen_area(true)
	
	save_paint_step(step)


func paint_map() -> void:
	var step: PaintStep = PaintStep.new()
	if gui.place_mode == MapEditorGUI.PlaceMode.TERRAIN:
		var map_coord: Vector2i = get_map_coord()
		if not _terrain_type_to_tile_dict.has(gui.terrain_type):
			printerr("can't paint unknown tile!")
			return
		var dist: int = gui.get_painter_size_dist()
		# 地图大小
		var size: Vector2i = size_dict[_map_size]
		var inside: Array[Vector2i] = get_surrounding_cells(map_coord, dist, true)
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
		
		# 强制重绘选择区域
		paint_new_green_chosen_area(true)
	elif gui.place_mode == MapEditorGUI.PlaceMode.CLIFF:
		var border_coord: Vector2i = get_border_coord()
		if not is_cliff_placable(border_coord):
			return
		# 绘制边界悬崖
		paint_border(border_coord, step, BorderTileType.CLIFF)
		
		# 强制重绘选择区域
		paint_new_green_chosen_area(true)
	elif gui.place_mode == MapEditorGUI.PlaceMode.RIVER:
		var border_coord: Vector2i = get_border_coord()
		if not is_river_placable(border_coord):
			return
		# 绘制边界河流
		paint_border(border_coord, step, BorderTileType.RIVER)
		
		# 强制重绘选择区域
		paint_new_green_chosen_area(true)
	
	save_paint_step(step)


func save_paint_step(step: PaintStep) -> void:
	if step.changed_arr.size() > 0:
		_before_step_stack.push_back(step)
		# 最多只记录 30 个历史操作
		if _before_step_stack.size() > 30:
			_before_step_stack.pop_front()
		gui.set_cancel_button_disable(false)
		# 每次操作后也就意味着不能向后恢复了
		_after_step_stack.clear()
		gui.set_restore_button_disable(true)


func paint_border(border_coord: Vector2i, step: PaintStep, type :BorderTileType) -> void:
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = border_coord
	change.tile_change = false
	change.before_border = _border_tile_info[border_coord.x][border_coord.y]
	change.after_border = BorderInfo.new(type)
	step.changed_arr.append(change)
	# 记录地图地块信息
	_border_tile_info[border_coord.x][border_coord.y] = change.after_border
	# 真正绘制边界
	match type:
		BorderTileType.RIVER:
			paint_river(border_coord)
		BorderTileType.CLIFF:
			paint_cliff(border_coord)
		BorderTileType.EMPTY:
			# 真正绘制边界为空
			border_tile_map.set_cell(0, border_coord, -1)


func paint_cliff(border_coord: Vector2i) -> void:
	match get_border_type(border_coord):
		BorderType.BACK_SLASH:
			border_tile_map.set_cell(0, border_coord, 0, Vector2i.ZERO)
		BorderType.SLASH:
			border_tile_map.set_cell(0, border_coord, 1, Vector2i.ZERO)
		BorderType.VERTICAL:
			border_tile_map.set_cell(0, border_coord, 2, Vector2i.ZERO)


func paint_river(border_coord: Vector2i) -> void:
	match get_border_type(border_coord):
		BorderType.BACK_SLASH:
			border_tile_map.set_cell(0, border_coord, 3, Vector2i.ZERO)
		BorderType.SLASH:
			border_tile_map.set_cell(0, border_coord, 4, Vector2i.ZERO)
		BorderType.VERTICAL:
			border_tile_map.set_cell(0, border_coord, 5, Vector2i.ZERO)


func paint_tile(coord: Vector2i, step: PaintStep, terrain_type: MapEditorGUI.TerrainType):
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = coord
	change.tile_change = true
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
		# 记录边界地块信息
		for i in range(size.x * 2 + 2):
			_border_tile_info.append([])
			for j in range(size.y * 2 + 2):
				_border_tile_info[i].append(BorderInfo.new(BorderTileType.EMPTY))


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


##
# 六边形	左上角	右上角	左		中		右		左下角	右下角
# (0,0)	(0,0)	(1,0)	(-1,1)	(0,1)	(1,1)	(0,2)	(1,2)
# (0,1)	(1,2)	(2,2)	(0,3)	(1,3)	(2,3)	(1,4)	(2,4)
# (1,0)	(2,0)	(3,0)	(1,1)	(2,1)	(3,1)	(2,2)	(3,2)
# (1,1)	(3,2)	(4,2)	(2,3)	(3,3)	(4,3)	(3,4)	(4,4)
# (0,2)	(0,4)	(1,4)	(-1,5)	(0,5)	(1,5)	(0,6)	(1,6)
##
func get_border_type(border_coord: Vector2i) -> BorderType:
	if border_coord.y % 2 == 0:
		if border_coord.x % 2 == border_coord.y / 2 % 2:
			return BorderType.SLASH
		else:
			return BorderType.BACK_SLASH
	elif border_coord.x % 2 == border_coord.y / 2 % 2:
		return BorderType.CENTER
	else:
		return BorderType.VERTICAL


# 测试 getBorderType() 方法
func test_get_border_type() -> void:
	print("slash ", Vector2i(0, 0), " is ", get_border_type(Vector2i(0, 0)))
	print("slash ", Vector2i(1, 2), " is ", get_border_type(Vector2i(1, 2)))
	print("back slash ", Vector2i(1, 0), " is ", get_border_type(Vector2i(1, 0)))
	print("back slash ", Vector2i(2, 2), " is ", get_border_type(Vector2i(2, 2)))
	print("center ", Vector2i(0, 1), " is ", get_border_type(Vector2i(0, 1)))
	print("center ", Vector2i(1, 3), " is ", get_border_type(Vector2i(1, 3)))
	print("vertical ", Vector2i(-1, 1), " is ", get_border_type(Vector2i(-1, 1)))
	print("vertical ", Vector2i(1, 1), " is ", get_border_type(Vector2i(1, 1)))
	print("vertical ", Vector2i(0, 3), " is ", get_border_type(Vector2i(0, 3)))
	print("vertical ", Vector2i(2, 3), " is ", get_border_type(Vector2i(2, 3)))


##
# 	边界		相邻地块
#	back_slash
#	(6,2)	(3,0), (2,1)
#	(4,2)	(2,0), (1,1)
#	(3,4)	(1,1), (1,2)
#	(5,4)	(2,1), (2,2)
#	slash
#	(1,2)	(0,0), (0,1)
#	(3,2)	(1,0), (1,1)
#	(2,4)	(0,1), (1,2)
#	(4,4)	(1,1), (2,2)
#	vertical
#	(1,1)	(0,0), (1,0)
#	(3,1)	(1,0), (2,0)
#	(2,3)	(0,1), (1,1)
#	(4,3)	(1,1), (2,1)
#	(1,5)	(0,2), (1,2)
##
func get_neighbor_tile_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		BorderType.CENTER:
			return [border_coord / 2]
		BorderType.VERTICAL:
			# 不能简写成 (border_corder.x - 1) / 2 否则负数有 bug
			return [Vector2i((border_coord.x + 1)/ 2 - 1, border_coord.y / 2),
					Vector2i(border_coord.x / 2 + border_coord.x % 2, border_coord.y / 2)]
		BorderType.SLASH:
			return [Vector2i((border_coord.x + 1)/ 2 - 1, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2, border_coord.y / 2)]
		BorderType.BACK_SLASH:
			return [Vector2i(border_coord.x / 2, border_coord.y / 2 - 1),
					Vector2i((border_coord.x + 1) / 2 - 1, border_coord.y / 2)]
		_:
			printerr("get_neighbor_tile_of_border | unknown border type")
			return []


##
#	边界		相邻边界
#	vertical
#	(1,1)	(1,0),(2,0),(1,2),(2,2)
#	(3,1)	(3,0),(4,0),(3,2),(4,2)
#	(0,3)	(0,2),(1,2),(0,4),(1,4)
#	(2,3)	(2,2),(3,2),(2,4),(3,4)
#	slash
#	(1,2)	(1,1),(2,2),(0,2),(0,3)
#	(3,2)	(3,1),(4,2),(2,2),(2,3)
#	(2,4)	(2,3),(3,4),(1,4),(1,5)
#	(4,4)	(4,3),(5,4),(3,4),(3,5)
#	back_slash:
#	(2,2)	(1,1),(1,2),(3,2),(2,3)
#	(4,2)	(3,1),(3,2),(5,2),(4,3)
#	(1,4)	(0,3),(0,4),(2,4),(1,5)
#	(3,4)	(2,3),(2,4),(4,4),(3,5)
##
func get_connect_border_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		BorderType.CENTER:
			return get_all_tile_border(border_coord / 2, false)
		BorderType.VERTICAL:
			return [Vector2i(border_coord.x, border_coord.y - 1),
					Vector2i(border_coord.x + 1, border_coord.y - 1),
					Vector2i(border_coord.x, border_coord.y + 1),
					Vector2i(border_coord.x + 1, border_coord.y + 1)]
		BorderType.SLASH:
			return [Vector2i(border_coord.x, border_coord.y - 1),
					Vector2i(border_coord.x + 1, border_coord.y),
					Vector2i(border_coord.x - 1, border_coord.y),
					Vector2i(border_coord.x - 1, border_coord.y + 1)]
		BorderType.BACK_SLASH:
			return [Vector2i(border_coord.x - 1, border_coord.y - 1),
					Vector2i(border_coord.x - 1, border_coord.y),
					Vector2i(border_coord.x + 1, border_coord.y),
					Vector2i(border_coord.x, border_coord.y + 1)]
		_:
			printerr("get_connect_border_of_border | unknown border type")
			return []


##
# 	边界		末端地块
#	back_slash
#	(6,2)	(2,0), (3,1)
#	(4,2)	(1,0), (2,1)
#	(3,4)	(0,1), (2,2)
#	(5,4)	(1,1), (3,2)
#	slash
#	(1,2)	(1,0), (-1,1)
#	(3,2)	(2,0), (0,1)
#	(2,4)	(1,1), (0,2)
#	(4,4)	(2,1), (1,2)
#	vertical
#	(1,1)	(0,-1), (0,1)
#	(3,1)	(1,-1), (1,1)
#	(2,3)	(1,0), (1,2)
#	(4,3)	(2,0), (2,2)
#	(1,5)	(0,1), (0,3)
#	(3,5)	(1,1), (1,3)
##
func get_end_tile_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		BorderType.VERTICAL:
			return [Vector2i(border_coord.x / 2, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2, border_coord.y / 2 + 1)]
		BorderType.BACK_SLASH:
			return [Vector2i(border_coord.x / 2 - 1, border_coord.y / 2 - 1),
					Vector2i((border_coord.x + 1) / 2, border_coord.y / 2)]
		BorderType.SLASH:
			return [Vector2i((border_coord.x + 1) / 2, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2 - 1, border_coord.y / 2)]
		_:
			printerr("getEndTileOfBorder | unknown or unsupported border type")
			return []


func get_all_tile_border(tile_coord: Vector2i, include_center: bool) -> Array[Vector2i]:
	var result = [
			get_tile_coord_directed_border(tile_coord, BorderDirection.LEFT_TOP),
			get_tile_coord_directed_border(tile_coord, BorderDirection.RIGHT_TOP),
			get_tile_coord_directed_border(tile_coord, BorderDirection.LEFT),
			get_tile_coord_directed_border(tile_coord, BorderDirection.RIGHT),
			get_tile_coord_directed_border(tile_coord, BorderDirection.LEFT_DOWN),
			get_tile_coord_directed_border(tile_coord, BorderDirection.RIGHT_DOWN),
	]
	if include_center:
		result.append(get_tile_coord_directed_border(tile_coord, BorderDirection.CENTER))
	return result


# 获取地块在指定方向的边界地块
func get_tile_coord_directed_border(tile_coord: Vector2i, direction: BorderDirection) -> Vector2i:
	match direction:
		BorderDirection.LEFT_TOP:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y)
		BorderDirection.RIGHT_TOP:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y)
		BorderDirection.LEFT:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 - 1, 2 * tile_coord.y + 1)
		BorderDirection.CENTER:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y + 1)
		BorderDirection.RIGHT:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y + 1)
		BorderDirection.LEFT_DOWN:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y + 2)
		BorderDirection.RIGHT_DOWN:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y + 2)
		_:
			printerr("getTileCoordDirectedBorder | direction not supported")
			return Vector2i(-1, -1)


func test_get_tile_coord_directed_border() -> void:
	print("hexagon ", Vector2i(0, 0), "'s left top is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.LEFT_TOP)) # (0,0)
	print("hexagon ", Vector2i(0, 0), "'s right top is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.RIGHT_TOP)) # (1,0)
	print("hexagon ", Vector2i(0, 0), "'s left is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.LEFT)) # (-1,1)
	print("hexagon ", Vector2i(0, 0), "'s center is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.CENTER)) # (0,1)
	print("hexagon ", Vector2i(0, 0), "'s right is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.RIGHT)) # (1,1)
	print("hexagon ", Vector2i(0, 0), "'s left down is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.LEFT_DOWN)) # (0,2)
	print("hexagon ", Vector2i(0, 0), "'s right down is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.RIGHT_DOWN)) # (1,2)
	print("hexagon ", Vector2i(0, 1), "'s left top is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.LEFT_TOP)) # (1,2)
	print("hexagon ", Vector2i(0, 1), "'s right top is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.RIGHT_TOP)) # (2,2)
	print("hexagon ", Vector2i(0, 1), "'s left is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.LEFT)) # (0,3)
	print("hexagon ", Vector2i(0, 1), "'s center is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.CENTER)) # (1,3)
	print("hexagon ", Vector2i(0, 1), "'s right is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.RIGHT)) # (2,3)
	print("hexagon ", Vector2i(0, 1), "'s left down is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.LEFT_DOWN)) # (1,4)
	print("hexagon ", Vector2i(0, 1), "'s right down is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.RIGHT_DOWN)) # (2,4)


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
	var tile_change: bool
	var before: TileInfo
	var after: TileInfo
	var before_border: BorderInfo
	var after_border: BorderInfo


class TileInfo:
	var type: MapEditorGUI.TerrainType = MapEditorGUI.TerrainType.OCEAN
	
	func _init(type: MapEditorGUI.TerrainType) -> void:
		self.type = type


class BorderInfo:
	var type: BorderTileType
	
	func _init(type: BorderTileType) -> void:
		self.type = type
