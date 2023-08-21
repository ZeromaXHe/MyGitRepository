extends CanvasLayer
class_name WinlineUiImpl

const ball_scene: PackedScene = preload("res://ui_impl/ball_button.tscn")

@onready var grid_container: GridContainer = $HBoxContainer/GridContainer
# 偷懒，懒得用数组了
@onready var next_ball1: TextureRect = $HBoxContainer/NextComingContainer/VBoxContainer/NextBall1
@onready var next_ball2: TextureRect = $HBoxContainer/NextComingContainer/VBoxContainer/NextBall2
@onready var next_ball3: TextureRect = $HBoxContainer/NextComingContainer/VBoxContainer/NextBall3
@onready var score_label: Label = $HBoxContainer/NextComingContainer/VBoxContainer/Score

# GirdContainer 中 BallButton 的二维数组
var ball_grid: Array = []
# 7 种球的颜色
var color_arr: Array[Color] = [Color.GREEN, Color.RED, Color.YELLOW, \
		Color.PURPLE, Color.BLUE, Color.WHITE, Color.ORANGE]
# 选择的位置（(-1，-1) 时说明没有选中要移动的球，其他值说明选中了要移动的球）
var chosen_position: Vector2i = Vector2i(-1, -1)
# 空位置数组，用于随机生成新的球时方便取用
var empty_posi_arr: Array = []
var game_over: bool = false
var score_point: int = 0


func _ready() -> void:
	# 刷新随机种子
	randomize()
	init_grid_container_and_pic_grid()
	init_start_5_balls()
	init_next_coming_3_balls()


## 初始化 grid_container，并把对应图片坐标引用存在 ball_grid 二维数组中
func init_grid_container_and_pic_grid():
	for i in range(9):
		ball_grid.append([])
		for j in range(9):
			var ball: BallButton = ball_scene.instantiate()
			ball.name = "BallButton" + str(i) + "-" + str(j)
			# 用非黑色的颜色代表球，黑色代表没球
			ball.modulate = Color.BLACK
			ball.x = i
			ball.y = j
			ball_grid[i].append(ball)
			grid_container.add_child(ball)
			empty_posi_arr.append(ball)
			
			ball.ball_button_pressed.connect(handle_ball_button_pressed)


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


## 初始化接下来出现的 3 个球
func init_next_coming_3_balls():
	next_ball1.modulate = color_arr[randi_range(0, 6)]
	next_ball2.modulate = color_arr[randi_range(0, 6)]
	next_ball3.modulate = color_arr[randi_range(0, 6)]


# 处理球被按下的事件
func handle_ball_button_pressed(ball: BallButton):
	if game_over:
		print("你已经输了，别按了")
		return
	if ball.modulate == Color.BLACK:
		# 黑色说明选择的位置没球
		if chosen_position == Vector2i(-1, -1):
			# (-1, -1) 说明之前没有选择要移动的球，直接不处理本次点击
			print("当前点击空位置[", ball.x, ", ", ball.y, "]无效，因为没有选择要移动的球")
			return
		
		move_ball_to_empty(ball_grid[chosen_position.x][chosen_position.y], ball)
		# 重置选择位置
		chosen_position = Vector2i(-1, -1)
	else:
		# 说明选中的地方有球
		chosen_position = Vector2i(ball.x, ball.y)


## 偷懒了，这里确实使用 BFS（广度优先搜索）或者 A* 会比较好。不过 DFS（深度优先搜索）实现起来简单，9 * 9 范围无所谓了。
func move_ball_to_empty(ball: BallButton, empty: BallButton):
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
	
	# 移动球，其实就是改颜色
	empty.modulate = ball.modulate
	ball.modulate = Color.BLACK
	# TODO: 数组查找效率比较低，这里简单实现功能
	empty_posi_arr.remove_at(empty_posi_arr.find(empty))
	empty_posi_arr.append(ball)
	
	find_any_score(empty)
	
	add_next_come_3_balls()


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
func find_any_score(ball: BallButton):
	# 构造用于 DFS 的访问数组
	var visited = []
	for i in range(9):
		visited.append([])
		for j in range(9):
			visited[i].append(false)
	# count_connect 其实也是 DFS，判断联通的相同颜色的个数
	var count = count_connect(visited, ball.x, ball.y, 0, ball.modulate)
	print("联通数量：", count)
	if count >= 5:
		# 每消除一个球加一分
		score_point += count
		score_label.text = str(score_point)
		# 清空 visited 数组，重复利用
		for i in range(9):
			for j in range(9):
				visited[i][j] = false
		# 把球消除成空位
		clear_empty(visited, ball.x, ball.y, ball.modulate)


## 同样利用 DFS 计算联通的相同颜色数量，这里是八个方向都可以
func count_connect(visited: Array, x: int, y: int, result: int, color: Color) -> int:
	if visited[x][y] or ball_grid[x][y].modulate != color:
		return 0
	visited[x][y] = true
	result += 1
	if y > 0:
		result += count_connect(visited, x, y - 1, 0, color)
	if y < 8:
		result += count_connect(visited, x, y + 1, 0, color)
	if x > 0:
		result += count_connect(visited, x - 1, y, 0, color)
		if y > 0:
			result += count_connect(visited, x - 1, y - 1, 0, color)
		if y < 8:
			result += count_connect(visited, x - 1, y + 1, 0, color)
	if x < 8:
		result += count_connect(visited, x + 1, y, 0, color)
		if y > 0:
			result += count_connect(visited, x + 1, y - 1, 0, color)
		if y < 8:
			result += count_connect(visited, x + 1, y + 1, 0, color)
	return result


## 同样利用 DFS 来消除并且得分，这里是八个方向都可以
func clear_empty(visited: Array, x: int, y: int, color: Color) -> void:
	if visited[x][y] or ball_grid[x][y].modulate != color:
		return
	visited[x][y] = true
	
	ball_grid[x][y].modulate = Color.BLACK
	empty_posi_arr.append(ball_grid[x][y])
	if y > 0:
		clear_empty(visited, x, y - 1, color)
	if y < 8:
		clear_empty(visited, x, y + 1, color)
	if x > 0:
		clear_empty(visited, x - 1, y, color)
		if y > 0:
			clear_empty(visited, x - 1, y - 1, color)
		if y < 8:
			clear_empty(visited, x - 1, y + 1, color)
	if x < 8:
		clear_empty(visited, x + 1, y, color)
		if y > 0:
			clear_empty(visited, x + 1, y - 1, color)
		if y < 8:
			clear_empty(visited, x + 1, y + 1, color)


## 将下面 3 个球加入棋盘
func add_next_come_3_balls():
	if empty_posi_arr.size() <= 3:
		print("空余位置数量少于等于 3，你输了！！！")
		game_over = true
		return
	empty_posi_arr.shuffle()
	empty_posi_arr.pop_back().modulate = next_ball1.modulate
	empty_posi_arr.pop_back().modulate = next_ball2.modulate
	empty_posi_arr.pop_back().modulate = next_ball3.modulate
	# 刷新三个即将出现的球的颜色
	init_next_coming_3_balls()


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_exit_btn_pressed() -> void:
	get_tree().quit()


func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://ui_impl/winline_ui_impl.tscn")
