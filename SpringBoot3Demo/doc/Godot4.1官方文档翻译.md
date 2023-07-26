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

为了设置速度，我们使用实体的 `transform.x`，这是一个指向实体“向前”方向的向量，并将其乘以速度。

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

请注意我们在移动之前进行的 `distance _to()` 检查。如果没有这个测试，实体在到达目标位置时会“抖动”，因为它稍微移动过这个位置并试图向后移动，但移动得太远并重复。

如果您愿意，取消对 `look_at()` 线的注释也会使实体指向其运动方向。

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

## 文件和数据 I/O

### 背景加载

通常，游戏需要异步加载资源。当切换游戏的主场景（例如，进入新级别）时，您可能希望显示一个加载屏幕，其中有一些进展的指示，或者您可能希望在游戏过程中加载额外的资源。

标准加载方法（ResourceLoader.load 或 GDScript 的简单加载）会阻塞线程，使您的游戏在加载资源时看起来没有响应。

解决这一问题的一种方法是使用 `ResourceLoader` 在后台线程中异步加载资源。

#### 使用 ResourceLoader

通常，您使用 ResourceLoader.load_thread_request 对加载路径资源的请求进行排队，然后将其加载到后台的线程中。

您可以使用 ResourceLoader.load_threadd_get_status 检查状态。进度可以通过进度传递一个数组变量来获得，该变量将返回一个包含百分比的单元素数组。

最后，您通过调用 ResourceLoader.load_threadd_get 来检索已加载的资源。

一旦调用 `load_thread_get()`，要么资源在后台完成加载并立即返回，要么加载会像 `load()` 那样在此时阻塞。如果您想保证这不会被阻止，您需要确保在请求加载和检索资源之间有足够的时间，或者您需要手动检查状态。

#### 示例

此示例演示如何在背景中加载场景。我们将有一个按钮按下时生成敌人。敌人将是`Enemy.tscn`，我们将在 `_ready` 上加载它，并在按下时实例化它。路径将是 `"Enemy.tscn"`，位于 `res://Enemy.tscn`.

首先，我们将启动一个请求来加载资源并连接按钮：

```python
const ENEMY_SCENE_PATH : String = "Enemy.tscn"

func _ready():
    ResourceLoader.load_threaded_request(ENEMY_SCENE_PATH)
    self.pressed.connect(_on_button_pressed)
```

现在，按下按钮时将调用 `_on_button_pressed`。这种方法将被用来制造敌人。

```python
func _on_button_pressed(): # Button was pressed
    # Obtain the resource now that we need it
    var enemy_scene = ResourceLoader.load_threaded_get(ENEMY_SCENE_PATH)
    # Instantiate the enemy scene and add it to the current scene
    var enemy = enemy_scene.instantiate()
    add_child(enemy)
```

### Godot 项目中的文件路径

本页介绍文件路径如何在 Godot 项目中工作。您将学习如何使用 `res://` 和 `user://` 符号访问项目中的路径，以及 Godot 在您和用户的系统中存储项目和编辑器文件的位置。

#### 路径分隔符

为了更容易地支持多个平台，Godot 使用了 **UNIX 风格的路径分隔符**（正斜杠 `/`）。这些功能适用于所有平台，**包括 Windows**。

不要在 Godot 中编写 `C:\Projects\Game` 这样的路径，而应该编写 `C:/Projects/Game`。

一些与路径相关的方法也支持 Windows 风格的路径分隔符（后斜杠 `\`），但它们需要加倍（`\\`），因为 `\` 通常用作具有特殊含义的字符的转义符。

这使得使用其他 Windows 应用程序返回的路径成为可能。我们仍然建议在您自己的代码中只使用正向斜杠，以确保一切都能按预期工作。

#### 访问项目文件夹中的文件（`res://`）

Godot 认为任何包含 `project.godot` 文本文件的文件夹中都存在项目，即使该文件为空。包含此文件的文件夹是项目的根文件夹。

您可以通过写入以 `res://` 开头的路径来访问与其相关的任何文件，`res://` 代表资源。例如，您可以使用以下路径访问位于项目根文件夹中代码中的图像文件 `character.png`：`res://character.png`.

#### 访问持久用户数据（`user://`）

要存储持久数据文件，如播放器的保存或设置，您需要使用 `user://` 而不是 `res://` 作为路径的前缀。这是因为当游戏运行时，项目的文件系统可能是只读的。

`user://` 前缀指向用户设备上的另一个目录。与 `res://` 不同，`user://` 指向的目录是自动创建的，并保证可写入，即使在导出的项目中也是如此。

`user://` 文件夹的位置取决于在“项目设置”中配置的内容：

- 默认情况下，`user://` 文件夹是在 Godot 的编辑器数据路径中的 `app_userdata/[project_name]` 文件夹中创建的。这是默认设置，以便原型和测试项目在 Godot 的数据文件夹中保持独立。
- 如果在项目设置中启用了 application/config/use_custom_user_dir，则会在 Godot 的编辑器数据路径旁边创建 `user://` 文件夹，即在应用程序数据的标准位置。
  - 默认情况下，文件夹名称将根据项目名称推断，但可以使用 application/config/custom_user_dir_name 进一步自定义。此路径可以包含路径分隔符，因此您可以使用它，例如，使用 `Studio Name/Game Name` 结构对给定工作室的项目进行分组。

在桌面平台上，`user://` 的实际目录路径为：

| 类型               | 位置                                                         |
| ------------------ | ------------------------------------------------------------ |
| 默认               | Windows: `%APPDATA%\Godot\app_userdata\[project_name]`<br/>macOS: `~/Library/Application Support/Godot/app_userdata/[project_name]`<br/>Linux: `~/.local/share/godot/app_userdata/[project_name]` |
| 自定义文件夹       | Windows: `%APPDATA%\[project_name]`<br/>macOS: `~/Library/Application Support/[project_name]`<br/>Linux: `~/.local/share/[project_name]` |
| 自定义文件夹和名字 | Windows: `%APPDATA%\[custom_user_dir_name]`<br/>macOS: `~/Library/Application Support/[custom_user_dir_name]`<br/>Linux: `~/.local/share/[custom_user_dir_name]` |

`[project_name]` 基于在项目设置中定义的应用程序名称，但您可以使用功能标记在每个平台的基础上覆盖它。

在移动平台上，此路径是项目独有的，出于安全原因，其他应用程序无法访问。

在 HTML5 导出中，`user://` 将通过 IndexedDB 引用存储在设备上的虚拟文件系统。（与主文件系统的交互仍然可以通过 JavaScriptBridge 单例执行。）

#### 将路径转换为绝对路径或“局部”路径

您可以使用 ProjectSettings.globize_path() 转换“本地”路径，如 `res://path/to/file.txt` 到绝对 OS 路径。例如，ProjectSettings.globize_path() 可用于使用 OS.shell_open() 在操作系统文件管理器中打开“本地”路径，因为它只接受本机操作系统路径。

要将绝对操作系统路径转换为以 `res://` 或 `user://` 开头的“本地”路径，请使用 ProjectSettings.localite_path()。这仅适用于指向项目根目录或 `user://` 文件夹中的文件或文件夹的绝对路径。

#### 编辑器数据路径

编辑器对编辑器数据、编辑器设置和缓存使用不同的路径，具体取决于平台。默认情况下，这些路径为：

| 类型       | 位置                                                         |
| ---------- | ------------------------------------------------------------ |
| 编辑器数据 | Windows: `%APPDATA%\Godot\`<br/>macOS: `~/Library/Application Support/Godot/`<br/>Linux: `~/.local/share/godot/` |
| 编辑器设置 | Windows: `%APPDATA%\Godot\`<br/>macOS: `~/Library/Application Support/Godot/`<br/>Linux: `~/.config/godot/` |
| 缓存       | Windows: `%TEMP%\Godot\`<br/>macOS: `~/Library/Caches/Godot/`<br/>Linux: `~/.cache/godot/` |

- **编辑器数据**包含导出模板和项目特定数据。
- **编辑器设置**包含主编辑器设置配置文件以及各种其他特定于用户的自定义设置（编辑器布局、功能配置文件、脚本模板等）。
- **缓存**包含编辑器生成或临时存储的数据。当 Godot 关闭时，可以安全地将其移除。

Godot 在所有平台上都符合 XDG 基本目录规范。可以按照规范覆盖环境变量，以更改编辑器和项目数据路径。

> **注意：**
>
> 如果您使用打包为 Flatpak 的 Godot，编辑器数据路径将位于 `~/.var/app/org.godotengine.Godot/` 中的子文件夹中。

##### 独立模式

如果您创建了一个名为的文件 `._sc_` 或 `_sc_` 在与编辑器二进制文件相同的目录中（或者在 *MacOS/Contents/* 中，对于 MacOS 编辑器 .app 捆绑包），Godot 将启用*自包含模式*。此模式使 Godot 将所有编辑器数据、设置和缓存写入编辑器二进制文件所在目录中名为 `editor_data/` 的目录。您可以使用它来创建编辑器的可移植安装。

Godot 的 Steam 版本默认使用独立模式。

> **注意：**
>
> 导出的项目中还不支持自包含模式。要读取和写入相对于可执行文件路径的文件，请使用 OS.get_executable_path()。请注意，只有当可执行文件位于可写位置（即，**不是** Program files 或其他对普通用户只读的目录）时，在可执行文件路径中写入文件才有效。

### 保存游戏

#### 简介

保存游戏可能很复杂。例如，可能希望跨多个级别存储来自多个对象的信息。高级保存游戏系统应允许提供有关任意数量对象的附加信息。这将允许保存功能随着游戏变得越来越复杂而扩展。

> **注意：**
>
> 如果您希望保存用户配置，可以使用 ConfigFile 类来实现此目的。

> **参考：**
>
> 您可以使用 Saving and Loading（Serialization）演示项目了解保存和加载在实际操作中的工作方式。

#### 识别持久对象

首先，我们应该确定我们想在游戏会话之间保留哪些对象，以及我们想从这些对象中保留哪些信息。在本教程中，我们将使用组来标记和处理要保存的对象，但其他方法当然也是可能的。

我们将首先将要保存的对象添加到“Persist”组中。我们可以通过 GUI 或脚本来实现这一点。让我们使用 GUI 添加相关节点：

一旦完成，当我们需要保存游戏时，我们可以让所有对象保存它们，然后告诉它们使用此脚本保存：

```python
var save_nodes = get_tree().get_nodes_in_group("Persist")
for i in save_nodes:
    # Now, we can call our save function on each node.
```

#### 序列化

下一步是序列化数据。这使得从磁盘读取和存储变得更加容易。在这种情况下，我们假设组 Persist 的每个成员都是一个实例化节点，因此都有一个路径。GDScript 有一个帮助类 JSON 来在字典和字符串之间转换，我们的节点需要包含一个返回这些数据的保存函数。保存功能如下所示：

```python
func save():
    var save_dict = {
        "filename" : get_scene_file_path(),
        "parent" : get_parent().get_path(),
        "pos_x" : position.x, # Vector2 is not supported by JSON
        "pos_y" : position.y,
        "attack" : attack,
        "defense" : defense,
        "current_health" : current_health,
        "max_health" : max_health,
        "damage" : damage,
        "regen" : regen,
        "experience" : experience,
        "tnl" : tnl,
        "level" : level,
        "attack_growth" : attack_growth,
        "defense_growth" : defense_growth,
        "health_growth" : health_growth,
        "is_alive" : is_alive,
        "last_attack" : last_attack
    }
    return save_dict
```

这为我们提供了一个样式为 `{"variable_name": value_of_variable}` 的字典，在加载时会很有用。

#### 保存和读取数据

正如文件系统教程中所述，我们需要打开一个文件，以便对其进行写入或读取。现在我们有了调用组并获取其相关数据的方法，让我们使用类 JSON 将其转换为易于存储的字符串，并将其存储在文件中。这样做可以确保每一行都是自己的对象，因此我们也有一种简单的方法从文件中提取数据。

```python
# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
    var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
    var save_nodes = get_tree().get_nodes_in_group("Persist")
    for node in save_nodes:
        # Check the node is an instanced scene so it can be instanced again during load.
        if node.scene_file_path.is_empty():
            print("persistent node '%s' is not an instanced scene, skipped" % node.name)
            continue

        # Check the node has a save function.
        if !node.has_method("save"):
            print("persistent node '%s' is missing a save() function, skipped" % node.name)
            continue

        # Call the node's save function.
        var node_data = node.call("save")

        # JSON provides a static method to serialized JSON string.
        var json_string = JSON.stringify(node_data)

        # Store the save dictionary as a new line in the save file.
        save_game.store_line(json_string)
```

游戏已保存！现在，为了加载，我们将读取每一行。使用 parse 方法将 JSON 字符串读回字典，然后对 dict 进行迭代以读取我们的值。但我们需要首先创建对象，然后使用文件名和父值来实现这一点。以下是我们的加载函数：

```python
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
    if not FileAccess.file_exists("user://savegame.save"):
        return # Error! We don't have a save to load.

    # We need to revert the game state so we're not cloning objects
    # during loading. This will vary wildly depending on the needs of a
    # project, so take care with this step.
    # For our example, we will accomplish this by deleting saveable objects.
    var save_nodes = get_tree().get_nodes_in_group("Persist")
    for i in save_nodes:
        i.queue_free()

    # Load the file line by line and process that dictionary to restore
    # the object it represents.
    var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
    while save_game.get_position() < save_game.get_length():
        var json_string = save_game.get_line()

        # Creates the helper class to interact with JSON
        var json = JSON.new()

        # Check if there is any error while parsing the JSON string, skip in case of failure
        var parse_result = json.parse(json_string)
        if not parse_result == OK:
            print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
            continue

        # Get the data from the JSON object
        var node_data = json.get_data()

        # Firstly, we need to create the object and add it to the tree and set its position.
        var new_object = load(node_data["filename"]).instantiate()
        get_node(node_data["parent"]).add_child(new_object)
        new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

        # Now we set the remaining variables.
        for i in node_data.keys():
            if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
                continue
            new_object.set(i, node_data[i])
```

现在，我们可以保存和加载任意数量的对象，这些对象几乎分布在场景树的任何位置！每个对象可以根据需要保存的内容存储不同的数据。

#### 一些注释

我们掩盖了为加载设置游戏状态的问题。这最终取决于项目创建者的逻辑。这通常很复杂，需要根据单个项目的需求进行大量定制。

此外，我们的实现假设没有任何 Persist 对象是其他 Persist 对象的子对象。否则，将创建无效路径。若要容纳嵌套的 Persist 对象，请考虑分阶段保存对象。首先加载父对象，以便在加载子对象时它们可用于 add_child() 调用。您还需要一种将子节点链接到父节点的方法，因为 NodePath 可能无效。

#### JSON 与二进制序列化

对于简单的游戏状态，JSON 可能会起作用，它会生成易于调试的可读文件。
但是 JSON 有很多局限性。如果您需要存储更复杂的游戏状态或大量的游戏状态，二进制序列化可能是更好的方法。

##### JSON 限制

以下是使用 JSON 时需要了解的一些重要问题。

- **文件大小**：JSON 以文本格式存储数据，这比二进制格式大得多。
- **数据类型**：JSON 只提供一组有限的数据类型。如果您有 JSON 没有的数据类型，则需要将数据转换为 JSON 可以处理的类型或从 JSON 可以处理类型转换数据。例如，JSON 无法解析的一些重要类型有：Vector2、Vector3、Color、Rect2 和 Quaternion。
- **编码/解码所需的自定义逻辑**：如果有任何自定义类要用 JSON 存储，则需要编写自己的逻辑来编码和解码这些类。

##### 二进制序列化

二进制序列化是存储游戏状态的另一种方法，您可以将其与 FileAccess 的函数 `get_var` 和 `store_var` 一起使用。

- 二进制序列化应该产生比 JSON 更小的文件。
- 二进制序列化可以处理大多数常见的数据类型。
- 二进制序列化需要较少的自定义逻辑来编码和解码自定义类。

请注意，并非所有属性都包含在内。只有使用 PROPERTY_USAGE_STORAGE 标志集配置的属性才会被序列化。通过重写类中的 _get_property_list 方法，可以向特性添加新的用法标志。您还可以通过调用 `Object._get_property_list` 来检查如何配置属性。有关可能的用法标志，请参阅 PropertyUsageFlags。

### 二进制序列化 API

#### 简介

Godot 有一个基于 Variant 的序列化 API。它用于有效地将数据类型转换为字节数组。此 API 通过全局 bytes_to_var() 和 var_to_bytes() 函数公开，但它也用于 FileAccess 的 `get_var` 和 `store_var` 方法以及 PacketPeer 的数据包 API。此格式*不*用于二进制场景和资源。

#### 完整对象与对象实例 ID

如果一个变量被序列化为 `full_objects=true`，那么该变量中包含的任何对象都将被序列化并包含在结果中。这是递归的。

如果 `full_objects=false`，则仅序列化变量中包含的任何对象的实例 ID。

#### 数据包规范

数据包被设计为总是被填充到 4 个字节。所有值都是小端编码的。所有数据包都有一个 4 字节的标头，表示一个整数，用于指定数据类型。

最低值的两个字节用于确定类型，而最高值的两字节包含标志：

```c++
base_type = val & 0xFFFF;
flags = val >> 16;
```

| 类型 | 值            |
| ---- | ------------- |
| 0    | null          |
| 1    | bool          |
| 2    | integer       |
| 3    | float         |
| 4    | string        |
| 5    | vector2       |
| 6    | rect2         |
| 7    | vector3       |
| 8    | transform2d   |
| 9    | plane         |
| 10   | quaternion    |
| 11   | aabb          |
| 12   | basis         |
| 13   | transform3d   |
| 14   | color         |
| 15   | node path     |
| 16   | rid           |
| 17   | object        |
| 18   | dictionary    |
| 19   | array         |
| 20   | raw array     |
| 21   | int32 array   |
| 22   | int64 array   |
| 23   | float32 array |
| 24   | float64 array |
| 25   | string array  |
| 26   | vector2 array |
| 27   | vector3 array |
| 28   | color array   |
| 29   | max           |

下面是实际的数据包内容，每种数据包的内容都有所不同。请注意，这假设 Godot 是使用单精度浮点编译的，这是默认值。如果 Godot 是用双精度浮点编译的，那么数据结构中“浮点”字段的长度应该是 8，偏移量应该是 `(offset - 4) * 2 + 4`。“float”类型本身总是使用双精度。

##### 0：null

##### 1：bool

| 偏移量 | 长度 | 类型    | 描述                  |
| ------ | ---- | ------- | --------------------- |
| 4      | 4    | Integer | 0 为 False, 1 为 True |

##### 2：int

如果未设置标志（flags == 0），则整数将作为 32 位整数发送：

| 偏移量 | 长度 | 类型    | 描述            |
| ------ | ---- | ------- | --------------- |
| 4      | 4    | Integer | 32 位有符号整数 |

如果设置了标志 `ENCODE_FLAG_64`（`flags & 1 == 1`），则整数将作为 64 位整数发送：

| 偏移量 | 长度 | 类型    | 描述            |
| ------ | ---- | ------- | --------------- |
| 4      | 8    | Integer | 64 位有符号整数 |

##### 3：float

如果未设置任何标志（flags == 0），则浮点值将作为 32 位单精度发送：

| 偏移量 | 长度 | 类型  | 描述                  |
| ------ | ---- | ----- | --------------------- |
| 4      | 4    | Float | IEEE 754 单精度浮点数 |

如果设置了标志 `ENCODE_FLAG_64`（`flags & 1 == 1`），则浮点值将作为 64 位双精度数字发送：

| 偏移量 | 长度 | 类型  | 描述                  |
| ------ | ---- | ----- | --------------------- |
| 4      | 8    | Float | IEEE 754 双精度浮点数 |

##### 4：String

| 偏移量 | 长度 | 类型    | 描述                      |
| ------ | ---- | ------- | ------------------------- |
| 4      | 4    | Integer | 字符串长度 (按字节为单位) |
| 8      | X    | Bytes   | UTF-8 编码的字符串        |

此字段填充为 4 个字节。

##### 5：Vector2

| 偏移量 | 长度 | 类型  | 描述   |
| ------ | ---- | ----- | ------ |
| 4      | 4    | Float | X 坐标 |
| 8      | 4    | Float | Y 坐标 |

##### 6：Rect2

| 偏移量 | 长度 | 类型  | 描述   |
| ------ | ---- | ----- | ------ |
| 4      | 4    | Float | X 坐标 |
| 8      | 4    | Float | Y 坐标 |
| 12     | 4    | Float | X 大小 |
| 16     | 4    | Float | Y 大小 |

##### 7：Vector3

| 偏移量 | 长度 | 类型  | 描述   |
| ------ | ---- | ----- | ------ |
| 4      | 4    | Float | X 坐标 |
| 8      | 4    | Float | Y 坐标 |
| 12     | 4    | Float | Z 坐标 |

##### 8：Transform2D

| 偏移量 | 长度 | 类型  | 描述                                  |
| ------ | ---- | ----- | ------------------------------------- |
| 4      | 4    | Float | X 列向量的 X 分量，通过 `[0][0]` 访问 |
| 8      | 4    | Float | X 列向量的 Y 分量，通过 `[0][1]` 访问 |
| 12     | 4    | Float | Y 列向量的 X 分量，通过 `[1][0]` 访问 |
| 16     | 4    | Float | Y 列向量的 Y 分量，通过 `[1][1]` 访问 |
| 20     | 4    | Float | 原始向量的 X 分量，通过 `[2][0]` 访问 |
| 24     | 4    | Float | 原始向量的 Y 分量，通过 `[2][1]` 访问 |

##### 9：Plane

| 偏移量 | 长度 | 类型  | 描述   |
| ------ | ---- | ----- | ------ |
| 4      | 4    | Float | 法线 X |
| 8      | 4    | Float | 法线 Y |
| 12     | 4    | Float | 法线 Z |
| 16     | 4    | Float | 距离   |

##### 10：Quaternion

| 偏移量 | 长度 | 类型  | 描述   |
| ------ | ---- | ----- | ------ |
| 4      | 4    | Float | 虚部 X |
| 8      | 4    | Float | 虚部 Y |
| 12     | 4    | Float | 虚部 Z |
| 16     | 4    | Float | 实部 W |

##### 11：AABB

| 偏移量 | 长度 | 类型  | 描述   |
| ------ | ---- | ----- | ------ |
| 4      | 4    | Float | X 坐标 |
| 8      | 4    | Float | Y 坐标 |
| 12     | 4    | Float | Z 坐标 |
| 16     | 4    | Float | X 大小 |
| 20     | 4    | Float | Y 大小 |
| 24     | 4    | Float | Z 大小 |

##### 12：Basis

| 偏移量 | 长度 | 类型  | 描述                                  |
| ------ | ---- | ----- | ------------------------------------- |
| 4      | 4    | Float | X 列向量的 X 分量，通过 `[0][0]` 访问 |
| 8      | 4    | Float | X 列向量的 Y 分量，通过 `[0][1]` 访问 |
| 12     | 4    | Float | X 列向量的 Z 分量，通过 `[0][2]` 访问 |
| 16     | 4    | Float | Y 列向量的 X 分量，通过 `[1][0]` 访问 |
| 20     | 4    | Float | Y 列向量的 Y 分量，通过 `[1][1]` 访问 |
| 24     | 4    | Float | Y 列向量的 Z 分量，通过 `[1][2]` 访问 |
| 28     | 4    | Float | Z 列向量的 X 分量，通过 `[2][0]` 访问 |
| 32     | 4    | Float | Z 列向量的 Y 分量，通过 `[2][1]` 访问 |
| 36     | 4    | Float | Z 列向量的 Z 分量，通过 `[2][2]` 访问 |

##### 13：Transform3D

| 偏移量 | 长度 | 类型  | 描述                                  |
| ------ | ---- | ----- | ------------------------------------- |
| 4      | 4    | Float | X 列向量的 X 分量，通过 `[0][0]` 访问 |
| 8      | 4    | Float | X 列向量的 Y 分量，通过 `[0][1]` 访问 |
| 12     | 4    | Float | X 列向量的 Z 分量，通过 `[0][2]` 访问 |
| 16     | 4    | Float | Y 列向量的 X 分量，通过 `[1][0]` 访问 |
| 20     | 4    | Float | Y 列向量的 Y 分量，通过 `[1][1]` 访问 |
| 24     | 4    | Float | Y 列向量的 Z 分量，通过 `[1][2]` 访问 |
| 28     | 4    | Float | Z 列向量的 X 分量，通过 `[2][0]` 访问 |
| 32     | 4    | Float | Z 列向量的 Y 分量，通过 `[2][1]` 访问 |
| 36     | 4    | Float | Z 列向量的 Z 分量，通过 `[2][2]` 访问 |
| 40     | 4    | Float | 原始向量的 X 分量，通过 `[3][0]` 访问 |
| 44     | 4    | Float | 原始向量的 Y 分量，通过 `[3][1]` 访问 |
| 48     | 4    | Float | 原始向量的 Z 分量，通过 `[3][2]` 访问 |

##### 14：Color

| 偏移量 | 长度 | 类型  | 描述                                       |
| ------ | ---- | ----- | ------------------------------------------ |
| 4      | 4    | Float | 红（通常为0..1，对于过亮的颜色可以高于 1） |
| 8      | 4    | Float | 绿（通常为0..1，对于过亮的颜色可以高于 1） |
| 12     | 4    | Float | 蓝（通常为0..1，对于过亮的颜色可以高于 1） |
| 16     | 4    | Float | Alpha (0..1)                               |

##### 15：NodePath

| 偏移量 | 长度 | 类型    | 描述                                                         |
| ------ | ---- | ------- | ------------------------------------------------------------ |
| 4      | 4    | Integer | 字符串长度, 或者新格式 (val&0x80000000 != 0 and NameCount=val&0x7FFFFFFF) |

###### 对旧格式：

| 偏移量 | 长度 | 类型  | 描述             |
| ------ | ---- | ----- | ---------------- |
| 8      | X    | Bytes | UTF-8 编码字符串 |

填充至 4 字节。

###### 对新格式：

| 偏移量 | 长度 | 类型    | 描述                         |
| ------ | ---- | ------- | ---------------------------- |
| 4      | 4    | Integer | Sub-name 计数                |
| 8      | 4    | Integer | 标记 (absolute: val&1 != 0 ) |

对于每一个 Name 和 Sub-Name

| 偏移量 | 长度 | 类型    | 描述             |
| ------ | ---- | ------- | ---------------- |
| X+0    | 4    | Integer | 字符串长度       |
| X+4    | X    | Bytes   | UTF-8 编码字符串 |

每个名字字符串填充到 4 字节。

##### 16：RID（不支持）

##### 17：Object

对象可以用三种不同的方式序列化：null 值、`full_objects = false` 或 `full_objects = true`。

###### 空值

| 偏移量 | 长度 | 类型    | 描述                 |
| ------ | ---- | ------- | -------------------- |
| 4      | 4    | Integer | 零 (32 位有符号整数) |

###### 禁用 `full_objects`

| 偏移量 | 长度 | 类型    | 描述                             |
| ------ | ---- | ------- | -------------------------------- |
| 4      | 8    | Integer | Object 实例 ID (64 位有符号整数) |

###### 启用 `full_objects`

| 偏移量 | 长度 | 类型    | 描述                    |
| ------ | ---- | ------- | ----------------------- |
| 4      | 4    | Integer | 类名 (字符串长度)       |
| 8      | X    | Bytes   | 类名 (UTF-8 编码字符串) |
| X+8    | 4    | Integer | 序列化的属性数量        |

对于每个属性：

| 偏移量 | 长度 | 类型         | 描述                      |
| ------ | ---- | ------------ | ------------------------- |
| Y      | 4    | Integer      | 属性名 (字符串长度)       |
| Y+4    | Z    | Bytes        | 属性名 (UTF-8 编码字符串) |
| Y+4+Z  | W    | `<variable>` | 属性值, 使用这种相同格式  |

> **注意：**
>
> 并非所有属性都包含在内。只有使用 PROPERTY_USAGE_STORAGE 标志集配置的属性才会被序列化。通过重写类中的 _get_property_list 方法，可以向特性添加新的用法标志。您还可以通过调用 `Object._get_property_list` 来检查如何配置属性使用。有关可能的用法标志，请参见 PropertyUsageFlags。

##### 18：Dictionary

| 偏移量 | 长度 | 类型    | 描述                                                 |
| ------ | ---- | ------- | ---------------------------------------------------- |
| 4      | 4    | Integer | val&0x7FFFFFFF = 元素, val&0x80000000 = 共享(布尔值) |

接下来，对于“元素”的数量，键和值的对，一个接一个，使用相同的格式。

##### 19：Array

| 偏移量 | 长度 | 类型    | 描述                                                  |
| ------ | ---- | ------- | ----------------------------------------------------- |
| 4      | 4    | Integer | val&0x7FFFFFFF = 元素, val&0x80000000 = 共享 (布尔值) |

接下来，对于“元素”的数量，使用相同的格式，一个接一个地取值。

##### 20：PackedByteArray

| 偏移量      | 长度 | 类型    | 描述            |
| ----------- | ---- | ------- | --------------- |
| 4           | 4    | Integer | 数组长度 (字节) |
| 8..8+length | 1    | Byte    | 字节 (0..255)   |

The array data is padded to 4 bytes.

##### 21: [PackedInt32Array](https://docs.godotengine.org/en/stable/classes/class_packedint32array.html#class-packedint32array)

| 偏移量        | 长度 | 类型    | 描述            |
| ------------- | ---- | ------- | --------------- |
| 4             | 4    | Integer | 数组长度 (整数) |
| 8..8+length*4 | 4    | Integer | 32 位有符号整数 |

##### 22: [PackedInt64Array](https://docs.godotengine.org/en/stable/classes/class_packedint64array.html#class-packedint64array)

| 偏移量        | 长度 | 类型    | 描述            |
| ------------- | ---- | ------- | --------------- |
| 4             | 8    | Integer | 数组长度 (整数) |
| 8..8+length*8 | 8    | Integer | 64 位有符号整数 |

##### 23: [PackedFloat32Array](https://docs.godotengine.org/en/stable/classes/class_packedfloat32array.html#class-packedfloat32array)

| 偏移量        | 长度 | 类型    | 描述                        |
| ------------- | ---- | ------- | --------------------------- |
| 4             | 4    | Integer | 数组长度 (浮点数)           |
| 8..8+length*4 | 4    | Integer | 32 位 IEEE 754 单精度浮点数 |

##### 24: [PackedFloat64Array](https://docs.godotengine.org/en/stable/classes/class_packedfloat64array.html#class-packedfloat64array)

| 偏移量        | 长度 | 类型    | 描述                        |
| ------------- | ---- | ------- | --------------------------- |
| 4             | 4    | Integer | 数组长度 (浮点数)           |
| 8..8+length*8 | 8    | Integer | 64 位 IEEE 754 双精度浮点数 |

##### 25: [PackedStringArray](https://docs.godotengine.org/en/stable/classes/class_packedstringarray.html#class-packedstringarray)

| 偏移量 | 长度 | 类型    | 描述              |
| ------ | ---- | ------- | ----------------- |
| 4      | 4    | Integer | 数组长度 (字符串) |

对每个字符串:

| 偏移量 | 长度 | 类型    | 描述             |
| ------ | ---- | ------- | ---------------- |
| X+0    | 4    | Integer | 字符串长度       |
| X+4    | X    | Bytes   | UTF-8 编码字符串 |

每个字符串被填充到 4 字节.

##### 26: [PackedVector2Array](https://docs.godotengine.org/en/stable/classes/class_packedvector2array.html#class-packedvector2array)

| 偏移量         | 长度 | 类型    | 描述     |
| -------------- | ---- | ------- | -------- |
| 4              | 4    | Integer | 数组长度 |
| 8..8+length*8  | 4    | Float   | X 坐标   |
| 8..12+length*8 | 4    | Float   | Y 坐标   |

##### 27: [PackedVector3Array](https://docs.godotengine.org/en/stable/classes/class_packedvector3array.html#class-packedvector3array)

| 偏移量          | 长度 | 类型    | 描述     |
| --------------- | ---- | ------- | -------- |
| 4               | 4    | Integer | 数组长度 |
| 8..8+length*12  | 4    | Float   | X 坐标   |
| 8..12+length*12 | 4    | Float   | Y 坐标   |
| 8..16+length*12 | 4    | Float   | Z 坐标   |

##### 28: [PackedColorArray](https://docs.godotengine.org/en/stable/classes/class_packedcolorarray.html#class-packedcolorarray)

| 偏移量          | 长度 | 类型    | 描述                                       |
| --------------- | ---- | ------- | ------------------------------------------ |
| 4               | 4    | Integer | 数组长度                                   |
| 8..8+length*16  | 4    | Float   | 红（通常为0..1，对于过亮的颜色可以高于 1） |
| 8..12+length*16 | 4    | Float   | 绿（通常为0..1，对于过亮的颜色可以高于 1） |
| 8..16+length*16 | 4    | Float   | 蓝（通常为0..1，对于过亮的颜色可以高于 1） |
| 8..20+length*16 | 4    | Float   | Alpha (0..1)                               |

## 处理输入

### 使用 InputEvent

#### 它是什么?

管理输入通常很复杂，无论是操作系统还是平台。为了稍微简化这一点，提供了一种特殊的内置类型 InputEvent。此数据类型可以配置为包含多种类型的输入事件。输入事件在引擎中传播，可以在多个位置接收，具体取决于目的。

下面是一个快速示例，如果按下了逃生键，则关闭游戏：

```python
func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            get_tree().quit()
```

但是，使用提供的 InputMap 功能更干净、更灵活，它允许您定义输入操作并为它们分配不同的键。通过这种方式，您可以为同一动作定义多个键（例如，键盘的退出键和游戏板上的开始按钮）。然后，您可以更容易地在项目设置中更改此映射，而无需更新代码，甚至可以在此基础上构建键映射功能，允许您的游戏在运行时更改键映射！

您可以在**“项目” > “项目设置” > “输入映射”**下设置 InputMap，然后使用以下操作：

```python
func _process(delta):
    if Input.is_action_pressed("ui_right"):
        # Move right.
```

#### 它怎么工作？

每个输入事件都源于用户/播放器（尽管可以生成 InputEvent 并将其反馈给引擎，这对手势很有用）。每个平台的操作系统对象将从设备中读取事件，然后将其提供给窗口。

窗口的 Viewport 对接收到的输入执行了大量操作，顺序如下：

1. 如果 Viewport 正在嵌入 Windows，则 Viewport 会尝试将其功能中的事件解释为窗口管理器（例如，用于调整窗口大小或移动窗口）。
2. 接下来，如果某个嵌入的窗口被聚焦，则该事件将被发送到该窗口，并在 Windows 视口中进行处理。如果没有聚焦嵌入的窗口，则“事件”将按以下顺序发送到当前视口的节点。
3. 首先，标准 [Node._input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-input) 函数将在任何覆盖它的节点中被调用（并且没有禁用 [Node.set_process_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-set-process-input) 的输入处理）。如果任何函数消耗了该事件，它可以调用 [Viewport.set_input_as_handled()](https://docs.godotengine.org/en/stable/classes/class_viewport.html#class-viewport-method-set-input-as-handled)，该事件将不再传播。这确保您可以过滤所有感兴趣的事件，甚至在 GUI 之前。对于游戏输入，[Node._unhandled_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-unhandled-input) 通常更适合，因为它允许 GUI 拦截事件。
4. 其次，它将尝试将输入馈送到 GUI，并查看是否有任何控件可以接收它。如果可以，则将通过虚拟函数 [Control._gui_input()](https://docs.godotengine.org/en/stable/classes/class_control.html#class-control-method-gui-input) 调用 Control 和信号“gui_put”将被发出（该函数可以通过脚本从中继承来重新实现）。如果控件想“消费”该事件，它将调用 [Control.accept_event()](https://docs.godotengine.org/en/stable/classes/class_control.html#class-control-method-accept-event)，该事件将不再传播。使用 [Control.mouse_filter](https://docs.godotengine.org/en/stable/classes/class_control.html#class-control-property-mouse-filter) 属性可以控制 Control 是否被通知鼠标事件 [Control._gui_input()](https://docs.godotengine.org/en/stable/classes/class_control.html#class-control-method-gui-input) 回调，以及是否进一步传播这些事件。
5. 如果到目前为止没有人消费该事件，则如果被重写（并且未使用[Node.set_process_shortcut_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-set-process-shortcut-input) 禁用），则将调用 [Node._shortcut_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-shortcut-input) 回调。这种情况仅发生在 InputEventKey、InputEventShortcut 和 InputEventJoypadButton 上。如果任何函数使用该事件，它可以调用 [Viewport.set_input_as_handled()](https://docs.godotengine.org/en/stable/classes/class_viewport.html#class-viewport-method-set-input-as-handled)，并且该事件将不再传播。快捷方式输入回调非常适合将要作为快捷方式处理的事件。
6. 如果到目前为止没有人消费该事件，则如果重写（并且未使用 [Node.set_process_unhandled_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-set-process-unhandled-input) 禁用），则将调用 [Node._unhandled_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-unhandled-input) 回调。如果任何函数使用该事件，它可以调用 [Viewport.set_input_as_handled()](https://docs.godotengine.org/en/stable/classes/class_viewport.html#class-viewport-method-set-input-as-handled)，并且该事件将不再传播。未处理的输入回调非常适合全屏游戏事件，因此当 GUI 处于活动状态时不会接收到这些事件。
7. 如果到目前为止没有人消费该事件，则如果重写（并且未使用 [Node.set_process_unhandled_key_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-set-process-unhandled-key-input) 禁用），则将调用 [Node._unhandled_key_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-unhandled-key-input) 回调。只有当事件是 InputEventKey 时才会发生这种情况。如果任何函数使用该事件，它可以调用 [Viewport.set_input_as_handled()](https://docs.godotengine.org/en/stable/classes/class_viewport.html#class-viewport-method-set-input-as-handled)，并且该事件将不再传播。未处理的键输入回调非常适合键事件。
8. 如果到目前为止没有人想要该事件，并且“对象拾取”处于启用状态，则该事件将用于对象拾取。对于根视口，这也可以在“项目设置”中启用。在3D场景的情况下，如果将 Camera3D 指定给 Viewport，则将投射到物理世界的光线（沿单击后的光线方向）。如果此光线击中对象，它将调用 [CollisionObject3D._input_event()](https://docs.godotengine.org/en/stable/classes/class_collisionobject3d.html#class-collisionobject3d-method-input-event) 函数（默认情况下，实体会接收此回调，但区域不会。这可以通过 Area3D 属性进行配置）。在 2D 场景的情况下，概念上与 [CollisionObject2D._input_event()](https://docs.godotengine.org/en/stable/classes/class_collisionobject2d.html#class-collisionobject2d-method-input-event) 相同。

当将事件发送到其子节点和子节点时，视口将以相反的深度优先顺序执行此操作，如下图所示，从场景树底部的节点开始，到根节点结束。嵌入的 Windows 和 SubViewports 不在此过程中。

此顺序不适用于 [Control._gui_input()](https://docs.godotengine.org/en/stable/classes/class_control.html#class-control-method-gui-input)，它根据事件位置或焦点控件使用不同的方法。

由于视口不会将事件发送到其他子视口，因此必须使用以下方法之一：

1. 使用 [SubViewportContainer](https://docs.godotengine.org/en/stable/classes/class_subviewportcontainer.html#class-subviewportcontainer)，该容器会在 [Node._input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-input) 和 [Node._unhandled_input()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-unhandled-input) 期间自动将事件发送到其子 [SubViewports](https://docs.godotengine.org/en/stable/classes/class_subviewport.html#class-subviewport)。
2. 根据个人需求实施事件传播。

GUI 事件也在场景树中向上传播，但由于这些事件以特定控件为目标，因此只有目标控件节点的直接祖先才会接收该事件。

根据 Godot 基于节点的设计，这使得专门的子节点能够处理和消费特定事件，而它们的祖先，以及最终的场景根，可以在需要时提供更通用的行为。

#### InputEvent 的剖析

InputEvent 只是一个基本的内置类型，它不表示任何内容，只包含一些基本信息，如事件 ID（每个事件都会增加）、设备索引等。

InputEvent 有几种特殊类型，如下表所述：

| 事件                                                         | 类型索引        | 描述                                                         |
| ------------------------------------------------------------ | --------------- | ------------------------------------------------------------ |
| [InputEvent](https://docs.godotengine.org/en/stable/classes/class_inputevent.html#class-inputevent) | NONE            | 空输入事件                                                   |
| [InputEventKey](https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html#class-inputeventkey) | KEY             | 包含一个键代码和Unicode值，以及修饰符。                      |
| [InputEventMouseButton](https://docs.godotengine.org/en/stable/classes/class_inputeventmousebutton.html#class-inputeventmousebutton) | MOUSE_BUTTON    | 包含单击信息，如按钮、修饰符等。                             |
| [InputEventMouseMotion](https://docs.godotengine.org/en/stable/classes/class_inputeventmousemotion.html#class-inputeventmousemotion) | MOUSE_MOTION    | 包含运动信息，例如相对位置、绝对位置和速度。                 |
| [InputEventJoypadMotion](https://docs.godotengine.org/en/stable/classes/class_inputeventjoypadmotion.html#class-inputeventjoypadmotion) | JOYSTICK_MOTION | 包含操纵手柄/操纵板模拟轴信息。                              |
| [InputEventJoypadButton](https://docs.godotengine.org/en/stable/classes/class_inputeventjoypadbutton.html#class-inputeventjoypadbutton) | JOYSTICK_BUTTON | 包含操纵手柄/操纵板按钮信息。                                |
| [InputEventScreenTouch](https://docs.godotengine.org/en/stable/classes/class_inputeventscreentouch.html#class-inputeventscreentouch) | SCREEN_TOUCH    | 包含多点触摸按压/释放信息。（仅适用于移动设备）              |
| [InputEventScreenDrag](https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html#class-inputeventscreendrag) | SCREEN_DRAG     | 包含多点触摸拖动信息。（仅适用于移动设备）                   |
| [InputEventAction](https://docs.godotengine.org/en/stable/classes/class_inputeventaction.html#class-inputeventaction) | SCREEN_ACTION   | 包含常规操作。这些事件通常由程序员作为反馈生成。（下面将详细介绍） |

#### 行动

动作是将零个或多个 InputEvents 分组为一个常见的标题（例如，默认的“ui_left”动作将操纵手柄的左输入和键盘的左箭头键分组）。它们不需要表示 InputEvent，但很有用，因为它们在编程游戏逻辑时抽象了各种输入。

这允许：

- 相同的代码可以在具有不同输入的不同设备上工作（例如，PC 上的键盘、控制台上的游戏板）。
- 要在运行时重新配置的输入。
- 在运行时以编程方式触发的操作。

可以从“**输入映射**”选项卡中的“项目设置”菜单创建操作，并指定输入事件。

任何事件都有 InputEvent.is_action()、InputEvent.is_pressed() 和 InputEvent 方法。

或者，可能希望向游戏提供来自游戏代码的动作（这方面的一个很好的例子是检测手势）。Input singleton 有一个方法：Input.parse_Input_event（）。您通常会这样使用它：

```python
var ev = InputEventAction.new()
# Set as ui_left, pressed.
ev.action = "ui_left"
ev.pressed = true
# Feedback.
Input.parse_input_event(ev)
```

#### 输入映射

通常需要自定义和重新映射来自代码的输入。如果整个工作流依赖于操作，那么 InputMap 单例非常适合在运行时重新分配或创建不同的操作。这个单例不保存（必须手动修改），它的状态是从项目设置（project.godot）运行的。因此，任何这种类型的动态系统都需要以程序员认为最合适的方式存储设置。

### 输入示例

#### 简介

在本教程中，您将学习如何使用 Godot 的 InputEvent 系统来捕获玩家输入。你的游戏可以使用许多不同类型的输入——键盘、游戏板、鼠标等——以及许多不同的方式将这些输入转化为游戏中的动作。本文档将向您展示一些最常见的场景，这些场景可以作为您自己项目的起点。

> **注意：**
>
> 有关 Godot 的输入事件系统如何工作的详细概述，请参阅使用 InputEvent。

#### 事件与轮询

有时你想让你的游戏对某个输入事件做出反应，比如按下“跳跃”按钮。对于其他情况，您可能希望只要按下某个键，就会发生一些事情，例如移动。在第一种情况下，可以使用 `_input()` 函数，每当发生输入事件时都会调用该函数。在第二种情况下，Godot 提供了 Input singleton，您可以使用它来查询输入的状态。

示例：

```python
func _input(event):
    if event.is_action_pressed("jump"):
        jump()


func _physics_process(delta):
    if Input.is_action_pressed("move_right"):
        # Move as long as the key/button is pressed.
        position.x += speed * delta
```

这使您可以灵活地混合和匹配所做的输入处理类型。

在本教程的剩余部分中，我们将重点关注在 `_input()` 中捕获单个事件。

#### 输入事件

输入事件是从 InputEvent 继承的对象。根据事件类型的不同，对象将包含与该事件相关的特定属性。要查看事件的实际外观，请添加一个节点并附加以下脚本：

```python
extends Node


func _input(event):
    print(event.as_text())
```

当您按键、移动鼠标和执行其他输入时，您将在输出窗口中看到每个事件滚动经过。以下是输出示例：

```
A
Mouse motion at position ((971, 5)) with velocity ((0, 0))
Right Mouse Button
Mouse motion at position ((870, 243)) with velocity ((0.454937, -0.454937))
Left Mouse Button
Mouse Wheel Up
A
B
Shift
Alt+Shift
Alt
Shift+T
Mouse motion at position ((868, 242)) with velocity ((-2.134768, 2.134768))
```

正如您所看到的，对于不同类型的输入，结果是非常不同的。关键事件甚至被打印为其关键符号。例如，让我们考虑 InputEventMouseButton。它继承自以下类：

- InputEvent - 所有输入事件的基类
- InputEventWithModifiers - 添加了检查是否按下了修改器（如 `Shift` 或 `Alt`.）的功能。
- InputEventMouse - 添加鼠标事件属性，例如 `position`
- InputEventMouseButton - 包含被按下按钮的索引，无论是双击，等等。

> **提示：**
>
> 在处理事件时，最好保持类引用处于打开状态，以便检查事件类型的可用属性和方法。

如果您试图访问不包含属性的输入类型上的属性，则可能会遇到错误，例如在 `InputEventKey` 上调用 `position`。要避免这种情况，请确保首先测试事件类型：

```python
func _input(event):
    if event is InputEventMouseButton:
        print("mouse button event at ", event.position)
```

#### InputMap

InputMap 是处理各种输入的最灵活的方法。您可以通过创建命名的输入动作来使用它，您可以将任意数量的输入事件（如按键或鼠标单击）分配给这些动作。要查看它们并添加自己的设置，请打开“项目”->“项目设置”，然后选择“输入映射”选项卡：

> **提示：**
>
> 一个新的 Godot 项目包括许多已经定义的默认操作。若要查看它们，请在“输入映射”对话框中启用 `Show Built-in Actions`。

##### 捕捉动作

一旦定义了操作，就可以使用 `is_action_pressed()` 和 `is_action_released()` 在脚本中处理它们，方法是传递要查找的操作的名称：

```python
func _input(event):
    if event.is_action_pressed("my_action"):
        print("my_action occurred!")
```

#### 键盘事件

键盘事件在 InputEventKey 中捕获。虽然建议使用输入操作，但在某些情况下，您可能需要专门查看关键事件。对于本例，让我们检查 `T`：

```python
func _input(event):
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_T:
            print("T was pressed")
```

> **提示：**
> 有关键代码常量的列表，请参见 @GlobalScope_Key。

> **警告：**
>
> 由于*键盘重影*，如果一次按太多键，可能不会在给定时间注册所有键输入。由于它们在键盘上的位置，某些键比其他键更容易出现重影。一些键盘在硬件级别上具有防重影功能，但这种功能通常不存在于低端键盘和笔记本电脑键盘上。
>
> 因此，建议使用默认的键盘布局，该布局设计为在没有防重影的情况下在键盘上工作良好。有关更多信息，请参阅此 Gamedev Stack Exchange 问题。

##### 键盘修饰符

修饰符属性继承自 InputEventWithModifiers。这允许您使用布尔属性检查修改器组合。让我们想象一下，当按下 `T` 时，你希望发生一件事，但当按下 `Shift + T` 时，会发生不同的事情：

```python
func _input(event):
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_T:
            if event.shift_pressed:
                print("Shift+T was pressed")
            else:
                print("T was pressed")
```

> **提示：**
> 有关键代码常量的列表，请参见 @GlobalScope_Key。

#### 鼠标事件

鼠标事件源于 InputEventMouse 类，分为两种类型：InputEventMouseButton 和 InputEventMouseMotion。请注意，这意味着所有鼠标事件都将包含一个位置属性。

##### 鼠标按钮

捕捉鼠标按钮与处理关键事件非常相似 @GlobalScope_MouseButton 包含每个可能按钮的 `MOUSE_BUTTON_*` 常量列表，这些常量将在事件的 `button_index` 属性中报告。请注意，滚动轮也算作一个按钮——确切地说，是两个按钮，其中 `MOUSE_BUTTON_WHEEL_UP` 和 `MOUSE_BUTTON_WHEEL_DOWN` 都是单独的事件。

```python
func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            print("Left button was clicked at ", event.position)
        if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
            print("Wheel up")
```

##### 鼠标运动

每当鼠标移动时，就会发生 InputEventMouseMotion 事件。您可以使用 `relative` 特性查找移动的距离。

下面是一个使用鼠标事件拖放 Sprite2D 节点的示例：

```python
extends Node


var dragging = false
var click_radius = 32 # Size of the sprite.


func _input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if (event.position - $Sprite2D.position).length() < click_radius:
            # Start dragging if the click is on the sprite.
            if not dragging and event.pressed:
                dragging = true
        # Stop dragging if the button is released.
        if dragging and not event.pressed:
            dragging = false

    if event is InputEventMouseMotion and dragging:
        # While dragging, move the sprite with the mouse.
        $Sprite2D.position = event.position
```

#### 触摸事件

如果您使用的是触摸屏设备，则可以生成触摸事件。InputEventScreenTouch 相当于鼠标单击事件，InputEventScrenDrag 的工作原理与鼠标运动基本相同。

> **提示：**
>
> 要在非触摸屏设备上测试触摸事件，请打开“项目设置”，然后转到“输入设备/指向”部分。启用“模拟鼠标触摸”，您的项目将鼠标点击和运动解释为触摸事件。

### 鼠标和输入坐标

#### 关于

这个小教程的目的是为了清除输入坐标、获取鼠标位置和屏幕分辨率等方面的许多常见错误。

#### 硬件显示坐标

在编写要在 PC 上运行的复杂 UI（如编辑器、MMO、工具等）的情况下，使用硬件坐标是有意义的。然而，在这个范围之外，它就没有那么大意义了。

#### 视口显示坐标

Godot 使用视口来显示内容，并且可以通过几个选项缩放视口（请参见多分辨率教程）。然后，使用节点中的函数来获取鼠标坐标和视口大小，例如：

```python
func _input(event):
   # Mouse in viewport coordinates.
   if event is InputEventMouseButton:
       print("Mouse Click/Unclick at: ", event.position)
   elif event is InputEventMouseMotion:
       print("Mouse Motion at: ", event.position)

   # Print the size of the viewport.
   print("Viewport Resolution is: ", get_viewport_rect().size)
```

或者，也可以向视口询问鼠标位置：

```python
get_viewport().get_mouse_position()
```

> **注意：**
>
> 当鼠标模式设置为 `Input.MOUSE_MODE_CAPTURED` 时，`InputEventMouseMotion` 中的 `event.position` 值是屏幕的中心。使用 `event.relative` 而不是 `event.position` 和 `event.speed` 来处理鼠标移动和位置更改。

### 自定义鼠标光标

为了适应整体设计，您可能需要更改游戏中鼠标光标的外观。有两种方法可以自定义鼠标光标：

1. 使用项目设置
2. 使用脚本

使用项目设置是自定义鼠标光标的一种更简单（但更有限）的方法。第二种方式更具可定制性，但涉及到脚本编写：

> **注意：**
>
> 您可以通过在 `_process()` 方法中隐藏鼠标光标并将 Sprite2D 移动到光标位置来显示“软件”鼠标光标，但与“硬件”鼠标光标相比，这将增加至少一帧延迟。因此，建议尽可能使用此处描述的方法。
>
> 如果必须使用“软件”方法，请考虑添加外推步骤，以更好地显示实际鼠标输入。

#### 使用项目设置

打开项目设置，转到“显示”>“鼠标光标”。您将看到自定义图像、自定义图像热点和工具提示位置偏移。

“自定义图像”是要设置为鼠标光标的所需图像。自定义热点是图像中要用作光标检测点的点。

> **警告：**
>
> 自定义图像最多必须为 256×256 像素。为避免渲染问题，建议使用小于或等于 128×128 的大小。
>
> 在 web 平台上，允许的最大光标图像大小为 128×128。

#### 使用脚本

创建一个节点并附加以下脚本。

```python
extends Node


# Load the custom images for the mouse cursor.
var arrow = load("res://arrow.png")
var beam = load("res://beam.png")


func _ready():
    # Changes only the arrow shape of the cursor.
    # This is similar to changing it in the project settings.
    Input.set_custom_mouse_cursor(arrow)

    # Changes a specific shape of the cursor (here, the I-beam shape).
    Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)
```

> **参考：**
>
> 查看 Input.set_custom_mouse_cursor() 的文档，了解有关用法和平台特定注意事项的更多信息。

#### 演示项目

通过研究此演示项目了解更多信息：https://github.com/guilhermefelipecgs/custom_hardware_cursor

#### 光标列表

如 Input 类中所述（请参见 CursorShape 枚举），您可以定义多个鼠标光标。您要使用哪一个取决于您的用例。

### 控制器、游戏手柄和操纵杆

Godot 支持数百种控制器模型，这得益于社区来源的 SDL 游戏控制器数据库。

控制器在 Windows、macOS、Linux、Android、iOS 和 HTML5 上都受支持。

请注意，方向盘、方向舵踏板和 HOTAS 等更专业的设备测试较少，可能并不总是如预期那样工作。还没有实现对这些装置的超越力反馈。如果您可以访问其中一个设备，请毫不犹豫地在 GitHub 上报告错误。

在本指南中，您将学习：

- **如何编写既支持键盘输入又支持控制器输入的输入逻辑。**
- **控制器的行为如何与键盘/鼠标输入不同。**
- **Godot 中控制器的故障排除。**

#### 支持通用输入

得益于 Godot 的输入操作系统，Godot 可以同时支持键盘和控制器输入，而无需编写单独的代码路径。您不应该在脚本中硬编码键或控制器按钮，而应该在项目设置中创建输入操作，然后这些操作将引用指定的键和控制器输入。

输入操作在使用 InputEvent 页面上有详细说明。

> **注意：**
>
> 与键盘输入不同，支持鼠标和控制器输入的动作（例如在第一人称游戏中环顾四周）将需要不同的代码路径，因为它们必须单独处理。

##### 我应该使用哪种输入单例方法？

有三种方法可以以模拟感知的方式获得输入：

- 如果您有两个轴（如操纵杆或 WASD 移动），并且希望两个轴都作为一个输入，请使用 `Input.get_vector()`：

  ```python
  # `velocity` will be a Vector2 between `Vector2(-1.0, -1.0)` and `Vector2(1.0, 1.0)`.
  # This handles deadzone in a correct way for most use cases.
  # The resulting deadzone will have a circular shape as it generally should.
  var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
  
  # The line below is similar to `get_vector()`, except that it handles
  # the deadzone in a less optimal way. The resulting deadzone will have
  # a square-ish shape when it should ideally have a circular shape.
  var velocity = Vector2(
          Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
          Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
  ).limit_length(1.0)
  ```

- 当您有一个可以双向移动的轴时（例如飞行操纵杆上的油门），或者当您想单独处理单独的轴时，请使用 `Input.get_axis()`：

  ```python
  # `walk` will be a floating-point number between `-1.0` and `1.0`.
  var walk = Input.get_axis("move_left", "move_right")
  
  # The line above is a shorter form of:
  var walk = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
  ```

- 对于其他类型的模拟输入，例如处理触发器或一次处理一个方向，请使用 `Input.get_action_strenth()`：

  ```python
  # `strength` will be a floating-point number between `0.0` and `1.0`.
  var strength = Input.get_action_strength("accelerate")
  ```

  对于非模拟数字/布尔输入（仅“按下”或“未按下”值），如控制器按钮、鼠标按钮或键盘键，请使用 `Input.is_action_pressed()`：


  ```python
  # `jumping` will be a boolean with a value of `true` or `false`.
  var jumping = Input.is_action_pressed("jump")
  ```

> **注意：**
>
> 如果您需要知道上一帧中是否*刚刚*按下了输入，请使用 `Input.is_action_just_pressed()` 而不是 `Input.is_action_pressed()`。与只要保持输入就返回 `true` 的 `Input.is_action_pressed()` 不同，`Input.is_action_just_pressed()` 只会在按下按钮后的一帧内返回 `true`。

在 Godot 3.4 之前的版本（如 3.3）中，`Input.get_vector()` 和 `Input.get_axis()` 不可用。Godot 3.3 中只有 `Input.get_action_strenth()` 和 `Input.is_action_pressed()` 可用。

#### 振动

振动（也称为*触觉反馈*）可以用来增强游戏的感觉。例如，在赛车游戏中，你可以通过振动来传达汽车当前行驶的表面，或者在碰撞时产生突然的振动。

使用 Input singleton 的 start_joy_vibration 方法开始振动游戏板。使用 stop_joy_vibration 提前停止振动（如果启动时未指定持续时间，则非常有用）。

在移动设备上，您也可以使用 vibrate_handheld 振动设备本身（独立于游戏板）。在 Android 上，这需要在导出项目之前在 Android 导出预设中启用 `VIBRATE` 权限。

> **注意：**
>
> 振动可能会让某些玩家感到不舒服。确保提供游戏中的滑块来禁用振动或降低其强度。

#### 键盘/鼠标与控制器输入之间的差异

如果您习惯于处理键盘和鼠标输入，您可能会对控制器处理特定情况的方式感到惊讶。

##### 死区

与键盘和鼠标不同，控制器提供带有模拟输入的轴。模拟输入的好处在于，它们为操作提供了额外的灵活性。与只能提供 `0.0` 和 `1.0` 强度的数字输入不同，模拟输入可以提供 `0.0` 到 `1.0` 之间的任何强度。缺点是，如果没有死区系统，由于控制器的物理构建方式，模拟轴的强度永远不会等于 `0.0`。相反，它将停留在诸如 `0.062` 之类的低值。这种现象被称为漂移，在旧的或有故障的控制器上可能更明显。

让我们以一款赛车游戏为例。由于有了模拟输入，我们可以缓慢地将汽车转向一个或另一个方向。然而，如果没有死区系统，即使玩家没有触摸操纵杆，汽车也会自动缓慢转向。这是因为方向轴强度在我们期望的情况下不会等于 `0.0`。由于我们不希望我们的汽车在这种情况下自行转向，我们定义了一个“死区”值 `0.2`，它将忽略强度低于 `0.2` 的所有输入。理想的死区值高到足以忽略操纵杆漂移引起的输入，但低到足以不忽略玩家的实际输入。

Godot 采用了一个内置的死区系统来解决这个问题。默认值为 `0.5`，但您可以在“项目设置”的“输入映射”选项卡中根据每个操作对其进行调整。对于 `Input.get_vector()`，死区可以指定为可选的第五个参数。如果未指定，它将计算矢量中所有动作的平均死区值。

##### “回声”事件

与键盘输入不同，按住控制器按钮（如D-pad方向）**不会**以固定的间隔生成重复的输入事件（也称为“回声”事件）。这是因为操作系统从一开始就不会为控制器输入发送“回波”事件。

如果希望控制器按钮发送回显事件，则必须通过代码生成 InputEvent 对象，并定期使用 Input.parse_Input_event() 对其进行解析。这可以在 Timer 节点的帮助下完成。

##### 窗口焦点

与键盘输入不同，操作系统上的**所有**窗口都可以看到控制器输入，包括未聚焦的窗口。

虽然这对第三方分屏功能很有用，但也可能产生不利影响。玩家在与另一个窗口交互时，可能会意外地将控制器输入发送到正在运行的项目。

如果您希望在项目窗口未聚焦时忽略事件，则需要使用以下脚本创建一个名为 `Focus` 的自动加载，并使用它检查所有输入：

```python
# Focus.gd
extends Node

var focused := true

func _notification(what: int) -> void:
    match what:
        NOTIFICATION_APPLICATION_FOCUS_OUT:
            focused = false
        NOTIFICATION_APPLICATION_FOCUS_IN:
            focused = true


func input_is_action_pressed(action: StringName) -> bool:
    if focused:
        return Input.is_action_pressed(action)

    return false


func event_is_action_pressed(event: InputEvent, action: StringName) -> bool:
    if focused:
        return Input.is_action_pressed(action)

    return false
```

然后，不要使用 `Input.is_action_pressed(action)`，而是使用 `Focus.Input_is_action_press(action)`。其中 `action` 是输入操作的名称。此外，不要使用 `event.is_action_pressed(action)`，而是使用 `Focus.event_is_action_ppressed(event，action)`，其中 `event` 是 `InputEvent` 引用，`action` 是输入操作的名称。

##### 节电预防

与键盘和鼠标输入不同，控制器输入**不会**抑制睡眠和节能措施（例如在经过一定时间后关闭屏幕）。

为了解决这个问题，Godot 在项目运行时默认启用节能保护。如果您在玩游戏板时注意到系统正在关闭显示器，请检查项目设置中的“**显示 > 窗口 > 节能 > 保持屏幕打开**”的值。

在 Linux 上，防止省电需要引擎能够使用 D-Bus。如果在 Flatpak 中运行项目，请检查 D-Bus 是否已安装并可访问，因为沙盒限制可能会使这在默认情况下无法实现。

#### 疑难解答

> **参考：**
>
> 您可以在 GitHub 上查看控制器支持的已知问题列表。

##### Godot 无法识别我的控制器。

首先，检查您的控制器是否被其他应用程序识别。您可以使用 Gamepad 测试仪网站来确认您的控制器已被识别。

##### 我的控制器映射的按钮或轴不正确。

首先，如果您的控制器提供某种固件更新实用程序，请确保运行它以从制造商那里获得最新的修复程序。例如，Xbox One 和 Xbox Series 控制器可以使用 Xbox Accessories 应用程序更新固件。（此应用程序仅在 Windows 上运行，因此您必须使用 Windows 计算机或支持 USB 的 Windows 虚拟机来更新控制器的固件。）更新控制器固件后，如果您在无线模式下使用控制器，请将控制器拆开，然后将其与您的电脑重新配对。

如果按钮映射不正确，这可能是由于SDL游戏控制器数据库的错误映射造成的。您可以通过在链接的存储库上打开一个pull请求来提供一个更新的映射，以包含在下一个 Godot 版本中。

有许多方法可以创建映射。一种选择是在官方的 Joypads 演示中使用映射向导。一旦您有了控制器的工作映射，您就可以在运行 Godot 之前通过定义 `SDL_GAMECONTROLLERCONFIG` 环境变量来测试它：

```shell
export SDL_GAMECONTROLLERCONFIG="your:mapping:here"
./path/to/godot.x86_64
```

要在非桌面平台上测试映射，或者用额外的控制器映射分发项目，可以通过在脚本的 _ready() 函数中尽早调用 Input.add_joy_mapping() 来添加它们。

##### 我的控制器在给定的平台上工作，但不能在另一个平台上工作。

###### Linux

如果您使用的是自编译引擎二进制文件，请确保它是在 udev 支持下编译的。这在默认情况下是启用的，但可以通过在 SCons 命令行上指定 `udev=no` 来禁用 udev 支持。如果您使用的是 Linux 发行版提供的引擎二进制文件，请仔细检查它是否是使用 udev 支持编译的。

控制器在没有 udev 支持的情况下仍然可以工作，但它的可靠性较低，因为在游戏过程中必须使用定期轮询来检查控制器是否已连接或断开连接（热插拔）。

###### HTML5

与“原生”平台相比，HTML5 控制器支持通常不太可靠。控制器支持的质量往往因浏览器而异。因此，如果玩家无法让控制器正常工作，你可能不得不指示他们使用不同的浏览器。

### 处理退出请求

#### 退出

大多数平台都可以选择请求应用程序退出。在台式机上，这通常是通过窗口标题栏上的“x”图标来完成的。在 Android 上，后退按钮用于在主屏幕上退出（否则返回）。

#### 处理通知

在桌面和 web 平台上，当窗口管理器请求退出时，Node 会收到一个特殊的 `NOTIFICATION_WM_CLOSE_REQUEST` 通知。

在 Android 上，将改为发送 `NOTIFICATION_WM_GO_BACK_REQUEST`。如果在“项目设置”中选中了“**应用程序 > 配置 > 返回时退出**”（默认设置），则按下“返回”按钮将退出应用程序。

> **注意：**
>
> `NOTIFICATION_WM_GO_BACK_REQUEST` 在 iOS 上不受支持，因为 iOS 设备没有物理“后退”按钮。

处理通知如下（在任何节点上）：

```python
func _notification(what):
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        get_tree().quit() # default behavior
```

在开发移动应用程序时，除非用户在主屏幕上，否则不希望退出，因此可以改变行为。

需要注意的是，默认情况下，当从窗口管理器请求退出时，Godot应用程序具有退出的内置行为。这一点可以更改，以便用户能够完成整个退出过程：

```python
get_tree().set_auto_accept_quit(false)
```

#### 发送您自己的退出通知

虽然强制关闭应用程序可以通过调用 SceneTree.quit 来完成，但这样做不会将 `NOTIFICATION_WM_CLOSE_REQUEST` 发送到场景树中的节点。通过调用 SceneTree.quit 退出将不允许完成自定义操作（如保存、确认退出或调试），即使您试图延迟强制退出的行。

相反，如果您想通知场景树中的节点即将终止的程序，您应该自己发送通知：

```python
get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
```

发送此通知将通知所有节点程序终止，但不会像 3.X 中那样终止程序本身。为了实现之前的行为，应在通知后调用 SceneTree.quit。

## 数学

### 向量数学

#### 简介

本教程是对线性代数应用于游戏开发的简短而实用的介绍。线性代数是研究向量及其用途的学科。矢量在二维和三维开发中都有许多应用，Godot 广泛使用它们。培养对向量数学的良好理解对于成为一名强大的游戏开发人员至关重要。

> **注意：**
>
> 本教程不是关于线性代数的正式教材。我们将只关注它是如何应用于游戏开发的。要更广泛地了解数学，请参阅 https://www.khanacademy.org/math/linear-algebra

#### 坐标系（2D）

在二维空间中，使用水平轴（`x`）和垂直轴（`y`）定义坐标。2D 空间中的特定位置被写成一对值，例如 `(4, 3)`。

> **注意：**
>
> 如果你是计算机图形学的新手，那么正 `y` 轴指向下方而不是上方可能会显得很奇怪，就像你在数学课上学到的那样。然而，这在大多数计算机图形应用程序中是常见的。

2D 平面中的任何位置都可以用这种方式通过一对数字来识别。然而，我们也可以将位置 `(4, 3)` 视为从 `(0, 0)` 点或原点的偏移。绘制一个从原点指向该点的箭头：

这是一个**矢量**。矢量表示许多有用的信息。除了告诉我们点在 `(4, 3)`，我们还可以将其视为角度 `θ`（theta）和长度（或幅度）`m`。在这种情况下，箭头是一个**位置向量**，它表示相对于原点的空间位置。

关于向量，需要考虑的一个非常重要的点是，它们只表示**相对**方向和大小。没有矢量位置的概念。以下两个矢量相同：

两个矢量都表示右边 4 个单位和某个起点下面 3 个单位的点。向量在平面上的何处绘制并不重要，它始终表示相对的方向和大小。

#### 矢量运算

您可以使用任意一种方法（x 和 y 坐标或角度和幅度）来引用向量，但为了方便起见，程序员通常使用坐标表示法。例如，在 Godot 中，原点是屏幕的左上角，因此要将名为 `Node2D` 的 2D 节点向右放置 400 像素，向下放置 300 像素，请使用以下代码：

```python
$Node2D.position = Vector2(400, 300)
```

Godot 分别支持 Vector2 和 Vector3 用于 2D 和 3D 用途。本文中讨论的相同数学规则适用于这两种类型，无论我们在类引用中链接到 Vector2 方法，您也可以查看它们的 Vector3 对应方法。

##### 成员访问

矢量的各个分量可以通过名称直接访问。

```python
# Create a vector with coordinates (2, 5).
var a = Vector2(2, 5)
# Create a vector and assign x and y manually.
var b = Vector2()
b.x = 3
b.y = 1
```

##### 添加矢量

当将两个矢量相加或相减时，将添加相应的分量：

```python
var c = a + b  # (2, 5) + (3, 1) = (5, 6)
```

我们还可以通过在第一个向量的末尾添加第二个向量来直观地看到这一点：

请注意，将 `a + b` 相加会得到与 `b + a` 相同的结果。

##### 标量乘法

> **注意：**
>
> 矢量表示方向和大小。一个只表示大小的值称为**标量**。标量在 Godot 中使用浮点类型。

向量可以与**标量**相乘：

```python
var c = a * 2  # (2, 5) * 2 = (4, 10)
var d = b / 3  # (3, 6) / 3 = (1, 2)
```

> **注意：**
>
> 向量与标量相乘不会改变其方向，只会改变其大小。这就是**缩放**矢量的方式。

#### 实际应用

让我们来看看向量加法和减法的两种常见用法。

##### 运动

矢量可以表示**任何**具有大小和方向的量。典型的例子有：位置、速度、加速度和力。在该图像中，步骤1中的宇宙飞船具有 `(1, 3)` 的位置矢量和 `(2, 1)` 的速度矢量。速度矢量表示船舶每走一步移动的距离。我们可以通过将速度添加到当前位置来找到步骤 2 的位置。

> **提示：**
>
> 速度测量单位时间内位置的变化。新位置是通过将速度乘以经过的时间（这里假设为一个单位，例如 1s）与先前位置相加来找到的。
>
> 在典型的 2D 游戏场景中，您将获得以像素每秒为单位的速度，并将其乘以_process() 或 _physics_process() 回调中的 `delta` 参数（自上一帧以来经过的时间）。

##### 指向目标

在这个场景中，你有一辆坦克希望将炮塔指向机器人。从机器人的位置减去坦克的位置，得到从坦克指向机器人的矢量。

> **提示：**
>
> 要找到从 `A` 指向 `B` 的矢量，请使用 `B - A`。

#### 单位矢量

**大小**为 `1` 的向量称为**单位向量**。它们有时也称为**方向向量**或**法线**。当您需要跟踪某个方向时，单位向量非常有用。

##### 规范化

**规范化**向量意味着将其长度减少到 `1`，同时保留其方向。这是通过将其每个分量除以其大小来实现的。因为这是一个常见的操作，Godot 为此提供了一个专用的 normalized() 方法：

```python
a = a.normalized()
```

> **警告：**
>
> 由于规格化涉及除以向量的长度，因此无法规格化长度为 `0` 的向量。尝试这样做通常会导致错误。不过，在 GDScript 中，尝试对长度为 0 的向量调用 normalized() 方法会使值保持不变，从而避免出现错误。

##### 反射

单位向量的一个常见用途是指示**法线**。法向量是垂直于曲面排列的单位向量，定义曲面的方向。它们通常用于照明、碰撞和其他涉及曲面的操作。

例如，假设我们有一个移动的球，我们想从墙上或其他物体上反弹：

曲面法线的值为 `(0, -1)`，因为这是一个水平曲面。当球碰撞时，我们采取它的剩余运动（当它撞击表面时剩余的量），并使用法线反射它。在 Godot 中，有一个 bounce() 方法来处理这个问题。以下是使用 CharacterBody2D 的上图的代码示例：

```python
var collision: KinematicCollision2D = move_and_collide(velocity * delta)
if collision:
    var reflect = collision.get_remainder().bounce(collision.get_normal())
    velocity = velocity.bounce(collision.get_normal())
    move_and_collide(reflect)
```

#### 点积

**点积**是向量数学中最重要的概念之一，但经常被误解。点积是对两个向量的运算，返回一个**标量**。与同时包含大小和方向的矢量不同，标量值只有大小。

点积的公式有两种常见形式：

$A \cdot B = \left\| A \right\| \left\| B \right\| \cos \theta$

和

$A \cdot B = A_xB_x + A_yB_y$

数学符号 *||A||* 代表向量 `A` 的大小，Ax 表示向量 `A` 的 `x` 分量。

然而，在大多数情况下，使用内置的 dot() 方法是最容易的。请注意，两个向量的顺序并不重要：

```python
var c = a.dot(b)
var d = b.dot(a)  # These are equivalent.
```

当与单位向量一起使用时，点积是最有用的，使第一个公式简化为仅 `cos(θ)`。这意味着我们可以使用点积来告诉我们两个向量之间的角度：

使用单位向量时，结果将始终在 `-1`（180°）和 `1`（0°）之间。

##### 面向

我们可以利用这个事实来检测一个物体是否面向另一个物体。在下图中，玩家 `P` 试图避开僵尸 `A` 和僵尸 `B`。假设僵尸的视野是 **180°**，他们能看到玩家吗？

绿色箭头 `fA` 和 `fB` 是表示僵尸面向方向的**单位向量**，蓝色半圆表示其视野。对于僵尸 `A`，我们使用 `P - A` 找到指向玩家的方向向量 `AP`，并对其进行归一化，然而，Godot 有一个辅助方法，称为 direction_to()。如果这个矢量和对面矢量之间的角度小于 90°，那么僵尸可以看到玩家。

在代码中，它看起来是这样的：

```python
var AP = A.direction_to(P)
if AP.dot(fA) > 0:
    print("A sees P!")
```

#### 叉积

像点积一样，叉积是对两个向量的运算。然而，叉积的结果是一个方向垂直于两者的向量。它的大小取决于它们的相对角度。如果两个向量是平行的，那么它们的叉积的结果将是零向量。

$\left\| a \times b \right\| = \left\| a \right\| \left\| b \right\| \left| \sin(a, b) \right|$

叉积是这样计算的：

```python
var c = Vector3()
c.x = (a.y * b.z) - (a.z * b.y)
c.y = (a.z * b.x) - (a.x * b.z)
c.z = (a.x * b.y) - (a.y * b.x)
```

使用 Godot，您可以使用内置的 Vector3.cross() 方法：

```python
var c = a.cross(b)
```

叉积在 2D 中没有数学定义。Vector2.cross() 方法是 2D 向量的 3D 叉积的常用模拟方法。

> **注意：**
>
> 在交叉积中，顺序很重要。`a.cross(b)` 给出的结果与 `b.cross(a)` 不同。得到的向量指向**相反的**方向。

##### 计算法线

叉积的一个常见用途是在三维空间中找到平面或曲面的曲面法线。如果我们有三角形 `ABC`，我们可以使用向量减法来找到两条边 `AB` 和 `AC`。使用叉积，`AB × AC`产生一个垂直于这两条边的向量：曲面法线。

下面是一个计算三角形法线的函数：

```python
func get_triangle_normal(a, b, c):
    # Find the surface normal given 3 vertices.
    var side1 = b - a
    var side2 = c - a
    var normal = side1.cross(side2)
    return normal
```

##### 指向目标

在上面的点积部分，我们看到了如何使用它来找到两个向量之间的角度。然而，在 3D 中，这还不够。我们还需要知道围绕什么轴旋转。我们可以通过计算当前面向的方向和目标方向的叉积来发现这一点。得到的垂直矢量是旋转轴。

#### 更多信息

有关在 Godot 中使用矢量数学的更多信息，请参阅以下文章：

- 高级矢量数学
- 矩阵与变换

### 高级向量数学

#### 平面

点积在单位向量上还有另一个有趣的性质。想象一下，垂直于该向量（并通过原点）经过一个平面。平面将整个空间分为正（平面上）和负（平面下），（与流行的观点相反）你也可以在 2D 中使用它们的数学：

垂直于曲面的单位向量（因此，它们描述曲面的方向）称为**单位法线向量**。不过，通常它们只是缩写为法线。法线出现在平面、三维几何体（用于确定每个面或顶点的侧边位置）等中。**法线**是一个**单位向量**，但由于其用途，它被称为法线。（就像我们称 (0, 0) 为原点！）。

平面经过原点，其表面垂直于单位向量（或法线）。向量指向的一侧是正半空间，而另一侧是负半空间。在 3D 中，这是完全相同的，只是平面是一个无限曲面（想象一张无限平的纸，你可以确定方向并固定到原点），而不是一条线。

##### 到平面的距离

既然平面是什么已经很清楚了，让我们回到点积。**单位向量**和**空间中任意点**之间的点积（是的，这次我们在向量和位置之间做点积），返回**从点到平面的距离**：

```python
var distance = normal.dot(point)
```

但不仅仅是绝对距离，如果点在负半空间中，距离也将是负的：

这使我们能够判断一个点在平面的哪一边。

##### 远离原点

我知道你在想什么！到目前为止，这很好，但*真实的*平面在空间中无处不在，不仅仅是穿过原点。你想要真正的*平面*动作，你*现在*就想要。

请记住，平面不仅将空间一分为二，而且它们还具有*极性*。这意味着可以有完全重叠的平面，但它们的负半空间和正半空间是交换的。

考虑到这一点，让我们将全平面描述为**法线** N 和**与原点**标量 D **的距离**。因此，我们的平面由 N 和 D 表示。例如：

对于三维数学，Godot 提供了一个 Plane 内置类型来处理此问题。

基本上，N 和 D 可以表示空间中的任何平面，无论是 2D 平面还是 3D 平面（取决于 N 的维数），两者的数学运算都是相同的。它和以前一样，但 D 是从原点到平面的距离，沿 N 方向行进。举个例子，假设你想到达平面上的一个点，你只需要做：

```python
var point_in_plane = N*D
```

这将拉伸（调整大小）法向量并使其接触平面。这个数学可能看起来很混乱，但实际上比看起来简单得多。如果我们想再次说明从点到平面的距离，我们也可以这样做，但要调整距离：

```python
var distance = N.dot(point) - D
```

同样，使用内置函数：

```python
var distance = plane.distance_to(point)
```

这将再次返回正距离或负距离。

翻转平面的极性可以通过否定 N 和 D 来完成。这将导致平面处于相同位置，但具有倒置的负半空间和正半空间：

```python
N = -N
D = -D
```

Godot 还在 Plane 中实现了这个运算符。因此，使用以下格式将按预期工作：

```python
var inverted_plane = -plane
```

记住，平面的主要实际用途是我们可以计算到它的距离。那么，什么时候计算从一点到平面的距离有用呢？让我们看一些例子。

##### 在 2D 中构造平面

飞机显然不是凭空产生的，所以必须建造。在 2D 中构建它们很容易，这可以从一个法线（单位向量）和一个点，或者从空间中的两个点来完成。

在一个法线和一个点的情况下，大部分的功都完成了，因为法线已经计算好了，所以从法线和点的点积计算 D。

```python
var N = normal
var D = normal.dot(point)
```

对于空间中的两个点，实际上有两个平面穿过它们，共享相同的空间，但法线指向相反的方向。要从两个点计算法线，必须首先获得方向向量，然后需要将其向任意一侧旋转 90°：

```python
# Calculate vector from `a` to `b`.
var dvec = (point_b - point_a).normalized()
# Rotate 90 degrees.
var normal = Vector2(dvec.y, -dvec.x)
# Alternatively (depending the desired side of the normal):
# var normal = Vector2(-dvec.y, dvec.x)
```

其余部分与前面的示例相同。point_a 或 point_b 都可以工作，因为它们位于同一平面中：

```python
var N = normal
var D = normal.dot(point_a)
# this works the same
# var D = normal.dot(point_b)
```

在 3D 中做同样的事情稍微复杂一些，下面将进一步解释。

##### 平面的一些例子

下面是一个平面有用的例子。假设你有一个凸多边形。例如，矩形、梯形、三角形或任何没有面向内弯曲的多边形。

对于多边形的每一段，我们计算经过该段的平面。一旦我们有了平面列表，我们就可以做一些简单的事情，例如检查一个点是否在多边形内。

我们遍历所有平面，如果我们能找到一个到点的距离为正的平面，那么该点就在多边形之外。如果我们做不到，那么问题就在内部。

代码应该是这样的：

```python
var inside = true
for p in planes:
    # check if distance to plane is positive
    if (p.distance_to(point) > 0):
        inside = false
        break # with one that fails, it's enough
```

很酷吧？但情况好多了！只要再努力一点，类似的逻辑就会让我们知道两个凸多边形何时也重叠。这被称为分离轴定理（SAT），大多数物理引擎都使用它来检测碰撞。

对于一个点，只需检查平面是否返回正距离就足以判断该点是否在外部。对于另一个多边形，我们必须找到一个*所有其他多边形点*都返回正距离的平面。此检查是用 A 的平面对 B 的点执行的，然后用 B 的平面对 A 的点执行：

代码应该是这样的：

```python
var overlapping = true

for p in planes_of_A:
    var all_out = true
    for v in points_of_B:
        if (p.distance_to(v) < 0):
            all_out = false
            break

    if (all_out):
        # a separating plane was found
        # do not continue testing
        overlapping = false
        break

if (overlapping):
    # only do this check if no separating plane
    # was found in planes of A
    for p in planes_of_B:
        var all_out = true
        for v in points_of_A:
            if (p.distance_to(v) < 0):
                all_out = false
                break

        if (all_out):
            overlapping = false
            break

if (overlapping):
    print("Polygons Collided!")
```

正如你所看到的，飞机非常有用，而这只是冰山一角。您可能想知道非凸多边形会发生什么。这通常只是通过将凹多边形拆分为较小的凸多边形来处理，或者使用诸如 BSP 之类的技术（现在很少使用）。

#### 3D 中的碰撞检测

这是另一个额外的奖励，是对耐心和跟上这篇长教程的奖励。这是另一条智慧。这可能不是一个直接的用例（Godot 已经很好地进行了碰撞检测），但几乎所有的物理引擎和碰撞检测库都使用它 :)

还记得将 2D 中的凸形转换为 2D 平面阵列对于碰撞检测很有用吗？您可以检测一个点是否在任何凸形内，或者两个 2D 凸形是否重叠。

好吧，这在 3D 中也适用，如果两个 3D 多面体形状碰撞，你将无法找到分离平面。如果找到了一个分离平面，那么这些形状肯定不会碰撞。

为了刷新一点，分离平面意味着多边形 A 的所有顶点都在平面的一侧，而多边形 B 的所有顶点在另一侧。该平面始终是多边形 A 或多边形 B 的面平面之一。

然而，在 3D 中，这种方法存在问题，因为在某些情况下可能找不到分离平面。这就是这种情况的一个例子：

为了避免这种情况，需要测试一些额外的平面作为分隔符，这些平面是多边形 A 的边和多边形 B 的边之间的叉积

所以最后的算法是这样的：

```python
var overlapping = true

for p in planes_of_A:
    var all_out = true
    for v in points_of_B:
        if (p.distance_to(v) < 0):
            all_out = false
            break

    if (all_out):
        # a separating plane was found
        # do not continue testing
        overlapping = false
        break

if (overlapping):
    # only do this check if no separating plane
    # was found in planes of A
    for p in planes_of_B:
        var all_out = true
        for v in points_of_A:
            if (p.distance_to(v) < 0):
                all_out = false
                break

        if (all_out):
            overlapping = false
            break

if (overlapping):
    for ea in edges_of_A:
        for eb in edges_of_B:
            var n = ea.cross(eb)
            if (n.length() == 0):
                continue

            var max_A = -1e20 # tiny number
            var min_A = 1e20 # huge number

            # we are using the dot product directly
            # so we can map a maximum and minimum range
            # for each polygon, then check if they
            # overlap.

            for v in points_of_A:
                var d = n.dot(v)
                max_A = max(max_A, d)
                min_A = min(min_A, d)

            var max_B = -1e20 # tiny number
            var min_B = 1e20 # huge number

            for v in points_of_B:
                var d = n.dot(v)
                max_B = max(max_B, d)
                min_B = min(min_B, d)

            if (min_A > max_B or min_B > max_A):
                # not overlapping!
                overlapping = false
                break

        if (not overlapping):
            break

if (overlapping):
   print("Polygons collided!")
```

#### 更多信息

有关在 Godot 中使用向量数学的更多信息，请参阅以下文章：

- 矩阵与变换

如果您想要更多的解释，您应该查看 3Blue1Brown 的优秀视频系列“线性代数的本质”：https://www.youtube.com/watch?v=fNk_zzaMoSs&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab

### 矩阵与变换

#### 简介

在阅读本教程之前，我们建议您彻底阅读并理解矢量数学教程，因为本教程需要矢量知识。

本教程是关于*转换*以及我们如何在 Godot 中使用矩阵来表示它们。它并不是矩阵的全面深入指南。变换在大多数情况下应用为平移、旋转和缩放，因此我们将重点讨论如何用矩阵表示这些变换。

本指南的大部分内容都集中在 2D 上，使用 Transform2D 和 Vector2，但 3D 中的工作方式非常相似。

> **注意：**
>
> 如前一教程中所述，重要的是要记住，在 Godot 中，Y 轴在 2D 中向下指向。这与大多数学校教授线性代数的方式相反，Y 轴指向上。

> **注意：**
>
> 惯例是 X 轴为红色，Y 轴为绿色，Z 轴为蓝色。本教程的颜色编码与这些约定相匹配，但我们也将用蓝色表示原点向量。

##### 矩阵分量与恒等矩阵

单位矩阵表示没有平移、没有旋转和没有缩放的变换。让我们先来看看单位矩阵，以及它的组成部分与它的视觉表现之间的关系。

矩阵有行和列，变换矩阵对每个矩阵的作用有特定的约定。

在上面的图像中，我们可以看到红色的 X 矢量由矩阵的第一列表示，绿色的 Y 矢量同样由第二列表示。对列的更改将更改这些向量。我们将在接下来的几个例子中看到它们是如何被操纵的。

您不应该担心直接操作行，因为我们通常处理列。然而，您可以将矩阵的行视为显示哪些向量有助于在给定方向上移动。

当我们引用诸如 *t.x.y* 之类的值时，它是 X 列向量的 Y 分量。换句话说，矩阵的左下角。类似地，*t.x.x* 是左上角，*t.y.x* 是右上角，而 *t.y.y* 是右下角，其中 *t* 是 Transform2D。

##### 缩放变换矩阵

应用量表是最容易理解的操作之一。让我们首先将 Godot 标志放在向量下面，这样我们就可以直观地看到对象上的效果：

现在，要缩放矩阵，我们所需要做的就是将每个分量乘以我们想要的缩放比例。让我们把它放大 2。1 乘以 2 变成 2，0 乘以 2 变成 0，所以我们得出这样的结论：

为了在代码中做到这一点，我们将每个向量相乘：

```python
var t = Transform2D()
# Scale
t.x *= 2
t.y *= 2
transform = t # Change the node's transform to what we calculated.
```

如果我们想将其恢复到原始比例，我们可以将每个分量乘以 0.5。这几乎就是缩放变换矩阵的全部内容。

要根据现有的变换矩阵计算对象的比例，可以对每个列向量使用 `length()`。

> **注意：**
>
> 在实际项目中，可以使用 `scaled()` 方法来执行缩放。

##### 旋转变换矩阵

我们将以与前面相同的方式开始，在身份矩阵下面添加 Godot 标志：

举个例子，假设我们想将 Godot 徽标顺时针旋转 90 度。现在，X 轴指向右侧，Y 轴指向下方。如果我们在脑海中旋转这些，我们会从逻辑上看到新的 X 轴应该指向下方，新的 Y 轴应该指向左侧。

你可以想象，你抓住 Godot 标志和它的矢量，然后围绕中心旋转。无论您在哪里完成旋转，向量的方向都决定了矩阵是什么。

我们需要在法线坐标中表示“向下”和“向左”，这意味着我们将 X 设置为 (0, 1)，将 Y 设置为 (-1, 0)。这些也是 `Vector2.DOWN` 和 `Vector2.LEFT` 的值。当我们这样做时，我们会得到旋转对象所需的结果：

如果你在理解上面的内容时有困难，可以试试这个练习：剪一张正方形的纸，在上面画 X 和 Y 向量，把它放在图形纸上，然后旋转它并记下端点。

要在代码中执行旋转，我们需要能够以编程方式计算这些值。此图显示了从旋转角度计算变换矩阵所需的公式。如果这部分看起来很复杂，不要担心，我保证这是你需要知道的最难的事情。

> **注意：**
>
> Godot 用弧度而不是度数表示所有旋转。一整圈是 *TAU* 或 *PI*2* 弧度，而 90 度的四分之一圈是 *TAU/4* 或 *PI/2* 弧度。使用 *TAU* 通常会产生可读性更强的代码。

> **注意：**
>
> 有趣的事实：除了在 Godot 中 Y *向下*，旋转是顺时针表示的。这意味着所有的数学和 trig 函数的行为与 Y-is-up CCW 系统相同，因为这些差异“抵消”了。你可以把两个系统中的旋转都看作是“从 X 到 Y”。

为了执行 0.5 弧度（约 28.65 度）的旋转，我们将 0.5 的值代入上述公式，并进行评估，以找到实际值：

以下是如何在代码中完成的（将脚本放在 Node2D 上）：

```python
var rot = 0.5 # The rotation to apply.
var t = Transform2D()
t.x.x = cos(rot)
t.y.y = cos(rot)
t.x.y = sin(rot)
t.y.x = -sin(rot)
transform = t # Change the node's transform to what we calculated.
```

若要根据现有变换矩阵计算对象的旋转，可以使用 `atan2(t.x.y，t.x.x)`，其中 t 是 Transform2D。

> **注意：**
>
> 在实际项目中，可以使用 `rotated()` 方法执行旋转。

##### 变换矩阵的基础

到目前为止，我们只研究了 *x* 和 *y*，向量，它们负责表示旋转、缩放和/或剪切（高级，最后介绍）。X 和 Y 向量一起被称为变换矩阵的基。“基”和“基向量”这两个术语很重要。
您可能已经注意到 Transform2D 实际上有三个 Vector2 值：`x`、`y` 和 `origin`。`origin` 不是基础的一部分，但它是变换的一部分。我们需要它来表示位置。从现在起，我们将跟踪所有示例中的原点向量。你可以将起源视为另一个专栏，但通常最好将其视为完全独立的。

请注意，在 3D 中，Godot 有一个单独的 Basis 结构，用于保存基的三个 Vector3 值，因为代码可能会变得复杂，并且将其与 Transform3D（由一个 Basis 和一个额外的 Vector3 组成）分离是有意义的。

##### 转换转换矩阵

改变 `origin` 向量称为平移变换矩阵。平移基本上是一个“移动”物体的技术术语，但它明确不涉及任何旋转。

让我们通过一个例子来帮助理解这一点。我们将像上次一样从恒等式变换开始，只是这次我们将跟踪原点向量。

如果我们想将对象移动到 (1, 2) 的位置，我们需要将其 `origin` 向量设置为 (1, 2) 中：

还有一个 `translated()` 方法，它执行与直接添加或更改 `origin` 不同的操作。`translated()` 方法将*相对于对象自身的旋转*平移对象。例如，当使用 `Vector2.UP` 调用 `translated()` 时，顺时针旋转 90 度的对象将向右移动。

> **注意：**
>
> Godot 的 2D 使用基于像素的坐标，因此在实际项目中，您需要平移数百个单位。

##### 综合起来

我们将把迄今为止提到的所有内容应用到一个变换上。接下来，使用 Sprite2D 节点创建一个项目，并使用 Godot 徽标作为纹理资源。

让我们将平移设置为 (350, 150)，旋转 -0.5 弧度，缩放 3。我发布了一张截图，以及复制它的代码，但我鼓励你尝试在不看代码的情况下复制截图！

```python
var t = Transform2D()
# Translation
t.origin = Vector2(350, 150)
# Rotation
var rot = -0.5 # The rotation to apply.
t.x.x = cos(rot)
t.y.y = cos(rot)
t.x.y = sin(rot)
t.y.x = -sin(rot)
# Scale
t.x *= 3
t.y *= 3
transform = t # Change the node's transform to what we calculated.
```

##### 剪切变换矩阵（高级）

> **注意：**
>
> 如果您只是想了解如何*使用*变换矩阵，请随意跳过本教程的这一部分。本节探讨了变换矩阵的一个不常见的方面，目的是建立对它们的理解。
>
> Node2D 提供了开箱即用的剪切特性。

您可能已经注意到，变换比上述动作的组合具有更多的自由度。2D 变换矩阵的基础在两个 Vector2 值中总共有四个数字，而旋转值和缩放的 Vector2 只有 3 个数字。缺失自由度的高级概念被称为剪切。

通常情况下，基本向量总是相互垂直。但是，剪切在某些情况下可能很有用，了解剪切可以帮助您了解变换是如何工作的。

为了直观地向您展示它的外观，让我们在 Godot 徽标上覆盖一个网格：

该网格上的每个点都是通过将基向量相加而获得的。右下角是 X + Y，而右上角是 X - Y。如果我们改变基向量，整个网格都会随之移动，因为网格是由基向量组成的。无论我们对基向量做什么更改，网格上当前平行的所有线都将保持平行。

例如，让我们将 Y 设置为 (1, 1)：

```python
var t = Transform2D()
# Shear by setting Y to (1, 1)
t.y = Vector2.ONE
transform = t # Change the node's transform to what we calculated.
```

> **注意：**
>
> 不能在编辑器中设置 Transform2D 的原始值，因此如果要剪切对象，则*必须*使用代码。

由于矢量不再垂直，对象已被剪切。栅格的底部中心（相对于自身为 (0, 1)）现在位于 (1, 1) 的世界位置。

对象内坐标在纹理中被称为 UV 坐标，所以让我们借用这个术语。要从相对位置找到世界位置，公式为 U * X + V * Y，其中 U 和 V 是数字，X 和 Y 是基向量。

栅格的右下角始终位于 UV 位置 (1, 1) 处，位于世界位置 (2, 1)，该位置是根据 X * 1 + Y * 1 计算得出的，即 (1, 0) + (1, 1)、或 (1 + 1, 0 + 1) 或 (2, 1)。这与我们观察到的图像右下角的位置相吻合。

类似地，始终位于 UV 位置 (1, -1) 的栅格的右上角位于世界位置 (0, -1)，该位置是根据 X * 1 + Y * -1 计算的，即 (1, 0) - (1, 1)、或 (1 - 1, 0 - 1) 或 (0, -1)。这与我们观察到的图像右上角的位置相吻合。

希望您现在能够完全理解变换矩阵如何影响对象，以及基向量之间的关系，以及对象的 “UV” 或“内部坐标”如何改变其世界位置。

> **注意：**
>
> 在 Godot 中，所有变换数学运算都是相对于父节点进行的。当我们提到“世界位置”时，如果节点有父节点，那么它将相对于节点的父节点。

如果您想了解更多解释，请查看 3Blue1Brown 关于线性变换的精彩视频：https://www.youtube.com/watch?v=kYB8IZa5AuE

#### 变换的实际应用

在实际项目中，通常通过将多个 Node2D 或 Node3D 节点作为彼此的父节点来处理变换内部的变换。

然而，了解如何手动计算我们需要的值是很有用的。我们将介绍如何使用 Transform2D 或 Transform3D 手动计算节点的变换。

##### 转换变换之间的位置

在许多情况下，您希望在变换中转换位置和从变换中转换出位置。例如，如果您有一个相对于玩家的位置，并希望找到世界（父相对）位置，或者如果您有世界位置，并想知道它相对于玩家的相对位置。

我们可以使用 `*` 运算符找到在世界空间中相对于玩家的向量的定义：

```python
# World space vector 100 units below the player.
print(transform * Vector2(0, 100))
```

我们可以按相反的顺序使用 `*` 运算符来找到一个世界空间位置，如果它是相对于玩家定义的：

```python
# Where is (0, 100) relative to the player?
print(Vector2(0, 100) * transform)
```

> **注意：**
>
> 如果您事先知道变换位于 (0, 0)，则可以使用 “basis_xform” 或 “basis_xform_inv” 方法，这些方法可以跳过处理转换。

##### 相对于自身移动对象

一种常见的操作，尤其是在 3D 游戏中，是相对于物体本身移动物体。例如，在第一人称射击游戏中，按 `W` 时，您希望角色向前移动（-Z 轴）。

由于基向量是相对于父对象的方向，而原点向量是相对于其父对象的位置，因此我们可以将基向量的倍数相加，以相对于对象本身移动对象。

此代码将一个对象向右移动 100 个单位：

```python
transform.origin += transform.x * 100
```

对于在三维中移动，您需要将 “x” 替换为 “based.x”。

> **注意：**
>
> 在实际项目中，可以在三维中使用 `translate_object_local` 或在二维中使用 `move_local_x` 和 `move_local_y` 来执行此操作。

##### 将变换应用于变换

关于变换，需要了解的最重要的一点是如何将其中的几个变换一起使用。父节点的变换会影响其所有子节点。让我们剖析一个例子。

在该图中，子节点在组件名称后面有一个“2”，以将它们与父节点区分开来。这么多数字可能看起来有点让人不知所措，但请记住，每个数字都显示两次（在箭头旁边和矩阵中），而且几乎一半的数字都是零。

这里进行的唯一转换是，父节点被赋予了 (2, 1) 的比例，子节点被赋予 (0.5, 0.5) 的比例并且两个节点都被赋予了位置。

所有子变换都受父变换的影响。子对象的比例为 (0.5, 0.5)，因此您希望它是 1:1 的比例平方，而且它确实是，但仅相对于父对象。子对象的 X 向量最终在世界空间中为 (1, 0)，因为它是由父对象的基向量缩放的。类似地，子节点的 `origin` 向量设置为 (1, 1)，但由于父节点的基向量，这实际上会在世界空间中移动它 (2, 1)。

要手动计算子变换的世界空间变换，我们将使用以下代码：

```python
# Set up transforms like in the image, except make positions be 100 times bigger.
var parent = Transform2D(Vector2(2, 0), Vector2(0, 1), Vector2(100, 200))
var child = Transform2D(Vector2(0.5, 0), Vector2(0, 0.5), Vector2(100, 100))

# Calculate the child's world space transform
# origin = (2, 0) * 100 + (0, 1) * 100 + (100, 200)
var origin = parent.x * child.origin.x + parent.y * child.origin.y + parent.origin
# basis_x = (2, 0) * 0.5 + (0, 1) * 0
var basis_x = parent.x * child.x.x + parent.y * child.x.y
# basis_y = (2, 0) * 0 + (0, 1) * 0.5
var basis_y = parent.x * child.y.x + parent.y * child.y.y

# Change the node's transform to what we calculated.
transform = Transform2D(basis_x, basis_y, origin)
```

在实际项目中，我们可以通过使用 `*` 运算符将一个变换应用于另一个变换来找到子对象的世界变换：

```python
# Set up transforms like in the image, except make positions be 100 times bigger.
var parent = Transform2D(Vector2(2, 0), Vector2(0, 1), Vector2(100, 200))
var child = Transform2D(Vector2(0.5, 0), Vector2(0, 0.5), Vector2(100, 100))

# Change the node's transform to what would be the child's world transform.
transform = parent * child
```

> **注意：**
>
> 矩阵相乘时，顺序很重要！不要把它们弄混。

最后，应用身份转换始终不会起到任何作用。

如果您想了解更多解释，请查看 3Blue1Brown 关于矩阵组成的精彩视频：https://www.youtube.com/watch?v=XkY2DOUCWMU

##### 反转变换矩阵

“affine_inverse” 函数返回一个“撤消”上一个变换的变换。这在某些情况下可能很有用。让我们来看看几个例子。

将逆变换与法线变换相乘将撤消所有变换：

```python
var ti = transform.affine_inverse()
var t = ti * transform
# The transform is the identity transform.
```

通过变换及其逆变换对位置进行变换会得到相同的位置：

```python
var ti = transform.affine_inverse()
position = transform * position
position = ti * position
# The position is the same as before.
```

#### 这一切是如何在 3D 中工作的？

变换矩阵的一大优点是，它们在 2D 和 3D 变换之间的工作方式非常相似。上面用于 2D 的所有代码和公式在 3D 中都是一样的，除了 3 个例外：添加了第三个轴，每个轴的类型都是 Vector3，而且 Godot 将 Basis 与 Transform3D 分开存储，因为数学可能会变得复杂，将其分开是有意义的。

与 2D 相比，3D 中平移、旋转、缩放和剪切的所有概念都是相同的。为了进行缩放，我们取每个分量并将其相乘；为了旋转，我们改变每个基向量指向的位置；为了变换，我们操纵原点；对于剪切，我们将基向量改变为非垂直的。

如果你愿意的话，玩转换是一个好主意，以了解它们是如何工作的。Godot 允许您直接从检查器编辑三维变换矩阵。您可以下载这个项目，它有彩色的线和立方体，以帮助在二维和三维中可视化基本矢量和原点：https://github.com/godotengine/godot-demo-projects/tree/master/misc/matrix_transform

> **注意：**
>
> 您不能在 Godot 4.0 的检查器中直接编辑 Node2D 的变换矩阵。这一点可能会在 Godot 的未来版本中有所改变。

如果您想了解更多解释，请查看 3Blue1Brown 关于 3D 线性变换的精彩视频：https://www.youtube.com/watch?v=rHLEWRxRGiM

##### 以 3D 表示旋转（高级）

二维和三维变换矩阵之间最大的区别是如何在没有基向量的情况下单独表示旋转。

对于 2D，我们有一种简单的方法（atan2）在变换矩阵和角度之间切换。在三维中，旋转过于复杂，无法表示为一个数字。有一种叫做欧拉角的东西，它可以将旋转表示为一组 3 个数字，然而，除了琐碎的情况外，它们是有限的，也不是很有用。

在 3D 中，我们通常不使用角度，我们要么使用变换基（在 Godot 中几乎到处都使用），要么使用四元数。Godot 可以使用四元数结构来表示四元数。我给你的建议是完全忽略它们是如何在引擎盖下工作的，因为它们非常复杂和不直观。

然而，如果你真的必须知道它是如何工作的，这里有一些很棒的资源，你可以按顺序遵循：
https://www.youtube.com/watch?v=mvmuCPvRoWQ
https://www.youtube.com/watch?v=d4EgbgTm0Bg
https://eater.net/quaternions

### 插值

插值是图形编程中非常基本的操作。熟悉它是件好事，这样可以拓展你作为图形开发人员的视野。

基本思想是，您希望从 A 转换到 B。值 `t` 表示介于两者之间的状态。

例如，如果 `t` 是 0，则状态是 A。如果 `t` 是 1，则状态为 B。介于两者之间的任何东西都是*插值*。

在两个实数（浮点）之间，插值可以描述为：

```python
interpolation = A * (1 - t) + B * t
```

并经常简写成：

```python
interpolation = A + (B - A) * t
```

这种以*恒定速度*将一个值转换为另一个值的插值的名称是“*线性*”。所以，当你听说*线性插值*时，你知道他们指的是这个公式。

还有其他类型的插值，这里不涉及。之后推荐阅读 Bezier 页面。

#### 矢量插值

向量类型（Vector2 和 Vector3）也可以进行插值，它们附带了方便的函数 Vector2.lerp() 和 Vector3.lerp()。

对于三次插值，还有 Vector2.cubic_interpolate() 和 Vector3.cubic_interpolate()，它们执行贝塞尔风格的插值。

以下是使用插值从点 A 到点 B 的伪代码示例：

```python
var t = 0.0

func _physics_process(delta):
    t += delta * 0.4

    $Sprite2D.position = $A.position.lerp($B.position, t)
```

它将产生以下运动：

#### 变换插值

也可以对整个变换进行插值（确保它们具有均匀的比例，或者至少具有相同的非均匀比例）。为此，可以使用函数 Transform3D.interpole_with()。

以下是将猴子从位置 1 转换为位置 2 的示例：

使用如下伪代码：

```python
var t = 0.0

func _physics_process(delta):
    t += delta

    $Monkey.transform = $Position1.transform.interpolate_with($Position2.transform, t)
```

再一次，它生成如下运动：

#### 平滑运动

插值可用于平滑移动、旋转等。以下是使用平滑运动跟随鼠标的圆的示例：

```python
const FOLLOW_SPEED = 4.0

func _physics_process(delta):
    var mouse_pos = get_local_mouse_position()

    $Sprite2D.position = $Sprite2D.position.lerp(mouse_pos, delta * FOLLOW_SPEED)
```

这是它看上去的样子：

这对于平滑相机移动、盟友跟随你（确保他们保持在一定范围内）以及许多其他常见的游戏模式非常有用。

### 贝塞尔、曲线和路径

贝塞尔曲线是自然几何形状的数学近似。我们使用它们来表示一条信息尽可能少且具有高度灵活性的曲线。

与更抽象的数学概念不同，贝塞尔曲线是为工业设计而创建的。它们是图形软件行业中流行的工具。

它们依赖于插值，正如我们在上一篇文章中看到的那样，将多个步骤结合起来创建平滑的曲线。为了更好地理解贝塞尔曲线是如何工作的，让我们从它最简单的形式开始：二次贝塞尔曲线。

#### 二次贝塞尔

取三点，二次贝塞尔函数工作所需的最小值：

为了在它们之间绘制曲线，我们首先在由三个点形成的两个线段中的每个线段的两个顶点上逐渐插值，使用范围从 0 到 1 的值。当我们将 `t` 的值从 0 更改为 1 时，这给了我们两个沿着线段移动的点。

```python
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
    var q0 = p0.lerp(p1, t)
    var q1 = p1.lerp(p2, t)
```

然后，我们对 `q0` 和 `q1` 进行插值，以获得沿着曲线移动的单个点 `r`。

```python
var r = q0.lerp(q1, t)
return r
```

这种类型的曲线称为二次贝塞尔曲线。

#### 三次贝塞尔

在前面的例子的基础上，我们可以通过在四个点之间进行插值来获得更多的控制。

我们首先使用具有四个参数的函数，以四个点作为输入，`p0`、`p1`、`p2` 和 `p3`：

```python
func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
```

我们对每对点应用线性插值，将它们减少为三个：

```python
var q0 = p0.lerp(p1, t)
var q1 = p1.lerp(p2, t)
var q2 = p2.lerp(p3, t)
```

然后，我们将我们的三点归结为两点：

```python
var r0 = q0.lerp(q1, t)
var r1 = q1.lerp(q2, t)
```

再归为一点：

```python
var s = r0.lerp(r1, t)
return s
```

这是整个函数：

```python
func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
    var q0 = p0.lerp(p1, t)
    var q1 = p1.lerp(p2, t)
    var q2 = p2.lerp(p3, t)

    var r0 = q0.lerp(q1, t)
    var r1 = q1.lerp(q2, t)

    var s = r0.lerp(r1, t)
    return s
```

结果将是在所有四个点之间插值的平滑曲线：

> **注意：**
>
> 三次贝塞尔插值在三维中的作用相同，只需使用 Vector3 而不是 Vector2。

#### 添加控制点

基于三次贝塞尔，我们可以改变其中两个点的工作方式，以自由控制曲线的形状。相比于有 `p0`、`p1`、`p2` 和 `p3`，我们将它们存储为：

- `point0 = p0`：是第一个点，即源
- `control0 = p1 - p0`：是相对于第一个控制点的矢量
- `control1 = p3 - p2`：是相对于第二个控制点的矢量
- `point1 = p3`：是第二个点，即目的地

通过这种方式，我们有两个点和两个控制点，它们是各自点的相对向量。如果您以前使用过图形或动画软件，这可能看起来很熟悉：

这就是图形软件向用户呈现贝塞尔曲线的方式，以及它们在 Godot 中的工作和外观。

#### Curve2D、Curve3D、Path 和 Path2D

有两个对象包含曲线：Curve3D 和 Curve2D（分别用于 3D 和 2D）。

它们可以包含多个点，从而允许更长的路径。也可以将它们设置为节点：Path3D 和 Path2D（也可以分别用于 3D 和 2D）：

然而，使用它们可能并不完全显而易见，所以下面是对贝塞尔曲线最常见的用例的描述。

#### 评估

只评估它们可能是一种选择，但在大多数情况下，这并不是很有用。Bezier 曲线的最大缺点是，如果以恒定速度遍历它们，从 `t=0` 到 `t=1`，实际插值将不会以恒定速度移动。速度也是点 `p0`、`p1`、`p2` 和 `p3` 之间的距离之间的插值，并且没有以恒定速度遍历曲线的数学上简单的方法。

让我们用以下伪代码做一个示例：

```python
var t = 0.0

func _process(delta):
    t += delta
    position = _cubic_bezier(p0, p1, p2, p3, t)
```

正如你所看到的，即使t以恒定的速度增加，圆的速度（以每秒像素为单位）也会发生变化。这使得边框很难用于任何开箱即用的实用工具。

#### 绘制

绘制边框（或基于曲线的对象）是一个非常常见的用例，但这也不容易。几乎在任何情况下，贝塞尔曲线都需要转换为某种线段。然而，如果不产生非常高的数量，这通常是困难的。

原因是曲线的某些部分（特别是拐角）可能需要大量的点，而其他部分可能不需要：

此外，如果两个控制点都是 `0, 0`（记住它们是相对向量），则贝塞尔曲线将只是一条直线（因此绘制大量点将是浪费的）。

在绘制贝塞尔曲线之前，需要进行*镶嵌*。这通常是通过递归或分治函数来完成的，该函数分割曲线，直到曲率量小于某个阈值。

*Curve* 类通过 Curve2D.steslate() 函数（该函数接收递归和角度 `tolerance` 参数的可选 `stages`）提供这一点。这样，基于曲线绘制东西更容易。

#### 遍历

曲线的最后一个常见用例是遍历它们。由于前面提到的恒速，这也是很困难的。

为了更容易做到这一点，需要将曲线烘焙成等距点。这样，它们可以用正则插值来近似（可以用三次选项进一步改进）。要做到这一点，只需将 Curve3D.sample_baked() 方法与 Curve2D.get_baked_length() 一起使用即可。对其中任何一个的第一次调用都会在内部烘焙曲线。

那么，可以使用以下伪代码以恒定速度进行遍历：

```python
var t = 0.0

func _process(delta):
    t += delta
    position = curve.sample_baked(t * curve.get_baked_length(), true)
```

然后，输出将以恒定速度移动：

### 随机数生成

许多游戏依靠随机性来实现核心游戏机制。本页指导您了解常见类型的随机性，以及如何在 Godot 中实现它们。

在简要概述了生成随机数的有用函数后，您将了解如何从数组、字典中获取随机元素，以及如何在 GDScript 中使用噪声生成器。

> **注意：**
>
> 计算机无法生成“真实”的随机数。相反，它们依赖于伪随机数生成器（PRNG）。

#### 全局作用域与 RandomNumberGenerator 类

Godot 公开了两种生成随机数的方法：通过全局范围方法或使用 RandomNumberGenerator 类。

全局范围方法更容易设置，但它们不能提供那么多控制。

RandomNumberGenerator 需要更多的代码来使用，但允许创建多个实例，每个实例都有自己的种子和状态。

本教程使用全局范围方法，除非该方法仅存在于 RandomNumberGenerator 类中。

#### randomize() 方法

在全局范围内，您可以找到一个 randomize() 方法。**当项目开始初始化随机种子时，只应调用一次此方法。**多次调用它是不必要的，可能会对性能产生负面影响。

将其放在主场景脚本的 `_ready()` 方法中是一个不错的选择：

```python
func _ready():
    randomize()
```

您也可以使用 seed() 设置固定的随机种子。这样做将使您在运行过程中获得*确定性*结果：

```python
func _ready():
    seed(12345)
    # To use a string as a seed, you can hash it to a number.
    seed("Hello world".hash())
```

使用 RandomNumberGenerator 类时，应该对实例调用 `randomize()`，因为它有自己的种子：

```python
var random = RandomNumberGenerator.new()
random.randomize()
```

#### 获取随机数

让我们来看看 Godot 中生成随机数的一些最常用的函数和方法。

函数 randi() 返回一个介于 0 和 2^32-1 之间的随机数。由于最大值是巨大的，您很可能希望使用模运算符（`%`）将结果绑定在 0 和分母之间：

```python
# Prints a random integer between 0 and 49.
print(randi() % 50)

# Prints a random integer between 10 and 60.
print(randi() % 51 + 10)
```

randf() 返回一个介于 0 和 1 之间的随机浮点数。这对于实现加权随机概率系统等是有用的。

randfn() 返回一个遵循正态分布的随机浮点数。这意味着返回的值更有可能在平均值（默认值为 0.0）附近，随偏差（默认值 1.0）而变化：

```python
# Prints a random floating-point number from a normal distribution with a mean 0.0 and deviation 1.0.
var random = RandomNumberGenerator.new()
random.randomize()
print(random.randfn())
```

randf_range() 接受 `from` 和 `to` 两个参数，并返回一个介于 `from` 和 `to` 之间的随机浮点数：

```python
# Prints a random floating-point number between -4 and 6.5.
print(randf_range(-4, 6.5))
```

RandomNumberGenerator.randi_range() 接受 `from` 和 `to` 两个参数，并返回一个介于 `from` 和 `to` 之间的随机整数：

```python
# Prints a random integer between -10 and 10.
var random = RandomNumberGenerator.new()
random.randomize()
print(random.randi_range(-10, 10))
```

#### 获取一个随机数组元素

我们可以使用随机整数生成来从数组中获取随机元素：

```python
var _fruits = ["apple", "orange", "pear", "banana"]

func _ready():
    randomize()

    for i in range(100):
        # Pick 100 fruits randomly.
        print(get_fruit())


func get_fruit():
    var random_fruit = _fruits[randi() % _fruits.size()]
    # Returns "apple", "orange", "pear", or "banana" every time the code runs.
    # We may get the same fruit multiple times in a row.
    return random_fruit
```

为了防止同一种水果被连续采摘不止一次，我们可以为这种方法添加更多的逻辑：

```python
var _fruits = ["apple", "orange", "pear", "banana"]
var _last_fruit = ""


func _ready():
    randomize()

    # Pick 100 fruits randomly.
    for i in range(100):
        print(get_fruit())


func get_fruit():
    var random_fruit = _fruits[randi() % _fruits.size()]
    while random_fruit == _last_fruit:
        # The last fruit was picked, try again until we get a different fruit.
        random_fruit = _fruits[randi() % _fruits.size()]

    # Note: if the random element to pick is passed by reference,
    # such as an array or dictionary,
    # use `_last_fruit = random_fruit.duplicate()` instead.
    _last_fruit = random_fruit

    # Returns "apple", "orange", "pear", or "banana" every time the code runs.
    # The function will never return the same fruit more than once in a row.
    return random_fruit
```

这种方法有助于减少随机数生成的重复性。尽管如此，它并不能阻止结果在有限的一组值之间“乒乓球”。为了防止这种情况发生，请改用洗牌袋模式。

#### 获取随机字典值

我们还可以将类似的逻辑从数组应用到字典中：

```python
var metals = {
    "copper": {"quantity": 50, "price": 50},
    "silver": {"quantity": 20, "price": 150},
    "gold": {"quantity": 3, "price": 500},
}


func _ready():
    randomize()

    for i in range(20):
        print(get_metal())


func get_metal():
    var random_metal = metals.values()[randi() % metals.size()]
    # Returns a random metal value dictionary every time the code runs.
    # The same metal may be selected multiple times in succession.
    return random_metal
```

#### 加权随机概率

randf() 方法返回一个介于 0.0 和 1.0 之间的浮点数。我们可以用它来创建一个“加权”概率，其中不同的结果具有不同的可能性：

```python
func _ready():
    randomize()

    for i in range(100):
        print(get_item_rarity())


func get_item_rarity():
    var random_float = randf()

    if random_float < 0.8:
        # 80% chance of being returned.
        return "Common"
    elif random_float < 0.95:
        # 15% chance of being returned.
        return "Uncommon"
    else:
        # 5% chance of being returned.
        return "Rare"
```

#### 使用洗牌袋“更好”的随机性

举一个与上面相同的例子，我们想随机挑选水果。然而，每次选择水果时依赖随机数生成可能会导致分布不太均匀。如果玩家运气好（或不好），他们可以连续三次或更多次获得相同的水果。

您可以使用洗牌袋模式来完成此操作。它的工作原理是在选择一个元素后将其从数组中删除。经过多次选择后，数组最终为空。发生这种情况时，您可以将其重新初始化为默认值：

```python
var _fruits = ["apple", "orange", "pear", "banana"]
# A copy of the fruits array so we can restore the original value into `fruits`.
var _fruits_full = []


func _ready():
    randomize()
    _fruits_full = _fruits.duplicate()
    _fruits.shuffle()

    for i in 100:
        print(get_fruit())


func get_fruit():
    if _fruits.empty():
        # Fill the fruits array again and shuffle it.
        _fruits = _fruits_full.duplicate()
        _fruits.shuffle()

    # Get a random fruit, since we shuffled the array,
    # and remove it from the `_fruits` array.
    var random_fruit = _fruits.pop_front()
    # Prints "apple", "orange", "pear", or "banana" every time the code runs.
    return random_fruit
```

当运行上述代码时，有机会连续两次获得相同的结果。一旦我们选择了一个水果，它将不再是一个可能的返回值，除非数组现在为空。当数组为空时，我们将其重置回默认值，从而可以再次获得相同的结果，但只能获得一次。

#### 随机噪声

当您需要一个根据输入*缓慢*变化的值时，上面显示的随机数生成可以显示其极限。输入可以是位置、时间或任何其他信息。

为此，可以使用随机噪波函数。噪波函数在生成逼真地形的过程生成中尤其流行。Godot 为此提供了 FastNoiseLite，它支持 1D、2D 和 3D 噪声。以下是 1D 噪声的示例：

```python
var _noise = FastNoiseLite.new()

func _ready():
    randomize()
    # Configure the FastNoiseLite instance.
    _noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
    _noise.seed = randi()
    _noise.fractal_octaves = 4
    _noise.frequency = 1.0 / 20.0

    for i in 100:
        # Prints a slowly-changing series of floating-point numbers
        # between -1.0 and 1.0.
        print(_noise.get_noise_1d(i))
```

## 导航

### 二维导航概述

Godot 提供了多个对象、类和服务器，以便于 2D 和 3D 游戏的基于网格或网格的导航和寻路。以下部分快速概述了 Godot 中用于 2D 场景的所有可用导航相关对象及其主要用途。

Godot 为二维导航提供了以下对象和类：

- **[Astar2D](https://docs.godotengine.org/en/stable/classes/class_astar2d.html#class-astar2d)**

  `Astar2D` 对象提供了在加权**点**图中查找最短路径的选项。

  AStar2D 类最适合基于细胞的 2D 游戏，该游戏不需要演员到达区域内的任何可能位置，只需要预定义的不同位置。

- **[NavigationServer2D](https://docs.godotengine.org/en/stable/classes/class_navigationserver2d.html#class-navigationserver2d)**

  `NavigationServer2D` 提供了一个功能强大的服务器 API，用于查找导航网格定义的区域上两个位置之间的最短路径。

  NavigationServer 最适合 2D 实时游戏，该游戏需要演员到达导航网格定义区域内的任何可能位置。基于网格的导航可以很好地适应大型游戏世界，因为当需要许多网格单元时，通常可以用单个多边形定义大区域。

  NavigationServer 保存不同的导航地图，每个导航地图由保存导航网格数据的区域组成。可以将代理放置在地图上进行规避计算。RID 用于在与服务器通信时引用内部地图、区域和代理。

  **以下 NavigationServer RID 类型可用。**

  - **导航地图（NavMap）RID**
    对包含区域和代理的特定导航地图的引用。地图将尝试通过接近度加入区域的已更改导航网格。该地图将同步每个物理帧的区域和代理。

  - **导航区域（NavRegion）RID**

    对可以保存导航网格数据的特定导航区域的引用。该区域可以启用/禁用，也可以使用导航层位掩码限制使用。

  - **导航链接（NavLink）RID**

    对特定导航链接的引用，该链接连接任意距离上的两个导航网格位置。

  - **导航代理（NavAgent）RID**

    对半径值仅用于回避的特定回避代理人的引用。

以下场景树节点可用作使用 NavigationServer2D API 的助手。

- **导航区域2D（[NavigationRegion2D](https://docs.godotengine.org/en/stable/classes/class_navigationregion2d.html#class-navigationregion2d)）节点**

  持有 NavigationPolygon 资源的节点，该资源定义 NavigationServer2D 的导航网格。

  - 可以启用/禁用该区域。
  - 可以通过导航层位掩码进一步限制在寻路中的使用。
  - 区域可以通过组合导航网格的接近度来连接其导航网格。

- **导航链接2D（[NavigationLink2D](https://docs.godotengine.org/en/stable/classes/class_navigationlink2d.html#class-navigationlink2d)）节点**

  在任意距离上连接导航网格上两个位置以进行路径查找的节点。

  - 可以启用/禁用链接。
  - 链接可以是单向的，也可以是双向的。
  - 可以通过导航层位掩码进一步限制在寻路中的使用。

  链接告诉路径查找连接的存在以及代价。实际的代理处理和移动需要在自定义脚本中进行。

- **导航代理2D（[NavigationAgent2D](https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html#class-navigationagent2d)）节点**

  帮助通用 NavigationServer2D API 的可选帮助节点调用 Node2D 继承父节点的路径查找和回避。

- **导航障碍2D（[NavigationObstacle2D](https://docs.godotengine.org/en/stable/classes/class_navigationobstacle2d.html#class-navigationobstacle2d)）节点**

  作为具有回避半径的代理的节点，需要将其添加到继承父节点的 Node2D 下才能工作。障碍物旨在作为无法有效地重新（烘焙）到导航网格的不断移动对象的最后选择。此节点也仅在使用 RVO 处理时工作。

二维导航网格是使用以下资源定义的：

- **导航多边形（[NavigationPolygon](https://docs.godotengine.org/en/stable/classes/class_navigationpolygon.html#class-navigationpolygon)）资源**

  一种资源，用于保存二维导航网格数据，并提供多边形绘制工具，以便在编辑器内以及运行时定义导航区域。

  - NavigationRegion2D 节点使用此资源来定义其导航区域。
  - NavigationServer2D 使用此资源来更新各个区域的导航网格。
  - 在定义平铺导航区域时，平铺集编辑器会在内部创建并使用此资源。

> **参考：**
>
> 您可以使用 2D navigation Polygon 和基于网格的 navigation with AStarGrid2D 演示项目来了解 2D 导航是如何工作的。

#### 2D 场景的设置

以下步骤显示了 2D 中使用 NavigationServer2D 和 NavigationAgent2D 进行路径移动的最小可行导航的基本设置。

1. 将 NavigationRegion2D 节点添加到场景中。

2. 单击区域节点并将新的 NavigationPolygon 资源添加到区域节点。

3. 使用 NavigationPolygon 绘制工具定义可移动导航区域。

   > **注意：**
   >
   > 导航网格定义了演员可以站立和移动的区域。在导航多边形边和碰撞对象之间留出足够的余量，以避免路径跟随演员在碰撞时重复卡住。

4. 在场景中添加 CharacterBody2D 节点，该节点具有基本碰撞形状和用于视觉效果的精灵或网格。

5. 在角色节点下方添加 NavigationAgent2D 节点。

6. 将以下脚本添加到 CharacterBody2D 节点。我们确保在场景完全加载并且 NavigationServer 有时间同步后设置移动目标。

```python
extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
    # These values need to be adjusted for the actor's speed
    # and the navigation layout.
    navigation_agent.path_desired_distance = 4.0
    navigation_agent.target_desired_distance = 4.0

    # Make sure to not await during _ready.
    call_deferred("actor_setup")

func actor_setup():
    # Wait for the first physics frame so the NavigationServer can sync.
    await get_tree().physics_frame

    # Now that the navigation map is no longer empty, set the movement target.
    set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
    navigation_agent.target_position = movement_target

func _physics_process(delta):
    if navigation_agent.is_navigation_finished():
        return

    var current_agent_position: Vector2 = global_position
    var next_path_position: Vector2 = navigation_agent.get_next_path_position()

    var new_velocity: Vector2 = next_path_position - current_agent_position
    new_velocity = new_velocity.normalized()
    new_velocity = new_velocity * movement_speed

    velocity = new_velocity
    move_and_slide()
```

> **注意：**
>
> 在第一帧中，NavigationServer 映射没有同步区域数据，任何路径查询都将返回空。等待一帧以暂停脚本，直到 NavigationServer 有时间同步为止。

### 三维导航概述

Godot 提供了多个对象、类和服务器，以便于 2D 和 3D 游戏的基于网格或网格的导航和寻路。以下部分快速概述了 Godot 中用于 3D 场景的所有可用导航相关对象及其主要用途。

Godot 为三维导航提供了以下对象和类：

- **[Astar3D](https://docs.godotengine.org/en/stable/classes/class_astar3d.html#class-astar3d)**

  `Astar3D` 对象提供了在加权**点**图中查找最短路径的选项。

  AStar3D 类最适合基于细胞的 3D 游戏，该游戏不需要演员到达区域内的任何可能位置，只需要预定义的不同位置。

- **[NavigationServer3D](https://docs.godotengine.org/en/stable/classes/class_navigationserver3d.html#class-navigationserver3d)**
  `NavigationServer3D` 提供了一个功能强大的服务器 API，用于查找由导航网格定义的区域上两个位置之间的最短路径。

  NavigationServer 最适合 3D 实时游戏，它确实需要演员到达导航网格定义区域内的任何可能位置。基于网格的导航可以很好地适应大型游戏世界，因为当需要许多网格单元时，通常可以用单个多边形定义大区域。

  NavigationServer 保存不同的导航地图，每个导航地图由保存导航网格数据的区域组成。可以将代理放置在地图上进行规避计算。RID 用于在与服务器通信时引用内部地图、区域和代理。

  **以下 NavigationServer RID 类型可用。**

  - **导航地图（NavMap）RID**

    对包含区域和代理的特定导航地图的引用。地图将尝试通过接近度加入区域的已更改导航网格。该地图将同步每个物理帧的区域和代理。

  - **导航区域（NavRegion）RID**

    对可以保存导航网格数据的特定导航区域的引用。该区域可以启用/禁用，也可以使用导航层位掩码限制使用。

  - **导航链接（NavLink）RID**

    对特定导航链接的引用，该链接连接任意距离上的两个导航网格位置。

  - **导航代理（NavAgent）RID**

    对半径值仅用于回避的特定回避代理人的引用。

以下场景树节点可用作使用 NavigationServer3D API 的助手。

- **导航区域3D（[NavigationRegion3D](https://docs.godotengine.org/en/stable/classes/class_navigationregion3d.html#class-navigationregion3d)）节点**

  持有导航网格资源的节点，该资源定义 NavigationServer3D 的导航网格。

  - 可以启用/禁用该区域。
  - 可以通过导航层位掩码进一步限制在寻路中的使用。
  - 区域可以通过组合导航网格的接近度来连接其导航网格。

- **导航链接3D（[NavigationLink3D](https://docs.godotengine.org/en/stable/classes/class_navigationlink3d.html#class-navigationlink3d)）节点**

  在任意距离上连接导航网格上两个位置以进行路径查找的节点。

  - 可以启用/禁用链接。
  - 链接可以是单向的，也可以是双向的。
  - 可以通过导航层位掩码进一步限制在寻路中的使用。

  链接告诉路径查找连接的存在以及代价。实际的代理处理和移动需要在自定义脚本中进行。

- **导航代理3D（[NavigationAgent3D](https://docs.godotengine.org/en/stable/classes/class_navigationagent3d.html#class-navigationagent3d)）节点**

  帮助通用 NavigationServer3D API 的可选帮助节点调用 Node3D 继承父节点的路径查找和回避。

- **导航障碍3D（[NavigationObstacle3D](https://docs.godotengine.org/en/stable/classes/class_navigationobstacle3d.html#class-navigationobstacle3d)）节点**

  作为具有回避半径的代理的节点，需要将其添加到继承父节点的 Node3D 下才能工作。障碍物旨在作为无法有效地重新（烘焙）到导航网格的不断移动对象的最后选择。此节点也仅在使用 RVO 处理时工作。

三维导航网格是使用以下资源定义的：

- **导航网格（[NavigationMesh](https://docs.godotengine.org/en/stable/classes/class_navigationmesh.html#class-navigationmesh)）资源**

  保存三维导航网格数据并提供三维几何体烘焙选项的资源，用于在编辑器内以及运行时定义导航区域。

  - NavigationRegion3D 节点使用此资源来定义其导航区域。
  - NavigationServer3D 使用此资源来更新各个区域的导航网格。
  - 当为每个网格单元定义特定的导航网格时，GridMap 编辑器将使用此资源。

> **参考：**
>
> 您可以使用 3D 导航演示项目了解 3D 导航在实际操作中的工作原理。

#### 3D 场景设置

以下步骤显示如何在使用 NavigationServer3D 和 NavigationAgent3D 进行路径移动的 3D 中设置最小可行导航。

1. 将 NavigationRegion3D 节点添加到场景中。
2. 单击区域节点并将新的 NavigationMesh 资源添加到区域节点。
3. 添加一个新的 MeshInstance3D 节点作为区域节点的子节点。
4. 选择 MeshInstance3D 节点并添加新的 PlaneMesh，然后将 xy 大小增加到 10。
5. 再次选择区域节点，然后按顶部栏上的“烘焙 Navmesh”按钮。
6. 现在出现了一个透明的导航网格，它在平面网格的顶部徘徊了一段距离。
7. 在场景中添加 CharacterBody3D 节点，该节点具有基本碰撞形状和一些用于视觉效果的网格。
8. 在角色节点下方添加 NavigationAgent3D 节点。
9. 将具有以下内容的脚本添加到 CharacterBody3D 节点。我们确保在场景完全加载并且 NavigationServer 有时间同步后设置移动目标。此外，添加 Camera3D 和一些灯光和环境可以看到一些东西。

```python
extends CharacterBody3D

var movement_speed: float = 2.0
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
    # These values need to be adjusted for the actor's speed
    # and the navigation layout.
    navigation_agent.path_desired_distance = 0.5
    navigation_agent.target_desired_distance = 0.5

    # Make sure to not await during _ready.
    call_deferred("actor_setup")

func actor_setup():
    # Wait for the first physics frame so the NavigationServer can sync.
    await get_tree().physics_frame

    # Now that the navigation map is no longer empty, set the movement target.
    set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
    navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
    if navigation_agent.is_navigation_finished():
        return

    var current_agent_position: Vector3 = global_position
    var next_path_position: Vector3 = navigation_agent.get_next_path_position()

    var new_velocity: Vector3 = next_path_position - current_agent_position
    new_velocity = new_velocity.normalized()
    new_velocity = new_velocity * movement_speed

    velocity = new_velocity
    move_and_slide()
```

> **注意：**
>
> 在第一帧中，NavigationServer 映射没有同步区域数据，任何路径查询都将返回空。等待一帧以暂停脚本，直到 NavigationServer 有时间同步为止。

### 使用 NavigationServer

NavigationServer 的 2D 和 3D 版本分别作为 NavigationServer2D 和 NavigationServer3D 提供。

2D 和 3D 都使用相同的 NavigationServer，NavigationServer3D 是主服务器。NavigationServer2D 是一个前端，可将 2D 位置转换为 3D 位置并返回。因此，完全有可能（如果不是有点麻烦的话）将 NavigationServer3D API 专门用于 2D 导航。

#### 与 NavigationServer 通信

使用 NavigationServer 意味着为可以发送到 NavigationServer 以进行更新或请求数据的 `query` 准备参数。

为了引用内部 NavigationServer 对象（如地图、区域和代理），使用 RID 作为标识号。SceneTree 中的每个与导航相关的节点都有一个返回该节点 RID 的函数。

#### 线程和同步

NavigationServer 不会立即更新每一个更改，而是等待到 `physics_frame` 结束时将所有更改同步在一起。

需要等待同步才能将更改应用于所有映射、区域和代理。之所以进行同步，是因为某些更新（如重新计算整个导航地图）非常昂贵，并且需要来自所有其他对象的更新数据。此外，NavigationServer 默认情况下使用 `threadpool` 来实现某些功能，如代理之间的回避计算。

对于大多数只从 NavigationServer 请求数据而不进行更改的 `get()` 函数，不需要等待。请注意，并非所有数据都会考虑到在同一帧中所做的更改。例如，如果回避 `agent` 在此帧更改了导航 `map`，那么 `agent_get_map()` 函数仍将返回同步之前的旧地图。例外情况是在将更新发送到 NavigationServer 之前在内部存储其值的节点。当节点上的 getter 用于在同一帧中更新的值时，它将返回存储在节点上的已更新值。

NavigationServer 是 `thread-safe`（线程安全）的，因为它放置了所有希望在队列中进行更改的 API 调用，以便在同步阶段执行。完成脚本和节点的场景输入后，NavigationServer 的同步将在物理帧的中间进行。

> **注意：**
>
> 重要的一点是，大多数 NavigationServer 更改在下一个物理帧之后生效，而不是立即生效。这包括场景树中与导航相关的节点或通过脚本所做的所有更改。

以下功能将仅在同步阶段执行：

- map_set_active()
- map_set_up()
- map_set_cell_size()
- map_set_edge_connection_margin()
- region_set_map()
- region_set_transform()
- region_set_enter_cost()
- region_set_travel_cost()
- region_set_navigation_layers()
- region_set_navigation_mesh()
- agent_set_map()
- agent_set_neighbor_dist()
- agent_set_max_neighbors()
- agent_set_time_horizon()
- agent_set_radius()
- agent_set_max_speed()
- agent_set_velocity()
- agent_set_target_velocity()
- agent_set_position()
- agent_set_ignore_y()
- agent_set_callback()
- free()

#### 2D 和 3D NavigationServer 的差异

NavigationServer2D 和 NavigationServer3D 在其维度的功能上是等效的，并且都在场景后面使用相同的 NavigationServer。

严格意义上讲，NavigationServer2D 是一个神话。NavigationServer2D 是一个前端，便于将 Vector2(x, y) 转换为 Vector3(x, 0.0, z)，然后再转换为 NavigationServer 3D API。2D 使用平面三维网格寻路，NavigationServer2D 便于转换。当指南只使用 NavigationServer 而不使用 2D 或 3D 后缀时，它通常通过将 Vector2(x, y) 与 Vector3(x, 0.0, z) 或反向交换来同时适用于这两个服务器。

从技术上讲，可以使用工具为其他维度创建导航网格，例如，当使用平面三维源几何体时，使用三维导航网格烘焙二维导航网格，或者使用 NavigationRegion2D 和 NavigationPolygons 的多边形轮廓绘制工具创建三维平面导航网格。

使用 NavigationServer2D API 创建的任何 RID 都可以在 NavigationServer 3D API 上运行，2D 和 3D 回避代理都可以存在于同一地图上。

> **注意：**
>
> 在二维和三维中创建的区域将在放置在同一地图上时合并它们的导航网格，并应用合并条件。NavigationServer 不会区分 NavigationRegion2D 和 NavigationRegion3D 节点，因为这两个节点都是服务器上的区域。默认情况下，这些节点在不同的导航地图上注册，因此只有在手动更改地图（例如使用脚本）时才能进行合并。
>
> 启用回避功能的演员将在放置在同一地图上时同时避开 2D 和 3D 回避代理。

> **警告：**
> 在 Godot 自定义生成上禁用 3D 时，无法使用 NavigationServer2D。

#### 正在等待同步

在游戏开始时，新的场景或过程导航更改了 NavigationServer 的任何路径查询都将返回空或错误。

导航地图此时仍然为空或未更新。SceneTree 中的所有节点都需要首先将其导航相关数据上传到 NavigationServer。每个添加或更改的地图、区域或代理都需要在 NavigationServer 中注册。之后，NavigationServer 需要一个用于同步的 `physics_frame` 来更新地图、区域和代理。

一种解决方法是延迟调用自定义设置函数（这样所有节点都准备好了）。设置功能进行所有导航更改，例如添加程序性内容。然后，函数在继续路径查询之前等待下一个 physics_frame。

```python
extends Node3D

func _ready():
    # use call deferred to make sure the entire SceneTree Nodes are setup
    # else await / yield on 'physics_frame' in a _ready() might get stuck
    call_deferred("custom_setup")

func custom_setup():

    # create a new navigation map
    var map: RID = NavigationServer3D.map_create()
    NavigationServer3D.map_set_up(map, Vector3.UP)
    NavigationServer3D.map_set_active(map, true)

    # create a new navigation region and add it to the map
    var region: RID = NavigationServer3D.region_create()
    NavigationServer3D.region_set_transform(region, Transform())
    NavigationServer3D.region_set_map(region, map)

    # create a procedural navigation mesh for the region
    var new_navigation_mesh: NavigationMesh = NavigationMesh.new()
    var vertices: PackedVector3Array = PoolVector3Array([
        Vector3(0,0,0),
        Vector3(9.0,0,0),
        Vector3(0,0,9.0)
    ])
    new_navigation_mesh.set_vertices(vertices)
    var polygon: PackedInt32Array = PackedInt32Array([0, 1, 2])
    new_navigation_mesh.add_polygon(polygon)
    NavigationServer3D.region_set_navigation_mesh(region, new_navigation_mesh)

    # wait for NavigationServer sync to adapt to made changes
    await get_tree().physics_frame

    # query the path from the navigationserver
    var start_position: Vector3 = Vector3(0.1, 0.0, 0.1)
    var target_position: Vector3 = Vector3(1.0, 0.0, 1.0)
    var optimize_path: bool = true

    var path: PackedVector3Array = NavigationServer3D.map_get_path(
        map,
        start_position,
        target_position,
        optimize_path
    )

    print("Found a path!")
    print(path)
```

#### 服务器避免回调

如果注册了 RVO 回避代理进行回避回调，NavigationServer 会在 PhysicsServer 同步之前调度其 `safe_velocity` 信号。

要了解有关 NavigationAgent 的更多信息，请参阅使用 NavigationAgent。

使用回避的 NavigationAgent 的简化执行顺序：

- 物理帧开始。
- _physics_process(delta)。
- NavigationAgent 节点上的 set_velocity()。
- 代理向 NavigationServer 发送速度和位置。
- NavigationServer 正在等待同步。
- NavigationServer 同步并计算所有注册回避代理的回避速度。
- NavigationServer 为每个注册的回避代理发送带有信号的 safe_velocity 矢量。
- 代理接收信号并移动其父对象，例如使用 move_and_slide 或 linear_velocity。
- PhysicsServer 进行同步。
- 物理帧结束。

因此，在具有 safe_velocity 的回调函数中移动 physics_body 参与者是完全线程和物理安全的，因为在 PhysicsServer 提交更改并进行自己的计算之前，所有这些都发生在同一个 physics_frame 内。

### 使用 NavigationMaps

NavigationMap 是 NavigationServer 上由 NavigationServer RID 标识的抽象导航世界。

地图可以容纳几乎无限多的导航区域，并将其与导航网格连接起来，以构建游戏世界的可遍历区域，用于寻路。

地图可以由回避代理加入以处理回避代理之间的冲突回避。

> **注意：**
>
> 不同的 NavigationMap 彼此完全隔离，但导航区域和回避代理可以在每次服务器同步后在不同的地图之间切换。

#### 默认导航地图

默认情况下，Godot 为根视口的每个 World2D 和 World3D 创建导航地图 RID。

2D 默认导航 `map` 可以通过 `get_world_2d().get_navigation_map()` 从任何 Node2D 继承节点获得。

3D 默认导航 `map` 可以通过 `get_world_3d().get_navigation_map()` 从任何 Node3D 继承节点获得。

```python
extends Node2D

var default_2d_navigation_map_rid: RID = get_world_2d().get_navigation_map()
```

```python
extends Node3D

var default_3d_navigation_map_rid: RID = get_world_3d().get_navigation_map()
```

#### 创建新的导航地图

NavigationServer 可以创建并支持特定游戏所需的任意数量的导航地图。其他导航地图是通过直接使用 NavigationServer API 创建和维护的，例如支持不同的回避代理或参与者移动类型。

例如，不同导航地图的使用请参见支持不同的角色类型和支持不同的演员移动。

每个导航地图将排队的更改分别同步到其导航区域和回避代理。未接收到更改的导航地图几乎不需要处理时间。导航区域和规避代理只能是单个导航地图的一部分，但它们可以随时切换地图。

> **注意：**
>
> 导航地图切换只有在下一次 NavigationServer 同步之后才会生效。

```python
extends Node2D

var new_navigation_map: RID = NavigationServer2D.map_create()
NavigationServer2D.map_set_active(true)
```

```python
extends Node3D

var new_navigation_map: RID = NavigationServer3D.map_create()
NavigationServer3D.map_set_active(true)
```

> **注意：**
>
> 使用 NavigationServer2D API 或 NavigationServer 3D API 创建的导航地图没有区别。

### 使用 NavigationRegions

NavigationRegions 是 NavigationServer 上导航 `map` `region` 的可视化节点表示。每个 NavigationRegion 节点都为导航网格数据保存一个资源。

2D 和 3D 版本分别提供 NavigationRegion2D 和 NavigationRegion3D。

各个 NavigationRegions 将其 2D NavigationPolygon 或 3D NavigationMesh 资源数据上载到 NavigationServer。NavigationServer 映射将这些信息转换为用于路径查找的组合导航映射。

若要使用 SceneTree 创建导航区域，请将 `NavigationRegion2D` 或 `NavigationRegion3D` 节点添加到场景中。所有区域都需要导航网格资源才能正常工作。请参阅使用导航网格，了解如何创建和应用导航网格。

NavigationRegions 将自动将 `global_transform` 更改推送到 NavigationServer 上的区域，使其适合移动平台。当各个区域的导航网格足够近时，NavigationServer 将尝试连接它们。有关详细信息，请参见连接导航网格。要在任意距离上连接 NavigationRegions，请参阅使用 NavigationLinks 以了解如何创建和使用 `NavigationLink`。

> **警告：**
>
> 虽然更改 NavigationRegion 节点的变换会更新 NavigationServer 上的区域位置，但更改比例不会。导航网格资源没有比例，当源几何图形更改比例时需要完全更新。

可以启用/禁用区域，如果禁用，则不会对未来的路径查找查询做出贡献。

> **注意：**
>
> 启用/禁用某个区域时，不会自动更新现有路径。

#### 创建新的导航区域

新的 NavigationRegion 节点将自动注册到其 2D/3D 维度的默认世界导航地图。

然后可以使用 `get_region_rid()` 从 NavigationRegion Nodes 获取区域 RID。

```python
extends NavigationRegion3D

var navigationserver_region_rid: RID = get_region_rid()
```

还可以使用 NavigationServer API 创建新区域，并将其添加到任何现有地图中。

如果直接使用 NavigationServer API 创建区域，则需要手动为其分配导航地图。

```python
extends Node2D

var new_2d_region_rid: RID = NavigationServer2D.region_create()
var default_2d_map_rid: RID = get_world_2d().get_navigation_map()
NavigationServer2D.region_set_map(new_2d_region_rid, default_2d_map_rid)
```

```python
extends Node3D

var new_3d_region_rid: RID = NavigationServer3D.region_create()
var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
NavigationServer3D.region_set_map(new_3d_region_rid, default_3d_map_rid)
```

> **注意：**
>
> NavigationRegions 只能分配给单个 NavigationMap。如果将现有区域指定给新地图，它将离开旧地图。

### 使用 NavigationMeshes

导航网格的 2D 和 3D 版本分别作为 NavigationPolygon 和 NavigationMesh 提供。

> **注意：**
>
> 导航网格描述了代理的可遍历安全区域，其中心位置为零半径。如果希望路径查找考虑代理的（碰撞）大小，则需要相应地缩小导航网格。

导航的工作独立于其他引擎部分，如渲染和物理。导航网格是从其他系统交换信息的数据格式，因为它描述了特定代理的可穿越安全区域。在创建导航网格时，需要考虑来自其他发动机部件的所有必要信息。例如，代理不应该剪辑的视觉效果或代理不应该碰撞的物理碰撞形状。考虑到来自其他引擎部件（如视觉效果和碰撞）的所有导航限制的过程通常称为导航网格烘焙。

如果您在遵循导航路径时遇到剪裁或碰撞问题，请始终记住，您需要通过适当的导航网格告诉导航系统您的意图。导航系统本身永远不会知道“这是一个树/岩石/墙壁碰撞的形状或视觉网格”，因为它只知道“在这里，我被告知我可以安全地行驶，因为它在导航网格上”。

#### 创建二维导航网格

2D 编辑器中的导航网格是在 NavigationPolygon 绘制工具的帮助下创建的，当选择 NavigationRegion2D 时，这些工具会显示在编辑器的顶部栏中。

NavigationPolygon 绘制工具可用于通过定义 `outline` 多边形来创建和编辑导航网格。轮廓多边形稍后将转换为 NavigationServer 区域的真实 NavigationMesh 资源。

可以将多个轮廓添加到同一 NavPolygon 资源中，只要它们不相交或重叠即可。每个附加的轮廓都将在由较大轮廓创建的多边形中剪切一个孔。如果较大的多边形已经是一个洞，它将在里面创建一个新的导航网格多边形。

如果意图合并对齐的多边形，例如网格单元中的多边形，则轮廓不能替换。正如名称所暗示的那样，轮廓不能相互交叉或具有任何重叠的顶点位置。

如图所示的轮廓布局将无法实现导航网格生成所需的凸划分。在这种布局情况下，不能使用大纲工具。使用 Geometry2D 类进行多边形合并或相交操作，以创建用于导航的有效合并网格。

笔记
NavigationServer 不连接来自同一 NavigationMesh 资源的导航网格岛。如果以后应该连接，请不要在同一 NavigationRegion2D 和 NavPoly 资源中创建多个断开连接的岛。

对于 2D，不存在类似于 3D 的带有几何体解析的导航网格烘焙。用于偏移、合并、相交和剪裁的 Geometry2D 类函数可用于将现有 NavigationPolygons 缩小或放大到不同的演员大小。

#### 创建三维导航网格

三维编辑器中的导航网格是在编辑器检查器中显示的 NavigationMeshGenerator 单例和 NavigationMesh 烘焙设置的帮助下创建的。

NavigationMesh 烘焙是创建简化网格的过程，用于从（复杂的）3D 级几何体中查找路径。在这个过程中，Godot 解析场景几何体，并将原始网格或碰撞数据交给第三方 ReCast 库，用于处理和创建最终导航网格。

由于性能和技术原因，生成的 NavigationMesh 是源几何体曲面的近似值。不要期望 NavigationMesh 完全遵循原始曲面。尤其是放置在坡道上的导航多边形将无法与地面保持相等的距离。要使演员与地面完美对齐，请使用其他方法，如物理学。

> **警告：**
>
> 网格需要进行三角测量才能用作导航网格。不支持其他网格面格式，如 quad 或 ngon。

#### NavigationMesh 在运行时重新生成

要在运行时重新生成 `NavigationMesh`，请使用 NavigationRegion3D.bake_navigation_mesh() 函数。另一种选择是直接将 NavigationMeshGenerator.bake() Singleton 函数与 NavigationMesh 资源一起使用。如果导航网格资源已经准备好，也可以使用 NavigationServer3D API 直接更新区域。

```python
extends NavigationRegion3D

func update_navigation_mesh():

    # use bake and update function of region
    var on_thread: bool = true
    bake_navigation_mesh(on_thread)

    # or use the NavigationMeshGenerator Singleton
    var _navigationmesh: NavigationMesh = navigation_mesh
    NavigationMeshGenerator.bake(_navigationmesh, self)
    # remove old resource first to trigger a full update
    navigation_mesh = null
    navigation_mesh = _navigationmesh

    # or use NavigationServer API to update region with prepared navigation mesh
    var region_rid: RID = get_region_rid()
    NavigationServer3D.region_set_navigation_mesh(region_rid, navigation_mesh)
```

> **注意：**
>
> 在运行时烘焙 NavigationMesh 是一项成本高昂的操作。复杂的导航网格需要一些时间来烘焙，如果在主线程上完成，则可以冻结游戏。（重新）烘焙大的导航网格最好在单独的线程中完成。

> **警告：**
> NavigationMesh 资源（如 `cell_size`）上的属性值需要与内部存储的实际网格数据相匹配，以便在没有问题的情况下合并不同的导航网格。

NavigationRegion2D 和 Navigation3D 都使用网格来标记可遍历区域，只有创建它们的工具不同。

对于二维导航，多边形资源用于在编辑器中绘制轮廓点。NavigationServer2D 根据这些轮廓点创建一个网格，以便将导航数据上载到 NavigationServer。

对于三维导航，将使用网格资源。3D 变体不提供绘制工具，而是提供大量参数，以直接从 3D 源几何体烘焙导航网格。

> **注意：**
>
> 从技术上讲，2D 和 3D 之间没有硬性区别——如何使用给定的工具集来创建平面导航网格。2D 绘图工具可用于创建平面 3D 导航网格，3D 烘焙工具可用于将平面 3D 几何体解析为 2D 适当的导航网格。

#### 来自碰撞多边形的二维导航网格

以下脚本为 CollisionPolygons 解析 NavigationRegion2D 的所有子节点，并将其形状烘焙到 NavigationPolygon 中。由于 NavigationPolygon 根据轮廓数据创建导航网格，因此形状不能重叠。

```python
extends NavigationRegion2D

var new_navigation_polygon: NavigationPolygon = get_navigation_polygon()

func _ready():

    parse_2d_collisionshapes(self)

    new_navigation_polygon.make_polygons_from_outlines()
    set_navigation_polygon(new_navigation_polygon)

func parse_2d_collisionshapes(root_node: Node2D):

    for node in root_node.get_children():

        if node.get_child_count() > 0:
            parse_2d_collisionshapes(node)

        if node is CollisionPolygon2D:

            var collisionpolygon_transform: Transform2D = node.get_global_transform()
            var collisionpolygon: PackedVector2Array = node.polygon

            var new_collision_outline: PackedVector2Array = collisionpolygon_transform * collisionpolygon

            new_navigation_polygon.add_outline(new_collision_outline)
```

#### 程序 2D 导航网格

以下脚本将创建一个新的二维导航区域，并使用 NavigationPolygon 资源中程序生成的导航网格数据填充该区域。

```python
extends Node2D

var new_2d_region_rid: RID = NavigationServer2D.region_create()

var default_2d_map_rid: RID = get_world_2d().get_navigation_map()
NavigationServer2D.region_set_map(new_2d_region_rid, default_2d_map_rid)

var new_navigation_polygon: NavigationPolygon = NavigationPolygon.new()
var new_outline: PackedVector2Array = PackedVector2Array([
    Vector2(0.0, 0.0),
    Vector2(50.0, 0.0),
    Vector2(50.0, 50.0),
    Vector2(0.0, 50.0),
])
new_navigation_polygon.add_outline(new_outline)
new_navigation_polygon.make_polygons_from_outlines()

NavigationServer2D.region_set_navigation_polygon(new_2d_region_rid, new_navigation_polygon)
```

#### 程序三维导航网格

以下脚本将创建一个新的三维导航区域，并使用 NavigationMesh 资源中过程生成的导航网格数据填充该区域。

```python
extends Node3D

var new_3d_region_rid: RID = NavigationServer3D.region_create()

var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
NavigationServer3D.region_set_map(new_3d_region_rid, default_3d_map_rid)

var new_navigation_mesh: NavigationMesh = NavigationMesh.new()
# Add vertices for a triangle.
new_navigation_mesh.vertices = PackedVector3Array([
    Vector3(-1.0, 0.0, 1.0),
    Vector3(1.0, 0.0, 1.0),
    Vector3(1.0, 0.0, -1.0)
])
# Add indices for the polygon.
new_navigation_mesh.add_polygon(
    PackedInt32Array([0, 1, 2])
)
NavigationServer3D.region_set_navigation_mesh(new_3d_region_rid, new_navigation_mesh)
```

#### 三维网格地图的 Navmesh

以下脚本为每个 GridMap 项创建一个新的三维导航网格，清除当前网格单元，并使用新的导航网格添加新的过程网格单元。

```python
extends GridMap

# enable navigation mesh for grid items
set_bake_navigation(true)

# get grid items, create and set a new navigation mesh for each item in the MeshLibrary
var gridmap_item_list: PackedInt32Array = mesh_library.get_item_list()
for item in gridmap_item_list:
    var new_item_navigation_mesh: NavigationMesh = NavigationMesh.new()
    # Add vertices and polygons that describe the traversable ground surface.
    # E.g. for a convex polygon that resembles a flat square.
    new_item_navigation_mesh.vertices = PackedVector3Array([
        Vector3(-1.0, 0.0, 1.0),
        Vector3(1.0, 0.0, 1.0),
        Vector3(1.0, 0.0, -1.0),
        Vector3(-1.0, 0.0, -1.0),
    ])
    new_item_navigation_mesh.add_polygon(
        PackedInt32Array([0, 1, 2, 3])
    )
    mesh_library.set_item_navigation_mesh(item, new_item_navigation_mesh)
    mesh_library.set_item_navigation_mesh_transform(item, Transform3D())

# clear the cells
clear()

# add procedual cells using the first item
var _position: Vector3i = Vector3i(global_transform.origin)
var _item: int = 0
var _orientation: int = 0
for i in range(0,10):
    for j in range(0,10):
        _position.x = i
        _position.z = j
        gridmap.set_cell_item(_position, _item, _orientation)
        _position.x = -i
        _position.z = -j
        gridmap.set_cell_item(_position, _item, _orientation)
```

### 使用 NavigationPaths

#### 获取导航路径

导航路径可以直接从 NavigationServer 查询，并且不需要任何其他节点或对象，只要导航地图具有可使用的导航网格即可。

要获取二维路径，请使用 `NavigationServer2D.map_get_path(map, from, to, optimize, navigation_layers)`。

要获取三维路径，请使用 `NavigationServer3D.map_get_path(map, from, to, optimize, navigation_layers)`。

有关需要额外设置的更多可自定义导航路径查询，请参阅使用 NavigationPathQueryObjects。

查询所需的参数之一是导航地图的 RID。每个游戏 `World` 都有一个自动创建的默认导航地图。默认导航地图可以使用 `get_world_2d().get_navigation_map()` 从任何 Node2D 继承节点检索，也可以使用 `get_world_3d().get_navigation_map()` 在任何 Node3D 继承节点检索。第二和第三参数是起始位置和目标位置，作为 2D 的 Vector2 或 3D 的 Vector3。

如果 `optimized` 参数为 `true`，则通过额外的漏斗算法过程，路径位置将沿着多边形角缩短。这对于具有不等大小多边形的导航网格上的自由移动非常有效，因为路径将围绕 A* 算法找到的多边形走廊的角。对于小单元，A* 算法创建了一个非常窄的漏斗走廊，当与网格一起使用时，可能会创建难看的拐角路径。

如果 `optimized` 参数为 `false`，则路径位置将放置在每个多边形边的中心。这适用于具有相等大小多边形的导航网格上的纯网格移动，因为路径将穿过网格单元的中心。在网格之外，由于多边形通常用一条长边覆盖大的开放区域，这可能会产生不必要的长弯路。

```python
extends Node2D
 # basic query for a navigation path in 2D using the default navigation map
var default_2d_map_rid: RID = get_world_2d().get_navigation_map()
var start_position: Vector2 = Vector2(0.0, 0.0)
var target_position: Vector2 = Vector2(5.0, 0.0)
var path: PackedVector2Array = NavigationServer2D.map_get_path(
    default_2d_map_rid,
    start_position,
    target_position,
    true
)
```

```python
extends Node3D
# basic query for a navigation path in 3D using the default navigation map
var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
var start_position: Vector3 = Vector3(0.0, 0.0, 0.0)
var target_position: Vector3 = Vector3(5.0, 0.0, 3.0)
var path: PackedVector3Array = NavigationServer3D.map_get_path(
    default_3d_map_rid,
    start_position,
    target_position,
    true
)
```

NavigationServer 返回的 `path` 将是用于 2D 的 `PackedVector2Array` 或用于 3D 的 `PackedVector3Array`。这些只是一个内存优化的矢量位置 `Array`。阵列内的所有位置向量都保证位于 NavigationPolygon 或 NavigationMesh 内。如果路径数组不为空，则其导航网格位置最接近第一个索引 `path[0]` 位置的起始位置。离目标位置最近的可用导航网格位置是最后一个索引 `path[path.size()-1]` 位置。之间的所有索引都是参与者在不离开导航网格的情况下到达目标所应遵循的路径点。

> **注意：**
>
> 如果目标位置位于未合并或连接的不同导航网格上，则导航路径将指向起始位置导航网格上尽可能接近的位置。

以下脚本通过使用 `set_movement_target()` 设置目标位置，使用默认导航地图沿导航路径移动 Node3D 继承节点。

```python
var movement_speed: float = 4.0
var movement_delta: float
var path_point_margin: float = 0.5
var default_3d_map_rid: RID = get_world_3d().get_navigation_map()

var current_path_index: int = 0
var current_path_point: Vector3
var current_path: PackedVector3Array

func set_movement_target(target_position: Vector3):

    var start_position: Vector3 = global_transform.origin

    current_path = NavigationServer3D.map_get_path(
        default_3d_map_rid,
        start_position,
        target_position,
        true
    )

    if not current_path.is_empty():
        current_path_index = 0
        current_path_point = current_path[0]

func _physics_process(delta):

    if current_path.is_empty():
        return

    movement_delta = move_speed * delta

    if global_transform.origin.distance_to(current_path_point) <= path_point_margin:
        current_path_index += 1
        if current_path_index >= current_path.size():
            current_path = []
            current_path_index = 0
            current_path_point = global_transform.origin
            return

    current_path_point = current_path[current_path_index]

    var new_velocity: Vector3 = (current_path_point - global_transform.origin).normalized() * movement_delta

    global_transform.origin = global_transform.origin.move_toward(global_transform.origin + new_velocity, movement_delta)
```

### 使用 NavigationPathQueryObjects

`NavigationPathQueryObjects` 可以与 `NavigationServer.query_path()` 一起使用，以获得高度**定制**的导航路径，包括有关该路径的可选**元数据**。

与获得普通 NavigationPath 相比，这需要更多的设置，但可以根据项目的不同需求定制寻路和提供的路径数据。

NavigationPathQueryObjects 由一对对象组成，一个 `NavigationPathQueryParameters` 对象保存查询的自定义选项，另一个 `NavigationPathQueryResult` 从查询中接收（定期）更新的结果路径和元数据。

`NavigationPathQueryParameters` 的 2D 和 3D 版本分别作为 NavigationPathQueryParameters2D 和 NavigationPathqueryParameters3D 提供。
`NavigationPathQueryResult` 的 2D 和 3D 版本分别作为 NavigationPathQuerResult2D 和 NavigationPathQueryResult3D 提供。

参数和结果都与 `NavigationServer.query_path()` 函数成对使用。

有关可用的自定义选项及其使用，请参阅参数的类文档。

虽然这不是一个严格的要求，但这两个对象都打算提前创建一次，存储在代理的持久变量中，并通过更新的参数重复用于每个后续路径查询。如果一个项目有大量定期更新路径的同时代理，这种重用可以避免频繁创建对象所带来的性能影响。

```python
# prepare query objects
var query_parameters = NavigationPathQueryParameters2D.new()
var query_result  = NavigationPathQueryResult2D.new()

# update parameters object
query_parameters.map = get_world_2d().get_navigation_map()
query_parameters.start_position = agent2d_current_global_position
query_parameters.target_position = agent2d_target_global_position

# update result object
NavigationServer2D.query_path(query_parameters, query_result)
var path: PackedVector2Array = query_result.get_path()
```

```python
# prepare query objects
var query_parameters = NavigationPathQueryParameters3D.new()
var query_result  = NavigationPathQueryResult3D.new()

# update parameters object
query_parameters.map = get_world_3d().get_navigation_map()
query_parameters.start_position = agent3d_current_global_position
query_parameters.target_position = agent3d_target_global_position

# update result object
NavigationServer3D.query_path(query_parameters, query_result)
var path: PackedVector3Array = query_result.get_path()
```

### 使用 NavigationAgents

NavigationsAgent 是辅助节点，它结合了 Node2D/3D 继承父节点的路径查找、路径跟随和代理避免功能。它们为初学者以更方便的方式代表父参与者节点调用 NavigationServer API 提供了便利。

NavigationAgents 的 2D 和 3D 版本分别作为 NavigationAgent2D 和 NavigationAgent3D 提供。

新的 NavigationAgent 节点将自动加入 World2D/World3D 上的默认导航地图。

NavigationsAgent 节点是可选的，不是使用导航系统的硬性要求。它们的整个功能可以替换为对 NavigationServer API 的脚本和直接调用。

#### NavigationAgent 路径查找

当其 `target_position` 设置为全局位置时，NavigationAgent 会在其当前导航地图上查询新的导航路径。

路径查找的结果可能受到以下属性的影响。

- `navigation_layers` 位掩码可用于限制代理可以使用的导航网格。
- `pathfinding_algorithm` 控制路径搜索中路径查找在导航网格多边形中的传播方式。
- `path_postprocessing` 设置在返回路径查找找到的原始路径道路之前是否或如何更改该道路。
- `path_metadata_flags` 允许收集路径返回的附加路径点元数据。

> **警告：**
> 禁用路径元标志将禁用代理上的相关信号发射。

#### NavigationAgent 路径跟随

在为代理设置了 `target_position` 之后，可以使用 `get_next_path_position()` 函数检索路径中的下一个位置。

一旦接收到下一个路径位置，使用您自己的移动代码将代理的父参与者节点移到此路径位置。

> **注意：**
>
> 导航系统从不移动 NavigationAgent 的父节点。这场运动完全掌握在用户及其自定义脚本的手中。

NavigationAgent 有自己的内部逻辑来处理当前路径并调用更新。

`get_next_path_position()` 函数负责更新代理的许多内部状态和属性。该函数应在每个 `physics_process` 中重复调用一次，直到 `is_navigation_finished()` 告诉路径已完成。在到达目标位置或路径末端后不应调用该函数，因为它可能会由于重复的路径更新而使代理在适当位置抖动。如果路径已经完成，请始终在脚本中尽早使用 `is_navigation_finished()` 进行检查。

以下属性会影响路径跟随行为。

- `path_dedesired_distance` 定义代理将其内部路径索引推进到下一个路径位置的距离。
- `target_dedesired_distance` 定义了代理认为要到达的目标位置的距离及其末端的路径。
- `path_max_distance` 定义代理何时请求新路径，因为它移动得离当前路径点段太远。

重要的更新都是在 `_physics_process()` 中调用 `get_next_path_position()` 函数时触发的。

NavigationAgent 可以与 `process` 一起使用，但仍限于在 `physics_process` 中发生的单个更新。

以下是 NavigationAgent 常用的各种节点的脚本示例。

##### Pathfollowing 常见问题

在编写代理移动脚本时，需要考虑一些常见的用户问题和重要的注意事项。

- **路径返回为空**

  如果代理在导航地图同步之前查询路径，例如在 _ready() 函数中，路径可能返回空。在这种情况下，get_next_path_position() 函数将返回与代理父节点相同的位置，并且代理将考虑到达的路径末端。这是通过进行延迟调用或使用回调来解决的，例如等待导航地图更改信号。

- **代理被困在两个位置之间跳舞**

  这通常是由每一帧非常频繁的路径更新引起的，无论是故意的还是意外的（例如，设置的最大路径距离太短）。路径查找需要找到导航网格上有效的最近位置。如果每一帧都请求一条新的路径，那么第一个路径位置最终可能会在代理当前位置的前后不断切换，导致代理在两个位置之间跳跃。

- **代理有时会反悔**

  如果一个代理移动得很快，它可能会在不推进路径索引的情况下超过 path_dedesired_distance 检查。这可能导致代理回溯到它后面的路径点，直到它通过距离检查以增加路径索引。为您的代理速度和更新率相应地增加所需的距离通常可以解决这一问题，以及一个更平衡的导航网格多边形布局，不需要太多的多边形边在小空间中挤在一起。

- **代理有时会回头寻找一个框架**

  就像在两个位置之间卡住跳舞的代理一样，这通常是由每一帧非常频繁的路径更新引起的。根据导航网格布局，尤其是当代理直接放置在导航网格边缘或边缘连接上时，路径位置有时会稍微“落后”于参与者的当前方向。这种情况的发生是由于精度问题，并非总是可以避免的。如果演员被立即旋转以面对当前路径位置，这通常只是一个可见的问题。

#### 导航代理回避

本节介绍如何使用特定于 NavigationAgent 的导航回避。

为了让 NavigationAgent 使用回避功能，必须将 `enable_avoidance` 属性设置为 `true`。

必须连接 NavigationAgent 节点的 velocity_computerd 信号才能接收 `safe_velocity` 计算结果。

为了触发回避速度计算，必须使用 `_physics_process()` 中 NavigationAgent 节点上的 `set_velocity()` 设置代理父节点的当前速度。

在处理回避的短暂等待之后（仍然在同一帧中），`safe_velocity` 矢量将与信号一起被接收。该速度矢量应用于移动 NavigationAgent 的父节点，以避免与其他使用代理或回避障碍物的回避发生碰撞。

> **注意：**
>
> 只有在同一地图上注册了回避的其他代理人才会被考虑在回避计算中。

以下 NavigationAgent 属性与回避相关：

- 属性 `height` 仅在三维中可用。高度与代理的当前全局 y 轴位置一起决定了代理在回避模拟中的垂直位置。使用 2D 回避的代理将自动忽略其下方或上方的其他代理或障碍物。
- 属性 `radius` 控制回避圆的大小，如果是三维球体，则控制代理周围的大小。该区域描述的是代理的身体，而不是躲避机动距离。
- 当搜索应避免的其他代理时，属性 `neighbor_distance` 控制代理的搜索半径。较低的值可降低加工成本。
- 属性 `max_neighbors` 控制在避免计算中考虑多少其他代理（如果它们都具有重叠半径）。较低的值降低了处理成本，但过低的值可能导致代理忽略避免。
- 属性 `time_horizon_agents` 和 `time_horizo_obstacles` 控制其他代理或障碍物的回避预测时间（以秒为单位）。当特工计算他们的安全速度时，他们选择的速度可以保持这几秒钟，而不会与另一个躲避物体相撞。预测时间应该尽可能低，因为代理会减慢速度以避免在该时间段内发生碰撞。
- 属性 `max_speed` 控制代理回避计算所允许的最大速度。如果代理的父级移动速度超过此值，则避免 `safe_velocity` 可能不够准确，无法避免碰撞。
- `use_3d_avoidance` 属性在下次更新时在 2D 回避（xz 轴）和 3D 回避（xyz 轴）之间切换代理。请注意，2D 回避和 3D 回避在单独的回避模拟中运行，因此在它们之间划分的代理不会相互影响。
- 属性 `avoidance_layers` 和 `avoidance_mask` 是类似于例如物理层的位掩码。代理将仅避开位于与其自己的回避掩码位中的至少一个相匹配的回避层上的其他回避对象。
- `avoidance_priority` 使优先级较高的代理忽略优先级较低的代理。这可以用于在避免模拟中赋予某些代理更大的重要性，例如重要的 npc 角色，而不必不断改变其整个避免层或掩码。

回避存在于其自身的空间中，并且没有来自导航网格或物理碰撞的信息。场景背后的回避代理只是平面 2D 平面上具有不同半径的圆，或者是其他空的 3D 空间中的球体。导航障碍物可用于向回避模拟添加一些环境约束，请参阅使用导航障碍物。

> **注意：**
>
> 回避不会影响寻路。它应该被视为一个额外的选项，用于不断移动无法有效地（重新）烘焙到导航网格中以在其周围移动的对象。

使用 NavigationAgent `enable_avoidance` 属性是切换回避的首选选项。以下代码片段可用于在代理上切换回避、创建或删除回避回调或切换回避模式。

```python
extends NavigationAgent2D

var agent: RID = get_rid()
# Enable avoidance
NavigationServer2D.agent_set_avoidance_enabled(agent, true)
# Create avoidance callback
NavigationServer2D.agent_set_avoidance_callback(agent, Callable(self, "_avoidance_done"))

# Disable avoidance
NavigationServer2D.agent_set_avoidance_enabled(agent, false)
# Delete avoidance callback
NavigationServer2D.agent_set_avoidance_callback(agent, Callable())
```

```python
extends NavigationAgent3D

var agent: RID = get_rid()
# Enable avoidance
NavigationServer3D.agent_set_avoidance_enabled(agent, true)
# Create avoidance callback
NavigationServer3D.agent_set_avoidance_callback(agent, Callable(self, "_avoidance_done"))
# Switch to 3D avoidance
NavigationServer3D.agent_set_use_3d_avoidance(agent, true)

# Disable avoidance
NavigationServer3D.agent_set_avoidance_enabled(agent, false)
# Delete avoidance callback
NavigationServer3D.agent_set_avoidance_callback(agent, Callable())
# Switch to 2D avoidance
NavigationServer3D.agent_set_use_3d_avoidance(agent, false)
```

#### NavigationAgent 脚本模板

以下部分提供了 NavigationAgents 常用节点的脚本模板。

##### 扮演 Node3D

此脚本将基本导航移动添加到具有 NavigationAgent3D 子节点的 Node3D 中。

```python
extends Node3D

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
var movement_delta: float

func _ready() -> void:
    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
    navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
    if navigation_agent.is_navigation_finished():
        return

    movement_delta = movement_speed * delta
    var next_path_position: Vector3 = navigation_agent.get_next_path_position()
    var current_agent_position: Vector3 = global_position
    var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_delta
    if navigation_agent.avoidance_enabled:
        navigation_agent.set_velocity(new_velocity)
    else:
        _on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
    global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)
```

##### 扮演 CharacterBody3D

此脚本将基本导航移动添加到具有 NavigationAgent3D 子节点的 CharacterBody3D 中。

```python
extends CharacterBody3D

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func _ready() -> void:
    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
    navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
    if navigation_agent.is_navigation_finished():
        return

    var next_path_position: Vector3 = navigation_agent.get_next_path_position()
    var current_agent_position: Vector3 = global_position
    var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
    if navigation_agent.avoidance_enabled:
        navigation_agent.set_velocity(new_velocity)
    else:
        _on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
    velocity = safe_velocity
    move_and_slide()
```

##### 扮演 RigidBody3D

此脚本将基本导航移动添加到具有 NavigationAgent3D 子节点的 RigidBody3D 中。

```python
extends RigidBody3D

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func _ready() -> void:
    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
    navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
    if navigation_agent.is_navigation_finished():
        return

    var next_path_position: Vector3 = navigation_agent.get_next_path_position()
    var current_agent_position: Vector3 = global_position
    var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
    if navigation_agent.avoidance_enabled:
        navigation_agent.set_velocity(new_velocity)
    else:
        _on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
    linear_velocity = safe_velocity
```

### 使用 NavigationObstacles

导航障碍物可以用作静态或动态障碍物，以影响规避控制主体。

- 当静态使用时，导航障碍物会将躲避控制的代理约束在多边形定义区域的外部或内部。
- 当动态使用时，导航障碍物会推开周围半径范围内的躲避控制代理。

NavigationObstructs 节点的 2D 和 3D 版本分别作为 NavigationObstact2D 和 NavigationObstect3D 可用。

> **注意：**
>
> 导航障碍物不会以任何方式改变或影响寻路。导航障碍物只影响由回避控制的主体的回避速度。

#### 静态障碍物

当 NavigationObstruct 的顶点属性由位置的轮廓数组填充以形成多边形时，它被视为静态的。

- 静态障碍物起到了坚硬的作用——不跨越边界使用代理进行躲避，例如类似于物理碰撞，但用于躲避。
- 静态障碍物通过一组轮廓 `vertices`（位置）定义其边界，在 3D 的情况下，则使用额外的 `height` 属性。
- 静态障碍物仅适用于使用 2D 回避模式的代理。
- 静态障碍通过顶点的缠绕顺序来定义，若代理被推出或吸入。
- 静止的障碍物不能改变它们的位置。它们只能被扭曲到一个新的位置，然后从头开始重建。因此，静态障碍物不适合每帧改变位置的用途，因为持续重建具有高性能成本。
- 瞬移到另一个位置的静态障碍物无法由代理预测。如果静态障碍物瞬移在代理身上，这就产生了代理被卡住的风险。

当在 3D 中使用 2D 回避时，Vector3 顶点的 y 轴将被忽略。相反，障碍物的全局 y 轴位置被用作高程级别。代理将忽略三维中位于其下方或上方的静态障碍物。这是由障碍物和代理的全局 y 轴位置自动确定的，作为高程水平以及它们各自的高度特性。

#### 动态障碍

当导航障碍物的 `radius` 属性大于零时，该障碍物被认为是动态的。

- 动态障碍物就像一个柔软的请远离我的物体，使用代理进行躲避，例如，类似于它们躲避其他代理的方式。
- 动态障碍物用 2D 圆的单个 `radius` 定义其边界，或者在 3D 躲避的情况下用球体形状定义其边界。
- 动态障碍物可以在每帧改变其位置，而无需额外的性能成本。
- 具有设定速度的动态障碍物可以通过代理在其运动中进行预测。
- 在拥挤或狭窄的空间中，动态障碍物不是约束代理人的可靠方法。

虽然静态和动态特性可以在同一障碍物上同时激活，但不建议这样做以提高性能。理想情况下，当障碍物移动时，静态顶点被移除，而半径被激活。当障碍物到达新的最终位置时，它应该逐渐扩大半径，将所有其他物体推开。在障碍物周围创建了足够的节省空间后，应再次添加静态顶点并移除半径。这有助于避免在重建静态边界完成时，代理卡在突然出现的静态障碍中。

与代理类似，障碍物可以使用 `avoidance_layers` 位掩码。所有在自己的回避遮罩上有匹配位的代理都会避开障碍物。

#### 程序障碍

可以直接在 NavigationServer 上创建新的障碍物，而无需节点。

用脚本创建的障碍至少需要一个 `map` 和一个 `position`。对于动态使用，需要 `radius`。对于静态使用，需要一个 `vertices` 数组。

```python
# For 2D

# create a new "obstacle" and place it on the default navigation map.
var new_obstacle_rid: RID = NavigationServer2D.obstacle_create()
var default_2d_map_rid: RID = get_world_2d().get_navigation_map()

NavigationServer2D.obstacle_set_map(new_obstacle_rid, default_2d_map_rid)
NavigationServer2D.obstacle_set_position(new_obstacle_rid, global_position)

# Use obstacle dynamic by increasing radius above zero.
NavigationServer2D.obstacle_set_radius(new_obstacle_rid, 5.0)

# Use obstacle static by adding a square that pushes agents out.
var outline = PackedVector2Array([Vector2(-100, -100), Vector2(100, -100), Vector2(100, 100), Vector2(-100, 100)])
NavigationServer2D.obstacle_set_vertices(new_obstacle_rid, outline)

# Enable the obstacle.
NavigationServer2D.obstacle_set_avoidance_enabled(new_obstacle_rid, true)
```

```python
# For 3D

# Create a new "obstacle" and place it on the default navigation map.
var new_obstacle_rid: RID = NavigationServer3D.obstacle_create()
var default_3d_map_rid: RID = get_world_3d().get_navigation_map()

NavigationServer3D.obstacle_set_map(new_obstacle_rid, default_3d_map_rid)
NavigationServer3D.obstacle_set_position(new_obstacle_rid, global_position)

# Use obstacle dynamic by increasing radius above zero.
NavigationServer3D.obstacle_set_radius(new_obstacle_rid, 0.5)

# Use obstacle static by adding a square that pushes agents out.
var outline = PackedVector3Array([Vector3(-5, 0, -5), Vector3(5, 0, -5), Vector3(5, 0, 5), Vector3(-5, 0, 5)])
NavigationServer3D.obstacle_set_vertices(new_obstacle_rid, outline)
# Set the obstacle height on the y-axis.
NavigationServer3D.obstacle_set_height(new_obstacle_rid, 1.0)

# Enable the obstacle.
NavigationServer3D.obstacle_set_avoidance_enabled(new_obstacle_rid, true)
```

### 使用 NavigationLinks

NavigationLinks 用于在任意距离上连接 NavigationRegion2D 和 NavigationRegion3D 中的导航网格多边形，以进行路径查找。

NavigationLinks 还用于考虑通过与游戏对象（如梯子、跳跃垫或传送带）交互而获得的路径查找中的移动快捷方式。

NavigationJumplinks 节点的二维和三维版本分别作为 NavigationLink2D 和 NavigationLink3D 提供。

不同的 NavigationRegions 可以在不需要 NavigationLink 的情况下连接其导航网格，只要它们位于导航地图 `edge_connection_emargin` 内并具有兼容的 `navigation_layers` 即可。一旦距离变得太大，建立有效的连接就成了一个问题——NavigationLinks 可以解决这个问题。

请参阅使用导航区域以了解有关导航区域使用的更多信息。请参见连接导航网格以了解有关如何连接导航网格的详细信息。

NavigationLinks 与 NavigationRegions 共享许多属性，如 `navigation_layers`。与 NavigationRegions 相比，NavigationLinks 在任意距离的两个位置之间添加了单个连接，NavigationRegion 使用导航网格资源添加了更局部的可遍历区域。

NavigationLinks 有一个 `start_position` 和 `end_position`，并且在启用 `bidirectional` 时可以双向运行。放置导航链接后，导航链接会连接搜索半径内最靠近其 `start_position` 和 `end_position` 的导航网格多边形，以进行路径查找。

多边形搜索半径可以在 `navigation/2d_or_3d/default_link_connection_radius` 下的 ProjectSettings 中全局配置，也可以使用 `NavigationServer.map_set_link_connection_radius()` 函数为每个导航地图单独设置。

`start_position` 和 `end_position` 在编辑器中都有调试标记。位置的可见半径显示多边形搜索半径。将比较内部的所有导航网格多边形，并为边连接拾取最近的多边形。如果在搜索半径内未找到有效的多边形，则导航链接将被禁用。

链接调试视觉效果可以在编辑器 ProjectSettings 中的 `debug/shapes/navigation` 下更改。调试的可见性也可以在编辑器三维视口 gizmo 菜单中进行控制。

> **注意：**
>
> NavigationLinks 本身不会在两个链接位置之间移动代理。

导航链接不提供通过链接的任何自动移动。相反，当代理到达链接的位置时，游戏代码需要做出反应（例如通过区域触发器），并为代理移动通过链接以最终到达链接的其他位置（例如通过传送或动画）以继续沿着路径。

### 使用 NavigationLayers

NavigationLayers 是一个可选功能，用于进一步控制在路径查询中考虑哪些导航网格以及可以连接哪些区域。它们的工作原理类似于物理层如何控制碰撞对象之间的碰撞，或者视觉层如何控制渲染到 Viewport 的内容。

NavigationLayers 可以在 `ProjectSettings` 中与 PhysicsLayers 或 VisualLayers 相同地命名。

如果两个区域没有一个兼容的层，NavigationServer 将不会合并它们。有关合并导航网格的更多信息，请参见连接导航网格。

如果某个区域没有一个具有路径查询 `navigation_layers` 参数的兼容导航层，则在寻路时将跳过该区域导航网格。有关在 NavigationServer 中查询路径的详细信息，请参阅使用 NavigationPaths。

NavigationLayers 是用作 `bitMask` (位掩码) 的单个 `int` 值。许多与导航相关的节点都有 `set_navigation_layer_value()` 和 `get_navigation_Layeer_value()` 函数，可以直接设置和获取层数，而不需要更复杂的逐位操作。

在脚本中，可以使用以下辅助函数来处理 navigation_layers 位掩码。

```python
func change_layers():
    var region: NavigationRegion3D = get_node("NavigationRegion3D")
    # enables 4-th layer for this region
    region.navigation_layers = enable_bitmask_inx(region.navigation_layers, 4)
    # disables 1-rst layer for this region
    region.navigation_layers = disable_bitmask_inx(region.navigation_layers, 1)

    var agent: NavigationAgent3D = get_node("NavigationAgent3D")
    # make future path queries of this agent ignore regions with 4-th layer
    agent.navigation_layers = disable_bitmask_inx(agent.navigation_layers, 4)

    var path_query_navigation_layers: int = 0
    path_query_navigation_layers = enable_bitmask_inx(path_query_navigation_layers, 2)
    # get a path that only considers 2-nd layer regions
    var path: PoolVector3Array = NavigationServer3D.map_get_path(
        map,
        start_position,
        target_position,
        true,
        path_query_navigation_layers
        )

static func is_bitmask_inx_enabled(_bitmask: int, _index: int) -> bool:
    return _bitmask & (1 << _index) != 0

static func enable_bitmask_inx(_bitmask: int, _index: int) -> int:
    return _bitmask | (1 << _index)

static func disable_bitmask_inx(_bitmask: int, _index: int) -> int:
    return _bitmask & ~(1 << _index)
```

更改路径查询的导航层是启用/禁用整个导航区域的一种性能友好的替代方案。与区域更改相比，具有不同导航层的导航路径查询不会触发 NavigationServer 上的大规模更新。

更改 NavigationAgent 节点的导航层将对下一个路径查询产生直接影响。更改区域的导航层将立即对区域产生影响，但任何新的区域连接或断开连接都将仅在下一个物理帧之后生效。

### 导航调试工具

> **注意：**
>
> 调试工具、属性和函数仅在 Godot 调试构建中可用。不要在将成为发布构建一部分的代码中使用它们中的任何一个。

#### 启用调试导航

默认情况下，导航调试可视化在编辑器中启用。若要在运行时可视化导航网格和连接，请启用编辑器调试菜单中的 `Visible Navigation`（可见导航）选项。

在 Godot 调试构建中，还可以通过脚本在 NavigationServers 上切换导航调试。

```python
NavigationServer2D.set_debug_enabled(false)
NavigationServer3D.set_debug_enabled(true)
```

#### 调试导航设置

导航调试的外观可以在 `debug/shapes/navigation` 下的 ProjectSettings 中更改。某些调试功能也可以随意启用或禁用，但可能需要重新启动场景才能应用。

#### 调试导航网格多边形

如果启用了 `enable_edge_lines`，则导航网格多边形的边将高亮显示。如果同时启用 `enable_edge_lines_xray`，则导航网格的边将通过几何体可见。

如果启用 `enable_geometry_face_random_color`，则每个导航网格面接收与来自 `geometry_face_color` 的主颜色混合的随机颜色。

#### 调试边缘连接

在 `edge_connection_margin` 距离内连接的不同导航网格被覆盖。覆盖的颜色由导航调试 `edge_connection_color` 控制。可以使用导航调试 `enable_edge_connections_xray` 属性使连接通过几何体可见。

> **注意：**
>
> 只有当 NavigationServer 处于活动状态时，边缘连接才可见。

#### 调试性能

要测量 NavigationServer 性能，可以在编辑器调试器中的 *“调试器”->“监视器”->“NavigationProcess”* 下找到一个专用监视器。

NavigationProcess 以毫秒为单位显示 NavigationServer 更新其内部的时间。NavigationProcess 的工作原理类似于视觉帧渲染的 Process 和碰撞和修复更新的 PhysicsProcess。

NavigationProcess 负责 `navigation maps`、`navigation regions` 和 `navigation agents` 的所有更新，以及更新框架的所有 `avoidance calculations`。

> **注意：**
>
> NavigationProcess 不包括寻路性能，因为寻路操作独立于服务器进程更新的导航地图数据。

一般情况下，NavigationProcess 的运行时性能应尽可能低且稳定，以避免帧速率问题。请注意，由于 NavigationServer 进程更新发生在物理更新的中间，NavigationProcess 的增加将自动增加 PhysicsProcess 相同的数量。

Navigation 还提供了有关 NavigationServer 上当前导航相关对象和导航地图组成的更详细统计信息。

这里显示的导航统计数据不能被判断为性能的好坏，因为它完全取决于项目的合理或过度。

导航统计信息有助于识别不太明显的性能瓶颈，因为源可能并不总是具有可见的表示形式。例如，由于具有数千条边/多边形的导航网格过于详细而导致的寻路性能问题，或者由于过程导航出错而导致的问题。

### 连接导航网格

当一条边的至少两个顶点位置完全重叠时，NavigationServer 会自动合并不同的导航网格。

要在任意距离上进行连接，请参见使用导航链接。

对于多个 NavigationPolygon 资源也是如此。只要它们的轮廓点正好重叠，NavigationServer 就会将它们合并。NavigationPolygon 轮廓必须来自不同的 NavigationPolyon 资源才能连接。

在同一 NavigationPolygon 上重叠或相交的轮廓将无法创建导航网格。来自不同 NavigationPolygons 的重叠或相交轮廓通常无法在 NavigationServer 上创建导航区域边缘连接，因此应避免。

> **警告:**
>
> 精确意味着顶点位置合并的精确性。导入网格经常发生的小浮动错误将阻止顶点合并的成功。

或者，当 `NavigationMesh` 的边几乎平行且彼此相距一定距离时，NavigationMesh 不会合并，但仍被 NavigationServer 视为连接。连接距离由每个导航地图的 `edge_connection_margin` 定义。在许多情况下，NavigationMesh 边在部分重叠时无法正确连接。为了实现一致的合并行为，最好始终避免任何导航网格重叠。

如果启用了导航调试并且 NavigationServer 处于活动状态，则已建立的导航网格连接将被可视化。有关导航调试选项的详细信息，请参阅导航调试工具。

默认的 2D `edge_connection_margin` 可以在 `navigation/2d/default_edge_connection_margin` 下的 ProjectSettings 中更改。

默认的 3D `edge_connection_margin` 可以在 `navigation/3d/default_edge_connection_margin` 下的 ProjectSettings 中更改。

也可以使用 NavigationServer API 在运行时更改任何导航地图的边缘连接边距值。

```python
extends Node2D
# 2D margins are designed to work with "pixel" values
var default_2d_map_rid: RID = get_world_2d().get_navigation_map()
NavigationServer2D.map_set_edge_connection_margin(default_2d_map_rid, 50.0)
```

```python
extends Node3D
# 3D margins are designed to work with 3D unit values
var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
NavigationServer3D.map_set_edge_connection_margin(default_3d_map_rid, 0.5)
```

> **注意：**
>
> 更改边缘连接边距将触发 NavigationServer 上所有导航网格连接的完全更新。

### 支持不同的演员类型

为了支持不同的行动者类型，例如，由于它们的大小，每种类型都需要自己的导航地图和导航网格，并使用适当的代理半径和高度烘焙。同样的方法可以用于区分例如陆上行走、游泳或飞行代理。

> **注意：**
>
> 代理仅由烘焙导航网格、路径查找和避免的半径和高度值定义。不支持更复杂的形状。

```python
# create navigation mesh resources for each actor size
var navigation_mesh_standard_size: NavigationMesh = NavigationMesh.new()
var navigation_mesh_small_size: NavigationMesh = NavigationMesh.new()
var navigation_mesh_huge_size: NavigationMesh = NavigationMesh.new()

# set appropriated agent parameters
navigation_mesh_standard_size.agent_radius = 0.5
navigation_mesh_standard_size.agent_height = 1.8
navigation_mesh_small_size.agent_radius = 0.25
navigation_mesh_small_size.agent_height = 0.7
navigation_mesh_huge_size.agent_radius = 1.5
navigation_mesh_huge_size.agent_height = 2.5

# get the root node for the baking to parse geometry
var root_node: Node3D = get_node("NavigationMeshBakingRootNode")

# bake the navigation geometry for each agent size
NavigationMeshGenerator.bake(navigation_mesh_standard_size, root_node)
NavigationMeshGenerator.bake(navigation_mesh_small_size, root_node)
NavigationMeshGenerator.bake(navigation_mesh_huge_size, root_node)

# create different navigation maps on the NavigationServer
var navigation_map_standard: RID = NavigationServer3D.map_create()
var navigation_map_small: RID = NavigationServer3D.map_create()
var navigation_map_huge: RID = NavigationServer3D.map_create()

# create a region for each map
var navigation_map_standard_region: RID = NavigationServer3D.region_create()
var navigation_map_small_region: RID = NavigationServer3D.region_create()
var navigation_map_huge_region: RID = NavigationServer3D.region_create()

# set navigation mesh for each region
NavigationServer3D.region_set_navigation_mesh(navigation_map_standard_region, navigation_mesh_standard_size)
NavigationServer3D.region_set_navigation_mesh(navigation_map_small_region, navigation_mesh_small_size)
NavigationServer3D.region_set_navigation_mesh(navigation_map_huge_region, navigation_mesh_huge_size)

# add regions to maps
navigation_map_standard_region.region_set_map(navigation_map_standard_region, navigation_map_standard)
navigation_map_small_region.region_set_map(navigation_map_small_region, navigation_map_small)
navigation_map_huge_region.region_set_map(navigation_map_huge_region, navigation_map_huge)

# wait a physics frame for sync
await get_tree().physics_frame

# query paths for each size
var path_standard_agent = NavigationServer3D.map_get_path(navigation_map_standard, start_pos, end_pos, true)
var path_small_agent = NavigationServer3D.map_get_path(navigation_mesh_small_size, start_pos, end_pos, true)
var path_huge_agent = NavigationServer3D.map_get_path(navigation_map_huge, start_pos, end_pos, true)
```

### 支持不同的演员移动

为了支持不同的演员移动，如蹲下和爬行，需要类似于支持不同演员类型的地图设置。

为蹲着或爬行的演员烘焙具有适当高度的不同导航网格，这样他们就可以在游戏世界中的狭窄区域找到路径。

当演员改变运动状态时，例如站起来、开始蹲下或爬行，请在适当的地图上查询路径。

如果回避行为也应该随着运动而改变，例如仅在站立时回避或仅避开处于相同运动状态的其他代理，则随着每次运动的改变，将参与者的回避代理切换到另一个回避图。

```python
func update_path():

    if actor_standing:
        path = NavigationServer3D.map_get_path(standing_navigation_map_rid, start_position, target_position, true)
    elif actor_crouching:
        path = NavigationServer3D.map_get_path(crouched_navigation_map_rid, start_position, target_position, true)
    elif actor_crawling:
        path = NavigationServer3D.map_get_path(crawling_navigation_map_rid, start_position, target_position, true)

func change_agent_avoidance_state():

    if actor_standing:
        NavigationServer3D.agent_set_map(avoidance_agent_rid, standing_navigation_map_rid)
    elif actor_crouching:
        NavigationServer3D.agent_set_map(avoidance_agent_rid, crouched_navigation_map_rid)
    elif actor_crawling:
        NavigationServer3D.agent_set_map(avoidance_agent_rid, crawling_navigation_map_rid)
```

> **注意：**
>
> 虽然可以立即对多个映射执行路径查询，但回避代理映射切换只有在下一次服务器同步后才会生效。

### 支持不同的演员区域访问

在游戏中，不同区域访问的一个典型例子是用不同的导航网格连接房间的门，并非所有演员都能一直访问。

在门位置添加 NavigationRegion。添加一个适当的导航网格，其大小与可以与周围导航网格连接的门相同。为了控制访问启用/禁用导航层位，使用相同导航层位的路径查询可以通过“门”导航网格找到路径。

比特掩码可以充当一组门钥匙或能力，并且只有在其寻路查询中具有至少一个匹配并启用的比特层的参与者才能找到通过该区域的路径。有关如何使用导航层和位掩码的详细信息，请参见使用导航层。

如果需要，也可以启用/禁用整个“门”区域，但如果禁用，将阻止所有路径查询的访问。

尽可能在路径查询中使用导航层，因为启用或禁用区域上的导航层会触发导航地图连接的性能昂贵的重新计算。

> **警告：**
>
> 更改导航层只会影响新路径查询，但不会自动更新现有路径。

### 优化导航性能

常见的导航相关性能问题可分为以下主题：

- 解析导航网格烘焙的 SceneTree 节点时出现性能问题。
- 烘焙实际导航网格时的性能问题。
- NavigationAgent 路径查询的性能问题。
- 实际路径搜索的性能问题。
- 同步导航地图时出现性能问题。

在以下部分中，可以找到有关如何识别和修复或至少减轻其对帧速率的影响的信息。

#### 解析场景树节点的性能问题

> **提示：**
>
> 更喜欢使用边缘尽可能少的简单形状，例如没有像圆形、球体或圆环体那样的圆形。
>
> 与复杂的视觉网格相比，更喜欢使用物理碰撞形状作为源几何体，因为网格需要从 GPU 复制，并且通常比必要的要详细得多。

通常，避免使用非常复杂的几何体作为烘焙导航网格的源几何体。例如，永远不要使用非常详细的视觉网格，因为将其形状解析为数据阵列并对其进行体素化以进行导航网格烘焙需要很长时间，因为最终导航网格上没有真正的质量增益。相反，使用形状的非常简化的细节级别版本。更好的是，使用非常原始的形状，如方框和矩形，它们只大致覆盖相同的几何体，但仍然可以产生足够好的烘焙结果来进行寻路。

与视觉网格相比，更喜欢使用简单的物理碰撞形状，作为烘焙导航网格的源几何体。默认情况下，物理形状是非常有限和优化的形状，易于快速解析。另一方面，视觉网格可以从简单到复杂。最重要的是，为了访问视觉网格数据，解析器需要从 RenderingServer 请求网格数据阵列，因为视觉网格数据直接存储在 GPU 上，而不是缓存在 CPU 上。这需要锁定 RenderingServer 线程，并且在多线程渲染运行时可能会严重影响运行时的帧速率。如果渲染运行单线程，则帧率影响可能会更糟，网格解析可能会在复杂网格上冻结整个游戏几秒钟。

#### 导航网格烘焙的性能问题

> **提示：**
>
> 在运行时，始终倾向于使用背景线程烘焙导航网格。
>
> 增加 NavigationMesh `cell_size` 和 `cell_height` 以创建更少的体素。
>
> 将 `SamplePartitionType` 从分水岭更改为单调或图层以获得烘焙性能。

> **警告：**
>
> 切勿使用节点缩放源几何体以避免精度错误。大多数比例仅在视觉上适用，即使在缩小比例的情况下，在基本比例下非常大的形状仍需要大量额外的处理。

如果可能的话，在运行时烘焙导航网格应该始终在后台线程中完成。即使是小尺寸的导航网格，烘焙所需的时间也可能比压缩到单个帧中所需的要长得多，至少在帧速率应保持在可承受水平的情况下是这样。

从 SceneTree 节点解析的源几何体数据的复杂性对烘焙性能有很大影响，因为所有东西都需要映射到网格/体素。对于运行时烘焙性能，NavigationMesh 单元格大小和单元格高度应设置得尽可能高，而不会导致游戏的导航网格质量问题。如果单元大小或单元高度设置得过低，则烘焙将被迫创建过多的体素来处理源几何体。如果源几何体跨越一个非常大的游戏世界，则烘焙过程甚至可能会耗尽中间的内存并导致游戏崩溃。分区类型也可以根据游戏源几何体的复杂程度来降低，以获得一些性能。例如，具有块状几何体的大部分平面的游戏可以摆脱单调或分层模式，这种模式烘焙速度要快得多（例如，因为它们不需要远距离传球）。

从不使用节点缩放源几何体。它不仅会导致许多错误匹配的顶点和边的精度误差，而且一些缩放只作为视觉效果存在，而不存在于实际解析的数据中。例如，如果在编辑器中以视觉方式缩小网格，例如在 MeshInstance 上设置为 0.001 的比例，则网格仍然需要处理巨大且非常复杂的体素网格以进行烘焙。

#### NavigationAgent 路径查询的性能问题

> **提示：**
>
> 避免不必要的路径重置和查询 NavigationAgent 脚本中的每一帧。
>
> 避免在同一帧中更新所有 NavigationAgent 路径。

自定义 NavigationAgent 脚本中的逻辑错误和浪费操作是导致性能问题的常见原因，例如，注意每一帧重置路径。默认情况下，NavigationAgent 被优化为仅在目标位置更改、导航地图更改或被迫离所需路径距离太远时查询新路径。

例如，当 AI 应该移动到玩家时，不应该将目标位置设置为每一帧的玩家位置，因为这会在每一帧中查询新的路径。相反，应该比较从当前目标位置到玩家位置的距离，并且只有当玩家移动得太远时，才应该设置新的目标位置。

不要事先检查是否每帧都能到达目标位置。看似无害的检查相当于在后台进行昂贵的路径查询。如果计划无论如何都要请求一条新的路径（如果该位置可以到达），则应直接查询路径。通过查看返回路径的最后一个位置，如果该位置与检查位置相距“可达”距离，则回答“该位置可达吗？”问题。这避免了对同一 NavigationAgent 在每帧执行两个完整路径查询。

将 NavigationAgent 的总数划分为更新组或使用随机计时器，以便它们不会在同一帧中全部请求新路径。

#### 实际路径搜索的性能问题

> **提示：**
>
> 通过减少多边形和边的数量来优化过度细化的导航网格。

实际路径搜索的成本与导航网格多边形和边的数量直接相关，而与游戏世界的实际大小无关。如果一个巨大的游戏世界使用非常优化的导航网格，只有很少的多边形覆盖大面积，那么性能应该是可以接受的。如果游戏世界被分割成非常小的导航网格，每个导航网格都有微小的多边形（就像 TileMaps 一样），寻路性能将降低。

一个常见的问题是，当路径查询中无法到达目标位置时，性能会突然下降。这种性能下降是“正常的”，是因为导航网格太大、太未优化，有太多的多边形和边需要搜索。在可以快速到达目标位置的正常路径搜索中，一旦到达该位置，寻路就会提前退出，这可以在一段时间内隐藏这种缺乏优化的情况。如果无法到达目标位置，寻路必须在可用多边形中进行更长的搜索，以确认该位置绝对无法到达。

#### 导航地图同步的性能问题

> **提示：**
>
> 尽可能按顶点而不是按边连接合并导航网格多边形。

当对导航网格或导航区域等进行更改时，NavigationServer 需要同步导航地图。根据导航网格的复杂性，这可能需要相当长的时间，这可能会影响帧速率。

NavigationServer 通过顶点或边连接合并导航网格。当两条不同边的两个顶点位于同一地图网格单元中时，会发生按顶点合并。这是一个相当快速和低成本的操作。边连接合并发生在第二次过程中，用于所有仍然未合并的边。通过距离和角度检查所有自由边缘是否存在可能的边缘连接，这是相当昂贵的。

因此，除了具有尽可能少的多边形边的一般规则外，应该通过顶点提前合并尽可能多的边，这样只剩下几条边用于更昂贵的边连接计算。调试导航性能监视器可用于获取有关可用多边形和边的数量以及其中有多少未按顶点合并或未按顶点进行合并的统计信息。如果合并的顶点和边连接之间的比率太大（顶点应该高得多），则导航网格的创建或放置会非常低效。

## 网络

### 高级多人

#### 高级与低级 API

下面解释 Godot 中高级和低级网络的差异以及一些基本原理。如果您想从头开始，并将网络添加到您的第一个节点，请跳到下面的初始化网络。但是以后一定要读剩下的！

Godot 始终支持通过 UDP、TCP 和一些更高级别的协议（如 HTTP 和 SSL）进行标准的低级别网络连接。这些协议是灵活的，几乎可以用于任何事情。然而，使用它们手动同步游戏状态可能需要大量的工作。有时，这项工作是无法避免的，或者是值得的，例如，在后端使用自定义服务器实现时。但在大多数情况下，值得考虑 Godot 的高级网络 API，它牺牲了对低级网络的一些细粒度控制，以获得更大的易用性。

这是由于低级别协议的固有限制：

- TCP 确保数据包总是可靠且有序地到达，但由于纠错，延迟通常会更高。它也是一个相当复杂的协议，因为它了解什么是“连接”，并针对通常不适合多人游戏等应用程序的目标进行优化。数据包被缓冲，以便以更大的批量发送，以更低的每个数据包开销换取更高的延迟。这可能对 HTTP 之类的东西有用，但通常对游戏不有用。其中一些可以配置和禁用（例如，通过禁用 TCP 连接的“Nagle 算法”）。
- UDP 是一种更简单的协议，只发送数据包（没有“连接”的概念）。没有纠错使它非常快速（低延迟），但数据包可能会在传输过程中丢失或以错误的顺序接收。除此之外，UDP 的 MTU（最大数据包大小）通常很低（只有几百字节），因此传输较大的数据包意味着拆分它们，重新组织它们，并在某个部分出现故障时重试。

一般来说，TCP 可以被认为是可靠的、有序的和缓慢的；UDP 是不可靠、无序和快速的。由于性能差异很大，重新构建游戏所需的 TCP 部分（可选的可靠性和数据包顺序），同时避免不需要的部分（拥塞/流量控制功能、Nagle 算法等）通常是有意义的。正因为如此，大多数游戏引擎都有这样的实现，Godot 也不例外。

总之，您可以使用低级网络 API 进行最大程度的控制，并在裸网络协议之上实现所有功能，或者使用基于 SceneTree 的高级 API，该 API 以通常优化的方式在幕后完成大部分繁重的工作。

> **注意：**
>
> Godot 支持的大多数平台都提供了上述所有或大部分高级和低级网络功能。然而，由于网络始终在很大程度上依赖于硬件和操作系统，一些功能可能会在某些目标平台上更改或不可用。最值得注意的是，HTML5 平台目前提供 WebSockets 和 WebRTC 支持，但缺乏一些更高级别的功能，以及对 TCP 和 UDP 等低级别协议的原始访问。

> **注意：**
>
> 有关 TCP/IP、UDP 和网络的详细信息：https://gafferongames.com/post/udp_vs_tcp/
>
> Gaffer On Games 有很多关于游戏中网络的有用文章（这里），包括对游戏中网络模型的全面介绍。
>
> 如果您想使用您选择的低级网络库，而不是 Godot 的内置网络，请参阅此处获取示例：https://github.com/PerduGames/gdnet3

> **警告：**
>
> 在游戏中添加网络是有责任的。如果操作不当，它可能会使您的应用程序变得脆弱，并可能导致作弊或漏洞利用。它甚至可能允许攻击者破坏您的应用程序运行的机器，并使用您的服务器发送垃圾邮件、攻击他人或在用户玩您的游戏时窃取用户的数据。
>
> 当涉及网络而与 Godot 无关时，情况总是如此。当然，您可以进行实验，但当您发布网络应用程序时，请始终注意任何可能的安全问题。

#### 中级抽象

在讨论如何跨网络同步游戏之前，了解用于同步的基础网络 API 是如何工作的可能会有所帮助。

Godot 使用中级对象 MultiplayerPeer。这个对象并不是要直接创建的，而是为了让几个 C++ 实现能够提供它而设计的。

此对象从 PacketPeer 扩展而来，因此它继承了所有用于序列化、发送和接收数据的有用方法。除此之外，它还添加了设置对等点、传输模式等的方法。它还包括可以让您知道对等点何时连接或断开连接的信号。

这个类接口可以抽象大多数类型的网络层、拓扑和库。默认情况下，Godot 提供了一个基于 ENet（ENetMultiplayerPeer）、一个基于 WebRTC（WebRTCMultiplayerPee）和一个基于 WebSocket（WebSocketPeer）的实现，但这可以用于实现移动 API（用于特设 WiFi、蓝牙）或自定义设备/控制台特定的网络 API。

对于大多数常见情况，不鼓励直接使用此对象，因为 Godot 提供了更高级别的网络设施。如果游戏对较低级别的 API 有特定需求，这个对象仍然可用。

#### 托管注意事项

当托管服务器时，局域网上的客户端可以使用内部 IP 地址进行连接，该地址的格式通常为 `192.168.*.*`。非局域网/互联网客户端无法访问该内部 IP 地址。
在 Windows 上，您可以通过打开命令提示符并输入 `ipconfig` 来找到您的内部 IP 地址。在 macOS 上，打开一个终端并输入 `ifconfig`。在 Linux 上，打开一个终端并输入 `ip addr`。

如果你在自己的机器上托管服务器，并希望非局域网客户端连接到它，你可能必须转发路由器上的服务器端口。由于大多数住宅连接使用 NAT，因此这是使您的服务器可以从 Internet 访问所必需的。Godot 的高级多人 API 仅使用 UDP，因此您必须以 UDP 而不仅仅是 TCP 转发端口。

在转发 UDP 端口并确保您的服务器使用该端口后，您可以使用此网站查找您的公共 IP 地址。然后将此公共 IP 地址提供给任何希望连接到服务器的 Internet 客户端。

Godot 的高级多人 API 使用 ENet 的修改版本，该版本允许完全支持 IPv6。

#### 初始化网络

Godot 中控制网络的对象与控制所有与树相关的内容的对象相同：SceneTree。

要初始化高级网络，必须为 SceneTree 提供 NetworkedMultiplayerPeer 对象。

要创建该对象，首先必须将其初始化为服务器或客户端。

作为服务器初始化，在给定的端口上侦听，具有给定的最大对等数量：

```python
var peer = NetworkedMultiplayerENet.new()
peer.create_server(SERVER_PORT, MAX_PLAYERS)
get_tree().network_peer = peer
```

作为客户端初始化，连接到给定的 IP 和端口：

```python
var peer = NetworkedMultiplayerENet.new()
peer.create_client(SERVER_IP, SERVER_PORT)
get_tree().network_peer = peer
```

获取先前设置的网络对等端：

```python
get_tree().get_network_peer()
```

正在检查树是否初始化为服务器或客户端：

```python
get_tree().is_network_server()
```

终止网络功能：

```python
get_tree().network_peer = null
```

（尽管根据你的游戏，先发送一条消息让其他对等方知道你要离开，而不是让连接关闭或超时，这可能是有意义的。）

> **警告：**
>
> 导出到 Android 时，在导出项目或使用一键部署之前，请确保在Android导出预设中启用INTERNET权限。否则，任何类型的网络通信都将被安卓系统阻止。

#### 管理连接

有些游戏在任何时候都接受连接，另一些则在大厅阶段。Godot 可以被请求在任何时候不再接受连接（请参阅 SceneTree 上的 `set_refuse_new_network_connections(bool)` 和相关方法）。为了管理连接者，Godot 在 SceneTree 中提供以下信号：

服务器和客户端：

- `network_peer_connected(int id)`
- `network_peer_disconnected(int id)`

当一个新的对等端连接或断开连接时，连接到服务器的每个对等端（包括服务器上的对等端）都会调用上述信号。客户端将使用大于 1 的唯一 ID 进行连接，而网络对等方 ID  1 始终是服务器。任何低于 1 的都应视为无效。您可以通过 `SceneTree.get_network_unique_id()` 检索本地系统的 ID。这些 ID 主要用于大厅管理，通常应该存储，因为它们可以识别连接的对等方，从而识别玩家。您还可以使用 ID 仅向某些对等方发送消息。

客户端：

- `connected_to_server`
- `connection_failed`
- `server_disconnected`

同样，所有这些功能主要用于大厅管理或动态添加/删除玩家。对于这些任务，服务器显然必须作为服务器工作，您必须手动执行任务，例如向新连接的玩家发送有关其他已连接玩家的信息（例如，他们的姓名、统计数据等）。

Lobbies 可以以任何方式实现，但最常见的方式是在所有对等体的场景中使用具有相同名称的节点。通常，自动加载的节点/单例非常适合这样做，始终可以访问，例如 “/root/loglog”。

#### RPC

要在对等方之间进行通信，最简单的方法是使用 RPC（远程过程调用）。这是在 Node 中实现的一组功能：

- `rpc("function_name", <optional_args>)`
- `rpc_id(<peer_id>,"function_name", <optional_args>)`
- `rpc_unreliable("function_name", <optional_args>)`
- `rpc_unreliable_id(<peer_id>, "function_name", <optional_args>)`

同步成员变量也是可能的：

- `rset("variable", value)`
- `rset_id(<peer_id>, "variable", value)`
- `rset_unreliable("variable", value)`
- `rset_unreliable_id(<peer_id>, "variable", value)`

函数可以用两种方式调用：

- 可靠：当函数调用到达时，会发回确认消息；如果在一定时间后没有收到确认，则函数调用将被重新传输。
- 不可靠：函数调用只发送一次，没有检查它是否到达，但也没有任何额外的开销。

在大多数情况下，需要可靠。不可靠在同步对象位置时最有用（同步必须不断发生，如果数据包丢失，也没那么糟糕，因为新的数据包最终会到达，而且它可能会过时，因为在此期间对象移动得更远，即使它被可靠地重新发送）。

`SceneTree` 中还有 `get_rpc_sender_id` 函数，可用于检查哪个对等方（或对等方 id）发送了 RPC。

#### 返回大厅

让我们回到大厅。想象一下，每个连接到服务器的玩家都会告诉每个人这件事。

```python
# Typical lobby implementation; imagine this being in /root/lobby.

extends Node

# Connect all functions

func _ready():
    get_tree().network_peer_connected.connect(_player_connected)
    get_tree().network_peer_disconnected.connect(_player_disconnected)
    get_tree().connected_to_server.connect(_connected_ok)
    get_tree().connection_failed.connect(_connected_fail)
    get_tree().server_disconnected.connect(_server_disconnected)

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }

func _player_connected(id):
    # Called on both clients and server when a peer connects. Send my info to it.
    rpc_id(id, "register_player", my_info)

func _player_disconnected(id):
    player_info.erase(id) # Erase player from info.

func _connected_ok():
    pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
    pass # Server kicked us; show error and abort.

func _connected_fail():
    pass # Could not even connect to server; abort.

remote func register_player(info):
    # Get the id of the RPC sender.
    var id = get_tree().get_rpc_sender_id()
    # Store the info
    player_info[id] = info

    # Call function to update lobby UI here
```

您可能已经注意到了一些不同之处，那就是 `register_player` 函数中 `remote` 关键字的用法：

```python
remote func register_player(info):
```

这个关键字有两个主要用途。第一个是让 Godot 知道这个函数可以从 RPC 调用。如果没有添加关键字，Godot 将阻止任何为安全起见调用函数的尝试。这使得安全工作变得容易得多（因此客户端不能调用函数来删除另一个客户端系统上的文件）。

第二个用途是指定如何通过 RPC 调用函数。有四个不同的关键字：

- `remote`
- `remotesync`
- `master`
- `puppet`

`remote` 关键字表示 `rpc()` 调用将通过网络远程执行。

`remotesync` 关键字意味着 `rpc()` 调用将通过网络远程执行，但也将在本地执行（执行正常的函数调用）。

其他的将进一步解释。请注意，您还可以在 `SceneTree` 上使用 `get_rpc_sender_id` 函数来检查哪个对等方实际对 `register_player` 进行了 RPC 调用。

有了这一点，大厅管理或多或少应该得到解释。一旦你开始游戏，你很可能会想添加一些额外的安全措施，以确保客户端不会做任何有趣的事情（只需验证他们不时发送的信息，或在游戏开始前发送的信息）。为了简单起见，也因为每个游戏都会共享不同的信息，所以这里没有显示。

#### 开始游戏

一旦大厅里聚集了足够多的玩家，服务器就应该开始游戏了。这本身并没有什么特别的，但我们将解释一些在这一点上可以做的好技巧，让你的生活变得更轻松。

##### 玩家场景

在大多数游戏中，每个玩家都可能有自己的场景。请记住，这是一款多人游戏，因此在每个对等体中，您需要为**每个连接到它的玩家实例化一个场景**。对于 4 人游戏，每个对等体需要实例化 4 个玩家节点。

那么，如何命名这样的节点呢？在 Godot 中，节点需要有一个唯一的名称。玩家也必须相对容易地判断哪个节点代表每个玩家 ID。

解决方案是简单地将实例化的玩家场景的根节点命名为它们的网络 ID。这样，它们在每个对等体中都是相同的，RPC 将非常有效！以下是一个示例：

```python
remote func pre_configure_game():
    var selfPeerID = get_tree().get_network_unique_id()

    # Load world
    var world = load(which_level).instantiate()
    get_node("/root").add_child(world)

    # Load my player
    var my_player = preload("res://player.tscn").instantiate()
    my_player.set_name(str(selfPeerID))
    my_player.set_multiplayer_authority(selfPeerID) # Will be explained later
    get_node("/root/world/players").add_child(my_player)

    # Load other players
    for p in player_info:
        var player = preload("res://player.tscn").instantiate()
        player.set_name(str(p))
        player.set_multiplayer_authority(p) # Will be explained later
        get_node("/root/world/players").add_child(player)

    # Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
    # The server can call get_tree().get_rpc_sender_id() to find out who said they were done.
    rpc_id(1, "done_preconfiguring")
```

**注意：**
根据执行 pre_configure_game() 的时间，您可能需要通过 `call_deferred()` 将对 `add_child()` 的任何调用更改为延迟调用，因为场景树在创建场景时被锁定（例如，在调用 `_ready()` 时）。

##### 同步游戏开始

由于滞后、硬件不同或其他原因，设置玩家可能需要每个对等方花费不同的时间。为了确保游戏在每个人都准备好的时候真正开始，暂停游戏直到所有玩家都准备好可能很有用：

```python
remote func pre_configure_game():
    get_tree().set_pause(true) # Pre-pause
    # The rest is the same as in the code in the previous section (look above)
```

当服务器从所有对等端获得 OK 时，它可以告诉它们启动，例如：

```python
var players_done = []
remote func done_preconfiguring():
    var who = get_tree().get_rpc_sender_id()
    # Here are some checks you can do, for example
    assert(get_tree().is_network_server())
    assert(who in player_info) # Exists
    assert(not who in players_done) # Was not added yet

    players_done.append(who)

    if players_done.size() == player_info.size():
        rpc("post_configure_game")

remote func post_configure_game():
    # Only the server is allowed to tell a client to unpause
    if 1 == get_tree().get_rpc_sender_id():
        get_tree().set_pause(false)
        # Game starts now!
```

#### 同步游戏

在大多数游戏中，多人网络的目标是让游戏在所有玩它的同行上同步运行。除了提供 RPC 和远程成员变量集实现外，Godot 还添加了网络主机的概念。

##### 网络主机

节点的网络主节点是对其拥有最终权限的对等节点。

如果未明确设置，则网络主机将从父节点继承，如果未更改，则父节点将始终是服务器（ID 1）。因此，默认情况下，服务器对所有节点都具有权限。

可以使用以下函数设置网络主机：ref:`Node.set_multiplier_authority(id，recursive)`（recursive 默认为 `true`，意味着网络主机也在节点的所有子节点上递归设置）。

通过调用 `Node.is_network_master()` 来检查对等体上的特定节点实例是否是该节点的网络主机。当在服务器上执行时，这将返回 `true`，而在所有客户端对等体上返回 `false`。

如果你已经注意到前面的例子，你可能会注意到每个对等点都被设置为拥有自己玩家（节点）的网络主权限，而不是服务器：

```python
[...]
# Load my player
var my_player = preload("res://player.tscn").instantiate()
my_player.set_name(str(selfPeerID))
my_player.set_multiplayer_authority(selfPeerID) # The player belongs to this peer; it has the authority.
get_node("/root/world/players").add_child(my_player)

# Load other players
for p in player_info:
    var player = preload("res://player.tscn").instantiate()
    player.set_name(str(p))
    player.set_multiplayer_authority(p) # Each other connected peer has authority over their own player.
    get_node("/root/world/players").add_child(player)
[...]
```

每次在每个对等体上执行这段代码时，对等体都会使自己在其控制的节点上成为主节点，而所有其他节点都保持为傀儡，服务器是它们的网络主节点。

为了澄清，这里有一个轰炸机演示中的例子：

##### master 和 puppet 关键词

该模型的真正优势在于与 GDScript 中的 `master`/`puppet` 关键字（或 C# 中的等效关键字）一起使用。与 `remote` 关键字类似，函数也可以使用它们进行标记：

炸弹代码示例：

```python
for p in bodies_in_area:
    if p.has_method("exploded"):
        p.rpc("exploded", bomb_owner)
```

玩家代码示例：

```python
puppet func stun():
    stunned = true

master func exploded(by_who):
    if stunned:
        return # Already stunned

    rpc("stun")

    # Stun this player instance for myself as well; could instead have used
    # the remotesync keyword above (in place of puppet) to achieve this.
    stun()
```

在上面的例子中，炸弹在某个地方爆炸（可能由该炸弹节点的主节点管理，例如主机）。炸弹知道该区域中的尸体（玩家节点），因此在调用之前会检查它们是否包含 `explode` 方法。

回想一下，每个对等体都有一组完整的玩家节点实例，每个对等方（包括其自身和主机）有一个实例。每个对等体都将自己设置为与自己对应的实例的主节点，并将不同的对等体设置为其他每个实例的主对象。

现在，回到对 `exploded` 方法的调用，主机上的炸弹已经在该区域所有有该方法的物体上远程调用了它。但是，此方法位于玩家节点中，并且有一个 `master` 关键字。

玩家节点中 `exploded` 方法上的 `master` 关键字表示如何进行此调用的两个方面。首先，从主叫对等体（主机）的角度来看，主叫对等方只会尝试远程调用其设置为所讨论的播放器节点的网络主机的对等体上的方法。其次，从主机向其发送呼叫的对等方的角度来看，只有当对等方将自己设置为被调用方法（具有 `master` 关键字）的玩家节点的网络主机时，对等方才会接受呼叫。只要所有同行都同意谁是什么的主人，这就很有效。

上述设置意味着，只有拥有受影响身体的同伴才有责任告诉所有其他同伴，在被宿主的炸弹远程指示后，它的身体被震撼了。因此，拥有它的对等点（仍然使用 `explode` 方法）告诉所有其他对等点，它的玩家节点被震撼了。对等方通过在该玩家节点的所有实例上（在其他对等方上）远程调用 `stun` 方法来实现这一点。因为 `stun` 方法有 `puppet` 关键字，所以只有没有将自己设置为节点的网络主机的对等方才会调用它（换句话说，这些对等方由于不是该节点的网络主而被设置为该节点的 puppet）。

这次调用 `stun` 的结果是让玩家在所有对等体的屏幕上看起来都被震撼了，包括当前的网络主对等体（由于 `rpc("stun")` 之后的本地调用 `stun`）。

炸弹的主人（主持人）对该区域中的每一具尸体重复上述步骤，这样炸弹区域中任何玩家的所有实例都会在所有同行的屏幕上被震撼。

请注意，您也可以使用 `rpc_id(<id>, "exploded", bomb_owner)` 仅向特定玩家发送 `stun()` 消息。这对于炸弹这样的作用区域来说可能没有多大意义，但在其他情况下可能会有意义，比如单目标损伤。

```python
rpc_id(TARGET_PEER_ID, "stun") # Only stun the target peer
```

#### 为专用服务器导出

一旦你制作了一个多人游戏，你可能想把它导出到一个没有 GPU 的专用服务器上运行。有关详细信息，请参阅导出专用服务器。

> **注意：**
>
> 此页面上的代码示例不是为在专用服务器上运行而设计的。你必须修改它们，这样服务器就不会被视为玩家。您还必须修改游戏启动机制，以便第一个加入的玩家可以启动游戏。

> **注意：**
>
> 这里的 bomberman 示例主要是为了说明目的，在主机端没有做任何事情来处理对等方使用自定义客户端进行欺骗的情况，例如拒绝震撼自己。在当前的实现中，这种欺骗是完全可能的，因为每个客户端都是其自己玩家的网络主机，而玩家的网络主控器是决定是否在所有其他对等体和其自身上调用 I-was-stunned 方法（`stun`）的人。

### 发出 HTTP 请求

#### 为什么要使用 HTTP？

HTTP 请求对于与 web 服务器和其他非 Godot 程序进行通信非常有用。

与 Godot 的其他网络功能（如高级多人游戏）相比，HTTP 请求的开销更大，需要花费更多的时间，因此它们不适合实时通信，也不适合像多人游戏中常见的那样发送大量小更新。

然而，HTTP 提供了与外部网络资源的互操作性，并且非常擅长发送和接收大量数据，例如传输游戏资产等文件。

因此，HTTP 可能对您的游戏登录系统、大厅浏览器、从网络检索一些信息或下载游戏资产很有用。

本教程假定您熟悉 Godot 和 Godot 编辑器。请参阅简介和分步教程，特别是其中的节点和场景以及创建第一个脚本页面（如果需要）。

#### Godot 中的 HTTP 请求

HTTPRequest 节点是在 Godot 中发出 HTTP 请求的最简单方法。它由更低级的 HTTPClient 支持，这里有一个教程。

对于这个例子，我们将向 GitHub 发出 HTTP 请求，以检索最新 Godot 版本的名称。

> **警告：**
>
> 导出到 **Android** 时，在导出项目或使用一键部署之前，请确保在 Android 导出预设中启用 **Internet** 权限。否则，任何类型的网络通信都将被 Android 操作系统阻止。

#### 准备场景

创建一个新的空场景，添加一个根节点并添加一个脚本。然后添加一个 HTTPRequest 节点作为子节点。

#### 编写请求脚本

当项目启动时（所以在 `_ready()` 中），我们将使用 HTTPRequest 节点向 Github 发送一个 HTTP 请求，一旦请求完成，我们将解析返回的 JSON 数据，查找 `name` 字段并将其打印到控制台。

```python
extends Node

func _ready():
    $HTTPRequest.request_completed.connect(_on_request_completed)
    $HTTPRequest.request("https://api.github.com/repos/godotengine/godot/releases/latest")

func _on_request_completed(result, response_code, headers, body):
    var json = JSON.parse_string(body.get_string_from_utf8())
    print(json["name"])
```

保存脚本和场景，然后运行项目。Github 上最新发布的 Godot 的名称应该打印到输出日志中。有关解析 JSON 的更多信息，请参阅 JSON 的类引用。

请注意，您可能需要检查 `result` 是否等于 `RESULT_SUCCESS`，以及是否发生 JSON 解析错误，请参阅 JSON 类引用和 HTTPRequest 以了解更多信息。
在发送另一个请求之前，您必须等待一个请求完成。一次发出多个请求需要每个请求有一个节点。一种常见的策略是根据需要在运行时创建和删除 HTTPRequest 节点。

#### 向服务器发送数据

到目前为止，我们仅限于从服务器请求数据。但是，如果您需要将数据发送到服务器，该怎么办？以下是一种常见的方法：

```python
var json = JSON.stringify(data_to_send)
var headers = ["Content-Type: application/json"]
$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
```

#### 设置自定义 HTTP 标头

当然，您也可以设置自定义 HTTP 头。它们以字符串数组的形式给出，每个字符串都包含一个格式为 `"header: value"` 的标头。例如，要设置自定义用户代理（HTTP 用户 `User-Agent`），可以使用以下内容：

```python
$HTTPRequest.request("https://api.github.com/repos/godotengine/godot/releases/latest", ["User-Agent: YourCustomUserAgent"])
```

> **警告：**
>
> 请注意，有人可能会分析和反编译您发布的应用程序，从而获得任何嵌入的授权信息，如令牌、用户名或密码。这意味着在游戏中嵌入数据库访问凭据等内容通常不是一个好主意。尽可能避免向攻击者提供有用的信息。

### HTTP 客户端类

HTTPClient 提供对 HTTP 通信的低级访问。对于更高级别的接口，您可能想先看一下 HTTPRequest，这里有一个教程。

> **警告：**
>
> 导出到 Android 时，在导出项目或使用一键部署之前，请确保在 Android 导出预设中启用 `INTERNET` 权限。否则，任何类型的网络通信都将被安卓系统阻止。

下面是一个使用 HTTPClient 类的示例。它只是一个脚本，因此可以通过执行以下操作来运行：

```shell
c:\godot> godot -s http_test.gd
```

它将连接并获取一个网站。

```python
extends SceneTree

# HTTPClient demo
# This simple class can do HTTP requests; it will not block, but it needs to be polled.

func _init():
    var err = 0
    var http = HTTPClient.new() # Create the Client.

    err = http.connect_to_host("www.php.net", 80) # Connect to host/port.
    assert(err == OK) # Make sure connection is OK.

    # Wait until resolved and connected.
    while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
        http.poll()
        print("Connecting...")
        if not OS.has_feature("web"):
            OS.delay_msec(500)
        else:
            yield(Engine.get_main_loop(), "idle_frame")

    assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Check if the connection was made successfully.

    # Some headers
    var headers = [
        "User-Agent: Pirulo/1.0 (Godot)",
        "Accept: */*"
    ]

    err = http.request(HTTPClient.METHOD_GET, "/ChangeLog-5.php", headers) # Request a page from the site (this one was chunked..)
    assert(err == OK) # Make sure all is OK.

    while http.get_status() == HTTPClient.STATUS_REQUESTING:
        # Keep polling for as long as the request is being processed.
        http.poll()
        print("Requesting...")
        if OS.has_feature("web"):
            # Synchronous HTTP requests are not supported on the web,
            # so wait for the next main loop iteration.
            yield(Engine.get_main_loop(), "idle_frame")
        else:
            OS.delay_msec(500)

    assert(http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED) # Make sure request finished well.

    print("response? ", http.has_response()) # Site might not have a response.

    if http.has_response():
        # If there is a response...

        headers = http.get_response_headers_as_dictionary() # Get response headers.
        print("code: ", http.get_response_code()) # Show response code.
        print("**headers:\\n", headers) # Show headers.

        # Getting the HTTP Body

        if http.is_response_chunked():
            # Does it use chunks?
            print("Response is Chunked!")
        else:
            # Or just plain Content-Length
            var bl = http.get_response_body_length()
            print("Response Length: ", bl)

        # This method works for both anyway

        var rb = PackedByteArray() # Array that will hold the data.

        while http.get_status() == HTTPClient.STATUS_BODY:
            # While there is body left to be read
            http.poll()
            # Get a chunk.
            var chunk = http.read_response_body_chunk()
            if chunk.size() == 0:
                if not OS.has_feature("web"):
                    # Got nothing, wait for buffers to fill a bit.
                    OS.delay_usec(1000)
                else:
                    yield(Engine.get_main_loop(), "idle_frame")
            else:
                rb = rb + chunk # Append to read buffer.
        # Done!

        print("bytes got: ", rb.size())
        var text = rb.get_string_from_ascii()
        print("Text: ", text)

    quit()
```

### SSL 证书

#### 简介

通常需要使用 SSL 连接进行通信，以避免“中间人”攻击。Godot 有一个连接包装器 StreamPeerTLS，它可以接受常规连接并为其添加安全性。HTTPClient 类也通过使用这个包装器支持 HTTPS。

Godot 包括 Mozilla 的 SSL 证书，但您可以在项目设置中提供自己的 .crt 文件：

该文件应包含任何数量的 PEM 格式的公共证书。

当然，记得添加 .crt 作为过滤器，这样导出器在导出项目时就可以识别这一点。

有两种方式可以获得证书：

#### 方法 1：自签名证书

第一种方法是最简单的：生成私钥和公钥对，并将公钥（PEM 格式）添加到 .crt 文件中。私钥应该转到您的服务器。

OpenSSL 有一些相关文档。这种方法也不需要域验证，也不需要花费大量资金从 CA 购买证书。

#### 方法 2：CA 证书

第二种方法包括使用证书颁发机构（CA），如 Verisign、Geotrust 等。这是一个更繁琐的过程，但它更“官方”，并确保您的身份得到明确表示。

除非您与大公司或大公司合作，或者需要连接到其他人的服务器（即，通过 HTTPS 连接到谷歌或其他 REST API 提供商），否则此方法没有那么有用。

此外，当使用 CA 颁发的证书时，**您必须启用域验证**，以确保您要连接的域是预期的域，否则任何网站都可以在同一 CA 中颁发任何证书，并且它可以工作。

如果您使用的是 Linux，您可以使用提供的 certs 文件，该文件通常位于：

```
/etc/ssl/certs/ca-certificates.crt
```

该文件允许 HTTPS 连接到几乎任何网站（即谷歌、微软等）。

或者，如果要连接到特定的证书，请选择其中任何一个更具体的证书。

### WebSocket

#### HTML5 和 WebSocket

WebSocket 协议于 2011 年标准化，最初的目标是允许浏览器与服务器建立稳定的双向连接。在此之前，浏览器只支持 HTTPRequest，这不太适合双向通信。

该协议是基于消息的，是向浏览器发送推送通知的非常强大的工具，已用于实现聊天、回合制游戏等。它仍然使用 TCP 连接，这有利于可靠性，但不利于延迟，因此不适合 VoIP 和快节奏游戏等实时应用（请参阅 WebRTC 了解这些用例）。

由于其简单性、广泛的兼容性以及比原始 TCP 连接更容易使用，WebSocket 很快就开始在浏览器之外的本地应用程序中传播，作为与网络服务器通信的一种手段。

Godot 在本机和 HTML5 导出中都支持 WebSocket。

#### 在 Godot 中使用 WebSocket

WebSocket 是通过 WebSocketPeer 在 Godot 中实现的。WebSocket 实现与高级多人游戏兼容。有关更多详细信息，请参阅高级多人游戏部分。

> **警告：**
>
> 导出到 Android 时，在导出项目或使用一键部署之前，请确保在 Android 导出预设中启用 `INTERNET` 权限。否则，任何类型的网络通信都将被安卓系统阻止。

##### 最小客户端示例

这个示例将向您展示如何创建到远程服务器的 WebSocket 连接，以及如何发送和接收数据。

```python
extends Node

# The URL we will connect to
export var websocket_url = "wss://libwebsockets.org"

# Our WebSocketClient instance
var _client = WebSocketClient.new()

func _ready():
    # Connect base signals to get notified of connection open, close, and errors.
    _client.connection_closed.connect(_closed)
    _client.connection_error.connect(_closed)
    _client.connection_established.connect(_connected)
    # This signal is emitted when not using the Multiplayer API every time
    # a full packet is received.
    # Alternatively, you could check get_peer(1).get_available_packets() in a loop.
    _client.data_received.connect(_on_data)

    # Initiate connection to the given URL.
    var err = _client.connect_to_url(websocket_url, ["lws-mirror-protocol"])
    if err != OK:
        print("Unable to connect")
        set_process(false)

func _closed(was_clean = false):
    # was_clean will tell you if the disconnection was correctly notified
    # by the remote peer before closing the socket.
    print("Closed, clean: ", was_clean)
    set_process(false)

func _connected(proto = ""):
    # This is called on connection, "proto" will be the selected WebSocket
    # sub-protocol (which is optional)
    print("Connected with protocol: ", proto)
    # You MUST always use get_peer(1).put_packet to send data to server,
    # and not put_packet directly when not using the MultiplayerAPI.
    _client.get_peer(1).put_packet("Test packet".to_utf8())

func _on_data():
    # Print the received packet, you MUST always use get_peer(1).get_packet
    # to receive data from server, and not get_packet directly when not
    # using the MultiplayerAPI.
    print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())

func _process(delta):
    # Call this in _process or _physics_process. Data transfer, and signals
    # emission will only happen when calling this function.
    _client.poll()
```

这将打印：

```
Connected with protocol:
Got data from server: Test packet
```

##### 最小服务器示例

这个示例将向您展示如何创建一个监听远程连接的 WebSocket 服务器，以及如何发送和接收数据。

```python
extends Node

# The port we will listen to
const PORT = 9080
# Our WebSocketServer instance
var _server = WebSocketServer.new()

func _ready():
    # Connect base signals to get notified of new client connections,
    # disconnections, and disconnect requests.
    _server.client_connected.connect(_connected)
    _server.client_disconnected.connect(_disconnected)
    _server.client_close_request.connect(_close_request)
    # This signal is emitted when not using the Multiplayer API every time a
    # full packet is received.
    # Alternatively, you could check get_peer(PEER_ID).get_available_packets()
    # in a loop for each connected peer.
    _server.data_received.connect(_on_data)
    # Start listening on the given port.
    var err = _server.listen(PORT)
    if err != OK:
        print("Unable to start server")
        set_process(false)

func _connected(id, proto):
    # This is called when a new peer connects, "id" will be the assigned peer id,
    # "proto" will be the selected WebSocket sub-protocol (which is optional)
    print("Client %d connected with protocol: %s" % [id, proto])

func _close_request(id, code, reason):
    # This is called when a client notifies that it wishes to close the connection,
    # providing a reason string and close code.
    print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])

func _disconnected(id, was_clean = false):
    # This is called when a client disconnects, "id" will be the one of the
    # disconnecting client, "was_clean" will tell you if the disconnection
    # was correctly notified by the remote peer before closing the socket.
    print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func _on_data(id):
    # Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
    # and not get_packet directly when not using the MultiplayerAPI.
    var pkt = _server.get_peer(id).get_packet()
    print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
    _server.get_peer(id).put_packet(pkt)

func _process(delta):
    # Call this in _process or _physics_process.
    # Data transfer, and signals emission will only happen when calling this function.
    _server.poll()
```

这将打印（当客户端连接时）类似于以下内容：

```
Client 1348090059 connected with protocol: selected-protocol
Got data from client 1348090059: Test packet ... echoing
```

##### 高级聊天演示

godot 演示项目中的 *networking/websocket_chat* 和 *networking/websocket_player* 下提供了一个更高级的聊天演示，可以选择使用多人中级抽象和高级多人演示。

### WebRTC

#### HTML5、WebSocket、WebRTC

Godot 的一个伟大功能是它能够导出到 HTML5/WebAssembly 平台，当用户访问您的网页时，您的游戏可以直接在浏览器中运行。

这对演示和完整游戏来说都是一个很好的机会，但过去也有一些限制。在网络领域，浏览器过去只支持 HTTPRequest，直到最近，第一个 WebSocket 和后来的 WebRTC 被提议作为标准。

##### WebSocket

当 WebSocket 协议在 2011 年 12 月标准化时，它允许浏览器创建与 WebSocket 服务器的稳定双向连接。该协议是一个非常强大的工具，可以向浏览器发送推送通知，并已用于实现聊天、回合制游戏等。

不过，WebSocket 仍然使用 TCP 连接，这有利于可靠性，但不利于延迟，因此不适合 VoIP 和快节奏游戏等实时应用程序。

##### WebRTC

出于这个原因，自 2010 年以来，谷歌开始研究一种名为 WebRTC 的新技术，该技术后来在 2017 年成为 W3C 的候选推荐。WebRTC 是一组复杂得多的规范，它依赖于许多其他幕后技术（ICE、DTLS、SDP）来提供两个对等点之间的快速、实时和安全的通信。

其想法是在两个对等点之间找到最快的路由，并尽可能建立直接通信（即尽量避免中继服务器）。

然而，这是有代价的，即在通信开始之前，必须在两个对等体之间交换一些媒体信息（以会话描述协议 - SDP 字符串的形式）。这通常采用所谓的 WebRTC 信令服务器的形式。

对等方连接到信令服务器（例如 WebSocket 服务器）并发送其媒体信息。然后，服务器将此信息中继到其他对等端，允许它们建立所需的直接通信。一旦完成该步骤，对等端就可以断开与信令服务器的连接，并保持直接对等（P2P）连接的打开状态。

#### 在 Godot 中使用 WebRTC

WebRTC 在 Godot 中通过两个主要类 WebRTCPeerConnection 和 WebRTCDataChannel 以及多玩家 API 实现 WebRTCMultiplayerPeer 实现。有关更多详细信息，请参阅高级多人游戏部分。

> **注意：**
>
> 这些类在 HTML5 中自动可用，但**需要在本地（非 HTML5）平台上使用外部 GDExtension 插件**。查看 webrtc 原生插件存储库以获取说明和最新版本。

> **警告：**
>
> 导出到 Android 时，在导出项目或使用一键部署之前，请确保在 Android 导出预设中启用 `INTERNET` 权限。否则，任何类型的网络通信都将被安卓系统阻止。

##### 最小连接示例

此示例将向您展示如何在同一应用程序中的两个对等端之间创建 WebRTC 连接。这在现实生活中不是很有用，但会让您很好地了解如何设置 WebRTC 连接。

```python
extends Node

# Create the two peers
var p1 = WebRTCPeerConnection.new()
var p2 = WebRTCPeerConnection.new()
# And a negotiated channel for each each peer
var ch1 = p1.create_data_channel("chat", {"id": 1, "negotiated": true})
var ch2 = p2.create_data_channel("chat", {"id": 1, "negotiated": true})

func _ready():
    # Connect P1 session created to itself to set local description
    p1.connect("session_description_created", p1, "set_local_description")
    # Connect P1 session and ICE created to p2 set remote description and candidates
    p1.connect("session_description_created", p2, "set_remote_description")
    p1.connect("ice_candidate_created", p2, "add_ice_candidate")

    # Same for P2
    p2.connect("session_description_created", p2, "set_local_description")
    p2.connect("session_description_created", p1, "set_remote_description")
    p2.connect("ice_candidate_created", p1, "add_ice_candidate")

    # Let P1 create the offer
    p1.create_offer()

    # Wait a second and send message from P1
    yield(get_tree().create_timer(1), "timeout")
    ch1.put_packet("Hi from P1".to_utf8())

    # Wait a second and send message from P2
    yield(get_tree().create_timer(1), "timeout")
    ch2.put_packet("Hi from P2".to_utf8())

func _process(_delta):
    # Poll connections
    p1.poll()
    p2.poll()

    # Check for messages
    if ch1.get_ready_state() == ch1.STATE_OPEN and ch1.get_available_packet_count() > 0:
        print("P1 received: ", ch1.get_packet().get_string_from_utf8())
    if ch2.get_ready_state() == ch2.STATE_OPEN and ch2.get_available_packet_count() > 0:
        print("P2 received: ", ch2.get_packet().get_string_from_utf8())
```

这将打印：

```
P1 received: Hi from P1
P2 received: Hi from P2
```

##### 本地信号示例

这个例子扩展了前面的例子，在两个不同的场景中分离对等体，并使用单例作为信号服务器。

```python
# An example P2P chat client (chat.gd)
extends Node

var peer = WebRTCPeerConnection.new()

# Create negotiated data channel
var channel = peer.create_data_channel("chat", {"negotiated": true, "id": 1})

func _ready():
    # Connect all functions
    peer.ice_candidate_created.connect(_on_ice_candidate)
    peer.session_description_created.connect(_on_session)

    # Register to the local signaling server (see below for the implementation)
    Signaling.register(get_path())

func _on_ice_candidate(mid, index, sdp):
    # Send the ICE candidate to the other peer via signaling server
    Signaling.send_candidate(get_path(), mid, index, sdp)

func _on_session(type, sdp):
    # Send the session to other peer via signaling server
    Signaling.send_session(get_path(), type, sdp)
    # Set generated description as local
    peer.set_local_description(type, sdp)

func _process(delta):
    # Always poll the connection frequently
    peer.poll()
    if channel.get_ready_state() == WebRTCDataChannel.STATE_OPEN:
        while channel.get_available_packet_count() > 0:
            print(get_path(), " received: ", channel.get_packet().get_string_from_utf8())

func send_message(message):
    channel.put_packet(message.to_utf8())
```

现在对于本地信号服务器：

> **注意：**
>
> 这个本地信令服务器应该作为一个单例来连接同一场景中的两个对等点。

```python
# A local signaling server. Add this to autoloads with name "Signaling" (/root/Signaling)
extends Node

# We will store the two peers here
var peers = []

func register(path):
    assert(peers.size() < 2)
    peers.append(path)
    # If it's the second one, create an offer
    if peers.size() == 2:
        get_node(peers[0]).peer.create_offer()

func _find_other(path):
    # Find the other registered peer.
    for p in peers:
        if p != path:
            return p
    return ""

func send_session(path, type, sdp):
    var other = _find_other(path)
    assert(other != "")
    get_node(other).peer.set_remote_description(type, sdp)

func send_candidate(path, mid, index, sdp):
    var other = _find_other(path)
    assert(other != "")
    get_node(other).peer.add_ice_candidate(mid, index, sdp)
```

然后你可以像这样使用它：

```python
# Main scene (main.gd)
extends Node

const Chat = preload("res://chat.gd")

func _ready():
    var p1 = Chat.new()
    var p2 = Chat.new()
    add_child(p1)
    add_child(p2)
    yield(get_tree().create_timer(1), "timeout")
    p1.send_message("Hi from %s" % p1.get_path())

    # Wait a second and send message from P2
    yield(get_tree().create_timer(1), "timeout")
    p2.send_message("Hi from %s" % p2.get_path())
```

这将打印类似的内容：

```python
/root/main/@@3 received: Hi from /root/main/@@2
/root/main/@@2 received: Hi from /root/main/@@3
```

##### 使用 WebSocket 的远程信号

在 *networking/webrtc_signaling* 下的 godot 演示项目中提供了一个使用 WebSocket 进行对等信号和 WebRTCMultiplayerPeer 的更高级演示。

## 性能

### 简介

Godot 遵循平衡的性能哲学。在性能世界中，总是存在权衡，包括用速度换取可用性和灵活性。这方面的一些实际例子是：

- 高效地渲染大量对象很容易，但当必须渲染大型场景时，可能会变得效率低下。若要解决此问题，必须将可见性计算添加到渲染中。这会降低渲染效率，但同时渲染的对象也会减少。因此，提高了整体渲染效率。
- 为每个需要渲染的对象配置每个材质的属性也很慢。为了解决这个问题，对象按材质排序以降低成本。同时，排序也是有成本的。
- 在三维物理学中，也会发生类似的情况。处理大量物理对象（如 SAP）的最佳算法在插入/移除对象和光线投射方面速度较慢。允许更快插入和移除以及光线投射的算法将无法处理那么多活动对象。

还有更多这样的例子！游戏引擎在本质上力求通用。平衡算法总是比在某些情况下可能快而在其他情况下可能慢的算法，或者快速但更难使用的算法更受青睐。

Godot 也不例外。虽然它被设计为可以为不同的算法交换后端，但默认的后端将平衡和灵活性置于性能之上。

有了这一点，本教程部分的目的是解释如何从 Godot 中获得最大性能。虽然教程可以按任何顺序阅读，但最好从常规优化提示开始。

### 常规

#### 一般优化提示

##### 简介

在理想的世界里，计算机将以无限的速度运行。我们所能取得的成就的唯一限制就是我们的想象力。然而，在现实世界中，即使是最快的计算机也很容易生产出软件。

因此，设计游戏和其他软件是我们希望实现的目标和我们在保持良好性能的同时能够实际实现的目标之间的妥协。

为了达到最佳效果，我们有两种方法：

- 工作速度更快。
- 更聪明地工作。

最好，我们将使用两者的混合物。

##### 烟雾与镜子

更聪明地工作的一部分是认识到，在游戏中，我们经常可以让玩家相信他们所处的世界比实际情况更复杂、更互动、更令人兴奋。一个好的程序员就是一个魔术师，在尝试发明新技巧的同时，应该努力学习交易技巧。

##### 缓慢的本质

对于外部观察者来说，性能问题往往被集中在一起。但实际上，存在几种不同类型的性能问题：

- 每帧发生一次的缓慢过程，导致帧速率持续较低。
- 一种间歇性过程，会导致缓慢的“尖峰”，从而导致停滞。
- 在正常游戏之外发生的缓慢过程，例如，加载关卡时。

每一个都让用户感到厌烦，但方式各不相同。

#### 衡量性能

优化最重要的工具可能是衡量性能的能力——识别瓶颈所在，并衡量我们加快瓶颈的尝试是否成功。

有几种测量性能的方法，包括：

- 在感兴趣的代码周围放置启动/停止计时器。
- 使用 Godot 探查器。
- 使用外部第三方 CPU 评测器。
- 使用 GPU 评测器/调试器，如 NVIDIA Nsight Graphics 或 apitrace。
- 检查帧速率（禁用 V-Sync）。

请注意，不同区域的相对性能在不同的硬件上可能会有所不同。在多个设备上测量时间通常是个好主意。如果你的目标是移动设备，情况尤其如此。

##### 限制

CPU 评测器通常是衡量性能的常用方法。然而，它们并不总是能说明整个故事。

- 瓶颈通常出现在 GPU 上，这是 CPU 发出指令的“结果”。
- 由于 Godot 中使用的指令（例如，动态内存分配）的“结果”，操作系统进程（Godot 之外）中可能会出现尖峰。
- 由于需要初始设置，您可能无法始终对手机等特定设备进行配置。
- 您可能需要解决无法访问的硬件上出现的性能问题。

由于这些限制，您通常需要使用侦探工作来找出瓶颈所在。

##### 侦探工作

侦探工作对开发人员来说是一项至关重要的技能（无论是在性能方面，还是在 bug 修复方面）。这可以包括假设检验和二分搜索。

###### 假设检验

例如，假设你认为精灵正在减慢你的游戏速度。你可以通过以下方式来检验这个假设：

- 在添加更多精灵或删除一些精灵时测量性能。

这可能导致一个进一步的假设：精灵的大小是否决定了性能下降？

- 您可以通过保持所有内容不变，但更改精灵大小和测量性能来测试这一点。

###### 二分搜索

如果你知道帧所花费的时间比它们应该花费的时间长得多，但你不确定瓶颈在哪里。你可以从注释掉正常帧上发生的大约一半的例程开始。性能是否比预期提高了多少？

一旦你知道两个部分中的哪一个包含瓶颈，你就可以重复这个过程，直到你确定了有问题的区域。

#### 事件探查器

事件探查器允许您在运行程序时对程序计时。然后，事件探查器会提供结果，告诉您在不同函数和区域中花费的时间百分比，以及调用函数的频率。

这对于识别瓶颈和衡量改进的结果都非常有用。有时，试图提高性能可能会适得其反，导致性能下降。始终使用分析和计时来指导您的工作。

有关使用 Godot 内置探查器的更多信息，请参阅探查器。

#### 原则

唐纳德·克努思（Donald Knuth）说：

*程序员浪费了大量的时间来思考或担心程序中非关键部分的速度，而在考虑调试和维护时，这些提高效率的尝试实际上会产生强烈的负面影响。我们应该忘记小效率，比如说 97% 的时间：过早的优化是万恶之源。然而，我们不应该在关键的 3% 中放弃我们的机会。*

这些信息非常重要：

- 开发者时间有限。我们不应该盲目地试图加快项目的各个方面，而应该把精力集中在真正重要的方面。
- 优化工作的结果往往是代码比未优化的代码更难阅读和调试。将此限制在真正受益的领域符合我们的利益。

仅仅因为我们可以优化特定的代码，并不一定意味着我们*应该*这样做。知道何时以及何时不进行优化是一项很好的技能。

这句话的一个误导性方面是，人们倾向于关注“*过早优化是万恶之源*”这句话。虽然过早优化（根据定义）是不可取的，但高性能软件是高性能设计的结果。

##### 性能设计

鼓励人们在必要时忽略优化的危险在于，它很方便地忽略了考虑性能的最重要时间是在设计阶段，甚至在一个键碰到键盘之前。如果程序的设计或算法效率低下，那么以后再多的细节打磨也无法使其快速运行。它可能运行得更快，但永远不会像为性能而设计的程序那样快。

这在游戏或图形编程中往往比在一般编程中更重要。一个高性能的设计，即使没有低级别的优化，通常也会比具有低级别优化的平庸设计快很多倍。

##### 增量设计

当然，在实践中，除非你有先验知识，否则你不太可能第一次想出最好的设计。相反，您通常会对某个特定领域的代码进行一系列版本的编写，每个版本都对问题采取不同的方法，直到您找到满意的解决方案。在完成整体设计之前，在这个阶段不要在细节上花费太多时间，这一点很重要。否则，你的大部分工作都会被扔掉。

很难给出性能设计的一般指导方针，因为这取决于问题。不过，值得一提的是，在 CPU 方面，现代 CPU 几乎总是受到内存带宽的限制。这导致了面向数据的设计的复兴，它涉及到为数据的缓存局部性和线性访问设计数据结构和算法，而不是在内存中跳跃。

##### 优化过程

假设我们有一个合理的设计，并从 Knuth 那里吸取教训，我们优化的第一步应该是确定最大的瓶颈——最慢的功能，唾手可得的果实。

一旦我们成功地提高了最慢区域的速度，它就可能不再是瓶颈。因此，我们应该再次测试/评测，并找到下一个需要关注的瓶颈。

因此，该过程是：

1. 分析/识别瓶颈。
2. 优化瓶颈。
3. 返回步骤 1。

##### 优化瓶颈

一些评测器甚至会告诉你函数的哪一部分（数据访问、计算）正在减慢速度。

与设计一样，你应该首先集中精力确保算法和数据结构是最好的。数据访问应该是本地的（以最大限度地利用 CPU 缓存），而且通常使用紧凑的数据存储会更好（同样，总是根据测试结果进行简档）。通常，您会提前对繁重的计算进行预先计算。这可以通过在加载级别时执行计算、加载包含预先计算的数据的文件或简单地将复杂计算的结果存储到脚本常量中并读取其值来实现。

一旦算法和数据良好，您通常可以对例程进行小的更改，以提高性能。例如，可以将某些计算移动到循环之外，或者将嵌套的 `for` 循环转换为非嵌套的循环。（如果您事先知道 2D 阵列的宽度或高度，这应该是可行的。）

每次更改后，务必重新测试您的时间安排/瓶颈。有些变化会加快速度，有些则可能产生负面影响。有时，一个小的积极影响会被更复杂的代码的负面影响所抵消，你可能会选择忽略优化。

#### 附录

##### 瓶颈数学

谚语“一条链只有最薄弱的环节才能强大”直接适用于性能优化。如果你的项目 90% 的时间都花在函数 A 上，那么优化 A 会对性能产生巨大影响。

```
A: 9 ms
Everything else: 1 ms
Total frame time: 10 ms
```

```
A: 1 ms
Everything else: 1ms
Total frame time: 2 ms
```

在这个例子中，将这个瓶颈 A 改进 9 倍，使总帧时间减少了 5 倍，而每秒帧数增加了 5 倍。

然而，如果其他事情进展缓慢，也阻碍了你的项目，那么同样的改进可能会带来不那么显著的收益：

```
A: 9 ms
Everything else: 50 ms
Total frame time: 59 ms
```

```
A: 1 ms
Everything else: 50 ms
Total frame time: 51 ms
```

在这个例子中，尽管我们已经极大地优化了函数 A，但在帧速率方面的实际增益相当小。

在游戏中，事情变得更加复杂，因为 CPU 和 GPU 彼此独立运行。您的总帧时间由两者中较慢的一个决定。

```
CPU: 9 ms
GPU: 50 ms
Total frame time: 50 ms
```

```
CPU: 1 ms
GPU: 50 ms
Total frame time: 50 ms
```

在这个例子中，我们再次对 CPU 进行了巨大的优化，但帧时间没有改善，因为我们的 GPU 受到了瓶颈。

#### 使用服务器进行优化

像 Godot 这样的引擎由于其高级别的结构和功能而提供了更高的易用性。其中大部分是通过场景系统访问和使用的。使用节点和资源简化了复杂游戏中的项目组织和资产管理。

当然，总有缺点：

- 还有一层额外的复杂性。
- 性能低于直接使用简单 API 时的性能。
- 不可能使用多个线程来控制它们。
- 需要更多的内存。

在许多情况下，这并不是一个真正的问题（Godot 非常优化，大多数操作都是用信号处理的，因此不需要轮询）。尽管如此，有时还是可能的。例如，处理每帧需要处理的数万个实例可能会成为瓶颈。

这种情况让程序员后悔他们使用的是游戏引擎，并希望他们能回到更手工制作的低级别游戏代码实现。

尽管如此，Godot 是为解决这个问题而设计的。

> **参考：**
>
> 您可以使用 Bullet Shower 演示项目了解使用低级别服务器的工作原理

##### 服务器

Godot 最有趣的设计决策之一是整个场景系统是可选的。虽然目前还无法将其编译出来，但可以完全绕过它。

在核心，Godot 使用了服务器的概念。它们是非常低级的 API，用于控制渲染、物理、声音等。场景系统构建在它们之上，并直接使用它们。最常见的服务器有：

- RenderingServer：处理与图形相关的一切。
- PhysicsServer3D：处理与 3D 物理相关的一切。
- PhysicsServer2D：处理与 2D 物理相关的一切。
- AudioServer：处理与音频相关的一切。

探索他们的API，你会意识到提供的所有功能都是 Godot 允许你做的一切的低级实现。

##### RID

使用服务器的关键是了解资源 ID（RID）对象。这些是服务器实现的不透明句柄。它们是手动分配和释放的。服务器中的几乎每个功能都需要 RID 来访问实际资源。

大多数 Godot 节点和资源内部都包含来自服务器的这些 RID，它们可以通过不同的功能获得。事实上，任何继承 Resource 的内容都可以直接转换为 RID。不过，并非所有资源都包含 RID：在这种情况下，RID 将为空。然后可以将资源作为 RID 传递给服务器 API。

> **警告:**
>
> 资源被引用计数（请参阅 RefCounted），在确定资源是否仍在使用时，对资源的 RID 的引用不被计数。请确保在服务器外部保留对资源的引用，否则它及其 RID 都将被删除。

对于节点，有许多可用功能：

- 对于 CanvasItem，CanvasItem.get_canvas_item() 方法将返回服务器中的画布项 RID。
- 对于 CanvasLayer，CanvasLayer.get_canvas() 方法将返回服务器中的画布 RID。
- 对于 Viewport，Viewport.get_Viewport_rid() 方法将返回服务器中的视口 RID。
- 对于 3D，World3D 资源（可在 Viewport 和 Node3D 节点中获得）包含用于获取 *RenderingServer 场景*和 *PhysicsServer 空间*的函数。这允许使用服务器 API 直接创建 3D 对象并使用它们。
- 对于 2D，World2D 资源（可在 Viewport 和 CanvasItem 节点中获得）包含用于获取 *RenderingServer Canvas* 和 *Physics2DServer Space* 的函数。这允许使用服务器 API 直接创建 2D 对象并使用它们。
- VisualInstance3D 类允许分别通过 VisualInstance3D.get_instance() 和 VisualInstance3D.get_base() 获取场景*实例*和*实例库*。

尝试探索您熟悉的节点和资源，并找到获取服务器 *RID* 的功能。

建议不要从已经关联了节点的对象中控制 RID。相反，服务器功能应该始终用于创建和控制新功能以及与现有功能交互。

##### 创建精灵

这是一个如何从代码创建 sprite 并使用低级 CanvasItem API 移动它的示例。

```python
extends Node2D


# RenderingServer expects references to be kept around.
var texture


func _ready():
    # Create a canvas item, child of this node.
    var ci_rid = RenderingServer.canvas_item_create()
    # Make this node the parent.
    RenderingServer.canvas_item_set_parent(ci_rid, get_canvas_item())
    # Draw a texture on it.
    # Remember, keep this reference.
    texture = load("res://my_texture.png")
    # Add it, centered.
    RenderingServer.canvas_item_add_texture_rect(ci_rid, Rect2(texture.get_size() / 2, texture.get_size()), texture)
    # Add the item, rotated 45 degrees and translated.
    var xform = Transform2D().rotated(deg_to_rad(45)).translated(Vector2(20, 30))
    RenderingServer.canvas_item_set_transform(ci_rid, xform)
```

服务器中的画布项 API 允许您向其中添加绘图原语。一旦添加，就无法修改。需要清除项并重新添加基元（设置变换时并非如此，变换可以根据需要多次执行）。

基本体通过以下方式清除：

```python
RenderingServer.canvas_item_clear(ci_rid)
```

##### 将网格实例化到三维空间

3D API 与 2D API 不同，因此必须使用实例化 API。

```python
extends Node3D


# RenderingServer expects references to be kept around.
var mesh


func _ready():
    # Create a visual instance (for 3D).
    var instance = RenderingServer.instance_create()
    # Set the scenario from the world, this ensures it
    # appears with the same objects as the scene.
    var scenario = get_world_3d().scenario
    RenderingServer.instance_set_scenario(instance, scenario)
    # Add a mesh to it.
    # Remember, keep the reference.
    mesh = load("res://mymesh.obj")
    RenderingServer.instance_set_base(instance, mesh)
    # Move the mesh around.
    var xform = Transform3D(Basis(), Vector3(20, 100, 0))
    RenderingServer.instance_set_transform(instance, xform)
```

##### 创建2D刚体并移动精灵

这将使用 PhysicsServer2D API 创建 RigidBody2D，并在实体移动时移动 CanvasItem。

```python
# Physics2DServer expects references to be kept around.
var body
var shape


func _body_moved(state, index):
    # Created your own canvas item, use it here.
    RenderingServer.canvas_item_set_transform(canvas_item, state.transform)


func _ready():
    # Create the body.
    body = Physics2DServer.body_create()
    Physics2DServer.body_set_mode(body, Physics2DServer.BODY_MODE_RIGID)
    # Add a shape.
    shape = Physics2DServer.rectangle_shape_create()
    # Set rectangle extents.
    Physics2DServer.shape_set_data(shape, Vector2(10, 10))
    # Make sure to keep the shape reference!
    Physics2DServer.body_add_shape(body, shape)
    # Set space, so it collides in the same space as current scene.
    Physics2DServer.body_set_space(body, get_world_2d().space)
    # Move initial position.
    Physics2DServer.body_set_state(body, Physics2DServer.BODY_STATE_TRANSFORM, Transform2D(0, Vector2(10, 20)))
    # Add the transform callback, when body moves
    # The last parameter is optional, can be used as index
    # if you have many bodies and a single callback.
    Physics2DServer.body_set_force_integration_callback(body, self, "_body_moved", 0)
```

3D 版本应该非常相似，因为 2D 和 3D 物理服务器是相同的（分别使用 RigidBody3D 和 PhysicsServer3D）。

##### 从服务器获取数据

除非你知道自己在做什么，否则尽量不要通过调用函数从 RenderingServer、PhysicsServer2D 或 PhysicsServer3D 请求任何信息。为了提高性能，这些服务器通常会异步运行，调用任何返回值的函数都会使它们停滞，并迫使它们处理任何挂起的事情，直到实际调用该函数为止。如果你每帧都调用它们，这将严重降低性能（原因并不明显）。

正因为如此，此类服务器中的大多数 API 都是这样设计的，所以在可以保存实际数据之前，甚至不可能请求回信息。

### CPU

#### CPU 优化

#### 衡量性能

我们必须知道“瓶颈”在哪里，才能知道如何加快我们的计划。瓶颈是程序中最慢的部分，限制了一切进展的速度。关注瓶颈使我们能够集中精力优化能够最大程度提高速度的领域，而不是花费大量时间优化会带来小性能改进的功能。

对于 CPU 来说，识别瓶颈的最简单方法是使用探查器。

#### CPU 探查器

探查器与程序一起运行，并进行时间测量，以计算出每个函数所花费的时间比例。

Godot IDE 方便地拥有一个内置的探查器。它并不是每次启动项目时都运行：它必须手动启动和停止。这是因为，像大多数评测器一样，记录这些计时测量可能会大大降低项目的速度。

在分析之后，您可以回顾一个帧的结果。

> **注意：**
>
> 我们可以看到物理和音频等内置过程的成本，也可以看到我们自己的脚本功能的成本。
>
> 等待各种内置服务器所花费的时间可能不会计入分析程序中。这是一个已知的错误。

当一个项目运行缓慢时，你经常会看到一个明显的功能或过程比其他功能或过程花费更多的时间。这是您的主要瓶颈，您通常可以通过优化此区域来提高速度。

有关使用 Godot 内置探查器的更多信息，请参阅 Debugger 面板。

##### 外部探查器

尽管 Godot IDE 探查器非常方便和有用，但有时您需要更多的功能，以及对 Godot 引擎源代码本身进行探查的能力。

您可以使用许多第三方评测器来执行此操作，包括 Valgrind、VerySleepy、HotSpot、Visual Studio 和 Intel VTune。

> **注意：**
>
> 您需要从源代码编译 Godot 才能使用第三方探查器。这是获取调试符号所必需的。您也可以使用调试生成，但是，请注意，分析调试生成的结果与发布生成的结果不同，因为调试生成的优化程度较低。瓶颈通常在调试构建中处于不同的位置，因此您应该尽可能地对发布构建进行概要分析。

从左边开始，Callgrind 列出了函数及其子函数内的时间百分比（Inclusive）、在函数本身内花费的时间百分比，不包括子函数（Self）、调用函数的次数、函数名称以及文件或模块。

在这个例子中，我们可以看到几乎所有的时间都花在 *Main::iteration()* 函数下。这是重复调用的 Godot 源代码中的主函数。它会导致绘制帧、模拟物理记号以及更新节点和脚本。很大一部分时间花在渲染画布的函数上（66%），因为本例使用了 2D 基准测试。下面，我们看到几乎 50% 的时间都花在了 `libglapi` 和 `i965_dri`（图形驱动程序）中 Godot 代码之外。这告诉我们，大部分 CPU 时间都花在了图形驱动程序上。

这实际上是一个很好的例子，因为在理想的世界里，只有很小一部分时间会花在图形驱动程序上。这表明图形 API 中的通信和工作太多存在问题。这种特定的分析导致了 2D 批处理的发展，它通过减少该领域的瓶颈大大加快了 2D 渲染。

#### 手动计时功能

另一种方便的技术，尤其是在使用探查器识别出瓶颈后，是手动为测试中的函数或区域计时。具体内容因语言而异，但在 GDScript 中，您可以执行以下操作：

```python
var time_start = OS.get_ticks_usec()

# Your function you want to time
update_enemies()

var time_end = OS.get_ticks_usec()
print("update_enemies() took %d microseconds" % time_end - time_start)
```

手动计时函数时，通常最好多次（1000 次或更多次）运行该函数，而不是仅运行一次（除非它是一个非常慢的函数）。这样做的原因是计时器的精度通常有限。此外，CPU 将以一种随意的方式调度进程。因此，一系列运行的平均值比一次测量更准确。

当您试图优化函数时，请确保在执行过程中重复配置文件或计时。这将为您提供关于优化是否有效的关键反馈。

#### 缓存

CPU 缓存还有一些需要特别注意的地方，尤其是在比较一个函数的两个不同版本的定时结果时。结果可能高度依赖于数据是否在 CPU 缓存中。CPU 不会直接从系统 RAM 加载数据，尽管与 CPU 缓存相比数据量很大（几 GB 而不是几 MB）。这是因为系统 RAM 的访问速度非常慢。相反，CPU 从一个称为缓存的更小、更快的内存库加载数据。从缓存加载数据非常快，但每次尝试加载未存储在缓存中的内存地址时，缓存都必须访问主内存并缓慢加载一些数据。这种延迟可能导致 CPU 长时间闲置，并被称为“缓存未命中”。

这意味着，第一次运行函数时，它可能会运行缓慢，因为数据不在 CPU 缓存中。第二次及以后，它可能会运行得更快，因为数据在缓存中。因此，在计时时始终使用平均值，并注意缓存的影响。

了解缓存对 CPU 优化也至关重要。如果你有一个算法（例程），从随机分布的主内存区域加载少量数据，这可能会导致大量缓存未命中，很多时候，CPU 会等待数据，而不是做任何工作。相反，如果您可以使数据访问本地化，或者更好地以线性方式（如连续列表）访问内存，那么缓存将以最佳方式工作，CPU 将能够尽可能快地工作。

Godot 通常会为您处理这些低级的细节。例如，服务器 API 确保数据已经针对渲染和物理等方面的缓存进行了优化。不过，在编写 GDExtensions 时，您应该特别注意缓存。

#### 语言

Godot 支持许多不同的语言，值得记住的是，其中涉及到一些权衡。有些语言的设计是以速度为代价的，而另一些语言速度更快，但更难使用。

无论您选择何种脚本语言，内置引擎函数都以相同的速度运行。如果您的项目在自己的代码中进行大量计算，请考虑将这些计算转移到更快的语言中。

##### GDScript

GDScript 设计为易于使用和迭代，非常适合制作多种类型的游戏。然而，在这种语言中，易用性被认为比性能更重要。如果你需要进行大量的计算，可以考虑将你的一些项目转移到其他语言中。

##### C#

C# 很受欢迎，在 Godot 有一流的支持。它在速度和易用性之间提供了一个很好的折衷方案。不过，要注意游戏过程中可能发生的垃圾收集暂停和泄漏。解决垃圾收集问题的一种常见方法是使用对象池，这超出了本指南的范围。

##### 其他语言

第三方为包括 Rust 在内的其他几种语言提供支持。

##### C++

Godot 是用 C++ 编写的。使用 C++ 通常会产生最快的代码。然而，在实际层面上，部署到不同平台上的最终用户机器是最困难的。使用 C++ 的选项包括 GDExtensions 和自定义模块。

#### 线程

在进行大量可以并行运行的计算时，请考虑使用线程。现代 CPU 有多个核心，每个核心都能做有限的工作。通过将工作分散在多个线程上，您可以进一步提高 CPU 效率。

线程的缺点是必须非常小心。由于每个 CPU 核心独立运行，它们最终可能会试图同时访问同一内存。一个线程可以读取变量，而另一个线程正在写入：这被称为竞赛条件。在使用线程之前，请确保您了解危险以及如何尝试和预防这些比赛条件。

线程也会使调试变得相当困难。GDScript 调试器还不支持在线程中设置断点。

有关线程的更多信息，请参阅使用多个线程。

#### 场景树（SceneTree）

尽管节点是一个非常强大和通用的概念，但要注意每个节点都有成本。诸如 *_process()* 和 *_physics_process()* 之类的内置函数在树中传播。当您拥有大量节点时，这种内务管理会降低性能（节点数量取决于目标平台，范围从数千到数万不等，因此请确保在开发过程中对所有目标平台上的性能进行评测）。

每个节点在 Godot 渲染器中单独处理。因此，节点数量越少，每个节点中的节点越多，可以获得更好的性能。

[SceneTree](https://docs.godotengine.org/en/stable/classes/class_scenetree.html#class-scenetree) 的一个怪癖是，有时通过从场景树中删除节点，而不是暂停或隐藏节点，可以获得更好的性能。您不必删除已分离的节点。例如，您可以保留对某个节点的引用，使用 Node.remove_child(node) 将其从场景树中分离，然后稍后使用 Node.add_child(node) 将其重新附加。例如，这对于在游戏中添加和删除区域非常有用。

您可以通过使用服务器 API 完全避开场景树。有关详细信息，请参阅使用服务器进行优化。

#### 物理学

在某些情况下，物理学最终可能成为一个瓶颈。复杂的世界和大量的物理物体尤其如此。

以下是一些加速物理学的技术：

- 尝试将渲染几何体的简化版本用于碰撞形状。通常，这对最终用户来说并不明显，但可以大大提高性能。
- 当物理对象在当前区域之外时，尝试从物理对象中移除对象，或者重用物理对象（例如，可能每个区域允许 8 个怪物，然后重用这些怪物）。

物理学的另一个关键方面是物理学的勾选率。在一些游戏中，你可以大大降低勾选率，例如，你可以每秒只更新 30 次甚至 20 次物理，而不是每秒更新 60 次。这可以大大降低 CPU 负载。

更改物理节拍速率的缺点是，当物理更新速率与渲染的每秒帧数不匹配时，可能会出现抖动或抖动。此外，降低物理勾选率将增加输入滞后。在大多数具有实时玩家移动功能的游戏中，建议坚持默认的物理节拍率（60 Hz）。

抖动的解决方案是使用固定的时间步长插值，这涉及到在多个帧上平滑渲染的位置和旋转，以匹配物理。您可以自己实现，也可以使用第三方插件。就性能而言，与运行物理刻度相比，插值是一种非常便宜的操作。它的速度快了几个数量级，因此这可以在降低抖动的同时显著提高性能。

### GPU

#### GPU 优化

##### 简介

对新图形功能和进步的需求几乎保证了您将遇到图形瓶颈。其中一些可以在 CPU 端，例如在 Godot 引擎内部的计算中，为渲染准备对象。瓶颈也可能发生在图形驱动程序中的 CPU 上，该驱动程序对传递给 GPU 的指令进行排序，以及这些指令的传输。最后，GPU 本身也会出现瓶颈。

渲染中出现瓶颈的地方是高度特定于硬件的。特别是移动 GPU 可能会遇到在桌面上轻松运行的场景。

了解和调查 GPU 瓶颈与 CPU 上的情况略有不同。这是因为，通常情况下，您只能通过更改给 GPU 的指令来间接更改性能。此外，进行测量可能会更加困难。在许多情况下，衡量性能的唯一方法是检查渲染每帧所花费时间的变化。

#### 绘制调用、状态更改和 API

> **注意：**
>
> 以下章节与最终用户无关，但有助于提供后面章节中相关的背景信息。

Godot 通过图形 API（OpenGL、OpenGL ES 或 Vulkan）向 GPU 发送指令。所涉及的通信和驱动程序活动可能非常昂贵，尤其是在 OpenGL 和 OpenGL ES 中。如果我们能够以驱动程序和 GPU 喜欢的方式提供这些指令，我们可以大大提高性能。

OpenGL 中的几乎每个 API 命令都需要进行一定的验证，以确保 GPU 处于正确的状态。即使是看似简单的命令也可能引发一系列幕后内务处理。因此，我们的目标是将这些指令减少到最低限度，并尽可能多地将类似的对象分组在一起，以便它们可以一起渲染，或者使用这些昂贵的状态更改的最小数量。

##### 二维批处理

在 2D 中，单独处理每个项目的成本可能高得令人望而却步——屏幕上很容易出现数千个项目。这就是使用 2D *批处理*的原因。通过单个绘制调用将多个类似的项目分组在一起并在一批中渲染，而不是为每个项目单独调用绘制。此外，这意味着状态变化、材质和纹理变化可以保持在最低限度。

##### 三维批处理

在 3D 中，我们仍然致力于最大限度地减少绘制调用和状态更改。但是，将多个对象批处理到一个绘图调用中可能会更加困难。3D 网格往往包括数百或数千个三角形，实时组合大型网格的成本高得令人望而却步。随着每个网格的三角形数量的增加，连接它们的成本很快就会超过任何好处。一个更好的选择是**提前连接网格**（相对于彼此的静态网格）。这可以由艺术家完成，也可以在 Godot 中以编程方式完成。

在 3D 中将对象批处理在一起也会产生成本。渲染为一个对象的多个对象不能单独剔除。如果将屏幕外的整个城市连接到屏幕上的一片草地上，它仍将被渲染。因此，在尝试将三维对象批处理在一起时，应始终考虑对象的位置和剔除。尽管如此，连接静态对象的好处往往超过其他考虑因素，尤其是对于大量远距离或低多边形对象。

有关特定于三维的优化的详细信息，请参见优化三维性能。

##### 重用着色器和材质

Godot 渲染器与现有的有点不同。它的设计目的是尽可能减少 GPU 状态的变化。StandardMaterial3D 在重复使用需要类似着色器的材质方面做得很好。如果使用自定义着色器，请确保尽可能多地重用它们。Godot 的优先事项是：

重用材质：场景中不同的材质越少，渲染速度就越快。如果场景中有大量对象（数百或数千），请尝试重用这些材质。在最坏的情况下，请使用图集来减少纹理更改的数量。
重用着色器：如果材质无法重用，至少尝试重用着色器。注意：即使具有不同的参数，在共享相同配置（通过复选框启用或禁用的功能）的 StandardMaterial3D 之间也会自动重用着色器。

例如，如果一个场景有 `20,000` 个对象，每个对象有 `20,000` 种不同的材质，则渲染会很慢。如果同一场景有 `20,000` 个对象，但仅使用 `100` 种材质，则渲染速度会快得多。

#### 像素成本与顶点成本

您可能听说过，模型中多边形的数量越少，渲染速度就越快。这*确实*是相对的，取决于许多因素。

在现代 PC 和主机上，顶点成本很低。GPU 最初只渲染三角形。这意味着每一帧：

1. 所有顶点都必须由 CPU 进行转换（包括剪裁）。
2. 所有顶点都必须从主 RAM 发送到 GPU 内存。

如今，所有这些都在 GPU 内部处理，大大提高了性能。3D 艺术家通常对 polycount 性能有错误的感觉，因为 3D 建模软件（如 Blender、3ds Max 等）需要将几何体保存在 CPU 内存中才能进行编辑，从而降低了实际性能。游戏引擎更多地依赖 GPU，因此它们可以更有效地渲染许多三角形。

在移动设备上，情况有所不同。PC 和主机 GPU 是蛮力怪物，可以从电网中提取所需的电量。移动 GPU 仅限于一个小电池，因此它们需要更节能。

为了提高效率，移动 GPU 试图避免*过度绘制*。当屏幕上的同一像素被渲染多次时，会发生过度渲染。想象一下，一个有几栋建筑的小镇。GPU 在绘制之前不知道什么是可见的，什么是隐藏的。例如，可能会绘制一栋房子，然后在它前面绘制另一栋房子（这意味着对同一像素进行两次渲染）。PC GPU 通常不太关心这一点，只是在硬件上添加更多的像素处理器来提高性能（这也会增加功耗）。

在移动设备上，使用更多的电源不是一种选择，因此移动设备使用一种称为*基于瓦片的渲染*技术，将屏幕划分为网格。每个单元格都保留绘制到其上的三角形列表，并按深度对其进行排序，以最大限度地减少*过度绘制*。这项技术提高了性能并降低了功耗，但会影响顶点性能。因此，可以处理较少的顶点和三角形进行绘制。

此外，当屏幕的一小部分中存在具有大量几何体的小对象时，基于平铺的渲染会很困难。这迫使移动 GPU 在单个屏幕瓦片上施加很大的压力，这大大降低了性能，因为所有其他单元都必须等待它完成才能显示帧。

总之，不要担心移动设备上的顶点数，但**要避免顶点集中在屏幕的小部分**。如果角色、NPC、车辆等距离较远（这意味着它看起来很小），请使用较小的细节级别（LOD）模型。即使在桌面 GPU 上，也最好避免使用小于屏幕上像素大小的三角形。

使用时请注意所需的额外顶点处理：

- 蒙皮（骨骼动画）
- 变形（形状关键点）
- 顶点照明对象（在移动设备上常见）

#### 像素/片段着色器和填充率

与顶点处理相反，片段（每像素）着色的成本多年来急剧增加。屏幕分辨率提高了（4K 屏幕的面积为 8294400 像素，而旧的 640×480 VGA 屏幕的面积是 307200 像素，即面积的 27 倍），但碎片着色器的复杂性也激增。基于物理的渲染需要对每个片段进行复杂的计算。

你可以很容易地测试一个项目是否有填充率限制。关闭 V-Sync 以防止限制每秒帧数，然后将使用大窗口运行时的每秒帧数与使用非常小的窗口运行时进行比较。如果使用阴影，您也可以从类似地减少阴影贴图大小中受益。通常，你会发现使用一个小窗口，FPS 会增加很多，这表明你在某种程度上受到了填充率的限制。另一方面，如果 FPS 几乎没有增加，那么瓶颈就在其他地方。

您可以通过减少 GPU 必须做的工作量来提高填充率有限项目的性能。您可以通过简化着色器（如果使用 StandardMaterial3D，可能会关闭昂贵的选项）或减少所用纹理的数量和大小来实现这一点。此外，当使用非未着色粒子时，请考虑在其材质中强制顶点着色以降低着色成本。

> **参考：**
>
> 在支持的硬件上，可使用变速率着色来降低着色处理成本，而不会影响最终图像上边缘的清晰度。

**在目标是移动设备时，请考虑使用您可以合理负担得起的最简单的着色器。**

##### 读取纹理

片段着色器中的另一个因素是读取纹理的成本。读取纹理是一项昂贵的操作，尤其是在单个片段着色器中读取多个纹理时。此外，考虑过滤可能会进一步减慢速度（mipmaps 之间的三线性过滤和平均）。阅读纹理在功耗方面也很昂贵，这是手机上的一个大问题。

**如果使用第三方着色器或编写自己的着色器，请尝试使用需要尽可能少的纹理读取的算法。**

##### 纹理压缩

默认情况下，Godot 在导入时使用视频 RAM（VRAM）压缩来压缩 3D 模型的纹理。视频 RAM 压缩在存储时在大小上不如 PNG 或 JPG 高效，但在绘制足够大的纹理时可以极大地提高性能。

这是因为纹理压缩的主要目标是减少内存和 GPU 之间的带宽。

在 3D 中，对象的形状更多地取决于几何体，而不是纹理，因此压缩通常不明显。在 2D 中，压缩更多地取决于纹理内部的形状，因此 2D 压缩产生的伪影更明显。

作为警告，大多数安卓设备不支持透明（仅不透明）纹理的纹理压缩，因此请记住这一点。

> **注意：**
>
> 即使在 3D 中，“像素艺术”纹理也应禁用 VRAM 压缩，因为这会对其外观产生负面影响，而不会因分辨率低而显著提高性能。

##### 后期处理和阴影

就片段着色活动而言，后期处理效果和阴影也可能是昂贵的。始终测试这些对不同硬件的影响。

**减小阴影贴图的大小可以提高写入和读取阴影贴图的性能。**除此之外，提高阴影性能的最佳方法是为尽可能多的灯光和对象关闭阴影。较小或较远的泛光灯/聚光灯通常会禁用其阴影，只会产生较小的视觉影响。

#### 透明度和混合

透明对象在渲染效率方面存在特殊问题。不透明对象（尤其是在 3D 中）基本上可以按任何顺序渲染，Z 缓冲区将确保只有最前面的对象得到着色。透明对象或混合对象不同。在大多数情况下，它们不能依赖于 Z 缓冲区，必须按照“画家的顺序”（即从后到前）进行渲染才能看起来正确。

透明对象对填充率也特别不利，因为即使以后会在顶部绘制其他透明对象，也必须绘制每个项目。

不透明的物体不必这样做。他们通常可以通过仅首先写入 Z 缓冲区，然后仅对“获胜”片段（位于特定像素前面的对象）执行片段着色器来利用 Z 缓冲区。

在多个透明对象重叠的情况下，透明度尤其昂贵。通常最好使用尽可能小的透明区域，以最大限度地降低这些填充率要求，尤其是在填充率非常昂贵的移动设备上。事实上，在许多情况下，渲染更复杂的不透明几何体最终可能比使用透明度“作弊”更快。

#### 多平台建议

如果您的目标是在多个平台上发布，请*尽早*进行测试，并*经常*在所有平台上进行测试，尤其是移动平台。在桌面上开发游戏，但试图在最后一刻将其移植到手机上，这将导致灾难。

一般来说，你应该为最低的公分母设计游戏，然后为更强大的平台添加可选的增强功能。例如，您可能希望同时针对桌面和移动平台使用兼容性渲染方法。

#### 移动/平铺渲染器

如上所述，移动设备上的 GPU 的工作方式与桌面上的 GPU 截然不同。大多数移动设备都使用平铺渲染器。平铺渲染器将屏幕拆分为规则大小的平铺，这些平铺适合超高速缓存，从而减少了对主内存的读/写操作次数。

不过也有一些缺点。平铺渲染会使某些技术变得更加复杂和昂贵。依赖于在不同分幅中渲染的结果或保留早期操作的结果的分幅可能非常缓慢。请非常小心地测试着色器、视口纹理和后期处理的性能。

#### 使用 MultiMeshes 进行优化

对于需要不断处理（并且需要保留一定数量的控制）的大量实例（成千上万），建议直接使用服务器进行优化。

当物体数量达到数十万或数百万时，这些方法都不再有效。尽管如此，根据需求，还有一个可能的优化。

##### MultiMeshes

[MultiMesh](https://docs.godotengine.org/en/stable/classes/class_multimesh.html#class-multimesh) 是一个单一的绘制基本体，可以一次绘制多达数百万个对象。它非常高效，因为它使用 GPU 硬件来实现这一点（不过，在 OpenGL ES 2.0 中，它的效率较低，因为没有硬件支持）。

唯一的缺点是，对于单个实例，没有可能的*屏幕*或*截头体*剔除。这意味着，将*始终*或*从不*绘制数百万个对象，具体取决于整个“多重网格”的可见性。可以为它们提供一个自定义的可见性 rect，但它始终是*全可见性或无可见性*。

如果对象足够简单（只有几个顶点），这通常不是什么大问题，因为大多数现代 GPU 都是针对这种用例进行优化的。一种解决方法是为世界的不同区域创建多个多网格。
也可以在顶点着色器内部执行一些逻辑（使用 `INSTANCE_ID` 或 `INSTANCE_CUSTOM` 内置常量）。有关在“多重网格”中为数千个对象设置动画的示例，请参见为数千条鱼设置动画教程。着色器的信息可以通过纹理提供（有浮点图像格式非常适合）。

另一种选择是使用 GDExtension 和 C++，这应该非常有效（可以通过 RenderingServer.multimesh_set_buffer() 函数使用线性内存设置所有对象的整个状态）。通过这种方式，可以使用多个线程创建阵列，然后在一次调用中设置，从而提供高缓存效率。

最后，不要求所有“多重网格”实例都可见。可见的数量可以使用 MultiMesh.visible_instance_count 属性进行控制。典型的工作流程是分配将要使用的实例的最大数量，然后根据当前需要的数量更改可见的数量。

##### 多网格示例

以下是使用代码中的 MultiMesh 的示例。GDScript 以外的语言可能对数百万个对象更有效，但对几千个对象来说，GDScript 应该没问题。

```python
extends MultiMeshInstance3D


func _ready():
    # Create the multimesh.
    multimesh = MultiMesh.new()
    # Set the format first.
    multimesh.transform_format = MultiMesh.TRANSFORM_3D
    # Then resize (otherwise, changing the format is not allowed).
    multimesh.instance_count = 10000
    # Maybe not all of them should be visible at first.
    multimesh.visible_instance_count = 1000

    # Set the transform of the instances.
    for i in multimesh.visible_instance_count:
        multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3(i * 20, 0, 0)))
```

### 3D

#### 优化3D性能

#### 消隐

Godot 将自动执行视图截头体剔除，以防止渲染视口外的对象。这对于在小范围内进行的游戏来说效果很好，但在更大的级别上，事情可能会很快变得有问题。

##### 遮挡剔除

例如，在一个小镇上漫步，你可能只能看到你所在街道上的几栋建筑，以及天空和头顶上飞过的几只鸟。然而，就天真的渲染器而言，您仍然可以看到整个城镇。它不仅会渲染你面前的建筑，还会渲染你身后的街道，以及那条街上的人，那后面的建筑。您很快就会出现这样的情况：您试图渲染的内容比可见内容多 10 倍或 100 倍。

事情并没有看起来那么糟糕，因为 Z 缓冲区通常只允许 GPU 完全遮挡前面的对象。这被称为深度预处理，在 Godot 中使用 GLES3 渲染器时默认启用。但是，不需要的对象仍在降低性能。

我们可以潜在地减少渲染量的一种方法是利用遮挡。截至 Godot 3.2.2，Godot 中没有内置的遮挡支持。然而，只要精心设计，你仍然可以获得许多优势。

例如，在我们的城市街道场景中，您可以提前计算出从街道 `A` 只能看到另外两条街道，`B` 和 `C`。街道 `D` 到 `Z` 被隐藏。为了利用遮挡，您所要做的就是确定观众何时位于街道 `A`（可能使用 Godot 区域），然后可以隐藏其他街道。

这是所谓的“潜在可见集”的手动版本。这是一种非常强大的加速渲染的技术。你也可以使用它将物理或人工智能限制在局部区域，并加快这些速度以及渲染。

> **注意：**
>
> 在某些情况下，您可能需要调整级别设计以添加更多遮挡机会。例如，您可能需要添加更多的墙，以防止玩家看到太远的地方，这会由于失去遮挡剔除的机会而降低性能。

##### 其他遮挡技术

还有其他遮挡技术，如入口、自动变坡点和基于光栅的遮挡剔除。其中一些可能通过附加组件提供，将来也可能在核心 Godot 中提供。

##### 透明对象

Godot 按“材质”和“着色器”对对象进行排序以提高性能。但是，对于透明对象无法做到这一点。透明对象从后到前进行渲染，以便与后面的内容进行混合。因此，**尽量少使用透明对象**。如果一个对象有一个透明的小部分，请尝试使该部分成为具有自己材质的独立曲面。

有关更多信息，请参阅 GPU 优化文档。

#### 详细等级(LOD)

在某些情况下，特别是在远处，**用更简单的版本替换复杂的几何图形**可能是一个好主意。最终用户可能看不到太大的差异。考虑一下看远处的大量树木。有几种策略可以替换不同距离的模型。可以使用较低的多边形模型，或者使用透明度来模拟更复杂的几何体。

##### 广告牌和冒名顶替者

使用透明度处理 LOD 的最简单版本是公告牌。例如，可以使用单个透明四边形来表示远处的树。这可能非常便宜，当然，除非前面有很多树。在这种情况下，透明度可能开始侵蚀填充率（有关填充率的更多信息，请参阅 GPU 优化）。

另一种选择是不仅渲染一棵树，还将多棵树一起渲染为一个组。如果你能看到一个区域，但在比赛中不能用身体接近它，这会特别有效。

可以通过在不同角度预渲染对象的视图来制作冒名顶替。或者，您甚至可以更进一步，定期将对象的视图重新渲染到用作冒名顶替的纹理上。在一定距离上，需要将查看器移动相当长的距离，才能使视角发生显著变化。这可能很复杂，但根据你正在进行的项目类型，这可能是值得的。

##### 使用实例化（MultiMesh）

如果必须在同一位置或附近绘制多个相同的对象，请尝试使用“多重网格”。“多重网格”允许以极低的性能成本绘制数千个对象，使其非常适合羊群、草、粒子和任何其他具有数千个相同对象的对象。

另请参见“使用多重网格”文档。

#### 烘焙照明

照明对象是成本最高的渲染操作之一。实时照明、阴影（尤其是多个灯光）和 GI 尤其昂贵。对于低功耗的移动设备来说，它们可能太多了。

**考虑使用烘焙照明**，尤其是移动平台。这看起来很神奇，但缺点是它不会是动态的。有时，这是一个值得权衡的问题。

通常，如果需要多个灯光影响场景，最好使用“使用光照贴图”全局照明。烘焙还可以通过添加间接灯光反弹来提高场景质量。

#### 动画和蒙皮

动画和顶点动画（如蒙皮和变形）在某些平台上可能非常昂贵。您可能需要大幅降低动画模型的多边形数，或者在任何时候限制它们在屏幕上的数量。

#### 大世界

如果你正在制作大世界，那么与你可能熟悉的小游戏相比，有不同的考虑因素。

大世界可能需要构建在瓷砖中，当你在世界各地移动时，可以根据需要加载瓷砖。这可以防止内存使用失控，还可以将所需的处理限制在本地。

在大世界中，由于浮点误差，也可能存在渲染和物理故障。您可以使用一些技术，例如围绕玩家定位世界（而不是相反），或者周期性地移动原点，以保持事物以 `Vector3(0, 0, 0)` 为中心。

#### 为数千个对象设置动画

##### 使用 MultiMeshInstance3D 制作数千条鱼的动画

本教程探讨了游戏 ABZU 中使用的一种技术，该技术用于使用顶点动画和静态网格实例化来渲染和设置数千条鱼的动画。

在 Godot 中，这可以通过自定义着色器和 MultiMeshInstance3D 来实现。使用以下技术，即使在低端硬件上，也可以渲染数千个动画对象。

我们将从制作一条鱼的动画开始。然后，我们将看到如何将动画扩展到成千上万的鱼。

###### 设置一条鱼的动画

我们将从一条鱼开始。将鱼模型加载到 MeshInstance3D 中，然后添加新的 ShaderMaterial。

以下是我们将使用的鱼作为示例图像，您可以使用任何您喜欢的鱼模型。

> **注意：**
>
> 本教程中的鱼模型由 QuaterniusDev 制作，并与创造性公共许可证共享。CC0 1.0 通用（CC0 1.0）公共域专用 https://creativecommons.org/publicdomain/zero/1.0/

通常，您会使用骨骼和 Skeleton3D 来设置对象的动画。然而，骨骼是在 CPU 上设置动画的，因此您最终必须在每帧计算数千次操作，并且不可能拥有数千个对象。在顶点着色器中使用顶点动画可以避免使用骨骼，而是可以在几行代码中完全在 GPU 上计算完整的动画。

动画将由四个关键点运动组成：

1. 左右运动
2. 绕鱼中心的枢轴运动
3. 平移波浪运动
4. 平移扭曲运动

动画的所有代码都将在顶点着色器中，统一控制运动量。我们使用统一来控制运动的强度，这样您就可以在编辑器中调整动画并实时查看结果，而无需重新编译着色器。

所有的运动都将使用应用于模型空间中 `VERTEX` 的余弦波进行。我们希望顶点位于模型空间中，以便运动始终相对于鱼的方向。例如，从一侧到另一侧将始终在其从左到右的方向上来回移动鱼，而不是在世界方向的 `x` 轴上。

为了控制动画的速度，我们将从使用 `TIME` 定义自己的时间变量开始。

```glsl
//time_scale is a uniform float
float time = TIME * time_scale;
```

我们将实施的第一项运动是左右运动。它可以通过用时间的 `cos` 来抵消 `VERTEX.x`。每次渲染网格时，所有顶点都会向一侧移动 `cos(time)`。

```glsl
//side_to_side is a uniform float
VERTEX.x += cos(time) * side_to_side;
```

生成的动画应该如下所示：

接下来，我们添加枢轴。因为鱼的中心在（0，0），所以我们所要做的就是将 `VERTEX` 乘以一个旋转矩阵，使其围绕鱼的中心旋转。

我们构造了一个旋转矩阵，如下所示：

```glsl
//angle is scaled by 0.1 so that the fish only pivots and doesn't rotate all the way around
//pivot is a uniform float
float pivot_angle = cos(time) * 0.1 * pivot;
mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
```

然后我们将它乘以 `VERTEX.xz`，将其应用于 `x` 和 `z` 轴。

```glsl
VERTEX.xz = rotation_matrix * VERTEX.xz;
```

仅应用枢轴时，您应该会看到以下内容：

接下来的两个动作需要向下平移鱼的脊椎。为此，我们需要一个新的变量，`body`。`body` 是一个漂浮物，在鱼的尾部是 `0`，在它的头部是 `1`。

```glsl
float body = (VERTEX.z + 1.0) / 2.0; //for a fish centered at (0, 0) with a length of 2
```

下一个动作是沿着鱼的长度向下移动的余弦波。为了使它沿着鱼的脊椎移动，我们通过沿着脊椎的位置来偏移 `cos` 的输入，这是我们在上面定义的变量，`body`。

```glsl
//wave is a uniform float
VERTEX.x += cos(time + body) * wave;
```

这看起来与我们上面定义的左右运动非常相似，但在这一次中，通过使用 `body` 来偏移 `cos` 沿着脊椎的每个顶点在波浪中都有不同的位置，使其看起来像是波浪沿着鱼移动。

最后一个动作是扭曲，它是沿着脊椎的平移滚动。类似于枢轴，我们首先构造一个旋转矩阵。

```glsl
//twist is a uniform float
float twist_angle = cos(time + body) * 0.3 * twist;
mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));
```

我们在 `xy` 轴上应用旋转，使鱼看起来围绕其脊椎滚动。为了实现这一点，鱼的脊椎需要以 `z` 轴为中心。

```glsl
VERTEX.xy = twist_matrix * VERTEX.xy;
```

这是应用了扭曲的鱼：

如果我们一个接一个地应用所有这些运动，我们就会得到一个流体果冻状的运动。

正常的鱼大部分是用它们的后半身游泳。因此，我们需要将平移运动限制在鱼的后半部分。为此，我们创建了一个新的变量 `mask`。

`mask` 是一个浮动，使用 `smoothstep` 控制从 `0` 过渡到 `1` 的点，从鱼前面的 `0` 过渡到最后的 `1`。

```glsl
//mask_black and mask_white are uniforms
float mask = smoothstep(mask_black, mask_white, 1.0 - body);
```

下面是一张鱼的图片，`mask` 被用作 `COLOR`：

对于波浪，我们将运动乘以 `mask`，遮罩将其限制在后半部分。

```glsl
//wave motion with mask
VERTEX.x += cos(time + body) * mask * wave;
```

为了将遮罩应用于扭曲，我们使用 `mix`。`mix` 允许我们在完全旋转的顶点和未旋转的顶点之间混合顶点位置。我们需要使用 `mix`，而不是将 `mask` 乘以旋转后的 `VERTEX`，因为我们不是将运动添加到 `VERTEX` 中，而是将 `VERTEX` 替换为旋转后的版本。如果我们把它乘以 `mask`，我们就会缩小鱼的体积。

```glsl
//twist motion with mask
VERTEX.xy = mix(VERTEX.xy, twist_matrix * VERTEX.xy, mask);
```

把这四个动作放在一起，我们就得到了最后的动画。

继续玩规定参数，以改变鱼的游泳周期。你会发现，使用这四个动作，你可以创造各种各样的游泳风格。

###### 制作鱼群

Godot 使使用 MultiMeshInstance3D 节点渲染数千个相同对象变得容易。

创建和使用 MultiMeshInstance3D 节点的方式与创建 MeshInstance 三维节点的方式相同。在本教程中，我们将把 MultiMeshInstance3D 节点命名为鱼群，因为它将包含鱼群。

一旦有了 MultiMeshInstance3D，就可以添加一个 MultiMesh，并使用上面的着色器向该 MultiMesh 添加网格。

“多重网格”（MultiMeshes）使用三个附加的每实例属性绘制网格：“变换”（旋转、平移、缩放）、“颜色”和“自定义”。Custom 用于使用 Color 传入 4 个多用途变量。

`instance_count` 指定要绘制的网格实例数。目前，请将 `instance_count` 保留为 `0`，因为当 `instance_coount` 大于 `0` 时，您无法更改任何其他参数。我们稍后将在 GDScript 中设置 `instance count`。

`transform_format` 指定使用的变换是 3D 还是 2D。对于本教程，请选择“三维”。

对于 `color_format` 和 `custom_data_format`，可以在 `None`、`Byte` 和 `Float` 之间进行选择。`None` 表示不会将该数据（每个实例的 `COLOR` 变量或 `INSTANCE_CUSTOM`）传递给着色器。`Byte` 表示组成您输入的颜色的每个数字将用 8 位存储，而 `Float` 表示每个数字将存储在一个浮点数（32 位）中。`Float` 更慢但更精确，`Byte` 将占用更少的内存并更快，但您可能会看到一些视觉伪影。

现在，将 `instance_count` 设置为您想要的鱼的数量。

接下来，我们需要设置每个实例的转换。

有两种方法可以设置“多重网格”的逐实例变换。第一个完全在编辑器中，并在 MultiMeshInstance3D 教程中进行了描述。

第二种方法是对所有实例进行循环，并在代码中设置它们的转换。下面，我们使用 GDScript 在所有实例上循环，并将它们的变换设置为随机位置。

```python
for i in range($School.multimesh.instance_count):
  var position = Transform3D()
  position = position.translated(Vector3(randf() * 100 - 50, randf() * 50 - 25, randf() * 50 - 25))
  $School.multimesh.set_instance_transform(i, position)
```

运行此脚本会将鱼放置在 MultiMeshInstance3D 位置周围的框中的随机位置。

> **注意：**
>
> 如果性能对您来说是个问题，请尝试使用较少的鱼来运行场景。

注意到所有的鱼在它们的游泳周期中都处于相同的位置吗？这让他们看起来很机器人。下一步是在游泳周期中给每条鱼一个不同的位置，这样整个鱼群看起来更有机。

###### 设置鱼群的动画

使用 `cos` 函数为鱼设置动画的好处之一是，它们使用一个参数 `time` 设置动画。为了让每条鱼在游泳周期中都有一个独特的位置，我们只需要抵消 `time`。

我们通过将每个实例的自定义值 `INSTANCE_CUSTOM` 添加到 `time` 来实现这一点。

```glsl
float time = (TIME * time_scale) + (6.28318 * INSTANCE_CUSTOM.x);
```

接下来，我们需要将一个值传递到 `INSTANCE_CUSTOM` 中。我们通过从上面向 `for` 循环中添加一行来实现这一点。在 `for` 循环中，我们为每个实例分配一组四个随机浮点值。

```python
$School.multimesh.set_instance_custom_data(i, Color(randf(), randf(), randf(), randf()))
```

现在，这些鱼在游泳周期中都有独特的位置。你可以使用 `INSTANCE_CUSTOM` 让它们游得更快或更慢，乘以 `TIME`，让它们更有个性。

```glsl
//set speed from 50% - 150% of regular speed
float time = (TIME * (0.5 + INSTANCE_CUSTOM.y) * time_scale) + (6.28318 * INSTANCE_CUSTOM.x);
```

您甚至可以尝试以更改每个实例自定义值的方式更改每个实例的颜色。

在这一点上，你会遇到的一个问题是，鱼已经设置了动画，但它们没有移动。可以通过每帧更新每条鱼的逐实例变换来移动它们。尽管这样做比每帧移动数千个 MeshInstance3D 要快，但仍可能很慢。

在下一个教程中，我们将介绍如何使用 GPUParticles3D 来利用 GPU，并在获得实例化好处的同时单独移动每条鱼。

##### 用粒子控制数千条鱼

MeshInstance3D 的问题是更新其变换数组的成本很高。它非常适合在场景周围放置许多静态对象。但是，在场景周围移动对象仍然很困难。

为了使每个实例以一种有趣的方式移动，我们将使用 GPUParticles3D 节点。粒子通过在着色器中计算和设置每实例信息来利用 GPU 加速。

首先创建一个粒子节点。然后，在“绘制过程”下，将粒子的“绘制过程 1”设置为网格。然后在“处理材质”下创建一个新的 ShaderMaterial。

将 `shader_type` 设置为 `particles`。

```glsl
shader_type particles
```

然后添加以下两个功能：

```glsl
float rand_from_seed(in uint seed) {
  int k;
  int s = int(seed);
  if (s == 0)
    s = 305420679;
  k = s / 127773;
  s = 16807 * (s - k * 127773) - 2836 * k;
  if (s < 0)
    s += 2147483647;
  seed = uint(s);
  return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = (x >> uint(16)) ^ x;
  return x;
}
```

这些函数来自默认的 ParticleProcessMaterial。它们用于从每个粒子的 `RANDOM_SEED` 生成一个随机数。

粒子着色器的一个独特之处在于，一些内置变量跨帧保存。`TRANSFORM`、`COLOR` 和 `CUSTOM` 都可以在网格的着色器中访问，下次运行时也可以在粒子着色器中访问。

接下来，设置 `start()` 函数。粒子着色器包含一个 `start()` 函数和一个 `process()` 函数。

`start()` 函数中的代码仅在粒子系统启动时运行。`process()` 函数中的代码将始终运行。

我们需要生成 4 个随机数：3 个用于创建随机位置，1 个用于游泳周期的随机偏移。

首先，使用上面提供的 `hash()` 函数在 `start()` 函数内生成 4 个种子：

```glsl
uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
uint alt_seed2 = hash(NUMBER + uint(27) + RANDOM_SEED);
uint alt_seed3 = hash(NUMBER + uint(43) + RANDOM_SEED);
uint alt_seed4 = hash(NUMBER + uint(111) + RANDOM_SEED);
```

然后，使用这些种子使用 `rand_from_seed` 生成随机数：

```glsl
CUSTOM.x = rand_from_seed(alt_seed1);
vec3 position = vec3(rand_from_seed(alt_seed2) * 2.0 - 1.0,
                     rand_from_seed(alt_seed3) * 2.0 - 1.0,
                     rand_from_seed(alt_seed4) * 2.0 - 1.0);
```

最后，将 `position` 分配给 `TRANSFORM[3].xyz`，它是变换中保存位置信息的部分。

```glsl
TRANSFORM[3].xyz = position * 20.0;
```

请记住，到目前为止，所有这些代码都在 `start()` 函数内部。

网格的顶点着色器可以与上一教程中的完全相同。

现在，您可以通过直接添加到 `TRANSFORM` 或写入 `VELOCITY`，在每帧中单独移动每条鱼。

让我们通过在 `start()` 函数中设置鱼的 `VELOCITY` 来变换它们。

```glsl
VELOCITY.z = 10.0;
```

这是设置 `VELOCITY` 的最基本方法，每个粒子（或鱼）都将具有相同的速度。

只要设置 `VELOCITY`，你就可以让鱼随心所欲地游动。例如，请尝试下面的代码。

```glsl
VELOCITY.z = cos(TIME + CUSTOM.x * 6.28) * 4.0 + 6.0;
```

这将使每条鱼的速度在 `2` 到 `10` 之间。

如果在 `process()` 函数中设置了速度，也可以让每条鱼随时间改变速度。

如果您在上一个教程中使用了 `CUSTOM.y`，您还可以根据 `VELOCITY` 设置游泳动画的速度。只需使用 `CUSTOM.y`。

```glsl
CUSTOM.y = VELOCITY.z * 0.1;
```

此代码提供以下行为：

使用 ParticleProcessMaterial，您可以使鱼的行为变得简单或复杂。在本教程中，我们只设置了“速度”，但在您自己的“着色器”中，您也可以设置 `COLOR`、“旋转”和“缩放”（通过 `TRANSFORM`）。有关粒子着色器的详细信息，请参阅“粒子着色器参考”。

### 线程

#### 使用多个线程

##### 线程

线程允许同时执行代码。它允许从主线程卸载工作。

Godot 支持线程，并提供了许多方便的函数来使用它们。

> **注意：**
>
> 如果使用其他语言（C#、C++），使用它们支持的线程类可能会更容易。

> **警告：**
>
> 在线程中使用内置类之前，请先阅读线程安全 API，以检查它是否可以在线程中安全使用。

##### 创建线程

要创建线程，请使用以下代码：

```python
var thread: Thread

# The thread will start here.
func _ready():
    thread = Thread.new()
    # You can bind multiple arguments to a function Callable.
    thread.start(_thread_function.bind("Wafflecopter"))


# Run here and exit.
# The argument is the bound data passed from start().
func _thread_function(userdata):
    # Print the userdata ("Wafflecopter")
    print("I'm a thread! Userdata is: ", userdata)


# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
    thread.wait_to_finish()
```

然后，您的函数将在一个单独的线程中运行，直到它返回。即使函数已经返回，线程也必须收集它，因此调用 Thread.wait_to_finish()，它将等待线程完成（如果还没有完成），然后正确地处理它。

> **警告：**
>
> 在 Windows 上，在运行时创建线程的速度很慢，应该避免，以防止出现卡顿现象。应该使用本页后面解释的信号量。

##### 互斥

并不总是支持从多个线程访问对象或数据（如果这样做，将导致意外行为或崩溃）。阅读线程安全 API 文档，了解哪些引擎 API 支持多线程访问。

通常，在处理自己的数据或调用自己的函数时，尽量避免直接从不同的线程访问相同的数据。您可能会遇到同步问题，因为修改时数据并不总是在 CPU 内核之间更新。从不同线程访问一段数据时，请始终使用 Mutex。

当调用 Mutex.lock() 时，线程会确保所有其他线程在试图锁定同一个互斥对象时都会被阻塞（处于挂起状态）。当通过调用 Mutex.unlock() 解锁互斥对象时，将允许其他线程继续执行锁定（但一次只能执行一个）。

以下是使用 Mutex 的示例：

```python
var counter := 0
var mutex: Mutex
var thread: Thread


# The thread will start here.
func _ready():
    mutex = Mutex.new()
    thread = Thread.new()
    thread.start(_thread_function)

    # Increase value, protect it with Mutex.
    mutex.lock()
    counter += 1
    mutex.unlock()


# Increment the value from the thread, too.
func _thread_function():
    mutex.lock()
    counter += 1
    mutex.unlock()


# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
    thread.wait_to_finish()
    print("Counter is: ", counter) # Should be 2.
```

##### 信号量

有时你希望你的线程“*按需*”工作。换句话说，告诉它什么时候工作，让它在什么都不做的时候暂停。为此，使用了信号量。函数 Semaphore.wait() 在线程中用于挂起它，直到一些数据到达。

相反，主线程使用 Semaphore.post() 来表示数据已准备好进行处理：

```python
var counter := 0
var mutex: Mutex
var semaphore: Semaphore
var thread: Thread
var exit_thread := false


# The thread will start here.
func _ready():
    mutex = Mutex.new()
    semaphore = Semaphore.new()
    exit_thread = false

    thread = Thread.new()
    thread.start(_thread_function)


func _thread_function():
    while true:
        semaphore.wait() # Wait until posted.

        mutex.lock()
        var should_exit = exit_thread # Protect with Mutex.
        mutex.unlock()

        if should_exit:
            break

        mutex.lock()
        counter += 1 # Increment counter, protect with Mutex.
        mutex.unlock()


func increment_counter():
    semaphore.post() # Make the thread process.


func get_counter():
    mutex.lock()
    # Copy counter, protect with Mutex.
    var counter_value = counter
    mutex.unlock()
    return counter_value


# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
    # Set exit condition to true.
    mutex.lock()
    exit_thread = true # Protect with Mutex.
    mutex.unlock()

    # Unblock by posting.
    semaphore.post()

    # Wait until it exits.
    thread.wait_to_finish()

    # Print the counter.
    print("Counter is: ", counter)
```

#### 线程安全 API

##### 线程

线程用于平衡 CPU 和内核之间的处理能力。Godot 支持多线程，但不支持整个引擎。
下面列出了在 Godot 的不同领域中使用多线程的方法。

##### 全局作用域

全局作用域 singleton 都是线程安全的。支持从线程访问服务器（对于 RenderingServer 和 Physics 服务器，请确保在项目设置中启用线程或线程安全操作！）。

这使得它们非常适合在服务器中创建成千上万个实例并从线程控制它们的代码。当然，它需要更多的代码，因为这是直接使用的，而不是在场景树中。

##### 场景树

与活动场景树交互**不是**线程安全的。确保在线程之间发送数据时使用互斥。如果要从线程调用函数，可以使用 *call_deferred* 函数：

```python
# Unsafe:
node.add_child(child_node)
# Safe:
node.call_deferred("add_child", child_node)
```

但是，在活动树之外创建场景块（按树排列的节点）是可以的。这样，场景的部分可以在线程中构建或实例化，然后添加到主线程中：

```python
var enemy_scene = load("res://enemy_scene.scn")
var enemy = enemy_scene.instantiate()
enemy.add_child(weapon) # Set a weapon.
world.call_deferred("add_child", enemy)
```

不过，只有当您有**一个**线程加载数据时，这才真正有用。尝试从多个线程加载或创建场景块可能会奏效，但您可能会面临资源（在 Godot 中只加载一次）被多个线程调整的风险，从而导致意外行为或崩溃。

如果您真的知道自己在做什么，并且确信单个资源没有被使用或设置在多个资源中，则仅使用多个线程来生成场景数据。否则，只需直接使用服务器 API（完全线程安全），而不接触场景或资源，就更安全了。

##### 渲染

默认情况下，在 2D 或 3D 中渲染任何内容（如“精灵”）的实例化节点都不是线程安全的。若要确保渲染线程安全，请将“**渲染 > 线程 > 线程模型**”项目设置设置为“**多线程**”。

请注意，多线程线程模型有几个已知的错误，因此它可能不适用于所有场景。

##### GDScript 数组，字典

在 GDScript 中，从多个线程读取和写入元素是可以的，但任何改变容器大小（调整大小、添加或删除元素）的操作都需要锁定互斥对象。

##### 资源

不支持修改来自多个线程的唯一资源。然而，支持在多个线程上处理引用，因此也可以在线程上加载资源——场景、纹理、网格等——可以在线程中加载和操作，然后添加到主线程上的活动场景中。这里的限制如上所述，必须注意不要同时从多个线程加载同一资源，因此最容易使用**一个**线程加载和修改资源，然后使用主线程添加资源。

## 物理

### 物理简介

在游戏开发中，您通常需要知道游戏中的两个对象何时相交或接触。这就是所谓的**碰撞检测**。当检测到碰撞时，通常希望发生一些事情。这就是所谓的**碰撞响应**。

Godot 提供了许多 2D 和 3D 碰撞对象，以提供碰撞检测和响应。试图决定在你的项目中使用哪一个可能会让人困惑。如果您了解每种方法的工作原理以及它们的优缺点，就可以避免问题并简化开发。

在本指南中，您将学习：

- Godot 的四种碰撞对象类型
- 每个碰撞对象的工作方式
- 何时以及为什么选择一种类型而不是另一种类型

> **注意：**
>
> 本文档的示例将使用二维对象。每个二维物理物体和碰撞形状在三维中都有直接的等价物，在大多数情况下，它们的工作方式基本相同。

#### 碰撞对象

Godot 提供了四种碰撞对象，它们都扩展了 CollisionObject2D。下面列出的最后三个是物理体，并额外扩展了 PhysicsBody2D。

- **[Area2D](https://docs.godotengine.org/en/stable/classes/class_area2d.html#class-area2d)**

  `Area2D` 节点提供**检测**和**影响**。它们可以检测物体何时重叠，并可以在物体进出时发出信号。`Area2D` 也可以用于覆盖定义区域中的物理特性，如重力或阻尼。

- **[StaticBody2D](https://docs.godotengine.org/en/stable/classes/class_staticbody2d.html#class-staticbody2d)**

  静止物体是指不被物理引擎移动的物体。它参与碰撞检测，但不响应碰撞而移动。它们最常用于作为环境一部分或不需要任何动态行为的对象。

- **[RigidBody2D](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d)**

  这是实现模拟二维物理的节点。您不直接控制 `RigidBody2D`，而是对其施加力（重力、脉冲等），物理引擎计算产生的运动。阅读有关使用刚体的详细信息。

- **[CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html#class-characterbody2d)**

  一种提供碰撞检测但没有物理功能的物体。所有移动和碰撞响应都必须在代码中实现。

##### 物理材料

可以将静态实体和刚体配置为使用 PhysicsMaterial。这允许调整物体的摩擦和弹跳，并设置其是否具有吸收性和/或粗糙度。

##### 碰撞形状

一个物理体可以容纳任意数量的 Shape2D 对象作为子对象。这些形状用于定义对象的碰撞边界并检测与其他对象的接触。

> **注意：**
>
> 为了检测碰撞，必须至少为对象指定一个 `Shape2D`。

指定形状的最常见方法是添加 CollisionShape2D 或 CollisionPolygon2D 作为对象的子对象。这些节点允许您直接在编辑器工作空间中绘制形状。

> **重要：**
>
> 请注意不要在编辑器中缩放碰撞形状。Inspector 中的 “Scale” 属性应保持为 `(1, 1)`。更改碰撞形状的大小时，应始终使用大小控制柄，而**不是** `Node2D` 比例控制柄。缩放形状可能会导致意外的碰撞行为。

##### 物理过程回调

物理引擎以固定的速率运行（默认为每秒 60 次迭代）。该速率通常不同于帧速率，帧速率基于所呈现的内容和可用资源而波动。

重要的是，所有与物理相关的代码都以这种固定的速率运行。因此 Godot 区分了物理和空闲处理。运行每一帧的代码被称为空闲处理，在每个物理刻度上运行的代码被称作物理处理。Godot 提供了两个不同的回调，每个回调对应一个处理速率。

物理回调，Node._physics_process()，在每个物理步骤之前调用。任何需要访问实体属性的代码都应该在这里运行。此方法将传递一个 `delta` 参数，该参数是一个浮点数，等于自上一步以来经过的时间（以秒为单位）。当使用默认的 60 赫兹物理更新率时，它通常等于 `0.01666…`（但并不总是如此，请参阅下文）。

> **注意：**
>
> 建议在物理计算中始终使用 `delta` 参数，这样，如果您更改物理更新率或玩家的设备无法跟上，游戏就会正常运行。

##### 碰撞层和遮罩

碰撞层系统是最强大但经常被误解的碰撞功能之一。该系统允许您在各种对象之间建立复杂的交互。关键概念是**图层**和**遮罩**。每个 `CollisionObject2D` 都有 32 个不同的物理层，可以与之交互。

让我们依次查看每个属性：

- **collision_layer**

  这描述了对象显示**在**的图层。默认情况下，所有实体都在图层 `1` 上。

- **collision_mask**

  这描述了实体将**扫描**哪些层以进行碰撞。如果某个对象不在某个遮罩层中，则实体将忽略它。默认情况下，所有实体都扫描第 `1` 层。

这些属性可以通过代码进行配置，也可以在检查器中进行编辑。

跟踪你使用每一层的目的可能很困难，所以你可能会发现为你使用的层指定名称很有用。可以在“项目设置”->“图层名称”中指定名称。

###### GUI 示例

游戏中有四种节点类型：墙、玩家、敌人和硬币。玩家和敌人都应该与墙壁碰撞。玩家节点应该检测到敌人和硬币的碰撞，但敌人和硬币应该忽略对方。

首先将 1-4 层命名为“墙”、“玩家”、“敌人”和“硬币”，并使用“层”属性将每个节点类型放置在各自的层中。然后，通过选择应与其交互的层来设置每个节点的“遮罩”属性。例如，玩家的设置如下所示：

###### 代码示例

在函数调用中，层被指定为位掩码。如果函数默认启用所有层，则层掩码将显示为 `0xffffffff`。您的代码可以使用二进制、十六进制或十进制表示法作为图层遮罩，具体取决于您的偏好。

启用了层 1、3 和 4 的上述示例的等效代码如下：

```python
# Example: Setting mask value for enabling layers 1, 3 and 4

# Binary - set the bit corresponding to the layers you want to enable (1, 3, and 4) to 1, set all other bits to 0.
# Note: Layer 32 is the first bit, layer 1 is the last. The mask for layers 4,3 and 1 is therefore
0b10000000_00000000_00000000_00001101
# (This can be shortened to 0b1101)

# Hexadecimal equivalent (1101 binary converted to hexadecimal)
0x000d
# (This value can be shortened to 0xd)

# Decimal - Add the results of 2 to the power of (layer to be enabled - 1).
# (2^(1-1)) + (2^(3-1)) + (2^(4-1)) = 1 + 4 + 8 = 13
pow(2, 1-1) + pow(2, 3-1) + pow(2, 4-1)
```

#### Area2D

区域节点提供**检测**和**影响**。它们可以检测物体何时重叠，并在物体进出时发出信号。区域也可以用于覆盖定义区域中的物理特性，例如重力或阻尼。

Area2D 有三个主要用途：

- 覆盖给定区域中的物理参数（如重力）。
- 检测其他实体何时进入或离开某个区域，或者某个区域中当前有哪些实体。
- 检查其他区域是否重叠。

默认情况下，区域还接收鼠标和触摸屏输入。

#### StaticBody2D

静止物体是指不被物理引擎移动的物体。它参与碰撞检测，但不响应碰撞而移动。但是，它可以使用其 `constant_linear_velocity` 和 `constant_angular_velocity` 属性，将运动或旋转传递给碰撞物体，**就好像**它在移动一样。

`StaticBody2D` 节点最常用于作为环境一部分或不需要任何动态行为的对象。

`StaticBody2D` 的示例用法：

- 平台（包括移动平台）
- 输送带
- 墙壁和其他障碍物

#### RigidBody2D

这是实现模拟二维物理的节点。您不能直接控制 RigidBody2D。相反，您会对其施加力，物理引擎会计算产生的运动，包括与其他物体的碰撞，以及碰撞响应，如反弹、旋转等。

可以通过“质量”、“摩擦力”或“反弹”等特性修改刚体的行为，这些特性可以在检查器中设置。

实体的行为也会受到世界属性的影响，如在 *“项目设置”->“物理”* 中设置的，或者输入覆盖全局物理属性的区域 2D。

当一个刚体处于静止状态，并且有一段时间没有移动时，它就会进入睡眠状态。睡眠的实体就像静止的实体，它的力不是由物理引擎计算的。当通过碰撞或代码施加力时，实体会苏醒。

##### 使用 RigidBody2D

使用刚体的好处之一是，许多行为可以“免费”进行，而无需编写任何代码。例如，如果你正在制作一个带有掉落积木的“愤怒的小鸟”风格的游戏，你只需要创建 RigidBody2D 并调整它们的属性。堆叠、下落和弹跳将由物理引擎自动计算。

但是，如果您确实希望对刚体有一些控制，则应该小心——更改刚体的 `position`、`linear_velocity` 或其他物理特性可能会导致意外行为。如果需要更改任何与物理相关的属性，则应使用 _integrate_forces() 回调，而不是 `_physics_process()`。在这个回调中，您可以访问实体的 PhysicsDirectBodyState2D，它允许安全地更改属性并将它们与物理引擎同步。

例如，以下是“小行星”式宇宙飞船的代码：

```python
extends RigidBody2D

var thrust = Vector2(0, -250)
var torque = 20000

func _integrate_forces(state):
    if Input.is_action_pressed("ui_up"):
        state.apply_force(thrust.rotated(rotation))
    else:
        state.apply_force(Vector2())
    var rotation_direction = 0
    if Input.is_action_pressed("ui_right"):
        rotation_direction += 1
    if Input.is_action_pressed("ui_left"):
        rotation_direction -= 1
    state.apply_torque(rotation_direction * torque)
```

请注意，我们不是直接设置 `linear_velocity` 或 `angular_vocity` 属性，而是向物体施加力（`thrust` 和 `torque`），并让物理引擎计算由此产生的运动。

> **注意：**
>
> 当刚体进入睡眠状态时，将不会调用 `_integrate_forces()` 函数。若要覆盖此行为，您需要通过创建碰撞、对其施加力或禁用 can_sleep 属性来保持身体清醒。请注意，这可能会对性能产生负面影响。

##### 碰撞报告

默认情况下，刚体不会跟踪接触，因为如果场景中有许多实体，这可能需要大量内存。若要启用联系人报告，请将 max_contacts_reported 属性设置为非零值。然后可以通过 PhysicsDirectBodyState2D.get_contact_count() 和相关函数获取联系人。

可以通过 contact_monitor 属性启用通过信号进行的接触监测。有关可用信号的列表，请参见 RigidBody2D。

#### CharacterBody2D

CharacterBody2D 实体检测与其他实体的碰撞，但不受重力或摩擦等物理特性的影响。相反，它们必须由用户通过代码进行控制。物理引擎不会移动角色的身体。

移动角色身体时，不应直接设置其 `position`。相反，您可以使用 `move_and_collide()` 或 `move_and_slide()` 方法。这些方法沿着给定的向量移动物体，如果检测到与另一个物体发生碰撞，它将立即停止。车身碰撞后，任何碰撞响应都必须手动编码。

##### 角色冲突响应

碰撞后，您可能希望实体反弹、沿墙滑动或更改碰撞对象的属性。处理碰撞响应的方式取决于用于移动 CharacterBody2D 的方法。

###### [move_and_collide](https://docs.godotengine.org/en/stable/classes/class_physicsbody2d.html#class-physicsbody2d-method-move-and-collide)

当使用 `move_and_closure()` 时，函数返回一个 KinematicCollision2D 对象，该对象包含有关碰撞和碰撞体的信息。您可以使用这些信息来确定响应。

例如，如果要查找空间中发生碰撞的点：

```python
extends PhysicsBody2D

var velocity = Vector2(250, 250)

func _physics_process(delta):
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        var collision_point = collision_info.get_position()
```

或者从碰撞的对象上反弹：

```python
extends PhysicsBody2D

var velocity = Vector2(250, 250)

func _physics_process(delta):
    var collision_info = move_and_collide(velocity * delta)
    if collision_info:
        velocity = velocity.bounce(collision_info.get_normal())
```

###### [move_and_slide](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html#class-characterbody2d-method-move-and-slide)

滑动是一种常见的碰撞反应；想象一个玩家在自上而下的游戏中沿着墙壁移动，或者在平台游戏中在斜坡上跑上跑下。虽然可以在使用 `move_and_collide()` 后自己编写此响应，但 `move_and_slide()` 提供了一种方便的方法来实现滑动，而无需编写太多代码。

> **警告：**
>
> `move_and_slide()` 在计算中自动包含时间步长，因此不应将速度矢量乘以 `delta`。

例如，使用以下代码创建一个可以沿地面（包括斜坡）行走并在站在地面上时跳跃的角色：

```python
extends CharacterBody2D

var run_speed = 350
var jump_speed = -1000
var gravity = 2500

func get_input():
    velocity.x = 0
    var right = Input.is_action_pressed('ui_right')
    var left = Input.is_action_pressed('ui_left')
    var jump = Input.is_action_just_pressed('ui_select')

    if is_on_floor() and jump:
        velocity.y = jump_speed
    if right:
        velocity.x += run_speed
    if left:
        velocity.x -= run_speed

func _physics_process(delta):
    velocity.y += gravity * delta
    get_input()
    move_and_slide()
```

有关使用 `move_and_slide()` 的更多详细信息，请参见运动学角色（2D），包括带有详细代码的演示项目。

### 使用 RigidBody

#### 什么是刚体？

刚体是由物理引擎直接控制以模拟物理对象行为的刚体。为了定义实体的形状，必须为其指定一个或多个 Shape3D 对象。请注意，设置这些形状的位置会影响身体的质心。

#### 如何控制刚体

刚体的行为可以通过设置其特性（例如质量和重量）来更改。需要在刚体中添加物理材料，以调整其摩擦力和弹跳力，并确定其是否具有吸收性和/或粗糙度。这些属性可以在检查器中设置，也可以通过代码设置。有关特性及其效果的完整列表，请参见 RigidBody3D 和 PhysicsMaterial。

有几种方法可以控制刚体的运动，具体取决于所需的应用程序。

如果只需要放置刚体一次，例如设置其初始位置，则可以使用 Node3D 节点提供的方法，如 `set_global_transform()` 或 `look_at()`。然而，这些方法不能在每帧中调用，否则物理引擎将无法正确模拟身体的状态。例如，考虑要旋转的刚体，使其指向另一个对象。实现这种行为时的一个常见错误是在每帧使用 `look_at()`，这会破坏物理模拟。下面，我们将演示如何正确实现这一点。

不能使用 `set_global_transform()` 或 `look_at()` 方法并不意味着不能完全控制刚体。相反，您可以使用 `_integrate_forces()` 回调来控制它。在这种方法中，您可以添加力、施加脉冲或设置速度，以实现您想要的任何运动。

#### “look at” 方法

如上所述，使用 Node3D 的 `look_at()` 方法不能在每一帧都使用以跟随目标。这里有一个自定义的 `look_at()` 方法，它将可靠地处理刚体：

```python
extends RigidBody3D

func look_follow(state, current_transform, target_position):
    var up_dir = Vector3(0, 1, 0)
    var cur_dir = current_transform.basis * Vector3(0, 0, 1)
    var target_dir = (target_position - current_transform.origin).normalized()
    var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)

    state.angular_velocity = up_dir * (rotation_angle / state.step)

func _integrate_forces(state):
    var target_position = $my_target_node3d_node.global_transform.origin
    look_follow(state, global_transform, target_position)
```

此方法使用刚体的 `angular_velocity` 属性来旋转刚体。它首先计算当前角度和所需角度之间的差，然后添加在一帧时间内旋转该量所需的速度。

> **注意：**
>
> 此脚本将无法在角色模式下处理刚体，因为这样，刚体的旋转将被锁定。在这种情况下，必须使用标准 Node3D 方法旋转附着的网格节点。

### 使用 Area2D

#### 简介

Godot 提供了许多碰撞对象来提供碰撞检测和响应。试图决定在你的项目中使用哪一个可能会让人困惑。如果您了解每个问题的工作原理以及它们的优缺点，您就可以避免问题并简化开发。在本教程中，我们将研究 Area2D 节点，并展示一些如何使用它的示例。

> **注意：**
>
> 本文档假设您熟悉 Godot 的各种物理体。请先阅读物理学导论。

#### 什么是区域？

区域 2D 定义了 2D 空间的一个区域。在此空间中，可以检测到其他 CollisionObject2D 节点重叠、进入和退出。区域还允许覆盖局部物理特性。我们将在下面探讨这些函数中的每一个。

#### 区域特性

区域有许多特性，可以用来自定义其行为。

前八个特性用于配置区域的物理覆盖行为。我们将在下面的部分中研究如何使用这些功能。

*监控*和*可监控*用于启用和禁用该区域。

“碰撞”部分用于配置区域的碰撞层和遮罩。

“音频总线”部分允许您覆盖该区域中的音频，例如在播放器移动时应用音频效果。

请注意，Area2D 扩展了 CollisionObject2D，因此它还提供了从该类继承的属性，例如 `input_pickable`。

#### 重叠检测

也许 Area2D 节点最常见的用途是用于接触和重叠检测。当你需要知道两个物体已经接触，但不需要物理碰撞时，你可以使用一个区域来通知你接触的情况。

例如，假设我们正在制作一枚硬币供玩家拾取。硬币不是一个固体物体——玩家不能站在上面或推它——我们只希望它在玩家触摸它时消失。

以下是硬币的节点设置：

为了检测重叠，我们将在 Area2D 上连接适当的信号。使用哪个信号取决于玩家的节点类型。如果玩家在另一个区域，请使用 `area_entered`。然而，让我们假设我们的玩家是 `CharacterBody2D`（因此是 `CollisionObject2D` 类型），因此我们将连接 `body_entered` 信号。

> **注意：**
>
> 如果您不熟悉使用信号，请参阅使用信号进行介绍。

```python
extends Area2D

func _on_coin_body_entered(body):
    queue_free()
```

现在我们的玩家可以收集硬币了！

其他一些用法示例：

- 区域非常适合子弹和其他投射物撞击并造成伤害，但不需要任何其他物理特性，如弹跳。
- 在敌人周围使用一个大的圆形区域来定义其“探测”半径。当玩家在区域外时，敌人看不到它。
- “安全摄像头”-在一个有多个摄像头的大关卡中，将区域连接到每个摄像头上，并在玩家进入时激活它们。

有关在游戏中使用 Area2D 的示例，请参阅您的第一个 2D 游戏。

#### 区域影响

区域节点的第二个主要用途是改变物理特性。默认情况下，该区域不会执行此操作，但可以使用“空间覆盖”特性启用此操作。当区域重叠时，将按优先级顺序进行处理（优先级较高的区域将首先进行处理）。有四种替代选项：

- *合并*-面积将其值添加到迄今为止计算的值中。
- *替换*-该区域将替换物理属性，而优先级较低的区域将被忽略。
- *合并替换*-该区域将其重力/阻尼值添加到迄今为止计算的值中（按优先级顺序），忽略任何优先级较低的区域。
- *替换合并*-该区域替换迄今为止计算的任何重力/阻尼，但保持计算其余区域。

使用这些属性，可以创建具有多个重叠区域的非常复杂的行为。

可以覆盖的物理属性包括：

- *重力*-重力在区域内的强度。
- *重力向量*-重力的方向。该向量不需要进行归一化。
- *线性阻尼*-物体停止移动的速度-每秒损失的线性速度。
- *角阻尼*-物体停止旋转的速度-每秒损失的角速度。

##### 点重力

“*重力点*”属性允许您创建一个“吸引器”。该区域中的重力将朝着*重力向量*特性给定的点计算。值是相对于 Area2D 的，因此例如使用 `(0, 0)` 会将对象吸引到区域的中心。

##### 示例

下面所附的示例项目有三个区域演示物理覆盖。

您可以在此处下载此项目：area_2d_starter.zip

### 使用 CharacterBody2D/3D

#### 简介

Godot 提供了几个碰撞对象来提供碰撞检测和响应。试图决定在你的项目中使用哪一个可能会让人困惑。如果您了解每个问题的工作原理以及它们的优缺点，您就可以避免问题并简化开发。在本教程中，我们将查看 CharacterBody2D 节点，并展示如何使用它的一些示例。

> **注意：**
>
> 虽然本文档在其示例中使用 `CharacterBody2D`，但相同的概念也适用于 3D。

#### 什么是角色身体？

`CharacterBody2D` 用于实现通过代码控制的实体。角色身体在移动时检测与其他身体的碰撞，但不受引擎物理特性（如重力或摩擦）的影响。虽然这意味着你必须编写一些代码来创建它们的行为，但这也意味着你可以更精确地控制它们的移动和反应。

> **注意：**
>
> 本文档假设您熟悉 Godot 的各种物理体。请先阅读物理学导论，了解物理学选项的概述。

> **提示：**
>
> *CharacterBody2D* 可能会受到重力和其他力的影响，但必须在代码中计算移动。物理引擎不会移动 *CharacterBody2D*。

#### 运动与碰撞

移动 `CharacterBody2D` 时，不应直接设置其 `position` 特性。相反，您可以使用 `move_and_collide()` 或 `move_and_slide()` 方法。这些方法沿着给定的向量移动物体并检测碰撞。

> **警告：**
>
> 您应该在 `_physics_process()` 回调中处理物理身体运动。

这两种移动方法有不同的用途，在本教程的后面，您将看到它们如何工作的示例。
移动

##### move_and_collide

此方法需要一个必需的参数：Vector2，用于指示身体的相对运动。通常，这是速度向量乘以帧时间步长（`delta`）。如果发动机检测到沿该矢量的任何位置发生碰撞，则车身将立即停止移动。如果发生这种情况，该方法将返回一个 KinematicCollision2D 对象。

`KinematicCollision2D` 是一个包含碰撞和碰撞对象数据的对象。使用这些数据，可以计算碰撞响应。

当您只想移动身体并检测碰撞，但不需要任何自动碰撞响应时，`move_and_collide` 最有用。例如，如果你需要一颗从墙上弹开的子弹，你可以在检测到碰撞时直接改变速度的角度。请参阅下面的示例。

##### move_and_slide

`move_and_slide()` 方法旨在简化在希望一个物体沿着另一个物体滑动的常见情况下的碰撞响应。例如，它在平台游戏或自上而下的游戏中尤其有用。

当调用 `move_and_slide()` 时，函数使用许多节点属性来计算其滑动行为。这些属性可以在检查器中找到，也可以在代码中设置。

- `velocity` - 默认值：`Vector2(0, 0)`
  此属性以每秒像素为单位表示身体的速度矢量。`move_and_slide()` 将在碰撞时自动修改此值。
- `motion_mode` - 默认值：`MOTION_MODE_GROUNDED`
  此属性通常用于区分侧滚动和自上而下的移动。使用默认值时，可以使用 `is_on_floor()`、`is_on_wall()` 和 `is_on_ceiling()` 方法来检测物体与哪种类型的表面接触，以及物体将与斜坡相互作用。使用 `MOTION_MODE_FLOATING` 时，所有碰撞都将被视为“墙”。
- `up_direction` - 默认值：`Vector2(0, -1)`
  此属性允许您定义引擎应将哪些曲面视为地板。它的值允许您使用 `is_on_floor()`、`is_on_wall()` 和 `is_on_ceiling()` 方法来检测身体接触的表面类型。默认值表示水平曲面的顶面将被视为“地面”。
- `floor_stop_on_slope` - 默认值：`true`
  此参数可防止身体在静止时从斜坡上滑下。
- `wall_min_slide_angle` - 默认值：`0.261799`（弧度，相当于 `15` 度）
  这是当物体碰到斜坡时允许其滑动的最小角度。
- `floor_max_angle` - 默认值：`0.785398`（以弧度为单位，相当于 `45` 度）
  此参数是曲面不再被视为“地板”之前的最大角度

在特定情况下，还有许多其他特性可用于修改身体的行为。有关完整详细信息，请参阅CharacterBody2D文档。

#### 检测碰撞

当使用 `move_and_conflict()` 时，函数会直接返回一个 `KinematicCollision2D`，您可以在代码中使用它。

当使用 `move_and_slide()` 时，可能会发生多次碰撞，因为滑动响应是计算出来的。要处理这些冲突，请使用 `get_slide_collision_count()` 和 `get_slide_collision()`：

```python
# Using move_and_collide.
var collision = move_and_collide(velocity * delta)
if collision:
    print("I collided with ", collision.get_collider().name)

# Using move_and_slide.
move_and_slide()
for i in get_slide_collision_count():
    var collision = get_slide_collision(i)
    print("I collided with ", collision.get_collider().name)
```

> **注意：**
>
> *get_slide_collision_count()* 只计算物体碰撞和改变方向的次数。

有关返回碰撞数据的详细信息，请参见 KinematicCollision2D。

#### 使用哪种运动方法？

Godot 新用户的一个常见问题是：“你如何决定使用哪个移动函数？”通常，答案是使用 `move_and_slide()`，因为它看起来更简单，但事实并非如此。一种方法是，`move_and_slide()` 是一种特殊情况，而 `move_and_collide()` 更为一般。例如，以下两个代码片段会导致相同的冲突响应：

```python
# using move_and_collide
var collision = move_and_collide(velocity * delta)
if collision:
    velocity = velocity.slide(collision.get_normal())

# using move_and_slide
move_and_slide()
```

你用 `move_and_slide()` 做的任何事情也可以用 `move_and_collide()` 做，但它可能需要更多的代码。但是，正如我们将在下面的示例中看到的，在某些情况下 `move_and_slide()` 不能提供您想要的响应。

在上面的示例中，`move_and_slide()` 会自动更改 `velocity` 变量。这是因为当角色与环境碰撞时，函数会在内部重新计算速度，以反映减速情况。

例如，如果你的角色摔倒在地板上，你不希望它由于重力的影响而积累垂直速度。相反，您希望其垂直速度重置为零。

`move_and_slide()` 也可以在循环中多次重新计算运动学物体的速度，因为为了产生平滑的运动，它会移动角色，默认情况下最多碰撞五次。在该过程结束时，角色的新速度可用于下一帧。

#### 示例

要查看这些示例，请下载示例项目：character_body_2d_starter.zip

##### 运动和墙壁

如果您已经下载了示例项目，则此示例位于“basic_movement.tscn”中。

对于本例，添加一个具有两个子项的 `CharacterBody2D`：`Sprite2D` 和 `CollisionShape2D`。使用 Godot “icon.svg” 作为 `Sprite2D` 的纹理（将其从 Filesystem dock 拖动到 `Sprite2D` 中的 *Texture* 属性）。在 `CollisionShape2D` 的 *Shape* 属性中，选择 “New RectangleShape2D” 并调整矩形大小以适合精灵图像。

> **注意：**
>
> 有关实现二维移动方案的示例，请参见二维移动概述。

将脚本附加到 CharacterBody2D 并添加以下代码：

```python
extends CharacterBody2D

var speed = 300

func get_input():
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = input_dir * speed

func _physics_process(delta):
    get_input()
    move_and_collide(velocity * delta)
```

运行此场景，您将看到 `move_and_collide()` 按预期工作，沿着速度向量移动身体。现在，让我们看看当您添加一些障碍时会发生什么。添加具有矩形碰撞形状的 StaticBody2D。对于可见性，可以使用 Sprite2D、Polygon2D，或从“调试”菜单中启用“可见碰撞形状”。

再次运行场景并尝试移动到障碍物中。您将看到 `CharacterBody2D` 无法穿透障碍物。然而，试着以一定角度进入障碍物，你会发现障碍物就像胶水一样——感觉身体被卡住了。

发生这种情况是因为没有碰撞响应。当发生碰撞时，`move_and_collide()` 会停止身体的运动。我们需要对碰撞的任何响应进行编码。

尝试将函数更改为 `move_and_slide()`，然后再次运行。

`move_and_slide()` 提供了沿着碰撞对象滑动身体的默认碰撞响应。这对许多游戏类型都很有用，并且可能是获得所需行为所需的全部内容。

##### 弹跳/反射

如果你不想要滑动碰撞响应怎么办？对于这个例子（示例项目中的 “bounce_and_closure.tscn”），我们有一个角色在发射子弹，我们希望子弹从墙上弹开。
本例使用了三个场景。主场景包含播放器和墙。项目符号和墙是单独的场景，因此可以对它们进行实例化。
播放机由向前和向后的w和s键控制。瞄准使用鼠标指针。以下是播放器的代码，使用 `move_and_slide()`：

```python
extends CharacterBody2D

var Bullet = preload("res://bullet.tscn")
var speed = 200

func get_input():
    # Add these actions in Project Settings -> Input Map.
    var input_dir = Input.get_axis("backward", "forward")
    velocity = transform.x * input_dir * speed
    if Input.is_action_just_pressed("shoot"):
        shoot()

func shoot():
    # "Muzzle" is a Marker2D placed at the barrel of the gun.
    var b = Bullet.instantiate()
    b.start($Muzzle.global_position, rotation)
    get_tree().root.add_child(b)

func _physics_process(delta):
    get_input()
    var dir = get_global_mouse_position() - global_position
    # Don't move if too close to the mouse pointer.
    if dir.length() > 5:
        rotation = dir.angle()
        move_and_slide()
```

Bullet 的代码：

```python
extends CharacterBody2D

var speed = 750

func start(_position, _direction):
    rotation = _direction
    position = _position
    velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
    var collision = move_and_collide(velocity * delta)
    if collision:
        velocity = velocity.bounce(collision.get_normal())
        if collision.get_collider().has_method("hit"):
            collision.get_collider().hit()

func _on_VisibilityNotifier2D_screen_exited():
    # Deletes the bullet when it exits the screen.
    queue_free()
```

该操作发生在 `_physics_process()` 中。在使用 `move_and_collide()` 之后，如果发生碰撞，则返回 `KinematicCollision2D` 对象（否则，返回为 `null`）。

如果有返回的碰撞，我们使用 `Vector2.bounce()` 方法使用碰撞的 `normal` 来反映子弹的 `velocity`。

如果碰撞对象（`collider`）有一个 `hit` 方法，我们也会调用它。在示例项目中，我们为Wall添加了一个闪烁的颜色效果来演示这一点。

##### 平台游戏运动

让我们尝试一个更流行的例子：2D 平台游戏。`move_and_slide()` 是快速启动和运行功能性角色控制器的理想选择。如果您已经下载了示例项目，您可以在 “platformer.tscn” 中找到它。

对于本例，我们假设您有一个由一个或多个 `StaticBody2D` 对象组成的级别。它们可以是任何形状和大小。在示例项目中，我们使用 Polygon2D 创建平台形状。

以下是玩家实体的代码：

```python
extends CharacterBody2D

var speed = 300.0
var jump_speed = -400.0

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
    # Add the gravity.
    velocity.y += gravity * delta

    # Handle Jump.
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_speed

    # Get the input direction.
    var direction = Input.get_axis("ui_left", "ui_right")
    velocity.x = direction * speed

    move_and_slide()
```

在这个代码中，我们使用如上所述的 `move_and_slide()` 来沿着物体的速度向量移动物体，沿着任何碰撞表面（如地面或平台）滑动。我们还使用 `is_on_floor()` 来检查是否应该允许跳转。如果没有这个，你就可以在半空中“跳跃”；如果你正在制作《Flappy Bird》，那就太棒了，但不适合平台游戏。

一个完整的平台角色需要更多的东西：加速、双跳、郊狼时间等等。上面的代码只是一个起点。您可以将其作为基础，扩展到您自己项目所需的任何移动行为中。

### 光线投射

#### 简介

游戏开发中最常见的任务之一是投射光线（或自定义形状的对象）并检查它击中了什么。这使得复杂的行为、人工智能等得以发生。本教程将解释如何在二维和三维中执行此操作。

Godot 将所有低级别的游戏信息存储在服务器中，而场景只是前端。因此，光线投射通常是一项较低级别的任务。对于简单的光线投射，像 RayCast3D 和 RayCast2D 这样的节点会起作用，因为它们会返回每一帧光线投射的结果。

然而，很多时候，光线投射需要是一个更具互动性的过程，因此必须有一种通过代码实现这一点的方法。

#### 空间

在物理世界中，Godot 将所有低级别的碰撞和物理信息存储在一个空间中。当前的二维空间（对于二维物理）可以通过访问 [CanvasItem.get_world_2d().space](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#class-canvasitem-method-get-world-2d) 来获得。对于三维，它是 [Node3D.get_world_3d().space](https://docs.godotengine.org/en/stable/classes/class_node3d.html#class-node3d-method-get-world-3d)。

所得到的空间 RID 可以分别在 PhysicsServer3D 和 PhysicsServer2D 中用于 3D 和 2D。

#### 访问空间

Godot 物理默认情况下与游戏逻辑在同一个线程中运行，但可以设置为在单独的线程上运行，以更有效地工作。因此，访问空间的唯一安全时间是在  [Node._physics_process()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-physics-process) 回调期间。从该函数外部访问它可能会由于空间*被锁定*而导致错误。

若要对物理空间执行查询，必须使用 PhysicsDirectSpaceState2D 和 PhysicsDirectSpaceState3D。

在二维中使用以下代码：

```python
func _physics_process(delta):
    var space_rid = get_world_2d().space
    var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
```

或更直接：

```python
func _physics_process(delta):
    var space_state = get_world_2d().direct_space_state
```

在 3D 中：

```python
func _physics_process(delta):
    var space_state = get_world_3d().direct_space_state
```

#### 光线投射查询

为了执行二维光线投射查询，可以使用 PhysicsDirectSpaceState2D.contersect_ray() 方法。例如：

```python
func _physics_process(delta):
    var space_state = get_world_2d().direct_space_state
    # use global coordinates, not local to node
    var query = PhysicsRayQueryParameters2D.create(Vector2(0, 0), Vector2(50, 100))
    var result = space_state.intersect_ray(query)
```

结果是一本字典。如果射线没有击中任何东西，字典就会空了。如果它确实撞到了什么东西，它将包含碰撞信息：

```python
if result:
    print("Hit at point: ", result.position)
```

发生冲突时的 `result` 字典包含以下数据：

```python
{
   position: Vector2 # point in world space for collision
   normal: Vector2 # normal in world space for collision
   collider: Object # Object collided or null (if unassociated)
   collider_id: ObjectID # Object it collided against
   rid: RID # RID it collided against
   shape: int # shape index of collider
   metadata: Variant() # metadata of collider
}
```

数据在三维空间中是相似的，使用 Vector3 坐标。请注意，要启用与 Area3D 的冲突，布尔参数 `collapse_with_areas` 必须设置为 `true`。

```python
func _physics_process(delta):
    var space_state = get_world_3d().direct_space_state
    var cam = $Camera3D
    var mousepos = get_viewport().get_mouse_position()

    var origin = cam.project_ray_origin(mousepos)
    var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
    var query = PhysicsRayQueryParameters3D.create(origin, end)
    query.collide_with_areas = true

    var result = space_state.intersect_ray(query)
```

#### 碰撞例外

光线投射的一个常见用例是使角色能够收集有关其周围世界的数据。其中一个问题是，同一个角色有一个碰撞器，因此光线将只检测其父角色的碰撞器，如下图所示：

为了避免自相交，`intersect_ray()` parameters 对象可以通过其 `exclude` 属性获取一组异常。以下是如何从 CharacterBody2D 或任何其他碰撞对象节点使用它的示例：

```python
extends CharacterBody2D

func _physics_process(delta):
    var space_state = get_world_2d().direct_space_state
    var query = PhysicsRayQueryParameters2D.create(global_position, enemy_position)
    query.exclude = [self]
    var result = space_state.intersect_ray(query)
```

异常数组可以包含对象或 RID。

#### 碰撞遮罩

虽然 exceptions 方法可以很好地排除父实体，但如果您需要一个大的和/或动态的异常列表，则会变得非常不方便。在这种情况下，使用碰撞层/掩模系统要有效得多。

`intersect_ray()` parameters 对象也可以提供碰撞掩码。例如，要使用与父实体相同的遮罩，请使用 `collision_mask` 成员变量。异常数组也可以作为最后一个参数提供：

```python
extends CharacterBody2D

func _physics_process(delta):
    var space_state = get_world_2d().direct_space_state
    var query = PhysicsRayQueryParameters2D.create(global_position, enemy_position,
        collision_mask, [self])
    var result = space_state.intersect_ray(query)
```

有关如何设置碰撞遮罩的详细信息，请参见代码示例。

#### 屏幕上的 3D 光线投射

将光线从屏幕投射到三维物理空间对于对象拾取非常有用。没有太多必要这样做，因为 CollisionObject3D 有一个 “input_event” 信号，可以让你知道它是何时被点击的，但如果有人想手动操作，下面是操作方法。

若要从屏幕投射光线，需要一个 Camera3D 节点。`Camera3D` 可以有两种投影模式：透视和正交。因此，必须同时获得光线的原点和方向。这是因为 `origin` 在正交模式下变化，而 `normal` 在透视模式下变化：

要使用相机获取，可以使用以下代码：

```python
const RAY_LENGTH = 1000.0

func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == 1:
          var camera3d = $Camera3D
          var from = camera3d.project_ray_origin(event.position)
          var to = from + camera3d.project_ray_normal(event.position) * RAY_LENGTH
```

请记住，在 `_input()` 过程中，空间可能会被锁定，因此在实践中，该查询应该在 `_physics_process()` 中运行。

### 布娃娃系统

#### 简介

自 3.1 版本以来，Godot 支持布娃娃物理。布娃娃依靠物理模拟来创建逼真的程序动画。它们被用于许多游戏中的死亡动画。

在本教程中，我们将使用 Platformer3D 演示来设置布娃娃。

> **注意：**
>
> 您可以在 GitHub 或使用资产库下载 Platformer3D 演示。

#### 设置布娃娃

##### 创建物理骨骼

与引擎中的许多其他功能一样，有一个节点可以设置布娃娃：PhysicalBone3D 节点。为了简化设置，可以使用骨架节点中的“创建物理骨架”功能生成 `PhysicalBone` 节点。

在 Godot 中打开 platformer 演示，然后打开 Robi 场景。选择“`Skeleton`（骨架）”节点。一个骨架按钮出现在顶部栏菜单上：

单击它并选择 `Create physical skeleton`（创建物理骨架）选项。Godot 将为骨骼中的每个骨骼生成 `PhysicalBone` 节点和碰撞形状，并固定关节以将它们连接在一起：

某些生成的骨骼是不必要的：例如 `MASTER` 骨骼。所以我们将通过移除它们来清理骨架。

##### 清理骨架

引擎需要模拟的每个 PhysicalBone 都有性能成本，因此您希望删除每个太小而无法在模拟中产生影响的骨骼，以及所有实用骨骼。

例如，如果我们取一个人形，你不希望每个手指都有物理骨骼。可以将单个骨骼用于整个手，也可以将一个用于手掌、一个用于拇指，最后一个用于其他四个手指。

移除这些物理骨骼： `MASTER`, `waist`, `neck`, `headtracker`。这为我们提供了一个优化的骨架，并使我们更容易控制布娃娃。

##### 碰撞形状调整

下一个任务是调整碰撞形状和物理骨骼的大小，以匹配每个骨骼应该模拟的身体部分。

##### 关节调整

一旦你调整了碰撞形状，你的布娃娃就差不多准备好了。您只想调整销关节以获得更好的模拟。默认情况下，`PhysicalBone` 节点会指定一个不受约束的固定关节。若要更改销关节，请选择 `PhysicalBone` 并在 `Joint` 区域中更改约束类型。在那里，您可以更改约束的方向及其限制。

这是最终结果：

#### 模拟布娃娃

布娃娃现在可以使用了。要启动模拟并播放布娃娃动画，需要调用 `physical_bones_start_simulation` 方法。将脚本附加到骨架节点，并调用 `_ready` 方法中的方法：

```python
func _ready():
    physical_bones_start_simulation()
```

要停止模拟，请调用 `physical_bones_stop_simulation()` 方法。

也可以将模拟限制为仅限于少数骨骼。要执行此操作，请将骨骼名称作为参数传递。以下是部分布娃娃模拟的示例：

##### 碰撞层和遮罩

确保正确设置碰撞层和遮罩，这样 `CharacterBody3D` 的胶囊就不会妨碍物理模拟：

有关详细信息，请阅读“碰撞层和遮罩”。

### 运动学角色（2D）

#### 简介

是的，这个名字听起来很奇怪。“运动学角色”。那是什么？之所以取这个名字，是因为当物理引擎问世时，它们被称为“动力学”引擎（因为它们主要处理碰撞响应）。人们曾多次尝试使用动力学引擎创建角色控制器，但并不像看上去那么容易。Godot 拥有你能找到的最好的动态角色控制器实现之一（正如在 2d/platformer 演示中所看到的），但使用它需要相当水平的技能和对物理引擎的理解（或者对试错有很大的耐心）。

一些物理引擎，如 Havok，似乎认为动态角色控制器是最佳选择，而其他引擎（PhysX）则更倾向于推广运动学引擎。

那么，有什么区别呢？：

- **动态特性控制器**使用具有无限惯性张量的刚体。它是一个不能旋转的刚体。物理引擎总是让物体移动和碰撞，然后一起解决它们的碰撞。这使得动态角色控制器能够与其他物理对象无缝交互，如 platformer 演示中所示。然而，这些互动并不总是可以预测的。碰撞可能需要多个帧才能解决，因此一些碰撞可能会产生微小的位移。这些问题可以解决，但需要一定的技巧。
- 假设**运动学角色控制器**始终从非碰撞状态开始，并始终移动到非碰撞状态。如果它在碰撞状态下开始，它会像刚体一样尝试释放自己，但这是例外，而不是规则。这使得它们的控制和运动更加可预测，也更容易编程。然而，不利的一面是，它们不能直接与其他物理对象交互，除非手工编写代码。

本简短教程主要介绍运动学角色控制器。它使用了老派的处理碰撞的方法，这种方法不一定简单，但很好地隐藏起来，并以 API 的形式呈现出来。

#### 物理过程

为了管理运动学物体或角色的逻辑，总是建议使用物理过程，因为它在物理步骤之前被调用，并且它的执行与物理服务器同步，而且它总是每秒被调用相同的次数。这使得物理和运动计算以比使用常规过程更可预测的方式工作，如果帧速率过高或过低，常规过程可能会出现尖峰或失去精度。

```python
extends CharacterBody2D

func _physics_process(delta):
    pass
```

#### 场景设置

为了测试一些东西，下面是场景（来自 tilemap 教程）： kinematic_character_2d_starter.zip。我们将为角色创建一个新场景。使用机器人精灵并创建如下场景：

您会注意到，在我们的 CollisionShape2D 节点旁边有一个警告图标；那是因为我们还没有为它定义形状。在 CollisionShape2D 的 shape 属性中创建一个新的 CircleShape2D。单击 `<CircleShape2D>` 以转到其选项，并将半径设置为 30：

**注意：如前所述，在物理教程中，物理引擎无法处理大多数类型形状的缩放（只有碰撞多边形、平面和线段才能工作），因此始终更改形状的参数（如半径），而不是缩放。运动学/刚体/静体本身也是如此，因为它们的缩放会影响形状的缩放。**

现在，为角色创建一个脚本，上面用作示例的脚本应该作为基础。

最后，在 tilemap 中实例化该角色场景，并使地图场景成为主要场景，以便在按下 play 时运行。

#### 移动运动学角色

回到角色场景，打开剧本，魔法开始了！运动学实体在默认情况下不会执行任何操作，但它有一个名为 `CharacterBody2D.move_and_collide()` 的有用函数。该函数以 Vector2 为参数，并尝试将该运动应用于运动学实体。如果发生碰撞，它会在碰撞的瞬间停止。

所以，让我们向下移动精灵，直到它碰到地板：

```python
extends CharacterBody2D

func _physics_process(delta):
    move_and_collide(Vector2(0, 1)) # Move down 1 pixel per physics frame
```

结果是角色会移动，但在碰到地板时会停止。很酷吧？

下一步将为混合添加重力，这样它的行为更像一个普通的游戏角色：

```python
extends CharacterBody2D

const GRAVITY = 200.0

func _physics_process(delta):
    velocity.y += delta * GRAVITY

    var motion = velocity * delta
    move_and_collide(motion)
```

现在角色顺利下落。让我们让它在触摸方向键时向左右两侧移动。请记住，所使用的值（至少用于速度）是像素/秒。

这增加了左右按压时行走的基本支撑：

```python
extends CharacterBody2D

const GRAVITY = 200.0
const WALK_SPEED = 200

func _physics_process(delta):
    velocity.y += delta * GRAVITY

    if Input.is_action_pressed("ui_left"):
        velocity.x = -WALK_SPEED
    elif Input.is_action_pressed("ui_right"):
        velocity.x =  WALK_SPEED
    else:
        velocity.x = 0

    # "move_and_slide" already takes delta time into account.
    move_and_slide()
```

试试看。

这对于平台构建者来说是一个很好的起点。更完整的演示可以在随引擎分发的演示 zip 中找到，或者在 https://github.com/godotengine/godot-demo-projects/tree/master/2d/kinematic_character.

### 使用 SoftBody

柔体（或柔体动力学）模拟可变形对象的运动、形状变化和其他物理特性。例如，这可以用于模拟布料或创建更逼真的角色。

#### 基本设置

SoftBody3D 节点用于柔体模拟。

我们将创建一个有弹性的立方体来演示软体的设置。

以 `Node3D` 节点为根创建新场景。然后，创建一个 `Softbody` 节点。在检查器中节点的 `mesh` 属性中添加 `CubeMesh`，并增加网格的细分以进行模拟。

设置参数以获得您想要的柔体类型。尽量将 `Simulation Precision`（模拟精度）保持在 5 以上，否则，柔体可能会塌陷。

> **注意：**
>
> 小心处理某些参数，因为某些值可能会导致奇怪的结果。例如，如果形状没有完全闭合，并且您将压力设置为大于 0，则柔体将在强风下像塑料袋一样四处飞行。

播放场景以查看模拟。

> **提示：**
>
> 为了提高仿真结果，提高仿真精度，这将以性能为代价进行显著改进。

#### 斗篷模拟

让我们在 Platformer3D 演示中制作一件斗篷。

> **注意：**
>
> 您可以在 GitHub 或资产库上下载 Platformer3D 演示。

打开 `Player` 场景，添加 `SoftBody` 节点并为其指定 `PlaneMesh`。

打开 `PlaneMesh` 属性并设定大小（x:0.5 y:1），然后将 `Subdivide Width`（细分宽度）和 `Subdivide Depth`（细分深度）设定为 5。调整 `SoftBody` 的位置。你最终应该得到这样的结果：

> **提示：**
>
> “细分”会生成更细分的网格，以便进行更好的模拟。

在骨骼节点下添加 BoneAttachment3D 节点，然后选择“颈部骨骼”将斗篷附加到角色骨骼。

> **注意：**
>
> `BoneAttachment3D` 节点是将对象附着到甲胄（armature）的骨骼上。附着的物体将跟随骨骼的移动，角色的武器可以通过这种方式附着。

若要创建固定关节，请选择 `SoftBody` 节点中的上部顶点：

固定关节可以在 `SoftBody` 的 `Attachments` 属性中找到，选择 `BoneAttachment` 作为每个固定关节的 `SpatialAttachment`，固定关节现在附着到颈部。

最后一步是通过将运动学身体*玩家*添加到 `SoftBody` 的 `Parent Collision Ignore`（父碰撞忽略）来避免剪裁。

播放场景，斗篷应正确模拟。

这涵盖了柔体的基本设置，在制作游戏时对参数进行实验，以达到你想要的效果。

### 碰撞形状（2D）

本指南解释：

- Godot 中二维可用的碰撞形状的类型。
- 使用转换为多边形的图像作为碰撞形状。
- 关于 2D 碰撞的性能注意事项。

Godot 提供多种碰撞形状，具有不同的性能和精度权衡。

可以通过添加一个或多个 CollisionShape2D 或 CollisionPolygon2D 作为子节点来定义 PhysicsBody2D 的形状。请注意，必须将 Shape2D *资源*添加到 Inspector 停靠中的碰撞形状节点。

> **注意：**
>
> 将多个碰撞形状添加到单个 PhysicsBody2D 中时，不必担心它们重叠。他们不会互相“碰撞”。

#### 基本碰撞形状

Godot提供以下基本体碰撞形状类型：

- [RectangleShape2D](https://docs.godotengine.org/en/stable/classes/class_rectangleshape2d.html#class-rectangleshape2d)
- [CircleShape2D](https://docs.godotengine.org/en/stable/classes/class_circleshape2d.html#class-circleshape2d)
- [CapsuleShape2D](https://docs.godotengine.org/en/stable/classes/class_capsuleshape2d.html#class-capsuleshape2d)
- [SegmentShape2D](https://docs.godotengine.org/en/stable/classes/class_segmentshape2d.html#class-segmentshape2d)
- [SeparationRayShape2D](https://docs.godotengine.org/en/stable/classes/class_separationrayshape2d.html#class-separationrayshape2d) (专为角色设计)
- [WorldBoundaryShape2D](https://docs.godotengine.org/en/stable/classes/class_worldboundaryshape2d.html#class-worldboundaryshape2d) (无限平面)

可以使用一个或多个基本体形状来表示大多数较小对象的碰撞。但是，对于更复杂的对象，例如大型船舶或整个标高，可能需要凸形或凹形。下面将详细介绍。

我们建议为动力学对象（如 RigidBodies 和 KinematicBodies）选择基本体形状，因为它们的行为是最可靠的。它们通常也能提供更好的性能。

#### 凸碰撞形状

> **警告：**
>
> Godot 目前没有提供创建 2D 凸碰撞形状的内置方法。本节主要用于参考。

凸碰撞形状是原始碰撞形状和凹碰撞形状之间的折衷。它们可以代表任何复杂的形状，但有一个重要的警告。顾名思义，一个单独的形状只能代表一个凸起的形状。例如，一个金字塔是*凸的*，但一个空心的盒子是*凹的*。若要定义具有单个碰撞形状的凹形对象，需要使用凹形碰撞形状。

根据对象的复杂性，使用多个凸形状而不是凹碰撞形状可能会获得更好的性能。Godot 允许您使用*凸分解*来生成大致匹配空心对象的凸形状。请注意，这种性能优势在一定数量的凸起形状之后不再适用。对于大型和复杂的对象，例如整个级别，我们建议使用凹形。

#### 凹凸碰撞形状

凹形碰撞形状，也称为三聚碰撞形状，可以采取任何形式，从几个三角形到数千个三角形。凹形是最慢的选择，但在 Godot 中也是最准确的。**只能在 StaticBodies 中使用凹形。**除非 RigidBody 的模式是静态的，否则它们将无法与 KinematicBodies 或 RigidBodies 一起使用。

> **注意：**
>
> 即使凹面形状提供了最准确的*碰撞*，接触报告也可能不如原始形状精确。

当不使用 TileMaps 进行关卡设计时，凹入形状是关卡碰撞的最佳方法。

可以在检查器中配置 CollisionPolygon2D 节点的构建模式。如果将其设置为“**实体**”（默认设置），则碰撞将包括多边形及其包含的区域。如果设置为“**分段**”，则碰撞将仅包括多边形边。

通过选择 Sprite2D 并使用 2D 视口顶部的 **Sprite2D** 菜单，可以从编辑器中生成凹面碰撞形状。Sprite2D 下拉菜单将显示一个名为“**创建碰撞多边形 2D 同级**”的选项。单击后，它将显示一个包含 3 个设置的菜单：

- **简化**：值越高，形状越不详细，从而以精度为代价提高性能。
- **收缩（像素）**：较高的值将使生成的碰撞多边形相对于精灵的边缘收缩。
- **增长（像素）**：较高的值将使生成的碰撞多边形相对于精灵的边缘增长。请注意，将“增长”和“收缩”设置为相等的值可能会产生与将两者都保留为 0 不同的结果。

> **注意：**
>
> 如果您有一个包含许多小细节的图像，建议创建一个简化版本，并使用它来生成碰撞多边形。这可以带来更好的性能和游戏感觉，因为玩家不会被小的装饰性细节阻挡。
>
> 若要使用单独的图像生成碰撞多边形，请创建另一个 Sprite2D，从中生成碰撞多边形同级，然后移除 Sprite2D 节点。通过这种方式，可以从生成的碰撞中排除小细节。

#### 性能注意事项

每个 PhysicsBody 不限于单个碰撞形状。尽管如此，我们还是建议尽可能减少形状的数量，以提高性能，尤其是对于像 RigidBodies 和 KinematicBodies 这样的动态对象。最重要的是，避免平移、旋转或缩放 CollisionShapes，以受益于物理引擎的内部优化。

在 StaticBody 中使用单个未变换的碰撞形状时，引擎的*宽相位*算法可以丢弃不活动的 PhysicsBodies。然后，*窄相位*将只需要考虑活动体的形状。如果 StaticBody 有许多碰撞形状，则宽阶段将失败。然后，较慢的窄阶段必须针对每个形状执行碰撞检查。

如果遇到性能问题，您可能需要在准确性方面进行权衡。大多数游戏都没有 100% 准确的碰撞。他们会找到创造性的方法来隐藏它，或者在正常游戏中让它变得不显眼。

### 碰撞形状（3D）

本指南解释：

- Godot 中三维可用的碰撞形状的类型。
- 使用凸网格或凹网格作为碰撞形状。
- 关于三维碰撞的性能注意事项。

Godot 提供多种碰撞形状，具有不同的性能和精度权衡。

可以通过添加一个或多个 CollisionShape3D 作为子节点来定义 PhysicsBody3D 的形状。请注意，必须将 Shape3D 资源添加到 Inspector 停靠中的碰撞形状节点。

> **注意：**
>
> 将多个碰撞形状添加到单个 PhysicsBody 时，不必担心它们重叠。他们不会互相“碰撞”。

#### 基本碰撞形状

Godot提供以下基本体碰撞形状类型：

- [BoxShape3D](https://docs.godotengine.org/en/stable/classes/class_boxshape3d.html#class-boxshape3d)
- [SphereShape3D](https://docs.godotengine.org/en/stable/classes/class_sphereshape3d.html#class-sphereshape3d)
- [CapsuleShape3D](https://docs.godotengine.org/en/stable/classes/class_capsuleshape3d.html#class-capsuleshape3d)
- [CylinderShape3D](https://docs.godotengine.org/en/stable/classes/class_cylindershape3d.html#class-cylindershape3d)

可以使用一个或多个基本体形状来表示大多数较小对象的碰撞。但是，对于更复杂的对象，例如大型船舶或整个标高，可能需要凸形或凹形。下面将详细介绍。

我们建议为动力学对象（如 RigidBodies 和 KinematicBodies）选择基本体形状，因为它们的行为是最可靠的。它们通常也能提供更好的性能。

#### 凸碰撞形状

凸碰撞形状是原始碰撞形状和凹碰撞形状之间的折衷。它们可以代表任何复杂的形状，但有一个重要的警告。顾名思义，一个单独的形状只能代表一个凸起的形状。例如，一个金字塔是*凸的*，但一个空心的盒子是*凹的*。若要定义具有单个碰撞形状的凹形对象，需要使用凹形碰撞形状。

根据对象的复杂性，使用多个凸形状而不是凹碰撞形状可能会获得更好的性能。Godot允许您使用*凸分解*来生成大致匹配空心对象的凸形状。请注意，这种性能优势在一定数量的凸起形状之后不再适用。对于大型和复杂的对象，例如整个级别，我们建议使用凹形。

通过选择 MeshInstance3D 并使用 3D 视口顶部的 **Mesh** 菜单，可以从编辑器中生成一个或多个凸碰撞形状。编辑器公开了两种生成模式：

- **创建单个凸碰撞同级**使用“快速外壳”（Quickhull）算法。它将创建一个具有自动生成的凸碰撞形状的 CollisionShape 节点。由于它只生成单个形状，因此性能良好，非常适合小型对象。
- **创建多个凸碰撞同级**使用 V-HACD 算法。它创建了几个 CollisionShape 节点，每个节点都有一个凸起的形状。由于它可以生成多个形状，因此以牺牲性能为代价对凹面对象更准确。对于中等复杂度的对象，它可能比使用单个凹面碰撞形状更快。

#### 凹凸碰撞形状

凹形碰撞形状，也称为三聚碰撞形状，可以采取任何形式，从几个三角形到数千个三角形。凹形是最慢的选择，但在 Godot 中也是最准确的。**只能在 StaticBodies 中使用凹形。**除非刚体的模式是静态的，否则它们将无法与 KinematicBodies 或 RigidBodies 一起使用。

> **注意：**
>
> 即使凹面形状提供了最准确的*碰撞*，接触报告也可能不如原始形状精确。

当不使用网格贴图进行标高设计时，凹入形状是标高碰撞的最佳方法。也就是说，如果你的关卡有一些小细节，为了表现和游戏感觉，你可能想把这些细节排除在碰撞之外。为此，可以在三维建模器中构建简化的碰撞网格，并让 Godot 自动为其生成碰撞形状。下面将详细介绍

请注意，与原始形状和凸面形状不同，凹面碰撞形状没有实际的“体积”。可以将对象放置在造型*外部*，也可以放置在造型*内部*。

通过选择 MeshInstance3D 并使用 3D 视口顶部的 **Mesh** 菜单，可以从编辑器生成凹面碰撞形状。编辑器公开了两个选项：

- **创建 Trimesh 静态实体**是一个方便的选项。它将创建一个 StaticBody，其中包含与网格几何体匹配的凹形。
- **创建 Trimesh 碰撞同级节点**将创建一个具有与网格几何体匹配的凹形的 CollisionShape 节点。

> **注意：**
>
> 假设您需要使刚体在凹形碰撞形状上*滑动*。在这种情况下，您可能会注意到，有时刚体会向上颠簸。若要解决此问题，请打开**“项目” > “项目设置”**，然后启用**“物理” > “三维” > “平滑三网格碰撞”**。
>
> 启用平滑三聚碰撞后，请确保凹形是 StaticBody 的唯一形状，并且它位于原点，没有任何旋转。这样，刚体就可以在 StaticBody 上完美地滑动。

> **参考：**
>
> 有关如何导出 Godot 模型并在导入时自动生成碰撞形状的信息，请参见导入 3D 场景。

#### 性能注意事项

每个 PhysicsBody 不限于单个碰撞形状。尽管如此，我们还是建议尽可能减少形状的数量，以提高性能，尤其是对于像 RigidBodies 和 KinematicBodies 这样的动态对象。最重要的是，避免平移、旋转或缩放 CollisionShapes，以受益于物理引擎的内部优化。
在 StaticBody 中使用单个未变换的碰撞形状时，引擎的*宽相位*算法可以丢弃不活动的 PhysicsBodies。然后，*窄相位*将只需要考虑活动体的形状。如果 StaticBody 有许多碰撞形状，则宽阶段将失败。然后，较慢的窄阶段必须针对每个形状执行碰撞检查。

如果遇到性能问题，您可能需要在准确性方面进行权衡。大多数游戏都没有 100% 准确的碰撞。他们会找到创造性的方法来隐藏它，或者在正常游戏中让它变得不显眼。

### 大世界坐标

> **注意：**
>
> 大世界坐标主要用于三维项目；在 2D 项目中很少需要它们。此外，与 3D 渲染不同，启用大世界坐标时，2D 渲染当前无法从提高精度中获益。

#### 为什么要使用大世界坐标？

在 Godot 中，物理模拟和渲染都依赖于浮点数。然而，在计算中，浮点数的**精度和范围有限**。对于拥有巨大世界的游戏来说，这可能是一个问题，例如太空或行星级模拟游戏。

当该值接近 `0.0` 时，精度最大。随着值从 `0.0` 增大或减小，精度逐渐降低。每当浮点数的指数增加时就会发生这种情况，当浮点数超过 2 的幂值（2、4、8、16…）时就会发生。每次发生这种情况时，数字的最小步长都会增加，从而导致精度损失。
在实践中，这意味着随着玩家远离世界原点（2D 游戏中的 `Vector2(0, 0)` 或 3D 游戏中的 `Vector3(0, 0, 0)`），精度将降低。

这种精度的损失可能会导致物体在远离世界原点时看起来“振动”，因为模型的位置将捕捉到可以用浮点数表示的最近值。这也可能导致只有当玩家远离世界时才会出现的物理故障。

范围决定了可以存储在数字中的最小值和最大值。如果玩家试图移动超过这个范围，他们根本无法移动。然而，在实践中，浮点精度几乎总是在范围移动之前成为问题。

范围和精度（两个指数间隔之间的最小步长）由浮点数类型决定。*理论*范围允许将极高的值存储在单精度浮点中，但精度非常低。在实践中，不能表示所有整数值的浮点类型不是很有用。在极值处，精度变得非常低，以至于数字甚至无法区分两个单独的*整数*值。

这是单个整数值可以用浮点数表示的范围：

- **单精度浮点范围（表示所有整数）**：介于 -16,777,216 和 16,777,216 之间
- **双精度浮点范围（表示所有整数）**：介于 -9 万亿和 9 万亿之间

| 范围             | 单步进     | 双浮点步进            | 注释                                                         |
| ---------------- | ---------- | --------------------- | ------------------------------------------------------------ |
| [1; 2]           | ~0.0000001 | ~1e-15                | 精度在 0.0 附近变大（此表缩写）。                            |
| [2; 4]           | ~0.0000002 | ~1e-15                |                                                              |
| [4; 8]           | ~0.0000005 | ~1e-15                |                                                              |
| [8; 16]          | ~0.000001  | ~1e-14                |                                                              |
| [16; 32]         | ~0.000002  | ~1e-14                |                                                              |
| [32; 64]         | ~0.000004  | ~1e-14                |                                                              |
| [64; 128]        | ~0.000008  | ~1e-13                |                                                              |
| [128; 256]       | ~0.000015  | ~1e-13                |                                                              |
| [256; 512]       | ~0.00003   | ~1e-13                |                                                              |
| [512; 1024]      | ~0.00006   | ~1e-12                |                                                              |
| [1024; 2048]     | ~0.0001    | ~1e-12                |                                                              |
| [2048; 4096]     | ~0.0002    | ~1e-12                | 没有渲染伪影或物理故障的第一人称3D游戏的最大*推荐*单精度范围。 |
| [4096; 8192]     | ~0.0005    | ~1e-12                | 没有渲染伪影或物理故障的第三人称3D游戏的最大*推荐*单精度范围。 |
| [8192; 16384]    | ~0.001     | ~1e-12                |                                                              |
| [16384; 32768]   | ~0.0019    | ~1e-11                | 自上而下的3D游戏在没有渲染伪影或物理故障的情况下的最大*推荐*单精度范围。 |
| [32768; 65536]   | ~0.0039    | ~1e-11                | 任何3D游戏的最大*推荐*单精度范围。超过该点通常需要双倍精度（大世界坐标）。 |
| [65536; 131072]  | ~0.0078    | ~1e-11                |                                                              |
| [131072; 262144] | ~0.0156    | ~1e-10                |                                                              |
| > 262144         | > ~0.0313  | ~1e-10 (0.0000000001) | 超过该值后，双精度仍远高于单精度。                           |

当使用单精度浮点数时，可以超过建议的范围，但会出现更明显的伪影，物理故障也会更常见（例如玩家没有朝某些方向笔直行走）。

> **参考：**
>
> 有关详细信息，请参阅“浮点精度”一文。

#### 大世界坐标如何工作

大世界坐标（也称为**双精度物理**）提高了引擎内所有浮点计算的精度。

默认情况下，GDScript 中的 float 为64位，但 Vector2、Vector3 和 Vector4 为 32 位。这意味着向量类型的精度要有限得多。为了解决这个问题，我们可以增加 Vector 类型中用于表示浮点数的位数。这导致精度*呈指数级*增长，这意味着最终值的精度不仅是原来的两倍，而且在高值时可能会高出数千倍。通过从单精度浮点转换为双精度浮点，可以表示的最大值也大大增加。

为了避免在远离世界原点时出现模型捕捉问题，Godot 的 3D 渲染引擎将在启用大世界坐标时提高渲染操作的精度。出于性能原因，着色器不使用双精度浮点，但使用一种替代解决方案来模拟使用单精度浮点渲染的双精度。

> **注意：**
>
> 启用大型世界坐标会带来性能和内存使用方面的损失，尤其是在 32 位 CPU 上。只有在实际需要时才启用大世界坐标。
>
> 此功能是为中端/高端桌面平台量身定制的。大世界坐标在低端移动设备上可能无法正常运行，除非您采取措施通过其他方式（例如减少每秒物理滴答声的数量）减少 CPU 使用量。
>
> 在低端平台上，可以使用*原点偏移*方法来实现大世界，而无需使用双精度物理和渲染。原点偏移适用于单精度浮点，但它给游戏逻辑带来了更多的复杂性，尤其是在多人游戏中。因此，本页未详细说明原点偏移。

#### 大世界坐标是给谁的？

3D 空间或行星级模拟游戏通常需要大的世界坐标。这延伸到需要支持*非常*快的移动速度，但有时也需要支持非常慢*和*精确的移动的游戏。

另一方面，重要的是，只有在实际需要时才使用大世界坐标（出于性能原因）。以下情况通常**不**需要大世界坐标：

- 2D 游戏，因为精度问题通常不太明显。
- 小规模或中等规模世界的游戏。
- 游戏有很大的世界，但分为不同的级别，加载顺序介于两者之间。您可以将每个级别部分集中在世界原点周围，以避免精度问题，而不会造成性能损失。
- 开放式世界游戏，*可步行区域*不超过 8192×8192 米（以世界原点为中心）。如上表所示，即使对于第一人称游戏，精度水平在该范围内也可以接受。

**如果有疑问**，您可能不需要在项目中使用大世界坐标。作为参考，大多数现代 AAA 开放世界游戏不使用大型世界坐标系，在渲染和物理方面仍然依赖单精度浮点。

#### 启用大世界坐标

这个过程需要重新编译编辑器和所有要使用的导出模板二进制文件。如果只打算在发布模式下导出项目，则可以跳过调试导出模板的编译。在任何情况下，您都需要编译一个编辑器构建，这样您就可以测试您的大精度世界，而不必每次都导出项目。

有关每个目标平台的编译说明，请参阅编译部分。编译编辑器和导出模板时，需要添加 `precision=double` SCons 选项。

生成的二进制文件将使用 `.double` 后缀命名，以区别于单精度二进制文件（缺少任何精度后缀）。然后，您可以在“导出”对话框中的项目导出预设中将二进制文件指定为自定义导出模板。

#### 单精度和双精度构建之间的兼容性

使用 ResourceSaver singleton 保存*二进制*资源时，如果使用使用双精度数字的构建保存资源，则会在文件中存储一个特殊标志。因此，当您切换到双精度构建并保存时，磁盘上的所有二进制资源都会发生变化。

单精度和双精度都在使用此特殊标志的资源上使用 ResourceLoader 单例构建支持。这意味着单精度构建可以加载使用双精度构建保存的资源，反之亦然。基于文本的资源不存储双精度标志，因为它们不需要这样的标志才能正确读取。

##### 已知不兼容性

- 在网络多人游戏中，服务器和所有客户端应该使用相同的构建类型，以确保客户端之间的精度保持一致。使用不同的构建类型*可能*会起作用，但可能会出现各种问题。
- GDExtension API 在双精度构建中以不兼容的方式更改。这意味着**必须**重建扩展以使用双精度构建。在扩展开发人员端，当构建精度为 DOUBLE 的 GDExtension 时，将启用 `REAL_T_IS_DUBLE` 定义。`real_t` 可以用作单精度构建中 `float` 的别名，也可以用作双精度构建中 `double` 的别名。

#### 限制

由于 3D 渲染着色器实际上并不使用双精度浮点，因此在 3D 渲染精度方面存在一些限制：

- 使用 `skip_vertex_transform` 或 `world_vertex_coords` 的着色器不会从提高的精度中受益。
- 三平面映射不能从提高精度中获益。使用三平面贴图的材质在远离世界原点时会显示出可见的抖动。

启用大世界坐标后，二维渲染当前无法从提高的精度中获益。这可能会导致在远离世界原点时发生可见模型捕捉（从典型缩放级别的几百万像素开始）。尽管如此，2D 物理计算仍将受益于提高的精度。

### 排除物理问题

使用物理引擎时，您可能会遇到意想不到的结果。

虽然这些问题中的许多可以通过配置来解决，但其中一些是引擎错误的结果。有关物理引擎的已知问题，请参阅 GitHub 上的开放式物理相关问题。浏览已关闭的问题也有助于回答与物理引擎行为相关的问题。

#### 物体以高速相互穿过

这就是所谓的*隧穿*。在 RigidBody 属性中启用 **Continuous CD** 有时可以解决此问题。如果这没有帮助，您可以尝试其他解决方案：

- 使静态碰撞形状更厚。例如，如果玩家无法以某种方式到达较薄的地板下方，则可以使碰撞器比地板的视觉表示更厚。
- 根据快速移动对象的移动速度修改其碰撞形状。对象移动得越快，碰撞形状应该延伸到对象外部越大，以确保它能够更可靠地与薄壁碰撞。
- 在高级项目设置中增加**每秒物理滴答声**。虽然这还有其他好处（如更稳定的模拟和减少输入滞后），但这增加了 CPU 利用率，可能不适用于移动/ web 平台。默认值为 `60`（如 `120`、`180` 或 `240`）的倍数应是大多数显示器上平滑外观的首选。

#### 堆叠的对象不稳定且摇摆

尽管看起来是一个简单的问题，但在物理引擎中很难实现具有堆叠对象的稳定刚体模拟。这是由相互作用的综合力造成的。堆叠的物体越多，相互作用的力就越强。这最终会导致模拟变得不稳定，使对象无法在不移动的情况下彼此叠放。

提高物理模拟速率可以帮助缓解这个问题。为此，请在高级项目设置中增加“每秒物理刻度”。请注意，这会增加 CPU 利用率，并且可能不适用于移动/ web 平台。默认值为 `60`（如 `120`、`180` 或 `240`）的倍数应是大多数显示器上平滑外观的首选。

#### 缩放的物理体或碰撞形状未正确碰撞

Godot 目前不支持物理体或碰撞形状的缩放。作为一种解决方法，请更改碰撞形状的范围，而不是更改其比例。如果希望视觉表示的比例也更改，请分别更改基础视觉表示（Sprite2D、MeshInstance3D…）的比例和更改碰撞形状的范围。在这种情况下，请确保碰撞形状不是视觉表示的子对象。

由于默认情况下资源是共享的，因此如果不希望将更改应用于场景中使用相同碰撞形状资源的所有节点，则必须使碰撞形状资源唯一。这可以通过在更改冲突形状资源的大小之前在脚本中调用 `duplicate()` 来完成。

#### 薄物体放在地板上时会摇晃

这可能是由于以下两种原因之一：

- 地板的碰撞形状太薄。
- 刚体的碰撞形状太薄。

在第一种情况下，可以通过使地板的碰撞形状更厚来减轻这种情况。例如，如果玩家无法以某种方式到达较薄的地板下方，则可以使碰撞器比地板的视觉表示更厚。

在第二种情况下，这通常只能通过提高物理模拟率来解决（因为使形状变厚会导致刚体的视觉表示与其碰撞之间的脱节）。

在这两种情况下，提高物理模拟速率也有助于缓解这一问题。为此，请在高级项目设置中增加“**每秒物理刻度**”。请注意，这会增加 CPU 利用率，并且可能不适用于移动/ web 平台。默认值为 `60`（如 `120`、`180` 或 `240`）的倍数应是大多数显示器上平滑外观的首选。

#### 圆柱体碰撞形状不稳定

在 Godot 4 中从子弹到 GodotPhysics 的过渡过程中，圆柱体碰撞形状必须从头开始重新实现。然而，圆柱体碰撞形状是最难支持的形状之一，这就是为什么许多其他物理引擎没有为它们提供任何支持的原因。目前有几个已知的圆柱体碰撞形状错误。

目前，我们建议对字符使用长方体或胶囊碰撞形状。盒子通常提供了最好的可靠性，但也有让角色在对角线上占据更多空间的缺点。胶囊碰撞形状没有这个缺点，但它们的形状会使精确平台成型更加困难。

#### 车辆车身模拟不稳定，尤其是在高速情况下

当一个物理物体以高速移动时，它在每个物理步骤之间都会移动很长的距离。例如，当在 3D 中使用 1 个单位 = 1 米的约定时，以 360 公里/小时行驶的车辆每秒将行驶 100 个单位。默认物理模拟速率为 60 Hz 时，车辆每次物理刻度移动约 1.67 个单位。这意味着小型物体可能会被车辆完全忽略（由于隧穿），但在如此高的速度下，模拟通常几乎没有数据可供使用。

快速移动的车辆可以从物理模拟速率的提高中受益匪浅。为此，请在高级项目设置中增加“**每秒物理刻度**”。请注意，这会增加 CPU 利用率，并且可能不适用于移动/ web 平台。默认值为 `60`（如 `120`、`180` 或 `240`）的倍数应是大多数显示器上平滑外观的首选。

#### 当对象在瓷砖上移动时，碰撞会导致颠簸

这是物理引擎中一个已知的问题，由物体碰撞到一个形状的边缘引起，即使该边缘被另一个形状覆盖。这可能发生在二维和三维中。

解决这个问题的最好方法是创建一个“复合”对撞机。这意味着，您可以创建一个碰撞形状来表示一组瓷砖的碰撞，而不是单个瓷砖发生碰撞。通常，您应该在每个岛的基础上拆分复合碰撞器（这意味着每组接触瓷砖都有自己的碰撞器）。

在某些情况下，使用复合对撞机还可以提高物理模拟性能。然而，由于复合碰撞形状要复杂得多，这可能不是所有情况下的净性能胜利。

#### 当一个对象触摸另一个对象时帧率下降

这可能是由于其中一个对象使用了过于复杂的碰撞形状。出于性能原因，凸碰撞形状应使用尽可能少的形状。当依赖 Godot 的自动生成时，可能会为单个凸形碰撞资源创建数十个甚至数百个形状。

在某些情况下，用几个基本碰撞形状（长方体、球体或胶囊）替换凸碰撞器可以提供更好的性能。

使用非常详细的三聚（凹）碰撞的 StaticBodies 也可能出现此问题。在这种情况下，使用标高几何体的简化表示作为碰撞器。这不仅可以显著提高物理模拟性能，还可以通过消除碰撞中的小固定装置和裂缝来提高稳定性。

#### 物理模拟在远离世界原点时是不可靠的

这是由浮点精度误差引起的，随着物理模拟发生在离世界更远的地方，浮点精度误差变得更加明显。此问题还会影响渲染，从而导致摄影机在远离世界原点时移动不稳定。有关详细信息，请参见大世界坐标。