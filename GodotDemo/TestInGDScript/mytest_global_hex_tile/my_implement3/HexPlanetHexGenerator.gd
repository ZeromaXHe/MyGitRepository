class_name HexPlanetHexGenerator
extends RefCounted


static func generate_planet_tiles_and_chunks(planet: HexPlanet) -> void:
	# 测试 static sort_custom() bug 的方法
	#sort_custom_test()
	#sort_custom_static_test()
	
	planet.clear_spheres_and_lines()
	var points = GeodesicPoints.gen_points(planet.subdivisions, planet.radius)
	#print("test-log|points: ", points)
	var tiles = gen_hex_tiles(planet, points)
	var tile_centers = tiles.map(func(t): return t.center)
	#print("test-log|tile_centers: ", tile_centers)
	
	var chunk_origins = GeodesicPoints.gen_points(planet.chunk_subdivisions, planet.radius)
	#print("test-log|chunk_origins: ", chunk_origins)
	planet.draw_spheres(tile_centers, chunk_origins)
	var chunks = gen_hex_chunks(planet, tiles, chunk_origins)
	planet.chunks = chunks
	planet.tiles = tiles
	#print("test-log|tiles: ", tiles, " chunks: ", chunks)


## 用 lambda 在 static 方法中执行 sort_custom() 会失效，也没有报错！
static func sort_custom_test() -> void:
	var unique_verts = [
		Vector3(10, 10, 10),
		Vector3(3, 3, 3),
		Vector3(6, 6, 6),
		Vector3(9, 9, 9),
		Vector3(1, 1, 1),
		Vector3(7, 7, 7),
		Vector3(5, 5, 5),
		Vector3(4, 4, 4),
		Vector3(8, 8, 8),
		Vector3(2, 2, 2),
		Vector3(0, 0, 0),
		]
	var back_vert: Vector3 = unique_verts.back()
	print("sort_custom_test | back_vert: ", back_vert)
	unique_verts.sort_custom(
		func(a: Vector3, b: Vector3):
			(a - back_vert).length_squared() < (b - back_vert).length_squared())
	# TODO: 没有 Linq 的 Take(7) 优化，可能会很慢？
	var max_dist_between_neighbors: float = \
		sqrt((unique_verts[6] as Vector3 - back_vert).length_squared()) * 1.2
	print("sort_custom_test | max_dist_between_neighbors: ", max_dist_between_neighbors)
	print("sort_custom_test | unique_verts: ", unique_verts)
	print("sort_custom_test | unique_verts length: ", unique_verts.map(func(v: Vector3): return (v - back_vert).length_squared()))
	print("=============================")


## static 方法中的 sort_custom 必须这样写排序才能生效…… 不能用 lambda
static func sort_custom_static_test() -> void:
	var unique_verts = [
		Vector3(10, 10, 10),
		Vector3(3, 3, 3),
		Vector3(6, 6, 6),
		Vector3(9, 9, 9),
		Vector3(1, 1, 1),
		Vector3(7, 7, 7),
		Vector3(5, 5, 5),
		Vector3(4, 4, 4),
		Vector3(8, 8, 8),
		Vector3(2, 2, 2),
		Vector3(0, 0, 0),
		]
	var back_vert: Vector3 = unique_verts.back()
	print("sort_custom_test | back_vert: ", back_vert)
	vec_for_static_sort = back_vert
	unique_verts.sort_custom(cmp_minus_vec_length_squared)
	# TODO: 没有 Linq 的 Take(7) 优化，可能会很慢？
	var max_dist_between_neighbors: float = \
		sqrt((unique_verts[6] as Vector3 - back_vert).length_squared()) * 1.2
	print("sort_custom_test | max_dist_between_neighbors: ", max_dist_between_neighbors)
	print("sort_custom_test | unique_verts: ", unique_verts)
	print("sort_custom_test | unique_verts length: ", unique_verts.map(func(v: Vector3): return (v - back_vert).length_squared()))
	print("=============================")


# 注意：这里引入了用于 static 排序的变量
static var vec_for_static_sort: Vector3
static var axis_for_static_sort: Vector3
static var tile_for_static_sort: HexTile


static func cmp_minus_vec_length_squared(a: Vector3, b: Vector3) -> bool:
	return (a - vec_for_static_sort).length_squared() < (b - vec_for_static_sort).length_squared()


static func cmp_neg_minus_vec_signed_angle_to_axis(a: Vector3, b: Vector3) -> bool:
	return -(a - vec_for_static_sort).signed_angle_to(axis_for_static_sort, vec_for_static_sort) < \
		-(b - vec_for_static_sort).signed_angle_to(axis_for_static_sort, vec_for_static_sort)


static func cmp_center_minus_tile_length_squared(a: HexTile, b:HexTile) -> bool:
	return (a.center - tile_for_static_sort.center).length_squared() < \
		(b.center - tile_for_static_sort.center).length_squared()


static func cmp_vec_dot_center_normalized(a: HexTile, b: HexTile) -> bool:
	return vec_for_static_sort.dot(a.center.normalized()) < vec_for_static_sort.dot(b.center.normalized())


static func cmp_tile_center_minus_origin_length_squared(a: HexChunk, b: HexChunk) -> bool:
	return (tile_for_static_sort.center - a.origin).length_squared() < \
		(tile_for_static_sort.center - b.origin).length_squared()


