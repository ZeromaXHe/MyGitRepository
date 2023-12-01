class_name MouseHoverTilePanel
extends PanelContainer


@onready var label: RichTextLabel = $MarginContainer/Label


func _process(delta: float) -> void:
	if self.visible:
		var mouse_posi: Vector2 = get_viewport().get_mouse_position()
		# TODO: 目前如果只在右下角显示的话，当鼠标在窗口右下角可能看不到提示。
		# 未来可以加个根据坐标相对窗口的位置决定悬浮面板位置的逻辑
		self.offset_left = mouse_posi.x + 10
		self.offset_top = mouse_posi.y + 10


func show_info(map_coord: Vector2i) -> void:
	var tile_info: TileInfoDTO = MapTileService.get_tile_info(map_coord)
	label.text = tile_info.terrain_name
	if tile_info.landscape_name != "":
		label.text += "\n" + tile_info.landscape_name
	if tile_info.village:
		label.text += "\n部落村庄"
	if tile_info.resource_name != "":
		label.text += "\n" + tile_info.resource_name
	if tile_info.land:
		if tile_info.river:
			label.text += "\n河流"
		if tile_info.cliff:
			label.text += "\n悬崖"
	label.text += "\n移动力消耗：%d" % tile_info.move_cost
	if tile_info.land:
		if tile_info.defence_bonus > 0:
			label.text += "\n防御值变更：%d" % tile_info.defence_bonus
		label.text += "\n魅力：%s（%d）" % [tile_info.charm_desc, tile_info.charm]
		if tile_info.continent_name != null:
			label.text += "\n大陆：" + tile_info.continent_name
	label.text += "\n---------------"
	var yield_dto: YieldDTO = MapTileService.get_tile_yield(map_coord)
	if yield_dto.culture > 0:
		label.text += "\n" + str(yield_dto.culture) + " [img=20]res://assets/civ6_origin/core/webp_32x32/core_culture.webp[/img]文化"
	if yield_dto.food > 0:
		label.text += "\n" + str(yield_dto.food) + " [img=20]res://assets/civ6_origin/core/webp_32x32/core_food.webp[/img]食物"
	if yield_dto.production > 0:
		label.text += "\n" + str(yield_dto.production) + " [img=20]res://assets/civ6_origin/core/webp_32x32/core_production.webp[/img]生产力"
	if yield_dto.science > 0:
		label.text += "\n" + str(yield_dto.science) + " [img=20]res://assets/civ6_origin/core/webp_32x32/core_science.webp[/img]科技"
	if yield_dto.faith > 0:
		label.text += "\n" + str(yield_dto.faith) + " [img=20]res://assets/civ6_origin/core/webp_32x32/core_faith.webp[/img]信仰"
	if yield_dto.gold > 0:
		label.text += "\n" + str(yield_dto.gold) + " [img=20]res://assets/civ6_origin/core/webp_32x32/core_gold.webp[/img]金币"
	if GameController.get_mode() == GameController.Mode.MAP_EDITOR:
		label.text += "\nHex " + str(map_coord)
	
	var mouse_posi: Vector2 = get_viewport().get_mouse_position()
	self.offset_left = mouse_posi.x
	self.offset_top = mouse_posi.y
	self.show()


func hide_info() -> void:
	self.hide()
