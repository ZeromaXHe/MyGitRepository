extends Node2D
class_name CameraManager

@onready var camera_shake_timer: Timer = $CameraShakeTimer
@onready var camera: Camera2D = $Camera2D

var camera_shaking = false
var shake_intensity = 0


func _ready() -> void:
	GlobalMediator.camera_manager = self


func _process(delta: float) -> void:
	camera.zoom = lerp(camera.zoom, Vector2(1, 1), 0.3)
	if camera_shaking:
		camera.offset += delta * Vector2(
				randf_range(-shake_intensity, shake_intensity),
				randf_range(-shake_intensity, shake_intensity))
	else:
		camera.offset = lerp(camera.offset, Vector2(0, 0), 0.3)


func shake_camera(intensity):
	camera.zoom = Vector2(1, 1) - Vector2(intensity * 0.0015, intensity * 0.0015)
	shake_intensity = intensity
	camera_shake_timer.start()
	camera_shaking = true


func _on_camera_shake_timer_timeout() -> void:
	camera_shaking = false
