extends Node2D


func _ready() -> void:
	# 绘制移动格位边框
#	print(generate_move_tile_svg())
	# 绘制视野格位边框
	print(generate_sight_tile_svg())


func generate_move_tile_svg() -> String:
	return generate_multi_border_tile_svg(5, "#09F5C7", 10)


func generate_sight_tile_svg() -> String:
	return generate_multi_border_tile_svg(20, "#423308", 30)


func generate_multi_border_tile_svg(stroke_width: int, stroke_color: String, seperation: int) -> String:
	var top := Vector2(93, 0)
	var r_up := Vector2(185, 53.75)
	var r_down := Vector2(185, 161.25)
	var bottom := Vector2(93, 215)
	var l_down := Vector2(1, 161.25)
	var l_up := Vector2(1, 53.75)
	
	var cell_w: int = 186
	var cell_h: int = 215
	var width: int = seperation + (cell_w + seperation) * 8
	var height: int = seperation + (cell_h + seperation) * 8
	var result = """<?xml version="1.0" encoding="UTF-8"?>
<svg width="%d" height="%d" viewBox="0 0 %d %d" fill="none"
\txmlns="http://www.w3.org/2000/svg">""" % [width, height, width, height]
	for i in range(64):
		var offset := Vector2(seperation + (i % 8) * (cell_w + seperation), \
				seperation + (i / 8) * (cell_h + seperation))
		if i & 1 == 1:
			result += "\n\t" + svg_line(offset + top, offset + r_up, stroke_color, stroke_width)
		if i & 2 == 2:
			result += "\n\t" + svg_line(offset + r_up, offset + r_down, stroke_color, stroke_width)
		if i & 4 == 4:
			result += "\n\t" + svg_line(offset + r_down, offset + bottom, stroke_color, stroke_width)
		if i & 8 == 8:
			result += "\n\t" + svg_line(offset + bottom, offset + l_down, stroke_color, stroke_width)
		if i & 16 == 16:
			result += "\n\t" + svg_line(offset + l_down, offset + l_up, stroke_color, stroke_width)
		if i & 32 == 32:
			result += "\n\t" + svg_line(offset + l_up, offset + top, stroke_color, stroke_width)
	result += "\n</svg>"
	return result


func svg_line(from: Vector2, to: Vector2, stroke_color: String, stroke_width: int) -> String:
	# 格式字符串
	var template = "<line x1=\"%.2f\" y1=\"%.2f\" x2=\"%.2f\" y2=\"%.2f\" " \
			+ "style=\"stroke:%s;stroke-width:%d;stroke-linecap:round\"/>"
	return template % [from.x, from.y, to.x, to.y, stroke_color, stroke_width]

