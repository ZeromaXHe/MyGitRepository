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
# TileMap 层索引
const TILE_TERRAIN_LAYER_IDX: int = 0
const TILE_LANDSCAPE_LAYER_IDX: int = 1
const TILE_VILLAGE_LAYER_IDX: int = 2
const TILE_CONTINENT_LAYER_IDX: int = 3
const TILE_CHOSEN_LAYER_IDX: int = 4
const TILE_RESOURCE_LAYER_IDX: int = 5
# BorderTileMap 层索引
const BORDER_TILE_LAYER_IDX: int = 0
const BORDER_CHOSEN_LAYER_IDX: int = 1
# 资源类型和对应资源图标场景的映射字典
const RESOURCE_TYPE_TO_ICON_SCENE_DICT: Dictionary = {
	Map.ResourceType.SILK: preload("res://scenes/map_editor/resource_tiles/resource_sprite.tscn"),
	Map.ResourceType.RELIC: preload("res://scenes/map_editor/resource_tiles/sprite_relic.tscn"),
	Map.ResourceType.COCOA_BEAN: preload("res://scenes/map_editor/resource_tiles/sprite_cocoa_bean.tscn"),
	Map.ResourceType.COFFEE: preload("res://scenes/map_editor/resource_tiles/sprite_coffee.tscn"),
	Map.ResourceType.MARBLE: preload("res://scenes/map_editor/resource_tiles/sprite_marble.tscn"),
	Map.ResourceType.RICE: preload("res://scenes/map_editor/resource_tiles/sprite_rice.tscn"),
	Map.ResourceType.WHEAT: preload("res://scenes/map_editor/resource_tiles/sprite_wheat.tscn"),
	Map.ResourceType.TRUFFLE: preload("res://scenes/map_editor/resource_tiles/sprite_truffle.tscn"),
	Map.ResourceType.ORANGE: preload("res://scenes/map_editor/resource_tiles/sprite_orange.tscn"),
	Map.ResourceType.DYE: preload("res://scenes/map_editor/resource_tiles/sprite_dye.tscn"),
	Map.ResourceType.COTTON: preload("res://scenes/map_editor/resource_tiles/sprite_cotton.tscn"),
	Map.ResourceType.MERCURY: preload("res://scenes/map_editor/resource_tiles/sprite_mercury.tscn"),
	Map.ResourceType.WRECKAGE: preload("res://scenes/map_editor/resource_tiles/sprite_wreckage.tscn"),
	Map.ResourceType.TOBACCO: preload("res://scenes/map_editor/resource_tiles/sprite_tobacco.tscn"),
	Map.ResourceType.COAL: preload("res://scenes/map_editor/resource_tiles/sprite_coal.tscn"),
	Map.ResourceType.INCENSE: preload("res://scenes/map_editor/resource_tiles/sprite_incense.tscn"),
	Map.ResourceType.COW: preload("res://scenes/map_editor/resource_tiles/sprite_cow.tscn"),
	Map.ResourceType.JADE: preload("res://scenes/map_editor/resource_tiles/sprite_jade.tscn"),
	Map.ResourceType.CORN: preload("res://scenes/map_editor/resource_tiles/sprite_corn.tscn"),
	Map.ResourceType.PEARL: preload("res://scenes/map_editor/resource_tiles/sprite_pearl.tscn"),
	Map.ResourceType.FUR: preload("res://scenes/map_editor/resource_tiles/sprite_fur.tscn"),
	Map.ResourceType.SALT: preload("res://scenes/map_editor/resource_tiles/sprite_salt.tscn"),
	Map.ResourceType.STONE: preload("res://scenes/map_editor/resource_tiles/sprite_stone.tscn"),
	Map.ResourceType.OIL: preload("res://scenes/map_editor/resource_tiles/sprite_oil.tscn"),
	Map.ResourceType.GYPSUM: preload("res://scenes/map_editor/resource_tiles/sprite_gypsum.tscn"),
	Map.ResourceType.SALTPETER: preload("res://scenes/map_editor/resource_tiles/sprite_saltpeter.tscn"),
	Map.ResourceType.SUGAR: preload("res://scenes/map_editor/resource_tiles/sprite_sugar.tscn"),
	Map.ResourceType.SHEEP: preload("res://scenes/map_editor/resource_tiles/sprite_sheep.tscn"),
	Map.ResourceType.TEA: preload("res://scenes/map_editor/resource_tiles/sprite_tea.tscn"),
	Map.ResourceType.WINE: preload("res://scenes/map_editor/resource_tiles/sprite_wine.tscn"),
	Map.ResourceType.HONEY: preload("res://scenes/map_editor/resource_tiles/sprite_honey.tscn"),
	Map.ResourceType.CRAB: preload("res://scenes/map_editor/resource_tiles/sprite_crab.tscn"),
	Map.ResourceType.IVORY: preload("res://scenes/map_editor/resource_tiles/sprite_ivory.tscn"),
	Map.ResourceType.DIAMOND: preload("res://scenes/map_editor/resource_tiles/sprite_diamond.tscn"),
	Map.ResourceType.URANIUM: preload("res://scenes/map_editor/resource_tiles/sprite_uranium.tscn"),
	Map.ResourceType.IRON: preload("res://scenes/map_editor/resource_tiles/sprite_iron.tscn"),
	Map.ResourceType.COPPER: preload("res://scenes/map_editor/resource_tiles/sprite_copper.tscn"),
	Map.ResourceType.ALUMINIUM: preload("res://scenes/map_editor/resource_tiles/sprite_aluminium.tscn"),
	Map.ResourceType.SILVER: preload("res://scenes/map_editor/resource_tiles/sprite_silver.tscn"),
	Map.ResourceType.SPICE: preload("res://scenes/map_editor/resource_tiles/sprite_spice.tscn"),
	Map.ResourceType.BANANA: preload("res://scenes/map_editor/resource_tiles/sprite_banana.tscn"),
	Map.ResourceType.HORSE: preload("res://scenes/map_editor/resource_tiles/sprite_horse.tscn"),
	Map.ResourceType.FISH: preload("res://scenes/map_editor/resource_tiles/sprite_fish.tscn"),
	Map.ResourceType.WHALE: preload("res://scenes/map_editor/resource_tiles/sprite_whale.tscn"),
	Map.ResourceType.DEER: preload("res://scenes/map_editor/resource_tiles/sprite_deer.tscn"),
}


