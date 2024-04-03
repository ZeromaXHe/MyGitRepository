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

# P72 redis 哨兵监控之新 master 选举算法

由兵王开始推动故障切换流程并选出一个新 master

- 3 步骤

  - 新主登基

    - 某个 Slave 被选中成为新 Master

    - 选出新 Master 的规则，剩余 Slave 节点健康前提下

      - priority 高 -> replication offset 大 -> Run ID 小

      - redis.conf 文件中，优先级 slave-priority 或者 replica-priority 最高的从节点（数字越小优先级越高）

        - ```
          replica-priority 100
          ```

      - 复制偏移位置 offset 最大的从节点

      - 最小 Run ID 的从节点

        - 字典顺序，ASCII 码

  - 群臣俯首

    - 一朝天子一朝臣，换个码头重新拜
    - 执行 slaveof no one 命令让选出来的从节点成为新的主节点，并通过 slaveof 命令让其他节点成为其从节点
    - Sentinel leader 会对选举出的新 master 执行 slaveof no one 操作，将其提升为 master 节点
    - Sentinel leader 向其它 slave 发送命令，让剩余的 slave 成为新的 master 节点的 slave

  - 旧主拜服

    - 老 master 回来也认怂
    - 将之前已下线的老 master 设置为新选出的新 master 的从节点，当老 master 重新上线后，它会成为新 master 的从节点
    - Sentinel leader 会让原来的 master 降级为 slave 并恢复正常工作

- 小总结

  - 上述的 failover 操作均由 sentinel 自己独自完成，完全无需人工干预

# P73 redis 哨兵监控之哨兵使用建议

哨兵使用建议

- 哨兵节点的数量应为多个，哨兵本身应该集群，保证高可用
- 哨兵节点的数量应该是奇数
- 各个哨兵节点的配置应一致
- 如果哨兵节点部署在 Docker 等容器里面，尤其要注意端口的正确映射
- 哨兵集群 + 主从复制，并不能保证数据零丢失
  - 承上启下引出集群

# P74 redis 集群分片之集群是什么

11、Redis 集群（cluster）

- 是什么
  - 定义
    - **由于数据量过大，单个 Master 复制集**难以承担，因此需要对多个复制集进行集群，形成水平扩展每个复制集只负责存储整个数据集的一部分，这就是 Redis 的集群，其作用是提供在多个 Redis 节点间共享数据的程序集
  - 官网
  - 一图
  - 一句话
    - Redis 集群是一个提供在多个 Redis 节点间共享数据的程序集
    - **Redis 集群可以支持多个 Master**
- 能干嘛
- 集群算法-分片-槽位 slot
- 集群环境案例步骤
- 集群常见操作命令和 CRC 16 算法分析

# P75 redis 集群分片之集群能干嘛

能干嘛

- Redis 集群支持多个 Master，每个 Master 又可以挂载多个 Slave
  - 读写分离
  - 支持数据的高可用
  - 支持海量数据的读写存储操作
- 由于 Cluster 自带 Sentinel 的故障转移机制，内置了高可用的支持，**无需再去使用哨兵功能**
- 客户端与 Redis 的节点连接，不再需要连接集群中所有的节点，只需要任意连接集群中的一个可用节点即可
- **槽位 slot** 负责分配到各个物理服务节点，由对应的集群来负责维护节点、插槽和数据之间的关系

# P76 redis 集群分片之槽位 slot

集群算法-分配-槽位 slot

- 官网出处

  - 翻译说明

- redis 集群的槽位 slot

  - **Redis 集群的数据分片**

    Redis 集群没有使用一致性 Hash，而是引入了**哈希槽**的概念

    Redis 集群有 16384 个哈希槽，每个 key 通过 CRC16 校验后对 16384 取模来决定放置哪个槽。集群的每个节点负责一部分 hash 槽。

- redis 集群的分片

- 他俩的优势

- slot 槽位映射，一般业界有 3 种解决方案

- 经典面试题

  **为什么 redis 集群的最大槽数是 16384 个？**

- Redis 集群不保证强一致性，这意味着在特定的条件下，Redis 集群可能会丢掉一些被系统收到的写入请求命令

# P77 redis 集群分片之分片

redis 集群的分片

- 分片是什么
  - 使用 Redis 集群时我们会将存储的数据分散到多台 redis 机器上，这称为分片。简言之，集群中的每个 Redis 实例都被认为是整个数据的一个分片。
- 如何找到给定 key 的分片
  - 为了找到给定 key 的分片，我们对 key 进行 CRC16(key) 算法处理并通过对总分片数量取模。然后，**使用确定性哈希函数**，这意味着给定的 key **将多次始终映射到同一个分片**，我们可以推断将来读取特定 key 的位置。
- HASH_SLOT = CRC16(key) mod 16384

# P78 redis 集群分片之分片优势

他俩的优势

- **最大优势，方便扩缩容和数据分派查找**

  这种结构很容易添加或删除节点。比如如果我想新添加个节点 D，我需要从节点 A、B、C 中得部分槽到 D 上，如果我想移除节点 A，需要将 A 中的槽移到 B 和 C 节点上，然后将没有任何槽的 A 节点从集群中移除即可。由于从一个节点将哈希槽移动到另一个节点并不会停止服务，所以无论添加删除或者改变某个节点的哈希槽的数量都不会造成集群不可用的状态。

# P79 redis 集群分片之哈希取余分区算法

slot 槽位映射，一般业界有 3 种解决方案

- 哈希取余分区

  - 2 亿条记录就是 2 亿个 k，v，我们单机不行必须要分布式多机，假设有 3 台机器构成一个集群，用户每次读写操作都是根据公式：

    hash（key）% N 个机器台数，计算出哈希值，用来决定数据映射到哪一个节点上。

  - **优点：**

    简单粗暴，直接有效，只需要预估好数据规划好节点，例如 3 台、8 台、10 台，就能保证一段时间的数据支撑。使用 Hash 算法让固定的一部分请求落到同一台服务器上，这样每台服务器固定处理一部分请求（并维护这些请求的信息），起到负载均衡+分而治之的作用。

  - 缺点哪？？？

    - **缺点：**

      原来规划好的节点，进行扩容或者缩容就比较麻烦了，不管扩缩，每次数据变动导致节点有变动，映射关系需要重新进行计算，在服务器个数固定不变时没有问题，如果需要弹性扩容或故障停机的情况下，原来的取模公式就会发生变化：Hash(key) / 3 会变成 Hash(key) / ?。此时地址经过取余运算的结果将发生很大变化，根据公式获取的服务器也会变得不可控。

      某个 redis 机器宕机了，由于台数数量变化，会导致 hash 取余全部数据时重新洗牌。

- 一致性哈希算法分区

- **哈希槽分区**

# P80 redis 集群分片之一致性哈希算法 - 上集

一致性哈希算法分区

- 是什么

  - 一致性 Hash 算法背景

    一致性哈希算法在 1997 年由麻省理工学院中提出的，设计目标是为了解决**分布式缓存数据变动和映射问题，某个机器宕机了，分母数量改变了，自然取余数不 OK 了**。

- 能干嘛

  - 提出一致性 Hash 解决方案。目的是当服务器个数发生变动时，尽量减少影响客户端到服务器的映射关系

- 3 大步骤

  - 算法构建一致性哈希环

    - **一致性哈希环**

      一致性哈希算法必然有个 hash 函数并按照算法产生 hash 值，这个算法的所有可能哈希值会构成一个全量集，这个集合可以成为一个 hash 空间 [0, 2^32 - 1]，这个是一个线性空间，但是在算法中，我们通过适当的逻辑控制将它首尾相连（0 = 2^32），这样让它逻辑上形成了一个环形空间

      它也是按照使用取模的方法，**前面笔记介绍的节点取模法是对节点（服务器）的数量进行取模。而一致性 Hash 算法是对 2 ^ 32 取模**。简单来说，**一致性 Hash 算法将整个哈希值空间组织成一个虚拟的圆环**，如假设某哈希函数 H 的值空间为 0 ~ 2 ^ 32 - 1（即哈希值是一个 32 位无符号整数），整个哈希环如下图：整个空间**按顺时针方向组织**，圆环的正上方的点代表 0，0 点右侧的第一个点代表 1，以此类推，2、3、4、…… 直到 2 ^ 32 - 1，也就是说 0 点左侧的第一个点代表 2 ^ 32 - 1，0 和 2 ^ 32 - 1 在零点中方向重合，我们把这个由 2 ^ 32 个点组成的圆环称为 Hash 环。

  - 服务器 IP 节点映射

  - key 落到服务器的落键规则

- 优点

- 缺点

- 小总结

# P81 redis 集群分片之一致性哈希算法 - 下集

服务器 IP 节点映射

- **节点映射**

  将集群中各个 IP 节点映射到环上的某一个位置。

  将各个服务器使用 Hash 进行一个哈希，具体可以选择服务器的 IP 或主机名作为关键字进行哈希，这样每台机器就能确定其在哈希环上的位置。假如 4 个节点 Node A、B、C、D，经过 IP 地址的**哈希函数**计算（hash(ip)），使用 IP 地址哈希后在环空间的位置如下

key 落到服务器的落键规则

- 当我们需要存储一个 kv 键值对时，首先计算 key 的 hash 值，hash(key)，将这个 key 使用相同的函数 Hash 计算出哈希值并确定此数据在环上的位置，**从此位置沿环顺时针“行走”**，第一台遇到的服务器就是其应该定位到的服务器，并将该键值对存储在该节点上。

  如我们有 Object A、Object B、Object C、Object D 四个数据对象，经过哈希计算后，在环空间上的位置如下；根据一致性 Hash 算法，数据 A 会被定位到 Node A 上，B 被定位到 Node B 上，C 被定位到 Node C 上，D 被定位到 Node D 上。

# P82 redis 集群分片之一致性哈希算法优缺点

优点

- 一致性哈希算法的容错性

  - **容错性**

    假设 Node C 宕机，可以看到此时对象 A、B、D 不会受到影响。一般的，在一致性 Hash 算法中，如果一台服务器不可用，则**受影响的数据仅仅是此服务器到其环空间中前一台服务器（即沿着逆时针方向行走遇到的第一台服务器）之间数据**，其它不会受到影响。简单说，就是 C 挂了，受到影响的只是 B、C 之间的数据**且这些数据会转移到 D 进行存储。**

- 一致性哈希算法的扩展性

  - **扩展性**

    数据量增加了，需要增加一台节点 NodeX，X 的位置在 A 和 B 之间，那收到影响的也就是 A 到 X 之间的数据，重新把 A 到 X 的数据录入到 X 上即可，不会导致 hash 取余全部数据重新洗牌。

缺点

- 一致性哈希算法的**数据倾斜**问题

  - Hash 环的数据倾斜问题

    一致性 Hash 算法在服务**节点太少时**，容易因为节点分布不均匀而造成**数据倾斜**（被缓存的对象大部分几种缓存在某一台服务器上）问题，例如系统中只有两台服务器

小总结

- 为了在节点数目发生变化时尽可能少的迁移数据

  将所有的存储节点排列在首尾相接的 Hash 环上，每个 key 在计算 Hash 后会**顺时针**找到临近的存储节点存放。而当有节点加入或退出时仅影响该节点在 Hash 环上**顺时针相邻的后续节点**。

  **优点**

  加入和删除节点只影响哈希环中顺时针方向的相邻的节点，对其它节点无影响。

  **缺点**

  数据的分布和节点的位置有关，因为这些节点不是均匀的分布在哈希环上的，所以数据在进行存储时达不到均匀分布的效果。

# P83 redis 集群分片之哈希槽分区算法

哈希槽分区

- 是什么

  - **1 为什么出现**

    一致性哈希算法的**数据倾斜**问题

    哈希槽实质就是一个数组，数组 [0, 2 ^ 14 - 1] 形成 hash slot 空间。

    **2 能干什么**

    解决均匀分配的问题，**在数据和节点之间又加入了一层，把这层称为哈希槽（slot），用于管理数据和节点之间的关系**，现在就相当于节点上放的是槽，槽里放的是数据。

    槽解决的是粒度问题，相当于把粒度变大了，这样便于数据移动。哈希解决的是映射问题，使用 key 的哈希值来计算所在的槽，便于数据分配

    **3 多少个 hash 槽**

    一个集群只能有 16384 个槽，编号 0 - 16384（0 ~ 2 ^ 14 - 1）。这些槽会分配给集群中的所有主节点，分配策略没有要求。

    集群会记录节点和槽的对应关系，解决了节点和槽的关系后，接下来就需要对 key 求哈希值，然后对 16384 取模，余数是几 key 就落入对应的槽里。 HASH_SLOT = CRC16(key) mod 16384。以槽为单位移动数据，因为槽的数目是固定的，处理起来比较容易，这样数据移动问题就解决了。

  - HASH_SLOT = CRC16(key) mod 16384

- 哈希槽计算

  - Redis 集群中内置了 16384 个哈希槽，redis 会根据节点数量大致均等的将哈希槽映射到不同的节点。当需要在 Redis 集群中放置一个 key-value 时，redis 先对 key 使用 crc16 算法算出一个结果然后用结果对 16384 求余数 [CRC16(key) % 16384]，这样每个 key 都会对应一个编号在 0 - 16384 之间的哈希槽，也就是映射到某个节点上。如下代码，key 之 A、B 在 Node2，key 之 C 落在 Node3 上

# P84 redis 集群分片之为什么最大槽数是 16384 个

经典面试题

**为什么 redis 集群的最大槽数是 16384 个？**

- Redis 集群并没有使用一致性 hash 而是引入了哈希槽的概念。**Redis 集群有 16384 个哈希槽，**每个 key 通过 CRC16 校验后对 16384 取模来决定放置哪个槽，集群的每个节点负责一部分 hash 槽。但为什么哈希槽的数量是 16384 (2^14) 个呢？

  > CRC16 算法产生的 hash 值有 16bit，该算法可以产生 2^16=65535 个值
  >
  > 换句话说值是分布在 0 ~ 65535 之间，有更大的 65535 不用为什么只用 16384 就够？
  >
  > 作者在做 mod 运算的时候，为什么不 mod 65536，而选择 mod 16384？ HASH_SLOT = CRC16(key) mod 65536 为什么没启用

- 说明1

  - **正常的心跳数据包**带有节点的完整配置，可以用幂等方式用旧的节点替换旧节点，以便更新旧的配置

    这意味着它们包含原始节点的插槽配置，该节点使用 2k 的空间和 16k 的插槽，但是会使用 8k 的空间（使用 65k 的插槽）。

    同时，由于其它设计折衷，Redis 集群不太可能扩展到 1000 个以上的主节点。

    因此 16k 处于正确的范围内，以确保每个主机具有足够的插槽，最多可容纳 1000 个矩阵，但数量足够少，可以轻松地将插槽配置作为原始位图传播。请注意，在小型群集中，位图将难以压缩，因为当 N 较小时，位图将设置的 slot / N 位占设置位的很大百分比。

- 说明2

  - **（1）如果槽位为 65536，发送心跳信息的消息头达 8k，发送的心跳包过于庞大**

    在消息头中最占空间的是 myslots[CLUSTER_SLOTS / 8]。当槽位为 65536 时，这块的大小是：65536 / 8  / 1024 = 8kb

    在消息头中最占空间的是 myslots[CLUSTER_SLOTS / 8]。当槽位为 16384 时，这块的大小是：16384 / 8  / 1024 = 2kb

    因为每秒钟，redis 节点需要发送一定数量的 ping 消息作为心跳包，如果槽位为 65536，这个 ping 消息的消息头太大了，浪费带宽。

    **（2）redis 的集群主节点数量基本不可能超过 1000 个**。

    集群节点越多，心跳包的消息体内携带的数据越多。如果节点过 1000 个，也会导致网络拥堵。因此 redis 作者不建议 redis cluster 节点数量超过 1000 个。那么，对于节点数在 1000 以内的 redis cluster 集群，16384 个槽位够用了。没有必要扩展到 65536 个

    **（3）槽位越小，节点少的情况下，压缩比高，容易传输**

    Redis 主节点的配置信息中它所负责的哈希槽是通过一张 bitmap 的形式来保存的，在传输过程中会对 bitmap 进行压缩，但是如果 bitmap 的填充率 slots / N 很高的话（N 表示节点数），bitmap 的压缩率就很低。如果节点数很少，而哈希槽数量很多的话，bitmap 的压缩率就很低。

- 计算结论

  - Redis 集群中内置了 16384 个哈希槽，redis 会根据节点数量大致均等的将哈希槽映射到不同的节点。当需要在 Redis 集群中放置一个 key-value 时，redis 先对 key 使用 crc16 算法算出一个结果然后用结果对 16384 求余数 [CRC16(key) % 16384]，这样每个 key 都会对应一个编号在 0 - 16383 之间的哈希槽，也就是映射到某个节点上。

# P85 redis 集群分片之不保证强一致性

Redis 集群不保证强一致性，这意味着在特定的条件下，Redis 集群可能会丢掉一些被系统收到的写入请求命令

- **Write safety**

  Redis Cluster uses asynchronous replication between nodes, and **last failover wins** implicit merge function. This means that the last elected master dataset eventually replaces all the other replicas. There is always a window of time when it is possible to **lose writes** during partitions. However these windows are very different in the case of a client that is connected to the majority of masters, and a client that is connected to the minority of masters

# P86 redis 集群分片之3主3从集群搭建 - 上集

集群环境案例步骤

