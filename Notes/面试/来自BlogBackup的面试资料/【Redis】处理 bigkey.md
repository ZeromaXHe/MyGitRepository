# 简答

bigkey 是指 key 对应的 value 所占的内存空间比较大，例如一个字符串类型的 value 可以最大存到 512MB，一个列表类型的 value 最多可以存储 2^32-1 个元素。如果按照数据结构来细分的话，一般分为字符串类型 bigkey 和非字符串类型 bigkey。 

- **字符串类型**：体现在单个value值很大，一般认为超过 10KB 就是 bigkey，但这个值和具体的OPS相关。 
- **非字符串类型**：哈希、列表、集合、有序集合，体现在元素个数过多。

bigkey 的危害体现在三个方面：

- **内存空间不均匀（平衡）**：例如在 Redis Cluster 中，bigkey 会造成节点的内存空间使用不均匀。 
- **超时阻塞**：由于 Redis 单线程的特性，操作 bigkey 比较耗时，也就意味着阻塞 Redis 可能性增大。 
- **网络拥塞**：每次获取 bigkey 产生的网络流量较大，假设一个 bigkey 为 1MB，每秒访问量为 1000，那么每秒产生 1000MB 的流量，对于普通的千兆网卡（按照字节算是 128MB/s）的服务器来说简直是灭顶之灾，而且一般服务器会采用单机多实例的方式来部署，也就是说一个 bigkey 可能会对其他实例造成影响，其后果不堪设想。

在实际生产环境中发现bigkey的两种方式如下： 

- **被动收集**：许多开发人员确实可能对 bigkey 不了解或重视程度不够，但是这种 bigkey 一旦大量访问，很可能就会带来命令慢查询和网卡跑满问题，开发人员通过对异常的分析通常能找到异常原因可能是 bigkey，这种方式虽然不是被笔者推荐的，但是在实际生产环境中却大量存在，建议修改 Redis 客户端，当抛出异常时打印出所操作的 key，方便排查 bigkey 问题。 
- **主动检测**：scan + debug object：如果怀疑存在 bigkey，可以使用 scan 命令渐进的扫描出所有的 key，分别计算每个 key 的 serializedlength，找到对应 bigkey 进行相应的处理和报警，这种方式是比较推荐的方式。 

如何删除 bigkey：

- **string**：对于 string 类型使用 del 命令一般不会产生阻塞
- **hash、list、set、sorted set**：以 hash 为例子，使用 hscan 命令，每次获取部分（例如100个）field-value，再利用 hdel 删除每个 field（为了快速可以使用Pipeline）

Redis 4.0 新增了非常实用的 **lazy free** 特性，从根本上解决 Big Key(主要指定元素较多集合类型 Key)删除的风险。

lazy free 可译为惰性删除或延迟释放；当删除键的时候，Redis 提供异步延时释放 key 内存的功能，把 key 释放操作放在bio(Background I/O) 单独的子线程处理中，减少删除 big key 对 Redis 主线程的阻塞。有效地避免删除 big key 带来的性能和可用性问题。

lazy free的使用分为 2 类：

- 第一类是与 DEL 命令对应的主动删除：UNLINK 命令、FLUSHALL/FLUSHDB ASYNC
- 第二类是过期 key 删除、maxmemory key 驱逐淘汰删除：lazyfree-lazy-eviction、lazyfree-lazy-expire、lazyfree-lazy-server-del、slave-lazy-flush

lazy free 能监控的数据指标，只有一个值：`lazyfree_pending_objects`，表示 Redis 执行 lazy free 操作，在等待被实际回收内容的键个数。并不能体现单个大键的元素个数或等待 lazy free 回收的内存大小。

# 详解

bigkey 是指 key 对应的 value 所占的内存空间比较大，例如一个字符串类型的 value 可以最大存到 512MB，一个列表类型的 value 最多可以存储 2^32-1 个元素。如果按照数据结构来细分的话，一般分为字符串类型 bigkey 和非字符串类型 bigkey。 

- **字符串类型**：体现在单个value值很大，一般认为超过 10KB 就是 bigkey，但这个值和具体的OPS相关。 
- **非字符串类型**：哈希、列表、集合、有序集合，体现在元素个数过多。

bigkey无论是空间复杂度和时间复杂度都不太友好，下面我们将介绍它的危害。

> **注意**
>
> 因为非字符串数据结构中，每个元素实际上也是一个字符串，但这里只讨论元素个数过多的情况。 

# 1 bigkey 的危害

bigkey 的危害体现在三个方面：

