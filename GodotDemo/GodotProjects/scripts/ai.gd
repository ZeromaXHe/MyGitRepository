extends Node2D
class_name AI

signal state_changed(state: State)

enum State {
	PATROL,
	ENGAGE,
	ADVANCE,
}

@export var patrol_range: int = 200

@onready var patrol_timer: Timer = $PatrolTimer

var state: State = -1:
	set = set_state
var actor: Actor = null
var target: CharacterBody2D = null
var weapon: Weapon = null
var team: Team.TeamName = -1

# 巡逻状态使用
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false

# 前进状态使用
var next_base: Vector2 = Vector2.ZERO


func _ready():
	set_state(State.PATROL)

func _physics_process(_delta):
	match state:
		State.PATROL:
			if not patrol_location_reached:
				# 4.1 中的 move_and_slide 不需要传参了，直接根据 velocity 移动
				actor.rotate_toward(patrol_location)
				actor.velocity_toward(patrol_location)
				actor.move_and_slide()
				if actor.has_reached_position(patrol_location):
					patrol_location_reached = true
					actor.velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target != null and weapon != null:
				var angle_to_target = actor.rotate_toward(target.global_position)
#				print("sin: ", sin(0.5 * (actor.rotation - angle_to_target)))
				
				# lerp_angle 貌似会让 actor.rotation 超过上限 PI 和下限 -PI
				# 所以这里用 sin(0.5x) 替代 x 来实现原教程类似的效果
				# 使得目标进入一定角度时开枪
				if abs(sin(0.5 * (actor.rotation - angle_to_target))) < 0.08:
					weapon.shoot()
			else:
				print("engaged, but no weapon/target found")
		State.ADVANCE:
			if actor.has_reached_position(next_base):
				set_state(State.PATROL)
			else:
				actor.velocity_toward(next_base)
				actor.rotate_toward(next_base)
				actor.move_and_slide()
		_:
			print("Error: a unexpected state")


func initialize(actor: CharacterBody2D, weapon: Weapon, team: Team.TeamName):
	self.actor = actor
	self.weapon = weapon
	self.team = team
	
	weapon.weapon_out_of_ammo.connect(handle_reload)


func set_state(new_state: State):
	if new_state == state:
		return

	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	elif new_state == State.ADVANCE:
		if actor.has_reached_position(next_base):
			set_state(State.PATROL)

	state = new_state
	state_changed.emit(new_state)


func handle_reload():
	weapon.start_reload()


func _on_detection_zone_body_entered(body: Node):
	print("detected body entered!")
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body


func _on_detection_zone_body_exited(body):
	if target and body == target:
		set_state(State.ADVANCE)
		target = null


func _on_patrol_timer_timeout():
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
