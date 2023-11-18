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
	result.religion = resource_do.religion
	result.gold = terrain_do.gold + landscape_do.gold + resource_do.gold
	return result
