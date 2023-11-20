class_name UnitController


const UNIT_SCENE: PackedScene = preload("res://scenes/game/unit.tscn")


static func create_unit(req_dto: CreateUnitReqDTO) -> Unit:
	var unit_do: UnitDO = UnitService.create_unit(req_dto)
	var unit: Unit = UNIT_SCENE.instantiate()
	unit.id = unit_do.id
	ViewHolder.register_unit(unit)
	return unit


static func get_unit_do(id: int) -> UnitDO:
	return UnitService.get_unit_do(id)


static func get_unit_dos_on_coord(coord: Vector2i) -> Array:
	return UnitService.get_unit_dos_on_coord(coord)


static func wake_unit(id: int) -> void:
	UnitService.wake_unit(id)


static func skip_unit(id: int) -> void:
	UnitService.skip_unit(id)


static func sleep_unit(id: int) -> void:
	UnitService.sleep_unit(id)


static func cost_unit_move(id: int, cost: int) -> void:
	var new_move: int = UnitService.cost_unit_move(id, cost)
	var unit: Unit = ViewHolder.get_unit(id)
	ViewSignalsEmitter.get_instance().unit_move_changed.emit(id, new_move)
	if new_move == 0:
		ViewSignalsEmitter.get_instance().unit_move_depleted.emit(id)


static func move_unit(id: int, coord: Vector2i) -> void:
	UnitService.move_unit(id, coord)


static func delete_unit(id: int) -> void:
	UnitService.delete_unit(id)


static func get_sight_range() -> int:
	# TODO: 先通通返回 2 格视野
	return 2


static func get_move_range(unit_id: int) -> int:
	return UnitService.get_move_range(unit_id)


static func get_unit_pic_webp_256x256(type: UnitTypeTable.Enum) -> Texture2D:
	var unit_type_do: UnitTypeDO = UnitTypeController.get_unit_type_do_by_enum(type)
	if unit_type_do == null:
		printerr("get_unit_pic_webp_256x256 | no pic for type: ", type)
		return null
	return load(unit_type_do.icon_256)


static func get_unit_pic_webp_64x64(type: UnitTypeTable.Enum) -> Texture2D:
	var unit_type_do: UnitTypeDO = UnitTypeController.get_unit_type_do_by_enum(type)
	if unit_type_do == null:
		printerr("get_unit_pic_webp_64x64 | no pic for type: ", type)
		return null
	if type == UnitTypeTable.Enum.SETTLER:
		# 开拓者目前没有 64x64 的图
		return load(unit_type_do.icon_256)
	return load(unit_type_do.icon_64)


static func get_unit_name(type: UnitTypeTable.Enum) -> String:
	var unit_type_do: UnitTypeDO = UnitTypeController.get_unit_type_do_by_enum(type)
	if unit_type_do == null:
		printerr("get_unit_name | no name for type: ", type)
		return ""
	return unit_type_do.view_name


static func get_unit_pic_200(type: UnitTypeTable.Enum) -> String:
	var unit_type_do: UnitTypeDO = UnitTypeController.get_unit_type_do_by_enum(type)
	if unit_type_do == null:
		printerr("get_unit_pic_200 | no pic_200 for type: ", type)
		return ""
	return unit_type_do.pic_200

