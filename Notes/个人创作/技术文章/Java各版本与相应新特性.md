最近看 Spring framework 6、Spring Boot 3、Elasticsearch 8.0 这些都得使用 Java 17 了，而 Kafka 3.0 开始也弃用了 Java 8。正好自己一直没有系统性地去了解一下 Java 9 以后各个新版本的特性，所以自己总结了一下各个 Java 版本的特性，整理好以供参考和学习。

> Spring framework 6 消息来源：https://spring.io/blog/2021/09/02/a-java-17-and-jakarta-ee-9-baseline-for-spring-framework-6
>
> Spring Boot 3 消息来源：https://spring.io/blog/2022/01/20/spring-boot-3-0-0-m1-is-now-available
>
> Elasticsearch 8.0 消息来源：https://www.elastic.co/guide/en/elasticsearch/reference/8.0/migrating-8.0.html
>
> Kafka 3.0 消息来源：https://kafka.apache.org/downloads
>
> 
>
> 不过，Spring 和 Kafka 的新版本文档截至目前（2022.2.21）还没更新过来，里面还有支持 Java 8 的语句没修改…… 不禁感叹论时效性的话，还是需要关注各个框架的官宣文稿啊
>
> Kafka 3.1.x 文档：https://kafka.apache.org/documentation/#java
>
> ![Java各版本_kafka文档](.\图片\Java各版本_kafka文档.png)
>
> Spring framework 6.0.0 文档：https://docs.spring.io/spring-framework/docs/6.0.0-SNAPSHOT/reference/html/overview.html#overview
>
> ![](C:\Users\zhuxi\IdeaProjects\BlogBackup\技术文章\图片\Java各版本_spring6文档.png)



# Java 各版本的简略新特性表

| 版本 | 发布时间 | 新特性                                                       |
| ---- | -------- | ------------------------------------------------------------ |
| 1.0  | 1996     | 语言本身、Java 虚拟机、Applet、AWT                           |
| 1.1  | 1997     | 内部类、反射、JAR 文件格式、JDBC、JavaBeans、RMI             |
| 1.2  | 1998     | strictfp 修饰符、Java 类库的 Collections 集合类、J2SE \ J2EE \ J2ME 体系、EJB、Java Plug-in、Java IDL、Swing、JIT 即时编译器 |
| 1.3  | 2000     | Java 类库的数学运算和新的 Timer API 等、JNDI 开始作为一项平台级服务、使用 CORBA IIOP 实现 RMI、提供大量新的 Java 2D API、新添加 Java Sound 类库 |
| 1.4  | 2002     | 断言、正则表达式、异常链、NIO、日志类、XML 解析器、XSLT 转换器 |
| 5.0  | 2004     | 泛型类、遍历循环（for each 循环）、可变长参数、自动装箱、元数据（动态注解）、枚举、静态导入、改进了 JMM（Java 内存模型）、提供了 java.util.concurrent（JUC）并发包 |
| 6    | 2006     | 启用Java EE 6 \ Java SE 6 \ Java ME 6的新命名来代替J2EE \ J2SE \ J2ME的产品线命名方式、提供初步的动态语言支持、提供编译期注解处理器、微型 HTTP 服务器 API、对 Java 虚拟机内部做了大量改进（锁与同步、垃圾收集、类加载等方面的实现） |
| 7    | 2011.7   | 基于字符串的 switch、钻石操作符、二进制字面量、异常处理改进、提供新的 G1 收集器、加强对非 Java 语言的调用支持、可并行的类加载架构 |
| 8    | 2014.3   | Lambda 表达式、包含默认方法的接口、流和日期/时间库、内置Nashorn JavaScript引擎的支持、彻底移除 HotSpot 的永久代 |
| 9    | 2017.9   | Jigsaw 模块化功能、接口私有方法、Try-With Resources、@SafeVarargs注释、集合工厂方法、Process API改进、流API改进、增强若干工具（JS Shell、JLink、JHSDB等）、整顿了 HotSpot 各个模块各自为战的日志系统、支持HTTP 2客户单API |
| 10   | 2018.3   | 局部变量的类型推断、应用类数据共享、向G1引入并行Full GC、线程局部管控、统一源仓库、统一垃圾收集器接口、统一即时编译器接口（引入新的Graal即时编译器） |
| 11   | 2018.9   | ZGC 垃圾收集器、本地变量类型推断、字符串加强、集合加强、Stream 加强、Optional 加强、InputStream 加强、HTTP Client API、一个命令编译运行源代码 |
| 12   | 2019.3   | Switch 表达式（预览）、Java 微测试套件（JMH）、Shenandoah垃圾收集器、JVM常量API、默认类数据共享归档文件、可终止的G1 Mixed GC、G1及时返回未使用的已分配内存 |
| 13   | 2019.9   | 增强 ZGC 释放未使用内存、Socket API 重构、Switch 表达式扩展（预览功能）、文本块（预览功能） |
| 14   | 2020.3   | 完全支持改进的 switch 表达式、instanceof 支持模式匹配、record 特性、NullPointerException 精确到变量、加入了 Java 打包工具 jpackage 的预览版 |
| 15   | 2020.9   | ZGC 将从实验功能升级为产品、char 在 CharSequence 中添加了 isEmpty 默认方法、支持 Unicode 13.0、隐藏类、TreeMap 方法的专用实现、增加了为远程JMX配置第三个端口的能力 |
| 16   | 2021.3   | record 正式使用、jpackage 工具正式使用、instanceof 正式使用  |
| 17   | 2021.9   | 增强了伪随机数算法、移除 AOT 提前编译和 JIT 即时编译的功能、sealed修饰的类和接口限制其他的类或者接口的扩展和实现、进一步增强了switch语法的模式匹配 |

较早的版本特性参考了《Java 核心技术：卷I 基础知识（原书第11版）》和《深入理解 Java 虚拟机：JVM 高级特性与最佳实践（第3版）》

# JDK 8 ~ 17 各版本变化简单总结

需要注意，OpenJDK 和 Oracle 在具体细节上会有区别，以下列表中斜体为 OpenJDK 文档中提到的变化。

## JDK 8

具体常用的特性可以参考《Java 8 实战》，感觉很详细

| 所属范围 | 新特性                                                       |
| -------- | ------------------------------------------------------------ |
| 语言     | **Lambda 表达式**、**方法引用**、**接口默认方法**、**重复注解**、**类型注解（Type Annotation）**、改进的类型推断、方法参数反射 |
| 核心库   | **java.util.stream 包中的类提供 Stream API**、**java.util.Optional**、**具有键冲突的 HashMap 的性能改进（红黑树）**、Rhino javascript 引擎已被Nashorn Javascript 引擎 取代、<br/>IO 和 NIO （`SelectorProvider` 基于 Solaris 事件端口机制的 Solaris 新实现、减小`<JDK_HOME>/jre/lib/charsets.jar` 文件大小、`java.lang.String(byte[], *)`构造函数和方法 `java.lang.String.getBytes()` 的性能改进）、<br/>并行数组排序、标准编码和解码 Base64、无符号算术支持、<br/>网络（类 `java.net.URLPermission` 已添加、类 `java.net.HttpURLConnection` 中如果安装了安全管理器则调用该请求以打开连接需要权限）、<br/>**并发**（`java.util.concurrent`包新类和接口、 `java.util.concurrent.ConcurrentHashMap` 类新方法以支持基于新添加的流工具和 lambda 表达式的聚合操作、`java.util.concurrent.atomic` 包新类以支持可扩展的可更新变量、`java.util.concurrent.ForkJoinPool` 类新方法以支持公共池、添加类`java.util.concurrent.locks.StampedLock`以提供基于能力的锁，该锁具有三种用于控制读/写访问的模式） |
| JVM      | 添加了硬件内在函数以使用高级加密标准 (AES)、**删除 PermGen**、Java 编程语言中的默认方法由方法调用的字节码指令支持 |
| 工具     | `jjs` 命令以调用 Nashorn 引擎、`java` 命令启动 JavaFX 应用程序、`java` 手册页已重新设计、`jdeps` 命令行工具用于分析类文件、Java 管理扩展 (JMX) 提供对诊断命令的远程访问、`jarsigner` 工具用于向时间戳权威 (TSA) 请求签名时间戳的选项、<br/>javac 命令（可用于存储形式参数名称并使反射 API 能够检索形式参数名称的`-parameters`选项、正确实施 Java 语言规范 (JLS) 第 15.21 节中相等运算符的类型规则、支持在运行 `javadoc` 时生成的文件中检查可能导致各种问题的问题的评论内容、提供了根据需要生成本机标头的能力）、<br/>Pack200（对 JSR 292 引入的常量池条目和新字节码的支持、支持由 JSR-292、JSR-308 和 JSR-335 指定的类文件更改）、<br/>JDBC（JDBC-ODBC 桥已被删除、JDBC 4.2 引入了新特性）、<br/>包含 Java DB 10.10、包括 Java Mission Control 5.3 |
| javadoc  | 支持新的 `DocTree` API、支持新的 Javadoc Access API、现在支持在运行 `javadoc` 时生成的文件中检查可能导致各种问题的问题的评论内容 |
| 部署     | 对于沙盒小程序和 Java Web Start 应用程序，`URLPermission` 现在用于允许连接回到启动它们的服务器而 `SocketPermission`不再允许、在所有安全级别的主 JAR 文件的 JAR 文件清单中都需要 Permissions 属性 |
| 国际化   | **Unicode 6.2.0**、采用 Unicode CLDR 数据和 java.locale.providers 系统属性、**新的日历和语言环境 API**、能够将自定义资源包安装为扩展 |
| 客户端库 | JavaFX（新的 Modena 主题、`SwingNode`类使开发人员能够将 Swing 内容嵌入到 JavaFX 应用程序中、新的 UI 控件、`javafx.print` 包为 JavaFX 打印 API 提供公共类、3D 图形功能现在包括 3D 形状 \ 相机 \ 灯光 \ 子场景 \ 材质 \ 拾取和抗锯齿、`WebView` 提供了新功能和改进、增强的文本支持、对 Hi-DPI 显示器的支持、CSS Styleable* 类成为公共 API、新 ScheduledService 类允许自动重启服务、可用于 ARM 平台） |
| 安全     | 默认启用客户端 TLS 1.2、`AccessController.doPrivileged` 使代码能够断言其权限的子集、更强大的基于密码的加密算法、JSSE 服务器中的 SSL/TLS 服务器名称指示 (SNI) 扩展支持、支持 AEAD 算法、KeyStore 增强功能、SHA-224 消息摘要、增强对 NSA Suite B 加密的支持、更好地支持高熵随机数生成、`java.security.cert.PKIXRevocationChecker`用于配置 X.509 证书吊销检查、适用于 Windows 的 64 位 PKCS11、Kerberos 5 重放缓存中的新 rcache 类型、支持 Kerberos 5 协议转换和约束委派、默认禁用 Kerberos 5 弱加密类型、GSS-API/Kerberos 5 机制的未绑定 SASL、多个主机名的 SASL 服务、JNI 桥接到 Mac OS X 上的本机 JGSS、在 SunJSSE 提供程序中支持更强的临时 DH 密钥、支持 JSSE 中的服务器端密码套件首选项自定义 |

## JDK 9

| 所属范围 | 新特性                                                       | 删除                                          | 弃用                  |
| -------- | ------------------------------------------------------------ | --------------------------------------------- | --------------------- |
| 规范     | **模块系统**、新的版本字符串方案                             |                                               |                       |
| 语言     | 打磨Coin项目（**@SafeVargs 可用于私有实例方法**、**等价 final 变量可用于 try-with-resouces 语句**、**接口私有方法**、**禁止将下划线作为合法标识符**、**匿名类钻石标识符**） |                                               |                       |
| 核心库   | **集合的便利工厂方法**、**紧凑字符串**、平台日志 API 和服务、**并发包更新**、增强的方法句柄、**增强 @Deprecated 注解**、自旋等待提示、**过滤传入的序列化数据**、进程 API 更新、变量处理器、XML 目录 API、堆栈遍历 API、将选定的 Xerces 2.11.0 更新合并到 JAXP、**Nashorn 的解析器 API**、在 Nashorn 中实现选定的 ECMAScript 6 功能 |                                               |                       |
| JVM      | 编译器控制、分段代码缓存、语言定义对象模型的动态链接、**G1 成为默认垃圾收集器**、提高 G1 可用性确定性和性能、**统一 JVM 日志记录**、**统一 GC 日志记录** | **JDK 8 中已弃用的 GC 组合**                  | **CMS 垃圾收集器**    |
| 工具     | **jshell**、更多诊断命令、多版本JAR文件、为旧平台版本编译、**jlink** | 启动时JRE版本选择、JVM TI hprof代理、**jhat** |                       |
| javadoc  | 简化的Doclet API、支持 HTML 5、支持搜索、模块系统            |                                               |                       |
| 部署     | 增强的 Java 控制面板、**模块化 Java 应用程序打包**           |                                               | Java 插件、Applet API |
| 国际化   | **Unicode 8.0**、默认启用 CLDR 区域设置数据、**UTF-8 属性文件** |                                               |                       |
| 客户端库 | 多分辨率图像、为模块化准备 JavaFX UI 控件和 CSS API、BeanInfo 注解、TIFF 图像 I/O、Windows 和 Linux 上的 HiDPI 图形、特定于平台的桌面功能、在 Linux 上启用 GTK 3 |                                               |                       |
| 安全     | DTLS、TLS应用层协议协商扩展、TLS的OCSP Stapling、利用 GHASH 和 RSA 的 CPU 指令、基于 DRBG 的 SecureRandom 实现、禁用 SHA-1 证书、默认创建 PKCS 12 密钥库、SHA-3 哈希算法 |                                               |                       |

## JDK 10

| 所属范围 | 新特性                                                       | 删除                                                         | 弃用                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 语言     | ***局部变量的类型推断 var***                                 |                                                              |                                                              |
| 核心库   | Optional.orElseThrow()、**不可修改集合 API**、*基于时间的发布版本控制* | Runtime.getLocalizedInputStream 和 getLocalizedOutputStream 方法、RMI 服务器端多路复用协议支持、 |                                                              |
| JVM      | **G1 的并行 Full GC**、<br/>***垃圾收集器接口***、*应用程序类-数据共享（CDS）*、*线程本地握手*、*在用户指定的备用内存设备（例如 NV-DIMM）上分配 Java 对象堆*、***实验性基于 Java 的 JIT 编译器 Graal*** | FlatProfiler、过时的 -X 选项                                 |                                                              |
| 工具     | 增强 for 循环的字节码生成                                    | Native-Header 生成工具 (javah)、Java Launcher 的数据模型选项 -d32 和 -d64 |                                                              |
| javadoc  | 支持多种样式表、重写不改变规范的方法、@Summary 注解          | 旧的（JDK 6、JDK 7 和 JDK 8 时代）标准 Doclet                |                                                              |
| 部署     | *将 JDK 森林整合到一个存储库中*                              | 常见的 DOM API                                               |                                                              |
| svc      | 禁用 JRE 上次使用跟踪的系统属性、开箱即用 JMX 代理的散列密码 |                                                              | SNMP 监控支持                                                |
| 国际化   | *额外的 Unicode 语言标签扩展*                                |                                                              |                                                              |
| 客户端库 |                                                              | 对使用旧 LookAndFeel 的支持、JavaFX 应用程序生命周期的 HostServicesgetWebContext 方法、JavaFX 中的 T2K Rasterizer 和 ICU 布局引擎、JavaFX 中已弃用的 VP6/FXM/FLV 代码 |                                                              |
| 安全     | 根证书、TLS Session Hash 和扩展的 Master Secret 扩展支持     | 已弃用的 Pre-1.2 SecurityManager 方法和字段、policytool 工具、com.sun.security.auth 中已弃用的类 | java.security.{Certificate,Identity,IdentityScope,Signer} APIs、 java.security.acl APIs、 javax.security.auth.Policy API |

## JDK 11

| 所属范围 | 新特性                                                       | 删除                                                         | 弃用                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 语言     | **Lambda 参数的局部变量使用 var 语法**                       |                                                              |                                                              |
| 核心库   | **HTTP 客户端（标准）**、**新的 Collection.toArray(IntFunction) 默认方法**、 | sun.misc.Unsafe.defineClass、**Thread.destroy() 和 Thread.stop(Throwable) 方法**、sun.nio.ch.disableSystemWideOverlappingFileLockCheck 属性 | ThreadPoolExecutor 不应该指定对终结方法的依赖、**Nashorn JavaScript 引擎** |
| JVM      | 编译器线程的延迟分配、**ZGC 可扩展的低延迟垃圾收集器（实验性）**、**Epsilon 无操作垃圾收集器**、低开销堆分析、基于嵌套的访问控制、<br/>*动态类文件常量*、*改进 Aarch64 内在函数*、***飞行记录仪（Flight Recorder）*** |                                                              | -XX+AggressiveOpts、对商业功能的过时支持                     |
| 工具     | 启动单文件源代码程序                                         | **Java Mission Control (JMC)**、**Java EE 和 CORBA 模块**    | Pack200 工具和 API                                           |
| 部署     |                                                              | Java 部署技术                                                |                                                              |
| svc      |                                                              | JVM-MANAGEMENT-MIB.mib、SNMP 代理                            |                                                              |
| 国际化   | **Unicode 10**、将语言环境数据更新为 Unicode CLDR v33        | sun.locale.formatasdefault 属性                              |                                                              |
| 客户端库 |                                                              | **JavaFX**、com.sun.awt.AWTUtilities 类、Oracle JDK 中的 Lucida 字体、appletviewer Launcher、Oracle JDK 的 javax.imageio JPEG 插件不再支持带 alpha 的图像 | NSWindowStyleMaskTexturedBackground                          |
| 安全     | 与 Curve25519 和 Curve448 的 JEP 324 密钥协议、Brainpool EC 支持、ChaCha20 和 Poly1305 加密算法、增强的密钥库机制、向 SunMSCAPI 添加 RSASSA-PSS 签名支持、传输层安全 (TLS) 1.3、支持 RFC 8009 中定义的 Kerberos 5 的 HMAC-SHA2 的 AES 加密 |                                                              | 基于流的 GSSContext 方法                                     |

## JDK 12

| 所属范围 | 新特性                                                       | 删除                                                         | 弃用                    |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------- |
| 语言     | **switch 表达式（预览）**                                    |                                                              |                         |
| 核心库   | Linux 上的POSIX_SPAWN 选项、JVM 常量 API、紧凑数字格式       | FileInputStream 和 FileOutputStream 中的 finalize 方法、 java.util.ZipFile/Inflator/Deflator 中的 finalize 方法 |                         |
| JVM      | ZGC 并发类卸载、在备用内存设备上分配老一代 Java 堆、HotSpot Windows 操作系统检测正确识别 Windows Server 2019、命令行标志 -XX+ExtensiveErrorReports、<br/>***Shenandoah：一种低暂停时间的垃圾收集器（实验性）***、*仅维护单个 AArch64 端口*、*默认CDS档案*、***G1 的可中止混合收集***、***立即从 G1 返回未使用的已提交内存*** |                                                              | -XX+/-MonitorInUseLists |
| 工具     | jdeps --print-module-deps 报告传递依赖、<br/>***微基准套件（JMH）*** | javac 对 6/1.6 源、目标和发布值的支持                        |                         |
| svc      |                                                              | 从 Oracle 生成的构建中的 YY.M 供应商版本字符串               |                         |
| 国际化   | **Unicode 11**、日文新年号的方形字符支持                     |                                                              |                         |
| 客户端库 |                                                              | com.sun.awt.SecurityWarning 类                               |                         |
| 安全     | 禁止和允许 java.security.manager 系统属性的选项、-groupname 选项已添加到 keytool 密钥对生成、新的 Java Flight Recorder (JFR) 安全事件、自定义 PKCS12 密钥库的生成、ChaCha20 和 Poly1305 TLS、支持 krb5.conf 中的dns_canonicalize_hostname标志 | GTE CyberTrust 全局根                                        | 默认 Keytool -keyalg 值 |

## JDK 13

| 所属范围 | 新特性                                                       | 删除                                                         | 弃用                                             |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------ |
| 语言     | **switch表达式（预览版）**、**文本块（预览版）**             |                                                              |                                                  |
| 核心库   | FileSystems.newFileSystem(Path, Map<String, ?>) 方法、新的 java.nio.ByteBuffer Bulk get/put 方法传输字节而不考虑缓冲区位置、java.time 日本新纪元名令和、<br/>*重新实现旧的 Socket API* | 运行时跟踪方法、JDK 1.4 之前的 SocketImpl 实现               | 已弃用的 rmic 删除工具                           |
| JVM      | ZGC 取消提交未使用的内存、-XXSoftMaxHeapSize 标志、ZGC 最大堆大小增加到 16TB、动态 CDS 归档 | VM 选项 -XX+AggressiveOpts                                   | 不推荐使用的 Java 选项 -Xverifynone 和 -noverify |
| 工具     | 使用命名空间支持创建 DOM 和 SAX 工厂的新方法                 |                                                              |                                                  |
| javadoc  |                                                              | 从 javadoc 工具中删除旧功能                                  |                                                  |
| 国际化   | **Unicode 12.1**                                             |                                                              |                                                  |
| 客户端库 |                                                              | awt.toolkit 系统属性                                         | macOS 上已弃用且不受支持的 Swing Motif 外观      |
| 安全     | CRL 的可配置读取超时、用于显示 TLS 配置信息的新 keytool -showinfo -tls 命令、支持下一代 MS 加密 (CNG)、SunPKCS11 Provider 升级支持 PKCS#11 v2.40、支持 TLS 中的 X25519 和 X448、JSSE 中没有服务器端状态的会话恢复、允许限制 SASL 机制、规范 XML 1.1 URI 的新字符串常量、[xmldsig] 添加 KeyValueEC_TYPE、在 Windows 上添加了默认的本机 GSS-API 库、支持 Kerberos 跨领域引用 (RFC 6806) | SunJSSE 提供程序不再支持重复的 RSA 服务、T-Systems Deutsche Telekom 根 CA 2 证书、两个 DocuSign 根 CA 证书、两个 Comodo 根 CA 证书、内部 com.sun.net.ssl 包、从 SunJSSE Provider 中删除实验性 FIPS 140 兼容模式 | 不推荐使用的 javax.security.cert API             |

## JDK 14

| 所属范围 | 新特性                                                       | 删除                                                    | 弃用                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------------------------ |
| 语言     | **记录（Record）（预览版）**、<br/>***instanceof 的模式匹配（预览版）***、***switch 表达式***、***文本块（第二次预览）*** |                                                         |                                                              |
| 核心库   | 会计货币格式支持、明确 ReadableByteChannel.read() 规范及相关方法、<br/>*非易失性映射字节缓冲区*、*外部内存访问 API（孵化器）* | sun.nio.cs.map 系统属性                                 | 不推荐线程 suspend / resume                                  |
| JVM      | **Windows 和 macOS 上的 ZGC（实验性）**、Parallel GC 改进、G1 的 NUMA 感知内存分配、JFR 事件流、<br/>***有用的 NullPointerExceptions*** | **并发标记清除 (CMS) 垃圾收集器**                       | **弃用 ParallelScavenge + SerialOld GC 组合**、<br/>*弃用 Solaris 和 SPARC 端口* |
| 工具     | 允许默认调用可发现的 javac 插件、SAX ContentHandler 处理 XML 声明的新方法、<br/>*打包工具（孵化器）* | Pack200 工具和 API                                      |                                                              |
| 部署     |                                                              | netscape.javascript.JSObjectgetWindow 方法              |                                                              |
| 客户端库 |                                                              |                                                         | 不推荐使用 NSWindowStyleMaskTexturedBackground               |
| 安全     | 默认禁用 TLS、CertPath 和签名 JAR 中的弱命名曲线、Apache Santuario 库更新到版本 2.1.4 | 已弃用的 java.security.acl API、默认 keytool -keyalg 值 | 弃用了旧版椭圆曲线以进行删除、不推荐使用 OracleUcrypto JCE Provider |

## JDK 15

| 所属范围 | 新特性                                                       | 删除                                                         | 弃用                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 语言     | **隐藏类**、**文本块**、<br/>***密封类（预览版）***、***instanceof 的模式匹配（第二次预览）***、***记录（Record）（第二次预览）*** |                                                              |                                                              |
| 核心库   | 为 CharSequence 添加了 isEmpty 默认方法、对 SO_INCOMING_NAPI_ID 的支持、 **TreeMap 方法的特殊实现**、<br/>*重新实现旧的 DatagramSocket API*、*外部内存访问 API（第二个孵化器）* | 最终弃用的 Solaris 特定 SO_FLOW_SLA 套接字选项、RMI 静态存根编译器 (rmic)、**Nashorn JavaScript 引擎** | RMI 激活                                                     |
| JVM      | 为调试模式添加到 jhsdb 的新选项、<br/>***ZGC：可扩展的低延迟垃圾收集器（产品）***、***Shenandoah：低暂停时间垃圾收集器（产品）*** | 已过时 -XXUseAdaptiveGCBoundary、<br/>*删除 Solaris 和 SPARC 端口* | -XXForceNUMA 选项、禁用偏向锁定和不推荐使用的偏向锁定标志    |
| 工具     | 为 jstatd 添加了用于指定 RMI 连接器端口号的新选项、为 jcmd 添加了用于编写 gzipped 堆转储的新选项 |                                                              |                                                              |
| javadoc  |                                                              |                                                              |                                                              |
| 部署     |                                                              |                                                              | NSWindowStyleMaskTexturedBackground                          |
| svc      | 为远程 JMX 配置第三个端口的功能                              | 已弃用的常量 RMIConnectorServer.CREDENTIAL_TYPES             |                                                              |
| 国际化   | **Unicode 13.0**                                             |                                                              |                                                              |
| 安全     | 为 jarsigner 添加了撤销检查、如果使用了弱算法工具会发出警告、SunJCE Provider 支持基于 SHA-3 的 Hmac 算法、用于配置 TLS 签名方案的新系统属性、支持 certificate_authorities 扩展、支持 krb5.conf 中的规范化、支持跨域MSSFU、<br/>*爱德华兹曲线数字签名算法 (EdDSA)* | Comodo 根 CA 证书、DocuSign 根 CA 证书、已弃用的 SSLSession.getPeerCertificateChain() 方法实现、com.sun.net.ssl.internal.ssl.Provider 名称 | 默认禁用本机 SunEC 实现、为先前弃用的 ContentSigner API 添加了 forRemoval=true |

## JDK 16

