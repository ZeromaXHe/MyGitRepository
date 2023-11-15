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


func show_info(map_coord: Vector2i, tile_do: MapTileDO) -> void:
	label.text = DatabaseUtils.terrain_tbl.query_by_enum_val(tile_do.terrain).view_name
	if tile_do.landscape != LandscapeTable.Landscape.EMPTY:
		label.text += "\n" + DatabaseUtils.landscape_tbl.query_by_enum_val(tile_do.landscape).view_name
	if tile_do.village:
		label.text += "\n部落村庄"
	if tile_do.resource != ResourceTable.ResourceType.EMPTY:
		label.text += "\n" + DatabaseUtils.resource_tbl.query_by_enum_val(tile_do.resource).view_name
	if tile_do.continent != ContinentTable.Continent.EMPTY:
		label.text += "\n大陆：" + DatabaseUtils.continent_tbl.query_by_enum_val(tile_do.continent).view_name
	label.text += "\n---------------"
	label.text += "\nHex " + str(map_coord)
	
	var mouse_posi: Vector2 = get_viewport().get_mouse_position()
	self.offset_left = mouse_posi.x
	self.offset_top = mouse_posi.y
	self.show()


func hide_info() -> void:
	self.hide()
