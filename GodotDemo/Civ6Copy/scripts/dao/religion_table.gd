class_name ReligionTable
extends MySimSQL.EnumTable


enum Enum {
	ZOROASTRIANISM, # 拜火教
	TAOISM, # 道教
	ORTHODOXY, # 东正教
	BUDDHISM, # 佛教
	CONFUCIANISM, # 儒家思想
	SHINTO, # 神道教
	CATHOLICISM, # 天主教
	SIKHISM, # 锡克教
	PROTESTANTISM, # 新教
	ISLAM, # 伊斯兰教
	HINDUISM, # 印度教
	JUDAISM, # 犹太教
}


func _init() -> void:
	super._init()
	elem_type = ReligionDO
	
	for k in Enum.keys():
		var do := ReligionDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.ZOROASTRIANISM:
				do.view_name = "拜火教"
			Enum.TAOISM:
				do.view_name = "道教"
			Enum.ORTHODOXY:
				do.view_name = "东正教"
			Enum.BUDDHISM:
				do.view_name = "佛教"
			Enum.CONFUCIANISM:
				do.view_name = "儒家思想"
			Enum.SHINTO:
				do.view_name = "神道教"
			Enum.CATHOLICISM:
				do.view_name = "天主教"
			Enum.SIKHISM:
				do.view_name = "锡克教"
			Enum.PROTESTANTISM:
				do.view_name = "新教"
			Enum.ISLAM:
				do.view_name = "伊斯兰教"
			Enum.HINDUISM:
				do.view_name = "印度教"
			Enum.JUDAISM:
				do.view_name = "犹太教"
		super.init_insert(do)
