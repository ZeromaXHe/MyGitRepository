shader_type spatial;

uniform sampler2D terrain_grass;
uniform sampler2D terrain_rock;
uniform float min_grass_height = -0.60;
uniform float max_rock_height = 1.6;

varying float vertex_y;
uniform vec2 uvscale = vec2(5);

void vertex() {
	// Called for every vertex the material is visible on.
	vertex_y = VERTEX.y;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float vert_height = vertex_y;
	
	vec3 grass = texture(terrain_grass, UV * uvscale).rgb;
	vec3 rock = texture(terrain_rock, UV * uvscale).rgb;
	
	float weight = smoothstep(min_grass_height, max_rock_height, vert_height);
	vec3 final_color = mix(grass, rock, weight);
	ALBEDO = final_color.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
