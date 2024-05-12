shader_type spatial;

uniform sampler2D terrain_color;
uniform float min_height = 0;
uniform float max_height = 1;

varying float vertex_y;

float inverseLerp(float a, float b, float value) {
	float val = (value - a) / (b - a);
	return clamp(0.01, 1.0, val);
}

void vertex() {
	// Called for every vertex the material is visible on.
	vertex_y = VERTEX.y;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float height = vertex_y;
	float position = inverseLerp(min_height, max_height, height);
	vec3 color = texture(terrain_color, vec2(position, 0)).rgb;
	ALBEDO = color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
