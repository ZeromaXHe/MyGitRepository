# Java 9

尚硅谷Java教程_Java9新特性教程 2018-03-21 16:36:53

https://www.bilibili.com/video/BV17W411g7eK

## P1 课程目录结构

## P2 储备知识

## P3 新特性和后续版本迭代

Java 9 提供了超过 150 项新功能特性，包括备受期待的模块化系统、可交互的 REPL 工具：jshell，JDK 编译工具，Java 公共 API 和私有代码，以及安全增强、扩展提升、性能管理改善等。

可以说 Java 9 是一个庞大的系统工程，完全做了一个整体改变

具体来讲：

- 红色：
  - 模块化系统
  - jShell 命令

- 多版本兼容 jar 包
- 绿色（语法层面改进）：
  - 接口的私有方法
  - 钻石操作符的使用升级
  - 语法改进：try 语句
  - 下划线使用限制
- 黄色（API 层面改进）
  - String 存储结构变更
  - 便利的集合特性：of()
  - 增强的 Stream API
  - 多分辨率图像 API
  - 全新的 HTTP 客户端 API
  - Deprecated 的相关 API
- 智能 Java 编译工具
- 统一的 JVM 日志系统
- javadoc 的 HTML 5 支持
- Javascript 引擎升级：Nashorn
- java 的动态编译器

## P4 jdk 9 的下载安装及环境变量配置

跳过

## P5 帮助文档和 JEP_JSR 概念

- JEP（JDK Enhancement Proposals）：jdk 改进提案，每当需要有新的设想的时候，JEP 可以在 JCP（java community Process）之前或者同时提出非正式的规范（specification），被正式认可的 JEP 正式写进 JDK 的发展路线图并分配版本号。
- JSR（Java Specification Requests）：java 规范提案，新特性的规范出现在这一阶段，是指向 JCP（Java Community Process）提出新增一个标准化技术规范的正式请求。请求可以来自于小组/项目、JEP、JCP 成员或者 java 社区（community）成员的提案，每个 java 版本都由相应的 JSR 支持。
  - 小组：对特定技术内容，比如安全、网络、HotSpot 等有共同兴趣的组织和个人
  - 项目：编写代码、文档以及其他工作，至少由一个小组赞助和支持，比如最近的 Lambda 计划，JigSaw 计划等

## P6 新特性1：jdk 8 和 jdk 9 中 jdk 目录结构的变化

JDK：Java Development Kit（Java 开发工具包）

JRE：Java Runtime Environment（Java 运行环境）

说明：

- JDK = JRE + 开发工具集（例如 javac 编译工具等）
- JRE = JVM + Java SE 标准类库



JDK 8 的目录结构：

- bin
- include
- jre
  - bin
  - lib
- lib

JDK 9 的目录结构：

- bin
- conf
- include
- jmods
- legal
- lib

## P7 新特性2：模块化的特性概述

模块化系统：Jigsaw -> Modularity

### 2.1 官方 Feature

200：The Modular JDK

201：Modular Source Code

220：Modular Run-time Images

260：Encapsulate Most Internal APIs

261：Module System

282：jlink：The Java Linker

### 2.2 产生背景及意义

- 谈到 Java 9 大家往往第一个想到的就是 Jigsaw 项目。Java 相关生态在不断丰富的同时也越来越暴露出一些问题：
  - Java 运行环境的膨胀和臃肿。每次 JVM 启动的时候，至少会有 30 ~ 60 MB 的内存加载，主要原因是 JVM 需要加载 rt.jar，不过其中的类是否被 classloader 加载，第一步整个 jar 都会被 JVM 加载到内存当中去（而模块化可以根据模块的需要加载程序运行需要的 class）
  - 当代码库越来越大，创建复杂，盘根错节的“意大利面条式代码”的几率成指数级的增长。不同版本的类库交叉依赖导致让人头疼的问题，这些都阻碍了 Java 开发和运行效率的提升。
  - 很难真正地对代码进行封装，而系统并没有对不同部分（也就是 JAR 文件）之间的依赖关系有个明确的概念。每一个公共类都可以被类路径之下任何其他的公共类所访问到，这样就会导致无意中使用了并不想被公开访问的 API。
  - 类路径本身也存在问题：你怎么知晓所有需要的 JAR 都已经有了，或者是不是会有重复的项呢？
- 同时由于兼容性等各方面的掣肘，对 Java 进行大刀阔斧的革新越来越困难，Jigsaw 从 Java 7 阶段就开始筹备，Java 8 阶段进行了大量工作，终于在 Java 9 里落地。
- Jigsaw 项目（后期更名为 Modularity）的工作量和难度大大超出了初始规划。JSR 376 Java 平台模块化系统（JPMS，Java Platform Module System）作为 Jigsaw 项目的核心，其主体部分被分解成 6 个 JEP（JDK Enhancement Proposals）。
- 作为 Java 9 平台最大的一个特性，随着 Java 平台模块化系统的落地，开发人员无需再为不断膨胀的 Java 平台苦恼，例如，您可以使用 jlink 工具，根据需要定制运行时环境。这对于拥有大量镜像的容器应用场景或复杂依赖关系的大型应用等，都具有非常重要的意义。
- 本质上讲，模块（module）的概念，其实就是 package 外再裹一层，也就是说，用模块来管理各个 package，通过声明某个 package 暴露，不声明默认就是隐藏。因此，模块化使得代码组织上更安全，因为它可以指定哪些部分可以暴露，哪些部分隐藏。

### 2.3 设计理念

模块独立、化繁为简

模块化（以 Java 平台模块系统的形式）将 JDK 分为一组模块，可以在编译时，运行时或者构建时进行组合。

### 2.4 实现目标

- 主要目的在于减少内存的开销
- 只需必要模块，而非全部 jdk 模块，可简化各种类库和大型应用的开发和维护
- 改进 Java SE 平台，使其可以适应不同大小的计算设备
- 改进其安全性，可维护性，提高性能

## P8 模块化特性的代码实现

### 2.5 使用举例

模块将由通常的类和新的模块声明文件（module-info.java）组成。该文件是位于 java 代码结构的顶层，该模块描述符明确地定义了我们的模块需要什么依赖关系，以及哪些模块被外部使用。在 exports 子句中未提及的所有包默认情况下将封装在模块中，不能在外部使用。

```java
module java9demo {
    // 导出包
    exports com.atguigu.bean;
}
```

```java
module javatest {
    // 需要的 module
    requires java9demo;
}
```

## P9 新特性3：jshell 命令的使用

Java 的 REPL 工具：jShell 命令

```shell
jshell # 进入 jShell 环境
```

