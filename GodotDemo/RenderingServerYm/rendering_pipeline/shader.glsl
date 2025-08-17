#[vertex]
#version 450

layout(location = 0) in vec2 p_pos;

void main() {
    gl_Position = vec4(p_pos.x, p_pos.y, 1.0, 1.0);
}

#[fragment]
#version 450

layout(location = 0) out vec4 frag_color;
void main() {
    frag_color = vec4(1.0);
}