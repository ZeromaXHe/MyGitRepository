class_name MapEditor
extends Node2D


enum TileChangeType {
	TERRAIN,
	LANDSCAPE,
	VILLAGE,
	RESOURCE,
	CONTINENT,
}

const NULL_COORD := Vector2i(-10000, -10000)


# 左键点击开始时相对镜头的本地坐标
var _from_camera_position := Vector2(-1, -1)
# 格位模式下选择的图块
var _grid_chosen_coord: Vector2i = NULL_COORD
# 鼠标悬浮的图块坐标和时间
var _mouse_hover_tile_coord: Vector2i = NULL_COORD
var _mouse_hover_tile_time: float = 0
# 鼠标悬浮的边界坐标
var _mouse_hover_border_coord: Vector2i = NULL_COORD
# 记录地图
var _map: Map
# 恢复和取消，记录操作的栈
var _before_step_stack: Array[PaintStep] = []
var _after_step_stack: Array[PaintStep] = []


@onready var map_shower: MapShower = $MapShower
@onready var camera: CameraManager = $Camera2D
@onready var gui: MapEditorGUI = $MapEditorGUI


func _ready() -> void:
	if GlobalScript.load_map:
		load_map()
	else:
		initialize_map()
	initialize_camera(_map.size)
	
	gui.restore_btn_pressed.connect(handle_restore)
	gui.cancel_btn_pressed.connect(handle_cancel)
	gui.save_map_btn_pressed.connect(handle_save_map)
	# 控制大洲滤镜的显示与否
	gui.place_other_btn_pressed.connect(map_shower.hide_continent_layer)
	gui.place_continent_btn_pressed.connect(map_shower.show_continent_layer)
	# 切换放置和格位
	gui.rt_tab_changed.connect(handle_gui_rt_tab_changed)


func _process(delta: float) -> void:
	if gui.get_rt_tab_status() == MapEditorGUI.TabStatus.GRID:
		return
	var tile_moved: bool = handle_mouse_hover_tile(delta)
	var border_moved: bool = handle_mouse_hover_border(delta)
	if tile_moved or border_moved:
		paint_new_chosen_area()


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


func handle_save_map() -> void:
	_map.save()


func load_map() -> void:
	_map = Map.load_from_save()
	if _map == null:
		initialize_map()
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


func initialize_map() -> void:
	_map = Map.new()
	if _map.type == Map.Type.BLANK:
		# 修改 TileMap 图块
		var size: Vector2i = Map.SIZE_DICT[_map.size]
		for i in range(0, size.x, 1):
			for j in range(0, size.y, 1):
				var coord := Vector2i(i, j)
				map_shower.paint_tile(coord, _map.get_map_tile_info_at(coord))


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


func handle_gui_rt_tab_changed(tab: int) -> void:
	_mouse_hover_tile_coord = NULL_COORD
	_mouse_hover_border_coord = NULL_COORD
	clear_pre_mouse_hover_tile_chosen()
	clear_pre_mouse_hover_border_chosen()


func handle_restore() -> void:
	if _after_step_stack.is_empty():
		printerr("之后操作为空，异常！")
		return
	var step: PaintStep = _after_step_stack.pop_back()
	if _after_step_stack.is_empty():
		gui.set_restore_button_disable(true)
	for change in step.changed_arr:
		if change.tile_change:
			match change.tile_change_type:
				TileChangeType.TERRAIN:
					map_shower.paint_tile(change.coord, change.after)
				TileChangeType.LANDSCAPE:
					map_shower.paint_tile(change.coord, change.after)
				TileChangeType.VILLAGE:
					map_shower.paint_village(change.coord, change.after.village)
				TileChangeType.RESOURCE:
					map_shower.paint_resource(change.coord, change.after.resource)
				TileChangeType.CONTINENT:
					map_shower.paint_continent(change.coord, change.after.continent)
			# 恢复地图地块信息
			_map.change_map_tile_info(change.coord, change.after)
		else:
			# 恢复 BorderTileMap 到操作后的状态
			map_shower.paint_border(change.coord, change.after_border.type)
			# 恢复地图地块信息
			_map.change_border_tile_info(change.coord, change.after_border)
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
			match change.tile_change_type:
				TileChangeType.TERRAIN:
					map_shower.paint_tile(change.coord, change.before)
				TileChangeType.LANDSCAPE:
					map_shower.paint_tile(change.coord, change.before)
				TileChangeType.VILLAGE:
					map_shower.paint_village(change.coord, change.before.village)
				TileChangeType.RESOURCE:
					map_shower.paint_resource(change.coord, change.before.resource)
				TileChangeType.CONTINENT:
					map_shower.paint_continent(change.coord, change.before.continent)
			# 还原地图地块信息
			_map.change_map_tile_info(change.coord, change.before)
		else:
			# 恢复 BorderTileMap 到操作前的状态
			map_shower.paint_border(change.coord, change.before_border.type)
			# 恢复地图地块信息
			_map.change_border_tile_info(change.coord, change.before_border)
	# 把操作存到之后的恢复栈中
	_after_step_stack.push_back(step)
	gui.set_restore_button_disable(false)


