尚硅谷Redis零基础到进阶，最强redis7教程，阳哥亲自带练（附redis面试题） 2023-02-21 14:55:00

https://www.bilibili.com/video/BV13R4y1v7sP

# P1 redis7实战教程简介

零基础小白

1. 开篇闲聊和课程概述
2. Redis 入门概述
3. Redis 安装配置
4. Redis 10 大数据类型
5. Redis 持久化
6. Redis 事务
7. Redis 管道
8. Redis 发布订阅
9. Redis 复制（replica）
10. Redis 哨兵（sentinel）
11. Redis 集群（cluster）
12. SpringBoot 集成 Redis

大厂高阶篇

1. Redis 单线程 VS 多线程
2. BigKey
3. 缓存双写一致性之更新策略探讨
4. Redis 与 MySQL 数据双写一致性工程落地案例
5. 案例落地实战 bitmap/hyperloglog/GEO
6. 布隆过滤器 BloomFilter
7. 缓存预热+缓存雪崩+缓存击穿+缓存穿透
8. 手写 Redis 分布式锁
9. Redlock 算法和底层源码分析
10. Redis 的缓存过期淘汰策略
11. Redis 经典五大类型源码及底层实现
12. Redis 为什么快？高性能设计之 epoll 和 IO 多路复用深度解析
13. 终章总结

# P2 redis 是什么

是什么

- Redis：REmote Dictionary Server（远程字典服务器）
- 官网解释
  - Remote Dictionary Server（远程字典服务）是完全开源的，使用 ANSIC 语言编写遵守 BSD 协议，是一个高性能的 Key-Value 数据库提供了丰富的数据结构，例如 String、Hash、List、Set、SortedSet 等等。数据是存在内存中的，同时 Redis 支持事务、持久化、LUA 脚本、发布/订阅、缓存淘汰、流技术等多种功能特性提供了主从模式、Redis Sentinel 和 Redis Cluster 集群架构方案
- Redis 之父安特雷兹
  - Salvatore Sanfilippo，一名意大利程序员，大家更习惯称呼他 Antirez

# P3 redis 能干嘛-上集

# P4 redis 能干嘛-中集

# P5 redis 能干嘛-下集

能干嘛

- 主流功能与应用

  1. 分布式缓存，挡在 mysql 数据库之前的带刀护卫

     与传统数据库关系（mysql）

     - Redis 是 key-value 数据库（NoSQL 一种），mysql 是关系数据库
     - Redis 数据操作主要在内存，而 mysql 主要存储在磁盘
     - Redis 在某一些场景使用中要明显优于 mysql，比如计数器、排行榜等方面

  2. 内存存储和持久化（RDB+AOF）

     redis 支持异步将内存中的数据写到硬盘上，同时不影响继续服务

  3. 高可用架构搭配

  4. 缓存穿透、击穿、雪崩

  5. 分布式锁

  6. 队列

     Redis 提供 list 和 set 操作，这使得 Redis 能作为一个很好的消息队列平台来使用。

     我们常通过 Redis 的队列功能做购买限制

  7. 排行榜+点赞

     Redis 提供的 zset 数据类型能够快速实现这些复杂的排行榜。

  8. ...

- 总体功能概述

- 优势

  - 性能极高 - Redis 能读的速度是 110000 次/秒，写的速度是 81000 次/秒
  - Redis 数据类型丰富，不仅仅支持简单的 key-value 类型的数据，同时还提供 list、set、zset、hash 等数据结构的存储
  - Redis 支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用
  - Redis 支持数据的备份，即 master-slave 模式的数据备份

- 小总结

  - 应用场景
    - 缓存加速
    - 分布式会话
    - 排行榜场景
    - 分布式计数器
    - 分布式锁
  - 内存
    - Redis 也支持事务、持久化、LUA 脚本、发布/订阅、缓存淘汰、流技术等多种特性
    - String Hash List Set SortedSet
    - RDB 持久化、AOF 持久化

# P6 redis 去哪下

# P7 redis 怎么玩

怎么玩

- 官网
- 多种数据类型基本操作和配置
- 持久化和复制，RDB/AOF
- 事务的控制
- 复制，集群等

# P8 redis7新特性浅谈

Redis 迭代演化和 Redis 7 新特性浅谈

- 时间推移，版本升级

