class_name RouteTable
extends MySimSQL.EnumTable


enum Enum {
	ANCIENT_ROAD, # 远古时代道路
	MEDIEVAL_ROAD, # 古典时代道路
	INDUSTRIAL_ROAD, # 工业时代道路
	MODERN_ROAD, # 现代道路
}


func _init() -> void:
	super._init()
	elem_type = RouteDO
	
	for k in Enum.keys():
		var do = RouteDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.ANCIENT_ROAD:
				do.view_name = "远古时代道路"
				do.move_cost = 1.0
			Enum.MEDIEVAL_ROAD:
				do.view_name = "古典时代道路"
				do.move_cost = 1.0
				do.bridge = true
				do.era = EraTable.Enum.CLASSICAL
			Enum.INDUSTRIAL_ROAD:
				do.view_name = "工业时代道路"
				do.move_cost = 0.75
				do.bridge = true
				do.era = EraTable.Enum.INDUSTRIAL
			Enum.MODERN_ROAD:
				do.view_name = "现代道路"
				do.move_cost = 0.5
				do.bridge = true
				do.era = EraTable.Enum.MODERN
		super.init_insert(do)
