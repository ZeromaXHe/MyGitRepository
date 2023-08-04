extends Node2D
class_name MapAI

enum BaseCaptureStartOrder {
	FIRST,
	LAST,
}

@export var base_capture_start_order: BaseCaptureStartOrder
@export var team_name: Team.TeamName
@export var unit_scene: PackedScene = null
@export var max_units_alive: int = 4

@onready var team: Team = $Team
@onready var unit_container = $UnitContainer
@onready var respawn_timer: Timer = $RespawnTimer

var target_base: CapturableBase = null
var capturable_bases: Array = []
var respawn_points: Array = []
var next_spawn_to_use: int = 0


func initialize(capturable_bases: Array, respawn_points: Array):
	if capturable_bases.size() == 0 or respawn_points.size() == 0 or unit_scene == null:
		push_error("forgot to properly initialize map AI")
		return
	team.team = team_name
	
	self.respawn_points = respawn_points
	for respawn in respawn_points:
		spawn_unit(respawn.global_position)
	self.capturable_bases = capturable_bases
	
	for base in capturable_bases:
		(base as CapturableBase).base_captured.connect(handle_base_captured)
	
	check_for_capturable_bases()


func handle_base_captured(_new_team: Team.TeamName):
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
		if team.team != base.team.team:
			print("Assigning team %d to capture base %d" % [team.team, i])
			return base
	return null


func assign_next_capturable_base_to_units():
	for unit in unit_container.get_children():
		set_unit_ai_advance_to_target_base(unit)


func spawn_unit(spawn_location: Vector2):
	var unit_instance = unit_scene.instantiate() as Actor
	unit_instance.global_position = spawn_location
	unit_instance.died.connect(handle_unit_death)
	unit_container.add_child(unit_instance)
	
	# 必须在 add_child() 后，否则 ai 还没初始化
	set_unit_ai_advance_to_target_base(unit_instance)


func set_unit_ai_advance_to_target_base(unit: Actor):
	if target_base != null:
		var ai: AI = unit.ai
		ai.next_base_position = target_base.global_position
		ai.set_state(AI.State.ADVANCE)


func handle_unit_death():
	if respawn_timer.is_stopped() and unit_container.get_children().size() < max_units_alive:
		respawn_timer.start()


func _on_respawn_timer_timeout() -> void:
	var respawn = respawn_points[next_spawn_to_use]
	spawn_unit(respawn.global_position)
	next_spawn_to_use += 1
	next_spawn_to_use %= respawn_points.size()
	if unit_container.get_children().size() < max_units_alive:
		respawn_timer.start()