1. 3主3从 redis 集群配置

   - 找 3 台真实虚拟机，各自新建

     - mkdir -p /myredis/cluster

   - 新建 6 个独立的 redis 实例服务

     - 本次案例设计说明（ip 会有变化）

     - IP：192.168.111.175 + 端口6381/端口6382

       - vim /myredis/cluster/redisCluster6381.conf

         - ```
           bind 0.0.0.0
           daemonize yes
           protected-mode no
           port 6381
           logfile "/myredis/cluster/cluster6381.log"
           pidfile /myredis/cluster6381.pid
           dir /myredis/cluster
           dbfilename dump6381.rdb
           appendonly yes
           appendfilename "appendonly6381.aof"
           requirepass 111111
           masterauth 111111
           
           cluster-enabled yes
           cluster-config-file nodes-6381.conf
           cluster-node-timeout 5000
           ```

       - vim /myredis/cluster/redisCluster6382.conf

         - ```
           bind 0.0.0.0
           daemonize yes
           protected-mode no
           port 6382
           logfile "/myredis/cluster/cluster6382.log"
           pidfile /myredis/cluster6382.pid
           dir /myredis/cluster
           dbfilename dump6382.rdb
           appendonly yes
           appendfilename "appendonly6382.aof"
           requirepass 111111
           masterauth 111111
           
           cluster-enabled yes
           cluster-config-file nodes-6382.conf
           cluster-node-timeout 5000
           ```

     - IP：192.168.111.172 + 端口6383/端口6384

       - vim /myredis/cluster/redisCluster6383.conf
       - vim /myredis/cluster/redisCluster6384.conf

     - IP：192.168.111.174 + 端口6385/端口6386

       - vim /myredis/cluster/redisCluster6385.conf
       - vim /myredis/cluster/redisCluster6386.conf

     - 启动6台redis主机实例

   - 通过 redis-cli 命令为 6 台机器构建集群关系

   - 链接进入 6381 作为切入点，**查看并检验集群状态**

2. 3主3从 redis 集群读写

3. 主从容错切换迁移案例

4. 主从扩容案例

5. 主从缩容案例

# P87 redis 集群分片之3主3从集群搭建 - 下集

通过 redis-cli 命令为 6 台机器构建集群关系

- **构建主从关系命令**

  - // 注意，注意，注意自己的真实 IP 地址

    ```shell
    redis-cli -a 111111 --cluster create --cluster-replicas 1 192.168.111.175:6381 192.168.111.175:6382 192.168.111.172:6383 192.168.111.172:6384 192.168.111.174:6385 192.168.111.174:6386
    ```

    --cluster-replicas 1 表示为每个 master 创建一个 slave 节点

- 一切 OK 的话，3 主 3 从搞定

链接进入 6381 作为切入点，**查看并检验集群状态**

- 链接进入 6381 作为切入点，**查看节点状态**

  - ```shell
    redis-cli -a 111111 -p 6381
    info replication
    cluster info
    cluster nodes
    ```

- info replication

- cluster info

- cluster nodes

# P88 redis 集群分片之3主3从集群读写

3主3从 redis 集群读写

- 对 6381 新增两个 key，看看效果如何

  - ```
    127.0.0.1:6381> set k1 v1
    (error) MOVED 12706 192.168.111.174:6385
    127.0.0.1:6381> set k2 v2
    OK
    ```

- 为什么报错

  - 一定注意槽位的范围区间，需要路由到位

- 如何解决

  - 放置路由失效加参数 -c 并新增两个 key

- 查看集群信息

  - cluster nodes

- 查看某个 key 该属于对应得到槽位值

  CLUSTER KEYSLOT 键名称

# P89 redis 集群分片之主从容错切换

主从容错切换迁移案例

- 容错切换迁移
  - 主 6381 和从机切换，先停止主机 6381
    - 6381 主机停了，对应的真实从机上位
    - 6381 作为 1 号主机分配的从机以实际情况为准，具体是几号机器就是几号
  - 再次查看集群信息，本次 6381 主 6384 从
    - 6381 master 加入宕机了，6384 是否会上位成为新的 master？
  - 停止主机 6381，再次查看集群信息
    - 6384 成功上位并正常使用
  - 随后，6381 原来的主机回来了，是否会上位？
    - 恢复前
    - 恢复后
      - 6381 不会上位并以从节点形式回归
- 集群不保证数据一致性 100% OK，一定会有数据丢失情况
  - Redis 集群不保证强一致性，这意味着在特定的条件下，Redis 集群可能会丢掉一些被系统收到的写入请求命令
- 手动故障转移 or 节点从属调整该如何处理
  - 上面一换后 6381、6384 主从对调了，和原型设计图不一样了，该如何
  - 重新登陆 6381 机器
  - 常用命令
    - CLUSTER FAILOVER

# P90 redis 集群分片之集群扩容

主从扩容案例

- 新建 6387、6388 两个服务实例配置文件 + 新建后启动

  - IP：192.168.111.174 + 端口 6387 / 端口 6388

    - vim /myredis/cluster/redisCluster6387.conf

      - ```
        bind 0.0.0.0
        daemonize yes
        protected-mode no
        port 6387
        logfile "/myredis/cluster/cluster6387.log"
        pidfile /myredis/cluster6387.pid
        dir /myredis/cluster
        dbfilename dump6387.rdb
        appendonly yes
        appendfilename "appendonly6387.aof"
        requirepass 111111
        masterauth 111111
        
        cluster-enabled yes
        cluster-config-file nodes-6387.conf
        cluster-node-timeout 5000
        ```

    - vim /myredis/cluster/redisCluster6388.conf

      - ```
        bind 0.0.0.0
        daemonize yes
        protected-mode no
        port 6388
        logfile "/myredis/cluster/cluster6388.log"
        pidfile /myredis/cluster6388.pid
        dir /myredis/cluster
        dbfilename dump6388.rdb
        appendonly yes
        appendfilename "appendonly6388.aof"
        requirepass 111111
        masterauth 111111
        
        cluster-enabled yes
        ```

- 启动 87/88 两个新的节点实例，此时它们自己都是 master

  - redis-server /myredis/cluster/redisCluster6387.conf
  - redis-server /myredis/cluster/redisCluster6388.conf

- 将新增的 6387 节点（空槽号）作为 master 节点加入原集群

  - 将新增的 6387 作为 master 节点加入原有集群

    redis-cli -a 密码 --cluster add-node 自己实际IP地址:6387 自己实际IP地址:6381

    6387 就是将要作为 master 新增节点

    6381 就是原来集群节点里面的领路人，相当于 6387 拜拜 6381 的码头从而找到组织加入集群

    redis-cli -a 111111 --cluster add-node 192.168.111.174:6387 192.168.111.175:6381

- 检查集群情况第 1 次

  - redis-cli -a 密码 --cluster check 真实ip地址:6381

    redis-cli -a 111111 --cluster check 192.168.111.175:6381

- 重新分派槽号（reshard）

  - 重新分派槽号命令：redis-cli -a 密码 --cluster reshard IP地址：端口号

    redis-cli -a 111111 --cluster reshard 192.168.111.175:6381

- 检查集群情况第 2 次

  - 槽号分派说明

    - 为什么 6387 是 3 个新的区间，以前的还是连续？

      重新分配成本太高，所以前 3 家各自匀出来一部分，从 6381/6382/6283 三个旧节点分别匀出 1364 个坑位给新节点 6387

- 为主节点 6387 分片从节点 6388

  - 命令：redis-cli -a 密码 --cluster add-node ip:新slave端口 ip:新master端口 --cluster-slave --cluster-master-id 新主机节点ID

    redis-cli -a 111111 --cluster add-node 192.168.111.174:6388 192.168.111.174:6387 --cluster-slave --cluster-master-id  4feb6a7ee0ed2b39ff86474cf4189ab2a554a40f （这个是 6387 的编号，按照自己实际情况）

- 检查集群情况第 3 次

  - redis-cli -a 密码 --cluster check 真实ip地址:6381

    redis-cli -a 111111 --cluster check 192.168.111.175:6381

# P91 redis 集群分片之集群缩容

主从缩容案例

- 目的：6387 和 6388 下线

- 检查集群情况第一次，先获得从节点 6388 的节点 ID

  - redis-cli -a 密码 --cluster check 192.168.111.174:6388

- 从集群中将 4 号从节点 6388 删除

  - 命令：redis-cli -a 密码 --cluster del-node ip:从机端口 从机6388节点ID

    redis-cli -a 111111 --cluster del-node 192.168.111.174:6388 218e7b8b4f81be54ff173e4776b4f4aaf7c13da

    redis-cli -a 111111 --cluster check 192.168.111.174:6385

    检查一下发现，6388 被删除了，只剩下 7 台机器了。

- 将 6387 的槽号清空，重新分配，本例将清出来的槽号都给 6381

  - redis-cli -a 111111 --cluster reshard 192.168.111.175:6381

- 检查集群情况第二次

  - redis-cli -a 111111 --cluster check 192.168.111.175:6381
  - 4096 个槽位都指给 6381，它变成了 8192 个槽位，相当于全部都给 6381 了，不然要输入 3 次，一锅端

- 将 6487 删除

  - 命令：redis-cli -a 密码 --cluster del-node ip:端口 6387节点ID

    redis-cli -a 111111 --cluster del-node 192.168.111.174:6387 4feb6a7ee0ed2b39ff86474cf4189ab2a554a40f

- 检查集群情况第三次，6387/6388 被彻底祛除

  - redis-cli -a 111111 --cluster check 192.168.111.175:6381

# P92 redis 集群分片之小总结

集群常见操作命令和 CRC 16 算法分析

- 不在同一个 slot 槽位下的多键操作支持不好，通识占位符登场

  - （error）CROSSSLOT keys in request don't hash to the same slot

    不在同一个 slot 槽位下的键值无法使用 mset、mget 等多键操作

    可以通过 {} 来定义同一组的概念，使 key 中 {} 内相同内容的键值对放到一个 slot 槽位去，对照下图类似 k1、k2、k3 都映射为 x，自然槽位一样

    mset k1{x} l1 k2{x} l2 k3{x} l3

    mget k1{x} k2{x} k3{x}

- Redis 集群有 16384 个哈希槽，每个 key 通过 CRC 16 校验后对 16384 取模来决定放置哪个槽。集群的每个节点负责一部分 hash 槽

  - CRC16 源码浅谈
    - cluster.c  源码分析一下看看

- 常用命令

  - 集群是否完整才能对外提供服务

    - cluster-require-full-coverage

    - 默认 YES，现在集群架构是 3 主 3 从的 redis cluster 由 3 个 master 平分 16384 个 slot，每个 master 的小集群负责 1/3 的 slot，对应一部分数据。

      cluster-require-full-coverage：默认值 yes，即需要集群完整性，方可对外提供服务。通常情况，如果这 3 个小集群中，任何一个（1 主 1 从）挂了，你这个集群对外可提供的数据只有 2/3 了，整个集群是不完整的。redis 默认在这种情况下，是不会对外提供服务的。

      如果你的诉求是，集群不完整的话也需要对外提供服务，需要将该参数设置为 no，这样的话你挂了的那个小集群是不行了，但是其他的小集群仍然可以对外提供服务。

  - CLUSTER COUNTKEYSINSLOT 槽位数字编号

    - 1，该槽位被占用
    - 0，该槽位没占用

  - CLUSTER KEYSLOT 键名称

    - 该键应该存在哪个槽位上

# P93 springboot 整合 redis 之总体概述

12、SpringBoot 集成 Redis

- 总体概述

  - jedis-lettuce-RedisTemplate 三者的联系

  - 本地 Java 连接 Redis 常见问题，小白注意

    - bind 配置请注释掉
    - 保护模式设置为 no
    - Linux 系统的防火墙设置
    - redis 服务器的 IP 地址和密码是否正确
    - 忘记写访问 redis 的服务端口号和 auth 密码
    - 无脑粘贴脑图笔记

  - 集成 Jedis

  - 集成 lettuce

    - 是什么
      - Lettuce 是一个 Redis 的 Java 驱动包，Lettuce 翻译为生菜，没错，就是吃的那种生菜，所以它的 Logo 长这样
    - Lettuce vs Jedis
    - 案例

  - 集成 RedisTemplate-推荐使用

    - 连接单机

      - boot 整合 redis 基础演示

        - 建 Module

          - redis7_study

        - 改 POM

          - ```xml
            <!-- SpringBoot 通用依赖模块 -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <!-- jedis -->
            <dependency>
            	<groupId>redis.clients</groupId>
                <artifactId>jedis</artifactId>
                <version>4.3.1</version>
            </dependency>
            <!-- lettuce -->
            <dependency>
            	<groupId>io.lettuce</groupId>
                <artifactId>lettuce-core</artifactId>
                <version>6.2.1.RELEASE</version>
            </dependency>
            <!-- SpringBoot 与 Redis 整合依赖 -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-data-redis</artifactId>
            </dependency>
            <dependency>
            	<groupId>org.apache.commons</groupId>
                <artifactId>commons-pool2</artifactId>
            </dependency>
            <!-- swagger2 -->
            <dependency>
            	<groupId>io.springfox</groupId>
                <artifactId>springfox-swagger2</artifactId>
                <version>2.9.2</version>
            </dependency>
            ```

        - 写 YML

        - 主启动

        - 业务类

        - 测试

      - 其它 api 调用，一定自己多动手练习（家庭作业）

    - 连接集群

# P94 springboot 整合 redis 之 jedis 简介

集成 Jedis

- 是什么

  - Jedis Client 是 Redis 官网推荐的一个面向 Java 客户端，库文件实现了对各类 API 进行封装调用

- 步骤

  - 建 Module

    - redis7_study

  - 改 POM

    - ```xml
      <!-- jedis -->
      <dependency>
      	<groupId>redis.clients</groupId>
          <artifactId>jedis</artifactId>
          <version>4.3.1</version>
      </dependency>
      ```

  - 写 YML

  - 主启动

  - 业务类

    - 入门案例

      - ```java
        public class JedisDemo {
            public static void main(String[] args) {
                // 1 connection 获得，通过指定 ip 和端口号
                Jedis jedis = new Jedis("192.168.111.185", 6379);
                // 2 指定访问服务器的密码
                jedis.auth("111111");
                // 3 获得了 jedis 客户端，可以像 jdbc 一样，访问我们的 redis
                System.out.println(jedis.ping());
                
                // keys
                Set<String> keys = jedis.keys("*");
                System.out.println(keys);
                // string
                jedis.set("k3", "hello-jedis");
                System.out.println(jedis.get("k3"));
                System.out.println(jedis.ttl("k3"));
                jedis.expire("k3", 20L);
                // list
                jedis.lpush("list", "l1", "l2", "l3");
                List<String> list = jedis.lrange("list", 0, -1);
                for (String element: list) {
                    System.out.println(element);
                }
                // set
                // hash
                // zset
                
            }
        }
        ```

    - 家庭作业 5+1

      - 一个 key
      - 常用五大数据类型

# P95 springboot 整合 redis 之 lettuce 简介

集成 lettuce

- 是什么

  - Lettuce 是一个 Redis 的 Java 驱动包，Lettuce 翻译为生菜，没错，就是吃的那种生菜，所以它的 Logo 长这样

- Lettuce vs Jedis

  - **Jedis 和 Lettuce 的区别**

    Jedis 和 Lettuce 都是 Redis 的客户端，它们都可以连接 Redis 服务器，但是在 SpringBoot 2.0 之后默认都是使用的 Lettuce 这个客户端连接 Redis 服务器。因为当使用 Jedis 客户端连接 Redis 服务器的时候，每个线程都要拿自己创建的 Jedis 实例去连接 Redis 客户端，当有很多个线程的时候，不仅开销大需要反复的创建关闭一个 Jedis 连接，而且也是线程不安全的，一个线程通过 Jedis 实例更改 Redis 服务器中的数据之后会影响另一个线程；

    但是如果使用 Lettuce 这个客户端连接 Redis 服务器的时候，就不会出现上面的情况，Lettuce 底层使用的是 Netty，当有多个线程都需要连接 Redis 服务器的时候，可以保证只创建一个 Lettuce 连接，使所有的线程共享这一个 Lettuce 连接，这样可以减少创建关闭一个 Lettuce 连接时候的开销；而且这种方式也是线程安全的，不会出现一个线程通过 Lettuce 更改 Redis 服务器中的数据之后而影响另一个线程的情况。

- 案例

  - 改 POM

    - ```xml
      <!-- lettuce -->
      <dependency>
      	<groupId>io.lettuce</groupId>
          <artifactId>lettuce-core</artifactId>
          <version>6.2.1.RELEASE</version>
      </dependency>
      ```

  - 业务类

    - ```java
      @Slf4j
      public class LettuceDemo {
          public static void main(String[] args) {
              // 1 使用构建器链式编程来 build 我们 RedisURI
              RedisURI uri = RedisURI.builder()
                  .redis("192.168.111.185")
                  .withPort(6379)
                  .withAuthentication("default", "111111")
                  .build();
              
              // 2 创建连接客户端
              RedisClient redisClient = RedisClient.create(uri);
              StatefulRedisConnection<String, String> conn = redisClient.connect();
              
              // 3 通过 conn 创建操作的 command
              RedisCommands commands = conn.sync();
              
              // keys
              List<String> list = commands.keys("*");
              for (String s: list) {
                  log.info("key:{}", s);
              }
              // String
              commands.set("k1", "1111");
              String s1 = commands.get("k1");
              log.info("String s ===" + s1);
              // list
              commands.lpush("myList2", "v1", "v2", "v3");
              List<String> list2 = commands.lrange("myList2", 0, -1);
              for (String s: list2) {
                  log.info("list ssss === {}", s);
              }
              // set
              commands.sadd("mySet2", "v1", "v2", "v3");
              Set<String> set = commands.smembers("mySet2");
              for (String s: set) {
                  log.info("set ssss === {}", s);
              }
              // hash
              Map<String, String> map = new HashMap<>();
              map.put("k1", "138xxxxxxxx");
              map.put("k2", "atguigu");
              map.put("k3", "zzyybs@126.com");
              commands.hmset("myHash2", map);
              Map<String, String> retMap = commands.hgetall("myHash2");
              for (String k: retMap.keySet()) {
                  log.info("hash k={}, v=={}", k, retMap.get(k));
              }
              // zset
              commands.zadd("myZset2", 100.0, "s1", 110.0, "s2", 90.0, "s3");
              List<String> list3 = commands.zrange("myZset2", 0, 10);
              for (String s: list3) {
                  log.info("zset ssss === {}", s);
              }
              // sort
              SortArgs sortArgs = new SortArgs();
              sortArgs.alpha();
              sortArgs.desc();
              List<String> list4 = commands.sort("myList2", sortArgs);
              for (String s: list4) {
                  log.info("sort ssss === {}", s);
              }
              // 4 各种关闭释放资源
              conn.close();
              redisClient.shutdown();
          }
      }
      ```

