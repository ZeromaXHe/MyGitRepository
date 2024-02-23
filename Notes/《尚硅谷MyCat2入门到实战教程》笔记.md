【尚硅谷】MyCat2入门到实战教程（轻松掌握mycat）

https://www.bilibili.com/video/BV1iT41157JX

2022-06-14 14:55:00

# P1 Mycat 是什么、为什么要用

## 为什么学习 Mycat2

常见数据库瓶颈问题：

- 数据库数据量大，查询效率低
- 分布式数据库架构复杂对接困难
- 高访问高并发对数据库压力山大

解决方案：分布式数据库中间件 Mycat2

## 课程介绍

- 基础（入门）
  - Mycat 核心概念、底层原理、应用场景
  - 明确 Mycat 是什么、有什么用、怎么用
- 核心（应用）
  - 手把手从零开始搭建 Mycat2
  - 做好实战的准备
- 实战（高级）
  - 解决真实系统难题：实现读写分离、分库分表
  - 数据库分布式轻松搞定
- 新特性（进阶）
  - 了解新特性、学习 MycatUI 工具实现整体统筹提升 Mycat2 使用效率

## Mycat2 与老版本区别

| 功能                          | 1.6                               | 2                                |
| ----------------------------- | --------------------------------- | -------------------------------- |
| 多语句                        | 不支持                            | 支持                             |
| blob 值                       | 支持一部分                        | 支持                             |
| 全局二级索引                  | 不支持                            | 支持                             |
| 任意跨库 join（包含复杂查询） | catlet 支持                       | 支持                             |
| 分片表与分片表 JOIN 查询      | ER 表支持                         | 支持                             |
| 关联子查询                    | 不支持                            | 支持一部分                       |
| 分库同时分表                  | 不支持                            | 支持                             |
| 存储过程                      | 支持固定形式的                    | 支持更多                         |
| 支持逻辑视图                  | 不支持                            | 支持                             |
| 支持物理视图                  | 支持                              | 支持                             |
| 批量插入                      | 不支持                            | 支持                             |
| 执行计划管理                  | 不支持                            | 支持                             |
| 路由注释                      | 支持                              | 支持                             |
| 集群功能                      | 支持                              | 支持更多集群类型                 |
| 自动 hash 分片算法            | 不支持                            | 支持                             |
| 支持第三方监控                | 支持 mycat-web                    | 支持普罗米修斯、Kafka 日志等监控 |
| 流式合并结果集                | 支持                              | 支持                             |
| 范围查询                      | 支持                              | 支持                             |
| 单表映射物理表                | 不支持                            | 支持                             |
| XA 事务                       | 弱 XA                             | 支持，事务自动恢复               |
| 支持 MySQL 8                  | 需要更改 mysql 8 的服务器配置支持 | 支持                             |
| 虚拟表                        | 不支持                            | 支持                             |
| joinClustering                | 不支持                            | 支持                             |
| union all 语法                | 不支持                            | 支持                             |
| BKAJoin                       | 不支持                            | 支持                             |
| 优化器注释                    | 不支持                            | 支持                             |
| ER 表                         | 支持                              | 支持                             |
| 全局序列号                    | 支持                              | 支持                             |
| 保存点                        | 不支持                            | 支持                             |
| 离线迁移                      | 支持                              | 支持（实验）                     |
| 增量迁移                      | CRC32 算法支持                    | BINLOG 追平（实验）              |
| 安全停机                      | 不支持                            | 支持（实验）                     |
| HAProxy 协议                  | 不支持                            | 支持                             |

Mycat2 功能更强大，使用更简单

## 第一章 入门概述

### 1.1 是什么

Mycat 是数据库中间件。

#### 1、数据库中间件

中间件：是一类连接软件组件和应用的计算机软件，以便于软件各部件之间的沟通。

例子：Tomcat，web 中间件。

数据库中间件：连接 java 应用程序和数据库

#### 2、为什么要用 Mycat？

1. Java 与数据库紧耦合
2. 高访问量高并发对数据库的压力
3. 读写请求数据不一致

