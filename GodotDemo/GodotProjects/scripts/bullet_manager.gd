class_name BulletManager
extends Node2D


func handle_bullet_spawned(bullet: Bullet, team: Team.TeamName, posi, direction):
	bullet.global_position = posi
	bullet.set_direction(direction)
	bullet.team = team
	add_child(bullet)
