class_name CivicTable
extends MySimSQL.EnumTable


enum Enum {
	# 远古时代
	EARLY_EMPIRE, # 帝国初期
	FOREIGN_TRADE, # 对外贸易
	CODE_OF_LAWS, # 法典
	STATE_WORKFORCE, # 国家劳动力
	CRAFTSMANSHIP, # 技艺
	MILITARY_TRADITION, # 军事传统
	MYSTICISM, # 神秘主义
	# 古典时期
	DEFENSIVE_TACTICS, # 防御战术
	MILITARY_TRAINING, # 军事训练
	RECORDED_HISTORY, # 历史记录
	THEOLOGY, # 神学
	DRAMA_POETRY, # 戏剧和诗歌
	GAMES_RECREATION, # 游戏和娱乐
	POLITICAL_PHILOSOPHY, # 政治哲学
	# 中世纪
	FEUDALISM, # 封建主义
	GUILDS, # 公会
	MERCENARIES, # 雇佣兵
	NAVAL_TRADITION, # 海军传统
	DIVINE_RIGHT, # 王权神授
	CIVIL_SERVICE, # 行政部门
	MEDIEVAL_FAIRES, # 中世纪集市
	# 文艺复兴时期
	REFORMED_CHURCH, # 归正会
	ENLIGHTENMENT, # 启蒙运动
	HUMANISM, # 人文主义
	EXPLORATION, # 探索
	DIPLOMATIC_SERVICE, # 外交部门
	MERCANTILISM, # 重商主义
	# 工业时代
	URBANIZATION, # 城市化
	OPERA_BALLET, # 歌剧和芭蕾
	SCORCHED_EARTH, # 焦土策略
	NATIONALISM, # 民族主义
	CIVIL_ENGINEERING, # 土木工程
	COLONIALISM, # 殖民主义
	NATURAL_HISTORY, # 自然历史
	# 现代
	CONSERVATION, # 保护地球
	MASS_MEDIA, # 大众媒体
	MOBILIZATION, # 动员
	NUCLEAR_PROGRAM, # 核计划
	TOTALITARIANISM, # 极权主义
	CLASS_STRUGGLE, # 阶级斗争
	SUFFRAGE, # 选举权
	IDEOLOGY, # 意识形态
	CAPITALISM, # 资本主义
	# 原子能时代
	RAPID_DEPLOYMENT, # 紧急部署
	COLD_WAR, # 冷战
	SPACE_RACE, # 太空竞赛
	CULTURAL_HERITAGE, # 文化遗产
	PROFESSIONAL_SPORTS, # 职业体育
	# 信息时代
	GLOBALIZATION, # 全球化
	SOCIAL_MEDIA, # 社交媒体
	FUTURE_CIVIC, # 未来市政
}


