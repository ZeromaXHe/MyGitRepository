class_name UnitDO
extends MySimSQL.DataObj


# 所在地块坐标
var coord: Vector2i
# 单位类型
var type: UnitTypeTable.Type
# 所属玩家 id
var player_id: int
# 剩余移动力
var move: int
# 剩余劳动力
var labor: int
# 跳过
var skip: bool
# 睡眠
var sleep: bool
