class_name CivTable
extends MySimSQL.EnumTable


enum Enum {
	AMERICA, # 美国
	ARABIA, # 阿拉伯
	AUSTRALIA, # 澳大利亚
	AZTEC, # 阿兹特克
	BABYLON, # 巴比伦
	BRAZIL, # 巴西
	BYZANTIUM, # 拜占庭
#	CANADA, # 加拿大
	CHINA, # 中国
#	CREE, # 克里
	EGYPT, # 埃及
	ENGLAND, # 英国
	ETHIOPIA, # 埃塞俄比亚
	FRANCE, # 法国
	GAUL, # 高卢
#	GEORGIA, # 格鲁吉亚
	GERMANY, # 德国
	GRAN_COLOMBIA, # 大哥伦比亚
	GREECE, # 希腊
#	HUNGARY, # 匈牙利
#	INCA, # 印加
	INDIA, # 印度
	INDONESIA, # 印度尼西亚
	JAPAN, # 日本
	KHMER, # 高棉
	KONGO, # 刚果
#	KOREA, # 朝鲜
	MACEDON, # 马其顿
#	MALI, # 马里
#	MAORI, # 毛利
#	MAPUCHE, # 马普切
	MAYA, # 玛雅
#	MONGOLIA, # 蒙古
#	NETHERLANDS, # 荷兰
	NORWAY, # 挪威
	NUBIA, # 努比亚
#	OTTOMAN, # 奥斯曼
	PERSIA, # 波斯
	POLAND, # 波兰
	PORTUGAL, # 葡萄牙
	PHOENICIA, # 腓尼基
	ROME, # 罗马
	RUSSIA, # 俄罗斯
#	SCOTLAND, # 苏格兰
	SCYTHIA, # 斯基泰
	SPAIN, # 西班牙
	SUMERIA, # 苏美尔
#	SWEDEN, # 瑞典
	VIETNAM, # 越南
#	ZULU, # 祖鲁
	BARBARIAN, # 野蛮人
}


func _init() -> void:
	super._init()
	elem_type = CivDO
	
	for k in Enum.keys():
		var do = CivDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.AMERICA:
				do.view_name = "美国"
			Enum.ARABIA:
				do.view_name = "阿拉伯"
			Enum.AUSTRALIA:
				do.view_name = "澳大利亚"
			Enum.AZTEC:
				do.view_name = "阿兹特克"
			Enum.BABYLON:
				do.view_name = "巴比伦"
			Enum.BRAZIL:
				do.view_name = "巴西"
			Enum.BYZANTIUM:
				do.view_name = "拜占庭"
#			Enum.CANADA:
#				do.view_name = "加拿大"
			Enum.CHINA:
				do.view_name = "中国"
#			Enum.CREE:
#				do.view_name = "克里"
			Enum.EGYPT:
				do.view_name = "埃及"
			Enum.ENGLAND:
				do.view_name = "英国"
			Enum.ETHIOPIA:
				do.view_name = "埃塞俄比亚"
			Enum.FRANCE:
				do.view_name = "法国"
			Enum.GAUL:
				do.view_name = "高卢"
#			Enum.GEORGIA:
#				do.view_name = "格鲁吉亚"
			Enum.GERMANY:
				do.view_name = "德国"
			Enum.GRAN_COLOMBIA:
				do.view_name = "大哥伦比亚"
			Enum.GREECE:
				do.view_name = "希腊"
#			Enum.HUNGARY:
#				do.view_name = "匈牙利"
#			Enum.INCA:
#				do.view_name = "印加"
			Enum.INDIA:
				do.view_name = "印度"
			Enum.INDONESIA:
				do.view_name = "印度尼西亚"
			Enum.JAPAN:
				do.view_name = "日本"
			Enum.KHMER:
				do.view_name = "高棉"
			Enum.KONGO:
				do.view_name = "刚果"
#			Enum.KOREA:
#				do.view_name = "朝鲜"
			Enum.MACEDON:
				do.view_name = "马其顿"
#			Enum.MALI:
#				do.view_name = "马里"
#			Enum.MAORI:
#				do.view_name = "毛利"
#			Enum.MAPUCHE:
#				do.view_name = "马普切"
			Enum.MAYA:
				do.view_name = "玛雅"
#			Enum.MONGOLIA:
#				do.view_name = "蒙古"
#			Enum.NETHERLANDS:
#				do.view_name = "荷兰"
			Enum.NORWAY:
				do.view_name = "挪威"
			Enum.NUBIA:
				do.view_name = "努比亚"
#			Enum.OTTOMAN:
#				do.view_name = "奥斯曼"
			Enum.PERSIA:
				do.view_name = "波斯"
			Enum.POLAND:
				do.view_name = "波兰"
			Enum.PORTUGAL:
				do.view_name = "葡萄牙"
			Enum.PHOENICIA:
				do.view_name = "腓尼基"
			Enum.ROME:
				do.view_name = "罗马"
			Enum.RUSSIA:
				do.view_name = "俄罗斯"
#			Enum.SCOTLAND:
#				do.view_name = "苏格兰"
			Enum.SCYTHIA:
				do.view_name = "斯基泰"
			Enum.SPAIN:
				do.view_name = "西班牙"
			Enum.SUMERIA:
				do.view_name = "苏美尔"
#			Enum.SWEDEN:
#				do.view_name = "瑞典"
			Enum.VIETNAM:
				do.view_name = "越南"
#			Enum.ZULU:
#				do.view_name = "祖鲁"
			Enum.BARBARIAN:
				do.view_name = "野蛮人"
		super.init_insert(do)
