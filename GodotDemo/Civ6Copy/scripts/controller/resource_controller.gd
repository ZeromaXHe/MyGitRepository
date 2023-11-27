class_name ResourceController


static func get_resource_do_by_enum_val(enum_val: ResourceTable.Enum) -> ResourceDO:
	return ResourceService.get_resource_do_by_enum_val(enum_val)


static func is_resource_placeable(tile_coord: Vector2i, type: ResourceTable.Enum) -> bool:
	# 超出地图范围的不处理
	if not MapController.is_in_map_tile(tile_coord):
		return false
	var tile_info: MapTileDO = MapController.get_map_tile_do_by_coord(tile_coord)
	return is_resource_placeable_terrain_and_landscape(type, tile_info.terrain, tile_info.landscape)


static func is_resource_placeable_terrain_and_landscape(resource: ResourceTable.Enum, \
		terrain: TerrainTable.Enum, landscape: LandscapeTable.Enum) -> bool:
	return ResourceService.is_resource_placeable_terrain_and_landscape(resource, terrain, landscape)

