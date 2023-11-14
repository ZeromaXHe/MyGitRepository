class_name CityTable
extends MySimSQL.Table


var tile_id_index := MySimSQL.Index.new("tile_id", MySimSQL.Index.Type.UNIQUE)
var player_id_index := MySimSQL.Index.new("player_id", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	elem_type = CityDO
	create_index(player_id_index)
	create_index(tile_id_index)