func handle_mouse_hover_tile(delta: float) -> bool:
	var map_coord: Vector2i = map_shower.get_map_coord()
	if map_coord == _mouse_hover_tile_coord:
		_mouse_hover_tile_time += delta
		if not gui.mouse_hover_info_showed and _mouse_hover_tile_time > 2 and is_in_map_tile(map_coord):
			gui.show_mouse_hover_tile_info(map_coord, _map.get_map_tile_info_at(map_coord))
		return false
	clear_pre_mouse_hover_tile_chosen()
	_mouse_hover_tile_coord = map_coord
	_mouse_hover_tile_time = 0
	gui.hide_mouse_hover_tile_info()
	return true


func clear_pre_mouse_hover_tile_chosen() -> void:
	# 擦除所有选择的地块图块
	map_shower.clear_tile_chosen()


func handle_mouse_hover_border(_delta: float) -> bool:
	var border_coord: Vector2i = map_shower.get_border_coord()
	if border_coord == _mouse_hover_border_coord:
		return false
	clear_pre_mouse_hover_border_chosen()
	_mouse_hover_border_coord = border_coord
	return true


func clear_pre_mouse_hover_border_chosen() -> void:
	# 清理所有选择的边界图块
	map_shower.clear_border_chosen()


func paint_new_chosen_area(renew: bool = false) -> void:
	var map_coord: Vector2i = map_shower.get_map_coord()
	var border_coord: Vector2i = map_shower.get_border_coord()
	# 只在放置模式下绘制鼠标悬浮地块
	if gui.get_rt_tab_status() != MapEditorGUI.TabStatus.PLACE:
		return
	if renew:
		clear_pre_mouse_hover_tile_chosen()
		clear_pre_mouse_hover_border_chosen()
	
	match gui.place_mode:
		MapEditorGUI.PlaceMode.RIVER:
			map_shower.paint_chosen_border_area(border_coord, self.is_river_placeable)
		MapEditorGUI.PlaceMode.CLIFF:
			map_shower.paint_chosen_border_area(border_coord, self.is_cliff_placeable)
		MapEditorGUI.PlaceMode.TERRAIN:
			var dist: int = gui.get_painter_size_dist()
			var new_inside: Array[Vector2i] = map_shower.get_surrounding_cells(map_coord, dist, true)
			for coord in new_inside:
				# 新增新图块
				map_shower.paint_tile_chosen_placeable(coord)
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var placeable: Callable = func(x) -> bool: return is_landscape_placeable(x, gui.landscape_type)
			map_shower.paint_chosen_tile_area(map_coord, placeable)
		MapEditorGUI.PlaceMode.VILLAGE:
			map_shower.paint_chosen_tile_area(map_coord, self.is_village_placeable)
		MapEditorGUI.PlaceMode.RESOURCE:
			var placeable: Callable = func(x) -> bool: return is_resource_placeable(x, gui.resource_type)
			map_shower.paint_chosen_tile_area(map_coord, placeable)
		MapEditorGUI.PlaceMode.CONTINENT:
			var dist: int = gui.get_painter_size_dist()
			var new_inside: Array[Vector2i] = map_shower.get_surrounding_cells(map_coord, dist, true)
			for coord in new_inside:
				map_shower.paint_chosen_tile_area(coord, self.is_continent_placeable)


func is_in_map_tile(coord: Vector2i) -> bool:
	var map_size: Vector2i = Map.SIZE_DICT[_map.size]
	return coord.x >= 0 and coord.x < map_size.x and coord.y >= 0 and coord.y < map_size.y


