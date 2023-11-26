class_name DistrictTable
extends MySimSQL.EnumTable


enum Enum {
	OPPIDUM, # 奥皮杜姆
	PRESERVE, # 保护区
	THANH, # 城池
	HARBOR, # 港口
	INDUSTRIAL_ZONE, # 工业区
	AERODROME, # 航空港
	ROYAL_NAVY_DOCKYARD, # 皇家海军船坞
	STREET_CARNIVAL, # 街头狂欢节
	THEATER, # 剧院广场
	ENCAMPMENT, # 军营
	LAVRA, # 拉夫拉修道院
	MBANZA, # 姆班赞
	HIPPODROME, # 跑马场
	HANSA, # 商业同业工会
	COMMERCIAL_HUB, # 商业中心
	NEIGHBORHOOD, # 社区
	HOLY_SITE, # 圣地
	CITY_CENTER, # 市中心
	AQUEDUCT, # 水渠
	OBSERVATORY, # 天文台
	DIPLOMATIC_QUARTER, # 外交区
	ACROPOLIS, # 卫城
	CAMPUS, # 学院
	ENTERTAINMENT_COMPLEX, # 娱乐中心
	SPACEPORT, # 宇航中心
	BATH, # 浴场
}


func _init() -> void:
	super._init()
	elem_type = DistrictDO
	
	for k in Enum.keys():
		var do = DistrictDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.OPPIDUM:
				do.view_name = "奥皮杜姆"
				do.spec_civ = CivTable.Enum.GAUL
				do.replace_district = Enum.INDUSTRIAL_ZONE
				do.engineer_point = 1
				do.charm_influence = -1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.PRODUCTION
				do.adjoining_bonus.improvement_dict = {
					ImprovementTable.Enum.QUARRY: 2
				}
				do.adjoining_bonus.resource_category_dict = {
					ResourceTable.Category.STRATEGY: 2
				}
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.production = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.production = 1
				
				do.required_tech = TechTable.Enum.IRON_WORKING
				do.production_cost = 27
				do.maintenance_fee = 1
			Enum.PRESERVE:
				do.view_name = "保护区"
				do.housing = 1
				do.charm_influence = 1
				do.required_civic = CivicTable.Enum.MYSTICISM
				do.adjoin_center = -1
				do.production_cost = 54
			Enum.THANH:
				do.view_name = "城池"
				do.spec_civ = CivTable.Enum.VIETNAM
				do.replace_district = Enum.ENCAMPMENT
				do.charm_influence = -1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.CULTURE
				do.adjoining_bonus.district_bonus = 2
				do.adjoining_bonus.district_bonus_threshold = 1
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.gold = 2
				do.citizen_yield.production = 1
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.production = 1
				
				do.required_tech = TechTable.Enum.BRONZE_WORKING
				do.adjoin_center = -1
				do.production_cost = 27
				do.maintenance_fee = 1
			Enum.HARBOR:
				do.view_name = "港口"
				do.admiral_point = 1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.GOLD
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				do.adjoining_bonus.resource_dict = {
					# +1 金币，来自每个相邻的海岸资源单元格。
					ResourceTable.Enum.CRAB: 1,
					ResourceTable.Enum.WHALE: 1,
					ResourceTable.Enum.PEARL: 1,
					ResourceTable.Enum.FISH: 1,
				}
				do.adjoining_bonus.center_bonus = 2
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.gold = 2
				do.citizen_yield.food = 1
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.gold = 3
				
				do.required_tech = TechTable.Enum.CELESTIAL_NAVIGATION
				do.on_close_shore = true
				do.production_cost = 54
			Enum.INDUSTRIAL_ZONE:
				do.view_name = "工业区"
				do.engineer_point = 1
				do.charm_influence = -1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.PRODUCTION
				do.adjoining_bonus.improvement_dict = {
					ImprovementTable.Enum.QUARRY: 1,
					ImprovementTable.Enum.MINE: 1,
				}
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.production = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.production = 1
				
				do.required_tech = TechTable.Enum.APPRENTICESHIP
				do.production_cost = 54
				do.maintenance_fee = 1
			Enum.AERODROME:
				do.view_name = "航空港"
				do.plane_capacity = 4
				do.charm_influence = -1
				do.required_tech = TechTable.Enum.FLIGHT
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 54
				do.maintenance_fee = 1
			Enum.ROYAL_NAVY_DOCKYARD:
				do.view_name = "皇家海军船坞"
				do.spec_civ = CivTable.Enum.ENGLAND
				do.admiral_point = 2
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.GOLD
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				do.adjoining_bonus.resource_dict = {
					# +1 金币，来自每个相邻的海岸资源单元格。
					ResourceTable.Enum.CRAB: 1,
					ResourceTable.Enum.WHALE: 1,
					ResourceTable.Enum.PEARL: 1,
					ResourceTable.Enum.FISH: 1,
				}
				do.adjoining_bonus.center_bonus = 2
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.gold = 2
				do.citizen_yield.food = 1
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.gold = 3
				
				do.required_tech = TechTable.Enum.CELESTIAL_NAVIGATION
				do.on_close_shore = true
				do.production_cost = 27
			Enum.STREET_CARNIVAL:
				do.view_name = "街头狂欢节"
				do.spec_civ = CivTable.Enum.BRAZIL
				do.replace_district = Enum.ENTERTAINMENT_COMPLEX
				do.amuse_amenity = 2
				do.charm_influence = 1
				
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.food = 1
				
				do.required_civic = CivicTable.Enum.GAMES_RECREATION
				do.production_cost = 27
				do.maintenance_fee = 1
			Enum.THEATER:
				do.view_name = "剧院广场"
				do.writer_point = 1
				do.artist_point = 1
				do.musician_point = 1
				do.charm_influence = 1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.CULTURE
				do.adjoining_bonus.wonder_bonus = 1
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.culture = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.culture = 1
				
				do.required_civic = CivicTable.Enum.DRAMA_POETRY
				do.production_cost = 54
				do.maintenance_fee = 1
			Enum.ENCAMPMENT:
				do.view_name = "军营"
				do.general_point = 1
				do.charm_influence = -1
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.gold = 2
				do.citizen_yield.production = 1
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.production = 1
				
				do.required_tech = TechTable.Enum.BRONZE_WORKING
				do.adjoin_center = -1
				do.production_cost = 54
				do.maintenance_fee = 1
			Enum.LAVRA:
				do.view_name = "拉夫拉修道院"
				do.spec_civ = CivTable.Enum.RUSSIA
				do.replace_district = Enum.HOLY_SITE
				do.prophet_point = 2
				do.charm_influence = 1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.FAITH
				do.adjoining_bonus.natural_wonder_bonus = 2
				do.adjoining_bonus.terrain_dict = {
					TerrainTable.Enum.GRASS_MOUNTAIN: 1,
					TerrainTable.Enum.PLAIN_MOUNTAIN: 1,
					TerrainTable.Enum.DESERT_MOUNTAIN: 1,
					TerrainTable.Enum.TUNDRA_MOUNTAIN: 1,
					TerrainTable.Enum.SNOW_MOUNTAIN: 1,
				}
				do.adjoining_bonus.two_forest_bonus = 1
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.faith = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.faith = 1
				
				do.required_tech = TechTable.Enum.ASTROLOGY
				do.production_cost = 27
				do.maintenance_fee = 1
			Enum.MBANZA:
				do.view_name = "姆班赞"
				do.spec_civ = CivTable.Enum.KONGO
				# +2 食物 +4 金币
				do.housing = 5
				
				do.required_civic = CivicTable.Enum.GUILDS
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.production_cost = 27
			Enum.HIPPODROME:
				do.view_name = "跑马场"
				do.spec_civ = CivTable.Enum.BYZANTIUM
				do.replace_district = Enum.ENTERTAINMENT_COMPLEX
				do.amuse_amenity = 3
				do.charm_influence = 1
				
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.food = 1
				
				do.required_civic = CivicTable.Enum.GAMES_RECREATION
				do.production_cost = 27
				do.maintenance_fee = 1
			Enum.HANSA:
				do.view_name = "商业同业工会"
				do.replace_district = Enum.INDUSTRIAL_ZONE
				do.engineer_point = 1
				do.charm_influence = -1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.PRODUCTION
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				do.adjoining_bonus.district_dict = {
					Enum.COMMERCIAL_HUB: 2
				}
				do.adjoining_bonus.resource_bonus = 1
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.production = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.production = 1
				
				do.required_tech = TechTable.Enum.APPRENTICESHIP
				do.production_cost = 27
				do.maintenance_fee = 1
			Enum.COMMERCIAL_HUB:
				do.view_name = "商业中心"
				do.merchant_point = 1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.GOLD
				do.adjoining_bonus.river_tile_bonus = 2
				do.adjoining_bonus.district_dict = {
					Enum.HARBOR: 2,
					Enum.ROYAL_NAVY_DOCKYARD: 2,
				}
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.gold = 4
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.gold = 3
				
				do.required_tech = TechTable.Enum.CURRENCY
				do.production_cost = 54
			Enum.NEIGHBORHOOD:
				do.view_name = "社区"
				do.housing = 4
				
				do.required_civic = CivicTable.Enum.URBANIZATION
				do.production_cost = 54
			Enum.HOLY_SITE:
				do.view_name = "圣地"
				do.prophet_point = 1
				do.charm_influence = 1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.FAITH
				do.adjoining_bonus.natural_wonder_bonus = 2
				do.adjoining_bonus.terrain_dict = {
					TerrainTable.Enum.GRASS_MOUNTAIN: 1,
					TerrainTable.Enum.PLAIN_MOUNTAIN: 1,
					TerrainTable.Enum.DESERT_MOUNTAIN: 1,
					TerrainTable.Enum.TUNDRA_MOUNTAIN: 1,
					TerrainTable.Enum.SNOW_MOUNTAIN: 1,
				}
				do.adjoining_bonus.two_forest_bonus = 1
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.faith = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.faith = 1
				
				do.required_tech = TechTable.Enum.ASTROLOGY
				do.production_cost = 54
				do.maintenance_fee = 1
			Enum.CITY_CENTER:
				do.view_name = "市中心"
				do.plane_capacity = 1
				
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.gold = 3
				
				do.production_cost = 54
			Enum.AQUEDUCT:
				do.view_name = "水渠"
				
				do.required_tech = TechTable.Enum.ENGINEERING
				do.adjoin_freshwater = true
				do.production_cost = 36
			Enum.OBSERVATORY:
				do.view_name = "天文台"
				do.spec_civ = CivTable.Enum.MAYA
				do.replace_district = Enum.CAMPUS
				do.scientist_point = 1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.SCIENCE
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				do.adjoining_bonus.natural_wonder_dict = {
					NaturalWonderTable.Enum.BARRIER_REEF: 2
				}
				do.adjoining_bonus.improvement_dict = {
					ImprovementTable.Enum.PLANTATION: 2
				}
				do.adjoining_bonus.two_farm_bonus = 1
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.science = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.science = 1
				
				do.required_tech = TechTable.Enum.WRITING
				do.production_cost = 27
				do.maintenance_fee = 1
			Enum.DIPLOMATIC_QUARTER:
				do.view_name = "外交区"

				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.domestic_trade_yield.production = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.culture = 1
				
				do.required_tech = TechTable.Enum.MATHEMATICS
				do.production_cost = 30
				do.maintenance_fee = 1
			Enum.ACROPOLIS:
				do.view_name = "卫城"
				do.spec_civ = CivTable.Enum.GREECE
				do.replace_district = Enum.THEATER
				do.writer_point = 1
				do.artist_point = 1
				do.musician_point = 1
				do.charm_influence = 1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.CULTURE
				do.adjoining_bonus.wonder_bonus = 1
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 1
				do.adjoining_bonus.center_bonus = 1
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.culture = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.culture = 1
				
				do.required_civic = CivicTable.Enum.DRAMA_POETRY
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.production_cost = 27
				do.maintenance_fee = 1
			Enum.CAMPUS:
				do.view_name = "学院"
				do.scientist_point = 1
				
				do.adjoining_bonus = AdjoiningBonusDTO.new()
				do.adjoining_bonus.bonus_type = YieldDTO.Enum.SCIENCE
				do.adjoining_bonus.terrain_dict = {
					TerrainTable.Enum.GRASS_MOUNTAIN: 1,
					TerrainTable.Enum.PLAIN_MOUNTAIN: 1,
					TerrainTable.Enum.DESERT_MOUNTAIN: 1,
					TerrainTable.Enum.TUNDRA_MOUNTAIN: 1,
					TerrainTable.Enum.SNOW_MOUNTAIN: 1,
				}
				do.adjoining_bonus.two_rainforest_bonus = 1
				do.adjoining_bonus.district_bonus = 1
				do.adjoining_bonus.district_bonus_threshold = 2
				do.adjoining_bonus.natural_wonder_dict = {
					NaturalWonderTable.Enum.BARRIER_REEF: 2
				}
				
				do.citizen_yield = YieldDTO.new()
				do.citizen_yield.science = 2
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.science = 1
				
				do.required_tech = TechTable.Enum.WRITING
				do.production_cost = 54
				do.maintenance_fee = 1
			Enum.ENTERTAINMENT_COMPLEX:
				do.view_name = "娱乐中心"
				do.amuse_amenity = 1
				do.charm_influence = 1
				
				do.domestic_trade_yield = YieldDTO.new()
				do.domestic_trade_yield.food = 1
				do.international_trade_yield = YieldDTO.new()
				do.international_trade_yield.food = 1
				
				do.required_civic = CivicTable.Enum.GAMES_RECREATION
				do.production_cost = 54
				do.maintenance_fee = 1
			Enum.SPACEPORT:
				do.view_name = "宇航中心"
				do.charm_influence = -1
				
				do.required_tech = TechTable.Enum.ROCKETRY
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
				] as Array[TerrainTable.Enum]
				do.production_cost = 1800
			Enum.BATH:
				do.view_name = "浴场"
				do.spec_civ = CivTable.Enum.ROME
				do.replace_district = Enum.AQUEDUCT
				do.housing = 2
				do.amuse_amenity = 1
				
				do.required_tech = TechTable.Enum.ENGINEERING
				do.adjoin_freshwater = true
				do.production_cost = 18
		super.init_insert(do)

