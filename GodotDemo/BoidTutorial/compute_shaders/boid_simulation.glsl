#[compute]
#version 450

layout(local_size_x = 1024, local_size_y = 1, local_size_z = 1) in;

#include "shared_data.glsl"

void main() {
    int my_index = int(gl_GlobalInvocationID.x);
    if (my_index >= params.num_boids) return;

    vec2 my_pos = boid_pos.data[my_index];
    vec2 my_vel = boid_vel.data[my_index];
    vec2 avg_vel = vec2(0, 0);
    vec2 midpoint = vec2(0, 0);
    vec2 separation_vec = vec2(0, 0);
    int avoids = 0;
    int num_friends = 0;

    bool use_bins = true;
    int my_bin = bin.data[my_index];

    if (use_bins) {
        vec2 my_bin_x_y = one_to_two(my_bin, bin_params.bins_x);
        vec2 starting_bin = my_bin_x_y - vec2(1, 1);
        vec2 current_bin = starting_bin;
        for (int y = 0; y < 3; y++) {
            current_bin.y = starting_bin.y + y;
            if (current_bin.y < 0 || current_bin.y > bin_params.bins_y) continue;
            for (int x = 0; x < 3; x++) {
                current_bin.x = starting_bin.x + x;
                if (current_bin.x < 0 || current_bin.x > bin_params.bins_x) continue;
                int bin_index = two_to_one(current_bin, bin_params.bins_x);
                for (int i = bin_prefix_sum.data[bin_index - 1]; i < bin_prefix_sum.data[bin_index]; i++) {
                    int other_index = bin_reindex.data[i];
                    if (other_index != my_index) {
                        vec2 other_pos = boid_pos.data[other_index];
                        vec2 other_vel = boid_vel.data[other_index];
                        float dist = distance(my_pos, other_pos);
                        if (dist < params.friend_radius) {
                            num_friends += 1;
                            avg_vel += other_vel;
                            midpoint += other_pos;
                            if (dist < params.avoid_radius) {
                                avoids += 1;
                                separation_vec += my_pos - other_pos;
                            }
                        }
                    }
                }
            }
        }
    }
    else {
        for (int i = 0; i < params.num_boids; i++) {
            if (i != my_index) {
                vec2 other_pos = boid_pos.data[i];
                vec2 other_vel = boid_vel.data[i];
                float dist = distance(my_pos, other_pos);
                if (dist < params.friend_radius) {
                    num_friends += 1;
                    avg_vel += other_vel;
                    midpoint += other_pos;
                    if (dist < params.avoid_radius) {
                        avoids += 1;
                        separation_vec += my_pos - other_pos;
                    }
                }
            }
        }
    }
    if (num_friends > 0) {
        avg_vel /= num_friends;
        my_vel += normalize(avg_vel) * params.alignment_factor;
        midpoint /= num_friends;
        my_vel += normalize(midpoint - my_pos) * params.cohesion_factor;
        if (avoids > 0) {
            my_vel += normalize(separation_vec) * params.separation_factor;
        }
    }
    float my_rot = 0.0;
    my_rot = acos(dot(normalize(my_vel), vec2(1, 0)));
    if (isnan(my_rot)) {
        my_rot = 0.0;
    } else if (my_vel.y < 0) {
        my_rot = -my_rot;
    }
    float vel_mag = length(my_vel);
    vel_mag = clamp(vel_mag, params.min_vel, params.max_vel);
    my_vel = normalize(my_vel) * vel_mag;
    
    my_pos += my_vel * params.delta_time;
    my_pos = vec2(mod(my_pos.x, params.viewport_x), mod(my_pos.y, params.viewport_y));

    boid_vel.data[my_index] = my_vel;
    boid_pos.data[my_index] = my_pos;
    bin.data[my_index] = int(my_pos.x / bin_params.bin_size) + int(my_pos.y / bin_params.bin_size) * bin_params.bins_x;

    ivec2 pixel_pos = ivec2(int(mod(my_index, params.image_size)), int(my_index / params.image_size));
    imageStore(boid_data, pixel_pos, vec4(my_pos.x, my_pos.y, my_rot, num_friends));
}