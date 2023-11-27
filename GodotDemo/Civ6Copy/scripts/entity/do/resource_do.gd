class_name ResourceDO
extends MySimSQL.EnumDO


# 视图层名字缩写
var short_name: String
# 种类
var category: ResourceTable.Category
# 文化产量
var culture: int = 0
# 粮食产量
var food: int = 0
# 生产力产量
var production: int = 0
# 科技产量
var science: int = 0
# 宗教产量
var faith: int = 0
# 金币产量
var gold: int = 0

var placeable_terrains: Array[TerrainTable.Enum] # 可放置地形
var placeable_landscapes: Array[LandscapeTable.Enum] # 可放置地貌
var improvement: Array[ImprovementTable.Enum] # 改良设施
var harvest_type: YieldDTO.Enum = -1 # 收获类型
var harvest_val: int # 收获量
var required_tech: TechTable.Enum = -1 # 需要的科技
var required_civic: CivicTable.Enum = -1 # 需要的市政

var icon_scene: String # 图标场景路径
