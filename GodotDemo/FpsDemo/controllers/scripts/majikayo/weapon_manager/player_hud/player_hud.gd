extends Control


@export var player: CharacterBody3D
@export var weapon_manager: WeaponManager

@export var weapon_select_layout: PackedScene
const MAX_WEAPONS_PER_SLOT = 10

const WEAPON_SWITCH_MENU_STAY_DURATION = 2000
const WEAPON_SWITCH_MENU_FADE_DURATION = 250

var hovered_weapon: WeaponResource
var last_activated_menu: int = -999999


func get_weapon_menu_visibility() -> float:
	return 1.0 - clampf(
		float(Time.get_ticks_msec() - (last_activated_menu + WEAPON_SWITCH_MENU_STAY_DURATION)) \
		/ WEAPON_SWITCH_MENU_FADE_DURATION, 0.0, 1.0)


func get_all_weapons_ordered() -> Array[WeaponResource]:
	var weapons = weapon_manager.equipped_weapon.slice(0)
	weapons.sort_custom(func(w1, w2):
		if w1.slot != w2.slot:
			return w1.slot < w2.slot
		var diff = w1.slot_priority - w2.slot_priority
		return w1.get_rid().get_id() < w2.get_rid().get_id() if diff == 0 else diff < 0)
	return weapons


func get_weapons_in_slot(slot: int) -> Array[WeaponResource]:
	return get_all_weapons_ordered().filter(func(w): return w.slot == slot)


func cycle_through_weapons(amount: int):
	var all_weapons = get_all_weapons_ordered()
	if get_weapon_menu_visibility() == 0.0:
		hovered_weapon = weapon_manager.current_weapon
	if not hovered_weapon and len(all_weapons) > 0:
		hovered_weapon = all_weapons[0]
	if not hovered_weapon or len(all_weapons) == 0:
		return
	var cur_index = all_weapons.find(hovered_weapon)
	var new_index = (cur_index + amount) % len(all_weapons)
	hovered_weapon = all_weapons[new_index]
	show_weapon_switch_menu()


func show_weapon_switch_menu():
	last_activated_menu = Time.get_ticks_msec()
	update_weapon_switch_menu()


func hide_weapon_switch_menu():
	last_activated_menu = -999999


func update_weapon_switch_menu():
	# 第一次更新，我们需要构建完整的武器切换目录
	for weapon_slot_column in %WeaponSwitchMenu.get_children():
		while weapon_slot_column.get_child_count() < 10:
			weapon_slot_column.add_child(weapon_select_layout.instantiate())
	
	# 重置目录到默认状态（没有武器被装备）
	var slot_num = 1
	var hovered_weapon_slot = hovered_weapon.slot if hovered_weapon else -1
	for weapon_slot_column in %WeaponSwitchMenu.get_children():
		for i in range(MAX_WEAPONS_PER_SLOT):
			var weapons_in_slot = get_weapons_in_slot(slot_num)
			var weapon_gui = weapon_slot_column.get_child(i)
			weapon_gui.visible = (i == 0) or (slot_num == hovered_weapon_slot and i < len(weapons_in_slot))
			weapon_gui.slot_num = slot_num
			weapon_gui.show_slot_num = i == 0 and len(weapons_in_slot) > 0
			weapon_gui.is_expanded = false
			weapon_gui.show_weapon_icon = false
			if weapon_gui.visible and hovered_weapon_slot == slot_num:
				weapon_gui.is_expanded = true
				weapon_gui.weapon_name = weapons_in_slot[i].name
				weapon_gui.show_weapon_icon = weapons_in_slot.find(hovered_weapon) == i
				weapon_gui.weapon_icon = hovered_weapon.icon
			weapon_gui.update_visibility()
		slot_num += 1


func _unhandled_input(event: InputEvent) -> void:
	var num_key_pressed : int = -1
	if event is InputEventKey and not event.is_echo() and event.is_pressed():
		num_key_pressed = event.keycode - KEY_0 # Keys 是一个枚举 0 - 9
	
	if get_weapons_in_slot(num_key_pressed).size() > 0:
		var weapons_in_slot = get_weapons_in_slot(num_key_pressed)
		if get_weapon_menu_visibility() == 0.0:
			last_activated_menu = Time.get_ticks_msec()
			hovered_weapon = weapons_in_slot[0]
			show_weapon_switch_menu()
		else:
			last_activated_menu = Time.get_ticks_msec()
			# 循环到下一个武器
			if not hovered_weapon:
				hovered_weapon = weapons_in_slot[0]
			else:
				var weapon_index_in_slot = weapons_in_slot.find(hovered_weapon)
				var new_index = (weapon_index_in_slot + 1) % len(weapons_in_slot)
				hovered_weapon = weapons_in_slot[new_index]
			update_weapon_switch_menu()
	
	# 判断是仅仅滚动滚轮，没有按 Ctrl 时才切换武器（否则是在调整 noclip 速度，或者调整相机距离）
	if event is InputEventMouseButton and event.is_pressed() and not event.ctrl_pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			cycle_through_weapons(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			cycle_through_weapons(1)
	
	if Input.is_action_pressed("attack"):
		if get_weapon_menu_visibility() != 0.0:
			if hovered_weapon != null:
				weapon_manager.current_weapon = hovered_weapon
			hide_weapon_switch_menu()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_weapon_switch_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 更新武器切换目录可见性
	%WeaponSwitchMenu.modulate = Color(1, 1, 1, get_weapon_menu_visibility())
	weapon_manager.allow_shoot = get_weapon_menu_visibility() != 1.0
	# 更新准星上的健康和弹药条
	%HealthBar.material.set_shader_parameter("filled_percent", player.health / player.max_health)
	var ammo_pct = 1.0
	if weapon_manager.current_weapon and weapon_manager.current_weapon.magazine_capacity > 0:
		ammo_pct = weapon_manager.current_weapon.current_ammo / weapon_manager.current_weapon.magazine_capacity
	%AmmoBar.material.set_shader_parameter("filled_percent", ammo_pct)
	
	# 更新健康栏显示
	%HealthLabel.text = str(player.health)
	# 更新弹药栏显示
	if not weapon_manager.current_weapon or weapon_manager.current_weapon.current_ammo == INF:
		%AmmoBox.visible = false
	else:
		%AmmoBox.visible = true
		%ClipAmmoLabel.text = str(weapon_manager.current_weapon.current_ammo)
		
		if weapon_manager.current_weapon.reserve_ammo == INF:
			%ReserveAmmoLabel.text = "∞"
		else:
			%ReserveAmmoLabel.text = str(weapon_manager.current_weapon.reserve_ammo)
		
		%ReserveAmmoLabel.visible = weapon_manager.current_weapon.max_reserve_ammo > 0
