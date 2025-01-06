extends CharacterBody3D

@export var look_sensitivity: float = 0.006
@export var controller_look_sensitivity := 0.05

@export var jump_velocity := 6.0
@export var auto_bhop := true

const HEADBOB_MOVE_AMOUNT = 0.06
const HEADBOB_FREQUENCY = 2.4

var headbob_time := 0.0

# 地面移动设置
@export var walk_speed := 7.0
@export var sprint_speed := 8.5
@export var ground_accel := 14.0 # 地面加速度
@export var ground_decel := 10.0 # 地面减速度
@export var ground_friction := 6.0 # 地面摩擦

# 空中移动设置。需要调整这些来使得感觉 dialed in
@export var air_cap := 0.85 # Can surf steeper ramps if this is higher, makes it easier to stick and bhop
@export var air_accel := 800.0 # 空中加速度
@export var air_move_speed := 500.0

var wish_dir := Vector3.ZERO
var cam_aligned_wish_dir := Vector3.ZERO

var noclip_speed_mult := 3.0
var noclip := false

const MAX_STEP_HEIGHT = 0.5
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF


func _ready() -> void:
	for child: VisualInstance3D in %WorldModel.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # mouse_mode 的 setter
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * look_sensitivity)
			%Camera3D.rotate_x(-event.relative.y * look_sensitivity)
			%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# 滚轮调整 noclip 速度乘数
	if event is InputEventMouseButton and event.is_pressed():
		var e = event as InputEventMouseButton
		if e.button_index == MOUSE_BUTTON_WHEEL_UP:
			noclip_speed_mult = min(100.0, noclip_speed_mult * 1.1)
		elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			noclip_speed_mult = max(0.1, noclip_speed_mult * 0.9)


func _process(delta: float) -> void:
	handle_controller_look_input(delta)


var _saved_camera_global_pos = null

func save_camera_pos_for_smoothing():
	if _saved_camera_global_pos == null:
		_saved_camera_global_pos = %CameraSmooth.global_position


func slide_camera_smooth_back_to_origin(delta):
	if _saved_camera_global_pos == null:
		return
	%CameraSmooth.global_position.y = _saved_camera_global_pos.y
	%CameraSmooth.position.y = clampf(%CameraSmooth.position.y, -0.7, 0.7) # clamp 防止被传送
	var move_amount = max(self.velocity.length() * delta, walk_speed / 2 * delta)
	%CameraSmooth.position.y = move_toward(%CameraSmooth.position.y, 0.0, move_amount)
	_saved_camera_global_pos = %CameraSmooth.global_position
	if %CameraSmooth.position.y == 0:
		_saved_camera_global_pos = null # 停止平滑相机


func snap_down_to_stairs_check() -> void:
	var did_snap := false
	var floor_below: bool = %StairsBelowRayCast3D.is_colliding() \
		and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_on_floor() and velocity.y <= 0 \
			and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if run_body_test_motion(self.global_transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result):
			save_camera_pos_for_smoothing()
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap


func snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame:
		return false
	var expected_move_motion = self.velocity * Vector3(1, 0, 1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# 运行一个稍微高于我们期待移动到的，朝向地板的位置的 body_test_motion 
	# 我们给了一些上方的净空区域来确保玩家有足够的空间
	# 如果它碰到一个 step <= MAX_STEP_HEIGHT，我们可以传送玩家到台阶上
	# 同时进行他本打算进行的向前移动
	var down_check_result = PhysicsTestMotionResult3D.new()
	if run_body_test_motion(step_pos_with_clearance, Vector3(0, -MAX_STEP_HEIGHT * 2, 0), down_check_result) \
			and (down_check_result.get_collider() is StaticBody3D or down_check_result.get_collider() is CSGShape3D):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# 注意我放入了 step_height <= 0.01，因为我注意到它防止了一些物理抖动
		# 0.02 会变得试验（trial）和错误。太大并且有时卡在台阶上。太小则会在跑上天花板时抖动
		# 无论如何，普通角色控制器（jolt 以及默认）看上去能够处理 0.1 的台阶
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 \
				or (down_check_result.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT:
			return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_collision_point() \
			+ Vector3(0, MAX_STEP_HEIGHT, 0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			save_camera_pos_for_smoothing()
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false


func handle_noclip(delta) -> bool:
	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		noclip = !noclip
		noclip_speed_mult = 3.0
	
	$CollisionShape3D.disabled = noclip # 相当于 self.get_node("CollisionShape3D")
	
	if not noclip:
		return false
	
	var speed = get_move_speed() * noclip_speed_mult
	if Input.is_action_just_pressed("sprint"):
		speed *= 3.0
	self.velocity = cam_aligned_wish_dir * speed # Vector3.ZERO # Gmod 风格，当你使用 noclip 飞行时
	global_position += self.velocity * delta
	return true


var _cur_controller_look = Vector2()

func handle_controller_look_input(delta):
	var target_look = \
		Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up") \
			.normalized()
	if target_look.length() < _cur_controller_look.length():
		_cur_controller_look = target_look
	else:
		_cur_controller_look = _cur_controller_look.lerp(target_look, 5.0 * delta)
	
	rotate_y(-_cur_controller_look.x * controller_look_sensitivity) # 左右转
	%Camera3D.rotate_x(_cur_controller_look.y * controller_look_sensitivity) # 上下看
	%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # 钳制上下旋转


func _physics_process(delta: float) -> void:
	if is_on_floor():
		_last_frame_was_on_floor = Engine.get_physics_frames()
	
	var input_dir = \
		Input.get_vector("move_left", "move_right", "move_forward", "move_backward") \
			.normalized()
	# 取决于你想让角色面对的方向，你可能需要对 input_dir 取反
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	cam_aligned_wish_dir = %Camera3D.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	
	if not handle_noclip(delta):
		if is_on_floor() or _snapped_to_stairs_last_frame:
			if Input.is_action_just_pressed("jump") \
					or (auto_bhop and Input.is_action_pressed("jump")):
				self.velocity.y = jump_velocity
			handle_ground_physics(delta)
		else:
			handle_air_physics(delta)
		
		if not snap_up_stairs_check(delta):
			# 因为 snap_up_stairs_check 手动移动 body，不要调用 move_and_slide
			# 这将运行正常，因为我们通过 body_test_motion 确保了它不与除它移动上的台阶外的任何物体碰撞
			move_and_slide()
			snap_down_to_stairs_check()
	
	slide_camera_smooth_back_to_origin(delta)


func clip_velocity(normal: Vector3, overbounce: float, delta: float) -> void:
	# 当 strafing into 墙壁时, + gravity，速度将指向法线的反方向
	# 所以通过这个代码，我们将 back up and off the wall，取消我们的 strafe + gravity，允许冲浪
	var backoff := self.velocity.dot(normal) * overbounce
	# 不在原始配置（recipe）中。
	# 可能因为循环的顺序，在原始的起源引擎，它不应该存在速度能离平面很远很远但同时碰撞的情况。
	# 没有这行的话，可能会卡在天花板上
	if backoff >= 0: return
	
	var change := normal * backoff
	self.velocity -= change
	
	# 第二次迭代来确保移动不穿过平面
	# 不确定为什么这是必须的，但它在原始配置中，所以保留它
	var adjust := self.velocity.dot(normal)
	if adjust < 0.0:
		self.velocity -= normal * adjust


func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle


func run_body_test_motion(from: Transform3D, motion: Vector3, result = null) -> bool:
	if not result:
		result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)


func handle_air_physics(delta) -> void:
	self.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	# 经典的实战检验过的和粉丝最喜欢的起源/Quake 空中移动配置
	# 通过这个，CS:S 玩家会感觉他们游戏直觉 kick in
	var cur_speed_in_wish_air = self.velocity.dot(wish_dir)
	# 想要的速度 （如果 wish_dir > 0 长度）限制在 air_cap 下
	var capped_speed = min((air_move_speed * wish_dir).length(), air_cap)
	# 还有多少才能获得玩家希望的速度（在新的 dir 上）
	# 注意到这允许无限速度。如果 wish_dir 是垂直的，我们一直需要增加速度，而无论我们已经多快
	# 这是允许 CS:S 和 Quake 中的 bhop 之类东西的原因
	# 也发生在仅仅想给空中移动和响应提供一些好感觉时
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_air
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta # 经常加上这个
		accel_speed = min(accel_speed, add_speed_till_cap) # 去掉也能工作，但这里坚持用这个配置
		self.velocity += accel_speed * wish_dir
	
	if is_on_wall():
		# 这个漂浮模式可以在冲浪时表现更好，减少抖动
		# 这些代码有点取巧。将在空中切换漂浮模式
		# 在漂浮模式中，is_on_floor() 将永远不被触发，取而代之的是 is_on_wall()
		if is_surface_too_steep(get_wall_normal()):
			self.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			self.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		clip_velocity(get_wall_normal(), 1, delta) # 允许冲浪（surf）


func handle_ground_physics(delta) -> void:
	var speed = get_move_speed()
	# 和空中移动类似。地面存在加速和摩擦
	var cur_speed_in_wish_dir = self.velocity.dot(wish_dir)
	var add_speed_till_cap = speed - cur_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = ground_accel * delta * speed
		accel_speed = min(accel_speed, add_speed_till_cap)
		self.velocity += accel_speed * wish_dir
	
	# 应用摩擦力
	var control = max(self.velocity.length(), ground_decel)
	var drop = control * ground_friction * delta
	var new_speed = max(self.velocity.length() - drop, 0.0)
	if self.velocity.length() > 0:
		new_speed /= self.velocity.length()
	self.velocity *= new_speed
	
	headbob_effect(delta)


func get_move_speed() -> float:
	return sprint_speed if Input.is_action_pressed("sprint") else walk_speed


func headbob_effect(delta):
	headbob_time += delta * self.velocity.length()
	%Camera3D.transform.origin = Vector3(
		cos(headbob_time * HEADBOB_FREQUENCY * 0.5) * HEADBOB_MOVE_AMOUNT,
		sin(headbob_time * HEADBOB_FREQUENCY) * HEADBOB_MOVE_AMOUNT,
		0
	)
