@tool
class_name HexPlanet
extends Node3D


@export_range(0, 7) var subdivisions: int = 1
@export_range(0, 6) var chunk_subdivisions: int = 1
@export_range(1, 10000) var radius: float = 100
@export var debug_point_line: bool = false

var tiles: Array
var chunks: Array

@onready var terrain_generator: PerlinTerrainGenerator = $PerlinTerrainGenerator
@onready var test: Node3D = $Test


func get_tile(id: int) -> HexTile:
	return tiles[id]


func get_chunk(id: int) -> HexChunk:
	return chunks[id]


func clear_spheres_and_lines() -> void:
	# 清空 test 子节点
	for child in test.get_children():
		child.queue_free()


func draw_spheres(tile_centers: Array, chunk_origins: Array) -> void:
	if not debug_point_line:
		return
	#print("drawing_spheres tile_centers: ", tile_centers, ", chunk_origins: ", chunk_origins)
	for tc in tile_centers:
		draw_sphere_on_pos(tc, Color.GREEN)
	for co in chunk_origins:
		draw_sphere_on_pos(co, Color.RED)


func draw_sphere_on_pos(pos: Vector3, color: Color) -> void:
	var ins := MeshInstance3D.new()
	test.add_child(ins)
	ins.position = pos
	var sphere := SphereMesh.new()
	sphere.radius = radius / 40
	sphere.height = radius / 20
	ins.mesh = sphere
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	ins.set_surface_override_material(0, material)


func draw_line(from: Vector3, to: Vector3, cylinder_radius: float = radius / 60) -> void:
	if not debug_point_line:
		return
	var ins := MeshInstance3D.new()
	test.add_child(ins)
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
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	ins.set_surface_override_material(0, material)


func on_after_deserialize() -> void:
	for tile: HexTile in tiles:
		tile.planet = self
	for chunk: HexChunk in chunks:
		chunk.planet = self
		chunk.setup_events()
