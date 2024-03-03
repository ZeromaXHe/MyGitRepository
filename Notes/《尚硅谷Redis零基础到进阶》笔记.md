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

# P11 redis 10 大类型之总体概述

4、Redis 10 大数据类型

- which 10
  - 一图
    1. String
    2. List
    3. Set
    4. Hash
    5. Sorted set
    6. Stream
    7. Geospatial
    8. HyperLogLog
    9. Bitmaps
    10. Bitfields
  - 提前声明
    - 这里说的数据类型是 value 的数据类型，key 的类型都是字符串
  - 分别是
    1. redis 字符串（String）
       - String（字符串）
       - string 是 redis 最基本的类型，一个 key 对应一个 value。
       - string 类型是**二进制安全的**，意思是 redis 的 string 可以包含任何数据，比如 jpg 图片或者序列化的对象。
       - string 类型是 Redis 最基本的数据类型，一个 redis 中字符串 value 最多可以是 512M
    2. redis 列表（List）
       - Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的**头部（左边）或者尾部（右边）**
       - 它的底层实际是个**双端链表**，最多可以包含 2^32 - 1 个元素（4294967295，每个列表超过 40 亿个元素）
    3. redis 哈希表（Hash）
       - Redis hash 是一个 string 类型的 field（字段）和 value（值）的映射表，hash 特别适合用于存储对象。
       - Redis 中每个 hash 可以存储 2^32 - 1 键值对（40 多亿）
    4. redis 集合（Set）
       - Redis 的 Set 是 String 类型的**无序集合**。集合成员是唯一的，这就意味着集合中不能出现重复的数据，集合对象的编码可以是 intset 或者 hashtable。
       - Redis 中 Set 集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。
       - 集合中最大的成员数为 2^32 - 1（4294967295，每个集合可存储 40 多亿个成员）
    5. redis 有序集合（ZSet）
       - zset（sorted set，有序集合）
       - Redis zset 和 set 一样也是 string 类型元素的集合，且不允许重复的成员。
       - **不同的是每个元素都会关联一个 double 类型的分数，**redis 正是通过分数来为集合中的成员进行从小到大的排序。
       - **zset 的成员是唯一的，但分数（score）却可以重复。**
       - **zset 集合是通过哈希表实现的，所以添加、删除，查找的复杂度都是 O(1)。集合中最大的成员数为 2^32 - 1**
    6. redis 地理空间（GEO）
       - Redis GEO 主要用于存储地理位置信息，并对存储的信息进行操作，包括：
         - 添加地理位置的坐标
         - 获取地理位置的坐标
         - 计算两个位置之间的距离
         - 根据用户给定的经纬度坐标来获取指定范围内的地理位置集合
    7. redis 基数统计（HypeLogLog）
       - HyperLogLog 是用来做**基数统计**的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定且是很小的。
       - 在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。
       - 但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。
    8. redis 位图（bitmap）
       - Bit arrays (or simply bitmaps，我们可以称之为 位图)
       - 一个字节（一个 byte）= 8 位
       - 上图由许许多多的小格子组成，每一个格子里面只能放 1 或者 0，用它来判断 Y/N 状态。说的专业点，每一个个小格子就是一个个 bit
       - 由 0 和 1 状态表现的二进制位的 bit 数组
    9. redis 位域（bitfield）
       - 通过 bitfield 命令可以一次性操作多个**比特位域（指的是连续的多个比特位）**，它会执行一系列操作并返回一个响应数组，这个数组中的元素对应参数列表中的相应操作的执行结果。
       - 说白了就是通过 bitfield 命令我们可以一次性对多个比特位域进行操作。
    10. redis 流（Stream）
        - Redis Stream 是 Redis 5.0 版本新增加的数据结构。
        - Redis Stream 主要用于消息队列（MQ，Message Queue），Redis 本身是有一个 Redis 发布订阅（pub/sub）来实现消息队列的功能，但它有个缺点就是消息无法持久化，如果出现网络断开、Redis 宕机等，消息就会被丢弃。
        - 简单来说发布订阅（pub/sub）可以分发消息，但无法记录历史消息。
        - 而 Redis Stream 提供了消息的持久化和主备复制功能，可以让任何客户端访问任何时刻的数据，并且能记住每一个客户端的访问位置，还能保证消息不丢失
- 哪里去获得 redis 常见数据类型操作命令
- Redis 键（key）
- 数据类型命令及落地运用

# P12 redis 10 大类型之命令查阅

哪里去获得 redis 常见数据类型操作命令

- 官网英文
  - https://redis.io/commands/
- 中文
  - https://www.redis.cn/commands.html

# P13 redis 10 大类型之 key 操作命令

Redis 键（key）

- 常用

  - | 序号 | 命令                                 | 描述                                                         |
    | ---- | ------------------------------------ | ------------------------------------------------------------ |
    | 1    | DEL key                              | 该命令用于在 key 存在时删除 key                              |
    | 2    | DUMP key                             | 序列化给定 key，并返回被序列化的值                           |
    | 3    | EXIST key                            | 检查给定 key 是否存在                                        |
    | 4    | EXPIRE key seconds                   | 为给定 key 设置过期时间                                      |
    | 5    | EXPIREAT key timestamp               | EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置过期时间。不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳（unix timestamp） |
    | 6    | PEXPIRE key milliseconds             | 设置 key 的过期时间亿以毫秒计                                |
    | 7    | PEXPIREAT key milliseconds-timestamp | 设置 key 过期时间的时间戳（unix timestamp）以毫秒计          |
    | 8    | KEYS pattern                         | 查找所有符合给定模式（pattern）的 key                        |
    | 9    | MOVE key db                          | 将当前数据库的 key 移动到给定的数据库 db 当中                |
    | 10   | PERSIST key                          | 移除 key 的过期时间，key 将持久保持                          |
    | 11   | PTTL key                             | 以毫秒为单位返回 key 的剩余的过期时间                        |
    | 12   | TTL key                              | 以秒为单位，返回给定 key 的剩余生存时间（TTL，time to live） |
    | 13   | RANDOMKEY                            | 从当前数据库中随机返回一个 key                               |
    | 14   | RENAME key newkey                    | 修改 key 的名称                                              |
    | 15   | RENAMENX key newkey                  | 仅当 newkey 不存在时，将 key 改名为 newkey                   |
    | 16   | TYPE key                             | 返回 key 所存储的值的类型                                    |

- 案例

  - keys *
    - 查看当前库所有的 key
  - exists key
    - 判断某个 key 是否存在
  - type key
    - 查看你的 key 是什么类型
  - del key
    - 删除指定的 key 数据
  - unlink key
    - 非阻塞删除，仅仅将 keys 从 keyspace 元数据中删除，真正的删除会在后续异步中操作。
  - ttl key
    - 查看还有多少秒过期 ，-1 表示永不过期，-2 表示已过期
  - expire key 秒钟
    - 为给定的 key 设置过期时间
  - move key dbindex [0-15]
    - 将当前数据库的 key 移动到给定的数据库 db 当中
  - select dbindex
    - 切换数据库 [0-15]，默认为 0
  - dbsize
    - 查看当前数据库 key 的数量
  - flushdb
    - 清空当前库
  - flushall
    - 通杀全部库

# P14 redis 10 大类型之大小写和帮助命令

数据类型命令及落地运用

- 官网命令大全网址
  - 英文
  - 中文
- 备注
  - 命令不区分大小写，而 key 是区分大小写的
  - 永远的帮助命令，help @类型
    - help @string
    - help @list
    - help @hash
    - help @hyperloglog
    - ...
- redis 字符串（String）
- redis 列表（List）
- redis 哈希表（Hash）
- redis 集合（Set）
- redis 有序集合 ZSet（sorted set）
- redis 位图（bitmap）
- redis 基数统计（HypeLogLog）
- redis 地理空间（GEO）
- redis 流（Stream）
- redis 位域（bitfield）

# P15 redis 10 大类型之 string - 上集

redis 字符串（String）

- 常用

  - | 序号 | 命令                           | 描述                                                         |
    | ---- | ------------------------------ | ------------------------------------------------------------ |
    | 1    | SET key value                  | 设置指定 key 的值                                            |
    | 2    | GET key                        | 获取指定 key 的值                                            |
    | 3    | GETRANGE key start end         | 返回 key 中字符串值的字符                                    |
    | 4    | GETSET key value               | 将给定 key 的值设为 value，并返回 key 的旧值（old value）    |
    | 5    | GETBIT key offset              | 对 key 所储存的字符串值，获取指定偏移量上的位（bit）         |
    | 6    | MGET key1 [key2...]            | 获取所有（一个或多个）给定 key 的值                          |
    | 7    | SETBIT key offset value        | 对 key 所储存的字符串值，设置或清除指定偏移量上的位（bit）   |
    | 8    | SETEX key seconds value        | 将值 value 关联到 key，并将 key 的过期时间设为 seconds（以秒为单位） |
    | 9    | SETNX key value                | 只有在 key 不存在时设置 key 的值                             |
    | 10   | SETRANGE key offset value      | 用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始 |
    | 11   | STRLEN key                     | 返回 key 所储存的字符串值的长度                              |
    | 12   | MSET key value [key value ...] | 同时设置一个或多个 key-value 对                              |
    | 13   | MSETNX key milliseconds value  | 同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在 |
    | 14   | PSETEX key milliseconds value  | 这个命令和 SETEX 命令相似，但它以毫秒为单位设置 key 的生存时间，而不是像 SETEX 命令那样，以秒为单位 |
    | 15   | INCR key                       | 将 key 中存储的数字值增一。                                  |
    | 16   | INCRBY key increment           | 将 key 所存储的值加上给定的增量值（increment）。             |
    | 17   | INCRBYFLOAT key increment      | 将 key 所储存的值加上给定的浮点增量值（increment）           |
    | 18   | DECR key                       | 将 key 中储存的数字值减一                                    |
    | 19   | DECRBY key decrement           | key 所储存的值减去给定的减量值（decrement）                  |
    | 20   | APPEND key value               | 如果 key 已经存在并且是一个字符串，APPEND 命令将 value 追加到 key 原来的值的末尾 |

- 单值单 value

- 案例

  - 最常用

    - set key value

      - keepttl

      - `SET` 命令有 `EX`、`PX`、`NX`、`XX` 以及 `KEEPTTL` 五个可选参数，其中 `KEEPTTL`  为 6.0 版本添加的可选参数，其它为 2.6.12 版本添加的可选参数。

        - `EX seconds`：以秒为单位设置过期时间
        - `PX milliseconds`：以毫秒为单位设置过期时间
        - `EXAT timestamp`：设置以秒为单位的 UNIX 时间戳所对应的时间为过期时间
        - `PXAT milliseconds-timestamp`：设置以毫秒为单位的 UNIX 时间戳所对应的时间为过期时间
        - `NX`：键不存在的时候设置键值
        - `XX`：键存在的时候设置键值
        - `KEEPTTL`：保留设置前指定键的生存时间
        - `GET`：返回指定键原本的值，若键不存在时返回 `nil`

      - `SET` 命令使用 `EX`、`PX`、`NX` 参数，其效果等同于 `SETEX`、`PSETEX`、`SETNX` 命令。根据官方文档的描述，未来版本中  `SETEX`、`PSETEX`、`SETNX` 命令可能会被淘汰。

      - `EXAT`、`PXAT` 以及 `GET` 为 Redis 6.2 新增的可选参数。

      - 返回值

        - 设置成功则返回 `OK`；返回 `nil` 为未执行 `SET` 命令，如不满足 `NX`、`XX` 条件等。
        - 若使用 `GET` 参数，则返回该值原来的值，或在键不存在时返回 `nil`

      - **如何获得**设置指定 Key 过期的 Unix 时间，单位为秒

        ```java
        System.out.println(Long.toString(System.currentTimeMillis() / 1000L));
        ```

    - get key

  - 同时设置/获取多个键值

  - 获取指定区间范围内的值

  - 数值增减

  - 获取字符串长度和内容追加

  - 分布式锁

  - getset（先 get 再 set）

  - 应用场景

# P16 redis 10 大类型之 string - 下集

同时设置/获取多个键值

- MSET key value [key value ...]
- MGET key [key ...]
- mset/mget/msetnx

获取指定区间范围内的值

- getrange/setrange

数值增减

- **一定要是数字才能进行加减**
- 递增数字
  - INCR key
- 增加指定的整数
  - INCRBY key increment
- 递减数值
  - DECR key
- 减少指定的整数
  - DECRBY key decrement

获取字符串长度和内容追加

- STRLEN key
- APPEND key value

