class_name HotSeatChangingScene
extends Control


@onready var player_label: Label = $CenterContainer/PanelContainer/VBoxContainer/PlayerLabel


func _ready() -> void:
	var player_do: PlayerDO = PlayerService.get_current_player()
	if player_do == null:
		player_label.text = "测试玩家"
	else:
		player_label.text = PlayerService.get_current_player().name


func _on_start_button_pressed() -> void:
	hide()
