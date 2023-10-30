class_name MapShower
extends Node2D


# TileMap 层索引
const TILE_TERRAIN_LAYER_IDX: int = 0
const TILE_LANDSCAPE_LAYER_IDX: int = 1
const TILE_VILLAGE_LAYER_IDX: int = 2
const TILE_CONTINENT_LAYER_IDX: int = 3
const TILE_CHOSEN_LAYER_IDX: int = 4
const TILE_RESOURCE_LAYER_IDX: int = 5
const TILE_SIGHT_LAYER_IDX: int = 6
const TILE_MOVE_LAYER_IDX: int = 7
# 地形集索引
const TERRAIN_SET_IDX: int = 0
const MOVE_TERRAIN_IDX: int = 0
const SIGHT_TERRAIN_IDX: int = 1
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
# 记录 TileMap 坐标到资源图标的映射的字典
var _coord_to_resource_icon_dict: Dictionary = {}

@onready var border_tile_map: TileMap = $BorderTileMap
@onready var tile_map: TileMap = $TileMap
@onready var resource_icons: Node2D = $ResourceIcons


func _ready() -> void:
	hide_continent_layer()


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


func paint_sight_tile_areas(cells: Array[Vector2i], type: Map.SightType) -> void:
	match type:
		Map.SightType.UNSEEN:
			for cell in cells:
				tile_map.set_cell(TILE_SIGHT_LAYER_IDX, cell, 31, Vector2i.ZERO)
		Map.SightType.SEEN:
			for cell in cells:
				tile_map.set_cell(TILE_SIGHT_LAYER_IDX, cell, 30, Vector2i.ZERO)
		Map.SightType.IN_SIGHT:
			tile_map.set_cells_terrain_connect(TILE_SIGHT_LAYER_IDX, cells, TERRAIN_SET_IDX, SIGHT_TERRAIN_IDX)


func paint_move_tile_areas(cells: Array[Vector2i]) -> void:
	tile_map.set_cells_terrain_connect(TILE_MOVE_LAYER_IDX, cells, TERRAIN_SET_IDX, MOVE_TERRAIN_IDX)


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
	match Map.get_border_type(border_coord):
		Map.BorderType.VERTICAL:
			if placeable.call(border_coord):
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 8, Vector2i(0, 0))
			else:
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 11, Vector2i(0, 0))
		Map.BorderType.SLASH:
			if placeable.call(border_coord):
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 7, Vector2i(0, 0))
			else:
				border_tile_map.set_cell(MapShower.BORDER_CHOSEN_LAYER_IDX, border_coord, 10, Vector2i(0, 0))
		Map.BorderType.BACK_SLASH:
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


func paint_tile(coord: Vector2i, tile_info: Map.TileInfo) -> void:
	paint_terrain(coord, tile_info.type)
	paint_landscape(coord, tile_info.landscape)
	paint_village(coord, tile_info.village)
	paint_continent(coord, tile_info.continent)
	paint_resource(coord, tile_info.resource)


func paint_terrain(coord: Vector2i, type: Map.TerrainType) -> void:
	var tile: MapTileCell = _terrain_type_to_tile_dict[type]
	tile_map.set_cell(TILE_TERRAIN_LAYER_IDX, coord, tile.source_id, tile.atlas_coords)


func paint_landscape(tile_coord: Vector2i, type: Map.LandscapeType) -> void:
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


func paint_village(tile_coord: Vector2i, type: int):
	if type == 0:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, -1)
	else:
		tile_map.set_cell(TILE_VILLAGE_LAYER_IDX, tile_coord, 25, Vector2i.ZERO)


func paint_resource(tile_coord: Vector2i, type: Map.ResourceType) -> void:
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
		sprite.global_position = map_coord_to_global_position(tile_coord) + Vector2(0, 60)
		_coord_to_resource_icon_dict[tile_coord] = sprite
		resource_icons.add_child(sprite)


func paint_continent(tile_coord: Vector2i, type: Map.ContinentType) -> void:
	if type == Map.ContinentType.EMPTY:
		tile_map.erase_cell(TILE_CONTINENT_LAYER_IDX, tile_coord)
	else:
		tile_map.set_cell(TILE_CONTINENT_LAYER_IDX, tile_coord, 26, Vector2i((type - 1) % 10, (type - 1) / 10))


func paint_border(border_coord: Vector2i, type: Map.BorderTileType) -> void:
	match type:
		Map.BorderTileType.RIVER:
			paint_river(border_coord)
		Map.BorderTileType.CLIFF:
			paint_cliff(border_coord)
		Map.BorderTileType.EMPTY:
			# 真正绘制边界为空
			border_tile_map.erase_cell(BORDER_TILE_LAYER_IDX, border_coord)


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

func get_map_tile_xy() -> Vector2i:
	return tile_map.tile_set.tile_size


class MapTileCell:
	var source_id: int = -1
	var atlas_coords: Vector2i = Vector2i(-1, -1)
	
	func _init(source_id: int, atlas_coords: Vector2i) -> void:
		self.source_id = source_id
		self.atlas_coords = atlas_coords
