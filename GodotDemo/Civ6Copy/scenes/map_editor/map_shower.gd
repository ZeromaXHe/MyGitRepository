class_name MapShower
extends Node2D


# TileMap 层索引
const TILE_TERRAIN_LAYER_IDX: int = 0
const TILE_LANDSCAPE_LAYER_IDX: int = 1
const TILE_VILLAGE_LAYER_IDX: int = 2
const TILE_CONTINENT_LAYER_IDX: int = 3
const TILE_CHOSEN_LAYER_IDX: int = 4
const TILE_RESOURCE_LAYER_IDX: int = 5
const TILE_OUT_SIGHT_LAYER_IDX: int = 6
const TILE_IN_SIGHT_LAYER_IDX: int = 7
const TILE_MOVE_LAYER_IDX: int = 8
# 地形集索引
const TERRAIN_SET_IDX: int = 0
const MOVE_TERRAIN_IDX: int = 0
const SIGHT_TERRAIN_IDX: int = 1
# BorderTileMap 层索引
const BORDER_TILE_LAYER_IDX: int = 0
const BORDER_CHOSEN_LAYER_IDX: int = 1

static var singleton: MapShower
static var singleton_minimap: MapShower

@export var minimap: bool = false

# 地块类型到 TileSet source id 信息映射
var _terrain_type_to_src_id_dict : Dictionary = {
	TerrainTable.Enum.GRASS: [0, 0],
	TerrainTable.Enum.GRASS_HILL: [1, 0],
	TerrainTable.Enum.GRASS_MOUNTAIN: [2, 2],
	TerrainTable.Enum.PLAIN: [3, 3],
	TerrainTable.Enum.PLAIN_HILL: [4, 3],
	TerrainTable.Enum.PLAIN_MOUNTAIN: [5, 5],
	TerrainTable.Enum.DESERT: [6, 6],
	TerrainTable.Enum.DESERT_HILL: [7, 6],
	TerrainTable.Enum.DESERT_MOUNTAIN: [8, 8],
	TerrainTable.Enum.TUNDRA: [9, 9],
	TerrainTable.Enum.TUNDRA_HILL: [10, 9],
	TerrainTable.Enum.TUNDRA_MOUNTAIN: [11, 11],
	TerrainTable.Enum.SNOW: [12, 12],
	TerrainTable.Enum.SNOW_HILL: [13, 12],
	TerrainTable.Enum.SNOW_MOUNTAIN: [14, 14],
	TerrainTable.Enum.SHORE: [15, 15],
	TerrainTable.Enum.OCEAN: [16, 16],
}

@onready var border_tile_map: TileMap = $BorderTileMap
@onready var tile_map: TileMap = $TileMap


func _ready() -> void:
	hide_continent_layer()
	if minimap:
		singleton_minimap = self
	else:
		singleton = self
	
	if GlobalScript.load_map:
		load_map()
	else:
		GlobalScript.record_time()
		MapService.init_map_tile_table()
		MapService.init_map_border_table()
	
	# 读取地块
	GlobalScript.load_info = "填涂地图地块..."
	var size_vec: Vector2i = MapService.get_map_tile_size_vec()
	for i in range(size_vec.x):
		for j in range(size_vec.y):
			var coord := Vector2i(i, j)
			var tile_do: MapTileDO = MapTileService.get_map_tile_do_by_coord(coord)
			paint_tile(coord, tile_do)
	GlobalScript.log_used_time_from_last_record("MapShower.initialize", "painting map tiles")
	
	# 读取边界
	GlobalScript.load_info = "填涂地图边界块..."
	var border_size_vec: Vector2i = MapService.get_border_tile_size_vec()
	for i in range(border_size_vec.x):
		for j in range(border_size_vec.y):
			var coord := Vector2i(i, j)
			paint_border(coord, MapService.get_map_border_do_by_coord(coord).tile_type)
	GlobalScript.log_used_time_from_last_record("MapShower.initialize", "painting border tiles")


func load_map() -> void:
	if not MapService.load_from_save():
		printerr("you have no map save")


func hide_continent_layer() -> void:
	tile_map.set_layer_enabled(MapShower.TILE_CONTINENT_LAYER_IDX, false)


func show_continent_layer() -> void:
	tile_map.set_layer_enabled(MapShower.TILE_CONTINENT_LAYER_IDX, true)


func get_border_coord() -> Vector2i:
	return global_position_to_border_coord(get_global_mouse_position())


