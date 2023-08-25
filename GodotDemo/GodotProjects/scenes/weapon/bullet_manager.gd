class_name BulletManager
extends Node2D


func handle_bullet_spawned(bullet: Bullet):
	add_child(bullet)
