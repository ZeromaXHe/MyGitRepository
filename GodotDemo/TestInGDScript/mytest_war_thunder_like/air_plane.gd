class_name AirPlane
extends Node3D


const max_angle: float = PI / 6
const max_pitch_rotation: float = PI / 3
const max_roll_rotation: float = PI / 3
const max_yaw_rotation: float = PI / 6
const full_speed: float = 500 / 3.6

# 节流阀/油门
var throttle: float = 0.1:
	set(value):
		throttle = clampf(value, 0, 1.1)

@onready var left_aileron_root: Node3D = $Body/LeftWing/AileronRoot
@onready var right_aileron_root: Node3D = $Body/RightWing/AileronRoot
@onready var left_elevator_root: Node3D = $Body/LeftTail/ElevatorRoot
@onready var right_elevator_root: Node3D = $Body/RightTail/ElevatorRoot
@onready var rudder_root: Node3D = $Body/VerticalTail/RudderRoot

# 参考：pitch、yaw、roll三个角的区别（yaw angle 偏航角，steering angle 航向角的解释）
# https://blog.csdn.net/qq_38800089/article/details/108768388 
## 俯仰
@export_range(-1, 1) var pitch: float = 0:
	set(value):
		pitch = value
		left_elevator_root.rotation = Vector3(value * max_angle, 0, 0)
		right_elevator_root.rotation = Vector3(value * max_angle, 0, 0)
## 滚转
@export_range(-1, 1) var roll: float = 0:
	set(value):
		roll = value
		left_aileron_root.rotation = Vector3(value * max_angle, 0, 0)
		right_aileron_root.rotation = Vector3(-value * max_angle, 0, 0)
## 偏航
@export_range(-1, 1) var yaw: float = 0:
	set(value):
		yaw = value
		rudder_root.rotation = Vector3(-value * max_angle, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pitch_rotation_delta: float = pitch * delta * max_pitch_rotation
	rotate_object_local(Vector3.LEFT, pitch_rotation_delta)
	var roll_rotation_delta: float = roll * delta * max_roll_rotation
	rotate_object_local(Vector3.FORWARD, roll_rotation_delta)
	var yaw_rotation_delta: float = yaw * delta * max_yaw_rotation
	rotate_object_local(Vector3.DOWN, yaw_rotation_delta)
	translate_object_local(Vector3.FORWARD * delta * full_speed * throttle)
