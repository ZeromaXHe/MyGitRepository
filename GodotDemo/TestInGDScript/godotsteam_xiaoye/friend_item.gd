extends HBoxContainer


signal invite_button_pressed(steam_id)

# Steam ID
var steam_id: int
# 用户状态
var status: int
# 头像
var avatar: Image = null

@onready var texture_rect: TextureRect = $TextureRect
@onready var name_label: Label = $VBoxContainer/Name
@onready var online_label: Label = $VBoxContainer/Online
@onready var invite_button: Button = $InviteButton


func _ready() -> void:
	Steam.avatar_loaded.connect(_on_steam_avatar_loaded)


func set_data(json: Dictionary) -> void:
	steam_id = json["id"]
	name_label.text = json["name"]
	# 需要把 Mouse - Filter 置为 Pass 或 Stop，悬浮提示才能生效
	name_label.tooltip_text = json["name"]
	status = json["status"]
	set_status()
	Steam.getPlayerAvatar(Steam.AVATAR_LARGE, steam_id)


# 对应文档： 
# https://godotsteam.com/classes/friends/#avatar_loaded
# https://godotsteam.com/tutorials/avatars/#__tabbed_2_2
func _on_steam_avatar_loaded(user_id: int, avatar_size: int, avatar_buffer: PackedByteArray) -> void:
	if user_id == steam_id and avatar == null:
		print("loading ", steam_id, "'s avatar")
		# Create the image and texture for loading
		avatar = Image.create_from_data(avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)
		# Optionally resize the image if it is too large
		if avatar_size > 128:
			avatar.resize(128, 128, Image.INTERPOLATE_LANCZOS)
		# Apply the image to a texture
		var avatar_texture: ImageTexture = ImageTexture.create_from_image(avatar)
		# Set the texture to a Sprite, TextureRect, etc.
		texture_rect.texture = avatar_texture


func set_status():
	var text: String
	match status:
		0:
			text = "离线"
		1:
			text = "在线"
		2:
			text = "忙碌"
		3:
			text = "离开"
		4:
			text = "离开很久 Zzz"
		_:
			text = "其他状态"
	# 离线时不可邀请
	invite_button.disabled = status == 0
	online_label.text = text


func _on_invite_button_pressed() -> void:
	if status == 0:
		print("用户不在线")
	else:
		invite_button_pressed.emit(steam_id)
