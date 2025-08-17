extends Node2D

const ICON: Texture2D = preload("res://icon.svg")
const INSTANCE_COUNT := 100000

var mesh: ArrayMesh
var multimesh: RID


func _ready() -> void:
	await RenderingServer.frame_post_draw
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	st.set_color(Color.RED)
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-100, -100, 0))
	st.set_color(Color.GREEN)
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(100, -100, 0))
	st.set_color(Color.BLUE)
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-100, 100, 0))
	st.set_color(Color.YELLOW)
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(100, 100, 0))
	mesh = st.commit()
	var canvas_item_rid: RID = get_canvas_item()
	var trans := Transform2D.IDENTITY.translated(Vector2(400, 300))
	RenderingServer.canvas_item_add_mesh(canvas_item_rid, mesh.get_rid(),
		trans, Color.WHITE, ICON.get_rid())
	
	multimesh = RenderingServer.multimesh_create()
	RenderingServer.multimesh_allocate_data(multimesh, INSTANCE_COUNT,
		RenderingServer.MULTIMESH_TRANSFORM_2D, true)
	RenderingServer.multimesh_set_visible_instances(multimesh, INSTANCE_COUNT)
	RenderingServer.multimesh_set_mesh(multimesh, mesh.get_rid())
	for i: int in INSTANCE_COUNT:
		var col := Color.from_hsv(randf(), 1.0, 1.0, 1.0)
		RenderingServer.multimesh_instance_set_color(multimesh, i, col)
		var trans2 := Transform2D.IDENTITY.translated(
			Vector2(randf_range(0, 800), randf_range(0, 600))
		).rotated(randf() * TAU)
		RenderingServer.multimesh_instance_set_transform_2d(multimesh, i, trans2)
	RenderingServer.canvas_item_add_multimesh(canvas_item_rid, multimesh)