#### 3、数据库中间件对比

1. **Cobar** 属于阿里 B2B 事业群，始于 2008 年，在阿里服役 3 年多，接管 3000+ 个 MySQL 数据库的 schema，集群日处理在线 SQL 请求 50 亿次以上。由于 Cobar 发起人的离职，Cobar 停止维护。
2. **Mycat** 是开源社区在阿里 cobar 基础上进行二次开发，解决了 cobar 存在的问题，并且加入了许多新的功能在其中。青出于蓝而胜于蓝。
3. **OneProxy** 基于 MySQL 官方的 proxy 思想利用 c 语言进行开发的，OneProxy 是一款商业**收费**的中间件。舍弃了一些功能，专注在**性能和稳定性上**
4. **kingshard** 由小团队用 go 语言开发，还需要发展，需要不断完善
5. **Vitess** 是 Youtube 生产在使用，架构很复杂。不支持 MySQL 原生协议，使用**需要大量改造成本**。
6. **Atlas** 是 360 团队基于 mysql proxy 改写，功能还需完善，高并发下不稳定。
7. **MaxScale** 是 mariadb（MySQL 原作者维护的一个版本）研发的中间件
8. **MySQLRoute** 是 MySQL 官方 Oracle 公司发布的中间件

# P2 Mycat 能干什么、原理

### 1.2 干什么

1. 读写分离

2. 数据分片

   垂直拆分（分库）、水平拆分（分表）、垂直+水平拆分（分库分表）

3. 多数据源整合

### 1.3 原理

Mycat 的原理中最重要的一个动词是“拦截”，它拦截了用户发送过来的 SQL 语句，首先对 SQL 语句做了一些特定的分析：如分片分析、路由分析、读写分离分析、缓存分析等，然后将此 SQL 发往后端的真实数据库，并将返回的结果做适当的处理，最终再返回给用户。

这种方式把数据库的分布式从代码中解耦出来，程序员察觉不出来后台使用 Mycat 还是 MySQL。

# P3 新版本特性

### 1.4 Mycat 1.x 与 Mycat 2 功能对比

#### 1、1.x 与 2.0 功能对比图

1. 
2. 
3. 
4. 关联子查询：支持不能消除关联的关联子查询
5. 分库同时分表：把分库分表合一，同一规划
6. 存储过程：存储过程支持多结果集返回、支持接收 affectRow
7. 支持批量插入：支持 rewriteInsertBatchedStatementBatch 参数，用于提高批量插入性能（只有把 rewriteBatchedStatements 参数置为 true，MySQL 驱动才会帮你批量执行 SQL）
8. 支持执行计划管理：Mycat 2 的执行计划管理主要作用是管理执行计划，加快 SQL 到执行计划的转换，并且提供一个方式可以从持久层读取自定义的执行计划
9. 自动 hash 分片算法：由 1.6 版本的手动配置算法，到 2.0 的自动 hash 分片
10. 单表映射物理表：使用自动化建表语句创建测试的物理库物理表，它会自动生成配置文件，然后通过查看本地的配置文件，观察它的属性

# P4 映射模型区别

#### 2、映射模型区别

Mycat 1.6

- 分库

  logical table -> 多个 dataNode（cluster，schema）-> datasource

- 分表

  logical table -> 一个 dataNode（cluster，schema）+ 多个 tableName -> datasource

- 单表

  logical table -> 一个 dataNode（cluster，schema）-> datasource

Mycat 2

logical table -> partition(targetName, schema, table) => (cluster -> datasource)

# P5 安装

## 第二章 安装启动

### 2.1 安装

1. 下载安装包
2. 解压后即可使用
3. 修改文件夹及以下文件的权限

# P6 启动、访问

### 2.2 启动

#### 1、在 mycat 连接的 mysql 数据库里添加用户

创建用户，用户名为 mycat，密码为 123456，赋权限

