extends Control
# 参考文档： https://godotsteam.com/tutorials/lobbies/#__tabbed_1_2


const pre = preload("res://godotsteam_xiaoye/friend_item.tscn")

var lobby_max_members: int = 4
var lobby_id: int = 0
var lobby_data
var lobby_members_max: int = 10
var lobby_vote_kick: bool = false
var steam_id: int = 0
var steam_username: String = ""

@onready var in_lobby_users_vbox: VBoxContainer = $InLobbyUsersScroll/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSteam.open_global_steam()
	# 加载好友
	load_friends()
	
	# 大厅相关信号初始化
	Steam.join_requested.connect(_on_lobby_join_requested)
	Steam.lobby_chat_update.connect(_on_lobby_chat_update)
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_data_update.connect(_on_lobby_data_update)
	Steam.lobby_invite.connect(_on_lobby_invite)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_message.connect(_on_lobby_message)
	Steam.persona_state_change.connect(_on_persona_change)
	# Check for command line arguments
	#check_command_line()


func load_friends():
	var array = Steam.getUserSteamFriends()
	var vbox = $ScrollContainer/VBoxContainer
	if vbox.get_child_count() > 0:
		for child in vbox.get_children():
			child.queue_free()
	for friend in array:
		var ins = pre.instantiate()
		vbox.add_child(ins)
		ins.set_data(friend)
		ins.invite_button_pressed.connect(_on_invite_button_pressed)


func check_command_line() -> void:
	var these_arguments: Array = OS.get_cmdline_args()
	# There are arguments to process
	if these_arguments.size() <= 0:
		return
	# A Steam connection argument exists
	if these_arguments[0] != "+connect_lobby":
		return
	# Lobby invite exists so try to connect to it
	if int(these_arguments[1]) <= 0:
		return
	# At this point, you'll probably want to change scenes
	# Something like a loading into lobby screen
	print("Command line lobby ID: %s" % these_arguments[1])
	join_lobby(int(these_arguments[1]))


func join_lobby(this_lobby_id: int) -> void:
	print("Attempting to join lobby %s" % lobby_id)
	# Clear any previous lobby members lists, if you were in a previous lobby
	GlobalSteam.lobby_members.clear()
	# Make the lobby join request to Steam
	Steam.joinLobby(this_lobby_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# 邀请好友
func _on_invite_button_pressed(steam_id: int) -> void:
	if lobby_id != 0:
		Steam.inviteUserToLobby(lobby_id, steam_id)


# 创建房间
func _on_create_lobby_button_pressed() -> void:
	# Make sure a lobby is not already set
	if lobby_id == 0:
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, lobby_max_members)
	# Lobby Type Enums			Values	Descriptions
	# LOBBY_TYPE_PRIVATE		0		The only way to join the lobby is from an invite.
	# LOBBY_TYPE_FRIENDS_ONLY	1		Joinable by friends and invitees, but does not show up in the lobby list.
	# LOBBY_TYPE_PUBLIC			2		Returned by search and visible to friends.
	# LOBBY_TYPE_INVISIBLE		3		Returned by search, but not visible to other friends.


func _on_lobby_join_requested(this_lobby_id: int, friend_id: int) -> void:
	# Get the lobby owner's name
	var owner_name: String = Steam.getFriendPersonaName(friend_id)
	print("Joining %s's lobby..." % owner_name)
	# Attempt to join the lobby
	join_lobby(this_lobby_id)


func _on_lobby_chat_update(this_lobby_id: int, change_id: int, making_change_id: int, chat_state: int) -> void:
	# Get the user who has made the lobby change
	var changer_name: String = Steam.getFriendPersonaName(change_id)
	# If a player has joined the lobby
	if chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
		print("%s has joined the lobby." % changer_name)
	# Else if a player has left the lobby
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
		print("%s has left the lobby." % changer_name)
	# Else if a player has been kicked
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_KICKED:
		print("%s has been kicked from the lobby." % changer_name)
	# Else if a player has been banned
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_BANNED:
		print("%s has been banned from the lobby." % changer_name)
	# Else there was some unknown change
	else:
		print("%s did... something." % changer_name)
	# Update the lobby now that a change has occurred
	get_lobby_members()


func _on_lobby_created(connect: int, this_lobby_id: int) -> void:
	if connect == 1:
		# Set the lobby ID
		lobby_id = this_lobby_id
		print("Created a lobby: %s" % lobby_id)
		# Set this lobby as joinable, just in case, though this should be done by default
		Steam.setLobbyJoinable(lobby_id, true)
		# Set some lobby data
		Steam.setLobbyData(lobby_id, "name", GlobalSteam.steam_username + "'s Lobby")
		Steam.setLobbyData(lobby_id, "mode", "GodotSteam test")
		# Allow P2P connections to fallback to being relayed through Steam if needed
		var set_relay: bool = Steam.allowP2PPacketRelay(true)
		print("Allowing Steam to be relay backup: %s" % set_relay)


func _on_lobby_data_update() -> void:
	pass


func _on_lobby_invite(inviter: int, lobby: int, game: int) -> void:
	print("你不需要选择，邀请了就直接自动加入房间！（好惨啊，被迫） lobby: ", lobby)
	Steam.joinLobby(lobby)


