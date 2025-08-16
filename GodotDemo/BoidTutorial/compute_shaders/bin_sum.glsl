#[compute]
#version 450

layout(local_size_x = 1024, local_size_y = 1, local_size_z = 1) in;

#include "shared_data.glsl"

void main() {
    int my_index = int(gl_GlobalInvocationID.x);
    if (my_index < bin_params.num_bins) {
        bin_sum.data[my_index] = 0;
    }
    barrier();
    if (my_index < params.num_boids) {
        atomicAdd(bin_sum.data[bin.data[my_index]], 1);
    }
}