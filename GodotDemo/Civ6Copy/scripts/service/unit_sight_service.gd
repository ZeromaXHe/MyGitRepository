class_name UnitSightService


static func get_unit_sight_do(unit_id: int, coord: Vector2i) -> UnitSightDO:
	var qw := MySimSQL.QueryWrapper.new().eq("coord", coord).eq("unit_id", unit_id)
	var arr: Array = DatabaseUtils.unit_sight_tbl.select_arr(qw)
	if arr.is_empty():
		return null
	return arr[0]


static func get_player_unit_sight_count(player_id: int, coord: Vector2i) -> int:
	var unit_dos: Array = UnitService.get_unit_dos_of_player(player_id)
	var count = 0
	for unit_do: UnitDO in unit_dos:
		if get_unit_sight_do(unit_do.id, coord) != null:
			count += 1
	return count


static func in_sight(unit_id: int, coord: Vector2i) -> void:
	var do: UnitSightDO = get_unit_sight_do(unit_id, coord)
	if do == null:
		var new_do := UnitSightDO.new()
		new_do.coord = coord
		new_do.unit_id = unit_id
		DatabaseUtils.unit_sight_tbl.insert(new_do)
		
		var unit_do: UnitDO = UnitService.get_unit_do(unit_id)
		PlayerSightService.in_sight(unit_do.player_id, coord)


static func out_sight(unit_id: int, coord: Vector2i) -> void:
	var do: UnitSightDO = get_unit_sight_do(unit_id, coord)
	if do != null:
		DatabaseUtils.unit_sight_tbl.delete_by_id(do.id)
		
		var unit_do: UnitDO = UnitService.get_unit_do(unit_id)
		PlayerSightService.out_sight(unit_do.player_id, coord)