func is_landscape_placeable(tile_coord: Vector2i, landscape: Map.LandscapeType) -> bool:
	# 超出地图范围的不处理
	if not is_in_map_tile(tile_coord):
		return false
	if not is_landscape_placeable_terrain(landscape, _map.get_map_tile_info_at(tile_coord).type):
		return false
	match landscape:
		Map.LandscapeType.FLOOD:
			## 泛滥平原需要放在沿河的沙漠
			return is_flood_placeable_borders(tile_coord)
		Map.LandscapeType.OASIS:
			## 绿洲需要放在周围全是沙漠/沙漠丘陵/沙漠山脉地块的沙漠，而且不能和其他绿洲相邻
			return is_oasis_placeable_surroundings(tile_coord)
		_:
			return true


func is_landscape_placeable_terrain(landscape: Map.LandscapeType, terrain_type: Map.TerrainType) -> bool:
	match landscape:
		Map.LandscapeType.ICE:
			return is_ice_placeable_terrain(terrain_type)
		Map.LandscapeType.FOREST:
			return is_forest_placeable_terrain(terrain_type)
		Map.LandscapeType.SWAMP:
			return is_swamp_placeable_terrain(terrain_type)
		Map.LandscapeType.FLOOD:
			return is_flood_placeable_terrain(terrain_type)
		Map.LandscapeType.OASIS:
			return is_oasis_placeable_terrain(terrain_type)
		Map.LandscapeType.RAINFOREST:
			return is_rainforest_placeable_terrain(terrain_type)
		Map.LandscapeType.EMPTY:
			return true
		_:
			printerr("is_landscape_placeable_tile | unknown landscape: ", landscape)
			return false


func is_ice_placeable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.SHORE or terrain_type == Map.TerrainType.OCEAN


func is_forest_placeable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.GRASS or terrain_type == Map.TerrainType.GRASS_HILL \
			or terrain_type == Map.TerrainType.PLAIN or terrain_type == Map.TerrainType.PLAIN_HILL \
			or terrain_type == Map.TerrainType.TUNDRA or terrain_type == Map.TerrainType.TUNDRA_HILL


func is_swamp_placeable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.GRASS


func is_flood_placeable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.DESERT


func is_flood_placeable_borders(tile_coord: Vector2i) -> bool:
	var borders: Array[Vector2i] = Map.get_all_tile_border(tile_coord, false)
	for border in borders:
		if _map.get_border_tile_info_at(border).type == Map.BorderTileType.RIVER:
			return true
	return false


func is_oasis_placeable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.DESERT


func is_oasis_placeable_surroundings(tile_coord: Vector2i) -> bool:
	var surroundings: Array[Vector2i] = map_shower.get_surrounding_cells(tile_coord, 1, false)
	for surrounding in surroundings:
		var tile_info: Map.TileInfo = _map.get_map_tile_info_at(surrounding)
		if tile_info.type != Map.TerrainType.DESERT \
				and tile_info.type != Map.TerrainType.DESERT_HILL \
				and tile_info.type != Map.TerrainType.DESERT_MOUNTAIN:
			return false
		if tile_info.landscape == Map.LandscapeType.OASIS:
			return false
	return true


func is_rainforest_placeable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.GRASS or terrain_type == Map.TerrainType.GRASS_HILL \
			or terrain_type == Map.TerrainType.PLAIN or terrain_type == Map.TerrainType.PLAIN_HILL


func is_village_placeable(tile_coord: Vector2i) -> bool:
	# 超出地图范围的不处理
	if not is_in_map_tile(tile_coord):
		return false
	return is_village_placeable_terrain(_map.get_map_tile_info_at(tile_coord).type)


func is_village_placeable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.GRASS or terrain_type == Map.TerrainType.GRASS_HILL \
			or terrain_type == Map.TerrainType.PLAIN or terrain_type == Map.TerrainType.PLAIN_HILL \
			or terrain_type == Map.TerrainType.DESERT or terrain_type == Map.TerrainType.DESERT_HILL \
			or terrain_type == Map.TerrainType.TUNDRA or terrain_type == Map.TerrainType.TUNDRA_HILL \
			or terrain_type == Map.TerrainType.SNOW or terrain_type == Map.TerrainType.SNOW_HILL


