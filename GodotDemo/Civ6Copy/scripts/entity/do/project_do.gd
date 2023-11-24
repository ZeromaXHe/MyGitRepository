class_name ProjectDO
extends MySimSQL.EnumDO


var spec_civ: CivTable.Enum = -1 # 特属于文明
var spec_leader: LeaderTable.Enum = -1 # 特属于领袖
var required_resource: ResourceTable.Enum = -1 # 需要的资源
var required_district: DistrictTable.Enum = -1# 需要的区域
var required_tech: TechTable.Enum = -1 # 需要的科技
var required_project: ProjectTable.Enum = -1 # 需要的项目
