extends Node2D
class_name AI

signal state_changed(state: State)

enum State {
	IDLE,
	PATROL,
	ENGAGE,
	ADVANCE,
}

@export var patrol_range: int = 200

@onready var patrol_timer: Timer = $PatrolTimer
@onready var detection_zone: Area2D = $DetectionZone
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var state: State = State.IDLE:
	set = set_state
var actor: Actor = null
var target: CharacterBody2D = null

# 巡逻状态使用
var origin: Vector2 = Vector2.ZERO

# 前进状态使用
var next_base_position: Vector2 = Vector2.ZERO


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


func set_navigation_target(navigation_target: Vector2):
	navigation_agent.target_position = navigation_target


func _physics_process(_delta):
	# ai 的物理循环逻辑
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
			if target != null and actor.weapon_manager.current_weapon != null:
				var angle_to_target = actor.rotate_toward(target.global_position)
#				print("sin: ", sin(0.5 * (actor.rotation - angle_to_target)))
				
				# lerp_angle 貌似会让 actor.rotation 超过上限 PI 和下限 -PI
				# 所以这里用 sin(0.5x) 替代 x 来实现原教程类似的效果
				# 使得目标进入一定角度时开枪
				if abs(sin(0.5 * (actor.rotation - angle_to_target))) < 0.08:
					actor.weapon_manager.shoot()
			else:
				print("engaged, but no weapon/target found")
		State.ADVANCE:
			if navigation_agent.is_navigation_finished():
				set_state(State.PATROL)
			else:
				navigation_move()
		_:
			print("Error: a unexpected state")


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


## 需要等待下一个物理循环，否则导航可能设置不上？
func advance_to(target_base: CapturableBase):
	await get_tree().physics_frame

	next_base_position = target_base.global_position
	# 避免在前进状态下再次收到新的前进指令时不更新目标
	set_navigation_target(next_base_position)
	set_state(State.ADVANCE)


func set_state(new_state: State):
	if new_state == state:
		return

	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		set_navigation_target(origin)
	else:
		patrol_timer.stop()
		
	if new_state == State.ADVANCE:
		set_navigation_target(next_base_position)
	
	state = new_state
	state_changed.emit(new_state)


func _on_detection_zone_body_entered(body: Node):
	if body.has_method("get_team_side") and body.get_team_side() != actor.team.side:
		set_state(State.ENGAGE)
		target = body


func _on_detection_zone_body_exited(body):
	if target and body == target:
		set_state(State.ADVANCE)
		target = null


func _on_patrol_timer_timeout():
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	set_navigation_target(Vector2(random_x, random_y) + origin)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	actor.velocity = safe_velocity
	actor.move_and_slide()
