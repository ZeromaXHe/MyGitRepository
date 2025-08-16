#[compute]
#version 450

layout(local_size_x = 1024, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) restrict buffer Position {
    vec2 data[];
} boid_pos;

layout(set = 0, binding = 1, std430) restrict buffer Velocity {
    vec2 data[];
} boid_vel;

layout(set = 0, binding = 2, std430) restrict buffer Params {
    float num_boids;
    float image_size;
    float friend_radius;
    float avoid_radius;
    float min_vel;
    float max_vel;
    float alignment_factor;
    float cohesion_factor;
    float separation_factor;
    float viewport_x;
    float viewport_y;
    float delta_time;
} params;

layout(rgba16f, binding = 3) uniform image2D boid_data;

void main() {
    int my_index = int(gl_GlobalInvocationID.x);
    vec2 my_pos = boid_pos.data[my_index];
    vec2 my_vel = boid_vel.data[my_index];
    vec2 avg_vel = vec2(0, 0);
    vec2 midpoint = vec2(0, 0);
    vec2 separation_vec = vec2(0, 0);
    int avoids = 0;
    int num_friends = 0;
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

    ivec2 pixel_pos = ivec2(int(mod(my_index, params.image_size)), int(my_index / params.image_size));
    imageStore(boid_data, pixel_pos, vec4(my_pos.x, my_pos.y, my_rot, num_friends));
}