extends Node2D


func _ready() -> void:
	# 绘制移动格位边框
#	generate_move_tile_svg()
	# 绘制视野格位边框
#	generate_sight_tile_svg()
	# 绘制领土边界
	generate_multi_border_tile_double_line_svg(10, 30)


func generate_move_tile_svg() -> void:
	generate_multi_border_tile_svg(5, "#09F5C7", 10)


func generate_sight_tile_svg() -> void:
	generate_multi_border_tile_svg(20, "#423308", 30)


func generate_multi_border_tile_svg(stroke_width: int, stroke_color: String, seperation: int) -> void:
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
	var xml_begin: String = """<?xml version="1.0" encoding="UTF-8"?>
<svg width="%d" height="%d" viewBox="0 0 %d %d" fill="none"
\txmlns="http://www.w3.org/2000/svg">""" % [width, height, width, height]
	print(xml_begin)
	for i in range(64):
		var offset := Vector2(seperation + (i % 8) * (cell_w + seperation), \
				seperation + (i / 8) * (cell_h + seperation))
		if i & 1 == 1:
			print("\t" + svg_line(offset + top, offset + r_up, stroke_color, stroke_width))
		if i & 2 == 2:
			print("\t" + svg_line(offset + r_up, offset + r_down, stroke_color, stroke_width))
		if i & 4 == 4:
			print("\t" + svg_line(offset + r_down, offset + bottom, stroke_color, stroke_width))
		if i & 8 == 8:
			print("\t" + svg_line(offset + bottom, offset + l_down, stroke_color, stroke_width))
		if i & 16 == 16:
			print("\t" + svg_line(offset + l_down, offset + l_up, stroke_color, stroke_width))
		if i & 32 == 32:
			print("\t" + svg_line(offset + l_up, offset + top, stroke_color, stroke_width))
	print("</svg>")


func generate_multi_border_tile_double_line_svg(stroke_width: int, seperation: int) -> void:
	var top := Vector2(93, 0)
	var r_up := Vector2(185, 53.75)
	var r_down := Vector2(185, 161.25)
	var bottom := Vector2(93, 215)
	var l_down := Vector2(1, 161.25)
	var l_up := Vector2(1, 53.75)
	
	var shift_top := Vector2(0, -1)
	var shift_r_up := Vector2(0.866, -0.5)
	var shift_r_down := Vector2(0.866, 0.5)
	var shift_bottom := Vector2(0, 1)
	var shift_l_down := Vector2(-0.866, 0.5)
	var shift_l_up := Vector2(-0.866, -0.5)
	
	var cell_w: int = 186
	var cell_h: int = 215
	var width: int = seperation + (cell_w + seperation) * 8
	var height: int = seperation + (cell_h + seperation) * 16
	var xml_begin: String = """<?xml version="1.0" encoding="UTF-8"?>
<svg width="%d" height="%d" viewBox="0 0 %d %d" fill="none"
\txmlns="http://www.w3.org/2000/svg">""" % [width, height, width, height]
	print(xml_begin)
	# 实线
	for i in range(64):
	## 一次打不完，所以注释是用来分段打
#	for i in range(48, 64):
		var offset := Vector2(seperation + (i % 8) * (cell_w + seperation), \
				seperation + (i / 8) * (cell_h + seperation))
		if i & 1 == 1:
			print("\t" + svg_line(offset + top + stroke_width * shift_top, \
					offset + r_up + stroke_width * shift_r_up, "black", stroke_width))
			print("\t" + svg_line(offset + top - stroke_width * shift_top, \
					offset + r_up - stroke_width * shift_r_up, "white", stroke_width))
		if i & 2 == 2:
			print("\t" + svg_line(offset + r_up + stroke_width * shift_r_up, \
					offset + r_down + stroke_width * shift_r_down, "black", stroke_width))
			print("\t" + svg_line(offset + r_up - stroke_width * shift_r_up, \
					offset + r_down - stroke_width * shift_r_down, "white", stroke_width))
		if i & 4 == 4:
			print("\t" + svg_line(offset + r_down + stroke_width * shift_r_down, \
					offset + bottom + stroke_width * shift_bottom, "black", stroke_width))
			print("\t" + svg_line(offset + r_down - stroke_width * shift_r_down, \
					offset + bottom - stroke_width * shift_bottom, "white", stroke_width))
		if i & 8 == 8:
			print("\t" + svg_line(offset + bottom + stroke_width * shift_bottom, \
					offset + l_down + stroke_width * shift_l_down, "black", stroke_width))
			print("\t" + svg_line(offset + bottom - stroke_width * shift_bottom, \
					offset + l_down - stroke_width * shift_l_down, "white", stroke_width))
		if i & 16 == 16:
			print("\t" + svg_line(offset + l_down + stroke_width * shift_l_down, \
					offset + l_up + stroke_width * shift_l_up, "black", stroke_width))
			print("\t" + svg_line(offset + l_down - stroke_width * shift_l_down, \
					offset + l_up - stroke_width * shift_l_up, "white", stroke_width))
		if i & 32 == 32:
			print("\t" + svg_line(offset + l_up + stroke_width * shift_l_up, \
					offset + top + stroke_width * shift_top, "black", stroke_width))
			print("\t" + svg_line(offset + l_up - stroke_width * shift_l_up, \
					offset + top - stroke_width * shift_top, "white", stroke_width))
	# 虚线
	for i in range(64):
	## 一次打不完，所以注释是用来分段打
