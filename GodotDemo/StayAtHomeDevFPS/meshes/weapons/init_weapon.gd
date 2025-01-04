@tool
extends Node3D

@export var WEAPON_TYPE: Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			print("更换武器！")
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shadow: MeshInstance3D = %WeaponShadow

func _ready() -> void:
	load_weapon()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon1"):
		WEAPON_TYPE = load("res://meshes/weapons/crowbar/crowbar.tres")
		load_weapon()
	if event.is_action_pressed("weapon2"):
		WEAPON_TYPE = load("res://meshes/weapons/crowbar2/crowbar_left.tres")
		load_weapon()


func load_weapon() -> void:
	weapon_mesh.mesh = WEAPON_TYPE.mesh
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation
	weapon_shadow.mesh = WEAPON_TYPE.mesh # 自己加的。为啥教程里不设置 mesh？
	weapon_shadow.visible = WEAPON_TYPE.shadow
