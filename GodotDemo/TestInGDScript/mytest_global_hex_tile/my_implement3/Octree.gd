class_name Octree
extends RefCounted


const MAX_DEPTH: int = 5
const MAX_POINTS_PER_LEAF = 6

# 后下左边界点
var back_bottom_left: Vector3
# 前上右边界点
var front_top_right: Vector3
var center: Vector3
var size: Vector3
var points: Dictionary = {}
var depth: int = 0
var split: bool = false

# 现在命名是按 Unity 版的叫法，实际 Godot 里面 front 和 back 和命名是反的
# 后下左 back bottom left
var bblOctree: Octree
# 前下左 front bottom left
var fblOctree: Octree
# 后上左 back top left
var btlOctree: Octree
# 前上左 back top left
var ftlOctree: Octree
# 后下右 back bottom right
var bbrOctree: Octree
# 前下右 front bottom right
var fbrOctree: Octree
# 后上右 back top right
var btrOctree: Octree
# 前上右 back top right
var ftrOctree: Octree


func _init(back_bottom_left: Vector3, front_top_right: Vector3, depth: int = 0) -> void:
	self.front_top_right = front_top_right
	self.back_bottom_left = back_bottom_left
	self.center = (front_top_right + back_bottom_left) / 2.0
	self.size = front_top_right - back_bottom_left
	
	self.depth = depth


func do_split() -> void:
	split = true
	# 现在命名是按 Unity 版的叫法，实际 Godot 里面 front 和 back 和命名是反的
	bblOctree = Octree.new(back_bottom_left, center, depth + 1)
	fblOctree = Octree.new(back_bottom_left + Vector3.BACK * size.z / 2, \
		center + Vector3.BACK * size.z / 2, depth + 1)
	btlOctree = Octree.new(back_bottom_left + Vector3.UP * size.y / 2, \
		center + Vector3.UP * size.y / 2, depth + 1)
	ftlOctree = Octree.new(back_bottom_left + Vector3.UP * size.y / 2 + Vector3.BACK * size.z / 2, \
		center + Vector3.UP * size.x / 2 + Vector3.BACK * size.z / 2, depth + 1)
	bbrOctree = Octree.new(back_bottom_left + Vector3.RIGHT * size.x / 2, \
		center + Vector3.RIGHT * size.x / 2, depth + 1)
	fbrOctree = Octree.new(back_bottom_left + Vector3.BACK * size.z / 2 + Vector3.RIGHT * size.x / 2, \
		center + Vector3.BACK * size.z / 2 + Vector3.RIGHT * size.x / 2, depth + 1)
	btrOctree = Octree.new(back_bottom_left + Vector3.UP * size.y / 2 + Vector3.RIGHT * size.x / 2, \
		center + Vector3.UP * size.y / 2 + Vector3.RIGHT * size.x / 2, depth + 1)
	ftrOctree = Octree.new(back_bottom_left + Vector3.UP * size.y / 2 + Vector3.BACK * size.z / 2 \
		+ Vector3.RIGHT * size.x / 2, center + Vector3.UP * size.y / 2 + Vector3.BACK * size.z / 2 \
		+ Vector3.RIGHT * size.x / 2, depth + 1)
	
	for p_key in points:
		insert_point_internally(p_key, points[p_key])
	
	points.clear()


func insert_point_internally(key, pos: Vector3) -> void:
	if pos.x > center.x: # 右
		if pos.y > center.y: # 上
			if pos.z > center.z: # 前 (这里 Unity 和 Godot 是反的， 是 Godot 的 Back，Unity 的 Front
				ftrOctree.insert_point(key, pos)
			else: # 后 （这里 Unity 和 Godot 是反的， 是 Godot 的 Front，Unity 的 Back）
				btrOctree.insert_point(key, pos)
		else: # 下
			if pos.z > center.z: # 前 (这里 Unity 和 Godot 是反的， 是 Godot 的 Back，Unity 的 Front)
				fbrOctree.insert_point(key, pos)
			else: # 后 （这里 Unity 和 Godot 是反的， 是 Godot 的 Front，Unity 的 Back）
				bbrOctree.insert_point(key, pos)
	else: # 左
		if pos.y > center.y: # 上
			if pos.z > center.z: # 前 (这里 Unity 和 Godot 是反的， 是 Godot 的 Back，Unity 的 Front
				ftlOctree.insert_point(key, pos)
			else: # 后 （这里 Unity 和 Godot 是反的， 是 Godot 的 Front，Unity 的 Back）
				btlOctree.insert_point(key, pos)
		else: # 下
			if pos.z > center.z: # 前 (这里 Unity 和 Godot 是反的， 是 Godot 的 Back，Unity 的 Front
				fblOctree.insert_point(key, pos)
			else: # 后 （这里 Unity 和 Godot 是反的， 是 Godot 的 Front，Unity 的 Back）
				bblOctree.insert_point(key, pos)


func insert_point(key, pos: Vector3) -> void:
	if not split:
		if points.size() < MAX_POINTS_PER_LEAF:
			points[key] = pos
			return
		if depth >= MAX_DEPTH:
			# 不再分割，加入到字典中
			points[key] = pos
			return
		do_split()
	
	insert_point_internally(key, pos)


func get_points(center: Vector3, size: Vector3) -> Array:
	var ret: Array = []
	if not box_intersect_box(center, size, self.center, self.size):
		return ret
	if not split:
		for p_key in points:
			if point_within_box(center, size, points[p_key]):
				ret.append(p_key)
		return ret
	ret.append_array(bblOctree.get_points(center, size))
	ret.append_array(fblOctree.get_points(center, size))
	ret.append_array(btlOctree.get_points(center, size))
	ret.append_array(ftlOctree.get_points(center, size))
	ret.append_array(bbrOctree.get_points(center, size))
	ret.append_array(fbrOctree.get_points(center, size))
	ret.append_array(btrOctree.get_points(center, size))
	ret.append_array(ftrOctree.get_points(center, size))
	return ret


func box_intersect_box(a_center: Vector3, a_size: Vector3, b_center: Vector3, b_size: Vector3) -> bool:
	return a_center.x - a_size.x <= b_center.x + b_size.x \
		and a_center.x + a_size.x >= b_center.x - b_size.x \
		and a_center.y - a_size.y <= b_center.y + b_size.y \
		and a_center.y + a_size.y >= b_center.y - b_size.y \
		and a_center.z - a_size.z <= b_center.z + b_size.z \
		and a_center.z + a_size.z >= b_center.z - b_size.z


func point_within_box(box_center: Vector3, box_size: Vector3, point: Vector3) -> bool:
	return point.x <= box_center.x + box_size.x and point.x >= box_center.x - box_size.x \
		and point.y <= box_center.y + box_size.y and point.y >= box_center.y - box_size.y \
		and point.z <= box_center.z + box_size.z and point.z >= box_center.z - box_size.z
