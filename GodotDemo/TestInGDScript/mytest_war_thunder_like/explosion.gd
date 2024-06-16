class_name Explosion
extends Node3D


@export var scale_multiplier: float = 5

@onready var debris: GPUParticles3D = $Debris
@onready var fire: GPUParticles3D = $Fire
@onready var smoke: GPUParticles3D = $Smoke


func _ready() -> void:
	scale *= scale_multiplier
	debris.one_shot = true
	debris.emitting = false
	debris.process_material.scale_min = scale_multiplier * 0.5
	debris.process_material.scale_max = scale_multiplier * 1.5
	fire.one_shot = true
	fire.emitting = false
	fire.process_material.scale_min = scale_multiplier * 0.5
	fire.process_material.scale_max = scale_multiplier * 1.5
	smoke.one_shot = true
	smoke.emitting = false
	smoke.process_material.scale_min = scale_multiplier * 0.5
	smoke.process_material.scale_max = scale_multiplier * 1.5

func explode():
	debris.emitting = true
	fire.emitting = true
	smoke.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
