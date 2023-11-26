class_name BuildingTable
extends MySimSQL.EnumTable


enum Enum {
	# 保护区
	SANCTUARY, # 避难所
	GROVE, # 古树林
	# 港口
	LIGHTHOUSE, # 灯塔
	SEAPORT, # 码头
	SHIPYARD, # 造船厂
	# 工业区
	ELECTRONICS_FACTORY, # 电子厂
	POWER_PLANT, # 发电厂
	FACTORY, # 工厂
	WORKSHOP, # 工作坊
	# 航空港
	AIRPORT, # 机场
	HANGAR, # 机库
	# 剧院广场
	FILM_STUDIO, # 电影制片厂
	AMPHITHEATER, # 古罗马剧场
	BROADCAST_CENTER, # 广播中心
	MUSEUM_ARTIFACT, # 考古博物馆
	MUSEUM_ART, # 艺术博物馆
	# 军营
	ARMORY, # 兵工厂
	BARRACKS, # 兵营
	BASILIKOI_PAIDES, # 皇家学堂
	MILITARY_ACADEMY, # 军事学院
	STABLE, # 马厩
	# 商业中心
	SUKIENNICE, # 纺织会馆
	MARKET, # 市场
	BANK, # 银行
	STOCK_EXCHANGE, # 证券交易所
	# 圣地
	DAR_E_MEHR, # 拜火神庙
	PAGODA, # 宝塔
	CATHEDRAL, # 大教堂
	WAT, # 佛寺
	PRASAT, # 高棉庙堂
	MEETING_HOUSE, # 礼拜堂
	STAVE_CHURCH, # 木板教堂
	MOSQUE, # 清真寺
	SHRINE, # 神社
	TEMPLE, # 寺庙
	SYNAGOGUE, # 犹太教堂
	GURDWARA, # 谒师所
	STUPA, # 窣堵波
	# 市中心
	PALACE, # 宫殿
	PALGUM, # 沟渠
	MONUMENT, # 纪念碑
	GRANARY, # 粮仓
	WATER_MILL, # 水磨
	STAR_FORT, # 文艺复兴城墙
	SEWER, # 下水道
	WALLS, # 远古城墙
	CASTLE, # 中世纪城墙
	# 外交区
	CONSULATE, # 领事馆
	CHANCERY, # 外交办
	# 学院
	UNIVERSITY, # 大学
	NAVIGATION_SCHOOL, # 航海学校
	LIBRARY, # 图书馆
	RESEARCH_LAB, # 研究实验室
	MADRASA, # 伊斯兰学校
	# 娱乐中心
	ZOO, # 动物园
	ARENA, # 竞技场
	STADIUM, # 体育场
	TLACHTLI, # 蹴球场
}


