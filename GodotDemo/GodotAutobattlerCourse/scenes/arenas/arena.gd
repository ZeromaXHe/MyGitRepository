class_name Arena
extends Node2D

const CELL_SIZE := Vector2(32, 32)
const HALF_CELL_SIZE := Vector2(16, 16)
const QUARTER_CELL_SIZE := Vector2(8, 8)

@onready var unit_mover: UnitMover = %UnitMover
@onready var unit_spawner: UnitSpawner = %UnitSpawner


func _ready() -> void:
	unit_spawner.unit_spawner.connect(unit_mover.setup_unit)
