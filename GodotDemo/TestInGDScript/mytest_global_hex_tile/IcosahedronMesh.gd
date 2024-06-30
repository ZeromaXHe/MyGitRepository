@tool
extends MeshInstance3D


@export_range(1, 10000) var radius: float = 10
@export_range(1, 10000) var edge_segment: int = 1
@export var regenerate: bool = false
# true 分段时是采用球面旋转计算，false 时采用直线分段后映射到球面
@export var segment_by_rotation: bool = false
@export_group("render")
@export var render_hex: bool = true
@export_subgroup("detail")
@export var render_point: bool = true
@export var render_edge: bool = true


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
	
	var uvs := PackedVector2Array([
		Vector2(0, 0), # 0
		Vector2(1, 0), # 1
		Vector2(0, 1), # 2
		Vector2(1, 1), # 3
		Vector2(1, 1), # 4
		Vector2(0, 0), # 5
		Vector2(1, 0), # 6
		Vector2(0, 1), # 7
		Vector2(1, 0), # 8
		Vector2(0, 1), # 9
		Vector2(0, 0), # 10
		Vector2(0, 0) # 11
	])
	
	surface_tool_generation(vertices, indices, uvs)
	draw_vertices_view(vertices)
	if render_hex:
		draw_hex_tile_vertices_view(vertices, indices)


func arr_mesh_generation(vertices: PackedVector3Array, indices: PackedInt32Array, \
						uvs: PackedVector2Array) -> void:
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	array[Mesh.ARRAY_TEX_UV] = uvs
	var arr_mesh := ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh = arr_mesh


func surface_tool_generation(vertices: PackedVector3Array, indices: PackedInt32Array, \
							uvs: PackedVector2Array) -> void:
	var suftool := SurfaceTool.new()
	suftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(vertices.size()):
		suftool.set_uv(uvs[i])
		suftool.add_vertex(vertices[i])
	for i in indices:
		suftool.add_index(i)
	suftool.generate_normals()
	mesh = suftool.commit()


func draw_vertices_view(vertices: PackedVector3Array) -> void:
	for i in range(vertices.size()):
		# 在端点位置画标记（球或者文字），用颜色来区分序号
		draw_on_pos(vertices[i] * 1.05, i, false)


func draw_on_pos(pos: Vector3, i: int = -1, draw_sphere: bool = true, \
				sphere_radius: float = radius / edge_segment / 40) -> void:
	if not render_point:
		return
	#print("drawing on pos:", pos, " i:", i)
	var ins := MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	if draw_sphere:
		var sphere := SphereMesh.new()
		sphere.radius = sphere_radius
		sphere.height = sphere_radius * 2
		ins.mesh = sphere
	else:
		var text := TextMesh.new()
		text.font_size = radius * 10
		text.text = str(i)
		ins.mesh = text
		# 使文字按顶点方向朝向外
		ins.look_at(Vector3.ZERO);
	var material := StandardMaterial3D.new()
	match(i):
		-1:
			material.albedo_color = Color.WHITE
		0:
			material.albedo_color = Color.REBECCA_PURPLE
		1:
			material.albedo_color = Color.RED
		2:
			material.albedo_color = Color.DARK_RED
		3:
			material.albedo_color = Color.ORANGE_RED
		4:
			material.albedo_color = Color.ORANGE
		5:
			material.albedo_color = Color.YELLOW
		6:
			material.albedo_color = Color.YELLOW_GREEN
		7:
			material.albedo_color = Color.GREEN
		8:
			material.albedo_color = Color.DARK_GREEN
		9:
			material.albedo_color = Color.SKY_BLUE
		10:
			material.albedo_color = Color.BLUE
		11:
			material.albedo_color = Color.PURPLE
	ins.set_surface_override_material(0, material)


func draw_line(from: Vector3, to: Vector3, cylinder_radius: float = radius / edge_segment / 60) -> void:
	if not render_edge:
		return
	var ins := MeshInstance3D.new()
	add_child(ins)
	ins.position = (from + to) / 2
	# 圆柱体高度沿着 y 方向，所以面朝随便找的一个垂直 y 方向的向量即可
	var diff: Vector3 = to - from
	if diff.x != 0:
		ins.look_at(Vector3(-diff.y, diff.x, 0), diff)
	else:
		ins.look_at(Vector3(0, diff.z, -diff.y), diff)
	var cylinder := CylinderMesh.new()
	cylinder.top_radius = cylinder_radius
	cylinder.bottom_radius = cylinder_radius
	cylinder.height = from.distance_to(to)
	cylinder.radial_segments = 6
	ins.mesh = cylinder


