class_name CityDetailPanel
extends PanelContainer


signal close_button_pressed


func _on_close_button_pressed() -> void:
	close_button_pressed.emit()