# P96 springboot 整合 redis 之 RedisTemplate - 上集

集成 RedisTemplate-推荐使用

- 连接单机

  - boot 整合 redis 基础演示

    - 建 Module

      - redis7_study

    - 改 POM

      - ```xml
        </dependency>
        <!-- SpringBoot 与 Redis 整合依赖 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>
        <dependency>
        	<groupId>org.apache.commons</groupId>
            <artifactId>commons-pool2</artifactId>
        </dependency>
        <!-- swagger2 -->
        <dependency>
        	<groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>2.9.2</version>
        </dependency>
        <dependency>
        	<groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
            <version>2.9.2</version>
        </dependency>
        ```

    - 写 YML

      - ```properties
        # ===== redis 单机 =====
        spring.redis.database=0
        # 修改为自己真实 IP
        spring.redis.host=192.168.111.185
        spring.redis.port=6379
        spring.redis.password=111111
        spring.redis.lettuce.pool.max-active=8
        spring.redis.lettuce.pool.max-wait=-1ms
        spring.redis.lettuce.pool.max-idle=8
        spring.redis.lettuce.pool.min-idle=0
        ```

    - 主启动

    - 业务类

      - 配置类

        - RedisConfig

          - ```java
            @Configuration
            public class RedisConfig {
                @Bean
                public RedisTemplate<String, Object> redisTemplate(LettuceConnectionFactory lettuceConnectionFactory) {
                    RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
                    redisTemplate.setConnectionFactory(lettuceConnectionFactory);
                    // 设置 key 序列化方式 string
                    redisTemplate.setKeySerializer(new StringRedisSerializer());
                    // 设置 value 的序列化方式 json，使用 GenericJackson2JsonRedisSerializer 替换默认序列化
                    redisTemplate.setValueSerializer(new GenericJackson2JsonRedisSerializer());
                    
                    redisTemplate.setHashKeySerializer(new StringRedisSerializer());
                    redisTemplate.setHashValueSerializer(new GenericJackson2JsonRedisSerializer());
                    
                    redisTemplate.afterPropertiesSet();
                    
                    return redisTemplate;
                }
            }
            ```

        - SwaggerConfig

          - ```java
            @Configuration
            @EnableSwagger2
            public class SwaggerConfig {
                @Value("${spring.swagger2.enabled}")
                private Boolean enabled;
                
                @Bean
                public Docket createRestApi() {
                    return new Docket(DocumentationType.SWAGGER_2)
                        .apiInfo(apiInfo())
                        .enable(enabled)
                        .select()
                        .apis(RequestHandlerSelectors.basePackage("com.atguigu.redis7")) // 你自己的 package
                        .paths(PathSelectors.any())
                        .build();
                }
                
                public ApiInfo apiInfo() {
                    return new ApiInfoBuilder()
                        .title("springboot 利用 swagger2 构建 api 接口文档 " + "\t" + DateTimeFormatter.ofPattern("yyyy-MM-dd").format(LocalDateTime.now()))
                        .description("springboot + redis 整合，有问题给管理员阳哥邮件：zzyybs@126.com")
                        .version("1.0")
                        .termsOfServiceUrl("https://www.atguigu.com/")
                        .build();
                }
            }
            ```

      - service

      - controller

    - 测试

      - swagger
        - http://localhost:7777/swagger-ui.html#/
      - 序列化问题

  - 其它 api 调用命令，课堂时间有限，恳请各位一定自己多动手练习（家庭作业）

- 连接集群

# P97 springboot 整合 redis 之 RedisTemplate - 下集

序列化问题

- 键（Key）和值（Value）都是通过 Spring 提供的 Serializer 序列化到数据库的。

  RedisTemplate 默认使用的是 JdkSerializationRedisSerializer，StringRedisTemplate 默认使用的是 StringRedisSerializer, KEY 被序列化成这样，线上通过 KEY 去查询对应的 VALUE 非常不方便

- why

  - RedisTemplate.java -> defaultSerializer、stringSerializer
  - JDK 序列化方式（默认）惹的祸
    - JDK 序列化方式（默认）org.springframework.data.redis.serializer.JdkSerializationRedisSerializer，默认情况下，RedisTemplate 使用该数据列化方式，我们来看下源码 RedisTemplate#afterPropertiesSet()

# P98 springboot 整合 redis 之连接集群 - 上集

连接集群

- 启动 redis 集群 6 台实例

- 第一次改写 YML

  - ```properties
    # ===== redis 集群 =====
    spring.redis.password=111111
    # 获取失败最大重定向次数
    spring.redis.cluster.max-redirects=3
    spring.redis.lettuce.pool.max-active=8
    spring.redis.lettuce.pool.max-wait=-1ms
    spring.redis.lettuce.pool.max-idle=8
    spring.redis.lettuce.pool.min-idle=0
    
    spring.redis.cluster.nodes=192.168.111.175:6381,192.168.111.175:6382,192.168.111.172:6383,192.168.111.172:6384,192.168.111.174:6385,192.168.111.174:6386
    ```

- 直接通过微服务访问 redis 集群

  - 一切 OK

- 问题来了

  - 人为模拟，master-6381 机器意外宕机，手动 shutdown
  - 先对 redis 集群命令方式，手动验证各种读写命令，看看 6384 是否上位
  - Redis Cluster 集群能自动感知并自动完成主备切换，对应的 slave6384 会被选举为新的 master 节点
  - 微服务客户端再次读写访问试试

# P99 springboot 整合 redis 之连接集群 - 下集

微服务客户端再次读写访问试试

- 故障现象

  - **SpringBoot 客户端没有动态感知到 RedisCluster 的最新集群信息**
  - 经典故障
    - 【故障演练】Redis Cluster 集群部署采用了 3 主 3 从拓扑结构，数据读写访问 master 节点，slave 节点负责备份。当 master 宕机主从切换成功，redis 手动 OK，but 2 个经典故障

- 导致原因

  - SpringBoot 2.X 版本，Redis 默认的连接池采用 Lettuce

    当 Redis 集群节点发生变化后，Lettuce 默认是不会刷新节点拓扑

- 解决方案

  1. 排除 lettuce 采用 jedis（不推荐）

     - 将 `Lettuce` 二方包仲裁掉

       ```xml
       <dependency>
           <groupId>org.springframework.boot</groupId>
           <artifactId>spring-boot-starter-data-redis</artifactId>
           <version>2.3.12.RELEASE</version>
           <exclusions>
               <exclusion>
                   <groupId>io.lettuce</groupId>
                   <artifactId>lettuce-core</artifactId>
               </exclusion>
           </exclusions>
       </dependency>
       ```

       然后，引入 `Jedis` 相关二方包

       ```xml
       <dependency>
           <groupId>redis.clients</groupId>
           <artifactId>jedis</artifactId>
           <version>3.7.0</version>
       </dependency>
       ```

  2. 重写连接工厂实例（极度不推荐）

  3. 刷新节点集群拓扑动态响应

     - 官网

       - > Lettuce 处理 Moved 和 Ask 永久重定向，由于命令重定向，必须刷新节点拓扑视图。而自适应拓扑刷新（Adaptive updates）与定时拓扑刷新（Periodic updates）默认关闭

         解决方案：

         - 调用 RedisClusterClient.reloadPartitions
         - 后台基于时间间隔的周期刷新
         - 后台基于持续的`断开`和`移动、重定向`的自适应更新

- 第二次改写 YML

  - ```properties
    # ===== redis 集群 =====
    spring.redis.password=111111
    # 获取失败最大重定向次数
    spring.redis.cluster.max-redirects=3
    spring.redis.lettuce.pool.max-active=8
    spring.redis.lettuce.pool.max-wait=-1ms
    spring.redis.lettuce.pool.max-idle=8
    spring.redis.lettuce.pool.min-idle=0
    # 支持集群拓扑动态感应刷新，自适应拓扑刷新是否使用所有可用的更新，默认 false 关闭
    spring.redis.lettuce.cluster.refresh.adaptive=true
    # 定时刷新
    spring.redis.lettuce.cluster.refresh.period=2000
    spring.redis.cluster.nodes=192.168.111.175:6381,192.168.111.175:6382,192.168.111.172:6383,192.168.111.172:6384,192.168.111.174:6385,192.168.111.174:6386
    ```

# P100 redis 高级篇之开篇闲聊扯淡

大厂高阶篇

1. Redis 单线程 VS 多线程（入门篇）
2. BigKey
3. 缓存双写一致性之更新策略探讨
4. Redis 与 M'ySQL 数据双写一致性工程落地案例
5. 案例落地实战 bitmap/hyperloglog/GEO
6. 布隆过滤器 BloomFilter
7. 缓存预热 + 缓存雪崩 + 缓存击穿 + 缓存穿透
8. 手写 Redis 分布式锁
9. Redlock 算法和底层源码分析
10. Redis 的缓存过期淘汰策略
11. Redis 经典五大类型源码及底层实现
12. Redis 为什么快？高性能设计之 epoll 和 IO 多路复用深度解析
13. 终章总结

# P101 redis 高级篇之为什么用单线程

1、Redis 单线程 VS 多线程（入门篇）

- 首课很重要，后续深度讲解，避免晕菜，先预习混个耳熟

- 面试题

  - redis 到底是单线程还是多线程？
  - IO 多路复用听说过吗？
  - redis 为什么快？

- Redis 为什么选择单线程？

  - 是什么

    - **这种问法其实并不严谨，为啥这么说呢？**

      Redis 的版本很多 3.x、4.x、6.x，版本不同架构也是不同的，不限定版本问是否单线程也不太严谨。

      1. 版本 3.x，最早版本，也就是大家口口相传的 redis 是单线程，阳哥 2016 年讲解的 redis 就是 3.x 的版本
      2. 版本 4.x，严格意义来说也不是单线程，而是负责处理客户端请求的线程是单线程，但是**开始加了点多线程的东西（异步删除）**。---貌似
      3. 2020年5月版本的 6.0.x 后及 2022 年出的 7.0 版本后，**告别了大家印象中的单线程，用一种全新的多线程来解决问题。--- 实锤**

  - why

    - 厘清一个事实我们通常说，Redis 是单线程究竟何意？

      - Redis 是单线程

        主要是指 Redis 的网络 IO 和键值对读写是由一个线程来完成的，Redis 在处理客户端的请求时包括获取（socket 读）、解析、执行、内容返回（socket 写）等都由一个顺序串行的主线程处理，这就是所谓的“单线程”。这也是 Redis 对外提供键值存储服务的主要流程。

        但 Redis 的其他功能，比如持久化 RDB、AOF、异步删除、集群数据同步等等，其实是由额外的线程执行的。

        Redis 命令工作线程是单线程的，但是，整个 Redis 来说，是多线程的；

    - 请说说演进变化情况？

      - Redis 3.x 单线程时代但性能依旧很快的主要原因

        - 基于内存操作：Redis 的所有数据都存在内存中，因此所有的运算都是内存级别的，所以他的性能比较高；
        - 数据结构简单：Redis 的数据结构是专门设计的，而这些简单的数据结构的查找和操作的时间大部分复杂度都是 O(1)，因此性能比较高；
        - 多路复用和非阻塞 I/O：Redis 使用 I/O 多路复用功能来监听多个 socket 连接客户端，这样就可以使用一个线程连接来处理多个请求，减少线程切换带来的开销，同时也避免了 I/O 阻塞操作
        - 避免上下文切换：因为是单线程模型，因此就避免了不必要的上下文切换和多线程竞争，这就省去了多线程切换带来的时间和性能上的消耗，而且单线程不会导致死锁问题的发生

      - 作者原话，官网证据

        - https://redis.io/docs/getting-started/faq/

          - > **Redis 是单线程的。如何利用多个 CPU/内核？**
            >
            > CPU 并不是您使用 Redis 的瓶颈，因为通常 Redis 要么受内存限制，要么受网络限制。例如，使用在平均 Linux 系统上运行的流水线 Redis 每秒可以发送一百万个请求，因此，如果您的应用程序主要使用 O(N) 或 O(log(N)) 命令，则几乎不会使用过多的 CPU。
            >
            > 但是，为了最大程度地利用 CPU，您可以在同一框中启动多个 Redis 实例，并将它们视为不同的服务器。在某个时候，单个盒子可能还不够，因此，如果您要使用多个 CPU，则可以开始考虑更早地进行分片的某种方法。
            >
            > 您可以在“分区 ”页面中找到有关使用多个 Redis 实例的更多信息。
            >
            > 但是，在 Redis 4.0 中，我们开始使 Redis 具有更多线程。目前，这仅限于在后台删除对象，以及阻止通过 Redis 模块实现的命令。对于将来的版本，计划是使 Redis 越来越线程化。

            他的大体意思是说 Redis 是基于内存操作的，**因此他的瓶颈可能是机器的内存或者网络带宽而并非 CPU**，既然 CPU 不是瓶颈，那么自然就采用单线程的解决方案了，况且使用多线程比较麻烦。**但是在 Redis 4.0 中开始支持多线程了，例如后台删除、备份等功能**。

        - **Redis 4.0 之前**一直采用单线程的主要原因有以下三个

          1. 使用单线程模型是 Redis 的开发和维护更简单，因为单线程模型方便开发和调试
          2. 即使使用单线程模型也并发的处理多客户端的请求，主要使用的是 IO 多路复用和非阻塞 IO
          3. 对于 Redis 系统来说，**主要的性能瓶颈是内存或者网络带宽而并非 CPU**.

- 既然单线程这么好，为什么逐渐又加入了多线程特性？

- redis6/7 的多线程特性和 IO 多路复用入门篇

- Redis 7 默认是否开启了多线程？

- 我还是曾经哪个少年

# P102 redis 高级篇之开始支持多线程和 IO 多路复用首次浅谈

既然单线程这么好，为什么逐渐又加入了多线程特性？

- 单线程也有单线程的苦恼

  - 举个例子

    - 正常情况下使用 del 指令可以很快的删除数据，而当被删除的 key 是一个非常大的对象时，例如包含了成千上万个元素的 hash 集合时，那么 del 指令就会造成 Redis 主线程卡顿。

      **这就是 redis 3.x 单线程时代最经典的故障，大 key 删除的头疼问题，**由于 redis 是单线程的，del bigKey ... 等待很久这个线程才会释放，类似加了一个 synchronized 锁，你可以想象高并发下，程序堵成什么样子？

- 如何解决

  - 使用惰性删除可以有效的避免 Redis 卡顿的问题

  - 案例

    - 比如当我（Redis）需要删除一个很大的数据时，因为是单线程原子命令操作，这就会导致 Redis 服务卡顿。于是在 Redis 4.0 中就新增了多线程的模块，当然此版本中的多线程主要是为了解决删除数据效率比较低的问题的。

      ```
      unlink key
      flushdb async
      flushall async
      ```

      把删除工作交给了后台的小弟（子线程）异步来删除数据了。

      因为 Redis 是单个主线程处理，redis 之父 antirez 一直强调“Lazy Redis is better Redis”。

      而 lazy free 的本质就是把某些 cost（主要时间复制度，占用主线程 cpu 时间片）较高删除操作，从 redis 主线程剥离让 bio 子线程来处理，极大地减小主线阻塞时间。从而减少删除导致性能和稳定性问题。

  - 在 Redis 4.0 就引入了多个线程来实现数据的异步惰性删除等功能，但是其处理读写请求的仍然只有一个线程，所以仍然算是狭义上的单线程。

redis6/7 的多线程特性和 IO 多路复用入门篇

- 对于 Redis **主要的性能瓶颈是内存或者网络带宽而并非 CPU。**

- 第一次听

  - 听不懂没关系，阳哥故意的，先混个耳熟，后续大招先给我预热

- 最后 Redis 的瓶颈可以初步定为：网络 IO

  - redis 6/7，真正多线程登场

    - **在 Redis 6/7 中，非常受关注的第一个新特性就是多线程**。

      这是因为，Redis 一直被大家熟知的就是它的单线程架构，虽然有些命令操作可以用后台线程或子进程执行（比如数据删除、快照生成、AOF 重写）。但是，从网络 IO 处理到实际的读写命令处理，都是由单个线程完成的。

      随着网络硬件的性能提升，Redis 的性能瓶颈有时会出现在网络 IO 的处理上，也就是说，单个主线程处理网络请求的速度跟不上底层网络硬件的速度

      为了应对这个问题：

      **采用多个 IO 线程来处理网络请求，提高网络请求处理的并行度，Redis 6/7 就是采用的这种方法**。

      但是，Redis 的多 IO 线程只是用来处理网络请求的，**对于读写操作命令 Redis 仍然使用单线程来处理**。这是因为，Redis 处理请求时，网络处理经常是瓶颈，通过多个 IO 线程并行处理网络操作，可以提升实例的整体处理性能。而继续使用单线程执行命令操作，就不用为了保证 Lua 脚本、事务的原子性，额外开发多线程**互斥加锁机制了（不管加锁操作处理）**，这样一来，Redis 线程模型实现就简单了。

  - 主线程和 IO 线程是怎么协作完成请求处理的-精讲版

    - 四个阶段

      - ```mermaid
        graph TB
        subgraph 主线程
        	m1(接收建立连接请求, 获取 Socket) --> m2(将 Socket 放入全局等待队列)
            m2 --> m3(以轮询方式将 Socket 连接分配给 IO 线程)
            m3 --> m4(主线程阻塞, 等待 IO 线程完成请求读取和解析)
            m5(执行请求的命令操作) --> m6(请求的命令操作执行完成)
            m6 --> m7(将结果数据写入缓冲区)
            m7 --> m8(主线程阻塞, 等待 IO 线程完成数据回写 Socket)
            m9(清空等待队列, 等待后续请求)
        end
        
        subgraph IO线程
        	io1(将 Socket 和线程绑定) --> io2(读取 Socket 中的请求并解析)
        	io2 --> io3(请求解析完成)
        	io4(将结果数据回写 Socket) --> io5(Socket 回写完成)
        end
        
        m3 --IO 线程开始执行--> io1
        io3 --主线程开始执行--> m5
        m8 --IO 线程开始执行--> io4
        io5 --主线程开始执行--> m9
        ```

      - **阶段一：服务端和客户端建立 Socket 连接，并分配处理线程**

        首先，主线程负责接收建立连接请求。当有客户端请求和实例建立 Socket 连接时，主线程会创建和客户端的连接，并把 Socket 放入全局等待队列中。紧接着，主线程通过轮询方法把 Socket 连接分配给 IO 线程。

        **阶段二：IO 线程读取并解析请求**

        主线程一旦把 Socket 分配给 IO 线程，就会进入阻塞状态，等待 IO 线程完成客户端请求读取和解析。因为有多个 IO 线程在并行处理。所以，这个过程很快就可以完成。

        **阶段三：主线程执行请求操作**

        等到 IO 线程解析完请求，主线程还是会以单线程的方式执行这些命令操作。

        **阶段四：IO 线程回写 Socket 和主线程清空全局队列**

        当主线程执行完请求操作后，会把需要返回的结果写入缓冲区，然后，主线程会阻塞等待 IO 线程，把这些结果回写到 Socket 中，并返回给客户端。和 IO 线程读取和解析请求一样，IO 线程回写 Socket 时，也是有多个线程在并发执行，所以回写 Socket 的速度也很快。等到 IO 线程回写 Socket 完毕，主线程会清空全局队列，等待客户端和后续请求。

