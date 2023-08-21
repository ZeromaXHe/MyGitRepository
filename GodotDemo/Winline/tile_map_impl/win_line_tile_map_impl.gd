extends Node2D
class_name WinLineTileMapImpl


const ball_body_scene: PackedScene = preload("res://tile_map_impl/ball_character_body.tscn")
const empty_view_scene: PackedScene = preload("res://tile_map_impl/empty_view.tscn")

@onready var tile_map: TileMap = $TileMap
# 偷懒，懒得用数组了
@onready var next_ball1: TextureRect = $GUI/HBoxContainer/VBoxContainer/CenterContainer/NextBall1
@onready var next_ball2: TextureRect = $GUI/HBoxContainer/VBoxContainer/CenterContainer2/NextBall2
@onready var next_ball3: TextureRect = $GUI/HBoxContainer/VBoxContainer/CenterContainer3/NextBall3
@onready var score_label: Label = $GUI/HBoxContainer/VBoxContainer/Score
@onready var note_label: Label = $GUI/HBoxContainer/CenterContainer/Note
# 用于放球节点
@onready var balls: Node2D = $Balls
# 用于在球到达后等待一段时间
@onready var ball_arrive_timer: Timer = $BallArriveTimer
# 用于调试空位数组的相关组件
@onready var empty_debug_timer: Timer = $EmptyDebugTimer
@onready var empty_debug_btn: CheckButton = $GUI/HBoxContainer/VBoxContainer/EmptyDebugBtn
@onready var empty_debug_views: Node2D = $EmptyDebugViews

# 存储
var ball_grid: Array = []
# 7 种球的颜色
var color_arr: Array[Color] = [Color.GREEN, Color.RED, Color.YELLOW, \
		Color.PURPLE, Color.BLUE, Color.WHITE, Color.ORANGE]
# 选择的位置（(-1，-1) 时说明没有选中要移动的球，其他值说明选中了要移动的球）
var chosen_position: Vector2i = Vector2i(-1, -1)
# 空位置数组，用于随机生成新的球时方便取用
var empty_posi_arr: Array[Ball] = []
# 游戏结束状态
var game_over: bool = false
# 有球正在移动的状态
var moving_ball: bool = false
# 得分
var score_point: int = 0

# 表示八个方向的数组，每两个相邻的数字可以组成一个方向
var direct_arr: Array[int] = [1, 0, -1, 0, 1, 1, -1, -1]

class Ball:
	var x = -1
	var y = -1
	var modulate: Color
	# 当颜色不为黑色时，这里存储对应球的实体引用
	var instance: BallCharacterBody


func _ready() -> void:
	# 刷新随机种子
	randomize()
	init_ball_grid()
	init_start_5_balls()
	init_next_coming_3_balls()
	# 游戏结束提示一开始不显示
	note_label.visible = false


## 初始化 ball_grid 二维数组
func init_ball_grid():
	for i in range(9):
		ball_grid.append([])
		for j in range(9):
			var ball: Ball = Ball.new()
			# 用非黑色的颜色代表球，黑色代表没球
			ball.modulate = Color.BLACK
			ball.x = i
			ball.y = j
			ball_grid[i].append(ball)
			empty_posi_arr.append(ball)


## 初始化开始的五个球
func init_start_5_balls():
	for i in range(5):
		var x = randi_range(0, 8)
		var y = randi_range(0, 8)
		# 随机到的地方已经有球的话，就重新随机
		while ball_grid[x][y].modulate != Color.BLACK:
			x = randi_range(0, 8)
			y = randi_range(0, 8)
		ball_grid[x][y].modulate = color_arr[randi_range(0, 6)]
		
		empty_posi_arr.erase(ball_grid[x][y])
		init_ball_on_tile_map(x, y)


## 在 TileMap 之上生成球实体
func init_ball_on_tile_map(x: int, y: int):
	var ball := ball_body_scene.instantiate()
	balls.add_child(ball)
	ball.img.modulate = ball_grid[x][y].modulate
	ball.global_position = ball_idx_to_global_position(x, y)
	ball_grid[x][y].instance = ball
	# 将球所在的 TileMap 置为 ball
	tile_map.set_cell(0, Vector2i(x, y), 1, Vector2i(0, 0))


