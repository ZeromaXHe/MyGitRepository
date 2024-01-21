https://www.bilibili.com/video/BV1gr4y1U7CY

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

# P40 高级篇简介

1. Docker 复杂安装详说
2. DockerFile 解析
3. Docker 微服务实战
4. Docker 网络
5. Docker-compose 容器编排
6. Docker 轻量级可视化工具 Protainer
7. Docker 容器监控之 CAdvisor + InfluxDB + Granfana
8. 终章总结

# P41 mysql 主从复制 docker 版

5.7

## 主从搭建步骤

1. 新建主服务器容器实例 3307

   - `docker run -p 3307:3306 --name mysql-master -v /mydata/mysql-master/log:/var/log/mysql -v /mydata/mysql-master/data:/var/lib/mysql -v /mydata/mysql-master/conf:/etc/mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7`

2. 进入 /mydata/mysql-master/conf 目录下新建 my.cnf

   - ```
     [mysqld]
     ## 设置 server_id，同一局域网中需要唯一
     server_id=101
     ## 指定不需要同步的数据库名称
     binlog-ignore-db=mysql
     ## 开启二进制日志功能
     log-bin=mall-mysql-bin
     ## 设置二进制日志使用内存大小（事务）
     binlog_cache_size=1M
     ## 设置使用的二进制日志格式（mixed，statement,row）
     binlog_format=mixed
     ## 二进制日志过期清理时间。默认值为0，表示不自动清理
     expire_logs_days=7
     ## 跳过主从复制中遇到的所有错误或指定类型的错误，避免 slave 端复制中断。
     ## 如：1062 错误是指一些主键重复，1032 错误是因为主从数据库数据不一致
     slave_skip_errors=1062
     ```

3. 修改完配置后重启 master 实例

   - `docker restart mysql-master`

4. 进入 mysql-master 容器

   - `docker exec -it mysql-master /bin/bash`
   - `mysql -uroot -proot`

5. master 容器实例内创建数据同步用户

   - `CREATE USER 'slave'@'%' IDENTIFIED BY '123456'`
   - `GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'%'`

6. 新建从服务器容器实例 3308

   - `docker run -p 3308:3306 --name mysql-slave -v /mydata/mysql-slave/log:/var/log/mysql -v /mydata/mysql-slave/data:/var/lib/mysql -v /mydata/mysql-slave/conf:/etc/mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7`

7. 进入 /mydata/mysql-slave/conf 目录下新建 my.cnf

   - ```
     [mysqld]
     ## 设置 server_id，同一局域网中需要唯一
     server_id=102
     ## 指定不需要同步的数据库名称
     binlog-ignore-db=mysql
     ## 开启二进制日志功能,以备 Slave 作为其它数据库实例的 Master 时使用
     log-bin=mall-mysql-slave1-bin
     ## 设置二进制日志使用内存大小（事务）
     binlog_cache_size=1M
     ## 设置使用的二进制日志格式（mixed，statement,row）
     binlog_format=mixed
     ## 二进制日志过期清理时间。默认值为0，表示不自动清理
     expire_logs_days=7
     ## 跳过主从复制中遇到的所有错误或指定类型的错误，避免 slave 端复制中断。
     ## 如：1062 错误是指一些主键重复，1032 错误是因为主从数据库数据不一致
     slave_skip_errors=1062
     ## relay_log 配置中继日志
     relay_log=mall-mysql-relay-bin
     ## log_slave_updates 表示 slave 将复制事件写进自己的二进制日志
     log_slave_updates=1
     ## slave 设置为只读（具有 super 权限的用户除外）
     read_only=1
     ```

8. 修改完配置后重启 slave 实例

   - `docker restart mysql-slave`

9. 在主数据库中查看主从同步状态

   - `show master status;`

10. 进入 mysql-slave 容器

    - `docker exec -it mysql-slave /bin/bash`
    - `mysql -uroot -proot`

