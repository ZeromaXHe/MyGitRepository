extends Control


func _on_button_pressed() -> void:
	Events.battle_reward_exited.emit()
