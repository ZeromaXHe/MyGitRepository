extends CanvasLayer


func _ready() -> void:
	get_tree().paused = true
	# 显示鼠标
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/screen/main_menu_screen.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
