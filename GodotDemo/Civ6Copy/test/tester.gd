extends Node2D


enum EnumTest {
	AAAA,
	BBBB,
	CCCC,
}


func _ready() -> void:
#	test_hexagon_utils_cube_ring()
#	test_map_service_get_in_map_surrounding_coords()
#	test_enum()
	test_sort_vector2()


func test_sort_vector2() -> void:
	var arr = [Vector2(1, 1), Vector2(2, 1), Vector2(3, 3), Vector2(2, 3), Vector2(1, 3), Vector2(2, 2), \
			Vector2(1, 2), Vector2(3, 1), Vector2(3, 2)]
	arr.sort()
	print(arr)


func test_enum() -> void:
	print(EnumTest.keys())
	print(EnumTest.values())
	
	for k in EnumTest.keys():
		# 不能直接写 k == EnumTest.AAAA，k 是 String，EnumTest.AAAA 是 int
		if EnumTest[k] == EnumTest.AAAA:
			print("find AAAA")


func test_hexagon_utils_cube_ring() -> void:
	for hex in HexagonUtils.Cube.new(0,0,0).ring(1):
		print(hex.q, ", ", hex.r, ", ", hex.s)


func test_map_service_get_in_map_surrounding_coords() -> void:
	print(MapService.get_in_map_surrounding_coords(Vector2i(22, 14), DatabaseUtils.map_size_tbl.query_by_enum_val(MapSizeTable.Enum.DUAL).size_vec))
	print(HexagonUtils.OffsetCoord.odd_r(22, 14).neighbor(HexagonUtils.Direction.RIGHT_DOWN).to_vec2i())
	print(HexagonUtils.OffsetCoord.odd_r(22, 14).neighbor(HexagonUtils.Direction.LEFT_DOWN).to_vec2i())


# 测试 get_border_type() 方法
func test_map_controller_get_border_type() -> void:
	print("slash ", Vector2i(0, 0), " is ", MapBorderUtils.get_border_type(Vector2i(0, 0)))
	print("slash ", Vector2i(1, 2), " is ", MapBorderUtils.get_border_type(Vector2i(1, 2)))
	print("back slash ", Vector2i(1, 0), " is ", MapBorderUtils.get_border_type(Vector2i(1, 0)))
	print("back slash ", Vector2i(2, 2), " is ", MapBorderUtils.get_border_type(Vector2i(2, 2)))
	print("center ", Vector2i(0, 1), " is ", MapBorderUtils.get_border_type(Vector2i(0, 1)))
	print("center ", Vector2i(1, 3), " is ", MapBorderUtils.get_border_type(Vector2i(1, 3)))
	print("vertical ", Vector2i(-1, 1), " is ", MapBorderUtils.get_border_type(Vector2i(-1, 1)))
	print("vertical ", Vector2i(1, 1), " is ", MapBorderUtils.get_border_type(Vector2i(1, 1)))
	print("vertical ", Vector2i(0, 3), " is ", MapBorderUtils.get_border_type(Vector2i(0, 3)))
	print("vertical ", Vector2i(2, 3), " is ", MapBorderUtils.get_border_type(Vector2i(2, 3)))


static func test_map_controller_get_tile_coord_directed_border() -> void:
	print("hexagon ", Vector2i(0, 0), "'s left top is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 0), MapBorderTable.Direction.LEFT_TOP)) # (0,0)
	print("hexagon ", Vector2i(0, 0), "'s right top is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 0), MapBorderTable.Direction.RIGHT_TOP)) # (1,0)
	print("hexagon ", Vector2i(0, 0), "'s left is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 0), MapBorderTable.Direction.LEFT)) # (-1,1)
	print("hexagon ", Vector2i(0, 0), "'s center is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 0), MapBorderTable.Direction.CENTER)) # (0,1)
	print("hexagon ", Vector2i(0, 0), "'s right is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 0), MapBorderTable.Direction.RIGHT)) # (1,1)
	print("hexagon ", Vector2i(0, 0), "'s left down is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 0), MapBorderTable.Direction.LEFT_DOWN)) # (0,2)
	print("hexagon ", Vector2i(0, 0), "'s right down is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 0), MapBorderTable.Direction.RIGHT_DOWN)) # (1,2)
	print("hexagon ", Vector2i(0, 1), "'s left top is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 1), MapBorderTable.Direction.LEFT_TOP)) # (1,2)
	print("hexagon ", Vector2i(0, 1), "'s right top is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 1), MapBorderTable.Direction.RIGHT_TOP)) # (2,2)
	print("hexagon ", Vector2i(0, 1), "'s left is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 1), MapBorderTable.Direction.LEFT)) # (0,3)
	print("hexagon ", Vector2i(0, 1), "'s center is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 1), MapBorderTable.Direction.CENTER)) # (1,3)
	print("hexagon ", Vector2i(0, 1), "'s right is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 1), MapBorderTable.Direction.RIGHT)) # (2,3)
	print("hexagon ", Vector2i(0, 1), "'s left down is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 1), MapBorderTable.Direction.LEFT_DOWN)) # (1,4)
	print("hexagon ", Vector2i(0, 1), "'s right down is ", MapBorderUtils.get_tile_coord_directed_border(Vector2i(0, 1), MapBorderTable.Direction.RIGHT_DOWN)) # (2,4)


func _on_button_pressed() -> void:
	print("why can't press button under canvas layer?")


func _on_control_mouse_entered() -> void:
	# Mouse-Filter 是 Pass 的话会打印，但是后面的 button 就点不了了……
	# Ignore 的话，直接就没有鼠标信号了
	print("_on_control_mouse_entered")


func _on_parent_control_mouse_entered() -> void:
	print("_on_parent_control_mouse_entered")


func _on_parent_control_mouse_exited() -> void:
	print("_on_parent_control_mouse_exited")


func _on_area_2d_mouse_entered() -> void:
	print("_on_area_2d_mouse_entered")


func _on_area_2d_mouse_exited() -> void:
	print("_on_area_2d_mouse_exited")


func _on_parent_area_2d_mouse_entered() -> void:
	print("_on_parent_area_2d_mouse_entered")


func _on_parent_area_2d_mouse_exited() -> void:
	print("_on_parent_area_2d_mouse_exited")
