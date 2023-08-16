extends Node2D
class_name ParticleManager


const blood_scene: PackedScene = preload("res://scenes/blood.tscn")
const spark_scene: PackedScene = preload("res://scenes/spark.tscn")


func handle_bullet_hit_actor(actor: Actor, shooter: Actor, bullet_global_rotation: float, bullet_global_position: Vector2):
	# 击中角色时产生流血效果
	var blood = blood_scene.instantiate()
	blood.global_position = bullet_global_position
	blood.global_rotation = bullet_global_rotation
	# TODO: 后续使用对象池优化
	add_child(blood)


func handle_bullet_hit_something(global_rotation: float, global_position: Vector2):
	# 击中其他物品时产生弹片火花效果
	var spark = spark_scene.instantiate()
	spark.global_position = global_position
	spark.global_rotation = global_rotation
	# TODO: 后续使用对象池优化
	add_child(spark)


func clear():
	for child in get_children():
		child.queue_free()
