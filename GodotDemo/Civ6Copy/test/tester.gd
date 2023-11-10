extends Node2D


func _ready() -> void:
	test_hexagon_utils_cube_ring()
	test_map_get_in_map_surrounding_coords()


func test_hexagon_utils_cube_ring() -> void:
	for hex in HexagonUtils.Cube.new(0,0,0).ring(1):
		print(hex.q, ", ", hex.r, ", ", hex.s)


func test_map_get_in_map_surrounding_coords() -> void:
	print(Map.get_in_map_surrounding_coords(Vector2i(22, 14), Map.SIZE_DICT[Map.Size.DUAL]))
	print(HexagonUtils.OffsetCoord.odd_r(22, 14).neighbor(HexagonUtils.Direction.RIGHT_DOWN).to_vec2i())
	print(HexagonUtils.OffsetCoord.odd_r(22, 14).neighbor(HexagonUtils.Direction.LEFT_DOWN).to_vec2i())
