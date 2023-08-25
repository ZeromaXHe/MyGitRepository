extends CanvasLayer
class_name ScoreBoard


@export var kill_score = 100
@export var dead_score = -50
@export var capture_score = 300

@onready var player_stat: GridContainer = $CenterContainer/PanelContainer/HBoxContainer/PlayerVBoxContainer/PlayerStatContainer
@onready var enemy_stat: GridContainer = $CenterContainer/PanelContainer/HBoxContainer/EnemyVBoxContainer/EnemyStatContainer

var player_team_score_infos: Array[ScoreInfo] = []
var enemy_team_score_infos: Array[ScoreInfo] = []
var name_to_score_info_dict: Dictionary = {}
var player_rows: Array[BoardLabelRow] = []
var enemy_rows: Array[BoardLabelRow] = []


class ScoreInfo:
	var name: String
	var kill: int = 0
	var dead: int = 0
	var capture: int = 0
	var score: int = 0
	var timestamp: float


class BoardLabelRow:
	var name_label: RichTextLabel
	var kill_label: Label
	var dead_label: Label
	var capture_label: Label
	var score_label: Label


func _ready() -> void:
	GlobalSignals.actor_killed.connect(handle_actor_killed)
	
	for base in GlobalMediator.capturable_base_manager.capturable_bases:
		(base as CapturableBase).base_captured.connect(handle_base_captured)


func update_score_board():
	player_team_score_infos.sort_custom(sort_score_info)
	enemy_team_score_infos.sort_custom(sort_score_info)
	
	for i in range(player_rows.size()):
		update_row(player_rows[i], player_team_score_infos[i], true)
	for i in range(enemy_rows.size()):
		update_row(enemy_rows[i], enemy_team_score_infos[i], false)


func sort_score_info(a: ScoreInfo, b: ScoreInfo):
	# 分数高且先到达该分数的排前面
	if a.score == b.score:
		return a.timestamp < b.timestamp
	return a.score > b.score


func update_row(row: BoardLabelRow, score_info: ScoreInfo, player_team: bool):
	row.name_label.text = name_bbcode_wrapper(score_info.name, player_team)
	row.kill_label.text = str(score_info.kill)
	row.dead_label.text = str(score_info.dead)
	row.capture_label.text = str(score_info.capture)
	row.score_label.text = str(score_info.score)


func name_bbcode_wrapper(name: String, player_team: bool) -> String:
	return ("[center][color=green]" if player_team else "[center][color=red]") \
			+ name + "[/color][/center]"


func recalc_score(score_info: ScoreInfo):
	score_info.score = score_info.kill * kill_score + score_info.dead * dead_score \
			+ score_info.capture * capture_score
	score_info.timestamp = Time.get_unix_time_from_system()


func handle_actor_inited(actor: Actor):
	# 初始化得分信息数据结构
	var score_info := ScoreInfo.new()
	score_info.name = actor.name
	score_info.timestamp = Time.get_unix_time_from_system()
	name_to_score_info_dict[actor.name] = score_info
	if actor.team.side == Team.Side.PLAYER:
		player_team_score_infos.append(score_info)
	else:
		enemy_team_score_infos.append(score_info)
	print("init ", actor.name, "'s score board row...")
	# 初始化得分板界面上的一行
	init_board_label_row(actor)


func init_board_label_row(actor: Actor):
	var is_player_team: bool = (actor.team.side == Team.Side.PLAYER)
	# 好像并不需要等待 ready 信号，stat 不会为空
	var stat: GridContainer = player_stat if is_player_team else enemy_stat
	var rows: Array = player_rows if is_player_team else enemy_rows
	
	var row = BoardLabelRow.new()
	# 名字标签
	row.name_label = RichTextLabel.new()
	row.name_label.name = "Name"
	row.name_label.bbcode_enabled = true
	row.name_label.text = name_bbcode_wrapper(actor.name, is_player_team)
	row.name_label.fit_content = true
	stat.add_child(row.name_label)
	stat.add_child(VSeparator.new())
	# 击杀数标签
	row.kill_label = Label.new()
	row.kill_label.name = "Kill"
	row.kill_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.kill_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.kill_label.text = "0"
	stat.add_child(row.kill_label)
	stat.add_child(VSeparator.new())
	# 死亡数标签
	row.dead_label = Label.new()
	row.dead_label.name = "Dead"
	row.dead_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.dead_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.dead_label.text = "0"
	stat.add_child(row.dead_label)
	stat.add_child(VSeparator.new())
	# 占领数标签
	row.capture_label = Label.new()
	row.capture_label.name = "Capture"
	row.capture_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.capture_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.capture_label.text = "0"
	stat.add_child(row.capture_label)
	stat.add_child(VSeparator.new())
	# 得分标签
	row.score_label = Label.new()
	row.score_label.name = "Score"
	row.score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.score_label.text = "0"
	stat.add_child(row.score_label)
	
	rows.append(row)


func handle_actor_killed(killed: Actor, killer: Actor, _weapon: Weapon):
	# 友军误杀，暂时不列入统计（按道理应该统计下来扣分的）
	if killer.team.side == killed.team.side:
		return
	name_to_score_info_dict[killed.name].dead += 1
	name_to_score_info_dict[killer.name].kill += 1
	recalc_score(name_to_score_info_dict[killed.name])
	recalc_score(name_to_score_info_dict[killer.name])
	
	if visible:
		update_score_board()


func handle_base_captured(_base: CapturableBase, actors: Array[Actor]):
	for actor in actors:
		name_to_score_info_dict[actor.name].capture += 1
		recalc_score(name_to_score_info_dict[actor.name])
	
	if visible:
		update_score_board()


func _on_visibility_changed() -> void:
	if visible:
		update_score_board()
