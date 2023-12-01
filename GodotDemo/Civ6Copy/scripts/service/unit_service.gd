class_name UnitService


static func create_unit(req_dto: CreateUnitReqDTO) -> UnitDO:
	var unit_do := UnitDO.new()
	unit_do.coord = req_dto.coord
	unit_do.player_id = req_dto.player_id
	unit_do.type = req_dto.type
	var unit_type_do: UnitTypeDO = DatabaseUtils.unit_type_tbl.query_by_enum_val(req_dto.type)
	unit_do.move = unit_type_do.move
	unit_do.labor = unit_type_do.labor
	DatabaseUtils.unit_tbl.insert(unit_do)
	return unit_do


static func get_unit_do(id: int) -> UnitDO:
	return DatabaseUtils.unit_tbl.query_by_id(id)


static func get_unit_dos_on_coord(coord: Vector2i) -> Array:
	return DatabaseUtils.unit_tbl.query_by_coord(coord)


static func get_unit_dos_of_player(player_id: int) -> Array:
	return DatabaseUtils.unit_tbl.query_by_player_id(player_id)


static func wake_unit(id: int) -> void:
	DatabaseUtils.unit_tbl.update_field_by_id(id, "skip", false)
	DatabaseUtils.unit_tbl.update_field_by_id(id, "sleep", false)


static func skip_unit(id: int) -> void:
	DatabaseUtils.unit_tbl.update_field_by_id(id, "skip", true)


static func sleep_unit(id: int) -> void:
	DatabaseUtils.unit_tbl.update_field_by_id(id, "sleep", true)


static func is_next_need_move(unit: UnitDO) -> bool:
	return unit.move > 0 and not unit.skip and not unit.sleep


static func refresh_unit(id: int) -> void:
	DatabaseUtils.unit_tbl.update_field_by_id(id, "move", get_move_range(id))
	DatabaseUtils.unit_tbl.update_field_by_id(id, "skip", false)


static func cost_unit_move(id: int, cost: int) -> int:
	var unit_do: UnitDO = get_unit_do(id)
	var new_move: int = max(0, unit_do.move - cost)
	DatabaseUtils.unit_tbl.update_field_by_id(id, "move", new_move)
	return new_move


static func move_unit(id: int, coord: Vector2i) -> void:
	DatabaseUtils.unit_tbl.update_field_by_id(id, "coord", coord)


static func delete_unit(id: int) -> void:
	DatabaseUtils.unit_tbl.delete_by_id(id)


static func get_sight_range() -> int:
	# TODO: 先通通返回 2 格视野
	return 2


static func get_move_range(unit_id: int) -> int:
	var unit_do: UnitDO = get_unit_do(unit_id)
	return DatabaseUtils.unit_type_tbl.query_by_enum_val(unit_do.type).move


static func get_unit_pic_webp_256x256(type: UnitTypeTable.Enum) -> Texture2D:
	var unit_type_do: UnitTypeDO = UnitTypeService.get_unit_type_do_by_enum(type)
	if unit_type_do == null:
		printerr("get_unit_pic_webp_256x256 | no pic for type: ", type)
		return null
	return load(unit_type_do.icon_256)


static func get_unit_pic_webp_64x64(type: UnitTypeTable.Enum) -> Texture2D:
	var unit_type_do: UnitTypeDO = UnitTypeService.get_unit_type_do_by_enum(type)
	if unit_type_do == null:
		printerr("get_unit_pic_webp_64x64 | no pic for type: ", type)
		return null
	if type == UnitTypeTable.Enum.SETTLER:
		# 开拓者目前没有 64x64 的图
		return load(unit_type_do.icon_256)
	return load(unit_type_do.icon_64)


static func get_unit_name(type: UnitTypeTable.Enum) -> String:
	var unit_type_do: UnitTypeDO = UnitTypeService.get_unit_type_do_by_enum(type)
	if unit_type_do == null:
		printerr("get_unit_name | no name for type: ", type)
		return ""
	return unit_type_do.view_name


static func get_unit_pic_200(type: UnitTypeTable.Enum) -> String:
	var unit_type_do: UnitTypeDO = UnitTypeService.get_unit_type_do_by_enum(type)
	if unit_type_do == null:
		printerr("get_unit_pic_200 | no pic_200 for type: ", type)
		return ""
	return unit_type_do.pic_200
