class_name PlayerSightService


static func initialize_player_sight(player_id: int) -> void:
	var size_vec: Vector2i = MapService.get_map_tile_size_vec()
	for i in range(size_vec.x):
		for j in range(size_vec.y):
			var player_sight_do := PlayerSightDO.new()
			player_sight_do.player_id = player_id
			player_sight_do.coord = Vector2i(i, j)
			player_sight_do.sight = PlayerSightTable.Sight.UNSEEN
			DatabaseUtils.player_sight_tbl.insert(player_sight_do)


static func get_player_sight_do(player_id: int, coord: Vector2i) -> PlayerSightDO:
	var qw := MySimSQL.QueryWrapper.new().eq("coord", coord).eq("player_id", player_id)
	return DatabaseUtils.player_sight_tbl.select_arr(qw)[0]


static func get_player_sight_dos_by_sight(sight: PlayerSightTable.Sight) -> Array:
	return DatabaseUtils.player_sight_tbl.query_by_sight(sight)


static func in_sight(coord: Vector2i) -> void:
	var do: PlayerSightDO = get_player_sight_do(PlayerService.get_current_player_id(), coord)
	if do.sight == PlayerSightTable.Sight.IN_SIGHT:
		DatabaseUtils.player_sight_tbl.update_field_by_id(do.id, "count", do.count + 1)
		return
	DatabaseUtils.player_sight_tbl.update_field_by_id(do.id, "sight", PlayerSightTable.Sight.IN_SIGHT)
	DatabaseUtils.player_sight_tbl.update_field_by_id(do.id, "count", 1)


static func out_sight(coord: Vector2i) -> void:
	var do: PlayerSightDO = get_player_sight_do(PlayerService.get_current_player_id(), coord)
	if do.sight != PlayerSightTable.Sight.IN_SIGHT:
		return
	if do.count > 1:
		DatabaseUtils.player_sight_tbl.update_field_by_id(do.id, "count", do.count - 1)
		return
	DatabaseUtils.player_sight_tbl.update_field_by_id(do.id, "sight", PlayerSightTable.Sight.SEEN)
	DatabaseUtils.player_sight_tbl.update_field_by_id(do.id, "count", 0)
