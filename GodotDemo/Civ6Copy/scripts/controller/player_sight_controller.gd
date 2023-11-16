class_name PlayerSightController


static func get_player_sight_dos_by_sight(sight: PlayerSightTable.Sight) -> Array:
	return PlayerSightService.get_player_sight_dos_by_sight(sight)


static func in_sight(coord: Vector2i) -> void:
	PlayerSightService.in_sight(coord)


static func out_sight(coord: Vector2i) -> void:
	PlayerSightService.out_sight(coord)
