class_name MouseHoverTilePanel
extends PanelContainer


@onready var label: Label = $MarginContainer/Label


func _process(delta: float) -> void:
	if self.visible:
		var mouse_posi: Vector2 = get_viewport().get_mouse_position()
		# TODO: 目前如果只在右下角显示的话，当鼠标在窗口右下角可能看不到提示。
		# 未来可以加个根据坐标相对窗口的位置决定悬浮面板位置的逻辑
		self.offset_left = mouse_posi.x + 10
		self.offset_top = mouse_posi.y + 10


func show_info(map_coord: Vector2i, tile_info: Map.TileInfo) -> void:
	label.text = DatabaseUtils.query_terrain_by_enum_val(tile_info.type).view_name
	if tile_info.landscape != LandscapeTable.Landscape.EMPTY:
		label.text += "\n" + DatabaseUtils.query_landscape_by_enum_val(tile_info.landscape).view_name
	if tile_info.village == 1:
		label.text += "\n部落村庄"
	if tile_info.resource != ResourceTable.ResourceType.EMPTY:
		label.text += "\n" + DatabaseUtils.query_resource_by_enum_val(tile_info.resource).view_name
	if tile_info.type != TerrainTable.Terrain.SHORE and tile_info.type != TerrainTable.Terrain.OCEAN:
		label.text += "\n大陆：" + DatabaseUtils.query_continent_by_enum_val(tile_info.continent).view_name
	label.text += "\n---------------"
	label.text += "\nHex " + str(map_coord)
	
	var mouse_posi: Vector2 = get_viewport().get_mouse_position()
	self.offset_left = mouse_posi.x
	self.offset_top = mouse_posi.y
	self.show()


func hide_info() -> void:
	self.hide()
