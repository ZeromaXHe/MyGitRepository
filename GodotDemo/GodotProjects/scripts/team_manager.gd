extends Node2D
class_name TeamManager


signal unit_spawned(actor: Actor)
signal player_inited(player: Player)
signal ai_unit_inited(actor: Actor)

const player = preload("res://scenes/player.tscn")

@export var team_side: Team.Side
@export var unit_scene: PackedScene = null

@onready var unit_container = $UnitContainer
@onready var respawn_timer: Timer = $RespawnTimer
@onready var respawn_manager: Node2D = $RespawnManager

var respawn_idx: int = 0
var respawn_queue: Array[Actor] = []
var actor_map: Dictionary = {}

func _ready() -> void:
	GlobalSignals.actor_killed.connect(handle_actor_killed)
	
	if unit_scene == null:
		push_error("forgot to properly initialize team manager")
		return
	
	for base in GlobalMediator.capturable_base_manager.capturable_bases:
		(base as CapturableBase).base_captured.connect(handle_base_captured)


func init_units() -> void:
	# 初始化单位
	for i in range(respawn_manager.get_children().size()):
		# 我方单位的第一个重生点生成玩家
		if i == 0 && team_side == Team.Side.PLAYER:
			init_player()
		else:
			init_ai_unit()


func init_player():
	var player_instance: Player = player.instantiate()
	player_instance.name = "Player"
	actor_map[player_instance] = respawn_idx
	respawn_unit(player_instance)

	player_inited.emit(player_instance)


func init_ai_unit():
	var unit_instance = unit_scene.instantiate() as Actor
	unit_instance.name = get_actor_name_prefix(team_side) + "Bot" + str(respawn_idx)
	actor_map[unit_instance] = respawn_idx
	respawn_unit(unit_instance)
	
	ai_unit_inited.emit(unit_instance)


func get_actor_name_prefix(side: Team.Side) -> String:
	match (side):
		Team.Side.PLAYER:
			return "Ally"
		Team.Side.ENEMY:
			return "Enemy"
		_:
			return "Npc"


func handle_base_captured(base: CapturableBase, actors: Array[Actor]):
	for unit in unit_container.get_children():
		unit.handle_base_captured(base, actors)


func handle_actor_killed(killed: Actor, killer: Actor, _weapon: Weapon):
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
	unit_instance.respawn(respawn_manager.get_children()[respawn_idx])
	unit_spawned.emit(unit_instance)
	
	# FIXME: 现在不会校验重生点是否有单位没走开
	respawn_idx += 1
	respawn_idx %= respawn_manager.get_children().size()
