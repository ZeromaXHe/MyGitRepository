class_name ViewHolder


static var map_shower: MapShower
static var player_view_dict: Dictionary = {}
static var unit_view_dict: Dictionary = {}
static var city_view_dict: Dictionary = {}


static func register_map_shower(ms: MapShower) -> void:
	map_shower = ms


static func get_map_shower() -> MapShower:
	return map_shower


static func register_player(player: Player) -> void:
	player_view_dict[player.id] = player


static func get_player(id: int) -> Player:
	return player_view_dict[id]


static func register_unit(unit: Unit) -> void:
	unit_view_dict[unit.id] = unit


static func get_unit(id: int) -> Unit:
	return unit_view_dict[id]


static func register_city(city: City) -> void:
	city_view_dict[city.id] = city


static func get_city(id: int) -> City:
	return city_view_dict[id]
