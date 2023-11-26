class_name WonderTable
extends MySimSQL.EnumTable


enum Enum {
	ALHAMBRA, # 阿尔罕布拉宫
	APADANA, # 阿帕达纳宫
	EIFFEL_TOWER, # 埃菲尔铁塔
	ETEMENANKI, # 埃特曼安吉神庙
	HERMITAGE, # 艾尔米塔什博物馆
	BROADWAY, # 百老汇
	TORRE_DE_BELEM, # 贝伦塔
	TERRACOTTA_ARMY, # 兵马俑
	JEBEL_BARKAL, # 博尔戈尔山
	POTALA_PALACE, # 布达拉宫
	BIG_BEN, # 大本钟
	GREAT_LIGHTHOUSE, # 大灯塔
	GREAT_ZIMBABWE, # 大津巴布韦
	GREAT_LIBRARY, # 大图书馆
	PYRAMIDS, # 金字塔
	CRISTO_REDENTOR, # 救世基督像
	STONEHENGE, # 巨石阵
	COLOSSUS, # 巨像
	HANGING_GARDENS, # 空中花园
	RUHR_VALLEY, # 鲁尔山谷
	COLOSSEUM, # 罗马斗兽场
	ESTADIO_DO_MARACANA, # 马拉卡纳体育场
	HALICARNASSUS_MAUSOLEUM, # 摩索拉斯王陵墓
	MAHABODHI_TEMPLE, # 摩诃菩提寺
	BOLSHOI_THEATRE, # 莫斯科大剧院
	OXFORD_UNIVERSITY, # 牛津大学
	PETRA, # 佩特拉古城
	CHICHEN_ITZA, # 奇琴伊察
	ORACLE, # 神谕
	BIOSPHERE, # 生物圈
	MONT_ST_MICHEL, # 圣米歇尔山
	HAGIA_SOPHIA, # 圣索菲亚大教堂
	VENETIAN_ARSENAL, # 威尼斯军械库
	ANGKOR_WAT, # 吴哥窟
	SYDNEY_OPERA_HOUSE, # 悉尼歌剧院
	HUEY_TEOCALLI, # 休伊神庙
	STATUE_OF_ZEUS, # 宙斯像
	FORBIDDEN_CITY, # 紫禁城
}


