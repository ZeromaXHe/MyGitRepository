extends Node
class_name Health

@export var max_health: int = 100

@onready var hp: int = max_health:
	set = set_health

func set_health(new_hp):
	hp = clamp(new_hp, 0, max_health)
