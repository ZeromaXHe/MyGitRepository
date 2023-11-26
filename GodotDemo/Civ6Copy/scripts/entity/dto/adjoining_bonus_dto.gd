class_name AdjoiningBonusDTO
extends RefCounted


var bonus_type: YieldDTO.Enum # 加成类型
var district_bonus: int # 区域单元格加成
var district_bonus_threshold: int = 1 # 区域单元格加成区域个数阈值
var center_bonus: int # 市中心加成
var wonder_bonus: int # 奇观加成
var natural_wonder_bonus: int # 自然奇观加成
var resource_bonus: int # 资源加成
var river_tile_bonus: int # 河流地块加成
var two_forest_bonus: int # 每2个森林加成
var two_rainforest_bonus: int # 每2个雨林加成
var two_farm_bonus: int # 每2个农场加成
var two_plantation_bonus: int # 每2个种植园加成
var two_hacienda_bonus: int # 每2个大庄园加成
var improvement_dict: Dictionary # 改良设施加成字典
var district_dict: Dictionary # 区域加成字典
var resource_category_dict: Dictionary # 资源种类加成字典
var resource_dict: Dictionary # 资源加成字典
var terrain_dict: Dictionary # 地形加成字典
var natural_wonder_dict: Dictionary # 自然奇观加成字典
