# 教程

## 成就图标

这个快速教程将介绍如何从 Steam 的服务器上获得成就图标。之所以制作它，是因为人们需要使用一些额外的步骤来渲染图像，否则可能不太清楚。

> 相关 GodotSteam 类和函数：
>
> - [User Stats 类](https://godotsteam.com/classes/user_stats/)
>   - [getAchievementIcon()](https://godotsteam.com/classes/user_stats/#getachievementicon)
>   - [requestCurrentStats()](https://godotsteam.com/classes/user_stats/#requestcurrentstats)
> - [Utils 类](https://godotsteam.com/classes/utils/)
>   - [getImageRGBA()](https://godotsteam.com/classes/utils/#getimagergba)
>   - [getImageSize()](https://godotsteam.com/classes/utils/#getimagesize)

### 先决条件

在你可以获得成就图标之前，你首先需要从 Steam 中检索用户的统计数据。在初始化 Steam 时，默认情况下会执行此操作，但也可以选择禁用。本教程假设您已经收到用户统计信息。如有必要，请参阅 [requestCurrentStats()](https://godotsteam.com/classes/user_stats/#requestcurrentstats) 以获取更多信息。

### 获取句柄（Handle）和缓冲区（Buffer）

首先，您需要使用您在 Steamworks 后端设置的成就 API 名称来请求图标句柄：

```gdscript
var icon_handle: int = Steam.getAchievementIcon("ACHIEVEMENT_NAME")
```

此句柄是一个 ID，用于获取有关图像大小和像素数据的字节数组（缓冲区）的信息：

```gdscript
var icon_size: Dictionary = Steam.getImageSize(icon_handle)
var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)
```

请注意，`getImageRGBA()` 函数可能有些昂贵，因此建议每个图像句柄只调用一次该函数，并在需要多次访问图像数据时缓存结果。

### 创建图片

这个缓冲区是一个字典，包含两个键：成功 `success` 和缓冲区 `buffer`，缓冲区包含我们图标的实际图像数据。然而，由于它只是二进制数据，我们需要将其加载到图像中，以便 Godot 可以将其用作纹理。当我们从 Steam 接收数据时，缓冲区中的数据格式是 RGBA8，因此我们需要告诉 Godot 如何通过指定它来理解它：

- Godot 2.x, 3.x

  ```gdscript
  var icon_image: Image = Image.new()
  icon_image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])
  ```

- Godot 4.x

  ```gdscript
  var icon_image: Image = Image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])
  ```

图像的大小由您在 Steamworks 后端配置成就时上传的图像决定。Valve 建议使用更大（256x256）的图像。如果您想以不同的大小显示图像，例如 64x64，您可以选择现在调整其大小。查看 `Image.resize()` 的 [Godot 文档](https://docs.godotengine.org/en/stable/classes/class_image.html#class-image-method-resize)，看看哪种插值模式最适合您的需求。

```gdscript
icon_image.resize(64, 64, Image.INTERPOLATE_LANCZOS)
```

现在，所有像素都设置在正确的位置，我们可以创建将显示的实际纹理：

- Godot 2.x, 3.x

  ```gdscript
  var icon_texture: ImageTexture = ImageTexture.new()
  icon_texture.create_from_image(icon_image)
  ```

- Godot 4.x

  ```gdscript
  var icon_texture: ImageTexture = ImageTexture.create_from_image(icon_image)
  ```

最后我们可以显示图标。使用前面的 `icon_texture`，我们可以将此图标放置在等待的 Sprite 或 TextureRect 等上。

```gdscript
$Sprite.texture = icon_texture
```

#### 一体化（All-In-One）

我们的完整示例应该如下所示：

- Godot 2.x, 3.x

  ```gdscript
  # 获取图片句柄(handle)
  var icon_handle: int = Steam.getAchievementIcon("ACH_WIN_ONE_GAME")
  
  # 获取图片数据
  var icon_size: Dictionary = Steam.getImageSize(icon_handle)
  var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)
  
  # 创建要加载的 Image 图片
  var icon_image: Image = Image.new()
  icon_image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])
  
  # 从图片创建一个材质
  var icon_texture: ImageTexture = ImageTexture.new()
  icon_texture.create_from_image(icon_image)
  
  # 在 Sprite 节点上展示材质
  $Sprite.texture = icon_texture
  ```

- Godot 4.x

  ```gdscript
  # 获取图片句柄(handle)
  var icon_handle: int = Steam.getAchievementIcon("ACH_WIN_ONE_GAME")
  
  # 获取图片数据
  var icon_size: Dictionary = Steam.getImageSize(icon_handle)
  var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)
  
  # 创建要加载的 Image 图片
  var icon_image: Image = Image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])
  
  # 从图片创建一个材质
  var icon_texture: ImageTexture = ImageTexture.create_from_image(icon_image)
  
  # 在 Sprite 节点上展示材质
  $Sprite.texture = icon_texture
  ```

这就是你展示成就图标的方式。

### 额外资源

#### 示例项目

要查看本教程的实际操作，[请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## 身份验证

在本教程中，我们将讨论使用 Steam 对用户进行身份验证。网络超出了本教程的范围；您将需要实现自己的网络代码。你可以查看[大厅](https://godotsteam.com/tutorials/lobbies/)和 [p2p 网络](https://godotsteam.com/tutorials/p2p/)教程了解更多信息，甚至可以使用 Godot 的高级网络。[您可以在 Steam 的文档页面上阅读更多关于整个身份验证过程的内容](https://partner.steamgames.com/doc/features/auth)。

> 相关 GodotSteam 类和函数
>
> - [User 类](https://godotsteam.com/classes/user/)
>   - [beginAuthSession()](https://godotsteam.com/classes/user/#beginauthsession)
>   - [cancelAuthTicket()](https://godotsteam.com/classes/user/#cancelauthticket)
>   - [endAuthSession()](https://godotsteam.com/classes/user/#endauthsession)
>   - [getAuthSessionTicket()](https://godotsteam.com/classes/user/#getauthsessionticket)

### 设置信号

首先，在客户端和服务器中，都需要设置两个变量：`auth_ticket` 和 `client_auth_tickets`。显然，您将在 `auth_ticket` 中保留本地客户端的票证字典，并在 `client_auth_tickets` 数组中保留所有连接的客户端的列表。稍后会详细介绍。

```gdscript
# 设置一些变量
var auth_ticket: Dictionary     # Your auth ticket
var client_auth_tickets: Array  # Array of tickets from other clients
```

现在，我们将设置身份验证回调的信号：

- Godot 2.x, 3.x

  ```gdscript
  func _ready() -> void:
  	Steam.connect("get_auth_session_ticket_response", self, "_on_get_auth_session_ticket_response")
  	Steam.connect("validate_auth_ticket_response", self, "_on_validate_auth_ticket_response")
  ```

- Godot 4.x

  ```gdscript
  func _ready() -> void:
  	Steam.get_auth_session_ticket_response.connect(_on_get_auth_session_ticket_response)
  	Steam.validate_auth_ticket_response.connect(_on_validate_auth_ticket_response)
  ```

接下来，当我们接收到信号时，我们实现各自的功能：

```gdscript
# 从 Steam 获得授权（auth）票证后的回调
func _on_get_auth_session_ticket_response(this_auth_ticket: int, result: int) -> void:
	print("Auth session result: %s" % result)
	print("Auth session ticket handle: %s" % this_auth_ticket)
```

我们的 `_on_get_auth_session_ticket_response()` 函数将打印出身份验证票证的句柄以及获取票证是否成功（返回1）。您可以根据游戏的需要添加成功或失败的逻辑。如果成功，此时您可能需要将新票证发送到服务器或其他客户端进行验证。

说到验证：

```gdscript
# 尝试验证身份验证票证的回调
func _on_validate_auth_ticket_response(auth_id: int, response: int, owner_id: int) -> void:
	print("Ticket Owner: %s" % auth_id)

	# 使响应更加冗长，非常不必要，但对本例来说很好
	var verbose_response: String
	match response:
		0: verbose_response = "Steam 已验证用户在线，票证有效，票证未被重复使用。（Steam has verified the user is online, the ticket is valid and ticket has not been reused.）"
		1: verbose_response = "有问题的用户未连接到 Steam。（The user in question is not connected to Steam.）"
		2: verbose_response = "用户没有此应用程序 ID 的许可证或票证已过期。（The user doesn't have a license for this App ID or the ticket has expired.）"
		3: verbose_response = "此游戏禁止用户使用VAC。（The user is VAC banned for this game.）"
		4: verbose_response = "用户帐户已在其他地方登录，并且包含游戏实例的会话已断开连接。（The user account has logged in elsewhere and the session containing the game instance has been disconnected.）"
		5: verbose_response = "VAC 无法对此用户执行反作弊检查。（VAC has been unable to perform anti-cheat checks on this user.）"
		6: verbose_response = "出票人已取消该票证。（The ticket has been canceled by the issuer.）"
		7: verbose_response = "此票证已被使用，无效。（This ticket has already been used, it is not valid.）"
		8: verbose_response = "此票证不是来自当前连接到 steam 的用户实例。（This ticket is not from a user instance currently connected to steam.）"
		9: verbose_response = "此游戏禁止用户使用。此禁令是通过 Web API 而非 VAC 发出的。（The user is banned for this game. The ban came via the Web API and not VAC.）"
	print("身份验证响应（Auth response）: %s" % verbose_response)
	print("游戏拥有者 ID（Game owner ID）: %s" % owner_id)
```

当票证已验证时，会接收响应 `beginAuthSession()` 的 `_on_validate_auth_ticket_response()` 函数。它会发回被授权用户的 Steam ID、验证结果（如上所示，成功为 0），最后是拥有游戏的用户的 SteamID。

[正如Valve所指出的](https://partner.steamgames.com/doc/api/ISteamUser#ValidateAuthTicketResponse_t)，如果游戏是从 Steam Family Library Sharing（家庭库共享）借来的，那么游戏的所有者和授权用户可能会有所不同。在这个功能中，你可以再次输入游戏所需的任何逻辑。显然，如果成功的话，您可能希望将客户端添加到服务器中。

### 获取您的身份验证票证

首先，您需要从 Steam 获得一个 auth 票证，并将其存储在 `auth_ticket` 字典变量中；通过这种方式，您可以根据需要将其传递给服务器或其他客户端：

```gdscript
auth_ticket = Steam.getAuthSessionTicket()
```

此函数还有一个可选 `identity`，可以传递给它，但默认为 `null`。此标识可以与使用[“网络类型”](https://godotsteam.com/classes/networking_types/)类设置的某个网络标识相对应。

现在您有了身份验证票证，您将希望将其传递给服务器或其他客户端进行验证。

### 验证身份验证票证

您的服务器或其他客户端现在需要获取您的身份验证票证，然后才能允许您加入游戏。在对等情况下，每个客户端都希望验证其他玩家的门票。服务器或客户端将希望将 `auth_ticket` 字典的缓冲区和大小以及 Steam ID 传递给 `beginAuthSession()`。为此，我们将创建一个 `validate_auth_session()` 函数：

```gdscript
func validate_auth_session(ticket: Dictionary, steam_id: int) -> void:
	var auth_response: int = Steam.beginAuthSession(ticket.buffer, ticket.size, steam_id)

	# 获得详细的响应；不必要但在本例中有用
	var verbose_response: String
	match auth_response:
		0: verbose_response = "票证对此游戏和此Steam ID有效。（Ticket is valid for this game and this Steam ID.）"
		1: verbose_response = "票证无效。（The ticket is invalid.）"
		2: verbose_response = "已经为此 Steam ID 提交了票证。（A ticket has already been submitted for this Steam ID.）"
		3: verbose_response = "票证来自不兼容的接口版本。（Ticket is from an incompatible interface version.）"
		4: verbose_response = "此游戏不提供门票。（Ticket is not for this game.）"
		5: verbose_response = "票证已过期。（Ticket has expired.）"
	print("身份校验验证响应（Auth verifcation response）: %s" % verbose_response))

	if auth_response == 0:
		print("验证成功，正在将用户添加到 client_auth_tickets")
		client_auth_tickets.append({"id": steam_id, "ticket": ticket.id})

	# 您现在可以将客户端添加到游戏中
```

如果响应为 `0`（意味着票证有效），您可以允许玩家连接到服务器或游戏。还将接收到一个回调并触发我们的 `_on_validate_auth_ticket_response()` 函数，正如我们之前看到的，该函数将连同身份验证票证提供商的 Steam ID、结果和游戏所有者的 Steam 标识一起发送。当另一个用户取消其身份验证票证时，也会触发此回调。稍后会详细介绍。

在验证票证后，您需要将玩家的 Steam ID 和票证句柄保存在 `client_auth_tickets` 数组中，作为数组或字典，以便稍后调用它们来取消身份验证会话。在上面的例子中，我们使用了一个字典，这样我们就可以根据用户的 Steam ID 来提取票证句柄。

### 取消身份验证票证并结束身份验证会话

最后，当游戏结束或客户端离开游戏时，您需要取消自己的身份验证票证，并结束与其他玩家的身份验证会话。

当客户端准备离开游戏时，他们会将自己的票证句柄传递给 `cancelAuthTicket()` 函数，如下所示：

```gdscript
Steam.cancelAuthTicket(auth_ticket.id)
```

这将触发服务器或其他客户端的 `_on_validate_auth_ticket_response()` 函数，让他们知道玩家已经离开并使他们的身份验证票证无效。此外，您还应该调用 `endAuthSession()` 来关闭与服务器或其他客户端的身份验证会话：

```gdscript
Steam.endAuthSession(steam_id)
```

您需要传递连接的每个客户端的 Steam ID。您可以在 `client_auth_tickets` 数组的循环中这样做：

```gdscript
for this_client_ticket in client_auth_tickets:
	Steam.endAuthSession(this_client_ticket.id)

	# 然后从票证数组中删除此客户端
	client_auth_tickets.erase(this_client_ticket)
```

[Steamworks 文档](https://partner.steamgames.com/doc/features/auth)规定，每个玩家必须取消自己的授权票证，并结束与其他玩家开始的任何授权会话。

这篇关于经过身份验证的会话的简单教程到此结束。

### 其他资源

#### 示例项目

要查看本教程的实际操作，[请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## 大厅自动匹配

一个快速的，被要求的教程是自动配对大厅。虽然此示例没有显示如何匹配特定的条件，但会注意到可以将这些匹配放置在何处。本教程基本上是[大厅](https://godotsteam.com/tutorials/lobbies/)和 [P2P 网络](https://godotsteam.com/tutorials/p2p/)教程的扩展。正因为如此，我们将只关注不同之处；有关更多信息和布局，请参阅上述教程。

> 相关 GodotSteam 类和函数
>
> - [Matchmaking 类](https://godotsteam.com/classes/matchmaking/)
>   - [addRequestLobbyListDistanceFilter()](https://godotsteam.com/classes/matchmaking/#addrequestlobbylistdistancefilter)
>   - [getLobbyData()](https://godotsteam.com/classes/matchmaking/#getlobbydata)
>   - [getNumLobbyMembers()](https://godotsteam.com/classes/matchmaking/#getnumlobbymembers)
>   - [joinLobby()](https://godotsteam.com/classes/matchmaking/#joinlobby)
>   - [requestLobbyList()](https://godotsteam.com/classes/matchmaking/#requestlobbylist)

### 设置

首先，让我们设置一些变量以便稍后填写：

```gdscript
var lobby_id: int = 0
var lobby_max_players: int = 2
var lobby_members: Array = []
var matchmaking_phase: int = 0
```

从大厅教程中继承的是 `lobby_id`，它显然包含大厅的 ID，以及 `lobby_members`，它将是大厅成员及其 Steam ID 64 的一系列字典。

本教程的新内容是 `matching_phase`，它跟踪我们的代码进行的匹配搜索的迭代。同样新的是 `lobby_max_players`，它用于检查大厅是否有空间容纳我们的玩家。

所有的 `_ready()` 函数回调连接都是相同的。

### 寻找大厅

出于我们的目的，我们将创建一个名为“自动匹配”的按钮，并将一个按下 `on_pressed` 的信号连接到它，称为 `_on_auto_matchmake_pressed()`。以下是按下该按钮时触发的功能：

```gdscript
# 启动自动匹配过程。
func _on_auto_matchmake_pressed() -> void:
	# 重新设置匹配流程
	matchmake_phase = 0

	# 开始循环！
	matchmaking_loop()
```

这将启动主循环，为您的玩家寻找匹配的大厅：

```gdscript
# 尝试不同距离的迭代
func matchmaking_loop() -> void:
	# 如果此 matrix_phase 为 3 或更低，请继续
	if matchmake_phase < 4:
		###
		# 为游戏模式等添加其他过滤器。
		# 由于这是一个例子，我们无法设置游戏模式或文本匹配功能。
		# 但是，您可以使用 addRequestLobbyListStringFilter 来查找特定的
		# 大厅元数据中的文本以匹配不同的条件。
		###

		# 设置距离过滤器
		Steam.addRequestLobbyListDistanceFilter(matchmake_phase)

		# 请求一个列表
		Steam.requestLobbyList()

	else:
		print("[STEAM] 未能自动将您与大厅匹配。请再试一次。")
```

正如上面代码中所指出的，在搜索大厅之前，玩家可以从中选择不同的过滤器列表。这些可以应用于 `addRequestLobbyListStringFilter()` 提前查找的术语。比如游戏模式、地图、难度等等。

非常重要的是我们的 `addRequestLobbyListDistanceFilter()` 和 `matchmake_phase` 变量。我们以 “close”/0 开头，以 “worldwide”3 结尾；因此在 4 它找不到任何东西并且提示用户重试。

这个循环函数一旦找到一些要检查的大厅，就会触发一个回调。对我们的比赛进行排序应该如下所示：

```gdscript
# 大厅列表已创建，查找可能的大厅
func _on_lobby_match_list(lobbies: Array) -> void:
	# 设置 attempting_join 为 false
	var attempting_join: bool = false

	# 展示列表
	for this_lobby in lobbies:
		# 从 Steam 拉取大厅数据
		var lobby_name: String = Steam.getLobbyData(this_lobby, "name")
		var lobby_nums: int = Steam.getNumLobbyMembers(this_lobby)

		###
		# 为游戏模式等添加其他过滤器。
		# 由于这是一个例子，我们无法设置游戏模式或文本匹配功能。
		# 但是，与 lobby_name 非常相似，您可以使用 Steam.getLobbyData 来获取其他
		# 预设的大厅定义数据，以附加到下一个 if 语句中。
		###

		# 尝试加入符合条件的第一个大厅
		if lobby_nums < lobby_max_players and not attempting_join:
			# 打开 attempting_join
			attempting_join = true
			print("尝试加入大厅...")
			Steam.joinLobby(this_lobby)

	# 没有找到匹配的大厅，进入下一阶段
	if not attempting_join:
		# 增加 matchmake_phase
		matchmake_phase += 1
		matchmaking_loop()
```

这将遍历返回的每个大厅，如果它们都不匹配，它将迭代 `matche_phase` 变量并再次开始循环，但在距离过滤器中再向前移动一步。

与前面的附加过滤器非常相似，您可以按照获取 `lobby_name` 数据的方式，按其他大厅数据进行排序。这些信息可以在创建大厅时添加到大厅中，使这一过程更容易。

第一个符合您的条件并为用户提供空间的大厅会触发 `joinLobby()` 函数，玩家应该很快就会加入他们自动找到的大厅。

### 其他资源

#### 示例项目

要查看本教程的实际操作，[请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## 头像

您可能想要获得当前玩家或其他人的头像，并将其显示在您的游戏中。本教程将引导您完成化身检索的基础知识，并将其传递给精灵，以便您可以使用它。

> 相关 GodotSteam 类和函数
>
> - [Friends 类](https://godotsteam.com/classes/friends/)
>   - [getPlayerAvatar](https://godotsteam.com/classes/friends/#getplayeravatar)

### 请求头像

获取玩家头像的默认 Steamworks 功能需要多个步骤。然而，GodotSteam 有一个独特的功能，这使得获取化身数据变得非常容易。只需使用以下内容：

```gdscript
Steam.getPlayerAvatar()
```

此函数具有可选参数。默认情况下，它将获得当前玩家的中型（64x64）头像数据。但你也可以通过 `Steam.AVATAR_SMALL`（32x32），`Steam.AVATAR_MEDIUM`（64x64）或 `Steam.AVATAR_LARGE`（128x128 或更大）可获得不同尺寸；这些枚举的数字对应项（1、2 或 3）也会起作用。此外，您可以传递 Steam ID64 来获取特定用户的头像数据。

### 检索和创建图像

要检索头像数据缓冲区，您需要挂接回调信号：

- Godot 2.x, 3.x

  ```gdscript
  Steam.connect("avatar_loaded", self, "_on_loaded_avatar")
  ```

- Godot 4.x

  ```gdscript
  Steam.avatar_loaded.connect(_on_loaded_avatar)
  ```

这将返回用户的 Steam ID、头像的大小和用于渲染图像的数据缓冲区。如果你读过[成就图标教程](https://godotsteam.com/tutorials/achievement_icons/)，这一切看起来都很熟悉。我们的 `_on_loaded_avantar` 功能将如下所示：

- Godot 2.x, 3.x

  ```gdscript
  func _on_loaded_avatar(user_id: int, avatar_size: int, avatar_buffer: PoolByteArray) -> void:
      print("用户头像: %s" % user_id)
      print("尺寸: %s" % avatar_size)
  
      # 创建要加载的图片
      avatar_image = Image.new()
      avatar_image.create_from_data(avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)
  
      # 如果图像太大，可以选择调整图像大小
      if avatar_size > 128:
          avatar_image.resize(128, 128, Image.INTERPOLATE_LANCZOS)
  
      # 将图像应用于材质
      var avatar_texture: ImageTexture = ImageTexture.new()
      avatar_texture.create_from_image(avatar_image)
  
      # 将材质设置给 Sprite、TextureRect 等。
      $Sprite.set_texture(avatar_texture)
  ```

- Godot 4.x

  ```gdscript
  func _on_loaded_avatar(user_id: int, avatar_size: int, avatar_buffer: PackedByteArray) -> void:
      print("用户头像: %s" % user_id)
      print("尺寸: %s" % avatar_size)
  
      # 创建要加载的图片和材质
      var avatar_image: Image = Image.create_from_data(avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)
  
      # 如果图像太大，可以选择调整图像大小
      if avatar_size > 128:
          avatar_image.resize(128, 128, Image.INTERPOLATE_LANCZOS)
  
      # 将图像应用于材质
      var avatar_texture: ImageTexture = ImageTexture.create_from_image(avatar_image)
  
      # 将材质设置为 Sprite、TextureRect 等。
      $Sprite.set_texture(avatar_texture)
  ```

当然，该纹理可以应用于其他地方，这取决于您放置该函数的位置。

这涵盖了获得玩家头像的基本知识。

### 其他资源

#### 视频教程

喜欢视频教程吗？饱饱眼福！

- [FinePointCGI 的“获取你的头像图片并进行处理”](https://www.youtube.com/watch?v=VCwNxfYZ8Cw&t=731s)
- [FinePointCGI 的“我们如何加载我们的朋友头像”](https://www.youtube.com/watch?v=VCwNxfYZ8Cw&t=6301s)

#### 示例项目

要查看本教程的实际操作，[请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## C#

每隔一段时间，我们就会有人问如何将 GodotSteam 与 C# 一起使用，所以我想我会写下这篇文章。首先，我从来没有使用过 C#，所以我对它的理解非常空洞。

### Mono Build 在哪里？

说到这里，GodotSteam 目前还没有 C# 版本。我正在将上述构建添加到我们的 Github Actions 列表中，以便我们可以在每次更新时开始生成它们！

### 权变措施（Workarounds）

值得庆幸的是，对于那些使用 GDExtension 版本的项目的人来说，有一个可爱的项目会有所帮助！多亏了LauraWebdev，我们有了这个很酷的插件：[GodotStream C#绑定](https://github.com/LauraWebdev/GodotSteam_CSharpBindings){target=“_blank”}

虽然我仍在努力跟上所有这些 C# 业务的进度，但您可以阅读更多关于它在 Github 上如何工作的信息。甚至还有一些优秀的示例代码！

### 其他资源

Chickensoft 上的了不起的人都是关于 C# 的，请访问这里或他们的 Discord：

- [Chickensoft 网站](https://chickensoft.games/)
- [Chickensoft Discord](https://discord.gg/MjA6HUzzAE)

通常情况下，我会将 C# 用户推荐给 Steamworks 和 C# 的两个很棒的库之一：

- [Facepunch.Steamworks，来自 Rust 和 Garry’s Mod 制作者们](https://wiki.facepunch.com/steamworks)
- [Steamworks.NET，来自 super-nice Riley Labrecque](https://steamworks.github.io/)

我不知道你是如何将这些与 Godot 实际集成的，但我们 Discord 的一些成员确实做到了。我会在某个时候尝试联系他们，为本教程添加内容。

## 好友大厅

在这个快速教程中，我们将介绍如何获取包含所有属于朋友的对用户可见的大厅的字典的方法。这是因为它是多人游戏中非常常见的功能。

> 相关 GodotSteam 类和函数
>
> - [Friends 类](https://godotsteam.com/classes/friends/)
>   - [getFriendByIndex](https://godotsteam.com/classes/friends/#getfriendbyindex)
>   - [getFriendCount](https://godotsteam.com/classes/friends/#getfriendcount)
>   - [getFriendGamePlayed](https://godotsteam.com/classes/friends/#getfriendgameplayed)
> - [Matchmaking 类](https://godotsteam.com/classes/matchmaking/)
>   - [createLobby](https://godotsteam.com/classes/matchmaking/#createlobby)
> - [Utils 类](https://godotsteam.com/classes/utils/)
>   - [getAppID](https://godotsteam.com/classes/utils/#getappid)

### 解释的函数

在查看代码示例之前，我们将首先分解要调用的不同 Steam 函数。

```gdscript
var number_of_friends: int = Steam.getFriendCount(Steam.FRIEND_FLAG_IMMEDIATE)
```

[根据 Steamworks 文档](https://partner.steamgames.com/doc/api/ISteamFriends#GetFriendByIndex)，这必须在 `getFriendByIndex()` 之前运行。我们将使用它来迭代朋友列表中的每个朋友。

```gdscript
var steam_id: int = Steam.getFriendByIndex(index, Steam.FRIEND_FLAG_IMMEDIATE)
```

在循环中，我们将调用 `getFriendByIndex()` 来获取该索引处朋友的 Steam ID。

> **注意**
>
> 您必须使用与调用 `getFriendCount()` 时使用的朋友标志相同的朋友标志。请参阅 [FriendFlags 枚举](https://godotsteam.com/classes/friends/#friendflags)以获取有效选项，并参阅[朋友标志上的 Steamworks 文档](https://partner.steamgames.com/doc/api/ISteamFriends#EFriendFlags)以了解其含义。

```gdscript
var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)
```

有了朋友的 Steam ID，我们现在可以获得朋友可能正在玩或不在玩的游戏的信息。

如果朋友离线或未玩游戏，此词典将为空。否则，以下是此字典中的字段和可能的值：

- **id**: int
  - 他们正在玩的游戏的应用程序 ID。
- **lobby**：int **或** String
  - 如果朋友在该用户可见的大厅中，则它将是大厅 ID 的 int
  - 否则，它将是一个等于：`"No valid lobby"` 的字符串
- **ip**: 字符串
- **game_port**: int
- **query_port**: int
  - 取决于大厅设置，但 `ip`、`game_port` 和 `query_port` 可能都是零。

### 把它放在一起

```gdscript
func get_lobbies_with_friends() -> Dictionary:
	var results: Dictionary = {}

	for i in range(0, Steam.getFriendCount()):
		var steam_id: int = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_IMMEDIATE)
		var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)

		if game_info.empty():
			# 这个朋友不在玩游戏
			continue
		else:
			# 他们在玩游戏，则检查是不是和我们的游戏一样
			var app_id: int = game_info['id']
			var lobby = game_info['lobby']

			if app_id != Steam.getAppID() or lobby is String:
				# 要么不在这个游戏中，要么不在大厅里
				continue

			if not results.has(lobby):
				results[lobby] = []

			results[lobby].append(steam_id)

	return results
```

如果你想取回 `friend_id -> lobby_id` 的字典，你可以使用：

```gdscript
func get_friends_in_lobbies() -> Dictionary:
	var results: Dictionary = {}

	for i in range(0, Steam.getFriendCount()):
		var steam_id: int = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_IMMEDIATE)
		var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)

		if game_info.empty():
			# 这个朋友不在玩游戏
			continue
		else:
			# 他们在玩游戏，则看看这是不是和我们的游戏一样
			var app_id: int = game_info['id']
			var lobby = game_info['lobby']

			if app_id != Steam.getAppID() or lobby is String:
				# 要么不在这个游戏中，要么不在大厅里
				continue

			results[steam_id] = lobby

	return results
```

从这里，您可以随心所欲地创建 UI，并在用户做出选择时简单地调用 `joinLobby(lobby_id)`。

### 检查朋友是否仍在大厅

在可能的情况下，您不是每帧都运行 `get_lobbies_with_friends()`，用户可能会点击朋友离开的大厅，或者更糟的是，点击一个不再存在的大厅。

这是您在加入大厅之前可以做的一个小检查：

```gdscript
# 检查朋友是否在大厅内
func is_a_friend_still_in_lobby(steam_id: int, lobby_id: int) -> bool:
	var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)

	if game_info.empty():
		return false

	# 他们正在游戏中
	var app_id: int = game_info.id
	var lobby = game_info.lobby

	# 如果他们在同一个游戏中并且具有相同的 lobby_id，则返回 true
	return app_id == Steam.getAppID() and lobby is int and lobby == lobby_id
```

### 故障排除

如果在测试时没有看到任何大厅，请确保检查标志以了解大厅是如何创建的。

例如，您将无法看到带有此标志的大厅：

```gdscript
Steam.create_lobby(Steam.LOBBY_TYPE_INVISIBLE, 8)
```

如果大厅的配置方式是你看不见的，或者在最大容量时，Steam 不会提供大厅 ID。

## 初始化 Steam

在本教程中，我们将介绍 Steamworks 在游戏中的基本初始化；以及在全球范围内获得回调。如果你在工作中遇到问题，请查看常见问题教程。

请注意，本教程仅适用于 GodotSteam 的模块和 GDExtension 版本；GDNative 版本已经在 steam.gd 自动加载脚本中提供了这些函数。

> 相关 GodotSteam 类和函数

### 准备

在我们进一步讨论之前，如果您还没有在项目中启用日志，建议您启用日志。这将有助于您和我们调试您今后可能遇到的任何问题。

当然，如果你有一个自定义的日志记录系统，不要担心这一点。

- Godot 2.x、3.x
  - 要在 Godot 编辑器中启用日志记录，请转到：**项目 > 项目设置 > 日志 > 文件日志**（**Projects > Project Settings > Logging > File Logging**），然后选中**启用文件日志**（**Enable File Logging**）。这将开始将日志放置在项目的用户数据文件夹中。你可能会问，这些在哪里？[查看官方Godot Engine文档以查找位置](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html?highlight=user%20data)。
- Godot 4.x
  - 要在 Godot 编辑器中启用日志记录，请转到：**项目 > 项目设置 > 调试 > 文件日志**（**Projects > Project Settings > Debug > File Logging**），然后选中**启用文件日志**（**Enable File Logging**）。这将开始将日志放置在项目的用户数据文件夹中。你可能会问，这些在哪里？[查看官方Godot Engine文档以查找位置](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html?highlight=user%20data)。

### Steam 应用程序 ID

当游戏通过 Steam 客户端运行时，它已经知道你在玩哪个游戏。但是，在开发和测试过程中，您必须以某种方式提供有效的应用程序 ID。通常，如果你还没有应用程序 ID，你可以使用应用程序 ID 480，这是 Valve 的太空战争（SpaceWar）示例游戏。

您可以通过以下三种方式之一设置应用程序 ID，具体取决于最简单的方式：

#### 方法 1：steam_appid.txt

创建一个 steam_appid.txt 文件，并仅以应用程序 ID 作为文本。此文件必须位于您的常规 Godot 或启用 GodotSteam 的编辑器所在的位置。不过，在插件的情况下，有时它必须在项目的根目录中才能正常工作。

此外，在将游戏发送到 Steam 时，不要包含此文件，因为它不是必需的。当然，如果你这样做，不会有任何伤害。

#### 方法 2：将其传递给初始化

您可以将应用程序 ID 传递给 `steamInit` 或 `steamInitEx`，以便在初始化期间进行设置。这将是通过的第二个参数；第一个问题是是否希望在初始化期间提取本地用户的统计信息和成就。例如

```gdscript
var initialize_response: Dictionary = steamInitEx( true, 480 )
print("Did Steam initialize?: %s " % initialize_response)
```

如果使用此方法，你**必须**给第一个参数传递 true 或 false。

> **注意**
>
> GDNative 中不存在此功能。它只存在于 GodotSteam 3.22 及更高版本的 Godot3.x 和 GodotSteam4.5 及更高级别的 Godot4.x 和 GDExtension 中。

#### 方法 3：设置环境变量

您可以在自动加载 GDscript 或要运行的第一个 GDscript 中设置两个环境变量；最好是运行 Steam 初始化函数的脚本，最好是在 `_init()` 函数中。例如

```gdscript
func _init() -> void:
	# 在这里设置你游戏的 Steam 应用 ID
	OS.set_environment("SteamAppId", str(480))
	OS.set_environment("SteamGameId", str(480))
```

感谢用户 B0TLANNER 提供此方法。

### 初始化 Steam

在我的个人项目中，我通常会创建一个名为 `global.gd` 的自动加载 GDscript，它被添加为单例（singleton）。

然后，我创建一个名为 `initialize_stream()` 的函数，并添加下面的代码。这是从我的 `global.gd` 中的 `_ready()` 函数调用的：

```gdscript
func _ready() -> void:
	initialize_steam()


func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Steam 初始化了吗？: %s " % initialize_response)
```

默认情况下，`steamInitEx()` 将向 Steamworks 查询本地用户的当前统计信息，并将此数据作为回调（信号）发送回。您可以向函数传递一个布尔值（false）来防止这种行为：`steamInitEx(false)`。

`steamInitEx()` 将始终发回一个包含两个键/值的字典：

- **verbal** - 状态的详细文本版本
- **status**
  - 0 - 已成功初始化
  - 1 - 其他故障
  - 2 - 我们无法连接到 Steam，Steam 可能没有运行
  - 3 - Steam 客户端似乎已过时

### 检查错误

`steamInitEx()` 返回的字典可以打印并忽略。然而，在某些情况下，你可能不知道为什么游戏在启动时崩溃或发生了意想不到的事情；尤其是在开发时。对于这些情况，我们将检查 Steamworks 是否真的初始化，如果出现任何问题，我们将停止游戏，我们这样做：

```gdscript
func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Steam 初始化了吗?: %s" % initialize_response)

	if initialize_response['status'] > 0:
		print("初始化 Steam 失败，正在关闭: %s" % initialize_response)
		get_tree().quit()
```

如果 Steam 没有初始化并返回除 0 以外的任何状态，则此代码显然会关闭游戏。您可能只想捕获故障数据并继续，尽管 Steamworks 功能无法完全工作。

大多数情况下，在开发过程中，失败可能是由于缺少 API 文件（steam_API.dll、libsteam_api.so、libsteam_api.dylib）或未通过前面提到的方法之一设置游戏的应用程序 ID 造成的。

在任何情况下，初始化函数都应该让您对它失败的原因有一个很好的了解。如果您仍然无法解决，请联系我们寻求帮助！

### 获取更多数据

您可以在初始化后立即调用大量函数来收集有关用户的更多数据；从位置、使用的语言到头像等，我们将介绍一些常用的基本内容：

```gdscript
var is_on_steam_deck: bool = Steam.isSteamRunningOnSteamDeck()
var is_online: bool = Steam.loggedOn()
var is_owned: bool = Steam.isSubscribed()
var steam_id: int = Steam.getSteamID()
var steam_username: String = Steam.getPersonaName()
```

这将检查 Steam 是否在线，应用程序是否在 Steam Deck 上运行，获取当前用户的 Steam ID64，并检查当前用户是否拥有游戏。如果当前用户不拥有游戏，您也可以通过以下操作关闭游戏：

```gdscript
if is_owned == false:
	print("用户没有拥有该游戏")
	get_tree().quit()
```

> **注意**
>
> 使用这种自主行为关闭游戏可能会导致使用家庭共享、免费周末或其他尝试游戏方法的人出现问题。还有其他函数可以检查您可能需要考虑的条件。

在 Steamworks 初始化后的启动过程中，您可能还想做其他事情，比如获取当前成就或统计数据，但我们将在另一个教程中介绍这一点。

### 回调

Steamworks 的一个非常重要的部分是从 Steam 本身获取回调，以响应不同的功能。要接收回调，您需要在某个地方运行 `run_callbacks()` 函数；最好是每帧左右。有两种方法可用：

#### 方法 1：将其添加到 `_process()`

标准方法是将 `Steam.run_callbacks()` 函数添加到 `_process()` 函数中，如下所示：

```gdscript
func _process(_delta: float) -> void:
	Steam.run_callbacks()
```

我强烈建议，就像初始化过程一样，将这个 `_process()` 函数和 `Steam.run_callbacks()` 放在全局（单例 singleton）脚本中，这样它就可以一直检查回调。但是，如果您愿意，您可以将它放在任何可能使用回调信息的给定脚本中的任何 `_process()` 函数中。

#### 方法 2：将其传递给初始化

您可以将 true 作为第三个参数传递给任一初始化函数，并让 GodotSteam 在内部检查回调。就像这样：

```gdscript
var initialize_response: Dictionary = steamInitEx(false, 480, true)
print("Steam 初始化了吗？: %s " % initialize_response)
```

但是，您必须传递前两个参数，即是否希望在初始化期间提取本地用户的统计数据和成就，以及游戏的应用程序 ID。

> **注意**
>
> 当前 GDExtension 版本中不存在该参数。这仅适用于 Godot 3.x 的 GodotSteam 3.22 或更新版本，以及 Godot 4.x 的 GodotSteam 4.5 或更新版本。

一些用户注意到，如果他们的 `run_callback` 位于可以暂停的脚本或节点中，则所述回调将无法触发。请确保此函数位于始终在处理的脚本或节点中！

### 现在合起来

把它放在一起应该会给我们这样的东西：

- 没有内部应用 ID 和回调

  ```gdscript
  extends Node
  
  # Steam 变量
  var is_on_steam_deck: bool = false
  var is_online: bool = false
  var is_owned: bool = false
  var steam_app_id: int = 480
  var steam_id: int = 0
  var steam_username: String = ""
  
  
  func _init() -> void:
  	# 在这里设置你游戏的 Steam 应用 ID
  	OS.set_environment("SteamAppId", str(steam_app_id))
  	OS.set_environment("SteamGameId", str(steam_app_id))
  
  
  func _ready() -> void:
  	initialize_steam()
  
  
  func _process(_delta: float) -> void:
  	Steam.run_callbacks()
  
  
  func initialize_steam() -> void:
  	var initialize_response: Dictionary = Steam.steamInitEx()
  	print("Steam 初始化了吗?: %s" % initialize_response)
  
  	if initialize_response['status'] > 0:
  		print("初始化 Steam 失败。正在关闭: %s" % initialize_response)
  		get_tree().quit()
  
  	# 收集其他数据
  	is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
  	is_online = Steam.loggedOn()
  	is_owned = Steam.isSubscribed()
  	steam_id = Steam.getSteamID()
  	steam_username = Steam.getPersonaName()
  
  	# 检查帐户是否拥有游戏
  	if is_owned == false:
  		print("用户不拥有此游戏")
  		get_tree().quit()
  ```

- 有内部应用 ID 和回调

  ```gdscript
  extends Node
  
  # Steam 变量
  var is_on_steam_deck: bool = false
  var is_online: bool = false
  var is_owned: bool = false
  var steam_app_id: int = 480
  var steam_id: int = 0
  var steam_username: String = ""
  
  
  func _ready() -> void:
  	initialize_steam()
  
  
  func initialize_steam() -> void:
  	var initialize_response: Dictionary = Steam.steamInitEx(false, steam_app_id, true)
  	print("Steam 初始化了吗?: %s" % initialize_response)
  
  	if initialize_response['status'] > 0:
  		print("初始化 Steam 失败。正在关闭: %s" % initialize_response)
  		get_tree().quit()
  
  	# 收集其他数据
  	is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
  	is_online = Steam.loggedOn()
  	is_owned = Steam.isSubscribed()
  	steam_id = Steam.getSteamID()
  	steam_username = Steam.getPersonaName()
  
  	# 检查账户是否拥有游戏
  	if is_owned == false:
  		print("用户不拥有此游戏")
  		get_tree().quit()
  ```

这包括初始化和基本设置。

### 其他资源

#### 视频教程

喜欢视频教程吗？饱饱眼福！

- [BluePhoenixGames 的“Godot+Steam教程”](https://www.youtube.com/watch?v=J0GrG-AffCI&t=571s)
- [FinePointCGI 的“集成Steamworks”](https://www.youtube.com/watch?v=VCwNxfYZ8Cw)
- ["Godot 4 Steam Integration"，作者：Gwizz](https://www.youtube.com/watch?v=l0b5mh2HjyE)

#### 示例项目

[要查看本教程的实际操作，请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## 排行榜

本教程将介绍为您的游戏设置排行榜。稍后我将在本教程中添加更多其他功能，但这应该涵盖使用排行榜的所有基础知识。

> 相关 GodotSteam 类和函数
>
> - [User Stats 类](https://godotsteam.com/classes/user_stats/)
>   - [findLeaderboard()](https://godotsteam.com/classes/user_stats/#findLeaderboard)
>   - [uploadLeaderboardScore()](https://godotsteam.com/classes/user_stats/#uploadLeaderboardScore)
>   - [setLeaderboardDetailsMax()](https://godotsteam.com/classes/user_stats/#setLeaderboardDetailsMax)
>   - [downloadLeaderboardEntries()](https://godotsteam.com/classes/user_stats/#downloadLeaderboardEntries)
>   - [downloadLeaderboardEntriesForUsers()](https://godotsteam.com/classes/user_stats/#downloadLeaderboardEntriesForUsers)

### 设置

首先，让我们设置信号。

- Godot 2.x, 3.x

  ```gdscript
  Steam.connect("leaderboard_find_result", self, "_on_leaderboard_find_result")
  Steam.connect("leaderboard_score_uploaded", self, "_on_leaderboard_score_uploaded")
  Steam.connect("leaderboard_scores_downloaded", self, "_on_leaderboard_scores_downloaded")
  ```

- Godot 4.x

  ```gdscript
  Steam.leaderboard_find_result.connect(_on_leaderboard_find_result)
  Steam.leaderboard_score_uploaded.connect(_on_leaderboard_score_uploaded)
  Steam.leaderboard_scores_downloaded.connect(_on_leaderboard_scores_downloaded)
  ```

我们将按顺序检查每个信号和相关函数。首先，您需要将排行榜的 Steamworks 后端名称传递给 findLeaderboard() 函数，如下所示：

```gdscript
Steam.findLeaderboard( your_leaderboard_name )
```

一旦 Steam 找到你的排行榜，它会将句柄传递回 `leaderboard_find_result` 回调。与其连接的 `_on_leaderboard_find_result()` 函数应该如下所示：

```gdscript
func _on_leaderboard_find_result(handle: int, found: int) -> void:
	if found == 1:
		leaderboard_handle = handle
		print("找到了排行榜句柄: %s" % leaderboard_handle)
	else:
		print("没找到句柄")
```

一旦你有了这个句柄，你就可以使用所有的附加功能。请注意，您不需要保存排行榜句柄，因为它存储在内部。但是，除非您将排行榜存储在本地变量中，否则一次只能使用一个排行榜。我会在本地保存一本句柄词典，如下所示：

```gdscript
var leaderboard_handles: Dictionary = {
	"top_score": handle1,
	"most_kills": handle2,
	"most_games": handlde3
	}
```

这样，在快速更新排行榜时，您可以调用所需的任何句柄。否则，您必须使用 `findLeaderboard()` 再次查询每个排行榜，然后等待回调，然后上传新的分数。如果你不经常更新排行榜或更新那么多排行榜，那么使用内部存储的句柄可能会很好。

### 上传分数

在我们可以下载分数之前，我们需要上传它们。函数本身非常简单：

```gdscript
Steam.uploadLeaderboardScore( score, keep_best, details, handle )
```

第一个入参显然是分数。第二个是，无论分数是否高于用户的当前分数，都希望更新分数。第三个是细节，必须是整数；它们基本上可以是任何东西，但[以下是Valve对此的看法](https://partner.steamgames.com/doc/api/ISteamUserStats#UploadLeaderboardScore)。第四个是我们正在更新的排行榜句柄。但是，如果要使用内部存储的句柄，则不必传递句柄。

一旦你将分数传递给 Steam，你应该会收到来自 `leaderboard_score_uplooaded` 的回调。这将触发我们的 `_on_leaderboard_score_uploaded()` 函数：

```gdscript
func _on_leaderboard_score_uploaded(success: int, this_handle: int, this_score: Dictionary) -> void:
	if success == 1:
		print("Successfully uploaded scores!")
		# 添加额外的逻辑以使用传递回来的其他变量
	else:
		print("Failed to upload scores!")
```

在大多数情况下，你只是在寻找 1 的成功来证明它是有效的。然而，您可以在游戏中使用信号传回的额外变量作为逻辑。它们包含在名为 `this_score` 的字典中，该字典包含以下密钥：

- **score**：目前的新分数
- **score_changed**：如果分数发生更改（0 如果为 false，1 如果为 true）
- **new_rank**：该玩家的新全局排名
- **prev_rank**：该玩家之前的等级

#### 传递额外细节

如果你想传递更多细节，以下是 **sepTN** 的一些巧妙提示：

> 您可以添加小数据作为细节，例如将字符名称（作为字符串）嵌入排行榜条目中。如果你试图放置比可能大的细节，它会忽略它。要检索它，你需要再次处理它，因为 Steam 会吐出数组（PackedInt32Array）。

以下是一些共享的代码：

- Godot 2.x, 3.x

  ```gdscript
  # 据我所知，Godot 2 和 3 对于 to_int32_array 没有等价物。欢迎任何更正！
  #
  Steam.uploadLeaderboardScore(score, keep_best, var2bytes(details), handle)
  ```

- Godot 4.x

  ```gdscript
  Steam.uploadLeaderboardScore(score, keep_best, var_to_bytes(details).to_int32_array(), handle)
  ```

当您下载这些分数并需要将我们的分数详细信息恢复到可读的状态时，请确保分别在 Godot 4 和 Godot 3 上使用 `bytes_to_var()` 或 `bytes2var()` 将其反转。

### 下载分数

#### 是否设置最大详细信息

当然，您会希望向玩家显示排行榜分数。但在我们提取任何排行榜条目之前，我们需要通过设置 `setLeaderboardDetailsMax()` 函数来设置每个条目包含的最大详细信息量：

```gdscript
var details_max: int = Steam.setLeaderboardDetailsMax( value )
print("最大详细信息: %s" % details_max)
```

在 GodotSteam 4.6 或更高版本中，默认情况下，该值设置为 0，但您可能需要将其更改为与您上传的详细信息数量和上一节的分数相匹配。如果你没有保存分数的任何细节，你可以放心地忽略这一部分，继续请求排行榜条目。

在 GodotSteam 4.6.1及更高版本中，最大排行榜详细信息的默认值为 256 或 Steam 最大值。此更改使您不再需要先调用 `setLeaderboardDetailsMax()`；只有当您想更改最大值或关闭详细信息时。

#### 获取分数

在大多数情况下，您希望使用 `downloadLeaderboardEntries()`，但也可以通过将用户的 Steam ID 数组传递给它来使用 `downloadLeaderboardEntriesForUsers()`。两者都将使用相同的回调进行响应，但 `downloadLeaderboardEntriesForUsers()` 不允许对您的请求进行太多控制：

```gdscript
Steam.downloadLeaderboardEntries( 1, 10, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL, leaderboard_handle )

Steam.downloadLeaderboardEntriesForUsers( user_array, leaderboard_handle )
```

就像上传一样，如果您使用内部存储的排行榜句柄，下载分数不需要包含排行榜句柄。你会注意到，正如我上面提到的， `downloadLeaderboardEntriesForUsers()` 只接受用户的 Steam ID 数组作为它的另一个参数，而 `downloadLeaderboardEntries()` 有很多其他参数；我们现在就来具体介绍。

第一个参数是您开始使用的条目的索引；对于您的第一个请求，这通常是 1。第二个参数是要检索的最后一个索引；这个数字没有列出上限，但你可以很容易地显示，比如 10 左右。第三个参数是数据请求的类型；[您可以在 SDK 文档中阅读有关它的更多详细信息](https://partner.steamgames.com/doc/api/ISteamUserStats#ELeaderboardDataRequest)。快速概述：

| 排行榜数据请求枚举                          | 值   | 描述                                                         |
| ------------------------------------------- | ---- | ------------------------------------------------------------ |
| LEADERBOARD_DATA_REQUEST_GLOBAL             | 0    | 用于按排行榜排名的顺序范围。                                 |
| LEADERBOARD_DATA_REQUEST_GLOBAL_AROUND_USER | 1    | 用于获取相对于用户条目的条目。您可能希望在开始时使用负片，以便在用户之前获取条目。 |
| LEADERBOARD_DATA_REQUEST_FRIENDS            | 2    | 用于获取当前用户的好友的所有条目。忽略开始和结束参数。       |
| LEADERBOARD_DATA_REQUEST_USERS              | 3    | Steam 内部使用，请勿使用。                                   |

在您请求排行榜条目后，您应该会收到一个 `leaderboard_scores_downloaded` 回调，该回调将触发我们的 `_on_leaderboard _scores_downloaded()` 函数。该函数应类似于以下内容：

```gdscript
func _on_leaderboard_scores_downloaded(message: string, this_leaderboard_handle: int, result: Array) -> void:
	print("下载的分数信息: %s" % message)

	# 如果需要，请将其保存以供以后的排行榜互动使用
	var leaderboard_handle: int = this_leaderboard_handle

	# 添加逻辑以显示结果
	for this_result in result:
		# 使用返回的每个条目
```

该消息只是一个基本消息，通知您下载的状态；成功与否以及原因。发送回来的第二个片段是作为数组的结果。数组中的每个条目实际上都是一个字典，如下所示：

- **score**：该用户的分数
- **steam_id**：该用户的 Steam ID；你可以用这个来获取他们的头像、名字等。
- **global_rank**：很明显，他们在排行榜上的全球排名
- **ugc_handle**: 附加到此条目的任何 UGC 的句柄
- **details**: 与此条目一起存储的任何详细信息，以供以后使用

### 可能的偶然性

Discord 中的一位用户指出，有时 `downloadLeaderboardEntriesForUsers()` 会触发回调，但没有条目。奇怪的是，他们报告说，创建第二个排行榜，然后删除第一个排行榜可以解决这个问题。虽然我不明白为什么会出现这种情况，但如果你遇到这种情况，也许可以试试这个解决方案！

### 其他资源

#### 视频教程

喜欢视频教程吗？饱饱眼福！

- [FinePointCGI 的“如何构建排行榜”](https://www.youtube.com/watch?v=VCwNxfYZ8Cw&t=3394s)
- [《Godot 4 Steam排行榜》作者：Gwitz](https://www.youtube.com/watch?v=51qre_hodZI)

#### 示例项目

[要查看本教程的实际操作，请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## Linux 注意事项

有些用户在 Linux 上使用 Godot 和 GodotSteam 时可能会遇到一些问题。本教程页旨在介绍它们。

### GLES 2 / Mesa / 重叠碰撞

显然，使用 GLES 2 的游戏和运行 Mesa 20.3.5 至 21.2.5 的系统存在问题，导致 Steam 覆盖无法工作或游戏崩溃。到目前为止，除了使用 GLES 3 或在那个小窗口之外的 Mesa 版本外，还没有解决方案可以解决这个问题。

### Libsteam_api.so 问题

您可能会遇到以下错误：

```
error while loading shared libraries: libsteam_api.so: cannot open shared object file: No such file or directory
```

这意味着您忘记将 `libsteam_api.so` 放在可执行文件旁边。请记住将其与您已发布的游戏一起包含，如[导出和发布教程](https://godotsteam.com/tutorials/exporting_shipping/)中所述。

## 大厅

其中一个要求更高的教程是多人大厅和通过 Steam 的 P2P 网络；本教程专门介绍了大厅部分，[我们的 P2P 教程介绍了另一半](https://godotsteam.com/tutorials/p2p/)。请注意，仅以此为起点。

我还建议您在继续之前[查看本教程的“附加资源”部分](https://godotsteam.com/tutorials/lobbies/#additional-resources)。

> 相关 GodotSteam 类和函数
>
> - [Matchmaking 类](https://godotsteam.com/classes/matchmaking/)
>   - [addRequestLobbyListFilterSlotsAvailable()](https://godotsteam.com/classes/matchmaking/#addrequestlobbylistfilterslotsavailable)
>   - [addRequestLobbyListNearValueFilter()](https://godotsteam.com/classes/matchmaking/#addrequestlobbylistnearvaluefilter)
>   - [addRequestLobbyListNumericalFilter()](https://godotsteam.com/classes/matchmaking/#addrequestlobbylistnumericalfilter)
>   - [addRequestLobbyListResultCountFilter()](https://godotsteam.com/classes/matchmaking/#addrequestlobbylistresultcountfilter)
>   - [addRequestLobbyListStringFilter()](https://godotsteam.com/classes/matchmaking/#addrequestlobbyliststringfilter)
>   - [createLobby()](https://godotsteam.com/classes/matchmaking/#createlobby)
>   - [getLobbyData()](https://godotsteam.com/classes/matchmaking/#getlobbydata)
>   - [getLobbyMemberByIndex()](https://godotsteam.com/classes/matchmaking/#getlobbymemberbyindex)
>   - [getNumLobbyMembers()](https://godotsteam.com/classes/matchmaking/#getnumlobbymembers)
>   - [joinLobby()](https://godotsteam.com/classes/matchmaking/#joinlobby)
>   - [leaveLobby()](https://godotsteam.com/classes/matchmaking/#leavelobby)
>   - [requestLobbyList()](https://godotsteam.com/classes/matchmaking/#requestlobbylist)
>   - [sendLobbyChatMsg()](https://godotsteam.com/classes/matchmaking/#sendlobbychatmsg)
>   - [setLobbyData()](https://godotsteam.com/classes/matchmaking/#setlobbydata)
>   - [setLobbyJoinable()](https://godotsteam.com/classes/matchmaking/#setlobbyjoinable)
> - [Networking 类](https://godotsteam.com/classes/networking/)
>   - [allowP2PPacketRelay()](https://godotsteam.com/classes/networking/#allowp2ppacketrelay)
>   - [closeP2PSessionWithUser()](https://godotsteam.com/classes/networking/#closep2psessionwithuser)
> - [Friends 类](https://godotsteam.com/classes/friends/)
>   - [getFriendPersonaName()](https://godotsteam.com/classes/friends/#getfriendpersonaname)

### 设置

首先，让我们设置一些变量以便稍后填写：

```gdscript
const PACKET_READ_LIMIT: int = 32

var lobby_data
var lobby_id: int = 0
var lobby_members: Array = []
var lobby_members_max: int = 10
var lobby_vote_kick: bool = false
var steam_id: int = 0
var steam_username: String = ""
```

您的 Steam ID 和用户名实际上可能在不同的 GDScript 中，尤其是如果您像我[在初始化教程中提到](https://godotsteam.com/tutorials/initializing/)的那样使用 `global.gd`。最重要的是 `lobby_id`，它显然包含了大厅的 ID，以及 `lobby_members`，它将是大厅成员及其 Steam ID 64 的一系列字典。

### _ready() 函数

接下来，我们将为 Steamworks 和命令行检查器设置信号连接，如下所示：

- Godot 2.x, 3.x

  ```gdscript
  func _ready() -> void:
  	Steam.connect("join_requested", self, "_on_lobby_join_requested")
  	Steam.connect("lobby_chat_update", self, "_on_lobby_chat_update")
  	Steam.connect("lobby_created", self, "_on_lobby_created")
  	Steam.connect("lobby_data_update", self, "_on_lobby_data_update")
  	Steam.connect("lobby_invite", self, "_on_lobby_invite")
  	Steam.connect("lobby_joined", self, "_on_lobby_joined")
  	Steam.connect("lobby_match_list", self, "_on_lobby_match_list")
  	Steam.connect("lobby_message", self, "_on_lobby_message")
  	Steam.connect("persona_state_change", self, "_on_persona_change")
  
  	# 检查命令行参数
  	check_command_line()
  ```

- Godot 4.x

  ```gdscript
  func _ready() -> void:
  	Steam.join_requested.connect(_on_lobby_join_requested)
  	Steam.lobby_chat_update.connect(_on_lobby_chat_update)
  	Steam.lobby_created.connect(_on_lobby_created)
  	Steam.lobby_data_update.connect(_on_lobby_data_update)
  	Steam.lobby_invite.connect(_on_lobby_invite)
  	Steam.lobby_joined.connect(_on_lobby_joined)
  	Steam.lobby_match_list.connect(_on_lobby_match_list)
  	Steam.lobby_message.connect(_on_lobby_message)
  	Steam.persona_state_change.connect(_on_persona_change)
  
  	# 检查命令行参数
  	check_command_line()
  ```

我们将在下面逐一介绍。您注意到我们添加了对命令行参数的检查。以下是我们的基本函数：

```gdscript
func check_command_line() -> void:
	var these_arguments: Array = OS.get_cmdline_args()

	# 有一些参数需要处理
	if these_arguments.size() > 0:

		# 存在 Steam 连接参数
		if these_arguments[0] == "+connect_lobby":

			# 大厅邀请存在，所以尝试连接到它
			if int(these_arguments[1]) > 0:

				# 此时，您可能需要更改场景
				# 有点像加载到大厅屏幕
				print("命令行大厅 ID: %s" % these_arguments[1])
				join_lobby(int(these_arguments[1]))
```

如果玩家接受 Steam 邀请，或者右键单击朋友的名字，然后选择“加入游戏”或“加入大厅”，并且没有打开游戏，这一点很重要。执行任何一个操作都将使用附加命令 `+connect_lobby <Steam Lobby ID>` 启动游戏。遗憾的是，Godot 并没有真正理解这个命令参数，所以必须编写 `check_command_line()` 函数才能在这些约束条件下工作。

此外，您还需要将适当的场景名称添加到 Steamworks 网站上的 Steamworks 启动选项中。您将需要添加完整的场景路径(res://your-scene.tscn)在启动选项的 **Arguments** 行。[你可以在这个链接中阅读更多关于这方面的详细信息](https://github.com/GodotSteam/GodotSteam/issues/100)。非常感谢 **Antokolos** 回答了这个问题并提供了一个坚实的例子。

### 创建大厅

接下来，我们将设置大厅创建功能。您可能需要将此功能连接到游戏中的某个按钮：

```gdscript
func create_lobby() -> void:
	# 确保尚未设置大厅
	if lobby_id == 0:
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, lobby_max_members)
```

在本例中，我们使用变量和枚举的 `createLobby()`。第一个变量涵盖大厅的类型；我们正在使用一个对所有人开放的公共大厅。当然，您总共可以使用四种设置：

| 大厅类型枚举            | 值   | 描述                                         |
| ----------------------- | ---- | -------------------------------------------- |
| LOBBY_TYPE_PRIVATE      | 0    | 加入大厅的唯一途径是通过邀请。               |
| LOBBY_TYPE_FRIENDS_ONLY | 1    | 可由朋友和受邀者加入，但不显示在大厅列表中。 |
| LOBBY_TYPE_PUBLIC       | 2    | 通过搜索返回并对朋友可见。                   |
| LOBBY_TYPE_INVISIBLE    | 3    | 通过搜索返回，但其他朋友看不到。             |

第二个变量是允许加入大厅的最大玩家人数。此值不能设置为高于 250。

接下来，我们将介绍 Steam 的回调，即大厅已经创建：

```gdscript
func _on_lobby_created(connect: int, this_lobby_id: int) -> void:
	if connect == 1:
		# 设置大厅 ID
		lobby_id = this_lobby_id
		print("创建大厅: %s" % lobby_id)

		# 将这个大厅设置为可加入的，以防万一，尽管默认情况下应该就是这样做
		Steam.setLobbyJoinable(lobby_id, true)

		# 设置一些大厅数据
		Steam.setLobbyData(lobby_id, "name", "Gramps' Lobby")
		Steam.setLobbyData(lobby_id, "mode", "GodotSteam test")

		# 如果需要，允许 P2P 连接回退到通过 Steam 中继
		var set_relay: bool = Steam.allowP2PPacketRelay(true)
		print("允许 Steam 作为中继备份: %s" % set_relay)
```

一旦这个回调触发，您将获得您的大厅 ID，您可以将其传递给我们的 `lobby_id` 变量以供以后使用。正如注释所说，默认情况下，大厅应设置为可加入，但为了以防万一，我们将其添加到此处。你也可以让大厅无法进入。

您现在还可以设置一些大厅数据；它可以是您想要的任何**键 / 值**对。我不知道你可以设置的最大成对数量。

您会注意到，我在这一点上将 `allowP2PPacketRelay()` 设置为 true；正如注释所提到的，这允许 P2P 连接在需要时回退到通过 Steam 中继。如果您有 NAT 或防火墙问题，通常会发生这种情况。

### 获取大厅列表

现在我们可以创建大厅了，让我们查询并提取一个大厅列表。我通常有一个按钮，可以打开大厅界面，这是一个按钮列表，每个大厅一个：

```gdscript
func _on_open_lobby_list_pressed() -> void:
	# 将距离设置为“世界范围”
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)

	print("请求大厅列表")
	Steam.requestLobbyList()
```

在使用 `requestLobbyList()` 请求大厅列表之前，您可以添加更多搜索查询，如：

`addRequestLobbyListStringFilter()`
允许您在大厅元数据中查找特定作品（specific works）

`addRequestLobbyListNumericalFilter()`
添加数字比较过滤器（<=，<，=，>，>=，！=）

`addRequestLobbyListNearValueFilter()`
使结果接近您给定的指定值

`addRequestLobbyListFilterSlotsAvailable()`
仅返回具有指定数量可用空位的大厅

`addRequestLobbyListResultCountFilter()`
设置要返回的结果数

`addRequestLobbyListDistanceFilter()`
设置搜索大厅的距离，如：

| 大厅距离枚举                    | 值   | 检查距离 |
| ------------------------------- | ---- | -------- |
| LOBBY_DISTANCE_FILTER_CLOSE     | 0    | 近       |
| LOBBY_DISTANCE_FILTER_DEFAULT   | 1    | 默认     |
| LOBBY_DISTANCE_FILTER_FAR       | 2    | 远       |
| LOBBY_DISTANCE_FILTER_WORLDWIDE | 3    | 世界范围 |

一旦设置了全部、部分或不设置，就可以调用 `requestLobbyList()`。一旦它提取了您的大厅列表，它将触发回调 `_on_lobby_match_list()`。然后你可以随心所欲地在大厅里兜圈子。

在我们的示例代码中，我做了这样的事情来为每个大厅制作按钮：

- Godot 2.x, 3.x

  ```gdscript
  func _on_lobby_match_list(these_lobbies: Array) -> void:
  	for this_lobby in these_lobbies:
  		# 从 Steam 中提取大厅数据，这些数据特定于我们的示例
  		var lobby_name: String = Steam.getLobbyData(this_lobby, "name")
  		var lobby_mode: String = Steam.getLobbyData(this_lobby, "mode")
  
  		# 获取当前成员数
  		var lobby_num_members: int = Steam.getNumLobbyMembers(this_lobby)
  
  		# Create a button for the lobby
  		var lobby_button: Button = Button.new()
  		lobby_button.set_text("Lobby %s: %s [%s] - %s Player(s)" % [this_lobby, lobby_name, lobby_mode, lobby_num_members])
  		lobby_button.set_size(Vector2(800, 50))
  		lobby_button.set_name("lobby_%s" % this_lobby)
  		lobby_button.connect("pressed", self, "join_lobby", [this_lobby])
  
  		# Add the new lobby to the list
  		$Lobbies/Scroll/List.add_child(lobby_button)
  ```

- Godot 4.x

  ```gdscript
  func _on_lobby_match_list(these_lobbies: Array) -> void:
  	for this_lobby in these_lobbies:
  		# 从 Steam 中提取大厅数据，这些数据特定于我们的示例
  		var lobby_name: String = Steam.getLobbyData(this_lobby, "name")
  		var lobby_mode: String = Steam.getLobbyData(this_lobby, "mode")
  
  		# 获取当前成员数
  		var lobby_num_members: int = Steam.getNumLobbyMembers(this_lobby)
  
  		# 为大厅创建一个按钮
  		var lobby_button: Button = Button.new()
  		lobby_button.set_text("大厅 %s: %s [%s] - %s 名玩家" % [this_lobby, lobby_name, lobby_mode, lobby_num_members])
  		lobby_button.set_size(Vector2(800, 50))
  		lobby_button.set_name("lobby_%s" % this_lobby)
  		lobby_button.connect("pressed", Callable(self, "join_lobby").bind(this_lobby))
  
  		# 将新大厅加入队列
  		$Lobbies/Scroll/List.add_child(lobby_button)
  ```

您现在应该可以调用大厅列表并显示它们了。

### 加入大厅

接下来我们将讨论大厅的问题。单击我们在上一步中创建的大厅按钮之一将启动此功能：

```gdscript
func join_lobby(this_lobby_id: int) -> void:
	print("正在尝试加入大厅 %s" % lobby_id)

	# 如果您在以前的大厅，清除以前的任何大厅成员列表
	lobby_members.clear()

	# 向 Steam 发出大厅加入请求
	Steam.joinLobby(this_lobby_id)
```

这将尝试加入您单击的大厅，当成功时，它将触发 `_on_lobby_joined()` 回调：

```gdscript
func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	# 如果成功加入
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		# 将此大厅 ID 设置为您的大厅 ID
		lobby_id = this_lobby_id

		# 获取大厅成员
		get_lobby_members()

		# 进行初次握手
		make_p2p_handshake()

	# 否则它因为某种原因而失败
	else:
		# 获取失败原因
		var fail_reason: String

		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST: fail_reason = "该大厅不再存在。（This lobby no longer exists.）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED: fail_reason = "你没有加入该房间的许可。（You don't have permission to join this lobby.）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL: fail_reason = "大厅已满。（The lobby is now full.）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR: fail_reason = "嗯……意外事件发生！（Uh... something unexpected happened!）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED: fail_reason = "你被禁止加入该大厅。（You are banned from this lobby.）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED: fail_reason = "由于帐户受限，您无法加入。（You cannot join due to having a limited account.）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED: fail_reason = "该大厅已锁或已失效。（This lobby is locked or disabled.）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN: fail_reason = "这个大厅是社区锁定的。（This lobby is community locked.）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU: fail_reason = "大厅中的用户阻止您加入。（A user in the lobby has blocked you from joining.）"
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER: fail_reason = "您屏蔽的用户在大厅中。（A user you have blocked is in the lobby.）"

		print("加入该聊天室失败: %s" % fail_reason)

		# 重新打开大厅列表
		_on_open_lobby_list_pressed()
```

要想更清楚地解释这些聊天室的响应，[请查看 Friends 类中的枚举列表](https://godotsteam.com/classes/main/#chatroomenterresponse)。

如果玩家已经在游戏中，并接受 Steam 邀请或点击好友列表中的好友，然后从中选择“加入游戏”，则会触发 `join_requested` 回调。此函数将处理以下问题：

```gdscript
func _on_lobby_join_requested(this_lobby_id: int, friend_id: int) -> void:
	# 获取大厅所有者名字
	var owner_name: String = Steam.getFriendPersonaName(friend_id)

	print("正在加入 %s 的大厅..." % owner_name)

	# 尝试加入大厅
	join_lobby(this_lobby_id)
```

然后，它将遵循正常的 `join_lobby()` 过程，设置所有大厅成员、握手等。不要听起来重复，但请再次注意，如果玩家不在游戏中，并接受 Steam 邀请或通过朋友列表加入游戏，那么我们将回到前面讨论的命令行情况。

### 获取大厅成员

根据你如何设置大厅界面，你可能希望玩家看到某种带有玩家列表的聊天窗口。我们的 `get_loby_members()` 将帮助找出大厅里的所有人：

```gdscript
func get_lobby_members() -> void:
	# 清除您以前的大厅列表
	lobby_members.clear()

	# 从 Steam 获取此大厅的成员数量
	var num_of_members: int = Steam.getNumLobbyMembers(lobby_id)

	# 从 Steam 获取这些玩家的数据
	for this_member in range(0, num_of_members):
		# 获取成员的 Steam ID
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, this_member)

		# 获取成员的 Steam 名字
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)

		# 将他们加入到队列中
		lobby_members.append({"steam_id":member_steam_id, "steam_name":member_steam_name})
```

这将从 Steam 中获取大厅成员，然后循环并获取他们的姓名和 Steam ID，然后将他们附加到我们的 `lobby_members` 数组中以供稍后使用。然后，您可以在大厅房间中显示此列表。

### 个人信息变化 / 头像 / 名称

有时你会看到用户的名字和头像，有时是其中之一，不会立即正确显示。这是因为我们的本地用户只真正了解与他们一起玩过的朋友和玩家；存储在本地缓存中的任何内容。

加入大厅一段时间后，Steam 将发送这些数据，从而触发 `persona_state_change` 回调。您需要更新您的玩家列表以反映这一点，并为未知玩家获取正确的名称和头像。我们连接 `_on_persona_change()` 函数将执行以下操作：

```gdscript
# 一个用户信息改变了
func _on_persona_change(this_steam_id: int, _flag: int) -> void:
	# 请确保您在大厅中，并且该用户是有效的，否则 Steam 可能会向您的控制台日志发送垃圾信息
	if lobby_id > 0:
		print("一个用户 (%s) 修改了信息，更新大厅列表" % this_steam_id)

		# 更新玩家队列
		get_lobby_members()
```

所有这些实际上都是通过再次调用 `get_lobby_Members()` 来刷新我们的大厅列表信息，以获得正确的头像和名称。

### P2P 握手

您还将注意到，在加入大厅的部分，我们启动了最初的 P2P 握手；这只是打开并检查我们的 P2P 会话：

```gdscript
func make_p2p_handshake() -> void:
	print("正在向大厅发送 P2P 握手")

	send_p2p_packet(0, {"message": "handshake", "from": steam_id})
```

我们现在还不了解这一切意味着什么，但我想在这里展示握手函数的代码，因为它被引用了；[在 P2P 教程中详细介绍](https://godotsteam.com/tutorials/p2p/)。你的握手信息可以是任何东西，在大多数情况下都会被忽略。同样，这只是为了测试我们的 P2P 会话。

### 大厅更新 / 更改

现在玩家已经加入大厅，大厅中的每个人都将收到一个回调通知，通知更改。我们将这样处理：

```gdscript
func _on_lobby_chat_update(this_lobby_id: int, change_id: int, making_change_id: int, chat_state: int) -> void:
	# 获取进行大厅更改的用户
	var changer_name: String = Steam.getFriendPersonaName(change_id)

	# 如果玩家已加入大厅
	if chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
		print("%s 已经加入了大厅" % changer_name)

	# 否则，如果玩家已离开大厅
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
		print("%s 已经离开了大厅" % changer_name)

	# 否则，如果玩家被踢
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_KICKED:
		print("%s 已经被踢出大厅" % changer_name)

	# 否则，如果玩家已被禁止
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_BANNED:
		print("%s 已经被禁止进入大厅" % changer_name)

	# 还有一些未知的变化
	else:
		print("%s 做了…… 某些事情" % changer_name)

	# 发生更改后立即更新大厅
	get_lobby_members()
```

在大多数情况下，这将在玩家加入或离开大厅时更新。然而，如果你添加了踢（kick）或禁止（ban）玩家的功能，它也会显示出来。在这个功能的最后，我总是更新玩家列表，这样我们就可以在大厅中显示正确的玩家列表。

### 大厅聊天 / 信息

你可能还希望玩家能够在大厅里聊天，等待游戏开始。如果您有一个用于消息传递的 LineEdit 节点，单击“发送”按钮应该会触发如下操作：

```gdscript
func _on_send_chat_pressed() -> void:
	# 获取输入的聊天信息
	var this_message: String = $Chat.get_text()

	# 如果有消息
	if this_message.length() > 0:
		# 将消息传递给 Steam
		var was_sent: bool = Steam.sendLobbyChatMsg(lobby_id, this_message)

		# 发送成功吗？
		if not was_sent:
			print("ERROR: 聊天消息发送失败")

	# 清除聊天输入
	$Chat.clear()
```

$Chat 是您的 **LineEdit**，在您的项目中可能会有所不同。最重要的是获取文本并将其发送到 `sendLobbyChatMsg()`。

### 离开大厅

接下来我们将处理离开大厅的问题。如果您有一个按钮，请将其连接到此函数：

```gdscript
func leave_lobby() -> void:
	# 如果在大厅中，离开它
	if lobby_id != 0:
		# 向Steam发送离开请求
		Steam.leaveLobby(lobby_id)

		# 擦除 Steam 大厅 ID，然后显示默认大厅 ID 和玩家列表标题
		lobby_id = 0

		# 关闭与所有用户的会话
		for this_member in lobby_members:
			# 确保这不是您的 Steam ID
			if this_member['steam_id'] != steam_id:

				# 关闭P2P会话
				Steam.closeP2PSessionWithUser(this_member['steam_id'])

		# 清除本地大厅列表
		lobby_members.clear()
```

这将通知 Steam 您已离开大厅，然后在关闭与大厅中所有玩家的 P2P 会话后清除您的 `lobby_id` 变量以及您的 `lobby_members` 数组。你会注意到，在这一点上，我们没有任何功能可以通过 Steam 处理邀请。稍后将在大厅教程的后半部分添加此内容。

### 下一个

大厅教程到此结束。在这一点上，你可能想[看看P2P教程，它补充了这一章](https://godotsteam.com/tutorials/p2p/)。显然，这段代码不应该用于生产，更应该说是用于了解从哪里开始的非常、非常、非常简单的指南。

### 其他资源

#### 视频教程

喜欢视频教程吗？饱饱眼福！

- [DawnsCrowGames 的 “Godot 教程：GodotSteam 大厅系统”](https://youtu.be/si50G3S1XGU)

#### 相关项目

- [JDare 的 “GodotSteamHL”](https://github.com/JDare/GodotSteamHL)

#### 示例项目

[要查看本教程的实际操作，请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## Mac 注意事项

有些用户在使用 Godot 和 GodotSteam 时可能会在 macOS上 遇到一些问题。本教程页旨在介绍它们。

### M1 和 M2 机器问题

来自用户 **canardbleu**，一个关于使用预编译编辑器和 macOS M1 和 M2 机器的方便提示。

他们的团队表示：“（我们）无法启动任何场景，因为‘文件和文件夹’权限弹出窗口不断弹出。幸运的是，我们能够通过执行以下命令找到解决方法。”

```shell
codesign -s - --deep /Applications/GodotEditor.app
```

## P2P 网络

其中一个要求更高的教程是多人大厅和通过 Steam 的 P2P 网络；本教程专门介绍了 P2P 网络部分，[我们的大厅教程介绍了另一半](https://godotsteam.com/tutorials/lobbies/)。

请注意，本教程使用了旧的 **Steamworks Networking 类**，这是一个基本的、基于回合的大厅 / P2P设置。仅以此为起点。

我还建议您在继续之前[查看本教程的“附加资源”部分](https://godotsteam.com/tutorials/p2p/#additional-resources)。

> 相关 GodotSteam 类和函数
>
> - [Networking 类](https://godotsteam.com/classes/networking/)
>   - [acceptP2PSessionWithUser()](https://godotsteam.com/classes/networking/#acceptp2psessionwithuser)
>   - [getAvailableP2PPacketSize()](https://godotsteam.com/classes/networking/#getavailablep2ppacketsize)
>   - [readP2PPacket()](https://godotsteam.com/classes/networking/#readp2ppacket)
>   - [sendP2PPacket()](https://godotsteam.com/classes/networking/#sendp2ppacket)
> - [Friends 类](https://godotsteam.com/classes/friends/)
>   - [getFriendPersonaName()](https://godotsteam.com/classes/friends/#getfriendpersonaname)

### _ready() 函数

接下来，我们将为 Steamworks 和命令行检查器设置信号连接，如下所示：

- Godot 2.x, 3.x

  ```gdscript
  func _ready() -> void:
  	Steam.connect("p2p_session_request", self, "_on_p2p_session_request")
  	Steam.connect("p2p_session_connect_fail", self, "_on_p2p_session_connect_fail")
  
  	# 检查命令行参数
  	check_command_line()
  ```

- Godot 4.x

  ```gdscript
  func _ready() -> void:
  	Steam.p2p_session_request.connect(_on_p2p_session_request)
  	Steam.p2p_session_connect_fail.connect(_on_p2p_session_connect_fail)
  
  	# 检查命令行参数
  	check_command_line()
  ```

我们将在下面逐一介绍。

### _process() 函数

我们还需要在 `_process()` 函数中设置 `read_p2p_packet()`，以便它总是在寻找新的数据包：

```gdscript
func _process(_delta) -> void:
	Steam.run_callbacks()

	# 如果玩家已连接，则读取数据包
	if lobby_id > 0:
		read_p2p_packet()
```

如果您使用的是 `global.gd` 自动加载单例，那么您可以省略 `run_callbacks()` 命令，因为它们已经在运行了。

以下是来自 **tehsquidge** 的一段很好的代码，用于处理数据包读取：

```gdscript
func _process(delta):
	Steam.run_callbacks()

	if lobby_id > 0:
		read_all_p2p_packets()


func read_all_p2p_packets(read_count: int = 0):
	if read_count >= PACKET_READ_LIMIT:
		return

	if Steam.getAvailableP2PPacketSize(0) > 0:
		read_p2p_packet()
		read_all_p2p_packets(read_count + 1)
```

### P2P 网络 - 会话请求

接下来我们将查看 P2P 网络功能。[在大厅教程中](https://godotsteam.com/tutorials/lobbies/)，当有人加入大厅时，我们进行了 P2P 握手，它会触发 `p2p_session_request` 回调，进而触发此函数：

```gdscript
func _on_p2p_session_request(remote_id: int) -> void:
	# 获取请求者的姓名
	var this_requester: String = Steam.getFriendPersonaName(remote_id)
	print("%s 正在请求 P2P 会话" % this_requester)

	# 接受P2P会话；如果需要，可以应用逻辑拒绝此请求
	Steam.acceptP2PSessionWithUser(remote_id)

	# 进行初次握手
	make_p2p_handshake()
```

它非常简单地确认会话请求，接受它，然后发送回握手。

### 读取 P2P 数据包

在握手中，有一个对 `read_p2p_packet()` 函数的调用，该函数执行以下操作：

- Godot 2.x, 3.x

  ```gdscript
  func read_p2p_packet() -> void:
  	var packet_size: int = Steam.getAvailableP2PPacketSize(0)
  
  	# There is a packet
  	if packet_size > 0:
  		var this_packet: Dictionary = Steam.readP2PPacket(packet_size, 0)
  
  		if this_packet.empty() or this_packet == null:
  			print("WARNING: read an empty packet with non-zero size!")
  
  		# Get the remote user's ID
  		var packet_sender: int = this_packet['steam_id_remote']
  
  		# Make the packet data readable
  		var packet_code: PoolByteArray = this_packet['data']
  		var readable_data: Dictionary = bytes2var(packet_code)
  
  		# Print the packet to output
  		print("Packet: %s" % readable_data)
  
  		# Append logic here to deal with packet data
  ```

- Godot 4.x

  ```gdscript
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
  ```

如果数据包大小大于零，那么它将获得发送者的 Steam ID 和他们发送的数据。行 `bytes2var`（Godot 2.x，3.x）或`bytes_to_var`（Godot 4.x）非常重要，因为它将数据解码回您可以读取和使用的内容。解码后，您可以将数据传递给游戏的任何数量的函数。

### 发送 P2P 数据包

除了握手之外，你可能还想在玩家之间来回传递很多不同的数据。

我的设置有两个参数：第一个是作为字符串的收件人，第二个是字典。我认为字典最适合发送数据，这样你就可以有一个键/值对来参考，并减少接收端的混乱。每个数据包将通过以下函数：

- Godot 2.x, 3.x

  ```gdscript
  func send_p2p_packet(this_target: int, packet_data: Dictionary) -> void:
  	# 设置 send_type 和 channel
  	var send_type: int = Steam.P2P_SEND_RELIABLE
  	var channel: int = 0
  
  	# 创建一个数据数组以发送数据
  	var this_data: PoolByteArray
  	this_data.append_array(var2bytes(packet_data))
  
  	# 如果向每个人发送数据包
  	if this_target == 0:
  		# 如果有多个用户，发送数据包
  		if lobby_members.size() > 1:
  			# 循环遍历所有不是您的成员
  			for this_member in lobby_members:
  				if this_member['steam_id'] != steam_id:
  					Steam.sendP2PPacket(this_member['steam_id'], this_data, send_type, channel)
  
  	# 否则发送给特定的人
  	else:
  		Steam.sendP2PPacket(this_target, this_data, send_type, channel)
  ```

- Godot 4.x

  ```gdscript
  func send_p2p_packet(this_target: int, packet_data: Dictionary) -> void:
  	# 设置 send_type 和 channel
  	var send_type: int = Steam.P2P_SEND_RELIABLE
  	var channel: int = 0
  
  	# 创建一个数据数组以发送数据
  	var this_data: PackedByteArray
  	this_data.append_array(var_to_bytes(packet_data))
  
  	# 如果向每个人发送数据包
  	if this_target == 0:
  		# 如果有多个用户，发送数据包
  		if lobby_members.size() > 1:
  			# 循环遍历所有不是您的成员
  			for this_member in lobby_members:
  				if this_member['steam_id'] != steam_id:
  					Steam.sendP2PPacket(this_member['steam_id'], this_data, send_type, channel)
  
  	# 否则发送给特定的人
  	else:
  		Steam.sendP2PPacket(this_target, this_data, send_type, channel)
  ```

`send_type` 变量将与以下枚举和整数相对应：

| 发送类型枚举                     | 值   | 描述               |
| -------------------------------- | ---- | ------------------ |
| P2P_SEND_UNRELIABLE              | 0    | 发送不可靠         |
| P2P_SEND_UNRELIABLE_NO_DELAY     | 1    | 发送不可靠且无延迟 |
| P2P_SEND_RELIABLE                | 2    | 发送可靠           |
| P2P_SEND_RELIABLE_WITH_BUFFERING | 3    | 发送可靠且有缓冲   |

所使用的通道应与读取和发送功能相匹配。您可能想要使用多个通道，因此这显然应该进行调整。

随着游戏复杂性的增加，您可能会发现发送的数据量显著增加。响应式、有效网络的核心原则之一是减少您发送的数据量，以减少某些部分被破坏的机会或者要求游戏玩家拥有非常快速的互联网连接才能玩游戏。

幸运的是，我们可以在发送函数中引入**压缩**，以缩小数据的大小，而无需更改整个字典。这个概念很简单；当我们调用 **var2ytes**（Godot 2.x，3.x）或 **var_to_bytes**（Godot 4.x）函数时，我们将字典（或其他一些变量）转换为 **PoolByteArray**（Godot 2.x，3.0x）或 **PackedByteArray**（Godot 4.x），并通过互联网发送。

我们可以用一行代码将 **PoolByteArray** / **PackedByteArray** 压缩得更小：

- Godot 2.x, 3.x

  ```gdscript
  func send_p2p_packet(target: int, packet_data: Dictionary) -> void:
  	# 设置 send_type 和 channel
  	var send_type: int = Steam.P2P_SEND_RELIABLE
  	var channel: int = 0
  
  	# 创建一个数据数组以发送数据
  	var this_data: PoolByteArray
  
  	# 使用 GZIP 压缩方法压缩我们从字典中创建的 PoolByteArray
  	var compressed_data: PoolByteArray = var2bytes(packet_data).compress(File.COMPRESSION_GZIP)
  	this_data.append_array(compressed_data)
  
  	# 如果向每个人发送数据包
  	if target == 0:
  		# 如果有多个用户，发送数据包
  		if lobby_members.size() > 1:
  			# 循环遍历所有不是您的成员
  			for this_member in lobby_members:
  				if this_member['steam_id'] != steam_id:
  					Steam.sendP2PPacket(this_member['steam_id'], this_data, send_type, channel)
  
  	# 否则发送给特定的人
  	else:
  		Steam.sendP2PPacket(target, this_data, send_type, channel)
  ```

- Godot 4.x

  ```gdscript
  func send_p2p_packet(target: int, packet_data: Dictionary) -> void:
  	# 设置 send_type 和 channel
  	var send_type: int = Steam.P2P_SEND_RELIABLE
  	var channel: int = 0
  
  	# 创建一个数据数组以发送数据
  	var this_data: PackedByteArray
  
  	# 使用 GZIP 压缩方法压缩我们从字典中创建的 PackedByteArray
  	var compressed_data: PackedByteArray = var_to_bytes(packet_data).compress(FileAccess.COMPRESSION_GZIP)
  	this_data.append_array(compressed_data)
  
  	# 如果向每个人发送数据包
  	if target == 0:
  		# 如果有多个用户，发送数据包
  		if lobby_members.size() > 1:
  			# 循环遍历所有不是您的成员
  			for this_member in lobby_members:
  				if this_member['steam_id'] != steam_id:
  					Steam.sendP2PPacket(this_member['steam_id'], this_data, send_type, channel)
  
  	# 否则发送给特定的人
  	else:
  		Steam.sendP2PPacket(target, this_data, send_type, channel)
  ```

当然，我们现在已经通过互联网向其他人发送了一个**压缩**的 PoolByteArray / PackedByteArray，因此当他们收到数据包时，他们需要先**解压缩** PoolByteArray / PackedByteArray，然后才能对其进行解码。为了实现这一点，我们在 `read_p2p_packet` 函数中添加了一行代码，如下所示：

- Godot 2.x, 3.x

  ```gdscript
  func read_p2p_packet() -> void:
  	var packet_size: int = Steam.getAvailableP2PPacketSize(0)
  
  	# 有包
  	if packet_size > 0:
  		var this_packet: Dictionary = Steam.readP2PPacket(packet_size, 0)
  
  		if this_packet.empty() or this_packet == null:
  			print("WARNING: 读取大小为非零的空数据包!")
  
  		# 获取远程用户的 ID
  		var packet_sender: int = this_packet['steam_id_remote']
  
  		# 使数据包数据可读
  		var packet_code: PoolByteArray = this_packet['data']
  
  		# 在将数组转换为可用字典之前对其进行解压缩
  		var readable_data: Dictionary = bytes2var(packet_code.decompress_dynamic(-1, File.COMPRESSION_GZIP))
  
  		# 打印要输出的数据包
  		print("Packet: %s" % readable_data)
  
  		# 在此处附加逻辑以处理数据包数据
  ```

- Godot 4.x

  ```gdscript
  func read_p2p_packet() -> void:
  	var packet_size: int = Steam.getAvailableP2PPacketSize(0)
  
  	# 有包
  	if packet_size > 0:
  		var this_packet: Dictionary = Steam.readP2PPacket(packet_size, 0)
  
  		if this_packet.is_empty() or this_packet == null:
              print("WARNING: 读取大小为非零的空数据包!")
  
  		# 获取远程用户的 ID
  		var packet_sender: int = this_packet['steam_id_remote']
  
  		# 使数据包数据可读
  		var packet_code: PackedByteArray = this_packet['data']
  
  		# 在将数组转换为可用字典之前对其进行解压缩
  		var readable_data: Dictionary = bytes_to_var(packet_code.decompress_dynamic(-1, FileAccess.COMPRESSION_GZIP))
  
  		# 打印要输出的数据包
  		print("Packet: %s" % readable_data)
  
  		# 在此处附加逻辑以处理数据包数据
  ```

这里需要注意的关键点是，**发送和接收的格式必须相同**。Godot 中有很多关于压缩的内容，远远超出了本教程的范围；要了解更多信息，[请在此处阅读相关内容](https://docs.godotengine.org/en/stable/classes/class_poolbytearray.html#class-poolbytearray-method-compress)。

### P2P 会话失败

在本教程的最后一部分中，我们将使用以下函数处理 P2P 故障，该函数由 `p2p_session_connect_fail` 回调触发：

```gdscript
func _on_p2p_session_connect_fail(steam_id: int, session_error: int) -> void:
	# 如果没有给出错误
	if session_error == 0:
		print("WARNING: 会话失败 %s: 没有给出错误" % steam_id)

	# 否则，如果目标用户没有运行相同的游戏
	elif session_error == 1:
		print("WARNING: 会话失败 %s: 目标用户未运行同一游戏" % steam_id)

	# 否则，如果本地用户不拥有应用程序/游戏
	elif session_error == 2:
		print("WARNING: 会话失败 %s: 本地用户不拥有应用程序/游戏" % steam_id)

	# 否则，如果目标用户未连接到 Steam
	elif session_error == 3:
		print("WARNING: 会话失败 %s: 目标用户未连接到 Steam" % steam_id)

	# 否则，如果连接超时
	elif session_error == 4:
		print("WARNING: 会话失败 %s: 连接超时" % steam_id)

	# 否则，如果未使用
	elif session_error == 5:
		print("WARNING: 会话失败 %s: 未使用的" % steam_id)

	# 否则没有已知错误
	else:
		print("WARNING: 会话失败 %s: 未知错误 %s" % [steam_id, session_error])
```

这将打印一条警告消息，以便您了解会话连接失败的原因。从这里，您可以添加任何您想要的附加功能，如重试连接或其他功能。

### 下一个

P2P 教程到此结束。在这一点上，你可能想[看看大厅教程（如果你还没有），这是对这一教程的补充](https://godotsteam.com/tutorials/lobbies/)。显然，这段代码不应该用于生产，更多是用于作为关于从哪里开始的非常、非常、非常简单的指南。

### 其他资源

#### 建议阅读材料

我强烈建议阅读其中的部分或全部内容，以更好地理解网络。

- [Valve 的网络文档](https://partner.steamgames.com/doc/features/multiplayer/networking)
- [ThusSpokeNomad 的“游戏网络资源”](https://github.com/ThusSpokeNomad/GameNetworkingResources)
- [“如何编写网络游戏？” on StackOverflow](https://gamedev.stackexchange.com/questions/249/how-to-write-a-network-game)
- [Gaffer On Games 的网络](https://web.archive.org/web/20180823014743/https://gafferongames.com/tags/networking)
- [Gabriel Gambetta的“客户端/服务器游戏架构”](https://www.gabrielgambetta.com/client-server-game-architecture.html)

#### 相关项目

[JDare的“GodotSteamHL”](https://github.com/JDare/GodotSteamHL)

#### 示例项目

[要查看本教程的实际操作，请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## 轻松移除 Steam

很多人喜欢在其他平台上发布，如 Playstation、XBox、Switch、Itch.io 等。删除深度嵌入的 Steamworks 内容可能会很痛苦，有些人选择为游戏的 Steam 版本保留单独的存储库。然而，还有一种替代方法：以编程方式忽略 Steamworks 位。以下是用户在 Discord 中分享的一些示例。

### 我们是如何做到的

因此，我将在本教程中使用的示例是基于 Rutger 提交的解决方案 #2。我正在我当前的项目中积极使用此功能。

我们将创建两个变量来保存我们的平台和 Steamworks 对象，然后在尝试执行任何操作之前，修改通常的 `initialize_stream()` 函数来查找 Steam 单例：

```gdscript
var this_platform: String = "steam"
var steam_api: Object = null

# 初始化 Steam
func initialize_steam() -> void:
	if Engine.has_singleton("Steam"):
		this_platform = "steam"
		steam_api = Engine.get_singleton("Steam")

		var initialized: Dictionary = steam_api.steamInitEx(false)

		print("[STEAM] Steam 初始化了吗?: %s" % initialized))

		# 如果它确实失败了，让我们找出原因并将 steam_api 对象置空
		if initialized['status'] > 0:
			print("未能初始化 Steam，禁用所有 Steamworks 功能: %s" % initialized)
			steam_api = null

		# 用户在线吗?
		steam_id = steam_api.getSteamID()
		steam_name = steam_api.getPersonaName()

	else:
		this_platform = "itch"  # 可以是其他任何东西，比如主机平台等。
		steam_id = 0
		steam_name = "You"
```

现在，我们可以使用 `steam_api` 对象在游戏的其他地方调用我们的 steam 函数，如果没有 Steamworks，它不会因为缺少 singleton 调用而导致游戏崩溃。

我还创建了一个助手函数来快速检查是否可以使用 Steam 方式，如下所示：

```gdscript
func is_steam_enabled() -> bool:
	if this_platform == "steam" and steam_api != null:
		return true
	return false
```

由于它在我的全局脚本中，所以可以在我需要使用 Steam 函数的任何地方调用它。如果这个函数没有返回 true，那么我的代码就会忽略相关的 Steam 部分，如下所示：

```gdscript
func fire_steam_achievement(value: int) -> void:
	if not achievements[value]:
		achievements[value] = true

		# 将变量传递给 Steam 并将其关闭
		var this_achievement: String = "ACHIEVE"+str(value)

		# 现在，如果 Steam 存在并已启用，请使用 Steamworks 功能
		if is_steam_enabled():
			var was_set: bool = steam_api.setAchievement(ACHIEVE)
			print("[STEAM] Firing achievement %s, success: %s" % [this_achievement, was_set])

			var was_stored: bool = steam_api.storeStats()
			print("[STEAM] Statistics stored: %s" % was_stored)
```

因此，当您需要导出到非 Steam 平台时，您只需使用普通 Godot 模板，就不必担心其他任何事情！根本不需要不同版本的游戏。

下面我们有两个提交的关于如何实现这一目标的用户建议；上面的例子所示，是基于解决方案 #2 的，但如果这对您更有意义，也要检查解决方案 1。

### 解决方案 1：多个文件

Albey 在 GDScript 中分享了一些解决方案的脚本，其中有三个独立的文件。`SteamHandler.gd` 文件交换了游戏的哪个版本：

```gdscript
extends Node

var interface: SteamIntegrationBlank

func _ready() -> void:
	if OS.has_feature("Steam"):
		interface = load("res://Entities/Autoloads/Steam/SteamIntegration.gd").new()
	else:
		interface = load("res://Entities/Autoloads/Steam/SteamIntegrationBlank.gd").new()

	interface.initialise_steam()
	if interface.status != interface.STATUS_OK:
		get_tree().quit()
```

`SteamIntegrationBlank.gd` 文件处理 Steam 不存在时发生的情况：

```gdscript
extends Reference
class_name SteamIntegrationBlank

const STATUS_OK = 1
const STATUS_STEAM_NOT_RUNNING = 20
var status := STATUS_OK

func initialise_steam() -> void:
	pass
```

最后是 Steam 存在时的 `SteamIntegration.gd` 文件：

```gdscript
extends SteamIntegrationBlank

const APP_ID = ***

func initialise_steam() -> void:
	if Steam.restartAppIfNecessary(APP_ID):
		status = STATUS_STEAM_NOT_RUNNING
		return

	var init: Dictionary = Steam.steamInit()
	status = init['status']
```

### 解决方案 2：检查 Singleton

[Roost Games（Cat Cafe Manager 的制造商）的 Rutger](https://catcafemanager.com/) 分享了一条关于它的花絮：“如果有人想知道如何做到这一点，因为我必须通过 Switch 端口找到，我有一个全局变量 `platform` 作为任何特定于平台的东西的包装器，它只会在 `_ready()` 中这样做”。他的示例代码如下：

```gdscript
if Engine.has_singleton("Steam"):
	self.platform = "steam"
	self.Steam = Engine.get_singleton("Steam")
```

### GDExtension 的注意事项

使用 GodotSteam 的 GDExtension 时，还需要更改位于项目中 .godot 文件夹中的 `extension_list.cfg` 文件。如果你不这样做，那么游戏在运行时会在你的日志文件中产生一些错误。然而，它们是无害的，只是有点烦人。[有人提议纠正这种行为，所以祈祷吧！](https://github.com/godotengine/godot-proposals/issues/9322)

希望这些例子能给你一些关于如何从游戏中删除 Steamworks 功能的想法，而不必制作一堆不同的构建和存储库。

## 丰富状态

这个简短的教程是关于你游戏的丰富状态；特别是游戏增强了丰富状态。你可能在你的朋友列表中看到过一个游戏中的朋友，其中有一个次要的文本字符串，其中包含一些关于游戏的信息。通常是关于他们所处的级别、大厅、玩家数量等。好吧，这就是本教程的全部内容。

[您可以在 Steamworks 文档中阅读更多关于增强丰富状态的信息。](https://partner.steamgames.com/doc/features/enhancedrichpresence)

> 相关 GodotSteam 类和函数
>
> - [Friends 类](https://godotsteam.com/classes/friends/)
>   - [setRichPresence()](https://godotsteam.com/classes/friends/#setrichpresence)

### 设置

首先，您需要在 Steamworks 后端设置本地化文件。显然，如果没有这一步骤，丰富状态文本就不会真正起作用，因为它没有任何可参考的内容。您需要这样设置您的文本文件：

```json
"lang" {
    "language" {
        "english" {
            "tokens" {
                "#something1"   "Rich presence string"
                "#something2"   "Another string"
                "#something_with_input" "{something: %input%"
            }
        }
    }
}
```

确保用制表符分隔标记括号中的字符串。此外，在尝试测试文件之前，请确保在上传文件后发布更改。这些更改必须在 Steamworks 中实时显示。

你可以把各种语言放在自己的嵌套中，这样这些语言就可以向用户展示如何专门设置 Steam 客户端语言。每个 token 中的第一个字符串是您最终将在游戏代码中使用的字符串。

### 建议的代码

我有一个全局函数，在我的 `global.gd` 中，它可以在我的项目中的任何地方调用并处理这个问题。它是这样写的：

```gdscript
func set_rich_presence(token: String) -> void:
	# 设置 token
    var setting_presence = Steam.setRichPresence("steam_display", token)

	# 调试它
	print("设置丰富状态到 "+str(token)+": "+str(setting_presence))
```

在任何要设置标记的场景中：

```gdscript
global.set_rich_presence("#something1")
```

现在 Steam 将把你朋友列表中的文本设置为你在 Steamworks 后端的令牌列表中设置的文本。您也可以将鼠标悬停在自己的个人资料图片上，以查看游戏中的文本；用于测试目的。

[这里的 SDK 文档中详细介绍](https://partner.steamgames.com/doc/api/ISteamFriends#SetRichPresence)了您可以设置的其他标记。

### GDNative 中的奇怪 Bug

在 **Windows 版本的 GDNative** 中，GodotSteam 和 Samsfacee 的插件中都存在一个奇怪的错误。有时 `setRichPresence()` 函数会将密钥作为值发送。它并不一致，但碰巧足够明显和痛苦。

请注意，预编译模块版本、GDExtension 版本或 Linux 或 OSX 的 GDNative 版本中都不存在此错误。

这种行为似乎肯定是 GDNative 的问题，所以我们无法在我们的上真正解决它，并且一个问题已经提交到 Godot GitHub 页面。

值得庆幸的是，**Furcifer** 已经分享了一些代码来帮助解决这个问题！

```gdscript
var iteration = 0
var richPresenceKeyValue = []
var updatingRichPresence = false

func callNextFrame(methodName, arguments = []):
	get_tree().connect("idle_frame", self, methodName, arguments, CONNECT_ONESHOT)

func updateRichPresence():
	iteration = 0
	richPresenceKeyValue.clear()

	addRichPresence("numwins", String(Game.getNumWins()))
	addRichPresence("steam_display", "#status_Ingame")

	if not updatingRichPresence:
		updatingRichPresence = true
		setPresenceDelayed()

func addRichPresence(key, value):
	richPresenceKeyValue.push_back([key, value])
	Steam.setRichPresence(key, value)

func setPresenceDelayed():
	var remaining = []
	for tuple in richPresenceKeyValue:
		var success = forceSetProperty(tuple[0], tuple[1])
		if not success:
			remaining.push_back(tuple)

	richPresenceKeyValue = remaining

	if not richPresenceKeyValue.empty():
		iteration += 1
		recallSetPresenceDelayed() # recalls this function after a frame
	else:
		updatingRichPresence = false

func recallSetPresenceDelayed():
	Util.callNextFrame(self, "setPresenceDelayed")

func forceSetProperty(key : String, value : String) -> bool:
	for i in 10:
		var setval = Steam.getFriendRichPresence(STEAM_ID, key)
		if setval == key:
			#print("could not set key ", key, " - iteration: ", iteration, "/",i)
			Steam.setRichPresence(key, value)
		else:
			return true

	return false
```

### 其他资源

#### 视频教程

喜欢视频教程吗？饱饱眼福！

[FinePointCGI的“建立丰富状态”](https://www.youtube.com/watch?v=VCwNxfYZ8Cw&t=4762s)

#### 示例项目

[要查看本教程的实际操作，请查看我们在 GitHub 上的 GodotSteam 示例项目。](https://github.com/GodotSteam/GodotSteam-Example-Project)在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## 统计数据和成就

在某个时候，你可能想将统计数据保存到 Steam 的数据库和/或使用他们的成就系统。你会想[在 Steam 的文档中阅读这些内容](https://partner.steamgames.com/doc/features/achievements)，因为我不会介绍如何在 Steamworks 后端设置它的基础知识。

> 相关 GodotSteam 类和函数
>
> - [User Stats 类](https://godotsteam.com/classes/user_stats/)
>   - [requestCurrentStats()](https://godotsteam.com/classes/user_stats/#requestcurrentstats)
>   - [getAchievement()](https://godotsteam.com/classes/user_stats/#getachievement)
>   - [setAchievement()](https://godotsteam.com/classes/user_stats/#setschievement)
>   - [setStatFloat()](https://godotsteam.com/classes/user_stats/#setstatfloat)
>   - [setStatInt()](https://godotsteam.com/classes/user_stats/#setstatint)
>   - [storeStats()](https://godotsteam.com/classes/user_stats/#storestats)

### 准备工作

首先，您需要在 Steamworks 后端设置您的成就和统计数据。最重要的是，您希望实时发布这些更改。如果没有，它们将不会暴露于 Steamworks API，并且在尝试检索或设置它们时会出现错误。一旦它们发布，您就可以继续学习本教程。

### 获取 Steam 统计数据和成就

在大多数情况下，启动游戏时，您会希望从 Steam 的服务器中为本地用户获取所有相关成就和统计数据。有几种方法可以处理从 Steam 服务器接收的统计数据/成就数据的回调连接。除非您选择通过向 `steamInit()` 或 `steamInitEX()` 函数传递 `false` 来关闭它；它将自动请求本地用户的当前统计数据和成就。我一般通过假来防止这种情况发生。

要从结果回调中检索数据，您需要将 `current_stats_received` 回调连接到如下函数：

- Godot 2.x, 3.x

  ```gdscript
  Steam.connect("current_stats_received", self, "_on_steam_stats_ready", [], CONNECT_ONESHOT)
  ```

- Godot 4.x

  ```gdscript
  Steam.current_stats_received.connect(_on_steam_stats_ready)
  ```

您会注意到 `CONNECT_ONESHOT` 被传递以防止它多次触发。这是因为每当更新或接收到统计数据时，都会发送该信号，并将再次运行 `_on_steam_stats_ready()`。

在我的用例中，这是不可取的，但在您的用例中可能是这样。如果您不介意每次触发 `_on_steam_stats_ready()`，根据函数的逻辑，可以随意省略这一部分，如下所示：

- Godot 2.x, 3.x

  ```gdscript
  Steam.connect("current_stats_received", self, "_on_steam_stats_ready")
  ```

- Godot 4.x

  ```gdscript
  Steam.current_stats_received.connect(_on_steam_stats_ready)
  ```

如果你像我一样保留 `CONNECT_ONESHOT`，我建议用 `requestUserStats()` 调用 Steam stat 更新，并传递用户的 Steam ID。此函数适用于任何用户：本地或远程。您还需要以类似的方式连接其信号：

- Godot 2.x, 3.x

  ```gdscript
  Steam.connect("user_stats_received", self, "_on_steam_stats_ready")
  ```

- Godot 4.x

  ```gdscript
  Steam.user_stats_received.connect(_on_steam_stats_ready)
  ```

它可以连接到与 `requestCurrentStats()` 相同的函数，因为它们会发回相同的数据。对于我们的例子，这里是我们在连接信号中列出的 `_on_steam_stats_ready()` 函数：

```gdscript
func _on_steam_stats_ready(game: int, result: int, user: int) -> void:
	print("该游戏的 ID: %s" % game)
	print("调用结果: %s" % result)
	print("该用户的 Steam ID: %s" % user)
```

### 使用数据

在该功能中，您可以检查结果是否符合您的预期（理想情况下为 1），查看给定的统计数据是否适用于当前玩家，并检查游戏的 ID 是否匹配。此外，您现在可以将成就和统计数据传递给局部变量或函数。我经常会将成就传递给一个函数，以正确解析它们，因为它们会返回一个 BOOL 用于检索，而返回一个 BOOL 用于获得或不获得。

```gdscript
var achievements: Dictionary = {"achieve1":false, "achieve2":false, "achieve3":false}

func _on_steam_stats_ready(game: int, result: int, user: int) -> void:
	print("该游戏的 ID: %s" % game)
	print("调用结果: %s" % result)
	print("该用户的 Steam ID: %s" % user)

	# 获得成就并将其传递给变量
	get_achievement("acheive1")
	get_achievement("acheive2")
	get_achievement("acheive3")

	# 获取统计信息（int）并将其传递给变量
	var highscore: int = Steam.getStatInt("HighScore")
	var health: int = Steam.getStatInt("Health")
	var money: int = Steam.getStatInt("Money")

# 处理成就
func get_achievement(value: String) -> void:
	var this_achievement: Dictionary = Steam.getAchievement(value)

	# 成就存在
	if this_achievement['ret']:

		# 成就解锁
		if this_achievement['achieved']:
			achievements[value] = true

		# 成绩被锁
		else:
			achievements[value] = false

	# 成就不存在
	else:
		achievements[value] = false
```

### 设定成就

设定成绩和统计数据也很简单。我们将从成就开始。你需要告诉Steam成就已解锁，然后将其存储为“pops”：

```gdscript
Steam.setAchievement("achieve1")
Steam.storeStats()
```

如果你不调用 `storeStats()`，成就弹出窗口不会触发，但应该记录成就。但是，您仍然需要在某个时刻调用 `storeStats()` 来上传它们。我通常会制作一个通用函数来容纳这个过程，然后在需要时调用它：

```gdscript
func _fire_Steam_Achievement(value: String) -> void:
	# Set the achievement to an in-game variable
	achievements[value] = true

	# 将值传递给 Steam 然后发送它
	Steam.setAchievement(value)
	Steam.storeStats()
```

当调用最后一个 `storeStats()` 时，该成就将在视觉上为用户“弹出”并更新他们的 Steam 客户端。

### 设置统计信息

统计遵循一个非常相似的过程；既有基于 int 的，也有基于 float 的。设置为：

```gdcript
Steam.setStatInt("stat1", value)
Steam.setStatFloat("stat2", value)
Steam.storeStats()
```

当调用最后一个 `storeStats()` 时，统计数据将在Steam的服务器上更新。

### 其他资源

#### 视频教程

喜欢视频教程吗？饱饱眼福！

- [BluePhoenixGames的“Godot+Steam教程”](https://www.youtube.com/watch?v=J0GrG-AffCI&t=571s)
- [FinePointCGI 的“成就是如何实现的”](https://www.youtube.com/watch?v=VCwNxfYZ8Cw&t=938s)
- [FinePointCGI 的“让我们谈谈统计”](https://www.youtube.com/watch?v=VCwNxfYZ8Cw&t=1504s)
- [《Godot 4 Steam成就》作者：Gwitz](https://www.youtube.com/watch?v=dg6fSBe5EEE)

#### 示例项目

[要查看本教程的实际操作，请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## 语音

如果你想在游戏中使用 Steam 的语音功能，我们也可以提供！本示例部分基于 [Godot 的网络语音聊天的 Github 代码库](https://github.com/ikbencasdoei/godot-voip/)和 Valve 的 SpaceWar 示例。用户 **Punny** 和 **ynot01** 提供了其他想法、细节等。

> 相关 GodotSteam 类和函数
>
> - [Friends 类](https://godotsteam.com/classes/friends/)
>   - [setInGameVoiceSpeaking()](https://godotsteam.com/classes/friends/#setingamevoicespeaking)
> - [User 类](https://godotsteam.com/classes/user/)
>   - [decompressVoice()](https://godotsteam.com/classes/user/#decompressvoice)
>   - [getAvailableVoice()](https://godotsteam.com/classes/user/#getavailablevoice)
>   - [getVoice()](https://godotsteam.com/classes/user/#getvoice)
>   - [getVoiceOptimalSampleRate()](https://godotsteam.com/classes/user/#getvoiceoptimalsamplerate)
>   - [startVoiceRecording()](https://godotsteam.com/classes/user/#startvoicerecording)
>   - [stopVoiceRecording()](https://godotsteam.com/classes/user/#stopvoicerecording)

### 准备工作

首先，我们将设置一组稍后使用的变量。

- Godot 2.x, 3.x

  ```gdscript
  var current_sample_rate: int = 48000
  var has_loopback: bool = false
  var local_playback: AudioStreamGeneratorPlayback = null
  var local_voice_buffer: PoolByteArray = PoolByteArray()
  var network_playback: AudioStreamGeneratorPlayback = null
  var network_voice_buffer: PoolByteArray = PoolByteArray()
  var packet_read_limit: int = 5
  ```

- Godot 4.x

  ```gdscript
  var current_sample_rate: int = 48000
  var has_loopback: bool = false
  var local_playback: AudioStreamGeneratorPlayback = null
  var local_voice_buffer: PoolByteArray = PackedByteArray()
  var network_playback: AudioStreamGeneratorPlayback = null
  var network_voice_buffer: PoolByteArray = PackedByteArray()
  var packet_read_limit: int = 5
  ```

需要快速提及的几件事是，`has_loopback` 将切换您是否能在语音聊天中听到自己的声音。虽然在游戏中不是很好，但在测试时很方便。您还注意到以 `local_`/ `network_` 为前缀的变量；这些是用来存储你和其他人的数据。理论上，`network_` 将覆盖网络/ Steam 的所有音频输出（任何不是你的东西）。

此外，在测试的根目录中，我们需要创建两个 `AudioStreamPlayer` 节点。一个命名为 **Local**，一个命名的 **Network**，我们可以分别用作 `$Local` 和 `$Network`。

为了将语音数据添加到音频流中，我们需要设置 `AudioStreamGeneratorPlayback`。确保 `AudioStreamPlayer` 节点都有和 `AudioStreamGenerator` 作为其流。将流的 `buffer_length` 设置为类似 0.1 的值：

```gdscript
func _ready() -> void:
	$Local.stream.mix_rate = current_sample_rate
	$Local.play()
	local_playback = $Local.get_stream_playback()

	$Network.stream.mix_rate = current_sample_rate
	$Network.play()
	network_playback = $Network.get_stream_playback()
```

### 获取语音数据

此外，在 `_process()` 函数中，我们将向 `check_for_voice()` 函数添加调用：

```gdscript
func _process(_delta: float) -> void:
	check_for_voice()
```

这个功能基本上只是查看是否有来自 Steam 的语音数据可用，然后获取并发送数据进行处理。

```gdscript
func check_for_voice() -> void:
	var available_voice: Dictionary = Steam.getAvailableVoice()

	# 似乎有语音数据
	if available_voice['result'] == Steam.VOICE_RESULT_OK and available_voice['buffer'] > 0:
		# Valve 的 getVoice 使用 1024，但 GodotSteam 的设置为 8192？
		# 我们的尺码可能差距较大；GodotSteam 内部指出，Valve 建议 8kb
		# 然而，这在标题和太空战争的例子中都没有提到，而是在 Valve 的文档中，这些文档通常是错误的
		var voice_data: Dictionary = Steam.getVoice()
		if voice_data['result'] == Steam.VOICE_RESULT_OK and voice_data['written']:
			print("语音消息有数据: %s / %s" % [voice_data['result'], voice_data['written']])

			# 在这里，我们可以在网络上传递这些语音数据
			Networking.send_message(voice_data['buffer'])

			# 如果已启用环回，在此时播放
			if has_loopback:
				print("Loopback on")
				process_voice_data(voice_data, "local")
```

我们的 `Networking.send_message` 功能可以是您用于发送数据包/数据的任何 P2P 网络功能。在写这篇文章的时候，我想知道这有多必要，因为 Steam 正在记录语音数据，我们正在检查是否有可用的数据；如果有人的话，它肯定知道我们在和谁说话。我们需要将这些数据作为数据包发送回吗？

### 处理语音数据

好的，现在我们有了一些东西，让我们听听。我们可能想使用最佳采样率，而不是我们在 `current_sample_rate` 变量中设置的任何值。在这种情况下，我们可以使用此函数：

```gdscript
func get_sample_rate() -> void:
	current_sample_rate = Steam.getVoiceOptimalSampleRate()
	print("当前采样率: %s" % current_sample_rate)
```

此功能可以附加到按钮上。我们也可以在这个按钮上添加一个切换，以在最佳速率之间切换或返回默认速率。更改采样率时，请记住也要更改 `AudioStreamGenerator` 的混合率：

```gdscript
func get_sample_rate(is_toggled: bool) -> void:
	if is_toggled:
		current_sample_rate = Steam.getVoiceOptimalSampleRate()
	else:
		current_sample_rate = 48000
	$Local.stream.mix_rate = current_sample_rate
	$Network.stream.mix_rate = current_sample_rate
	print("当前采样率: %s" % current_sample_rate)
```

我们已经计算出了样本率，所以让我们试着实际播放这些数据。由于我们只是在测试一些东西，所以我们将使用 `local_` 变量和节点。

- Godot 2.x, 3.x

  ```gdscript
  func process_voice_data(voice_data: Dictionary, voice_source: String) -> void:
  	# 之前我们的采样率函数没有修改
  	get_sample_rate()
  
  	var decompressed_voice: Dictionary = Steam.decompressVoice(voice_data['buffer'], voice_data['written'], current_sample_rate)
  
  	if decompressed_voice['result'] == Steam.VOICE_RESULT_OK and decompressed_voice['size'] > 0:
  		print("解压语音: %s" % decompressed_voice['size'])
  
  		if voice_source == "local":
  			local_voice_buffer = decompressed_voice['uncompressed']
  			local_voice_buffer.resize(decompressed_voice['size'])
  
  			# 我们现在创建一个音频流，将数据放入
  			var local_audio: AudioStreamSample = AudioStreamSample.new()
  			local_audio.mix_rate = current_sample_rate
  			local_audio.data = local_voice_buffer
  			local_audio.format = AudioStreamSample.FORMAT_16_BITS
  
  			# 最后，将其放入一个节点并播放
  			$Local.stream = local_audio
  			$Local.play()
  ```

- Godot 4.x

  ```gdscript
  func process_voice_data(voice_data: Dictionary, voice_source: String) -> void:
  	# 之前我们的采样率函数没有修改
  	get_sample_rate()
  
  	var decompressed_voice: Dictionary = Steam.decompressVoice(voice_data['buffer'], voice_data['written'], current_sample_rate)
  
  	if decompressed_voice['result'] == Steam.VOICE_RESULT_OK and decompressed_voice['size'] > 0:
  		print("解压语音: %s" % decompressed_voice['size'])
  
  		if voice_source == "local":
  			local_voice_buffer = decompressed_voice['uncompressed']
  			local_voice_buffer.resize(decompressed_voice['size'])
  
  			# 现在，我们遍历 local_voice_buffer 并将样本推送到音频生成器
  			for i: int in range(0, mini(local_playback.get_frames_available() * 2, local_voice_buffer.size()), 2):
  				# Steam 的音频数据表示为 16 位单通道 PCM 音频，因此我们需要将其转换为振幅
  				# 组合低位和高位以获得完整的 16 位值
  				var raw_value: int = LOCAL_VOICE_BUFFER[0] | (LOCAL_VOICE_BUFFER[1] << 8)
  				# 将其设为 16 位有符号整数
  				raw_value = (raw_value + 32768) & 0xffff
  				# 将 16 位整数转换为从 -1 到 1 的浮点值
  				var amplitude: float = float(raw_value - 32768) / 32768.0
  
  				# push_frame() 使用 Vector2 参数。x 表示左通道，y 表示右通道
  				local_playback.push_frame(Vector2(amplitude, amplitude))
  
  				# 删除使用过的采样
  				local_voice_buffer.remove_at(0)
  				local_voice_buffer.remove_at(0)
  ```

### 录制语音

那么，我们实际上是如何将语音数据传输到 Steam 的呢？我们需要设置一个可以切换并连接到以下功能的按钮：

```gdscript
func record_voice(is_recording: bool) -> void:
	# 如果正在通话，请抑制 Steam UI 中的所有其他音频或语音通信
	Steam.setInGameVoiceSpeaking(steam_id, is_recording)

	if is_recording:
		Steam.startVoiceRecording()
	else:
		Steam.stopVoiceRecording()
```

小菜一碟！您会注意到我们的 `setInGameVoiceSpeaking` 有一个注释，它用于抑制来自 Steam UI 的任何声音或其他内容；你肯定会想要的。

您可能想提供始终在线语音聊天的选项，在这种情况下，您可能想在 `_ready()` 或其他地方启动此功能一次，以开始录制，直到播放器将其关闭。

这就是 Steam Voice 聊天的基础。同样，在这个例子中，播放有一种奇怪的起伏，但我们肯定可以在某个时候解决这个问题。

### 其他资源

#### 相关项目

[ikbencasdoei 的 Godot VOIP](https://github.com/ikbencasdoei/godot-voip)

#### 示例项目

[要查看本教程的实际操作，请查看我们在 GitHub 上的 GodotSteam 示例项目](https://github.com/GodotSteam/GodotSteam-Example-Project)。在那里，您可以获得所使用代码的完整视图，这可以作为您进行分支的起点。

## 工坊

一个热门话题出现了：工坊 / UGC。有很多移动部件，在本教程中我们可能会错过相当多。幸运的是，一些聪明人根据他们的经验提供了一些我们可以使用的信息。

> 相关 GodotSteam 类和函数
>
> - [Friends 类](https://godotsteam.com/classes/friends/)
>   - [activateGameOverlayToWebPage()](https://godotsteam.com/classes/friends/#activategameoverlaytowebpage)
> - [UGC 类](https://godotsteam.com/classes/ugc/)
>   - [createItem()](https://godotsteam.com/classes/ugc/#createitem)
>   - [createQueryUserUGCRequest()](https://godotsteam.com/classes/ugc/#createqueryuserugcrequest)
>   - [getItemInstallInfo()](https://godotsteam.com/classes/ugc/#getiteminstallinfo)
>   - [getSubscribedItems()](https://godotsteam.com/classes/ugc/#getsubscribeditems)
>   - [getQueryUGCResult()](https://godotsteam.com/classes/ugc/#getqueryugcresult)
>   - [releaseQueryUGCRequest()](https://godotsteam.com/classes/ugc/#releasequeryugcrequest)
>   - [sendQueryUGCRequest()](https://godotsteam.com/classes/ugc/#sendqueryugcrequest)
>   - [setReturnOnlyIDs()](https://godotsteam.com/classes/ugc/#setreturnonlyids)
>   - [startItemUpdate()](https://godotsteam.com/classes/ugc/#startitemupdate)
>   - [submitItemUpdate()](https://godotsteam.com/classes/ugc/#submititemupdate)
>   - [setItemContent()](https://godotsteam.com/classes/ugc/#setitemcontent)
>   - [setItemDescription()](https://godotsteam.com/classes/ugc/#setitemdescription)
>   - [setItemMetadata()](https://godotsteam.com/classes/ugc/#setitemmetadata)
>   - [setItemPreview()](https://godotsteam.com/classes/ugc/#setitempreview)
>   - [setItemTags()](https://godotsteam.com/classes/ugc/#setitemtags)
>   - [setItemTitle()](https://godotsteam.com/classes/ugc/#setitemtitle)
>   - [setItemUpdateLanguage()](https://godotsteam.com/classes/ugc/#setitemupdatelanguage)
>   - [setItemVisibility()](https://godotsteam.com/classes/ugc/#setitemvisibility)
> - [User 类](https://godotsteam.com/classes/user/)
>   - [getSteamID()](https://godotsteam.com/classes/user/#getsteamid)

### 开始之前

在做任何其他事情之前，你会想阅读 [Valve 在 Workshop / UGC上的文章，其中将涵盖本教程中没有涵盖的许多步骤](https://partner.steamgames.com/doc/features/workshop)。一旦你完成了这项工作，你还应该阅读 [Valve 关于工坊 / UGC 实施的报告，这样你就可以继续了](https://partner.steamgames.com/doc/features/workshop/implementation)。

当你最终读完这两篇文章时，我们就可以开始了。

### 工坊 / UGC 上传 / 下载

[**"被遗忘的梦想游戏"的卡普保罗**（**KarpPaul of Forgotten Dream Games**）为我们提供了关于在 Workshop / UGC 中上传和下载项目的非常棒的教程](https://forgottendreamgames.com/blog/godotsteam-how-to-upload-and-download-user-generated-content-ugc-repost.html)。由于他已经写了所有的东西，包括代码示例，所以当你只需点击链接并阅读全部内容时，没有任何理由在这里重申。

### 在 Workshop / UGC 中使用物品（Items）

**Lyaaaaaaaaaaaaaaa** 提交了一些代码，展示了他们如何在 Workshop / UGC 中使用物品：

```gdscript
extends Node

class_name Steam_Workshop

signal query_request_success

var published_items  : Array
var steam = SteamAutoload.steam    # 我不直接使用 “Steam” 来避免非 Steam 构建中的脚本错误。

var _app_id        : int =  ProjectSettings.get_setting("global/steam_app_id")
var _query_handler : int
var _page_number   : int = 1
var _subscribed_items : Dictionary

func _init() -> void:
	steam.connect("ugc_query_completed", self, "_on_query_completed")

	for item in steam.getSubscribedItems():
		var info : Dictionary
		info = get_item_install_info(item)
		if info["ret"] == true:
			_subscribed_items[item] = info


static func open_tos() -> void:
	var steam = SteamAutoload.steam
	var tos_url = "https://steamcommunity.com/sharedfiles/workshoplegalagreement"
	steam.activateGameOverlayToWebPage(tos_url)


func get_item_install_info(p_item_id : int) -> Dictionary:
	var info : Dictionary
	info = steam.getItemInstallInfo(p_item_id)

	if info["ret"] == false:
		var warning = "Item " + String(p_item_id) + " isn't installed or has no content"
		# 这里是您记录日志/显示错误的代码

	return info


func get_published_items(p_page : int = 1, p_only_ids : bool = false) -> void:
	var user_id : int = steam.getSteamID()
	var list    : int = steam.USER_UGC_LIST_PUBLISHED
	var type    : int = steam.WORKSHOP_FILE_TYPE_COMMUNITY
	var sort    : int = steam.USERUGCLISTSORTORDER_CREATIONORDERDESC

	_query_handler = steam.createQueryUserUGCRequest(user_id, list, type, sort, _app_id, _app_id, p_page)
	steam.setReturnOnlyIDs(_query_handler, p_only_ids)
	steam.sendQueryUGCRequest(_query_handler)


func get_item_folder(p_item_id : int) -> String:
	return _subscribed_items[p_item_id]["folder"]


func fetch_query_result(p_number_results : int) -> void:
	var result : Dictionary
	for i in range(p_number_results):
		result = steam.getQueryUGCResult(_query_handler, i)
		published_items.append(result)

	steam.releaseQueryUGCRequest(_query_handler)


func _on_query_completed(p_query_handler: int, p_result: int, p_results_returned: int, p_total_matching: int, p_cached: bool) -> void:

	if p_result == steam.RESULT_OK:
		fetch_query_result(p_results_returned)
	else:
		var warning = "Couldn't get published items. Error: " + String(p_result)
		# 这里是您记录日志/显示错误的代码

	if p_result == 50:
		_page_number ++ 1
		get_published_items(_page_number)

	elif p_result < 50:
		emit_signal("query_request_success", p_results_returned, _page_number)
```

#### 工坊 / UGC 物品

下面是 Lyaaaaaaaaaaaaaaa 的例子，这里是您的 Workshop / UGC 物品的一个类。

```gdscript
extends Node

class_name UGC_Item

signal item_created
signal item_updated
signal item_creation_failed
signal item_update_failed

var steam = SteamAutoload.steam # I don't use the `Steam` directly to avoid scripts errors in non-steam builds.

var _app_id  : int = ProjectSettings.get_setting("global/steam_app_id")
var _item_id : int
var _update_handler

func _init(p_item_id: int = 0, p_file_type: int = steam.WORKSHOP_FILE_TYPE_COMMUNITY) -> void:

	steam.connect("item_created", self, "_on_item_created")
	steam.connect("item_updated", self, "_on_item_updated")

	if p_item_id == 0:
		steam.createItem(_app_id, p_file_type)
	else:
		_item_id = p_item_id
		start_update(p_item_id)


func start_update(p_item_id : int) -> void:
	_update_handler = steam.startItemUpdate(_app_id, p_item_id)


func update(p_update_description : String = "Initial commit") -> void:
	steam.submitItemUpdate(_update_handler, p_update_description)


func set_title(p_title : String) -> void:
	if steam.setItemTitle(_update_handler, p_title) == false:
		# 这里是您记录日志/显示错误的代码


func set_description(p_description : String = "") -> void:
	if steam.setItemDescription(_update_handler, p_description) == false:
		# 这里是您记录日志/显示错误的代码


func set_update_language(p_language : String) -> void:
	if steam.setItemUpdateLanguage(_update_handler, p_language) == false:
		# 这里是您记录日志/显示错误的代码


func set_visibility(p_visibility : int = 2) -> void:
	if steam.setItemVisibility(_update_handler, p_visibility) == false:
		# 这里是您记录日志/显示错误的代码


func set_tags(p_tags : Array = []) -> void:
	if steam.setItemTags(_update_handler, p_tags) == false:
		# 这里是您记录日志/显示错误的代码


func set_content(p_content : String) -> void:
	if steam.setItemContent(_update_handler, p_content) == false:
		# 这里是您记录日志/显示错误的代码


func set_preview(p_image_preview : String = "") -> void:
	if steam.setItemPreview(_update_handler, p_image_preview) == false:
		# 这里是您记录日志/显示错误的代码


func set_metadata(p_metadata : String = "") -> void:
	if steam.setItemMetadata(_update_handler, p_metadata) == false:
		# 这里是您记录日志/显示错误的代码


func get_id() -> int:
	return _item_id


func _on_item_created(p_result : int, p_file_id : int, p_accept_tos : bool) -> void:
	if p_result == steam.RESULT_OK:
		_item_id = p_file_id
		# 这里是您记录日志/显示成功的代码
		emit_signal("item_created", p_file_id)
	else:
		var error = "创建工坊物品失败。错误: " + String(p_result)
		# 这里是您记录日志/显示错误的代码
		emit_signal("item_creation_failed", error)

	if p_accept_tos:
		Steam_Workshop.open_tos()


func _on_item_updated(p_result : int, p_accept_tos : bool) -> void:
	if p_result == steam.RESULT_OK:
		var item_url = "steam://url/CommunityFilePage/" + String(_item_id)
		# 这里是您记录日志/显示成功的代码
		steam.activateGameOverlayToWebPage(item_url)
		emit_signal("item_updated")
	else:
		var error = "更新工坊物品失败。错误: " + String(p_result)
		# 这里是您记录日志/显示错误的代码
		emit_signal("item_update_failed", error)

	if p_accept_tos:
		Steam_Workshop.open_tos()
```

### 奇怪的问题

KarpPaul 有一些关于从 `getQueryUGCResult` 获取“访问被拒绝”的信息：

> 关于我在 steamworks 中遇到的问题（Steam.getQueryUGCResult 在工坊对开发人员和客户可见时返回“访问被拒绝”）。我和 steam 的支持人员谈过了，他们无法重现错误。我检查了 ipc 日志，事实上一切看起来都很正常—— Steam 日志中没有拒绝访问的结果。然而，错误仍然存在于游戏中。不知道为什么会发生这种事，也不知道我怎么做的，也许我做错了。我想知道是否还有其他人会遇到这种情况。。。。无论如何，这并不重要，所以我只是让每个人都能看到我的工坊，并决定暂时忽略这个问题。