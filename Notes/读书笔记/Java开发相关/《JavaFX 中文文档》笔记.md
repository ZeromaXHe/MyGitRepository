来源：http://www.javafxchina.net/blog/docs/tutorial1/

翻译来源：https://docs.oracle.com/javase/8/javase-clienttechnologies.htm

# 第一篇 开始学习JavaFX

## 有何新特性

本章对JavaSE 8中JavaFX组件的新特性和重大产品改变进行了概述。

- JavaFX应用程序的默认主题是新设计的Modena主题。详见“关键特性”一节中的Modena主题部分。
- 已经加入了对HTML5的支持。详见“向JavaFX应用程序中添加HTML内容”相关章节。
- 新添加的SwingNode类改进了与Swing的互操作性。参考“在JavaFX应用程序中嵌入Swing内容”相关章节。
- 新的内置UI控件，DatePicker和TableView，已经可用。参考《使用JavaFX UI控件》一文来获得更多信息。
- 3D图形库被改进了，增加了一些新的API类。参考“关键特性”一节中的3D图形特性部分和“开始使用JavaFX 3D图形”章节来获得更多信息。
- print包现在是可用的，并且提供了公开的JavaFX打印API
- 加入了富本文支持
- 对Hi-DPI显示的支持已经变得可用了
- CSS样式类变成了公开API
- 引入了调度服务类

## 第一部分 什么是JavaFX

### JavaFX概览

#### 关键特性

下面的特性都被包含在了JavaFX8及以后发布版本中。在JavaFX8中引入的内容包括：

- Java API：JavaFX是一个Java库，包括用Java写成的类和接口。其API对基于JVM的语言也是友好的，例如JRuby和Scala。
- FXML和Scene Builder：FXML是一种基于XML的声明式标记语言，用于描述JavaFX应用程序的用户界面。设计师可以在FXML中编码或者使用JavaFX Scene Builder来交互式地设计图形用户接口（GUI）。Scene Builder所生成的FXML标记可以与IDE对接，这样开发者可以添加业务逻辑。
- WebView：它是一个使用了WebKitHTML技术的Web组件，可用于在JavaFX应用程序中嵌入Web页面。在WebView中运行的JavaScript可以方便地调用JavaAPI，并且JavaAPI也可以调用WebView中的JavaScript。对附加的HTML5特性的支持，包括Web Socket、Web Worker、Web Font、打印功能等都被添加到了JavaFX8中。参考《增加HTML内容到JavaFX应用程序中（Adding HTML Content to JavaFX Applications）》章节来了解更多信息。
- 与Swing互操作：现有的Swing程序可以通过JavaFX的新特性升级，例如多媒体播放和Web 内容嵌入。在JavaFX8中加入了SwingNode类，它可以将Swing内容嵌入到JavaFX程序中。参考SwingNode API Javadoc和《在JavaFX应用程序中嵌入Swing 内容（Embedding Swing Content in JavaFX Applications）》章节来了解更多信息。
- 内置的UI控件和CSS：JavaFX提供了开发一个全功能应用程序所需的所有主要控件。这些组件可以使用标准的Web技术如CSS来进行装饰。在JavaFX8中，DatePicker和TreeView UI控件是可用的，并且可以使用标准的Web技术如CSS来进行美化。参考《使用JavaFX UI控件（Using JavaFX UI Controls）》章节来了解更多信息。另外CSS样式控制类都变成了公开API，它们可以使用CSS来为对象增加样式。
- Modena主题：在JavaFX8中，提供了新的Modena主题来替换原来的Caspian主题。不过在Application的start()方法中，可以通过加入setUserAgentStylesheet(STYLESHEET_CASPIAN)代码行来继续使用Caspian主题。
- 3D图像处理能力：在JavaFX8中的3D图像处理API中加入了一些新的API，包括Shape3D (Box, Cylinder, MeshView和Sphere 子类)，SubScene, Material, PickResult, LightBase (AmbientLight 和PointLight子类)，SceneAntialiasing等。在本次发布中Camera类API也得到了更新。要了解更多信息，可以参考《开始学习JavaFX 3D图形（Getting Started with JavaFX 3D Graphics）》文档和对应的JavaDoc，包括scene.shape.Shape3D，javafx.scene.SubScene，javafx.scene.paint.Material，javafx.scene.input.PickResult和javafx.scene.SceneAntialiasing。
- Canvas API：Canvas API允许在由一个图形元素（node）组成的JavaFX场景（Scene）的一个区域中直接绘图。
- Printing API：JavaFX 8中加入了print包并且提供了打印功能公共类。
- Rich Text支持:JavaFX提供了更为强大的文本支持能力，包括双向文字（例如阿拉伯语）、复杂文字脚本，例如Thai、Hindu文字，并且支持多行、多种风格的文本节点。
- 多点触摸：基于底层平台的功能JavaFX提供了对多点触摸的支持。
- Hi-DPI支持：JavaFX 8现在支持Hi-DPI显示。
- 图形渲染硬件加速：JavaFX图像均基于图形渲染流水线（Prism）。JavaFX提供更为平滑的图像并且在显卡或图像处理单元（Graphics processing unit，GPU）支持的情况下通过Prism来获得更快的渲染速度。如果GPU不支持对应的图形处理功能，则Prism会使用软件渲染方式来替代。
- 高性能多媒体引擎：媒体流水线支持对Web媒体内容的播放。它提供了一个基于GStreamer多媒体框架的稳定、低延迟的多媒体处理框架。
- 自包含的应用部署模型：自包含应用包具有应用所需的所有资源、包括一个Java和JavaFX运行时的私有拷贝。它们可作为操作系统原生安装包发布，并提供与原生应用相同的安装和运行体验。