分布式锁

- setnx key value
- setex (set with expire) 键秒值 / setnx (set if not exist)
- 下半场-高阶篇详细深度讲解，不要错过

getset（先 get 再 set）

- getset：将给定 key 的值设为 value，并返回 key 的旧值（old value）。
- 简单一句话，先 get 然后立即 set

应用场景

- 比如抖音无限点赞某个视频或者商品，点一下加一次
- 是否喜欢的文章

# P17 redis 10 大类型之 list

Redis 列表（List）

- 常用

  - | 序号 | 命令                                  | 描述                                                         |
    | ---- | ------------------------------------- | ------------------------------------------------------------ |
    | 1    | BLPOP key1 [key2 ] timeout            | 移出并获取列表的第一个元素，如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止 |
    | 2    | BRPOP key1 [key2 ] timeout            | 移出并获取列表的最后一个元素，如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止 |
    | 3    | BRPOPLPUSH source destination timeout | 从列表中弹出一个值，将弹出的元素插入到另外一个列表中并返回它；如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止 |
    | 4    | LINDEX key index                      | 通过索引获取列表中的元素                                     |
    | 5    | LINSERT key BEFORE\|AFTER pivot value | 在列表的元素前或者后插入元素                                 |
    | 6    | LLEN key                              | 获取列表长度                                                 |
    | 7    | LPOP key                              | 移除并获取列表的第一个元素                                   |
    | 8    | LPUSH key value1 [value2]             | 将一个或多个值插入到列表头部                                 |
    | 9    | LPUSHX key value                      | 将一个或多个值插入到已存在的列表头部                         |
    | 10   | LRANGE key start stop                 | 获取列表指定范围内的元素                                     |
    | 11   | LREM key count value                  | 移除列表元素                                                 |
    | 12   | LSET key index value                  | 通过索引设置列表元素的值                                     |
    | 13   | LTRIM key start stop                  | 对一个列表进行修剪（trim），就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除 |
    | 14   | RPOP key                              | 移除并获取列表最后一个元素                                   |
    | 15   | RPOPLPUSH source destination          | 移除列表的最后一个元素，并将该元素添加到另一个列表并返回     |
    | 16   | RPUSH key value1 [value2]             | 在列表中添加一个或多个值                                     |
    | 17   | RPUSHX key value                      | 为已存在的列表添加值                                         |

- 单 key 多 value

- 简单说明

  - **一个双端链表的结构**，容量是 2 的 32 次方减 1 个元素，大概 40 多亿，主要功能有 push/pop 等，一般用在栈、队列、消息队列等场景。left、right 都可以插入添加；
  - 如果键不存在，创建新的链表；
  - 如果键已存在，新增内容；
  - 如果值全移除 ，对应的键也就消失了。

- 案例

  - lpush/rpush/lrange
  - lpop/rpop
  - lindex，按照索引下标获得元素（从上到下）
  - llen 获取列表中元素的个数
  - lrem key 数字N 给定值v1 解释（删除N个值等于v1的元素）
  - ltrim key 开始index 结束index，截取指定范围的值后再赋值给 key
  - rpoplpush 源列表 目的列表
  - lset key index value
  - lindex key before/after 已有值 插入的新值
  - 应用场景
    - 微信公众号订阅的消息

# P18 redis 10 大类型之 hash

Redis 哈希表（Hash）

- 常用

  - | 序号 | 命令                                           | 描述                                                  |
    | ---- | ---------------------------------------------- | ----------------------------------------------------- |
    | 1    | HDEL key field1 [field2]                       | 删除一个或多个哈希表字段                              |
    | 2    | HEXISTS key field                              | 查看哈希表 key 中，指定的字段是否存在。               |
    | 3    | HGET key field                                 | 获取存储在哈希表中指定字段的值                        |
    | 4    | HGETALL key                                    | 获取在哈希表中指定 key 的所有字段和值                 |
    | 5    | HINCRBY key field increment                    | 为哈希表 key 中的指定字段的整数值加上增量 increment   |
    | 6    | HINCRBYFLOAT key field increment               | 为哈希表 key 中的指定字段的浮点数值加上增量 increment |
    | 7    | HKEYS key                                      | 获取所有哈希表中的字段                                |
    | 8    | HLEN key                                       | 获取哈希表中字段的数量                                |
    | 9    | HMGET key field1 [field2]                      | 获取所有给定字段的值                                  |
    | 10   | HMSET key field1 value1 [field2 value2]        | 同时将多个 field-value（域-值）对设置 到哈希表 key 中 |
    | 11   | HSET key field value                           | 将哈希表 key 中的字段 field 的值设为 value            |
    | 12   | HSETNX key field value                         | 只有在字段 field 不存在时，设置给希表字段的值         |
    | 13   | HVALS key                                      | 获取哈希表中所有值                                    |
    | 14   | HSCAN key cursor [MATCH pattern] [COUNT count] | 迭代哈希表中的键值对                                  |

- KV 模式不变，但 V 是一个键值对

  - Map<String, Map<Object, Object>>

- 案例

  - hset/hget/hmset/hmget/hgetall/hdel
  - hlen
  - hexists key 在key里面的某个值的key
  - hkeys/hvals
  - hincrby/hincrbyfloat
  - hsetnx
  - 应用场景
    - JD 购物车早期 设计目前不再采用，当前小中厂可用

# P19 redis 10 大类型之 set

Redis 集合（Set）

- 常用

  - | 序号 | 命令                                           | 描述                                                |
    | ---- | ---------------------------------------------- | --------------------------------------------------- |
    | 1    | SADD key member1 [member2]                     | 向集合添加一个或多个成员                            |
    | 2    | SCARD key                                      | 获取集合的成员数                                    |
    | 3    | SDIFF key1 [key2]                              | 返回给定所有集合的差事                              |
    | 4    | SDIFFSTORE destination key1 [key2]             | 返回给定所有集合的差事并存储在 destination 中       |
    | 5    | SINTER key1 [key2]                             | 返回给定所有集合的交集                              |
    | 6    | SINTERSTORE destination key1 [key2]            | 返回给定所有集合的交集并存储在 destination 中       |
    | 7    | SISMEMBER key member                           | 判断 member 元素是否是集合 key 的成员               |
    | 8    | SMEMBERS key                                   | 返回集合中的所有成员                                |
    | 9    | SMOVE source destination member                | 将 member 元素从 source 集合移动到 destination 集合 |
    | 10   | SPOP key                                       | 移除并返回集合中的一个随机元素                      |
    | 11   | SRANDMEMBER key [count]                        | 返回集合中一个或多个随机数                          |
    | 12   | SREM key member1 [member2]                     | 移除集合中的一个或多个成员                          |
    | 13   | SUNION key1 [key2]                             | 返回所有给定集合的并集                              |
    | 14   | SUNIONSTORE destination key1 [key2]            | 所有给定集合的并集存储在 destination 集合中         |
    | 15   | SSCAN key cursor [MATCH pattern] [COUNT count] | 迭代集合中的元素                                    |

- 单值多 value，且无重复

- 案例

  - SADD key member [member ...] 添加元素
  - SMEMBERS key 遍历集合中的所有元素
  - SISMEMBER key member 判断元素是否在集合中
  - SREM key member [member ...] 删除元素
  - SCARD，获取集合里面的元素个数
  - SRANDMEMBER key [数字] 从集合中随机展现设置的数字个数元素，元素不删除
  - SPOP key [数字]，从集合中随机弹出一个元素，出一个删一个
  - SMOVE key1 key2 在key1里已存在的某个值，将 key1 里已存在的某个值赋给 key2
  - 集合运算
    - 集合的差集运算 A - B
      - 属于 A 但不属于 B 的元素构成的集合
      - SDIFF key [key ...]
    - 集合的并集运算 A ∪ B
      - 属于 A 或者属于 B 的元素合并后的集合
      - SUNION key [key ...]
    - 集合的交集运算 A ∩ B
      - 属于 A 同时也属于 B 的共同拥有的元素构成的集合
      - SINTER key [key ...]
      - SINTERCARD numkeys key [key ...] [LIMIT limit]
        - redis 7 新命令
        - 它不返回结果集，而只返回结果的基数。返回由所有给定集合的交集产生的集合的基数。
        - 案例
  - 应用场景
    - 微信抽奖小程序
    - 微信朋友圈点赞查看同赞朋友
    - QQ 内推可能认识的人

# P20 redis 10 大类型之 zset

Redis 有序集合 ZSet（sorted set）

- 多说一句

  - 在 set 基础上，每个 val 值前加一个 score 分数值；
    之前 set 是 k1 v1 v2 v3，
    现在 zset 是 k1 score1 v1 score2 v2

- 常用

  - | 序号 | 命令                                           | 描述                                                         |
    | ---- | ---------------------------------------------- | ------------------------------------------------------------ |
    | 1    | ZADD key score1 member1 [score2 member2]       | 向有序集合添加一个或多个成员，或者更新已存在成员的分数       |
    | 2    | ZCARD key                                      | 获取有序集合的成员数                                         |
    | 3    | ZCOUNT key min max                             | 计算在有序集合中指定区间分数的成员数                         |
    | 4    | ZINCRBY key increment member                   | 有序集合中对指定成员的分数加上增量 increment                 |
    | 5    | ZINTERSTORE destination numkeys key [key ...]  | 计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 key 中 |
    | 6    | ZLEXCOUNT key min max                          | 在有序集合中计算指定字典区间内成员数量                       |
    | 7    | ZRANGE key start stop [WITHSCORES]             | 通过索引区间返回有序集合成指定区间内的成员                   |
    | 8    | ZRANGEBYLEX key min max [LIMIT offset count]   | 通过字典区间返回有序集合的成员                               |
    | 9    | ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT] | 通过分数返回有序集合指定区间内的成员                         |
    | 10   | ZRANK key member                               | 返回有序集合中指定成员的索引                                 |
    | 11   | ZREM key member [member ...]                   | 移除有序集合中的一个或多个成员                               |
    | 12   | ZREMRANGEBYLEX key min max                     | 移除有序集合中给定的字典区间的所有成员                       |
    | 13   | ZREMRANGEBYRANK key start stop                 | 移除有序集合中给定的排名区间的所有成员                       |
    | 14   | ZREMRANGEBYSCORE key min max                   | 移除有序集合中给定的分数区间的所有成员                       |
    | 15   | ZREVRANGE key start stop [WITHSCORES]          | 返回有序集中指定区间内的成员，通过索引，分数从高到低         |
    | 16   | ZREVRANGEBYSCORE key max min [WITHSCORES]      | 返回有序集中指定分数区间内的成员，分数从高到低排序           |
    | 17   | ZREVRANK key member                            | 返回有序集合中指定成员的排名，有序集成员按分数值递减（从大到小）排序 |
    | 18   | ZSCORE key member                              | 返回有序集中，成员的分数值                                   |
    | 19   | ZUNIONSTORE destination numkeys key [key ...]  | 计算给定的一个或多个有序集的并集，并存储在新的 key 中        |
    | 20   | ZSCAN key cursor [MATCH pattern] [COUNT count] | 迭代有序集合中的元素（包括元素成员和元素分值）               |

- 案例

  - 向有序集合中加入一个元素和该元素的分数
  - ZADD key score member [score member ...] 添加元素
  - ZRANGE key start stop [WITHSCORES] 按照元素分数从小到大的顺序，返回索引从 start 到 stop 之间的所有元素
  - ZREVRANGE
  - ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count] 获取指定分数范围的元素
    - withscores
    - （ 不包含
    - limit 的作用是返回限制
  - ZSCORE key member 获取元素的分数
  - ZCARD key 获取集合中元素的数量
  - ZREM key 某score下对应的value值，作用是删除元素
  - ZINCRBY key increment member，增加某个元素的分数
  - ZCOUNT key min max 获得指定分数范围内的元素个数
  - ZMPOP 从键名列表中的第一个非空排序集中弹出一个或多个元素，它们是成员分数对
  - ZRANK key values值，作用是获取下标值
  - ZREVRANK key values值，作用是逆序获得下标值
  - 应用场景
    - 根据商品销售对商品进行排序显示

# P21 redis 10 大类型之 bitmap

Redis 位图（bitmap）

- 一句话

  - 由 0 和 1 状态表现的二进制位的 bit 数组

- 看需求

  - 用户是否登陆过 Y、N，比如京东每日签到送京豆
  - 电影、广告是否被点击播放过
  - 钉钉打卡上下班，签到统计
  - ......

