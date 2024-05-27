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

