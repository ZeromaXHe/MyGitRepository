class_name CityDO
extends MySimSQL.DataObj


# 城市名字
var name: String
# 所在地块 id
var tile_id: int
# 所属玩家 id
var player_id: int
# 视野坐标 id
var sight_ids: Array[int]
# 是否首都
var capital: bool
# 总住房数量
var housing: int
# 已用住房数量
var housing_used: int
# 宜居度
var amenity: int
# 防御值
var defense: int
# 人口
var pop: int
# 粮食累计值
var food_sum: float
# 生产单位 id
var producing_id: int
# 生产力累计值
var production_sum: float
