class_name RouteDO
extends MySimSQL.EnumDO


var move_cost: float # 移动力消耗
var bridge: bool = false # 在河面上建桥
var era: EraTable.Enum = -1 # 要求的时代