11. 在从数据库中配置主从复制

    - `change master to master_host='宿主机ip', master_user='slave', master_password='123456', master_port=3307, master_log_file='mall-mysql-bin.000001', master_log_pos=617, master_connect_retry=30`
    - master_host: 主数据库的 IP 地址
    - master_port: 主数据库的运行端口
    - master_user: 在主数据库创建的用于同步数据的用户账号
    - master_password: 在主数据库创建的用于同步数据的用户密码
    - master_log_file: 指定从数据库要复制数据的日志文件，通过查看主数据的状态，获取 File 参数
    - master_log_pos: 指定从数据库从哪个位置开始复制数据，通过查看主数据的状态，获取 Position 参数
    - master_connect_retry: 连接失败重试的时间间隔，单位为秒

12. 在从数据库中查看主从同步状态

    - `show slave status \G;` (\G 可加可不加，效果是按键值对的方式纵向排列)
    - Slave_IO_Running: No
    - Slave_SQL_Running: No

13. 在从数据库中开启主从同步

    - `start slave;`

14. 查看从数据库状态发现已经同步

    - `show slave status \G;` 
    - Slave_IO_Running: Yes
    - Slave_SQL_Running: Yes

15. 主从复制测试

# P42 分布式存储之哈希取余算法

cluster（集群）模式-docker版

哈希槽分区进行亿级数据存储

- 面试题：1~2亿条数据需要缓存，请问如何设计这个存储案例
- 回答：单机单台 100% 不可能，肯定是分布式存储，用 Redis 如何落地？
- 上述问题阿里 P6 ~ P7 工程案例和场景设计类必考题目，一般业界有 3 种解决方案
  - 哈希取余分区
  - 一致性哈希算法分区
  - 哈希槽分区



哈希取余分区

- 2 亿条记录就是 2 亿个 kv，我们单机不行必须要分布式多机，假设有 3 台机器构成一个集群，用户每次读写操作都是根据公式：hash(key) % N 个机器台数，计算出哈希值，用来决定数据映射到哪一个节点上
- 优点：
  - 简单粗暴，直接有效，只需要预估好数据规划好节点，例如 3 台、8 台、10 台，就能保证一段时间的数据支撑。使用 Hash 算法让固定的一部分请求落到同一台服务器上，这样每台服务器固定处理一部分请求（并维护这些请求的信息），起到负载均衡+分而治之的作用。
- 缺点：
  - 原来规划好的节点，进行扩容或者缩容就比较麻烦了。不管扩缩，每次数据变动导致节点有变动，映射关系需要重新进行计算，在服务器个数固定不变时没有问题，如果需要弹性扩容或故障停机的情况下，原来的取模公式就会发生变化：Hash(key)/3 会变成 Hash(key)/?。此时地址经过取余运算的结果将发生很大的变化，根据公式获取的服务器也会变得不可控。
  - 某个 Redis 机器宕机了，由于台数数量变化，会导致 hash 取余全部数据重新洗牌。

# P43 分布式存储之一致性哈希算法

## 是什么

- 一致性哈希算法在 1997 年由麻省理工学院提出的，设计目的是为了解决分布式缓存数据变动和映射问题。
- 某个机器宕机了，分母数量改变了，自然取余数不 OK 了

## 能干嘛

- 提出一致性 Hash 解决方案。目的是当服务器个数发生变动时，尽量减少影响客户端到服务器的映射关系

## 3大步骤