- 是什么

  - Bit arrays (or simply bitmaps，我们可以称之为 位图)

    一个字节（一个 byte）= 8 位

    上图由许许多多的小格子组成，每一个格子里面只能放 1 或者 0，用它来判断 Y/N 状态。说的专业点，每一个个小格子就是一个个 bit

  - 说明：**用 String 类型作为底层数据结构实现的一种统计二值状态的数据类型**

    **位图本质是数组**，它是基于 String 数据类型的按位的操作。该数组由多个二进制位组成，每个二进制位都对应一个偏移量（我们称之为一个索引）。

    Bitmap 支持的最大位数是 2 ^ 32 位，它可以极大的节约存储空间，使用 512M 内存就可以存储多达 42.9 亿的字节信息（2 ^ 32 = 4294967296）

- 能干嘛

  - 用于状态统计
    - Y, N，类似 AtomicBoolean

- 基本命令

  - | 命令                        | 作用                                                  | 时间复杂度 |
    | --------------------------- | ----------------------------------------------------- | ---------- |
    | setbit key offset val       | 给指定 key 的值的第 offset 赋值 val                   | O(1)       |
    | getbit key offset           | 获取指定 key 的第 offset 位                           | O(1)       |
    | bitcount key start end      | 返回指定 key 中 [start, end] 中为 1 的数量            | O(n)       |
    | bitop operation destkey key | 对不同的二进制存储数据进行位运算（AND、OR、NOT、XOR） | O(n)       |

  - setbit

    - setbit key offset value
    - setbit 键 偏移位 只能零或者1
    - **Bitmap 的偏移量是从零开始算的**

  - getbit

  - strlen

    - 统计字节数占用多少

  - bitcount

    - 全部键里面含有 1 的有多少个？

  - bitop

  - setbit 和 getbit 案例说明

    - 按照天

- 应用场景

  - 一年 365 天，全年天天登陆占用多少字节
  - 按照年

# P22 redis 10 大类型之 HyperLogLog

Redis 基数统计（HypeLogLog）

- 看需求

  - 统计某个网站的 UV、统计某个文章的 UV
  - 什么是 UV
  - 用户搜索网站关键词的数量
  - 统计用户每天搜索不同词条个数

- 是什么

  - 去重复统计功能的基数估计算法 - 就是 HyperLogLog
    - Redis 在 2.8.9 版本添加了 HyperLogLog 结构。
    - Redis HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定的、并且是很小的。
    - **在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基数。**这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。
    - 但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。
  - 基数
    - 是一种数据集，去重复后的真实个数
    - 案例 Case
  - 基数统计
    - 用于统计一个集合中不重复的元素个数，就是对集合去重复后剩余元素的计算
  - 一句话
    - 去重脱水后的真实数据

- 基本命令

  - | 序号 | 命令                                      | 描述                                      |
    | ---- | ----------------------------------------- | ----------------------------------------- |
    | 1    | PFADD key element [element ...]           | 添加指定元素到 HyperLogLog 中             |
    | 2    | PFCOUNT key [key ...]                     | 返回给定 HyperLogLog 的基数估算值。       |
    | 3    | PFMERGE destkey sourcekey [sourcekey ...] | 将多个 HyperLogLog 合并为一个 HyperLogLog |

- 应用场景：编码实战案例见高级篇

  - 天猫网站首页亿级 UV 的 Redis 统计方案

# P23 redis 10 大类型之 GEO

Redis 地理空间（GEO）

- 简介

  - 查找距离我们（坐标x0,y0）附近 r 公里范围内部的车辆

    使用如下 SQL 即可：

    ```mysql
    select taxi from position where x0 - r < x < x0 + r and y0 - r < y < y0 + r
    ```

    **但是这样会有什么问题呢？**

    1. 查询性能问题，如果并发高，数据量大这种查询是要搞垮数据库的
    2. 这个查询的是一个矩形访问，而不是以我为中心 r 公里为半径的圆形访问。
    3. 精确度的问题，我们知道地球不是平面坐标系，而是一个圆球，这种矩形计算在长距离计算时会有很大误差

- 原理

  - 核心思想就是将球体转换为平面，区块转换为一点
  - 主要分为三步
    1. 将三维的地区变为二维的坐标
    2. 在将二维的坐标转换为一维的点块
    3. 最后将一维的点块转换为二进制再通过 base32 编码

- Redis 在 3.2 版本以后增加了地理位置的处理

- 命令

  - GEOADD 多个精度（longitude）、纬度（latitude）、位置名称（member）添加到指定的 key 中
  - GEOPOS 从键里面返回所有给定位置元素的位置（经度和纬度）
  - GEODIST 返回两个给定位置之间的距离。
  - GEORADIUS 以给定的经纬度为中心，返回与中心的距离不超过给定最大距离的所有位置元素。
  - GEORADIUSBYMEMBER 跟 GEORADIUS 类似
  - GEOHASH 返回一个或多个位置元素的 Geohash 表示

- 命令实操

  - 如何获取某个地址的经纬度

  - GEOADD 添加经纬度坐标

    - 中文乱码如何处理

      - ```shell
        redis-cli --raw
        ```

  - GEOPOS 返回经纬度

  - GEOHASH 返回坐标的 geohash 表示

    - geohash 算法生成的 base32 编码值
    - 三维变二维变一维

  - GEODIST 两个位置之间距离

  - GEORADIUS

    - 以半径为中心，查找附近的 xxx

  - GEORADIUSBYMEMBER

    - 找出位于指定范围内的元素，中心点是由给定的位置元素决定

- 应用场景-编码实战案例见高级篇

  - 美团地图位置附近的酒店推送
  - 高德地图附近的核酸检查点

# P24 redis 10 大类型之 Stream - 上集

Redis 流（Stream）

- 是什么

  - redis 5.0 之前痛点

    - Redis 消息队列的 2 种方案

      - List 实现消息队列

        - List 实现方式其实就是点对点的模式

        - 按照插入顺序排序，你可以添加一个元素到列表的头部（左边）或者尾部（右边）。

          所以**常用来做异步队列使用**，将需要延后处理的任务结构体序列化成字符串塞进 Redis 的列表，另一个线程从这个列表中轮询数据进行处理。

      - (Pub/Sub)

        - Redis 发布订阅（pub/sub）有个缺点就是消息无法持久化，如果出现网络断开、Redis 宕机等，消息就会被丢弃。而且也没有 Ack 机制来保证数据的可靠性，假设一个消费者都没有，那消息就直接被丢弃了。

  - Redis 5.0 版本新增了一个更强大的数据结构——Stream

  - 一句话

    - Redis 版的 MQ 消息中间件 + 阻塞队列

- 能干嘛

  - 实现消息队列，它支持消息的持久化、支持自动生成全局唯一 ID、支持 ack 确认消息的模式、支持消费组模式等，让消息队列更加的稳定和可靠

- 底层结构和原理说明

  - stream 结构

    - 一个消息链表，将所有加入的消息都串起来，每个消息都有一个唯一的 ID 和对应的内容

      | 序号 | 名字              | 描述                                                         |
      | ---- | ----------------- | ------------------------------------------------------------ |
      | 1    | Message Content   | 消息内容                                                     |
      | 2    | Consumer group    | 消费组，通过 XGROUP CREATE 命令创建，同一个消费组可以有多个消费者 |
      | 3    | Last_delivered_id | 游标，每个消费组会有个游标 last_delivered_id，任意一个消费者读取了消息都会使游标 last_delivered_id 往前移动。 |
      | 4    | Consumer          | 消费者，消费组中的消费者                                     |
      | 5    | Pending_ids       | 消费者会有一个状态变量，用于记录被当前消费已读取但未 ack 的消息 Id，如果客户端没有 ack，这个变量里面的消息 ID 会越来越多，一旦某个消息被 ack 它就开始减少。这个 pending_ids 变量在 Redis 官方被称之为 PEL（Pending Entries List），记录了当前已经被客户端读取的消息，但是还没有 ack（Acknowledge character：确认字符），它用来确保客户端至少消费了消息一次，而不会在网络传输的中途丢失了没处理 |

- 基本命令理论简介

  - 队列相关指令

    - | 指令名称  | 指令作用                                        |
      | --------- | ----------------------------------------------- |
      | XADD      | 添加消息到队列末尾                              |
      | XTRIM     | 限制 Stream 的长度，如果已经超长会进行截取      |
      | XDEL      | 删除消息                                        |
      | XLEN      | 获取 Stream 中的消息长度                        |
      | XRANGE    | 获取消息列表（可以指定范围），忽略删除的消息    |
      | XREVRANGE | 和 XRANGE 相比区别在于反向获取，ID 从大到小     |
      | XREAD     | 获取消息（阻塞/非阻塞），返回大于指定 ID 的消息 |

  - 消费组相关指令

    - | 指令名称           | 指令作用                                                     |
      | ------------------ | ------------------------------------------------------------ |
      | XGROUP CREATE      | 创建消费者组                                                 |
      | XREADGROUP GROUP   | 读取消费者中的消息                                           |
      | XACK               | ack 消息，消息被标记为“已处理”                               |
      | XGROUP SETID       | 设置消费者组最后递送消息的 ID                                |
      | XGROUP DELCONSUMER | 删除消费者组                                                 |
      | XPENDING           | 打印待处理消息的详细信息                                     |
      | XCLAIM             | 转移消息的归属权（长期未被处理/无法处理的消息，转交给其他消费者组进行处理） |
      | XINFO              | 打印 Stream\Consumer\Group 的详细信息                        |
      | XINFO GROUPS       | 打印消费者组的详细信息                                       |
      | XINFO STREAM       | 打印 Stream 的详细信息                                       |

  - 四个特殊符号

    - `- +`
      - 最小和最大可能出现的 id
    - `$`
      - $ 表示只消费新的消息，当前流中最大的 id，可用于将要到来的信息
    - `>`
      - 用于 XREADGROUP 命令，表示迄今还没有发送给组中使用者的信息，会更新消费者组的最后 ID
    - `*`
      - 用于 XADD 命令，让系统自动生成 id

- 基本命令代码实操

- 使用建议

# P25 redis 10 大类型之 Stream - 中集

基本命令代码实操

- Redis 流实例演示

  - 队列相关指令

    - XADD

      - 添加消息到队列末尾

        - 消息 ID 必须要比上个 ID 大

        - 默认用星号表示自动生成规矩

        - *

          - 用于 XADD 命令中，让系统自动生成 id

        - XADD 用于向 Stream 队列中添加消息，如果指定的 Stream 队列不存在，则该命令执行时会新建一个 Stream 队列

          // * 号表示服务器自动生成 MessageID（类似 mysql 里面主键 auto_increment），后面顺序跟着一堆业务 key/value

          生成的消息 ID，由两部分组成：毫秒级时间戳-该毫秒内产生的第n条消息

          信息条目指的是序列号，在相同的毫秒下序列化从 0 开始递增，序列号是 64 位长度，理论上在同一毫秒内生成的数据量无法达到这个级别，因此不用担心序列号会不够用。millisecondsTime 指的是 Redis 节点服务器的本地时间，如果存在当前的毫秒时间戳比以前已经存在的数据的时间戳小的话（本地时间钟后跳），那么系统将会采用以前相同的毫秒创建新的 ID，也即 redis 在增加信息条目时会检查当前 id 与上一条目的 id，自动纠正错误的情况，一定要保证后面的 id 比前面大，一个流中信息条目的 ID 必须是单调增的，这是流的基础。

          客户端显示传入规则：

          Redis 对于 ID 有强制要求，格式必须是**时间戳-自增Id** 这样的方式，且后续 ID 不能小于前一个 ID

          Stream 的消息内容，也就是图中的 Message Content 它的结构类似 Hash 结构。以 key-value 的形式存在

    - XRANGE

      - 用于获取消息列表（可以指定范围），忽略删除的消息
      - start 表示开始值，- 代表最小值
      - end 表示结束值，+ 代表最大值
      - count 表示最多获取多少个值

    - XREVRANGE

    - XDEL

    - XLEN

      - 用于获取 Stream 队列的消息的长度

    - XTRIM

      - 用于对 Stream 的长度进行截取，如超长会进行截取
      - MAXLEN
        - 允许的最大长度，对流进行修剪限制长度
      - MINID
        - 允许的最小 id，从某个 id 值开始比该 id 值小的将会被抛弃

    - XREAD

      - 用于获取消息（阻塞/非阻塞），只会返回大于指定 ID 的消息

        - ```shell
          XREAD [COUNT count] [BLOCK milliseconds] STREAMS key [key ...] ID [ID ...]
          ```

          COUNT 最多读取多少条消息

          BLOCK 是否以阻塞的方式读取消息，默认不阻塞，如果 milliseconds 设置为 0，表示永远阻塞

      - 非阻塞

        - $ 代表特殊 ID，表示以当前 Stream 已经存储的最大的 ID 作为最后一个 ID，当前 Stream 中不存在大于当前最大 ID 的消息，因此此时返回 nil
        - 0-0 代表从最小的 ID 开始读取 Stream 中的消息，当不指定 count，将会返回 Stream 中的所有消息，注意也可以使用 0（00/000 也都是可以的……）

      - 阻塞

        - 请 redis-cli 启动第二个客户端连接上来

      - 小总结（类似 Java 里面的阻塞队列）

        - Stream 的基础方法，使用 XADD 存入消息和 XREAD 循环阻塞读取消息的方式可以实现简易版的消息队列，交互流程如下

  - 消费组相关指令

  - XINFO 用于打印 Stream\Consumer\Group 的详细信息

