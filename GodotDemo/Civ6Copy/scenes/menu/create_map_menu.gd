class_name CreateMapMenu
extends Control


@onready var main_vbox: VBoxContainer = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/MainVBoxContainer
@onready var advanced_option_vbox: VBoxContainer = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/AdvancedOptionVBoxContainer
@onready var advanced_option_button: Button = $MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/AdvancedOptionsButton


func _ready() -> void:
	main_vbox.visible = true
	advanced_option_button.visible = true
	advanced_option_vbox.visible = false


## 按下返回按钮
func _on_back_button_pressed() -> void:
	if main_vbox.visible:
		# 在主界面
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
	else:
		# 在高级选项界面
		main_vbox.visible = true
		advanced_option_button.visible = true
		advanced_option_vbox.visible = false


## 按下高级选项按钮
func _on_advanced_options_button_pressed() -> void:
	main_vbox.visible = false
	advanced_option_button.visible = false
	advanced_option_vbox.visible = true


func _on_create_button_pressed() -> void:
	GlobalScript.load_map = false
	# 加载页面配置
	GlobalScript.load_scene_path = "res://scenes/map_editor/map_editor.tscn"
	GlobalScript.jump_to_other_scene = false
	get_tree().change_scene_to_file("res://scenes/menu/loading_screen.tscn")
