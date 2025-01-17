shader_type spatial;

uniform float smoothness: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	ALBEDO = clamp(world_pos * 0.5 + 0.5, 0, 1);
	ROUGHNESS = 1. - smoothness;
}