# 左键点击开始时相对镜头的本地坐标
var _from_camera_position := Vector2(-1, -1)
# 鼠标悬浮的图块坐标和时间
var _mouse_hover_tile_coord: Vector2i = NULL_COORD
var _mouse_hover_tile_time: float = 0
# 鼠标悬浮的边界坐标
var _mouse_hover_border_coord: Vector2i = NULL_COORD
# 地块类型到 TileSet 信息映射
var _terrain_type_to_tile_dict : Dictionary = {
	Map.TerrainType.GRASS: MapTileCell.new(0, Vector2i.ZERO),
	Map.TerrainType.GRASS_HILL: MapTileCell.new(1, Vector2i.ZERO),
	Map.TerrainType.GRASS_MOUNTAIN: MapTileCell.new(2, Vector2i.ZERO),
	Map.TerrainType.PLAIN: MapTileCell.new(3, Vector2i.ZERO),
	Map.TerrainType.PLAIN_HILL: MapTileCell.new(4, Vector2i.ZERO),
	Map.TerrainType.PLAIN_MOUNTAIN: MapTileCell.new(5, Vector2i.ZERO),
	Map.TerrainType.DESERT: MapTileCell.new(6, Vector2i.ZERO),
	Map.TerrainType.DESERT_HILL: MapTileCell.new(7, Vector2i.ZERO),
	Map.TerrainType.DESERT_MOUNTAIN: MapTileCell.new(8, Vector2i.ZERO),
	Map.TerrainType.TUNDRA: MapTileCell.new(9, Vector2i.ZERO),
	Map.TerrainType.TUNDRA_HILL: MapTileCell.new(10, Vector2i.ZERO),
	Map.TerrainType.TUNDRA_MOUNTAIN: MapTileCell.new(11, Vector2i.ZERO),
	Map.TerrainType.SNOW: MapTileCell.new(12, Vector2i.ZERO),
	Map.TerrainType.SNOW_HILL: MapTileCell.new(13, Vector2i.ZERO),
	Map.TerrainType.SNOW_MOUNTAIN: MapTileCell.new(14, Vector2i.ZERO),
	Map.TerrainType.SHORE: MapTileCell.new(15, Vector2i.ZERO),
	Map.TerrainType.OCEAN: MapTileCell.new(16, Vector2i.ZERO),
}
# 记录地图
var _map: Map
# 恢复和取消，记录操作的栈
var _before_step_stack: Array[PaintStep] = []
var _after_step_stack: Array[PaintStep] = []
# 记录 TileMap 坐标到资源图标的映射的字典
var _coord_to_resource_icon_dict: Dictionary = {}

@onready var border_tile_map: TileMap = $BorderTileMap
@onready var tile_map: TileMap = $TileMap
@onready var resource_icons: Node2D = $ResourceIcons
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
	gui.place_other_btn_pressed.connect(func(): tile_map.set_layer_enabled(TILE_CONTINENT_LAYER_IDX, false))
	gui.place_continent_btn_pressed.connect(func(): tile_map.set_layer_enabled(TILE_CONTINENT_LAYER_IDX, true))
	tile_map.set_layer_enabled(TILE_CONTINENT_LAYER_IDX, false)


func _process(delta: float) -> void:
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
					do_paint_tile(change.coord, change.after)
				TileChangeType.LANDSCAPE:
					do_paint_tile(change.coord, change.after)
				TileChangeType.VILLAGE:
					do_paint_village(change.coord, change.after.village)
				TileChangeType.RESOURCE:
					do_paint_resource(change.coord, change.after.resource)
				TileChangeType.CONTINENT:
					do_paint_continent(change.coord, change.after.continent)
			# 恢复地图地块信息
			_map.change_map_tile_info(change.coord, change.after)
		else:
			# 恢复 BorderTileMap 到操作后的状态
			do_paint_border(change.coord, change.after_border.type)
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
					do_paint_tile(change.coord, change.before)
				TileChangeType.LANDSCAPE:
					do_paint_tile(change.coord, change.before)
				TileChangeType.VILLAGE:
					do_paint_village(change.coord, change.before.village)
				TileChangeType.RESOURCE:
					do_paint_resource(change.coord, change.before.resource)
				TileChangeType.CONTINENT:
					do_paint_continent(change.coord, change.before.continent)
			# 还原地图地块信息
			_map.change_map_tile_info(change.coord, change.before)
		else:
			# 恢复 BorderTileMap 到操作前的状态
			do_paint_border(change.coord, change.before_border.type)
			# 恢复地图地块信息
			_map.change_border_tile_info(change.coord, change.before_border)
	# 把操作存到之后的恢复栈中
	_after_step_stack.push_back(step)
	gui.set_restore_button_disable(false)


