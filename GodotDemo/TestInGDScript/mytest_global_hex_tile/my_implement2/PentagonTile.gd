@tool
extends MeshInstance3D


@export var edge_len: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_mesh()


func generate_mesh() -> void:
	var vertices := PackedVector3Array([
		edge_len * Vector3(0, 0.85065, 0),
		edge_len * Vector3(0.809, 0.263, 0),
		edge_len * Vector3(0.5, -0.688, 0),
		edge_len * Vector3(-0.5, -0.688, 0),
		edge_len * Vector3(-0.809, 0.263, 0),
	])
	# 节点的顺序会决定渲染表面的方向
	# 左手按第一个点在手腕，第三个点在指尖的顺时针方向匹配的话，大拇指向上的方向是可以看到表面的方向
	var indices := PackedInt32Array([
		0, 3, 4,
		0, 2, 3,
		0, 1, 2,
	])
	var uvs := PackedVector2Array([
		Vector2(0.5, 0), # 0
		Vector2(0, 0.382), # 1
		Vector2(0.191, 1), # 2
		Vector2(0.809, 1), # 3
		Vector2(1, 0.382), # 4
	])
	surface_tool_generation(vertices, indices, uvs)


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
