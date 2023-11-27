class_name TerrainService


static func get_terrain_do_by_enum_val(enum_val: TerrainTable.Enum) -> TerrainDO:
	return DatabaseUtils.terrain_tbl.query_by_enum_val(enum_val)


static func is_land_terrain(type: TerrainTable.Enum) -> bool:
	return not get_terrain_do_by_enum_val(type).water


static func is_flat_land_terrain(type: TerrainTable.Enum) -> bool:
	var do: TerrainDO = get_terrain_do_by_enum_val(type)
	return not do.water and not do.hill and not do.mountain


static func is_hill_land_terrain(type: TerrainTable.Enum) -> bool:
	var do: TerrainDO = get_terrain_do_by_enum_val(type)
	return not do.water and do.hill


static func is_mountain_land_terrain(type: TerrainTable.Enum) -> bool:
	var do: TerrainDO = get_terrain_do_by_enum_val(type)
	return not do.water and do.mountain


static func is_no_mountain_land_terrain(type: TerrainTable.Enum) -> bool:
	var do: TerrainDO = get_terrain_do_by_enum_val(type)
	return not do.water and not do.mountain


static func is_sea_terrain(type: TerrainTable.Enum) -> bool:
	return get_terrain_do_by_enum_val(type).water


