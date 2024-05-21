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
  # Get the image's handle
  var icon_handle: int = Steam.getAchievementIcon("ACH_WIN_ONE_GAME")
  
  # Get the image data
  var icon_size: Dictionary = Steam.getImageSize(icon_handle)
  var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)
  
  # Create the image for loading
  var icon_image: Image = Image.new()
  icon_image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])
  
  # Create a texture from the image
  var icon_texture: ImageTexture = ImageTexture.new()
  icon_texture.create_from_image(icon_image)
  
  # Display the texture on a sprite node
  $Sprite.texture = icon_texture
  ```

- Godot 4.x

  ```gdscript
  # Get the image's handle
  var icon_handle: int = Steam.getAchievementIcon("ACH_WIN_ONE_GAME")
  
  # Get the image data
  var icon_size: Dictionary = Steam.getImageSize(icon_handle)
  var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)
  
  # Create the image for loading
  var icon_image: Image = Image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])
  
  # Create a texture from the image
  var icon_texture: ImageTexture = ImageTexture.create_from_image(icon_image)
  
  # Display the texture on a sprite node
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
# Set up some variables
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
# Callback from getting the auth ticket from Steam
func _on_get_auth_session_ticket_response(this_auth_ticket: int, result: int) -> void:
    print("Auth session result: %s" % result)
    print("Auth session ticket handle: %s" % this_auth_ticket)
```

我们的 `_on_get_auth_session_ticket_response()` 函数将打印出身份验证票证的句柄以及获取票证是否成功（返回1）。您可以根据游戏的需要添加成功或失败的逻辑。如果成功，此时您可能需要将新票证发送到服务器或其他客户端进行验证。

说到验证：

```gdscript
# Callback from attempting to validate the auth ticket
func _on_validate_auth_ticket_response(auth_id: int, response: int, owner_id: int) -> void:
    print("Ticket Owner: %s" % auth_id)

    # Make the response more verbose, highly unnecessary but good for this example
    var verbose_response: String
    match response:
        0: verbose_response = "Steam has verified the user is online, the ticket is valid and ticket has not been reused."
        1: verbose_response = "The user in question is not connected to Steam."
        2: verbose_response = "The user doesn't have a license for this App ID or the ticket has expired."
        3: verbose_response = "The user is VAC banned for this game."
        4: verbose_response = "The user account has logged in elsewhere and the session containing the game instance has been disconnected."
        5: verbose_response = "VAC has been unable to perform anti-cheat checks on this user."
        6: verbose_response = "The ticket has been canceled by the issuer."
        7: verbose_response = "This ticket has already been used, it is not valid."
        8: verbose_response = "This ticket is not from a user instance currently connected to steam."
        9: verbose_response = "The user is banned for this game. The ban came via the Web API and not VAC."
    print("Auth response: %s" % verbose_response)
    print("Game owner ID: %s" % owner_id)
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

    # Get a verbose response; unnecessary but useful in this example
    var verbose_response: String
    match auth_response:
        0: verbose_response = "Ticket is valid for this game and this Steam ID."
        1: verbose_response = "The ticket is invalid."
        2: verbose_response = "A ticket has already been submitted for this Steam ID."
        3: verbose_response = "Ticket is from an incompatible interface version."
        4: verbose_response = "Ticket is not for this game."
        5: verbose_response = "Ticket has expired."
    print("Auth verifcation response: %s" % verbose_response))

    if auth_response == 0:
        print("Validation successful, adding user to client_auth_tickets")
        client_auth_tickets.append({"id": steam_id, "ticket": ticket.id})

    # You can now add the client to the game
```

如果响应为 `0`（意味着门票有效），您可以允许玩家连接到服务器或游戏。还将接收到一个回调并触发我们的 `_on_validate_auth_ticket_response()` 函数，正如我们之前看到的，该函数将连同身份验证票证提供商的 Steam ID、结果和游戏所有者的 Steam 标识一起发送。当另一个用户取消其身份验证票证时，也会触发此回调。稍后会详细介绍。

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

    # Then remove this client from the ticket array
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
# Start the auto matchmaking process.
func _on_auto_matchmake_pressed() -> void:
    # Set the matchmaking process over
    matchmake_phase = 0

    # Start the loop!
    matchmaking_loop()
```

