class_name MultiplayerSettingMenu
extends Control


## 按下返回按钮
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_confirm_button_pressed() -> void:
	# 玩家相关配置
	var player := Player.new()
	player.p_name = "玩家 1"
	player.main_color = Color("c71415")
	player.second_color = Color("f5ce02")
	GlobalScript.add_player(player)
	# 加载页面配置
	GlobalScript.load_scene_path = "res://scenes/game/hot_seat_game.tscn"
	GlobalScript.jump_to_other_scene = true
	GlobalScript.jump_scene_path = "res://scenes/menu/hot_seat_changing_scene.tscn"
	get_tree().change_scene_to_file("res://scenes/menu/loading_screen.tscn")
