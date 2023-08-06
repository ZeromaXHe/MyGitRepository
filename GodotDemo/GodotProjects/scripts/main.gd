extends Node

const player = preload("res://scenes/player.tscn")

@onready var capturable_base_manager: CapturableBaseManager = $CapturableBaseManager
@onready var ally_ai: MapAI = $AllyMapAI
@onready var enemy_ai: MapAI = $EnemyMapAI
@onready var bullet_manager: BulletManager = $BulletManager
@onready var camera: Camera2D = $Camera2D
@onready var kill_info: RichTextLabel = $CanvasLayer/KillInfo
@onready var name_labels_manager: NameLabelsManager = $GUI/NameLabelsManager
@onready var player_respawn_point: Node2D = $PlayerRespawnPoint

func _ready():
	# 刷新随机种子
	randomize()
	GlobalSignals.bullet_fired.connect(bullet_manager.handle_bullet_spawned)
	
	var ally_respawns = $AllyRespawnPoints
	var enemy_respawns = $EnemyRespawnPoints
	
	var bases = capturable_base_manager.get_capturable_bases()
	ally_ai.unit_spawned.connect(name_labels_manager.handle_unit_spawned)
	enemy_ai.unit_spawned.connect(name_labels_manager.handle_unit_spawned)
	ally_ai.initialize(bases, ally_respawns.get_children())
	enemy_ai.initialize(bases, enemy_respawns.get_children())

	# 清空 KillInfo 的内容
	kill_info.text = ""
	GlobalSignals.killed_info.connect(kill_info.handle_killed_info)
	
	spawn_player()


func spawn_player():
	var player_instance: Player = player.instantiate()
	player_instance.global_position = player_respawn_point.global_position
	player_instance.name = "Player"
	add_child(player_instance)
	player_instance.set_camera_transform(camera.get_path())
	player_instance.died.connect(handle_player_death)


func handle_player_death(killer):
	spawn_player()

