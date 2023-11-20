class_name UnitTypeTable
extends MySimSQL.EnumTable


enum Enum {
	SETTLER, # 开拓者
	BUILDER, # 建造者
	SCOUT, # 侦察兵
	WARRIOR, # 勇士
}


func _init() -> void:
	super._init()
	elem_type = UnitTypeDO
	
	for k in Enum.keys():
		var do := UnitTypeDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.SETTLER:
				do.view_name = "开拓者"
				do.category = UnitCategoryTable.Enum.CITIZEN
				do.move = 2
				# 开拓者暂时没有 64 尺寸的素材
				do.icon_64 = ""
				do.icon_256 = "res://assets/civ6_origin/unit/webp_256x256/icon_unit_settler.webp"
				do.pic_200 = "res://assets/civ6_origin/unit/png_200/unit_settler.png"
			Enum.BUILDER:
				do.view_name = "建造者"
				do.category = UnitCategoryTable.Enum.CITIZEN
				do.move = 2
				do.labor = 3
				do.icon_64 = "res://assets/civ6_origin/unit/webp_64x64/icon_unit_builder.webp"
				do.icon_256 = "res://assets/civ6_origin/unit/webp_256x256/icon_unit_builder.webp"
				# 暂时没有 200 尺寸的单位画像素材
				do.pic_200 = ""
			Enum.SCOUT:
				do.view_name = "侦察兵"
				do.category = UnitCategoryTable.Enum.GROUND_FORCE
				do.move = 3
				do.melee_atk = 10
				do.icon_64 = "res://assets/civ6_origin/unit/webp_64x64/icon_unit_scout.webp"
				do.icon_256 = "res://assets/civ6_origin/unit/webp_256x256/icon_unit_scout.webp"
				# 暂时没有 200 尺寸的单位画像素材
				do.pic_200 = ""
			Enum.WARRIOR:
				do.view_name = "勇士"
				do.category = UnitCategoryTable.Enum.GROUND_FORCE
				do.move = 2
				do.melee_atk = 20
				do.icon_64 = "res://assets/civ6_origin/unit/webp_64x64/icon_unit_warrior.webp"
				do.icon_256 = "res://assets/civ6_origin/unit/webp_256x256/icon_unit_warrior.webp"
				do.pic_200 = "res://assets/civ6_origin/unit/png_200/unit_warrior.png"
		super.init_insert(do)

