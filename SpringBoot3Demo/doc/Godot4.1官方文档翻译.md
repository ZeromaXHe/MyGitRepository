# 手册

## 最佳实践

### 介绍

本系列是帮助您高效使用Godot的最佳实践的集合。

Godot 允许在如何构建项目的代码库并将其分解为场景方面具有很大的灵活性。每种方法都有其优缺点，在你使用引擎足够长的时间之前，很难权衡它们。

总是有很多方法可以构造代码并解决特定的编程问题。在这里不可能涵盖所有这些。

这就是为什么每一篇文章都从一个现实世界的问题开始。我们将把每个问题分解为基本问题，提出解决方案，分析每个选项的利弊，并强调解决当前问题的最佳方案。

您应该从阅读 Godot 中的应用面向对象原则开始。它解释了 Godot 的节点和场景如何与其他面向对象编程语言中的类和对象相关联。它将帮助您理解该系列的其余部分。

> **注意：**
>
> Godot 中的最佳实践依赖于面向对象的设计原则。我们使用单一责任原则和封装等工具。

### 在 Godot 中应用面向对象原则

该引擎提供了两种创建可重用对象的主要方法：脚本和场景。从技术上讲，这两种方法在底层原理上都没有定义类。

尽管如此，使用 Godot 的许多最佳实践都涉及到将面向对象的编程原理应用于组成游戏的脚本和场景。这就是为什么理解我们如何将它们视为类是有用的。

本指南简要介绍了脚本和场景如何在引擎的核心中工作，以帮助您了解它们是在底层原理上是如何工作的。

#### 引擎中的脚本如何工作

该引擎提供了像 Node 这样的内置类。可以使用脚本扩展这些类型以创建派生类型。

从技术上讲，这些脚本不是类。相反，它们是告诉引擎在引擎的一个内置类上执行一系列初始化的资源。

Godot 的内部类具有向 ClassDB 注册类的数据的方法。此数据库提供对类信息的运行时访问。`ClassDB` 包含有关类的信息，例如：

- 属性。
- 方法。
- 常数。
- 信号。

这个 `ClassDB` 是对象在执行诸如访问属性或调用方法之类的操作时检查的对象。它检查数据库的记录和对象的基类型的记录，以查看对象是否支持该操作。

将脚本附加到对象扩展了 `ClassDB` 中可用的方法、属性和信号。

> **注意：**
>
> 即使不使用 `extends` 关键字的脚本也会隐式继承自引擎的基 RefCounted 类。因此，您可以在不使用代码中的 `extends` 关键字的情况下实例化脚本。但是，由于它们扩展了 `RefCounted`，因此无法将它们附加到节点。

#### 场景

场景的行为与类有很多相似之处，因此将场景视为类是有意义的。场景是可重用、可实例化和可继承的节点组。创建场景类似于使用 `add_child()` 创建节点并将其添加为子节点的脚本。

我们经常将场景与使用场景节点的脚本根节点配对。因此，脚本通过命令式代码添加行为来扩展场景。

场景的内容有助于定义：

- 脚本可使用哪些节点
- 它们是如何组织的
- 它们是如何初始化的
- 它们之间有什么信号连接

为什么这些对现场组织很重要？因为场景的实例*是*对象。因此，许多适用于编写代码的面向对象原则也适用于场景：单一责任、封装等。

场景*始终是附加到其根节点的脚本的扩展*，因此可以将其解释为类的一部分。

本最佳实践系列中解释的大多数技术都建立在这一点之上。

### 场景组织

本文涵盖了与场景内容的有效组织相关的主题。应该使用哪些节点？应该把它们放在哪里？他们应该如何互动？

#### 如何有效率地建立关系

当 Godot 用户开始制作自己的场景时，他们经常会遇到以下问题：

他们创建了第一个场景，并在其中填充内容，但最终却将场景的分支保存到了单独的场景中，因为他们应该把事情分开的恼人感觉开始累积。然而，他们随后注意到，他们以前能够依赖的硬引用已经不可能了。在多个位置重复使用场景会产生问题，因为节点路径找不到它们的目标，并且在编辑器中断中建立了信号连接。

要解决这些问题，必须实例化子场景，而不需要有关其环境的详细信息。人们需要能够相信子场景会自己创建，而不必挑剔如何使用它。

OOP 中最需要考虑的事情之一是维护具有与代码库其他部分松散耦合的集中、奇异目的类。这使对象的大小保持较小（为了可维护性），并提高了它们的可重用性。

这些面向对象的最佳实践对场景结构和脚本使用方面的最佳实践有几个启示。

**如果可能的话，应该将场景设计为没有依赖关系**。也就是说，一个人应该创造场景，把他们需要的一切都保留在自己的内部。

如果场景必须与外部上下文交互，经验丰富的开发人员建议使用依赖注入。这种技术需要一个高级 API 来提供低级 API 的依赖关系。为什么要这样做？因为依赖于外部环境的类可能会无意中触发错误和意外行为。

要做到这一点，必须公开数据，然后依靠父上下文对其进行初始化：

1. 连接到信号。非常安全，但应仅用于“响应”行为，而不是启动行为。请注意，信号名称通常是过去时动词，如 “entered”、“skill_activated” 或 “item_collected”。

   ```python
   # Parent
   $Child.signal_name.connect(method_on_the_object)
   
   # Child
   signal_name.emit() # Triggers parent-defined behavior.
   ```

2. 调用一个方法。用于启动行为。

   ```python
   # Parent
   $Child.method_name = "do"
   
   # Child, assuming it has String property 'method_name' and method 'do'.
   call(method_name) # Call parent-defined method (which child must own).
   ```

3. 初始化可调用属性。比方法更安全，因为方法的所有权是不必要的。用于启动行为。

   ```python
   # Parent
   $Child.func_property = object_with_method.method_on_the_object
   
   # Child
   func_property.call() # Call parent-defined method (can come from anywhere).
   ```

4. 初始化节点或其他对象引用。

   ```python
   # Parent
   $Child.target = self
   
   # Child
   print(target) # Use parent-defined node.
   ```

5. 初始化 NodePath。

   ```python
   # Parent
   $Child.target_path = ".."
   
   # Child
   get_node(target_path) # Use parent-defined NodePath.
   ```

这些选项隐藏子节点的访问点。这反过来又使孩子与环境保持松散耦合。可以在另一个上下文中重用它，而无需对其 API 进行任何额外更改。

> **注意：**
>
> 尽管上面的例子说明了父子关系，但相同的原则适用于所有对象关系。作为同级的节点应该只知道它们的层次结构，而祖先则为它们的通信和引用提供中介。
>
> ```python
> # Parent
> $Left.target = $Right.get_node("Receiver")
> 
> # Left
> var target: Node
> func execute():
>     # Do something with 'target'.
> 
> # Right
> func _init():
>     var receiver = Receiver.new()
>     add_child(receiver)
> ```
>
> 同样的原则也适用于维护对其他对象的依赖关系的非节点对象。无论哪个对象实际拥有这些对象，都应该管理它们之间的关系。

> **警告：**
>
> 人们应该倾向于将数据保留在内部（场景内部），尽管对外部上下文（即使是松散耦合的上下文）的依赖仍然意味着节点将期望其环境中的某些东西是真实的。项目的设计理念应该防止这种情况发生。否则，代码的固有责任将迫使开发人员使用文档在微观尺度上跟踪对象关系；这也被称为开发地狱。默认情况下，编写依赖外部文档才能安全使用的代码很容易出错。
>
> 为了避免创建和维护此类文档，可以将依赖节点（上面的“子节点”）转换为实现 `_get_configuration_warning()` 的工具脚本。从中返回一个非空字符串将使场景停靠生成一个警告图标，其中该字符串作为节点的工具提示。当 Area2D 节点没有定义子 CollisionShape2D 节点时，该图标与 Area2D 等节点显示的图标相同。然后，编辑器通过脚本代码对场景进行自记录。无需通过文档进行内容复制。
>
> 像这样的 GUI 可以更好地通知项目用户有关节点的关键信息。它是否具有外部依赖关系？这些依赖关系得到满足了吗？其他程序员，尤其是设计人员和编写人员，需要在消息中给出明确的说明，告诉他们如何配置它。

那么，为什么所有这些复杂的开关都能工作呢？好吧，因为场景单独运行时效果最好。如果无法单独工作，那么匿名与他人合作（具有最小的硬依赖性，即松散耦合）是次佳选择。不可避免的是，可能需要对类进行更改，如果这些更改导致它以不可预见的方式与其他场景交互，那么事情就会开始崩溃。所有这些间接方法的全部目的是避免最终出现这样的情况：更改一个类会对依赖它的其他类产生不利影响。

脚本和场景作为引擎类的扩展，应该遵守所有 OOP 原则。示例包括……

- SOLID
- DRY
- KISS
- YAGNI

#### 选择一个节点树结构

因此，开发人员开始开发一款游戏，却止步于面前的巨大可能性。他们可能知道自己想做什么，想拥有什么系统，但把它们都放在哪里？好吧，一个人如何制作他们的游戏总是取决于他们。可以通过无数种方式构建节点树。但是，对于那些不确定的人来说，这本有用的指南可以给他们一个体面结构的样本。

一个游戏应该总是有一个“入口点”；在某个地方，开发人员可以明确地跟踪事情从哪里开始，这样他们就可以在其他地方继续遵循逻辑。这个地方还可以作为程序中所有其他数据和逻辑的鸟瞰图。对于传统应用程序，这将是“主要”功能。在这种情况下，它将是一个主节点。

- 节点 "Main"（Main.gd）

然后，`main.gd` 脚本将作为游戏的主要控制器。

然后有了他们真正的游戏中的“世界”（2D 或 3D）。这可以是 Main 的子项。此外，他们的游戏需要一个主 GUI 来管理项目所需的各种菜单和小部件。

- **节点 "Main"（Main.gd）**
  - Node2D/Node3D "World"（game_world.gd）
  - Control "GUI" (gui.gd)

更改级别时，可以交换出“世界”节点的子节点。手动更改场景可以让用户完全控制游戏世界的过渡方式。

下一步是考虑一个项目需要什么样的游戏系统。如果有一个系统……

1. 在内部跟踪其所有数据
2. 应该是全局可访问的
3. 应该孤立地存在

…然后应该创建一个自动加载的 “singleton” 节点。

> **注意：**
>
> 对于较小的游戏，一个控制较少的更简单的替代方案是使用一个 “Game” 单例，该单例只需调用 SceneTree.change_scene_to_file() 方法即可交换主场景的内容。这种结构或多或少地保持了 “World” 作为主要游戏节点的地位。
>
> 任何 GUI 也需要是一个单例；成为 “World” 的一部分；或者被手动添加为根的直接子级。否则，GUI 节点也会在场景转换过程中删除自己。

如果一个系统修改了其他系统的数据，那么应该将这些数据定义为自己的脚本或场景，而不是自动加载。有关原因的更多信息，请参阅“自动加载与常规节点”文档。

游戏中的每个子系统都应该在场景树中有自己的部分。只有在节点实际上是其父节点的元素的情况下，才应该使用父子关系。移除父母是否合理地意味着一个人也应该移除孩子？如果不是，那么它应该在层次结构中作为同级或其他关系有自己的位置。

> **注意：**
>
> 在某些情况下，需要这些分离的节点也相对于彼此定位它们自己。为此，可以使用 RemoteTransform/RemoteTransform2D 节点。它们将允许目标节点有条件地从 Remote* 节点继承选定的变换元素。要分配 `target` NodePath，请使用以下操作之一：
>
> 1. 一个可靠的第三方，可能是父节点，来调解分配。
> 2. 一个组，可以很容易地将引用拉到所需的节点（假设只有一个目标）。
>
> 什么时候应该这样做？嗯，这是主观的。当一个节点必须在场景树中移动以保护自己时，必须进行微观管理时，就会出现困境。例如……
>
> - 将 “player” 节点添加到 “room” 中。
>
> - 需要更改房间，因此必须删除当前房间。
>
> - 在可以删除房间之前，必须保留和/或移动玩家。
>   存储是个问题吗？
>
>   - 如果没有，可以创建两个房间，移动玩家并删除旧的房间。没问题。
>
>   如果是这样，就需要……
>
>   - 将玩家移到树上的其他地方。
>   - 删除房间。
>   - 实例化并添加新房间。
>   - 重新添加玩家。
>
> 问题是，这里的玩家是一个“特例”；开发人员必须知道他们需要以这种方式处理项目中的玩家。因此，作为一个团队可靠地共享这些信息的唯一方法是将其记录下来。然而，将实现细节保存在文档中是危险的。这是一种维护负担，使代码可读性紧张，并不必要地夸大了项目的知识内容。
>
> 在一个拥有更大资产的更复杂的游戏中，最好将玩家完全留在场景树中的其他地方。这导致：
>
> - 更加一致。
> - 没有必须记录和保存在某个地方的“特殊情况”。
> - 没有机会出现错误，因为这些详细信息没有被考虑在内。
>
> 相反，如果需要有一个子节点不继承其父节点的变换，则可以使用以下选项：
>
> 1. **声明性**(declarative)解决方案：在它们之间放置一个 Node。作为没有变换的节点，节点不会将此类信息传递给其子节点。
> 2. **命令式**(imperative)解决方案：对 CanvasItem 或 Node3D 节点使用 `top_level` 属性。这将使节点忽略其继承的变换。

> **注意：**
>
> 如果构建网络游戏，请记住哪些节点和游戏系统与所有玩家相关，而不是仅与权威服务器相关。例如，并非所有用户都需要拥有每个玩家的 “PlayerController” 逻辑的副本。相反，他们只需要自己的。因此，将这些与“世界”分离开来可以帮助简化游戏连接等的管理。

场景组织的关键是从关系的角度而不是空间的角度来考虑场景树。节点是否依赖于其父节点的存在？如果没有，那么他们可以在其他地方独自茁壮成长。如果他们是依赖性的，那么他们理所当然地应该是父母的孩子（如果他们还不是，那么很可能是父母场景的一部分）。

这是否意味着节点本身就是组件？一点也不。Godot 的节点树形成了一种聚合关系，而不是一种组合关系。但是，尽管仍然可以灵活地移动节点，但当默认情况下不需要这样的移动时，这仍然是最好的。

### 何时使用场景或脚本

我们已经介绍了场景和脚本的不同之处。脚本用命令式代码定义引擎类扩展，用声明性代码定义场景。

因此，每个系统的功能都不同。场景可以定义扩展类如何初始化，但不能定义其实际行为。场景通常与脚本、声明节点组成的场景以及使用命令式代码添加行为的脚本一起使用。

#### 匿名类型

单独使用脚本*可以*完全定义场景的内容。从本质上讲，这就是 Godot 编辑器所做的，只是在其对象的 C++ 构造函数中。

但是，选择使用哪一个可能是一个两难的选择。创建脚本实例与创建引擎内的类相同，而处理场景需要更改 API：

```python
const MyNode = preload("my_node.gd")
const MyScene = preload("my_scene.tscn")
var node = Node.new()
var my_node = MyNode.new() # Same method call
var my_scene = MyScene.instantiate() # Different method call
var my_inherited_scene = MyScene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN) # Create scene inheriting from MyScene
```

此外，由于引擎和脚本代码之间的速度差异，脚本的运行速度将比场景稍慢。节点越大、越复杂，就越有理由将其构建为场景。

#### 命名类型

脚本可以在编辑器本身中注册为新类型。这会在节点或资源创建对话框中将其显示为新类型，并带有可选图标。通过这种方式，用户使用脚本的能力更加精简。而不是必须……

1. 知道他们想要使用的脚本的基本类型。
2. 创建该基类型的实例。
3. 将脚本添加到节点。

对于已注册的脚本，脚本类型会变成一个创建选项，就像系统中的其他节点和资源一样。创建对话框甚至有一个搜索栏，可以按名称查找类型。

注册类型有两种系统：

- 自定义类型
  - 仅限编辑器。运行时无法访问类型名。
  - 不支持继承的自定义类型。
  - 初始化器工具。使用脚本创建节点。没什么了。
  - 编辑器对脚本或其与其他引擎类型或脚本的关系没有类型意识。
  - 允许用户定义图标。
  - 适用于所有脚本语言，因为它以抽象方式处理脚本资源。
  - 使用 EditorPlugin.add_custom_type 进行设置。
- 脚本类
  - 编辑器和运行时可访问。
  - 完整显示继承关系。
  - 使用脚本创建节点，但也可以从编辑器更改类型或扩展类型。
  - 编辑器知道脚本、脚本类和引擎 C++ 类之间的继承关系。
  - 允许用户定义图标。
  - 引擎开发人员必须手动添加对语言的支持（包括名称公开和运行时可访问性）。
  - 仅 Godot 3.1+ 版本。
  - 编辑器扫描项目文件夹，并为所有脚本语言注册任何公开的名称。每种脚本语言都必须实现自己的支持，以公开这些信息。

这两种方法都将名称添加到创建对话框中，但脚本类尤其允许用户在不加载脚本资源的情况下访问类型名称。创建实例和访问常量或静态方法在任何地方都是可行的。

有了这样的功能，人们可能希望他们的类型是没有场景的脚本，因为它给用户带来了易用性。那些开发插件或创建内部工具供设计师使用的人会发现这样做更容易。

不利的一面是，这也意味着必须在很大程度上使用命令式编程。

#### 脚本和 PackedScene 的性能对比

在选择场景和脚本时要考虑的最后一个方面是执行速度。

随着对象大小的增加，脚本创建和初始化它们所需的大小也会大大增加。创建节点层次结构说明了这一点。每个节点的逻辑长度可以是几百行代码。

下面的代码示例创建一个新 `Node`，更改其名称，为其分配一个脚本，将其未来的父节点设置为其所有者，以便将其保存到磁盘中，最后将其添加为 `Main` 节点的子节点：

```python
# main.gd
extends Node

func _init():
    var child = Node.new()
    child.name = "Child"
    child.script = preload("child.gd")
    child.owner = self
    add_child(child)
```

像这样的脚本代码比引擎端的 C++ 代码慢得多。每个指令都会调用脚本编写 API，这会导致在后端进行许多“查找”，以查找要执行的逻辑。

场景有助于避免此性能问题。场景继承的基本类型 PackedScene 定义了使用序列化数据创建对象的资源。该引擎可以在后端批量处理场景，并提供比脚本更好的性能。

#### 总结

最后，最好的方法是考虑以下几点：

- 如果一个人希望创建一个基本工具，该工具将在几个不同的项目中重复使用，并且所有技能水平的人都可能使用（包括那些不自称“程序员”的人），那么它很可能应该是一个脚本，很可能是一个带有自定义名称/图标的脚本。

- 如果一个人希望创造一个特定于他们游戏的概念，那么它应该始终是一个场景。场景比脚本更易于跟踪/编辑，并提供更高的安全性。

- 如果要为场景命名，那么他们仍然可以在 3.1 中通过声明脚本类并将场景作为常量来实现这一点。脚本实际上变成了一个命名空间：

  ```python
  # game.gd
  class_name Game # extends RefCounted, so it won't show up in the node creation dialog
  extends RefCounted
  
  const MyScene = preload("my_scene.tscn")
  
  # main.gd
  extends Node
  func _ready():
      add_child(Game.MyScene.instantiate())
  ```

### 自动加载对比常规节点

Godot 提供了一个功能，可以在项目的根目录下自动加载节点，允许您全局访问它们，这可以实现 Singleton 的角色：Singleton（自动加载）。使用 SceneTree.change_scene_to_file 从代码更改场景时，这些自动加载的节点不会释放。

在本指南中，您将了解何时使用自动加载功能，以及可以用来避免自动加载的技术。

#### 切割音频问题

其他引擎可以鼓励使用创建管理器类，即将许多功能组织到全局可访问对象中的单件。由于节点树和信号，Godot 提供了许多避免全局状态的方法。

例如，假设我们正在建造一个平台游戏，并希望收集能播放声音效果的硬币。有一个节点：AudioStreamPlayer。但是，如果我们在 `AudioStreamPlayer` 已经在播放声音时调用它，新的声音会中断第一个声音。

一个解决方案是编写一个全局的、自动加载的声音管理器类。它会生成一个 `AudioStreamPlayer` 节点池，这些节点在每次新的音效请求到来时循环使用。假设我们称该类为 `Sound`，您可以通过调用 `Sound.play("coin_pickup.ogg")` 在项目中的任何位置使用它。这在短期内解决了问题，但会引发更多问题：

1. **全局状态**：一个对象现在负责所有对象的数据。如果 `Sound` 类有错误或没有可用的 AudioStreamPlayer，则调用它的所有节点都可能中断。
2. **全局访问**：现在任何对象都可以从任何地方调用 `Sound.play(sound_path)`，不再有简单的方法可以找到错误的来源。
3. **全局资源分配**：从一开始就存储了一个 AudioStreamPlayer 节点池，您可能数量太少并面临错误，也可能数量太多并占用了超出所需的内存。

> **注意：**
>
> 关于全局访问，问题是，在我们的示例中，任何地方的任何代码都可能向 `Sound` 自动加载传递错误的数据。因此，要探索以修复错误的领域跨越了整个项目。
>
> 当您将代码保存在场景中时，音频中可能只涉及一个或两个脚本。

与此形成对比的是，每个场景都保留了所需数量的 `AudioStreamPlayer` 节点，所有这些问题都消失了：

1. 每个场景都管理自己的状态信息。如果数据有问题，它只会在那一个场景中引起问题。
2. 每个场景仅访问其自己的节点。现在，如果存在错误，很容易找到哪个节点有故障。
3. 每个场景都会精确地分配所需的资源量。

#### 管理共享功能或数据

使用自动加载的另一个原因可能是希望在许多场景中重用相同的方法或数据。

在函数的情况下，可以使用 GDScript 中的 class_name 关键字创建一种新类型的 `Node`，为单个场景提供该功能。

当涉及到数据时，您可以：

1. 创建新类型的资源以共享数据。
2. 将数据存储在每个节点都可以访问的对象中，例如使用 `owner` 属性访问场景的根节点。

#### 何时你需要使用自动加载

在某些情况下，自动加载的节点可以简化代码：

- **静态数据**：如果您需要一个类独有的数据，比如数据库，那么自动加载是一个很好的工具。Godot 中没有脚本 API 来创建和管理静态数据。
- **静态函数**：创建一个只返回值的函数库。
- **范围广泛的系统**：如果单例管理自己的信息，而不入侵其他对象的数据，那么这是创建

处理范围广泛任务的系统的好方法。例如，一个任务或一个对话系统。

在 Godot 3.1 之前，另一个用途只是为了方便：自动加载在 GDScript 中为其名称生成了一个全局变量，允许您从项目中的任何脚本文件中调用它们。但现在，您可以使用 `class_name` 关键字来获得整个项目中某个类型的自动完成。

> **注意：**
>
> Autoload 并不完全是一个 Singleton。没有什么可以阻止您实例化自动加载节点的副本。它只是一个使节点自动加载为场景树根的子节点的工具，无论游戏的节点结构或运行的场景如何，例如按 `F6` 键。
>
> 因此，您可以通过调用 `get_node("/root/Sound")` 来获得自动加载的节点，例如一个名为 `Sound` 的自动加载。

### 何时以及如何避免对所有内容使用节点

节点的生产成本很低，但即使是节点也有其局限性。一个项目可能有数以万计的节点，所有这些节点都在做事情。然而，他们的行为越复杂，每个行为对项目性能的影响就越大。

Godot 为创建节点使用的 API 提供了更轻量级的对象。在设计如何构建项目功能时，一定要记住这些选项。

1. Object：终极轻量级对象，原始对象必须使用手动内存管理。话虽如此，创建自己的自定义数据结构（甚至是节点结构）并不太困难，这些数据结构也比 Node 类轻。

   - **示例**：请参见 Tree 节点。它支持对具有任意行数和列数的内容表进行高级定制。它用来生成可视化的数据实际上是 TreeItem 对象的树。
   - **优点**：将 API 简化为范围较小的对象有助于提高其可访问性并缩短迭代时间。与其使用整个节点库，不如创建一组缩写的对象，节点可以从中生成和管理适当的子节点。

   > **注意：**
   >
   > 处理它们时应该小心。可以将对象存储到变量中，但这些引用可能会在没有警告的情况下变得无效。例如，如果对象的创建者突然决定删除它，那么当下次访问它时，就会触发错误状态。

2. RefCounted：只比 Object 稍微复杂一点。它们跟踪对自身的引用，只有在不存在对自身的进一步引用时才删除加载的内存。在大多数需要自定义类中的数据的情况下，这些都很有用。

   - **示例**：请参见 FileAccess 对象。它的功能就像一个普通的 Object，只是不需要自己删除它。
   - **优点**：与 Object 相同。

3. Resource：只比 RefCounted 稍微复杂一点。它们具有将其对象属性序列化到Godot 资源文件中/从 Godot 资源文件中反序列化（即保存和加载）的先天能力。

   - **示例**：脚本、PackedScene（用于场景文件）和其他类型，如每个 AudioEffect 类。其中的每一个都可以保存和加载，因此它们是从 Resource 扩展而来的。
   - **优点**：关于 Resource 相对于传统数据存储方法的优势，已经有很多说法了。不过，在使用 Resource 而不是 Node 的情况下，它们的主要优势在于 Inspector 兼容性。虽然几乎与 Object/RefCounted 一样轻，但它们仍然可以在 Inspector 中显示和导出属性。这使它们能够实现与可用性方面的子节点非常相似的目的，但如果计划在其场景中有许多这样的资源/节点，则也可以提高性能。

### Godot 接口

通常需要依赖于其他对象的脚本来实现功能。此过程分为两部分：

1. 获取对可能具有这些特征的对象的引用。
2. 访问对象中的数据或逻辑。

本教程的其余部分概述了完成这一切的各种方法。

#### 获取对象引用

对于所有 Object，引用它们的最基本方法是从另一个获取的实例中获取对现有对象的引用。

```python
var obj = node.object # Property access.
var obj = node.get_object() # Method access.
```

同样的原理也适用于 RefCounted 对象。虽然用户通常以这种方式访问 Node 和 Resource，但也可以采取其他措施。

可以通过加载访问来获取资源，而不是属性或方法访问。

```python
var preres = preload(path) # Load resource during scene load
var res = load(path) # Load resource when program reaches statement

# Note that users load scenes and scripts, by convention, with PascalCase
# names (like typenames), often into constants.
const MyScene : = preload("my_scene.tscn") as PackedScene # Static load
const MyScript : = preload("my_script.gd") as Script

# This type's value varies, i.e. it is a variable, so it uses snake_case.
export(Script) var script_type: Script

# If need an "export const var" (which doesn't exist), use a conditional
# setter for a tool script that checks if it's executing in the editor.
tool # Must place at top of file.

# Must configure from the editor, defaults to null.
export(Script) var const_script setget set_const_script
func set_const_script(value):
    if Engine.is_editor_hint():
        const_script = value

# Warn users if the value hasn't been set.
func _get_configuration_warning():
    if not const_script:
        return "Must initialize property 'const_script'."
    return ""
```

请注意以下内容：