- Unix 网络编程中的五种 IO 模型

  - Blocking IO - 阻塞 IO

  - NoneBlocking IO - 非阻塞 IO

  - IO multiplexing - IO 多路复用

    - Linux 世界一切皆文件

      - 文件描述符、简称 FD，句柄
      - FileDescriptor
        - 文件描述符（File descriptor）是计算机科学中的一个术语，是一个用于表述指向文件的引用的抽象化概念。文件描述符在形式上是一个非负整数。实际上，它是一个索引值，指向内核为每一个进程所维护的该进程打开文件的记录表。当程序打开一个现有文件或者创建一个新文件时，内核向进程返回一个文件描述符。在程序设计中，文件描述符这一概念往往只适用于 UNIX、Linux 这样的操作系统。

    - 首次浅谈 IO 多路复用，IO 多路复用是什么

      - 一种同步的 IO 模型，实现**一个线程**监视**多个文件句柄**，**一旦某个文件句柄就绪**就能通知到对应应用程序进行相应的读写操作，**没有文件句柄就绪时**就会阻塞应用程序，从而释放 CPU 资源
      - 概念
        - I/O：网络 I/O，尤其在操作系统层面指数据在内核态和用户态之间的读写操作
        - 多路：多个客户端连接（连接就是套接字描述符，即 socket 或者 channel）
        - 复用：复用一个或几个线程
        - IO 多路复用
          - 也就是说一个或一组线程处理多个 TCP 连接，使用单进程就能够实现同时处理多个客户端的连接，**无需创建或者维护过多的进程/线程**
        - 一句话
          - 一个服务端进程可以同时处理多个套接字描述符。
          - 实现 IO 多路复用的模型有 3 种：可以分 select -> poll -> epoll 三个阶段来描述。

    - 场景体验，说人话引出 epoll

      - 场景解析

        - 模拟一个 tcp 服务器处理 30 个客户 socket

          假设你是一个监考老师，让 30 个学生解答一道竞赛考题，然后负责验收学生答卷，你有下面几个选择：

          **第一种选择（轮询）**：按顺序逐个验收，先验收 A，然后是 B，之后是 C、D……这中间如果有一个学生卡住，全班都会被耽误，你用循环挨个处理 socket，根本不具有并发能力。

          **第二种选择（来一个 new 一个，1 对 1 服务）**：你创建 30 个分身线程，每个分身线程检查一个学生的答案是否正确。这种类似于为每一个用户创建一个进程或者线程处理连接。

          **第三种选择（响应式处理，1 对多服务）**。你站在讲台上等，谁解答完谁举手。这时 C、D 举手，表示他们解答问题完毕。你下去依次检查 C、D 的答案，然后继续回到讲台上等。此时 E、A 又举手，然后去处理 E 和 A……这种就是 IO 复用模型。Linux 下的 select、poll 和 epoll 就是干这个的。

      - IO 多路复用模型，简单明了版理解

        - 将用户 socket 对应的文件描述符（FileDescriptor）注册进 epoll，然后 epoll 帮你监听哪些 socket 上有消息到达，这样就避免了大量的无用操作。此时的 socket 应该采用**非阻塞模式**。这样，整个过程只在调用 select、poll、epoll 这些调用的时候才会阻塞，收发客户消息是不会阻塞的，整个进程或者线程就被充分利用起来，这就是事件驱动，所谓的 reactor 反应模式。

          **在单个线程通过记录跟踪每一个 Socket（I/O 流）的状态来同时管理多个 I/O 流**，一个服务端进程可以同时处理多个套接字描述符。目的是尽量多的提高服务器的吞吐能力。

          大家都用过 nginx，nginx 使用 epoll 接收请求，nginx 会有很多链接进来，epoll 会把他们都监视起来，然后像拨开关一样，谁有数据就拨向谁，然后调用相应的代码处理。redis 类似同理，这就是 IO 多路复用原理，有请求就响应，没请求不打扰。

    - 小总结

      - 只使用一个服务端进程可以同时处理多个套接字描述符连接

        - 客户端请求服务端时，实际就是在服务端的 Socket 文件中写入客户端对应的文件描述符（FileDescriptor），如果有多个客户端同时请求服务端，为每次请求分配一个线程，类似每次来都 new 一个，如此就会比较耗费服务器资源……

          因此，我们只使用一个线程来监听多个文件描述符，这就是 IO 多路复用

          **采用多路 I/O 复用技术可以让单个线程高效的处理多个连接请求一个服务器进程可以同时处理多个套接字描述符。**

    - 面试题：redis 为什么这么快

      - 备注：IO 多路复用 + epoll 函数使用，才是 redis 为什么这么快的直接原因，而不是仅仅单线程命令 + redis 安装在内存中。

  - signal driven IO - 信号驱动 IO

  - asynchronous IO - 异步 IO

- 简单说明

  - **Redis 工作线程是单线程的，但是，整个 Redis 来说，是多线程的**

  - 主线程和 IO 线程是怎么协作完成请求处理的-精简版

    - I/O 的读和写本身是堵塞的，比如当 socket 中有数据时，Redis 会通过调用先将数据从内核态空间拷贝到用户态空间，再交给 Redis 调用，而这个拷贝的过程就是阻塞的，当数据量越大时拷贝所需要的时间就越多，而这些操作都是基于单线程完成的。

    - Redis 采用 Reactor 模式的网络模型，对于一个客户端请求，主线程负责一个完整的处理过程：

      读取 socket -> 解析请求 -> 执行操作 -> 写入 socket

    - 从 Redis 6 开始，就新增了多线程的功能来提高 I/O 的读写性能，他的主要实现思路是将**主线程的 IO 读写任务拆分给一组独立的线程去执行**，这样就可以使多个 socket 的读写可以并行化了，**采用多路 I/O 复用技术可以让单个线程高效的处理多个连接请求**（尽量减少网络 I/O 的时间消耗），**将最耗时的 Socket 的读取、请求解析、写入单独外包出去**，剩下的命令执行仍然由主线程串行执行并和内存的数据交互。

    - （其它都是多个 IO 线程）读取 socket -> 解析请求 -> 执行操作（主线程） -> 写入 socket

    - 结合上图可知，网络 IO 操作就变成多线程化了，其它核心部分仍然是线程安全的，是个不错的折中办法。

  - 结论

    - Redis 6-7 将网络数据读写、请求协议解析通过多个 IO 线程的来处理

      对于真正的命令执行来说，仍然使用主线程操作，一举两得，便宜占尽！！！

      Redis 6.0 多线程（鱼和熊掌兼得）-> 多个 IO 线程解决网络 IO 问题（多线程红利）、单个工作线程保证线程安全 高性能（单线程红利）

# P103 redis 高级篇之开启多线程 IO 特性支持

Redis 7 默认是否开启了多线程？

- 如果你在实际应用中，发现 Redis 实例的 **CPU 开销不大但吞吐量却没有提升**，可以考虑使用 Redis 7 的多线程机制，加速网络处理，进而提升实例的吞吐量

  - Redis 7 将所有数据放在内存中，内存的响应时长大约为 100 纳秒，对于小数据包，Redis 服务器可以处理 8W 到 10W 的 QPS，这也是 Redis 处理的极限了，**对于 80% 的公司来说，单线程的 Redis 已经足够使用了。**

  - 在 Redis 6.0 及 7 后，**多线程机制默认是关闭的**，如果需要使用多线程功能，需要在 redis.conf 中完成两个设置

    ```
    # io-threads 4
    # io-threads-do-reads no
    ```

    1. 设置 io-threads-do-reads 配置项为 yes，表示启动多线程。
    2. 设置线程个数。关于线程数的设置，官方的建议是如果为 4 核的 CPU，建议线程数设置为 2 或 3，**如果为 8 核 CPU 建议线程数设置为 6，**线程数一定要小于机器核数，线程数并不是越大越好。

我还是曾经那个少年

- Redis 自身出道就是优秀，基于内存操作、数据结构简单、多路复用和非阻塞 I/O、避免了不必要的线程上下文切换等特性，在单线程的环境下依然很快；

  但对于大数据的 key 删除还是卡顿厉害，因此在 Redis 4.0 引入了多线程 unlink key/flushall async 等命令，主要用于 Redis 数据的异步删除；

  而在 Redis 6/7 中引入了 I/O 多线程的读写，这样就可以更加高效的处理更多的任务了，**Redis 只是将 I/O 读写变成了多线程**，而**命令的执行依旧是由主线程串行执行的**，因此在多线程下操作 Redis 不会出现线程安全的问题。

  **Redis 无论是当初的单线程设计，还是如今与当初设计相背的多线程，目的只有一个：让 Redis 变得越来越快**。

  所以 Redis 依旧没变，他还是那个曾经的少年，哈哈~

# P104 redis 高级篇之 BigKey 大厂面试题概览

2、BigKey

- 面试题
  - 阿里广告平台，海量数据里查询某一固定前缀的 key
  - 小红书，你如何生产上限制 keys * /flushdb/flushall 等危险命令以防止误删误用？
  - 美团，MEMORY USAGE 命令你用过吗？
  - BigKey 问题，多大算 big？你如何发现？如何删除？如何处理？
  - BigKey 你做过调优吗？惰性释放 lazyfree 了解过吗？
  - Morekey 问题，生产上 redis 数据库有 1000W 记录，你如何遍历？key * 可以吗？
- MoreKey 案例
- BigKey 案例
- BigKey 生产调优

# P105 redis 高级篇之 BigKey 100W 记录案例和生产故障

MoreKey 案例

- 大批量往 redis 里面插入 2000W 测试数据 key

  - Linux Bash 下面执行，插入 100W

    - ```bash
      # 生成 100W 条 redis 批量设置 kv 的语句（key=kn, value=vn）写入到 /tmp 目录下的 redisTest.txt 文件中
      for((i=1;i<=100*10000;i++)); do echo "set k$i v$i" >> /tmp/redisTest.txt ;done;
      ```

  - 通过 redis 提高的管道 --pipe 命令插入 100W 大批量数据

    - 结合自己机器的地址

      ```shell
      cat /tmp/redisTest.txt | /opt/redis-7.0.0/src/redis-cli -h 127.0.0.1 -p 6379 -a 111111 --pipe
      redis-cli -a 111111 dbsize
      ```

      100w 数据插入 redis 花费 5.8 秒左右

- 某快递巨头真实生产案例新闻

  - 新闻

    - 对 Redis 稍微有点使用经验的人都知道线上是不能执行 keys * 相关命令的，虽然其模糊匹配功能使用非常方便也很强大，在小数据量情况下使用没什么问题，数据量大会导致 Redis 锁住及 CPU 飙升，在生产环境建议禁用或者重命名！

  - keys * 你试试 100W 花费多少秒遍历查询

    - keys * （34.74s） flushdb (2.16s)

    - keys * 这个指令有致命的弊端，在实际环境中最好不要使用

      > 这个指令没有 offset、limit 参数，是要一次性吐出所有满足条件的 key，由于 redis 是单线程的，其所有操作都是原子的，而 keys 算法是遍历算法，复杂度是 O(n)，如果实例中有千万级以上的 key，这个指令就会导致 Redis 服务卡顿，所有读写 Redis 的其它的指令都会被延后甚至会超时报错，可能会引起缓存雪崩甚至数据库宕机

  - 生产上限制 keys */flushdb/flushall 等危险命令以防止误删误用？

    - 通过配置设置禁用这些命令，redis.conf 在 SECURITY 这一项中

      - ```
        rename-command keys ""
        rename-command flushdb ""
        rename-command flushall ""
        ```

- 不用 keys * 避免卡顿，那该用什么

  - scan 命令登场

    - 一句话，类似 mysql limit 的**但不完全相同**

  - Scan 命令用于迭代数据库中的数据库键

    - 语法

      - SCAN cursor [MATCH pattern] [COUNT count]

        基于游标的迭代器，需要基于上一次的游标延续之前的迭代过程

        以 0 作为游标开始一次新的迭代，直到命令返回游标 0 完成一次遍历

        不保证每次执行都返回某个给定数量的元素，支持模糊查询

        一次返回的数量不可控，只能是大概率符合 count 参数

    - 特点

      - redis Scan 命令基本语法如下：

        SCAN cursor [MATCH pattern] [COUNT count]

        - cursor - 游标
        - pattern - 匹配的模式
        - count - 指定从数据集里返回多少元素，默认值为 10

        SCAN 命令是一个基于游标的迭代器，每次被调用之后，都会向用户返回一个新的游标，**用户在下次迭代时需要使用这个新游标作为 SCAN 命令的游标参数**，以此来延续之前的迭代过程。

        SCAN 返回一个包含**两个元素的数组**，第一个元素是用于进行下一次迭代的新游标，第二个元素则是一个数组，这个数组中包含了所有被迭代的元素。**如果新游标返回零表示迭代已结束。**

        SCAN 的遍历顺序**非常特别，它不是从第一维数组的第零位一直遍历到末尾，而是采用了高位进位加法来遍历。之所以使用这样特殊的方式进行遍历，是考虑到字典的扩容和缩容时避免槽位的遍历重复和遗漏**

    - 使用

      - ```
        127.0.0.1:6379> keys *
        1) "db_number"
        2) "key1"
        3) "myKey"
        127.0.0.1:6379> scan 0 MATCH * COUNT 1
        1) "2"
        2) 1) "db_number"
        127.0.0.1:6379> scan 2 MATCH * COUNT 1
        1) "1"
        2) 1) "myKey"
        127.0.0.1:6379> scan 1 MATCH * COUNT 1
        1) "3"
        2) 1) "key1"
        127.0.0.1:6379> scan 3 MATCH * COUNT 1
        1) "0"
        2) (empty list or set)
        ```

# P106 redis 高级篇之 BigKey 发现删除优化策略_1

BigKey 案例

- 多大算 Big

  - 参考《阿里云 Redis 开发规范》

    - 【强制】：拒绝 bigkey（防止网卡流量、慢查询）

      string 类型控制在 10KB 以内，hash、list、set、zset 元素个数不要超过 5000.

      反例：一个包含 200 万个元素的 list

      非字符串的 bigkey，不要使用 del 删除，使用 hscan、sscan、zscan 方式渐进式删除，同时要注意防止 bigkey 过期时间自动删除问题（例如一个 200 万的 zset 设置 1 小时过期，会触发 del 操作，造成阻塞，而且该操作不会出现在慢查询中（lantency 可查））

  - string 和二级结构

    - string 是 value，最大 512MB 但是 >= 10KB 就是 bigkey
    - list、hash、set 和 zset，个数超过 5000 就是 bigkey
      - 疑问？？？
        - list
          - 一个列表最多可以包含 2^32-1 个元素（4294967295，每个列表超过 40 亿个元素）。
        - hash
          - Redis 中每个 hash 可以存储 2^32 - 1 键值对（40 多亿）
        - set
          - 集合中最大的成员数为 2^32 - 1（4294967295，每个集合可存储 40 多亿个成员）。
        - ...

- 哪些危害

  - 内存不均，集群迁移困难
  - 超时删除，大 key 删除作梗
  - 网络流量阻塞

- 如何产生

  - 社交类
    - 王心凌粉丝列表，典型案例粉丝逐步递增
  - 汇总统计
    - 某个报表，月日年经年累月的积累

- 如何发现

  - redis-cli --bigkeys

    - **好处，见最下面总结**

      给出每种数据结构 Top 1 bigkey，同时给出每种数据类型的键值个数 + 平均大小

      **不足**

      想查询大于 10kb 的所有 key，--bigkeys 参数就无能为力了，需要用到 memory usage 来计算每个键值的字节数

      redis-cli --bigkeys -a 111111

      redis-cli -h 127.0.0.1 -p 6379 -a 111111 -bigkeys

      每隔 100 条 scan 指令就会休眠 0.1s，ops 就不会剧烈抬升，但是扫描的时间会变长

      redis-cli -h 127.0.0.1 -p 7001 --bigkeys -i 0.1

  - MEMORY USAGE 键

    - 计算每个键值的字节数
    - 官网