func _init() -> void:
	super._init()
	elem_type = CivicDO
	
	for k in Enum.keys():
		var do = CivicDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.EARLY_EMPIRE:
				do.view_name = "帝国初期"
				do.quotation = [
					"回顾过去，随着不断变换的帝国起起伏伏，你也能预见未来。——马可·奥里利乌斯",
					"像空调这样的奢侈品摧毁了罗马帝国。因为有空调，所以他们紧闭窗户；他们无法听到蛮族的到来。——加里森·凯勒"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_civics = [Enum.FOREIGN_TRADE] as Array[Enum]
				do.culture_cost = 70
				do.inspire_desc = "文明人口至少达到6。"
				do.inspire_cost = 6
			Enum.FOREIGN_TRADE:
				do.view_name = "对外贸易"
				do.quotation = [
					"每个国家都以交换为生。——亚当·斯密",
					"我认为这是贸易的积极方面。整个世界都被搅和在一起。——伊莎贝尔·霍温"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_civics = [Enum.CODE_OF_LAWS] as Array[Enum]
				do.culture_cost = 40
				do.inspire_desc = "发现1个新大陆。"
				do.inspire_cost = 1
			Enum.CODE_OF_LAWS:
				do.view_name = "法典"
				do.quotation = [
					"不是智慧，而是权力制定了法律。——托马斯·霍布斯",
					"人在状态最好时，是最高贵的动物；但如果违背法律和正义，他会变成最恶劣的动物。——亚里士多德"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.culture_cost = 20
			Enum.STATE_WORKFORCE:
				do.view_name = "国家劳动力"
				do.quotation = [
					"强大的经济始于强壮的、受过良好教育的劳动力。——比尔·欧文斯",
					"同样重要的是要有一个又快乐又努力工作的劳动力，这是赚钱的底线。——弗恩·杜希"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_civics = [Enum.CRAFTSMANSHIP] as Array[Enum]
				do.culture_cost = 70
				do.inspire_desc = "建造任意特色区域。"
				do.inspire_cost = 1
			Enum.CRAFTSMANSHIP:
				do.view_name = "技艺"
				do.quotation = [
					"没有技艺，灵感不过是风中摇曳的芦苇。——约翰内斯·勃拉姆斯",
					"缺乏想象力的技能是一门手艺，为我们提供了许多有用的东西，比如柳条编制的野餐篮。——汤姆·斯托帕德"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_civics = [Enum.CODE_OF_LAWS] as Array[Enum]
				do.culture_cost = 40
				do.inspire_desc = "改良3个单元格。"
				do.inspire_cost = 3
			Enum.MILITARY_TRADITION:
				do.view_name = "军事传统"
				do.quotation = [
					"所谓勇者，是把恐惧埋在自己心底。——上校大卫·哈克沃斯",
					"我不会低估军事理论的价值，但如果让军人在战争中盲目地服从命令，那他们必败无疑。——尤利西斯·辛普森·格兰特"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_civics = [Enum.CRAFTSMANSHIP] as Array[Enum]
				do.culture_cost = 50
				do.inspire_desc = "清除蛮族哨站。"
				do.inspire_cost = 1
			Enum.MYSTICISM:
				do.view_name = "神秘主义"
				do.quotation = [
					"神秘主义是宇宙一体论的偶然错误和个别性象征。——拉尔夫·瓦尔多·爱默生",
					"我想说我实践了各种激进的神秘主义。我非常确定这里面的有些事我不太懂。——罗布·贝尔"
				] as Array[String]
				do.era = EraTable.Enum.ANCIENT
				do.required_civics = [Enum.FOREIGN_TRADE] as Array[Enum]
				do.culture_cost = 50
				do.inspire_desc = "建立万神殿。"
				do.inspire_cost = 1
			Enum.DEFENSIVE_TACTICS:
				do.view_name = "防御战术"
				do.quotation = [
					"无坚不摧在于防御；而进攻才有获胜的可能。——孙子",
					"防御优于财富。——亚当·斯密"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_civics = [Enum.GAMES_RECREATION, Enum.POLITICAL_PHILOSOPHY] as Array[Enum]
				do.culture_cost = 175
				do.inspire_desc = "成为被宣战的目标。"
				do.inspire_cost = 1
			Enum.MILITARY_TRAINING:
				do.view_name = "军事训练"
				do.quotation = [
					"如果杀人是天性，那为何人们需要学习如何杀人呢？——琼·贝兹",
					"别人吵架爱插嘴，一定鼻子常流血。——约翰·盖伊"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_civics = [Enum.MILITARY_TRADITION, Enum.GAMES_RECREATION] as Array[Enum]
				do.culture_cost = 120
				do.inspire_desc = "建造1个军营。"
				do.inspire_cost = 1
			Enum.RECORDED_HISTORY:
				do.view_name = "历史记录"
				do.quotation = [
					"我经历过一些可怕的事，有些的确发生过。——马克·吐温",
					"历史是人们对往事一致认定的说法。——拿破仑·波拿巴"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_civics = [Enum.POLITICAL_PHILOSOPHY, Enum.DRAMA_POETRY] as Array[Enum]
				do.culture_cost = 175
				do.inspire_desc = "建造2个学院区域。"
				do.inspire_cost = 2
			Enum.THEOLOGY:
				do.view_name = "神学"
				do.quotation = [
					"没有神学理论体系的宗教思维不比没有数学运算的测定法和天文学，或没有化学应用的炼铁更高深。——约翰·霍尔",
					"人类受苦是因为他们把众神作为娱乐创造的东西看的太认真了。——艾伦·瓦茨"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_civics = [Enum.DRAMA_POETRY, Enum.MYSTICISM] as Array[Enum]
				do.culture_cost = 120
				do.inspire_desc = "创立1个宗教。"
				do.inspire_cost = 1
			Enum.DRAMA_POETRY:
				do.view_name = "戏剧和诗歌"
				do.quotation = [
					"在关于小人的话题上，诗人们神秘地保持沉默。——切斯特顿",
					"世界是个大舞台，所有男男女女不过是舞台上的演员而已。——威廉·莎士比亚"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_civics = [Enum.EARLY_EMPIRE] as Array[Enum]
				do.culture_cost = 110
				do.inspire_desc = "建造1个奇观。"
				do.inspire_cost = 1
			Enum.GAMES_RECREATION:
				do.view_name = "游戏和娱乐"
				do.quotation = [
					"在满足了物质需求后，人们会注重精神需求。——爱德华·贝拉米",
					"没有时间娱乐的人，迟早得有时间生病。——约翰·沃纳梅克"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_civics = [Enum.STATE_WORKFORCE] as Array[Enum]
				do.culture_cost = 110
				do.inspire_desc = "研究建造科技。"
				do.inspire_cost = 1
			Enum.POLITICAL_PHILOSOPHY:
				do.view_name = "政治哲学"
				do.quotation = [
					"政治是可能性艺术，可成为下一个最好的艺术。——奥托·冯·俾斯麦",
					"分而治之，这是至理名言。合而御之，却更显明智。——约翰·沃尔夫冈·冯·歌德"
				] as Array[String]
				do.era = EraTable.Enum.CLASSICAL
				do.required_civics = [Enum.STATE_WORKFORCE, Enum.EARLY_EMPIRE] as Array[Enum]
				do.culture_cost = 110
				do.inspire_desc = "会晤3个城邦。"
				do.inspire_cost = 3
			Enum.FEUDALISM:
				do.view_name = "封建主义"
				do.quotation = [
					"在民主国家，你的投票很重要。在封建国家，你的地位很重要。——莫根斯·加尔贝格",
					"封建主义进步促使铁盔甲不断得到改进，直到最后出现了像犰狳一样的斗士。——约翰·博伊尔·奥莱利"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_civics = [Enum.DEFENSIVE_TACTICS] as Array[Enum]
				do.culture_cost = 275
				do.inspire_desc = "建造6个农场。"
				do.inspire_cost = 6
			Enum.GUILDS:
				do.view_name = "公会"
				do.quotation = [
					"每个人都应该让他的儿子多学习有用的商业或专业知识，这样将来才能改变命运…他们才能依靠自己的有形资产生存下来。——费尼斯·巴纳姆",
					"你不能去逮捕盗贼工会。我的意思是，我们已经忙了一整天了。——泰瑞·普莱契"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_civics = [Enum.FEUDALISM, Enum.CIVIL_SERVICE] as Array[Enum]
				do.culture_cost = 385
				do.inspire_desc = "建造2个市场。"
				do.inspire_cost = 2
			Enum.MERCENARIES:
				do.view_name = "雇佣兵"
				do.quotation = [
					"和平时期，老百姓受到雇佣兵掠夺；战争时期，受到敌人掠夺。——尼可罗·马基亚维利",
					"然而，作为一个雇佣兵…嘿，我们只是去到那些既有钱又有麻烦的地方。——霍华德·泰勒"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_civics = [Enum.MILITARY_TRAINING, Enum.FEUDALISM] as Array[Enum]
				do.culture_cost = 290
				do.inspire_desc = "您的军队有8个陆地战斗单位。"
				do.inspire_cost = 8
			Enum.NAVAL_TRADITION:
				do.view_name = "海军传统"
				do.quotation = [
					"对战争来讲，好的海军部队不是一种挑衅。它是和平的可靠保证。——西奥多·罗斯福",
					"海军是传统和未来相结合的产物——在这两方面，我们都充满自豪和信心。——阿利·伯克"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_civics = [Enum.DEFENSIVE_TACTICS] as Array[Enum]
				do.culture_cost = 200
				do.inspire_desc = "使用四段帆船击杀1个单位。"
				do.inspire_cost = 1
			Enum.DIVINE_RIGHT:
				do.view_name = "王权神授"
				do.quotation = [
					"我用随后这条神学原理推断出的这一点涉及到了王权，质疑上帝可以做的事是亵渎神明…所以质疑国王可以做的事则是在煽动叛乱。——詹姆斯一世",
					"听着，在池塘里的奇怪妇女分发刺刀，这是毫无政策依据的…你不能因为某个水中的放荡女子给你把刀就谋权篡位。——巨蟒剧团"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_civics = [Enum.CIVIL_SERVICE, Enum.THEOLOGY] as Array[Enum]
				do.culture_cost = 290
				do.inspire_desc = "建造2座寺庙。"
				do.inspire_cost = 2
			Enum.CIVIL_SERVICE:
				do.view_name = "行政部门"
				do.quotation = [
					"全是一些文件和表单，整个行政部门就像是用文件、表格和繁文缛节构成的堡垒。——亚历山大·奥斯妥夫斯基",
					"纳税者是为政府工作的人，但不需要参加公务员考试。——罗纳德·里根"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_civics = [Enum.DEFENSIVE_TACTICS, Enum.RECORDED_HISTORY] as Array[Enum]
				do.culture_cost = 275
				do.inspire_desc = "一个城市的人口增长到10。"
				do.inspire_cost = 10
			Enum.MEDIEVAL_FAIRES:
				do.view_name = "中世纪集市"
				do.quotation = [
					"发光的不一定都是金子；你常常会听到大家这样说。——威廉·莎士比亚",
					"有一些非常诚实的人，他们认为自己不需要讨价还价，直到某一天，他们被商人给骗了。——阿纳托尔·法郎士"
				] as Array[String]
				do.era = EraTable.Enum.MEDIEVAL
				do.required_civics = [Enum.FEUDALISM] as Array[Enum]
				do.culture_cost = 385
				do.inspire_desc = "经营4条贸易线。"
				do.inspire_cost = 4
			Enum.REFORMED_CHURCH:
				do.view_name = "归正会"
				do.quotation = [
					"我不想把自己交托给天堂和地狱，你看，我有朋友在这两个地方。——马克·吐温",
					"现代文明的三大要素：火药、印刷术、新教。——托马斯·卡莱尔"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_civics = [Enum.GUILDS, Enum.DIVINE_RIGHT] as Array[Enum]
				do.culture_cost = 400
				do.inspire_desc = "使6座城市信奉您的宗教。"
				do.inspire_cost = 6
			Enum.ENLIGHTENMENT:
				do.view_name = "启蒙运动"
				do.quotation = [
					"新观念总是遭到怀疑和反对，没有别的原因，只是因为人们习惯于旧的东西。—— 约翰·洛克",
					"任何违反自然的东西都是违反理智的，任何和理智相悖的东西都是荒诞可笑的。——巴鲁赫·斯宾诺莎"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_civics = [Enum.HUMANISM, Enum.DIPLOMATIC_SERVICE] as Array[Enum]
				do.culture_cost = 655
				do.inspire_desc = "获得3个伟人。"
				do.inspire_cost = 3
			Enum.HUMANISM:
				do.view_name = "人文主义"
				do.quotation = [
					"人文主义的四大特点是：好奇心、自由思想、相信好品味、相信人类。——E·M·福斯特",
					"不可对人性失去信心。人性就像大海；虽然海洋中会有几滴水是脏的，但大海不会变脏。——圣雄甘地"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_civics = [Enum.MEDIEVAL_FAIRES, Enum.GUILDS] as Array[Enum]
				do.culture_cost = 540
				do.inspire_desc = "获得1位大艺术家。"
				do.inspire_cost = 1
			Enum.EXPLORATION:
				do.view_name = "探索"
				do.quotation = [
					"一旦停止探索，我们将生活在一个停滞不前的世界，缺乏好奇心，没有梦想。——奈尔·德葛拉司·泰森",
					"我们不应停止探索，在所有探索的尽头，我们会回到起点，重新认识这个地方。——艾略特"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_civics = [Enum.MERCENARIES, Enum.MEDIEVAL_FAIRES] as Array[Enum]
				do.culture_cost = 400
				do.inspire_desc = "建造2艘轻快帆船。"
				do.inspire_cost = 2
			Enum.DIPLOMATIC_SERVICE:
				do.view_name = "外交部门"
				do.quotation = [
					"外交领域有两个问题：小问题和大问题。小问题自己会消失，大问题你无可奈何。——帕特里克·麦基尼斯",
					"外交官只记得女人的生日而不记得她的年龄。——罗伯特·弗罗斯特"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_civics = [Enum.GUILDS] as Array[Enum]
				do.culture_cost = 540
				do.inspire_desc = "与另一个文明国家结盟。"
				do.inspire_cost = 1
			Enum.MERCANTILISM:
				do.view_name = "重商主义"
				do.quotation = [
					"但是在市场经济条件下，个人可能会逃脱国家的管束。——彼得·伯格",
					"在见识了非市场经济后，我突然更明白了我喜欢市场经济的哪些方面。——艾瑟·戴森"
				] as Array[String]
				do.era = EraTable.Enum.RENAISSANCE
				do.required_civics = [Enum.HUMANISM] as Array[Enum]
				do.culture_cost = 655
				do.inspire_desc = "获得1个大商人。"
				do.inspire_cost = 1
			Enum.URBANIZATION:
				do.view_name = "城市化"
				do.quotation = [
					"工业革命和城市规模的增长让人感到渺小。——温特·瑟夫",
					"我喜欢城市里所有的东西都很巨大，一切的美丽和丑陋。——约瑟夫·布罗茨基"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_civics = [Enum.CIVIL_ENGINEERING, Enum.NATIONALISM] as Array[Enum]
				do.culture_cost = 1060
				do.inspire_desc = "一座城市的人口增长到15。"
				do.inspire_cost = 15
			Enum.OPERA_BALLET:
				do.view_name = "歌剧和芭蕾"
				do.quotation = [
					"歌剧是，当一个人背后被捅了一刀，他不流血，他唱歌剧。——罗伯特·本奇利",
					"芭蕾表达出一种脆弱的力量和一种不会改变的精致。——艾茵·兰德"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_civics = [Enum.ENLIGHTENMENT] as Array[Enum]
				do.culture_cost = 725
				do.inspire_desc = "建造1座艺术博物馆。"
				do.inspire_cost = 1
			Enum.SCORCHED_EARTH:
				do.view_name = "焦土策略"
				do.quotation = [
					"战争就是地狱。——威廉·特库姆塞·谢尔曼",
					"我只懂友谊或焦土策略。——罗杰·艾尔斯"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_civics = [Enum.NATIONALISM] as Array[Enum]
				do.culture_cost = 1060
				do.inspire_desc = "建造2个野战加农炮。"
				do.inspire_cost = 2
			Enum.NATIONALISM:
				do.view_name = "民族主义"
				do.quotation = [
					"民族主义促使国家产生，而不是国家产生了民族主义。——欧内斯特·葛尔纳",
					"人类在部落主义和民族主义中表现出的天性证明了人类进化的机械动力。——阿瑟·基思"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_civics = [Enum.ENLIGHTENMENT] as Array[Enum]
				do.culture_cost = 920
				do.inspire_desc = "使用1个战争借口宣战。"
				do.inspire_cost = 1
			Enum.CIVIL_ENGINEERING:
				do.view_name = "土木工程"
				do.quotation = [
					"改造使弯路变得笔直；但未经改造的弯路才是成就天才之路。——威廉·布雷克",
					"人们设计傻瓜式设备时，最常见的一个错误是低估了大傻瓜的独创性。——道格拉斯·亚当斯"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_civics = [Enum.MERCANTILISM] as Array[Enum]
				do.culture_cost = 920
				do.inspire_desc = "建造7个不同的特色区域。"
				do.inspire_cost = 7
			Enum.COLONIALISM:
				do.view_name = "殖民主义"
				do.quotation = [
					"记住：政治、殖民主义、帝国主义和战争都源于人类的大脑。——维莱亚努尔·拉马钱德兰",
					"殖民主义。合理原则的强制传播。但，是谁将它传播给殖民者的呢？——安东尼·伯吉斯"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_civics = [Enum.MERCANTILISM] as Array[Enum]
				do.culture_cost = 725
				do.inspire_desc = "研究天文学科技。"
				do.inspire_cost = 1
			Enum.NATURAL_HISTORY:
				do.view_name = "自然历史"
				do.quotation = [
					"如果我参与造物，我会提出一些有用的建议使宇宙秩序更加和谐。——纳尔逊·艾格林",
					"在所有自然历史著作中，我们不断发现关于动物对食物、习性以及它们生活场所不可思议的适应性的详细记载。——阿尔弗雷德·华莱士"
				] as Array[String]
				do.era = EraTable.Enum.INDUSTRIAL
				do.required_civics = [Enum.COLONIALISM] as Array[Enum]
				do.culture_cost = 870
				do.inspire_desc = "建造1座考古博物馆。"
				do.inspire_cost = 1
			Enum.CONSERVATION:
				do.view_name = "保护地球"
				do.quotation = [
					"水和空气这两样生活必须品已变成全球垃圾桶了。——雅克·伊夫·库斯托",
					"为了经济利益破坏雨林就像燃烧一幅文艺复兴时期的绘画来烹制美食一样。——爱德华•威尔逊"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.NATURAL_HISTORY] as Array[Enum]
				do.culture_cost = 1255
				do.inspire_desc = "建造1个惊艳的社区。"
				do.inspire_cost = 1
			Enum.MASS_MEDIA:
				do.view_name = "大众媒体"
				do.quotation = [
					"大众媒体的作用并不是让你产生信仰，而是让你保持对政党组织的兴趣。——克里斯托弗·拉什",
					"如果你不看报纸，你会很无知。如果你看报纸，你会被误导。——马克·吐温"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.NATURAL_HISTORY, Enum.URBANIZATION] as Array[Enum]
				do.culture_cost = 1410
				do.inspire_desc = "研究无线电。"
				do.inspire_cost = 1
			Enum.MOBILIZATION:
				do.view_name = "动员"
				do.quotation = [
					"当他们为战争做准备时，那些最有发言权的人大量发表和平宣言，直到完成整个动员过程。——斯蒂芬·茨威格",
					"为了团结人民，政府需要敌人…如果没有真正的敌人，他们会造一个，以此让大家动员起来。——一行禅师"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.URBANIZATION] as Array[Enum]
				do.culture_cost = 1410
				do.inspire_desc = "您的军队里有3支军团。"
				do.inspire_cost = 1
			Enum.NUCLEAR_PROGRAM:
				do.view_name = "核计划"
				do.quotation = [
					"原子能的释放，改变了除人类思考模式之外的一切…解决这个问题在于人心。早知道我就当个钟表匠了。——阿尔伯特·爱因斯坦",
					"我认为生活在核时代的孩子，他们爱的能力被削弱了。当你振作精神面对这种影响时，努力去爱吧。——马丁·艾米斯"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.IDEOLOGY] as Array[Enum]
				do.culture_cost = 1715
				do.inspire_desc = "建造1个研究实验室。"
				do.inspire_cost = 1
			Enum.TOTALITARIANISM:
				do.view_name = "极权主义"
				do.quotation = [
					"只有暴徒和精英会被极权主义本身的势头所吸引。依靠宣传才能获取民心。——汉娜•阿伦特",
					"任何意识形态的终极目的都是极权主义。——汤姆·罗宾斯"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.IDEOLOGY] as Array[Enum]
				do.culture_cost = 1715
				do.inspire_desc = "建造3座军事院校。"
				do.inspire_cost = 3
			Enum.CLASS_STRUGGLE:
				do.view_name = "阶级斗争"
				do.quotation = [
					"这就是阶级斗争，好吧，但我所处的阶级是富人阶级，它发动了战争…我们会取得胜利。——沃伦·巴菲特",
					"阶级斗争必然导致无产阶级专政。——卡尔·马克思"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.IDEOLOGY] as Array[Enum]
				do.culture_cost = 1715
				do.inspire_desc = "建造3座工厂。"
				do.inspire_cost = 3
			Enum.SUFFRAGE:
				do.view_name = "选举权"
				do.quotation = [
					"为什么对女性区别对待？妇女参政会成功，别在乎这些可怜的游击队性质的反对派。——维多利亚·伍德胡尔",
					"男人的权力不能再多；女人的权力不能再少！——苏珊·安东尼"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.IDEOLOGY] as Array[Enum]
				do.culture_cost = 1715
				do.inspire_desc = "建造4个下水道。"
				do.inspire_cost = 4
			Enum.IDEOLOGY:
				do.view_name = "意识形态"
				do.quotation = [
					"它表明没有一种系统，即使最不人道的，可以离开意识形态而继续存在。——乔·斯洛沃",
					"慢慢地，思想导致意识形态，从而导致决策，最后导致行动。——南丹·尼勒卡尼"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.MASS_MEDIA, Enum.MOBILIZATION] as Array[Enum]
				do.culture_cost = 660
			Enum.CAPITALISM:
				do.view_name = "资本主义"
				do.quotation = [
					"资本主义的固有邪恶是幸福的不平等分享；社会主义的固有邪恶是痛苦的平等分享。——温斯顿·丘吉尔",
					"“总想离财富近一点，如果你足够努力，财富可能主动来找你。”——达蒙·朗伊恩"
				] as Array[String]
				do.era = EraTable.Enum.MODERN
				do.required_civics = [Enum.MASS_MEDIA] as Array[Enum]
				do.culture_cost = 1560
				do.inspire_desc = "建造3家证券交易所。"
				do.inspire_cost = 3
			Enum.RAPID_DEPLOYMENT:
				do.view_name = "紧急部署"
				do.quotation = [
					"立即认真执行一项好计划远比下周执行一项完美计划好。——乔治·史密斯·巴顿",
					"别管是不是在演习，冲向他们。——霍雷肖·纳尔逊"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_civics = [Enum.COLD_WAR] as Array[Enum]
				do.culture_cost = 2415
				do.inspire_desc = "在海外领土上建造1座航空港或1条飞机跑道。"
				do.inspire_cost = 1
			Enum.COLD_WAR:
				do.view_name = "冷战"
				do.quotation = [
					"从波罗的海的斯德丁到亚得里亚海的德里雅斯特，一幅横贯欧洲大陆的铁幕已经拉下。——温斯顿·丘吉尔",
					"冷战不会融化；它在致命的高温下尽情燃烧。——理查德·尼克松"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_civics = [Enum.IDEOLOGY] as Array[Enum]
				do.culture_cost = 2185
				do.inspire_desc = "研究核裂变科技。"
				do.inspire_cost = 1
			Enum.SPACE_RACE:
				do.view_name = "太空竞赛"
				do.quotation = [
					"我们选择在这个十年飞向月球，并做些其他的事，不是因为它们容易，而是因为它们很难。——约翰·肯尼迪",
					"美国宇航局花了上百万美元来研发可以在太空使用的圆珠笔。俄罗斯人带了支铅笔。——威尔·沙博"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_civics = [Enum.COLD_WAR] as Array[Enum]
				do.culture_cost = 2415
				do.inspire_desc = "建造1个宇航中心区。"
				do.inspire_cost = 1
			Enum.CULTURAL_HERITAGE:
				do.view_name = "文化遗产"
				do.quotation = [
					"一个对历史、起源和文化不了解的人，就好比没有根的大树。——马库斯·加维",
					"你不是偶然发现文化遗产的。它们就在那里，等待着你去探寻和分享。——罗比·罗伯森"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_civics = [Enum.CONSERVATION] as Array[Enum]
				do.culture_cost = 1955
				do.inspire_desc = "有1个主题建筑。"
				do.inspire_cost = 1
			Enum.PROFESSIONAL_SPORTS:
				do.view_name = "职业体育"
				do.quotation = [
					"如果输赢不代表一切，那为什么还要在比赛中记分呢？——文斯·隆巴迪",
					"竞技体育不能塑造人的性格。但能体现人的性格。——海伍德·布朗"
				] as Array[String]
				do.era = EraTable.Enum.ATOMIC
				do.required_civics = [Enum.IDEOLOGY] as Array[Enum]
				do.culture_cost = 2185
				do.inspire_desc = "建造4个娱乐中心。"
				do.inspire_cost = 4
			Enum.GLOBALIZATION:
				do.view_name = "全球化"
				do.quotation = [
					"据说，反对全球化就像反对万有引力定律。——科菲·安南",
					"总有一天会没有边界、没有界限、没有国旗、没有国家，人心将成为唯一的通行证。——卡洛斯·桑塔纳"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_civics = [Enum.RAPID_DEPLOYMENT, Enum.SPACE_RACE] as Array[Enum]
				do.culture_cost = 2880
				do.inspire_desc = "建造3个机场。"
				do.inspire_cost = 3
			Enum.SOCIAL_MEDIA:
				do.view_name = "社交媒体"
				do.quotation = [
					"在我所有重要的毫无意义的事里面，我应该先告诉你哪一件呢？——简·奥斯汀",
					"被一件接一件恼人的事儿打断。——艾略特"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_civics = [Enum.SPACE_RACE, Enum.PROFESSIONAL_SPORTS] as Array[Enum]
				do.culture_cost = 2880
				do.inspire_desc = "研究远程通信科技。"
				do.inspire_cost = 1
			Enum.FUTURE_CIVIC:
				do.view_name = "未来市政"
				do.quotation = [
					"绝不能根据过去而规划未来。——埃德蒙·伯克",
					"我从不思考未来。因为它迟早会来的。——阿尔伯特·爱因斯坦"
				] as Array[String]
				do.era = EraTable.Enum.INFOMATION
				do.required_civics = [Enum.GLOBALIZATION, Enum.SOCIAL_MEDIA] as Array[Enum]
				do.culture_cost = 3200
		super.init_insert(do)

