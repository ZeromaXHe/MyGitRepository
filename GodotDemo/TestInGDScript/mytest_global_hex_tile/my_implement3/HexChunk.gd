class_name HexChunk
extends RefCounted


signal chunk_changed(tile: HexTile)

var id: int
var origin: Vector3
var tile_ids: Array = []
var is_dirty: bool

var planet: HexPlanet
var tiles: Array


func _init(id: int, planet: HexPlanet, origin: Vector3) -> void:
	self.origin = origin
	self.planet = planet
	self.id = id


func add_tile(tile_id: int) -> void:
	tile_ids.append(tile_id)


func on_chunk_tile_change(tile: HexTile) -> void:
	chunk_changed.emit(tile)


func get_tiles() -> Array:
	if tiles == null:
		tiles = []
		for i in range(tile_ids.size()):
			tiles.append(planet.get_tile(tile_ids[i]))
	return tiles


func get_mesh() -> Mesh:
	var tiles = get_tiles()
	var vertices = []
	var colors = []
	var indices = []
	for tile: HexTile in tiles:
		tile.append_to_mesh(vertices, indices, colors)
	var surface_tool := SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for vertex in vertices:
		surface_tool.add_vertex(vertex)
	for index in indices:
		surface_tool.add_index(index)
	surface_tool.generate_normals()
	return surface_tool.commit()


func get_closest_tile_angle(input: Vector3) -> HexTile:
	var tiles = get_tiles()
	var ret: HexTile = null
	var closeness: float = -10000.0
	for tile: HexTile in tiles:
		var similarity = tile.center.normalized().dot(input.normalized())
		if similarity > closeness:
			closeness = similarity
			ret = tile
	return ret


func make_dirty() -> void:
	is_dirty = true


func setup_events() -> void:
	var tiles = get_tiles()
	for tile: HexTile in tiles:
		tile.tile_changed.connect(on_chunk_tile_change)
