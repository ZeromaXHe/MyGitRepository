@tool
extends Node


func _init() -> void:
	print("global_node_gds _init")


func _enter_tree() -> void:
	print("global_node_gds _enter_tree")


func _ready() -> void:
	print("global_node_gds _ready")


func _exit_tree() -> void:
	print("global_node_gds _exit_tree")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			print("global_node_gds _notification pre-delete")
