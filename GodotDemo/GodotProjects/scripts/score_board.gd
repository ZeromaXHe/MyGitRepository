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
	var name: RichTextLabel
	var kill: Label
	var dead: Label
	var capture: Label
	var score: Label


func _ready() -> void:
	# 初始化 player_rows 和 enemy_rows
	for i in range(4):
		init_row(player_stat, player_rows, i)
		init_row(enemy_stat, enemy_rows, i)
	
	GlobalSignals.actor_killed.connect(handle_actor_killed)
	
	for base in GlobalMediator.capturable_base_manager.capturable_bases:
		(base as CapturableBase).base_captured.connect(handle_base_captured)


func init_row(stat: GridContainer, rows: Array, idx: int):
	var row = BoardLabelRow.new()
	row.name = stat.get_node("Name"+ str(idx + 1)) as RichTextLabel
	row.kill = stat.get_node("Kill" + str(idx + 1)) as Label
	row.dead = stat.get_node("Dead" + str(idx + 1)) as Label
	row.capture = stat.get_node("Capture" + str(idx + 1)) as Label
	row.score = stat.get_node("Score" + str(idx + 1)) as Label
	rows.append(row)


func update_score_board():
	player_team_score_infos.sort_custom(sort_score_info)
	enemy_team_score_infos.sort_custom(sort_score_info)
	
	for i in range(4):
		update_row(player_rows[i], player_team_score_infos[i], true)
		update_row(enemy_rows[i], enemy_team_score_infos[i], false)


func sort_score_info(a: ScoreInfo, b: ScoreInfo):
	# 分数高且先到达该分数的排前面
	if a.score == b.score:
		return a.timestamp < b.timestamp
	return a.score > b.score


func update_row(row: BoardLabelRow, score_info: ScoreInfo, player_team: bool):
	row.name.text = name_bbcode_wrapper(score_info.name, player_team)
	row.kill.text = str(score_info.kill)
	row.dead.text = str(score_info.dead)
	row.capture.text = str(score_info.capture)
	row.score.text = str(score_info.score)


func name_bbcode_wrapper(name: String, player_team: bool) -> String:
	return ("[center][color=green]" if player_team else "[center][color=red]") \
			+ name + "[/color][/center]"


func recalc_score(score_info: ScoreInfo):
	score_info.score = score_info.kill * kill_score + score_info.dead * dead_score \
			+ score_info.capture * capture_score
	score_info.timestamp = Time.get_unix_time_from_system()


func handle_actor_inited(actor: Actor):
	var score_info := ScoreInfo.new()
	score_info.name = actor.name
	score_info.timestamp = Time.get_unix_time_from_system()
	name_to_score_info_dict[actor.name] = score_info
	if actor.team.side == Team.Side.PLAYER:
		player_team_score_infos.append(score_info)
	else:
		enemy_team_score_infos.append(score_info)
	
	# TODO: 现在代码和场景里都是写死的数量，后续优化
	if name_to_score_info_dict.size() == 8:
		update_score_board()


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
