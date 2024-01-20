# P1 课程简介

# P2 docker为什么出现

问题：为什么会有 docker 出现

答案就是使用容器。Docker 之所以发展如此迅速，也是因为它对此给出了一个标准化的解决方案——系统平滑移植，容器虚拟化技术。

环境配置相当麻烦，换一台机器，就要重来一次，费时费力。很多人想到，能不能从根本上解决问题，软件可以带环境安装？也就是说，安装的时候，把原始环境一模一样地复制过来。开发人员利用 Docker 可以消除协作编码时“在我的机器上可正常工作”的问题

之前在服务器配置一个应用的运行环境，要安装各种软件，就拿尚硅谷电商项目的环境来说，Java/RabbitMQ/MySQL/JDBC 驱动包等。安装和配置这些东西有多麻烦就不说了，它还不能跨平台。假如我们是在 Windows 上安装的这些环境，到了 Linux 又得重新装。况且就算不跨操作系统，换另一台同样操作系统的服务器，要移植应用也是非常麻烦的。

传统上认为，软件编码开发/测试结束后，所产出的成果即是程序，或是能够编译执行的二进制字节码等（Java 为例）。而为了让这些程序可以顺利执行，开发团队也得准备完整的部署文件，让运维团队得以部署应用程式，开发需要清楚的告诉运维部署团队，用的全部配置文件+所有软件环境。不过即便如此，仍然常常发生部署失败的状况。Docker 的出现使得 Docker 得以打破过去“程序即应用”的观念。透过镜像（image）将作业系统核心除外，运作应用程式所需要的系统环境，由下而上打包，达到应用程式跨平台间的无缝接轨运作。

# P3 docker 理念简介

# P4 docker是什么

## Docker 理念

Docker 是基于 Go 语言实现的云开源项目。

Docker 的主要目标是“Build，Ship and Run Any App Anywhere”，也就是通过对应用组件的封装、分发、部署、运行等生命周期的管理，使用户的 APP(可以是一个 WEB 应用或数据库应用等等)及其运行环境能够做到“一次镜像，处处运行”。

Linux 容器技术的出现就解决了这样一个问题，而 Docker 就是在它的基础上发展过来的。将应用打成镜像，通过镜像成为运行在 Docker 容器上面的实例，而 Docker 容器在任何操作系统上都是一致的，这就实现了跨平台、跨服务器。只需要一次配置好环境，换到别的机子上就可以一键部署好，大大简化了操作。

# P5 传统虚拟机和容器的对比

## 传统虚拟机技术

虚拟机（virtual machine）就是带环境安装的一种解决方案。

它可以在一种操作系统里面运行另一种操作系统，比如在 Windows10 系统里面运行 Linux 系统 CentOS7。应用程序对此毫无感知，因为虚拟机看上去跟真实系统一模一样，而对于底层系统来说，虚拟机就是一个普通文件，不需要了就删掉，对其他部分毫无影响。这类虚拟机完美的运行了另一套系统，能够使应用程序，操作系统和硬件三者之间的逻辑不变。

传统虚拟机技术基于安装在主操作系统上的虚拟机管理系统（如：VirtualBox 和 VMWare 等），创建虚拟机（虚拟出各种硬件），在虚拟机上安装从操作系统，在从操作系统中安装部署各种应用。

## 容器虚拟化技术

由于前面虚拟机存在某些缺点，Linux 发展出了另一种虚拟化技术：

Linux 容器（Linux Containers，缩写为 LXC）

Linux 容器是与系统其他部分隔离开的一系列进程，从另一个镜像运行，并由该镜像提供支持进程所需的全部文件。容器提供的镜像包含了应用的所有依赖项，因而在从开发到测试再到生产的整个过程中，它都具有可移植性和一致性。

Linux 容器不是模拟一个完整的操作系统而是对进程进行隔离。有了容器，就可以将软件运行所需的所有资源打包到一个隔离的容器中。容器与虚拟机不同，不需要捆绑一整套操作系统，只需要软件工作所需的库资源和设置。系统因此而变得高效轻量并保证部署在任何环境中的软件都能始终如一地运行。

Docker 容器是在操作系统层面上实现虚拟化，直接复用本地主机的操作系统，而传统虚拟机则是在硬件层面实现虚拟化。与传统的虚拟机相比，Docker 优势体现为启动速度快、占用体积小。

## 对比

比较了 Docker 和传统虚拟化方式的不同之处：
- 传统虚拟机技术是虚拟出一套硬件后，在其上运行一个完整操作系统，在该系统上再运行所需应用进程
- 容器内的应用进程直接运行于宿主的内核，容器内没有自己的内核且没有进行硬件虚拟。因此容器要比传统虚拟机更为轻便。
- 每个容器之间互相隔离，每个容器有自己的文件系统，容器之间进程不会相互影响，能区分计算资源。

