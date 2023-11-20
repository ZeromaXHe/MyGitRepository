class_name Unit
extends Node2D


signal unit_clicked(unit: Unit)


var id: int

@onready var background: Sprite2D = $BackgroundSprite2D
@onready var icon: Sprite2D = $IconSprite2D


func initiate() -> void:
	var unit_do: UnitDO = UnitController.get_unit_do(id)
	global_position = ViewHolder.get_map_shower().map_coord_to_global_position(unit_do.coord)
	# 绘制图标图像
	initiate_icon(unit_do)
	# 更新玩家视野
	update_sight()


func initiate_icon(unit_do: UnitDO) -> void:
	icon.texture = UnitController.get_unit_pic_webp_64x64(unit_do.type)
	match unit_do.type:
		UnitTypeTable.Enum.SETTLER:
			icon.scale = Vector2(0.2, 0.2)
		_:
			icon.scale = Vector2(0.8, 0.8)
	# 绘制单位种类背景图标
	var unit_type_do: UnitTypeDO = UnitTypeController.get_unit_type_do_by_enum(unit_do.type)
	var icon_path: String = UnitCategoryController.get_unit_category_do_by_enum(unit_type_do.category).icon
	background.texture = load(icon_path)
	# 给单位绘制所属玩家颜色
	var player_do: PlayerDO = PlayerController.get_player_do(unit_do.player_id)
	background.modulate = player_do.main_color
	icon.modulate = player_do.second_color


func delete() -> void:
	# 清理单位视野
	update_out_sight()
	UnitController.delete_unit(id)
	queue_free()


func update_sight() -> void:
	var unit_do: UnitDO = UnitController.get_unit_do(id)
	var player_do: PlayerDO = PlayerController.get_player_do(unit_do.player_id)
	var dict: Dictionary = MapController.get_in_sight_range_dict(unit_do.coord, UnitController.get_sight_range())
	for in_sight_coord in dict.keys():
		PlayerSightController.in_sight(in_sight_coord)
	var cells: Array[Vector2i] = []
	cells.append_array(dict.keys())
	ViewHolder.get_map_shower().paint_in_sight_tile_areas(cells)


func update_out_sight() -> void:
	var unit_do: UnitDO = UnitController.get_unit_do(id)
	var player_do: PlayerDO = PlayerController.get_player_do(unit_do.player_id)
	var dict: Dictionary = MapController.get_in_move_range_dict(unit_do.coord, UnitController.get_sight_range())
	var cells: Array[Vector2i] = []
	for out_sight_coord in dict.keys():
		PlayerSightController.out_sight(out_sight_coord)
		var seens: Array = PlayerSightController.get_player_sight_dos_by_sight(PlayerSightTable.Sight.SEEN)
		if seens.any(func(s): s.coord == out_sight_coord):
			ViewHolder.get_map_shower().paint_out_sight_tile_areas(out_sight_coord, PlayerSightTable.Sight.SEEN)


func show_move_range() -> void:
	var move_capability: int = UnitController.get_unit_do(id).move
	if move_capability == 0:
		return
	var unit_do: UnitDO = UnitController.get_unit_do(id)
	var dict: Dictionary = MapController.get_in_move_range_dict(unit_do.coord, move_capability)
	var cells: Array[Vector2i] = []
	# FIXME: 暂时让所有单位都在地块上互斥
	cells.append_array(dict.keys().filter(func(coord): return is_no_unit_on_tile(coord)))
	ViewHolder.get_map_shower().paint_move_tile_areas(cells)


func is_no_unit_on_tile(coord: Vector2i) -> bool:
	return UnitController.get_unit_dos_on_coord(coord).is_empty()


func move_to(coord: Vector2i) -> void:
	var unit_do: UnitDO = UnitController.get_unit_do(id)
	UnitController.cost_unit_move(unit_do.id, MapController.get_move_cost_sum(unit_do.coord, coord))
	update_out_sight()
	UnitController.move_unit(id, coord)
	self.global_position = ViewHolder.get_map_shower().map_coord_to_global_position(coord)
	update_sight()


func _on_unit_button_pressed() -> void:
	print("_on_unit_button_pressed | unit clicked")
	unit_clicked.emit(self)