```shell
jshell> /imports # 显示导入的包
jshell> / # 按下 Tab 可以查看补全
jshell> /list # 显示还在生效的历史操作（重写方法的话会替换掉原来的）
jshell> /vars # 显示生效的变量
jshell> /methods # 显示生效的方法
jshell> /edit add # 使用外部编辑器来修改 add 方法
jshell> /edit # 使用外部编辑器来修改所有历史操作
jshell> /open E:\teach\Java9\HelloWorld.java # 打开并执行按 jshell 指令顺序写的文件
jshell> /exit # 退出
```

受检异常（编译时异常）会被 jShell 在后台为我们隐藏。

### 3.1 官方 Feature

222：jshell: The Java Shell (Read-Eval-Print Loop)

### 3.2 产生背景

像 Python 和 Scala 之类的语言早就有交互式编程环境 REPL(read-evaluate-print loop) 了，以交互式的方式对语句和表达式进行求值。开发者只需要输入一些代码，就可以在编译前获得对程序的反馈。而之前的 Java 版本想要执行代码，必须创建文件、声明类、提供测试方法方可实现

### 3.3 设计理念

即写即得、快速运行

## P10 新特性4：多版本兼容 jar 包的使用说明

### 4.1 官方 Feature

238：Multi-Release JAR Files

### 4.2 使用说明

当一个新版本的 Java 出现的时候，你的库用户要花费数年时间才会切换到这个新的版本。这就意味着库得去向后兼容你想要支持的最老的 Java 版本（许多情况下就是 Java 6 或者 Java 7）。这实际上意味着未来的很长一段时间，你都不能在库中运用 Java 9 所提供的新特性。幸运的是，多版本兼容 jar 功能能让你创建仅在特定版本的 Java 环境中运行库程序选择使用的 class 版本。

jar 包的 `META-INF/versions/9` 下有特别为 Java 9 准备的 class 版本，可以运用 Java 9 所提供的特性和库。

## P11 多版本兼容 jar 包的代码演示

打包：

- `javac -d build --release 8 src/main/java/com/atguigu/*.java`
- `javac -d build9 --release 9 src/main/java-9/com/atguigu/*.java`
- `jar --create --main-class=Application --file multijar.jar -C build . --release 9 -C build9 .`

## P12 新特性5：接口中定义私有方法

面试题：抽象类和接口的异同？

- 两者的定义：
  - 声明的方式
  - 内部的结构（jdk 7 全局常量和抽象方法, jdk 8 静态方法和默认方法, jdk 9 私有方法）
- 相同点：不能实例化；以多态的方式使用
- 不同点：单继承；多实现

### 5.1 官方 Feature

213：Milling Project Coin

### 5.2 使用说明

Java 8 中规定接口中的方法除了抽象方法之外，还可以**定义静态方法和默认方法**。一定程度上，扩展了接口的功能，此时的接口更像是一个抽象类。

在 Java 9 中，接口更加的灵活和强大，连方法的访问权限修饰符都可以声明为 private 的了，此时方法将不会成为你对外暴露的 API 的一部分。

## P13 新特性6：钻石操作符的使用升级

### 6.1 使用说明

我们能够与匿名实现类共同使用钻石操作符（diamond operator）

在 java 8 中如下操作是会报错的：

```java
private List<String> flattenStrings(List<String>... lists) {
    Set<String> set = new HashSet<>(){}; // 这里 <> 会报错
    for (List<String> list: lists) {
        set.addAll(list);
    }
    return new ArrayList<>(set);
}
```

## P14 新特性7：异常处理 try 结构的使用升级

### 7.1 使用举例

在 java 7 之前，我们习惯于这样处理资源的关闭：

```java
InputStreamReader reader = null;
try {
    reader = new InputStreamReader(System.in);
    // 流的操作
    reader.read();
} catch (IOException e) {
    e.printStackTrace();
} finally {
    // 资源的关闭操作
    if (reader != null) {
        try {
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

Java 7 以后：

```java
try (InputStreamReader reader = new InputStreamReader(System.in)) {
    // 读取数据的过程
    reader.read();
} catch (IOException e) {
    e.printStackTrace();
}
```

但之前要求资源对象的实例化必须放在 try 的括号内完成

Java 9 中可以在 try() 中调用已经实例化的资源对象

```java
InputStreamReader reader = new InputStreamReader(System.in);
OutputStreamReader writer = new OutputStreamReader(System.out);
try (reader; writer) {
    // 此时的 reader 是 final 的
    // 读取数据的过程
    reader.read();
} catch (IOException e) {
    e.printStackTrace();
}
```

## P15 新特性8：下划线命名标识符的限制

### 8.1 使用说明

在 Java 8 中，标识符可以独立使用 `_` 来命名

但是，在 Java 9 中规定 `_` 不再可以单独命名标识符了，如果使用，会报错

## P16 新特性9：String 底层存储结构的变化

- String：jdk 8 及之前，底层使用 char[] 存储；jdk 9：底层使用 byte[] + encoding flag。不可变的字符序列。
- StringBuffer：实现同上。可变的字符序列；线程安全的，效率低
- StringBuilder：实现同上。可变的字符序列；线程不安全的，效率高（jdk 5.0）

### 9.1 官方 Feature

JEP 254：Compact Strings

### 9.2 产生背景

之前是 char 数组，char 是两个字符，所以改成 byte 数组可以节省一半。加上编码（encoding-flag）就可以实现一样效果。

## P17 新特性10：创建只读集合

原来：

```java
Collections.unmodifiableList()
Collections.unmodifiableSet()
Collections.unmodifiableMap()
```

Java 9：

```java
List.of()
Set.of()
Map.of()
Map.ofEntry(Map.entry(), ...)
```

### 10.1 官方 Feature

269：Convenience Factory Methods for Collections

## P18 新特性11：增强的 Stream API

### 11.1 使用说明

Java 的 Stream API 是 Java 标准库最好的改进之一，让开发者能够快速运算，从而能够有效的利用数据并行计算。Java 8 提供的 Stream 能够利用多核架构实现声明式的数据处理。

在 Java 9 中，Stream API 变得更好，Stream 接口中添加了 4 个新的方法：dropWhile、takeWhile、ofNullable，还有个 iterate 方法的新重载方法，可以让你提供一个 Predicate（判断条件）来指定什么时候结束迭代。

除了对 Stream 本身的扩展，Optional 和 Stream 之间的结合也得到了改进。现在可以通过 Optional 的新方法 stream() 将一个 Optional 对象转换为一个（可能是空的）Stream 对象。

### 11.2 使用举例

takeWhile() 的使用：

用于从 Stream 中获取一部分数据，接收一个 Predicate 来进行选择。在有序的 Stream 中，takeWhile 返回从开头开始的尽量多的元素。

```java
List<Integer> list = Arrays.asList(45,43,76,87,42,77,80,73,67,88);
list.stream().takeWhile(x -> x < 50).forEach(System.out::println);