- 算法构建一致性哈希环
  - 一致性哈希算法必然有个 hash 函数并按照算法产生 hash 值，这个算法的所有可能哈希值会构成一个全量集，这个集合可以成为一个 hash 空间`[0, 2^32 - 1]`，这个是一个线性空间，但是在算法中，我们通过适当的逻辑控制将它首尾相连（0 = 2^32），这样让它逻辑上形成了一个环形空间。
  - 它也是按照使用取模的方法。前面笔记介绍的节点取模法是对节点（服务器）的数量进行取模。而一致性 Hash 算法是对 2^32 取模，简单来说，一致性 Hash 算法将整个哈希值空间组织成一个虚拟的圆环，如假设某哈希函数 H 的值空间为 0 ~ 2^32 - 1（即哈希值是一个 32 位无符号整形），整个哈希环如下图：整个空间按顺时针方向组织，圆环的正上方的点代表 0，0 点右侧的第一个点代表 1，以此类推，2、3、4…… 直到 2^32 - 1，也就是说 0 点左侧的第一个点。0 和 2^32-1 在零点钟方向重合，我们把这个由 2^32 个点组成的圆环称为 Hash 环
- 服务器 IP 节点映射
  - 将集群中各个 IP 节点映射到环上的某一个位置。
  - 将各个服务器使用 Hash 进行一个哈希，具体可以选择服务器的 IP 或主机名作为关键字进行哈希，这样每台机器就能确定其在哈希环上的位置。假如 4 个节点 Node A、B、C、D，经过 IP 地址的哈希函数计算（hash(ip)），使用 IP 地址哈希后在环空间的位置如下
- key 落到服务器的落键规则
  - 当我们需要存储一个 kv 键值对时，首先计算 key 的 hash 值，hash(key)，将这个 key 使用相同的函数 Hash 计算出哈希值并确定此数据在环上的位置，从此位置沿环顺时针“行走”，第一台遇到的服务器就是其应该定位到的服务器，并将该键值对存储在该节点上。

## 优点

- 一致性哈希算法的容错性
  - 假如 Node C 宕机，可以看到此时对象 A、B、D 不会受到影响，只有 C 对象被重定位到 Node D。一般的，在一致性 Hash 算法中，如果一台服务器不可用，则受影响的数据仅仅是此服务器到其环空间中前一台服务器（即沿着逆时针方向行走遇到的第一台服务器）之间数据，其它不会受到影响。简单说，就是 C 挂了，受到影响的只是 B、C 之间的数据，并且这些数据会转移到 D 进行存储。
- 一致性哈希算法的扩展性
  - 数据量增加了，需要增加一台节点 Node X，X 的位置在 A 和 B 之间，那受到影响的也就是 A 到 X 之间的数据，重新把 A 到 X 的数据录入到 X 上即可，不会导致 hash 取余全部数据重新洗牌。

## 缺点

- 一致性哈希算法的数据倾斜问题
  - 一致性Hash算法在服务节点太少时，容易因为节点分布不均匀而造成数据倾斜（被缓存的对象大部分集中缓存在某一台服务器上）问题

## 总结

为了在节点发生改变时尽可能少的迁移数据

将所有的存储节点排列在首尾相接的 Hash 环上，每个 key 在计算 Hash 后会顺时针找到临近的存储节点存放。而当有节点加入或退出时仅影响该节点在 Hash 环上顺时针相邻的后续节点。

- 优点：加入和删除节点只影响哈希环中顺时针方向的相邻的节点，对其他节点无影响
- 缺点：数据的分布和节点的位置有关，因为这些节点不是均匀分布在哈希环上的，所以数据在进行存储时达不到均匀分布的效果。

# P44 分布式存储之哈希槽算法

## 是什么

为什么出现

- 一致性哈希算法的数据倾斜问题
- 哈希槽实质就是一个数组，数组[0, 2^14-1] 形成 hash slot 空间

能干什么

- 解决均匀分配的问题，在数据和节点之间又加入了一层，把这层称为哈希槽（slot），用于管理数据和节点之间的关系，现在就相当于节点上放的是槽，槽里放的是数据。
- 槽解决的是粒度问题，相当于把粒度变大了，这样便于数据移动。
- 哈希解决的是映射问题，使用 key 的哈希值来计算所在的槽，便于数据分配。

多少个 hash 槽

