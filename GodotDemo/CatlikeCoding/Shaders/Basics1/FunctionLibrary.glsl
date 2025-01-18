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

layout (set = 0, binding = 0, std430) restrict buffer Vertices {
    float data[]; // in ProceduralPlanet, vec3 splitted to 3 floats; we do it too, because Buffer.BlockCopy only apply to primitives' array
} positions;
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

void SetPosition(uvec3 id, vec3 position) {
    if (id.x < uintParams._Resolution && id.y < uintParams._Resolution) {
        uint idx = id.x + id.y * uintParams._Resolution;
        positions.data[3 * idx] = position.x;
        positions.data[3 * idx + 1] = position.y;
        positions.data[3 * idx + 2] = position.z;
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
        SetPosition(id, function(uv.x, uv.y, floatParams._Time)); \
    }

#define KERNEL_MORPH_FUNCTION(functionA, functionB) \
    void functionA##To##functionB##Kernel (uvec3 id) { \
        vec2 uv = GetUV(id); \
        vec3 position = mix(\
            functionA(uv.x, uv.y, floatParams._Time), functionB(uv.x, uv.y, floatParams._Time), \
            floatParams._TransitionProgress \
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
    uvec3 id = gl_GlobalInvocationID;
    uint idx = uintParams._FuncIndex;
    if (idx < 12) {
        if (idx < 6) {
            if (idx < 3) {
                if (idx == 0) WaveKernel(id);
                else if (idx == 1) WaveToMultiWaveKernel(id);
                else /*if (idx == 2)*/ WaveToRippleKernel(id);
            } else { // 3 ~ 5
                if (idx == 3) WaveToSphereKernel(id);
                else if (idx == 4) WaveToTorusKernel(id);
                else /*if (idx == 5)*/ MultiWaveToWaveKernel(id);
            }
        } else if (idx < 9) { // 6 ~ 8
            if (idx == 6) MultiWaveKernel(id);
            else if (idx == 7) MultiWaveToRippleKernel(id);
            else /*if (idx == 8)*/ MultiWaveToSphereKernel(id);
        } else { // 9 ~ 11
            if (idx == 9) MultiWaveToTorusKernel(id);
            else if (idx == 10) RippleToWaveKernel(id);
            else /*if (idx == 11)*/ RippleToMultiWaveKernel(id);
        }
    } else if (idx < 18) { // 12 ~ 17
        if (idx < 15) { // 12 ~ 14
            if (idx == 12) RippleKernel(id);
            else if (idx == 13) RippleToSphereKernel(id);
            else /*if (idx == 14)*/ RippleToTorusKernel(id);
        } else { // 15 ~ 17
            if (idx == 15) SphereToWaveKernel(id);
            else if (idx == 16) SphereToMultiWaveKernel(id);
            else /*if (idx == 17)*/ SphereToRippleKernel(id);
        }
    } else if (idx < 21) { // 18 ~ 20
        if (idx == 18) SphereKernel(id);
        else if (idx == 19) SphereToTorusKernel(id);
        else /*if (idx == 20)*/ TorusToWaveKernel(id);
    } else if (idx < 23) { // 21 ~ 22
        if (idx == 21) TorusToMultiWaveKernel(id);
        else /**if (idx == 22)*/ TorusToRippleKernel(id);
    } else { // 23 ~ 24
        if (idx == 23) TorusToSphereKernel(id);
        else /*if (idx == 24)*/ TorusKernel(id);
    }
}