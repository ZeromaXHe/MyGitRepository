extends CanvasLayer


func _ready() -> void:
	# 显示鼠标
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_option_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screen/option_menu_screen.tscn")
