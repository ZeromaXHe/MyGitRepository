class_name HexPlanet
extends RefCounted


@export_range(0, 7) var subdivisions: int
@export_range(0, 6) var chunk_subdivisions: int

var radius: float
var terrain_generator: BaseTerrainGenerator
var tiles: Array
var chunks: Array


func get_tile(id: int) -> HexTile:
	return tiles[id]


func get_chunk(id: int) -> HexChunk:
	return chunks[id]

