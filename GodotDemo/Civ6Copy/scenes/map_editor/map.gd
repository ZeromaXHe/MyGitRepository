class_name Map
extends Node


# 地图类型
enum Type {
	BLANK, # 空白地图
}

# 地图尺寸
enum Size {
	DUAL, # 决斗
}

enum TerrainType {
	GRASS,
	GRASS_HILL,
	GRASS_MOUNTAIN,
	PLAIN,
	PLAIN_HILL,
	PLAIN_MOUNTAIN,
	DESERT,
	DESERT_HILL,
	DESERT_MOUNTAIN,
	TUNDRA,
	TUNDRA_HILL,
	TUNDRA_MOUNTAIN,
	SNOW,
	SNOW_HILL,
	SNOW_MOUNTAIN,
	SHORE,
	OCEAN,
}

enum LandscapeType {
	EMPTY, # 空
	ICE, # 冰
	FOREST, # 森林
	SWAMP, # 沼泽
	FLOOD, # 泛滥平原
	OASIS, # 绿洲
	RAINFOREST, # 雨林
}

enum ContinentType {
	EMPTY, # 空
	AFRICA, # 非洲
	AMASIA, # 阿马西亚
	AMERICA, # 美洲
	ANTARCTICA, # 南极洲
	ARCTIC, # 北极大陆
	ASIA, # 亚洲
	ASIAMERICA, # 亚美大陆
	ATLANTICA, # 大西洋洲
	ATLANTIS, # 亚特兰蒂斯
	AUSTRALIA, # 澳大利亚
	AVALONIA, # 阿瓦隆尼亚
	AZANIA, # 阿扎尼亚
	BALTICA, # 波罗大陆
	CIMMERIA, # 辛梅利亚大陆
	COLUMBIA, # 哥伦比亚
	CONGO_CRATON, # 刚果克拉通
	EURAMERICA, # 欧美大陆
	EUROPE, # 欧洲
	GONDWANA, # 冈瓦那
	KALAHARI, # 喀拉哈里
	KAZAKHSTANIA, # 哈萨克大陆
	KENORLAND, # 凯诺兰
	KUMARI_KANDAM, # 古默里坎达
	LAURASIA, # 劳亚古陆
	LAURENTIA, # 劳伦古陆
	LEMURIA, # 利莫里亚 
	MU, # 穆大陆
	NENA, # 妮娜大陆
	NORTH_AMERICA, # 北美洲
	NOVOPANGAEA, # 新盘古大陆
	NUNA, # 努纳
	OCEANIA, # 大洋洲
	PANGAEA, # 盘古大陆
	PANGAEA_ULTIMA, # 终极盘古大陆
	PANNOTIA, # 潘诺西亚
	RODINIA, # 罗迪尼亚
	SIBERIA, # 西伯利亚
	SOUTH_AMERICA, # 南美洲
	TERRA_AUSTRALIS, # 未知的南方大陆
	UR, # 乌尔
	VAALBARA, # 瓦巴拉
	VENDIAN, # 文德期
	ZEALANDIA, # 西兰蒂亚
}

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

enum BorderDirection {
	LEFT_TOP,
	RIGHT_TOP,
	LEFT,
	CENTER,
	RIGHT,
	LEFT_DOWN,
	RIGHT_DOWN,
}

enum BorderType {
	SLASH,
	BACK_SLASH,
	CENTER,
	VERTICAL,
}

enum BorderTileType {
	EMPTY,
	RIVER,
	CLIFF,
}

const TERRAIN_TYPE_TO_NAME_DICT: Dictionary = {
	TerrainType.GRASS: "草原",
	TerrainType.GRASS_HILL: "草原（丘陵）",
	TerrainType.GRASS_MOUNTAIN: "草原（山脉）",
	TerrainType.PLAIN: "平原",
	TerrainType.PLAIN_HILL: "平原（丘陵）",
	TerrainType.PLAIN_MOUNTAIN: "平原（山脉）",
	TerrainType.DESERT: "沙漠",
	TerrainType.DESERT_HILL: "沙漠（丘陵）",
	TerrainType.DESERT_MOUNTAIN: "沙漠（山脉）",
	TerrainType.TUNDRA: "冻土",
	TerrainType.TUNDRA_HILL: "冻土（丘陵）",
	TerrainType.TUNDRA_MOUNTAIN: "冻土（山脉）",
	TerrainType.SNOW: "雪地",
	TerrainType.SNOW_HILL: "雪地（丘陵）",
	TerrainType.SNOW_MOUNTAIN: "雪地（山脉）",
	TerrainType.SHORE: "海岸与湖泊",
	TerrainType.OCEAN: "海洋",
}

