class_name GameController
extends Node

@export var world_3d: Node3D
@export var world_2d: Node2D
@export var gui: Control
@export var transition_controller: SceneTransitionController

var current_3d_scene
var current_2d_scene
var current_gui_scene


func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false,
		transition: bool = true, transition_in: String = "FadeIn",
		transition_out: String = "FadeOut", seconds: float = 1.0) -> void:
	if transition:
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new
	transition_controller.transition(transition_in, seconds)


func change_3d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_3d_scene != null:
		if delete:
			current_3d_scene.queue_free()
		elif keep_running:
			current_3d_scene.visible = false
		else:
			world_3d.remove_child(current_3d_scene)
	var new = load(new_scene).instantiate()
	world_3d.add_child(new)
	current_3d_scene = new


func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
	var new = load(new_scene).instantiate()
	world_2d.add_child(new)
	current_2d_scene = new


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_controller = self
	current_gui_scene = $GUI/SplashScreenManager
