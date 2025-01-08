extends CharacterBody3D

@export var CAMERA_CONTROLLER: Camera3D

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

@export var swim_up_speed := 10.0
@export var climb_speed := 7.0

@export var health = 100.0
@export var max_health = 100.0

func take_damage(damage: float):
	health -= damage


# 相机选项
enum CameraStyle {
	FIRST_PERSON, THIRD_PERSON_VERTICAL_LOOK, THIRD_PERSON_FREE_LOOK
}
@export var camera_style : CameraStyle = CameraStyle.FIRST_PERSON:
	set(v):
		camera_style = v
		update_camera()

var wish_dir := Vector3.ZERO
var cam_aligned_wish_dir := Vector3.ZERO

const CROUCH_TRANSLATE = 0.7
const CROUCH_JUMP_ADD = CROUCH_TRANSLATE * 0.9 # 乘以 0.9 是因为类起源引擎的摄像机在空中蹲伏时抖动，作为好提示

var is_crouched := false

var noclip_speed_mult := 3.0
var noclip := false

const MAX_STEP_HEIGHT = 0.5
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF

const VIEW_MODEL_LAYER = 9
const WORLD_MODEL_LAYER = 2


func _ready() -> void:
	Global.player = self
	update_view_and_world_model_masks()
	update_camera()


