class_name UnitTypeTable
extends MySimSQL.EnumTable


enum Enum {
	# 海上战争
	GERMAN_UBOAT, # U型潜水艇
	MISSILE_CRUISER, # 导弹巡洋舰
	ENGLISH_SEADOG, # 海猎犬
	AIRCRAFT_CARRIER, # 航空母舰
	NUCLEAR_SUBMARINE, # 核潜艇
	FRIGATE, # 护卫舰
	BYZANTINE_DROMON, # 火战船
	GALLEY, # 桨帆船
	PORTUGUESE_NAU, # 克拉克帆船
	BRAZILIAN_MINAS_GERAES, # 米纳斯吉拉斯
	SUBMARINE, # 潜艇
	CARAVEL, # 轻快帆船
	DESTROYER, # 驱逐舰
	INDONESIAN_JONG, # 戎克船
	PRIVATEER, # 私掠船
	QUADRIREME, # 四段帆船
	NORWEGIAN_LONGSHIP, # 维京长船
	BATTLESHIP, # 战舰
	IRONCLAD, # 装甲舰
	# 空战
	AMERICAN_P51, # P-51战斗机
	BOMBER, # 轰炸机
	JET_BOMBER, # 喷气式轰炸机
	JET_FIGHTER, # 喷气式战斗机
	BIPLANE, # 双翼机
	FIGHTER, # 战斗机
	# 陆地战斗
	ETHIOPIAN_OROMO_CAVALRY, # 奥罗莫骑兵
	KONGO_SHIELD_BEARER, # 奥姆本巴
	INFANTRY, # 步兵
	PIKEMAN, # 长矛兵
	PERSIAN_IMMORTAL, # 长生军
	MACEDONIAN_HYPASPIST, # 持盾护卫
	ARTILLERY, # 大炮
	FRENCH_GARDE_IMPERIALE, # 帝国卫队
	AT_CREW, # 反坦克组
	GAUL_GAESATAE, # 高卢枪佣兵
	KHMER_DOMREY, # 高棉战象
	RUSSIAN_COSSACK, # 哥萨克骑兵
	ARCHER, # 弓箭手
	ENGLISH_REDCOAT, # 红衫军
	CHINESE_CROUCHING_TIGER, # 虎蹲炮
	MACEDONIAN_HETAIROI, # 伙友骑兵
	ROCKET_ARTILLERY, # 火箭炮
	MUSKETMAN, # 火枪手
	MACHINE_GUN, # 机关枪队
	MECHANIZED_INFANTRY, # 机械化步兵
	BYZANTINE_TAGMA, # 甲胄骑兵
	SWORDSMAN, # 剑客
	NORWEGIAN_BERSERKER, # 狂暴武士
	DIGGER, # 矿工军团
	ROMAN_LEGION, # 罗马军团
	BARBARIAN_HORSE_ARCHER, # 蛮族弓骑手
	BARBARIAN_HORSEMAN, # 蛮族骑手
	AMERICAN_ROUGH_RIDER, # 莽骑兵
	LAHORE_NIHANG, # 尼杭战士
	COLOMBIAN_LLANERO, # 牛仔骑兵
	ARABIAN_MAMLUK, # 奴隶兵
	MAN_AT_ARMS, # 披甲战士
	NUBIAN_PITATI, # 皮塔提弓箭手
	CAVALRY, # 骑兵
	KNIGHT, # 骑士
	HORSEMAN, # 骑手
	SPEARMAN, # 枪兵
	SCYTHIAN_HORSE_ARCHER, # 萨卡弓骑手
	BOMBARD, # 射石炮
	CATAPULT, # 石弩
	EGYPTIAN_CHARIOT_ARCHER, # 世袭贵族战车射手
	TANK, # 坦克
	MAYAN_HULCHE, # 投枪手
	SLINGER, # 投石兵
	TREBUCHET, # 投石机
	WARRIOR_MONK, # 武僧
	JAPANESE_SAMURAI, # 武士
	MODERN_AT, # 现代反坦克组
	MODERN_ARMOR, # 现代坦克
	LINE_INFANTRY, # 线列步兵
	VIETNAMESE_VOI_CHIEN, # 象兵
	AZTEC_EAGLE_WARRIOR, # 雄鹰战士
	FIELD_CANNON, # 野战加农炮
	POLISH_HUSSAR, # 翼骑兵
	WARRIOR, # 勇士
	RANGER, # 游骑兵
	SUMERIAN_WAR_CART, # 战车
	INDIAN_VARU, # 战象
	SCOUT, # 侦察兵
	SPANISH_CONQUISTADOR, # 征服者
	HELICOPTER, # 直升飞机
	HEAVY_CHARIOT, # 重型战车
	GREEK_HOPLITE, # 重装步兵
	BABYLONIAN_SABUM_KIBITTUM, # 主力兵团
	CROSSBOWMAN, # 弩手
	# 平民
	MISSIONARY, # 传教士
	GREAT_ENGINEER, # 大工程师
	GREAT_GENERAL, # 大将军
	GREAT_SCIENTIST, # 大科学家
	GREAT_MERCHANT, # 大商人
	GREAT_ARTIST, # 大艺术家
	GREAT_MUSICIAN, # 大音乐家
	GREAT_PROPHET, # 大预言家
	GREAT_WRITER, # 大作家
	GREAT_ADMIRAL, # 海军统帅
	SPY, # 间谍
	BUILDER, # 建造者
	SETTLER, # 开拓者
	ARCHAEOLOGIST, # 考古学家
	TRADER, # 商人
	GURU, # 上师
	INQUISITOR, # 审判官
	APOSTLE, # 使徒
	NATURALIST, # 自然学家
	COMANDANTE_GENERAL, # 总指挥
	# 支援
	MOBILE_SAM, # 防空导弹车
	ANTIAIR_GUN, # 防空炮
	SIEGE_TOWER, # 攻城塔
	OBSERVATION_BALLOON, # 观测气球
	MILITARY_ENGINEER, # 军事工程师
	BATTERING_RAM, # 破城槌
	MEDIC, # 医疗兵
}


