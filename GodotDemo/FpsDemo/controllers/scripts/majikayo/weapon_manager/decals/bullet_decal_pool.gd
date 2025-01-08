class_name BulletDecalPool

const MAX_BULLET_DECALS = 1000
static var decal_pool := []
static var decal_scene: PackedScene = preload("res://controllers/scripts/majikayo/weapon_manager/decals/bullet_decal.tscn")

static func spawn_bullet_decal(global_pos: Vector3, normal: Vector3, parent: Node3D,
		bullet_basis: Basis, texture_override = null):
	var decal_instance: Decal
	if len(decal_pool) >= MAX_BULLET_DECALS and is_instance_valid(decal_pool[0]):
		decal_instance = decal_pool.pop_front()
		decal_pool.push_back(decal_instance)
		decal_instance.reparent(parent)
	else:
		decal_instance = decal_scene.instantiate()
		parent.add_child(decal_instance)
		decal_pool.push_back(decal_instance)
	
	# 如果需要，则清理无效的。父节点可能已经 .queue_free() 了
	if not is_instance_valid(decal_pool[0]):
		decal_pool.pop_front()
	# 为处理那些像水平刀划贴花的，朝向玩家旋转贴花
	decal_instance.global_transform = Transform3D(bullet_basis, global_pos) \
		* Transform3D(Basis().rotated(Vector3.RIGHT, deg_to_rad(90)), Vector3())
	# 对齐表面
	decal_instance.global_basis = Basis(Quaternion(decal_instance.global_basis.y, normal)) \
		* decal_instance.global_basis
	decal_instance.get_node("GPUParticles3D").emitting = true
	
	if texture_override is Texture2D:
		decal_instance.texture_albedo = texture_override
