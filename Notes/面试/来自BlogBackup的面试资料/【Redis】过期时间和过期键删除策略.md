# 简答

Redis 中可以使用以下四个命令来为所有的数据结构设置过期时间或生存时间：

- `EXPIRE <key> <ttl>` 命令用于将键 key 的生存时间设置为 ttl 秒。
- `PEXPIRE <key> <ttl>` 命令用于将键 key 的生存时间设置为 ttl 毫秒。
- `EXPIREAT <key> <timestamp>` 命令用于将键 key 的过期时间设置为 timestamp 所指定的秒数时间戳。
- `PEXPIREAT <key> <timestamp>` 命令用于将键 key 的过期时间设置为 timestamp 所指定的毫秒数时间戳。

实际上 `EXPIRE`、`PEXPIRE`、`EXPIREAT` 三个命令都是使用 `PEXPIREAT` 命令来实现的。

此外还有几个与过期时间相关的命令：

- `PERSIST` 命令可以移除一个键的过期时间。
- `TTL` 命令以秒为单位返回键的剩余生存时间，而 `PTTL` 命令则以毫秒为单位返回键的剩余生存时间



至于**过期键删除策略**，Redis 服务器实际使用的是惰性删除和定期删除两种策略

- **惰性删除**：

  过期键的惰性删除策略由 `db.c/expireIfNeeded` 函数实现，所有读写数据库的 Redis 命令在执行之前都会调用 `expireIfNeeded` 函数对输入键进行检查：

  1）如果输入键已经过期，那么 `expireIfNeeded` 函数将输入键从数据库中删除。

  2）如果输入键未过期，那么 `expireIfNeeded` 函数不做动作。

- **定期删除**：

  过期键的定期删除策略由 `redis.c/activeExpireCycle` 函数实现，每当 Redis 的服务器周期性操作 `redis.c/serverCron` 函数执行时，`activeExpireCycle` 函数就会被调用。它在规定的时间内，分多次遍历服务器中的各个数据库，从数据库的 `expires` 字典中随机检查一部分键的过期时间，并删除其中的过期键。

  1）从过期字典中随机 20 个 key；删除这 20 个 key 中已经过期的 key；如果过期的 key 比率超过 1/4，那就重复步骤。

  2）全局变量 `current_db` 会记录当前 `activeExpireCycle` 函数检查的进度，并在下一次 `activeExpireCycle` 函数调用时，接着上一次的进度进行处理。

  3）随着 `activeExpireCycle` 函数的不断执行，服务器中的所有数据库都会被检查一遍，这时函数将 `current_db` 变量重置为 0，然后再次开始新一轮的检查工作。

  Redis 默认会每秒进行十次过期扫描。同时，为了保证过期扫描不会出现循环过度，导致线程卡死现象，算法还增加了扫描时间的上限，默认不会超过 25ms



关于 AOF、RDB 和复制对过期键的处理，也有其特殊的地方：

- **AOF**：

  当服务器以 AOF 持久化模式运行时，如果数据库中的某个键已经过期，但它还没有被惰性删除或者定期删除，那么 AOF 文件不会因为这个过期键而产生任何影响。当过期键被惰性删除或者定期删除之后，程序会向 AOF 文件追加（append）一条 DEL 命令，来显式地记录该键已被删除。

  在执行 AOF 重写的过程中，程序会对数据库中的键进行检查，已过期的键不会被保存到重写后的 AOF 文件中。

- **RDB**：

  在执行 `SAVE` 命令或者 `BGSAVE` 命令创建一个新的 RDB 文件时，程序会对数据库中的键进行检查，已过期的键不会被保存到新创建的 RDB 文件中。

  而在载入 RDB 文件时，如果服务器以主服务器模式运行，程序会对文件中保存的键进行检查，未过期的键会被载入到数据库中，而过期键则会被忽略。如果服务器以从服务器模式运行，那么文件中保存的所有键，不论是否过期，都会被载入到数据库中。不过，因为主从服务器在进行数据同步的时候，从服务器的数据库就会被清空，所以一般来讲，过期键对载入 RDB 文件的从服务器也不会造成影响。

- **复制**

  当服务器运行在复制模式下时，从服务器的过期键删除动作由主服务器控制。主库在 key 到期时，会在 AOF 文件里增加一条 del 指令，同步到所有的从库，从库通过执行这条 del 指令来删除过期的 key

# 详解

Redis 所有的数据结构都可以设置过期时间，时间一到，就会自动删除。

那么会不会因为同一时间太多的 key 过期，以至于忙不过来？同时因为 Redis 是单线程的，删除的时间也会占用线程的处理时间，如果过期删除过于繁忙，会不会导致读写指令出现卡顿？

