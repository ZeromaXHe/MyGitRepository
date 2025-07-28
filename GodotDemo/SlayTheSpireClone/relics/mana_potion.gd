extends Relic


func activate_relic(owner: RelicUI) -> void:
	Events.player_hand_drawn.connect(func(): _add_mana(owner), CONNECT_ONE_SHOT)


func _add_mana(owner: RelicUI) -> void:
	owner.flash()
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	if player:
		player.stats.mana += 1
