extends CanvasLayer


@onready var night_battle_check_box: CheckBox = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/NightBattleCheckBox
@onready var friendly_fire_damage_check_box: CheckBox = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/FriendlyFireDamageCheckBox
@onready var player_invincible_check_box: CheckBox = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/PlayerInvincibleCheckBox
@onready var ai_dont_shoot_check_box: CheckBox = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/AIDontShootCheckBox
@onready var navigation_debug_check_box: CheckBox = $PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/NavigationDebugCheckBox

func _ready() -> void:
	night_battle_check_box.button_pressed = GlobalMediator.night_battle
	friendly_fire_damage_check_box.button_pressed = GlobalMediator.friendly_fire_damage
	player_invincible_check_box.button_pressed = GlobalMediator.player_invincible
	ai_dont_shoot_check_box.button_pressed = GlobalMediator.ai_dont_shoot
	navigation_debug_check_box.button_pressed = GlobalMediator.navigation_debug


func _on_night_battle_check_box_pressed() -> void:
	GlobalMediator.night_battle = night_battle_check_box.button_pressed


func _on_friendly_fire_damage_check_box_pressed() -> void:
	GlobalMediator.friendly_fire_damage = friendly_fire_damage_check_box.button_pressed


func _on_player_invincible_check_box_pressed() -> void:
	GlobalMediator.player_invincible = player_invincible_check_box.button_pressed


func _on_ai_dont_shoot_check_box_pressed() -> void:
	GlobalMediator.ai_dont_shoot = ai_dont_shoot_check_box.button_pressed


func _on_navigation_debug_check_box_pressed() -> void:
	GlobalMediator.navigation_debug = navigation_debug_check_box.button_pressed


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu_screen.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
