class_name MapService


# A* 算法
static var move_astar: MapMoveAStar2D
static var sight_astar: MapSightAStar2D


static func init_map_tile_table(size: MapSizeTable.Size) -> void:
	# 记录地图地块信息
	var size_vec: Vector2i = get_map_tile_size_vec(size)
	for i in range(size_vec.x):
		for j in range(size_vec.y):
			var map_tile_do := MapTileDO.new()
			map_tile_do.coord = Vector2i(i, j)
			DatabaseUtils.map_tile_tbl.insert(map_tile_do)


static func init_map_border_table(size: MapSizeTable.Size) -> void:
	# 记录边界地块信息
	var border_size_vec: Vector2i = get_border_tile_size_vec(MapSizeTable.Size.DUAL)
	for i in range(border_size_vec.x):
		for j in range(border_size_vec.y):
			var map_border_do := MapBorderDO.new()
			map_border_do.coord = Vector2i(i, j)
			DatabaseUtils.map_tile_tbl.insert(map_border_do)


static func init_move_astar(size: MapSizeTable.Size) -> void:
	var size_vec: Vector2i = get_map_tile_size_vec(size)
	move_astar = MapMoveAStar2D.new()
	for i in range(size_vec.x):
		for j in range(size_vec.y):
			var coord := Vector2i(i, j)
			var point_id: int = move_astar.coord_to_id(coord)
			move_astar.add_point(point_id, coord)
			if j > 0:
				move_astar.connect_points(point_id, point_id - 1)
				if j % 2 == 0:
					move_astar.connect_points(point_id, point_id - size_vec.y - 1)
			if i > 0:
				move_astar.connect_points(point_id, point_id - size_vec.y)
			if j % 2 == 0 and j < size_vec.y - 1:
				move_astar.connect_points(point_id, point_id - size_vec.y + 1)


static func init_sight_astar(size: MapSizeTable.Size) -> void:
	var size_vec: Vector2i = get_map_tile_size_vec(size)
	sight_astar = MapSightAStar2D.new()
	for i in range(size_vec.x):
		for j in range(size_vec.y):
			var coord := Vector2i(i, j)
			var point_id: int = sight_astar.coord_to_id(coord)
			sight_astar.add_point(point_id, coord)
			if j > 0:
				sight_astar.connect_points(point_id, point_id - 1)
				if j % 2 == 0:
					sight_astar.connect_points(point_id, point_id - size_vec.y - 1)
			if i > 0:
				sight_astar.connect_points(point_id, point_id - size_vec.y)
			if j % 2 == 0 and j < size_vec.y - 1:
				sight_astar.connect_points(point_id, point_id - size_vec.y + 1)


static func get_map_tile_size_vec(size: MapSizeTable.Size) -> Vector2i:
	return DatabaseUtils.map_size_tbl.query_by_enum_val(size).size_vec


static func get_border_tile_size_vec(size: MapSizeTable.Size) -> Vector2i:
	var map_tile_size: Vector2i = get_map_tile_size_vec(size)
	return 2 * (map_tile_size + Vector2i.ONE)


static func save_map() -> void:
	var json_string: String = JSON.stringify(get_persistance_dict())
	print("save | json_string:", json_string)
	var save_map: FileAccess = FileAccess.open("user://map.save", FileAccess.WRITE)
	save_map.store_line(json_string)


static func get_persistance_dict() -> Dictionary:
	return {
		"size": MapSizeTable.Size.DUAL,
		"type": MapTypeTable.Type.BLANK,
		"map_tile_info": serialize_map_tile_info(),
		"border_tile_info": serialize_border_tile_info(),
	}


