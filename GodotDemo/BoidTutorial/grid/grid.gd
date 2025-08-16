extends Node2D

var bin_size = 1
var bins_x = 1
var bins_y = 1


func _draw() -> void:
	var inv = get_global_transform().inverse()
	draw_set_transform(inv.get_origin(), inv.get_rotation(), inv.get_scale())
	for i in range(0, bins_x):
		draw_line(Vector2(i * bin_size, get_viewport_rect().size.y), Vector2(i * bin_size, 0), Color.GREEN)
	for i in range(0, bins_y):
		draw_line(Vector2(0, i * bin_size), Vector2(get_viewport_rect().size.x, i * bin_size), Color.GREEN)
