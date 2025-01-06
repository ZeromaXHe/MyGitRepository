class_name DoorComponent
extends Area3D

enum DoorType {SLIDING, ROTATING, PHYSICS}
enum ForwardDirection {X, Y, Z}
enum DoorStatus {OPEN, CLOSED}
enum DoorOperation {MANUAL, CLOSE_AUTOMATICALLY, OPEN_CLOSE_AUTOMATICALLY}

@export_group("门设置")
@export var door_type: DoorType
@export var forward_direction: ForwardDirection
@export var movement_direction: Vector3
@export var rotation_axis := Vector3.UP
@export var rotation_amount : float = 90.0
@export var door_size: Vector3
@export var physics_force: float = 30.0
@export_group("关门设置")
@export var door_operation: DoorOperation
@export var close_time: float = 2.0
@export_group("Tween 设置")
@export var speed: float = 0.5
@export var transition: Tween.TransitionType
@export var easing: Tween.EaseType

var parent
var orig_pos: Vector3
var orig_rot: Vector3
var rotation_adjustment: float
var door_direction: Vector3
var door_status := DoorStatus.CLOSED


func _ready() -> void:
	parent = get_parent()
	orig_pos = parent.position
	orig_rot = parent.rotation
	parent.ready.connect(connect_parent)
	body_entered.connect(on_trigger)
	body_exited.connect(off_trigger)


func connect_parent() -> void:
	#print("door interacted signal connecting: ", parent.has_user_signal("interacted"))
	if door_operation == DoorOperation.MANUAL \
			or door_operation == DoorOperation.CLOSE_AUTOMATICALLY \
			or door_type == DoorType.PHYSICS:
		parent.connect("interacted", check_door)


func on_trigger(body: Node3D) -> void:
	if body is CharacterBody3D and door_operation == DoorOperation.OPEN_CLOSE_AUTOMATICALLY:
		check_door()


func off_trigger(body: Node3D) -> void:
	if body is CharacterBody3D and door_operation == DoorOperation.OPEN_CLOSE_AUTOMATICALLY:
		check_door()


func check_door() -> void:
	match forward_direction:
		ForwardDirection.X:
			door_direction = parent.global_transform.basis.x
		ForwardDirection.Y:
			door_direction = parent.global_transform.basis.y
		ForwardDirection.Z:
			door_direction = parent.global_transform.basis.z
	var door_position: Vector3 = parent.global_position
	var player_position: Vector3 = Global.player.global_position
	var direction_to_player: Vector3 = door_position.direction_to(player_position)
	var door_dot: float = direction_to_player.dot(door_direction)
	if door_dot < 0:
		rotation_adjustment = 1
	else:
		rotation_adjustment = -1
	#print("check_door forward:", forward_direction, ", door_direction: ", door_direction, \
		#", door_position: ", door_position, ", player_position: ", player_position, \
		#", door_dot: ", door_dot)
	if door_type == DoorType.PHYSICS:
		#print("physics door check")
		var door = parent as RigidBody3D
		door.apply_impulse(door_direction * physics_force * rotation_adjustment)
	else:
		match door_status:
			DoorStatus.CLOSED:
				open_door()
			DoorStatus.OPEN:
				close_door()


func open_door() -> void:
	#print("open door")
	door_status = DoorStatus.OPEN
	var tween = get_tree().create_tween()
	match door_type:
		DoorType.SLIDING:
			tween.tween_property(parent, "position", \
				orig_pos + (movement_direction * door_size), speed) \
				.set_trans(transition) \
				.set_ease(easing)
		DoorType.ROTATING:
			tween.tween_property(parent, "rotation", \
				orig_rot + (rotation_axis * rotation_adjustment * deg_to_rad(rotation_amount)), speed) \
				.set_trans(transition) \
				.set_ease(easing)
	if door_operation == DoorOperation.CLOSE_AUTOMATICALLY:
		tween.tween_interval(close_time)
		tween.tween_callback(close_door)


func close_door() -> void:
	#print("close door")
	door_status = DoorStatus.CLOSED
	var tween = get_tree().create_tween()
	match door_type:
		DoorType.SLIDING:
			tween.tween_property(parent, "position", orig_pos, speed) \
				.set_trans(transition) \
				.set_ease(easing)
		DoorType.ROTATING:
			tween.tween_property(parent, "rotation", orig_rot, speed) \
				.set_trans(transition) \
				.set_ease(easing)
