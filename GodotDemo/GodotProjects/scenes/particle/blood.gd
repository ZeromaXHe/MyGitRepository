extends Node2D

@onready var blood_particles: CPUParticles2D = $BloodParticles

var fade = false
var alpha = 1.0


func _process(delta: float) -> void:
	if fade:
		alpha = lerp(alpha, 0.0, 0.1)
		modulate.a = alpha
		
		if alpha < 0.005:
			queue_free()


func _on_freeze_blood_timer_timeout() -> void:
	# 使血液的粒子效果停止
	blood_particles.set_process(false)
	blood_particles.set_physics_process(false)
	blood_particles.set_process_input(false)
	blood_particles.set_process_internal(false)
	blood_particles.set_process_unhandled_input(false)
	blood_particles.set_process_unhandled_key_input(false)


func _on_fade_out_timer_timeout() -> void:
	fade = true
