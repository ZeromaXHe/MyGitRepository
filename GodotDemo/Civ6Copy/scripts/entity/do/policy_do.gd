class_name PolicyDO
extends MySimSQL.EnumDO


var type: PolicyTable.Type # 类型
var replaced_by: PolicyTable.Enum # 随着发展会被以下政策替代
var required_civic: CivicTable.Enum # 要求的市政
