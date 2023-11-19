class_name ResourceTable
extends MySimSQL.EnumTable


enum ResourceType {
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
}

enum Category {
	EMPTY,
	BONUS,
	LUXURY,
	STRATEGY,
	RELIC,
}

var short_name_index := MySimSQL.Index.new("short_name", MySimSQL.Index.Type.UNIQUE)
var category_index := MySimSQL.Index.new("category", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	super._init()
	elem_type = ResourceDO
	create_index(short_name_index)
	create_index(category_index)
	
	for k in ResourceType.keys():
		var do = ResourceDO.new()
		do.enum_name = k
		do.enum_val = ResourceType[k]
		match do.enum_val:
			ResourceType.EMPTY:
				do.view_name = "空"
				do.short_name = "空"
				do.category = Category.EMPTY
			ResourceType.SILK:
				do.view_name = "丝绸"
				do.short_name = "丝绸"
				do.category = Category.LUXURY
				do.culture = 1
			ResourceType.RELIC:
				do.view_name = "历史遗迹"
				do.short_name = "历遗"
				do.category = Category.RELIC
			ResourceType.COCOA_BEAN:
				do.view_name = "可可豆"
				do.short_name = "可可"
				do.category = Category.LUXURY
				do.gold = 3
			ResourceType.COFFEE:
				do.view_name = "咖啡"
				do.short_name = "咖啡"
				do.category = Category.LUXURY
				do.culture = 1
			ResourceType.MARBLE:
				do.view_name = "大理石"
				do.short_name = "大理"
				do.category = Category.LUXURY
				do.culture = 1
			ResourceType.RICE:
				do.view_name = "大米"
				do.short_name = "大米"
				do.category = Category.BONUS
				do.food = 1
			ResourceType.WHEAT:
				do.view_name = "小麦"
				do.short_name = "小麦"
				do.category = Category.BONUS
				do.food = 1
			ResourceType.TRUFFLE:
				do.view_name = "松露"
				do.short_name = "松露"
				do.category = Category.LUXURY
				do.gold = 3
			ResourceType.ORANGE:
				do.view_name = "柑橘"
				do.short_name = "柑橘"
				do.category = Category.LUXURY
				do.food = 2
			ResourceType.DYE:
				do.view_name = "染料"
				do.short_name = "染料"
				do.category = Category.LUXURY
				do.faith = 1
			ResourceType.COTTON:
				do.view_name = "棉花"
				do.short_name = "棉花"
				do.category = Category.LUXURY
				do.gold = 3
			ResourceType.MERCURY:
				do.view_name = "水银"
				do.short_name = "水银"
				do.category = Category.LUXURY
				do.science = 1
			ResourceType.WRECKAGE:
				do.view_name = "海难遗迹"
				do.short_name = "海遗"
				do.category = Category.RELIC
			ResourceType.TOBACCO:
				do.view_name = "烟草"
				do.short_name = "烟草"
				do.category = Category.LUXURY
				do.faith = 1
			ResourceType.COAL:
				do.view_name = "煤"
				do.short_name = "煤"
				do.category = Category.STRATEGY
				do.production = 2
			ResourceType.INCENSE:
				do.view_name = "熏香"
				do.short_name = "熏香"
				do.category = Category.LUXURY
				do.faith = 1
			ResourceType.COW:
				do.view_name = "牛"
				do.short_name = "牛"
				do.category = Category.BONUS
				do.food = 1
			ResourceType.JADE:
				do.view_name = "玉"
				do.short_name = "玉"
				do.category = Category.LUXURY
				do.culture = 1
			ResourceType.CORN:
				do.view_name = "玉米"
				do.short_name = "玉米"
				do.category = Category.BONUS
				do.gold = 2
			ResourceType.PEARL:
				do.view_name = "珍珠"
				do.short_name = "珍珠"
				do.category = Category.LUXURY
				do.faith = 1
			ResourceType.FUR:
				do.view_name = "皮草"
				do.short_name = "皮草"
				do.category = Category.LUXURY
				do.food = 1
				do.gold = 1
			ResourceType.SALT:
				do.view_name = "盐"
				do.short_name = "盐"
				do.category = Category.LUXURY
				do.food = 1
				do.gold = 1
			ResourceType.STONE:
				do.view_name = "石头"
				do.short_name = "石头"
				do.category = Category.BONUS
				do.production = 1
			ResourceType.OIL:
				do.view_name = "石油"
				do.short_name = "石油"
				do.category = Category.STRATEGY
				do.production = 3
			ResourceType.GYPSUM:
				do.view_name = "石膏"
				do.short_name = "石膏"
				do.category = Category.LUXURY
				do.production = 1
				do.gold = 1
			ResourceType.SALTPETER:
				do.view_name = "硝石"
				do.short_name = "硝石"
				do.category = Category.STRATEGY
				do.food = 1
				do.production = 1
			ResourceType.SUGAR:
				do.view_name = "糖"
				do.short_name = "糖"
				do.category = Category.LUXURY
				do.food = 2
			ResourceType.SHEEP:
				do.view_name = "羊"
				do.short_name = "羊"
				do.category = Category.BONUS
				do.food = 1
			ResourceType.TEA:
				do.view_name = "茶"
				do.short_name = "茶"
				do.category = Category.LUXURY
				do.science = 1
			ResourceType.WINE:
				do.view_name = "葡萄酒"
				do.short_name = "葡萄"
				do.category = Category.LUXURY
				do.food = 1
				do.gold = 1
			ResourceType.HONEY:
				do.view_name = "蜂蜜"
				do.short_name = "蜂蜜"
				do.category = Category.LUXURY
				do.food = 2
			ResourceType.CRAB:
				do.view_name = "螃蟹"
				do.short_name = "螃蟹"
				do.category = Category.BONUS
				do.gold = 2
			ResourceType.IVORY:
				do.view_name = "象牙"
				do.short_name = "象牙"
				do.category = Category.LUXURY
				do.production = 1
				do.gold = 1
			ResourceType.DIAMOND:
				do.view_name = "钻石"
				do.short_name = "钻石"
				do.category = Category.LUXURY
				do.gold = 3
			ResourceType.URANIUM:
				do.view_name = "铀"
				do.short_name = "铀"
				do.category = Category.STRATEGY
				do.production = 2
			ResourceType.IRON:
				do.view_name = "铁"
				do.short_name = "铁"
				do.category = Category.STRATEGY
				do.science = 1
			ResourceType.COPPER:
				do.view_name = "铜"
				do.short_name = "铜"
				do.category = Category.BONUS
				do.gold = 2
			ResourceType.ALUMINIUM:
				do.view_name = "铝"
				do.short_name = "铝"
				do.category = Category.STRATEGY
				do.science = 1
			ResourceType.SILVER:
				do.view_name = "银"
				do.short_name = "银"
				do.category = Category.LUXURY
				do.gold = 3
			ResourceType.SPICE:
				do.view_name = "香料"
				do.short_name = "香料"
				do.category = Category.LUXURY
				do.food = 2
			ResourceType.BANANA:
				do.view_name = "香蕉"
				do.short_name = "香蕉"
				do.category = Category.BONUS
				do.food = 1
			ResourceType.HORSE:
				do.view_name = "马"
				do.short_name = "马"
				do.category = Category.STRATEGY
				do.food = 1
				do.production = 1
			ResourceType.FISH:
				do.view_name = "鱼"
				do.short_name = "鱼"
				do.category = Category.BONUS
				do.food = 1
			ResourceType.WHALE:
				do.view_name = "鲸鱼"
				do.short_name = "鲸鱼"
				do.category = Category.LUXURY
				do.production = 1
				do.gold = 1
			ResourceType.DEER:
				do.view_name = "鹿"
				do.short_name = "鹿"
				do.category = Category.BONUS
				do.production = 1
		super.init_insert(do)


func query_by_short_name(short_name: String) -> ResourceDO:
	return short_name_index.get_do(short_name)[0] as ResourceDO


func query_by_category(category: Category) -> Array:
	return category_index.get_do(category)

