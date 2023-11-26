class_name UnitTypeDO
extends MySimSQL.EnumDO


var category: UnitCategoryTable.Enum # 种类
var spec_civ: CivTable.Enum = -1 # 特属于文明
var spec_leader: LeaderTable.Enum = -1 # 特属于领袖
var spec_city_state: CityStateTable.Enum = -1 # 特属于城邦
var spec_belief: BeliefTable.Enum = -1 # 特属于信条
var replace_unit_type: UnitTypeTable.Enum = -1 # 替代的单位类型
var upgrade_unit_type: UnitTypeTable.Enum = -1 # 升级到单位类型
var move: int # 移动力
var religion_atk: int # 宗教战斗力
var preach_time: int # 传教次数
var heal_time: int # 治疗次数
var labor: int # 劳动力
var melee_atk: int # 近战攻击力
var range_atk: int # 远程攻击力
var range: int # 射程
var bombard_atk: int # 轰炸攻击力
var antiair_atk: int # 防空力量
var plane_capacity: int # 飞机容量
var required_district: DistrictTable.Enum = -1 # 需要的区域
var required_building: BuildingTable.Enum = -1 # 需要的建筑
var required_tech: TechTable.Enum = -1 # 需要的科技
var required_civic: CivicTable.Enum = -1 # 需要的市政
var production_cost: int # 生产力消耗
var gold_cost: int # 金币购买成本
var faith_cost: int # 信仰购买成本
var maintenance_fee: int # 维护费用

# 64x64 图标资源路径
var icon_64: String
# 256x256 图标资源路径
var icon_256: String
# png_200 单位图片资源路径
var pic_200: String
