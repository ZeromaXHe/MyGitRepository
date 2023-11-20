class_name UnitTypeService


static func get_unit_type_do_by_enum(type: UnitTypeTable.Enum) -> UnitTypeDO:
	return DatabaseUtils.unit_type_tbl.query_by_enum_val(type)