list = Arrays.asList(1,2,3,4,5,6,7,8);
list.stream().takeWhile(x -> x < 5).forEach(System.out::println);
```

dropWhile() 的使用：

dropWhile 的行为与 takeWhile 相反，返回剩余的元素。

```java
List<Integer> list = Arrays.asList(45,43,76,87,42,77,80,73,67,88);
list.stream().dropWhile(x -> x < 50).forEach(System.out::println);

list = Arrays.asList(1,2,3,4,5,6,7,8);
list.stream().dropWhile(x -> x < 5).forEach(System.out::println);
```

ofNullable 的使用：

Java 8 中 Stream 不能完全为 null，否则会报空指针异常。而 Java 9 中的 ofNullable 方法允许我们创建一个单元素 Stream，可以包含一个非空元素，也可以创建一个空 Stream。

```java
// 报 NullPointerException
// Stream<Object> stream1 = Stream.of(null);
// System.out.println(stream1.count());

// 不报异常，允许通过
Stream<String> stringStream = Stream.of("AA", "BB", null);
System.out.println(stringStream.count()); // 3

// 不报异常，允许通过
List<String> list = new ArrayList<>();
list.add("AA");
list.add(null);
System.out.println(list.stream().count()); // 2

// OfNullable(): 允许值为 null
Stream<Object> stream1 = Stream.ofNullable(null);
System.out.println(stream1.count()); // 0
Stream<String> stream = Stream.ofNullable("hello world");
System.out.println(stream.count()); // 1
```

iterate() 的使用：

```java
// 原来控制终止的方式
Stream.iterate(1, i -> i + 1).limit(10)
    .forEach(System.out::println);
// 现在控制终止方式
Stream.iterate(1, i -> i < 100, i -> i + 1)
    .forEach(System.out::println);
```

## P19 新特性11：Optional 提供的 stream()

Optional 类中 stream() 的使用：

```java
List<String> list = new ArrayList<>();
list.add("Tom");
list.add("Jerry");
list.add("Tim");

Optional<List<String>> optional = Optional.ofNullable(list);
Stream<List<String>> stream = optional.stream();
stream.flatMap(x -> x.stream()).forEach(System.out::println);
```

## P20 新特性12：多分辨率图像 API

### 12.1 官方 Feature

251：Multi-Resolution Images

263：HiDPI Graphics on Windows and Linux

### 12.2 产生背景

在 Mac 上，JDK 已经支持视网膜显示，但在 Linux 和 Windows 上，它并没有。在那里，Java 程序在当前的高分辨率屏幕上可能看起来很小，不能使用它们。这是因为像素用于这些系统的大小计算（无论像素实际有多大）。毕竟，高分辨率显示器的有效部分是像素非常小。

JEP 263 以这样的方式扩展了 JDK，即 Windows 和 Linux 也考虑到像素的大小。为此，使用比现在更多的现代 API：Direct2D for Windows 和 GTK+，而不是 Xlib for Linux。图形，窗口和文本由此自动缩放。

JEP 251 还提供处理多分辨率图像的能力，即包含不同分辨率的相同图像的文件。根据相应屏幕的 DPI 度量，然后以适当的分辨率使用图像。

### 12.3 使用说明

- 新的 API 定义在 java.awt.image 包下
- 将不同分辨率的图像封装到一张（多分辨率的）图像中，作为它的变体
- 获取这个图像的所有变体
- 获取特定分辨率的图像变体——表示一张已知分辨率单位为 DPI 的特定尺寸大小的逻辑图像，并且这张图像是最佳的变体。
- 基于当前屏幕分辨率大小和运用的图像转换算法，java.awt.Graphics 类可以从接口 MultiResolutionImage 获取所需的变体。
- MultiResolutionImage 的基础实现是 java.awt.image.BaseMultiResolutionImage。

## P21 新特性13：全新的 Http 客户端 API

### 13.1 官方 Feature

110：HTTP 2 Client

### 13.2 使用说明

HTTP，用于传输网页的协议，早在 1997 年就被采用在目前的 1.1 版本中。直到 2015 年，HTTP2 才成为标准。

HTTP/1.1 和 HTTP/2 的主要区别是如何在客户端和服务器之间构建和传输数据。HTTP/1.1 依赖于请求/响应周期。HTTP/2 允许服务器“push”数据：它可以发送比客户端请求更多的数据。这使得它可以优先处理并发送对于首先加载网页至关重要的数据。

Java 9 中有新的方式来处理 HTTP 调用。它提供了一个新的 HTTP 客户端（HttpClient），它将替代仅适用于 blocking 模式的 HttpURLConnection（HttpURLConnection 是在 HTTP 1.0 的时代创建的，并使用了协议无关的方法），并提供对 WebSocket 和 HTTP/2 的支持。

此外，HTTP 客户端还提供 API 来处理 HTTP/2 的特性，比如流和服务器推送等功能。

全新的 HTTP 客户端 API 可以从 jdk.incubator.httpclient 模块中获取。因为在默认情况下，这个模块是不能根据 classpath 获取的，需要使用 add modules 命令选项配置这个模块，将这个模块添加到 classpath 中。

### 13.3 使用举例

```java
HttpClient client = HttpClient.newHttpClient();
HttpRequest req = HttpRequest.newBuilder(URI.create("http://www.atguigu.com"))
    .GET()
    .build();
