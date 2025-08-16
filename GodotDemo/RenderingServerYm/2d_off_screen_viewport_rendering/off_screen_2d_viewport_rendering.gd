extends Node

var viewport: RID
var canvas: RID
var canvas_item: RID


func _ready() -> void:
	viewport = RenderingServer.viewport_create()
	RenderingServer.viewport_set_size(viewport, 100, 100) # 没有这行时，默认生成 4x4 洋红/黑色棋盘格子 png
	RenderingServer.viewport_set_active(viewport, true)
	RenderingServer.viewport_set_clear_mode(viewport, RenderingServer.VIEWPORT_CLEAR_ALWAYS)
	RenderingServer.viewport_set_update_mode(viewport, RenderingServer.VIEWPORT_UPDATE_ALWAYS)
	#viewport = get_tree().root.get_viewport_rid() # 绘制到主视口
	canvas = RenderingServer.canvas_create()
	RenderingServer.viewport_attach_canvas(viewport, canvas)
	canvas_item = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(canvas_item, canvas)
	RenderingServer.canvas_item_add_circle(canvas_item, Vector2(50, 50), 25, Color.WHITE)
	
	# RenderingServer 单例有两个信号，分别表示渲染帧开始与结束
	# 当 frame_post_draw 信号发出，渲染帧结束，我们再保存图像
	#await RenderingServer.frame_post_draw
	# 调用 force_draw() 方法，可以强制 RenderingServer 立即重绘所有视口
	# 这就包括活跃的主视口，以及其他子视口，都会被重新绘制
	RenderingServer.force_draw()
	
	var viewport_texture: RID = RenderingServer.viewport_get_texture(viewport)
	var img: Image = RenderingServer.texture_2d_get(viewport_texture)
	img.save_png("res://2d_off_screen_viewport_rendering/export.png")


func _notification(what: int) -> void:
	if (what == NOTIFICATION_PREDELETE):
		RenderingServer.free_rid(canvas_item)
		RenderingServer.free_rid(canvas)
		RenderingServer.free_rid(viewport)