这些问题 Antirez 早就想到了，所以在过期这件事上，Redis 非常小心。

## 1 过期策略简介

### 1.1 过期的 key 集合

redis 会将每个设置了过期时间的 key 放入到一个独立的字典中，以后会定时遍历这个字典来删除到期的 key。除了定时遍历之外，它还会使用惰性策略来删除过期的 key，所谓惰性策略就是在客户端访问这个 key 的时候，redis 对 key 的过期时间进行检查，如果过期了就立即删除。定时删除是集中处理，惰性删除是零散处理。

### 1.2 定时扫描策略

Redis 默认会每秒进行十次过期扫描，过期扫描不会遍历过期字典中所有的 key，而是采用了一种简单的贪心策略。

1. 从过期字典中随机 20 个 key；
2. 删除这 20 个 key 中已经过期的 key；
3. 如果过期的 key 比率超过 1/4，那就重复步骤 1。

同时，为了保证过期扫描不会出现循环过度，导致线程卡死现象，算法还增加了扫描时间的上限，默认不会超过 25ms。

设想一个大型的 Redis 实例中所有的 key 在同一时间过期了，会出现怎样的结果？

毫无疑问，Redis 会持续扫描过期字典 (循环多次)，直到过期字典中过期的 key 变得稀疏，才会停止 (循环次数明显下降)。这就会导致线上读写请求出现明显的卡顿现象。导致这种卡顿的另外一种原因是内存管理器需要频繁回收内存页，这也会产生一定的 CPU 消耗。

也许你会争辩说“扫描不是有 25ms 的时间上限了么，怎么会导致卡顿呢”？这里打个比方，假如有 101 个客户端同时将请求发过来了，然后前 100 个请求的执行时间都是 25ms，那么第 101 个指令需要等待多久才能执行？2500ms，这个就是客户端的卡顿时间，是由服务器不间断的小卡顿积少成多导致的。

**所以业务开发人员一定要注意过期时间，如果有大批量的 key 过期，要给过期时间设置一个随机范围，而不能全部在同一时间过期**。

### 1.3 从库的过期策略

从库不会进行过期扫描，从库对过期的处理是被动的。主库在 key 到期时，会在 AOF 文件里增加一条 del 指令，同步到所有的从库，从库通过执行这条 del 指令来删除过期的 key。

因为指令同步是异步进行的，所以主库过期的 key 的 del 指令没有及时同步到从库的话，会出现主从数据的不一致，主库没有的数据在从库里还存在，比如集群环境分布式锁的算法漏洞就是因为这个同步延迟产生的。

## 2 设置键的生存时间或过期时间

通过 `EXPIRE` 命令或者 `PEXPIRE` 命令，客户端可以以秒或者毫秒精度为数据库中某个键设置生存时间（Time To Live，TTL），在经过指定的秒数或者毫秒数之后，服务器就会自动删除生存时间为 0 的键：

~~~sh
redis> SET key value
OK
redis> EXPIRE key 5
(integer) 1
redis> GET key // 5 秒之内
"value"
redis> GET key // 5 秒之后
(nil)
~~~

> **注意**
>
> `SETEX` 命令可以在设置一个字符串键的同时为键设置过期时间，因为这个命令是一个类型限定的命令（只能用于字符串键），所以本章不会对这个命令进行介绍，但 SETEX 命令设置过期时间的原理和本章介绍的 EXPIRE 命令设置过期时间的原理是完全一样的。

与 `EXPIRE` 命令和 `PEXPIRE` 命令类似，客户端可以通过 `EXPIREAT` 命令或 `PEXPIREAT` 命令，以秒或者毫秒精度给数据库中的某个键设置过期时间（expire time）。

过期时间是一个 UNIX 时间戳，当键的过期时间来临时，服务器就会自动从数据库中删除这个键：

~~~sh
redis> SET key value
OK
redis> EXPIREAT key 1377257300
(integer) 1
redis> TIME
1) "1377257296"
2) "296543"
redis> GET key // 1377257300 之前
"value"
redis> TIME
1) "1377257303"
2) "230656"
redis> GET key // 1377257300 之后
(nil)
~~~

`TTL` 命令和 `PTTL` 命令接受一个带有生存时间或者过期时间的键，返回这个键的剩余生存时间，也就是，返回距离这个键被服务器自动删除还有多长时间：

