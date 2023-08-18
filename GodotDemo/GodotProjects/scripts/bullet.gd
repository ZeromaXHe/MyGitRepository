class_name Bullet
extends Area2D


@export var speed: int = 2000
@export var damage: int = 10

@onready var ray_cast: RayCast2D = $RayCast2D

var direction := Vector2.ZERO
var team: Team = null
var shooter: Actor
var from_weapon: Weapon

func _physics_process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * speed * delta
		global_rotation = direction.angle()


func set_direction(direction: Vector2):
	self.direction = direction
	global_rotation = direction.angle()


func _on_kill_timer_timeout():
	queue_free()


func _on_body_entered(body: Node):
	if body.has_method("handle_hit"):
		if GlobalMediator.friendly_fire_damage or \
				(body.has_method("get_team_side") and body.get_team_side() != team.side):
			body.handle_hit(self)
	else:
		# 击中其他物体，使用 RayCast2D 计算反射角
		ray_cast.enabled = true
		# 强制 ray_cast 在本物理帧中计算
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			# 获取法线向量，计算反射角
			var normal: Vector2 = ray_cast.get_collision_normal()
			var reflex_angle = Vector2.from_angle(global_rotation).bounce(normal).angle()
			GlobalSignals.bullet_hit_something.emit(reflex_angle, ray_cast.get_collision_point())
	queue_free()
