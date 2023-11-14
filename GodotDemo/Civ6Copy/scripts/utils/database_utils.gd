class_name DatabaseUtils


# 地块表
static var tile_tbl := TileTable.new()
# 地形表
static var terrain_tbl := TerrainTable.new()
# 地貌表
static var landscape_tbl := LandscapeTable.new()
# 资源表
static var resource_tbl := ResourceTable.new()
# 大陆表
static var continent_tbl := ContinentTable.new()
# 玩家表
static var player_tbl := PlayerTable.new()
# 城市表
static var city_tbl := CityTable.new()
# 单位表
static var unit_tbl := UnitTable.new()
# 单位类型表
static var unit_type_tbl := UnitTypeTable.new()
# 单位种类表
static var unit_category_tbl := UnitCategoryTable.new()


static func query_tile_by_coord(coord: Vector2i) -> TileDO:
	return tile_tbl.coord_index.get_do(coord)


static func query_terrain_by_id(id: int) -> TerrainDO:
	return terrain_tbl.query_by_id(id)


static func query_terrain_by_short_name(short_name: String) -> TerrainDO:
	return terrain_tbl.short_name_index.get_do(short_name)


static func query_terrain_by_enum_name(enum_name: String) -> TerrainDO:
	return terrain_tbl.enum_name_index.get_do(enum_name)


static func query_terrain_by_enum_val(enum_val: int) -> TerrainDO:
	return terrain_tbl.enum_val_index.get_do(enum_val)


static func query_landscape_by_id(id: int) -> LandscapeDO:
	return landscape_tbl.query_by_id(id)


static func query_landscape_by_short_name(short_name: String) -> LandscapeDO:
	return landscape_tbl.short_name_index.get_do(short_name)


static func query_landscape_by_enum_name(enum_name: String) -> LandscapeDO:
	return landscape_tbl.enum_name_index.get_do(enum_name)


static func query_landscape_by_enum_val(enum_val: int) -> LandscapeDO:
	return landscape_tbl.enum_val_index.get_do(enum_val)


static func query_resource_by_id(id: int) -> ResourceDO:
	return resource_tbl.query_by_id(id)


static func query_resource_by_short_name(short_name: String) -> ResourceDO:
	return resource_tbl.short_name_index.get_do(short_name)


static func query_resource_by_enum_name(enum_name: String) -> ResourceDO:
	return resource_tbl.enum_name_index.get_do(enum_name)


static func query_resource_by_enum_val(enum_val: int) -> ResourceDO:
	return resource_tbl.enum_val_index.get_do(enum_val)


static func query_continent_by_enum_val(enum_val: int) -> ContinentDO:
	return continent_tbl.enum_val_index.get_do(enum_val)


static func query_unit_type_by_enum_val(enum_val: int) -> UnitTypeDO:
	return unit_type_tbl.enum_val_index.get_do(enum_val)


static func query_unit_category_by_enum_val(enum_val: int) -> UnitCategoryDO:
	return unit_category_tbl.enum_val_index.get_do(enum_val)