~~~sh
redis> SET key value
OK
redis> EXPIRE key 1000
(integer) 1
redis> TTL key
(integer) 997
redis> SET another_key another_value
OK
redis> TIME
1) "1377333070"
2) "761687"
redis> EXPIREAT another_key 1377333100
(integer) 1
redis> TTL another_key
(integer) 10
~~~

### 2.1 设置过期时间

Redis 有四个不同的命令可以用于设置键的生存时间（键可以存在多久）或过期时间（键什么时候会被删除）：

- `EXPIRE <key> <ttl>` 命令用于将键 key 的生存时间设置为 ttl 秒。
- `PEXPIRE <key> <ttl>` 命令用于将键 key 的生存时间设置为 ttl 毫秒。
- `EXPIREAT <key> <timestamp>` 命令用于将键 key 的过期时间设置为 timestamp 所指定的秒数时间戳。
- `PEXPIREAT <key> <timestamp>` 命令用于将键 key 的过期时间设置为 timestamp 所指定的毫秒数时间戳。

虽然有多种不同单位和不同形式的设置命令，但实际上 `EXPIRE`、`PEXPIRE`、`EXPIREAT` 三个命令都是使用 `PEXPIREAT` 命令来实现的：无论客户端执行的是以上四个命令中的哪一个，经过转换之后，最终的执行效果都和执行 `PEXPIREAT` 命令一样。

### 2.2 保存过期时间

redisDb 结构的 expires 字典保存了数据库中所有键的过期时间，我们称这个字典为过期字典：

- 过期字典的键是一个指针，这个指针指向键空间中的某个键对象（也即是某个数据库键）。
- 过期字典的值是一个 long long 类型的整数，这个整数保存了键所指向的数据库键的过期时间——一个毫秒精度的 UNIX 时间戳。

~~~c
typedef struct redisDb {
    // ...
    // 过期字典，保存着键的过期时间
    dict *expires;
    // ...
} redisDb;
~~~

当客户端执行 `PEXPIREAT` 命令（或者其他三个会转换成 `PEXPIREAT` 命令的命令）为一个数据库键设置过期时间时，服务器会在数据库的过期字典中关联给定的数据库键和过期时间。

### 2.3 移除过期时间

`PERSIST` 命令可以移除一个键的过期时间：

~~~sh
redis> PEXPIREAT message 1391234400000
(integer) 1
redis> TTL message
(integer) 13893281
redis> PERSIST message
(integer) 1
redis> TTL message
(integer) -1
~~~

`PERSIST` 命令就是 `PEXPIREAT` 命令的反操作：`PERSIST` 命令在过期字典中查找给定的键，并解除键和值（过期时间）在过期字典中的关联。

### 2.4 计算并返回剩余生存时间

`TTL` 命令以秒为单位返回键的剩余生存时间，而 `PTTL` 命令则以毫秒为单位返回键的剩余生存时间：

~~~sh
redis> PEXPIREAT alphabet 1385877600000
(integer) 1
redis> TTL alphabet
(integer) 8549007
redis> PTTL alphabet
(integer) 8549001011
~~~

`TTL` 和 `PTTL` 两个命令都是通过计算键的过期时间和当前时间之间的差来实现的

### 2.5 过期键的判定

通过过期字典，程序可以用以下步骤检查一个给定键是否过期：

1. 检查给定键是否存在于过期字典：如果存在，那么取得键的过期时间。
2. 检查当前 UNIX 时间戳是否大于键的过期时间：如果是的话，那么键已经过期；否则的话，键未过期。

> **注意**
>
> 实现过期键判定的另一种方法是使用 TTL 命令或者 PTTL 命令，比如说，如果对某个键执行 TTL 命令，并且命令返回的值大于等于 0，那么说明该键未过期。在实际中，Redis 检查键是否过期的方法是通过直接访问字典，因为直接访问字典比执行一个命令稍微快一些。

## 3 过期键删除策略

我们知道，数据库键的过期时间都保存在过期字典中，而且知道如何根据过期时间去判断一个键是否过期；那么如果一个键过期了，它什么时候会被删除呢？

这个问题有三种可能的答案，它们分别代表了三种不同的删除策略：

- **定时删除**：在删除键的过期时间的同时，创建一个定时器（timer），让定时器在键的过期时间来临时，立即执行对键的删除操作。
- **惰性删除**：放任键过期不管，但是每次从键空间中获取键时，都检查取得的键是否过期，如果过期的话，就删除该键；如果没有过期，就返回该键。
- **定期删除**：每隔一段时间，程序就对数据库进行一次检查，删除里面的过期键。至于要删除多少过期键，以及要检查多少个数据库，则由算法决定。

在这三种策略中，第一种和第三种为主动删除策略，而第二种则为被动删除策略。

