class_name FallingPlayerState
extends PlayerMovementState

@export var SPEED: float = 5.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var DOUBLE_JUMP_VELOCITY: float = 4.5

var DOUBLE_JUMP: bool = false

func enter(previous_state) -> void:
	ANIMATION.pause()


func exit() -> void:
	DOUBLE_JUMP = false


func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	if Input.is_action_just_pressed("jump") and !DOUBLE_JUMP:
		DOUBLE_JUMP = true
		PLAYER.velocity.y = DOUBLE_JUMP_VELOCITY
	if PLAYER.is_on_floor():
		ANIMATION.play("JumpEnd")
		transition.emit("IdlePlayerState")