# P26 redis 10 大类型之 Stream - 下集

消费组相关指令

- XGROUP CREATE
  - 用于创建消费者组
    - $ 表示从 Stream 尾部开始消费
    - O 表示从 Stream 头部开始消费
    - 创建消费者组的时候必须指定 ID，ID 为 O 表示从头开始消费，为 $ 表示只消费新的消息，**队尾新来**
- XREADGROUP GROUP
  - “>”，表示从第一条尚未被消费的消息开始读取
  - 消费组 groupA 内的消费者 consumer1 从 mystream 消息队列中读取所有消息
    - stream 中的消息一旦被消费者组里的一个消费者读取了，就不能再被该消费组内的其他消费者读取了，即同一个消费组里的消费者不能消费同一条消息。刚才的 XREADGROUP 命令再执行一次，此时读到的就是空值
  - 但是，**不同消费组**的消费者可以消费同一条消息
  - **消费组的目的？？**
    - 让组内的多个消费者共同分担读取消息，所以，我们通常会让每个消费者读取部分消息，从而实现消息读取负载在多个消费者间是均衡分布的
- 重点问题
  1. 问题：基于 Stream 实现的消息队列，如何保证消费者在发生故障或宕机再次重启后，仍然可以读取未处理完的消息？
  2. Streams 会自动使用内部队列（也称为 PENDING List）留存消费组里每个消费者读取的消息保底措施，直到消费者使用 XACK 命令通知 Streams “消息已经处理完成”。
  3. 消费确认增加了消息的可靠性，一般在业务处理完成之后，需要执行 XACK 命令确认消息已经被消费完成
- XPENDING
  - 查询每个消费组内所以消费者 **已读取、但尚未确认** 的消息
  - 查看某个消费者具体读取了哪些数据
- XACK
  - 向消息队列确认消息处理已完成

XINFO 用于打印 Stream\Consumer\Group 的详细信息



使用建议

- Stream 还是不能 100% 等价于 Kafka、RabbitMQ 来使用的，生产案例少，慎用
- 仅仅代表本人愚见，不权威

# P27 redis 10 大类型之 bitfield

Redis 位域（bitfield）

- 了解即可
- 是什么
  - 官网
    - BITFIELD 命令可以将一个 Redis 字符串看作是一个由二进制位组成的数组，并对这个数组中任意偏移进行访问。可以使用该命令对一个有符号的 5 位整型数的第 1234 位设置指定值，也可以对一个 31 位无符号整型数的第 4567 位进行取值。类似地，本命令可以对指定的整数进行自增和自减操作，可配置的上溢和下溢处理操作。
    - `BITFIELD` 命令可以在一次调用中同时对多个位范围进行操作：它接受一系列待执行的操作作为参数，并返回一个数组，数组中的每个元素就是对应操作的执行结果。
- 能干嘛
  - 位域修改
  - 溢出控制
  - 用途：BITFIELD 命令的作用在于它能够将很多小的整数储存到 一个长度较大的位图中，又或者将一个非常庞大的键分割为多个较小的键来进行储存，从而非常高效地使用内存，使得 Redis 能够得到更多不同的应用——特别是在实时分析领域：BITFIELD 能够以指定的方式对计算溢出进行控制的能力，使得它可以被应用于这一领域。
- 一句话
  - 将一个 Redis 字符串看作是**一个由二进制位组成的数组**，并能对变长位宽和任意没有字节对齐的指定整型位域进行寻址和修改
- 命令基础语法
- 案例
  - Ascii 码表
  - 基本命令代码实操
    - BITFIELD key [GET type offset]
      - 返回指定的位域
    - BITFIELD key [SET type offset value]
      - 设定指定位域的值并返回它的原值
    - BITFIELD key [INCRBY type offset increment]
    - 溢出控制 OVERFLOW [WRAP|SAT|FAIL]
      - WRAP：使用回绕（wrap around）方法处理有符号整数和无符号整数的溢出情况
      - SAT：使用饱和计算（saturation arithmetic）方法处理溢出，下溢计算的结果为最小的整数值，而上溢计算的结果为最大的整数值
      - FAIL：命令将拒绝执行那些会导致上溢或者下溢情况出现的计算，并向用户返回空值表示计算未被执行

# P28 redis 持久化之理论介绍

5、Redis 持久化

- 总体介绍
  - 官网地址
  - 为什么需要持久化
- 持久化双雄
  - 一图
  - RDB（Redis DataBase）
  - AOF（Append Only File）
- RDB-AOF 混合持久化
- 纯缓存模式

# P29 redis 持久化之 RDB 简介

RDB（Redis DataBase）

- 官网介绍

  - RDB（Redis 数据库）：RDB 持久化以指定的时间间隔执行数据集的时间点快照。

- 是什么

  - 在指定的时间间隔，执行数据集的时间点快照

    - 实现类似照片记录效果的方式，就是把某一时刻的数据和状态以文件的形式写到磁盘上，也就是快照。这样一来即使故障宕机，快照文件也不会丢失，数据的可靠性也就得到了保证。

      这个快照文件就称为 RDB 文件（dump.rdb），其中 RDB 就是 Redis DataBase 的缩写。

- 能干嘛

  - 在指定的时间间隔内将内存中的数据集快照写入磁盘，也就是行话讲的 Snapshot 内存快照，它恢复时再将硬盘快照文件直接读回到内存里
  - 一锅端
    - Redis 的数据都在内存中，保存备份时它执行的是**全量快照**，也就是说，把内存中的所有数据都记录到磁盘中，一锅端
  - Rdb 保存的是 dump.rdb 文件

- 案例演示

  - 需求说明

  - **配置文件（6 vs 7）**

    - Redis 6.0.16 以下

      - 自动触发：

        在 Redis.conf 配置文件中的 SNAPSHOTTING 下配置 save 参数，来触发 Redis 的 RDB 持久化条件，比如 “save m n”：表示 m 秒内数据集存在 n 次修改时，自动触发 bgsave

        save 900 1：每隔 900s（15min），如果有超过 1 个 key 发生了变化，就写一份新的 RDB 文件

        save 300 10：每隔 300s（5min），如果有超过 10 个 key 发生了变化，就写一份新的 RDB 文件

        save 60 10000：每隔 60s（1min），如果有超过 10000 个 key 发生了变化，就写一份新的 RDB 文件

    - Redis 6.2 以及 Redis-7.0.0

      - save 3600 1 300 100 60 10000

  - 操作步骤

- 优势

- 劣势

- 如何检查修复 dump.rdb 文件

- 哪些情况会触发 RDB 快照

- 如何禁用快照

- RDB 优化配置项详解

- 小总结

# P30 redis 持久化之 RDB 配置说明

操作步骤

- 自动触发
  - Redis 7 版本，按照 redis.conf 里配置的 `save <seconds> <changes>`
  - 本次案例 5 秒 2 次修改
    - `save 5 2`
  - 修改 dump 文件保存路径
    - 默认：`dir ./`
    - 自定义修改的路径且可以进入 redis 里用 **CONFIG GET dir** 获取目录
  - 修改 dump 文件名称
  - 触发备份
  - 如何恢复
- 手动触发

# P31 redis 持久化之 RDB 自动触发

触发备份

- 第1种情况
- 第2种情况
  - 时间间隔大于等于5秒，修改次数大于等于2次，自动触发

如何恢复

- 将备份文件（dump.rdb）移动到 redis 安装目录并启动服务即可
- 备份成功后故意用 flushdb 清空 redis，看看是否可以恢复数据
  - 结论
    - 执行 flushall/flushdb 命令也会产生 dump.rdb 文件，但里面是空的，无意义
- 物理恢复，一定服务和备份**分机隔离**
  - 备注：不可以把备份文件 dump.rdb 和生产 redis 服务器放在同一台机器，必须**分开各自存储**，以防生产机物理损坏后备份文件也挂了。

# P32 redis 持久化之 RDB 手动触发

手动触发

- save 和 bgsave
  - **Redis 提供了两个命令来生成 RDB 文件，分别是 save 和 bgsave**
  - Save
    - 在主程序中执行**会阻塞**当前 redis 服务器，直到持久化工作完成执行 save 命令期间，Redis 不能处理其他命令，**线上禁止使用**
    - 案例
  - BGSAVE（默认）
    - Redis 会在后台异步进行快照操作，**不阻塞**快照同时还可以响应客户端请求，该触发方式会 fork 一个子进程由子进程复制持久化过程
    - 官网说明
    - Redis 会使用 bgsave 对当前内存中的所有数据做快照，这个操作是子进程在后台完成的，这就允许主进程同时可以修改数据。
    - fork 是什么？
      - 各位熟悉的
        - Git fork
      - 操作系统角度
        - 在 Linux 程序中，fork() 会产生一个和父进程完全相同的子进程，但子进程在此后多会 exec 系统调用，处于效率考虑，尽量避免膨胀
    - 案例
    - LASTSAVE
      - 可以通过 lastsave 命令获取最后一次成功快照的时间
      - 案例

# P33 redis 持久化之 RDB 优缺点及数据丢失案例

优势

- 官网说明
  - RDB 是 Redis 数据的一个非常紧凑的单文件时间点表示。RDB 文件非常适合备份。例如，您可能希望在最近的 24 小时内每小时归档一次 RDB 文件，并在 30 天内每天保存一个 RDB 快照。这使您可以在发生灾难时轻松恢复不同版本的数据集。
  - RDB 非常适合灾难恢复，它是一个可以传输到远程数据中心或 Amazon S3（可能已加密）的压缩文件
  - RDB  最大限度地提高了 Redis 的性能，因为 Redis 父进程为了持久化而需要做的唯一工作就是派生一个将完成所有其余工作的子进程。父进程永远不会执行磁盘 I/O 或类似操作。
  - 与 AOF 相比，RDB 允许使用大数据集更快地重启。
  - 在副本上，RDB 支持**重启和故障转移后的部分重新同步**。
- 小总结
  - 适合大规模的数据恢复
  - 按照业务定时备份
  - 对数据完整性和一致性要求不高
  - RDB 文件在内存中的加载速度要比 AOF 快得多

劣势

- 官网说明
  - 如果您需要在 Redis 停止工作时（例如断电后）将数据丢失的可能性降到最低，那么 RDB 并不好。您可以配置生成 RDB 的不同保存点（例如，在对数据集至少 5 分钟和 100 次写入之后，您可以有多个保存点）。但是，您通常会每五分钟或更长时间创建一次 RDB 快照，因此，如果 Redis 由于任何原因在没有正确关闭的情况下停止工作，您应该准备好丢失最新分钟的数据。
  - RDB 需要经常 fork() 以便使用子进程在磁盘上持久化。如果数据集很大，fork() 可能会很耗时，并且如果数据集很大并且 CPU 性能不是很好，可能会导致 Redis 停止为客户端服务几毫秒甚至一秒钟。AOF 也需要 fork() 但频率较低，您可以调整要重写日志的频率，而不需要对持久性进行任何权衡。
- 小总结
  - 在一定间隔时间做一次备份，所以如果 redis 意外 down 掉的话，就会丢失从当前至最近一次快照期间的数据，**快照之间的数据会丢失**
  - 内存数据的全量同步，如果数据量太大会导致 I/O 严重影响服务器性能
  - RDB 依赖于主进程的 fork，在更大的数据集中，这可能会导致服务请求的瞬间延迟。fork 的时候内存中的数据被克隆了一份，大致 2 倍的膨胀性，需要考虑
- 数据丢失案例
  - 正常录入数据
  - kill -9 故意模拟意外 down 机
  - redis 重启恢复，查看数据是否丢失

# P34 redis 持久化之 RDB 修复命令

