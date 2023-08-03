extends Node2D
class_name Team

enum TeamName {
	NEUTRAL,
	PLAYER,
	ENEMY,
}

@export var team: TeamName = TeamName.NEUTRAL
