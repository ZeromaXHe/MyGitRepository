class_name ContinentTable
extends MySimSQL.EnumTable


enum Continent {
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
	
	for k in Continent.keys():
		var do = ContinentDO.new()
		do.enum_name = k
		do.enum_val = Continent[k]
		match do.enum_val:
			Continent.EMPTY:
				do.view_name = "空"
			Continent.AFRICA:
				do.view_name = "非洲"
			Continent.AMASIA:
				do.view_name = "阿马西亚"
			Continent.AMERICA:
				do.view_name = "美洲"
			Continent.ANTARCTICA:
				do.view_name = "南极洲"
			Continent.ARCTIC:
				do.view_name = "北极大陆"
			Continent.ASIA:
				do.view_name = "亚洲"
			Continent.ASIAMERICA:
				do.view_name = "亚美大陆"
			Continent.ATLANTICA:
				do.view_name = "大西洋洲"
			Continent.ATLANTIS:
				do.view_name = "亚特兰蒂斯"
			Continent.AUSTRALIA:
				do.view_name = "澳大利亚"
			Continent.AVALONIA:
				do.view_name = "阿瓦隆尼亚"
			Continent.AZANIA:
				do.view_name = "阿扎尼亚"
			Continent.BALTICA:
				do.view_name = "波罗大陆"
			Continent.CIMMERIA:
				do.view_name = "辛梅利亚大陆"
			Continent.COLUMBIA:
				do.view_name = "哥伦比亚"
			Continent.CONGO_CRATON:
				do.view_name = "刚果克拉通"
			Continent.EURAMERICA:
				do.view_name = "欧美大陆"
			Continent.EUROPE:
				do.view_name = "欧洲"
			Continent.GONDWANA:
				do.view_name = "冈瓦那"
			Continent.KALAHARI:
				do.view_name = "喀拉哈里"
			Continent.KAZAKHSTANIA:
				do.view_name = "哈萨克大陆"
			Continent.KENORLAND:
				do.view_name = "凯诺兰"
			Continent.KUMARI_KANDAM:
				do.view_name = "古默里坎达"
			Continent.LAURASIA:
				do.view_name = "劳亚古陆"
			Continent.LAURENTIA:
				do.view_name = "劳伦古陆"
			Continent.LEMURIA:
				do.view_name = "利莫里亚 "
			Continent.MU:
				do.view_name = "穆大陆"
			Continent.NENA:
				do.view_name = "妮娜大陆"
			Continent.NORTH_AMERICA:
				do.view_name = "北美洲"
			Continent.NOVOPANGAEA:
				do.view_name = "新盘古大陆"
			Continent.NUNA:
				do.view_name = "努纳"
			Continent.OCEANIA:
				do.view_name = "大洋洲"
			Continent.PANGAEA:
				do.view_name = "盘古大陆"
			Continent.PANGAEA_ULTIMA:
				do.view_name = "终极盘古大陆"
			Continent.PANNOTIA:
				do.view_name = "潘诺西亚"
			Continent.RODINIA:
				do.view_name = "罗迪尼亚"
			Continent.SIBERIA:
				do.view_name = "西伯利亚"
			Continent.SOUTH_AMERICA:
				do.view_name = "南美洲"
			Continent.TERRA_AUSTRALIS:
				do.view_name = "未知的南方大陆"
			Continent.UR:
				do.view_name = "乌尔"
			Continent.VAALBARA:
				do.view_name = "瓦巴拉"
			Continent.VENDIAN:
				do.view_name = "文德期"
			Continent.ZEALANDIA:
				do.view_name = "西兰蒂亚"
		super.init_insert(do)
