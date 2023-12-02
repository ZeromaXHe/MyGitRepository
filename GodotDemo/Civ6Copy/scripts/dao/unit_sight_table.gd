class_name UnitSightTable
extends MySimSQL.Table


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.NORMAL)
var unit_id_index := MySimSQL.Index.new("unit_id", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	elem_type = UnitSightDO
	create_index(coord_index)
	create_index(unit_id_index)


func query_by_coord(coord: Vector2i) -> Array:
	return coord_index.get_do(coord)


func query_by_unit_id(unit_id: int) -> Array:
	return unit_id_index.get_do(unit_id)


