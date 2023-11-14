class_name Unit
extends Node2D


signal unit_clicked(unit: Unit)
signal unit_move_capability_depleted(unit: Unit)
signal move_capability_changed(move_capability: int)


var category: UnitCategoryTable.Category
var type: UnitTypeTable.Type
var player: Player
var coord: Vector2i
var move_capability: int:
	set(move):
		move_capability = move
		move_capability_changed.emit(move)
		if move == 0:
			unit_move_capability_depleted.emit(self)
var skip_flag: bool = false
var sleep_flag: bool = false

@onready var background: Sprite2D = $BackgroundSprite2D
@onready var icon: Sprite2D = $IconSprite2D


func initiate(type: UnitTypeTable.Type, player: Player, coord: Vector2i, map_shower: MapShower) -> void:
	self.type = type
	self.category = DatabaseUtils.query_unit_type_by_enum_val(type).category
	self.player = player
	self.coord = coord
	self.global_position = map_shower.map_coord_to_global_position(coord)
	self.move_capability = get_move_range()
	# 将单位记入地图信息
	map_shower._map.get_map_tile_info_at(coord).units.append(self)
	# 将单位记录在玩家中
	GlobalScript.get_current_player().units.append(self)
	# 绘制图标图像
	initiate_icon()
	# 更新玩家视野
	update_sight(map_shower)


func initiate_icon() -> void:
	icon.texture = get_unit_pic_webp_64x64(type)
	match type:
		UnitTypeTable.Type.SETTLER:
			icon.scale = Vector2(0.2, 0.2)
		_:
			icon.scale = Vector2(0.8, 0.8)
	
	var icon_path = DatabaseUtils.query_unit_category_by_enum_val(category).icon
	background.texture = load(icon_path)
	background.modulate = player.main_color
	icon.modulate = player.second_color


static func get_unit_pic_webp_256x256(type: UnitTypeTable.Type) -> Texture2D:
	var unit_type_do: UnitTypeDO = DatabaseUtils.query_unit_type_by_enum_val(type)
	if unit_type_do == null:
		printerr("get_unit_pic_webp_256x256 | no pic for type: ", type)
		return null
	return load(unit_type_do.icon_256)


static func get_unit_pic_webp_64x64(type: UnitTypeTable.Type) -> Texture2D:
	var unit_type_do: UnitTypeDO = DatabaseUtils.query_unit_type_by_enum_val(type)
	if unit_type_do == null:
		printerr("get_unit_pic_webp_64x64 | no pic for type: ", type)
		return null
	if type == UnitTypeTable.Type.SETTLER:
		# 开拓者目前没有 64x64 的图
		return load(unit_type_do.icon_256)
	return load(unit_type_do.icon_64)


static func get_unit_name(type: UnitTypeTable.Type) -> String:
	var unit_type_do: UnitTypeDO = DatabaseUtils.query_unit_type_by_enum_val(type)
	if unit_type_do == null:
		printerr("get_unit_name | no name for type: ", type)
		return ""
	return unit_type_do.view_name


static func get_unit_pic_200(type: UnitTypeTable.Type) -> String:
	var unit_type_do: UnitTypeDO = DatabaseUtils.query_unit_type_by_enum_val(type)
	if unit_type_do == null:
		printerr("get_unit_pic_200 | no pic_200 for type: ", type)
		return ""
	return unit_type_do.pic_200


func delete(map_shower: MapShower) -> void:
	# 将单位从地图信息中删除
	map_shower._map.get_map_tile_info_at(coord).units.erase(self)
	# 将单位从玩家拥有的单位列表中删除
	GlobalScript.get_current_player().units.erase(self)
	# 清理单位视野
	update_out_sight(map_shower)
	queue_free()


func update_sight(map_shower: MapShower) -> void:
	var dict: Dictionary = map_shower._map.sight_astar.get_in_range_coords_to_cost_dict(coord, get_sight_range())
	for in_sight_coord in dict.keys():
		player.map_sight_info.in_sight(in_sight_coord)
	var cells: Array[Vector2i] = []
	cells.append_array(dict.keys())
	map_shower.paint_in_sight_tile_areas(cells)


func update_out_sight(map_shower: MapShower) -> void:
	var dict: Dictionary = map_shower._map.sight_astar.get_in_range_coords_to_cost_dict(coord, get_sight_range())
	var cells: Array[Vector2i] = []
	for out_sight_coord in dict.keys():
		player.map_sight_info.out_sight(out_sight_coord)
		if player.map_sight_info.seen_dict.has(out_sight_coord):
			map_shower.paint_out_sight_tile_areas(out_sight_coord, Map.SightType.SEEN)


func show_move_range(map_shower: MapShower) -> void:
	if move_capability == 0:
		return
	var dict: Dictionary = map_shower._map.move_astar.get_in_range_coords_to_cost_dict(coord, move_capability)
	var cells: Array[Vector2i] = []
	# FIXME: 暂时让所有单位都在地块上互斥
	cells.append_array(dict.keys().filter(func(coord): return is_no_unit_on_tile(coord, map_shower)))
	map_shower.paint_move_tile_areas(cells)


func is_no_unit_on_tile(coord: Vector2i, map_shower: MapShower) -> bool:
	return map_shower._map.get_map_tile_info_at(coord).units.is_empty()


func move_to(coord: Vector2i, map_shower: MapShower) -> void:
	self.move_capability = max(0, self.move_capability \
			- map_shower._map.move_astar.coord_path_cost_sum(map_shower._map.move_astar.get_point_path_by_coord(self.coord, coord)))
	update_out_sight(map_shower)
	# 将单位移出地图原坐标
	map_shower._map.get_map_tile_info_at(self.coord).units.erase(self)
	self.coord = coord
	self.global_position = map_shower.map_coord_to_global_position(coord)
	update_sight(map_shower)
	# 将单位移入地图新坐标
	map_shower._map.get_map_tile_info_at(self.coord).units.append(self)


func get_sight_range() -> int:
	# TODO: 先通通返回 2 格视野
	return 2


func get_move_range() -> int:
	# TODO: 先通通返回 2 格移动力
	return 2


## 鼠标点击 ClickArea2D 的信号处理
func _on_click_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			print("_on_click_area_2d_input_event | clicked on unit")
			# TODO: 可能的 bug - 如果在别处点击，这里释放的话，吞掉输入事件可能有 bug
			get_viewport().set_input_as_handled()
			unit_clicked.emit(self)
