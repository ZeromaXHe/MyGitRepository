class_name CityBuildingService


static func city_build(city_id: int, building: CityBuildingTable.Building) -> void:
	var do := CityBuildingDO.new()
	do.city_id = city_id
	do.building = building
	DatabaseUtils.city_building_tbl.insert(do)


static func get_buildings(city_id: int) -> Array:
	return DatabaseUtils.city_building_tbl.query_by_city_id(city_id)
