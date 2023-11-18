class_name ViewSignalsEmitter


signal unit_move_depleted(unit_id: int)
signal unit_move_changed(unit_id: int, move: int)
signal city_production_changed(city_id: int)
signal city_production_completed(unit_type: UnitTypeTable.Type, city_coord: Vector2i)


static var singleton := ViewSignalsEmitter.new()


static func get_instance() -> ViewSignalsEmitter:
	return singleton
