extends Button
class_name BallButton


signal ball_button_pressed(ball: BallButton)

var x = -1
var y = -1


func _on_pressed() -> void:
	ball_button_pressed.emit(self)
