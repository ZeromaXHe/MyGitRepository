class_name TechTable
extends MySimSQL.EnumTable


enum Enum {
	# 远古时代
	MINING, # 采矿业
	IRRIGATION, # 灌溉
	SAILING, # 航海术
	ARCHERY, # 箭术
	WHEEL, # 轮子
	MASONRY, # 砌砖
	WRITING, # 写作
	ANIMAL_HUSBANDRY, # 畜牧业
	ASTROLOGY, # 占星术
	POTTERY, # 制陶术
	BRONZE_WORKING, # 铸铜术
	# 古典时期
	
}


func _init() -> void:
	super._init()
	elem_type = TechDO
	
	for k in Enum.keys():
		var do = TechDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.MINING:
				do.view_name = "采矿业"
				do.quotation = ["有谁能比矿工妻子更值得信任？——莫尔·特拉维斯",
						"不要一错再错。——威尔·罗杰斯"]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 25
			Enum.IRRIGATION:
				do.view_name = "灌溉"
				do.quotation = ["没有爱可以活下去，但没有水，没人能生存下来。——威斯坦·休·奥登",
						"一个有足够勇气的人才会去植树造林，一个城市的灌溉系统比它的征服者更具意义。——约翰·汤姆森爵士"]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = Enum.POTTERY
				do.research_cost = 50
				do.eureka_desc = "改良1种农产资源。"
				do.eureka_cost = 1
			Enum.SAILING:
				do.view_name = "航海术"
				do.quotation = ["大船可以多冒险，而小船则不能离岸太远。——本杰明·富兰克林",
						"我并不是厌恶陆地上的生活。但生活在海上会让我更开心。——德瑞克爵士"]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 50
				do.eureka_desc = "在海岸边建造1座城市。"
				do.eureka_cost = 1
			Enum.ARCHERY:
				do.view_name = "箭术"
				do.quotation = ["我朝天空射箭。不知箭落何方。——亨利·沃兹沃思·朗费罗",
						"但愿邪恶力量永远无法触及你。——乔治·卡林"]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = Enum.ANIMAL_HUSBANDRY
				do.research_cost = 50
				do.eureka_desc = "用投石兵击杀1个单位。"
				do.eureka_cost = 1
			Enum.WHEEL:
				do.view_name = "轮子"
				do.quotation = ["有时轮子旋转缓慢，但至少它在转动。——洛恩·迈克尔斯",
						"不要另起炉灶；只需稍作调整。——安东尼·安吉洛"]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = Enum.MINING
				do.research_cost = 80
				do.eureka_desc = "开采1种矿产资源"
				do.eureka_cost = 1
			Enum.MASONRY:
				do.view_name = "砌砖"
				do.quotation = ["我们每个人都能雕刻石头、建造圆柱、或切割一块彩色玻璃来建造比我们本身大得多的东西。——伍冰枝",
						"残暴的战争把铜像推翻，内讧把城池荡成一片废墟。——威廉·莎士比亚"]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = Enum.MINING
				do.research_cost = 80
				do.eureka_desc = "建造1座采石场。"
				do.eureka_cost = 1
			Enum.WRITING:
				do.view_name = "写作"
				do.quotation = ["写作意味着分享。分享是人类社会的一部分——思想、想法、意见。——保罗·科埃略",
						"写作很简单。你所要做的就是把错误的词语划掉。——马克·吐温"]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = Enum.POTTERY
				do.research_cost = 50
				do.eureka_desc = "遇见另一个文明。"
				do.eureka_cost = 1
			Enum.ANIMAL_HUSBANDRY:
				do.view_name = "畜牧业"
				do.quotation = ["如果天堂里没有狗，那么我死后，我想到狗去的地方去。——威尔·罗杰斯",
						"我喜欢猪。狗崇拜人类。猫鄙视人类。猪对我们一视同仁。——温斯顿·丘吉尔"]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 25
			Enum.ASTROLOGY:
				do.view_name = "占星术"
				do.quotation = ["我不相信星座。我是射手座，天生多疑。——亚瑟·查理斯·克拉克",
						"不懂星座的医生没资格称自己为医生。——希波克拉底"]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 50
				do.eureka_desc = "发现1个自然奇观。"
				do.eureka_cost = 1
			Enum.POTTERY:
				do.view_name = "制陶术"
				do.quotation = ["从来没有人弄湿黏土后就不管了，就像粘土可以变成砖块以此发家致富。——普鲁塔克",
						"我认为粘土在技艺精湛的制陶工人手中肯定会感到快乐。——珍妮特·菲奇"]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 25
			Enum.BRONZE_WORKING:
				do.view_name = "铸铜术"
				do.quotation = ["青铜制品是一种形态反射，是滋润心灵的美酒。——埃斯库罗斯",
						"我也对创造一份不朽的遗产感兴趣…因为青铜制品会维持数千年。——理查德·麦克唐纳"]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = Enum.MINING
				do.research_cost = 80
				do.eureka_desc = "击杀3个蛮族单位。"
				do.eureka_cost = 3
		super.init_insert(do)
