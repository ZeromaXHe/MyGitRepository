class_name DoorComponent
extends Node

@export var direction: Vector3
@export var door_size: Vector3
@export var speed: float = 0.5
@export var close_time: float = 2.0
@export var transition: Tween.TransitionType
@export var easing: Tween.EaseType

var parent
var orig_pos: Vector3


func _ready() -> void:
	parent = get_parent()
	orig_pos = parent.position
	parent.ready.connect(connect_parent)


func connect_parent() -> void:
	print("door interacted signal connecting: ", parent.has_user_signal("interacted"))
	parent.connect("interacted", open_door)


func open_door() -> void:
	print("open door")
	var tween = get_tree().create_tween()
	tween.tween_property(parent, "position", orig_pos + (direction * door_size), speed) \
		.set_trans(transition) \
		.set_ease(easing)
	tween.tween_interval(close_time)
	tween.tween_callback(close_door)


func close_door() -> void:
	print("close door")
	var tween = get_tree().create_tween()
	tween.tween_property(parent, "position", orig_pos, speed) \
		.set_trans(transition) \
		.set_ease(easing)
