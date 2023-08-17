extends CharacterBody2D
class_name Actor


const night_battle_actor_material: Material = preload("res://styles/night_battle_actor_matrial.tres")

@export var speed: int = 200

@onready var health: Health = $Health
@onready var ai: AI = $AI
@onready var weapon_manager: WeaponManager = $WeaponManager
@onready var team: Team = $Team
@onready var actor_ui_rmt_txfm: RemoteTransform2D = $ActorUiRmtTxfm2D
@onready var body_img: Sprite2D = $BodyImg

var name_label_node2d: Node2D = null


func _ready():
	# 玩家是没有 ai 的
	if ai != null:
		ai.initialize(self)
	weapon_manager.initialize(self)
	
	if GlobalMediator.night_battle:
		var light: PointLight2D = $BodyImg/PointLight2D
		if light != null:
			light.visible = true
		body_img.material = night_battle_actor_material


func is_player() -> bool:
	return team.character == Team.Character.PLAYER


func can_shoot(target: Actor) -> bool:
	if GlobalMediator.ai_dont_shoot:
		return false
	var space_state = get_world_2d().direct_space_state
	# 使用全局坐标
	var query = PhysicsRayQueryParameters2D.create(global_position, target.global_position)
	var result = space_state.intersect_ray(query)
	# 目前 Actor 半径大概在 25 左右，如果碰撞点在范围外，说明中间有碰撞体
	# FIXME: 之后应该用枪口射线去判断才对
	return not result.is_empty() and result.position.distance_to(target.global_position) < 30


func respawn(respawn_point: Node2D):
	global_position = respawn_point.global_position
	# 重置血量和弹药
	health.hp = health.max_health
	weapon_manager.reset_to_max_ammo()


func set_name_label_node2d(name_label_node2d: Node2D):
	self.name_label_node2d = name_label_node2d
	self.actor_ui_rmt_txfm.remote_path = name_label_node2d.get_path()


func handle_base_captured(base: CapturableBase):
	if ai != null:
		ai.handle_base_captured(base)


func rotate_toward(location: Vector2) -> float:
	var angle_to_location = global_position \
			.direction_to(location) \
			.angle()
#	print("rot: ", rotation, ", ang: ", angle_to_location)
	# 注意要用 lerp_angle 而不是 lerp
	# 否则 angle_to_location 刚好 PI 到 -PI 的弧度转换的地方会导致敌人反向旋转
	rotation = lerp_angle(rotation, angle_to_location, 0.1)
	return angle_to_location


func velocity_toward(location: Vector2) -> Vector2:
	velocity = global_position.direction_to(location) * speed
	return velocity


func has_reached_position(location: Vector2) -> bool:
	return global_position.distance_to(location) < 5


func get_team_side() -> Team.Side:
	return team.side


func handle_hit(bullet: Bullet):
	health.hp -= bullet.damage
	print(name, " hit! ", health.hp)
	GlobalSignals.bullet_hit_actor.emit(self, bullet.shooter, bullet.global_rotation, bullet.global_position)
	if health.hp <= 0:
		die(bullet)


func die(bullet: Bullet):
	GlobalSignals.actor_killed.emit(self, bullet.shooter)
	# 将 Actor 和对应的名字标签从父节点中移除，而不是 queue_free()
	# 作为游荡于场景树之外的引用，略微感觉有点风险。
	# 目前分别在 map_ai 的 actor_map 和 actor 的 name_label_node2d 保留引用
	if (name_label_node2d != null):
		name_label_node2d.get_parent().remove_child(name_label_node2d)
	self.get_parent().remove_child(self)