- **内存空间不均匀（平衡）**：例如在 Redis Cluster 中，bigkey 会造成节点的内存空间使用不均匀。 
- **超时阻塞**：由于 Redis 单线程的特性，操作 bigkey 比较耗时，也就意味着阻塞 Redis 可能性增大。 
- **网络拥塞**：每次获取 bigkey 产生的网络流量较大，假设一个 bigkey 为 1MB，每秒访问量为 1000，那么每秒产生 1000MB 的流量，对于普通的千兆网卡（按照字节算是 128MB/s）的服务器来说简直是灭顶之灾，而且一般服务器会采用单机多实例的方式来部署，也就是说一个 bigkey 可能会对其他实例造成影响，其后果不堪设想。

bigkey 的存在并不是完全致命的，如果这个 bigkey 存在但是几乎不被访问，那么只有内存空间不均匀的问题存在，相对于另外两个问题没有那么重要紧急，但是如果 bigkey 是一个热点 key（频繁访问），那么其带来的危害不可想象，所以在实际开发和运维时一定要密切关注 bigkey 的存在。 

# 2 如何发现

`redis-cli --bigkeys` 可以命令统计 bigkey 的分布，但是在生产环境中，开发和运维人员更希望自己可以定义 bigkey 的大小，而且更希望找到真正的 bigkey 都有哪些，这样才可以去定位、解决、优化问题。判断一个 key 是否为 bigkey，只需要执行 debug object key 查看 serializedlength 属性即可，它表示 key 对应的 value 序列化之后的字节数，例如我们执行如下操作：

```sh
127.0.0.1:6379> debug object key
Value at:0x7fc06c1b1430 refcount:1 encoding:raw serializedlength:1256350 lru:11686193 lru_seconds_idle:20
```

可以发现 serializedlength=11686193 字节，约为 1M，同时可以看到 encoding 是 raw，也就是字符串类型，那么可以通过 strlen 来看一下字符串的字节数为 2247394 字节，约为 2MB：

```sh
127.0.0.1:6379> strlen key
(integer) 2247394
```

serializedlength 不代表真实的字节大小，它返回对象使用 RDB 编码序列化后的长度，值会偏小，但是对于排查 bigkey 有一定辅助作用，因为不是每种数据结构都有类似 strlen 这样的方法。 

在实际生产环境中发现bigkey的两种方式如下： 

- **被动收集**：许多开发人员确实可能对 bigkey 不了解或重视程度不够，但是这种 bigkey 一旦大量访问，很可能就会带来命令慢查询和网卡跑满问题，开发人员通过对异常的分析通常能找到异常原因可能是 bigkey，这种方式虽然不是被笔者推荐的，但是在实际生产环境中却大量存在，建议修改 Redis 客户端，当抛出异常时打印出所操作的 key，方便排查 bigkey 问题。 
- **主动检测**：scan + debug object：如果怀疑存在 bigkey，可以使用 scan 命令渐进的扫描出所有的 key，分别计算每个 key 的 serializedlength，找到对应 bigkey 进行相应的处理和报警，这种方式是比较推荐的方式。 

> **开发提示**
>
> - 如果键值个数比较多，scan + debug object 会比较慢，可以利用 Pipeline 机制完成。
> - 对于元素个数较多的数据结构，debug object执行速度比较慢，存在阻塞 Redis 的可能。 
> - 如果有从节点，可以考虑在从节点上执行。 

# 3 如何删除

当发现 Redis 中有 bigkey 并且确认要删除时，如何优雅地删除 bigkey？无论是什么数据结构，del 命令都将其删除。但是相信通过上面的分析后你一定不会这么做，因为删除 bigkey 通常来说会阻塞 Redis 服务。下面给出一组测试数据分别对string、hash、list、set、sorted set 五种数据结构的 bigkey 进行删除，bigkey 的元素个数和每个元素的大小不尽相同。

> **注意** 
>
> 下面测试和服务器硬件、Redis 版本比较相关，可能在不同的服务器上执行速度不太相同，但是能提供一定的参考价值

下表展示了删除 512KB ~ 10MB 的字符串类型数据所花费的时间，总体来说由于字符串类型结构相对简单，删除速度比较快，但是随着 value 值的不断增大，删除速度也逐渐变慢。 

| key 类型 | 512KB  | 1MB    | 2MB    | 5MB    | 10MB |
| -------- | ------ | ------ | ------ | ------ | ---- |
| string   | 0.22ms | 0.31ms | 0.32ms | 0.56ms | 1ms  |

下表展示了非字符串类型的数据结构在不同数量级、不同元素大小下对 bigkey 执行 del 命令的时间，总体上看元素个数越多、元素越大，删除时间越长，相对于字符串类型，这种删除速度已经足够可以阻塞 Redis。 

