class_name Unit
extends Node2D


signal unit_clicked(unit: Unit)
signal unit_move_depleted(unit_id: int)
signal unit_move_changed(unit_id: int, move: int)


const UNIT_SCENE: PackedScene = preload("res://scenes/game/unit.tscn")

static var id_dict: Dictionary = {}

var id: int:
	set(id_new):
		if id > 0:
			id_dict.erase(id)
		id = id_new
		if id_new > 0:
			id_dict[id] = self

@onready var background: Sprite2D = $BackgroundSprite2D
@onready var icon: Sprite2D = $IconSprite2D


static func create_unit(req_dto: CreateUnitReqDTO) -> Unit:
	var unit_do: UnitDO = UnitService.create_unit(req_dto)
	var unit: Unit = UNIT_SCENE.instantiate()
	unit.id = unit_do.id
	return unit


func initiate() -> void:
	var unit_do: UnitDO = UnitService.get_unit_do(id)
	global_position = MapShower.singleton.map_coord_to_global_position(unit_do.coord)
	# 绘制图标图像
	initiate_icon(unit_do)
	# 更新玩家视野
	update_sight()


func initiate_icon(unit_do: UnitDO) -> void:
	icon.texture = UnitService.get_unit_pic_webp_64x64(unit_do.type)
	match unit_do.type:
		UnitTypeTable.Enum.SETTLER:
			icon.scale = Vector2(0.2, 0.2)
		_:
			icon.scale = Vector2(0.8, 0.8)
	# 绘制单位种类背景图标
	var unit_type_do: UnitTypeDO = UnitTypeService.get_unit_type_do_by_enum(unit_do.type)
	var icon_path: String = UnitCategoryService.get_unit_category_do_by_enum(unit_type_do.category).icon
	background.texture = load(icon_path)
	# 给单位绘制所属玩家颜色
	var player_do: PlayerDO = PlayerService.get_player_do(unit_do.player_id)
	background.modulate = player_do.main_color
	icon.modulate = player_do.second_color


func delete() -> void:
	# 清理单位视野
	update_out_sight()
	UnitService.delete_unit(id)
	queue_free()


func update_sight() -> void:
	var unit_do: UnitDO = UnitService.get_unit_do(id)
	var player_do: PlayerDO = PlayerService.get_player_do(unit_do.player_id)
	var dict: Dictionary = MapService.sight_astar.get_in_range_coords_to_cost_dict(unit_do.coord, UnitService.get_sight_range())
	for in_sight_coord in dict.keys():
		UnitSightService.in_sight(id, in_sight_coord)
	var cells: Array[Vector2i] = []
	cells.append_array(dict.keys())
	MapShower.singleton.paint_in_sight_tile_areas(cells)
	MapShower.singleton_minimap.paint_in_sight_tile_areas(cells)


func update_out_sight() -> void:
	var unit_do: UnitDO = UnitService.get_unit_do(id)
	var player_do: PlayerDO = PlayerService.get_player_do(unit_do.player_id)
	var dict: Dictionary = MapService.move_astar.get_in_range_coords_to_cost_dict(unit_do.coord, UnitService.get_sight_range())
	var cells: Array[Vector2i] = []
	for out_sight_coord in dict.keys():
		UnitSightService.out_sight(id, out_sight_coord)
		var seens: Array = PlayerSightService.get_player_sight_dos_by_sight(PlayerSightTable.Sight.SEEN)
		if seens.any(func(s): s.coord == out_sight_coord):
			MapShower.singleton.paint_out_sight_tile_areas(out_sight_coord, PlayerSightTable.Sight.SEEN)
			MapShower.singleton_minimap.paint_out_sight_tile_areas(out_sight_coord, PlayerSightTable.Sight.SEEN)


func show_move_range() -> void:
	var move_capability: int = UnitService.get_unit_do(id).move
	if move_capability == 0:
		return
	var unit_do: UnitDO = UnitService.get_unit_do(id)
	var dict: Dictionary = MapService.move_astar.get_in_range_coords_to_cost_dict(unit_do.coord, move_capability)
	var cells: Array[Vector2i] = []
	# FIXME: 暂时让所有单位都在地块上互斥
	cells.append_array(dict.keys().filter(func(coord): return is_no_unit_on_tile(coord)))
	MapShower.singleton.paint_move_tile_areas(cells)


func is_no_unit_on_tile(coord: Vector2i) -> bool:
	return UnitService.get_unit_dos_on_coord(coord).is_empty()


func move_to(coord: Vector2i) -> void:
	var unit_do: UnitDO = UnitService.get_unit_do(id)
	var move_cost_sum: float = MapService.move_astar.coord_path_cost_sum(MapService.move_astar.get_point_path_by_coord(unit_do.coord, coord))
	cost_unit_move(move_cost_sum)
	update_out_sight()
	UnitService.move_unit(id, coord)
	self.global_position = MapShower.singleton.map_coord_to_global_position(coord)
	update_sight()


func cost_unit_move(cost: int) -> void:
	var new_move: int = UnitService.cost_unit_move(id, cost)
	unit_move_changed.emit(id, new_move)
	if new_move == 0:
		unit_move_depleted.emit(id)


func _on_unit_button_pressed() -> void:
	print("_on_unit_button_pressed | unit clicked")
	unit_clicked.emit(self)
