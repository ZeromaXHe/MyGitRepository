extends Node2D
class_name Weapon

signal weapon_out_of_ammo

@export var bullet_scene: PackedScene

@onready var muzzle: Node2D = $Muzzle
@onready var barrel: Node2D = $Barrel
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle_flash: Sprite2D = $MuzzleFlash

var team_side: Team.Side = -1
var max_ammo: int = 10
var current_ammo: int = max_ammo


func _ready() -> void:
	muzzle_flash.hide()


func initialize(team_side: Team.Side):
	self.team_side = team_side


func start_reload():
	print("reloading!")
	animation_player.play("reload")


func _end_reload():
	current_ammo = max_ammo


func shoot():
	# 子弹不足/冷却时间中/没有子弹实例
	if current_ammo <= 0 or not attack_cooldown.is_stopped() or bullet_scene == null:
#		print("attack_cooldown.is_stopped():" + str(attack_cooldown.is_stopped()))
		return

	var bullet: Bullet = bullet_scene.instantiate()
	# direction_to 不需要重复 normalized()
	var direction: Vector2 = barrel.global_position \
			.direction_to(muzzle.global_position)
	GlobalSignals.bullet_fired.emit(bullet, team_side, muzzle.global_position, direction)

	# 开启攻击冷却计时器
	attack_cooldown.start()
	# 播放枪口闪光动画
	animation_player.play("muzzle_flash")
	current_ammo -= 1
	if current_ammo == 0:
		weapon_out_of_ammo.emit()

