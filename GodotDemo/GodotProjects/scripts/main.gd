extends Node


@onready var bullet_manager: BulletManager = $BulletManager
@onready var player: Player = $Player


func _ready():
	# 刷新随机种子
	randomize()
	GlobalSignals.bullet_fired.connect(bullet_manager.handle_bullet_spawned)

