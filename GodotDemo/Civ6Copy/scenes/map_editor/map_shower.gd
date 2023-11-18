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
# 资源类型和对应资源图标场景的映射字典
const RESOURCE_TYPE_TO_ICON_SCENE_DICT: Dictionary = {
	ResourceTable.ResourceType.SILK: preload("res://scenes/map_editor/resource_tiles/resource_sprite.tscn"),
	ResourceTable.ResourceType.RELIC: preload("res://scenes/map_editor/resource_tiles/sprite_relic.tscn"),
	ResourceTable.ResourceType.COCOA_BEAN: preload("res://scenes/map_editor/resource_tiles/sprite_cocoa_bean.tscn"),
	ResourceTable.ResourceType.COFFEE: preload("res://scenes/map_editor/resource_tiles/sprite_coffee.tscn"),
	ResourceTable.ResourceType.MARBLE: preload("res://scenes/map_editor/resource_tiles/sprite_marble.tscn"),
	ResourceTable.ResourceType.RICE: preload("res://scenes/map_editor/resource_tiles/sprite_rice.tscn"),
	ResourceTable.ResourceType.WHEAT: preload("res://scenes/map_editor/resource_tiles/sprite_wheat.tscn"),
	ResourceTable.ResourceType.TRUFFLE: preload("res://scenes/map_editor/resource_tiles/sprite_truffle.tscn"),
	ResourceTable.ResourceType.ORANGE: preload("res://scenes/map_editor/resource_tiles/sprite_orange.tscn"),
	ResourceTable.ResourceType.DYE: preload("res://scenes/map_editor/resource_tiles/sprite_dye.tscn"),
	ResourceTable.ResourceType.COTTON: preload("res://scenes/map_editor/resource_tiles/sprite_cotton.tscn"),
	ResourceTable.ResourceType.MERCURY: preload("res://scenes/map_editor/resource_tiles/sprite_mercury.tscn"),
	ResourceTable.ResourceType.WRECKAGE: preload("res://scenes/map_editor/resource_tiles/sprite_wreckage.tscn"),
	ResourceTable.ResourceType.TOBACCO: preload("res://scenes/map_editor/resource_tiles/sprite_tobacco.tscn"),
	ResourceTable.ResourceType.COAL: preload("res://scenes/map_editor/resource_tiles/sprite_coal.tscn"),
	ResourceTable.ResourceType.INCENSE: preload("res://scenes/map_editor/resource_tiles/sprite_incense.tscn"),
	ResourceTable.ResourceType.COW: preload("res://scenes/map_editor/resource_tiles/sprite_cow.tscn"),
	ResourceTable.ResourceType.JADE: preload("res://scenes/map_editor/resource_tiles/sprite_jade.tscn"),
	ResourceTable.ResourceType.CORN: preload("res://scenes/map_editor/resource_tiles/sprite_corn.tscn"),
	ResourceTable.ResourceType.PEARL: preload("res://scenes/map_editor/resource_tiles/sprite_pearl.tscn"),
	ResourceTable.ResourceType.FUR: preload("res://scenes/map_editor/resource_tiles/sprite_fur.tscn"),
	ResourceTable.ResourceType.SALT: preload("res://scenes/map_editor/resource_tiles/sprite_salt.tscn"),
	ResourceTable.ResourceType.STONE: preload("res://scenes/map_editor/resource_tiles/sprite_stone.tscn"),
	ResourceTable.ResourceType.OIL: preload("res://scenes/map_editor/resource_tiles/sprite_oil.tscn"),
	ResourceTable.ResourceType.GYPSUM: preload("res://scenes/map_editor/resource_tiles/sprite_gypsum.tscn"),
	ResourceTable.ResourceType.SALTPETER: preload("res://scenes/map_editor/resource_tiles/sprite_saltpeter.tscn"),
	ResourceTable.ResourceType.SUGAR: preload("res://scenes/map_editor/resource_tiles/sprite_sugar.tscn"),
	ResourceTable.ResourceType.SHEEP: preload("res://scenes/map_editor/resource_tiles/sprite_sheep.tscn"),
	ResourceTable.ResourceType.TEA: preload("res://scenes/map_editor/resource_tiles/sprite_tea.tscn"),
	ResourceTable.ResourceType.WINE: preload("res://scenes/map_editor/resource_tiles/sprite_wine.tscn"),
	ResourceTable.ResourceType.HONEY: preload("res://scenes/map_editor/resource_tiles/sprite_honey.tscn"),
	ResourceTable.ResourceType.CRAB: preload("res://scenes/map_editor/resource_tiles/sprite_crab.tscn"),
	ResourceTable.ResourceType.IVORY: preload("res://scenes/map_editor/resource_tiles/sprite_ivory.tscn"),
	ResourceTable.ResourceType.DIAMOND: preload("res://scenes/map_editor/resource_tiles/sprite_diamond.tscn"),
	ResourceTable.ResourceType.URANIUM: preload("res://scenes/map_editor/resource_tiles/sprite_uranium.tscn"),
	ResourceTable.ResourceType.IRON: preload("res://scenes/map_editor/resource_tiles/sprite_iron.tscn"),
	ResourceTable.ResourceType.COPPER: preload("res://scenes/map_editor/resource_tiles/sprite_copper.tscn"),
	ResourceTable.ResourceType.ALUMINIUM: preload("res://scenes/map_editor/resource_tiles/sprite_aluminium.tscn"),
	ResourceTable.ResourceType.SILVER: preload("res://scenes/map_editor/resource_tiles/sprite_silver.tscn"),
	ResourceTable.ResourceType.SPICE: preload("res://scenes/map_editor/resource_tiles/sprite_spice.tscn"),
	ResourceTable.ResourceType.BANANA: preload("res://scenes/map_editor/resource_tiles/sprite_banana.tscn"),
	ResourceTable.ResourceType.HORSE: preload("res://scenes/map_editor/resource_tiles/sprite_horse.tscn"),
	ResourceTable.ResourceType.FISH: preload("res://scenes/map_editor/resource_tiles/sprite_fish.tscn"),
	ResourceTable.ResourceType.WHALE: preload("res://scenes/map_editor/resource_tiles/sprite_whale.tscn"),
	ResourceTable.ResourceType.DEER: preload("res://scenes/map_editor/resource_tiles/sprite_deer.tscn"),
}

