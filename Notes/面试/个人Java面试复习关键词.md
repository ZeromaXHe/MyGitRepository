# JVM

## 调优

## 参数

# 多线程

## 进程通信

- 管道( pipe )：
  - 管道是一种半双工的通信方式，数据只能单向流动，而且只能在具有亲缘关系的进程间使用。进程的亲缘关系通常是指父子进程关系。
- 有名管道 (namedpipe) ：
  - 有名管道也是半双工的通信方式，但是它允许无亲缘关系进程间的通信。
- 信号量(semophore ) ：
  - 信号量是一个计数器，可以用来控制多个进程对共享资源的访问。它常作为一种锁机制，防止某进程正在访问共享资源时，其他进程也访问该资源。因此，主要作为进程间以及同一进程内不同线程之间的同步手段。
- 消息队列( messagequeue ) ：
  - 消息队列是由消息的链表，存放在内核中并由消息队列标识符标识。消息队列克服了信号传递信息少、管道只能承载无格式字节流以及缓冲区大小受限等缺点。
- 信号 (sinal ) 
  - 信号是一种比较复杂的通信方式，用于通知接收进程某个事件已经发生。
- 共享内存(shared memory ) ：
  - 共享内存就是映射一段能被其他进程所访问的内存，这段共享内存由一个进程创建，但多个进程都可以访问。共享内存是最快的 IPC 方式，它是针对其他进程间通信方式运行效率低而专门设计的。它往往与其他通信机制，如信号两，配合使用，来实现进程间的同步和通信。
- 套接字(socket ) ：
  - 套接口也是一种进程间通信机制，与其他通信机制不同的是，它可用于不同设备及其间的进程通信。

参考文档：

