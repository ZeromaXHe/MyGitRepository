shader_type canvas_item;
render_mode unshaded;

uniform vec2 viewport_size;          // viewport 的像素尺寸
uniform sampler2D viewport1 : source_color;
uniform sampler2D viewport2 : source_color;
uniform bool split_active;           // true: 分屏, false: 使用 view1
uniform vec2 player1_position;       // 玩家 1 的位置（UV 坐标）
uniform vec2 player2_position;       // 玩家 2 的位置（UV 坐标）
uniform float split_line_thickness : hint_range(0, 10, 0.1);  // 分屏边界宽度
uniform vec3 split_line_color : source_color;       // 分屏边界颜色

// 来自 https://stackoverflow.com/questions/15276454/is-it-possible-to-draw-line-thickness-in-a-fragment-shader
float distance_to_line(vec2 p1, vec2 p2, vec2 point) {
	float a = p1.y - p2.y;
	float b = p2.x - p1.x;
	return abs(a * point.x + b * point.y + p1.x * p2.y - p2.x * p1.y) / sqrt(a * a + b * b);
}

void fragment() {
	vec3 view1 = texture(viewport1, UV).rgb;
	vec3 view2 = texture(viewport2, UV).rgb;

	float width = viewport_size.x;
	float height = viewport_size.y;

	if (split_active) {
		vec2 dx = player2_position - player1_position;

		float split_slope;
		if (dx.y != 0.0) {
			split_slope = dx.x / dx.y;
		} else {
			split_slope = 100000.0; // 如果 dx.y = 0，取一个大值（垂直分割）
		}

		vec2 split_origin = vec2(0.5, 0.5);
		vec2 split_line_start = vec2(0.0, height * ((split_origin.x - 0.0) * split_slope + split_origin.y));
		vec2 split_line_end = vec2(width, height * ((split_origin.x - 1.0) * split_slope + split_origin.y));

		float split_current_y = (split_origin.x - UV.x) * split_slope + split_origin.y;
		float split_player1_position_y = (split_origin.x - player1_position.x) * split_slope + split_origin.y;

		// 检查 UV 在分屏的哪一边，并选择合适的 view
		if (UV.y > split_current_y) {
			if (player1_position.y > split_player1_position_y) {
				COLOR = vec4(view1, 1.0);
			} else {
				COLOR = vec4(view2, 1.0);
			}
		} else {
			if (player1_position.y < split_player1_position_y) {
				COLOR = vec4(view1, 1.0);
			} else {
				COLOR = vec4(view2, 1.0);
			}
		}

		float distance_to_split_line = distance_to_line(split_line_start, split_line_end, vec2(UV.x * width, UV.y * height));
		if (distance_to_split_line < split_line_thickness) {
			// 绘制抗锯齿分割线
			COLOR.rgb = mix(split_line_color, COLOR.rgb, distance_to_split_line / split_line_thickness);
		}
	} else {
		COLOR = vec4(view1, 1.0);
	}
}
