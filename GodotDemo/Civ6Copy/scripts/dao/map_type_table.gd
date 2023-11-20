class_name MapTypeTable
extends MySimSQL.EnumTable


# 地图类型
enum Enum {
	BLANK, # 空白地图
}


func _init() -> void:
	super._init()
	elem_type = MapTypeDO
	
	for k in Enum.keys():
		var do = MapTypeDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.BLANK:
				do.view_name = "空白地图"
		super.init_insert(do)

