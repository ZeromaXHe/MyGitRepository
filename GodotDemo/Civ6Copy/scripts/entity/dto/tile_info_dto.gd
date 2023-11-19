class_name TileInfoDTO
extends RefCounted


# 地形名字
var terrain_name: String
# 是否陆地
var land: bool
# 地貌名字
var landscape_name: String
# 村庄
var village: bool
# 资源名字
var resource_name: String
# 临近河流
var river: bool
# 临近悬崖
var cliff: bool
# 移动力消耗
var move_cost: int
# 防御值变更
var defence_bonus: int
# 魅力
var charm: int
# 魅力描述
var charm_desc: String
# 大洲名字
var continent_name: String
# 产出
var tile_yield: YieldDTO
# 坐标
var coord: Vector2i