## ball_grid 的索引转换为全局位置坐标
func ball_idx_to_global_position(x: int, y: int) -> Vector2:
	return Vector2(32 + x * 64, 32 + y * 64)


## 全局坐标转 ball_grid 索引
func global_position_to_ball_idx(global_posi: Vector2) -> Vector2i:
	var x: int = global_posi.x / 64
	if x < 0 or x >= 9:
		return Vector2i(-1, -1)
	var y: int = global_posi.y / 64
	if y < 0 or y >= 9:
		return Vector2i(-1, -1)
	return Vector2i(x, y)


## 初始化接下来出现的 3 个球
func init_next_coming_3_balls():
	next_ball1.modulate = color_arr[randi_range(0, 6)]
	next_ball2.modulate = color_arr[randi_range(0, 6)]
	next_ball3.modulate = color_arr[randi_range(0, 6)]


func _unhandled_input(event: InputEvent) -> void:
	# 获取鼠标左键的输入事件
	if event.is_action_released("mouse_left"):
		handle_mouse_clicked(get_global_mouse_position())


# 处理鼠标左键被按下的事件
func handle_mouse_clicked(mouse_posi: Vector2):
	if game_over:
		print("你已经输了，别按了")
		return
	if moving_ball:
		print("有球正在移动，不能操作")
		return
	var idx: Vector2i = global_position_to_ball_idx(mouse_posi)
	if idx == Vector2i(-1, -1):
		print("点击的地方超过棋盘范围，不处理")
		return
	var clicked: Ball = ball_grid[idx.x][idx.y]
	print("当前点击对应棋盘坐标位置[", idx.x, ", ", idx.y, "]")
	if clicked.modulate == Color.BLACK:
		# 黑色说明选择的位置没球
		if chosen_position == Vector2i(-1, -1):
			# (-1, -1) 说明之前没有选择要移动的球，直接不处理本次点击
			print("当前点击空位置[", clicked.x, ", ", clicked.y, "]无效，因为没有选择要移动的球")
			return
		
		ball_grid[chosen_position.x][chosen_position.y].instance.chosen_img.visible = false
		move_ball_to_empty(ball_grid[chosen_position.x][chosen_position.y], clicked)
		# 重置选择位置
		chosen_position = Vector2i(-1, -1)
	elif chosen_position.x == clicked.x and chosen_position.y == clicked.y:
		# 说明选中的的球就是之前选的球，那么取消选择
		clicked.instance.chosen_img.visible = false
		chosen_position = Vector2i(-1, -1)
	else:
		chosen_position = Vector2i(clicked.x, clicked.y)
		clicked.instance.chosen_img.visible = true


## 偷懒了，这里确实使用 BFS（广度优先搜索）或者 A* 会比较好。不过 DFS（深度优先搜索）实现起来简单，9 * 9 范围无所谓了。
func move_ball_to_empty(ball: Ball, empty: Ball):
	# 构造用于 DFS 的访问数组
	var visited = []
	for i in range(9):
		visited.append([])
		for j in range(9):
			visited[i].append(false)
	# 如果 DFS 判断出不可达，则直接返回
	if not can_move_to(visited, ball.x, ball.y, empty.x, empty.y):
		print("球[", ball.x, ", ", ball.y, "]无法到达空位[", empty.x, ", ", empty.y, "]")
		return
	
	# 将球所在的 TileMap 置为 slot，不然后面球会因为自己脚下的位置不是空位而无法移动
	tile_map.set_cell(0, Vector2i(ball.x, ball.y), 2, Vector2i(0, 0))
	moving_ball = true
	async_move_ball_empty.call_deferred(ball, empty)