func _init() -> void:
	super._init()
	elem_type = BuildingDO
	
	for k in Enum.keys():
		var do = BuildingDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.SANCTUARY:
				do.view_name = "避难所"
				
				do.required_district = DistrictTable.Enum.PRESERVE
				do.required_civic = CivicTable.Enum.CONSERVATION
				do.production_cost = 440
				do.gold_cost = 1760
			Enum.GROVE:
				do.view_name = "古树林"
				
				do.required_district = DistrictTable.Enum.PRESERVE
				do.required_civic = CivicTable.Enum.MYSTICISM
				do.production_cost = 150
				do.gold_cost = 600
			Enum.LIGHTHOUSE:
				do.view_name = "灯塔"
				do.food = 1
				do.gold = 1
				do.housing = 1
				do.citizen_slot = 1
				do.admiral_point = 1
				
				do.required_district = DistrictTable.Enum.HARBOR
				do.required_tech = TechTable.Enum.CELESTIAL_NAVIGATION
				do.production_cost = 120
				do.gold_cost = 480
			Enum.SEAPORT:
				do.view_name = "码头"
				do.food = 2
				do.gold = 2
				do.housing = 1
				do.citizen_slot = 1
				do.admiral_point = 1
				
				do.required_district = DistrictTable.Enum.HARBOR
				do.required_tech = TechTable.Enum.ELECTRICITY
				do.required_building = Enum.SHIPYARD
				do.production_cost = 580
				do.gold_cost = 2320
			Enum.SHIPYARD:
				do.view_name = "造船厂"
				# 生产力加成等于该区域相邻金币加成。
				do.citizen_slot = 1
				do.admiral_point = 1
				
				do.required_district = DistrictTable.Enum.HARBOR
				do.required_tech = TechTable.Enum.MASS_PRODUCTION
				do.required_building = Enum.LIGHTHOUSE
				do.production_cost = 290
				do.gold_cost = 1160
			Enum.ELECTRONICS_FACTORY:
				do.view_name = "电子厂"
				do.spec_civ = CivTable.Enum.JAPAN
				do.replace_building = Enum.FACTORY
				do.production = 4
				do.citizen_slot = 1
				do.engineer_point = 1
				
				do.required_district = DistrictTable.Enum.INDUSTRIAL_ZONE
				do.required_tech = TechTable.Enum.INDUSTRIALIZATION
				do.required_building = Enum.WORKSHOP
				do.production_cost = 390
				do.gold_cost = 1560
				do.maintenance_fee = 2
			Enum.POWER_PLANT:
				do.view_name = "发电厂"
				do.production = 4
				do.citizen_slot = 1
				do.engineer_point = 1
				
				do.required_district = DistrictTable.Enum.INDUSTRIAL_ZONE
				do.required_tech = TechTable.Enum.ELECTRICITY
				do.required_building = Enum.FACTORY
				do.production_cost = 580
				do.gold_cost = 2320
				do.maintenance_fee = 3
			Enum.FACTORY:
				do.view_name = "工厂"
				do.production = 3
				do.citizen_slot = 1
				do.engineer_point = 1
				
				do.required_district = DistrictTable.Enum.INDUSTRIAL_ZONE
				do.required_tech = TechTable.Enum.INDUSTRIALIZATION
				do.required_building = Enum.WORKSHOP
				do.production_cost = 390
				do.gold_cost = 1560
				do.maintenance_fee = 2
			Enum.WORKSHOP:
				do.view_name = "工作坊"
				do.production = 2
				do.citizen_slot = 1
				do.engineer_point = 1
				
				do.required_district = DistrictTable.Enum.INDUSTRIAL_ZONE
				do.required_tech = TechTable.Enum.APPRENTICESHIP
				do.production_cost = 195
				do.gold_cost = 780
				do.maintenance_fee = 1
			Enum.AIRPORT:
				do.view_name = "机场"
				do.production = 3
				
				do.required_district = DistrictTable.Enum.AERODROME
				do.required_tech = TechTable.Enum.ADVANCED_FLIGHT
				do.required_building = Enum.HANGAR
				do.production_cost = 600
				do.gold_cost = 2400
				do.maintenance_fee = 2
			Enum.HANGAR:
				do.view_name = "机库"
				do.production = 2
				
				do.required_district = DistrictTable.Enum.AERODROME
				do.required_tech = TechTable.Enum.FLIGHT
				do.production_cost = 465
				do.gold_cost = 1860
				do.maintenance_fee = 1
			Enum.FILM_STUDIO:
				do.view_name = "电影制片厂"
				do.spec_civ = CivTable.Enum.AMERICA
				do.replace_building = Enum.BROADCAST_CENTER
				do.culture = 4
				do.citizen_slot = 1
				do.artist_point = 1
				do.musician_point = 2
				do.music_slot = 1
				
				do.required_district = DistrictTable.Enum.THEATER
				do.required_tech = TechTable.Enum.RADIO
				do.required_building = Enum.MUSEUM_ART
				do.production_cost = 580
				do.gold_cost = 2320
				do.maintenance_fee = 3
			Enum.AMPHITHEATER:
				do.view_name = "古罗马剧场"
				do.culture = 2
				do.citizen_slot = 1
				do.writer_point = 1
				do.writing_slot = 2
				
				do.required_district = DistrictTable.Enum.THEATER
				do.required_civic = CivicTable.Enum.DRAMA_POETRY
				do.production_cost = 150
				do.gold_cost = 600
				do.maintenance_fee = 1
			Enum.BROADCAST_CENTER:
				do.view_name = "广播中心"
				do.spec_civ = CivTable.Enum.AMERICA
				do.replace_building = Enum.BROADCAST_CENTER
				do.culture = 4
				do.citizen_slot = 1
				do.artist_point = 1
				do.musician_point = 2
				do.music_slot = 1
				
				do.required_district = DistrictTable.Enum.THEATER
				do.required_tech = TechTable.Enum.RADIO
				do.required_building = Enum.MUSEUM_ART
				do.production_cost = 580
				do.gold_cost = 2320
				do.maintenance_fee = 3
			Enum.MUSEUM_ARTIFACT:
				do.view_name = "考古博物馆"
				do.culture = 2
				do.citizen_slot = 1
				do.writer_point = 1
				do.artist_point = 2
				do.relic_slot = 3
				
				do.required_district = DistrictTable.Enum.THEATER
				do.required_civic = CivicTable.Enum.HUMANISM
				do.required_building = Enum.AMPHITHEATER
				do.incompatible_building = Enum.MUSEUM_ART
				do.production_cost = 290
				do.gold_cost = 1160
				do.maintenance_fee = 2
			Enum.MUSEUM_ART:
				do.view_name = "艺术博物馆"
				do.culture = 2
				do.citizen_slot = 1
				do.writer_point = 1
				do.artist_point = 2
				do.landscape_slot = 3
				
				do.required_district = DistrictTable.Enum.THEATER
				do.required_civic = CivicTable.Enum.HUMANISM
				do.required_building = Enum.AMPHITHEATER
				do.incompatible_building = Enum.MUSEUM_ARTIFACT
				do.production_cost = 290
				do.gold_cost = 1160
				do.maintenance_fee = 2
			Enum.ARMORY:
				do.view_name = "兵工厂"
				do.production = 2
				do.citizen_slot = 1
				do.general_point = 1
				
				do.required_district = DistrictTable.Enum.ENCAMPMENT
				do.required_tech = TechTable.Enum.MILITARY_ENGINEERING
				do.required_building = Enum.BARRACKS
				do.production_cost = 195
				do.gold_cost = 780
				do.maintenance_fee = 2
			Enum.BARRACKS:
				do.view_name = "兵营"
				do.production = 1
				do.housing = 1
				do.citizen_slot = 1
				do.general_point = 1
				
				do.required_district = DistrictTable.Enum.ENCAMPMENT
				do.required_tech = TechTable.Enum.BRONZE_WORKING
				do.incompatible_building = Enum.STABLE
				do.production_cost = 90
				do.gold_cost = 360
				do.maintenance_fee = 1
			Enum.BASILIKOI_PAIDES:
				do.view_name = "皇家学堂"
				do.production = 1
				do.housing = 1
				do.citizen_slot = 1
				do.general_point = 1
				
				do.required_district = DistrictTable.Enum.ENCAMPMENT
				do.required_tech = TechTable.Enum.BRONZE_WORKING
				do.incompatible_building = Enum.STABLE
				do.production_cost = 90
				do.gold_cost = 360
				do.maintenance_fee = 1
			Enum.MILITARY_ACADEMY:
				do.view_name = "军事学院"
				do.production = 3
				do.housing = 1
				do.citizen_slot = 1
				do.general_point = 1
				
				do.required_district = DistrictTable.Enum.ENCAMPMENT
				do.required_tech = TechTable.Enum.MILITARY_SCIENCE
				do.required_building = Enum.ARMORY
				do.production_cost = 390
				do.gold_cost = 1560
				do.maintenance_fee = 2
			Enum.STABLE:
				do.view_name = "马厩"
				do.production = 1
				do.housing = 1
				do.citizen_slot = 1
				do.general_point = 1
				
				do.required_district = DistrictTable.Enum.ENCAMPMENT
				do.required_tech = TechTable.Enum.HORSEBACK_RIDING
				do.incompatible_building = Enum.BARRACKS
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 1
			Enum.SUKIENNICE:
				do.view_name = "纺织会馆"
				do.spec_civ = CivTable.Enum.POLAND
				do.replace_building = Enum.MARKET
				do.gold = 3
				do.citizen_slot = 1
				do.merchant_point = 1
				
				do.required_district = DistrictTable.Enum.COMMERCIAL_HUB
				do.required_tech = TechTable.Enum.CURRENCY
				do.production_cost = 120
				do.gold_cost = 480
			Enum.MARKET:
				do.view_name = "市场"
				do.gold = 3
				do.citizen_slot = 1
				do.merchant_point = 1
				
				do.required_district = DistrictTable.Enum.COMMERCIAL_HUB
				do.required_tech = TechTable.Enum.CURRENCY
				do.production_cost = 120
				do.gold_cost = 480
			Enum.BANK:
				do.view_name = "银行"
				do.gold = 5
				do.citizen_slot = 1
				do.merchant_point = 1
				
				do.required_district = DistrictTable.Enum.COMMERCIAL_HUB
				do.required_tech = TechTable.Enum.BANKING
				do.required_building = Enum.MARKET
				do.production_cost = 290
				do.gold_cost = 1160
			Enum.STOCK_EXCHANGE:
				do.view_name = "证券交易所"
				do.gold = 7
				do.citizen_slot = 1
				do.merchant_point = 1
				
				do.required_district = DistrictTable.Enum.COMMERCIAL_HUB
				do.required_tech = TechTable.Enum.ECONOMICS
				do.required_building = Enum.BANK
				do.production_cost = 390
				do.gold_cost = 1560
			Enum.DAR_E_MEHR: 
				do.view_name = "拜火神庙"
				do.spec_belief = BeliefTable.Enum.DAR_E_MEHR
				do.faith = 3
				do.citizen_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.PAGODA:
				do.view_name = "宝塔"
				do.spec_belief = BeliefTable.Enum.PAGODA
				do.faith = 3
				do.housing = 1
				do.citizen_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.CATHEDRAL:
				do.view_name = "大教堂"
				do.spec_belief = BeliefTable.Enum.CATHEDRAL
				do.faith = 3
				do.citizen_slot = 1
				do.religious_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.WAT:
				do.view_name = "佛寺"
				do.spec_belief = BeliefTable.Enum.WAT
				do.faith = 3
				do.science = 2
				do.citizen_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.PRASAT:
				do.view_name = "高棉庙堂"
				do.spec_civ = CivTable.Enum.KHMER
				do.replace_building = Enum.TEMPLE
				do.faith = 4
				do.citizen_slot = 1
				do.prophet_point = 1
				do.relic_slot = 2
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_civic = CivicTable.Enum.THEOLOGY
				do.required_building = Enum.SHRINE
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 2
			Enum.MEETING_HOUSE:
				do.view_name = "礼拜堂"
				do.spec_belief = BeliefTable.Enum.MEETING_HOUSE
				do.faith = 3
				do.production = 2
				do.citizen_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.STAVE_CHURCH:
				do.view_name = "木板教堂"
				do.spec_civ = CivTable.Enum.NORWAY
				do.replace_building = Enum.TEMPLE
				do.faith = 4
				do.citizen_slot = 1
				do.prophet_point = 1
				do.relic_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_civic = CivicTable.Enum.THEOLOGY
				do.required_building = Enum.SHRINE
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 2
			Enum.MOSQUE:
				do.view_name = "清真寺"
				do.spec_belief = BeliefTable.Enum.MOSQUE
				do.faith = 3
				do.citizen_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.SHRINE:
				do.view_name = "神社"
				do.faith = 2
				do.citizen_slot = 1
				do.prophet_point = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_tech = TechTable.Enum.ASTROLOGY
				do.production_cost = 70
				do.gold_cost = 280
				do.maintenance_fee = 1
			Enum.TEMPLE:
				do.view_name = "寺庙"
				do.faith = 4
				do.citizen_slot = 1
				do.prophet_point = 1
				do.relic_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_civic = CivicTable.Enum.THEOLOGY
				do.required_building = Enum.SHRINE
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 2
			Enum.SYNAGOGUE:
				do.view_name = "犹太教堂"
				do.spec_belief = BeliefTable.Enum.SYNAGOGUE
				do.faith = 5
				do.citizen_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.GURDWARA:
				do.view_name = "谒师所"
				do.spec_belief = BeliefTable.Enum.GURDWARA
				do.faith = 3
				do.food = 2
				do.citizen_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.STUPA:
				do.view_name = "窣堵波"
				do.spec_belief = BeliefTable.Enum.STUPA
				do.faith = 3
				do.amuse_amenity = 1
				do.citizen_slot = 1
				
				do.required_district = DistrictTable.Enum.HOLY_SITE
				do.required_building = Enum.TEMPLE
				do.production_cost = 190
				do.faith_cost = 380
			Enum.PALACE:
				do.view_name = "宫殿"
				do.culture = 1
				do.gold = 5
				do.production = 2
				do.science = 2
				do.housing = 1
				do.amuse_amenity = 1
				do.greatwork_slot = 1
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.production_cost = 1
			Enum.PALGUM:
				do.view_name = "沟渠"
				do.spec_civ = CivTable.Enum.BYZANTIUM
				do.replace_building = Enum.WATER_MILL
				do.production = 2
				do.housing = 1
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.required_tech = TechTable.Enum.IRRIGATION
				do.production_cost = 80
				do.gold_cost = 320
			Enum.MONUMENT:
				do.view_name = "纪念碑"
				do.culture = 2
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.production_cost = 60
				do.gold_cost = 240
			Enum.GRANARY:
				do.view_name = "粮仓"
				do.food = 1
				do.housing = 2
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.required_tech = TechTable.Enum.POTTERY
				do.production_cost = 65
				do.gold_cost = 260
			Enum.WATER_MILL:
				do.view_name = "水磨"
				do.production = 1
				do.housing = 1
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.required_tech = TechTable.Enum.WHEEL
				do.production_cost = 80
				do.gold_cost = 320
			Enum.STAR_FORT:
				do.view_name = "文艺复兴城墙"
				do.defence = 100
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.required_tech = TechTable.Enum.SIEGE_TACTICS
				do.required_building = Enum.CASTLE
				do.production_cost = 305
			Enum.SEWER:
				do.view_name = "下水道"
				do.housing = 2
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.required_tech = TechTable.Enum.SANITATION
				do.production_cost = 200
				do.gold_cost = 800
				do.maintenance_fee = 2
			Enum.WALLS:
				do.view_name = "远古城墙"
				do.defence = 100
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.required_tech = TechTable.Enum.MASONRY
				do.production_cost = 80
			Enum.CASTLE:
				do.view_name = "中世纪城墙"
				do.defence = 100
				
				do.required_district = DistrictTable.Enum.CITY_CENTER
				do.required_tech = TechTable.Enum.CASTLES
				do.required_building = Enum.WALLS
				do.production_cost = 225
			Enum.CONSULATE:
				do.view_name = "领事馆"
				
				do.required_district = DistrictTable.Enum.DIPLOMATIC_QUARTER
				do.required_tech = TechTable.Enum.MATHEMATICS
				do.production_cost = 150
				do.gold_cost = 600
				do.maintenance_fee = 1
			Enum.CHANCERY:
				do.view_name = "外交办"
				
				do.required_district = DistrictTable.Enum.DIPLOMATIC_QUARTER
				do.required_civic = CivicTable.Enum.DIPLOMATIC_SERVICE
				do.required_building = Enum.CONSULATE
				do.production_cost = 290
				do.gold_cost = 1160
				do.maintenance_fee = 2
			Enum.UNIVERSITY:
				do.view_name = "大学"
				do.science = 4
				do.housing = 1
				do.citizen_slot = 1
				do.scientist_point = 1
				
				do.required_district = DistrictTable.Enum.CAMPUS
				do.required_tech = TechTable.Enum.EDUCATION
				do.required_building = Enum.LIBRARY
				do.production_cost = 250
				do.gold_cost = 1000
				do.maintenance_fee = 2
			Enum.NAVIGATION_SCHOOL:
				do.view_name = "航海学校"
				do.spec_civ = CivTable.Enum.PORTUGAL
				do.replace_building = Enum.UNIVERSITY
				do.science = 4
				do.housing = 1
				do.citizen_slot = 1
				do.admiral_point = 1
				do.scientist_point = 1
				
				do.required_district = DistrictTable.Enum.CAMPUS
				do.required_tech = TechTable.Enum.EDUCATION
				do.required_building = Enum.LIBRARY
				do.production_cost = 250
				do.gold_cost = 1000
				do.maintenance_fee = 2
			Enum.LIBRARY:
				do.view_name = "图书馆"
				do.science = 2
				do.citizen_slot = 1
				do.scientist_point = 1
				
				do.required_district = DistrictTable.Enum.CAMPUS
				do.required_tech = TechTable.Enum.WRITING
				do.production_cost = 90
				do.gold_cost = 360
				do.maintenance_fee = 1
			Enum.RESEARCH_LAB:
				do.view_name = "研究实验室"
				do.science = 5
				do.citizen_slot = 1
				do.scientist_point = 1
				
				do.required_district = DistrictTable.Enum.CAMPUS
				do.required_tech = TechTable.Enum.CHEMISTRY
				do.required_building = Enum.UNIVERSITY
				do.production_cost = 580
				do.gold_cost = 2320
				do.maintenance_fee = 3
			Enum.MADRASA:
				do.view_name = "伊斯兰学校"
				do.spec_civ = CivTable.Enum.ARABIA
				do.replace_building = Enum.UNIVERSITY
				do.science = 5
				# 信仰值加成等于该区域相邻科技值加成。
				do.housing = 1
				do.citizen_slot = 1
				do.scientist_point = 1
				
				do.required_district = DistrictTable.Enum.CAMPUS
				do.required_civic = CivicTable.Enum.THEOLOGY
				do.required_building = Enum.LIBRARY
				do.production_cost = 250
				do.gold_cost = 1000
				do.maintenance_fee = 2
			Enum.ZOO:
				do.view_name = "动物园"
				do.amuse_amenity = 1
				
				do.required_district = DistrictTable.Enum.ENTERTAINMENT_COMPLEX
				do.required_civic = CivicTable.Enum.NATURAL_HISTORY
				do.required_building = Enum.ARENA
				do.production_cost = 445
				do.gold_cost = 1780
				do.maintenance_fee = 2
			Enum.ARENA:
				do.view_name = "竞技场"
				do.amuse_amenity = 2
				
				do.required_district = DistrictTable.Enum.ENTERTAINMENT_COMPLEX
				do.required_civic = CivicTable.Enum.GAMES_RECREATION
				do.production_cost = 150
				do.gold_cost = 600
				do.maintenance_fee = 1
			Enum.STADIUM:
				do.view_name = "体育场"
				do.amuse_amenity = 2
				
				do.required_district = DistrictTable.Enum.ENTERTAINMENT_COMPLEX
				do.required_civic = CivicTable.Enum.PROFESSIONAL_SPORTS
				do.required_building = Enum.ZOO
				do.production_cost = 660
				do.gold_cost = 2640
				do.maintenance_fee = 3
			Enum.TLACHTLI:
				do.view_name = "蹴球场"
				do.spec_civ = CivTable.Enum.AZTEC
				do.replace_building = Enum.ARENA
				do.faith = 2
				do.culture = 1
				do.amuse_amenity = 2
				do.general_point = 1
				
				do.required_district = DistrictTable.Enum.ENTERTAINMENT_COMPLEX
				do.required_civic = CivicTable.Enum.GAMES_RECREATION
				do.production_cost = 135
				do.gold_cost = 540
				do.maintenance_fee = 1
		super.init_insert(do)

