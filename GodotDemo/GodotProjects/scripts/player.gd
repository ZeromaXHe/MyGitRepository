extends Actor
class_name Player


@onready var camera_rmt_txfm: RemoteTransform2D = $CameraRmtTxfm2D


func _physics_process(delta: float) -> void:
	# Player 控制逻辑
	get_input()
	move_and_slide()


func get_input():
	look_at(get_global_mouse_position())
	velocity = Input.get_vector("left", "right", "up", "down") * speed
	
	if not weapon_manager.current_weapon.semi_auto and Input.is_action_pressed("shoot"):
		# 全自动射击
		weapon_manager.shoot()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot") and weapon_manager.current_weapon.semi_auto:
		# 半自动射击
		weapon_manager.shoot()
	elif event.is_action_released("reload"):
		weapon_manager.reload()
	elif event.is_action_released("weapon_1"):
		weapon_manager.switch_weapon(0)
	elif event.is_action_released("weapon_2"):
		weapon_manager.switch_weapon(1)


func set_camera_transform(camera_path: NodePath):
	camera_rmt_txfm.remote_path = camera_path
