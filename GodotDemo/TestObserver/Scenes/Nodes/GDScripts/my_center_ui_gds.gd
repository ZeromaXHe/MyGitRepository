@tool
extends CenterContainer

func _init() -> void:
	print("my_center_ui_gds _init")


func _enter_tree() -> void:
	print("my_center_ui_gds _enter_tree")


func _ready() -> void:
	print("my_center_ui_gds _ready")


func _exit_tree() -> void:
	print("my_center_ui_gds _exit_tree")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			print("my_center_ui_gds _notification pre-delete")