# 地块类型到 TileSet 信息映射
var _terrain_type_to_tile_dict : Dictionary = {
	TerrainTable.Terrain.GRASS: MapTileCell.new(0, Vector2i.ZERO),
	TerrainTable.Terrain.GRASS_HILL: MapTileCell.new(1, Vector2i.ZERO),
	TerrainTable.Terrain.GRASS_MOUNTAIN: MapTileCell.new(2, Vector2i.ZERO),
	TerrainTable.Terrain.PLAIN: MapTileCell.new(3, Vector2i.ZERO),
	TerrainTable.Terrain.PLAIN_HILL: MapTileCell.new(4, Vector2i.ZERO),
	TerrainTable.Terrain.PLAIN_MOUNTAIN: MapTileCell.new(5, Vector2i.ZERO),
	TerrainTable.Terrain.DESERT: MapTileCell.new(6, Vector2i.ZERO),
	TerrainTable.Terrain.DESERT_HILL: MapTileCell.new(7, Vector2i.ZERO),
	TerrainTable.Terrain.DESERT_MOUNTAIN: MapTileCell.new(8, Vector2i.ZERO),
	TerrainTable.Terrain.TUNDRA: MapTileCell.new(9, Vector2i.ZERO),
	TerrainTable.Terrain.TUNDRA_HILL: MapTileCell.new(10, Vector2i.ZERO),
	TerrainTable.Terrain.TUNDRA_MOUNTAIN: MapTileCell.new(11, Vector2i.ZERO),
	TerrainTable.Terrain.SNOW: MapTileCell.new(12, Vector2i.ZERO),
	TerrainTable.Terrain.SNOW_HILL: MapTileCell.new(13, Vector2i.ZERO),
	TerrainTable.Terrain.SNOW_MOUNTAIN: MapTileCell.new(14, Vector2i.ZERO),
	TerrainTable.Terrain.SHORE: MapTileCell.new(15, Vector2i.ZERO),
	TerrainTable.Terrain.OCEAN: MapTileCell.new(16, Vector2i.ZERO),
}
# 记录 TileMap 坐标到资源图标的映射的字典
var _coord_to_resource_icon_dict: Dictionary = {}

@onready var border_tile_map: TileMap = $BorderTileMap
@onready var tile_map: TileMap = $TileMap
@onready var resource_icons: Node2D = $ResourceIcons


func _ready() -> void:
	hide_continent_layer()
	ViewHolder.register_map_shower(self)


func initialize() -> void:
	if GlobalScript.load_map:
		load_map()
	else:
		GlobalScript.record_time()
		MapController.init_map()
	
	# 读取地块
	GlobalScript.load_info = "填涂地图地块..."
	var size_vec: Vector2i = MapController.get_map_tile_size_vec()
	for i in range(size_vec.x):
		for j in range(size_vec.y):
			var coord := Vector2i(i, j)
			var tile_do: MapTileDO = MapController.get_map_tile_do_by_coord(coord)
			paint_tile(coord, tile_do)
	GlobalScript.log_used_time_from_last_record("MapShower.initialize", "painting map tiles")
	
	# 读取边界
	GlobalScript.load_info = "填涂地图边界块..."
	var border_size_vec: Vector2i = MapController.get_border_tile_size_vec()
	for i in range(border_size_vec.x):
		for j in range(border_size_vec.y):
			var coord := Vector2i(i, j)
			paint_border(coord, MapController.get_map_border_do_by_coord(coord).tile_type)
	GlobalScript.log_used_time_from_last_record("MapShower.initialize", "painting border tiles")