#	for i in range(24, 64):
#	for i in range(56, 64):
		var offset := Vector2(seperation + (i % 8) * (cell_w + seperation), \
				seperation + (8 + i / 8) * (cell_h + seperation))
		if i & 1 == 1:
			print("\t" + svg_dash_line(offset + top + stroke_width * shift_top, \
					offset + r_up + stroke_width * shift_r_up, "black", stroke_width))
			print("\t" + svg_dash_line(offset + top - stroke_width * shift_top, \
					offset + r_up - stroke_width * shift_r_up, "white", stroke_width))
		if i & 2 == 2:
			print("\t" + svg_dash_line(offset + r_up + stroke_width * shift_r_up, \
					offset + r_down + stroke_width * shift_r_down, "black", stroke_width))
			print("\t" + svg_dash_line(offset + r_up - stroke_width * shift_r_up, \
					offset + r_down - stroke_width * shift_r_down, "white", stroke_width))
		if i & 4 == 4:
			print("\t" + svg_dash_line(offset + r_down + stroke_width * shift_r_down, \
					offset + bottom + stroke_width * shift_bottom, "black", stroke_width))
			print("\t" + svg_dash_line(offset + r_down - stroke_width * shift_r_down, \
					offset + bottom - stroke_width * shift_bottom, "white", stroke_width))
		if i & 8 == 8:
			print("\t" + svg_dash_line(offset + bottom + stroke_width * shift_bottom, \
					offset + l_down + stroke_width * shift_l_down, "black", stroke_width))
			print("\t" + svg_dash_line(offset + bottom - stroke_width * shift_bottom, \
					offset + l_down - stroke_width * shift_l_down, "white", stroke_width))
		if i & 16 == 16:
			print("\t" + svg_dash_line(offset + l_down + stroke_width * shift_l_down, \
					offset + l_up + stroke_width * shift_l_up, "black", stroke_width))
			print("\t" + svg_dash_line(offset + l_down - stroke_width * shift_l_down, \
					offset + l_up - stroke_width * shift_l_up, "white", stroke_width))
		if i & 32 == 32:
			print("\t" + svg_dash_line(offset + l_up + stroke_width * shift_l_up, \
					offset + top + stroke_width * shift_top, "black", stroke_width))
			print("\t" + svg_dash_line(offset + l_up - stroke_width * shift_l_up, \
					offset + top - stroke_width * shift_top, "white", stroke_width))
	print("</svg>")


func svg_line(from: Vector2, to: Vector2, stroke_color: String, stroke_width: int) -> String:
	# 格式字符串
	var template = "<line x1=\"%.2f\" y1=\"%.2f\" x2=\"%.2f\" y2=\"%.2f\" " \
			+ "style=\"stroke:%s;stroke-width:%d;stroke-linecap:round\"/>"
	return template % [from.x, from.y, to.x, to.y, stroke_color, stroke_width]


func svg_dash_line(from: Vector2, to: Vector2, stroke_color: String, stroke_width: int) -> String:
	# 格式字符串
	var template = "<line x1=\"%.2f\" y1=\"%.2f\" x2=\"%.2f\" y2=\"%.2f\" " \
			+ "style=\"stroke:%s;stroke-width:%d;stroke-linecap:round;stroke-dasharray: 20 15\"/>"
	return template % [from.x, from.y, to.x, to.y, stroke_color, stroke_width]

