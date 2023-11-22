class_name CityStateTable
extends MySimSQL.EnumTable


enum Type {
	INDUSTRY, # 工业
	MILITARY, # 军事
	TECH, # 科技
	TRADE, # 贸易
	CULTURE, # 文化
	RELIGION, # 宗教
}

enum Enum {
	# 工业
	AUCKLAND, # 奥克兰
	BRUSSELS, # 布鲁塞尔
	BUENOS_AIRES, # 布宜诺斯艾利斯
	TORONTO, # 多伦多
	HONG_KONG, # 香港
	SINGAPORE, # 新加坡
	JOHANNESBURG, # 约翰内斯堡
	# 军事
	GRANADA, # 格拉纳达
	KABUL, # 喀布尔
	LAHORE, # 拉合尔
	PRESLAV, # 普雷斯拉夫
	VALLETTA, # 瓦莱塔
	WOLIN, # 沃林
	CARTHAGE, # 迦太基
	# 科技
	HATTUSA, # 哈图沙
	PALENQUE, # 米特拉
	NALANDA, # 那烂陀
	GENEVA, # 日内瓦
	SEOUL, # 首尔
	STOCKHOLM, # 斯德哥尔摩
	TARUGA, # 塔鲁加
	# 贸易
	AMSTERDAM, # 阿姆斯特丹
	HUNZA, # 罕萨
	MUSCAT, # 马斯喀特
	LISBON, # 摩加迪沙
	SAMARKAND, # 撒马尔罕
	ZANZIBAR, # 桑给巴尔
	JAKARTA, # 斯里巴加湾
	# 文化
	AYUTTHAYA, # 阿瑜陀耶
	CAGUANA, # 卡瓜纳
	KUMASI, # 库马西
	MOHENJO_DARO, # 摩亨朱·达罗
	NAN_MADOL, # 南马都尔
	ANTANANARIVO, # 塔那那利佛
	VILNIUS, # 维尔纽斯
	# 宗教
	ARMAGH, # 阿尔马
	YEREVAN, # 埃里温
	KANDY, # 康提
	LA_VENTA, # 拉文塔
	CHINGUETTI, # 欣盖提
	JERUSALEM, # 耶路撒冷
	VATICAN_CITY, # 梵蒂冈城
}


var type_index := MySimSQL.Index.new("type", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	super._init()
	elem_type = CityStateDO
	create_index(type_index)
	
	for k in Enum.keys():
		var do = CityStateDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.AUCKLAND:
				do.view_name = "奥克兰"
				do.type = Type.INDUSTRY
			Enum.BRUSSELS:
				do.view_name = "布鲁塞尔"
				do.type = Type.INDUSTRY
			Enum.BUENOS_AIRES:
				do.view_name = "布宜诺斯艾利斯"
				do.type = Type.INDUSTRY
			Enum.TORONTO:
				do.view_name = "多伦多"
				do.type = Type.INDUSTRY
			Enum.HONG_KONG:
				do.view_name = "香港"
				do.type = Type.INDUSTRY
			Enum.SINGAPORE:
				do.view_name = "新加坡"
				do.type = Type.INDUSTRY
			Enum.JOHANNESBURG:
				do.view_name = "约翰内斯堡"
				do.type = Type.INDUSTRY
			Enum.GRANADA:
				do.view_name = "格拉纳达"
				do.type = Type.MILITARY
			Enum.KABUL:
				do.view_name = "喀布尔"
				do.type = Type.MILITARY
			Enum.LAHORE:
				do.view_name = "拉合尔"
				do.type = Type.MILITARY
			Enum.PRESLAV:
				do.view_name = "普雷斯拉夫"
				do.type = Type.MILITARY
			Enum.VALLETTA:
				do.view_name = "瓦莱塔"
				do.type = Type.MILITARY
			Enum.WOLIN:
				do.view_name = "沃林"
				do.type = Type.MILITARY
			Enum.CARTHAGE:
				do.view_name = "迦太基"
				do.type = Type.MILITARY
			Enum.HATTUSA:
				do.view_name = "哈图沙"
				do.type = Type.TECH
			Enum.PALENQUE:
				do.view_name = "米特拉"
				do.type = Type.TECH
			Enum.NALANDA:
				do.view_name = "那烂陀"
				do.type = Type.TECH
			Enum.GENEVA:
				do.view_name = "日内瓦"
				do.type = Type.TECH
			Enum.SEOUL:
				do.view_name = "首尔"
				do.type = Type.TECH
			Enum.STOCKHOLM:
				do.view_name = "斯德哥尔摩"
				do.type = Type.TECH
			Enum.TARUGA:
				do.view_name = "塔鲁加"
				do.type = Type.TECH
			Enum.AMSTERDAM:
				do.view_name = "阿姆斯特丹"
				do.type = Type.TRADE
			Enum.HUNZA:
				do.view_name = "罕萨"
				do.type = Type.TRADE
			Enum.MUSCAT:
				do.view_name = "马斯喀特"
				do.type = Type.TRADE
			Enum.LISBON:
				do.view_name = "摩加迪沙"
				do.type = Type.TRADE
			Enum.SAMARKAND:
				do.view_name = "撒马尔罕"
				do.type = Type.TRADE
			Enum.ZANZIBAR:
				do.view_name = "桑给巴尔"
				do.type = Type.TRADE
			Enum.JAKARTA:
				do.view_name = "斯里巴加湾"
				do.type = Type.TRADE
			Enum.AYUTTHAYA:
				do.view_name = "阿瑜陀耶"
				do.type = Type.CULTURE
			Enum.CAGUANA:
				do.view_name = "卡瓜纳"
				do.type = Type.CULTURE
			Enum.KUMASI:
				do.view_name = "库马西"
				do.type = Type.CULTURE
			Enum.MOHENJO_DARO:
				do.view_name = "摩亨朱·达罗"
				do.type = Type.CULTURE
			Enum.NAN_MADOL:
				do.view_name = "南马都尔"
				do.type = Type.CULTURE
			Enum.ANTANANARIVO:
				do.view_name = "塔那那利佛"
				do.type = Type.CULTURE
			Enum.VILNIUS:
				do.view_name = "维尔纽斯"
				do.type = Type.CULTURE
			Enum.ARMAGH:
				do.view_name = "阿尔马"
				do.type = Type.RELIGION
			Enum.YEREVAN:
				do.view_name = "埃里温"
				do.type = Type.RELIGION
			Enum.KANDY:
				do.view_name = "康提"
				do.type = Type.RELIGION
			Enum.LA_VENTA:
				do.view_name = "拉文塔"
				do.type = Type.RELIGION
			Enum.CHINGUETTI:
				do.view_name = "欣盖提"
				do.type = Type.RELIGION
			Enum.JERUSALEM:
				do.view_name = "耶路撒冷"
				do.type = Type.RELIGION
			Enum.VATICAN_CITY:
				do.view_name = "梵蒂冈城"
				do.type = Type.RELIGION
		super.init_insert(do)


func query_by_type(type: Type) -> CityStateDO:
	return type_index.get_do(type)[0] as CityStateDO
