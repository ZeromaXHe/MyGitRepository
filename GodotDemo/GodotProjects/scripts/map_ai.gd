extends Node2D
class_name MapAI


signal unit_spawned(actor: Actor)


enum BaseCaptureStartOrder {
	FIRST,
	LAST,
}

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
var spawn_idx_queue: Array[int] = []


func initialize(capturable_bases: Array, respawn_points: Array):
	if capturable_bases.size() == 0 or respawn_points.size() == 0 or unit_scene == null:
		push_error("forgot to properly initialize map AI")
		return
	team.side = team_side
	
	self.respawn_points = respawn_points
	# 初始化单位
	for i in range(respawn_points.size()):
		initialize_spawn_unit(respawn_points[i].global_position, i)
	self.capturable_bases = capturable_bases
	
	for base in capturable_bases:
		(base as CapturableBase).base_captured.connect(handle_base_captured)
	
	check_for_capturable_bases()


func initialize_spawn_unit(spawn_location: Vector2, spawn_idx: int):
	var unit_instance = unit_scene.instantiate() as Actor
	unit_instance.global_position = spawn_location
	unit_instance.died.connect(handle_unit_death)
	# FIXME: 这里命名生成有问题，估计有时执行的时候之前的引用还没释放，导致重名
	unit_instance.set_actor_name(get_actor_name_prefix(team.side) + "Bot" + str(spawn_idx))
	unit_instance.spawn_idx = spawn_idx
	unit_container.add_child(unit_instance)
	# _ready() 是在进入场景树时调用，所以必须 add_child() 之后才会初始化 actor 的 ai
	unit_instance.set_ai_advance_to(target_base)
	
	unit_spawned.emit(unit_instance)


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


func handle_unit_death(unit: Actor, killer):
	spawn_idx_queue.push_back(unit.spawn_idx)
	if respawn_timer.is_stopped():
		respawn_timer.start()


func _on_respawn_timer_timeout() -> void:
	var next_spawn_idx = spawn_idx_queue.pop_front()
	var respawn = respawn_points[next_spawn_idx]
	initialize_spawn_unit(respawn.global_position, next_spawn_idx)
	if not spawn_idx_queue.is_empty():
		respawn_timer.start()


#func spawn_unit(spawn_location: Vector2, spawn_idx: int):
#	var unit: Actor = unit_list[spawn_idx]
#	unit.global_position = spawn_location
#	unit.visible = true
#	unit.disable_mode = CollisionObject2D.DISABLE_MODE_KEEP_ACTIVE
#	unit.ai.activate_detection_zone()
#	unit.set_ai_advance_to(target_base)
#
#	unit_spawned.emit(unit)
