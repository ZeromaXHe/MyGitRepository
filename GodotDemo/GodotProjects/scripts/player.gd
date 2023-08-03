class_name Player
extends CharacterBody2D

signal player_fired_bullet(bullet: Bullet, posi, direction)

@export var bullet_scene: PackedScene
@export var speed: int = 300

@onready var muzzle: Node2D = $Muzzle
@onready var barrel: Node2D = $Barrel

func get_input():
	look_at(get_global_mouse_position())
	velocity = Input.get_vector("left", "right", "up", "down") * speed
#	velocity = (Vector2.UP * Input.get_axis("down", "up")
#			 + Vector2.RIGHT * Input.get_axis("left", "right")) \
#			.normalized() * speed


func fire_bullet() -> void:
	if Input.is_action_pressed("shoot"):
		var bullet: Bullet = bullet_scene.instantiate()
		var direction: Vector2 = barrel.global_position \
				.direction_to(muzzle.global_position) \
				.normalized()
		emit_signal("player_fired_bullet", bullet, muzzle.global_position, direction)

func _physics_process(delta):
	get_input()
	fire_bullet()
	move_and_slide()
