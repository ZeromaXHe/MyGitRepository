# Java 基础

## 父子类加载顺序

1. 父类静态成员变量
2. 父类静态代码块
3. 子类静态成员变量
4. 子类静态代码块
5. 父类非静态成员变量 
6. 父类非静态代码块
7. 父类构造方法
8. 子类非静态成员变量
9. 子类非静态代码块
10. 子类构造方法

这里帮大家小结几个特点：

1. 成员变量 > 代码块 > 构造方法（构造器）。
2. 静态（共有） > 非静态（私有）。
3. 子类静态 > 父类非静态（私有）。

参考文档：

1. [Java父子类加载顺序｜8月更文挑战 - 掘金](https://juejin.cn/post/6991707135117967373)

## 反射

- 具体使用、API
  - Class 类
    - **Class 实例的三种方式**
      - .class
      - 对象 .getClass()
      - Class.forName()
    - 常用方法
      - newInstance() 通过类的无参构造方法创建对象
      - getDeclaredXxxs() 获得类的所有的（属性/构造器/方法等）
      - getFields() 获得类的public类型的属性。
      - getField(String name) 获得类的指定属性
      - getMethods() 获得类的public类型的方法
      - getMethod (String name,Class [] args) 获得类的指定方法
      - getConstrutors() 获得类的public类型的构造方法
      - getConstrutor(Class[] args) 获得类的特定构造方法
      - getName() 获得类的完整名字
      - getPackage() 获取此类所属的包
      - getSuperclass() 获得此类的父类对应的Class对象
  - Field 类
    - set()
    - get()
  - Method 类
    - invoke()
  - Constructor 类
    - newInstance()
  - AccessibleObject
    - **setAccessible(boolean)**
- 使用场景
  - Spring AOP 动态代理
  - BeanUtils 拷贝
  - Spring IOC 加载 XML 配置文件
  - Spring 等框架的注解式使用
- 原理
  - 在程序运行时动态加载类并获取类的详细信息，从而操作类或对象的属性和方法。
  - 本质是 JVM 得到 class 对象之后，再通过 class 对象进行反编译，从而获取对象的各种信息。
- 缺点
  - 安全
  - 性能

参考文档：

1. [2024年面试准备-1-Java篇.md](./2024年面试准备-1-Java篇.md) 反射

## Channel

- 通道（Channel）是 **java.nio** 的第二个主要创新。

  - 它们既不是一个扩展也不是一项增强，而是全新、极好的Java I/O示例，提供与I/O服务的直接连接。
  - Channel用于在字节缓冲区和位于通道另一侧的实体（通常是一个文件或套接字）之间有效地传输数据。

- 通道是访问I/O服务的导管。

  - I/O可以分为广义的两大类别：File I/O和Stream I/O。
  - 那么相应地有两种类型的通道也就不足为怪了，它们是文件（file）通道和套接字（socket）通道。
  - 我们看到在api里有一个 **FileChannel** 类和三个 socket 通道类：**SocketChannel**、**ServerSocketChannel** 和 **DatagramChannel**。

- 通道可以以多种方式创建。

  - Socket 通道有可以直接创建新 socket 通道的工厂方法。
  - 但是一个FileChannel对象却只能通过在一个打开的RandomAccessFile、FileInputStream或FileOutputStream对象上调用getChannel( )方法来获取。**你不能直接创建一个 FileChannel 对象**。

- SocketChannel

  - 可以设置 SocketChannel 为非阻塞模式（non-blocking mode）.设置之后，就可以在异步模式下调用connect(), read() 和write()了。

    ```java
    socketChannel.configureBlocking(false);
    ```

  - 如果 SocketChannel 在非阻塞模式下，此时调用connect()，该方法可能在连接建立之前就返回了。为了确定连接是否建立，可以调用 finishConnect() 的方法。

- **Scatter/Gather**

  - 通道提供了一种被称为Scatter/Gather的重要新功能（有时也被称为矢量I/O）。它是指在多个缓冲区上实现一个简单的I/O操作。
  - 对于一个write操作而言，数据是从几个缓冲区按顺序抽取（称为gather）并沿着通道发送的。缓冲区本身并不需要具备这种gather的能力（通常它们也没有此能力）。该gather过程的效果就好比全部缓冲区的内容被连结起来，并在发送数据前存放到一个大的缓冲区中。
  - 对于read操作而言，从通道读取的数据会按顺序被散布（称为scatter）到多个缓冲区，将每个缓冲区填满直至通道中的数据或者缓冲区的最大空间被消耗完。
  - scatter / gather经常用于需要将传输的数据分开处理的场合，例如传输一个由消息头和消息体组成的消息，你可能会将消息体和消息头分散到不同的buffer中，这样你可以方便的处理消息头和消息体。
  - 使用得当的话，Scatter/Gather会是一个极其强大的工具。它允许你委托操作系统来完成辛苦活：将读取到的数据分开存放到多个存储桶（bucket）或者将不同的数据区块合并成一个整体。
    - 这是一个巨大的成就，因为操作系统已经被高度优化来完成此类工作了。它节省了您来回移动数据的工作，也就避免了缓冲区拷贝和减少了您需要编写、调试的代码数量。

参考文档：

1. [详解java NIO之Channel（通道） - 知乎](https://zhuanlan.zhihu.com/p/351327314)

# Java 集合

## HashMap

- 继承关系

  ```mermaid
  classDiagram
  	AbstractMap <|-- HashMap
  	Map <|.. AbstractMap
  	Map <|.. HashMap
  	Cloneable <|.. HashMap
  	Serializable <|.. HashMap
  ```

- 实现原理

  - 数组 + 链表/红黑树

    - table 数组：

      ```java
      transient Node<K,V>[] table;
      ```

    - Java 8 引入的红黑树

- key 可以为 null，value 也可以为 null

- 哈希冲突

  - HashMap 使用的是链地址法
  - 所有的方法
    - 开放定址法
      - 线性探测法
        - ThreadLocal：内部的 ThreadLocalMap 就是用的这种
      - 平方探测法（二次探测）
    - 再哈希法
    - 链地址法（也叫拉链法）
      - Redis 的 hash 也是
    - 建立公共溢出区

- put() 方法详解

  - 利用 key 的 hashCode() 在 hash() 中运算出 hash 值，再利用 & 计算出数组的 index;
  - 如果没碰撞直接放到桶里
  - 如果碰撞了，在链表或红黑树中判断是否存在 key。如果节点已经存在就替换 old value (保证 key 的唯⼀性)
  - 如果不存在，则如果是链表的形式就使用尾插法插入新节点（Java 8 起）
    - Java 7 的时候还是头插法，多线程扩容时会有链表死循环的风险
  - 如果插入会导致链表过长(大于等于 `TREEIFY_THRESHOLD`)，就把链表转换成红黑树（Java 8 起）；
  - 如果桶满了(超过 loadFactor * currentCapacity)，就要 resize()

- 重要变量

  - `DEFAULT_INITIAL_CAPACITY` 
    - Table 数组的初始化长度： `1 << 4` `2^4=16`
  - `MAXIMUM_CAPACITY`
    - Table 数组的最大长度： `1<<30` `2^30=1073741824`
  - `DEFAULT_LOAD_FACTOR`
    - 负载因子：默认值为 `0.75`。 当元素的总个数 > 当前数组的长度 * 负载因子。数组会进行扩容，扩容为原来的两倍
  - `TREEIFY_THRESHOLD`
    - 链表树化阈值： 默认值为 `8` 。表示在一个node（Table）节点下的值的个数大于 8 时候，会将链表转换成为红黑树。
  - `UNTREEIFY_THRESHOLD`
    - 红黑树链化阈值： 默认值为 `6` 。 表示在进行扩容期间，单个 Node 节点下的红黑树节点的个数小于 6 时候，会将红黑树转化成为链表。
  - `MIN_TREEIFY_CAPACITY = 64`
    - **最小树化阈值**，当 Table 所有元素超过改值，才会进行树化（为了防止前期阶段频繁扩容和树化过程冲突）。否则进行扩容

- 为什么长度要是 2 的 n 次方？

  - 如何保证的

    - 初始长度
      - 默认 2^4 = 16
      - 指定长度时，设置 threshold（扩容的阈值）的 tableSizeFor() 方法也会把值调整为 `MAXIMUM_CAPACITY`（2 ^ 30）以内的最接近入参的 2 的 n 次方数字。第一次 put 引起扩容初始化 table 时，就会以这个值为 table 数组大小
    - 扩容按 2 倍扩容
      - 一个桶中的元素正好只会对应分散到两个新桶

  - 计算 hash 值

    - 不是简单调用 hashCode()：

      ```java
      static final int hash(Object key) {
       	int h;
          return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
      }
      ```

  - 目的：都是 2 的 n 次方的话，计算所属哈希桶时，**可以使用 & 按位与优化 % 取模计算**（hash & 15 == hash % 16）

- Java 7 和 Java 8 的 HashMap 区别

  - 哈希冲突：链表 -> 链表/红黑树

    - Java 8 引入树化机制：链表长度大于等于 8 时，全表超过 64 个节点后，转红黑树；没超过最小树化阈值就扩容；红黑树节点数量小于等于 6 时，退化回链表。

  - 插入链表时：头插法 -> 尾插法

    - 避免多线程下扩容可能形成死循环链表

  - 扩容和插入时机：扩容后插入，转移数据时单独计算 -> 扩容前插入，转移数据时统一计算

    - 统一计算也是防止了扩容时形成死循环链表

  - 扩容后的存储位置：按 hashCode() 扰动处理 再 (h & length -1) 重新计算一遍 -> 扩容后的桶索引要么是原索引，要么是原索引+原容量

  - hash() 的实现：四次右移连续 ^  -> hashCode() ^ 一次右移

    - Java 7：

      ```java
      h ^= (h >>> 20) ^ (h >>> 12);
      return h ^ (h >>> 7) ^ (h >>> 4);
      ```

    - Java 8：

      ```java
      int h;
      return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
      ```

  - 初始化方法：单独方法 `inflateTable()` -> 直接在第一次 `put()` 时利用 `resize()` 初始化 table


参考文档：

1. [2024年面试准备-2-集合篇.md](./2024年面试准备-2-集合篇.md) HashMap

## Hashtable

- 较为远古的使用Hash算法的容器结构了，现在基本已被淘汰

- 注意一下类名是 Hashtable, t 小写！

- 继承结构

  ```mermaid
  classDiagram
  	Dictionary <|--Hashtable
  	Map <|.. Hashtable
  	Cloneable <|.. Hashtable
  	Serializable <|.. Hashtable
  ```

- 线程安全

  - 几乎所有都加了 synchronized 锁
  - 不允许 key、value 为 null，理由参考 ConcurrentHashMap

- 结构：数组 + 单向链表

- 默认初始长度 11

- 默认加载因子 0.75

- 求 hash 值：

  ```java
  int hash = key.hashCode();
  int index = (hash & 0x7FFFFFFF) % tab.length;
  ```

- 扩容机制：

  - 默认的阈值是选取 `initialCapacity * loadFactor` 和 `Integer.MAX_VALUE - 8 + 1` 的最小值
  - 新的长度 = 原长度 * 2倍 + 1
  - 头插法链表

- 目前不推荐使用，单线程可以用 HashMap，多线程用 ConcurrentHashMap

参考文档：

1. [2024年面试准备-2-集合篇.md](./2024年面试准备-2-集合篇.md) Hashtable

# JVM

## 对象结构

- 对象头（Header）
  - MarkWord（4 字节）
    - 其内容是一系列的标记位，比如轻量级锁的标记位，偏向锁标记位等等
  - Class 对象指针（4 字节）
    - 其指向的位置是对象对应的Class对象（其对应的元数据对象）的内存地址
- 实例数据（Instance Data）
  - 对象实际数据（实际数据大小）
    - 这里面包括了对象的所有成员变量，其大小由各个成员变量的大小决定，比如：byte和boolean是1个字节，short和char是2个字节，int和float是4个字节，long和double是8个字节，reference是4个字节
- 对齐填充（Padding）
  - 可选（按 8 字节对齐）

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景一：Java 中的 String 类占用多大的内存空间 - Java 对象的结构

## 类加载时机和过程

- 一个类型从被加载到虚拟机内存中开始，到卸载出内存为止，它的整个生命周期将会经历**加载（Loading）、验证（Verification）、准备（Preparation）、解析（Resolution）、初始化（Initialization）、使用（Using）和卸载（Unloading）**七个阶段
  - 其中**验证、准备、解析**三个部分统称为**连接（Linking）**
  - **加载、验证、准备、初始化和卸载这五个阶段的顺序是确定的**，类型的加载过程必须按照这种顺序按部就班地开始
    - 请注意，这里笔者写的是按部就班地“开始”，而不是按部就班地“进行”或按部就班地“完成”，强调这点是因为这些阶段通常都是互相交叉地混合进行的，会在一个阶段执行的过程中调用、激活另一个阶段。
  - **而解析阶段则不一定**：它在某些情况下可以在初始化阶段之后再开始，这是为了支持Java语言的运行时绑定特性（也称为动态绑定或晚期绑定）。
- 关于在什么情况下需要开始类加载过程的第一个阶段“加载”，《Java虚拟机规范》中并没有进行强制约束，这点可以交给虚拟机的具体实现来自由把握
- 但是对于初始化阶段，《Java虚拟机规范》则是严格规定了**有且只有**六种情况必须立即对类进行“初始化”（而加载、验证、准备自然需要在此之前开始）：这六种场景中的行为称为**对一个类型进行主动引用**。
  - 遇到**new、getstatic、putstatic或invokestatic这四条字节码指令**时，如果类型没有进行过初始化，则需要先触发其初始化阶段。
    - 能够生成这四条指令的典型Java代码场景有：
      - 使用 **new 关键字**实例化对象的时候。
      - 读取或设置一个类型的**静态字段**（被final修饰、已在编译期把结果放入常量池的静态字段除外）的时候。
      - 调用一个类型的**静态方法**的时候。
  - 使用 **java.lang.reflect 包**的方法对类型进行**反射调用**的时候，如果类型没有进行过初始化，则需要先触发其初始化。
  - 当初始化类的时候，如果发现其**父类**还没有进行过初始化，则需要先触发其父类的初始化。
  - 当虚拟机启动时，用户需要指定一个要执行的**主类（包含main()方法的那个类）**，虚拟机会先初始化这个主类。
  - 当使用JDK 7新加入的动态语言支持时，如果一个java.lang.invoke.MethodHandle实例最后的解析结果为**REF_getStatic、REF_putStatic、REF_invokeStatic、REF_newInvokeSpecial四种类型的方法句柄**，并且这个方法句柄对应的类没有进行过初始化，则需要先触发其初始化。
  - 当一个接口中定义了JDK 8新加入的**默认方法（被default关键字修饰的接口方法）**时，如果有这个接口的实现类发生了初始化，那该接口要在其之前被初始化。

参考文档：

1. [2024年面试准备-3-JVM篇.md](./2024年面试准备-3-JVM篇.md) 7.2 类加载的时机

## 类加载过程 1：加载

- 在加载阶段，Java虚拟机需要完成以下三件事情：
  - 通过一个类的全限定名来获取定义此类的**二进制字节流**。
    - 它并没有指明二进制字节流必须得从某个Class文件中获取，确切地说是根本没有指明要从哪里获取、如何获取。许多举足轻重的Java技术都建立在这一基础之上，例如：
      - 从ZIP压缩包中读取，这很常见，最终成为日后JAR、EAR、WAR格式的基础。
      - 从网络中获取，这种场景最典型的应用就是Web Applet。
      - 运行时计算生成，这种场景使用得最多的就是动态代理技术，在java.lang.reflect.Proxy中，就是用了ProxyGenerator.generateProxyClass()来为特定接口生成形式为“*$Proxy”的代理类的二进制字节流。
      - 由其他文件生成，典型场景是JSP应用，由JSP文件生成对应的Class文件。
      - 从数据库中读取，这种场景相对少见些，例如有些中间件服务器（如SAP Netweaver）可以选择把程序安装到数据库中来完成程序代码在集群间的分发。
      - 可以从加密文件中获取，这是典型的防Class文件被反编译的保护措施，通过加载时解密Class文件来保障程序运行逻辑不被窥探。
  - 将这个字节流所代表的静态存储结构转化为**方法区的运行时数据结构**。
  - 在内存中生成一个代表这个类的**java.lang.Class对象**，作为方法区这个类的各种数据的访问入口。
- 相对于类加载过程的其他阶段，**非数组类型的加载阶段（准确地说，是加载阶段中获取类的二进制字节流的动作）是开发人员可控性最强的阶段**。
  - 加载阶段既可以使用Java虚拟机里内置的引导类加载器来完成，也可以由用户自定义的类加载器去完成，开发人员通过定义自己的类加载器去控制字节流的获取方式（重写一个类加载器的findClass()或loadClass()方法），实现根据自己的想法来赋予应用程序获取运行代码的动态性。
- 对于数组类而言，情况就有所不同，**数组类本身不通过类加载器创建**，它是由Java虚拟机直接在内存中动态构造出来的。但数组类与类加载器仍然有很密切的关系，因为**数组类的元素类型（ElementType，指的是数组去掉所有维度的类型）最终还是要靠类加载器来完成加载**
  - 一个数组类（下面简称为C）创建过程遵循以下规则：
    - 如果数组的组件类型（Component Type，指的是数组去掉一个维度的类型，注意和前面的元素类型区分开来）是引用类型，那就递归采用本节中定义的加载过程去加载这个组件类型，数组C将被标识在加载该组件类型的类加载器的类名称空间上（这点很重要，在7.4节会介绍，一个类型必须与类加载器一起确定唯一性）。
    - 如果数组的组件类型不是引用类型（例如int[]数组的组件类型为int），Java虚拟机将会把数组C标记为与引导类加载器关联。
    - 数组类的可访问性与它的组件类型的可访问性一致，如果组件类型不是引用类型，它的数组类的可访问性将默认为public，可被所有的类和接口访问到。
  - 加载阶段结束后，Java虚拟机外部的二进制字节流就按照虚拟机所设定的格式存储在方法区之中了，方法区中的数据存储格式完全由虚拟机实现自行定义
- 加载阶段与连接阶段的部分动作（如一部分字节码文件格式验证动作）是交叉进行的，加载阶段尚未完成，连接阶段可能已经开始，但这些夹在加载阶段之中进行的动作，仍然属于连接阶段的一部分，这两个阶段的开始时间仍然保持着固定的先后顺序。

参考文档：

1. [2024年面试准备-3-JVM篇.md](./2024年面试准备-3-JVM篇.md) 7.3.1 加载

## 类加载过程 2：验证

- **验证是连接阶段的第一步**，这一阶段的目的是确保Class文件的字节流中包含的信息符合《Java虚拟机规范》的全部约束要求，保证这些信息被当作代码运行后不会危害虚拟机自身的安全。
- 验证阶段大致上会完成下面四个阶段的检验动作
  - **文件格式验证**
    - 第一阶段要验证字节流是否符合Class文件格式的规范，并且能被当前版本的虚拟机处理
    - 这一阶段可能包括下面这些验证点：
      - 是否以魔数0xCAFEBABE开头。
      - 主、次版本号是否在当前Java虚拟机接受范围之内。
      - 常量池的常量中是否有不被支持的常量类型（检查常量tag标志）。
      - 指向常量的各种索引值中是否有指向不存在的常量或不符合类型的常量。
      - CONSTANT_Utf8_info型的常量中是否有不符合UTF-8编码的数据。
      - Class文件中各个部分及文件本身是否有被删除的或附加的其他信息。
      - ……
    - 该验证阶段的主要目的是保证输入的字节流能正确地解析并存储于方法区之内，格式上符合描述一个Java类型信息的要求。
    - 这阶段的验证是基于二进制字节流进行的，只有通过了这个阶段的验证之后，这段字节流才被允许进入Java虚拟机内存的方法区中进行存储
      - 所以后面的三个验证阶段全部是基于方法区的存储结构上进行的，不会再直接读取、操作字节流了。
  - **元数据验证**
    - 第二阶段是对字节码描述的信息进行语义分析，以保证其描述的信息符合《Java语言规范》的要求
    - 这个阶段可能包括的验证点如下：
      - 这个类是否有父类（除了java.lang.Object之外，所有的类都应当有父类）。
      - 这个类的父类是否继承了不允许被继承的类（被final修饰的类）。
      - 如果这个类不是抽象类，是否实现了其父类或接口之中要求实现的所有方法。
      - 类中的字段、方法是否与父类产生矛盾（例如覆盖了父类的final字段，或者出现不符合规则的方法重载，例如方法参数都一致，但返回值类型却不同等）。
      - ……
    - 第二阶段的主要目的是对类的元数据信息进行语义校验，保证不存在与《Java语言规范》定义相悖的元数据信息。
  - **字节码验证**
    - 第三阶段是整个验证过程中最复杂的一个阶段，主要目的是通过数据流分析和控制流分析，确定程序语义是合法的、符合逻辑的。
    - 这阶段就要对类的方法体（Class文件中的Code属性）进行校验分析，保证被校验类的方法在运行时不会做出危害虚拟机安全的行为，例如：
      - 保证任意时刻操作数栈的数据类型与指令代码序列都能配合工作，例如不会出现类似于“在操作栈放置了一个int类型的数据，使用时却按long类型来加载入本地变量表中”这样的情况。
      - 保证任何跳转指令都不会跳转到方法体以外的字节码指令上。
      - 保证方法体中的类型转换总是有效的，例如可以把一个子类对象赋值给父类数据类型，这是安全的，但是把父类对象赋值给子类数据类型，甚至把对象赋值给与它毫无继承关系、完全不相干的一个数据类型，则是危险和不合法的。
      - ……
    - 由于数据流分析和控制流分析的高度复杂性，Java虚拟机的设计团队为了避免过多的执行时间消耗在字节码验证阶段中，在JDK 6之后的Javac编译器和Java虚拟机里进行了一项联合优化，把尽可能多的校验辅助措施挪到Javac编译器里进行。
      - 具体做法是给方法体Code属性的属性表中新增加了一项名为“StackMapTable”的新属性，这项属性描述了方法体所有的基本块（Basic Block，指按照控制流拆分的代码块）开始时本地变量表和操作栈应有的状态，在字节码验证期间，Java虚拟机就不需要根据程序推导这些状态的合法性，只需要检查StackMapTable属性中的记录是否合法即可。
      - 这样就将字节码验证的类型推导转变为类型检查，从而节省了大量校验时间。
      - 而到了 JDK 7 之后，尽管虚拟机中仍然保留着类型推导验证器的代码，但是对于主版本号大于50（对应JDK6）的Class文件，使用类型检查来完成数据流分析校验则是唯一的选择，不允许再退回到原来的类型推导的校验方式。
  - **符号引用验证**
    - 最后一个阶段的校验行为发生在虚拟机将符号引用转化为直接引用的时候，**这个转化动作将在连接的第三阶段——解析阶段中发生**。
    - 符号引用验证可以看作是对类自身以外（常量池中的各种符号引用）的各类信息进行匹配性校验，通俗来说就是，该类是否缺少或者被禁止访问它依赖的某些外部类、方法、字段等资源。
    - 本阶段通常需要校验下列内容：
      - 符号引用中通过字符串描述的全限定名是否能找到对应的类。
      - 在指定类中是否存在符合方法的字段描述符及简单名称所描述的方法和字段。
      - 符号引用中的类、字段、方法的可访问性（private、protected、public、`<package>`）是否可被当前类访问。
    - 符号引用验证的主要目的是确保解析行为能正常执行
      - 如果无法通过符号引用验证，Java虚拟机将会抛出一个java.lang.IncompatibleClassChangeError的子类异常，典型的如：java.lang.IllegalAccessError、java.lang.NoSuchFieldError、java.lang.NoSuchMethodError等。
- 验证阶段对于虚拟机的类加载机制来说，是一个非常重要的、但却不是必须要执行的阶段，因为验证阶段只有通过或者不通过的差别，只要通过了验证，其后就对程序运行期没有任何影响了。
  - 如果程序运行的全部代码（包括自己编写的、第三方包中的、从外部加载的、动态生成的等所有代码）都已经被反复使用和验证过，在生产环境的实施阶段就可以考虑**使用 -Xverify:none 参数来关闭大部分的类验证措施，以缩短虚拟机类加载的时间**。

参考文档：

1. [2024年面试准备-3-JVM篇.md](./2024年面试准备-3-JVM篇.md) 7.3.2 验证

## 类加载过程 3：准备

- 准备阶段是**正式为类中定义的变量（即静态变量，被static修饰的变量）分配内存并设置类变量初始值的阶段**
  - 从概念上讲，这些变量所使用的内存都应当在方法区中进行分配，但必须注意到方法区本身是一个逻辑上的区域
    - 在JDK 7及之前，HotSpot使用永久代来实现方法区时，实现是完全符合这种逻辑概念的；
    - 而在JDK 8及之后，类变量则会随着Class对象一起存放在Java堆中，这时候“类变量在方法区”就完全是一种对逻辑概念的表述了
- 关于准备阶段，还有两个容易产生混淆的概念笔者需要着重强调
  - 首先是这时候进行内存分配的仅包括类变量，而**不包括实例变量**，实例变量将会在对象实例化时随着对象一起分配在Java堆中
  - 其次是这里所说的初始值**“通常情况”下是数据类型的零值**
    - “特殊情况”：如果类字段的字段属性表中存在 ConstantValue 属性，那在准备阶段变量值就会被初始化为 **ConstantValue 属性所指定的初始值**
      - 目前 Oracle 公司实现的 Javac 编译器的选择是，如果**同时使用 final 和 static 来修饰一个变量**（按照习惯，这里称“常量”更贴切），并且这个变量的数据类型是**基本类型或者 java.lang.String** 的话，就将会生成 ConstantValue 属性来进行初始化；
      - 如果这个变量没有被 final 修饰，或者并非基本类型及字符串，则将会选择在 `<clinit>()` 方法中进行初始化。

参考文档：

1. [2024年面试准备-3-JVM篇.md](./2024年面试准备-3-JVM篇.md) 7.3.3 准备

## 类加载过程 4：解析

- 解析阶段是**Java虚拟机将常量池内的符号引用替换为直接引用的过程**
  - 符号引用在第6章讲解 Class 文件格式的时候已经出现过多次，在Class文件中它以CONSTANT_Class_info、CONSTANT_Fieldref_info、CONSTANT_Methodref_info等类型的常量出现
  - 那解析阶段中所说的直接引用与符号引用又有什么关联呢？
    - **符号引用（Symbolic References）**：符号引用以一组符号来描述所引用的目标，符号可以是任何形式的字面量，只要使用时能无歧义地定位到目标即可。
    - **直接引用（Direct References）**：直接引用是可以直接指向目标的指针、相对偏移量或者是一个能间接定位到目标的句柄。
- 《Java虚拟机规范》之中并未规定解析阶段发生的具体时间，只要求了在执行ane-warray、checkcast、getfield、getstatic、instanceof、invokedynamic、invokeinterface、invoke-special、invokestatic、invokevirtual、ldc、ldc_w、ldc2_w、multianewarray、new、putfield和putstatic这17个用于操作符号引用的字节码指令之前，先对它们所使用的符号引用进行解析。
- 对同一个符号引用进行多次解析请求是很常见的事情，**除 invokedynamic 指令以外**，虚拟机实现可以**对第一次解析的结果进行缓存**，譬如在运行时直接引用常量池中的记录，并把常量标识为已解析状态，从而避免解析动作重复进行。
  - 不过对于invokedynamic指令，上面的规则就不成立了。当碰到某个前面已经由invokedynamic指令触发过解析的符号引用时，并不意味着这个解析结果对于其他invokedynamic指令也同样生效。
  - 因为 invokedynamic 指令的目的本来就是用于动态语言支持，它对应的引用称为“动态调用点限定符（Dynamically-Computed Call Site Specifier）”，这里“动态”的含义是指必须等到程序实际运行到这条指令时，解析动作才能进行。
  - 相对地，其余可触发解析的指令都是“静态”的，可以在刚刚完成加载阶段，还没有开始执行代码时就提前进行解析。
- 解析动作主要针对**类或接口、字段、类方法、接口方法、方法类型、方法句柄和调用点限定符这7类符号引用**进行
  - 分别对应于常量池的CONSTANT_Class_info、CON-STANT_Fieldref_info、CONSTANT_Methodref_info、CONSTANT_InterfaceMethodref_info、CONSTANT_MethodType_info、CONSTANT_MethodHandle_info、CONSTANT_Dyna-mic_info和CONSTANT_InvokeDynamic_info 8种常量类型
  - 1.类或接口的解析
  - 2.字段解析
  - 3.方法解析
  - 4.接口方法解析

参考文档：

1. [2024年面试准备-3-JVM篇.md](./2024年面试准备-3-JVM篇.md) 7.3.4 解析

## 类加载过程 5：初始化

- 类的初始化阶段是类加载过程的最后一个步骤，之前介绍的几个类加载的动作里，除了在加载阶段用户应用程序可以通过自定义类加载器的方式局部参与外，其余动作都完全由Java虚拟机来主导控制。
  - 直到初始化阶段，Java虚拟机才真正开始执行类中编写的Java程序代码，将主导权移交给应用程序。
- 进行准备阶段时，变量已经赋过一次系统要求的初始零值，而在初始化阶段，则会根据程序员通过程序编码制定的主观计划去初始化类变量和其他资源。
  - 我们也可以从另外一种更直接的形式来表达：**初始化阶段就是执行类构造器 `<clinit>()` 方法的过程**。
  - `<clinit>()` 并不是程序员在 Java 代码中直接编写的方法，它是 Javac 编译器的自动生成物
- `<clinit>()`
  - `<clinit>()` 方法是由编译器自动收集类中的**所有类变量的赋值动作和静态语句块（static{}块）中的语句**合并产生的，**编译器收集的顺序是由语句在源文件中出现的顺序决定的**，静态语句块中只能访问到定义在静态语句块之前的变量，定义在它之后的变量，在前面的静态语句块可以赋值，但是不能访问
  - `<clinit>()` 方法与类的构造函数（即在虚拟机视角中的实例构造器 `<init>()` 方法）不同，它不需要显式地调用父类构造器，**Java虚拟机会保证在子类的 `<clinit>()` 方法执行前，父类的 `<clinit>()` 方法已经执行完毕**。因此在Java虚拟机中第一个被执行的 `<clinit>()` 方法的类型肯定是 java.lang.Object。
  - 由于父类的 `<clinit>()` 方法先执行，也就意味着父类中定义的静态语句块要优先于子类的变量赋值操作
  - `<clinit>()` 方法对于类或接口来说并不是必需的，如果一个类中没有静态语句块，也没有对变量的赋值操作，那么编译器可以不为这个类生成 `<clinit>()` 方法。
  - 接口中不能使用静态语句块，但仍然有变量初始化的赋值操作，因此接口与类一样都会生成 `<clinit>()` 方法。但**接口与类不同的是，执行接口的 `<clinit>()` 方法不需要先执行父接口的 `<clinit>()` 方法，因为只有当父接口中定义的变量被使用时，父接口才会被初始化**。此外，接口的实现类在初始化时也一样不会执行接口的  `<clinit>()` 方法。
  - Java 虚拟机必须保证一个类的 `<clinit>()` 方法在多线程环境中被正确地加锁同步，如果多个线程同时去初始化一个类，那么只会有其中一个线程去执行这个类的 `<clinit>()` 方法，其他线程都需要阻塞等待，直到活动线程执行完毕 `<clinit>()` 方法。如果在一个类的 `<clinit>()` 方法中有耗时很长的操作，那就可能造成多个进程阻塞，在实际应用中这种阻塞往往是很隐蔽的。

参考文档：

1. [2024年面试准备-3-JVM篇.md](./2024年面试准备-3-JVM篇.md) 7.3.5 初始化

# 多线程

## 进程通信

- 管道( pipe )：
  - 管道是一种半双工的通信方式，数据只能单向流动，而且只能在具有亲缘关系的进程间使用。进程的亲缘关系通常是指父子进程关系。
- 有名管道 (namedpipe) ：
  - 有名管道也是半双工的通信方式，但是它允许无亲缘关系进程间的通信。
- 信号量(semophore ) ：
  - 信号量是一个计数器，可以用来控制多个进程对共享资源的访问。它常作为一种锁机制，防止某进程正在访问共享资源时，其他进程也访问该资源。因此，主要作为进程间以及同一进程内不同线程之间的同步手段。
- 消息队列( messagequeue ) ：
  - 消息队列是由消息的链表，存放在内核中并由消息队列标识符标识。消息队列克服了信号传递信息少、管道只能承载无格式字节流以及缓冲区大小受限等缺点。
- 信号 (sinal ) 
  - 信号是一种比较复杂的通信方式，用于通知接收进程某个事件已经发生。
- 共享内存(shared memory ) ：
  - 共享内存就是映射一段能被其他进程所访问的内存，这段共享内存由一个进程创建，但多个进程都可以访问。共享内存是最快的 IPC 方式，它是针对其他进程间通信方式运行效率低而专门设计的。它往往与其他通信机制，如信号两，配合使用，来实现进程间的同步和通信。
- 套接字(socket ) ：
  - 套接口也是一种进程间通信机制，与其他通信机制不同的是，它可用于不同设备及其间的进程通信。

参考文档：

1. [面试官：说说进程间通信和线程间通信的几种方式及区别 - 知乎](https://zhuanlan.zhihu.com/p/430069448)

## 线程通信

- 锁机制：包括互斥锁、条件变量、读写锁
- 信号量机制(Semaphore)：包括无名线程信号量和命名线程信号量
- 信号机制(Signal)：类似进程间的信号处理

参考文档：

1. [面试官：说说进程间通信和线程间通信的几种方式及区别 - 知乎](https://zhuanlan.zhihu.com/p/430069448)

## 线程和进程区别

- 调度：
  - 线程作为处理器调度和分配的基本单位
  - 而进程是作为拥有资源的基本单位
- 并发性
  - 不仅进程之间可以并发执行
  - 同一个进程的多个线程之间也可以并发执行
- 拥有资源
  - 进程是拥有资源的一个独立单位，有自己独立的地址空间
  - 线程不拥有系统资源，但可以访问隶属于进程的资源，共享进程的地址空间.
- 系统开销
  - 在创建或撤消进程时，由于系统都要为之分配和回收资源，导致系统的开销明显大于创建或撤消线程时的开销。

参考文档：

1. [操作系统：进程与线程之间的区别及联系](https://zhuanlan.zhihu.com/p/505594640)

## 查看线程/进程 CPU 使用率

- 那么首先需要获取这个进程的PID: `ps -ef| grep [process name]`
- 然后查看该进程的CPU: `top -p [PID]`
  - `-p <进程ID>`：仅显示指定进程ID的信息。
- 查看这个进程的各个进程的CPU: `top -H -p [PID]`
  - `-H`：在进程信息中显示线程详细信息。
  - `-d <秒数>`：指定 top 命令的刷新时间间隔，单位为秒。

参考文档：

1. [linux 下查看某一进程的cpu使用率和这个线程中各个线程的cpu使用率 - CSDN](https://blog.csdn.net/learners_sjt/article/details/82461079)
2. [Linux top 命令 - RUNOOB](https://www.runoob.com/linux/linux-comm-top.html)

## 死锁必要条件、预防、避免

- 四个必要条件
  - **互斥条件**：资源是独占的且排他使用，进程互斥使用资源，即任意时刻一个资源只能给一个进程使用，其他进程若申请一个资源，而该资源被另一进程占有时，则申请者等待直到资源被占有者释放。
  - **不可剥夺条件**：进程所获得的资源在未使用完毕之前，不被其他进程强行剥夺，而只能由获得该资源的进程资源释放。
  - **请求和保持条件**：进程每次申请它所需要的一部分资源，在申请新的资源的同时，继续占用已分配到的资源。
  - **循环等待条件**：在发生死锁时必然存在一个进程等待队列{P1,P2,…,Pn},其中P1等待P2占有的资源，P2等待P3占有的资源，…，Pn等待P1占有的资源，形成一个进程等待环路，环路中每一个进程所占有的资源同时被另一个申请，也就是前一个进程占有后一个进程所深情地资源。
  - 以上给出了导致死锁的四个必要条件，只要系统发生死锁则以上四个条件至少有一个成立。事实上循环等待的成立蕴含了前三个条件的成立，似乎没有必要列出然而考虑这些条件对死锁的预防是有利的，因为可以通过破坏四个条件中的任何一个来预防死锁的发生。
- 死锁预防
  - 我们可以通过破坏死锁产生的4个必要条件来 预防死锁，由于资源互斥是资源使用的固有特性是无法改变的。
  - **破坏“不可剥夺”条件**：一个进程不能获得所需要的全部资源时便处于等待状态，等待期间他占有的资源将被隐式的释放重新加入到 系统的资源列表中，可以被其他的进程使用，而等待的进程只有重新获得自己原有的资源以及新申请的资源才可以重新启动，执行。
  - **破坏”请求与保持条件“**：第一种方法静态分配即每个进程在开始执行时就申请他所需要的全部资源。第二种是动态分配即每个进程在申请所需要的资源时他本身不占用系统资源。
  - **破坏“循环等待”条件**：采用资源有序分配其基本思想是将系统中的所有资源顺序编号，将紧缺的，稀少的采用较大的编号，在申请资源时必须按照编号的顺序进行，一个进程只有获得较小编号的进程才能申请较大编号的进程。
- 死锁避免
  - 死锁避免的基本思想：系统对进程发出的每一个系统能够满足的资源申请进行动态检查，并根据检查结果决定是否分配资源，如果分配后系统可能发生死锁，则不予分配，否则予以分配，这是一种保证系统不进入死锁状态的动态策略。
  - 银行家算法
  - 安全状态、不安全状态

参考文档：

1. [死锁的四个必要条件](https://blog.csdn.net/jyy305/article/details/70077042)

# Spring

## 循环依赖

三层缓存

- 加入 singletonFactories 三级缓存的前提是**执行了构造器**，所以构造器的循环依赖无法解决。

三层缓存：

- singletonObjects
- earlySingletonObjects
- singletonFactories

```java
public class DefaultSingletonBeanRegistry extends SimpleAliasRegistry implements SingletonBeanRegistry {
	...
	// 从上至下 分表代表这“三级缓存”
	private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>(256); //一级缓存，存放完全实例化且属性赋值完成的 Bean ，可以直接使用
	private final Map<String, Object> earlySingletonObjects = new HashMap<>(16); // 二级缓存，存放早期 Bean 的引用，尚未装配属性的 Bean
	private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<>(16); // 三级缓存，存放实例化完成的 Bean 工厂
    ...
	
	/** Names of beans that are currently in creation. */
	// 这个缓存也十分重要：它表示bean创建过程中都会在里面呆着~
	// 它在Bean开始创建时放值，创建完成时会将其移出~
	private final Set<String> singletonsCurrentlyInCreation = Collections.newSetFromMap(new ConcurrentHashMap<>(16));

	/** Names of beans that have already been created at least once. */
	// 当这个Bean被创建完成后，会标记为这个 注意：这里是set集合 不会重复
	// 至少被创建了一次的  都会放进这里~~~~
	private final Set<String> alreadyCreated = Collections.newSetFromMap(new ConcurrentHashMap<>(256));
    ...
	@Override
	@Nullable
	public Object getSingleton(String beanName) {
		return getSingleton(beanName, true);
	}
	@Nullable
	protected Object getSingleton(String beanName, boolean allowEarlyReference) {
		//1.先从一级缓存中获取，获取到直接返回
		Object singletonObject = this.singletonObjects.get(beanName);
		//2.如果获取不到或对象正在创建，就到二级缓存中去获取，获取到直接返回
		if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
			synchronized (this.singletonObjects) {
				singletonObject = this.earlySingletonObjects.get(beanName);
				//3.如果仍获取不到，且允许 singletonFactories(allowEarlyCurrentlyInCreation()）通过 getObject()获取。
				//就到三级缓存中用 getObject() 获取。
				//获取到就从 singletonFactories中移出，且放进 earlySingletonObjects。
				//（即从三级缓存移动到二级缓存）
				if (singletonObject == null && allowEarlyReference) {
					ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
					if (singletonFactory != null) {
						singletonObject = singletonFactory.getObject();
						this.earlySingletonObjects.put(beanName, singletonObject);
						this.singletonFactories.remove(beanName);
					}
				}
			}
		}
		return singletonObject;
	}
	...
	public boolean isSingletonCurrentlyInCreation(String beanName) {
		return this.singletonsCurrentlyInCreation.contains(beanName);
	}
	protected boolean isActuallyInCreation(String beanName) {
		return isSingletonCurrentlyInCreation(beanName);
	}
	...
}
```

getBean() -> doGetBean() -> createBean() -> doCreateBean() -> 返回 Bean

创建 Bean 的三个核心方法

- createBeanInstance()：例化，即调用对象的构造方法实例化对象
- populateBean()：填充属性，主要对 bean 的依赖属性注入（@Autowired）
- initializeBean()：回到一些如initMethod，InitalizingBean等方法



为什么是三层不是两层：考虑 AOP 代理对象

1. 假设去掉三级缓存：在实例化阶段就得执行后置处理器，判断有 AnnotationAwareAspectJAutoProxyCreator 并创建代理对象。
2. 假设去掉二级缓存：如果去掉了二级缓存，则需要直接在 `singletonFactory.getObject()` 阶段初始化完毕，并放到一级缓存中。那有这么一种场景，B 和 C 都依赖了 A。而多次调用 `singletonFactory.getObject()` 返回的代理对象是不同的，就会导致 B 和 C 依赖了不同的 A。



**参考文档**

1. [彻底搞懂Spring之三级缓存解决循环依赖问题 - 知乎](https://zhuanlan.zhihu.com/p/610322151)

# MySQL

## 索引类型

- 索引按照**物理实现**方式，索引可以分为 2 种：**聚簇（聚集）**和**非聚簇（非聚集）**索引。
  - 我们也把非聚簇索引称为**二级索引**或者**辅助索引**。
  - 以多个列的大小为排序规则建立的 B+ 树称为**联合索引**，本质上也是一个二级索引。
- 按照**功能逻辑**区分，MySQL目前主要有以下索引类型：
  - **主键索引**
    - 数据列不允许重复，不允许为 NULL，一个表只能有一个主键。
    - `ALTER TABLE table_name ADD PRIMARY KEY (column);`
  - **普通索引**
    - MySQL中基本索引类型，没有什么限制，允许在定义索引的列中插入重复值和NULL值。一个表允许多个列创建普通索引。
    - `ALTER TABLE table_name ADD INDEX index_name (column);`
  - **唯一索引**
    - 索引列中的值必须是唯一的，但是允许NULL值。建立唯一索引的目的大部分时候都是为了该属性列的数据的唯一性，而不是为了查询效率。一个表允许多个列创建唯一索引。
    - `ALTER TABLE table_name ADD UNIQUE (column);`
  - **全文索引**
    - 主要是为了快速检索大文本数据中的关键字的信息。字段长度比较大时，如果创建普通索引，在进行like模糊查询时效率比较低，这时可以创建全文索引，基于倒排索引，类似于搜索引擎。MyISAM存储引擎支持全文索引，InnoDB 存储引擎在 MySQL 5.6.4 版本中也开始支持全文索引。
    - `ALTER TABLE table_name ADD FULLTEXT (column);`
  - **前缀索引**
    - 在文本类型如BLOB、TEXT或者很长的VARCHAR列上创建索引时，可以使用前缀索引，数据量相比普通索引更小，可以指定索引列的长度，但是数值类型不能指定。
    - `ALTER TABLE table_name ADD KEY(column_name(prefix_length));`
  - **组合索引**
    - 指多个字段上创建的索引，只有在查询条件中使用了创建索引时的第一个字段，索引才会被使用。使用组合索引时遵循最左前缀原则。
    - 主键索引、普通索引、唯一索引等都可以使用多个字段形成组合索引。例如，`ALTER TABLE table_name ADD INDEX index_name ( column1, column2, column3 );`
  - **空间索引**
    - MySQL在5.7之后的版本支持了空间索引，而且支持OpenGIS几何数据模型。MySQL在空间索引这方面遵循OpenGIS几何数据模型规则。

参考文档

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P118
2. [MySQL索引的概念以及七种索引类型介绍 - CSDN](https://blog.csdn.net/weixin_43767015/article/details/119109385)

## 索引失效

- **最佳左前缀法则**
  - 在 MySQL 建立联合索引时会遵守最佳左前缀匹配原则，即最左优先，在检索数据时从联合索引的最左边开始匹配。
  - 如果索引了多列，要遵守最左前缀法则。指的是查询从索引的最左前列开始并且不跳过索引中的列。
  - 对于多列索引，**过滤条件要使用索引必须按照索引建立时的顺序，依次满足，一旦跳过某个字段，索引后面的字段都无法被使用**。如果查询条件中没有使用这些字段中第 1 个字段时，多列（或联合）索引不会被使用。
- **主键**插入顺序
  - 对于一个使用 `InnoDB` 存储引擎的表来说，在我们没有显式的创建索引时，表中的数据实际上都是存储在聚簇索引的叶子节点的。
  - 而记录又是存储在数据页中的，数据页和记录又是按照记录主键值从小到大的顺序进行排序，所以如果我们插入的记录的主键值是依次增大的话，那我们每插满一个数据页就换到下一个数据页继续插，而如果我们插入的主键值忽大忽小的话，就比较麻烦了。
  - 所以我们建议：让主键具有 `AUTO_INCREMENT`，让存储引擎自己为表生成主键，而不是我们手动插入。
    - 数据页已经满了，再插进来怎么办呢？我们需要把当前页面分裂成两个页面，把本页中的一些记录移动到新创建的这个页中。**页面分裂**和**记录移位**意味着什么？意味着：性能损耗！所以如果我们想尽量避免这样无谓的性能损耗，最好让插入的记录的主键值依次递增，这样就不会发生这样的性能损耗了。
- **计算、函数、类型转换（自动或手动）**导致索引失效
- **类型转换**导致索引失效
- **范围条件**右边的列索引失效
  - 范围右边的列不能使用。比如：（<）（<=）（>）（>=）和 between 等
  - 将范围查询条件放置语句最后
- **不等于**（!= 或者 <>）索引失效
- is null 可以使用索引，**is not null** 无法使用索引
- **like 以通配符 % 开头**索引失效
- **OR 前后存在非索引的列**，索引失效
  - 在 WHERE 子句中，如果在 OR 前的条件列进行了索引，而在 OR 后的条件列没有进行索引，那么索引会失效。也就是说，**OR 前后的两个条件中的列都是索引时，查询中才使用索引**。
  - 前后都是索引列时可以使用索引合并：index_merge
- 数据库和表的字符集统一使用 utf8mb4
  - 统一使用 utf8mb4（5.5.3 版本以上支持）兼容性更好，统一字符集可以避免由于字符集转换产生的乱码。**不同的字符集进行比较前需要进行转换会造成索引失效**。

## 慢查询

- 默认情况下，MySQL 数据库没有开启慢查询日志，需要我们手动来设置这个参数。

  - 如果不是调优需要的话，一般不建议启动该参数，因为开启慢查询日志会或多或少带来一定的性能影响。

- 开启慢查询日志步骤

  - 开启 slow_query_log

    在使用前，我们需要先看下慢查询是否已经开启，使用下面这条命令即可：

    ```mysql
    show variables like '%slow_query_log%';
    ```

    我们能看到 `slow_query_log=OFF`，我们可以把慢查询日志打开，注意设置变量值的时候需要使用 global，否则会报错：

    ```mysql
    set global slow_query_log='ON';
    ```

    然后我们再来查看下慢查询日志是否开启，以及慢查询日志文件的位置（slow_query_log_file）：

    你能看到这时慢查询分析已经开启，同时文件保存在 `/var/lib/mysql/atguigu02-slow.log` 文件中。

  - 修改 long_query_time 阈值

    接下来我们来看下慢查询的时间阈值设置，使用如下命令：

    ```mysql
    show variables like '%long_query_time%';
    ```

    这里如果我们想把时间缩短，比如设置为 1 秒，可以这样设置：

    ```mysql
    #测试发现：设置 global 的方式对当前 session 的 long_query_time 失效，对新连接的客户端有效，所以可以一并执行下述语句
    set global long_query_time = 1;
    show global variables like '%long_query_time%';
    
    set long_query_time = 1;
    show variables like '%long_query_time%';
    ```

    **补充：配置文件中一并设置参数**

    如下的方式相较于前面的命令行方式，可以看作是永久设置的方式。

    修改 `my.cnf` 文件，[mysqld]下增加或修改参数 `long_query_time`、`slow_query_log` 和 `slow_query_log_file` 后，然后重启 MySQL 服务器。

    ```properties
    [mysqld]
    slow_query_log=ON # 开启慢查询日志的开关
    slow_query_log_file=/var/lib/mysql/atguigu-slow.log #慢查询日志的目录和文件名信息
    long_query_time=3 #设置慢查询的阈值为 3 秒，超出此设定值的 SQL 即被记录到慢查询日志
    log_output=FILE
    ```

    如果不指定存储路径，慢查询日志将默认存储到 MySQL 数据库的数据文件夹下。如果不指定文件名，默认文件名为 hostname-slow.log

- 查看慢查询数目

  - 查询当前系统中有多少条慢查询记录：

    ```mysql
    SHOW GLOBAL STATUS LIKE `%Slow_queries%`;
    ```

- 慢查询日志分析工具：mysqldumpslow

  - 在生产环境中，如果要手工分析日志，查找、分析 SQL，显然是个体力活，MySQL 提供了日志分析工具 `mysqldumpslow`。

  - 查看 mysqldumpslow 的帮助信息

    ```mysql
    mysqldumpslow --help
    ```

参考文档

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P135

## EXPLAIN 执行计划

- 版本情况

  - MySQL 5.6.3 以前只能 `EXPLAIN SELECT`；MySQL 5.6.3 以后就可以 `EXPLAIN SELECT, UPDATE, DELETE`
  - 在 5.7 以前的版本中，想要显示 `partitions` 需要使用 `explain partitions` 命令；想要显示 `filtered` 需要使用 `explain extended` 命令。在 5.7 版本后，默认 explain 直接显示 partitions 和 filtered 中的信息。

- EXPLAIN 语句输出的各个列的作用如下：

  | 列名          | 描述                                                      |
  | ------------- | --------------------------------------------------------- |
  | id            | 在一个大的查询语句中每个 SELECT 关键字都对应一个唯一的 id |
  | select_type   | SELECT 关键字对应的那个查询的类型                         |
  | table         | 表名                                                      |
  | partitions    | 匹配的分区信息                                            |
  | type          | 针对单表的访问方法                                        |
  | possible_keys | 可能用到的索引                                            |
  | key           | 实际上使用的索引                                          |
  | key_len       | 实际使用到的索引长度                                      |
  | ref           | 当使用索引列等值查询时，与索引列进行等值匹配的对象信息    |
  | rows          | 预估的需要读取的记录条数                                  |
  | filtered      | 某个表经过搜索条件过滤后剩余记录条数的百分比              |
  | Extra         | 一些额外信息                                              |

- 各列作用

  - table

    - MySQL 规定 EXPLAIN 语句输出的每条记录都对应着某个单表的访问方法，该条记录的 table 列代表着该表的表名（有时不是真实的表名字，可能是简称）。

  - id

    - **查询语句中每出现一个 `SELECT` 关键字，MySQL 就会为它分配一个唯一的 `id` 值**。

    - 这个 `id` 值就是 `EXPLAIN` 语句的第一个列

    - 这里需要大家记住的是，**在连接查询的执行计划中，每个表都会对应一条记录，这些记录的 id 列的值是相同的**，出现在前边的表表示驱动表，出现在后边的表表示被驱动表。

    - 对于包含子查询的查询语句来说，就可能涉及多个 `SELECT` 关键字，所以在**包含子查询的查询语句的执行计划中，每个 `SELECT` 关键字都会对应一个唯一的 `id` 值**

    - 但是这里大家需要特别注意，**查询优化器可能对涉及子查询的查询语句进行重写，从而转换为连接查询。**所以如果我们想知道查询优化器对某个包含子查询的语句是否进行了重写，直接查看执行计划就好了

    - UNION 子句、UNION ALL 的情况：

      - 对于包含 `UNION` 子句的查询语句来说，每个 `SELECT` 关键字对应一个 `id` 值也是没错的，不过还是有点儿特别的东西，比方说下边这个查询：

        ```mysql
        EXPLAIN SELECT * FROM s1 UNION SELECT * FROM s2;
        ```

        这个语句的执行计划的第三条记录是什么？为何 `id` 值是 `NULL`，而且 table 列也很奇怪？`UNION`！它会把多个查询的结果集并起来并对结果集中的记录进行去重，怎么去重呢？MySQL 使用的是内部的临时表。正如上边的查询计划中所示，UNION 子句是为了把 id 为 1 的查询和 id 为 2 的查询的结果集合并起来并去重，所以在内部创建了一个名为 `<union1, 2>` 的临时表（就是执行计划第三条记录的 table 列的名称），id 为 `NULL` 表明这个临时表是为了合并两个查询的结果集而创建的。

      - 跟 UNION 对比起来，`UNION ALL` 就不需要为最终的结果集进行去重，它只是单纯的把多个查询的结果集中的记录合并成一个并返回给用户，所以也就不需要使用临时表。所以在包含 `UNION ALL` 子句的查询的执行计划中，就没有那个 id 为 NULL 的记录

    - 小结：

      - id 如果相同，可以认为是一组，从上往下顺序执行
      - 在所有组中，id 值越大，优先级越高，越先执行
      - 关注点：id 号每个号码，表示一趟独立的查询，一个 sql 的查询趟数越少越好

  - select_type

    - | 名称                 | 描述                                                         |
      | -------------------- | ------------------------------------------------------------ |
      | SIMPLE               | Simple SELECT (not using UNION or subqueries)<br />查询语句中不包含 `UNION` 或者子查询的查询都算作是 `SIMPLE` 类型<br />当然，连接查询也算是 `SIMPLE` 类型 |
      | PRIMARY              | Outermost SELECT<br />对于包含 `UNION`、`UNION ALL` 或者子查询的大查询组成的，其中最左边的那个查询的 `select_type` 值就是 `PRIMARY` |
      | UNION                | Second or later SELECT statement in a UNION<br />对于包含 `UNION` 或者 `UNION ALL` 的大查询来说，它是由几个小查询组成的，其中除了最左边的那个小查询以外，其余的小查询的 `select_type` 值就是 `UNION` |
      | UNION RESULT         | Result of a UNION<br />`MySQL` 选择使用临时表来完成 `UNION` 查询的去重工作，针对该临时表的查询的 `select_type` 就是 `UNION RESULT` |
      | SUBQUERY             | First SELECT in subquery<br />如果包含子查询的查询语句不能够转为对应的 `semi-join` 的形式，并且该子查询是不相关子查询，并且查询优化器决定采用将该子查询物化的方案来执行该子查询时，该子查询的第一个 `SELECT` 关键字代表的那个查询的 `select_type` 就是 `SUBQUERY` |
      | DEPENDENT SUBQUERY   | First SELECT in subquery, dependent on outer query           |
      | DEPENDENT UNION      | Second or later SELECT statement in a UNION, dependent on outer query |
      | DERIVED              | Derived table                                                |
      | MATERIALIZED         | Materialized subquery<br />当查询优化器在执行包含子查询的语句时，选择将子查询物化之后与外层查询进行连接查询时，该子查询对应的 `select_type` 属性就是 `MATERIALIZED` |
      | UNCACHEABLE SUBQUERY | A subquery for which the result cannot be cached and must be re-evaluated for each row of the outer query |
      | UNCACHEABLE UNION    | The second or later select in a UNION that belongs to an uncacheable subquery (see UNCACHEABLE SUBQUERY) |

  - partitions

    - 代表分区表中的命中情况，非分区表，该项为 `NULL`。

  - type

    - 执行计划的一条记录就代表着 MySQL 对某个表的执行查询时的访问方法，又称“访问类型”，其中的 `type` 列就表明了这个访问方法是啥，是较为重要的一个指标。

    - 完整的访问方法如下：`system`，`count`，`eq_ref`，`ref`，`fulltext`，`ref_or_null`，`index_merge`，`unique_subquery`，`index_subquery`，`range`，`index`，`ALL`。

    - 详细解释

      - system

        - 当表中只有一条记录并且该表使用的存储引擎的统计数据是精确的，比如 MyISAM、Memory，那么对该表的访问方法就是 `system`。
          - 测试：可以把表改成使用 InnoDB 存储引擎，试试看执行计划的 `type` 列是什么？ALL

      - const

        - 当我们根据**主键**或者**唯一**二级索引列与常数进行等值匹配时，对单表的访问方法就是 `const`

      - eq_ref

        - 在**连接查询**时，如果**被驱动表**是通过**主键**或者**唯一**二级索引列等值匹配的方式进行访问的（如果该主键或者唯一二级索引是联合索引的话，所有的索引列都必须进行等值比较）则对该被驱动表的访问方法就是 `eq_ref`

      - ref

        - 当通过**普通的二级索引**列与常量进行等值匹配时来查询某个表，那么对该表的访问方法就可能是 `ref`

      - fulltext

        - 全文索引

      - ref_or_null

        - 当对**普通二级索引**进行等值匹配查询，该索引列的值也可以是 `NULL` 值时，那么对该表的访问方法就可能是 `ref_or_null`

      - index_merge

        - 一般情况下对于某个表的查询只能使用到一个索引，但单表访问方法时在某些场景下可以使用 **`Intersection`、`Union`、`Sort-Union`** 这三种索引合并的方式来执行查询。

        - 例子：

          ```mysql
          EXPLAIN SELECT * FROM s1 WHERE key1 = 'a' OR key3 = 'a';
          ```

      - unique_subquery

        - 类似于两表连接中的被驱动表的 `eq_ref` 访问方法，`unique_subquery` 是针对在一些**包含 `IN` 子查询**的查询语句中，如果查询优化器决定将 `IN` 子查询转换为 `EXISTS` 子查询，而且子查询可以使用到**主键**进行**等值匹配**的话，那么该子查询执行计划的 `type` 列的值就是 `unique_subquery`

      - index_subquery

        - `index_subquery` 与 `unique_subquery` 类似，只不过访问子查询中的表时使用的是**普通的索引**

      - range

        - 如果**使用索引**获取某些**特定范围**的记录，那么就可能使用到 `range` 访问方法

      - index

        - 当我们可以使用索引覆盖，但**需要扫描全部的索引记录**时，该表的访问方法就是 `index`

      - ALL

        - 最熟悉的全表扫描

    - **小结：**

      - 结果值从最好到最坏依次是：

        **system > const > eq_ref > ref** > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > **range > index > ALL**

        其中比较重要的几个提取出来（见粗体）。

      - SQL 性能优化的目标：至少要达到 range 级别，要求是 ref 级别，最好是 const 级别。（阿里巴巴开发手册要求）

  - possible_keys

    - `possible_keys` 列表示在某个查询语句中，对某个表执行单表查询时可能用到的索引有哪些。一般查询涉及到的字段上若存在索引，则该索引将被列出，但不一定被查询使用。

  - keys

    - `key` 列表示实际用到的索引有哪些，如果为 NULL，则没有使用索引。

  - key_len

    - 实际使用到的索引长度（即：字节数）
    - 帮你检查是否充分的利用上了索引，值越大越好，主要针对于联合索引，有一定的参考意义。

  - ref

    - 显示索引的哪一列被使用了，如果可能的话，是一个常数。哪些列或常量。哪些列或常量被用于查找索引列上的值。
    - 当使用索引列等值匹配的条件去执行查询时，也就是在访问方法是 `const`、`eq_ref`、`ref`、`ref_or_null`、`unique_subquery`、`index_subquery` 其中之一时，`ref` 列展示的就是与索引列作等值匹配的结构是什么，比如只是一个常数或者是某个列。

  - rows

    - 预估的需要读取的记录条数
    - 值越小越好

  - filtered

    - 某个表经过搜索条件过滤后剩余记录条数的**百分比**

  - extra

    - 顾名思义，`Extra` 列是用来说明一些额外信息的，包含不适合在其他列中显示但十分重要的额外信息。

    - `No tables used`

      - 当查询语句的没有 `FROM` 子句时将会提示该额外信息

    - `Impossible WHERE`

      - 查询语句的 `WHERE` 子句永远为 `FALSE` 时将会提示该额外信息

    - `Using where`

      - 不用读取表中所有信息，仅通过索引就可以获取所需数据，这发生在对表的全部的请求列都是同一个索引的部分的时候，表示 mysql 服务器将在存储引擎检索行后再进行过滤。表明使用了 where 过滤。
      - 当我们使用全表扫描来执行对某个表的查询，并且该语句的 `WHERE` 子句中有针对该表的搜索条件时，在 `Extra` 列中会提示上述额外信息。

    - `No matching min/max row`

      - 当查询列表处有 `MIN` 或者 `MAX` 聚集函数，但是并没有符合 `WHERE` 子句中的搜索条件的记录时，将会提示该额外信息

    - `Using index`

      - 当我们的查询列表以及搜索条件中只包含属于某个索引的列，也就是在**可以使用索引覆盖**的情况下，在 `Extra` 列将会提示该额外信息。

    - `Using index condition`

      - 如果在查询语句的执行过程中将要使用索引条件下推这个特性，在 Extra 列中将会显示 `Using index condition`

      - **索引条件下推**

        - 有些搜索条件中虽然出现了索引列，但却不能使用到索引

        - 案例：

          - ```mysql
            SELECT * FROM s1 WHERE key1 > 'z' AND key1 LIKE '%a';
            ```

          - 先根据 `key1 > 'z'` 这个条件，定位到二级索引 `idx_key1` 中对应的二级索引记录，先不着急回表，而是先检测一下该记录是否满足 `key1 LIKE '%a'` 这个条件，如果这个条件不满足，则该二级索引记录压根儿就没必要回表。

        - 回表操作其实是一个随机 IO，比较耗时，所以上述修改虽然只改进了一点点，但是可以省去好多回表操作的成本。

    - `Using join buffer (Block Nested Loop)`

      - 在连接查询执行过程中，当被驱动表不能有效的利用索引加快访问速度，MySQL 一般会为其分配一块名叫 `join buffer` 的内存块来加快查询速度，也就是我们所讲的基于块的嵌套循环算法

    - `Not exists`

      - 当我们使用左（外）连接时，如果 `WHERE` 子句中包含要求被驱动表的某个列等于 `NULL` 值的搜索条件，而且那个列又是不允许存储 `NULL` 值的，那么在该表的执行计划的 Extra 列就会提示 `Not exists` 额外信息

    - `Using intersect(...)`、`Using union(...)` 和 `Using sort_union(...)`

      - 如果执行计划的 `Extra` 列出现了 `Using intersect(...)` 提示，说明准备使用 `Intersect` 索引合并的方式执行查询，括号中的 ... 表示需要进行索引合并的索引名称；
      - 如果出现了 `Using union(...)` 提示，说明准备使用 `Union` 索引合并的方式执行查询；
      - 出现了 `Using sort_union(...)` 提示，说明准备使用 `Sort-Union` 索引合并的方式执行查询。

    - `Zero limit`

      - 当我们的 `LIMIT` 子句参数为 0 时，表示压根不打算从表中读出任何记录，将会提示该额外信息

    - `Using filesort`

      - 但是很多情况下排序操作无法使用到索引，只能在内存中（记录较少的时候）或者磁盘中（记录较多的时候）进行排序，MySQL 把这种在内存中或者磁盘上进行排序的方式统称为文件排序（英文名：`filesort`）。
      - 如果某个查询需要使用文件排序的方式执行查询，就会在执行计划的 `Extra` 列中显示 `Using filesort` 提示

    - `Using temporary`

      - 在许多查询的执行过程中，MySQL 可能会借助临时表来完成一些功能，比如去重、排序之类的，比如我们在执行许多包含 `DISTINCT`、`GROUP BY`、`UNION` 等子句的查询过程中，如果不能有效利用索引来完成查询，MySQL 很有可能寻求通过建立内部的临时表来执行查询。
      - 如果查询中使用到了内部的临时表，在执行计划的 `Extra` 列将显示 `Using temporary` 提示

参考文档

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P136 ~ 138

## 锁的种类

- 对数据的操作类型划分
  - 读锁/共享锁
    - S 锁 `SELECT ... LOCK IN SHARE MODE;`
    - X 锁 `SELECT ... FOR UPDATE;`
  - 写锁/排他锁
    - `DELETE`
    - `UPDATE`
- 锁粒度角度划分
  - 表级锁
    - 表级别的 S 锁、X 锁
    - 意向锁
    - 自增锁
    - MDL 锁
  - 行级锁
    - Record Locks
    - Gap Locks
    - Next-Key Locks
    - 插入意向锁
  - 页级锁
- 对待锁的态度划分
  - 悲观锁
  - 乐观锁
- 加锁方式
  - 隐式锁
  - 显式锁
- 其他
  - 全局锁
  - 死锁

参考文档：

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P174

## 表锁

- **1、表级别的 S 锁、X 锁**

  - MyISAM 在执行查询语句（SELECT）前，会给涉及的所有表加读锁，在执行增删改操作前，会给涉及的表加写锁。InnoDB 存储引擎是不会为这个表添加表级别的**读锁**或者**写锁**的。
    - 一般情况下，不会使用 InnoDB 存储引擎提供的表级别的 **S 锁**和 **X 锁**。只会在一些特殊情况下，比方说**崩溃恢复**过程中用到。比如，在系统变量 `autocommit=0, innodb_table_locks = 1` 时，**手动**获取 InnoDB 存储引擎提供的表 t 的 **S 锁**或者 **X 锁**可以这么写：
      - `LOCK TABLES t READ`：InnoDB 存储引擎会对表 `t` 加表级别的 **S 锁**
      - `LOCK TABLES t WRITE`：InnoDB 存储引擎会对表 `t` 加表级别的 **X 锁**
    - 不过尽量避免在使用 InnoDB 存储引擎的表上使用 `LOCK TABLES` 这样的手动锁表语句，它们并不会提供什么额外的保护，只是会降低并发能力而已。InnoDB 的厉害之处还是实现了更细粒度的**行锁**，关于 InnoDB 表级别的 **S 锁**和 **X 锁**大家了解一下就可以了。

- **2、意向锁（Intention lock）**

  - InnoDB 支持**多粒度锁（multiple granularity locking）**, 它允许**行级锁**与**表级锁**共存，而**意向锁**就是其中的一种**表锁**。

    1. 意向锁的存在是为了协调行锁和表锁的关系，支持多粒度（表锁与行锁）的锁并存。
    2. 意向锁是一种**不与行级锁冲突表级锁**，这一点非常重要。
    3. 表明“某个事务正在某些行持有了锁或该事务准备去持有锁”

  - 意向锁分为两种：

    - **意向共享锁**（intention shared lock，IS）：事务有意向对表中的某些行加**共享锁**（S 锁）

      ```mysql
      -- 事务要获取某些行的 S 锁，必须先获得表的 IS 锁。
      SELECT column FROM table ... LOCK IN SHARE MODE;
      ```

    - **意向排他锁**（intention exclusive lock，IX）：事务有意向对表中的某些行加**排他锁**（X 锁）

      ```mysql
      -- 事务要获取某些行的 X 锁，必须先获得表的 IX 锁
      SELECT column FROM table ... FOR UPDATE;
      ```

  - 首先，我们需要知道意向锁之间的兼容互斥性，如下所示。

    |                  | 意向共享锁（IS） | 意向排他锁（IX） |
    | ---------------- | ---------------- | ---------------- |
    | 意向共享锁（IS） | 兼容             | 兼容             |
    | 意向排他锁（IX） | 兼容             | 兼容             |

    即意向锁之间是互相兼容的，虽然意向锁和自家兄弟互相兼容，但是它会与普通的排他/共享锁互斥。

    |              | 意向共享锁（IS） | 意向排他锁（IX） |
    | ------------ | ---------------- | ---------------- |
    | 共享锁（IS） | 兼容             | 互斥             |
    | 排他锁（IX） | 互斥             | 互斥             |

    注意这里的排他/共享锁指的都是表锁，**意向锁不会与行级的共享/排他锁互斥**。

  - 并发性

    - 意向锁不会与行级的共享/排他锁互斥！正因为如此，意向锁并不会影响到多个事务对不同数据行加排他锁的并发性。（不然我们直接用普通的表锁就行了）

- **3、自增锁（AUTO-INC 锁）**

  - 在使用 MySQL 过程中，我们可以为表的某个列添加 `AUTO_INCREMENT` 属性；由于这个表的 id 字段声明了 AUTO_INCREMENT，意味着在书写插入语句时不需要为其赋值

  - 所有插入数据的方式总共分为三类，分别是“`Simple inserts`”，“`Bulk inserts`” 和 “`Mixed-mode inserts`”。

    1. **“Simple inserts”（简单插入）**

       可以**预先确定要插入和行数**（当语句被初始处理时）的语句。包括没有嵌套子查询的单行和多行 `INSERT ... VALUES()` 和 `REPLACE` 语句。比如我们上面举的例子就属于该类插入，已经确定要插入的行数。

    2. **“Bulk inserts”（批量插入）**

       **事先不知道要插入的行数**（和所需自动递增的数量）的语句。比如 `INSERT ... SELECT`, `REPLACE ... SELECT` 和 `LOAD DATA` 语句，但不包括纯 INSERT。InnoDB 在每处理一行，为 AUTO_INCREMENT 列分配一个新值。

    3. **“Mixed-mode inserts”（混合模式插入）**

       这些是“Simple inserts”语句但是指定部分新行的自动递增值。例如 `INSERT INTO teacher (id, name) VALUES (1, 'a'), (NULL, 'b'), (5, 'c'), (NULL, 'd');` 只是指定了部分 id 的值。另一种类型的“混合模式插入”是 `INSERT ... ON DUPLICATE KEY UPDATE`。

  - 对于上面数据插入的案例，MySQL 中采用了**自增锁**的方式来实现，**AUTO-INC 锁是当向使用 AUTO_INCREMENT 列的表中插入数据时需要获取的一种特殊的表级锁**，在执行插入语句时就在表级别加一个 AUTO-INC 锁，然后为每条待插入记录的 AUTO_INCREMENT 修饰的列分配递增的值，在该语句执行结束后，再把 AUTO-INC 锁释放掉。

    - **一个事务在持有 AUTO-INC 锁的过程中，其他事务的插入语句都要被阻塞**，可以保证一个语句中分配的递增值是连续的。

    - 也正因为此，其并发性显然并不高，**当我们向一个有 AUTO_INCREMENT 关键字的主键插入值的时候，每条语句都要对这个表锁进行竞争**，这样的并发潜力其实是很低下的，所以 innodb 通过 `innodb_autoinc_lock_mode` 的不同取值来提供不同的锁定机制，来显著提高 SQL 语句的可伸缩性和性能。

      - **（1）innodb_autoinc_lock_mode = 0（“传统”锁定模式）**

        在此锁定模式下，所有类型的 insert 语句都会获得一个特殊的表级 AUTO-INC 锁，用于插入具有 AUTO_INCREMENT 列的表。

      - **（2）innodb_autoinc_lock_mode = 1（“连续”锁定模式）**

        在 MySQL 8.0 之前，连续锁定模式是**默认**的。

        在这个模式下，“bulk inserts”仍然使用 AUTO-INC 表级锁，并保持到语句结束。

        对于“Simple inserts”（要插入的行数事先已知），则通过在 `mutex（轻量锁）`的控制下获得所需数量的自动递增值来避免表级 AUTO-INC 锁，它只在分配过程的持续时间内保持，而不是直到语句完成。不使用表级 AUTO-INC 锁，除非 AUTO-INC 锁由另一个事务保持。如果另一个事务保持 AUTO-INC 锁，则“Simple inserts”等待 AUTO-INC 锁，如同它是一个“bulk inserts”

      - **（3）innodb_autoinc_lock_mode = 2（“交错”锁定模式）**

        从 MySQL 8.0 开始，交错锁模式是**默认**设置。

        在这种锁定模式下，所有类 INSERT 语句都不会使用表级 AUTO-INC 锁，并且可以同时执行多个语句。这是最快和最可扩展的锁定模式，但是当使用基于语句的复制或恢复方案时，**从二进制日志重播 SQL 语句时，这是不安全的**。

- **4、元数据锁（MDL 锁）**

  - MySQL 5.5 引入了 meta data lock，简称 MDL 锁，属于表锁范畴。
  - MDL 的作用是，保证读写的正确性。
    - 比如，如果一个查询正在遍历一个表中的数据，而执行期间另一个线程对这个**表结构做变更**，增加了一列，那么查询线程拿到的结果跟表结构对不上，肯定是不行的。
  - 因此，**当对一个表做增删改查操作的时候，加 MDL 读锁；当要对表做结构变更操作的时候，加 MDL 写锁。**
  - **不需要显式使用**，在访问一个表的时候会被自动加上。

参考文档：

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P175 ~ 176

## 行锁

- 行锁（Row Lock）也称为记录锁，顾名思义，就是锁住某一行（某条记录 row）。需要的注意的是，MySQL 服务器层并没有实现行锁机制，**行级锁只在存储引擎层实现**。
- InnoDB 与 MyISAM 的最大不同有两点：一是支持事务（TRANSACTION）；二是采用了行级锁。
- 分类
  1. 记录锁（Record Locks）
     - 记录锁也就是仅仅把一条记录锁上，官方的类型名称为：`LOCK_REC_NOT_GAP`。比如我们把 id 值为 8 的那条记录加一个记录锁，仅仅是锁住了 id 值为 8 的记录，对周围的数据没有影响。
     - 记录锁是有 S 锁和 X 锁之分的，称之为 **S 型记录锁**和 **X 型记录锁**
  2. 间隙锁（Gap Locks）
     - `MySQL` 在 `REPEATABLE READ` 隔离级别下是可以解决幻读问题的，解决方案有两种，可以使用 `MVCC` 方案解决，也可以采用**加锁**方案解决。（分别对应**快照读**（一致性读）和**当前读**（锁定读）两种情况下的处理方式）
       - 但是在使用加锁方案解决时有个大问题，就是事务在第一次执行读取操作时，那些幻影记录尚不存在，我们无法给这些**幻影记录**加上**记录锁**。
       - InnoDB 提出了一种称之为 **Gap Locks** 的锁，官方的类型名称为：`LOCK_GAP`，我们可以简称为 **gap 锁**。
     - **gap 锁的提出仅仅是为了防止插入幻影记录而提出的。**虽然有**共享 gap 锁**和**独占 gap 锁**这样的说法，但是它们起到的作用是相同的。而且如果对一条记录加了 gap 锁（不论是共享 gap 锁还是独占 gap 锁），并不是限制其他事务对这条记录加记录锁或者继续加 gap 锁。
  3. 临键锁（Next-Key Locks）
     - 有时候我们既想**锁住某条记录**，又想**阻止**其他事务在该记录前边的**间隙插入新纪录**，所以 InnoDB 就提出了一种称之为 `Next-Key Locks` 的锁，官方的类型名称为：`LOCK_ORDINARY`，我们也可以简称为 **next-key 锁**。
     - Next-Key Locks 是在存储引擎 `innodb`、事务级别在**可重复读**的情况下使用的数据库锁，innodb 默认的锁就是 Next-Key locks。
     - **next-key 锁**的本质就是一个**记录锁**和一个 **gap 锁**的合体，它既能保护该条记录，又能阻止别的事务将新的记录插入被保护记录前边的**间隙**。
  4. 插入意向锁（Insert Intention Locks）
     - 我们说一个事务在**插入**一条记录时需要判断一下插入位置是不是被别的事务加了 **gap 锁**（**next-key 锁**也包含 **gap 锁**），如果有的话，插入操作需要等待，直到拥有 **gap 锁**的那个事务提交。
     - 但是 **InnoDB 规定事务在等待的时候也需要在内存中生成一个锁结构**，表明有事务想在某个**间隙**中**插入**新纪录，但是现在在等待。
     - InnoDB 就把这种类型的锁命名为 `Insert Intention Locks`，官方的类型名称为：`LOCK_INSERT_INTENTION`，我们称为**插入意向锁**。
     - 插入意向锁是一种 **Gap 锁**，不是意向锁，在 insert 操作时产生。
     - 总结来说，插入意向锁的特性可以分成两部分：

       1. 插入意向锁是一种**特殊的间隙锁**——间隙锁可以锁定开区间内的部分记录。
       2. 插入意向锁之间**互不排斥**，所以即使多个事务在同一区间插入多条记录，只要记录本身（主键、唯一索引）不冲突，那么事务之间就不会出现冲突等待。
     - 注意，虽然插入意向锁中含有意向锁三个字，但是它并不属于意向锁而属于间隙锁，因为意向锁是表锁而插入意向锁是**行锁**。

参考文档：

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P177 ~ 178

## 页锁

- 页锁就是在**页的粒度**上进行锁定，锁定的数据资源比行锁要多，因为一个页中可以有多个行记录。
  - 当我们使用页锁的时候，会出现数据浪费的现象，但这样的浪费最多也就是一个页上的数据行。
- **页锁的开销介于表锁和行锁之间，会出现死锁。锁定粒度介于表锁和行锁之间，并发度一般。**
- 每个层级的锁数量是有限制的，因为锁会占用内存空间，**锁空间的大小是有限的**。当某个层级的锁数量超过了这个层级的阈值时，就会进行**锁升级**。
  - 锁升级就是用更大粒度的锁替代多个更小粒度的锁，比如 InnoDB 中行锁升级为表锁，这样做的好处是占用的锁空间降低了，但同时数据的并发度也下降了。
- 目前只有 **BDB 引擎**支持页面锁，应用场景较少。
  - （也就是 InnoDB 没有页锁）

参考文档：

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P179

## 隐式锁

- 一个事务在执行 `INSERT` 操作时，如果即将插入的**间隙**已经被其他事务加了 **gap 锁**，那么本次 `INSERT` 操作会阻塞，并且当前事务会在该间隙上加一个**插入意向锁**，否则一般情况下 `INSERT` 操作是不加锁的。

- 那如果一个事务首先插入了一条记录（此时并没有在内存生产与该记录关联的锁结构），然后另一个事务：

  - 立即使用 `SELECT ... LOCK IN SHARE MODE` 语句读取这条记录，也就是要获取这条记录的 **S 锁**，或者使用 `SELECT ... FOR UPDATE` 语句读取这条记录，也就是要获取这条记录的 **X 锁**，怎么办？

    如果允许这种情况的发生，那么可能产生**脏读**问题。

  - 立即修改这条记录，也就是要获取这条记录的 **X 锁**，怎么办？

  - 如果允许这种情况的发生，那么可能产生**脏写**问题。

- 这时候我们前边提到过的**事务 id** 又要起作用了。我们把聚簇索引和二级索引中的记录分开看一下：

  - **情景一**：对于聚簇索引记录来说，有一个 `trx_id` 隐藏列，该隐藏列记录着最后改动该记录的**事务 id**。那么如果在当前事务中新插入一条聚簇索引记录后，该记录的 `trx_id` 隐藏列代表的就是当前事务的**事务 id**，如果其他事务此时想对该记录添加 **S 锁**或者 **X 锁**时，首先会看一下该记录的 `trx_id` 隐藏列代表的事务是否是当前的活跃事务，如果是的话，那么就帮助当前事务创建一个 **X 锁**（也就是为当前事务创建一个锁结构，`is_waiting` 属性是 `false`），然后自己进入等待状态（也就是为自己也创建一个锁结构，`is_waiting` 属性是 `true`）。
  - **情景二**：对于二级索引记录来说，本身并没有 `trx_id` 隐藏列，但是在二级索引页面的 `Page Header` 部分有一个 `PAGE_MAX_TRX_ID` 属性，该属性代表对该页面做改动的最大的**事务 id**，如果 `PAGE_MAX_TRX_ID` 属性值小于当前最小的活跃**事务 id**，那么说明对该页面做修改的事务都已经提交了，否则就需要在页面中定位到对应的二级索引记录，然后回表找到它对应的聚簇索引记录，然后再重复**情景一**的做法。
  - 即 ：一个事务对新插入的记录可以不显式的加锁（生成一个锁结构），但是由于**事务 id**的存在，相当于加了一个**隐式锁**。别的事务在对这条记录加 **S 锁**或者 **X 锁**时，由于**隐式锁**的存在，会先帮助当前事务生成一个锁结构，然后自己再生成一个锁结构后进入等待状态。隐式锁是一种**延迟加锁**的机制，从而来减少加锁的数量。
  - 隐式锁在实际内存对象中并不含有这个锁信息，只有当产生锁等待时，隐式锁转化为显式锁。

- 隐式锁的逻辑过程如下：

  1. InnoDB 的每条记录中都一个隐含的 trx_id 字段，这个字段存在于聚簇索引的 B+Tree 中。
  2. 在操作一条记录前，首先根据记录中的 trx_id 检查该事务是否是活动的事务（未提交或回滚）。如果是活动的事务，首先将**隐式锁**转换为**显式锁**（就是为该事务添加一个锁）。
  3. 检查是否有锁冲突，如果有冲突，创建锁，并设置为 waiting 状态。如果没有冲突不加锁，跳到 5.
  4. 等待加锁成功，被唤醒，或者超时
  5. 写数据，并将自己的 trx_id 写入 trx_id 字段。

参考文档：

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P180

## 全局锁

全局锁就是对**整个数据库实例**加锁。当你需要让整个库处于**只读状态**的时候，可以使用这个命令，之后其他线程的以下语句会被阻塞：数据更新语句（数据的增删改）、数据定义语句（包括建表、修改表结构等）和更新类事务的提交语句。全局锁的典型使用**场景**是：做**全库逻辑备份**。

全局锁的命令：

```mysql
Flush tables with read lock
```

参考文档：

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P181

## 防范 SQL 注入

1. JDBC 的 PreparedStatement

   - 采用预编译语句集，它内置了处理SQL注入的能力

2. 使用 MyBatis 的 #

   - \# 将传入的数据都当成一个字符串，会对自动传入的数据加一个双引号。

   - $ **将传入的数据直接显示生成在sql中。**

   - MyBatis是如何做到SQL预编译的呢？

     其实在框架底层，是JDBC中的PreparedStatement类在起作用，PreparedStatement是我们很熟悉的Statement的子类，它的对象包含了编译好的SQL语句。

     - 简单说，#{}是经过预编译的，是安全的；
     - ${}是未经过预编译的，仅仅是取变量的值，是非安全的，存在SQL注入。



# Redis

## 数据结构

1. redis 字符串（String）
   - String（字符串）
   - string 是 redis 最基本的类型，一个 key 对应一个 value。
   - string 类型是**二进制安全的**，意思是 redis 的 string 可以包含任何数据，比如 jpg 图片或者序列化的对象。
   - string 类型是 Redis 最基本的数据类型，一个 redis 中字符串 value 最多可以是 512M
2. redis 列表（List）
   - Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的**头部（左边）或者尾部（右边）**
   - 它的底层实际是个**双端链表**，最多可以包含 2^32 - 1 个元素（4294967295，每个列表超过 40 亿个元素）
3. redis 哈希表（Hash）
   - Redis hash 是一个 string 类型的 field（字段）和 value（值）的映射表，hash 特别适合用于存储对象。
   - Redis 中每个 hash 可以存储 2^32 - 1 键值对（40 多亿）
4. redis 集合（Set）
   - Redis 的 Set 是 String 类型的**无序集合**。集合成员是唯一的，这就意味着集合中不能出现重复的数据，集合对象的编码可以是 intset 或者 hashtable。
   - Redis 中 Set 集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。
   - 集合中最大的成员数为 2^32 - 1（4294967295，每个集合可存储 40 多亿个成员）
5. redis 有序集合（ZSet）
   - zset（sorted set，有序集合）
   - Redis zset 和 set 一样也是 string 类型元素的集合，且不允许重复的成员。
   - **不同的是每个元素都会关联一个 double 类型的分数，**redis 正是通过分数来为集合中的成员进行从小到大的排序。
   - **zset 的成员是唯一的，但分数（score）却可以重复。**
   - **zset 集合是通过哈希表实现的，所以添加、删除，查找的复杂度都是 O(1)。集合中最大的成员数为 2^32 - 1**
6. redis 地理空间（GEO）
   - Redis GEO 主要用于存储地理位置信息，并对存储的信息进行操作，包括：
     - 添加地理位置的坐标
     - 获取地理位置的坐标
     - 计算两个位置之间的距离
     - 根据用户给定的经纬度坐标来获取指定范围内的地理位置集合
7. redis 基数统计（HypeLogLog）
   - HyperLogLog 是用来做**基数统计**的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定且是很小的。
   - 在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。
   - 但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。
8. redis 位图（bitmap）
   - Bit arrays (or simply bitmaps，我们可以称之为 位图)
   - 一个字节（一个 byte）= 8 位
   - 上图由许许多多的小格子组成，每一个格子里面只能放 1 或者 0，用它来判断 Y/N 状态。说的专业点，每一个个小格子就是一个个 bit
   - 由 0 和 1 状态表现的二进制位的 bit 数组
9. redis 位域（bitfield）
   - 通过 bitfield 命令可以一次性操作多个**比特位域（指的是连续的多个比特位）**，它会执行一系列操作并返回一个响应数组，这个数组中的元素对应参数列表中的相应操作的执行结果。
   - 说白了就是通过 bitfield 命令我们可以一次性对多个比特位域进行操作。
10. redis 流（Stream）
    - Redis Stream 是 Redis 5.0 版本新增加的数据结构。
    - Redis Stream 主要用于消息队列（MQ，Message Queue），Redis 本身是有一个 Redis 发布订阅（pub/sub）来实现消息队列的功能，但它有个缺点就是消息无法持久化，如果出现网络断开、Redis 宕机等，消息就会被丢弃。
    - 简单来说发布订阅（pub/sub）可以分发消息，但无法记录历史消息。
    - 而 Redis Stream 提供了消息的持久化和主备复制功能，可以让任何客户端访问任何时刻的数据，并且能记住每一个客户端的访问位置，还能保证消息不丢失

参考文档：

1. [《尚硅谷Redis零基础到进阶》笔记.md](../视频笔记/《尚硅谷Redis零基础到进阶》笔记.md) P11

## 底层数据结构

- redis 6 类型-物理编码-对应表

  - （1：04）

    | 类型         | 编码                      | 对象                                             |
    | ------------ | ------------------------- | ------------------------------------------------ |
    | REDIS_STRING | REDIS_ENCODING_INT        | 使用整数值实现的字符串对象                       |
    | REDIS_STRING | REDIS_ENCODING_EMBSTR     | 使用 embstr 编码的简单动态字符串实现的字符串对象 |
    | REDIS_STRING | REDIS_ENCODING_RAW        | 使用简单动态字符串实现的字符串对象               |
    | REDIS_LIST   | REDIS_ENCODING_ZIPLIST    | 使用压缩列表实现的列表对象                       |
    | REDIS_LIST   | REDIS_ENCODING_LINKEDLIST | 使用双端链表实现的列表对象                       |
    | REDIS_HASH   | REDIS_ENCODING_ZIPLIST    | 使用压缩列表实现的哈希对象                       |
    | REDIS_HASH   | REDIS_ENCODING_HT         | 使用字典实现的哈希对象                           |
    | REDIS_SET    | REDIS_ENCODING_INTSET     | 使用整数集合实现的集合对象                       |
    | REDIS_SET    | REDIS_ENCODING_HT         | 使用字典实现的集合对象                           |
    | REDIS_ZSET   | REDIS_ENCODING_ZIPLIST    | 使用压缩列表实现的有序集合对象                   |
    | REDIS_ZSET   | REDIS_ENCODING_SKIPLIST   | 使用跳跃表和字典实现的有序集合对象               |

- redis 6 数据类型对应的底层数据结构

  - （1：57）

    1. 字符串

       **int**：8 个字节的长整型

       **embstr**：小于等于 44 个字节的字符串

       **raw**：大于 44 个字节的字符串

       - embstr 与 raw 类型底层的数据结构其实都是 SDS（简单动态字符串，Redis 内部定义 sdshdr 一种结构）。

    2. 哈希

       **ziplist**（压缩列表）：当哈希类型元素小于 hash-max-ziplist-entries 配置（默认 512 个）、同时所有值都小于 hash-max-ziplist-value 配置（默认 64 字节）时，Redis 会使用 ziplist 作为哈希的内部实现，ziplist 使用更加紧凑的结构实现多个元素的连续存储。所以在节省内存方面比 hashtable 更加优秀

       **hashtable**（哈希表）：当哈希类型无法满足 ziplist 的条件时，Redis 会使用 hashtable 作为哈希的内部实现，因为此时 ziplist 的读写效率会下降，而 hashtable 的读写时间复杂度为 O(1)

    3. 列表

       **ziplist**（压缩列表）：当列表的元素个数小于 list-max-ziplist-entries 配置（默认 512 个），同时列表中每个元素的值都小于 list-max-ziplist-value 配置时（默认 64 字节），Redis 会选用 ziplist 来作为列表的内部实现来减少内存的使用。

       **linkedlist**（链表）：当列表类型无法满足 ziplist 的条件时，Redis 会使用 linkedlist 作为列表的内部实现。

       3.2 版本之后只有使用：**quicklist**：ziplist 和 linkedlist 的结合以 ziplist 为节点的链表

    4. 集合

       **intset**（整数集合）：当集合中的元素都是整数且元素个数小于 set-max-intset-entries 配置（默认 512 个）时，Redis 会用 intset 来作为集合的内部实现，从而减少内存的使用。

       **hashtable**（哈希表）：当集合类型无法满足 intset 的条件时，Redis 会使用 hashtable 作为集合的内部实现

    5. 有序集合

       **ziplist**（压缩列表）：当有序集合的元素个数小于 zset-max-ziplist-entries 配置（默认 128 个），同时每个元素的值都小于 zset-max-ziplist-value 配置（默认 64 字节）时，Redis 会用 ziplist 来作为有序集合的内部实现，ziplist 可以有效减少内存的使用

       **skiplist**（跳跃表）：当 ziplist 条件不满足时，有序集合会使用 skiplist 作为内部实现，因为此时 ziplist 的读写效率会下降

- redis 6 数据类型以及数据结构的关系（2：35）

- redis 7 数据类型以及数据结构的关系（2：52）

  - ziplist -> listpack（所有地方，包括 quicklist 内）

  - listpack 避免了 ziplist 的连锁更新的问题

- redis 数据类型以及数据结构的时间复杂度（3：24）

参考文档：

1. [《尚硅谷Redis零基础到进阶》笔记.md](../视频笔记/《尚硅谷Redis零基础到进阶》笔记.md) P163

## 布隆过滤器

- 原理

  - BloomFilter 的算法是，首先分配一块内存空间做 bit 数组，数组的 bit 位初始值全部设为 0。
  - 加入元素时，采用 k 个相互独立的 Hash 函数计算，然后将元素 Hash 映射的 K 个位置全部设置为 1。
  - 检测 key 是否存在，仍然用这 k 个 Hash 函数计算出 k 个位置，如果位置全部为 1，则表明 key 存在，否则不存在。

- Redis 实现

  - bitmaps

    - 基本命令

      - | 命令                        | 作用                                                  | 时间复杂度 |
        | --------------------------- | ----------------------------------------------------- | ---------- |
        | setbit key offset val       | 给指定 key 的值的第 offset 赋值 val                   | O(1)       |
        | getbit key offset           | 获取指定 key 的第 offset 位                           | O(1)       |
        | bitcount key start end      | 返回指定 key 中 [start, end] 中为 1 的数量            | O(n)       |
        | bitop operation destkey key | 对不同的二进制存储数据进行位运算（AND、OR、NOT、XOR） | O(n)       |

  - Redisson

    - Redis 实现布隆过滤器的底层就是通过 bitmap 这种数据结构，至于如何实现，这里就不重复造轮子了，介绍业界比较好用的一个客户端工具——Redisson。

    - ```java
      package com.ys.rediscluster.bloomfilter.redisson;
      
      import org.redisson.Redisson;
      import org.redisson.api.RBloomFilter;
      import org.redisson.api.RedissonClient;
      import org.redisson.config.Config;
      
      public class RedissonBloomFilter {
      
          public static void main(String[] args) {
              Config config = new Config();
              config.useSingleServer().setAddress("redis://192.168.14.104:6379");
              config.useSingleServer().setPassword("123");
              //构造Redisson
              RedissonClient redisson = Redisson.create(config);
      
              RBloomFilter<String> bloomFilter = redisson.getBloomFilter("phoneList");
              //初始化布隆过滤器：预计元素为100000000L,误差率为3%
              bloomFilter.tryInit(100000000L,0.03);
              //将号码10086插入到布隆过滤器中
              bloomFilter.add("10086");
      
              //判断下面号码是否在布隆过滤器中
              System.out.println(bloomFilter.contains("123456"));//false
              System.out.println(bloomFilter.contains("10086"));//true
          }
      }
      ```

    - 这是单节点的Redis实现方式，如果数据量比较大，期望的误差率又很低，那单节点所提供的内存是无法满足的，这时候可以使用分布式布隆过滤器，同样也可以用 Redisson 来实现

- 非 Redis 实现

  - Guava

    - ```java
      package com.ys.rediscluster.bloomfilter;
      
      import com.google.common.base.Charsets;
      import com.google.common.hash.BloomFilter;
      import com.google.common.hash.Funnel;
      import com.google.common.hash.Funnels;
      
      public class GuavaBloomFilter {
          public static void main(String[] args) {
              BloomFilter<String> bloomFilter = BloomFilter.create(Funnels.stringFunnel(Charsets.UTF_8),100000,0.01);
      
              bloomFilter.put("10086");
      
              System.out.println(bloomFilter.mightContain("123456"));
              System.out.println(bloomFilter.mightContain("10086"));
          }
      }
      ```

参考文档：

1. [Redis详解（十三）------ Redis布隆过滤器 -  博客园](https://www.cnblogs.com/ysocean/p/12594982.html)

## 单线程 / 多线程

- Redis 3.x 单线程时代但性能依旧很快的主要原因

  - 基于内存操作：Redis 的所有数据都存在内存中，因此所有的运算都是内存级别的，所以他的性能比较高；
  - 数据结构简单：Redis 的数据结构是专门设计的，而这些简单的数据结构的查找和操作的时间大部分复杂度都是 O(1)，因此性能比较高；
  - 多路复用和非阻塞 I/O：Redis 使用 I/O 多路复用功能来监听多个 socket 连接客户端，这样就可以使用一个线程连接来处理多个请求，减少线程切换带来的开销，同时也避免了 I/O 阻塞操作
  - 避免上下文切换：因为是单线程模型，因此就避免了不必要的上下文切换和多线程竞争，这就省去了多线程切换带来的时间和性能上的消耗，而且单线程不会导致死锁问题的发生

- **Redis 4.0 之前**一直采用单线程的主要原因有以下三个

  1. 使用单线程模型是 Redis 的开发和维护更简单，因为单线程模型方便开发和调试
  2. 即使使用单线程模型也并发的处理多客户端的请求，主要使用的是 IO 多路复用和非阻塞 IO
  3. 对于 Redis 系统来说，**主要的性能瓶颈是内存或者网络带宽而并非 CPU**.

- Redis 是基于内存操作的，**因此他的瓶颈可能是机器的内存或者网络带宽而并非 CPU**，既然 CPU 不是瓶颈，那么自然就采用单线程的解决方案了，况且使用多线程比较麻烦。**但是在 Redis 4.0 中开始支持多线程了，例如后台删除、备份等功能**。

  - RDB bgsave
  - AOF 重写
  - 惰性删除
    - 大 key 问题
    - 在 Redis 4.0 就引入了多个线程来实现数据的异步惰性删除等功能，但是其处理读写请求的仍然只有一个线程，所以仍然算是狭义上的单线程。

- **在 Redis 6/7 中，非常受关注的第一个新特性就是多线程**。

  - 随着网络硬件的性能提升，Redis 的性能瓶颈有时会出现在网络 IO 的处理上，也就是说，单个主线程处理网络请求的速度跟不上底层网络硬件的速度

  - 为了应对这个问题：**采用多个 IO 线程来处理网络请求，提高网络请求处理的并行度，Redis 6/7 就是采用的这种方法**。

  - 但是，Redis 的多 IO 线程只是用来处理网络请求的，**对于读写操作命令 Redis 仍然使用单线程来处理**

    - 这是因为，Redis 处理请求时，网络处理经常是瓶颈，通过多个 IO 线程并行处理网络操作，可以提升实例的整体处理性能。而继续使用单线程执行命令操作，就不用为了保证 Lua 脚本、事务的原子性，额外开发多线程**互斥加锁机制了（不管加锁操作处理）**，这样一来，Redis 线程模型实现就简单了。

  - 主线程和 IO 线程四个阶段

    - **阶段一：服务端和客户端建立 Socket 连接，并分配处理线程**

      首先，主线程负责接收建立连接请求。当有客户端请求和实例建立 Socket 连接时，主线程会创建和客户端的连接，并把 Socket 放入全局等待队列中。紧接着，主线程通过轮询方法把 Socket 连接分配给 IO 线程。

    - **阶段二：IO 线程读取并解析请求**

      主线程一旦把 Socket 分配给 IO 线程，就会进入阻塞状态，等待 IO 线程完成客户端请求读取和解析。因为有多个 IO 线程在并行处理。所以，这个过程很快就可以完成。

    - **阶段三：主线程执行请求操作**

      等到 IO 线程解析完请求，主线程还是会以单线程的方式执行这些命令操作。

    - **阶段四：IO 线程回写 Socket 和主线程清空全局队列**

      当主线程执行完请求操作后，会把需要返回的结果写入缓冲区，然后，主线程会阻塞等待 IO 线程，把这些结果回写到 Socket 中，并返回给客户端。和 IO 线程读取和解析请求一样，IO 线程回写 Socket 时，也是有多个线程在并发执行，所以回写 Socket 的速度也很快。等到 IO 线程回写 Socket 完毕，主线程会清空全局队列，等待客户端和后续请求。

- Redis 采用 **Reactor 模式**的网络模型，对于一个客户端请求，主线程负责一个完整的处理过程：

  读取 socket -> 解析请求 -> 执行操作 -> 写入 socket

参考文档：

1. [《尚硅谷Redis零基础到进阶》笔记.md](../视频笔记/《尚硅谷Redis零基础到进阶》笔记.md) P101 ~ 102

## 持久化（RDB、AOF）

- RDB（Redis DataBase）

  - 自动触发

    - Redis 6.0.16 以下在 Redis.conf 配置文件中的 SNAPSHOTTING 下配置 save 参数，来触发 Redis 的 RDB 持久化条件，比如 “save m n”：表示 m 秒内数据集存在 n 次修改时，自动触发 bgsave

      - save 900 1：每隔 900s（15min），如果有超过 1 个 key 发生了变化，就写一份新的 RDB 文件

        save 300 10：每隔 300s（5min），如果有超过 10 个 key 发生了变化，就写一份新的 RDB 文件

        save 60 10000：每隔 60s（1min），如果有超过 10000 个 key 发生了变化，就写一份新的 RDB 文件

    - Redis 7 版本，按照 redis.conf 里配置的 `save <seconds> <changes>`

  - 手动触发

    - save（阻塞） 和 bgsave（默认，fork 子线程来持久化）

  - 如何恢复

    - 将备份文件（dump.rdb）移动到 redis 安装目录并启动服务即可

  - 如何检查修复 dump.rdb 文件

    - `redis-check-rdb /myredis/dumpfiles/dump6379.rdb`

- AOF（Append Only File）

  - 三种写回策略

    - | 配置项   | 写回时机           | 优点                     | 缺点                             |
      | -------- | ------------------ | ------------------------ | -------------------------------- |
      | Always   | 同步写回           | 可靠性高，数据基本不丢失 | 每个写命令都要落盘，性能影响较大 |
      | Everysec | 每秒写回           | 性能适中                 | 宕机时丢失 1 秒内的数据          |
      | No       | 操作系统控制的写回 | 性能好                   | 宕机时丢失数据较多               |

  - 重写机制

    - AOF 文件重写并不是对原文件进行重新整理，而是直接读取服务器现有的键值对，然后用一条命令去代替之前记录这个键值对的多条命令，生成一个新的文件后去替换原来的 AOF 文件

    - 自动触发

      - auto-aof-rewrite-percentage 100

        auto-aof-rewrite-min-size 64mb

        注意，**同时满足，且的关系**才会触发

    - 手动触发

      - 客户端向服务器发送 bgrewriteaof 命令

  - 异常修复命令：`redis-check-aof --fix` 进行修复

- RDB-AOF 混合持久化

  - 设置 `aof-use-rdb-preamble` 的值为 yes
  - RDB 镜像做全量持久化，AOF 做增量持久化

- 同时关闭 RDB + AOF

  - `save ""`
    - 禁用 rdb
    - 禁用 rdb 持久化模式下，我们仍然可以使用命令 save、bgsave 生成 rdb 文件
  - `appendonly no`
    - 禁用 aof
    - 禁用 aof 持久化模式下，我们仍然可以使用命令 bgrewriteaof 生成 aof 文件

参考文档：

1. [《尚硅谷Redis零基础到进阶》笔记.md](../视频笔记/《尚硅谷Redis零基础到进阶》笔记.md) P28 ~ 46

## 分布式锁（SETNX、Lua、Redisson、RedLock）

一把靠谱的分布式锁应该有哪些特征：

- **「互斥性」**: 任意时刻，只有一个客户端能持有锁。
- **「锁超时释放」**：持有锁超时，可以释放，防止不必要的资源浪费，也可以防止死锁。
- **「可重入性」**:一个线程如果获取了锁之后,可以再次对其请求加锁。
- **「高性能和高可用」**：加锁和解锁需要开销尽可能低，同时也要保证高可用，避免分布式锁失效。
- **「安全性」**：锁只能被持有的客户端删除，不能被其他客户端删除

方案：

- 方案一：SETNX + EXPIRE
  - 缺点
    - 但是这个方案中，`setnx`和`expire`两个命令分开了，**「不是原子操作」**。如果执行完`setnx`加锁，正要执行`expire`设置过期时间时，进程crash或者要重启维护了，那么这个锁就“长生不老”了，**「别的线程永远获取不到锁啦」**。
- 方案二：SETNX + value值是（系统时间+过期时间）
  - 缺点
    - 过期时间是客户端自己生成的（System.currentTimeMillis()是当前系统的时间），必须要求分布式环境下，每个客户端的时间必须同步。
    - 如果锁过期的时候，并发多个客户端同时请求过来，都执行 jedis.getSet()，最终只能有一个客户端加锁成功，但是该客户端锁的过期时间，可能被别的客户端覆盖
    - 该锁没有保存持有者的唯一标识，可能被别的客户端释放/解锁。
- 方案三：使用Lua脚本(包含SETNX + EXPIRE两条指令)
- 方案四：SET的扩展命令（SET EX PX NX）
  - 缺点
    - 问题一：**「锁过期释放了，业务还没执行完」**。假设线程a获取锁成功，一直在执行临界区的代码。但是100s过去后，它还没执行完。但是，这时候锁已经过期了，此时线程b又请求过来。显然线程b就可以获得锁成功，也开始执行临界区的代码。那么问题就来了，临界区的业务代码都不是严格串行执行的啦。
    - 问题二：**「锁被别的线程误删」**。假设线程a执行完后，去释放锁。但是它不知道当前的锁可能是线程b持有的（线程a去释放锁时，有可能过期时间已经到了，此时线程b进来占有了锁）。那线程a就把线程b的锁释放掉了，但是线程b临界区业务代码可能都还没执行完呢。
- 方案五：SET EX PX NX  + 校验唯一随机值,再释放锁
  - 缺点：
    - 方案五还是可能存在**「锁过期释放，业务没执行完」**的问题。
- 方案六: 开源框架~Redisson
  - 只要线程一加锁成功，就会启动一个`watch dog`看门狗，它是一个后台线程，会每隔10秒检查一下，如果线程1还持有锁，那么就会不断的延长锁key的生存时间。
  - 使用Redisson解决了**「锁过期释放，业务没执行完」**问题。
- 方案七：多机实现的分布式锁Redlock
  - 搞多个Redis master部署，以保证它们不会同时宕掉。并且这些master节点是完全相互独立的，相互之间不存在数据同步。同时，需要确保在这多个master实例上，是与在Redis单实例，使用相同方法来获取和释放锁。

参考文档：

1. [Redis实现分布式锁的7种方案，及正确使用姿势！ - 博客园](https://www.cnblogs.com/wangyingshuo/p/14510524.html)

## 部署方式（单机、主从复制、哨兵、集群）

- 单机模式
  - 优点
    - 架构简单，部署方便；
    - 高性价比：缓存使用时无需备用节点（单实例可用性可以用supervisor或crontab保证），当然为了满足业务的高可用性，也可以牺牲一个备用节点，但同时刻只有一个实例对外提供服务；
    - 高性能。
  - 缺点
    - 不保证数据的可靠性；
    - 在缓存使用，进程重启后，数据丢失，即使有备用的节点解决高可用性，但是仍然不能解决缓存预热问题，因此不适用于数据可靠性要求高的业务；
    - 高性能受限于单核CPU的处理能力（Redis是单线程机制），CPU为主要瓶颈，所以适合操作命令简单，排序、计算较少的场景。也可以考虑用Memcached替代。
- 主从模式（复制）
  - 优点
    - 高可靠性：一方面，采用双机主备架构，能够在主库出现故障时自动进行主备切换，从库提升为主库提供服务，保证服务平稳运行；另一方面，开启数据持久化功能和配置合理的备份策略，能有效的解决数据误操作和数据异常丢失的问题；
    - 读写分离策略：从节点可以扩展主库节点的读能力，有效应对大并发量的读操作。
  - 缺点
    - 故障恢复复杂，如果没有RedisHA系统（需要开发），当主库节点出现故障时，需要手动将一个从节点晋升为主节点，同时需要通知业务方变更配置，并且需要让其它从库节点去复制新主库节点，整个过程需要人为干预，比较繁琐；
    - 主库的写能力受到单机的限制，可以考虑分片；
    - 主库的存储能力受到单机的限制，可以考虑Pika；
    - 原生复制的弊端在早期的版本中也会比较突出，如：Redis复制中断后，Slave会发起psync，此时如果同步不成功，则会进行全量同步，主库执行全量备份的同时可能会造成毫秒或秒级的卡顿；又由于COW机制，导致极端情况下的主库内存溢出，程序异常退出或宕机；主库节点生成备份文件导致服务器磁盘IO和CPU（压缩）资源消耗；发送数GB大小的备份文件导致服务器出口带宽暴增，阻塞请求，建议升级到最新版本。
- 哨兵模式
  - 优点
    - Redis Sentinel集群部署简单；
    - 能够解决Redis主从模式下的高可用切换问题；
    - 很方便实现Redis数据节点的线形扩展，轻松突破Redis自身单线程瓶颈，可极大满足Redis大容量或高性能的业务需求；
    - 可以实现一套Sentinel监控一组Redis数据节点或多组数据节点。
  - 缺点
    - 部署相对Redis主从模式要复杂一些，原理理解更繁琐；
    - 资源浪费，Redis数据节点中slave节点作为备份节点不提供服务；
    - Redis Sentinel主要是针对Redis数据节点中的主节点的高可用切换，对Redis的数据节点做失败判定分为主观下线和客观下线两种，对于Redis的从节点有对节点做主观下线操作，并不执行故障转移。
    - 不能解决读写分离问题，实现起来相对复杂。
- 集群模式
  - 优点：
    - 无中心架构；
    - 数据按照slot存储分布在多个节点，节点间数据共享，可动态调整数据分布；
    - 可扩展性：可线性扩展到1000多个节点，节点可动态添加或删除；
    - 高可用性：部分节点不可用时，集群仍可用。通过增加Slave做standby数据副本，能够实现故障自动 failover，节点之间通过gossip协议交换状态信息，用投票机制完成Slave到Master的角色提升；
    - 降低运维成本，提高系统的扩展性和可用性。
  - 缺点：
    - Client实现复杂，驱动要求实现Smart Client，缓存slots mapping信息并及时更新，提高了开发难度，客户端的不成熟影响业务的稳定性。目前仅JedisCluster相对成熟，异常处理部分还不完善，比如常见的“max redirect exception”。
    - 节点会因为某些原因发生阻塞（阻塞时间大于clutser-node-timeout），被判断下线，这种failover是没有必要的。
    - 数据通过异步复制，不保证数据的强一致性。
    - 多个业务使用同一套集群时，无法根据统计区分冷热数据，资源隔离性较差，容易出现相互影响的情况。
    - Slave在集群中充当“冷备”，不能缓解读压力，当然可以通过SDK的合理设计来提高Slave资源的利用率。
    - Key批量操作限制，如使用mset、mget目前只支持具有相同slot值的Key执行批量操作。对于映射为不同slot值的Key由于Keys不支持跨slot查询，所以执行mset、mget、sunion等操作支持不友好。
    - Key事务操作支持有限，只支持多key在同一节点上的事务操作，当多个Key分布于不同的节点上时无法使用事务功能。
    - Key作为数据分区的最小粒度，不能将一个很大的键值对象如hash、list等映射到不同的节点。
      不支持多数据库空间，单机下的redis可以支持到16个数据库，集群模式下只能使用1个数据库空间，即db 0。
    - 复制结构只支持一层，从节点只能复制主节点，不支持嵌套树状复制结构。
    - 避免产生hot-key，导致主库节点成为系统的短板。
    - 避免产生big-key，导致网卡撑爆、慢查询等。
    - 重试时间应该大于cluster-node-time时间。
    - Redis Cluster不建议使用pipeline和multi-keys操作，减少max redirect产生的场景。

参考文档：

1. [Redis的几种部署方式及持久化策略 - CSDN](https://blog.csdn.net/zwdwinter/article/details/88636397)

## 脑裂问题

- 哨兵+主从

- 原主服务器接受到客户端的信息后，还未同步到从服务器上就是去连接了，但是重启后又由主变为了从服务器，无法同步数据了，所以这部分数据就丢失了，这就是脑裂问题

- 解决办法

  - 在配置文件中添加如下配置

    ```
    min-slaves-to-write 1
    min-slaves-max-lag 10
    ```

  - 这种方法**不可能百分百避免数据丢失**

参考文档

1. [Redis常见问题——脑裂问题 - CSDN](https://blog.csdn.net/cxy_t/article/details/110825175)

## 分布式一致性协议（Raft、Gossip）

- Raft
  - Raft是一种为分布式系统设计的共识算法，用于管理复制日志的一致性。
  - 在Redis的Sentinel模式下，Raft协议被用于选举一个Leader Sentinel来执行自动故障转移操作。
  - 在Raft协议中，节点有三种状态
    - Leader（领导）
    - Follower（跟随者）
    - Candidate（候选人）。
  - 系统的时间被划分为一个个的Term（任期），每个Term开始时，所有节点都成为Follower。
  - 如果一个Follower在一段时间内没有收到来自Leader的心跳信息，它将转变为Candidate状态并发起选举。其他节点收到选举请求后，将比较自己的Term和请求中的Term，如果请求中的Term更大，则认可该Candidate为Leader。
- Gossip
  - 在Redis Cluster模式下，Gossip协议被用于实现无中心式的节点通信。
  - Gossip协议是一种最终一致性算法，它不要求节点知道所有其他节点的状态，因此具有去中心化的特点。
    - 节点之间通过交换信息来维护系统状态的一致性，虽然无法保证在某个时刻所有节点状态一致，但可以保证在“最终”所有节点一致。
  - 在实际应用中，Redis Cluster通过Gossip协议实现了节点间的动态信息交换，包括节点状态、槽位信息等。
    - 这种去中心化的通信方式使得Redis Cluster具有很高的可扩展性和容错性。
    - 当一个节点出现故障时，其他节点可以通过Gossip协议感知到这一变化，并自动调整集群状态，保证服务的可用性。
- 这两种协议如何协同工作
  - 在Redis的分布式环境中，Sentinel和Cluster模式可以同时使用。
    - Sentinel负责监控主从节点的健康状况，并在必要时进行故障转移。
    - 而Cluster则负责数据的分片存储和负载均衡。
  - 当Sentinel检测到主节点故障时，它会通过Raft协议选举出一个Leader Sentinel来执行故障转移操作。
  - 在这个过程中，Cluster中的节点通过Gossip协议保持通信，确保集群状态的一致性。

参考文档：

1. [Redis中的分布式一致性协议：Raft与Gossip的协同工作](https://cloud.baidu.com/article/3193422)

# Kafka

## 高可用

- Kafka 一个最基本的架构认识
  - 由多个 broker 组成，每个 broker 是一个节点；你创建一个 topic，这个 topic 可以划分为多个 partition，每个 partition 可以存在于不同的 broker 上，每个 partition 就放一部分数据。
- 这就是**天然的分布式消息队列**，就是说一个 topic 的数据，是**分散放在多个机器上的，每个机器就放一部分数据**。
- 实际上 RabbmitMQ 之类的，并不是分布式消息队列，它就是传统的消息队列，只不过提供了一些集群、HA(High Availability, 高可用性) 的机制而已，因为无论怎么玩儿，RabbitMQ 一个 queue 的数据都是放在一个节点里的，镜像集群下，也是每个节点都放这个 queue 的完整数据。
- Kafka 0.8 以前，是没有 HA 机制的，就是任何一个 broker 宕机了，那个 broker 上的 partition 就废了，没法写也没法读，没有什么高可用性可言。
  - 比如说，我们假设创建了一个 topic，指定其 partition 数量是 3 个，分别在三台机器上。但是，如果第二台机器宕机了，会导致这个 topic 的 1/3 的数据就丢了，因此这个是做不到高可用的。
- Kafka 0.8 以后，提供了 HA 机制，就是 replica（复制品） 副本机制。
  - 每个 partition 的数据都会同步到其它机器上，形成自己的多个 replica 副本。
  - 所有 replica 会选举一个 leader 出来，那么生产和消费都跟这个 leader 打交道，然后其他 replica 就是 follower。
  - 写的时候，leader 会负责把数据同步到所有 follower 上去，读的时候就直接读 leader 上的数据即可。只能读写 leader？很简单，**要是你可以随意读写每个 follower，那么就要 care 数据一致性的问题**，系统复杂度太高，很容易出问题。Kafka 会均匀地将一个 partition 的所有 replica 分布在不同的机器上，这样才可以提高容错性。
- 这么搞，就有所谓的**高可用性**了，因为如果某个 broker 宕机了，没事儿，那个 broker上面的 partition 在其他机器上都有副本的。如果这个宕机的 broker 上面有某个 partition 的 leader，那么此时会从 follower 中**重新选举**一个新的 leader 出来，大家继续读写那个新的 leader 即可。这就有所谓的高可用性了
  - **写数据**的时候，生产者就写 leader，然后 leader 将数据落地写本地磁盘，接着其他 follower 自己主动从 leader 来 pull 数据。一旦所有 follower 同步好数据了，就会发送 ack 给 leader，leader 收到所有 follower 的 ack 之后，就会返回写成功的消息给生产者。（当然，这只是其中一种模式，还可以适当调整这个行为）
  - **消费**的时候，只会从 leader 去读，但是只有当一个消息已经被所有 follower 都同步成功返回 ack 的时候，这个消息才会被消费者读到。

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景二：说说消息队列的高可用、不重复消费、可靠传输、顺序消费、消息堆积？ - Kafka 的高可用

## 不重复消费（幂等性）

其实还是得结合业务来思考，我这里给几个思路：

- 比如你拿个数据要写库，你先根据主键查一下，如果这数据都有了，你就别插入了，update 一下好吧。
- 比如你是写 Redis，那没问题了，反正每次都是 set，天然幂等性。
- 比如你不是上面两个场景，那做的稍微复杂一点，你需要让生产者发送每条数据的时候，里面加一个全局唯一的 id，类似订单 id 之类的东西，然后你这里消费到了之后，先根据这个 id 去比如 Redis 里查一下，之前消费过吗？如果没有消费过，你就处理，然后这个 id 写 Redis。如果消费过了，那你就别处理了，保证别重复处理相同的消息即可。
- 比如基于数据库的唯一键来保证重复数据不会重复插入多条。因为有唯一键约束了，重复数据插入只会报错，不会导致数据库中出现脏数据。

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景二：说说消息队列的高可用、不重复消费、可靠传输、顺序消费、消息堆积？ - 如何保障消息不重复消费（幂等性）？

## 可靠传输（不丢失）

- **消费者丢数据**
  - 唯一可能导致消费者弄丢数据的情况，就是说，你消费到了这个消息，然后消费者那边**自动提交了 offset**，让 Kafka 以为你已经消费好了这个消息，但其实你才刚准备处理这个消息，你还没处理，你自己就挂了，此时这条消息就丢咯。
  - 这不是跟 RabbitMQ 差不多吗，大家都知道 Kafka 会自动提交 offset，那么只要**关闭自动提交** offset，在处理完之后自己手动提交 offset，就可以保证数据不会丢。但是此时确实还是**可能会有重复消费**，比如你刚处理完，还没提交 offset，结果自己挂了，此时肯定会重复消费一次，自己保证幂等性就好了。
  - 生产环境碰到的一个问题，就是说我们的 Kafka 消费者消费到了数据之后是写到一个内存的 queue 里先缓冲一下，结果有的时候，你刚把消息写入内存 queue，然后消费者会自动提交 offset。然后此时我们重启了系统，就会导致内存 queue 里还没来得及处理的数据就丢失了。
- **Kafka 丢数据**
  - 这块比较常见的一个场景，就是 Kafka 某个 broker 宕机，然后重新选举 partition 的 leader。大家想想，要是此时其他的 follower 刚好还有些数据没有同步，结果此时 leader 挂了，然后选举某个 follower 成 leader 之后，不就少了一些数据？这就丢了一些数据啊。
  - 生产环境也遇到过，我们也是，之前 Kafka 的 leader 机器宕机了，将 follower 切换为 leader 之后，就会发现说这个数据就丢了。
  - 所以此时一般是要求起码设置如下 4 个参数：
    - 给 topic 设置 replication.factor 参数：这个值必须大于 1，要求每个 partition 必须有至少 2 个副本。
    - 在 Kafka 服务端设置 min.insync.replicas 参数：这个值必须大于 1，这个是要求一个 leader 至少感知到有至少一个 follower 还跟自己保持联系，没掉队，这样才能确保 leader 挂了还有一个 follower 吧。
    - 在 producer 端设置 acks=all ：这个是要求每条数据，必须是**写入所有 replica 之后，才能认为是写成功了**。
    - 在 producer 端设置 retries=MAX （很大很大很大的一个值，无限次重试的意思）：这个是**要求一旦写入失败，就无限重试**，卡在这里了。
  - 我们生产环境就是按照上述要求配置的，这样配置之后，至少在 Kafka broker 端就可以保证在 leader 所在 broker 发生故障，进行 leader 切换时，数据不会丢失。
- **生产者丢数据**
  - 如果按照上述的思路设置了 acks=all ，一定不会丢，要求是，你的 leader 接收到消息，所有的 follower 都同步到了消息之后，才认为本次写成功了。如果没满足这个条件，生产者会自动不断的重试，重试无限次。

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景二：说说消息队列的高可用、不重复消费、可靠传输、顺序消费、消息堆积？ - Kafka 如何保障消息的可靠

## 顺序性

- 先看看顺序会错乱的场景：
  - **Kafka**：比如说我们建了一个 topic，有三个 partition。生产者在写的时候，其实可以指定一个 key，比如说我们指定了某个订单 id 作为 key，那么这个订单相关的数据，一定会被分发到同一个 partition 中去，而且这个 partition 中的数据一定是有顺序的。 消费者从 partition 中取出来数据的时候，也一定是有顺序的。到这里，顺序还是 ok 的，没有错乱。
  - 接着，我们在消费者里可能会搞**多个线程来并发处理消息**。因为如果消费者是单线程消费处理，而处理比较耗时的话，比如处理一条消息耗时几十 ms，那么 1 秒钟只能处理几十条消息，这吞吐量太低了。而多个线程并发跑的话，顺序可能就乱掉了。
- **Kafka 解决方案**
  - 一个 topic，一个 partition，一个 consumer，内部单线程消费，单线程吞吐量太低，一般不会用这个。
  - 写 N 个内存 queue，具有相同 key 的数据都到同一个内存 queue；然后对于 N 个线程，每个线程分别消费一个内存 queue 即可，这样就能保证顺序性。

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景二：说说消息队列的高可用、不重复消费、可靠传输、顺序消费、消息堆积？ - 如何保证消息的顺序性？ - Kafka 解决方案

## 消息堆积

- **大量消息在 mq 里积压了几个小时了还没解决**
  - 一个消费者一秒是 1000 条，一秒 3 个消费者是 3000 条，一分钟就是 18 万条。所以如果你积压了几百万到上千万的数据，即使消费者恢复了，也需要大概 1 小时的时间才能恢复过来。
  - 一般这个时候，只能临时紧急扩容了，具体操作步骤和思路如下：
    - 先修复 consumer 的问题，确保其恢复消费速度，然后将现有 consumer 都停掉。
    - 新建一个 topic，partition 是原来的 10 倍，临时建立好原先 10 倍的 queue 数量。
    - 然后写一个临时的分发数据的 consumer 程序，这个程序部署上去消费积压的数据，**消费之后不做耗时的处理**，直接均匀轮询写入临时建立好的 10 倍数量的 queue。
    - 接着临时征用 10 倍的机器来部署 consumer，每一批 consumer 消费一个临时 queue 的数据。这种做法相当于是临时将 queue 资源和 consumer 资源扩大 10 倍，以正常的 10 倍速度来消费数据。
    - 等快速消费完积压数据之后，**得恢复原先部署的架构**，**重新**用原先的 consumer 机器来消费消息。
- **mq 中的消息过期失效了**
  - 假设你用的是 RabbitMQ，RabbtiMQ 是可以设置过期时间的，也就是 TTL。如果消息在 queue 中积压超过一定的时间就会被 RabbitMQ 给清理掉，这个数据就没了。那这就是第二个坑了。这就不是说数据会大量积压在 mq 里，而是**大量的数据会直接搞丢**。
  - 这个情况下，就不是说要增加 consumer 消费积压的消息，因为实际上没啥积压，而是丢了大量的消息。我们可以采取一个方案，就是**批量重导**，这个我们之前线上也有类似的场景干过。就是大量积压的时候，我们当时就直接丢弃数据了，然后等过了高峰期以后，比如大家一起喝咖啡熬夜到晚上12点以后，用户都睡觉了。这个时候我们就开始写程序，将丢失的那批数据，写个临时程序，一点一点的查出来，然后重新灌入 mq 里面去，把白天丢的数据给他补回来。也只能是这样了。
  - 假设 1 万个订单积压在 mq 里面，没有处理，其中 1000 个订单都丢了，你只能手动写程序把那 1000 个订单给查出来，手动发到 mq 里去再补一次。
- **mq 都快写满了**
  - 如果消息积压在 mq 里，你很长时间都没有处理掉，此时导致 mq 都快写满了，咋办？这个还有别的办法吗？没有，谁让你第一个方案执行的太慢了，你临时写程序，接入数据来消费，**消费一个丢弃一个，都不要了**，快速消费掉所有的消息。然后走第二个方案，到了晚上再补数据吧。

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景二：说说消息队列的高可用、不重复消费、可靠传输、顺序消费、消息堆积？ - 如何处理消息堆积？

# RabbitMQ

## 高可用

- RabbitMQ的高可用是**基于主从**（非分布式）做高可用性。RabbitMQ 有三种模式：**单机模式（Demo 级别）、普通集群模式（无高可用性）、镜像集群模式（高可用性）**。
- **普通集群模式**
  - 普通集群模式，意思就是在多台机器上启动多个 RabbitMQ 实例，每个机器启动一个。你**创建的queue，只会放在一个 RabbitMQ 实例上**，但是每个实例都同步 queue 的元数据（元数据可以认为是 queue 的一些配置信息，通过元数据，可以找到 queue 所在实例）。你消费的时候，实际上如果连接到了另外一个实例，那么那个实例会从 queue 所在实例上拉取数据过来。
  - 这种方式确实很麻烦，也不怎么好，**没做到所谓的分布式**，就是个普通集群。因为这导致你要么消费者每次随机连接一个实例然后拉取数据，要么固定连接那个 queue 所在实例消费数据，前者有**数据拉取的开销**，后者导致**单实例性能瓶颈**。
  - 而且如果那个放 queue 的实例宕机了，会导致接下来其他实例就无法从那个实例拉取，如果你**开启了消息持久化**，让 RabbitMQ 落地存储消息的话，**消息不一定会丢**，得等这个实例恢复了，然后才可以继续从这个 queue 拉取数据。
  - 所以这个事儿就比较尴尬了，这就**没有什么所谓的高可用性**，**这方案主要是提高吞吐量的**，就是说让集群中多个节点来服务某个 queue 的读写操作。
- **镜像集群模式**
  - 这种模式，才是所谓的 RabbitMQ 的高可用模式。跟普通集群模式不一样的是，在镜像集群模式下，你创建的 queue，无论元数据还是 queue 里的消息都会**存在于多个实例上**，就是说，每个 RabbitMQ 节点都有这个 queue 的一个**完整镜像**，包含 queue 的全部数据的意思。然后每次你写消息到 queue 的时候，都会自动把**消息同步**到多个实例的 queue 上。
  - 那么**如何开启这个镜像集群模式**呢？其实很简单，RabbitMQ 有很好的管理控制台，就是在后台新增一个策略，这个策略是**镜像集群模式的策略**，指定的时候是可以要求数据同步到所有节点的，也可以要求同步到指定数量的节点，再次创建 queue 的时候，应用这个策略，就会自动将数据同步到其他的节点上去了。
  - 好处
    - 你任何一个机器宕机了，没事儿，其它机器（节点）还包含了这个 queue 的完整数据，别的 consumer 都可以到其它节点上去消费数据。
  - 坏处
    - 第一，这个性能开销也太大了吧，消息需要同步到所有机器上，导致网络带宽压力和消耗很重！
    - 第二，这么玩儿，不是分布式的，就**没有扩展性可言**了，如果某个 queue 负载很重，你加机器，新增的机器也包含了这个 queue 的所有数据，并**没有办法线性扩展**你的 queue。你想，如果这个 queue 的数据量很大，大到这个机器上的容量无法容纳了，此时该怎么办呢？

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景二：说说消息队列的高可用、不重复消费、可靠传输、顺序消费、消息堆积？ - RabbitMQ 的高可用

## 可靠传输（不丢失）

- **生产者丢数据**
  - 生产者将数据发送到 RabbitMQ 的时候，可能数据就在半路给搞丢了，因为网络问题啥的，都有可能。此时可以选择用 RabbitMQ 提供的事务功能，就是生产者**发送数据之前**开启 RabbitMQ 事务 channel.txSelect ，然后发送消息，如果消息没有成功被 RabbitMQ 接收到，那么生产者会收到异常报错，此时就可以回滚事务 channel.txRollback ，然后重试发送消息；如果收到了消息，那么可以提交事务 channel.txCommit 。
    - 但是问题是，RabbitMQ 事务机制（同步）一搞，基本上**吞吐量会下来，因为太耗性能**。
  - 所以一般来说，如果你要确保说写 RabbitMQ 的消息别丢，可以开启 confirm 模式，在生产者那里设置开启 confirm 模式之后，你每次写的消息都会分配一个唯一的 id，然后如果写入了 RabbitMQ 中，RabbitMQ 会给你回传一个 ack 消息，告诉你说这个消息 ok 了。如果 RabbitMQ 没能处理这个消息，会回调你的一个 nack 接口，告诉你这个消息接收失败，你可以重试。而且你可以结合这个机制自己在内存里维护每个消息 id 的状态，如果超过一定时间还没接收到这个消息的回调，那么你可以重发。
  - 事务机制和 confirm 机制最大的不同在于，**事务机制是同步的**，你提交一个事务之后会**阻塞**在那儿，但是 confirm 机制是**异步**的，你发送个消息之后就可以发送下一个消息，然后那个消息 RabbitMQ 接收了之后会异步回调你的一个接口通知你这个消息接收到了。
  - 所以一般在生产者这块**避免数据丢失**，都是用 confirm 机制的。
- **RabbitMQ 丢数据**
  - 就是 RabbitMQ 自己弄丢了数据，这个你必须**开启** **RabbitMQ** **的持久化**，就是消息写入之后会持久化到磁盘，哪怕是 RabbitMQ 自己挂了，**恢复之后会自动读取之前存储的数据**，一般数据不会丢。除非极其罕见的是，RabbitMQ 还没持久化，自己就挂了，**可能导致少量数据丢失**，但是这个概率较小。
  - 设置持久化有**两个步骤**：
    - 创建 queue 的时候将其设置为持久化 这样就可以保证 RabbitMQ 持久化 queue 的元数据，但是它是不会持久化 queue 里的数据的。
    - 第二个是发送消息的时候将消息的 deliveryMode 设置为 2 就是将消息设置为持久化的，此时 RabbitMQ 就会将消息持久化到磁盘上去。
  - 必须要同时设置这两个持久化才行，RabbitMQ 哪怕是挂了，再次重启，也会从磁盘上重启恢复 queue，恢复这个 queue 里的数据。
  - 注意，哪怕是你给 RabbitMQ 开启了持久化机制，也有一种可能，就是这个消息写到了 RabbitMQ 中，但是还没来得及持久化到磁盘上，结果不巧，此时 RabbitMQ 挂了，就会导致内存里的一点点数据丢失。
  - 所以，持久化可以跟生产者那边的 confirm 机制配合起来，只有消息被持久化到磁盘之后，才会通知生产者 ack 了，所以哪怕是在持久化到磁盘之前，RabbitMQ 挂了，数据丢了，生产者收不到 ack ，你也是可以自己重发的。
- **消费者丢数据**
  - RabbitMQ 如果丢失了数据，主要是因为你消费的时候，**刚消费到，还没处理，结果进程挂了**，比如重启了，那么就尴尬了，RabbitMQ 认为你都消费了，这数据就丢了。
  - 这个时候得用 RabbitMQ 提供的 ack 机制，简单来说，就是你必须关闭 RabbitMQ 的自动 ack ，可以通过一个 api 来调用就行，然后每次你自己代码里确保处理完的时候，再在程序里 ack 一把。这样的话，如果你还没处理完，不就没有 ack 了？那 RabbitMQ 就认为你还没处理完，这个时候 RabbitMQ 会把这个消费分配给别的 consumer 去处理，消息是不会丢的。

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景二：说说消息队列的高可用、不重复消费、可靠传输、顺序消费、消息堆积？ - RabbitMQ 如何保障消息的可靠

## 顺序性

- 先看看顺序会错乱的场景：
  - **RabbitMQ**：一个 queue，多个 consumer。比如，生产者向 RabbitMQ 里发送了三条数据，顺序依次是 data1/data2/data3，压入的是 RabbitMQ 的一个内存队列。有三个消费者分别从 MQ 中消费这三条数据中的一条，结果消费者2先执行完操作，把 data2 存入数据库，然后是 data1/data3。这不明显乱了。
- 解决方案
  - 拆分多个 queue，每个 queue 一个 consumer，就是多一些 queue 而已，确实是麻烦点；或者就一个 queue 但是对应一个 consumer，然后这个 consumer 内部用内存队列做排队，然后分发给底层不同的 worker 来处理。

参考文档：

1. 《我要进大厂系列之面试圣经（第1版）.pdf》场景二：说说消息队列的高可用、不重复消费、可靠传输、顺序消费、消息堆积？ - 如何保证消息的顺序性？ - Kafka 解决方案

# Linux

## 创建文件

- `touch a.txt`
- `vi a.txt`
- `vim a.txt`
- `> a.txt`
  - 覆盖
- `>> a.txt`
  - 追加
  - 两个箭头指令前面常用的
    - `echo`
    - `cat`
- `cp a.txt /test`
  - 复制一个空文件

参考文档：

1. [Linux创建文件的5种方式 - CSDN](https://blog.csdn.net/xtho62/article/details/118194873)

## IO 多路复用

epoll 是现在最先进的 IO 多路复用器，Redis、Nginx、Linux 中的 Java NIO 都使用的是 epoll

|                      | select                                                | poll                                                | epoll                                                        |
| -------------------- | ----------------------------------------------------- | --------------------------------------------------- | ------------------------------------------------------------ |
| 操作方式             | 遍历                                                  | 遍历                                                | 回调                                                         |
| 数据结构             | bitmap                                                | 数组                                                | 红黑树                                                       |
| 最大连接数           | 1024(x86) 或 2048（x64）                              | 无上限                                              | 无上限                                                       |
| 最大支持文件描述符数 | 一般有最大值限制                                      | 65535                                               | 65535                                                        |
| fd 拷贝              | 每次调用 select，都需要把 fd 集合从用户态拷贝到内核态 | 每次调用 poll，都需要把 fd 集合从用户态拷贝到内核态 | fd 首次调用 epoll_ctl 拷贝，每次调用 epoll_wait 不拷贝       |
| 工作效率             | 每次调用都进行线性遍历，时间复杂度为 O(n)             | 每次调用都进行线性遍历，时间复杂度 O(n)             | 事件通知方式，每当 fd 就绪，系统注册的回调函数就会被调用，将就绪 fd 放到 readyList 里面，时间复杂度 O(1) |

# 计算机网络

## HTTP 和 HTTPS 区别

- 加密性
  - HTTP 明文传输，数据都是未加密的，安全性较差
  - HTTPS（SSL+HTTP） 数据传输过程是加密的，安全性较好。
- 认证
  - 使用 HTTPS 协议需要到 CA（Certificate Authority，数字证书认证机构） 申请证书，一般免费证书较少，因而需要一定费用。证书颁发机构如：Symantec、Comodo、GoDaddy 和 GlobalSign 等。
- 速度
  - HTTP 页面响应速度比 HTTPS 快，主要是因为 HTTP 使用 TCP 三次握手建立连接，客户端和服务器需要交换 3 个包
  - 而 HTTPS除了 TCP 的三个包，还要加上 ssl 握手需要的 9 个包，所以一共是 12 个包。
- 端口
  - http 和 https 使用的是完全不同的连接方式，用的端口也不一样，前者是 80，后者是 443。
- 服务器资源
  - HTTPS 其实就是建构在 SSL/TLS 之上的 HTTP 协议，所以，要比较 HTTPS 比 HTTP 要更耗费服务器资源。

参考文档：

1. [HTTP 与 HTTPS 的区别 - RUNOOB](https://www.runoob.com/w3cnote/http-vs-https.html)

## HTTPS 保证安全

- HTTPS 经由 HTTP 进行通信，但利用 SSL/TLS 来加密数据包。
  - SSL：（Secure Socket Layer，安全套接字层），位于可靠的面向连接的**网络层协议**和**应用层协议**之间的一种协议层。SSL通过互相认证、使用数字签名确保完整性、使用加密确保私密性，以实现客户端和服务器之间的安全通讯。该协议由两层组成：SSL记录协议和SSL握手协议。
    - SSL是TLS的前世。
  - TLS：(Transport Layer Security，传输层安全协议)，用于两个应用程序之间提供保密性和数据完整性。该协议由两层组成：TLS 记录协议和 TLS 握手协议。
    - TLS 以 SSL 3.0 为基础于 1999 年作为 SSL 的新版本推出。
    - SSL2.0 和 SSL3.0 已经被 IEFT 组织废弃（分别在 2011 年，2015 年）多年来，在被废弃的 SSL 协议中一直存在漏洞并被发现 (e.g. POODLE, DROWN)。大多数现代浏览器遇到使用废弃协议的 web 服务时，会降低用户体验（红线穿过挂锁标志或者https表示警告）来表现。
      - 因为这些原因，你应该在服务端禁止使用 SSL 协议，仅仅保留 TLS 协议开启。
- 常规的 HTTP 通信，有以下的问题。
  1. **窃听风险**（eavesdropping）：第三方可以获知通信内容。
  2. **篡改风险**（tampering）：第三方可以修改通信内容。
  3. **冒充风险**（pretending）：第三方可以冒充他人身份参与通信。
- 因此，SSL/TLS 协议就是为了解决这三大风险而设计的，希望达到：
  1. 所有信息都是**加密传播**，第三方无法窃听。
  2. 具有**校验机制**，一旦被篡改，通信双方会立刻发现。
  3. 配备**身份证书**，防止身份被冒充。

参考文档：

1. [Https 是如何保证安全的？ - 知乎](https://zhuanlan.zhihu.com/p/110216210)

## HTTP 1.0、1.1 和 2.0 的区别

- 结论
  - 结论1：从 HTTP/1.0 到 HTTP/2，都是利用 TCP 作为底层协议进行通信的。
  - 结论2：HTTP/1.1，引进了长连接(keep-alive)，减少了建立和关闭连接的消耗和延迟。
  - 结论3：HTTP/2，引入了多路复用：连接共享，提高了连接的利用率，降低延迟。

参考文档：

1. [HTTP1.0、HTTP1.1 和 HTTP2.0 的区别 - 知乎](https://zhuanlan.zhihu.com/p/370862112)

## TCP 可靠传输

- 实现了可靠性传输
  - 检验和
    - 通过检验和的方式，接收端可以检测出来数据是否有差错和异常，假如有差错就会直接丢弃TCP段，重新发送
  - 序列号/确认应答
    - 只要发送端有一个包传输，接收端没有回应确认包（ACK包），都会重发。或者接收端的应答包，发送端没有收到也会重发数据。这就可以保证数据的完整性。
  - 超时重传
    - 超时重传是指发送出去的数据包到接收到确认包之间的时间，如果超过了这个时间会被认为是丢包了，需要重传。
  - 最大消息长度
    - 在建立TCP连接的时候，双方约定一个最大的长度（MSS）作为发送的单位，重传的时候也是以这个单位来进行重传。理想的情况下是该长度的数据刚好不被网络层分块。
  - 滑动窗口控制
    - 我们上面提到的超时重传的机制存在效率低下的问题，发送一个包到发送下一个包要经过一段时间才可以。所以我们就想着能不能不用等待确认包就发送下一个数据包呢？这就提出了一个滑动窗口的概念。
    - 窗口的大小就是在无需等待确认包的情况下，发送端还能发送的最大数据量。这个机制的实现就是使用了大量的缓冲区，通过对多个段进行确认应答的功能。通过下一次的确认包可以判断接收端是否已经接收到了数据，如果已经接收了就从缓冲区里面删除数据。
  - 拥塞控制
    - 窗口控制解决了 两台主机之间因传送速率而可能引起的丢包问题，在一方面保证了TCP数据传送的可靠性。然而如果网络非常拥堵，此时再发送数据就会加重网络负担，那么发送的数据段很可能超过了最大生存时间也没有到达接收方，就会产生丢包问题。为此TCP引入慢启动机制，先发出少量数据，就像探路一样，先摸清当前的网络拥堵状态后，再决定按照多大的速度传送数据。

参考文档：

1. [TCP的可靠性传输是如何保证的 - 知乎](https://zhuanlan.zhihu.com/p/112317245)

## TCP 三次握手

- 过程
  - **第一次握手**：
    - 客户端将TCP报文**标志位SYN置为1**，随机产生一个序号值seq=J，保存在TCP首部的序列号(Sequence Number)字段里，指明客户端打算连接的服务器的端口，并将该数据包发送给服务器端
    - 发送完毕后，客户端进入`SYN_SENT`状态，等待服务器端确认。
  - **第二次握手**：
    - 服务器端收到数据包后由标志位SYN=1知道客户端请求建立连接
    - 服务器端将TCP报文**标志位SYN和ACK都置为1**，ack=J+1，随机产生一个序号值seq=K，并将该数据包发送给客户端以确认连接请求
    - 服务器端进入`SYN_RCVD`状态。
  - **第三次握手**：
    - 客户端收到确认后，检查ack是否为 J+1，ACK是否为1，如果正确则将标志位ACK置为1，ack=K+1，并将该数据包发送给服务器端
    - 服务器端检查ack是否为K+1，ACK是否为1，如果正确则连接建立成功，客户端和服务器端进入`ESTABLISHED`状态
    - 完成三次握手，随后客户端与服务器端之间可以开始传输数据了。
- 为什么需要三次
  - 我们假设client发出的第一个连接请求报文段并没有丢失，而是在某个网络结点长时间的滞留了，以致延误到连接释放以后的某个时间才到达server。本来这是一个早已失效的报文段。但server收到此失效的连接请求报文段后，就误认为是client再次发出的一个新的连接请求。于是就向client发出确认报文段，同意建立连接。
  - 假设不采用“三次握手”，那么只要server发出确认，新的连接就建立了。由于现在client并没有发出建立连接的请求，因此不会理睬server的确认，也不会向server发送数据。但server却以为新的运输连接已经建立，并一直等待client发来数据。这样，server的很多资源就白白浪费掉了。
  - 所以，采用“三次握手”的办法可以防止上述现象发生。例如刚才那种情况，client不会向server的确认发出确认。server由于收不到确认，就知道client并没有要求建立连接。

参考文档：

1. [一文彻底搞懂 TCP三次握手、四次挥手过程及原理 - 知乎](https://zhuanlan.zhihu.com/p/108504297)

## TCP 半连接状态

- 客户端向服务端发起连接请求，服务器第一次收到客户端的SYN之后，就会处于**SYN_RCVD状态**，此时双方还没有完全建立其连接，服务器会把此种状态下请求连接放到一个队列里，我们将这种队列称之为**半连接队列**。
- **全连接队列**就是已经完成了三次握手，建立起连接就会放到全连接队列中去，如果全连接队列满了就可能会出现丢包的现象。
- 补充关于SYN-ACK重传次数的问题
  - 服务器发送完SYN-ACK包，如果未收到客户端确认包，服务器进行首次重传，等待一段时间仍未收到客户确认包，进行第二次重传。如果重传次数超过系统规定的最大重传次数，系统将该连接信息从半连接队列中删除。
  - 每次重传等待的时间一般不同，一般是指数增长。如时间间隔是1，2，4，8

参考文档：

1. [TCP之半连接状态 - CSDN](https://blog.csdn.net/weixin_44390164/article/details/119077124)

## TCP 四次挥手

- 四次挥手即终止TCP连接，就是指断开一个TCP连接时，需要客户端和服务端总共发送4个包以确认连接的断开。

- 挥手请求可以是 Client 端，也可以是 Server 端发起的，我们假设是Client端发起：

  - **第一次挥手**： 
    - Client 端发起挥手请求，向Server端发送标志位是FIN报文段，设置序列号seq
    - 此时，Client端进入`FIN_WAIT_1`状态，这表示Client端没有数据要发送给Server端了。
  - **第二次分手**
    - Server 端收到了 Client 端发送的 FIN 报文段进入 `CLOSE_WAIT` 状态
    - Server 向 Client 端返回一个标志位是ACK的报文段，ack 设为 seq 加 1，Client 端收到后进入`FIN_WAIT_2`状态
    - Server端告诉Client端，我确认并同意你的关闭请求。
  - **第三次分手**： 
    - Server 端向 Client 端发送标志位是FIN的报文段，请求关闭连接
    - 同时 Server 端进入`LAST_ACK`状态。
  - **第四次分手** ： 
    - Client 端收到 Server 端发送的FIN报文段，向 Server 端发送标志位是 ACK 的报文段，然后 Client 端进入`TIME_WAIT` 状态。
    - Server端收到Client端的 ACK 报文段以后，就关闭连接。
    - 此时，Client 端等待 **2MSL** 的时间后依然没有收到回复，则证明 Server 端已正常关闭，那好，Client端也可以关闭连接了。

- 为什么需要四次

  - 建立连接时因为当Server端收到Client端的SYN连接请求报文后，可以直接发送**SYN+ACK**报文。其中ACK报文是用来应答的，SYN报文是用来同步的。所以建立连接只需要三次握手。
  - 由于TCP协议是一种面向连接的、可靠的、基于字节流的运输层通信协议，TCP是**全双工模式**。这就意味着，关闭连接时，当Client端发出FIN报文段时，只是表示Client端告诉Server端数据已经发送完毕了。当Server端收到FIN报文并返回ACK报文段，表示它已经知道Client端没有数据发送了，但是Server端还是可以发送数据到Client端的，所以Server很可能并不会立即关闭SOCKET，直到Server端把数据也发送完毕。当Server端也发送了FIN报文段时，这个时候就表示Server端也没有数据要发送了，就会告诉Client端，我也没有数据要发送了，之后彼此就会愉快的中断这次TCP连接。

- 为什么要等待2MSL？

  **MSL**：报文段最大生存时间，它是任何报文段被丢弃前在网络内的最长时间。有以下两个原因：

  - **第一点：保证TCP协议的全双工连接能够可靠关闭**：
    由于IP协议的不可靠性或者是其它网络原因，导致了Server端没有收到Client端的ACK报文，那么Server端就会在超时之后重新发送FIN，如果此时Client端的连接已经关闭处于`CLOESD`状态，那么重发的FIN就找不到对应的连接了，从而导致连接错乱，所以，Client端发送完最后的ACK不能直接进入`CLOSED`状态，而要保持`TIME_WAIT`，当再次收到FIN的收，能够保证对方收到ACK，最后正确关闭连接。
  - **第二点：保证这次连接的重复数据段从网络中消失**
    如果Client端发送最后的ACK直接进入`CLOSED`状态，然后又再向Server端发起一个新连接，这时不能保证新连接的与刚关闭的连接的端口号是不同的，也就是新连接和老连接的端口号可能一样了，那么就可能出现问题：如果前一次的连接某些数据滞留在网络中，这些延迟数据在建立新连接后到达Client端，由于新老连接的端口号和IP都一样，TCP协议就认为延迟数据是属于新连接的，新连接就会接收到脏数据，这样就会导致数据包混乱。所以TCP连接需要在TIME_WAIT状态等待2倍MSL，才能保证本次连接的所有数据在网络中消失。

参考文档：

1. [一文彻底搞懂 TCP三次握手、四次挥手过程及原理 - 知乎](https://zhuanlan.zhihu.com/p/108504297)

## 从输入 URL 到页面展示的过程

- 1、输入网址
- 2、DNS 解析
- 3、建立 tcp 连接
- 4、客户端发送 HTTP 请求
- 5、服务器处理请求
  - （可能出现重定向，可能的 Nginx 反向代理）
- 6、服务器响应请求
  - 状态码
    - 1xx：信息性状态码，表示服务器已接收了客户端请求，客户端可继续发送请求。
      - 100 Continue
      - 101 Switching Protocols
    - 2xx：成功状态码，表示服务器已成功接收到请求并进行处理。
      - 200 OK 表示客户端请求成功
      - 204 No Content 成功，但不返回任何实体的主体部分
      - 206 Partial Content 成功执行了一个范围（Range）请求
    - 3xx：重定向状态码，表示服务器要求客户端重定向。
      - 301 Moved Permanently 永久性重定向，响应报文的Location首部应该有该资源的新URL
      - 302 Found 临时性重定向，响应报文的Location首部给出的URL用来临时定位资源
      - 303 See Other 请求的资源存在着另一个URI，客户端应使用GET方法定向获取请求的资源
      - 304 Not Modified 服务器内容没有更新，可以直接读取浏览器缓存
      - 307 Temporary Redirect 临时重定向。与302 Found含义一样。302禁止POST变换为GET，但实际使用时并不一定，307则更多浏览器可能会遵循这一标准，但也依赖于浏览器具体实现
    - 4xx：客户端错误状态码，表示客户端的请求有非法内容。
      - 400 Bad Request 表示客户端请求有语法错误，不能被服务器所理解
      - 401 Unauthonzed 表示请求未经授权，该状态代码必须与 WWW-Authenticate 报头域一起使用
      - 403 Forbidden 表示服务器收到请求，但是拒绝提供服务，通常会在响应正文中给出不提供服务的原因
      - 404 Not Found 请求的资源不存在，例如，输入了错误的URL
    - 5xx：服务器错误状态码，表示服务器未能正常处理客户端的请求而出现意外错误。
      - 500 Internel Server Error 表示服务器发生不可预期的错误，导致无法完成客户端的请求
      - 503 Service Unavailable 表示服务器当前不能够处理客户端的请求，在一段时间之后，服务器可能会恢复正常
- 7、浏览器展示 HTML
  - 解析过程中，浏览器首先会解析HTML文件构建DOM树，然后解析CSS文件构建渲染树，等到渲染树构建完成后，浏览器开始布局渲染树并将其绘制到屏幕上。
- 8、浏览器发送请求获取其他在 HTML 中的资源
  - （部分可能从 CDN 获取；部分可能浏览器缓存）

参考文档：

1. [从输入URL到页面展示的详细过程 - CSDN](https://blog.csdn.net/wlk2064819994/article/details/79756669)

# 分布式系统

## CAP 理论

- CAP
  - Consistency（一致性）
    - 对于客户端的每次读操作，要么读到的是最新的数据，要么读取失败。换句话说，一致性是站在分布式系统的角度，对访问本系统的客户端的一种承诺：要么我给您返回一个错误，要么我给你返回绝对一致的最新数据，不难看出，其强调的是数据正确。
  - Availability（可用性）
    - 任何客户端的请求都能得到响应数据，不会出现响应错误。换句话说，可用性是站在分布式系统的角度，对访问本系统的客户的另一种承诺：我一定会给您返回数据，不会给你返回错误，但不保证数据最新，强调的是不出错。
  - Partition tolerance（分区容忍性）
    - 由于分布式系统通过网络进行通信，网络是不可靠的。当任意数量的消息丢失或延迟到达时，系统仍会继续提供服务，不会挂掉。换句话说，分区容忍性是站在分布式系统的角度，对访问本系统的客户端的再一种承诺：我会一直运行，不管我的内部出现何种数据同步问题，强调的是不挂掉。
- 权衡 C、A
  - 对于一个分布式系统而言，P是前提，必须保证，因为只要有网络交互就一定会有延迟和数据丢失，这种状况我们必须接受，必须保证系统不能挂掉。
  - 当选择了C（一致性）时，如果由于网络分区而无法保证特定信息是最新的，则系统将返回错误或超时。
  - 当选择了A（可用性）时，系统将始终处理客户端的查询并尝试返回最新的可用的信息版本，即使由于网络分区而无法保证其是最新的。
- 为什么不能同时满足三个
  - 可以举例：A 更新数据，此时 A、B 网络断开，B 未能同步，此时需要保证分区容错性的前提下，B 无法在满足一致性和可用性的同时返回最新的数据

参考文档：

1. [轻松理解CAP理论 - 知乎](https://zhuanlan.zhihu.com/p/50990721)

# 设计模式

## 单例模式

- 实现方式

  1. 懒汉式，线程不安全

     **是否 Lazy 初始化：**是

     **是否多线程安全：**否

     ```java
     public class Singleton {  
         private static Singleton instance;  
         private Singleton (){}  
       
         public static Singleton getInstance() {  
             if (instance == null) {  
                 instance = new Singleton();  
             }  
             return instance;  
         }  
     }
     ```

  2. 懒汉式，线程安全

     **是否 Lazy 初始化：**是

     **是否多线程安全：**是

     ```java
     public class Singleton {  
         private static Singleton instance;  
         private Singleton (){}  
         public static synchronized Singleton getInstance() {  
             if (instance == null) {  
                 instance = new Singleton();  
             }  
             return instance;  
         }  
     }
     ```

  3. 饿汉式

     **是否 Lazy 初始化：**否

     **是否多线程安全：**是

     ```java
     public class Singleton {  
         private static Singleton instance = new Singleton();  
         private Singleton (){}  
         public static Singleton getInstance() {  
         return instance;  
         }  
     }
     ```

  4. 双检锁/双重校验锁（DCL，即 double-checked locking）

     **是否 Lazy 初始化：**是

     **是否多线程安全：**是

     ```java
     public class Singleton {  
         private volatile static Singleton singleton;  
         private Singleton (){}  
         public static Singleton getSingleton() {  
             if (singleton == null) {  
                 synchronized (Singleton.class) {  
                     if (singleton == null) {  
                         singleton = new Singleton();  
                     }  
                 }  
             }  
             return singleton;  
         }  
     }
     ```

  5. 登记式/静态内部类

     **是否 Lazy 初始化：**是

     **是否多线程安全：**是

     ```java
     public class Singleton {  
         private static class SingletonHolder {  
         private static final Singleton INSTANCE = new Singleton();  
         }  
         private Singleton (){}  
         public static final Singleton getInstance() {  
             return SingletonHolder.INSTANCE;  
         }  
     }
     ```

  6. 枚举

     **是否 Lazy 初始化：**否

     **是否多线程安全：**是

     ```java
     public enum Singleton {  
         INSTANCE;  
         public void whateverMethod() {  
         }  
     }
     ```

  7. 单例注册表

     单例注册表是Spring中Bean单例的核心实现方案。可以通过一个ConcurrentHashMap存储Bean对象，保证Bean名称唯一的情况下也能保证线程安全。

参考文档：

1. [单例模式 - RUNOOB](https://www.runoob.com/design-pattern/singleton-pattern.html)
2. [详解单例模式及其在Sping中的最优实践 - 知乎](https://zhuanlan.zhihu.com/p/442496004)

# 算法

## 堆排序

```java
/**
 * 堆排序演示
 *
 * @author Lvan
 */
public class HeapSort {
    public static void main(String[] args) {
//        int[] arr = {5, 1, 7, 3, 1, 6, 9, 4};
        int[] arr = {16, 7, 3, 20, 17, 8};
        heapSort(arr);
        for (int i : arr) {
            System.out.print(i + " ");
        }
    }

    /**
     * 创建堆，
     * @param arr 待排序列
     */
    private static void heapSort(int[] arr) {
        //创建堆
        for (int i = (arr.length - 1) / 2; i >= 0; i--) {
            //从第一个非叶子结点从下至上，从右至左调整结构
            adjustHeap(arr, i, arr.length);
        }
        //调整堆结构+交换堆顶元素与末尾元素
        for (int i = arr.length - 1; i > 0; i--) {
            //将堆顶元素与末尾元素进行交换
            int temp = arr[i];
            arr[i] = arr[0];
            arr[0] = temp;
            //重新对堆进行调整
            adjustHeap(arr, 0, i);
        }
    }

    /**
     * 调整堆
     * @param arr 待排序列
     * @param parent 父节点
     * @param length 待排序列尾元素索引
     */
    private static void adjustHeap(int[] arr, int parent, int length) {
        //将temp作为父节点
        int temp = arr[parent];
        //左孩子
        int lChild = 2 * parent + 1;
        while (lChild < length) {
            //右孩子
            int rChild = lChild + 1;
            // 如果有右孩子结点，并且右孩子结点的值大于左孩子结点，则选取右孩子结点
            if (rChild < length && arr[lChild] < arr[rChild]) {
                lChild++;
            }
            // 如果父结点的值已经大于孩子结点的值，则直接结束
            if (temp >= arr[lChild]) {
                break;
            }
            // 把孩子结点的值赋给父结点
            arr[parent] = arr[lChild];

            //选取孩子结点的左孩子结点,继续向下筛选
            parent = lChild;
            lChild = 2 * lChild + 1;
        }
        arr[parent] = temp;
    }
}
```

参考文档：

1. [堆排序——Java实现 - 博客园](https://www.cnblogs.com/luomeng/p/10618709.html)

## 快速排序

```java
public class QuickSort {
	private void swap(int[] arr, int i, int j) {
		int temp = arr[i];
		arr[i] = arr[j];
		arr[j] = temp;
	}
	
	public void quickSort(int[] arr, int start, int end) {
		if (start >= end)
			return;
		int k = arr[start];
		int i = start, j = end;
		while (i != j) {
			while (i < j && arr[j] >= k)
				--j;
			swap(arr, i, j);
			while (i < j && arr[i] <= k)
				++i;
			swap(arr, i, j);
		}
		quickSort(arr, start, i - 1);
		quickSort(arr, i + 1, end);
	}
	
	public static void main(String[] args) {
		int[] arr = {5, 2, 6, 9, 1, 3, 4, 8, 7, 10};
		new QuickSort().quickSort(arr, 0, arr.length - 1);
		System.out.println(Arrays.toString(arr));
	}
}
```

参考文档：

1. [快速排序Java代码简洁实现 - 知乎](https://zhuanlan.zhihu.com/p/144738954)

## Java 排序实现

- Collections.sort()排序有两种实现方式
  - 一是让元素类实现Comparable接口并覆盖compareTo()方法
  - 二是给Collecitons.sort()方法传入比较器，通常采用匿名内部内的方式传入。
- Collections.sort() 通过调用Arrays.sort()方法进行排序
  - 在Java1.6+中，如果集合大小<32则采用Tim-Sort算法，如果>=32则采用归并排序。
  - ComparableTimSort.sort()
    - 如果**2<= nRemaining <=32**,即MIN_MERGE的初始值，表示需要排序的数组是小数组，**可以使用mini-TimSort方法进行排序**
      - mini-TimSort排序方法：先找出数组中从下标为0开始的第一个升序序列，或者找出降序序列后转换为升序重新放入数组，将这段升序数组作为初始数组，将之后的每一个元素通过二分法排序插入到初始数组中。注意，这里就调用到了我们重写的compareTo()方法了。
    - **否则 nRemaining > 32 需要使用归并排序**。

参考文档

1. [Java集合排序功能实现分析 - 博客园](https://www.cnblogs.com/dudadi/p/8007167.html)