1. [面试官：说说进程间通信和线程间通信的几种方式及区别 - 知乎](https://zhuanlan.zhihu.com/p/430069448)

## 线程通信

- 锁机制：包括互斥锁、条件变量、读写锁
- 信号量机制(Semaphore)：包括无名线程信号量和命名线程信号量
- 信号机制(Signal)：类似进程间的信号处理

参考文档：

1. [面试官：说说进程间通信和线程间通信的几种方式及区别 - 知乎](https://zhuanlan.zhihu.com/p/430069448)

## 线程和进程区别

- 调度：
  - 线程作为处理器调度和分配的基本单位
  - 而进程是作为拥有资源的基本单位
- 并发性
  - 不仅进程之间可以并发执行
  - 同一个进程的多个线程之间也可以并发执行
- 拥有资源
  - 进程是拥有资源的一个独立单位，有自己独立的地址空间
  - 线程不拥有系统资源，但可以访问隶属于进程的资源，共享进程的地址空间.
- 系统开销
  - 在创建或撤消进程时，由于系统都要为之分配和回收资源，导致系统的开销明显大于创建或撤消线程时的开销。

参考文档：

1. [操作系统：进程与线程之间的区别及联系](https://zhuanlan.zhihu.com/p/505594640)

## 查看线程/进程 CPU 使用率

- 那么首先需要获取这个进程的PID: `ps -ef| grep [process name]`
- 然后查看该进程的CPU: `top -p [PID]`
  - `-p <进程ID>`：仅显示指定进程ID的信息。
- 查看这个进程的各个进程的CPU: `top -H -p [PID]`
  - `-H`：在进程信息中显示线程详细信息。
  - `-d <秒数>`：指定 top 命令的刷新时间间隔，单位为秒。

参考文档：

1. [linux 下查看某一进程的cpu使用率和这个线程中各个线程的cpu使用率 - CSDN](https://blog.csdn.net/learners_sjt/article/details/82461079)
2. [Linux top 命令 - RUNOOB](https://www.runoob.com/linux/linux-comm-top.html)

# Spring

## 循环依赖

三层缓存

- 加入 singletonFactories 三级缓存的前提是**执行了构造器**，所以构造器的循环依赖无法解决。

三层缓存：

- singletonObjects
- earlySingletonObjects
- singletonFactories

```java
public class DefaultSingletonBeanRegistry extends SimpleAliasRegistry implements SingletonBeanRegistry {
	...
	// 从上至下 分表代表这“三级缓存”
	private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>(256); //一级缓存，存放完全实例化且属性赋值完成的 Bean ，可以直接使用
	private final Map<String, Object> earlySingletonObjects = new HashMap<>(16); // 二级缓存，存放早期 Bean 的引用，尚未装配属性的 Bean
	private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<>(16); // 三级缓存，存放实例化完成的 Bean 工厂
    ...
	
	/** Names of beans that are currently in creation. */
	// 这个缓存也十分重要：它表示bean创建过程中都会在里面呆着~
	// 它在Bean开始创建时放值，创建完成时会将其移出~
	private final Set<String> singletonsCurrentlyInCreation = Collections.newSetFromMap(new ConcurrentHashMap<>(16));

	/** Names of beans that have already been created at least once. */
	// 当这个Bean被创建完成后，会标记为这个 注意：这里是set集合 不会重复
	// 至少被创建了一次的  都会放进这里~~~~
	private final Set<String> alreadyCreated = Collections.newSetFromMap(new ConcurrentHashMap<>(256));
    ...
	@Override
	@Nullable
	public Object getSingleton(String beanName) {
		return getSingleton(beanName, true);
	}
	@Nullable
	protected Object getSingleton(String beanName, boolean allowEarlyReference) {
		//1.先从一级缓存中获取，获取到直接返回
		Object singletonObject = this.singletonObjects.get(beanName);
		//2.如果获取不到或对象正在创建，就到二级缓存中去获取，获取到直接返回
		if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
			synchronized (this.singletonObjects) {
				singletonObject = this.earlySingletonObjects.get(beanName);
				//3.如果仍获取不到，且允许 singletonFactories(allowEarlyCurrentlyInCreation()）通过 getObject()获取。
				//就到三级缓存中用 getObject() 获取。
				//获取到就从 singletonFactories中移出，且放进 earlySingletonObjects。
				//（即从三级缓存移动到二级缓存）
				if (singletonObject == null && allowEarlyReference) {
					ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
					if (singletonFactory != null) {
						singletonObject = singletonFactory.getObject();
						this.earlySingletonObjects.put(beanName, singletonObject);
						this.singletonFactories.remove(beanName);
					}
				}
			}
		}
		return singletonObject;
	}
	...
	public boolean isSingletonCurrentlyInCreation(String beanName) {
		return this.singletonsCurrentlyInCreation.contains(beanName);
	}
	protected boolean isActuallyInCreation(String beanName) {
		return isSingletonCurrentlyInCreation(beanName);
	}
	...
}
```

getBean() -> doGetBean() -> createBean() -> doCreateBean() -> 返回 Bean

创建 Bean 的三个核心方法

- createBeanInstance()：例化，即调用对象的构造方法实例化对象
- populateBean()：填充属性，主要对 bean 的依赖属性注入（@Autowired）
- initializeBean()：回到一些如initMethod，InitalizingBean等方法



为什么是三层不是两层：考虑 AOP 代理对象

1. 假设去掉三级缓存：在实例化阶段就得执行后置处理器，判断有 AnnotationAwareAspectJAutoProxyCreator 并创建代理对象。
2. 假设去掉二级缓存：如果去掉了二级缓存，则需要直接在 `singletonFactory.getObject()` 阶段初始化完毕，并放到一级缓存中。那有这么一种场景，B 和 C 都依赖了 A。而多次调用 `singletonFactory.getObject()` 返回的代理对象是不同的，就会导致 B 和 C 依赖了不同的 A。



**参考文档**

1. [彻底搞懂Spring之三级缓存解决循环依赖问题 - 知乎](https://zhuanlan.zhihu.com/p/610322151)

# MySQL

## 索引类型

- 索引按照**物理实现**方式，索引可以分为 2 种：**聚簇（聚集）**和**非聚簇（非聚集）**索引。
  - 我们也把非聚簇索引称为**二级索引**或者**辅助索引**。
  - 以多个列的大小为排序规则建立的 B+ 树称为**联合索引**，本质上也是一个二级索引。
- 按照**功能逻辑**区分，MySQL目前主要有以下索引类型：
  - **主键索引**
    - 数据列不允许重复，不允许为 NULL，一个表只能有一个主键。
    - `ALTER TABLE table_name ADD PRIMARY KEY (column);`
  - **普通索引**
    - MySQL中基本索引类型，没有什么限制，允许在定义索引的列中插入重复值和NULL值。一个表允许多个列创建普通索引。
    - `ALTER TABLE table_name ADD INDEX index_name (column);`
  - **唯一索引**
    - 索引列中的值必须是唯一的，但是允许NULL值。建立唯一索引的目的大部分时候都是为了该属性列的数据的唯一性，而不是为了查询效率。一个表允许多个列创建唯一索引。
    - `ALTER TABLE table_name ADD UNIQUE (column);`
  - **全文索引**
    - 主要是为了快速检索大文本数据中的关键字的信息。字段长度比较大时，如果创建普通索引，在进行like模糊查询时效率比较低，这时可以创建全文索引，基于倒排索引，类似于搜索引擎。MyISAM存储引擎支持全文索引，InnoDB 存储引擎在 MySQL 5.6.4 版本中也开始支持全文索引。
    - `ALTER TABLE table_name ADD FULLTEXT (column);`
  - **前缀索引**
    - 在文本类型如BLOB、TEXT或者很长的VARCHAR列上创建索引时，可以使用前缀索引，数据量相比普通索引更小，可以指定索引列的长度，但是数值类型不能指定。
    - `ALTER TABLE table_name ADD KEY(column_name(prefix_length));`
  - **组合索引**
    - 指多个字段上创建的索引，只有在查询条件中使用了创建索引时的第一个字段，索引才会被使用。使用组合索引时遵循最左前缀原则。
    - 主键索引、普通索引、唯一索引等都可以使用多个字段形成组合索引。例如，`ALTER TABLE table_name ADD INDEX index_name ( column1, column2, column3 );`
  - **空间索引**
    - MySQL在5.7之后的版本支持了空间索引，而且支持OpenGIS几何数据模型。MySQL在空间索引这方面遵循OpenGIS几何数据模型规则。

参考文档

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P118
2. [MySQL索引的概念以及七种索引类型介绍 - CSDN](https://blog.csdn.net/weixin_43767015/article/details/119109385)

## 表级锁

- **1、表级别的 S 锁、X 锁**

  - MyISAM 在执行查询语句（SELECT）前，会给涉及的所有表加读锁，在执行增删改操作前，会给涉及的表加写锁。InnoDB 存储引擎是不会为这个表添加表级别的**读锁**或者**写锁**的。
    - 一般情况下，不会使用 InnoDB 存储引擎提供的表级别的 **S 锁**和 **X 锁**。只会在一些特殊情况下，比方说**崩溃恢复**过程中用到。比如，在系统变量 `autocommit=0, innodb_table_locks = 1` 时，**手动**获取 InnoDB 存储引擎提供的表 t 的 **S 锁**或者 **X 锁**可以这么写：
      - `LOCK TABLES t READ`：InnoDB 存储引擎会对表 `t` 加表级别的 **S 锁**
      - `LOCK TABLES t WRITE`：InnoDB 存储引擎会对表 `t` 加表级别的 **X 锁**
    - 不过尽量避免在使用 InnoDB 存储引擎的表上使用 `LOCK TABLES` 这样的手动锁表语句，它们并不会提供什么额外的保护，只是会降低并发能力而已。InnoDB 的厉害之处还是实现了更细粒度的**行锁**，关于 InnoDB 表级别的 **S 锁**和 **X 锁**大家了解一下就可以了。

- **2、意向锁（Intention lock）**

  - InnoDB 支持**多粒度锁（multiple granularity locking）**, 它允许**行级锁**与**表级锁**共存，而**意向锁**就是其中的一种**表锁**。

    1. 意向锁的存在是为了协调行锁和表锁的关系，支持多粒度（表锁与行锁）的锁并存。
    2. 意向锁是一种**不与行级锁冲突表级锁**，这一点非常重要。
    3. 表明“某个事务正在某些行持有了锁或该事务准备去持有锁”

  - 意向锁分为两种：

    - **意向共享锁**（intention shared lock，IS）：事务有意向对表中的某些行加**共享锁**（S 锁）

      ```mysql
      -- 事务要获取某些行的 S 锁，必须先获得表的 IS 锁。
      SELECT column FROM table ... LOCK IN SHARE MODE;
      ```

    - **意向排他锁**（intention exclusive lock，IX）：事务有意向对表中的某些行加**排他锁**（X 锁）

      ```mysql
      -- 事务要获取某些行的 X 锁，必须先获得表的 IX 锁
      SELECT column FROM table ... FOR UPDATE;
      ```

  - 首先，我们需要知道意向锁之间的兼容互斥性，如下所示。

    |                  | 意向共享锁（IS） | 意向排他锁（IX） |
    | ---------------- | ---------------- | ---------------- |
    | 意向共享锁（IS） | 兼容             | 兼容             |
    | 意向排他锁（IX） | 兼容             | 兼容             |

    即意向锁之间是互相兼容的，虽然意向锁和自家兄弟互相兼容，但是它会与普通的排他/共享锁互斥。

    |              | 意向共享锁（IS） | 意向排他锁（IX） |
    | ------------ | ---------------- | ---------------- |
    | 共享锁（IS） | 兼容             | 互斥             |
    | 排他锁（IX） | 互斥             | 互斥             |

    注意这里的排他/共享锁指的都是表锁，**意向锁不会与行级的共享/排他锁互斥**。

  - 并发性

    - 意向锁不会与行级的共享/排他锁互斥！正因为如此，意向锁并不会影响到多个事务对不同数据行加排他锁的并发性。（不然我们直接用普通的表锁就行了）

- **3、自增锁（AUTO-INC 锁）**

  - 在使用 MySQL 过程中，我们可以为表的某个列添加 `AUTO_INCREMENT` 属性；由于这个表的 id 字段声明了 AUTO_INCREMENT，意味着在书写插入语句时不需要为其赋值

  - 所有插入数据的方式总共分为三类，分别是“`Simple inserts`”，“`Bulk inserts`” 和 “`Mixed-mode inserts`”。

    1. **“Simple inserts”（简单插入）**

       可以**预先确定要插入和行数**（当语句被初始处理时）的语句。包括没有嵌套子查询的单行和多行 `INSERT ... VALUES()` 和 `REPLACE` 语句。比如我们上面举的例子就属于该类插入，已经确定要插入的行数。

    2. **“Bulk inserts”（批量插入）**

       **事先不知道要插入的行数**（和所需自动递增的数量）的语句。比如 `INSERT ... SELECT`, `REPLACE ... SELECT` 和 `LOAD DATA` 语句，但不包括纯 INSERT。InnoDB 在每处理一行，为 AUTO_INCREMENT 列分配一个新值。

    3. **“Mixed-mode inserts”（混合模式插入）**

       这些是“Simple inserts”语句但是指定部分新行的自动递增值。例如 `INSERT INTO teacher (id, name) VALUES (1, 'a'), (NULL, 'b'), (5, 'c'), (NULL, 'd');` 只是指定了部分 id 的值。另一种类型的“混合模式插入”是 `INSERT ... ON DUPLICATE KEY UPDATE`。

  - 对于上面数据插入的案例，MySQL 中采用了**自增锁**的方式来实现，**AUTO-INC 锁是当向使用 AUTO_INCREMENT 列的表中插入数据时需要获取的一种特殊的表级锁**，在执行插入语句时就在表级别加一个 AUTO-INC 锁，然后为每条待插入记录的 AUTO_INCREMENT 修饰的列分配递增的值，在该语句执行结束后，再把 AUTO-INC 锁释放掉。

    - **一个事务在持有 AUTO-INC 锁的过程中，其他事务的插入语句都要被阻塞**，可以保证一个语句中分配的递增值是连续的。

    - 也正因为此，其并发性显然并不高，**当我们向一个有 AUTO_INCREMENT 关键字的主键插入值的时候，每条语句都要对这个表锁进行竞争**，这样的并发潜力其实是很低下的，所以 innodb 通过 `innodb_autoinc_lock_mode` 的不同取值来提供不同的锁定机制，来显著提高 SQL 语句的可伸缩性和性能。

      - **（1）innodb_autoinc_lock_mode = 0（“传统”锁定模式）**

        在此锁定模式下，所有类型的 insert 语句都会获得一个特殊的表级 AUTO-INC 锁，用于插入具有 AUTO_INCREMENT 列的表。

      - **（2）innodb_autoinc_lock_mode = 1（“连续”锁定模式）**

        在 MySQL 8.0 之前，连续锁定模式是**默认**的。

        在这个模式下，“bulk inserts”仍然使用 AUTO-INC 表级锁，并保持到语句结束。

        对于“Simple inserts”（要插入的行数事先已知），则通过在 `mutex（轻量锁）`的控制下获得所需数量的自动递增值来避免表级 AUTO-INC 锁，它只在分配过程的持续时间内保持，而不是直到语句完成。不使用表级 AUTO-INC 锁，除非 AUTO-INC 锁由另一个事务保持。如果另一个事务保持 AUTO-INC 锁，则“Simple inserts”等待 AUTO-INC 锁，如同它是一个“bulk inserts”

      - **（3）innodb_autoinc_lock_mode = 2（“交错”锁定模式）**

        从 MySQL 8.0 开始，交错锁模式是**默认**设置。

        在这种锁定模式下，所有类 INSERT 语句都不会使用表级 AUTO-INC 锁，并且可以同时执行多个语句。这是最快和最可扩展的锁定模式，但是当使用基于语句的复制或恢复方案时，**从二进制日志重播 SQL 语句时，这是不安全的**。

- **4、元数据锁（MDL 锁）**

  - MySQL 5.5 引入了 meta data lock，简称 MDL 锁，属于表锁范畴。
  - MDL 的作用是，保证读写的正确性。
    - 比如，如果一个查询正在遍历一个表中的数据，而执行期间另一个线程对这个**表结构做变更**，增加了一列，那么查询线程拿到的结果跟表结构对不上，肯定是不行的。
  - 因此，**当对一个表做增删改查操作的时候，加 MDL 读锁；当要对表做结构变更操作的时候，加 MDL 写锁。**
  - **不需要显式使用**，在访问一个表的时候会被自动加上。

参考文档：

1. [尚硅谷《MySQL数据库入门到大牛》笔记.md](../视频笔记/尚硅谷《MySQL数据库入门到大牛》笔记.md) P175 ~ 176

## 防范 SQL 注入

1. JDBC 的 PreparedStatement

   - 采用预编译语句集，它内置了处理SQL注入的能力

2. 使用 MyBatis 的 #

   - \# 将传入的数据都当成一个字符串，会对自动传入的数据加一个双引号。

   - $ **将传入的数据直接显示生成在sql中。**

   - MyBatis是如何做到SQL预编译的呢？

     其实在框架底层，是JDBC中的PreparedStatement类在起作用，PreparedStatement是我们很熟悉的Statement的子类，它的对象包含了编译好的SQL语句。

     - 简单说，#{}是经过预编译的，是安全的；
     - ${}是未经过预编译的，仅仅是取变量的值，是非安全的，存在SQL注入。

# Redis

## 数据结构

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

参考文档：

1. [《尚硅谷Redis零基础到进阶》笔记.md](../视频笔记/《尚硅谷Redis零基础到进阶》笔记.md) P11

## 底层数据结构

- redis 6 类型-物理编码-对应表

  - （1：04）

    | 类型         | 编码                      | 对象                                             |
    | ------------ | ------------------------- | ------------------------------------------------ |
    | REDIS_STRING | REDIS_ENCODING_INT        | 使用整数值实现的字符串对象                       |
    | REDIS_STRING | REDIS_ENCODING_EMBSTR     | 使用 embstr 编码的简单动态字符串实现的字符串对象 |
    | REDIS_STRING | REDIS_ENCODING_RAW        | 使用简单动态字符串实现的字符串对象               |
    | REDIS_LIST   | REDIS_ENCODING_ZIPLIST    | 使用压缩列表实现的列表对象                       |
    | REDIS_LIST   | REDIS_ENCODING_LINKEDLIST | 使用双端链表实现的列表对象                       |
    | REDIS_HASH   | REDIS_ENCODING_ZIPLIST    | 使用压缩列表实现的哈希对象                       |
    | REDIS_HASH   | REDIS_ENCODING_HT         | 使用字典实现的哈希对象                           |
    | REDIS_SET    | REDIS_ENCODING_INTSET     | 使用整数集合实现的集合对象                       |
    | REDIS_SET    | REDIS_ENCODING_HT         | 使用字典实现的集合对象                           |
    | REDIS_ZSET   | REDIS_ENCODING_ZIPLIST    | 使用压缩列表实现的有序集合对象                   |
    | REDIS_ZSET   | REDIS_ENCODING_SKIPLIST   | 使用跳跃表和字典实现的有序集合对象               |

- redis 6 数据类型对应的底层数据结构

  - （1：57）

    1. 字符串

       **int**：8 个字节的长整型

       **embstr**：小于等于 44 个字节的字符串

       **raw**：大于 44 个字节的字符串

       - embstr 与 raw 类型底层的数据结构其实都是 SDS（简单动态字符串，Redis 内部定义 sdshdr 一种结构）。

    2. 哈希

       **ziplist**（压缩列表）：当哈希类型元素小于 hash-max-ziplist-entries 配置（默认 512 个）、同时所有值都小于 hash-max-ziplist-value 配置（默认 64 字节）时，Redis 会使用 ziplist 作为哈希的内部实现，ziplist 使用更加紧凑的结构实现多个元素的连续存储。所以在节省内存方面比 hashtable 更加优秀

       **hashtable**（哈希表）：当哈希类型无法满足 ziplist 的条件时，Redis 会使用 hashtable 作为哈希的内部实现，因为此时 ziplist 的读写效率会下降，而 hashtable 的读写时间复杂度为 O(1)

    3. 列表

       **ziplist**（压缩列表）：当列表的元素个数小于 list-max-ziplist-entries 配置（默认 512 个），同时列表中每个元素的值都小于 list-max-ziplist-value 配置时（默认 64 字节），Redis 会选用 ziplist 来作为列表的内部实现来减少内存的使用。

       **linkedlist**（链表）：当列表类型无法满足 ziplist 的条件时，Redis 会使用 linkedlist 作为列表的内部实现。

       3.2 版本之后只有使用：**quicklist**：ziplist 和 linkedlist 的结合以 ziplist 为节点的链表

    4. 集合

       **intset**（整数集合）：当集合中的元素都是整数且元素个数小于 set-max-intset-entries 配置（默认 512 个）时，Redis 会用 intset 来作为集合的内部实现，从而减少内存的使用。

       **hashtable**（哈希表）：当集合类型无法满足 intset 的条件时，Redis 会使用 hashtable 作为集合的内部实现

    5. 有序集合

       **ziplist**（压缩列表）：当有序集合的元素个数小于 zset-max-ziplist-entries 配置（默认 128 个），同时每个元素的值都小于 zset-max-ziplist-value 配置（默认 64 字节）时，Redis 会用 ziplist 来作为有序集合的内部实现，ziplist 可以有效减少内存的使用

       **skiplist**（跳跃表）：当 ziplist 条件不满足时，有序集合会使用 skiplist 作为内部实现，因为此时 ziplist 的读写效率会下降

- redis 6 数据类型以及数据结构的关系（2：35）

- redis 7 数据类型以及数据结构的关系（2：52）

  - ziplist -> listpack（所有地方，包括 quicklist 内）

  - listpack 避免了 ziplist 的连锁更新的问题

- redis 数据类型以及数据结构的时间复杂度（3：24）

参考文档：

1. [《尚硅谷Redis零基础到进阶》笔记.md](../视频笔记/《尚硅谷Redis零基础到进阶》笔记.md) P163

## 单线程 / 多线程

- Redis 3.x 单线程时代但性能依旧很快的主要原因

  - 基于内存操作：Redis 的所有数据都存在内存中，因此所有的运算都是内存级别的，所以他的性能比较高；
  - 数据结构简单：Redis 的数据结构是专门设计的，而这些简单的数据结构的查找和操作的时间大部分复杂度都是 O(1)，因此性能比较高；
  - 多路复用和非阻塞 I/O：Redis 使用 I/O 多路复用功能来监听多个 socket 连接客户端，这样就可以使用一个线程连接来处理多个请求，减少线程切换带来的开销，同时也避免了 I/O 阻塞操作
  - 避免上下文切换：因为是单线程模型，因此就避免了不必要的上下文切换和多线程竞争，这就省去了多线程切换带来的时间和性能上的消耗，而且单线程不会导致死锁问题的发生

- **Redis 4.0 之前**一直采用单线程的主要原因有以下三个

  1. 使用单线程模型是 Redis 的开发和维护更简单，因为单线程模型方便开发和调试
  2. 即使使用单线程模型也并发的处理多客户端的请求，主要使用的是 IO 多路复用和非阻塞 IO
  3. 对于 Redis 系统来说，**主要的性能瓶颈是内存或者网络带宽而并非 CPU**.

- Redis 是基于内存操作的，**因此他的瓶颈可能是机器的内存或者网络带宽而并非 CPU**，既然 CPU 不是瓶颈，那么自然就采用单线程的解决方案了，况且使用多线程比较麻烦。**但是在 Redis 4.0 中开始支持多线程了，例如后台删除、备份等功能**。

  - RDB bgsave
  - AOF 重写
  - 惰性删除
    - 大 key 问题
    - 在 Redis 4.0 就引入了多个线程来实现数据的异步惰性删除等功能，但是其处理读写请求的仍然只有一个线程，所以仍然算是狭义上的单线程。

- **在 Redis 6/7 中，非常受关注的第一个新特性就是多线程**。

  - 随着网络硬件的性能提升，Redis 的性能瓶颈有时会出现在网络 IO 的处理上，也就是说，单个主线程处理网络请求的速度跟不上底层网络硬件的速度

  - 为了应对这个问题：**采用多个 IO 线程来处理网络请求，提高网络请求处理的并行度，Redis 6/7 就是采用的这种方法**。

  - 但是，Redis 的多 IO 线程只是用来处理网络请求的，**对于读写操作命令 Redis 仍然使用单线程来处理**

    - 这是因为，Redis 处理请求时，网络处理经常是瓶颈，通过多个 IO 线程并行处理网络操作，可以提升实例的整体处理性能。而继续使用单线程执行命令操作，就不用为了保证 Lua 脚本、事务的原子性，额外开发多线程**互斥加锁机制了（不管加锁操作处理）**，这样一来，Redis 线程模型实现就简单了。

  - 主线程和 IO 线程四个阶段

    - **阶段一：服务端和客户端建立 Socket 连接，并分配处理线程**

      首先，主线程负责接收建立连接请求。当有客户端请求和实例建立 Socket 连接时，主线程会创建和客户端的连接，并把 Socket 放入全局等待队列中。紧接着，主线程通过轮询方法把 Socket 连接分配给 IO 线程。

    - **阶段二：IO 线程读取并解析请求**

      主线程一旦把 Socket 分配给 IO 线程，就会进入阻塞状态，等待 IO 线程完成客户端请求读取和解析。因为有多个 IO 线程在并行处理。所以，这个过程很快就可以完成。

    - **阶段三：主线程执行请求操作**

      等到 IO 线程解析完请求，主线程还是会以单线程的方式执行这些命令操作。

    - **阶段四：IO 线程回写 Socket 和主线程清空全局队列**

      当主线程执行完请求操作后，会把需要返回的结果写入缓冲区，然后，主线程会阻塞等待 IO 线程，把这些结果回写到 Socket 中，并返回给客户端。和 IO 线程读取和解析请求一样，IO 线程回写 Socket 时，也是有多个线程在并发执行，所以回写 Socket 的速度也很快。等到 IO 线程回写 Socket 完毕，主线程会清空全局队列，等待客户端和后续请求。

- Redis 采用 **Reactor 模式**的网络模型，对于一个客户端请求，主线程负责一个完整的处理过程：

  读取 socket -> 解析请求 -> 执行操作 -> 写入 socket

参考文档：

1. [《尚硅谷Redis零基础到进阶》笔记.md](../视频笔记/《尚硅谷Redis零基础到进阶》笔记.md) P101 ~ 102

## 持久化（RDB、AOF）

- RDB（Redis DataBase）

  - 自动触发

    - Redis 6.0.16 以下在 Redis.conf 配置文件中的 SNAPSHOTTING 下配置 save 参数，来触发 Redis 的 RDB 持久化条件，比如 “save m n”：表示 m 秒内数据集存在 n 次修改时，自动触发 bgsave

      - save 900 1：每隔 900s（15min），如果有超过 1 个 key 发生了变化，就写一份新的 RDB 文件

        save 300 10：每隔 300s（5min），如果有超过 10 个 key 发生了变化，就写一份新的 RDB 文件

        save 60 10000：每隔 60s（1min），如果有超过 10000 个 key 发生了变化，就写一份新的 RDB 文件

    - Redis 7 版本，按照 redis.conf 里配置的 `save <seconds> <changes>`

  - 手动触发

    - save（阻塞） 和 bgsave（默认，fork 子线程来持久化）

  - 如何恢复

    - 将备份文件（dump.rdb）移动到 redis 安装目录并启动服务即可

  - 如何检查修复 dump.rdb 文件

    - `redis-check-rdb /myredis/dumpfiles/dump6379.rdb`

- AOF（Append Only File）

  - 三种写回策略

    - | 配置项   | 写回时机           | 优点                     | 缺点                             |
      | -------- | ------------------ | ------------------------ | -------------------------------- |
      | Always   | 同步写回           | 可靠性高，数据基本不丢失 | 每个写命令都要落盘，性能影响较大 |
      | Everysec | 每秒写回           | 性能适中                 | 宕机时丢失 1 秒内的数据          |
      | No       | 操作系统控制的写回 | 性能好                   | 宕机时丢失数据较多               |

  - 重写机制

    - AOF 文件重写并不是对原文件进行重新整理，而是直接读取服务器现有的键值对，然后用一条命令去代替之前记录这个键值对的多条命令，生成一个新的文件后去替换原来的 AOF 文件

    - 自动触发

      - auto-aof-rewrite-percentage 100

        auto-aof-rewrite-min-size 64mb

        注意，**同时满足，且的关系**才会触发

    - 手动触发

      - 客户端向服务器发送 bgrewriteaof 命令

  - 异常修复命令：`redis-check-aof --fix` 进行修复

- RDB-AOF 混合持久化

  - 设置 `aof-use-rdb-preamble` 的值为 yes
  - RDB 镜像做全量持久化，AOF 做增量持久化

- 同时关闭 RDB + AOF

  - `save ""`
    - 禁用 rdb
    - 禁用 rdb 持久化模式下，我们仍然可以使用命令 save、bgsave 生成 rdb 文件
  - `appendonly no`
    - 禁用 aof
    - 禁用 aof 持久化模式下，我们仍然可以使用命令 bgrewriteaof 生成 aof 文件

参考文档：

1. [《尚硅谷Redis零基础到进阶》笔记.md](../视频笔记/《尚硅谷Redis零基础到进阶》笔记.md) P28 ~ 46

## 分布式锁（SETNX、Lua、Redisson、RedLock）

一把靠谱的分布式锁应该有哪些特征：

- **「互斥性」**: 任意时刻，只有一个客户端能持有锁。
- **「锁超时释放」**：持有锁超时，可以释放，防止不必要的资源浪费，也可以防止死锁。
- **「可重入性」**:一个线程如果获取了锁之后,可以再次对其请求加锁。
- **「高性能和高可用」**：加锁和解锁需要开销尽可能低，同时也要保证高可用，避免分布式锁失效。
- **「安全性」**：锁只能被持有的客户端删除，不能被其他客户端删除

方案：

- 方案一：SETNX + EXPIRE
  - 缺点
    - 但是这个方案中，`setnx`和`expire`两个命令分开了，**「不是原子操作」**。如果执行完`setnx`加锁，正要执行`expire`设置过期时间时，进程crash或者要重启维护了，那么这个锁就“长生不老”了，**「别的线程永远获取不到锁啦」**。
- 方案二：SETNX + value值是（系统时间+过期时间）
  - 缺点
    - 过期时间是客户端自己生成的（System.currentTimeMillis()是当前系统的时间），必须要求分布式环境下，每个客户端的时间必须同步。
    - 如果锁过期的时候，并发多个客户端同时请求过来，都执行 jedis.getSet()，最终只能有一个客户端加锁成功，但是该客户端锁的过期时间，可能被别的客户端覆盖
    - 该锁没有保存持有者的唯一标识，可能被别的客户端释放/解锁。
- 方案三：使用Lua脚本(包含SETNX + EXPIRE两条指令)
- 方案四：SET的扩展命令（SET EX PX NX）
  - 缺点
    - 问题一：**「锁过期释放了，业务还没执行完」**。假设线程a获取锁成功，一直在执行临界区的代码。但是100s过去后，它还没执行完。但是，这时候锁已经过期了，此时线程b又请求过来。显然线程b就可以获得锁成功，也开始执行临界区的代码。那么问题就来了，临界区的业务代码都不是严格串行执行的啦。
    - 问题二：**「锁被别的线程误删」**。假设线程a执行完后，去释放锁。但是它不知道当前的锁可能是线程b持有的（线程a去释放锁时，有可能过期时间已经到了，此时线程b进来占有了锁）。那线程a就把线程b的锁释放掉了，但是线程b临界区业务代码可能都还没执行完呢。
- 方案五：SET EX PX NX  + 校验唯一随机值,再释放锁
  - 缺点：
    - 方案五还是可能存在**「锁过期释放，业务没执行完」**的问题。
- 方案六: 开源框架~Redisson
  - 只要线程一加锁成功，就会启动一个`watch dog`看门狗，它是一个后台线程，会每隔10秒检查一下，如果线程1还持有锁，那么就会不断的延长锁key的生存时间。
  - 使用Redisson解决了**「锁过期释放，业务没执行完」**问题。
- 方案七：多机实现的分布式锁Redlock
  - 搞多个Redis master部署，以保证它们不会同时宕掉。并且这些master节点是完全相互独立的，相互之间不存在数据同步。同时，需要确保在这多个master实例上，是与在Redis单实例，使用相同方法来获取和释放锁。

参考文档：

1. [Redis实现分布式锁的7种方案，及正确使用姿势！ - 博客园](https://www.cnblogs.com/wangyingshuo/p/14510524.html)

## 部署方式（单机、主从复制、哨兵、集群）

- 单机模式
  - 优点
    - 架构简单，部署方便；
    - 高性价比：缓存使用时无需备用节点（单实例可用性可以用supervisor或crontab保证），当然为了满足业务的高可用性，也可以牺牲一个备用节点，但同时刻只有一个实例对外提供服务；
    - 高性能。
  - 缺点
    - 不保证数据的可靠性；
    - 在缓存使用，进程重启后，数据丢失，即使有备用的节点解决高可用性，但是仍然不能解决缓存预热问题，因此不适用于数据可靠性要求高的业务；
    - 高性能受限于单核CPU的处理能力（Redis是单线程机制），CPU为主要瓶颈，所以适合操作命令简单，排序、计算较少的场景。也可以考虑用Memcached替代。
- 主从模式（复制）
  - 优点
    - 高可靠性：一方面，采用双机主备架构，能够在主库出现故障时自动进行主备切换，从库提升为主库提供服务，保证服务平稳运行；另一方面，开启数据持久化功能和配置合理的备份策略，能有效的解决数据误操作和数据异常丢失的问题；
    - 读写分离策略：从节点可以扩展主库节点的读能力，有效应对大并发量的读操作。
  - 缺点
    - 故障恢复复杂，如果没有RedisHA系统（需要开发），当主库节点出现故障时，需要手动将一个从节点晋升为主节点，同时需要通知业务方变更配置，并且需要让其它从库节点去复制新主库节点，整个过程需要人为干预，比较繁琐；
    - 主库的写能力受到单机的限制，可以考虑分片；
    - 主库的存储能力受到单机的限制，可以考虑Pika；
    - 原生复制的弊端在早期的版本中也会比较突出，如：Redis复制中断后，Slave会发起psync，此时如果同步不成功，则会进行全量同步，主库执行全量备份的同时可能会造成毫秒或秒级的卡顿；又由于COW机制，导致极端情况下的主库内存溢出，程序异常退出或宕机；主库节点生成备份文件导致服务器磁盘IO和CPU（压缩）资源消耗；发送数GB大小的备份文件导致服务器出口带宽暴增，阻塞请求，建议升级到最新版本。
- 哨兵模式
  - 优点
    - Redis Sentinel集群部署简单；
    - 能够解决Redis主从模式下的高可用切换问题；
    - 很方便实现Redis数据节点的线形扩展，轻松突破Redis自身单线程瓶颈，可极大满足Redis大容量或高性能的业务需求；
    - 可以实现一套Sentinel监控一组Redis数据节点或多组数据节点。
  - 缺点
    - 部署相对Redis主从模式要复杂一些，原理理解更繁琐；
    - 资源浪费，Redis数据节点中slave节点作为备份节点不提供服务；
    - Redis Sentinel主要是针对Redis数据节点中的主节点的高可用切换，对Redis的数据节点做失败判定分为主观下线和客观下线两种，对于Redis的从节点有对节点做主观下线操作，并不执行故障转移。
    - 不能解决读写分离问题，实现起来相对复杂。
- 集群模式
  - 优点：
    - 无中心架构；
    - 数据按照slot存储分布在多个节点，节点间数据共享，可动态调整数据分布；
    - 可扩展性：可线性扩展到1000多个节点，节点可动态添加或删除；
    - 高可用性：部分节点不可用时，集群仍可用。通过增加Slave做standby数据副本，能够实现故障自动 failover，节点之间通过gossip协议交换状态信息，用投票机制完成Slave到Master的角色提升；
    - 降低运维成本，提高系统的扩展性和可用性。
  - 缺点：
    - Client实现复杂，驱动要求实现Smart Client，缓存slots mapping信息并及时更新，提高了开发难度，客户端的不成熟影响业务的稳定性。目前仅JedisCluster相对成熟，异常处理部分还不完善，比如常见的“max redirect exception”。
    - 节点会因为某些原因发生阻塞（阻塞时间大于clutser-node-timeout），被判断下线，这种failover是没有必要的。
    - 数据通过异步复制，不保证数据的强一致性。
    - 多个业务使用同一套集群时，无法根据统计区分冷热数据，资源隔离性较差，容易出现相互影响的情况。
    - Slave在集群中充当“冷备”，不能缓解读压力，当然可以通过SDK的合理设计来提高Slave资源的利用率。
    - Key批量操作限制，如使用mset、mget目前只支持具有相同slot值的Key执行批量操作。对于映射为不同slot值的Key由于Keys不支持跨slot查询，所以执行mset、mget、sunion等操作支持不友好。
    - Key事务操作支持有限，只支持多key在同一节点上的事务操作，当多个Key分布于不同的节点上时无法使用事务功能。
    - Key作为数据分区的最小粒度，不能将一个很大的键值对象如hash、list等映射到不同的节点。
      不支持多数据库空间，单机下的redis可以支持到16个数据库，集群模式下只能使用1个数据库空间，即db 0。
    - 复制结构只支持一层，从节点只能复制主节点，不支持嵌套树状复制结构。
    - 避免产生hot-key，导致主库节点成为系统的短板。
    - 避免产生big-key，导致网卡撑爆、慢查询等。
    - 重试时间应该大于cluster-node-time时间。
    - Redis Cluster不建议使用pipeline和multi-keys操作，减少max redirect产生的场景。

参考文档：

1. [Redis的几种部署方式及持久化策略 - CSDN](https://blog.csdn.net/zwdwinter/article/details/88636397)

## 脑裂问题

- 哨兵+主从

- 原主服务器接受到客户端的信息后，还未同步到从服务器上就是去连接了，但是重启后又由主变为了从服务器，无法同步数据了，所以这部分数据就丢失了，这就是脑裂问题

- 解决办法

  - 在配置文件中添加如下配置

    ```
    min-slaves-to-write 1
    min-slaves-max-lag 10
    ```

  - 这种方法**不可能百分百避免数据丢失**

参考文档

1. [Redis常见问题——脑裂问题 - CSDN](https://blog.csdn.net/cxy_t/article/details/110825175)

## 分布式一致性协议（Raft、Gossip）

- Raft
  - Raft是一种为分布式系统设计的共识算法，用于管理复制日志的一致性。
  - 在Redis的Sentinel模式下，Raft协议被用于选举一个Leader Sentinel来执行自动故障转移操作。
  - 在Raft协议中，节点有三种状态
    - Leader（领导）
    - Follower（跟随者）
    - Candidate（候选人）。
  - 系统的时间被划分为一个个的Term（任期），每个Term开始时，所有节点都成为Follower。
  - 如果一个Follower在一段时间内没有收到来自Leader的心跳信息，它将转变为Candidate状态并发起选举。其他节点收到选举请求后，将比较自己的Term和请求中的Term，如果请求中的Term更大，则认可该Candidate为Leader。
- Gossip
  - 在Redis Cluster模式下，Gossip协议被用于实现无中心式的节点通信。
  - Gossip协议是一种最终一致性算法，它不要求节点知道所有其他节点的状态，因此具有去中心化的特点。
    - 节点之间通过交换信息来维护系统状态的一致性，虽然无法保证在某个时刻所有节点状态一致，但可以保证在“最终”所有节点一致。
  - 在实际应用中，Redis Cluster通过Gossip协议实现了节点间的动态信息交换，包括节点状态、槽位信息等。
    - 这种去中心化的通信方式使得Redis Cluster具有很高的可扩展性和容错性。
    - 当一个节点出现故障时，其他节点可以通过Gossip协议感知到这一变化，并自动调整集群状态，保证服务的可用性。
- 这两种协议如何协同工作
  - 在Redis的分布式环境中，Sentinel和Cluster模式可以同时使用。
    - Sentinel负责监控主从节点的健康状况，并在必要时进行故障转移。
    - 而Cluster则负责数据的分片存储和负载均衡。
  - 当Sentinel检测到主节点故障时，它会通过Raft协议选举出一个Leader Sentinel来执行故障转移操作。
  - 在这个过程中，Cluster中的节点通过Gossip协议保持通信，确保集群状态的一致性。

参考文档：

1. [Redis中的分布式一致性协议：Raft与Gossip的协同工作](https://cloud.baidu.com/article/3193422)

# Linux

## 创建文件

- `touch a.txt`
- `vi a.txt`
- `vim a.txt`
- `> a.txt`
  - 覆盖
- `>> a.txt`
  - 追加
  - 两个箭头指令前面常用的
    - `echo`
    - `cat`
- `cp a.txt /test`
  - 复制一个空文件

参考文档：

1. [Linux创建文件的5种方式 - CSDN](https://blog.csdn.net/xtho62/article/details/118194873)

## IO 多路复用

epoll 是现在最先进的 IO 多路复用器，Redis、Nginx、Linux 中的 Java NIO 都使用的是 epoll

|                      | select                                                | poll                                                | epoll                                                        |
| -------------------- | ----------------------------------------------------- | --------------------------------------------------- | ------------------------------------------------------------ |
| 操作方式             | 遍历                                                  | 遍历                                                | 回调                                                         |
| 数据结构             | bitmap                                                | 数组                                                | 红黑树                                                       |
| 最大连接数           | 1024(x86) 或 2048（x64）                              | 无上限                                              | 无上限                                                       |
| 最大支持文件描述符数 | 一般有最大值限制                                      | 65535                                               | 65535                                                        |
| fd 拷贝              | 每次调用 select，都需要把 fd 集合从用户态拷贝到内核态 | 每次调用 poll，都需要把 fd 集合从用户态拷贝到内核态 | fd 首次调用 epoll_ctl 拷贝，每次调用 epoll_wait 不拷贝       |
| 工作效率             | 每次调用都进行线性遍历，时间复杂度为 O(n)             | 每次调用都进行线性遍历，时间复杂度 O(n)             | 事件通知方式，每当 fd 就绪，系统注册的回调函数就会被调用，将就绪 fd 放到 readyList 里面，时间复杂度 O(1) |

# 计算机网络

## HTTP 和 HTTPS 区别

- 加密性
  - HTTP 明文传输，数据都是未加密的，安全性较差
  - HTTPS（SSL+HTTP） 数据传输过程是加密的，安全性较好。
- 认证
  - 使用 HTTPS 协议需要到 CA（Certificate Authority，数字证书认证机构） 申请证书，一般免费证书较少，因而需要一定费用。证书颁发机构如：Symantec、Comodo、GoDaddy 和 GlobalSign 等。
- 速度
  - HTTP 页面响应速度比 HTTPS 快，主要是因为 HTTP 使用 TCP 三次握手建立连接，客户端和服务器需要交换 3 个包
  - 而 HTTPS除了 TCP 的三个包，还要加上 ssl 握手需要的 9 个包，所以一共是 12 个包。
- 端口
  - http 和 https 使用的是完全不同的连接方式，用的端口也不一样，前者是 80，后者是 443。
- 服务器资源
  - HTTPS 其实就是建构在 SSL/TLS 之上的 HTTP 协议，所以，要比较 HTTPS 比 HTTP 要更耗费服务器资源。

参考文档：

1. [HTTP 与 HTTPS 的区别 - RUNOOB](https://www.runoob.com/w3cnote/http-vs-https.html)

## HTTPS 保证安全

- HTTPS 经由 HTTP 进行通信，但利用 SSL/TLS 来加密数据包。
  - SSL：（Secure Socket Layer，安全套接字层），位于可靠的面向连接的**网络层协议**和**应用层协议**之间的一种协议层。SSL通过互相认证、使用数字签名确保完整性、使用加密确保私密性，以实现客户端和服务器之间的安全通讯。该协议由两层组成：SSL记录协议和SSL握手协议。
    - SSL是TLS的前世。
  - TLS：(Transport Layer Security，传输层安全协议)，用于两个应用程序之间提供保密性和数据完整性。该协议由两层组成：TLS 记录协议和 TLS 握手协议。
    - TLS 以 SSL 3.0 为基础于 1999 年作为 SSL 的新版本推出。
    - SSL2.0 和 SSL3.0 已经被 IEFT 组织废弃（分别在 2011 年，2015 年）多年来，在被废弃的 SSL 协议中一直存在漏洞并被发现 (e.g. POODLE, DROWN)。大多数现代浏览器遇到使用废弃协议的 web 服务时，会降低用户体验（红线穿过挂锁标志或者https表示警告）来表现。
      - 因为这些原因，你应该在服务端禁止使用 SSL 协议，仅仅保留 TLS 协议开启。
- 常规的 HTTP 通信，有以下的问题。
  1. **窃听风险**（eavesdropping）：第三方可以获知通信内容。
  2. **篡改风险**（tampering）：第三方可以修改通信内容。
  3. **冒充风险**（pretending）：第三方可以冒充他人身份参与通信。
- 因此，SSL/TLS 协议就是为了解决这三大风险而设计的，希望达到：
  1. 所有信息都是**加密传播**，第三方无法窃听。
  2. 具有**校验机制**，一旦被篡改，通信双方会立刻发现。
  3. 配备**身份证书**，防止身份被冒充。

参考文档：

1. [Https 是如何保证安全的？ - 知乎](https://zhuanlan.zhihu.com/p/110216210)

## HTTP 1.0、1.1 和 2.0 的区别

- 结论
  - 结论1：从 HTTP/1.0 到 HTTP/2，都是利用 TCP 作为底层协议进行通信的。
  - 结论2：HTTP/1.1，引进了长连接(keep-alive)，减少了建立和关闭连接的消耗和延迟。
  - 结论3：HTTP/2，引入了多路复用：连接共享，提高了连接的利用率，降低延迟。

参考文档：

1. [HTTP1.0、HTTP1.1 和 HTTP2.0 的区别 - 知乎](https://zhuanlan.zhihu.com/p/370862112)

## TCP 可靠传输

- 实现了可靠性传输
  - 检验和
    - 通过检验和的方式，接收端可以检测出来数据是否有差错和异常，假如有差错就会直接丢弃TCP段，重新发送
  - 序列号/确认应答
    - 只要发送端有一个包传输，接收端没有回应确认包（ACK包），都会重发。或者接收端的应答包，发送端没有收到也会重发数据。这就可以保证数据的完整性。
  - 超时重传
    - 超时重传是指发送出去的数据包到接收到确认包之间的时间，如果超过了这个时间会被认为是丢包了，需要重传。
  - 最大消息长度
    - 在建立TCP连接的时候，双方约定一个最大的长度（MSS）作为发送的单位，重传的时候也是以这个单位来进行重传。理想的情况下是该长度的数据刚好不被网络层分块。
  - 滑动窗口控制
    - 我们上面提到的超时重传的机制存在效率低下的问题，发送一个包到发送下一个包要经过一段时间才可以。所以我们就想着能不能不用等待确认包就发送下一个数据包呢？这就提出了一个滑动窗口的概念。
    - 窗口的大小就是在无需等待确认包的情况下，发送端还能发送的最大数据量。这个机制的实现就是使用了大量的缓冲区，通过对多个段进行确认应答的功能。通过下一次的确认包可以判断接收端是否已经接收到了数据，如果已经接收了就从缓冲区里面删除数据。
  - 拥塞控制
    - 窗口控制解决了 两台主机之间因传送速率而可能引起的丢包问题，在一方面保证了TCP数据传送的可靠性。然而如果网络非常拥堵，此时再发送数据就会加重网络负担，那么发送的数据段很可能超过了最大生存时间也没有到达接收方，就会产生丢包问题。为此TCP引入慢启动机制，先发出少量数据，就像探路一样，先摸清当前的网络拥堵状态后，再决定按照多大的速度传送数据。

参考文档：

1. [TCP的可靠性传输是如何保证的 - 知乎](https://zhuanlan.zhihu.com/p/112317245)

## TCP 三次握手

- 过程
  - **第一次握手**：
    - 客户端将TCP报文**标志位SYN置为1**，随机产生一个序号值seq=J，保存在TCP首部的序列号(Sequence Number)字段里，指明客户端打算连接的服务器的端口，并将该数据包发送给服务器端
    - 发送完毕后，客户端进入`SYN_SENT`状态，等待服务器端确认。
  - **第二次握手**：
    - 服务器端收到数据包后由标志位SYN=1知道客户端请求建立连接
    - 服务器端将TCP报文**标志位SYN和ACK都置为1**，ack=J+1，随机产生一个序号值seq=K，并将该数据包发送给客户端以确认连接请求
    - 服务器端进入`SYN_RCVD`状态。
  - **第三次握手**：
    - 客户端收到确认后，检查ack是否为 J+1，ACK是否为1，如果正确则将标志位ACK置为1，ack=K+1，并将该数据包发送给服务器端
    - 服务器端检查ack是否为K+1，ACK是否为1，如果正确则连接建立成功，客户端和服务器端进入`ESTABLISHED`状态
    - 完成三次握手，随后客户端与服务器端之间可以开始传输数据了。
- 为什么需要三次
  - 我们假设client发出的第一个连接请求报文段并没有丢失，而是在某个网络结点长时间的滞留了，以致延误到连接释放以后的某个时间才到达server。本来这是一个早已失效的报文段。但server收到此失效的连接请求报文段后，就误认为是client再次发出的一个新的连接请求。于是就向client发出确认报文段，同意建立连接。
  - 假设不采用“三次握手”，那么只要server发出确认，新的连接就建立了。由于现在client并没有发出建立连接的请求，因此不会理睬server的确认，也不会向server发送数据。但server却以为新的运输连接已经建立，并一直等待client发来数据。这样，server的很多资源就白白浪费掉了。
  - 所以，采用“三次握手”的办法可以防止上述现象发生。例如刚才那种情况，client不会向server的确认发出确认。server由于收不到确认，就知道client并没有要求建立连接。

参考文档：

1. [一文彻底搞懂 TCP三次握手、四次挥手过程及原理 - 知乎](https://zhuanlan.zhihu.com/p/108504297)

## TCP 半连接状态

- 客户端向服务端发起连接请求，服务器第一次收到客户端的SYN之后，就会处于**SYN_RCVD状态**，此时双方还没有完全建立其连接，服务器会把此种状态下请求连接放到一个队列里，我们将这种队列称之为**半连接队列**。
- **全连接队列**就是已经完成了三次握手，建立起连接就会放到全连接队列中去，如果全连接队列满了就可能会出现丢包的现象。
- 补充关于SYN-ACK重传次数的问题
  - 服务器发送完SYN-ACK包，如果未收到客户端确认包，服务器进行首次重传，等待一段时间仍未收到客户确认包，进行第二次重传。如果重传次数超过系统规定的最大重传次数，系统将该连接信息从半连接队列中删除。
  - 每次重传等待的时间一般不同，一般是指数增长。如时间间隔是1，2，4，8

参考文档：

1. [TCP之半连接状态 - CSDN](https://blog.csdn.net/weixin_44390164/article/details/119077124)

## TCP 四次挥手

- 四次挥手即终止TCP连接，就是指断开一个TCP连接时，需要客户端和服务端总共发送4个包以确认连接的断开。

- 挥手请求可以是 Client 端，也可以是 Server 端发起的，我们假设是Client端发起：

  - **第一次挥手**： 
    - Client 端发起挥手请求，向Server端发送标志位是FIN报文段，设置序列号seq
    - 此时，Client端进入`FIN_WAIT_1`状态，这表示Client端没有数据要发送给Server端了。
  - **第二次分手**
    - Server 端收到了 Client 端发送的 FIN 报文段进入 `CLOSE_WAIT` 状态
    - Server 向 Client 端返回一个标志位是ACK的报文段，ack 设为 seq 加 1，Client 端收到后进入`FIN_WAIT_2`状态
    - Server端告诉Client端，我确认并同意你的关闭请求。
  - **第三次分手**： 
    - Server 端向 Client 端发送标志位是FIN的报文段，请求关闭连接
    - 同时 Server 端进入`LAST_ACK`状态。
  - **第四次分手** ： 
    - Client 端收到 Server 端发送的FIN报文段，向 Server 端发送标志位是 ACK 的报文段，然后 Client 端进入`TIME_WAIT` 状态。
    - Server端收到Client端的 ACK 报文段以后，就关闭连接。
    - 此时，Client 端等待 **2MSL** 的时间后依然没有收到回复，则证明 Server 端已正常关闭，那好，Client端也可以关闭连接了。

- 为什么需要四次

  - 建立连接时因为当Server端收到Client端的SYN连接请求报文后，可以直接发送**SYN+ACK**报文。其中ACK报文是用来应答的，SYN报文是用来同步的。所以建立连接只需要三次握手。
  - 由于TCP协议是一种面向连接的、可靠的、基于字节流的运输层通信协议，TCP是**全双工模式**。这就意味着，关闭连接时，当Client端发出FIN报文段时，只是表示Client端告诉Server端数据已经发送完毕了。当Server端收到FIN报文并返回ACK报文段，表示它已经知道Client端没有数据发送了，但是Server端还是可以发送数据到Client端的，所以Server很可能并不会立即关闭SOCKET，直到Server端把数据也发送完毕。当Server端也发送了FIN报文段时，这个时候就表示Server端也没有数据要发送了，就会告诉Client端，我也没有数据要发送了，之后彼此就会愉快的中断这次TCP连接。

- 为什么要等待2MSL？

  **MSL**：报文段最大生存时间，它是任何报文段被丢弃前在网络内的最长时间。有以下两个原因：

  - **第一点：保证TCP协议的全双工连接能够可靠关闭**：
    由于IP协议的不可靠性或者是其它网络原因，导致了Server端没有收到Client端的ACK报文，那么Server端就会在超时之后重新发送FIN，如果此时Client端的连接已经关闭处于`CLOESD`状态，那么重发的FIN就找不到对应的连接了，从而导致连接错乱，所以，Client端发送完最后的ACK不能直接进入`CLOSED`状态，而要保持`TIME_WAIT`，当再次收到FIN的收，能够保证对方收到ACK，最后正确关闭连接。
  - **第二点：保证这次连接的重复数据段从网络中消失**
    如果Client端发送最后的ACK直接进入`CLOSED`状态，然后又再向Server端发起一个新连接，这时不能保证新连接的与刚关闭的连接的端口号是不同的，也就是新连接和老连接的端口号可能一样了，那么就可能出现问题：如果前一次的连接某些数据滞留在网络中，这些延迟数据在建立新连接后到达Client端，由于新老连接的端口号和IP都一样，TCP协议就认为延迟数据是属于新连接的，新连接就会接收到脏数据，这样就会导致数据包混乱。所以TCP连接需要在TIME_WAIT状态等待2倍MSL，才能保证本次连接的所有数据在网络中消失。

参考文档：

1. [一文彻底搞懂 TCP三次握手、四次挥手过程及原理 - 知乎](https://zhuanlan.zhihu.com/p/108504297)

# 分布式系统

## CAP 理论

- CAP
  - Consistency（一致性）
    - 对于客户端的每次读操作，要么读到的是最新的数据，要么读取失败。换句话说，一致性是站在分布式系统的角度，对访问本系统的客户端的一种承诺：要么我给您返回一个错误，要么我给你返回绝对一致的最新数据，不难看出，其强调的是数据正确。
  - Availability（可用性）
    - 任何客户端的请求都能得到响应数据，不会出现响应错误。换句话说，可用性是站在分布式系统的角度，对访问本系统的客户的另一种承诺：我一定会给您返回数据，不会给你返回错误，但不保证数据最新，强调的是不出错。
  - Partition tolerance（分区容忍性）
    - 由于分布式系统通过网络进行通信，网络是不可靠的。当任意数量的消息丢失或延迟到达时，系统仍会继续提供服务，不会挂掉。换句话说，分区容忍性是站在分布式系统的角度，对访问本系统的客户端的再一种承诺：我会一直运行，不管我的内部出现何种数据同步问题，强调的是不挂掉。
- 权衡 C、A
  - 对于一个分布式系统而言，P是前提，必须保证，因为只要有网络交互就一定会有延迟和数据丢失，这种状况我们必须接受，必须保证系统不能挂掉。
  - 当选择了C（一致性）时，如果由于网络分区而无法保证特定信息是最新的，则系统将返回错误或超时。
  - 当选择了A（可用性）时，系统将始终处理客户端的查询并尝试返回最新的可用的信息版本，即使由于网络分区而无法保证其是最新的。
- 为什么不能同时满足三个
  - 可以举例：A 更新数据，此时 A、B 网络断开，B 未能同步，此时需要保证分区容错性的前提下，B 无法在满足一致性和可用性的同时返回最新的数据

参考文档：

1. [轻松理解CAP理论 - 知乎](https://zhuanlan.zhihu.com/p/50990721)

# 设计模式

## 单例模式

- 实现方式

  1. 懒汉式，线程不安全

     **是否 Lazy 初始化：**是

     **是否多线程安全：**否

     ```java
     public class Singleton {  
         private static Singleton instance;  
         private Singleton (){}  
       
         public static Singleton getInstance() {  
             if (instance == null) {  
                 instance = new Singleton();  
             }  
             return instance;  
         }  
     }
     ```

  2. 懒汉式，线程安全

     **是否 Lazy 初始化：**是

     **是否多线程安全：**是

     ```java
     public class Singleton {  
         private static Singleton instance;  
         private Singleton (){}  
         public static synchronized Singleton getInstance() {  
             if (instance == null) {  
                 instance = new Singleton();  
             }  
             return instance;  
         }  
     }
     ```

  3. 饿汉式

     **是否 Lazy 初始化：**否

     **是否多线程安全：**是

     ```java
     public class Singleton {  
         private static Singleton instance = new Singleton();  
         private Singleton (){}  
         public static Singleton getInstance() {  
         return instance;  
         }  
     }
     ```

  4. 双检锁/双重校验锁（DCL，即 double-checked locking）

     **是否 Lazy 初始化：**是

     **是否多线程安全：**是

     ```java
     public class Singleton {  
         private volatile static Singleton singleton;  
         private Singleton (){}  
         public static Singleton getSingleton() {  
             if (singleton == null) {  
                 synchronized (Singleton.class) {  
                     if (singleton == null) {  
                         singleton = new Singleton();  
                     }  
                 }  
             }  
             return singleton;  
         }  
     }
     ```

  5. 登记式/静态内部类

     **是否 Lazy 初始化：**是

     **是否多线程安全：**是

     ```java
     public class Singleton {  
         private static class SingletonHolder {  
         private static final Singleton INSTANCE = new Singleton();  
         }  
         private Singleton (){}  
         public static final Singleton getInstance() {  
             return SingletonHolder.INSTANCE;  
         }  
     }
     ```

  6. 枚举

     **是否 Lazy 初始化：**否

     **是否多线程安全：**是

     ```java
     public enum Singleton {  
         INSTANCE;  
         public void whateverMethod() {  
         }  
     }
     ```

  7. 单例注册表

     单例注册表是Spring中Bean单例的核心实现方案。可以通过一个ConcurrentHashMap存储Bean对象，保证Bean名称唯一的情况下也能保证线程安全。

参考文档：

1. [单例模式 - RUNOOB](https://www.runoob.com/design-pattern/singleton-pattern.html)
2. [详解单例模式及其在Sping中的最优实践 - 知乎](https://zhuanlan.zhihu.com/p/442496004)

# 算法

## 堆排序

```java
/**
 * 堆排序演示
 *
 * @author Lvan
 */
public class HeapSort {
    public static void main(String[] args) {
//        int[] arr = {5, 1, 7, 3, 1, 6, 9, 4};
        int[] arr = {16, 7, 3, 20, 17, 8};
        heapSort(arr);
        for (int i : arr) {
            System.out.print(i + " ");
        }
    }

    /**
     * 创建堆，
     * @param arr 待排序列
     */
    private static void heapSort(int[] arr) {
        //创建堆
        for (int i = (arr.length - 1) / 2; i >= 0; i--) {
            //从第一个非叶子结点从下至上，从右至左调整结构
            adjustHeap(arr, i, arr.length);
        }
        //调整堆结构+交换堆顶元素与末尾元素
        for (int i = arr.length - 1; i > 0; i--) {
            //将堆顶元素与末尾元素进行交换
            int temp = arr[i];
            arr[i] = arr[0];
            arr[0] = temp;
            //重新对堆进行调整
            adjustHeap(arr, 0, i);
        }
    }

    /**
     * 调整堆
     * @param arr 待排序列
     * @param parent 父节点
     * @param length 待排序列尾元素索引
     */
    private static void adjustHeap(int[] arr, int parent, int length) {
        //将temp作为父节点
        int temp = arr[parent];
        //左孩子
        int lChild = 2 * parent + 1;
        while (lChild < length) {
            //右孩子
            int rChild = lChild + 1;
            // 如果有右孩子结点，并且右孩子结点的值大于左孩子结点，则选取右孩子结点
            if (rChild < length && arr[lChild] < arr[rChild]) {
                lChild++;
            }
            // 如果父结点的值已经大于孩子结点的值，则直接结束
            if (temp >= arr[lChild]) {
                break;
            }
            // 把孩子结点的值赋给父结点
            arr[parent] = arr[lChild];

            //选取孩子结点的左孩子结点,继续向下筛选
            parent = lChild;
            lChild = 2 * lChild + 1;
        }
        arr[parent] = temp;
    }
}
```

参考文档：

1. [堆排序——Java实现 - 博客园](https://www.cnblogs.com/luomeng/p/10618709.html)

## 快速排序

```java
public class QuickSort {
	private void swap(int[] arr, int i, int j) {
		int temp = arr[i];
		arr[i] = arr[j];
		arr[j] = temp;
	}
	
	public void quickSort(int[] arr, int start, int end) {
		if (start >= end)
			return;
		int k = arr[start];
		int i = start, j = end;
		while (i != j) {
			while (i < j && arr[j] >= k)
				--j;
			swap(arr, i, j);
			while (i < j && arr[i] <= k)
				++i;
			swap(arr, i, j);
		}
		quickSort(arr, start, i - 1);
		quickSort(arr, i + 1, end);
	}
	
	public static void main(String[] args) {
		int[] arr = {5, 2, 6, 9, 1, 3, 4, 8, 7, 10};
		new QuickSort().quickSort(arr, 0, arr.length - 1);
		System.out.println(Arrays.toString(arr));
	}
}
```

参考文档：

1. [快速排序Java代码简洁实现 - 知乎](https://zhuanlan.zhihu.com/p/144738954)

## Java 排序实现

- Collections.sort()排序有两种实现方式
  - 一是让元素类实现Comparable接口并覆盖compareTo()方法
  - 二是给Collecitons.sort()方法传入比较器，通常采用匿名内部内的方式传入。
- Collections.sort() 通过调用Arrays.sort()方法进行排序
  - 在Java1.6+中，如果集合大小<32则采用Tim-Sort算法，如果>=32则采用归并排序。
  - ComparableTimSort.sort()
    - 如果**2<= nRemaining <=32**,即MIN_MERGE的初始值，表示需要排序的数组是小数组，**可以使用mini-TimSort方法进行排序**
      - mini-TimSort排序方法：先找出数组中从下标为0开始的第一个升序序列，或者找出降序序列后转换为升序重新放入数组，将这段升序数组作为初始数组，将之后的每一个元素通过二分法排序插入到初始数组中。注意，这里就调用到了我们重写的compareTo()方法了。
    - **否则 nRemaining > 32 需要使用归并排序**。

参考文档

1. [Java集合排序功能实现分析 - 博客园](https://www.cnblogs.com/dudadi/p/8007167.html)