- 如何删除

  - 参考《阿里云 Redis 开发规范》

    - 【强制】：拒绝 bigkey（防止网卡流量、慢查询）

      string 类型控制在 10KB 以内，hash、list、set、zset 元素个数不要超过 5000.

      反例：一个包含 200 万个元素的 list

      非字符串的 bigkey，不要使用 del 删除，使用 hscan、sscan、zscan 方式渐进式删除，同时要注意防止 bigkey 过期时间自动删除问题（例如一个 200 万的 zset 设置 1 小时过期，会触发 del 操作，造成阻塞，而且该操作不会出现在慢查询中（lantency 可查））

  - 官网

  - 普通命令

    - String

      - 一般用 del，如果过于庞大 unlink

    - hash

      - 使用 hscan 每次获取少量 field-value，再使用 hdel 删除每个 field

      - 命令

        - Redis HSCAN 命令会用于迭代哈希表中的键值对

          **语法**

          redis HSCAN 命令基本语法如下：

          HSCAN key cursor [MATCH pattern] [COUNT count]

          - cursor - 游标
          - pattern - 匹配的模式
          - count - 指定从数据集里返回多少元素，默认值为 10

          **可用版本**

          大于等于 2.8.0

          **返回值**

          返回的每个元素都是一个元组，每一个元组元素由一个字段（field）和值（value）组成

      - 阿里手册

        - 1、Hash 删除：hsan + hdel

          ```java
          public void delBigHash(String host, int port, String password, String bigHashKey) {
              Jedis jedis = new Jedis(host, port);
              if (password != null && !"".equals(password)) {
                  jedis.auth(password);
              }
              ScanParams scanParams = new ScanParams().count(100);
              String cursor = "0";
              do {
                  ScanResult<Entry<String, String>> scanResult = jedis.hscan(bigHashKey, cursor, scanParams);
                  List<Entry<String, String>> entryList = scanResult.getResult();
                  if (entryList != null && !entryList.isEmpty()) {
                      for (Entry<String, String> entry : entryList) {
                          jedis.hdel(bigHashKey, entry.getKey());
                      }
                  }
                  cursor = scanResult.getStringCursor();
              } while (!"0".equals(cursor));
              
              // 删除 bigkey
              jedis.del(bigHashKey);
          }
          ```

    - list

      - 使用 ltrim 渐进式逐步删除，直到全部删除完成

      - 命令

        - Redis Ltrim 对一个列表进行修剪（trim），就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除。

          下标 0 表示列表的第一个元素，以 1 表示列表的第二个元素，以此类推。你也可以使用负数下标，以 -1 表示列表的最后一个元素，-2 表示列表的倒数第二个元素，以此类推。

          **语法**

          redis Ltrim 命令基本语法如下：

          LTRIM KEY_NAME START STOP

          **可用版本**

          大于等于 1.0.0

          **返回值**

          命令执行成功时，返回 ok

      - 阿里手册

        - 2、List 删除：ltrim

          ```java
          public void delBigList(String host, int port, String password, String bigListKey) {
              Jedis jedis = new Jedis(host, port);
              if (password != null && !"".equals(password)) {
                  jedis.auth(password);
              }
              long llen =  jedis.llen(bigListKey);
              int counter = 0;
              int left = 100;
              while (counter < llen) {
                  // 每次从左侧截掉 100 个
                  jedis.ltrim(bigListKey, left, llen);
                  counter += left;
              }
              // 最终删除 key
              jedis.del(bigListKey);
          }
          ```

    - set

      - 使用 sscan 每次获取部分元素，再使用 srem 命令删除每个元素

      - 命令

      - 阿里手册

        - 3、Set 删除：sscan + srem

          ```java
          public void delBigSet(String host, int port, String password, String bigSetKey) {
              Jedis jedis = new Jedis(host, port);
              if (password != null && !"".equals(password)) {
                  jedis.auth(password);
              }
              ScanParams scanParams = new ScanParams().count(100);
              String cursor = "0";
              do {
                  ScanResult<String> scanResult = jedis.sscan(bigSetKey, cursor, scanParams);
                  List<String> memberList = scanResult.getResult();
                  if (memberList != null && !memberList.isEmpty()) {
                      for (String member : memberList) {
                          jedis.srem(bigSetKey, member);
                      }
                  }
                  cursor = scanResult.getStringCursor();
              } while (!"0".equals(cursor));
              
              // 删除 bigkey
              jedis.del(bigHashKey);
          }
          ```

    - zset

      - 使用 zscan 每次获取部分元素，再使用 ZREMRANGEBYRANK 命令删除每个元素

      - 命令

      - 阿里手册

        - ```java
          public void delBigZset(String host, int port, String password, String bigZsetKey) {
              Jedis jedis = new Jedis(host, port);
              if (password != null && !"".equals(password)) {
                  jedis.auth(password);
              }
              ScanParams scanParams = new ScanParams().count(100);
              String cursor = "0";
              do {
                  ScanResult<Tuple> scanResult = jedis.zscan(bigZsetKey, cursor, scanParams);
                  List<Tuple> tupleList = scanResult.getResult();
                  if (tupleList != null && !tupleList.isEmpty()) {
                      for (Tuple tuple : tupleList) {
                          jedis.srem(bigZsetKey, tuple.getElement());
                      }
                  }
                  cursor = scanResult.getStringCursor();
              } while (!"0".equals(cursor));
              
              // 删除 bigkey
              jedis.del(bigHashKey);
          }
          ```

BigKey 生产调优

- redis.conf 配置文件 LAZY FREEING 相关说明

  - 阻塞和非阻塞删除命令

    - Redis 有两个原语来删除键。一种称为 DEL，是对象的阻塞删除。这意味着服务器停止处理新命令，以便以同步方式回收与对象关联的所有内存。如果删除的键与一个小对象相关联的所有内存。如果删除的键与一个小对象相关联，则执行 DEL 命令所需的时间非常短，可与大多数其它命令相媲美

      Redis 中的 O(1) 或 O(log_N) 命令。但是，如果键与包含数百万个元素的聚合值相关联，则服务器可能会阻塞很长时间（甚至几秒钟）才能完成操作。

      基于上述原因，Redis 还提供了非阻塞删除原语，例如 UNLINK（非阻塞 DEL）以及 FLUSHALL 和 FLUSHDB 命令的 ASYNC 选项，以便在后台回收内存。这些命令在恒定时间内执行。另一个线程将尽可能快地逐步释放后台中的对象。

      FLUSHALL 和 FLUSHDB 的 DEL、UNLINK 和 ASYNC 选项是用户控制的。这取决于应用程序的设计，以了解何时使用其中一个是个好主意。然而，作为其它操作的副作用，Redis 服务器有时不得不删除键或刷新整个数据库。具体而言，Redis 在以下场景中独立于用户调用删除对象

  - 优化配置

    - ```
      lazyfree-lazy-server-del no 改为 Yes
      replica-lazy-flush no 改为 Yes
      
      lazyfree-lazy-user-del no 改为 Yes
      ```

# P107 redis 高级篇之缓存双写一致性面试题概览

2、缓存双写一致性之更新策略探讨

- 反馈回来的面试题

  - 一图

    - 通用查询方法三部曲

      1 OK，直接从 redis 获得并返回

      2 next，redis 无，从 mysql 获得并返回

      3 完成第 2 步同时，讲 mysql 数据回写 redis，两边数据一致

      问题，上面业务逻辑你用 Java 代码如何写

  - 你只要用缓存，就可能会涉及到 redis 缓存与数据库双存储双写，你只要是双写，就一定会有数据一致性的问题，那么你如何解决一致性问题？

  - 双写一致性，你先动缓存 redis 还是数据库 mysql 哪一个？why？

  - **延时双删**你做过吗？会有哪些问题？

  - 有这么一种情况 ，微服务查询 redis 无 mysql 有，为保证数据双写一致性回写 redis 你需要注意什么？**双检加锁**策略你了解过吗？如何尽量避免缓存击穿？

  - redis 和 mysql 双写 100% 会出纰漏，做不到强一致性，你如何保证**最终一致性**？

  - ……

- 缓存双写一致性，谈谈你的理解

- 数据库和缓存一致性的几种更新策略

# P108 redis 高级篇之缓存双写一致性细则要求

缓存双写一致性，谈谈你的理解

- 如果 redis 中**有数据**

  - 需要和数据库中的值相同

- 如果 redis 中**无数据**

  - 数据库中的值要是最新值，且准备回写 redis

- 缓存按照操作来分，细分 2 种

  - 只读缓存
  - 读写缓存
    - 同步直写策略
      - 写数据库后也同步写 redis 缓存，缓存和数据库中的数据一致；
      - 对于读写缓存来说，要想保证缓存和数据库中的数据一致，就要采用同步直写策略
    - 异步缓写策略
      - 正常业务运行中，mysql 数据变动了，但是可以在业务上容许出现一定时间后才作用于 redis，比如仓库、物流系统
      - 异常情况出现了，不得不将失败的动作重新修补，有可能需要借助 kafka 或者 RabbitMQ 等消息中间件，实现重试重写

- 一图代码你如何写

  - 问题》》》？

  - 采用双检加锁策略

    - ```java
      public String get(String key) {
          String value = redis.get(key); // 查询缓存
          if (value != null) {
              // 缓存存在直接返回
              return value;
          } else {
              // 缓存不存在则对方法加锁
              // 假设请求量很大，缓存过期
              synchronized (TestFuture.class) {
                  value = redis.get(key); // 再查一遍 redis
                  if (value != null) {
                      // 查到数据直接返回
                      return value;
                  } else {
                      // 二次查询缓存也不存在，直接查 DB
                      value = dao.get(key);
                      // 数据缓存
                      redis.setnx(key, value, time);
                      // 返回
                      return value;
                  }
              }
          }
      }
      ```

  - Code

数据库和缓存一致性的几种更新策略

- 目的

  - 总之，我们要达到最终一致性！

    - **给缓存设置过期时间，定期清理缓存并回写，是保证最终一致性的解决方案。**

      我们可以对存入缓存的数据设置过期时间，所有的**写操作以数据库为准**，对缓存操作只是尽最大努力即可。也就是说如果数据库写成功，缓存更新失败，那么只要到达过期时间，则后面的读请求自然会从数据库中读取新值然后回填缓存，达到一致性，**切记，要以 mysql 的数据库写入库为准**。

      上述方案和后续落地案例是调研后的主流 + 成熟的做法，但是考虑到各个公司业务系统的差距，**不是 100% 绝对正确，不保证绝对适配全部情况，**请同学们自行酌情选择打法，合适自己的最好。

- 可以停机的情况

  - 挂牌报错，凌晨升级，温馨提示，服务降级
  - 单线程，这样重量级的数据操作最好不要多线程

- 我们讨论 4 种更新策略

  - X 先更新数据库，再更新缓存
  - X 先更新缓存，再更新数据库
  - X 先删除缓存，再更新数据库
  - 先更新数据库，再删除缓存

- 小总结

# P109 redis 高级篇之缓存双写一致性四大策略探讨

我们讨论 4 种更新策略

- X 先更新数据库，再更新缓存

  - 异常问题 1

    1. 先更新 mysql 的某商品的库存，当前商品的库存是 100，更新为 99 个
    2. 先更新 mysql 修改为 99 成功，然后更新 redis
    3. **此时假设异常出现**，更新 redis 失败了，这导致 mysql 里面的库存是 99 而 redis 里面的还是 100.
    4. 上述发生，会让数据库里面和缓存 redis 里面数据不一致，**读到 redis 脏数据**

  - 异常问题 2

    - 【先更新数据库，再更新缓存】，A、B 两个线程发起调用

      【正常逻辑】

      1. A update mysql 100
      2. A update redis 100
      3. B update mysql 80
      4. B update redis 80

      ============

      【异常逻辑】多线程环境下，A、B 两个线程有快有慢，有前有后有并行

      1. A update mysql 100
      2. B update mysql 80
      3. B update redis 80
      4. A update redis 100

      ============

      最终结果，mysql 和 redis 数据不一致，mysql 80，redis 100

- X 先更新缓存，再更新数据库

  - X 不太推荐

    - 业务上一般把 mysql 作为**底单数据库**，保证最后解释

  - 异常问题 2

    - 【先更新数据库，再更新缓存】，A、B 两个线程发起调用

      【正常逻辑】

      1. A update redis 100
      2. A update mysql 100
      3. B update redis 80
      4. B update mysql 80

      ============

      【异常逻辑】多线程环境下，A、B 两个线程有快有慢，有前有后有并行

      1. A update redis 100
      2. B update redis 80
      3. B update mysql 80
      4. A update mysql 100

      ============

      --- mysql 100，redis 80

- X 先删除缓存，再更新数据库

  - 异常问题

    - 步骤分析 1，先删除缓存，再更新数据库

      - （10:40）

        阳哥自己这里写 20 秒，是自己乱写的，表示更新数据库可能失败，实际中不可能，哈哈~

        1 A 线程先成功删除了 redis 里面的数据，然后去更新 mysql，此时 mysql 正在更新中，还没有结束。（比如网络延时）**B 突然出现要来读取缓存数据**。

    - 步骤分析 2，先删除缓存，再更新数据库（13:25）

    - 步骤分析 3，先删除缓存，再更新数据库（14:03）

    - 上面 3 步骤串讲梳理（16:30）

  - 解决方案

    - 采用延时双删策略（20:39）

    - 双删方案面试题

      - 这个删除该休眠多久呢？

        - （22:14）

          **第一种方法：**加百毫秒即可

          **第二种方法：**新启动一个后台监控程序

      - 这种同步淘汰策略，吞吐量降低怎么办？

        - （23:38）

          ```java
          CompletableFuture.supplyAsync(() -> {
              
          }).whenComplete((t, u) -> {
              
          }).exceptionally(e -> {
              
          }).get();
          ```

      - 后续看门狗 WatchDog 源码分析

- 先更新数据库，再删除缓存

  - 异常问题（27:59）

  - 业务指导思想

    - 微软云
    - 我们后面的阿里巴巴 Canal 也是类似的思想
      - 上述的订阅 binlog 程序在 mysql 中有现成的中间件叫 canal，可以完成订阅 binlog 日志的功能。

  - 解决方案

    - （33:43）

      暂存到消息队列中

      没成功删除，从消息队列中重新读取

      成功删除，从消息队列中去除

      重试超过一定次数，向业务层发送报错信息

  - 类似经典的分布式事务问题，只有一个权威答案

    - 最终一致性
      - 流量充值，先下发短信实际充值可能滞后 5 分钟，可以接受
      - 电商发货，短信下发但是物流明天见

小总结

- 如何选择方案？利弊如何（36:56）
- 一图总结（39:11）

# P110 redis 高级篇之缓存双写一致性工程落地需求和 Canal 简介

4、Redis 与 M'ySQL 数据双写一致性工程落地案例

- 复习 + 面试题（1:43）
  - 采用双检加锁策略（3:11）
- Canal
  - 是什么（8:02）
    - 官网地址
    - 一句话
      - canal，意为水道/管道/沟渠，主要用途是基于数据库增量日志解析，提供增量数据订阅和消费
  - 能干嘛
    - 数据库镜像
    - 数据库实时备份
    - 索引构建和实时维护（拆分异构索引、倒排索引等）
    - 业务 cache 刷新
    - 带业务逻辑的增量数据处理
  - 去哪下
- 工作原理，面试问答
  - 传统 MySQL 主从复制工作原理（13:38）
  - Canal 工作原理（16:09）
- mysql-canal-redis 双写一致性 Coding

# P111 redis 高级篇之缓存双写一致性工程 Canal 落地案例代码

mysql-canal-redis 双写一致性 Coding

- java 案例，来源出处
- mysql
  - 查看 mysql 版本
    - SELECT VERSION()
    - mysql 5.7.28
  - 当前的主机二进制日志
    - show master status;
  - 查看 SHOW VARIABLES LIKE 'log_bin';（4:11）
  - 开启 MySQL 的 binlog 写入功能
    - D:\devSoft\mysql\mysql5.7.28 目录下打开
      - 最好提前备份
      - my.ini（5:07）
  - 重启 mysql
  - 再次查看 SHOW VARIABLES LIKE 'log_bin';（6:51）
  - 授权 canal 连接 MySQL 账号
    - mysql 默认的用户在 mysql 库的 user 表里（7:25）
    - 默认没有 canal 账户，此处新建+授权（8:09）
- canal 服务端
  1. 下载
     - 下载 Linux 版本：canal.deployer-1.1.6.tar.gz
  2. 解压
     - 解压后整体放入 /mycanal 路径下（11:09）
  3. 配置
     - 修改 /mycanal/conf/example 路径下 instance.properties 文件（12:16）
     - instance.properties
       - 换成自己的 mysql 主机 master 的 IP 地址（13:23）
       - 换成自己的在 mysql 新建的 canal 账户（13:32）
  4. 启动
     - /opt/mycanal/bin 路径下执行
       - ./startup.sh
  5. 查看
     - 判断 canal 是否启动成功
       - 查看 server 日志（15:05）
       - 查看样例 example 的日志（16:11）
- canal 客户端（Java 编写业务程序）
  - SQL 脚本（17:13）
  - 建 module
    - canal_demo02
  - 改 POM（18:57）
  - 写 YML（19:42）
  - 主启动（20:34）
  - 业务类
    - RedisUtils（21:43）
    - RedisCanalClientExample（23:28）
    - 题外话
      - java 程序下 connector.subscribe 配置的过滤正则（45:21）
      - 关闭资源代码简写
        - try-with-resources 释放资源（48:09）

# P112 redis 高级篇之大数据统计分析面试题概览

5、案例落地实战 bitmap/hyperloglog/GEO

- 先看看大厂真实需求 + 面试题反馈
  - 面试题1
    - 抖音电商直播，主播介绍的商品有评论，1 个商品对应了 1 系列的评论，排序 + 展现 + 取前 10 条记录
    - 用户在手机 App 上的签到打卡信息：1 天对应 1 系列用户的签到记录，新浪微博、钉钉打卡签到，来没来如何统计？
    - 应用网站上的网页访问信息：1 个网页对应 1 系列的访问点击，淘宝网首页，每天有多少人浏览首页？
    - 你们公司系统上线后，说一下 UV、PV、DAU 分别是多少？
    - ……
  - 面试题2（5:48）
  - 需求痛点
    - 亿级数据的收集 + 清洗 + 统计 + 展现
    - 一句话
      - 存的进 + 取得快 + 多维度
    - 真正有价值的是统计……
- 统计的类型有哪些？
  - 亿级系统中常见的四种统计
    - 聚合统计
      - 统计多个集合元素的聚合结果，就是前面讲解过的**交叉并等集合统计**
      - 复习命令（9:44）
      - 交并差集和聚合函数的应用
    - 排序统计
      - 抖音短视频最新评论留言的场景，请你设计一个展现列表。考察你的数据结构和设计思路
      - 设计案例和回答思路（11:36）
        - answer
          - zset（13:46）
          - 在面对需要展示最新列表、排行榜等场景时，如果数据更新频繁或者需要分页显示，建议使用 ZSet
    - 二值统计
      - 集合元素的取值就只有 0 和 1 两种。在钉钉上班签到打卡的场景中，我们只用记录有签到（1）或没签到（0）
      - 见 bitmap
    - 基数统计
      - 指统计一个集合中**不重复的元素个数**
      - 见 hyperloglog
