// 本文件用来测试 .glsl 计算着色器代码的正确性
// 并不真正使用
vec2 GetUV (uvec3 id) {
	return (vec2(id.xy) + vec2(0.5)) * 0.1 - 1.0;
    //return (vec2(id.xy) + vec2(0.5)) * _Step - 1.0;
}

void SetPosition (uvec3 id, vec3 position) {
    //if (id.x < _Resolution && id.y < _Resolution) {
        //_Positions[id.x + id.y * _Resolution] = position;
    //}
	if (id.x < uint(10) && id.y < uint(10)) {
		//_Positions[id.x + id.y * uint(10)] = position;
	}
}

#define PI 3.14159265358979323846

vec3 Wave (float u, float v, float t) {
    vec3 p;
    p.x = u;
    p.y = sin(PI * (u + v + t));
    p.z = v;
    return p;
}

vec3 MultiWave (float u, float v, float t) {
    vec3 p;
    p.x = u;
    p.y = sin(PI * (u + 0.5 * t));
    p.y += 0.5 * sin(2.0 * PI * (v + t));
    p.y += sin(PI * (u + v + 0.25 * t));
    p.y *= 1.0 / 2.5;
    p.z = v;
    return p;
}

vec3 Ripple (float u, float v, float t) {
    float d = sqrt(u * u + v * v);
    vec3 p;
    p.x = u;
    p.y = sin(PI * (4.0 * d - t));
    p.y /= 1.0 + 10.0 * d;
    p.z = v;
    return p;
}

vec3 Sphere (float u, float v, float t) {
    float r = 0.9 + 0.1 * sin(PI * (12.0 * u + 8.0 * v + t));
    float s = r * cos(0.5 * PI * v);
    vec3 p;
    p.x = s * sin(PI * u);
    p.y = r * sin(0.5 * PI * v);
    p.z = s * cos(PI * u);
    return p;
}

vec3 Torus (float u, float v, float t) {
    float r1 = 0.7 + 0.1 * sin(PI * (8.0 * u + 0.5 * t));
    float r2 = 0.15 + 0.05 * sin(PI * (16.0 * u + 8.0 * v + 3.0 * t));
    float s = r2 * cos(PI * v) + r1;
    vec3 p;
    p.x = s * sin(PI * u);
    p.y = r2 * sin(PI * v);
    p.z = s * cos(PI * u);
    return p;
}

#define KERNEL_FUNCTION(function) \
	void function##Kernel (uvec3 id) { \
		vec2 uv = GetUV(id); \
		SetPosition(id, function(uv.x, uv.y, 0)); \
	}

#define KERNEL_MORPH_FUNCTION(functionA, functionB) \
	void functionA##To##functionB##Kernel (uvec3 id) { \
		vec2 uv = GetUV(id); \
		vec3 position = mix( \
			functionA(uv.x, uv.y, 0), functionB(uv.x, uv.y, 0), \
			1 \
		); \
		SetPosition(id, position); \
	}

KERNEL_FUNCTION(Wave)
KERNEL_FUNCTION(MultiWave)
KERNEL_FUNCTION(Ripple)
KERNEL_FUNCTION(Sphere)
KERNEL_FUNCTION(Torus)

KERNEL_MORPH_FUNCTION(Wave, MultiWave)
KERNEL_MORPH_FUNCTION(Wave, Ripple)
KERNEL_MORPH_FUNCTION(Wave, Sphere)
KERNEL_MORPH_FUNCTION(Wave, Torus)

KERNEL_MORPH_FUNCTION(MultiWave, Wave)
KERNEL_MORPH_FUNCTION(MultiWave, Ripple)
KERNEL_MORPH_FUNCTION(MultiWave, Sphere)
KERNEL_MORPH_FUNCTION(MultiWave, Torus)

KERNEL_MORPH_FUNCTION(Ripple, Wave)
KERNEL_MORPH_FUNCTION(Ripple, MultiWave)
KERNEL_MORPH_FUNCTION(Ripple, Sphere)
KERNEL_MORPH_FUNCTION(Ripple, Torus)

KERNEL_MORPH_FUNCTION(Sphere, Wave)
KERNEL_MORPH_FUNCTION(Sphere, MultiWave)
KERNEL_MORPH_FUNCTION(Sphere, Ripple)
KERNEL_MORPH_FUNCTION(Sphere, Torus)

KERNEL_MORPH_FUNCTION(Torus, Wave)
KERNEL_MORPH_FUNCTION(Torus, MultiWave)
KERNEL_MORPH_FUNCTION(Torus, Ripple)
KERNEL_MORPH_FUNCTION(Torus, Sphere)

void main() {
	WaveKernel(uvec3(1));
}