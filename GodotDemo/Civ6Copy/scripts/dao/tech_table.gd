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
	ENGINEERING, # 工程
	CURRENCY, # 货币
	CONSTRUCTION, # 建造
	IRON_WORKING, # 炼铁术
	HORSEBACK_RIDING, # 骑马
	MATHEMATICS, # 数学
	CELESTIAL_NAVIGATION, # 天文导航
	SHIPBUILDING, # 造船术
	# 中世纪
	CASTLES, # 城堡
	MACHINERY, # 机械
	EDUCATION, # 教育
	MILITARY_ENGINEERING, # 军事工程学
	STIRRUPS, # 马镫
	APPRENTICESHIP, # 学徒
	MILITARY_TACTICS, # 战术
	# 文艺复兴时期
	SIEGE_TACTICS, # 攻城术
	SQUARE_RIGGING, # 横帆装置
	GUNPOWDER, # 火药
	METAL_CASTING, # 金属铸造
	MASS_PRODUCTION, # 批量生产
	ASTRONOMY, # 天文学
	BANKING, # 银行业
	PRINTING, # 印刷术
	CARTOGRAPHY, # 制图学
	# 工业时代
	BALLISTICS, # 弹道学
	INDUSTRIALIZATION, # 工业化
	ECONOMICS, # 经济
	MILITARY_SCIENCE, # 军事学
	SCIENTIFIC_THEORY, # 科学理论
	RIFLING, # 膛线
	SANITATION, # 卫生设备
	STEAM_POWER, # 蒸汽动力
	# 现代
	ELECTRICITY, # 电力
	FLIGHT, # 飞行
	STEEL, # 钢铁
	CHEMISTRY, # 化学
	REPLACEABLE_PARTS, # 零件规格化
	COMBUSTION, # 内燃机
	RADIO, # 无线电
	# 原子能时代
	COMPUTERS, # 电脑
	ADVANCED_BALLISTICS, # 高级弹道学
	NUCLEAR_FISSION, # 核裂变
	SYNTHETIC_MATERIALS, # 合成材料
	ROCKETRY, # 火箭研究
	COMBINED_ARMS, # 联合作战
	PLASTICS, # 塑料
	ADVANCED_FLIGHT, # 现代航空
	# 信息时代
	COMPOSITES, # 复合材料
	NUCLEAR_FUSION, # 核聚变
	ROBOTICS, # 机器人技术
	LASERS, # 激光
	NANOTECHNOLOGY, # 纳米技术
	FUTURE_TECH, # 未来科技
	SATELLITES, # 卫星
	STEALTH_TECHNOLOGY, # 隐形技术
	TELECOMMUNICATIONS, # 远程通信
	GUIDANCE_SYSTEMS, # 制导系统
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
				do.quotation = [
					"有谁能比矿工妻子更值得信任？——莫尔·特拉维斯",
					"不要一错再错。——威尔·罗杰斯"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 25
			Enum.IRRIGATION:
				do.view_name = "灌溉"
				do.quotation = [
					"没有爱可以活下去，但没有水，没人能生存下来。——威斯坦·休·奥登",
					"一个有足够勇气的人才会去植树造林，一个城市的灌溉系统比它的征服者更具意义。——约翰·汤姆森爵士"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = [Enum.POTTERY] as Array[Enum]
				do.research_cost = 50
				do.eureka_desc = "改良1种农产资源。"
				do.eureka_cost = 1
			Enum.SAILING:
				do.view_name = "航海术"
				do.quotation = [
					"大船可以多冒险，而小船则不能离岸太远。——本杰明·富兰克林",
					"我并不是厌恶陆地上的生活。但生活在海上会让我更开心。——德瑞克爵士"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 50
				do.eureka_desc = "在海岸边建造1座城市。"
				do.eureka_cost = 1
			Enum.ARCHERY:
				do.view_name = "箭术"
				do.quotation = [
					"我朝天空射箭。不知箭落何方。——亨利·沃兹沃思·朗费罗",
					"但愿邪恶力量永远无法触及你。——乔治·卡林"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = [Enum.ANIMAL_HUSBANDRY] as Array[Enum]
				do.research_cost = 50
				do.eureka_desc = "用投石兵击杀1个单位。"
				do.eureka_cost = 1
			Enum.WHEEL:
				do.view_name = "轮子"
				do.quotation = [
					"有时轮子旋转缓慢，但至少它在转动。——洛恩·迈克尔斯",
					"不要另起炉灶；只需稍作调整。——安东尼·安吉洛"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = [Enum.MINING] as Array[Enum]
				do.research_cost = 80
				do.eureka_desc = "开采1种矿产资源"
				do.eureka_cost = 1
			Enum.MASONRY:
				do.view_name = "砌砖"
				do.quotation = [
					"我们每个人都能雕刻石头、建造圆柱、或切割一块彩色玻璃来建造比我们本身大得多的东西。——伍冰枝",
					"残暴的战争把铜像推翻，内讧把城池荡成一片废墟。——威廉·莎士比亚"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = [Enum.MINING] as Array[Enum]
				do.research_cost = 80
				do.eureka_desc = "建造1座采石场。"
				do.eureka_cost = 1
			Enum.WRITING:
				do.view_name = "写作"
				do.quotation = [
					"写作意味着分享。分享是人类社会的一部分——思想、想法、意见。——保罗·科埃略",
					"写作很简单。你所要做的就是把错误的词语划掉。——马克·吐温"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = [Enum.POTTERY] as Array[Enum]
				do.research_cost = 50
				do.eureka_desc = "遇见另一个文明。"
				do.eureka_cost = 1
			Enum.ANIMAL_HUSBANDRY:
				do.view_name = "畜牧业"
				do.quotation = [
					"如果天堂里没有狗，那么我死后，我想到狗去的地方去。——威尔·罗杰斯",
					"我喜欢猪。狗崇拜人类。猫鄙视人类。猪对我们一视同仁。——温斯顿·丘吉尔"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 25
			Enum.ASTROLOGY:
				do.view_name = "占星术"
				do.quotation = [
					"我不相信星座。我是射手座，天生多疑。——亚瑟·查理斯·克拉克",
					"不懂星座的医生没资格称自己为医生。——希波克拉底"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 50
				do.eureka_desc = "发现1个自然奇观。"
				do.eureka_cost = 1
			Enum.POTTERY:
				do.view_name = "制陶术"
				do.quotation = [
					"从来没有人弄湿黏土后就不管了，就像粘土可以变成砖块以此发家致富。——普鲁塔克",
					"我认为粘土在技艺精湛的制陶工人手中肯定会感到快乐。——珍妮特·菲奇"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.research_cost = 25
			Enum.BRONZE_WORKING:
				do.view_name = "铸铜术"
				do.quotation = [
					"青铜制品是一种形态反射，是滋润心灵的美酒。——埃斯库罗斯",
					"我也对创造一份不朽的遗产感兴趣…因为青铜制品会维持数千年。——理查德·麦克唐纳"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_tech = [Enum.MINING] as Array[Enum]
				do.research_cost = 80
				do.eureka_desc = "击杀3个蛮族单位。"
				do.eureka_cost = 3
			Enum.ENGINEERING:
				do.view_name = "工程"
				do.quotation = [
					"萝卜青菜各有所爱。——罗伯特·海因莱因",
					"正常人认为东西没坏就别修它。工程师认为东西没坏是它功能太少。——斯科特·亚当斯"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_tech = [Enum.WHEEL] as Array[Enum]
				do.research_cost = 200
				do.eureka_desc = "建造远古城墙。"
				do.eureka_cost = 1
			Enum.CURRENCY:
				do.view_name = "货币"
				do.quotation = [
					"财富不在于多得，而在于少欲。——爱比克泰德",
					"钱如果没有给你带来幸福，至少也能让你在舒适中痛苦。——海伦·格蕾·布朗"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_tech = [Enum.WRITING] as Array[Enum]
				do.research_cost = 120
				do.eureka_desc = "建立1条贸易路线。"
				do.eureka_cost = 1
			Enum.CONSTRUCTION:
				do.view_name = "建造"
				do.quotation = [
					"用心创作；用知识建造。——克里斯·杰米",
					"宇宙的四个基本成分是水、火、砂砾和乙烯基。——戴夫·巴里"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_tech = [Enum.MASONRY, Enum.HORSEBACK_RIDING] as Array[Enum]
				do.research_cost = 200
				do.eureka_desc = "建造1个水磨。"
				do.eureka_cost = 1
			Enum.IRON_WORKING:
				do.view_name = "炼铁术"
				do.quotation = [
					"上帝通过铁器创造了我们。然后他升高温度，将其中一些铸造成钢。——玛莉·奥斯蒙",
					"万物都有极限——铁矿石不可能被打造成黄金。——马克·吐温"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_tech = [Enum.BRONZE_WORKING] as Array[Enum]
				do.research_cost = 120
				do.eureka_desc = "建造1座铁矿。"
				do.eureka_cost = 1
			Enum.HORSEBACK_RIDING:
				do.view_name = "骑马"
				do.quotation = [
					"没有浪费任何时间在马鞍上。——温斯顿·丘吉尔",
					"骑马的人在精神和体格方面都比走路的人强。——约翰·斯坦贝克"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_tech = [Enum.ARCHERY] as Array[Enum]
				do.research_cost = 120
				do.eureka_desc = "建造1座牧场。"
				do.eureka_cost = 1
			Enum.MATHEMATICS:
				do.view_name = "数学"
				do.quotation = [
					"没有数学，你什么也做不了。你周围的一切都是数学。你周围的一切都是数字。——夏琨塔拉·戴维",
					"如果我再次进行研究，我会听从柏拉图的建议，从数学开始。——伽利略·伽利雷"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_tech = [Enum.CURRENCY] as Array[Enum]
				do.research_cost = 120
				do.eureka_desc = "建造3个不同的特色区域。"
				do.eureka_cost = 3
			Enum.CELESTIAL_NAVIGATION:
				do.view_name = "天文导航"
				do.quotation = [
					"我要的只是一艘高高的船，一颗星星为我导航。——约翰·梅斯菲尔德",
					"按照星星，而不是按照过往船只的灯光设定航向。——奥马尔·布拉德利"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_tech = [Enum.SAILING, Enum.ASTROLOGY] as Array[Enum]
				do.research_cost = 120
				do.eureka_desc = "改良2处海洋资源。"
				do.eureka_cost = 2
			Enum.SHIPBUILDING:
				do.view_name = "造船术"
				do.quotation = [
					"我无法想象出人类是在什么情况下造出了船…现代造船已不止于此。——皇家邮轮泰坦尼克号船长爱德华·约翰·史密斯",
					"在水手和来世之间除了块厚木板，什么也没有。——汤姆斯·吉本斯"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_tech = [Enum.SAILING] as Array[Enum]
				do.research_cost = 200
				do.eureka_desc = "拥有2艘桨帆船。"
				do.eureka_cost = 2
			Enum.CASTLES:
				do.view_name = "城堡"
				do.quotation = [
					"前路有危险？我并不会避开它们。最危险的地方就是最安全的地方。——内莫·诺克斯",
					"如果你看见了云雾笼罩的城堡，那么请一定走向那里去实现你非凡的梦想吧。——穆罕默德·穆拉特·伊尔登"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_tech = [Enum.CONSTRUCTION] as Array[Enum]
				do.research_cost = 390
				do.eureka_desc = "采用带有6个固定政策槽位的政体。"
				do.eureka_cost = 1
			Enum.MACHINERY:
				do.view_name = "机械"
				do.quotation = [
					"我会想象世界就是一个机器。机器不会有多余零件。它们永远都是需要多少就有多少。——雨果·卡布里特",
					"记住：不仅是机器，人类自己也会出毛病。——格雷戈里•本福德"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_tech = [Enum.IRON_WORKING, Enum.ENGINEERING] as Array[Enum]
				do.research_cost = 300
				do.eureka_desc = "拥有3名弓箭手。"
				do.eureka_cost = 3
			Enum.EDUCATION:
				do.view_name = "教育"
				do.quotation = [
					"教育的目的是用充实的知识取代空虚的头脑。——迈尔康·福布斯",
					"受教育的标志是你可以不接受一种观点，但你能够容纳它。——亚里士多德"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_tech = [Enum.MATHEMATICS, Enum.ENGINEERING] as Array[Enum]
				do.research_cost = 390
				do.eureka_desc = "获得1位大科学家。"
				do.eureka_cost = 1
			Enum.MILITARY_ENGINEERING:
				do.view_name = "军事工程学"
				do.quotation = [
					"猛攻——修建——战争——美国第十六工兵旅的座右铭",
					"如果科学过多干涉战争，野战军队会需要更多工程师；战争后期，任何时候都没有足够的工兵。——伯纳德·蒙哥马利"
					] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_tech = [Enum.CONSTRUCTION] as Array[Enum]
				do.research_cost = 390
				do.eureka_desc = "建造1个水渠。"
				do.eureka_cost = 1
			Enum.STIRRUPS:
				do.view_name = "马镫"
				do.quotation = [
					"像马镫一样的简单发明很少，也没几个会像马镫那样对历史产生强大的推动作用。——林·怀特",
					"在马镫和地面之间，我祈求宽恕，我获得了宽容。——威廉·卡姆登"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_tech = [Enum.HORSEBACK_RIDING] as Array[Enum]
				do.research_cost = 390
				do.eureka_desc = "拥有封建主义市政。"
				do.eureka_cost = 1
			Enum.APPRENTICESHIP:
				do.view_name = "学徒"
				do.quotation = [
					"在工艺方面，我们都是学徒，从未出现过大师。——欧内斯特·海明威",
					"训练学徒是没有捷径的。我的方法是示范和不停的指责。——雷蒙·斯尼奇"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_tech = [Enum.CURRENCY, Enum.HORSEBACK_RIDING] as Array[Enum]
				do.research_cost = 300
				do.eureka_desc = "建造3座矿山"
				do.eureka_cost = 3
			Enum.MILITARY_TACTICS:
				do.view_name = "战术"
				do.quotation = [
					"战术意味着用你所拥有的东西做你所能做的事。——索尔·阿林斯基",
					"策略需要推理力；战术需要观察力。——马克思·尤伟"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_tech = [Enum.MATHEMATICS] as Array[Enum]
				do.research_cost = 300
				do.eureka_desc = "使用枪兵击杀1个单位。"
				do.eureka_cost = 1
			Enum.SIEGE_TACTICS:
				do.view_name = "攻城术"
				do.quotation = [
					"故上兵伐谋，其次伐交，其次伐兵，其下攻城。攻城之法为不得已。——孙子",
					"所有的罗曼史都在绽放在美好的事物之间。——迈尔斯·卡梅隆"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.CASTLES] as Array[Enum]
				do.research_cost = 660
				do.eureka_desc = "拥有2个投石机。"
				do.eureka_cost = 2
			Enum.SQUARE_RIGGING:
				do.view_name = "横帆装置"
				do.quotation = [
					"世界上某些地方人类无法靠近，但帆船却可以。——艾伦·维利耶",
					"推动船前行的并不是高耸的帆篷，而是看不见的风。——英国谚语"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.CARTOGRAPHY] as Array[Enum]
				do.research_cost = 660
				do.eureka_desc = "使用火枪手击杀1个单位。"
				do.eureka_cost = 1
			Enum.GUNPOWDER:
				do.view_name = "火药"
				do.quotation = [
					"火药的真正用途是让所有人都长高。——托马斯·卡莱尔",
					"人是一种军事动物，对火药引以为豪，并且喜欢游行。——菲利普·贝利"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.APPRENTICESHIP, Enum.STIRRUPS, Enum.MILITARY_ENGINEERING] as Array[Enum]
				do.research_cost = 540
				do.eureka_desc = "建造1个兵工厂。"
				do.eureka_cost = 1
			Enum.METAL_CASTING:
				do.view_name = "金属铸造"
				do.quotation = [
					"最先，火神赫菲斯托斯做了一个超级厉害的巨大盾牌…他在盾牌上锻造了两座宏伟城市。——荷马",
					"不要随意评判一个人，除非你经历过他所经历的。——雷克·莱尔顿"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.GUNPOWDER] as Array[Enum]
				do.research_cost = 660
				do.eureka_desc = "拥有2名弩手。"
				do.eureka_cost = 2
			Enum.MASS_PRODUCTION:
				do.view_name = "批量生产"
				do.quotation = [
					"人们可以选择任何颜色的T型车——只要它是黑的。——亨利·福特",
					"那些可以被贴上标签、包装、进行大量生产的东西既不是真理也不是艺术。——马蒂·鲁宾"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.EDUCATION, Enum.SHIPBUILDING] as Array[Enum]
				do.research_cost = 540
				do.eureka_desc = "建造1座伐木场。"
				do.eureka_cost = 1
			Enum.ASTRONOMY:
				do.view_name = "天文学"
				do.quotation = [
					"天文学吸引人们仰望上苍，引导我们了解其他世界。——柏拉图",
					"当你不是一个天文学家时，天文学更有趣。——布赖恩·梅"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.EDUCATION] as Array[Enum]
				do.research_cost = 660
				do.eureka_desc = "在邻近山岳的地方建造1所大学。"
				do.eureka_cost = 1
			Enum.BANKING:
				do.view_name = "银行业"
				do.quotation = [
					"如果你欠银行100美元，你会有麻烦。如果你欠银行1亿美元，有麻烦的是银行。——保罗·盖蒂",
					"我看到银行说它们24小时营业，但我没那么多时间去那里玩。——史蒂夫·赖特"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.EDUCATION, Enum.STIRRUPS] as Array[Enum]
				do.research_cost = 540
				do.eureka_desc = "拥有公会市政。"
				do.eureka_cost = 1
			Enum.PRINTING:
				do.view_name = "印刷术"
				do.quotation = [
					"笔没有剑重，但可能印刷机的威力比攻城器大。寥寥数语就能改变一切。——泰瑞·普莱契",
					"正如火药改变了战争的形式，印刷机也改变了思想传播的方式。——温德尔·菲利浦斯"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.MACHINERY] as Array[Enum]
				do.research_cost = 540
				do.eureka_desc = "建造2所大学。"
				do.eureka_cost = 2
			Enum.CARTOGRAPHY:
				do.view_name = "制图学"
				do.quotation = [
					"流浪者不一定都迷失了方向。——约翰·罗纳德·瑞尔·托尔金"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_tech = [Enum.SHIPBUILDING] as Array[Enum]
				do.research_cost = 540
				do.eureka_desc = "建造2个港口。"
				do.eureka_cost = 2
			Enum.BALLISTICS:
				do.view_name = "弹道学"
				do.quotation = [
					"有件事可用来推测发生了什么，但我们没有妄自揣测，直到弹道学证实了发生的一切…——约翰·汉森",
					"让我们跪下祈祷吧。我不知道该向谁祈祷。有弹道的守护神吗？——亚当·萨维奇"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_tech = [Enum.METAL_CASTING] as Array[Enum]
				do.research_cost = 845
				do.eureka_desc = "使用军事工程师在领土中建设2座堡垒。"
				do.eureka_cost = 2
			Enum.INDUSTRIALIZATION:
				do.view_name = "工业化"
				do.quotation = [
					"我认为工业革命初期，人类犯了一个错误，我们直接跨越到了机械化的东西。人们需要使用双手来感受创造力。——安德鲁·诺顿",
					"暴力经济学的关键词是城市化、工业化、集中、效率、数量、速度。——舒马赫"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_tech = [Enum.SQUARE_RIGGING, Enum.MASS_PRODUCTION] as Array[Enum]
				do.research_cost = 845
				do.eureka_desc = "建造3座工作坊。"
				do.eureka_cost = 3
			Enum.ECONOMICS:
				do.view_name = "经济"
				do.quotation = [
					"经济学这门学科不太尊重个人意愿。——尼基塔·赫鲁晓夫",
					"普通人通过马路或铁路去往各地，但经济学家沿着基础设施继续他的旅程。——玛格丽特·撒切尔"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_tech = [Enum.SCIENTIFIC_THEORY, Enum.METAL_CASTING] as Array[Enum]
				do.research_cost = 970
				do.eureka_desc = "建造2家银行。"
				do.eureka_cost = 2
			Enum.MILITARY_SCIENCE:
				do.view_name = "军事学"
				do.quotation = [
					"不管战略多美妙，偶尔看看结果如何很重要。——温斯顿·丘吉尔",
					"没人发起战争——更确切地说，没有一个有理性的人会这样做——他没想清楚通过战争获得什么，以及具体打算如何去做。——卡尔·冯·克劳塞维茨"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_tech = [Enum.SIEGE_TACTICS, Enum.PRINTING] as Array[Enum]
				do.research_cost = 845
				do.eureka_desc = "使用骑士击杀1个单位。"
				do.eureka_cost = 1
			Enum.SCIENTIFIC_THEORY:
				do.view_name = "科学理论"
				do.quotation = [
					"声称无法验证，并认定不会受这些毫无价值的反驳证据的影响，他们可能产生的价值鼓舞了我们，或让我们感到惊奇无比。——卡尔·萨根",
					"如果事实和理论不符，那么就修改事实。——阿尔伯特·爱因斯坦"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_tech = [Enum.ASTRONOMY, Enum.BANKING] as Array[Enum]
				do.research_cost = 845
				do.eureka_desc = "拥有启蒙运动市政。"
				do.eureka_cost = 1
			Enum.RIFLING:
				do.view_name = "膛线"
				do.quotation = [
					"事实胜于雄辩。——克莱格·罗伯茨",
					"只有站在客观公正的立场才能作出最准确的判断。——第二目标公司"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_tech = [Enum.BALLISTICS, Enum.MILITARY_SCIENCE] as Array[Enum]
				do.research_cost = 970
				do.eureka_desc = "建造1座硝石矿。"
				do.eureka_cost = 1
			Enum.SANITATION:
				do.view_name = "卫生设备"
				do.quotation = [
					"过去200年里，在挽救生命与改善健康状况方面，没有任何一项创新可以与此次由盖厕所而引发的卫生革命所产生的意义相提并论。——西尔维娅·伯韦尔",
					"除卫生设备、医疗、教育、葡萄酒、公共秩序、道路、淡水系统和公共卫生以外…罗马人还为我们做了什么？——约翰·克里斯"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_tech = [Enum.SCIENTIFIC_THEORY] as Array[Enum]
				do.research_cost = 970
				do.eureka_desc = "建造2个社区。"
				do.eureka_cost = 2
			Enum.STEAM_POWER:
				do.view_name = "蒸汽动力"
				do.quotation = [
					"发明蒸汽机的科学进步是否让人类受益，这是一个有争议的问题。——温斯顿·丘吉尔",
					"蒸汽机对科学的贡献远远大于科学对蒸汽机的贡献。——劳伦斯· 亨德尔森"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_tech = [Enum.INDUSTRIALIZATION] as Array[Enum]
				do.research_cost = 970
				do.eureka_desc = "建造2座造船厂。"
				do.eureka_cost = 2
			Enum.ELECTRICITY:
				do.view_name = "电力"
				do.quotation = [
					"如果没电，那我们就得借着烛光看电视。——乔治·戈布尔",
					"虽然说本杰明·富兰克林发现了电，但他也发明了计量器并赚了很多钱。——厄尔·威尔逊"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_tech = [Enum.STEAM_POWER] as Array[Enum]
				do.research_cost = 1250
				do.eureka_desc = "拥有3艘私掠船。"
				do.eureka_cost = 3
			Enum.FLIGHT:
				do.view_name = "飞行"
				do.quotation = [
					"一旦尝过飞行的滋味，便会永远仰望天空，因为你曾去过那里，并且渴望回到那里。——列奥纳多·达·芬奇",
					"如果着陆后你能安全走出机舱，那这个着陆还不错；如果第二天你还能继续使用这架飞机，那这个着陆简直棒呆啦。——查克·叶格"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_tech = [Enum.INDUSTRIALIZATION, Enum.SCIENTIFIC_THEORY] as Array[Enum]
				do.research_cost = 1140
				do.eureka_desc = "建造1个工业时代或以后的奇观。"
				do.eureka_cost = 1
			Enum.STEEL:
				do.view_name = "钢铁"
				do.quotation = [
					"最好的钢并不总是最亮的。——乔·艾伯康比",
					"有三种东西特别难以穿透：钢铁、钻石以及人的本性。——本杰明·富兰克林"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_tech = [Enum.RIFLING] as Array[Enum]
				do.research_cost = 1140
				do.eureka_desc = "建造1座煤矿、生产1艘装甲舰。"
				do.eureka_cost = 1
			Enum.CHEMISTRY:
				do.view_name = "化学"
				do.quotation = [
					"化学是物理当中令人讨厌的一部分。——彼得·瑞斯",
					"化学家通常说话不结巴。如果结巴的话会非常尴尬，因为他们有时需要说出一大串化学术语。——威廉·克鲁克斯爵士"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_tech = [Enum.SANITATION] as Array[Enum]
				do.research_cost = 1250
				do.eureka_desc = "拥有第2级同盟。"
				do.eureka_cost = 1
			Enum.REPLACEABLE_PARTS:
				do.view_name = "零件规格化"
				do.quotation = [
					"一台机器以平稳且可预见的方式运行，它的部件必须符合标准，这样才能更换。——查尔斯·艾森斯坦",
					"很多人爱惜汽车胜过爱惜自己的身体…但汽车部件是可以更换的。——帕尔默"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_tech = [Enum.ECONOMICS] as Array[Enum]
				do.research_cost = 1140
				do.eureka_desc = "拥有3个战列步兵。"
				do.eureka_cost = 3
			Enum.COMBUSTION:
				do.view_name = "内燃机"
				do.quotation = [
					"当我们还是小孩儿时，汽车没那么先进。归根结底，汽车仍然只是一台汽油内燃机。——德纳·布鲁奈蒂",
					"我一直认为用内燃机来替代马匹是人类历史进程中一件很令人沮丧的事。——温斯顿·丘吉尔"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_tech = [Enum.STEEL, Enum.RIFLING] as Array[Enum]
				do.research_cost = 1250
				do.eureka_desc = "出土1件文物。"
				do.eureka_cost = 1
			Enum.RADIO:
				do.view_name = "无线电"
				do.quotation = [
					"没有无线电的世界是聋人世界。——欧内斯特·耶博阿",
					"收音机是心灵剧院；电视是蠢人剧院。——史蒂夫·艾伦"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_tech = [Enum.STEAM_POWER, Enum.FLIGHT] as Array[Enum]
				do.research_cost = 1250
				do.eureka_desc = "建造1座国家公园。"
				do.eureka_cost = 1
			Enum.COMPUTERS:
				do.view_name = "电脑"
				do.quotation = [
					"人都会犯错，但是想真正把事情搞砸你还需要一台计算机。——保罗·埃利希",
					"电脑的优点和缺点是你让它做什么，它就做什么。——泰德·尼尔森"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_tech = [Enum.ELECTRICITY, Enum.RADIO] as Array[Enum]
				do.research_cost = 1580
				do.eureka_desc = "采用带有8个固定政策槽位的政体。"
				do.eureka_cost = 1
			Enum.ADVANCED_BALLISTICS:
				do.view_name = "高级弹道学"
				do.quotation = [
					"在理性的子弹面前，无知的勇气是没用的。——乔治·巴顿",
					"把月亮作为你的目标。如果没打中，也许还能打中星星。——克莱门特·斯通"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_tech = [Enum.REPLACEABLE_PARTS, Enum.STEEL] as Array[Enum]
				do.research_cost = 1410
				do.eureka_desc = "建造1座燃油发电厂。"
				do.eureka_cost = 1
			Enum.NUCLEAR_FISSION:
				do.view_name = "核裂变"
				do.quotation = [
					"如果你继续进行核军备竞赛，那你接下来要做的是把他们都炸成碎片。——温斯顿·丘吉尔",
					"别碰原子能。——哈伯格"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_tech = [Enum.ADVANCED_BALLISTICS, Enum.COMBINED_ARMS] as Array[Enum]
				do.research_cost = 1580
				do.eureka_desc = "通过大科学家或间谍提升。"
				do.eureka_cost = 1
			Enum.SYNTHETIC_MATERIALS:
				do.view_name = "合成材料"
				do.quotation = [
					"文化里充斥着太多的塑料，以致于含乙烯基的塑料美洲豹兽皮变成了濒临灭绝的合成物。——莉莉·汤姆林",
					"对聚酯纤维没什么好宽恕的。在这个问题上，撒旦和上帝意见一致。——乔·希尔"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_tech = [Enum.PLASTICS] as Array[Enum]
				do.research_cost = 1580
				do.eureka_desc = "建造2个航空港。"
				do.eureka_cost = 2
			Enum.ROCKETRY:
				do.view_name = "火箭研究"
				do.quotation = [
					"科学火箭神话被编成了神话，这和它真正的困难不相称。——约翰·卡马克",
					"当你发射一枚火箭，你并不是真正让火箭自己飞行。它的一切都在你的掌控中。——迈克尔·安德森"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_tech = [Enum.RADIO, Enum.CHEMISTRY] as Array[Enum]
				do.research_cost = 1410
				do.eureka_desc = "通过大科学家或间谍提升。"
				do.eureka_cost = 1
			Enum.COMBINED_ARMS:
				do.view_name = "联合作战"
				do.quotation = [
					"有意义的战斗胜过无意义的生活。——乔治·史密斯·巴顿",
					"战争中最不可估量的东西是人的意志力。——李德·哈特"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_tech = [Enum.STEEL, Enum.COMBUSTION] as Array[Enum]
				do.research_cost = 1410
				do.eureka_desc = "拥有3支军队或无敌舰队"
				do.eureka_cost = 3
			Enum.PLASTICS:
				do.view_name = "塑料"
				do.quotation = [
					"在主要可塑性物质的层级结构里，塑料制品是一种不受待见的材料，它消失在橡胶的热情洋溢和金属的平坦坚硬之中。——罗兰·巴特",
					"这世间没有什么是永恒的。除了塑料。——帕特丽夏·邓恩"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_tech = [Enum.COMBUSTION] as Array[Enum]
				do.research_cost = 1410
				do.eureka_desc = "建造1口油井。"
				do.eureka_cost = 3
			Enum.ADVANCED_FLIGHT:
				do.view_name = "现代航空"
				do.quotation = [
					"飞机确实又快又实惠，不过一味追求效率，我们得失去多少快乐，牺牲多少休闲时光啊。——金吉·罗杰斯",
					"假如老天有意让人飞行，它将让人更加安逸的抵达机场。——乔治·温特斯"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_tech = [Enum.RADIO] as Array[Enum]
				do.research_cost = 1410
				do.eureka_desc = "建造3架双翼机。"
				do.eureka_cost = 3
			Enum.COMPOSITES:
				do.view_name = "复合材料"
				do.quotation = [
					"所有物质事物看起来都是由硬粒子和固相颗粒组成…在很多方面，都和智能主体决策创造的第一个产物联系在一起。——艾萨克·牛顿",
					"很明显，科学正努力把天堂带到地球，而人类正使用各种物质来建造地狱。——赫伯特·胡佛"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.SYNTHETIC_MATERIALS] as Array[Enum]
				do.research_cost = 1850
				do.eureka_desc = "拥有3辆坦克。"
				do.eureka_cost = 3
			Enum.NUCLEAR_FUSION:
				do.view_name = "核聚变"
				do.quotation = [
					"我支持从15亿千米远的地方来控制核聚变能量。通过太阳进行的核聚变非常不错，而且是免费的。地球上的反应堆…没有那么多。——乔·罗姆",
					"当夜晚抬头仰望星星时，因为遥远的核聚变，所以看到的一切都那么闪亮。——卡尔·萨根"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.LASERS] as Array[Enum]
				do.research_cost = 2155
				do.eureka_desc = "通过大科学家或间谍提升。"
				do.eureka_cost = 1
			Enum.ROBOTICS:
				do.view_name = "机器人技术"
				do.quotation = [
					"机器人技术永远存在，它永远都是下一件大事，这项技术如此让人兴奋，如此扣人心弦，以至于很容易得意忘形。——科林·安格尔",
					"I'll be back."
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.COMPUTERS] as Array[Enum]
				do.research_cost = 2155
				do.eureka_desc = "开启全球化市政。"
				do.eureka_cost = 1
			Enum.LASERS:
				do.view_name = "激光"
				do.quotation = [
					"当上帝说让光芒普照大地时，他的意思肯定是指完美的相干光线。——查尔斯·汤斯",
					"我是一个超级激光信徒——我相信它们肯定是未来潮流。——柯特妮·考克斯"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.NUCLEAR_FISSION] as Array[Enum]
				do.research_cost = 1850
				do.eureka_desc = "通过大科学家或间谍提升。"
				do.eureka_cost = 1
			Enum.NANOTECHNOLOGY:
				do.view_name = "纳米技术"
				do.quotation = [
					"如果科技能推动变革，那么纳米科技是人类未来的推动力。——娜塔莎·维塔莫尔",
					"很多规则在纳米技术面前低下了头…由此产生了很多好处，当然也有很多坏处。——马特·斯皮尔"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.COMPOSITES] as Array[Enum]
				do.research_cost = 2155
				do.eureka_desc = "建造1座铝矿。"
				do.eureka_cost = 1
			Enum.FUTURE_TECH:
				do.view_name = "未来科技"
				do.quotation = [
					"没有什么比梦想更能创造未来。——维克多·雨果",
					"虽然未来似乎很遥远，但其实已经开始了。——马提·史提潘尼克"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.SATELLITES, Enum.ROBOTICS, Enum.NANOTECHNOLOGY, Enum.NUCLEAR_FUSION] as Array[Enum]
				do.research_cost = 2500
			Enum.SATELLITES:
				do.view_name = "卫星"
				do.quotation = [
					"卫星没有意识。——爱德华·默罗",
					"现在世界各地有31颗卫星在快速移动，除了帮你找到如何去杂货店以外，也没其他用处了。——伯内特"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.ADVANCED_FLIGHT, Enum.ROCKETRY] as Array[Enum]
				do.research_cost = 1850
				do.eureka_desc = "通过大科学家或间谍提升。"
				do.eureka_cost = 1
			Enum.STEALTH_TECHNOLOGY:
				do.view_name = "隐形技术"
				do.quotation = [
					"我想说的是隐形是一种有趣的能力，你可以穿过世界看看它到底是什么样子，而没人能看到你。——凯文·贝肯",
					"在艺术和梦想中，也许你继续放纵；在生命里，也许你依旧在平衡和蛰伏。——帕蒂·史密斯"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.SYNTHETIC_MATERIALS] as Array[Enum]
				do.research_cost = 1850
				do.eureka_desc = "通过大科学家或间谍提升。"
				do.eureka_cost = 1
			Enum.TELECOMMUNICATIONS:
				do.view_name = "远程通信"
				do.quotation = [
					"沃森先生…过来一下…我想见你。——亚历山大·格雷厄姆·贝尔",
					"沟通的最大问题是会产生错觉。——乔治·萧伯纳"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.COMPUTERS] as Array[Enum]
				do.research_cost = 1850
				do.eureka_desc = "建造2个广播中心。"
				do.eureka_cost = 2
			Enum.GUIDANCE_SYSTEMS:
				do.view_name = "制导系统"
				do.quotation = [
					"生大材，不遇其时，其势定衰。生平庸，不化其势，其性定弱。——老子",
					"我喜欢看我妈在回家路上同导航仪争论。——伊莎贝拉·弗尔曼"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_tech = [Enum.ROCKETRY, Enum.ADVANCED_BALLISTICS] as Array[Enum]
				do.research_cost = 1850
				do.eureka_desc = "击毁1架战斗机。"
				do.eureka_cost = 1
		super.init_insert(do)

