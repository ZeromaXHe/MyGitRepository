extends CharacterBody2D
class_name Actor


signal died(actor: Actor, killer_name: String)


@export var speed: int = 100
@export var player_control: bool = false

@onready var health: Health = $Health
@onready var ai: AI = $AI
@onready var weapon: Weapon = $Weapon
@onready var team: Team = $Team
@onready var name_label_transform: RemoteTransform2D = $NameLabelTransform
@onready var camera_transform: RemoteTransform2D = $CameraTransform

var spawn_idx: int = -1
var name_label_node2d: Node2D = null


func _ready():
	if player_control:
		# FIXME: 这里命名生成有问题，估计有时执行的时候之前的引用还没释放，导致重名
		name = "Player"
	ai.initialize(self, weapon, team.side)
	weapon.initialize(team.side, self)


func set_camera_transform(camera_path: NodePath):
	camera_transform.remote_path = camera_path


func set_name_label_node2d(name_label_node2d: Node2D):
	self.name_label_node2d = name_label_node2d
	self.name_label_transform.remote_path = name_label_node2d.get_path()


func set_ai_advance_to(target_base: CapturableBase):
	if target_base != null:
		ai.advance_to(target_base)


func set_actor_name(actor_name: String):
	self.name = actor_name

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
	print(name, " hit! ", health.hp)
	if health.hp <= 0:
		die(bullet)


func die(bullet: Bullet):
	var killer_name = bullet.shooter_name
	died.emit(self, killer_name)
	GlobalSignals.killed_info.emit(self.team.side, self.name, \
			bullet.team_side, killer_name)
	if (name_label_node2d != null):
		name_label_node2d.queue_free()
	queue_free()
