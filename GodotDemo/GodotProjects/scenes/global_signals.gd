extends Node

signal bullet_fired(bullet: Bullet)

signal actor_killed(killed: Actor, killer: Actor, weapon: Weapon)

signal bullet_hit_actor(actor: Actor, shooter: Actor,\
		bullet_global_rotation: float, bullet_global_position: Vector2)

signal bullet_hit_something(global_rotation: float, global_position: Vector2)

signal chat_info_sended(chater_name: String, team_character: Team.Character, text: String)
