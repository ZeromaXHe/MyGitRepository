extends Node2D
class_name Team

enum TeamName {
	PLAYER,
	ENEMY
}

@export var team: TeamName = TeamName.PLAYER
