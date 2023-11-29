class_name CitizenNode2D
extends Node2D


var coord: Vector2i
var city_id: int


func _on_button_pressed() -> void:
	print("citizen button pressed, coord: ", coord, ", city_id: ", city_id)
