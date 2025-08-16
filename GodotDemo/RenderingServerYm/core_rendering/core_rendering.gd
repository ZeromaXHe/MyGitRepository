extends Node2D

const ICON: Texture2D = preload("res://icon.svg")

var pos := Vector2.ZERO;


func _process(delta: float) -> void:
	queue_redraw()


# 当节点被设置为可见时，Godot 就会触发一次 draw 函数，执行里面的代码
# 所以请注意，draw 函数不是每帧都会触发的
# 只有调用 queue_redraw() 后，Godot 才会在帧末尾清空渲染队列，然后重新绘制
func _draw() -> void:
	draw_texture(ICON, pos, Color.WHITE);
	pos.x += 1;
