extends Node

@export var controller: CharacterBody3D
@export_range(0.0, 500.0, 0.1) var force: float = 100.0
@export var enabled: bool = false


func _physics_process(delta: float) -> void:
	if enabled and controller.get_slide_collision_count() > 0:
		var collision = controller.get_last_slide_collision()
		if collision.get_collider() is RigidBody3D:
			var rigid_body = collision.get_collider() as RigidBody3D
			var direction = -collision.get_normal()
			var speed = clamp(controller.velocity.length(), 1.0, 10.0)
			var impulse_position = collision.get_position() - rigid_body.global_position
			rigid_body.apply_impulse(direction * speed * force, impulse_position)
