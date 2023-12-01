class_name MiniMap
extends Node2D


signal click_on_tile(coord: Vector2i)


static var singleton: MiniMap

@onready var map_shower: MapShower = $MapShower
@onready var camera: Camera2D = $Camera2D
@onready var view_line: Line2D = $ViewLine2D


func _ready() -> void:
	singleton = self
	initialize(MapService.get_map_tile_size_vec(), MapShower.singleton.get_map_tile_xy())
	paint_player_sight()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
#				print("click on minimap")
				click_on_tile.emit(map_shower.get_mouse_map_coord())


func initialize(map_size: Vector2i, tile_xy: Vector2i) -> void:
	var tile_x: int = tile_xy.x
	var tile_y: int = tile_xy.y
	# 小心 int 溢出
	var max_x = map_size.x * tile_x + (tile_x / 2)
	var max_y = (map_size.y * tile_y * 3 + tile_y)/ 4
	# 摄像头默认居中
	camera.global_position = Vector2(max_x / 2, max_y / 2)


func get_view_line() -> Line2D:
	return view_line


func paint_player_sight() -> void:
	var player: PlayerDO = PlayerService.get_current_player()
	var unseens: Array = PlayerSightService.get_player_sight_dos_by_sight(PlayerSightTable.Sight.UNSEEN)
	for unseen in unseens:
		map_shower.paint_out_sight_tile_areas(unseen.coord, PlayerSightTable.Sight.UNSEEN)
	var seens: Array = PlayerSightService.get_player_sight_dos_by_sight(PlayerSightTable.Sight.SEEN)
	for seen in seens:
		map_shower.paint_out_sight_tile_areas(seen.coord, PlayerSightTable.Sight.SEEN)
	var in_sights: Array = PlayerSightService.get_player_sight_dos_by_sight(PlayerSightTable.Sight.IN_SIGHT)
	var in_sight_coords: Array[Vector2i] = []
	for in_sight in in_sights:
		in_sight_coords.append(in_sight.coord)
	map_shower.paint_in_sight_tile_areas(in_sight_coords)