## 异步执行球移动的过程，待球移动到指定位置，执行收尾逻辑
func async_move_ball_empty(ball: Ball, empty: Ball):
	# 命令球向空位移动
	ball.instance.move_to(ball_idx_to_global_position(empty.x, empty.y))
	print("等待球移动完成")
	# 等待球到达目标的信号
	await ball.instance.ball_reached_target
	print("球已经完成")
	
	# 再等待一段时间，不然会有 bug，会被新生成的球挤住
	ball_arrive_timer.start()
	await ball_arrive_timer.timeout
	
	# TODO: 数组查找效率比较低，这里简单实现功能
	empty_posi_arr.erase(empty)
	empty_posi_arr.append(ball)
	
	# 移动球后，改 ball_grid 中存储的颜色和实例
	empty.modulate = ball.modulate
	empty.instance = ball.instance
	ball.modulate = Color.BLACK
	ball.instance = null
	
	# 寻路最后球的位置会有一定误差，手动把它置为最准确的位置
	empty.instance.global_position = ball_idx_to_global_position(empty.x, empty.y)
	
	# 将 empty 所在的 TileMap 位置置为 ball 图块
	tile_map.set_cell(0, Vector2i(empty.x, empty.y), 1, Vector2i(0, 0))
	
	find_any_score(empty)
	
	add_next_come_3_balls()
	
	moving_ball = false


## 深度优先搜索判断是否可以移动到的实现，这里是只能按四个方向走
func can_move_to(visited: Array, x: int, y: int, dest_x: int, dest_y: int) -> bool:
	if visited[x][y]:
		return false
	if x == dest_x and y == dest_y:
		return true
	visited[x][y] = true
	if x > 0 and ball_grid[x - 1][y].modulate == Color.BLACK \
			and can_move_to(visited, x - 1, y, dest_x, dest_y):
		return true
	if x < 8 and ball_grid[x + 1][y].modulate == Color.BLACK \
			and can_move_to(visited, x + 1, y, dest_x, dest_y):
		return true
	if y > 0 and ball_grid[x][y - 1].modulate == Color.BLACK \
			and can_move_to(visited, x, y - 1, dest_x, dest_y):
		return true
	if y < 8 and ball_grid[x][y + 1].modulate == Color.BLACK \
			and can_move_to(visited, x, y + 1, dest_x, dest_y):
		return true
	return false


## 判断是否得分
func find_any_score(ball: Ball):
	# 判断联通的相同颜色的个数
	var any_connect: Array[bool] = count_connect(ball)
	if any_connect[0]:
		# 把球消除成空位
		clear_empty(ball, any_connect)
		# 更新 UI 上的得分
		score_label.text = str(score_point)


##
# 计算联通的相同颜色数量，这里是对横竖斜四个方向进行统计。
# 返回的布尔数组总会包含 5 个布尔值:
# 索引 0 表示是否要消除
# 索引 1 表示横向要消除
# 索引 2 表示纵向要消除
# 索引 3 表示斜向（/）要消除
# 索引 4 表示反斜向（\）要消除
##
func count_connect(ball: Ball) -> Array[bool]:
	var row_count: int = 1
	var col_count: int = 1
	var slash_count: int = 1
	var back_slash_count: int = 1
	for i in range(8):
		# qx 和 qy 表示正在查询的坐标
		var qx = ball.x
		var qy = ball.y
		# dx 和 dy 表示移动方向
		var dx = direct_arr[i]
		var dy = direct_arr[(i + 1) % 8]
		# 计算联通数量
		while qx + dx >= 0 and qy + dy >= 0 and qx + dx <= 8 and qy + dy <= 8 \
				and ball_grid[qx + dx][qy + dy].modulate == ball.modulate:
			qx += dx
			qy += dy
			if dx != 0 and dy == 0:
				row_count += 1
			elif dx == 0 and dy != 0:
				col_count += 1
			elif dx + dy == 0:
				slash_count += 1
			else:
				back_slash_count += 1
	print("横：", row_count, " 纵：", col_count, " 斜：", slash_count, " 反斜：", back_slash_count)
	return [row_count >= 5 or col_count >= 5 or slash_count >= 5 or back_slash_count >= 5, \
			row_count >= 5, col_count >= 5, slash_count >= 5, back_slash_count >= 5]


