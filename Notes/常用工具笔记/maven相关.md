# maven中的groupId和artifactId到底指的是什么

原文：https://www.cnblogs.com/zhaiyf/p/9077402.html

​       groupid和artifactId被统称为“坐标”是为了保证项目唯一性而提出的，如果你要把你项目弄到maven本地仓库去，你想要找到你的项目就必须根据这两个id去查找。
　　groupId一般分为多个段，这里我只说两段，第一段为域，第二段为公司名称。域又分为org、com、cn等等许多，其中org为非营利组织，com为商业组织。举个apache公司的tomcat项目例子：这个项目的groupId是org.apache，它的域是org（因为tomcat是非营利项目），公司名称是apache，artigactId是tomcat。
　　比如我创建一个项目，我一般会将groupId设置为cn.snowin，cn表示域为中国，snowin是我个人姓名缩写，artifactId设置为testProj，表示你这个项目的名称是testProj，依照这个设置，你的包结构最好是cn.snowin.testProj打头的，如果有个StudentDao，它的全路径就是cn.snowin.testProj.dao.StudentDao

# Maven JDK 版本设置

```xml
    <!-- 局部jdk配置，pom.xml中 -->
    <build>  
        <plugins>  
            <plugin>  
                <groupId>org.apache.maven.plugins</groupId>  
                <artifactId>maven-compiler-plugin</artifactId>  
                <configuration>  
                    <source>1.8</source>  
                    <target>1.8</target>  
                </configuration>  
            </plugin>  
        </plugins>  
    </build>  
```
```xml
    <!-- 全局jdk配置，settings.xml -->
    <profile>  
        <id>jdk18</id>  
        <activation>  
            <activeByDefault>true</activeByDefault>  
            <jdk>1.8</jdk>  
        </activation>  
        <properties>  
            <maven.compiler.source>1.8</maven.compiler.source>  
            <maven.compiler.target>1.8</maven.compiler.target>  
            <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>  
        </properties>   
    </profile>  

```

————————————————
版权声明：本文为CSDN博主「嘿嘿不错」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/ACMer_AK/article/details/70475889

# Maven 和 IDEA 的版本问题

今天用Maven改完JDK的版本后，一直编译不了，报`Unable to import Maven project`。

查了一下日志，发现是：`No implementation for org.apache.maven.model.path.PathTranslator was bound.`

查了一下原因，貌似是Maven的版本太高了，IDEA版本跟不上... 我也是醉了，看样子不能一股脑装最新的。

# Maven 老版本

https://mirror.bit.edu.cn/apache/maven/maven-3/3.5.4/binaries/

官网的入口是真的难找，默认的是最新的，必须点https://maven.apache.org/download.cgi这个页面下面的`All current release sources (plugins, shared libraries,...) available at https://www.apache.org/dist/maven/`链接，进入maven-3文件夹才能找到…… 这页面设计是真的一言难尽，生怕你找到似的……

（好吧，我的锅，刚才发现下面的点击下面的`Previous Releases`里面的archives也可以链接到maven-3的路径下……）

```
Previous Releases
It is strongly recommended to use the latest release version of Apache Maven to take advantage of newest features and bug fixes.

If you still want to use an old version you can find more information in the Maven Releases History and can download files from the archives for versions 3.0.4+ and legacy archives for earlier releases.
```

# Maven安装 环境变量 及配置

计算机 -> 右键 属性 -> 弹出窗口"系统"左侧 高级系统属性 -> 弹出窗口“系统属性”：“高级”分页 环境变量

新建环境变量 `MAVEN_HOME`，赋值  `D:\apache-maven-X.X.X` (类似的安装路径)

编辑环境变量`Path`，追加`%MAVEN_HOME%\bin\`;

配置好后，运行 -> cmd -> 输入 `mvn -version`试试能不能正常显示版本号

然后打开安装目录下的conf/settings.xml

在`<settings>`里配置本地仓库：

```xml
<localRepository>D:\apache-maven-3.5.4\repository</localRepository>
```

在`<mirrors>`里配置仓库镜像：

```xml
<mirrors>
   <!-- 阿里云仓库 -->
    <mirror>
        <id>alimaven</id>
        <mirrorOf>*</mirrorOf>
        <name>aliyun maven</name>
        <url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
    </mirror>
</mirrors>
```
