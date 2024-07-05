class_name HexChunkRender
extends MeshInstance3D


var rendered_chunk_id: int
var planet: HexPlanet
var chunk: HexChunk


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	planet = (get_tree().get_first_node_in_group("HexPlanetManager") as HexPlanetManager).hex_planet
	planet.get_chunk(rendered_chunk_id).chunk_changed.connect(_on_chunk_changed)
	update_mesh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_hex_chunk().is_dirty:
		update_mesh()
		get_hex_chunk().is_dirty = false


func _on_chunk_changed(changed_tile: HexTile) -> void:
	planet.get_chunk(changed_tile.chunk_id).make_dirty()
	for n_tile: HexTile in changed_tile.get_neighbors():
		if changed_tile.chunk_id != n_tile.chunk_id:
			planet.get_chunk(n_tile.chunk_id).make_dirty()


func update_mesh() -> void:
	var new_chunk_mesh = get_hex_chunk().get_mesh()
	mesh = new_chunk_mesh


func get_hex_chunk() -> HexChunk:
	if chunk == null:
		chunk = planet.get_chunk(rendered_chunk_id)
	return chunk


func set_hex_chunk(planet: HexPlanet, chunk_id: int) -> void:
	self.planet = planet
	self.rendered_chunk_id = chunk_id
