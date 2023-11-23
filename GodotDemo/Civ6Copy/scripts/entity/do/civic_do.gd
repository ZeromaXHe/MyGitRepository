class_name CivicDO
extends MySimSQL.EnumDO


# 引言
var quotation: Array[String]
# 所属时代
var era: EraTable.Enum
# 所需市政
var required_civics: Array[CivicTable.Enum]
# 文化值消耗
var culture_cost: int
# 鼓舞时刻描述
var inspire_desc: String
# 鼓舞时刻进度需要
var inspire_cost: int

