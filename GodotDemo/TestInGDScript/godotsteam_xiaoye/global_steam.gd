extends Node
# 参考文档：https://godotsteam.com/tutorials/initializing/


var steam_id: int
var steam_username: String
var lobby_members: Array = []

var open: bool = false


func _init() -> void:
	# Set your game's Steam app ID here
	# 480 对应 Space War 这个游戏
	OS.set_environment("SteamAppId", str(480))
	OS.set_environment("SteamGameId", str(480))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if open:
		open_global_steam()


func open_global_steam() -> void:
	open = true
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
	if not open:
		return
	Steam.run_callbacks()
	read_p2p_packet()


# 参考文档： https://godotsteam.com/tutorials/p2p/#__tabbed_3_2
func read_p2p_packet() -> void:
	var packet_size: int = Steam.getAvailableP2PPacketSize(0)
	# There is a packet
	if packet_size > 0:
		var this_packet: Dictionary = Steam.readP2PPacket(packet_size, 0)
		if this_packet.is_empty() or this_packet == null:
			print("WARNING: read an empty packet with non-zero size!")
		# Get the remote user's ID
		var packet_sender: int = this_packet['steam_id_remote']
		# Make the packet data readable
		var packet_code: PackedByteArray = this_packet['data']
		var readable_data: Dictionary = bytes_to_var(packet_code)
		# Print the packet to output
		print("Packet: %s" % readable_data)
		# Append logic here to deal with packet data
		if readable_data['message'] == "rpc":
			var node = get_node(readable_data['node'])
			node.callv(readable_data['func_name'], readable_data['args'])
		elif readable_data['message'] == "reset":
			var node = get_node(readable_data['node'])
			node.set(readable_data['key'], readable_data['value'])


# 参考文档： https://godotsteam.com/tutorials/p2p/#__tabbed_3_2
func send_p2p_packet(this_target: int, packet_data: Dictionary) -> void:
	# Set the send_type and channel
	var send_type: int = Steam.P2P_SEND_RELIABLE
	var channel: int = 0
	# Create a data array to send the data through
	var this_data: PackedByteArray
	this_data.append_array(var_to_bytes(packet_data))
	# If sending a packet to everyone
	if this_target == 0:
		# If there is more than one user, send packets
		if lobby_members.size() > 1:
			# Loop through all members that aren't you
			for this_member in lobby_members:
				if this_member['id'] != steam_id:
					Steam.sendP2PPacket(this_member['id'], this_data, send_type, channel)
	# Else send it to someone specific
	else:
		Steam.sendP2PPacket(this_target, this_data, send_type, channel)


# rpc 远程方法调用
func node_rpc(node: Node, func_name: String, args: Array = []) -> void:
	send_p2p_packet(0, {"message": "rpc", "node": node.get_path(), "func_name": func_name, "args": args})


# 远程调用并执行本地方法
func node_rpc_sync(node: Node, func_name: String, args: Array = []) -> void:
	node_rpc(node, func_name, args)
	node.callv(func_name, args)


# rpc 远程修改值
func node_reset(node: Node, key: String, value) -> void:
	send_p2p_packet(0, {"message": "reset", "node": node.get_path(), "key": key, "value": value})


# rpc 远程修改值并本地调用
func node_reset_sync(node: Node, key: String, value) -> void:
	node_reset(node, key, value)
	node.set(key, value)