func do_paint_border(coord: Vector2i, type: Map.BorderTileType) -> void:
	match type:
		Map.BorderTileType.EMPTY:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, coord, -1)
		Map.BorderTileType.RIVER:
			paint_river(coord)
		Map.BorderTileType.CLIFF:
			paint_cliff(coord)


func get_border_coord() -> Vector2i:
	return border_tile_map.local_to_map(border_tile_map.to_local(get_global_mouse_position()))


func get_map_coord() -> Vector2i:
	return tile_map.local_to_map(tile_map.to_local(get_global_mouse_position()))


func handle_mouse_hover_tile(delta: float) -> bool:
	var map_coord: Vector2i = get_map_coord()
	if map_coord == _mouse_hover_tile_coord:
		_mouse_hover_tile_time += delta
		if not gui.mouse_hover_info_showed and _mouse_hover_tile_time > 2 and is_in_map_tile(map_coord):
			gui.show_mouse_hover_tile_info(map_coord, _map.get_map_tile_info_at(map_coord))
		return false
	clear_pre_mouse_hover_tile_selection()
	_mouse_hover_tile_coord = map_coord
	_mouse_hover_tile_time = 0
	gui.hide_mouse_hover_tile_info()
	return true


func clear_pre_mouse_hover_tile_selection() -> void:
	# 按最大笔刷的范围擦除原来图块
	if _mouse_hover_tile_coord != NULL_COORD:
		var old_inside: Array[Vector2i] = get_surrounding_cells(_mouse_hover_tile_coord, 2, true)
		for coord in old_inside:
			# 擦除原图块
			tile_map.erase_cell(TILE_CHOSEN_LAYER_IDX, coord)


func handle_mouse_hover_border(_delta: float) -> bool:
	var border_coord: Vector2i = get_border_coord()
	if border_coord == _mouse_hover_border_coord:
		return false
	clear_pre_mouse_hover_border_selection()
	_mouse_hover_border_coord = border_coord
	return true


func clear_pre_mouse_hover_border_selection() -> void:
	# 清理之前的边界图块
	if _mouse_hover_border_coord != NULL_COORD:
		border_tile_map.erase_cell(BORDER_CHOSEN_LAYER_IDX, _mouse_hover_border_coord)


func paint_new_chosen_area(renew: bool = false) -> void:
	var map_coord: Vector2i = get_map_coord()
	var border_coord: Vector2i = get_border_coord()
	# 只在放置模式下绘制鼠标悬浮地块
	if gui.get_rt_tab_status() != MapEditorGUI.TabStatus.PLACE:
		return
	if renew:
		clear_pre_mouse_hover_tile_selection()
		clear_pre_mouse_hover_border_selection()
	
	match gui.place_mode:
		MapEditorGUI.PlaceMode.RIVER:
			do_paint_chosen_border_area(border_coord, self.is_river_placable)
		MapEditorGUI.PlaceMode.CLIFF:
			do_paint_chosen_border_area(border_coord, self.is_cliff_placable)
		MapEditorGUI.PlaceMode.TERRAIN:
			var dist: int = gui.get_painter_size_dist()
			var new_inside: Array[Vector2i] = get_surrounding_cells(map_coord, dist, true)
			for coord in new_inside:
				# 新增新图块
				tile_map.set_cell(TILE_CHOSEN_LAYER_IDX, coord, 17, Vector2i(0, 0))
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var placable: Callable = func(x) -> bool: return is_landscape_placable(x, gui.landscape_type)
			do_paint_chosen_tile_area(map_coord, placable)
		MapEditorGUI.PlaceMode.VILLAGE:
			do_paint_chosen_tile_area(map_coord, self.is_village_placable)
		MapEditorGUI.PlaceMode.RESOURCE:
			var placable: Callable = func(x) -> bool: return is_resource_placable(x, gui.resource_type)
			do_paint_chosen_tile_area(map_coord, placable)
		MapEditorGUI.PlaceMode.CONTINENT:
			var dist: int = gui.get_painter_size_dist()
			var new_inside: Array[Vector2i] = get_surrounding_cells(map_coord, dist, true)
			for coord in new_inside:
				do_paint_chosen_tile_area(coord, self.is_continent_placable)


func do_paint_chosen_tile_area(map_coord: Vector2i, placable: Callable) -> void:
	if placable.call(map_coord):
		tile_map.set_cell(TILE_CHOSEN_LAYER_IDX, map_coord, 17, Vector2i(0, 0))
	else:
		tile_map.set_cell(TILE_CHOSEN_LAYER_IDX, map_coord, 18, Vector2i(0, 0))


