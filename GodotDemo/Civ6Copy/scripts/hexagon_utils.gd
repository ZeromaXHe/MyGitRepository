## 参考链接：https://www.redblobgames.com/grids/hexagons/
class_name HexagonUtils
extends Node


## 名字和注释里对应行排列(pointy top)的情形，括号里是对应列排列(flat top)的情形
enum Direction {
	RIGHT, # 右 （右下）
	RIGHT_UP, # 右上 （右上）
	LEFT_UP, # 左上 （上）
	LEFT, # 左 （左上）
	LEFT_DOWN, # 左下 （左下）
	RIGHT_DOWN, # 右下 （下）
}


##
#	In a regular hexagon the interior angles are 120°.
#	There are six “wedges”, each an equilateral triangle with 60° angles inside.
#	Each corner is `size` units away from the `center`.
#
#	@param center 中心坐标
#	@param size 角到中心的距离
#	@param i 第几个角
#	@return 角的坐标
##
static func pointy_hex_corner(center: Vector2, size: float, i: int) -> Vector2:
	var angle_deg: float = 60 * i - 30
	var angle_rad: float = deg_to_rad(angle_deg)
	return Vector2(center.x + size * cos(angle_rad), \
			center.y + size * sin(angle_rad))


## =======================================================
#						偏移坐标系
## =======================================================
class OffsetCoord:
	enum Type {
		ALL,
		ODD_R, # TileMap 的 Stacked 其实就是对应这种 odd-r
		EVEN_R,
		ODD_Q,
		EVEN_Q,
	}
	
	static var oddr_direction_differences: Array[Array] = [
		[ # 偶数行
			odd_r(1, 0), odd_r(0, -1), odd_r(-1, -1), # 右, 右上, 左上
			odd_r(-1, 0), odd_r(1, 1), odd_r(0, 1), # 左, 左下, 右下
		],
		[ # 奇数行
			odd_r(1, 0), odd_r(1, -1), odd_r(0, -1), # 右, 右上, 左上
			odd_r(-1, 0), odd_r(0, 1), odd_r(1, 1), # 左, 左下, 右下
		],
	]
	static var evenr_direction_differences: Array[Array] = [
		[ # 偶数行
			even_r(1, 0), even_r(1, -1), even_r(0, -1), # 右, 右上, 左上
			even_r(-1, 0), even_r(0, 1), even_r(1, 1), # 左, 左下, 右下
		],
		[ # 奇数行
			even_r(1, 0), even_r(0, -1), even_r(-1, -1), # 右, 右上, 左上
			even_r(-1, 0), even_r(-1, 1), even_r(0, 1), # 左, 左下, 右下
		],
	]
	static var oddq_direction_differences: Array[Array] = [
		[ # 偶数行
			odd_q(1, 0), odd_q(1, -1), odd_q(0, -1), # 右下, 右上, 上
			odd_q(-1, -1), odd_q(-1, 0), odd_q(0, 1), # 左上, 左下, 下
		],
		[ # 奇数行
			odd_q(1, 1), odd_q(1, 0), odd_q(0, -1), # 右下, 右上, 上
			odd_q(-1, 0), odd_q(-1, 1), odd_q(0, 1), # 左上, 左下, 下
		],
	]
	static var evenq_direction_differences: Array[Array] = [
		[ # 偶数行
			even_q(1, 1), even_q(1, 0), even_q(0, -1), # 右下, 右上, 上
			even_q(-1, 0), even_q(-1, 1), even_q(0, 1), # 左上, 左下, 下
		],
		[ # 奇数行
			even_q(1, 0), even_q(1, -1), even_q(0, -1), # 右下, 右上, 上
			even_q(-1, -1), even_q(-1, 0), even_q(0, 1), # 左上, 左下, 下
		],
	]
	
	var col: int
	var row: int
	var type: Type = Type.ALL
	
	
	func _init(col: int, row: int):
		self.col = col
		self.row = row
	
	
	static func init(col: int, row: int, type: int) -> OffsetCoord:
		var oddr := OffsetCoord.new(col, row)
		oddr.type = type
		return oddr
	
	
	static func odd_r(col: int, row: int) -> OffsetCoord:
		return init(col, row, Type.ODD_R)
	
	
	static func even_r(col: int, row: int) -> OffsetCoord:
		return init(col, row, Type.EVEN_R)
	
	
	static func odd_q(col: int, row: int) -> OffsetCoord:
		return init(col, row, Type.ODD_Q)
	
	
	static func even_q(col: int, row: int) -> OffsetCoord:
		return init(col, row, Type.EVEN_Q)
	
	
	static func oddr_direction_vec(parity: int, direction: Direction) -> OffsetCoord:
		return oddr_direction_differences[parity][direction]
	
	
	static func evenr_direction_vec(parity: int, direction: Direction) -> OffsetCoord:
		return evenr_direction_differences[parity][direction]
	
	
	static func oddq_direction_vec(parity: int, direction: Direction) -> OffsetCoord:
		return oddq_direction_differences[parity][direction]
	
	
	static func evenq_direction_vec(parity: int, direction: Direction) -> OffsetCoord:
		return evenq_direction_differences[parity][direction]
	
	
	func add(vec: OffsetCoord) -> OffsetCoord:
		if vec.type != type and vec.type != Type.ALL and type != Type.ALL:
			printerr("OffsetCoord | different type adding")
			return null
		var result: OffsetCoord = OffsetCoord.new(col + vec.col, row + vec.row)
		result.type = type if type != Type.ALL else vec.type
		return result
	
	
	func substract(vec: OffsetCoord) -> OffsetCoord:
		if vec.type != type and vec.type != Type.ALL and type != Type.ALL:
			printerr("OffsetCoord | different type sustracting")
			return null
		var result: OffsetCoord = OffsetCoord.new(col - vec.col, row - vec.row)
		result.type = type if type != Type.ALL else vec.type
		return result
	
	
	func distance_to(vec: OffsetCoord) -> int:
		var a = to_axial()
		var b = vec.to_axial()
		if a == null or b == null:
			return -1
		return a.distance_to(b)
	
	
	func neighbor(direction: Direction) -> OffsetCoord:
		match type:
			Type.ALL:
				printerr("OffsetCoord | type ALL can't find neighbor")
				return null
			Type.ODD_R:
				var parity = row & 1
				return add(oddr_direction_vec(parity, direction))
			Type.EVEN_R:
				var parity = row & 1
				return add(evenr_direction_vec(parity, direction))
			Type.ODD_Q:
				var parity = col & 1
				return add(oddq_direction_vec(parity, direction))
			Type.EVEN_Q:
				var parity = col & 1
				return add(evenq_direction_vec(parity, direction))
			_:
				printerr("OffsetCoord | neighbor | unknown type: ", type)
				return null
	
	
	func to_axial() -> Hex:
		match type:
			Type.ALL:
				printerr("OffsetCoord | type ALL can't turn to axial")
				return null
			Type.ODD_R:
				return oddr_to_axial()
			Type.EVEN_R:
				return evenr_to_axial()
			Type.ODD_Q:
				return oddq_to_axial()
			Type.EVEN_Q:
				return evenq_to_axial()
			_:
				printerr("OffsetCoord | to_axial | unknown type: ", type)
				return null
	
	
	func oddr_to_axial() -> Hex:
		var q: int = col - (row - (row & 1)) / 2
		var r: int = row
		return Hex.new(q, r)
	
	
	func evenr_to_axial() -> Hex:
		var q: int = col - (row + (row & 1)) / 2
		var r: int = row
		return Hex.new(q, r)
	
	
	func oddq_to_axial() -> Hex:
		var q: int = col
		var r: int = row - (col - (col & 1)) / 2
		return Hex.new(q, r)
	
	
	func evenq_to_axial() -> Hex:
		var q: int = col
		var r: int = row - (col + (col & 1)) / 2
		return Hex.new(q, r)