func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	# If joining was successful
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		# Set this lobby ID as your lobby ID
		lobby_id = this_lobby_id
		# Get the lobby members
		get_lobby_members()
		$StartGameButton.visible = Steam.getLobbyOwner(lobby_id) == GlobalSteam.steam_id
		# Make the initial handshake
		make_p2p_handshake()
	# Else it failed for some reason
	else:
		# Get the failure reason
		var fail_reason: String
		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST: fail_reason = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED: fail_reason = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL: fail_reason = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR: fail_reason = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED: fail_reason = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED: fail_reason = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED: fail_reason = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN: fail_reason = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU: fail_reason = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER: fail_reason = "A user you have blocked is in the lobby."
		print("Failed to join this chat room: %s" % fail_reason)
		#Reopen the lobby list
		_on_open_lobby_list_pressed()


func make_p2p_handshake() -> void:
	print("Sending P2P handshake to the lobby")
	GlobalSteam.send_p2p_packet(0, {"message": "handshake", "from": steam_id})


func get_lobby_members() -> void:
	# Clear your previous lobby list
	GlobalSteam.lobby_members.clear()
	for item in in_lobby_users_vbox.get_children():
		item.queue_free()
	# Get the number of members from this lobby from Steam
	var num_of_members: int = Steam.getNumLobbyMembers(lobby_id)
	# Get the data of these players from Steam
	for this_member in range(0, num_of_members):
		# Get the member's Steam ID
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, this_member)
		# Get the member's Steam name
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		# Add them to the list
		var obj: Dictionary = {"id":member_steam_id, "name":member_steam_name, "status": 1}
		GlobalSteam.lobby_members.append(obj)
		
		# 添加到画面上
		var ins = pre.instantiate()
		in_lobby_users_vbox.add_child(ins)
		ins.set_data(obj)


func _on_open_lobby_list_pressed() -> void:
	# Set distance to worldwide
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	print("Requesting a lobby list")
	Steam.requestLobbyList()
	# Before requesting the lobby list with requestLobbyList() you can add more search queries like:
	# - addRequestLobbyListStringFilter()
	# Allows you to look for specific works in the lobby metadata
	# - addRequestLobbyListNumericalFilter()
	# Adds a numerical comparions filter (<=, <, =, >, >=, !=)
	# - addRequestLobbyListNearValueFilter()
	# Gives results closes to the specified value you give
	# - addRequestLobbyListFilterSlotsAvailable()
	# Only returns lobbies with a specified amount of open slots available
	# - addRequestLobbyListResultCountFilter()
	# Sets how many results you want returned
	# - addRequestLobbyListDistanceFilter()
	# Sets the distance to search for lobbies, like:
	# Lobby Distance Enums				Values	Checking Distances
	# LOBBY_DISTANCE_FILTER_CLOSE		0		Close
	# LOBBY_DISTANCE_FILTER_DEFAULT		1		Default
	# LOBBY_DISTANCE_FILTER_FAR			2		Far
	# LOBBY_DISTANCE_FILTER_WORLDWIDE	3		Worldwide


func _on_lobby_match_list(these_lobbies: Array) -> void:
	for this_lobby in these_lobbies:
		# Pull lobby data from Steam, these are specific to our example
		var lobby_name: String = Steam.getLobbyData(this_lobby, "name")
		var lobby_mode: String = Steam.getLobbyData(this_lobby, "mode")
		# Get the current number of members
		var lobby_num_members: int = Steam.getNumLobbyMembers(this_lobby)
		# Create a button for the lobby
		var lobby_button: Button = Button.new()
		lobby_button.set_text("Lobby %s: %s [%s] - %s Player(s)" % [this_lobby, lobby_name, lobby_mode, lobby_num_members])
		lobby_button.set_size(Vector2(800, 50))
		lobby_button.set_name("lobby_%s" % this_lobby)
		lobby_button.connect("pressed", Callable(self, "join_lobby").bind(this_lobby))
		# Add the new lobby to the list
		$Lobbies/Scroll/List.add_child(lobby_button)


func _on_lobby_message() -> void:
	pass


# A user's information has changed
func _on_persona_change(this_steam_id: int, _flag: int) -> void:
	# Make sure you're in a lobby and this user is valid or Steam might spam your console log
	if lobby_id > 0:
		print("A user (%s) had information change, update the lobby list" % this_steam_id)
		# Update the player list
		get_lobby_members()


# 发送消息
func _on_send_button_pressed() -> void:
	# Get the entered chat message
	var this_message: String = $Lobbies/ChatHBox/LineEdit.get_text()
	# If there is even a message
	if this_message.length() > 0:
		# Pass the message to Steam
		var was_sent: bool = Steam.sendLobbyChatMsg(lobby_id, this_message)
		# Was it sent successfully?
		if not was_sent:
			print("ERROR: Chat message failed to send.")
	# Clear the chat input
	$Lobbies/ChatHBox/LineEdit.clear()


# 离开房间
func _on_leave_lobby_button_pressed() -> void:
	# If in a lobby, leave it
	if lobby_id != 0:
		# Send leave request to Steam
		Steam.leaveLobby(lobby_id)
		for item in in_lobby_users_vbox.get_children():
			item.queue_free()
		# Wipe the Steam lobby ID then display the default lobby ID and player list title
		lobby_id = 0
		# Close session with all users
		for this_member in GlobalSteam.lobby_members:
			# Make sure this isn't your Steam ID
			if this_member['id'] != steam_id:
				# Close the P2P session
				Steam.closeP2PSessionWithUser(this_member['id'])
		# Clear the local lobby list
		GlobalSteam.lobby_members.clear()


func _on_start_game_button_pressed() -> void:
	if Steam.getLobbyOwner(lobby_id) != GlobalSteam.steam_id:
		print("你非房主，不能开始游戏")
		return
	GlobalSteam.node_rpc_sync(self, "start")


func start() -> void:
	get_tree().change_scene_to_file("res://godotsteam_xiaoye/game.tscn")