func do_paint_chosen_border_area(border_coord: Vector2i, placable: Callable) -> void:
	if is_in_map_border(border_coord) <= 0:
		return
	match Map.get_border_type(border_coord):
		Map.BorderType.VERTICAL:
			if placable.call(border_coord):
				border_tile_map.set_cell(BORDER_CHOSEN_LAYER_IDX, border_coord, 8, Vector2i(0, 0))
			else:
				border_tile_map.set_cell(BORDER_CHOSEN_LAYER_IDX, border_coord, 11, Vector2i(0, 0))
		Map.BorderType.SLASH:
			if placable.call(border_coord):
				border_tile_map.set_cell(BORDER_CHOSEN_LAYER_IDX, border_coord, 7, Vector2i(0, 0))
			else:
				border_tile_map.set_cell(BORDER_CHOSEN_LAYER_IDX, border_coord, 10, Vector2i(0, 0))
		Map.BorderType.BACK_SLASH:
			if placable.call(border_coord):
				border_tile_map.set_cell(BORDER_CHOSEN_LAYER_IDX, border_coord, 6, Vector2i(0, 0))
			else:
				border_tile_map.set_cell(BORDER_CHOSEN_LAYER_IDX, border_coord, 9, Vector2i(0, 0))


func is_in_map_tile(coord: Vector2i) -> bool:
	var map_size: Vector2i = Map.SIZE_DICT[_map.size]
	return coord.x >= 0 and coord.x < map_size.x and coord.y >= 0 and coord.y < map_size.y


func is_landscape_placable(tile_coord: Vector2i, landscape: Map.LandscapeType) -> bool:
	# 超出地图范围的不处理
	if not is_in_map_tile(tile_coord):
		return false
	if not is_landscape_placable_terrain(landscape, _map.get_map_tile_info_at(tile_coord).type):
		return false
	match landscape:
		Map.LandscapeType.FLOOD:
			## 泛滥平原需要放在沿河的沙漠
			return is_flood_placable_borders(tile_coord)
		Map.LandscapeType.OASIS:
			## 绿洲需要放在周围全是沙漠/沙漠丘陵/沙漠山脉地块的沙漠，而且不能和其他绿洲相邻
			return is_oasis_placable_surroundings(tile_coord)
		_:
			return true


func is_landscape_placable_terrain(landscape: Map.LandscapeType, terrain_type: Map.TerrainType) -> bool:
	match landscape:
		Map.LandscapeType.ICE:
			return is_ice_placable_terrain(terrain_type)
		Map.LandscapeType.FOREST:
			return is_forest_placable_terrain(terrain_type)
		Map.LandscapeType.SWAMP:
			return is_swamp_placable_terrain(terrain_type)
		Map.LandscapeType.FLOOD:
			return is_flood_placable_terrain(terrain_type)
		Map.LandscapeType.OASIS:
			return is_oasis_placable_terrain(terrain_type)
		Map.LandscapeType.RAINFOREST:
			return is_rainforest_placable_terrain(terrain_type)
		Map.LandscapeType.EMPTY:
			return true
		_:
			printerr("is_landscape_placable_tile | unknown landscape: ", landscape)
			return false


func is_ice_placable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.SHORE or terrain_type == Map.TerrainType.OCEAN


func is_forest_placable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.GRASS or terrain_type == Map.TerrainType.GRASS_HILL \
			or terrain_type == Map.TerrainType.PLAIN or terrain_type == Map.TerrainType.PLAIN_HILL \
			or terrain_type == Map.TerrainType.TUNDRA or terrain_type == Map.TerrainType.TUNDRA_HILL


func is_swamp_placable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.GRASS


func is_flood_placable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.DESERT


func is_flood_placable_borders(tile_coord: Vector2i) -> bool:
	var borders: Array[Vector2i] = Map.get_all_tile_border(tile_coord, false)
	for border in borders:
		if _map.get_border_tile_info_at(border).type == Map.BorderTileType.RIVER:
			return true
	return false


func is_oasis_placable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.DESERT


func is_oasis_placable_surroundings(tile_coord: Vector2i) -> bool:
	var surroundings: Array[Vector2i] = get_surrounding_cells(tile_coord, 1, false)
	for surrounding in surroundings:
		var tile_info: Map.TileInfo = _map.get_map_tile_info_at(surrounding)
		if tile_info.type != Map.TerrainType.DESERT \
				and tile_info.type != Map.TerrainType.DESERT_HILL \
				and tile_info.type != Map.TerrainType.DESERT_MOUNTAIN:
			return false
		if tile_info.landscape == Map.LandscapeType.OASIS:
			return false
	return true


func is_rainforest_placable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.GRASS or terrain_type == Map.TerrainType.GRASS_HILL \
			or terrain_type == Map.TerrainType.PLAIN or terrain_type == Map.TerrainType.PLAIN_HILL


func is_village_placable(tile_coord: Vector2i) -> bool:
	# 超出地图范围的不处理
	if not is_in_map_tile(tile_coord):
		return false
	return is_village_placable_terrain(_map.get_map_tile_info_at(tile_coord).type)


func is_village_placable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type == Map.TerrainType.GRASS or terrain_type == Map.TerrainType.GRASS_HILL \
			or terrain_type == Map.TerrainType.PLAIN or terrain_type == Map.TerrainType.PLAIN_HILL \
			or terrain_type == Map.TerrainType.DESERT or terrain_type == Map.TerrainType.DESERT_HILL \
			or terrain_type == Map.TerrainType.TUNDRA or terrain_type == Map.TerrainType.TUNDRA_HILL \
			or terrain_type == Map.TerrainType.SNOW or terrain_type == Map.TerrainType.SNOW_HILL


