@tool
class_name BaseTerrainGenerator
extends Node3D


func create_hex_tile(id: int, planet: HexPlanet, center_position: Vector3, verts: Array) -> HexTile:
	return HexTile.new(id, planet, center_position, verts)


func after_tile_creation(new_tile: HexTile) -> void:
	printerr("BaseTerrainGenerator after_tile_creation should be overrided")
