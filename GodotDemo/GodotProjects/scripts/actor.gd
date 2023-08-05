extends CharacterBody2D
class_name Actor


signal died


@export var speed: int = 100

@onready var health: Health = $Health
@onready var ai: AI = $AI
@onready var weapon: Weapon = $Weapon
@onready var team: Team = $Team


func _ready():
	ai.initialize(self, weapon, team.side)
	weapon.initialize(team.side)


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


func has_reached_position(location: Vector2) -> bool:
	return global_position.distance_to(location) < 5


func get_team() -> Team.Side:
	return team.side


func handle_hit(bullet: Bullet):
	health.hp -= bullet.damage
	print("enemy hit! ", health.hp)
	if health.hp <= 0:
		die()


func die():
	died.emit()
	queue_free()
