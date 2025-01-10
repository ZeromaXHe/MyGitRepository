// NOTE: Shader automatically converted from Godot Engine 4.2.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color = vec4(1., 1., 1., 1.);
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128) = 1.0;
uniform float roughness : hint_range(0,1) = 1.0;
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel = vec4(0., 0., 0., 0.);
uniform sampler2D texture_roughness : hint_roughness_g,filter_linear_mipmap,repeat_enable;
uniform float specular = 0.5;
uniform float metallic = 1.0;
uniform sampler2D texture_normal : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform float normal_scale : hint_range(-16,16) = 1.0;
uniform vec3 uv1_scale = vec3(1., 1., 1.);
uniform vec3 uv1_offset = vec3(0., 0., 0.);
uniform vec3 uv2_scale = vec3(1., 1., 1.);
uniform vec3 uv2_offset = vec3(0., 0., 0.);

uniform float viewmodel_fov = 75.0f;

// E12 教程视频里的 Godot Shader 流程图：
//
// Vertex Shader:
// 模型/本地空间 Model/Local Space
// -(乘以 MODEL_MATRIX)-> 世界/全局空间 World/Global Space ->
// -(乘以 VIEW_MATRIX)-> 视图/相机空间 View/Camera Space ->
// -(乘以 PROJECTION_MATRIX)-> 剪切空间 Clip Space ->
// |-----------------------
// -> 透视除法 Perspective Division: vec3 ndc = clip.xyz / clip.w ->
// |-----------------------
// | Fragment Shader
// -> 归一化设备坐标 Normalized Device Coordinates -> 屏幕空间 Screen Space
void vertex() {

	UV=UV*uv1_scale.xy+uv1_offset.xy;

	/* VIEW MODEL Z CLIP FIX CODE */
	if (viewmodel_fov > 0.0) {
		float onetanfov = 1.0f / tan(0.5f * (viewmodel_fov * PI / 180.0f));
		float aspect = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
		// Optional: Modify projection matrix to change the FOV
		PROJECTION_MATRIX[1][1] = -onetanfov;
		PROJECTION_MATRIX[0][0] = onetanfov / aspect;
	}

	POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX.xyz, 1.0);
	// Mix 顶点 Z 到超级接近 clip 平面, 仍然留了一点距离
	//POSITION.z = mix(POSITION.z, 0.0, 0.999); // 老版本。 向 0.0 进行 Mix (接近 z 平面)
	// 上面代码对于 Godot 4.3 无效，因为 Z 被反转了: https://godotengine.org/article/introducing-reverse-z/
	// 现在我们需要向 1.0 mix, 但在 clip 空间会除以 POSITION.w，所以仍然没法生效。
	// 所以我们向 POSITION.w mix z，这样在透视除法（Persperctive Division）后，它将变成 1.0 (接近 buffer 因为 Z 被反转)
	POSITION.z = mix(POSITION.z, POSITION.w, 0.9); // 可以取更高的 mix 值，像 0.999，但我发现 0.9 防止 99% clipping w/ 比 0.999 更少失真
	/* END VIEW MODEL Z CLIP FIX CODE */
}

// POSITION.xyz = POSITION.xyz / POSITION.w;

void fragment() {


	// https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html#fragment-built-ins
	// in vec3 VERTEX
	// Vertex that comes from vertex function (default, in view space).
	// 你也可以在 fragment shader 中做深度 mix, 但我发现它会导致更多失真（artifacts）.
	//vec4 clipSpace = PROJECTION_MATRIX * vec4(VERTEX, 1.0);
	//vec3 ndc = clipSpace.xyz / clipSpace.w; // NDC, Normalized Device Coordinates
	//DEPTH = mix((ndc.z + 1.0) / 2.0, 1.0, 0.9);

	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(0.0,1.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	NORMAL_MAP = texture(texture_normal,base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;
}
