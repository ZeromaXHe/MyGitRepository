extends Node2D
class_name Team

enum Side {
	NEUTRAL,
	PLAYER,
	ENEMY,
}

@export var side: Team.Side = Side.NEUTRAL


func get_rival(side: Team.Side) -> Team.Side:
	match (side):
		Side.PLAYER:
			return Side.ENEMY
		Side.ENEMY:
			return Side.PLAYER
		_:
			return Side.NEUTRAL
