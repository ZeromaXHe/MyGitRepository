#[compute]
#version 450

// 对于计算着色器，我们要声明线程组的线程规模
// 在 layout 标签，分别指定 local_size_x/y/z
// 表示一个线程组中线程的数量，计算公式为线程总数 = x * y * z
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

// set 属性决定这个数据来源于哪个 uniform set
// binding，指定 uniform 绑定，决定单个 uniform 处于 uniform set 中的具体位置
// rgba32f 描述数据的格式，对应当初的 32 位浮点类型
// restrict，使用该修饰符，消除指针别名，让 glsl 编译器进行优化；restrict 表示该资源不会被其他采样器或图像同时访问
// 然后指定数据为 uniform，并且类型为 2D 图像
layout(set = 0, binding = 0, rgba32f) restrict uniform image2D import_image;

void main() {
    imageStore(import_image, ivec2(gl_GlobalInvocationID.xy), vec4(
        gl_GlobalInvocationID.x & gl_GlobalInvocationID.y,
        (gl_GlobalInvocationID.x & 15) / 15,
        (gl_GlobalInvocationID.y * 15) / 15,
        1.0
    ));
}