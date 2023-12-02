class_name PlayerSightDO
extends MySimSQL.DataObj


# 玩家 id
var player_id: int
# 地块坐标
var coord: Vector2i
# 视野类型
var sight := PlayerSightTable.Sight.UNSEEN
