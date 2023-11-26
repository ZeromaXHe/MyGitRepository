class_name NaturalWonderTable
extends MySimSQL.EnumTable


enum Enum {
	EYJAFJALLAJOKULL, # 艾雅法拉火山
	BERMUDA_TRIANGLE, # 百慕大三角区
	TORRES_DEL_PAINE, # 百内国家公园
	TSINGY, # 贝马拉哈国家公园
	BARRIER_REEF, # 大堡礁
	CLIFFS_DOVER, # 多佛白崖
	CRATER_LAKE, # 火山口湖
	GALAPAGOS, # 加拉帕戈斯群岛
	GIANTS_CAUSEWAY, # 巨人堤
	LYSEFJORDEN, # 吕瑟峡湾
	PIOPIOTAHI, # 米尔福德峡湾
	PAITITI, # 帕依提提
	PANTANAL, # 潘塔纳尔湿地
	KILIMANJARO, # 乞力马扎罗山
	FOUNTAIN_OF_YOUTH, # 青春之泉
	DEAD_SEA, # 死海
	ULURU, # 乌卢鲁
	HA_LONG_BAY, # 下龙湾 
	YOSEMITE, # 约塞米蒂国家公园
	EVEREST, # 珠穆朗玛峰
}


func _init() -> void:
	super._init()
	elem_type = NaturalWonderDO
	
	for k in Enum.keys():
		var do = NaturalWonderDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.EYJAFJALLAJOKULL:
				do.view_name = "艾雅法拉火山"
				do.quotation = "高耸的巨大火柱照亮了大地，使霍尔特的夜晚如白昼一样明亮。——《利物浦水星报》"
				do.movable = false
				do.charm_influence = 2
				do.culture_influence = 1
				do.food_influence = 2
			Enum.BERMUDA_TRIANGLE:
				do.view_name = "百慕大三角区"
				do.quotation = "“无人知晓这片海洋隐藏着的美妙秘密，它那温柔却骇人的波涛似乎在诉说，深处隐藏着某些灵魂…那里有着无数暗影、溺亡的梦想和幻想，那些被我们称为生命和灵魂的东西，仍在梦中反复沉溺。”——赫尔曼·梅尔维尔"
				do.cells = 3
				do.charm_influence = 2
				do.science_influence = 5
			Enum.TORRES_DEL_PAINE:
				do.view_name = "百内国家公园"
				do.quotation = "一些坐落在一起的花冈岩峰很像老虎的牙齿，高高耸入天空。——霍华德·希尔曼"
				do.cells = 2
				do.movable = false
				do.charm_influence = 2
				do.double_terrain_yield = true
			Enum.TSINGY:
				do.view_name = "贝马拉哈国家公园"
				do.quotation = "泰斯尼是个占地647平方千米的老虎陷阱，由带有参差不齐长矛的巨大方尖碑组成。是的，它们会将你的漂亮脸蛋刺破。——巴德·埃里克森"
				do.movable = false
				do.charm_influence = 2
				do.culture_influence = 1
				do.science_influence = 1
			Enum.BARRIER_REEF:
				do.view_name = "大堡礁"
				do.quotation = "微生物不认为二氧化碳是一种毒药。形成贝壳和珊瑚的植物与微生物把二氧化碳看作它们的基本成分。——珍妮·班娜斯"
				do.cells = 2
				do.food = 3
				do.science = 2
				do.charm_influence = 2
			Enum.CLIFFS_DOVER:
				do.view_name = "多佛白崖"
				do.quotation = "在白色悬崖城垛上的王国政府里，一片寂静，比安息日还要寂静。——威廉·华兹华斯"
				do.cells = 2
				do.food = 2
				do.gold = 3
				do.culture = 3
				do.charm_influence = 2
			Enum.CRATER_LAKE:
				do.view_name = "火山口湖"
				do.quotation = "我再也没能看到地球上的美景，这些景色是我见过的最美好的事物。火山口湖是最美的景观。——杰克·伦敦"
				do.science = 1
				do.faith = 5
				do.charm_influence = 2
			Enum.GALAPAGOS:
				do.view_name = "加拉帕戈斯群岛"
				do.quotation = "这个群岛的自然历史非常奇特：它好像自成一个小世界。——查尔斯·达尔文"
				do.cells = 2
				do.movable = false
				do.charm_influence = 2
				do.science_influence = 2
			Enum.GIANTS_CAUSEWAY:
				do.view_name = "巨人堤"
				do.quotation = "这里有深棕色的非晶玄武岩和红色的赭石，下面则是纤细而独特的木炭层。——都柏林便士期刊"
				do.movable = false
				do.charm_influence = 2
				do.culture_influence = 1
			Enum.LYSEFJORDEN:
				do.view_name = "吕瑟峡湾"
				do.quotation = "在这片海和无尽的孤独中出现了一条昏暗的道路，一条没有人类足迹的道路。没有人曾经过此地；亦没有船只曾在此航行。——维克多·雨果"
				do.movable = false
				do.charm_influence = 2
				do.production_influence = 1
			Enum.PIOPIOTAHI:
				do.view_name = "米尔福德峡湾"
				do.quotation = "但，当我进入新西兰峡湾中心时，我有了久违的孩童般的喜悦感，纯粹的敬畏感也涌入心底。我知道通往米尔福德峡湾的道路景色很美——但这岂止是美？——达罗克·唐纳德"
				do.cells = 3
				do.movable = false
				do.charm_influence = 2
				do.culture_influence = 1
				do.gold_influence = 1
			Enum.PAITITI:
				do.view_name = "帕依提提"
				do.quotation = "“如未开采的黄金一般，隐藏在枝繁叶茂的旷野之中。”——约翰·缪尔"
				do.cells = 3
				do.movable = false
				do.charm_influence = 2
				do.gold_influence = 3
				do.culture_influence = 2
			Enum.PANTANAL:
				do.view_name = "潘塔纳尔湿地"
				do.quotation = "潘塔纳尔湿地是世界上最复杂的热带冲积平原，可能也是最不为人所知的地方。——阿齐兹·萨比尔"
				do.cells = 4
				do.move_cost = 1
				do.defence_bonus = -2
				do.food = 2
				do.culture = 2
				do.charm_influence = 2
			Enum.KILIMANJARO:
				do.view_name = "乞力马扎罗山"
				do.quotation = "事实证明乞力马扎罗山上没有WIFI，所以，旅行途中我花了两周时间在坦桑尼亚和人聊天。——南希·邦兹"
				do.movable = false
				do.charm_influence = 2
				do.food_influence = 2
			Enum.FOUNTAIN_OF_YOUTH:
				do.view_name = "青春之泉"
				do.quotation = "“吉耶婆那渴望获得美丽，于是便一跃入水。孪生兄弟双马童也没入水中。而当他们出水之时…已焕发年轻美丽的全新光彩。”——无名氏"
				do.science = 4
				do.faith = 4
			Enum.DEAD_SEA:
				do.view_name = "死海"
				do.quotation = "就像死海海岸上的苹果，吃了一口，全是灰。——拜伦勋爵"
				do.cells = 2
				do.culture = 2
				do.faith = 2
				do.charm_influence = 2
			Enum.ULURU:
				do.view_name = "乌卢鲁"
				do.quotation = "雨季时这里景色该有多壮丽啊，四面八方都是瀑布！——威廉·高斯"
				do.movable = false
				do.charm_influence = 4
				do.culture_influence = 2
				do.faith_influence = 2
			Enum.HA_LONG_BAY:
				do.view_name = "下龙湾"
				do.quotation = "看哪，人间竟有如此仙境。清澈的湛蓝海水有如镜子般透彻，而成千上万的海龟则为海面增添了些许黝黑。——阮廌"
				do.cells = 2
				do.defence_bonus = 15
				do.food = 3
				do.production = 1
				do.culture = 1
				do.charm_influence = 2
			Enum.YOSEMITE:
				do.view_name = "约塞米蒂国家公园"
				do.quotation = "对我来说，约塞米蒂谷是在石头和空间组成的巨大建筑物上形成的一个永远有日出、闪着绿光的金色奇迹。——安塞尔·亚当斯"
				do.cells = 2
				do.movable = false
				do.charm_influence = 2
				do.science_influence = 1
				do.gold_influence = 1
			Enum.EVEREST:
				do.view_name = "珠穆朗玛峰"
				do.quotation = "我们征服的不是高山，而是自己。——埃德蒙·希拉里爵士"
				do.cells = 3
				do.movable = false
				do.charm_influence = 2
				do.faith_influence = 1
		super.init_insert(do)