```mysql
CREATE USER 'mycat'@'%' IDENTIFIED BY '123456';
-- 必须要赋的权限 mysql 8 才有的
GRANT XA_RECOVER_ADMIN ON *.* TO 'root'@'%';
-- 视情况赋权限
GRANT ALL PRIVILEGES ON *.* TO 'mycat'@'%';
flush privileges;
```

#### 2、修改 mycat 的 prototype 的配置

启动 mycat 之前需要确认 prototype 数据源所对应的 mysql 数据库配置，修改对应的 user（用户），password（密码），url 中的 ip

```shell
vim conf/datasources/prototypeDs.data
```

#### 3、验证数据库访问情况

Mycat 作为数据库中间件要和数据库部署在不同机器上，所以要验证远程访问情况。

```shell
mysql -uroot -p123123 -h 192.168.140.100 -P 3306
mysql -uroot -p123123 -h 192.168.140.99 -P 3306
# 如远程访问报错，请建对应用户
grant all privileges on *.* to root@'缺少的host' identified by '123123';
```

#### 4、启动 mycat

linux 启动命令

```shell
cd mycat/bin
./mycat start
./mycat status
./mycat start # 启动
./mycat stop # 停止
./mycat console # 前台运行
./mycat install # 添加到系统自动启动（暂未实现）
./mycat remove # 取消随系统自动启动（暂未实现）
./mycat restart # 重启服务
./mycat pause # 暂停
./mycat status # 查看启动状态
```

### 2.3 登录

#### 1、登录后台管理窗口

此登录方式用于管理维护 Mycat

```shell
mysql -umycat -p123456 -P 9066
# 常用命令如下
show database;
help;
```

#### 2、登录数据窗口

此登录方式用于通过 Mycat 查询数据，我们选择这种方式访问 Mycat

```shell
mysql -umycat -p123456 -P 8066
```

# P7 Mycat 2 概念介绍上

## 第三章 Mycat2 相关概念

### 3.1 概念描述

#### 1、分库分表

按照一定规则把数据库中的表拆分为多个带有数据库实例，物理库，物理表访问路径的分表。

解读：

分库：一个电商项目，分为用户库、订单库等等。

分表：一张订单表数据数百万，达到 MySQL 单表瓶颈，分到多个数据库中的多张表

#### 2、逻辑库

数据库代理中的数据库，它可以包含多个逻辑表。

解读：Mycat 里定义的库，在逻辑上存在，物理上在 MySQL 里并不存在。有可能是多个 MySQL 数据库共同组成一个逻辑库。类似多个小孩叠罗汉穿上外套，扮演一个大人。

#### 3、逻辑表

数据库代理中的表，它可以映射代理连接的数据库中的表（物理表）

解读：Mycat 里定义的表，在逻辑上存在，可以映射真实的 MySQL 数据库的表。可以一对一，也可以一对多。

#### 4、物理库

数据库代理连接的数据库中的库

解读：MySQL 真实的数据库。

#### 5、物理表

数据库代理连接的数据库中的表

解读：MySQL 真实的数据库中的真实数据表。

#### 6、拆分键

即分片键，描述拆分逻辑表的数据规则的字段

解读：比如订单表可以按照归属的用户 id 拆分，用户 id 就是拆分键。

# P8 Mycat2 概念介绍下

#### 7、物理分表

指已经进行数据拆分的，在数据库上面的物理表，是分片表的一个分区

解读：多个物理分表里的数据汇总就是逻辑表的全部数据

#### 8、物理分库

一般指包含多个物理分表的库

解读：参与数据分片的实际数据库

#### 9、分库

一般指通过多个数据库拆分分片表，每个数据库一个物理分表，物理分库名字相同

解读：分库是个动作，需要多个数据库参与。就像多个数据库是多个盘子，分库就是把一串数据葡萄，分到各个盘子里，而查询数据时，所有盘子的葡萄又通过 Mycat2 组成了完整的一串葡萄。

#### 10、分片表，水平分片表

按照一定规则把数据拆分成多个分区的表，在分库分表语境下，它属于逻辑表的一种

解读：按照规则拆分数据，上一个例子中的那串葡萄

#### 11、单表

