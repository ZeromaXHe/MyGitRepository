extends Node


const game_over_scene: PackedScene = preload("res://scenes/game_over_screen.tscn")
const pause_scene: PackedScene = preload("res://scenes/pause_screen.tscn")

@onready var capturable_base_manager: CapturableBaseManager = $CapturableBaseManager
@onready var ally_team_manager: TeamManager = $AllyTeamManager
@onready var enemy_team_manager: TeamManager = $EnemyTeamManager
@onready var bullet_manager: BulletManager = $BulletManager
@onready var camera_manager: CameraManager = $CameraManager
@onready var gui: GUI = $GUI
@onready var ground: TileMap = $Ground
@onready var particle_manager: ParticleManager = $ParticleManager
@onready var name_labels_manager: NameLabelsManager = $NameLabelsManager
@onready var night_canvas_modulate: CanvasModulate = $NightCanvasModulate


func _ready():
	# 刷新随机种子
	randomize()
	# 隐藏鼠标
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	
	GlobalSignals.bullet_fired.connect(handle_bullet_fired)
	GlobalSignals.bullet_hit_actor.connect(handle_bullet_hit_actor)
	GlobalSignals.bullet_hit_something.connect(particle_manager.handle_bullet_hit_something)
	
	capturable_base_manager.player_captured_all_bases.connect(handle_player_win)
	capturable_base_manager.player_lost_all_bases.connect(handle_player_lose)
	
	# 初始化地图 AI
	ally_team_manager.unit_spawned.connect(handle_unit_spawned)
	ally_team_manager.player_inited.connect(handle_player_inited)
	enemy_team_manager.unit_spawned.connect(handle_unit_spawned)
	
	ally_team_manager.init_units()
	enemy_team_manager.init_units()
	
	if GlobalMediator.navigation_debug:
		ground.navigation_visibility_mode = TileMap.VISIBILITY_MODE_FORCE_SHOW
	if GlobalMediator.night_battle:
		night_canvas_modulate.visible = true


func handle_unit_spawned(actor: Actor):
	gui.handle_unit_spawned(actor)
	# 生成名字标签
	name_labels_manager.handle_unit_spawned(actor)


func handle_bullet_fired(bullet: Bullet):
	bullet_manager.handle_bullet_spawned(bullet)
	# 玩家开枪时震动镜头
	if bullet.shooter.is_player():
		camera_manager.shake_camera(30)
		gui.player_fired()


func handle_bullet_hit_actor(actor: Actor, shooter: Actor, bullet_global_rotation: float, bullet_global_position: Vector2):
	particle_manager.handle_bullet_hit_actor(actor, shooter, bullet_global_rotation, bullet_global_position)
	# 玩家受击时震动镜头
	if actor.is_player():
		camera_manager.shake_camera(120)
	# 玩家命中敌人，显示击中标志
	if shooter.is_player():
		gui.show_player_hit_mark(false)


func handle_player_inited(player_instance: Player):
	player_instance.set_camera_transform(camera_manager.get_path())
	gui.set_player(player_instance)


func handle_player_win():
	game_over(true)


func handle_player_lose():
	game_over(false)


func game_over(win: bool):
	# 释放没播放完的粒子效果
	particle_manager.clear()
	
	var game_over: GameOverScreen = game_over_scene.instantiate() as GameOverScreen
	add_child(game_over)
	game_over.set_title(win)
	get_tree().paused = true


func _unhandled_input(event: InputEvent) -> void:
	# 暂停菜单
	if event.is_action_pressed("pause") and not get_tree().paused:
		var pause_menu = pause_scene.instantiate()
		add_child(pause_menu)
