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