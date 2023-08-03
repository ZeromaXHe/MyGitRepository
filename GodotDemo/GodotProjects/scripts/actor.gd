extends CharacterBody2D
class_name Enemy

@export var speed: int = 100

@onready var health: Health = $Health
@onready var ai: AI = $AI
@onready var weapon: Weapon = $Weapon
@onready var team: Team = $Team


func _ready():
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team)


func rotate_toward(location: Vector2) -> float:
	var angle_to_location = global_position \
			.direction_to(location) \
			.angle()
#	print("rot: ", rotation, ", ang: ", angle_to_location)
	# 注意要用 lerp_angle 而不是 lerp
	# 否则 angle_to_location 刚好 PI 到 -PI 的弧度转换的地方会导致敌人反向旋转
	rotation = lerp_angle(rotation, angle_to_location, 0.1)
	return angle_to_location


func velocity_toward(location: Vector2):
	velocity = global_position.direction_to(location) * speed


func get_team() -> Team.TeamName:
	return team.team


func handle_hit(bullet: Bullet):
	health.hp -= bullet.damage
	print("enemy hit! ", health.hp)
	if health.hp <= 0:
		queue_free()
