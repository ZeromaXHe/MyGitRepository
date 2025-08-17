extends Node2D

const COMPUTE_SHADER: RDShaderFile = preload("res://compute_pipeline/compute_shader.glsl")

var rd: RenderingDevice
var shader: RID
var image_size := Vector2i(500, 500)
var import_image: RID
var uniform_set: RID
var compute_pipeline: RID

@onready var texture_rect: TextureRect = %TextureRect


func _ready() -> void:
	rd = RenderingServer.create_local_rendering_device()
	var shader_spirv: RDShaderSPIRV = COMPUTE_SHADER.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)
	compute_pipeline = rd.compute_pipeline_create(shader)
	
	var format := RDTextureFormat.new()
	format.format = RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT
	format.width = image_size.x
	format.height = image_size.y
	format.usage_bits = RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | \
		RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	var view := RDTextureView.new()
	import_image = rd.texture_create(format, view, [])
	
	var import_texture_uniform := RDUniform.new()
	import_texture_uniform.binding = 0
	import_texture_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	import_texture_uniform.add_id(import_image)
	uniform_set = rd.uniform_set_create([import_texture_uniform], shader, 0)
	
	var compute_list: int = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, compute_pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, ceil(image_size.x / 8), ceil(image_size.y / 8), 1)
	rd.compute_list_end()
	
	rd.submit()
	rd.sync()
	
	var data: PackedByteArray = rd.texture_get_data(import_image, 0)
	var img := Image.create_from_data(image_size.x, image_size.y, false,
		Image.Format.FORMAT_RGBAF, data)
	texture_rect.texture = ImageTexture.create_from_image(img)


func _notification(what: int) -> void:
	match (what):
		NOTIFICATION_PREDELETE:
			rd.free()