- 一个集群只能有 16384 个槽，编号 0~16383（0 ~ 2^14-1）。这些槽会分配给集群中的所有主节点，分配策略没有要求。可以指定哪些编号的槽分配给哪个主节点。集群会记录节点和槽的对应关系。解决了节点和槽的关系后，接下来就需要对 key 求哈希值，然后对 16384 取余，余数是几 key 就落入对应的槽里，slot = CRC16(key) % 16384。以槽为单位移动数据，因为槽的数目是固定的，处理起来比较容易，这样数据移动问题就解决了。
- 为什么是 16384 个？
  - CRC 16 算法产生的 hash 值有 16 bit，该算法可以产生 2^16 = 65536 个值。为什么不 mod 65536 而选择 mod 16384？
  - 说明1：
    - 正常的心跳数据包带有节点的完整配置，可以用幂等方式用旧的节点替换旧节点，以便更新旧的配置。
    - 这意味着它们包含原始节点的插槽配置，该节点使用 2k 的空间和 16k 的插槽，但是使用 65k 的插槽会使用 8k 的空间。
    - 同时，由于其他设计折衷，Redis 集群不太可能扩展到 1000 个以上的主节点。
    - 因此 16k 处于正确的范围内，以确保每个主机具有足够的插槽，最多可容纳 1000 个矩阵，但数量足够少，可以轻松地将插槽配置作为原始位图传播。请注意，在小型群集中，位图将难以压缩，因为当 N 较小时，位图将设置的 slot / N 位占设置位的很大百分比。
  - 说明2：
    1. 如果槽位为 65536，发送心跳信息的消息头达 8k，发送的心跳包过于庞大
    2. Redis 的集群主节点数量基本不可能超过 1000 个
    3. 槽位越小，节点少的情况下，压缩比高，容易传输

## 哈希槽计算

Redis 集群中内置了 16384 个哈希槽，Redis 会根据节点数量大致均等的将哈希槽映射到不同的节点。当需要在 Redis 集群中放置一个 key-value 时，Redis 先对 key 使用 CRC16 算法算出一个结果，然后把结果对 16384 求余数，这样每个 key 都会对应一个编号在 0~16383 之间的哈希槽，也就是映射到某个节点上。

# P45 3主3从redis集群配置上集

3主3从redis集群配置

- 关闭防火墙+启动docker后台服务
- 新建6个docker容器实例
  - `docker run -d --name redis-node-1 --net host --privileged=true -v /data/redis/share/redis-node-1:/data redis:6.0.8 --cluster-enabled yes --appendonly yes --port 6381`
  - `docker run -d --name redis-node-2 --net host --privileged=true -v /data/redis/share/redis-node-2:/data redis:6.0.8 --cluster-enabled yes --appendonly yes --port 6382`
  - ……
  - `docker run` 创建并运行 docker 容器实例
  - `--name redis-node-6` 容器名字
  - `--net host` 使用宿主机的 IP 和端口，默认
  - `--privileged=true` 获取宿主机 root 用户权限
  - `-v /data/redis/share/redis-node-6:/data` 容器卷，宿主机地址：docker 内部地址
  - `redis:6.0.8` redis 镜像和版本号
  - `--cluster-enabled yes` 开启 redis 集群
  - `--appendonly yes` 开启持久化
  - `--port 6386` redis 端口号
- 进入容器redis-node-1并为6台机器构建集群关系
  - 进入容器 `docker exec -it redis-node-1 /bin/bash`
  - 构建主从关系
  - 一切 OK 的话，3主3从搞定
- 链接进入6381作为切入点，查看集群状态



## 构建主从关系

注意，进入 docker 容器后才能执行以下命令，且注意自己的真实 IP 地址

```shell
redis-cli --cluster create 192.168.111.147:6381 192.168.111.147:6382 192.168.111.147:6383 192.168.111.147:6384 192.168.111.147:6385 192.168.111.147:6386 --cluster-replicas 1
```

