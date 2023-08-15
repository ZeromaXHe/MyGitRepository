extends Node2D
class_name AI

enum State {
	IDLE,
	PATROL,
	ENGAGE,
	ADVANCE,
	CAPTURING,
}

@export var patrol_range: int = 200

@onready var patrol_timer: Timer = $PatrolTimer
@onready var detection_zone: Area2D = $DetectionZone
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var state: State = State.IDLE:
	set = set_state
var actor: Actor = null
var targets: Array[Actor] = []

# 巡逻状态使用
var origin: Vector2 = Vector2.ZERO

# 前进状态使用
var bases: Array = []
var advancing_base_idx: int = -1


func _ready():
	set_state(State.PATROL)
	
	# 导航相关的配置
	navigation_agent.path_desired_distance = 5.0
	navigation_agent.target_desired_distance = 10.0
	# 空闲时候调用，防止阻塞 _ready()
	actor_setup.call_deferred()


func actor_setup():
	# 等待第一个物理帧，使得 NavigationServer 可以同步.
	await get_tree().physics_frame

	navigation_agent.max_speed = actor.speed
	# 现在导航地图不是空了，设置移动目标（初始化时先原地不动）
	set_navigation_target(actor.global_position)


func init_bases(new_bases: Array):
	bases.append_array(new_bases)
	set_state(State.ADVANCE)


func set_navigation_target(navigation_target: Vector2):
	navigation_agent.target_position = navigation_target


func refresh_targets():
	targets.clear()
	for body in detection_zone.get_overlapping_bodies():
		_on_detection_zone_body_entered(body)


func _physics_process(_delta):
	# AI 角色死亡时不进行处理
	if actor.health.hp == 0:
		return
	if state != State.ENGAGE and targets.size() > 0:
		for target in targets:
			if actor.can_shoot(target):
				set_state(State.ENGAGE)
				return
	match state:
		State.PATROL:
			if not navigation_agent.is_navigation_finished():
				navigation_move()
			else:
				actor.velocity = Vector2.ZERO
			
			if patrol_timer.is_stopped():
				# 防止重复启动巡逻计时器
				patrol_timer.start()
		State.ENGAGE:
			if targets.size() > 0:
				engage_targets()
			else:
				printerr("engaged, but no target found")
				set_state(State.ADVANCE)
		State.ADVANCE:
			if navigation_agent.is_navigation_finished():
				set_state(State.PATROL)
			else:
				navigation_move()
		_:
			printerr("Error: a unexpected state")


func engage_targets():
	while targets.size() > 0 and targets[0].health.hp == 0:
		targets.pop_front()
	if targets.size() == 0:
		# 所有敌人均被击杀，继续前进
		set_state(State.ADVANCE)
		return
	for target in targets:
		if not actor.can_shoot(target):
			continue
		var angle_to_target = actor.rotate_toward(target.global_position)
		# print("sin: ", sin(0.5 * (actor.rotation - angle_to_target)))
		
		# lerp_angle 貌似会让 actor.rotation 超过上限 PI 和下限 -PI
		# 所以这里用 sin(0.5x) 替代 x 来实现原教程类似的效果
		# 使得目标进入一定角度时开枪
		if abs(sin(0.5 * (actor.rotation - angle_to_target))) < 0.08:
			actor.weapon_manager.shoot()
		return
	# 走到这里的逻辑，那说明没有找到可以射击的目标，那就继续前进
	print(actor.name, " has no shootable target")
	set_state(State.ADVANCE)


func navigation_move():
	var next_position: Vector2 = navigation_agent.get_next_path_position()
	actor.rotate_toward(next_position)
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(actor.velocity_toward(next_position))
	else:
		actor.velocity_toward(next_position)
		# 4.1 中的 move_and_slide 不需要传参了，直接根据 velocity 移动
		actor.move_and_slide()


func initialize(actor: Actor):
	self.actor = actor


func handle_base_captured(base: CapturableBase):
	# 如果 AI 当前正在前往的基地已经被友方占领，选择一个新的基地作为目标
	if actor.health.hp > 0 and state == State.ADVANCE \
			and bases[advancing_base_idx] == base \
			and base.team.side == actor.team.side:
		choose_new_advancing_base()


func choose_new_advancing_base():
	var target_bases = bases.filter(func(b): return b.team.side != actor.team.side)
	print(actor.name, " choose advance, bases: ", bases.size(), " target_bases: ", target_bases.size())
	# 没有可供占领的基地了，开始巡逻
	if target_bases.size() == 0:
		set_state(State.PATROL)
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


func set_state(new_state: State):
	if new_state == state:
		return

	if new_state == State.PATROL:
		patrol_timer.start()
		if origin != global_position:
			set_navigation_target(global_position)
			origin = global_position
	else:
		patrol_timer.stop()
	
	# 因为 choose_new_advancing_base() 中可能改变状态，所以这里先设值
	state = new_state
	
	if new_state == State.ADVANCE:
		choose_new_advancing_base()


func _on_detection_zone_body_entered(body: Node):
	if body.has_method("get_team_side") and body.get_team_side() != actor.team.side:
		var shootable = actor.can_shoot(body)
		print(actor.name, " find a target, shootable: ", shootable)
		targets.append(body as Actor)
		if shootable:
			set_state(State.ENGAGE)


func _on_detection_zone_body_exited(body):
	if not body.has_method("get_team_side") or body.get_team_side() == actor.team.side:
		return
	var idx = targets.find(body)
	if idx == -1:
		printerr(actor.name, " target not in array, but exited zone")
		return
	targets.remove_at(idx)
	if targets.size() == 0:
		set_state(State.ADVANCE)


func _on_patrol_timer_timeout():
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	set_navigation_target(Vector2(random_x, random_y) + origin)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	actor.velocity = safe_velocity
	actor.move_and_slide()
