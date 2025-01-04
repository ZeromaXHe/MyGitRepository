class_name PlayerMovementState
extends State

var PLAYER: Player
var ANIMATION: AnimationPlayer
var WEAPON: WeaponController

func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	ANIMATION = PLAYER.ANIMATION_PLAYER
	WEAPON = PLAYER.WEAPON_CONTROLLER


func _process(delta: float) -> void:
	pass