func load_map() -> void:
	if not MapController.load_from_save():
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


func get_map_coord() -> Vector2i:
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


func paint_terrain(coord: Vector2i, type: TerrainTable.Terrain) -> void:
	var tile: MapTileCell = _terrain_type_to_tile_dict[type]
	tile_map.set_cell(TILE_TERRAIN_LAYER_IDX, coord, tile.source_id, tile.atlas_coords)


func paint_landscape(tile_coord: Vector2i, type: LandscapeTable.Landscape) -> void:
	match type:
		LandscapeTable.Landscape.ICE:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 19, Vector2i.ZERO)
		LandscapeTable.Landscape.FOREST:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 20, Vector2i.ZERO)
		LandscapeTable.Landscape.SWAMP:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 21, Vector2i.ZERO)
		LandscapeTable.Landscape.FLOOD:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 22, Vector2i.ZERO)
		LandscapeTable.Landscape.OASIS:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 23, Vector2i.ZERO)
		LandscapeTable.Landscape.RAINFOREST:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, 24, Vector2i.ZERO)
		LandscapeTable.Landscape.EMPTY:
			tile_map.set_cell(TILE_LANDSCAPE_LAYER_IDX, tile_coord, -1)


func paint_village(tile_coord: Vector2i, village: bool):
	if village:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, 25, Vector2i.ZERO)
	else:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, -1)


func paint_city(tile_coord: Vector2i, type: int):
	if type == 0:
		tile_map.erase_cell(TILE_VILLAGE_LAYER_IDX, tile_coord)
	else:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, 32, Vector2i.ZERO)


func paint_resource(tile_coord: Vector2i, type: ResourceTable.ResourceType) -> void:
	# 清除原来的资源图标
	if _coord_to_resource_icon_dict.has(tile_coord):
		_coord_to_resource_icon_dict[tile_coord].queue_free()
		_coord_to_resource_icon_dict.erase(tile_coord)
	if type == ResourceTable.ResourceType.EMPTY:
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
		sprite.global_position = map_coord_to_global_position(tile_coord) + Vector2(0, 60)
		_coord_to_resource_icon_dict[tile_coord] = sprite
		resource_icons.add_child(sprite)


func paint_continent(tile_coord: Vector2i, type: ContinentTable.Continent) -> void:
	if type == ContinentTable.Continent.EMPTY:
		tile_map.erase_cell(TILE_CONTINENT_LAYER_IDX, tile_coord)
	else:
		tile_map.set_cell(TILE_CONTINENT_LAYER_IDX, tile_coord, 26, Vector2i((type - 1) % 10, (type - 1) / 10))


func paint_border(border_coord: Vector2i, type: MapBorderTable.TileType) -> void:
	match type:
		MapBorderTable.TileType.RIVER:
			paint_river(border_coord)
		MapBorderTable.TileType.CLIFF:
			paint_cliff(border_coord)
		MapBorderTable.TileType.EMPTY:
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


func get_surrounding_cells(map_coord: Vector2i, dist: int, include_inside: bool) -> Array[Vector2i]:
	# Godot 这个假范型，真垃圾…… 还得这样脱裤子放屁拐一下，不然后面 .map() 返回的是 Array
	var result: Array[Vector2i] = []
	if dist < 0:
		return result
	var oddr: HexagonUtils.OffsetCoord = HexagonUtils.OffsetCoord.odd_r(map_coord.x, map_coord.y)
	if include_inside:
		result.append_array(oddr.to_axial().spiral(dist) \
				.map(func(hex: HexagonUtils.Hex): return hex.to_oddr().to_vec2i()))
	else:
		result.append_array(oddr.to_axial().ring(dist) \
				.map(func(hex: HexagonUtils.Hex): return hex.to_oddr().to_vec2i()))
	return result


func get_surrounding_borders(map_coord: Vector2i, dist: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if dist < 0:
		return result
	var center: Vector2i = MapBorderUtils.get_tile_coord_directed_border(map_coord, MapBorderTable.Direction.CENTER)
	var oddr: HexagonUtils.OffsetCoord = HexagonUtils.OffsetCoord.odd_r(center.x, center.y)
	result.append_array(oddr.to_axial().ring(dist * 2 + 1) \
			.map(func(hex: HexagonUtils.Hex): return hex.to_oddr().to_vec2i()))
	return result


func get_map_tile_xy() -> Vector2i:
	return tile_map.tile_set.tile_size


class MapTileCell:
	var source_id: int = -1
	var atlas_coords: Vector2i = Vector2i(-1, -1)
	
	func _init(source_id: int, atlas_coords: Vector2i) -> void:
		self.source_id = source_id
		self.atlas_coords = atlas_coords
