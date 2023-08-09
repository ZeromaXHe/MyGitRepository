extends CanvasLayer


func _ready() -> void:
	get_tree().paused = true


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
