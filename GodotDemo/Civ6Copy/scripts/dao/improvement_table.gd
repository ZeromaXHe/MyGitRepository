class_name ImprovementTable
extends MySimSQL.EnumTable


enum Enum {
	ALCAZAR, # 阿卡萨城堡
	BATEY, # 巴特依
	FORT, # 堡垒
	PAIRIDAEZA, # 波斯庭院
	QUARRY, # 采石场
	GREAT_WALL, # 长城
	CHATEAU, # 城堡
	MISSION, # 传教团
	MAHAVIHARA, # 大寺
	HACIENDA, # 大庄园
	MISSILE_SILO, # 导弹发射井
	ROCK_HEWN_CHURCH, # 独石教堂
	LUMBER_MILL, # 伐木场
	AIRSTRIP, # 飞机跑道
	KURGAN, # 坟墩
	KAMPUNG, # 甘榜屋
#	CORPORATION, # 公司
	ROMAN_FORT, # 古罗马堡垒
	BEACH_RESORT, # 海滨度假区
	OFFSHORE_OIL_RIG, # 海上石油钻机
	ZIGGURAT, # 金字形神塔
	COLOSSAL_HEAD, # 巨神头像
	MINE, # 矿山
#	ANCIENT_TOWER_DEFENSE, # 路障
	PASTURE, # 牧场
	OUTBACK_STATION, # 内陆牧场
	FARM, # 农场
	PYRAMID, # 努比亚金字塔
#	MODERN_TOWER_DEFENSE, # 强化路障
	FEITORIA, # 商站
	SPHINX, # 狮身人面像
	STEPWELL, # 梯井
#	MODERN_TRAP_DEFENSE, # 现代陷阱
#	ANCIENT_TRAP_DEFENSE, # 陷阱
#	INDUSTRY, # 行业
	MONASTERY, # 修道院
	CAMP, # 营地
	OIL_WELL, # 油井
	FISHING_BOATS, # 渔船
	TRADING_DOME, # 圆顶市集
	PLANTATION, # 种植园
}


