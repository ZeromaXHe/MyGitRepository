class_name BulletManager
extends Node2D


func handle_bullet_spawned(bullet: Bullet, team_side: Team.Side, posi, direction):
	bullet.global_position = posi
	bullet.set_direction(direction)
	bullet.team_side = team_side
	add_child(bullet)
