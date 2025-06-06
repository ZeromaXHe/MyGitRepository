
// NOTE: Shader automatically converted from Godot Engine 4.3.stable's FogMaterial.

shader_type fog;

uniform float density : hint_range(-8, 8, 0.0001) = 1.0;
uniform vec4 albedo : source_color = vec4(1.0);
uniform vec4 emission : source_color = vec4(0, 0, 0, 1);
uniform float height_falloff = 0.0;
uniform float edge_fade = 0.1;
uniform sampler3D density_texture: hint_default_white;


vec3 random3(vec3 c) {
	float j = 4096.0 + sin(dot(c, vec3(17.0, 59.4, 15.0)));
	vec3 r;
	r.z = fract(512.0 * j);
	j *= .125;
	r.x = fract(512.0 * j);
	j *= .125;
	r.y = fract(512.0 * j);
	return r - 0.5;
}

/* skew constants for 3d simplex functions */
const float F3 = 0.3333333;
const float G3 = 0.1666667;

/* 3d simplex noise */
float simplex3d(vec3 p) {
	/* 1. find current tetrahedron T and it's four vertices */
	/* s, s+i1, s+i2, s+1.0 - absolute skewed (integer) coordinates of T vertices */
	/* x, x1, x2, x3 - unskewed coordinates of p relative to each of T vertices*/
	p = p * 5.0;
	vec3 s = floor(p + dot(p, vec3(F3)));
	vec3 x = p - s + dot(s, vec3(G3));
	
	vec3 e = step(vec3(0.), x - x.yzx);
	vec3 i1 = e * (1.0 - e.zxy);
	vec3 i2 = 1.0 - e.zxy * (1.0 - e);
	
	vec3 x1 = x - i1 + G3;
	vec3 x2 = x - i2 + 2.0 * G3;
	vec3 x3 = x - 1.0 + 3.0 * G3;
	
	/* 2. find four surflets and store them in d */
	vec4 w, d;
	/* calculate surflet weights */
	w.x = dot(x, x);
	w.y = dot(x1, x1);
	w.z = dot(x2, x2);
	w.w = dot(x3, x3);
	/* w fades from 0.6 at the center of the surflet to 0.0 at the margin */
	w = max(0.6 - w, 0.0);
	/* calculate surflet components */
	d.x = dot(random3(s), x);
	d.y = dot(random3(s + i1), x1);
	d.z = dot(random3(s + i2), x2);
	d.w = dot(random3(s + 1.0), x3);
	/* multiply d by w^4 */
	w *= w;
	w *= w;
	d *= w;
	/* 3. return the sum of the four surflets */
	return dot(d, vec4(52.));
}

/* const matrices for 3d rotation */
const mat3 rot1 = mat3(vec3(-.37, .36, .85), vec3(-.14, -.93, .34), vec3(.92, .01, .4));
const mat3 rot2 = mat3(vec3(-.55, -.39, .74), vec3(.33, -.91, -.24), vec3(.77, .12, .63));
const mat3 rot3 = mat3(vec3(-.71, .52, -.47), vec3(-.08, -.72, -.68), vec3(-.7, -.45, .56));

/* directional artifacts can be reduced by rotating each octave */
float simplex3d_fractal(vec3 m) {
	return 0.5333333 * simplex3d(m * rot1) + 0.2666667 * simplex3d(2.0 * m * rot2)
		+ 0.1333333 * simplex3d(4.0 * m * rot3) + 0.0666667 * simplex3d(8.0 * m);
}

void fog() {
	DENSITY = density * clamp(exp2(-height_falloff * (WORLD_POSITION.y - OBJECT_POSITION.y)), 0.0, 1.0);
	DENSITY *= texture(density_texture, UVW).r;
	DENSITY *= pow(clamp(-2.0 * SDF / min(min(SIZE.x, SIZE.y), SIZE.z), 0.0, 1.0), edge_fade);
	float n = simplex3d_fractal(vec3(UVW.x, UVW.y - TIME * 0.1, UVW.z));
	n = 0.5 + 0.5 * n;
	n = n - smoothstep(0.3, 0.7, distance(UVW, vec3(0.5)));
	DENSITY *= n;
	ALBEDO = albedo.rgb;
	EMISSION = emission.rgb;
}
