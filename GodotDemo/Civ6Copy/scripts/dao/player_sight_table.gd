class_name PlayerSightTable
extends MySimSQL.Table


enum Sight {
	UNSEEN, # 未见过
	SEEN, # 见过
	IN_SIGHT, # 视野范围内
}


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.NORMAL)
var player_id_index := MySimSQL.Index.new("player_id", MySimSQL.Index.Type.NORMAL)
var sight_index := MySimSQL.Index.new("sight", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	elem_type = PlayerSightDO
	create_index(coord_index)
	create_index(player_id_index)
	create_index(sight_index)


func query_by_coord(coord: Vector2i) -> Array:
	return coord_index.get_do(coord)


func query_by_player_id(player_id: int) -> Array:
	return player_id_index.get_do(player_id)


func query_by_sight(sight: Sight) -> Array:
	return sight_index.get_do(sight)