const LANDSCAPE_TYPE_TO_NAME_DICT: Dictionary = {
	LandscapeType.EMPTY: "空",
	LandscapeType.ICE: "冰",
	LandscapeType.FOREST: "森林",
	LandscapeType.SWAMP: "沼泽",
	LandscapeType.FLOOD: "泛滥平原",
	LandscapeType.OASIS: "绿洲",
	LandscapeType.RAINFOREST: "雨林",
}

const CONTINENT_TYPE_TO_NAME_DICT: Dictionary = {
	ContinentType.EMPTY: "空",
	ContinentType.AFRICA: "非洲",
	ContinentType.AMASIA: "阿马西亚",
	ContinentType.AMERICA: "美洲",
	ContinentType.ANTARCTICA: "南极洲",
	ContinentType.ARCTIC: "北极大陆",
	ContinentType.ASIA: "亚洲",
	ContinentType.ASIAMERICA: "亚美大陆",
	ContinentType.ATLANTICA: "大西洋洲",
	ContinentType.ATLANTIS: "亚特兰蒂斯",
	ContinentType.AUSTRALIA: "澳大利亚",
	ContinentType.AVALONIA: "阿瓦隆尼亚",
	ContinentType.AZANIA: "阿扎尼亚",
	ContinentType.BALTICA: "波罗大陆",
	ContinentType.CIMMERIA: "辛梅利亚大陆",
	ContinentType.COLUMBIA: "哥伦比亚",
	ContinentType.CONGO_CRATON: "刚果克拉通",
	ContinentType.EURAMERICA: "欧美大陆",
	ContinentType.EUROPE: "欧洲",
	ContinentType.GONDWANA: "冈瓦那",
	ContinentType.KALAHARI: "喀拉哈里",
	ContinentType.KAZAKHSTANIA: "哈萨克大陆",
	ContinentType.KENORLAND: "凯诺兰",
	ContinentType.KUMARI_KANDAM: "古默里坎达",
	ContinentType.LAURASIA: "劳亚古陆",
	ContinentType.LAURENTIA: "劳伦古陆",
	ContinentType.LEMURIA: "利莫里亚 ",
	ContinentType.MU: "穆大陆",
	ContinentType.NENA: "妮娜大陆",
	ContinentType.NORTH_AMERICA: "北美洲",
	ContinentType.NOVOPANGAEA: "新盘古大陆",
	ContinentType.NUNA: "努纳",
	ContinentType.OCEANIA: "大洋洲",
	ContinentType.PANGAEA: "盘古大陆",
	ContinentType.PANGAEA_ULTIMA: "终极盘古大陆",
	ContinentType.PANNOTIA: "潘诺西亚",
	ContinentType.RODINIA: "罗迪尼亚",
	ContinentType.SIBERIA: "西伯利亚",
	ContinentType.SOUTH_AMERICA: "南美洲",
	ContinentType.TERRA_AUSTRALIS: "未知的南方大陆",
	ContinentType.UR: "乌尔",
	ContinentType.VAALBARA: "瓦巴拉",
	ContinentType.VENDIAN: "文德期",
	ContinentType.ZEALANDIA: "西兰蒂亚",
}

