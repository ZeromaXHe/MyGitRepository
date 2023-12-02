class_name CitySightService


static func get_city_sight_do(city_id: int, coord: Vector2i) -> CitySightDO:
	var qw := MySimSQL.QueryWrapper.new().eq("coord", coord).eq("city_id", city_id)
	var arr: Array = DatabaseUtils.city_sight_tbl.select_arr(qw)
	if arr.is_empty():
		return null
	return arr[0]


static func get_player_city_sight_count(player_id: int, coord: Vector2i) -> int:
	var city_dos: Array = CityService.get_city_dos_of_player(player_id)
	var count = 0
	for city_do: CityDO in city_dos:
		if get_city_sight_do(city_do.id, coord) != null:
			count += 1
	return count


static func in_sight(city_id: int, coord: Vector2i) -> void:
	var do: CitySightDO = get_city_sight_do(city_id, coord)
	if do == null:
		var new_do := CitySightDO.new()
		new_do.coord = coord
		new_do.city_id = city_id
		DatabaseUtils.city_sight_tbl.insert(new_do)
		
		var city_do: CityDO = CityService.get_city_do(city_id)
		PlayerSightService.in_sight(city_do.player_id, coord)


static func out_sight(city_id: int, coord: Vector2i) -> void:
	var do: CitySightDO = get_city_sight_do(city_id, coord)
	if do != null:
		DatabaseUtils.city_sight_tbl.delete_by_id(do.id)
		
		var city_do: CityDO = CityService.get_city_do(city_id)
		PlayerSightService.out_sight(city_do.player_id, coord)
