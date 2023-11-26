class_name NaturalWonderDO
extends MySimSQL.EnumDO


var quotation: String # 引言
var cells: int = 1 # 占用单元格数量
var movable: bool = true # 是否可以逾越

var move_cost: int # 移动力变更
var defence_bonus: int # 防御值变更
var culture: int # 文化产量
var food: int # 粮食产量
var production: int # 生产力产量
var science: int # 科技产量
var faith: int # 信仰产量
var gold: int # 金币产量

var charm_influence: int # 相邻单元格提升的魅力
var culture_influence: int # 相邻单元格提供文化产量
var food_influence: int # 相邻单元格提供粮食产量
var production_influence: int # 相邻单元格提供生产力产量
var science_influence: int # 相邻单元格提供科技产量
var faith_influence: int # 相邻单元格提供信仰产量
var gold_influence: int # 相邻单元格提供金币产量
var double_terrain_yield: bool = false # 相邻单元格的地形产量翻倍
