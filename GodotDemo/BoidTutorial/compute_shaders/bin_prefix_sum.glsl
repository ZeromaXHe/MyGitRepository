#[compute]
#version 450

layout(local_size_x = 1024, local_size_y = 1, local_size_z = 1) in;

#include "shared_data.glsl"

void main() {
    int my_index = int(gl_GlobalInvocationID.x);
    if (my_index >= bin_params.num_bins) return;
    bin_prefix_sum.data[my_index] = 0;
    for (int i = 0; i <= my_index; i++) {
        bin_prefix_sum.data[my_index] += bin_sum.data[i];
    }
    barrier();
    bin_index_tracker.data[my_index] = 0;
    if (my_index > 0) {
        bin_index_tracker.data[my_index] = bin_prefix_sum.data[my_index - 1];
    }
}