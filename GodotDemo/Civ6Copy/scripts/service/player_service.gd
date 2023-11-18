class_name PlayerService


static var player_idx: int = 0
static var player_id_arr: Array[int] = []


static func clear_players() -> void:
	DatabaseUtils.player_tbl.truncate()


static func add_player(player: PlayerDO) -> void:
	DatabaseUtils.player_tbl.insert(player)
	player_id_arr.append(player.id)
	# 初始化玩家视野
	PlayerSightService.initialize_player_sight(player.id)


static func get_current_player() -> PlayerDO:
	return get_player_do(get_current_player_id())


static func get_current_player_id() -> int:
	if player_id_arr.is_empty():
		return -1
	return player_id_arr[player_idx]


static func get_player_do(id: int) -> PlayerDO:
	return DatabaseUtils.player_tbl.query_by_id(id)


static func get_all_player_dos() -> Array:
	return DatabaseUtils.player_tbl.query_all()

