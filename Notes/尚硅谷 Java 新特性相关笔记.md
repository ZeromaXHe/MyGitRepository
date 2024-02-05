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