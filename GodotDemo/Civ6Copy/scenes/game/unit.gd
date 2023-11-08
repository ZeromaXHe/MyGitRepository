class_name Unit
extends Node2D


signal unit_clicked(unit: Unit)
signal unit_move_capability_depleted(unit: Unit)
signal move_capability_changed(move_capability: int)

enum Category {
	GROUND_FORCE, # 地面部队
	SEA_FORCE, # 海上部队
	AIR_FORCE, # 空中部队
	ASSISTANT_FORCE, # 支援部队
	CITIZEN, # 平民
	TRADER, # 商人
	RELIGIOUS, # 宗教单位
}

enum Type {
	SETTLER, # 开拓者
	BUILDER, # 建造者
	SCOUT, # 侦察兵
	WARRIOR, # 勇士
}

const TYPE_TO_CATEGORY_DICT: Dictionary = {
	Type.SETTLER: Category.CITIZEN,
	Type.BUILDER: Category.CITIZEN,
	Type.SCOUT: Category.GROUND_FORCE,
	Type.WARRIOR: Category.GROUND_FORCE,
}

var category: Category
var type: Type
var player: Player
var coord: Vector2i
var move_capability: int:
	set(move):
		move_capability = move
		move_capability_changed.emit(move)
		if move == 0:
			unit_move_capability_depleted.emit(self)

@onready var background: Sprite2D = $BackgroundSprite2D
@onready var icon: Sprite2D = $IconSprite2D


func initiate(type: Type, player: Player, coord: Vector2i, map_shower: MapShower) -> void:
	self.type = type
	self.category = TYPE_TO_CATEGORY_DICT[type]
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
		Type.SETTLER:
			icon.scale = Vector2(0.2, 0.2)
		_:
			icon.scale = Vector2(0.8, 0.8)
	
	match self.category:
		Category.CITIZEN:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_citizen_background.svg")
		Category.RELIGIOUS:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_religious_background.svg")
		Category.TRADER:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_trader_background.svg")
		Category.GROUND_FORCE:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_ground_military_background.svg")
		Category.AIR_FORCE:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_ground_military_background.svg")
		Category.SEA_FORCE:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_sea_military_background.svg")
		Category.ASSISTANT_FORCE:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_assistant_background.svg")
	
	background.modulate = player.main_color
	icon.modulate = player.second_color


static func get_unit_pic_webp_256x256(type: Type) -> Texture2D:
	match type:
		Type.SETTLER:
			return load("res://assets/civ6_origin/unit/webp_256x256/icon_unit_settler.webp")
		Type.BUILDER:
			return load("res://assets/civ6_origin/unit/webp_256x256/icon_unit_builder.webp")
		Type.SCOUT:
			return load("res://assets/civ6_origin/unit/webp_256x256/icon_unit_scout.webp")
		Type.WARRIOR:
			return load("res://assets/civ6_origin/unit/webp_256x256/icon_unit_warrior.webp")
		_:
			printerr("get_unit_pic_webp_256x256 | no pic for type: ", type)
			return null


static func get_unit_pic_webp_64x64(type: Type) -> Texture2D:
	match type:
		Type.SETTLER:
			# 开拓者目前没有 64x64 的图
			return load("res://assets/civ6_origin/unit/webp_256x256/icon_unit_settler.webp")
		Type.BUILDER:
			return load("res://assets/civ6_origin/unit/webp_64x64/icon_unit_builder.webp")
		Type.SCOUT:
			return load("res://assets/civ6_origin/unit/webp_64x64/icon_unit_scout.webp")
		Type.WARRIOR:
			return load("res://assets/civ6_origin/unit/webp_64x64/icon_unit_warrior.webp")
		_:
			printerr("get_unit_pic_webp_64x64 | no pic for type: ", type)
			return null


static func get_unit_name(type: Type) -> String:
	match type:
		Type.SETTLER:
			return "开拓者"
		Type.BUILDER:
			return "建造者"
		Type.SCOUT:
			return "侦察兵"
		Type.WARRIOR:
			return "勇士"
		_:
			printerr("get_unit_name | no name for type: ", type)
			return ""


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
	cells.append_array(dict.keys())
	map_shower.paint_move_tile_areas(cells)


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