`--cluster-replicas 1` 表示为每一个 master 创建一个 slave 节点

# P46 3主3从redis集群配置中集

## 链接进入6381作为切入点，查看集群状态

- 连接进入 6381 作为切入点，查看节点状态
- cluster info
- cluster nodes

# P47 3主3从redis集群配置下集

# P48 redis集群读写error说明

## 主从容错切换迁移案例

- 数据读写存储
  - 启动 6 机构成的集群并通过 exec 进入
  - 对 6381 新增两个 key（error）
  - 防止路由失效加参数 -c 并新增两个 key `redis-cli -p 6381 -c`
  - 查看集群信息 `redis-cli --cluster check 192.168.111.147:6381`
- 容错切换迁移

# P49 redis 集群读写路由增强正确案例

# P50 查看集群信息 cluster check

# P51 主从容错切换迁移

## 容错切换迁移

- 主 6381 和从机切换，先停止主机 6381
- 再次查看集群信息
  - `docker exec -it redis-node-2 /bin/bash`
  - `redis-cli -p 6382 -c`
  - `cluster nodes`
- 先还原之前的 3 主 3 从
- 查看集群状态

# P52 主从扩容需求分析

# P53 主从扩容案例演示

## 主从扩容案例

- 新建 6387、6388 两个节点+新建后启动+查看是否 8 节点
  - `docker run -d --name redis-node-7 --net host --privileged=true -v /data/redis/share/redis-node-7:/data redis:6.0.8 --cluster-enabled yes --appendonly yes --port 6387`
  - `docker run -d --name redis-node-8 --net host --privileged=true -v /data/redis/share/redis-node-8:/data redis:6.0.8 --cluster-enabled yes --appendonly yes --port 6388`
  - `docker ps`
- 进入 6387 容器实例内部 `docker exec -it redis-node-7 /bin/bash`
- 将新增的 6387 节点（空槽号）作为 master 节点加入原集群
  - `redis-cli --cluster add-node 自己实际IP地址:6387 自己实际IP地址:6381`
  - 6387 就是将要作为 master 新增节点
  - 6381 就是原来集群节点里面的领路人，相当于 6387 拜托 6381 从而找到组织加入集群
- 检查集群情况第 1 次
  - `redis-cli --cluster check 真实IP地址:6381`
  - 0 slots | 0 slaves
- 重新分配槽号
  - 重新分配槽号命令：`redis-cli --cluster reshard IP地址:端口号`
  - `redis-cli --cluster reshard 192.168.111.157:6381`
- 检查集群情况第 2 次
- 为主节点 6387 分配从节点 6388
  - 命令：`redis-cli --cluster add-node ip:新slave端口 ip:新master端口 --cluster-slave --cluster-master-id 新主机节点ID`
  - `redis-cli --cluster add-node 192.168.111.147:6388 192.168.111.147:6387 --cluster-slave --cluster-master-id e4781f644d4a4e4d4b4d107157b9ba8144631451`
- 检查集群情况第 3 次

# P54 主从缩容需求分析

1. 先清除从节点 6388
2. 清出来的槽号重新分配
3. 再删除 6387
4. 恢复成 3 主 3 从

# P55 主从缩容案例演示

## 主从缩容案例

- 目的：6387 和 6388 下线
- 检查集群情况 1 获得 6388 的节点 ID
  - `redis-cli --cluster check 192.168.111.147:6382`
- 从集群中将 4 号从节点 6388 删除
  - 命令：`redis-cli --cluster del-node ip:从机端口 从机6388节点ID`
  - `redis-cli --cluster del-node 192.168.111.147:6388 5d149074b7e57b802287d1797a874ed7a1a284a8`
- 将 6387 的槽号清空，重新分配，本例将清出来的槽号都给 6381
  - `redis-cli --cluster reshard 192.168.111.147:6381`
