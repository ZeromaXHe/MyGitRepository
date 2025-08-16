#[compute]
#version 450

layout(local_size_x = 1024, local_size_y = 1, local_size_z = 1) in;

#include "shared_data.glsl"

void main() {
    int my_index = int(gl_GlobalInvocationID.x);
    if (my_index >= params.num_boids) return;
    int my_bin = bin.data[my_index];
    int last_index = atomicAdd(bin_index_tracker.data[my_bin], 1);
    bin_reindex.data[last_index] = my_index;
}