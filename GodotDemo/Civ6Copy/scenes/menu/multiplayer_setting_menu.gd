class_name MultiplayerSettingMenu
extends Control


## 按下返回按钮
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
