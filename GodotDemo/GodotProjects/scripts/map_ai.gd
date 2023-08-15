extends Node2D
class_name MapAI


signal unit_spawned(actor: Actor)
signal player_inited(player: Player)

const player = preload("res://scenes/player.tscn")

@export var team_side: Team.Side
@export var unit_scene: PackedScene = null
@export var max_units_alive: int = 4

@onready var team: Team = $Team
@onready var unit_container = $UnitContainer
@onready var respawn_timer: Timer = $RespawnTimer

var capturable_bases: Array = []
var respawn_points: Array = []
var respawn_idx: int = 0
var respawn_queue: Array[Actor] = []
var actor_map: Dictionary = {}

func initialize(capturable_bases: Array, respawn_points: Array):
	GlobalSignals.actor_killed.connect(handle_actor_killed)
	
	if capturable_bases.size() == 0 or respawn_points.size() == 0 or unit_scene == null:
		push_error("forgot to properly initialize map AI")
		return
	team.side = team_side
	
	self.respawn_points = respawn_points
	self.capturable_bases = capturable_bases
	# 初始化单位
	for i in range(respawn_points.size()):
		# 我方单位的第一个重生点生成玩家
		if i == 0 && team_side == Team.Side.PLAYER:
			init_player()
		else:
			init_ai_unit()
	
	for base in capturable_bases:
		(base as CapturableBase).base_captured.connect(handle_base_captured)


func init_player():
	var player_instance: Player = player.instantiate()
	player_instance.name = "Player"
	actor_map[player_instance] = respawn_idx
	respawn_unit(player_instance)

	player_inited.emit(player_instance)


func init_ai_unit():
	var unit_instance = unit_scene.instantiate() as Actor
	unit_instance.name = get_actor_name_prefix(team.side) + "Bot" + str(respawn_idx)
	actor_map[unit_instance] = respawn_idx
	respawn_unit(unit_instance)
	# TODO: 现在这个初始化逻辑乱得跟坨什么样的，得看下 Godot 的类型生命周期考虑一下如何重构
	# 目前 respawn_unit 的时候 ai 设置前进状态会失败(还没有 bases)，靠这里配置 bases 的时候再触发一次
	unit_instance.set_unit_bases(capturable_bases)


func get_actor_name_prefix(side: Team.Side) -> String:
	match (side):
		Team.Side.PLAYER:
			return "Ally"
		Team.Side.ENEMY:
			return "Enemy"
		_:
			return "Npc"


func handle_base_captured(base: CapturableBase):
	notify_base_captured_to_units(base)


func notify_base_captured_to_units(base: CapturableBase):
	for unit in unit_container.get_children():
		unit.handle_base_captured(base)


func handle_actor_killed(killed: Actor, killer: Actor):
	if killed.team.side == team_side:
		respawn_queue.push_back(killed)
		if respawn_timer.is_stopped():
			respawn_timer.start()


func _on_respawn_timer_timeout() -> void:
	var spawn_unit: Actor = respawn_queue.pop_front()
	respawn_unit(spawn_unit)
	if not respawn_queue.is_empty():
		respawn_timer.start()


func respawn_unit(unit_instance: Actor):
	unit_container.add_child(unit_instance)
	unit_instance.respawn(respawn_points[respawn_idx])
	unit_spawned.emit(unit_instance)
	
	# FIXME: 现在不会校验重生点是否有单位没走开
	respawn_idx += 1
	respawn_idx %= respawn_points.size()
