class_name CrouchingPlayerState
extends PlayerMovementState

@export var SPEED: float = 3.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export_range(1, 6, 0.1) var CROUCH_SPEED: float = 4.0

@onready var CROUCH_SHAPE_CAST: ShapeCast3D = %ShapeCast3D

var RELEASED: bool = false

func enter(previous_state) -> void:
	ANIMATION.speed_scale = 1.0
	if previous_state.name != "SlidingPlayerState":
		ANIMATION.play("Crouching", -1.0, CROUCH_SPEED)
	else:
		ANIMATION.current_animation = "Crouching"
		ANIMATION.seek(1.0, true)


func exit() -> void:
	RELEASED = false


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	if Input.is_action_just_released("crouch"):
		uncrouch()
	elif !Input.is_action_pressed("crouch") and !RELEASED:
		RELEASED = true
		uncrouch()


func uncrouch():
	if !CROUCH_SHAPE_CAST.is_colliding():
		ANIMATION.play("Crouching", -1.0, -CROUCH_SPEED * 1.5, true)
		if ANIMATION.is_playing():
			await ANIMATION.animation_finished
		transition.emit("IdlePlayerState")
	else:
		await get_tree().create_timer(0.1).timeout
		uncrouch()
