class_name TerrainService


static func is_land_terrain(type: TerrainTable.Terrain) -> bool:
	return type != TerrainTable.Terrain.SHORE and type != TerrainTable.Terrain.OCEAN


static func is_flat_land_terrain(type: TerrainTable.Terrain) -> bool:
	return type == TerrainTable.Terrain.GRASS or type == TerrainTable.Terrain.PLAIN \
			or type == TerrainTable.Terrain.DESERT or type == TerrainTable.Terrain.TUNDRA \
			or type == TerrainTable.Terrain.SNOW


static func is_hill_land_terrain(type: TerrainTable.Terrain) -> bool:
	return type == TerrainTable.Terrain.GRASS_HILL or type == TerrainTable.Terrain.PLAIN_HILL \
			or type == TerrainTable.Terrain.DESERT_HILL or type == TerrainTable.Terrain.TUNDRA_HILL \
			or type == TerrainTable.Terrain.SNOW_HILL


static func is_mountain_land_terrain(type: TerrainTable.Terrain) -> bool:
	return type == TerrainTable.Terrain.GRASS_MOUNTAIN or type == TerrainTable.Terrain.PLAIN_MOUNTAIN \
			or type == TerrainTable.Terrain.DESERT_MOUNTAIN or type == TerrainTable.Terrain.TUNDRA_MOUNTAIN \
			or type == TerrainTable.Terrain.SNOW_MOUNTAIN


static func is_no_mountain_land_terrain(type: TerrainTable.Terrain) -> bool:
	return type == TerrainTable.Terrain.GRASS or type == TerrainTable.Terrain.GRASS_HILL \
			or type == TerrainTable.Terrain.PLAIN or type == TerrainTable.Terrain.PLAIN_HILL \
			or type == TerrainTable.Terrain.DESERT or type == TerrainTable.Terrain.DESERT_HILL \
			or type == TerrainTable.Terrain.TUNDRA or type == TerrainTable.Terrain.TUNDRA_HILL \
			or type == TerrainTable.Terrain.SNOW or type == TerrainTable.Terrain.SNOW_HILL


static func is_sea_terrain(type: TerrainTable.Terrain) -> bool:
	return type == TerrainTable.Terrain.SHORE or type == TerrainTable.Terrain.OCEAN


