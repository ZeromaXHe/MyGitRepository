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

# P6 05 Pod：最小调度单元的使用进阶及实践

## 前言

**Pod** 是 Kubernetes 中原子化的部署单元

可以包含一个或多个容器

而且容器之间可以共享网络、存储资源

- Pod 里的某一个容器异常退出了怎么办？
- 有没有“健康检查”方便你知道业务的真实运行情况，比如容器运行正常，但是业务不工作了？
- 容器在启动或删除前后，如果需要做一些特殊处理怎么办？比如做一些清理工作
- 如果容器所在节点宕机，重启后会对你的容器产生影响吗？
- ……

## Pod 的运行状态

```shell
$ kubectl get pod twocontainers -o=jsonpath='{.status.phase}'
Pending
```

```shell
$ kubectl get pod twocontainers
NAME			READY	STATUS				RESTARTS	AGE
twocontainers	0/2		ContainerCreating	0			13s
```

处于 **Pending** 状态的 Pod 不外乎以下 2 个原因：

1. Pod 还未被调度
2. Pod 内的容器镜像在待运行的节点上不存在，需要从镜像中心拉取

```shell
$ kubectl get pod twocontainers
NAME			READY	STATUS		RESTARTS	AGE
twocontainers	2/2		Running		0			2m
```

- Succeeded
  - 表示 Pod 内所有容器均成功运行结束
  - 即正常退出，退出码为 0
- Failed
  - 表示 Pod 内的所有容器均运行终止，且至少有一个容器终止失败
  - 一般这种情况，都是由于容器运行异常退出，或者被系统终止掉了
- Unknown
  - 一般是由于 Node 失联导致的 Pod 状态无法获取到

## Pod 的重启策略

Kubernetes 中定义了如下三种重启策略

可以通过 **spec.restartPolicy** 字段在 Pod 定义中进行设置

- Always
  - 表示一直重启，也是默认的重启策略
  - Kubelet 会定期查询容器的状态
  - 一旦某个容器处于退出状态，就对其执行重启操作
- OnFailure
  - 表示只有在容器异常退出，即退出码不为 0 时，才会对其进行重启操作
- Never
  - 表示从不重启



比如某些 Java 进程启动速度非常慢，在容器启动阶段其实是无法提供服务的，虽然这个时候该容器是处于运行状态

比如有些服务的进程发生阻塞，导致无法对外提供服务，这个时候容器对外还是显示为运行态

## Pod 中的健康检查

Kubernetes 中提供了一系列的健康检查

可以定制调用来帮助解决类似的问题

称之为 **Probe（探针）**

- livenessProbe
  - 可以用来探测容器是否真的在“运行”，即“探活”
- readinessProbe
  - 用于指示容器是否可以对外提供正常的服务请求，即“就绪”
- startupProbe
  - 可以用于判断容器是否已经启动好



- ExecAction
  - 可以在容器内执行 shell 脚本
- HTTPGetAction
  - 方便对指定的端口和 IP 地址执行 HTTP Get 请求
- TCPSocketAction
  - 可以对指定端口进行 TCP 检查

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: probe-demo
  namespace: demo
spec:
  containers:
  - name: sise
    image: quay.io/openshiftlabs/simpleservice:0.5.0
    ports:
    - containerPort: 9876
    readinessProbe:
      tcpSocket:
        port: 9876
      periodSeconds: 10
    livenessProbe:
      periodSeconds: 5
      httpGet:
        path: /health
        port: 9876
    startupProbe:
      httpGet:
        path: /health
        port: 9876
      failureThreshold: 3
      periodSeconds: 2
```

平常使用中

建议你对全部服务同时设置 **readiness** 和 **liveness** 健康检查

## 容器生命周期内的 hook

PostStart 可以在容器启动之后就执行

PreStop 则在容器被停止之前被执行，是一种阻塞式的方式

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle-demo
  namespace: demo
spec:
  containers:
  - name: lifecycle-demo-container
    image: nginx:1.19
    lifecycle:
      postStart:
        exec:
          command: ["/bin/sh", "-c", "echo Hello from the postStart handler > /usr/share/message"]
      preStop:
        exec:
          command: ["/usr/sbin/nginx", "-s", "quit"]
```

## init 容器

通常用来做一些初始化工作

比如环境检测、OSS 文件下载、工具安装等等

- 总是运行到完成，可以理解为一次性的任务，不可以运行常驻型任务，因为会 block 应用容器的启动运行
- 顺序启动执行，下一个的 init 容器都必须在上一个运行成功后才可以启动
- 禁止使用 readiness/liveness 探针，可以使用 Pod 定义的 **activeDeadlineSeconds**，其中包含了 Init Container 的启动时间
- 禁止使用 lifecycle hook

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-demo
  namespace: demo
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.31
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.31
    command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;']
  - name: init-mydb
    image: busybox: 1.31
    command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']
