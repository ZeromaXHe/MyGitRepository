class_name DistrictDO
extends MySimSQL.EnumDO


var spec_civ: CivTable.Enum = -1 # 特属于文明
var replace_district: DistrictTable.Enum = -1 # 取代的区域
var housing: int # 住房数量
var plane_capacity: int # 飞机容量
var amuse_amenity: int # 娱乐区域宜居度
var scientist_point: int # 每回合大科学家点数
var engineer_point: int # 每回合大工程师点数
var writer_point: int # 每回合大作家点数
var artist_point: int # 每回合大艺术家点数
var musician_point: int # 每回合大音乐家点数
var merchant_point: int # 每回合大商人点数
var prophet_point: int # 每回合大预言家点数
var general_point: int # 每回合大将军点数
var admiral_point: int # 每回合海军统帅点数
var charm_influence: int # 相邻单元格提升的魅力
var adjoining_bonus: AdjoiningBonusDTO # 相邻加成
var citizen_yield: YieldDTO # 公民收益
var domestic_trade_yield: YieldDTO # 国内目的地-贸易收益
var international_trade_yield: YieldDTO # 国际目的地-贸易收益
var required_tech: TechTable.Enum = -1 # 需要的科技
var required_civic: CivicTable.Enum = -1 # 需要的市政
var adjoin_center: int = 0 # 邻接市中心的要求（0: 无要求，1：必须邻接，-1：必须不邻接）
var on_close_shore: bool = false # 是否放置在临近陆地的海岸上
var adjoin_freshwater: bool = false # 是否必须邻接淡水（河流、湖泊、绿洲、山脉）
var placeable_terrains: Array[TerrainTable.Enum] # 可放置地形要求（空对应无要求）
var placeable_landscapes: Array[LandscapeTable.Enum] # 可放置地貌要求（空对应无要求）
var production_cost: int # 生产力消耗
var maintenance_fee: int # 维护费用