| 所属范围 | 新特性                                                       | 删除                                                         | 弃用                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 语言     | **密封类（第二次预览）**、**记录（Record）**、**instanceof 的模式匹配** |                                                              |                                                              |
| 核心库   | 外部链接器 API（孵化器）、**默认情况下对 JDK 内部进行强封装**、外部内存访问 API（第三个孵化器）、**基于值的类的警告**、添加 InvocationHandler::invokeDefault 方法用于 Proxy 的默认方法支持、Unix 域套接字、java.time 格式添加了日时段支持、**添加 Stream.toList() 方法** |                                                              | **最终弃用的线程组stop、destroy、isDestroyed、setDaemon 和 isDaemon** |
| JVM      | 矢量 API（孵化器）、改进的编译命令标志、**ZGC 并发堆栈处理**、**在 G1 中同时取消提交内存**、默认启用新的 jdk.ObjectAllocationSample 事件、**弹性元空间**、<br/>*启用 C++14 语言功能*、*Alpine Linux 端口*、*Windows/AArch64 端口* | **去除实验特征 AOT 和 Graal JIT**、已弃用的跟踪标志已过时，必须用统一日志等效项替换 | 部分 Signal-Chaining API 已弃用                              |
| 工具     | 打包工具                                                     |                                                              |                                                              |
| javadoc  |                                                              |                                                              |                                                              |
| 部署     |                                                              |                                                              |                                                              |
| 基础设施 | *从 Mercurial 迁移到 Git*、*迁移到 GitHub*                   |                                                              |                                                              |
| 国际化   |                                                              |                                                              |                                                              |
| 客户端库 |                                                              | 删除 java.awt.PeerFixer                                      |                                                              |
| 安全     | 对 RSASSA-PSS 和 EdDSA 的签名 JAR 支持、 SUN \ SunRsaSign 和 SunEC 提供商支持基于 SHA-3 的签名算法、 jarsigner 保留 POSIX 文件权限和符号链接属性、在 keytool -printcert 和 -printcrl 命令中添加了 -trustcacerts 和 -keystore 选项、 SunPKCS11 Provider 支持 SHA-3 相关算法、改进证书链处理、 改进 TLS 应用层协议协商 (ALPN) 值的编码、EdDSA 签名算法的 TLS 支持 | 1024 位密钥的根证书、传统的椭圆曲线                          | 弃用了将 DN 表示为主体或字符串对象的 java.security.cert API  |

## JDK 17

| 所属范围 | 新特性                                                       | 删除                                                         | 弃用                                                     |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------------------------------------------------- |
| 语言     | **密封类**、**switch 模式匹配（预览版）**、<br/>***恢复始终严格的浮点语义*** |                                                              |                                                          |
| 核心库   | DatagramSocket 可直接用于加入多播组、在 macOS 上添加对 UserDefinedFileAttributeView 的支持、**增强的伪随机数生成器**、**外部函数和内存 API（孵化器）**、控制台字符集 API、**用于反序列化的 JDK Flight Recorder 事件**、**实现特定于上下文的反序列化过滤器**、本机字符编码名称的系统属性、添加 java.time.InstantSource、十六进制格式和解析实用程序、<br/>***强封装 JDK 内部***、*矢量 API（第二个孵化器）* | 强封装 JDK 内部相关的选项、sun.misc.Unsafe::defineAnonymousClass、RMI 激活 | 弃用 Socket 实现工厂机制                                 |
| JVM      | 理想图可视化器（IGV）的现代化、实验编译器黑洞支持、HotSpot JVM中新的类层次分析实现、macOS/AArch64 端口、统一日志支持异步日志刷新 | **实验性 AOT 和 JIT 编译器**                                 | 弃用 JVM TI 堆函数 1.0                                   |
| 工具     |                                                              |                                                              |                                                          |
| javadoc  | **错误消息中的源详细信息**、“New API”的新页面和改进的“Deprecated”页面、包摘要页面上的“相关包” |                                                              |                                                          |
| 部署     |                                                              |                                                              |                                                          |
| svc      |                                                              |                                                              |                                                          |
| 国际化   |                                                              |                                                              |                                                          |
| 客户端库 | 新的 macOS 渲染管道、 用于访问大图标的新 API                 |                                                              | 弃用 Applet API 以进行删除                               |
| 安全     | 支持在 Keytool -genkeypair 命令中指定签名者、SunJCE Provider 使用 AES 密码支持 KW 和 KWP 模式、新的 SunPKCS11 配置属性、如果 PKCS11 库支持，SunPKCS11 提供程序支持 ChaCha20-Poly1305 Cipher 和 ChaCha20 KeyGenerator、具有系统属性的可配置扩展、如果 default_tkt_enctypes 或 default_tgs_enctypes 不存在，则使用 allowed_enctypes | Telia 公司的 Sonera Class2 CA 证书                           | 弃用安全管理器以进行删除、在 Kerberos 中弃用 3DES 和 RC4 |

# JDK 9 ~ 17 各个版本的重要新特性

简单翻译整理了一下 Oracle 官方文档和 OpenJDK 的文档，个人挑出感觉和自己相关比较重要的新特性做个整合。遇到我不太熟悉的领域的内容的话，翻译可能不准确，对于这种地方，我尽量在括号里标注了英文原文或者直接保留英文原文。

可能有的重要的特性因为我自己用的少或者不了解（简单来说就是安全库、macOS以及一些底层实现等相关的都不太懂），没有被我放到这一章节；如果想看这些其他的新特性，可以看后面“各个版本的其他新特性（部分）”章节。删除的和弃用的特性也在后续章节中介绍。



## JDK 17

### JEP 409：密封类

**【规范】**

密封类（Sealed Class）已添加到 Java 语言中。密封的类和接口限制了哪些其他类或接口可以扩展或实现它们。

### JEP 406：switch 的模式匹配（预览版）

**【规范】**

通过对 switch 表达式和语句的模式匹配以及对模式语言的扩展来增强 Java 编程语言。将模式匹配扩展到 switch 允许针对多个模式测试表达式，每个模式都有特定的操作，因此可以简洁安全地表达复杂的面向数据的查询。

### JEP 382：新的 macOS 渲染管道

**【客户端库 / 2d】**

Swing API 用于渲染的 Java 2D API 现在可以使用适用于 macOS 的新 Apple Metal 加速渲染 API。

目前默认情况下禁用此功能，因此渲染仍使用 OpenGL API，Apple 已弃用这些 API，但仍可用并受支持。

要启用 Metal，应用程序应通过设置系统属性来指定其用途：

```sh
-Dsun.java2d.metal=true
```

使用 Metal 或 OpenGL 对应用程序是透明的，因为这是内部实现的差异，并且对 Java API 没有影响。Metal 管道需要 macOS 10.14.x 或更高版本。在早期版本上设置它的尝试将被忽略。

### JEP 356：增强的伪随机数生成器

**【核心库 / java.util】**

为伪随机数生成器 (pseudorandom number generator, PRNG) 提供新的接口类型和实现，包括可跳转 PRNG 和另一类可拆分 PRNG 算法 (LXM)。

### 理想图可视化器的现代化

**【HotSpot / 编译器】**

理想图可视化器（Ideal Graph Visualizer，IGV）是一种以可视化和交互方式探索 HotSpot VM C2 即时（JIT）编译器中使用的中间表示的工具，它已实现现代化。增强功能包括：

- 支持在最高 JDK 15 上运行 IGV（IGV 的底层 NetBeans 平台支持的最新版本）
- 更快、基于 Maven 的 IGV 构建系统
- 稳定块形成、组移除和节点跟踪
- 默认过滤器中更直观的着色（coloring）和节点分类
- 具有更自然默认行为的排名快速节点搜索

现代化的 IGV与早期 JDK 版本生成的图*部分*兼容。它支持图形加载和可视化等基本功能，但可能会影响节点聚类和着色等辅助功能。

### 错误消息中的源详细信息

**【工具 / javadoc】**

当 JavaDoc 在输入源文件中报告问题时，它会显示问题的源代码行，以及该行将包含指向具体位置的插入符号 `^`，其方式类似于编译器 ( `javac`) 诊断消息。

此外，现在将日志记录和其他“信息”消息写入标准错误流，将标准输出流用于命令行选项特别要求的输出，例如命令行帮助。

### “New API”的新页面和改进的“Deprecated”页面

**【工具 / javadoc】**

JavaDoc 现在可以生成一个总结 API 最近更改的页面。要包含的最新版本列表使用 `--since` 命令行选项指定。这些值用于查找 `@since` 要包含在新页面上的具有匹配标签的声明。`--since-label` 命令行选项提供在“新 API”页面的标题中使用的文本。

在总结弃用项目的页面上，您可以查看按弃用的版本分组的项目。

### JEP 412：外部函数和内存API（孵化器）

**【核心库】**

引入一个 API，Java 程序可以通过该 API 与 Java 运行时之外的代码和数据进行互操作。通过有效地调用外部函数（即 JVM 之外的代码）和安全地访问外部内存（即不受 JVM 管理的内存），API 使 Java 程序能够调用本机库并处理本机数据，而不会受 JNI 的脆弱性和危险的影响。

### 控制台字符集 API

**【核心库】**

`java.io.Console` 已更新以定义一个返回`Charset`控制台的新方法。返回的字符集可能与 `Charset.defaultCharset()` 方法返回的字符集不同。例如，它在 Windows (en-US) 上返回 `IBM437` 时 `Charset.defaultCharset()` 返回。

### 用于反序列化的 JDK Flight Recorder 事件

**【核心库 / java.io：序列化】**

现在可以使用 JDK Flight Recorder (JFR) 监控对象的反序列化。当启用 JFR 并且 JFR 配置包含反序列化事件时，每当运行的程序尝试反序列化对象时，JFR 都会发出事件。反序列化事件名为 `jdk.Deserialization`，默认情况下是禁用的。反序列化事件包含序列化过滤机制使用的信息。此外，如果启用了过滤器，JFR 事件会指示过滤器是接受还是拒绝对象的反序列化。

### JEP 415：实现特定于上下文的反序列化过滤器

**【核心库 / java.io：序列化】**

特定于上下文的反序列化过滤器 允许应用程序通过 JVM 范围的过滤器工厂配置特定于上下文和动态选择的反序列化过滤器，该过滤器工厂被调用来为每个单独的反序列化操作选择一个过滤器。

### 添加 java.time.InstantSource

**【核心库 / java.time】**

引入了一个新接口 `java.time.InstantSource`。这个接口是 `java.time.Clock` 的一个抽象，只关注当前时刻，不涉及到时区。

### 十六进制格式和解析实用程序

**【核心库 / java.util】**

`java.util.HexFormat` 为原始类型和字节数组提供与十六进制的转换。分隔符、前缀、后缀和大写或小写的选项由返回 HexFormat 实例的工厂方法提供。

### 实验编译器黑洞支持

**【HotSpot / 编译器】**

添加了对编译器黑洞（Compiler Blackholes）的实验性支持。这是为了避免在关键路径上的死代码消除，从而不会影响基准性能，对于低级基准测试很有用。当前支持以 CompileCommand 的形式实现，可以通过 `-XX:CompileCommand=blackhole,<method>` 使用，并计划最终将其升级为公共 API。

JMH（Java Microbenchmark Harness，Java 微基准测试工具套件） 在被命令或者可用时，已经能够自动检测和使用此工具。

### HotSpot JVM中新的类层次分析实现

**【HotSpot / 编译器】**

HotSpot JVM 中引入了新的类层次结构分析实现。它增强了对抽象和默认方法的处理，从而改进了 JIT 编译器做出的内联决策。新的实现取代了原来的实现，默认开启。

`-XX:+UnlockDiagnosticVMOptions -XX:-UseVtableBasedCHA` 为了帮助诊断与新实现相关的可能问题，可以通过指定命令行标志来打开原始实现。

在未来的版本中可能会删除原始实现。

### JEP 391：macOS/AArch64 端口

**【HotSpot / 编译器】**

macOS 11.0 现在支持 AArch64 架构。这个 JEP 在 JDK 中实现了对 macos-aarch64 平台的支持。添加的功能之一是支持 W^X（write xor execute, 写异或执行）内存。它仅对 macos-aarch64 启用，并且可以在某些时候扩展到其他平台。JDK 既可以在 Intel 机器上交叉编译，也可以在基于 Apple M1 的机器上编译。

### 统一日志支持异步日志刷新

**【HotSpot / 编译器】**

为了避免在使用统一日志的线程中出现不希望的延迟，用户现在可以请求统一日志系统以异步模式运行。这是通过传递命令行选项来完成的 `-Xlog:async`。在异步日志模式下，日志站点将所有日志消息排入缓冲区。独立线程负责将它们刷新到相应的输出。中间缓冲区是有界的。在缓冲区耗尽时，排队的消息将被丢弃。用户可以使用命令行选项控制中间缓冲区的大小 `-XX:AsyncLogBufferSize=<bytes>`。

### 包摘要页面上的“相关包”

**【工具 / javadoc】**

包的摘要页面现在包括列出任何“相关包”的部分。相关包的集合是根据通用命名约定启发式确定的，可能包括以下内容：

- “父”包（即包是子包的包）
- 同级包（即具有相同父包的其他包）
- 任何子包

相关的包不必都在同一个模块中。

### OpenJDK 文档中提到的特性

#### JEP 306：恢复始终严格的浮点语义

**【规格 / 语言】**

使浮点运算始终保持严格，而不是同时具有严格的浮点语义 ( `strictfp`) 和细微不同的默认浮点语义。这将恢复语言和 VM 的原始浮点语义，与 Java SE 1.2 中引入严格和默认浮点模式之前的语义相匹配。

#### JEP 403：强封装 JDK 内部

**【核心库】**

强烈封装 JDK 的所有内部元素，除了 关键的内部 API，例如 `sun.misc.Unsafe`。将不再可能通过单个命令行选项放松对内部元素的强封装，这在 JDK 9 到 JDK 16 中是可能的。

#### JEP 414：Vector API（第二个孵化器）

**【核心库】**

引入一个 API 来表达向量计算，该计算可以在运行时可靠地编译为支持的 CPU 架构上的最佳向量指令，从而实现优于等效标量计算的性能。



## JDK 16

### JEP 389：外部链接器 API（孵化器）

**【核心库】**

引入一个 API，该 API 提供对本机代码的静态类型纯 Java 访问。此 API 与 Foreign-Memory API (JEP 393) 一起，将大大简化绑定到本机库的其他容易出错的过程。

### JEP 396：默认情况下对 JDK 内部进行强封装

**【核心库】**

默认情况下强烈封装 JDK 的所有内部元素，除了关键的内部 API，例如`sun.misc.Unsafe`. 允许最终用户选择自 JDK 9 以来一直默认的宽松强封装。

通过此更改，启动器选项的默认值 `--illegal-access` 现在是 `deny` 而不是 `permit`. 因此，使用 JDK 的大多数内部类、方法或字段的现有代码将无法运行。这样的代码可以通过指定在 JDK 16 上运行 `--illegal-access=permit`。但是，该选项将在未来的版本中删除。

### JEP 393：外部内存访问（Foreign-Memory Access） API（第三个孵化器）

**【核心库】**

引入 API 以允许 Java 程序安全有效地访问 Java 堆之外的外部内存。

### JEP 390：基于值的类的警告

**【核心库】**

*标准库提供的基于值的类*的用户——尤其是原始包装类的用户——应该避免依赖类实例的标识。强烈建议程序员不要调用包装类构造函数，该函数现在已弃用以在未来将其删除。新 `javac` 警告不鼓励对基于值的类实例进行同步。也可以使用命令行选项激活有关同步的运行时警告 `-XX:DiagnoseSyncOnValueBasedClasses`。

### 添加 InvocationHandler::invokeDefault 方法用于 Proxy 的默认方法支持

**【核心库 / java.lang : reflect】**

`java.lang.reflect.InvocationHandler`接口中添加了一个新方法 `invokeDefault` 以允许调用代理接口中定义的默认方法。

### java.time 格式添加了每日时段(Day Period)支持

**【核心库 / java.time】**

新的格式化程序模式、字母“B”及其支持方法已添加到`java.time.format.DateTimeFormatter/DateTimeFormatterBuilder`类中。该模式和方法转换每日时段（在Unicode 联盟的 CLDR 中定义的`day periods`）。应用程序现在可以表示一天中的时段，例如“早上”或“晚上”，而不仅仅是上午/下午。以下示例演示了转换每日时段：

```
DateTimeFormatter.ofPattern("B").format(LocalTime.now()) 
```

此示例根据一天中的时间和区域设置生成每日时段文本。

### 添加 Stream.toList() 方法

**【核心库 / java.util.stream】**

`java.util.Stream` 接口中添加了一个新方法 `toList`。因此，实现 `Stream` 接口的类或扩展 `Stream` 接口的接口从其他地方静态导入 `toList` 方法会有潜在源不兼容性，例如`Collectors.toList`. 对此类方法的引用必须更改为使用限定名称而不是静态导入。

### JEP 338：矢量 API（孵化器）

**【HotSpot / 编译器】**

提供孵化器模块 `jdk.incubator.vector` 的初始迭代，以表达向量计算，这些计算在运行时可靠地编译为支持的 CPU 架构上的最佳向量硬件指令，从而实现优于等效标量计算的性能。

### 改进的编译命令标志

**【HotSpot / 编译器】**

CompileCommand 标志具有已用于子命令集合的选项类型。这些命令的有效性没有经过验证，因此拼写错误会导致命令被忽略。他们有以下形式：

```sh
-XX:CompileCommand=option,<method pattern>,<option name>,<value type>,<value> 
```

现在所有选项命令都作为普通命令以这种形式存在：

```sh
-XX:CompileCommand=<option name>,<method pattern>,<value> 
```

验证选项名称并推断类型。如果命令名称不存在，或者值与命令的类型不匹配，则会给出有用的错误消息。所有命令名称都不区分大小写。

选项命令的旧语法仍然可以使用。已添加验证选项名称、值类型和值是否一致。

所有可用选项都可以列出：

```sh
-XX:CompileCommand=help 
```

### JEP 376：ZGC 并发堆栈处理

**【HotSpot / gc】**

Z 垃圾收集器（Z Garbage Collector，ZGC）现在同时处理线程堆栈。这允许 ZGC 在并发阶段处理 JVM 中的所有根，而不是停止世界暂停。ZGC 暂停中完成的工作量现在变得恒定，通常不超过几百微秒。

### 在 G1 中同时取消提交内存

**【HotSpot / gc】**

此新功能始终启用并改变了 G1 将 Java 堆内存返回给操作系统的时间。G1 仍然在 GC 暂停期间做出 sizing 决定，但将耗时的工作交给与 Java 应用程序并行的线程。

### JEP 387：弹性元空间

**【HotSpot / 运行时】**

JEP 387 “弹性元空间”彻底检查了 VM 内部元空间和类空间的实现。更少的内存用于类的元数据。在涉及大量小粒度类加载器的场景中，节省效果最为明显。类卸载后，内存及时返回给操作系统。

添加了一个开关来微调元空间回收：`-XX:MetaspaceReclaimPolicy=(balanced|aggressive|none)`。 `balanced`，作为默认设置，使 VM 回收内存，同时保持最小的计算开销；`aggressive` 以稍微昂贵的簿记为代价适度提高回收率；`none` 完全关闭回收。

开关 `InitialBootClassLoaderMetaspaceSize` 和 `UseLargePagesInMetaspace` 已被弃用。

### JEP 397：密封类（第二次预览）

**【工具 / javac】**

密封（sealed）类和接口在 JDK 16 中再次预览，最初在 JDK 15 中添加到 Java 语言中。密封类和接口限制了哪些其他类或接口可以扩展或实现它们。

### JEP 395：记录

**【工具 / javac】**

记录（record）已添加到 Java 语言中。记录是 Java 语言中的一种新类。它们充当不可变数据的透明载体，其惯例代码比普通类少。

自从嵌套类首次被引入 Java 以来，除了由常量表达式初始化的静态 final 字段外，内部的嵌套类声明已被禁止声明静态成员。此限制适用于非静态成员类、本地类和匿名类。

JEP 384: Records (Second Preview) 添加了对本地接口、枚举类和记录类的支持，所有这些都是静态定义。这是一个广受欢迎的增强功能，允许将某些声明的范围缩小到本地上下文的编码样式。

虽然 JEP 384 允许静态本地类和接口，但它并没有放松对静态成员类和内部类接口的限制。内部类可以在其方法体之一内声明静态接口，但不能作为类成员。

作为自然的下一步，JEP 395 进一步放宽了嵌套限制，并允许在内部类中声明静态类、方法、字段等。

### JEP 394：instanceof 的模式匹配

**【工具 / javac】**

运算符的模式匹配 `instanceof` 已成为 JDK 16 中 Java 语言的最终和永久特性。模式匹配允许更简洁和安全地表达 Java 程序中的通用逻辑，即从对象中条件提取组件。

### JEP 392：打包工具

**【工具 / jpackage】**

提供 `jpackage `工具，用于打包自包含的 Java 应用程序。JEP 343 在 JDK 14 中将其 `jpackage tool` 作为孵化工具引入。它仍然是 JDK 15 中的孵化工具，以便有时间获得额外的反馈。它已在 JDK 16 中从孵化升级为生产就绪功能。由于这种转变，`jpackage` 模块的名称已从 `jdk.incubator.jpackage` 更改为`jdk.jpackage`。

### OpenJDK 文档中提到的特性

#### JEP 347：启用 C++14 语言功能

**【HotSpot / 其他】**

允许在 JDK C++ 源代码中使用 C++14 语言功能，并就哪些功能可以在 HotSpot 代码中使用提供具体指导。

#### JEP 357: 从 Mercurial 迁移到 Git

**【基础设施】**

将 OpenJDK 社区的源代码存储库从 Mercurial (hg) 迁移到 Git。

#### JEP 369：迁移到 GitHub

**【基础设施】**

在 GitHub 上托管 OpenJDK 社区的 Git 存储库。与 JEP 357（从 Mercurial 迁移到 Git）一致，这会将所有单存储库 OpenJDK 项目迁移到 GitHub，包括 JDK 功能版本（JDK feature releases）和版本 11 及更高版本的 JDK 更新版本（JDK update releases）。

#### JEP 386：Alpine Linux 端口

**【HotSpot】**

将 JDK 移植到 Alpine Linux，以及其他使用 musl 作为主要 C 库（primary C library）的在 x64 和 AArch64 架构上的 Linux 发行版。

#### JEP 388：Windows/AArch64 端口

**【HotSpot】**

将 JDK 移植到 Windows/AArch64。





## JDK 15

### 为 CharSequence 添加了 isEmpty 默认方法

**【核心库 / java.lang】**

`java.lang.CharSequence` 已在此版本中更新定义 `isEmpty` 默认方法来测试一个字符序列是否为空。代码中常见的实例是用来测试和过滤空 `String` 和其他 `CharSequence` ，并且 `CharSequence::isEmpty` 可以用作方法引用。实现 `java.lang.CharSequence` 的类和其他定义 `isEmpty` 方法的接口应该注意这个新增特性，因为它们可能需要修改以重写该 `isEmpty` 方法。

### 支持 Unicode 13.0

**【核心库 / java.lang】**

此版本将 Unicode 支持升级到 13.0，其中包括以下内容：

-  `java.lang.Character` 支持 13.0 级别的 Unicode 字符数据库，13.0 增加了 5,930 个字符，总共 143,859 个字符。这些新增内容包括 4 个新脚本（script），总共 154 个脚本，以及 55 个新的表情符号字符。
- 和 `java.text.Bidi` 类 `java.text.Normalizer` 分别支持 13.0 级别的 Unicode 标准附件 #9 和 #15。
-  `java.util.regex` 包支持基于 Unicode 标准附件 #29 的 13.0 级别的扩展字素集群（Extended Grapheme Clusters）。

### JEP 371 隐藏类

**【核心库 / java.lang.invoke】**

JEP 371 在 Java 15 中引入了隐藏类（hidden class）。隐藏类对既有代码有以下影响：

1. `Class::getName` 传统上返回二进制名称，但对于隐藏类，它返回包含 ASCII 正斜杠 ( `/`) 的字符串，因此不是二进制名称。假设返回的字符串是二进制名称的程序可能需要更新以处理隐藏类。也就是说，`Unsafe::defineAnonymousClass` 长期以来的实践是用来定义名称不是二进制名称的类，因此某些程序可能已经可以成功处理这些名称。

2. `Class::descriptorString` 和 `MethodType::descriptorString` 为隐藏类返回一个内容为 ASCII 点 (`.`) 的字符串，因此不是符合 JVMS 4.3 的类型描述符。假设返回的字符串是符合 JVMS 4.3 的类型描述符的程序可能需要更新以处理隐藏类。

3. `Class::getNestMembers` 更改为：在无法验证 `NestMembers` 属性中列出的任何成员的嵌套成员身份（nest membership）时，不引发异常。相反，`Class::getNestMembers` 返回嵌套主（nest host）和主（host's） `NestMembers` 属性中列出的成功解析并确定与此类具有相同嵌套主的成员（这意味着可能它返回的成员比 `NestMembers` 属性中所列出的成员更少）。预期在存在错误嵌套成员资格时收到 `LinkageError` 的现有代码可能会受到影响。

4. JVM 中的 nestmate 测试改为仅 `IllegalAccessError` 在 nest 成员资格无效时才抛出。

   一些历史理解是必要的：

   - 在 Java 8 中，每个访问控制失败都用 `IllegalAccessError`(IAE) 发出信号。此外，如果一次给定的访问检查使用 IAE 失败，那么每次使用 IAE 的相同检查都会失败。
   - 在 Java 11 中，嵌套伙伴 (nest mates, JEP 181) 的引入意味着访问控制失败可以通过 `IllegalAccessError` 或者 `LinkageError`（如果嵌套成员资格无效时）. 尽管如此，如果给定的访问检查因特定异常而失败，那么相同的检查将始终因相同的异常而失败。
   - 在 Java 15 中，`Lookup::defineHiddenClass` 的引入意味着当隐藏类被定义为查找类（lookup class）的嵌套对象时，必须快速地确定查找类的嵌套主。两者 `Lookup::defineHiddenClass` 都 `Class::getNestHost` 以比 Java 11 中的 JVM 更具弹性的方式确定类的嵌套主；也就是说，如果一个类声称的嵌套成员资格无效，API 只会将其视为自托管（self-hosted）类。为了与 API 保持一致，当类的嵌套成员资格无效时，JVM 不再抛出异常 `LinkageError`，而是将类视为自托管。这意味着 JVM 只从访问控制中抛出 IAE（因为自托管类不允许任何其他类访问其私有成员）。这是绝大多数用户代码所期望的行为。

5. JVM TI `GetClassSignature ` 为隐藏类返回一个内容为 ASCII 点 (`.`)的字符串。如果 JVM TI 代理假定从 `GetClassSignature` 返回的字符串是符合 JVMS 4.3 的类型描述符，则它们可能需要更新隐藏类。

### TreeMap 方法的特殊实现

**【核心库 / java.util : collections】**