static func gen_hex_tiles(planet: HexPlanet, sphere_verts: Array) -> Array:
	var hex_tiles = []
	# 获取去重过的顶点
	var unique_verts = GeodesicPoints.distinct(sphere_verts)
	# 使用所有将成为六边形中心的点，构建八叉树
	var vert_octree = Octree.new(Vector3.ONE * (planet.radius * -1.1), \
		Vector3.ONE * (planet.radius * 1.1))
	for v in unique_verts:
		vert_octree.insert_point(v, v)
		#print("vertOctTree inserting ", v);
	# 两个相邻地块的最大距离
	var back_vert: Vector3 = unique_verts.back()
	vec_for_static_sort = back_vert
	unique_verts.sort_custom(cmp_minus_vec_length_squared)
	# TODO: 没有 Linq 的 Take(7) 优化，可能会很慢？
	var max_dist_between_neighbors: float = \
		sqrt((unique_verts[6] as Vector3 - back_vert).length_squared()) * 1.2
	#print("max_dist_between_neighbors: ", max_dist_between_neighbors, \
		#" unique_verts length: ", unique_verts.map(func(v: Vector3): return (v - back_vert).length_squared()))
	# 构建瓦片
	for i in range(unique_verts.size()):
		var unique_vert: Vector3 = unique_verts[i]
		var closest_verts: Array = vert_octree.get_points(unique_vert, Vector3.ONE * max_dist_between_neighbors)
		#print("closest_verts.size: ", closest_verts.size(), ", unique_vert: ", unique_vert);
		vec_for_static_sort = unique_vert
		closest_verts.sort_custom(cmp_minus_vec_length_squared)
		while closest_verts.size() > 7:
			closest_verts.pop_back()
		# 第七个点比第六个点远了 1.5 倍的话，截取六个点（五边形）
		if closest_verts.size() == 7 and (closest_verts[6] as Vector3 - unique_vert).length() \
				> (closest_verts[5] as Vector3 - unique_vert).length() * 1.5:
			closest_verts.pop_back()
		# 排除掉自己
		closest_verts.pop_front()
		#print("closest.count: ", closest_verts.size(), \
			#" length:", closest_verts.map(func(v: Vector3): return (v - unique_vert).length()))
		# 按随索引增加，逆时针排序的顺序排列最近的点
		# BUG: 这是个 hack 并可能导致 bug
		var angle_axis = Vector3.UP + Vector3.ONE * 0.1
		axis_for_static_sort = angle_axis
		vec_for_static_sort = unique_vert
		closest_verts.sort_custom(cmp_neg_minus_vec_signed_angle_to_axis)
		var hex_verts = []
		for j in range(closest_verts.size()):
			var vert_j = closest_verts[j]
			var vert_j_plus1 = closest_verts[(j + 1) % closest_verts.size()]
			planet.draw_line(vert_j, vert_j_plus1)
			var lerp_j = unique_vert.lerp(vert_j, 0.66666666)
			var lerp_j_plus1 = unique_vert.lerp(vert_j_plus1, 0.66666666)
			hex_verts.append(lerp_j.lerp(lerp_j_plus1, 0.5))
		# 找到中间顶点
		var center = Vector3.ZERO
		for j in range(hex_verts.size()):
			center += hex_verts[j]
		center /= hex_verts.size()
		#print("center: ", center, ", hex_verts.size: ", hex_verts.size(), \
			#" length: ", hex_verts.map(func(v: Vector3): return (v - unique_vert).length()))
		
		var hex_tile = planet.terrain_generator.create_hex_tile(i, planet, center, hex_verts)
		hex_tiles.append(hex_tile)
	# 使用将成为六边形中心的所有点作为 key，HexTile 作为 value，来构建一个 HexTile 八叉树
	var hex_octree = Octree.new(Vector3.ONE * planet.radius * -1.1, \
		Vector3.ONE * planet.radius * 1.1)
	for h: HexTile in hex_tiles:
		hex_octree.insert_point(h, h.center)
		#print("inserting point h: ", h, ", h.center: ", h.center)
	# 找到相邻地块
	for i in range(hex_tiles.size()):
		var current_tile: HexTile = hex_tiles[i]
		var closest_hexes: Array = hex_octree.get_points(current_tile.center, Vector3.ONE * max_dist_between_neighbors)
		tile_for_static_sort = current_tile
		closest_hexes.sort_custom(cmp_center_minus_tile_length_squared)
		while closest_hexes.size() > 7:
			closest_hexes.pop_back()
		if closest_hexes.size() == 7 and ((closest_hexes[6] as HexTile).center - current_tile.center).length() \
				> ((closest_hexes[5] as HexTile).center - current_tile.center).length() * 1.5:
			closest_hexes.pop_back() # 一定是五边形
		# 排除自己，最近的瓦片
		closest_hexes.pop_front()
		#print("i: ", i, ", closest_hexes: ", \
			#closest_hexes.map(func(a): return (a.center - tile_for_static_sort.center).length_squared()))
		# 根据顶点将瓦片排序
		var verts = current_tile.vertices
		#print("verts: ", verts)
		var ordered_neighbors = []
		for j in range(verts.size()):
			vec_for_static_sort = -((verts[j] as Vector3 + verts[(j + 1) % verts.size()] as Vector3) / 2).normalized()
			closest_hexes.sort_custom(cmp_vec_dot_center_normalized)
			if closest_hexes.size() > 0:
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
		tile_for_static_sort = tile
		chunks.sort_custom(cmp_tile_center_minus_origin_length_squared)
		var best_chunk: HexChunk = chunks[0]
		#print("test-log|best_chunk.id: ", best_chunk.id, " tile.id: ", tile.id, \
			#" tile.center:", tile.center, " | chunks.id: ", chunks.map(func(chunk): return chunk.id), \
			#" | chunks.origin: ", chunks.map(func(chunk): return chunk.origin))
		best_chunk.add_tile(tile.id)
		tile.set_chunk(best_chunk.id)
	return chunks