这将启动主循环，为您的玩家寻找匹配的大厅：

```gdscript
# Iteration for trying different distances
func matchmaking_loop() -> void:
    # If this matchmake_phase is 3 or less, keep going
    if matchmake_phase < 4:
        ###
        # Add other filters for things like game modes, etc.
        # Since this is an example, we cannot set game mode or text match features.
        # However you could use addRequestLobbyListStringFilter to look for specific
        # text in lobby metadata to match different criteria.

        ###
        # Set the distance filter
        Steam.addRequestLobbyListDistanceFilter(matchmake_phase)

        # Request a list
        Steam.requestLobbyList()

    else:
        print("[STEAM] Failed to automatically match you with a lobby. Please try again.")
```

正如上面代码中所指出的，在搜索大厅之前，玩家可以从中选择不同的过滤器列表。这些可以应用于 `addRequestLobbyListStringFilter()` 提前查找的术语。比如游戏模式、地图、难度等等。

非常重要的是我们的 `addRequestLobbyListDistanceFilter()` 和 `matchmake_phase` 变量。我们以 “close”/0 开头，以 “worldwide”3 结尾；因此在 4 它找不到任何东西并且提示用户重试。

这个循环函数一旦找到一些要检查的大厅，就会触发一个回调。对我们的比赛进行排序应该如下所示：

```gdscript
# A lobby list was created, find a possible lobby
func _on_lobby_match_list(lobbies: Array) -> void:
    # Set attempting_join to false
    var attempting_join: bool = false

    # Show the list 
    for this_lobby in lobbies:
        # Pull lobby data from Steam
        var lobby_name: String = Steam.getLobbyData(this_lobby, "name")
        var lobby_nums: int = Steam.getNumLobbyMembers(this_lobby)

        ###
        # Add other filters for things like game modes, etc.
        # Since this is an example, we cannot set game mode or text match features.
        # However, much like lobby_name, you can use Steam.getLobbyData to get other
        # preset lobby defining data to append to the next if statement.
        ###

        # Attempt to join the first lobby that fits the criteria
        if lobby_nums < lobby_max_players and not attempting_join:
            # Turn on attempting_join
            attempting_join = true
            print("Attempting to join lobby...")
            Steam.joinLobby(this_lobby)

    # No lobbies that matched were found, go onto the next phase
    if not attempting_join:
        # Increment the matchmake_phase
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
      print("Avatar for user: %s" % user_id)
      print("Size: %s" % avatar_size)
  
      # Create the image for loading
      avatar_image = Image.new()
      avatar_image.create_from_data(avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)
  
      # Optionally resize the image if it is too large
      if avatar_size > 128:
          avatar_image.resize(128, 128, Image.INTERPOLATE_LANCZOS)
  
      # Apply the image to a texture
      var avatar_texture: ImageTexture = ImageTexture.new()
      avatar_texture.create_from_image(avatar_image)
  
      # Set the texture to a Sprite, TextureRect, etc.
      $Sprite.set_texture(avatar_texture)
  ```

- Godot 4.x

  ```gdscript
  func _on_loaded_avatar(user_id: int, avatar_size: int, avatar_buffer: PackedByteArray) -> void:
      print("Avatar for user: %s" % user_id)
      print("Size: %s" % avatar_size)
  
      # Create the image and texture for loading
      var avatar_image: Image = Image.create_from_data(avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)
  
      # Optionally resize the image if it is too large
      if avatar_size > 128:
          avatar_image.resize(128, 128, Image.INTERPOLATE_LANCZOS)
  
      # Apply the image to a texture
      var avatar_texture: ImageTexture = ImageTexture.create_from_image(avatar_image)
  
      # Set the texture to a Sprite, TextureRect, etc.
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
            # This friend is not playing a game
            continue
        else:
            # They are playing a game, check if it's the same game as ours
            var app_id: int = game_info['id']
            var lobby = game_info['lobby']

            if app_id != Steam.getAppID() or lobby is String:
                # Either not in this game, or not in a lobby
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
            # This friend is not playing a game
            continue
        else:
            # They are playing a game, check if it's the same game as ours
            var app_id: int = game_info['id']
            var lobby = game_info['lobby']

            if app_id != Steam.getAppID() or lobby is String:
                # Either not in this game, or not in a lobby
                continue

            results[steam_id] = lobby

    return results
```

