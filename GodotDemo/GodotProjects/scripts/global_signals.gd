extends Node

signal bullet_fired(bullet: Bullet)

signal actor_killed(killed: Actor, killer: Actor)

signal bullet_hit_actor(actor: Actor, global_rotation: float, global_position: Vector2)

signal bullet_hit_something(global_rotation: float, global_position: Vector2)