##
# 根据入参的 any_connect 来清除对应需要清理的方向
# any_connect 的构造参考 count_connect() 的注释
##
func clear_empty(ball: Ball, any_connect: Array[bool]) -> void:
	var qx = ball.x
	var qy = ball.y
	# 横向
	if any_connect[1]:
		while qx > 0 and ball_grid[qx - 1][qy].modulate == ball.modulate:
			qx -= 1
			reset_ball_to_slot_and_score(qx, qy)
		qx = ball.x
		while qx < 8 and ball_grid[qx + 1][qy].modulate == ball.modulate:
			qx += 1
			reset_ball_to_slot_and_score(qx, qy)
		qx = ball.x
	# 纵向
	if any_connect[2]:
		while qy > 0 and ball_grid[qx][qy - 1].modulate == ball.modulate:
			qy -= 1
			reset_ball_to_slot_and_score(qx, qy)
		qy = ball.y
		while qy < 8 and ball_grid[qx][qy + 1].modulate == ball.modulate:
			qy += 1
			reset_ball_to_slot_and_score(qx, qy)
		qy = ball.y
	# 斜向
	if any_connect[3]:
		while qx < 8 and qy > 0 and ball_grid[qx + 1][qy - 1].modulate == ball.modulate:
			qx += 1
			qy -= 1
			reset_ball_to_slot_and_score(qx, qy)
		qx = ball.x
		qy = ball.y
		while qx > 0 and qy < 8 and ball_grid[qx - 1][qy + 1].modulate == ball.modulate:
			qx -= 1
			qy += 1
			reset_ball_to_slot_and_score(qx, qy)
		qx = ball.x
		qy = ball.y
	# 反斜向
	if any_connect[4]:
		while qx > 0 and qy > 0 and ball_grid[qx - 1][qy - 1].modulate == ball.modulate:
			qx -= 1
			qy -= 1
			reset_ball_to_slot_and_score(qx, qy)
		qx = ball.x
		qy = ball.y
		while qx < 8 and qy < 8 and ball_grid[qx + 1][qy + 1].modulate == ball.modulate:
			qx += 1
			qy += 1
			reset_ball_to_slot_and_score(qx, qy)
		qx = ball.x
		qy = ball.y
	
	reset_ball_to_slot_and_score(ball.x, ball.y)


func reset_ball_to_slot_and_score(x: int, y: int):
	ball_grid[x][y].instance.queue_free()
	ball_grid[x][y].modulate = Color.BLACK
	# 将球所在的 TileMap 置为 slot
	tile_map.set_cell(0, Vector2i(x, y), 2, Vector2i(0, 0))
	# 每个球加一分
	score_point += 1
	# 增加空位
	empty_posi_arr.append(ball_grid[x][y])


## 将下面 3 个球加入棋盘
func add_next_come_3_balls():
	empty_posi_arr.shuffle()
	
	var next: Ball
	if empty_posi_arr.size() > 0:
		next = empty_posi_arr.pop_back()
		if next.instance != null:
			printerr("wtf")
		next.modulate = next_ball1.modulate
		init_ball_on_tile_map(next.x, next.y)
	
	if empty_posi_arr.size() > 0:
		next = empty_posi_arr.pop_back()
		if next.instance != null:
			printerr("wtf")
		next.modulate = next_ball2.modulate
		init_ball_on_tile_map(next.x, next.y)
	
	if empty_posi_arr.size() > 0:
		next = empty_posi_arr.pop_back()
		if next.instance != null:
			printerr("wtf")
		next.modulate = next_ball3.modulate
		init_ball_on_tile_map(next.x, next.y)
	
	if empty_posi_arr.size() == 0:
		print("空余位置数量为 0，你输了！！！")
		game_over = true
		note_label.visible = true
	else:
		# 刷新三个即将出现的球的颜色
		init_next_coming_3_balls()


func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://tile_map_impl/win_line_tile_map_impl.tscn")


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_exit_btn_pressed() -> void:
	get_tree().quit()


func _on_empty_debug_timer_timeout() -> void:
	for child in empty_debug_views.get_children():
		child.queue_free()
	for empty in empty_posi_arr:
		var empty_view = empty_view_scene.instantiate()
		empty_debug_views.add_child(empty_view)
		empty_view.global_position = ball_idx_to_global_position(empty.x, empty.y)


func _on_empty_debug_btn_toggled(button_pressed: bool) -> void:
	if button_pressed:
		empty_debug_timer.start()
		# 首先就直接绘制一次
		_on_empty_debug_timer_timeout()
	else:
		empty_debug_timer.stop()
		for child in empty_debug_views.get_children():
			child.queue_free()
		
