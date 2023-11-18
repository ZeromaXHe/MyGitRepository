class_name VillageController


static func is_village_placeable(tile_coord: Vector2i) -> bool:
	# 超出地图范围的不处理
	if not MapController.is_in_map_tile(tile_coord):
		return false
	return is_village_placeable_terrain(MapController.get_map_tile_do_by_coord(tile_coord).terrain)


static func is_village_placeable_terrain(terrain_type: TerrainTable.Terrain) -> bool:
	return TerrainController.is_no_mountain_land_terrain(terrain_type)