# P6 docker 能干嘛解决什么问题

DevOps 工程师：一次构建、随处运行

- **更快速的应用交付和部署**：传统的应用开发完成后，需要提供一堆安装程序和配置说明文档，安装部署后需根据配置文档进行繁杂的配置才能正常运行。Docker 化之后只需要交付少量容器镜像文件，在正式生产环境加载镜像并运行即可，应用安装配置在镜像里已经内置好，大大节省部署配置和测试验证时间。
- **更便捷的升级和扩缩容**：随着微服务架构和 Docker 的发展，大量的应用会通过微服务方式架构，应用的开发构建将变成搭乐高积木一样，每个 Docker 容器将变成一块“积木”，应用的升级将变得非常容易。当现有的容器不足以支撑业务处理时，可通过镜像运行新的容器进行快速扩容，使应用系统的扩容从原先的天级变成分钟级甚至秒级。
- **更简单的系统运维**：应用容器化运行后，生产环境运行的应用可与开发、测试环境的应用高度一致，容器会将应用程序相关的环境和状态完全封装起来，不会因为底层基础架构和操作系统的不一致性给应用带来影响，产生新的 BUG。当出现程序异常时，也可以通过测试环境的相同容器进行快速定位和修复。
- **更高效的计算资源利用**：Docker 是内核级虚拟化，其不像传统的虚拟化技术一样需要额外的 Hypervisor 支持，所以在一台物理机上可以运行很多个容器实例，可大大提升物理服务器的 CPU 和内存的利用率。

美团 Why Docker

- 更轻量：基于容器的虚拟化，仅包含业务运行所需的 runtime 环境，CentOS/Ubuntu 基础镜像仅 170M；宿主机可部署 100 ~ 1000 个容器
- 更高效：无操作系统虚拟化开销
  - 计算：轻量、无额外开销
  - 存储：系统盘 aufs/dm/overlayfs; 数据盘 volume
  - 网络：宿主机网络，NS 隔离
- 更敏捷、更灵活：
  - 分层的存储和包管理，devops 理念
  - 支持多种网络配置

# P7 docker 官网介绍

# P8 docker 三要素

需要正确的理解仓库/镜像/容器这几个概念：

Docker 本身是一个容器运行载体或称之为管理引擎。我们把应用程序和配置依赖打包好形成一个可交付的运行环境，这个打包好的运行环境就是 image 镜像文件。只有通过这个镜像文件才能生成 Docker 容器实例（类似 Java 中 new 出来一个对象）。

image 文件可以看作是容器的模板。Docker 根据 image 文件生成容器的实例。同一个 image 文件，可以生成多个同时运行的容器实例。

## 镜像文件

image 文件生成的容器实例，本身也是一个文件，称为镜像文件。

Docker 镜像（image）就是一个只读的模板。镜像可以用来创建 Docker 容器，一个镜像可以创建很多容器。它也相当于是一个 root 文件系统。比如官方镜像 centos:7 就包含了完整的一套 centos:7 最小系统的 root 文件系统。相当于容器的“源代码”，Docker 镜像文件类似于 Java 的类模板，而 Docker 容器实例类似于 Java 中 new 出来的实例对象，

## 容器实例

一个容器运行一种服务，当我们需要的时候，就可以通过 Docker 客户端创建一个对应的运行实例，也就是我们的容器

1. 从面向对象角度：Docker 利用容器（Container）独立运行的一个或一组应用，应用程序或服务运行在容器里面，容器就类似于一个虚拟化的运行环境，容器是用镜像创建的运行实例。就像是 Java 中类和实例对象一样，镜像是静态的定义，容器是镜像运行时的实体。容器为镜像提供了一个标准的和隔离的运行环境，它可以被启动、开始、停止、删除。每个容器都是相互隔离的、保证安全的平台
2. 从镜像容器角度：可以把容器看做是一个简易版的 Linux 环境（包括 root 用户权限、进程空间、用户空间和网络空间等）和运行在其中的应用程序。

## 仓库

就是放一堆镜像的地方，我们可以把镜像发布到仓库中，需要的时候再从仓库中拉下来就可以了。

仓库（Repository）是集中存放镜像文件的场所。类似于 Maven 仓库，存放各种 jar 包的地方；GitHub 仓库，存放各种 Git 项目的地方；Docker 公司提供的官方 Registry 被称为 Docker Hub，存放各种镜像模板的地方。

