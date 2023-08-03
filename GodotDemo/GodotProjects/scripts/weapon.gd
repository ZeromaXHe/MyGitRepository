extends Node2D
class_name Weapon

@export var bullet_scene: PackedScene

@onready var muzzle: Node2D = $Muzzle
@onready var barrel: Node2D = $Barrel
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var team: Team.TeamName = -1


func initialize(team: Team.TeamName):
	self.team = team


func shoot():
	# 冷却时间中
	if not attack_cooldown.is_stopped():
#		print("attack_cooldown.is_stopped():" + str(attack_cooldown.is_stopped()))
		return

	var bullet: Bullet = bullet_scene.instantiate()
	# direction_to 不需要重复 normalized()
	var direction: Vector2 = barrel.global_position \
			.direction_to(muzzle.global_position)
	GlobalSignals.bullet_fired.emit(bullet, team, muzzle.global_position, direction)

	# 开启攻击冷却计时器
	attack_cooldown.start()
	# 播放枪口闪光动画
	animation_player.play("muzzle_flash")
