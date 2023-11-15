class_name MapTypeTable
extends MySimSQL.EnumTable


# 地图类型
enum Type {
	BLANK, # 空白地图
}


func _init() -> void:
	super._init()
	elem_type = MapTypeDO
	
	for k in Type.keys():
		var do = MapTypeDO.new()
		do.enum_name = k
		do.enum_val = Type[k]
		match do.enum_val:
			Type.BLANK:
				do.view_name = "空白地图"
		super.init_insert(do)

