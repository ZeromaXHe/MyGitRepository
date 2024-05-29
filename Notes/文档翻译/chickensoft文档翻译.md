网址：https://chickensoft.games/

# Chickensoft 开发哲学

https://chickensoft.games/philosophy/

## 目的

Chickensoft 是一个开源组织，旨在为中小型独立游戏开发商和工作室赋能。我们相信，对于大多数中型游戏来说，游戏体系结构在很大程度上是一个已解决的问题。

理想情况下，游戏开发者应该可以自由地专注于实现有趣的游戏逻辑，而不是被迫重新发现几十年来围绕软件架构的知识。作为一个组织，Chickensoft 对如何构建游戏提出了强烈的意见，并提供了实现这些意见的工具。

许多人指出，我们的代码看起来与其他 C# 项目有很大不同。我们并没有故意偏离规范——我们的代码受到各种来源的启发，包括C#编译器本身的代码。为了解释我们为什么这么做，我们概述了一些原则，这些原则为我们对软件架构和游戏开发的强烈意见提供了依据。

> **提示**
>
> 想找一些不那么理论化的东西吗？查看我们的技术操作指南，[令人愉快的游戏架构 Enjoyable Game Architecture](https://chickensoft.games/blog/game-architecture).。

Chickensoft 认为，构建高质量软件的通用工具应该始终是开源的。Chickensoft 的工具是为世界上最流行的开源游戏引擎 Godot 构建的，并根据许可的 MIT 许可证获得许可。我们用世界上最流行的编程语言之一 C# 编写工具，C# 自 2014 年以来一直是开源的。Godot 为 C# 提供第一方支持，并一直位列有史以来最受欢迎的 GitHub 项目前 100 名。

## 为什么在 Godot 中使用 C#？

我们相信，代码质量和开发人员的幸福感是项目能否按时成功完成的核心决定因素。作为一种语言，C# 允许小团队生成高性能、组织良好的代码，是有史以来最受欢迎的编程语言之一。

C# 拥有广泛的企业级库和工具生态系统，经常用于实现从简单控制台程序到复杂分布式系统的所有内容。

## 狗粮

与流行的观点相反，我们制造工具不是为了好玩。只有当我们遇到现实生活中的用例，并确定制作一个工具会使大多数其他中型游戏开发项目受益时，我们才能开发一个工具（即，[我们吃自己的狗粮 we eat our own dog food](https://en.wikipedia.org/wiki/Eating_your_own_dog_food)）。

我们构建每一个工具的目的是立即在真实的游戏项目中使用和尝试它。为此，我们维护了一个经过充分测试的 3D 平台游戏演示，该演示利用了 Chickensoft 工具并展示了我们的架构实践。只有开发我们迫切需要的工具才能防止我们解决不必要的问题，并确保我们工具的质量。没有什么比在具有非琐碎用例的真实生产环境中使用工具更能识别工具中的设计缺陷和 bug 了。

## 我们的技术观点

我们相信游戏代码可以。。。

- 🏎️ 快速的
- 🧘‍♀️ 灵活的
- 🏭 一致的
- 🧪 可测试的
- 📱 跨平台
- 🥚 最小的
- 👩‍💻 可破解的
- 🪢 松散耦合

在过去的几年里，我们一直在构建工具来支持现有的软件体系结构模式，以促进这些目标的实现。虽然没有一种模式是完美的，但我们非常有信心，我们已经打下了一个良好的基础，可以在未来几年里再接再厉。

### 🏎️ 快速的

Chickensoft 更喜欢优化源代码生成而不是反射。生产依赖项仅使用 C# 的无反射模式支持的“反射”，以确保未来在需要提前编译的平台（如 iOS）上的兼容性。

为了防止 C# 垃圾收集器暂停，生产依赖关系避免了关键游戏循环路径期间的内存分配。每个包都努力使用具有正确时间复杂性或基准性能的数据结构，以最佳地解决手头的工作。时间复杂性有时与不同数量的数据无关，因此基于真实世界用例的基准数据结构更适合用于性能关键型数据。

### 🧘‍♀️ 灵活的

所有 Chickensoft 项目的存在都是为了服务于“寻找乐趣”的经典游戏开发理念。由于大多数游戏开发项目都因执行而失败，因此 Chickensoft 工具旨在确保在整个开发生命周期中执行可扩展、结构良好的代码。传统上，随着代码变得越来越混乱，添加功能的成本会随着时间的推移而增加。Chickensoft 的游戏架构和工具的存在是为了随着时间的推移降低成本。Chickensoft 的观点基于其他类似 Godot 的跨平台框架在幕后的实践和成功，以及许多为这些生态系统做出贡献的顶级工程师的建议。

### 🏭 一致的

Chickensoft 利用基于特征的项目结构的概念来确保游戏代码可以正确地标记化（请参阅《游戏架构与设计：新版*Game Architecture and Design: A New Edition*》第17章[第482页]中的“标记中的思考 Thinking in Tokens”）。将一个功能的所有非共享元素保存在一个目录中，可以更容易地将功能复制到其他项目中，并标准化开发人员需要了解游戏中任何给定部分的地方。项目之间复制功能的容易性也不应被低估，因为它允许开发人员在沙盒项目中快速尝试，并将其转移到更成熟的项目中，或者在没有后果的情况下重组更大的项目。

当所有东西的结构一致时，开发人员可以更容易地理解代码库中他们自己没有编写的部分。相似性有助于减少开发者在功能（甚至整个游戏项目）之间的升级时间，从而大幅降低成本。基于功能的体系结构也是一个易于理解的想法，这使得开发人员向新员工或团队中的初级工程师进行教学变得更加简单。

当利用自动化测试时，自包含代码也更容易被模拟 mock（或伪造 fake）。结构良好的代码测试成本相对较低。

### 🧪 可测试的

随着项目越来越先进，单元测试辅助工具或核心游戏系统的重要性变得越来越重要。此外，模拟输入的自动化集成测试可以为游戏提供巨大的价值，并通过防止错误回归大大减轻手动 QA 测试人员的负担。更好的是，您的 QA 团队可以腾出时间来帮助编写自动化测试，确保以基本持平的开发成本获得无限回报。

### 📱 跨平台

Chickensoft 的命令行和 CI/CD 工具设计用于三种主要的桌面操作系统：Windows、macOS 和 Linux。制作游戏的依赖性也被设计用于三大桌面平台，以及 iOS 和 Android。虽然跨平台支持为我们带来了额外的工作量，但我们认为，为了确保开发人员能够在尽可能多的平台上销售他们的产品，额外的努力是值得的。

### 🥚 最小的

每个 Chickensoft 项目都在努力拥有尽可能少的代码，以符合此处概述的原则的可读、可维护的方式执行其功能。因为很难预先设计出优雅的系统，所以随着项目的成熟，我们经常会精简和删除不必要的代码，尽可能不断地朝着这些目标迭代。

在任何可能的情况下，我们都会寻找以最少的失败点来解决现实生活中的重大问题的方法。这不是一个完美的过程，但我们一直在寻找更好的方法来简化事情，提高可靠性，同时降低缺陷的风险。简单的代码也更容易使用。

### 👩‍💻 可破解的

Chickensoft 项目公开了公共的 API，在我们的教程或自述 readme 中并不总是提到这些。虽然我们不建议您围绕这些 API 构建核心系统，但它可以在紧急情况下派上用场。我们相信开发人员应该有完成任务所需的自由，即使这意味着让我们的工具做一些让我们坐立不安的事情。很多时候，添加或改进功能是因为社区成员告知我们意外的用例，这些用例最终非常有用。

### 🪢 松散耦合

游戏引擎特定的软件包旨在尽可能避免接触游戏引擎。对引擎的调用更少，可以更容易地保持包的最新状态，并降低 C# 的托管环境和 Godot 的本机环境之间的封送成本。尽可能利用普通 C# 可以减少有 C# 经验的开发人员的学习曲线，并使我们能够利用该语言令人难以置信的能力，如记录类型和事件。

因为 Godot 的发布周期相当快，所以保持包的更新可以使我们的项目与最新版本的 Godot 一起使用，并使我们几乎在发布新版本的 Godot 时就可以集成即将进行的更改或修复。对于不间断的更改，我们的大多数软件包发布都是自动化的，确保我们的软件包在 Godot 更新时都可用。

# 令人愉快的游戏架构

https://chickensoft.games/blog/game-architecture/

游戏架构，就像所有的软件架构一样，随着项目的进行，往往会被忽视或遗忘。可扩展、令人愉快的生产代码库非常罕见，几乎是神话。

不一定非得这样：视频游戏开发困难并不意味着它一定会很痛苦。即使您重新设计核心系统并进行全面重构，您仍然可以实现一个健壮的软件体系结构，该体系结构可以与您的游戏相适应。由于架构是基于专家意见和开发者体验的，我们将借鉴其他软件架构的智慧，创建一个优先考虑愉快开发者体验的游戏架构。

在过去的几年里，我一直在为 Godot 和 C# 制作和维护十几个开源软件包。在利用这些包和本文中描述的固执己见的体系结构的同时，我能够在一两个月的业余时间内构建一个 3D 平台成型器演示。如果你愿意留下来，我很乐意与你分享方法论、基本原理，甚至演示本身。

> 演示中使用的大多数资产都是 GDQuest 创建的免费资产——请查看并支持他们的努力！

为什么我要处理像架构这样主观而模糊的东西？因为，在内心深处，我相信我们大多数人都不想为架构而烦恼。我们只想制作我们的游戏，并在游戏中玩得很开心。不幸的是，如果你不假思索地开始编写代码，你经常会发现越走越难。

## 💡 什么是软件体系结构？

你已经知道了，但为了完整性，我们无论如何都会定义它。

软件体系结构是围绕开发人员的团队代码目标设计的一组规则和实践。

这些做法是否真的实现了这些目标完全是另一回事。

我认为，一个好的架构是**有主见的，基于从过去满足相同（或相似）目标的项目中学习到的经验**，并**能很好地与特定堆栈的开发工具配合使用**：即，*一个良好的架构应该提供结构，基于经验，并易于实现*。

如果有两种同样好的方法来做某事，那么一个好的体系结构会选择其中一种作为推荐方法。好的架构拥抱集体主义，而不是个人主义。每个功能或组件的实现应与其他功能和组件类似。增加代码相似性使开发人员能够快速升级，相对容易地在功能之间切换，并减少他们必须记住的复杂细节的数量。

下面，我列出了一些常见的、高级的目标，一个好的体系结构可以围绕这些目标进行设计。这些目标的范围从整体组织实践到关于文件应该放在哪里以及代码应该如何格式化和找出程序错误（linted）的恼人细节。

1. **组织**：添加新功能时，我将代码和相关资产放在哪里？
2. **开发**：我如何知道要写什么代码来完成一个功能？
3. **测试**：如何为我的功能编写测试？
4. **结构**：如何获得功能所需的依赖项？
5. **一致性**：如何保持代码的格式？（是的，这很重要。如果你没有自动样式强制执行，你可能会遇到 IDE 的语言服务器试图应用自动修复程序的问题，这会让你的生活变得艰难。）
6. **灵活性**：当我需要重构一些东西时会发生什么？一个优化的体系结构将允许我们在不破坏其他功能的情况下彻底检修一个功能，使我们能够更快地迭代并保持代码的灵活性。

虽然体系结构不能牵着你的手，给你逐行的编码指令（这是你团队中高级开发人员的工作），但它至少应该让你知道，当你第一次从积压工作中解脱出来时从哪里开始。

一个好的体系结构应该有助于在您第一次开始使用一个新功能时防止写手，呃，代码者的阻塞。它应该消除对本应是平凡过程的猜测（比如构建一个新视图、其状态管理和测试），并将其转化为你可以在睡梦中做的事情（或通过一些片段实现自动化）。

为了实现上述崇高目标，我们将为我们的架构制定具体的要求，以实现我们的崇高目标。我们理想的架构应该…

1. 定义**抽象层**来组织代码模块。
2. 为代码库中的文件和资产提供一个**组织系统**。
3. 允许对代码的每个“单元”进行**隔离测试**。

为了实现这些目标，我们将从许多现有的模式和架构中汲取灵感，随意地融入我们喜欢的任何内容。

## 🍰 抽象层

我们理想的架构应该提供一个关于游戏整体结构的意见。在典型的可视化应用程序中，可能有视图层、业务逻辑/域层和数据层。

对于游戏，我们可以制作自己的类似图层。每一层都将对应于我们的代码库中的一种对象类型。

- 可视化层——脚本化游戏引擎组件。附加到游戏对象、Godot `Node` 脚本类等的 Unity `MonoBehavior`。
- GameLogic 层——游戏的肉和土豆，本身分为两个“子层”：
  - 视觉游戏逻辑层——驱动单个游戏引擎组件状态的状态机、行为树或其他有状态机制。
  - 纯游戏逻辑层——执行不特定于任何单个视觉组件的游戏逻辑的存储库类。
- 数据层——用于“较低级别”交互的各种客户端类，如网络和持久存储。

这三个抽象层合在一起，使我们能够批判性地看待我们的游戏。大多数代码应该很好地归入其中一层。

> 将游戏逻辑区分为视觉游戏逻辑和纯游戏逻辑，这让人想起了[干净架构 clean architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) 区分“企业范围的业务规则”和“特定于应用程序的业务规则。”

我们还将在我们的体系结构中引入一个额外的规定：一层中的对象只能与它们正下方的层中的物体强耦合。您可能会从分层体系结构的严格形式中认识到这一规则。

将对象限制为仅与其正下方层中的对象交互，可以防止同一层中的同级依赖关系（强耦合），以及“跳过”层，这将表明存在设计疏忽。

### 🎭 视觉层

视觉组件驱动我们在游戏引擎中看到的东西。它们有很多种风格，但在游戏引擎中往往非常相似。在 Unity 中，您可以找到应用于 GameObjects 的 `MonoBehavior` 组件。在 Godot 中，我们将 Godot 节点划分为子类，并将脚本附加到场景节点。这两个系统都允许我们表示引擎内的视觉组件。

大多数游戏开发者都会重申将视觉逻辑与游戏逻辑分离的重要性，并引用单一责任原则——那么，你到底是如何做到的呢？

状态机和行为树等机制通常用于将某个事物的“状态”与可视化它的代码分离。例如，可视化脚本可以创建一个状态机，并向状态机提供对其自身的引用，从而允许状态机在状态之间变化时“驱动”可视化对象。可视化脚本同样可以挂起对其状态机的引用，将相关的输入事件转发给它，使状态机有机会在发生任何事情时驱动它。

一个最佳的体系结构可能会在执行组件状态机或其他状态机制中的所有逻辑时，完全消除视觉游戏组件脚本的条件分支。

然而，现实生活并不总是那么美好：出于性能原因，对视觉组件本身进行一些检查，以决定是否值得将事件传递给状态机，这通常是有利的。如果你不这样做，像 C# 这样的垃圾收集语言可能会产生很多不必要的内存压力，这取决于你处理输入队列和内存分配的谨慎程度。

以下是可视化节点脚本的最小示例。例如，它完全是无状态的。唯一可能发生的事件——按下主菜单按钮——是通过使用信号转发的，允许有状态的祖先操作这个节点。

```c#
[SuperNode(typeof(AutoNode))]
public partial class WinMenu : Control, IWinMenu {
  public override partial void _Notification(int what);

  #region Nodes
  [Node]
  public IButton MainMenuButton { get; set; } = default!;
  #endregion Nodes

  #region Signals
  [Signal]
  public delegate void MainMenuEventHandler();
  #endregion Signals

  public void OnReady() => MainMenuButton.Pressed += OnMainMenuPressed;

  public void OnExitTree() => MainMenuButton.Pressed -= OnMainMenuPressed;

  public void OnMainMenuPressed() => EmitSignal(SignalName.MainMenu);
}
```

> 您经常会发现，许多节点可能是无状态的，只是在发生某些事情时发出信号。从可视化层中剥离尽可能多的逻辑是有益的，因为它允许有状态的父节点操作更简单的无状态节点。相比之下，谷歌的跨平台应用程序框架 Flutter 特别要求您区分 StatefulWidget 和 StatelessWidget。同样的区别也适用于 Godot，因为它们都共享一个可视化的、基于树的合成结构。

我们将广泛使用 SuperNodes 源代码生成器，它允许我们从一个类“复制”代码并将其“粘贴”到另一个类中（即编译时混合）。

在上面的例子中，`AutoNode` mixin（在 `SuperNodes` 术语中称为 `PowerUp`）在构建时自动将代码添加到我们的 `WinMenu` 类中，该代码将 `MainMenuButton` 属性连接到场景中具有相同唯一标识符 `%MainMenuButton` 的相应节点。像这样的小技巧可以帮我们省去大量容易出错的打字。

AutoNode mixin 来自 Chickensoft 的 [PowerUps](https://github.com/chickensoft-games/PowerUps) 系列。我们将在本文中使用其他一些 PowerUps，我们将在进行中对此进行解释。

### 🤖 GameLogic层

游戏逻辑只是指操纵游戏及其机制的代码，而不必直接担心游戏的可视化、网络化或持久化等其他问题。

在我们的体系结构中，我们区分了两种游戏逻辑。让我们看看每一个。

#### 🖼 视觉游戏逻辑层

如前所述，视觉游戏逻辑只是特定于单个视觉组件的代码（状态机、行为树或属于特定视觉组件的其他有状态机制）。

对于不仅仅出现在游戏中的视觉效果，它们可能应该引用行为树、状态机、状态图或其他表示其存在状态的有状态机制。

有状态机制可以通过接口松散地耦合到其拥有的组件，使它们能够通过调用其上的方法或产生视觉游戏组件绑定的输出来“驱动”其视觉组件。

*视觉组件的工作是闭嘴并看起来很漂亮*。越笨越好。一个理想的可视化组件只会将所有输入转发到它的底层状态机（或它正在使用的任何东西）。

##### 状态管理实践

对于游戏中一些更复杂的视觉组件，一个简单的状态机会很快失控。最有可能的是，您最终会使用 [状态图 statechart](https://statecharts.dev/)，这是一种分层状态机，可以帮助避免普通状态机的陷阱。

幸运的是，我已经创建了一个名为 [LogicBlocks](https://github.com/chickensoft-games/LogicBlocks) 的符合人体工程学的分层状态机实现，它允许您以编写普通 C# ~~类~~记录的方式编写状态。在游戏演示中，LogicBlocks 轻松处理菜单转换逻辑、整体暂停模式、玩家状态机和其他所有有状态组件。

我建议至少考虑使用 LogicBlocks，原因如下：

- 包括一个图片生成器，用于读取代码并帮助您将其可视化为 UML 状态图。
- 易于测试（抽象输入和输出）。
- 无需定义转换表。它的操作更像摩尔机器，比典型的基于过渡的方法更符合人体工程学。
- 正确实现嵌套状态的状态入口和出口回调。
- 正确地对输入进行排队和处理。
- 为状态提供一个黑板——一个共享的数据存储。
- 包括符合人体工程学的绑定系统，使您能够轻松地将视觉组件与其状态同步。
- LogicBlocks 可以将输入添加到自身，允许它们启动后续的状态更改。

下面是游戏演示中的 `InGameUILogic` 状态机。这是一个非常简单的状态机——它只有一个订阅 `AppRepository` 的状态（有关详细信息，请参阅下一节），并在硬币数量变化时产生输出。

```c#
public partial class InGameUILogic {
  public record State : StateLogic, IState {

    public State(IContext context) : base(context) {
      var appRepo = context.Get<IAppRepo>();

      OnEnter<State>((previous) => {
        appRepo.NumCoinsCollected.Sync += OnNumCoinsCollected;
        appRepo.NumCoinsAtStart.Sync += OnNumCoinsAtStart;
      });

      OnExit<State>((next) => {
        appRepo.NumCoinsCollected.Sync -= OnNumCoinsCollected;
        appRepo.NumCoinsAtStart.Sync -= OnNumCoinsAtStart;
      });
    }

    public void OnNumCoinsCollected(int numCoinsCollected) {
      Context.Output(new Output.NumCoinsCollectedChanged(numCoinsCollected));
    }

    public void OnNumCoinsAtStart(int numCoinsAtStart) {
      Context.Output(new Output.NumCoinsAtStartChanged(numCoinsAtStart));
    }

  }
}
```

同时，`InGameUI` 的实际 Godot 节点绑定到状态机的输出，每当硬币数量变化时都会更新 UI。

```c#

[SuperNode(typeof(AutoNode), typeof(Dependent))]
public partial class InGameUI : Control, IInGameUI {

  // ...

  public void OnResolved() {
    InGameUIBinding = InGameUILogic.Bind();

    InGameUIBinding
      .Handle<InGameUILogic.Output.NumCoinsCollectedChanged>(
        (output) => SetCoinsLabel(
          output.NumCoinsCollected, AppRepo.NumCoinsAtStart.Value
        )
      )
      .Handle<InGameUILogic.Output.NumCoinsAtStartChanged>(
        (output) => SetCoinsLabel(
          AppRepo.NumCoinsCollected.Value, output.NumCoinsAtStart
        )
      );

    InGameUILogic.Start();
  }

  public void SetCoinsLabel(int coins, int totalCoins) {
    CoinsLabel.Text = $"{coins}/{totalCoins}";
  }

  // ...
}
```

#### 🎰 纯游戏逻辑层

“纯”游戏逻辑包含了游戏的“领域”。纯游戏逻辑层中的组件通常是存储库，它们通常只是普通的老 C# 类。存储库负责执行危害游戏域的规则。

##### 国际象棋的领域

在国际象棋中，如果这样做不会让国王被将军，那么车可以吃其路径上的任何一块棋子。车还必须停在吃子发生的位置。“吃子”的概念是国际象棋特有的规则，因此存在于国际象棋的“领域”内。

因为吃子不仅仅涉及一个棋子，所以它不能在视觉游戏逻辑层中干净地实现。相反，车的状态机可能会意识到它被引导来吃一个子，然后调用存储库的方法来尝试吃子。如果允许车吃子，存储库将执行吃子，触发一个新被吃的棋子已经订阅的事件。被吃的棋子将它自己从棋盘上移除，存储库可以向车的状态机返回成功指示符。

##### 制作存储库

在游戏演示中，我们有一个 `AppRepository`，它允许我们处理整个应用程序的游戏逻辑。由于收集硬币不仅仅影响一个视觉组件，并对您如何赢得游戏负责，因此我们在 `AppRepository` 中处理硬币收集。

```c#
/// <summary>
/// Pure application game logic repository — shared between view-specific logic
/// blocks.
/// </summary>
public class AppRepo : IAppRepo {
  // ...

  public void StartCoinCollection(ICoin coin) {
    _coinsBeingCollected++;
    _numCoinsCollected.OnNext(_numCoinsCollected.Value + 1);
    CoinCollected?.Invoke();
  }

  public void OnFinishCoinCollection(ICoin coin) {
    _coinsBeingCollected--;

    if (
      _coinsBeingCollected == 0 &&
      _numCoinsCollected.Value >= _numCoinsAtStart.Value
    ) {
      OnGameEnded(GameOverReason.PlayerWon);
    }
  }

  // ...
}
```

为了简洁起见，我们省略了很多内容，但您可能已经明白了：每当硬币检测到与玩家发生碰撞时，它都会向其状态机发送一个事件，状态机会启动硬币收集动画，并告诉 `AppRepository` 正在收集硬币。当动画完成时，它会告诉 `AppRepository` 它已经完成了收集。

`AppRepository` 跟踪收集的硬币数量，然后启动一个事件以结束游戏。其他视觉组件上的其他状态机通过事件订阅游戏，根据需要处理清理或转换到其他屏幕。

##### 游戏中的数据流

一个好的状态机、行为树或其他状态实现应该能够订阅存储库中发生的事件，以及从它们所属的可视化组件接收事件和/或查询数据。

您可以想象数据从拥有它的可视化组件向下流入状态，并从需要广播事件的*游戏逻辑存储库向上冒泡*。

如果所有这些听起来都很熟悉，那可能是因为它是一种反应式（如 ReactiveX 或 rx）编码风格。或者，您可能使用了事件总线——另一种类型的松耦合、可观察的系统。

> 我倾向于把反应式代码想象成胶水：它非常强大、混乱，而且无处不在——所以要谨慎使用！如果你曾经试图向初级程序员解释将元素压缩在一起的多个链式事件源转换器，你就会知道这是多么棘手。在未来的 6 个月里，这对你自己来说也很棘手。

为了方便起见，我使用了一个名为 `AutoProp` 的小反应实用程序，它的灵感来自 C# 的内置事件和观察程序。它或多或少与 C# 观察者相同的 API，但进行了一些调整以更符合人体工程学。

```c#
  public IAutoProp<bool> MyValue => _myValue; // expose read-only version
  private readonly AutoProp<bool> _myValue = new AutoProp<bool>(false);
```

为了保持理智，我们可以创建特定功能的游戏存储库。这些存储库可以提供给任何游戏组件的状态机制，允许它订阅该存储库提供的事件。由于视觉游戏逻辑层直接存在于纯游戏逻辑层之上，因此只允许状态机制与存储库交互并订阅存储库。

### 💽 数据层

数据层表示应用程序中的各种数据客户端，如网络客户端或文件客户端。在许多情况下，游戏引擎本身就足够了。

因为数据层是应用程序的最底层，所以域层中的存储库（您的纯游戏逻辑）通常会调用数据层上的各种方法，通过各种渠道发送和接收所需内容。与订阅存储库的状态机一样，存储库本身也可以订阅来自数据层的传入数据，在游戏中发生相关事件时调用自己的事件，允许所有相关的状态机接收更新，从而更新其视觉组件。一路上都是乌龟。

我没有在游戏演示中实现游戏保存或加载，所以我还没有一个例子可以展示。我正在开发的下一个 Chickensoft 软件包有望帮助减少实现版本化游戏保存系统的工作量，所以请抓紧时间。

## 💉 依赖注入

一旦你了解了所有你需要的东西，你就必须弄清楚如何获得它。我们知道我们的应用程序将由视觉组件、状态管理机制、存储库和数据客户端组成。

在现实世界中，对对象的引用将通过每一层抽象向下渗透，直到它们定位在正确的位置。我们遵循分层体系结构中的“一层中的对象不应该知道任何其他对象，除了它们正下方的层中的那些对象”规则，但现实世界并不是那么干净。

事实上，以下是它的实际工作原理。

godot 节点脚本可以为其后代节点提供值。在我们的游戏演示中，`Player` 节点脚本将其逻辑块 `PlayerLogic` 提供给其子节点，允许它们绑定到其状态机。

然而，为了第一次获得这个值，每个后代都需要搜索他们的祖先，看看他们中是否有人提供了他们想要的值类型。

> 在除最深的树之外的大多数树中，执行祖先遍历是解决依赖提供程序的一种非常快速的方法。较深的树可以将值重新提供给较低的部分，从而缩短搜索距离。

不过，还有一个问题。在 Godot，最深的节点在它们的祖先之前就已经“准备好”了。这意味着依赖节点向其祖先提供程序节点请求提供程序不一定有机会初始化的值。

我们使用 [AutoInject](https://github.com/chickensoft-games/AutoInject) mixin 解决了这个问题，它本身利用 [SuperNodes](https://github.com/chickensoft-games/SuperNodes) 源代码生成器进行编译时混合。在后台，AutoInject 会临时向提供程序订阅所需的值。一旦提供程序表明其所有依赖项都可以使用，AutoInject 将确保依赖节点有机会进行自我设置。如果提供者在准备好（而且应该）后立即提供他们的值，那么所有这些都可以在同一个框架中发生，使一切都变得美好和确定。

要使用 AutoInject 提供值，我们的 Player 节点只需要为它想要提供的所有值类型实现 `IProvide<T>`。

```c#
[SuperNode(typeof(Provider))]
public partial class Player : CharacterBody3D, IPlayer, IProvide<IPlayerLogic> {
  public override partial void _Notification(int what);

  #region Provisions
  IPlayerLogic IProvide<IPlayerLogic>.Value() => PlayerLogic;
  #endregion Provisions

  // ...

  public void OnReady() {
    PlayerLogic = new PlayerLogic(/* ... */);

    Provide(); // Indicate the dependencies we provide are now available.
  }

}
```

通过利用 `Dependent` mixin，子代可以同样容易地从祖先节点访问依赖项。

`PlayerModel` 节点是 `Player` 节点的后代，它绑定到玩家状态机，并根据状态机的输出触发视觉动画。

```c#
[SuperNode(typeof(Dependent), typeof(AutoNode))]
public partial class PlayerModel : Node3D {
  public override partial void _Notification(int what);

  #region Dependencies
  [Dependency]
  public IPlayerLogic PlayerLogic => DependOn<IPlayerLogic>();
  #endregion Dependencies

  public void OnResolved() {
    PlayerBinding = PlayerLogic.Bind();

    PlayerBinding
      .Handle<PlayerLogic.Output.Animations.Idle>(
        (output) => AnimationStateMachine.Travel("idle")
      )
      .Handle<PlayerLogic.Output.Animations.Move>(
        (output) => AnimationStateMachine.Travel("move")
      )
      .Handle<PlayerLogic.Output.Animations.Jump>(
        (output) => AnimationStateMachine.Travel("jump")
      )
      .Handle<PlayerLogic.Output.Animations.Fall>(
        (output) => AnimationStateMachine.Travel("fall")
      )
      .Handle<PlayerLogic.Output.MoveSpeedChanged>(
        (output) => AnimationTree.Set(
          "parameters/main_animations/move/blend_position", output.Speed
        )
      );
  }

  // ...
}
```

### 😶‍🌫️ 简化的相关性

使用这样一个简单的依赖系统提供了许多优点。

- 道理很简单。
- 遵循 Godot 自然的基于树的结构。
- 避免了 Null 性问题。对象只在需要的时候、需要的地方存在。对象及其从属对象要么存在，要么不存在。不再检查您的依赖项，看您需要的东西是 null 或是具有 null 值。
- 声明式的编码风格，明确什么是负责什么的。

在幕后，AutoInject 负责查找提供程序、缓存、在等待提供程序提供值时订阅提供程序，以及在重新进入树时使缓存无效。我们所要做的就是说出我们正在提供什么或我们想要什么，并确保我们的后代被置于给予他们所需价值的祖先之下。

在游戏演示中，您只需搜索 `[Dependency]` 即可查看从祖先节点查找到的每个值。演示中的可视化节点广泛使用 AutoInject 来查找存储库。一旦解决了依赖关系，存储库就会传递给节点的状态机。

## 🧑‍🔬 测试

如果一个软件体系结构允许应用程序的所有单个“单元”（即网络客户端、存储库、状态和视图）相互独立地进行测试，那么它可能是一个不错的体系结构。毕竟，隔离测试就是“单元测试”的定义。

在单元测试中，“单元”是可以隔离测试的最小代码单元。这个烦人的递归定义很重要，因为架构的质量可以决定一个单元有多大。在理想的世界里，每个单元都属于一个——而且只有一个——抽象层。

从历史上看，在游戏引擎中对视觉组件进行单元测试几乎是不可能的。甚至 Unity 也承认，`MonoBehavior` 不能真正进行单元测试。

在 Godot，情况有所好转。您可以轻松地旋转场景的新实例，将其添加到测试场景中，并将 [GoDotTest](https://github.com/chickensoft-games/GoDotTest) 与 [GodotTestDriver](https://github.com/derkork/godot-test-driver) 一起使用来调用场景脚本的方法，并断言它按预期操作引擎环境，然后撤消它所更改的任何内容。

大多数人到此为止，非常高兴能够为游戏中的大多数事情编写测试。这很好，尤其是如果您不想测量代码覆盖率的话。

如果你无法满足测试的欲望，并且你发现自己想要准确地测量代码覆盖率，那么上面提到的方法就不太管用了。你很快就会意识到，旋转场景意味着它的任何子场景也会被旋转。如果这些子场景有脚本，它们就会被执行。这带来了大量其他系统，您需要模拟或交换假对象，但无法拦截场景的反序列化并交换所有内容。

到目前为止，您的简单“单元”测试已经成为超新星，并且正在跨越如此多的抽象层，以至于您的测试已经分解为集成测试。因此，您的测试最终会测试游戏中的所有其他内容，并且您的代码覆盖率变得毫无意义。

毕竟，只有在完全隔离的情况下测试每个系统，代码覆盖率才是准确的。否则，你会污染结果，无法轻易判断哪些系统尚未测试。

我能听到你在想“那么，单元测试有什么意义呢？测试这么小的‘单元’功能值得吗？”

是的，但不是因为我们想验证行为。这只是一个额外的奖励。

等等，什么？单元测试的目的不是验证行为吗？至少在我看来是正确的。

### 🧪 为什么要编写单元测试？

我对单元测试的感觉和我对高中老师坚持我们在代数课上“展示我们的运算过程”的感觉一样。这完全是一件苦差事，但它建立了专业知识，而且是正确的做法，即使你可以“在脑子里解决所有问题”（在代码方面你永远无法做到）。

家务就是这样。必需的我们必须保持我们的房子清洁，否则我们会受到虫害（bug infestation）的侵扰。同样，我们必须保持我们的代码干净，否则我们最终会得到——等等。你明白了。

如果你和我一样害怕打扫房子，你应该记住一条古老的规则：如果你必须做一些你不喜欢的事情，尽可能简单地做。为成功做好准备。当你打扫房子的时候，听听你最喜欢的音乐，并向自己保证之后你会出去吃饭。

因此，我认为单元测试非常重要的原因如下：

- **单元测试是“展示你的运算过程”**。它们确保每一行代码至少执行一次。
- **单元测试加强了一致性，并确保遵循您的体系结构**。如果你不遵循相同的体系结构，那么编写测试就会变得更加困难。-老实说：大多数测试一开始都是其他一些测试的复制/粘贴，所以你想把它最先做正确。
- **单元测试是一次性的**。如果你对某个东西进行了大量重构，那么删除测试并重新开始可能比重构测试更容易。另外，你最终会得到更好的测试，而且通常更快。如果你的代码写得相当好，这将是一个不成问题的问题。
- **单元测试充当活文档**。如果它们不是最新的，你的项目就不会编译。如果开发人员需要知道如何使用特定的代码，他们可以快速查看测试并获得所需的一切，因为代码的所有功能都将经过测试。
- **单元测试验证测试对象的状态和/或行为**。

事实上，单元测试验证您的代码按照您所说的去做，这只是锦上添花。如果代码是强耦合的，那么几乎不可能进行单元测试。仅仅是单元测试的存在就证明了代码并不可怕。

如果单元测试感觉重复，那是因为它们是重复的。根据测试主题的不同，您最终可能会测试一些行为和状态，这意味着一些测试最终可能会非常紧密地耦合。显然，通过一些实践或测试实用程序抽象，可以减少它们的耦合，但往往有很多测试基本上只是验证测试主题的实现。这很好，因为它们是一次性的。有了今天的人工智能辅助编码，你会没事的——我保证。

> 如果你只是在制作一个游戏的原型来获得正确的游戏性，你不会想写很多单元测试，如果有的话。单元测试往往会锁定很多代码，所以在制作实际游戏之前不要这样做。

最佳架构允许游戏通过单元测试实现 100% 的代码覆盖率。在某些情况下，性能关键代码可能耦合得如此紧密，以至于隔离测试太困难，而且一个单元跨越了多个抽象层。幸运的是，如果代码库中的所有其他内容都是模块化的，可以进行隔离测试，那么在违反规则的地方划出一点爆炸半径是完全允许的。这是一种“你必须知道规则才能打破规则”的事情。

假设你被说服了，现在让我们谈谈它是如何实际完成的。

### 🔬 实践中的单元测试

为了能够测试包含其他场景的 Godot 场景，我们需要能够在不反序列化实际场景文件的情况下创建场景的实例。幸运的是，Godot 允许我们重新构建我们想要的任何场景脚本——问题得到了解决。不过，不完全是这样。一旦我们将脚本添加到测试场景中开始测试它，如果它试图找到任何子项，它就会崩溃，因为它不会有任何子项。子实例来自 `.tscn` 文件，我们通常会在加载场景时反序列化该文件，但由于我们只是创建了脚本的实例，因此不会有任何子实例。

那很好。我们只需在脚本中添加一点功能（使用 mixin），即可模拟假节点树，并根据其期望的路径返回假节点。这工作得出奇地好，只是我们不能返回接口，这使得 mocking 变得不可能。我们不能返回接口的原因是 Godot 节点实际上没有任何对应的接口——它们只是类。

由于没有接口，我们必须为每个子节点创建一个实际的节点。这变得非常乏味，非常快，导致使用了大量的测试夹具(test fixtures)。

因此，为了解决这个问题，我创建了 [GodotNodeInterfaces](https://github.com/chickensoft-games/GodotNodeInterfaces)，它为每种类型的 Godot 节点生成接口和适配器。它还提供了访问子节点作为其自适应接口的替代方法，并与伪场景树系统一起进行测试。

我还没有用 GodotNodeInterfaces 进行过广泛的评测，因为我在使用它时每秒会得到数百帧。我想在编译器无法内联所有内容的情况下，可能会对性能产生轻微影响。

因为替代的子访问函数 GodotNodeInterfaces 提供了真实 Godot 节点的返回封装版本，所以存在分配开销。幸运的是，可以通过在创建节点脚本时存储节点引用来减轻分配开销，同时消除所有分配。

不过，如果你仍然担心表现，那就向我的一位个人英雄 Bob 说吧：

> 不过，我的经验是，使一款有趣的游戏变快比使一款快游戏变有趣更容易。一个折衷方案是保持代码的灵活性，直到设计稳定下来，然后删除一些抽象以提高性能。——[架构、性能和游戏 Architecture, Performance, and Games](https://gameprogrammingpatterns.com/architecture-performance-and-games.html)

看见总是有足够的时间来编写糟糕的代码！一旦你的游戏变得干净、稳定、有趣，我祝福你为了表现而破坏它。毕竟，“所有的魔法都是有代价的”，或者类似的话。

### 💁 测试提示

如果您还没有对 C# 进行过太多测试，那么您可能想熟悉一些基本知识，[包括 mocking](https://www.codemag.com/Article/2305041/Using-Moq-A-Simple-Guide-to-Mocking-for-.NET)。

在最后一节中，我们将演示上面概述的体系结构如何使我们能够相对容易地测试所有内容。

#### 🎨 理解视觉测试

为了测试视觉组件，我们必须非常仔细地对它们进行推理。如前所述，有两种方法可以实例化 Godot 节点进行测试。

1. 直接实例化视觉组件的场景脚本。我们避免在单元测试中这样做，因为在单一测试中执行多个单元会污染代码覆盖率。对于集成测试，当我们不测量代码覆盖率时，直接实例化场景就足够容易了。
2. 创建场景脚本的新实例，而不反序列化其场景。一旦添加到场景树中，就会破坏子关系，因为这些子关系并不存在，因为我们没有反序列化场景文件。我们可以通过使用 GodotNodeInterfaces 提供的假场景树系统来解决这个问题。

我们将始终使用方法 `#2`。

一旦我们有了要测试的节点实例，就有两种方法来测试它。

1. 我们可以将节点添加到测试场景树中，这使它能够操纵游戏引擎环境并占用世界中的空间。对于许多节点，我们必须在测试期间将它们实际添加到场景树中，以便能够验证它们与引擎的交互。
2. 或者，我们可以只调用节点上的方法，而不将它们添加到场景树中。如果方法中没有任何操作场景树或节点的其他属性（要求它位于树中），则此操作有效。对于许多节点，我们可以使用这种方法，因为它稍微简单一点。

#### 👷 设置测试

我们将使用 [GoDotTest](https://github.com/chickensoft-games/GoDotTest) 作为我们的测试运行程序。GoDotTest 为我们保证了一些不变量，帮助我们确定性地运行测试。

- 测试总是一次执行一个，按照它们在特定测试类的代码中出现的顺序执行。
- `Setup` 和 `Cleanup` 方法可以在每次测试前后调用，`SetupAll` 和 `CleanupAll` 方法可以在运行测试套件（即测试类）前后调用。
- 测试可以放置在测试场景中。
- 出于 CI/CD 的目的，可以从命令行运行测试。
- 测试从不并行运行。
- 测试及其设置方法可以是异步的，也可以不是异步的。

#### 🧬 两阶段初始化

我们经常需要**将脚本的初始化分为两个阶段**：一个阶段用于**创建属于该脚本的值**，如其依赖项、状态机和绑定，第二个阶段用于**使用这些依赖项或绑定**。如果我们不将初始化与使用分开，我们将无法在单元测试期间注入模拟值，因为这些值将被创建并在之后立即使用。

在实践中，以下是将初始化分为两个阶段的情况。

```c#
[SuperNode(typeof(AutoNode), typeof(Dependent))]
public partial class InGameUI : Control, IInGameUI {
  public override partial void _Notification(int what);

  #region Dependencies
  [Dependency]
  public IAppRepo AppRepo => DependOn<IAppRepo>();
  #endregion Dependencies

  #region Nodes
  [Node]
  public ILabel CoinsLabel { get; set; } = default!;
  #endregion Nodes

  #region State
  public IInGameUILogic InGameUILogic { get; set; } = default!;
  public InGameUILogic.IBinding InGameUIBinding { get; set; } = default!;
  #endregion State

  public void Setup() {
    InGameUILogic = new InGameUILogic(this, AppRepo);
  }

  public void OnResolved() {
    InGameUIBinding = InGameUILogic.Bind();

    InGameUIBinding
      .Handle<InGameUILogic.Output.NumCoinsCollectedChanged>(
        (output) => SetCoinsLabel(
          output.NumCoinsCollected, AppRepo.NumCoinsAtStart.Value
        )
      )
      .Handle<InGameUILogic.Output.NumCoinsAtStartChanged>(
        (output) => SetCoinsLabel(
          AppRepo.NumCoinsCollected.Value, output.NumCoinsAtStart
        )
      );

    InGameUILogic.Start();
  }
```

我们再次看到 `InGameUI` 视图，该视图显示用户在游戏中收集的硬币数量。请注意这两个独立的方法，`Setup()` 和 `OnResolved()`。第一种方法创建 `InGameUILogic` 状态机，而第二种方法绑定到状态机的输出并启动状态机。

由于上面的脚本使用 [AutoInject](https://github.com/chickensoft-games/AutoInject) 来解决依赖关系，我们可以利用 AutoInject 的一个鲜为人知的功能来帮助完成初始化过程。AutoInject 通常会在为脚本的依赖项找到的所有提供程序都指示它们提供了值后，对脚本调用 `OnResolved()` 方法，但它还有更多功能。

如果脚本上有一个 `Setup()` 方法，则该方法将在解析依赖项之后调用，但就在调用 `OnResolved()` 之前——如果且仅当——脚本的 `IsTesting` 属性设置为 false。不过，没有显示 `IsTesting` 属性——它隐藏在生成的文件中。

```c#
// Contents of generated file GameDemo.InGameUI_Dependent.g.cs

#pragma warning disable
#nullable enable
using System;
// ...

namespace GameDemo {
  partial class InGameUI : global::Chickensoft.AutoInject.IDependent
  {
  #region SuperNodesStaticReflectionStubs
    /// <summary>
    /// True if the node is being unit-tested. When unit-tested, setup callbacks
    /// will not be invoked.
    /// </summary>
    public bool IsTesting { get; set; } = false;

    // ...
```

通过使用两阶段初始化，我们能够在场景树中轻松地测试游戏组件。

我不会在这里显示完整的测试，但您可以查看 [Player](https://github.com/chickensoft-games/GameDemo/blob/main/test/src/player/PlayerTest.cs) 节点的测试。它利用了两阶段初始化的优势，防止在实际测试场景中运行时调用 Player 的 `Setup()` 方法，从而确保我们的模拟值被注入。

#### 🌲 伪造场景树

每个场景的根节点上应该只有一个脚本。

> **提示**
>
> 如果您发现自己需要将脚本添加到 Godot 场景中的非根节点，请不要添加。相反，在向节点分支添加脚本之前，请将其保存为自己的场景。
>
> 同样，如果您发现自己正在编写一个 Godot 节点脚本来操纵其子节点，那么您可能会遇到使用假节点树作为单元测试来测试该脚本的困难。为了获得最佳效果，请将脚本添加到子项，并要求它从脚本中操作自己的子项。一般的经验法则是“任何脚本都不应该比其子脚本更深地操作节点。”

确保每个场景的根节点上只有一个脚本，可以使用 [GodotNodeInterfaces](https://github.com/chickensoft-games/GodotNodeInterfaces) 提供的伪场景树系统轻松测试场景。通过将节点引用为接口并自动将它们与 [AutoNode](https://github.com/chickensoft-games/PowerUps) 挂钩，我们可以轻松地在隔离的情况下测试场景，而无需旋转整个子树。

在下面的例子中，取自游戏演示[对旋转金币的单元测试](https://github.com/chickensoft-games/GameDemo/blob/main/test/src/coin/CoinTest.cs#L47-L50)，我们通过创建硬币所需值的模拟版本来设置测试，然后调用 AutoNode 生成的 `FakeNodeTree` 方法，指示我们的硬币在提供的路径上使用节点的模拟对象，而不是尝试连接到真正的子节点。

```c#
  [Setup]
  public void Setup() {
    _appRepo = new Mock<IAppRepo>();
    _animPlayer = new Mock<IAnimationPlayer>();
    _coinModel = new Mock<INode3D>();
    _logic = new Mock<ICoinLogic>();
    _binding = CoinLogic.CreateFakeBinding();

    _logic.Setup(logic => logic.Bind()).Returns(_binding);

    _coin = new Coin {
      IsTesting = true,
      AnimationPlayer = _animPlayer.Object,
      CoinModel = _coinModel.Object,
      CoinLogic = _logic.Object,
      CoinBinding = _binding
    };

    _coin.FakeDependency(_appRepo.Object);

    _coin.FakeNodeTree(new() {
      ["%AnimationPlayer"] = _animPlayer.Object,
      ["%CoinModel"] = _coinModel.Object
    });
  }
```

#### 🥸 AutoInject 提供的模拟依赖项

在上面的例子中，我们还使用了通过 AutoInject 生成的 `FakeDependency` 方法。伪造依赖关系会阻止依赖节点在树中搜索提供程序——这在只测试脚本的测试场景中是不存在的。相反，我们正在测试的依赖节点在查找该类型的依赖项时只会使用提供的值，从而使我们能够轻松模拟依赖项。

## 🗂 文件结构和基于特征的体系结构

文件的组织方式应该有利于为代码库做出贡献的艺术家和开发人员。请允许我在这里建议基于特性（feature-based）的组织。

在基于特性的组织中，文件是按特性组织的，任何在某种共享目录中的特性之间共享的文件，通常称为公共文件 `common`。

在游戏演示中，我们非常简单地定义了特性。玩家四处奔跑收集硬币，在蘑菇上跳跃，并与物理环境互动。因此，蘑菇是一种特性，硬币也是一种特性等。你可以随心所欲地定义特性，但你可能想看看 Rollings 和 Morris 的《游戏架构与设计：新版》第17章（第482页）中的“代币思维（Thinking in Tokens）”一节。

在基于特性的体系结构中，您确实希望避免将特性强耦合在一起。如果你能保持它们的松散耦合，你可以很容易地添加和删除它们。

看看 Coin 特性的文件是如何实现的：

```
├── src
│   ├── coin
│   │   ├── Coin.cs
│   │   ├── Coin.tscn
│   │   ├── CollectorDetector.tscn
│   │   ├── audio
│   │   │   ├── coin_collected.mp3
│   │   │   └── coin_collected.mp3.import
│   │   ├── state
│   │   │   ├── CoinLogic.Input.cs
│   │   │   ├── CoinLogic.Output.cs
│   │   │   ├── CoinLogic.State.cs
│   │   │   ├── CoinLogic.cs
│   │   │   ├── CoinLogic.g.puml
│   │   │   └── states
│   │   │       ├── CoinLogic.State.Collecting.cs
│   │   │       └── CoinLogic.State.Idle.cs
│   │   └── visuals
│   │       ├── coin_model.glb
│   │       ├── coin_model.glb.import
│   │       ├── coin_normal.tres
│   │       ├── coin_roughness.tres
│   │       ├── coin_texture.tres
│   │       └── teleport_3d.gdshader
```

硬币所需的一切都位于硬币 `coin` 文件夹内。甚至状态机的状态也位于 `state/states` 子文件夹中。所有其他特性也以相同的方式组织起来，这使得开发人员可以很容易地介入并修复一些东西，即使她还没有开发该特性。艺术家也可以快速直观地知道他们可能需要在哪里投放一些更新的视觉效果。

我经常看到有人建议为每种类型的文件（如脚本 `scripts`、场景 `scenes`、纹理 `textures` 等）保留单独的文件夹。我的小脑袋发现这种组织模式很困难，因为相关文件被拆分到多个位置，而且每当你决定重命名某个文件时，很难记住去其他地方的顶级目录中重命名相应的文件。你还必须知道如何识别所有相关的文件，这本身就是一种记忆练习。

### 🪢 防止特征中的强耦合

为了防止我的特性彼此强耦合，我让它们通过接口进行交互。例如，任何实现 `ICoinCollector` 的东西都可以收集硬币。硬币并不在乎它是什么，它只知道它可以被任何实现该接口的东西收集。在这个游戏中，只有玩家。

为了方便起见，我只是在 `src` 目录中创建了一个文件夹，其中包含跨特性使用的接口。我本可以把这些放在一个通用目录中，但我决定为这类事情创建一个 `traits` 目录。

```
├── src
│   ├── traits
│   │   ├── ICoinCollector.cs
│   │   ├── IKillable.cs
│   │   └── IPushEnabled.cs
```

毫无疑问，您可以找到进一步的组织模式来改进这一点。当你这样做的时候，请打开我们的 Discord 并与我分享 ^-^。

### 🏛 测试的文件结构

游戏演示中所有内容的单元测试都是源目录中需要测试的内容的 1:1 镜像，每个文件都添加了添加的 `Test` 后缀。

```
└── test
    └── src
        ├── coin
        │   ├── CoinTest.cs
        │   └── state
        │       ├── CoinLogicTest.cs
        │       └── states
        │           ├── CoinLogic.State.CollectingTest.cs
        │           └── CoinLogic.State.IdleTest.cs
```

## 🥰 结论

感谢您阅读我关于游戏架构的文章（篇幅过长）。我不可能随心所欲地深入了解每一件事的细节，所以如果你有问题，请随时联系我。如果你找到了更容易、更好、更愉快的工作方式，请不要把它们保密。我很想吸收你的知识！

# 2024 年在 Godot 中使用 C#

https://chickensoft.games/blog/godot-csharp-2024

大约一年半前，与 Godot 和 C# 一起启动一个项目是一个勇敢的选择。Godot Discord 主服务器中一直有一个 C# 频道，但信息和教程（更不用说演示了）几乎不存在。

现在是 2024 年，让我们看看我们已经走了多远。

## 🥳 发生了很多事情

整个 2023 年，游戏开发界发生了很多事情。其中一些变化对使用 C# 的游戏开发者来说也是个大新闻：

- Godot 4 发布了！
- Unity 做了一些游戏开发者不喜欢的事情。
- Godot 的 C# 集成经过了彻底的检修，并从 Mono 移植到了 .NET SDK。
- Godot 4.2 中提供了对 C# Godot 游戏的实验性 iOS 和 Android 移动平台支持。
- Godot 论坛重新回归时尚。
- 由 Godot 的一些创始人创建的 W4 Games 公司又筹集了 1500 万美元。
- Godot 基金现在每月收入超过 60000 美元！

> **提示**
>
> 不确定是否要使用 C#？查看我们关于 [Godot 4 中 GDScript 与 C# 的博客](https://chickensoft.games/blog/gdscript-vs-csharp/)。

除了 Godot 不断增加的资金支持和知名组织更广泛的支持外，Godot C# 社区本身也在继续蓬勃发展。我们甚至在 Chickensoft 网站上观察到了一个新的用户活动基线水平，大约从 Unity 引入安装费的时候开始。

##### 🎮 完整的游戏演示

2023 年末，我们发布了一个开源的、经过充分测试的 3D 平台游戏演示，该演示是用 Godot 和 C# 使用令人敬畏的 GDQuest 资产构建的。我们也将在明年维护演示，使其保持最新状态，并在学习新事物时对其进行清理。

Gamefromsatch 也涵盖了我们的游戏演示——请在下面查看！

如果你想了解更多，请随时阅读我们最近关于[游戏架构的论文](https://chickensoft.games/blog/game-architecture/)——它对演示进行了分解，并详细介绍了其中的技术决策。但是，带上你的老花镜——这是一篇*很长的*文章。

说到 C# 的 Godot 游戏架构，现在还有 [Godot 架构组织建议](https://github.com/abmarnie/godot-architecture-organization-advice)存储库——去看看吧，也给它一颗星！

##### 🛠 制作游戏的力量

Chickensoft 现在拥有 14 个开源软件包，旨在解决您在使用Godot和C#时可能遇到的常见问题：

- [GodotEnv](https://github.com/chickensoft-games/GodotEnv)：在macOS、Linux和Windows上自动化和标准化Godot安装、版本切换和插件管理。
  GoDotTest:出于CI/CD目的，在本地或从命令行运行和调试自动化测试。
- [setup-godot](https://github.com/chickensoft-games/setup-godot)：在支持godot导出模板的macOS、Linux和Windows GitHub运行程序上安装和运行godot。
- [LogicBlocks](https://github.com/chickensoft-games/LogicBlocks)：易于使用，用于游戏的分层状态机。它甚至还为您生成代码的状态图。
- [AutoInject](https://github.com/chickensoft-games/AutoInject): 基于树的依赖项注入，使您可以轻松地将依赖项范围扩展到特定的Godot场景子树。
- [GodotGame](https://github.com/chickensoft-games/GodotGame)：使用Chickensoft最佳实践快速构建C#游戏的模板。
- …等等，都可以从我们的主页轻松访问。

## 🏆 2023 年的有趣亮点

### 🎨 TerraBrush

TerraBrush 是 spimort 用 C# 编写的 Godot 地图编辑器插件，它具有许多令人难以置信的地图编辑功能。一定要给它一颗星，并在你的下一个 3D 项目中试用！

### 🍰 图层生成器

Anton 发布了 GodotLayersSourceGenerator，它将生成冲突层名称的映射。他还更新了 BinaryBundle，一个用于网络代码的 C# 序列化生成器。

> **提示**
>
> 如果您正在寻找更多的 C# 生成器，请查看 GodotSharp。SourceGenerators 项目：它有用于场景树、输入映射和大量其他内容的生成器。

### 📺 任意减色与调色板有序抖动

如果你想让你的游戏更复古一点，可以看看最近发布的 Mark 的任意色彩减少和调色板有序抖动着色器。以下是应用于伪等轴测 3D 场景的视频：

### 🌉 Unidot 导入器

想把 Unity 的资产带过来吗？现在，您可以使用 Unidot Importer 轻松完成这一操作——它将自动将您的 `.unitypackage` 资产转换为 Godot `.tscn` 场景文件！

## 🐤 一个开源社区

如果你正在将 Godot 与 C# 一起使用，或者有兴趣这样做，你就不再孤单了！我们中的许多人都在积极努力，通过共享我们创建的工具、文档和游戏，与 Godot 和 C# 一起创造一个更好的游戏开发未来。我们也很想见你！

> **注意**
>
> Chickensoft 是一个草根社区和开源组织，致力于通过 C# 进一步使用 Godot。我们很高兴现在有一个超过 1000 名成员的社区，在过去的一年里，人们慷慨地为我们的开源软件包贡献了许多错误修复和功能。来打招呼！

# Godot 能兑现诺言吗？

游戏引擎公司 Unity 再次因冒犯用户而臭名昭著。这一次，他们宣布，对于收入超过 20 万美元的游戏，每次安装费为 0.20 美元。当然，他们不愿意分享如何确定什么是有效安装。

## 💔 所有人都喜欢？

Unity 最近的现金抢夺也并不意外：这只是一系列不受欢迎的决定中的最新违规行为。如果你错过了，以下是世界上最受欢迎的游戏引擎的进展：

- 在苹果广告跟踪发生变化后，市值损失了 50 亿美元。
- 解雇了大量员工。
- 试图删除自己的论坛，但在激怒了社区后，最终放弃了。
- 与一家知名的广告软件公司合并。
- 取消了他们自己的内部游戏项目 Gigaya，称其“在当前阶段需要彻底清理和优化”。
- 收入 20 万美元后，每次安装收费 0.20 美元。

这就是过去一年半发生的事情。

就我个人而言，我不知道为什么在游戏引擎市场占据绝大多数份额的公司想在他们把它全部烧掉的时候发挥作用。我想我们不可能都有正常的消遣。

一些人猜测，Unity 领导层正在玩 4D 象棋，并将取消这些变化，留下版税或更高的价格，相比之下，这些价格似乎更容易接受。或者他们现在只关心企业客户，或者希望每个人都在游戏中乱放广告。不管怎样，没有人确切知道。老实说，这并不重要——一旦信任的围栏被打破，开发商就会开始走向更绿色的牧场。

## 😴 Godot 一直在做什么？

Godot，由于其规模和多年来的流行，在某种程度上已经成为 Unity 或 Unreal 之外的游戏引擎的事实选择。不过，这并不重要，因为许多工作室从未认真考虑过。使用 Godot 很难找到开发人员的工作。

我怀疑这种情况正在改变。虽然每个人都在使用专有工具，但 Godot 团队一直在努力工作。他们发布了一个重要的新版本 Godot 4，它极大地改进了代码库，为开发 AAA 游戏所需的缺失功能铺平了道路。既然基础已经打好，工作完成只是时间问题。

C# 的支持也有了很大的提高。Godot 4 将运行时从 Mono 转移到 .NET SDK，为更紧密的集成和更快的开发周期打开了大门。事实上，Godot 4 的最新版本正在测试 Android 平台对 C# 的支持，iOS 和 Web 支持计划在 .NET提供了所需的正确基础设施时推出。

## 💖 Godot 的承诺

Godot 承诺成为“你一直在等待的免费开源引擎”。如果你看看创作者 Juan Linietsky 多年来一直在说的话，你会发现一个理想主义的承诺，即一个完全免费和开放的游戏引擎——一个你不必担心谁会试图从你那里拿走游戏利润的世界。

他还承诺在继续改进 3D 系统的同时，照顾那些叛逃到 Godot 的 Unity 用户。

与此同时，当我联系到 Godot 时，Godot 团队的执行董事告诉我，他们希望雇佣一名全职人员来完成 Godot C# 集成。唯一阻碍他们的是资金。

我不能代表任何人说话，但我相信 Godot 团队。仅用 C#，他们就修复了无数的集成错误，包括我个人提交的至少一两个。这只是我一直关注的引擎的一部分。Godot 已经收到了 2000 多人的贡献，与竞争对手相比，该团队以微薄的预算成功地筛选了无数的修复和请求。

Godot 团队不断地以很小的费用完成神奇的壮举。

## ✅ 接受挑战

不管 Unity 是否有意，我认为他们已经唤醒了一个沉睡的巨人。Godot 以前似乎对 Unity 持矛盾态度，但现在他们承诺会照顾 Unity 留下的用户。

所以，如果我是一个有数百万美元可投的大工作室，我会把它投给 Godot。自由软件无法停止。

# Godot 4 中的 GDScript 和 C#

几乎每天都有人问：“我应该用 GDScript 还是 C# 来制作我的 Godot 游戏？”

在 Godot Reddit、论坛、各种 Discord 服务器上，以及人们谈论 Godot 的任何地方，都给出了很多令人惊叹的建议——所以让我们一劳永逸地把它写下来！

在这篇文章中，我们将深入了解 Godot4.x 中 GDScript 和 C# 的优缺点，以及如何选择其中一种或同时使用它们的技巧！

> **信息**
>
> 如果您没有时间阅读所有这些内容，以下是您可能选择 GDScript 的原因：
>
> - ✅ 你是编码新手，或者你是一个业余爱好者。
> - ✅ 你是一个不介意动态类型的专家。
> - ✅ 您需要无缝的引擎集成和本机扩展支持。
> - ✅ 性能不是一个主要问题（通常不是游戏脚本的问题）。
> - ✅ 不与工具发生冲突。在引擎内部编写代码！
>
> 另一方面，以下是您可能选择 C# 的一些原因：
>
> - ✅ 您有使用 Java、Go 或 Dart 等托管语言的经验。
> - ✅ 您已经了解了 C#，可能是以前使用 Unity 或编写企业应用程序时了解的。
> - ✅ 您更喜欢静态类型。
> - ✅ 比起空白分隔的语法，您更喜欢大括号。
> - ✅ 您需要访问成熟的开发人员工具：linting、自定义分析器和源代码生成。
> - ✅ 您希望在不使用系统语言的情况下获得额外的性能。
> - ✅ 你需要访问的庞大的 .NET 包的库。
> - ⚠️ 您还不需要导出到 iOS 或 web。虽然 C# Android 导出正在最新版本中进行测试，但支持导出到 iOS 和 web 仍然是未来计划。您可以在此处跟踪进度。
> - ❌ 您不需要与任何 GDExtensions 集成。目前，Godot 不为 GDExtensions 生成 C# 绑定，这意味着您不能从 C# 调用 GDExtension。如果您愿意承担性能损失，可以通过从 C# 调用 GDScript 来解决此问题。

## 🤖 GDScript

正如您可能知道的，Godot 提供了自己的高级动态类型编程语言 GDScript。虽然 GDScript 经常被拿来与 Python 进行比较，但我发现它的语法更友好，有一些可选的类型提示，也让人想起 TypeScript 或 Swift。

对于快速原型和实验，我通常只会使用 GDScript（或破解别人的）拼凑一个快速脚本，直到我得到我想要的。在几乎所有情况下，使用 GDScript 都更加简单快捷。

如果您碰巧能熟练使用 C++ 或 Rust，那么您可以为 GDScript 中无法执行的任何操作创建 GDExtension（或者在 GDScript 中执行太慢）。Godot 将为扩展生成绑定，允许您从 GDScript 调用扩展代码，而无需额外的工作。非常神奇！

为了进一步让这选择更甜蜜，Godot 4 大幅改进了 GDScript：它速度快得多，可以处理循环/循环依赖关系，并支持 lambda 函数。最重要的是，您观看的关于 Godot 的几乎每一个教程或视频都使用 GDScript。

如果你还没有被打动，我可能没有什么其他的话可以让你使用它。

### ☀️ GDScript 优点

- 🚀 难以置信的易于学习和良好的支持。
- 🤝 许多提供实际支持的大型友好社区。
- 📚 大量教程和视频。
- 🥳 支持Godot支持的每一个平台。
- ✨ 始终更新Godot的最新功能。
- 🔌 完美的本地扩展集成。
- 🪛 工具支持——您可以直接在 Godot 引擎的编辑器中编写 GDScript，也可以使用官方的 VSCode 扩展。您甚至可以获得用于格式化 GDScript 文件的 VSCode 扩展。

### 🌧 GDScript 缺点

那么 GDScript 有什么问题呢？真的不多，但我会在这里列出一些需要注意的事项：

- 💨 不一定像 C# 那样具有性能。当从 C# 调用 Godot 引擎时，由于编组的原因会带来性能损失，但 C# 本身的执行速度往往比 GDScript 快得多。
- 🔒 任何用 GDScript 编写的代码都是完全特定于 Godot 引擎的。这通常对游戏脚本来说不是问题（因为它们本质上不是很便携），但值得一提。
- ⬜️ 空格分隔的语法。如果你无法忍受 Python，或者只是非常喜欢大括号，那么再多的 GDScript 也无法抚慰你的灵魂。同样，如果您喜欢以空格分隔的语法，您会感到宾至如归。
- ⚡️ 不是静态类型的。虽然您可以指定类型提示来帮助进行错误检查，但它们充其量是可选的。对一些人来说，这是一个优势。对其他人来说，缺乏强制的静态类型是一个令人头疼的问题。

对于我采访过的大多数游戏开发商来说，这些都不是典型的交易破坏者。GDScript 拥有狂热的追随者是有原因的：它真的非常棒。既然你知道了它的优点和缺点，你就有信心选择它。

还是不相信？让我们来谈谈 C#。

## #️⃣ C#

虽然没有 GDScript 那么受欢迎，但 Godot 中的 C# 支持已经取得了长足的进步。在约 5000 名接受调查的用户中，只有约 13% 的用户表示他们正在使用 C# 构建 Godot 游戏。

### 🌧 C# 缺点

在我们走得太远之前，有几点值得重申：

- ❌ Godot 无法导出适用于 iOS 或 web 的 C# 游戏。
- ❌ 您不能直接从 C# 调用 GDExtensions。

如果这两种方法中的任何一种都是您项目的必备工具，那么您不应该使用 C#。除非你很乐观，相信这些缺点会在项目需要时得到解决，否则你应该使用 GDScript 或第三方语言集成。

> **信息**
>
> C# 功能强大得令人难以置信，可以让你挖掘海量 .NET 生态系统的包和工具，但这是有代价的。如果你准备冒险，不介意挑战，并且可以忍受上面提到的缺点，C# 可能非常适合你的项目。

### ☀️ C# 优点

因为 C# 是 23 年前首次出现的通用编程语言，所以很难充分赞扬它的优点。为了节省时间，我将在 Godot 游戏开发的背景下列出一些积极因素：

- 🚀 C# 是一种成熟的语言，背后有微软的全力支持。如果你曾经使用过 Java 或 Dart，你也会感到宾至如归。
- 🛠 令人难以置信的工具支持。想要创建一个具有自动修复功能的自定义分析器吗？源生成器？模板项目？你可以做到。
- 🧑‍💻 IDE 的选择：您可以使用 Visual Studio、JetBrains Rider 或 Visual Studio Code。
- 📦 整个 .NET 包生态系统。如果有一个 nuget 包可以解决你的问题，你可能会使用它。
- 🤝 官方 Godot Discord 中有一个非常有用的 C# 频道。
- 🐤 我们有一个 Chickensoft Discord 服务器，专门用于支持 Godot C# 社区。如果你遇到问题或只是想聊聊，请随时过来打招呼！

### 🎟 免费的东西

虽然用 C# 创建的 Godot 插件不多，但 Chickensoft 提供了许多经过良好测试的包来帮助您入门。每个项目最初都是我个人游戏项目的一部分，后来被分解成单独的包与社区共享。每个项目都经过了充分的测试，并且有 100% 的代码覆盖率（为了我自己的安心）。

想要快速创建一个已经设置了基本 CI/CD 和单元测试的 Godot 游戏吗？使用我们的 [`dotnet new` 模板](https://github.com/chickensoft-games/GodotGame)创建游戏。我们有一个[包模板](https://github.com/chickensoft-games/GodotPackage)，用于创建与 Godot 一起使用的 nuget 包。

需要将代码自动注入到脚本中的生命周期方法中吗？我们有一个[源代码生成器](https://github.com/chickensoft-games/SuperNodes)。[基于节点的自动依赖注入如何](https://github.com/chickensoft-games/AutoInject)？

我们甚至有自己的命令行工具 [GodotEnv](https://github.com/chickensoft-games/GodotEnv)，它将根据 `addons.json` 文件自动管理您项目的 Godot 插件，并允许您在开发插件时在本地进行符号链接。插件不再有 git 子模块！

如果你想从 GitHub 操作工作流中使用 Godot，你可以使用 [setup-godot](https://github.com/chickensoft-games/setup-godot) 直接在 macOS、Windows 或 Linux 运行程序上运行 Godot。

我们还有用于[在 Godot 中运行测试](https://github.com/chickensoft-games/GoDotTest)、在 C# 中创建基本[状态机](https://github.com/chickensoft-games/GoDotNet)、[日志记录](https://github.com/chickensoft-games/GoDotLog)和其他一些事情的包。

> **提示**
>
> Chickensoft 是一个开源组织——我们所有的产品都是免费的。我们欢迎社区的贡献和反馈！

## 😅 害怕承诺？

由于您可以在同一个项目中混合和匹配 C# 和 GDScript，因此您只需要选择在项目的大部分时间使用哪种语言。

> **提示**
>
> 由于大多数现有的 Godot 插件都是用 GDScript 编写的，因此如果您选择 GDScript 作为脚本语言，则不太可能需要从 GDScript 调用 C#。

如果您碰巧选择了 C# 作为主要的脚本语言，您可能需要偶尔从 C# 调用 GDScript，因为在 C# 中重写您可能需要的每个插件是不切实际的。虽然这可能不如将所有内容都保存在一种语言中有效，但在紧要关头它确实会有所帮助。

所以，如果你讨厌使用单一的语言，为什么不同时使用两种语言呢 [脚注 1.]？Godot 文档讨论了[如何在 C# 和 GDScript 之间架起桥梁](https://docs.godotengine.org/en/stable/tutorials/scripting/cross_language_scripting.html)。

## 🎁 总结

尽管 Chickensoft 致力于 C# Godot 社区，但 C# 并不一定是每个 Godot 游戏的正确选择。对于大多数人来说，GDScript 可能是最好的选择。

我想，如果你需要（或想）使用 C#，你内心深处就已经知道了。

最终，如果您决定开始冒险，并在下一款 Godot 游戏中使用 C#，我们很乐意在 Chickensoft Discord 中为您伸出援手，为您加油。不管怎样，我们都祝你好运，希望能收到你的来信！😀

> **信息**
>
> 如果你对我在做什么感兴趣，欢迎你在 Mastodon 上关注我，或在 Discord 上联系我。

1. 实际上，有很好的理由将大部分代码库保持在一种语言中：一致性、易于重构、降低增加贡献者的障碍等等。↩

# Godot 和 C#：一种可行的 Unity 替代

Godot 是 Unity 的一个可行的替代品——不仅对早期采用者来说，对整个技能范围的游戏开发者和艺术家来说也是如此。

该引擎提供了明显更好的开发体验（通过基于文本的资源）和快速、响应的用户界面。我们将在博客的其余部分为这一声明辩护，并解决人们对 Godot 的普遍担忧。

在过去的几个月里，我从感兴趣的用户那里听到了几十个关于 Godot、它提供的 C# 支持以及该引擎的未来的问题。需要注意的是，我并没有正式加入 Godot Engine 组织。然而，我已经与一些核心引擎开发人员和贡献者进行了交谈，我想一劳永逸地平息反对 Godot 和 C# 的争论。

有很多事情要报道，而且都是好消息——所以让我们深入了解吧！

> 无关：此博客已正式离开 Medium！[脚注 1.]

## 🎇 Godot 的大年

如果你没有盯得太紧，你可能错过了一些新闻！Godot 4 现在处于测试阶段，它推出了一些令人印象深刻的新功能：

- Vulkan 渲染器
- 大型开放世界的符号距离、基于场的全局照明（SDFGI）
- GPU 光照贴图
- 自定义天空着色器
- 自动生成的 LOD（详细级别）网格
- .NET 6 支持
- 修改的着色器语言
- GDScript 的循环依赖项支持
- …以及无数其他变化

最重要的是，通过从 mono 迁移到对 .NET 直接的集成支持，C# 支持已经彻底改变。我们稍后再谈。

### 压倒性的支持

Godot 继续得到社区的大力支持。Godot 的创造者 Juan Linietsky 描述了 Godot 如何遭遇尽可能好的问题：

> 我们有太多的人在做事情的时候非常高效，非常好。[脚注 2.]

从本质上讲，贡献者的绝对数量（GitHub 上有 1800+ 人）几乎可以保证在任何特定时刻都在开发任何特定的功能。

在 Patreon，Godot 现在每月收到超过 15000 美元的捐款。自从我上次在夏天检查以来，每月增加了 2000 美元。

Godot 子版块 reddit r/Godot 目前拥有 101000 多名会员，自夏季以来至少增加了 5000 名用户（可能在很大程度上是由于 Unity 的失误）。官方的 Godot Discord 目前拥有超过 50000 名用户。

## 💁‍♀️ 解决您的顾虑

在 Reddit 上（偶尔也会在其他地方），感兴趣的用户会问 C# 是否“准备好了”或是不是 Godot 的“一流”公民。答案很简单：**是的**。

如果你不相信我，请继续阅读。我们将回应每一个反对 Godot 及其对 C# 支持的常见论点。

### 资产商店在哪里？

当我告诉人们 Godot 是一个可行的 Unity 替代品时，这通常是我听到的第一个反驳，这是有充分理由的。Godot 没有资产货币化系统... *到目前为止*

当然，Godot 确实有一个官方的资产库，里面有 1500 多个资产，但它们都是免费的。🙁

我们大多数人通常会对免费资产感到兴奋，但当你是一名依靠出售资产养活自己的艺术家或开发商时，赠送你的产品是不可能的。你应该能够做你擅长的事情谋生，这才是公平的。

正如有人在 Reddit 上指出的那样，货币化需要大量的官僚努力。收取付款并负责付款处理是一项艰巨的工作。

2021 年，Godot 的创始人 Juan Linietsky 证实，付费资产市场即将建立。

Godot 团队最近宣布成立非营利的 Godot 基金会，称付费资产市场是其主要动机之一：

> 随着 Godot 的不断发展，我们的需求也在不断增长。Godot 的规模值得拥有自己的组织的灵活性和探索更广泛资金来源的机会。
>
> 这方面的例子包括众筹活动（如 Blender 或 Krita 做的），用户在资产库上出售资产（并将份额捐给 Godot 基金会）、销售商品和其他类型的资金的高度要求。

虽然这并不能解决今天的问题，但你可能可以利用现有的 1500 多个免费资产。

对于一些用户来说，访问大量资产是不可谈判的。在 Godot 的资产库成为一个繁荣的付费市场之前，这些用户不会使用 Godot。然而，对于大多数开发人员来说，我相信 Godot 比 Unity 等人提高了开发人员的生产力。这远远弥补了资产的减少。

例如：如果你正在创作自己的艺术品，或者从艺术家那里购买艺术品和模型，那么无论如何，你可能都在编写自己的自定义代码。为什么不在 Godot 做呢？每当编辑器决定扫描您的资产时，它不会连续挂 2 分钟，不像其他引擎那样，*咳咳*。

### C# 怎么样呢？

在研究 Godot 和 C# 时，人们经常会问“C# 是一等公民吗？”。我相信这个问题在 Godot 第一次引入 C# 时就流行起来了。像所有新特性一样，C# 支持最初是不完整的，文档也很差，但随着时间的推移，它得到了巩固。如今，Godot Docs 几乎提供了 C# 和 GDScript 中的每一个代码示例，Godot 3（LTS）中的 C# 支持非常健壮（robust）。

如果您正在寻找 C# API 文档，paulloz 将维护 Godot API 文档的 C# 版本。

重申一下，Godot 支持两种第一方编程语言：GDScript 和 C#。所有其他语言绑定都是非官方的第三方项目。

当被问及 Godot 中新的 GDExtension 支持是否会取代对第一方 C# 支持的需求时，neikeq（Godot C# 的核心贡献者之一）解释说，C# 支持将继续内置，因为通过原生扩展加载多个 .NET 程序集会很困难（如果可能的话）。

#### C#支持的未来

我通过 Discord 的私人信息向 neikeq 询问了几个关于 Godot 中 C# 的问题，在他们的许可下，我将在这里发布一些采访内容（为了清晰起见，经过了轻微编辑）：

> **我**：很多人对 Godot 持观望态度，因为他们不确定 C# 支持是否是长期计划的，或者他们可能因为过去缺乏文档而备受煎熬。你想让他们知道什么？
>
> **neikeq**：从长远来看，他们不应该担心 C# 的支持。今年有很多人对此感到担忧，因为最初 C# 没有包含在 Godot 4 的 alpha 版本中，但现在它已经存在了，很快它将被统一为 Godot 的单一版本。
>
> 对于 C# 支持的未来来说，最重要的因素之一是从 Godot 4 开始，它更容易维护。仍有改进的空间（例如，更改/添加编组类型现在需要做更多的工作）。但我们肩上卸下的工作量是巨大的。这些时间可以花在其他方面，比如解决问题。
>
> 希望在某些事情上也能少一些困惑。以前在运行时打印的编组（marshalling）错误现在是编译器错误。
>
> **我**：是因为有了新的源代码生成器，还是因为进行了其他更改，所以维护工作更容易了？
>
> **neikeq**：我们不再自己构建 Mono 运行时，这在 wasm、iOS 甚至 Android 等平台上有时尤其痛苦。以及必须维护其中一些平台的构建代码并确保其正常工作（如 iOS 的 AOT）。这一切都在官方 .NET 版本发布时一起转移到 MSBuild。诚然，我们还没有移动和 wasm 支持，但当时机成熟时，它将更容易实现。新的宿主 + 纯 C# + 源代码生成器也比我们以前使用Mono嵌入API的方法更容易维护（尽管正如我所提到的，编组在这方面需要改进）。
>
> **我**：对于那些担心 C# 支持会消失的人，有什么结束语吗？
>
> **neikeq**：我们无意取消对 C# 的支持，因为很多业内人士都告诉我们，C# 支持是采用该引擎的一个重要因素。

### 更大的 C# 生态系统

仍然对在开源游戏引擎上冒险持怀疑态度？请允许我通过展示一些很棒的 C# 项目来增加交易的趣味性。

我们这篇文章的特色图片来自 SatiRogue，一款由 TetrisMcKenna 制作的“回合制地牢爬行类 rogue-like RPG，用Godot3.x C# + RelEcs 制作”。该源代码在 MIT 许可下可在 GitHub 上免费获得。

以下是用 C# 编写的其他一些很棒的项目：

- Carnagion / GDSerializer
- derkork / godot-test-driver
- Byteron / RelEcsGodot

## 🐤 Chickensoft 免费提供的东西

Chickensoft 的第一年表现不错：最初是 Godot 的一个以 C# 为中心的粉丝俱乐部，现在已经发展成为一个由热情的包作者和游戏开发者组成的小社区。我们的社区成员帮助回答了有关 Godot 和 C# 的技术问题，共享了许多开源软件包，并提交了关于 Godot 引擎的多个错误报告（其中一些已经修复！）。

### Godot 4 准备就绪

我很高兴地宣布，**Godot 4 的所有 Chickensoft 软件包都已正式更新**！

通过在 `.csproj` 文件中添加一些 nuget `<PackageReference>` 标记，您可以免费获得[基于节点的依赖关系设置](https://github.com/chickensoft-games/go_dot_dep)、[日志记录](https://github.com/chickensoft-games/go_dot_log)、[自动测试](https://github.com/chickensoft-games/go_dot_test)和[状态机](https://github.com/chickensoft-games/go_dot_net)，并使用 Godot 4 运行！

> 所有的 Chickensoft 包都是狗粮包，这意味着我之所以构建它们，是因为每次创建新的游戏项目时，我都试图解决同样的问题。我从来没有完成过一个游戏，但至少我有一些工具。也许下次。。。

### 宣布 GodotEnv

[GodotEnv](https://github.com/chickensoft-games/GodotEnv) 是一个命令行工具，可以帮助管理 Godot 插件并从模板中快速创建新的 Godot 项目。

在学习 Godot 时，我一次又一次地遇到同样的头痛。当我试图让我的代码在游戏项目中可重复使用时，我意识到在我还在开发插件的时候，没有简单的方法可以让它们保持最新。同样，每当我创建一个新的沙盒项目时，我每次都必须将十几个左右的文件复制到新项目中。

GodotEnv 的插件管理系统允许您在自己的文件中声明依赖项（以防止 git 子模块的版本控制问题），而模板生成使您能够快速创建新项目，而不必每次都复制所需的所有文件。

#### 插件管理，简化

Godot 插件只是一个 git 存储库，里面有一个 `addons/your_addon_name` 文件夹。当用户安装您的插件时，该文件夹的内容（场景、脚本、艺术资产等）将被复制到项目文件夹的 `addon/your_addon_name`。由于插件是一个扁平的文件夹结构，人们通常认为在项目存储库中使用 git 子模块作为插件。我最初尝试了 git 子模块，发现很难在所有使用插件的项目中保持所有内容的最新。

> **信息**
>
> 在 Godot 中使用 C# 时，有两种重用代码的机制：插件和 nuget 包。
>
> 导入 nuget 包就像将它们添加到 Godot 项目的 `.csproj` 文件中一样简单。不幸的是，您无法真正从 nuget 包导入场景或其他资产。它们只适用于重用代码。
>
> 另一方面，插件允许您重用*任何东西*。

如果 git 子模块对你来说也太痛苦了，GodotEnv 允许你在 `addons.json` 文件中声明你的项目需要什么插件，这样它就可以为你安装它们。

GodotEnv 还允许您通过复制或符号链接到本地文件夹来安装插件。

```json
{
  "path": "addons",
  "cache": ".addons",
  "addons": {
    "godot_dialogue_manager": {
      "url": "https://github.com/nathanhoad/godot_dialogue_manager",
      "source": "remote",
      "checkout": "main",
      "subfolder": "addons/dialogue_manager"
    },
    "my_local_addon_repo": {
      "url": "../my_addons/my_local_addon_repo",
      "source": "local"
    },
    "my_symlinked_addon": {
      "url": "/drive/path/to/addon",
      "source": "symlink"
    }
  }
}
```

然后，您所要做的就是运行以下操作：

```shell
godotenv addons install
```

## 🎬 结论

Godot 生态系统提供了一个资产库、每月的游戏 jam 和众多的开发者社区。如果你在 Godot 中使用 C#，你可以在项目中使用 nuget 上的任何东西，解锁整个 C# 生态系统以及 Godot 所能提供的一切。无论你是在计划你的项目，还是在做最后的润色，都有一个完整的生态系统来支持你。Godot 应用程序可以在每个主要平台上发布，多家公司可以为希望在主机上发布游戏的开发者提供支持。

用 C# 制作 Godot 游戏是一种令人难以置信的体验，而且它只会越来越好。如果你想开始（或继续）你的游戏开发之旅，非常欢迎你加入我们在 Chickensoft 的开源社区。

如果你已经在用 Godot 和 C# 制作游戏，并希望你的项目出现在博客中，请与我们联系！

## 脚注

1. 在网站上而不是在 Medium 上托管博客可以让我集成自定义小工具：这是一个巨大的胜利。如果你喜欢这个网站，可以随意使用。此外，黑客新闻读者（迄今为止是最活跃的受众）往往会因为阅读量的限制而不喜欢 Medium。如果你是从黑客新闻（或其他任何地方）读到这篇文章的，欢迎！↩
2. 00:48:00 左右收听《开源游戏引擎的作用：Godot 和 O3DE》在“构建开放元宇宙” Podcast 播客上↩

# 是时候用 Godot 制作 C# 独立游戏了

你一直梦想着制作 C# 游戏，但引擎总是让它变得太难了——直到现在。

## C# 独立游戏开发世界的动荡

一段时间以来，C# 一直是游戏开发者的热门选择，最初在微软的 XNA 框架中流行起来，后来被 Monogame、Unity 和 Godot 等工具进一步普及。

Unity 经常被认为是 C# 游戏开发的事实引擎，最近因为裁员、威胁要删除论坛、市值减少 50 亿美元以及与知名广告软件公司 IronSource 合并而成为新闻焦点。Reddit 评论中充满了忠实的 Unity 用户，他们开始质疑 Unity 是否忘记了他们，评论从“也许我应该学习虚幻……”到“这就是你不公开的原因。”

需要明确的是，我不喜欢批评 Unity，我认为所有 Unity 员工都在失业是一种耻辱。乍一看，Unity 在支持的功能数量上是如此可笑地领先于 Godot，将两者进行比较似乎很滑稽。一个是行业巨头和世界上最受欢迎的游戏引擎，而另一个是由热情的开发者在空闲时间开发的免费的 30 兆字节程序。

从技术上讲，Unity 可以比 Godot 做得更多，至少在纸面上是这样。在实践中，Unity 需要用于 tweens、定时器和网络的第三方工具，所有这些 Godot 都包括开箱即用的工具。尽管如此，我还是认为这对我们绝大多数独立游戏开发商来说并不重要。这个博客的其余部分只是为了让你相信这个论点。

你是想用最新的 bug 技术制作出世界上最好看的游戏，还是想在制作游戏时真正享受乐趣？如果你同意这个问题的最后一部分，我想邀请你试试 Godot。如果你已经尝试过 Godot 一段时间并放弃了，我想请你再给 Godot 机会。现在可能比你意识到的要好。

## Unity 不再有趣

众所周知，Unity 使用起来很痛苦：它打开速度很慢，而且在你尝试工作时，它经常会暂停以重新扫描整个项目。如果你试图与其他几个人一起使用源代码管理，你必须更加努力地使用 Unity 独特的文件格式，让一切都变得更好。按照现代标准，Unity 的发展有时会有点倒退。

当你打开 Godot 时，它几乎是瞬间打开的。用户界面的大小恰到好处，所有控件都可以在几个简单的窗格中轻松访问，您可以根据自己的喜好重新排列。

在 Godot 中，一切都是由节点组成的。没有预制件、游戏组件或其他抽象概念可供学习。只是节点。场景只是一个节点树，以熟悉的配置格式保存为纯文本文件，您可以在文本编辑器中轻松阅读。需要快速编辑场景以修复对重命名或移动到 Godot 之外的文件的引用？只需在代码编辑器中打开它并修复路径即可。当您切换回 Godot 编辑器时，它会在您眨眼之前重新加载项目。源代码管理也没有什么困难：因为所有内容都是文本，所以所有内容都能正常工作。

Godot 还允许您完全控制 `.csproj` 文件，允许您根据需要设置依赖项和配置 MSBuild。想要使用代码生成器吗？你可以做到。定制 Roslyn 分析仪？去做吧。你自己的 nuget 包？确认.

## 使用 Godot 实际上很有趣

当你构建场景时，Godot 不会和你打架。制作场景感觉很像使用组合创建一个类，场景甚至可以从其他场景继承（使用另一个场景作为场景的根节点，可以从中继承并在编辑器和代码中覆盖其属性），从而可以表达您从面向对象编程中非常熟悉的模式。

“玩得开心”难道不是用 C# 制作游戏的全部意义吗？使用托管语言是为了让创建游戏变得更容易，而不是更难。*不要担心所有的位和字节，C# 会帮你处理好的*。可悲的是，当营利性游戏引擎公司决定将工具的货币化置于用户的幸福之上时，我们失去了这一点。Godot 的情况并非如此：制作 C# 游戏再次变得有趣起来。

## 但是 Unity 的资产商店呢？

“好吧，我想换 Godot，”你说，“但我需要 Unity 资产商店的高质量付费资产，因为我不是艺术家/音乐家/专业编码员等。”

不幸的是，付费资产商店是你必须做出的最大牺牲。虽然 Godot 资产库不能总是与 Unity 的付费产品相比，但它*免费*提供 1300+ 件作品。你见过人们在 Godot 制作的所有很棒的东西吗？

> Godot 资产库可能会收到捐款或付款，让创作者的作品得到奖励，但我还没有听到任何结论。如果是这样的话，预计在不久的将来会有更多的优质资产。

大多数人可能会同意，患有影响生活质量的可怕疾病退休比健康退休要糟糕得多。那么，你为什么要继续使用一个让你痛苦的游戏引擎呢？制作游戏应该很有趣！

如果只是 Unity 资产商店阻碍了你，我可能无法说服你给 Godot 一个机会。但是，如果你足智多谋，不介意做一点额外的工作，并且/或者你愿意移植你的脚本并将你的 3D 模型导入 Godot，你可能会对你所缺少的东西感到惊喜。

## 你是这个节目的明星

Godot 优先考虑开发人员体验。我认为文档中没有明确写过这一点，我也从未听过其他人这么说，但这就是我使用 Godot 时的感受。当然，它的功能比主流游戏引擎少，但它的“少数”功能是经过精心打磨和深思熟虑的，使用起来很愉快。当我使用 Godot 时，我感觉很特别。Godot 的文档内容详尽、文笔优美、解释性强。如果你真的陷入困境，你可以查看它的源代码（实际上我已经做过几次了，并弄清楚了）。一切都很正常，开箱即用！

你知道吗，像 Godot 4 的 `NavigationServer`（具有本地对象回避功能）这样的杀手级功能现在从 3.5 开始可用？您甚至可以在运行时计算导航网格。Godot 开发人员通过反向移植为 4.0 开发的一些最有价值的功能来证明他们对您的承诺。他们这么做是因为你——游戏开发者——是他们宇宙的焦点。

Godot 团队并不寻求商业上的成功。这与 Blender 的策略相同：为人们制定尽可能好的计划。他们再清楚不过了：Godot 团队希望你在制作游戏时玩得开心！

## “我会等到下一个版本。”

很多人坚持支持 Godot 4.0。要么他们在拖延，要么他们真诚地认为 Godot 不能做他们想做的事。对于一个大团队来说，这可能是真的，但对于我们大多数独立开发者来说——真的吗？你还不能因为 Godot 没有 LOD 就开始做*任何事情*？我很难相信这一点。

长期使用 Unity 的用户可能知道醒来时发现他们真正喜欢（或依赖）的功能被砍掉的感觉，因为 Unity 想以不同的方式赚钱，而不*仅仅是让开发者高兴*。

很有可能，当你成功突破 Godot 的极限时，一个新版本已经发布，它可以做得更多。

我们不再等待戈多了，你也不应该。是时候让你开心了。

## Godot 的 C#：2022 年我们的处境

Godot 中的 C# 支持自几年前首次引入以来已经取得了长足的进步。Godot 允许您使用 C# 10，这为开发人员带来了难以置信的体验（Unity 甚至不完全支持 C# 9）。

虽然 C# Godot 社区相当小（在对 Godot community Poll 2022 做出回应的约 5000 名用户中，约 14% 使用 C#），但我们已经能够创建插件管理器、测试框架、序列化程序、mod 加载器、日志记录、基于节点的依赖管理器、Steam 集成等等。

在 Reddit 上，r/Godot 拥有 90000 多名会员。官方的 Discord 已经超过 4.5 万人。如果有成千上万的人一直加入，你会有很好的同伴。Steam 上的大量游戏都是使用 Godot 发布的。在 Patreon，Godot 每月收入超过 15000 美元。

## Godot 中的 C#

用 C# 建立一个复杂的 Godot 项目可能有点棘手，尤其是如果你不熟悉 MSBuild 这个奇怪的地狱。尽管如此，社区还是帮助我完成了我想做的一切。

> 我花了很多时间记录如何在 Godot 中设置 C# 项目，特别是因为很多想在 Godot 中使用 C# 的人都是新手。如果你想要一些关于如何设置和构建项目的示例和文档，我强烈建议你为我的组织 Chickensoft 查看一些 GitHub 存储库。或者，您可以进入我们的 Discord 服务器，我们将很乐意提供帮助！

### 但是测试呢？

如果你是一个测试驱动的开发专家（或者只是热衷于测试），你可能想知道如何为你的 C# Godot 游戏编写测试。有一段时间，这非常困难，除非你将 XUnit 与 Rider 一起使用（它也有自己的挑战）。

测试不再难以设置。有多个库用于编写 C# Godot 代码的测试，包括 Chickensoft 的官方[测试框架 go_dot_test](https://github.com/chickensoft-games/go_dot_test)，它允许您从 VSCode 调试测试、收集覆盖率并从命令行运行测试。

### Godot C# 生态系统缺少什么？

虽然 Godot 对 C# 的支持确实令人难以置信，但生态系统对实用程序的支持相当少，尤其是 C# 的网络框架和深度编辑器集成。也没有像 Odin for Unity 这样的单一、直接的工具。如果你准备迎接成为早期采用者的挑战，晚上睡不着想着开源软件，你可能会为 Godot C# 世界创建下一个大而有用的工具。

虽然 Godot 在当前 3.x 版本中内置了令人难以置信的、易于使用的 RPC 网络支持，但至少据我所知，它不具备交换传输以使用 Steamworks 或其他消息协议的能力。这可能会在 4.0 中出现。

即便如此，我们目前正在为 Godot 构建我们自己的 C# 网络库，其灵感来源于 Mirror 和 GameObjects 的 Netcode，完全绕过了 Godot 的网络，适用于那些可能想要更自定义的网络方法或需要支持某些传输的人。我也会尽我所能，因为我在这件事上太力不从心了！

### 关于 Godot 中的 C#，我还应该了解什么？

与其他引擎一样，Godot 在其 C++ 层和 C# 层之间来回封送类型。并非所有类型都可以转换为 Godot 的类型之一，但这并不像你想象的那么大。对于大多数游戏逻辑，您可以按照通常的方式创建类、记录和结构，并且在 C# 层中一切都会正常工作。

如果需要将类型传递给 Godot 子系统或使用 GDScript 的节点，则需要确保所涉及的任何自定义对象都是继承了 `Godot.Object` 的 C# 类（或 `Godot.Reference`），因为这是 Godot 正确序列化和跟踪值的唯一方法（c++ 层使用引用计数，而不是垃圾收集）。您也可以使用 C# 的强类型事件，但如果您需要与节点事件接口，则应该使用 Godot 的信号系统。一般来说，比起 Godot 类型，我更喜欢普通的 C# 功能，以避免封送惩罚并利用 C# 的强类型。当我需要与 Godot 节点、GDScript 或任何期望 Godot 类型的东西接口时，我会采用 Godot 的做事方式。到目前为止，这对我来说非常好，我想你也会。

### 异步呢？

在 C# 的 Task 中使用 `async` 和 `await` 可能会让 Godot 有点头疼，尤其是如果你没有意识到在 C# 中执行异步 Task 的大多数方法都会启动一个新线程（或从任务线程池中回收一个线程）。一般来说，我建议尽可能避免异步，除非你有一个很好的方法来保持它的自包含性，并且只在绝对必要的情况下使用它，例如在加载系统或集成测试中（需要跨帧 `await`）。如果您无法逃脱异步，那么您可以始终使用 C# 事件与同步代码的其余部分进行接口，以使事情变得简单。

### C# 构造函数和 Godot

由于 Godot 旋转类的方式，您应该避免在 Godot 节点的构造函数中创建值，而是在 Godot 调用节点的 `_Ready` 方法时初始化值。如果你过早尝试这样做，你会在游戏中引入很多不稳定因素。由于 C# 没有 `late` 修饰符（Dart）或 `lazy`（Kotlin），您可以简单地将值初始化为 `null`（或者 `null!` 如果您使用的是 null 感知代码），然后在 `_Ready` 中完成字段初始化。

我知道这有点技术性，但了解这几件事应该会让你省去一些头疼的事情。这肯定会帮助我们的！

## 开源永远是赢家

Godot 可能永远不会成为主导游戏引擎，但我们相信，只要有足够的时间，开源游戏引擎总有一天会主导这个领域。Godot 优先考虑开发人员，当开发人员获胜时，其他人最终也会获胜。

那你还在等什么？当然不是戈多。制作你梦寐以求的独立 C# 游戏！我们将永远在 Discord 提供帮助！访问 Github 上的 Chickensoft！

# Chickensoft

## 👩‍🏫 关于Chickensoft

Chickensoft 是一个致力于 C# Godot 社区的开源组织。我们拥有一个 Discord 服务器，专门为使用 Godot 和 C# 编写游戏、应用程序和工具的开发人员提供支持。

根据 MIT 的许可，所有 Chickensoft 项目都可以免费用于个人和商业项目。有关更多信息，请参阅我们的许可证页面。

## 📖 这是什么？

Chickensoft 是许多开源项目的所在地。由于其中一些项目涉及面很广，因此它们的文档就托管在这里。你可以在主页上看到 Chickensoft 的所有项目。

此外，我们正在努力更好地记录通用 C# 和 Godot 的开发。想添加关于特定主题的注释吗？欢迎为开源的 Chickensoft 网站投稿！

## 🐤 为什么叫这个名字？

Chickensoft 一开始只是我的游戏开发项目的一个愚蠢的个人组织。在使用 Godot 制作游戏时，我最终创建了一些实用程序，使 C# 的开发变得更容易。现在这些项目都有了自己的生活，我已经放弃了发布游戏的尝试。如果出于某种原因，我真的发布了一款商业游戏，它将以不同的名字命名。🥲

## 🪦 一句忠告

对于所有的游戏开发者，我要提醒他们：**不要制作工具——制作游戏**。否则，你最终只会为可能（也可能）帮助他人制作游戏的工具编写文档。最坏的情况是，你可能会陷入编写整个引擎的黑暗深渊。

不幸的是，“不做工具”和“真正做游戏”对游戏开发者来说是难以下咽的药丸。游戏开发是出了名的困难，即使没有编写工具的诱惑。当你最终成功制作游戏时，我们将在社区 Discord 服务器上为你加油！

如果你仍然不听，请随意贡献。只要知道你正踏上一条充满未完成项目和破碎梦想的黑暗道路。😶‍🌫️

# Godot C# 安装指南

https://chickensoft.games/docs/setup

如果你有 .NET SDK 安装后，Godot 4 提供了非常好的开箱即用的开发体验——但如果您想配置环境以简化 IDE 集成和命令行使用，则需要遵循一些额外的步骤。

准备好用 Godot 和 C# 制作游戏了吗？让我们从确保您的开发环境准备就绪开始吧！

> 如果您在某一步上卡住了，或者想通知我们不正确或过时的文档，请在 Discord 上加入我们。

> **提示**
>
> 本指南专门针对 **Godot  4**——所有 Chickensoft 软件包都已正式迁移到 Godot 4。

## 📦 安装 .NET SDK

要使用 Godot 4，我们建议安装 .NET 8 SDK。

> **提示**
>
> 可以安装的多个版本 .NET SDK。C# 工具（通常）足够智能，可以根据项目的目标框架、`global.json` 文件和 Godot 中的其他设置来选择正确的版本。如果您在 SDK 解决方案方面遇到问题，请随时联系 Discord。
>
> 安装 .NET 6 SDK 和/或 .NET 7 SDK 可能也不会有什么坏处。有 .NET 6、7 和 8 将允许您运行各种 C# 项目和工具。

> **信息**
>
> 我们经常编写文件路径，如 `~/folder`。`~` 是主文件夹的快捷方式。在 Windows 上，`~` 扩展到类似 `C:\Users\you` 的内容。在 macOS 上，`~` 扩展为 `/Users/you`。在 Linux 上，`~` 扩展到 `/home/you`。例如，`~/Documents` 在 Windows 上扩展为 `C:\Users\you\Documents`，在 macOS 上扩展为 `/Users/you/Documents`，而在 Linux 上扩展为 `/home/you/Documents`。

- macOS
  - 在 macOS 上使用 Microsoft 提供的安装程序安装 .NET SDK。有关安装 .NET SDK 的详细信息，请参阅微软针对 Mac 的文章。
- Linux
  - 在Linux上安装 .NET SDK 时需要注意一些问题，所以请参阅微软对 Linux 的文章。
- Windows
  - 以管理员身份打开 PowerShell，然后使用 `winget` 安装 .NET 8 SDK：`winget install dotnet-SDK-8`（或 `winget upgrade` 以升级现有安装）。有关安装 .NET SDK 的详细信息，请参阅 Microsoft 针对 Windows 的文章或发行说明。
  - 您也可以使用 Microsoft 提供的安装程序安装 .NET SDK，或通过 Visual Studio 2022 社区版。

如果要安装 .NET SDK，您可以[在这里找到所有可用的下载](https://dotnet.microsoft.com/en-us/download/dotnet)。

这个 .NET SDK 安装程序和包管理器倾向于将其放置在每个平台上的标准位置——如果您手动安装，请确保记下安装位置。我们稍后需要。

## ⏳ 使用 Git 进行版本控制

您**绝对**应该使用版本控制系统来跟踪游戏的代码和资产：特别是 [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)。

> **危险**
>
> 🔥🔥🔥 出现错误，工具可能会意外清除文件，场景引用可能会被破坏——在开发的混乱中会发生糟糕的事情。
>
> **Git 允许您回到过去并撤消不需要的更改**，如果您希望开发不是噩梦般的，这是非常宝贵的😱. 它还允许您轻松地与他人协作，并将代码存储在 GitHub、GitLab 和其他与 git 相关的服务中。
>
> 虽然学习 git 可能会让人望而生畏，但作为一名游戏开发人员，保护你宝贵的时间和工作绝对是你的责任，而使用 git 是体验中的一个强制性部分，使你能够做到这一点。**游戏开发非常困难，所以不要让你的工作得不到保护，这会让你自己更加困难**。🔥🔥🔥
>
> 请务必将[“撤销 Git 中的更改”](https://www.atlassian.com/git/tutorials/undoing-changes)部分添加到书签中，以防止在下一次危机中出现恐慌。搞砸不是**如果**的问题，而是**什么时候**的问题——所以要做好准备。

正确地学习和使用 git 是一项在开发过程中逐渐积累起来的技能，但[基础知识并不太难](https://www.atlassian.com/git/tutorials/what-is-version-control)，使用 [Visual Studio Code](https://code.visualstudio.com/) 可以让你在大多数情况下不必真正接触命令行就可以做到这一点。

> **信息**
>
> 即使你已经在使用 git，但你并不完全适应它，也可以看看前面提到的 [git 初学者指南](https://www.atlassian.com/git/tutorials/what-is-version-control)——在我看来，这是最好的指南，也是我一直向初级工程师推荐的指南。对于任何你可能不确定的事情，你都可以直接进入[高级提示](https://www.atlassian.com/git/tutorials/advanced-overview)。

## 🖥 Shell 环境

让我们将 shell 环境设置为包含指向 .NET SDK 的环境变量。这将允许您从任何位置运行 `dotnet` 命令行工具。我们将使用它安装 GodotEnv 来管理我们的 Godot 安装，使 Godot 游戏开发比以往任何时候都更容易。

> **信息**
>
> **👩‍💻 我应该使用哪个外壳？**
>
> 为了保持一致性，Chickensoft 正式建议在每个操作系统上使用 bash shell，特别是如果你正在 macOS、Windows 和 Linux 上开发跨平台的游戏——一旦你的环境设置正确，使用 Godot 就很容易做到这一点。
>
> 由于 bash shell 默认情况下在 Windows 上不可用，您可以通过安装 git 来访问它，git 包括 git bash for Windows 应用程序。您还可以将 Windows 终端（在 git 安装程序中可以选择添加 Windows 终端配置文件）和 [VSCode 配置为默认使用 bash](https://stackoverflow.com/a/70407051)。
>
> Bash 有点深奥，但您可以[很快轻松地学习所需的 Bash 基础知识](https://linuxconfig.org/bash-scripting-tutorial-for-beginners)。或者你可以深入[阅读关于 bash 的整本书](https://tldp.org/LDP/Bash-Beginners-Guide/html/index.html)。

完成此操作后，我们将能够从终端运行 Godot，并为 Visual Studio 代码创建适当的启动配置。

- macOS

  - 如果 `~/.zshrc` 不存在，则需要创建它。

    > **提示**
    >
    > 要在 macOS Finder 中切换隐藏文件的可见性，请按 `Cmd + Shift + .`——它也适用于文件对话框！

    将以下内容添加到 `~/.zshrc` 文件中：

    ```shell
    # .NET SDK Configuration
    export DOTNET_ROOT="/usr/local/share/dotnet"
    export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Disable analytics
    export DOTNET_ROLL_FORWARD_TO_PRERELEASE=1
    
    # Add the .NET SDK to the system paths so we can use the `dotnet` tool.
    export PATH="$DOTNET_ROOT:$PATH"
    export PATH="$DOTNET_ROOT/sdk:$PATH"
    export PATH="$HOME/.dotnet/tools:$PATH"
    
    # Run this if you ever run into errors while doing a `dotnet restore`
    alias nugetclean="dotnet nuget locals --clear all"
    ```

- Linux

  - 如果 `~/.bashrc` 不存在，则需要创建它。将以下内容添加到文件中：

    ```shell
    # .NET SDK Configuration
    export DOTNET_ROOT="/usr/share/dotnet"
    export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Disable analytics
    export DOTNET_ROLL_FORWARD_TO_PRERELEASE=1
    
    # Add the .NET SDK to the system paths so we can use the `dotnet` tool.
    export PATH="$DOTNET_ROOT:$PATH"
    export PATH="$DOTNET_ROOT/sdk:$PATH"
    export PATH="$HOME/.dotnet/tools:$PATH"
    
    # Run this if you ever run into errors while doing a `dotnet restore`
    alias nugetclean="dotnet nuget locals --clear all"
    ```

- Windows

  - 在 Windows 中，当使用 Git 附带的 bash shell（Git Bash）时，您可以将 shell 配置放在 `~/.bashrc` 中。在文件中，添加以下内容：

    ```shell
    # .NET SDK Configuration
    export DOTNET_ROOT="C:\\Program Files\\dotnet"
    export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Disable analytics
    export DOTNET_ROLL_FORWARD_TO_PRERELEASE=1
    
    # Add the .NET SDK to the system paths so we can use the `dotnet` tool.
    export PATH="$DOTNET_ROOT:$PATH"
    export PATH="$DOTNET_ROOT\\sdk:$PATH"
    export PATH="$HOME\\.dotnet\\tools:$PATH"
    
    # Run this if you ever run into errors while doing a `dotnet restore`
    alias nugetclean="dotnet nuget locals --clear all"
    ```

> **信息**
>
> 取决于的安装 .NET SDK 方式，您可能需要也可能不需要将它们添加到 `~/.bashrc`（linux）或 `~/.zshrc`（macOS）中的路径中。你可以在 bash shell 中运行 `which dotnet`，看看它们是否已经在你的路径上了。如果是，请删除之前添加的 `export PATH` 行。如果不是这样，您应该使用 `DOTNET_ROOT` 指向您的 `dotnet` 根目录，如上所示。
>
> 确保 .NET SDK 的路径与此工具在特定系统上的安装位置相匹配，因为如果手动安装，它可能会有所不同。

## 🤖 安装 Godot

您可以使用 Chickensoft 的命令行工具 GodotEnv 在机器上本地管理 Godot 版本（以及在项目中管理 Godot 资产库插件）。

> **信息**
>
> 使用 GodotEnv 在您的系统上安装和管理 Godot 提供了许多优势：
>
> - ✅ 从Godot TuxFamily下载镜像自动下载、提取和安装任何请求的Godot 4.x+ 版本（支持或不支持 .NET）。
>
> - ✅ 自动管理系统上指向您要使用的 Godot 版本的符号链接。符号链接路径永远不会改变——只是它指向的版本。
>
>   在 Windows 上，维护符号链接需要管理员权限，这使得手动管理很麻烦。GodotEnv 与 Windows 的用户访问控制（UAC）集成，可在需要时自动请求管理员权限。
>
> - ✅ 添加一个指向符号链接位置的系统 `GODOT` 环境变量，通过脚本方便其使用。
>
> - ✅ 将 `GODOT` 指向的路径添加到系统的 PATH 中。让初始化 Godot 二进制文件变得轻而易举，只需运行 `godot` 即可打开 GodotEnv 管理的版本。
>
> - ✅ 跨平台和机器标准化安装位置，使与其他队友的协作更加容易。
>
> - ✅ 快速将系统 Godot 版本更改为任何已安装版本，并列出所有已安装版本。

要安装 GodotEnv，请运行以下操作：

```shell
dotnet tool install --global Chickensoft.GodotEnv
```

### 🦾 使用 GodotEnv 安装

您可以通过按此处显示的方式指定 Godot 版本来自动安装 Godot。

```shell
godotenv godot install 4.0.1
```

### 😓 手动安装

如果你不相信，你可以手动下载 Godot，并将其安装在任何你想安装的地方。

### 📍 Godot 安装路径

如果您使用 GodotEnv，Godot 版本将自动安装在以下位置：

- macOS

  - | 位置     | 路径                                                         |
    | -------- | ------------------------------------------------------------ |
    | 符号连接 | `/Users/{you}/.config/godotenv/godot/bin`                    |
    | 真实路径 | `/Users/{you}/.config/godotenv/godot/versions/godot_dotnet_{version}/Godot_mono.app/Contents/MacOS/Godot` |

- Linux

  - | 位置     | 路径                                                         |
    | -------- | ------------------------------------------------------------ |
    | 符号连接 | `/home/{you}/.config/godotenv/godot/bin`                     |
    | 真实路径 | `/home/{you}/.config/godotenv/godot/versions/godot_dotnet_{version}/Godot_v{version}-stable_mono_linux_x86_64/Godot_v{version}-stable_mono_linux.x86_64` |

- Windows

  - | 位置     | 路径                                                         |
    | -------- | ------------------------------------------------------------ |
    | 符号连接 | `C:\Users\{you}\AppData\Roaming\godotenv\godot\bin`          |
    | 真实路径 | `C:\Users\{you}\AppData\Roaming\godotenv\godot\versions\godot_dotnet_{version}\Godot_v{version}-stable_mono_win64\Godot_v{version}-stable_mono_win64.exe` |

> **注意**
>
> 所有 Chickensoft 模板和 VSCode 启动配置都依赖于一个名为 `GODOT` 的环境变量，该变量包含您要使用的 Godot 版本的路径。
>
> **GodotEnv 将自动更新您的环境变量**，通过更新 macOS 上的 `~/.zshrc` 文件或 Linux 上的 `~/.bashrc` 文件来以指向其符号链接，该符号链接又指向 Godot 的活动版本。在 Windows 上，GodotEnv 将自动尝试使用具有请求的管理权限的相关命令提示符命令更新环境变量。
>
> **❗️ 在为所有应用程序更新环境变量后，您必须注销并再次登录才能看到更新的值。**
>
> 如果您没有使用 GodotEnv，或者想再次检查变量是否存在，请确保您已按如下方式设置了环境变量：
>
> - macOS
>
>   - 在您的 `~/.zshrc` 文件中，确保存在以下内容。
>
>     ```shell
>     # This should be added to your ~/.zshrc file by GodotEnv automatically, but
>     # you can also add it manually and change the path of Godot to match
>     # your system.
>     export GODOT="/Users/{you}/.config/godotenv/godot/bin"
>     ```
>
> - Linux
>
>   - 在你的 `~/.bashrc` 文件中，确保存在如下内容。
>
>     ```shell
>     # This should be added to your ~/.zshrc file by GodotEnv automatically, but
>     # you can also add it manually and change the path of Godot to match
>     # your system.
>     export GODOT="/home/{you}/.config/godotenv/godot/bin"
>     ```
>
> - Windows
>
>   - Windows 有一个用于更新环境变量的可视化编辑器。请参阅[本文](https://github.com/sindresorhus/guides/blob/main/set-environment-variables.md#windows-7-and-8)。

如果是手动安装，请考虑将其放置在以下位置之一：

- macOS
  - 将 Godot 移动到 `/Applications/Godot_mono.app`。不管怎样，这就是你所有其他 Mac 应用程序的位置！
- Linux
  - 如果你使用的是 Linux，你可能对把它放在哪里有自己的看法。如果你不确定，你可以把 Godot 可执行文件（及其支持文件）放在用户文件夹中自己的文件夹中：`/home/Godot`。
- Windows
  - 在 Windows 上，您可以将 Godot 和任何支持文件放在 `C:\Godot\Godot_mono.exe` 中，或放在用户文件夹 `C:\Users\{you}\Godot` 中自己的文件夹中。

## ⌨️ Visual Studio Code

Chickensoft 的所有包和模板都是为与 Visual Studio Code（VSCode）配合使用而设计的。

您可以在此处下载 Visual Studio Code。

### 🔌 VSCode 扩展

至少，您需要 [`ms-dotnettools.csharp`](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp) 扩展。Chickensoft 还[推荐了一些其他扩展](https://github.com/chickensoft-games/GodotGame/blob/main/.vscode/extensions.json)，使开发更容易。

### 💾 Godot 和 C# 的 VSCode 设置

我们需要重新打开 OmniSharp——默认情况下，它不应该被关闭。

将 VSCode 设置作为 JSON 文件打开，然后添加以下设置：

```json
"dotnetAcquisitionExtension.enableTelemetry": false,
// Increases project compatibility with the C# extension.
"dotnet.preferCSharpExtension": true,
```

Chickensoft 还建议使用以下附加设置来获得愉快的 C# 开发体验：

```json
"csharp.suppressHiddenDiagnostics": false,
// Draw a line between selected brackets so you can see blocks of code easier.
"editor.guides.bracketPairs": "active",

"[csharp]": {
  "editor.codeActionsOnSave": {
    "source.addMissingImports": "explicit",
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  "editor.formatOnPaste": true,
  "editor.formatOnSave": true,
  "editor.formatOnType": true
},

// To make bash the default terminal on Windows, add these:
"terminal.integrated.defaultProfile.windows": "Git Bash",
"terminal.integrated.profiles.windows": {
  "Command Prompt": {
    "icon": "terminal-cmd",
    "path": [
      "${env:windir}\\Sysnative\\cmd.exe",
      "${env:windir}\\System32\\cmd.exe"
    ]
  },
  "Git Bash": {
    "icon": "terminal",
    "source": "Git Bash"
  },
  "PowerShell": {
    "icon": "terminal-powershell",
    "source": "PowerShell"
  }
}
```

最后，C# 的语义高亮显示有点奇怪，所以你可以通过添加这些颜色调整来解决这个问题：

> **C# 语义语法高亮颜色校正设置**
>
> ```json
> "editor.tokenColorCustomizations": {
>   "[*Dark*]": {
>     // Themes that include the word "Dark" in them.
>     "textMateRules": [
>       {
>         "scope": "comment.documentation",
>         "settings": {
>           "foreground": "#608B4E"
>         }
>       },
>       {
>         "scope": "comment.documentation.attribute",
>         "settings": {
>           "foreground": "#C8C8C8"
>         }
>       },
>       {
>         "scope": "comment.documentation.cdata",
>         "settings": {
>           "foreground": "#E9D585"
>         }
>       },
>       {
>         "scope": "comment.documentation.delimiter",
>         "settings": {
>           "foreground": "#808080"
>         }
>       },
>       {
>         "scope": "comment.documentation.name",
>         "settings": {
>           "foreground": "#569CD6"
>         }
>       }
>     ]
>   },
>   "[*Light*]": {
>     // Themes that include the word "Light" in them.
>     "textMateRules": [
>       {
>         "scope": "comment.documentation",
>         "settings": {
>           "foreground": "#008000"
>         }
>       },
>       {
>         "scope": "comment.documentation.attribute",
>         "settings": {
>           "foreground": "#282828"
>         }
>       },
>       {
>         "scope": "comment.documentation.cdata",
>         "settings": {
>           "foreground": "#808080"
>         }
>       },
>       {
>         "scope": "comment.documentation.delimiter",
>         "settings": {
>           "foreground": "#808080"
>         }
>       },
>       {
>         "scope": "comment.documentation.name",
>         "settings": {
>           "foreground": "#808080"
>         }
>       }
>     ]
>   },
>   "[*]": {
>     // Themes that don't include the word "Dark" or "Light" in them.
>     // These are some bold colors that show up well against most dark and
>     // light themes.
>     //
>     // Change them to something that goes well with your preferred theme :)
>     "textMateRules": [
>       {
>         "scope": "comment.documentation",
>         "settings": {
>           "foreground": "#0091ff"
>         }
>       },
>       {
>         "scope": "comment.documentation.attribute",
>         "settings": {
>           "foreground": "#8480ff"
>         }
>       },
>       {
>         "scope": "comment.documentation.cdata",
>         "settings": {
>           "foreground": "#0091ff"
>         }
>       },
>       {
>         "scope": "comment.documentation.delimiter",
>         "settings": {
>           "foreground": "#aa00ff"
>         }
>       },
>       {
>         "scope": "comment.documentation.name",
>         "settings": {
>           "foreground": "#ef0074"
>         }
>       }
>     ]
>   }
> },

## ✨ 创建 Godot 项目

Chickensoft 提供了一些 `dotnet new` 模板，帮助您快速创建用于 Godot 4 的 C# 项目。

现在您已经配置了环境（希望从那时起重新启动），您应该能够从终端使用 `dotnet` 工具来安装 Chickensoft 的开发模板。

```shell
dotnet new install Chickensoft.GodotGame
dotnet new install Chickensoft.GodotPackage
```

### 🎮 创建 Godot 游戏

GodotGame 模板允许您快速生成具有 VSCode 调试启动配置、测试（本地和 CI/CD）、代码覆盖率、依赖更新检查和拼写检查的游戏！

要创建一个新游戏，只需运行以下命令并在 Godot 和 VSCode 中打开生成的目录。

```shell
dotnet new chickengame --name "MyGameName" --param:author "My Name"

cd MyGameName
dotnet restore
```

🥳 终于——你终于准备好做游戏了！

### 📦 创建可重复使用的 Nuget 包

如果你想在项目之间共享编译的源代码，或者允许其他人在他们的项目中使用你的代码，你可以发布 Nuget 包。

使用 GodotPackage 模板可以设置具有连续集成、自动格式化、VSCode 调试器配置文件和预配置单元测试项目的包。

```shell
dotnet new --install Chickensoft.GodotPackage

dotnet new chickenpackage --name "MyPackageName" --param:author "My Name"

cd MyPackageName
/path/to/godot4 --headless --build-solutions --quit
dotnet build
```

在 VSCode 中打开新项目，并使用提供的启动配置来调试应用程序。

> **提示**
>
> 如果您需要共享代码**和**其他资源文件，如场景、纹理、音乐和任何其他非 C# 源文件，则应使用 Godot 资产库（Godot Asset Library）包。Chickensoft 的 GodotEnv CLI 工具允许您轻松地在项目中安装和管理插件。

# SuperNodes

[SuperNodes](https://github.com/chickensoft-games/SuperNodes) 是一个 C# 源代码生成器，为 Godot 节点脚本提供超能力。

### 🔮 C# 脚本的超级能力

许多编程语言允许您使用诸如 `mixin`、`traits` 甚至 `模板` 和 `宏` 之类的功能将一个类的内容与另一个类相结合。

C#没有这样的特性。😢

> **等等！默认接口实现如何？**
>
> 您可能想知道 C# 的默认接口实现功能。不幸的是，默认接口实现不能用于向类添加实例数据。
>
> 也就是说，您不能使用默认接口实现将字段添加到类中（而且在某种程度上，您不能添加属性实现，因为它们使用的是隐藏的字段）。
>
> 以下是微软对此的看法：
>
> > **注意**
> >
> > 接口可能不包含实例状态。虽然现在允许使用静态字段，但接口中不允许使用实例字段。接口中不支持实例自动属性，因为它们会隐式声明隐藏字段。

为了弥补 C# 中的这些缺点，SuperNodes 生成器允许您通过向任何普通 Godot 脚本添加 `[SuperNode]` 属性来将其转换为 `SuperNode`。将节点转换为 SuperNode 允许您：

- ✅ 将 PowerUps（本质上是 C# 的混合）应用到节点脚本中。
- ✅ 与 Godot 的官方源代码生成器一起使用第三方源代码生成器。
- ✅ 在运行时获取和设置脚本属性和字段的值，而不使用反射。
- ✅ 在运行时检查脚本属性和字段的属性和类型，而不使用反射。
- ✅ 使用共享运行时类型跨程序集检查超级节点。
- ✅ 仅使用源代码 nuget 包的 PowerUps。

制作 PowerUp 也很容易：只需用 `[PowerUp]` 属性标记另一个脚本类，然后将该 PowerUp 应用于 SuperNode。

```c#
namespace SimpleExample;

using Godot;
using SuperNodes.Types;

[SuperNode(typeof(ExamplePowerUp))]
public partial class ExampleNode : Node {
  public override partial void _Notification(int what);

  public void OnReady() => SomeMethod();

  public void OnProcess(double delta) => SomeMethod();

  public void SomeMethod() {
    var d = GetProcessDeltaTime();
    if (LastNotification == NotificationReady) {
      GD.Print("We were getting ready.");
    }
    else if (LastNotification == NotificationProcess) {
      GD.Print("We were processing a frame.");
    }
  }
}

// A PowerUp that logs some of the main lifecycle events of a node.
[PowerUp]
public partial class ExamplePowerUp : Node {
  public long LastNotification { get; private set; }

  public void OnExamplePowerUp(int what) {
    switch ((long)what) {
      case NotificationReady:
        GD.Print("PowerUp is ready!");
        break;
      case NotificationEnterTree:
        GD.Print("I'm in the tree!");
        break;
      case NotificationExitTree:
        GD.Print("I'm out of the tree!");
        break;
      default:
        break;
    }
    LastNotification = what;
  }
}
```

上面的脚本定义了一个名为 `ExampleNode` 的超级节点，该超级节点应用名为 `ExamplePowerUp` 的 PowerUp。

`ExamplePowerUp` 跟踪节点中发生的最后一个生命周期事件，允许 `ExampleNode` 访问 PowerUp 的 `LastNotification` 属性，就好像它是自己的一样，即使 `ExampleNode` 没有声明这样的属性。

由于源代码生成器的魔力，因此不会出现语法错误。一切都能正确编译，并支持静态类型！

### 🔘 SuperNodes

我们将把上面的例子分成几个小部分来解释发生了什么。

```c#
[SuperNode(typeof(ExamplePowerUp))]
```

可以为 `[SuperNode]` 属性提供一个参数列表。每个参数都可以指定一个 PowerUp 或一个表示生命周期方法挂钩的字符串（稍后将详细介绍）。PowerUp 是通过传递 PowerUp 类的类型来指定的，因此我们使用 `typeof` 来标识 `ExamplePowerUp` 的类型。它快速、简单，并且**在编译时工作**！

```c#
public partial class ExampleNode : Node {
```

您可能会从 Godot 中编写 C# 脚本中认识到这一点。这只是一个普通的 Godot 脚本类！

```c#
  public override partial void _Notification(int what);
```

不幸的是，所有 `[SuperNode]` 脚本都必须包含这个极其冗长的部分方法签名。

> **注意**
>
> 如果您忘记添加 `public override partial void _Notification(int what);` 对于您的 SuperNode 脚本，您将从 SuperNodes 生成器收到一条很好的小消息，提醒您使用正确的方法签名来执行此操作（因为我们都知道您可能不想记住这一点）。

为了让 SuperNodes 工作，它必须能够为 Godot 的 `_Notification` 方法生成一个实现。实现生命周期方法允许超级节点调用 PowerUps 和生命周期挂钩，以响应 Godot 节点中发生的任何生命周期事件。

> **注意**
>
> 如果您还需要脚本来实现 `_Notification`，只需声明一个具有签名 `public void OnNotification(int what)` 的方法，SuperNodes 将确保在调用 `_Notification` 时调用它。

您可能已经注意到，SuperNode 使用名为 `OnReady` 和 `OnProcess` 的方法，而不是覆盖 `_Ready` 和 `_Process`，它们在其他方面与 Godot 对应方法具有相同的签名。SuperNodes 生成器将在 SuperNodes 内部为每个 Godot 生命周期通知查找名为 `On{LifecycleHandler}` 的方法（有相当多），并调用具有相同名称、前缀为 `On` 的处理程序。

> **提示**
>
> 查看生命周期处理程序的完整列表，以确定可以实现哪些方法！

```c#
public partial class ExampleNode : Node {
  public override partial void _Notification(int what);

  public void OnReady() => SomeMethod();

  public void OnProcess(double delta) => SomeMethod();
```

### 🔋 PowerUps

上面示例中的 PowerUp 也是一个普通的脚本类，用于扩展 Godot 节点。唯一的新部分似乎是 `[PowerUp]` 属性，但实际上这里隐藏着一些东西。

```c#
[PowerUp]
public partial class ExamplePowerUp : Node {
  public long LastNotification { get; private set; }

  public void OnExamplePowerUp(int what) {
    switch ((long)what) {
      case NotificationReady:
        GD.Print("PowerUp is ready!");
        break;

        // ...
```

在进行 PowerUp 时，SuperNodes 将检查 PowerUp 是否声明了名为 `On{PowerUpName}` 的方法。

在这种情况下，有一个 `OnExamplePowerUp(int what)` 方法，它接收 Godot 通知标识符整数。每当 Godot 事件发生时，SuperNodes 都会从其生成的 `_Notification` 处理程序中调用 `OnExamplePowerUp` 方法，从而允许 PowerUp 执行操作以响应其应用到的任何 SuperNode 的事件。

> **信息**
>
> 从现在起，当谈到 PowerUps 时，我们将把 `On{PowerUpName}` 方法称为 `OnPowerUp` 方法。

PowerUps 可以向 C# Godot 脚本添加任何类型的附加实例数据（字段、属性、事件、静态成员等），从而绕过默认接口实现的限制。但这还不是全部。PowerUps 还可以：

- ✅ 将实例数据、方法和事件实现添加到 SuperNodes。
- ✅ 在超级节点上实现接口。
- ✅ 接收类型参数（通用 PowerUps）！
- ✅ 在超级节点上实现通用接口。
- ✅ 检查和操作超级节点的所有属性和字段，包括来自其他 PowerUps 的属性和字段。

我们将在本文后面的文档中讨论如何在项目中利用这些功能。

### 🪄 魔法之下

SuperNodes 将为 `ExampleNode` 生成几个实现文件，以便能够神奇地增强它。

> **提示**
> 要显示生成的文件，可以将以下内容添加到 `.csproj` 文件中：
>
> ```xml
> <PropertyGroup>
>   <EmitCompilerGeneratedFiles>true</EmitCompilerGeneratedFiles>
>   <CompilerGeneratedFilesOutputPath>.generated</CompilerGeneratedFilesOutputPath>
> </PropertyGroup>
> ```


以下是包含 `_Notification` 方法的主实现文件中的内容：

> **`SimpleExample.ExampleNode.g.cs`**
>
> ```c#
> #nullable enable
> using Godot;
> using SuperNodes.Types;
> 
> namespace SimpleExample {
>   partial class ExampleNode {
>     public override partial void _Notification(int what) {
>       // Invoke declared lifecycle method handlers.
>       OnExamplePowerUp(what);
> 
>       // Invoke any notification handlers declared in the script.
>       switch ((long)what) {
>         case NotificationReady:
>           OnReady();
>           break;
>         case NotificationProcess:
>           OnProcess(GetProcessDeltaTime());
>           break;
>         default:
>           break;
>       }
>     }
>   }
> }
> #nullable disable
> ```

生成的 `_Notification` 实现允许 SuperNode 跟踪发生的生命周期事件，并将它们分派到脚本的生命周期方法处理程序，以及应用的 PowerUp 中声明的任何 `OnPowerUp` 方法。

SuperNodes 只为脚本中的生命周期处理程序生成 `switch/case` 语句——它不会为每个 Godot 通知标识符生成一个 `case`。如果不声明 `OnReady` 方法，`switch/case` 语句将没有 `NotificationReady` 的 `case`，从而减少了最终二进制文件中跳转指令的数量。

我们几乎没有触及 SuperNodes 和 PowerUps 的表面。如果你玩得很开心，继续阅读以了解更多！

## 📦 安装

只需将以下包引用添加到项目的 `.csproj` 文件中（您可以在 Nuget 上找到最新版本）。不要忘记在 SuperNodes 包引用中包含 `PrivateAssets="all"` 和 `OutputItemType="analyzer"` 属性！

```xml
<ItemGroup>
  <!-- Include SuperNodes as a Source Generator -->
  <PackageReference Include="Chickensoft.SuperNodes" Version="1.1.0" PrivateAssets="all" OutputItemType="analyzer" />

  <!-- Type definitions and attributes used by SuperNodes. -->
  <!-- By convention, version will be the same as the generator itself. -->
  <PackageReference Include="Chickensoft.SuperNodes.Types" Version="1.1.0" />
</ItemGroup>
```

> **信息**
>
> 因为 SuperNodes 是一个源生成器，所以必须包含 `PrivateAssets="all" OutputItemType="analyzer"` 来告诉构建系统如何使用它。

现在，您的节点脚本已经准备好进行超级充电（supercharged） 了！在下一节中，我们将开始解释如何利用 SuperNodes 提供的功能。

## 🤖 源生成器

### 🔄 生命周期挂钩

前面我们提到过，您可以在 SuperNode 上声明生命周期挂钩。在 SuperNodes 的行话中，“生命周期挂钩”只是在节点生命周期事件发生时应调用的方法的名称，如 `Ready`、`Process`、`EnterTree` 等。

让我们举个例子来解释一下！

```c#
namespace LifecycleExample;

using Godot;
using SuperNodes.Types;

[SuperNode("MyLifecycleHook")]
public partial class MySuperNode : Node {
  public override partial void _Notification(int what);
}
```

`MySuperNode` 类已经声明了一个名为 `MyLifecycleHook` 的生命周期钩子。因为我们已经声明了这个方法，所以 SuperNodes 将知道从其生成的 `_Notification` 实现中调用它。

以下是生成的代码的样子。

```c#
#nullable enable
using Godot;
using SuperNodes.Types;

namespace LifecycleExample {
  partial class MySuperNode {
    public override partial void _Notification(int what) {
      // Invoke declared lifecycle method handlers.
      MyLifecycleHook(what);
    }
  }
}
#nullable disable
```

现在假设我们有另一个源生成器，它在 `MySuperNode` 类上生成一个名为 `MyLifecycleHook` 的方法。

```c#
// Pretend this implementation is created by another source generator
public partial class MySuperNode {
  public void MyLifecycleHook(int what) {
    if (what == NotificationReady) {
      GD.Print($"{Name} is ready.");
    }
  }
}
```

即使 SuperNodes 无法了解其他源生成器，它仍然可以调用声明的生命周期挂钩方法！

我们甚至可以声明多个生命周期方法挂钩和 PowerUps。

```c#
[SuperNode("MyLifecycleHook", typeof(MyPowerUp), "MyOtherLifecycleHook")]
public partial class MySuperNode : Node {
```

> **注意**
>
> 超级节点将按照声明的顺序调用生命周期方法钩子和 PowerUps。在上面的示例中，调用将如下所示：
>
> ```c#
> // Code generated by SuperNodes
> public override partial void _Notification(int what) {
>   // Invoke declared lifecycle method handlers.
>   MyLifecycleHook(what);
>   MyPowerUp(what);
>   MyOtherLifecycleHook(what);
> }
> ```
>
> 生命周期挂钩和 PowerUps 总是在用户定义的生命周期处理程序（如 `OnReady`、`OnProcess`、`OnEnterTree` 等）之前调用。

### 😥 源生成器问题

如果您尝试将第三方源代码生成器与 Godot 的官方源代码生成器一起使用，您可能会遇到以下一些限制：

1. 由于 C# 源代码生成器（按设计）彼此不了解，Godot 源代码生成器无法为其他源代码生成器添加到脚本的任何成员生成 GDScript 绑定。

   同样，其他源生成器添加到脚本实现中的属性将不会使用 `[Export]` 属性导出，因为它们生成的代码对官方 Godot 源生成器不可用。

   > **信息**
   >
   > 因为源生成器的运行顺序在中是不可配置的 .NET，没有简单的解决方法。请参阅 godotengine/godot#66597，了解有关源代码生成器支持的危险的更多详细信息。

2. 如果多个第三方源生成器添加相同的生命周期方法实现（如 `_Notification`），则生成的代码将无效。源代码生成器无法知道另一个源代码生成器是否会实现相同的方法，因此无法避免生成重复的代码。

> **提示**
>
> 我们无法解决问题 #1，但我们*可以*接受它。从本质上讲，由第三方源生成器添加到类中的任何成员在 Godot 或 GDScript 中都不可见，但在 C# 中可以正常工作。如果您主要用 C# 编写代码，这不会给您带来任何问题。

### 💖 源生成器解决方案

从理论上讲，我们**可以**解决问题 #2。

想象两个源生成器，每个源生成器都希望实现 `_Notification` 以执行响应节点脚本的生命周期事件的操作。如果两个生成器都实现了 `_Notification` 并添加到游戏开发者的项目中，代码甚至不会编译，因为在同一个类中会有两个重复的 `_Notification` 方法实现。

那么，我们该如何解决这个问题呢？就像你小时候父母解决问题的方法一样：分享。

#### 🙋 调解人来救援

超级节点可以充当源生成器之间的中介。如果每个想要进入节点生命周期的生成器都创建了一个包含生命周期挂钩方法的实现，那么 SuperNodes 可以在生成的 `_Notification` 方法中调用每个生成器的方法。之后，用户可以简单地将生成器的生命周期方法挂钩的名称添加到他们的 `[SuperNode]` 属性中，以利用其他源生成器。

例如，假设我们创建了一个名为 `PrintOnReady` 的源生成器，该生成器为每个节点脚本生成一个名称为 `PrintOnReady` 的方法。然后，我们可以将 `PrintOnReady` 生命周期方法名称添加到我们的 `[SuperNode]` 属性中，以利用 `PrinteOnReady` 源生成器。

```c#
// Hypothetical PrintOnReady source generator output.
public partial class MySuperNode {
  public void PrintOnReady(int what) {
    if (what == NotificationReady) {
      GD.Print($"{Name} is ready.");
    }
  }
}
```

在我们的节点脚本中，我们可以用 `PrintOnReady` 生命周期钩子方法名称来注释类。

```c#
[SuperNode("PrintOnReady")]
public partial class MySuperNode : Node {
  public override partial void _Notification(int what);
}
```

这很有效，但我们可以做得更好。让我们使用 `nameof` 来确保我们不会意外拼错生命周期挂钩方法的名称！

```c#
[SuperNode(nameof(MySuperNode.PrintOnReady))]
public partial class MySuperNode : Node {
  public override partial void _Notification(int what);
}
```

哇，有点长。如果我们使用多个生成器呢？

```c#
[SuperNode(nameof(MySuperNode.GeneratedMethod1, MySuperNode.GeneratedMethod2))]
public partial class MySuperNode : Node {
```

嗯，那不太有趣。

如果第三方源生成器注入了一个与它添加到每个节点脚本的方法同名的类，该怎么办？

```c#
// Somewhere in the generated code for PrintOnReady
public class PrintOnReady {
  // Nothing to see here — this only exists to help with nameof!
}
```

然后我们可以使用 `nameof` 来获取类的名称，这将与方法相同。

```c#
[SuperNode(nameof(PrintOnReady))]
public partial class MySuperNode : Node {
```

啊，太完美了。我们基本上已经开发了一种约定，如果第三方源生成器希望通过允许超级节点为其进行调解来和谐地协同工作，则可以遵循该约定。

#### 🏪 源生成器作者指南

你是源代码生成器的作者吗？你想制作一个兼容的源生成器，利用 Godot 节点的生命周期，并与使用 SuperNodes 的其他生成器很好地配合吗？如果是这样的话，以下是 Chickensoft 的官方指南，可以帮助您入门：

- ☑️ 源生成器应该注入一个与它打算添加到节点脚本中的生命周期挂钩方法同名的类。

  如果源生成器想要添加不同种类的生命周期挂钩方法（取决于节点），它可以为可能添加的每个方法名称注入一个类。注入类名有助于允许用户以类型安全的方式使用 `nameof` 在 `[SuperNode]` 属性中轻松引用方法的名称。

- ☑️ 首选与生成器名称匹配的生命周期方法挂钩名称，这样用户可以通过自动完成更容易地发现方法名称。

- ☑️ 不要实现其他生命周期方法，如 `_Notification`、`_Ready`、`_Process` 等。每当发生任何事件时，生成器的生命周期方法挂钩都会被调用，使生成器能够过滤掉它关心的事件。

- ☑️ 在源生成器的文档/README中，请包括一条说明，说明其用户还必须引用超级节点，以便在响应生命周期事件时调用生成器。

> **信息**
>
> 如果您正在开发源生成器，请在 Discord 上与我们联系！我们很乐意回答您的任何问题，并为您提供一个与社区共享工具的地方！

## 📊 静态反射表

下面是一个应用 PowerUp 的 SuperNode 示例。

```c#
namespace AdvancedReflection;

using System;
using Godot;
using SuperNodes.Types;

[SuperNode(typeof(MyPowerUp))]
public partial class MySuperNode : Node2D {
  public override partial void _Notification(int what);

  [Export(PropertyHint.Range, "0, 100")]
  public int Probability { get; set; } = 50;
}

[PowerUp]
public partial class MyPowerUp : Node2D {
  [Obsolete("MyName is obsolete — please use Identifier instead.")]
  public string MyName { get; set; } = nameof(MyPowerUp);

  public string Identifier { get; set; } = nameof(MyPowerUp);
}
```

`MySuperNode` 脚本有一个导出到 Godot 编辑器的属性 `Probability`。因为它还应用了 `MyPowerUp`，所以SuperNode 最终获得了两个额外的属性：`MyName` 和 `Identifier`。

在编译时，SuperNodes 将为 `MySuperNode` 生成以下静态反射实现。生成的实现包括属性表、属性的属性、类型、可见性、可变性信息以及获取和设置这些属性值的方法。

> **StaticReflectionExample.MySuperNode_Reflection.g.cs**
>
> ```c#
> #nullable enable
> using System;
> using System.Collections.Generic;
> using System.Collections.Immutable;
> using Godot;
> using SuperNodes.Types;
> 
> namespace StaticReflectionExample {
>   partial class MySuperNode : ISuperNode {
>     public ImmutableDictionary<string, ScriptPropertyOrField> PropertiesAndFields
>       => ScriptPropertiesAndFields;
> 
>     public static ImmutableDictionary<string, ScriptPropertyOrField> ScriptPropertiesAndFields { get; }
>       = new Dictionary<string, ScriptPropertyOrField>() {
>       ["Identifier"] = new ScriptPropertyOrField(
>         Name: "Identifier",
>         Type: typeof(string),
>         IsField: false,
>         IsMutable: true,
>         IsReadable: true,
>         ImmutableDictionary<string, ImmutableArray<ScriptAttributeDescription>>.Empty
>       ),
>       ["MyName"] = new ScriptPropertyOrField(
>         Name: "MyName",
>         Type: typeof(string),
>         IsField: false,
>         IsMutable: true,
>         IsReadable: true,
>         new Dictionary<string, ImmutableArray<ScriptAttributeDescription>>() {
>           ["global::System.ObsoleteAttribute"] = new ScriptAttributeDescription[] {
>             new ScriptAttributeDescription(
>               Name: "ObsoleteAttribute",
>               Type: typeof(global::System.ObsoleteAttribute),
>               ArgumentExpressions: new dynamic[] {
>                 "MyName is obsolete — please use Identifier instead.",
>               }.ToImmutableArray()
>             )
>           }.ToImmutableArray()
>         }.ToImmutableDictionary()
>       ),
>       ["Probability"] = new ScriptPropertyOrField(
>         Name: "Probability",
>         Type: typeof(int),
>         IsField: false,
>         IsMutable: true,
>         IsReadable: true,
>         new Dictionary<string, ImmutableArray<ScriptAttributeDescription>>() {
>           ["global::Godot.ExportAttribute"] = new ScriptAttributeDescription[] {
>             new ScriptAttributeDescription(
>               Name: "ExportAttribute",
>               Type: typeof(global::Godot.ExportAttribute),
>               ArgumentExpressions: new dynamic[] {
>                 Godot.PropertyHint.Range, "0, 100",
>               }.ToImmutableArray()
>             )
>           }.ToImmutableArray()
>         }.ToImmutableDictionary()
>       )
>       }.ToImmutableDictionary();
> 
>     public TResult GetScriptPropertyOrFieldType<TResult>(
>       string scriptProperty, ITypeReceiver<TResult> receiver
>     ) => ReceiveScriptPropertyOrFieldType(scriptProperty, receiver);
> 
>     public static TResult ReceiveScriptPropertyOrFieldType<TResult>(
>       string scriptProperty, ITypeReceiver<TResult> receiver
>     ) {
>       switch (scriptProperty) {
>         case "Identifier":
>           return receiver.Receive<string>();
>         case "MyName":
>           return receiver.Receive<string>();
>         case "Probability":
>           return receiver.Receive<int>();
>         default:
>           throw new System.ArgumentException(
>             $"No field or property named '{scriptProperty}' was found on MySuperNode."
>           );
>       }
>     }
> 
>     public dynamic GetScriptPropertyOrField(string scriptProperty) {
>       switch (scriptProperty) {
>         case "Identifier":
>           return Identifier;
>         case "MyName":
>           return MyName;
>         case "Probability":
>           return Probability;
>         default:
>           throw new System.ArgumentException(
>             $"No field or property named '{scriptProperty}' was found on MySuperNode."
>           );
>       }
>     }
> 
>     public void SetScriptPropertyOrField(string scriptProperty, dynamic value) {
>       switch (scriptProperty) {
>         case "Identifier":
>           Identifier = value;
>           break;
>         case "MyName":
>           MyName = value;
>           break;
>         case "Probability":
>           Probability = value;
>           break;
>         default:
>           throw new System.ArgumentException(
>             $"No field or property named '{scriptProperty}' was found on MySuperNode."
>           );
>       }
>     }
>   }
> }
> #nullable disable
> ```

### 🎫 可用信息

这是大量生成的代码，需要同时查看。让我们仔细看看发生了什么！

SuperNodes 在每个 SuperNode 类上生成一个名为 `ScriptPropertiesAndFields` 的静态属性。它还生成一个实例成员 `PropertiesAndFields`，该成员只返回 `ScriptPropertiesAndFields` 的值。

```c#
    public ImmutableDictionary<string, ScriptPropertyOrField> PropertiesAndFields
      => ScriptPropertiesAndFields;

    public static ImmutableDictionary<string, ScriptPropertyOrField> ScriptPropertiesAndFields { get; }
      = new Dictionary<string, ScriptPropertyOrField>() {
```

> **提示**
>
> `PropertiesAndFields` 实例属性使外部对象类更容易访问有关特定实例类的静态信息。

`ScriptPropertiesAndFields` 只是在 SuperNode 类（及其任何应用的 PowerUps）中找到的属性和字段名称到 `ScriptPropertyOrField` 对象的映射。

> **注意**
>
> `SuperNodes.Types` 包必须包含在每个想要使用 SuperNodes 的项目中，以及任何想要利用 SuperNodes 静态反射功能的程序集中。如果模型是在包中注入而不是共享的，则每个程序集都将有自己的模型副本，这将使跨程序集静态反射更加困难。
>
> 有关如何设置超级节点及其运行时类型的信息，请参阅安装。

`ScriptPropertyOrField` 模型包含有关成员是属性还是字段、其可变性和可读性的信息，以及应用于成员的属性字典。

以下是关于 `MyPowerUp` 提供的 `MyName` 属性的详细信息，该属性具有 `[Obsolete]` 属性。

```c#
// ...
public static ImmutableDictionary<string, ScriptPropertyOrField> ScriptPropertiesAndFields { get; }
  = new Dictionary<string, ScriptPropertyOrField>() {
  // ...
  ["MyName"] = new ScriptPropertyOrField(
    Name: "MyName",
    Type: typeof(string),
    IsField: false,
    IsMutable: true,
    IsReadable: true,
    new Dictionary<string, ImmutableArray<ScriptAttributeDescription>>() {
      ["global::System.ObsoleteAttribute"] = new ScriptAttributeDescription[] {
        new ScriptAttributeDescription(
          Name: "ObsoleteAttribute",
          Type: typeof(global::System.ObsoleteAttribute),
          ArgumentExpressions: new dynamic[] {
            "MyName is obsolete — please use Identifier instead.",
          }.ToImmutableArray()
        )
      }.ToImmutableArray()
    }.ToImmutableDictionary()
  ),
  // ...
```

属性字典是属性的完整类型名称到属性描述数组的映射，因为某些属性允许应用多个相同类型。

与 `ScriptPropertyOrField` 模型类似，每个 `ScriptAttributeDescription` 模型都包含有关属性的友好名称、类型以及传递给属性构造函数的参数的信息。由于这些参数是 C# 常量，因此可以在不可变的动态数组中提供。

> **信息**
>
> 如果你对动态类型不是很熟悉，你可以在这里阅读更多关于它们的信息。

### 🧐 自省（Introspection）

使用生成的反射实用程序，我们可以在代码库中的任何位置操作超级节点的属性和字段。

#### 📜 SuperNode 自省

在脚本中，您可以访问 `PropertiesAndFields` 字典以获取有关特定属性或字段的信息。

```c#
[SuperNode(typeof(MyPowerUp))]
public partial class MySuperNode : Node2D {
  public override partial void _Notification(int what);

  [Export(PropertyHint.Range, "0, 100")]
  public int Probability { get; set; } = 50;

  public void OnReady() {
    foreach (var property in PropertiesAndFields.Keys) {
      GD.Print($"{property} = {GetScriptPropertyOrField(property)}");
    }
    // Change probability to 100
    SetScriptPropertyOrField("Probability", 100);
  }
}
```

#### 🔋 PowerUp 自省

在 PowerUp 内部，如果（且仅当）为生成的反射表声明存根，则也可以访问它们。您可以使用 `[PowerUpIgnore]` 属性标记存根，以防止它们被复制到 SuperNode 实现中并导致重复的定义错误。

> **提示**
>
> 为生成的反射表声明存根的最简单方法是将 PowerUp 类标记为 `abstract`。

```c#
[PowerUp]
public abstract partial class MyPowerUp : Node2D {
  [Obsolete("MyName is obsolete — please use Identifier instead.")]
  public string MyName { get; set; } = nameof(MyPowerUp);

  public string Identifier { get; set; } = nameof(MyPowerUp);

  #region StaticReflectionStubs

  [PowerUpIgnore]
  public abstract ImmutableDictionary<string, ScriptPropertyOrField> PropertiesAndFields { get; }

  [PowerUpIgnore]
  public abstract dynamic GetScriptPropertyOrField(string name);

  [PowerUpIgnore]
  public abstract void SetScriptPropertyOrField(string name, dynamic value);

  #endregion StaticReflectionStubs

  [PowerUpIgnore]

  public void OnMyPowerUp(int what) {
    foreach (var property in PropertiesAndFields.Keys) {
      GD.Print($"{property} = {GetScriptPropertyOrField(property)}");
    }
    // Change identifier
    SetScriptPropertyOrField("Identifier", "AnotherIdentifier");
  }
}
```

#### 📦 交叉装配自省

如果您在另一个程序集中编写代码，该程序集希望从使用 SuperNodes 的程序集中加载代码，那么您可以访问公共生成的静态反射实用程序，就像您在代码库中一样。

```c#
using AnAssemblyUsingSuperNodes;
using SuperNodes.Types;

public static void Main() {
  var mySuperNode = new MySuperNode();
  var properties = mySuperNode.PropertiesAndFields.Keys;

  // ...
}
```

> **提示**
>
> 如果要导入多个使用 SuperNodes 并希望存储对 `ScriptPropertyOrField` 对象的引用的程序集，则可以包括 `SuperNodes.Types` 包，以便每个程序集共享相同的反射模型定义。

## 🔄 生命周期处理程序

SuperNodes 允许您实现与 Godot 节点和对象通知相对应的方法，如用于 `NotificationReady` 的 `OnReady` 或代替 `NotificationProcess` 的 `OnProcess`。

同样，还有一个特殊的 `OnNotification(int what)` 方法，可以在收到通知时随时调用。由于 SuperNodes 必须实现 `_Notification(int what)` 本身，这是在脚本中立即接收通知的唯一方法。

以下列表包含可以在 SuperNode 中实现的每个可能的生命周期处理程序。每一个对应于 `Notification` 类型的可以在 `Godot.Node` 或 `Godot.Object` 中找到。

如果 Godot 的通知被更新或重命名，则可以发布相应调整的新版本的 SuperNodes。

请注意，`OnProcess` 和 `OnPhysicsProcess` 是特殊情况，它们都有一个单独的 `double delta` 参数，该参数分别由 `GetProcessDeltaTime()` 和 `GetPhysicsProcessDeltaTime()` 提供。

- `Godot.Object` 通知
  - `OnPostinitialize` = `NotificationPostinitialize`
  - `OnPredelete` = `NotificationPredelete`
- `Godot.Node` 通知
  - `OnNotification(what)` = `override void _Notification(what)`
  - `OnEnterTree` = `NotificationEnterTree`
  - `OnWmWindowFocusIn` = `NotificationWmWindowFocusIn`
  - `OnWmWindowFocusOut` = `NotificationWmWindowFocusOut`
  - `OnWmCloseRequest` = `NotificationWmCloseRequest`
  - `OnWmSizeChanged` = `NotificationWmSizeChanged`
  - `OnWmDpiChange` = `NotificationWmDpiChange`
  - `OnVpMouseEnter` = `NotificationVpMouseEnter`
  - `OnVpMouseExit` = `NotificationVpMouseExit`
  - `OnOsMemoryWarning` = `NotificationOsMemoryWarning`
  - `OnTranslationChanged` = `NotificationTranslationChanged`
  - `OnWmAbout` = `NotificationWmAbout`
  - `OnCrash` = `NotificationCrash`
  - `OnOsImeUpdate` = `NotificationOsImeUpdate`
  - `OnApplicationResumed` = `NotificationApplicationResumed`
  - `OnApplicationPaused` = `NotificationApplicationPaused`
  - `OnApplicationFocusIn` = `NotificationApplicationFocusIn`
  - `OnApplicationFocusOut` = `NotificationApplicationFocusOut`
  - `OnTextServerChanged` = `NotificationTextServerChanged`
  - `OnWmMouseExit` = `NotificationWmMouseExit`
  - `OnWmMouseEnter` = `NotificationWmMouseEnter`
  - `OnWmGoBackRequest` = `NotificationWmGoBackRequest`
  - `OnEditorPreSave` = `NotificationEditorPreSave`
  - `OnExitTree` = `NotificationExitTree`
  - `OnMovedInParent` = `NotificationMovedInParent`
  - `OnReady` = `NotificationReady`
  - `OnEditorPostSave` = `NotificationEditorPostSave`
  - `OnUnpaused` = `NotificationUnpaused`
  - `OnPhysicsProcess(double delta)` = `NotificationPhysicsProcess`
  - `OnProcess(double delta)` = `NotificationProcess`
  - `OnParented` = `NotificationParented`
  - `OnUnparented` = `NotificationUnparented`
  - `OnPaused` = `NotificationPaused`
  - `OnDragBegin` = `NotificationDragBegin`
  - `OnDragEnd` = `NotificationDragEnd`
  - `OnPathRenamed` = `NotificationPathRenamed`
  - `OnInternalProcess` = `NotificationInternalProcess`
  - `OnInternalPhysicsProcess` = `NotificationInternalPhysicsProcess`
  - `OnPostEnterTree` = `NotificationPostEnterTree`
  - `OnDisabled` = `NotificationDisabled`
  - `OnEnabled` = `NotificationEnabled`
  - `OnSceneInstantiated` = `NotificationSceneInstantiated`

## 🧬 高级使用

在第一节中，我们解释了 PowerUps 的基本知识以及如何将它们应用于 SuperNodes。

PowerUps 具有许多功能，允许您以以前只有使用源生成器才能实现的方式增强节点脚本。从某种意义上说，PowerUps 是一种轻量级的静态元编程工具。

#### 🧰 何时使用 PowerUps

向节点脚本中自由添加代码是一项艰巨的任务，因此我们建议为可能应用于大量脚本的系统保留 PowerUps。序列化、依赖项注入、日志记录、分析或与其他组件的集成等都是 PowerUps 的好候选者。

如果你疯狂地使用 PowerUps 进行游戏逻辑，你最终会得到很多生成的代码，这些代码很难阅读和调试。如果你不确定是否应该把一些东西做成 PowerUp，可以随时跳到 Chickensoft Discord 寻求建议。

#### 🪢 通电限制

PowerUps 可以通过扩展它们可以应用到的最不特定的类型来约束它们可以应用的 SuperNodes 的类型。

> **提示**
> 在 PowerUp 中扩展基类会将 PowerUp 的使用限制为作为扩展类的子类（或子类型）的 SuperNodes。

例如，如果希望 PowerUp 能够应用于 `Node2D`（或其任何子代），则可以在 PowerUp 类中扩展 `Node2D`。如果不扩展 `Node2D` 或其任何子代的 SuperNodes 尝试应用 PowerUp，它们将在编译时出错。

```c#
namespace PowerUpConstraints;

using Godot;
using SuperNodes.Types;

[SuperNode(typeof(MyPowerUp))]
public partial class MySuperNode : Node3D {
  public override partial void _Notification(int what);
}

[PowerUp]
public partial class MyPowerUp : Node2D { }
```

> **危险**
>
> 由于 `Node3D` 不是 `Node2D` 的祖先，尝试构建上面的代码会导致 `SUPER_NODE_INVALID_POWER_UP` 错误。

#### 💎 命名冲突

如果将两个 PowerUps 应用于一个都声明同一成员的节点，则会出现编译时错误。

```c#
[SuperNode(typeof(PowerUpA), typeof(PowerUpB))]
public partial class MySuperNode : Node {
  public override partial void _Notification(int what);
  // ...
}

[PowerUp]
public partial class PowerUpA : Node {
  public string MyName { get; set; } = nameof(PowerUpA);
}

[PowerUp]
public partial class PowerUpB : Node {
  public string MyName { get; set; } = nameof(PowerUpB);
}
```

> **危险**
>
> 上面的示例导致以下编译器错误：
>
> ```
> The type 'ExampleNode' already contains a definition for 'MyName'
> ```

聪明的读者可能会认为这是来自多重继承的经典“钻石问题”。

幸运的是，您可以利用 C# 的显式接口实现语法来解决 PowerUps 之间的命名冲突。

```c#
namespace NamingConflictWorkaround;

using Godot;
using SuperNodes.Types;

[SuperNode(typeof(PowerUpA), typeof(PowerUpB))]
public partial class MySuperNode : Node {
  public override partial void _Notification(int what);
}

public interface IPowerUpA {
  string MyName { get; }
}

[PowerUp]
public class PowerUpA : IPowerUpA {
  string IPowerUpA.MyName { get; } = nameof(PowerUpA);
}

public interface IPowerUpB {
  string MyName { get; }
}

[PowerUp]
public class PowerUpB : IPowerUpB {
  string IPowerUpB.MyName { get; } = nameof(PowerUpB);
}
```

在接下来的几节中，我们将解释 PowerUps 的更多高级功能，并提供有关如何在项目中利用这些功能的信息。

### 🔋 PowerUps 和接口

PowerUps 可以代表 SuperNode 实现接口。

每当 SuperNode 应用 PowerUp 时，该 SuperNode 都会实现 PowerUp 也已实现的任何接口。

```c#
namespace ImplementedInterfaceExample;

using System.Diagnostics;
using Godot;
using SuperNodes.Types;

[SuperNode(typeof(MyPowerUp))]
public partial class MySuperNode : Node {
  public override partial void _Notification(int what);

  public void OnReady()
    => Debug.Assert(
      this is IMyPowerUp, "MySuperNode should implement IMyPowerUp"
    );
}

public interface IMyPowerUp { }

[PowerUp]
public class MyPowerUp : IMyPowerUp { }
```

在编译时，SuperNodes将生成 `MySuperNode` 的实现，并应用 PowerUp 的内容，包括 PowerUp 实现的所有接口！

```c#
// ImplementedInterfaceExample.MySuperNode_MyPowerUp.g.cs
#nullable enable
using Godot;
using SuperNodes.Types;

namespace ImplementedInterfaceExample {
  partial class MySuperNode : global::ImplementedInterfaceExample.IMyPowerUp
  {
  }
}
#nullable disable
```

### 🪫 泛型 PowerUps

PowerUps 支持泛型参数。使用 PowerUps 作为泛型混合插件可以实现那些在没有昂贵的运行时反射的情况下难以实现、痛苦或不可能实现的模式。

#### 🔌 创建泛型 PowerUp

创建泛型 PowerUp 与创建泛型类相同：

```c#
namespace GenericPowerUpExample;

using Godot;
using SuperNodes.Types;

[PowerUp]
public partial class MyPowerUp<T> : Node {
  public T Value { get; set; } = default!;

  public void OnMyPowerUp(int what) {
    if (what == NotificationReady) {
      if (Value is string) {
        GD.Print("You gave me a string!");
      }
      else if (Value is int) {
        GD.Print("You gave me an int!");
      }
      else {
        GD.Print("You gave me something else!");
      }
    }
  }
}
```

任何应用此 PowerUp 的 SuperNode 都将获得 `T` 指定类型的 `Value` 属性。

#### ⚡️ 使用泛型 PowerUp

要使用泛型 PowerUp，只需在应用 PowerUp 时指定类型参数：

```c#
namespace GenericPowerUpExample;

using Godot;
using SuperNodes.Types;

[SuperNode(typeof(MyPowerUp<string>))]
public partial class MySuperNode : Node {
  public override partial void _Notification(int what);

  public void OnReady() => System.Diagnostics.Debug.Assert(Value is not null);
}
```

#### 👯 类型替换

在编译时，SuperNodes 生成器将用 `[SuperNode]` 属性提供给它的类型参数替换 PowerUp 上的类型参数。

以下是为上面的示例生成的代码：

> **GenericPowerUpExample.MySuperNode_MyPowerUp.g.cs**
>
> ```c#
> #nullable enable
> using Godot;
> using SuperNodes.Types;
> 
> namespace GenericPowerUpExample {
>   partial class MySuperNode
>   {
>     public string Value { get; set; } = default !; // <-- Type was changed!
>     public void OnMyPowerUp(int what)
>     {
>       if (what == NotificationReady)
>       {
>         if (Value is string)
>         {
>           GD.Print("You gave me a string!");
>         }
>         else if (Value is int)
>         {
>           GD.Print("You gave me an int!");
>         }
>         else
>         {
>           GD.Print("You gave me something else!");
>         }
>       }
>     }
>   }
> }
> #nullable disable
> ```

### ♻️ 共享 PowerUp

要共享 PowerUp，我们需要能够共享它的代码，而不是其内容的编译 `.dll`。如果我们无法共享 PowerUp 的源代码，则 SuperNodes 生成器无法将其应用于 SuperNode。

幸运的是，Nuget 可以用来制作纯源代码的 Nuget 包。

#### 📑 仅源代码 Nuget 包

当一个项目引用纯源代码包时，项目中的任何源代码生成器都可以看到纯源代码的包的内容并从中生成代码。这正是我们想要的！

SuperNodes 包含一个仅限源代码的包示例，您可以根据自己的喜好复制和自定义该包。只需复制它并配置 `.csproj` 文件中的字段以匹配您的项目。

项目中包含的任何源代码都将自动复制到 nuget 包的内容文件中进行分发，所以可以根据需要添加任意多的源文件！

#### 📄 使用仅源代码包

使用纯源代码包与使用普通包有点不同。

##### 🖥 在本地

通过 `<ProjectReference>` 在本地导入仅限源代码的包是不起作用的，因为导入的源代码不会提供给使用项目的源生成器。

要在本地使用仅限源代码的 PowerUp 包，请首先构建项目。

```shell
cd SharedPowerUps # or wherever your source-only PowerUp project is
dotnet build
```

在要导入仅限源代码的 PowerUp 包的项目的解决方案文件旁边添加 `nuget.config`。

在 `nuget.config` 文件中，添加一个密钥（任何名称都可以），该密钥的值包含仅限源代码的 PowerUp 包的路径：

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <config>
  </config>
  <settings>
  </settings>
  <packageSources>
    <add key="Local Packages" value="/Somewhere/LocalPackages" />
  </packageSources>
</configuration>
```

`nuget.config` 中到本地程序包的路径应与纯源 PowerUp 程序包的 `*.csproj` 文件中的 `<OutputPath>` 相同（或者您可以手动将纯源程序包 `.nupkg` 移动到 `nuget.config` 中指定的本地程序包存储路径）。

最后，在想要使用纯源代码包的项目中，将 `<PackageReference>` 添加到仅源代码包中，如下所示（确保将名称替换为仅源代码的包的名称）。

```xml
<ItemGroup>
  <PackageReference Include="SharedPowerUps" Version="1.0.0" PrivateAssets="all" />
</ItemGroup>
```

> **注意**
>
> 您必须包括 `PrivateAssets="all"`。

`nuget.config` 文件将指示 `dotnet` 或 `nuget` 工具从本地路径正确解析包。

> **注意**
>
> 如果您对仅限源代码的 PowerUp 软件包进行更改，则 `dotnet restore` 不会始终了解这些更改。若要强制项目清除其包缓存，请运行以下操作：
>
> ```shell
> cd your_project_using_a_source_only_package
> dotnet nuget locals --clear all
> dotnet build
> ```

##### 📦 来自 Nuget

如果您已经成功发布了纯源代码包，那么使用它应该非常简单，只需将以下内容添加到项目中即可：

```xml
<ItemGroup>
  <PackageReference Include="MySharedPowerUps" Version="1.0.0" PrivateAssets="all" />
</ItemGroup>
```

### 🔬 高级静态反射

SuperNodes 可以做一些很酷的编码技巧。如果你想学习如何使用它们，你来对地方了！

#### 🗂 访问类型信息

通过在生成的表中查找属性或字段，可以轻松访问 SuperNodes 上属性或字段的普通 `Type` 信息。

```c#
// ...
public void OnReady() {
  var myPropertyType = PropertiesAndFields("MyProperty").Type;
}
// ...
```

> **危险**
>
> 不幸的是，从 `Type` 对象转换为泛型类型参数需要在运行时使用反射或代码生成。
>
> 不能在 C# 中将变量用作类型参数，因为类型必须在编译时解析。
>
> ```c#
> public void OnReady() {
>   var myPropertyType = PropertiesAndFields("MyProperty").Type;
> 
>   // doesn't work — can't use a variable as a type argument.
>   myService.SomeMethod<myPropertyType>();
> }
> ```
>
> 有关更多信息，请随意阅读有关具体化和参数多态性的内容。这听起来像是一种宗教，但事实并非如此。尽管如此，如果你和编程语言理论家交谈，你就不会被完全误导让你留下印象这是一个邪教。

SuperNodes 提供了一种机制，可以将属性或字段的类型信息作为泛型类型参数进行访问。

让我们假设我们正在尝试创建一个 SuperNode，它将序列化它所包含的所有属性和字段。为了举例说明，我们将定义一个伪序列化程序，如下所示：

```c#
public interface ISerializer {
  bool Serialize<T>(T value);
  T Deserialize<T>(dynamic value);
}

// Stub implementation for example — build or use your own serializer!
public class MySerializer : ISerializer {
  public bool Serialize<T>(T value) => true;
  public T Deserialize<T>(dynamic value) => default!;
}
```

> **提示**
>
> 在运行时将属性或字段的类型作为泛型类型参数进行访问，这在编写与（例如，序列化程序）接口的代码时会有所帮助。也许你会发现它有其他用途！

接下来，我们将创建一个类型接收器，用于调用序列化程序的 `Serialize` 方法。当我们创建它时，我们将为它提供序列化程序和要序列化的值。

类型接收器实现 `ITypeReceiver.Receive<T>()`，一个由 `SuperNodes.Types` 提供的接口。它允许我们将感兴趣的属性的类型作为类型参数而不是 `Type` 对象来接收。

```c#
public class MySerializerHelper : ITypeReceiver<bool> {
  public ISerializer Serializer { get; }
  public dynamic Value { get; }

  public MySerializerHelper(ISerializer serializer, dynamic value) {
    Serializer = serializer;
    Value = value;
  }

  public bool Receive<TSerialize>()
    => Serializer.Serialize<TSerialize>(Value);
}
```

> **注意**
>
> 为什么我们必须创建一个实现接口的类？
>
> 不幸的是，C# 不支持带有泛型类型参数的匿名函数（lambdas）。为了解决这个问题，我们必须定义一个实现泛型方法的类，这样我们才能“接收”类型参数。

最后，我们将创建一个 SuperNode，它在调用生成的实用程序方法 `GetScriptPropertyOrFieldType` 时使用我们的类型接收器。要将属性的类型作为类型参数，我们将所需属性的名称和类型接收器的实例传递给 `GetScriptPropertyOrFieldType`。

```c#
namespace AccessingTypesExample;

using System;
using Godot;
using GoDotTest;
using SuperNodes.Types;

[SuperNode]
public partial class MySuperNode : Node {
  /// <summary>This property will be serialized!</summary>
  public string MyName { get; } = nameof(MySuperNode);

  public override partial void _Notification(int what);

  private readonly ISerializer _serializer = new MySerializer();

  public void OnReady() {
    foreach (var memberName in PropertiesAndFields.Keys) {
      var member = PropertiesAndFields[memberName];

      if (!member.IsReadable || member.IsField) { continue; }

      var value = GetScriptPropertyOrField(memberName);
      var serializerHelper = new MySerializerHelper(_serializer, value);
      var result = GetScriptPropertyOrFieldType(memberName, serializerHelper);
      if (!result) {
        throw new InvalidOperationException(
          $"Failed to serialize {memberName}."
        );
      }
    }
  }
}
```

在我们的 `OnReady` 方法中，我们获取自己身上所有属性和字段的名称，并对它们进行迭代。

一旦我们有了属性名称和值，我们就会创建类型接收器 `MySerializerHelper` 的实例，并调用 `GetScriptPropertyOrFieldType` 工具方法。然后，`GetScriptPropertyOrFieldType` 工具方法将使用我们请求的属性类型调用类型接收器的 `Receive<T>()` 方法。在类型接收器中，我们使用属性的泛型类型来调用我们的序列化程序——仅此而已！

#### PowerUp  ↔️ SuperNode 通信

PowerUp 的设计方式不应使其需要自己的属性或字段由其应用的 SuperNode 初始化。这样做将要求 SuperNode 在其构造函数或其他生命周期方法中配置其从 PowerUp 获得的成员，这将违背 PowerUp 在 SuperNode 没有任何配置或知识的情况下向 SuperNode 添加功能的目的。

如果您发现自己想在 PowerUp 之外配置 PowerUp，您可能可以使用组合。

然而，在 PowerUp 上公开静态属性是完全可以接受的，该属性为 PowerUp 的每个应用程序配置其使用情况。例如，当主场景加载时，它可以在每个需要配置的 PowerUp 类上配置静态属性。

要在代码中引用 PowerUp 自己的静态属性，必须通过 PowerUp 的类名专门引用静态属性的名称。此外，您应该记得将 `[PowerUpIgnore]` 添加到静态属性中。如果不这样做，静态属性将被复制到应用 PowerUp 的任何超级节点中。

```c#
#pragma warning disable IDE0002
[PowerUp]
public partial class MyPowerUp : Node {
  [PowerUpIgnore]
  public static string NameToGreet { get; set; } = default!;

  public void OnMyPowerUp(int what) {
    if (what == NotificationReady) {
      GD.Print($"Hello, {MyPowerUp.NameToGreet}!");
    }
  }
}
#pragma warning restore IDE0002
```

> **提示**
>
> 禁用上面的 IDE0002 可以防止 .NET 建议我们简化引用 `MyPowerUp.NameToGreet` 到 `NameToGreet`。在这种特殊情况下，我们必须完全解析名称，否则 SuperNodes 生成器会认为我们指的是应用 PowerUp 的 SuperNode 上的静态属性。

#### 🧮 显式接口实现

值得一提的是，静态反射支持显式接口实现语法。

为了好玩，这里有一个显式实现接口的通用 PowerUp 示例。

```c#
namespace ExplicitInterfaceImplementationExample;

using Godot;
using SuperNodes.Types;

[SuperNode(typeof(MyPowerUp<int>))]
public partial class MySuperNode : Node {
  public override partial void _Notification(int what);

  public void OnReady() { }
}

[PowerUp]
public partial class MyPowerUp<T> : Node, IMyPowerUp<T> {
  T IMyPowerUp<T>.Value { get; } = default!;
}

public interface IMyPowerUp<T> {
  T Value { get; }
}
```

如果我们查看为 MySuperNode 生成的代码，我们会发现 SuperNodes 生成器将 `Value` 属性引用为 `IMyPowerUp<int>.Value`

```c#
public static ImmutableDictionary<string, ScriptPropertyOrField> ScriptPropertiesAndFields { get; }
  = new Dictionary<string, ScriptPropertyOrField>() {
  ["IMyPowerUp<int>.Value"] = new ScriptPropertyOrField(
    Name: "IMyPowerUp<int>.Value",
    Type: typeof(int),
    IsField: false,
    IsMutable: false,
    IsReadable: true,
    ImmutableDictionary<string, ImmutableArray<ScriptAttributeDescription>>.Empty
  )
  }.ToImmutableDictionary();
```

# 💉 AutoInject

https://github.com/chickensoft-games/AutoInject

在构建时为 C# Godot 脚本注入基于节点的依赖项。

## 📘 背景

当游戏脚本彼此强耦合时，很快就会变得难以维护。依赖注入的各种方法通常用于促进弱耦合。对于 Godot 游戏中的 C# 脚本，提供了 AutoInject，以允许场景树中较高的节点向树中较低的子节点提供依赖关系。

AutoInject 借用了其他基于树的依赖项供应系统中的 `Provider` 和 `Dependent` 的概念。`Provider` 节点为其子节点提供值。`Dependent` 节点从其祖先节点请求值。

因为 `_Ready/OnReady` 是在 Godot 中首先在树下的节点脚本上调用的（请参阅了解树顺序以了解更多信息），所以树中较低的节点通常无法访问它们所需的值，因为直到它们的祖先有机会用自己的 `_Ready/OnReady` 方法创建它们时，这些值才存在。AutoInject 通过临时订阅它发现的仍在从每个 `Dependent` 初始化的每个 `Provider` 来解决这个问题，直到它知道依赖关系已经解决。

在游戏场景树的各个部分上提供“自上而下”的节点有几个优点：

- ✅ 从属节点可以找到提供所需值的最近的祖先，从而允许轻松覆盖提供的值（在需要时）。
- ✅ 节点可以在场景树中移动，而无需更新其依赖关系。
- ✅ 最终位于不同提供程序下的节点将自动使用该新提供程序的值。
- ✅ 脚本不必相互了解。
- ✅ 数据的自然流动模仿了 Godot 引擎中使用的其他模式。
- ✅ 通过提供默认的回退值，从属脚本仍然可以在独立的场景中运行。
- ✅ 将依赖关系范围化到场景树可防止在提供程序节点上方存在无效的值。
- ✅ 解析发生在 O(n) 中，其中 `n` 是请求从属节点（通常只有少数节点要搜索）上方的树的高度。对于深层树，通过在树的下游重新提供依赖关系来“反映”依赖关系，可以进一步加快速度。
- ✅ 当节点进入场景树时，将解析依赖项，从而允许随后进行 O(1) 访问。退出并重新进入场景树将再次触发相关性解析过程。
- ✅ 脚本既可以是从属脚本，也可以是提供程序。

## 📦 安装

AutoInject 是一个仅限源代码的包，它使用 SuperNodes 源代码生成器在构建时生成必要的依赖项注入代码。您需要在项目中包括SuperNodes、SuperNodes 运行时类型和 AutoInject。所有的包装都非常轻。

只需将以下内容添加到项目的 `.csproj` 文件中即可。请务必检查 Nuget 上每个软件包的最新版本。

```xml
<ItemGroup>
    <PackageReference Include="Chickensoft.SuperNodes" Version="1.8.0" PrivateAssets="all" OutputItemType="analyzer" />
    <PackageReference Include="Chickensoft.SuperNodes.Types" Version="1.8.0" />
    <PackageReference Include="Chickensoft.AutoInject" Version="1.6.0" PrivateAssets="all" />
</ItemGroup>
```

## 🐔 Provider

若要为子代节点提供值，请将 `Provider` PowerUp 添加到节点脚本中，并为要提供的每个值实现 `IProvide<T>`。

一旦提供程序初始化了它们提供的值，它们就必须调用 `Provide` 方法来通知 AutoInject，它们所提供的值现在可用。

下面的示例显示了一个节点脚本，该脚本为其子体提供 `string` 值。

```c#
namespace MyGameProject;

using Chickensoft.AutoInject;
using Godot;
using SuperNodes.Types;

[SuperNode(typeof(Provider))]
public partial class MyProvider : Node, IProvide<string> {
  public override partial void _Notification(int what);

  string IProvide<string>.Value() => "Value"

  // Call the Provide() method once your dependencies have been initialized.
  public void OnReady() => Provide();

  public void OnProvided() {
    // You can optionally implement this method. It gets called once you call
    // Provide() to inform AutoInject that the provided values are now 
    // available.
  }
}
```

## 🐣 Dependent

要在某个子节点中使用提供的值，请将 `Dependent` PowerUp 添加到子节点脚本中，并用 `[Dependency]` 属性标记每个依赖项。当您的节点准备好并开始依赖项解析过程时，SuperNodes 将自动通知 AutoInject。

一旦解析了依赖节点中的所有依赖项，将调用依赖节点的 `OnResolved` 方法（如果被重写）。

```c#
namespace MyGameProject;

using Godot;
using SuperNodes.Types;

[SuperNode(typeof(Dependent))]
public partial class StringDependent : Node {
  public override partial void _Notification(int what);

  [Dependency]
  public string MyDependency => DependOn<string>();

  public void OnResolved() {
    // All of my dependencies are now available! Do whatever you want with 
    // them here.
  }
}
```

`OnResolved` 方法将在 `_Ready/OnReady` 之后调用，但在第一帧之前调用，如果（且仅当）它所依赖的所有提供程序在第一帧前调用 `Provide()`。

从本质上讲，`OnResolved` 是在最慢的提供程序完成提供依赖关系时调用的。为了获得最佳体验，不要等到处理完成后才从提供者处调用 `Provide`。

如果您有一个既是 `Dependent` 又是 `Provider` 的节点脚本，则可以安全地从 `OnResolved` 方法调用 `Provide`，使其能够提供依赖关系。

任何 `Provider` 节点的一般经验如下：**尽可能快地调用 `Provide`：从 `_Ready/OnReady` 或从 `OnResolved`**。如果项目中的所有提供程序都遵循此规则，则在处理树中已存在的节点之前，依赖项设置将完成。稍后添加的依赖节点将在节点接收到 `Node.NotificationReady` 通知后开始依赖解析过程。

## 🙏 提示

### 保持依赖关系树的简单性

为了获得最佳结果，请保持依赖关系树的简单性并且不受异步初始化的影响。如果你想变得过于花哨，你可以引入依赖解析死锁。避免复杂的依赖层次结构通常可以在设计游戏时进行一些额外的实验。

### 侦听依赖项

与其订阅父节点的事件，不如考虑订阅依赖项值本身发出的事件。

```c#
[SuperNode(typeof(Dependent))]
public partial class MyDependent : Node {
  public override partial void _Notification(int what);

  [Dependency]
  public MyValue Value => DependOn<MyValue>();

  public void OnResolved() {
    // Setup subscriptions once dependencies are valid.
    MyValue.OnSomeEvent += ValueUpdated
  }

  public void OnTreeExit() {
    // Clean up subscriptions here!
    MyValue.OnSomeEvent -= ValueUpdated
  }

  public void ValueUpdated() {
    // Do something in response to the value we depend on changing.
  }
}
```

### 回退值

您可以提供在找不到提供程序时使用的回退值。这样可以更容易地从编辑器中单独运行场景，而不必担心设置生产依赖关系。当然，只有在依赖节点上方找不到该类型的提供程序时，才会使用回退值。

```c#
[Dependency]
public string MyDependency => DependOn<string>(() => "fallback_value");
```

### 伪造依赖项

有时，在测试时，您可能希望“伪造”依赖项的值。伪造的依赖关系优先于依赖节点上方可能存在的任何提供程序以及任何提供的回退值。

```c#
  [Test]
  public void FakesDependency() {
    // Some dependent 
    var dependent = new MyNode();

    var fakeValue = "I'm fake!";
    dependent.FakeDependency(fakeValue);

    TestScene.AddChild(dependent);

    dependent._Notification((int)Node.NotificationReady);

    dependent.OnResolvedCalled.ShouldBeTrue();
    dependent.MyDependency.ShouldBe(fakeValue);

    TestScene.RemoveChild(dependent);
  }
```

## AutoInject 的工作原理

AutoInject 使用一种简单、特定的算法来解决依赖关系。

- 当 Dependent PowerUp 添加到 SuperNode 时，SuperNodes 生成器将把代码从从属加电复制到它应用到的节点中。
- 具有 Dependent PowerUp 的节点脚本会观察其生命周期。当它注意到 `Node.NotificationReady` 信号时，它将开始依赖项解析过程，而无需在节点脚本中编写任何代码。
- 依赖关系过程如下所示：
  - 使用 SuperNode 的静态反射表生成来检查节点脚本的所有属性。这允许脚本在不必求助于 C# 的运行时反射调用的情况下进行内省。具有 `[Dependency]` 属性的属性被收集到一组所需的依赖项中。
  - 所有必需的依赖项都将添加到剩余的依赖项集中。
  - 从属节点开始搜索其祖先，从自身开始，然后是其父节点，依此类推。
    - 如果当前搜索节点为任何剩余的依赖项实现了 `IProvide`，则开始单独的解析过程。
      - 依赖项将提供程序存储在从Dependent PowerUp复制过来的节点脚本的字典属性中。
      - 依赖项将添加到已找到的依赖项集合中。
      - 如果提供程序搜索节点尚未提供其依赖项，则依赖项订阅提供程序的 `OnInitialized` 事件。
      - 挂起的依赖关系提供程序回调跟踪依赖节点的计数器，该计数器还从剩余的依赖关系集中删除该提供程序的依赖关系，并在没有任何剩余内容的情况下启动 OnResolved 进程。
      - SuperNodes 可以在提供程序节点上订阅事件并跟踪提供程序是否已初始化，它将代码从提供程序 PowerUp 复制到提供程序的节点脚本中。
    - 在检查完所有剩余的依赖项之后，将从剩余的依赖性集中删除所找到的依赖性集合，并为下一个搜索节点清除所找到的依存性集合。
    - 如果找到所有依赖项，依赖项将启动 OnResolved 进程并完成搜索。
    - 否则，搜索节点的父节点将成为下一个要搜索的父节点。
  - 当找到每个依赖项的提供者，或者到达场景树的顶部时，搜索就结束了。

该算法有一些自然的后果，例如在所有提供程序都提供了值之前，`OnResolved` 不会在依赖项上调用。这是有意的——提供者在调用 `_Ready` 之后，应该同步初始化其提供的值。

AutoInject 的存在主要是为了从依赖项中定位提供程序，并订阅提供程序的时间刚好足够调用它们自己的 `_Ready` 方法——等待的时间比从提供程序调用 `Provide` 的时间长可能会引入依赖项解析死锁或其他指示反模式的不希望出现的情况。

通过在提供程序节点中从 `_Ready` 调用 `Provide()`，可以确保执行顺序同步展开如下：

1. 从属节点 `_Ready`（提供程序的后代，最深的节点先准备好）。
2. 提供程序节点 `_Ready`（调用 `Provide`）。
3. 依赖 `OnResolved`
4. 第 1 帧 `_Process`
5. 第 2 帧 `_Process`
6. 等等

通过遵循 `Provide()` 对 `_Ready` 的约定，可以确保所有从属节点在第一个进程调用发生之前都接收到 `OnResolved` 回调，从而确保节点在帧处理开始之前设置好✨.

> 如果您的提供程序也是依赖程序，则可以从 `OnResolved` 调用 `Provide`，以允许它向其子树提供依赖关系，这仍然保证在帧处理开始之前进行依赖关系解析。只是不要等到处理开始后才从您的提供者那里调用`Provide`！
>
> 通常，在对依赖项调用帧处理回调**之前**，它们应该能够访问它们的依赖项。

# GoDotTest

https://github.com/chickensoft-games/GoDotTest

Godot 的 C# 测试运行程序。从命令行运行测试，收集代码覆盖率，并在 VSCode 中调试测试。

## 安装

在 nuget 上查找 GoDotTest 的最新版本。使用 Godot 预发布版本的 GoDotTest 版本在版本名称中具有匹配的预发布标签。

将最新版本的 GoDotTest 添加到 `*.csproj` 文件中。请确保将 `*VERSION*` 替换为最新版本。

```xml
<ItemGroup>
  <PackageReference Include="Chickensoft.GoDotTest" Version="*VERSION*" />
</ItemGroup>
```

## 示例

下面的示例显示了如何编写单元测试。每个测试都扩展所提供的 `TestClass`，并将测试场景作为传递给基类的构造函数参数接收。测试可以使用测试场景来创建节点并将它们添加到场景树中。

```c#
using Godot;
using GoDotTest;

public class ExampleTest : TestClass {
  private readonly ILog _log = new GDLog(nameof(ExampleTest));

  public ExampleTest(Node testScene) : base(testScene) { }

  [SetupAll]
  public void SetupAll() => _log.Print("Setup everything");

  [Setup]
  public void Setup() => _log.Print("Setup");

  [Test]
  public void Test() => _log.Print("Test");

  [Cleanup]
  public void Cleanup() => _log.Print("Cleanup");

  [CleanupAll]
  public void CleanupAll() => _log.Print("Cleanup everything");

  [Failure]
  public void Failure() =>
    _log.Print("Runs whenever any of the tests in this suite fail.");
}
```

测试可以利用生命周期属性来执行设置步骤和/或清理步骤。在每次测试之前调用 `[Setup]` 属性，在每次测试之后调用 `[Cleanup]` 属性。

同样，`[SetupAll]` 属性在第一个测试运行之前调用，`[CleanupAll]` 特性在所有测试运行之后调用。测试总是按照在测试类中定义的顺序执行。

只要同一套件中的测试失败，任何标记有 `Failure` 属性的方法都将运行。故障方法可用于截屏或以特定方式管理错误。

以下是 GoDoTest 为自己的测试显示的测试执行输出：

## 配置

您可以从 Visual Studio 代码在 Godot 中调试测试。为此，您需要为以下启动配置和脚本指定 `GODOT` 环境变量才能正常工作。`GODOT` 变量应指向 Godot 可执行文件的路径。

有关设置用于 Godot 和 GoDotTest 的开发环境的更多信息，请参阅 Chickensoft 安装指南。

## 调试

以下 `launch.json` 文件提供启动配置，用于调试游戏、调试所有测试或调试 Visual Studio 代码中当前打开的测试。要调试当前打开的测试，请确保测试的类名与文件名匹配，这在 C# 中是典型的。

### Godot 4 发布配置

将以下 `tasks.json` 和 `launch.json` 放在项目根目录中名为 `.vscode` 的文件夹中。如果你从 VSCode 中的根目录打开你的项目，你将能够调试你的游戏及其测试。

#### tasks.json

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build",
      "command": "dotnet",
      "type": "process",
      "args": [
        "build",
        "--no-restore"
      ],
      "problemMatcher": "$msCompile",
      "presentation": {
        "echo": true,
        "reveal": "silent",
        "focus": false,
        "panel": "shared",
        "showReuseMessage": true,
        "clear": false
      }
    }
  ]
}
```

#### launch.json

```json
{
  "version": "0.2.0",
  "configurations": [
    // For these launch configurations to work, you need to setup a GODOT
    // environment variable. On mac or linux, this can be done by adding
    // the following to your .zshrc, .bashrc, or .bash_profile file:
    // export GODOT="/Applications/Godot.app/Contents/MacOS/Godot"
    {
      "name": "Play",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${env:GODOT4}",
      "args": [],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false,
    },
    {
      "name": "Debug Tests",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${env:GODOT4}",
      "args": [
        // These command line flags are used by GoDotTest to run tests.
        "--run-tests",
        "--quit-on-finish"
      ],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false,
    },
    {
      "name": "Debug Current Test",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${env:GODOT4}",
      "args": [
        // These command line flags are used by GoDotTest to run tests.
        "--run-tests=${fileBasenameNoExtension}",
        "--quit-on-finish"
      ],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false,
    },
  ]
}
```

## 测试场景

在您的项目中创建一个 `test` 文件夹，并在其中创建测试场景。将 C# 脚本添加到测试场景的根目录中，内容如下：

```c#
using System.Reflection;
using Godot;
using GoDotTest;

public partial class Tests : Node2D {
  public override async void _Ready()
    => await GoTest.RunTests(Assembly.GetExecutingAssembly(), this);
}
```

## 主场景

您使用 GoDotTest 的方式会因您是创建游戏还是使用 Godot 和 C# 的 nuget 包而异。

### 游戏

在主场景中，您可以告诉 GoDotTest 查看提供给 Godot 进程的命令行参数，并构造一个测试环境对象，该对象可用于确定是否应运行测试。

如果需要运行测试，可以指示 GoDotTest 在当前程序集中查找并执行测试。

因为您通常不想在游戏的发行版构建中包含测试，所以可以通过将以下内容添加到 `.csproj` 文件中来从构建中排除所有测试文件（如果测试文件不在名为 `test` 的根目录下的文件夹中，则将 `test/**/*` 更改为项目中测试文件的相对路径）：

```xml
<PropertyGroup>
  <DefaultItemExcludes Condition="'$(Configuration)' == 'ExportRelease'">
    $(DefaultItemExcludes);test/**/*
  </DefaultItemExcludes>
</PropertyGroup>
```

将以下脚本添加到 Godot 游戏的主场景（入口点）中。如果您已经有一个自定义的主场景，请将其重命名为 `Game.tscn`，并创建一个完全空的新主场景。如果您正在制作 3D 游戏，请将根设置为 Node3D，而不是 Node2D。

注意，这个脚本依赖于游戏的实际开始场景是 `Game.tscn`：如果你没有，你需要创建一个。如果不需要运行测试，您的游戏将启动并立即切换到 `Game.tscn`。否则，主场景将要求 GoDotTest 在当前程序集中查找并运行测试。

```c#
namespace YourGame;

using Godot;

#if DEBUG
using System.Reflection;
using GoDotTest;
#endif

public partial class Main : Node2D {
#if DEBUG
  public TestEnvironment Environment = default!;
#endif

  public override void _Ready() {
#if DEBUG
    // If this is a debug build, use GoDotTest to examine the
    // command line arguments and determine if we should run tests.
    Environment = TestEnvironment.From(OS.GetCmdlineArgs());
    if (Environment.ShouldRunTests) {
      CallDeferred("RunTests");
      return;
    }
#endif
    // If we don't need to run tests, we can just switch to the game scene.
    GetTree().ChangeSceneToFile("res://src/Game.tscn");
  }

#if DEBUG
  private void RunTests()
    => _ = GoTest.RunTests(Assembly.GetExecutingAssembly(), this, Environment);
#endif
}
```

### 包

如果您正在创建一个与 Godot 一起使用的 nuget 包，则应该创建一个单独的测试项目来引用您的 nuget 软件包项目。

在测试项目中，创建一个主场景，并向其中添加以下脚本。

```c#
namespace MyProject.Tests;

using System.Reflection;
using Godot;
using GoDotTest;

public partial class Tests : Node2D {
  public override void _Ready()
    => _ = GoTest.RunTests(Assembly.GetExecutingAssembly(), this);
}
```

为了获得最佳效果，可以考虑使用 Chickensoft 的 `dotnet new` GodotPackage 模板快速创建一个新的 Godot C# 包项目，该项目已经设置为与 GoDotTest 一起使用。

## 日志

如果您在查看测试日志时遇到问题，请尝试在项目设置的“网络限制”中增加`每秒最大字符数`、`每秒最大排队消息数`、`每秒最大错误数` 和 `每秒最大警告数`（您可能需要打开“高级设置”才能查看这些设置）。

## 断言和模拟（Mocking）

GoDotTest 只是一个测试提供程序和测试执行系统。保持 GoDotTest 的范围较小，使我们能够快速更新它，并确保它始终与最新的 Godot 版本配合良好。

对于模拟，我们推荐 LightMock.Generator。它在用法上类似于流行的 `Moq` 库，但在编译时生成 mock，确保了在 .NET 环境的任何库的最大兼容性。为了使 LightMock 的 API 更接近 Moq，您可以使用 Chickensoft 的 LightMoq 适配器。

对于集成测试，我们推荐 GodotTestDriver。GodotTestDriver 允许您创建驱动程序，这些驱动程序允许您模拟输入、等待下一帧、与 UI 元素交互、创建自定义测试驱动程序等。

## 覆盖率

如果您的代码被正确配置为在传入 `--run-tests` 时切换到测试场景（请参见上文），您可以使用 coverlet 工具运行 Godot 并从测试中收集代码覆盖率。

```shell
coverlet \
  "./.godot/mono/temp/bin/Debug" --verbosity detailed \
  --target $GODOT4 \
  --targetargs "--run-tests --coverage --quit-on-finish" \
  --format "opencover" \
  --output "./coverage/coverage.xml" \
  --exclude-by-file "**/test/**/*.cs" \
  --exclude-by-file "**/*Microsoft.NET.Test.Sdk.Program.cs" \
  --exclude-by-file "**/Godot.SourceGenerators/**/*.cs" \
  --exclude-assemblies-without-sources "missingall"
```

`--run-tests`、`--coverage` 和 `--quit-on-finish` 标志是 GoDotTest 特有的，它们对 Godot 本身毫无意义。如果您的主场景配置为如上所示正确使用 GoDotTest，那么您可以期望 coverlet 工具使用正确的参数调用 Godot 来开始测试。

由于设置测试覆盖率需要一个精心构建的项目，我们建议查看 Chickensoft GodotPackage 中关于收集覆盖率的部分，并查看该项目中包含的 `coverage.sh` 脚本。

> `--coverage` 标志告诉 GoDotTest 执行 Godot 进程的目的是收集覆盖率。当提供 `--coverage` 标志时，GoDotTest 将强制退出进程，这样它就可以设置整个进程的退出代码，因为 Godot 的 `SceneTree.Quit(int exitCode)` 方法实际上并没有设置退出代码。通过绕过 Godot 从 .NET 强制退出会在进程退出时显示一些错误消息，但它不会引起任何其他问题，可以安全地忽略。

## 它的工作原理

GoDotTest `TestProvider` 使用反射来查找当前程序集中的所有测试套件（扩展所提供的 `TestClass` 的类）。如果测试环境没有提供给 GoDotTest，它会构建自己的 `TestEnvironment`，该环境表示 Godot 启动时提供给它的命令行参数，并根据测试套件名称的存在（如果提供）过滤测试套件。否则，它将运行所有测试套件。

GoDotTest 使用 `TestExecutor` 按照方法在 `TestClass` 中声明的顺序运行方法。测试方法用 `[Test]` 属性表示。

测试输出由响应测试事件的 `TestReporter` 显示。

GoDotTest 将 `await` 它遇到的任何 `aync Task` 测试方法。测试不是并行运行的，也没有任何添加该功能的计划，因为在编写可视化或集成风格的测试时，这会导致竞争条件。GoDotTest 的重点是提供一种可靠的、C# 优先的 Godot 测试方法，该方法以非常简单和确定的方式运行测试。

如果您需要自定义测试的加载和运行方式，可以使用 `GoTest.cs` 中的代码作为起点。

## 命令行参数

- `--run-tests`：这个标志的出现会通知你的游戏应该运行测试。如果已将主场景设置为在它找到此标志时重定向到测试场景（如上所述），则可以在从命令行运行 Godot 时使用传入此标志（用于调试或 CI/CD 目的）来运行测试。
- `--quit-on-finish`：此标志的存在表示测试运行程序应在应用程序运行完测试后立即退出。
- `--stop-on-error`：此标志的存在表明测试运行程序在遇到任何测试套件中的第一个错误时应该停止运行测试。如果没有此标志，它将尝试运行所有测试套件。
- `--sequential`：此标志的存在表明，如果测试套件方法中发生错误，则应跳过测试套件中的后续测试方法。如果您的测试方法依赖于先前成功完成的测试方法，请使用此选项。使用 `--stop-on-error` 时会忽略此标志。
- `--coverage`：在 Godot 4 中运行测试以收集覆盖率时需要。允许 GoDotTest 强制退出，以便盖玻片正确拾取覆盖物。

有关命令行标志的详细信息，请参见 `TestEnvironment.cs`。

# 🔋 PowerUps

与 SuperNodes 源生成器一起工作的 C# Godot 游戏脚本的电源（power-ups）集合。

目前，此软件包提供了两个 PowerUps：`AutoNode` 和 `AutoSetup`。

- 🌲 AutoNode：自动将字段和属性连接到场景树中相应的节点——还可以使用 GodotNodeInterfaces 通过其接口访问节点。
- 🛠 AutoSetup：为 Godot 节点脚本中的后期两阶段初始化提供了一种机制，以便于单元测试。

> Chickensoft 还维护了第三个 PowerUp，用于依赖注入，称为 AutoInject，它位于自己的 AutoInject 存储库中。

## 📦 安装

与大多数 nuget 包不同，PowerUp 是作为仅限源代码的 nuget 包提供的，这些包实际上将 PowerUp 的源代码注入到您的项目中。

将代码直接注入到引用 PowerUp 的项目中，可以让 SuperNodes 源代码生成器看到代码并生成所需的胶水，使一切都能在没有反射的情况下工作。

要使用 PowerUps，请将以下内容添加到 `.csproj` 文件中。请确保在 Nuget 上获得每个软件包的最新版本。请注意，`AutoNode` PowerUp 需要 GodotNodeInterfaces 包，这样您就可以通过接口而不是具体类型来访问 Godot 节点，这有助于单元测试。

```xml
<ItemGroup>
    <PackageReference Include="Chickensoft.SuperNodes" Version="1.6.1" PrivateAssets="all" OutputItemType="analyzer" />
    <PackageReference Include="Chickensoft.SuperNodes.Types" Version="1.6.1" />
    <PackageReference Include="Chickensoft.PowerUps" Version="3.0.1-godot4.2.0-beta.5" PrivateAssets="all" />
    <PackageReference Include="Chickensoft.GodotNodeInterfaces" Version="2.0.0-godot4.2.0-beta.5 " />
    <!-- ^ Or whatever the latest versions are. -->
</ItemGroup>
```

## 🌲 自动节点

无论何时实例化场景，`AutoNode` PowerUp 都会自动将脚本中的字段和属性连接到场景树中声明的节点路径或唯一的节点名称，而不进行反射。它还可以用于将节点连接为接口，而不是具体的节点类型。

只需将 `[Node]` 属性应用于脚本中要自动连接到场景中节点的任何字段或属性。

如果未在 `[Node]` 属性中指定节点路径，则字段或属性的名称将在帕斯卡命名法（PascalCase）中转换为唯一的节点标识符名称。例如，通过将属性名转换为帕斯卡命名法并在百分号指示符前加上前缀，`_my_unique_node` 下方的字段名将转换为唯一节点路径名 `%MyUniqueNode`。同样，属性名称 `MyUniqueNode` 被转换为 `%MyUniqueNode`，这不是一个很大的转换，因为属性名称已经使用帕斯卡命名法中。

为了获得最佳效果，请对场景树中的节点名称使用帕斯卡命名法（无论如何，Godot 在默认情况下倾向于这样做）。

在下面的例子中，我们使用 GodotNodeInterfaces 来引用节点作为它们的接口，而不是它们的具体 Godot 类型。这使我们能够编写一个单元测试，通过替换模拟节点来伪造场景树中的节点，使我们能够一次测试单个节点脚本，而不会污染我们的测试覆盖率。

```c#
using Chickensoft.GodotNodeInterfaces;
using Chickensoft.PowerUps;
using Godot;
using SuperNodes.Types;

[SuperNode(typeof(AutoNode))]
public partial class MyNode : Node2D {
  public override partial void _Notification(int what);

  [Node("Path/To/SomeNode")]
  public INode2D SomeNode { get; set; } = default!;

  [Node] // Connects to "%MyUniqueNode" since no path was specified.
  public INode2D MyUniqueNode { get; set; } = default!;

  [Node("%OtherUniqueName")]
  public INode2D DifferentName { get; set; } = default!;

  [Node] // Connects to "%MyUniqueNode" since no path was specified.
  internal INode2D _my_unique_node = default!;
}
```

### 🧪 测试

通过替换 mock 节点，我们可以很容易地为上面的示例编写测试：

```c#
using System.Threading.Tasks;
using Chickensoft.GodotNodeInterfaces;
using Chickensoft.GoDotTest;
using Chickensoft.PowerUps.Tests.Fixtures;
using Godot;
using GodotTestDriver;
using Moq;
using Shouldly;

public class MyNodeTest : TestClass {
  private Fixture _fixture = default!;
  private MyNode _scene = default!;

  private Mock<INode2D> _someNode = default!;
  private Mock<INode2D> _myUniqueNode = default!;
  private Mock<INode2D> _otherUniqueNode = default!;

  public MyNodeTest(Node testScene) : base(testScene) { }

  [Setup]
  public async Task Setup() {
    _fixture = new(TestScene.GetTree());

    _someNode = new();
    _myUniqueNode = new();
    _otherUniqueNode = new();

    _scene = new MyNode();
    _scene.FakeNodeTree(new() {
      ["Path/To/SomeNode"] = _someNode.Object,
      ["%MyUniqueNode"] = _myUniqueNode.Object,
      ["%OtherUniqueName"] = _otherUniqueNode.Object,
    });

    await _fixture.AddToRoot(_scene);
  }

  [Cleanup]
  public async Task Cleanup() => await _fixture.Cleanup();

  [Test]
  public void UsesFakeNodeTree() {
    // Making a new instance of a node without instantiating a scene doesn't
    // trigger NotificationSceneInstantiated, so if we want to make sure our
    // AutoNodes get hooked up and use the FakeNodeTree, we need to do it manually.
    _scene._Notification((int)Node.NotificationSceneInstantiated);

    _scene.SomeNode.ShouldBe(_someNode.Object);
    _scene.MyUniqueNode.ShouldBe(_myUniqueNode.Object);
    _scene.DifferentName.ShouldBe(_otherUniqueNode.Object);
    _scene._my_unique_node.ShouldBe(_myUniqueNode.Object);
  }
}
```

## 🛠 自动设置

`AutoSetup` 将有条件地从 `_Ready` 调用节点脚本所具有的 `void Setup()` 方法，如果（且仅当）它添加到节点的 `IsTesting` 字段为 false。有条件地调用设置方法可以将节点的后期成员初始化分为两个阶段，从而允许对节点进行单元测试。如果为节点编写测试，只需在 `Setup()` 方法中初始化测试中需要模拟的任何成员。

```c#
using Chickensoft.PowerUps;
using Godot;
using SuperNodes.Types;

[SuperNode(typeof(AutoSetup))]
public partial class MyNode : Node2D {
  public override partial void _Notification(int what);

  public MyObject Obj { get; set; } = default!;

  public void Setup() {
    // Setup is called from the Ready notification if our IsTesting property
    // (added by AutoSetup) is false.

    // Initialize values which would be mocked in a unit testing method.
    Obj = new MyObject();
  }

  public void OnReady() {
    // Guaranteed to be called after Setup()

    // Use object we setup in Setup() method (or, if we're running in a unit 
    // test, this will use whatever the test supplied)
    Obj.DoSomething();
  }
}
```

> 💡 AutoInject 为同样需要后期两阶段初始化的节点提供了开箱即用的功能。它还提供了一个 `IsTesting` 属性，但将在解析依赖项之后（但在调用 `OnResolved()` 之前）调用 `Setup()` 方法。如果您正在使用AutoInject，请注意，您可以在节点脚本上使用 `AutoSetup` 或 `Dependent` PowerUp，但不能同时使用两者。

# GodotNodeInterfaces

Godot 节点接口和适配器。

## 🤔 什么……为什么？

在完美的世界中，在某些情况下，模拟 Godot 节点进行测试非常有意义：

- 你是一个 TDD 崇拜者。
- 您想要对 Godot 节点脚本进行单元测试。
- 您不希望为节点脚本实例化相应的场景。为什么？因为实例化场景也会实例化任何子代及其脚本，等等。仅仅实例化脚本并将其添加到场景中就会导致测试覆盖率被收集，最终它覆盖的应用程序远远超过实际测试中的系统（您试图测试的节点脚本），这使得很难判断哪些脚本尚未测试。

GodotSharp 不公开 Godot 节点的接口，因此使用专有的企业级模拟解决方案模拟它们的成本非常高。

如果你仍然感到困惑，这可能不适合你。这是一种“如果你想要/需要这种东西，你就会知道”的东西。这实际上只适合那些喜欢编写测试并获得 100% 代码覆盖率的完美主义者。

## 🧐 我在这里什么也没看到

这是因为接口和适配器是在构建时根据引用的 GodotSharp API 版本生成的。

以下是生成的接口示例：

```c#
/// <summary>
/// <para>Casts light in a 2D environment. A light is defined as a color, an energy value, a mode (see constants), and various other parameters (range and shadows-related).</para>
/// </summary>
public interface ILight2D : INode2D {
    /// <summary>
    /// <para>The Light2D's blend mode. See <see cref="Light2D.BlendModeEnum" /> constants for values.</para>
    /// </summary>
    Light2D.BlendModeEnum BlendMode { get; set; }
    /// <summary>
    /// <para>The Light2D's <see cref="Color" />.</para>
    /// </summary>
    Color Color { get; set; }
    /// <summary>
    /// <para>If <c>true</c>, Light2D will only appear when editing the scene.</para>
    /// </summary>
    bool EditorOnly { get; set; }

    ...
```

这是相应的适配器：

```c#
/// <summary>
/// <para>Casts light in a 2D environment. A light is defined as a color, an energy value, a mode (see constants), and various other parameters (range and shadows-related).</para>
/// </summary>
public class Light2DAdapter : Node2DAdapter, ILight2D, INodeAdapter {
  /// <summary>Underlying Godot object this adapter uses.</summary>
  public new Light2D TargetObj { get; private set; }

  /// <summary>Creates a new Light2DAdapter for Light2D.</summary>
  /// <param name="object">Godot object.</param>
  public Light2DAdapter(GodotObject @object) : base(@object) {
    if (@object is not Light2D typedObj) {
      throw new System.InvalidCastException(
        $"{@object.GetType().Name} is not a Light2D"
      );
    }
    TargetObj = typedObj;
  }

    /// <summary>
    /// <para>The Light2D's blend mode. See <see cref="Godot.Light2D.BlendModeEnum" /> constants for values.</para>
    /// </summary>
    public Light2D.BlendModeEnum BlendMode { get => TargetObj.BlendMode; set => TargetObj.BlendMode = value; }

    ...
```

以下是适配器工厂的外观：

```c#
public static class GodotNodes {
  private static readonly Dictionary<Type, Func<Node, IGodotNodeAdapter>> _adapters = new() {
      [typeof(INode)] = node => new NodeAdapter(node),
      [typeof(IAnimationPlayer)] = node => new AnimationPlayerAdapter(node),
      [typeof(IAnimationTree)] = node => new AnimationTreeAdapter(node),
      [typeof(ICodeEdit)] = node => new CodeEditAdapter(node),
      [typeof(IGraphEdit)] = node => new GraphEditAdapter(node),

      ...
```

### 🤯 使用接口

`GodotNodeInterfaces` 为适配器和普通 Godot 节点添加了一些用于常见子节点操作的扩展方法变体（通过扩展方法）。

- `AddChildEx()`
- `FindChildEx()`
- `FindChildrenEx()`
- `GetChildEx<T>()`
- `GetChildEx()`
- `GetChildCountEx()`
- `GetChildrenEx()`
- `GetChildOrNullEx()`
- `GetChildrenEx()`
- `GetNodeEx()`
- `GetNodeOrNullEx<T>()`
- `GetNodeOrNullEx()`
- `HasNodeEx()`
- `RemoveChildEx()`

这些方法接收任意对象，这些对象可以是 Godot 节点实例或 Godot 接口适配器。返回节点的方法将返回经过调整的节点，以便您可以继续使用接口类型。

如果使用这些方法而不是 Godot 版本，则可以模拟子树操作，从而更容易地对节点脚本进行单元测试。

## 📦 安装

只需从 nuget 安装软件包！

```shell
dotnet add package Chickensoft.GodotNodeInterfaces 
```

## 📖 用法

您可以在 Godot 节点脚本中使用接口，并使用上面提到的各种 Ex 方法来操纵场景树。

一旦设置好了，就可以在节点脚本中使用它。

```c#
public partial class MyNode : Node2D {
  public ISprite2D Sprite { get; set; } = default!;

  public override void _Ready() {
    Sprite = this.GetNodeEx<ISprite2D>("Sprite");
  }
}
```

### 🧪 测试

所有 Godot 节点适配器实现都有一个 `FakeNodes` 字典，每个 Ex 节点操作方法（如 `GetNodeEx`、`GetChildrenEx` 等）首先检查该字典。如果在给定路径的字典中找到模拟节点，则会返回该字典，而不是查找实际节点。这允许测试 Godot 节点。

例如，这里有一个节点，它在 `_Ready` 中获取对其子节点之一的引用。

```c#
using Chickensoft.GodotNodeInterfaces;
using Chickensoft.PowerUps;
using Godot;
using SuperNodes.Types;

[SuperNode(typeof(AutoNode))]
public partial class MyNode : Node2D {
  public override partial void _Notification(int what);

  public INode2D MyChild { get; set; } = default!;

  public void OnReady() {
    // This automatically finds the node and creates a Godot node adapter
    // so that we can refer to it by its interface.
    MyChild = this.GetNodeEx<INode2D>("MyChild");
  }
}
```

> 使用 Chickensoft PowerUp 的 `AutoNode` PowerUp 可以为我们的节点实例使用假节点树。稍后会详细介绍。

由于我们使用接口来引用子节点，所以我们可以在测试中模拟它。

```c#
[Test]
public void LoadsGame() {
  var node = new MyNode();

  var myChild = new Mock<INode2D>().Object;

  // We can fake the children of the node we're testing by supplying
  // a dictionary of node paths that correspond to mock node objects.
  // Since we're referencing nodes by interfaces in our node script, this
  // works!
  node.FakeNodeTree(new() {
    ["MyChild"] = myChild.Object
  });

  node.OnReady();

  // Make sure our node did what we expected it to do.
  node.MyChild.ShouldBe(myChild.Object);
}
```

## 💁 获取帮助

*这个包坏了吗？遇到晦涩难懂的 C# 构建问题？*我们很乐意在 Chickensoft Discord 服务器上为您提供帮助。

## 💪 贡献

该项目包含一个非常匆忙编写的控制台生成器程序，该程序使用反射（yep！）来查找 GodotSharp 中属于或扩展Godot `Node` 类的所有类型，然后生成接口、适配器和适配器工厂。

实际的软件包是空的——我们在 CI/CD 中生成项目，这样我们就可以通过 renovatebot 保持此软件包的最新状态，并在新的 GodotSharp 软件包丢失时自动发布新版本。

### 🐞 调试

提供了 VSCode 启动配置文件，允许您调试生成器程序。当试图找出它生成无效代码的原因时，这可能非常有用。

> **重要**：您必须为上述启动配置设置 `GODOT` 环境变量。如果您还没有这样做，请参阅Chickensoft设置文档。

### 🏚 Renovatebot

此存储库包括一个可与 Renovatebot 一起使用的 `renovate.json` 配置，以帮助其保持最新状态。

> 与 Dependabot 不同，Renovatebot 能够将所有依赖项更新合并为一个拉取请求，这是 Godot C# 存储库的必备功能，每个子项目都需要相同的 Godot.NET.Sdk 版本。如果在多个存储库中拆分依赖关系版本冲突，则 CI 中的构建将失败。

将 Renovatebot 添加到存储库的最简单方法是从 GitHub Marketplace 安装它。请注意，您必须授予它对您希望它监视的每个组织和存储库的访问权限。

所包含的 `renovate.json` 包括一些配置选项，以限制 Renovatebot 打开拉取请求的频率，以及 regex 过滤掉一些版本不好的依赖项以防止无效的依赖项版本更新。

如果您的项目设置为在合并拉取请求之前需要批准，并且您希望利用 Renovatebot 的自动合并功能，则可以安装 Renovate Approve 机器人程序来自动批准 Renovate 依赖关系 PR。如果您需要两个批准，则可以安装相同的 Renovate Approve 2 机器人程序。有关详细信息，请参阅此部分。

# Godot Test Driver

https://github.com/chickensoft-games/GodotTestDriver

这个库提供了一个 API，它简化了编写 Godot 项目的集成测试。

- ✅ 将集成测试与 Godot 项目的实现细节解耦。
- ✅ 轻松模拟鼠标点击、按键和输入操作。
- ✅ Godot 的许多内置节点的驱动程序，使模拟复杂交互变得容易。
- ✅ 支持轻松设置测试夹具并在测试后正确销毁它们。

> **注意**
>
> GodotTestDriver 由 derkork 创建，现在由 Chickensoft 开源社区维护（经许可）。

> **注意**
>
> GodotTestDriver 不是测试执行器。我们建议 GoDotTest 在 Godot 游戏中执行测试。

## 如何使用 GodotTestDriver

### 安装

GodotTestDriver 发布在 NuGet 上。要添加它，请使用此命令行命令（或 IDE 的 NuGet 工具）：

```shell
dotnet add package GodotTestDriver
```

如果您的目标是 `netstandard2.1`，也可以在 `.csproj` 文件中添加以下行，使其与 Godot 一起工作：

```xml
<PropertyGroup>
    <CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>
</PropertyGroup>
```

### 真实世界示例

- [OpenSCAD 图形编辑器](https://github.com/derkork/openscad-graph-editor/tree/master/Tests)
- [Chickensoft 3D 游戏演示](https://github.com/chickensoft-games/GameDemo)

### 固定设施（Fixtures）

此库提供了一个 `Fixture` 类，可用于创建和自动处理 Godot 节点和场景。fixture 确保所有树修改都在主线程上运行。

```c#
using GodotTestDriver;

class MyTest {
     // You will need get hold of a SceneTree instance. The way you get
     // hold of it will depend on the testing framework you use.
    SceneTree tree = ...;
    Fixture fixture;
    Player player;
    Arena arena;

    // This is a setup method. The exact way of how stuff is set up
    // differs from framework to framework, but most have a setup
    // method.
    async Task Setup() {
        // Create a new Fixture instance.
        fixture = new Fixture(tree);

        // load the arena scene. It will be automatically
        // disposed of when the fixture is disposed.
        arena = await fixture.LoadAndAddScene<Arena>("res://arena.tscn");

        // load the player. it also will be automatically disposed.
        player = fixture.LoadScene<Player>("res://player.tscn");

        // add the player to the arena.
        arena.AddChild(player);
    }


    async Task TestBattle() {
        // load a monster. again, it will be automatically disposed.
        var monster = fixture.LoadScene<Monster>("res://monster.tscn");

        // add the monster to the arena
        arena.AddChild(monster);

        // create a weapon on the fly without loading a scene.
        // We call fixture.AutoFree to schedule this object for
        // deletion when the fixture is cleaned up.
        var weapon = fixture.AutoFree(new Weapon());

        // add the weapon to the player.
        arena.AddChild(weapon);


        // run the actual tests.
        ....
    }

    // You can also add custom cleanup steps to the fixture while
    // the test is running. These will be performed after the
    // test is done. This is very useful for cleaning up stuff
    // that is created during the tests.
    async Task TestSaving() {
        ...
        // save the game
        GameDialog.SaveButton.Click();

        // await file operations here

        // instruct the fixture to delete our savegame in the
        // cleanup phase.
        fixture.AddCleanupStep(() => File.Delete("user://savegame.dat"));

        // assert that the game was saved
        Assert.That(File.Exists("user://savegame.dat"));

        ....
        // when the test is done, the fixture will run your custom
        // cleanup step (e.g. delete the save game in this case)
    }


    // This is a cleanup method. Like the setup method, the exact
    // way of how stuff is cleaned up differs from framework to
    // framework, but most have a cleanup method.
    async Task TearDown() {
        // dispose of anything we created during the test.
        // this will also run all custom cleanup steps.
        await Fixture.Cleanup();
    }
}
```

#### 通过命名约定加载场景

如果您的项目中有许多场景，那么一直将场景路径硬编码到测试中可能会变得很麻烦。这也会使在项目中移动场景变得更加困难。

要解决此问题，可以使场景遵循命名约定。例如，假设 `Player/Player.tscn` 场景的根节点是将其脚本存储在 `Player/Player.cs` 中的 `Player` 节点。然后，您可以像这样简单地加载场景：

```c#
var player = fixture.LoadScene<Player>();
```

为了实现这一点，场景文件和脚本文件必须具有相同的名称、相同的拼写和大小写，并且必须位于同一目录中，这一点非常重要。唯一的区别必须是文件扩展名-场景文件为 `.tscn`，脚本文件为 `.cs`。

## 测试驱动程序

### 介绍

测试驱动程序充当测试代码和游戏代码之间的抽象层。它们是一个高级界面，测试可以通过它“看到”游戏并与之交互。有了测试驱动程序，你的游戏测试不需要知道游戏是如何在引擎盖下工作的。这使您的测试更易于更改。

### 生成供测试驱动程序工作的节点

测试驱动程序在节点树的一部分上工作。每个测试驱动程序都以一个*生产者*作为参数，这个函数应该从驱动程序将要处理的当前树中生成一个节点。例如，`ButtonDriver` 采用一个生成按钮节点的函数。

该节点的具体生成方式取决于您的游戏和测试设置。假设您将使用具有某种 `SetUp` 方法的经典测试框架：

```c#
class MyTest {

    ButtonDriver buttonDriver;

    async Task Setup() {
        buttonDriver = new ButtonDriver(() => GetTree().GetNodeOrNull<Button>("UI/MyButton"));

        // ... more setup here
    }
}
```

在本例中，`ButtonDriver` 将尝试使用 `GetNodeOrNull` 函数获取它应该处理的节点。当构造驱动程序时，它不会检查节点是否实际存在。只有在使用驱动程序时才会发生这种情况。通过这种方式，您可以在没有匹配节点结构的情况下设置驱动程序。这非常有用，因为节点结构可以在测试运行时动态更改（例如，对话框可以添加到场景中或从场景中删除，与怪物或玩家相同）。

### 使用测试驱动程序

创建测试驱动程序后，您可以在测试中使用它：

```c#

void TestButtonDisappearsWhenClicked() {
    // when
    // will click the button in its center. This will actually
    // move the mouse set a click and trigger all the events of a
    // proper button click.
    buttonDriver.ClickCenter();

    // then
    // the button should be present but invisible.
    Assert.That(button.Visible).IsFalse();
}
```

请注意您的测试现在是如何与驱动程序接口的，而不是与底层节点结构接口的。当调用 `ClickCenter` 方法，但按钮实际上不存在且不可见时，该方法将抛出一个异常，解释为什么现在不能单击按钮。这样，当你测试游戏时，你会得到正确的错误消息，而不仅仅是 `NullReferenceException`，这对调试测试有很大帮助。

### 测试驱动程序的组成

单独使用测试驱动程序是很好的，但它只适用于非常简单的情况。大多数时候，你会有复杂的嵌套节点结构，这些结构构成了你的游戏实体和 UI。因此，您可以将测试驱动程序组成树状结构来表示这些实体。假设你弹出一个对话框，询问玩家是否想在退出前保存游戏。它由三个按钮和一个标签组成。

您可以编写一个自定义驱动程序，将此对话框表示为测试：

```c#

// the root of the dialog would be a panel container.
class ConfirmationDialogDriver : ControlDriver<PanelContainer> {

    // we have a label and three buttons
    public LabelDriver Label { get; }
    public ButtonDriver YesButton { get; }
    public ButtonDriver NoButton { get; }
    public ButtonDriver CancelButton { get; }

    public ConfirmationDialogDriver(Func<PanelContainer> producer) : base(producer) {
        // for each of the elements we create a new driver, that
        // uses a producer fetching the respective node from below
        // our own root node.

        // Root is a built-in property of the driver base class,
        // which will run the producer function to get the root node.
        Label = new LabelDriver(() => Root?.GetNodeOrNull<Label>("VBox/Label"));
        YesButton = new ButtonDriver(() => Root?.GetNodeOrNull<Button>("VBox/HBox/YesButton"));
        NoButton = new ButtonDriver(() => Root?.GetNodeOrNull<Button>("VBox/HBox/NoButton"));
        CancelButton = new ButtonDriver(() => Root?.GetNodeOrNull<Button>("VBox/HBox/CancelButton"));
    }
}
```

现在，我们可以在测试中使用此驱动程序来测试对话框：

```c#
ConfirmationDialogDriver dialogDriver;

async Task Setup() {
    // prepare the driver
    dialogDriver = new ConfirmationDialogDriver(() => GetTree().GetNodeOrNull<PanelContainer>("UI/ConfirmationDialog"));
}


void ClickingYesClosesTheDialog() {
    // when
    // we click the yes button.
    dialogDriver.YesButton.ClickCenter();

    // then
    // the dialog should be gone.
    Assert.That(dialogDriver.Visible).IsFalse();
}
```

请注意，由于驱动程序的实现方式 `dialogDriver.YesButton` 永远不会抛出 `NullReferenceException`，即使该按钮当前不在树中。这大大简化了测试代码。此外，您的测试代码现在已经与实际的节点结构完全解耦。如果您决定更改对话框的节点结构，则只需要更改 `ConfirmationDialogDriver`，而不需要更改所有使用它的测试。

### 内置驱动程序

- [BaseButtonDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/BaseButtonDriver.cs) - 类似按钮的 UI 元素的驱动程序基类
- [ButtonDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/ButtonDriver.cs) - 按钮驱动程序
- [Camera2DDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/Camera2DDriver.cs) - 2D 相机的驱动程序
- [CanvasItemDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/CanvasItemDriver.cs) - 画布项目的驱动程序
- [CheckBoxDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/CheckBoxDriver.cs) - 复选框的驱动程序
- [ControlDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/ControlDriver.cs) - 操作控件的驱动程序的根驱动程序类，可用于任何控件
- [GraphEditDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/GraphEditDriver.cs) - 图形编辑器的驱动程序
- [GraphNodeDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/GraphNodeDriver.cs) - 图形节点的驱动程序
- [ItemListDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/ItemListDriver.cs) - 项目列表的驱动程序
- [LabelDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/LabelDriver.cs) - 标签驱动程序
- [LineEditDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/LineEditDriver.cs) - 行编辑的驱动程序
- [Node2DDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/Node2DDriver.cs) - 2D 节点的驱动程序
- [NodeDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/NodeDriver.cs) - 根驱动程序类。
- [OptionButtonDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/OptionButtonDriver.cs) - 选项按钮的驱动程序
- [PopupMenuDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/PopupMenuDriver.cs) - 弹出菜单的驱动程序
- [RichTextLabelDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/RichTextLabelDriver.cs) - 富文本标签的驱动程序
- [Sprite2DDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/Sprite2DDriver.cs) - 2D 精灵的驱动程序
- [TextEditDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/TextEditDriver.cs) - 文本编辑的驱动程序
- [WindowDriver](https://github.com/chickensoft-games/GodotTestDriver/blob/main/GodotTestDriver/Drivers/WindowDriver.cs) - 用于窗口的驱动程序

## 输入

GodotTestDriver 提供了许多扩展方法，允许您模拟用户输入。

> **注意**
>
> 除了需要经过时间的方法（例如，`Node::HoldActionFor()`）外，这些函数不等待额外的帧经过。当您需要额外的帧来处理输入时，GodotTestDriver 提供等待扩展，如下所述。

### 模拟鼠标输入

GodotTest 在 `Viewport` 上提供了许多扩展功能，允许您模拟视口中的鼠标输入。

```c#
// you can move the mouse to a certain position (e.g. for simulating a hover)
viewport.MoveMouseTo(new Vector2(100, 100));

// you can click at a certain position (default is left mouse button)
viewport.ClickMouseAt(new Vector2(100, 100));

// you can give a ButtonList argument to click with a different mouse button
viewport.ClickMouseAt(new Vector2(100, 100), ButtonList.Right);

// you can also send single mouse presses and releases
viewport.PressMouse();
viewport.ReleaseMouse();

// there is also built-in support for mouse dragging
// this will press the mouse at the first point, then move it to the
// second point and release it there.
viewport.DragMouse(new Vector2(100, 100), new Vector2(400, 400));

// again you can give a ButtonList argument to drag with a different mouse button
viewport.DragMouse(new Vector2(100, 100), new Vector2(400, 400), ButtonList.Right);
```

### 模拟键盘输入

GodotTest 在 `SceneTree`/`Node` 上提供了许多扩展功能，允许您模拟键盘输入。

```c#
// you can press down a key
node.PressKey(KeyList.A);
// you can also specify modifiers (e.g. shift+F1)
node.PressKey(KeyList.F1, shift: true);
// you can also specify multiple modifiers (e.g. ctrl+shift+F1)
node.PressKey(KeyList.F1, control: true, shift: true);

// you can release a key
node.ReleaseKey(KeyList.A);

// you can also combine pressing and releasing a key
node.TypeKey(KeyList.A);
```

### 模拟控制器输入

GodotTest 在 `SceneTree` / `Node` 上提供了许多扩展功能，允许您使用 Godot 的 `InputEventJoypadButton` 和 `InputEventJoypadMotion` 事件模拟控制器输入。

```c#
// you can press down a controller button
node.PressJoypadButton(JoyButton.Y);

// you can release a controller button
node.ReleaseJoypadButton(JoyButton.Y);

// you can specify a particular controller device
var deviceID = 0;
node.PressJoypadButton(JoyButton.Y, deviceID);
node.ReleaseJoypadButton(JoyButton.Y, deviceID);

// you can simulate pressure for pressure-sensitive devices
var pressure = 0.8f;
node.PressJoypadButton(JoyButton.Y, deviceID, pressure);
node.ReleaseJoypadButton(JoyButton.Y, deviceID);

// you can combine pressing and releasing a button
node.TapJoypadButton(JoyButton.Y, deviceID, pressure);

// you can move an analog controller axis to a given position, with 0 being the rest position
// for instance:
// * a gamepad trigger will range from 0 to 1
// * a thumbstick's x-axis will range from -1 to 1
node.MoveJoypadAxisTo(JoyAxis.RightX, -0.3f);

// you can release a controller axis (equivalent to setting its position to 0)
node.ReleaseJoypadAxis(JoyAxis.RightX);

// you can specify a particular controller device
node.MoveJoypadAxisTo(JoyAxis.RightX, -0.3f, deviceID);
node.ReleaseJoypadAxis(JoyAxis.RightX, deviceID);

// hold a controller button for 1.5 seconds
await node.HoldJoypadButtonFor(1.5f, JoyButton.Y, deviceID, pressure);
// hold a controller axis position for 1.5 seconds
await node.HoldJoypadAxisFor(1.5f, JoyAxis.RightX, -0.3f, deviceID);
```

使用映射动作模拟控制器输入，用于 Godot 的 `Input.GetActionStrength()`，`Input.GetAxis()` 和 `Input.GetVector()` 方法，请参阅下一节。

### 模拟其他动作

从 2.1.0 版本开始，您现在也可以模拟如下操作：

```c#
// start the jump action
node.StartAction("jump");
// end the jump action
node.EndAction("jump");

// hold an action pressed for 1 second
await node.HoldActionFor(1.0f, "jump");
```

## 等待扩展

GodotTestDriver 在 `SceneTree` 上提供了许多扩展功能，允许您等待某些事件发生。这是集成测试中的一个常见要求，在集成测试中，您将单击或发送一些按键，然后发生一些需要一段时间才能处理的操作。

```c#
Fixture fixture;
// this is a custom driver for the game under test
ArenaDriver arena;

public async Task Setup() {
    fixture = new Fixture(GetTree());
    // add the arena to the scene
    var arenaInstance = fixture.LoadAndAddScene("res://arena.tscn");
    arena = new ArenaDriver(() => arenaInstance);

    // load a monster and put it into the arena
    var monster = fixture.LoadScene<Monster>("res://monster.tscn");
    arena.AddMonster(monster);

    // load a player and put it into the arena
    var player = fixture.LoadScene<Player>("res://player.tscn");
    arena.AddPlayer(player);
}

// you can wait for a certain amount of time for a condition
// to become true
public async Task TestCombat() {
    // when
    // i open the arena gates
    arena.OpenGates();

    // then
    // within 5 seconds the player should be dead because
    // the monster will attack the player.
    await GetTree().WithinSeconds(5, () => {
        // this assertion will be repeatedly run every frame
        // until it either succeeds or the 5 seconds have elapsed
        Assert.True(arena.Player.IsDead);
    });
}

// you can also check for a condition to stay true for a
// certain amount of time
public async Task TestGodMode() {
    // setup
    // give god mode to the player
    arena.Player.EnableGodMode();

    // when
    // i open the arena gates
    arena.OpenGates();

    // then
    // the player will not lose any health within the next 5 seconds
    await GetTree().DuringSeconds(5, () => {
        // this assertion will be repeatedly run every frame
        // until it either fails or the 5 seconds have elapsed
        Assert.Equal(arenaDriver.Player.MaxHealth, arenaDriver.Player.Health);
    });
}
```

### 编写自己的驱动程序

- 如果受控对象处于执行请求操作的适当状态，则所有调用都应成功。否则，这些调用应该引发 `InvalidOperationException`。例如，如果您使用 `ButtonDriver`，而尝试单击按钮时该按钮当前不可见，则驱动程序将引发 `InvalidOperationException`。
- 生产者函数永远不应该抛出异常。如果他们找不到节点，他们应该只返回 `null`。

# 💡 LogicBlocks

https://github.com/chickensoft-games/LogicBlocks

为 C# 中的游戏和应用程序提供人性化、层次化的状态机。

逻辑块借用了[状态图 statecharts](https://statecharts.dev/)、状态机和[块 blocs](https://www.flutteris.com/blog/en/reactive-programming-streams-bloc)，以提供灵活且易于使用的 API。

LogicBlocks 不需要开发人员编写复杂的转换表，而是允许开发人员使用状态模式定义读起来像普通代码的自包含状态。逻辑块旨在便于重构，并随着项目的发展从简单的状态机发展到嵌套的分层状态图。

> 🖼 有没有想过你的代码是什么样子的？LogicBlocks 包括一个实验生成器，它允许您将逻辑块可视化为状态图——现在您的图将始终是最新的！

## 🙋 什么是逻辑块（Logic Block）？

**逻辑块是一个可以接收输入、维持状态并产生输出的类**。你如何设计你的状态取决于你自己。输出允许逻辑块侦听器被告知没有像状态那样持久化的一次性事件，允许逻辑块在没有紧密耦合的情况下影响周围的世界。此外，逻辑块状态可以从逻辑块的*黑板*中检索整个逻辑块共享的值。

> 🧑‍🏫 您可能已经注意到，我们从行为树中借用了*黑板*这个术语——这是防止状态和逻辑块之间的依赖关系强耦合的好方法。然而，LogicBlocks 黑板允许您按类型请求对象，而不是基于字符串。

这里是一个电灯开关的最小示例。更多✨ 先进的✨ 示例链接如下。

```c#
using Chickensoft.LogicBlocks;
using Chickensoft.LogicBlocks.Generator;

[StateMachine]
public class LightSwitch : LogicBlock<LightSwitch.State> {
  public override State GetInitialState() => new State.SwitchedOff();

  public static class Input {
    public readonly record struct Toggle;
  }

  public abstract record State : StateLogic {
    // "On" state
    public record SwitchedOn : State, IGet<Input.Toggle> {
      public State On(Input.Toggle input) => new SwitchedOff();
    }

    // "Off" state
    public record SwitchedOff : State, IGet<Input.Toggle> {
      public State On(Input.Toggle input) => new SwitchedOn();
    }
  }
}
```

## 🖼 可视化逻辑块

逻辑块源生成器可以用于生成代码所表示的状态图的 UML 图。它在您构建项目时运行（并且在 IDE 命令时运行），因此您将始终拥有项目中逻辑块的最新关系图。

以下是由上面的电灯开关示例生成的图表：

- [**`LightSwitch.cs`**](https://github.com/chickensoft-games/LogicBlocks/blob/main/Chickensoft.LogicBlocks.Generator.Tests/test_cases/LightSwitch.cs)

## 👷 如何使用逻辑块？

要与逻辑块交互，只需给它一个输入。输入按接收顺序排队并一次处理一个。

```c#
var lightSwitch = new LightSwitch();

// Toggle the light switch.
lightSwitch.Input(new LightSwitch.Input.Toggle());

// You can also access the current state any time.
lightSwitch.Value.ShouldBeOfType<LightSwitch.State.TurnedOn>();
```

逻辑块还带有一个简单的绑定系统，可以很容易地进行观察。您可以根据需要创建任意多的绑定，并在完成后简单地处理它们。

```c#
var binding = lightSwitch.Bind();

binding.When<LightSwitch.State.TurnedOn>()
  .Call((state) => Console.WriteLine("Light turned on."));

binding.When<LightSwitch.State.TurnedOff>()
  .Call((state) => Console.WriteLine("Light turned off."));

// ...

binding.Dispose();
```

*利用声明性绑定可以轻松地使视图或游戏组件与其底层状态保持同步*。您还可以使用绑定进行日志记录，在其他地方触发副作用，或者您能想到的任何其他事情。

## 👩‍🏫 示例

想找更多的例子吗？看看这些更现实、更真实的场景。

- [**`Heater.cs`**](https://github.com/chickensoft-games/LogicBlocks/blob/main/Chickensoft.LogicBlocks.Generator.Tests/test_cases/Heater.cs)

- [**`ToasterOven.cs`**](https://github.com/chickensoft-games/LogicBlocks/blob/main/Chickensoft.LogicBlocks.Generator.Tests/test_cases/ToasterOven.cs)

- [**`VendingMachine.cs`**](https://github.com/chickensoft-games/LogicBlocks/blob/main/Chickensoft.LogicBlocks.Example/VendingMachine.cs)

  [自动售货机示例项目](https://github.com/chickensoft-games/LogicBlocks/blob/main/Chickensoft.LogicBlocks.Example/Program.cs)显示了一个完全构建的 CLI 应用程序，该应用程序模拟自动售货机，包括计时器、库存和现金返还。

## 💡 为什么选择LogicBlocks？

逻辑块试图实现以下目标：

- **🎁 自给自足的状态。**

  逻辑块 API 是以摩尔机器为模型的。每个状态都是一个自包含的类型，它通过从输入处理程序返回新状态来声明可以转换到什么状态。相反，逻辑块也受益于 Mealy 机器的设计：状态可以在进入状态时检查前一个状态，也可以在退出状态时检查下一个状态。在我看来，这结合了“两全其美”，并很好地与面向对象编程相结合。

- **💪 可靠的执行，即使出现错误。**

  错误处理机制在很大程度上受到了 [bloc](https://bloclibrary.dev/#/) 规范实现机制的启发。不再有无效的转换异常、缺少输入处理程序警告等。如果一个状态不能处理输入，则不会发生任何事情——就这么简单！

- **🎰 输入抽象**

  要与逻辑块交互，必须给它一个输入对象。在状态图术语中，`input` 被称为 `event`，但我们不这么称呼它们，以避免与C#的 `event` 概念混淆（这是非常不同的）。

  将输入与状态转换解耦，可以更简单地实现使用逻辑块的组件——它不必担心在给逻辑块输入之前检查逻辑块的状态。这大大减少了条件分支，将复杂性留在了状态内部。

- **🪆 嵌套/层次状态。**

  由于逻辑块将状态视为自包含对象，因此可以简单地使用继承来表示状态层次结构的复合状态。此外，相关的已注册状态入口和出口回调是按层次状态的正确顺序调用的。

- **🧨 能够产生输出。**

  输出只是简单的对象，可以包含侦听器可能感兴趣的相关数据。在状态图术语中，输出被称为 `action`，但我们不这么称呼它们，以避免与 C# 的 `action` 概念混淆，后者非常不同。

  可以在逻辑块的执行期间的任何点产生输出。从状态输入处理程序生成输出允许您在外部世界中触发副作用，而无需您的逻辑块知道它。

- **🔄 同步输入处理。**

  逻辑块总是同步处理输入，允许它们通过立即响应用户输入来为响应用户界面供电。为了处理长时间运行的操作，您可以利用事件驱动的模式，或者自己从利用它们的状态中挂起正在进行的 `Task` 引用。

  默认情况下同步也有助于提高性能和简单性，这使得单线程游戏逻辑变得轻而易举。

- **📝 有序输入处理。**

  所有输入都按照接收到的顺序一次处理一个。如果当前状态没有用于当前输入的输入处理程序，则简单地丢弃该输入。

- **👩‍💻 开发者友好型。**

  逻辑块的设计符合人体工程学，便于重构，并在您迭代预期状态行为时随您扩展。

  如果出于任何原因，您决定从逻辑块迁移到基于表的状态机方法，那么从 Moore 机（LogicBlocks 也利用了自包含状态）到 Mealy 机（基于转换的逻辑）的转换是[非常琐碎的](https://electronics.stackexchange.com/a/73397)。另一种方式几乎没有那么容易。

- **🤝 兼容性。**

  适用于任何支持 `netstandard2.1` 的地方。与 Godot、Unity 或其他 C# 项目一起使用。

- **🪢 内置Fluent绑定。**

  逻辑块带有 `Binding`，这是一个实用程序类，为监视状态和输出提供了流畅的 API。绑定到逻辑块就像调用 `myLogicBlock.Bind()` 一样简单

- **🧪 可测试。**

  使用传统的模拟工具可以很容易地测试逻辑块。您可以模拟逻辑块、其上下文及其绑定，以单独对逻辑块状态和逻辑块使用者进行单元测试。

## 📦 安装

您可以在 nuget 上找到 LogicBlocks 的最新版本。

```shell
dotnet add package Chickensoft.LogicBlocks
```

要使用 LogicBlocks 源生成器，请将以下内容添加到 `.csproj` 文件中。确保用 nuget 的最新版本的 LogicBlocks 生成器替换 `3.0.0`。

```xml
  <PackageReference Include="Chickensoft.LogicBlocks.Generator" Version="3.0.0" PrivateAssets="all" OutputItemType="analyzer" />
```

一旦安装了这两个包，就可以在项目中使用以下命令强制生成关系图：

```shell
dotnet build --no-incremental
```

## 📚 入门

由于 LogicBlock 是基于状态图的，因此它有助于理解状态图的基础知识。以下是一些可以帮助您入门的资源：

- [状态机和状态图简介](https://xstate.js.org/docs/guides/introduction-to-state-machines-and-statecharts/)
- [Statecharts.dev](https://statecharts.dev/)
- [UML 状态机（维基百科）](https://en.wikipedia.org/wiki/UML_state_machine)

### ✨ 创建逻辑块

要制作一个逻辑块，您需要一个状态机或状态图的想法。从图中提取一个（或实现现有的图）是一个很好的入门方法。

一旦您对想要构建的内容有了基本的想法，就可以为您的机器创建一个新的类，并简单地扩展 `LogicBlock`。

对于这个例子，我们将创建一个简单的状态机来模拟空间加热器——当室外很冷时，你可能会使用这种类型来加热房间。

我们的空间加热器将可以使用温度供应商服务。这种提供者的接口将被假定为如下：

```c#
/// <summary>
/// Temperature sensor that presumably communicates with actual hardware
/// (not shown here).
/// </summary>
public interface ITemperatureSensor {
  /// <summary>Last recorded air temperature.</summary>
  double AirTemp { get; }
  /// <summary>Invoked whenever a change in temperature is noticed.</summary>
  event Action<double>? OnTemperatureChanged;
}
```

不过，稍后会有更多内容。

#### 声明逻辑块

我们需要为我们的逻辑块创建一个基本的脚手架，其中包括一个基本状态类型。逻辑块使用的所有其他状态都将扩展基本状态类型（或者至少是其继承层次结构中的子体）。基本状态必须在逻辑块内部定义为嵌套类型，以便它可以在后台访问 LogicBlocks 所需的类型。

> 每当逻辑块状态作为当前状态附加到逻辑块时，它都会获得自己的逻辑块上下文副本。逻辑块上下文允许状态产生输出，访问黑板上的依赖项，甚至向它们所属的逻辑块添加输入。

我们还将创建一个构造函数，接受逻辑块状态所需的依赖关系。在这种情况下，我们需要前面提到的温度传感器对象。在构造函数中，我们将把它添加到逻辑块的*黑板*中——任何逻辑块状态都可以访问的共享数据集合。

```c#
using Chickensoft.LogicBlocks;
using Chickensoft.LogicBlocks.Generator;

[StateMachine]
public class Heater : LogicBlock<Heater.State> {
    public static class Input { }

    public abstract record State : StateLogic { }
    
    public abstract record Output { }

    public Heater(ITemperatureSensor tempSensor) {
      // Add the temperature sensor to the blackboard so states can use it.
      Set(tempSensor);
    }
  }
```

> `LogicBlock` 子类还要求我们实现 `GetInitialState` 方法，但我们还没有任何状态，所以我们稍后将实现它。

通常，逻辑块状态类型应该是扩展 `StateLogic` 记录的记录。`StateLogic` 记录由 LogicBlocks 提供，允许各状态跟踪入口/出口回调。

> [C# 记录](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/tutorials/records)只是与类相同的引用类型，并增加了免费提供浅相等比较的改进。
>
> LogicBlocks 经过优化以避免转换到相同的后续状态，因此使用记录可以让我们在不付出任何努力的情况下利用这一点。

我们还创建了两个空的静态类 `Input` 和 `Output`。LogicBlock 不需要这些，它只是帮助组织我们的输入和输出，这样我们就可以在一个地方看到它们。能够在文件中向上或向下滚动，查看逻辑块可以使用的所有输入和输出，这很好。

最后，我们将 `[StateMachine]` 属性添加到我们的逻辑块类中，以告诉 LogicBlocks 源生成器关于我们的机器。将 `[StateMachine]` 属性放在逻辑块上允许LogicBlocks生成器找到逻辑块并生成将其可视化为图片所需的UML图代码。

### ⤵️ 定义输入和输出

既然我们已经剔除了一个逻辑块，我们就可以定义我们的输入和输出了。当然，这些将针对眼前的问题。

输入只是包含状态工作所需的任何数据的值。逻辑块将输入排队并一次处理一个。当前状态负责处理当前正在处理的任何输入。如果它不处理它，则简单地丢弃输入，并以相同的方式处理任何剩余的输入。

输出是由状态产生并发送到逻辑块的任何侦听器的一次性值。输出可用于保持视图或其他可视化系统（如游戏组件）与机器的当前状态同步。

```c#
  public static class Input {
    public readonly record struct TurnOn;
    public readonly record struct TurnOff;
    public readonly record struct TargetTempChanged(double Temp);
    public readonly record struct AirTempSensorChanged(double AirTemp);
  }

  public static class Output {
    public readonly record struct FinishedHeating;
  }
```

我们的每一个输入都代表了与我们正在设计的机器相关的事情。由于我们正在对空间加热器进行建模，我们已经为所有可能发生的事情提供了输入，例如打开和关闭它，改变目标温度，以及从空气温度传感器接收新的读数。我们还想知道房间何时达到所需的目标温度，所以我们添加了 `FinishedHeating` 输出。

> 您可能注意到，我们将每个输入和输出都设置为 `readonly record struct`。使用记录类型使我们能够利用简写的主构造函数语法，从而大大减少了对简单数据对象所需的键入量。
>
> 此外，对输出使用 `readonly record struct` 通常也允许 C# 编译器将它们保留在堆栈中。如果我们使用非值类型（普通记录或类），它们几乎肯定最终会被分配到堆上，这可能会很昂贵。由于几乎在视频游戏或其他高度交互式系统的每一帧都添加输入并产生输出并不罕见，因此尽可能少地分配堆是很重要的。

### 💡 定义状态

我们知道我们的空间加热器将处于三种状态之一：`Off`、`Idle`（打开但不加热）和 `Heating`（打开*并*加热）。由于我们想象中的空间加热器有一个控制所需室温（目标温度）的旋钮，我们知道我们所有的状态都应该具有 `TargetTemp` 属性。最后，我们希望我们的空间加热器能够根据空气温度读数自动启动和停止加热。

让我们首先定义每个状态所共有的信息和行为。我们知道，如果旋转温度旋钮，无论加热器处于何种状态，其目标温度都会发生变化。因此，让我们在基本状态本身上添加一个 `TargetTemp` 属性和一个用于更改目标温度的输入处理程序。这样，所有其他从它继承的状态都将免费获得该功能。这也是有道理的，因为无论加热器是开着还是关着，你都可以转动温度旋钮。

```c#
[StateMachine]
public class Heater : LogicBlock<Heater.State> {
  ...

  public abstract record State : StateLogic, IGet<Input.TargetTempChanged> {
    public double TargetTemp { get; init; }

    public State On(Input.TargetTempChanged input) => this with {
      TargetTemp = input.Temp
    };
  }

  ...
}
```

这看起来很好：每当我们的空间加热器上的假想温度旋钮转动时，它就会更新状态的 `TargetTemp` 属性。

让我们进入 `Off` 状态。这将非常简单。它只需要接收 `TurnOn` 事件并检查温度传感器，看看它是否需要直接进入 `Heating` 状态或应该进入 `Idle` 状态。

```c#
public record Off : State, IGet<Input.TurnOn> {
  public State On(Input.TurnOn input) {
    var tempSensor = Context.Get<ITemperatureSensor>();

    if (tempSensor.AirTemp >= TargetTemp) {
      // Room is already hot enough.
      return new Idle() { TargetTemp = TargetTemp };
    }

    // Room is too cold — start heating.
    return new Heating() { TargetTemp = TargetTemp };
  }
}
```

注意我们是如何使用 `Context.Get<ITemperatureSensor>` 来获取温度传感器——这就是我们从逻辑块的黑板中获取依赖关系的方式。

我们需要再次使用继承技巧：`Idle` 和 `Heating` 状态都可以关闭，所以我们将创建另一个名为 `Powered` 的抽象状态类，表示加热器正在打开。

```c#
public abstract record Powered : State, IGet<Input.TurnOff> {
  public Powered() {
    // Whenever a Powered state is entered, play a chime to
    // alert the user that the heater is on. Subsequent states that
    // inherit from Powered will not play a chime until a different
    // state has been entered before returning to a Powered state.
    OnEnter<Powered>((previous) => Context.Output(new Output.Chime()));

    // Unlike OnEnter, OnAttach will run for every state instance that
    // inherits from this record. Use these to setup your state.
    //
    // Attach and detach are great for setting up long-running operations.
    OnAttach(
      () => Get<ITemperatureSensor>().OnTemperatureChanged += OnTemperatureChanged
    );

    OnDetach(
      () => Get<ITemperatureSensor>().OnTemperatureChanged -= OnTemperatureChanged
    );
  }

  public State On(Input.TurnOff input) =>
    new Off() { TargetTemp = TargetTemp };

  // Whenever our temperature sensor gives us a reading, we will just
  // provide an input to ourselves. This lets us have a chance to change
  // the logic block's state.
  private void OnTemperatureChanged(double airTemp) =>
    Context.Input(new Input.AirTempSensorChanged(airTemp));
}
```

`Powered` 状态更有趣。构造函数注册附加和分离回调，这些回调将为扩展 `Powered` 类的状态的每个实例调用。它还注册了一个入口回调，每当状态机在处于非通电状态后转换到从通电状态继承的状态时，就会调用该入口回调。

> 💡 `OnAttach` 和 `OnDetach` 与 `OnEnter` 和 `OnExit` 不同。`OnEnter` 和 `OnExit` 遵循一个状态的类型层次结构：即，如果您进入一个扩展 `Powered` 的状态，然后进入另一个扩展 `Powered` 的状态，则 `Powered` 的 OnEnter 回调将只调用一次。另一方面，对于进入的每个扩展 `Powered` 的状态，都会调用 `OnAttach` 和 `OnDetach`。
>
> 您应该将 `OnEnter` 和 `OnExit` 视为执行理论上正确行为（如生成输出）的地方，将 `OnAttach` 和 `OnDetach` 视为设置实际行为（如注册事件处理程序或执行普通设置）的地方。
>
> 最后，*状态附加和入口之间的区别对于序列化很重要*。当反序列化状态机时，您不想重新调用入口回调，但您确实需要执行在序列化状态机之前完成的任何设置。附件回调允许在反序列化时对状态进行旋转备份，而不会产生意外的副作用。

在附件回调中，`Powered` 状态订阅温度传感器的 `OnTemperatureChanged` 事件。同样，它在从逻辑块分离之前取消订阅。

每当空气温度传感器通知我们一个新值时，就会调用状态上的私有方法 `OnTemperatureChanged`。它使用上下文在拥有状态的逻辑块上激发输入。输入将由逻辑块的当前状态处理，在这种情况下，它只是触发输入的状态 `Powered`。这是一个很好的技巧，可以创建对服务的订阅，允许状态触发状态转换以响应其他地方发生的事件。

> 请注意，我们使用了在状态 `Get<TDataType>()` 中提供的方法：它是如上所示的 `Context.Get` 方法的简写，但为我们节省了一些输入。

现在让我们添加 `Idle` 状态。它所需要做的就是对空气温度的变化做出反应，并在温度下降到远低于目标温度时开始加热。由于 `Idle` 将继承 `Powered`，它将自动订阅空气温度的变化，这将导致它接收 `AirTempSensorChanged` 输入。

```c#
public record Idle : Powered, IGet<Input.AirTempSensorChanged> {
  public State On(Input.AirTempSensorChanged input) {
    if (input.AirTemp < TargetTemp - 3.0d) {
      // Temperature has fallen too far below target temp — start heating.
      return new Heating() { TargetTemp = TargetTemp };
    }
    // Room is still hot enough — keep waiting.
    return this;
  }
}
```

最后，我们需要制作 `Heating` 状态。它的功能类似于闲置（Idle），但当房间达到目标温度时，它将恢复闲置，而不是打开暖气。

```c#
public record Heating : Powered, IGet<Input.AirTempSensorChanged> {
  public State On(Input.AirTempSensorChanged input) {
    if (input.AirTemp >= TargetTemp) {
      // We're done heating!
      Context.Output(new Output.FinishedHeating());
      return new Idle() { TargetTemp = TargetTemp };
    }
    // Room isn't hot enough — keep heating.
    return this;
  }
}
```

当处理 `AirTempSensorChanged` 输入时，它会检查新温度是否达到或高于目标温度。如果是，它会触发 `FinishedHeating` 输出，让任何逻辑块侦听器都知道我们成功地完成了空间加热器的工作。然后返回 `Idle` 状态。

我们即将完成我们的逻辑块——我们所需要做的就是定义初始状态！

```c#
[StateMachine]
public class Heater :
  LogicBlock<Heater.Input, Heater.State> {
  ...

  public override State GetInitialState() => new State.Off() {
    TargetTemp = 72.0
  };

  ...
}
```

每次我们创建逻辑块类时，都必须重写 `GetInitialState` 以提供启动状态。在这种情况下，我们只需返回目标温度为 72 度（华氏度）的关闭状态。

### 🪢 绑定到 LogicBlock

如果您错过了上面的内容，完整的空间加热器示例可在 [`Heater.cs`](https://github.com/chickensoft-games/LogicBlocks/blob/main/Chickensoft.LogicBlocks.Generator.Tests/test_cases/Heater.cs) 中找到。

要使用我们的逻辑块，我们必须首先制作一个符合上面提到的 `ITemperatureSensor` 接口的温度传感器。

```c#
public record TemperatureSensor : ITemperatureSensor {
  public double AirTemp { get; set; } = 72.0d;
  public event Action<double>? OnTemperatureChanged;

  public void UpdateReading(double airTemp) {
    AirTemp = airTemp;
    OnTemperatureChanged?.Invoke(airTemp);
  }
}
```

现在，在我们的应用程序或游戏代码的某个地方，我们可以创建一个新的逻辑块实例并绑定到它。

```c#
var tempSensor = new TemperatureSensor();
var heater = new Heater(tempSensor);

using var binding = heater.Bind();

var messages = new List<string>();

// Handle an output produced by the heater.
binding.Handle<Heater.Output.FinishedHeating>(
  (output) => messages.Add("Finished heating :)")
);

binding.When<Heater.State.Off>().Call(
  (state) => messages.Add("Heater turned off")
);

// Listen to all states that inherit from Heater.State.Powered.
binding.When<Heater.State.Powered>().Call(
  (state) => messages.Add("Heater is powered")
);

binding.When<Heater.State.Idle>().Call(
  (state) => messages.Add("Heater is idling")
);

binding.When<Heater.State.Heating>().Call(
  (state) => messages.Add("Heater is heating")
);

binding.When<Heater.State>()
  .Use(
    data: (state) => state.TargetTemp,
    to: (temp) => Console.WriteLine($"Heater target temp changed to {temp}")
  );

heater.Input(new Heater.Input.TurnOn());

// Dropping the temp below target should move it from idling to heating
tempSensor.UpdateReading(66.0);
// Raising the temp above target should move it from heating back to idling
tempSensor.UpdateReading(74);

messages.ShouldBe(new string[] {
  "Heater is powered",
  "Heater is idling",
  "Heater is powered",
  "Heater is heating",
  "Finished heating :)",
  "Heater is powered",
  "Heater is idling"
});
```

请记住，逻辑块的绑定是一次性的。您需要在逻辑块的生命周期中保留对绑定的引用，然后在完成后将其处理掉。

如果状态或从状态中选择的数据没有更改，绑定将不会重新运行回调。

## 🔮 其他提示

### ♻️ 重复使用输入、状态和输出

如果需要编写避免内存中堆分配的高性能代码，可以重用输入和状态。如果您对输出使用 `readonly record struct`，那么它们应该已经避免了堆。

为了便于使用，请考虑将状态所需的任何依赖项传递到逻辑块的构造函数中。然后，在构造函数中，创建逻辑块将使用的状态。最后，在 `GetInitialState` 方法中，通过在黑板中查找返回初始状态。

```c#
namespace Chickensoft.LogicBlocks.Tests.Fixtures;

using Chickensoft.LogicBlocks.Generator;

[StateMachine]
public partial class MyLogicBlock : LogicBlock<MyLogicBlock.State> {
  public static class Input { ... }
  public abstract record State : StateLogic { ... }
  public static class Output { ... }

  public MyLogicBlock(IMyDependency dependency) {
    // Add dependencies and pre-created states to the blackboard so that states
    // can reuse them.
    Set(dependency);

    // Add pre-created states to the blackboard so that states can look them up
    // instead of having to create them.
    Set(new State.MyFirstState());
    Set(new State.MySecondState());
  }

  // Return the initial state by looking it up in the blackboard.
  public override State GetInitialState() => Context.Get<MyFirstState>();
}
```

在其他地方，在您的状态内，您可以查找要转换到的状态。

```c#
public record MyFirstState : IGet<Input.SomeInput> {
  public State On(Input.SomeInput input) {
    // Lookup the state we want to go to.
    var nextState = Context.Get<MySecondState>();
    // Transition to the pre-made state.
    return nextState;
  }
}
```

> 🚨 如果在转换到重用状态之前更改重用状态的属性，则不正确地重用状态可能会破坏绑定，因为绑定仅通过引用缓存状态。为了避免这种情况，不要向可重用状态添加任何额外的属性——相反，使用黑板来存储所有状态的相关数据。

### 🎤 事件

如果需要对逻辑块进行完全控制，则可以手动订阅逻辑块的事件。手动订阅事件可以允许您创建一个自定义绑定系统或其他这样的系统，该系统可以监视输入、处理输出和捕获错误。

```c#
var logic = new MyLogicBlock();

logic.OnInput += OnInput;
logic.OnState += OnState;
logic.OnOutput += OnOutput;
logic.OnError += OnError;

public void OnInput(object input) =>
  Console.WriteLine($"Input being processed: {input}");

public void OnState(MyLogicBlock.State state) =>
  Console.WriteLine($"State changed: {state}");

public void OnOutput(object output) =>
  Console.WriteLine($"Output: {output}");

public void OnError(Exception error) =>
  Console.WriteLine($"Error occurred: {error}");
```

与任何 C# 事件一样，请确保在侦听完逻辑块后取消订阅，以避免造成内存泄漏。

```c#
logic.OnInput -= OnInput;
logic.OnState -= OnState;
logic.OnOutput -= OnOutput;
logic.OnError -= OnError;
```

### 📛 错误处理

默认情况下，状态中抛出的异常不会导致逻辑块停止处理输入。相反，逻辑块将调用 `OnError` 事件并继续处理输入。

有两种方法可以将错误添加到逻辑块中。第一种是在状态的输入处理程序中抛出异常。第二种方法是在上下文中调用 `AddError(Exception e)` 方法。无论您选择哪种方式，这两种方法都将导致逻辑块调用其 `HandleError` 方法。唯一的区别在于您所在状态的输入处理程序是否继续运行。当然，抛出异常会中止方法的执行，同时调用 `Context.AddError` 将继续正常执行。

```c#
// Somewhere inside your logic block...

public record MyState : State IGet<Input.SomeInput> {
  ...

  public void On(Input.SomeInput input) {
    // Add an error to the logic block.
    Context.AddError(new InvalidOperationException("Oops."));

    // Same as above, but breaks out of the method.
    throw new InvalidOperationException("Oops.");

    // Use Context.AddError if you need to continue execution inside your 
    // state method. Otherwise, feel free to throw.
  }

}
```

在需要手动控制抛出的异常是否停止应用程序的情况下，可以重写逻辑块中的 `HandleError` 方法。

```c#
[StateMachine]
public partial class MyLogicBlock : LogicBlock<MyLogicBlock.State> {

  ...

  protected override void HandleError(Exception e) {
    // This is a great place to log errors.

    // Or you can stop execution on any exception that occurs inside a state.
    throw e; 
  }

  ...
}
```

### 💥 初始状态副作用

默认情况下，LogicBlocks 不会调用初始状态注册的任何 `OnEnter` 回调，因为 state 属性在第一次访问初始状态时会惰性地创建初始状态。懒惰地创建状态可以使 LogicBlocks API 更符合人体工程学。如果状态没有延迟初始化，那么在您有机会向逻辑块的黑板添加任何内容之前，基本 LogicBlock 构造函数必须设置第一个状态，这使得很难创建具有黑板依赖性的状态。

也就是说，**在很多情况下，您*确实*希望为初始状态运行入口回调，因为您*确实*希望绑定触发**。

要强制 LogicBlock 运行入口回调并创建初始状态（如果还没有），只需在逻辑块上调用 `Start()` 方法。

```c#
var logic = new MyLogicBlock();
var binding = logic.Bind();
binding.Handle<MyLogicBlock.Output.SomeOutput>(
  (output) => { ... }
);

// Run initial state's entrance callbacks. Essentially, this forces any 
// relevant bindings to run in response to the first state, ensuring that 
// whatever is consuming the logic block is in-sync with the initial state.
logic.Start();
```

同样，当您完成逻辑块时，您可以通过调用 `Stop` 来运行最终状态的退出回调。

```c#
logic.Stop(); // Runs OnExit callbacks for the current (presumably final) state.
```

### 🧪 测试

LogicBlocks、上下文和绑定都可以被模拟（mocked）。然而，模拟上下文和绑定可能有点麻烦，因此LogicBlocks 允许您创建假绑定和上下文，从而使测试更加简单。

让我们来看看一些例子。

#### 测试 LogicBlock 消费者

想象一下，您有一个名为 `MyObject` 的对象，它使用一个称为 [`MyLogicBlock`](https://github.com/chickensoft-games/LogicBlocks/blob/main/Chickensoft.LogicBlocks.Tests/test/fixtures/MyLogicBlock.cs) 的逻辑块。

该对象做两件事：它注册一个绑定来观察 `SomeOutput`，并有一个方法 `DoSomething` 将 `SomeInput` 输入添加到它使用的逻辑块中。

```c#
public class MyObject : IDisposable {
  public IMyLogicBlock Logic { get; }
  public MyLogicBlock.IBinding Binding { get; }

  public bool SawSomeOutput { get; private set; }

  public MyObject(IMyLogicBlock logic) {
    Logic = logic;
    Binding = logic.Bind();

    Binding.Handle<MyLogicBlock.Output.SomeOutput>(
      (output) => SawSomeOutput = true
    );
  }

  // Method we want to test
  public void DoSomething() => Logic.Input(new MyLogicBlock.Input.SomeInput());

  public void Dispose() {
    Binding.Dispose();
    GC.SuppressFinalize(this);
  }
}
```

要为 `MyObject` 编写单元测试，我们需要模拟它的依赖项，然后验证它是否以我们期望的方式与依赖项交互。在这种情况下，唯一的依赖项是逻辑块。我们可以像模拟其他对象一样模拟它。

由于对象绑定到其构造函数中的逻辑块，我们需要以某种方式拦截该请求。我们可以利用每个逻辑块上存在的静态方法 `CreateFakeBinding()`，并设置我们的 mock 逻辑块，以便在被要求绑定时返回假绑定。这样，对象可以像往常一样注册绑定回调，而不知道它实际上在使用假绑定系统。

```c#
using Moq;
using Shouldly;
using Xunit;

public class MyObjectTest {
  [Fact]
  public void DoSomethingDoesSomething() {
    // Our unit test follows the AAA pattern: Arrange, Act, Assert.
    // Or Setup, Execute, and Verify, if you prefer.

    // Setup — make a fake binding and return that from our mock logic block
    using var binding = MyLogicBlock.CreateFakeBinding();

    var logic = new Mock<IMyLogicBlock>();
    logic.Setup(logic => logic.Bind()).Returns(binding);
    logic.Setup(logic => logic.Input(It.IsAny<MyLogicBlock.Input.SomeInput>()));

    using var myObject = new MyObject(logic.Object);

    // Execute — run the method we're testing
    myObject.DoSomething();

    // Verify — check that the mock object's stubbed methods were called
    logic.VerifyAll();
  }

  // ...
```

最后，我们想测试绑定是否在逻辑块生成输出 `SomeOutput` 时被实际调用。为此，我们可以使用伪绑定的 `Output()` 方法模拟逻辑块产生的输出。

> 💡 伪绑定还可以分别通过 `SetState()`、`Input()` 和 `AddError()` 方法模拟更改状态、添加输入和错误。

```c#
  // ...

  [Fact]
  public void HandlesSomeOutput() {
    // Setup — make a fake binding and return that from our mock logic block
    using var binding = MyLogicBlock.CreateFakeBinding();

    var logic = new Mock<IMyLogicBlock>();
    logic.Setup(logic => logic.Bind()).Returns(binding);

    using var myObject = new MyObject(logic.Object);

    // Execute — trigger an output from the fake binding!
    binding.Output(new MyLogicBlock.Output.SomeOutput());

    // Verify — verify object's callback was invoked by checking side effects
    myObject.SawSomeOutput.ShouldBeTrue();
  }
}
```

#### 测试 LogicBlock 状态

我们还可以测试我们的逻辑块状态是否正常工作。传统上，这将通过模拟给定给状态的逻辑块上下文并期望该状态对其调用某些方法来完成，然后验证该状态是否与上下文执行了正确的交互。

不过，这需要大量的打字。幸运的是，LogicBlocks 为每个逻辑块状态提供了一个 `CreateFakeContext()` 方法。伪上下文允许我们查看状态添加了哪些输入、输出和错误，而无需在模拟上进行大量方法打桩（stubbing）。

例如，假设我们想在 `MyLogicBlock` 上测试状态 `SomeState`。

以下是 `SomeState` 的定义，供参考。当它被输入和退出时，它输出输出 `SomeOutput`。此外，当它接收到 `SomeInput` 输入时，它还会再次输出 `SomeOutput` 并转换到 `SomeOtherState`。

```c#
// ...
public record SomeState : State, IGet<Input.SomeInput> {
  public SomeState() {
    OnEnter<SomeState>(
      (previous) => Context.Output(new Output.SomeOutput())
    );
    OnExit<SomeState>(
      (previous) => Context.Output(new Output.SomeOutput())
    );
  }

  public IState On(Input.SomeInput input) {
    Context.Output(new Output.SomeOutput());
    return new SomeOtherState();
  }
}
// ...
```

通过对状态本身调用 `Enter()` 和 `Exit()`，我们可以轻松地测试enter和exit方法。通过向我们的状态提供一个假上下文，我们可以验证它是否执行了正确的操作。

```c#
using Chickensoft.LogicBlocks.Tests.Fixtures;
using Shouldly;
using Xunit;

public class SomeStateTest {
  [Fact]
  public void SomeStateEnters() {
    var state = new MyLogicBlock.State.SomeState();
    var context = state.CreateFakeContext();

    state.Enter();

    context.Outputs.ShouldBe(
      new object[] { new MyLogicBlock.Output.SomeOutput() }
    );
  }

  [Fact]
  public void SomeStateExits() {
    var state = new MyLogicBlock.State.SomeState();
    var context = state.CreateFakeContext();

    state.Exit();

    context.Outputs.ShouldBe(
      new object[] { new MyLogicBlock.Output.SomeOutput() }
    );
  }

  // ...
```

我们检查了添加到伪上下文中的输出，以确保它们是正确的。我们也可以检查输入和错误。

> 💡 如果您需要重置伪上下文并清除它记录的所有内容，则可以调用 `context.Reset()`。

最后，我们可以通过对状态本身调用 `On()` 方法来测试输入处理程序。再次，我们可以使用伪上下文来验证状态是否添加了正确的输出。

```c#
  // ...

  [Fact]
  public void GoesToSomeOtherStateOnSomeInput() {
    var state = new MyLogicBlock.State.SomeState();
    var context = state.CreateFakeContext();

    var nextState = state.On(new MyLogicBlock.Input.SomeInput());

    nextState.ShouldBeOfType<MyLogicBlock.State.SomeOtherState>();

    context.Outputs.ShouldBe(
      new object[] { new MyLogicBlock.Output.SomeOutput() }
    );
  }
}
```

#### 假绑定

假绑定允许您模拟许多操作：

```c#
[Fact]
public void MyTest() {
  using var binding = MyLogicBlock.CreateFakeBinding();

  var logic = new Mock<IMyLogicBlock>();
  logic.Setup(logic => logic.Bind()).Returns(binding);

  // ...

  // Simulate a state change
  binding.SetState(new MyLogicBlock.State.SomeState());

  // Simulate an input
  binding.Input(new MyLogicBlock.Input.SomeInput());

  // Simulate an output
  binding.Output(new MyLogicBlock.Output.SomeOutput());

  // Simulate an error being added
  binding.AddError(new InvalidOperationException("Oops!"));

  // ...
}
```

#### 假上下文

假上下文允许您记录由测试状态触发的交互。

```c#
[Fact]
public void MyTest() {
  var state = new MyLogicBlock.State.SomeState();
  var context = state.CreateFakeContext();

  // ...

  // Set blackboard dependency
  context.Set<IMyDependency>(new Mock<IMyDependency>());

  // Set multiple blackboard dependencies at once
  context.Set(
    new Dictionary<Type, object>() {
      [typeof(IMyDependency)] = new Mock<IMyDependency>(),
      [typeof(IMyOtherDependency)] = new Mock<IMyOtherDependency>()
    }
  );

  // Check the inputs added by the state
  context.Inputs.ShouldBe(
    new object[] { new MyLogicBlock.Input.SomeInput() }
  );

  // Check the outputs added by the state
  context.Outputs.ShouldBe(
    new object[] { new MyLogicBlock.Output.SomeOutput() }
  );

  // Check the errors added by the state
  context.Errors.ShouldBe(
    new Exception[] { new InvalidOperationException("Oops!") }
  );

  // Reset the context, clearing all recorded interactions and dependencies
  context.Reset();

  // ...
}
```

## 🖼 生成状态图

LogicBlocks 生成器可以生成 UML 代码，这些代码可以用于可视化代码所表示的状态图。

> 🪄 基于代码生成图表促进了代码优先的解决方案：您的代码不必维护单独的图表，而是充当状态机的真相来源。作为奖励，您的图表永远不会过时！

有关安装 LogicBlocks 源生成器的说明，请参阅安装。

要指示 LogicBlocks 生成器为代码创建 UML 状态图，请将 `[StateMachine]` 属性添加到 LogicBlock 的定义中：

```c#
[StateMachine]
public class LightSwitch : LogicBlock<LightSwitch.Input, LightSwitch.State> {
```

> `[StateMachine]` 属性代码由源生成器自动注入。

将为项目中具有 `[StateMachine]` 属性的每个逻辑块生成状态图。图代码放在 LogicBlock 的扩展名为 `.g.puml` 的源文件旁边。

例如，这里是为上面提到的 `VendingMachine` 示例生成的 UML：

```c#
@startuml VendingMachine
state "VendingMachine State" as State {
  state Idle {
    Idle : OnEnter → ClearTransactionTimeOutTimer
    Idle : OnPaymentReceived → MakeChange
  }
  state TransactionActive {
    state Started {
      Started : OnEnter → TransactionStarted
    }
    state PaymentPending
    TransactionActive : OnEnter → RestartTransactionTimeOutTimer
    TransactionActive : OnPaymentReceived → MakeChange, TransactionCompleted
    TransactionActive : OnTransactionTimedOut → MakeChange
  }
  state Vending {
    Vending : OnEnter → BeginVending
  }
}

Idle --> Idle : PaymentReceived
Idle --> Idle : SelectionEntered
Idle --> Started : SelectionEntered
Started --> Idle : SelectionEntered
Started --> Started : SelectionEntered
TransactionActive --> Idle : TransactionTimedOut
TransactionActive --> PaymentPending : PaymentReceived
TransactionActive --> Vending : PaymentReceived
Vending --> Idle : VendingCompleted

[*] --> Idle
@enduml
```

> 💡 为了举例，上面的代码片段被简化了。实际的生成器输出有点冗长，但它呈现的是相同的图表。正确识别状态需要额外的详细信息，以避免嵌套状态之间的命名冲突。
>
> 如果您想要更高级的外观，请查看 LogicBlocks 存储库中各个包中的各种 `*.puml` 文件。这些文件由 LogicBlocks Generator 从包含的示例和测试用例中生成，用于验证 LogicBlocks 是否按预期工作。每个 `*.puml` 文件旁边都有一个 LogicBlock 源文件，该文件具有 `[StateMachine]` 属性，用于通知生成器创建图表代码。检查源代码，并将其与图表代码进行比较，以查看生成器在引擎盖下做了什么。

### 使用 PlantUML 查看图表

您可以将生成的 UML 复制并粘贴到 PlantText 中，以在线生成图表。

或者，您可以在本地安装 PlantUML 和/或使用 jebbs.PlantUML VSCode 扩展来呈现表示您的机器的 UML 状态图。

安装步骤（适用于 macOS）：

```shell
brew install graphviz
brew install plantuml

# To start your own PlantUML server:
java -jar /opt/homebrew/Cellar/plantuml/1.2023.9/libexec/plantuml.jar -picoweb
# ^ May need to change path above to match the version you installed.
# Try `brew info plantuml` to see where PlantUML is installed.
```

服务器运行后，您可以通过打开 VSCode 命令菜单并选择 “PlantUML: 预览当前图表”来预览图表。

## 🐛 故障排除

### 无法从具有未初始化上下文的逻辑块中获取值。

自 4.x 版本以来，LogicBlocks 延迟初始化上下文。上下文在 OnEnter/Exit/Attach/Detach 方法之外的构造函数中不可用。

错误：

```c#
public Active() {
  var value = Get<int>();
  OnEnter<Active>(
    (previous) => Context.Output(new Output.ValueChanged(value));
  );
}
```

正确：

```c#
public Active() {
  OnEnter<Active>(
    (previous) => {
      var value = Get<int>();
      Context.Output(new Output.ValueChanged(value));
    }
  );
}
```

## 📺 致谢

从概念上讲，逻辑块汲取了许多灵感：

### 📊 [状态图 Statecharts](https://statecharts.dev/)

正如状态图所描述的，逻辑块输出实际上只是[“动作”](https://statecharts.dev/glossary/action.html)。

输出提供了一种与逻辑块之外的世界通信的方式，而不会在逻辑块和正在听它说话的任何东西（如游戏引擎组件或视图）之间引入强耦合。

逻辑块状态也可以使用普通的面向对象编程模式，如继承和组合，来重新创建状态图的嵌套或层次性质。

### 🧊 [Bloc](https://bloclibrary.dev/#/)

逻辑块大量借鉴了 bloc 提出的约定：特别是 `On<TInput>` 风格的输入处理程序、基于继承的状态、`AddError` 和 `OnError`。

### 🎰 有限状态机。

逻辑块 API 在很大程度上受到 Moore 和 Mealy 状态机的启发。

根据转换定义逻辑是 Mealy 状态机的定义（见上文）。不幸的是，要求开发人员根据转换创建逻辑有点笨拙。通常，许多转换共享必须考虑在内的公共代码。忘记从每个相关转换调用共享代码会导致严重的逻辑错误。相反，逻辑块 API 包含在输入和退出时调用的自包含状态。然而，逻辑块确实提供了一种监视转换的方法，以便您可以在发生某些转换时产生输出，但它们不允许您在观察转换时更改状态。

# GodotEnv

https://github.com/chickensoft-games/GodotEnv

GodotEnv 是一个命令行工具，可以轻松地在 Godot 版本之间切换并管理项目中的插件。

GodotEnv 可以执行以下操作：

- ✅ 在 Windows、macOS 和 Linux 上从命令行下载、提取和安装 Godot 3.0/4.0+ 版本（类似于 NVM、FVM、asdf 等工具）。
- ✅ 通过更新符号链接切换 Godot 的活动版本。
- ✅ 自动设置用户 `GODOT` 环境变量，该变量始终指向 Godot 的活动版本。
- ✅ 使用易于理解的 `addons.json` 文件，从本地路径、远程 git 存储库或符号链接在 Godot 项目中安装插件。不再与 git 子模块斗争！只要在 `addons.json` 文件发生更改时运行 `godotenv addons install` 即可。
- ✅ 在项目中自动创建和配置 `.gitignore`、`addons.json` 和 `addons/.editorconfig`，以便于管理插件。
- ✅ 允许插件使用平面依赖关系图声明对其他插件的依赖关系。

## 📦 安装

GodotEnv 是一个 .NET 命令行工具，可在 Windows、macOS 和 Linux 上运行。

```shell
dotnet tool install --global Chickensoft.GodotEnv
```

GodotEnv 使用本地 git 安装和 shell 中提供的其他进程，因此请确保已正确安装 git 并配置了本地 shell 环境。

> ⧉在 Windows 上，某些操作可能需要管理员权限，例如管理符号链接或编辑某些文件。在这种情况下，GodotEnv 应该提示您批准，某些操作会导致命令行窗口在消失前弹出一段时间——这是正常的。

## 快速入门

我们将在下面深入了解这些命令，但如果您想立即开始，可以将 `--help` 标志与任何命令一起使用以获取更多信息。

```shell
# Overall help
godotenv --help

# Help for entire categories of commands
godotenv godot --help
godotenv addons --help

# Help for a specific godot management command
godotenv godot install --help

# etc...
```

## 🤖 Godot 版本管理

GodotEnv 可以自动为您管理本地机器上的 Godot 版本。

> 🙋‍♀️ 使用 GodotEnv 安装 Godot 最适合本地开发。如果您想出于 CI/CD 目的直接在 GitHub 操作运行程序上安装 Godot，请考虑使用 Chickensoft 的 [setup-godot](https://github.com/chickensoft-games/setup-godot) 操作——它在运行之间缓存 Godot 安装，安装 Godot 导出模板，也适用于 Windows、macOS 和 Ubuntu GitHub 运行程序。

### 安装 Godot

要开始使用 GodotEnv 管理 Godot 版本，您需要首先指示 GodotEnw 安装 Godot 的一个版本。

```shell
godotenv godot install 4.0.1
# or a non-stable version:
godotenv godot install 4.1.1-rc.1
```

版本应与 [GodotSharp nuget 包](https://www.nuget.org/packages/GodotSharp/)上显示的版本的格式相匹配。下载来自 [GitHub Release Builds](https://github.com/godotengine/godot-builds/releases)。

默认情况下，GodotEnv 会安装 .NET 支持的 Godot 版本。

如果你真的必须安装无聊的，非 .NET 版本的 Godot，您可以这样做😢.

```shell
godotenv godot install 4.0.1 --no-dotnet
```

安装 Godot 版本时，GodotEnv 会执行以下步骤：

- 📦 下载 Godot 安装 zip 档案（如果尚未下载）。
- 🤐 提取 Godot 安装 zip 存档。
- 📂 通过更新符号链接激活新安装的版本。
- 🏝 确保用户 `GODOT` 环境变量指向活动的 Godot 版本符号链接。

### 列出 Godot 版本

GodotEnv 可以向您显示已安装的 Godot 版本的列表。

```shell
godotenv godot list
```

根据您所安装的内容，可能会产生如下结果：

```
4.0.1
4.0.1 *dotnet
4.1.1-rc.1
4.1.1-rc.1 *dotnet
```

### 列出可用的 Godot 版本

GodotEnv 还支持显示可使用 `-r` 选项安装的远程 Godot 版本的列表。

```shell
godotenv godot list -r
```

### 使用不同的 Godot 版本

您可以通过指示 GodotEnv 将符号链接更新为已安装的版本之一来更改 Godot 的活动版本。默认情况下，它只查找 .NET 支持的 Godot 版本。使用非 .NET 版本的 Godot，指定 `--no-dotnet`。

```shell
# uses dotnet version
godotenv godot use 4.0.1

# uses non-dotnet version
godotenv godot use 4.0.1 --no-dotnet
```

### 卸载 Godot 版本

卸载的工作方式与安装和切换版本的工作方式相同。

```shell
# uninstalls .NET version
godotenv godot uninstall 4.0.1

# uninstalls not-dotnet version
godotenv godot uninstall 4.0.1 --no-dotnet
```

### 获取符号链接路径

GodotEnv 可以提供指向符号链接的路径，该符号链接始终指向 Godot 的活动版本。

```shell
godotenv godot env path
```

### 获取活动 Godot 版本路径

GodotEnv 将为您提供其使用的符号链接当前指向的 Godot 活动版本的路径。

```shell
godotenv godot env target
```

### 获取和设置 GODOT 环境变量

您可以使用 GodotEnv 将 `GODOT` 用户环境变量设置为符号链接，该符号链接始终指向 Godot 的活动版本。

```shell
# Set the GODOT environment variable to the symlink that GodotEnv maintains.
godotenv godot env setup

# Print the value of the GODOT environment variable.
godotenv godot env get
```

> 在 Windows 上，这会将 `GODOT` 环境变量添加到当前用户的环境变量配置中。
>
> 在 macOS 上，这会将 `GODOT` 环境变量添加到当前用户的默认 shell 配置文件中。如果用户的 shell 不兼容，则默认为 `zsh`。
>
> 在 Linux 上，这会将 `GODOT` 环境变量添加到当前用户的默认 shell 配置文件中。如果用户的 shell 不兼容，则默认为 `bash`。
>
> 在对任何系统上的环境变量进行更改后，请确保关闭任何打开的终端并打开一个新的终端，以确保更改被接受。如果在其他应用程序中没有发现更改，您可能必须注销并重新登录。幸运的是，由于环境变量指向指向活动 Godot 版本的符号链接，因此您只需执行一次！之后，您可以随意切换 Godot 版本，而不会有任何进一步的头痛。

### 🧼 清除 Godot 安装程序下载缓存

GodotEnv 将下载的 Godot 安装 zip 档案缓存在缓存文件夹中。您可以要求 GodotEnv 为您清除缓存文件夹。

```shell
godotenv cache clear
```

## 🔌 加载项管理

GodotEnv 允许您安装 [Godot 插件](https://godotengine.org/asset-library/asset)。Godot 插件是可以复制到项目中的 Godot 资产和/或脚本的集合。[按照惯例](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html#style-guide)，这些存储在与 Godot 项目相关的名为 `addons` 的文件夹中。查看 [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) 插件，了解 Godot 插件本身的结构。

除了从远程源复制插件外，GodotEnv 还允许您从本地 git 存储库或符号链接将插件安装到机器上的本地目录，以便您可以跨多个 Godot 项目开发插件。

使用 GodotEnv 管理插件可以避免在使用 git 子模块或手动管理符号链接时出现的一些麻烦。

> 此外，在项目中重新安装插件之前，GodotEnv 将检查对插件内容文件的意外修改，以防止覆盖您所做的更改。它通过将非符号链接的插件转换为自己的临时 git 存储库，并在卸载和重新安装之前检查更改来实现这一点。

### 何时使用 Godot 加载项

如果您使用 C#，您有两种共享代码的方式：Godot 插件和 nuget 包。每种方法都应用于不同的场景。

- 🔌 **插件**允许在多个 Godot 项目中重用场景、脚本或任何其他 Godot 资产和文件。
- 📦 **Nuget 包**只允许将 C# 代码绑定到一个库中，该库可以在多个 Godot 项目中使用。

> 如果您只是在项目之间共享 C# 代码，则应该使用 nuget 包或在本地引用另一个 .csproj。如果您需要共享场景、资源或任何其他类型的文件，请使用 Godot 插件。

#### 为什么要为 Godot 使用插件管理器？

Godot 项目中的插件管理历来存在一些问题：

- 如果您将一个插件复制并粘贴到多个项目中，然后在其中一个项目中修改该插件，则其他项目将不会得到您所做的任何更新。项目之间重复的代码会导致代码不同步，让开发人员感到沮丧，并忘记哪一个是最新的。
- 如果你想在项目之间共享插件，你可能会想使用 git 子模块。不幸的是，在切换分支时，git 子模块可能非常麻烦，您必须注意您签出的是哪一个提交。众所周知，子模块使用起来并不友好，甚至在经验丰富的开发人员使用时也可能非常脆弱。
- GodotEnv 允许插件声明对其他插件的依赖关系。虽然这不是一个常见的用例，但在解决平面依赖关系图中的插件时，它仍然会检查各种类型的冲突，并在检测到任何潜在问题时发出警告。

使用 `addons.json` 文件，开发人员可以声明他们的项目需要哪些插件，然后忘记如何获得它们。每当 `addons.json` 文件在分支之间发生变化时，您只需通过运行 `godotenv addons install` 来重新安装这些插件，一切都会“正常工作”。此外，很容易看到哪些插件随着时间的推移和不同分支之间发生了变化——只需检查 `addons.josn` 文件的 git diff 即可。

### 在项目中初始化 GodotEnv

GodotEnv 需要告诉 git 忽略你的插件目录，这样它就可以管理插件了。此外，它将在插件目录中放置一个 `.editorconfig`，它将抑制 C# 代码分析警告，因为 C# 样式往往差异很大。

```shell
godotenv addons init
```

这将向你的 .gitignore 文件中添加如下内容：

```shell
# Ignore all addons since they are managed by GodotEnv:
addons/*

# Don't ignore the editorconfig file in the addons directory.
!addons/.editorconfig
```

`addons init` 命令还将在您的 `addons` 目录中创建一个 `.editorconfig`，其中包含以下内容：

```properties
[*.cs]
generated_code = true
```

最后，GodotEnv 将创建一个示例 `addons.jsonc` 文件，其中包含以下内容，让您开始学习：

```json
// Godot addons configuration file for use with the GodotEnv tool.
// See https://github.com/chickensoft-games/GodotEnv for more info.
// -------------------------------------------------------------------- //
// Note: this is a JSONC file, so you can use comments!
// If using Rider, see https://youtrack.jetbrains.com/issue/RIDER-41716
// for any issues with JSONC.
// -------------------------------------------------------------------- //
{
  "$schema": "https://chickensoft.games/schemas/addons.schema.json",
  // "path": "addons", // default
  // "cache": ".addons", // default
  "addons": {
    "imrp": { // name must match the folder name in the repository
      "url": "https://github.com/MakovWait/improved_resource_picker",
      // "source": "remote", // default
      // "checkout": "main", // default
      "subfolder": "addons/imrp"
    }
  }
}
```

### 安装插件

GodotEnv 将使用系统 shell 从符号链接、本地路径或远程 git url 安装插件。请确保您已经在 shell 环境中配置了 git 以使用任何所需的凭据，因为 git 将用于克隆本地和远程存储库。

```shell
godotenv addons install
```

当您在 GodotEnv 中运行插件安装命令时，它会**在 shell 的当前工作目录**中查找 `addons.json` 或 [`addons.jsonc`](https://code.visualstudio.com/docs/languages/json#_json-with-comments) 文件。插件文件告诉 GodotEnv 应该在项目中安装哪些插件。

这里有一个示例插件文件，它安装了 3 个插件，每个插件来自不同的源（远程 git 存储库、本地 git 存储库和符号链接）。

```json
{
  "path": "addons", // optional — this is the default
  "cache": ".addons", // optional — this is the default
  "addons": {
    "godot_dialogue_manager": {
      "url": "https://github.com/nathanhoad/godot_dialogue_manager.git",
      "source": "remote", // optional — this is the default
      "checkout": "main", // optional — this is the default
      "subfolder": "addons/dialogue_manager" // optional — defaults to "/"
    },
    "my_local_addon_repo": {
      "url": "../my_addons/my_local_addon_repo",
      "source": "local"
    },
    "my_symlinked_addon": {
      "url": "/drive/path/to/addon",
      "source": "symlink"
    }
  }
}
```

> ❗️ 上面 `addons` 字典中的每个键都必须是项目插件路径中已安装插件的目录名。也就是说，如果插件存储库在 `addons/my_addon` 中包含其插件内容，则插件文件中插件的密钥名称必须为 `my_addon`。

### 本地插件

如果您想从机器上的本地路径安装插件，则本地插件必须是 git 存储库。您可以将 `url` 指定为相对或绝对文件路径。

```json
{
  "addons": {
    "local_addon": {
      "url": "../my_addons/local_addon",
      "checkout": "main",
      "subfolder": "/",
      "source": "local"
    },
    "other_local_addon": {
      "url": "/Users/me/my_addons/other_local_addon",
      "source": "local"
    },
  }
}
```

### 远程插件

GodotEnv 可以从远程 git 存储库安装插件。以下是来自远程 git 存储库的插件的插件规范。url 可以是任何有效的 git 远程 url。

```json
{
  "addons": {
    "remote_addon": {
      "url": "git@github.com:user/remote_addon.git",
      "subfolder": "addons/remote_addon"
    }
  }
}
```

默认情况下，GodotEnv 假设插件 `source` 是 `remote`，`checkout` 引用是 `main`，并且要安装的`子文件夹`是存储库的 root `/`。如果需要自定义这些字段中的任何一个，可以覆盖默认值：

```json
{
  "addons": {
    "remote_addon": {
      "url": "git@github.com:user/remote_addon.git",
      "source": "remote",
      "checkout": "master",
      "subfolder": "subfolder/inside/repo",
    }
  }
}
```

### 符号链接插件

最后，GodotEnv 可以使用符号链接“安装”插件。使用符号链接安装的插件不需要指向 git 存储库——相反，GodotEnv 将创建一个文件夹，使用符号链接“指向”文件系统上的另一个文件夹。

```json
  "addons": {
    "my_symlink_addon": {
      "url": "/Users/myself/Desktop/folder",
      "source": "symlink"
    },
    "my_second_symlink_addon": {
      "url": "../../some/other/folder",
      "source": "symlink",
      "subfolder": "some_subfolder"
    }
  }
```

> 注意：使用符号链接时会忽略 `checkout` 引用。

每当符号链接的插件被修改时，这些更改都会立即出现在项目中，这与 git 存储库中包含的插件不同。此外，如果您更改游戏项目中的插件，它会更新符号链接所指向的插件源。

> 使用符号链接是在一个或多个项目中包含仍在开发中的插件的好方法。

### 插件配置

GodotEnv 将本地和远程插件缓存在 `cache` 文件夹中，如上所述，使用 `addons.json` 文件中的缓存属性进行配置（相对于您的项目，默认值为 `.addons/`）。您可以安全地删除此文件夹，GodotEnv 将在下次安装插件时重新创建它。删除缓存会迫使 GodotEnv 在下次安装时重新下载或复制所有内容。

> **重要**：请确保将 `.addons/cache` 文件夹添加到 `.gitignore` 文件中！

GodotEnv 会将插件安装到 `addons.json` 文件中路径键指定的目录中（默认为 `addons/`）。

应从源代码管理中省略加载项。如果您需要在处理 Godot 项目的同时处理一个插件，请使用 GodotEnv 符号链接该插件。通过从源代码管理中省略插件文件夹，您可以有效地将插件视为不可变的包，就像 NPM 对 JavaScript 所做的那样。

只需在克隆项目后或在您的 `addons.json` 文件发生更改时运行 `godotenv addons install` 即可！

### 插件的插件

插件本身可以包含一个 `addons.json` 文件，该文件声明对其他插件的依赖关系。在插件解析过程中缓存插件时，GodotEnv 会检查它是否也包含一个 `addons.json` 文件。如果是，GodotEnv 将把它的依赖项添加到队列中，并继续进行插件解析。如果 GodotEnv 检测到潜在冲突，它将输出警告，解释当前配置可能出现的任何潜在陷阱。

GodotEnv 使用了一个平面依赖图，这让人想起了 [bower](https://bower.io/) 等工具。一般来说，GodotEnv 会尽量宽容和乐于助人，尤其是当您试图在不兼容的配置中包含插件时。GodotEnv 将尽可能清楚地显示警告和错误，以帮助您解决可能出现的任何潜在冲突场景。

## 贡献

如果您想贡献，请查看 [`CONTRIBUTING.md`](https://github.com/chickensoft-games/GodotEnv/blob/main/CONTRIBUTING.md)！

虽然插件安装逻辑经过了很好的测试，但 Godot 版本管理功能是新的，仍然需要测试。目前，GitHub 工作流对其进行端到端测试。随着时间的推移，我将添加更多的单元测试。

# Chickensoft.GodotPackage

https://github.com/chickensoft-games/GodotPackage

一个 .NET模板，用于快速创建用于 Godot 4 的 C# nuget 包。

## 🥚 入门

该模板允许您轻松创建一个 nuget 包，用于 Godot 4 C# 项目。Microsoft 的 dotnet 工具允许您轻松创建、安装和使用模板。

```shell
# Install this template
dotnet new --install Chickensoft.GodotPackage

# Generate a new project based on this template
dotnet new chickenpackage --name "MyPackageName" --param:author "My Name"

# Use Godot to generate files needed to compile the package's test project.
cd MyPackageName/MyPackageName.Tests/
$GODOT --headless --build-solutions --quit
dotnet build
```

## 💁 获取帮助

*这个模板坏了吗？遇到晦涩难懂的 C# 构建问题？*我们很乐意在 Chickensoft Discord 服务器上为您提供帮助。

## 🏝 环境设置

为了使提供的调试配置和测试覆盖率正常工作，必须正确设置开发环境。Chickensoft 安装文档描述了如何按照 Chickensoft 的最佳实践设置 Godot 和 C# 开发环境。

### VSCode 设置

此模板在 `.vscode/settings.json` 中包含一些 Visual Studio 代码设置。这些设置有助于 Windows（Git-Bash、PowerShell、命令提示符）和 macOS（zsh）上的终端环境，并修复 Omnisharp 遇到的一些语法着色问题。您还可以在 Omnisharp 和 .NET Roslyn 分析器中找到启用编辑器配置支持的设置，以获得更愉快的编码体验。

请仔细检查提供的 VSCode 设置是否与您的现有设置不冲突。

### .NET 版本控制

包含的 [`global.json`](https://github.com/chickensoft-games/GodotPackage/blob/main/global.json) 指定的版本 .NET SDK。它还指定了包含的测试项目应该使用的 `Godot.NET.Sdk` 版本（因为测试在实际的 Godot 游戏中运行，所以您可以使用完整的 Godot API 来验证您的包是否按预期工作）。

## 🐞 调试

您可以通过在 VSCode 中打开此存储库的根目录并选择其中一个启动配置：`Debug Tests` 或 `Debug Current Test`，调试在 `Chickensoft.GodotPackage.Tests/` 包中包含的测试项目。

> 要使启动配置文件 `Debug Current Test` 正常工作，测试文件必须与其内部的测试类共享相同的名称。例如，名为 `PackageTest` 的测试类必须位于名为 `PackageTest.cs` 的测试文件中。

启动配置文件将触发一个构建（不恢复包），然后发出指示 .NET 来运行 Godot 4（同时与 VSCode 通信以进行交互式调试）。

> **重要**：您必须为上述启动配置设置 `GODOT` 环境变量。如果您正在使用 [GodotEnv](https://github.com/chickensoft-games/GodotEnv) 安装和管理 Godot 版本，那么您已经安装好了！有关更多信息，请参阅 Chickensoft 安装文档。

## 👷 测试

默认情况下，`Chickensoft.GodotPackage.Tests/` 中的一个测试项目是为您的包编写测试而创建的。[GoDotTest](https://github.com/chickensoft-games/go_dot_test) 已经包含并设置好了，让您可以专注于开发和测试。

[GoDotTest](https://github.com/chickensoft-games/go_dot_test) 是 Godot 和 C# 的一个易于使用的测试框架，允许您从命令行运行测试、收集代码覆盖率以及在 VSCode 中调试测试。

该项目被配置为允许从 VSCode 轻松运行和调试测试，或通过 CI/CD 工作流执行测试，而不必在最终版本构建中包括测试文件或测试依赖项。

`Main.tscn` 和 `Main.cs` 场景和脚本文件是游戏的入口点。一般来说，除非你在做一些高度定制的事情，否则你可能不需要修改这些。如果游戏不是在测试模式下运行（或者是发布版本），它会立即将场景更改为 `game/Game.tscn`。一般来说，比起 `Main.tscn`，更喜欢编辑 `game/Game.tscn`。如果使用 `--run-tests` 命令行参数运行 Godot，则游戏将运行测试，而不是切换到位于 `game/Game.tscn` 的游戏场景。`.vscode/launch.json` 中提供的调试配置允许您轻松调试测试（或者仅调试当前打开的测试，前提是其文件名与其类名匹配）。

有关更多示例，请参阅 `test/ExampleTest.cs` 和 [GoDotTest](https://github.com/chickensoft-games/go_dot_test) 自述文件。

## 🚦 测试覆盖范围

代码覆盖率要求首先安装一些 `dotnet` 全局工具。您应该从项目目录的根目录安装这些工具。

```shell
dotnet tool install --global coverlet.console
dotnet tool update --global coverlet.console
dotnet tool install --global dotnet-reportgenerator-globaltool
dotnet tool update --global dotnet-reportgenerator-globaltool
```

> 在 Apple Silicon 计算机上运行全局工具的 `dotnet tool update` 通常是必要的，以确保工具安装正确。

您可以通过在 `test/coverage.sh` 中运行 bash 脚本来收集代码覆盖率并生成覆盖率徽章（在 Windows 上，您可以使用 Git 附带的 Git Bash shell）。

```shell
# Must give coverage script permission to run the first time it is used.
chmod +x test/.coverage.sh

# Run code coverage:
cd Chickensoft.GodotPackage.Tests
./coverage.sh
```

您也可以通过 VSCode 运行测试覆盖率，方法是打开命令选项板并 `Tasks: Run Task`，然后选择 `coverage`。

## 🏭 CI/CD

此软件包包括各种 GitHub Actions 工作流，使您的软件包的开发和部署更加容易。

### 🚥 测验

对每个到存储库的推送或拉取请求都会运行测试。您可以在 [`.github/workflows/tests.yaml`](https://github.com/chickensoft-games/GodotPackage/blob/main/.github/workflows/tests.yaml) 中配置要在哪些平台上运行测试。

默认情况下，测试使用 Godot 4 的最新测试版运行每个平台（macOS、Windows 和 Linux）。

测试是通过从命令行运行在 `Chickensoft.GodotPackage.Tests` 中的 Godot 测试项目来执行的，并将相关参数传递给 Godot，以便 GoDotTest 可以发现并运行测试。

### 🧑‍🏫 拼写检查

对每个到存储库的推送或拉取请求都会进行拼写检查。拼写检查设置可以在 [`.github/workflows/Spellcheck.yaml`](https://github.com/chickensoft-games/GodotPackage/blob/main/.github/workflows/spellcheck.yaml) 中配置

建议使用 VSCode 的代码拼写检查器插件来帮助您在提交拼写错误之前发现拼写错误。如果需要向字典中添加单词，可以将其添加到 `cspell.json` 文件中。

您也可以通过将鼠标悬停在拼写错误的单词上并选择 `Quick Fix…` 来从 VSCode 向本地 `cspell.json` 文件添加单词。。。然后 `Add "{word}" to config: GodotPackage/cspell.json`。

### 📦 发布

当您准备好制作新版本时，可以手动调度 [`.github/workflows/release.yaml`](https://github.com/chickensoft-games/GodotPackage/blob/main/.github/workflows/publish.yaml) 中包含的工作流。一旦您为版本提升策略指定了 `major`、`minor` 或 `patch`，工作流将使用更新的版本构建您的包，并在 GitHub 和 nuget 上发布。

如果附带的 [`.github/workflows/auto_release.yaml`](https://github.com/chickensoft-games/GodotPackage/blob/main/.github/workflows/auto_release.yaml) 检测到一个新的提交，它将触发发布工作流，该提交是来自 renvatebot 的例行依赖项更新。由于 Renovatebot 被配置为自动合并依赖项更新，当 Godot.NET.Sdk 的新版本已发布或您所依赖的其他软件包已更新时，您的包将自动发布到 Nuget。如果不希望出现这种行为，请从 [`renovae.json`](https://github.com/chickensoft-games/GodotPackage/blob/main/renovate.json) 中删除 `"automerge": true` 属性。

> 要发布到 nuget，您需要在 GitHub 中配置一个名为 `NUGET_API_KEY` 的存储库或组织机密，其中包含您的Nuget API 密钥。请确保将 `NUGET_API_KEY` 设置为**密钥（secret）**（而不是环境变量）以确保其安全！

### 🏚 Renovatebot

此存储库包括一个用于 [Renovatebot](https://www.mend.io/free-developer-tools/renovate/) 的 [`renovate.json`](https://github.com/chickensoft-games/GodotPackage/blob/main/renovate.json) 配置。Renovatebot 可以自动打开和合并拉取请求，以帮助您在检测到新的依赖关系版本发布时保持依赖关系的最新状态。

> 与 Dependabot 不同，Renovatebot 能够将所有依赖项更新合并为一个拉取请求，这是 Godot C# 存储库的必备功能，每个子项目都需要相同的 Godot.NET.Sdk 版本。如果在多个存储库中拆分依赖关系版本冲突，则 CI 中的构建将失败。

将 Renovatebot 添加到存储库的最简单方法是[从 GitHub Marketplace 安装它](https://github.com/apps/renovate)。请注意，您必须授予它对您希望它监视的每个组织和存储库的访问权限。

所包含的 `renovate.json` 包括一些配置选项，以限制 Renovatebot 打开拉取请求的频率，以及 regex 过滤掉一些版本不好的依赖项以防止无效的依赖项版本更新。

如果您的项目设置为在合并拉取请求之前需要批准，并且您希望利用 Renovatebot 的自动合并功能，则可以安装 [Renovate Approve](https://github.com/apps/renovate-approve) 机器人程序来自动批准Renovate依赖关系PR。如果您需要两个批准，则可以安装相同的 [Renovate Approve 2](https://github.com/apps/renovate-approve-2) 机器人程序。有关详细信息，请参阅[此部分](https://stackoverflow.com/a/66575885)。