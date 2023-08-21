extends CanvasLayer
class_name Menu


func _on_ui_impl_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui_impl/winline_ui_impl.tscn")


func _on_tile_map_impl_button_pressed() -> void:
	get_tree().change_scene_to_file("res://tile_map_impl/win_line_tile_map_impl.tscn")
