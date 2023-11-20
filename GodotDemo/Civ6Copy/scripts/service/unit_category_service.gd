class_name UnitCategoryService


static func get_unit_category_do_by_enum(category: UnitCategoryTable.Enum) -> UnitCategoryDO:
	return DatabaseUtils.unit_category_tbl.query_by_enum_val(category)
