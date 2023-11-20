class_name MapBorderTable
extends MySimSQL.Table


enum Direction {
	LEFT_TOP,
	RIGHT_TOP,
	LEFT,
	CENTER,
	RIGHT,
	LEFT_DOWN,
	RIGHT_DOWN,
}

enum Type {
	SLASH, # / 斜线
	BACK_SLASH, # \ 反斜线
	CENTER, # 中心
	VERTICAL, # | 垂直线
}

enum Enum {
	EMPTY, # 空
	RIVER, # 河流
	CLIFF, # 悬崖
}

var coord_index := MySimSQL.Index.new("coord", MySimSQL.Index.Type.UNIQUE)


func _init() -> void:
	elem_type = MapBorderDO
	create_index(coord_index)


func query_by_coord(coord: Vector2i) -> MapBorderDO:
	return coord_index.get_do(coord)[0] as MapBorderDO