- 检查集群情况第二次
- 将 6387 删除
  - 命令：`redis-cli --cluster del-node ip:端口 6387节点ID`
  - `redis-cli --cluster del-node 192.168.111.147:6387 e4781f644d4a4e4d4b4d107157b9ba8144631451`
- 检查集群情况第三次

# P56 分布式存储案例小总结

# P57 Dockerfile 简介

## 是什么

- Dockerfile 是用来构建 Docker 镜像的文本文件，是由一条条构建镜像所需的指令和参数构成的脚本
- 概述
- 官网
  - https://docs.docker.com/engine/reference/builder
- 构建三步骤
  - 编写 Dockerfile 文件
  - docker build 命令构建镜像
  - docker run 依镜像运行容器实例

# P58 Dockerfile 构建过程解析

## Dockerfile 内容基础知识

1. 每条保留字指令都必须为大写字母且后面要跟随至少一个参数
2. 指令按照从上到下，顺序执行
3. `#` 表示注释
4. 每条指令都会创建一个新的镜像层并对镜像进行提交

## Docker 执行 Dockerfile 的大致流程

1. docker 从基础镜像运行一个容器
2. 执行一条指令并对容器做出修改
3. 执行类似 docker commit 的操作提交一个新的镜像层
4. docker 再基于刚提交的镜像运行一个新容器
5. 执行 dockerfile 中的下一条指令直到所有指令都执行完成

## 小总结

从应用软件的角度来看，Dockerfile、Docker 镜像与 Docker 容器分别代表软件的三个不同阶段

- Dockerfile 是软件的原材料
- Docker 镜像是软件的交付品
- Docker 容器则可以认为是软件镜像的运行态，也即依照镜像运行的容器实例

Dockerfile 面向开发，Docker 镜像成为交付标准，Docker 容器则涉及部署与运维，三者缺一不可，合力充当 Docker 体系的基石。

1. Dockerfile，需要定义一个 Dockerfile，Dockerfile 定义了进程需要的一切东西。Dockerfile 涉及的内容包括执行代码或者是文件、环境变量、依赖包、运行时环境、动态链接库、操作系统的发行版、服务进程和内核进程（当应用进程需要和系统服务和内核进程打交道，这时需要考虑如何设计 namespace 的权限控制）等等。
2. Docker 镜像，在用 Dockerfile 定义一个文件之后，docker build 时会产生一个 Docker 镜像，当运行 Docker 镜像时会真正开始提供服务
3. Docker 容器，容器是直接提供服务的。

# P59 Dockerfile 保留字简介

- 参考 tomcat8 的 dockerfile 入门
  - https://github.com/docker-library/tomcat
- `FROM`：基础镜像，当前新镜像是基于哪个镜像的，指定一个已经存在的镜像作为模板，第一条必须是 FROM
- `MAINTAINER`：镜像维护者的姓名和邮箱地址
- `RUN`：容器构建时需要运行的命令
  - 两种格式：shell 格式和 exec 格式
    - shell 格式: `RUN <命令>`
    - exec 格式：`RUN ["可执行文件", "参数1", "参数2"...]`
  - RUN 是在 docker build 时运行
- `EXPOSE`：当前容器对外暴露出的端口
- `WORKDIR`：指定在创建容器后，终端默认登陆的进来工作目录，一个落脚点
- `USER`：指定该镜像以什么样的用户去执行，如果都不指定，默认是 root
- `ENV`：用来在构建镜像过程中设置环境变量
  - `ENV MY_PATH /usr/mytest` 这个环境变量可以在后续的任何 RUN 指令中使用，这就如同在命令前面指定了环境变量前缀一样；也可以在其他指令中直接使用这些环境变量，比如：`WORKDIR $MY_PATH`
