class_name TileTable
extends MySimSQL.Table


var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.UNIQUE, \
		func(t: TileDO) -> Vector2i: return t.coord)


func _init() -> void:
	create_index(coord_index)
