extends Node2D
class_name Weapon

signal weapon_out_of_ammo
signal ammo_changed(new_ammo: int)

@export var bullet_scene: PackedScene

@onready var muzzle: Node2D = $Muzzle
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle_flash: Sprite2D = $MuzzleFlash

var max_ammo: int = 10
var current_ammo: int = max_ammo:
	set = set_current_ammo 
var holder: Actor = null


func _ready() -> void:
	muzzle_flash.hide()


func initialize(holder: Actor):
	self.holder = holder


func start_reload():
	print("reloading!")
	animation_player.play("reload")


func _end_reload():
	current_ammo = max_ammo


func set_current_ammo(ammo: int):
	var actual_ammo = clamp(ammo, 0, max_ammo)
	if (current_ammo == actual_ammo):
		return
	current_ammo = actual_ammo
	ammo_changed.emit(actual_ammo)
	if current_ammo == 0:
		weapon_out_of_ammo.emit()



func shoot():
	# 子弹不足/冷却时间中/没有子弹实例
	if current_ammo <= 0 or not attack_cooldown.is_stopped() or bullet_scene == null:
#		print("attack_cooldown.is_stopped():" + str(attack_cooldown.is_stopped()))
		return

	var bullet: Bullet = bullet_scene.instantiate()
	bullet.shooter = holder
	bullet.global_position = muzzle.global_position
	# direction_to 不需要重复 normalized()
	var direction: Vector2 = global_position.direction_to(muzzle.global_position)
	bullet.set_direction(direction)
	bullet.team = holder.team
	GlobalSignals.bullet_fired.emit(bullet)

	# 开启攻击冷却计时器
	attack_cooldown.start()
	# 播放枪口闪光动画
	animation_player.play("muzzle_flash")
	current_ammo -= 1