没有分片，没有数据冗余的表

解读：没有拆分数据，也没有复制数据到别的库的表

#### 12、全局表，广播表

每个数据库实例都冗余全量数据的逻辑表

它通过表数据冗余，使分片表的分区与该表的数据在同一个数据库实例里，达到 join 运算能够直接在该数据库实例里执行，它的数据一致一般是通过数据库代理分发 SQL 实现，也有基于集群日志的实现

解读：例如系统中翻译字段的字典表，每个分片表都需要完整的字典数据翻译字段。

#### 13、ER 表

狭义指父子表中的子表，它的分片键指向父表的分片键，而且两表的分片算法相同

广义指具有相同数据分布的一组表

解读：关联别的表的子表，例如：订单详情表就是订单表的 ER 表

#### 14、集群

多个数据节点组成的逻辑节点，在 mycat2 里，它是把对多个数据源地址视为一个数据源地址（名称），并提供自动故障恢复、转移，即实现高可用，负载均衡的组件。

解读：集群就是高可用、负载均衡的代名词

#### 15、数据源

连接后端数据库的组件，它是数据库代理中连接后端数据库的客户端

解读：Mycat 通过数据源连接 MySQL 数据库

#### 16、原型库（prototype）

原型库是 Mycat 2 后面的数据库，比如 mysql 库

解读：原型库就是存储数据的真实数据库，配置数据源时必须指定原型库

# P9 Mycat2 配置文件介绍

### 3.2 配置文件

#### 1、服务（server）

服务相关配置

1. 所在目录

   mycat/conf

   默认配置即可

#### 2、用户（user）

配置用户相关信息

1. 所在目录

   mycat/conf/users

2. 命名方式

   {用户名}.user.json

3. 配置内容

   ```shell
   vim mycat/conf/users/root.user.json
   ```

   ```json
   {
       "ip": null,
       "password": "123456",
       "transactionType": "xa",
       "username": "root",
       "isolation": 3
   }
   ```

   字段含义

   - ip： 客户端访问 ip，建议为空，填写后会对客户端的 ip 进行限制

   - username: 用户名

   - password: 密码

   - isolation: 设置初始化的事务隔离级别

     - READ_UNCOMMITTED: 1
     - READ_COMMITTED: 2
     - REPEATED_READ: 3, 默认
     - SERIALIZABLE: 4

   - transactionType: 事务类型

     可选值：

     - proxy：本地事务，在涉及大于 1 个数据库的事务，commit 阶段失败会导致不一致，但是兼容性最好 
     - xa：xa 事务，需要确认存储节点集群类型是否支持 XA

     可以通过语句实现切换

     ```mysql
     set transaction_policy = 'xa'
     set transaction_policy = 'proxy'
     ```

     可以通过语句查询

     ```mysql
     SELECT @@transaction_policy
     ```

#### 3、数据源（datasource）

配置 Mycat 连接的数据源信息

1. 所在目录

   mycat/conf/datasources

2. 命令方式

   {数据源名字}.datasource.json

3. 配置内容

   ```shell
   vim mycat/conf/datasources/prototype.datasources.json
   ```

   ```json
   {
       "dbType": "mysql",
       "idleTimeout": 60000,
       "initSqls": [],
       "initSqlsGetConnection": true,
       "instanceType": "READ_WRITE",
       "maxCon": 1000,
       "maxConnectTimeout": 3000,
       "maxRetryCount": 5,
       "minCon": 1,
       "name": "prototype",
       "password": "123456",
       "type": "JDBC",
       "url": "jdbc:mysql://127.0.0.1:3306/mysql?useUnicode=true&serverTimezone=UTC",
       "user": "root",
       "weight": 0,
       "queryTimeout": 30, // millis
   }
   ```

   字段含义：

   - dbType: 数据库类型，mysql

   - name：用户名

   - password：密码

   - type：数据源类型，默认 JDBC

   - url：访问数据库地址

   - idleTimeout：空闲连接超时时间

   - initSqls：初始化 sql

   - initSqlsGetConnection：对于 jdbc 每次获取连接是否都执行 initSqls

   - instanceType：配置实例只读还是读写

     可选值：

     READ_WRITE，READ，WRITE

   - initSqlsGetConnection：对于 jdbc 每次获取连接是否都执行 initSqls

   - weight：负载均衡权重

