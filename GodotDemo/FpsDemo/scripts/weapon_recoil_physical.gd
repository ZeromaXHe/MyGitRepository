extends Node3D

@export var recoil_amount: Vector3
@export var snap_amount: float
@export var speed: float

@export var weapon: WeaponController

var current_position: Vector3
var target_position: Vector3


func _ready() -> void:
	weapon.weapon_fired.connect(add_recoil)


func _process(delta: float) -> void:
	target_position = lerp(target_position, Vector3.ZERO, speed * delta)
	current_position = lerp(current_position, target_position, snap_amount * delta)
	position = current_position


func add_recoil() -> void:
	target_position += Vector3(randf_range(-recoil_amount.x, recoil_amount.x),\
		randf_range(recoil_amount.y, recoil_amount.y * 2.0),\
		randf_range(recoil_amount.z, recoil_amount.z * 2.0))