TreeMap 类现在提供了 `putIfAbsent`、`computeIfAbsent`、`computeIfPresent`、`compute` 和 `merge` 方法的重写实现。新的实现提供了性能改进。但是，如果供 `compute-` 开头的方法或者 `merge` 方法调用的函数修改了映射，则可能会抛出 ConcurrentModificationException，因为禁止供这些方法的函数修改映射。如果发生 ConcurrentModificationException，则必须更改函数以避免修改映射，或者应重写周围的代码以将 `compute-` 开头的方法和 `merge` 方法的使用替换为常规 Map 方法，例如`get` 和 `put`。

### JEP 378 文本块

**【工具 / javac】**

文本块已添加到 Java 语言中。文本块是一个多行字符串文字，它避免了大多数转义序列的需要，以可预测的方式自动格式化字符串，并在需要时让开发人员控制格式。

### OpenJDK 文档中提到的特性

#### JEP 339：爱德华兹曲线数字签名算法 (EdDSA)

**【安全库 / javax.crypto】**

如 RFC 8032 所述，使用 Edwards-Curve 数字签名算法 (EdDSA) 实施加密签名。

#### JEP 360：密封类（预览版）

**【规范 / 语言】**

使用密封的（sealed）类和接口增强 Java 编程语言。密封的类和接口限制了哪些其他类或接口可以扩展或实现它们。

#### JEP 373：重新实现旧的 DatagramSocket API

**【核心库 / java.net】**

用易于维护和调试的更简单、更现代的实现替换 `java.net.DatagramSocket` 和 `java.net.MulticastSocket` API的底层实现。新的实现将很容易适应虚拟线程，目前正在 Project Loom 中进行探索。这是JEP 353 的后续，它已经重新实现了旧的 Socket API。

#### JEP 375：instanceof 的模式匹配（第二次预览）

**【规格 / 语言】**

通过*模式匹配*增强 Java 编程语言的 `instanceof` 运算符。模式匹配 使程序中可以更简洁和安全地表达从多个对象中按条件提取组件的通用逻辑。这是 JDK 15 中的预览语言功能。

#### JEP 377：ZGC：可扩展的低延迟垃圾收集器（产品）

**【HotSpot / gc】**

将 Z 垃圾收集器从实验功能更改为产品功能。

#### JEP 379：Shenandoah：低暂停时间垃圾收集器（产品）

**【HotSpot / gc】**

将 Shenandoah 垃圾收集器从实验功能更改为产品功能。

#### JEP 381：删除 Solaris 和 SPARC 端口

**【HotSpot】**

删除源代码并构建对 Solaris/SPARC、Solaris/x64 和 Linux/SPARC 端口的支持。这些端口在 JDK 14 中已被弃用以删除，并明确打算在未来的版本中删除它们。

#### JEP 383：外部内存访问 API（第二个孵化器）

**【核心库】**

引入 API 以允许 Java 程序安全有效地访问 Java 堆之外的外部内存。

#### JEP 384：记录（第二次预览）

**【规范 / 语言】**

使用记录增强 Java 编程语言，记录是充当不可变数据的透明载体的类。记录可以被认为是*名义元组*（*nominal tuples*）。



## JDK 14

### 会计货币格式支持

**【核心库】**

对于金额在某些语言环境中以括号格式格式化的具有会计风格的货币格式实例，可以通过调用带有 “u-cf-account” Unicode 语言环境扩展的 `NumberFormat.getCurrencyInstance(Locale)` 来获得。例如 `Locale.US`，它将格式化为 “`($3.27)`” 而不是 “`-$3.27`”。

### JEP 359 记录（预览版）

**【核心库 / java.lang】**

在 JDK 14 中，Records (JEP 359) 预览功能添加了一个新类`java.lang.Record`。该 `java.lang` 包是按需隐式导入的，即 `import java.lang.*`。如果现有源文件中的代码按需导入某个其他包，例如，`import com.myapp.*;`，并且该包声明了一个名为 `Record` 的类型，则现有源文件中引用该类型的代码将不会在不更改的情况下编译。要编译代码，请使用单一类型导入来导入其他包的 `Record` 类型，例如 `import com.myapp.Record;`。

### 明确 ReadableByteChannel.read() 规范及相关方法

**【核心库 / java.nio】**

`DatagramChannel.receive()`、`FileChannel.read(ByteBuffer,long)`、`ReadableByteChannel.read()` 和 `ScatteringByteChannel.read()` 方法的规范（specification）已在此版本中更新，以指定：如果（任何）缓冲区参数是只读的，则抛出一个 `IllegalArgumentException` 。此更改仅调整规范以匹配现有的长期行为。

### Windows 上的 JEP 365 ZGC

**【HotSpot / gc】**

Z 垃圾收集器 (ZGC) 现在可作为 Windows 上的实验性功能使用。要启用它，请使用 JVM 标志 `-XX:+UnlockExperimentalVMOptions -XX:+UseZGC`。

### macOS 上的 JEP 364 ZGC

**【HotSpot / gc】**

Z 垃圾收集器 (ZGC) 现在可作为 macOS 上的实验性功能使用。要启用它，请使用 JVM 标志 `-XX:+UnlockExperimentalVMOptions -XX:+UseZGC`。

### Parallel GC 改进

**【HotSpot / gc】**

Parallel GC 采用了与其他收集器相同的任务管理机制来调度并行任务。这可能会导致显着的性能改进。由于此更改，以下产品标志已过时：`-XX:BindGCTaskThreadsToCPUs`、`-XX:UseGCTaskAffinity` 和 `-XX:GCTaskTimeStampEntries`。

### G1 的 JEP 345 NUMA 感知内存分配

**【HotSpot / gc】**

G1 垃圾收集器现在尝试跨垃圾收集在年轻代中的同一 NUMA 节点上分配和保留对象。这类似于 Parallel GC NUMA 感知。

G1 尝试使用严格的交错将 Humongous 和 Old 区域均匀分布在所有可用的 NUMA 节点上。从年轻代复制到老年代的对象的放置是随机的。

这些新的 NUMA-Aware 内存分配启发式是通过使用 `-XX:+UseNUMA` 命令行选项自动启用的。

### JEP 349 JFR 事件流

**【HotSpot / jfr】**

JDK Flight Recorder (JFR) 现在支持对 Java 应用程序的持续监控，方法是允许使用位于 jdk.jfr.consumer 包中的新 API 动态使用事件。使用 JFR 时始终启用该功能，这意味着直到最后一秒的记录数据可用于进程内和进程外消耗。

### OpenJDK 文档中提到的特性

#### JEP 305：instanceof 的模式匹配（预览版）

**【规范 / 语言】**

通过 *模式匹配* 增强 Java 编程语言的 `instanceof` 运算符。模式匹配 使程序中可以更简洁和安全地表达从多个对象中按条件提取组件的通用逻辑。这是 JDK 14 中的预览语言功能。

#### JEP 343：打包工具（孵化器）

**【工具 / jpackage】**

创建用于打包自包含（self-contained）的 Java 应用程序的工具。

#### JEP 352：非易失性映射字节缓冲区(Non-Volatile Mapped Byte Buffers)

**【核心库 / java.nio】**

添加新的 JDK 特定文件映射模式，以便 `FileChannel` API 可用于创建 `MappedByteBuffer` 引用非易失性内存的实例。

#### JEP 358：有用的 NullPointerExceptions

**【HotSpot / 运行时】**

通过精确描述哪个变量是 `null` 来提高 JVM 生成的 `NullPointerException` 可用性 。

#### JEP 361：switch 表达式

**【规格 / 语言】**

扩展 `switch`，使它可以使用语句或表达式，并且两种形式都可以使用传统 `case ... :` 标签（有贯穿（fall through））或新 `case ... ->` 标签（没有贯穿），还有一个新的语句用于从一个 `switch` 中产生一个值表达（yielding a value）。这些更改将简化日常编码，并为在 `switch` 引入模式匹配做准备。这是 JDK 12 和 JDK 13 中的预览语言功能。

#### JEP 362：弃用 Solaris 和 SPARC 端口

**【HotSpot】**

弃用 Solaris/SPARC、Solaris/x64 和 Linux/SPARC 端口，以便在未来的版本中删除它们。

#### JEP 368：文本块（第二次预览）

**【规范 / 语言】**

将*文本块* 添加到 Java 语言。文本块是一个多行字符串，它避免了大多数转义序列的需要，以可预测的方式自动格式化字符串，并在需要时让开发人员控制格式。这是 JDK 14 中的预览语言功能。

#### JEP 370：外部内存访问（Foreign-Memory Access） API（孵化器）

**【核心库】**

引入 API 以允许 Java 程序安全有效地访问 Java 堆之外的外部内存。



## JDK 13

### 添加 FileSystems.newFileSystem(Path, Map<String, ?>) 方法

**【核心库 / java.nio】**

添加了三种新方法，`java.nio.file.FileSystems` 以便更轻松地使用将文件内容视为文件系统的文件系统提供程序。

- `newFileSystem(Path)`
- `newFileSystem(Path, Map<String, ?>)`
- `newFileSystem(Path, Map<String, ?>, ClassLoader)`

添加 `newFileSystem(Path, Map<String, ?>)` 方法会对一直使用现有双参数 `newFileSystem(Path, ClassLoader)` 方法并将类加载器指定为 `null` 的代码造成源码（但不是二进制）兼容性问题。例如，由于引用不明确，无法编译以下代码`newFileSystem`：

```java
FileSystem fs = FileSystems.newFileSystem(path, null);
```

为了避免不明确的引用，需要修改此代码以将第二个参数转换为`java.lang.ClassLoader`.

### 新的 java.nio.ByteBuffer Bulk get/put 方法传输字节而不考虑缓冲区位置

**【核心库 / java.nio】**

`java.nio.ByteBuffer` 现在，其他缓冲区类型 `java.nio` 定义了绝对批量 `get` 和 `put` 方法来传输连续的字节序列，而不考虑或影响缓冲区位置。

### 日本新年号名令和

**【核心库 / java.time】**

代表新令和年号（era）的实例已添加到此更新中。与其他年号不同，这个年号没有公共字段。可以通过调用 `JapaneseEra.of(3)` 或 `JapaneseEra.valueOf("Reiwa")` 获取。JDK 13 及更高版本将有一个新的公共字段来代表这个年号。

从 2019 年 5 月 1 日开始的日本年号的占位符名称 “`NewEra`” 已替换为新的官方名称。依赖占位符名称来获取新年号单例（`JapaneseEra.valueOf("NewEra")`）的应用程序将不再工作。

### 支持 Unicode 12.1

**【核心库 / java.util : i18n】**

此版本将 Unicode 支持升级到 12.1，其中包括以下内容：

- `java.lang.Character` 支持 12.1 级别的 Unicode 字符库，其中 12.0 从 11.0 开始增加了 554 个字符，总共 137,928 个字符。这些新增内容包括 4 个新脚本（script），总共 150 个脚本，以及 61 个新的表情符号字符。从 12.0 开始，12.1 只添加了一个字符 ,`U+32FF SQUARE ERA NAME REIWA`。
- `java.text.Bidi` 和 `java.text.Normalizer` 类分别支持 12.0 级别的 Unicode 标准附件 #9 和 #15。
- `java.util.regex` 包支持基于 12.0 级别的 Unicode 标准附件 #29 的扩展字素集群

### JEP 351 ZGC 取消提交未使用的内存

**【HotSpot / gc】**

ZGC 得到了增强，可以将未使用的堆内存返回给操作系统。这对于关注内存占用的应用程序和环境很有用。

此功能默认启用，但可以使用 `-XX:-ZUncommit` 显式禁用。此外，如果堆大小会缩小到最小堆大小 ( `-Xms`) 以下的话，内存不会被取消提交。这意味着如果最小堆大小 (`-Xms`) 配置为等于最大堆大小 (`-Xmx`)，则此功能将被隐式禁用。

可以使用 `-XX:ZUncommitDelay=<seconds>`（默认为 300 秒）配置取消提交延迟。此延迟指定内存在有资格取消提交之前应该未使用多长时间。

### 添加 -XXSoftMaxHeapSize 标志

**【HotSpot / gc】**

添加了可管理（manageable）的命令行标志`-XX:SoftMaxHeapSize=<bytes>`。目前，它仅在启用 Z 垃圾收集器时有效（`-XX:+UseZGC`）。

设置后，GC 将努力不使堆增长超过指定大小，除非 GC 决定有必要这样做以避免 OutOfMemoryError。不允许将软最大堆大小设置为大于最大堆大小 ( `-Xmx`) 的值。如果未在命令行上设置，则默认为等于最大堆大小的值。

作为可管理的（`manageable`），它的值可以在运行时调整。例如，可以使用 `jcmd VM.set_flag SoftMaxHeapSize <bytes>` 或通过 HotSpot MXBean 调整其值。

设置此标志在许多情况下很有用，例如：

- 在关注资源使用的环境中，您可能希望降低堆占用空间，同时保留处理临时增加的堆空间需求的能力。
- 在使用并发 GC（例如 ZGC）时，您可能希望安全地使用它并提高您对不会因为分配率的意外增加而陷入分配停顿的信心。设置软最大堆大小鼓励 GC 保持较小的堆，这意味着 GC 将比其他方式更积极地收集垃圾，使其更能适应应用程序分配率的突然增加。

### ZGC 最大堆大小增加到 16TB

**【HotSpot / gc】**

ZGC 支持的最大堆大小从 4TB 增加到 16TB。

### JEP 350 动态 CDS 归档

**【HotSpot / 运行时】**

JEP 350 扩展了应用程序类数据共享（application class-data sharing，AppCDS）以允许在 Java 应用程序退出时进行动态类归档（dynamic archiving of classes）。通过消除用户为每个应用程序创建类列表而进行试运行的必要性，它还提高了 AppCDS 的可用性。`-Xshare:dump` 选项启用的现有静态归档（static archiving）使用类列表继续按原样工作。

动态生成的存档是在与正在运行的 JDK 映像打包的默认系统存档之上创建的。为每个应用程序生成一个单独的顶层存档文件。用户可以指定动态存档名称的文件名作为 `-XX:ArchiveClassesAtExit` 选项的参数。例如，以下命令创建 `hello.jsa`：

```
% bin/java -XX:ArchiveClassesAtExit=hello.jsa -cp hello.jar Hello
```

要使用此动态存档运行相同的应用程序：

```
% bin/java -XX:SharedArchiveFile=hello.jsa -cp hello.jar Hello
```

用户还可以在选项 `-XX:SharedArchiveFile` 中指定基本存档和动态存档，例如：

```
-XX:SharedArchiveFile=<base archive>:<dynamic archive><br>
```

### JEP 354 switch 表达式（预览版）

**【工具 / javac】**

扩展 `switch` 以使它可以用作语句或表达式，并且两种形式都可以使用传统 `case ... :` 标签（有贯穿（fall through））或新 `case ... ->` 标签（没贯穿），还有一个新的语句用于从一个 `switch` 中产生一个值表达（yielding a value）。这些更改将简化日常编码，并为在 `switch` 中使用模式匹配做准备。这是 JDK 13 中的预览语言功能。

### JEP 355 文本块（预览版）

**【工具 / javac】**

将文本块添加到 Java 语言。文本块是一个多行字符串文字，它避免了大多数转义序列的需要，以可预测的方式自动格式化字符串，并在需要时让开发人员控制格式。这是 JDK 13 中的预览语言功能。

### OpenJDK 文档中提到的特性

#### JEP 353：重新实现旧的 Socket API

**【核心库 / java.net】**

`java.net.Socket` 和 `java.net.ServerSocket` API使用的底层实现将替换为更简单、更现代且易于维护和调试的实现。新的实现将很容易适应用户模式线程，也就是纤程，目前正在 Project Loom 中探索。



## JDK 12

### 对 Unicode 11 的支持

**【核心库 / java.lang】**

JDK 12 版本包括对 Unicode 11.0.0 的支持。在支持 Unicode 10.0.0 的 JDK 11 发布之后，Unicode 11.0.0 引入了以下新功能，这些新功能现在包含在 JDK 12 中：

- 684个新字符（character）
- 11个新块（block）
- 7个新脚本。

684 个新字符，其中包括以下重要内容：

- 66 个表情符号（emoji character）
- Copyleft 符号（symbol）
- 评级系统的半星
- 额外的占星术符号
- 象棋中国象棋符号

7个新脚本：

- 哈尼菲罗兴亚（Hanifi Rohingya）
- 老粟特（Old Sogdian）
- 粟特（Sogdian）
- 多格拉（Dogra）
- 贡贾拉贡迪（Gunjala Gondi）
- 望加锡（Makasar）
- 美非德林（Medefaidrin）

11 个新块，其中包括 7 个用于上面列出的新脚本的块和 4 个用于以下现有脚本的块：

- 格鲁吉亚语扩展
- 玛雅数字
- 印度语 Siyaq 数字
- 国际象棋符号

### JEP 334 JVM 常量 API

**【核心库 / java.lang.Invoke】**

新包 `java.lang.invoke.constant` 引入了一个 API 来模拟类文件和运行时工件的名义描述，特别是可从常量池加载的常量。它通过定义一系列基于值的符号引用 (JVMS 5.1) 类型来实现这一点，能够描述每种可加载常量。符号引用以纯名词形式描述可加载常量，与类加载或可访问性上下文分开。一些类可以充当它们自己的符号引用（例如，`String`）；对于可链接常量，添加了一系列符号引用类型（`ClassDesc`、`MethodTypeDesc`、`MethodHandleDesc` 和 `DynamicConstantDesc`），其中包含用于描述这些常量的名词性信息（nominal information）。

### 对紧凑数字格式支持

**【核心库 / java.text】**

`NumberFormat` 的支持增加了对紧凑形式数字格式的支持。紧凑数字格式是指以短的或人类可读的形式表示数字。例如，在 en_US 语言环境中，1000 可以格式化为“1K”，1000000 可以格式化为“1M”，具体取决于 `NumberFormat.Style`. 紧凑数字格式由 LDML 的紧凑数字格式定义。要获取实例，请使用 `NumberFormat` 为紧凑数字格式提供的工厂方法之一。例如：

```java
NumberFormat fmt = NumberFormat.getCompactNumberInstance(Locale.US, NumberFormat.Style.SHORT);
String result = fmt.format(1000);
```

上面的示例结果为“1K”。

### 日文新时代的方形字符支持

**【核心库 / java.util : i18n】**

Unicode 联盟保留代码点 U+32FF 来表示从 2019 年 5 月开始的新年号的日文方形字符。`Character` 类中的相关方法返回与现有的日本年号字符相同的属性（例如，“Meizi”的 U+337E）。

### ZGC 并发类卸载

**【HotSpot / gc】**

Z 垃圾收集器现在支持类卸载。通过卸载未使用的类，可以释放与这些类相关的数据结构，从而降低应用程序的整体占用空间。ZGC 中的类卸载是并发发生的，不会停止 Java 应用程序线程的执行，因此对 GC 暂停时间的影响为零。此功能默认启用，但可以使用命令行选项禁用`-XX:-ClassUnloading`。

### 在备用内存设备上分配老一代 Java 堆

**【HotSpot / gc】**

G1 和并行 GC 中的这个实验性功能允许他们在备用内存设备（如 NV-DIMM 内存）上分配老一代 Java 堆。

当今的操作系统通过文件系统公开 NV-DIMM 内存设备。例如 NTFS DAX 模式和 ext4 DAX 模式。这些文件系统中的内存映射文件绕过文件缓存并提供虚拟内存到设备物理内存的直接映射。使用标志 `-XX:AllocateOldGenAt=<path>` 指定 NV-DIMM 文件系统的路径会启用此功能。没有其他额外的标志来启用此功能。

启用后，新生代对象仅放置在 DRAM 中，而老年代对象始终分配在 NV-DIMM 中。在任何给定点，收集器都保证 DRAM 和 NV-DIMM 内存中提交的总内存始终小于 `-Xmx` 指定的堆大小。

当前实现在 NV-DIMM 文件系统中预先分配完整的 Java 堆大小，以避免动态生成大小的问题。用户需要确保 NV-DIMM 文件系统上有足够的可用空间。

启用后，VM 还会根据可用 DRAM 限制年轻代的最大大小，但建议用户明确设置年轻代的最大大小。

例如，如果 VM `-Xmx756g` 在具有 32GB DRAM 和 1024GB NV-DIMM 内存的系统上运行，则收集器将根据以下计算限制年轻代的大小：

1. `-XX:MaxNewSize` 或 `-Xmn` 没有被指定：最大年轻代大小设置为可用内存的 80% (25.6GB)。
2. `-XX:MaxNewSize` 或 `-Xmn` 被指定：最大年轻代大小上限为可用内存的 80% (25.6GB)，无论指定多少。
3. 用户可以使用 `-XX:MaxRAM` 让 VM 知道有多少 DRAM 可供使用。如果指定，最大年轻代大小设置为 MaxRAM 中值的 80%。
4. 用户可以使用 `-XX:MaxRAMPercentage` 指定年轻代使用的 DRAM 百分比（而不是默认的 80%）。

使用 logging 选项启用日志记录 `gc+ergo=info` 将在启动时打印最大的年轻代大小。

### JEP 325 Switch 表达式（预览）

**【工具 / javac】**

Java 语言增强了 `switch` 语句，使其既可以用作语句，也可以用作表达式。用作 `switch` 表达式通常会使代码更简洁易读。语句和表达式形式都可以使用传统`case ... :`标签（有贯穿（fall through））或简化`case ... ->`标签（没有贯穿）。此外，两种形式都可以在一种情况下打开多个常量。这些增强功能`switch`是预览语言功能

### OpenJDK 文档中提到的特性

#### JEP 189：Shenandoah：一种低暂停时间的垃圾收集器（实验性）

**【HotSpot / gc】**

添加一个名为 Shenandoah 的新垃圾收集 (GC) 算法，该算法通过与正在运行的 Java 线程同时进行以疏散工作来减少 GC 暂停时间。Shenandoah 的暂停时间与堆大小无关，这意味着无论您的堆是 200 MB 还是 200 GB，您都将拥有相同的一致暂停时间。

#### JEP 230：微基准套件

**【性能】**

在 JDK 源代码中添加一套基本的微基准测试，让开发人员可以轻松运行现有的微基准测试并创建新的微基准测试。

#### JEP 340：一个 AArch64 端口，而不是两个

**【HotSpot】**

删除所有与 `arm64` 端口相关的源，同时保留 32 位 ARM 端口和 64 位 `aarch64` 端口。

#### JEP 341：默认 CDS 档案

**【HotSpot / 运行时】**

增强 JDK 构建过程以在 64 位平台上使用默认类列表生成类数据共享 (CDS) 存档。

#### JEP 344：G1 的可中止混合收集（Abortable Mixed Collections）

**【HotSpot / gc】**

如果 G1 混合收集（mixed collections）可能超过暂停目标，则使它们可中止。

#### JEP 346：立即从 G1 返回未使用的已提交内存

**【HotSpot / gc】**

增强 G1 垃圾收集器在空闲时自动将 Java 堆内存返回给操作系统。



## JDK 11

### JEP 327 Unicode 10

**【核心库 / java.lang】**

升级现有平台 API 以支持 Unicode 标准 10.0 版（JEP 327：Unicode 10）。

JDK 11 版本包括对 Unicode 10.0.0 的支持。自支持 Unicode 8.0.0 的 JDK 10 发布以来，JDK 11 结合了 Unicode 9.0.0 和 10.0.0 版本，包括：

- 16,018 个新字符（character）
- 18个新块（block）
- 10个新脚本（script）

16,018 个新字符包括以下重要内容：

- 新 4K 电视标准的 19 个符号
- 比特币标志
- 128 个表情符号

10 个新脚本：

- 阿德拉姆（Adlam）
- 拜克苏基（Bhaiksuki）
- 马尔肯（Marchen）
- 纽瓦（Newa）
- 奥沙（Osage）
- 西夏（Tangut）
- 马萨兰·贡迪（Masaram Gondi）
- 女书（Nushu）
- 索永博（Soyombo）
- 扎纳巴扎尔广场（Zanabazar Square）

18 个新块，其中包括 10 个用于上面列出的新脚本的块和 8 个用于以下现有脚本的块：

- 西里尔文扩展-C
- 蒙古语补充
- 表意符号和标点符号
- 西夏组件
- 格拉哥里补充剂
- 叙利亚语补充
- 假名扩展-A
- 中日韩扩展 F

### JEP 321 HTTP 客户端（标准）

**【核心库 / java.net】**

通过 JEP 110 对 JDK 9 中引入的孵化 HTTP 客户端 API 进行标准化，并在 JDK 10 ( JEP 321) 中进行了更新。

HTTP 客户端已在 Java 11 中标准化。作为这项工作的一部分，位于 `jdk.incubator.http` 包中的先前孵化的 API 已被删除。需要更新使用`jdk.incubator.http` 包中的类型的代码，改为从标准包名 `java.net.http` 中导入 HTTP 类型。

### 新的 Collection.toArray(IntFunction) 默认方法

**【核心库 / java.util : collections】**

`java.util.Collection` 接口中添加了一个新的默认方法 `toArray(IntFunction)` 。 此方法允许将集合的元素传输到新创建的所需运行时类型的数组。新方法是现有`toArray(T[])`方法的重载，它将数组实例作为参数。添加重载方法会造成轻微的源码不兼容性。以前，表单的代码 `coll.toArray(null)` 总是会解析为仅有的 `toArray` 方法。使用新的重载方法，此代码现在是模棱两可的，将导致编译时错误。（这只是源码不兼容。现有的二进制文件不受影响。）模棱两可的代码应更改为 `null` 强制转换为所需的数组类型，例如，`toArray((Object[])null)` 或一些其他数组类型。请注意，传递 `null` 给 `toArray` 方法被指定为抛出 `NullPointerException`。

### 编译器线程的延迟分配

**【HotSpot / 编译器】**

添加了一个新的命令行标志 `-XX:+UseDynamicNumberOfCompilerThreads` 来动态控制编译器线程。在默认启用的分层编译模式下，VM 在具有许多 CPU 的系统上启动大量编译器线程，而不管可用内存和编译请求的数量如何。因为线程即使在空闲时也会消耗内存（几乎所有时间），这会导致资源使用效率低下。

为了解决这个问题，实现已更改为在启动期间仅启动每种类型的一个编译器线程，并动态处理更多线程的启动和关闭。它由一个新的命令行标志控制，默认情况下启用：

```
-XX:+UseDynamicNumberOfCompilerThreads
```

### JEP 333 ZGC 可扩展的低延迟垃圾收集器（实验性）

**【HotSpot / gc】**

Z 垃圾收集器，也称为 ZGC，是一种可扩展的低延迟垃圾收集器 ( JEP 333 )。它旨在满足以下目标：

- 暂停时间不超过 10 毫秒
- 暂停时间不会随着堆或 live-set 的大小而增加
- 处理大小从几百兆字节到数 TB 不等的堆