func _init() -> void:
	super._init()
	elem_type = WonderDO
	
	for k in Enum.keys():
		var do := WonderDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.ALHAMBRA:
				do.view_name = "阿尔罕布拉宫"
				do.quotation = "这里的一切似乎都是为了激起友好快乐的感觉，因为一切都如此精致而美丽。——华盛顿·欧文"
				do.remove_era = EraTable.Enum.INDUSTRIAL
				do.amuse_amenity = 2
				do.general_point = 2
				
				do.required_tech = TechTable.Enum.CASTLES
				do.adjoining_district = DistrictTable.Enum.ENCAMPMENT
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.production_cost = 710
			Enum.APADANA:
				do.view_name = "阿帕达纳宫"
				do.quotation = "我的祖先大流士一世修建了这座阿帕达纳宫，但它却被无情烧毁。托阿胡拉马兹达、阿娜希塔和密特拉的鸿福，我让它重见天日。——阿尔塔薛西斯二世"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.greatwork_slot = 2
				
				do.required_civic = CivicTable.Enum.POLITICAL_PHILOSOPHY
				do.adjoin_capital = true
				do.production_cost = 400
			Enum.EIFFEL_TOWER:
				do.view_name = "埃菲尔铁塔"
				do.quotation = "我应该嫉妒这座塔。她比我更出名。——古斯塔夫·埃菲尔"
				do.remove_era = EraTable.Enum.INFOMATION
				
				do.required_tech = TechTable.Enum.STEEL
				do.adjoining_district = DistrictTable.Enum.CITY_CENTER
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 1620
			Enum.ETEMENANKI:
				do.view_name = "埃特曼安吉神庙"
				do.quotation = "“来吧，我们来建一座城，城里有一座直达云霄的高塔，我们将因此扬名立万。”——《创世纪》11:4"
				do.remove_era = EraTable.Enum.MEDIEVAL
				do.science = 2
				
				do.required_tech = TechTable.Enum.WRITING
				do.placeable_landscapes = [
					LandscapeTable.Enum.FLOOD,
					LandscapeTable.Enum.SWAMP,
				]
				do.production_cost = 220
			Enum.HERMITAGE:
				do.view_name = "艾尔米塔什博物馆"
				do.quotation = "博物馆处于文化斗争的前沿，扬善抑恶——总之，一直在同陈腐和原始的东西做斗争。——冬宫博物馆馆长米哈伊尔"
				do.remove_era = EraTable.Enum.ATOMIC
				do.artist_point = 3
				do.landscape_slot = 4
				
				do.required_civic = CivicTable.Enum.NATURAL_HISTORY
				do.production_cost = 1450
			Enum.BROADWAY:
				do.view_name = "百老汇"
				do.quotation = "轻歌曼舞好营生，娱乐业至上。——欧文·柏林《飞燕金枪》"
				do.remove_era = EraTable.Enum.INFOMATION
				do.writer_point = 3
				do.musician_point = 3
				do.writing_slot = 1
				do.music_slot = 2
				
				do.required_civic = CivicTable.Enum.MASS_MEDIA
				do.adjoining_district = DistrictTable.Enum.THEATER
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 1620
			Enum.TORRE_DE_BELEM:
				do.view_name = "贝伦塔"
				do.quotation = "“这些火炮会让试图通过的船只遭到沉重打击。”——阿布兰特什公爵夫人劳拉·朱诺"
				do.remove_era = EraTable.Enum.MODERN
				do.gold = 5
				do.admiral_point = 1
				
				do.required_civic = CivicTable.Enum.MERCANTILISM
				do.adjoining_district = DistrictTable.Enum.HARBOR
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.on_lake = false
				do.production_cost = 920
			Enum.TERRACOTTA_ARMY:
				do.view_name = "兵马俑"
				do.quotation = "世界上有七大奇迹，我们可能会说兵马俑是世界第八大奇迹。——雅克·希拉克"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.general_point = 1
				
				do.required_tech = TechTable.Enum.CONSTRUCTION
				do.required_building = BuildingTable.Enum.BARRACKS
				do.required_building_incompatible = true
				do.adjoining_district = DistrictTable.Enum.ENCAMPMENT
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.production_cost = 400
			Enum.JEBEL_BARKAL:
				do.view_name = "博尔戈尔山"
				do.quotation = "这座山的西南角有一道深深的裂缝，从山的主体分出了一块巨大的陡峭砂岩...它的外观宛如一尊巨像。——E. A.沃利斯·巴奇"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.faith = 4
				
				do.required_tech = TechTable.Enum.IRON_WORKING
				do.placeable_terrains = [
					TerrainTable.Enum.DESERT_HILL,
				] as Array[TerrainTable.Enum]
				do.production_cost = 400
			Enum.POTALA_PALACE:
				do.view_name = "布达拉宫"
				do.quotation = "我第一次踏上布达拉宫房顶时，像步入生命的巅峰一般，这种感觉是前所未有的：整个人进入到从未有过的意识范围之中。——皮柯·耶尔"
				do.remove_era = EraTable.Enum.MODERN
				do.culture = 2
				do.faith = 3
				
				do.required_tech = TechTable.Enum.ASTRONOMY
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.production_cost = 1060
			Enum.BIG_BEN:
				do.view_name = "大本钟"
				do.quotation = "不要盯着大钟看；要做大钟正在做的事。继续前进。——萨姆·李文森"
				do.remove_era = EraTable.Enum.ATOMIC
				do.gold = 6
				do.merchant_point = 3
				
				do.required_tech = TechTable.Enum.ECONOMICS
				do.required_building = BuildingTable.Enum.BANK
				do.adjoining_district = DistrictTable.Enum.COMMERCIAL_HUB
				do.adjoin_river = true
				do.production_cost = 1450
			Enum.GREAT_LIGHTHOUSE:
				do.view_name = "大灯塔"
				do.quotation = "灯塔是所有目光的焦点。——亨利·大卫·梭罗"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.gold = 3
				do.admiral_point = 1
				
				do.required_tech = TechTable.Enum.CELESTIAL_NAVIGATION
				do.required_building = BuildingTable.Enum.LIGHTHOUSE
				do.adjoining_district = DistrictTable.Enum.HARBOR
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.on_lake = false
				do.production_cost = 290
			Enum.GREAT_ZIMBABWE:
				do.view_name = "大津巴布韦"
				do.quotation = "示巴女王所要求的一切东西，所罗门王都满足了她；另外还按照自己的意愿给予她丰富的馈赠。所以她和仆人一起返回了自己的国家。——《列王纪》10章13节"
				do.remove_era = EraTable.Enum.MODERN
				do.gold = 5
				do.merchant_point = 2
				
				do.required_tech = TechTable.Enum.BANKING
				do.required_building = BuildingTable.Enum.MARKET
				do.adjoining_district = DistrictTable.Enum.COMMERCIAL_HUB
				do.adjoining_resource = ResourceTable.Enum.COW
				do.production_cost = 920
			Enum.GREAT_LIBRARY:
				do.view_name = "大图书馆"
				do.quotation = "我们可以徜徉在亚历山大图书馆密密麻麻的书架前，这是想象力和知识的聚集地；它的毁灭是一种警告，让我们意识到我们所拥有的一切都将消失。——阿尔维托·曼古埃尔"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.science = 2
				do.scientist_point = 1
				do.writing_slot = 2
				
				do.required_civic = CivicTable.Enum.RECORDED_HISTORY
				do.required_building = BuildingTable.Enum.LIBRARY
				do.adjoining_district = DistrictTable.Enum.CAMPUS
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 400
			Enum.PYRAMIDS:
				do.view_name = "金字塔"
				do.quotation = "四十个世纪从这些金字塔的顶端，俯瞰着我们。——拿破仑·波拿巴"
				do.remove_era = EraTable.Enum.MEDIEVAL
				do.culture = 2
				
				do.required_tech = TechTable.Enum.MASONRY
				do.placeable_terrains = [
					TerrainTable.Enum.DESERT,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.EMPTY,
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.production_cost = 220
			Enum.CRISTO_REDENTOR:
				do.view_name = "救世基督像"
				do.quotation = "因此，雕塑的作用是让人感到‘一切都掌握在上帝的手中’。——谢尔盖·谢苗诺夫"
				do.remove_era = EraTable.Enum.INFOMATION
				do.culture = 4
				
				do.required_civic = CivicTable.Enum.MASS_MEDIA
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.production_cost = 1620
			Enum.STONEHENGE:
				do.view_name = "巨石阵"
				do.quotation = "你能想象试图说服600人帮你将一个重为50吨的石头拖动28千米穿过乡村，并用力将它立起来，然后说：‘好了，小伙子们！再推动20块这样的石头…然后就可以庆祝啦！’这样的场景吗？——比尔·布莱森"
				do.remove_era = EraTable.Enum.MEDIEVAL
				do.faith = 2
				
				do.required_tech = TechTable.Enum.ASTROLOGY
				do.adjoining_resource = ResourceTable.Enum.STONE
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 180
			Enum.COLOSSUS:
				do.view_name = "巨像"
				do.quotation = "在罗兹岛上建成了一座36米高的巨像，以此代表太阳…艺术家在上面使用了大量青铜，可能是想引起矿产资源匮乏。——费隆（拜占庭）"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.gold = 3
				do.admiral_point = 1
				
				do.required_tech = TechTable.Enum.SHIPBUILDING
				do.adjoining_district = DistrictTable.Enum.HARBOR
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.on_lake = false
				do.production_cost = 400
			Enum.HANGING_GARDENS:
				do.view_name = "空中花园"
				do.quotation = "通过楼梯可以到达顶层，旁边是抽水机，雇佣了大量工人来齐心协力从幼发拉底河抽水到花园。——斯特拉博"
				do.remove_era = EraTable.Enum.MEDIEVAL
				do.housing = 2
				
				do.required_tech = TechTable.Enum.IRRIGATION
				do.production_cost = 180
			Enum.RUHR_VALLEY:
				do.view_name = "鲁尔山谷"
				do.quotation = "德国的工业中心实际已停止了运营。几乎没有人工作，几乎没有任何东西在运行；鲁尔地区的全体居民…需要其他国家的援助。——亚当·弗格森"
				do.remove_era = EraTable.Enum.ATOMIC
				
				do.required_tech = TechTable.Enum.INDUSTRIALIZATION
				do.required_building = BuildingTable.Enum.FACTORY
				do.adjoining_district = DistrictTable.Enum.INDUSTRIAL_ZONE
				do.adjoin_river = true
				do.production_cost = 1240
			Enum.COLOSSEUM:
				do.view_name = "罗马斗兽场"
				do.quotation = "竞技场耸立，罗马屹立不倒；竞技场倒塌，罗马倒塌；罗马倒塌，整个世界都会崩溃。——圣徒比德"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.culture = 2
				do.amuse_amenity = 3
				
				do.required_civic = CivicTable.Enum.GAMES_RECREATION
				do.adjoining_district = DistrictTable.Enum.ENTERTAINMENT_COMPLEX
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 400
			Enum.ESTADIO_DO_MARACANA:
				do.view_name = "马拉卡纳体育场"
				do.quotation = "纵观历史，只有三个人能让马拉卡纳球场安静下来：教皇、法兰克·辛纳屈、我。——阿尔喀德斯·吉贾（乌拉圭足球运动员）"
				do.culture = 6
				do.amuse_amenity = 2
				
				do.required_civic = CivicTable.Enum.PROFESSIONAL_SPORTS
				do.required_building = BuildingTable.Enum.STADIUM
				do.adjoining_district = DistrictTable.Enum.ENTERTAINMENT_COMPLEX
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 1740
			Enum.HALICARNASSUS_MAUSOLEUM:
				do.view_name = "摩索拉斯王陵墓"
				do.quotation = "在哈利卡纳苏斯坐落着一个巨大的陵墓，它的规模和壮丽世间第一。——萨莫萨塔的琉善"
				do.remove_era = EraTable.Enum.RENAISSANCE
				
				do.required_civic = CivicTable.Enum.DEFENSIVE_TACTICS
				do.adjoining_district = DistrictTable.Enum.HARBOR
				do.production_cost = 400
			Enum.MAHABODHI_TEMPLE:
				do.view_name = "摩诃菩提寺"
				do.quotation = "在印度比哈尔邦尘土飞扬的喧闹角落里，有一个神奇的地方被人们当作佛教中心。——《旅游者指南》里的菩提伽耶"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.faith = 4
				
				do.required_civic = CivicTable.Enum.THEOLOGY
				do.required_building = BuildingTable.Enum.TEMPLE
				do.create_religion_needed = true
				do.adjoining_district = DistrictTable.Enum.HOLY_SITE
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
				] as Array[LandscapeTable.Enum]
				do.production_cost = 400
			Enum.BOLSHOI_THEATRE:
				do.view_name = "莫斯科大剧院"
				do.quotation = "莫斯科大剧院芭蕾舞团是充满想象力的地方，一个具有魔法和吸引力的美丽浪漫之地。优雅的舞者、气势磅礴的音乐以及华丽的服饰让世人为之震撼。——特鲁迪·加丰科"
				do.remove_era = EraTable.Enum.ATOMIC
				do.writer_point = 2
				do.musician_point = 2
				do.writing_slot = 1
				do.music_slot = 1
				
				do.required_civic = CivicTable.Enum.OPERA_BALLET
				do.adjoining_district = DistrictTable.Enum.THEATER
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 1240
			Enum.OXFORD_UNIVERSITY:
				do.view_name = "牛津大学"
				do.quotation = "牛津大学的聪明人…知道所有需要知道的事。但他们都没有蟾蜍先生一半聪明！——肯尼思·格拉姆"
				do.remove_era = EraTable.Enum.ATOMIC
				do.scientist_point = 3
				do.writing_slot = 2
				
				do.required_tech = TechTable.Enum.SCIENTIFIC_THEORY
				do.required_building = BuildingTable.Enum.UNIVERSITY
				do.adjoining_district = DistrictTable.Enum.CAMPUS
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.production_cost = 1240
			Enum.PETRA:
				do.view_name = "佩特拉古城"
				do.quotation = "约旦-佩特拉古城是人类工艺的绝妙展示，它把贫瘠的岩石变成了伟大的奇迹。——爱德华·道森"
				do.remove_era = EraTable.Enum.RENAISSANCE
				
				do.required_tech = TechTable.Enum.MATHEMATICS
				do.placeable_terrains = [
					TerrainTable.Enum.DESERT,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.EMPTY,
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.production_cost = 400
			Enum.CHICHEN_ITZA:
				do.view_name = "奇琴伊察"
				do.quotation = "大竞技场也让人印象深刻。我很想看他们在这里进行比赛，虽然结局听起来很暴力。我认为作为观众还是会安全些。——伊斯拉德布"
				do.remove_era = EraTable.Enum.INDUSTRIAL
				
				do.required_civic = CivicTable.Enum.GUILDS
				do.placeable_landscapes = [
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.production_cost = 710
			Enum.ORACLE:
				do.view_name = "神谕"
				do.quotation = "我像海豚一样跳向快速驶过的船只，祈祷自己成为阿波罗海豚星座；祭坛本身也被称作海豚星座。——荷马"
				do.remove_era = EraTable.Enum.MEDIEVAL
				do.culture = 1
				do.faith = 1
				
				do.required_civic = CivicTable.Enum.MYSTICISM
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.production_cost = 290
			Enum.BIOSPHERE:
				do.view_name = "生物圈"
				do.quotation = "“天堂既在我们脚下，也在我们头顶。”——亨利·戴维·梭罗"
				do.science = 8
				
				do.required_tech = TechTable.Enum.SYNTHETIC_MATERIALS
				do.adjoining_district = DistrictTable.Enum.NEIGHBORHOOD
				do.adjoin_river = true
				do.production_cost = 1740
			Enum.MONT_ST_MICHEL:
				do.view_name = "圣米歇尔山"
				do.quotation = "教会和国家、灵魂和身体、神和人类，这些都是圣米歇尔山上的一个整体，主要任务是进行战斗，各行其事，或为彼此守卫。——享利·亚当斯"
				do.remove_era = EraTable.Enum.INDUSTRIAL
				do.faith = 2
				do.relic_slot = 2
				
				do.required_civic = CivicTable.Enum.DIVINE_RIGHT
				do.placeable_landscapes = [
					LandscapeTable.Enum.FLOOD,
					LandscapeTable.Enum.SWAMP,
				] as Array[LandscapeTable.Enum]
				do.production_cost = 710
			Enum.HAGIA_SOPHIA:
				do.view_name = "圣索菲亚大教堂"
				do.quotation = "它是一座华丽的重要纪念碑，是跨文化宝藏…除非和直到它能被两种宗教和谐共享——这真是一个伟大的想法——它应该被建成世俗的模样，以此向这两种宗教致敬，是它们让纪念碑如此华丽。——牛博·武约维奇"
				do.remove_era = EraTable.Enum.INDUSTRIAL
				do.faith = 4
				
				do.required_tech = TechTable.Enum.EDUCATION
				do.create_religion_needed = true
				do.adjoining_district = DistrictTable.Enum.HOLY_SITE
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 710
			Enum.VENETIAN_ARSENAL:
				do.view_name = "威尼斯军械库"
				do.quotation = "威尼斯联邦的军械库上有这样一段题词：快乐是城市在和平时期想起战争的痛苦。——罗伯特·伯顿"
				do.remove_era = EraTable.Enum.MODERN
				do.engineer_point = 2
				
				do.required_tech = TechTable.Enum.MASS_PRODUCTION
				do.adjoining_district = DistrictTable.Enum.INDUSTRIAL_ZONE
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.on_lake = false
				do.production_cost = 920
			Enum.ANGKOR_WAT:
				do.view_name = "吴哥窟"
				do.quotation = "这座寺庙四周环绕着护城河，须借助唯一的桥梁进出，门口有两只威风凛凛的巨型石虎镇守，似乎要把恐惧植入来访者的心中。——蒂欧格·都·科托"
				do.remove_era = EraTable.Enum.INDUSTRIAL
				do.faith = 2
				
				do.required_civic = CivicTable.Enum.MEDIEVAL_FAIRES
				do.adjoining_district = DistrictTable.Enum.AQUEDUCT
				do.production_cost = 710
			Enum.SYDNEY_OPERA_HOUSE:
				do.view_name = "悉尼歌剧院"
				do.quotation = "在幕布拉起前很久，歌剧已经开始，在幕布降下后很久，歌剧才结束。它开始于我的想象中，变成了我的生命，在我离开歌剧院很久之后，它依然是我生活的一部分。——玛丽亚·卡拉斯"
				do.culture = 8
				do.musician_point = 5
				do.music_slot = 3
				
				do.required_civic = CivicTable.Enum.CULTURAL_HERITAGE
				do.adjoining_district = DistrictTable.Enum.HARBOR
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.on_lake = false
				do.production_cost = 1850
			Enum.HUEY_TEOCALLI:
				do.view_name = "休伊神庙"
				do.quotation = "但维齐洛波奇特利非常生气，作为牺牲，穿过了4个房间，献身于太阳神，天空中的太阳消失了，或再次出现了。——福莱·迪亚哥·杜兰"
				do.remove_era = EraTable.Enum.INDUSTRIAL
				
				do.required_tech = TechTable.Enum.MILITARY_TACTICS
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.on_lake = true
				do.production_cost = 710
			Enum.STATUE_OF_ZEUS:
				do.view_name = "宙斯像"
				do.quotation = "“神的头上戴着一个橄榄叶桂冠，右手则握着带翅膀的胜利女神雕像。”——塞缪尔·奥古斯塔斯·米切尔"
				do.remove_era = EraTable.Enum.RENAISSANCE
				do.gold = 3
				
				do.required_civic = CivicTable.Enum.MILITARY_TRAINING
				do.required_building = BuildingTable.Enum.BARRACKS
				do.required_building_incompatible = false
				do.adjoining_district = DistrictTable.Enum.ENCAMPMENT
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 400
			Enum.FORBIDDEN_CITY:
				do.view_name = "紫禁城"
				do.quotation = "整个宫殿是沿着一条中心轴建立的，这也是整个世界的轴心，以宫殿为代表，四个方向的所有东西都是从中心点悬吊下来的。——杰弗里·里格尔"
				do.remove_era = EraTable.Enum.MODERN
				do.culture = 5
				
				do.required_tech = TechTable.Enum.PRINTING
				do.adjoining_district = DistrictTable.Enum.CITY_CENTER
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 920
		super.init_insert(do)