func is_resource_placable(tile_coord: Vector2i, type: Map.ResourceType) -> bool:
	# 超出地图范围的不处理
	if not is_in_map_tile(tile_coord):
		return false
	var tile_info: Map.TileInfo = _map.get_map_tile_info_at(tile_coord)
	return is_resource_placable_terrain_and_landscape(type, tile_info.type, tile_info.landscape)


func is_resource_placable_terrain_and_landscape(resource: Map.ResourceType, \
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
			return terrain == Map.TerrainType.GRASS and landscape == Map.LandscapeType.RAINFOREST
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
			# FIXME: 网上百科里的判定条件怪怪的
			return terrain == Map.TerrainType.PLAIN \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.WRECKAGE:
			return terrain == Map.TerrainType.SHORE \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.TOBACCO:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and (landscape == Map.LandscapeType.FOREST or landscape == Map.LandscapeType.RAINFOREST)
		Map.ResourceType.COAL:
			return (terrain == Map.TerrainType.GRASS_HILL or terrain == Map.TerrainType.PLAIN_HILL) \
					and landscape == Map.LandscapeType.FOREST
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
			return terrain == Map.TerrainType.TUNDRA and landscape == Map.LandscapeType.FOREST
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
					or (terrain == Map.TerrainType.DESERT and landscape == Map.LandscapeType.FLOOD) \
					or landscape == Map.LandscapeType.SWAMP
		Map.ResourceType.GYPSUM:
			return (terrain == Map.TerrainType.PLAIN or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT_HILL or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.SALTPETER:
			return ((terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and (landscape == Map.LandscapeType.EMPTY or landscape == Map.LandscapeType.FLOOD)) \
					or ((terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.TUNDRA) \
					and landscape == Map.LandscapeType.EMPTY)
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
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.FOREST
		Map.ResourceType.HONEY:
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.CRAB:
			return terrain == Map.TerrainType.SHORE and landscape == Map.LandscapeType.EMPTY
		Map.ResourceType.IVORY:
			# FIXME: 这里条件是不是有问题？沙漠貌似无法满足
			return (terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.PLAIN \
					or terrain == Map.TerrainType.PLAIN_HILL) \
					and (landscape == Map.LandscapeType.RAINFOREST or landscape == Map.LandscapeType.FOREST)
		Map.ResourceType.DIAMOND:
			return (terrain == Map.TerrainType.GRASS_HILL or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT_HILL or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.RAINFOREST
		Map.ResourceType.URANIUM:
			# FIXME: 沙漠和雪地和森林雨林冲突
			return (terrain == Map.TerrainType.GRASS or terrain == Map.TerrainType.GRASS_HILL \
					or terrain == Map.TerrainType.PLAIN or terrain == Map.TerrainType.PLAIN_HILL \
					or terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.DESERT_HILL \
					or terrain == Map.TerrainType.TUNDRA or terrain == Map.TerrainType.TUNDRA_HILL \
					or terrain == Map.TerrainType.SNOW or terrain == Map.TerrainType.SNOW_HILL) \
					and (landscape == Map.LandscapeType.RAINFOREST or landscape == Map.LandscapeType.FOREST)
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
			# FIXME: 这里条件是不是有问题？沙漠、沙漠丘陵貌似无法满足
			return (terrain == Map.TerrainType.DESERT or terrain == Map.TerrainType.DESERT_HILL \
					or terrain == Map.TerrainType.PLAIN) \
					and landscape == Map.LandscapeType.RAINFOREST
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
			return (terrain == Map.TerrainType.TUNDRA or terrain == Map.TerrainType.TUNDRA_HILL) \
					and landscape == Map.LandscapeType.FOREST
	return false


func is_continent_placable(tile_coord: Vector2i) -> bool:
	# 超出地图范围的不处理
	if not is_in_map_tile(tile_coord):
		return false
	return is_continent_placable_terrain(_map.get_map_tile_info_at(tile_coord).type)


func is_continent_placable_terrain(terrain_type: Map.TerrainType) -> bool:
	return terrain_type != Map.TerrainType.SHORE and terrain_type != Map.TerrainType.OCEAN


func is_in_map_border(border_coord: Vector2i) -> int:
	var neighbor_tile_coords: Array[Vector2i] = Map.get_neighbor_tile_of_border(border_coord)
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
	if is_in_map_border(border_coord) <= 0 or Map.get_border_type(border_coord) == Map.BorderType.CENTER:
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


func is_cliff_placable(border_coord: Vector2i) -> bool:
	if is_in_map_border(border_coord) <= 0 or Map.get_border_type(border_coord) == Map.BorderType.CENTER:
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
			var border_coord: Vector2i = get_border_coord()
			if _map.get_border_tile_info_at(border_coord).type != Map.BorderTileType.CLIFF:
				return
			paint_border(border_coord, step, Map.BorderTileType.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RIVER:
			var border_coord: Vector2i = get_border_coord()
			if _map.get_border_tile_info_at(border_coord).type != Map.BorderTileType.RIVER:
				return
			paint_border(border_coord, step, Map.BorderTileType.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var tile_coord: Vector2i = get_map_coord()
			if _map.get_map_tile_info_at(tile_coord).landscape == Map.LandscapeType.EMPTY:
				return
			paint_landscape(tile_coord, step, Map.LandscapeType.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.VILLAGE:
			var tile_coord: Vector2i = get_map_coord()
			if _map.get_map_tile_info_at(tile_coord).village == 0:
				return
			paint_village(tile_coord, step, 0)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RESOURCE:
			var tile_coord: Vector2i = get_map_coord()
			if _map.get_map_tile_info_at(tile_coord).resource == Map.ResourceType.EMPTY:
				# FIXME: 4.1 现在的场景 TileMap bug，需要等待 4.2 发布解决。目前先打日志说明一下
#				print("tile map ", tile_coord, " is empty. (if you see a icon, it's because 4.1's bug. Wait for 4.2 update to fix it)")
				return
			paint_resource(tile_coord, step, Map.ResourceType.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
	save_paint_step(step)


func paint_map() -> void:
	var step: PaintStep = PaintStep.new()
	match gui.place_mode:
		MapEditorGUI.PlaceMode.TERRAIN:
			var map_coord: Vector2i = get_map_coord()
			if not _terrain_type_to_tile_dict.has(gui.terrain_type):
				printerr("can't paint unknown tile!")
				return
			var dist: int = gui.get_painter_size_dist()
			var inside: Array[Vector2i] = get_surrounding_cells(map_coord, dist, true)
			for coord in inside:
				# 超出地图范围的不处理
				if not is_in_map_tile(coord):
					continue
				if _map.get_map_tile_info_at(coord).type == gui.terrain_type:
					continue
				paint_terrain(coord, step, gui.terrain_type)
			# 围绕陆地地块绘制浅海
			if gui.terrain_type != Map.TerrainType.SHORE and gui.terrain_type != Map.TerrainType.OCEAN:
				var out_ring: Array[Vector2i] = get_surrounding_cells(map_coord, dist + 1, false)
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
				var borders: Array[Vector2i] = get_surrounding_borders(map_coord, dist)
				for border in borders:
					if is_cliff_placable(border):
						paint_border(border, step, Map.BorderTileType.CLIFF)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var coord: Vector2i = get_map_coord()
			if not is_landscape_placable(coord, gui.landscape_type):
				return
			if _map.get_map_tile_info_at(coord).landscape == gui.landscape_type:
				return
			paint_landscape(coord, step, gui.landscape_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.VILLAGE:
			var coord: Vector2i = get_map_coord()
			if not is_village_placable(coord):
				return
			if _map.get_map_tile_info_at(coord).village == 1:
				return
			paint_village(coord, step, 1)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RESOURCE:
			var coord: Vector2i = get_map_coord()
			if not is_resource_placable(coord, gui.resource_type):
				return
			if _map.get_map_tile_info_at(coord).resource == gui.resource_type:
				return
			paint_resource(coord, step, gui.resource_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.CONTINENT:
			var map_coord: Vector2i = get_map_coord()
			var dist: int = gui.get_painter_size_dist()
			var inside: Array[Vector2i] = get_surrounding_cells(map_coord, dist, true)
			for coord in inside:
				if not is_continent_placable(coord):
					continue
				if _map.get_map_tile_info_at(coord).continent == gui.continent_type:
					continue
				paint_continent(coord, step, gui.continent_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.CLIFF:
			var border_coord: Vector2i = get_border_coord()
			if not is_cliff_placable(border_coord):
				return
			if _map.get_border_tile_info_at(border_coord).type == Map.BorderTileType.CLIFF:
				return
			# 绘制边界悬崖
			paint_border(border_coord, step, Map.BorderTileType.CLIFF)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RIVER:
			var border_coord: Vector2i = get_border_coord()
			if not is_river_placable(border_coord):
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


func copy_tile_info(from: Map.TileInfo) -> Map.TileInfo:
	var to: Map.TileInfo = Map.TileInfo.new(from.type)
	to.landscape = from.landscape
	to.village = from.village
	to.resource = from.resource
	to.continent = from.continent
	return to


func paint_terrain(coord: Vector2i, step: PaintStep, terrain_type: Map.TerrainType):
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = coord
	change.tile_change_type = TileChangeType.TERRAIN
	change.tile_change = true
	change.before = _map.get_map_tile_info_at(coord)
	change.after = copy_tile_info(change.before)
	change.after.type = terrain_type
	
	if change.before.landscape != Map.LandscapeType.EMPTY \
			and not is_landscape_placable_terrain(change.before.landscape, terrain_type):
		change.after.landscape = Map.LandscapeType.EMPTY
	if change.before.village == 1 and not is_village_placable_terrain(terrain_type):
		change.after.village = 0
	
	if change.before.continent != Map.ContinentType.EMPTY \
			and not is_continent_placable_terrain(terrain_type):
		change.after.continent = Map.ContinentType.EMPTY
	elif is_continent_placable_terrain(terrain_type) and change.before.continent == Map.ContinentType.EMPTY:
		# 从海变陆时需要给个默认的大洲
		change.after.continent = gui.continent_type
	
	if change.before.resource != Map.ResourceType.EMPTY \
			and not is_resource_placable_terrain_and_landscape(change.before.resource, terrain_type, change.after.landscape):
		change.after.resource = Map.ResourceType.EMPTY
	
	step.changed_arr.append(change)
	
	# 记录地图地块信息
	_map.change_map_tile_info(coord, change.after)
	# 重新绘制整个 TileMap 地块
	do_paint_tile(coord, change.after)
	
	# 对周围一圈边界进行校验，不符合的边界需要重置为空
	var borders: Array[Vector2i] = Map.get_all_tile_border(coord, false)
	for border in borders:
		var border_info: Map.BorderInfo = _map.get_border_tile_info_at(border)
		if border_info.type == Map.BorderTileType.CLIFF:
			if not is_cliff_placable(border):
				paint_border(border, step, Map.BorderTileType.EMPTY)
		elif border_info.type == Map.BorderTileType.RIVER:
			if not is_river_placable(border):
				paint_border(border, step, Map.BorderTileType.EMPTY)


func do_paint_tile(coord: Vector2i, tile_info: Map.TileInfo) -> void:
	do_paint_terrain(coord, tile_info.type)
	do_paint_landscape(coord, tile_info.landscape)
	do_paint_village(coord, tile_info.village)
	do_paint_continent(coord, tile_info.continent)
	do_paint_resource(coord, tile_info.resource)


func do_paint_terrain(coord: Vector2i, type: Map.TerrainType) -> void:
	var tile: MapTileCell = _terrain_type_to_tile_dict[type]
	tile_map.set_cell(TILE_TERRAIN_LAYER_IDX, coord, tile.source_id, tile.atlas_coords)


func paint_landscape(tile_coord: Vector2i, step: PaintStep, type: Map.LandscapeType) -> void:
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = tile_coord
	change.tile_change = true
	change.tile_change_type = TileChangeType.LANDSCAPE
	change.before = _map.get_map_tile_info_at(tile_coord)
	change.after = copy_tile_info(change.before)
	change.after.landscape = type
	
	if change.before.resource == Map.ResourceType.EMPTY \
			and not is_resource_placable_terrain_and_landscape(change.before.resource, change.before.type, type):
		change.after.resource = Map.ResourceType.EMPTY
		do_paint_resource(tile_coord, Map.ResourceType.EMPTY)
	
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_map_tile_info(tile_coord, change.after)
	# 真正绘制地貌
	do_paint_landscape(tile_coord, type)


func do_paint_landscape(tile_coord: Vector2i, type: Map.LandscapeType) -> void:
	match type:
		Map.LandscapeType.ICE:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 19, Vector2i.ZERO)
		Map.LandscapeType.FOREST:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 20, Vector2i.ZERO)
		Map.LandscapeType.SWAMP:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 21, Vector2i.ZERO)
		Map.LandscapeType.FLOOD:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 22, Vector2i.ZERO)
		Map.LandscapeType.OASIS:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 23, Vector2i.ZERO)
		Map.LandscapeType.RAINFOREST:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 24, Vector2i.ZERO)
		Map.LandscapeType.EMPTY:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, -1)


func paint_village(tile_coord: Vector2i, step: PaintStep, type: int) -> void:
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = tile_coord
	change.tile_change = true
	change.tile_change_type = TileChangeType.VILLAGE
	change.before = _map.get_map_tile_info_at(tile_coord)
	change.after = copy_tile_info(change.before)
	change.after.village = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_map_tile_info(tile_coord, change.after)
	# 真正绘制村庄
	do_paint_village(tile_coord, type)


func do_paint_village(tile_coord: Vector2i, type: int):
	if type == 0:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, -1)
	else:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, 25, Vector2i.ZERO)


func paint_resource(tile_coord: Vector2i, step: PaintStep, type: Map.ResourceType) -> void:
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = tile_coord
	change.tile_change = true
	change.tile_change_type = TileChangeType.RESOURCE
	change.before = _map.get_map_tile_info_at(tile_coord)
	change.after = copy_tile_info(change.before)
	change.after.resource = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_map_tile_info(tile_coord, change.after)
	# 真正绘制资源
	do_paint_resource(tile_coord, type)


func do_paint_resource(tile_coord: Vector2i, type: Map.ResourceType) -> void:
	# 清除原来的资源图标
	if _coord_to_resource_icon_dict.has(tile_coord):
		_coord_to_resource_icon_dict[tile_coord].queue_free()
		_coord_to_resource_icon_dict.erase(tile_coord)
	if type == Map.ResourceType.EMPTY:
		# FIXME：4.1 有 bug，TileMap 没办法把实例化的场景清除。现在的场景 TileMap 简直不能用…… 太蠢了
		# 静待 4.2 发布，看 GitHub 讨论区貌似在 4.2 得到了修复。在修复前，会有资源显示和实际数据不一致的情况
		# 对应的讨论区：https://github.com/godotengine/godot/issues/69596
#			print("do_paint_resource empty: ", tile_coord, " (tile map won't update until 4.2 is relased)")
#			tile_map.set_cell(TILE_RESOURCE_LAYER_IDX, tile_coord, -1, Vector2i(-1, -1), -1)
		pass
	else:
		# 保证资源图标场景的排序和 ResourseType 中一致
#		tile_map.set_cell(TILE_RESOURCE_LAYER_IDX, tile_coord, 27, Vector2i.ZERO, type)
		var scene: PackedScene = RESOURCE_TYPE_TO_ICON_SCENE_DICT[type]
		var sprite := scene.instantiate() as Sprite2D
		sprite.global_position = tile_map.to_global(tile_map.map_to_local(tile_coord)) + Vector2(0, 60)
		_coord_to_resource_icon_dict[tile_coord] = sprite
		resource_icons.add_child(sprite)


func paint_continent(tile_coord: Vector2i, step: PaintStep, type: Map.ContinentType) -> void:
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = tile_coord
	change.tile_change = true
	change.tile_change_type = TileChangeType.CONTINENT
	change.before = _map.get_map_tile_info_at(tile_coord)
	change.after = copy_tile_info(change.before)
	change.after.continent = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_map_tile_info(tile_coord, change.after)
	# 真正绘制大洲
	do_paint_continent(tile_coord, type)


func do_paint_continent(tile_coord: Vector2i, type: Map.ContinentType) -> void:
	if type == Map.ContinentType.EMPTY:
		tile_map.erase_cell(TILE_CONTINENT_LAYER_IDX, tile_coord)
	else:
		tile_map.set_cell(TILE_CONTINENT_LAYER_IDX, tile_coord, 26, Vector2i((type - 1) % 10, (type - 1) / 10))


func paint_border(border_coord: Vector2i, step: PaintStep, type: Map.BorderTileType) -> void:
	# 记录操作
	var change: PaintChange = PaintChange.new()
	change.coord = border_coord
	change.tile_change = false
	change.before_border = _map.get_border_tile_info_at(border_coord)
	change.after_border = Map.BorderInfo.new(type)
	step.changed_arr.append(change)
	# 记录地图地块信息
	_map.change_border_tile_info(border_coord, change.after_border)
	# 真正绘制边界
	match type:
		Map.BorderTileType.RIVER:
			paint_river(border_coord)
		Map.BorderTileType.CLIFF:
			paint_cliff(border_coord)
		Map.BorderTileType.EMPTY:
			# 真正绘制边界为空
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, -1)


func paint_cliff(border_coord: Vector2i) -> void:
	match Map.get_border_type(border_coord):
		Map.BorderType.BACK_SLASH:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 0, Vector2i.ZERO)
		Map.BorderType.SLASH:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 1, Vector2i.ZERO)
		Map.BorderType.VERTICAL:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 2, Vector2i.ZERO)