ZGC 的核心是一个并发垃圾收集器，这意味着所有繁重的工作（标记、压缩、引用处理、字符串表清理等）都是在 Java 线程继续执行的同时完成的。这极大地限制了垃圾收集对应用程序响应时间的负面影响。

ZGC 作为一个*实验特性* 被包含进来。因此，要启用它，`-XX:+UnlockExperimentalVMOptions` 选项需要与 `-XX:+UseZGC` 选项结合使用。

ZGC的这个实验版本有以下限制：

- 它仅在 Linux/x64 上可用。
- 不支持使用压缩 oops 和/或压缩类点。默认情况下禁用 `-XX:+UseCompressedOops` 和选项。`-XX:+UseCompressedClassPointers` 启用它们将无效。
- 不支持类卸载。默认情况下禁用 `-XX:+ClassUnloading` 和 `-XX:+ClassUnloadingWithConcurrentMark` 选项。启用它们将无效。
- 不支持将 ZGC 与 Graal 结合使用。

### JEP 318 Epsilon，无操作垃圾收集器

**【HotSpot / gc】**

Epsilon GC 是新的实验性无操作垃圾收集器。Epsilon GC 只处理内存分配，并没有实现任何内存回收机制。它对于性能测试很有用，可以对比其他 GC 的成本/收益。它可用于在测试中方便地断言内存占用和内存压力。在极端情况下，它可能对生命周期很短的作业很有用，其中内存回收将在 JVM 终止时发生，或者在低垃圾应用程序中获得最后一次延迟的改进。

### JEP 331 低开销堆分析

**【HotSpot / jvmti】**

提供一种对 Java 堆分配进行采样的低开销方式，可通过 JVMTI ( JEP 331 ) 访问。

它旨在满足以下目标：

- 默认情况下持续启用的低开销
- 可通过定义明确的编程接口 (JVMTI) 访问
- 可以对所有分配进行采样（即，不限于在一个特定堆区域中或以一种特定方式分配的分配）
- 可以以独立于实现的方式定义（即不依赖任何特定的 GC 算法或 VM 实现）
- 可以提供关于活的和死的 Java 对象的信息

### JEP 181 基于嵌套的访问控制

**【HotSpot / 运行时】**

引入了嵌套，一种访问控制上下文，它与 Java 编程语言中现有的嵌套类型概念保持一致（JEP-181：基于嵌套的访问控制）。

在 Java SE 11 中，Java 虚拟机支持将类和接口安排到新的访问控制上下文中，称为*嵌套*。嵌套允许逻辑上属于同一代码实体但编译为不同 `class` 文件的类和接口访问彼此的 `private` 成员，而无需编译器插入可访问性扩展桥接方法。嵌套是 Java SE 平台的一种低级机制；Java 编程语言的访问控制规则没有变化。`javac` 编译器已更新为在编译 Java 源代码中的嵌套类和接口时使用嵌套，方法是生成新的 `class` 将顶级类（或接口）及其所有嵌套类和接口放在同一个嵌套中的文件属性。Java 虚拟机已更新为在检查 `private` 构造函数、方法或字段的可访问性时使用这些属性，包括通过核心反射和 `java.lang.invoke.MethodHandles.Lookup` API。嵌套中的成员身份通过 `java.lang.Class` 的新方法 `getNestHost` 和 `getNestMembers` 方法暴露。

由于嵌套成员资格记录在 `class` 顶级类或接口（*嵌套主机*）的文件中，因此该 `class` 文件必须在运行时存在以允许执行访问控制检查。这通常不是问题，因为通常直接使用顶级类或接口。在某些代码中，顶级类或接口仅充当嵌套类或接口的持有者，并且在其他情况下未被使用，打包工具可能已经`class`从库或应用程序的分发中删除了该文件。`private` 使用基于嵌套的访问控制，如果任何嵌套的类或接口需要访问彼此的成员，则不再可能省略顶级类或接口——`NoClassDefFoundError` 或 `ClassNotFoundException` 将被抛出。

### JEP 323：Lambda 参数的局部变量语法

**【工具 / javac】**

现在可以在声明 lambda 表达式的形式参数时使用保留的类型关键字 `var` 了( JEP 323 )。这建立在 Java SE 10 中 `var ` 声明局部变量时使用的能力之上。

使用 `var` 来修饰 lambda 表达式的形式参数，会使参数的类型使用与既不存在 `var` 也不存在显式类型时相同的规则进行推断。自 Java SE 8 以来，Lambda 表达式允许在没有显式类型的情况下声明其形式参数。

如果 `var` 用于 lambda 表达式的任何形式参数，则它必须用于该 lambda 表达式的所有形式参数。

### JEP 330 启动单文件源代码程序

**【工具 / 启动器】**

增强 java 启动器以运行作为单个 Java 源代码文件提供的程序，包括通过“shebang”文件和相关技术在脚本中使用。

### OpenJDK 文档中提到的特性

#### JEP 309：动态类文件常量

**【HotSpot / 运行时】**

扩展 Java 类文件格式以支持新的常量池形式 `CONSTANT_Dynamic`。加载 `CONSTANT_Dynamic` 将委托创建到引导方法，就像链接 `invokedynamic` 调用站点委托链接到引导方法一样。

#### JEP 315：改进 Aarch64 内在函数

**【HotSpot / 编译器】**

改进现有的字符串和数组内在函数，并在 AArch64 处理器上为 `java.lang.Math ` 的 sin、cos 和 log 函数实现新的内在函数。

#### JEP 328：飞行记录仪（Flight Recorder）

**【HotSpot / jfr】**

为 Java 应用程序和 HotSpot JVM 故障排除提供低开销数据收集框架。



## JDK 10

### Optional.orElseThrow() 方法

**【核心库 / java.util】**

`Optional` 类中添加了一个新方法 `orElseThrow`。它是现有方法 `get` 的同义词，且现在是首选替代方法。

### 用于创建不可修改集合的 API

**【核心库 / java.util : collections】**

添加了几个新的 API，以方便创建不可修改的集合。`List.copyOf`、`Set.copyOf` 和 `Map.copyOf` 方法从现有实例创建新集合实例。新方法`toUnmodifiableList`、`toUnmodifiableSet` 和 `toUnmodifiableMap` 已添加到 Stream 包中的类 `Collectors` 中。这些允许将 Stream 的元素收集到不可修改的集合中。

### G1 的 JEP 307 并行 Full GC

**【HotSpot / gc】**

通过使 full GC 并行来改善 G1 最坏情况的延迟。G1 垃圾收集器旨在避免完全收集，但是当并发收集不能足够快地回收内存时，将发生回退 full GC。G1 的 full GC 的旧实现使用单线程标记-清除-整理（mark-sweep-compact）算法。在 JEP 307 中，full GC 已被并行化，现在使用与年轻和混合收集相同数量的并行工作线程。

### 增强 for 循环的字节码生成

**【工具 / javac】**

字节码生成已针对增强的 for 循环进行了改进，为它们提供了翻译方法的改进。例如：

```java
List<String> data = new ArrayList<>(); for (String b : data);
```

以下是增强后生成的代码：

```java
{ /*synthetic*/ Iterator i$ = data.iterator(); for (; i$.hasNext(); ) { String b = (String)i$.next(); } b = null; i$ = null; }
```

在 for 循环之外声明迭代器变量允许在不再使用时为其分配空值。这使得 GC 可以访问它，然后可以摆脱未使用的内存。当增强的 for 循环中的表达式是一个数组时，也做了类似的事情。

### javadoc 支持多种样式表

**【工具/javadoc（工具）】**

新的 javadoc 命令行选项 `--add-stylesheet` 已添加到 javadoc 工具中。新 `--add-stylesheet` 选项支持在生成的文档中使用多个样式表。现有 `-stylesheetfile` 选项现在有一个别名 ,`--main-stylesheet` 以帮助区分主样式表和任何其他样式表。

### 覆盖不改变规范的方法

**【工具/javadoc（工具）】**

javadoc 工具中添加了一个新的选项 `--overridden-methods=` 值。许多类在不更改规范的情况下覆盖继承的方法。`--overridden-methods=` 值选项可用于将这些方法与其他继承的方法分组，而不是使用类中声明的其他方法详细记录它们。

### API 描述摘要的注释标签

**【工具/javadoc（工具）】**

添加了一个新的内联标记 ，`{@summary ...}` 以明确指定用作 API 描述摘要的文本。默认情况下，API 描述的摘要是从第一句话推断出来的。这是通过使用简单算法或 `java.text.BreakIterator`. 但是，对此的启发式方法并不总是正确的，并且可能导致错误地确定第一句的结尾。新标签使 API 摘要文本能够被显式设置而不是推断。

### OpenJDK 文档中提到的特性

#### JEP 286：局部变量类型推断

**【工具】**

增强 Java 语言以将类型推断扩展到使用初始化程序的局部变量声明。

#### JEP 296：将 JDK 森林整合到一个存储库中

**【基础结构 / 构建】**

将 JDK 森林（Forest）的众多存储库组合到一个存储库中，以简化和简化开发。

#### JEP 304：垃圾收集器接口

**【HotSpot / gc】**

通过引入干净的垃圾收集器（GC）接口，改进不同垃圾收集器的源代码隔离。

#### JEP 310：应用程序类-数据共享

**【HotSpot / 运行时】**

为了改善启动和占用空间，扩展现有的类数据共享（“CDS”）功能以允许将应用程序类放置在共享存档中。

#### JEP 312：线程本地握手

**【HotSpot / 运行时】**

引入一种无需执行全局 VM 安全点即可在线程上执行回调的方法。使停止单个线程既可行又成本低，而不是需要在要么停止所有线程要么不停止线程中二选一。

#### JEP 314：额外的 Unicode 语言标签扩展

**【核心库 / java.util : i18n】**

增强 `java.util.Locale` 和相关 API 以实现 BCP 47 语言标签的额外 Unicode 扩展。

#### JEP 316：替代存储设备上的堆分配

**【HotSpot / gc】**

启用 HotSpot VM 以在用户指定的备用内存设备（例如 NV-DIMM）上分配 Java 对象堆。

#### JEP 317：实验性的基于 Java 的 JIT 编译器

**【HotSpot / 编译器】**

启用基于 Java 的 JIT 编译器 Graal，用作 Linux/x64 平台上的实验性 JIT 编译器。

#### JEP 322：基于时间的发布版本控制

**【核心库 / java.lang】**

修改 Java SE 平台和 JDK 的版本字符串方案，以及相关的版本信息，以用于当前和未来的基于时间的发布模型。



## JDK 9

### Java 平台模块系统

**【主要变化】**

引入了一种新的 Java 编程组件，即模块，它是一个命名的、自描述的代码和数据集合。该模块系统：

- 引入了一个新的可选阶段，链接时间，它介于编译时间和运行时间之间，在此期间可以将一组模块组装并优化为自定义运行时映像。
- 将选项添加到工具 `javac`、`jlink` 和 `java` 您可以指定模块路径的位置，这些路径定位模块的定义。
- 介绍模块化 JAR 文件，它是一个 JAR 文件`module-info.class`，其根目录中有一个文件。
- 引入 JMOD 格式，这是一种类似于 JAR 的打包格式，只是它可以包含本机代码和配置文件。

JDK 本身被划分为一组模块。这种变化：

- 使您能够将 JDK 的模块组合成各种配置，包括：

  - JRE和JDK对应的配置。
  - 配置在内容上大致等同于Java SE 8 中定义的每个 Compact Profiles。
  - 仅包含一组指定模块及其所需模块的自定义配置。

- 重构 JDK 和 JRE 运行时映像以适应模块并提高性能、安全性和可维护性。

- 定义一个新的 URI 方案，用于命名存储在运行时映像中的模块、类和资源，而不显示映像的内部结构或格式。

- 删除认可的标准覆盖机制和扩展机制。

- 从 Java 运行时映像中删除 `rt.jar` 和删除 `tools.jar`。

- 默认情况下使大部分 JDK 的内部 API 不可访问，但保留一些关键的、广泛使用的内部 API 可访问，直到它们的全部或大部分功能存在支持的替换。

  运行命令 `jdeps -jdkinternals` 以确定您的代码是否使用内部 JDK API。

### JEP 223：新版本字符串方案

**【主要变化】**

提供简化的版本字符串格式，有助于清楚地区分主要、次要、安全和补丁更新版本。

新的版本字符串格式如下：

```
$MAJOR.$MINOR.$SECURITY.$PATCH
```

- `$MAJOR` 是为主要版本增加的版本号，例如 JDK 9，它包含 Java SE 平台规范指定的重要新功能。主要版本包含新功能和对现有功能的更改，这些都是提前计划和宣布的。
- `$MINOR` 是为每个次要更新增加的版本号，例如错误修复、标准 API 的修订或相关平台规范范围之外的功能实现。
- `$SECURITY` 是为安全更新版本增加的版本号，其中包含关键修复，包括提高安全性所必需的修复。
- `$PATCH` 是针对包含已一起测试的安全性和高优先级客户修复程序的版本增加的版本号。

### JEP 222：jshell：Java Shell（读取-评估-打印循环）

**【工具】**

将 Read-Eval-Print Loop (REPL) 功能添加到 Java 平台。

`jshell` 工具提供了一个交互式命令行界面，用于评估 Java 编程语言的声明、语句和表达式。它通过即时结果和反馈促进了编码选项的原型设计和探索。即时反馈与从表达式开始的能力相结合对教育很有用——无论是学习 Java 语言还是只是学习新的 API 或语言特性。

JShell API 使应用程序能够利用 REPL 功能。

### JEP 228：添加更多诊断命令

**【工具】**

定义其他诊断命令以提高诊断 Hotspot 和 JDK 问题的能力。

### JEP 238：多版本 JAR 文件

**【工具】**

扩展 JAR 文件格式以使多个特定于 Java 版本的类文件能够在单个存档中共存。

多版本 JAR (MRJAR) 包含特定于特定 Java 平台版本的类和资源的附加版本化目录。`jar` 使用该工具的 `--release` 选项指定版本化目录。

### JEP 245：验证 JVM 命令行标志参数

**【工具】**

验证所有数字 JVM 命令行标志的参数以避免失败，如果发现它们无效，则显示相应的错误消息。

对于需要用户指定数值的参数，已实现范围和可选约束检查。

### JEP 247：为旧平台版本编译

**【工具】**

增强 `javac`，使其可以编译 Java 程序以在选定的早期版本平台上运行。

使用 `-source` 或 `-target` 选项时，编译后的程序可能会意外使用给定目标平台不支持的 API。`--release` 选项将防止意外使用 API。

### JEP 282：jlink：Java 链接器

**【工具】**

将一组模块及其依赖项组装并优化为 JEP 220 中定义的自定义运行时映像。

`jlink`工具定义了一种插件机制，用于在组装过程中进行转换和优化，以及生成替代图像格式。它可以创建针对单个程序优化的自定义运行时。JEP 261 将*链接时间*定义为编译时间和运行时间阶段之间的可选阶段。链接时需要一个链接工具来组装和优化一组模块及其传递依赖项，以创建运行时映像或可执行文件。

### JEP 275：模块化 Java 应用程序打包

**【部署】**

将 Project Jigsaw 的功能集成到 Java Packager 中，包括模块感知和自定义运行时创建。

利用该 `jlink` 工具创建更小的包。

创建仅使用 JDK 9 运行时的应用程序。不能用于使用早期版本的 JRE 打包应用程序。

### JEP 213：打磨 Coin 项目

**【语言】**

确定一些小的变化：

- 允许 `@SafeVargs` 用于私有实例方法。
- 允许等价 final 变量用作 `try-with-resources` 语句中的资源。
- 如果推断类型的参数类型是可表示的，则允许使用匿名类的菱形。
- 从 Java SE 8 开始，从合法标识符名称集中删除下划线。
- 添加对私有接口方法的支持。

### JEP 221：简化的 Doclet API

**【javadoc】**

将旧的 Doclet API 替换为利用其他标准现有 API 的新简化 API。标准 doclet 已被重写以使用新的 Doclet API。

### JEP 224：HTML5 Javadoc

**【javadoc】**

支持生成 HTML5 输出。要获得完全符合 HTML5 的输出，请确保文档注释中提供的任何 HTML 内容都符合 HTML5。

### JEP 225：Javadoc 搜索

**【javadoc】**

为生成的 API 文档提供搜索框。使用此搜索框可在文档中查找程序元素、标记词和短语。

### JEP 261：模块系统

**【javadoc】**

支持模块声明中的文档注释。包括新的命令行选项来配置要记录的模块集，并为要记录的任何模块生成一个新的摘要页面。

### JEP 165：编译器控制

**【JVM】**

提供一种通过编译器指令选项控制 JVM 编译的方法。控制级别是运行时可管理的和特定于方法的。Compiler Control 取代 CompileCommand 并向后兼容。

### JEP 197：分段代码缓存

**【JVM】**

将代码缓存划分为不同的段，每个段都包含特定类型的编译代码，以提高性能并支持未来的扩展。

### JEP 276：语言定义对象模型的动态链接

**【JVM】**

在运行时将高级对象操作（例如读取属性、写入属性和调用函数）动态链接到适当的目标方法句柄。它根据传递的值的实际类型将这些操作链接到目标方法句柄。这些对象操作表示为调用动态站点。

虽然 java.lang.invoke 为 invokedynamic 调用站点的动态链接提供了一个低级 API ，但它没有提供一种方法来表达对对象的更高级别的操作，也没有提供实现它们的方法。

使用包 jdk.dynalink，您可以实现其表达式包含动态类型（无法静态确定的类型）并且对这些动态类型的操作表示为 invokedynamic 调用站点的编程语言（因为语言的对象模型或类型系统不与 JVM 非常匹配）。

### 提高 G1 可用性、确定性和性能

**【JVM调优】**

增强垃圾优先 (G1) 垃圾收集器以自动确定几个重要的内存回收设置。以前必须手动设置这些设置以获得最佳结果。此外，修复了 G1 垃圾收集器的可用性、确定性和性能问题。

### JEP 158：统一 JVM 日志记录

**【JVM调优】**

为 JVM 的所有组件引入了一个通用的日志记录系统。

### JEP 248：使 G1 成为默认垃圾收集器

**【JVM调优】**

使垃圾优先 (G1) 成为 32 位和 64 位服务器配置上的默认垃圾收集器 (GC)。对于大多数用户来说，使用低暂停收集器（例如 G1）比以前默认的面向吞吐量的收集器（例如 Parallel GC）提供更好的整体体验。

### JEP 271：统一 GC 日志记录

**【JVM调优】**

使用 JEP 158 中引入的统一 JVM 日志记录框架重新实现垃圾收集 (GC) 日志记录。GC 日志以与当前 GC 日志格式一致的方式重新实现；但是，新旧格式之间存在一些差异。

### JEP 102：进程（Process） API 更新

**【核心库】**

改进了用于控制和管理操作系统进程的 API。

`ProcessHandle` 类提供进程的本机进程 ID、参数、命令、启动时间、累积 CPU 时间、用户、父进程和后代。该类还可以监视进程的活跃度和销毁进程。使用 `ProcessHandle.onExit` 方法，`CompletableFuture` 类的异步机制可以在进程退出时执行一个动作。

### JEP 193：变量处理器（Variable Handlers）

**【核心库】**

定义一种标准方法来向对象字段和数组元素进行 `java.util.concurrent.atomic` 和 `sun.misc.Unsafe` 等价的操作。

定义一组标准的栅栏操作（fence operations），由 `VarHandle` 静态方法组成，这些方法可以对内存排序进行细粒度控制。这是 `sun.misc.Unsafe` 的替代方案，它提供了一组非标准的栅栏操作。

定义标准可达性围栏操作以确保引用的对象保持强可达性。

### JEP 254：紧凑字符串

**【核心库】**

对字符串采用更节省空间的内部表示。以前，String类将字符存储在char数组中，每个字符使用两个字节（16 位）。String类的新内部表示是一个字节数组加上一个编码标志字段。

这纯粹是一个实现更改，对现有的公共接口没有任何更改。

### JEP 264：平台日志 API 和服务

**【核心库】**

定义平台类可以用来记录消息的最小日志 API，以及这些消息的消费者的服务接口。库或应用程序可以提供此服务的实现，以将平台日志消息路由到其选择的日志框架。如果未提供实现，则使用基于 `java.util.logging` API 的默认实现。

### JEP 266：更多并发更新

**【核心库】**

为在 JDK 8 中 JEP 155：并发更新 引入的并发更新添加了进一步的并发更新，包括可互操作的发布-订阅框架和 `CompletableFuture` API 的增强。

### JEP 268：XML 目录

**【核心库】**

添加标准 XML 目录 API，支持结构化信息标准促进组织 (OASIS) XML 目录版本 1.1 标准。API 定义了目录和目录解析器抽象，它们可以用作内部或外部解析器，以及接受解析器的 JAXP 处理器。

使用内部目录 API 的现有库或应用程序将需要迁移到新 API 以利用新功能。

### JEP 269：集合的便利工厂方法

**【核心库】**

使创建具有少量元素的集合和映射的实例变得更加容易。`List`、`Set` 和 `Map` 接口上的新静态工厂方法使创建这些集合的不可变实例变得更加简单。

例如：

```java
Set<String> alphabet = Set.of("a", "b", "c");
```

### JEP 274：增强的方法句柄

**【核心库】**

增强 `java.lang.invoke` 包的 `MethodHandle`、`MethodHandles` 和 `MethodHandles.Lookup` 类，以简化常见用例并实现更好的编译器优化。

新增内容包括：

- 在 `java.lang.invoke` 包的 `MethodHandles` 类中，为循环和 `try / finally` 块提供新的 `MethodHandle` 组合子（combinators）。
- 使用新的 `MethodHandle` 组合子增强 `MethodHandle` 和 `MethodHandles` 类以进行参数处理。
- 在 `MethodHandles.Lookup` 类中为接口方法和可选的超级构造函数实现新的查找。

### JEP 277：增强的弃用

**【核心库】**

修改 `@Deprecated` 注解以提供有关规范中 API 的状态和预期处置的更好信息。添加了两个新元素：

- `@Deprecated(forRemoval=true)` 表示该 API 将在 Java SE 平台的未来版本中删除。
- `@Deprecated(since="version")` 包含指示 API 元素何时被弃用的 Java SE 版本字符串，对于那些在 Java SE 9 及更高版本中弃用的元素。

例如：`@Deprecated(since="9", forRemoval=true)`

核心平台中的 `@Deprecated` 注解已更新。

您可以使用新工具 `jdeprscan` 来扫描类库（JAR 文件）以查找已弃用的 JDK API 元素的使用情况。

### JEP 285：自旋-等待（Spin-Wait）提示

**【核心库】**

定义一个 API，使 Java 代码能够提示正在执行自旋循环。自旋循环反复检查条件是否为真，例如何时可以获得锁，之后可以安全地执行一些计算，然后释放锁。这个 API 纯粹是一个提示，没有语义行为要求。请参阅方法 `Thread.onSpinWait`。

### JEP 290：过滤传入的序列化数据

**【核心库】**

允许过滤传入的对象序列化数据流，以提高安全性和稳健性。对象序列化客户端可以更轻松地验证其输入，导出的远程方法调用 (RMI) 对象也可以更轻松地验证调用参数。

序列化客户端实现一个在 `ObjectInputStream` 上设置的过滤器接口。对于 RMI，对象通过 `RemoteServerRef` 导出，该对象在 `MarshalInputStream` 上设置过滤器，以在调用参数未编组时对其进行验证。

### JEP 259：堆栈遍历（Stack-Walking） API

**【核心库】**

 提供堆栈遍历 API，允许轻松过滤和延迟访问堆栈跟踪中的信息。

API 支持在符合给定标准的帧处停止的短走，以及遍历整个堆栈的长走。如果调用者只对堆栈上的顶部帧感兴趣，则在与给定标准匹配的帧处停止可以避免检查所有帧的成本。当堆栈遍历器配置为这样做时，API 允许访问 Class 对象。请参阅类 `java.lang.Stackwalker`。

### JEP 236：Nashorn 的解析器 API

**【Nashorn】**

使应用程序（尤其是 IDE 和服务器端框架）能够解析和分析 ECMAScript 代码。

使用 `Parser` 类中的方法从字符串、URL 或文件中解析 ECMAScript 代码。这些方法返回 `CompilationUnitTree` 的实例，它将 ECMAScript 代码表示为抽象语法树。

`jdk.nashorn.api.tree` 包包含 Nashorn 解析器 API。

### JEP 292：在 Nashorn 中实现选定的 ECMAScript 6 功能

**【Nashorn】**

实现了 ECMA-262 第 6 版中引入的许多新功能，也称为 ECMAScript 6，或简称 ES6。实现的功能包括：

- 模板字符串
- `let`, `const` 和块作用域
- 迭代器和 `for..of` 循环
- `Map`、`Set`、`WeakMap` 和 `WeakSet`
- 符号
- 二进制和八进制文字

### JEP 267：Unicode 8.0

**【国际化】**

支持 Unicode 8.0 。JDK 8 支持 Unicode 6.2。

Unicode 6.3、7.0 和 8.0 标准组合引入了 10,555 个字符、29 个脚本和 42 个块，所有这些都在 JDK 9 中得到支持。

### JEP 226：UTF-8 属性文件

**【国际化】**

以 UTF-8 编码加载属性文件。在以前的版本中，加载属性资源包时使用了 ISO-8859-1 编码。UTF-8 是一种更方便的方式来表示非拉丁字符。

大多数现有的属性文件不应受到影响。





# JDK 9 ~ 17 各个版本删除的功能和选项



## JDK 17

### JEP 403：强封装 JDK 内部

**【核心库】**

强封装（Strongly encapsulate） JDK 的所有内部元素，除了关键的内部 API，例如 `sun.misc.Unsafe`.

通过此更改，`java` 启动器选项`--illegal-access` 已过时。如果在命令行上使用，则会发出警告消息，否则无效。必须使用 JDK 的内部类、方法或字段的现有代码仍然可以通过使用`--add-opens` 启动器选项或 `Add-Opens` 文件清单属性来打开特定包来工作。

### JEP 407：删除 RMI 激活

**【核心库 / java.rmi】**

远程方法调用 (RMI) 激活机制已被删除。RMI 激活是 RMI 的一个过时部分，自 Java SE 8 以来一直是可选的。 RMI 激活已被 Java SE 15 中的 JEP 385弃用，并且已被 JEP 407 从此版本中删除。该 `rmid` 工具也已被删除。有关背景、基本原理、风险和替代方案，请参阅 JEP 385。RMI 的其余部分保持不变。

### JEP 410：删除实验性 AOT 和 JIT 编译器

**【HotSpot / 编译器】**

HotSpot VM 中的 AOT 编译器相关代码已被删除。使用 JEP295 定义的 HotSpot VM 选项会在 VM 初始化时产生“无法识别的 VM 选项”错误。

### 删除 sun.misc.Unsafe::defineAnonymousClass

