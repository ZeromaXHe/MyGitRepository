extends Node

signal bullet_fired(bullet: Bullet)

signal killed_info(killed_team_side: Team.Side, killed_name: String, \
		killer_team_side: Team.Side, killer_name: String)
