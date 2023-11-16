class_name HotSeatChangingScene
extends Control


@onready var player_label: Label = $CenterContainer/PanelContainer/VBoxContainer/PlayerLabel


func _ready() -> void:
	player_label.text = PlayerController.get_current_player().name


func _on_start_button_pressed() -> void:
	hide()
