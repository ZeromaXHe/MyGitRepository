class_name TerrainController


static func is_land_terrain(terrain: TerrainTable.Terrain) -> bool:
	return TerrainService.is_land_terrain(terrain)


static func is_flat_land_terrain(terrain: TerrainTable.Terrain) -> bool:
	return TerrainService.is_flat_land_terrain(terrain)


static func is_hill_land_terrain(terrain: TerrainTable.Terrain) -> bool:
	return TerrainService.is_hill_land_terrain(terrain)


static func is_mountain_land_terrain(terrain: TerrainTable.Terrain) -> bool:
	return TerrainService.is_mountain_land_terrain(terrain)


static func is_no_mountain_land_terrain(terrain: TerrainTable.Terrain) -> bool:
	return TerrainService.is_no_mountain_land_terrain(terrain)


static func is_sea_terrain(terrain: TerrainTable.Terrain) -> bool:
	return TerrainService.is_sea_terrain(terrain)

