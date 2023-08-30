extends CharacterBody2D
class_name CameraBody


@export var speed: int = 300

var mouse_in_move_area: bool = false

@onready var mouse_move_area: Area2D = $MouseMoveArea


func _physics_process(delta: float) -> void:
	if mouse_in_move_area:
		var direction: Vector2 = get_local_mouse_position()
		self.velocity = direction.normalized() * speed
		move_and_slide()


func _on_mouse_move_area_mouse_entered() -> void:
	mouse_in_move_area = true


func _on_mouse_move_area_mouse_exited() -> void:
	mouse_in_move_area = false