static func serialize_map_tile_info() -> String:
	var res: String = ""
	var tiles: Array = DatabaseUtils.map_tile_tbl.select_arr(
			MySimSQL.QueryWrapper.new().order_by_asc("coord"))
	var row: int = 0
	for tile in tiles:
		var tile_do := tile as MapTileDO
		if tile_do.coord.x > row:
			res += ";"
			row = tile_do.coord.x
		else:
			res += ","
		if tile_do.continent != ContinentTable.Continent.EMPTY:
			res += str(tile_do.terrain) + "|" \
					+ str(tile_do.landscape) + "|" \
					+ ("1" if tile_do.village else "0") + "|" \
					+ str(tile_do.resource) + "|" \
					+ str(tile_do.continent)
		elif tile_do.resource != ResourceTable.ResourceType.EMPTY:
			res += str(tile_do.terrain) + "|" \
					+ str(tile_do.landscape) + "|" \
					+ ("1" if tile_do.village else "0") + "|" \
					+ str(tile_do.resource)
		elif tile_do.village:
			res += str(tile_do.terrain) + "|" \
					+ str(tile_do.landscape) + "|" \
					+ ("1" if tile_do.village else "0")
		elif tile_do.landscape != LandscapeTable.Landscape.EMPTY:
			res += str(tile_do.terrain) + "|" \
					+ str(tile_do.landscape)
		else:
			res += str(tile_do.terrain)
	return res


static func serialize_border_tile_info() -> String:
	var res: String = ""
	var borders: Array = DatabaseUtils.map_border_tbl.select_arr(
			MySimSQL.QueryWrapper.new().order_by_asc("coord"))
	var row: int = 0
	for border in borders:
		var border_do := border as MapBorderDO
		if border_do.coord.x > row:
			res += ";"
			row = border_do.coord.x
		else:
			res += ","
		res += str(border_do.tile_type)
	return res


