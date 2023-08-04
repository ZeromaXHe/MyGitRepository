extends Node


@onready var capturable_base_manager = $CapturableBaseManager
@onready var ally_ai = $AllyMapAI
@onready var enemy_ai = $EnemyMapAI
@onready var player: Player = $Player
@onready var bullet_manager: BulletManager = $BulletManager


func _ready():
	# 刷新随机种子
	randomize()
	GlobalSignals.bullet_fired.connect(bullet_manager.handle_bullet_spawned)
	
	var bases = capturable_base_manager.get_capturable_bases()
	ally_ai.initialize(bases)
	enemy_ai.initialize(bases)

