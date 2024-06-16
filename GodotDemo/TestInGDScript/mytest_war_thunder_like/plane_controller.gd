extends Node3D


signal throttle_changed(throttle: float)
signal height_changed(height: float)


const explosion_scene: PackedScene = preload("res://mytest_war_thunder_like/explosion.tscn")

@export var controlled_plane: AirPlane = null

@onready var camera: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if controlled_plane == null:
		controlled_plane = get_parent() as AirPlane


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	controlled_plane.roll = -1 if Input.is_action_pressed("A") else 0 \
		+ 1 if Input.is_action_pressed("D") else 0
	controlled_plane.pitch = -1 if Input.is_action_pressed("S") else 0 \
		+ 1 if Input.is_action_pressed("W") else 0
	controlled_plane.yaw = -1 if Input.is_action_pressed("Q") else 0 \
		+ 1 if Input.is_action_pressed("E") else 0
	if Input.is_action_just_pressed("Ctrl"):
		controlled_plane.throttle -= 0.1
		throttle_changed.emit(controlled_plane.throttle)
	if Input.is_action_just_pressed("Shift"):
		controlled_plane.throttle += 0.1
		throttle_changed.emit(controlled_plane.throttle)
	if Input.is_action_just_pressed("Click"):
		var explosion := explosion_scene.instantiate() as Explosion
		add_child(explosion)
		explosion.explode()
	height_changed.emit(controlled_plane.global_position.y)
