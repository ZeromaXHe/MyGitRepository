class_name Arena
extends Node2D

const CELL_SIZE := Vector2(32, 32)
const HALF_CELL_SIZE := Vector2(16, 16)
const QUARTER_CELL_SIZE := Vector2(8, 8)

@export var arena_music_stream: AudioStream

@onready var sell_portal: SellPortal = %SellPortal
@onready var unit_mover: UnitMover = %UnitMover
@onready var unit_spawner: UnitSpawner = %UnitSpawner
@onready var unit_combiner: UnitCombiner = %UnitCombiner
@onready var shop: Shop = %Shop


func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
	unit_spawner.unit_spawned.connect(sell_portal.setup_unit)
	unit_spawner.unit_spawned.connect(unit_combiner.queue_unit_combination_update.unbind(1))
	shop.unit_bought.connect(unit_spawner.spawn_unit)
	
	MusicPlayer.play(arena_music_stream)
