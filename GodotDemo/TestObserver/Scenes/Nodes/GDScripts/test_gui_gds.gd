@tool
extends Control

func _init() -> void:
	print("test_gui_gds _init")


func _enter_tree() -> void:
	print("test_gui_gds _enter_tree")


func _ready() -> void:
	print("test_gui_gds _ready")


func _exit_tree() -> void:
	print("test_gui_gds _exit_tree")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			print("test_gui_gds _notification pre-delete")
