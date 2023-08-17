extends CanvasLayer
class_name GUI


@onready var kill_info: RichTextLabel = $Rows/TopRow/MarginContainer/KillInfo
@onready var hp_bar: ProgressBar = $Rows/BottomRow/MarginContainer/HpBar
@onready var current_ammo: Label = $Rows/BottomRow/CurrentAmmo
@onready var max_ammo: Label = $Rows/BottomRow/MaxAmmo
@onready var base_a_label: Label = $BaseALabel
@onready var base_b_label: Label = $BaseBLabel
@onready var base_c_label: Label = $BaseCLabel
@onready var aim_mark: TextureRect = $AimMark
@onready var hit_mark: TextureRect = $HitMark
@onready var hit_mark_hide_timer: Timer = $HitMark/HitMarkHideTimer
@onready var mini_map: MiniMap = $Rows/TopRow/SubViewportContainer/SubViewport/MiniMap

var max_ammo_value: int
var player: Player = null

var base_a: CapturableBase = null
var base_b: CapturableBase = null
var base_c: CapturableBase = null


func _ready() -> void:
	GlobalMediator.gui = self
	# 清空 KillInfo 的内容
	kill_info.text = ""
	GlobalSignals.actor_killed.connect(handle_actor_killed)
	hp_bar.value = 100
	hit_mark.hide()
	aim_mark.show()
	
	# 基地方位标签相关绑定
	bind_bases()


func _process(_delta: float) -> void:
	if base_a_label.visible:
		base_a_label.position = calc_base_label_position(base_a)
	if base_b_label.visible:
		base_b_label.position = calc_base_label_position(base_b)
	if base_c_label.visible:
		base_c_label.position = calc_base_label_position(base_c)
	
	# TextureRect 居然还要自己减 pivot_offset？
	aim_mark.global_position = aim_mark.get_global_mouse_position() - aim_mark.pivot_offset


func handle_actor_killed(killed: Actor, killer: Actor):
	if killer.is_player():
		# 显示玩家击杀标志
		show_player_hit_mark(true)
	
	kill_info.handle_actor_killed(killed, killer)
	mini_map.delete_actor_icon(killed)


func handle_unit_spawned(actor: Actor):
	# 小地图创建角色图标
	mini_map.create_actor_icon(actor)


func player_fired():
	# scale 是 Vector2，写成 float 也不报错…… Godot 这个隐藏错误的特性真是让人头大，我还是喜欢尽早暴露异常
	var tween = get_tree().create_tween()
	tween.tween_property(aim_mark, "scale", Vector2(1.5, 1.5), 0.05)
	tween.tween_property(aim_mark, "scale", Vector2.ONE, 0.05)


func show_player_hit_mark(kill: bool):
	# DisplayServer.mouse_get_position() 结果是 Vector2i，而且是屏幕坐标不是窗口坐标！
	hit_mark.global_position = hit_mark.get_global_mouse_position() - hit_mark.pivot_offset
	hit_mark.modulate = Color(Color.RED, 0.7) if kill else Color(Color.WHITE, 0.7)
	hit_mark.scale = Vector2(1.5, 1.5) if kill else Vector2.ONE
	hit_mark.show()
	hit_mark_hide_timer.start()


func _on_hit_mark_hide_timer_timeout() -> void:
	hit_mark.hide()


func calc_base_label_position(base: CapturableBase) -> Vector2:
	var player_to_base_dir: Vector2 = player.global_position.direction_to(base.global_position)
	# 长宽比，即 x: y
	var dir_aspect = player_to_base_dir.aspect()
	var window_size := Vector2(get_window().size)
	var window_aspect = window_size.aspect()
	if abs(dir_aspect) > abs(window_aspect):
		# 方向向量的射线必定和窗口左右边缘相交，所以以 x 轴方向放缩
		return window_size / 2 + player_to_base_dir / abs(player_to_base_dir.x) * (window_size.x / 2 - 100) 
	else:
		# 方向向量的射线必定和窗口上下边缘相交，所以以 y 轴方向放缩
		return window_size / 2 + player_to_base_dir / abs(player_to_base_dir.y) * (window_size.y / 2 - 50) 
	

func bind_bases():
	# TODO: 目前绑定的代码写得太死了。先实现功能，之后优化
	for base in GlobalMediator.capturable_base_manager.capturable_bases:
		var cap_base = base as CapturableBase
		match (cap_base.point_code):
			"A":
				base_a = cap_base
				base_a_label.visible = not cap_base.out_screen_notifier.is_on_screen()
			"B":
				base_b = cap_base
				base_b_label.visible = not cap_base.out_screen_notifier.is_on_screen()
			"C":
				base_c = cap_base
				base_c_label.visible = not cap_base.out_screen_notifier.is_on_screen()
		cap_base.exited_screen.connect(handle_base_exited_screen)
		cap_base.entered_screen.connect(handle_base_entered_screen)
		cap_base.base_captured.connect(handle_base_captured)
		
		mini_map.create_base_icon(cap_base)


func handle_base_exited_screen(base: CapturableBase):
	update_base_label_visible(base, true)


func handle_base_entered_screen(base: CapturableBase):
	update_base_label_visible(base, false)


func handle_base_captured(base: CapturableBase, _actors: Array[Actor]):
	match (base.point_code):
		"A":
			base_a_label.modulate = base.get_color(base.team.side)
		"B":
			base_b_label.modulate = base.get_color(base.team.side)
		"C":
			base_c_label.modulate = base.get_color(base.team.side)


func update_base_label_visible(base: CapturableBase, new_visible: bool):
	match (base.point_code):
		"A":
			base_a_label.visible = new_visible
		"B":
			base_b_label.visible = new_visible
		"C":
			base_c_label.visible = new_visible


func set_player(new_player: Player):
	self.player = new_player
	
	set_new_health_value(new_player.health.hp)
	set_weapon(new_player.weapon_manager.current_weapon)
	new_player.health.changed.connect(set_new_health_value)
	if not new_player.weapon_manager.weapon_changed.is_connected(handle_weapon_changed):
		new_player.weapon_manager.weapon_changed.connect(handle_weapon_changed)


func handle_weapon_changed(_old_weapon: Weapon, new_weapon: Weapon):
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
