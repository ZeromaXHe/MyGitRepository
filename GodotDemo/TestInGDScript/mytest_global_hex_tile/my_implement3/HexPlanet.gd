@tool
class_name HexPlanet
extends Node3D


@export_range(0, 7) var subdivisions: int = 1
@export_range(0, 6) var chunk_subdivisions: int = 1

@export_range(1, 10000) var radius: float = 100

var tiles: Array
var chunks: Array

@onready var terrain_generator: PerlinTerrainGenerator = $PerlinTerrainGenerator
@onready var test: Node3D = $Test


func get_tile(id: int) -> HexTile:
	return tiles[id]


func get_chunk(id: int) -> HexChunk:
	return chunks[id]


func draw_spheres(tile_centers: Array, chunk_origins: Array) -> void:
	print("drawing_spheres tile_centers: ", tile_centers, ", chunk_origins: ", chunk_origins)
	# 清空 test 子节点
	for child in test.get_children():
		child.queue_free()
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


func on_after_deserialize() -> void:
	for tile: HexTile in tiles:
		tile.planet = self
	for chunk: HexChunk in chunks:
		chunk.planet = self
		chunk.setup_events()