func global_position_to_border_coord(global_posi: Vector2) -> Vector2i:
	return border_tile_map.local_to_map(border_tile_map.to_local(global_posi))


func border_coord_to_global_position(border_coord: Vector2i) -> Vector2:
	return border_tile_map.to_global(border_tile_map.map_to_local(border_coord))


func get_mouse_map_coord() -> Vector2i:
	return global_position_to_map_coord(get_global_mouse_position())


func global_position_to_map_coord(global_posi: Vector2) -> Vector2i:
	return tile_map.local_to_map(tile_map.to_local(global_posi))


func map_coord_to_global_position(map_coord: Vector2i) -> Vector2:
	return tile_map.to_global(tile_map.map_to_local(map_coord))


func paint_out_sight_tile_areas(coord: Vector2i, type: PlayerSightTable.Sight) -> void:
	match type:
		PlayerSightTable.Sight.UNSEEN:
			tile_map.set_cell(TILE_OUT_SIGHT_LAYER_IDX, coord, 31, Vector2i.ZERO)
		PlayerSightTable.Sight.SEEN:
			tile_map.set_cell(TILE_OUT_SIGHT_LAYER_IDX, coord, 30, Vector2i.ZERO)
	tile_map.erase_cell(TILE_IN_SIGHT_LAYER_IDX, coord)
	# 更新周围视野范围内受影响的地块
	var surroundings: Array[Vector2i] = tile_map.get_surrounding_cells(coord)
	var cells: Array[Vector2i] = []
	for surround in surroundings:
		if is_in_sight_tile_area(surround):
			cells.append(surround)
			tile_map.erase_cell(TILE_IN_SIGHT_LAYER_IDX, surround)
	if not cells.is_empty():
		tile_map.set_cells_terrain_connect(TILE_IN_SIGHT_LAYER_IDX, cells, TERRAIN_SET_IDX, SIGHT_TERRAIN_IDX)


func paint_in_sight_tile_areas(cells: Array[Vector2i]) -> void:
	tile_map.set_cells_terrain_connect(TILE_IN_SIGHT_LAYER_IDX, cells, TERRAIN_SET_IDX, SIGHT_TERRAIN_IDX)
	for coord in cells:
		tile_map.erase_cell(TILE_OUT_SIGHT_LAYER_IDX, coord)


func is_in_sight_tile_area(coord: Vector2i) -> bool:
	return tile_map.get_cell_source_id(TILE_IN_SIGHT_LAYER_IDX, coord) != -1


func paint_move_tile_areas(cells: Array[Vector2i]) -> void:
	tile_map.set_cells_terrain_connect(TILE_MOVE_LAYER_IDX, cells, TERRAIN_SET_IDX, MOVE_TERRAIN_IDX)


func clear_move_tile_areas() -> void:
	tile_map.clear_layer(TILE_MOVE_LAYER_IDX)


func is_in_move_tile_areas(coord: Vector2i) -> bool:
	return tile_map.get_cell_source_id(TILE_MOVE_LAYER_IDX, coord) != -1


func paint_chosen_tile_area(map_coord: Vector2i, placeable: Callable) -> void:
	if placeable.call(map_coord):
		paint_tile_chosen_placeable(map_coord)
	else:
		paint_tile_chosen_unplaceable(map_coord)


func paint_tile_chosen_placeable(tile_coord: Vector2i) -> void:
	tile_map.set_cell(MapShower.TILE_CHOSEN_LAYER_IDX, tile_coord, 17, Vector2i(0, 0))


func paint_tile_chosen_unplaceable(tile_coord: Vector2i) -> void:
	tile_map.set_cell(MapShower.TILE_CHOSEN_LAYER_IDX, tile_coord, 18, Vector2i(0, 0))


func paint_chosen_border_area(border_coord: Vector2i, placeable: Callable) -> void:
	if is_in_map_border(border_coord) <= 0:
		return
	match MapBorderUtils.get_border_type(border_coord):
		MapBorderTable.Type.VERTICAL:
			if placeable.call(border_coord):
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 8, Vector2i(0, 0))
			else:
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 11, Vector2i(0, 0))
		MapBorderTable.Type.SLASH:
			if placeable.call(border_coord):
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 7, Vector2i(0, 0))
			else:
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 10, Vector2i(0, 0))
		MapBorderTable.Type.BACK_SLASH:
			if placeable.call(border_coord):
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 6, Vector2i(0, 0))
			else:
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 9, Vector2i(0, 0))


func clear_tile_chosen() -> void:
	# 擦除选择层全部图块
	tile_map.clear_layer(MapShower.TILE_CHOSEN_LAYER_IDX)