- hyperloglog
- GEO
- bitmap

# P113 redis 高级篇之大数据统计 UVPVDAU 术语行话

hyperloglog

- 说名词，行话谈资
  - 什么是 UV
    - Unique Visitor，独立访客，一般理解为客户端 IP
    - **需要去重考虑**
  - 什么是 PV
    - Page View，页面浏览量
    - 不用去重
  - 什么是 DAU
    - Daily Active User
      - 日活跃用户量
        - 登陆或者使用了某个产品的用户数（去重复登陆的用户）
      - 常用于反映网站、互联网应用或者网络游戏的运营情况
  - 什么是 MAU
    - Monthly Active User
      - 月活跃用户量
  - 假如上述术语，你不知道？
- 看需求（6:47）
- 是什么（小白篇讲解过，快速复习一下）
  - 基数
    - 是一种数据集，去重复后的真实个数
    - 案例 Case（9:13）
  - 去重复统计功能的基数估计算法-就是 HyperLogLog（9:47）
  - 基数统计
    - 用于统计一个集合中不重复的元素个数，就是对集合去重复后剩余元素的计算
  - 一句话
    - 去重脱水后的真实数据
  - 基本命令（11:26）
- HyperLogLog 如何做的？如何演化出来的？
- 淘宝网站首页亿级 UV 的 Redis 统计方案

# P114 redis 高级篇之大数据统计去重复思路分析和误差率

HyperLogLog 如何做的？如何演化出来的？

- 基数统计就是 HyperLogLog
- 去重复统计你先会想到哪些方式？
  - HashSet
  - bitmap（2:53）
  - 结论
    - 样本元素越多内存消耗急剧增大，难以管控+各种慢，对于亿级统计不太合适，大数据害死人
    - 量变引起质变
  - 办法？
    - 概率算法（7:32）
- **原理说明**
  - **只是进行不重复的基数统计，不是集合也不保存数据，只记录数量而不是具体内容**
  - 有误差
    - Hyperloglog 提供不精确的去重计数方案
    - **牺牲准确率来换取空间，误差仅仅只是 0.81% 左右**
  - 这个误差如何来的？论文地址和出处
    - Redis 之父安特雷兹回答（11:39）

# P115 redis 高级篇之大数据统计 HyperLogLog 案例

淘宝网站首页亿级 UV 的 Redis 统计方案

- 需求
  - UV 的统计需要去重，一个用户一天内的多次访问只能算作一次
  - 淘宝、天猫首页的 UV，平均每天是 1 ~ 1.5 个亿左右
  - 每天存 1.5 个亿的 IP，访问者来了后先去查是否存在，不存在加入
- 方案讨论
  - 用 mysql
    - 傻X，不解释
  - 用 redis 的 hash 结构存储（2:48）
    - 说明（3:10）
  - hyperloglog（4:36）
- HyperLogLogService（12:07）
- HyperLogLogController（13:09）

# P116 redis 高级篇之大数据统计 GEO 附近的 XXX 类型面试题

GEO

- Redis 之 GEO

  - 大厂面试题简介（0:24）

  - 地理知识说明

    - 经纬度（3:30）

  - 如何获得某个地址的经纬度

  - 命令复习，第二次

    - GEOADD 添加经纬度坐标（6:53）

      - 中文乱码如何处理（7:20）

    - GEOPOS 返回经纬度（7:29）

    - GEOHASH 返回坐标的 geohash 表示（8:13）

      - geohash 算法生成的 base32 编码值

      - 3 维变 2 维变 1 维

        - 主要分为三步

          将三维的地球变为二维的坐标

          再将二维的坐标转换为一维的点块

          最后将一维的点块转换为二进制再通过 base32 编码

    - GEODIST 两个位置之间的距离(9:05)

    - GEORADIUS（10:06）

      - 以半径为中心，查找附近的 XXX

    - GEORADIUSBYMEMBER（11:28）

- 美团地图位置附近的酒店推送

# P117 redis 高级篇之大数据统计 GEO 美团 APP 附近的酒店推送案例

美团地图位置附近的酒店推送

- 需求分析
  - 美团 app 附近的酒店（0:28）
  - 摇个妹子，附近的妹子（1:33）
  - 高德地图附近的人或者一公里以内的各种营业厅、加油站、理发店、超市……
  - 找个单车
  - ……
- 架构设计
  - Redis 的新类型 GEO（2:12）
  - 命令
- 编码实现
  - 关键点
    - GEORADIUS
      - 以给定的经纬度为中心，找出某一半径内的元素
    - GeoController
    - GeoService

# P118 redis 高级篇之大数据统计 Bitmap 京东签到送京豆案例

bitmap

- 大厂真实面试题案例
  - 日活统计
  - 连续签到打卡
  - 最近一周的活跃用户
  - 统计指定用户一年之中的登陆天数
  - 某用户按照一年 365 天，哪几天登陆过？哪几天没有登陆？全年中登陆的天数共计多少？
- 是什么（2:44）
  - 一句话
    - 由 0 和 1 状态表现的二进制位的 bit 数组
- 能干嘛
  - 用于状态统计
    - Y、N，类似 AtomicBoolean
  - 看需求
    - 用户是否登陆过 Y、N，比如京东每日签到送京豆
    - 电影、广告是否被点击播放过
    - 钉钉打卡上下班，签到统计
    - ……
- 京东签到领取京豆
  - 需求说明（4:19）
  - 小厂方法，传统 mysql 方式
    - 建表 SQL（6:17）
    - 困难和解决思路（7:18）
  - 大厂方法，基于 Redis 的 Bitmaps 实现签到日历
    - 建表-按位-redis bitmap（8:30）
- 命令复习，第二次（8:56）
  - setbit
    - setbit key offset value
    - setbit 键 偏移位 只能零或者1
    - Bitmap 的偏移量是从零开始算的
  - getbit
    - getbit key offset
  - setbit 和 getbit 案例说明
  - bitmap 的底层编码说明，get 命令操作如何
  - strlen
  - bitcount
  - bitop
- 案例实战见下一章，bitmap 类型签到 + 结合布隆过滤器，案例升级

# P119 redis 高级篇之布隆过滤器面试题简介

6、布隆过滤器面试题简介

- 先看看大厂真实需求 + 面试题反馈
  - 现有 50 亿个电话号码，现有 10 万个电话号码，如何要快速准确的判断这些电话号码**是否已经存在**?（1:35）
  - 判断是否存在，布隆过滤器了解过吗？
  - 安全连接网址，全球数 10 亿的网址判断
  - 黑名单校验，识别垃圾邮件
  - 白名单校验，识别出合法用户进行后续处理
  - ……
- 是什么
- 能干嘛-特点考点
- 布隆过滤器原理
- 布隆过滤器的使用场景
- 尝试手写布隆过滤器，结合 bitmap 自研一下体会思想
- 布隆过滤器优缺点
- 布谷鸟过滤器（了解）

# P120 redis 高级篇之布隆过滤器是什么

是什么

- 一句话
  - 由一个初值都为零的 bit 数组和多个哈希函数构成，用来快速判断集合中是否存在某个元素（0:44）
  - 设计思想（2:18）
    - 本质就是判断具体数据是否存在于一个大的集合中
- 备注
  - 布隆过滤器是一种**类似 set 的**数据结构，只是**统计结果在巨量数据下有点小瑕疵，不够完美**（6:07）

能干嘛-特点考点

- 高效地插入和查询，占用空间少，返回的结果是不确定性+不够完美（8:57）
- 重点
  - 一个元素如果判断结果：存在时，元素不一定存在，但是判断结果为不存在时，则一定不存在。
- 布隆过滤器可以添加元素，但是**不能删除元素**，由于涉及 hashcode 判断依据，删掉元素会导致误判率增加。
- **小总结**
  - 有，是可能有
  - 无，是肯定无
    - 可以保证的是，如果布隆过滤器判断一个元素不在一个集合中，那这个元素一定不会在集合中

布隆过滤器原理

- 布隆过滤器实现原理和数据结构
  - 原理（14:04）
  - 添加 key、查询 key（14:40）
  - hash 冲突导致数据不精准（17:09）
  - hash 冲突导致数据不精准2
    - 哈希函数（21:06）
    - Java 中 hash 冲突 Java 案例
- 使用3步骤
  - 初始化 bitmap（29:24）
  - 添加占坑位（29:44）
  - 判断是否存在（31:21）
- 布隆过滤器误判率，为什么不要删除（33:17）
- **小总结**
  - 是否存在
    - 有，是很可能有
    - 无，是肯定无，100% 无
  - 使用时最好不要让实际元素数量远大于初始化数量，一次给够避免扩容
  - 当实际元素数量超过初始化数量时，应该对布隆过滤器进行重建，重新分配一个 size 更大的过滤器，再将所有的历史元素批量 add 进行

# P121 redis 高级篇之布隆过滤器自研案例和基础代码

布隆过滤器的使用场景

- **解决缓存穿透的问题，和 redis 结合 bitmap 使用**（2:11）
- 黑名单校验，识别垃圾邮件（6:16）
- 安全连接网址，全球上 10 亿的网址判断
- ……

尝试手写布隆过滤器，结合 bitmap 自研一下体会思想

- **结合 bitmap 类型手写一个简单的布隆过滤器，体会设计思想**

- 整体架构（12:50）

- 步骤设计

  - redis 的 setbit/getbit（13:47）
  - setBit 的构建过程
    - @PostConstruct 初始化白名单数据
    - 计算元素的 hash 值
    - 通过上一步 hash 值算出对应的二进制数组的坑位
    - 将对应坑位的值的修改为数字 1，表示存在
  - getBit 查询是否存在
    - 计算元素的 hash 值
    - 通过上一步 hash 值算出对应的二进制数组的坑位
    - 返回对应坑位的值，零表示无，1 表示存在

- springboot + redis + mybatis 案例基础与一键编码环境整合

  - Mybatis 通用 Mapper 4

    - mybatis-generator

    - MyBatis 通用 Mapper4 官网

    - 一键生成

      - t_customer 用户表 SQL（19:32）

      - 建 springboot 的 Module

        - mybatis_generator

      - 改 POM（20:58）

      - 写 YML

        - 无

      - mgb 配置相关 src\main\resources 路径下新建

        - config.properties
          - 内容（21:55）
        - generatorConfig.xml
          - 内容（22:16）

      - 一键生成（25:51）

        - 双击插件 mybatis-generator:generate，一键生成

          生成 entity + mapper 接口 + xml 实现 SQL

  - SpringBoot + Mybatis + Redis 缓存实战编码

    - 建 Module
      - 改造我们的 redis7_study 工程
    - POM（26:59）
    - YML（28:12）
      - \src\main\resources\目录下新建 mapper 文件夹并拷贝 CustomerMapper.xml
    - 主启动（30:09）
    - 业务类
      - 干活
        - 数据库表 t_customer 是否 OK
        - entity
          - 上一步自动生成的拷贝过来 Customer
        - mapper 接口（31:30）
        - mapperSQL 文件（31:36）
        - service 类（41:44）
        - controller（47:03）
    - 启动测试 Swagger 是否 OK

- 新增布隆过滤器案例

# P122 redis 高级篇之布隆过滤器结合 bitmap 手写布隆过滤器和小总结

新增布隆过滤器案例

- code
  - BloomFilterInit（白名单）（7:30）
    - @PostConstruct 初始化白名单数据，故意差异化数据演示效果……
  - CheckUtils（10:40）
  - CustomerService
  - CustomerController
- 测试说明

布隆过滤器的优缺点

- 优点

  - 高效地插入和查询，内存占用 bit 空间少

- 缺点

  - 不能删除元素。

    因为删掉元素会导致误判率增加，因为 hash 冲突同一个位置可能存的东西是多个共有的，你删除一个元素的同时可能也把其它的删除了。

  - 存在误判，不能精准过滤

    - 有，是很可能有
    - 无，是肯定无，100% 无

布谷鸟过滤器（了解）（28:36）

# P123 redis 高级篇之缓存预热雪崩穿透击穿面试题简介

7、缓存预热 + 缓存雪崩 + 缓存击穿 + 缓存穿透

- 先看看大厂真实需求+面试题反馈
  - 缓存预热、雪崩、穿透、击穿分别是什么？你遇到过哪几个情况？
  - 缓存预热你是怎么做的？
  - 如何避免或者减少缓存雪崩？
  - 穿透和击穿有什么区别？它俩是一个意思还是截然不同？
  - 穿透和击穿你有什么解决方案？如何避免？
  - 加入出现了缓存不一致，你有哪些修补方案？
  - ……
- 缓存预热
- 缓存雪崩
- 缓存穿透
- 缓存击穿
- 总结

# P124 redis 高级篇之缓存预热-雪崩-穿透

缓存预热（5:37）

- @PostConstruct 初始化白名单数据

缓存雪崩

- 发生
  - redis 主机挂了，Redis 全盘崩溃，偏硬件运维
  - redis 中有大量 key 同时过期大面积失效，偏软件开发
- 预防 + 解决
  - redis 中 key 设置为永不过期 or 过期时间错开
  - redis 缓存集群实现高可用
    - 主从 + 哨兵
    - Redis Cluster
    - 开启 Redis 持久化机制 aof/rdb，尽快恢复缓存集群
  - 多缓存结合预防雪崩
    - ehcache 本地缓存 + redis 缓存
  - 服务降级
    - Hystrix 或者阿里 sentinel 限流 & 降级（10:03）
  - **人民币玩家**
    - 阿里云-云数据库 Redis 版

缓存穿透

- 是什么
  - 请求去查询一条记录，先查 redis 无，后查 mysql 无，**都查询不到该条记录，**但是请求每次都会打到数据库上去，导致后台数据库压力暴增，这种现象我们称为缓存穿透，这个 redis 变成了一个摆设……
  - 简单说就是本来无一物，两库都没有。既不在 Redis 缓存库，也不在 mysql，数据库存在被多次暴击风险
- 解决
  - 缓存穿透 | 恶意攻击 | 空对象缓存、bloomfilter 过滤器
  - 一图（16:11）
  - 方案1：空对象缓存或者缺省值
    - 一般 OK（17:48）
    - But
      - 黑客或者恶意攻击
        - 黑客会对你的系统进行攻击，拿一个不存在的 id 去查询数据，会产生大量的请求到数据库去查询。可能会导致你的数据库由于压力过大而宕掉
        - key 相同打你系统
          - 第一次打到 mysql，空对象缓存后第二次就返回 defaultNull 缺省值，避免 mysql 被攻击，不用再到数据库中去走一圈了
        - **key 不同打你系统**
          - 由于存在空对象缓存和缓存回写（看自己业务不限死），redis 中的无关紧要的 key 也会越写越多**（记得设置 redis 过期时间）**
  - 方案2：Google 布隆过滤器 Guava 解决缓存穿透

# P125 redis 高级篇之 Guava 版布隆过滤器案例分析和编码

方案2：Google 布隆过滤器 Guava 解决缓存穿透

- Guava 中布隆过滤器的实现算是比较权威的，所以实际项目中我们可以直接使用 Guava 布隆过滤器
- Guava's BloomFilter 源码出处
- 案例：白名单过滤器
  - 白名单架构说明（2:13）
  - 误判问题，但是概览小可以接受，不能从布隆过滤器删除
  - 全部合法的 key 都需要放入 Guava 版布隆过滤器 + redis 里面，不然数据就是返回 null
  - **Coding 实战**
    - 建 Module
      - 修改 redis7_study
    - 改 POM（3:37）
    - 写 YML
    - 主启动
    - 业务类
      - Case01
        - 新建测试案例，hello 入门
      - Case02
        - GuavaBloomFilterController
        - GuavaBloomFilterService
          - 取样本 100W 数据，查查不在 100W 范围内，其它 10W 数据是否存在
          - 上一步结论（22:44）
    - **debug 源码分析下，看看 hash 函数**
    - 布隆过滤器说明（32:49）
- 家庭作业思考题：黑名单使用（36:49）

# P126 redis 高级篇之缓存击穿是什么及危害

缓存击穿

- 是什么
  - 大量的请求同时查询一个 key 时，此时这个 key 正好失效了，就会导致大量的请求都打到数据库上面去
  - **简单说就是热点 key 突然失效了，暴打 mysql**
  - 备注
    - 穿透和击穿，截然不同
- 危害
  - 会造成某一时刻数据库请求量过大，压力剧增
  - 一般技术部门需要知道**热点 key 是那些个**？做到心里有数防止击穿
- 解决
  - 缓存击穿 | 热点 key 失效 | 互斥更新、随机退避、差异失效时间
  - 热点 key 失效
    - 时间到了自然清除但还没被访问到
    - delete 掉的 key，刚巧又被访问
  - 方案1：差异失效时间，对于访问频繁的热点 key，干脆就不设置过期时间
  - **方案2：互斥更新，采用双检加锁策略**（8:20）

# P127 redis 高级篇之天猫聚划算需求分析-设计-编码案例

案例

- 天猫聚划算功能实现 + 防止缓存击穿