## =======================================================
#						轴坐标系
## =======================================================
class Hex:
	static var axial_direction_vectors: Array[Hex] = [
		Hex.new(1, 0), # 右
		Hex.new(1, -1), # 右上
		Hex.new(0, -1), # 左上
		Hex.new(-1, 0), # 左
		Hex.new(-1, 1), # 左下
		Hex.new(0, 1), # 右下
	]
	
	var q: int
	var r: int
	
	
	func _init(q: int, r: int):
		self.q = q
		self.r = r
	
	
	## 返回轴坐标下的方向向量
	static func direction_vec(direction: Direction) -> Hex:
		return axial_direction_vectors[direction]
	
	
	func add(vec: Hex) -> Hex:
		return Hex.new(q + vec.q, r + vec.r)
	
	
	func substract(vec: Hex) -> Hex:
		return Hex.new(q - vec.q, r - vec.r)
	
	
	## 顺时针旋转
	func rotate_right() -> Hex:
		return Hex.new(-r, q + r)
	
	
	func rotate_right_around(pivot: Hex) -> Hex:
		var vec: Hex = substract(pivot)
		return pivot.add(vec.rotate_right())
	
	
	## 逆时针旋转
	func rotate_left() -> Hex:
		return Hex.new(q + r, -q)
	
	
	func rotate_left_around(pivot: Hex) -> Hex:
		var vec: Hex = substract(pivot)
		return pivot.add(vec.rotate_left())
	
	
	## q 轴对称（中心格斜线 / 方向对角线的轴）
	# 注：求垂直于 q 轴的轴对称点，可以 self.scale(-1).reflect_q()
	# 求对于不过中心点的 q 轴的对称点，可以在轴上取一个参考点 pivot，
	# 然后 pivot.add(self.substract(pivot).reflect_q())
	func relect_q() -> Hex:
		return Hex.new(q, -q - r)
	
	
	## r 轴对称（中心格竖线 | 方向对角线的轴）
	func relect_r() -> Hex:
		return Hex.new(-q - r, r)
	
	
	## s 轴对称（中心格反斜线 \ 方向对角线的轴）
	func relect_s() -> Hex:
		return Hex.new(r, q)
	
	
	func scale(factor: int) -> Hex:
		return Hex.new(q * factor, r * factor)
	
	
	func distance_to(vec: Hex) -> int:
		var diff: Hex = substract(vec)
		return (abs(diff.q) + abs(diff.q + diff.r) + abs(diff.r)) / 2
	
	
	func in_range(n: int) -> Array[Hex]:
		var result: Array[Hex] = []
		for i in range(-n, n+1):
			for j in range(max(-n, -i - n), min(n, -i + n) + 1):
				result.append(add(Hex.new(i, j)))
		return result
	
	
	func intersecting_range(h: Hex, n: int) -> Array[Hex]:
		var result: Array[Hex] = []
		var q_min = max(q, h.q) - n
		var q_max = min(q, h.q) + n
		var r_min = max(r, h.r) - n
		var r_max = min(r, h.r) + n
		var s_min = max(-q - r, -h.q - h.r) - n
		var s_max = min(-q - r, -h.q - h.r) + n
		for i in range(q_min, q_max + 1):
			for j in range(max(r_min, -i - s_max), \
					min(r_max, -i - s_min) + 1):
				result.append(Hex.new(i, j))
		return result
	
	
	func ring(radius: int) -> Array[Hex]:
		var result: Array[Hex] = []
		# 对于 radius == 0 时无效
		var hex = add(direction_vec(Direction.LEFT_DOWN).scale(radius))
		for i in Direction.values():
			for j in range(radius):
				result.append(hex)
				hex = hex.neighbor(i)
		return result
	
	
	## 轴坐标系相邻
	func neighbor(direction: Direction) -> Hex:
		return add(direction_vec(direction))
	
	
	## 立方体坐标
	func to_cube() -> Cube:
		return Cube.new(q, r, -q - r)
	
	
	## odd-r 坐标
	#	Implementation note:
	#	I use a&1 (bitwise and) instead of a%2 (modulo) to detect whether something is even (0) or odd (1),
	#	because it works with negative numbers too.
	#	上面说的其实就是我自己在之前也碰到了的负数 bug，用按位与（&）来解决确实方便
	##
	func to_oddr() -> OffsetCoord:
		var col: int = q + (r - (r&1)) / 2
		var row: int = r
		return OffsetCoord.odd_r(col, row)
	
	
	## even-r 坐标
	func to_evenr() -> OffsetCoord:
		var col: int = q + (r + (r&1)) / 2
		var row: int = r
		return OffsetCoord.even_r(col, row)
	
	
	## odd-q 坐标
	func to_oddq() -> OffsetCoord:
		var col: int = q
		var row: int = r + (q - (q&1)) / 2
		return OffsetCoord.odd_q(col, row)
	
	
	## even-q 坐标
	func to_evenq() -> OffsetCoord:
		var col: int = q
		var row: int = r + (q + (q&1)) / 2
		return OffsetCoord.even_q(col, row)
	
	
	func to_doubleheight() -> DoubledCoord:
		var col: int = q
		var row: int = 2 * r + q
		return DoubledCoord.height(col, row)
	
	
	func to_doublewidth() -> DoubledCoord:
		var col: int = 2 * q + r
		var row: int = r
		return DoubledCoord.width(col, row)

