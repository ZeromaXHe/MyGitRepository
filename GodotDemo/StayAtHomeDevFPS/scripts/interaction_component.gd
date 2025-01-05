class_name InteractionComponent
extends Node

signal player_interacted(object: RigidBody3D)

@export var mesh: MeshInstance3D
@export var context: String
@export var override_icon: bool
@export var new_icon: String

var parent
var highlight_material = preload("res://materials/interactable_highlight.tres")


func _ready() -> void:
	parent = get_parent()
	connect_parent()
	set_default_mesh()


func _process(delta: float) -> void:
	pass


func in_range() -> void:
	mesh.material_overlay = highlight_material
	MessageBus.interaction_focused.emit(context, new_icon, override_icon)


func not_in_range() -> void:
	mesh.material_overlay = null
	MessageBus.interaction_unfocused.emit()


func on_interact() -> void:
	player_interacted.emit(parent)


func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")
	parent.connect("focused", in_range)
	parent.connect("unfocused", not_in_range)
	parent.connect("interacted", on_interact)


func set_default_mesh() -> void:
	if mesh:
		pass
	else:
		for i in parent.get_children():
			if i is MeshInstance3D:
				mesh = i
