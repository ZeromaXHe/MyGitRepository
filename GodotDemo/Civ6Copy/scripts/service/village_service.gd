class_name VillageService


static func is_village_placeable(tile_coord: Vector2i) -> bool:
	# 超出地图范围的不处理
	if not MapService.is_in_map_tile(tile_coord):
		return false
	return is_village_placeable_terrain(MapTileService.get_map_tile_do_by_coord(tile_coord).terrain)


static func is_village_placeable_terrain(terrain_type: TerrainTable.Enum) -> bool:
	return TerrainService.is_no_mountain_land_terrain(terrain_type)