**【核心库】**

### 删除 Telia 公司的 Sonera Class2 CA 证书

**【安全库/java.security】**



## JDK 16

### 删除 java.awt.PeerFixer

**【客户端库 / java.awt】**

非公共类 `java.awt.PeerFixer` 在此版本中已删除。此类用于为在 JDK 1.1.1 之前创建的 ScrollPane 对象提供反序列化支持。

### 去除实验特征 AOT 和 Graal JIT

**【HotSpot / 编译器】**

Java Ahead-of-Time 编译实验工具 `jaotc` 已被删除。使用 JEP295 定义的 HotSpot VM 选项会产生不支持的选项警告，否则将被忽略。

实验性的基于 Java 的 JIT 编译器 Graal JEP317 已被删除。尝试使用它会产生 JVMCI 错误：`JVMCI compiler 'graal' not found`.

### 已弃用的跟踪标志已过时，必须用统一日志等效项替换

**【HotSpot / 运行时】**

在 Java 9 中添加统一日志记录时，许多跟踪标志被弃用并映射到它们的统一日志记录等效项。这些标志现在已过时，将不再自动转换以启用统一日志记录。要继续获得相同的日志输出，您必须将这些标志的使用明确替换为它们的统一日志等效项。

| 过时的选项               | 统一日志替换            |
| ------------------------ | ----------------------- |
| -XX:+TraceClassLoading   | -Xlog:class+load=info   |
| -XX:+TraceClassUnloading | -Xlog:class+unload=info |
| -XX:+TraceExceptions     | -Xlog:exceptions=info   |

### 删除了 1024 位密钥的根证书

**【安全库 / java.security】**

一些具有弱 1024 位 RSA 公钥的根证书已从 `cacerts` 密钥库中删除

### 去除传统的椭圆曲线

**【安全库 / javax.crypto】**

SunEC 提供程序不再支持一些已过时或未使用现代公式和技术实现的椭圆曲线。



## JDK 15

### 删除最终弃用的 Solaris 特定 SO_FLOW_SLA 套接字选项

**【核心库 / java.net】**

在此版本中，随着 JEP381 ( JDK-8241787 ) 中 Solaris 端口的删除，JDK 特定的套接字选项 `jdk.net.ExtendedSocketOptions.SO_FLOW_SLA`（仅与 Solaris 上的套接字相关）及其支持类 `SocketFlow` 和 `SocketFlow.Status` 已被删除。

### 删除 RMI 静态存根编译器 (rmic)

**【核心库 / java.rmi】**

RMI 静态存根编译器（RMI Static Stub Compiler）`rmic` 已被删除。该 `rmic` 工具已过时，自 JDK 13 起为了在未来将其删除已标为弃用。

### 删除已弃用的常量 RMIConnectorServer.CREDENTIAL_TYPES

**【核心svc / javax.management】**

最终弃用的常量 `javax.management.remote.rmi.RMIConnectorServer.CREDENTIAL_TYPE` 已被删除。可以使用 `RMIConnectorServer.CREDENTIALS_FILTER_PATTERN` 指定过滤器模式。

### 移除 Nashorn JavaScript 引擎

**【核心库 / jdk.nashorn】**

Nashorn JavaScript 脚本引擎、其 API 和 `jjs` 工具已被删除。该引擎、API 和该工具在 Java 11 中已被弃用，以便在未来的版本中删除它们

### 已过时 -XXUseAdaptiveGCBoundary

**【HotSpot / gc】**

VM 选项 `UseAdaptiveGCBoundary` 已过时。使用此选项将产生过时选项警告，否则将被忽略。

此选项以前默认禁用，启用它仅在使用 `-XX:+UseParallelGC`. 启用它旨在为某些应用程序提供性能优势。但是，由于崩溃和性能下降，它已默认禁用很长时间。

### 移除 Comodo 根 CA 证书

**【安全库 / java.security】**

### 删除 DocuSign 根 CA 证书

**【安全库 / java.security】**

### 弃用了已弃用的 SSLSession.getPeerCertificateChain() 方法实现

**【安全库 / javax.net.ssl】**

`SSLSession.getPeerCertificateChain() `已从 SunJSSE 提供程序和 HTTP 客户端实现中的 JDK 中删除了已弃用方法的实现。此方法的默认实现已更改为抛出 UnsupportedOperationException。

`SSLSession.getPeerCertificateChain()` 是一个不推荐使用的方法，将在未来的版本中删除。为了减轻删除兼容性的影响，应用程序应该改用该 `SSLSession.getPeerCertificates()` 方法。对于服务提供商，请从现有实现中删除此方法，并且在任何新实现中不支持此方法。

### 删除 com.sun.net.ssl.internal.ssl.Provider 名称

**【安全库 / javax.net.ssl】**

旧的 SunJSSE 提供程序名称 “com.sun.net.ssl.internal.ssl.Provider” 已被删除，不应再使用。应改为使用 “SunJSSE” 名称。例如， `SSLContext.getInstance("TLS", "SunJSSE")`。



## JDK 14

### 删除 sun.nio.cs.map 系统属性

**【核心库 / java.nio.charsets】**

JDK 1.4.1 中添加的系统属性 `sun.nio.cs.map` 已被删除。它是为应用程序提供的，以帮助从 `Shift_JIS` 相当于 MS Windows 代码页 932 的旧定义迁移到 IANA 定义的定义。使用映射属性的应用程序需要根据需要指定正确的字符集名称。

### 去掉 netscape.javascript.JSObjectgetWindow 方法

**【部署】**

已删除过时的方法 `netscape.javascript.JSObject::getWindow`。此方法在 JDK 9 中已弃用。从 JDK 11 开始，不再有使用此方法的有用方法；它总是返回 `null`。

### JEP 363 删除并发标记和清除 (CMS) 垃圾收集器

**【HotSpot / gc】**

CMS 垃圾收集器已被删除。`-XX:UseConcMarkSweepGC` 和别名 `-Xconcgc`，`-Xnoconcgc` 以及所有 CMS 特定选项（太多无法列出）都已过时。

### 删除了已弃用的 java.security.acl API

**【安全库 / java.security】**

已弃用的 `java.security.acl` API 已被删除。这包括该包中的以下类：`Acl`、`AclEntry`、`AclNotFoundException`、`Group`、`LastOwnerException`、`NotOwnerException`、`Owner` 和 `Permission`。

### 删除默认 keytool -keyalg 值

**【安全库 / java.security】**

`keytool -genkeypair` 和 `keytool -genseckey` 命令的默认密钥算法已被删除。现在，您必须通过在使用 `-genkeypair` 或者 `-genseckey` 命令时包含 `-keyalg` 选项来指定密钥算法。如果未指定 `-keyalg` 选项，则 `keytool` 将终止并显示错误消息：“必须指定 -keyalg 选项（The -keyalg option must be specified）”。

### JEP 367 删除 Pack200 工具和 API

**【工具 / jar】**

JDK 5.0 中添加的 `pack200` 和 `unpack200` 工具已被删除。该类 `java.util.jar.Pack200` 和接口 `java.util.jar.Pack200.Packer` 和 `java.util.jar.Pack200.Unpacker` 也已被删除。这些工具和 API 在 Java SE 11 中已被弃用，以便在未来的版本中删除它们。此外，在 `jar`工具中，`jar c` 的 `n` 子选项已被删除。



## JDK 13

### 删除 awt.toolkit 系统属性

**【客户端库】**

从历史上看（直到 JDK 1.8），`java.awt.Toolkit` 类的文档引用了 “awt.toolkit” 系统属性，该属性设置为平台实现子类的名称。该属性的文档在 JDK 9 中被删除，因为 (1) 它是一个内部细节，不打算成为受支持的接口，并且 (2) 模块系统的封装意味着无法直接操作该类。但是，系统属性直到现在才被删除。如果需要，以前读取此属性的应用程序仍然可以通过实例化 AWT Toolkit 并通过该实例查询类名来获取它。

### 删除运行时跟踪方法

**【核心库 / java.lang】**

过时的方法 `traceInstructions(boolean)` 并 `traceMethodCalls(boolean)` 已从 `java.lang.Runtime` 类中删除。这些方法在许多版本中都不起作用，它们的预期功能由 Java 虚拟机工具接口 (JVMTI) 提供。

### 不再支持 JDK 1.4 之前的 SocketImpl 实现

**【核心库 / java.net】**

`java.net.SocketImpl` 此版本已删除对为 Java SE 1.3 和更早版本编译的自定义实现的支持。`SocketImpl` 此更改对为 Java SE 1.4（2002 年发布）或更高版本编译的实现没有影响。

### 移除 VM 选项 -XX+AggressiveOpts

**【HotSpot / 运行时】**

VM 选项 `-XX:+AggressiveOpts` 在 JDK 11 中已弃用，并在 JDK 12 中删除了对它的支持（除了生成警告之外，它的使用被忽略）。现在使用此标志将导致 VM 初始化错误。

### SunJSSE 提供程序不再支持重复的 RSA 服务

**【安全库】**

SunJSSE 提供程序已删除对 `RSA KeyFactory`、`RSA KeyPairGenerator`、`MD2withRSA`、`MD5withRSA`和 `SHA1withRSA Signature` 的支持。

从 JDK 5 开始，`SunRsaSign` 引入了提供程序来支持这些与 RSA 相关的算法。SunJSSE 提供程序支持这些的唯一原因是为了向后兼容 JDK 5 之前的应用程序。删除应该只影响从 SunJSSE 提供者明确请求这些 RSA 服务的应用程序。应用程序应删除硬编码的 “SunJSSE” 提供程序名称。

### 删除 T-Systems Deutsche Telekom 根 CA 2 证书

**【安全库 / java.security】**

T-Systems Deutsche Telekom Root CA 2 证书已过期并已从 `cacerts` 密钥库中删除

### 删除两个 DocuSign 根 CA 证书

**【安全库 / java.security】**

两个 DocuSign 根 CA 证书已过期并从 `cacerts` 密钥库中删除

### 删除两个 Comodo 根 CA 证书

**【安全库 / java.security】**

两个 Comodo 根 CA 证书已过期并从 `cacerts` 密钥库中删除

### 删除内部 com.sun.net.ssl 包仅用于与旧版 JSSE 1.0 应用程序兼容

**【安全库 / javax.net.ssl】**

内部包 `com.sun.net.ssl` 已从 JDK 中删除。在 Java SE 1.4 之前，当 JSSE 作为独立产品发布时，`com.sun.net.ssl `API 是受支持的，但自 Java SE 1.4 起，该包已被弃用，仅供内部使用。自 Java SE 1.4 起，`javax.net.ssl`包中提供了标准替换 API（standard replacement APIs），例如 `HostNameVerifier`、`KeyManager` 和 `TrustManager`。尽管应用程序应该已转换为标准 API，但此注释是最后警告，这些非标准 API 已被删除。

### 从 SunJSSE Provider 中删除实验性 FIPS 140 兼容模式

**【安全库 / javax.net.ssl】**

实验性的 FIPS 140 兼容模式已从 SunJSSE 提供程序中删除。

旧版应用程序可能已通过以下方法之一使用实验模式：

1. 更新 `java.security` 文件并为 SunJSSE 提供程序指定一个加密提供程序（例如，`security.provider.4=com.sun.net.ssl.internal.ssl.Provider SunPKCS11-NSS`）
2. 使用 JDK 内部类并创建具有指定加密提供程序的提供程序（例如，`new com.sun.net.ssl.internal.ssl.Provider(cryptoProvider);`）。

因为 SunJSSE 提供程序使用 JDK 默认加密提供程序，所以应用程序可以配置 `security.provider` 安全属性以使用符合 FIPS 140 的加密提供程序。

### 从 javadoc 工具中删除旧功能

**【工具 / javadoc】**

已从 *javadoc* 工具中删除了以下四个功能：

- *支持使用 HTML 4 生成 API 文档：*在 JDK 9 中添加了对 HTML 5 的支持，并且自 JDK 11 以来一直是默认设置。要生成完全符合 HTML 5 规范的 API 文档，开发人员应确保对 HTML 标记的任何使用在他们的文档注释中也符合 HTML 5 规范。
- *支持“旧”javadoc API：*这包括 API ( `com.sun.javadoc`)、旧标准 doclet ( `com.sun.tools.doclets.standard`) 和旧入口点 ( `com.sun.tools.javadoc.Start`)，都在 `jdk.javadoc` 模块中。JDK 9 中引入了新的 API 和新的标准 doclet，利用了其他现代建模 API，例如`javax.lang.model`. 可以使用 `javax.tools.DocumentationTool` API 或者（为了简单使用）`java.util.spi.ToolProvider` 以编程方式调用 javadoc 工具。仅使用 *javadoc* 工具生成标准 API 文档的用户不受影响。
- *支持使用 HTML 框架生成文档：*它已被 JDK 9 中添加的“搜索”功能以及页面内改进的索引文件和链接所取代。
- *对 `--no-module-directories` 选项的支持*：此选项为 JDK 9 和 10 中的 *javadoc* 工具用于生成文档的组织提供了有限的支持，其中不同模块的文件未分组到单独的目录中。



## JDK 12

### 删除 com.sun.awt.SecurityWarning 类

**【客户端库 / java.awt】**

`com.sun.awt.SecurityWarning` 类在 JDK 11 (JDK-8205588) 中已被弃用且标记为 `forRemoval=true`。该类在 JDK 中未使用，已在此版本中删除。

### 从 FileInputStream 和 FileOutputStream 中删除 finalize 方法

**【核心库 / java.io】**

`FileInputStream` 和 `FileOutputStream` 的方法 `finalize` 在 JDK 9 中已弃用并设为以后删除。它们已在此版本中删除。`java.lang.ref.Cleaner` 自从 JDK 9 起作为关闭无法通过 `FileInputStream` 和 `FileOutputStream` 访问到的文件描述符的主要机制。关闭文件的推荐方法是显式调用 `close` 或使用 `try-with-resources`。

### 删除 java.util.ZipFile/Inflator/Deflator 中的 finalize 方法

**【核心库 / java.util.jar】**

`java.util.ZipFile`、`java.util.Inflator` 和 `java.util.Deflator` 的 `finalize` 方法在 JDK 9 中被弃用以删除，并且其实现已更新为无操作。

`java.util.ZipFile`、`java.util.Inflator` 和 `java.util.Deflator` 的 `finalize` 方法此版本中已删除。为了执行清理而重写 `finalize` 的子类应该改为使用替代清理机制，并删除重写的 `finalize` 方法。

删除 finalize 方法将暴露 `Object.finalize` 给 `ZipFile`、`Deflater` 和 `Inflater` 的子类。由于声明的异常发生变化，编译错误可能会发生在重写 `finalize` 时。`Object.finalize` 现在声明为抛出 `java.lang.Throwable`。以前，被声明的只有 `java.io.IOException`。

### 从 Oracle 生成的构建中删除了 YY.M 供应商（Vendor）版本字符串

**【基础设施 / 构建】**

供应商版本字符串是由 JEP 322（基于时间的发布版本控制）引入的，作为系统属性的值 `java.vendor.version`。从该版本开始，它在 Oracle 的 JDK 版本中设置为 `YY.M`， `YY` 和 `M`分别是发布的 GA 日期的年份和月份。此字符串在 `java --version`  命令和相关命令的输出中对终端用户最为明显。

从 JDK 12 开始，从 Oracle 构建的 JDK 将不再包含供应商版本字符串。因此，系统属性 `java.vendor.version` 现在值为 `null`，`java --version` 与相关命令的输出将不再包含供应商版本字符串。

### 删除 GTE CyberTrust 全局根

**【安全库 / java.security】**

### 删除 javac 对 6/1.6 源、目标和发布值的支持

**【工具 / javac】**

已经移除 6 / 1.6 对 javac 的 `-source`、`-target` 和 `--release` 标志的参数支持



## JDK 11

### 删除 com.sun.awt.AWTUtilities 类

**【客户端库】**

类 `com.sun.awt.AWTUtilities`  在 JDK 10 ( JDK-8187253 ) 中已弃用并标记 `forRemoval=true`。该类在 JDK 中未使用，已在此版本中删除。

### 从 Oracle JDK 中删除 Lucida 字体

**【客户端库 / 2d】**

Oracle JDK 不再提供任何字体，完全依赖于操作系统上安装的字体。

这意味着 Bigelow & Holmes Lucida 系列（Lucida Sans、Lucida Bright 和 Lucida Typewriter）中的字体不再可用于来自 JDK 的应用程序。

如果应用程序依赖于 JDK 中提供的字体，则可能需要更新它们。

如果系统管理员正在运行依赖于 JDK 中提供的字体而不是系统字体包的 Java 服务器应用程序，那么在安装系统字体包之前，这些应用程序可能无法运行。

### 删除 appletviewer Launcher

**【客户端库 / java.awt】**

该 `appletviewer` 工具在 JDK 9 中已弃用，并在此版本中删除。

### Oracle JDK 的 javax.imageio JPEG 插件不再支持带 alpha 的图像

**【客户端库 / javax.imageio】**

以前，Oracle JDK 使用广泛使用的 IJG JPEG 库的专有扩展来提供可选的色彩空间支持。这用于支持 PhotoYCC 和在读取和写入时具有 alpha 组件的图像。Oracle JDK 11 中删除了此可选支持。遇到任何这些格式的编码 JPEG 图像是不太可能的，除非它们以前是由早期版本的 Oracle JDK 编码的。但是，如果遇到它们，解码现在将失败并出现异常。使用 Alpha 通道写入图像也会失败并出现异常。最可能出现问题的情况是应用程序不知道它们依赖于这种支持。如果直接调用 ImageWriter 或使用 Image I/O 便捷方法，这可能会失败并出现异常。这 `write()` 方法现在将返回 `false`，意味着它没有写入图像。

一个精心编写的应用程序应该检查这些情况，这将减轻这种情况。请注意，OpenJDK 从来没有这种可选的专有支持。在这些情况下，它总是失败并产生异常。

### 删除 sun.misc.Unsafe.defineClass

**【核心库】**

该类 `sun.misc.Unsafe.defineClass` 已被删除。用户应使用 Java SE 9 中添加的公共替换 , `java.lang.invoke.MethodHandles.Lookup.defineClass`。

### 删除 Thread.destroy() 和 Thread.stop(Throwable) 方法

**【核心库 / java.lang】**

方法 `Thread.destroy()` 和 `Thread.stop(Throwable)` 已被删除。它们已在多个 Java SE 版本中被弃用。`Thread.destroy()` 方法从未实现过，并且该 `Thread.stop(Throwable)` 方法自 Java SE 8 以来一直不起作用。任何代码都不应依赖这两种方法的行为；但是，任何使用这些方法的代码都会导致编译错误。缓解措施是从源代码中删除对这些方法的引用。请注意，无参数方法 `Thread.stop()` 不受此更改的影响。

### 删除 sun.nio.ch.disableSystemWideOverlappingFileLockCheck 属性

**【核心库 / java.nio】**

该物业 `sun.nio.ch.disableSystemWideOverlappingFileLockCheck` 已被移除。因此，与旧锁定方法的兼容性也已被删除。

JDK 6 引入了系统属性 `sun.nio.ch.disableSystemWideOverlappingFileLockCheck` 来控制文件锁定行为。具体来说，该属性用于启用 JVM 范围的文件锁定抑制并提供与 JDK 1.4 和 JDK 5 的兼容性。旧的行为仅限于检查仅在通道实例上而不是 JVM 范围内获得的锁，这就是实际指定的。

### 删除 sun.locale.formatasdefault 属性

**【核心svc / javax.management】**

JDK 7 中为了向后兼容而引入的系统属性 `sun.locale.formatasdefault` 已被删除。

### 移除 JVM-MANAGEMENT-MIB.mib

**【核心svc / javax.management】**

通过 SNMP 监视和管理 JVM 的规范 `JVM-MANAGEMENT-MIB.mib` 已被删除。客户可以使用 JMX 来监视和管理正在运行的 JVM 并访问标准的指标和操作集。

### 删除 SNMP 代理

**【核心svc / 工具】**

`jdk.snmp` 模块已被移除。

因此，以下 `com.sun.management.snmp.*` 属性在使用 `-D` 选项或 `management.properties` 配置设置时是无操作的。

- `com.sun.management.snmp.port`
- `com.sun.management.snmp.trap`
- `com.sun.management.snmp.interface`
- `com.sun.management.snmp.acl`
- `com.sun.management.snmp.acl.file`

### 去除 Java 部署技术

**【部署】**

在 JDK 9 中已弃用并标记为在 JDK 10 中删除的候选者的 Java Plugin 和 Java WebStart 技术现在已被删除。请注意，用于配置部署技术的 Java 控制面板也已与共享系统 JRE（但不是服务器 JRE）和 JRE 自动更新机制一起被删除。

### 从 Oracle JDK 中移除 JMC

**【基础架构】**

Java Mission Control (JMC) 不再包含在 JDK 包中。JMC 的独立版本与 Oracle JDK 11 和 OpenJDK 11 兼容，可单独下载。

### 从 Oracle JDK 中删除 JavaFX

**【javafx / 其他】**

JavaFX 模块已从 JDK 11 版本中删除。这些模块包含在早期版本的 Oracle JDK 中，但不包含在 OpenJDK 版本中。JavaFX 模块将作为 JDK 之外的一组单独模块提供。

### JEP 320 删除 Java EE 和 CORBA 模块

**【其他库】**

从 Java SE 平台和 JDK 中删除 Java EE 和 CORBA 模块。这些模块在 Java SE 9 中被弃用，并声明打算在未来的版本中删除它们 ( JEP 320 )。

以下模块已从 Java SE 11 和 JDK 11 中删除：

- `java.xml.ws`（JAX-WS，加上相关技术 SAAJ 和 Web 服务元数据）
- `java.xml.bind`(JAXB)
- `java.activation`(JAF)
- `java.xml.ws.annotation`（常用注解）
- `java.corba`（CORBA）
- `java.transaction`(JTA)
- `java.se.ee`（以上六个模块的聚合器模块）
- `jdk.xml.ws`（JAX-WS 工具）
- `jdk.xml.bind`（JAXB 工具）

`jdk.xml.ws`从模块中删除了以下 JAX-WS 工具：

- `wsgen`
- `wsimport`

`jdk.xml.bind`从模块中删除了以下 JAXB 工具：

- `schemagen`
- `xjc`

`java.corba`从模块中删除了以下 CORBA 工具：

- `idlj`
- `orbd`
- `servertool`
- `tnamesrv`

编译器 `rmic` 已更新以删除 `-idl` 和 `-iiop` 选项。因此，RMI 编译器将不再能够生成 IDL 或 IIOP 存根和关联类。

此外，由于删除了 Java EE 和 CORBA 模块，以下系统属性不再适用：

- `com.sun.xml.internal.ws.client.ContentNegotiation`
- `com.sun.xml.internal.ws.legacyWebMethod`
- `javax.xml.bind.context.factory`
- `javax.xml.bind.JAXBContext`
- `javax.xml.soap.MetaFactory`
- `javax.xml.ws.spi.Provider`
- `jaxb.fragment`
- `jaxb.noNamespaceSchemaLocation`
- `jaxb.schemaLocation`
- `jaxb.formatted.output`
- `jaxb.encoding`
- `mail.mime.decodetext.strict`
- `mail.mime.encodeeol.strict`
- `mail.mime.foldencodedwords`
- `mail.mime.foldtext`
- `mail.mime.charset`
- `saaj.mime.optimization`
- `saaj.lazy.contentlength`
- `saaj.lazy.contentlength`
- `saaj.lazy.mime.optimization`



## JDK 10

### 取消对使用旧 LookAndFeel 的支持

**【客户端库】**

应用程序不再可能使用旧的或不受支持的 LookAndFeels。一些应用程序（例如 Nimbus 和 Aqua）使用旧的类名来实例化 JDK 内部的 Swing LookAndFeels。

### 删除 Runtime.getLocalizedInputStream 和 getLocalizedOutputStream 方法

**【核心库 / java.lang】**

方法 `Runtime.getLocalizedInputStream` 和 `Runtime.getLocalizedOutputStream` 已被删除。它们是过时的国际化机制的一部分，没有已知用途。

### 删除 RMI 服务器端多路复用协议支持

**【核心库 / java.rmi】**

RMI Multiplex 协议在 JDK 9 中被禁用并已被删除。

### 移除常见的 DOM API

**【部署 / 插件】**

`com.sun.java.browser.plugin2.DOM` 和 `sun.plugin.dom.DOMObject` API 已被删除。应用程序可以用 `netscape.javascript.JSObject` 来操作 DOM。

### 移除 FlatProfiler

**【HotSpot / 运行时】**

JDK 9 中已弃用的 FlatProfiler 通过删除实现代码已过时。通过设置 `-Xprof` VM 参数启用了 FlatProfiler。`-Xprof` 标志在此版本中仍然可以识别；但是，设置它会打印出警告消息。

### 删除过时的 -X 选项

**【HotSpot / 运行时】**

已删除过时的 HotSpot VM 选项（`-Xoss`、`-Xsqnopause`、`-Xoptimize`、`-Xboundthreads` 和 `-Xusealtsigs`）。

### 移除 HostServicesgetWebContext 方法

**【javafx / 应用程序生命周期】**

`HostServices::getWebContext` 方法在 JDK 9 中已被弃用，现已被删除。此功能没有替代品。应用程序将不再能够与 JavaFX Applet 的封闭网页进行通信。请注意，此功能所依赖的 Java 插件也已被弃用，无法删除。

### 从 JavaFX 中移除 T2K Rasterizer 和 ICU 布局引擎

**【javafx / 图形】**

T2K 光栅化器和 ICU 布局引擎已从 JavaFX 中删除。

### 从 JavaFX 中删除已弃用的 VP6/FXM/FLV 代码

**【javafx / 媒体】**

JavaFX Media 中删除了对 VP6 视频编码格式和 FXM/FLV 容器的支持。鼓励用户使用 MP4 容器中的 H.264/AVC1 或 HTTP Live Streaming。

### 删除已弃用的 Pre-1.2 SecurityManager 方法和字段

**【安全库 / java.security】**

以下 pre-1.2 的 `java.lang.SecurityManager ` 弃用并标记为 `forRemoval=true` 的方法和字段已被删除：

- `inCheck`场地
- `getInCheck`方法
- `classDepth`方法
- `classLoaderDepth`方法
- `currentClassLoader`方法
- `currentLoadedClass`方法
- `inClass`方法
- `inClassLoader`方法

此外，已弃用的 `checkMemberAccess` 方法已更改为如果调用者没有保证 `AllPermission`时抛出一个 `SecurityException`。此方法容易出错，用户应改为直接调用 `checkPermission` 方法。

### 删除策略工具

**【安全库 / java.security】**

`policytool` 安全工具已从 JDK 中删除。

### 删除 com.sun.security.auth 中已弃用的类

**【安全库 / java.security】**

