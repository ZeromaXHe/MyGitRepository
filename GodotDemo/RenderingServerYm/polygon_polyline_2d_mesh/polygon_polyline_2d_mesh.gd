extends Node2D

const ICON = preload("res://icon.svg")

@export var mesh: Mesh


func _ready() -> void:
	await RenderingServer.frame_post_draw
	var canvas_item_rid: RID = get_canvas_item()
	var points: PackedVector2Array = []
	var colors: PackedColorArray = []
	var side := 6
	var pos := Vector2(400, 300)
	var deg := 0.0
	for i in side:
		points.append(pos + Vector2(cos(deg), sin(deg)) * 100)
		colors.append(Color.from_hsv(deg / TAU, 1.0, 1.0))
		deg += TAU / side
	RenderingServer.canvas_item_add_polygon(canvas_item_rid, points, colors)
	# polyline 多线必须自己处理连接初始点
	var line_points: PackedVector2Array = Array(points.duplicate()).map(func(v): return v - Vector2(0, 200))
	line_points.append(line_points[0])
	var line_colors: PackedColorArray = colors.duplicate()
	line_colors.append(line_colors[0])
	RenderingServer.canvas_item_add_polyline(canvas_item_rid, line_points, colors, 8)
	
	RenderingServer.canvas_item_add_multiline(
		canvas_item_rid,
		PackedVector2Array([
			Vector2(0, 0), Vector2(800, 600),
			Vector2(800, 0), Vector2(0, 600)
		]),
		PackedColorArray([Color.RED, Color.WHITE]))
	
	var trans := Transform2D.IDENTITY
	trans = trans.translated(Vector2(200, 300))
	RenderingServer.canvas_item_add_mesh(canvas_item_rid, mesh.get_rid(),
		trans, Color.RED, ICON.get_rid())
