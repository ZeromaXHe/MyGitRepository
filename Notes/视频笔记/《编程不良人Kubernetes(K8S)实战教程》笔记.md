【编程不良人】kubernetes (k8s) 实战教程，已完结！

2023-02-09 09:29:22 up 主：[编程不良人](https://space.bilibili.com/352224540)

https://www.bilibili.com/video/BV1cd4y1J7qE

# P1 第一章 Kubernetes 初识之简介

Kubernetes

官网：https://kubernetes.io/zh-cn/

## 第一章 初识 Kubernetes

- Kubernetes 简介
- 为什么需要 Kubernetes
- Kubernetes 能做什么
- Kubernetes 不是什么？

### 1 简介

> 摘取官网：https://kubernetes.io/zh-cn/docs/concepts/overview/

**Kubernetes** 这个名字源于希腊语，意为`舵手`或`飞行员`。k8s 这个缩写是因为 k 和 s 之间有八个字符的关系。Google 在 2014 年开源了 Kubernetes 项目。Kubernetes 建立在 Google 大规模运行生产工作负载十几年经验的基础上，结合了社区中最优秀的想法和实践。

Kubernetes 是一个可移植、可扩展的开源平台，用于 `管理容器化的工作负载和服务，可促进声明式配置和自动化`。Kubernetes 拥有一个庞大且快速增长的生态、其服务、支持和工具的使用范围相当广泛。

从 2014 年第一个版本发布以来，Kubernetes 迅速获得开源社区的追捧，包括 Red Hat、VMware 在内的很多有影响力的公司加入到开发和推广的阵营。目前 Kubernetes 已经成为发展最快、市场占有率最高的容器编排引擎产品。

# P2 Kubernetes 初识之为什么需要 k8s

### 2 为什么需要 k8s

> 摘取官网：https://kubernetes.io/zh-cn/docs/concepts/overview/

**传统部署时代**：

早期，各个组织是在物理服务器上运行应用程序。**由于无法限制在物理服务器中运行的应用程序资源使用，因此会导致资源分配问题。**例如，如果在同一台物理服务器上运行多个应用程序，则可能会出现一个应用程序占用大部分资源的情况，而导致其他应用程序的性能下降。**一种解决方案是将每个应用程序都运行在不同的物理服务器上，但是当某个应用程式资源利用率不高时，剩余资源无法被分配给其他应用程式，而且维护许多物理服务器的成本很高**。

**虚拟化部署时代**：

因此，虚拟化技术被引入了。虚拟化技术允许你在单个物理服务器的 CPU 上运行多台虚拟机（VM）。**虚拟化能使应用程序在不同 VM 之间被彼此隔离，且能提供一定程度的安全性，因为一个应用程序的信息不能被另一应用程序随意访问。**

虚拟化技术能够更好地利用物理服务器的资源，并且因为可轻松地添加或更新应用程序。而因此可以具有更高的可扩缩性，以及降低硬件成本等等的好处。通过虚拟化，你可以将一组物理资源呈现为可丢弃的虚拟机集群。

**每个 VM 是一台完整的计算机，在虚拟机硬件之上运行所有组件，包括其自己的操作系统。**

**容器部署时代**：

容器类似于 VM，但是更宽松的隔离特性，使容器之间可以共享操作系统（OS）。因此，容器比起 VM 被认为是更轻量级的。且与 VM 类似，每个容器都具有自己的文件系统、CPU、内存、进程空间等。由于它们与基础架构分离，因此可以跨云和 OS 发行版本进行移植。容器的出现解决了应用和基础环境异构的问题，让应用可以做到一次构建，多次部署。不可否认容器是打包和运行应用程序的好方式，因此容器方式部署变得流行起来。但随着容器部署流行，仅仅是基于容器的部署仍有一些问题没有解决：

- 生产环境中，你需要运行着应用程序的容器，并确保服务不会下线。例如，如果一个容器发生故障，则你需要启动另一个容器
- 高并发时，你需要启动多个应用程序容器为系统提高高可用，并保证多个容器能负载均衡
- 在维护、升级版本时，你需要将运行应用程序容器重新部署，部署时必须对之前应用容器备份，一旦出现错误，需要手动启动之前容器保证系统运行。

**如果以上行为交由给系统处理，是不是会更容易一些？那么谁能做到这些？**

# P3 Kubernetes 初识之 k8s 能做什么

### 3 k8s 能做什么？

> 摘取官网：https://kubernetes.io/zh-cn/docs/concepts/overview/

这就是 Kubernetes 要来做的事情！**Kubernetes 为你提供了一个可弹性运行分布式系统的框架**。Kubernetes 会满足你的扩展需求、故障转移你的应用、提供部署模式等。Kubernetes 为你提供：

- **服务发现和负载均衡**

  Kubernetes 可以使用 DNS 名称或自己的 IP 地址来暴露容器。如果进入容器的流量很大，Kubernetes 可以负载均衡并分配网络流量，从而使部署稳定。

- **存储编排**

  Kubernetes 允许你自己挂载你选择的存储系统，例如本地存储、公共云提供商等。

- **自动部署和回滚**

  你可以使用 Kubernetes 描述已部署容器的所需状态，它可以以受控的速率将实际状态更改为期望状态。例如，你可以自动化 Kubernetes 来为你的部署创建新容器，删除现有容器并将它们的所有资源用于新容器。

- **自动完成装箱计算/自动资源调度**

  你为 Kubernetes 提供许多节点组成的集群，在这个集群上运行容器化的任务。你告诉 Kubernetes 每个容器需要多少 CPU 和内存（RAM）。Kubernetes 可以将这些容器按实际情况调度到你的节点上，以最佳方式利用你的资源。

- **自我修复/自愈能力**

  Kubernetes 将重新启动失败的容器、替换容器、杀死不响应用户定义的运行状况检查的容器，并且在准备好服务之前不将其通告给客户端。

- **密钥与配置管理**

  Kubernetes 允许你存储和管理敏感信息，例如密码、OAuth 令牌和 ssh 密钥。你可以在不重建容器镜像的情况下部署和更新密钥和应用程序配置，也无需在堆栈配置中暴露密钥。

# P4 Kubernetes 初识之 k8s 不是什么

### 4 k8s 不是什么

**Kubernetes 不是传统的、包罗万象的 PaaS（平台即服务）系统**。由于 Kubernetes 是在容器级别运行，而非在硬件级别，它提供了 PaaS 产品共有的一些普遍适用的功能，例如部署、扩展、负载均衡，允许用户集成他们的日志记录、监控和警报方案。但是，**Kubernetes 不是单体式（monolithic）系统**，那些默认解决方案都是可选、可插拔的。Kubernetes 为构建开发人员平台提供了基础，但是在重要的地方保留了用户选择权，能有更高的灵活性。

Kubernetes：

- 不限制支持的应用程序类型。Kubernetes 旨在支持极其多种多样的工作负载，包括无状态、有状态和数据处理工作负载。如果应用程序可以在容器中运行，那么它应该可以在 Kubernetes 上很好地运行。
- 不部署源代码，也不构建你的应用程序。持续集成（CI）、交付和部署（CI/CD）工作流取决于组织的文化和偏好以及技术要求。
- 不提供应用程序级别的服务作为内置服务，例如中间件（例如消息中间件）、数据处理框架（例如 Spark）、数据库（例如 MySQL）、缓存、集群存储系统（例如 Ceph）。这样的组件可以在 Kubernetes 上运行，并且/或者可以由运行在 Kubernetes 上的应用程序通过可移植机制（例如开放服务代理）来访问。
- 不是日志记录、监视或警报的解决方案。它集成了一些功能作为概念证明，并提供了收集和导出指标的机制
- 不提供也不要求配置用的语言、系统（例如 jsonnet），它提供了声明性 API，该声明性 API 可以由任意形式的声明性规范所构成。
- 不提供也不采用任何全面的机器配置、维护、管理或自我修复系统。
- 此外，Kubernetes 不仅仅是一个编排系统，实际上它消除了编排的需要。编排的技术定义是执行已定义的工作流程：首先执行 A，然后执行 B，再执行 C。而 Kubernetes 包含了一组独立可组合的控制过程，可以连续地将当前状态驱动到所提供的预期状态。你不需要在乎如何从 A 移动到 C，也不需要集中控制，这使得系统更易于使用且功能更强大、系统更健壮，更为弹性和可扩展。

# P5 第二章 组件和架构之集群组件（一）

## 第二章 组件&架构

- 集群组件
- 核心概念
- 集群安装

### 1 集群组件

当部署完 Kubernetes，便拥有了一个完整的集群。一组工作机器，称为节点，会运行容器化应用程序。**每个集群至少有一个工作节点**。工作节点会**托管 Pod**，而 Pod 就是作为应用负载的组件。**控制平面管理集群中的工作节点和 Pod**。

#### 1.1 控制平面组件（Control Plane Components）

控制平面组件会为集群做出全局决策，比如资源的调度。以及检测和响应集群事件，例如当不满足部署的 `replica` 字段时，要启动新的 Pod。

> 控制平面组件可以在集群中的任何节点上运行。然而，为了简单起见，设置脚本通常会在同一个计算机上启动所有控制平面组件，并且不会在此计算机上运行用户容器。

- **kube-apiserver**

  API server 是 Kubernetes 控制平面的组件，**该组件负责公开了 Kubernetes API，负责处理接受请求的工作**。API server 是 Kubernetes 控制平面的前端。Kubernetes API 服务器的主要实现是 kube-apiserver。`kube-apiserver` 设计上考虑了水平扩缩，也就是说，它可通过部署多个实例来进行扩展。你可以运行 `kube-apiserver` 的多个实例，并在这些实例之间平衡流量。

- **etcd**

  **一致且高度可用的键值存储，用作 Kubernetes 的所有集群数据的后台数据库**。

- **kube-scheduler**

  `kube-scheduler` 是控制平面的组件，负责监视新创建的、未指定运行节点 node 的 Pods，并选择节点来让 Pod 在上面运行。调度决策考虑的因素包括单个 Pod 及 Pods 集合的资源需求、软硬件及策略约束、亲和性及反亲和性规范、数据位置、工作负载间的干扰及最后时限。

- **kube-controller-manager**

  kube-controller-manager 是控制平面的组件。负责运行控制器进程。从逻辑上讲，每个控制器都是一个单独的进程，但是为了降低复杂性，它们都被编译到同一个可执行文件，并在同一个进程中运行。

  这些控制器包括：

  - 节点控制器（Node Controller）：负责在节点出现故障时进行通知和响应
  - 任务控制器（Job Controller）：监测代表一次性任务的 Job 对象，然后创建 Pods 来运行这些任务直至完成
  - 端点分片控制器（EndpointSlice controller）：填充端点分片（EndpointSlice）对象（以提供 Service 和 Pod 之间的链接）。
  - 服务账号控制器（ServiceAccount controller）：为新的命名空间创建默认的服务账号（ServiceAccount）。

- **cloud-controller-manager**（optional 可选）

  一个 Kubernetes 控制平面组件，嵌入了特定于云平台的控制逻辑。云控制器管理器（Cloud Controller Manager）允许你将你的集群连接到云提供商的 API 之上，并将与该云平台交互的组件同与你的集群交互的组件分离开来。`cloud-controller-manager` 仅运行特定于云平台的控制器。因此如果你在自己的环境中运行 Kubernetes，或者在本地计算机中运行学习环境，所部署的集群不需要有云控制器管理器。与 `kube-controller-manager` 类似，`cloud-controller-manager` 将若干逻辑上独立的控制回路组合到同一个可执行文件中，供你以同一进程的方式运行。你可以对其执行水平扩容（运行不止一个副本）以提升性能或者增强容错能力。

  下面的控制器都包含对云平台驱动的依赖：

  - 节点控制器（Node Controller）：用于在节点终止响应后检查云提供商以确定节点是否以被删除
  - 路由控制器（Route Controller）：用于在底层云基础架构中设置路由
  - 服务控制器（Service Controller）：用于创建、更新和删除云提供商负载均衡器

# P6 组件和架构之集群组件（二）

#### 1.2 Node 组件

> 节点组件会在每个节点上运行，负责维护运行的 Pod 并提供 Kubernetes 运行环境

- **kubelet**

  kubelet 会在集群中每个节点（node）上运行。它保证容器（containers）都运行在 Pods 中。

  kubelet 接收一组通过各类机制提供给它的 PodSpecs，确保这些 PodSpecs 中描述的容器处于运行状态且健康。kubelet 不会管理不是由 Kubernetes 创建的容器。

- **kube-proxy**

  kube-proxy 是集群中每个节点（node）上所运行的网络代理，实现 Kubernetes 服务（Service）概念的一部分。

  kube-proxy 维护节点上的一些网络规则。这些网络规则会允许从集群内部或外部的网络会话与 Pod 进行网络通信。

  如果操作系统提供了可用的数据包过滤层，则 kube-proxy 会通过它来实现网络规则。否则，kube-proxy 仅做流量转发。

- **容器运行时（Container Runtime）**

  容器运行环境是负责运行容器的软件。

  Kubernetes 支持许多容器运行环境，例如 containerd、CRI-0、Docker 以及 Kubernetes CRI 的其他任何实现。

# P7 组件和架构之集群组件（三）

#### 1.3 插件（Addons）

- **DNS**

  尽管其他插件都并非严格意义上的必需组件，但几乎所有 Kubernetes 集群都应该有集群 DNS 因为很多示例都需要 DNS 服务。

- **Web 界面（仪表盘）**

  Dashboard 是 Kubernetes 集群的通用的、基于 Web 的用户界面。它使用户可以管理集群中运行的应用程序以及集群本身，并进行故障排除。

- **容器资源监控**

  容器资源监控将关于容器的一些常见的时间序列度量值保存到一个集中的数据库中，并提供浏览这些数据的界面

- **集群层面日志**

  集群层面日志机制负责将容器的日志数据保存到一个集中的日志存储中，这种集中日志存储提供搜索和浏览接口。

# P8 组件和架构之架构详细&总结

### 2 集群架构详细

- **总结**
  - Kubernetes 集群由多个节点组成，节点分为两类：一类是属于管理平面的主节点/控制节点（Master Node）；一类是属于运行平面的工作节点（Worker Node）。显然，复杂的工作肯定都交给控制节点去做了，工作节点负责提供稳定的操作接口和能力抽象即可。

# P9 集群搭建之 minikube 集群

### 3 集群搭建【重点】

- **minikube**

  只是一个 K8S 集群模拟器，只有一个节点的集群，只为测试用，master 和 worker 都在一起

- **裸机安装**

  至少需要两台机器（主节点、工作节点各一台），需要自己安装 Kubernetes 组件，配置会稍微麻烦点。

  缺点：配置麻烦，缺少生态支持，例如负载均衡器、云存储。

- **直接用云平台 Kubernetes**

  可视化搭建，只需简单几步就可以创建好一个集群。

  优点：安装简单、生态齐全，负责均衡器、存储等都给你配套好，简单操作就搞定

- **k3s** k8s

  安装简单，脚本自动完成。

  优点：轻量级，配置要求低，安装简单，生态齐全。

#### 3.1 minikube

# P10 集群搭建之裸机安装集群（一）

#### 3.2 裸机安装

##### 0 环境准备

- 节点数量：3 台虚拟机 centos7
- 硬件配置：2G 或更多的 RAM，2 个 CPU 或更多的 CPU，硬盘至少 30G 以上
- 网络要求：多个节点之间网络互通，每个节点能访问外网

##### 1 集群规划

- k8s-node1：10.15.0.5
- k8s-node2：10.15.0.6
- k8s-node3：10.15.0.7

##### 2 设置主机名

```shell
$ hostnamectl set-hostname k8s-node1
$ hostnamectl set-hostname k8s-node2
$ hostnamectl set-hostname k8s-node3
```

##### 3 同步 hosts 文件

> 如果 DNS 不支持主机名称解析，还需要在每台机器的 `/etc/hosts` 文件中添加主机名和 IP 的对应关系：
>
> ```shell
> cat >> /etc/hosts << EOF
> 10.15.0.5 k8s-node1
> 10.15.0.6 k8s-node2
> 10.15.0.7 k8s-node3
> EOF
> ```

# P11 集群搭建之裸机安装集群（二）

##### 4 关闭防火墙

```shell
systemctl stop firewalld && systemctl disable firewalld
```

##### 5 关闭 SELINUX

> 注意：ARM 架构请勿执行，执行会出现 ip 无法获取问题！

```shell
setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

##### 6 关闭 swap 分区

```shell
swapoff -a && sed -ri 's/.*swap.*/#&/' /etc/fstab
```

##### 7 同步时间

```shell
$ yum install ntpdate -y
$ ntpdate time.windows.com
```

##### 8 安装 containerd

```shell
# 安装 yum-config-manager 相关依赖
$ yum install -y yum-utils device-mapper-persistent-data lvm2
# 添加 containerd yum 源
$ yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 安装 containerd
$ yum install -y containerd.io cri-tools
# 配置 containerd
$ cat > /etc/containerd/config.toml << EOF
disabled_plugins = ["restart"]
[plugins.linux]
shim_debug = true
[plugins.cri.registry.mirrors."docker.io"]
endpoint = ["http://frz7i079.mirror.aliyuncs.com"]
[plugins.cri]
sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.2"
EOF
# 启动 containerd 服务 并 开机配置自启动
$ systemctl enable containerd && systemctl start containerd && systemctl status containerd

# 配置 containerd 配置
$ cat > /etc/modules-load.d/containerd.conf << EOF
overlay
br_netfilter
EOF

# 配置 k8s 网络配置
$ cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# 加载 overlay br_netfilter 模块
$ modprobe overlay
$ modprobe br_netfilter

# 查看当前配置是否生效
$ sysctl -p /etc/sysctl.d/k8s.conf
```

# P12 集群搭建之裸机安装集群（三）

##### 9 添加源

- 查看源

  ```shell
  $ yum repolist
  ```

- 添加源 x86

  ```shell
  $ cat << EOF > kubernetes.repo
  [kubernetes]
  name=Kubernetes
  baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
  enabled=1
  gpgcheck=0
  repo_gpgcheck=0
  gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirros.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
  EOF
  $ mv kubernetes.repo /etc/yum.repos.d/
  ```

- 添加源 ARM

  ```shell
  $ cat << EOF > Kubernetes.repo
  [kubernetes]
  name=Kubernetes
  baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-aarch64
  enabled=1
  gpgcheck=0
  repo_gpgcheck=0
  gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirros.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
  EOF
  
  $ mv kubernetes.repo /etc/yum.repos.d/
  ```

##### 10 安装 k8s

```shell
# 安装最新版本
$ yum install -y kubelet kubeadm kubectl

# 指定版本安装
# yum install -y kubelet-1.26.0 kubectl-1.26.0 kubeadm-1.26.0

# 启动 kubelet
$ sudo systemctl enable kubelet && sude systemctl start kubelet && sudo systemctl status kubelet
```

##### 11 初始化集群

- **注意：初始化 k8s 集群仅仅需要再在 master 节点进行集群初始化！**

```shell
kubeadm init \
--apiserver-advertise-address=10.15.0.5 \
--pod-network-cidr=10.244.0.0/16 \
--image-repository registry.aliyuncs.com/google_containers
```

##### 12 配置集群网络

> 创建配置：kube-flannel.yml，执行 kubectl apply -f kube-flannel.yml

- **注意：只在主节点执行即可！**

```yaml
---
kind: Namespace
apiVersion: v1
metadata:
  name: kube-flannel
  labels:
    pod-security.kubernetes.io/enforce: privileged
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: flannel
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - nodes/status
  verbs:
  - patch
---
kind: CLusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: flannel
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: flannel
subjects:
- kind: ServiceAccount
  name: flannel
  namespace: kube-flannel
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: flannel
  namespace: kube-flannel
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: kube-flannel-cfg
  namespace: kube-flannel
  labels:
    tier: node
    app: flannel
data:
  cni-conf.json: |
    {
      "name": "cbr0",
      "cniVersion": "0.3.1",
      "plugins": [
        {
          "type": "flannel",
          "delegate": {
            "hairpinMode": true,
            "isDefaultGateway": true
          }
        },
        {
          "type": "portmap",
          "capabilities": {
            "portMappings": true
          }
        }
      ]
    }
  net-conf.json: |
    {
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "vxlan"
      }
    }
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: kube-flannel-ds
  namespace: kube-flannel
  labels:
    tier: node
    app: flannel
