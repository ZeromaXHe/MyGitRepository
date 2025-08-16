shader_type particles;

uniform sampler2D boid_data;
uniform float scale = .5;

void start() {
	// Called when a particle is spawned.
}

void process() {
	// Called every frame on existing particles (according to the Fixed FPS property).
	ivec2 pos_image_size = textureSize(boid_data, 0);
	ivec2 texel_pos = ivec2(int(mod(float(INDEX), float(pos_image_size.x))),
							int(float(INDEX) / float(pos_image_size.x)));
	vec4 boid_pos_rot = texelFetch(boid_data, texel_pos, 0);
	mat2 scale_rot_mat = mat2(vec2(cos(boid_pos_rot.b), sin(boid_pos_rot.b)), // first column
							vec2(-sin(boid_pos_rot.b), cos(boid_pos_rot.b))); // second column
	scale_rot_mat *= scale;
	TRANSFORM[0].xy = scale_rot_mat[0];
	TRANSFORM[1].xy = scale_rot_mat[1];
	TRANSFORM[3].xy = vec2(boid_pos_rot.r, boid_pos_rot.g);
}