1. 一种语言可以通过多种方式加载这样的资源。
2. 在设计对象访问数据的方式时，不要忘记也可以将资源作为引用传递。
3. 请记住，加载资源会获取引擎维护的缓存资源实例。要获得一个新对象，必须复制一个现有的引用，或者用 `new()` 从头开始实例化一个引用。

节点同样有一个替代的访问点：SceneTree。

```python
extends Node

# Slow.
func dynamic_lookup_with_dynamic_nodepath():
    print(get_node("Child"))

# Faster. GDScript only.
func dynamic_lookup_with_cached_nodepath():
    print($Child)

# Fastest. Doesn't break if node moves later.
# Note that `@onready` annotation is GDScript only.
# Other languages must do...
#     var child
#     func _ready():
#         child = get_node("Child")
@onready var child = $Child
func lookup_and_cache_for_future_access():
    print(child)

# Delegate reference assignment to an external source.
# Con: need to perform a validation check.
# Pro: node makes no requirements of its external structure.
#      'prop' can come from anywhere.
var prop
func call_me_after_prop_is_initialized_by_parent():
    # Validate prop in one of three ways.

    # Fail with no notification.
    if not prop:
        return

    # Fail with an error message.
    if not prop:
        printerr("'prop' wasn't initialized")
        return

    # Fail and terminate.
    # Note: Scripts run from a release export template don't
    # run `assert` statements.
    assert(prop, "'prop' wasn't initialized")

# Use an autoload.
# Dangerous for typical nodes, but useful for true singleton nodes
# that manage their own data and don't interfere with other objects.
func reference_a_global_autoloaded_variable():
    print(globals)
    print(globals.prop)
    print(globals.my_getter())
```

#### 从一个对象中访问数据或逻辑

Godot 的脚本 API 是鸭子类型的。这意味着，如果脚本执行操作，Godot 不会按类型验证它是否支持该操作。相反，它检查对象是否实现了单独的方法。

例如，CanvasItem 类有一个 `visible` 属性。所有公开给脚本 API 的属性实际上都是绑定到名称的 setter 和 getter 对。如果有人试图访问 CanvasItem.visible，那么Godot会按顺序进行以下检查：

- 如果对象附加了脚本，它将尝试通过脚本设置属性。这使得脚本有机会通过重写基对象上定义的属性的 setter 方法来重写该属性。
- 如果脚本没有该属性，它将在 ClassDB 中针对 CanvasItem 类及其所有继承类型执行 “visible” 属性的 HashMap 查找。如果找到，它将调用绑定的 setter 或 getter。有关 HashMaps 的更多信息，请参阅数据首选项文档。
- 如果找不到，它会进行显式检查，查看用户是否希望访问“脚本”或“元”属性。
- 如果不是，它将检查 CanvasItem 及其继承类型中的 `_set`/`_get` 实现（取决于访问类型）。这些方法可以执行给人以 Object 具有属性的印象的逻辑。`_get_property_list` 方法也是如此。
  - 请注意，即使是非合法的符号名称也会发生这种情况，例如 TileSet 的 “1/tile_name” 属性。这是指 ID 为 1 的瓦片的名称，即 `TileSet.tile_get_name(1)`。

因此，这个鸭子类型的系统可以在脚本、对象的类或对象继承的任何类中定位属性，但只能用于扩展 Object 的对象。

Godot 提供了多种选项，用于对这些访问执行运行时检查：

- 鸭子类型的属性访问。这些将是属性检查（如上所述）。如果对象不支持该操作，则执行将停止。

  ```python
  # All Objects have duck-typed get, set, and call wrapper methods.
  get_parent().set("visible", false)
  
  # Using a symbol accessor, rather than a string in the method call,
  # will implicitly call the `set` method which, in turn, calls the
  # setter method bound to the property through the property lookup
  # sequence.
  get_parent().visible = false
  
  # Note that if one defines a _set and _get that describe a property's
  # existence, but the property isn't recognized in any _get_property_list
  # method, then the set() and get() methods will work, but the symbol
  # access will claim it can't find the property.
  ```

- 方法检查。在 CanvasItem.visible 的情况下，可以像访问任何其他方法一样访问方法 `set_visible` 和 `is_visible`。

  ```python
  var child = get_child(0)
  
  # Dynamic lookup.
  child.call("set_visible", false)
  
  # Symbol-based dynamic lookup.
  # GDScript aliases this into a 'call' method behind the scenes.
  child.set_visible(false)
  
  # Dynamic lookup, checks for method existence first.
  if child.has_method("set_visible"):
      child.set_visible(false)
  
  # Cast check, followed by dynamic lookup.
  # Useful when you make multiple "safe" calls knowing that the class
  # implements them all. No need for repeated checks.
  # Tricky if one executes a cast check for a user-defined type as it
  # forces more dependencies.
  if child is CanvasItem:
      child.set_visible(false)
      child.show_on_top = true
  
  # If one does not wish to fail these checks without notifying users,
  # one can use an assert instead. These will trigger runtime errors
  # immediately if not true.
  assert(child.has_method("set_visible"))
  assert(child.is_in_group("offer"))
  assert(child is CanvasItem)
  
  # Can also use object labels to imply an interface, i.e. assume it
  # implements certain methods.
  # There are two types, both of which only exist for Nodes: Names and
  # Groups.
  
  # Assuming...
  # A "Quest" object exists and 1) that it can "complete" or "fail" and
  # that it will have text available before and after each state...
  
  # 1. Use a name.
  var quest = $Quest
  print(quest.text)
  quest.complete() # or quest.fail()
  print(quest.text) # implied new text content
  
  # 2. Use a group.
  for a_child in get_children():
      if a_child.is_in_group("quest"):
          print(quest.text)
          quest.complete() # or quest.fail()
          print(quest.text) # implied new text content
  
  # Note that these interfaces are project-specific conventions the team
  # defines (which means documentation! But maybe worth it?).
  # Any script that conforms to the documented "interface" of the name or
  # group can fill in for it.
  ```

- 外包对 Callable 的访问。在需要最大程度的不依赖性的情况下，这些可能很有用。在这种情况下，依赖于外部上下文来设置方法。

  ```python
  # child.gd
  extends Node
  var fn = null
  
  func my_method():
      if fn:
          fn.call()
  
  # parent.gd
  extends Node
  
  @onready var child = $Child
  
  func _ready():
      child.fn = print_me
      child.my_method()
  
  func print_me():
      print(name)
  ```

这些策略有助于 Godot 的灵活设计。在它们之间，用户拥有广泛的工具来满足他们的特定需求。

### Godot 通知

Godot 中的每个 Object 都实现了一个 _notification 方法。其目的是允许 Object 响应可能与其相关的各种引擎级回调。例如，如果引擎告诉 CanvasItem “绘制”，它将调用 `_notification(NOTIFICATION_DRAW)`。

其中一些通知，如 draw，对于在脚本中重写非常有用。如此之多，以至于 Godot 用专用函数公开了其中的许多：

- `_ready()` : NOTIFICATION_READY
- `_enter_tree()` : NOTIFICATION_ENTER_TREE
- `_exit_tree()` : NOTIFICATION_EXIT_TREE
- `_process(delta)` : NOTIFICATION_PROCESS
- `_physics_process(delta)` : NOTIFICATION_PHYSICS_PROCESS
- `_draw()` : NOTIFICATION_DRAW

用户可能*没有*意识到的是，除了 Node 之外，还存在其他类型的通知，例如：

- [Object::NOTIFICATION_POSTINITIALIZE](https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-constant-notification-postinitialize)：在对象初始化期间触发的回调。脚本无法访问。
- [Object::NOTIFICATION_PREDELETE](https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-constant-notification-predelete)：在引擎删除对象（即“析构函数”）之前触发的回调。

Node 中*确实*存在的许多回调没有任何专用方法，但仍然非常有用。

- [Node::NOTIFICATION_PARENTED](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-constant-notification-parented)：在向另一个节点添加子节点时触发的回调。
- [Node::NOTIFICATION_UNPARENTED](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-constant-notification-unparented)：从另一个节点移除子节点时触发的回调。

可以从通用 `_notification` 方法访问所有这些自定义通知。

> **注意：**
>
> 文档中标记为“虚拟”的方法也打算被脚本覆盖。
>
> 一个经典的例子是 Object 中的 _init 方法。虽然它没有等效的 `NOTIFICATION_*`，但引擎仍然调用该方法。大多数语言（除了 C#）都依赖它作为构造函数。

那么，在哪种情况下应该使用这些通知或虚拟功能呢？

#### _process vs. _physics_process vs. `*_input`

当需要帧之间与帧速率相关的增量时间时，请使用 `_process`。如果更新对象数据的代码需要尽可能频繁地更新，那么这是正确的位置。这里经常执行循环逻辑检查和数据缓存，但归根结底是需要更新评估的频率。如果他们不需要执行每一帧，那么实现 Timer-yield-timeout 循环是另一种选择。

```python
# Infinitely loop, but only execute whenever the Timer fires.
# Allows for recurring operations that don't trigger script logic
# every frame (or even every fixed frame).
while true:
    my_method()
    $Timer.start()
    yield($Timer, "timeout")
```

当需要帧之间与帧速率无关的增量时间时，请使用 `_physics_process`。如果代码需要随着时间的推移进行一致的更新，无论时间进展得有多快或有多慢，这都是正确的地方。递归运动学和对象变换操作应在此处执行。

虽然可以实现最佳性能，但应该避免在这些回调过程中进行输入检查 `_process` 和 `_physics_process` 将在每个机会触发（默认情况下，它们不会“休息”）。相反，`*_input` 回调将仅在引擎实际检测到输入的帧上触发。

可以在输入回调中检查输入操作。如果想要使用 delta 时间，可以根据需要从相关的 deltatime 方法中获取它。

```python
# Called every frame, even when the engine detects no input.
func _process(delta):
    if Input.is_action_just_pressed("ui_select"):
        print(delta)

# Called during every input event.
func _unhandled_input(event):
    match event.get_class():
        "InputEventKey":
            if Input.is_action_just_pressed("ui_accept"):
                print(get_process_delta_time())
```

#### _init vs. initialization vs. export

如果脚本在没有场景的情况下初始化自己的节点子树，那么代码应该在这里执行。其他与属性或 SceneTree 无关的初始化也应在此处运行。这在 `_ready` 或 `_enter_tree` 之前触发，但在脚本创建并初始化其属性之后触发。

脚本有三种类型的属性分配，可以在实例化期间发生：

```python
# "one" is an "initialized value". These DO NOT trigger the setter.
# If someone set the value as "two" from the Inspector, this would be an
# "exported value". These DO trigger the setter.
export(String) var test = "one" setget set_test

func _init():
    # "three" is an "init assignment value".
    # These DO NOT trigger the setter, but...
    test = "three"
    # These DO trigger the setter. Note the `self` prefix.
    self.test = "three"

func set_test(value):
    test = value
    print("Setting: ", test)
```

实例化场景时，属性值将按照以下顺序设置：

1. **初始值分配**：实例化将分配初始化值或初始分配值。初始化分配的优先级高于初始化值。
2. **导出值分配**：如果从场景而不是脚本实例化，Godot 将分配导出的值以替换脚本中定义的初始值。

因此，实例化脚本与场景将影响初始化*和*引擎调用 setter 的次数。

#### _ready vs. _enter_tree vs. NOTIFICATION_PARENTED

当实例化连接到第一个执行场景的场景时，Godot 将实例化树下的节点（进行 `_init` 调用），并构建从根向下的树。这将导致 `_enter_tree` 调用级联到树中。一旦树完成，叶节点就会调用 `_ready`。一旦所有子节点都完成了对其方法的调用，节点就会调用此方法。这会导致反向级联返回到树根。

实例化脚本或独立场景时，节点不会在创建时添加到 SceneTree，因此不会触发 `_enter_tree` 回调。相反，只发生 `_init` 调用。将场景添加到 SceneTree 中时，将发生 `_enter_tree` 和 `_ready` 调用。

如果需要触发作为另一个节点的父节点发生的行为，无论是否作为主/活动场景的一部分发生，都可以使用 PARENTED 通知。例如，这里有一个片段，它将节点的方法连接到父节点上的自定义信号，而不会失败。对可能在运行时创建的以数据为中心的节点很有用。

```python
extends Node

var parent_cache

func connection_check():
    return parent_cache.has_user_signal("interacted_with")

func _notification(what):
    match what:
        NOTIFICATION_PARENTED:
            parent_cache = get_parent()
            if connection_check():
                parent_cache.interacted_with.connect(_on_parent_interacted_with)
        NOTIFICATION_UNPARENTED:
            if connection_check():
                parent_cache.interacted_with.disconnect(_on_parent_interacted_with)

func _on_parent_interacted_with():
    print("I'm reacting to my parent's interaction!")
```

### 数据首选项

有没有想过应该用数据结构 Y 还是 Z 来处理问题 X？本文涵盖了与这些困境相关的各种主题。

> **注意：**
>
> 本文引用了 “[something]-time” 操作。这个术语来自算法分析的大 O 符号。
> 长话短说，它描述了运行时长度的最坏情况。用外行的话来说：
>
> “随着问题域的大小增加，算法的运行时长度……”
>
> - 恒定时间，`O(1)`：“…不增加。”
> - 对数时间，`O(log n)`：“…以缓慢的速度增加。”
> - 线性时间，`O(n)`：“…以相同的速率增加。”
> - 等等
>
> 想象一下，如果一个人必须在一帧内处理 300 万个数据点。用线性时间算法来制作该功能是不可能的，因为数据的巨大规模会使运行时间远远超过分配的时间。相比之下，使用恒定时间算法可以毫无问题地处理操作。
>
> 总的来说，开发人员希望尽可能避免进行线性时间操作。但是，如果保持线性时间运算的规模较小，并且不需要经常执行运算，那么这可能是可以接受的。平衡这些需求并为工作选择正确的算法/数据结构是程序员技能有价值的部分原因。

#### 数组 vs. 字典 vs. 对象

Godot 将脚本 API 中的所有变量存储在 Variant 类中。变体可以存储与变体兼容的数据结构，如数组和字典以及对象。

Godot 将 Array 实现为 `Vector<Variant>`。引擎将数组内容存储在内存的连续部分中，即它们位于彼此相邻的行中。

> **注意：**
>
> 对于那些不熟悉 C++ 的人来说，Vector 是传统 C++ 库中数组对象的名称。它是一个“模板化”类型，这意味着它的记录只能包含一个特定的类型（用尖括号表示）。因此，例如，PackedStringArray 类似于 `Vector<String>`。

连续的内存存储意味着以下操作性能：

- **迭代**：最快。非常适合循环。

  - 操作：它所做的只是增加一个计数器以获得下一个记录。

- **插入、擦除、移动**：位置相关。一般比较慢。

  - 操作：添加/删除/移动内容包括移动相邻的记录（以腾出空间/填充空间）。

  - 从末尾添加/删除较快。

  - 从任意位置添加/删除较慢。

  - 从前面添加/删除最慢。

  - 如果从前面进行多次插入/删除，那么……

    1. 反转数组。
    2. 执行一个循环，在最后执行数组更改。
    3. 重新反转阵列。

    这只复制了数组的2个副本（仍然是恒定的时间，但速度较慢），而复制了大约阵列的 1/2，平均 N 次（线性时间）。

- **获得，设置**：按位置最快。例如，可以请求第 0 条、第 2 条、第 10 条记录等，但不能指定您想要的记录。

  - 操作：1 个从数组起始位置到所需索引的加法运算。

- **查找**：最慢。标识值的索引/位置。

  - 操作：必须遍历数组并比较值，直到找到匹配项为止。
    - 性能还取决于是否需要进行详尽的搜索。
  - 如果保持有序，自定义搜索操作可以使其达到对数时间（相对较快）。不过，普通用户对此并不满意。通过在每次编辑后对数组进行重新排序，并编写有顺序的搜索算法来完成。

Godot 将 Dictionary 实现为 `OrderedHashMap<Variant, Variant>`。引擎存储键值对的小数组（初始化为 2^3 或 8 条记录）。当一个人试图访问一个值时，他们会为它提供一个密钥。然后，它对密钥进行散列运算，即将其转换为数字。“hash”用于计算数组中的索引。作为一个数组，OHM 可以在映射到值的键的“表”中快速查找。当 HashMap 变得太满时，它会增加到 2 的下一次幂（因此，是 16 个记录，然后是 32 个，等等），并重新构建结构。

散列是为了减少密钥冲突的机会。如果出现这种情况，则表必须重新计算考虑前一位置的值的另一个索引。总之，这导致了对所有记录的持续时间访问，而牺牲了内存和一些较小的操作效率。

1. 对每个键进行任意次数的哈希运算。
   - 哈希运算是恒定的时间，所以即使一个算法必须做不止一个，只要哈希计算的数量不会太依赖于表的密度，事情就会保持快速。这导致……
2. 为表保持不断增长的大小。
   - HashMaps 故意在表中保留未使用的内存间隙，以减少哈希冲突并保持访问速度。这就是为什么它的大小不断以 2 的幂二次方增加的原因。

可以看出，字典专门从事数组所没有的任务。其操作细节概述如下：

- **迭代**：快。
  - 操作：在映射的内部散列向量上迭代。返回每个键。然后，用户使用该键跳转到并返回所需的值。
- **插入、擦除、移动**：最快。
  - 操作：对给定的键进行哈希。执行 1 次加法运算以查找适当的值（数组起始 + 偏移）。移动是其中的两个（一个插入，一个擦除）。映射必须进行一些维护以保持其功能：
    - 更新已排序的记录列表。
    - 确定表密度是否要求扩展表容量。
  - 字典会记住用户插入键的顺序。这使它能够执行可靠的迭代。
- **获得，设置**：最快。与按键查找相同。
  - 操作：与插入/擦除/移动相同。
- **查找**：最慢。标识值的键。
  - 操作：必须遍历记录并比较值，直到找到匹配项为止。
  - 请注意，Godot 并没有提供开箱即用的功能（因为它们不适用于此任务）。

Godot 将对象实现为愚蠢但动态的数据内容容器。对象在提出问题时查询数据源。例如，为了回答“您有一个名为 ‘position’ 的属性吗？”的问题，它可能会询问其脚本或 ClassDB。人们可以在 Godot 文章中的应用面向对象原则中找到更多关于对象是什么以及它们如何工作的信息。

这里的重要细节是 Object 任务的复杂性。每次执行其中一个多源查询时，它都会运行几个迭代循环和 HashMap 查找。此外，查询是依赖于 Object 的继承层次结构大小的线性时间操作。如果 Object 查询的类（其当前类）没有找到任何内容，则请求将一直推迟到下一个基类，直到原始 Object 类。虽然这些都是孤立的快速操作，但它必须进行如此多的检查，这使得它们比查找数据的两种替代方法都慢。

> **注意：**
>
> 当开发人员提到脚本编写 API 的速度有多慢时，他们所指的就是这个查询链。与编译后的 C++ 代码相比，在编译后的代码中，应用程序可以准确地找到任何东西，编写 API 脚本的操作不可避免地要花费更长的时间。他们必须找到任何相关数据的来源，然后才能尝试访问这些数据。
>
> GDScript 之所以慢，是因为它执行的每一个操作都要经过这个系统。
>
> C# 可以通过更优化的字节码以更高的速度处理一些内容。但是，如果 C# 脚本调用引擎类的内容，或者脚本试图访问它外部的东西，它将通过这个管道。
>
> NativeScript C++ 更进一步，默认情况下将所有内容都保留在内部。对外部结构的调用将通过脚本 API 进行。在 NativeScript C++ 中，注册方法以将其公开给脚本 API 是一项手动任务。此时，外部的非 C++ 类将使用 API 来定位它们。

那么，假设从引用扩展到创建数据结构，比如数组或字典，为什么要选择 Object 而不是其他两个选项呢？

1. **控制**：有了对象，就有了创建更复杂结构的能力。可以对数据进行分层抽象，以确保外部API不会随着内部数据结构的更改而更改。更重要的是，对象可以有信号，允许反应行为。
2. **清晰性**：当涉及到脚本和引擎类为对象定义的数据时，对象是可靠的数据源。属性可能不包含期望的值，但一开始就不必担心该属性是否存在。
3. **方便**：如果一个人已经考虑到了类似的数据结构，那么从现有类进行扩展会使构建数据结构的任务变得更容易。相比之下，数组和字典并不能满足所有可能的用例。

对象还为用户提供了创建更加专业化的数据结构的机会。有了它，人们可以设计自己的列表、二进制搜索树、堆、伸展树、图、并查集和任何其他选项。

“为什么不将 Node 用于树结构？”有人可能会问。Node 类包含与自定义数据结构无关的内容。因此，在构建树结构时，构造自己的节点类型是很有帮助的。

```python
extends Object
class_name TreeNode

var _parent: TreeNode = null
var _children: = [] setget

func _notification(p_what):
    match p_what:
        NOTIFICATION_PREDELETE:
            # Destructor.
            for a_child in _children:
                a_child.free()
```

从这里，人们可以创造出自己的具有特定特征的结构，只受想象力的限制。

#### 枚举：int vs. string

大多数语言都提供枚举类型选项。GDScript 没有什么不同，但与大多数其他语言不同，它允许对枚举值使用整数或字符串（后者仅在 GDScript 中使用 `export` 关键字时使用）。那么问题来了，“应该用哪一个？”

简短的回答是，“无论你对哪个更满意。”这是 GDScript 特有的功能，而不是一般的 Godot 脚本；这些语言将可用性置于性能之上。

在技术层面上，整数比较（恒定时间）将比字符串比较（线性时间）更快。如果要保持其他语言的约定，那么应该使用整数。

当想要打印枚举值时，就会出现使用整数的主要问题。作为整数，尝试打印 MY_ENUM 将打印 `5` 或其他内容，而不是类似 `"MyEnum"` 的内容。要打印整数枚举，必须编写一个字典，为每个枚举映射相应的字符串值。

如果使用枚举的主要目的是打印值，并且希望将它们作为相关概念组合在一起，那么将它们用作字符串是有意义的。这样，就不需要在打印时执行单独的数据结构。

#### AnimatedTexture vs. AnimatedSprite2D vs. AnimationPlayer vs. AnimationTree

在什么情况下应该使用 Godot 的每个动画类？Godot 的新用户可能还不清楚答案。

