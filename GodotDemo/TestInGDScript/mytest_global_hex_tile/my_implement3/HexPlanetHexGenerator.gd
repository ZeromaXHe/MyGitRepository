class_name HexPlanetHexGenerator
extends RefCounted


static func generate_planet_tiles_and_chunks(planet: HexPlanet) -> void:
	var points = GeodesicPoints.gen_points(planet.subdivisions, planet.radius)
	var tiles = gen_hex_tiles(planet, points)
	
	var chunk_origins = GeodesicPoints.gen_points(planet.chunk_subdivisions, planet.radius)
	var chunks = gen_hex_chunks(planet, tiles, chunk_origins)
	planet.chunks = chunks
	planet.tiles = tiles


static func gen_hex_tiles(planet: HexPlanet, sphere_verts: Array) -> Array:
	var hex_tiles = []
	# 获取去重过的顶点
	var sphere_verts_distinct = {}
	for v in sphere_verts:
		sphere_verts_distinct[v] = true
	var unique_verts = sphere_verts_distinct.keys()
	# 使用所有将成为六边形中心的点，构建八叉树
	var vert_octree = Octree.new(Vector3.ONE * (planet.radius * -1.1), \
		Vector3.ONE * (planet.radius * 1.1))
	for v in unique_verts:
		vert_octree.insert_point(v, v)
	# 两个相邻地块的最大距离
	var back_vert: Vector3 = unique_verts.back()
	unique_verts.sort_custom(
		func(a: Vector3, b: Vector3):
			(a - back_vert).length_squared() < \
			(b - back_vert).length_squared())
	# TODO: 没有 Linq 的 Take(7) 优化，可能会很慢？
	var max_dist_between_neighbors: float = \
		sqrt((unique_verts[6] as Vector3 - back_vert).length_squared()) * 1.2
	# 构建瓦片
	for i in range(unique_verts.size()):
		var unique_vert: Vector3 = unique_verts[i]
		var closest_verts: Array = vert_octree.get_points(unique_vert, Vector3.ONE * max_dist_between_neighbors)
		closest_verts.sort_custom(
			func(a: Vector3, b:Vector3):
				(a - unique_vert).length_squared() < (b - unique_vert).length_squared())
		if closest_verts.size() > 7:
			closest_verts.resize(7)
		# 第七个点比第六个点远了 1.5 倍的话，截取六个点（五边形）
		if closest_verts.size() == 7 and (closest_verts[6] as Vector3 - unique_vert).length() \
				> (closest_verts[5] as Vector3 - unique_vert).length() * 1.5:
			closest_verts.resize(6)
		# 排除掉自己
		closest_verts.pop_front()
		# 按随索引增加，逆时针排序的顺序排列最近的点
		# BUG: 这是个 hack 并可能导致 bug
		var angle_axis = Vector3.UP + Vector3.ONE * 0.1
		closest_verts.sort_custom(
			func(a: Vector3, b: Vector3):
				-(a - unique_vert).signed_angle_to(angle_axis, unique_vert) < \
				-(b - unique_vert).signed_angle_to(angle_axis, unique_vert)
		)
		var hex_verts = []
		for j in range(closest_verts.size()):
			var lerp_j = unique_vert.lerp(closest_verts[j], 0.66666666)
			var lerp_j_plus1 = unique_vert.lerp(closest_verts[(j + 1) % closest_verts.size()], 0.66666666)
			hex_verts.append(lerp_j.lerp(lerp_j_plus1, 0.5))
		# 找到中间顶点
		var center = Vector3.ZERO
		for j in range(hex_verts.size()):
			center += hex_verts[j]
		center /= hex_verts.size()
		
		var hex_tile = planet.terrain_generator.create_hex_tile(i, planet, center, hex_verts)
		hex_tiles.append(hex_tile)
	# 使用将成为六边形中心的所有点作为 key，HexTile 作为 value，来构建一个 HexTile 八叉树
	var hex_octree = Octree.new(Vector3.ONE * planet.radius * -1.1, \
		Vector3.ONE * planet.radius * 1.1)
	for h: HexTile in hex_tiles:
		hex_octree.insert_point(h, h.center)
	# 找到相邻地块
	for i in range(hex_tiles.size()):
		var current_tile: HexTile = hex_tiles[i]
		var closest_hexes: Array = hex_octree.get_points(current_tile.center, Vector3.ONE * max_dist_between_neighbors)
		closest_hexes.sort_custom(
			func(a: HexTile, b:HexTile):
				(a.center - current_tile.center).length_squared() < (b.center - current_tile.center).length_squared())
		if closest_hexes.size() > 7:
			closest_hexes.resize(7)
		if closest_hexes.size() == 7 and ((closest_hexes[6] as HexTile).center - current_tile.center).length() \
				> ((closest_hexes[5] as HexTile).center - current_tile.center).length() * 1.5:
			closest_hexes.resize(6) # 一定是五边形
		# 排除自己，最近的瓦片
		closest_hexes.pop_front()
		# 根据顶点将瓦片排序
		var verts = current_tile.vertices
		var ordered_neighbors = []
		for j in range(verts.size()):
			closest_hexes.sort_custom(
				func(a: HexTile, b: HexTile):
					-((verts[j] as Vector3 + verts[(j + 1) % verts.size()] as Vector3) / 2) \
						.normalized().dot(a.center.normalized()) < \
					-((verts[j] as Vector3 + verts[(j + 1) % verts.size()] as Vector3) / 2) \
						.normalized().dot(b.center.normalized())
			)
			ordered_neighbors.append(closest_hexes[0])
		current_tile.add_neighbors(ordered_neighbors)
	# 通过生成器启动每个瓦片
	for tile: HexTile in hex_tiles:
		planet.terrain_generator.after_tile_creation(tile)
	return hex_tiles


static func gen_hex_chunks(planet: HexPlanet, tiles: Array, chunk_centers: Array) -> Array:
	var chunk_count: int = chunk_centers.size()
	var chunks = []
	for i in range(chunk_count):
		chunks.append(HexChunk.new(i, planet, chunk_centers[i]))
	for i in range(tiles.size()):
		var tile: HexTile = tiles[i]
		chunks.sort_custom(
			func(a: HexChunk, b: HexChunk):
				(tile.center - a.origin).length_squared() < \
				(tile.center - b.origin).length_squared())
		var best_chunk: HexChunk = chunks[0]
		best_chunk.add_tile(tile.id)
		tile.set_chunk(best_chunk.id)
	return chunks
