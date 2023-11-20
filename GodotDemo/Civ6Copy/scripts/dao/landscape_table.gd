class_name LandscapeTable
extends MySimSQL.EnumTable


enum Enum {
	EMPTY, # 空
	ICE, # 冰
	FOREST, # 森林
	SWAMP, # 沼泽
	FLOOD, # 泛滥平原
	OASIS, # 绿洲
	RAINFOREST, # 雨林
}

var short_name_index := MySimSQL.Index.new("short_name", MySimSQL.Index.Type.UNIQUE)


func _init() -> void:
	super._init()
	elem_type = LandscapeDO
	create_index(short_name_index)
	
	for k in Enum.keys():
		var do = LandscapeDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.EMPTY:
				do.view_name = "空"
				do.short_name = "空"
			Enum.ICE:
				do.view_name = "冰"
				do.short_name = "冰块"
				do.movable = false
			Enum.FOREST:
				do.view_name = "森林"
				do.short_name = "森林"
				do.production = 1
				do.defence_bonus = 3
				do.move_cost = 1
				do.charm_influence = 1
			Enum.SWAMP:
				do.view_name = "沼泽"
				do.short_name = "沼泽"
				do.food = 1
				do.defence_bonus = -2
				do.move_cost = 1
				do.charm_influence = -1
			Enum.FLOOD:
				do.view_name = "泛滥平原"
				do.short_name = "泛滥"
				do.food = 3
				do.defence_bonus = -2
				do.charm_influence = -1
			Enum.OASIS:
				do.view_name = "绿洲"
				do.short_name = "绿洲"
				do.food = 3
				do.gold = 1
				do.charm_influence = 1
			Enum.RAINFOREST:
				do.view_name = "雨林"
				do.short_name = "雨林"
				do.production = 1
				do.defence_bonus = 3
				do.move_cost = 1
				do.charm_influence = -1
		super.init_insert(do)


func query_by_short_name(short_name: String) -> EnumDO:
	return short_name_index.get_do(short_name)[0] as LandscapeDO
