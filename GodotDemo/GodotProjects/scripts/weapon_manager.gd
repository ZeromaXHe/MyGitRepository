extends Node2D
class_name WeaponManager

signal weapon_changed(old_weapon: Weapon, new_weapon: Weapon)

# 换弹音效
const female_reload_sound: AudioStream = preload("res://audio/kenney_voiceover_pack/Female/war_reloading.ogg")
const male_reload_sound: AudioStream = preload("res://audio/kenney_voiceover_pack/Male/war_reloading.ogg")

@onready var current_weapon: Weapon = $Pistol

var weapons: Array = []

var holder: Actor = null


func _ready() -> void:
	weapons = get_children()
	
	for weapon in weapons:
		weapon.hide()
	current_weapon.show()


func initialize(holder: Actor):
	self.holder = holder

	if not holder.is_player():
		# 如果是 AI，没子弹了立即换弹
		current_weapon.weapon_out_of_ammo.connect(reload)


func switch_weapon(idx: int):
	if idx >= 0 and idx < weapons.size() and weapons[idx] != current_weapon:
		weapon_changed.emit(current_weapon, weapons[idx])
		current_weapon.hide()
		current_weapon = weapons[idx]
		current_weapon.show()


func reset_to_max_ammo():
	current_weapon.current_ammo = current_weapon.max_ammo


func shoot():
	current_weapon.shoot(holder)


func reload():
	var voice = female_reload_sound if holder.team.character == Team.Character.ALLY else male_reload_sound
	holder.voice_and_chat(voice, "Reloading!")
	current_weapon.start_reload()
