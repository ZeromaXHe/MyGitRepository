class_name ImprovementDO
extends MySimSQL.EnumDO


var spec_civ: CivTable.Enum = -1 # 特属于文明
var spec_city_state: CityStateTable.Enum = -1 # 特属于城邦

var weapon_capacity: int # 武器能力
var plane_capacity: int # 飞机容量
var housing: float # 住房
var culture: int # 文化产量
var food: int # 粮食产量
var production: int # 生产力产量
var science: int # 科学产量
var faith: int # 信仰产量
var gold: int # 金币产量
var charm_influence: int # 相邻单元格提升的魅力

var required_tech: TechTable.Enum = -1 # 要求的科技
var required_civic: CivicTable.Enum = -1 # 要求的市政
var adjoining_bonus: Array[AdjoiningBonusDTO] # 相邻加成
var placeable_terrains: Array[TerrainTable.Enum] # 可放置地形
var placeable_landscapes: Array[LandscapeTable.Enum] # 可放置地貌
var placeable_resources: Array[ResourceTable.Enum] # 可放置资源
var built_by: UnitTypeTable.Enum # 建造的单位类型
