extends Node2D


func _ready() -> void:
	test_hexagon_utils_cube_ring()


func test_hexagon_utils_cube_ring() -> void:
	for hex in HexagonUtils.Cube.new(0,0,0).ring(1):
		print(hex.q, ", ", hex.r, ", ", hex.s)