func clear_border_chosen() -> void:
	border_tile_map.clear_layer(MapShower.BORDER_CHOSEN_LAYER_IDX)


func is_in_map_border(border_coord: Vector2i) -> int:
	var neighbor_tile_coords: Array[Vector2i] = MapBorderUtils.get_neighbor_tile_of_border(border_coord)
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


func paint_tile(coord: Vector2i, tile_do: MapTileDO) -> void:
	paint_terrain(coord, tile_do.terrain)
	paint_landscape(coord, tile_do.landscape)
	paint_village(coord, tile_do.village)
	paint_continent(coord, tile_do.continent)
	paint_resource(coord, tile_do.resource)


func paint_terrain(coord: Vector2i, type: TerrainTable.Enum) -> void:
	var src_ids: Array = _terrain_type_to_src_id_dict[type]
	tile_map.set_cell(TILE_TERRAIN_LAYER_IDX, coord, src_ids[1 if minimap else 0], Vector2i.ZERO)


func paint_landscape(tile_coord: Vector2i, type: LandscapeTable.Enum) -> void:
	if minimap:
		return
	match type:
		LandscapeTable.Enum.ICE:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 19, Vector2i.ZERO)
		LandscapeTable.Enum.FOREST:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 20, Vector2i.ZERO)
		LandscapeTable.Enum.SWAMP:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 21, Vector2i.ZERO)
		LandscapeTable.Enum.FLOOD:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 22, Vector2i.ZERO)
		LandscapeTable.Enum.OASIS:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 23, Vector2i.ZERO)
		LandscapeTable.Enum.RAINFOREST:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 24, Vector2i.ZERO)
		LandscapeTable.Enum.EMPTY:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, -1)


func paint_village(tile_coord: Vector2i, village: bool):
	if minimap:
		return
	if village:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, 25, Vector2i.ZERO)
	else:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, -1)


func paint_city(tile_coord: Vector2i, type: int):
	if type == 0:
		tile_map.erase_cell(TILE_VILLAGE_LAYER_IDX, tile_coord)
	else:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, 32, Vector2i.ZERO)


func paint_resource(tile_coord: Vector2i, type: ResourceTable.Enum) -> void:
	if minimap:
		return
	if type == ResourceTable.Enum.EMPTY:
		tile_map.erase_cell(TILE_RESOURCE_LAYER_IDX, tile_coord)
		pass
	else:
		# 保证资源图标场景的排序和 ResourseType 中一致
		tile_map.set_cell(TILE_RESOURCE_LAYER_IDX, tile_coord, 27, Vector2i.ZERO, type)


func paint_continent(tile_coord: Vector2i, type: ContinentTable.Enum) -> void:
	if minimap:
		return
	if type == ContinentTable.Enum.EMPTY:
		tile_map.erase_cell(TILE_CONTINENT_LAYER_IDX, tile_coord)
	else:
		tile_map.set_cell(TILE_CONTINENT_LAYER_IDX, tile_coord, 26, Vector2i((type - 1) % 10, (type - 1) / 10))


func paint_border(border_coord: Vector2i, type: MapBorderTable.Enum) -> void:
	match type:
		MapBorderTable.Enum.RIVER:
			paint_river(border_coord)
		MapBorderTable.Enum.CLIFF:
			paint_cliff(border_coord)
		MapBorderTable.Enum.EMPTY:
			# 真正绘制边界为空
			border_tile_map.erase_cell(BORDER_TILE_LAYER_IDX, border_coord)


func paint_cliff(border_coord: Vector2i) -> void:
	match MapBorderUtils.get_border_type(border_coord):
		MapBorderTable.Type.BACK_SLASH:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 0, Vector2i.ZERO)
		MapBorderTable.Type.SLASH:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 1, Vector2i.ZERO)
		MapBorderTable.Type.VERTICAL:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 2, Vector2i.ZERO)


func paint_river(border_coord: Vector2i) -> void:
	match MapBorderUtils.get_border_type(border_coord):
		MapBorderTable.Type.BACK_SLASH:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 3, Vector2i.ZERO)
		MapBorderTable.Type.SLASH:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 4, Vector2i.ZERO)
		MapBorderTable.Type.VERTICAL:
			border_tile_map.set_cell(BORDER_TILE_LAYER_IDX, border_coord, 5, Vector2i.ZERO)


func get_map_tile_xy() -> Vector2i:
	return tile_map.tile_set.tile_size

