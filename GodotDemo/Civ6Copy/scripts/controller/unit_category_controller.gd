class_name UnitCategoryController


static func get_unit_category_do_by_enum(category: UnitCategoryTable.Enum) -> UnitCategoryDO:
	return UnitCategoryService.get_unit_category_do_by_enum(category)
