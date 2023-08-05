class_name Bullet
extends Area2D


@export var speed: int = 10
@export var damage: int = 10

var direction := Vector2.ZERO
var team_side: Team.Side = -1
var shooter = null

func _physics_process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * speed
		global_rotation = direction.angle()


func set_direction(direction: Vector2):
	self.direction = direction
	global_rotation = direction.angle()


func _on_kill_timer_timeout():
	queue_free()


func _on_body_entered(body: Node):
	if body.has_method("handle_hit"):
		if body.has_method("get_team") and body.get_team() != team_side:
			body.handle_hit(self)
		queue_free()