func draw_hex_tile_vertices_view(vertices: PackedVector3Array, indices: PackedInt32Array) -> void:
	var connect_map = init_connect_map(indices)
	var visited_map = init_visited_map()
	# 绘制所有顶点球
	for v in vertices:
		draw_on_pos(v)
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


func draw_face_index(vertices: PackedVector3Array, i1: int, i2: int, i3: int, visited_map: Array) -> void:
	var v21 = get_segment_vertices(vertices[i2], vertices[i1], edge_segment * 3)
	var v23 = get_segment_vertices(vertices[i2], vertices[i3], edge_segment * 3)
	var v13 = get_segment_vertices(vertices[i1], vertices[i3], edge_segment * 3)
	# 检验边是否绘制过，没绘制的话就画
	if not visited_map[i2][i1]:
		for v in v21:
			draw_on_pos(v)
		for i in range(edge_segment):
			draw_line(v21[i * 3 + 1], v21[i * 3 + 2])
		visited_map[i1][i2] = true
		visited_map[i2][i1] = true
	if not visited_map[i2][i3]:
		for v in v23:
			draw_on_pos(v)
		for i in range(edge_segment):
			draw_line(v23[i * 3 + 1], v23[i * 3 + 2])
		visited_map[i2][i3] = true
		visited_map[i3][i2] = true
	if not visited_map[i1][i3]:
		for v in v13:
			draw_on_pos(v)
		for i in range(edge_segment):
			draw_line(v13[i * 3 + 1], v13[i * 3 + 2])
		visited_map[i1][i3] = true
		visited_map[i3][i1] = true
	# 绘制真正面内部的顶点
	var pre_vertices = []
	for i in range(1, edge_segment * 3 + 1):
		var layer_vertices: Array
		var last_layer: bool = (i == edge_segment * 3)
		if last_layer:
			layer_vertices = v13
		else:
			# 给顶点 0 周围五个面绘制分段小球（循环逻辑等于是在一个面上一圈一圈往外画）
			layer_vertices = get_segment_vertices(v21[i], v23[i], i)
			for j in range(1, layer_vertices.size() - 1):
				draw_on_pos(layer_vertices[j])
		var layer_count = layer_vertices.size()
		var pre_count = pre_vertices.size()
		if i % 3 == 0:
			for j in range((layer_count + 2) / 3):
				if j * 3 + 2 < layer_count and not last_layer:
					draw_line(layer_vertices[j * 3 + 1], layer_vertices[j * 3 + 2])
				if j * 3 + 2 < pre_count:
					draw_line(layer_vertices[j * 3 + 2], pre_vertices[j * 3 + 2])
				if j * 3 + 1 < layer_count:
					draw_line(layer_vertices[j * 3 + 1], pre_vertices[j * 3])
		elif (i + 1) % 3 == 0:
			for j in range((layer_count + 2) / 3):
				if j * 3 + 3 < layer_count and not last_layer:
					draw_line(layer_vertices[j * 3 + 2], layer_vertices[j * 3 + 3])
				if j * 3 + 2 < pre_count:
					draw_line(layer_vertices[j * 3 + 3], pre_vertices[j * 3 + 3])
				if j * 3 + 2 < layer_count:
					draw_line(layer_vertices[j * 3 + 2], pre_vertices[j * 3 + 1])
		else:
			for j in range((layer_count + 2) / 3):
				if j * 3 + 1 < layer_count and not last_layer:
					draw_line(layer_vertices[j * 3], layer_vertices[j * 3 + 1])
				if j * 3 + 1 < pre_count:
					draw_line(layer_vertices[j * 3 + 1], pre_vertices[j * 3 + 1])
				if j * 3 - 1 > 0:
					draw_line(layer_vertices[j * 3], pre_vertices[j * 3 - 1])
		pre_vertices = layer_vertices


func get_segment_vertices(from: Vector3, to: Vector3, segment: int) -> Array[Vector3]:
	var result: Array[Vector3] = [from]
	if segment_by_rotation:
		var angle: float = from.angle_to(to)
		# 计算出每个分段的角度
		var segment_angle: float = angle / segment
		# 用叉积求出单位法向量（方向符合右手定则）
		var normal_vec: Vector3 = from.cross(to).normalized()
		for i in range(segment - 1):
			result.append(from.rotated(normal_vec, (i + 1) * segment_angle))
	else:
		var diff: Vector3 = to - from
		var segment_diff: Vector3 = diff / segment
		for i in range(segment - 1):
			result.append((from + (i + 1) * segment_diff).normalized() * radius)
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

