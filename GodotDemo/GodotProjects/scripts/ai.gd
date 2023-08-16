extends Node2D
class_name AI


@export var patrol_range: int = 200

@onready var patrol_timer: Timer = $PatrolTimer
@onready var detection_zone: Area2D = $DetectionZone
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var actor: Actor = null
var targets: Array[Actor] = []

# 基于类继承关系的状态模式实现状态机
static var AI_STATE_ADVANCE: AiStateAdvance = AiStateAdvance.new()
static var AI_STATE_ENGAGE: AiStateEngage = AiStateEngage.new()
static var AI_STATE_IDLE: AiStateIdle = AiStateIdle.new()
static var AI_STATE_PATROL: AiStatePatrol = AiStatePatrol.new()
static var AI_STATE_DEAD: AiStateDead = AiStateDead.new()

var ai_state: AiState = AI_STATE_IDLE:
	set = set_ai_state

# 巡逻状态使用
var origin: Vector2 = Vector2.ZERO

# 前进状态使用
var bases: Array = []
var advancing_base_idx: int = -1


func _ready():
	# 导航相关的配置
	navigation_agent.path_desired_distance = 5.0
	navigation_agent.target_desired_distance = 10.0
	# 空闲时候调用，防止阻塞 _ready()
	actor_setup.call_deferred()


func _physics_process(_delta):
	# AI 角色死亡时不进行处理
	if actor.health.hp == 0:
		return

	if not ai_state.update_state(self):
		ai_state.control_actor(self)


func actor_setup():
	# 等待第一个物理帧，使得 NavigationServer 可以同步.
	await get_tree().physics_frame

	navigation_agent.max_speed = actor.speed
	# 现在导航地图不是空了，设置移动目标（初始化时先原地不动）
	set_navigation_target(actor.global_position)


func init_bases(new_bases: Array):
	bases.append_array(new_bases)


func set_navigation_target(navigation_target: Vector2):
	navigation_agent.target_position = navigation_target


func refresh_targets():
	targets.clear()
	for body in detection_zone.get_overlapping_bodies():
		_on_detection_zone_body_entered(body)


func exist_shootable_target() -> bool:
	if targets.size() == 0:
		return false
	for target in targets:
		if actor.can_shoot(target):
			return true
	return false


func initialize(actor: Actor):
	self.actor = actor


func handle_base_captured(base: CapturableBase):
	# 如果 AI 当前正在前往的基地已经被友方占领，选择一个新的基地作为目标
	if actor.health.hp > 0 and ai_state == AI_STATE_ADVANCE \
			and bases[advancing_base_idx] == base \
			and base.team.side == actor.team.side:
		choose_new_advancing_base()


func choose_new_advancing_base():
	var target_bases = bases.filter(func(b): return b.team.side != actor.team.side)
#	print(actor.name, " choose advance, bases: ", bases.size(), " target_bases: ", target_bases.size())
	# 没有可供占领的基地了，开始巡逻
	if target_bases.size() == 0:
		set_ai_state(AI_STATE_PATROL)
	else:
		# 按距离排序
		target_bases.sort_custom(func(a, b): actor.global_position.distance_to(a.global_position) < \
				actor.global_position.distance_to(b.global_position))
		# 默认找最近的基地作为目标
		var target_base = target_bases[0]
		if target_bases.size() > 1 and randf_range(0, 1) < 0.3:
			# 40% 的概率去其他基地点找点乐子
			target_base = target_bases[randi_range(1, target_bases.size() - 1)]
		advancing_base_idx = bases.find(target_base)
		# 防止第一次初始化的时候阻塞
		advance_to.call_deferred(target_base.global_position)


## 需要等待下一个物理循环，否则导航可能设置不上？
func advance_to(global_posi: Vector2):
	if get_tree() == null:
		printerr(actor.name, " not in scene tree!")
		return
	await get_tree().physics_frame
	# 更新前进目标
	set_navigation_target(global_posi)


func set_ai_state(new_ai_state: AiState):
	if new_ai_state == ai_state:
		return

	if new_ai_state == AI_STATE_PATROL:
		patrol_timer.start()
		if origin != global_position:
			set_navigation_target(global_position)
			origin = global_position
	else:
		patrol_timer.stop()
	
	if ai_state == AI_STATE_DEAD:
		# 刷新目标敌人
		refresh_targets()
	
	if new_ai_state == AI_STATE_DEAD:
		targets.clear()
	
	# 因为 choose_new_advancing_base() 中可能改变状态，所以这里先设值
	ai_state = new_ai_state
	
	if new_ai_state == AI_STATE_ADVANCE:
		choose_new_advancing_base()


func _on_detection_zone_body_entered(body: Node):
	if body.has_method("get_team_side") and body.get_team_side() != actor.team.side:
		var shootable = actor.can_shoot(body)
		print(actor.name, " find a target, shootable: ", shootable)
		targets.append(body as Actor)


func _on_detection_zone_body_exited(body):
	if not body.has_method("get_team_side") or body.get_team_side() == actor.team.side:
		return
	var idx = targets.find(body)
	if idx == -1:
		printerr(actor.name, " target not in array, but exited zone")
		return
	targets.remove_at(idx)


func _on_patrol_timer_timeout():
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	set_navigation_target(Vector2(random_x, random_y) + origin)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	actor.velocity = safe_velocity
	actor.move_and_slide()
