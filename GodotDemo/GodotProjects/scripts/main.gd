extends Node


const game_over_scene: PackedScene = preload("res://scenes/game_over_screen.tscn")
const pause_scene: PackedScene = preload("res://scenes/pause_screen.tscn")
const blood_scene: PackedScene = preload("res://scenes/blood.tscn")
const spark_scene: PackedScene = preload("res://scenes/spark.tscn")

@onready var capturable_base_manager: CapturableBaseManager = $CapturableBaseManager
@onready var ally_ai: MapAI = $AllyMapAI
@onready var enemy_ai: MapAI = $EnemyMapAI
@onready var bullet_manager: BulletManager = $BulletManager
@onready var camera: Camera2D = $Camera2D
@onready var name_labels_manager: NameLabelsManager = $GUIManager/NameLabelsManager
@onready var gui: GUI = $GUI
@onready var ground: TileMap = $Ground
@onready var particles: Node2D = $Particles


func _ready():
	# 刷新随机种子
	randomize()
	GlobalSignals.bullet_fired.connect(bullet_manager.handle_bullet_spawned)
	GlobalSignals.bullet_hit_actor.connect(handle_bullet_hit_actor)
	GlobalSignals.bullet_hit_something.connect(handle_bullet_hit_something)
	
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


func handle_bullet_hit_actor(global_rotation: float, global_position: Vector2):
	var blood = blood_scene.instantiate()
	blood.global_position = global_position
	blood.global_rotation = global_rotation
	# TODO: 后续使用对象池优化
	particles.add_child(blood)


func handle_bullet_hit_something(global_rotation: float, global_position: Vector2):
	var spark = spark_scene.instantiate()
	spark.global_position = global_position
	spark.global_rotation = global_rotation
	# TODO: 后续使用对象池优化
	particles.add_child(spark)


func handle_player_inited(player_instance: Player):
	player_instance.set_camera_transform(camera.get_path())
	gui.set_player(player_instance)


func handle_player_win():
	game_over(true)


func handle_player_lose():
	game_over(false)


func game_over(win: bool):
	particles.queue_free()
	var game_over: GameOverScreen = game_over_scene.instantiate() as GameOverScreen
	add_child(game_over)
	game_over.set_title(win)
	get_tree().paused = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not get_tree().paused:
		var pause_menu = pause_scene.instantiate()
		add_child(pause_menu)