- 模拟高并发的天猫聚划算案例 code

  - 是什么

    - 生产案例网址

  - 问题，热点 key 突然失效导致了缓存击穿

  - 技术方案实现

    - 分析过程（6:51）

    - redis 数据类型选型（11:11）

    - springboot + redis 实现高并发的聚划算业务 V2

      - 建 Module

        - 修改 redis7_study

      - 改 POM

        - 无

      - 写 YML

        - 无

      - 主启动

        - 无

      - 业务类

        - entity
        - JHSTaskService
          - 采用定时器将参与聚划算活动的特价商品新增进入 redis 中
        - JHSProductController

      - 备注

        - 至此步骤，上述聚划算的功能算是完成，请思考在高并发下有什么**经典**生产问题？

      - Bug 和隐患说明

        - 热点 key 突然失效导致可怕的缓存击穿（31:41）

          - delete 命令执行的一瞬间有空隙，其它请求线程继续找 Redis 为 null
          - 打到了 mysql，暴击……

        - 复习 again

          - （34:27）

            | 缓存问题     | 产生原因               | 解决方案                               |
            | ------------ | ---------------------- | -------------------------------------- |
            | 缓存更新方式 | 数据变更、缓存时效性   | 同步更新、失效更新、异步更新、定时更新 |
            | 缓存不一致   | 同步更新失败、异步更新 | 增加重试、补偿任务、最终一致           |
            | 缓存穿透     | 恶意攻击               | 空对象缓存、bloomfilter 过滤器         |
            | 缓存击穿     | 热点 key 失效          | 互斥更新、随机退避、差异失效时间       |
            | 缓存雪崩     | 缓存挂掉               | 快速失败熔断、主从模式、集群模式       |

        - 最终目的

          - 2 条命令原子性还是其次，主要是**防止热 key 突然失效暴击 mysql 打爆系统**

      - 进一步升级加固案例

        - **复习，互斥更新，采用双检加锁策略**
        - 差异失效时间（35:55）
        - JHSTaskService
        - JHSProductController

# P128 redis 高级篇之缓存预热雪崩穿透击穿小总结

总结（0:21）

# P129 redis 高级篇之 redis 分布式锁大厂面试题简介

8、手写 Redis 分布式锁

- 粉丝反馈回来的题目
  - Redis 除了拿来做缓存，你还见过基于 Redis 的什么用法？
    - 数据共享，分布式 Session
    - 分布式锁
    - 全局 ID
    - 计算器、点赞
    - 位统计
    - 购物车
    - 轻量级消息队列
      - list
      - stream
    - 抽奖
    - 点赞、签到、打卡
    - 差集交集并集，用户关注、可能认识的人，推荐模型
    - 热点新闻、热搜排行榜
  - Redis 做分布式锁的时候有需要注意的问题？
  - 你们公司自己实现的分布式锁是否用的 setnx 命令实现？这个是最合适的吗？你如何考虑分布式锁的可重入问题？
  - 如果是 Redis 是单点部署的，会带来什么问题？
    - 那你准备怎么解决单点问题呢？
  - Redis 集群模式下，比如主从模式，CAP 方面有没有什么问题呢？
  - 那你简单的介绍一下 Redlock 吧？你简历上写 redisson，你谈谈
  - Redis 分布式锁如何续期？看门狗知道吗？
  - ……
- 锁的种类
- 一个靠谱分布式锁需要具备的条件和刚需
- 分布式锁
- 重点
- Base 案例（boot+redis）
- 手写分布式锁思路分析 2023

# P130 redis 高级篇之 redis 分布式锁是什么及超卖故障

锁的种类

- **单机版同一个 JVM 虚拟机内**，synchronized 或者 Lock 接口
- **分布式多个不同 JVM 虚拟机**，单机的线程锁机制不再起作用，资源类在不同的服务器之间共享了。

一个靠谱分布式锁需要具备的条件和刚需

- 独占性
  - OnlyOne，任何时刻只能有且仅有一个线程持有
- 高可用
  - 若 redis 集群环境下，不能因为某一个节点挂了而出现获取锁和释放锁失败的情况
  - 高并发请求下，依旧性能 OK 好使
- 防死锁
  - 杜绝死锁，必须有超时控制机制或者撤销操作，有个兜底终止跳出方案
- 不乱抢
  - 防止张冠李戴，不能私下 unlock 别人的锁，只能自己加锁自己释放，自己约的锁含着泪也要自己解
- 重入性
  - 同一个节点的同一个线程如果获得锁之后，它也可以再次获取这个锁

**分布式锁**（12：53）

- setnx key value

  - （13：31）

    差评，setnx + expire 不安全，两条命令非原子性的

- **set key value [EX seconds] [PX milliseconds] [NX|XX]**

重点

- JUC 中 AQS 锁的规范落地参考 + 可重入锁考虑 + Lua 脚本 + Redis 命令一步步实现分布式锁

Base 案例（boot + redis）

- 使用场景：
  - 多个服务间保证同一时刻同一时间段内同一用户只能有一个请求（防止关键业务出现并发攻击）
- 建 Module
  - redis_distributed_lock2
  - redis_distributed_lock3
- 改 POM
- 写 YML
- 主启动
- 业务类
  - Swagger2Config
  - RedisConfig
  - InventoryService
  - InventoryController
- swagger

手写分布式锁思路分析 2023

- 大家来找茬
  - 上面测试通过求吐槽
    1. 初始化版本简单添加
       - 业务类
         - InventoryService
         - 请将 7777 的业务逻辑代码原样拷贝到 8888
       - 加了 synchronized 或者 Lock
    2. nginx 分布式微服务架构
       - 问题
         - V2.0 版本代码分布式部署后，单机锁还是出现超卖现象，需要分布式锁
         - Nginx 配置负载均衡
           - 命令地址+配置地址
             - 命令地址
               - /usr/local/nginx/sbin
             - 配置地址
               - /usr/local/nginx/conf
           - 启动
             - /usr/local/nginx/sbin
               - ./nginx
             - 启动 Nginx 并测试通过，浏览器看到 nginx 欢迎 welcome 页面
           - /usr/local/nginx/conf 目录下修改配置文件 nginx.conf 新增反向代理和负载均衡配置（36：39）
           - 关闭
             - /usr/local/nginx/sbin
               - ./nginx -s stop
           - 指定配置启动（35：41）
             - 在 /usr/local/nginx/sbin 路径下执行下面的命令
             - ./nginx -c /usr/local/nginx/conf/nginx.conf
           - 重启
             - /usr/local/nginx/sbin
               - ./nginx -s reload
         - V2.0 版本代码修改 + 启动两个微服务
           - 7777
             - InventoryService
           - 8888
             - InventoryService
           - 通过 Nginx 访问，你的 Linux 服务器地址 IP，反向代理 + 负载均衡
             - 可以点击看到效果，一边一个，默认轮询
         - 上面纯手点验证 OK，下面高并发模拟
           - 线程组 redis
             - 100 个商品足够了
           - http 请求（44：42）
           - jmeter 压测
           - 76 号商品被卖出 2 次，出现超卖故障现象
         - bug-why
           - 为什么加了 synchronized 或者 Lock 还是没有控制住？
           - 解释（45：02）
         - 分布式锁出现
           - 能干嘛
             - 跨进程 + 跨服务
             - 解决超卖
             - 防止缓存击穿
       - 解决
         - 上 redis 分布式锁 setnx（47：32）
         - 官网
    3. redis 分布式锁
    4. 宕机与过期+防止死锁
    5. 防止误删 key 的问题
    6. Lua 保证原子性
    7. 可重入锁+设计模式
    8. 自动续期
  - 总结

# P131 redis 高级篇之 redis 分布式锁迭代编码01

3、Redis 分布式锁

- 修改为 3.1 版
  - 通过递归重试的方式
  - 问题
    - 测试手工 OK，测试 Jmeter 压测 5000 OK
    - 递归是一种思想没错，但是容易导致 StackOverflowError，不太推荐，进一步完善
- 修改为 3.2 版
  - 多线程判断想想 JUC 里面说过的虚假唤醒，用 while 替代 if
  - 用自选替代递归重试

4、宕机与过期+防止死锁

- 当前代码为 3.2 版接上一步
- 问题
  - 部署了微服务的 Java 程序机器挂了，代码层面根本没有走到 finally 这块，没办法保证解锁（无过期时间该 key 一直存在），这个 key 没有被删除，需要加入一个过期时间限定 key
- 解决
  - 修改为 4.1 版（29：00）
  - 4.1 版结论
    - 设置 key + 过期时间分开了，必须要合并成一行具备原子性（29：32）
  - 修改为 4.2 版
    - Jmeter 压测 OK（30：47）
  - 4.2 版结论
    - 加锁和过期时间设置必须同一行，保证原子性

5、防止误删 key 的问题

- 当前代码为 4.2 版接上一步
- 问题
  - 实际业务处理时间如果超过了默认设置 key 的过期时间？？
  - 张冠李戴，删除了别人的锁（35：57）
- 解决
  - 只能自己删除自己的，不许动别人的
  - 修改为 5.0 版（40：19）

6、Lua 保证原子性

- 当前代码为 5.0 版接上一步
- 问题
  - finally 块的判断 + del 删除操作不是原子性的
- 启用 lua 脚本编写 redis 分布式锁判断+删除判断代码
  - lua 脚本（46：48）
  - 官网
    - 官方脚本（52：58）
- Lua 脚本浅谈
- 解决

# P132 redis 高级篇之 redis 分布式锁迭代编码02

Lua 脚本浅谈

- Lua 脚本初识
  - Redis 调用 Lua 脚本通过 eval 命令保证代码执行的原子性，直接用 return 返回脚本执行后的结果值
  - eval luascript numkeys [key [key ...]] [arg [arg ...]]
  - helloworld 入门
    1. hello lua
    2. set k1 v1 get k1
    3. mset
- Lua 脚本进一步
  - Redis 分布式锁 lua 脚本官网练习
  - 条件判断语法（20：14）
  - 条件判断案例（24：56）

解决

- 修改为 6.0 版 code（31：39）
  - bug 说明（31：45）

# P133 redis 高级篇之 redis 分布式锁迭代编码03

7、可重入锁 + 设计模式

- 当前代码为 6.0 版上一步
  - while 判断并自旋重试获取锁+ setnx 含自然过期时间 + Lua 脚本官网删除锁命令
  - 问题
    - 如何兼顾锁的可重入性问题
  - 复习写好一个锁的条件和规约（2：26）
- 可重入锁（又名递归锁）
  - 说明（9：47）
  - “可重入锁”这四个字分开来解释：
    - 可：可以
    - 重：再次
    - 入：进入
    - 锁：同步锁
    - 进入什么
      - 进入同步域（即同步代码块/方法或显式锁锁定的代码）
    - 一句话
      - 一个线程中的多个流程可以获取同一把锁，持有这把同步锁可以再次进入。
      - 自己可以获取自己的内部锁
  - JUC 知识复习，可重入锁出 bug 会如何影响程序
  - 可重入锁种类
    - 隐式锁（即 synchronized 关键字使用的锁）默认是可重入锁（19：43）
      - 同步块（20：21）
      - 同步方法
    - synchronized 的重入的实现机理（26：44）
    - 显式锁（即 Lock）也有 ReentrantLock 这样的可重入锁
- lock/unlock 配合可重入锁进行 AQS 源码分析讲解
  - 切记，一般而言，你 lock 了几次就要 unlock 几次
- 思考，上述可重入锁计数问题，redis 中那个数据类型可以代替
  - K, K, V（36：42）
  - Map<String, Map<Object, Object>>
  - 案例命令（37：05）
  - 小总结
    - setnx，只能解决有无的问题
      - 够用但是不完美
    - hset，不但解决有无，还解决可重入问题
- 思考+设计重点（一横一纵）
- lua 脚本
- 将上述 lua 脚本整合进入微服务 Java 程序
- 可重入性测试重点

# P134 redis 高级篇之 redis 分布式锁迭代编码04

思考+设计重点（一横一纵）

- 目前有 2 条支线，目的是保证同一个时候只能有一个线程持有锁进去 redis 做扣减库存动作
- 2 个分支
  - 保证加锁/解锁，lock/unlock
  - 扣减库存 redis 命令的原子性（1：17）

lua 脚本

- redis 命令过程分析（6：39）
- 加锁 lua 脚本 lock
  - 先判断 redis 分布式锁这个 key 是否存在
    - EXISTS key（7：33）
      - 返回零说明不存在，hset 新建当前线程属于自己的锁 BY UUID:ThreadID（7：48）
      - 返回一说明已经有锁，需进一步判断是不是当前线程自己的
        - HEXISTS key uuid:ThreadID（8：10）
          - 返回零说明不是自己的
          - 返回一说明是自己的锁，自增1次表示重入（8：28）
  - 上述设计修改为 Lua 脚本
    - V1（12：34）
    - V2（16：25）
    - V3（16：50）
  - 测试（19：32）
- 解锁 lua 脚本 unlock
  - 设计思路：有锁且还是自己的锁
    - HEXISTS key uuid:ThreadID（22：54）
      - 返回零，说明根本没有锁，程序块返回 nil
      - 不是零，说明有锁且是自己的锁，直接调用 HINCRBY 负一表示每次减个一，解锁一次。直到它变为零表示可以删除该锁 key，del  锁key
      - 全套流程（23：26）
  - 上述设计修改为 Lua 脚本
    - V1
    - V2（27：39）
  - 测试全套流程（28：53）

# P135 redis 高级篇之 redis 分布式锁迭代编码05

将上述 lua 脚本整合进入微服务 Java 程序

- 复原程序为初始无锁版
- 新建 RedisDistributedLock 类并实现 JUC 里面的 Lock 接口
- 满足 JUC 里面 AQS 对 Lock 锁的接口规范定义来进行实现落地代码
- 结合设计模式开发属于自己的 Redis 分布式锁工具类
  - lock 方法的全盘通用讲解
  - lua 脚本
    - 加锁 lock（10：46）
    - 解锁 unlock（19：14）
  - 工厂设计模式引入
    - 通过实现 JUC 里面的 Lock 接口，实现 Redis 分布式锁 RedisDistributedLock
    - InventoryService 直接使用上面的代码设计，有什么问题（25：51）
    - 考虑扩展，本次是 redis 实现分布式锁，以后 zookeeper、mysql 实现那？？？
    - 引入工厂模式改造 7.1 版 code
    - 单机+并发测试通过

# P136 redis 高级篇之 redis 分布式锁迭代编码06

- 引入工厂模式改造 7.1 版 code
  - DistributedLockFactory（4：05）
  - RedisDistributedLock
  - InventoryService 使用工厂模式版
- 单机+并发测试通过

可重入性测试重点

- 可重入测试？？？
  - InventoryService 类新增可重入测试方法
  - 结果（20：04）
    - ThreadID 一致了但是 UUID 不 OK
- 引入工厂模式改造 7.2 版 code
  - DistributedLockFactory
  - RedisDistributedLock
  - InventoryService 类新增可重入测试方法
- 单机+并发+可重入性，测试通过

# P137 redis 高级篇之 redis 分布式锁迭代编码07

8、自动续期

- 确保 redisLock 过期时间大于业务执行时间的问题
  - Redis 分布式锁如何续期？
- CAP
  - Redis 集群是 AP
    - AP
      - Redis 异步复制造成的锁丢失，比如：主节点没来得及把刚刚 set 进来这条数据给从节点，master 就挂了，从机上位但从机上无该数据
  - Zookeeper 集群是 CP
    - CP（7：30）
    - 故障（8：31）
  - 顺便复习 Eureka 集群是 AP
    - AP（10：04）
  - 顺便复习 Nacos 集群是 AP（10：50）
- 加个钟，lua 脚本（15：36）
- 8.0 版新增自动续期功能
  - 修改为 V8.0 版程序
  - del 掉之前的 lockName zzyyRedisLock
  - RedisDistributedLock（27：02）
  - InventoryService
    - 记得去掉可重入测试 testReEnter()
    - InventoryService 业务逻辑里面故意 sleep 一段时间测试自动续期

# P138 redis 高级篇之 redis 分布式锁小总结

总结

- synchronized 单机版 OK，上分布式死翘翘
- nginx 分布式微服务，单机锁不行
- 取消单机锁，上 redis 分布式锁 setnx
  - 只加了锁，没有释放锁，出异常的话，可能无法释放锁，必须要在代码层面 finally 释放锁
  - 宕机了，部署了微服务代码层面根本没有走到 finally 这块，没办法保证解锁，这个 key 没有被删除，需要有 lockKey 的过期时间设定
  - 为 redis 的分布式锁 key，增加过期时间。此外，还必须要 setnx + 过期时间必须同一行
    - 必须规定只能自己删除自己的锁，你不能把别人的锁删除了，防止张冠李戴，1 删 2，2 删 3
    - unlock 变 Lua 脚本保证
      - 锁重入，hset 替代 setnx + lock 变为 Lua 脚本保证
        - 自动续期

# P139 redis RedLock 底层 Redisson 源码深层分析-上

9、Redlock 算法和底层源码分析

- 当前代码为 8.0 版接上一步

  - 自研一把分布式锁，面试中回答的主要考点
    - 按照 JUC 里面 java.util.concurrent.locks.Lock 接口规范编写
    - lock() 加锁关键逻辑（4：35）
      - 加锁
        - 加锁实际上就是在 redis 中，给 Key 键设置一个值，为避免死锁，并给定一个过期时间
      - 自旋
      - 续期
    - unlock 解锁关键逻辑（5：59）
      - 将 Key 键删除。但也不能乱删，不能说客户端 1 的请求将客户端 2 的锁给删除掉，只能自己删除自己的锁
  - 上面自研的 redis 锁对于一般中小公司，不是特别高并发场景足够用了，单机 redis 小业务也撑得住

- Redis 分布式锁-Redlock 红锁算法 Distributed locks with Redis

  - 官网说明

    - 主页说明（8：12）

  - 为什么学习这个？怎么产生的？

    - 之前我们手写的分布式锁有什么缺点？

      - 官网证据（11：48）
      - 翻译（11：54）

    - 说人话

      - （15：07）

        主从复制是异步的，master 还没同步锁时宕机的情况，导致从机升级为主机，两个用户同时认为自己拥有了锁

  - Redlock 算法设计理念

    - redis 之父提出了 Redlock 算法解决这个问题（18：27）
    - 设计理念（21：38）
    - 解决方案（27：00）
      - 容错公式

  - 天上飞的理念（RedLock）必然有落地的实现（Redisson）

    - redisson 实现
      - Redisson 是 java 的 redis 客户端之一，提供了一些 api 方便操作 redis
      - redisson 之官网
      - redisson 之 GitHub
      - redisson 之解决分布式锁

- 使用 Redisson 进行编码改造 V9.0

- Redisson 源码解析

- 多机案例

# P140 redis RedLock 底层 Redisson 源码深层分析-中

使用 Redisson 进行编码改造 V9.0