## =======================================================
#						立方体坐标系
## =======================================================
class Cube:
	# 因为有 new，貌似就没办法写成 const
	static var cube_direction_vectors: Array[Cube] = [
		Cube.new(1, 0, -1), # 右
		Cube.new(1, -1, 0), # 右上
		Cube.new(0, -1, 1), # 左上
		Cube.new(-1, 0, 1), # 左
		Cube.new(-1, 1, 0), # 左下
		Cube.new(0, 1, -1), # 右下
	]
	static var cube_diagonal_vectors: Array[Cube] = [
		Cube.new(1, 1, -2), # 右下
		Cube.new(2, -1, -1), # 右上 
		Cube.new(1, -2, 1), # 上
		Cube.new(-1, -1, 2), # 左上
		Cube.new(-2, 1, 1), # 左下
		Cube.new(-1, 2, -1), # 下
	]
	
	var q: int
	var r: int
	var s: int
	
	
	func _init(q: int, r: int, s: int):
		self.q = q
		self.r = r
		self.s = s
	
	
	## 返回立方体坐标下的方向向量
	static func direction_vec(direction: Direction) -> Cube:
		return cube_direction_vectors[direction]
	
	
	## 返回立方体坐标下的对角线向量
	static func diagonal_vec(direction: Direction) -> Cube:
		return cube_diagonal_vectors[direction]
	
	
	func add(vec: Cube) -> Cube:
		return Cube.new(q + vec.q, r + vec.r, s + vec.s)
	
	
	func substract(vec: Cube) -> Cube:
		return Cube.new(q - vec.q, r - vec.r, s - vec.s)
	
	
	## 顺时针旋转
	func rotate_right() -> Cube:
		return Cube.new(-r, -s, -q)
	
	
	func rotate_right_around(pivot: Cube) -> Cube:
		var vec: Cube = substract(pivot)
		return pivot.add(vec.rotate_right())
	
	
	## 逆时针旋转
	func rotate_left() -> Cube:
		return Cube.new(-s, -q, -r)
	
	
	func rotate_left_around(pivot: Cube) -> Cube:
		var vec: Cube = substract(pivot)
		return pivot.add(vec.rotate_left())
	
	
	# q 轴对称（中心格斜线 / 方向对角线的轴）
	func relect_q() -> Cube:
		return Cube.new(q, s, r)
	
	
	# r 轴对称（中心格竖线 | 方向对角线的轴）
	func relect_r() -> Cube:
		return Cube.new(s, r, q)
	
	
	# s 轴对称（中心格反斜线 \ 方向对角线的轴）
	func relect_s() -> Cube:
		return Cube.new(r, q, s)
	
	
	func scale(factor: int) -> Cube:
		return Cube.new(q * factor, r * factor, s * factor)
	
	
	func distance_to(vec: Cube) -> int:
		var diff: Cube = substract(vec)
		return (abs(diff.q) + abs(diff.r) + abs(diff.s)) / 2
		# 等效： return max(abs(diff.q), abs(diff.r), abs(diff.s))
	
	
	# 因为浮点数的问题，所以用的是 Vector3 代表浮点化的 Cube
	func lerp_to_vec3(b: Cube, t: float) -> Vector3:
		return Vector3(lerpf(q, b.q, t), \
				lerpf(r, b.r, t), \
				lerpf(s, b.s, t))
	
	
	# 因为浮点数的问题，所以用的是 Vector3 代表浮点化的 Cube
	static func round_vec3(cube: Vector3):
		var q: int = roundi(cube.x)
		var r: int = roundi(cube.y)
		var s: int = roundi(cube.z)
		
		var q_diff: float = absf(q - cube.x)
		var r_diff: float = absf(r - cube.y)
		var s_diff: float = absf(s - cube.z)
		
		if q_diff > r_diff and q_diff > s_diff:
			q = -r - s
		elif r_diff > s_diff:
			r = -q - s
		else:
			s = -q - r
		return Cube.new(q, r, s)
	
	
	func line_draw_to(vec: Cube) -> Array[Cube]:
		var n = distance_to(vec)
		var result: Array[Cube] = []
		for i in range(n + 1):
			result.append(round_vec3(lerp_to_vec3(vec, 1.0 / n * i)))
		return result
	
	
	func in_range(n: int) -> Array[Cube]:
		var result: Array[Cube] = []
		for i in range(-n, n+1):
			for j in range(max(-n, -i - n), min(n, -i + n) + 1):
				var k = -i - j
				result.append(add(Cube.new(i, j, k)))
		return result
	
	
	func intersecting_range(h: Cube, n: int) -> Array[Cube]:
		var result: Array[Cube] = []
		var q_min = max(q, h.q) - n
		var q_max = min(q, h.q) + n
		var r_min = max(r, h.r) - n
		var r_max = min(r, h.r) + n
		var s_min = max(s, h.s) - n
		var s_max = min(s, h.s) + n
		for i in range(q_min, q_max + 1):
			for j in range(max(r_min, -i - s_max), \
					min(r_max, -i - s_min) + 1):
				result.append(Cube.new(i, j, -i - j))
		return result
	
	
	## 环
	func ring(radius: int) -> Array[Cube]:
		var result: Array[Cube] = []
		# 对于 radius == 0 时无效
		var hex = add(direction_vec(Direction.LEFT_DOWN).scale(radius))
		for i in Direction.values():
			for j in range(radius):
				result.append(hex)
				hex = hex.neighbor(i)
		return result
	
	
	## 螺旋
	func spiral(radius: int) -> Array[Cube]:
		var result: Array[Cube] = []
		for k in range(1, radius + 1):
			result.append_array(ring(k))
		return result
	
	
	## 立方体坐标系相邻
	func neighbor(direction: Direction) -> Cube:
		return add(direction_vec(direction))
	
	
	## 立方体坐标系对角线相邻（相隔仅一格，角上连线出去的格子）
	func diagonal_neighbor(direction: Direction) -> Cube:
		return add(diagonal_vec(direction))
	
	
	## 轴坐标
	func to_axial() -> Hex:
		return Hex.new(q, r)


