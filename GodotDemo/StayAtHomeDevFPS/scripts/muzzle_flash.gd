extends Node3D

@export var weapon: WeaponController
@export var flash_time: float = 0.05

@export var light: OmniLight3D
@export var emitter: GPUParticles3D


func _ready() -> void:
	weapon.weapon_fired.connect(add_muzzle_flash)


func add_muzzle_flash() -> void:
	light.visible = true
	emitter.emitting = true
	await get_tree().create_timer(flash_time).timeout
	light.visible = false
