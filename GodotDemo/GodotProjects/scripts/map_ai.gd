extends Node2D
class_name MapAI


signal unit_spawned(actor: Actor)
signal player_inited(player: Player)

enum BaseCaptureStartOrder {
	FIRST,
	LAST,
}

const player = preload("res://scenes/player.tscn")

@export var base_capture_start_order: BaseCaptureStartOrder
@export var team_side: Team.Side
@export var unit_scene: PackedScene = null
@export var max_units_alive: int = 4

@onready var team: Team = $Team
@onready var unit_container = $UnitContainer
@onready var respawn_timer: Timer = $RespawnTimer

var target_base: CapturableBase = null
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
	# 初始化单位
	for i in range(respawn_points.size()):
		# 我方单位的第一个重生点生成玩家
		if i == 0 && team_side == Team.Side.PLAYER:
			init_player()
		else:
			init_ai_unit()
	self.capturable_bases = capturable_bases
	
	for base in capturable_bases:
		(base as CapturableBase).base_captured.connect(handle_base_captured)
	
	check_for_capturable_bases()


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


func get_actor_name_prefix(side: Team.Side) -> String:
	match (side):
		Team.Side.PLAYER:
			return "Ally"
		Team.Side.ENEMY:
			return "Enemy"
		_:
			return "Npc"


func handle_base_captured(_new_team: Team.Side):
	check_for_capturable_bases()


func check_for_capturable_bases():
	target_base = get_next_capturable_base()
	if target_base != null:
		assign_next_capturable_base_to_units()


func get_next_capturable_base() -> CapturableBase:
	var list_of_bases = range(capturable_bases.size())
	if base_capture_start_order == BaseCaptureStartOrder.LAST:
		list_of_bases = range(capturable_bases.size() - 1, -1, -1)
	for i in list_of_bases:
		var base: CapturableBase = capturable_bases[i]
		if team.side != base.team.side:
			print("Assigning team %d to capture base %d" % [team.side, i])
			return base
	return null


func assign_next_capturable_base_to_units():
	for unit in unit_container.get_children():
		unit.set_ai_advance_to(target_base)


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
	# _ready() 是在进入场景树时调用，所以必须 add_child() 之后才会初始化 actor 的 ai
	unit_instance.respawn(respawn_points[respawn_idx], target_base)
	unit_spawned.emit(unit_instance)
	
	# FIXME: 现在不会校验重生点是否有单位没走开
	respawn_idx += 1
	respawn_idx %= respawn_points.size()
