extends Node2D
class_name CameraManager


@export var aim_offset_dist: int = 200
@export var aim_zoom_multiple: float = 1.5

@onready var camera_shake_timer: Timer = $CameraShakeTimer
@onready var camera: Camera2D = $Camera2D

var camera_shaking = false
var shake_intensity = 0
var base_offset: Vector2 = Vector2.ZERO
var base_zoom: Vector2 = Vector2.ONE


func _ready() -> void:
	GlobalMediator.camera_manager = self


func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		# 瞄准模式下的镜头配置
		base_offset = Vector2.from_angle(rotation) * aim_offset_dist
		base_zoom = Vector2.ONE * aim_zoom_multiple
	else:
		base_offset = Vector2.ZERO
		base_zoom = Vector2.ONE
	
	camera.zoom = lerp(camera.zoom, base_zoom, 0.3)
	if camera_shaking:
		camera.offset += delta * Vector2(
				randf_range(-shake_intensity, shake_intensity),
				randf_range(-shake_intensity, shake_intensity))
	else:
		camera.offset = lerp(camera.offset, base_offset, 0.3)


func shake_camera(intensity):
	camera.zoom = base_zoom - Vector2(intensity * 0.0015, intensity * 0.0015)
	shake_intensity = intensity
	camera_shake_timer.start()
	camera_shaking = true


func _on_camera_shake_timer_timeout() -> void:
	camera_shaking = false
