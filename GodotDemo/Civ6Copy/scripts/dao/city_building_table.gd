class_name CityBuildingTable
extends MySimSQL.Table


# TODO: 后续单独建表
enum Building {
	PALACE, # 宫殿
}


var city_id_index := MySimSQL.Index.new("city_id", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	elem_type = CityBuildingDO
	create_index(city_id_index)


func query_by_city_id(city_id: int) -> Array:
	return city_id_index.get_do(city_id)
