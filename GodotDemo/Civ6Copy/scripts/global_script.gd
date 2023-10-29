extends Node


const NULL_COORD := Vector2i(-10000, -10000)

# 是否加载地图
static var load_map: bool = false

# 游戏玩家相关
var player_idx: int = 0
var player_arr: Array[Player] = []


func get_current_player() -> Player:
	if player_arr.size() == 0:
		add_player(Player.new())
	return player_arr[player_idx]


func add_player(player: Player) -> void:
	player_arr.append(player)
