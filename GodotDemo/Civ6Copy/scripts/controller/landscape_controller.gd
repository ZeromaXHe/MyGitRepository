class_name LandscapeController


static func is_landscape_placeable(tile_coord: Vector2i, landscape: LandscapeTable.Landscape) -> bool:
	# 超出地图范围的不处理
	if not MapController.is_in_map_tile(tile_coord):
		return false
	if not is_landscape_placeable_terrain(landscape, MapController.get_map_tile_do_by_coord(tile_coord).terrain):
		return false
	match landscape:
		LandscapeTable.Landscape.FLOOD:
			## 泛滥平原需要放在沿河的沙漠
			return is_flood_placeable_borders(tile_coord)
		LandscapeTable.Landscape.OASIS:
			## 绿洲需要放在周围全是沙漠/沙漠丘陵/沙漠山脉地块的沙漠，而且不能和其他绿洲相邻
			return is_oasis_placeable_surroundings(tile_coord)
		_:
			return true


static func is_landscape_placeable_terrain(landscape: LandscapeTable.Landscape, terrain_type: TerrainTable.Terrain) -> bool:
	match landscape:
		LandscapeTable.Landscape.ICE:
			return is_ice_placeable_terrain(terrain_type)
		LandscapeTable.Landscape.FOREST:
			return is_forest_placeable_terrain(terrain_type)
		LandscapeTable.Landscape.SWAMP:
			return is_swamp_placeable_terrain(terrain_type)
		LandscapeTable.Landscape.FLOOD:
			return is_flood_placeable_terrain(terrain_type)
		LandscapeTable.Landscape.OASIS:
			return is_oasis_placeable_terrain(terrain_type)
		LandscapeTable.Landscape.RAINFOREST:
			return is_rainforest_placeable_terrain(terrain_type)
		LandscapeTable.Landscape.EMPTY:
			return true
		_:
			printerr("is_landscape_placeable_tile | unknown landscape: ", landscape)
			return false


static func is_ice_placeable_terrain(terrain_type: TerrainTable.Terrain) -> bool:
	return TerrainController.is_sea_terrain(terrain_type)


static func is_forest_placeable_terrain(terrain_type: TerrainTable.Terrain) -> bool:
	return terrain_type == TerrainTable.Terrain.GRASS or terrain_type == TerrainTable.Terrain.GRASS_HILL \
			or terrain_type == TerrainTable.Terrain.PLAIN or terrain_type == TerrainTable.Terrain.PLAIN_HILL \
			or terrain_type == TerrainTable.Terrain.TUNDRA or terrain_type == TerrainTable.Terrain.TUNDRA_HILL


static func is_swamp_placeable_terrain(terrain_type: TerrainTable.Terrain) -> bool:
	return terrain_type == TerrainTable.Terrain.GRASS


static func is_flood_placeable_terrain(terrain_type: TerrainTable.Terrain) -> bool:
	return terrain_type == TerrainTable.Terrain.DESERT


static func is_flood_placeable_borders(tile_coord: Vector2i) -> bool:
	var borders: Array[Vector2i] = MapBorderUtils.get_all_tile_border(tile_coord, false)
	for border in borders:
		if MapController.get_map_border_do_by_coord(border).tile_type == MapBorderTable.TileType.RIVER:
			return true
	return false


static func is_oasis_placeable_terrain(terrain_type: TerrainTable.Terrain) -> bool:
	return terrain_type == TerrainTable.Terrain.DESERT


static func is_oasis_placeable_surroundings(tile_coord: Vector2i) -> bool:
	var surroundings: Array[Vector2i] = ViewHolder.get_map_shower().get_surrounding_cells(tile_coord, 1, false)
	for surrounding in surroundings:
		var tile_do: MapTileDO = MapController.get_map_tile_do_by_coord(surrounding)
		var terrain: TerrainTable.Terrain = tile_do.terrain
		if terrain != TerrainTable.Terrain.DESERT \
				and terrain != TerrainTable.Terrain.DESERT_HILL \
				and terrain != TerrainTable.Terrain.DESERT_MOUNTAIN:
			return false
		if tile_do.landscape == LandscapeTable.Landscape.OASIS:
			return false
	return true


static func is_rainforest_placeable_terrain(terrain_type: TerrainTable.Terrain) -> bool:
	return terrain_type == TerrainTable.Terrain.GRASS or terrain_type == TerrainTable.Terrain.GRASS_HILL \
			or terrain_type == TerrainTable.Terrain.PLAIN or terrain_type == TerrainTable.Terrain.PLAIN_HILL
