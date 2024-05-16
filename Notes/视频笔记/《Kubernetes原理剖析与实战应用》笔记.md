Kubernetes原理剖析与实战应用

up 主：[gzqhero](https://space.bilibili.com/381340790)

2023-02-24 20:06:44

https://www.bilibili.com/video/BV1A84y1J7vp

# P1 00 开篇词 如何深入掌握 Kubernetes？

## 为什么要学习 Kubernetes

- 谈论容器
- Kubernetes
- 云原生

从开源到现在已经 **6 年**（注：2014 年中 Google 推出 Kubernetes，说明视频是 2020 年的？）

国内诸多大厂都已经在生产环境中大规模使用容器以及 **Kubernetes**

无数中小企业也都在进行业务容器化探索以及云原生化改造



2015-2019 年 Kubernetes 相关岗位同期增长 2149%

Kubernetes 职位搜索频率增长 2125%



## 课程设计

- 构建 Kubernetes 体系框架
- 进阶高可用业务
- 打造系统守护神
- 构筑安全无忧的系统
- 深入实现原理，感受高阶使用技巧

## 适合人群

- 刚接触容器的开发者
- 运维工程师
- 向云原生转型的应用开发者或架构师

# P2 01 前世今生：Kubernetes 是如何火起来的？

## 前言

**Kubernetes** 是一款由 Google 开源的容器编排管理工具

想要深入地掌握 Kubernetes 框架

就不得不先了解 Kubernetes 的**前世今生**

## 云计算平台

**“云计算”**概念由 Google 提出

自 2006 年被提出后

已经逐渐成为信息技术产业发展的战略重点

你可能也会切身感受到变化



- IaaS
  - Containers
  - Virtual Machines
  - Network
  - Storage
  - “装修风格”自己定
- PaaS
  - App Deployment
  - Auto-scaling & Clustering
  - CI/CD Automation
  - Container Orchestration
  - 系统和环境都是现成
- SaaS
  - Marketplace
  - Custom Packaging
  - Premium CDN & DNS
  - Built-in Billing
  - 相当于直接住酒店
  - 一切需求都由供应商搞定



面临的问题

- 性价比低，资源利用率低
- 迁移成本高
- 环境不一致

## Docker

**Docker** 大大降低使用容器技术的门槛

轻量、可移植、跨平台、镜像、一致性保障等优异的特性

**解放生产力**



Docker 的灵魂——**Docker 镜像**

直接打包应用运行所需要的整个“操作系统”

不会出现任何兼容性问题

赋予了本地环境和云端环境无差别的能力

避免了用户通过“试错”来匹配不同环境之间差异的痛苦过程

## 我们为什么需要容器调度平台

| 能力        | 解释                                             |
| ----------- | ------------------------------------------------ |
| 调度        | 自动生成容器实例                                 |
| 亲和/反亲和 | 生成的容器可以相邻或者相隔，帮助提高可用性和性能 |
| 健康检查    | 自动检测容器的健康状态                           |
| 容错        | 自动在健康的节点上重新生成容器实例               |
| 可扩展      | 自动根据需要增加或者删除容器实例                 |
| 网络        | 允许容器之间互相通信                             |
| 服务发现    | 允许容器之间互相发现                             |
| 滚动升级    | 容器升级可以避免对业务造成影响，同时可以出错回滚 |

- Docker Swarm
  - 直接调度 Docker 容器
  - 使用标准的 Docker API 语义，为用户提供无缝衔接的使用体验
- MESOS
  - 分布式资源管理平台，提供 Framework 注册机制
- Kubernetes
  - 目标是消除编排物理或者虚拟计算、网络和存储等基础设施负担
  - 采用 **Pod** 和 **Label** 服务

## Kubernetes 成为事实标准

**2014 年 6 月 7 日**

**第一个 commit** 拉开 Kubernetes 的序幕

**2015 年 7 月 21 日**

正式对外发布第一版本，走进了大众视线

Kubernetes 简称“**K8s**”



- Kubernetes 的成功离不开 Borg
- 不会跟任何平台绑定，可以跑在任何环境里
- 上手门槛很低
- 使用声明式 API
- 相关生态异常活跃

## 写在最后

**Kubernetes** 是为数不多的能够成长为基础技术的技术之一

是如今所有云应用程序开发机构能做出的最安全的投资

# P3 02 高屋建瓴：Kubernetes 的架构为什么是这样的？

## 前言

如何将 Kubernetes 应用到自己的项目中

首先就**需要了解 Kubernetes 的架构**



Google 使用 **Linux 容器**时间超过 15 年

期间共创建了三套容器调度管理系统

分别是 **Borg**、**Omega** 和 **Kubernetes**

## Borg 的架构

**Cell**

Borg 用 Cell 来定义一组机器资源

Google 内部一个中等规模的 Cell 可以管理

1 万台左右服务器

这些服务器的配置可以是异构的

**Cluster**

即集群

一个数据中心可以同时运行一个或者多个集群

每个集群又可以有多个 Cell

比如一个大 Cell 和多个小 Cell

## Kubernetes 的架构

etcd

paxos 和 raft

## Kubernetes 的组件

- kube-apiserver
  - 是整个 Kubernetes 集群的“灵魂”，是信息的汇聚中枢
  - 提供了所有内部和外部的 API 请求操作的唯一入口
  - 同时也负责整个集群的认证、授权、访问控制、服务发现等等能力
- kube-controller-manager
  - 负责维护整个 Kubernetes 集群的状态，比如多副本创建、滚动更新等
- kube-scheduler
  - 是监听未调度的 Pod，按照预定的调度策略绑定到满足条件的节点上



容器运行时主要负责容器的镜像管理以及容器创建及运行

Kubelet 负责维护 Pod 的生命周期，比如创建和删除 Pod 对应的容器

Kube-proxy 主要负责 Kubernetes 内部的服务通信，在主机上维护网络规则并提供转发及负责均衡能力



CoreDNS 负责为整个集群提供 DNS 服务

Ingress Controller 为服务提供外网接入能力

Dashboard 提供 GUI 可视化界面

Fluentd + elasticsearch 为集群提供日志采集、存储与查询等能力

## Master 和 Node 的交互方式

Kubernetes 中所有的状态都是采用**上报**的方式实现的

APIServer 不会主动跟 Kubelet 建立请求链接

所有的容器状态汇报都是由 Kubelet 主动向 APIServer 发起的



新增的 Node 被 APIServer 纳管后

Kubelet 进程就会定时向 APIServer 汇报**“心跳”**，即汇报自身的状态

包括自身健康状态、负载数据统计等



当一段时间内心跳包没有更新

那此时 kube-controller-manager 就会将其标记为 **NodeLost（失联）**

## 写在最后

**Kubernetes 系统在设计时很注重容错性和可扩展性**

通过 backoff retry、多副本、滚动升级等机制

增强集群的容错性，提高 Kubernetes 系统的稳定性

# P4 03 集群搭建：手把手教你玩转 Kubernetes 集群搭建

## 前言

上节课已经对 Kubernetes 的架构有了清楚的认识

但还没有和 **Kubernetes 集群**真正打过交道

## 在线 Kubernetes 集群



## Kubernetes 集群搭建难吗？

搭建一个简单自用的 Kubernetes 集群比较简单

但想要搭建一个生产可用且相对安全的集群，就不容易了



对于一个分布式系统而言，要想达到生产可用

**就必须要具备身份认证和权限授权能力**



在 Kubernetes 中，kube-apiserver 启动时会预设一些权限，用于各内部组件的接入访问

各个组件在签发证书时，就需要使用各自预设的 CN（Common Name）来标识自己的身份

## 常见的集群搭建方法

**Kind**

名字取自 Kubernetes IN Docker 的简写

最初仅用来在 Docker 中搭建本地的 Kubernetes 开发测试环境

**如果本地没有太多的物理资源**，这个工具比较适合



**Minikube**

相比 Kind 功能更强大

可以借助于本地的虚拟化能力

通过 Hyperkit、Hyper-V、KVM、Parallels、Podman、VirtualBox 和 VMWare 等创建出虚拟机

然后在虚拟机中搭建出 Kubernetes 集群来



**Kubeadm**

最推荐使用

是社区官方持续维护的集群搭建工具

在 Kubernetes v1.13 版本的时候就已经 **GA** 了（GA 即 General Availability，指官方开始推荐广泛使用）

**Kubeadm 的优势**

- 使用 Kubeadm 可以快速搭建出符合**一致性测试认证**（Conformance Test）的集群
- Kubeadm 用户体验非常优秀，使用起来非常方便，并且可以用于搭建生产环境，支持**搭建高可用集群**
- Kubeadm 的代码设计采用了可组合的模块方式
- 最为关键的是，Kubeadm 可以向下兼容低一个小版本的 Kubernetes
- 同时 Kubeadm 还支持集群平滑升级到高版本

## 集群升级

目前 Kubernetes 社区并没有一个所谓的 “TLS 版本”

Kubernetes 以 **x.y.z** 的格式来发布版本

- x - 主版本号（major version）
- y - 小版本号（minor version）
- z - 补丁版本号（patch version）

Kubernetes 社区异常活跃

每隔三个月就会发布一个小版本

但是官方只会维护最新的三个小版本

每一年 Kubernetes 都会发布四个版本



升级策略

- 永远升级到最高最新的版本
- 每半年升级一次，这样会落后社区 1 ~ 2 个小版本
- 一年升级一次小版本，或者更长

## 集群升级的建议

即使最微小的集群变更也要非常小心，慎重操作

最好通过**“轮转 + 灰度”**的升级策略来逐个集群升级

- 升级前请务必备份所有重要组件及数据
- 千万不要跨小版本进行升级
- 注意观察容器的状态，避免引发某些有状态业务发生异常
- 每次升级之前，切记一定要认真阅读官方的 release note
- 谨慎使用还在 alpha 阶段的功能

社区推荐的集群升级基本流程

- 升级主控制平面节点
- 升级其他控制平面节点
- 升级工作节点

## 写在最后

集群搭建只是第一步

重要的是后续集群的维护工作

**千万不要跨小版本进行升级，要按小版本依次升上来**

# P5 04 核心定义：Kubernetes 是如何搞定“不可变基础设施”的？

## 前言

上节课了解了 Kubernetes 集群的搭建方式

本节课学习 Kubernetes 中最重要、也是最核心的对象——**Pod**



**CNCF 官方定义云原生**

云原生技术有利于各组织在公有云、私有云和混合云等新型动态环境中

构建和运行可弹性扩展的应用

云原生的代表技术包括容器、服务网络、微服务、**不可变基础设施**和声明式 API

这些技术能够构建容错性好，易于管理和便于观察的松耦合系统

结合可靠的自动化手段，云原生技术使工程师能够轻松地对系统作出频繁和可预测的重大变更

## 怎么理解不可变基础设施？

**不可变基础设施**

这个名词最早由 Chad Fowler 于 2013 年在他的文章 “Trash Your Servers and Burn Your Code：Immutable Infrastructure and Disposable Components” 中提出来



跟不可变基础设施相对的，我们称之为**可变基础设施**

比如 kernel 升级、配置升级、打补丁等

- 持续的变更修改给服务运行态引入过多的中间态，增加了不可预知的风险
- 故障发生时，难以及时快速构建出新的服务副本
- 不易标准化，交付运维过程异常痛苦，虽然可以通过 Ansible、Puppet 等部署工具进行交付，但是也很难保证对底层各种异构的环境支持得很好，还有随时会出现的版本漂移问题

**Kubernetes 中不可变基础设施就是 Pod**

## Pod 是什么

- IP address
- volume
- containerized app

同一个 Pod 中的容器共享网络、存储资源

- 每个 Pod 都会拥有一个独立的网络空间，其内部的所有容器都共享网络资源，即 IP 地址、端口。内部的容器直接通过 localhost 就可以通信
- Pod 可以挂载多个共享的存储卷（Volume）。这时内部的各个容器就可以访问共享的 Volume 进行数据的读写

适合放在一个 Pod 中

- 容器之间会发生文件交换等。一个写文件，一个读文件
- 容器之间需要本地通信。比如通过 localhost 或者本地的 Socket
- 容器之间需要发生频繁的 RPC 调用。处于性能的考量，将它们放在一个 Pod 内
- 希望为应用添加其他功能。比如日志收集、监控数据采集、配置中心、路由及熔断等功能

## Pod 背后的涉及理念

**为什么 Kubernetes 不直接管理容器，而用 Pod 来管理呢？**

直接管理一个容器开起来更简单，为了能够更好地管理容器，Kubernetes 在容器基础上做了更高层次的抽象，即 **Pod**

- 存活探针（Liveness Probe）可以从应用程序的角度去探测一个进程是否还存活着。在容器出现问题之前，就可以快速检测到问题
- 容器启动后和终止前可以进行的操作。比如在容器停止前，可能需要做一些清理工作，或者不能马上结束进程
- 定义了容器终止后要采取的策略，比如始终重启、正常退出才重启等



**为什么要允许一个 Pod 内可以包含多个容器？**

**为什么不直接在单个容器里运行多个程序？**

**容器实际上是一个“单进程”的模型**

如果在容器里启动多个进程

不仅它们的日志记录会混在一起，它们各自的生命周期也无法管理



很多公司在刚开始容器化改造时都会这么去使用容器

把容器当作 VM 来使用，有时也叫作**富容器模式**

这是一种非常不好的尝试，也不符合不可变基础设施的理念



**用一个 Pod 管理多个容器，既能够保持容器之间的隔离性，还能保证相关容器的环境一致性**

## 如何声明一个 Pod

- 元数据（metadata）
  - Namespace（命名空间）
    - 是对一组资源和对象的抽象集合，主要用于逻辑上的隔离
    - 内置的 namespace：
      - **default**
      - **kube-system**
      - **kube-public**
      - **kube-node-lease**
  - Name（对象名）
    - 是用来标识对象的名称，在 namespace 内具有**唯一性**
    - 在不同 namespace 下，可以创建相同名字的对象
  - Uid（对象 ID）
    - 由系统自动生成的，主要用于 Kubernetes 内部标识使用
    - 还可以在 metadata 里面用各种标签（labels）和注释（annotations）来标识和匹配不同的对象
      - 用标签 **env=dev** 来标识开发环境
      - 用 **env=testing** 来标识测试环境
- 规范（spec）
  - 在 Spec 中描述了该对象的详细配置信息，即用户希望的状态（Desired State）
  - Kubernetes 中的各大组件会根据这个配置进行一系列的操作，将这种定义从“抽象”变为“现实”，称之为**调和（Reconcile）**
- 状态（status）
  - 包含了该对象的一些状态信息，会由各个控制器定期进行更新
  - 也是不同控制器之间进行相互通信的一个渠道
  - 像 Node 的 status 就记录了该节点的一些状态信息
  - 其他的控制器就可以通过 status 知道该 Node 的情况，做一些操作，比如节点宕机修复、可分配资源等

## 写在最后

**Pod** 是 Kubernetes 项目中实现“容器设计模式”的最佳实践之一

也是 Kubernetes 进行复杂应用编排的基础依赖
