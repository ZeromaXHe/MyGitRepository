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