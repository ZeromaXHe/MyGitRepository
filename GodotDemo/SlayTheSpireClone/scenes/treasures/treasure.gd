extends Control


func _on_button_pressed() -> void:
	Events.treasure_room_exited.emit()
