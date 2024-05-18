extends Node
# 参考文档：https://godotsteam.com/tutorials/initializing/


var steam_id: int
var steam_username: String

func _init() -> void:
	# Set your game's Steam app ID here
	# 480 对应 Space War 这个游戏
	OS.set_environment("SteamAppId", str(480))
	OS.set_environment("SteamGameId", str(480))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_steam()
	get_steam_data()


func initialize_steam() -> void:
	# By default, steamInitEx() will query Steamworks for the local user's current statistics
	# 默认情况下，steamInitEx() 将查询 Steamworks 来获取本地用户的当前统计信息
	# and send this data back as a callback (signal). 
	# 并且作为回调（信号）发送回这些数据
	# You can pass a boolean (false) to the function to prevent this behavior: steamInitEx(false).
	# 你可以通过给函数传递一个布尔值（false）的方式来防止这个行为： steamInitEx(false)
	# steamInitEx() will always send back a dictionary with two keys / values:
	# steamInitEx() 将返回一个包含两个键值对的字典
	# - verbal - The verbose, text version of status
	# - status:
	# 		0 - Successfully initialized（成功初始化）
	# 		1 - Some other failure（其他错误）
	# 		2 - We cannot connect to Steam, steam probably isn't running（无法连接到 Steam, 可能并未运行）
	# 		3 - Steam client appears to be out of date（Steam 客户端过期）
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s " % initialize_response)
	
	if initialize_response['status'] > 0:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)
		get_tree().quit()


func get_steam_data():
	# 是否使用 Steam Deck 游玩
	var is_on_steam_deck: bool = Steam.isSteamRunningOnSteamDeck()
	# 是否在线
	var is_online: bool = Steam.loggedOn()
	# 是否拥有游戏
	var is_owned: bool = Steam.isSubscribed()
	# Steam ID
	steam_id = Steam.getSteamID()
	# Steam 用户名
	steam_username = Steam.getPersonaName()
	
	print("Steam Deck: ", is_on_steam_deck, ", online: ", is_online, ", owned: ", is_owned,
		", Steam ID: ", steam_id, ", username: ", steam_username)
	
	# 不拥有游戏就退出
	if is_owned == false:
		print("User does not own this game")
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Steam.run_callbacks()
