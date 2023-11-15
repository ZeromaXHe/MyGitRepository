class_name MapSizeTable
extends MySimSQL.EnumTable


# 地图尺寸
enum Size {
	DUAL, # 决斗
}


func _init() -> void:
	super._init()
	elem_type = MapSizeDO
	
	for k in Size.keys():
		var do = MapSizeDO.new()
		do.enum_name = k
		do.enum_val = Size[k]
		match do.enum_val:
			Size.DUAL:
				do.view_name = "决斗"
				do.size_vec = Vector2i(44, 26)
		super.init_insert(do)
