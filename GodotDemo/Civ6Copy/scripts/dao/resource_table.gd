class_name ResourceTable
extends MySimSQL.EnumTable


enum Enum {
	EMPTY, # 空
	SILK, # 丝绸
	RELIC, # 历史遗迹
	COCOA_BEAN, # 可可豆
	COFFEE, # 咖啡
	MARBLE, # 大理石
	RICE, # 大米
	WHEAT, # 小麦
	TRUFFLE, # 松露
	ORANGE, # 柑橘
	DYE, # 染料
	COTTON, # 棉花
	MERCURY, # 水银
	WRECKAGE, # 海难遗迹
	TOBACCO, # 烟草
	COAL, # 煤
	INCENSE, # 熏香
	COW, # 牛
	JADE, # 玉
	CORN, # 玉米
	PEARL, # 珍珠
	FUR, # 皮草
	SALT, # 盐
	STONE, # 石头
	OIL, # 石油
	GYPSUM, # 石膏
	SALTPETER, # 硝石
	SUGAR, # 糖
	SHEEP, # 羊
	TEA, # 茶
	WINE, # 葡萄酒
	HONEY, # 蜂蜜
	CRAB, # 螃蟹
	IVORY, # 象牙
	DIAMOND, # 钻石
	URANIUM, # 铀
	IRON, # 铁
	COPPER, # 铜
	ALUMINIUM, # 铝
	SILVER, # 银
	SPICE, # 香料
	BANANA, # 香蕉
	HORSE, # 马
	FISH, # 鱼
	WHALE, # 鲸鱼
	DEER, # 鹿
#	CLOVES # 丁香
#	CINNAMON # 肉桂
}

enum Category {
	EMPTY, # 空
	BONUS, # 加成
	LUXURY, # 奢侈品
	STRATEGY, # 战略
	RELIC, # 文物
}

