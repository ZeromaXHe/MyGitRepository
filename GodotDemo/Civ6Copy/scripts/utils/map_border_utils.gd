class_name MapBorderUtils


##
# 六边形	左上角	右上角	左		中		右		左下角	右下角
# (0,0)	(0,0)	(1,0)	(-1,1)	(0,1)	(1,1)	(0,2)	(1,2)
# (0,1)	(1,2)	(2,2)	(0,3)	(1,3)	(2,3)	(1,4)	(2,4)
# (1,0)	(2,0)	(3,0)	(1,1)	(2,1)	(3,1)	(2,2)	(3,2)
# (1,1)	(3,2)	(4,2)	(2,3)	(3,3)	(4,3)	(3,4)	(4,4)
# (0,2)	(0,4)	(1,4)	(-1,5)	(0,5)	(1,5)	(0,6)	(1,6)
##
static func get_border_type(border_coord: Vector2i) -> MapBorderTable.Type:
	if border_coord.y % 2 == 0:
		if border_coord.x % 2 == border_coord.y / 2 % 2:
			return MapBorderTable.Type.SLASH
		else:
			return MapBorderTable.Type.BACK_SLASH
	elif border_coord.x % 2 == border_coord.y / 2 % 2:
		return MapBorderTable.Type.CENTER
	else:
		return MapBorderTable.Type.VERTICAL


##
# 	边界		相邻地块
#	back_slash
#	(6,2)	(3,0), (2,1)
#	(4,2)	(2,0), (1,1)
#	(3,4)	(1,1), (1,2)
#	(5,4)	(2,1), (2,2)
#	slash
#	(1,2)	(0,0), (0,1)
#	(3,2)	(1,0), (1,1)
#	(2,4)	(0,1), (1,2)
#	(4,4)	(1,1), (2,2)
#	vertical
#	(1,1)	(0,0), (1,0)
#	(3,1)	(1,0), (2,0)
#	(2,3)	(0,1), (1,1)
#	(4,3)	(1,1), (2,1)
#	(1,5)	(0,2), (1,2)
##
static func get_neighbor_tile_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		MapBorderTable.Type.CENTER:
			return [border_coord / 2]
		MapBorderTable.Type.VERTICAL:
			# 不能简写成 (border_corder.x - 1) / 2 否则负数有 bug
			return [Vector2i((border_coord.x + 1)/ 2 - 1, border_coord.y / 2),
					Vector2i(border_coord.x / 2 + border_coord.x % 2, border_coord.y / 2)]
		MapBorderTable.Type.SLASH:
			return [Vector2i((border_coord.x + 1)/ 2 - 1, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2, border_coord.y / 2)]
		MapBorderTable.Type.BACK_SLASH:
			return [Vector2i(border_coord.x / 2, border_coord.y / 2 - 1),
					Vector2i((border_coord.x + 1) / 2 - 1, border_coord.y / 2)]
		_:
			printerr("get_neighbor_tile_of_border | unknown border type")
			return []


##
#	边界		相邻边界
#	vertical
#	(1,1)	(1,0),(2,0),(1,2),(2,2)
#	(3,1)	(3,0),(4,0),(3,2),(4,2)
#	(0,3)	(0,2),(1,2),(0,4),(1,4)
#	(2,3)	(2,2),(3,2),(2,4),(3,4)
#	slash
#	(1,2)	(1,1),(2,2),(0,2),(0,3)
#	(3,2)	(3,1),(4,2),(2,2),(2,3)
#	(2,4)	(2,3),(3,4),(1,4),(1,5)
#	(4,4)	(4,3),(5,4),(3,4),(3,5)
#	back_slash:
#	(2,2)	(1,1),(1,2),(3,2),(2,3)
#	(4,2)	(3,1),(3,2),(5,2),(4,3)
#	(1,4)	(0,3),(0,4),(2,4),(1,5)
#	(3,4)	(2,3),(2,4),(4,4),(3,5)
##
static func get_connect_border_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		MapBorderTable.Type.CENTER:
			return get_all_tile_border(border_coord / 2, false)
		MapBorderTable.Type.VERTICAL:
			return [Vector2i(border_coord.x, border_coord.y - 1),
					Vector2i(border_coord.x + 1, border_coord.y - 1),
					Vector2i(border_coord.x, border_coord.y + 1),
					Vector2i(border_coord.x + 1, border_coord.y + 1)]
		MapBorderTable.Type.SLASH:
			return [Vector2i(border_coord.x, border_coord.y - 1),
					Vector2i(border_coord.x + 1, border_coord.y),
					Vector2i(border_coord.x - 1, border_coord.y),
					Vector2i(border_coord.x - 1, border_coord.y + 1)]
		MapBorderTable.Type.BACK_SLASH:
			return [Vector2i(border_coord.x - 1, border_coord.y - 1),
					Vector2i(border_coord.x - 1, border_coord.y),
					Vector2i(border_coord.x + 1, border_coord.y),
					Vector2i(border_coord.x, border_coord.y + 1)]
		_:
			printerr("get_connect_border_of_border | unknown border type")
			return []


