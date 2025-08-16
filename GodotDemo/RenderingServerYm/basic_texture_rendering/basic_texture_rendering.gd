@tool
extends Node2D

const ICON: Texture2D = preload("res://icon.svg")


func _ready() -> void:
	# 重绘操作（queue_redraw()）实际上是一个延迟调用操作，在 CPU 空闲时间调用
	# 在重绘方法的延迟调用方法中，调用 canvas_item_clear 方法，清空了渲染命令
	# 所以需要等待一帧，这样在节点入树后，不会立刻提交渲染命令，避免提交的命令在第一帧末尾被 redraw 方法清空
	await get_tree().process_frame
	var item_rid: RID = get_canvas_item();
	var texture_rid: RID = ICON.get_rid();
	RenderingServer.canvas_item_add_texture_rect(
		item_rid, Rect2(50, 50, 100, 100), texture_rid)