- `ADD`：将宿主机目录下的文件拷贝进镜像且会自动处理 URL 和解压 tar 压缩包
- `COPY`：类似 ADD，拷贝文件和目录到镜像中。将从构建上下文目录中<源路径>的文件/目录复制到新的一层的镜像内的<目标路径>位置
- `VOLUME`：容器数据卷，用于数据保存和持久化工作
- `CMD`：指定容器启动之后要干的事情
  - 两种格式：shell 格式和 exec 格式
    - shell 格式：`CMD <命令>`
    - exec 格式：`CMD ["可执行文件", "参数1", "参数2"...]`
    - 参数列表格式：`CMD ["参数1", "参数2"...]`，在指定了 `ENTRYPOINT` 指令后，用 `CMD` 指定具体的参数
  - 注意
    - Dockerfile 中可以有多个 CMD 指令，但只有最后一个会生效，CMD 会被 docker run 之后的参数替换
    - 参考官网 Tomcat 的 dockerfile 演示讲解
  - 它和前面 RUN 命令的区别
    - CMD 是在 docker run 时运行
    - RUN 是在 docker build 时运行
- `ENTRYPOINT`：也是用来指定一个容器启动时要运行的命令
  - 类似于 CMD 命令，但是 ENTRYPOINT 不会被 docker run 后面的命令覆盖，而且这些命令行参数会被当作参数送给 ENTRYPOINT 指令指定的程序
  - 命令格式和案例说明
    - 命令格式：`ENTRYPOINT ["可执行文件", "参数1", "参数2"...]`
    - ENTRYPOINT 可以和 CMD 一起用，一般是变参才会使用 CMD，这里的 CMD 等于是在给 ENTRYPOINT 传参
    - 当指定了 ENTRYPOINT 后，CMD 的含义就发生了变化，不再是直接运行其命令而是将 CMD 的内容作为参数传递给 ENTRYPOINT 指令，他两个组合会变成 `<ENTRYPOINT> "<CMD>"`
  - 优点
  - 注意

# P60 centos 之 dockerfile 需求说明

- 要求
  - CentOS 7 镜像具备 vim + ifconfig +  jdk8
  - JDK 的下载镜像地址
- 编写
- 构建
- 运行
- 再体会下 UnionFS（联合文件系统）

# P61 centos 之 dockerfile 案例演示

## 编写

准备编写 Dockerfile 文件（大写字母D）

```dockerfile
FROM centos
MAINTAINER zzyy<zzyybs@126.com>

ENV MYPATH /usr/local
WORKDIR $MYPATH

# 安装 vim 编辑器
RUN yum -y install vim
# 安装 ifconfig 命令查看网络 IP
RUN yum -y install net-tools
# 安装 java8 及 lib 库
RUN yum -y install glibc.i686
RUN mkdir /usr/local/java
# ADD 是相对路径 jar，把 jdk-8u171-linux-x64.tar.gz 添加到容器中，安装包必须要和 Dockerfile 文件在同一位置
ADD jdk-8u171-linux-x64.tar.gz /usr/local/java/
# 配置 java 环境变量
ENV JAVA_HOME /usr/local/java/jdk1.8.0_171
ENV JRE_HOME $JAVA_HOME/jre
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib:$CLASSPATH
ENV PATH $JAVA_HOME/bin:$PATH

EXPOSE 80

CMD echo $MYPATH
CMD echo "success------------ok"
CMD /bin/bash
```

## 构建

`docker build -t 新镜像名字:TAG .`

注意，上面 TAG 后面有个空格有个点

## 运行

`docker run -it 新镜像名字:TAG`

# P62 虚悬镜像

最好别搞那么多 RUN，不然一个 RUN 对应 UnionFS 里面的一层

## 虚悬镜像是什么

仓库名、标签都是 `<none>` 的镜像，俗称 dangling image

Dockerfile 写一个

```dockerfile
from ubuntu
CMD echo 'action is success'
```

## 查看

`docker image ls -f dangling=true`

命令结果

## 删除

`docker image prune`

虚悬镜像已经失去存在价值，可以删除
