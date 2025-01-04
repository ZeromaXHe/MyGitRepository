@tool
class_name WeaponController
extends Node3D

@export var WEAPON_TYPE: Weapons:
	set(value):
		WEAPON_TYPE = value
		# 不加 is_node_ready() 的话，
		# 好像会有个 WEAPON_TYPE 为 null 时调用 load_weapon 的报错
		if is_node_ready() and Engine.is_editor_hint():
			print("更换武器！")
			load_weapon()
@export var sway_noise: NoiseTexture2D
@export var sway_speed: float = 1.2
@export var reset: bool = false:
	set(value):
		reset = value
		if is_node_ready() and Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shadow: MeshInstance3D = %WeaponShadow

var mouse_movement: Vector2
var random_sway_x
var random_sway_y
var random_sway_amount: float
var time: float = 0.0
var idle_sway_adjustment
var idle_sway_rotation_strength
var weapon_bob_amount := Vector2.ZERO

var raycast_test = preload("res://assets/scenes/raycast_test.tscn")


func _ready() -> void:
	if owner != null && owner != self: #好像 GDScript 就不会阻塞自己……
		await owner.ready
	print("Weapon ready")
	load_weapon()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon1"):
		WEAPON_TYPE = load("res://meshes/weapons/crowbar/crowbar.tres")
		load_weapon()
	if event.is_action_pressed("weapon2"):
		WEAPON_TYPE = load("res://meshes/weapons/crowbar2/crowbar_left.tres")
		load_weapon()
	if event is InputEventMouseMotion:
		mouse_movement = event.relative


func load_weapon() -> void:
	weapon_mesh.mesh = WEAPON_TYPE.mesh
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation
	weapon_shadow.mesh = WEAPON_TYPE.mesh # 自己加的。为啥教程里不设置 mesh？
	weapon_shadow.visible = WEAPON_TYPE.shadow
	
	idle_sway_adjustment = WEAPON_TYPE.idle_sway_adjustment
	idle_sway_rotation_strength = WEAPON_TYPE.idle_sway_rotation_strength
	random_sway_amount = WEAPON_TYPE.random_sway_amount


func sway_weapon(delta, isIdle: bool) -> void:
	if isIdle:
		var sway_random: float = get_sway_noise()
		var sway_random_adjusted: float = sway_random * idle_sway_adjustment

		time += delta * (sway_speed + sway_random)
		random_sway_x = sin(time * 1.5 + sway_random_adjusted) / random_sway_amount
		random_sway_y = sin(time - sway_random_adjusted) / random_sway_amount

		mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
		position.x = lerp(position.x, WEAPON_TYPE.position.x - \
			(mouse_movement.x * WEAPON_TYPE.sway_amount_position + random_sway_x) * delta, \
			WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, WEAPON_TYPE.position.y + \
			(mouse_movement.y * WEAPON_TYPE.sway_amount_position + random_sway_y) * delta, \
			WEAPON_TYPE.sway_speed_position)
		rotation_degrees.y = lerp(rotation_degrees.y, WEAPON_TYPE.rotation.y + \
			(mouse_movement.x * WEAPON_TYPE.sway_amount_rotation + \
			random_sway_y * idle_sway_rotation_strength) * delta, \
			WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.x = lerp(rotation_degrees.x, WEAPON_TYPE.rotation.x - \
			(mouse_movement.y * WEAPON_TYPE.sway_amount_rotation + \
			random_sway_x * idle_sway_rotation_strength) * delta, \
			WEAPON_TYPE.sway_speed_rotation)
	else:
		mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
		position.x = lerp(position.x, WEAPON_TYPE.position.x - \
			(mouse_movement.x * WEAPON_TYPE.sway_amount_position + weapon_bob_amount.x) * delta, \
			WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, WEAPON_TYPE.position.y + \
			(mouse_movement.y * WEAPON_TYPE.sway_amount_position + weapon_bob_amount.y) * delta, \
			WEAPON_TYPE.sway_speed_position)
		rotation_degrees.y = lerp(rotation_degrees.y, \
			WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation) * delta, \
			WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.x = lerp(rotation_degrees.x, \
			WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation) * delta, \
			WEAPON_TYPE.sway_speed_rotation)


func weapon_bob(delta, bob_speed: float, hbob_amount: float, vbob_amount: float) -> void:
	time += delta
	weapon_bob_amount.x = sin(time * bob_speed) * hbob_amount
	weapon_bob_amount.y = abs(sin(time * bob_speed)) * vbob_amount


func get_sway_noise() -> float:
	var player_position := Vector3.ZERO
	if not Engine.is_editor_hint():
		player_position = Global.player.global_position
	var noise_location: float = sway_noise.noise.get_noise_2d(player_position.x, player_position.y)
	return noise_location


func attack() -> void:
	var camera = Global.player.CAMERA_CONTROLLER
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		test_raycast(result.get("position"))


func test_raycast(position: Vector3) -> void:
	var instance = raycast_test.instantiate()
	get_tree().root.add_child(instance)
	instance.global_position = position
	await get_tree().create_timer(3).timeout
	instance.queue_free()