在 JDK 9 中标记为删除的以下不推荐使用的类已被删除：

- `com.sun.security.auth.PolicyFile`
- `com.sun.security.auth.SolarisNumericGroupPrincipal`
- `com.sun.security.auth.SolarisNumericUserPrincipal`
- `com.sun.security.auth.SolarisPrincipal`
- `com.sun.security.auth.X500Principal`
- `com.sun.security.auth.module.SolarisLoginModule`
- `com.sun.security.auth.module.SolarisSystem`

### 删除旧的（JDK 6、JDK 7 和 JDK 8 时代）标准 Doclet

**【工具 / javadoc（工具）】**

旧的（JDK 6、JDK 7 和 JDK 8 时代）标准 doclet 已在此版本中删除，它输出 HTML 内容并已被替代品取代。底层的 javadoc API（参见`com.sun.javadoc`API 文档）已被弃用，但暂时仍然可用，供用户提供的 doclet 使用。

### JEP 313 移除 Native-Header 生成工具 (javah)

**【工具 / javah】**

如前所述，本机标头（native-header）工具 `javah` 已被删除。

现在可以使用`javac`带有`-h`选项的 Java 编译器生成本机标头（native headers）。

### 删除 Java Launcher 的数据模型选项 -d32 和 -d64

**【工具 / 启动器】**

启动器的 `java` 数据模型选择选项（-d32、-d64、-J-d32 和 -J-d64）已被删除。它们已经过时并且之前已被弃用。`java` 为防止启动器失败，用户在调用启动器或工具（如 `javac` 和 `javah`）时必须删除这些选项的使用。



## JDK 9

### JEP 231：删除启动时 JRE 版本选择

删除了请求不是在启动时启动的 JRE 的 JRE 版本的能力。

现代应用程序通常通过 Java Web Start（带有 JNLP 文件）、本机 OS 打包系统或活动安装程序进行部署。这些技术有自己的方法来管理所需的 JRE，方法是根据需要查找或下载和更新所需的 JRE。这使得启动时 JRE 版本选择已过时。

### JEP 240：删除 JVM TI hprof 代理

从 JDK 中删除 `hprof` 代理。`hprof` 代理是作为 JVM 工具接口的演示代码编写的，并非旨在成为生产工具。

`hprof` 代理的有用功能已被更好的替代方案所取代。

### JEP 241：删除 jhat 工具

从 JDK 中删除 `jhat` 工具。

`jhat` 工具是 JDK 6 中添加的一个实验性且不受支持的工具。它已过时；卓越的堆可视化器和分析器已经问世多年。

### JEP 214：删除 JDK 8 中已弃用的 GC 组合

删除 JDK 8 中已弃用的垃圾收集器 (GC) 组合。

这意味着以下 GC 组合不再存在：

- DefNew + CMS
- ParNew + SerialOld
- 增量CMS

并发标记扫描 (CMS) 的“前台”模式也已被删除。以下命令行标志已被删除：

- `-Xincgc`
- `-XX:+CMSIncrementalMode`
- `-XX:+UseCMSCompactAtFullCollection`
- `-XX:+CMSFullGCsBeforeCompaction`
- `-XX:+UseCMSCollectionPassing`

命令行标志 `-XX:+UseParNewGC` 不再有效。ParNew 只能与 CMS 一起使用，而 CMS 需要 ParNew。因此，`-XX:+UseParNewGC` 标志已被弃用，并且可能会在未来的版本中被删除。





# JDK 9 ~ 17 各个版本弃用的功能和选项



## JDK 17

### JEP 398：弃用 Applet API 以进行删除

**【客户端库 / java.awt】**

### JEP 411：弃用安全管理器以进行删除

**【安全库 / java.security】**

### 在 Kerberos 中弃用 3DES 和 RC4

**【安全库 / org.ietf.jgss : krb5】**

### 弃用 Socket 实现工厂机制

**【核心库 / java.net】**

以下用于设置系统范围的套接字实现工厂的静态方法已被弃用：

- `static void ServerSocket.setSocketFactory(SocketImplFactory fac)`
- `static void Socket.setSocketImplFactory(SocketImplFactory fac)`
- `static void DatagramSocket.setDatagramSocketImplFactory(DatagramSocketImplFactory fac)`

这些 API 点用于为 `java.net` 包中的相应套接字类型静态配置系统范围的工厂。自 Java 1.4 以来，这些方法大多已过时。

### 弃用 JVM TI 堆函数 1.0

**【HotSpot / jvmti】**



## JDK 16

### 最终弃用的线程组停止、销毁、isDestroyed、setDaemon 和 isDaemon

**【核心库 / java.lang】**

`java.lang.ThreadGroup` 定义的 `stop`、`destroy`、`isDestroyed`、`setDaemon` 和 `isDaemon` 方法在此版本中已被最终弃用（terminally deprecated）。

`ThreadGroup::stop` 本质上是不安全的，并且自 Java 1.2 起已被弃用。该方法现在已被最终弃用，并将在未来的版本中删除。

用于销毁 ThreadGroup 的 API 和机制存在固有缺陷。支持显式或自动销毁线程组的方法已被最终弃用，并将在未来的版本中删除。

### 部分 Signal-Chaining API 已弃用

**【HotSpot / 运行时】**

信号链工具是在 JDK 1.4 中引入的，它支持三种不同的 Linux 信号处理 API： `sigset`、`signal` 和 `sigaction`。只有 `sigaction` 是用于多线程进程的跨平台、受支持的 API。`signal` 和 `sigset` 两者在仍然定义它们的那些平台上都被认为是过时的。因此，现在  `signal` 和 `sigset` 与信号链工具一起使用已被弃用，并且在未来的版本中将删除对其使用的支持。

### 弃用了将 DN 表示为主体或字符串对象的 java.security.cert API

**【安全库 / java.security】**

这些 API 采用或返回可分辨名称（Distinguished Names）作为 `Principal` 或 `String` 对象，并且在比较不同主体（Principal）实现之间的名称时，可能会由于编码信息的丢失或差异而导致问题。它们都有使用 `X500Principal` 对象的替代 API。



## JDK 15

###  已弃用的 RMI 激活以删除

**【核心库 / java.rmi】**

RMI 激活机制已被弃用，可能会在平台的未来版本中删除。RMI 激活是 RMI 的一个过时部分，自 Java 8 以来一直是可选的。它允许 RMI 服务器 JVM 在收到来自客户端的请求时启动（“激活, activated”），而不是要求 RMI 服务器 JVM 连续运行。RMI 的其他部分并未弃用。

### 已弃用的 NSWindowStyleMaskTexturedBackground

**【文档】**

升级用于构建 JDK 的 macOS SDK 后，`apple.awt.brushMetalLook` 和 `textured` Swing 属性的行为发生了变化。设置这些属性后，框架的标题仍然可见。建议将该 `apple.awt.transparentTitleBar ` 属性设置为 `true` 使框架的标题再次不可见。`apple.awt.fullWindowContent` 也可以使用该属性。

请注意，`Textured window` 支持是通过使用 `NSWindowStyleMask` 的 `NSTexturedBackgroundWindowMask`值实现的。但是，这在 macOS 10.12 中已和在 macOS 10.14 中已被弃用的`NSWindowStyleMaskTexturedBackground` 一起被弃用。

### 不推荐使用 -XXForceNUMA 选项

**【HotSpot / gc】**

不推荐使用VM 选项 `ForceNUMA`。使用此选项将产生弃用警告。此选项将在未来的版本中删除。

默认情况下始终禁用此选项。它的存在是为了支持在单节点 / UMA 平台上运行时测试与 NUMA 相关的代码路径。

### 禁用偏向锁定和不推荐使用的偏向锁定标志

**【HotSpot / 运行时】**

在此版本中，默认情况下已禁用偏向锁定。此外，VM 选项 `UseBiasedLocking` 以及 VM 选项 `BiasedLockingStartupDelay`、`BiasedLockingBulkRebiasThreshold`、`BiasedLockingBulkRevokeThreshold`、`BiasedLockingDecayTime` 和 `UseOptoBiasInlining` 已被弃用。这些选项将继续按预期工作，但在使用时会生成弃用警告。

偏向锁定可能会影响表现出大量非竞争同步的应用程序的性能，例如依赖于每次访问时同步的旧 Java Collections API 的应用程序。这些 API 例如 `Hashtable ` 和 `Vector` 。在命令行上使用 `-XX:+BiasedLocking` 可重新启用偏向锁定。在禁用偏向锁定的情况下有显着的性能回归请向 Oracle 报告。

### 默认禁用本机 SunEC 实现

**【安全库 / javax.crypto】**

SunEC 加密提供商不再宣传未使用现代公式和技术实现的曲线。本说明底部列出的任意曲线和命名曲线均已禁用。SunEC 仍然支持和启用常用的命名曲线 secp256r1、secp384r1、secp521r1、x25519 和 x448，因为它们使用现代技术。仍需要 SunEC 提供程序禁用的曲线的应用程序可以通过将 System 属性 `jdk.sunec.disableNative` 设置为 `false` 来重新启用它们。例如：`java -Djdk.sunec.disableNative=false ...`。

如果此属性设置为任何其他值，则曲线将保持禁用状态。禁用曲线时引发的异常将包含消息 `Legacy SunEC curve disabled`，后跟曲线名称。受更改影响的方法是`KeyPair.generateKeyPair()`、`KeyAgreement.generateSecret()`、`Signature.verify()` 和 `Signature.sign()`. 当曲线不受支持时，这些方法会抛出与之前相同的异常类。

### 为先前弃用的 ContentSigner API 添加了 forRemoval=true

**【安全库 / jdk.security】**

`com.sun.jarsigner` 包中的 `ContentSigner` 和 `ContentSignerParameters` 类支持替代签名者，并且已和 `forRemoval=true` 一起被弃用。当 `-altsigner` 或者 `-altsignerpath` 选项被指定时，`jarsigner` 工具会发出警告，指出这些选项已弃用并将被删除。



## JDK 14

### 弃用线程挂起/恢复以删除

**【核心库 / java.lang】**

以下与线程暂停相关的方法在此版本 `java.lang.Thread` 中 `java.lang.ThreadGroup` 已被最终弃用：

- `Thread.suspend()`
- `Thread.resume()`
- `ThreadGroup.suspend()`
- `ThreadGroup.resume()`
- `ThreadGroup.allowThreadSuspension(boolean)`

这些方法将在未来的版本中删除。

### 不推荐使用 NSWindowStyleMaskTexturedBackground

**【客户端库 / javax.swing】**

升级用于构建 JDK 的 macOS SDK 后，Swing 属性 `apple.awt.brushMetalLook` 和 `textured` 的行为发生了变化。设置这些属性后，框架的标题仍然可见。建议将该 `apple.awt.transparentTitleBar` 属性设置为 `true` 使框架的标题再次不可见。也可以使用 `apple.awt.fullWindowContent` 属性。

请注意，`Textured window` 支持是通过使用 `NSWindowStyleMask` 的 `NSTexturedBackgroundWindowMask` 值实现的。但是，这在 macOS 10.12 中已被弃用，和在 macOS 10.14 中已被弃用的 `NSWindowStyleMaskTexturedBackground` 一起。

### JEP 366 弃用 ParallelScavenge + SerialOld GC 组合

**【HotSpot / gc】**

ParallelScavenge + SerialOld 垃圾收集器组合已被弃用。任何 `UseParallelOldGC` 用于启用此垃圾收集算法组合的命令行选项的使用都会导致弃用警告。

直接替换是 `-XX:+UseParallelGC` 在命令行上使用 ParallelScavenge + ParallelOld 垃圾收集器。

### 弃用了旧版椭圆曲线以进行删除

**【安全库 / javax.crypto】**

`SunEC` 提供程序支持的以下命名椭圆曲线已被弃用：

brainpoolP256r1，brainpoolP320r1，brainpoolP384r1，brainpoolP512r1，secp112r1，secp112r2，secp128r1，secp128r2，secp160k1，secp160r1，secp160r2，secp192k1，secp192r1，secp224k1，secp224r1，secp256k1，sect113r1，sect113r2，sect131r1，sect131r2，sect163k1，sect163r1，sect163r2，sect193r1，sect193r2， sect233k1，sect233r1，sect239k1，sect283k1，sect283r1，sect409k1，sect409r1，sect571k1，sect571r1，X9.62 c2tnb191v1，X9.62 c2tnb191v2，X9.62 c2tnb191v3，X9.62 c2tnb239v1，X9.62 c2tnb239v2，X9.62 c2tnb239v3，X9。 62 c2tnb359v1, X9.62 c2tnb431r1, X9.62 prime192v2, X9.62 prime192v3, X9.62 prime239v1, X9.62 prime239v2, X9.62 prime239v3

这些曲线的实现将在后续 JDK 版本中删除。其中一小部分可能会被更现代的实现所取代。

### 弃用 OracleUcrypto JCE 提供程序以删除

**【安全库 / javax.crypto】**

OracleUcrypto JCE Provider 及其包含的模块 `jdk.crypto.ucrypto` 已被弃用，并可能在 JDK 的未来版本中被删除。



## JDK 13

### macOS 上已弃用且不受支持的 Swing Motif 外观

**【客户端库】**

JDK 13 中的 macOS 不支持 Swing Motif 外观（Look and Feel）。

在源代码中，不推荐使用 Swing Motif 外观，目的是在未来的版本中将其删除。改为使用 `javax.swing.plaf.metal.MetalLookAndFeel`。

### 已弃用的 rmic 删除工具

**【核心库 / java.rmi】**

*rmic* 工具已被弃用，可能会从未来的版本中删除。*rmic* 工具用于创建支持 Java 远程方法调用 (RMI) 工具使用的 Java 远程方法协议 (JRMP) 的静态存根（static stub）。静态生成的存根已过时，在 Java SE 5.0 中被动态生成的存根取代。动态生成的存根不再需要使用诸如 *rmic 之*类的工具进行预生成，它们在功能上等同于静态生成的存根。应该通过更改远程对象的导出方式来迁移 RMI 应用程序以使用动态生成的 RMI 存根。有关更多详细信息，请参阅类文档`java.rmi.server.UnicastRemoteObject`。

### 不推荐使用的 Java 选项 -Xverifynone 和 -noverify

**【HotSpot / 运行时】**

Java 选项在此版本 `-Xverify:none` 中 `-noverify` 已被弃用。这些选项将继续按预期工作，但在使用时会生成以下警告：

```
warning: Options -Xverify:none and -noverify were deprecated in JDK 13 and will likely be removed in a future release.
```

弃用这些选项有助于防止用户运行违反 JVM 规范的代码，这会使他们的应用程序对恶意代码开放。

需要在没有启动验证的情况下运行的用户可以使用 AppCDS 来归档他们的课程。这些类在归档期间进行验证，并避免在运行时进行验证。

请注意，如果您在使用这些选项中的任何一个时遇到问题，您很可能需要在不使用这些选项的情况下重现问题，然后 Oracle 支持部门才能协助调查。

### 不推荐使用 forRemoval=true 的 javax.security.cert API

**【安全库 / javax.net.ssl】**

`javax.security.cert` API 已被弃用并标记为以后删除。不应再使用此包中的类。`java.security.cert` 包装中包含合适的替代品。



## JDK 12

### 弃用 -XX+/-MonitorInUseLists

**【HotSpot / 运行时】**

VM 选项 `-XX:-MonitorInUseLists `在 JDK 12 中已过时并被忽略。使用此标志将导致发出警告。在未来的版本中，此选项可能会完全删除。

### 弃用默认 Keytool -keyalg 值

**【安全库 / java.security】**

`-genkeypair` 和 `-genseckey` 命令的默认 `-keyalg` 值已弃用。如果用户没有明确指定 `-keyalg` 选项的值，则会显示警告。还将打印附加信息文本，显示新生成的条目使用的算法。在后续的 JDK 版本中，将不再支持默认密钥算法值，并且将需要 `-keyalg` 选项。



## JDK 11

### ThreadPoolExecutor 不应该指定对终结的依赖

**【核心库 / java.util.concurrent】**

以前版本的 ThreadPoolExecutor 有一个关闭线程池的 finalize 方法，但在这个版本中，finalize 方法什么都不做。除非子类显式调用 finalize 方法并依赖于正在关闭的执行程序，否则这应该没有可见的效果。

### 不推荐使用 NSWindowStyleMaskTexturedBackground

**【客户端库 / javax.swing】**

升级用于构建 JDK 的 macOS SDK 后，`apple.awt.brushMetalLook` 和 `textured` Swing 属性的行为发生了变化。设置这些属性后，框架的标题仍然可见。建议将该 `apple.awt.transparentTitleBar` 属性设置为 `true` 使框架的标题再次不可见。也可以使用 `apple.awt.fullWindowContent` 属性。

请注意，`Textured window` 支持是通过使用 `NSTexturedBackgroundWindowMask` 的 `NSWindowStyleMask` 值实现的。但是，这在 macOS 10.12 中已被弃用，而在 macOS 10.14 中 `NSWindowStyleMaskTexturedBackground` 一同也已被弃用。

### JEP 335 弃用 Nashorn JavaScript 引擎

**【文档】**

弃用 Nashorn JavaScript 脚本引擎和 API 以及 jjs 工具，以便在未来的版本中删除它们 ( JEP 335 )。

Nashorn JavaScript 引擎实现、API 和 `jjs` shell 工具已被弃用，可能会在未来的版本中被删除。使用来自 `jdk.nashorn.api.scripting` 和 `jdk.nashorn.api.tree`  包的类和接口的代码将从`javac` 得到一个弃用警告。

Nashorn 引擎（由 `javax.script` API 或 `jrunscript` 工具使用时）以及 `jjs` shell 工具将打印有关弃用的警告消息。要禁用此运行时警告消息，用户可以包含新的 Nashorn 选项，`--no-deprecation-warning`。这对于依赖于精确输出的兼容性脚本可能很有用（例如，避免警告破坏其预期的精确输出）。

### 弃用 -XX+AggressiveOpts

**【HotSpot / 编译器】**

VM 选项 `-XX:+AggressiveOpts` 在 JDK 11 中已弃用，并将在未来的版本中删除。该选项最初应该启用 C2 编译器的实验优化，以提高特定基准测试的性能。随着时间的推移，大多数功能已被删除或集成，导致选项的行为定义不明确且容易出错。该标志当前具有的唯一效果是设置 `AutoBoxCacheMax` 为 20000 和`BiasedLockingStartupDelay` 为 500。可以通过从命令行设置它们相应的标志来实现相同的配置。因此，`-XX:+AggressiveOpts` 在未来的版本中将不再可用。

### 对商业功能的过时支持

**【HotSpot / 运行时】**

`-XX:+UnlockCommercialFeatures` 和 `-XX:+LogCommercialFeatures` 命令行参数已被废弃。如果使用将生成警告消息。用于控制 VM 中商业/许可功能的使用和日志记录的命令行参数。由于不再有此类功能，因此命令行参数不再有用。

同样，`VM.unlock_commercial_features` 和 `VM.check_commercial_features` jcmd 命令也将生成警告消息，但没有额外的效果。

### 弃用基于流的 GSSContext 方法

**【安全库 / org.ietf.jgss】**

`GSSContext` 由于 GSS-API 适用于不透明令牌并且未定义有线协议，因此此版本中已弃用基于流的方法。这包括 `initSecContext`, `acceptSecContext`, `wrap`, `unwrap`,`getMIC` 和 `verifyMIC` 具有 `InputStream` 参数的方法的重载形式。这些方法已在 RFC 8353 中删除。

### JEP 336 弃用 Pack200 工具和 API

**【工具】**

弃用 `pack200` 和 `unpack200` 工具，以及 `java.util.jar` 中的 Pack200 API ( JEP 336 )。

`pack200` API 和与之关联的工具`pack200` 和 `unpack200` 已被弃用，并将在未来的版本中删除。

这些工具仍包含在 JDK 11 中，但将不再更新以支持最新的类文件格式。具有未知属性的类文件将被传递而不压缩。



## JDK 10

### SNMP 监控支持已弃用以移除

**【核心svc / javax.management】**

为 Java 虚拟机提供 SNMP 监控和管理支持的 `jdk.snmp` 模块已被弃用，并计划在未来的版本中删除。

启用 JVM SNMP 监视时（通过 `management.properties` 配置文件中配置的 `com.sun.management.snmp.port` 属性）会发出弃用警告消息。

### java.security.{Certificate,Identity,IdentityScope,Signer} APIs 不推荐使用

**【安全库/java.security】**

已弃用的 `java.security.{Certificate, Identity, IdentityScope, Signer} `类已被标记 `forRemoval=true`，并且可能会在 Java SE 的未来版本中被删除。

### java.security.acl APIs 不推荐以移除

**【安全库/java.security】**

已弃用的 `java.security.acl` API 已被标记 `forRemoval=true`，并且可能会在 Java SE 的未来版本中被删除。

###  javax.security.auth.Policy API 不推荐用于移除

**【安全库/java.security】**

已弃用的 `javax.security.auth.Policy` 类已被标记 `forRemoval=true`，并将在未来的版本中删除。自 JDK 1.4 以来，`javax.security.auth.Policy` 类已被弃用，并被 `java.security.Policy` 替代.



## JDK 9

### 弃用 Java 插件

在 Oracle 的 JDK 9 版本中弃用 Java 插件和相关的小程序技术。虽然在 JDK 9 中仍然可用，但将考虑在未来的版本中从 Oracle JDK 和 JRE 中删除这些技术。

嵌入网页的小程序和 JavaFX 应用程序需要 Java 插件才能运行。考虑将这些类型的应用程序重写为 Java Web Start 或自包含应用程序。

### JEP 289：弃用 Applet API

弃用 Applet API，随着 Web 浏览器供应商取消对 Java 浏览器插件的支持，Applet API 变得不那么有用。虽然在 JDK 9 中仍然可用，但Applet类将考虑在未来的版本中删除。考虑将小程序重写为 Java Web Start 或自包含应用程序。

### JEP 291：弃用并发标记扫描 (CMS) 垃圾收集器

弃用并发标记扫描 (CMS) 垃圾收集器。`-XX:+UseConcMarkSweepGC` 使用该选项在命令行上请求时会发出警告消息。Garbage-First (G1) 垃圾收集器旨在替代 CMS 的大多数用途。





# JDK 9 ~ 17 各个版本的其他新特性



## JDK 17

### 用于访问大图标的新 API

**【客户端库 / javax.swing】**

JDK 17 中提供了一种新方法，`javax.swing.filechooser.FileSystemView.getSystemIcon(File, int, int)` 可以在可能的情况下访问更高质量的图标。这个方法完全针对 Windows 平台实现，其他平台上的结果可能会有所不同但以后会得到增强。例如，通过使用以下代码：

```java
FileSystemView fsv = FileSystemView.getFileSystemView();
Icon icon = fsv.getSystemIcon(new File("application.exe"), 64, 64);
JLabel label = new JLabel(icon);
```

用户可以获得更高质量的“application.exe”文件图标。此图标适用于创建可以在 HighDPI 环境中更好地缩放的标签。

### DatagramSocket 可以直接用于加入多播组

**【核心库 / java.net】**

`java.net.DatagramSocket` 已在此版本中更新以添加对加入多播组（multicast groups）的支持。它现在定义了加入和离开多播组的方法 `joinGroup`。`leaveGroup` 的类级别 API 文档 `java.net.DatagramSocket` 已更新，以解释如何 `DatagramSocket` 配置并使用普通文本加入和离开多播组。

此更改意味着`DatagramSocket` API 可用于多播应用程序，而无需使用旧版 `java.net.MulticastSocket` API。尽管它的 `MulticastSocket` 大多数方法都已弃用，但 API 像以前一样工作。

### 在 macOS 上添加对 UserDefinedFileAttributeView 的支持

**【核心库 / java.nio】**

macOS 上的文件系统提供程序实现已在此版本中更新，以支持扩展属性。`java.nio.file.attribute.UserDefinedFileAttributeView` API 现在可用于获取文件扩展属性的视图（view）。以前的 JDK 版本不支持此（可选）视图。

###  ARM 上的 macOS 早期访问（Early Access）可用

**【基础设施 / 建设】**

新的 macOS 现在可用于 ARM 系统。ARM 端口的行为应与 Intel 端口类似。没有已知的功能差异。在 macOS 上报告问题时，请指定是使用 ARM 还是 x64。

### 支持在 Keytool -genkeypair 命令中指定签名者

**【安全库 / java.security】**

`-signer` 和 `-signerkeypass` 选项已添加到 `keytool` 功能的 `-genkeypair` 命令中。`-signer` 选项指定签名者的 `PrivateKeyEntry` 密钥库别名，`-signerkeypass` 选项指定用于保护签名者私钥的密码。这些选项允许 `keytool -genkeypair` 使用签名者的私钥对证书进行签名。这对于使用密钥协商算法作为其公钥算法生成证书特别有用。

### SunJCE Provider 使用 AES 密码支持 KW 和 KWP 模式

**【安全库 / javax.crypto】**

SunJCE 提供程序已得到增强，以支持 AES 密钥包装算法 (RFC 3394) 和 AES 带填充算法的密钥包装 (RFC 5649)。在早期版本中，SunJCE 提供程序在“AESWrap”密码算法下支持 RFC 3394，该算法只能用于包装和解包密钥。通过此增强功能，添加了两种分组密码模式 KW 和 KWP，它们支持使用 AES 进行数据加密/解密和密钥打包/解包。

### 新的 SunPKCS11 配置属性

**【安全库 / javax.crypto : pkcs11】**

SunPKCS11 提供程序添加了新的提供程序配置属性，以更好地控制本机资源的使用。SunPKCS11 提供程序使用本机资源以使用本机 PKCS11 库。为了管理和更好地控制原生资源，增加了额外的配置属性来控制清除原生引用的频率以及注销后是否销毁底层PKCS11 Token。

SunPKCS11 提供程序配置文件的 3 个新属性是：

1. `destroyTokenAfterLogout`（布尔值，默认为 false）如果设置为 true，`java.security.AuthProvider.logout()` 则在调用 SunPKCS11 提供程序实例时，将销毁底层 Token 对象并释放资源。这实质上使 SunPKCS11 提供程序实例在 logout() 调用后无法使用。请注意，不应将此属性设置为 true 的 PKCS11 提供程序添加到系统提供程序列表中，因为提供程序对象在 logout() 方法调用后不可用。
2. `cleaner.shortInterval`（整数，默认为2000，以毫秒为单位）这定义了在繁忙期间清除本地引用的频率，即清理线程应该多久处理一次队列中不再需要的本地引用以释放本地内存。请注意，清洁线程将在 200 次失败尝试后切换到 “longInterval” 频率，即在队列中没有找到引用时。
3. `cleaner.longInterval`（整数，默认为 60000，以毫秒为单位）这定义了在非忙碌期间检查原生引用的频率，即清理线程应该多久检查一次队列中的原生引用。请注意，如果检测到用于清理的本机 PKCS11 引用，则清理线程将切换回 “shortInterval” 值。

