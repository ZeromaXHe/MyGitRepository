class_name MainMenu
extends Control


# 当前选择的按钮
var current_button: Button = null
var main_button_to_vbox_dict: Dictionary = {}

# VBox 选项
@onready var single_player_vbox: VBoxContainer = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/SinglePlayerVBox
@onready var multiplayer_vbox: VBoxContainer = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MultiplayerVBox
@onready var additional_vbox: VBoxContainer = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/AdditionalVBox
@onready var benchmark_vbox: VBoxContainer = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/BenchmarkVBox
@onready var map_editor_vbox: VBoxContainer = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MapEditorVBox
# 主菜单按钮
@onready var single_player_button: Button = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MainVBox/SinglePlayerButton
@onready var multiplayer_button: Button = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MainVBox/MultiplayerButton
@onready var option_button: Button = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MainVBox/OptionButton
@onready var additional_button: Button = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MainVBox/AdditionalButton
@onready var tutorial_button: Button = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MainVBox/TutorialButton
@onready var benchmark_button: Button = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MainVBox/BenchmarkButton
@onready var map_editor_button: Button = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MainVBox/MapEditorButton
@onready var exit_button: Button = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/MainVBox/ExitButton


func _ready() -> void:
	single_player_vbox.visible = false
	multiplayer_vbox.visible = false
	additional_vbox.visible = false
	benchmark_vbox.visible = false
	map_editor_vbox.visible = false
	init_main_button_to_vbox_dict()


## 初始化按钮到 VBox 的字典映射
func init_main_button_to_vbox_dict():
	main_button_to_vbox_dict[single_player_button] = single_player_vbox
	main_button_to_vbox_dict[multiplayer_button] = multiplayer_vbox
	main_button_to_vbox_dict[additional_button] = additional_vbox
	main_button_to_vbox_dict[benchmark_button] = benchmark_vbox
	main_button_to_vbox_dict[map_editor_button] = map_editor_vbox


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func main_button_pressed(button: Button):
	change_main_button_and_vbox_state(button)
	if current_button != button:
		# 用来还原之前点击过的其他按钮、VBox 界面
		change_main_button_and_vbox_state(current_button)
		current_button = button
	else:
		# 第二次点击按钮后，取消选择
		current_button = null


func change_main_button_and_vbox_state(button: Button):
	if button == null or not main_button_to_vbox_dict.has(button):
		return
	var vbox: VBoxContainer = main_button_to_vbox_dict[button]
	vbox.visible = not vbox.visible
	reverse_main_button_alignment(button)


func reverse_main_button_alignment(button: Button):
	if button.alignment == HORIZONTAL_ALIGNMENT_LEFT:
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT


func _on_single_player_button_pressed() -> void:
	main_button_pressed(single_player_button)


func _on_multiplayer_button_pressed() -> void:
	main_button_pressed(multiplayer_button)


## 按下“热座模式”按钮
func _on_hot_seat_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/multiplayer_setting_menu.tscn")


# 无 VBox
func _on_option_button_pressed() -> void:
	main_button_pressed(option_button)


func _on_additional_button_pressed() -> void:
	main_button_pressed(additional_button)


# 无 VBox
func _on_tutorial_button_pressed() -> void:
	main_button_pressed(tutorial_button)


func _on_benchmark_button_pressed() -> void:
	main_button_pressed(benchmark_button)


func _on_map_editor_button_pressed() -> void:
	main_button_pressed(map_editor_button)


## 点击地图编辑器的“新地图”按钮
func _on_new_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/create_map_menu.tscn")


## 点击地图编辑器的“加载地图”按钮
func _on_load_button_pressed() -> void:
	GlobalScript.load_map = true
	get_tree().change_scene_to_file("res://scenes/gui/map_editor_gui.tscn")
