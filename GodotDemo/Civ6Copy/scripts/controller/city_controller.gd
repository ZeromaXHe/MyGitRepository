class_name CityController


const CITY_SCENE: PackedScene = preload("res://scenes/game/city.tscn")

static var city_view_dict: Dictionary = {}


static func create_city(coord: Vector2i) -> City:
	var city_do: CityDO = CityService.create_city(coord)
	var city: City = CITY_SCENE.instantiate()
	city.id = city_do.id
	city_view_dict[city_do.id] = city
	return city


static func choose_producing_unit(id: int, unit_type: UnitTypeTable.Type) -> void:
	CityService.choose_producing_unit(id, unit_type)
	city_view_dict[id].update_production_ui()


static func get_city_do(id: int) -> CityDO:
	return CityService.get_city_do(id)


static func get_city_yield(city_id: int) -> YieldDTO:
	return CityService.get_city_yield(city_id)

