class_name MouseHoverTilePanel
extends PanelContainer


@onready var label: Label = $MarginContainer/Label

func show_info(map_coord: Vector2i, tile_info: Map.TileInfo) -> void:
	label.text = Map.TERRAIN_TYPE_TO_NAME_DICT[tile_info.type]
	if tile_info.landscape != Map.LandscapeType.EMPTY:
		label.text += "\n" + Map.LANDSCAPE_TYPE_TO_NAME_DICT[tile_info.landscape]
	if tile_info.village == 1:
		label.text += "\n部落村庄"
	if tile_info.resource != Map.ResourceType.EMPTY:
		label.text += "\n" + Map.RESOURCE_TYPE_TO_NAME_DICT[tile_info.resource]
	if tile_info.type != Map.TerrainType.SHORE and tile_info.type != Map.TerrainType.OCEAN:
		label.text += "\n大陆：" + Map.CONTINENT_TYPE_TO_NAME_DICT[tile_info.continent]
	label.text += "\n---------------"
	label.text += "\nHex " + str(map_coord)
	
	var mouse_posi: Vector2 = get_viewport().get_mouse_position()
	self.offset_left = mouse_posi.x
	self.offset_top = mouse_posi.y
	self.show()


func hide_info() -> void:
	self.hide()