const RESOURCE_TYPE_TO_NAME_DICT: Dictionary = {
	ResourceType.EMPTY: "空",
	ResourceType.SILK: "丝绸",
	ResourceType.RELIC: "历史遗迹",
	ResourceType.COCOA_BEAN: "可可豆",
	ResourceType.COFFEE: "咖啡",
	ResourceType.MARBLE: "大理石",
	ResourceType.RICE: "大米",
	ResourceType.WHEAT: "小麦",
	ResourceType.TRUFFLE: "松露",
	ResourceType.ORANGE: "柑橘",
	ResourceType.DYE: "染料",
	ResourceType.COTTON: "棉花",
	ResourceType.MERCURY: "水银",
	ResourceType.WRECKAGE: "海难遗迹",
	ResourceType.TOBACCO: "烟草",
	ResourceType.COAL: "煤",
	ResourceType.INCENSE: "熏香",
	ResourceType.COW: "牛",
	ResourceType.JADE: "玉",
	ResourceType.CORN: "玉米",
	ResourceType.PEARL: "珍珠",
	ResourceType.FUR: "皮草",
	ResourceType.SALT: "盐",
	ResourceType.STONE: "石头",
	ResourceType.OIL: "石油",
	ResourceType.GYPSUM: "石膏",
	ResourceType.SALTPETER: "硝石",
	ResourceType.SUGAR: "糖",
	ResourceType.SHEEP: "羊",
	ResourceType.TEA: "茶",
	ResourceType.WINE: "葡萄酒",
	ResourceType.HONEY: "蜂蜜",
	ResourceType.CRAB: "螃蟹",
	ResourceType.IVORY: "象牙",
	ResourceType.DIAMOND: "钻石",
	ResourceType.URANIUM: "铀",
	ResourceType.IRON: "铁",
	ResourceType.COPPER: "铜",
	ResourceType.ALUMINIUM: "铝",
	ResourceType.SILVER: "银",
	ResourceType.SPICE: "香料",
	ResourceType.BANANA: "香蕉",
	ResourceType.HORSE: "马",
	ResourceType.FISH: "鱼",
	ResourceType.WHALE: "鲸鱼",
	ResourceType.DEER: "鹿",
}

# 地图尺寸和格子数的映射字典
const SIZE_DICT: Dictionary = {
	0: Vector2i(44, 26),
}

var size: Size
var type: Type
# 记录地图图块数据
var _map_tile_info: Array = []
var _border_tile_info: Array = []


func _init() -> void:
	size = Size.DUAL
	type = Type.BLANK

	var map_size: Vector2i = SIZE_DICT[size]
	# 记录地图地块信息
	for i in range(map_size.x):
		_map_tile_info.append([])
		for j in range(map_size.y):
			_map_tile_info[i].append(TileInfo.new(TerrainType.OCEAN))
	# 记录边界地块信息
	for i in range(map_size.x * 2 + 2):
		_border_tile_info.append([])
		for j in range(map_size.y * 2 + 2):
			_border_tile_info[i].append(BorderInfo.new(BorderTileType.EMPTY))


func save() -> void:
	var json_string: String = JSON.stringify(get_persistance_dict())
	print("save | json_string:", json_string)
	var save_map: FileAccess = FileAccess.open("user://map.save", FileAccess.WRITE)
	save_map.store_line(json_string)


func get_persistance_dict() -> Dictionary:
	return {
		"size": size,
		"type": type,
		"map_tile_info": serialize_map_tile_info(),
		"border_tile_info": serialize_border_tile_info(),
	}


func serialize_map_tile_info() -> String:
	var res: String = ""
	for row in _map_tile_info:
		if res != "":
			res += ";"
		for elem in row:
			if res != "" and not res.ends_with(";"):
				res += ","
			var tile_info := elem as TileInfo
			if tile_info.continent != ContinentType.AFRICA:
				res += str(tile_info.type) + "|" + str(tile_info.landscape) + "|" \
						+ str(tile_info.village) + "|" + str(tile_info.resource) \
						+ "|" + str(tile_info.continent)
			elif tile_info.resource != ResourceType.EMPTY:
				res += str(tile_info.type) + "|" + str(tile_info.landscape) + "|" \
						+ str(tile_info.village) + "|" + str(tile_info.resource)
			elif tile_info.village != 0:
				res += str(tile_info.type) + "|" + str(tile_info.landscape) + "|" \
						+ str(tile_info.village)
			elif tile_info.landscape != LandscapeType.EMPTY:
				res += str(tile_info.type) + "|" + str(tile_info.landscape)
			else:
				res += str(tile_info.type)
	return res


func serialize_border_tile_info() -> String:
	var res: String = ""
	for row in _border_tile_info:
		if res != "":
			res += ";"
		for elem in row:
			if res != "" and not res.ends_with(";"):
				res += ","
			var border_info := elem as BorderInfo
			res += str(border_info.type)
	return res


func change_map_tile_info(coord: Vector2i, tile_info: TileInfo) -> void:
	_map_tile_info[coord.x][coord.y] = tile_info


func change_border_tile_info(coord: Vector2i, border_info: BorderInfo) -> void:
	_border_tile_info[coord.x][coord.y] = border_info


func get_map_tile_info_at(coord: Vector2i) -> TileInfo:
	return _map_tile_info[coord.x][coord.y]


func get_border_tile_info_at(coord: Vector2i) -> BorderInfo:
	return _border_tile_info[coord.x][coord.y]


