class_name GameController


enum Mode {
	HOT_SEAT_GAME,
	MAP_EDITOR,
}


static var mode: Mode


static func set_mode(mode: Mode) -> void:
	GameController.mode = mode


static func get_mode() -> Mode:
	return mode
