class_name CityDO
extends MySimSQL.DataObj


# 城市名字
var name: String
# 所在地块坐标
var coord: Vector2i
# 所属玩家 id
var player_id: int
# 是否首都
var capital: bool
# 总住房数量
var housing: int
# 宜居度
var amenity: int
# 防御值
var defense: int
# 人口
var pop: int = 1
# 粮食累计值
var food_sum: float = 0
# 生产单位类型
var producing_type: UnitTypeTable.Enum = -1
# 生产力累计值
var production_sum: float