static func load_from_save() -> Map:
	var res: Map = null
	if not FileAccess.file_exists("user://map.save"):
		printerr("load | Error! We don't have a save to load.")
		return res
	var save_map: FileAccess = FileAccess.open("user://map.save", FileAccess.READ)
	while save_map.get_position() < save_map.get_length():
		var json_string: String = save_map.get_line()
		var json := JSON.new()
		var parse_result: Error = json.parse(json_string)
		if not parse_result == OK:
			printerr("load | JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var node_data: Variant = json.get_data()
		res = Map.new()
		res.size = node_data["size"]
		res.type = node_data["type"]
		res._map_tile_info = deserialize_map_tile_info(node_data["map_tile_info"])
		res._border_tile_info = deserialize_border_tile_info(node_data["border_tile_info"])
	return res


static func deserialize_map_tile_info(data_str: String) -> Array:
	var map_tile_info: Array = []
	var row_strs: PackedStringArray = data_str.split(";")
	for row_str in row_strs:
		map_tile_info.append([])
		var elem_strs: PackedStringArray = row_str.split(",")
		for elem_str in elem_strs:
			var field_strs: PackedStringArray = elem_str.split("|")
			var tile_info := TileInfo.new(int(field_strs[0]))
			if field_strs.size() == 1:
				map_tile_info.back().append(tile_info)
				continue
			tile_info.landscape = int(field_strs[1])
			if field_strs.size() == 2:
				map_tile_info.back().append(tile_info)
				continue
			tile_info.village = int(field_strs[2])
			if field_strs.size() == 3:
				map_tile_info.back().append(tile_info)
				continue
			tile_info.resource = int(field_strs[3])
			if field_strs.size() == 4:
				map_tile_info.back().append(tile_info)
				continue
			tile_info.continent = int(field_strs[4])
			map_tile_info.back().append(tile_info)
	return map_tile_info


static func deserialize_border_tile_info(data_str: String) -> Array:
	var border_tile_info: Array = []
	var row_strs: PackedStringArray = data_str.split(";")
	for row_str in row_strs:
		border_tile_info.append([])
		var elem_strs: PackedStringArray = row_str.split(",")
		for elem_str in elem_strs:
			border_tile_info.back().append(BorderInfo.new(int(elem_str)))
	return border_tile_info


##
# 六边形	左上角	右上角	左		中		右		左下角	右下角
# (0,0)	(0,0)	(1,0)	(-1,1)	(0,1)	(1,1)	(0,2)	(1,2)
# (0,1)	(1,2)	(2,2)	(0,3)	(1,3)	(2,3)	(1,4)	(2,4)
# (1,0)	(2,0)	(3,0)	(1,1)	(2,1)	(3,1)	(2,2)	(3,2)
# (1,1)	(3,2)	(4,2)	(2,3)	(3,3)	(4,3)	(3,4)	(4,4)
# (0,2)	(0,4)	(1,4)	(-1,5)	(0,5)	(1,5)	(0,6)	(1,6)
##
static func get_border_type(border_coord: Vector2i) -> BorderType:
	if border_coord.y % 2 == 0:
		if border_coord.x % 2 == border_coord.y / 2 % 2:
			return BorderType.SLASH
		else:
			return BorderType.BACK_SLASH
	elif border_coord.x % 2 == border_coord.y / 2 % 2:
		return BorderType.CENTER
	else:
		return BorderType.VERTICAL


# 测试 getBorderType() 方法
static func test_get_border_type() -> void:
	print("slash ", Vector2i(0, 0), " is ", get_border_type(Vector2i(0, 0)))
	print("slash ", Vector2i(1, 2), " is ", get_border_type(Vector2i(1, 2)))
	print("back slash ", Vector2i(1, 0), " is ", get_border_type(Vector2i(1, 0)))
	print("back slash ", Vector2i(2, 2), " is ", get_border_type(Vector2i(2, 2)))
	print("center ", Vector2i(0, 1), " is ", get_border_type(Vector2i(0, 1)))
	print("center ", Vector2i(1, 3), " is ", get_border_type(Vector2i(1, 3)))
	print("vertical ", Vector2i(-1, 1), " is ", get_border_type(Vector2i(-1, 1)))
	print("vertical ", Vector2i(1, 1), " is ", get_border_type(Vector2i(1, 1)))
	print("vertical ", Vector2i(0, 3), " is ", get_border_type(Vector2i(0, 3)))
	print("vertical ", Vector2i(2, 3), " is ", get_border_type(Vector2i(2, 3)))


##
# 	边界		相邻地块
#	back_slash
#	(6,2)	(3,0), (2,1)
#	(4,2)	(2,0), (1,1)
#	(3,4)	(1,1), (1,2)
#	(5,4)	(2,1), (2,2)
#	slash
#	(1,2)	(0,0), (0,1)
#	(3,2)	(1,0), (1,1)
#	(2,4)	(0,1), (1,2)
#	(4,4)	(1,1), (2,2)
#	vertical
#	(1,1)	(0,0), (1,0)
#	(3,1)	(1,0), (2,0)
#	(2,3)	(0,1), (1,1)
#	(4,3)	(1,1), (2,1)
#	(1,5)	(0,2), (1,2)
##
static func get_neighbor_tile_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		BorderType.CENTER:
			return [border_coord / 2]
		BorderType.VERTICAL:
			# 不能简写成 (border_corder.x - 1) / 2 否则负数有 bug
			return [Vector2i((border_coord.x + 1)/ 2 - 1, border_coord.y / 2),
					Vector2i(border_coord.x / 2 + border_coord.x % 2, border_coord.y / 2)]
		BorderType.SLASH:
			return [Vector2i((border_coord.x + 1)/ 2 - 1, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2, border_coord.y / 2)]
		BorderType.BACK_SLASH:
			return [Vector2i(border_coord.x / 2, border_coord.y / 2 - 1),
					Vector2i((border_coord.x + 1) / 2 - 1, border_coord.y / 2)]
		_:
			printerr("get_neighbor_tile_of_border | unknown border type")
			return []


##
#	边界		相邻边界
#	vertical
#	(1,1)	(1,0),(2,0),(1,2),(2,2)
#	(3,1)	(3,0),(4,0),(3,2),(4,2)
#	(0,3)	(0,2),(1,2),(0,4),(1,4)
#	(2,3)	(2,2),(3,2),(2,4),(3,4)
#	slash
#	(1,2)	(1,1),(2,2),(0,2),(0,3)
#	(3,2)	(3,1),(4,2),(2,2),(2,3)
#	(2,4)	(2,3),(3,4),(1,4),(1,5)
#	(4,4)	(4,3),(5,4),(3,4),(3,5)
#	back_slash:
#	(2,2)	(1,1),(1,2),(3,2),(2,3)
#	(4,2)	(3,1),(3,2),(5,2),(4,3)
#	(1,4)	(0,3),(0,4),(2,4),(1,5)
#	(3,4)	(2,3),(2,4),(4,4),(3,5)
##
static func get_connect_border_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		BorderType.CENTER:
			return get_all_tile_border(border_coord / 2, false)
		BorderType.VERTICAL:
			return [Vector2i(border_coord.x, border_coord.y - 1),
					Vector2i(border_coord.x + 1, border_coord.y - 1),
					Vector2i(border_coord.x, border_coord.y + 1),
					Vector2i(border_coord.x + 1, border_coord.y + 1)]
		BorderType.SLASH:
			return [Vector2i(border_coord.x, border_coord.y - 1),
					Vector2i(border_coord.x + 1, border_coord.y),
					Vector2i(border_coord.x - 1, border_coord.y),
					Vector2i(border_coord.x - 1, border_coord.y + 1)]
		BorderType.BACK_SLASH:
			return [Vector2i(border_coord.x - 1, border_coord.y - 1),
					Vector2i(border_coord.x - 1, border_coord.y),
					Vector2i(border_coord.x + 1, border_coord.y),
					Vector2i(border_coord.x, border_coord.y + 1)]
		_:
			printerr("get_connect_border_of_border | unknown border type")
			return []


##
# 	边界		末端地块
#	back_slash
#	(6,2)	(2,0), (3,1)
#	(4,2)	(1,0), (2,1)
#	(3,4)	(0,1), (2,2)
#	(5,4)	(1,1), (3,2)
#	slash
#	(1,2)	(1,0), (-1,1)
#	(3,2)	(2,0), (0,1)
#	(2,4)	(1,1), (0,2)
#	(4,4)	(2,1), (1,2)
#	vertical
#	(1,1)	(0,-1), (0,1)
#	(3,1)	(1,-1), (1,1)
#	(2,3)	(1,0), (1,2)
#	(4,3)	(2,0), (2,2)
#	(1,5)	(0,1), (0,3)
#	(3,5)	(1,1), (1,3)
##
static func get_end_tile_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		BorderType.VERTICAL:
			return [Vector2i(border_coord.x / 2, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2, border_coord.y / 2 + 1)]
		BorderType.BACK_SLASH:
			return [Vector2i(border_coord.x / 2 - 1, border_coord.y / 2 - 1),
					Vector2i((border_coord.x + 1) / 2, border_coord.y / 2)]
		BorderType.SLASH:
			return [Vector2i((border_coord.x + 1) / 2, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2 - 1, border_coord.y / 2)]
		_:
			printerr("getEndTileOfBorder | unknown or unsupported border type")
			return []


static func get_all_tile_border(tile_coord: Vector2i, include_center: bool) -> Array[Vector2i]:
	var result: Array[Vector2i] = [
			get_tile_coord_directed_border(tile_coord, BorderDirection.LEFT_TOP),
			get_tile_coord_directed_border(tile_coord, BorderDirection.RIGHT_TOP),
			get_tile_coord_directed_border(tile_coord, BorderDirection.LEFT),
			get_tile_coord_directed_border(tile_coord, BorderDirection.RIGHT),
			get_tile_coord_directed_border(tile_coord, BorderDirection.LEFT_DOWN),
			get_tile_coord_directed_border(tile_coord, BorderDirection.RIGHT_DOWN),
	]
	if include_center:
		result.append(get_tile_coord_directed_border(tile_coord, BorderDirection.CENTER))
	return result


# 获取地块在指定方向的边界地块
static func get_tile_coord_directed_border(tile_coord: Vector2i, direction: BorderDirection) -> Vector2i:
	match direction:
		BorderDirection.LEFT_TOP:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y)
		BorderDirection.RIGHT_TOP:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y)
		BorderDirection.LEFT:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 - 1, 2 * tile_coord.y + 1)
		BorderDirection.CENTER:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y + 1)
		BorderDirection.RIGHT:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y + 1)
		BorderDirection.LEFT_DOWN:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y + 2)
		BorderDirection.RIGHT_DOWN:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y + 2)
		_:
			printerr("getTileCoordDirectedBorder | direction not supported")
			return Vector2i(-1, -1)


