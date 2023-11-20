class_name TerrainService


static func is_land_terrain(type: TerrainTable.Enum) -> bool:
	return type != TerrainTable.Enum.SHORE and type != TerrainTable.Enum.OCEAN


static func is_flat_land_terrain(type: TerrainTable.Enum) -> bool:
	return type == TerrainTable.Enum.GRASS or type == TerrainTable.Enum.PLAIN \
			or type == TerrainTable.Enum.DESERT or type == TerrainTable.Enum.TUNDRA \
			or type == TerrainTable.Enum.SNOW


static func is_hill_land_terrain(type: TerrainTable.Enum) -> bool:
	return type == TerrainTable.Enum.GRASS_HILL or type == TerrainTable.Enum.PLAIN_HILL \
			or type == TerrainTable.Enum.DESERT_HILL or type == TerrainTable.Enum.TUNDRA_HILL \
			or type == TerrainTable.Enum.SNOW_HILL


static func is_mountain_land_terrain(type: TerrainTable.Enum) -> bool:
	return type == TerrainTable.Enum.GRASS_MOUNTAIN or type == TerrainTable.Enum.PLAIN_MOUNTAIN \
			or type == TerrainTable.Enum.DESERT_MOUNTAIN or type == TerrainTable.Enum.TUNDRA_MOUNTAIN \
			or type == TerrainTable.Enum.SNOW_MOUNTAIN


static func is_no_mountain_land_terrain(type: TerrainTable.Enum) -> bool:
	return type == TerrainTable.Enum.GRASS or type == TerrainTable.Enum.GRASS_HILL \
			or type == TerrainTable.Enum.PLAIN or type == TerrainTable.Enum.PLAIN_HILL \
			or type == TerrainTable.Enum.DESERT or type == TerrainTable.Enum.DESERT_HILL \
			or type == TerrainTable.Enum.TUNDRA or type == TerrainTable.Enum.TUNDRA_HILL \
			or type == TerrainTable.Enum.SNOW or type == TerrainTable.Enum.SNOW_HILL


static func is_sea_terrain(type: TerrainTable.Enum) -> bool:
	return type == TerrainTable.Enum.SHORE or type == TerrainTable.Enum.OCEAN


