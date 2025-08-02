class_name GameState
extends Resource

enum Phase {
	PREPERATION,
	BATTLE
}

@export var current_phase: Phase:
	set(value):
		current_phase = value
		changed.emit()