func paint_river(border_coord: Vector2i) -> void:
	match Map.get_border_type(border_coord):
		Map.BorderType.BACK_SLASH:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 3, Vector2i.ZERO)
		Map.BorderType.SLASH:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 4, Vector2i.ZERO)
		Map.BorderType.VERTICAL:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 5, Vector2i.ZERO)


func get_surrounding_cells(map_coord: Vector2i, dist: int, include_inside: bool) -> Array[Vector2i]:
	if dist < 0:
		return []
	# 从坐标到是否边缘的布尔值的映射
	var dict: Dictionary = get_tile_coord_to_rim_bool_dict(map_coord, dist)
	var result: Array[Vector2i] = []
	for k in dict:
		if not include_inside and not dict[k]:
			continue
		result.append(k)
	return result


## TODO: 目前获取边界效率比较低，未来可以重构这个逻辑
func get_surrounding_borders(map_coord: Vector2i, dist: int) -> Array[Vector2i]:
	if dist < 0:
		return []
	# 从坐标到是否边缘的布尔值的映射
	var dict: Dictionary = get_tile_coord_to_rim_bool_dict(map_coord, dist)
	var result: Array[Vector2i] = []
	for coord in dict:
		if not dict[coord]:
			# 非边缘的直接跳过
			continue
		var borders: Array[Vector2i] = Map.get_all_tile_border(coord, false)
		for border in borders:
			var neighbors: Array[Vector2i] = Map.get_neighbor_tile_of_border(border)
			var count_out: int = 0
			for neighbor in neighbors:
				if not dict.has(neighbor):
					count_out += 1
			if count_out == 1:
				result.append(border)
	return result


