class_name PlayerSightService


static func get_player_sight_do(player_id: int, coord: Vector2i) -> PlayerSightDO:
	var qw := MySimSQL.QueryWrapper.new().eq("coord", coord).eq("player_id", player_id)
	var arr: Array = DatabaseUtils.player_sight_tbl.select_arr(qw)
	if arr.is_empty():
		return null
	return arr[0]


static func get_player_sight_dos_by_sight(player_id: int, sight: PlayerSightTable.Sight) -> Array:
	var qw := MySimSQL.QueryWrapper.new().eq("sight", sight).eq("player_id", player_id)
	return DatabaseUtils.player_sight_tbl.select_arr(qw)


static func in_sight(player_id: int, coord: Vector2i) -> void:
	var do: PlayerSightDO = get_player_sight_do(player_id, coord)
	if do == null:
		var player_sight_do := PlayerSightDO.new()
		player_sight_do.player_id = player_id
		player_sight_do.coord = coord
		player_sight_do.sight = PlayerSightTable.Sight.IN_SIGHT
		DatabaseUtils.player_sight_tbl.insert(player_sight_do)
		return
	# 如果之前已经进入视野
	if do.sight == PlayerSightTable.Sight.IN_SIGHT:
		return
	# 说明视野是“看过”的状态，更新为“视野范围内”
	DatabaseUtils.player_sight_tbl.update_field_by_id(do.id, "sight", PlayerSightTable.Sight.IN_SIGHT)


static func out_sight(player_id: int, coord: Vector2i) -> void:
	var do: PlayerSightDO = get_player_sight_do(player_id, coord)
	if do.sight != PlayerSightTable.Sight.IN_SIGHT:
		return
	var count = UnitSightService.get_player_unit_sight_count(player_id, coord) + CitySightService.get_player_city_sight_count(player_id, coord)
	if count == 0:
		DatabaseUtils.player_sight_tbl.update_field_by_id(do.id, "sight", PlayerSightTable.Sight.SEEN)