### 如果 PKCS11 库支持，SunPKCS11 提供程序支持 ChaCha20-Poly1305 Cipher 和 ChaCha20 KeyGenerator

**【安全库 / javax.crypto : pkcs11】**

当底层 PKCS11 库支持相应的 PKCS#11 机制时，SunPKCS11 提供程序得到增强以支持以下加密服务和算法：

- ChaCha20 KeyGenerator <=> CKM_CHACHA20_KEY_GEN 机制
- CHACHA20-POLY1305 密码 <=> CKM_CHACHA20_POLY1305 机制
- CHACHA20-POLY1305 算法参数 <=> CKM_CHACHA20_POLY1305 机制
- CHACHA20 SecretKeyFactory <=> CKM_CHACHA20_POLY1305 机制

### 具有系统属性的可配置扩展

**【安全库 / javax.net.ssl】**

添加了两个新的系统属性。系统属性 `jdk.tls.client.disableExtensions` 用于禁用客户端中使用的 TLS 扩展。系统属性 `jdk.tls.server.disableExtensions` 用于禁用服务器中使用的 TLS 扩展。如果扩展被禁用，它将不会在握手消息中生成或处理。

属性字符串是逗号分隔的标准 TLS 扩展名列表，在 IANA 文档中注册（例如，server_name、status_request 和 signature_algorithms_cert）。请注意，扩展名区分大小写。未知、不受支持、拼写错误和重复的 TLS 扩展名令牌将被忽略。

请注意，阻止 TLS 扩展的影响是复杂的。例如，如果禁用强制扩展，则可能无法建立 TLS 连接。请不要禁用强制扩展，也不要使用此功能，除非您清楚了解其影响。

### 如果 default_tkt_enctypes 或 default_tgs_enctypes 不存在，则使用 allowed_enctypes

**【安全库 / org.ietf.jgss : krb5】**

使用 allowed_enctypes 作为 default_tkt_enctypes 或 default_tgs_enctypes 的默认值（如果它们中的任何一个未在 krb5.conf 中定义）。



## JDK 16

### JEP 380：Unix 域套接字

**【核心库 / java.nio】**

`java.nio.channels`在、`SocketChannel`和`ServerSocketChannel`类中提供对 Unix 域套接字 (AF_UNIX) 的支持。

### 默认启用新的 jdk.ObjectAllocationSample 事件

**【HotSpot / jfr】**

引入了一个新的 JFR 事件 ，`jdk.ObjectAllocationSample`，以允许始终在线（always-on）、低开销（low-overhead）的分配分析。该事件在`default` 和 `profile` 配置中都被启用，最大速率分别为 150 和 300 个事件/秒。事件 `jdk.ObjectAllocationInNewTLAB` 以及 `jdk.ObjectAllocationOutsideTLAB` 详细描述了内存分配，但开销相对较高。它们以前在 `default` 配置中被禁用，但现在也在 `profile` 配置中被禁用以进一步减少开销。

此更改的影响可以在 JDK Mission Control (JMC) 8.0 或更早版本中看到，其中“TLAB 分配”页面将丢失数据。建议在 `jdk.ObjectAllocationSample` 支持可用时升级到更高版本的 JMC 。同时，可以在 JMC 录制向导（recording wizard）中启用 `jdk.ObjectAllocationInNewTLAB` 和 `jdk.ObjectAllocationOutsideTLAB` 事件，或手动编辑 .jfc 文件。

### 对 RSASSA-PSS 和 EdDSA 的签名 JAR 支持

**【安全库 / java.security】**

此增强功能包括两个主要更改：

1. JarSigner API 和 `jarsigner` 工具现在支持使用 RSASSA-PSS 或 EdDSA 密钥对 JAR 文件进行签名。
2. `.SF `不是直接对文件进行签名，而是 `jarsigner` 创建一个 SignerInfo signedAttributes 字段，包含 ContentType、MessageDigest、SigningTime 和 CMSAlgorithmProtection 。如果 `jarsigner -altsigner` 选项指定了替代签名机制，则不会生成该字段。请注意，虽然此字段在此代码更改之前并不是由 `jarsigner` 生成，但此前在解析签名时一直支持。这意味着带有该字段的新签名的 JAR 文件可以通过早期的 JDK 版本进行验证。

### SUN、SunRsaSign 和 SunEC 提供程序支持基于 SHA-3 的签名算法

**【安全库 / java.security】**

SUN、SunRsaSign 和 SunEC 提供程序（provider）已得到增强，以支持基于 SHA-3 的签名算法。现在通过这些提供程序支持具有 SHA-3 系列摘要的 DSA 签名、RSA 和 ECDSA 签名实现。此外，当在签名参数中指定时，来自 SunRsaSign 提供程序的 RSASSA-PSS 签名实现可以识别 SHA-3 系列摘要。

### jarsigner 保留 POSIX 文件权限和符号链接属性

**【安全库 / java.security】**

在对包含 POSIX 文件权限或符号链接属性的文件进行签名时，`jarsigner` 现在将这些属性保留在新签名的文件中，但会警告这些属性未签名且不受签名保护。 `jarsigner -verify` 在此类文件的操作过程中会打印相同的警告。

请注意，该 `jar `工具不会读取/写入这些属性。`unzip` 对于保留这些属性的工具，这种变化更加明显。

### 在 keytool -printcert 和 -printcrl 命令中添加了 -trustcacerts 和 -keystore 选项

**【安全库 / java.security】**

`-trustcacerts` 和 `-keystore` 选项已添加到 `keytool` 实用程序的 `-printcert` 和 `-printcrl` 命令中。如果证书是用户密钥库或 `cacerts` 密钥库中的受信任证书，`-printcert` 命令不会检查证书签名算法的弱点。 `-printcrl` 命令使用来自用户密钥库或 `cacerts` 密钥库的证书验证 CRL，如果无法验证，将打印出警告。

### SunPKCS11 Provider 支持 SHA-3 相关算法

**【安全库 / javax.crypto】**

SunPKCS11 提供程序已更新支持 SHA-3 算法。还添加了对使用 SHA-3 以外的消息摘要的 Hmac 的附加 KeyGenerator 支持。当底层 PKCS11 库支持相应的 PKCS11 机制时，SunPKCS11 提供程序现在支持以下附加算法：

- 消息摘要：SHA3-224、SHA3-256、SHA3-384、SHA3-512
- Mac：HmacSHA3-224、HmacSHA3-256、HmacSHA3-384、HmacSHA3-512
- 签名：SHA3-224withDSA，SHA3-256withDSA，SHA3-384withDSA，SHA3-512withDSA，SHA3-224withDSAinP1363Format，SHA3-256withDSAinP1363Format，SHA3-384withDSAinP1363Format，SHA3-512withDSAinP1363Format，SHA3-224withECDSA，SHA3-256withECDSA，SHA3-384withECDSA，SHA3-512withECDSA， SHA3-224withECDSAinP1363Format，SHA3-256withECDSAinP1363Format，SHA3-384withECDSAinP1363Format，SHA3-512withECDSAinP1363Format，SHA3-224withRSA，SHA3-256withRSA，SHA3-384withRSA，SHA3-512withRSA，SHA3-224withRSASSA-PSS，SHA3-256withRSASSA-PSS，SHA3-384withRSASSA-PSS， SHA3-512 和 RSASSA-PSS。
- 密钥生成器：HmacMD5、HmacSHA1、HmacSHA224、HmacSHA256、HmacSHA384、HmacSHA512、HmacSHA512/224、HmacSHA512/256、HmacSHA3-224、HmacSHA3-256、HmacSHA3-384、HmacSHA3-512。

### 改进证书链处理

**【安全库 / javax.net.ssl】**

添加了一个新的系统属性 ，`jdk.tls.maxHandshakeMessageSize ` 以设置 TLS/DTLS 握手中握手消息的最大允许大小。系统属性的默认值为 32768（32 KB）。

添加了一个新的系统属性 ，`jdk.tls.maxCertificateChainLength` 用于设置 TLS/DTLS 握手中证书链的最大允许长度。系统属性的默认值为 10。

### 改进 TLS 应用层协议协商 (ALPN) 值的编码

**【安全库 / javax.net.ssl】**

SunJSSE 提供程序无法正确读取或写入某些 TLS ALPN 值。这是由于选择字符串作为 API 接口以及未记录的内部使用 UTF-8 字符集，它将大于 U+00007F（7 位 ASCII）的字符转换为多字节数组，这可能不是同行。

ALPN 值现在使用对等方期望的网络字节表示来表示，对于标准的 7 位基于 ASCII 的字符串应该不需要修改。但是，SunJSSE 现在将字符串字符编码/解码为 8 位 ISO_8859_1/LATIN-1 字符。这意味着使用 U+000007F 以上字符且之前使用 UTF-8 编码的应用程序可能需要修改以执行 UTF-8 转换，或者将 Java 安全属性设置 *`jdk.tls.alpnCharset`* 为 “UTF-8” 恢复行为。

### EdDSA 签名算法的 TLS 支持

**【安全库 / javax.net.ssl】**

SunJSSE 提供程序现在支持使用 EdDSA 签名算法。具体来说，SunJSSE 可以使用包含 EdDSA 密钥的证书进行服务器端和客户端身份验证，并且可以使用用 EdDSA 算法签名的证书。此外，需要数字签名的 TLS 握手消息支持 EdDSA 签名。



## JDK 15

### 添加了对 SO_INCOMING_NAPI_ID 的支持

**【核心库 / java.net】**

此版本中 `SO_INCOMING_NAPI_ID` 添加了一个新的特定于 JDK 的套接字选项。`jdk.net.ExtendedSocketOptions` 套接字选项是 Linux 特定的，允许应用程序查询与其套接字连接关联的底层设备队列的 NAPI（新 API）ID，并利用高性能网络接口卡 (NIC) 设备的应用程序设备队列 (ADQ) 功能.

### 添加了为远程 JMX 配置第三个端口的功能

**【核心svc / javax.management】**

通过设置以下属性，JMX 通过配置两个网络端口（从命令行或在属性文件中）支持（显式）远程网络访问：

```properties
com.sun.management.jmxremote.port=<port#>
com.sun.management.jmxremote.rmi.port=<port#>
```

注意：如果未指定，则第二个端口将默认为第一个。

还打开了第三个本地端口以接受（本地）JMX 连接。该端口之前是随机选择的，这可能会导致端口冲突。

但是，现在可以使用以下方法配置第三个 JMX 端口（仅限本地）：

~~~properties
com.sun.management.jmxremote.local.port=<port#>
~~~

### 为 jstatd 添加了用于指定 RMI 连接器端口号的新选项

**【核心svc / 工具】**

该命令中添加了一个新 `-r <port>` 选项，`jstatd` 用于指定 RMI 连接器端口号。如果未指定端口号，则使用随机可用端口。

### 为 jcmd 添加了用于编写 gzipped 堆转储的新选项

**【核心svc / 工具】**

诊断命令 `gz` 中添加了一个新的整数选项。`GC.heap_dump` 如果指定，它将启用写入堆转储的 gzip 压缩。提供的值是压缩级别。它的范围可以从 1（最快）到 9（最慢，但最好的压缩）。推荐级别为 1。

### 为调试模式添加到 jhsdb 的新选项

**【HotSpot / svc代理】**

`jhsdb` 调试模式的命令中添加了三个新选项：

1. `--rmiport <port> `用于指定 RMI 连接器端口号。如果未指定端口号，则使用随机可用端口。
2. `--registryport <port> `用于指定 RMI 注册表端口号。此选项覆盖系统属性 `sun.jvm.hotspot.rmi.port`。如果未指定端口号，则使用系统属性。如果未设置系统属性，则使用默认端口 1099。
3. `--hostname <hostname>` 用于指定 RMI 连接器主机名。该值可以是主机名或 IPv4/IPv6 地址。此选项覆盖系统属性 `java.rmi.server.hostname`。如果未指定主机名，则使用系统属性。如果未设置系统属性，则使用系统主机名。

### 适用于 Windows 的 Oracle JDK 安装程序在可从任何命令提示符访问的路径中提供可执行文件（javac 等）

**【安装 / 安装】**

适用于 Windows 的 Oracle JDK 安装程序在系统位置提供 `java.exe`、`javaw.exe`、`javac.exe` 和 `jshell.exe` 命令，以便用户可以运行 Java 应用程序，而无需提供 Oracle JDK 安装文件夹的路径。

### 为 jarsigner 添加了撤销检查

**【安全库 / java.security】**

该命令中添加了一个新 `-revCheck` 选项，`jarsigner` 以启用证书的吊销检查。

### 如果使用了弱算法，工具会发出警告

**【安全库 / java.security】**

和工具已更新，可在密钥、证书和签名 JAR 中使用弱加密算法时警告用户，然后再禁用它们 `keytool`。`jarsigner` 弱算法在配置文件的 `jdk.security.legacyAlgorithms` 安全属性中设置。`java.security` 在此版本中，这些工具会针对 SHA-1 哈希算法和 1024 位 RSA/DSA 密钥发出警告。

### SunJCE Provider 支持基于 SHA-3 的 Hmac 算法

**【安全库 / javax.crypto】**

SunJCE 提供程序已得到增强，以支持 HmacSHA3-224、HmacSHA3-256、HmacSHA3-384 和 HmacSHA3-512。这些算法的实现在 Mac 和 KeyGenerator 服务下可用。Mac 服务生成 keyed-hash，而 KeyGenerator 服务为 Mac 生成密钥。

### 用于配置 TLS 签名方案的新系统属性

**【安全库 / javax.net.ssl】**

添加了两个新的系统属性来自定义 JDK 中的 TLS 签名方案。`jdk.tls.client.SignatureSchemes` 已为 TLS 客户端添加，并 `jdk.tls.server.SignatureSchemes` 已为服务器端添加。

每个系统属性都包含一个以逗号分隔的受支持签名方案名称列表，指定可用于 TLS 连接的签名方案。

### 支持 certificate_authorities 扩展

**【安全库 / javax.net.ssl】**

“certificate_authorities” 扩展是 TLS 1.3 中引入的可选扩展。它用于指示端点支持的证书颁发机构 (CA)，接收端点应使用它来指导证书选择。

在此 JDK 版本中，客户端和服务器端都支持 TLS 1.3 的 “certificate_authorities” 扩展。此扩展始终存在于客户端证书选择中，而对于服务器证书选择是可选的。

`jdk.tls.client.enableCAExtension` 应用程序可以通过将系统属性设置为 来启用此扩展以进行服务器证书选择 `true`。该属性的默认值为 `false`。

请注意，如果客户端信任的 CA 超过扩展的大小限制（小于 2^16 字节），则不会启用扩展。此外，一些服务器实现不允许握手消息超过 2^14 字节。因此，当 `jdk.tls.client.enableCAExtension` 设置为 `true` 并且客户端信任的 CA 多于服务器实现限制时，可能会出现互操作性问题。

### 支持 krb5.conf 中的规范化

**【安全库 / org.ietf.jgss : krb5】**

JDK Kerberos 实现现在支持 krb5.conf 文件中的 “canonicalize” 标志。当设置为 *true* 时，客户端在对 KDC 服务（AS 协议）的 TGT 请求中请求 RFC 6806名称规范化。否则，默认情况下，不请求它。

新的默认行为不同于 JDK 14 和以前的版本，在这些版本中，客户端始终在对 KDC 服务的 TGT 请求中请求名称规范化（前提是未使用 *sun.security.krb5.disableReferrals* 系统或安全属性明确禁用对 RFC 6806 的支持）。

### 支持跨域MSSFU

**【安全库 / org.ietf.jgss : krb5】**

对 Kerberos MSSFU 扩展 [1] 的支持现在扩展到跨领域环境。

通过利用在 JDK-8215032 的上下文中引入的 Kerberos 跨领域引用增强功能，可以使用 “S4U2Self” 和 “S4U2Proxy” 扩展来模拟位于不同领域的用户和服务主体。



## JDK 14

### 默认禁用 TLS、CertPath 和签名 JAR 中的弱命名曲线

**【安全库 / java.security】**

默认情况下，通过将弱命名曲线添加到以下 `disabledAlgorithms` 安全属性来禁用它们：`jdk.tls.disabledAlgorithms`、`jdk.certpath.disabledAlgorithms` 和 `jdk.jar.disabledAlgorithms`。下面列出了命名曲线。

有 47 条弱命名曲线被禁用，向每个 `disabledAlgorithms` 属性添加单独的命名曲线将是压倒性的。为了缓解这个问题，`jdk.disabled.namedCurves` 实现了一个新的安全属性 ，它可以列出所有 `disabledAlgorithms` 属性共有的命名曲线。要在属性中使用新属性 `disabledAlgorithms`，请在完整属性名称前加上关键字 `include`。用户仍然可以将单独的命名曲线添加到 `disabledAlgorithms` 与此新属性分开的属性中。属性中不能包含其他 `disabledAlgorithms` 属性。

要恢复命名曲线，请 `include jdk.disabled.namedCurves` 从特定或所有 `disabledAlgorithms` 安全属性中删除。要恢复一条或多条曲线，请从 `jdk.disabled.namedCurves `属性中删除特定的命名曲线。

曲线被禁用通过 `jdk.disabled.namedCurves` 包括以下：secp112r1，secp112r2，secp128r1，secp128r2，secp160k1，secp160r1，secp160r2，secp192k1，secp192r1，secp224k1，secp224r1，secp256k1，sect113r1，sect113r2，sect131r1，sect131r2，sect163k1，sect163r1，sect163r2，sect193r1，sect193r2 ，sect233k1，sect233r1，sect239k1，sect283k1，sect283r1，sect409k1，sect409r1，sect571k1，sect571r1，X9.62 c2tnb191v1，X9.62 c2tnb191v2，X9.62 c2tnb191v3，X9.62 c2tnb239v1，X9.62 c2tnb239v2，X9.62 c2tnb239v3，X9 .62 c2tnb359v1，X9.62 c2tnb431r1，X9.62 prime192v2，X9.62 prime192v3，X9.62 prime239v1，X9.62 prime239v2，X9.62 prime239v3，brainpoolP256r1，brainpoolP320r1，brainpoolP384r1，brainpoolP512r1

保持启用的曲线是：secp256r1、secp384r1、secp521r1、X25519、X448

### Apache Santuario 库更新到版本 2.1.4

**【安全库 / javax.xml.crypto】**

Apache Santuario 库已升级到版本 2.1.4。因此，`com.sun.org.apache.xml.internal.security.parser.pool-size` 引入了新的系统属性。

`DocumentBuilder` 这个新的系统属性设置处理 XML 签名时使用的内部缓存的池大小。该函数等效 `org.apache.xml.security.parser.pool-size` 于 Apache Santuario 中使用的系统属性，并且具有相同的默认值 20。

### 允许默认调用可发现的 javac 插件

**【工具 / javac】**

如果没有在从命令行传递给的选项或 `options` API 调用的参数中显式传递给 `javac` 启动的情况下，javac “插件”现在可以选择默认启动。可以通过以返回 `true` 来实现 `Plugin.isDefault()` 方法以启用此行为。

### SAX ContentHandler 处理 XML 声明的新方法

**【xml / jaxp】**

`SAX ContentHandler` 添加了一个新方法  `declaration` 来接收 XML 声明的通知。通过实现此方法，应用程序可以接收与输入文档中声明的完全相同的版本、编码和独立属性的值。



## JDK 13

### CRL 的可配置读取超时

**【安全库 / java.security】**

`com.sun.security.crl.readtimeout `系统属性设置 CRL 检索的最大读取超时，以秒为单位。如果该属性尚未设置，或者其值为负数，则将其设置为默认值 15 秒。值 0 表示无限超时。

### 用于显示 TLS 配置信息的新 keytool -showinfo -tls 命令

**【安全库 / java.security】**

`keytool -showinfo -tls` 添加了一个显示 TLS 配置信息的新命令。

### 支持下一代 MS 加密 (CNG)

**【安全库 / java.crypto】**

SunMSCAPI 提供程序现在支持读取下一代加密 (Cryptography Next Generation，CNG) 格式的私钥。这意味着 CNG 格式的 RSA 和 EC 密钥可以从 Windows 密钥库中加载，例如“Windows-MY”。还支持与 EC（`SHA1withECDSA`、`SHA256withECDSA` 等）相关的签名算法。

### SunPKCS11 Provider 升级支持 PKCS#11 v2.40

**【安全库 / javax.crypto : pkcs11】**

SunPKCS11 提供程序已更新，支持 PKCS#11 v2.40。当底层 PKCS11 库支持相应的 PKCS11 机制时，此版本增加了对更多算法的支持，例如 AES/GCM/NoPadding 密码、使用 SHA-2 系列消息摘要的 DSA 签名和 RSASSA-PSS 签名。

### 支持 TLS 中的 X25519 和 X448

**【安全库 / javax.net.ssl】**

命名椭圆曲线组 `x25519` 现在 `x448` 可用于 TLS 版本 1.0 到 1.3 中的 JSSE 密钥协议，`x25519` 是默认启用的命名组中最受青睐的。现在默认的有序列表是：

```
x25519, secp256r1, secp384r1, secp521r1, x448,
 sect283k1, sect283r1, sect409k1, sect409r1, sect571k1, sect571r1,
 secp256k1,
 ffdhe2048, ffdhe3072, ffdhe4096, ffdhe6144, ffdhe8192
```

可以使用系统属性 *`jdk.tls.namedGroups`* 覆盖默认列表。

### JSSE 中没有服务器端状态的会话恢复

**【安全库 / javax.net.ssl】**

该功能允许 JSSE 的服务器端无状态运行。如 RFC 5077 及以下 TLS 1.2 和 RFC 8446 中所述，TLS 服务器以加密会话票证（session ticket）的形式将内部会话信息发送到支持无状态的客户端。该会话票证在 TLS 握手期间提供给服务器以恢复会话。这应该会提高 TLS 服务器在大型工作负载下的性能和内存使用率，因为很少使用会话缓存。由于缓存的会话信息较少，某些会话信息可能不可用。此功能默认不启用，可以通过设置两个属性来开启。

请注意，无效的无状态 TLS 会话可以在当前实现中恢复。不保证在未来的版本和更新中行为相同。

请注意，在当前实现中，`SSLSession.getID()` 对于 TLS 1.3 和无状态 TLS 1.2 连接，返回值不会在恢复之间保持不变。如果应用程序依赖会话标识符值，这可能是一个问题。这可能会更改为与未来版本一致。

添加了两个新的系统属性以支持此功能：`jdk.tls.client.enableSessionTicketExtension` 用于在客户端切换 TLS 1.2 的 ClientHello 消息上的会话票证扩展（Session Ticket Extension）。属性值：“`true`” 发送扩展名，“`false`”不发送（默认值）。

`jdk.tls.server.enableSessionTicketExtension` 如果客户端支持，则允许服务器使用无状态会话票证。不支持无状态会话票据的客户端将使用缓存。属性值：“`true`” 启用无状态，“`false`” 不启用（默认值）。

### 允许限制 SASL 机制

**【安全库 / javax.security】**

添加了一个名为的安全属性 `jdk.sasl.disabledMechanisms`，可用于禁用 SASL 机制。如果在 `Sasl.createSaslClient` 的 `mechanisms` 参数或 `Sasl.createSaslServer` 的 `mechanism` 参数中指定了任何禁用的机制，则将被忽略。此安全属性的默认值为空，这意味着没有开箱即用的机制被禁用。

### 规范 XML 1.1 URI 的新字符串常量

**【安全库 / javax.xml.crypto】**

新字符串常量 `INCLUSIVE_11` 和 `INCLUSIVE_11_WITH_COMMENTS` 已添加到 `javax.xml.crypto.dsig.CanonicalizationMethod` API。这些代表规范 XML 1.1 和规范 XML 1.1 的 URI，以及用于 XML 签名的注释算法。

### [xmldsig] 添加 KeyValueEC_TYPE

**【安全库 / javax.xml.crypto】**

现在支持 XML 签名语法和处理的 W3C 建议中描述的 `ECKeyValue` 类型。`javax.xml.crypto.dsig.keyinfo.KeyValue` 接口中添加了一个新常量 `EC_TYPE`。请注意，目前 `NamedCurve` 仅支持域参数类型，不支持 `ECParameters` 显式曲线参数类型。

### 在 Windows 上添加了默认的本机 GSS-API 库

**【安全库 / org.ietf.jgss】**

在 Windows 平台上的 JDK 中添加了原生 GSS-API 库。该库仅在客户端，并使用默认凭据。当系统属性 `sun.security.jgss.native` 设置为“true”时，它将被加载。用户仍然可以通过将系统属性 `sun.security.jgss.lib` 设置为其路径来加载第三方本机 GSS-API 库。

### 支持 Kerberos 跨领域引用 (RFC 6806)

**【安全库 / org.ietf.jgss : krb5】**

Kerberos 客户端已得到增强，支持主体名称规范化和跨领域引用，如 RFC 6806 协议扩展所定义。

由于这个新特性，Kerberos 客户端可以利用更多动态环境配置，并且不一定需要（提前）知道如何到达目标主体（用户或服务）的领域。

默认情况下启用支持，允许的最大推荐跃点数为 5。要关闭它，请将 `sun.security.krb5.disableReferrals` 安全性或系统属性设置为 false。要配置自定义最大推荐跃点数，请将 `sun.security.krb5.maxReferrals` 安全性或系统属性设置为任何正值。

### 使用命名空间支持创建 DOM 和 SAX 工厂的新方法

**【xml / jaxp】**

添加了新的方法来实例化 DOM 和 SAX 工厂，默认情况下支持命名空间。这些方法的前缀是“NS”，代表 NamespaceAware。以下是新方法的列表：

- `newDefaultNSInstance()`
- `newNSInstance()`
- `newNSInstance(String factoryClassName, ClassLoader classLoader)`

使用这些新方法，通过工厂创建的解析器将默认为 NamespaceAware。例如，以下语句：

```java
DocumentBuilder db = DocumentBuilderFactory.newDefaultNSInstance().newDocumentBuilder();
```

相当于：

```java
DocumentBuilderFactory dbf = DocumentBuilderFactory.newDefaultInstance(); 
dbf.setNamespaceAware(true); 
DocumentBuilder db = dbf.newDocumentBuilder();
```



## JDK 12

### Linux 上的POSIX_SPAWN 选项

**【核心库 / java.lang】**

作为在 Linux 上启动进程的另一种方式，该 `jdk.lang.Process.launchMechanism` 属性可以设置为 `POSIX_SPAWN`. 这个选项在其他 *nix 平台上已经存在很长时间了。Linux 上的默认启动机制 (`VFORK`) 未更改，因此此附加选项不会影响现有安装。

`POSIX_SPAWN` 减轻在产生子进程时罕见的病理情况，但尚未经过过度测试。`POSIX_SPAWN` 在生产性安装中使用时建议谨慎。

