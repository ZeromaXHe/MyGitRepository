class_name HotSeatChangingScene
extends Control


@onready var player_label: Label = $CenterContainer/PanelContainer/VBoxContainer/PlayerLabel


func _ready() -> void:
	player_label.text = GlobalScript.get_current_player().p_name


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/hot_seat_game.tscn")
