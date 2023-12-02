class_name BuyCellNode2D
extends Node2D


signal node_pressed


var coord: Vector2i
var city_id: int


func _on_button_pressed() -> void:
	# 控制领土
	MapTileService.city_claim_territory(city_id, coord)
	Player.id_dict[PlayerService.get_current_player_id()].territory_border.paint_dash_border([coord] as Array[Vector2i])
	# 扩展视野
	var sight_cells: Array[Vector2i] = MapService.get_surrounding_cells(coord, 1, false) \
			.filter(MapService.is_in_map_tile)
	for in_sight_coord in sight_cells:
		CitySightService.in_sight(city_id, in_sight_coord)
	MapShower.singleton.paint_in_sight_tile_areas(sight_cells)
	node_pressed.emit()
