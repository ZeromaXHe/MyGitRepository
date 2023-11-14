class_name TileService


static func get_tile_yield(coord: Vector2i) -> YieldDTO:
	var result := YieldDTO.new()
	var tile_do: TileDO = DatabaseUtils.query_tile_by_coord(coord)
	var terrain_do: TerrainDO = DatabaseUtils.query_terrain_by_id(tile_do.terrain_id)
	var landscape_do: LandscapeDO = DatabaseUtils.query_landscape_by_id(tile_do.terrain_id)
	var resource_do: ResourceDO = DatabaseUtils.query_resource_by_id(tile_do.terrain_id)
	result.culture = resource_do.culture
	result.food = terrain_do.food + landscape_do.food + resource_do.food
	result.production = terrain_do.production + landscape_do.production + resource_do.production
	result.science = resource_do.science
	result.religion = resource_do.religion
	result.gold = terrain_do.gold + landscape_do.gold + resource_do.gold
	return result