仓库分为公开仓库（Public）和私有仓库（Private）两种形式。最大的公开仓库是 Docker Hub(http://hub.docker.com)存放了数量庞大的镜像供用户下载。国内的公开仓库包括阿里云、网易云等

# P9 docker 平台入门图解

Docker 工作原理

Docker 是一个 Client-Server 结构的系统，Docker 守护进程运行在主机上，然后通过 Socket 连接从客户端访问，守护进程从客户端接受命令并管理运行在主机上的容器。容器，是一个运行时环境，就是我们前面说到的集装箱。可以对比 MySQL 演示对比讲解。

# P10 docker 平台架构图解

整体架构及底层通信原理简述

Docker 是一个 C/S 模式的架构，后端是一个松耦合架构，众多模块各司其职。

Docker 运行的基本流程为：

1. 用户是使用 Docker Client 与 Docker Daemon 建立通信，并发送请求给后者。
2. Docker Daemon 作为 Docker 架构中的主体部分，首先提供 Docker Server 的功能使其可以接受 Docker Client 的请求。
3. Docker Engine 执行 Docker 内部的一系列工作，每一项工作都是以一个 Job 的形式的存在。
4. Job 的运行过程中，当需要容器镜像时，则从 Docker Registry 中下载镜像，并通过镜像管理驱动 Graph driver 将下载镜像以 Graph 的形式存储。
5. 当需要为 Docker 创建网络环境时，通过网络管理驱动 Network driver 创建并配置 Docker 容器网络环境。
6. 当需要限制 Docker 容器运行资源或执行用户指令等操作时，则通过 Exec driver 来完成。
7. Lib container 是一项独立的容器管理包，Network driver 以及 Exec driver 都是通过 Lib container 来实现具体对容器进行的操作。（包括 netlink, appmarmor, namespaces, cgroups, devices）

# P11 centos7 上安装 docker

1. 确定你是 CentOS7 及以上版本
2. 卸载旧版本
3. yum 安装 gcc 相关
4. 安装需要的软件包
5. 设置 stable 镜像仓库
6. 更新 yum 软件包索引
7. 安装 DOCKER CE
8. 启动 docker
9. 测试

# P12 镜像加速器配置

# P13 helloworld 分析介绍 3 要素配合

# P14 为什么 Docker 会比 VM 虚拟机快

1. **Docker 有着比虚拟机更少的抽象层**：由于 Docker 不需要 Hypervisor(虚拟机)实现硬件资源虚拟化，运行在 Docker 容器上的程序直接使用的都是实际物理机的硬件资源。因此在 CPU、内存利用率上 Docker 将会在效率上有明细优势。
2. **Docker 利用的是宿主机的内核，而不需要加载操作系统 OS 内核**：当新建一个容器时，Docker 不需要和虚拟机一样重新加载一个操作系统内核。进而避免引寻、加载操作系统内核返回等比较费时费资源的过程，当新建一个虚拟机时，虚拟机软件需要加载 OS，返回新建过程是分钟级别的。而 Docker 由于直接利用宿主机的操作系统，则省略了返回过程，因此新建一个 Docker 容器只需要几秒钟。

# P15 帮助启动类命令

- 启动 Docker：systemctl start docker
- 停止 Docker：systemctl stop docker
- 重启 Docker：systemctl restart docker
- 查看 Docker 状态：systemctl status docker
- 开机启动：systemctl enable docker
- 查看 Docker 概要信息：docker info
- 查看 Docker 总体帮助文档：docker --help
- 查看 Docker 命令帮助文档：docker 具体命令 --help

# P16 镜像命令

- docker images：列出本地主机上的镜像
  - OPTIONS 说明：
    - -a 列出本地所有的镜像（含历史映像层）
    - -q 只显示镜像 ID
  - 各个选项说明：
    - REPOSITORY 表示镜像的仓库源
    - TAG：镜像的标签版本号
    - IMAGE ID：镜像 ID
    - CREATED：镜像创建时间
    - SIZE：镜像大小
  - 同一个仓库源可以有多个 TAG 版本，代表这个仓库源的不同版本，我们使用 REPOSITORY:TAG 来定义不同的镜像。如果你不指定一个镜像的版本标签，例如你只使用 ubuntu，Docker 将默认使用 ubuntu:latest 镜像
- docker search 某个镜像名字：搜索镜像
  - NAME 镜像名称
  - DESCRIPTION 镜像说明
  - STARS 点赞数量
  - OFFICIAL 是否是官方的
  - AUTOMATED 是否是自动构建的
- docker pull 某个镜像名字：下载镜像
- docker system df 查看镜像/容器/数据卷所占的空间
- docker rmi 某个镜像名字ID：删除镜像
  - 删除单个： docker rmi -f 镜像ID
  - 删除多个： docker rmi -f 镜像名1:TAG 镜像名2:TAG
  - 删除全部： docker rmi -f $(docker images -qa)

谈谈 Docker 虚悬镜像是什么？

仓库名、标签都是 <none> 的镜像，俗称虚悬镜像（dangling image）

# P17 ubuntu 容器说明

容器命令：

- 新建+启动容器：`docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`
- 列出当前所有正在运行的容器：`docker ps [OPTIONS]`
- 退出容器：两种推出方式 exit 和 ctrl+p+q
- 启动已停止运行的容器：`docker start 容器ID或容器名`
- 重启容器：`docker restart 容器ID或容器名`
- 停止容器：`docker stop 容器ID或容器名`
- 强制停止容器：`docker kill 容器ID或容器名`
- 删除已停止的容器：`docker rm 容器ID`

# P18 容器命令 A

新建+启动容器：`docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`

OPTIONS 说明：
- `--name="容器新名字"` 为容器指定一个名称
- `-d` 后台运行容器并返回容器 ID，也即启动守护式容器（后台运行）
- `-i` 以交互模式运行容器，通常与 -t 同时使用
- `-t` 为容器重新分配一个伪输入终端，通常与 -i 同时使用，也即启动交互式容器（前台有伪终端，等待交互）
- `-P` 随机端口映射，大写P
- `-p` 指定端口映射，小写p
  - `-p hostPort:containerPort` 端口映射 -p 8080:80
  - `-p ip:hostPort:containerPort` 配置监听地址 -p 10.0.0.100:8080:80
  - `-p ip::containerPort` 随机分配端口 -p 10.0.0.100::80
  - `-p hostPort:containerPort:udp` 指定协议 -p 8080:80:tcp
  - `-p 81:80 -p 443:443` 指定多个

# P19 容器命令 B

列出当前所有正在运行的容器：`docker ps [OPTIONS]`

- OPTIONS 说明
  - `-a` 列出当前所有正在运行的容器+历史上运行过的
  - `-l` 显示最近创建的容器
  - `-n` 显示最近n个创建的容器
  - `-q` 静默模式，只显示容器编号

# P20 容器命令 C

退出容器：两种推出方式 exit 和 ctrl+p+q

- exit 退出，容器停止
- ctrl+p+q 退出，容器不停止

启动已停止运行的容器：`docker start 容器ID或容器名`

重启容器：`docker restart 容器ID或容器名`

停止容器：`docker stop 容器ID或容器名`

强制停止容器：`docker kill 容器ID或容器名`

删除已停止的容器：`docker rm 容器ID`
- 一次性删除多个容器实例
  - `docker rm -f $(docker ps -a -q)`
  - `docker ps -a -q | xargs docker rm`

# P21 容器命令 D

重要

- 有镜像才能创建容器，这是根本前提
- 启动守护式容器（后台服务器）：`docker run -d 容器名`
- 查看容器日志：`docker logs 容器ID`
- 查看容器内运行的进程：`docker top 容器ID`
- 查看容器内部细节：`docker inspect 容器ID`
- 进入正在运行的容器并以命令行交互：`docker exec -it 容器ID bashShell`
  - 重新进入：`docker attach 容器ID`
- 从容器内拷贝文件到主机上：`docker cp 容器ID:容器内路径 目的主机路径`
- 导入和导出容器：`docker export 容器ID > 文件名.tar` 和 `cat 文件名.tar | docker import - 镜像用户/镜像名:镜像版本号`

## 启动守护式容器（后台服务器）

- 在大部分场景下，我们希望 Docker 的服务是在后台运行的，我们可以通过 -d 指定容器的后台运行模式
- `docker run -d 容器名`
- Redis 前后台启动演示 case
  - 前台交互式启动: `docker run -it redis:6.0.8`
  - 后台守护式启动: `docker run -d redis:6.0.8`
- 问题：Docker 容器后台运行，就必须有一个前台进程。容器运行的命令如果不是那些一直挂起的命令（比如运行 top，tail），就是会自动退出的。
  - 这个是 Docker 机制问题，比如你的 Web 容器，我们以 Nginx 为例，正常情况下，我们配置启动服务只需要启动响应的 service 即可。例如 service nginx start。但是，这样做，nginx 为后台进程模式运行，就导致 Docker 前台没有运行的应用，这样的容器后台启动后，会立即自杀，因为它觉得没事可做了。
  - 所以最佳的解决方案是：将你要运行的程序以前台进程的形式运行，常见就是命令行模式，表示我还有交互操作，别中断

## 进入正在运行的容器并以命令行交互

- `docker exec -it 容器ID bashShell`
- 重新进入：`docker attach 容器ID`
- 上述两个区别
  - attach 直接进入容器启动命令的终端，不会启动新的线程。用 exit 退出，会导致容器的停止
  - exec 是在容器中打开新的终端，并且可以启动新的进程。用 exit 退出，不会导致容器的停止
- 推荐使用 docker exec

# P22 容器命令 E

## 从容器内拷贝文件到主机上

- 容器 -> 主机
- `docker cp 容器ID:容器内路径 目的主机路径`

## 导入和导出容器

- export 导出容器的内容流作为一个 tar 归档文件【对应 import 命令】
  - `docker export 容器ID > 文件名.tar`
- import 从 tar 包中的内容创建一个新的文件系统再导入为镜像【对应 export】
  - `cat 文件名.tar | docker import - 镜像用户/镜像名:镜像版本号`

## 常用命令

- `attach` 当前 shell 下 attach 连接指定运行镜像
- `build` 通过 Dockerfile 定制镜像
- `commit` 提交当前容器为新的镜像
- `cp` 从容器中拷贝指定文件或者目录到宿主机中
- `create` 创建一个新的容器，同 run，但不启动容器
- `diff` 查看 docker 容器变化
- `events` 从 docker 服务获取容器实时事件
- `exec` 在已存在的容器上运行命令
- `export` 导出容器的内容流作为一个 tar 归档文件【对应 import】
- `history` 展示一个镜像形成历史
- `images` 列出系统当前镜像
- `import` 从 tar 包中的内容创建一个新的文件系统映像【对应 export】
- `info` 显示系统相关信息
- `inspect` 查看容器详细信息
- `kill` 杀死指定 Docker 容器
- `load` 从一个 tar 包中加载一个镜像【对应 save】
- `login` 注册或者登录一个 Docker 源服务器
- `logout` 从当前 Docker registry 退出
- `logs` 输出当前容器日志信息
- `port` 查看映射端口对应的容器内部源端口
- `pause` 暂停容器
- `ps` 列出容器列表
- `pull` 从 Docker 镜像源服务器拉取指定镜像或者库镜像
- `push` 推送指定镜像或者库镜像至 Docker 源服务器
- `restart` 重启运行的容器
- `rm` 移除一个或者多个容器
- `rmi` 移除一个或多个镜像【无容器使用该镜像才可删除，否则需删除相关容器才可继续或 -f 强制删除】
- `run` 创建一个新的容器并运行一个命令
- `save` 保存一个镜像为一个 tar 包【对应 load】
- `search` 在 Docker Hub 中搜索镜像
- `start` 启动容器
- `stop` 停止容器
- `tag` 给源中镜像打标签
- `top` 查看容器中运行的进程信息
- `unpause` 取消暂停容器
- `version` 查看 Docker 版本号
- `wait` 截取容器停止时的退出状态值

# P23 镜像的分层概念

## 镜像是什么

是一种轻量级、可执行的独立软件包，它包含运行某个软件所需的所有内容，我们把应用程序和配置依赖打包好形成一个可交付的运行环境（包括代码、运行时需要的库、环境变量和配置文件等），这个打包好的运行环境就是 image 镜像文件。

只有通过这个镜像文件才能生成 Docker 容器实例（类似 Java 中 new 出来一个对象）

## 分层的镜像

以我们的 pull 为例，在下载的过程中我们可以看到 Docker 的镜像好像是在一层一层的下载

## UnionFS(联合文件系统)

UnionFS（联合文件系统）：Union 文件系统（UnionFS）是一种分层、轻量级并且高性能的文件系统，它支持对文件系统的修改作为一次提交来一层层的叠加，同时可以将不同目录挂载到同一个虚拟文件系统下（unite several directories into a single virtual filesystem）。Union 文件系统是 Docker 镜像的基础。镜像可以通过分层来进行继承，基于基础镜像（没有父镜像），可以制作各种具体的应用镜像。

特性：一次同时加载多个文件系统，但从外面看起来，只能看到一个文件系统，联合加载会把各层文件系统叠加起来，这样最终的文件系统会包含所有底层的文件和目录。

## Docker 镜像加载原理

Docker 镜像实际上由一层一层的文件系统组成，这种层级的文件系统 UnionFS。

bootfs(boot file system)主要包含 bootloader 和 kernel，bootloader 主要是引导加载 kernel，Linux 刚启动时会加载 bootfs 文件系统，在 Docker 镜像的最底层是引导文件系统 bootfs。这一层与我们典型的 Linux/Unix 系统是一样的，包含 boot 加载器和内核。当 boot 加载完成以后整个内核就在内存中了，此时内存的使用权已由 bootfs 转交给内核，此时系统也会卸载 bootfs。

rootfs(root file system)，在 bootfs 之上，包含的就是典型 Linux 系统中的 /dev, /proc, /bin, /etc 等标准目录和文件。rootfs 就是各种不同的操作系统发行版，比如 Ubuntu，CentOS 等等。

平时我们安装进虚拟机的 CentOS 都是好几个 G，为什么 Docker 这里才 200M？

对于一个精简的 OS，rootfs 可以很小，只需要包括最基本的命令、工具和程序库就可以了，因为底层直接用 Host 的 kernel，自己只需要提供 rootfs 就行了。由此可见对于不同的 Linux 发行版，bootfs 基本是一致的，rootfs 会有差别，因此不同的发行版可以公用 bootfs。

## 为什么 Docker 镜像要采用这种分层结构呢？

镜像分层最大的一个好处就是共享资源，方便复制迁移，就是为了复用。

比如说有多个镜像都从相同的 base 镜像构建而来，那么 Docker Host 只需在磁盘上保存一份 base 镜像；同时内存中也只需加载一份 base 镜像，就可以为所有容器服务了。而且镜像的每一层都可以被共享。

## 重点理解

Docker 镜像层都是只读的，容器层是可写的

当容器启动时，一个新的可写层被加载到镜像的顶部。 这一层通常被称作“容器层”，“容器层”之下的都叫“镜像层”。

所有对容器的改动——无论添加、删除、还是修改文件都只会发生在容器层中。只有容器层是可写的，容器层下面的所有镜像层都是只读的。

# P24 commit 命令上集

`docker commit` 提交容器副本使之成为一个新的镜像

`docker commit -m="提交的描述信息" -a="作者" 容器ID 要创建的目标镜像名:[标签名]`

# P25 commit 命令下集

Docker 中的镜像分层，支持通过扩展现有镜像，创建新的镜像。类似于 Java 继承于一个 Base 基础类，自己再按需扩展。

新镜像是从 base 镜像一层一层叠加生成的。每安装一个软件，就在现有镜像的基础上增加一层

# P26 本地镜像发布到阿里云

- 选择控制台，进入容器镜像服务
- 选择个人实例
- 命名空间
- 仓库名称
- 进入管理界面获得脚本

1. 登录阿里云 Docker Registry
  - `docker login --username=*** registry.cn-qingdao.aliyuncs.com`
  - 用于登录的用户名为阿里云账号全名，密码为开通服务时设置的密码。您可以在访问凭证页面修改凭证密码。
2. 将 Registry 中拉取镜像
  - `docker pull registry.cn-qingdao.aliyuncs.com/atguigubj/myubuntu:[镜像版本号]`
3. 将镜像推送到 Registry
  - `docker login --username=*** registry.cn-qingdao.aliyuncs.com`
  - `docker tag [ImageId] registry.cn-qingdao.aliyuncs.com/atguigubj/myubuntu:[镜像版本号]`
  - `docker push registry.cn-qingdao.aliyuncs.com/atguigubj/myubuntu:[镜像版本号]`

# P27 docker 私有库简介

1. 官方 Docker Hub 地址：http://hub.docker.com/ 中国大陆访问太慢了且准备被阿里云取代的趋势，不太主流。

2. DockerHub、阿里云这样的公共镜像仓库可能不太方便，涉及机密的公司不可能提供镜像给公网，所以需要创建一个本地私人仓库供给团队使用，基于公司内部项目构建镜像。

Docker Registry 是官方提供的工具，可以用于构建私有镜像仓库

1. 下载镜像 Docker Registry
2. 运行私有库 Registry，相当于本地有个私有 Docker Hub
3. 案例演示创建一个新镜像，ubuntu 安装 ifconfig 命令
4. curl 验证私服库上有什么镜像
5. 将新镜像 zzyyubuntu:1.2 修改符合私服规范的 Tag
6. 修改配置文件使之支持 http
7. push 推送到私服库
8. curl 验证私服库上有什么镜像2
9. pull 到本地并运行

# P28 新镜像推送私服库案例

## 运行私有库 Registry，相当于本地有个私有 Docker Hub

`docker run -d -p 5000:5000 -v /zzyyuse/myregistry/:/tmp/registry --privileged=true registry`

默认情况下，仓库被创建在容器的 /var/lib/registry 目录下，建议自行用容器卷映射，方便于宿主机联调

## 案例演示创建一个新镜像，ubuntu 安装 ifconfig 命令

- 从 Hub 上下载 ubuntu 镜像到本地并成功运行
- 原始的 Ubuntu 镜像是不带着 ifconfig 命令的
- 外网连通的情况下，安装 ifconfig 命令并测试通过
  - Docker 容器内执行上述两条命令：
    - `apt-get update`
    - `apt-get install net-tools`
- 安装完成后，commit 我们自己的新镜像
  - `docker commit -m="提交的描述信息" -a="作者" 容器ID 要创建的目标镜像名:[标签名]`
  - 命令：在容器外执行，记得
- 启动我们的新镜像并和原来的对比

## curl 验证私服库上有什么镜像

`curl -XGET http://192.168.111.162:5000/v2/_catalog`

可以看到，目前私服库没有任何镜像上传过

## 将新镜像 zzyyubuntu:1.2 修改符合私服规范的 Tag

按照公式：`docker tag 镜像:Tag Host:Port/Repsitory:Tag`

自己 host 主机 IP 地址，填写自己的，不要粘贴

使用命令 docker tag 将 zzyyubuntu:1.2 这个镜像修改为 192.168.111.162:5000/zzyyubuntu:1.2

## 修改配置文件使之支持 http

`cat /etc/docker/daemon.json`

`"insecure-registries":["192.168.111.162:500"]`

上述理由：docker 默认不允许 http 方式推送镜像，通过配置选项来取消这个限制 ==> 修改完后如果不生效，建议重启 docker

# P29 容器数据卷是什么

## 坑：容器卷记得加入 --privileged=true

Docker 挂载主机目录访问如果出现 cannot open directory .: Permission denied

解决办法：在挂载目录后多加一个 --privileged=true 参数即可

如果是 CentOS 7 安全模块会比之前系统版本加强，不安全的会先禁止，所以目录挂载的情况被默认为不安全的行为，在 SELinux 里面挂载目录被禁止掉了，如果要开启，我们一般使用 --privileged=true 命令，扩大容器的权限解决挂载目录没有权限的问题，也即使用该参数，container 内的 root 拥有真正的 root 权限，否则，container 内的 root 只是外部的一个普通用户权限。

## 是什么

卷就是目录或文件，存在于一个或多个容器中，由 docker 挂载到容器，但不属于联合文件系统，因此能够绕过 Union File System 提供一些用于持续存储或共享数据的特性。

卷的设计目的就是数据的持久化，完全独立于容器的生命周期，因此 Docker 不会在容器删除时删除其挂载的数据卷。

- 一句话：有点类似我们 Redis 里面的 rdb 和 aof 文件
- 将 docker 容器内的数据保存进宿主机的磁盘中
- 运行一个带有容器卷存储功能的容器实例 `docker run -it --privileged=true -v /宿主机绝对路径目录:/容器内目录 镜像名`

# P30 容器数据卷能干嘛

将运用和运行的环境打包成镜像，run 后形成容器实例运行，但是我们对数据的要求希望是持久化的

Docker 容器产生的数据，如果不备份，那么当容器实例删除后，容器内的数据自然也就没有了。为了能保存数据，在 Docker 中我们使用卷。

特点：
1. 数据卷可在容器之间共享或重用数据
2. 卷中的更改可以直接实时生效
3. 数据卷中的更改不会包含在镜像的更新中
4. 数据卷的生命周期一直持续到没有容器使用它为止

# P31 容器卷和主机互通互联

数据卷案例

1. 宿主vs容器之间映射添加容器卷
   - 直接命令添加
     - 命令：`docker run -it --privileged=true -v /宿主机绝对路径目录:/容器内目录 镜像名`
     - 查看数据卷是否挂载成功
       - `docker inspect 容器ID`
       - 查看 "Mounts" 里的 "Source"、"Destination"
     - 容器和宿主机之间数据共享
       1. docker 修改，主机同步获得
       2. 主机修改，docker 同步获得
       3. docker 容器 stop，主机修改，docker 容器重启看数据是否同步。
2. 读写规则映射添加说明
3. 卷的继承和共享

# P32 容器卷ro和rw读写规则

读写规则映射添加说明

- 读写（默认）
  - `docker run -it --privileged=true -v /宿主机绝对路径目录:/容器内目录:rw 镜像名`
  - 默认同上案例，默认就是 rw
- 只读
  - 容器实例内部被限制，只能读取不能写
  - `docker run -it --privileged=true -v /宿主机绝对路径目录:/容器内目录:ro 镜像名`
  - 此时如果宿主机写入内容，可以同步给容器内，容器可以读到。

# P33 容器卷之间的继承

卷的继承和共享
- 容器1完成和宿主机的映射
  - `docker run -it --privileged=true -v /mydocker/u:/tmp --name u1 ubuntu`
- 容器2继承容器1的卷规则
  - `docker run -it --privileged=true --volume-from 父类 --name u2 ubuntu`

# P34 docker 上安装常见软件说明

总体步骤
- 搜索镜像
- 拉取镜像
- 查看镜像
- 启动镜像
  - 服务端口映射
- 停止镜像
- 移除容器

# P35 tomcat 安装上集

- docker hub 上面查找 tomcat 镜像
- 从 docker hub 上拉取 tomcat 镜像到本地
- docker images 查看是否有拉取到的 tomcat
- 使用 tomcat 镜像创建容器实例（也叫运行镜像）
  - `docker run -it -p 8080:8080 tomcat`
  - -p 小写，主机端口:docker容器端口
  - -P 大写，随机分配端口
  - i 交互
  - t 终端
  - d 后台
- 访问首页
  - 404

- 免修改版说明

# P36 tomcat 安装下集

## 访问首页

- 问题：404
- 解决：可能没有映射端口或者没有关闭防火墙；把 webapps.dist 目录换成 webapps

## 免修改版说明

tomcat 8（jdk8）

# P37 mysql 安装上集

- docker hub 上面查找 mysql 镜像
- 从 docker hub 上（阿里云加速器）拉取 mysql 镜像到本地标签为 5.7
- 使用 mysql 5.7 镜像创建容器（也叫运行镜像）
  - 简单版
  - 实战版

## 使用 mysql 5.7 镜像创建容器（也叫运行镜像）简单版

- 使用 mysql 镜像
  - `docker run -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7`
  - `docker ps`
  - `docker exec -it 容器ID /bin/bash`
  - `mysql -uroot -p`
- 建库建表插入数据
- 外部 Win10 也来连接运行在 docker 上的 mysql 容器实例服务
- 问题
  - 无法插入中文数据，报错
    - docker 默认字符集编码隐患：`SHOW VARIABLES LIKE 'character%'` latin1
  - 删掉容器后，里面的 mysql 数据怎么办？（容器数据卷）

# P38 mysql 安装下集

## 使用 mysql 5.7 镜像创建容器（也叫运行镜像）实战版

- 新建 mysql 容器实例

  - `docker run -d -p 3306:3306 --privileged=true -v /zzyyuse/mysql/log:/var/log/mysql -v /zzyyuse/mysql/data:/var/lib/mysql -v /zzyyuse/mysql/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=123456 --name mysql mysql:5.7`

- 新建 my.cnf

  - 通过容器卷同步给 mysql 容器实例

  - ```
    [client]
    default_character_set=utf8
    [mysqld]
    collation_server = utf8_general_ci
    character_set_server = utf8
    ```

- 重新启动 mysql 容器实例再重新进入并查看字符编码

  - `docker restart mysql`

  - `docker exec -it mysql bash`

  - `mysql -uroot -p`

  - `SHOW VARIABLES LIKE 'character%'`

- 再新建库新建表再插入中文测试

- 结论

  - 之前的 DB 无效
  - 修改字符集操作+重启 mysql 容器实例之后的 DB 有效，需要新建
  - 结论：docker 安装完 MySQL 并 run 出容器后，建议先修改完字符集编码后再新建 mysql 库-表-插数据

- 假如将当前容器实例删除，再重新来一次，之前建的 db01 实例还有吗？

# P39 redis 常规安装

- 从 docker hub 上（阿里云加速器）拉取 redis 镜像到本地标签为 6.0.8
- 入门命令
- 命令提醒：容器卷记得加入 --privileged=true
- 在 CentOS 宿主机下新建目录 /app/redis `mkdir -p /app/redis`
- 将一个 redis.conf 文件模板拷贝进 /app/redis 目录下
- /app/redis 目录下修改 redis.conf 文件
  - 默认出厂的原始 redis.conf
  - 开启 redis 验证 可选
    - `requirepass 123`
  - 允许 redis 外地连接 必须
    - 注释掉`# bind 127.0.0.1`
  - daemonize no
    - 将 daemonize yes 注释起来或者 daemonize no 设置，因为该配置和 docker run 中 -d 参数冲突，会导致容器一直启动失败
  - 开启 redis 数据持久化 `appendonly yes` 可选
- 使用 redis 6.0.8 镜像创建容器（也叫运行镜像）
  - `docker run -p 6379:6379 --name myr3 --privileged=true -v /app/redis/redis.conf:/etc/redis/redis.conf -v /app/redis/data:/data -d redis:6.0.8 redis-server /etc/redis/redis.conf`
- 测试 redis-cli 连接上来
- 请证明 docker 启动使用了我们自己指定的配置文件
- 测试 redis-cli 连接上来第 2 次
