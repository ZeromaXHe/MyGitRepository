class_name MapBorderController


static func is_river_placeable(border_coord: Vector2i) -> bool:
	if ViewHolder.get_map_shower().is_in_map_border(border_coord) <= 0 or MapBorderUtils.get_border_type(border_coord) == MapBorderTable.Type.CENTER:
		return false
	var neighbor_tile_coords: Array[Vector2i] = MapBorderUtils.get_neighbor_tile_of_border(border_coord)
	for coord in neighbor_tile_coords:
		if not MapController.is_in_map_tile(coord):
			continue
		var terrain_type: TerrainTable.Terrain = MapController.get_map_tile_do_by_coord(coord).terrain
		if TerrainController.is_sea_terrain(terrain_type):
			# 和浅海或者深海相邻
			return false
	var end_tile_coords: Array[Vector2i] = MapBorderUtils.get_end_tile_of_border(border_coord)
	for coord in end_tile_coords:
		if not MapController.is_in_map_tile(coord):
			continue
		var terrain_type: TerrainTable.Terrain = MapController.get_map_tile_do_by_coord(coord).terrain
		if TerrainController.is_sea_terrain(terrain_type):
			# 末端是浅海或者深海
			return true
	var connect_border_coords: Array[Vector2i] = MapBorderUtils.get_connect_border_of_border(border_coord)
	for coord in connect_border_coords:
		var border_tile_type: MapBorderTable.TileType = MapController.get_map_border_do_by_coord(coord).tile_type
		if border_tile_type == MapBorderTable.TileType.RIVER:
			# 连接的边界有河流
			return true
	return false


static func is_cliff_placeable(border_coord: Vector2i) -> bool:
	if ViewHolder.get_map_shower().is_in_map_border(border_coord) <= 0 or MapBorderUtils.get_border_type(border_coord) == MapBorderTable.Type.CENTER:
		return false
	var neighbor_tile_coords: Array[Vector2i] = MapBorderUtils.get_neighbor_tile_of_border(border_coord)
	var neighbor_sea: bool = false
	var neighbor_land: bool = false
	for coord in neighbor_tile_coords:
		var terrain_type: TerrainTable.Terrain = MapController.get_map_tile_do_by_coord(coord).terrain
		if TerrainController.is_sea_terrain(terrain_type):
			# 和浅海或者深海相邻
			neighbor_sea = true
		else:
			neighbor_land = true
	return neighbor_land and neighbor_sea