[AnimatedTexture](https://docs.godotengine.org/en/stable/classes/class_animatedtexture.html#class-animatedtexture) 是引擎绘制为动画循环而非静态图像的纹理。用户可以操作……

1. 它在纹理的每个部分上移动的速率（fps）。
2. 纹理（帧）中包含的区域数。

Godot 的 RenderingServer 然后以规定的速率按顺序绘制区域。好消息是，这不涉及引擎部分的额外逻辑。坏消息是用户几乎没有控制权。

还要注意，AnimatedTexture 是一个资源，与这里讨论的其他 Node 对象不同。可以创建一个使用 AnimatedTexture 作为纹理的 Sprite2D 节点。或者（其他人做不到的事情）可以在 TileSet 中添加 AnimatedTextures 作为瓦片，并将其与 TileMap 集成，用于许多自动设置动画的背景，这些背景都在一个批量绘制调用中渲染。

AnimatedSprite2D 节点与 SpriteFrames 资源结合使用，可以通过子画面创建各种动画序列，在动画之间切换，并控制其速度、区域偏移和方向。这使得它们非常适合控制基于 2D 帧的动画。

如果需要触发与动画更改相关的其他效果（例如，创建粒子效果、调用函数或操纵基于帧的动画之外的其他外围元素），则需要将 AnimationPlayer 节点与 AnimatedSprite2D 结合使用。

如果玩家想要设计更复杂的 2D 动画系统，例如……

1. **剪切动画**：在运行时编辑精灵的变换。
2. **2D 网格动画**：为精灵的纹理定义一个区域，并为其装配一个骨架。然后为骨骼设置动画，根据骨骼之间的关系拉伸和弯曲纹理。
3. 以上内容的混合。

虽然需要一个 AnimationPlayer 来为游戏设计每个单独的动画序列，但组合动画进行混合也很有用，即实现这些动画之间的平滑过渡。在为其对象规划的动画之间也可能存在分层结构。在这些情况下，[AnimationTree](https://docs.godotengine.org/en/stable/classes/class_animationtree.html#class-animationtree) 大放异彩。你可以在这里找到关于使用动画树的深入指南。

### 逻辑首选项

有没有想过应该用策略 Y 还是 Z 来解决问题 X ？本文涵盖了与这些困境相关的各种主题。

#### 添加节点和更改属性：哪个先？

在运行时从脚本初始化节点时，可能需要更改节点名称或位置等属性。一个常见的困境是，你应该在什么时候改变这些值？

最佳做法是在将节点添加到场景树之前更改节点上的值。一些属性的 setter 有代码来更新其他相应的值，而这些代码可能很慢！在大多数情况下，此代码对游戏的性能没有影响，但在程序生成等大量使用情况下，它可能会使游戏陷入困境。

出于这些原因，在将节点添加到场景树之前，设置节点的初始值始终是最佳做法。

#### 加载 vs. 预加载

在 GDScript 中，存在全局预加载方法。它尽早加载资源，以预先加载“加载”操作，避免在性能敏感的代码中间加载资源。

它的对应方法 load 方法仅在资源到达 load 语句时才加载资源。也就是说，它将就地加载资源，当它发生在敏感进程中间时，可能会导致速度减慢。`load` 函数也是 ResourceLoader.load(path) 的别名，*所有*脚本语言都可以访问它。

那么，预加载和加载究竟是什么时候发生的，什么时候应该使用？让我们看一个例子：

```python
# my_buildings.gd
extends Node

# Note how constant scripts/scenes have a different naming scheme than
# their property variants.

# This value is a constant, so it spawns when the Script object loads.
# The script is preloading the value. The advantage here is that the editor
# can offer autocompletion since it must be a static path.
const BuildingScn = preload("res://building.tscn")

# 1. The script preloads the value, so it will load as a dependency
#    of the 'my_buildings.gd' script file. But, because this is a
#    property rather than a constant, the object won't copy the preloaded
#    PackedScene resource into the property until the script instantiates
#    with .new().
#
# 2. The preloaded value is inaccessible from the Script object alone. As
#    such, preloading the value here actually does not benefit anyone.
#
# 3. Because the user exports the value, if this script stored on
#    a node in a scene file, the scene instantiation code will overwrite the
#    preloaded initial value anyway (wasting it). It's usually better to
#    provide null, empty, or otherwise invalid default values for exports.
#
# 4. It is when one instantiates this script on its own with .new() that
#    one will load "office.tscn" rather than the exported value.
export(PackedScene) var a_building = preload("office.tscn")

# Uh oh! This results in an error!
# One must assign constant values to constants. Because `load` performs a
# runtime lookup by its very nature, one cannot use it to initialize a
# constant.
const OfficeScn = load("res://office.tscn")

# Successfully loads and only when one instantiates the script! Yay!
var office_scn = load("res://office.tscn")
```

预加载允许脚本在加载脚本时处理所有加载。预加载是有用的，但也有不希望的时候。为了区分这些情况，可以考虑以下几点：

1. 如果无法确定脚本何时加载，那么预加载资源，尤其是场景或脚本，可能会导致意想不到的进一步加载。这可能会导致在原始脚本的加载操作之上出现意外的可变长度加载时间。
2. 如果其他东西可以替换该值（例如场景的导出初始化），那么预加载该值就没有意义了。如果打算总是自己创建脚本，那么这一点并不是一个重要因素。
3. 如果只想“导入”另一个类资源（脚本或场景），那么使用预加载的常量通常是最好的做法。然而，在特殊情况下，人们可能不希望这样做：
   1. 如果“导入的”类易于更改，那么它应该是一个属性，使用 `export` 或 `load` 进行初始化（甚至可能要到以后才能初始化）。
   2. 如果脚本需要大量的依赖项，并且不希望消耗那么多内存，那么可能希望随着环境的变化在运行时加载和卸载各种依赖项。如果将资源预加载到常量中，那么卸载这些资源的唯一方法就是卸载整个脚本。如果它们是加载的属性，则可以将它们设置为 null，并完全删除对资源的所有引用（作为 RefCounted 扩展类型，这将导致资源从内存中自行删除）。

#### 大关卡：静态与动态

如果一个人正在创建一个大关卡，哪些情况最合适？他们是否应该将关卡创建为一个静态空间？还是他们应该把关卡分块加载，并根据需要改变世界的内容？

好吧，简单的答案是，“当性能需要时”。与这两个选项相关的困境是一个古老的编程选择：一个是优化内存超过速度，还是反之亦然？

天真的答案是使用一个同时加载所有内容的静态级别。但是，根据项目的不同，这可能会消耗大量内存。浪费用户的 RAM 会导致程序运行缓慢，或者计算机试图同时执行的其他操作完全崩溃。

不管怎样，都应该将较大的场景分解为较小的场景（以帮助资产的可重用性）。然后，开发人员可以设计一个节点，实时管理资源和节点的创建/加载和删除/卸载。具有大型和多样化环境或程序生成元素的游戏通常会执行这些策略，以避免浪费内存。

另一方面，对动态系统进行编码更为复杂，即使用更多的编程逻辑，这会导致出现错误和错误。如果一个人不小心，他们可能开发了一个增加应用程序的技术债务的系统。

因此，最好的选择是……

1. 对小型游戏使用静态关卡。
2. 如果一个人有时间/资源在一个中型/大型游戏上，创建一个库或插件，可以对节点和资源的管理进行编码。如果随着时间的推移进行改进，以提高可用性和稳定性，那么它可以发展成为跨项目的可靠工具。
3. 为中型/大型游戏编写动态逻辑代码，因为一个人有编码技能，但没有时间或资源来完善代码（游戏必须完成）。以后可能会进行重构，将代码外包到插件中。

有关在运行时交换场景的各种方法的示例，请参阅“手动更改场景”文档。

### 项目组织

#### 介绍

由于 Godot 对项目结构或文件系统的使用没有限制，因此在学习引擎时组织文件似乎很有挑战性。本教程建议了一个工作流，它应该是一个很好的起点。我们还将介绍使用 Godot 的版本控制。

#### 组织

Godot 本质上是基于场景的，并且按原样使用文件系统，没有元数据或资产数据库。

与其他引擎不同，许多资源都包含在场景本身中，因此文件系统中的文件量要低得多。

考虑到这一点，最常见的方法是对尽可能靠近场景的资产进行分组；当一个项目增长时，它使它更易于维护。

例如，通常可以将其基本资产（如精灵图像、3D模型网格、材质和音乐等）放在一个文件夹中。然后，他们可以使用一个单独的文件夹来存储使用它们的构建级别。

```
/project.godot
/docs/.gdignore  # See "Ignoring specific folders" below
/docs/learning.html
/models/town/house/house.dae
/models/town/house/window.png
/models/town/house/door.png
/characters/player/cubio.dae
/characters/player/cubio.png
/characters/enemies/goblin/goblin.dae
/characters/enemies/goblin/goblin.png
/characters/npcs/suzanne/suzanne.dae
/characters/npcs/suzanne/suzanne.png
/levels/riverdale/riverdale.scn
```

#### 风格指南

为了确保项目之间的一致性，我们建议遵循以下指南：

- 对文件夹和文件名使用 **snake_case**（C# 脚本除外）。这避开了在 Windows 上导出项目后可能出现的区分大小写问题。C# 脚本是这个规则的一个例外，因为惯例是按类名命名它们，类名应该使用 PascalCase。
- 使用 **PascalCase** 作为节点名称，因为这与内置的节点大小写匹配。
- 通常，将第三方资源保存在顶级 `addons/` 文件夹中，即使它们不是编辑器插件。这样可以更容易地跟踪哪些文件是第三方文件。这条规则也有一些例外；例如，如果您为角色使用第三方游戏资产，那么将它们与角色场景和脚本包含在同一文件夹中会更有意义。

#### 导入

3.0 之前的 Godot 版本完成了从项目外部文件的导入过程。虽然这在大型项目中很有用，但它给大多数开发人员带来了组织上的麻烦。

因此，现在可以从项目文件夹中透明地导入资源。

##### 忽略特定文件夹

为了防止 Godot 导入特定文件夹中包含的文件，请在文件夹中创建一个名为 `.gdignore` 的空文件（需要前导 `.`）。这有助于加快初始项目导入的速度。

> 要在 Windows 上创建名称以句点开头的文件，可以使用文本编辑器（如Notepad++）或在命令提示符下使用以下命令：`type nul > .gdignore`

一旦忽略该文件夹，就无法再使用 `load()` 和 `preload()` 方法加载该文件夹中的资源。忽略文件夹也会自动将其隐藏在 FileSystem dock 中，这有助于减少混乱。

请注意，`.gdignore` 文件的内容被忽略，这就是为什么该文件应该为空的原因。它不支持像 `.gitignore` 文件那样的模式。

#### 大小写敏感

默认情况下，Windows 和最新的 macOS 版本使用不区分大小写的文件系统，而 Linux 发行版默认情况下使用区分大小写文件系统。这可能会导致导出项目后出现问题，因为 Godot 的 PCK 虚拟文件系统区分大小写。为了避免这种情况，建议对项目中的所有文件（通常使用小写字符）坚持使用 `snake_case` 命名。

> **注意：**
>
> 当样式指南另有规定时（例如 C# 样式指南），您可以打破此规则。尽管如此，还是要保持一致以避免错误。

在 Windows 10 上，为了进一步避免与区分大小写相关的错误，您还可以使项目文件夹区分大小写。启用 Windows Subsystem for Linux 功能后，请在 PowerShell 窗口中运行以下命令：

```shell
# To enable case-sensitivity:
fsutil file setcasesensitiveinfo <path to project folder> enable

# To disable case-sensitivity:
fsutil file setcasesensitiveinfo <path to project folder> disable
```

如果您尚未启用 Windows Subsystem for Linux，则可以在以管理员身份运行的 PowerShell 窗口中输入以下行，然后在询问时重新启动：

```shell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

### 版本控制系统

#### 简介

Godot 的目标是对 VCS 友好，并生成大部分可读和可合并的文件。Godot 还支持在编辑器中使用版本控制系统。但是，编辑器中的 VCS 需要针对您正在使用的特定 VCS 的插件。VCS 可以在编辑器中的**项目 > 版本控制**下进行设置或关闭。

#### 官方 Git 插件

官方插件支持在编辑器内部使用 Git。你可以在这里找到最新版本。关于如何使用 Git 插件的文档可以在这里找到。

#### 要从 VCS 中排除的文件

Godot 自动创建了一些文件和文件夹。您应该将它们添加到 VCS 忽略：

- `.godot/`：此文件夹存储各种项目缓存数据。`.godot/imported/` 存储引擎根据源资产及其导入标志自动导入的所有文件。`.godot/editor/` 保存有关编辑器状态的数据，例如当前打开的脚本文件和最近使用的节点。
- `*.translation`：这些文件是从 CSV 文件生成的二进制导入翻译。
- `export_presets.cfg`：该文件包含项目的所有导出预设，包括敏感信息，如 Android 密钥库凭据。
- `.mono/`：此文件夹存储自动生成的 Mono 文件。它只存在于使用 Mono 版本Godot的项目中。

> **提示：**
>
> 将此 .gitignore 文件保存在项目的根文件夹中，以自动设置文件排除。

#### 和 Windows 上的 Git 一起工作

大多数 Git for Windows 客户端的配置都将 `core.autocrlf` 设置为 `true`。这可能会导致文件不必要地被 Git 标记为已修改，因为它们的行尾会自动转换。最好将此选项设置为：

```shell
git config --global core.autocrlf input
```

#### 已知问题

运行 `git pull` 之前**始终关闭编辑器**！否则，如果在编辑器打开时同步文件，则可能会丢失数据。

## 2D

### 画布层

#### Viewport 和 Canvas 项目

CanvasItem 是所有 2D 节点的基础，无论是常规的 2D 节点，如 Node2D 还是 Control。两者都继承自 CanvasItem。您可以在树中排列画布项目。每个项都将继承其父项的变换：当父项移动时，其子项也会移动。

CanvasItem 节点及其继承的节点是 Viewport 的直接或间接子节点，Viewport 会显示这些节点。

Viewport 的属性 Viewport.canvas_transform 允许将自定义 Transform2D 变换应用于其包含的 CanvasItem 层次结构。Camera2D 等节点通过更改变换来工作。

为了实现滚动等效果，操纵画布变换属性比移动根画布项及其整个场景更有效。

不过，通常情况下，我们不希望游戏或应用程序中的*所有内容*都受到画布转换的影响。例如：

- **视差背景**：移动速度比舞台其他部分慢的背景。
- **UI**：想象一下叠加在我们游戏世界视图上的用户界面（UI）或平视显示器（HUD）。我们希望生命计数器、分数显示和其他元素即使在我们对游戏世界的看法发生变化时也能保留其屏幕位置。
- **过渡**：我们可能希望用于过渡（渐变、混合）的视觉效果保持在固定的屏幕位置。

如何在单个场景树中解决这些问题？

#### CanvasLayers

答案是 CanvasLayer，它是一个为其所有子级和子级添加单独 2D 渲染层的节点。默认情况下，Viewport 子层将在“0”层绘制，而 CanvasLayer 将在任何数字层绘制。编号较大的图层将绘制在编号较小的图层之上。CanvasLayers 也有自己的变换，不依赖于其他层的变换。这使得 UI 可以固定在屏幕空间中，同时我们对游戏世界的看法也会发生变化。

这方面的一个例子是创建视差背景。这可以用“-1”层的 CanvasLayer 来完成。带有点数、生命计数器和暂停按钮的屏幕也可以在“1”层创建。

下面是它的外观图：



CanvasLayers 与树的顺序无关，它们只取决于它们的层数，因此可以在需要时实例化它们。

> **注意：**
>
> 控制节点的绘制顺序不需要 CanvasLayers。确保节点正确绘制在其他节点的“前面”或“后面”的标准方法是操纵场景面板中节点的顺序。也许与直觉相反，场景面板中最顶部的节点绘制在视口中较低节点的后面。二维节点还具有 CanvasItem.z_index 特性，用于控制其绘制顺序。

### Viewport 和画布转换

#### 简介

这是节点从本地绘制内容到绘制到屏幕上的 2D 转换的概述。本概述讨论了引擎的低级别细节。

#### 画布转换

如前一教程“画布层”中所述，每个 CanvasItem 节点（请记住，Node2D 和基于 Control 的节点使用 CanvasItem 作为其公共根）都将位于 Canvas Layer 中。每个画布层都有一个可以作为 Transform2D 访问的变换（平移、旋转、缩放等）。

在上一个教程中也介绍了，默认情况下，节点是在内置画布的第 0 层中绘制的。要将节点放在不同的层中，可以使用 CanvasLayer 节点。

#### 全局画布变换

Viewports 还具有全局画布变换（也称为 Transform2D）。这是主变换，影响所有单独的 Canvas Layer 变换。一般来说，这种转换没有多大用处，但在 Godot 编辑器的 CanvasItem 编辑器中使用。

#### 拉伸变换

最后，视口有一个“拉伸变换”，用于调整屏幕大小或拉伸屏幕。此变换在内部使用（如“多分辨率”中所述），但也可以在每个视口上手动设置。

输入事件与此变换相乘，但缺少上面的那些。为了将 InputEvent 坐标转换为本地 CanvasItem 坐标，为了方便起见，添加了 CanvasItem.make_input_local() 函数。

#### 变换顺序

要使 CanvasItem 本地属性中的坐标成为实际屏幕坐标，必须应用以下转换链：

#### 变换函数

通过以下功能可以获得每个变换：

| 类型                             | 变换                                                         |
| -------------------------------- | ------------------------------------------------------------ |
| CanvasItem                       | [CanvasItem.get_global_transform()](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#class-canvasitem-method-get-global-transform) |
| CanvasLayer                      | [CanvasItem.get_canvas_transform()](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#class-canvasitem-method-get-canvas-transform) |
| CanvasLayer+GlobalCanvas+Stretch | [CanvasItem.get_viewport_transform()](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#class-canvasitem-method-get-viewport-transform) |

最后，要将 CanvasItem 本地坐标转换为屏幕坐标，只需按以下顺序相乘：

```python
var screen_coord = get_viewport_transform() * (get_global_transform() * local_pos)
```

但是，请记住，通常不希望使用屏幕坐标。建议的方法是简单地使用 Canvas 坐标（CanvasItem.get_global_transform()），以允许自动调整屏幕分辨率以正常工作。

#### 提供自定义输入事件

通常需要将自定义输入事件提供给场景树。有了以上知识，要正确地做到这一点，必须按照以下方式进行：

```py
var local_pos = Vector2(10, 20) # local to Control/Node2D
var ie = InputEventMouseButton.new()
ie.button_index = MOUSE_BUTTON_LEFT
ie.position = get_viewport_transform() * (get_global_transform() * local_pos)
get_tree().input_event(ie)
```

### 渲染

#### 2D 光照和阴影

##### 简介

默认情况下，Godot 中的 2D 场景是未着色的，没有可见的灯光和阴影。虽然渲染速度很快，但未着色的场景可能看起来平淡无奇。Godot 提供了使用实时 2D 照明和阴影的能力，这可以大大增强项目的深度感。

##### 节点

完整的二维光源设置中涉及多个节点：

- CanvasModulate（使场景的其余部分变暗）
- PointLight2D（用于全向灯或聚光灯）
- DirectionalLight2D（用于阳光或月光）
- LightOccluder2D（用于光影投射器）
- 接收照明的其他 2D 节点，例如 Sprite2D 或 TileMap。

[CanvasModulate](https://docs.godotengine.org/en/stable/classes/class_canvasmodulate.html#class-canvasmodulate) 用于通过指定将用作基本“环境”颜色的颜色来使场景变暗。这是任何 2D 光都无法到达的区域中的最终照明颜色。如果没有 CanvasModulate 节点，最终场景将看起来过于明亮，因为 2D 灯光只会使现有的未着色外观（看起来完全亮起）变亮。

[Sprite2Ds](https://docs.godotengine.org/en/stable/classes/class_sprite2d.html#class-sprite2d) 用于显示光斑、背景和阴影投射器的纹理。

[PointLight2Ds](https://docs.godotengine.org/en/stable/classes/class_pointlight2d.html#class-pointlight2d) 用于照亮场景。灯光的工作方式通常是在场景的其余部分添加选定纹理以模拟照明。

[LightOccluder2Ds](https://docs.godotengine.org/en/stable/classes/class_lightoccluder2d.html#class-lightoccluder2d) 用于告诉着色器场景的哪些部分投射阴影。这些遮挡物可以作为独立节点放置，也可以是 TileMap 节点的一部分。

阴影仅出现在 PointLight2D 覆盖的区域上，其方向基于灯光的中心。

> **注意：**
>
> 背景颜色**不**接收任何照明。如果希望在背景上投射灯光，则需要为背景添加视觉表示，例如 Sprite2D。
>
> “Sprite2D”的“**区域**”（Region）属性有助于快速创建重复的背景纹理，但请记住，也要在 Sprite2D 的属性中将“**纹理 > 重复**”（texture>Repeat）设定为“**启用**”（Enabled）。

##### 点光源

点光源（也称为位置光源）是二维光源中最常见的元素。点光源可用于表示火炬、火焰、投射物等发出的光。

PointLight2D 提供了以下属性以在检查器中进行调整：

- **纹理**：用作光源的纹理。纹理的大小决定了灯光的大小。纹理可能有一个 alpha 通道，这在使用 Light2D 的**混合**调和模式（Mix blend mode）时很有用，但在使用“**添加**”（默认）或“**减去**”调和模式时则不需要。
- **偏移**：灯光纹理的偏移。与移动灯光节点时不同，更改偏移不会导致阴影移动。
- **纹理比例**：灯光大小的倍增。较高的值将使灯光进一步向外延伸。较大的灯光会影响屏幕上更多的像素，因此性能成本较高，因此在增加灯光大小之前请考虑这一点。
- **高度**：灯光相对于法线贴图的虚拟高度。默认情况下，灯光非常靠近接收灯光的曲面。如果使用法线贴图，这将使照明几乎不可见，因此请考虑增加该值。调整灯光的高度只会在使用法线贴图的曲面上产生可见的差异。

如果没有预先制作的纹理用于灯光，可以使用此“中性”点光源纹理（右键单击 > **将图像另存为…**）：

如果需要不同的衰减，可以通过在灯光的“**纹理**”（Texture）属性上指定“**新 GradientTexture2D**”来按程序创建纹理。创建资源后，展开其“**填充**”（Fill）部分，并将填充模式设置为“**径向**”（Radial）。然后，您必须调整渐变本身，使其从不透明的白色开始变为透明的白色，并将其开始位置移动到中心。

##### 定向光

Godot 4.0 的新功能是能够在 2D 中进行定向照明。定向照明用于表示阳光或月光。光线相互平行投射，就好像太阳或月亮离接收光线的表面无限远一样。

DirectionalLight2D 提供以下特性：

- **高度**：灯光相对于法线贴图的虚拟高度（`0.0`=平行于曲面，`1.0`=垂直于曲面）。默认情况下，灯光与接收灯光的曲面完全平行。如果使用法线贴图，这将使照明几乎不可见，因此请考虑增加该值。调整灯光的高度只会在使用法线贴图的曲面上产生视觉差异。**高度**不会影响阴影的外观。
- **最大距离**：与摄影机中心对象的最大距离可以在其阴影被剔除之前（以像素为单位）。减小该值可以防止位于摄影机外部的对象投射阴影（同时还可以提高性能）。“**最大距离**”（Max Distance）不考虑 Camera2D 缩放，这意味着在较高的缩放值下，当缩放到给定点时，阴影会更快地消失。

> **注意：**
>
> 无论“高度”特性的值如何，方向阴影始终显示为无限长。这是 Godot 中用于 2D 灯光的阴影渲染方法的限制。
>
> 要使方向阴影不是无限长，应禁用 DirectionalLight2D 中的阴影，并使用从 2D 签名距离字段读取的自定义着色器。该距离场是由场景中存在的 LightOccluder2D 节点自动生成的。

##### 常见光属性

PointLight2D 和 DirectionalLight2D 都提供了共同的属性，这些属性是 Light2D 基类的一部分：

- **启用**（Enable）：允许切换灯光的可见性。与隐藏灯光节点不同，禁用此特性不会隐藏灯光的子对象。
- **仅编辑器**（Editor Only）：如果启用，则灯光仅在编辑器中可见。它将在正在运行的项目中自动禁用。
- **颜色**（Color）：灯光的颜色。
- **能量**（Energy）：光的强度倍增器。值越高，灯光越亮。
- **调和模式**（Blend Mode）：用于灯光计算的混合公式。默认的“**添加**”适用于大多数用例。**减法**可以用于负光，这些负光在物理上不精确，但可以用于特殊效果。**混合**调和模式通过线性插值将灯光纹理对应的像素值与其下的像素值混合。
- **范围 > Z 最小值**（Range > Z Min）：受灯光影响的最低 Z 索引。
- **范围 > Z 最大值**（Range > Z Max）：受灯光影响的最高 Z 索引。
- **范围 > 最小层**（Range > Layer Min）：受灯光影响的最低视觉层。
- **范围 > 最大层**（Range > Layer Max）：受灯光影响的最高视觉层。
- **范围 > 项目消隐遮罩**（Range > Item Cull Mask）：控制哪些节点从该节点接收灯光，具体取决于其他节点启用的视觉层“**遮挡灯光遮罩**”（Occluder light Mask）。这可以用来防止某些物体接收光。

##### 设置阴影

在 PointLight2D 或 DirectionalLight2D 节点上启用“Shadow”>“Enabled”属性后，最初不会看到任何视觉差异。这是因为场景中还没有任何节点具有任何遮挡物，这些遮挡物被用作阴影投射的基础。

为了使阴影出现在场景中，必须将 LightOccluder2D 节点添加到场景中。这些节点还必须具有设计为匹配精灵轮廓的遮挡多边形。

LightOccluder2D 节点及其多边形资源（必须设置为具有任何视觉效果）具有两个属性：

- **SDF 碰撞**：如果启用，遮挡器将成为可在自定义着色器中使用的实时生成的带符号距离字段的一部分。当不使用从SDF读取的自定义着色器时，启用该着色器不会产生视觉差异，也不会产生性能成本，因此为方便起见，默认情况下会启用该着色器。
- **遮挡灯光遮罩**：它与 PointLight2D 和 DirectionalLight2D 的 Shadow > Item Cull Mask 属性一起使用，以控制哪些对象为每个灯光投射阴影。这可用于防止特定对象投射阴影。

有两种方法可以创建光遮挡器：

###### 自动生成一个光遮挡器

通过选择节点，单击 2D 编辑器顶部的“**Sprite2D**”菜单，然后选择“**创建 LightOccluder2D 同级**（Create LightOccluder2D Sibling）”，可以从精灵 2D 节点自动创建遮挡器。

在出现的对话框中，轮廓将围绕精灵的边缘。如果轮廓与精灵的边缘非常匹配，可以单击“**确定**（OK）”。如果轮廓离精灵的边缘太远（或正在“侵蚀”精灵的边缘），请调整“**增长（像素）**”（Grow (pixels)）和“**收缩（像素）**”（Shrink (pixels)），然后单击“**更新预览**”（Update Preview）。重复此操作，直到获得满意的结果。

###### 手动绘制光遮挡器

创建一个 LightOccluder2D 节点，然后选择该节点并单击 2D 编辑器顶部的“+”按钮。当被要求创建多边形资源时，回答“**是**”。然后，可以通过单击创建新点来开始绘制遮挡多边形。您可以通过右键单击现有点来删除这些点，也可以通过单击现有直线然后拖动来从现有直线创建新点。

可以在启用阴影的二维光源上调整以下特性：

- **颜色**：着色区域的颜色。默认情况下，着色区域为全黑，但出于艺术目的可以更改此设置。颜色的 alpha 通道控制阴影被指定颜色着色的程度。
- **过滤器**：用于阴影的过滤器模式。默认的“**无**”渲染速度最快，非常适合具有像素艺术美学的游戏（由于其“块状”视觉效果）。如果需要柔和的阴影，请改用 **PCF5**。**PCF13** 甚至更软，但渲染要求最高。PCF13由于其高渲染成本而应一次仅用于少数灯光。
- **过滤器平滑**：控制当“**过滤器**”设置为 **PCF5** 或 **PCF13** 时对阴影应用的软化程度。较高的值会产生较柔和的阴影，但可能会导致条纹伪影可见（尤其是PCF5）。
- **项目消隐遮罩**：控制哪些 LightOccluder2D 节点投射阴影，具体取决于它们各自的“**遮挡器灯光遮罩**”（Occluder Light Mask）属性。

###### 遮挡器绘制顺序

**LightOccluder2D 遵循通常的二维绘图顺序**。这对于 2D 照明很重要，因为这是控制遮挡器是否应该遮挡精灵本身的方式。

如果 LightOccluder2D 节点是精灵的兄弟节点，则如果精灵位于场景树中的精灵下方，则遮挡器将遮挡精灵本身。

如果 LightOccluder2D 节点是精灵的子节点，则如果在 LightOccluder2D 节点上禁用了“**显示在父对象后面**（Show Behind Parent）”（这是默认设置），则遮挡器将遮挡精灵本身。

##### 法线贴图和镜面反射贴图

法线贴图和镜面反射贴图可以大大增强 2D 照明的深度感。与这些在 3D 渲染中的工作方式类似，法线贴图可以根据接收光的表面的方向（以每个像素为基础）改变其强度，从而有助于使照明看起来不那么平坦。镜面反射贴图通过使一些光线反射回观看者，进一步帮助改善视觉效果。

PointLight2D 和 DirectionalLight2D 都支持法线贴图和镜面反射贴图。自 Godot 4.0 以来，法线贴图和镜面反射贴图可以指定给任何 2D 元素，包括从 Node2D 或 Control 继承的节点。

法线贴图表示每个像素“指向”的方向。然后，引擎使用该信息以物理上合理的方式将照明正确地应用于 2D 表面。法线贴图通常由手绘的高度贴图创建，但也可以由其他纹理自动生成。

镜面反射贴图定义每个像素反射光线的程度（如果镜面反射贴图包含颜色，则定义反射光线的颜色）。更亮的值将导致纹理上给定点的反射更亮。镜面反射贴图通常使用手动编辑创建，使用漫反射纹理作为基础。

> **提示：**
>
> 如果你的精灵没有法线贴图或镜面贴图，你可以使用免费开源的 Laigter 工具生成它们。

若要在 2D 节点上设置法线贴图和/或镜面反射贴图，请为绘制节点纹理的特性创建新的 CanvasTexture 资源。例如，在精灵 2D 上：

展开新创建的资源。您可以找到几个需要调整的属性：

- **漫反射 > 纹理**（Diffuse > Texture）：基础颜色纹理。在该属性中，加载用于精灵本身的纹理。
- **法线贴图 > 纹理**（Normal Map > Texture）：法线贴图纹理。在该属性中，加载从高度贴图生成的法线贴图纹理（请参见上面的提示）。
- **镜面反射 > 纹理**（Specular > Texture）：镜面反射贴图纹理，用于控制漫反射纹理上每个像素的镜面反射强度。镜面反射贴图通常是灰度级的，但它也可以包含相应地乘以反射颜色的颜色。在该属性中，加载已创建的镜面反射贴图纹理（请参见上面的提示）。
- **镜面反射 > 颜色**（Specular > Color）：镜面反射的颜色倍增。
- **镜面反射 > 光泽度**（Specular > Shininess）：用于反射的镜面反射指数。较低的值将增加反射的亮度并使其更加漫反射，而较高的值将使反射更加局部化。高值更适用于看起来潮湿的表面。
- **纹理 > 过滤器**（Texture > Filter）：可以设置为覆盖纹理过滤模式，无论节点的属性设置为什么（或“**渲染 > 纹理 > 画布纹理 > 默认纹理过滤器**”（Rendering > Textures > Canvas Textures > Default Texture Filter）项目设置）。
- **纹理 > 重复**（Texture > Repeat）：无论节点的属性设置为什么（或“**渲染>纹理>画布纹理>默认纹理重复**”（Rendering > Textures > Canvas Textures > Default Texture Repeat）项目设置），都可以设置为覆盖纹理过滤模式。

启用法线贴图后，您可能会注意到灯光似乎较弱。若要解决此问题，请增加 PointLight2D 和 DirectionalLight2D 节点上的“**高度**”属性。您可能还想稍微增加灯光的“**能量**”属性，以便在启用法线贴图之前更接近灯光强度的外观。

##### 使用附加精灵作为 2D 灯光的快速替代方案

如果在使用 2D 灯光时遇到性能问题，则可能值得将其中一些灯光替换为使用添加混合的 Sprite2D 节点。这尤其适用于短时间的动态效果，如子弹或爆炸。

相加精灵的渲染速度要快得多，因为它们不需要经过单独的渲染管道。此外，可以将此方法与 AnimatedSprite2D（或 Sprite2D + AnimationPlayer）一起使用，这允许创建动画 2D “灯光”。

然而，与 2D 灯光相比，添加精灵有一些缺点：

- 与“实际”2D照明相比，混合公式不准确。在光线充足的区域，这通常不是问题，但这会阻止添加精灵正确地照亮完全黑暗的区域。
- 相加精灵不能投射阴影，因为它们不是灯光。
- 相加精灵会忽略其他精灵上使用的法线贴图和镜面反射贴图。

要显示具有添加调和（additive blending）的精灵，请创建一个 Sprite2D 节点并为其指定纹理。在检查器中，向下滚动到 **CanvasItem > Material** 部分，展开它，然后单击 **Material** 属性旁边的下拉列表。选择“**新建 CanvasItemMaterial**”，单击新创建的材质进行编辑，然后将“**调和模式**”（Blend Mode）设置为“**添加**”（Add）。

#### 2D 网格

##### 简介

在三维中，网格用于显示世界。在 2D 中，它们是罕见的，因为图像被更频繁地使用。Godot 的 2D 引擎是一个纯二维引擎，因此它不能真正直接显示 3D 网格（尽管它可以通过 `Viewport` 和 `ViewportTexture` 完成）。

> **参考：**
>
> 如果您对在二维视口上显示三维网格感兴趣，请参见使用视口作为纹理教程。

二维网格是包含二维几何体（可以省略或忽略 Z）而不是三维几何体的网格。您可以尝试使用代码中的 `SurfaceTool` 自己创建它们，并在 `MeshInstance2D` 节点中显示它们。

目前，在编辑器中生成二维网格的唯一方法是将 OBJ 文件作为网格导入，或将其从 Sprite2D 转换。

##### 优化绘制的像素

在某些情况下，此工作流对于优化二维图形非常有用。当绘制具有透明度的大图像时，Godot 会将整个四边形绘制到屏幕上。仍将绘制大的透明区域。

这可能会影响性能，尤其是在移动设备上，当绘制非常大的图像（通常为屏幕大小）或用大的透明区域将多个图像叠加在一起时（例如，当使用视差背景时）。

转换为网格将确保只绘制不透明部分，而忽略其余部分。

##### 将 Sprite2D 转为 2D 网格

可以通过将 Sprite2D 转换为 MeshInstance2D 来利用此优化。从边缘包含大量透明度的图像开始，如以下树：

将其放入 `Sprite2D` 中，然后从菜单中选择“转化为 2D 网格”：

将出现一个对话框，显示如何创建二维网格的预览：

默认值在许多情况下都足够好，但您可以根据需要更改增长（growth）和简化（simplification）：

最后，按下 `Convert 2D Mesh` 按钮，您的 Sprite2D 将被替换：

#### 2D 精灵动画

##### 简介

在本教程中，您将学习如何使用 AnimatedSprite2D 类和 AnimationPlayer 创建 2D 动画角色。通常，当创建或下载动画角色时，它将以两种方式之一出现：作为单独的图像或作为包含所有动画帧的单个精灵表。两者都可以通过 AnimatedSprite2D 类在 Godot 中设置动画。

首先，我们将使用 AnimatedSprite2D 为单个图像的集合设置动画。然后我们将使用这个类为精灵表设置动画。最后，我们将学习另一种使用 AnimationPlayer 和 Sprite2D 的 Animation 属性制作精灵表动画的方法。

> **注意：**
>
> 以下示例的艺术来自 https://opengameart.org/users/ansimuz 和 tgfcoder。

##### 使用 AnimatedSprite2D 的单个图像

在此场景中，您有一组图像，每个图像都包含角色的一个动画帧。对于本例，我们将使用以下动画：

您可以在此处下载图像：2d_sprite_animation_assets.zip

解压缩图像并将其放在项目文件夹中。使用以下节点设置场景树：

> **注意：**
>
> 根节点也可以是 Area2D 或 RigidBody2D。动画仍将以相同的方式制作。动画完成后，可以将形状指定给 CollisionShape2D。更多信息请参见物理学导论。

现在选择 `AnimatedSprite2D`，并在其 *SpriteFrames* 属性中选择“新建精灵框架”。

单击新的 SpriteFrames 资源，您将看到一个新面板出现在编辑器窗口的底部：

从左侧的 FileSystem 停靠中，将 8 个单独的图像拖动到“精灵框架”面板的中心部分。在左侧，将动画的名称从“默认”更改为“运行”。

使用“*过滤动画*”输入右上角的“播放”按钮预览动画。现在，您应该可以看到在视口中播放的动画。然而，它有点慢。若要解决此问题，请将“精灵帧”面板中的“*速度（FPS）*”设置更改为10。

您可以通过单击“添加动画”按钮并添加其他图像来添加其他动画。

###### 控制动画

动画完成后，可以使用 `play()` 和 `stop()` 方法通过代码控制动画。以下是一个简单的示例，用于在按住向右箭头键的同时播放动画，并在释放该键时停止动画。

```python
extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
    if Input.is_action_pressed("ui_right"):
        _animated_sprite.play("run")
    else:
        _animated_sprite.stop()
```

##### 带有 AnimatedSprite2D 的精灵表

您还可以使用类 `AnimatedSprite2D` 从精灵表中轻松设置动画。我们将使用这个公共域精灵表：

右键单击图像并选择“将图像另存为”进行下载，然后将图像复制到项目文件夹中。

以与以前使用单个图像时相同的方式设置场景树。选择 `AnimatedSprite2D`，并在其“精灵框架”属性中选择“新建精灵框架”。

单击新的“精灵框架”资源。这一次，当底部面板出现时，选择“从精灵表添加帧”。

系统将提示您打开一个文件。选择您的精灵表。

将打开一个新窗口，显示您的精灵表。您需要做的第一件事是更改精灵表中垂直和水平图像的数量。在这个精灵表中，我们有四个水平的图像和两个垂直的图像。

接下来，从精灵表中选择要包含在动画中的帧。我们将选择前四个，然后单击“添加 4 帧”来创建动画。

现在，您将在底部面板中的动画列表下看到您的动画。在默认情况下双击可更改要跳转的动画的名称。

最后，检查 SpriteFrames 编辑器上的播放按钮，查看您的青蛙跳跃！

##### 带有 AnimationPlayer 的精灵表

使用精灵表时可以设置动画的另一种方法是使用标准的 Sprite2D 节点来显示纹理，然后使用 AnimationPlayer 设置从纹理到纹理的更改的动画。

考虑一下这个精灵表，它包含 6 帧动画：

右键单击图像并选择“将图像另存为”进行下载，然后将图像复制到项目文件夹中。

我们的目标是在一个循环中一个接一个地显示这些图像。首先设置场景树：

> **注意：**
>
> 根节点也可以是 Area2D 或 RigidBody2D。动画仍将以相同的方式制作。动画完成后，可以将形状指定给 CollisionShape2D。更多信息请参见物理学导论。

将精灵表拖动到精灵的*纹理*属性中，您将看到整个工作表显示在屏幕上。若要将其分割为各个帧，请展开“检查器”中的“动画”部分，并将 *Hframes* 设置为 `6`。*Hframes* 和 *Vframes* 是精灵工作表中水平和垂直帧的数量。

现在尝试更改 *Frame* 属性的值。您将看到它的范围从 `0` 到 `5`，Sprite2D 显示的图像也会相应地更改。这是我们将要设置动画的属性。

选择 `AnimationPlayer` 并单击“动画”按钮，然后单击“新建”。将新动画命名为“行走”。将动画长度设置为 `0.6`，然后单击“循环”按钮，这样我们的动画就会重复。

现在选择 `Sprite2D` 节点，然后单击关键点图标以添加新轨迹。

继续在时间线上的每个点添加帧（默认情况下为 `0.1` 秒），直到您拥有从 0 到 5 的所有帧。您将看到实际出现在动画轨迹中的帧：

在动画上按“播放”以查看其外观。

###### 控制 AnimationPlayer 动画

与 AnimatedSprite2D 一样，您可以使用 `play()` 和 `stop()` 方法通过代码控制动画。同样，这里是一个在按住右箭头键时播放动画的示例，并在释放该键时停止动画。

```python
extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer

func _process(_delta):
    if Input.is_action_pressed("ui_right"):
        _animation_player.play("walk")
    else:
        _animation_player.stop()
```

> **注意：**
>
> 如果同时更新动画和单独的属性（例如，当角色在开始“翻转”动画时翻转时，平台生成器可能会更新精灵的 `h_flip`/ `v_flip` 属性），请记住 `play()` 不会立即应用。相反，它将在下次处理 AnimationPlayer 时应用。这可能最终出现在下一帧上，导致出现“小故障”帧，其中应用了属性更改，但没有应用动画。如果这是一个问题，在调用 `play()` 之后，可以调用 `advance(0)` 立即更新动画。

##### 总结

这些示例说明了可以在 Godot 中用于 2D 动画的两个类。`AnimationPlayer` 比 `AnimatedSprite2D` 稍微复杂一些，但它提供了额外的功能，因为您还可以设置其他属性（如位置或比例）的动画。类 `AnimationPlayer` 也可以与 `AnimatedSprite2D` 一起使用。试着看看什么最适合你的需求。

#### 2D 粒子系统

##### 导论

粒子系统用于模拟复杂的物理效果，如火花、火焰、魔法粒子、烟雾、薄雾等。

其想法是“粒子”以固定的间隔和固定的寿命发射。在其生命周期内，每个粒子都将具有相同的基本行为。使每个粒子与其他粒子不同并提供更有机外观的是与每个参数相关的“随机性”。本质上，创建粒子系统意味着设置基本物理参数，然后添加随机性。

##### 粒子节点

Godot 为 2D 粒子提供了两个不同的节点，GPUParticles2D 和 CPUarticles2D。GPUParticles2D 更先进，使用 GPU 处理粒子效果。CPUParticles2D 是一个 CPU 驱动的选项，与 GPUParticles2D 功能接近，但在使用大量粒子时性能较低。另一方面，CPUArticles2D 可能在低端系统或 GPU 瓶颈情况下表现更好。

虽然 GPUParticles2D 是通过 ParticleProcessMaterial（以及可选的自定义着色器）配置的，但匹配选项是通过 CPUarticles2D 中的节点属性提供的（轨迹设置除外）。

通过单击检查器中的节点，然后在三维编辑器视口顶部的工具栏中选择“**粒子 > 转化为CPUarticles2D**”，可以将 GPUParticles2D 节点转化为 CPUArticles2D 节点。

本教程的其余部分将使用 GPUParticles2D 节点。首先，将 GPUParticles2D 节点添加到场景中。创建该节点后，您会注意到只创建了一个白点，并且在场景停靠中的 GPUParticles2D 节点旁边有一个警告图标。这是因为节点需要 ParticleProcessMaterial 才能发挥作用。

###### ParticleProcessMaterial

若要将处理材质添加到粒子节点，请转到检查器面板中的 `Process Material`。单击 `Material` 旁边的框，然后从下拉菜单中选择 `New ParticleProcessMaterial`。

您的 GPUParticles2D 节点现在应该向下发射白点。

###### 纹理

粒子系统使用单个纹理（将来可能会通过 spritesheet 将其扩展到动画纹理）。纹理是通过相关纹理属性设置的：

##### 时间参数

###### 寿命（Lifetime）

每个粒子保持活动的时间（以秒为单位）。寿命结束时，将创建一个新粒子来替换它。

Lifetime: 0.5

Lifetime: 4.0

###### 一次性（One Shot）

启用后，GPUParticles2D 节点将发射其所有粒子一次，然后再也不会发射。

###### 预处理（Preprocess）

粒子系统从零粒子发射开始，然后开始发射。这可能会给加载场景带来不便，并且火炬、薄雾等系统在您进入时就开始发射。预处理用于让系统在第一次实际绘制之前处理给定的秒数。

###### 速度比例（Speed Scale）

速度比例的默认值为 `1`，用于调整粒子系统的速度。降低该值会使粒子速度变慢，而增加该值会让粒子速度更快。

###### 爆炸性（Explosiveness）

如果寿命为 `1`，并且有 10 个粒子，则意味着每 0.1 秒就会发射一个粒子。爆炸性参数会改变这一点，并强制粒子一起发射。范围为：

- 0：以规则的间隔发射粒子（默认值）。
- 1：同时发射所有粒子。

也允许中间的值。此功能对于创建粒子的爆炸或突然爆发非常有用：

###### 随机性（Randomness）

所有物理参数都可以随机化。随机值的范围从 `0` 到 `1`。随机化参数的公式为：

```python
initial_value = param_value + param_value * randomness
```

###### 固定 FPS（Fixed FPS）

此设置可用于将粒子系统设置为以固定 FPS 进行渲染。例如，将该值更改为 `2` 将使粒子以每秒 2 帧的速度渲染。请注意，这不会减慢粒子系统本身的速度。

###### Fract Delta

这可用于打开或关闭 Fract Delta。

##### 绘制参数

###### 可见性矩形（Visibility Rect）

可见性矩形控制粒子在屏幕上的可见性。如果此矩形在视口之外，则引擎不会在屏幕上渲染粒子。

矩形的 `W` 和 `H` 属性分别控制其“宽度”和“高度”。`X` 和 `Y` 特性控制矩形左上角相对于粒子发射器的位置。

您可以让 Godot 使用二维视图上方的工具栏自动生成可见性矩形。要执行此操作，请选择 GPUParticles2D 节点，然后单击 `Particles > Generate Visibility Rect`。Godot 将模拟发射粒子的 Particles2D 节点几秒钟，并将矩形设置为适合粒子所采用的曲面。
可以使用 `Generation Time (sec)` 选项控制发射持续时间。最大值为 25 秒。如果粒子需要更多时间移动，可以临时更改 Particles2D 节点上的 `preprocess` 持续时间。

###### 本地坐标

默认情况下，此选项处于启用状态，这意味着粒子发射到的空间相对于节点。如果节点被移动，则所有粒子都将随之移动：

如果禁用，粒子将发射到全局空间，这意味着如果移动节点，则已发射的粒子不会受到影响：

###### 绘制顺序

这控制了绘制单个粒子的顺序。`Index` 表示粒子是根据其发射顺序绘制的（默认）。`Lifetime` 意味着它们是按照剩余寿命的顺序绘制的。

##### ParticleProcessMaterial 设置

###### 方向

这是粒子发射的基本方向。默认值为 `Vector3(1, 0, 0)`，它使粒子向右发射。但是，使用默认重力设置，粒子将直接向下移动。

若要使此特性引人注目，您需要一个大于 0 的初始速度。这里，我们将初始速度设置为 40。你会注意到粒子向右发射，然后由于重力而下降。

###### 分布

此参数是将在任一方向上随机添加到基准 `Direction` 的角度（以度为单位）。`180` 的排列将向所有方向发射（+/-180）。要使排列执行任何操作，“初始速度”参数必须大于 0。

###### 平面度（Flatness）

该属性只对 3D 粒子有用。

###### 重力

重力对每个粒子有效。

###### 初始速度

初始速度是粒子将被发射的速度（单位为像素每秒）。速度稍后可能会通过重力或其他加速度进行修改（如下文所述）。

###### 角速度

角速度是应用于粒子的初始角速度。

###### 旋转速度

自旋速度是粒子围绕其中心旋转的速度（以度/秒为单位）。

###### 轨道速度

轨道速度用于使粒子围绕其中心旋转。

###### 线性加速度

应用于每个粒子的线性加速度。

###### 径向加速度

如果这个加速度是正的，粒子会被加速离开中心。如果是负面的，他们就会被吸收。

###### 切向加速度

该加速度将使用与中心相切的向量。与径向加速度相结合可以产生很好的效果。

###### 阻尼

阻尼对粒子施加摩擦力，迫使它们停止。它对火花或爆炸特别有用，这些火花或爆炸通常以高线速度开始，然后在消退时停止。

###### 角

确定粒子的初始角度（以度为单位）。此参数在随机化时非常有用。

###### 比例（Scale）

确定粒子的初始比例。

###### 颜色

用于更改正在发射的粒子的颜色。

###### 色调变化

`Variation` 值设置应用于每个粒子的初始色调变化。`Variation Random` 值控制色调变化随机性比率。

##### 发射形状

ParticleProcessMaterials 允许您设置发射遮罩，该遮罩指定粒子发射的区域和方向。这些可以从项目中的纹理生成。

确保设置了 ParticleProcessMaterial，并选择了 GPUParticles2D 节点。工具栏中应显示“粒子”菜单：

打开它并选择“加载发射遮罩”（Load Emission Mask）:

然后选择要用作遮罩的纹理：

将出现一个包含多个设置的对话框。

###### 发射遮罩

可以从纹理生成三种类型的发射遮罩：

- 实心像素：粒子将从纹理的任何区域生成，不包括透明区域。
- 边界像素：粒子将从纹理的外部边缘生成。
- 定向边界像素：类似于边界像素，但向遮罩添加额外信息，使粒子能够远离边界发射。请注意，需要设置 `Initial Velocity` 才能利用此功能。

###### 发射颜色

`Capture from Pixel` 将使粒子在其生成点继承遮罩的颜色。

单击“确定”后，将生成遮罩，并将其设置为 `Emission Shape` 部分下的ParticleProcessMaterial：

此部分中的所有值都是由“加载发射遮罩”菜单自动生成的，因此通常应将它们单独保留。

> **注意：**
>
> 图像不应直接添加到 `Point Texture` 或 `Color Texture`。应始终使用“加载发射遮罩”菜单。

#### 2D 抗锯齿

> **参考：**
>
> Godot 还支持 3D 渲染中的抗锯齿。3D 抗锯齿页面对此进行了介绍。

##### 简介

由于分辨率有限，在 2D 中渲染的场景可能会出现混叠伪影。这些瑕疵通常以几何体边上的“楼梯”效果的形式表现出来，并且在使用 Line2D、Polygon2D 或 TextureProgressBar 等节点时最为明显。对于不支持抗锯齿的方法，二维中的自定义图形也可能具有锯齿瑕疵。

在下面的示例中，您可以注意到边是如何具有块状外观的：

为了解决这个问题，Godot 支持几种在 2D 渲染中启用抗锯齿的方法。

##### Line2D 和自定义图形中的抗锯齿特性

这是推荐的方法，因为在大多数情况下，它对性能的影响较小。

Line2D 具有**抗锯齿**特性，您可以在检查器中启用该特性。此外，二维自定义绘图的几种方法支持可选的 `antialiased` 参数，在调用函数时可以将该参数设置为 `true`。

这些方法不需要启用 MSAA，这使得它们的基线性能成本较低。换言之，如果在某个点上没有绘制任何抗锯齿几何体，就不会产生永久的附加成本。

这些抗锯齿方法的缺点是它们通过生成额外的几何体来工作。如果生成的是每帧更新一次的复杂二维几何体，这可能是一个瓶颈。此外，Polygon2D、TextureProgressBar 和几种自定义绘图方法都没有抗锯齿特性。对于这些节点，可以改为使用二维多采样抗锯齿。

##### 多样本抗锯齿（MSAA）

在 2D 中启用 MSAA 之前，了解 MSAA 将在什么上运行是很重要的。2D 中的 MSAA 遵循与 3D 中类似的限制。虽然它没有引入任何模糊性，但其应用范围是有限的。2D MSAA 的主要应用包括：

- 几何图形边，如直线和多边形绘制。
- *仅为接触纹理边缘的像素*的精灵边缘。这适用于线性和最近邻滤波。在图像上使用透明度创建的精灵边不受 MSAA 的影响。

MSAA 的缺点是它只在边缘操作。这是因为 MSAA 增加了*覆盖*样本的数量，但没有增加颜色样本的数量。但是，由于*颜色*采样的数量没有增加，因此片段着色器仍然只为每个像素运行一次。因此，MSAA 不会以任何方式**影响**以下类型锯齿：

- 最近邻过滤纹理*中*的锯齿（像素艺术）。
- 自定义 2D 着色器导致的锯齿。
- 使用 Light2D 时的镜面反射锯齿。
- 字体渲染中的别名。

通过更改“**渲染 > 抗锯齿 > 质量 > MSAA 2D**”（Rendering > Anti Aliasing > Quality > MSAA 2D）设置的值，可以在“项目设置”中启用 MSAA。更改 **MSAA 2D** 设置而不是 **MSAA 3D** 的值很重要，因为这是完全独立的设置。

无抗锯齿（左）和各种 MSAA 级别（右）之间的比较。左上角包含一个 Line2D 节点，右上角包含 2 个 TextureProgressBar 节点。底部包含 8 个像素的艺术精灵，其中 4 个触摸边缘（绿色背景），4 个不触摸边缘（Godot 徽标）：

#### 2D 中的自定义绘制

##### 简介

Godot 有节点来绘制精灵、多边形、粒子和各种各样的东西。在大多数情况下，这就足够了。如果没有节点可以绘制您需要的特定内容，则可以使任何二维节点（例如，基于 Control 或 Node2D）绘制自定义命令。

二维节点中的自定义图形非常有用。以下是一些用例：

- 绘制现有节点无法执行的形状或逻辑，例如带有轨迹的图像或特殊动画多边形。
- 与节点不太兼容的可视化，例如俄罗斯方块。（俄罗斯方块示例使用自定义绘制函数来绘制方块。）
- 绘制大量简单的对象。自定义绘图避免了使用大量节点的开销，可能会降低内存使用率并提高性能。
- 制作自定义UI控件。有很多控件可用，但当您有不寻常的需求时，您可能需要一个自定义控件。

##### 绘制

将脚本添加到任何 CanvasItem 派生的节点，如 Control 或 Node2D。然后覆盖 `_draw()` 函数。

```python
extends Node2D

func _draw():
    # Your draw commands here
    pass
```

绘图命令在 CanvasItem 类参考中进行了描述。他们有很多。

##### 更新

`_draw()` 函数只调用一次，然后缓存并记住 draw 命令，因此不需要进一步调用。

如果由于状态或其他事情发生了更改而需要重新绘制，请在同一节点中调用 CanvasItem.queue_redraw()，然后将进行新的 `_draw()` 调用。

这里有一个稍微复杂一点的例子，一个纹理变量，如果修改就会被重新绘制：

```python
extends Node2D

export (Texture) var texture setget _set_texture

func _set_texture(value):
    # If the texture variable is modified externally,
    # this callback is called.
    texture = value  # Texture was changed.
    queue_redraw()  # Trigger a redraw of the node.

func _draw():
    draw_texture(texture, Vector2())
```

在某些情况下，可能需要绘制每个帧。为此，请从 `_process()` 回调调用 `queue_redraw()`，如下所示：

```python
extends Node2D

func _draw():
    # Your draw commands here
    pass

func _process(delta):
    queue_redraw()
```

##### 坐标

图形 API 使用 CanvasItem 的坐标系，而不一定使用像素坐标。这意味着它使用在应用 CanvasItem 的变换后创建的坐标空间。此外，您可以使用 draw_set_transform 或 draw_set_transform_matrix 在其上应用自定义变换。

使用 `draw_line` 时，应考虑线条的宽度。当使用奇数尺寸的宽度时，位置应偏移 `0.5`，以保持线居中，如下所示。

```python
func _draw():
    draw_line(Vector2(1.5, 1.0), Vector2(1.5, 4.0), Color.GREEN, 1.0)
    draw_line(Vector2(4.0, 1.0), Vector2(4.0, 4.0), Color.GREEN, 2.0)
    draw_line(Vector2(7.5, 1.0), Vector2(7.5, 4.0), Color.GREEN, 3.0)
```

这同样适用于 `filled=false` 的 `draw_rect`方法。

```python
func _draw():
    draw_rect(Rect2(1.0, 1.0, 3.0, 3.0), Color.GREEN)
    draw_rect(Rect2(5.5, 1.5, 2.0, 2.0), Color.GREEN, false, 1.0)
    draw_rect(Rect2(9.0, 1.0, 5.0, 5.0), Color.GREEN)
    draw_rect(Rect2(16.0, 2.0, 3.0, 3.0), Color.GREEN, false, 2.0)
```

##### 示例：绘制圆弧

我们现在将使用 Godot 引擎的自定义绘图功能来绘制 Godot 没有提供功能的东西。例如，Godot 提供了一个 `draw_circle()` 函数，用于绘制整个圆。但是，画一个圆的一部分怎么样？您必须编写一个函数来执行此操作，并自己绘制。

###### 弧函数

圆弧由其支撑圆参数定义，即中心位置和半径。然后，弧本身由它开始的角度和停止的角度来定义。以下是我们必须为绘图函数提供的 4 个参数。我们还将提供颜色值，因此如果我们愿意，我们可以用不同的颜色绘制圆弧。

基本上，在屏幕上绘制形状需要将其分解为一定数量的点，这些点从一个点链接到下一个点。正如你所能想象的，你的形状由越多的点组成，看起来就越光滑，但就处理成本而言，它也会越重。一般来说，如果你的形状很大（或者在 3D 中，靠近相机），它将需要绘制更多的点，而不会看起来有角度。相反，如果你的形状很小（或者在 3D 中，远离相机），你可以减少它的点数以节省处理成本；这被称为*细节级别（LOD）*。在我们的示例中，我们将简单地使用固定数量的点，无论半径如何。

```python
func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PackedVector2Array()

    for i in range(nb_points + 1):
        var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color)
```

还记得我们的形状必须分解成的点的数量吗？我们将 `nb_points` 变量中的这个数字固定为 `32`。然后，我们初始化一个空的 `PackedVector2Array`，它只是 `Vector2`s 的数组。

下一步包括计算组成圆弧的这 32 个点的实际位置。这在第一个 for 循环中完成：我们迭代要计算位置的点的数量，加上一个以包括最后一个点。我们首先确定每个点的角度，介于起始角度和结束角度之间。

每个角度减少 90° 的原因是我们将使用三角法计算每个角度的2D位置（你知道，余弦和正弦的东西…）。然而，`cos()` 和 `sin()` 使用的是弧度，而不是度。0°（0 弧度）的角度从 3 点钟开始，尽管我们想从 12 点钟开始计数。因此，我们将每个角度减小 90°，以便从 12 点钟开始计数。

以角度 `angle`（弧度）位于圆上的点的实际位置由 `Vector2(cos(angle), sin(angle))` 给出。由于 `cos()` 和 `sin()` 返回的值介于 -1 和 1 之间，因此位置位于半径为 1 的圆上。要在我们的支撑圆上有这个位置，它的半径为 `radius`，我们只需要将位置乘以 `radius`。最后，我们需要将支撑圆定位在 `center` 位置，这是通过将其添加到 `Vector2` 值来执行的。最后，我们在先前定义的 `PackedVector2Array` 中插入该点。

现在，我们需要实际得出我们的观点。正如你所能想象的，我们不会简单地画出我们的 32 分：我们需要画出它们之间的一切。我们本可以用以前的方法自己计算每一点，并一个接一个地画出来。但这太复杂且效率低下（除非明确需要），所以我们只需在每对点之间划一条线。除非我们的支撑圆的半径很大，否则一对点之间的每条线的长度永远不足以看到它们。如果发生这种情况，我们只需要增加点数。

###### 在屏幕上绘制圆弧

我们现在有了一个在屏幕上绘制内容的功能；是时候在 `_draw()` 函数内部调用它了：

```python
func _draw():
    var center = Vector2(200, 200)
    var radius = 80
    var angle_from = 75
    var angle_to = 195
    var color = Color(1.0, 0.0, 0.0)
    draw_circle_arc(center, radius, angle_from, angle_to, color)
```

结果：

###### 圆弧多边形函数

我们可以更进一步，不仅可以编写一个函数来绘制由圆弧定义的圆盘的平面部分，还可以绘制其形状。该方法与以前完全相同，只是我们绘制了一个多边形而不是直线：

```python
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PackedVector2Array()
    points_arc.push_back(center)
    var colors = PackedColorArray([color])

    for i in range(nb_points + 1):
        var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    draw_polygon(points_arc, colors)
```

###### 动态自定义图形

好了，我们现在可以在屏幕上绘制自定义的东西了。然而，它是静态的；让我们把这个形状绕中心转。这样做的解决方案只是随着时间的推移更改 angle_from 和 angle_to 值。对于我们的例子，我们将简单地将它们增加 50。该增量值必须保持恒定，否则转速将相应变化。

首先，我们必须在脚本的顶部使 angle_from 和 angle_to 变量都是全局变量。还要注意，您可以将它们存储在其他节点中，并使用 `get_node()` 访问它们。

```python
extends Node2D

var rotation_angle = 50
var angle_from = 75
var angle_to = 195
```

我们在 _process(delta) 函数中更改这些值。

我们还在这里增加我们的 angle_from 和 angle_to 值。但是，我们决不能忘记将结果值 `wrap()` 在 0 和 360° 之间！也就是说，如果角度是 361°，那么它实际上是 1°。如果不包装这些值，脚本将正常工作，但角度值会随着时间的推移越来越大，直到达到 Godot 可以管理的最大整数值（`2^31-1`）。当这种情况发生时，Godot 可能会崩溃或产生意外行为。

最后，我们一定不要忘记调用 `queue_redraw()` 函数，它会自动调用 `_draw()`。通过这种方式，您可以控制何时刷新帧。

```python
func _process(delta):
    angle_from += rotation_angle
    angle_to += rotation_angle

    # We only wrap angles when both of them are bigger than 360.
    if angle_from > 360 and angle_to > 360:
        angle_from = wrapf(angle_from, 0, 360)
        angle_to = wrapf(angle_to, 0, 360)
    queue_redraw()
```

此外，不要忘记修改 `_draw()` 函数以利用这些变量：

```python
func _draw():
   var center = Vector2(200, 200)
   var radius = 80
   var color = Color(1.0, 0.0, 0.0)

   draw_circle_arc( center, radius, angle_from, angle_to, color )
```

我们跑吧！它起作用了，但弧线旋转得太快了！怎么了？

原因是你的 GPU 实际上正在以最快的速度显示帧。我们需要以这种速度“规范化”绘图；为了实现这一点，我们必须使用 `_process()` 函数的 `delta` 参数。`delta` 包含最后两个渲染帧之间经过的时间。它通常很小（约 0.0003 秒，但这取决于您的硬件），因此使用 `delta` 控制绘图可以确保程序在每个硬件上以相同的速度运行。

在我们的例子中，我们只需要在 `_process()` 函数中将 `rotation_angle` 变量乘以 `delta`。这样，我们的 2 个角度将增加一个小得多的值，这直接取决于渲染速度。

```python
func _process(delta):
    angle_from += rotation_angle * delta
    angle_to += rotation_angle * delta

    # We only wrap angles when both of them are bigger than 360.
    if angle_from > 360 and angle_to > 360:
        angle_from = wrapf(angle_from, 0, 360)
        angle_to = wrapf(angle_to, 0, 360)
    queue_redraw()
```

让我们再跑一次！这一次，旋转显示良好！

###### 抗锯齿绘制

Godot 在 draw_line 中提供方法参数以启用抗锯齿，但并非所有自定义绘图方法都提供此 `antialiased` 参数。

对于不提供 `antialiased` 参数的自定义绘图方法，可以启用 2D MSAA，这会影响整个视口中的渲染。这提供了高质量的抗锯齿，但性能成本更高，而且仅针对特定元素。有关详细信息，请参见 2D 抗锯齿。

##### 工具

在编辑器中运行节点时，可能还需要绘制自己的节点。这可以用作某些功能或行为的预览或可视化。有关详细信息，请参见在编辑器中运行代码。

### 物理和运动

#### 2D 运动总览

##### 简介

每个初学者都有过这样的经历：“我该如何移动我的角色？”根据你制作的游戏风格，你可能有特殊要求，但一般来说，大多数 2D 游戏中的移动都是基于少量设计的。

我们将在这些示例中使用 CharacterBody2D，但这些原则也适用于其他节点类型（Area2D、RigidBody2D）。

##### 设置

下面的每个示例都使用相同的场景设置。从具有两个子对象的 `CharacterBody2D` 开始：`Sprite2D` 和 `CollisionShape2D`。您可以将 Godot 图标（“icon.png”）用于 Sprite2D 的纹理，也可以使用任何其他 2D 图像。

打开 `Project -> Project Settings`（项目 -> 项目设置），选择“输入映射”选项卡。添加以下输入操作（有关详细信息，请参阅 InputEvent）：

##### 8 向运动

在这种情况下，您希望用户按下四个方向键（上/左/下/右或 W/A/S/D）并沿选定方向移动。“8 向移动”这个名字来源于玩家可以同时按下两个键进行对角移动。

将脚本添加到角色主体并添加以下代码：

```python
extends CharacterBody2D

@export var speed = 400

func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    velocity = input_direction * speed

func _physics_process(delta):
    get_input()
    move_and_slide()
```

在 `get_input()` 函数中，我们使用 Input `get_vector()` 来检查四个关键事件，并求和返回一个方向向量。

然后，我们可以通过将这个长度为 `1` 的方向向量乘以我们想要的速度来设置速度。

> **提示：**
>
> 如果你以前从未使用过向量数学，或者需要复习，你可以在向量数学的 Godot 中看到向量用法的解释。

> **注意：**
>
> 如果按键时上面的代码没有任何作用，请按照本教程的“设置”部分所述，仔细检查是否正确设置了输入操作。

##### 旋转 + 运动

这种类型的动作有时被称为“小行星风格”，因为它类似于那个经典街机游戏的运作方式。按左/右键可旋转角色，而向上/向下键可使角色朝着任何方向向前或向后移动。

```python
extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5

var rotation_direction = 0

func get_input():
    rotation_direction = Input.get_axis("left", "right")
    velocity = transform.x * Input.get_axis("down", "up") * speed

func _physics_process(delta):
    get_input()
    rotation += rotation_direction * rotation_speed * delta
    move_and_slide()
```

在这里，我们添加了两个变量来跟踪我们的旋转方向和速度。旋转将直接应用于实体的 `rotation` 特性。

为了设置速度，我们使用身体的 `transform.x`，这是一个指向身体“向前”方向的向量，并将其乘以速度。

##### 旋转 + 运动（鼠标）

这种运动方式是前一种的变体。这一次，方向是由鼠标位置而不是键盘设置的。角色将始终“看着”鼠标指针。然而，前向/后向输入保持不变。

```python
extends CharacterBody2D

@export var speed = 400

func get_input():
    look_at(get_global_mouse_position())
    velocity = transform.x * Input.get_axis("down", "up") * speed

func _physics_process(delta):
    get_input()
    move_and_slide()
```

在这里，我们使用 Node2D `look_at()` 方法将玩家指向鼠标的位置。如果没有此功能，您可以通过如下设置角度来获得相同的效果：

```python
rotation = get_global_mouse_position().angle_to_point(position)
```

##### 点击并移动

最后一个示例仅使用鼠标来控制角色。点击屏幕将使玩家移动到目标位置。

```python
extends CharacterBody2D

@export var speed = 400

var target = position

func _input(event):
    if event.is_action_pressed("click"):
        target = get_global_mouse_position()

func _physics_process(delta):
    velocity = position.direction_to(target) * speed
    # look_at(target)
    if position.distance_to(target) > 10:
        move_and_slide()
```

请注意我们在移动之前进行的 `distance _to()` 检查。如果没有这个测试，身体在到达目标位置时会“抖动”，因为它稍微移动过这个位置并试图向后移动，但移动得太远并重复。

如果您愿意，取消对 `look_at()` 线的注释也会使身体指向其运动方向。

> **提示：**
>
> 这种技术也可以作为“跟随”字符的基础。`target` 位置可以是要移动到的任何对象的位置。

##### 总结

您可能会发现这些代码示例非常有用，可以作为您自己项目的起点。随意使用它们，并对它们进行实验，看看你能做什么。

您可以在此处下载此示例项目：2d_movement_starter.zip

### 工具

#### 使用 TileSets

##### 简介

瓷砖贴图是用于创建游戏布局的瓷砖网格。使用 TileMap 节点设计关卡有几个好处。首先，它们允许您通过在网格上“绘制”瓷砖来绘制布局，这比逐个放置单个 Sprite2D 节点要快得多。其次，它们允许更大的级别，因为它们是为绘制大量瓷砖而优化的。最后，它们允许您通过碰撞、遮挡和导航形状为平铺添加更大的功能。

要使用瓷砖贴图，您需要首先创建一个 TileSet。TileSet 是可以放置在 TileMap 节点中的瓦片的集合。创建 TileSet 后，您将能够使用 TileMap 编辑器放置它们。

要遵循本指南，您需要一个包含平铺的图像，其中每个平铺都具有相同的大小（大型对象可以拆分为多个平铺）。此图像被称为 *tilesheet*。瓷砖不一定是正方形的：它们可以是矩形、六边形或等角（伪三维透视）。

##### 创建一个新的 TileSet

###### 使用 tilesheet

本演示将使用以下取自 [Kenney's "Abstract Platformer" pack](https://kenney.nl/assets/abstract-platformer) 的瓦片。我们将使用该集合中的此特定 *tilesheet*：

创建一个新的 **TileMap** 节点，然后选择它并在检查器中创建一个新建 TileSet 资源：

创建 TileSet 资源后，单击该值以在检查器中展开它。默认的平铺形状为“方形”，但也可以选择“等轴测”、“半偏移方形”或“六边形”（取决于平铺图像的形状）。如果使用正方形以外的平铺形状，则可能还需要调整“**平铺布局**”（Tile Layout）和“**平铺偏移轴**”（Tile Offset Axis）属性。最后，如果希望按瓷砖坐标剪裁瓷砖，则启用“**渲染 > UV剪裁**”（Rendering > UV Clipping）特性可能会很有用。这样可以确保分幅不能绘制在分幅表上分配的区域之外。

在检查器中将平铺大小设置为 64 × 64，以匹配示例平铺表：

如果依赖于自动平铺创建（就像我们在这里要做的那样），则必须在创建图集**之前**设置平铺大小。图集将确定瓦片表中的哪些瓦片可以添加到瓦片映射节点（因为并非图像的每个部分都是有效的瓦片）。

打开编辑器底部的 **TileSet** 面板，然后单击左下角的“+”图标添加新图集：

创建图集后，必须为其指定一个 tilesheet 纹理。这可以通过在底部面板的左列上选择它，然后单击“**纹理**”属性的值并选择“**快速加载**”（或“**加载**”）来完成。使用出现的文件对话框指定图像文件的路径。

指定有效图像后，系统将询问您是否自动创建平铺。回答**是**：

这将根据您之前在 TileSet 资源中指定的平铺大小自动创建平铺。这大大加快了初始平铺设置的速度。

> **注意：**
>
> 使用基于图像内容的自动分幅生成时，分幅表中完全透明的部分将不会生成分幅。

如果瓷砖表中有您不希望出现在图集中的瓷砖，请选择瓷砖集预览顶部的“橡皮擦”工具，然后单击要删除的瓷砖：

也可以右键单击磁贴并选择“删除”，作为橡皮擦工具的替代工具。

> **提示：**
>
> 与 2D 和 TileMap 编辑器一样，您可以使用鼠标中键或右键在 TileSet 面板上平移，并使用鼠标滚轮或左上角的按钮进行缩放。

如果要从单个 TileSet 的多个平铺表图像中获取平铺，请创建其他图集并为每个图集指定纹理，然后再继续。也可以通过这种方式为每个瓦片使用一个图像（尽管建议使用瓦片表以获得更好的可用性）。

可以在中间列中调整地图集的属性：



可以在图集上调整以下属性：

- **ID**：标识符（在这个 TileSet 中是唯一的），用于排序。
- **名称**：地图册的人类可读名称。此处使用描述性名称用于组织目的（例如“地形”、“装饰”等）。
- **页边距**：图像边缘上不应选择为平铺的页边距（以像素为单位）。如果您下载了边缘有页边空白的平铺图图像（例如用于归因），则增加此值可能会很有用。
- **分隔**：图集上每个瓦片之间的分隔（以像素为单位）。如果您正在使用的分幅图图像包含辅助线（例如每个分幅之间的轮廓），则增加此值可能非常有用。
- **纹理区域大小**：图集上每个平铺的大小（以像素为单位）。在大多数情况下，这应该与 TileMap 属性中定义的平铺大小相匹配（尽管这不是严格必要的）。
- **使用纹理填充**：如果选中，则在每个平铺周围添加一个 1 像素透明边，以防止启用过滤时纹理流血。除非由于纹理填充而遇到渲染问题，否则建议保持启用状态。

请注意，更改纹理边缘、分隔和区域大小可能会导致瓦片丢失（因为其中一些瓦片位于图集图像的坐标之外）。要从瓷砖表自动重新生成瓷砖，请使用瓷砖集编辑器顶部的三个垂直点菜单按钮，然后选择“**在不透明纹理区域中创建瓷砖**”（Create Tiles in Non-Transparent Texture Regions）：

###### 使用场景集合

自 Godot 4.0 以来，您可以将实际*场景*放置为平铺。这允许您将任何节点集合用作互动程序。例如，您可以使用场景平铺来放置游戏元素，例如玩家可以与之互动的商店。还可以使用场景平铺来放置 AudioStreamPlayer2D（用于环境声音）、粒子效果等。

> **警告：**
>
> 与图集相比，场景瓦片具有更大的性能开销，因为每个场景都是为每个放置的瓦片单独实例化的。
>
> 建议在必要时仅使用场景平铺。要在没有任何高级操作的情况下在平铺中绘制精灵，请使用图集。

对于本例，我们将创建一个包含 CPUParticles2D 根节点的场景。将此场景保存到场景文件（与包含 TileMap 的场景分离），然后切换到包含 TileMap 节点的场景。打开 TileSet 编辑器，并在左列中创建一个新的**场景集合**：

创建场景集合后，如果愿意，可以在中间列中输入场景集合的描述性名称。选择此场景集合，然后创建一个新的场景槽：

在右列中选择此场景槽，然后使用“**快速加载**”（或“**加载**”）加载包含粒子的场景文件：

现在，您的平铺集中有一个场景平铺。切换到平铺贴图编辑器后，您将能够从场景集合中选择它，并像绘制其他平铺一样绘制它。

##### 将多个图册合并为一个图册

在一个 TileSet 资源中使用多个图册有时会很有用，但在某些情况下也会很麻烦（尤其是在每个图块使用一个图像的情况下）。Godot 允许您将多个图集合并为一个图集，以便于组织。

要执行此操作，必须在 TileSet 资源中创建多个图集。使用位于图集列表底部的“三个垂直点”菜单按钮，然后选择“**打开图集合并工具**”：

这将打开一个对话框，您可以在其中按住 `Shift` 或 `Ctrl` 键，然后单击多个元素来选择多个图集：

选择“**合并**”将选定的图集合并为单个图集图像（转换为 TileSet 中的单个图集）。未合并的图集将在 TileSet 中删除，但原始的 tilesheet 图像将保留在文件系统中。如果不希望从 TileSet 资源中删除未合并的图集，请选择“**合并（保留原始图集）**”（Merge (Keep Original Atlases)）。

> **提示：**
>
> TileSet 具有一个 tile 代理系统。瓦片代理是一个映射表，它允许使用给定的瓦片集通知 TileMap 一组给定的瓦片标识符应该被另一组替换。
>
> 合并不同图集时会自动设置磁贴代理，但也可以手动设置，这要归功于您可以使用上述“三个垂直点”菜单访问的“**管理磁贴代理**”（Manage Tile Proxies）对话框。
>
> 当您更改图集 ID 或希望用另一图集中的瓷砖替换图集中的所有瓷砖时，手动创建瓷砖代理可能很有用。请注意，在编辑 TileMap 时，可以将所有单元格替换为其对应的映射值。

##### 将碰撞、导航和遮挡添加到 TileSet

我们现在已经成功创建了一个基本的 TileSet。我们现在可以开始在 TileMap 节点中使用，但它目前缺乏任何形式的碰撞检测。这意味着玩家和其他物体可以直接穿过地板或墙壁。

如果使用二维导航，还需要为瓦片定义导航多边形，以生成代理可用于寻路的导航网格。

最后，如果使用 2D 灯光和阴影或 GPUParticles2D，您可能还希望 TileSet 能够投射阴影并与粒子碰撞。这需要为 TileSet 上的“实心”瓷砖定义遮挡多边形。

为了能够为每个瓦片定义碰撞、导航和遮挡形状，您需要首先为瓦片集资源创建一个物理层、导航层或遮挡层。要执行此操作，请选择 TileMap 节点，单击检查器中的 TileSet 属性值进行编辑，然后展开 **Physics Layers** 并选择 **Add Element**：

如果您还需要导航支持，现在是创建导航层的好时机：

如果需要支持灯光多边形遮挡器，现在是创建遮挡层的好时机：

> **注意：**
>
> 本教程中的后续步骤是为创建碰撞多边形而定制的，但导航和遮挡的过程非常相似。它们各自的多边形编辑器的行为方式相同，因此为了简洁起见，不重复这些步骤。
>
> 唯一需要注意的是，平铺的遮挡多边形属性是图集检查器中“**渲染**”子部分的一部分。请确保展开此部分，以便可以编辑多边形。

创建物理层后，您可以访问 TileSet 图集检查器中的“**物理层**”部分：

在 TileSet 编辑器聚焦的同时按 `F` 键，可以快速创建矩形碰撞形状。如果键盘快捷键不起作用，请尝试单击多边形编辑器周围的空白区域以使其聚焦：

在此平铺碰撞编辑器中，您可以访问所有二维多边形编辑工具：

- 使用多边形上方的工具栏可以在创建新多边形、编辑现有多边形和删除多边形上的点之间切换。“三个垂直点”菜单按钮提供了其他选项，例如旋转和翻转多边形。
- 通过单击并拖动两点之间的直线来创建新点。
- 通过右键单击（或使用上面描述的“删除”工具并左键单击）删除点。
- 通过单击鼠标中键或右键在编辑器中平移。（右键单击平移只能用于附近没有点的区域。）

您可以使用默认的矩形形状，通过删除其中一个点来快速创建三角形碰撞形状：

您还可以通过添加更多点，将矩形用作更复杂形状的基础：

> **提示：**
>
> 如果有一个较大的平铺集，则单独为每个平铺指定碰撞可能会花费大量时间。这一点尤其正确，因为 TileMap 往往有许多具有常见碰撞图案的瓦片（例如实心块或 45 度斜坡）。若要将类似的碰撞形状快速应用于多个瓦片，请使用一次为多个瓦片指定特性的功能。

##### 将自定义元数据分配给平铺集的平铺

可以使用*自定义数据层*按平铺方式指定自定义数据。这对于存储特定于游戏的信息非常有用，例如玩家触摸瓷砖时瓷砖应该造成的伤害，或者瓷砖是否可以使用武器摧毁。

数据与平铺集中的平铺相关联：放置的平铺的所有实例都将使用相同的自定义数据。如果需要创建具有不同自定义数据的互动程序变体，可以通过创建替代互动程序并仅更改替代互动程序的自定义数据来完成。

您可以在不破坏现有元数据的情况下对自定义数据进行重新排序：对自定义数据属性进行重新排序后，TileSet 编辑器将自动更新。

请注意，在编辑器中，属性名称不会显示（仅显示它们的索引，该索引与它们的定义顺序相匹配）。例如，对于上面显示的自定义数据层示例，我们将分配一个瓦片，使 `damage_per_second` 元数据设置为 `25`，`destructible` 元数据设置为 `false`：

瓷砖特性绘制也可用于自定义数据：

##### 创建地形集（自动平铺）

> **注意：**
>
> 这个功能在 Godot3.x 中以一种不同于*自动平铺*（autotiling）的形式实现。Terrains本质上是自动驾驶的更强大的替代品。与自动地图不同，地形可以支持从一个地形过渡到另一个地形，因为一个瓦片可以同时定义多个地形。
>
> 与以前不同的是，自动地图是一种特定的瓷砖，地形只是分配给地图集瓷砖的一组属性。然后，专用的 TileMap 绘制模式使用这些属性，该模式以智能的方式选择具有地形数据的瓷砖。这意味着任何地形瓷砖都可以像其他瓷砖一样被绘制为地形或单个瓷砖。

“抛光”瓷砖集通常具有应在平台、地板等的角落或边缘使用的变体。虽然这些瓷砖可以手动放置，但很快就会变得乏味。用程序生成的级别处理这种情况也可能很困难，并且需要大量代码。

Godot 提供*地形*来自动执行这种瓷砖连接。这允许您自动使用“正确”的平铺变体。

地形被分为地形集。每个地形集都指定了“**匹配拐角和侧面**”（Match Corners and Sides）、“**匹配拐角**”和“**匹配侧面**”中的模式。它们定义了地形如何在地形集中相互匹配。

> **注意：**
>
> 上述模式对应于 Godot3.x: 2×2、3×3 或 3×3 minimum 中使用的先前位掩码模式自动文件。这也类似于平铺编辑器的功能。

选择 TileMap 节点，转到检查器并在 TileSet *资源*中创建新的地形集：

创建地形集后，**必须**在地形集*中*创建一个或多个地形：

在平铺集编辑器中，切换到“选择”模式，然后单击平铺。在中间的列中，展开“**地形**”部分，然后为分幅指定地形集 ID 和地形 ID。`-1` 表示“无地形设置”或“无地形”，这意味着您必须将“**地形设置**”设置为 `0` 或更大，然后才能将“**地形**”设置为 `0` 或更大。

> **注意：**
>
> 地形集 ID 和地形 ID 彼此独立。它们也从 `0` 开始，而不是从 `1` 开始。

完成此操作后，您现在可以配置在中间列中可见的**地形对等位**部分。对等比特根据相邻瓦片来确定将放置哪个瓦片。`-1` 是一个特殊值，指的是空格。

例如，如果一个瓦片的所有位都设置为 `0` 或更大，则只有当所有 8 个相邻瓦片都在使用具有相同地形 ID 的瓦片时，它才会出现。如果瓦片的位设置为 `0` 或更大，但左上角、右上角和右上角位设置为 `-1`，则只有在其顶部（包括对角线）有空格时才会出现。

完整瓷砖表的配置示例如下：

##### 一次为多个瓦片指定属性

有两种方法可以同时为多个瓦片指定特性。根据您的使用情况，一种方法可能比另一种更快：

###### 使用多个平铺选择

如果希望一次配置多个属性，请选择 TileSet 编辑器顶部的 **Select**（选择）模式：

完成此操作后，可以通过按住 `Shift` 键然后单击平铺来选择右侧列上的多个平铺。您也可以通过按住鼠标左键然后拖动鼠标来执行矩形选择。最后，您可以通过按住 `Shift` 键然后单击选定的磁贴来取消选择已选定的磁帖（而不影响选择的其余部分）。

然后可以使用 TileSet 编辑器中间列中的检查器指定属性。只有您在此处更改的属性才会应用于所有选定的磁贴。与编辑器的检查器中一样，选定分幅上不同的属性在编辑之前将保持不同。

使用数字和颜色特性，编辑特性后，您还将在图集中的所有瓷砖上看到特性值的预览：

###### 使用瓷砖特性绘画

如果希望一次将单个特性应用于多个平铺，则可以使用*特性绘制*模式来实现此目的。

配置要在中间列中绘制的属性，然后在右列中单击平铺（或按住鼠标左键）以在平铺上“绘制”属性。

瓷砖特性绘制对于手动设置耗时的特性尤其有用，例如碰撞形状：

##### 创建替代瓷砖

有时，您希望使用单个平铺图像（在图集中只找到一次），但配置方式不同。例如，您可能希望使用相同的平铺图像，但旋转、翻转或使用不同的颜色进行调制。这可以使用*替代*瓷砖来完成。

若要创建备选瓷砖，请在瓷砖集编辑器显示的图集中的基础瓷砖上单击鼠标右键，然后选择“**创建备选瓷砖**”：

如果当前处于“选择”模式，则已选择备选磁贴进行编辑。如果当前未处于“选择”模式，您仍然可以创建替代磁贴，但您需要切换到“选择模式”并选择替代磁贴进行编辑。

如果您没有看到替代瓦片，请平移到图集图像的右侧，因为替代瓦片总是出现在 TileSet 编辑器中给定图集的基础瓦片的右侧：

选择替代平铺之后，可以像在基础平铺上一样使用中间列更改任何属性。然而，与底层瓷砖相比，暴露特性列表有所不同：

- **备选 ID**：此备选瓦片的唯一数字标识符。更改它会破坏现有的 TileMap，所以要小心！此 ID 还控制在编辑器中显示的备选瓦片列表中的排序。
- **渲染 > 翻转 H**：如果为 `true`，则平铺将水平翻转。
- **渲染 > 翻转 V**：如果为 `true`，则平铺将垂直翻转。
- **渲染 > 平移**：如果为 `true`，则平铺将逆时针旋转 90 度。将其与“**翻转 H**”和/或“**翻转 V**”组合，以执行 180 度或 270 度旋转。
- **渲染 > 纹理原点**：用于绘制瓷砖的原点。与基础瓦片相比，这可以用于在视觉上偏移瓦片。
- **渲染 > 调制**：渲染平铺时要使用的颜色倍增。
- **渲染 > 材质**：用于此平铺的材质。这可用于将不同的混合模式或自定义着色器应用于单个平铺。
- **Z 索引**：此磁贴的排序顺序。较高的值将使平铺呈现在同一层上的其他平铺之前。
- **Y 排序原点**：用于基于其 Y 坐标（以像素为单位）进行平铺排序的垂直偏移。这允许在自上而下的游戏中使用不同高度的层。调整这一点可以帮助缓解排序某些磁贴的问题。仅当平铺所在的平铺贴图层上的“**Y 排序启用**”为 `true` 时有效。

您可以通过单击替代磁贴旁边的大“+”图标来创建其他替代磁贴变体。这相当于选择基础平铺，然后右键单击以再次选择“**创建替代平铺**”。

> **注意：**
>
> 创建替代平铺时，不会继承基础平铺中的任何属性。如果希望基础磁贴和备选磁贴上的属性相同，则必须在备选磁贴中再次设置属性。

#### 使用 TileMaps

> **参考：**
>
> 此页面假定您已经创建或下载了 TileSet。如果没有，请先阅读使用 TileSet，因为您需要一个 TileSet 来创建 TileMap。

##### 介绍

瓷砖贴图是用于创建游戏布局的瓷砖网格。使用 TileMap 节点设计关卡有几个好处。首先，它们可以通过在网格上“绘制”瓷砖来绘制布局，这比逐个放置单个 Sprite2D 节点要快得多。其次，它们允许更大的级别，因为它们是为绘制大量瓷砖而优化的。最后，您可以将碰撞、遮挡和导航形状添加到平铺中，从而为平铺贴图添加更大的功能。

> **注意：**
>
> Godot 4.0已将多个逐瓦片属性（如瓦片旋转）从TileMap移动到TileSet。在“平铺贴图”编辑器中时，无法再旋转单个平铺。相反，必须使用TileSet编辑器来创建替代的旋转平铺。
>
> 此更改允许更大的设计一致性，因为并非每个瓦片都需要在瓦片集中旋转或翻转。

##### 在 TileMap 中指定 TileSet

如果您已经阅读了上一页的“使用 TileSet”，则应该有一个 TileMap 节点内置的 TileSet 资源。这有利于原型设计，但在现实世界的项目中，通常会有多个级别重用同一个 tileset。

在多个 TileMap 节点中重用同一 TileSet 的推荐方法是将 TileSet 保存到外部资源。要执行此操作，请单击 TileSet 资源旁边的下拉列表，然后选择“**保存**”：

##### 创建平铺贴图层

从 Godot 4.0 开始，您可以在单个 TileMap 节点中放置多个层。例如，这允许您区分前景分幅和背景分幅，以便更好地组织。您可以在给定的位置每层放置一个平铺，如果您有多个层，则可以将多个平铺重叠在一起。

默认情况下，TileMap 节点自动具有一个预制层。如果只需要一个图层，则不必创建其他图层，但如果现在要创建，请选择 TileMap 节点并展开检查器中的 **Layers** 部分：

每个层都有几个可以调整的特性：

- **名称**：显示在 TileMap 编辑器中的可读名称。这可以是“背景”、“建筑”、“植被”等。
- **Enabled**（启用）：如果为 `true`，则该层在编辑器中以及运行项目时可见。
- **调制**：用作层上所有瓷砖的乘数的颜色。这也与每个瓦片的 **Modulate** 属性和 TileMap 节点的 **Modulate** 特性相乘。例如，可以使用此选项使背景分幅变暗，使前景分幅更加突出。
- **启用 Y 排序**：如果为 `true`，则根据瓷砖在 TileMap 上的 Y 位置对瓷砖进行排序。这可以用于防止某些平铺设置中的排序问题，尤其是等轴测平铺。
- **Y 排序原点**：用于在每个瓦片上进行 Y 排序的垂直偏移（以像素为单位）。仅当“**Y 排序启用**”为 `true` 时有效。
- **Z 索引**：控制该层是绘制在其他 TileMap 层的前面还是后面。该值可以是正的，也可以是负的；具有最高Z索引的层被绘制在其他层的顶部。如果多个图层具有相等的Z索引特性，则图层列表中最后一个图层（显示在列表底部的图层）将绘制在顶部。

您可以通过拖放“**层**”部分中条目左侧的“三个水平条”图标来重新排列层。

> **注意：**
>
> 您可以在未来创建、重命名或重新排序层，而不会影响现有平铺。不过要小心，因为*移除*一层也会移除放置在该层上的所有瓷砖。

##### 打开 TileMap 编辑器

选择 TileMap 节点，然后打开编辑器底部的 TileMap 面板：

##### 选择用于绘制的瓷砖

首先，如果您已经在上面创建了其他层，请确保您已经选择了要在其上绘制的层：

> **提示：**
>
> 在 2D 编辑器中，当前未从同一 TileMap 节点编辑的层在 TileMap 编辑器中显示为灰色。可以通过单击图层选择菜单旁边的图标（“**高亮显示选定的平铺贴图图层**”工具提示）禁用此行为。

如果尚未创建其他层，则可以跳过上述步骤，因为进入 TileMap 编辑器时会自动选择第一个层。

在二维编辑器中放置平铺之前，必须在编辑器底部的“平铺贴图”面板中选择一个或多个平铺。要执行此操作，请单击“平铺贴图”面板中的一个平铺，或按住鼠标按钮选择多个平铺：

> **提示：**
> 与 2D 和 TileSet 编辑器一样，可以使用鼠标中键或右键在 TileMap 面板上平移，并使用鼠标滚轮或左上角的按钮进行缩放。

也可以按住 `Shift` 键以附加到当前选择。选择多个平铺时，每次执行绘制操作时都会放置多个平铺。这可以用于在一次单击中绘制由多个瓦片组成的结构（如大型平台或树木）。

最终选择不必是连续的：如果选定的平铺之间有空白，则在 2D 编辑器中绘制的图案中，该平铺将保持空白。

如果您已经在瓷砖集中创建了替代瓷砖，则可以选择它们在基础瓷砖的右侧进行绘制：

最后，如果在 TileSet 中创建了场景集合，则可以在 TileMap 中放置场景瓦片：

##### 绘画模式和工具

使用 TileMap 编辑器顶部的工具栏，可以在多种绘制模式和工具之间进行选择。这些模式会影响在二维编辑器中单击时的操作，而不是 TileMap 面板本身。

从左到右，可以选择的绘制模式和工具有：

###### 选择

通过单击单个平铺，或在 2D 编辑器中按住鼠标左键选择多个带有矩形的平铺来选择平铺。请注意，不能选择空格：如果创建矩形选择，则只会选择非空的平铺。

若要附加到当前选择，请按住 `Shift` 键，然后选择平铺。若要从当前选择中删除，请按住 `Ctrl` 键，然后选择一个互动程序。

然后，可以在任何其他绘制模式中使用该选择来快速创建已放置图案的副本。

在“选择”模式下，不能放置新的分幅，但在进行选择后仍可以通过右键单击擦除分幅。无论您在选择中单击的位置如何，整个选择都将被擦除。

在“绘制”模式下，可以通过按住 `Ctrl` 键然后执行选择来临时切换此模式。

> **提示：**
>
> 通过执行选择，按 `Ctrl + C`，然后按 `Ctrl + V`，可以复制和粘贴已放置的平铺。左键单击后将粘贴所选内容。您可以再次按 `Ctrl + V` 以这种方式执行更多复制。右键单击或按 `Esc` 键取消粘贴。

###### 绘制

标准的“绘制”模式允许您通过单击或按住鼠标左键来放置瓷砖。

如果右键单击，当前选定的平铺将从平铺映射中删除。换句话说，它将被空的空间所取代。

如果在 TileMap 中或使用“选择”工具选择了多个平铺，则每次按住鼠标左键单击或拖动鼠标时都会放置这些平铺。

> **提示：**
>
> 在“绘制”模式下，可以通过在按住鼠标左键之前按住 `Shift`，然后将鼠标拖动到线的终点来绘制线。这与使用下面描述的Line（测线）工具相同。
>
> 您也可以在按住鼠标左键之前按住 `Ctrl` 和 `Shift`，然后将鼠标拖动到矩形的终点，从而绘制矩形。这与使用下面描述的矩形工具相同。
>
> 最后，您可以在二维编辑器中通过按住 `Ctrl` 键然后单击平铺（或按住并拖动鼠标）来拾取现有的平铺。这将把当前绘制的互动程序切换到您刚刚单击的互动程序。这与使用下面描述的选取器工具相同。

###### 线

选择“Line Paint”模式后，可以绘制一条始终为 1 瓷砖厚的线（无论其方向如何）。

如果在“线条绘制”模式下单击鼠标右键，则将在线条中进行擦除。

如果在 TileMap 中或使用“选择”工具选择了多个平铺，则可以将它们放置在直线上的重复图案中。

在“绘制”或“擦除”模式下，可以通过按住 `Shift` 键然后绘制来临时切换此模式。

###### 矩形

选择“矩形绘制”模式后，可以绘制轴对齐的矩形。

如果在“矩形绘制”模式下单击鼠标右键，将在轴对齐的矩形中进行擦除。

如果在 TileMap 中或使用“选择”工具选择了多个平铺，则可以将它们放置在矩形内的重复图案中。

在“绘制”或“橡皮擦”模式下，可以通过按住 `Ctrl` 和 `Shift` 键然后绘制来临时切换此模式。

###### 桶填充

选择 Bucket Fill（桶填充）模式后，您可以仅通过切换工具栏右侧的 **Contiqueous**（连续）复选框来选择是否将绘画限制在连续区域。

如果启用“**连续**”（默认设置），则只会替换与当前选择相匹配的磁贴。这种连续检查是水平和垂直执行的，但*不是*对角执行的。

如果禁用“**连续**”，则整个 TileMap 中具有相同 ID 的所有磁贴都将被当前选定的磁贴替换。如果在未选中“**连续**”的情况下选择一个空分幅，则包含分幅贴图有效区域的矩形中的所有分幅都将被替换。

如果在 Bucket Fill（桶填充）模式下单击鼠标右键，则会将匹配的瓦片替换为空瓦片。

如果在 TileMap 中或使用“选择”工具选择了多个瓷砖，则可以将它们放置在填充区域内的重复图案中。

###### 选取器

选择“选取器”模式后，可以在二维编辑器中通过按住 `Ctrl` 键然后单击平铺来选取现有的平铺。这将把当前绘制的互动程序切换到您刚刚单击的互动程序。您还可以通过按住鼠标左键并形成矩形选择来一次拾取多个平铺。只能拾取非空瓷砖。

在“绘制”模式下，可以通过按住 `Ctrl` 键然后单击或拖动鼠标来临时切换此模式。

###### 橡皮擦

此模式与任何其他绘制模式（绘制、直线、矩形、桶填充）相结合。启用橡皮擦模式时，左键单击时，平铺将被空的平铺替换，而不是绘制新线。

在任何其他模式下，您可以通过右键单击而不是左键单击来临时切换此模式。

##### 使用散射随机绘制

绘制时，可以选择启用*随机化*。启用后，绘制时将在当前选定的所有平铺之间选择一个随机平铺。这由“绘制”、“直线”、“矩形”和“桶填充”工具支持。为了有效地进行绘制随机化，必须在 TileMap 编辑器中选择多个平铺或使用散射（这两种方法可以组合使用）。

如果“**散射**”设置为大于 0 的值，则绘制时可能不会放置瓷砖。这可以用于向大区域添加偶尔的、不重复的细节（例如在大型自上而下的 TileMap 上添加草或碎屑）。

使用“绘制”模式时的示例：

使用桶填充模式时的示例：

> **注意：**
>
> 橡皮擦模式不考虑随机化和散射。选择中的所有平铺始终被删除。

##### 使用图案保存和加载预制瓷砖放置

虽然您可以在选择模式下复制和粘贴瓷砖，但您可能希望保存预制的瓷砖*图案*，以便一次放置在一起。这可以在每个 TileMap 的基础上通过选择 TileMap 编辑器的 **Patterns** 选项卡来完成。

要创建新图案，请切换到“选择”模式，执行选择并按 `Ctrl + C`。单击“图案”选项卡中的空白区域（空白区域周围应显示一个蓝色焦点矩形），然后按 `Ctrl + V`：

要使用现有图案，请在“**图案**”选项卡中单击其图像，切换到任何绘画模式，然后在 2D 编辑器中的某个位置左键单击：

与多瓷砖选择一样，如果与线条、矩形或桶填充绘画模式一起使用，图案将重复。

> **注意：**
>
> 尽管在 TileMap 编辑器中进行了编辑，但模式仍存储在 TileSet 资源中。这允许在加载保存到外部文件的 TileSet 资源后，在不同的 TileMap 节点中重用模式。

##### 使用地形自动处理瓷砖连接

若要使用地形，TileMap 节点必须至少包含一个地形集和该地形集中的一个地形。如果尚未为 TileSet 创建地形集，请参见创建地形集（自动平铺）。

地形连接有三种可用的绘制模式：

- **Connect**，其中瓦片连接到同一 TileMap 层上的周围瓦片。
- **路径**，其中瓦片连接到在同一笔划中绘制的瓦片（直到释放鼠标按钮为止）。
- 平铺特定替代以解决冲突或处理地形系统未覆盖的情况。

“连接”模式更容易使用，但“路径”更灵活，因为它允许在绘画过程中进行更多的艺术家控制。例如，“路径”可以允许道路直接相邻而不相互连接，而“连接”将强制连接两条道路。

最后，您可以从地形中选择特定的瓦片来解决某些情况下的冲突：

任何将其至少一个比特设置为对应地形ID的值的瓦片都将出现在可供选择的瓦片列表中。

##### 处理丢失的瓷砖

如果删除 TileMap 中引用的 TileSet 中的瓦片，TileMap 将显示一个占位符，指示放置了无效的瓦片 ID：

这些占位符在正在运行的项目中**不**可见，但磁贴数据仍然保留在磁盘上。这样可以安全地关闭和重新打开这些场景。重新添加具有匹配 ID 的互动程序后，这些互动程序将以新互动程序的外观出现。

> **注意：**
>
> 在选择 TileMap 节点并打开 TileMap 编辑器之前，丢失的磁贴占位符可能不可见。

## 动画

### 动画功能简介

[AnimationPlayer](https://docs.godotengine.org/en/stable/classes/class_animationplayer.html#class-animationplayer) 节点允许您创建从简单到复杂的任何动画。

在本指南中，您将学会：

- 使用“动画”面板
- 为任何节点的任何属性制作动画
- 创建一个简单的动画

在 Godot 中，您可以为 Inspector 中的任何可用内容设置动画，如节点变换、精灵、UI 元素、粒子、材质的可见性和颜色等。您还可以修改脚本变量的值，甚至调用函数。

#### 创建 AnimationPlayer 节点

要使用动画工具，我们首先必须创建一个 AnimationPlayer 节点。

AnimationPlayer 节点类型是动画的数据容器。一个 AnimationPlayer 节点可以容纳多个动画，这些动画可以自动转换到另一个。

创建 AnimationPlayer 节点后，单击该节点以打开视口底部的“动画面板”。

动画面板由四个部分组成：

- 动画控件（即添加、加载、保存和删除动画）
- 曲目列表
- 具有关键帧的时间线
- 时间轴和轨迹控件，例如，您可以在其中缩放时间轴和编辑轨迹。

#### 计算机动画依赖于关键帧

关键帧定义某个时间点上特性的值。

菱形表示时间轴中的关键帧。两个关键帧之间的一条线表示它们之间的值不变。

可以设置节点属性的值，并为其创建动画关键帧。当动画运行时，引擎将在关键帧之间插值，导致它们随着时间的推移逐渐变化。

时间轴定义动画所需的时间。可以在各个点插入关键帧，并更改它们的计时。

“动画面板”中的每一行都是引用节点的“法线”或“变换”特性的动画轨迹。每个轨迹都存储一个节点及其受影响特性的路径。例如，图中的位置轨迹指的是 Sprite2D 节点的 `position` 特性。

> **提示：**
> 如果设置了错误的特性动画，则可以通过双击轨迹并键入新路径来随时编辑轨迹的路径。使用“从头开始播放”按钮从头开始播放动画（或按键盘上的 `Shift + D` 键）可以立即查看更改。

#### 教程：创建简单动画

##### 场景设置

在本教程中，我们将创建一个以 AnimationPlayer 作为其子节点的精灵节点。我们将设置精灵的动画，使其在屏幕上的两个点之间移动。

> **警告：**
>
> AnimationPlayer 继承自 Node，而不是 Node2D 或 Node3D，这意味着子节点将不会继承父节点的变换，因为层次中存在裸节点。
>
> 因此，不建议将具有 2D/3D 变换的节点添加为 AnimationPlayer 节点的子节点。

精灵包含一个图像纹理。对于本教程，请选择 Sprite2D 节点，在“检查器”中单击“纹理”，然后单击“加载”。为精灵的纹理选择默认的 Godot 图标。

##### 添加动画

选择 AnimationPlayer 节点，然后单击动画编辑器中的“动画”按钮。从列表中，选择“新建”（添加动画）以添加新动画。在对话框中输入动画的名称。

##### 管理动画库

为了便于重用，动画将注册在动画库资源的列表中。如果在未指定任何特定设置的情况下将动画添加到 AnimationPlayer，则该动画将注册在默认情况下 AnimationPlayer 拥有的[全局]动画库中。

如果有多个动画库，并且您试图添加一个动画，则会出现一个对话框，其中包含选项。

##### 添加曲目

要为我们的精灵添加新曲目，请选择它并查看工具栏：

使用这些开关和按钮可以为选定节点的位置、旋转和缩放添加关键帧。由于我们只设置精灵位置的动画，请确保只选择位置开关。所选开关为蓝色。

单击关键帧按钮以创建第一个关键帧。由于我们还没有为 Position 属性设置轨道，Godot 将提供为我们创建它。单击“**创建**”。

Godot 将创建一个新的轨迹，并在时间线的开头插入我们的第一个关键帧：

##### 第二个关键帧

我们需要设置精灵的结束位置以及到达那里需要多长时间。

比方说，我们希望在两个点之间移动需要两秒钟。默认情况下，动画设置为仅持续一秒钟，因此在动画面板的时间轴标题右侧的控件中将动画长度更改为 2。

现在，将精灵向右移动到其最终位置。可以使用工具栏中的*“移动”工具*，也可以在“*检查器*”（Inspector）中设置“*位置*”的X值。

单击动画面板中两秒标记附近的时间轴标题，然后单击工具栏中的关键点按钮以创建第二个关键帧。

##### 运行动画

单击“从头开始播放”（从头开始播放）按钮。

耶！我们的动画运行：

##### 来回

Godot 有一个有趣的功能，我们可以在动画中使用。如果设置了“动画循环”，但在动画结束时没有指定关键帧，则第一个关键帧也是最后一个关键帧。

这意味着我们现在可以将动画长度延长到 4 秒，Godot 还将计算从最后一个关键帧到第一个关键帧的帧，来回移动我们的精灵。

可以通过更改轨迹的循环模式来更改此行为。这将在下一章中介绍。

##### 轨迹设置

每条轨迹的末尾都有一个设置面板，您可以在其中设置其更新模式、轨迹插值和循环模式。

轨迹的更新模式告诉 Godot 何时更新属性值。这可以是：

- **连续**：更新每帧上的特性
- **离散**：仅更新关键帧上的特性
- **捕获**：如果第一个关键帧的时间大于0.0，则会记住特性的当前值，并与第一个动画关键帧混合。例如，您可以使用“捕获”模式将位于任何位置的节点移动到特定位置。

您通常会使用“连续”模式。其他类型用于编写复杂动画的脚本。

轨迹插值告诉 Godot 如何计算关键帧之间的帧值。支持以下插值模式：

- 最近：设置最近的关键帧值
- 线性：基于两个关键帧之间的线性函数计算设置值
- 立方：基于两个关键帧之间的立方函数计算设置值
- 线性角度（仅显示在旋转特性中）：具有最短路径旋转的线性模式
- 立方角（仅显示在旋转特性中）：具有最短路径旋转的立方模式

使用“立方插值”，动画在关键帧处的速度较慢，在关键帧之间的速度较快，这会导致更自然的移动。立方插值通常用于角色动画。线性插值以固定的速度为更改设置动画，从而产生更机器人化的效果。

Godot 支持两种循环模式，当设置为循环时，这两种模式会影响动画：

- 钳制循环插值：选择此选项时，动画将在该轨迹的最后一个关键帧之后停止。当再次到达第一个关键帧时，动画将重置为其值。
- 环绕循环插值：选中此选项后，Godot 将计算最后一个关键帧之后的动画，以再次达到第一个关键帧的值。

#### 其他属性的关键帧

Godot 的动画系统并不局限于位置、旋转和缩放。可以设置任何特性的动画。

如果在动画面板可见的情况下选择精灵，Godot 将在每个精灵属性的 *Inspector* 中显示一个小的关键帧按钮。单击其中一个按钮可将轨迹和关键帧添加到当前动画中。

#### 编辑关键帧

可以单击动画时间轴中的关键帧，以在“*检查器*”中显示和编辑其值。

也可以在此处通过单击并拖动关键帧的缓和曲线来编辑其缓和值。这告诉 Godot 在到达该关键帧时如何插值动画属性。

您可以通过这种方式调整动画，直到移动“看起来正确”。

#### 使用 RESET 轨道

您可以设置一个特殊的 RESET 动画来包含“默认姿势”。这用于确保在保存场景并在编辑器中再次打开场景时恢复默认姿势。

对于现有轨迹，可以添加名为“RESET”（区分大小写）的动画，然后为要重置的每个特性添加轨迹。唯一的关键帧应该在时间 0，并为每个轨迹指定所需的默认值。

如果 AnimationPlayer 的“**保存时重置**”（Reset On Save）属性设置为 `true`，则场景将在应用重置动画效果的情况下保存（就像搜索到时间 `0.0` 一样）。这只会影响已保存的文件-编辑器中的属性轨迹保持不变。

如果要重置编辑器中的轨迹，请选择 AnimationPlayer 节点，打开“**动画**”底部面板，然后在动画编辑器的“**编辑**”（Edit）下拉菜单中选择“**应用重置**”（Apply Reset）。

在新动画上添加轨迹时，编辑器将要求您在使用检查器中特性旁边的关键帧图标时自动创建 RESET 轨迹。这不适用于使用 3.4 之前的 Godot 版本创建的轨迹，因为 3.4 中添加了动画重置轨迹功能。

> **注意：**
>
> RESET 轨迹也用作混合的参考值。请参见以获得更好的混合效果。

### 动画轨迹类型

此页面概述了 Godot 的动画播放器节点在默认属性轨迹之上可用的轨迹类型。

> **参考：**
>
> 我们假设您已经阅读了动画功能简介，其中涵盖了基本内容，包括属性轨迹。

#### 属性轨道

最基本的轨道类型。请参见动画功能简介。

#### 位置 3D/旋转 3D/缩放 3D 轨道

这些三维变换轨迹控制三维对象的位置、旋转和比例。与使用常规特性轨迹相比，它们使 3D 对象的变换更容易设置动画。

它是为从外部 3D 模型导入的动画而设计的，可以通过压缩来减少资源容量。

#### 混合变形轨道

混合形状轨迹经过优化，可在 MeshInstance3D 中设置混合形状的动画。

它是为从外部3D模型导入的动画而设计的，可以通过压缩来减少资源容量。

#### 调用方法轨道

调用方法轨迹允许您在动画中的精确时间调用函数。例如，可以调用 `queue_free()` 来删除死亡动画结尾的节点。

> **注意：**
> 为了安全起见，在编辑器中预览动画时，不会执行放置在调用方法轨迹上的事件。

要创建这样的轨迹，请单击“添加轨迹->调用方法轨迹”。然后，会打开一个窗口，您可以选择要与轨迹关联的节点。要调用节点的方法之一，请右键单击时间线并选择“插入关键点”。将打开一个窗口，其中包含可用方法的列表。双击一个以完成关键帧的创建。

要更改方法调用或其参数，请单击键并前往检查器停靠站。在那里，您可以更改要调用的方法。如果展开“Args”部分，您将看到一个可以编辑的参数列表。

#### 贝塞尔曲线轨道

贝塞尔曲线轨道类似于特性轨迹，只是它允许您使用贝塞尔曲线设置特性值的动画。

> **注意：**
> Bezier 曲线轨道和特性轨道不能在 AnimationPlayer 和 AnimationTree 中混合。

要创建一个，请单击“添加轨迹->贝塞尔曲线轨迹”。与特性轨迹一样，您需要选择一个节点和一个特性来设置动画。若要打开贝塞尔曲线编辑器，请单击动画轨迹右侧的曲线图标。

在编辑器中，关键点由填充的菱形表示，轮廓菱形通过线控制曲线的形状连接到关键点。

在编辑器的右键单击面板中，可以选择处理模式：

- 自由：允许在不影响其他操纵器位置的情况下沿任何方向定向操纵器。
- 线性：不允许旋转操纵器并绘制线性图形。
- 平衡：使操纵器一起旋转，但关键点和操纵器之间的距离不镜像。
- 镜像：使一个操纵器的位置与另一个完全镜像，包括它们到关键点的距离。

#### 音频播放音轨

如果要使用音频创建动画，则需要创建音频播放轨迹。若要创建一个，场景必须具有 AudioStreamPlayer、AudioStreamPlayer2D 或 AudioStream Player3D 节点。创建轨迹时，必须选择其中一个节点。

若要在动画中播放声音，请将音频文件从文件系统停靠点拖放到动画轨迹上。您应该在音轨中看到音频文件的波形。

要从动画中删除声音，您可以右键单击它并选择“Delete Key(s)”，或者单击它并按 `Del` 键。

混合模式允许您选择在 [AnimationTree](https://docs.godotengine.org/en/stable/classes/class_animationtree.html#class-animationtree) 中混合时是否调整音量。

#### 动画播放音轨

通过动画播放轨迹，可以对场景中其他动画播放器节点的动画进行排序。例如，可以使用它为剪切场景中的几个角色设置动画。

要创建动画播放轨迹，请选择“新建轨迹->动画播放轨迹”

然后，选择要与轨迹关联的动画播放器。

若要将动画添加到轨迹中，请在其上单击鼠标右键并插入关键点。选择刚刚创建的关键点以在检查器停靠中选择动画。

如果一个动画已经在播放，并且您想提前停止它，您可以创建一个关键点，并在检查器中将其设置为[*STOP*]。

> **注意：**
>
> 如果将包含动画播放器的场景实例化到场景中，则需要在场景树中启用“可编辑子对象”以访问其动画播放器。此外，动画播放器不能引用自己。

### 剪切动画

#### 它是什么？

传统上，剪切动画是一种定格动画，其中纸张（或其他薄材料）被切割成特殊形状，并以角色和对象的二维表示形式排列。角色的身体通常由几个部分组成。影片的每一帧都会对这些片段进行一次排列和拍摄。动画师在每个镜头之间以小的增量移动和旋转零件，以在图像按顺序快速播放时产生移动的错觉。

现在可以使用软件创建剪切动画的模拟，如《南方公园》和《杰克与永不落幕的海盗》中所示。

在电子游戏中，这种技术也变得流行起来。例如 Paper Mario 或 Rayman Origins。

#### Godot 中的剪切动画

Godot 提供了使用剪切钻机的工具，非常适合工作流程：

- **动画系统与引擎完全集成**：这意味着动画可以控制的不仅仅是对象的运动。纹理、精灵大小、枢轴、不透明度、颜色调制等等，都可以设置动画并进行混合。
- **组合动画样式**：AnimatedSprite2D 允许将传统的 cel 动画与剪切动画一起使用。在 cel 动画中，不同的动画帧使用完全不同的图形，而不是不同位置的相同片段。在其他基于剪切的动画中，cel 动画可以选择性地用于复杂的部分，如手、脚、变化的面部表情等。
- **自定义形状元素**：可以使用 Polygon2D 创建自定义形状，允许 UV 动画、变形等。
- **粒子系统**：剪切动画装备可以与粒子系统组合。这对魔术效果、喷气背包等都很有用。
- **自定义碰撞器**：在骨骼的不同部分设置碰撞器和影响区域，非常适合老板和格斗游戏。
- **动画树**：允许在多个动画之间进行复杂的组合和混合，与在 3D 中的工作方式相同。

还有更多！

#### GBot 的制作

在本教程中，我们将使用安德烈亚斯·以扫创建的 GBot 角色片段作为演示内容。

获取您的资产：cutout_animation_assets.zip。

#### 设置钻机

创建一个空的 Node2D 作为场景的根，我们将在它下面工作：

模型的第一个节点是臀部。通常，在二维和三维中，髋部都是骨骼的根部。这样可以更容易地设置动画：

接下来是躯干。躯干需要是臀部的子对象，因此创建一个子精灵并加载躯干纹理，稍后适当调整：

这看起来不错。让我们通过旋转躯干来看看我们的层次是否像骨架一样工作。我们可以按 `E` 键进入旋转模式，然后用鼠标左键拖动。要退出旋转模式，请按 `ESC`。

旋转枢轴错误，需要调整。

Sprite2D 中间的这个小十字是旋转枢轴：

#### 调整枢轴

可以通过更改 Sprite2D 中的偏移特性来调整轴心：

枢轴也可以通过*视觉*进行调整。将鼠标悬停在所需的轴点上时，按 `V` 键将选定 Sprite2D 的轴移动到该轴点。工具栏中还有一个具有类似功能的工具。

继续添加身体部位，从右臂开始。确保将每个精灵放在层次中的正确位置，使其旋转和平移相对于其父精灵：

左臂有问题。在二维中，子节点显示在其父节点的前面：

我们希望左臂出现在臀部和躯干*后面*。我们可以将左臂节点移动到髋部后面（场景层次中的髋部节点上方），但左臂不再位于层次中的适当位置。这意味着它不会受到躯干运动的影响。我们将使用 `RemoteTransform2D` 节点解决此问题。

> **注意：**
>
> 还可以通过调整从 Node2D 继承的任何节点的 Z 属性来解决深度排序问题。

#### RemoteTransform2D 节点

RemoteTransform2D 节点变换层次中其他位置的节点。此节点将其自己的变换（包括从其父节点继承的任何变换）应用于其目标的远程节点。

这使我们能够校正元素的可见性顺序，而与剪切层次结构中这些部分的位置无关。

创建 `RemoteTransform2D` 节点作为躯干的子节点。称之为 `remote_arm_l`。在第一个节点内创建另一个 RemoteTransform2D节点，并将其称为 `remote_hand_l`。使用两个新节点的 `RemotePath` 属性分别以 `arm_l` 和 `hand_l` 精灵为目标：

移动 `RemoteTransform2D` 节点现在会移动精灵。因此，我们可以通过调整 `RemoteTransform2D` 变换来创建动画：

#### 完成骨架

按照与其余零件相同的步骤完成骨架。生成的场景应类似于以下内容：

生成的装备将易于设置动画。通过选择节点并旋转它们，可以有效地设置正向运动学（FK）的动画。

对于简单的对象和装备，这是可以的，但也有局限性：

- 在复杂装备中，在主视口中选择精灵可能会变得困难。场景树最终被用来选择部分，这可能会更慢。
- 反向运动学（IK）可用于设置手和脚等肢体的动画，并且在当前状态下不能与装备一起使用。

为了解决这些问题，我们将使用 Godot 的骨架。

#### 骨骼

在 Godot 中，有一个助手可以在节点之间创建“骨骼”。骨骼链接的节点称为骨骼。

作为一个例子，让我们把右臂变成一个骨架。若要创建骨架，必须从上到下选择节点链：

然后，单击“骨架”菜单，然后选择 `Make Bones`。

这将增加覆盖手臂的骨骼，但结果可能令人惊讶。

为什么这只手没有骨头？在 Godot 中，骨骼将节点与其父节点连接起来。并且目前没有手节点的子节点。有了这些知识，让我们再试一次。

第一步是创建一个端点节点。任何类型的节点都可以，但 Marker2D 是首选，因为它在编辑器中可见。端点节点将确保最后一块骨骼具有方向。

现在选择从端点到手臂的整个链，并创建骨骼：

结果更像骨骼，现在可以选择手臂和前臂并设置动画。

为所有重要的肢体创建端点。为切口的所有可关节连接部分生成骨骼，并将髋部作为所有这些部分之间的最终连接。

您可能会注意到，在连接臀部和躯干时会创建一个额外的骨骼。Godot 已经用骨骼将髋关节节点连接到场景根，我们不希望这样。若要解决此问题，请选择根节点和髋部节点，打开“骨架”菜单，单击 `clear bones`。

你的最终骨架应该是这样的：

您可能已经注意到手中有第二组端点。这很快就会有意义。

现在整个图形都已装配好，下一步是设置 IK 链。IK 链允许对肢体进行更自然的控制。

#### IK 链

IK 代表反向运动学。这是一种方便的技术，可以设置手、脚和其他末端的位置动画，就像我们制作的一样。想象一下，您希望将角色的脚放置在地面上的特定位置。如果没有 IK 链，脚的每次运动都需要旋转和定位其他几个骨骼（至少是胫骨和大腿）。这将是相当复杂的，并导致不精确的结果。IK 允许我们在胫骨和大腿自我调整的同时直接移动脚。

> **注意：**
>
> Godot 中的 IK 链当前仅在编辑器中工作，而不在运行时工作。它们旨在简化设置关键帧的过程，目前不适用于程序动画等技术。

若要创建 IK 链，请为链选择从端点到基础的骨骼链。例如，要为右腿创建 IK 链，请选择以下选项：

然后为 IK 启用此链。转到“编辑 > 生成 IK 链”。

因此，链的底部将变为*黄色*。

IK 链设置好后，抓住链底部的任何子级或子级（例如脚）并移动它。你会看到链的其余部分随着你调整其位置而调整。

#### 动画提示

以下部分将收集为剪切装备创建动画的提示。有关 Godot 中动画系统如何工作的详细信息，请参见动画功能简介。

##### 设置关键帧并排除属性

当动画编辑器窗口打开时，特殊的上下文元素会出现在顶部工具栏中：

关键点按钮在当前播放头位置为选定对象或骨骼插入位置、旋转和缩放关键帧。

按键左侧的“loc”、“rot”和“scl”切换按钮可修改其功能，允许您指定将为三个属性中的哪一个创建关键帧。

下面举例说明了这是如何有用的：假设您有一个节点，该节点已经有两个关键帧仅为其比例设置动画。您希望将重叠的旋转移动添加到同一节点。旋转运动应该在与已经设置的比例变化不同的时间开始和结束。添加新关键帧时，可以使用切换按钮仅添加旋转信息。这样，可以避免添加不需要的缩放关键帧，因为这会破坏现有的缩放动画。

#### 创建休息姿势

将休息姿势视为默认姿势，当游戏中没有其他姿势处于活动状态时，剪切装备应设置为该姿势。按以下方式创建休息姿势：

1. 确保钻机零件的位置看起来像是“静止”布置。
2. 创建一个新动画，将其重命名为“静止”。
3. 选择装备中的所有节点（框选择应该很好）。
4. 确保工具栏中的“loc”、“rot”和“scl”切换按钮都处于活动状态。
5. 按下按键。将为存储其当前排列的所有选定零件插入钥匙。现在，在游戏中需要时，可以通过播放您创建的“休息”动画来调用此姿势。

#### 仅修改旋转

设置剪切装备的动画时，通常只需要更改节点的旋转。很少使用位置和比例。

因此，在插入密钥时，您可能会发现在大多数情况下只激活“rot”切换很方便：

这将避免为位置和比例创建不需要的动画轨迹。

#### 关键帧 IK 链

编辑 IK 链时，不必选择整个链来添加关键帧。选择链的端点并插入关键帧将自动为链的所有其他部分插入关键帧。

#### 在视觉上将精灵移动到其父对象后面

有时，有必要让节点在动画过程中更改其相对于其父节点的视觉深度。想象一个面对镜头的角色，他从背后拿出一些东西，然后把它举在面前。在该动画过程中，整个手臂和他手中的对象需要更改其相对于角色身体的视觉深度。

为了帮助实现这一点，在所有 Node2D 继承节点上都有一个可设置关键帧的“Behind Parent”属性。规划装备时，请考虑它需要执行的移动，并考虑如何使用“在父节点后面”和/或 RemoteTransform2D 节点。它们提供了重叠的功能。

#### 为多个关键点设置缓和曲线

要同时将同一缓和曲线应用于多个关键帧，请执行以下操作：

1. 选择相关的键。
2. 单击动画面板右下角的铅笔图标。这将打开转换编辑器。
3. 在过渡编辑器中，单击所需的曲线以应用它。

#### 2D 骨骼变形

骨骼变形可以用来增强剪切装备，使单个部件有机变形（例如，当昆虫角色行走时，天线会摆动）。

此过程在单独的教程中进行了描述。

### 2D 骨骼

#### 简介

在使用 3D 时，骨骼变形对角色和生物来说很常见，大多数 3D 建模应用程序都支持它。对于 2D，由于该功能不常使用，很难找到专门用于此功能的主流软件。

一种选择是在 Spine 或 Dragonbones 等第三方软件中创建动画。不过，从 Godot 3.1 开始，该功能是内置的。

为什么要直接在 Godot 中制作骨骼动画？答案是它有很多优点：

- 更好地与引擎集成，从而减少从外部工具导入和编辑的麻烦。
- 能够控制动画中的粒子系统、着色器、声音、调用脚本、颜色、透明度等。
- Godot 内置的骨架系统非常高效，专为性能而设计。

然后，以下教程将解释二维骨骼变形。

#### 设置

> **参考：**
>
> 在开始之前，我们建议您完成“剪切”动画教程，以大致了解 Godot 中的动画设置。

在本教程中，我们将使用单个图像来构建我们的角色。从 gBot_pieces.png 下载或保存下面的图像。

还建议下载最终的角色图像 gBot_complete.png，以便为将不同的片段组合在一起提供良好的参考。

#### 创建多边形

为模型创建一个新场景（如果它将是一个动画角色，则可能需要使用 `CharacterBody2D`）。为了便于使用，将创建一个空的二维节点作为多边形的根。

从 `Polygon2D` 节点开始。现在没有必要将其放置在场景中的任何位置，只需如下创建即可：

选择它并将纹理与之前下载的角色片段一起指定：

不建议直接绘制多边形。相反，打开多边形的“UV”对话框：

转到*点*模式，选择铅笔并围绕所需的部分绘制多边形：

复制多边形节点并为其指定一个正确的名称。然后，再次进入“UV”对话框，并将旧多边形替换为新的所需片段中的另一个多边形。

当您复制节点并且下一个片段具有相似的形状时，您可以编辑上一个多边形，而不是绘制新的多边形。

移动多边形后，请记住通过在多边形 2D UV 编辑器中选择“**编辑>将多边形复制到 UV**” 来更新 UV。

继续这样做，直到映射完所有部分。

您会注意到，节点的片段显示在与原始纹理中相同的布局中。这是因为默认情况下，绘制多边形时，UV和点是相同的。

重新排列片段并构建角色。这应该很快。没有必要改变枢轴，所以不必麻烦确保每个零件的旋转枢轴是正确的；你可以暂时离开他们。

啊，这些片段的视觉顺序还不正确，因为有些片段覆盖了错误的片段。重新排列节点的顺序以解决此问题：

这下你懂了！这肯定比剪切教程中要容易得多。

#### 创建骨架

创建 `Skeleton2D` 节点作为根节点的子节点。这将是我们骨架的基础：

创建 `Bone2D` 节点作为骨骼的子节点。把它放在臀部（通常骨骼从这里开始）。骨骼将指向右侧，但您现在可以忽略这一点。

继续在层次中创建骨骼并相应地命名它们。

在这个链的末端，会有一个*颚*节点。它又很短，指向右边。这对于没有孩子的骨骼来说是正常的。可以使用检查器中的特性更改尖端骨骼的长度：

在这种情况下，我们不需要旋转骨骼（巧合的是，下巴正好指向精灵中），但如果需要，请随时执行。同样，这只适用于尖端骨骼，因为有子节点的节点通常不需要长度或特定的旋转。

继续构建整个骨架：

你会注意到，所有的骨骼都会发出一个关于错过休息姿势的恼人警告。这意味着是时候设定一个了。转到*骨架*节点并创建静止姿势。此姿势是默认姿势，您可以随时返回（这对于设置动画非常方便）：

警告将消失。如果修改骨骼（添加/移除骨骼），则需要再次设置静止姿势。

#### 变形多边形

选择先前创建的多边形，并将骨架节点指定给其 `skeleton` 特性。这将确保它们最终能够被它变形。

单击上面高亮显示的特性，然后选择骨架节点：

再次打开多边形的UV编辑器，然后转到“*骨骼*”区域。

您将无法绘制权重。为此，需要将骨架中的骨骼列表与多边形同步。此步骤仅手动执行一次（除非通过添加/删除/重命名骨骼来修改骨骼）。它可以确保装配信息保留在多边形中，即使骨骼节点意外丢失或骨骼被修改。按下“将骨骼同步到多边形”按钮以同步列表。

骨骼列表将自动显示。默认情况下，多边形中的任何一个都没有指定权重。选择要指定权重的骨骼并绘制它们：

白色的点指定了完整的权重，而黑色的点不受骨骼的影响。如果多个骨骼的同一点被绘制为白色，则影响将分布在它们之间（因此通常不需要在两者之间使用阴影，除非您想打磨弯曲效果）。

绘制权重后，设置骨骼（而不是多边形！）的动画将具有相应修改和弯曲多边形的所需效果。由于您只需要在这种方法中设置骨骼动画，因此工作变得容易多了！

但这并不全是玫瑰。尝试设置弯曲多边形的骨骼的动画通常会产生意想不到的结果：

之所以会发生这种情况，是因为 Godot 在绘制多边形时会生成连接点的内部三角形。它们并不总是像你期望的那样弯曲。若要解决此问题，需要在几何体中设置提示，以明确期望几何体如何变形。

#### 内部顶点

再次打开每个骨骼的UV菜单，然后转到“*点*”区域。在希望几何体弯曲的区域中添加一些内部顶点：

现在，转到“*多边形*”部分，用更多细节重新绘制自己的多边形。想象一下，当多边形弯曲时，你需要确保它们变形的可能性最小，所以尝试一下，找到正确的设置。

开始绘制后，原始多边形将消失，您可以自由创建自己的多边形：

虽然您可能希望对三角形的走向进行更细粒度的控制，但这种细节量通常是可以的。自己试验，直到得到你喜欢的结果。

**注意：**不要忘记，您新添加的内部顶点也需要权重绘制！再次转到“*骨骼*”区域，将它们指定给右侧骨骼。

一旦你做好了准备，你会得到更好的结果：

### 使用 AnimationTree

#### 简介

有了 AnimationPlayer，Godot 拥有任何游戏引擎中最灵活的动画系统之一。在任何节点或资源中为几乎任何属性设置动画的能力，以及具有专用变换、bezier、函数调用、音频和子动画轨迹的能力，都是非常独特的。

但是，通过 `AnimationPlayer` 混合这些动画的支持相对有限，因为只能设置固定的交叉渐变过渡时间。

AnimationTree 是 Godot 3.1 中引入的一个新节点，用于处理高级转换。它取代了古老的 `AnimationTreePlayer`，同时增加了大量的功能和灵活性。

#### 创建动画树

在开始之前，必须明确 `AnimationTree` 节点不包含其自己的动画。相反，它使用包含在 `AnimationPlayer` 节点中的动画。这样，您可以像往常一样编辑动画（或从 3D 场景导入动画），然后使用此额外节点控制播放。

使用 `AnimationTree` 最常见的方法是在 3D 场景中。当从 3D 交换格式导入场景时，它们通常会内置动画（导入时可以是多个动画，也可以是从一个大动画中分割出来的）。最后，导入的 Godot 场景将包含 `AnimationPlayer` 节点中的动画。

由于很少在 Godot 中直接使用导入的场景（它们要么是实例化的，要么是从中继承的），因此可以将 `AnimationTree` 节点放置在包含导入场景的新场景中。然后，将 `AnimationTree` 节点指向在导入场景中创建的 `AnimationPlayer`。

以下是第三人称射击游戏演示中的操作方法，供参考：

为玩家创建了一个以 `CharacterBody3D` 为根的新场景。在这个场景中，原始 `.dae`（Collada）文件被实例化，并创建了一个 `AnimationTree` 节点。

#### 创建树

`AnimationTree` 中可以使用三种主要类型的节点：

1. 动画节点，引用链接的 `AnimationPlayer` 中的动画。
2. 动画根节点，用于混合子节点。
3. 动画混合节点，在 `AnimationNodeBlendTree` 中通过多个输入端口作为单个图形混合使用。

要在 `AnimationTree` 中设置根节点，可以使用以下几种类型：

- `AnimationNodeAnimation`：从列表中选择一个动画并播放它。这是最简单的根节点，通常不会直接用作根。
- `AnimationNodeBlendTree`：包含许多混合类型的节点，如 mix、blend2、blend3、one-shot 等。这是最常用的根之一。
- `AnimationNodeStateMachine`：包含多个根节点作为图中的子节点。每个节点都被用作一个状态，并提供多种功能在状态之间交替。
- `AnimationNodeBlendSpace2D`: 允许在 2D 混合空间中放置根节点。控制 2D 中的混合位置以在多个动画之间混合。
- `AnimationNodeBlendSpace1D`：上述（1D）的简化版本。

#### 混合树

`AnimationNodeBlendTree` 可以包含用于混合的根节点和常规节点。节点从菜单添加到图形中：

默认情况下，所有混合树都包含一个 `Output` 节点，并且必须将某些内容连接到该节点才能播放动画。

测试此功能的最简单方法是将 `Animation` 节点直接连接到该节点：

这将简单地播放动画。确保 `AnimationTree` 处于活动状态，以便实际发生某些事情。

以下是可用节点的简短描述：

##### Blend2 / Blend3

这些节点将通过用户指定的混合值在两个或三个输入之间混合：

对于更复杂的混合，建议使用混合空间。

混合也可以使用过滤器，即您可以单独控制哪些轨迹通过混合功能。这对于将动画层叠在一起非常有用。

##### OneShot

此节点将执行子动画，并在完成后返回。淡入淡出的混合时间以及过滤器都可以自定义。

设置请求并更改动画播放后，单镜头节点会通过将其 `request` 值设置为 `AnimationNodeOneShot.one_shot_request_NONE` 来自动清除下一个进程帧上的请求。

```python
# Play child animation connected to "shot" port.
animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
# Alternative syntax (same result as above).
animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

# Abort child animation connected to "shot" port.
animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
# Alternative syntax (same result as above).
animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT

# Get current state (read-only).
animation_tree.get("parameters/OneShot/active"))
# Alternative syntax (same result as above).
animation_tree["parameters/OneShot/active"]
```

##### TimeSeek

此节点可用于使查找命令发生在动画图的任何子级上。使用此节点类型可以从 `AnimationNodeBlendTree` 的开始或某个播放位置播放 `Animation`。

设置时间并更改动画播放后，通过将 `seek_request` 值设置为 `-1.0`，搜索节点在下一个进程帧上自动进入睡眠模式。

```python
# Play child animation from the start.
animation_tree.set("parameters/TimeSeek/seek_request", 0.0)
# Alternative syntax (same result as above).
animation_tree["parameters/TimeSeek/seek_request"] = 0.0

