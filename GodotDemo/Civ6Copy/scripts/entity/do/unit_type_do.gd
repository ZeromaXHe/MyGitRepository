class_name UnitTypeDO
extends MySimSQL.EnumDO


# 种类
var category: UnitCategoryTable.Enum
# 移动力
var move: int
# 劳动力
var labor: int
# 近战攻击力
var melee_atk: int

# 64x64 图标资源路径
var icon_64: String
# 256x256 图标资源路径
var icon_256: String
# png_200 单位图片资源路径
var pic_200: String
