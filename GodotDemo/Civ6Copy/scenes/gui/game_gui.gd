class_name GameGUI
extends CanvasLayer


# 百科面板
@onready var wiki_panel: WikiPanel = $WikiPanelContainer
# 鼠标悬停在地块上时显示的面板
@onready var mouse_hover_tile_panel: MouseHoverTilePanel = $MouseHoverTilePanel

func _ready() -> void:
	wiki_panel.visible = false
	# 鼠标悬停面板初始不显示
	hide_mouse_hover_tile_info()


func is_mouse_hover_info_shown() -> bool:
	return mouse_hover_tile_panel.visible


func show_mouse_hover_tile_info(map_coord: Vector2i, tile_info: Map.TileInfo) -> void:
	mouse_hover_tile_panel.show_info(map_coord, tile_info)


func hide_mouse_hover_tile_info() -> void:
	mouse_hover_tile_panel.hide_info()


func _on_civ_pedia_button_pressed() -> void:
	wiki_panel.visible = true