# Play child animation from 12 second timestamp.
animation_tree.set("parameters/TimeSeek/seek_request", 12.0)
# Alternative syntax (same result as above).
animation_tree["parameters/TimeSeek/seek_request"] = 12.0
```

##### TimeScale

允许通过 *scale* 参数缩放连接到 *in* 输入的动画的速度（或反转动画）。将 *scale* 设置为 0 将暂停动画。

##### Transition

非常简单的状态机（当您不想处理 `StateMachine` 节点时）。动画可以连接到输出，并且可以指定转换时间。设置请求并更改动画播放后，转换节点会通过将其 `transition_request` 值设置为空字符串（`""`），自动清除下一个进程帧上的请求。

```python
# Play child animation connected to "state_2" port.
animation_tree.set("parameters/Transition/transition_request", "state_2")
# Alternative syntax (same result as above).
animation_tree["parameters/Transition/transition_request"] = "state_2"

# Get current state name (read-only).
animation_tree.get("parameters/Transition/current_state")
# Alternative syntax (same result as above).
animation_tree["parameters/Transition/current_state"]

# Get current state index (read-only).
animation_tree.get("parameters/Transition/current_index"))
# Alternative syntax (same result as above).
animation_tree["parameters/Transition/current_index"]
```

##### BlendSpace2D

`BlendSpace2D` 是一个用于在二维中进行高级混合的节点。将点添加到二维空间，然后可以控制位置以确定混合：

可以控制 X 和 Y 的范围（并为方便起见标记）。默认情况下，点可以放置在任何位置（在坐标系上单击鼠标右键或使用“*添加点*”按钮），三角形将使用 Delaunay 自动生成。

也可以通过禁用*自动三角形*选项手动绘制三角形，尽管这很少是必要的：

最后，可以更改混合模式。默认情况下，通过在最近的三角形内插值来进行混合。处理2D动画（逐帧）时，可能需要切换到“*离散*”模式。或者，如果您想在离散动画之间切换时保持当前播放位置，则有一个 *Carry* 模式。此模式可以在“*混合*”菜单中更改：

##### BlendSpace1D

这类似于二维混合空间，但在一个维度上（因此不需要三角形）。

##### StateMachine

此节点充当状态机，根节点作为状态。根节点可以通过线路创建和连接。状态通过*转换*连接，转换是具有特殊属性的连接。转换是单向的，但两个可以用于双向连接。

过渡有多种类型：

- *立即*：将立即切换到下一个状态。当前状态将结束并融入新状态的开始。
- *同步*：会立即切换到下一个状态，但会将新状态搜索到旧状态的播放位置。
- *结束时*：将等待当前状态播放结束，然后切换到下一个状态动画的开始。

转换还有一些特性。单击任何转换，它将显示在检查器停靠区中：

- 切换模式是转换类型（见上文），可以在此处创建后进行修改。
- 达到此状态时，“*自动前进*”将自动打开转换。这在“结束”开关模式下效果最佳。
- 设置此条件时，“*前进条件*”将启用自动前进。这是一个自定义文本字段，可以用变量名填充。该变量可以从代码中修改（稍后将对此进行详细介绍）。
- *Xfade 时间*是在该状态和下一状态之间交叉淡入淡出的时间。
- *Priority* 与代码中的 `travel()` 函数一起使用（稍后会详细介绍）。当通过树时，优先选择较低优先级的转换。
- *Disabled*（禁用）切换禁用此转换（禁用时，将不会在行驶或自动前进过程中使用）。

#### 为了更好地混合

在 Godot 4.0+ 中，为了使混合结果具有确定性（可重复且始终一致），混合特性值必须具有特定的初始值。例如，在要混合的两个动画的情况下，如果一个动画具有属性轨迹，而另一个没有，则计算混合动画时，就好像后一个动画的属性轨迹具有初始值一样。

对 Skeleton3D 骨骼使用位置/旋转/缩放 3D 轨迹时，初始值为 Bone Rest。对于其他属性，初始值是 `0`，如果轨迹出现在 `RESET` 动画中，则使用其第一个关键帧的值。

例如，以下 AnimationPlayer 有两个动画，但其中一个动画缺少“位置”的“属性”轨迹。

这意味着缺少将这些位置视为 `Vector2(0，0)` 的动画。

可以通过将“位置”的“特性”轨迹作为初始值添加到 `RESET` 动画中来解决此问题。

> **注意：**
>
> 请注意，`RESET` 动画的存在是为了定义最初加载对象时的默认姿势。假设它只有一帧，并且不期望使用时间线来回放。

还请记住，“旋转 3D”轨迹和“属性”轨迹用于将“插值类型”设置为“线性角度”或“立方角度”的 2D 旋转，将防止作为混合动画从初始值旋转超过 180 度。

这对于 Skeleton3D 在混合动画时防止骨骼穿透身体非常有用。因此，Skeleton3D 的 Bone Rest 值应尽可能接近可移动范围的中点。**这意味着，对于人形模型，最好以 T 形姿势导入它们。**

您可以看到，“骨骼静止”中的最短旋转路径优先排列，而不是动画之间最短的旋转路径。

如果需要通过混合动画将 Skeleton3D 本身旋转 180 度以上以进行移动，则可以使用“根运动”。

#### 根部运动

使用 3D 动画时，动画师常用的一种技术是使用根骨骼为骨骼的其余部分提供运动。这允许以台阶与下面的地板实际匹配的方式为角色设置动画。它还允许在电影拍摄过程中与对象进行精确的交互。

在 Godot 中播放动画时，可以选择此骨骼作为*根运动轨迹*。这样做将在视觉上取消骨骼变换（动画将保持原位）。

然后，可以通过 AnimationTree API 检索实际运动作为变换：

```python
# Get the motion delta.
animation_tree.get_root_motion_position()
animation_tree.get_root_motion_rotation()
animation_tree.get_root_motion_scale()

