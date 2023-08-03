extends Node


@onready var bullet_manager: BulletManager = $BulletManager
@onready var player: Player = $Player


func _ready():
	player.player_fired_bullet.connect(bullet_manager.handle_bullet_spawned)