#### 4、集群（cluster）

配置集群信息

1. 所在目录

   mycat/conf/clusters

2. 命名方式

   {集群名字}.cluster.json

3. 配置内容

   ```shell
   vim mycat/conf/clusters/prototype.cluster.json
   ```

   ```json
   {
       "clusterType": "MASTER_SLAVE",
       "heartbeat": {
           "heartbeatTimeout": 1000,
           "maxRetryCount": 3, // 2021-6-4 前是 maxRetry，后更正为 maxRetryCount
           "minSwitchTimeInterval": 300,
           "slaveThreshold": 0
       },
       "masters": [ // 配置多个主节点，在主挂的时候会选一个检测存活的数据源作为主节点
           "prototypeDs"
       ],
       "replicas": [ // 配置多个从节点
           "xxxx"
       ],
       "maxCon": 200,
       "name": "prototype",
       "readBalanceType": "BALANCE_ALL",
       "switchType":"SWITCH",
       ///////////////// 可选 /////////////////
       "timer": { // MySQL 集群心跳周期，配置则开启集群心跳，Mycat 主动检测主从延迟以及高可用主从切换
           "initialDelay": 30,
           "period": 5,
           "timeUnit": "SECONDS"
       },
       // "readBalanceType": "BALANCE_ALL",
       // "writeBalanceType": "BALANCE_ALL",
   }
   ```

   字段含义：

   - clusterType：集群类型

     可选值：

     - SINGLE_NODE：单一节点
     - MASTER_SLAVE：普通主从
     - GARELA_CLUSTER：garela cluster/PXC 集群
     - MHA：MHA 集群
     - MGR：MGR 集群

   - readBalanceType：查询负载均衡策略

     可选值：

     - BALANCE_ALL（默认值）

       获取集群中所有数据源

     - BALANCE_ALL_READ

       获取集群中允许读的数据源

     - BALANCE_READ_WRITE

       获取集群中允许读写的数据源，但允许读的数据源优先

     - BALANCE_NONE

       获取集群中允许写数据源，即主节点中选择

   - switchType：切换类型

     可选值：

     - NOT_SWITCH：不进行主从切换
     - SWITCH：进行主从切换

#### 4、逻辑库表（schema）

配置逻辑库表，实现分库分表

1. 所在目录

   mycat/conf/schemas

2. 命名方式

   {库名}.schema.json

3. 配置内容

   ```shell
   vim mycat/conf/schemas/mydb1.schema.json
   ```

   ```json
   // 库配置
   {
       "schemaName": "mydb",
       "targetName": "prototype"
   }
   ```

   - schemaName：逻辑库名
   - targetName：目的数据源或集群

   targetName 自动从 prototype 目标加载 test 库下的物理表或者视图作为单表，prototype 必须是 mysql 服务器

   ```json
   // 单表配置
   {
       "schemaName": "mysql-test",
       "normalTables": {
           "role_edges": {
               "createTableSQL": null, // 可选
               "locality": {
                   "schemaName": "mysql", // 物理库，可选
                   "tableName": "role_edges", // 物理表，可选
                   "targetName": "prototype" // 指向集群，或者数据源
               }
           }
       }
   }
   // 详细配置见分库分表
   ```

# P10 一主一从读写分离原理

## 第四章 搭建读写分离

我们通过 Mycat 和 MySQL 的主从复制配合搭建数据库的读写分离，实现 MySQL 的高可用性。我们将搭建：一主一从、双主双从两种读写分离模式。

### 4.1 搭建一主一从

一个主机用于处理所有写请求，一台从机负责所有读请求。

#### 1、搭建 MySQL 数据库主从复制

1. MySQL 主从复制原理

   Master(binary log) -> Slave(I/O thread -> Relay log -> SQL thread)