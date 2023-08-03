class_name BulletManager
extends Node2D


func handle_bullet_spawned(bullet: Bullet, posi, direction):
	bullet.global_position = posi
	bullet.set_direction(direction)
	add_child(bullet)
