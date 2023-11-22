class_name TechDO
extends MySimSQL.EnumDO


# 引言
var quotation: Array[String]
# 所属时代
var era: EraTable.Enum
# 所需科技
var required_tech: Array[TechTable.Enum]
# 研究费用
var research_cost: int
# 尤里卡描述
var eureka_desc: String
# 尤里卡进度需要
var eureka_cost: int

