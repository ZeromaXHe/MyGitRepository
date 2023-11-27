class_name ResourceService


static func get_resource_do_by_enum_val(enum_val: ResourceTable.Enum) -> ResourceDO:
	return DatabaseUtils.resource_tbl.query_by_enum_val(enum_val)


static func is_resource_placeable_terrain_and_landscape(resource: ResourceTable.Enum, \
		terrain: TerrainTable.Enum, landscape: LandscapeTable.Enum) -> bool:
	if resource == ResourceTable.Enum.EMPTY:
		return true
	var do: ResourceDO = get_resource_do_by_enum_val(resource)
	return (landscape == LandscapeTable.Enum.EMPTY and do.placeable_terrains != null \
			and do.placeable_terrains.has(terrain)) \
			or (do.placeable_landscapes != null and do.placeable_landscapes.has(landscape))

