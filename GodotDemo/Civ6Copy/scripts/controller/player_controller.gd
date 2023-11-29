class_name PlayerController


static func clear_players() -> void:
	PlayerService.clear_players()


static func add_player(player: PlayerDO) -> Player:
	PlayerService.add_player(player)
	var p := Player.new()
	p.initiate(player)
	# 存储用于反查显示层对象
	ViewHolder.register_player(p)
	return p


static func get_player_do(id: int) -> PlayerDO:
	return PlayerService.get_player_do(id)


static func get_all_player_dos() -> Array:
	return PlayerService.get_all_player_dos()


static func get_current_player() -> PlayerDO:
	return PlayerService.get_current_player()


static func get_current_player_id() -> int:
	return PlayerService.get_current_player_id()


static func get_next_need_move_unit(unit_id: int = -1, return_input: bool = true) -> UnitDO:
	var player_id: int = PlayerService.get_current_player_id()
	var units: Array = UnitService.get_unit_dos_of_player(player_id)
	if unit_id == -1:
		var movable = units.filter(UnitService.is_next_need_move)
		if movable.is_empty():
			return null
		return movable[0]
	
	var unit: UnitDO = UnitService.get_unit_do(unit_id)
	if return_input and UnitService.is_next_need_move(unit):
		return unit
	
	var idx = units.find(unit)
	if idx == -1:
		printerr("get_next_need_move_unit | unit unfound in units")
		return null
	var i = (idx + 1) % units.size()
	while i != idx:
		if UnitService.is_next_need_move(units[i]):
			return units[i]
		i = (i + 1) % units.size()
	return null


static func refresh_units() -> void:
	var player_id: int = PlayerService.get_current_player_id()
	var units: Array = UnitService.get_unit_dos_of_player(player_id)
	for unit in units:
		UnitService.refresh_unit(unit.id)


static func get_next_productable_city(city_id: int = -1, return_input: bool = true) -> CityDO:
	var player_id: int = PlayerService.get_current_player_id()
	var cities: Array = CityService.get_city_dos_of_player(player_id)
	if city_id == -1:
		var productable = cities.filter(CityService.is_next_need_product)
		if productable.is_empty():
			return null
		return productable[0]
	
	var city: CityDO = CityService.get_city_do(city_id)
	if return_input and CityService.is_next_need_product(city):
		return city
	
	var idx = cities.find(city)
	if idx == -1:
		printerr("get_next_productable_city | city unfound in cities")
		return null
	var i = (idx + 1) % cities.size()
	while i != idx:
		if CityService.is_next_need_product(cities[i]):
			return cities[i]
		i = (i + 1) % cities.size()
	return null


static func update_citys_product_val() -> void:
	var player_id: int = PlayerService.get_current_player_id()
	var cities: Array = CityService.get_city_dos_of_player(player_id)
	for city in cities:
		CityService.update_product_val(city.id)
