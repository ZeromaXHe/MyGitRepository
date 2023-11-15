class_name MapTileTable
extends MySimSQL.Table


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.UNIQUE)


func _init() -> void:
	elem_type = MapTileDO
	create_index(coord_index)


func query_by_coord(coord: Vector2i) -> MapTileDO:
	return coord_index.get_do(coord)[0] as MapTileDO