### 3.1 定时删除

定时删除策略对内存是最友好的：通过使用定时器，定时删除策略可以保证过期键会尽可能快地被删除，并释放过期键所占用的内存。

另一方面，定时删除策略的**缺点**是，它对 CPU 时间是最不友好的：在过期键比较多的情况下，删除过期键这一行为可能会占用相当一部分 CPU 时间，在内存不紧张但是 CPU 时间非常紧张的情况下，将 CPU 时间用在删除和当前任务无关的过期键上，无疑会对服务器的响应时间和吞吐量造成影响。

除此之外，创建一个定时器需要用到 Redis 服务器中的时间事件，而当前时间事件的实现方式——无序链表，查找一个事件的时间复杂度为 O(N)——并不能高效地处理大量时间事件。

因此，要让服务器创建大量的定时器，从而实现定时删除策略，在现阶段来说并不现实。

### 3.2 惰性删除

惰性删除策略对 CPU 时间来说是最友好的：程序只会在取出键时才对键进行过期检查，这可以保证删除过期键的操作只会在非做不可的情况下进行，并且删除的目标仅限于当前处理的键，这个策略不会再删除其他无关的过期键上花费任何 CPU 时间。

惰性删除策略的**缺点**是，它对内存是最不友好的：如果一个键已经过期，而这个键又仍然保留在数据库中，那么只要这个过期键不被删除，它所占用的内存就不会释放。

在使用惰性删除策略时，如果数据库中有非常多的过期键，而这些过期键又恰好没有被访问到的话，那么它们也许永远也不会被删除（除非用户手动执行 `FLUSHDB`），我们甚至可以将这种情况看作是一种内存泄漏——无用的垃圾数据占用了大量的内存，而服务器却不会自己去释放它们，这对于运行状态非常依赖于内存的 Redis 服务器来说，肯定不是一个好消息。

### 3.3 定期删除

从上面对定时删除和惰性删除的讨论来看，这两种删除方式在单一使用时都有明显的缺陷：

- 定时删除占用太多 CPU 时间，影响服务器的响应时间和吞吐量。
- 惰性删除浪费太多内存，有内存泄漏的危险。

定期删除策略是前两种策略的一种整合和折中：

- 定期删除策略每隔一段时间执行一次删除过期键操作，并通过限制删除操作执行的时长和频率来减少删除操作对 CPU 时间的影响。
- 除此之外，通过定期删除过期键，定期删除策略有效地减少了因为过期键而带来的内存浪费。

定期删除策略的**难点**是确定删除操作执行的时长和频率：

- 如果删除操作执行得太频繁，或者执行的时间太长，定期删除策略就会退化成定时删除策略，以至于将 CPU 时间过多地消耗在删除过期键上面。
- 如果删除操作执行得太少，或者执行的时间太短，定期删除策略又会和惰性删除策略一样，出现浪费内存的情况。

因此，如果采用定期删除策略的话，服务器必须根据情况，合理地设置删除操作的执行时长和执行频率。

## 4 Redis 的过期键删除策略

前一节，我们讨论了定时删除、惰性删除和定期删除三种过期键删除策略，**Redis 服务器实际使用的是惰性删除和定期删除两种策略**：通过配合使用这两种删除策略，服务器可以很好地在合理使用 CPU 时间和避免浪费内存空间之间取得平衡。

### 4.1 惰性删除策略的实现

过期键的惰性删除策略由 `db.c/expireIfNeeded` 函数实现，所有读写数据库的 Redis 命令在执行之前都会调用 `expireIfNeeded` 函数对输入键进行检查：

- 如果输入键已经过期，那么 `expireIfNeeded` 函数将输入键从数据库中删除。
- 如果输入键未过期，那么 `expireIfNeeded` 函数不做动作。

`expireIfNeeded` 函数就像一个过滤器，它可以在命令真正执行之前，过滤掉过期的输入键，从而避免命令接触到过期键。

另外，因为每个被访问的键都可能因为过期而被 `expireIfNeeded` 函数删除，所以每个命令的实现函数都必须能同时处理键存在以及键不存在这两种情况：

- 当键存在时，命令按照键存在的情况执行。
- 当键不存在或者键因为过期而被 `expireIfNeeded` 函数删除时，命令按照键不存在的情况执行。

### 4.2 定期删除策略的实现

过期键的定期删除策略由 `redis.c/activeExpireCycle` 函数实现，每当 Redis 的服务器周期性操作 `redis.c/serverCron` 函数执行时，`activeExpireCycle` 函数就会被调用，它在规定的时间内，分多次遍历服务器中的各个数据库，从数据库的 `expires` 字典中随机检查一部分键的过期时间，并删除其中的过期键。

