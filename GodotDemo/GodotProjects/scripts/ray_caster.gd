extends Node2D


@export var ray_range: int = 600

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D

var pre_frame_ray_collide: bool = false


func _ready() -> void:
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.RIGHT * ray_range)
	
	ray_cast.target_position = Vector2(ray_range, 0)


func _process(delta: float) -> void:
	if ray_cast.is_colliding():
		# 这里切记不能修改根节点的 scale，不然会影响这里的距离判断…… 一开始我就是拿 Img 做根节点，缩小图片导致 bug
		line.set_point_position(1, Vector2.RIGHT * \
				ray_cast.global_position.distance_to(ray_cast.get_collision_point()))
		pre_frame_ray_collide = true
	else:
		if pre_frame_ray_collide:
			# 如果之前碰撞了，恢复正常值
			line.set_point_position(1, Vector2.RIGHT * ray_range)
		pre_frame_ray_collide = false