HttpResponse<String> response = client.send(req, HttpResponse.BodyHandler.asString());
System.out.println(response.statusCode());
System.out.println(response.version().name());
System.out.println(response.body());
```

## P22 新特性14：Deprecated 的相关 API

### 14.1 官方 Feature

211: Elide Deprecated Warnings on Import Statements

214: Remove GC Combinations Deprecated in JDK 8

277: Enhanced Deprecation

289: Deprecate the Applet API

291: Deprecate the Concurrent Mark Sweep(CMS) Garbage Collector

### 14.2 使用说明

Java 9 废弃或者移除了几个不常用的功能。其中最重要的是 Applet API，现在是标记为废弃的。随着对安全要求的提高，主流浏览器已经取消对 Java 浏览器插件的支持。HTML 5 的出现也进一步加速了它的消亡。开发者现在可以使用像 Java Web Start 这样的技术来代替 Applet，它可以实现从浏览器启动应用程序或者安装应用程序。

同时 appletviewer 工具也被标记为废弃。

## P23 新特性15：智能 Java 编译工具

### 15.1 官方 Feature

139：Enhance javac to Improve Build Speed

199：Smart Java Compilation, Phase Two

### 15.2 使用说明

智能 java 编译工具（sjavac）的第一个阶段始于 JEP139 这个项目，用于在多核处理器情况下提升 JDK 的编译速度。如今，这个项目已经进入第二阶段，即 JEP 199，其目的是改进 Java 编译工具，并取代目前 JDK 编译工具 javac，继而成为 Java 环境默认的通用的智能编译工具。

JDK 9 还更新了 javac 编译器以便能够将 java 9 代码编译运行在低版本 Java 中。



## P24 新特性16：统一的 JVM 日志系统

### 16.1 官方 Feature

158: Unified JVM Logging

271: Unified GC Logging

### 16.2 使用说明

日志是解决问题的唯一有效途径：曾经很难知道 JVM 性能问题和导致 JVM 崩溃的根本原因。不同的 JVM 日志的碎片化和日志选项（例如：JVM 组件对于日志使用的是不同的机制和规则），这使得 JVM 难以进行调试。

解决该问题最佳方法：对所有的 JVM 组件引入一个单一的系统，这些 JVM 组件支持细粒度和易配置的 JVM 日志。

## P25 新特性17：javadoc 的 HTML5 支持

### 17.1 官方 Feature

224: HTML5 Javadoc

225: Javadoc Search

### 17.2 使用说明

jdk 8：生成的 java 帮助文档是在 HTML 4 中，而 HTML 4 已经是很久的标准了。

jdk 9：javadoc 的输出，现在符合兼容 HTML 5 标准。

下图是 java 8 中生成 html 页面，如果想要找到一些类文档，必须在 google 中搜索

## P26 新特性18：JavaScript 的 Nashorn 引擎升级

### 18.1 官方 Feature

236：Parser API for Nashorn

292：Implement Selected ECMAScript 6 Features in Nashorn

### 18.2 使用说明

Nashorn 项目在 JDK 9 中得到改进，它为 Java 提供轻量级的 JavaScript 运行时。Nashorn 项目跟随 Netscape 的 Rhino 项目，目的是为了在 Java 中实现一个高性能但轻量级的 JavaScript 运行时。Nashorn 项目使得 Java 应用能够嵌入 JavaScript。它在 JDK 8 中为 Java 提供一个 JavaScript 引擎。

JDK 9 包含一个用来解析 Nashorn 的 ECMAScript 语法树的 API。这个 API 使得 IDE 和服务端框架不需要依赖 Nashorn 项目的内部实现类，就能够分析 ECMAScript 代码。

## P27 新特性19：Java 的动态编译器

### 19.1 官方 Feature

243: Java-Level JVM Compiler Interface

295: Ahead-of-Time Compilation

### 19.2 产生背景

Oracle 一直在努力提高 Java 启动和运行时性能，希望其能够在更广泛的场景达到或接近本地语言的性能。但是，直到今天，谈到 Java，很多 C/C++ 开发者还是会不屑地评价为启动慢，吃内存。

简单说，这主要是因为 Java 编译产生的类文件是 Java 虚拟机可以理解的二进制代码，而不是真正的可执行的本地代码，需要 Java 虚拟机进行解释和编译，这带来了额外的开销。

### 19.3 使用说明

JIT (Just-in-time) 编译器可以在运行时将热点编译成本地代码，速度很快。但是 Java 项目现在变得很大很复杂，因此 JIT 编译器需要花费较长时间才能热身完，而且有些 Java 方法还没法编译，性能方面也会下降。AoT 编译就是为了这些问题而生的。

在 JDK 9 中，AOT（JEP 295：Ahead-of-Time Compilation）作为实验特性被引入进来，开发者可以利用新的 jaotc 工具将重点代码转换成类似类库一样的文件。虽然仍处于试验阶段，但这个功能使得 Java 应用在被虚拟机启动之前能够先将 Java 类编译为原生代码。此功能旨在改进小型和大型应用程序的启动时间，同时对峰值性能的影响很小。

但是 Java 技术供应商 Excelsior 的营销总监 Dimitry Leskov 担心 AoT 编译技术不够成熟，希望 Oracle 能够等到 Java 10 时有个更稳定版本才发布。

另外 JVMCI（JEP 243：Java-Level JVM Compiler Interface）等特性，对于整个编程语言的发展，可能都具有非常重要的意义，虽然未必引起了广泛关注。目前 Graal Core API 已经被集成进入 Java 9，虽然还只是初始一小步，但是完全用 Java 语言来实现的可靠的、高性能的动态编译器，似乎不再是遥不可及，这是 Java 虚拟机开发工程师的福音。

与此同时，随着 Truffle 框架和 Substrate VM 的发展，已经让个别信心满满的工程师高呼“One VM to Rule Them All”，也许就在不远的将来 Ploygot 以一种另类的方式成为现实。

## P28 新特性的总结与展望

### 1、在 Java 9 中看不到什么？

#### 1.1 一个标准化和轻量级的 JSON API

#### 1.2 新的货币 API

### 2、展望

# Java 10

Java语言高级-Java8/9/10/11新特性-2019-尚硅谷 2019-05-02 17:49:12

https://www.bilibili.com/video/BV184411x7XA

## P42 java10 新特性的概述

- 2018 年 3 月 21 日，Oracle 官方宣布 Java 10 正式发布。
- 需要注意的是 Java 9 和 Java 10 都不是 LTS（Long-Term-Support）版本，和过去的 Java 大版本升级不同，这两个只有半年左右的开发和维护期。而未来的 Java 11，也就是 18.9 LTS，才是 Java 8 之后第一个 LTS 版本。
- JDK 10 一共定义了 109 个新特性，其中包含 12 个 JEP（对于程序员来讲，真正的新特性其实就一个），还有一些新 API 和 JVM 规范以及 JAVA 语言规范上的改动。
- JDK 10 的 12 个 JEP（JDK Enhancement Proposal 特性加强提议）参阅官方文档：http://openjdk.java.net/projects/jdk/10/

12 个 JEP：

- 286: [Local-Variable Type Inference](https://openjdk.org/jeps/286) 局部变量类型推断
- 296: [Consolidate the JDK Forest into a Single Repository](https://openjdk.org/jeps/296) JDK 库的合并
- 304: [Garbage-Collector Interface](https://openjdk.org/jeps/304) 统一的垃圾回收接口
- 307: [Parallel Full GC for G1](https://openjdk.org/jeps/307) 为 G1 提供并行的 Full GC
- 310: [Application Class-Data Sharing](https://openjdk.org/jeps/310) 应用程序类数据（AppCDS 共享）
- 312: [Thread-Local Handshakes](https://openjdk.org/jeps/312) ThreadLocal 握手交互
- 313: [Remove the Native-Header Generation Tool (javah)](https://openjdk.org/jeps/313) 移除 JDK 中附带的 javah 工具
- 314: [Additional Unicode Language-Tag Extensions](https://openjdk.org/jeps/314) 使用附加的 Unicode 语言标记扩展
- 316: [Heap Allocation on Alternative Memory Devices](https://openjdk.org/jeps/316) 能将堆内存占用分配给用户指定的备用内存设备
- 317: [Experimental Java-Based JIT Compiler](https://openjdk.org/jeps/317) 使用基于 Java 的 JIT 编译器
- 319: [Root Certificates](https://openjdk.org/jeps/319) 根证书
- 322: [Time-Based Release Versioning](https://openjdk.org/jeps/322) 基于时间的发布版本

## P43 java10 新特性：局部变量类型推断

- 产生背景：开发者经常抱怨 Java 中引用代码的程度。局部变量的显示类型声明，常常被认为是不必须的，给一个好听的名字经常可以很清楚的表达出下面应该怎样继续。

- 好处：减少了啰嗦和形式的代码，避免了信息冗余，而且对齐了变量名，更容易阅读！

- 举例如下：

  - 场景一：类实例化时

    作为 Java 开发者，在声明一个变量时，我们总是习惯了敲打两次变量类型，第一次用于声明变量类型，第二次用于构造器。

    ```java
    LinkedHashSet<Integer> set = new LinkedHashSet<>();
    ```

  - 场景二：返回值类型含复杂泛型结构

    变量的声明类型书写复杂且较长，尤其是加上泛型的使用

    ```java
    Iterator<Map.Entry<Integer, Student>> iterator = set.iterator();
    ```

  - 场景三：

    我们也经常声明一种变量，它只会被使用一次，而且是用在下一行代码中，比如：

    ```java
    URL url = new URL("http://www.atguigu.com");
    URLConnection connection = url.openConnection();
    Reader reader = new BufferReader(new InputStreamReader(connection.getInputStream()));
    ```

尽管 IDE 可以帮我们自动完成这些代码，但当变量总是跳来跳去的时候，可读性还是会受到影响，因为变量类型的名称由各种不同长度的字符组成。而且，有时候开发人员会尽力避免声明中间变量，因为太多的类型声明只会分散注意力，不会带来额外的好处。

在局部变量中使用时，以下情况不适用：

1. 局部变量不赋值，初始值为 null，就不能实现类型推断
2. Lambda 表达式中，左边的函数式接口不能声明为 var
3. 方法引用中，左边的函数式接口不能声明为 var
4. 数组静态初始化中，无法 `var arr = {1, 2, 3};`

不适用以下结构中：

1. 没有初始化的局部变量声明
2. 方法的返回类型
3. 方法的参数类型
4. 构造器的参数类型
5. 属性
6. catch 块

反编译后，从代码来看，就好像之前已经声明了这些类型一样。事实上，这一特性只发生在编译阶段，与运行时无关，所以对运行时的性能不会产生任何影响。

### 工作原理

在处理 var 时，编译器先是查看表达式右边部分，并根据右边变量值的类型进行推断，作为左边变量的类型，然后将该类型写入字节码当中。

### 注意

- var 不是一个关键字

  你不需要担心变量名或方法名会与 var 发生冲突，因为 var 实际上并不是一个关键字，而是一个类型名，只有在编译器需要知道类型的地方才需要用到它。除此之外，它就是一个普通合法的标识符。也就是说，除了不能用它作为类名，其他的都可以，但极少人会用它作为类名。

- 这不是 JavaScript

  首先要说明的是，var 并不会改变 Java 是一门静态类型语言的事实。编译器负责推断出类型，并把结果写入字节码文件，就好像是开发人员自己敲入类型一样。

## P44 java10 新特性：集合新增创建不可变集合的方法

自 Java 9 开始，jdk 里面为集合（List/Set/Map）都添加了 of（jdk 9 新增）和 copyOf（jdk 10 新增）方法，它们两个都用来创建不可变的集合，来看下它们的使用和区别。

```java
// 示例1：
var list1 = List.of("Java", "Python", "C");
var copy1 = List.copyOf(list1);
System.out.println(list1 == copy1); // true