func is_resource_placeable(tile_coord: Vector2i, type: Map.ResourceType) -> bool:
	# 超出地图范围的不处理
	if not is_in_map_tile(tile_coord):
		return false
	var tile_info: Map.TileInfo = _map.get_map_tile_info_at(tile_coord)
	return is_resource_placeable_terrain_and_landscape(type, tile_info.type, tile_info.landscape)


func is_resource_placeable_terrain_and_landscape(resource: Map.ResourceType, \
		terrain: Map.TerrainType, landscape: Map.LandscapeType) -> bool:
	match resource:
		Map.ResourceType.EMPTY:
			return true
		Map.ResourceType.SILK:
			return landscape == Map.LandscapeType.FOREST
		Map.ResourceType.RELIC:
			return terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.GRASS_HILL \
					or terrain == Map.TerrainType.PLAIN or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.DESERT_HILL \
					or terrain == Map.TerrainType.TUNDRA or terrain == Map.TerrainType.TUNDRA_HILL \
					or terrain == Map.TerrainType.SNOW or terrain == Map.TerrainType.SNOW_HILL
		Map.ResourceType.COCOA_BEAN:
			return landscape == Map.LandscapeType.RAINFOREST
		Map.ResourceType.COFFEE:
			return terrain == Map.TerrainType.GRASS or landscape == Map.LandscapeType.RAINFOREST
		Map.ResourceType.MARBLE:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.GRASS_HILL \
					or terrain == Map.TerrainType.PLAIN_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.RICE:
			return terrain == Map.TerrainType.GRASS \
					and (landscape == Map.LandscapeType.EMPTY or landscape == Map.LandscapeType.SWAMP \
					or landscape == Map.LandscapeType.FLOOD)
		Map.ResourceType.WHEAT:
			return ((terrain == Map.TerrainType.PLAIN or terrain == Map.TerrainType.DESERT) \
					and landscape == Map.LandscapeType.FLOOD) \
					or (terrain == Map.TerrainType.PLAIN and landscape == Map.LandscapeType.EMPTY)
		Map.ResourceType.TRUFFLE:
			return landscape == Map.LandscapeType.FOREST or landscape == Map.LandscapeType.RAINFOREST \
					or landscape == Map.LandscapeType.SWAMP
		Map.ResourceType.ORANGE:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.DYE:
			return landscape == Map.LandscapeType.RAINFOREST or landscape == Map.LandscapeType.FOREST
		Map.ResourceType.COTTON:
			return ((terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN \
					or terrain == Map.TerrainType.DESERT) and landscape == Map.LandscapeType.FLOOD) \
					or ((terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.EMPTY)
		Map.ResourceType.MERCURY:
			return terrain == Map.TerrainType.PLAIN \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.WRECKAGE:
			return terrain == Map.TerrainType.SHORE \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.TOBACCO:
			return ((terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.EMPTY) \
					or landscape == Map.LandscapeType.FOREST or landscape == Map.LandscapeType.RAINFOREST
		Map.ResourceType.COAL:
			return (terrain == Map.TerrainType.GRASS_HILL or terrain == Map.TerrainType.PLAIN_HILL) \
					and landscape == Map.LandscapeType.EMPTY
					# or landscape == Map.LandscapeType.FOREST 原版不支持
		Map.ResourceType.INCENSE:
			return (terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.COW:
			return terrain == Map.TerrainType.GRASS and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.JADE:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN \
					or terrain == Map.TerrainType.TUNDRA) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.CORN:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and (landscape == Map.LandscapeType.FLOOD or landscape == Map.LandscapeType.EMPTY)
		Map.ResourceType.PEARL:
			return terrain == Map.TerrainType.SHORE and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.FUR:
			return terrain == Map.TerrainType.TUNDRA or landscape == Map.LandscapeType.FOREST
		Map.ResourceType.SALT:
			return (terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.PLAIN \
					or terrain == Map.TerrainType.TUNDRA) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.STONE:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.GRASS_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.OIL:
			return ((terrain == Map.TerrainType.SHORE or terrain == Map.TerrainType.DESERT \
					or terrain == Map.TerrainType.TUNDRA or terrain == Map.TerrainType.SNOW) \
					and landscape == Map.LandscapeType.EMPTY) \
					or landscape == Map.LandscapeType.SWAMP
					# or (terrain == Map.TerrainType.DESERT and landscape == Map.LandscapeType.FLOOD) 原版不支持
		Map.ResourceType.GYPSUM:
			return (terrain == Map.TerrainType.PLAIN or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT_HILL or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.SALTPETER:
			# 注意原版和其他判定不一样
			return ((terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN \
					or terrain == Map.TerrainType.TUNDRA or terrain == Map.TerrainType.DESERT) \
					and landscape == Map.LandscapeType.EMPTY) or landscape == Map.LandscapeType.FLOOD
		Map.ResourceType.SUGAR:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN \
					or terrain == Map.TerrainType.DESERT) \
					and (landscape == Map.LandscapeType.FLOOD or landscape == Map.LandscapeType.SWAMP)
		Map.ResourceType.SHEEP:
			return (terrain == Map.TerrainType.GRASS_HILL or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT_HILL or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.TEA:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.GRASS_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.WINE:
			return ((terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.EMPTY) or landscape == Map.LandscapeType.FOREST
		Map.ResourceType.HONEY:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.CRAB:
			return terrain == Map.TerrainType.SHORE and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.IVORY:
			return ((terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.PLAIN \
					or terrain == Map.TerrainType.PLAIN_HILL) and landscape == Map.LandscapeType.EMPTY) \
					or landscape == Map.LandscapeType.RAINFOREST or landscape == Map.LandscapeType.FOREST
		Map.ResourceType.DIAMOND:
			return ((terrain == Map.TerrainType.GRASS_HILL or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT_HILL or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.EMPTY) or landscape == Map.LandscapeType.RAINFOREST
		Map.ResourceType.URANIUM:
			return ((terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.GRASS_HILL \
					or terrain == Map.TerrainType.PLAIN or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.DESERT_HILL \
					or terrain == Map.TerrainType.TUNDRA or terrain == Map.TerrainType.TUNDRA_HILL \
					or terrain == Map.TerrainType.SNOW or terrain == Map.TerrainType.SNOW_HILL) \
					and landscape == Map.LandscapeType.EMPTY) \
					or landscape == Map.LandscapeType.RAINFOREST or landscape == Map.LandscapeType.FOREST
		Map.ResourceType.IRON:
			return (terrain == Map.TerrainType.GRASS_HILL or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT_HILL or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.COPPER:
			return (terrain == Map.TerrainType.GRASS_HILL or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT_HILL or terrain == Map.TerrainType.TUNDRA_HILL \
					or terrain == Map.TerrainType.SNOW_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.ALUMINIUM:
			return (terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.DESERT_HILL \
					or terrain == Map.TerrainType.PLAIN) and landscape == Map.LandscapeType.EMPTY
					# or landscape == Map.LandscapeType.RAINFOREST 风云变幻的条件，原版不行
		Map.ResourceType.SILVER:
			return (terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.DESERT_HILL \
					or terrain == Map.TerrainType.TUNDRA or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.SPICE:
			return landscape == Map.LandscapeType.RAINFOREST or landscape == Map.LandscapeType.FOREST
		Map.ResourceType.BANANA:
			return landscape == Map.LandscapeType.RAINFOREST
		Map.ResourceType.HORSE:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.FISH:
			return terrain == Map.TerrainType.SHORE and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.WHALE:
			return terrain == Map.TerrainType.SHORE and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.DEER:
			return ((terrain == Map.TerrainType.TUNDRA or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.EMPTY) or landscape == Map.LandscapeType.FOREST
	return false


func is_continent_placeable(tile_coord: Vector2i) -> bool:
	# 超出地图范围的不处理
	if not is_in_map_tile(tile_coord):
		return false
	return is_continent_placeable_terrain(_map.get_map_tile_info_at(tile_coord).type)


func is_continent_placeable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type != Map.TerrainType.SHORE and terrain_type != Map.TerrainType.OCEAN


func is_river_placeable(border_coord: Vector2i) -> bool:
	if map_shower.is_in_map_border(border_coord) <= 0 or Map.get_border_type(border_coord) == Map.BorderType.CENTER:
		return false
	var neighbor_tile_coords: Array[Vector2i] = Map.get_neighbor_tile_of_border(border_coord)
	for coord in neighbor_tile_coords:
		if not is_in_map_tile(coord):
			continue
		var terrain_type: Map.TerrainType = _map.get_map_tile_info_at(coord).type
		if terrain_type == Map.TerrainType.SHORE or terrain_type == Map.TerrainType.OCEAN:
			# 和浅海或者深海相邻
			return false
	var end_tile_coords: Array[Vector2i] = Map.get_end_tile_of_border(border_coord)
	for coord in end_tile_coords:
		if not is_in_map_tile(coord):
			continue
		var terrain_type: Map.TerrainType = _map.get_map_tile_info_at(coord).type
		if terrain_type == Map.TerrainType.SHORE or terrain_type == Map.TerrainType.OCEAN:
			# 末端是浅海或者深海
			return true
	var connect_border_coords: Array[Vector2i] = Map.get_connect_border_of_border(border_coord)
	for coord in connect_border_coords:
		var border_tile_type: Map.BorderTileType = _map.get_border_tile_info_at(coord).type
		if border_tile_type == Map.BorderTileType.RIVER:
			# 连接的边界有河流
			return true
	return false


func is_cliff_placeable(border_coord: Vector2i) -> bool:
	if map_shower.is_in_map_border(border_coord) <= 0 or Map.get_border_type(border_coord) == Map.BorderType.CENTER:
		return false
	var neighbor_tile_coords: Array[Vector2i] = Map.get_neighbor_tile_of_border(border_coord)
	var neighbor_sea: bool = false
	var neighbor_land: bool = false
	for coord in neighbor_tile_coords:
		var terrain_type: Map.TerrainType = _map.get_map_tile_info_at(coord).type
		if terrain_type == Map.TerrainType.SHORE or terrain_type == Map.TerrainType.OCEAN:
			# 和浅海或者深海相邻
			neighbor_sea = true
		else:
			neighbor_land = true
	return neighbor_land and neighbor_sea


func depaint_map() -> void:
	var step: PaintStep = PaintStep.new()
	match gui.place_mode:
		MapEditorGUI.PlaceMode.CLIFF:
			var border_coord: Vector2i = map_shower.get_border_coord()
			if _map.get_border_tile_info_at(border_coord).type != Map.BorderTileType.CLIFF:
				return
			paint_border(border_coord, step, Map.BorderTileType.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RIVER:
			var border_coord: Vector2i = map_shower.get_border_coord()
			if _map.get_border_tile_info_at(border_coord).type != Map.BorderTileType.RIVER:
				return
			paint_border(border_coord, step, Map.BorderTileType.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var tile_coord: Vector2i = map_shower.get_map_coord()
			if _map.get_map_tile_info_at(tile_coord).landscape == Map.LandscapeType.EMPTY:
				return
			paint_landscape(tile_coord, step, Map.LandscapeType.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.VILLAGE:
			var tile_coord: Vector2i = map_shower.get_map_coord()
			if _map.get_map_tile_info_at(tile_coord).village == 0:
				return
			paint_village(tile_coord, step, 0)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RESOURCE:
			var tile_coord: Vector2i = map_shower.get_map_coord()
			if _map.get_map_tile_info_at(tile_coord).resource == Map.ResourceType.EMPTY:
				# FIXME: 4.1 现在的场景 TileMap bug，需要等待 4.2 发布解决。目前先打日志说明一下
#				print("tile map ", tile_coord, " is empty. (if you see a icon, it's because 4.1's bug. Wait for 4.2 update to fix it)")
				return
			paint_resource(tile_coord, step, Map.ResourceType.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
	save_paint_step(step)


func paint_map() -> void:
	# 格位模式下只绘制选择绿块
	if gui.get_rt_tab_status() == MapEditorGUI.TabStatus.GRID:
		var coord: Vector2i = map_shower.get_map_coord()
		map_shower.clear_tile_chosen()
		_grid_chosen_coord = coord
		map_shower.paint_tile_chosen_placeable(coord)
		gui.update_grid_info(coord, _map.get_map_tile_info_at(coord))
		return
	var step: PaintStep = PaintStep.new()
	match gui.place_mode:
		MapEditorGUI.PlaceMode.TERRAIN:
			var map_coord: Vector2i = map_shower.get_map_coord()
			var dist: int = gui.get_painter_size_dist()
			var inside: Array[Vector2i] = map_shower.get_surrounding_cells(map_coord, dist, true)
			for coord in inside:
				# 超出地图范围的不处理
				if not is_in_map_tile(coord):
					continue
				if _map.get_map_tile_info_at(coord).type == gui.terrain_type:
					continue
				paint_terrain(coord, step, gui.terrain_type)
			# 围绕陆地地块绘制浅海
			if gui.terrain_type != Map.TerrainType.SHORE and gui.terrain_type != Map.TerrainType.OCEAN:
				var out_ring: Array[Vector2i] = map_shower.get_surrounding_cells(map_coord, dist + 1, false)
				for coord in out_ring:
					# 超出地图范围的不处理
					if not is_in_map_tile(coord):
						continue
					# 仅深海需要改为浅海
					if _map.get_map_tile_info_at(coord).type != Map.TerrainType.OCEAN:
						continue
					paint_terrain(coord, step, Map.TerrainType.SHORE)
			# 如果地块是丘陵，需要在周围沿海边界放置悬崖
			if gui.terrain_type == Map.TerrainType.GRASS_HILL \
					or gui.terrain_type == Map.TerrainType.PLAIN_HILL \
					or gui.terrain_type == Map.TerrainType.DESERT_HILL \
					or gui.terrain_type == Map.TerrainType.TUNDRA_HILL \
					or gui.terrain_type == Map.TerrainType.SNOW_HILL:
				var borders: Array[Vector2i] = map_shower.get_surrounding_borders(map_coord, dist)
				for border in borders:
					if is_cliff_placeable(border):
						paint_border(border, step, Map.BorderTileType.CLIFF)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var coord: Vector2i = map_shower.get_map_coord()
			if not is_landscape_placeable(coord, gui.landscape_type):
				return
			if _map.get_map_tile_info_at(coord).landscape == gui.landscape_type:
				return
			paint_landscape(coord, step, gui.landscape_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.VILLAGE:
			var coord: Vector2i = map_shower.get_map_coord()
			if not is_village_placeable(coord):
				return
			if _map.get_map_tile_info_at(coord).village == 1:
				return
			paint_village(coord, step, 1)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RESOURCE:
			var coord: Vector2i = map_shower.get_map_coord()
			if not is_resource_placeable(coord, gui.resource_type):
				return
			if _map.get_map_tile_info_at(coord).resource == gui.resource_type:
				return
			paint_resource(coord, step, gui.resource_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.CONTINENT:
			var map_coord: Vector2i = map_shower.get_map_coord()
			var dist: int = gui.get_painter_size_dist()
			var inside: Array[Vector2i] = map_shower.get_surrounding_cells(map_coord, dist, true)
			for coord in inside:
				if not is_continent_placeable(coord):
					continue
				if _map.get_map_tile_info_at(coord).continent == gui.continent_type:
					continue
				paint_continent(coord, step, gui.continent_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.CLIFF:
			var border_coord: Vector2i = map_shower.get_border_coord()
			if not is_cliff_placeable(border_coord):
				return
			if _map.get_border_tile_info_at(border_coord).type == Map.BorderTileType.CLIFF:
				return
			# 绘制边界悬崖
			paint_border(border_coord, step, Map.BorderTileType.CLIFF)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RIVER:
			var border_coord: Vector2i = map_shower.get_border_coord()
			if not is_river_placeable(border_coord):
				return
			if _map.get_border_tile_info_at(border_coord).type == Map.BorderTileType.RIVER:
				return
			# 绘制边界河流
			paint_border(border_coord, step, Map.BorderTileType.RIVER)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
	
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


func paint_terrain(coord: Vector2i, step: PaintStep, terrain_type: Map.TerrainType):
	# 记录操作
	var change: PaintChange = build_change_of_tile(coord, TileChangeType.TERRAIN)
	change.after.type = terrain_type
	
	if change.before.landscape != Map.LandscapeType.EMPTY \
			and not is_landscape_placeable_terrain(change.before.landscape, terrain_type):
		change.after.landscape = Map.LandscapeType.EMPTY
	if change.before.village == 1 and not is_village_placeable_terrain(terrain_type):
		change.after.village = 0
	
	if change.before.continent != Map.ContinentType.EMPTY \
			and not is_continent_placeable_terrain(terrain_type):
		change.after.continent = Map.ContinentType.EMPTY
	elif is_continent_placeable_terrain(terrain_type) and change.before.continent == Map.ContinentType.EMPTY:
		# 从海变陆时需要给个默认的大洲
		change.after.continent = gui.continent_type
	
	if change.before.resource != Map.ResourceType.EMPTY \
			and not is_resource_placeable_terrain_and_landscape(change.before.resource, terrain_type, change.after.landscape):
		change.after.resource = Map.ResourceType.EMPTY
	
	step.changed_arr.append(change)
	
	# 记录地图地块信息
	_map.change_map_tile_info(coord, change.after)
	# 重新绘制整个 TileMap 地块
	map_shower.paint_tile(coord, change.after)
	
	# 对周围一圈边界进行校验，不符合的边界需要重置为空
	var borders: Array[Vector2i] = Map.get_all_tile_border(coord, false)
	for border in borders:
		var border_info: Map.BorderInfo = _map.get_border_tile_info_at(border)
		if border_info.type == Map.BorderTileType.CLIFF:
			if not is_cliff_placeable(border):
				paint_border(border, step, Map.BorderTileType.EMPTY)
		elif border_info.type == Map.BorderTileType.RIVER:
			if not is_river_placeable(border):
				paint_border(border, step, Map.BorderTileType.EMPTY)


func paint_landscape(tile_coord: Vector2i, step: PaintStep, type: Map.LandscapeType) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_tile(tile_coord, TileChangeType.LANDSCAPE)
	change.after.landscape = type
	
	if change.before.resource == Map.ResourceType.EMPTY \
			and not is_resource_placeable_terrain_and_landscape(change.before.resource, change.before.type, type):
		change.after.resource = Map.ResourceType.EMPTY
		map_shower.paint_resource(tile_coord, Map.ResourceType.EMPTY)
	
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_map_tile_info(tile_coord, change.after)
	# 真正绘制地貌
	map_shower.paint_landscape(tile_coord, type)


func paint_village(tile_coord: Vector2i, step: PaintStep, type: int) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_tile(tile_coord, TileChangeType.VILLAGE)
	change.after.village = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_map_tile_info(tile_coord, change.after)
	# 真正绘制村庄
	map_shower.paint_village(tile_coord, type)


func paint_resource(tile_coord: Vector2i, step: PaintStep, type: Map.ResourceType) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_tile(tile_coord, TileChangeType.RESOURCE)
	change.after.resource = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_map_tile_info(tile_coord, change.after)
	# 真正绘制资源
	map_shower.paint_resource(tile_coord, type)


func paint_continent(tile_coord: Vector2i, step: PaintStep, type: Map.ContinentType) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_tile(tile_coord, TileChangeType.CONTINENT)
	change.after.continent = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_map_tile_info(tile_coord, change.after)
	# 真正绘制大洲
	map_shower.paint_continent(tile_coord, type)


func paint_border(border_coord: Vector2i, step: PaintStep, type: Map.BorderTileType) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_border(border_coord, type)
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_border_tile_info(border_coord, change.after_border)
	# 真正绘制边界
	map_shower.paint_border(border_coord, type)


func build_change_of_tile(tile_coord: Vector2i, type: TileChangeType) -> PaintChange:
	var change: PaintChange = PaintChange.new()
	change.coord = tile_coord
	change.tile_change = true
	change.tile_change_type = type
	change.before = _map.get_map_tile_info_at(tile_coord)
	change.after = Map.TileInfo.copy(change.before)
	return change
	
	
func build_change_of_border(border_coord: Vector2i, type: Map.BorderTileType) -> PaintChange:
	var change: PaintChange = PaintChange.new()
	change.coord = border_coord
	change.tile_change = false
	change.before_border = _map.get_border_tile_info_at(border_coord)
	change.after_border = Map.BorderInfo.new(type)
	return change


class PaintStep:
	var changed_arr: Array[PaintChange] = []


class PaintChange:
	var coord: Vector2i
	var tile_change: bool
	var tile_change_type: TileChangeType = TileChangeType.TERRAIN
	var before: Map.TileInfo
	var after: Map.TileInfo
	var before_border: Map.BorderInfo
	var after_border: Map.BorderInfo