func update_view_and_world_model_masks():
	for child: VisualInstance3D in %WorldModel.find_children("*", "VisualInstance3D", true, false):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(WORLD_MODEL_LAYER, true)
	for child: VisualInstance3D in %ViewModel.find_children("*", "VisualInstance3D", true, false):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(VIEW_MODEL_LAYER, true)
		if child is GeometryInstance3D:
			child.cast_shadow = false
	%Camera3D.set_cull_mask_value(WORLD_MODEL_LAYER, false)
	%ThirdPersonCamera3D.set_cull_mask_value(VIEW_MODEL_LAYER, false)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # mouse_mode 的 setter
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# 我自己加的切换视角按键（教程没有）
		if Input.is_action_just_pressed("change_view"):
			match camera_style:
				CameraStyle.THIRD_PERSON_FREE_LOOK:
					camera_style = CameraStyle.FIRST_PERSON
				CameraStyle.FIRST_PERSON:
					camera_style = CameraStyle.THIRD_PERSON_VERTICAL_LOOK
				CameraStyle.THIRD_PERSON_VERTICAL_LOOK:
					camera_style = CameraStyle.THIRD_PERSON_FREE_LOOK
		
		if event is InputEventMouseMotion:
			if camera_style == CameraStyle.THIRD_PERSON_FREE_LOOK:
				# 在自由视角模式下，旋转摄像机轨道，而不是玩家
				%ThirdPersonCamYaw.rotate_y(-event.relative.x * look_sensitivity)
			else:
				%ThirdPersonCamYaw.rotation.y = 0
				rotate_y(-event.relative.x * look_sensitivity)
			# 第一人称上下看
			%Camera3D.rotate_x(-event.relative.y * look_sensitivity)
			%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			# 第三人称上下看
			%ThirdPersonCamPitch.rotate_x(-event.relative.y * look_sensitivity)
			%ThirdPersonCamPitch.rotation.x = \
				clamp(%ThirdPersonCamPitch.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# 滚轮调整 noclip 速度乘数
	if event is InputEventMouseButton and event.is_pressed():
		var e = event as InputEventMouseButton
		if e.button_index == MOUSE_BUTTON_WHEEL_UP:
			noclip_speed_mult = min(100.0, noclip_speed_mult * 1.1)
		elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			noclip_speed_mult = max(0.1, noclip_speed_mult * 0.9)


func get_active_camera() -> Camera3D:
	if camera_style == CameraStyle.FIRST_PERSON:
		return %Camera3D
	else:
		return %ThirdPersonCamera3D


func update_camera():
	if not is_inside_tree():
		return
	var cameras = [%Camera3D, %ThirdPersonCamera3D]
	if not cameras.any(func(c: Camera3D): return c.current):
		return # 如果没有当前相机，则不要更新相机，可能是在 cutscene cam 或其他的
	get_active_camera().current = true


var target_recoil := Vector2.ZERO
var current_recoil := Vector2.ZERO
const RECOIL_APPLY_SPEED: float = 10.0
const RECOIL_RECOVER_SPEED: float = 7.0

func add_recoil(pitch: float, yaw: float) -> void:
	target_recoil.x += pitch
	target_recoil.y += yaw


func get_current_recoil() -> Vector2:
	return current_recoil


func update_recoil(delta: float) -> void:
	# 慢慢使目标后坐力回到 0.0
	target_recoil = target_recoil.lerp(Vector2.ZERO, RECOIL_RECOVER_SPEED * delta)
	# 慢慢使当前后坐力改变到目标后坐力
	var prev_recoil = current_recoil
	current_recoil = current_recoil.lerp(target_recoil, RECOIL_APPLY_SPEED * delta)
	var recoil_diff = current_recoil - prev_recoil
	# 旋转玩家/相机向着当前后坐力
	rotate_y(recoil_diff.y)
	%Camera3D.rotate_x(recoil_diff.x)
	%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	%ThirdPersonCamPitch.rotation.x = %Camera3D.rotation.x


@onready var animation_tree: AnimationTree = $WorldModel/DesertDroidContainer/AnimationTree

func update_animations():
	animation_tree.is_crouched = is_crouched
	animation_tree.is_in_air = noclip or (not is_on_floor() and not _snapped_to_stairs_last_frame)
	animation_tree.is_sprinting = Input.is_action_pressed("sprint")
	
	var rel_vel = self.global_basis.inverse() * ((self.velocity * Vector3(1, 0, 1)) / get_move_speed())
	var rel_vel_xz = Vector2(rel_vel.x, -rel_vel.z)
	
	if is_crouched:
		animation_tree.set(
			"parameters/AnimationNodeStateMachine/Crouched/CrouchBlendSpace2D/blend_position",
			rel_vel_xz)
	elif Input.is_action_pressed("sprint"):
		animation_tree.set(
			"parameters/AnimationNodeStateMachine/Standing/RunBlendSpace2D/blend_position",
			rel_vel_xz)
	else:
		animation_tree.set(
			"parameters/AnimationNodeStateMachine/Standing/WalkBlendSpace2D/blend_position",
			rel_vel_xz)


func _process(delta: float) -> void:
	handle_controller_look_input(delta)
	var c = get_interactable_component_at_shapecast()
	if c:
		c.hover_cursor(self)
		if Input.is_action_just_pressed("interact"):
			c.interact_with()
	if camera_style == CameraStyle.THIRD_PERSON_FREE_LOOK and wish_dir.length():
		# 如果在自由视角模式，摄像机决定移动方向，而不是角色的方向。所以根据速度修改角色方向
		var add_rotation_y = (-self.global_transform.basis.z) \
			.signed_angle_to(wish_dir.normalized(), Vector3.UP)
		var rot_towards = lerp_angle(self.global_rotation.y,
			self.global_rotation.y + add_rotation_y,
			max(0.1, abs(add_rotation_y / TAU))) - self.global_rotation.y
		self.rotation.y += rot_towards
		%ThirdPersonCamYaw.rotation.y -= rot_towards
	
	update_recoil(delta)
	update_animations()


func get_interactable_component_at_shapecast() -> InteractableComponent:
	for i in %InteractShapeCast3D.get_collision_count():
		# 允许和玩家碰撞
		if i > 0 and %InteractShapeCast3D.get_collider(0) != $".":
			return null
		# 自己加的逻辑，近战击杀敌人的时候，对方刚好销毁的时候会为空，导致报错（教程没有）
		var node = %InteractShapeCast3D.get_collider(i) as Node
		if !node:
			continue
		var c = node.get_node_or_null("InteractableComponent")
		if c is InteractableComponent:
			return c
	return null


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


func push_away_rigid_bodies():
	for i in get_slide_collision_count(): # 居然可以直接 for，不用 range？！
		var c := get_slide_collision(i)
		if !c.get_collider() is RigidBody3D:
			continue
		var rb = c.get_collider() as RigidBody3D
		var push_dir = -c.get_normal()
		# 物体速度需要在推动方向上提高到匹配玩家的速度大小
		var velocity_diff_in_push_dir = self.velocity.dot(push_dir) \
			- rb.linear_velocity.dot(push_dir)
		# 仅仅计算朝向远离角色的推动方向的速度
		velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
		# 比我们质量更大的物体应该更难推动。但推动速度比我们自己还快不合理
		const MY_APPROX_MASS_KG = 80.0
		var mass_ratio = min(1., MY_APPROX_MASS_KG / rb.mass)
		# 别从下方或上方推物体
		push_dir.y = 0
		# 5.0 是个魔法数字，根据你需要调整
		var push_force = mass_ratio * 5.0
		rb.apply_impulse(push_dir * velocity_diff_in_push_dir * push_force,
			c.get_position() - rb.global_position)


func snap_down_to_stairs_check() -> void:
	var did_snap := false
	# 和教程里略微不一样
	# 因为在 move_and_slide 之后调用，_last_frame_was_on_floor 应该仍然是当前帧。
	# 在 move_and_slide 离开楼梯顶部后，在地面上应该为 false。更新 raycast 以防止它还没 ready
	%StairsBelowRayCast3D.force_raycast_update()
	var floor_below: bool = %StairsBelowRayCast3D.is_colliding() \
		and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() == _last_frame_was_on_floor
	if not is_on_floor() and velocity.y <= 0 \
			and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = KinematicCollision3D.new()
		if self.test_move(self.global_transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result):
			save_camera_pos_for_smoothing()
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap


func snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame:
		return false
	# 如果尝试跳跃时不 snap 楼梯，不移动时也不需要检查前方楼梯
	if self.velocity.y > 0 or (self.velocity * Vector3(1, 0, 1)).length() == 0:
		return false
	var expected_move_motion = self.velocity * Vector3(1, 0, 1) * delta
	var step_pos_with_clearance = self.global_transform.translated(
		expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# 运行一个稍微高于我们期待移动到的，朝向地板的位置的 body_test_motion 
	# 我们给了一些上方的净空区域来确保玩家有足够的空间
	# 如果它碰到一个 step <= MAX_STEP_HEIGHT，我们可以传送玩家到台阶上
	# 同时进行他本打算进行的向前移动
	var down_check_result = KinematicCollision3D.new()
	if self.test_move(step_pos_with_clearance, Vector3(0, -MAX_STEP_HEIGHT * 2, 0), down_check_result) \
			and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D")):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# 注意我放入了 step_height <= 0.01，因为我注意到它防止了一些物理抖动
		# 0.02 会变得试验（trial）和错误。太大并且有时卡在台阶上。太小则会在跑上天花板时抖动
		# 无论如何，普通角色控制器（jolt 以及默认）看上去能够处理 0.1 的台阶
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 \
				or (down_check_result.get_position() - self.global_position).y > MAX_STEP_HEIGHT:
			return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_position() \
			+ Vector3(0, MAX_STEP_HEIGHT, 0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() \
				and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			save_camera_pos_for_smoothing()
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false


var _cur_ladder_climbing: Area3D = null

func handle_ladder_physics(delta) -> bool:
	# 保持跟踪是否已经在梯子上。如果之前不是已经在梯子上，检查是否和梯子 area3d 重合
	var was_climbing_ladder := _cur_ladder_climbing and _cur_ladder_climbing.overlaps_body(self)
	if not was_climbing_ladder:
		_cur_ladder_climbing = null
		for ladder: Area3D in get_tree().get_nodes_in_group("ladder_area3d"):
			if ladder.overlaps_body(self):
				_cur_ladder_climbing = ladder
	if _cur_ladder_climbing == null:
		return false
	# 设置变量。这里大多数将取决于玩家的相对梯子的位置/速度/输入
	var ladder_gtransform: Transform3D = _cur_ladder_climbing.global_transform
	var pos_rel_to_ladder := ladder_gtransform.affine_inverse() * self.global_position
	
	var forward_move := Input.get_action_strength("move_forward")\
		- Input.get_action_strength("move_backward")
	var side_move := Input.get_action_strength("move_right") \
		- Input.get_action_strength("move_left")
	var ladder_forward_move = ladder_gtransform.affine_inverse().basis \
		* get_active_camera().global_transform.basis * Vector3(0, 0, -forward_move)
	var ladder_side_move = ladder_gtransform.affine_inverse().basis \
		* get_active_camera().global_transform.basis * Vector3(side_move, 0, 0)
	# Strafe 速度很简单。只需要取相对于梯子的 x 分量
	var ladder_strafe_vel: float = climb_speed * (ladder_side_move.x + ladder_forward_move.x)
	# 对于攀爬速度，有一些事情需要考虑：
	# 如果直接 strafing into 梯子，向上，如果 strafing away，向下
	var ladder_climb_vel: float = climb_speed * -ladder_side_move.z
	# 当按下向前 & 面向梯子，玩家很可能想向上爬，反之则向下
	# 所以我们将向我们面朝方向来为上下检测偏置 45 度方向（上/下）
	var cam_forward_amount: float = %Camera3D.basis.z.dot(_cur_ladder_climbing.basis.z)
	var up_wish := Vector3.UP.rotated(Vector3.RIGHT, deg_to_rad(-45 * cam_forward_amount)) \
		.dot(ladder_forward_move)
	ladder_climb_vel += climb_speed * up_wish
	
	# 仅仅在向梯子移动时开始攀爬 & 当爬下梯子时防止卡在梯子顶部
	# 尽量尝试在爬梯子时匹配玩家意图
	var should_dismount = false
	if not was_climbing_ladder:
		var mounting_from_top = pos_rel_to_ladder.y > _cur_ladder_climbing.get_node("TopOfLadder").position.y
		if mounting_from_top:
			# 他们应该在尝试达到梯子顶部，或尝试离开梯子
			if ladder_climb_vel > 0:
				should_dismount = true
		else:
			# 如果不是爬上顶部，他们也可以坠落或在地面
			# 在这种情况下，仅在有意识地向梯子移动时爬
			if (ladder_gtransform.affine_inverse().basis * wish_dir).z >= 0:
				should_dismount = true
		# 仅仅在梯子非常近时爬。帮助我们更简单地脱离顶部 & 防止相机抖动
		if abs(pos_rel_to_ladder.z) > 0.1:
			should_dismount = true
	# 让玩家在地面可以走出
	if is_on_floor() and ladder_climb_vel <= 0:
		should_dismount = true
	
	if should_dismount:
		_cur_ladder_climbing = null
		return false
	
	# 允许在梯子中间跳离
	if was_climbing_ladder and Input.is_action_just_pressed("jump"):
		self.velocity = _cur_ladder_climbing.global_transform.basis.z * jump_velocity * 1.5
		_cur_ladder_climbing = null
		return false
	
	self.velocity = ladder_gtransform.basis * Vector3(ladder_strafe_vel, ladder_climb_vel, 0)
	#self.velocity = self.velocity.limit_length(climb_speed) # 不建议取消梯子加速
	# Snap 玩家到梯子上
	pos_rel_to_ladder.z = 0
	self.global_position = ladder_gtransform * pos_rel_to_ladder
	
	move_and_slide()
	return true


# 当玩家在水里时返回 true，这种情况下不要运行正常的空中/地面物理
func handle_water_physics(delta) -> bool:
	if get_tree().get_nodes_in_group("water_area") \
			.all(func(area): return !area.overlaps_body(self)):
		return false
	
	if not is_on_floor():
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * 0.1 * delta
	
	self.velocity += cam_aligned_wish_dir * get_move_speed() * delta
	
	if Input.is_action_pressed("jump"):
		self.velocity.y += swim_up_speed * delta
	
	# 水中速度阻尼
	self.velocity = self.velocity.lerp(Vector3.ZERO, 2 * delta)
	
	return true


@onready var _original_capsule_height = $CollisionShape3D.shape.height

func handle_crouch(delta) -> void:
	var was_crouched_last_frame = is_crouched
	if Input.is_action_pressed("crouch"):
		is_crouched = true
	elif is_crouched and not self.test_move(self.transform, Vector3(0, CROUCH_TRANSLATE, 0)):
		is_crouched = false
	
	# 允许蹲伏来抬高跳跃
	var translate_y_if_possible := 0.0
	if was_crouched_last_frame != is_crouched and not is_on_floor() \
			and not _snapped_to_stairs_last_frame:
		translate_y_if_possible = \
			CROUCH_JUMP_ADD if is_crouched else -CROUCH_JUMP_ADD
	# 确保玩家蹲跳时不要卡在地板/天花板
	if translate_y_if_possible != 0.0:
		var result = KinematicCollision3D.new()
		self.test_move(self.transform, Vector3(0, translate_y_if_possible, 0), result)
		self.position.y += result.get_travel().y
		%Head.position.y -= result.get_travel().y
		%Head.position.y = clampf(%Head.position.y, -CROUCH_TRANSLATE, 0)
	
	%Head.position.y = move_toward(%Head.position.y, -CROUCH_TRANSLATE if is_crouched else 0, 7.0 * delta)
	var shape_height = _original_capsule_height \
		- CROUCH_TRANSLATE if is_crouched else _original_capsule_height
	$CollisionShape3D.shape.height = shape_height
	$CollisionShape3D.position.y = $CollisionShape3D.shape.height / 2


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
	
	if camera_style == CameraStyle.THIRD_PERSON_VERTICAL_LOOK \
			or camera_style == CameraStyle.FIRST_PERSON:
		rotate_y(-_cur_controller_look.x * controller_look_sensitivity) # 左右转
	else:
		%ThirdPersonCamYaw.rotate_y(-_cur_controller_look.x * controller_look_sensitivity) # 左右转
	%Camera3D.rotate_x(_cur_controller_look.y * controller_look_sensitivity) # 上下看
	%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # 钳制上下旋转
	%ThirdPersonCamPitch.rotation.x = %Camera3D.rotation.x


func _physics_process(delta: float) -> void:
	if is_on_floor():
		_last_frame_was_on_floor = Engine.get_physics_frames()
	
	update_camera()
	
	var input_dir = \
		Input.get_vector("move_left", "move_right", "move_forward", "move_backward") \
			.normalized()
	# 取决于你想让角色面对的方向，你可能需要对 input_dir 取反
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	cam_aligned_wish_dir = get_active_camera().global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	if camera_style == CameraStyle.THIRD_PERSON_FREE_LOOK:
		wish_dir = %ThirdPersonCamYaw.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	
	handle_crouch(delta)
	
	if not handle_noclip(delta) and not handle_ladder_physics(delta):
		if not handle_water_physics(delta):
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
			push_away_rigid_bodies() # 在 move_and_slide() 前调用
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
	if is_crouched:
		return walk_speed * 0.8
	return sprint_speed if Input.is_action_pressed("sprint") else walk_speed


func headbob_effect(delta):
	headbob_time += delta * self.velocity.length()
	%Camera3D.transform.origin = Vector3(
		cos(headbob_time * HEADBOB_FREQUENCY * 0.5) * HEADBOB_MOVE_AMOUNT,
		sin(headbob_time * HEADBOB_FREQUENCY) * HEADBOB_MOVE_AMOUNT,
		0
	)
