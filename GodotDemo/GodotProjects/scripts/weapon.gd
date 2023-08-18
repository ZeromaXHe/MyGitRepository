@tool
extends Node2D
class_name Weapon

signal weapon_out_of_ammo
signal ammo_changed(new_ammo: int)

@export var bullet_scene: PackedScene
@export var max_ammo: int = 10
@export var semi_auto: bool = true

@onready var muzzle: Node2D = $Muzzle
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle_flash: Sprite2D = $MuzzleFlash

var current_ammo: int = max_ammo:
	set = set_current_ammo


func _get_configuration_warnings() -> PackedStringArray:
	# 在代码开头加上 @tool 才可以生效
	var result: PackedStringArray = []
	if animation_player == null:
		result.append("Weapon 实现类下必须拥有一个名为 AnimationPlayer 的动画播放器节点")
	else:
		if not animation_player.has_animation("reload"):
			result.append("AnimationPlayer 必须具有 reload 动画")
		if not animation_player.has_animation("muzzle_flash"):
			result.append("AnimationPlayer 必须具有 muzzle_falsh 动画")
	return result


func _ready() -> void:
	if not Engine.is_editor_hint():
		muzzle_flash.hide()
		# 不加的话赋值不正确，不知道什么原因
		current_ammo = max_ammo


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



func shoot(holder: Actor):
	# 子弹不足/冷却时间中/没有子弹实例
	if current_ammo <= 0 or not attack_cooldown.is_stopped() or bullet_scene == null:
#		print("attack_cooldown.is_stopped():" + str(attack_cooldown.is_stopped()))
		return

	var bullet: Bullet = bullet_scene.instantiate()
	bullet.shooter = holder
	bullet.from_weapon = self
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
