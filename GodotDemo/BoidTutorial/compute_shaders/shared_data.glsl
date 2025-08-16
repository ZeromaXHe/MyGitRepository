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

layout(set = 0, binding = 4, std430) restrict buffer BinParams {
    int bin_size;
    int bins_x;
    int bins_y;
    int num_bins;
} bin_params;

layout(set = 0, binding = 5, std430) restrict buffer Bin {
    int data[];
} bin;

layout(set = 0, binding = 6, std430) restrict buffer BinCount {
    int data[];
} bin_sum;

layout(set = 0, binding = 7, std430) restrict buffer ReindexBinCount {
    int data[];
} bin_prefix_sum;

layout(set = 0, binding = 8, std430) restrict buffer ReindexBin {
    int data[];
} bin_index_tracker;

layout(set = 0, binding = 9, std430) restrict buffer ReindexBinPositions {
    int data[];
} bin_reindex;

ivec2 one_to_two(int index, int grid_width) {
    int row = int(index / grid_width);
    int col = int(mod(index, grid_width));
    return ivec2(col, row);
}

int two_to_one(vec2 index, int grid_width) {
    int row = int(index.y);
    int col = int(index.x);
    return row * grid_width + col;
}