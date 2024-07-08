class_name HexTile
extends RefCounted


signal tile_changed(tile: HexTile)

var id: int
var neighbor_ids: Array = []
var chunk_id: int
var center: Vector3
var vertices: Array
var height: float

var planet: HexPlanet
var color: Color
# 相邻的 HexTile（Godot Array 默认不是 null 而是 [] 坑人啊！）
var neighbors: Array


func _init(id: int, planet: HexPlanet, center: Vector3, verts: Array) -> void:
	self.id = id
	self.planet = planet
	self.center = center
	self.vertices = verts
	self.height = 0.0


func append_to_mesh(mesh_verts: Array, mesh_indices: Array, mesh_colors: Array) -> void:
	# 生成六边形基础
	var base_index = mesh_verts.size()
	mesh_verts.append(transform_point(center, height))
	mesh_colors.append(color)
	for j in range(vertices.size()):
		mesh_verts.append(transform_point(vertices[j], height))
		mesh_colors.append(color)
		
		mesh_indices.append(base_index)
		mesh_indices.append(base_index + (j + 1) % vertices.size() + 1)
		mesh_indices.append(base_index + j + 1)
	
	# 如果需要生成墙的话，生成
	var neighbors = get_neighbors()
	#print("neighbors: ", neighbors)
	for j in range(neighbors.size()):
		var this_height = height
		var other_height = neighbors[j].height
		if not other_height < this_height:
			continue
		base_index = mesh_verts.size()
		# 添加栅栏
		mesh_verts.append(transform_point(vertices[(j + 1) % vertices.size()], other_height))
		mesh_verts.append(transform_point(vertices[j], other_height))
		mesh_verts.append(transform_point(vertices[(j + 1) % vertices.size()], this_height))
		mesh_verts.append(transform_point(vertices[j], this_height))
		
		mesh_colors.append(color)
		mesh_colors.append(color)
		mesh_colors.append(color)
		mesh_colors.append(color)
		
		mesh_indices.append(base_index)
		mesh_indices.append(base_index + 1)
		mesh_indices.append(base_index + 2)
		
		mesh_indices.append(base_index + 2)
		mesh_indices.append(base_index + 1)
		mesh_indices.append(base_index + 3)


func transform_point(input: Vector3, height: float) -> Vector3:
	return input * (1 + height / planet.radius)


func set_chunk(chunk_id: int) -> void:
	self.chunk_id = chunk_id


func add_neighbors(nbrs: Array) -> void:
	#print("tile id: ", id, " adding neighbors: ", nbrs.map(func(n): return n.id))
	for nbr in nbrs:
		neighbor_ids.append(nbr.id)


func set_height(new_height: float) -> void:
	height = new_height
	trigger_mesh_recompute()


func get_neighbors() -> Array:
	# Godot Array 默认不是 null 而是 [] 坑人啊！
	if neighbors.size() == neighbor_ids.size():
		return neighbors
	neighbors = []
	for nid in neighbor_ids:
		neighbors.append(planet.get_tile(nid))
	return neighbors


func trigger_mesh_recompute() -> void:
	tile_changed.emit(self)