##
# 	边界		末端地块
#	back_slash
#	(6,2)	(2,0), (3,1)
#	(4,2)	(1,0), (2,1)
#	(3,4)	(0,1), (2,2)
#	(5,4)	(1,1), (3,2)
#	slash
#	(1,2)	(1,0), (-1,1)
#	(3,2)	(2,0), (0,1)
#	(2,4)	(1,1), (0,2)
#	(4,4)	(2,1), (1,2)
#	vertical
#	(1,1)	(0,-1), (0,1)
#	(3,1)	(1,-1), (1,1)
#	(2,3)	(1,0), (1,2)
#	(4,3)	(2,0), (2,2)
#	(1,5)	(0,1), (0,3)
#	(3,5)	(1,1), (1,3)
##
static func get_end_tile_of_border(border_coord: Vector2i) -> Array[Vector2i]:
	match get_border_type(border_coord):
		MapBorderTable.Type.VERTICAL:
			return [Vector2i(border_coord.x / 2, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2, border_coord.y / 2 + 1)]
		MapBorderTable.Type.BACK_SLASH:
			return [Vector2i(border_coord.x / 2 - 1, border_coord.y / 2 - 1),
					Vector2i((border_coord.x + 1) / 2, border_coord.y / 2)]
		MapBorderTable.Type.SLASH:
			return [Vector2i((border_coord.x + 1) / 2, border_coord.y / 2 - 1),
					Vector2i(border_coord.x / 2 - 1, border_coord.y / 2)]
		_:
			printerr("getEndTileOfBorder | unknown or unsupported border type")
			return []


static func get_all_tile_border(tile_coord: Vector2i, include_center: bool) -> Array[Vector2i]:
	var result: Array[Vector2i] = [
			get_tile_coord_directed_border(tile_coord, MapBorderTable.Direction.LEFT_TOP),
			get_tile_coord_directed_border(tile_coord, MapBorderTable.Direction.RIGHT_TOP),
			get_tile_coord_directed_border(tile_coord, MapBorderTable.Direction.LEFT),
			get_tile_coord_directed_border(tile_coord, MapBorderTable.Direction.RIGHT),
			get_tile_coord_directed_border(tile_coord, MapBorderTable.Direction.LEFT_DOWN),
			get_tile_coord_directed_border(tile_coord, MapBorderTable.Direction.RIGHT_DOWN),
	]
	if include_center:
		result.append(get_tile_coord_directed_border(tile_coord, MapBorderTable.Direction.CENTER))
	return result


# 获取地块在指定方向的边界地块
static func get_tile_coord_directed_border(tile_coord: Vector2i, direction: MapBorderTable.Direction) -> Vector2i:
	match direction:
		MapBorderTable.Direction.LEFT_TOP:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y)
		MapBorderTable.Direction.RIGHT_TOP:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y)
		MapBorderTable.Direction.LEFT:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 - 1, 2 * tile_coord.y + 1)
		MapBorderTable.Direction.CENTER:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y + 1)
		MapBorderTable.Direction.RIGHT:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y + 1)
		MapBorderTable.Direction.LEFT_DOWN:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2, 2 * tile_coord.y + 2)
		MapBorderTable.Direction.RIGHT_DOWN:
			return Vector2i(tile_coord.x * 2 + tile_coord.y % 2 + 1, 2 * tile_coord.y + 2)
		_:
			printerr("getTileCoordDirectedBorder | direction not supported")
			return Vector2i(-1, -1)