// 示例2：
var list2 = new ArrayList<String>();
var copy2 = List.copyOf(list2);
System.out.println(list2 == copy2); // false

// 示例1 和 2 代码基本一致，为什么一个 true，一个 false？
```

结论：

copyOf() 如果参数是一个只读集合，则返回值为原值

如果参数不是一个只读集合，则返回一个新的集合，这个集合是只读的。



从源码分析，可以看出 copyOf 方法会先判断来源集合是不是 AbstractImmutableList 类型的，如果是，就直接返回，如果不是，则调用 of 创建一个新的集合。

示例 2 因为用的 new 创建的集合，不属于不可变 AbstractImmutableList 类的子类，所以 copyOf 方法又创建了一个新的实例，所以为 false。

注意：使用 of 和 copyOf 创建的集合为不可变集合，不能进行添加、删除、替换、排序等操作，不然会报 java.lang.UnsupportedOperationException 异常。

上面演示了 List 的 of 和 copyOf 方法，Set 和 Map 接口都有。

# Java 11

Java语言高级-Java8/9/10/11新特性-2019-尚硅谷 2019-05-02 17:49:12

https://www.bilibili.com/video/BV184411x7XA

## P45 java11 新特性的概述

北京时间 2018 年 9 月 26 日，Oracle 官方宣布 Java 11 正式发布。这是 Java 大版本周期变化后的第一个长期支持版本，非常值得关注。从官网即可下载，最新发布的 Java 11 将带来 ZGC Http Client 等重要特性，一共包含 17 个 JEP（JDK Enhancement Proposals， JDK 增强提案）。其实，总共更新不止 17 个，只是我们更关注如下的 17 个 JEP 更新。

181: [Nest-Based Access Control](https://openjdk.org/jeps/181) 基于嵌套的访问控制
309: [Dynamic Class-File Constants](https://openjdk.org/jeps/309) 动态的类文件常量
315: [Improve Aarch64 Intrinsics](https://openjdk.org/jeps/315) 改进 Aarch64 Intrinsics
318: [Epsilon: A No-Op Garbage Collector](https://openjdk.org/jeps/318) Epsilon 垃圾回收器，又被称为 “No-Op”（无操作）回收器
320: [Remove the Java EE and CORBA Modules](https://openjdk.org/jeps/320) 移除 Java EE 和 CORBA 模块，JavaFX 也已被移除
321: [HTTP Client (Standard)](https://openjdk.org/jeps/321)
323: [Local-Variable Syntax for Lambda Parameters](https://openjdk.org/jeps/323) 用于 Lambda 参数的局部变量语法
324: [Key Agreement with Curve25519 and Curve448](https://openjdk.org/jeps/324) 采用 Curve25519 和 Curve448 算法实现的密钥协议
327: [Unicode 10](https://openjdk.org/jeps/327)
328: [Flight Recorder ](https://openjdk.org/jeps/328) 飞行记录仪
329: [ChaCha20 and Poly1305 Cryptographic Algorithms](https://openjdk.org/jeps/329) 实现 ChaCha20 和 Poly1305 加密算法
330: [Launch Single-File Source-Code Programs](https://openjdk.org/jeps/330) 启动单个 Java 源文件文件的程序
331: [Low-Overhead Heap Profiling](https://openjdk.org/jeps/331) 低开销的堆分配采样方法
332: [Transport Layer Security (TLS) 1.3](https://openjdk.org/jeps/332) 对 TLS 1.3 的支持
333: [ZGC: A Scalable Low-Latency Garbage Collector
   (Experimental)](https://openjdk.org/jeps/333) ZGC：可伸缩的低延迟垃圾回收器，处于实验性阶段
335: [Deprecate the Nashorn JavaScript Engine](https://openjdk.org/jeps/335) 弃用 Nashorn JavaScript 引擎
336: [Deprecate the Pack200 Tools and API](https://openjdk.org/jeps/336) 弃用 Pack200 工具及其 API

JDK 11 是一个长期支持版本（LTS, Long-Term-Support）

- 对于企业来说，选择 11 将意味着长期的、可靠的、可预测的技术路线图。其中免费的 OpenJDK 11 确定将得到的 OpenJDK 社区的长期支持，LTS 版本将是可以放心选择的版本。
- 从 JVM GC 的角度，JDK 11 引入了两种新的 GC，其中包括也许是划时代意义的 ZGC，虽然其目前还是实验特性，但是从能力上来看，这是 JDK 的一个巨大突破，为特定生产环境的苛刻需求提供了一个可能的选择。例如，对部分企业核心存储等产品，如果能够保证不超过 10ms 的 GC 暂停，可靠性会上一个大的台阶，这是过去我们进行 GC 调优几乎做不到的，是能与不能的问题。



## P46 java11 新特性：String 新增的方法

- 判断字符串是否为空白: `.isBlank()` （\t、\n 也是空白）
- 去除首尾空白：`.strip()`
- 去除尾部空格：`.stripTrailing()`
- 去除首部空格：`.stripLeading()`
- 复制字符串：`.repeat(3)`
- 行数统计：`.lines().count()`



## P47 java11 新特性：Optional 新增的方法

Optional 也增加了几个非常酷的方法，现在可以很方便的将一个 Optional 转换成一个 Stream，或者当一个空 Optional 时给它一个替代的。

| 新增方法                                                     | 描述                                                         | 新增的版本 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---------- |
| `boolean isEmpty()`                                          | 判断 value 是否为空                                          | JDK 11     |
| `ifPresentOrElse(Consumer<? super T>action, Runnable emptyAction)` | value 非空，执行参数1功能；如果 value 为空，执行参数2功能    | JDK 9      |
| `Optional<T> or(Supplier<? extends Optional<? extends T>> supplier)` | value 非空，返回对应的 Optional；value 为空，返回形参封装的 Optional | JDK 9      |
| `Stream<T> stream()`                                         | value 非空，返回仅包含此 value 的 Stream；否则，返回一个空的 Stream | JDK 9      |
| `T orElseThrow()`                                            | value 非空，返回 value；否则抛异常 NoSuchElementException    | JDK 10     |



## P48 java11 新特性：局部变量类型推断的升级

在 var 上添加注解的语法格式，在 jdk 10 中是不能实现的。在 JDK 11 中加入了这样的语法。

```java
// 使用 var 的好处是在使用 lambda 表达式时给参数加上注解。
Consumer<String> con2 = (@Deprecated var t) -> System.out.println(t.toUpperCase());
```



## P49 java11 新特性：HttpClient

- HTTP，用于传输网页的协议，早在 1997 年就被采用在目前的 1.1 版本中。直到 2015 年，HTTP2 才成为标准。
- HTTP/1.1 和 HTTP/2 的主要区别是如何在客户端和服务器之间构建和传输数据。HTTP/1.1 依赖于请求/响应周期。HTTP/2 允许服务器“push”数据：它可以发送比客户端请求更多的数据。这使得它可以优先处理并发送对于首先加载网页至关重要的数据。
- 这是 Java 9 开始引入的一个处理 HTTP 请求的 HTTP Client API，该 API 支持同步和异步，而在 Java 11 中已经为正式可用状态，你可以在 java.net 包中找到这个 API。
- 它将替代仅仅适用于 blocking 模式的 HttpURLConnection（HttpURLConnection 是在 HTTP 1.0 的时代创建的，并使用了协议无关的方法），并提供对 WebSocket 和 HTTP/2 的支持

```java
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder(URI.create("http://127.0.0.1:8080/test/")).build();
BodyHandler<String> responseBodyHandler = BodyHandler.ofString();
HttpResponse<String> response = client.send(request, responseBodyHandler);
String body = response.body();
System.out.println(body);
```

```java
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder(URI.create("http://127.0.0.1:8080/test/")).build();
BodyHandler<String> responseBodyHandler = BodyHandler.ofString();
CompletableFuture<HttpResponse<String>> sendAsync = client.sendAsync(request, responseBodyHandler);
sendAsync.thenApply(t -> t.body()).thenAccept(System.out::println);
```

## P50 java11 新特性：更简化的编译运行程序

看下面的代码。

```shell
# 编译
javac JavaStack.java
# 运行
java JavaStack
```

在我们的认知里面，要运行一个 Java 源代码必须先编译，再运行，两步执行动作。而在未来的 Java 11 版本中，通过一个 java 命令就直接搞定了，如以下所示：

```java
java JavaStack.java
```

一个命令编译运行源代码的注意点：

- 执行源文件中的第一个类，第一个类必须包含主方法。
- 并且不可以使用其他源文件中的自定义类，本文件中的自定义类是可以使用的。

## P51 java11 新特性：其他新特性

- 废弃 Nashorn 引擎
  - 在后续版本准备移除掉，有需要的可以考虑使用 GraalVM。
- ZGC
  - GC 是 java 主要优势之一。然而，当 GC 停顿太长，就会开始影响应用的响应时间。消除或减少 GC 停顿时长，java 将对更广泛的应用场景是一个更有吸引力的平台。此外，现代系统中可用内存不断增长，用户和程序员希望 JVM 能够以高效的方式充分利用这些内存，并且无需长时间的 GC 暂停时间。
  - ZGC，A Scalable Low-Latency Garbage Collector(Experimental) 
  - ZGC，这应该是 JDK 11 最为瞩目的特性，没有之一。但是后面带了 Experimental，说明这还不建议用到生产环境。
  - ZGC 是一个并发，基于 region，压缩型的垃圾收集器，只有 root 扫描阶段会 STW（stop the world），因此 GC 停顿时间不会随着堆的增长和存活对象的增长而变长。
  - 优势：
    - GC 暂停时间不会超过 10 ms
    - 既能处理几百兆的小堆，也能处理几个 T 的大堆
    - 和 G1 相比，应用吞吐能力不会下降超过 15%
    - 为未来的 GC 功能和利用 colord 指针以及 Load barriers 优化奠定基础
    - 初始只支持 64 位系统
  - ZGC 的设计目标是：支持 TB 级内存容量，暂停时间低（< 10 ms），对整个程序吞吐量的影响小于 15%。将来还可以扩展实现机制，以支持不少令人兴奋的功能，例如多层堆（即热对象置于 DRAM 和冷对象置于 NVMe 闪存），或压缩堆。
- Unicode 10
- Deprecate the Pack200 Tools and API
- 新的 Epsilon 垃圾收集器
- 完全支持 Linux 容器（包括 Docker）
- 支持 G1 上的并行完全垃圾收集
- 最新的 HTTPS 安全协议 TLS 1.3
- Java Flight Recorder

## P52 java11 新特性：jdk 后续更新的展望

当前 JDK 中看不到：

- 一个标准化和轻量级的 JSON API
- 新的货币 API

# Java 12

尚硅谷宋红康Java12&13新特性教程(深入解读java12&13) 2019-09-23 15:31:53

https://www.bilibili.com/video/BV1jJ411M7kQ

## P1 新特性内容目录概述

## P2 Java 生态圈的介绍

作为一个平台

作为一种文化

作为一个社区

## P3 Java 的语言优势

## P4 JDK 各个版本的新特性介绍

### JDK Version 1.0

1996-01-23 Oak（橡树）

初代版本，伟大的一个里程碑，但是是纯解释运行，使用外挂 JIT，性能比较差，运行速度慢。

### JDK Version 1.1

1997-02-19

- JDBC（Java DataBase Connectivity）
- 支持内部类
- RMI（Remote Method Invocation）
- 反射
- Java Bean

### JDK Version 1.2

1998-12-08 Playground（操场）

- 集合框架
- JIT（Just In Time）编译器
- 对打包的 Java 文件进行数字签名
- JFC（Java Foundation Classes），包括 Swing 1.0，拖放的 Java 20 类库
- Java 插件
- JDBC 中引入可滚动结果集，BLOB，CLOB，批量更新和用户自定义类型
- Applet 中添加声音支持

同时 Sun 发布了 JSP/Servlet、EJB 规范，以及将 Java 分成了 J2EE、J2SE 和 J2ME。这表明了 Java 开始向企业、桌面应用和移动设备应用 3 大领域挺进。

### JDK Version 1.3

2000-05-08 Kestrel（红隼）

- Java Sound API
- jar 文件索引
- 对 Java 各个方面都做了大量优化和增强

此时，Hotspot 虚拟机成为 Java 的默认虚拟机。

### JDK Version 1.4

2002-02-13 Merlin（隼）

- 断言
- XML 处理
- Java 打印服务
- Logging API
- Java Web Start
- JDBC 3.0 API
- Preferences API
- 链式异常处理
- 支持 IPv6
- 支持正则表达式
- 引入 Image I/O API

同时，古老的 Classic 虚拟机退出历史舞台。

一年后，Java 平台的 Scala 正式发布，同年 Groovy 也加入了 Java 阵营。

### Java 5

2004-09-30 Tiger（老虎）

- 类型安全的枚举
- 泛型
- 自动装箱和自动拆箱
- 元数据（注解）
- 增强循环，可以使用迭代方式
- 可变参数
- 静态引入
- Instrumentation

同时 JDK 1.5 改名为 J2SE 5.0

### Java 6

2006-12-11 Mustang（野马）

- 支持脚本语言
- JDBC 4.0 API
- Java Compiler API
- 可插拔注解
- 增加对 Native PKI (Public Key Infrastructure), Java GSS (Generic Security Service), Kerberos 和 LDAP (Lightweight Directory Access Protocol) 支持
- 继承 Web Services

同年，Java 开源并建立了 OpenJDK。顺利成章，Hotspot 虚拟机也成为了 OpenJDK 中的默认虚拟机。

2007 年，Java 平台迎来了新伙伴 Clojure

2008 年，Oracle 收购了 BEA，得到了 JRockit 虚拟机。

2009 年，Twitter 宣布把后台大部分程序从 Ruby 迁移到 Scala，这是 Java 平台又一次大规模应用。

2010 年，Oracle 收购了 Sun，获得最具价值的 Hotspot 虚拟机。此时 Oracle 拥有市场占用率最高的两款虚拟机 Hotspot 和 JRockit，并计划在未来对它们进行整合。

### Java 7

2011-07-28 Dolphin（海豚）

- 钻石型语法（在创建泛型对象时应用类型推断）
- 支持 try-with-resources（自动关闭资源）
- switch语句块中允许以字符串作为分支条件
- 引入 Java NIO.2 开发包
- 在创建泛型对象时应用类型推断
- 支持动态语言
- 数值类型可以用二进制字符串表示，并且可以在字符串表示中添加下划线
- null 值的自动处理

在 JDK 1.7 中，正式启用了新的垃圾回收器 G1，支持了 64 位系统的压缩指针。

### Java 8

2014-03-18

- Lambda 表达式 - Lambda 允许把函数作为一个方法的参数（函数作为参数传递进方法中）
- 方法引用 - 方法引用提供了非常有用的语法，可以直接引用已有 Java 类或对象（实例）的方法或构造器。与 lambda 联合使用，方法引用可以使语言的构造更紧凑简洁，减少冗余代码。
- 默认方法 - 默认方法就是一个在接口里面有了一个实现的方法
- 新工具 - 新的编译工具，如：Nashorn 引擎 jjs、类依赖分析器 jdeps
- Stream API - 新添加的 Stream API（java.util.stream）把真正的函数式编程风格引入到 Java 中。
- Date Time API - 加强对日期与时间的处理。
- Optional 类 - Optional 类已经成为 Java 8 类库的一部分，用来解决空指针异常。
- Nashorn Javascript 引擎 - Java 8 提供了一个新的 Nashorn Javascript 引擎，它允许我们在 JVM 上运行特定的 javascript 应用。

### Java 9

2017-09-22

- 模块系统：模块是一个包的容器，Java 9 最大的变化之一是引入了模块系统（Jigsaw 项目）
- REPL（JShell）：交互式编程环境。
- HTTP 2 客户端
- 改进的 Javadoc：Javadoc 现在支持在 API 文档中进行搜索。另外，Javadoc 的输出现在符合兼容 HTML 5 标准。
- 多版本兼容 JAR 包
- 集合工厂方法
- 私有接口方法
- 进程 API：改进的 API 来控制和管理操作系统进程。引进 java.lang.ProcessHandle 及其嵌套接口 Info 来让开发者逃离时常因为要获取一个本地进程的 PID 而不得不使用本地代码的窘境。
- 改进的 Stream API：改进的 Stream API 添加了一些便利的方法，使流处理更容易，并使用收集器编写复杂的查询。
- 改进 try-with-resources
- 改进的弃用注解 @Deprecated：注解 @Deprecated 可以标记 Java API 状态，可以表示被标记的 API 将会被移除，或者已经破坏。
- 改进钻石操作符（Diamond Operator）
- 改进 Optional 类
- 多分辨率图像 API
- 改进的 CompletableFuture API：CompletableFuture 类的异步机制可以在 ProcessHandle.onExit 方法退出时执行操作。
- 轻量级的 JSON API：内置了一个轻量级的 JSON API
- 响应式流（Reactive Streams） API： Java 9 中引入了新的响应式流 API 来支持 Java 9 中的响应式编程。

### Java 10

2018-03-21

- JEP 286，var 局部变量类型推断
- JEP 296，将原来用 Mercurial 管理的众多 JDK 仓库代码，合并到一个仓库中，简化开发和管理过程。
- JEP 304，统一的垃圾回收接口
- JEP 307，G1 垃圾回收器的并行完整垃圾回收，实现并行性来改善最坏情况下的延迟
- JEP 310，应用程序类数据（AppCDS）共享，通过跨进程共享通用类元数据来减少内存占用空间，和减少启动时间
- JEP 312，ThreadLocal 握手交互。在不进入到全局 JVM 安全点（Safepoint）的情况下，对线程执行回调。优化可以只停止单个线程，而不是停全部线程或一个都不停。
- JEP 313，移除 JDK 中附带的 javah 工具。可以使用 javac -h 代替。
- JEP 314，使用附加的 Unicode 语言标记扩展
- JEP 317，能使堆内存占用分配给用户指定的备用内存设备
- JEP 317，使用 Graal 基于 Java 的编译器，可以预先把 Java 代码编译成本地代码来提升效能
- JEP 318，在 OpenJDK 中提供一组默认的根证书颁发机构证书。开源目前 Oracle 提供的 Java SE 的根证书，这样 OpenJDK 对开发人员使用起来更方便。
- JEP 322，基于时间定义的发布版本，即上述提到的发布周期。

### Java 11

2018-09-25

## P5 JDK 版本的更新周期

## P6 Java 版本更新的破坏性

## P7 JDK 12 & 13  的下载与 IDEA 2019.2 版本的安装

## P8 Java 12 新特性概述

美国当地时间 2019 年 3 月 19 日，也就是北京时间 20 号 Java 12 正式发布了

Features：总共有 8 个新的 JEP（JDK Enhancement Proposals）

https://openjdk.org/projects/jdk/12/

分别为：

| JEP  |                               |                                                              |
| ---- | ----------------------------- | ------------------------------------------------------------ |
| 189: | 低暂停时间的 GC               | [Shenandoah: A Low-Pause-Time Garbage Collector (Experimental)](https://openjdk.org/jeps/189) |
| 230: | 微基准测试套件                | [Microbenchmark Suite](https://openjdk.org/jeps/230)         |
| 325: | switch 表达式                 | [Switch Expressions (Preview)](https://openjdk.org/jeps/325) |
| 334: | JVM 常量 API                  | [JVM Constants API](https://openjdk.org/jeps/334)            |
| 340: | 只保留一个 AArch64 实现       | [One AArch64 Port, Not Two](https://openjdk.org/jeps/340)    |
| 341: | 默认类数据共享归档文件        | [Default CDS Archives](https://openjdk.org/jeps/341)         |
| 344: | 可中止的 G1 Mixed GC          | [Abortable Mixed Collections for G1](https://openjdk.org/jeps/344) |
| 346: | G1 及时返回未使用的已分配内存 | [Promptly Return Unused Committed Memory from G1](https://openjdk.org/jeps/346) |



## P9 Java 12 新特性：switch 表达式

switch 表达式（预览）

### 6.1.1 传统 switch 的弊端

传统的 switch 声明语句（switch statement）在使用中有一些问题：

- 匹配是自上而下的，如果忘记写 break，后面的 case 语句不论匹配与否都会执行
- 所有的 case 语句共用一个块范围，在不同的 case 语句定义的变量名不能重复
- 不能在一个 case 里写多个执行结果一致的条件
- 整个 switch 不能作为表达式返回值

Java 12 将会对 switch 声明语句进行扩展，可将其作为增强版的 switch 语句或称为“switch 表达式”来写出更加简化的代码。

### 6.1.2 何为预览语言？

Switch 表达式也是作为预览语言功能的第一个语言改动被引入新版 Java 中来的，预览语言功能的想法是在 2018 年初被引入 Java 的，本质上讲，这是一种引入新特性的测试版的方法。通过这种方式，能够根据用户反馈进行升级、更改，在极端情况下，如果没有被很好的接纳，则可以完全删除该功能。预览功能的关键在于它们没有被包含在 Java SE 规范中。

### 6.1.3 语法详解

扩展的 switch 语句，不仅可以作为语句（statement），还可以作为表达式（expression），并且两种写法都可以使用传统的 switch 语法，或者使用简化的 `case L ->` 模式匹配的语法作用于不同范围并且控制执行流。这些更改将简化日常编码工作，并为 switch 中的模式匹配（JEP 305）做好准备。

- 使用 Java 12 中 Switch 表达式的写法，省去了 break 语句，避免了因少写 break 而出错
- 同时将多个 case 合并到一行，显得简洁、清晰也更加优雅的表达逻辑分支，其具体写法就是将之前的 case 语句表成了：`case L ->`，即如果条件匹配 case L，则执行标签右侧的代码，同时标签右侧的代码段只能是表达式、代码块或 throw 语句。
- 为了保持兼容性，case 条件语句中依然可以使用字符 `:`，这时 fall-through 规则依然有效的，即不能省略原有的 break 语句，但是同一个 switch 结构里不能混用 `->` 和 `:`，否则会有编译错误。并且简化后的 switch 代码块中定义的局部变量，其作用域就限制在代码块中，而不是蔓延到整个 switch 结构，也不用根据不同的判断条件来给变量赋值。

### 6.1.5 使用总结

这个语法如果做过 Android 开发的不会陌生，因为 Kotlin 家的 when 表达式就是这么干的！

Switch Expressions 或者说起相关的 Pattern Matching 特性，为我们勾勒出了 Java 语法进化的一个趋势，将开发者从复杂繁琐的低层次抽象中逐渐解放出来，以更高层次更优雅的抽象，既降低代码量，又避免意外编程错误的出现，进而提高代码质量和开发效率。

### 6.1.6 展望

Java 11 以及之前版本中，Switch 表达式支持以下类型：byte、char、short、int、Byte 、Character、Short、Integer、enum、String，在未来的某个 Java 版本有可能会允许支持 float、double 和 long（以及对应类型的包装类型）。