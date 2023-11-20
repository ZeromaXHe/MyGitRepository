class_name MapTileService


static func clear_map_tiles() -> void:
	DatabaseUtils.map_tile_tbl.truncate()


static func city_claim_territory(city_id: int, coord: Vector2i) -> void:
	var tile_do: MapTileDO = get_map_tile_do_by_coord(coord)
	DatabaseUtils.map_tile_tbl.update_field_by_id(tile_do.id, "city_id", city_id)
#	print("city_claim_territory | after city_id: ", tile_do.city_id, " input:", city_id)


static func get_map_tile_dos_by_city(city_id: int) -> Array:
#	print("get_map_tile_dos_by_city | input:", city_id)
	return DatabaseUtils.map_tile_tbl.query_by_city_id(city_id)


static func get_map_tile_do_by_coord(coord: Vector2i) -> MapTileDO:
	return DatabaseUtils.map_tile_tbl.query_by_coord(coord)


static func change_map_tile_info(coord: Vector2i, tile_do: MapTileDO) -> void:
	var pre: MapTileDO = DatabaseUtils.map_tile_tbl.query_by_coord(coord)
	tile_do.id = pre.id
	DatabaseUtils.map_tile_tbl.update_by_id(tile_do)


static func get_tile_yield(coord: Vector2i) -> YieldDTO:
	var result := YieldDTO.new()
	var tile_do: MapTileDO = DatabaseUtils.map_tile_tbl.query_by_coord(coord)
	var terrain_do: TerrainDO = DatabaseUtils.terrain_tbl.query_by_enum_val(tile_do.terrain)
	var landscape_do: LandscapeDO = DatabaseUtils.landscape_tbl.query_by_enum_val(tile_do.landscape)
	var resource_do: ResourceDO = DatabaseUtils.resource_tbl.query_by_enum_val(tile_do.resource)
	result.culture = resource_do.culture
	result.food = terrain_do.food + landscape_do.food + resource_do.food
	result.production = terrain_do.production + landscape_do.production + resource_do.production
	result.science = resource_do.science
	result.faith = resource_do.faith
	result.gold = terrain_do.gold + landscape_do.gold + resource_do.gold
	return result


static func get_tile_info(coord: Vector2i) -> TileInfoDTO:
	var tile_info_dto := TileInfoDTO.new()
	var tile_do: MapTileDO = DatabaseUtils.map_tile_tbl.query_by_coord(coord)
	var terrain_do: TerrainDO = DatabaseUtils.terrain_tbl.query_by_enum_val(tile_do.terrain)
	tile_info_dto.terrain_name = terrain_do.view_name
	tile_info_dto.land = TerrainController.is_land_terrain(tile_do.terrain)
	tile_info_dto.move_cost = 1 + terrain_do.move_cost
	tile_info_dto.defence_bonus = terrain_do.defence_bonus
	
	if tile_do.landscape != LandscapeTable.Enum.EMPTY:
		var landscape_do: LandscapeDO = DatabaseUtils.landscape_tbl.query_by_enum_val(tile_do.landscape)
		tile_info_dto.landscape_name = landscape_do.view_name
		tile_info_dto.move_cost += landscape_do.move_cost
		tile_info_dto.defence_bonus += landscape_do.defence_bonus
	tile_info_dto.village = tile_do.village
	if tile_do.resource != ResourceTable.Enum.EMPTY:
		tile_info_dto.resource_name = DatabaseUtils.resource_tbl.query_by_enum_val(tile_do.resource).view_name
	
	tile_info_dto.river = MapBorderController.is_tile_near_border(coord, MapBorderTable.Enum.RIVER)
	tile_info_dto.cliff = MapBorderController.is_tile_near_border(coord, MapBorderTable.Enum.CLIFF)
	tile_info_dto.charm = get_tile_charm(coord)
	tile_info_dto.charm_desc = get_charm_desc(tile_info_dto.charm)
	
	if tile_do.continent != ContinentTable.Enum.EMPTY:
		tile_info_dto.continent_name = DatabaseUtils.continent_tbl.query_by_enum_val(tile_do.continent).view_name
	tile_info_dto.tile_yield = get_tile_yield(coord)
	tile_info_dto.coord = coord
	return tile_info_dto


static func get_tile_charm(coord: Vector2i) -> int:
	var charm: int = 0
	var surroundings: Array[Vector2i] = MapController.get_surrounding_cells(coord, 1, false)
	for surrounding in surroundings:
		var tile_do: MapTileDO = MapController.get_map_tile_do_by_coord(surrounding)
		if tile_do == null:
			continue
		var terrain_do: TerrainDO = DatabaseUtils.terrain_tbl.query_by_enum_val(tile_do.terrain)
		charm += terrain_do.charm_influence
		var landscape_do: LandscapeDO = DatabaseUtils.landscape_tbl.query_by_enum_val(tile_do.landscape)
		charm += landscape_do.charm_influence
	return charm


static func get_charm_desc(charm: int) -> String:
	if charm >= 4:
		return "惊艳的"
	elif charm >= 2:
		return "迷人的"
	elif charm >= -1:
		return "普通的"
	elif charm >= -3:
		return "无吸引力的"
	else:
		return "令人厌恶的"
