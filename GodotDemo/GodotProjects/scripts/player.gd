class_name Player
extends CharacterBody2D

@export var speed: int = 300

@onready var health: Health = $Health
@onready var weapon: Weapon = $Weapon
@onready var team: Team = $Team


func _ready():
	weapon.initialize(team.team)


func _physics_process(delta):
	get_input()
	shoot()
	move_and_slide()


func get_input():
	look_at(get_global_mouse_position())
	velocity = Input.get_vector("left", "right", "up", "down") * speed
#	velocity = (Vector2.UP * Input.get_axis("down", "up")
#			 + Vector2.RIGHT * Input.get_axis("left", "right")) \
#			.normalized() * speed


func shoot():
	if Input.is_action_just_pressed("shoot"):
		weapon.shoot()


func get_team() -> Team.TeamName:
	return team.team


func handle_hit(bullet: Bullet):
	health.hp -= bullet.damage
	print("player hit! ", health.hp)
