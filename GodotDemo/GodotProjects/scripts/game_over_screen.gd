extends CanvasLayer
class_name GameOverScreen

@onready var title: Label = $PanelContainer/MarginContainer/Rows/Title


func _ready() -> void:
	get_tree().paused = true


func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.GREEN
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.RED


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu_screen.tscn")