### HotSpot Windows 操作系统检测正确识别 Windows Server 2019

**【HotSpot / 运行时】**

在此修复之前，Windows Server 2019 被识别为“Windows Server 2016”，这在 `os.name` 系统属性和 `hs_err_pid` 文件中产生了不正确的值。

### 命令行标志 -XX+ExtensiveErrorReports

**【HotSpot / 运行时】**

命令行标志 `-XX:+ExtensiveErrorReports` 以允许更广泛地报告与 `hs_err<pid>.log` 文件中报告的崩溃相关的信息。在产品构建中默认禁用，可以在需要最大信息的环境中打开该标志——即使生成的日志可能非常大和/或包含可能被认为是敏感的信息。

### 禁止和允许 java.security.manager 系统属性的选项

**【安全库 / java.security】**

新的“禁止”和“允许”令牌选项已添加到 `java.security.manager` 系统属性中。在 JDK 实现中，如果 Java 虚拟机启动时系统属性 `java.security.manager` 设置为“disallow”，则 `System.setSecurityManager` 方法不能用于设置安全管理器，并且会抛出 `UnsupportedOperationException`. “disallow”选项可以提高从未设置安全管理器的应用程序的运行时性能。有关这些选项的行为的更多详细信息，请参阅 `java.lang.SecurityManager` 的类描述。

### -groupname 选项已添加到 keytool 密钥对生成

**【安全库 / java.security】**

一个新 `-groupname` 选项，`keytool -genkeypair` 以便用户在生成密钥对时可以指定命名组。例如，`keytool -genkeypair -keyalg EC -groupname secp384r1` 将使用 `secp384r1` 曲线生成一个 EC 密钥对。因为可能有多个相同大小的曲线，所以使用 `-groupname` 选项优于使用 `-keysize` 选项。

### 新的 Java Flight Recorder (JFR) 安全事件

**【安全库 / java.security】**

四个新的 JFR 事件已添加到安全库区域。这些事件默认禁用，可以通过 JFR 配置文件或通过标准 JFR 选项启用。

- `jdk.SecurityPropertyModification`
  - 记录 `Security.setProperty(String key, String value)` 方法调用
- `jdk.TLSHandshake`
  - 记录 TLS 握手活动。事件字段包括：
    - 对等主机名
    - 对等端口
    - 协商的 TLS 协议版本
    - 协商的 TLS 密码套件
    - 对等客户端的证书 ID
- `jdk.X509Validation`
  - 记录在成功的 X.509 验证（信任链）中协商的 X.509 证书的详细信息
- `jdk.X509Certificate`
  - 记录 X.509 证书的详细信息。事件字段包括：
    - 证书算法
    - 证书序列号
    - 证书科目
    - 证书颁发者
    - 钥匙类型
    - 密钥长度
    - 证书编号
    - 证书有效期

### 自定义 PKCS12 密钥库的生成

**【安全库 / java.security】**

添加了新的系统和安全属性，使用户能够自定义 PKCS #12 密钥库的生成。这包括密钥保护、证书保护和 MacData 的算法和参数。这些属性的详细说明和可能的值可以在 `java.security` 文件的 “PKCS12 KeyStore 属性” 部分中找到。

此外，SunJCE 提供程序添加了对以下基于 SHA-2 的 HmacPBE 算法的支持：HmacPBESHA224、HmacPBESHA256、HmacPBESHA384、HmacPBESHA512、HmacPBESHA512/224、HmacPBESHA512/256

###  ChaCha20 和 Poly1305 TLS

**【安全库 / javax.net.ssl】**

密码套件使用 ChaCha20-Poly1305 算法的新 TLS 密码套件已添加到 JSSE。默认情况下启用这些密码套件。TLS_CHACHA20_POLY1305_SHA256 密码套件可用于 TLS 1.3。以下密码套件可用于 TLS 1.2：

- TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
- TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
- TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256

### 支持 krb5.conf 中的 dns_canonicalize_hostname 标志

**【安全库 / org.ietf.jgss : krb5】**

`krb5.conf` JDK Kerberos 实现现在支持配置文件中的内容。当设置为“true”时，服务主体名称中的短主机名将被规范化为完全限定的域名（如果可用）。否则，不执行规范化。默认值是true”。这也是 JDK 12 之前的行为。

### jdeps --print-module-deps 报告传递依赖（Transitive Dependences）

**【工具】**

`jdeps --print-module-deps`、`--list-deps` 和 `--list-reduce-deps` 选项已增强如下。

1. 默认情况下，它们根据给定的输入 JAR 文件或类的要求，直接或间接地对类路径和模块路径上的库执行传递模块依赖（transitive module dependence）分析。以前，他们只报告给定输入 JAR 文件或类所需的模块。`--no-recursive` 选项可用于请求非传递依赖（non-transitive dependence）分析。
2. 默认情况下，它们将任何缺少的依赖项标记为错误，即从类路径和模块路径中找不到。`--ignore-missing-deps` 选项可用于抑制缺失的依赖错误。请注意，在将 `--ignore-missing-deps` 选项用于非模块化应用程序时，将使用 jdeps 输出的模块列表创建自定义图像。在自定义映像上运行的此类应用程序可能会在抑制缺失依赖错误时在运行时失败。



## JDK 11

### 将语言环境数据更新为 Unicode CLDR v33

**【核心库 / java.util : i18n】**

基于 Unicode Consortium 的 CLDR（通用语言环境数据注册表）的语言环境数据已针对 JDK 11 进行了更新。补充平面中的本地化数字（例如，印度 Chakma 脚本中的数字）被替换为 ASCII 数字，直到 JDK-8204092 得到解决. 缅甸语区域的中短时模式尚未升级。解决 JDK-8209175 后，这些模式将被升级。

### 与 Curve25519 和 Curve448 的 JEP 324 密钥协议

**【安全库】**

如 RFC 7748 中所述， JEP 324 添加了使用 Curve25519 和 Curve448 的新密钥协商方案的实现。此实现可作为 Java 密码体系结构服务使用，但尚未合并到新的 TLS 1.3 实现中。

### 添加了 Brainpool EC 支持 (RFC 5639)

**【安全库 / javax.crypto】**

SunEC 提供程序已得到增强，可支持 RFC 5639 *《椭圆曲线密码学 (ECC) Brainpool 标准曲线和曲线生成》* 中定义的 4 条额外的 Brainpool 曲线。`java.security.spec.ECGenParameterSpec` 可以使用标准名称为 brainpoolP256r1、brainpoolP320r1、brainpoolP384r1 和 brainpoolP512r1 的对象创建对应的 EC 域参数（domain parameter）。请注意，尚未增强 SunJSSE 提供程序以支持这些 Brainpool 曲线。

### JEP 329 ChaCha20 和 Poly1305 加密算法

**【安全库 / javax.crypto】**

按照 RFC 7539 中的规定实施 ChaCha20 和 ChaCha20-Poly1305 密码。ChaCha20 是一种较新的流密码，可以替代旧的、不安全的 RC4 流密码。

那些希望获得 ChaCha20 流密码实例的人可以将算法字符串 “ChaCha20” 与 `Cipher.getInstance` 方法一起使用。那些希望在 AEAD 模式下使用 ChaCha20 和 Poly1305 身份验证器的用户可以使用算法字符串 “ChaCha20-Poly1305”。有关详细信息，请参阅“Java 安全标准算法名称”文档。

### 增强的密钥库机制

**【安全库 / javax.crypto】**

引入了一个名为的新安全属性 `jceks.key.serialFilter`。如果配置了此过滤器，则 JCEKS KeyStore 在对存储在 SecretKeyEntry 中的加密密钥对象进行反序列化期间使用它。如果未配置或过滤器结果为 UNDECIDED（例如，没有任何模式匹配），则查询配置的过滤器 `jdk.serialFilter`。

如果 `jceks.key.serialFilter` 还提供了系统属性，它将取代此处定义的安全属性值。

过滤器模式使用与 `jdk.serialFilter` 相同的格式。默认模式允许`java.lang.Enum`, `java.security.KeyRep`, `java.security.KeyRep$Type`,`javax.crypto.spec.SecretKeySpec` 但拒绝所有其他模式。

存储不序列化为上述类型的 SecretKey 的客户必须修改过滤器以使密钥可提取。

### 向 SunMSCAPI 添加 RSASSA-PSS 签名支持

**【安全库 / javax.crypto】**

SunMSCAPI 提供程序中添加了 RSASSA-PSS 签名算法支持。

### JEP 332 传输层安全 (TLS) 1.3

**【安全库/javax.net.ssl】**

JDK 11 版本包括传输层安全性 (TLS) 1.3 规范 (RFC 8446) 的实现。有关更多详细信息，包括受支持的功能列表，请参阅*Java 安全套接字扩展 (JSSE) 参考指南*文档和 JEP 332。

对于 TLS 1.3，定义了以下新的标准算法名称：

1. TLS协议版本名称：TLSv1.3
2. SSLContext 算法名称：TLSv1.3
3. TLS 1.3 的 TLS 密码套件名称：TLS_AES_128_GCM_SHA256、TLS_AES_256_GCM_SHA384
4. X509KeyManager 的 keyType：RSASSA-PSS
5. X509TrustManager 的 authType：RSASSA-PSS

`jdk.tls.keyLimits` 已为 TLS 1.3 添加了新的安全属性。当特定算法的指定数据量已被处理后，会触发握手后的密钥和 IV 更新以派生新的密钥。

添加了一个新的系统属性 ，`jdk.tls.server.protocols` 用于在 SunJSSE 提供程序的服务器端配置默认启用的协议套件。

请注意，KRB5 密码套件实现已从 JDK 中删除，因为它们不再被认为可以安全使用。

请注意，TLS 1.3 与以前的版本不直接兼容。尽管 TLS 1.3 可以通过向后兼容模式实现，但在升级到 TLS 1.3 时仍然需要考虑几个兼容性风险：

1. TLS 1.3 使用半关闭策略，而 TLS 1.2 和之前的版本使用双工关闭策略。对于依赖双工关闭策略的应用程序，升级到 TLS 1.3 时可能会出现兼容性问题。
2. signature_algorithms_cert 扩展要求使用预定义的签名算法进行证书身份验证。然而，在实践中，应用程序可能会使用不受支持的签名算法。
3. TLS 1.3 不支持 DSA 签名算法。如果服务器配置为仅使用 DSA 证书，则无法升级到 TLS 1.3。
4. TLS 1.3 支持的密码套件与 TLS 1.2 及之前的版本不同。如果应用程序对不再受支持的密码套件进行硬编码，则它可能无法在不修改应用程序代码的情况下使用 TLS 1.3。
5. TLS 1.3 会话恢复和密钥更新行为不同于 TLS 1.2 和之前的版本。兼容性影响应该是最小的，但如果应用程序依赖于 TLS 协议的握手细节，则可能存在风险。

如果需要，系统属性 `jdk.tls.client.protocols` 和 `jdk.tls.server.protocols` 可用于在 SunJSSE 提供程序中相应地配置默认启用的协议。

### 支持 RFC 8009 中定义的 Kerberos 5 的 HMAC-SHA2 的 AES 加密

**【安全库 / org.ietf.jgss : krb5】**

`aes128-cts-hmac-sha256-128` 支持 RFC 8009中 `aes256-cts-hmac-sha384-192` 定义的 Kerberos 5 加密类型。默认情况下启用这些加密类型。

用户可以使用文件中的 `default_tkt_enctypes` 和 `default_tgs_enctypes` 设置 `krb5.conf` 来修改列表。



## JDK 10

### 禁用 JRE 上次使用跟踪的系统属性

**【核心svc / java.lang.management】**

引入了一个新的系统属性 `jdk.disableLastUsageTracking` 来禁用正在运行的 VM 的 JRE 上次使用跟踪。可以使用 `-Djdk.disableLastUsageTracking=true` 或 `-Djdk.disableLastUsageTracking` 在命令行中设置此属性。设置此系统属性后，将禁用 JRE 上次使用跟踪，而无论 `usagetracker.properties` 中的 `com.oracle.usagetracker.track.last.usage` 属性值设置的是什么。

### 开箱即用 JMX 代理的散列密码

**【核心svc / javax.management】**

`jmxremote.password` JMX 代理现在使用其 SHA3-512 哈希覆盖文件中存在的明文密码。

###  向 org.omg.CORBA.ORB::string_to_object 方法添加额外的 IDL 存根类型检查

**【其他库 / corba】**

显式或隐式调用 `org.omg.CORBA.ORB.string_to_object` 的应用程序，并希望确保 `ORB::string_to_object` 调用流程中涉及的 IDL 存根类型的完整性，应指定额外的 IDL 存根类型检查。这是一项“选择加入”功能，默认情况下未启用。

为了利用额外的类型检查，IDL 存根类的有效 IDL 接口类名称列表由以下之一配置：

- 指定位于 Java SE 9 `conf/security/java.security` 文件或者 Java SE 8 及更早版本中 `jre/lib/security/java.security` 文件中的安全属性 `com.sun.CORBA.ORBIorTypeCheckRegistryFilter`。
- 使用类列表指定系统属性`com.sun.CORBA.ORBIorTypeCheckRegistryFilter`。如果设置了系统属性，则其值将覆盖 `java.security` 配置中定义的相应属性。

如果未设置 `com.sun.CORBA.ORBIorTypeCheckRegistryFilter` 属性，则仅针对与内置 IDL 存根类对应的 IDL 接口类型的一组类名执行类型检查。

### JEP 319 根证书

**【安全库 / java.security】**

在 JDK 中提供一组默认的根证书颁发机构 (CA) 证书。

适用于 Linux x64 的 OpenJDK 9 二进制文件的 `cacerts` 密钥库已由 JEP 319：根证书 填充，其中包含一组由 Oracle 的 Java SE 根 CA 程序的 CA 颁发的根证书。这解决了 Linux x64 的 OpenJDK 9 二进制文件中的空 `cacerts` 密钥库问题。由于未安装受信任的根证书颁发机构，空 `cacerts` 密钥库已阻止建立 TLS 连接。作为 OpenJDK 9 二进制文件的解决方法，用户必须设置 `javax.net.ssl.trustStore` 系统属性以使用不同的密钥库。

### TLS Session Hash 和扩展的 Master Secret 扩展支持

在 JDK JSSE 提供程序中添加了对 TLS 会话哈希和扩展主密钥扩展 (RFC 7627) 的支持。请注意，一般情况下，如果未启用端点标识并且之前的握手是会话恢复缩写的初始握手，则服务器证书更改受到限制，除非两个证书所代表的身份可以视为相同。但是，如果启用或协商扩展，则不需要服务器证书更改限制，并将相应地丢弃。如果出现兼容性问题，应用程序可以通过在 JDK中将系统属性 `jdk.tls.useExtendedMasterSecret` 设置为 `false` 来禁用此扩展的协商。通过将系统属性 `jdk.tls.allowLegacyResumption` 设置为 `false`，当会话散列和扩展的主秘密扩展没有协商时，应用程序可以拒绝简短的握手。通过将系统属性 `jdk.tls.allowLegacyMasterSecret` 设置为 `false`，应用程序可以拒绝不支持会话散列和扩展主密钥扩展的连接。



## JDK 9

### JEP 219：数据报传输层安全性 (DTLS)

**【安全】**

启用 Java 安全套接字扩展 (JSSE) API 和 SunJSSE 安全提供程序以支持 DTLS 版本 1.0 和 DTLS 版本 1.2 协议。

### JEP 244：TLS 应用层协议协商扩展

**【安全】**

使传输层安全 (TLS) 连接中的客户端和服务器能够协商要使用的应用程序协议。使用应用层协议协商 (ALPN)，客户端将支持的应用协议列表作为 TLS ClientHello 消息的一部分发送。服务器选择一个协议并将所选协议作为 TLS ServerHello 消息的一部分返回。应用程序协议协商可以在 TLS 握手中完成，而无需添加网络往返。

### JEP 249：TLS 的 OCSP 装订（Stapling）

**【安全】**

使 TLS 连接中的服务器能够检查已撤销的 X.509 证书撤销。服务器在 TLS 握手期间通过联系在线证书状态协议 (OCSP) 响应者获取相关证书来执行此操作。然后，它将撤销信息附加或“装订”到返回给客户端的证书，以便客户端可以采取适当的行动。

使客户端能够从 TLS 服务器请求 OCSP 装订。客户端检查来自支持该功能的服务器的装订响应。

### JEP 246：利用 GHASH 和 RSA 的 CPU 指令

**【安全】**

`AES/GCM/NoPadding` 使用 GHASH HotSpot 内在函数将性能提高 34 倍到 150 倍。GHASH 内在函数由 Intel x64 CPU 上的  `PCLMULQDQ` 指令和 SPARC 上的 `xmul/xmulhi` 指令加速。

将使用 RSA HotSpot 内在函数的方法 `BigInteger squareToLen` 和 `BigInteger mulAdd` 的性能提高多达 50% 。RSA 内在函数适用于 Intel x64 上的类 `java.math.BigInteger`。

引入了一个新的安全属性 `jdk.security.provider.preferred` 来配置为特定算法提供显着性能提升的提供程序。

### JEP 273：基于 DRBG 的 SecureRandom 实现

**【安全】**

在  `SecureRandom`  API 的 NIST SP 800-90Ar1 中提供指定的确定性随机位生成器 (DRBG) 机制（mechanism）的功能。

DRBG 机制使用与 SHA-512 和 AES-256 一样强大的现代算法。这些机制中的每一个都可以配置有不同的安全强度和功能，以满足用户的需求。

### JEP 288：禁用 SHA-1 证书

**【安全】**

通过提供更灵活的机制来禁用具有基于 SHA-1 的签名的 X.509 证书链，改进了 JDK 的安全配置。

在 JDK 中默认包含的根锚定的 TLS 服务器证书链中禁用 SHA-1；本地或企业证书颁发机构 (CA) 不受影响。

`jdk.certpath.disabledAlgorithms` 安全属性通过几个新约束得到增强，允许更好地控制可以禁用的证书类型。

### JEP 229：默认创建 PKCS12 密钥库

**【安全】**

将默认密钥库类型从 JKS 修改为 PKCS12。PKCS#12 是用于存储加密密钥的可扩展、标准和广泛支持的格式。PKCS12 密钥库通过存储私钥、可信公钥证书和密钥来提高机密性。此功能还为与支持 PKCS12 的其他系统（例如 Mozilla、Microsoft 的 Internet Explorer 和 OpenSSL）的互操作性提供了机会。

SunJSSE 提供程序提供了 `java.security.KeyStore` 用于读取和写入 PKCS12 文件的 PKCS12 格式的完整实现。

`keytool` 密钥和证书管理实用程序可以创建 PKCS12 密钥库。

### JEP 287：SHA-3 哈希算法

**【安全】**

支持 NIST FIPS 202 中指定的 SHA-3 加密哈希函数。

 `java.security.MessageDigest` API支持以下附加标准算法：SHA3-224、SHA3-256、SHA3-384 和 SHA3-512。

以下提供程序支持 SHA-3 算法增强功能：

- SUN 提供程序：SHA3-224、SHA3-256、SHA3-384 和 SHA3-512
- OracleUcrypto 提供程序：Solaris 12.0 支持的 SHA-3 摘要

### 增强的 Java 控制面板

**【部署】**

改进了 Java 控制面板中选项的分组和显示。信息更容易找到，搜索字段可用，并且不再使用模式对话框。请注意，某些选项的位置与以前版本的 Java 控制面板不同。

### JEP 255：将选定的 Xerces 2.11.0 更新合并到 JAXP

**【核心库】**

更新 JDK 以支持 2.11.0 版本的 Xerces 解析器。公共 JAXP API 没有变化。

更改位于 Xerces 2.11.0 的以下类别中：数据类型、DOM L3 序列化程序、XPointer、目录解析器和 XML 模式验证（包括错误修复，但不包括 XML 模式 1.1 开发代码）。

### JEP 251：多分辨率图像

**【客户端库】**

允许将一组具有不同分辨率的图像封装到单个多分辨率图像中。这对于应用程序适应在运行时分辨率可能从大约 96dpi 到 300dpi 变化的显示设备可能很有用。

接口 `java.awt.image.MultiResolutionImage` 将一组具有不同分辨率的图像封装成单个多分辨率图像，这使应用程序能够轻松地操作和显示具有不同分辨率的图像。

### JEP 253：为模块化准备 JavaFX UI 控件和 CSS API

**【客户端库】**

为 JavaFX UI 控件和 CSS 功能提供公共 API，这些功能以前只能通过内部包使用，但现在由于模块化而无法访问。

新包 `javafx.scene.control.skin` 由一组类组成，这些类为每个 UI 控件的外观（或外观）提供默认实现。

新类 `CssParser` 是一个返回 `Stylesheet` 对象的 CSS 解析器，它使您可以更好地控制应用程序的 CSS 样式。它是 CSS API（`javafx.css` 包）的一部分。CSS API 包括新的支持类，包括解析器使用的一组标准转换器；参考 `javafx.css.converter` 包。

### JEP 256：BeanInfo 注解

**【客户端库】**

`@beaninfo` 将 Javadoc 标记替换为注解类型 `JavaBean`、`BeanProperty` 和 `SwingContainer`。

这些注解类型在运行时生成 `BeanInfo` 期间设置相应的特征属性。因此，您可以更轻松地直接在 Bean 类中指定这些属性，而不是为每个 Bean 类创建单独的 `BeanInfo` 类。它还可以删除自动生成的类，从而更容易模块化客户端库。

### JEP 262：TIFF 图像 I/O

**【客户端库】**

将标签图像文件格式 (TIFF) 读写作为标准添加到包 `javax.imageio` 中。新包 `javax.imageio.plugins.tiff` 提供了简化 TIFF 元数据的可选操作的类。

### JEP 263：Windows 和 Linux 上的 HiDPI 图形

**【客户端库】**

为 Windows 和 Linux 上的每英寸高点数 (HiDPI) 显示自动缩放和调整 AWT 和 Swing 组件的大小。

JDK 已经在 OS X 上支持 HiDPI“视网膜显示器”。

在此版本之前，在 Windows 和 Linux 上，Java 应用程序的大小和渲染基于像素，即使在像素密度是传统显示器的两到三倍的 HiDPI 显示器上也是如此。这导致 GUI 组件和窗口太小而无法阅读或使用。

### JEP 272：特定于平台的桌面功能

**【客户端库】**

向类 `java.awt.Desktop` 添加其他方法，使您能够与桌面交互，包括以下内容：

- 显示自定义关于和首选项窗口。
- 处理打开或打印文件列表的请求。
- 处理打开 URL 的请求。
- 打开本机帮助查看器应用程序。
- 设置默认菜单栏。
- 启用或禁用应用程序突然终止。

这些新方法替换了 OS X 包 `com.apple.eawt` 中包含的内部 API 的功能，这些功能在 JDK 9 中默认情况下无法访问。请注意，不再可以访问包 `com.apple.eio` 。

### JEP 283：在 Linux 上启用 GTK 3

**【客户端库】**

支持 Java 图形应用程序，无论是基于 JavaFX、Swing 还是抽象窗口工具包 (AWT)，都可以在 Linux 或 Solaris 上使用 GTK+ 版本 2 或版本 3。

默认情况下，Linux 或 Solaris 上的 JDK 使用 GTK+ 2（如果可用）；如果没有，它使用 GTK+ 3。

要使用特定版本的 GTK+，请设置系统属性 `jdk.gtk.version`。此系统属性的值可能为 2、2.2 或 3。您必须在应用程序加载 GTK+ 之前设置此属性，并且它不得与可能已由另一个工具包较早加载的 GTK+ 版本冲突。

### JEP 252：默认启用 CLDR 区域设置数据

**【国际化】**

使用公共区域设置数据存储库 (CLDR) 基于 XML 的区域设置数据，该数据首先在 JDK 8 中添加，作为 JDK 9 中的默认区域设置数据。在以前的版本中，默认设置是 JRE。

要启用与 JDK 8 兼容的行为，请将系统属性 `java.locale.providers` 设置为一个在 `CLDR` 前面带有 `COMPAT` 的值.



# 一些原始资料的链接

## Oracle

Oracle Java 的各个版本新特性文档：

简单来说，就是在 Oracle 的 Java SE 页面（https://docs.oracle.com/en/java/javase/index.html）里面点各个版本，然后找到“What's New”的链接。11 版本前的需要特别找一下，页面不一样。

| 版本 | 文档链接                                                     |
| ---- | ------------------------------------------------------------ |
| 5.0  | https://docs.oracle.com/javase/1.5.0/docs/relnotes/features.html |
| 6    | https://www.oracle.com/java/technologies/javase/features.html |
| 7    | https://www.oracle.com/java/technologies/javase/jdk7-relnotes.html |
| 8    | https://www.oracle.com/java/technologies/javase/8-whats-new.html |
| 9    | https://docs.oracle.com/javase/9/whatsnew/toc.htm            |
| 10   | https://www.oracle.com/java/technologies/javase/10-relnote-issues.html |
| 11   | https://www.oracle.com/java/technologies/javase/11-relnote-issues.html#NewFeature |
| 12   | https://www.oracle.com/java/technologies/javase/12-relnote-issues.html#NewFeature |
| 13   | https://www.oracle.com/java/technologies/javase/13-relnote-issues.html#NewFeature |
| 14   | https://www.oracle.com/java/technologies/javase/14-relnote-issues.html#NewFeature |
| 15   | https://www.oracle.com/java/technologies/javase/15-relnote-issues.html#NewFeature |
| 16   | https://www.oracle.com/java/technologies/javase/16-relnotes.html#NewFeature （这个地址好像有点bug，没跳到新特性介绍） |
| 16   | https://www.oracle.com/java/technologies/javase/16all-relnotes.html （16 版本含有全部子版本 release note 的地址，里面才有新特性介绍） |
| 17   | https://www.oracle.com/java/technologies/javase/17-relnote-issues.html#NewFeature |

## OpenJDK

关于 OpenJDK  各个版本（JDK 6 以后）支持的 JEP（Java 增强提案），可以在 OpenJDK 网站上查到（版本 6 ~ 9 查看具体 JEP 特性需要在地址后面加features， 例如：http://openjdk.java.net/projects/jdk8/features/，或者在页面上点那个 features 链接）。

而 JEP 的索引（实现的版本与 JEP 编号的对应）可以在这个地址看到：http://openjdk.java.net/jeps/0

| 版本    | 文档链接                               |
| ------- | -------------------------------------- |
| 6       | http://openjdk.java.net/projects/jdk6/ |
| 7       | http://openjdk.java.net/projects/jdk7/ |
| 8       | http://openjdk.java.net/projects/jdk8/ |
| 9       | http://openjdk.java.net/projects/jdk9/ |
| 10 ~ 19 | http://openjdk.java.net/projects/jdk/  |

