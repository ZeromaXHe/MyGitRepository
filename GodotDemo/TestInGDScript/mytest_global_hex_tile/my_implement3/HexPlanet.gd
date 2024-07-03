@tool
class_name HexPlanet
extends Node3D


@export_range(0, 7) var subdivisions: int = 1
@export_range(0, 6) var chunk_subdivisions: int = 1

@export_range(1, 10000) var radius: float = 100

var tiles: Array
var chunks: Array

@onready var terrain_generator: PerlinTerrainGenerator = $PerlinTerrainGenerator


func get_tile(id: int) -> HexTile:
	return tiles[id]


func get_chunk(id: int) -> HexChunk:
	return chunks[id]


func on_after_deserialize() -> void:
	for tile: HexTile in tiles:
		tile.planet = self
	for chunk: HexChunk in chunks:
		chunk.planet = self
		chunk.setup_events()