| key 类型   | 10 万<br/>（8 个字节） | 100 万<br/>（8 个字节） | 10 万<br/>（16 个字节） | 100 万<br/>（16 个字节） | 10 万<br/>（128 个字节） | 100 万<br/>（128 个字节） |
| ---------- | ---------------------- | ----------------------- | ----------------------- | ------------------------ | ------------------------ | ------------------------- |
| hash       | 51ms                   | 950ms                   | 58ms                    | 970ms                    | 96ms                     | 2000ms                    |
| list       | 23ms                   | 134ms                   | 23ms                    | 138ms                    | 23ms                     | 266ms                     |
| set        | 44ms                   | 873ms                   | 58ms                    | 881ms                    | 73ms                     | 1319ms                    |
| sorted set | 51ms                   | 845ms                   | 57ms                    | 859ms                    | 59ms                     | 969ms                     |

从上分析可见，除了 string 类型，其他四种数据结构删除的速度有可能很慢，这样增大了阻塞 Redis 的可能性。既然不能用 del 命令，那有没有比较优雅的方式进行删除呢，这时候就需要将和 scan 命令的若干类似命令拿出来：sscan、hscan、zscan。 

## 3.1 string

对于 string 类型使用 del 命令一般不会产生阻塞

## 3.2 hash、list、set、sorted set

下面以 hash 为例子，使用 hscan 命令，每次获取部分（例如100个）field-value，再利用 hdel 删除每个 field（为了快速可以使用Pipeline）：

```java
public void delBigHash(String bigKey) {
    Jedis jedis = new Jedis(“127.0.0.1”, 6379);
    // 游标
    String cursor = “0”;
    while (true) {
        ScanResult<Map.Entry<String, String>> scanResult =
            jedis.hscan(bigKey, cursor, new ScanParams().count(100));
        // 每次扫描后获取新的游标
        cursor = scanResult.getStringCursor();
        // 获取扫描结果
        List<Entry<String, String>> list = scanResult.getResult();
        if (list == null || list.size() == 0) {
            continue;
        }
        String[] fields = getFieldsFrom(list);
        // 删除多个field
        jedis.hdel(bigKey, fields);
        // 游标为0时停止
        if (cursor.equals(“0”)) {
            break;
        }
    }
    // 最终删除key
    jedis.del(bigKey);
}
/**
 * 获取field数组
 * @param list
 * @return
 */
private String[] getFieldsFrom(List<Entry<String, String>> list) {
    List<String> fields = new ArrayList<String>();
    for(Entry<String, String> entry : list) {
        fields.add(entry.getKey());
    }
    return fields.toArray(new String[fields.size()]); 
}
```

> **开发提示**
>
> 请勿忘记每次执行到最后执行 del key 操作。

# 4 最佳实践思路

由于开发人员对 Redis 的理解程度不同，在实际开发中出现 bigkey 在所难免，重要的是，能通过合理的检测机制及时找到它们，进行处理。作为开发人员在业务开发时应注意不能将 Redis 简单暴力的使用，应该在数据结构的选择和设计上更加合理，例如出现了 bigkey，要思考一下可不可以做一些优化（例如拆分数据结构）尽量让这些 bigkey 消失在业务中，如果 bigkey 不可避免，也要思考一下要不要每次把所有元素都取出来（例如有时候仅仅需要 hmget，而不是 hgetall）。



最后，可喜的是，Redis 在 4.0 版本支持 lazy delete free的模式，删除 bigkey 不会阻塞 Redis。 

Redis 4.0 新增了非常实用的 lazy free 特性，从根本上解决 Big Key(主要指定元素较多集合类型 Key)删除的风险。在 redis 运维中容易遇到 Big Key 删除带来可用性和性能故障。

## 4.1 lazy free的定义

lazy free 可译为惰性删除或延迟释放；当删除键的时候，Redis 提供异步延时释放 key 内存的功能，把 key 释放操作放在bio(Background I/O) 单独的子线程处理中，减少删除 big key 对 Redis 主线程的阻塞。有效地避免删除 big key 带来的性能和可用性问题。

## 4.2 我们为什么需要 lazy free

Redis 是单线程程序(除少量的 bio 任务),当运行一个耗时较大的请求时，会导致所有请求排队等待 Redis 不能响应其他请求，引起性能问题,甚至集群发生故障切换。

而 Redis 删除大的集合键时，就属于这类比较耗时的请求。通过测试来看，删除一个 100 万个元素的集合键，耗时约 1000ms 左右。

在 Redis 4.0 前，没有 lazy free 功能；DBA 只能通过取巧的方法，类似 scan big key，每次删除 100 个元素；但在面对“被动”删除键的场景，这种取巧的删除就无能为力。

