class_name PlayerService


static var player_idx: int = 0
static var player_id_arr: Array[int] = []


static func clear_players() -> void:
	DatabaseUtils.player_tbl.truncate()


static func add_player(player: PlayerDO) -> void:
	DatabaseUtils.player_tbl.insert(player)
	player_id_arr.append(player.id)


static func get_current_player() -> PlayerDO:
	return get_player_do(get_current_player_id())


static func get_current_player_id() -> int:
	if player_id_arr.is_empty():
		return -1
	return player_id_arr[player_idx]


## 当前玩家结束回合，返回是否所有玩家都已结束本回合
static func current_player_end_turn() -> bool:
	player_idx = (player_idx + 1) % player_id_arr.size()
	return player_idx == 0

static func get_player_do(id: int) -> PlayerDO:
	return DatabaseUtils.player_tbl.query_by_id(id)


static func get_all_player_dos() -> Array:
	return DatabaseUtils.player_tbl.query_all()


static func get_next_need_move_unit(unit_id: int = -1, return_input: bool = true) -> UnitDO:
	var player_id: int = get_current_player_id()
	var units: Array = UnitService.get_unit_dos_of_player(player_id)
	if unit_id == -1:
		var movable = units.filter(UnitService.is_next_need_move)
		if movable.is_empty():
			return null
		return movable[0]
	
	var unit: UnitDO = UnitService.get_unit_do(unit_id)
	var idx = units.find(unit)
	if idx == -1:
		printerr("get_next_need_move_unit | unit unfound in units")
		return null
	var i = (idx + 1) % units.size()
	while i != idx:
		if UnitService.is_next_need_move(units[i]):
			return units[i]
		i = (i + 1) % units.size()
	# 可以返回自己的情况下，如果自己可以移动就把自己返回
	if return_input and UnitService.is_next_need_move(unit):
		return unit
	return null


static func refresh_units() -> void:
	var player_id: int = get_current_player_id()
	var units: Array = UnitService.get_unit_dos_of_player(player_id)
	for unit in units:
		UnitService.refresh_unit(unit.id)


static func get_next_productable_city(city_id: int = -1, return_input: bool = true) -> CityDO:
	var player_id: int = get_current_player_id()
	var cities: Array = CityService.get_city_dos_of_player(player_id)
	if city_id == -1:
		var productable = cities.filter(CityService.is_next_need_product)
		if productable.is_empty():
			return null
		return productable[0]
	
	var city: CityDO = CityService.get_city_do(city_id)
	var idx = cities.find(city)
	if idx == -1:
		printerr("get_next_productable_city | city unfound in cities")
		return null
	var i = (idx + 1) % cities.size()
	while i != idx:
		if CityService.is_next_need_product(cities[i]):
			return cities[i]
		i = (i + 1) % cities.size()
	# 可以返回自己的情况下，如果自己可以选择生产项目就把自己返回
	if return_input and CityService.is_next_need_product(city):
		return city
	return null


static func update_citys_product_val() -> void:
	var player_id: int = get_current_player_id()
	var cities: Array = CityService.get_city_dos_of_player(player_id)
	for city in cities:
		CityService.update_product_val(city.id)