如何检查修复 dump.rdb 文件

- `redis-check-rdb /myredis/dumpfiles/dump6379.rdb`

# P35 redis 持久化之 RDB 触发小结和快照禁用

哪些情况会触发 RDB 快照

- 配置文件中默认的快照配置
- 手动 save/bgsave 命令
- 执行 flushall/flushdb 命令也会产生 dump.rdb 文件，但里面是空的，无意义
- 执行 shutdown 且没有设置开启 AOF 持久化
- 主从复制时，主节点自动触发

如何禁用快照

- 动态所有停止 RDB 保存规则的方法：redis-cli config set save ""
- 快照禁用
  - `save ""`

# P36 redis 持久化之 RDB 优化参数

RDB 优化配置项详解

- 配置文件 SNAPSHOTTING 模块
  - `save <seconds> <changes>`
  - dbfilename
  - dir
  - stop-writes-on-bgsave-error
    - 默认 yes
    - 如果配置成 no，表示你不在乎数据不一致或者有其他的手段发现和控制这种不一致，那么在快照写入失败时，也能确保 redis 继续接受新的写请求
  - rdbcompression
    - 默认 yes
    - 对于存储到磁盘中的快照，可以设置是否进行压缩存储。如果是的话，redis 会采用 LZF 算法进行压缩。如果你不想消耗 CPU 来进行压缩的话，可以设置为关闭此功能
  - rdbchecksum
    - 默认 yes
    - 在存储快照后，还可以让 redis 使用 CRC 64 算法来进行数据校验，但是这样做会增加大约 10% 的性能消耗，如果希望获取到最大的性能提升，可以关闭此功能
  - rdb-del-sync-files
    - rdb-del-sync-files：在没有持久性的情况下删除复制中使用的 RDB 文件启用。默认情况下 no，此选项是禁用的。

小总结

- RDB 是一个非常紧凑的文件
- RDB 在保存 RDB 文件时父进程唯一需要做的就是 fork 出一个子进程，接下来的工作全部由子进程来做，父进程不需要再做其他 IO 操作，所以 RDB 持久化方式可以最大化 redis 的性能。
- 与 AOF 相比，在恢复大的数据集的时候，RDB 方式会更快一些。
- 数据丢失风险大
- RDB 需要经常 fork 子进程来保存数据集到硬盘上，当数据集比较大的时候，fork 的过程是非常耗时的，可能会导致 Redis 在一些毫秒级不能相应客户端请求

# P37 redis 持久化之 AOF 简介

AOF（Append Only File）

- 官网介绍

- 是什么

  - **以日志的形式来记录每个写操作，**将 Redis 执行过的所有写指令记录下来（读操作不记录），只许追加文件但不可以改写文件，redis 启动之初会读取该文件重新构建数据，换言之，redis 重启的话就根据日志文件的内容将写指令从前到后执行一次以完成数据的恢复工作

  - 默认情况下，redis 是没有开启 AOF（append only file）的。

    开启 AOF 功能需要设置配置：appendonly yes

- 能干嘛

- AOF 保存的是 appendonly.aof 文件

- AOF 持久化工作流程

- AOF 缓存区三种写回策略

- 案例演示和说明

  AOF 配置/启动/修复/恢复

- 优势

- 劣势

- AOF 重写机制

- AOF 优化配置项详解

- 小总结

# P38 redis 持久化之 AOF 工作流程和写回策略

AOF 持久化工作流程

1. Client 作为命令的来源，会有多个源头以及源源不断的请求命名。
2. 在这些命令到达 Redis Server 以后并不是直接写入 AOF 文件，会将其这些命令先放入 AOF 缓存中进行保存。这里的 AOF 缓冲区实际上是内存中的一片区域，存在的目的是当这些命令达到一定量以后再写入磁盘，避免频繁的磁盘 IO 操作。
3. AOF 缓冲会根据 AOF 缓冲区**同步文件的三种写回策略**将命令写入磁盘上的 AOF 文件。
4. 随着写入 AOF 内容的增加为避免文件膨胀，会根据规则进行命令的合并（又称**AOF 重写**），从而起到 AOF 文件压缩的目的。
5. 当 Redis Server 服务器重启的时候会从 AOF 文件载入数据。

AOF 缓存区三种写回策略

- 三种写回策略

  - 默认是 everysec
  - Always
    - 同步写回，每个写命令执行完立刻同步地将日志写回磁盘
  - everysec
    - 每秒写回，每个写命令执行完，只是先把日志写到 AOF 文件的内存缓冲区，每隔 1 秒把缓冲区中的内容写入磁盘
  - no
    - 操作系统控制的写回，每个写命令执行完，只是先把日志写到 AOF 文件的内存缓存区，由操作系统决定何时将缓冲区内容写回磁盘

- 三种写回策略小总结 update

  - | 配置项   | 写回时机           | 优点                     | 缺点                             |
    | -------- | ------------------ | ------------------------ | -------------------------------- |
    | Always   | 同步写回           | 可靠性高，数据基本不丢失 | 每个写命令都要落盘，性能影响较大 |
    | Everysec | 每秒写回           | 性能适中                 | 宕机时丢失 1 秒内的数据          |
    | No       | 操作系统控制的写回 | 性能好                   | 宕机时丢失数据较多               |

    

# P39 redis 持久化之 AOF 功能配置开启

案例演示和说明

AOF 配置/启动/修复/恢复

- 配置文件说明（6 vs 7）

  - 如何开启 aof

    - appendonly yes

  - 使用默认写回策略，每秒钟

    - appendsync everysec

  - aof 文件-保存路径

    - redis 6
      - AOF 保存文件的位置和 RDB 保存文件的位置一样，都是通过 redis.conf  配置文件的 dir 配置
      - 官网文档
    - redis 7 之后最新
      - appenddirname "appendonlydir"
      - 最终路径
        - dir + appenddirname

  - aof 文件-保存名称

    - redis6

      - appendfilename "appendonly.aof"
      - 有且仅有一个

    - Redis 7.0 Multi Part AOF 的设计

      - 官网说明

      - 从 1 到 3

        - base 基本文件

        - incr 增量文件

        - manifest 清单文件

        - MP-AOF 实现

          方案概述

          顾名思义，MP-AOF 就是将原来的单个 AOF 文件拆分成多个 AOF 文件。在 MP-AOF 中，我们将 AOF 分为三种类型，分别为：

          - BASE：表示基础 AOF，它一般由子进程通过重写产生，该文件最多只有一个
          - INCR：表示增量 AOF，它一般会在 AOFRW 开始执行时被创建，该文件可能存在多个
          - HISTORY：表示历史 AOF，它由 BASE 和 INCR AOF 变化而来，每次 AOFRW 成功完成时，本次 AOFRW 之前对应的 BASE 和 INCR AOF 都将变为 HISTORY，HISTORY 类型的 AOF 会被 Redis 自动删除。

          为了管理这些 AOF 文件，我们引入了一个 manifest（清单）文件来跟踪、管理这些 AOF。同时，为了便于 AOF 备份和拷贝，我们将所有的 AOF 文件和 manifest 文件放入一个单独的文件目录中，目录名由 appenddirname 配置（Redis 7.0 新增配置项）决定。

      - Redis 7.0 config 中对应的配置项

        - ```
          // 几种类型文件的前缀，后缀有关序列和类型的附加信息
          appendfilename "appendonly.aof"
          // 新版本增加的目录配置项目
          appenddirname "appendonlydir"
          
          // 如有下的 aof 文件存在
          1. 基本文件
          	appendonly.aof.1.base.rdb
          2. 增量文件
          	appendonly.aof.1.incr.aof
          	appendonly.aof.2.incr.aof
          3. 清单文件
          	appendonly.aof.manifest
          ```

- 正常恢复

- 异常恢复

# P40 redis 持久化之 AOF 正常恢复演示

正常恢复

- 启动：设置 Yes
  - 修改默认的 appendonly no, 改为 yes
  - 写操作继续，生成 aof 文件到指定的目录
  - 恢复 1：重启 redis 然后重新加载，结果 OK
  - 恢复 2
    - 写入数据进 redis，然后 flushdb + shutdown 服务器
    - 新生成了 dump 和 aof
    - 备份新生成的 aof.bak，然后删除 dump/aof 再看恢复
    - 重启 redis 然后重新加载试试？？？
    - 停止服务器，拿出我们的备份修改后再重新启动服务器看看

# P41 redis 持久化之 AOF 异常恢复演示

异常恢复

- 故意乱写正常的 AOF 文件，模拟网络闪断文件写 error
- 重启 Redis 之后就会进行 AOF 文件的载入，发现启动都不行
- 异常修复命令：redis-check-aof --fix 进行修复
- 重新OK

# P42 redis 持久化之 AOF 优缺点案例总结

优势

- 更好的保护数据不丢失、性能高、可做紧急恢复
- AOF 优势
  - 使用 AOF Redis 更加持久：您可以有不同的 fsync 策略：根本不 fsync、每秒 fsync、每次查询时 fsync。使用每秒 fsync 的默认策略，写入性能仍然很棒。fsync 是使用后台线程执行的，当没有 fsync 正在进行时，主线程将努力执行写入，因此您只能丢失一秒钟的写入。
  - AOF 日志是一个仅附加日志，因此不会出现寻道问题，也不会在断电时出现损坏问题。即使由于某种原因（磁盘已满或其他原因）日志以写一半的命令结尾，redis-check-aof 工具也能够轻松修复它。
  - 当 AOF 变得太大时，Redis 能够在后台自动重写 AOF。重写是完全安全的，因为当 Redis 继续附加到旧文件时，会使用创建当前数据集所需的最少操作集生成一个全新的文件，一旦第二个文件准备就绪，Redis 就会切换两者并开始附加到新的那一个。
  - AOF 以易于理解和解析的格式依次包含所有操作的日志。您甚至可以轻松导出 AOF 文件。例如，即使您不小心使用该 FLUSHALL 命令刷新了所有内容，只要在此期间没有执行日志重写，您仍然可以通过停止服务器、删除最新命令并重复启动 Redis 来保存您的数据集。

劣势

- 相同数据集的数据而言 aof 文件要远大于 rdb 文件，恢复速度慢于 rdb
- aof 运行效率要慢于 rdb，每秒同步策略效率较好，不同步效率和 rdb 相同
- AOF 缺点
  - AOF 文件通常比相同数据集的等效 RDB 文件大。
  - 根据确切的 fsync 策略，AOF 可能比 RDB 慢。一般来说，将 fsync 设置为每秒性能仍然非常高，并且在禁用 fsync 的情况下，即使在高负载下它也应该与 RDB 一样快。即使在巨大的写入负载的情况下，RDB 仍然能够提供关于最大延迟的更多保证。

# P43 redis 持久化之 AOF 重写机制案例

AOF 重写机制

- 是什么

  - 由于 AOF 持久化是 Redis 不断将写命令记录到 AOF 文件中，随着 Redis 不断的进行，AOF 的文件会越来越大，文件越大，占用服务器内存越大以及 AOF 恢复要求时间越长。

    为了解决这个问题，**Redis 新增了重写机制**，当 AOF 文件的大小超过所设定的峰值时，Redis 就会**自动**启动 AOF 文件的内容压缩，只保留可以恢复数据的最小指令集

    或者

    可以**手动使用命令 bgrewriteaof 来重写**。

  - 官网

  - 一句话

    - 启动 AOF 文件的内容压缩，只保留可以恢复数据的最小指令集

- 触发机制

  - 官网默认配置

    - auto-aof-rewrite-percentage 100

      auto-aof-rewrite-min-size 64mb

      注意，**同时满足，且的关系**才会触发

      1. 根据上次重写后的 aof 大小，判断当前 aof 大小是不是增长了 1 倍
      2. 重写时满足的文件大小

  - 自动触发

    - 满足配置文件中的选项后，Redis 会记录上次重写时的 AOF 大小，默认配置是当 AOF 文件大小是上次 rewrite 后大小的一倍且文件大于 64M 时

  - 手动触发

    - 客户端向服务器发送 bgrewriteaof 命令

