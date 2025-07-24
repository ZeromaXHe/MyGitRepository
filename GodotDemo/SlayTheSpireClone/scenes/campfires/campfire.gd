extends Control


func _on_button_pressed() -> void:
	Events.campfire_exited.emit()
