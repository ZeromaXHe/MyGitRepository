class_name UnitTable
extends MySimSQL.Table


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.NORMAL, \
		func(u: UnitDO) -> Vector2i: return u.coord)
var player_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.NORMAL, \
		func(u: UnitDO) -> int: return u.player_id)


func _init() -> void:
	create_index(coord_index)
	create_index(player_index)