```

## 写在最后

Kubernetes 内部最核心的对象之一，**Pod** 承载了太多的功能

为了增加可扩展、可配置性

Kubernetes 增加了各种 Probe、Hook 等，以此方便使用者进行接入配置

# P7 06 无状态应用：剖析 Kubernetes 业务副本及水平扩展底层原理

## 前言

每一个 Pod 都是应用的一个实例

通常不会直接在 Kubernetes 中创建和运行单个 Pod

因为 Pod 的生命周期是短暂的，即**“阅后即焚”**



单独地用一个 Pod 来承载业务

**无法保证高可用、可伸缩、负载均衡等要求，而且 Pod 也无法“自愈”**



这时就需要在 Pod 之上做一层抽象

通过多个副本（Replica）来保证可用 Pod 的数量，避免业务不可用

## 有状态服务 VS 无状态服务

业务的服务类型

- 无状态服务
  - 如浏览网页
  - 每次请求都包含了需要的所有信息
  - 每次请求都和之前的没有任何关系
- 有状态服务
  - 如打网络游戏
  - 其请求是状态化的，服务端需要保存请求的相关信息
  - 这样每个请求都可以默认地使用之前的请求上下文

## Kubernetes 中的无状态工作负载

Kubernetes 中各个对象的 metadata 字段

都有 **label（标签）** 和**annotation（注解）**两个对象



- label（标签）
  - 主要用来标识一些有意义且对象密切相关的信息
  - 用来支持 labelSelector（标签选择器）以及一些查询操作，还有选择对象
- annotation（注解）
  - 主要用来记录一些非识别的信息
  - 并不用于标识和选择对象



```shell
$ kubectl get pod -l label1=value1,label2=value2 -n my-namespace
```

查询出 my-namespace 这个命名空间下面，带有标签 label1=value1 和 label2=value2 的 pod

label 中的键值对在匹配的时候是**“且”**的关系



ReplicationController 通常缩写为“rc”

```shell
$ kubectl get rc -n my-namespace
```



**ReplicaSet（简写为 rs）**用来替代 ReplicaController

目前支持三种操作符：**in**、**notin** 和 **exists**

可以用 **environment in (production, qa)** 匹配 label 中带有 environment=production 或 environment=qa 的 pod

可以用 **tier notin (frontend, backend)** 匹配 label 中不带有 tier=frontend 或 tier=backend 的 Pod

```shell
kuberctl get pods -l environment=production, tier=fronted
```

```shell
kubectl get pods -l 'environment in (production),tier in (frontend)'
```



Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment-demo
  namespace: demo
  labels:
  	app: nginxs
spec:
  replicas: 3
selector:
  matchLabels:
    app: nginx
  template:
    matadata:
      labels:
        app: nginx
    version: v1
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

```shell
$ kubectl create ns demo
$ kubectl create -f deploy-demo.yaml
deployment.apps/nginx-deployment-demo created
```

```shell
$ kubectl get rs -n demo
NAME								DESIRED	CURRENT	READY	AGE
nginx-deployment-demo-5d65f98bd9	3		3		0		5s
```

```shell
$ kubectl get pod -n demo -l app=nginx,version=v1
```

```shell
$ kubectl edit deploy nginx-deployment-demo -n demo
```

```shell
$ kubectl apply -f deploy-demo.yaml
```

```shell
$ kubectl get rs -n demo
NAME								DESIRED	CURRENT	READY	AGE
nginx-deployment-demo-5d65f98bd9	3		3		3		4m10s
nginx-deployment-demo-7594578db7	1		1		0		3s
```

建议你使用默认的策略来保证可用性

```shell
$ kubectl get pod -n demo -l app=nginx,version=v1
```

```shell
$ kubectl get pod -n demo -l app=nginx -w
```

## 写在最后

有了 Deployment 这个高级对象

可以很方便地完成无状态服务的发布、更新升级，无须多余的人工参与

就能保证业务的高可用性

# P8 07 有状态应用：Kubernetes 如何通过 StatefulSet 支持有状态应用

## 前言

Kubernetes 中的另外一种工作负载 **StatefulSet**

主要**用于有状态的服务发布**



在 kubectl 命令行中，一般将 StatefulSet 简写为 sts

在部署一个 StatefulSet 的时候，有个前置依赖对象，即 Service（服务）

## StatefulSet 的特性

```shell
$ kubectl get pod -n demo -w
NAME		READY	STATUS				RESTARTS	AGE
web-demo-0	0/1		ContainerCreating	0			18s
web-demo-0	1/1		Running				0			20s
web-demo-1	0/1		Pending				0			0s
web-demo-1	0/1		Pending				0			0s
web-demo-1	0/1		ContainerCreating	0			0s
web-demo-1	1/1		Running				0			2s
```

```shell
$ kubectl get pod -n demo -w -l app=nginx
```

```shell
$ kubectl get event -n demo -w
```

```shell
$ kubectl scale sts web-demo -n demo --replicas=5 statefulset.apps/web-demo scaled
```

## 如何更新升级 StatefulSet

StatefulSet 中支持两种更新升级策略

- RollingUpdate 是默认的更新策略
- OnDelete 当更新策略设置为 OnDelete 时必须手动先删除 Pod 才能触发新的 Pod 更新

## 写在最后

StatefulSet 的特点：

- 具备固定的网络标记，比如主机名，域名等
- 支持持久化存储，而且最好能够跟实例一一绑定
- 可以按照顺序来部署和扩展
- 可以按照顺序进行终止和删除操作
- 在进行滚动升级的时候，也会按照一定顺序

# P9 08 配置管理：Kubernetes 管理业务配置方式有哪些？

## 前言

使用过程中，常常需要对 Pod 进行一些配置管理

比如参数配置文件怎么使用，敏感数据怎么保存传递等等

- 有些不变的配置是可以打包到镜像中的，那可变的配置呢？
- 信息泄露，很容易引发安全风险，尤其是一些敏感信息，比如密码、密钥等
- 每次配置更新后，都要重新打包一次，升级应用；镜像版本过多，也给镜像管理和镜像中心存储带来很大的负担
- 定制化太严重，可扩展能力差，且不容易复用

## ConfigMap

```shell
$ kubectl create -f cm-demo-mix.yaml
configmap/cm-demo-mix created
$ kubectl create -f cm-all-env.yaml
configmap/cm-demo-all-env created
```

```shell
$ kubectl get cm -n demo
NAME			DATA	AGE
cm-demo-all-env	2		30s
cm-demo-mix		4		2s
$ kubectl describe cm cm-demo-all-env -n demo
```

## Secret

可以用 Secret 来保存一些敏感的数据信息，比如密码、密钥、token 等

跟 ConfigMap 的用法基本保持一致，都可以用来作为环境变量或者文件挂载

```shell
$ kubectl create secret -h
```

## 写在最后

ConfigMap 和 Secret 是 Kubernetes 常用的保存配置数据的对象

可以根据需要选择合适的对象存储数据

- 如果业务自己支持 reload 配置的话，比如 nginx -s reload，可以通过 inotify 感知到文件更新，或者直接定期进行 reload
- Reloader 通过 watch ConfigMap 和 Secret，一旦发现对象更新，就自动触发对 Deployment 或 StatefulSet 等工作负载对象进行滚动升级

# P10 09 存储类型：如何挑选合适的存储插件？

## 前言

虚拟机时代，大家比较少考虑存储的问题

通过底层 IaaS 平台申请虚拟机时

大多数情况下都会事先预估好需要的容量

方便虚拟机起来后可以稳定的使用这些存储资源

## Kubernetes 中的 Volume 是如何设计的？

| 插件分类     | 主要用途描述                                                 | 卷插件                                                       | 数据是否会随着 Pod 删除而删除 |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------------- |
| 临时存储     | 主要用于存储一些临时文件，类似于在操作系统中创建的 tempDir   | EmptyDir                                                     | 是                            |
| 本地存储     | 用于将一些 Kubernetes 中定义的配置通过 volume 映射到容器中使用 | ConfigMap<br />DownwardAPI<br />Secret                       | 是                            |
| 本地存储     | 使用宿主机上的存储资源                                       | HostPath<br />Local                                          | 否                            |
| 自建存储平台 | 客户自己搭建的存储平台                                       | CephFS<br />Ginder<br />GlusterFS<br />NFS<br />RBD<br />……  | 否                            |
| 云厂商插件   | 一些云厂商提供的插件，供云上的 Kubernetes 使用               | awsElasticBlockStore<br />AzureDisk<br />AzureFile<br />GCEPersistentDisk | 否                            |

## 常见的几种内置 Volume 插件

**ConfigMap** 和 **Secret**

都可以通过 Volume 形式挂载到 Pod 内



**Downward API**



**EmptyDir**



**HostPath**

和 EmptyDir 一样，都是利用宿主机的存储为容器分配资源

两者的区别就是 HostPath 中的数据并不会随着 Pod 被删除而删除，而是会持久地存放在该节点上

- 避免通过容器恶意修改宿主机上的文件内容
- 避免容器恶意占用宿主机上的存储资源而打爆宿主机
- 要考虑到 Pod 自身的生命周期，而且 Pod 是会“漂移”重新“长”到别的节点上的，所以要避免过度依赖本地的存储

## 为什么社区要采用 CSI

1. 这些插件对 Kubernetes 代码本身的稳定性以及安全性引入了很多未知的风险，一个很小的 Bug 都有可能导致集群受到攻击或者无法工作
2. 这些插件的维护和 Kubernetes 的正常迭代紧密耦合在一起，一起打包和编译。即使是某个单一插件出现了 Bug，都需要通过升级 Kubernetes 的版本来修复
3. 社区需要维护所有的 volume plugin，并且要经过完整的测试验证流程来保证可用性，这给社区的正常迭代平添了很多麻烦
4. 各个卷插件依赖的包也都要算作 Kubernetes 项目的一部分，这会让 Kubernetes 的依赖变得臃肿
5. 开发者被迫要将这些插件代码进行开源

# P11 10 存储管理：怎样对业务数据进行持久化存储？

## 前言

Volume 跟 Pod 的**生命周期是绑定的**

当 Pod 被删除后，Volume 中的数据有可能会一同被删除



- 共享 Volume
- 复用 Volume 中的数据
- Volume 自身的一些强关联诉求
- Volume 功能及语义扩展

## 静态 PV

PV = Persistent Volume

ReadWriteOnce (RWO) 表示该卷只可以以读写方式挂载到一个 Pod 内

ReadOnlyMany (ROX) 表示该卷可以挂载到多个节点上，并被多个 Pod 以只读方式挂载

ReadWriteMany (RWX) 表示卷可以被多个节点以读写方式挂载供多个 Pod 同时使用

```shell
$ kubectl get pv task-pv-volume
NAME			CAPACITY	ACCESSMODES	RECLAIMPOLICY	STATUS		STORAGECLASS	AGE
task-pv-volume	10Gi		RWO			Retain			Available	manual			4s
```

除 Retain 外还有：

- Recycle，即回收，这个时候会清除 PV 中的数据
- Delete，即删除，这个策略常在云服务商的存储服务中使用到，比如 AWS EBS



PVC

```shell
$ kubectl get pvc -n demo
```



PV 状态

- Pending 表示目前该 PV 在后端存储系统中还没创建完成
- Available 即闲置可用状态，这个时候还没有被绑定到任何 PVC 上
- Bound 就像上面例子里似的，这个时候已经绑定到某个 PVC 上了
- Released 表示已经绑定的 PVC 已经被删掉了，但资源还未被回收掉
- Failed 表示回收失败



PVC 状态

- Pending 表示还未绑定任何 PV
- Bound 表示已经和某个 PV 进行了绑定
- Lost 表示关联的 PV 失联

## 动态 PV

## StatefulSet 中怎么使用 PV 和 PVC？

对于 StatefulSet 管理的 Pod

每个 Pod 使用的 Volume 中的数据都不一样，而且相互之间关系是需要强绑定的

# P12 11 K8s Service：轻松搞定服务发现和负载均衡

## 前言

通过 **PV** 持久化地保存数据

通过 **Deployment** 或 **StatefulSet** 这类工作负载来管理多实例从而保证服务的高可用

## 为什么需要服务发现？

传统的应用部署，服务实例的网络位置是固定的

在 Kubernetes 中，业务都是通过 Pod 来承载的

每个 Pod 的生命周期又很短暂，**用后即焚**，IP 地址也都是随机分配，**动态变化**的

## Kubernetes 中的 Service

## 集群内如何访问 Service？

**如果该 Service 有 ClusterIP 可以直接用这个虚拟 IP 去访问**

比如 nginx-prod-svc-demo 这个 Service

通过 kubectl get svc nginx-prod-svc-demo -n dmeo 或 kubectl get svc nginx-prod-svc-demo -n dmeo 就可以看到其 Cluster IP 为 10.111.193.186，端口号为 80

那么可以通过 http(s)://10.111.193.186:80 就可以访问到该服务



**当然也可以使用该 Service 的域名，依赖于集群内部的 DNS 即可访问**

同 namespace 下的 Pod 可以直接通过 nginx-prod-svc-demo 这个 Service 名去访问

如果是不同 namespace 下的 Pod 则需要加上该 Service 所在的 namespace 名

即 nginx-prod-svc-demo.demo 去访问

## 集群内部的负载均衡如何实现？

## Headless Service

1. 用户可以自己选择要连接哪个 Pod。通过查询 Service 的 DNS 记录来获取后端真实负载的 IP 地址，自主选择要连接哪个 IP
2. 可用于部署有状态服务。每个 StatefulSet 管理的 Pod 都有一个单独的 DNS 记录，且域名保持不变。即 `<PodName>.<ServiceName>.<NamespaceName>.svc.cluster.local`。这样 StatefulSet 中的各个 Pod 就可以直接通过 Pod 名字解决相互间身份以及访问问题

## 写在最后

Service 是 Kubernetes 很重要的对象

主要负责为各种工作负载暴露服务，方便各个服务之间互访
