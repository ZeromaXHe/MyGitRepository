class_name EraTable
extends MySimSQL.EnumTable


enum Enum {
	ANCIENT, # 远古时代
	CLASSICAL, # 古典时期
	MEDIEVAL, # 中世纪
	RENAISSANCE, # 文艺复兴时期
	INDUSTRIAL, # 工业时代
	MODERN, # 现代
	ATOMIC, # 原子能时代
	INFOMATION, # 信息时代
}


func _init() -> void:
	super._init()
	elem_type = EraDO
	
	for k in Enum.keys():
		var do = EraDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.ANCIENT:
				do.view_name = "远古时代"
			Enum.CLASSICAL:
				do.view_name = "古典时期"
			Enum.MEDIEVAL:
				do.view_name = "中世纪"
			Enum.RENAISSANCE:
				do.view_name = "文艺复兴时期"
			Enum.INDUSTRIAL:
				do.view_name = "工业时代"
			Enum.MODERN:
				do.view_name = "现代"
			Enum.ATOMIC:
				do.view_name = "原子能时代"
			Enum.INFOMATION:
				do.view_name = "信息时代"
		super.init_insert(do)

