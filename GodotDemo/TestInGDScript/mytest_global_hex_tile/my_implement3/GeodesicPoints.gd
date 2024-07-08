class_name GeodesicPoints
extends RefCounted


static func gen_points(subdivides: int, radius: float) -> Array:
	const m: float = 0.525731112119133606
	const n: float = 0.850650808352039932
	var vertices := [
		Vector3(-m, 0, n),
		Vector3(m, 0, n),
		Vector3(-m, 0, -n),
		Vector3(m, 0, -n),
		Vector3(0, n, m),
		Vector3(0, n, -m),
		Vector3(0, -n, m),
		Vector3(0, -n, -m),
		Vector3(n, m, 0),
		Vector3(-n, m, 0),
		Vector3(n, -m, 0),
		Vector3(-n, -m, 0)
	]
	
	# 这里的索引并不参与渲染，只是用于细分的计算，所以顺序是按 Unity 的顺序写的
	var indices := [
		1, 4, 0, # UnityHexPlanet C# 版的顺序，在 Godot 里按道理用来渲染得写成 1, 0, 4
		4, 9, 0,
		4, 5, 9,
		8, 5, 4,
		1, 8, 4,
		1, 10, 8,
		10, 3, 8,
		8, 3, 5,
		3, 2, 5,
		3, 7, 2,
		3, 10, 7,
		10, 6, 7,
		6, 11, 7,
		6,  0,11,
		6, 1, 0,
		10, 1, 6,
		11, 0, 9,
		2, 11, 9,
		5, 2, 9,
		11, 2, 7,
	]
	
	var flatVertices = []
	var flatIndices = []
	
	for i in range(indices.size()):
		flatVertices.append(vertices[indices[i]])
		flatIndices.append(i)
	
	vertices = flatVertices
	indices = flatIndices
	#print("vertices.size: ", vertices.size(), ", indices.size: ", indices.size())
	# 细分
	for i in range(subdivides):
		indices = subdivide_sphere(vertices, indices)
		#print("i: ", i, ", vertices.size: ", vertices.size(), ", indices.size: ", indices.size())
	# 缩放
	for i in range(vertices.size()):
		vertices[i] *= radius
	# 去重
	return distinct(vertices)


# TODO: 写个 Utils 类
static func distinct(vertices: Array) -> Array:
	var result = []
	for i in range(vertices.size() - 1):
		var no_close_vert: bool = true
		for j in range(i + 1, vertices.size()):
			if (vertices[i] as Vector3).is_equal_approx(vertices[j]):
				no_close_vert = false
				break
		if no_close_vert:
			result.append(vertices[i])
	result.append(vertices.back())
	#print("distinct result.size: ", result.size())
	return result


static func subdivide_sphere(vertices: Array, indices: Array) -> Array:
	var new_indices = []
	var tri_count: int = indices.size() / 3
	for tri in range(tri_count):
		# 获取我们将要细分的三角形的顶点
		var old_vert_index: int = tri * 3
		var idx_a: int = indices[old_vert_index]
		var idx_b: int = indices[old_vert_index + 1]
		var idx_c: int = indices[old_vert_index + 2]
		var v_a: Vector3 = vertices[idx_a]
		var v_b: Vector3 = vertices[idx_b]
		var v_c: Vector3 = vertices[idx_c]
		# 找到新的顶点
		var v_ab = v_a.lerp(v_b, 0.5).normalized()
		var v_bc = v_b.lerp(v_c, 0.5).normalized()
		var v_ac = v_a.lerp(v_c, 0.5).normalized()
		# 将新的顶点添加到顶点列表
		var new_vert_index = vertices.size()
		vertices.append(v_ab)
		vertices.append(v_bc)
		vertices.append(v_ac)
		# 增加新的索引
		# 中间三角形
		new_indices.append(new_vert_index)
		new_indices.append(new_vert_index + 1)
		new_indices.append(new_vert_index + 2)
		# A 三角形
		new_indices.append(new_vert_index + 2)
		new_indices.append(idx_a)
		new_indices.append(new_vert_index)
		# B 三角形
		new_indices.append(new_vert_index)
		new_indices.append(idx_b)
		new_indices.append(new_vert_index + 1)
		# C 三角形
		new_indices.append(new_vert_index + 1)
		new_indices.append(idx_c)
		new_indices.append(new_vert_index + 2)
	return new_indices

