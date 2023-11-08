class_name GameCityProductPanel
extends PanelContainer


signal close_button_pressed
signal settler_button_pressed


func _on_settler_button_pressed() -> void:
	settler_button_pressed.emit()


func _on_close_button_pressed() -> void:
	close_button_pressed.emit()
