class_name MapController


static func init_map() -> void:
	MapService.init_map_tile_table()
	MapService.init_map_border_table()


static func init_astar() -> void:
	MapService.init_move_astar()
	MapService.init_sight_astar()


static func get_in_move_range_dict(coord: Vector2i, range: int):
	return MapService.move_astar.get_in_range_coords_to_cost_dict(coord, range)


static func get_in_sight_range_dict(coord: Vector2i, range: int):
	return MapService.sight_astar.get_in_range_coords_to_cost_dict(coord, range)


static func get_move_cost_sum(from: Vector2i, to: Vector2i):
	return MapService.move_astar.coord_path_cost_sum(MapService.move_astar.get_point_path_by_coord(from, to))


static func is_in_map_tile(coord: Vector2i):
	return MapService.is_in_map_tile(coord)


static func get_map_tile_size_vec() -> Vector2i:
	return MapService.get_map_tile_size_vec()


static func get_border_tile_size_vec() -> Vector2i:
	return MapService.get_border_tile_size_vec()


static func get_map_tile_do_by_coord(coord: Vector2i) -> MapTileDO:
	return MapTileService.get_map_tile_do_by_coord(coord)


static func change_map_tile_info(coord: Vector2i, tile_do: MapTileDO) -> void:
	return MapTileService.change_map_tile_info(coord, tile_do)


static func get_map_border_do_by_coord(coord: Vector2i) -> MapBorderDO:
	return MapService.get_map_border_do_by_coord(coord)


static func change_border_tile_info(coord: Vector2i, border_do: MapBorderDO) -> void:
	return MapService.change_border_tile_info(coord, border_do)


static func save_map() -> void:
	MapService.save_map()


static func load_from_save() -> bool:
	return MapService.load_from_save()


static func get_tile_yield(coord: Vector2i) -> YieldDTO:
	return MapTileService.get_tile_yield(coord)


static func get_tile_info(coord: Vector2i) -> TileInfoDTO:
	return MapTileService.get_tile_info(coord)


static func get_surrounding_cells(map_coord: Vector2i, dist: int, include_inside: bool) -> Array[Vector2i]:
	# Godot 这个假范型，真垃圾…… 还得这样脱裤子放屁拐一下，不然后面 .map() 返回的是 Array
	var result: Array[Vector2i] = []
	if dist < 0:
		return result
	var oddr: HexagonUtils.OffsetCoord = HexagonUtils.OffsetCoord.odd_r(map_coord.x, map_coord.y)
	if include_inside:
		result.append_array(oddr.to_axial().spiral(dist) \
				.map(func(hex: HexagonUtils.Hex): return hex.to_oddr().to_vec2i()))
	else:
		result.append_array(oddr.to_axial().ring(dist) \
				.map(func(hex: HexagonUtils.Hex): return hex.to_oddr().to_vec2i()))
	return result
