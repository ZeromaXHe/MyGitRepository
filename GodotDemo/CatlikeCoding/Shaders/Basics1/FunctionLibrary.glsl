#[compute]
#version 450
// Failed parse 3:
//ERROR: 0:42: 'assign' :  cannot convert from ' in highp 3-component vector of float' to 'layout( column_major std430 offset=0) restrict temp highp float'
//ERROR: 0:42: '' : compilation terminated 
//ERROR: 2 compilation errors.  No code generated.
//
// Failed parse 2:
//ERROR: 0:35: '_Positions' :  left of '[' is not of type array, matrix, or vector  
//ERROR: 0:35: '' : compilation terminated 
//ERROR: 2 compilation errors.  No code generated.
//
// Failed parse 1:
//ERROR: 0:10: '' : memory qualifiers cannot be used on this type 
//ERROR: 0:10: 'non-opaque uniforms outside a block' : not allowed when using GLSL for Vulkan 
//ERROR: 0:10: 'binding' : requires block, or sampler/image, or atomic-counter type 
//ERROR: 0:10: 'rgba32f' : only apply to images 
//ERROR: 0:10: '' : compilation terminated 
//ERROR: 5 compilation errors.  No code generated.
//
// (Comments must use ASCII chars, or there will be errors in Godot:
// Unicode parsing error: Invalid unicode codepoint (xxxx), cannot represent as ASCII/Latin-1)
//
// translated from CatlikeCoding compute shader tutorial source code:
// https://bitbucket.org/catlikecodingunitytutorials/basics-05-compute-shaders/src/master/Assets/Scripts/FunctionLibrary.compute
layout (local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout (set = 0, binding = 0, std430) writeonly buffer Vertices {
    float data[]; // in ProceduralPlanet, vec3 splitted to 3 floats; we do it too, because Buffer.BlockCopy only apply to primitives' array
} transforms;
// TODO: What is the "uniform buffer" mentioned in ProceduralPlanet project?
layout (set = 0, binding = 1, std430) restrict buffer UintParamsBlock {
    uint _Resolution;
    uint _FuncIndex;
} uintParams;
// TODO: What is the "uniform buffer" mentioned in ProceduralPlanet project?
layout (set = 0, binding = 2, std430) restrict buffer FloatParamsBlock {
    float _Step;
    float _Time;
    float _TransitionProgress;
} floatParams;

vec2 GetUV(uvec3 id) {
    return (vec2(id.xy) + vec2(0.5)) * floatParams._Step - 1.0;
}

void SetTransform(uvec3 id, vec3 position) {
    if (id.x < uintParams._Resolution && id.y < uintParams._Resolution) {
        uint idx = id.x + id.y * uintParams._Resolution;
        transforms.data[12 * idx] = floatParams._Step;
        transforms.data[12 * idx + 1] = 0;
        transforms.data[12 * idx + 2] = 0;
        transforms.data[12 * idx + 3] = position.x;
        transforms.data[12 * idx + 4] = 0;
        transforms.data[12 * idx + 5] = floatParams._Step;
        transforms.data[12 * idx + 6] = 0;
        transforms.data[12 * idx + 7] = position.y;
        transforms.data[12 * idx + 8] = 0;
        transforms.data[12 * idx + 9] = 0;
        transforms.data[12 * idx + 10] = floatParams._Step;
        transforms.data[12 * idx + 11] = position.z;
    }
}

#define PI 3.14159265358979323846

vec3 Wave(float u, float v, float t) {
    vec3 p;
    p.x = u;
    p.y = sin(PI * (u + v + t));
    p.z = v;
    return p;
}

vec3 MultiWave(float u, float v, float t) {
    vec3 p;
    p.x = u;
    p.y = sin(PI * (u + 0.5 * t));
    p.y += 0.5 * sin(2.0 * PI * (v + t));
    p.y += sin(PI * (u + v + 0.25 * t));
    p.y *= 1.0 / 2.5;
    p.z = v;
    return p;
}

vec3 Ripple(float u, float v, float t) {
    float d = sqrt(u * u + v * v);
    vec3 p;
    p.x = u;
    p.y = sin(PI * (4.0 * d - t));
    p.y /= 1.0 + 10.0 * d;
    p.z = v;
    return p;
}

vec3 Sphere(float u, float v, float t) {
    float r = 0.9 + 0.1 * sin(PI * (12.0 * u + 8.0 * v + t));
    float s = r * cos(0.5 * PI * v);
    vec3 p;
    p.x = s * sin(PI * u);
    p.y = r * sin(0.5 * PI * v);
    p.z = s * cos(PI * u);
    return p;
}

vec3 Torus(float u, float v, float t) {
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
        SetTransform(id, function(uv.x, uv.y, floatParams._Time)); \
    }

#define KERNEL_MORPH_FUNCTION(functionA, functionB) \
    void functionA##To##functionB##Kernel (uvec3 id) { \
        vec2 uv = GetUV(id); \
        vec3 position = mix(\
            functionA(uv.x, uv.y, floatParams._Time), functionB(uv.x, uv.y, floatParams._Time), \
            floatParams._TransitionProgress \
        ); \
        SetTransform(id, position); \
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
    uvec3 id = gl_GlobalInvocationID;
    uint idx = uintParams._FuncIndex;
    switch(idx) {
        case 0: WaveKernel(id); break;
        case 1: WaveToMultiWaveKernel(id); break;
        case 2: WaveToRippleKernel(id); break;
        case 3: WaveToSphereKernel(id); break;
        case 4: WaveToTorusKernel(id); break;
        case 5: MultiWaveToWaveKernel(id); break;
        case 6: MultiWaveKernel(id); break;
        case 7: MultiWaveToRippleKernel(id); break;
        case 8: MultiWaveToSphereKernel(id); break;
        case 9: MultiWaveToTorusKernel(id); break;
        case 10: RippleToWaveKernel(id); break;
        case 11: RippleToMultiWaveKernel(id); break;
        case 12: RippleKernel(id); break;
        case 13: RippleToSphereKernel(id); break;
        case 14: RippleToTorusKernel(id); break;
        case 15: SphereToWaveKernel(id); break;
        case 16: SphereToMultiWaveKernel(id); break;
        case 17: SphereToRippleKernel(id); break;
        case 18: SphereKernel(id); break;
        case 19: SphereToTorusKernel(id); break;
        case 20: TorusToWaveKernel(id); break;
        case 21: TorusToMultiWaveKernel(id); break;
        case 22: TorusToRippleKernel(id); break;
        case 23: TorusToSphereKernel(id); break;
        case 24: TorusKernel(id); break;
    }
}