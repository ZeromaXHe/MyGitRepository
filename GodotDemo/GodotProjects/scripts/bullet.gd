class_name Bullet
extends Area2D

@export var speed: int = 10

var direction := Vector2.ZERO

func _physics_process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * speed
		global_rotation = direction.angle()


func set_direction(direction: Vector2):
	self.direction = direction
	global_rotation = direction.angle()
