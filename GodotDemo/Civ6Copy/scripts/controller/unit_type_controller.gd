class_name UnitTypeController


static func get_unit_type_do_by_enum(type: UnitTypeTable.Type) -> UnitTypeDO:
	return UnitTypeService.get_unit_type_do_by_enum(type)