例如：我们生产 Redis Cluster 大集群，业务缓慢地写入一个带有 TTL 的 2000 多万个字段的 Hash 键，当这个键过期时，redis 开始被动清理它时，导致 Redis 被阻塞 20 多秒，当前分片主节点因 20 多秒不能处理请求，并发生主库故障切换。

Redis 4.0有 lazy free 功能后，这类主动或被动的删除 big key 时，和一个 O(1) 指令的耗时一样,亚毫秒级返回； 把真正释放 Redis 元素耗时动作交由 bio 后台任务执行。

## 4.3 lazy free的使用

lazy free的使用分为 2 类：第一类是与 DEL 命令对应的主动删除，第二类是过期 key 删除、maxmemory key 驱逐淘汰删除。

### 4.3.1 主动删除键使用 lazy free

**UNLINK 命令**

UNLINK 命令是与 DEL 一样删除 key 功能的 lazy free 实现。

唯一不同是，UNLINK 在删除集合类键时，如果集合键的元素个数大于 64 个(详细后文），会把真正的内存释放操作，给单独的 bio 来操作。

```sh
127.0.0.1:7000> LLEN mylist
(integer) 2000000
127.0.0.1:7000> UNLINK mylist
(integer) 1
127.0.0.1:7000> SLOWLOG get
1) 1) (integer) 1
2) (integer) 1505465188
3) (integer) 30
4) 1) "UNLINK"
2) "mylist"
5) "127.0.0.1:17015"
6) ""
```

> **注意**：DEL命令，还是并发阻塞的删除操作

**FLUSHALL/FLUSHDB ASYNC**

通过对 FLUSHALL/FLUSHDB 添加 ASYNC 异步清理选项，Redis 在清理整个实例或 DB 时，操作都是异步的。

```sh
127.0.0.1:7000> DBSIZE
(integer) 1812295
127.0.0.1:7000> flushall //同步清理实例数据，180万个key耗时1020毫秒
OK
(1.02s)
127.0.0.1:7000> DBSIZE
(integer) 1812637
127.0.0.1:7000> flushall async //异步清理实例数据，180万个key耗时约9毫秒
OK
127.0.0.1:7000> SLOWLOG get
1) 1) (integer) 2996109
2) (integer) 1505465989
3) (integer) 9274 //指令运行耗时9.2毫秒
4) 1) "flushall"
2) "async"
5) "127.0.0.1:20110"
6) ""
```

### 4.3.2 被动删除键使用 lazy free

lazy free 应用于被动删除中，目前有4种场景，每种场景对应一个配置参数； 默认都是关闭。

```
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
slave-lazy-flush no
```

> 注意：从测试来看 lazy free 回收内存效率还是比较高的； 但在生产环境请结合实际情况，开启被动删除的 lazy free 观察 Redis 内存使用情况。

**lazyfree-lazy-eviction**

针对 Redis 内存使用达到 maxmeory，并设置有淘汰策略时；在被动淘汰键时，是否采用 lazy free 机制；

因为此场景开启 lazy free, 可能使用淘汰键的内存释放不及时，导致 redis 内存超用，超过 maxmemory 的限制。此场景使用时，请结合业务测试。

**lazyfree-lazy-expire**

针对设置有 TTL 的键，达到过期后，被 Redis 清理删除时是否采用 lazy free 机制；此场景建议开启，因 TTL 本身是自适应调整的速度。

**lazyfree-lazy-server-del**

针对有些指令在处理已存在的键时，会带有一个隐式的 DEL 键的操作。如 rename 命令，当目标键已存在, Redis 会先删除目标键，如果这些目标键是一个 big key,那就会引入阻塞删除的性能问题。 此参数设置就是解决这类问题，建议可开启。

**slave-lazy-flush**

针对 slave 进行全量数据同步，slave 在加载 master 的 RDB 文件前，会运行 flushall 来清理自己的数据场景，参数设置决定是否采用异常 flush 机制。如果内存变动不大，建议可开启。可减少全量同步耗时，从而减少主库因输出缓冲区爆涨引起的内存使用增长。

## 4.4 lazy free的监控

lazy free 能监控的数据指标，只有一个值：`lazyfree_pending_objects`，表示 Redis 执行 lazy free 操作，在等待被实际回收内容的键个数。并不能体现单个大键的元素个数或等待 lazy free 回收的内存大小。

所以此值有一定参考值，可监测 Redis lazy free 的效率或堆积键数量； 比如在 flushall async 场景下会有少量的堆积。

# 参考文档

- 《Redis 开发与运维》12.4 处理 bigkey
- Redis的新特性懒惰删除Lazy Free详解：https://www.jb51.net/article/163919.htm