extends Node


const game_over_scene: PackedScene = preload("res://scenes/game_over_screen.tscn")

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
	capturable_base_manager.player_captured_all_bases.connect(handle_player_win)
	capturable_base_manager.player_lost_all_bases.connect(handle_player_lose)
	
	ally_ai.unit_spawned.connect(name_labels_manager.handle_unit_spawned)
	ally_ai.player_inited.connect(handle_player_inited)
	enemy_ai.unit_spawned.connect(name_labels_manager.handle_unit_spawned)
	ally_ai.initialize(bases, ally_respawns.get_children())
	enemy_ai.initialize(bases, enemy_respawns.get_children())


func handle_player_inited(player_instance: Actor):
	player_instance.set_camera_transform(camera.get_path())
	gui.set_player(player_instance)


func handle_player_win():
	var game_over: GameOverScreen = game_over_scene.instantiate() as GameOverScreen
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true


func handle_player_lose():
	var game_over: GameOverScreen = game_over_scene.instantiate() as GameOverScreen
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true