## TODO: 目前基于 TileMap 既有 API 实现的，所以效率比较低，未来可以自己实现这个逻辑
func get_tile_coord_to_rim_bool_dict(map_coord: Vector2i, dist: int) -> Dictionary:
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
	return dict


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
			do_paint_terrain(coord, tile_info.type)
			do_paint_landscape(coord, tile_info.landscape)
			do_paint_village(coord, tile_info.village)
			do_paint_resource(coord, tile_info.resource)
			if is_continent_placable(coord):
				do_paint_continent(coord, tile_info.continent)
	# 读取边界
	for i in range(size.x * 2 + 2):
		for j in range(size.y * 2 + 2):
			var coord := Vector2i(i, j)
			do_paint_border(coord, _map.get_border_tile_info_at(coord).type)


func initialize_map() -> void:
	_map = Map.new()
	if _map.type == Map.Type.BLANK:
		# 修改 TileMap 图块
		var size: Vector2i = Map.SIZE_DICT[_map.size]
		var ocean_cell: MapTileCell = _terrain_type_to_tile_dict[Map.TerrainType.OCEAN]
		for i in range(0, size.x, 1):
			for j in range(0, size.y, 1):
				tile_map.set_cell(TILE_TERRAIN_LAYER_IDX, Vector2i(i, j), ocean_cell.source_id, ocean_cell.atlas_coords)


func initialize_camera(map_size: Map.Size) -> void:
	var size: Vector2i = Map.SIZE_DICT[map_size]
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
	var tile_change: bool
	var tile_change_type: TileChangeType = TileChangeType.TERRAIN
	var before: Map.TileInfo
	var after: Map.TileInfo
	var before_border: Map.BorderInfo
	var after_border: Map.BorderInfo