- 你怎么知道该这样使用？
  - 官网说话（1：11）
- V9.0 版本修改
  - POM（2：35）
  - RedisConfig
  - InventoryController
  - 从现在开始不再用我们自己手写的锁了
  - InventoryService
  - 测试
    - 单机
    - JMeter
      - Bug（14：08）
      - 解决
        - 业务代码修改为 V9.1 版

Redisson 源码解析

- 加锁

- 可重入

- 续命

- 解锁

- 分析步骤

  - Redis 分布式锁过期了，但是业务逻辑还没处理完怎么办

    - 还记得之前说过的缓存续命吗？

  - 守护线程“续命”

    - （19：40）

      每 1/3 的锁时间检查 1 次

  - 在获取锁成功后，给锁加一个 watchdog，watchdog 会起一个定时任务，在锁没有被释放且快要过期的时候会续期（20：30）

  - 上述源码分析1（21：52）

    - 通过 redisson 新建出来的锁 key，默认是 30 秒

  - 上述源码分析2（26：34）

  - 上述源码分析3（27：04）

    - 流程解释
      - 通过 exists 判断，如果锁不存在，则设置值和过期时间，加锁成功
      - 通过 hexists 判断，如果锁已存在，并且锁的是当前线程，则证明是重入锁，加锁成功
      - 如果锁已存在，但锁的不是当前线程，则证明有其它线程持有锁。返回当前锁的过期时间（代表了锁 key 的剩余生存时间），加锁失败

  - 上述源码分析4（31：21）

    - watch dog 自动延期机制（32：55）
    - 自动续期 lua 脚本分析（34：16）

  - 解锁（35：27）

# P141 redis RedLock 底层 Redisson 源码深层分析-下

多机案例

- 理论参考来源

  - redis 之父提出了 Redlock 算法解决这个问题

  - 官网（3：03）

  - 具体（3：07）

  - 小总结

    - （4：41）

      网上讲的基于故障转移实现的 redis 主从无法真正实现 Redlock

- 代码参考来源

  - X 2022年第8章第4小节（7：48）
  - X 2023年第8章第4小节
    - 8.4 RedLock：This object is deprecated. Use RLock or RFencedLock instead.
  - 2023年第8章第3小节
    - MultiLock 多重锁（12：40）

- 案例

  - docker 走起 3 台 redis 的 master 机器，本次设置 3 台 master 各自独立无从属关系（16：26）
  - 进入上一步刚启动的 redis 容器实例（18：39）
  - 建 Module
    - redis_redlock
  - 改 POM
  - 写 YML
  - 主启动
  - 业务类
    - 配置
      - CacheConfiguration
      - RedisPoolProperties
      - RedisProperties
      - RedisSingleProperties
    - Controller
  - 测试
    - 命令
      - ttl ATGUIGU_REDLOCK
      - HGETALL ATGUIGU_REDLOCK
      - shutdown
      - docker start redis-master-1
      - docker exec -it redis-master-1 redis-cli
    - 结论（37：17）

# P142 redis 高级篇之缓存淘汰大厂面试题简介

10、Redis 的缓存过期淘汰策略

- 粉丝反馈的面试题

  - 生产上你们的 redis 内存设置多少？

  - 如何配置、修改 redis 的内存大小

  - 如果内存满了你怎么办

  - redis 清理内存的方式？定期删除和惰性删除了解过吗

  - redis 缓存淘汰策略有哪些？分别是什么？你用哪个？

  - redis 的 LRU 了解过吗？请手写 LRU

    - 算法手写 code 见阳哥大厂第 3 季视频（3：05）

  - lru 和 lfu 算法的区别是什么

    - LRU means Least Recently Used

      LFU means Least Frequently Used

  - ……

- Redis 内存满了怎么办

- 往 redis 里写的数据是怎么没了的？它如何删除的？

- redis 缓存淘汰策略

- redis 缓存淘汰策略配置性能建议

# P143 redis 高级篇之缓存淘汰策略内存查看和打满 OOM

Redis 内存满了怎么办

- redis 默认内存多少？在哪里查看？如何设置修改？

  - 查看 Redis 最大占用内存

    - （0：38）

      设置 maxmemory 参数，是 bytes 字节类型，注意转换

  - redis 默认内存多少可以用？

    - 如果不设置最大内存大小或者设置最大内存大小为 0，在 64 位操作系统下不限制内存大小，在 32 位操作系统下最多使用 3 GB 内存
    - 注意，在 64 bit 系统下，maxmemory 设置为 0 表示不限制 Redis 内存使用

  - 一般生产上你如何配置？

    - 一般推荐 Redis 设置内存为最大物理内存的四分之三

  - 如何修改 redis 内存设置

    - 通过修改文件配置（5：12）
    - 通过命令修改（5：52）

  - 什么命令查看 redis 内存使用情况？

    - info memory
    - config get maxmemory

- 真要打满了会怎么样？如果 Redis 内存使用超过了设置的最大值会怎样？

  - 改改配置，故意把最大值设为 1 个 byte 试试（8：39）

- 结论

  - 设置了 maxmemory 的选项，假如 redis 内存使用达到上限
  - 没有加上过期时间就会导致数据写满 maxmemory，为了避免类似情况，引出下一章内存淘汰策略

往 redis 里写的数据是怎么没了的？它如何删除的？

- redis 过期键的删除策略（10：46）
- 三种不同的删除策略
  - 立即删除（11：38）
    - 总结：对 CPU 不友好，用处理器性能换取存储空间（拿时间换空间）
  - 惰性删除（14：03）
    - 总结：对 memory 不友好，用存储空间换取处理器性能（拿空间换时间）
    - 开启惰性淘汰，lazyfree-lazy-eviction=yes
  - 上面两种方案都走极端
    - 定期删除（17：17）
      - 定期抽样 key，判断是否过期
      - 漏网之鱼
- 上述步骤都过堂了，还有漏洞吗？（20：16）
- redis 缓存淘汰策略登场

# P144 redis 高级篇之缓存淘汰策略八种策略及使用建议

redis 缓存淘汰策略

- redis 配置文件（0：14）
- lru 和 lfu 算法的区别是什么（1：30）
- 有哪些（redis 7 版本）
  1. noeviction：不会驱逐任何 key，表示即使内存达到上限也不进行置换，所有能引起内存增加的命令都会返回 error
  2. allkeys-lru：对所有 key 使用 LRU 算法进行删除，优先删除掉最近最不经常使用的 key，用以保存新数据
  3. volatile-lru：对所有设置了过期时间的 key 使用 LRU 算法进行删除
  4. allkeys-random：对所有 key 随机删除
  5. volatile-random：对所有设置了过期时间的 key 随机删除
  6. volatile-ttl：删除马上要过期的 key
  7. allkeys-lfu：对所有 key 使用 LFU 算法进行删除
  8. volatile-lfu：对所有设置了过期时间的 key 使用 LFU 算法进行删除
- 上面总结
  - 2 * 4 = 8
  - 2 个维度
    - 过期键中筛选
    - 所有键中筛选
  - 4 个方面
    - LRU
    - LFU
    - random
    - ttl
  - 8 个选项
- 你平时用哪一种（8:33）
- 如何配置、修改
  - 直接使用 config 命令
  - 直接 redis.conf 配置文件

redis 缓存淘汰策略配置性能建议

- 避免存储 bigkey
- 开启惰性淘汰，lazyfree-lazy-eviction=yes

# P145 redis 高级篇之 redis 源码分析大厂面试题简介

11、Redis 经典五大类型源码及底层实现

- 粉丝反馈回来的题目（2:28）
  - Redis 数据类型的底层数据结构
    - SDS 动态字符串
    - 双向链表
    - 压缩列表 ziplist
    - 哈希表 hashtable
    - 跳表 skiplist
    - 整数集合 intset
    - 快速列表 quicklist
    - 紧凑列表 listpack
  - 阅读源码意义
    - 90% 没有太大意义，完全为了面试
    - 10% 大厂自己内部中间件，比如贵公司自己内部 redis 重构，阿里云 redis，美团 tair，滴滴 kedis 等等
- redis 源码在哪里
- 源码分析参考书，阳哥个人推荐
- Redis 源代码的核心部分
- 我们平时说 redis 是字典数据库 KV 键值对到底是什么
- 5 大结构底层 C 语言源码分析
- skiplist 跳表面试题

# P146 redis 高级篇之 redis 源码分析 src 源码包简介

redis 源码在哪里

- \redis-7.0.5\src（0：36）

源码分析参考书，阳哥个人推荐

- 《Redis 设计与实现》
- 《Redis 5 设计与源码分析》

Redis 源代码的核心部分

- src 源码包下面该如何看？
  - 源码分析思路
    - 这么多你如何看？
      - 外面考什么就看什么
      - 分类
  - Redis 基本的数据结构（骨架）
    - GitHub 官网说明（6：25）
      - Redis 对象 object.c
      - 字符串 t_string.c
      - 列表 t_list.c
      - 字典 t_hash.c
      - 集合及有序集合 t_set.c 和 t_zset.c
      - 数据流 t_stream.c
        - Streams 的底层实现结构 listpack.c 和 rax.c
          - 了解
    - 简单动态字符串 sds.c
    - 整数集合 intset.c
    - 压缩列表 ziplist.c
    - 快速链表 quicklist.c
    - listpack
    - 字典 dict.c
  - Redis 数据库的实现
    - 数据库的底层实现 db.c
    - 持久化 rdb.c 和 aof.c
  - Redis 服务端和客户端实现
    - 事件驱动 ae.c 和 ae_epoll.c
    - 网络连接 anet.c 和 networking.c
    - 服务端程序 server.c
    - 客户端程序 redis-cli.c
  - 其他
    - 主从复制 replication.c
    - 哨兵 sentinel.c
    - 集群 cluster.c
    - 其它数据结构，如 hyperloglog.c、geo.c 等
    - 其它功能，如 pub/sub、lua 脚本

我们平时说 redis 是字典数据库 KV 键值对到底是什么

- 怎样实现键值对（key-value）数据库的
  - redis 是 key-value 存储系统
    - key 一般都是 String 类型的字符串对象
    - value 类型则为 redis 对象（redisObject）
      - value 可以是字符串对象，也可以是集合数据类型的对象，比如 List 对象、Hash 对象、Set 对象和 Zset 对象
  - 图说（16：47）
- 10 大类型说明（粗分）
  - 传统的 5 大类型
    - String
    - List
    - Hash
    - Set
    - ZSet
  - 新介绍的 5 大类型（17：45）
    - bitmap
      - 实质 String
    - hyperLogLog
      - 实质 String
    - GEO
      - 实质 Zset
    - Stream
      - 实质 Stream
    - BITFIELD
      - 看具体 key
- 上帝视角（20：06）
- Redis 定义了 redisObject 结构体来表示 string、hash、list、set、zset 等数据类型
  - C 语言 struct 结构体语法简介（26：20）
  - Redis 中每个对象都是一个 redisObject 结构
  - 字典、KV 是什么（重点）
  - 这些键值对是如何保存进 Redis 并进行读取操作，O(1) 复杂度
  - redisObject + Redis 数据类型 + Redis 所有编码方式（底层实现）三者之间的关系

# P147 redis 高级篇之 redis 源码分析从 dictEntry 到 RedisObject

字典、KV 是什么（重点）

- 每个键值对都会有一个 dictEntry
- （源码位置：dict.h）（1：20）
- 重点：从 dictEntry 到 RedisObject（3：46）

这些键值对是如何保存进 Redis 并进行读取操作，O(1) 复杂度（7：31）

redisObject + Redis 数据类型 + Redis 所有编码方式（底层实现）三者之间的关系

- （9：00）

  redisObject

  - 字符串 REDIS_STRING
    - 整数 REDIS_ENCODING_INT
    - 字符串 REDIS_ENCODING_RAW
  - 列表 REDIS_LIST
    - 双端列表 REDIS_ENCODING_LINKEDLIST
    - 压缩列表 REDIS_ENCODING_ZIPLIST
  - 有序集合 REDIS_ZSET
    - 跳跃表 REDIS_ENCODING_SKIPLIST
    - 压缩列表 REDIS_ENCODING_ZIPLIST
  - 哈希表 REDIS_HASH
    - 压缩列表 REDIS_ENCODING_ZIPLIST
    - 字典 REDIS_ENCODING_HT
  - 集合 REDIS_SET
    - 字典 REDIS_ENCODING_HT
    - 整数集合 REDIS_ENCODING_INTSET

# P148 redis 高级篇之 redis 源码分析 RedisObject 内各字段含义

5 大结构底层 C 语言源码分析

- 重点：redis 数据类型与数据结构总纲图

  - 源码分析总体数据结构大纲

    1. SDS 动态字符串
    2. 双向链表
    3. 压缩列表 ziplist
    4. 哈希表 hashtable
    5. 跳表 skiplist
    6. 整数集合 intset
    7. 快速列表 quicklist
    8. 紧凑列表 listpack

  - redis 6.0.5

    - （3：56）

      String = SDS

      Set = intset + hashtable

      ZSet = skiplist + ziplist

      List = quicklist + ziplist

      Hash = hashtable + ziplist

  - 2021.11.29 号之后

  - redis 7

    - （7：54）

      String = SDS

      Set = intset + hashtable

      ZSet = skiplist + listpack 紧凑列表

      List = quicklist

      Hash = hashtable + listpack 紧凑列表

  - 复习一下基础篇介绍的 redis 7 新特性，看看数据结构

- 源码分析总体数据结构大纲

  - 程序员写代码时脑子底层思维（13：15）
    - 上帝视角最右边编码如何来的（13：47）
    - redisObject 操作底层定义来自哪里？（14：26）

- 从 set hello world 说起

  - 每个键值对都会有一个 dictEntry（17：01）
  - 看看类型
    - type 键
  - 看看编码
    - object encoding hello

- redisObject 结构的作用（20：29）

  - RedisObject 各字段的含义（22：22）
  - 案例
    - set age 17（26：14）

- 经典 5 大数据结构解析

  - 各个类型的数据结构的编码映射和定义（27：23）
  - Debug Object key
    - 再看一次 set age 17（28：57）
    - 上述解读
      - 命令（30：33）
      - 案例
        - 开启前（33：44）
        - 开启后（35：40）
  - String 数据结构介绍
  - Hash 数据结构介绍
  - List 数据结构介绍
  - Set 数据结构介绍
  - ZSet 数据结构介绍

- 小总结

# P149 redis 高级篇之 redis 源码分析 String 类型 3 大编码介绍

String 数据结构介绍

- 3 大物理编码方式
  - RedisObject 内部对应 3 大物理编码（2：51）
  - int
    - 保存 long 型（长整型）的 64 位（8 个字节）有符号整数
    - 9223372036854775807（2^63 - 1）
    - 上面数字最多19位
    - 补充
      - 只有整数才会使用 int，如果是浮点数，Redis 内部其实先将浮点数转化为字符串值，然后再保存。
  - embstr
    - 代表 embstr 格式的 SDS（Simple Dynamic String 简单动态字符串），保存长度小于 44 字节的字符串
    - EMBSTR 顾名思义即：embedded string，表示嵌入式的 String
  - raw
    - 保存长度大于 44 字节的字符串
- 3 大物理编码案例
  - 案例测试（7：01）
  - C 语言中字符串的展现
  - SDS 简单动态字符串
  - Redis 为什么重新设计一个 SDS 数据结构？
  - 源码分析
  - 转变逻辑图
  - 案例结论
- 总结

# P150 redis 高级篇之 redis 源码分析 String 类型 SDS

- C 语言中字符串的展现（0：26）

- SDS 简单动态字符串

  - sds.h 源码分析

    - （3：47）

      len 字符串长度

      alloc 分配的空间长度

      flags sds 类型

      buf[] 字节数组

  - 说明（4：24）

  - 官网

- Redis 为什么重新设计一个 SDS 数据结构？（11：58、15：19）

# P151 redis 高级篇之 redis 源码分析 String 之 int-embstr-raw 源码分析

源码分析

- 用户 API

  - set k1 v1 底层发生了什么？调用关系（0：52）

- 3 大物理编码方式（4：23）

  - INT 编码格式

    - set k1 123

      - （4：50）

        当字符串键值的内容可以用一个 64 位有符号整形来表示时，Redis 会将键值转化为 long 型来进行存储，此时即对应 OBJ_ENCODING_INT 编码类型。

        Redis 启动时会预先建立 10000 个分别存储 0~9999 的 redisObject 变量作为共享对象，这就意味着如果 set 字符串的键值在 0 ~ 10000 之间的话，则可以**直接指向共享对象 而不需要再建立新对象，此时键值不占空间！**

  - EMBSTR 编码格式

    - set k1 abc（15：16）
      - 进一步 createEmbeddedStringObject 方法（16：50）

  - RAW 编码格式

    - set k1 大于44长度的一个字符串，随便写（18：40）

  - 明明没有超过阈值，为什么变成 raw 了

    - （20：40）

      对于 embstr，由于其实现是只读的，因此在对 embstr 对象进行修改时，都会先转化为 raw 再进行修改。因此，只要是修改 embstr 对象，修改后的对象一定是 raw 的，无论是否达到了 44 个字节

      判断不出来，就取最大 Raw

# P152 redis 高级篇之 redis 源码分析 String 重要总结

- 转变逻辑图（1：17）

- 案例结论

  - （4：10）

    只有整数才会使用 int，如果是浮点数，Redis 内部其实先将浮点数转化为字符串值，然后再保存。

    embstr 与 raw 类型底层的数据结构其实都是 SDS（简单动态字符串，Redis 内部定义 sdshdr 一种结构）。

总结

- Redis 内部会根据用户给的不同键值而使用不同的编码格式，自适应地选择较优化的内部编码格式，而这一切对用户完全透明！

# P153 redis 高级篇之 redis 源码分析 Hash 类型底层结构概述

Hash 数据结构介绍

- 案例
  - redis 6
  - redis 7
- hash 的两种编码格式
  - redis 6
    -  ziplist
    - hashtable
  - redis 7
    - listpack
    - hashtable

# P154 redis 高级篇之 redis 源码分析 Hash 类型 ziplist 和 hashtable 案例

