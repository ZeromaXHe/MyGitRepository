@tool
extends Node3D


@export_range(1, 10000) var radius: float = 100
@export_range(1, 1000) var edge_segment: int = 1
@export var regenerate: bool = false
# true 分段时是采用球面旋转计算，false 时采用直线分段后映射到球面
@export var segment_by_rotation: bool = true
@export var hexagon_tile: PackedScene
@export var pentagon_tile: PackedScene

var up_for_hexagon_dict: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_mesh()


func generate_mesh() -> void:
	# 参考 [OGL][探讨]正二十面体(Icosahedron)的顶点坐标取值 
	# https://bbs.bccn.net/thread-365031-1-1.html
	var m: float = 0.525731112119133606
	var n: float = 0.850650808352039932
	var vertices := PackedVector3Array([
		radius * Vector3(-m, 0, n),
		radius * Vector3(m, 0, n),
		radius * Vector3(-m, 0, -n),
		radius * Vector3(m, 0, -n),
		radius * Vector3(0, n, m),
		radius * Vector3(0, n, -m),
		radius * Vector3(0, -n, m),
		radius * Vector3(0, -n, -m),
		radius * Vector3(n, m, 0),
		radius * Vector3(-n, m, 0),
		radius * Vector3(n, -m, 0),
		radius * Vector3(-n, -m, 0)
	])
	# 节点的顺序会决定渲染表面的方向
	# 左手按第一个点在手腕，第三个点在指尖的顺时针方向匹配的话，大拇指向上的方向是可以看到表面的方向
	var indices := PackedInt32Array([
		1, 0, 4, # 比如这里如果写 1, 4, 0 就会渲染到内表面去
		4, 0, 9,
		4, 9, 5,
		8, 4, 5,
		1, 4, 8,
		1, 8, 10,
		10, 8, 3,
		8, 5, 3,
		3, 5, 2,
		3, 2, 7,
		3, 7, 10,
		10, 7, 6,
		6, 7, 11,
		6, 11, 0,
		6, 0, 1,
		10, 6, 1,
		11, 9, 0,
		2, 9, 11,
		5, 9, 2,
		11, 7, 2
	])
	
	var connect_map = init_connect_map(indices)
	var visited_map = init_visited_map()
	# 绘制所有顶点球
	for v in vertices:
		draw_on_pos(v, false)
	# 处理面上的分段顶点
	for i in range(indices.size() / 3):
		draw_face_index(vertices, indices[i * 3], indices[i * 3 + 1], indices[i * 3 + 2], visited_map)


func init_visited_map() -> Array:
	# 将是一个 bool 的二维数组，表示两个索引顶点间的边是否被绘制过
	var visited_map = []
	# 初始化 12 个顶点间的连通状态为 false
	for i in range(12):
		visited_map.append([])
		for j in range(12):
			visited_map[i].append(false)
	return visited_map


func init_connect_map(indices: PackedInt32Array) -> Array:
	# 将是一个 bool 的二维数组，表示两个坐标间的连通状态
	var connect_map = []
	# 初始化 12 个顶点间的连通状态为 false
	for i in range(12):
		connect_map.append([])
		for j in range(12):
			connect_map[i].append(false)
	
	for i in range(indices.size()):
		if i % 3 == 0:
			continue
		# 这里之所以不需要反着再置 true，是因为同一条边一定会正反访问两次
		# 因为面的绘制有我之前说的“左手定则”（姑且这么叫）决定法线方向，所以所有的边一定会按 (a, b) 和 (b, a) 的顺序出现两次
		# 记住有这样一个特性，去重什么的都很方便
		connect_map[indices[i]][indices[i-1]] = true
	return connect_map


func draw_on_pos(pos: Vector3, hex: bool = true) -> void:
	#print("drawing on pos:", pos, " i:", i)
	draw_sphere_on_pos(pos)
	if hex:
		draw_hexagon_tile_on_pos(pos)
	else:
		draw_pentagon_tile_on_pos(pos)


func draw_sphere_on_pos(pos: Vector3) -> void:
	var ins := MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere := SphereMesh.new()
	sphere.radius = radius / edge_segment / 40
	sphere.height = radius / edge_segment / 20
	ins.mesh = sphere
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	ins.set_surface_override_material(0, material)


