class_name TerrainTable
extends MySimSQL.EnumTable


enum Enum {
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

var short_name_index := MySimSQL.Index.new("short_name", MySimSQL.Index.Type.UNIQUE)


func _init() -> void:
	super._init()
	elem_type = TerrainDO
	create_index(short_name_index)
	for k in Enum.keys():
		var do = TerrainDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.GRASS:
				do.view_name = "草原"
				do.short_name = "草原"
				do.food = 2
			Enum.GRASS_HILL:
				do.view_name = "草原（丘陵）"
				do.short_name = "草丘"
				do.food = 2
				do.production = 1
				do.hill = true
				do.move_cost = 1
				do.defence_bonus = 3
			Enum.GRASS_MOUNTAIN:
				do.view_name = "草原（山脉）"
				do.short_name = "草山"
				do.mountain = true
				do.charm_influence = 1
				do.movable = false
			Enum.PLAIN:
				do.view_name = "平原"
				do.short_name = "平原"
				do.food = 1
				do.production = 1
			Enum.PLAIN_HILL:
				do.view_name = "平原（丘陵）"
				do.short_name = "平丘"
				do.food = 1
				do.production = 2
				do.hill = true
				do.move_cost = 1
				do.defence_bonus = 3
			Enum.PLAIN_MOUNTAIN:
				do.view_name = "平原（山脉）"
				do.short_name = "平山"
				do.mountain = true
				do.charm_influence = 1
				do.movable = false
			Enum.DESERT:
				do.view_name = "沙漠"
				do.short_name = "沙漠"
			Enum.DESERT_HILL:
				do.view_name = "沙漠（丘陵）"
				do.short_name = "沙丘"
				do.production = 1
				do.hill = true
				do.move_cost = 1
				do.defence_bonus = 3
			Enum.DESERT_MOUNTAIN:
				do.view_name = "沙漠（山脉）"
				do.short_name = "沙山"
				do.mountain = true
				do.charm_influence = 1
				do.movable = false
			Enum.TUNDRA:
				do.view_name = "冻土"
				do.short_name = "冻土"
				do.food = 1
			Enum.TUNDRA_HILL:
				do.view_name = "冻土（丘陵）"
				do.short_name = "冻丘"
				do.food = 1
				do.production = 1
				do.hill = true
				do.move_cost = 1
				do.defence_bonus = 3
			Enum.TUNDRA_MOUNTAIN:
				do.view_name = "冻土（山脉）"
				do.short_name = "冻山"
				do.mountain = true
				do.charm_influence = 1
				do.movable = false
			Enum.SNOW:
				do.view_name = "雪地"
				do.short_name = "雪地"
			Enum.SNOW_HILL:
				do.view_name = "雪地（丘陵）"
				do.short_name = "雪丘"
				do.hill = true
				do.production = 1
				do.move_cost = 1
				do.defence_bonus = 3
			Enum.SNOW_MOUNTAIN:
				do.view_name = "雪地（山脉）"
				do.short_name = "雪山"
				do.mountain = true
				do.charm_influence = 1
				do.movable = false
			Enum.SHORE:
				do.view_name = "海岸与湖泊"
				do.short_name = "浅水"
				do.food = 1
				do.gold = 1
				do.water = true
				do.charm_influence = 1
			Enum.OCEAN:
				do.view_name = "海洋"
				do.short_name = "海洋"
				do.food = 1
				do.water = true
		super.init_insert(do)


func query_by_short_name(short_name: String) -> TerrainDO:
	return short_name_index.get_do(short_name)[0] as TerrainDO

