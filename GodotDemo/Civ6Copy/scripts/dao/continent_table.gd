class_name ContinentTable
extends MySimSQL.EnumTable


enum Enum {
	EMPTY, # 空
	AFRICA, # 非洲
	AMASIA, # 阿马西亚
	AMERICA, # 美洲
	ANTARCTICA, # 南极洲
	ARCTIC, # 北极大陆
	ASIA, # 亚洲
	ASIAMERICA, # 亚美大陆
	ATLANTICA, # 大西洋洲
	ATLANTIS, # 亚特兰蒂斯
	AUSTRALIA, # 澳大利亚
	AVALONIA, # 阿瓦隆尼亚
	AZANIA, # 阿扎尼亚
	BALTICA, # 波罗大陆
	CIMMERIA, # 辛梅利亚大陆
	COLUMBIA, # 哥伦比亚
	CONGO_CRATON, # 刚果克拉通
	EURAMERICA, # 欧美大陆
	EUROPE, # 欧洲
	GONDWANA, # 冈瓦那
	KALAHARI, # 喀拉哈里
	KAZAKHSTANIA, # 哈萨克大陆
	KENORLAND, # 凯诺兰
	KUMARI_KANDAM, # 古默里坎达
	LAURASIA, # 劳亚古陆
	LAURENTIA, # 劳伦古陆
	LEMURIA, # 利莫里亚 
	MU, # 穆大陆
	NENA, # 妮娜大陆
	NORTH_AMERICA, # 北美洲
	NOVOPANGAEA, # 新盘古大陆
	NUNA, # 努纳
	OCEANIA, # 大洋洲
	PANGAEA, # 盘古大陆
	PANGAEA_ULTIMA, # 终极盘古大陆
	PANNOTIA, # 潘诺西亚
	RODINIA, # 罗迪尼亚
	SIBERIA, # 西伯利亚
	SOUTH_AMERICA, # 南美洲
	TERRA_AUSTRALIS, # 未知的南方大陆
	UR, # 乌尔
	VAALBARA, # 瓦巴拉
	VENDIAN, # 文德期
	ZEALANDIA, # 西兰蒂亚
}


func _init() -> void:
	super._init()
	elem_type = ContinentDO
	
	for k in Enum.keys():
		var do = ContinentDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.EMPTY:
				do.view_name = "空"
			Enum.AFRICA:
				do.view_name = "非洲"
			Enum.AMASIA:
				do.view_name = "阿马西亚"
			Enum.AMERICA:
				do.view_name = "美洲"
			Enum.ANTARCTICA:
				do.view_name = "南极洲"
			Enum.ARCTIC:
				do.view_name = "北极大陆"
			Enum.ASIA:
				do.view_name = "亚洲"
			Enum.ASIAMERICA:
				do.view_name = "亚美大陆"
			Enum.ATLANTICA:
				do.view_name = "大西洋洲"
			Enum.ATLANTIS:
				do.view_name = "亚特兰蒂斯"
			Enum.AUSTRALIA:
				do.view_name = "澳大利亚"
			Enum.AVALONIA:
				do.view_name = "阿瓦隆尼亚"
			Enum.AZANIA:
				do.view_name = "阿扎尼亚"
			Enum.BALTICA:
				do.view_name = "波罗大陆"
			Enum.CIMMERIA:
				do.view_name = "辛梅利亚大陆"
			Enum.COLUMBIA:
				do.view_name = "哥伦比亚"
			Enum.CONGO_CRATON:
				do.view_name = "刚果克拉通"
			Enum.EURAMERICA:
				do.view_name = "欧美大陆"
			Enum.EUROPE:
				do.view_name = "欧洲"
			Enum.GONDWANA:
				do.view_name = "冈瓦那"
			Enum.KALAHARI:
				do.view_name = "喀拉哈里"
			Enum.KAZAKHSTANIA:
				do.view_name = "哈萨克大陆"
			Enum.KENORLAND:
				do.view_name = "凯诺兰"
			Enum.KUMARI_KANDAM:
				do.view_name = "古默里坎达"
			Enum.LAURASIA:
				do.view_name = "劳亚古陆"
			Enum.LAURENTIA:
				do.view_name = "劳伦古陆"
			Enum.LEMURIA:
				do.view_name = "利莫里亚 "
			Enum.MU:
				do.view_name = "穆大陆"
			Enum.NENA:
				do.view_name = "妮娜大陆"
			Enum.NORTH_AMERICA:
				do.view_name = "北美洲"
			Enum.NOVOPANGAEA:
				do.view_name = "新盘古大陆"
			Enum.NUNA:
				do.view_name = "努纳"
			Enum.OCEANIA:
				do.view_name = "大洋洲"
			Enum.PANGAEA:
				do.view_name = "盘古大陆"
			Enum.PANGAEA_ULTIMA:
				do.view_name = "终极盘古大陆"
			Enum.PANNOTIA:
				do.view_name = "潘诺西亚"
			Enum.RODINIA:
				do.view_name = "罗迪尼亚"
			Enum.SIBERIA:
				do.view_name = "西伯利亚"
			Enum.SOUTH_AMERICA:
				do.view_name = "南美洲"
			Enum.TERRA_AUSTRALIS:
				do.view_name = "未知的南方大陆"
			Enum.UR:
				do.view_name = "乌尔"
			Enum.VAALBARA:
				do.view_name = "瓦巴拉"
			Enum.VENDIAN:
				do.view_name = "文德期"
			Enum.ZEALANDIA:
				do.view_name = "西兰蒂亚"
		super.init_insert(do)