## =======================================================
#						双倍坐标系
## =======================================================
class DoubledCoord:
	enum Type {
		ALL,
		HEIGHT,
		WIDTH,
	}
	
	static var width_direction_vectors: Array[DoubledCoord] = [
		width(2, 0), width(1, -1), width(-1, -1), # 右, 右上, 左上
		width(-2, 0), width(-1, 1), width(1, 1), # 左, 左下, 右下
	]
	
	static var height_direction_vectors: Array[DoubledCoord] = [
		width(1, 1), width(1, -1), width(0, -2), # 右下, 右上, 上
		width(-1, -1), width(-1, 1), width(0, 2), # 左上, 左下, 下
	]
	
	var col: int
	var row: int
	var type: Type = Type.ALL
	
	
	func _init(col: int, row: int) -> void:
		self.col = col
		self.row = row
	
	
	static func init(col: int, row: int, type: Type) -> DoubledCoord:
		var doubled := DoubledCoord.new(col, row)
		doubled.type = type
		return doubled
	
	
	static func height(col: int, row: int) -> DoubledCoord:
		return init(col, row, Type.HEIGHT)
	
	
	static func width(col: int, row: int) -> DoubledCoord:
		return init(col, row, Type.WIDTH)
	
	
	static func width_direction_vec(direction: Direction) -> DoubledCoord:
		return width_direction_vectors[direction]
	
	
	static func height_direction_vec(direction: Direction) -> DoubledCoord:
		return height_direction_vectors[direction]
	
	
	func add(vec: DoubledCoord) -> DoubledCoord:
		if vec.type != type and vec.type != Type.ALL and type != Type.ALL:
			printerr("DoubledCoord | different type adding")
			return null
		var result: DoubledCoord = DoubledCoord.new(col + vec.col, row + vec.row)
		result.type = type if type != Type.ALL else vec.type
		return result
	
	
	func substract(vec: DoubledCoord) -> DoubledCoord:
		if vec.type != type and vec.type != Type.ALL and type != Type.ALL:
			printerr("DoubledCoord | different type substracting")
			return null
		var result: DoubledCoord = DoubledCoord.new(col - vec.col, row - vec.row)
		result.type = type if type != Type.ALL else vec.type
		return result
	
	
	func distance_to(vec: DoubledCoord) -> int:
		var diff: DoubledCoord = substract(vec)
		if diff == null || type == Type.ALL:
			return -1
		if type == Type.WIDTH:
			return diff.row + max(0, (diff.col - diff.row) / 2)
		else:
			return diff.col + max(0, (diff.row - diff.col) / 2)
	
	
	func neighbor(direction: Direction) -> DoubledCoord:
		match type:
			Type.ALL:
				printerr("DoubledCoord | type ALL can't find neighbor")
				return null
			Type.WIDTH:
				return add(width_direction_vec(direction))
			Type.HEIGHT:
				return add(height_direction_vec(direction))
			_:
				printerr("DoubledCoord | neighbor | unknown type: ", type)
				return null
	
	
	func to_axial() -> Hex:
		match type:
			Type.ALL:
				printerr("DoubledCoord | type ALL can't turn to axial")
				return null
			Type.HEIGHT:
				return height_to_axial()
			Type.WIDTH:
				return width_to_axial()
			_:
				printerr("DoubledCoord | to_axial | unknown type: ", type)
				return null
	
	
	## 双倍高度坐标 & 轴坐标
	func height_to_axial() -> Hex:
		var q: int = col
		var r: int = (row - col) / 2
		return Hex.new(q, r)
	
	
	## 双倍宽度坐标 & 轴坐标
	func width_to_axial() -> Hex:
		var q: int = (col - row) / 2
		var r: int = row
		return Hex.new(q, r)