# Get the actual blended value of the animation.
animation_tree.get_root_motion_position_accumulator()
animation_tree.get_root_motion_rotation_accumulator()
animation_tree.get_root_motion_scale_accumulator()
```

这可以提供给 CharacterBody3D.move_and_slide 等函数来控制角色移动。

还有一个工具节点 `RootMotionView`，可以放置在场景中，并将作为角色和动画的自定义地板（游戏过程中默认禁用此节点）。

#### 从代码进行控制

在构建并预览了树之后，剩下的唯一问题是“如何通过代码控制所有这些？”。

请记住，动画节点只是资源，因此，它们在使用它们的所有实例之间共享。直接在节点中设置值将影响使用此 `AnimationTree` 的场景的所有实例。这通常是不可取的，但也有一些很酷的用例，例如，您可以复制和粘贴动画树的部分，或者在不同的动画树中重用具有复杂布局（如状态机或混合空间）的节点。

实际动画数据包含在 `AnimationTree` 节点中，并可通过属性进行访问。检查 `AnimationTree` 节点的“参数”部分，查看可以实时修改的所有参数：

这很方便，因为它可以从 `AnimationPlayer` 甚至 `AnimationTree` 本身为它们设置动画，从而实现非常复杂的动画逻辑。

若要从代码中修改这些值，必须获取属性路径。这可以通过将鼠标悬停在任何参数上轻松完成：

这允许设置或读取它们：

```python
animation_tree.set("parameters/eye_blend/blend_amount", 1.0)
# Simpler alternative form:
animation_tree["parameters/eye_blend/blend_amount"] = 1.0
```

#### 状态机行程

Godot 的 `StateMachine` 实现中的一个很好的特性是能够旅行。可以指示图形从当前状态转到另一个状态，同时访问所有中间状态。这是通过 A* 算法完成的。如果没有从当前状态开始到目标状态结束的转换路径，则图形将传送到目标状态。

若要使用旅行功能，应首先从 `AnimationTree` 节点检索 [AnimationNodeStateMachinePlayback](https://docs.godotengine.org/en/stable/classes/class_animationnodestatemachineplayback.html#class-animationnodestatemachineplayback) 对象（将其导出为属性）。

```python
var state_machine = animation_tree["parameters/playback"]
```

检索后，可以通过调用它提供的众多函数之一来使用它：

```python
state_machine.travel("SomeState")
```

您必须先运行状态机，然后才能旅行。请确保调用 `start()` 或选择要在**加载时自动播放**的节点。

### 播放视频

Godot 支持使用 VideoStreamPlayer 节点进行视频播放。

#### 支持的播放格式

核心中唯一支持的格式是 **Ogg Theora**（不要与 Ogg Vorbis 音频混淆）。扩展可以带来对其他格式的支持，但截至 2022 年 7 月，还没有这样的扩展。

H.264 和 H.265 不能在核心 Godot 中得到支持，因为它们都受到软件专利的阻碍。AV1 是免费的，但它在 CPU 上解码仍然很慢，而且硬件解码支持还不能在所有使用的 GPU 上获得。

Godot3.x 在核心中支持 WebM，但在 4.0 中删除了对它的支持，因为它太 bug，难以维护。

> **注意：**
>
> 您可能会找到扩展名为 `.ogg` 或 `.ogx` 的视频，这是 Ogg 容器中数据的通用扩展。
>
> 将这些文件扩展名重命名为 `.ogv` *可能*会允许在 Godot 中导入视频。然而，并非所有扩展名为 `.ogg` 或 `.ogx` 的文件都是视频，其中一些文件可能只包含音频。

#### 设置 VideoStreamPlayer

1. 使用“创建新节点”对话框创建 VideoStreamPlayer 节点。
2. 在场景树停靠中选择 VideoStreamPlayer 节点，转到检查器并在 Stream 属性中加载 `.ogv` 文件。
   - 如果你还没有 Ogg Theora 格式的视频，请跳转到推荐的 Theora 编码设置。
3. 如果希望在加载场景后立即播放视频，请在检查器中选中“**自动播放**”。如果没有，请禁用“**自动播放**”，并在脚本中的 VideoStreamPlayer 节点上调用 `play()` 以在需要时开始播放。

##### 处理大小调整和不同纵横比

默认情况下，在 Godot 4.0 中，VideoStreamPlayer 将自动调整大小以匹配视频的分辨率。您可以通过在 VideoStreamPlayer 节点上启用**展开**（Expand），使其遵循通常的控制大小。

要根据窗口大小调整 VideoStreamPlayer 节点的大小，请使用 2D 编辑器视口顶部的“**布局**”菜单调整锚点。然而，这种设置可能不够强大，无法处理所有用例，例如在不扭曲视频的情况下播放全屏视频（而是在边缘留出空白）。为了获得更多的控制，您可以使用 AspectRatioContainer 节点，该节点旨在处理此类用例：

添加一个 AspectRatioContainer 节点。请确保它不是任何其他容器节点的子节点。选择 AspectRatioContainer 节点，然后将其在 2D 编辑器顶部的 Layout 设置为 **Full Rect**。在 AspectRatioContainer 节点中设置 **Ratio** 以匹配视频的纵横比。您可以在检查器中使用数学公式来帮助自己。记住将其中一个操作数设为浮点。否则，除法的结果将始终是一个整数。

配置完 AspectRatioContainer 后，将 VideoStreamPlayer 节点重新设置为 AspectRatioContainer 节点的子节点。确保在 VideoStreamPlayer 上禁用了**扩展**。您的视频现在应该自动缩放以适应整个屏幕，同时避免失真。

> **参考：**
>
> 有关在项目中支持多纵横比的更多提示，请参阅多分辨率。

##### 在三维曲面上显示视频

使用 VideoStreamPlayer 节点作为 SubViewport 节点的子节点，可以在三维曲面上显示任何二维节点。例如，当逐帧动画需要太多内存时，这可以用于显示动画广告牌。

这可以通过以下步骤来完成：

1. 创建 [SubViewport](https://docs.godotengine.org/en/stable/classes/class_subviewport.html#class-subviewport) 节点。设置其大小以匹配视频的像素大小。
2. 创建 VideoStreamPlayer 节点*作为 SubViewport 节点的子节点*，并在其中指定视频路径。确保已禁用“**展开**”，并在需要时启用“**自动播放**”。
3. 在其“网格”属性中创建具有 PlaneMesh 或 QuadMesh 资源的 MeshInstance3D 节点。调整网格大小以匹配视频的纵横比（否则，它将显示扭曲）。
4. 在 GeometryInstance3D 区域的“材质替代”特性中创建新的 StandardMaterial3D 资源。
5. 在 StandardMaterial3D 的“资源”部分（底部）中启用“**本地到场景**”。这是必需的，然后才能在“视口纹理”(ViewportTexture)的“反照率纹理”(Albedo Texture)属性中使用该纹理。
6. 在 StandardMaterial3D 中，将“**Albedo > Texture**”特性设定为“**New ViewportTexture**”。单击新资源以编辑该资源，然后在 **Viewport Path**（视口路径）特性中指定 SubViewport 节点的路径。
7. 在 StandardMaterial3D 中启用 **Albedo Texture Force sRGB**（阿尔伯多纹理力sRGB）以防止颜色被洗掉。
8. 如果广告牌应该发射自己的灯光，请将“**着色模式**”设定为“**未着色**”以提高渲染性能。

请参阅在 3D 演示中使用视口和 GUI，以了解有关设置的更多信息。

#### 视频解码条件和推荐分辨率

视频解码是在 CPU 上执行的，因为 GPU 没有用于解码 Theora 视频的硬件加速。现代桌面 CPU 可以以 1440p@60 FPS 或更高的速度解码 Ogg Theora 视频，但低端移动 CPU 可能难以处理高分辨率视频。

为了确保您的视频在各种硬件上顺利解码：

- 在为桌面平台开发游戏时，建议最多以 1080p 编码（最好是 30 FPS）。大多数人仍在使用 1080p 或更低分辨率的显示器，因此编码更高分辨率的视频可能不值得增加文件大小和 CPU 要求。
- 当为移动或网络平台开发游戏时，建议最多以 720p 编码（最好以 30 FPS 甚至更低的速度）。移动设备上 720p 和 1080p 视频之间的视觉差异通常不那么明显。

#### 播放限制

目前在 Godot 中实现视频播放有几个限制：

- 不支持将视频搜索到某一点。
- 不支持更改播放速度。VideoStreamPlayer 也不会遵循 Engine.time_scale。
- 不支持循环，但您可以将 VideoStreamPlayer 的完成信号连接到再次播放视频的函数。
- 不支持从URL流式传输视频。

#### 建议的 Theora 编码设置

一句话的建议是**避免依赖内置的 Ogg Theora 导出器**（大多数时候）。您可能希望使用外部程序对视频进行编码的原因有两个：

- 一些程序，如 Blender 可以渲染到 Ogg Theora。然而，按照今天的标准，默认的质量预设通常非常低。您可以增加正在使用的软件中的质量选项，但您可能会发现输出质量仍不理想（考虑到文件大小的增加）。这通常意味着软件只支持按恒定比特率（CBR）编码，而不支持按可变比特率（VBR）编码。在大多数情况下，VBR编码应该是优选的，因为它提供了更好的质量与文件大小之比。
- 其他一些程序根本无法呈现给 Ogg Theora。

在这种情况下，您可以将视频渲染为中等质量的格式（例如高比特率 H.264 视频），然后将其重新编码为 Ogg Theora。理想情况下，您应该使用无损或未压缩格式作为中间格式，以最大限度地提高输出 Ogg Theora 视频的质量，但这可能需要大量磁盘空间。

HandBrake（GUI）和 FFmpeg（CLI）是用于此目的的流行开源工具。FFmpeg 有一个更陡峭的学习曲线，但它更强大。

以下是将 MP4 视频转换为 Ogg Theora 的示例 FFmpeg 命令。由于 FFmpeg 支持许多输入格式，您应该能够将以下命令用于几乎任何输入视频格式（AVI、MOV、WebM…）。

> **注意：**
>
> 请确保您的 FFmpeg 副本是使用 libthera 和 libvorbis 支持编译的。您可以在没有任何参数的情况下运行 `ffmpeg`，然后查看命令输出中的 `configuration:` 行来检查这一点。

##### 平衡质量和文件大小

**视频质量级别**（-q:v）必须介于 `1` 和 `10` 之间。质量 `6` 是质量和文件大小之间的一个很好的折衷方案。如果以高分辨率（如 1440p 或 4K）进行编码，则可能需要将 `-q:v` 减小到 `5` 以保持文件大小合理。由于 1440p 或 4K 视频的像素密度更高，因此与低分辨率视频相比，高分辨率下的低质量预设看起来同样好或更好。

**音频质量级别**（-q:a）必须介于 `-1` 和 `10`之间。质量 `6` 提供了质量和文件大小之间的良好折衷。与视频质量相比，提高音频质量并不会增加输出文件的大小。因此，如果你想要尽可能干净的音频，你可以将其增加到 `9`，以获得*感知无损*的音频。如果您的输入文件已经使用有损音频压缩，这一点尤其有价值。更高质量的音频确实会增加解码器的 CPU 使用量，因此在高系统负载的情况下可能会导致音频丢失。有关 Ogg Vorbis 音频质量预设及其各自可变比特率的列表，请参阅本页。

##### FFmpeg：在保留原始视频分辨率的同时进行转换

以下命令转换视频，同时保持其原始分辨率。视频和音频的比特率是可变的，以最大限度地提高质量，同时节省视频/音频中不需要高比特率的部分（如静态场景）的空间。

```shell
ffmpeg -i input.mp4 -q:v 6 -q:a 6 output.ogv
```

##### FFmpeg：调整视频大小，然后进行转换

以下命令将视频的大小调整为 720 像素高（720p），同时保留其现有的纵横比。如果以高于 720p 的分辨率记录源，这有助于显著减小文件大小：

```shell
ffmpeg -i input.mp4 -vf "scale=-1:720" -q:v 6 -q:a 6 output.ogv
```

### 创建影片

Godot 可以录制任何 2D 或 3D 项目的**非实时**视频和音频。这种录制也称为*离线渲染*。在许多情况下，这是有用的：

- 录制游戏预告片以供宣传使用。
- 录制将在最终游戏中显示为预先录制的视频的过场。这允许使用更高质量的设置（以文件大小为代价），而不考虑播放器的硬件。
- 记录按程序生成的动画或动作设计。在视频录制过程中，用户交互仍然是可能的，音频也可以包括在内（尽管在录制视频时你听不到）。
- 比较动画场景中图形设置、着色器或渲染技术的视觉输出。

借助 Godot 的动画功能，如 AnimationPlayer 节点、Tweeners、粒子和着色器，它可以有效地用于创建任何类型的 2D 和 3D 动画（以及静态图像）。

如果你已经习惯了 Godot 的工作流程，那么与 Blender 相比，使用 Godot 进行视频渲染可能会让你的工作效率更高。也就是说，为非实时用途设计的渲染器，如 Cycles 和 Eevee，可以产生更好的视觉效果（以更长的渲染时间为代价）。

与实时视频录制相比，非实时录制的一些优点包括：

- 无论硬件的功能如何，都可以使用任何图形设置（包括要求极高的设置）。输出视频将始终具有完美的帧节奏；它永远不会出现掉帧或口吃。更快的硬件将允许您在更短的时间内渲染给定的动画，但视觉输出保持不变。
- 以比屏幕分辨率更高的分辨率渲染，而不必依赖 NVIDIA 的动态超分辨率或 AMD 的虚拟超分辨率等特定于驱动程序的工具。
- 以高于视频目标帧速率的帧速率渲染，然后进行后期处理以生成高质量的运动模糊。这也使在多个帧上聚合的效果（如时间抗锯齿、SDFGI 和体积雾）看起来更好。

> **警告：**
>
> **此功能不是为在游戏过程中捕捉实时镜头而设计的。**
>
> 玩家应该使用 OBS Studio 或 SimpleScreenRecorder 之类的东西来录制游戏视频，因为他们在拦截合成器方面比 Godot 在本地使用 Vulkan 或 OpenGL 时做得更好。
>
> 也就是说，如果你的游戏在拍摄时以接近实时的速度运行，你仍然可以使用这一功能（但由于声音直接保存到视频文件中，因此无法播放声音）。

#### 启用影音制作模式

要启用影音制作模式，请在运行项目*之前*单击编辑器右上角的“电影卷轴”按钮：

启用影音制作模式时，图标将获得与强调色匹配的背景：

编辑器退出时，影音制作状态**不会**持续，因此如果需要，必须在重新启动编辑器后重新启用影音制作模式。

> **注意：**
>
> 在重新启动项目之前，在运行项目时切换影音制作模式不会有任何效果。

在您可以通过运行项目录制视频之前，您仍然需要配置输出文件路径。可以为“项目设置”中的所有场景设置此路径：

或者，可以通过将名为 `movie_file` 的字符串元数据添加到场景的**根节点**，按每个场景设置输出文件路径。仅当主场景设置为有问题的场景时，或通过按 `F6`（macOS 上的 `Cmd + R`）直接运行场景时，才使用此选项。

项目设置或元数据中指定的路径可以是绝对路径，也可以是相对于项目根的路径。

配置并启用影音制作模式后，从编辑器运行项目时将自动使用该模式。

##### 命令行用法

影音制作也可以从命令行启用：

```shell
godot --path /path/to/your_project --write-movie output.avi
```

如果输出路径是相对的，那么它是**相对于项目文件夹的**，而不是当前工作目录的。在上面的示例中，文件将被写入 `/path/to/your_project/output.avi`。此行为类似于 `--export` 命令行参数。

由于影音制作的输出分辨率是由视口大小设置的，因此如果项目使用 `disabled` 或 `canvas_items` 拉伸模式，则可以在启动时调整窗口大小以覆盖它：

```shell
godot --path /path/to/your_project --write-movie output.avi --resolution 1280x720
```

请注意，窗口大小由显示器的分辨率限制。如果需要以高于屏幕分辨率的分辨率录制视频，请参见以高于屏幕决议的分辨率渲染。

录制 FPS 也可以在命令行上覆盖，而无需编辑“项目设置”：

```shell
godot --path /path/to/your_project --write-movie output.avi --fixed-fps 30
```

> **注意：**
>
> `--write-movie` 和 `--fixed-fps` 命令行参数在导出的项目中都可用。项目运行时无法切换影音制作模式，但您可以使用 OS.execute() 方法运行导出项目的第二个实例，该实例将录制视频文件。

#### 选择输出格式

输出格式由 MovieWriter 类提供。Godot 有 2 个内置 MovieWriters，更多可以通过扩展实现：

##### AVI（推荐）

带有 MJPEG 的 AVI 容器，用于视频和未压缩音频。具有有损视频压缩功能，可实现中等文件大小和快速编码。可以通过更改**“编辑器” > “电影编写器” > “MJPEG 质量”**来调整有损压缩质量。

生成的文件可以在大多数视频播放器中查看，但必须将其转换为另一种格式才能在网络上查看，或者由 Godot 使用 VideoStreamPlayer 节点进行查看。MJPEG 不支持透明度。AVI 输出目前被限制为大小最多为 4GB 的文件。

若要使用AVI，请在**“编辑器” > “影音编写器” > “电影文件”**项目设置中指定要创建的 `.avi` 文件的路径。

##### PNG

PNG 图像序列用于视频，WAV 用于音频。以大文件大小和慢速编码为代价，提供无损视频压缩功能。这是为了在录制后使用外部工具编码为视频文件。

支持透明度，但根视口必须将其 `transparent_bg` 属性设置为 `true`，透明度才能在输出图像上可见。这可以通过启用“**渲染>透明背景**”高级项目设置来实现。可以选择启用“**显示 > 窗口 > 大小 > 透明**”和“**显示 > 窗 > 每像素透明度 > 启用**”，以允许在录制视频时预览透明度，但不必为输出图像包含透明度而启用它们。

若要使用 PNG，请在**“编辑器” > “影音编写器” > “电影文件”**项目设置中指定要创建的 `.png` 文件。生成的 `.wav` 文件将具有与 `.png` 文件相同的名称（减去扩展名）。

##### 自定义

如果您需要直接编码为不同的格式或通过第三方软件传输流，您可以扩展 MovieWriter 类来创建自己的电影编剧。出于性能原因，这通常应该使用 GDExtension 来完成。

#### 配置

在“项目设置”的**“编辑器” > “影片编写器”**区域中，可以配置几个选项。其中一些只有在启用“项目设置”对话框右上角的**“高级”**切换后才可见。

混合速率Hz：在编写电影时，在录制的音频中使用的音频混合速率。这可能与项目的混合速率不同，但该值必须可被录制的FPS整除，以防止音频随着时间的推移而不同步。
扬声器模式：编写电影时在录制的音频中使用的扬声器模式（立体声、5.1环绕或7.1环绕）。
MJPEG质量：将视频写入AVI文件时使用的JPEG质量，介于0.01和1.0之间（包括0.01和1.0）。更高的质量值会以更大的文件大小为代价产生更好看的输出。建议的质量值介于0.75和0.9之间。即使质量为1.0，JPEG压缩仍有损耗。此设置不影响音频质量，在写入PNG图像序列时会被忽略。
电影文件：电影的输出路径。这可以是绝对的，也可以是相对于项目根的。
禁用V-Sync：如果启用，则在编写电影时请求禁用V-Sync。如果硬件足够快，可以以高于监视器刷新率的帧速率渲染、编码和保存视频，这可以加快视频写入速度。如果操作系统或图形驱动程序在应用程序无法禁用V-Sync的情况下强制V-Sync，则此设置无效。
FPS：输出影片中每秒渲染的帧数。值越高，动画越平滑，代价是渲染时间越长，输出文件大小越大。大多数视频托管平台不支持高于60的FPS值，但您可以使用更高的值来生成运动模糊。

> **注意：**
>
> 使用 `disabled` 或 `2d` 拉伸模式时，输出文件的分辨率由窗口大小设置。确保在启动屏幕结束*之前*调整窗口大小。为此，建议调整“**显示 > 窗口 > 大小 > 窗口宽度覆盖**”和“**窗口高度覆盖**”高级项目设置。
>
> 请参见以高于屏幕分辨率的分辨率渲染。

#### 退出影音制作模式

要安全地退出正在使用影音制作模式的项目，请使用窗口顶部的 X 按钮，或在脚本中调用 `get_tree().quit()`。

**不建议**在运行 Godot 的终端上按 `F8`（在 macOS 上按 `Cmd + .`）或按 `Ctrl + C`，因为这会导致格式不正确的 AVI 文件没有持续时间信息。对于 PNG 图像序列，PNG 图像不会被负面更改，但相关的 WAV 文件仍然缺乏持续时间信息。

一些视频播放器可能仍然能够播放 AVI 或 WAV 文件以及工作视频和音频。但是，使用 AVI 或 WAV 文件的软件（如视频编辑器）可能无法打开该文件。在这种情况下，使用视频转换器程序会有所帮助。

如果使用 AnimationPlayer 控制场景中的“主要动作”（例如摄影机移动），则可以在有问题的 AnimationPlayer 节点上启用**“完成时退出影片”**属性。启用此属性后，当动画播放完毕*且*引擎在影音制作模式下运行时，Godot 将自行退出。请注意，*此属性对循环动画没有影响*。因此，需要确保动画设置为非循环。

#### 使用高质量图形设置

`movie` 要素标记可用于替代特定的项目设置。这对于启用高质量的图形设置非常有用，因为这些设置的速度不够快，无法在硬件上实时运行。请记住，将每个设置设置为最大值仍然会降低电影保存速度，尤其是在以更高分辨率录制时。因此，仍然建议仅在图形设置对输出图像产生有意义的影响时才增加图形设置。

还可以在脚本中查询此功能标记，以提高在环境资源中设置的质量设置。例如，为了进一步改进 SDFGI 细节并减少光泄漏：

```python
extends Node3D

