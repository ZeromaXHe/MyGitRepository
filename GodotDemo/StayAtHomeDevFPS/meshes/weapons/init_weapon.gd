@tool
extends Node3D

@export var WEAPON_TYPE: Weapons:
	set(value):
		WEAPON_TYPE = value
		# 不加 is_node_ready() 的话，
		# 好像会有个 WEAPON_TYPE 为 null 时调用 load_weapon 的报错
		if is_node_ready() and Engine.is_editor_hint():
			print("更换武器！")
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shadow: MeshInstance3D = %WeaponShadow

var mouse_movement: Vector2

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


func sway_weapon(delta) -> void:
	mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
	position.x = lerp(position.x, \
		WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position) * delta, \
		WEAPON_TYPE.sway_speed_position)
	position.y = lerp(position.y, \
		WEAPON_TYPE.position.y + (mouse_movement.y * WEAPON_TYPE.sway_amount_position) * delta, \
		WEAPON_TYPE.sway_speed_position)
	rotation_degrees.y = lerp(rotation_degrees.y, \
		WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation) * delta, \
		WEAPON_TYPE.sway_speed_rotation)
	rotation_degrees.x = lerp(rotation_degrees.x, \
		WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation) * delta, \
		WEAPON_TYPE.sway_speed_rotation)


func _physics_process(delta: float) -> void:
	sway_weapon(delta)
