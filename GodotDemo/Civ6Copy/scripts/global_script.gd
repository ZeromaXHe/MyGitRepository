# 自动加载的脚本需要作为场景隐藏根节点下的节点，所以必须继承 Node
extends Node


signal load_info_changed(info: String)

const NULL_COORD := Vector2i(-10000, -10000)

# 是否加载地图
static var load_map: bool = false

# 加载页面相关
var load_scene_path: String
var load_info: String = "加载中...":
	set(str):
		load_info = str
		load_info_changed.emit(str)
var loaded_scene: PackedScene
# 计时相关
var last_time_record: int
# 游戏玩家相关
var player_idx: int = 0
var player_arr: Array[Player] = []


func record_time() -> void:
	last_time_record = Time.get_ticks_msec()


func log_used_time_from_last_record(method_name: String, action_name: String) -> void:
	var new_time_record: int = Time.get_ticks_msec()
	print("%s | %s cost: %d ms" % [method_name, action_name, new_time_record - last_time_record])
	last_time_record = new_time_record


func get_current_player() -> Player:
	if player_arr.size() == 0:
		add_player(Player.new())
	return player_arr[player_idx]


func add_player(player: Player) -> void:
	player_arr.append(player)