func _ready():
    if OS.has_feature("movie"):
        # When recording a movie, improve SDFGI cell density
        # without decreasing its maximum distance.
        get_viewport().world_3d.environment.sdfgi_min_cell_size *= 0.25
        get_viewport().world_3d.environment.sdfgi_cascades = 8
```

#### 以高于屏幕分辨率的分辨率渲染

通过以 4K 或 8K 等高分辨率进行渲染，可以显著提高整体渲染质量。

> **注意：**
>
> 对于 3D 渲染，Godot 提供了“**渲染 > 缩放 3D > 缩放**”高级项目设置，该设置可以设置为 `1.0` 以上以获得超采样抗锯齿。然后，在视口上绘制三维渲染时会对其进行*下采样*。这提供了一种昂贵但高质量的抗锯齿形式，而不会增加最终输出分辨率。
>
> 首先考虑使用此项目设置，因为与实际提高输出分辨率相比，它可以避免降低电影写入速度和增加输出文件大小。

如果希望以更高的分辨率渲染 2D，或者如果实际需要更高的原始像素输出进行 3D 渲染，可以将分辨率提高到屏幕允许的范围以上。

默认情况下，Godot 在项目中使用 `disabled` 的拉伸模式。如果使用 `disabled` 或 `canvas_items` 拉伸模式，则窗口大小决定输出视频分辨率。

另一方面，如果项目配置为使用 `viewport` 拉伸模式，则视口分辨率决定输出视频分辨率。视口分辨率是使用“**显示 > 窗口 > 大小 > 视口宽度**”和“**视口高度**”项目设置设置的。这可以用于以比屏幕分辨率更高的分辨率渲染视频。

要在录制过程中缩小窗口而不影响输出视频分辨率，可以将“**显示>窗口>大小>窗口宽度覆盖**”和“**窗口高度覆盖**”高级项目设置设置为大于 `0` 的值。

若要仅在录制电影时应用分辨率替代，可以使用 `movie` 功能标记替代这些设置。

#### 后期处理步骤

下面列出了一些常见的后处理步骤。

> **注意：**
>
> 当使用多个后处理步骤时，请尝试在一个 FFmpeg 命令中执行所有步骤。这将通过避免多个有损编码步骤来节省编码时间并提高质量。

##### 将 AVI 视频转换为 MP4

虽然一些平台（如 YouTube）支持直接上传 AVI 文件，但许多其他平台则需要事先进行转换。HandBrake（GUI）和 FFmpeg（CLI）是用于此目的的流行开源工具。FFmpeg 有一个更陡峭的学习曲线，但它更强大。

下面的命令将 AVI 视频转换为具有 15 的恒定速率因子（CRF）的 MP4（H.264）视频。这会产生相对较大的文件，但非常适合对视频进行重新编码以减小其大小的平台（例如大多数视频共享网站）：

```shell
ffmpeg -i input.avi -crf 15 output.mp4
```

要以质量为代价获得较小的文件，请增加上述命令中的 CRF 值。

要获得具有更好大小/质量比的文件（以较慢的编码时间为代价），请在上述命令中的 `-crf 15` 之前添加 `-preset veryslow`。相反，`-preset veryfast` 可以用于以更差的大小/质量比为代价实现更快的编码。

##### 将 PNG 图像序列 + WAV 音频转换为视频

如果您选择录制旁边有 WAV 文件的 PNG 图像序列，则需要将其转换为视频，然后才能在其他地方使用。

Godot 生成的 PNG 图像序列的文件名始终包含 8 位数字，从 0 开始，数字为零。如果指定输出路径 `folder/example.png`，Godot 将在该文件夹中写入 `folder/example00000000.png`、`folder/example00000001.png` 等。音频将保存在 `folder/example.wav` 中。

FPS 是使用 `-r` 参数指定的。它应该与录制过程中指定的 FPS 相匹配。否则，视频将看起来变慢或变快，音频将与视频不同步。

```shell
ffmpeg -r 60 -i input%08d.png -i input.wav -crf 15 output.mp4
```

如果录制的 PNG 图像序列启用了透明度，则需要使用支持存储透明度的视频格式。MP4/H.264 不支持存储透明度，因此您可以使用 WebM/VP9 作为替代方案：

```shell
ffmpeg -r 60 -i input%08d.png -i input.wav -c:v libvpx-vp9 -crf 15 -pix_fmt yuva420p output.webm
```

##### 剪切视频

您可以在录制视频后修剪不想保留的视频部分。例如，要丢弃 12.1 秒之前的所有内容，并在该点之后只保留 5.2 秒的视频：

 ```shell
 ffmpeg -i input.avi -ss 00:00:12.10 -t 00:00:05.20 -crf 15 output.mp4
 ```

剪切视频也可以使用图形用户界面工具 LosslessCut 完成。

##### 调整视频大小

以下命令将视频的大小调整为 1080 像素高（1080p），同时保留其现有的纵横比：

```shell
ffmpeg -i input.avi -vf "scale=-1:1080" -crf 15 output.mp4
```

##### 降低帧速率

以下命令将视频的帧速率更改为 30 FPS，如果输入视频中有更多的原始帧，则会删除一些原始帧：

```shell
ffmpeg -i input.avi -r 30 -crf 15 output.mp4
```

##### 用 FFmpeg 生成累积运动模糊

Godot 没有内置的运动模糊支持，但它仍然可以在录制的视频中创建。

如果以原始帧速率的倍数录制视频，则可以将帧混合在一起，然后降低帧速率以生成具有累积运动模糊的视频。这种运动模糊看起来很好，但生成它可能需要很长时间，因为每秒必须渲染更多的帧（除了用于后处理的时间之外）。

以 240 FPS 的源视频为例，生成 4× 运动模糊并将其输出帧速率降低到 60 FPS：

```shell
ffmpeg -i input.avi -vf "tmix=frames=4, fps=60" -crf 15 output.mp4
```

这也使得在多个帧上收敛的效果（如时间抗锯齿、SDFGI 和体积雾）收敛得更快，因此看起来更好，因为它们能够在给定的时间处理更多的数据。如果希望在不添加运动模糊的情况下获得此好处，请参见降低帧速率。