func draw_hexagon_tile_on_pos(pos: Vector3) -> void:
	var hexagon = hexagon_tile.instantiate() as MeshInstance3D
	hexagon.edge_len = radius * 0.75 / edge_segment
	add_child(hexagon)
	hexagon.look_at_from_position(pos, Vector3.ZERO, up_for_hexagon_dict[pos])


func draw_pentagon_tile_on_pos(pos: Vector3) -> void:
	var pentagon = pentagon_tile.instantiate() as MeshInstance3D
	pentagon.edge_len = radius * 0.75 / edge_segment
	add_child(pentagon)
	pentagon.look_at_from_position(pos, Vector3.ZERO, get_up_vector_for_pentagon(pos))


func get_up_vector_for_pentagon(pos: Vector3) -> Vector3:
	var abs_x = abs(pos.x)
	var abs_y = abs(pos.y)
	var abs_z = abs(pos.z)
	if abs_x > abs_y and abs_x > abs_z:
		return Vector3(-pos.x, 0, 0)
	elif abs_y > abs_x and abs_y > abs_z:
		return Vector3(0, -pos.y, 0)
	elif abs_z > abs_x and abs_z > abs_y:
		return Vector3(0, 0, -pos.z)
	else:
		printerr("error up vector for pentagon")
		return Vector3.UP


func draw_face_index(vertices: PackedVector3Array, i1: int, i2: int, i3: int, visited_map: Array) -> void:
	var v21 = get_segment_vertices(vertices[i2], vertices[i1], edge_segment)
	var v23 = get_segment_vertices(vertices[i2], vertices[i3], edge_segment)
	var v13 = get_segment_vertices(vertices[i1], vertices[i3], edge_segment)
	# 检验边是否绘制过，没绘制的话就画
	if not visited_map[i2][i1]:
		for v in v21:
			if v == vertices[i2] or v == vertices[i1]:
				continue
			draw_on_pos(v)
		visited_map[i1][i2] = true
		visited_map[i2][i1] = true
	if not visited_map[i2][i3]:
		for v in v23:
			if v == vertices[i2] or v == vertices[i3]:
				continue
			draw_on_pos(v)
		visited_map[i2][i3] = true
		visited_map[i3][i2] = true
	if not visited_map[i1][i3]:
		for v in v13:
			if v == vertices[i1] or v == vertices[i3]:
				continue
			draw_on_pos(v)
		visited_map[i1][i3] = true
		visited_map[i3][i1] = true
	# 绘制真正面内部的顶点
	var pre_vertices = []
	for i in range(2, edge_segment):
		# 给顶点 0 周围五个面绘制分段小球（循环逻辑等于是在一个面上一圈一圈往外画）
		var layer_vertices: Array = get_segment_vertices(v21[i], v23[i], i)
		for j in range(1, layer_vertices.size() - 1):
			draw_on_pos(layer_vertices[j])


func get_segment_vertices(from: Vector3, to: Vector3, segment: int) -> Array[Vector3]:
	var result: Array[Vector3] = [from]
	if segment_by_rotation:
		var angle: float = from.angle_to(to)
		# 计算出每个分段的角度
		var segment_angle: float = angle / segment
		# 用叉积求出单位法向量（方向符合右手定则）
		var normal_vec: Vector3 = from.cross(to).normalized()
		for i in range(segment - 1):
			var point: Vector3 = from.rotated(normal_vec, (i + 1) * segment_angle)
			result.append(point)
			up_for_hexagon_dict[point] = from
	else:
		var diff: Vector3 = to - from
		var segment_diff: Vector3 = diff / segment
		for i in range(segment - 1):
			var point: Vector3 = (from + (i + 1) * segment_diff).normalized() * radius
			result.append(point)
			up_for_hexagon_dict[point] = from
	result.append(to)
	return result


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if regenerate:
		clear_pre_drawed()
		generate_mesh()
		regenerate = false


func clear_pre_drawed() -> void:
	for child in get_children():
		child.queue_free()
