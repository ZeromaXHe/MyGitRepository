class_name MapController


static func init_map() -> void:
	var size = MapSizeTable.Size.DUAL
	MapService.init_map_tile_table(size)
	MapService.init_map_border_table(size)
