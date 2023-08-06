class_name Player
extends CharacterBody2D


signal died(killer)


@export var speed: int = 300

@onready var health: Health = $Health
@onready var weapon: Weapon = $Weapon
@onready var team: Team = $Team
@onready var camera_transform: RemoteTransform2D = $CameraTransform


func _ready():
	# FIXME: 这里命名生成有问题，估计有时执行的时候之前的引用还没释放，导致重名
	name = "Player"
	weapon.initialize(team.side, self)


func _physics_process(delta):
	get_input()
	move_and_slide()


func get_input():
	look_at(get_global_mouse_position())
	velocity = Input.get_vector("left", "right", "up", "down") * speed
#	velocity = (Vector2.UP * Input.get_axis("down", "up")
#			 + Vector2.RIGHT * Input.get_axis("left", "right")) \
#			.normalized() * speed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		weapon.shoot()
	elif event.is_action_released("reload"):
		reload()


func set_camera_transform(camera_path: NodePath):
	camera_transform.remote_path = camera_path


func reload():
	weapon.start_reload()


func get_team() -> Team.Side:
	return team.side


func handle_hit(bullet: Bullet):
	health.hp -= bullet.damage
	print("player hit! ", health.hp)
	if health.hp <= 0:
		die(bullet)


func die(bullet: Bullet):
	print("player died!!!")
	var killer_name = bullet.shooter_name
	died.emit(killer_name)
	GlobalSignals.killed_info.emit(self.team.side, self.name, \
			bullet.team_side, killer_name)
	queue_free()