- Redis 版本迭代推演介绍

  - 几个里程碑式的重要版本

    - 2009 诞生

    - 2010 Redis 1.0

      - Redis data types

    - 2012 Redis 2.6

      - lua
      - pubsub
      - Redis Sentinel V1

    - 2013 Redis 2.8

      - Redis Sentinel V2
      - ipv6

    - 2015 Redis 3.0

      - Redis Cluster
      - GEO

    - 2016 Redis 4.0

      - psync 2.0
      - lazy-free
      - modules
      - rdb-aof

    - 2017 Redis 5.0

      - Stream

    - 2020 Redis 6.0

      - Threaded I/O
      - SSL
      - ACLs

    - 2022 Redis 7.0

      - functions
      - ACL V2
      - sharded-pubsub
      - client-eviction
      - multi-part AOF

    - 5.0 版本是直接升级到 6.0 版本，对于这个激进的升级，Redis 之父 antirez 表现得很有信心和兴奋，所以第一时间发文来阐述 6.0 得一些重大功能“Redis 6.0.0 GA is out！”

    - 随后 Redis 再接再厉，直接王炸 Redis 7.0 —— 2023 年爆款

      2022 年 4 月 27 日 Redis 正式发布了 7.0 更新（其实早在 2022 年 1 月 31 日，Redis 已经预发布了 7.0rc-1，经过社区的考验后，确认没重大 Bug 才会正式发布）

  - 命名规则

    - Redis 从发布至今，已经有十余年的时光了，一直遵循着自己的命名规则：

      版本号第二位如果是奇数，则为非稳定版本，如 2.7、2.9、3.1

      版本号第二位如果是偶数，则为稳定版本，如 2.6、2.8、3.0、3.2

      当前奇数版本就是下一个稳定版本的开发版本，如 2.9 版本是 3.0 版本的开发版本

- Redis 7.0 新特性概述

  - 部分新特性总览
    - 2022 年 4 月正式发布的 Redis 7.0 是目前 Redis 历史版本中变化最大的版本。
    - 首先，它有超过 50 个以上新增命令；其次，它有大量核心特性的新增和改进。
    - Redis Functions
      - 更高效更易用更好管理
      - Lua：EVAL 高开销、无法持久化、主从切换可能丢失
      - Redis Functions：EVALSHA 更低开销、RDB，AOF 均可持久化 支持自动加载、切换不丢失
    - Client-eviction
      - 连接内存占用独立管理
    - Multi-part AOF
      - AOFRW 不再是运维痛点
    - ACL v2
      - 精细化权限管理
    - 新增命令
      - 新增 ZMPOP，BZMPOP，LMPOP，BLMPOP 等新命令，对于 EXPIRE 和 SET 命令，新增了更多的命令参数选项。例如，ZMPOP 的格式如下：ZMPOP numkeys key [key ...] MIN|MAX [COUNT count], 而 BZMPOP 是 ZMPOP 的阻塞版本。
    - listpack 替代 ziplist
      - listpack 是用来替代 ziplist 的新数据结构，在 7.0 版本已经没有 ziplist 的配置了（6.0 版本仅部分数据类型作为过渡阶段在使用）
    - 底层性能提升（和编码关系不大）

- 本次将对 Redis 7 的一部分新特性做说明（not all）

# P9 redis 安装环境要求和准备

# P10 redis 安装和坑排除

1. 下载获得 redis-7.0.0.tar.gz 后将它放入我们的 Linux 目录 /opt

2. /opt 目录下解压 redis

3. 进入目录 cd redis-7.0.0

4. 在 redis-7.0.0 目录下执行 make 命令

5. 查看默认安装目录：usr/local/bin

6. 将默认的 redis.conf 拷贝到自己定义好的一个路径下，比如 /myredis

7. 修改 /myredis 目录下 redis.conf 配置文件做初始化设置

   redis.conf 配置文件，改完后确保生效，记得重启

   1. 默认 daemonize no 改为 daemonize yes
   2. 默认 protected-mode yes 改为 protected-mode no
   3. 默认 bind 127.0.0.1 改为 直接注释掉（默认 bind 127.0.0.1 只能本机访问）或改成本机 IP 地址，否则影响远程 IP 连接
   4. 添加 redis 密码 改为 `requirepass 你自己设置的密码`

8. 启动服务

   /usr/local/bin 目录下运行 redis-server，启用 /myredis 目录下的 redis.conf 文件

   `redis-server /myredis/redis7.conf`

9. 连接服务

   - redis-cli 连接和 ping
   - 备注说明：如果你不配置 Requirepass 就不用密码这一步

10. 大家知道 Redis 端口为啥是 6379 么？

11. 永远的 helloworld

12. 关闭

    - 单实例关闭：redis-cli -a 111111 shutdown
    - 多实例关闭，指定端口关闭：redis-cli -p 6379 shutdown