class_name TileTable
extends MySimSQL.Table


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.UNIQUE)


func _init() -> void:
	elem_type = TileDO
	create_index(coord_index)