var short_name_index := MySimSQL.Index.new("short_name", MySimSQL.Index.Type.UNIQUE)
var category_index := MySimSQL.Index.new("category", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	super._init()
	elem_type = ResourceDO
	create_index(short_name_index)
	create_index(category_index)
	
	for k in Enum.keys():
		var do = ResourceDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.EMPTY:
				do.view_name = "空"
				do.short_name = "空"
				do.category = Category.EMPTY
			Enum.SILK:
				do.view_name = "丝绸"
				do.short_name = "丝绸"
				do.category = Category.LUXURY
				do.culture = 1
				
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/resource_sprite.tscn"
			Enum.RELIC:
				do.view_name = "历史遗迹"
				do.short_name = "历遗"
				do.category = Category.RELIC
				
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
					LandscapeTable.Enum.FOREST,
					LandscapeTable.Enum.SWAMP,
					LandscapeTable.Enum.FLOOD,
					LandscapeTable.Enum.OASIS,
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.required_civic = CivicTable.Enum.NATURAL_HISTORY
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_relic.tscn"
			Enum.COCOA_BEAN:
				do.view_name = "可可豆"
				do.short_name = "可可"
				do.category = Category.LUXURY
				do.gold = 3
				
				do.placeable_landscapes = [
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_cocoa_bean.tscn"
			Enum.COFFEE:
				do.view_name = "咖啡"
				do.short_name = "咖啡"
				do.category = Category.LUXURY
				do.culture = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_coffee.tscn"
			Enum.MARBLE:
				do.view_name = "大理石"
				do.short_name = "大理"
				do.category = Category.LUXURY
				do.culture = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.QUARRY] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_marble.tscn"
			Enum.RICE:
				do.view_name = "大米"
				do.short_name = "大米"
				do.category = Category.BONUS
				do.food = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.SWAMP,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.FARM] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.FOOD
				do.harvest_val = 20
				do.required_tech = TechTable.Enum.POTTERY
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_rice.tscn"
			Enum.WHEAT:
				do.view_name = "小麦"
				do.short_name = "小麦"
				do.category = Category.BONUS
				do.food = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.FARM] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.FOOD
				do.harvest_val = 20
				do.required_tech = TechTable.Enum.POTTERY
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_wheat.tscn"
			Enum.TRUFFLE:
				do.view_name = "松露"
				do.short_name = "松露"
				do.category = Category.LUXURY
				do.gold = 3
				
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
					LandscapeTable.Enum.SWAMP,
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.CAMP] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_truffle.tscn"
			Enum.ORANGE:
				do.view_name = "柑橘"
				do.short_name = "柑橘"
				do.category = Category.LUXURY
				do.food = 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_orange.tscn"
			Enum.DYE:
				do.view_name = "染料"
				do.short_name = "染料"
				do.category = Category.LUXURY
				do.faith = 1
				
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_dye.tscn"
			Enum.COTTON:
				do.view_name = "棉花"
				do.short_name = "棉花"
				do.category = Category.LUXURY
				do.gold = 3
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_cotton.tscn"
			Enum.MERCURY:
				do.view_name = "水银"
				do.short_name = "水银"
				do.category = Category.LUXURY
				do.science = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_mercury.tscn"
			Enum.WRECKAGE:
				do.view_name = "海难遗迹"
				do.short_name = "海遗"
				do.category = Category.RELIC
				
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.required_civic = CivicTable.Enum.CULTURAL_HERITAGE
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_wreckage.tscn"
			Enum.TOBACCO:
				do.view_name = "烟草"
				do.short_name = "烟草"
				do.category = Category.LUXURY
				do.faith = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_tobacco.tscn"
			Enum.COAL:
				do.view_name = "煤"
				do.short_name = "煤"
				do.category = Category.STRATEGY
				do.production = 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				do.required_tech = TechTable.Enum.INDUSTRIALIZATION
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_coal.tscn"
			Enum.INCENSE:
				do.view_name = "熏香"
				do.short_name = "熏香"
				do.category = Category.LUXURY
				do.faith = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_incense.tscn"
			Enum.COW:
				do.view_name = "牛"
				do.short_name = "牛"
				do.category = Category.BONUS
				do.food = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.PASTURE] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.FOOD
				do.harvest_val = 20
				do.required_tech = TechTable.Enum.ANIMAL_HUSBANDRY
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_cow.tscn"
			Enum.JADE:
				do.view_name = "玉"
				do.short_name = "玉"
				do.category = Category.LUXURY
				do.culture = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.TUNDRA,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_jade.tscn"
			Enum.CORN:
				do.view_name = "玉米"
				do.short_name = "玉米"
				do.category = Category.BONUS
				do.gold = 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.FARM] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.GOLD
				do.harvest_val = 40
				do.required_tech = TechTable.Enum.POTTERY
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_corn.tscn"
			Enum.PEARL:
				do.view_name = "珍珠"
				do.short_name = "珍珠"
				do.category = Category.LUXURY
				do.faith = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.FISHING_BOATS] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_pearl.tscn"
			Enum.FUR:
				do.view_name = "皮草"
				do.short_name = "皮草"
				do.category = Category.LUXURY
				do.food = 1
				do.gold = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.TUNDRA,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.CAMP] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_fur.tscn"
			Enum.SALT:
				do.view_name = "盐"
				do.short_name = "盐"
				do.category = Category.LUXURY
				do.food = 1
				do.gold = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_salt.tscn"
			Enum.STONE:
				do.view_name = "石头"
				do.short_name = "石头"
				do.category = Category.BONUS
				do.production = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.QUARRY] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.PRODUCTION
				do.harvest_val = 20
				do.required_tech = TechTable.Enum.MASONRY
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_stone.tscn"
			Enum.OIL:
				do.view_name = "石油"
				do.short_name = "石油"
				do.category = Category.STRATEGY
				do.production = 3
				
				do.placeable_terrains = [
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.SNOW,
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.SWAMP,
				] as Array[LandscapeTable.Enum]
				do.improvement = [
					ImprovementTable.Enum.OIL_WELL,
					ImprovementTable.Enum.OFFSHORE_OIL_RIG,
				] as Array[ImprovementTable.Enum]
				do.required_tech = TechTable.Enum.STEEL
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_oil.tscn"
			Enum.GYPSUM:
				do.view_name = "石膏"
				do.short_name = "石膏"
				do.category = Category.LUXURY
				do.production = 1
				do.gold = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.QUARRY] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_gypsum.tscn"
			Enum.SALTPETER:
				do.view_name = "硝石"
				do.short_name = "硝石"
				do.category = Category.STRATEGY
				do.food = 1
				do.production = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.TUNDRA,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				do.required_tech = TechTable.Enum.MILITARY_ENGINEERING
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_saltpeter.tscn"
			Enum.SUGAR:
				do.view_name = "糖"
				do.short_name = "糖"
				do.category = Category.LUXURY
				do.food = 2
				
				do.placeable_landscapes = [
					LandscapeTable.Enum.SWAMP,
					LandscapeTable.Enum.FLOOD,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_sugar.tscn"
			Enum.SHEEP:
				do.view_name = "羊"
				do.short_name = "羊"
				do.category = Category.BONUS
				do.food = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.PASTURE] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.FOOD
				do.harvest_val = 20
				do.required_tech = TechTable.Enum.ANIMAL_HUSBANDRY
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_sheep.tscn"
			Enum.TEA:
				do.view_name = "茶"
				do.short_name = "茶"
				do.category = Category.LUXURY
				do.science = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.GRASS_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_tea.tscn"
			Enum.WINE:
				do.view_name = "葡萄酒"
				do.short_name = "葡萄"
				do.category = Category.LUXURY
				do.food = 1
				do.gold = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_wine.tscn"
			Enum.HONEY:
				do.view_name = "蜂蜜"
				do.short_name = "蜂蜜"
				do.category = Category.LUXURY
				do.food = 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.CAMP] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_honey.tscn"
			Enum.CRAB:
				do.view_name = "螃蟹"
				do.short_name = "螃蟹"
				do.category = Category.BONUS
				do.gold = 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.FISHING_BOATS] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.GOLD
				do.harvest_val = 40
				do.required_tech = TechTable.Enum.CELESTIAL_NAVIGATION
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_crab.tscn"
			Enum.IVORY:
				do.view_name = "象牙"
				do.short_name = "象牙"
				do.category = Category.LUXURY
				do.production = 1
				do.gold = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.CAMP] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_ivory.tscn"
			Enum.DIAMOND:
				do.view_name = "钻石"
				do.short_name = "钻石"
				do.category = Category.LUXURY
				do.gold = 3
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_diamond.tscn"
			Enum.URANIUM:
				do.view_name = "铀"
				do.short_name = "铀"
				do.category = Category.STRATEGY
				do.production = 2
				
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
					LandscapeTable.Enum.FOREST,
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				do.required_tech = TechTable.Enum.COMBINED_ARMS
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_uranium.tscn"
			Enum.IRON:
				do.view_name = "铁"
				do.short_name = "铁"
				do.category = Category.STRATEGY
				do.science = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				do.required_tech = TechTable.Enum.BRONZE_WORKING
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_iron.tscn"
			Enum.COPPER:
				do.view_name = "铜"
				do.short_name = "铜"
				do.category = Category.BONUS
				do.gold = 2
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS_HILL,
					TerrainTable.Enum.PLAIN_HILL,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA_HILL,
					TerrainTable.Enum.SNOW_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.GOLD
				do.harvest_val = 40
				do.required_tech = TechTable.Enum.MINING
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_copper.tscn"
			Enum.ALUMINIUM:
				do.view_name = "铝"
				do.short_name = "铝"
				do.category = Category.STRATEGY
				do.science = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.PLAIN,
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				do.required_tech = TechTable.Enum.RADIO
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_aluminium.tscn"
			Enum.SILVER:
				do.view_name = "银"
				do.short_name = "银"
				do.category = Category.LUXURY
				do.gold = 3
				
				do.placeable_terrains = [
					TerrainTable.Enum.DESERT,
					TerrainTable.Enum.DESERT_HILL,
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.MINE] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_silver.tscn"
			Enum.SPICE:
				do.view_name = "香料"
				do.short_name = "香料"
				do.category = Category.LUXURY
				do.food = 2
				
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_spice.tscn"
			Enum.BANANA:
				do.view_name = "香蕉"
				do.short_name = "香蕉"
				do.category = Category.BONUS
				do.food = 1
				
				do.placeable_landscapes = [
					LandscapeTable.Enum.RAINFOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.PLANTATION] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.FOOD
				do.harvest_val = 20
				do.required_tech = TechTable.Enum.IRRIGATION
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_banana.tscn"
			Enum.HORSE:
				do.view_name = "马"
				do.short_name = "马"
				do.category = Category.STRATEGY
				do.food = 1
				do.production = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.GRASS,
					TerrainTable.Enum.PLAIN,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.PASTURE] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_horse.tscn"
			Enum.FISH:
				do.view_name = "鱼"
				do.short_name = "鱼"
				do.category = Category.BONUS
				do.food = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.FISHING_BOATS] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.FOOD
				do.harvest_val = 20
				do.required_tech = TechTable.Enum.CELESTIAL_NAVIGATION
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_fish.tscn"
			Enum.WHALE:
				do.view_name = "鲸鱼"
				do.short_name = "鲸鱼"
				do.category = Category.LUXURY
				do.production = 1
				do.gold = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.SHORE,
				] as Array[TerrainTable.Enum]
				do.improvement = [ImprovementTable.Enum.FISHING_BOATS] as Array[ImprovementTable.Enum]
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_whale.tscn"
			Enum.DEER:
				do.view_name = "鹿"
				do.short_name = "鹿"
				do.category = Category.BONUS
				do.production = 1
				
				do.placeable_terrains = [
					TerrainTable.Enum.TUNDRA,
					TerrainTable.Enum.TUNDRA_HILL,
				] as Array[TerrainTable.Enum]
				do.placeable_landscapes = [
					LandscapeTable.Enum.FOREST,
				] as Array[LandscapeTable.Enum]
				do.improvement = [ImprovementTable.Enum.CAMP] as Array[ImprovementTable.Enum]
				do.harvest_type = YieldDTO.Enum.PRODUCTION
				do.harvest_val = 20
				do.required_tech = TechTable.Enum.ANIMAL_HUSBANDRY
				
				do.icon_scene = "res://scenes/map_editor/resource_tiles/sprite_deer.tscn"
		super.init_insert(do)


func query_by_short_name(short_name: String) -> ResourceDO:
	return short_name_index.get_do(short_name)[0] as ResourceDO


func query_by_category(category: Category) -> Array:
	return category_index.get_do(category)