- 案例说明

  - 需求说明

    - **启动 AOF 文件的内容压缩，只保留可以恢复数据的最小指令集。**

      **举个例子：**比如有个 key

      一开始你 set k1 v1

      然后改成 set k1 v2

      最后改成 set k1 v3

      如果不重写，那么这 3 条语句都在 aof 文件中，内容占空间不说启动的时候都要执行一遍，共计 3 条命令；

      但是，我们实际效果只需要 set k1 v3 这一条，所以，

      开启重写后，只需要保存 set k1 v3 就可以了只需要保留最后一次修改值，相当于给 aof 文件瘦身减肥，性能更好

      AOF 重写不仅降低了文件的占用空间，同时更小的 AOF 也可以更快地被 Redis 加载。

  - 需求验证

    - 启动 AOF 文件的内容压缩，只保留可以恢复数据的最小指令集

  - 步骤

    - 前期配置准备
      - 开启 aof
      - 重写峰值修改为 1k
        - auto-aof-rewrite-min-size 1k
      - 关闭混合，设置为 no
        - aof-use-rdb-preamble no
      - 删除之前的全部 aof 和 rdb，清除干扰项
    - 自动触发案例 01
      - 完成上述正确配置，重启 redis 服务器，执行 set k1 v1 查看 aof 文件是否正常
      - 查看三大配置文件
        - 复习配置项
        - 本次操作
      - k1 不停 1111111 暴涨
        - 对同一个 k1，不停重复值 11111111111
        - 文件慢慢变大，到峰值后启动重写机制
      - 重写触发
    - 手动触发案例 02
      - 客户端向服务器发送 bgrewriteaof 命令
    - 结论
      - **也就是说 AOF 文件重写并不是对原文件进行重新整理，而是直接读取服务器现有的键值对，然后用一条命令去代替之前记录这个键值对的多条命令，生成一个新的文件后去替换原来的 AOF 文件**。
      - AOF 文件重写触发机制：通过 redis.conf 配置文件中的 auto-aof-rewrite-percentage：默认值 100，以及 auto-aof-rewrite-min-size：64mb 配置，也就是说默认 Redis 会记录上次重写时 AOF 大小，**默认配置是当 AOF 文件大小是上次 rewrite 后大小的一倍且文件大于 64M 时触发**。

- 重写原理

  1. 在重写开始前，Redis 会创建一个”重写子进程“，这个子进程会读取现有的 AOF 文件，并将其包含的指令进行分析压缩并写入到一个临时文件中。
  2. 与此同时，主进程会将新接收到的写指令一边累积到内存缓冲区中，一边继续写入到原有的 AOF 文件中，这样做是保证原有的 AOF 文件的可用性，避免在重写过程中出现意外。
  3. 当”重写子进程“完成重写工作后，它会给父进程发一个信号，父进程收到信号后就会将内存中缓存的写指令追加到新 AOF 文件中
  4. 当追加结束后，redis 就会用新 AOF 文件来代替旧 AOF 文件，之后再有新的写指令，就都会追加到新的 AOF 文件中
  5. 重写 aof 文件的操作，并没有读取旧的 aof 文件，而是将整个内存中的数据库内容用命令的方式重写了一个新的 aof 文件，这点和快照有点类似

# P44 redis 持久化之 AOF 小总结

AOF 优化配置项详解

- 配置文件 APPEND ONLY MODE 模块

  - | 配置指令                                                   | 配置含义                   | 配置示例                                                     |
    | ---------------------------------------------------------- | -------------------------- | ------------------------------------------------------------ |
    | appendonly                                                 | 是否开启 aof               | appendonly yes                                               |
    | appendfilename                                             | 文件名称                   | appendfilename "appendonly.aof"                              |
    | appendfsync                                                | 同步方式                   | everysec/always/no                                           |
    | no-appendfsync-on-rewrite                                  | aof 重写期间是否同步       | no-appendfsync-on-rewrite no                                 |
    | auto-aof-rewrite-percentage<br />auto-aof-rewrite-min-size | 重写触发配置、文件重写策略 | auto-aof-rewrite-percentage 100<br />auto-aof-rewrite-min-size 64mb |

小总结

- AOF 文件时一个只进行追加的日志文件
- Redis 可以在 AOF 文件体积变得过大时，自动地在后台对 AOF 进行重写
- AOF 文件有序地保存了对数据库执行的所有写入操作，这些写入操作以 Redis 协议的格式保存，因此 AOF 文件的内容非常容易被人读懂，对文件进行分析也很轻松
- 对于相同的数据集来说，AOF 文件的体积通常要大于 RDB 文件的体积
- 根据所使用的 fsync 策略，AOF 的速度可能会慢于 RDB

# P45 redis 持久化之 RDB+AOF 混合持久化

RDB-AOF 混合持久化

- 官网建议

- rdb vs aof

  - 问题
    - 可否共存？
    - 如果共存听谁的？
  - 官网文档
  - 数据恢复顺序和**加载流程**
    - 在同时开启 rdb 和 aof 持久化时，重启时只会加载 aof 文件，不会加载 rdb 文件

- 你怎么选？用哪个？

  - RDB 持久化方式能够在指定的时间间隔能对你的数据进行快照存储
  - AOF 持久化方式记录每次对服务器写的操作，当服务器重启的时候会重写执行这些命令来恢复原始的数据，AOF 命令以 redis 协议追加保存每次写的操作到文件末尾

- 同时开启两种持久化方式

  - 在这种情况下，**当 redis 重启的时候会优先载入 AOF 文件来恢复原始的数据**，因为在通常情况下 AOF 文件保存的数据集要比 RDB 文件保存的数据集要完整
  - RDB 的数据不实时，同时使用两者时服务器重启也只会找 AOF 文件。**那要不要只使用 AOF 呢？作者建议不要**，因为 RDB 更适合用于备份数据库（AOF 在不断变化不好备份），留着 rdb 作为一个万一的手段

- 推荐方式

  - RDB + AOF 混合方式

    - 结合了 RDB 和 AOF 的优点，既能快速加载又能避免丢失过多的数据。

      1. 开启混合方式设置

         设置 aof-use-rdb-preamble 的值为 yes，yes 表示开启，设置为 no 表示禁用

      2. RDB + AOF 的混合方式 --> 结论：RDB 镜像做全量持久化，AOF 做增量持久化

         先使用 RDB 进行快照存储，然后使用 AOF 持久化记录所有的写操作，当重写策略满足或手动触发重写的时候，**将最新的数据存储为新的 RDB 记录**。这样的话，重启服务的时候会从 RDB 和 AOF 两部分恢复数据，既保证了数据完整性，又提高了恢复数据的性能。简单来说：混合持久化方式产生的文件一部分是 RDB 格式，一部分是 AOF 格式。--> AOF 包括了 RDB 头部 + AOF 混写

# P46 redis 持久化之纯缓存模式 Only

纯缓存模式

- 同时关闭 RDB + AOF
  - save ""
    - 禁用 rdb
    - 禁用 rdb 持久化模式下，我们仍然可以使用命令 save、bgsave 生成 rdb 文件
  - appendonly no
    - 禁用 aof
    - 禁用 aof 持久化模式下，我们仍然可以使用命令 bgrewriteaof 生成 aof 文件

# P47 redis 事务之理论简介

6、Redis 事务

- 是什么
  - 官网
  - 可以一次执行多个命令，本质是一组命令的集合。一个事务中的所有命令都会序列化，**按顺序地串行化执行而不会被其他命令插入，不许加塞**
- 能干嘛
  - 一个队列中，一次性、顺序性、排他性的执行一系列命令
- Redis 事务 VS 数据库事务
  1. 单独的隔离操作
     - Redis 的事务仅仅是保证事务里的操作会被连续独占的执行，redis 命令执行是单线程架构，在执行完事务内所有指令前是不可能再去同时执行其他客户端的请求的
  2. 没有隔离级别的概念
     - 因为事务提交前任何指令都不会被实际执行，也就不存在”事务内的查询要看到事务里的更新，在事务外查询不能看到“这种问题了
  3. 不保证原子性
     - Redis 的事务**不保证原子性**，也就是不保证所有指令同时成功或同时失败，只有决定是否开始执行全部指令的能力，没有执行到一半进行回滚的能力
  4. 排他性
     - Redis 会保证一个事务内的命令依次执行，而不会被其他命令插入
- 怎么玩
- 小总结

# P48 redis 事务之案例实操

怎么玩

- 常用命令

  - | 序号 | 命令                | 描述                                                         |
    | ---- | ------------------- | ------------------------------------------------------------ |
    | 1    | DISCARD             | 取消事务，放弃执行事务块内的所有命令                         |
    | 2    | EXEC                | 执行所有事务块内的命令                                       |
    | 3    | MULTI               | 标记一个事务块的开始                                         |
    | 4    | UNWATCH             | 取消 WATCH 命令对所有 key 的监视                             |
    | 5    | WATCH key [key ...] | 监视一个（或多个）key，如果在事务执行之前这个（或这些）key 被其他命令所改动，那么事务将被打断 |

- case1: 正常执行

  - MULTI
  - EXEC

- case2: 放弃事务

  - MULTI
  - DISCARD

- case3: 全体连坐

  - 官网说明

    - A command may fail to be queued, so there may be an error before `EXEC`. For instance the command may be syntactically wrong (wrong number of arguments, wrong command name, ...), or there may be some critical condition like an out of memory condition (if the server is configured to have a memory limit using the `maxmemory` directive)

  - 故意写错，语法编译不通过

    一个语法出错，全体连坐。如果任何一个命令语法有错，Redis 会直接返回错误，所有的命令都不会执行

    值没有变化，无作用

- case4: 冤头债主

  - 前期语法都没错，编译通过；

    执行 exec 后报错：

    冤有头，债有主

    对的执行错的停

  - 官网说明

  - 补充

    - Redis 不提供事务回滚的功能，开发者必须在事务执行出错后，自行恢复数据库状态

  - 注意和传统数据库事务区别，不一定要么一起成功要么一起失败

- case5: watch 监控

  - Redis 使用 Watch 来提供乐观锁锁定，类似于 CAS（Check-and-Set）
    - 悲观锁
      - 悲观锁（Pessimistic Lock），顾名思义，就是很悲观，每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁，这样别人想拿这个数据就会 block 直到它拿到锁。
    - 乐观锁
      - 乐观锁（Optimistic Lock），顾名思义，就是很乐观，每次去拿数据的时候都认为别人不会修改，**所以不会上锁**，但是在更新的时候会判断一下在此期间别人有没有去更新这个数据。
      - **乐观锁策略：提交版本必须大于记录当前版本才能执行更新**
    - CAS
  - watch
    - 初始化 k1 和 balance 两个 key，先监控再开启 multi，保证两 key 变动在同一个事务内
    - 有加塞篡改
      - watch 命令是一种乐观锁的实现，Redis 在修改的时候会检测数据是否被更改，如果更改了，则执行失败
  - unwatch
  - 小结
    - 一旦执行了 exec 之前加的监控锁都会被取消掉了
    - 当客户端连接丢失的时候（比如退出链接），所有东西都会被取消监视

小总结

- **开启**：以 MULTI 开始一个事务
- **入队**：将多个命令入队到事务中，接到这些命令并不会立即执行，而是放到等待执行的事务队列里面
- **执行**：由 EXEC 命令触发事务

# P49 redis 管道之理论简介

7、Redis 管道

- 面试题

  - 如何优化频繁命令往返造成的性能瓶颈？

  - 问题由来

    - Redis 是一种基于**客户端-服务端模型**以及请求/响应协议的 TCP 服务。一个请求会遵循以下步骤：

      1. 客户端向服务端发送命令分四步（发送命令 -> 命令排队 -> 命令执行 -> 返回结果），并监听 Socket 返回，通常以阻塞模式等待服务端响应。
      2. 服务端处理命令，并将结果返回给客户端。

      **上述两部称为：Round Trip Time（简称 RTT，数据包往返于两端的时间），问题笔记最下方**

      如果同时需要执行大量的命令，那么就要等待上一条命令应答后再执行，这中间不仅仅多了 RTT（Round Time Trip）,而且还频繁调用系统 IO，发送网络请求，同时需要 redis 调用多次 read() 和 write() 系统方法。系统方法会将数据从用户态转移到内核态，这样就会对进程上下文有比较大的影响了，性能不太好

- 是什么

  - 解决思路
    - 引出管道这个概念
    - 管道（pipeline）可以一次性发送多条命令给服务端，服务端依次处理完毕后，**通过一条响应一次性将结果返回，通过减少客户端与 redis 的通信次数来实现降低往返延时时间**。pipeline 实现的原理是队列，先进先出特性就保证数据的顺序性。
  - 官网
  - 定义
    - Pipeline 是为了解决 RTT 往返回时，仅仅是将命令打包一次性发送，对整个 Redis 的执行不造成其他任何影响
  - 一句话
    - **批处理命令变种优化措施**，类似 Redis 的原生批命令（mget 和 mset）

- 案例演示

- 小总结

# P50 redis 管道之案例实操

案例演示

