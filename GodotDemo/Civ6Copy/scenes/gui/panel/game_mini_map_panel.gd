class_name GameMiniMapPanel
extends VBoxContainer


signal clicked_on_minimap_tile(coord: Vector2i)


@onready var mini_map: MiniMap = $MiniMapPanel/MarginContainer/SubViewportContainer/SubViewport/MiniMap


func get_mini_map() -> MiniMap:
	return mini_map


func _on_mini_map_click_on_tile(coord: Vector2i) -> void:
	clicked_on_minimap_tile.emit(coord)