static func load_from_save() -> bool:
	GlobalScript.record_time()
	GlobalScript.load_info = "读取地图存档..."
	if not FileAccess.file_exists("user://map.save"):
		printerr("load_from_save | Error! We don't have a save to load.")
		return false
	var save_map: FileAccess = FileAccess.open("user://map.save", FileAccess.READ)
	while save_map.get_position() < save_map.get_length():
		# 目前正常情况只有一行
		var json_string: String = save_map.get_line()
		GlobalScript.log_used_time_from_last_record("load_from_save", "reading file line")
		
		var json := JSON.new()
		var parse_result: Error = json.parse(json_string)
		if not parse_result == OK:
			printerr("load_from_save | JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var node_data: Variant = json.get_data()
		GlobalScript.log_used_time_from_last_record("load_from_save", "handling json")
		
		GlobalScript.load_info = "解析地图存档..."
		deserialize_map_tile_info(node_data["map_tile_info"])
		GlobalScript.log_used_time_from_last_record("load_from_save", "deserializing map")
		
		deserialize_border_tile_info(node_data["border_tile_info"])
		GlobalScript.log_used_time_from_last_record("load_from_save", "deserializing border")
	return true


static func deserialize_map_tile_info(data_str: String) -> void:
	# 清空原表
	DatabaseUtils.map_tile_tbl.truncate()
	var row_strs: PackedStringArray = data_str.split(";")
	var i: int = 0
	for row_str in row_strs:
		var elem_strs: PackedStringArray = row_str.split(",")
		var j: int = 0
		for elem_str in elem_strs:
			var field_strs: PackedStringArray = elem_str.split("|")
			var tile_do := MapTileDO.new()
			tile_do.coord = Vector2i(i, j)
			tile_do.terrain = int(field_strs[0])
			if field_strs.size() == 1:
				DatabaseUtils.map_tile_tbl.insert(tile_do)
				j += 1
				continue
			tile_do.landscape = int(field_strs[1])
			if field_strs.size() == 2:
				DatabaseUtils.map_tile_tbl.insert(tile_do)
				j += 1
				continue
			tile_do.village = int(field_strs[2]) == 1
			if field_strs.size() == 3:
				DatabaseUtils.map_tile_tbl.insert(tile_do)
				j += 1
				continue
			tile_do.resource = int(field_strs[3])
			if field_strs.size() == 4:
				DatabaseUtils.map_tile_tbl.insert(tile_do)
				j += 1
				continue
			tile_do.continent = int(field_strs[4])
			DatabaseUtils.map_tile_tbl.insert(tile_do)
			j += 1
		i += 1


static func deserialize_border_tile_info(data_str: String) -> void:
	# 清空原表
	DatabaseUtils.map_border_tbl.truncate()
	var row_strs: PackedStringArray = data_str.split(";")
	var i: int = 0
	for row_str in row_strs:
		var elem_strs: PackedStringArray = row_str.split(",")
		var j: int = 0
		for elem_str in elem_strs:
			var border_do := MapBorderDO.new()
			border_do.coord = Vector2i(i, j)
			border_do.tile_type = int(elem_str)
			DatabaseUtils.map_border_tbl.insert(border_do)
			j += 1
		i += 1


static func is_in_map_tile(coord: Vector2i) -> bool:
	var map_size: Vector2i = DatabaseUtils.map_size_tbl.query_by_enum_val(MapSizeTable.Size.DUAL).size_vec
	return coord.x >= 0 and coord.x < map_size.x and coord.y >= 0 and coord.y < map_size.y


static func change_map_tile_info(coord: Vector2i, tile_do: MapTileDO) -> void:
	var pre: MapTileDO = DatabaseUtils.map_tile_tbl.query_by_coord(coord)
	tile_do.id = pre.id
	DatabaseUtils.map_tile_tbl.update_by_id(tile_do)


static func change_border_tile_info(coord: Vector2i, border_do: MapBorderDO) -> void:
	var pre: MapBorderDO = DatabaseUtils.map_border_tbl.query_by_coord(coord)
	border_do.id = pre.id
	DatabaseUtils.map_border_tbl.update_by_id(border_do)


static func get_map_tile_do_by_coord(coord: Vector2i) -> MapTileDO:
	return DatabaseUtils.map_tile_tbl.query_by_coord(coord)


static func get_map_border_do_by_coord(coord: Vector2i) -> MapBorderDO:
	return DatabaseUtils.map_border_tbl.query_by_coord(coord)


static func get_in_map_surrounding_coords(coord: Vector2i, map_size: Vector2i) -> Array[Vector2i]:
	var oddr: HexagonUtils.OffsetCoord = HexagonUtils.OffsetCoord.odd_r(coord.x, coord.y)
	var result: Array[Vector2i] = []
	for direction in HexagonUtils.Direction.values():
		var neighbor_coord: Vector2i = oddr.neighbor(direction).to_vec2i()
		if neighbor_coord.y >= 0 and neighbor_coord.y < map_size.y \
				and neighbor_coord.x >= 0 and neighbor_coord.x < map_size.x:
			result.append(neighbor_coord)
	return result


static func get_tile_yield(coord: Vector2i) -> YieldDTO:
	var result := YieldDTO.new()
	var tile_do: MapTileDO = DatabaseUtils.map_tile_tbl.query_by_coord(coord)
	var terrain_do: TerrainDO = DatabaseUtils.terrain_tbl.query_by_enum_val(tile_do.terrain)
	var landscape_do: LandscapeDO = DatabaseUtils.landscape_tbl.query_by_enum_val(tile_do.landscape)
	var resource_do: ResourceDO = DatabaseUtils.resource_tbl.query_by_enum_val(tile_do.resource)
	result.culture = resource_do.culture
	result.food = terrain_do.food + landscape_do.food + resource_do.food
	result.production = terrain_do.production + landscape_do.production + resource_do.production
	result.science = resource_do.science
	result.religion = resource_do.religion
	result.gold = terrain_do.gold + landscape_do.gold + resource_do.gold
	return result


class MapAStar2D extends AStar2D:
	const UNREACHABLE_COST: float = 1e100
	
	
	func _compute_cost(from_id: int, to_id: int) -> float:
		return cost_by_id(from_id, to_id)
	
	
	func _estimate_cost(from_id: int, to_id: int) -> float:
		return cost_by_id(from_id, to_id)
	
	
	func coord_to_id(coord: Vector2i):
		return coord.x * MapService.get_map_tile_size_vec(MapSizeTable.Size.DUAL).y + coord.y
	
	
	func cost_by_id(from_id: int, to_id: int) -> float:
		var from_coord := Vector2i(get_point_position(from_id))
		var to_coord := Vector2i(get_point_position(to_id))
		return cost_by_coord(from_coord, to_coord)
	
	
	func cost_by_coord(from_coord: Vector2i, to_coord: Vector2i) -> float:
		# 抽象父类，必须被继承并且重写本方法
		printerr("please override cost_by_coord() if you extends MapAStar2D")
		return UNREACHABLE_COST
	
	
	func get_point_path_by_coord(from_coord: Vector2i, to_coord: Vector2i) -> PackedVector2Array:
		return get_point_path(coord_to_id(from_coord), coord_to_id(to_coord))
	
	
	func is_coord_path_unreachable(coord_path: PackedVector2Array) -> bool:
		for i in range(coord_path.size() - 1):
			if cost_by_coord(Vector2i(coord_path[i]), Vector2i(coord_path[i + 1])) == UNREACHABLE_COST:
				return false
		return true
	
	
	func coord_path_cost_sum(coord_path: PackedVector2Array) -> float:
		var cost_sum: float = 0.0
		for i in range(coord_path.size() - 1):
			cost_sum += cost_by_coord(Vector2i(coord_path[i]), Vector2i(coord_path[i + 1]))
		return cost_sum
	
	
	func get_in_range_coords_to_cost_dict(coord: Vector2i, range: int, dict: Dictionary = {coord: 0.0}) -> Dictionary:
		var map_size: Vector2i = MapService.get_map_tile_size_vec(MapSizeTable.Size.DUAL)
		var surroundings: Array[Vector2i] = MapService.get_in_map_surrounding_coords(coord, map_size)
		for surround in surroundings:
			var cost: float = cost_by_coord(coord, surround)
			if cost <= range:
				# 如果访问过地块，并且目前的路径消耗的行动力不会更少，则直接返回
				if dict.get(surround, UNREACHABLE_COST) <= dict[coord] + cost:
					continue
				dict[surround] = dict[coord] + cost
				# 如果还可以移动，则继续判断
				if cost < range:
					get_in_range_coords_to_cost_dict(surround, range - cost, dict)
		return dict


class MapMoveAStar2D extends MapAStar2D:
	func cost_by_coord(from_coord: Vector2i, to_coord: Vector2i) -> float:
		var from_tile: MapTileDO = MapService.get_map_tile_do_by_coord(from_coord)
		var to_tile: MapTileDO = MapService.get_map_tile_do_by_coord(to_coord)
		# 无法前往山脉和冰
		if TerrainService.is_mountain_land_terrain(to_tile.terrain) \
				or to_tile.landscape == LandscapeTable.Landscape.ICE:
			return UNREACHABLE_COST
		# FIXME: 暂时先让跨越陆海分隔的路线成本为无法到达
		if TerrainService.is_land_terrain(from_tile.terrain) \
				and TerrainService.is_sea_terrain(to_tile.terrain):
			return UNREACHABLE_COST
		if TerrainService.is_sea_terrain(from_tile.terrain) \
				and TerrainService.is_land_terrain(to_tile.terrain):
			return UNREACHABLE_COST
		# FIXME: 暂时没考虑跨河惩罚
		if TerrainService.is_hill_land_terrain(to_tile.terrain):
			return 2
		return 1


class MapSightAStar2D extends MapAStar2D:
	func cost_by_coord(from_coord: Vector2i, to_coord: Vector2i) -> float:
		var from_tile: MapTileDO = MapService.get_map_tile_do_by_coord(from_coord)
		var to_tile: MapTileDO = MapService.get_map_tile_do_by_coord(to_coord)
		if TerrainService.is_hill_land_terrain(to_tile.terrain) \
				or TerrainService.is_mountain_land_terrain(to_tile.terrain):
			return 2
		return 1
