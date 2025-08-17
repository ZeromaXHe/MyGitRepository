extends Node2D

const SHADER: RDShaderFile = preload("res://rendering_pipeline/shader.glsl")

var rd: RenderingDevice
var shader: RID
var vertex_buffer: RID
var vertex_array: RID
var framebuffer_texture: RID
var framebuffer: RID
var render_pipeline: RID

@onready var texture_rect: TextureRect = %TextureRect


func _ready() -> void:
	rd = RenderingServer.create_local_rendering_device()
	var spirv: RDShaderSPIRV = SHADER.get_spirv()
	shader = rd.shader_create_from_spirv(spirv)
	
	var vertexs: PackedFloat32Array = [
		0.0, -1.0, # 0
		-1.0, 1.0, # 1
		1.0, 1.0, # 2
	]
	var vertex_bytes: PackedByteArray = vertexs.to_byte_array()
	vertex_buffer = rd.vertex_buffer_create(vertex_bytes.size(), vertex_bytes)
	var vertex_description: Array[RDVertexAttribute] = [
		RDVertexAttribute.new()
	]
	vertex_description[0].format = RenderingDevice.DATA_FORMAT_R32G32_SFLOAT
	vertex_description[0].location = 0
	vertex_description[0].offset = 0
	vertex_description[0].stride = 4 * 2
	
	var vertex_src_buffers: Array[RID] = [
		vertex_buffer
	]
	
	var vertex_format: int = rd.vertex_format_create(vertex_description)
	vertex_array = rd.vertex_array_create(3, vertex_format, vertex_src_buffers)
	
	var frametexture_format := RDTextureFormat.new()
	frametexture_format.format = RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT
	frametexture_format.width = 512
	frametexture_format.height = 512
	frametexture_format.usage_bits = RenderingDevice.TEXTURE_USAGE_COLOR_ATTACHMENT_BIT \
		| RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	framebuffer_texture = rd.texture_create(frametexture_format, RDTextureView.new())
	
	var framebuffers: Array[RID] = [framebuffer_texture]
	var framebuffer_attachment: Array[RDAttachmentFormat] = [
		RDAttachmentFormat.new()
	]
	framebuffer_attachment[0].format = frametexture_format.format
	framebuffer_attachment[0].samples = RenderingDevice.TEXTURE_SAMPLES_1
	framebuffer_attachment[0].usage_flags = frametexture_format.usage_bits
	
	var framebuffer_format: int = rd.framebuffer_format_create(framebuffer_attachment)
	framebuffer = rd.framebuffer_create(framebuffers, framebuffer_format)
	
	var color_blend_state := RDPipelineColorBlendState.new()
	var color_blend_attachment := RDPipelineColorBlendStateAttachment.new()
	color_blend_attachment.write_r = true
	color_blend_attachment.write_g = true
	color_blend_attachment.write_b = true
	color_blend_attachment.write_a = true
	color_blend_state.attachments.append(color_blend_attachment)
	render_pipeline = rd.render_pipeline_create(shader, framebuffer_format, vertex_format,
		RenderingDevice.RENDER_PRIMITIVE_TRIANGLES,
		RDPipelineRasterizationState.new(),
		RDPipelineMultisampleState.new(),
		RDPipelineDepthStencilState.new(),
		color_blend_state)
	
	var clear_color: PackedColorArray = [Color.BLACK]
	var draw_list: int = rd.draw_list_begin(framebuffer, RenderingDevice.DRAW_CLEAR_ALL, clear_color)
	rd.draw_list_bind_render_pipeline(draw_list, render_pipeline)
	rd.draw_list_bind_vertex_array(draw_list, vertex_array)
	rd.draw_list_draw(draw_list, false, 1)
	rd.draw_list_end()
	
	rd.submit()
	rd.sync()
	
	var data: PackedByteArray = rd.texture_get_data(framebuffer_texture, 0)
	var img: Image = Image.create_from_data(512, 512, false, Image.FORMAT_RGBAF, data)
	texture_rect.texture = ImageTexture.create_from_image(img)
