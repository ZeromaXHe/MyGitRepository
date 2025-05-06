@tool
extends Node3D

func _init() -> void:
	print("planet_gds _init")


func _enter_tree() -> void:
	print("planet_gds _enter_tree")


func _ready() -> void:
	print("planet_gds _ready")


func _exit_tree() -> void:
	print("planet_gds _exit_tree")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			print("planet_gds _notification pre-delete")
