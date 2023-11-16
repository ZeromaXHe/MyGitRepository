class_name MapTileTable
extends MySimSQL.Table


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.UNIQUE)
var city_id_index := MySimSQL.Index.new("city_id", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	elem_type = MapTileDO
	create_index(coord_index)
	create_index(city_id_index)


func query_by_coord(coord: Vector2i) -> MapTileDO:
	return coord_index.get_do(coord)[0] as MapTileDO


func query_by_city_id(city_id: int) -> Array:
	return city_id_index.get_do(city_id)
