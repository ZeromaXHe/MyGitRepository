class_name MultiplayerSettingMenu
extends Control


## 按下返回按钮
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_confirm_button_pressed() -> void:
	var player := Player.new()
	player.p_name = "玩家 1"
	player.main_color = Color("c71415")
	player.second_color = Color("f5ce02")
	GlobalScript.add_player(player)
	get_tree().change_scene_to_file("res://scenes/menu/hot_seat_changing_scene.tscn")