func _init() -> void:
	super._init()
	elem_type = ImprovementDO
	
	for k in Enum.keys():
		var do := ImprovementDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.ALCAZAR:
				do.view_name = "阿卡萨城堡"
				do.spec_city_state = CityStateTable.Enum.GRANADA
				do.culture = 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.BATEY:
				do.view_name = "巴特依"
				do.spec_city_state = CityStateTable.Enum.CAGUANA
				do.culture = 1
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.CULTURE
				do.adjoining_bonus[0].district_dict = {
					DistrictTable.Enum.ENTERTAINMENT_COMPLEX: 1, # “探索”市政后变成 2
				}
				do.adjoining_bonus[0].resource_bonus = 1 # “探索”市政后变成 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.FORT:
				do.view_name = "堡垒"
				do.required_tech = TechTable.Enum.SIEGE_TACTICS
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.MILITARY_ENGINEER
			Enum.PAIRIDAEZA:
				do.view_name = "波斯庭院"
				do.culture = 1 # "外交部门"市政后 +1
				do.gold = 2
				do.charm_influence = 1
				do.adjoining_bonus = [AdjoiningBonusDTO.new(), AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.GOLD
				do.adjoining_bonus[0].district_dict = {
					DistrictTable.Enum.ENTERTAINMENT_COMPLEX: 1,
				}
				do.adjoining_bonus[0].center_bonus = 1
				do.adjoining_bonus[1].bonus_type = YieldDTO.Enum.CULTURE
				do.adjoining_bonus[1].district_dict = {
					DistrictTable.Enum.HOLY_SITE: 1,
					DistrictTable.Enum.THEATER: 1,
				}
				
				do.required_civic = CivicTable.Enum.EARLY_EMPIRE
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.QUARRY:
				do.view_name = "采石场"
				do.production = 1 # +1 生产力（需要火箭研究）
				# +2 金币（需要银行业）
				do.charm_influence = -1
				
				do.required_tech = TechTable.Enum.MINING
				do.placeable_resources = [
					ResourceTable.Enum.GYPSUM,
					ResourceTable.Enum.MARBLE,
					ResourceTable.Enum.STONE,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.GREAT_WALL:
				do.view_name = "长城"
				do.spec_civ = CivTable.Enum.CHINA
				# 相邻加成
				# +1 金币，来自每个相邻的长城单元格。需要砌砖。
				# +1 文化值，来自每个相邻的长城单元格。需要城堡。
				
				do.required_tech = TechTable.Enum.MASONRY
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.CHATEAU:
				do.view_name = "城堡"
				do.spec_civ = CivTable.Enum.FRANCE
				do.culture = 2
				do.gold = 1
				do.charm_influence = 1
				do.adjoining_bonus = [AdjoiningBonusDTO.new(), AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.GOLD
				do.adjoining_bonus[0].river_tile_bonus = 2
				do.adjoining_bonus[1].bonus_type = YieldDTO.Enum.CULTURE
				do.adjoining_bonus[1].wonder_bonus = 1 # +2 文化值，来自每个相邻的奇观单元格。需要飞行。
				
				do.required_civic = CivicTable.Enum.HUMANISM
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.MISSION:
				do.view_name = "传教团"
				do.spec_civ = CivTable.Enum.SPAIN
				do.faith = 2
				# +2 科技值（需要文化遗产）
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.SCIENCE
				do.adjoining_bonus[0].district_dict = {
					DistrictTable.Enum.HOLY_SITE: 1,
					DistrictTable.Enum.CAMPUS: 1,
				}
				
				do.required_tech = TechTable.Enum.EDUCATION
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.MAHAVIHARA:
				do.view_name = "大寺"
				do.spec_city_state = CityStateTable.Enum.NALANDA
				do.science = 2
				do.housing = 1
				do.adjoining_bonus = [AdjoiningBonusDTO.new(), AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.SCIENCE
				do.adjoining_bonus[0].district_dict = {
					DistrictTable.Enum.CAMPUS: 1, # +2 科技值，来自每个相邻的学院单元格。需要科学理论。
					DistrictTable.Enum.OBSERVATORY: 1, # +2 科技值，来自每个相邻的天文台单元格。需要科学理论。
				}
				do.adjoining_bonus[1].bonus_type = YieldDTO.Enum.FAITH
				do.adjoining_bonus[1].district_dict = {
					DistrictTable.Enum.HOLY_SITE: 1,
					DistrictTable.Enum.LAVRA: 1,
				}
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.HACIENDA:
				do.view_name = "大庄园"
				do.spec_civ = CivTable.Enum.GRAN_COLOMBIA
				do.gold = 2
				do.production = 1
				do.housing = 0.5
				do.adjoining_bonus = [AdjoiningBonusDTO.new(), AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.FOOD
				do.adjoining_bonus[0].two_plantation_bonus = 1 # +1 食物，来自每个相邻的种植园单元格。需要零件规格化。
				do.adjoining_bonus[1].bonus_type = YieldDTO.Enum.PRODUCTION
				do.adjoining_bonus[1].two_hacienda_bonus = 1 # +1 生产力，来自每个相邻的大庄园单元格。需要紧急部署。
				
				do.required_civic = CivicTable.Enum.MERCANTILISM
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.MISSILE_SILO:
				do.view_name = "导弹发射井"
				do.weapon_capacity = 1
				
				do.required_tech = TechTable.Enum.ROCKETRY
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.MILITARY_ENGINEER
			Enum.ROCK_HEWN_CHURCH:
				do.view_name = "独石教堂"
				do.spec_civ = CivTable.Enum.ETHIOPIA
				do.faith = 1
				do.charm_influence = 1
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.FAITH
				do.adjoining_bonus[0].terrain_dict = {
					TerrainTable.Enum.GRASS_HILL: 1,
					TerrainTable.Enum.PLAIN_HILL: 1,
					TerrainTable.Enum.DESERT_HILL: 1,
					TerrainTable.Enum.TUNDRA_HILL: 1,
					TerrainTable.Enum.SNOW_HILL: 1,
					TerrainTable.Enum.GRASS_MOUNTAIN: 1,
					TerrainTable.Enum.PLAIN_MOUNTAIN: 1,
					TerrainTable.Enum.DESERT_MOUNTAIN: 1,
					TerrainTable.Enum.TUNDRA_MOUNTAIN: 1,
					TerrainTable.Enum.SNOW_MOUNTAIN: 1,
				}
				
				do.required_civic = CivicTable.Enum.DRAMA_POETRY
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.LUMBER_MILL:
				do.view_name = "伐木场"
				do.production = 1 # +1 生产力（需要钢铁）
				
				do.required_tech = TechTable.Enum.MACHINERY
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
				] as Array[LandscapeTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.AIRSTRIP:
				do.view_name = "飞机跑道"
				do.plane_capacity = 3
				do.charm_influence = -1
				
				do.required_tech = TechTable.Enum.FLIGHT
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.MILITARY_ENGINEER
			Enum.KURGAN:
				do.view_name = "坟墩"
				do.spec_civ = CivTable.Enum.SCYTHIA
				do.gold = 3
				do.faith = 1
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.FAITH
				do.adjoining_bonus[0].improvement_dict = {
					Enum.PASTURE: 1, # +2 信仰值，来自每个相邻的牧场单元格。需要马镫。
				}
				
				do.required_tech = TechTable.Enum.ANIMAL_HUSBANDRY
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.KAMPUNG:
				do.view_name = "甘榜屋"
				do.spec_civ = CivTable.Enum.INDONESIA
				do.production = 1 # +1 生产力（需要土木工程）
				do.housing = 1
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.FOOD
				do.adjoining_bonus[0].improvement_dict = {
					Enum.FISHING_BOATS: 1,
				}
				
				do.required_tech = TechTable.Enum.SHIPBUILDING
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.ROMAN_FORT:
				do.view_name = "古罗马堡垒"
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.ROMAN_LEGION
			Enum.BEACH_RESORT:
				do.view_name = "海滨度假区"
				
				do.required_tech = TechTable.Enum.RADIO
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.OFFSHORE_OIL_RIG:
				do.view_name = "海上石油钻机"
				do.production = 2
				do.charm_influence = -1
				
				do.required_tech = TechTable.Enum.PLASTICS
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
					TerrainTable.Enum.OCEAN,
				] as Array[TerrainTable.Enum]
				do.placeable_resources = [
					ResourceTable.Enum.OIL,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.ZIGGURAT:
				do.view_name = "金字形神塔"
				do.spec_civ = CivTable.Enum.SUMERIA
				do.science = 2
				# +1 文化值（需要自然历史）
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.COLOSSAL_HEAD:
				do.view_name = "巨神头像"
				do.spec_city_state = CityStateTable.Enum.LA_VENTA
				do.faith = 2
				# +1 文化值（需要人文主义）
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.FAITH
				do.adjoining_bonus[0].two_forest_bonus = 1
				do.adjoining_bonus[0].two_rainforest_bonus = 1
				
				do.required_tech = TechTable.Enum.MASONRY
				do.required_civic = CivicTable.Enum.HUMANISM
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.MINE:
				do.view_name = "矿山"
				do.production = 1 # +1 生产力（需要学徒） +1 生产力（需要工业化）
				do.charm_influence = -1
				
				do.required_tech = TechTable.Enum.MINING
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.placeable_resources = [
					ResourceTable.Enum.COPPER,
					ResourceTable.Enum.DIAMOND,
					ResourceTable.Enum.JADE,
					ResourceTable.Enum.SILVER,
					ResourceTable.Enum.SALT,
					ResourceTable.Enum.SILVER,
					ResourceTable.Enum.ALUMINIUM,
					ResourceTable.Enum.COAL,
					ResourceTable.Enum.IRON,
					ResourceTable.Enum.SALTPETER,
					ResourceTable.Enum.URANIUM,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.PASTURE:
				do.view_name = "牧场"
				do.production = 1 # +1 生产力（需要机器人技术）
				do.housing = 0.5
				# +1 食物（需要马镫）
				# 相邻加成
				# +1 生产力，来自每个相邻的内陆牧场单元格。需要蒸汽动力。
				
				do.required_tech = TechTable.Enum.ANIMAL_HUSBANDRY
				do.placeable_resources = [
					ResourceTable.Enum.COW,
					ResourceTable.Enum.SHEEP,
					ResourceTable.Enum.HORSE,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.OUTBACK_STATION:
				do.view_name = "内陆牧场"
				do.spec_civ = CivTable.Enum.AUSTRALIA
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.FOOD
				do.adjoining_bonus[0].improvement_dict = {
					Enum.PASTURE: 1,
				}
				# 相邻加成
				# +1 生产力，来自每2个相邻内陆牧场单元格。需要蒸汽动力。
				# +1 食物，来自每2个相邻内陆牧场单元格。需要紧急部署。
				
				do.required_civic = CivicTable.Enum.GUILDS
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.FARM:
				do.view_name = "农场"
				do.food = 1
				do.housing = 0.5
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.PRODUCTION
				do.adjoining_bonus[0].district_dict = {
					DistrictTable.Enum.OBSERVATORY: 1,
				}
				# 相邻加成
				# +1 食物，来自每2个相邻农场单元格。需要封建主义。随着零件规格化的出现，代替了之前的政策。
				# +1 食物，来自每个相邻的农场单元格。需要零件规格化。
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.placeable_resources = [
					ResourceTable.Enum.RICE,
					ResourceTable.Enum.WHEAT,
					ResourceTable.Enum.CORN,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.PYRAMID:
				do.view_name = "努比亚金字塔"
				do.spec_civ = CivTable.Enum.NUBIA
				do.faith = 2
				do.food = 2
				do.adjoining_bonus = [
					AdjoiningBonusDTO.new(), # 0
					AdjoiningBonusDTO.new(), # 1
					AdjoiningBonusDTO.new(), # 2
					AdjoiningBonusDTO.new(), # 3
					AdjoiningBonusDTO.new(), # 4
					AdjoiningBonusDTO.new(), # 5
				] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.FOOD
				do.adjoining_bonus[0].district_dict = {
					DistrictTable.Enum.CITY_CENTER: 1,
				}
				do.adjoining_bonus[1].bonus_type = YieldDTO.Enum.SCIENCE
				do.adjoining_bonus[1].district_dict = {
					DistrictTable.Enum.CAMPUS: 1,
				}
				do.adjoining_bonus[2].bonus_type = YieldDTO.Enum.GOLD
				do.adjoining_bonus[2].district_dict = {
					DistrictTable.Enum.COMMERCIAL_HUB: 1,
					DistrictTable.Enum.HARBOR: 1,
				}
				do.adjoining_bonus[3].bonus_type = YieldDTO.Enum.FAITH
				do.adjoining_bonus[3].district_dict = {
					DistrictTable.Enum.HOLY_SITE: 1,
				}
				do.adjoining_bonus[4].bonus_type = YieldDTO.Enum.PRODUCTION
				do.adjoining_bonus[4].district_dict = {
					DistrictTable.Enum.INDUSTRIAL_ZONE: 1,
				}
				do.adjoining_bonus[5].bonus_type = YieldDTO.Enum.CULTURE
				do.adjoining_bonus[5].district_dict = {
					DistrictTable.Enum.THEATER: 1,
				}
				
				do.required_tech = TechTable.Enum.MASONRY
				do.placeable_terrains = [
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.FEITORIA:
				do.view_name = "商站"
				do.spec_civ = CivTable.Enum.PORTUGAL
				do.gold = 4
				do.production = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.PORTUGUESE_NAU
			Enum.SPHINX:
				do.view_name = "狮身人面像"
				do.spec_civ = CivTable.Enum.EGYPT
				do.culture = 1 # +1 文化值（需要自然历史）
				do.faith = 1
				do.charm_influence = 1
				
				do.required_civic = CivicTable.Enum.CRAFTSMANSHIP
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.STEPWELL:
				do.view_name = "梯井"
				do.spec_civ = CivTable.Enum.INDIA
				do.food = 1 # +1 食物（需要职业体育）
				do.housing = 1
				# +1 信仰值（需要封建主义）
				
				do.required_tech = TechTable.Enum.IRRIGATION
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.MONASTERY:
				do.view_name = "修道院"
				do.spec_city_state = CityStateTable.Enum.ARMAGH
				do.faith = 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.CAMP:
				do.view_name = "营地"
				do.gold = 1
				do.housing = 0.5
				# +1 生产力（需要重商主义）
				# +1 金币（需要合成材料）
				# +1 食物（需要重商主义）
				
				do.required_tech = TechTable.Enum.ANIMAL_HUSBANDRY
				do.placeable_resources = [
					ResourceTable.Enum.DEER,
					ResourceTable.Enum.FUR,
					ResourceTable.Enum.IVORY,
					ResourceTable.Enum.TRUFFLE,
					ResourceTable.Enum.HONEY,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.OIL_WELL:
				do.view_name = "油井"
				do.production = 2
				do.charm_influence = -1
				
				do.required_tech = TechTable.Enum.STEEL
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.placeable_resources = [
					ResourceTable.Enum.OIL,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.FISHING_BOATS:
				do.view_name = "渔船"
				do.food = 1
				do.housing = 0.5
				# +2 金币（需要制图学）
				# +1 食物（需要塑料）
				
				do.required_tech = TechTable.Enum.SAILING
				do.placeable_resources = [
					ResourceTable.Enum.CRAB,
					ResourceTable.Enum.FISH,
					ResourceTable.Enum.PEARL,
					ResourceTable.Enum.WHALE,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.TRADING_DOME:
				do.view_name = "圆顶市集"
				do.spec_city_state = CityStateTable.Enum.SAMARKAND
				do.gold = 2
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.GOLD
				do.adjoining_bonus[0].resource_category_dict = {
					ResourceTable.Category.LUXURY: 1,
				}
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
			Enum.PLANTATION:
				do.view_name = "种植园"
				do.gold = 2
				do.housing = 0.5
				# +1  食物（需要科学理论）
				# +2  金币（需要全球化）
				do.adjoining_bonus = [AdjoiningBonusDTO.new()] as Array[AdjoiningBonusDTO]
				do.adjoining_bonus[0].bonus_type = YieldDTO.Enum.PRODUCTION
				do.adjoining_bonus[0].two_hacienda_bonus = 1
				# +1 生产力，来自每个相邻的大庄园单元格。需要紧急部署。
				
				do.required_tech = TechTable.Enum.IRRIGATION
				do.placeable_resources = [
					ResourceTable.Enum.BANANA,
					ResourceTable.Enum.ORANGE,
					ResourceTable.Enum.COCOA_BEAN,
					ResourceTable.Enum.COFFEE,
					ResourceTable.Enum.COTTON,
					ResourceTable.Enum.DYE,
					ResourceTable.Enum.INCENSE,
					ResourceTable.Enum.SILK,
					ResourceTable.Enum.SPICE,
					ResourceTable.Enum.SUGAR,
					ResourceTable.Enum.TEA,
					ResourceTable.Enum.TOBACCO,
					ResourceTable.Enum.WINE,
				] as Array[ResourceTable.Enum]
				do.built_by = UnitTypeTable.Enum.BUILDER
		super.init_insert(do)
