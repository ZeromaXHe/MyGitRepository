class_name BuildingDO
extends MySimSQL.EnumDO


var spec_civ: CivTable.Enum = -1 # 所属文明
var spec_belief: BeliefTable.Enum = -1 # 特属于信条
var replace_building: BuildingTable.Enum = -1 # 取代建筑
var culture: int # 文化产量
var food: int # 食物产量
var production: int # 生产力产量
var science: int # 科技产量
var faith: int # 信仰产量
var gold: int # 金币产量
var defence: int # 外部防御
var amuse_amenity: int # 娱乐区域宜居度
var housing: int # 住房
var citizen_slot: int # 公民槽位
var scientist_point: int # 每回合大科学家点数
var engineer_point: int # 每回合大工程师点数
var writer_point: int # 每回合大作家点数
var artist_point: int # 每回合大艺术家点数
var musician_point: int # 每回合大音乐家点数
var merchant_point: int # 每回合大商人点数
var prophet_point: int # 每回合大预言家点数
var general_point: int # 每回合大将军点数
var admiral_point: int # 每回合海军统帅点数
var writing_slot: int # 著作巨作槽位
var music_slot: int # 音乐巨作槽位
var landscape_slot: int # 艺术巨作槽位
var religious_slot: int # 宗教艺术巨作槽位
var relic_slot: int # 遗物槽位
var artifact_slot: int # 文物槽位
var greatwork_slot: int # 巨作槽位（可保存任意类型）
var required_district: DistrictTable.Enum = -1 # 需要的区域
var required_building: BuildingTable.Enum = -1 # 需要的建筑
var incompatible_building: BuildingTable.Enum = -1 # 互斥的建筑
var required_tech: TechTable.Enum = -1 # 需要的科技
var required_civic: CivicTable.Enum = -1 # 需要的市政
var production_cost: int = -1 # 生产力消耗
var gold_cost: int = -1 # 金币购买成本
var faith_cost: int = -1 # 信仰购买成本
var maintenance_fee: int = 0 # 维护费用
