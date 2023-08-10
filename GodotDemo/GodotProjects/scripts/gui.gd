extends CanvasLayer
class_name GUI


@onready var kill_info: RichTextLabel = $Rows/TopRow/MarginContainer/KillInfo
@onready var hp_bar: ProgressBar = $Rows/BottomRow/MarginContainer/HpBar
@onready var current_ammo: Label = $Rows/BottomRow/CurrentAmmo
@onready var max_ammo: Label = $Rows/BottomRow/MaxAmmo

var max_ammo_value: int
var player: Player = null

func _ready() -> void:
	# 清空 KillInfo 的内容
	kill_info.text = ""
	GlobalSignals.actor_killed.connect(kill_info.handle_actor_killed)
	hp_bar.value = 100


func set_player(player: Player):
	self.player = player
	
	set_new_health_value(player.health.hp)
	set_weapon(player.weapon_manager.current_weapon)
	player.health.changed.connect(set_new_health_value)
	if not player.weapon_manager.weapon_changed.is_connected(handle_weapon_changed):
		player.weapon_manager.weapon_changed.connect(handle_weapon_changed)


func handle_weapon_changed(old_weapon: Weapon, new_weapon: Weapon):
	set_weapon(new_weapon)


func set_weapon(weapon: Weapon):
	set_max_ammo(weapon.max_ammo)
	set_current_ammo(weapon.current_ammo)
	weapon.ammo_changed.connect(set_current_ammo)


func set_new_health_value(new_health: float):
	if abs(new_health - hp_bar.value) >= 10:
		# Godot 4 的 Tween 不再是节点了，直接这样调用即可获取。具体看 Tween 的文档
		# 貌似不能复用，提取到 _ready() 里面初始化会无效
		var tween = get_tree().create_tween()
		tween.tween_property(hp_bar, "value", new_health, 0.3)
		var bar_fill_style: StyleBoxFlat = hp_bar.get("theme_override_styles/fill")
		var original_color: Color = Color("#b44141")
		var highlight_color: Color = Color.LIGHT_CORAL
		tween.tween_property(bar_fill_style, "bg_color", highlight_color, 0.15)
		tween.tween_property(bar_fill_style, "bg_color", original_color, 0.15)
	else:
		# 修改生命比较小的情况就不用 tween 了（呼吸回血）
		hp_bar.value = new_health


func set_current_ammo(new_ammo: int):
	current_ammo.text = str(new_ammo)
	# 根据剩余弹药量显示不同颜色
	if new_ammo == 0:
		current_ammo.modulate = Color.RED
	elif new_ammo < 0.3 * max_ammo_value:
		current_ammo.modulate = Color.ORANGE
	elif new_ammo <= 0.5 * max_ammo_value:
		current_ammo.modulate = Color.YELLOW
	else:
		current_ammo.modulate = Color.WHITE


func set_max_ammo(new_max_ammo: int):
	max_ammo.text = str(new_max_ammo)
	max_ammo_value = new_max_ammo