`activeExpireCycle` 函数的工作模式可以总结如下：

- 函数每次运行时，都从一定数量的数据库中取出一定数量的随机键进行检查，并删除其中的过期键。
- 全局变量 `current_db` 会记录当前 `activeExpireCycle` 函数检查的进度，并在下一次 `activeExpireCycle` 函数调用时，接着上一次的进度进行处理。
- 随着 `activeExpireCycle` 函数的不断执行，服务器中的所有数据库都会被检查一遍，这时函数将 `current_db` 变量重置为 0，然后再次开始新一轮的检查工作。

## 5 AOF、RDB 和复制功能对过期键的处理

### 5.1 生成 RDB 文件

在执行 `SAVE` 命令或者 `BGSAVE` 命令创建一个新的 RDB 文件时，程序会对数据库中的键进行检查，已过期的键不会被保存到新创建的 RDB 文件中。

因此，数据库中包含过期键不会对生成新的 RDB 文件造成影响。

### 5.2 载入 RDB 文件

在启动 Redis 服务器时，如果服务器开启了 RDB 功能，那么服务器将对 RDB 文件进行载入：

- 如果服务器以主服务器模式运行，那么在载入 RDB 文件时，程序会对文件中保存的键进行检查，未过期的键会被载入到数据库中，而过期键则会被忽略，所以过期键对载入 RDB 文件的主服务器不会造成影响。
- 如果服务器以从服务器模式运行，那么在载入 RDB 文件时，文件中保存的所有键，不论是否过期，都会被载入到数据库中。不过，因为主从服务器在进行数据同步的时候，从服务器的数据库就会被清空，所以一般来讲，过期键对载入 RDB 文件的从服务器也不会造成影响。

### 5.3 AOF 文件写入

当服务器以 AOF 持久化模式运行时，如果数据库中的某个键已经过期，但它还没有被惰性删除或者定期删除，那么 AOF 文件不会因为这个过期键而产生任何影响。

当过期键被惰性删除或者定期删除之后，程序会向 AOF 文件追加（append）一条 DEL 命令，来显式地记录该键已被删除。

> 举个例子，如果客户端使用 `GET message` 命令，视图访问过期的 message 键，那么服务器将执行以下三个动作：
>
> 1. 从数据库中删除 message 键。
> 2. 追加一条 `DEL message` 命令到 AOF 文件。
> 3. 向执行 GET 命令的客户端返回空回复。

### 5.4 AOF 重写

和生成 RDB 文件时类似，在执行 AOF 重写的过程中，程序会对数据库中的键进行检查，已过期的键不会被保存到重写后的 AOF 文件中。

因此，数据库中包含过期键不会对 AOF 重写造成影响。

### 5.5 复制

当服务器运行在复制模式下时，从服务器的过期键删除动作由主服务器控制：

- 主服务器在删除一个过期键之后，会显式地向所有从服务器发送一个 DEL 命令，告知从服务器删除这个过期键。
- 从服务器在执行客户端发送的读命令时，即使碰到过期键也不会将过期键删除，而是继续像处理未过期的键一样来处理过期键。
- 从服务器只有在接到主服务器发来的 DEL 命令之后，才会删除过期键。

通过由主服务器来控制从服务器统一地删除过期键，可以保证主从服务器数据的一致性，也正是因为这个原因，当一个过期键仍然存在于主服务器的数据库时，这个过期键在从服务器里的复制品也会继续存在。

> 举个例子，有一对主从服务器，它们的数据库中都保存着同样的三个键 message、xxx 和 yyy，其中 message 为过期键。
>
> 如果这时有客户端向从服务器发送命令 `GET message`，那么从服务器将发现 message 键已经过期，但从服务器并不会删除 message 键，而是继续将 message 键的值返回给客户端，就好像 message 键并没有过期一样。
>
> 假设在此之后，有客户端向主服务器发送命令 `GET message`，那么主服务器将发现键 message 已经过期：主服务器会删除 message 键，向客户端返回空回复，并向从服务器发送 `DEL message` 命令。
>
> 从服务器在收到主服务器发来的 `DEL message` 命令之后，也会从数据库中删除 message 键，在这之后，主从服务器都不再保存过期键 message 了。

# 参考文档

- 《Redis 深度历险：核心原理和应用实践》扩展 4：朝生暮死——过期策略
- 《Redis 设计与实现》9.4 设置键的生存时间或过期时间 ~ 9.7 AOF、RDB 和复制功能对过期键的处理