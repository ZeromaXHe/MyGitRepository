# 第2章 用Tomcat构建Web站点

## 2.1 Web应用的相关知识

### 2.1.1 HTTP协议

（P52）

### 2.1.2 URL

（P53）

访问标记符URL，即Uniform Resource Locater，统一资源定位符

### 2.1.3 主要的Web服务器软件

（P53）

目前主要的两种Web服务器软件是Microsoft Internet Information Server（简称IIS）和Apache，但是它们都不直接支持本书所讲解的Servlet和JSP程序。

Tomcat是Sun公司推荐的运行Servlet和JSP的容器，它可以被集成到IIS和Apache中。另外，Tomcat也具有Web服务器的一些基本功能，对于一般的应用情况，也可以直接将Tomcat作为Web服务器的一些基本功能，对于一般的应用情况，也可以直接将Tomcat作为Web服务器软件运行。

### 2.1.4 网站系统的组成

（P53）

简单的网站只需要一台Web服务器即可对外提供网页浏览服务。复杂的网站包括多台Web服务器组成的集群系统、负载均衡设备、具有缓存功能的代理服务器（可以有多级，甚至包括放置在服务器端的缓存系统）、数据库系统等。

为了能让浏览器透明地访问到Web站点，让用户感觉不到是在访问区域代理服务器，在DNS系统中需要将www.sina.com主机名指向所有区域的代理服务器的IP地址。

## 2.2 安装Tomcat

### 2.2.1 Tomcat简介

（P55）

Tomcat是Apache组织的Jakarta项目中的一个重要子项目，它是Sun公司推荐的运行Servlet和JSP的容器（引擎），其源代码是完全公开的。另外，Tomcat还具有Web服务器的基本功能，提供数据库连接池、SSL、Proxy等许多通用组件功能。	它处理静态HTML文件的速度比不上Apache和IIS等专业的Web服务器，其作为Web服务器软件的功能也不如Apache和IIS强大。

### 2.2.2 获取Tomcat安装程序包

（P55）

Tomcat完全是由Java写成的

### 2.2.3 使用zip和tar.gz包安装Tomcat

（P56）

Tomcat根目录下的一些主要子目录的介绍：

- bin 用于放置Tomcat的可执行文件和脚本执行文件
- conf 用于放置Tomcat的配置文件
- logs 用于放置Tomcat的日志记录文件
- webapps Web应用程序的主要发布目录
- work Tomcat的工作目录，JSP文件翻译成的Servlet源文件和class文件放置在这里。

### 2.2.4 使用exe程序安装Tomcat

（P57）

## 2.3 Tomcat的启动与停止

### 2.3.1 使用Tomcat服务程序

（P60）

默认情况下，Tomcat的Web服务监听端口为8080.

http://localhost:8080

```
查找网络服务程序监听异常的问题：
Tomcat服务程序所使用的的网络监听端口号已被其他网络服务程序或Web服务程序占用，导致Tomcat服务程序并没有真正正常启动运行。	netstat -na 命令，查看TCP监听端口列表中是否包含Tomcat的Web服务绑定的监听端口。
netstat -na 只能看到哪些网络端口号正在被使用，而无法查看到某个端口号是在被哪个应用程序所使用。使用一个名为Fport的工具软件，可以查看到本地计算机上所有打开的TCP和UDP端口，以及使用这些端口的应用程序名称。
```

### 2.3.2 使用Tomcat程序组中的快捷菜单

（P63）

1.Tomcat4.1.31 的快捷启动菜单

```
了解Tomcat 4.1.31的快捷启动菜单的工作原理：
Tomcat是一个完全用Java语言编写的程序，所以它应该可以使用如下的命令形式来启动：
java <各种命令选项> <Tomcat的Java启动类>
另外，也可以在Java程序的启动类所位于的Jar包的MANIFEST.MF文件中，增加一个名称为Main-Class的属性，将它的属性值设置为Java程序的启动类，然后使用如下的命令形式来启动Java程序：
java -jar <其他各种命令选项> <启动类所在的Jar包>
Tomcat 4.1.31的快捷启动菜单的完整命令可简化成如下形式：
java -jar bootstrap.jar start
其中，bootstrap.jar是Tomcat启动类所在的Jar包，start是传递给启动类中main方法的参数。
```

2.Tomcat5.5.12的快捷菜单

### 2.3.3 使用tomcat.exe程序

（P66）

1.Tomcat4.1.3中的tomcat.exe

