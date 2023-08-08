extends Node

@onready var capturable_base_manager: CapturableBaseManager = $CapturableBaseManager
@onready var ally_ai: MapAI = $AllyMapAI
@onready var enemy_ai: MapAI = $EnemyMapAI
@onready var bullet_manager: BulletManager = $BulletManager
@onready var camera: Camera2D = $Camera2D
@onready var name_labels_manager: NameLabelsManager = $GUIManager/NameLabelsManager
@onready var gui: GUI = $GUI

func _ready():
	# 刷新随机种子
	randomize()
	GlobalSignals.bullet_fired.connect(bullet_manager.handle_bullet_spawned)
	
	var ally_respawns = $AllyRespawnPoints
	var enemy_respawns = $EnemyRespawnPoints
	
	var bases = capturable_base_manager.get_capturable_bases()
	ally_ai.unit_spawned.connect(name_labels_manager.handle_unit_spawned)
	ally_ai.player_inited.connect(handle_player_inited)
	enemy_ai.unit_spawned.connect(name_labels_manager.handle_unit_spawned)
	ally_ai.initialize(bases, ally_respawns.get_children())
	enemy_ai.initialize(bases, enemy_respawns.get_children())


func handle_player_inited(player_instance: Actor):
	player_instance.set_camera_transform(camera.get_path())
	gui.set_player(player_instance)