func _init() -> void:
	super._init()
	elem_type = UnitTypeDO
	
	for k in Enum.keys():
		var do := UnitTypeDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.GERMAN_UBOAT:
				do.view_name = "U型潜水艇"
				do.spec_civ = CivTable.Enum.GERMANY
				do.replace_unit_type = Enum.SUBMARINE
				do.upgrade_unit_type = Enum.NUCLEAR_SUBMARINE
				do.category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.move = 3
				do.melee_atk = 65
				do.range_atk = 75
				do.range = 2
				
				do.required_tech = TechTable.Enum.ELECTRICITY
				do.production_cost = 430
				do.gold_cost = 1720
				do.maintenance_fee = 6
			Enum.MISSILE_CRUISER:
				do.view_name = "导弹巡洋舰"
				do.category = UnitCategoryTable.Enum.NAVY_RANGE
				do.move = 5
				do.melee_atk = 75
				do.range_atk = 90
				do.antiair_atk = 110
				do.range = 3
				
				do.required_tech = TechTable.Enum.LASERS
				do.production_cost = 680
				do.gold_cost = 2720
				do.maintenance_fee = 8
			Enum.ENGLISH_SEADOG:
				do.view_name = "海猎犬"
				do.spec_civ = CivTable.Enum.ENGLAND
				do.replace_unit_type = Enum.PRIVATEER
				do.upgrade_unit_type = Enum.SUBMARINE
				do.category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.move = 4
				do.melee_atk = 40
				do.range_atk = 55
				do.range = 2
				
				do.required_civic = CivicTable.Enum.MERCANTILISM
				do.production_cost = 280
				do.gold_cost = 1120
				do.maintenance_fee = 4
			Enum.AIRCRAFT_CARRIER:
				do.view_name = "航空母舰"
				do.category = UnitCategoryTable.Enum.NAVY_CARRIER
				do.move = 3
				do.melee_atk = 65
				do.plane_capacity = 2
				
				do.required_tech = TechTable.Enum.COMBINED_ARMS
				do.production_cost = 540
				do.gold_cost = 2160
				do.maintenance_fee = 7
			Enum.NUCLEAR_SUBMARINE:
				do.view_name = "核潜艇"
				do.category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.move = 4
				do.melee_atk = 80
				do.range_atk = 85
				do.range = 2
				
				do.required_tech = TechTable.Enum.TELECOMMUNICATIONS
				do.production_cost = 680
				do.gold_cost = 2720
				do.maintenance_fee = 8
			Enum.FRIGATE:
				do.view_name = "护卫舰"
				do.upgrade_unit_type = Enum.BATTLESHIP
				do.category = UnitCategoryTable.Enum.NAVY_RANGE
				do.move = 4
				do.melee_atk = 45
				do.range_atk = 55
				do.range = 2
				
				do.required_tech = TechTable.Enum.SQUARE_RIGGING
				do.production_cost = 280
				do.gold_cost = 1120
				do.maintenance_fee = 5
			Enum.BYZANTINE_DROMON:
				do.view_name = "火战船"
				do.spec_civ = CivTable.Enum.BYZANTIUM
				do.replace_unit_type = Enum.QUADRIREME
				do.upgrade_unit_type = Enum.FRIGATE
				do.category = UnitCategoryTable.Enum.NAVY_RANGE
				do.move = 3
				do.melee_atk = 20
				do.range_atk = 25
				do.range = 2
				
				do.required_tech = TechTable.Enum.SHIPBUILDING
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 2
			Enum.GALLEY:
				do.view_name = "桨帆船"
				do.upgrade_unit_type = Enum.CARAVEL
				do.category = UnitCategoryTable.Enum.NAVY_MELEE
				do.move = 3
				do.melee_atk = 30
				
				do.required_tech = TechTable.Enum.SAILING
				do.production_cost = 65
				do.gold_cost = 260
				do.maintenance_fee = 1
			Enum.PORTUGUESE_NAU:
				do.view_name = "克拉克帆船"
				do.spec_civ = CivTable.Enum.PORTUGAL
				do.replace_unit_type = Enum.CARAVEL
				do.upgrade_unit_type = Enum.IRONCLAD
				do.category = UnitCategoryTable.Enum.NAVY_MELEE
				do.move = 4
				do.melee_atk = 55
				do.labor = 2
				
				do.required_tech = TechTable.Enum.CARTOGRAPHY
				do.production_cost = 240
				do.gold_cost = 960
				do.maintenance_fee = 2
				# 可以建造商站
			Enum.BRAZILIAN_MINAS_GERAES:
				do.view_name = "米纳斯吉拉斯"
				do.spec_civ = CivTable.Enum.BRAZIL
				do.replace_unit_type = Enum.BATTLESHIP
				do.upgrade_unit_type = Enum.MISSILE_CRUISER
				do.category = UnitCategoryTable.Enum.NAVY_RANGE
				do.move = 5
				do.melee_atk = 70
				do.range_atk = 80
				do.antiair_atk = 95
				do.range = 3
				
				do.required_civic = CivicTable.Enum.NATIONALISM
				do.production_cost = 430
				do.gold_cost = 1720
				do.maintenance_fee = 6
			Enum.SUBMARINE:
				do.view_name = "潜艇"
				do.upgrade_unit_type = Enum.NUCLEAR_SUBMARINE
				do.category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.move = 3
				do.melee_atk = 65
				do.range_atk = 75
				do.range = 2
				
				do.required_tech = TechTable.Enum.ELECTRICITY
				do.production_cost = 480
				do.gold_cost = 1920
				do.maintenance_fee = 6
			Enum.CARAVEL:
				do.view_name = "轻快帆船"
				do.upgrade_unit_type = Enum.IRONCLAD
				do.category = UnitCategoryTable.Enum.NAVY_MELEE
				do.move = 4
				do.melee_atk = 55
				
				do.required_tech = TechTable.Enum.CARTOGRAPHY
				do.production_cost = 240
				do.gold_cost = 960
				do.maintenance_fee = 4
			Enum.DESTROYER:
				do.view_name = "驱逐舰"
				do.category = UnitCategoryTable.Enum.NAVY_MELEE
				do.move = 4
				do.melee_atk = 85
				do.antiair_atk = 90
				
				do.required_tech = TechTable.Enum.COMBINED_ARMS
				do.production_cost = 540
				do.gold_cost = 2160
				do.maintenance_fee = 7
			Enum.INDONESIAN_JONG:
				do.view_name = "戎克船"
				do.spec_civ = CivTable.Enum.INDONESIA
				do.replace_unit_type = Enum.FRIGATE
				do.upgrade_unit_type = Enum.BATTLESHIP
				do.category = UnitCategoryTable.Enum.NAVY_RANGE
				do.move = 5
				do.melee_atk = 45
				do.range_atk = 55
				do.range = 2
				
				do.required_civic = CivicTable.Enum.MERCENARIES
				do.production_cost = 300
				do.gold_cost = 1200
				do.maintenance_fee = 5
			Enum.PRIVATEER:
				do.view_name = "私掠船"
				do.upgrade_unit_type = Enum.SUBMARINE
				do.category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.move = 4
				do.melee_atk = 40
				do.range_atk = 50
				do.range = 2
				
				do.required_civic = CivicTable.Enum.MERCANTILISM
				do.production_cost = 280
				do.gold_cost = 1120
				do.maintenance_fee = 4
			Enum.QUADRIREME:
				do.view_name = "四段帆船"
				do.upgrade_unit_type = Enum.FRIGATE
				do.category = UnitCategoryTable.Enum.NAVY_RANGE
				do.move = 3
				do.melee_atk = 20
				do.range_atk = 25
				do.range = 1
				
				do.required_tech = TechTable.Enum.SHIPBUILDING
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 2
			Enum.NORWEGIAN_LONGSHIP:
				do.view_name = "维京长船"
				do.spec_leader = LeaderTable.Enum.HARDRADA
				do.replace_unit_type = Enum.GALLEY
				do.upgrade_unit_type = Enum.CARAVEL
				do.category = UnitCategoryTable.Enum.NAVY_MELEE
				do.move = 3
				do.melee_atk = 35
				
				do.required_tech = TechTable.Enum.SAILING
				do.production_cost = 65
				do.gold_cost = 260
				do.maintenance_fee = 1
			Enum.BATTLESHIP:
				do.view_name = "战舰"
				do.upgrade_unit_type = Enum.MISSILE_CRUISER
				do.category = UnitCategoryTable.Enum.NAVY_RANGE
				do.move = 5
				do.melee_atk = 60
				do.range_atk = 70
				do.antiair_atk = 90
				do.range = 3
				
				do.required_tech = TechTable.Enum.STEEL
				do.production_cost = 430
				do.gold_cost = 1720
				do.maintenance_fee = 6
			Enum.IRONCLAD:
				do.view_name = "装甲舰"
				do.upgrade_unit_type = Enum.DESTROYER
				do.category = UnitCategoryTable.Enum.NAVY_MELEE
				do.move = 5
				do.melee_atk = 70
				
				do.required_tech = TechTable.Enum.STEAM_POWER
				do.production_cost = 280
				do.gold_cost = 1520
				do.maintenance_fee = 5
			Enum.AMERICAN_P51:
				do.view_name = "P-51战斗机"
				do.spec_civ = CivTable.Enum.AMERICA
				do.replace_unit_type = Enum.FIGHTER
				do.upgrade_unit_type = Enum.JET_FIGHTER
				do.category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.move = 10
				do.melee_atk = 105
				do.range_atk = 105
				do.range = 5
				
				do.required_district = DistrictTable.Enum.AERODROME
				do.required_tech = TechTable.Enum.ADVANCED_FLIGHT
				do.production_cost = 520
				do.gold_cost = 2080
				do.maintenance_fee = 7
			Enum.BOMBER:
				do.view_name = "轰炸机"
				do.upgrade_unit_type = Enum.JET_BOMBER
				do.category = UnitCategoryTable.Enum.AIR_BOMBER
				do.move = 10
				do.melee_atk = 85
				do.bombard_atk = 110
				do.range = 10
				
				do.required_district = DistrictTable.Enum.AERODROME
				do.required_tech = TechTable.Enum.ADVANCED_FLIGHT
				do.production_cost = 560
				do.gold_cost = 2240
				do.maintenance_fee = 7
			Enum.JET_BOMBER:
				do.view_name = "喷气式轰炸机"
				do.category = UnitCategoryTable.Enum.AIR_BOMBER
				do.move = 15
				do.melee_atk = 90
				do.bombard_atk = 120
				do.range = 15
				
				do.required_district = DistrictTable.Enum.AERODROME
				do.required_tech = TechTable.Enum.STEALTH_TECHNOLOGY
				do.production_cost = 700
				do.gold_cost = 2800
				do.maintenance_fee = 8
			Enum.JET_FIGHTER:
				do.view_name = "喷气式战斗机"
				do.category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.move = 10
				do.melee_atk = 110
				do.range_atk = 110
				do.range = 6
				
				do.required_district = DistrictTable.Enum.AERODROME
				do.required_tech = TechTable.Enum.LASERS
				do.production_cost = 650
				do.gold_cost = 2600
				do.maintenance_fee = 8
			Enum.BIPLANE:
				do.view_name = "双翼机"
				do.upgrade_unit_type = Enum.FIGHTER
				do.category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.move = 6
				do.melee_atk = 80
				do.range_atk = 75
				do.range = 4
				
				do.required_district = DistrictTable.Enum.AERODROME
				do.required_tech = TechTable.Enum.FLIGHT
				do.production_cost = 430
				do.gold_cost = 1720
				do.maintenance_fee = 6
			Enum.FIGHTER:
				do.view_name = "战斗机"
				do.upgrade_unit_type = Enum.JET_FIGHTER
				do.category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.move = 8
				do.melee_atk = 100
				do.range_atk = 100
				do.range = 5
				
				do.required_district = DistrictTable.Enum.AERODROME
				do.required_tech = TechTable.Enum.ADVANCED_FLIGHT
				do.production_cost = 520
				do.gold_cost = 2080
				do.maintenance_fee = 7
			Enum.ETHIOPIAN_OROMO_CAVALRY:
				do.view_name = "奥罗莫骑兵"
				do.spec_civ = CivTable.Enum.ETHIOPIA
				do.replace_unit_type = Enum.HORSEMAN
				do.upgrade_unit_type = Enum.CAVALRY
				do.category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.move = 5
				do.melee_atk = 48
				
				do.required_tech = TechTable.Enum.CASTLES
				do.production_cost = 200
				do.gold_cost = 800
				do.maintenance_fee = 3
			Enum.KONGO_SHIELD_BEARER:
				do.view_name = "奥姆本巴"
				do.spec_civ = CivTable.Enum.KONGO
				do.replace_unit_type = Enum.SWORDSMAN
				do.upgrade_unit_type = Enum.MAN_AT_ARMS
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 38
				
				do.required_tech = TechTable.Enum.IRON_WORKING
				do.production_cost = 110
				do.gold_cost = 440
				do.maintenance_fee = 2
			Enum.INFANTRY:
				do.view_name = "步兵"
				do.upgrade_unit_type = Enum.MECHANIZED_INFANTRY
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 75
				
				do.required_tech = TechTable.Enum.REPLACEABLE_PARTS
				do.production_cost = 430
				do.gold_cost = 1720
				do.maintenance_fee = 6
			Enum.PIKEMAN:
				do.view_name = "长矛兵"
				do.upgrade_unit_type = Enum.AT_CREW
				do.category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.move = 2
				do.melee_atk = 45
				
				do.required_tech = TechTable.Enum.MILITARY_TACTICS
				do.production_cost = 200
				do.gold_cost = 800
				do.maintenance_fee = 3
			Enum.PERSIAN_IMMORTAL:
				do.view_name = "长生军"
				do.spec_civ = CivTable.Enum.PERSIA
				do.replace_unit_type = Enum.SWORDSMAN
				do.upgrade_unit_type = Enum.MAN_AT_ARMS
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 35
				do.range_atk = 25
				do.range = 2
				
				do.required_tech = TechTable.Enum.IRON_WORKING
				do.production_cost = 100
				do.gold_cost = 400
				do.maintenance_fee = 2
			Enum.MACEDONIAN_HYPASPIST:
				do.view_name = "持盾护卫"
				do.spec_civ = CivTable.Enum.MACEDON
				do.replace_unit_type = Enum.SWORDSMAN
				do.upgrade_unit_type = Enum.MAN_AT_ARMS
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 38
				
				do.required_tech = TechTable.Enum.IRON_WORKING
				do.production_cost = 100
				do.gold_cost = 400
				do.maintenance_fee = 2
			Enum.ARTILLERY:
				do.view_name = "大炮"
				do.upgrade_unit_type = Enum.ROCKET_ARTILLERY
				do.category = UnitCategoryTable.Enum.SIEGE
				do.move = 2
				do.melee_atk = 60
				do.bombard_atk = 80
				do.range = 2
				
				do.required_tech = TechTable.Enum.STEEL
				do.production_cost = 430
				do.gold_cost = 1720
				do.maintenance_fee = 6
			Enum.FRENCH_GARDE_IMPERIALE:
				do.view_name = "帝国卫队"
				do.spec_civ = CivTable.Enum.FRANCE
				do.replace_unit_type = Enum.LINE_INFANTRY
				do.upgrade_unit_type = Enum.INFANTRY
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 70
				
				do.required_tech = TechTable.Enum.MILITARY_SCIENCE
				do.production_cost = 360
				do.gold_cost = 1440
				do.maintenance_fee = 5
			Enum.AT_CREW:
				do.view_name = "反坦克组"
				do.upgrade_unit_type = Enum.MODERN_AT
				do.category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.move = 2
				do.melee_atk = 75
				
				do.required_tech = TechTable.Enum.CHEMISTRY
				do.production_cost = 400
				do.gold_cost = 1600
				do.maintenance_fee = 4
			Enum.GAUL_GAESATAE:
				do.view_name = "高卢枪佣兵"
				do.spec_civ = CivTable.Enum.GAUL
				do.replace_unit_type = Enum.WARRIOR
				do.upgrade_unit_type = Enum.MAN_AT_ARMS
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 20
				
				do.production_cost = 60
				do.gold_cost = 240
			Enum.KHMER_DOMREY:
				do.view_name = "高棉战象"
				do.spec_civ = CivTable.Enum.KHMER
				do.replace_unit_type = Enum.TREBUCHET
				do.upgrade_unit_type = Enum.BOMBARD
				do.category = UnitCategoryTable.Enum.SIEGE
				do.move = 2
				do.melee_atk = 40
				do.bombard_atk = 50
				do.range = 2
				
				do.required_tech = TechTable.Enum.MILITARY_ENGINEERING
				do.production_cost = 200
				do.gold_cost = 800
				do.maintenance_fee = 3
			Enum.RUSSIAN_COSSACK:
				do.view_name = "哥萨克骑兵"
				do.spec_civ = CivTable.Enum.RUSSIA
				do.replace_unit_type = Enum.CAVALRY
				do.upgrade_unit_type = Enum.HELICOPTER
				do.category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.move = 5
				do.melee_atk = 67
				
				do.required_tech = TechTable.Enum.MILITARY_SCIENCE
				do.production_cost = 340
				do.gold_cost = 1360
				do.maintenance_fee = 5
			Enum.ARCHER:
				do.view_name = "弓箭手"
				do.upgrade_unit_type = Enum.CROSSBOWMAN
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 2
				do.melee_atk = 15
				do.range_atk = 25
				do.range = 2
				
				do.required_tech = TechTable.Enum.ARCHERY
				do.production_cost = 60
				do.gold_cost = 240
				do.maintenance_fee = 1
			Enum.ENGLISH_REDCOAT:
				do.view_name = "红衫军"
				do.spec_leader = LeaderTable.Enum.VICTORIA
				do.replace_unit_type = Enum.LINE_INFANTRY
				do.upgrade_unit_type = Enum.INFANTRY
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 70
				
				do.required_tech = TechTable.Enum.MILITARY_SCIENCE
				do.production_cost = 360
				do.gold_cost = 1440
				do.maintenance_fee = 5
			Enum.CHINESE_CROUCHING_TIGER:
				do.view_name = "虎蹲炮"
				do.spec_civ = CivTable.Enum.CHINA
				do.replace_unit_type = Enum.CROSSBOWMAN
				do.upgrade_unit_type = Enum.FIELD_CANNON
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 2
				do.melee_atk = 30
				do.range_atk = 50
				do.range = 1
				
				do.required_tech = TechTable.Enum.MACHINERY
				do.production_cost = 140
				do.gold_cost = 560
				do.maintenance_fee = 3
			Enum.MACEDONIAN_HETAIROI:
				do.view_name = "伙友骑兵"
				do.spec_leader = LeaderTable.Enum.ALEXANDER
				do.replace_unit_type = Enum.HORSEMAN
				do.upgrade_unit_type = Enum.KNIGHT
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 4
				do.melee_atk = 36
				
				do.required_tech = TechTable.Enum.HORSEBACK_RIDING
				do.production_cost = 100
				do.gold_cost = 400
				do.maintenance_fee = 2
			Enum.ROCKET_ARTILLERY:
				do.view_name = "火箭炮"
				do.category = UnitCategoryTable.Enum.SIEGE
				do.move = 3
				do.melee_atk = 70
				do.bombard_atk = 100
				do.range = 3
				
				do.required_tech = TechTable.Enum.GUIDANCE_SYSTEMS
				do.production_cost = 680
				do.gold_cost = 2720
				do.maintenance_fee = 8
			Enum.MUSKETMAN:
				do.view_name = "火枪手"
				do.upgrade_unit_type = Enum.LINE_INFANTRY
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 55
				
				do.required_tech = TechTable.Enum.GUNPOWDER
				do.production_cost = 240
				do.gold_cost = 960
				do.maintenance_fee = 4
			Enum.MACHINE_GUN:
				do.view_name = "机关枪队"
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 2
				do.melee_atk = 70
				do.range_atk = 85
				do.range = 2
				
				do.required_tech = TechTable.Enum.ADVANCED_BALLISTICS
				do.production_cost = 540
				do.gold_cost = 2160
				do.maintenance_fee = 6
			Enum.MECHANIZED_INFANTRY:
				do.view_name = "机械化步兵"
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 3
				do.melee_atk = 85
				
				do.required_tech = TechTable.Enum.SATELLITES
				do.production_cost = 650
				do.gold_cost = 2600
				do.maintenance_fee = 8
			Enum.BYZANTINE_TAGMA:
				do.view_name = "甲胄骑兵"
				do.spec_leader = LeaderTable.Enum.BASIL
				do.replace_unit_type = Enum.KNIGHT
				do.upgrade_unit_type = Enum.TANK
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 4
				do.melee_atk = 50
				
				do.required_civic = CivicTable.Enum.DIVINE_RIGHT
				do.production_cost = 180
				do.gold_cost = 720
				do.maintenance_fee = 3
			Enum.SWORDSMAN:
				do.view_name = "剑客"
				do.upgrade_unit_type = Enum.MAN_AT_ARMS
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 35
				
				do.required_tech = TechTable.Enum.IRON_WORKING
				do.production_cost = 90
				do.gold_cost = 360
				do.maintenance_fee = 2
			Enum.NORWEGIAN_BERSERKER:
				do.view_name = "狂暴武士"
				do.spec_civ = CivTable.Enum.NORWAY
				do.replace_unit_type = Enum.MAN_AT_ARMS
				do.upgrade_unit_type = Enum.MUSKETMAN
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 48
				
				do.required_tech = TechTable.Enum.MILITARY_TACTICS
				do.production_cost = 160
				do.gold_cost = 640
				do.maintenance_fee = 3
			Enum.DIGGER:
				do.view_name = "矿工军团"
				do.spec_civ = CivTable.Enum.AUSTRALIA
				do.replace_unit_type = Enum.INFANTRY
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 78
				
				do.required_tech = TechTable.Enum.REPLACEABLE_PARTS
				do.production_cost = 430
				do.gold_cost = 1720
				do.maintenance_fee = 6
			Enum.ROMAN_LEGION:
				do.view_name = "罗马军团"
				do.spec_civ = CivTable.Enum.ROME
				do.replace_unit_type = Enum.SWORDSMAN
				do.upgrade_unit_type = Enum.MAN_AT_ARMS
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 40
				do.labor = 1
				
				do.required_tech = TechTable.Enum.IRON_WORKING
				do.production_cost = 110
				do.gold_cost = 440
				do.maintenance_fee = 2
				# 可以建造古罗马堡垒
			Enum.BARBARIAN_HORSE_ARCHER:
				do.view_name = "蛮族弓骑手"
				do.spec_civ = CivTable.Enum.BARBARIAN
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 3
				do.melee_atk = 10
				do.range_atk = 15
				do.range = 1
				
				do.production_cost = 35
				do.gold_cost = 140
				do.maintenance_fee = 1
			Enum.BARBARIAN_HORSEMAN:
				do.view_name = "蛮族骑手"
				do.spec_civ = CivTable.Enum.BARBARIAN
				do.category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.move = 3
				do.melee_atk = 20
				
				do.production_cost = 40
				do.gold_cost = 160
				do.maintenance_fee = 1
			Enum.AMERICAN_ROUGH_RIDER:
				do.view_name = "莽骑兵"
				do.spec_leader = LeaderTable.Enum.T_ROOSEVELT_ROUGHRIDER
				do.replace_unit_type = Enum.KNIGHT
				do.upgrade_unit_type = Enum.TANK
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 5
				do.melee_atk = 67
				
				do.required_tech = TechTable.Enum.BALLISTICS
				do.production_cost = 385
				do.gold_cost = 1540
				do.maintenance_fee = 2
			Enum.LAHORE_NIHANG:
				do.view_name = "尼杭战士"
				do.spec_city_state = CityStateTable.Enum.LAHORE
				do.category = UnitCategoryTable.Enum.LAHORE_NIHANG
				do.move = 2
				do.melee_atk = 25
				
				do.faith_cost = 200
				do.maintenance_fee = 2
			Enum.COLOMBIAN_LLANERO:
				do.view_name = "牛仔骑兵"
				do.spec_civ = CivTable.Enum.GRAN_COLOMBIA
				do.replace_unit_type = Enum.CAVALRY
				do.upgrade_unit_type = Enum.HELICOPTER
				do.category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.move = 5
				do.melee_atk = 62
				
				do.required_tech = TechTable.Enum.MILITARY_SCIENCE
				do.production_cost = 330
				do.gold_cost = 1320
				do.maintenance_fee = 2
			Enum.ARABIAN_MAMLUK:
				do.view_name = "奴隶兵"
				do.spec_civ = CivTable.Enum.ARABIA
				do.replace_unit_type = Enum.KNIGHT
				do.upgrade_unit_type = Enum.TANK
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 4
				do.melee_atk = 50
				
				do.required_tech = TechTable.Enum.STIRRUPS
				do.production_cost = 180
				do.gold_cost = 720
				do.maintenance_fee = 3
			Enum.MAN_AT_ARMS:
				do.view_name = "披甲战士"
				do.upgrade_unit_type = Enum.MUSKETMAN
				do.category = UnitCategoryTable.Enum.MELEE
				
				do.required_tech = TechTable.Enum.APPRENTICESHIP
				do.production_cost = 160
				do.gold_cost = 640
				do.maintenance_fee = 3
			Enum.NUBIAN_PITATI:
				do.view_name = "皮塔提弓箭手"
				do.spec_civ = CivTable.Enum.NUBIA
				do.replace_unit_type = Enum.ARCHER
				do.upgrade_unit_type = Enum.CROSSBOWMAN
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 3
				do.melee_atk = 17
				do.range_atk = 30
				do.range = 2
				
				do.required_tech = 70
				do.gold_cost = 280
				do.maintenance_fee = 1
			Enum.CAVALRY:
				do.view_name = "骑兵"
				do.upgrade_unit_type = Enum.HELICOPTER
				do.category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.move = 5
				do.melee_atk = 62
				
				do.required_tech = TechTable.Enum.MILITARY_SCIENCE
				do.production_cost = 330
				do.gold_cost = 1320
				do.maintenance_fee = 5
			Enum.KNIGHT:
				do.view_name = "骑士"
				do.upgrade_unit_type = Enum.TANK
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 4
				do.melee_atk = 50
				
				do.required_tech = TechTable.Enum.STIRRUPS
				do.production_cost = 180
				do.gold_cost = 720
				do.maintenance_fee = 3
			Enum.HORSEMAN:
				do.view_name = "骑手"
				do.upgrade_unit_type = Enum.CAVALRY
				do.category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.move = 4
				do.melee_atk = 36
				
				do.required_tech = TechTable.Enum.HORSEBACK_RIDING
				do.production_cost = 80
				do.gold_cost = 320
				do.maintenance_fee = 2
			Enum.SPEARMAN:
				do.view_name = "枪兵"
				do.upgrade_unit_type = Enum.PIKEMAN
				do.category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.move = 2
				do.melee_atk = 25
				
				do.required_tech = TechTable.Enum.BRONZE_WORKING
				do.production_cost = 65
				do.gold_cost = 260
				do.maintenance_fee = 1
			Enum.SCYTHIAN_HORSE_ARCHER:
				do.view_name = "萨卡弓骑手"
				do.spec_civ = CivTable.Enum.SCYTHIA
				do.replace_unit_type = Enum.ARCHER
				do.upgrade_unit_type = Enum.CROSSBOWMAN
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 4
				do.melee_atk = 20
				do.range_atk = 25
				do.range = 1
				
				do.required_tech = TechTable.Enum.HORSEBACK_RIDING
				do.production_cost = 100
				do.gold_cost = 400
				do.maintenance_fee = 2
			Enum.BOMBARD:
				do.view_name = "射石炮"
				do.upgrade_unit_type = Enum.ARTILLERY
				do.category = UnitCategoryTable.Enum.SIEGE
				do.move = 2
				do.melee_atk = 45
				do.bombard_atk = 55
				do.range = 2
				
				do.required_tech = TechTable.Enum.METAL_CASTING
				do.production_cost = 280
				do.gold_cost = 1120
				do.maintenance_fee = 4
			Enum.CATAPULT:
				do.view_name = "石弩"
				do.upgrade_unit_type = Enum.TREBUCHET
				do.category = UnitCategoryTable.Enum.SIEGE
				do.move = 2
				do.melee_atk = 25
				do.bombard_atk = 35
				do.range = 2
				
				do.required_tech = TechTable.Enum.ENGINEERING
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 2
			Enum.EGYPTIAN_CHARIOT_ARCHER:
				do.view_name = "世袭贵族战车射手"
				do.spec_civ = CivTable.Enum.EGYPT
				do.replace_unit_type = Enum.HEAVY_CHARIOT
				do.upgrade_unit_type = Enum.CROSSBOWMAN
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 2
				do.melee_atk = 25
				do.range_atk = 35
				do.range = 2
				
				do.required_tech = TechTable.Enum.WHEEL
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 2
			Enum.TANK:
				do.view_name = "坦克"
				do.upgrade_unit_type = Enum.MODERN_ARMOR
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 4
				do.melee_atk = 85
				
				do.required_tech = TechTable.Enum.COMBUSTION
				do.production_cost = 480
				do.gold_cost = 1920
				do.maintenance_fee = 6
			Enum.MAYAN_HULCHE:
				do.view_name = "投枪手"
				do.spec_civ = CivTable.Enum.MAYA
				do.replace_unit_type = Enum.ARCHER
				do.upgrade_unit_type = Enum.CROSSBOWMAN
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 2
				do.melee_atk = 15
				do.range_atk = 28
				do.range = 2
				
				do.required_tech = TechTable.Enum.ARCHERY
				do.production_cost = 60
				do.gold_cost = 240
				do.maintenance_fee = 1
			Enum.SLINGER:
				do.view_name = "投石兵"
				do.upgrade_unit_type = Enum.ARCHER
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 2
				do.melee_atk = 5
				do.range_atk = 15
				do.range = 1
				
				do.production_cost = 35
				do.gold_cost = 140
			Enum.TREBUCHET:
				do.view_name = "投石机"
				do.upgrade_unit_type = Enum.BOMBARD
				do.category = UnitCategoryTable.Enum.SIEGE
				do.move = 2
				do.melee_atk = 35
				do.bombard_atk = 45
				do.range = 2
				
				do.required_tech = TechTable.Enum.MILITARY_ENGINEERING
				do.production_cost = 200
				do.gold_cost = 800
				do.maintenance_fee = 3
			Enum.WARRIOR_MONK:
				do.view_name = "武僧"
				do.spec_belief = BeliefTable.Enum.WARRIOR_MONKS
				do.category = UnitCategoryTable.Enum.WARRIOR_MONK
				do.move = 3
				do.melee_atk = 40
				
				do.required_building = BuildingTable.Enum.TEMPLE
				do.faith_cost = 200
				do.maintenance_fee = 2
			Enum.JAPANESE_SAMURAI:
				do.view_name = "武士"
				do.spec_civ = CivTable.Enum.JAPAN
				do.upgrade_unit_type = Enum.MUSKETMAN
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 48
				
				do.required_civic = CivicTable.Enum.FEUDALISM
				do.production_cost = 160
				do.gold_cost = 640
				do.maintenance_fee = 3
			Enum.MODERN_AT:
				do.view_name = "现代反坦克组"
				do.category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.move = 3
				do.melee_atk = 85
				
				do.required_tech = TechTable.Enum.COMPOSITES
				do.production_cost = 580
				do.gold_cost = 2320
				do.maintenance_fee = 8
			Enum.MODERN_ARMOR:
				do.view_name = "现代坦克"
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 4
				do.melee_atk = 95
				
				do.required_tech = TechTable.Enum.COMPOSITES
				do.production_cost = 680
				do.gold_cost = 2720
				do.maintenance_fee = 8
			Enum.LINE_INFANTRY:
				do.view_name = "线列步兵"
				do.upgrade_unit_type = Enum.INFANTRY
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 65
				
				do.required_tech = TechTable.Enum.MILITARY_SCIENCE
				do.production_cost = 360
				do.gold_cost = 1440
				do.maintenance_fee = 5
			Enum.VIETNAMESE_VOI_CHIEN:
				do.view_name = "象兵"
				do.spec_civ = CivTable.Enum.VIETNAM
				do.replace_unit_type = Enum.CROSSBOWMAN
				do.upgrade_unit_type = Enum.FIELD_CANNON
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 3
				do.melee_atk = 35
				do.range_atk = 40
				do.range = 2
				
				do.required_tech = TechTable.Enum.MACHINERY
				do.production_cost = 200
				do.gold_cost = 800
				do.maintenance_fee = 3
			Enum.AZTEC_EAGLE_WARRIOR:
				do.view_name = "雄鹰战士"
				do.spec_civ = CivTable.Enum.AZTEC
				do.replace_unit_type = Enum.WARRIOR
				do.upgrade_unit_type = Enum.SWORDSMAN
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 28
				
				do.production_cost = 65
				do.gold_cost = 260
			Enum.FIELD_CANNON:
				do.view_name = "野战加农炮"
				do.upgrade_unit_type = Enum.MACHINE_GUN
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 2
				do.melee_atk = 50
				do.range_atk = 60
				do.range = 2
				
				do.required_tech = TechTable.Enum.BALLISTICS
				do.production_cost = 330
				do.gold_cost = 1320
				do.maintenance_fee = 5
			Enum.POLISH_HUSSAR:
				do.view_name = "翼骑兵"
				do.spec_civ = CivTable.Enum.POLAND
				do.replace_unit_type = Enum.KNIGHT
				do.upgrade_unit_type = Enum.TANK
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 4
				do.melee_atk = 64
				
				do.required_civic = CivicTable.Enum.MERCANTILISM
				do.production_cost = 330
				do.gold_cost = 1320
				do.maintenance_fee = 5
			Enum.WARRIOR:
				do.view_name = "勇士"
				do.upgrade_unit_type = Enum.SWORDSMAN
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 20
				
				do.production_cost = 40
				do.gold_cost = 160
				
				do.icon_64 = "res://assets/civ6_origin/unit/webp_64x64/icon_unit_warrior.webp"
				do.icon_256 = "res://assets/civ6_origin/unit/webp_256x256/icon_unit_warrior.webp"
				do.pic_200 = "res://assets/civ6_origin/unit/png_200/unit_warrior.png"
			Enum.RANGER:
				do.view_name = "游骑兵"
				do.category = UnitCategoryTable.Enum.RECON
				do.move = 3
				do.melee_atk = 45
				do.range_atk = 60
				do.range = 1
				
				do.required_tech = TechTable.Enum.RIFLING
				do.production_cost = 380
				do.gold_cost = 1520
				do.maintenance_fee = 5
			Enum.SUMERIAN_WAR_CART:
				do.view_name = "战车"
				do.spec_civ = CivTable.Enum.SUMERIA
				do.replace_unit_type = Enum.HEAVY_CHARIOT
				do.upgrade_unit_type = Enum.KNIGHT
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 3
				do.melee_atk = 30
				
				do.production_cost = 55
				do.gold_cost = 220
			Enum.INDIAN_VARU:
				do.view_name = "战象"
				do.spec_civ = CivTable.Enum.INDIA
				do.replace_unit_type = Enum.KNIGHT
				do.upgrade_unit_type = Enum.TANK
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 2
				do.melee_atk = 40
				
				do.required_tech = TechTable.Enum.HORSEBACK_RIDING
				do.production_cost = 120
				do.gold_cost = 480
				do.maintenance_fee = 3
			Enum.SCOUT:
				do.view_name = "侦察兵"
				do.upgrade_unit_type = Enum.RANGER
				do.category = UnitCategoryTable.Enum.RECON
				do.move = 3
				do.melee_atk = 10
				
				do.production_cost = 30
				do.gold_cost = 120
				
				do.icon_64 = "res://assets/civ6_origin/unit/webp_64x64/icon_unit_scout.webp"
				do.icon_256 = "res://assets/civ6_origin/unit/webp_256x256/icon_unit_scout.webp"
				# 暂时没有 200 尺寸的单位画像素材
				do.pic_200 = ""
			Enum.SPANISH_CONQUISTADOR:
				do.view_name = "征服者"
				do.spec_civ = CivTable.Enum.SPAIN
				do.replace_unit_type = Enum.MUSKETMAN
				do.upgrade_unit_type = Enum.LINE_INFANTRY
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 2
				do.melee_atk = 58
				
				do.required_tech = TechTable.Enum.GUNPOWDER
				do.production_cost = 250
				do.gold_cost = 1000
				do.maintenance_fee = 4
			Enum.HELICOPTER:
				do.view_name = "直升飞机"
				do.category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.move = 4
				do.melee_atk = 86
				
				do.required_tech = TechTable.Enum.SYNTHETIC_MATERIALS
				do.production_cost = 600
				do.gold_cost = 2400
				do.maintenance_fee = 7
			Enum.HEAVY_CHARIOT:
				do.view_name = "重型战车"
				do.upgrade_unit_type = Enum.KNIGHT
				do.category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.move = 2
				do.melee_atk = 28
				
				do.required_tech = TechTable.Enum.WHEEL
				do.production_cost = 65
				do.gold_cost = 260
				do.maintenance_fee = 1
			Enum.GREEK_HOPLITE:
				do.view_name = "重装步兵"
				do.spec_civ = CivTable.Enum.GREECE
				do.replace_unit_type = Enum.SPEARMAN
				do.upgrade_unit_type = Enum.PIKEMAN
				do.category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.move = 2
				do.melee_atk = 28
				
				do.required_tech = TechTable.Enum.BRONZE_WORKING
				do.production_cost = 65
				do.gold_cost = 260
				do.maintenance_fee = 1
			Enum.BABYLONIAN_SABUM_KIBITTUM:
				do.view_name = "主力兵团"
				do.spec_civ = CivTable.Enum.BABYLON
				do.replace_unit_type = Enum.WARRIOR
				do.upgrade_unit_type = Enum.SWORDSMAN
				do.category = UnitCategoryTable.Enum.MELEE
				do.move = 3
				do.melee_atk = 17
				
				do.production_cost = 35
				do.gold_cost =  140
			Enum.CROSSBOWMAN:
				do.view_name = "弩手"
				do.upgrade_unit_type = Enum.FIELD_CANNON
				do.category = UnitCategoryTable.Enum.RANGE
				do.move = 2
				do.melee_atk = 30
				do.range_atk = 40
				do.range = 2
				
				do.required_tech = TechTable.Enum.MACHINERY
				do.production_cost = 180
				do.gold_cost = 720
				do.maintenance_fee = 3
			Enum.MISSIONARY:
				do.view_name = "传教士"
				do.category = UnitCategoryTable.Enum.RELIGIOUS
				do.move = 4
				do.religion_atk = 100
				do.preach_time = 3
				
				do.required_building = BuildingTable.Enum.SHRINE
				do.faith_cost = 150
			Enum.GREAT_ENGINEER:
				do.view_name = "大工程师"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.GREAT_GENERAL:
				do.view_name = "大将军"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.GREAT_SCIENTIST:
				do.view_name = "大科学家"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.GREAT_MERCHANT:
				do.view_name = "大商人"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
				# do.labor = 1
				# 可以建造公司
			Enum.GREAT_ARTIST:
				do.view_name = "大艺术家"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.GREAT_MUSICIAN:
				do.view_name = "大音乐家"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.GREAT_PROPHET:
				do.view_name = "大预言家"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.GREAT_WRITER:
				do.view_name = "大作家"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.GREAT_ADMIRAL:
				do.view_name = "海军统帅"
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.SPY:
				do.view_name = "间谍"
				do.category = UnitCategoryTable.Enum.SPY
				# 最大升级次数: 3
				do.production_cost = 225
				do.maintenance_fee = 4
				# 间谍任务
				# 反间谍 回合数：16（标准速度）
				# 破坏火箭研究 回合数：8（标准速度） 基础可能性：20% 目标区域：宇航中心
				# 获取信息源 回合数：8（标准速度）
				# 偷窃巨作 回合数：8（标准速度） 基础可能性：20% 目标区域：剧院广场
				# 情报站 回合数：8（标准速度）
				# 招募游击队员 回合数：8（标准速度） 基础可能性：10% 目标区域：社区
				# 破坏生产 回合数：8（标准速度） 基础可能性：35% 目标区域：工业区
				# 抽取资金 回合数：8（标准速度） 基础可能性：56% 目标区域：商业中心
				# 窃取科技提升 回合数：8（标准速度） 基础可能性：35% 目标区域：学院
				# 丧尸爆发 回合数：8（标准速度） 基础可能性：20% 目标区域：市中心
			Enum.BUILDER:
				do.view_name = "建造者"
				do.category = UnitCategoryTable.Enum.CITIZEN
				do.move = 2
				do.labor = 3
				
				do.production_cost = 50
				do.gold_cost = 200
				
				do.icon_64 = "res://assets/civ6_origin/unit/webp_64x64/icon_unit_builder.webp"
				do.icon_256 = "res://assets/civ6_origin/unit/webp_256x256/icon_unit_builder.webp"
				# 暂时没有 200 尺寸的单位画像素材
				do.pic_200 = ""
			Enum.SETTLER:
				do.view_name = "开拓者"
				do.category = UnitCategoryTable.Enum.CITIZEN
				do.move = 2
				
				do.production_cost = 80
				do.gold_cost = 320
				
				# 开拓者暂时没有 64 尺寸的素材
				do.icon_64 = ""
				do.icon_256 = "res://assets/civ6_origin/unit/webp_256x256/icon_unit_settler.webp"
				do.pic_200 = "res://assets/civ6_origin/unit/png_200/unit_settler.png"
			Enum.ARCHAEOLOGIST:
				do.view_name = "考古学家"
				do.category = UnitCategoryTable.Enum.CITIZEN
				do.move = 4
				
				do.required_civic = CivicTable.Enum.NATURAL_HISTORY
				do.required_building = BuildingTable.Enum.MUSEUM_ARTIFACT
				do.production_cost = 400
				do.gold_cost = 1600
			Enum.TRADER:
				do.view_name = "商人"
				do.category = UnitCategoryTable.Enum.TRADER
				
				do.required_civic = CivicTable.Enum.FOREIGN_TRADE
				do.production_cost = 40
				do.gold_cost = 160
			Enum.GURU:
				do.view_name = "上师"
				do.category = UnitCategoryTable.Enum.RELIGIOUS
				do.move = 4
				do.religion_atk = 90
				do.heal_time = 3
				
				do.required_building = BuildingTable.Enum.TEMPLE
				do.faith_cost = 240
			Enum.INQUISITOR:
				do.view_name = "审判官"
				do.category = UnitCategoryTable.Enum.RELIGIOUS # 百科上是单独的类型
				do.move = 4
				do.religion_atk = 75
				do.preach_time = 3
				
				do.required_building = BuildingTable.Enum.TEMPLE
				do.faith_cost = 150
			Enum.APOSTLE:
				do.view_name = "使徒"
				do.category = UnitCategoryTable.Enum.RELIGIOUS
				do.move = 4
				do.religion_atk = 110
				do.preach_time = 3
				
				do.required_building = BuildingTable.Enum.TEMPLE
				do.faith_cost = 400
			Enum.NATURALIST:
				do.view_name = "自然学家"
				do.category = UnitCategoryTable.Enum.CITIZEN
				do.move = 4
				
				do.required_civic = CivicTable.Enum.CONSERVATION
				do.faith_cost = 1600
			Enum.COMANDANTE_GENERAL:
				do.view_name = "总指挥"
				do.spec_civ = CivTable.Enum.GRAN_COLOMBIA
				do.category = UnitCategoryTable.Enum.GREAT_PERSON
				do.move = 4
			Enum.MOBILE_SAM:
				do.view_name = "防空导弹车"
				do.category = UnitCategoryTable.Enum.SUPPORT
				do.move = 3
				do.antiair_atk = 100
				do.range = 1
				
				do.required_tech = TechTable.Enum.GUIDANCE_SYSTEMS
				do.production_cost = 590
				do.gold_cost = 2360
				do.maintenance_fee = 4
			Enum.ANTIAIR_GUN:
				do.view_name = "防空炮"
				do.upgrade_unit_type = Enum.MOBILE_SAM
				do.category = UnitCategoryTable.Enum.SUPPORT
				do.move = 2
				do.antiair_atk = 90
				do.range = 1
				
				do.required_tech = TechTable.Enum.ADVANCED_BALLISTICS
				do.production_cost = 455
				do.gold_cost = 1820
				do.maintenance_fee = 2
			Enum.SIEGE_TOWER:
				do.view_name = "攻城塔"
				do.upgrade_unit_type = Enum.MEDIC
				# 随着发展会被以下替代： 土木工程
				do.category = UnitCategoryTable.Enum.SUPPORT
				do.move = 2
				
				do.required_tech = TechTable.Enum.CONSTRUCTION
				do.production_cost = 100
				do.gold_cost = 400
				do.maintenance_fee = 2
			Enum.OBSERVATION_BALLOON:
				do.view_name = "观测气球"
				do.category = UnitCategoryTable.Enum.SUPPORT
				do.move = 2
				
				do.required_tech = TechTable.Enum.FLIGHT
				do.production_cost = 240
				do.gold_cost = 960
				do.maintenance_fee = 2
			Enum.MILITARY_ENGINEER:
				do.view_name = "军事工程师"
				do.category = UnitCategoryTable.Enum.SUPPORT
				do.move = 2
				do.labor = 2
				
				do.required_tech = TechTable.Enum.MILITARY_ENGINEERING
				do.required_building = BuildingTable.Enum.ARMORY
				do.production_cost = 170
				do.gold_cost = 680
				do.maintenance_fee = 2
			Enum.BATTERING_RAM:
				do.view_name = "破城槌"
				do.upgrade_unit_type = Enum.MEDIC
				# 随着发展会被以下替代： 土木工程
				do.category = UnitCategoryTable.Enum.SUPPORT
				do.move = 2
				
				do.required_tech = TechTable.Enum.MASONRY
				do.production_cost = 65
				do.gold_cost = 260
				do.maintenance_fee = 1
			Enum.MEDIC:
				do.view_name = "医疗兵"
				do.category = UnitCategoryTable.Enum.SUPPORT
				do.move = 2
				
				do.required_tech = TechTable.Enum.SANITATION
				do.production_cost = 370
				do.gold_cost = 1480
				do.maintenance_fee = 5
		super.init_insert(do)

