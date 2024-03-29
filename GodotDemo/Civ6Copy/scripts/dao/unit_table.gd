class_name UnitTable
extends MySimSQL.Table


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.NORMAL)
var player_id_index := MySimSQL.Index.new("player_id", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	elem_type = UnitDO
	create_index(coord_index)
	create_index(player_id_index)


func query_by_coord(coord: Vector2i) -> Array:
	return coord_index.get_do(coord)


func query_by_player_id(player_id: int) -> Array:
	return player_id_index.get_do(player_id)
