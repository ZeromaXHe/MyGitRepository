extends Node2D

const ICON: Texture2D = preload("res://icon.svg")
const MY_MATERIAL: CanvasItemMaterial = preload("res://2d_primitive_and_shader/my_canvas_item_material.tres")

var canvas_item: RID
var material_rid: RID
var shader_rid: RID


func _ready() -> void:
	var canvas: RID = get_canvas()
	canvas_item = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(canvas_item, canvas)
	
	material_rid = RenderingServer.material_create()
	RenderingServer.canvas_item_set_material(canvas_item, material_rid)
	
	shader_rid = RenderingServer.shader_create() # 使用 gdshader 而非 glsl
	RenderingServer.shader_set_code(shader_rid,
	"""
	shader_type canvas_item;
	
	uniform float value = 1.0;
	
	void fragment() {
		vec4 src = COLOR;
		vec4 gray = vec4(vec3((src.r + src.g + src.b) / 3.0), 1.0);
		COLOR = mix(src, gray, value);
		// COLOR = texture(TEXTURE, UV);
		// COLOR.a = UV.y;
	}
	""")
	RenderingServer.material_set_shader(material_rid, shader_rid)
	
	draw_canvas(canvas_item)


var timer: float = 0.0

func _process(delta: float) -> void:
	timer += delta
	RenderingServer.material_set_param(material_rid, "value", sin(timer))


func draw_canvas(canvas_item: RID):
	var texture_rid: RID = ICON.get_rid()
	#RenderingServer.canvas_item_set_material(canvas_item, MY_MATERIAL.get_rid())
	RenderingServer.canvas_item_add_primitive(
		canvas_item,
		PackedVector2Array([Vector2(400, 0), Vector2(0, 600), Vector2(800, 600)]),
		PackedColorArray([Color.RED, Color.GREEN, Color.BLUE]),
		PackedVector2Array([Vector2(0.5, 0), Vector2(0, 1.0), Vector2(1.0, 1.0)]),
		texture_rid)


func _notification(what: int) -> void:
	if (what == NOTIFICATION_PREDELETE):
		RenderingServer.free_rid(canvas_item)
