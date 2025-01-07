class_name InteractableComponent
extends Node

signal interacted()

var characters_hovering = {}


func interact_with():
	interacted.emit()


func hover_cursor(character: CharacterBody3D):
	characters_hovering[character] = Engine.get_process_frames()


func get_character_hovered_by_cur_camera() -> CharacterBody3D:
	for character: CharacterBody3D in characters_hovering.keys():
		var cur_cam = get_viewport().get_camera_3d() if get_viewport() else null
		if cur_cam in character.find_children("*", "Camera3D"):
			return character
	return null


func _process(delta: float) -> void:
	for character: CharacterBody3D in characters_hovering.keys():
		if Engine.get_process_frames() - characters_hovering[character] > 1:
			characters_hovering.erase(character)
