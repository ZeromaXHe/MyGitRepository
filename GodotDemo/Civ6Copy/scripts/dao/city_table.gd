class_name CityTable
extends MySimSQL.Table


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.UNIQUE)
var player_id_index := MySimSQL.Index.new("player_id", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	elem_type = CityDO
	create_index(coord_index)
	create_index(player_id_index)


func query_by_coord(coord: Vector2i) -> CityDO:
	return coord_index.get_do(coord)[0] as CityDO


func query_by_player_id(player_id: int) -> Array:
	return player_id_index.get_do(player_id)