### 理解JavaFX架构

~~~mermaid
graph TB
	javafx[JavaFX Public APIs and Scene Graph] --> quantum[Quantum Toolkit]
	quantum --> prism[Prism]
	quantum --> glass[Glass Windowing Toolkit]
	quantum --> media[Media Engine]
	quantum --> web[Web Engine]
	prism --> 2d[Java 2D]
	prism --> opengl[OpenGL]
	prism --> d3d[D3D]
	2d --> jdk[JDK API Libraries & Tools]
	opengl --> jdk
	d3d --> jdk
	glass ---> jdk
	media ---> jdk
	web ---> jdk
	jdk --> jvm[Java Virtual Machine]
~~~

图2-1说明了JavaFX平台的组件架构。后面的章节将会对每个组件及其之间的联系进行说明。在JavaFX公开的API之下JavaFX代码运行引擎。它由几大部分组成：一个JavaFX 高性能图形引擎，名为Prism；一个简洁高效的窗体系统，名为Glass；一个媒体引擎；一个web引擎。尽管这些组件并没有公开对外暴露，但是下面的描述将有助于你理解一个JavaFX应用是如何运行的。

- 场景图(Scene Graph)
- JavaFX功能的公开API(Java Public APIs for JavaFX Features)
- 图形系统(Graphics System)
- Glass窗体工具包(Glass Windowing Toolkit)
- 多媒体和图像(Media and Images)
- Web组件(Web Component)
- CSS
- UI控件(UI Controls)
- 布局(Layout)
- 2-D和3-D转换(2-D and 3-D Transformations)
- 视觉特效(Visual Effects)

#### 场景图

JavaFX场景图(Scene Graph)位于图2-1中的顶层部分，它是构建JavaFX应用的入口。它是一个层级结构的节点树，表示了所有用户界面的视觉元素。它可以处理输入，并且可以被渲染。

在场景图中的一个元素被称为一个节点(Node)。每个节点都有一个ID、样式类和包围盒(bounding volume)。除了根节点之外，在场景图中的所有节点都有一个父节点、0个或多个子节点。节点还可以有如下特性：

- 效果(Effects)，例如模糊和阴影
- 不透明度(Opacity)
- 变换(Transforms)
- 事件处理器(Event handlers，例如鼠标、键盘和输入法)
- 应用相关的状态(Application-specific state)

与Swing和AWT不同，JavaFX场景图还包括图元，例如矩形、文本，还有控件、布局容器、图像、多媒体。

对于大多数用户来说，场景图简化了UI设计，尤其是对富客户端应用来说。对场景图中使用动画可以很容易地通过javafx.animation API和声明式方法(例如XML文档)来实现。

javafx.scene API允许创建和定义各种内容，例如：

- 节点(Nodes)：包括各种形状(2D或3D)、图像、多媒体、内嵌的Web浏览器、文本、UI控件、图表、组和容器
- 状态(State)：变换(节点的定位和定向)、视觉效果、以及内容的其它视觉状态。
- 效果(Effects)：可以改变场景图节点的外观的简单对象。例如模糊、阴影、图像调整。

# 第二篇 使用JavaFX图形

# 第三篇 使用JavaFX UI组件