static func test_get_tile_coord_directed_border() -> void:
	print("hexagon ", Vector2i(0, 0), "'s left top is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.LEFT_TOP)) # (0,0)
	print("hexagon ", Vector2i(0, 0), "'s right top is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.RIGHT_TOP)) # (1,0)
	print("hexagon ", Vector2i(0, 0), "'s left is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.LEFT)) # (-1,1)
	print("hexagon ", Vector2i(0, 0), "'s center is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.CENTER)) # (0,1)
	print("hexagon ", Vector2i(0, 0), "'s right is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.RIGHT)) # (1,1)
	print("hexagon ", Vector2i(0, 0), "'s left down is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.LEFT_DOWN)) # (0,2)
	print("hexagon ", Vector2i(0, 0), "'s right down is ", get_tile_coord_directed_border(Vector2i(0, 0), BorderDirection.RIGHT_DOWN)) # (1,2)
	print("hexagon ", Vector2i(0, 1), "'s left top is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.LEFT_TOP)) # (1,2)
	print("hexagon ", Vector2i(0, 1), "'s right top is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.RIGHT_TOP)) # (2,2)
	print("hexagon ", Vector2i(0, 1), "'s left is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.LEFT)) # (0,3)
	print("hexagon ", Vector2i(0, 1), "'s center is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.CENTER)) # (1,3)
	print("hexagon ", Vector2i(0, 1), "'s right is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.RIGHT)) # (2,3)
	print("hexagon ", Vector2i(0, 1), "'s left down is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.LEFT_DOWN)) # (1,4)
	print("hexagon ", Vector2i(0, 1), "'s right down is ", get_tile_coord_directed_border(Vector2i(0, 1), BorderDirection.RIGHT_DOWN)) # (2,4)


class TileInfo:
	var type: TerrainType = TerrainType.OCEAN
	var landscape: LandscapeType = LandscapeType.EMPTY
	var village: int = 0 # 0 表示没有，1 表示有
	var resource: ResourceType = ResourceType.EMPTY
	var continent: ContinentType = ContinentType.EMPTY
	
	func _init(type: TerrainType) -> void:
		self.type = type


class BorderInfo:
	var type: BorderTileType
	
	func _init(type: BorderTileType) -> void:
		self.type = type