从这里，您可以随心所欲地创建 UI，并在用户做出选择时简单地调用 `joinLobby(lobby_id)`。

### 检查朋友是否仍在大厅

在可能的情况下，您不是每帧都运行 `get_lobbies_with_friends()`，用户可能会点击朋友离开的大厅，或者更糟的是，点击一个不再存在的大厅。

这是您在加入大厅之前可以做的一个小检查：

```gdscript
# Check if a friend is in a lobby
func is_a_friend_still_in_lobby(steam_id: int, lobby_id: int) -> bool:
    var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)

    if game_info.empty():
        return false

    # They are in a game
    var app_id: int = game_info.id
    var lobby = game_info.lobby

    # Return true if they are in the same game and have the same lobby_id
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
    # Set your game's Steam app ID here
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
    print("Did Steam initialize?: %s " % initialize_response)
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
    print("Did Steam initialize?: %s" % initialize_response)

    if initialize_response['status'] > 0:
        print("Failed to initialize Steam, shutting down: %s" % initialize_response)
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
    print("User does not own this game")
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
print("Did Steam initialize?: %s " % initialize_response)
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
  
  # Steam variables
  var is_on_steam_deck: bool = false
  var is_online: bool = false
  var is_owned: bool = false
  var steam_app_id: int = 480
  var steam_id: int = 0
  var steam_username: String = ""
  
  
  func _init() -> void:
      # Set your game's Steam app ID here
      OS.set_environment("SteamAppId", str(steam_app_id))
      OS.set_environment("SteamGameId", str(steam_app_id))
  
  
  func _ready() -> void:
      initialize_steam()
  
  
  func _process(_delta: float) -> void:
      Steam.run_callbacks()
  
  
  func initialize_steam() -> void:
      var initialize_response: Dictionary = Steam.steamInitEx()
      print("Did Steam initialize?: %s" % initialize_response)
  
      if initialize_response['status'] > 0:
          print("Failed to initialize Steam. Shutting down. %s" % initialize_response)
          get_tree().quit()
  
      # Gather additional data
      is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
      is_online = Steam.loggedOn()
      is_owned = Steam.isSubscribed()
      steam_id = Steam.getSteamID()
      steam_username = Steam.getPersonaName()
  
      # Check if account owns the game
      if is_owned == false:
          print("User does not own this game")
          get_tree().quit()
  ```

- 有内部应用 ID 和回调

  ```gdscript
  extends Node
  
  # Steam variables
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
      print("Did Steam initialize?: %s" % initialize_response)
  
      if initialize_response['status'] > 0:
          print("Failed to initialize Steam. Shutting down. %s" % initialize_response)
          get_tree().quit()
  
      # Gather additional data
      is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
      is_online = Steam.loggedOn()
      is_owned = Steam.isSubscribed()
      steam_id = Steam.getSteamID()
      steam_username = Steam.getPersonaName()
  
      # Check if account owns the game
      if is_owned == false:
          print("User does not own this game")
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
        print("Leaderboard handle found: %s" % leaderboard_handle)
    else:
        print("No handle was found")
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
        # Add additional logic to use other variables passed back
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
  # Godot 2 and 3 have no equivalent for to_int32_array I am aware of. Any corrections welcome!
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
print("Max details: %s" % details_max)
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
    print("Scores downloaded message: %s" % message)

    # Save this for later leaderboard interactions, if you want
    var leaderboard_handle: int = this_leaderboard_handle

    # Add logic to display results
    for this_result in result:
        # Use each entry that is returned
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