spec:
  selector:
    matchLabels:
      app: flannel
  template:
    metadata:
      labels:
        tier: node
        app: flannel
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/os
                operators: In
                values:
                - linux
      hostNetwork: true
      priorityClassName: system-node-critical
      tolerations:
      - operator: Exists
        effect: NoSchedule
      serviceAccountName: flannel
      initContainers:
      - name: install-cni-plugin
       #image: flannelcni/flannel-cni-plugin:v1.1.0 for ppc64le and mips64le (dockerhub limitations may apply)
        image: docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.1.0
        command:
        - cp
        args:
        - -f
        - /flannel
        - /opt/cni/bin/flannel
        volumeMounts:
        - name: cni-plugin
          mountPath: /opt/cni/bin
      - name: install-cni
       #image: flannelcni/flannel:v0.20.2 for ppc64le and mips64le (dockerhub limitations may apply)
        image: docker.io/rancher/mirrored-flannelcni-flannel:v0.20.2
        command:
        - cp
        args:
        - -f
        - /etc/kube-flannel/cni-conf.json
        - /etc/cni/net.d/10-flannel.conflist
        volumeMounts:
        - name: cni
          mountPath: /etc/cni/net.d
        - name: flannel-cfg
          mountPath: /etc/kube-flannel/
      containers:
      - name: kube-flannel
       #image: flannelcni/flannel:v0.20.2 for ppc64le and mips64le (dockerhub limitations may apply)
        image: docker.io/rancher/mirrored-flannelcni-flannel:v0.20.2
        command:
        - /opt/bin/flanneld
        args:
        - --ip-masq
        - --kube-subnet-mgr
        resources:
          requests:
            cpu: "100m"
            memory: "50Mi"
          limits:
            cpu: "100m"
            memory: "50Mi"
        securityContext:
          privileged: false
          capabilities:
            add: ["NET_ADMIN", "NET_RAW"]
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: EVENT_QUEUE_DEPTH
          value: "5000"
        volumeMounts:
        - name: run
          mountPath: /run/flannel
        - name: flannel-cfg
          mountPath: /etc/kube-flannel/
        - name: xtables-lock
          mountPath: /run/xtables.lock
      volumes:
      - name: run
        hostPath:
          path: /run/flannel
      - name: cni-plugin
        hostPath:
          path: /opt/cni/bin
      - name: cni
        hostPath:
          path: /etc/cni/net.d
      - name: flannel-cfg
        configMap:
          name: kube-flannel-cfg
      - name: xtables-lock
        hostPath:
          path: /run/xtables.lock
          type: FileOrCreate
