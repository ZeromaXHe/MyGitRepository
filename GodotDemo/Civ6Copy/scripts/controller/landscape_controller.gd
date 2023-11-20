class_name LandscapeController


static func is_landscape_placeable(tile_coord: Vector2i, landscape: LandscapeTable.Enum) -> bool:
	# 超出地图范围的不处理
	if not MapController.is_in_map_tile(tile_coord):
		return false
	if not is_landscape_placeable_terrain(landscape, MapController.get_map_tile_do_by_coord(tile_coord).terrain):
		return false
	match landscape:
		LandscapeTable.Enum.FLOOD:
			## 泛滥平原需要放在沿河的沙漠
			return is_flood_placeable_borders(tile_coord)
		LandscapeTable.Enum.OASIS:
			## 绿洲需要放在周围全是沙漠/沙漠丘陵/沙漠山脉地块的沙漠，而且不能和其他绿洲相邻
			return is_oasis_placeable_surroundings(tile_coord)
		_:
			return true


static func is_landscape_placeable_terrain(landscape: LandscapeTable.Enum, terrain_type: TerrainTable.Enum) -> bool:
	match landscape:
		LandscapeTable.Enum.ICE:
			return is_ice_placeable_terrain(terrain_type)
		LandscapeTable.Enum.FOREST:
			return is_forest_placeable_terrain(terrain_type)
		LandscapeTable.Enum.SWAMP:
			return is_swamp_placeable_terrain(terrain_type)
		LandscapeTable.Enum.FLOOD:
			return is_flood_placeable_terrain(terrain_type)
		LandscapeTable.Enum.OASIS:
			return is_oasis_placeable_terrain(terrain_type)
		LandscapeTable.Enum.RAINFOREST:
			return is_rainforest_placeable_terrain(terrain_type)
		LandscapeTable.Enum.EMPTY:
			return true
		_:
			printerr("is_landscape_placeable_tile | unknown landscape: ", landscape)
			return false


static func is_ice_placeable_terrain(terrain_type: TerrainTable.Enum) -> bool:
	return TerrainController.is_sea_terrain(terrain_type)


static func is_forest_placeable_terrain(terrain_type: TerrainTable.Enum) -> bool:
	return terrain_type == TerrainTable.Enum.GRASS or terrain_type == TerrainTable.Enum.GRASS_HILL \
			or terrain_type == TerrainTable.Enum.PLAIN or terrain_type == TerrainTable.Enum.PLAIN_HILL \
			or terrain_type == TerrainTable.Enum.TUNDRA or terrain_type == TerrainTable.Enum.TUNDRA_HILL


static func is_swamp_placeable_terrain(terrain_type: TerrainTable.Enum) -> bool:
	return terrain_type == TerrainTable.Enum.GRASS


static func is_flood_placeable_terrain(terrain_type: TerrainTable.Enum) -> bool:
	return terrain_type == TerrainTable.Enum.DESERT


static func is_flood_placeable_borders(tile_coord: Vector2i) -> bool:
	return MapBorderController.is_tile_near_border(tile_coord, MapBorderTable.Enum.RIVER)


static func is_oasis_placeable_terrain(terrain_type: TerrainTable.Enum) -> bool:
	return terrain_type == TerrainTable.Enum.DESERT


static func is_oasis_placeable_surroundings(tile_coord: Vector2i) -> bool:
	var surroundings: Array[Vector2i] = MapController.get_surrounding_cells(tile_coord, 1, false)
	for surrounding in surroundings:
		var tile_do: MapTileDO = MapController.get_map_tile_do_by_coord(surrounding)
		var terrain: TerrainTable.Enum = tile_do.terrain
		if terrain != TerrainTable.Enum.DESERT \
				and terrain != TerrainTable.Enum.DESERT_HILL \
				and terrain != TerrainTable.Enum.DESERT_MOUNTAIN:
			return false
		if tile_do.landscape == LandscapeTable.Enum.OASIS:
			return false
	return true


static func is_rainforest_placeable_terrain(terrain_type: TerrainTable.Enum) -> bool:
	return terrain_type == TerrainTable.Enum.GRASS or terrain_type == TerrainTable.Enum.GRASS_HILL \
			or terrain_type == TerrainTable.Enum.PLAIN or terrain_type == TerrainTable.Enum.PLAIN_HILL