- 当堂演示

  - ```shell
    cat cmd.txt
    
    # set k100 v100
    # set k200 v200
    # hset k300 name haha
    # hset k300 age 20
    # hset k300 gender male
    
    cat cmd.txt | redis-cli -a 111111 --pipe
    ```

# P51 redis 管道之小总结

小总结

- Pipeline 与原生批量命令对比
  - 原生批量命令是原子性（例如：mset，mget），**pipeline 是非原子性**
  - 原生批量命令一次只能执行一种命令，pipeline 支持批量执行不同命令
  - 原生批命令是服务端实现，而 pipeline 需要服务端与客户端共同完成
- Pipeline 与事务对比
  - 事务具有原子性，管道不具有原子性
  - 管道一次性将多条命令发送到服务器，事务是一条一条的发，事务只有在接收到 exec 命令后才会执行，管道不会
  - 执行事务时会阻塞其他命令的执行，而执行管道中的命令时不会
- 使用 Pipeline 注意事项
  - pipeline 缓冲的指令只是会依次执行，不保证原子性，如果执行中指令发生异常，将会继续执行后续的指令
  - 使用 pipeline 组装的命令个数不能太多，不然数据量过大客户端阻塞的时间可能过久，同时服务端此时也被迫回复一个队列答复，占用很多内存

# P52 redis 发布订阅之理论简介

8、Redis 发布订阅

- 学习定位
  - 了解即可
- 是什么
  - 定义
    - 是一种消息通信模式：发送者（PUBLISH）发送消息，订阅者（SUBSCRIBE）接收消息，可以实现进程间的消息传递
  - 官网
  - 一句话
    - Redis 可以实现消息中间件 MQ 的功能，通过发布订阅实现消息的引导和分流。
    - **仅代表我个人**：不推荐使用该功能，专业的事情交给专业的中间件处理，redis 就做好分布式缓存功能
- 能干嘛
  - Redis 客户端可以订阅任意数量的频道，类似我们微信关注多个公众号
    - 当有新消息通过 PUBLISH 命令发送给频道 channel1 时
  - 小总结
    - 发送/订阅其实是一个轻量的队列，只不过数据不会被持久化，一般用来处理**实时性较高的异步消息**
- 常用命令
- 案例演示

# P53 redis 发布订阅之命令简介

常用命令

- | 序号 | 命令                                        | 描述                             |
  | ---- | ------------------------------------------- | -------------------------------- |
  | 1    | PSUBSCRIBE pattern [pattern ...]            | 订阅一个或多个符合给定模式的频道 |
  | 2    | PUBSUB subcommand [argument [argument ...]] | 查看订阅与发送系统状态           |
  | 3    | PUBLISH channel message                     | 将信息发送到指定的频道           |
  | 4    | PUNSUBSCRIBE [pattern [pattern ...]]        | 退订所有给定模式的频道           |
  | 5    | SUBSCRIBE channel [channel ...]             | 订阅给定的一个或多个频道的信息   |
  | 6    | UNSUBSCRIBE [channel [channel ...]]         | 指退订给定的频道                 |

- SUBSCRIBE channel [channel ...]

  - 订阅给定的一个或多个频道的信息
  - **推荐先执行订阅后再发布，订阅成功之前发布的消息是收不到的**
  - 订阅的客户端每次可以收到一个 3 个参数的消息
    - 消息的种类
    - 始发频道的名称
    - 实际的消息内容

- PUBLISH channel message

  - 发送消息到指定的频道

- PSUBSCRIBE pattern [pattern ...]

  - 按照模式批量订阅，订阅一个或多个符合给定模式（支持 * 号 ？号之类的）的频道

- PUBSUB subcommand [argument [argument ...]]

  - 查看订阅与发布系统状态
  - PUBSUB CHANNELS
    - 由活跃频道组成的列表
  - PUBSUB NUMSUB [channel [channel ...]]
    - 某个频道有几个订阅者
  - PUBSUB NUMPAT
    - 只统计使用 PSUBSCRIBE 命令执行的，返回客户端订阅的唯一**模式的数量**

- UNSUBSCRIBE [channel [channel ...]]

- PUNSUBSCRIBE [pattern [pattern ...]]

# P54 redis 发布订阅之案例实操

案例演示

- 当堂演示

  - 打开 3 个客户端，演示客户端 A、B 订阅消息，客户端 C 发布消息
  - 演示批量订阅和发布
  - 取消订阅

- 小总结

  - Redis 可以实现消息中间件 MQ 的功能，通过发布订阅实现消息的引导和分流。

    仅代表我个人：不推荐使用该功能，专业的事情交给专业的中间件处理，redis 就做好分布式缓存功能

  - Pub/Sub 缺点

    - 发布的消息在 Redis 系统中不能持久化，因此，必须先执行订阅，再等待消息发布。如果先发布了消息，那么该消息由于没有订阅者，
    - 消息只管发送对于发布者而言消息是即发即失的，不管接收，也没有 ACK 机制，无法保证消息的消费成功。
    - 以上缺点导致 Redis 的 Pub/Sub 模式就像个小玩具，在生产环境中几乎无用武之地，为此 Redis 5.0 版本新增了 Stream 数据结构，不但支持多播，还支持数据持久化，相比 Pub/Sub 更加的强大

# P55 redis 主从复制之理论简介

9、Redis 复制（replica）

- 是什么
  - 官网地址
  - 一句话
    - 就是主从复制，master 以写为主，Slave 以读为主
    - 当 master 数据变化的时候，自动将新的数据异步同步到其它 slave 数据库
- 能干嘛
  - 读写分离
  - 容灾恢复
  - 数据备份
  - 水平扩容支撑高并发
- 怎么玩
  - 配从（库）不配主（库）
  - 权限细节，重要
    - master 如果配置了 requirepass 参数，需要密码登陆
    - 那么 slave 就要配置 masterauth 来设置校验密码，否则的话 master 会拒绝 slave 的访问请求
  - 基本操作命令
    - info replication
      - 可以用查看复制节点的主从关系和配置信息
    - replicaof 主库IP 主库端口
      - 一般写入进 redis.conf 配置文件内
    - slaveof 主库IP 主库端口
      - 每次与 master 断开之后，都需要重新连接，除非你配置进 redis.conf 文件
      - 在运行期间修改 slave 节点的信息，如果该数据库已经是某个主数据库的从数据库，那么会停止和原主数据库的同步关系**转而和新的主数据库同步，重新拜码头**
    - slaveof no one
      - 使当前数据库停止与其它数据库的同步，**转成主数据库，自立为王**
- 案例演示
- 复制原理和工作流程
- 复制的缺点

# P56 redis 主从复制之演示架构

案例演示

- 架构说明
  - 一个 Master 两个 Slave
    - 3 台虚机，每台都安装 redis
  - 拷贝多个 redis.conf 文件
    - redis6379.conf
    - redis6380.conf
    - redis6381.conf
- 小口诀
  - 三边网络相互 ping 通且注意防火墙配置
  - 三大命令
    - 主从复制
      - replicaof 主库IP 主库端口
      - 配从（库）不配主（库）
    - 改换门庭
      - slaveof 新主库IP 新主库端口
    - 自立为王
      - slaveof no one
- 修改配置文件细节操作
- 常用 3 招

# P57 redis 主从复制之配置细则

修改配置文件细节操作

- redis6379.conf 为例，步骤
  1. 开启 daemonize yes
  2. 注释掉 bind 127.0.0.1
  3. protected-mode no
  4. 指定端口
  5. 指定当前工作目录, dir
  6. pid 文件名字，pidfile
  7. log 文件名字，logfile
  8. requirepass
  9. dump.rdb 名字
  10. aof 文件，appendfilename
  11. **从机访问主机的通行密码 masterauth，必须**
      - 从机需要配置，主机不用

常用 3 招

- 一主二仆
- 薪火相传
- 反客为主

# P58 redis 主从复制之一主二仆

一主二仆

- 方案1：配置文件固定写死

  - 配置文件执行
    - replicaof 主库IP 主库端口
    - 配从（库）不配主（库）
      - 配置从机 6380
      - 配置从机 6381
    - 先 master 后两台 slave 依次启动
    - 主从关系查看
      - 日志
        - 主机日志
        - 备机日志
      - 命令
        - info replication 命令查看

- 主从问题演示

  1. 从机可以执行写命令吗？

     - 不行，报错：`(error) READONLY You can't write against a read only replica.`

  2. 从机切入点问题

     - **slave 是从头开始复制还是从切入点开始复制？**

       master 启动，写到 k3

       slave1 跟着 master 同时启动，跟着写到 k3

       slave2 写到 k3 后才启动，那之前的是否也可以复制？

       Y，首次一锅端，后续跟随，master 写，slave 跟。

  3. 主机 shutdown 后，从机会上位吗？

     - **主机 shutdown 后情况如何？从机是上位还是原地待命？**

       从机不动，原地待命，从机数据可以正常使用；等待主机重启动归来

  4. 主机 shutdown 后，重启后主从关系还在吗？从机还能否顺利复制？

     - 可以

  5. 某台从机 down 后，master 继续，从机重启后它能跟上大部队吗？

     - 可以

- 方案2：命令操作手动指定

  - 从机停机去掉配置文件中的配置项，3 台目前都是主机状态，各不从属
  - 3 台 master
  - 预设的从机上执行命令
    - slaveof 主库IP 主库端口
    - 效果
  - 用命令使用的话，2 台从机重启后，关系还在吗？
    - 不在了

- 配置 VS 命令的区别，当堂试验讲解

  - 配置，持久稳定
  - 命令，当次生效

# P59 redis 主从复制之薪火相传

薪火相传

- 上一个 slave 可以是下一个 slave 的 master，slave 同样可以接收其他 slaves 的连接和同步请求，那么该 slave 作为了链条中下一个的 master，可以有效减轻主 master 的写压力
- 中途变更转向：会清除之前的数据，重新建立拷贝最新的
- slaveof 新主库IP 新主库端口

# P60 redis 主从复制之反客为主

反客为主

- SLAVEOF no one
  - 使当前数据库停止与其他数据库……

# P61 redis 主从复制之工作流程总结

复制原理和工作流程

- slave 启动，同步初请
  - slave 启动成功连接到 master 后会发送一个 sync 命令
  - slave 首次全新连接 master，一次完全同步（全量复制）将被自动执行，slave 自身原有数据会被 master 数据覆盖清除
- 首次连接，全量复制
  - master 节点收到 sync 命令后会开始在后台保存快照（即 RDB 持久化，主从复制时会触发 RDB），同时收集所有接收到的用于修改数据集命令缓存起来，master 节点执行 RDB 持久化完后，master 将 rdb 快照文件和所有缓存的命令发送到所有 slave，以完成一次完全同步
  - 而 slave 服务在接收到数据库文件数据后，将其存盘并加载到内存中，从而完成复制初始化
- 心跳持续，保持通信
  - repl-ping-replica-period 10
    - master 发出 PING 包的周期，默认是 10 秒
- 进入平稳，增量复制
  - Master 继续将新的所有收集到的修改命令自动依次传给 slave，完成同步
- 从机下线，重连续传
  - master 会检查 backlog 里面的 offset，master 和 slave 都会保存一个复制的 offset 还有一个 masterId，offset 是保存在 backlog 中的。**Master 只会把已经复制的 offset 后面的数据复制给 Slave**，类似断点续传

# P62 redis 主从复制之痛点和改进需求

复制的缺点

- 复制延时，信号衰减
  - 由于所有的写操作都是先在 Master 上操作，然后同步更新到 Slave 上，所以从 Master 同步到 Slave 机器有一定的延迟，当系统很繁忙的时候，延迟问题会更加严重，Slave 机器数量的增加也会使这个问题更加严重。
- Master 挂了怎么办？
  - 默认情况下，不会在 slave 节点中自动重选一个 master
  - 那每次都要人工干预？
    - 无人值守安装变成刚需

# P63 redis 哨兵监控之理论简介

10、Redis 哨兵（sentinel）

- 是什么
  - 吹哨人巡查监控后台 master 主机是否故障，如果故障了根据**投票数**自动将某个从库转换为新主库，继续对外服务
  - 作用
    - 俗称，无人值守运维
    - **哨兵的作用：**
      1. 监控 redis 运行状态，包括 master 和 slave
      2. 当 master down 机，能自动将 slave 切换成新 master
  - 官网理论
- 能干嘛
  - 主从监控
    - 监控主从 redis 库运行是否正常
  - 消息通知
    - 哨兵可以将故障转移的结果发送给客户端
  - 故障转移
    - 如果 Master 异常，则会进行主从切换，将其中一个 Slave 作为新 Master
  - 配置中心
    - 客户端通过连接哨兵来获得 Redis 服务的主节点地址