```

##### 13 查看集群状态

```shell
# 查看集群节点状态 全部为 Ready 代表集群搭建成功
$ kubectl get nodes
NAME		STATUS	ROLES			AGE	VERSION
k8s-node1	Ready	control-plane	21h	v1.26.0
k8s-node2	Ready	control-plane	21h	v1.26.0
k8s-node3	Ready	control-plane	21h	v1.26.0

# 查看集群系统 pod 运行情况，下面所有 pod 状态为 Runnning 代表集群可用
$ kubectl get pod -A
NAMESPACE		NAME						READY	STATUS	RESTARTS	AGE
default			nginx						1/1		Running	0			21h
kube-flannel	kube-flannel-ds-gtq49		1/1		Running	0			21h
kube-flannel	kube-flannel-ds-qpdl6		1/1		Running	0			21h
kube-flannel	kube-flannel-ds-ttxjb		1/1		Running	0			21h
kube-system		coredns-5bbd96d687-p7q2x	1/1		Running	0			21h
kube-system		coredns-5bbd96d687-rzcnz	1/1		Running	0			21h
kube-system		etcd-k8s-node1				1/1		Running	0			21h
kube-system		kube-apiserver-k8s-node1	1/1		Running	0			21h
kube-system		kube-proxy-mtsbp			1/1		Running	0			21h
kube-system		kube-proxy-v2jfs			1/1		Running	0			21h
kube-system		kube-proxy-x6vhn			1/1		Running	0			21h
kube-system		kube-scheduler-k8s-node1	1/1		Running	0			21h
```

