extends Control

const CHAR_SELECTOR_SCENE = preload("res://scenes/uis/character_selector.tscn")

@onready var continue_button: Button = %Continue


func _ready() -> void:
	get_tree().paused = false


func _on_continue_pressed() -> void:
	print("continue run")


func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)


func _on_exit_pressed() -> void:
	get_tree().quit()
