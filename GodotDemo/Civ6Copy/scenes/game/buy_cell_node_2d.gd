class_name BuyCellNode2D
extends Node2D


signal node_pressed


var coord: Vector2i
var city_id: int


func _on_button_pressed() -> void:
	# 控制领土
	MapController.city_claim_territory(city_id, coord)
	ViewHolder.get_player(PlayerController.get_current_player_id()).territory_border.paint_dash_border([coord] as Array[Vector2i])
	# 扩展视野
	var sight_cells: Array[Vector2i] = MapController.get_surrounding_cells(coord, 1, false) \
			.filter(MapController.is_in_map_tile)
	for in_sight_coord in sight_cells:
		# FIXME: 现在会重复计算视野，但去重目前太复杂了，后续修改
		PlayerSightService.in_sight(in_sight_coord)
	ViewHolder.get_map_shower().paint_in_sight_tile_areas(sight_cells)
	node_pressed.emit()
