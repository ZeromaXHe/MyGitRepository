# 本仓库建立目的

之前自己的代码都是分项目上传的，分的比较散。因为其实大部分并不算严格意义的开源项目，所以每次都单开个 repository 感觉有点浪费。这里直接建立一个总的 Git 仓库，可以统一上传各种不同语言的不同项目代码，某种程度来说，也算是将 Git 和项目解耦。

# 仓库建立过程

在目录下执行下面命令建立本地仓库：

```shell
git init
```

检查当前文件状态（会显示未跟踪文件）：

```shell
git status
```

跟踪新文件\暂存文件更新：

```shell
git add README.md
```

> 这是个多功能命令：可以用它开始跟踪新文件，或者把已跟踪的文件放到暂存区，还能用于合并时把有冲突的文件标记为已解决状态等。

查看未暂存的内容：

```shell
git diff
```

查看已暂存的将要添加到下次提交里的内容：

```shell
git diff --cached
```

> （Git 1.6.1 及更高版本还允许使用 `git diff --staged`，效果是相同的，但更好记些。）

提交更新：

```shell
git commit
```

这种方式会启动文本编辑器以便输入本次提交的说明。

> 你也可以在 `commit` 命令后添加 `-m` 选项，将提交信息与命令放在同一行
>
> 只要在提交的时候，给 `git commit` 加上 `-a` 选项，Git 就会自动把所有已经跟踪过的文件暂存起来一并提交，从而跳过 `git add` 步骤



# 仓库内容

- **GodotDemo**: Godot 引擎开发的一些项目
  - **Civ6Copy**: 仿《文明6》项目
  - **GodotProjects**: 俯视角射击游戏项目
  - **TestInGDScript**: GDScript 测试项目
  - **Winline**: Win Line 小游戏项目
- **MySpringTuling**：图灵《手写Spring底层原理源码》笔记和代码
- **Notes**: 一些笔记文件
  - **个人创作**：主要是之前公众号写的一些文章备份
    - **技术文章**
    - **杂谈随笔**
  - **书籍翻译**：一些英文书的翻译。目前主要是：
    - 《System Design Interview》[卷1](Notes/书籍翻译/SystemDesignInterview翻译.md)、[卷2](Notes/书籍翻译/SystemDesignInterview翻译.md)
  - **文档翻译**：一些官方文档或教程的翻译。目前主要是：
    - [Godot 4.1 文档](Notes/文档翻译/Godot4.1官方文档翻译.md)
    - [Jackson 教程](Notes/文档翻译/Jackson框架Baeldung教程翻译.md)
    - [Kafka 3.4 文档](Notes/文档翻译/Kafka3.4官方文档翻译.md)
    - [MapStruct 教程](Notes/文档翻译/MapStruct框架Baeldung教程翻译.md)
    - [OpenAI 文档](Notes/文档翻译/OpenAI官方文档翻译.md)
    - [Redis 文档](Notes/文档翻译/Redis官方文档翻译.md)
    - [SpringBoot 3.0.0 文档](Notes/文档翻译/SpringBoot3.0.0官方文档翻译.md)
    - [Spring Data JPA 3.1.0 文档](Notes/文档翻译/SpringDataJPA3.1.0官方文档翻译.md)
    - [Spring Framework 6.0.4 文档](Notes/文档翻译/SpringFramework6.0.4官方文档翻译.md)
  - **常用工具笔记**：一些常用的工具的速查笔记。我自己常用的一些：
    - [Mermaid 图教程](Notes/常用工具笔记/Mermaid图教程.md) Typora 里面可以写 Markdown 的时候用这个画图
    - [LaTeX 相关](Notes/常用工具笔记/LaTeX相关.md) Typora 里面用 LaTeX 写公式
    - 其他……
  - **视频笔记**：一些视频笔记。目前主要是：
    - 看完的：[Docker](Notes/视频笔记/《尚硅谷Docker实战教程》笔记.md)、[MySQL（高级篇）](Notes/视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md)、[SpringCloud](Notes/视频笔记/《尚硅谷2024最新SpringCloud教程》笔记.md)、[JUC](Notes/视频笔记/《尚硅谷JUC并发编程（对标阿里P6-P7）》笔记.md)、[Redis](Notes/视频笔记/《尚硅谷Redis零基础到进阶》笔记.md)、[Kafka](Notes/视频笔记/《尚硅谷Kafka3.x教程》笔记.md)、[Thrift](Notes/视频笔记/图灵《一个半小时学会轻量级、跨语言的RPC框架Thrift》笔记.md)、[ZooKeeper](Notes/视频笔记/《尚硅谷大数据技术之Zookeeper3.5.7版本教程》笔记.md)、[XXL-Job](Notes/视频笔记/《1小时掌握XXL-JOB分布式调度实战》笔记.md)
    - 看完较多、进行中的：[Netty](Notes/视频笔记/《尚硅谷Netty视频教程》笔记.md)、[Dubbo](Notes/视频笔记/《Dubbo源码解读与实战》笔记.md)、[SpringBoot](Notes/视频笔记/《尚硅谷SpringBoot零基础教程》笔记.md)、[Java 新特性](Notes/视频笔记/尚硅谷 Java 新特性相关笔记.md)
    - 没看完、进度很少的：[JVM](Notes/视频笔记/《尚硅谷JVM精讲与GC调优教程》笔记.md)、[ElasticSearch](Notes/视频笔记/《尚硅谷ElasticSearch教程入门到精通》笔记.md)、[MySQL 面试题](Notes/视频笔记/《尚硅谷MySQL数据库面试题宝典》笔记.md)、[Nginx](Notes/视频笔记/《尚硅谷Nginx教程（亿级流量nginx架构设计）》笔记.md)、[SpringSecurity](Notes/视频笔记/《尚硅谷SpringSecurity+OAuth2权限管理实战教程》笔记.md)、[Spring](Notes/视频笔记/《尚硅谷Spring零基础入门到进阶，一套搞定spring6》笔记.md)、[Kubernetes](Notes/视频笔记/尚硅谷《云原生Java架构师的第一课K8s+Docker+KubeSphere+DevOps》笔记.md)
  - **读书笔记**：
    - **Java 开发相关**：整个 Java 后端技术栈可能涉及到的书籍的相关阅读笔记，还有类似 JavaFX 这种客户端的
      - **2019-2020 旧笔记**：最一开始学 Java 时候记的一些很零散的笔记，包括 CSDN 一些文章的原稿
    - **游戏开发相关**
    - **其它编程相关**：JavaScript、Python、Scala
    - **语言学习**：日语
    - **其它**：其它平时看的书的笔记
  - **面试**：自己面试相关的准备。目前内容主要是：[《个人 Java 面试复习原材料.md》](Notes/面试/个人Java面试复习原材料.md)
    - **来自BlogBackup的面试资料**：原来 BlogBackup 仓库迁移过来的面试题文章（很多都是之前发在公众号上的）
- **RandomFileChooser**：一个简单的随机选取文件的 Java 程序
- **SpringBoot3Demo**: 自己简单的一个 SpringBoot3 测试项目
- **SpringBoot3ReactorShangGuiGu**: 《尚硅谷 SpringBoot3 响应式编程教程》代码和笔记
- **SpringCloudAlibabaDemo**：自己简单的 Spring Cloud Alibaba 测试项目