- 怎么玩（案例演示实战步骤）
- 哨兵运行流程和选举原理
- 哨兵使用建议

# P64 redis 哨兵监控之案例实操01

怎么玩（案例演示实战步骤）

- Redis Sentinel 架构，前提说明
  - 3 个哨兵
    - 自动监控和维护集群，不存放数据，只是吹哨人
  - 1 主 2 从
    - 用于数据读取和存放
- 案例步骤，不服就干
  - /myredis 目录下新建或者拷贝 sentinel.conf 文件，名字绝不能错
  - 先看看 /opt 目录下默认的 sentinel.conf 文件的内容
  - 重点参数项说明
    - bind
      - 服务监听地址，用于客户端连接，默认本机地址
    - daemonize
      - 是否以后台 daemon 方式运行
    - protected-mode
      - 安全保护模式
    - port
      - 端口
    - logfile
      - 日志文件路径
    - pidfile
      - pid 文件路径
    - dir
      - 工作目录
    - `sentinel monitor <master-name> <ip> <redis-port> <quorum>`
      - 设置要监控的 master 服务器
      - quorum 表示最少有几个哨兵认可客观下线，同意故障迁移的法定票数
    - `sentinel auth-pass <master-name> <password>`
    - 其它
  - 本次案例哨兵 sentinel 文件通用配置
  - 先启动一主二从 3 个 redis 实例，测试正常的主从复制
  - =====以下是哨兵内容部分=====
  - 再启动 3 个哨兵，完成监控
  - 启动 3 个哨兵监控后再测试一次主从复制
    - 岁月静好一切 OK
  - 原有的 master 挂了
  - 对比配置文件
- 其他备注

# P65 redis 哨兵监控之案例实操02

`sentinel monitor <master-name> <ip> <redis-port> <quorum>`

- 设置要监控的 master 服务器

- quorum 表示最少有几个哨兵认可客观下线，同意故障迁移的法定票数

  - 行尾最后的 quorum 代表什么意思呢？**quorum：确认客观下线的最少的哨兵数量**

    我们知道，网络是不可靠的，有时候一个 sentinel 会因为网络堵塞而**误以为**一个 master redis 已经死掉了，在 sentinel 集群环境下需要多个 sentinel 互相沟通来确认某个 master **是否真的死了**，quorum 这个参数是进行客观下线的一个依据，意思是至少有 quorum 个 sentinel 认为这个 master 有故障，才会对这个 master 进行下线以及故障转移。因为有的时候，某个 sentinel 节点可能因为自身网络原因，导致无法连接 master，而此时 master 并没有出现故障，所以，这就需要多个 sentinel 都一致认为该 master 有问题，才可以进行下一步操作，这就保证了公平性和高可用。

`sentinel auth-pass <master-name> <password>`

- master 设置了密码，连接 master 服务的密码

其它

- `sentinel down-after-milliseconds <master-name> <milliseconds>`

  指定多少毫秒之后，主节点没有应答哨兵，此时哨兵主观上认为主节点下线

- `sentinel parallel-syncs <master-name> <nums>`

  表示允许并行同步的 slave 个数，当 Master 挂了后，哨兵会选出新的 Master，此时，剩余的 slave 会向新的 master 发起同步数据

- `sentinel failover-timeout <master-name> <milliseconds>`

  故障转移的超时时间，进行故障转移时，如果超过设置的毫秒，表示故障转移失败

- `sentinel  notification-script <master-name> <script-path>`

  配置当某一事件发生时所需要执行的脚本

- `sentinel client-reconfig-script <master-name> <script-path>`

  客户端重新配置主节点参数脚本

# P66 redis 哨兵监控之案例实操03

本次案例哨兵 sentinel 文件通用配置

- 由于机器硬件关系，我们的 3 个哨兵都同时配置进 192.168.111.169 同一台机器

- sentinel26379.conf

  - ```
    bind 0.0.0.0
    daemonize yes
    protected-mode no
    port 26379
    logfile "/myredis/sentinel26379.log"
    pidfile /var/run/redis-sentinel26379.pid
    dir /myredis
    sentinel monitor mymaster 192.168.111.169 6379 2
    sentinel auth-pass mymaster 111111
    ```

- sentinel26380.conf

  - ```
    bind 0.0.0.0
    daemonize yes
    protected-mode no
    port 26380
    logfile "/myredis/sentinel26380.log"
    pidfile /var/run/redis-sentinel26380.pid
    dir /myredis
    sentinel monitor mymaster 192.168.111.169 6379 2
    sentinel auth-pass mymaster 111111
    ```

- sentinel26381.conf

  - ```
    bind 0.0.0.0
    daemonize yes
    protected-mode no
    port 26381
    logfile "/myredis/sentinel26381.log"
    pidfile /var/run/redis-sentinel26381.pid
    dir /myredis
    sentinel monitor mymaster 192.168.111.169 6379 2
    sentinel auth-pass mymaster 111111
    ```

- 请看一眼 sentinel26379.conf、sentinel26380.conf、sentinel26381.conf 我们自己填写的内容

- master 主机配置文件说明

先启动一主二从 3 个 redis 实例，测试正常的主从复制

- 架构说明
  1. 169 机器上新建 redis6379.conf 配置文件，由于要配合本次案例，请设置 masterauth 项访问密码为 111111，不然后续可能报错 master_link_status:down
  2. 172 机器上新建 redis6380.conf 配置文件，设置好 `replicaof <masterip> <masterport>`
  3. 173 机器上新建 redis6381.conf 配置文件，设置好 `replicaof <masterip> <masterport>`
- 请看一眼 sentinel6379.conf、sentinel6380.conf、sentinel6381.conf 我们自己填写主从复制相关内容
  - 主机 6379
    - 6379 后续可能会变成从机，需要设置访问新主机的密码，请设置 masterauth 项访问密码为 111111，**不然后续可能报错 master_link_status:down**
  - 6380
  - 6381
- 3 台不同的虚拟机实例，启动三部真实机器实例并连接
- 具体查看当堂动手案例配置并观察文件内容

# P67 redis 哨兵监控之案例实操04

先启动一主二从 3 个 redis 实例，测试正常的主从复制

- 3 台不同的虚拟机实例，启动三部真实机器实例并连接
  - redis-cli -a 111111 -p 6379
  - redis-cli -a 111111 -p 6380
  - redis-cli -a 111111 -p 6381

再启动 3 个哨兵，完成监控

- redis-sentinel sentinel26379.conf --sentinel
- redis-sentinel sentinel26380.conf --sentinel
- redis-sentinel sentinel26381.conf --sentinel

启动 3 个哨兵监控后再测试一次主从复制

- 岁月静好一切 OK

# P68 redis 哨兵监控之案例实操05

原有的 master 挂了

- 我们自己手动关闭 6379 服务器，模拟 master 挂了
- 问题思考
  - 两台**从机**数据是否 OK
  - 是否会从剩下的 2 台机器上选出新的 master
    - 会
  - 之前 down 机的 master 机器重启回来，谁将会是新老大？会不会双 master 冲突？
    - 新 master，不会
- 揭晓答案

# P69 redis 哨兵监控之案例实操06

揭晓答案

- 数据 OK
  - 两个小问题
    - info replication -> Error: Server closed the connection
    - get k2 -> Error: Broken pipe
  - 6380
  - 6381
  - 了解 Broken Pipe
    - 认识 broken pipe
      - pipe 是管道的意思，管道里面是数据流，通常是从文件或网络套接字读取的数据。当该管道从另一端突然关闭时，会发生数据突然中断，即是 broken，对于 socket 来说，可能是网络被拔出或另一端的进程崩溃
    - 解决问题
      - 其实当该异常发生的时候，对于服务器来说，并没有多少影响。因为可能是某个客户端突然中止了进程导致了该错误
    - 总结 Broken pipe
      - 这个异常是客户端读取超时关闭了连接，这时候服务器端再向客户端已经断开的连接写数据时就发生了 broken pipe 异常！
- 投票新选
  - sentinel26379.log
  - sentinel26380.log
  - sentinel26381.log
- 谁是 master，限本次案例
  - 6381 被选为新 master，上位成功
  - 以前的 6379 从 master 降级变成了 slave
  - 6380 还是 slave，只不过换了个新老大 6381（6379 变 6381），6380 还是 slave

对比配置文件

- vim sentinel26379.conf
- 老master，vim redis6379.conf
- 新master，vim redis6381.conf
- 结论
  - 文件的内容，在运行期间会被 sentinel 动态进行更改
  - Master-Slave 切换后，master_redis.conf、slave_redis.conf 和 sentinel.conf 的内容都会发生改变，即 master_redis.conf 中会多一行 slaveof 的配置，sentinel.conf 的监控目标会随之调换

# P70 redis 哨兵监控之案例实操07

其它备注

- 生产都是不同机房不同服务器，很少出现 3 个哨兵全挂掉的情况
- 可以同时监控多个 master，一行一个

# P71 redis 哨兵监控之哨兵运行流程

哨兵运行流程和选举原理

- 当一个主从配置中的 master 失效之后，sentinel 可以选举出一个新的 master 用于自动接替原 master 的工作，主从配置中的其他 redis 服务器自动指向新的 master 同步数据。一般建议 sentinel 采取奇数台，防止某一台 sentinel 无法连接到 master 导致误切换

- 运行流程，故障切换

  - 三个哨兵监控一主二从，正常运行中……

  - SDown 主观下线（Subjectively Down）

    - SDOWN（主观不可用）是**单个 Sentinel 自己主观上**检测到的关于 master 的状态，从 sentinel 的角度来看，如果发送了 PING 心跳后，在一定时间内没有收到合法的回复，就达到了 SDOWN 的条件。

    - sentinel 配置文件中的 down-after-milliseconds 设置了判断主观下线的时间长度

    - 说明

      - 所谓主观下线（Subjectively Down，简称 SDOWN）指的是**单个 Sentinel 实例**对服务器做出的下线判断，即单个 sentinel 认为某个服务下线（有可能是接收不到订阅，之间的网络不通等等原因）。主观下线就是说如果服务器在 [sentinel down-after-milliseconds] 给定的毫秒数之内没有回应 PING 命令或者返回一个错误消息，那么这个 Sentinel 会主观的（**单方面的**）认为这个 master 不可以用了

        `sentinel down-after-milliseconds <masterName> <timeout>`

        表示 master 被当前 sentinel 实例认定为失效的间隔时间，这个配置其实就是进行主观下线的一个依据

        master 在多长时间内一直没有给 Sentinel 返回有效信息，则认定该 master 主观下线。也就是说如果多久没联系上 redis-server，认为这个 redis-server 进入到失效（SDOWN）状态。

  - ODown 客观下线（Objectively Down）

    - ODWON 需要一定数量的 sentinel，**多个哨兵达成一致意见**才能认为一个 master 客观上已经宕掉

    - 说明

      - **quorum 这个参数是进行客观下线的一个依据，**法定人数/法定票数

        意思是至少有 quorum 个 sentinel 认为这个 master 有故障才会对这个 master 进行下线以及故障转移。因为有的时候，某个 sentinel 节点可能因为自身网络原因导致无法连接 master，而此时 master 并没有出现故障，所以这就需要多个 sentinel 都一致认为该 master 有问题，才可以进行下一步操作，这就保证了公平性和高可用。

  - 选举出领导者哨兵（哨兵中选出兵王）

    - 当主节点被判断客观下线以后，各个哨兵节点会进行协商，先选举出一个**领导者哨兵节点（兵王）**并由该领导者节点，也即被选举出的兵王进行 failover（故障迁移）

      - 三哨兵日志文件 2 次解读分析

        - sentinel26379.log

        - sentinel26380.log

          - ```
            +sdown ...
            +odown ...
            +new-epoch 1
            +try-failover ...
            Sentinel new configuration saved on disk
            +vote-for-leader ...
            
            ...
            
            +switch-master ...
            +slave ...
            +slave ...
            ```

        - sentinel26381.log

    - 哨兵领导者，兵王如何选出来的？

      - Raft 算法

        - 监视该主节点的所有哨兵都有可能被选为领导者，选举使用的算法是 Raft 算法；Raft 算法的基本思路**是先到先得**

          即在一轮选举中，哨兵 A 向 B 发送成为领导者的申请，如果 B 没有同意过其他哨兵，则会同意 A 成为领导者

  - 由兵王开始推动故障切换流程并选出一个新 master