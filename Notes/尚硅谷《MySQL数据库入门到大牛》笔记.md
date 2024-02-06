尚硅谷《MySQL数据库入门到大牛，mysql安装到优化，百科全书级，全网天花板》2021-11-17

https://www.bilibili.com/video/BV1iq4y1u7vj 

# P1 MySQL 教程简介

# P2 为什么使用数据库及数据库常用概念

## 为什么要使用数据库

- 持久化（persistence）：把数据保存到可掉电式存储设备中以供之后使用。大多数情况下，特别是企业级应用，数据持久化意味着将内存中的数据保存到硬盘上加以“固化”，而持久化的实现过程大多通过各种关系数据库来完成。
- 持久化的主要作用是将内存中的数据存储在关系型数据库中，当然也可以存储在磁盘文件、XML 数据文件中。

## 数据库与数据库管理系统

### 数据库的相关概念

DB：数据库（Database）即存储数据的“仓库”，其本质是一个文件系统。它保留了一系列有组织的数据。

DBMS：数据库管理系统（Database Management System）是一种操纵和管理数据库的大型软件，用于建立、使用和维护数据库，对数据库进行统一管理和控制。用户通过数据库管理系统访问数据库中表内的数据。

SQL：结构化查询语言（Structured Query Language）专门用来与数据库通信的语言。

### 数据库与数据库管理系统的关系

数据库管理系统（DBMS）可以管理多个数据库，一般开发人员会针对每一个应用创建一个数据库。为保存应用中实体的数据，一般会在数据库创建多个表，以保存程序中实体用户的数据。

# P3 常见的 DBMS 的对比

## 常见的数据库管理系统排名

目前互联网上常见的数据库管理软件有 Oracle、MySQL、MS SQL Server、DB2、PostgreSQL、Access、Sybase、Informix 这几种。

# P94 MySQL 8.0 新特性——窗口函数的使用

## 1. MySQL 8 新特性概述

MySQL 从 5.7 版本直接跳跃发布了 8.0 版本，可见这是一个令人兴奋的里程碑版本。MySQL 8 版本在功能上做了显著的改进与增强，开发者对 MySQL 的源代码进行了重构，最突出的一点是多 MySQL Optimizer 优化器进行了改进。不仅在速度上得到了改善，还为用户带来了更好的性能和更棒的体验。

### 1.1 MySQL 8.0 新增特性

1. 更简便的 NoSQL 支持

   NoSQL 泛指非关系型数据库和数据存储。随着互联网平台的规模飞速发展，传统的关系型数据库已经越来越不能满足需求。从 5.6 版本开始，MySQL 就开始支持简单的 NoSQL 存储功能。MySQL 8 对这一功能做了优化，以更灵活的方式实现 NoSQL 功能，不再依赖模式（schema）。

2. 更好的索引

   在查询中，正确地使用索引可以提高查询的效率。MySQL 8 中新增了 `隐藏索引` 和 `降序索引`。隐藏索引可以用来测试去掉索引对查询性能的影响。在查询中混合存在多列索引时，使用降序索引可以提高查询的性能。

3. 更完善的 JSON 支持

   MySQL 从 5.7 开始支持原生 JSON 数据的存储，MySQL 8 对这一功能做了优化，增加了聚合函数 `JSON_ARRAYAGG()` 和 `JSON_OBJECTAGG()`，将参数聚合为 JSON 数组或对象，新增了行内操作符 ->>，是列路径运算符 -> 的增强，对 JSON 排序做了提升，并优化了 JSON 的更新操作。

4. 安全和账户管理

   MYSQL 8 中新增了 `caching_sha2_password` 授权插件、角色、密码历史记录和 FIPS 模式支持，这些特性提高了数据库的安全性和性能，使数据库管理员能够更灵活地进行账户管理工作。

5. InnoDB 的变化

   `InnoDB 是 MySQL 默认的存储引擎`，是事务型数据库的首选引擎，支持事务安全表（ACID），支持行锁定和外键。在 MySQL 8 版本中，InnoDB 在自增、索引、加密、死锁、共享锁等方面做了大量的`改进和优化`，并且支持原子数据定义语言（DDL），提高了数据安全性，对事务提供更好的支持。

6. 数据字典

   在之前的 MySQL 版本中，字典数据都存储在元数据文件和非事务表中。从 MySQL 8 开始新增了事务数据字典，在这个字典里存储着数据库对象信息，这些数据字典存储在内部事务表中。

7. 原子数据定义语句

   MySQL 8 开始支持原子数据定义语句（Atomic DDL），即 `原子 DDL`。目前，只有 InnoDB 存储引擎支持原子 DDL。

   原子数据定义语句（DDL）将与 DDL 操作相关的数据字典更新、存储引擎操作、二进制日志写入结合到一个单独的原子事务中，这使得即使服务器崩溃，事务也会提交或回滚。

   使用支持原子操作的存储引擎所创建的表，在执行 DROP TABLE、CREATE TABLE、ALTER TABLE、RENAME TABLE、TRUNCATE TABLE、CREATE TABLESPACE、DROP TABLESPACE 等操作时，都支持原子操作，即事务要么完全操作成功，要么失败后回滚，不再进行部分提交。

   对于从 MySQL 5.7 复制到 MySQL 8 版本中的语句，可以添加 IF EXISTS 或 IF NOT EXISTS 语句来避免发生错误。

8. 资源管理
   MySQL 8 开始支持创建和管理资源组，允许将服务器内运行的线程分配给特定的分组，以便线程根据组内可用资源执行。组属性能够控制组内资源，启用或限制组内资源消耗。数据库管理员能够根据不同的工作负载适当地更改这些属性。

   目前，CPU 时间是可控资源，由“虚拟 CPU”这个概念来表示，此术语包含 CPU 的核心数，超线程，硬件线程等等。服务器在启动时确定可用的虚拟 CPU 数量。拥有对应权限的数据库管理员可以将这些 CPU 与资源组关联，并为资源组分配线程。

   资源组组件为 MySQL 中的资源组管理提供了 SQL 接口。资源组的属性用于资源组。MySQL 中存在两个默认组，系统组和用户组。默认的组不能被删除，其属性也不能被更改。对于用户自定义的组，资源组创建时可初始化所有的属性，除去名字和类型，其他属性都可在创建之后进行更改。

   在一些平台下，或进行了某些 MySQL 的配置时，资源管理的功能将受到限制，甚至不可用。例如，如果安装了线程池插件，或者使用的是 MacOS 系统，资源管理将处于不可用状态。在 FreeBSD 和  Solaris 系统中，资源线程优先级将失效。在 Linux 系统中，只有配置了 CAP_SYS_NICE 属性，资源管理优先级才能发挥作用。

9. 字符集支持

   MySQL 8 中默认的字符集由 `latin1` 更改为 `utf8mb4`，并首次增加了日语所特定使用的集合，utf8mb4_ja_0900_as_cs。

10. 优化器增强

    MySQL 优化器开始支持隐藏索引和降序索引。隐藏索引不会被优化器使用，验证索引的必要性时不需要删除索引，先将索引隐藏，如果优化器性能无影响就可以真正地删除索引。降序索引允许优化器对多个列进行排序，并且允许排序顺序不一致。

11. 公用表表达式

    公用表表达式（Common Table Expression）简称为 CTE，MySQL 现在支持递归和非递归两种形式的 CTE。CTE 通过在 SELECT 语句或其他特定语句前`使用 WITH 语句对临时结果`进行命名。

    基础语法如下：

    ```mysql
    WITH cte_name(col_name1, col_name2 ...) AS (Subquery)
    SELECT * FROM cte_name;
    ```

    Subquery 代表子查询，子查询前使用 WITH 语句将结果集命名为 cte_name，在后续的查询中即可使用 cte_name 进行查询。

12. 窗口函数

    MySQL 8 开始支持窗口函数。在之前的版本中已存在的大部分`聚合函数`在 MySQL 8 中也可以作为窗口函数来使用

    | 函数名称       | 描述                                                     |
    | -------------- | -------------------------------------------------------- |
    | CUME_DIST()    | 累计的分布值                                             |
    | DENSE_RANK()   | 对当前记录不间断排序                                     |
    | FIRST_VALUE()  | 返回窗口首行记录的对应字段值                             |
    | LAG()          | 返回对应字段的前 N 行记录                                |
    | LAST_VALUE()   | 返回窗口尾行记录的对应字段值                             |
    | LEAD()         | 返回对应字段的后 N 行记录                                |
    | NTH_VALUE()    | 返回第 N 条记录对应的字段值                              |
    | NTILE()        | 将区划分为 N 组，并返回组的数量                          |
    | PERCENT_RANK() | 返回 0 到 1 之间的小数，表示某个字段值在数据分区中的排名 |
    | RANK()         | 返回分区内每条记录对应的排名                             |
    | ROW_NUMBER()   | 返回每一条记录对应的序号，且不重复                       |

13. 正则表达式支持

    MySQL 在 8.0.4 以后的版本中采用支持 unicode 的国际化组件库实现正则表达式操作。这种方式不仅能提供完全的 Unicode 支持，而且是多字节安全编码。MySQL 增加了 REGEXP_LIKE()、EGEXP_INSTR()、REGEXP_REPLACE() 和 REGEXP_SUBSTR() 等函数来提升性能。另外，regexp_stack_limit 和 regexp_time_limit 系统变量能够通过匹配引擎来控制资源消耗。

14. 内部临时表

    `TempTable 存储引擎取代 MEMORY 存储引擎成为内部临时表的默认存储引擎`。TempTable 存储引擎为 VARCHAR 和 VARBINARY 列提供高效存储。`internal_tmp_mem_storage_engine` 会话变量定义了内部临时表的存储引擎，可选的值有两个，TempTable 和 MEMORY，其中 TempTable 为默认的存储引擎。temptable_max_ram 系统配置项定义了 TempTable 存储引擎可使用的最大内存数量。

15. 日志记录

    在 MySQL 8 中错误日志子系统由一系列 MySQL 组件构成。这些组件的构成由系统变量 log_error_services 来配置，能够实现日志事件的过滤和写入。

16. 备份锁

    新的备份锁允许在线备份期间执行数据操作语句，同时阻止可能造成快照不一致的操作。新备份锁由 LOCK INSTANCE FOR BACKUP 和 UNLOCK INSTANCE 语法提供支持，执行这些操作需要备份管理员特权。

17. 增强的 MySQL 复制

    MySQL 8 复制支持对 `JSON 文档`进行部分更新的`二进制日志记录`，该记录`使用紧凑的二进制格式`，从而节省记录完整 JSON 文档的空间。当使用基于语句的日志记录时，这种紧凑的日志记录会自动完成，并且可以通过将新的 binlog_row_value_options 系统变量值设置为 PARTIAL_JSON 来启用。

### 1.2 MySQL 8.0 移除的旧特性

在 MySQL 5.7 版本上开发的应用程序如果使用了 MySQL 8.0 移除的特性，语句可能会失败，或者产生不同的执行结果。为了避免这些问题，对于使用了移除特性的应用，应当尽力修正以避免使用这些特性，并尽可能使用替代方法。

1. 查询缓存

   `查询缓存已被移除`，删除的项有：

   1. 语句：FLUSH QUERY CACHE 和 RESET QUERY CACHE。
   2. 系统变量：query_cache_limit、query_cache_min_res_unit、query_cache_size、query_cache_type、query_cache_wlock_invalidate。
   3. 状态变量：Qcache_free_blocks、Qcache_free_memory、Qcache_hits、Qcache_inserts、Qcache_lowmem_prunes、Qcache_not_cached、Qcache_queries_in_cache、Qcache_total_blocks。
   4. 线程状态：checking privileges on cached query、checking query cache for query、invalidating query cache entries、sending cached result to client、storing result in query cache、waiting for query cache lock。

2. 加密相关

   删除的加密相关的内容有：ENCODE()、DECODE()、ENCRYPT()、DES_ENCRYPT() 和 DES_DECRYPT() 函数，配置项 des-key-file，系统变量 have_crypt，FLUSH 语句的 DES_KEY_FILE 选项，HAVE_CRYPT CMake 选项。

   对于移除的 ENCRYPT() 函数，考虑使用 SHA2() 替代，对于其他移除的函数，使用 AES_ENCRYPT() 和 AES_DECRYPT() 替代。

3. 空间函数相关

   在 MySQL 5.7 版本中，多个空间函数已被标记为过时。这些过时函数在 MySQL 8 中都已被移除，只保留了对应的 ST_ 和 MBR 函数。

4. \N 和 NULL

   在 SQL 语句中，解析器不再将 \N 视为 NULL，所以在 SQL 语句中应使用 NULL 代替 \N。这项变化不会影响使用 LOAD DATA INFILE 或者 SELECT ... INTO OUTFILE 操作文件的导入和导出。在这类操作中，NULL 仍等同于 \N

5. mysql_install_db

   在 MySQL 分布中，已移除了 mysql_install_db 程序，数据字典初始化需要调用带着 --initialize 或者 --initialize-insecure 选项的 mysqld 来代替实现。另外，--bootstrap 和 INSTALL_SCRIPTDIR CMake 也已被删除。

6. 通用分区处理程序

   通用分区处理程序已从 MySQL 服务中被移除。为了实现给定表分区，表所使用的存储引擎需要自有的分区处理程序。

   提供本地分区支持的 MySQL 存储引擎有两个，即 InnoDB 和 NDB，而在 MySQL 8 中只支持 InnoDB。

7. 系统和状态变量信息

   在 INFORMATION_SCHEMA 数据库中，对系统和状态变量信息不再进行维护。GLOBAL_VARIABLES、SESSION_VARIABLES、GLOBAL_STATUS、SESSION_STATUS 表都已被删除。另外，系统变量 show_compatibility_56 也已被删除。被删除的状态变量有 Slave_heartbeat_period、Slave_last_heartbeat、Slave_received_heartbeats、Slave_retried_transactions、Slave_running。以上被删除的内容都可使用性能模式中对应的内容进行替代。

8. mysql_plugin 工具

   mysql_plugin 工具用来配置 MySQL 服务器插件，现已被删除，可使用 --plugin-load 或 --plugin-load-add 选项在服务器启动时加载插件或者在运行时使用 INSTALL PLUGIN 语句加载插件来替代该工具。

## 2. 新特性1：窗口函数

20:00

### 2.1 使用窗口函数前后对比

### 2.2 窗口函数分类

31:30

### 2.3 语法结构

38:30

### 2.4 分类讲解

#### 序号函数

41:30

- ROW_NUMBER() 函数（41:40）
- RANK() 函数（46:30）
- DENSE_RANK() 函数（49:20）

#### 分布函数

51:50

- PERCENT_RANK() 函数（52:00）
- CUME_DIST() 函数（56:40）

#### 前后函数

58:40

- LAG(expr, n) 函数（58:50）
- LEAD(expr, n) 函数（1:02:30）

#### 首尾函数

1:04:32

- FIRST_VALUE(expr) 函数（1:04:40）
- LAST_VALUE(expr) 函数（1:07:25）

#### 其他函数

1:07:40

- NTH_VALUE(expr, n) 函数（1:07:50）
- NTILE(n) 函数（1:10:00）

# P95 公用表表达式 - 课后练习 - 最后寄语

## 普通公用表表达式

02:35

## 递归公用表表达式

08:20

## 小结

18:30

# P96 MySQL 高级特性篇章节概览

## 06 - MySQL 架构篇

1. Linux 环境下 MySQL 的安装与使用
   - 启动好两台 CentOS 7 虚拟机
   - rpm、yum、编译安装源码包
   - 服务的启动与远程登陆
   - 字符集设置、各级别字符集规则
   - sql_mode
2. MySQL 的数据目录
   - 主要目录结构
     - 文件存放路径：/var/lib/mysql
     - 相关命令：/usr/bin
     - 配置文件目录：/usr/share/mysql-8.0
   - 数据库文件系统
     - db.opt
     - .frm
     - .ibd
     - .MYD
     - .MYI
3. 用户与权限管理
   - 权限表：user 表、db 表、table_priv 表等
   - 用户管理：创建、修改、删除用户；设置密码
   - 权限管理：授予、查看、回收权限
   - 角色管理：创建、查看、激活、删除角色
   - 配置文件的使用
4. 逻辑架构
   - 逻辑架构分析
     - 连接层
     - 服务层
     - 引擎层
     - 存储层
   - SQL 查询流程
   - 查看执行计划
   - 数据库缓冲池
5. 存储引擎
   - 查看默认引擎
   - 设置表的引擎
   - 不同引擎介绍
     - InnoDB
     - MyISAM
     - Archive
     - CSV
     - Memory
     - ……
6. InnoDB 数据存储结构
   - 关系图
   - InnoDB 行格式
     - COMPACT 行格式
     - Redundant 行格式
     - Dynamic 行格式
     - Compressed 行格式
   - 数据页组成部分
     - 文件头（File Header）
     - 页头（Page Header）
     - 最大最小记录（Infimum + supremum）
     - 用户记录（User Records）
     - 空闲空间（Free Space）
     - 页目录（Page Directory）
     - 文件尾（File Tailer）
   - 区的结构：一个区会分配 64 个连续的页
   - 段的结构：若干个零散的页面以及一些完整的区组成
   - 表空间
     - 系统表空间（System tablespace）
     - 独立表空间（File-per-table tablespace）
     - 撤销表空间（Undo Tablespace）
     - 临时表空间（Temporary Tablespace）

## 07 - 索引及调优篇

1. 索引的数据结构
   - 类比
   - InnoDB 中的索引
     - 聚簇索引
     - 二级索引
   - 常见数据结构
     - Hash 结构
     - 二叉搜索树
     - AVL 树
     - B-Tree
     - B+Tree
     - R-Tree
2. 索引的创建与设计规则
   - 索引的创建、删除等
   - 哪些情况适合创建索引
     - 12 条规则
   - 哪些情况不适合创建索引
     - 7 条规则
3. 性能分析工具的使用
   - 数据库服务器的优化步骤
   - 系统性能参数
   - 统计 SQL 的查询成本：last_query_cost
   - 慢查询日志
   - 慢查询日志分析工具：mysqldumpslow
   - SQL 执行成本：SHOW PROFILE
   - 分析查询语句：EXPLAIN
4. 索引优化和查询优化
   - 调优原则与调优手段
   - 索引失效案例
     - 11 大案例分析
   - 关联查询优化
   - 子查询优化
   - 排序优化
   - GROUP BY 优化
   - 日常 SQL 编写的规范与优化
     - 16 大案例剖析
5. 数据库的设计规范
   - 六大范式
   - 反范式化
   - ER 模型
   - 表的设计原则
     - “三少一多”
   - SQL  编写建议
6. 数据库其他调优策略
   - 如何定位调优问题
   - 调优的维度和步骤
   - 优化 MySQL 服务器
     - 优化硬件
     - 优化参数
   - 优化数据库结构
     - 7 大原则
   - 大表优化
     - 限定查找范围
     - 读写分离
     - 垂直拆分
     - 水平拆分
   - 其他调优策略
     - 服务器语句超时处理
     - 创建全局通用表空间
     - 临时表性能优化
     - 隐藏索引对调优的帮助

## 08 - 事务篇

1. 事务基础知识
   - 事务处理的原则
   - 事务的 ACID 特性
   - 事务的状态
   - 事务隔离级别
2. MySQL 事务日志
   - redo 日志
     - redo 日志格式
     - redo 日志的写入过程
     - redo 日志的刷盘时机
     - 崩溃恢复
   - undo 日志
     - undo 日志的格式
     - 通用链表结构
     - Undo 页面链表
     - undo 日志具体写入过程
3. 锁
   - 并发事务访问相同记录
     - 读-读情况
     - 写-写情况
     - 读-写或写-读情况
   - 锁的不同角度分类
     - 对数据操作的类型分类划分：读锁、写锁
     - 对数据操作的粒度划分：表级锁、行锁、页级锁
       - 表级别的 S 锁、X 锁
       - 意向锁
       - 自增锁
       - MDL 锁
     - 从程序员的角度划分：乐观锁、悲观锁
     - 按加锁的方式划分：显示锁，隐式锁
     - 全局锁
     - 死锁
   - 锁的内存结构
   - 间隙锁加锁规则
     - 11 大案例剖析
4. 多版本并发控制
   - 快照读
   - 当前读
   - 版本链
   - ReadView
   - InnoDB 是如何解决幻读的

## 09 - 日志与备份篇

1. 其他数据库日志
   - 慢查询日志（slow query log）
   - 通用查询日志（general query log）
   - 错误日志（error log）
   - 二进制日志（bin log）
   - 中继日志（relay log）
   - 数据定义语句日志
2. 主从复制
   - 主从复制的原理
   - 一主一从常见配置
     - 主机配置文件
     - 从机配置文件
   - 主从同步数据一致性问题
   - 一主一从的读写分离
   - 主从复制：双主双从
   - 垂直拆分——分库
   - 水平拆分——分表
3. 数据库备份与恢复
   - mysqldump 实现逻辑备份
     - 备份全部数据库
     - 备份部分数据库
     - 备份部分表
     - 备份单表的部分数据
     - 只备份结构或只备份数据
   - 物理备份：直接复制整个数据库
     - 使用 MySQLhotcopy 工具快速备份
   - mysql 命令恢复数据
     - 单库备份中恢复单库
     - 全量备份恢复
     - 从全量备份中恢复单库
     - 从单库备份中恢复单表
   - 数据库迁移
     - 物理迁移和逻辑迁移
     - 相同版本数据库之间迁移注意点
     - 不同版本数据库之间迁移注意点
     - 全量迁移
     - 表的导出与导入

# P97 CentOS 环境的准备

## 1 安装前说明

### 1.1 Linux 系统及工具的准备

- 安装并启动好两台虚拟机：`CentOS 7`
  - 掌握克隆虚拟机的操作
    - mac 地址
    - 主机名 `vim /etc/hostname`
    - ip 地址 `vim /etc/sysconfig/network-scripts/ifcfg-ens33`
    - UUID
- 安装有 `XShell` 和 `Xftp` 等访问 CentOS 系统的工具
- CentOS 6 和 CentOS 7 在 MySQL 的使用中的区别
  1. 防火墙：6 是 iptables，7 是 firewalld
  2. 启动服务的命令：6 是 service，7 是 systemctl

# P98 MySQL 的卸载

## 1.2 查看是否安装过 MySQL

- 如果你使用 rpm 安装，检查一下 RPM PACKAGE：

  ```shell
  rpm -qa | grep -i mysql # -i 忽略大小写
  ```

- 检查 mysql service

  ```shell
  systemctl status mysqld.service
  ```

- 如果存在 mysql-libs 的旧版本包，显示如下：（有查询结果）

- 如果不存在 mysql-libs 的版本，显示如下：（无查询结果）

## 1.3 MySQL 的卸载

1. 关闭 mysql 服务

   ```shell
   systemctl stop mysqld.service
   ```

2. 查看当前 mysql 安装状况

   ```shell
   rpm -qa | grep -i mysql
   # 或
   yum list installed | grep mysql
   ```

3. 卸载上述命令查询出的已安装程序

   ```shell
   yum remove mysql-xxx mysql-xxx mysql-xxx
   ```

   务必卸载干净，反复执行 `rpm -qa | grep -i mysql` 确认是否有卸载残留

4. 删除 mysql 相关文件

   - 查找相关文件 `find / -name mysql`
   - 删除上述命令查找出的相关文件 `rm -rf xxx`

5. 删除 my.cnf `rm -rf /etc/my.cnf`

# P99 Linux 下安装 MySQL 8.0 和 5.7 版本

## 2 MySQL 的 Linux 版安装

### 2.1 MySQL 的 4 大版本

> - **MySQL Community Server 社区版本**，开源免费，自由下载，但不提供官方技术支持，适用于大多数普通用户。
> - **MySQL Enterprise Edition 企业版本**，需付费，不能在线下载，可以使用 30 天。提供了更多的功能和更完备的技术支持，更适合于对数据库的功能和可靠性要求较高的企业客户。
> - **MySQL Cluster 集群版**，开源免费。用于架设集群服务器，可将几个 MySQL Server 封装成一个 Server。需要在社区版或企业版的基础上使用。
> - **MySQL Cluster CGE 高级集群版**，需付费。

此外，官方还提供了 `MySQL Workbench`（GUI TOOL）一款专为 MySQL 设计的**ER/数据库建模工具**。它是著名的数据库设计工具DBDesigner4的继任者。MySQL Workbench 又分为两个版本，分别是**社区版**（MySQL Workbench OSS）、**商用版**（MySQL Workbench SE）。

### 2.2 下载 MySQL 指定版本

1. 下载地址：官网 https://www.mysql.com

2. 打开官网，点击 DOWNLOADS

   然后点击 MySQL Community(GPL) Downloads

3. 点击 MySQL Community Server

4. 在 General Availability(GA) Releases 中选择合适的版本

   - 如果安装 Windows 系统下 MySQL，推荐下载 **MSI 安装程序**；点击 **Go to Download Page** 进行下载即可。
   - Windows 下的 MySQL 安装有两种安装程序
     - `mysql-installer-web-community-8.0.25.0.msi` 下载程序大小：2.4M；安装时需要联网安装组件
     - `mysql-installer-community-8.0.25.0.msi` 下载程序大小：435.7M；安装时离线安装即可。**推荐**。

5. Linux 系统下安装 MySQL 的几种方式

   1. Linux 系统下安装软件的常用三种方式：

      - 方式一：rpm 命令

        使用 rpm 命令安装扩展名“.rpm”的软件包。

      - 方式二：yum 命令

        需联网，从**互联网获取**的 yum 源，直接使用 yum 命令安装。

      - 方式三：编译安装源码包

        针对 `tar.gz` 这样的压缩格式，要用 tar 命令来解压；如果是其他压缩格式，就使用其他命令。

   2. Linux 系统下安装 MySQL，官方给出多种安装方式

      | 安装方式       | 特点                                                 |
      | -------------- | ---------------------------------------------------- |
      | rpm            | 安装简单，灵活性差，无法灵活选择版本、升级           |
      | rpm repository | 安装包极小，版本安装简单灵活，升级方便，需要联网安装 |
      | 通用二进制包   | 安装比较复杂，灵活性高，平台通用性好                 |
      | 源码包         | 安装最复杂，时间长，参数设置灵活，性能好             |

      - 这里不能直接选择 CentOS 7 系统版本，所以选择与之对应的 `Red Hat Enterprise Linux`

6. 下载的 tar 包，用压缩工具打开

   - 解压后 rpm 安装包

### 2.3 CentOS 7 下检查 MySQL 依赖

1. 检查 /tmp 临时目录权限（必不可少）

   由于 mysql 安装过程中，会通过 mysql 用户在 /tmp 目录下新建 tmp_db 文件，所以请给 /tmp 较大的权限。执行：

   ```shell
   chmod -R 777 /tmp
   ```

2. 安装前，检查依赖

   ```shell
   rpm -qa | grep libaio
   rpm -qa | grep net-tools
   ```

   如果不存在 需要到 centos 安装盘里进行 rpm 安装。安装 linux 如果带图形化界面，这些都是安装好的。

### 2.4 CentOS 7 下 MySQL 安装过程

1. 将安装程序拷贝到 /opt 目录下

   在 mysql 的安装目录下执行：（必须按照顺序执行）

   ```shell
   rpm -ivh mysql-community-common-8.0.25-1.el7.x86_64.rpm
   rpm -ivh mysql-community-client-plugins-8.0.25-1.el7.x86_64.rpm
   rpm -ivh mysql-community-libs-8.0.25-1.el7.x86_64.rpm
   rpm -ivh mysql-community-client-8.0.25-1.el7.x86_64.rpm
   rpm -ivh mysql-community-server-8.0.25-1.el7.x86_64.rpm
   ```

   - 注意：如在检查工作时，没有检查 mysql 依赖环境在安装 mysql-community-server 会报错
   - `rpm` 是 Redhat Package Manage 缩写，通过 RPM 的管理，用户可以把源代码包装成以 rpm 为扩展名的文件形式，易于安装。
   - `-i` , --install 安装软件包
   - `-v`，--verbose 提供更多的详细信息输出
   - `-h`，--hash 软件包安装时列出哈希标记（和 -v 一起使用效果更好），展示进度条

2. 安装过程截图

   安装过程中可能的报错信息：`mariadb-libs 被 mysql-community-libs-8.0.25-1.el7.x86_64 取代`

   > 一个命令： yum remove mysql-libs 解决，清除之前安装过的依赖即可

3. 查看 MySQL 版本

   执行如下命令，如果成功表示安装 mysql 成功。类似 java -version 打出版本等信息

   ```shell
   mysql --version
   # 或
   mysqladmin --version
   ```

   执行如下命令，查看是否安装成功。需要增加 -i 不用去区分大小写，否则搜索不到。

   ```shell
   rpm -qa | grep -i mysql
   ```

4. 服务的初始化

   为了保证数据库目录与文件的所有者为 mysql 登录用户，如果你是以 root 身份运行 mysql 服务，需要执行下面的命令初始化：

   ```shell
   mysqld --initialize --user=mysql
   ```

   说明：--initialize 选项默认以“安全”模式来初始化，则会为 root 用户生成一个密码并将**该密码标记为过期**，登录后你需要设置一个新的密码。生成的**临时密码**会往日志中记录一份。

   查看密码：

   ```shell
   cat /var/log/mysqld.log
   ```

   root@localhost: 后面就是初始化的密码

5. 启动 MySQL，查看状态

   ```shell
   # 加不加 .service 后缀都可以
   systemctl start mysqld.service # 启动
   systemctl stop mysqld.service # 关闭
   systemctl restart mysqld.service # 重启
   systemctl status mysqld.service # 查看状态
   ```

   > `mysqld` 这个可执行文件就代表着 `MySQL` 服务器程序，运行这个可执行文件就可以直接启动一个服务器进程。

   查看进程：

   ```shell
   ps -ef | grep -i mysql
   ```

6. 查看 MySQL 服务是否自启动

   ```shell
   systemctl list-unit-files| grep mysqld.service
   ```

   默认是 enabled。

   - 如果不是 enabled 可以运行如下命令设置自启动

     ```shell
     systemctl enable mysqld.service
     ```

   - 如果希望不进行自启动，运行如下命令设置

     ```shell
     systemctl disable mysqld.service
     ```

     

# P100 SQLyog 实现 MySQL 8.0 和 5.7 的远程连接

## 3 MySQL 登录

### 3.1 首次登录

通过 `mysql -hlocalhost -P3306 -uroot -p` 进行登录

### 3.2 修改密码

- 因为初始化密码默认是过期的，所以查看数据库会报错

- 修改密码：

  ```mysql
  ALTER USER `root`@`localhost` IDENTIFIED BY `new_password`;
  ```

- 5.7 版本之后（不含5.7），mysql 加入了全新的密码安全机制。设置新密码太简单会报错。

- 改为更复杂的密码规则之后，设置成功，可以正常使用数据库了。

### 3.3 设置远程登录

1. 当前问题

   在用 SQLyog 或 Navicat 中配置远程连接 MySQL 数据库时遇到如下报错信息，这是由于 MySQL 配置了不支持远程连接引起的。

2. 确认网络

   1. 在远程机器上使用 ping ip地址 保证网络畅通

   2. 在远程机器上使用 telnet 命令保证端口号开放访问

      ```shell
      telnet ip地址 端口号
      ```

3. 关闭防火墙或开放端口

   方式一：关闭防火墙

   - CentOS 6:

     ```shell
     service iptables sto
     ```

   - CentOS 7:

     ```shell
     systemctl start firewalld.service
     systemctl status firewalld.service
     systemctl stop firewalld.service
     # 设置开机启用防火墙
     systemctl enable firewalld.service
     # 设置开机禁用防火墙
     systemctl disable firewalld.service
     ```

   方式二：开放端口

   - 查看开放的端口号

     ```shell
     firewall-cmd --list-all
     ```

   - 设置开放的端口号

     ```shell
     firewall-cmd --add-service=http --permanent
     firewall-cmd --add-port=3306/tcp --permanent
     ```

   - 重启防火墙

     ```shell
     firewall-cmd --reload
     ```

4. Linux 下修改配置

   ```mysql
   show databases;
   use mysql;
   select host, user from user;
   update user set host = '%' where user = 'root';
   flush privileges;
   ```

配置新连接报错：错误号码 2058，分析是 mysql 密码加密方法变了。

解决办法：Linux 下 mysql -u root -p 登录你的 mysql 数据库，然后执行这条 SQL：

```mysql
ALTER USER `root`@'%' IDENTIFIED WITH mysql_native_password BY 'abc123';
```

然后再重新配置 SQLyog 的连接，则可以连接成功了。

## 4 MySQL 8 的密码强度评估（了解）

### 4.1 MySQL 不同版本设置密码（可能出现）

- MySQL 5.7 中：成功

  ```shell
  mysql> alter user 'root' identified by 'abcd1234';
  Query OK, 0 rows affected (0.00 sec)
  ```

- MySQL 8.0 中：失败

  ```shell
  mysql> alter user 'root' identified by 'abcd1234';
  ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
  ```

### 4.2 MySQL 8 之前的安全策略

在 MySQL 8.0 之前，MySQL 使用的是 validate_password 插件检测、验证账号密码强度，保障账号的安全性。

安装/启用插件方式1：在参数文件 my.cnf 中添加参数

```
[mysqld]
plugin-load-add=validate_password.so
\#ON/OFF/FORCE_PLUS_PERMANENT: 是否使用该插件（及强制/永久强制使用）
validate-password=FORCE_PLUS_PERMANENT
```

> 说明1：
>
> plugin library 中的 validate_password 文件名的后缀名根据平台不同有所差异。对于 Unix 和 Unix-like 系统而言，它的文件后缀名是 .dll。
>
> 说明2：
>
> 修改参数后必须重启 MySQL 服务才能生效。
>
> 说明3：
>
> 参数 FORCE_PLUS_PERMANENT 是为了防止插件在 MySQL 运行时的时候被卸载。当你卸载插件时就会报错。

安装/启用插件方式2：运行时命令安装（推荐）

```mysql
mysql> INSTALL PLUGIN validate_password SONAME 'validate_password.so';
Query OK, 0 rows affected, 1 warning (0.11 sec)
```

此方法也会注册到元数据，也就是 mysql.plugin 表中，所以不用担心 MySQL 重启后插件会失效。

### 4.3 MySQL 8 的安全策略

22:58

### 4.4 卸载插件、组件（了解）

26:00

# P101 字符集的修改与底层原理说明

## 5 字符集的相关操作

### 5.1 修改 MySQL 5.7 字符集

#### 修改步骤

在 MySQL 8.0 版本之前，默认字符集为 `latin1`，utf8 字符集指向的是 `utf8mb3`。网站开发人员在数据库设计的时候往往会将编码修改为 utf8 字符集。如果遗忘修改默认的编码，就会出现乱码的问题。从 MySQL 8.0 开始，数据库的默认编码将改为 `utf8mb4`，从而避免上述乱码的问题。

操作1：查看默认使用的字符串

```mysql
show variables like 'character%';
# 或者
show variables like '%char%';
```

操作2：修改字符集

```shell
vim /etc/my.cnf
```

在 MySQL 5.7 或之前的版本中，在文件最后加上中文字符集配置：

```
character_set_server=utf8
```

操作3：重新启动 MySQL 服务

```shell
systemctl restart mysqld
```

> 但是原库、原表的设定不会发生变化，参数修改只对新建的数据库生效。

#### 已有库 & 库字符集的变更

MySQL 5.7 版本中，以前创建的库，创建的表字符集还是 latin1。

修改已创建数据库的字符集

```mysql
alter database dbtest1 character set 'utf8';
```

修改已创建数据表的字符集

```mysql
alter table t_emp convert to character set 'utf8';
```

> 注意：但是原有的数据如果是用非 'utf8' 编码的话，数据本身编码不会发生改变。已有数据需要导出或删除，然后重新插入。

### 5.2 各级别的字符集

MySQL 有 4 个级别的字符集和比较规则，分别是：

- 服务器级别
- 数据库级别
- 表级别
- 列级别

执行如下 SQL 语句：

```mysql
show variables like 'character%';
```

- character_set_server：服务器级别的字符集
- character_set_database：当前数据库的字符集
- character_set_client：服务器解码请求时使用的字符集
- character_set_connection：服务器处理请求时会把请求字符串从 character_set_client 转为 character_set_connection
- character_set_results：服务器向客户端返回数据时使用的字符集

#### 服务器级别

character_set_server 服务器级别的字符集

我们可以在启动服务器程序时通过启动选项或者在服务器程序运行过程中使用 `SET` 语句修改这两个变量的值。比如我们可以在配置文件中这样写：

```mysql
[server]
character_set_server=gbk # 默认字符集
collation_server=gbk_chinese_ci # 对应的默认的比较规则
```

当服务器启动的时候读取这个配置文件后这两个系统变量的值便修改了。

#### 数据库级别

character_set_database：当前数据库的字符集

我们在创建和修改数据库的时候可以指定该数据库的字符集和比较规则，具体语法如下：

```mysql
CREATE DATABASE 数据库名
	[[DEFAULT] CHARACTER SET 字符集名称]
	[[DEFAULT] COLLATE 比较规则名称];

ALTER DATABASE 数据库名
	[[DEFAULT] CHARACTER SET 字符集名称]
	[[DEFAULT] COLLATE 比较规则名称];
```

其中 `DEFAULT` 可以忽略，并不影响语句的语义。

数据库的创建语句中也可以不指定字符集和比较规则，比如这样：

```mysql
CREATE DATABASE 数据库名;
```

这样的话将使用服务器级别的字符集和比较规则作为数据库的字符集和比较规则。

#### 表级别

我们也可以在创建和修改表的时候指定表的字符集和比较规则，语法如下：

```mysql
CREATE TABLE 表名 (列的信息)
	[[DEFAULT] CHARACTER SET 字符集名称]
	[[DEFAULT] COLLATE 比较规则名称];

ALTER TABLE 表名
	[[DEFAULT] CHARACTER SET 字符集名称]
	[[DEFAULT] COLLATE 比较规则名称];
```

如果创建和修改表的语句中没有指明字符集和比较规则，将使用该表所在数据库的字符集和比较规则作为该表的字符集和比较规则。

#### 列级别

对于存储字符串的列，同一个表中的不同的列也可以有不同的字符集和比较规则。我们在创建和修改列定义的时候可以指定该列的字符集和比较规则，语法如下：

```mysql
CREATE TABLE 表名(
    列名 字符串类型 [CHARACTER SET 字符集名称] [COLLATE 比较规则名称],
    其他列...
);

ALTER TABLE 表名 MODIFY 列名 字符串类型 [CHARACTER SET 字符集] [COLLATE 比较规则名称];
```

对于某个列来说，如果在创建和修改的语句中没有指明字符集和比较规则，将使用该列所在表的字符集和比较规则作为该列的字符集和比较规则。

> 提示
>
> 在转换列的字符集时需要注意，如果转换前列中存储的数据不能用转换后的字符集进行表示会发生错误。比如说原先列使用的字符集是 utf8，列中存储了一些汉字，现在把列的字符集转换为 ascii 的话就会出错，因为 ascii 字符集并不能表示汉字字符。

# P102 比较规则_请求到响应过程中的编码和解码过程

## 5.3 字符集与比较规则（了解）

### utf8 和 utf8mb4

`utf8` 字符集表示一个字符需要使用 1 ~ 4 个字节，但是我们常用的一些字符使用 1 ~ 3 个字节就可以表示了。而字符集表示一个字符所用的最大字节长度，在某些方面会影响系统的存储和性能，所以设计 MySQL 的设计者偷偷的定义了两个概念：

- `utf8mb3`：阉割过的 `utf8` 字符集，只使用 1 ~ 3 个字节表示字符。
- `utf8mb4`：正宗的 `utf8` 字符集，使用 1 ~ 4 个字节表示字符。

在 MySQL 中 `utf8` 是 `utf8mb3` 的别名，所以之后在 MySQL 中提到 `utf8` 就意味着使用 1 ~ 3 个字节来表示一个字符。如果大家有使用 4 字节编码一个字符的情况，比如存储一些 emoji 表情，那请使用 `utf8mb4`。

此外，通过如下指令可以查看 MySQL 支持的字符集：

```mysql
SHOW CHARSET;
# 或者
SHOW CHARACTER SET;
```

### 比较规则

上表中，MySQL 版本一共支持 41 种字符集，其中 `Default collation` 列表示这种字符集中一种默认的比较规则，里面包含着该比较规则主要作用于哪种语言，比如 `utf8_polish_ci` 表示以波兰语的规则比较，`utf8_spanish_ci` 是以西班牙语的规则比较，`utf8_general_ci` 是一种通用的比较规则。

后缀表示该比较规则是否区分语言中的重音、大小写。具体如下：

| 后缀 | 英文释义           | 描述             |
| ---- | ------------------ | ---------------- |
| _ai  | accent insensitive | 不区分重音       |
| _as  | accent sensitive   | 区分重音         |
| _ci  | case insensitive   | 不区分大小写     |
| _cs  | case sensitive     | 区分大小写       |
| _bin | binary             | 以二进制方式比较 |

最后一列 `maxLen`，它代表该种字符集表示一个字符最多需要几个字节。

这里把常见的字符集和对应的 MaxLen 显示如下：

| 字符集名称 | MaxLen |
| ---------- | ------ |
| ascii      | 1      |
| latin1     | 1      |
| gb2312     | 2      |
| gbk        | 2      |
| utf8       | 3      |
| utf8mb4    | 4      |

常用操作1：

```mysql
# 查看 GBK 字符集的比较规则
SHOW COLLATION LIKE 'gbk%';
# 查看 UTF-8 字符集的比较规则
SHOW COLLATION LIKE 'utf8%';
```

常用操作2：

```mysql
# 查看服务器的字符集和比较规则
SHOW VARIABLES LIKE '%_server';
# 查看数据库的字符集和比较规则
SHOW VARIABLES LIKE '%_database';
# 查看具体数据库的字符集
SHOW CREATE DATABASE dbtest1;
# 修改具体数据库的字符集
ALTER DATABASE dbtest1 DEFAULT CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';
```

说明1：

> utf8_unicode_ci 和 utf8_general_ci 对中、英文来说没有本质的区别。
>
> utf8_general_ci 校对速度快，但准确度稍差。
>
> utf8_unicode_ci 准确度高，但校对速度稍慢。
>
> 一般情况下，用 utf8_general_ci 就够了，但如果你的应用有德语、法语或者俄语，请一定使用 utf8_unicode_ci。

说明2：

> 修改了数据库的默认字符集和比较规则后，原来已经创建的表格的字符集和比较规则并不会改变，如果需要，那么需单独修改。

常用操作3：

```mysql
# 查看表的字符集
show create table employees;
# 查看表的比较规则
show table status from atguigudb like 'employees';
# 修改表的字符集和比较规则
ALTER TABLE emp1 DEFAULT CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';
```

## 5.4 请求到响应过程中字符集的变化

我们知道从客户端发往服务器的请求本质上就是一个字符串，服务器向客户端返回的结果本质上也是一个字符串，而字符串其实是使用某种字符集编码的二进制数据。这个字符串可不是使用一种字符集的编码方式一条道走到黑的，从发送请求到返回结果这个过程中伴随着多次字符集的转换，在这个过程中会用到 3 个系统变量，我们先把它们写出来看一下：

| 系统变量                   | 描述                                                         |
| -------------------------- | ------------------------------------------------------------ |
| `character_set_client`     | 服务器解码请求时使用的字符集                                 |
| `character_set_connection` | 服务器处理请求时会把字符串从 `character_set_client` 转为 `character_set_connection` |
| `character_set_results`    | 服务器向客户端返回数据时使用的字符集                         |

12:36

从这个分析中我们可以得出这么几点需要注意的地方：

- 服务器认为客户端发送过来的请求是用 `character_set_client` 编码的。

  假设你的客户端采用的字符集和 `character_set_client` 不一样的话，这就会出现识别不准确的情况。比如我的客户端使用的是 `utf8` 字符集，如果把系统变量 `character_set_client` 的值设置为 `ascii` 的话，服务器可能无法理解我们发送的请求，更别谈处理这个请求了。

- 服务器将把得到的结果集使用 `character_set_results` 编码后发送给客户端。

  假设你的客户端采用的字符集和 `character_set_results` 不一样的话，这就可能会出现客户端无法解码结果集的情况，结果就是在你的屏幕上出现乱码。比如我的客户端使用的是 `utf8` 字符集，如果把系统变量 `character_set_results` 的值设置为 `ascii` 的话，可能会产生乱码。 

- `character_set_connection` 只是服务器在将请求的字节串从 `character_set_client` 转换为 `character_set_connection` 时使用，一定要注意，该字符集包含的字符范围一定涵盖请求中的字符，要不然会导致有的字符无法使用 `character_set_connection` 代表的字符集进行编码。

经验

开发中通常把 `character_set_client`、`character_set_results`、`character_set_connection` 这三个系统变量设置成和客户端使用的字符集一致的情况，这样减少了很多无谓的字符集转换。为了方便我们设置，MySQL 提供了一条非常简便的语句：

```mysql
SET NAMES 字符集名;
```

这一条语句产生的效果和我们执行这 3 条的效果是一样的：

```mysql
SET character_set_client = 字符集名;
SET character_set_connection = 字符集名;
SET character_set_results = 字符集名;
```

另外如果你想在启动客户端的时候就把 `character_set_client`、`character_set_results`、`character_set_connection` 这三个系统变量设置成一样的，那我们可以在启动客户端的时候指定一个叫 `default-character-set` 的启动选项，比如在配置文件里可以这么写：

```mysql
[client]
default-character-set=utf8
```

它起到的效果和执行一遍 `SET NAMES utf8` 是一样一样的，都会将那三个系统变量的值设置成 `utf8`。

# P103 SQL 大小写规范与 sql_mode 的设置

## 6 SQL 大小写规范

### 6.1 Windows 和 Linux 平台区别

在 SQL 中，关键字和函数名是不用区分字母大小写的

Windows 系统默认大小写不敏感，但是 Linux 系统是大小写敏感的

```mysql
SHOW VARIABLES LIKE '%lower_case_table_names%';
```

lower_case_table_names 参数值的设置：

- 默认为 0，大小写敏感。
- 设置 1，大小写不敏感。创建的表，数据库都是以小写形式存放在磁盘上，对于 SQL 语句都是转换为小写对表和数据库进行查找。
- 设置 2，创建的表和数据库依据语句上格式存放，凡是查找都是转换为小写进行。

### 6.2 Linux 下大小写规则设置

06:25

当想设置为大小写不敏感时，要在 `my.cnf` 这个配置文件 `[mysqld]` 中写入 `lower_case_table_names=1`，然后重启服务器。

此参数适用于 MySQL 5.7。MySQL 8 必须先删除数据目录

### 6.3 SQL 编写建议

09:15

## 7 sql_mode 的合理设置

10:30

### 7.1 介绍

sql_mode 会影响 MySQL 支持的 SQL 语法以及它执行的数据验证检查。通过设置 sql_mode，可以完成不同严格程度的数据校验，有效地保障数据准确性。

- 5.6 的 mode 默认值为空（即：`NO_ENGINE_SUBSTITUTION`），其实表示的是一个空值，相当于没有什么模式设置，可以理解为宽松模式。在这种设置下是可以允许一些非法操作的，比如允许一些非法数据的插入。
- 5.7 的 mode 是 `STRICT_TRANS_TABLES`，也就是严格模式。用于进行数据的严格校验，错误数据不能插入，报 error（错误），并且事务回滚

### 7.2 宽松模式 vs 严格模式

12:20

`char(10)` 如果超过了设定的字段长度 10

### 7.3 宽松模式再举例

15:56

### 7.4 模式查看和设置

16:05

查看当前的 sql_mode

```mysql
select @@session.sql_mode
select @@global.sql_mode
# 或者
show variables like 'sql_mode';
```

临时设置方式：设置当前窗口中设置 sql_mode

```mysql
SET GLOBAL sql_mode = 'modes...'; # 全局
SET SESSION sql_mode = 'modes...'; # 当前会话
```

永久设置方式：在 /etc/my.cnf 中配置 sql_mode

```mysql
[mysqld]
sql_mode=ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
```

# P104 MySQL 目录结构与表在文件系统中的表示

## 1 MySQL 8 的主要目录结构

```shell
find / -name mysql
```

### 1.1 数据库文件的存放路径

MySQL 数据库文件的存放路径：/var/lib/mysql/

数据目录对应着一个系统变量`datadir`

```mysql
SHOW VARIABLES LIKE 'datadir';
```

### 1.2 相关命令目录

/usr/bin（mysqladmin、mysqlbinlog、mysqldump 等命令）和 /usr/sbin

### 1.3 配置文件目录

/usr/share/mysql-8.0（命令及配置文件），/etc/mysql（如 my.cnf）

## 2 数据库和文件系统的关系

### 2.1 查看默认数据库

```mysql
SHOW DATABASES;
```

可以看到有 4 个数据库是属于 MySQL 自带的系统数据库。

- `mysql`

  MySQL 系统自带的核心数据库，它存储了 MySQL 的用户账户和权限信息，一些存储过程、事件的定义信息，一些运行过程中产生的日志信息，一些帮助信息以及时区信息等。

- `information_schema`

  MySQL 系统自带的数据库，这个数据库保存着 MySQL 服务器维护的所有其他数据库的信息，比如有哪些表、哪些视图、哪些触发器、哪些列、哪些索引。这些信息并不是真实的用户数据，而是一些描述性信息，有时候也称之为**元数据**。在系统数据库 `information_schema` 中提供了一些以 `innodb_sys` 开头的表，用于表示内部系统表。

  ```mysql
  USE information_schema;
  SHOW TABLES LIKE 'innodb_sys%'
  ```

- `performance_schema`

  MySQL 系统自带的数据库，这个数据库里主要保存 MySQL 服务器运行过程中的一些状态信息，可以用来监控 MySQL 服务的各类性能指标。包括统计最近执行了哪些语句，在执行过程的每个阶段都花费了多长时间，内存的使用情况等信息。

- `sys`

  MySQL 系统自带的数据库，这个数据库主要是通过视图的形式把 `information_schema` 和 `performance_schema` 结合起来，帮助系统管理员和开发人员监控 MySQL 的技术性能。

### 2.2 数据库在文件系统中的表示

12:35

`db.opt` 5.7 存在，8 没有

### 2.3 表在文件系统中的表示

#### 2.3.1 InnoDB 存储引擎模式

`.frm` 5.7 存在，8 没有（合并在 `.ibd` 里）

`ibdata1` 系统表空间

`.ibd` 独立表空间

#### 2.3.2 MyISAM 存储引擎模式

`.frm` 表结构 5.7 -> `.sdi` 8 存储元数据

`.MYD` 数据（MYData）

`.MYI` 索引（MYIndex）

### 2.4 小结

### 2.5 视图在文件系统中的表示

我们知道 MySQL 中的视图其实是虚拟的表，也就是某个查询语句的一个别名而已，所以在存储视图的时候是不需要存储真实的数据的，只需要把它的结构存储起来就行了。和表一样，描述视图结构的文件也会被存储到所属数据库对应的子目录下边，只会存储一个`视图名.frm`的文件。

### 2.6 其他的文件

- 服务器进程文件
- 服务器日志文件
- 默认/自动生成的 SSL 和 RSA 证书和密钥文件

# P105 用户的创建\修改\删除

## 1 用户管理

2:56

MySQL 用户可以分为普通用户和 root 用户。root 用户是超级管理员，拥有所有权限，包括创建用户、删除用户和修改用户的密码等管理权限；普通用户只拥有被授予的各种权限。

MySQL 提供了许多语句用来管理用户账号，这些语句可以用来管理包括登录和退出 MySQL 服务器，创建用户、删除用户、密码管理和权限管理等内容。

MySQL 数据库的安全性需要通过账户管理来保证。

### 1.1 登录 MySQL 服务器

启动 MySQL 服务后，可以通过 mysql 命令来登录 MySQL 服务器，命令如下：

```shell
mysql -h hostname|hostIP -P port -u username -p DatabaseName -e "SQL语句"
```

### 1.2 创建用户

7:25

在 MySQL 数据库中，官方推荐使用 CREATE USER 语句创建新用户。MySQL 8 版本移除了 PASSWORD 加密方法，因此不再推荐使用 INSERT 语句直接操作 MySQL 中的 user 表来增加用户。

使用 CREATE USER 来创建新用户时，必须拥有 CREATE USER 权限。每添加一个用户，CREATE USER 语句会在 MySQL.user 表中添加一条新纪录，但是新创建的账户没有任何权限。如果添加的账户已经存在，CREATE USER 语句就会返回一个错误。

CREATE USER 语句的基本语法形式如下：

```mysql
CREATE USER 用户名 [IDENTIFIED BY '密码'] [,用户名 [INDENTIFIED BY '密码']];
```

### 1.3 修改用户

14:42

```mysql
UPDATE mysql.user SET USER='li4' WHERE USER='wang5';
FLUSH PRIVILEGES;
```

### 1.4 删除用户

17:35

在 MySQL 数据库中，可以使用 `DROP USER` 语句来删除普通用户，也可以直接在 mysql.user 表中删除用户。

**方式1：使用 DROP 方式删除（推荐）**

```mysql
DROP USER user[, user];
```

默认@'%'

**方式2：使用 DELETE 方式删除**

```mysql
DELETE FROM mysql.user WHERE Host='hostname' AND User='username';
FLUSH PRIVILEGES; 
```

> 注意：不推荐通过 `DELETE` 进行删除，系统会有残留信息保留。而 `DROP USER` 命令会删除用户以及对应的权限，执行命令后你会发现 mysql.user 表和 mysql.db 表的相应记录都消失了。

# P106 用户密码的设置和管理

## 1.5 设置当前用户密码

MySQL 8 中已移除了 PASSWORD() 函数

旧的写法如下：

```mysql
# 修改当前用户的密码：（MySQL 5.7 测试有效）
SET PASSWORD = PASSWORD('123456');
```

这里介绍推荐的写法：

1、使用 ALTER USER 命令来修改当前用户密码

```mysql
ALTER USER USER() IDENTIFIED BY 'new_password';
```

2、使用 SET 语句来修改当前用户密码

```mysql
SET PASSWORD='new_password';
```

## 1.6 修改其他用户密码

1、使用 ALTER 语句来修改普通用户的密码

```mysql
ALTER USER user [IDENTIFIED BY '新密码'][, user [IDENTIFIED BY '新密码']]...;
```

2、使用 SET 命令来修改普通用户的密码

```mysql
SET PASSWORD FOR 'username'@'hostname'='new_password';
```

3、使用 UPDATE 命令来修改普通用户的密码（不推荐）

```mysql
UPDATE MySQL.user SET authentication_string=PASSWORD('123456') WHERE User = 'username' AND Host = 'hostname';
```

### 1.7 MySQL 8 的密码管理（了解）

09:53

（1）密码过期：要求定期修改密码

（2）密码重用限制：不允许使用旧密码

（3）密码强度评估：要求使用高强度的密码

# P107 权限管理与访问控制

## 2 权限管理

关于 MySQL 的权限简单的理解就是 MySQL 允许你做你权力以内的事情，不可以越界。比如只允许你执行 SELECT 操作，那么你就不能执行 UPDATE 操作。只允许你从某台机器上连接 MySQL，那么你就不能从除那台机器以外的其他机器连接 MySQL。

### 2.1 权限列表

1:28

```mysql
SHOW PRIVILEGES;
```

| 权限                    | user 表中对应的列      | 权限的范围           |
| ----------------------- | ---------------------- | -------------------- |
| CREATE                  | Create_priv            | 数据库、表或索引     |
| DROP                    | Drop_priv              | 数据库、表或视图     |
| GRANT OPTION            | Grant_priv             | 数据库、表或存储过程 |
| REFERENCES              | References_priv        | 数据库或表           |
| EVENT                   | Event_priv             | 数据库               |
| ALTER                   | Alter_priv             | 数据库               |
| DELETE                  | Delete_priv            | 表                   |
| INDEX                   | Index_priv             | 表                   |
| INSERT                  | Insert_priv            | 表                   |
| SELECT                  | Select_priv            | 表或列               |
| UPDATE                  | Update_priv            | 表或列               |
| CREATE TEMPORARY TABLES | Create_tem_table_priv  | 表                   |
| LOCK TABLES             | Lock_priv              | 表                   |
| TRIGGER                 | Trigger_priv           | 表                   |
| CREATE VIEW             | Create_view_priv       | 视图                 |
| SHOW VIEW               | Show_view_priv         | 视图                 |
| ALTER ROUTINE           | Alter_routine_priv     | 存储过程和函数       |
| CREATE ROUTINE          | Create_routine_priv    | 存储过程和函数       |
| EXECUTE                 | Execute_priv           | 存储过程和函数       |
| FILE                    | File_priv              | 访问服务器上的文件   |
| CREATE TABLESPACE       | Create_tablespace_priv | 服务器管理           |
| CREATE USER             | Create_user_priv       | 服务器管理           |
| PROCESS                 | Process_priv           | 存储过程和函数       |
| RELOAD                  | Reload_priv            | 访问服务器上的文件   |
| REPLICATION CLIENT      | Repl_client_priv       | 服务器管理           |
| REPLICATION SLAVE       | Repl_slave_priv        | 服务器管理           |
| SHOW DATABASES          | Show_db_priv           | 服务器管理           |
| SHUTDOWN                | Shutdown_priv          | 服务器管理           |
| SUPER                   | Super_priv             | 服务器管理           |

| 权限分布 | 可能的设置的权限                                             |
| -------- | ------------------------------------------------------------ |
| 表权限   | Select, Insert, Update, Delete, Create, Drop, Grant, References, Index, Alter |
| 列权限   | Select, Insert, Update, References                           |
| 过程权限 | Execute, Alter Routine, Grant                                |

### 2.2 授予权限的原则

02:45

### 2.3 授予权限

04:12

给用户授权的方式有 2 种，分别是通过把角色赋予用户给用户授权和直接给用户授权。

```mysql
GRANT 权限1，权限2，...权限n ON 数据库名称.表名称 TO 用户名@用户地址 [IDENTIFIED BY '密码口令'];
```

- `GRANT ALL PRIVILEGES ON ...` 所有库所有表的全部权限
- 如果需要赋予包括 GRANT 的权限，添加参数 `WITH GRANT OPTION` 这个选项即可，表示该用户可以将自己拥有的权限授权给别人。
- 可以使用 GRANT 重复给用户添加权限，权限叠加。

> 横向分组
>
> 纵向分组

### 2.4 查看权限

15:52

- 查看当前用户权限

  ```mysql
  SHOW GRANTS;
  SHOW GRANTS FOR CURRENT_USER;
  SHOW GRANTS FOR CURRENT_USER();
  ```

- 查看某用户的全局权限：

  ```mysql
  SHOW GRANTS FOR 'user'@'主机地址';
  ```

### 2.5 收回权限

16:12

- 收回权限命令

  ```mysql
  REVOKE 权限1，权限2，... 权限n ON 数据库名称.表名称 FROM 用户名@用户地址;
  ```

- `REVOKE ALL PRIVILEGES ON *.* FROM joe@'%'`

## 3 权限表

24:10

MySQL 服务器通过权限表来控制用户对数据库的访问，权限表存放在 mysql 数据库中。MySQL 数据库系统会根据这些权限表的内容为每个用户赋予相应的权限。这些权限表中最重要的是 user 表、db 表。除此之外，还有 table_priv 表、column_priv 表和 proc_priv 表等。在 MySQL 启动时，服务器将这些数据库表中权限信息的内容读入内存。

## 4 访问控制（了解）

33:50

### 4.1 连接核实阶段

### 4.2 请求核实阶段

# P108 角色的使用

## 5 角色管理

### 5.1 角色的理解

角色是 MySQL 8.0 引入的新功能。在 MySQL 中，角色是权限的集合。

引入角色的目的是方便管理拥有相同权限的用户。

### 5.2 创建角色

05:30

`CREATE ROLE`

### 5.3 给角色赋予权限

07:10

```mysql
GRANT ALL PRIVILEGES ON school.* TO 'school_admin';
GRANT SELECT ON school.* TO 'school_read';
```



### 5.4 查看角色的权限

09:30

```mysql
SHOW GRANTS FOR 'manager';
```

### 5.5 回收角色的权限

10:52

```mysql
REVOKE privileges ON tablename FROM 'rolename';
```

### 5.6 删除角色

11:53

```mysql
DROP ROLE role[, role2]...
```

### 5.7 给用户赋予角色

12:50

```mysql
GRANT role[, role2, ...] TO user[, user2, ...];
```

`SELECT CURRENT_ROLE()`

MySQL 中创建了角色以后，默认都是没有被激活。

### 5.8 激活角色

16:55

方式1：使用 SET DEFAULT ROLE 命令激活角色

```mysql
SET DEFAULT ROLE ALL TO 'kangshifu'@'localhost', 'dev1'@'localhost';
```

方式2：将 activate_all_roles_on_login 设置为 ON

```mysql
SET GLOBAL activate_all_roles_on_login=ON;
```

### 5.9 撤销用户的角色

20:47

```mysql
REVOKE role FROM user;
```

### 5.10 设置强制角色（mandatory role）

22:43

强制角色是给每个创建账户的默认角色，不需要手动设置。强制角色无法被 `REVOKE` 或者 `DROP`

方式1：服务启动前设置

```mysql
[mysqld]
mandatory_role='role1,role2@localhost,r3@%.atguigu.com'
```

方式2：运行时设置

```mysql
SET PERSIST mandatory_role='role1,role2@localhost,r3@%.atguigu.com'
SET GLOBAL mandatory_role='role1,role2@localhost,r3@%.atguigu.com'
```

### 5.11 小结

# P109 配置文件、系统变量与MySQL逻辑架构

## 6 配置文件的使用

### 6.1 配置文件格式

```mysql
[server]
option1 # 这是 option1，该选项不需要选项值
option2=value2 # 这是 option2，该选项需要选项值
(具体的启动选项...)
[mysqld]
(具体的启动选项...)
[mysqld_safe]
(具体的启动选项...)
[client]
(具体的启动选项...)
[mysql]
(具体的启动选项...)
[mysqladmin]
(具体的启动选项...)
```

`=` 周围可以有空白字符

`#` 来添加注释

### 6.2 启动命令与选项组

03:16

- `[server]` 组下边的启动选项将作用于**所有的服务器**程序。
- `[client]` 组下边的启动选项将作用于**所有的客户端**程序。

下面是启动命令能读取的选项组都有哪些：

| 启动命令       | 类别       | 能读取的组                                |
| -------------- | ---------- | ----------------------------------------- |
| `mysqld`       | 启动服务器 | `[mysqld]`、`[server]`                    |
| `mysqld_safe`  | 启动服务器 | `[mysqld]`、`[server]`、`[mysqld_safe]`   |
| `mysql.server` | 启动服务器 | `[mysqld]`、`[server]`、`[mysqld.server]` |
| `mysql`        | 启动客户端 | `[mysql]`、`[client]`                     |
| `mysqladmin`   | 启动客户端 | `[mysqladmin]`、`[client]`                |
| `mysqldump`    | 启动客户端 | `[mysqldump]`、`[client]`                 |

### 6.3 特定MySQL版本的专用选项组

05:25

我们可以在选项组的名称后加上特定的 MySQL 版本号，比如 `[mysqld-5.7]`

### 6.4 同一个配置文件中多个组的优先级

05:50

以最后一个出现的组中的启动选项为准

### 6.5 命令行和配置文件中启动选项的区别

06:41

如果同一个启动选项既出现在命令行中，又出现在配置文件中，那么以命令行中的启动选项为准！

## 7 系统变量（复习）

07:20

### 7.1 系统变量简介

### 7.2 查看系统变量

### 7.3 设置系统变量

#### 7.3.1 通过启动选项设置

- 通过命令行
- 通过配置文件

#### 7.3.2 服务器程序运行过程中设置

设置不同作用范围的系统变量

- `GLOBAL`：全局变量，影响服务器的整体操作。
- `SESSION`：会话变量，影响某个客户端连接的操作。（注：`SESSION` 有个别名叫 `LOCAL`）

```mysql
SET [GLOBAL|SESSION] 系统变量名 = 值;
SET [@@(GLOBAL|SESSION).]var_name = XXX;
```

## 1 逻辑架构剖析

09:35

### 1.1 服务器处理客户端请求

首先 MySQL 是典型的 C/S 架构，即 Client/Server 架构，服务器端程序使用的 `mysqld`。

不论客户端进程和服务器进程是采用哪种方式进行通信，最后实现的效果都是：客户端进程向服务器进程发送一段文本（SQL 语句），服务器进程处理后再向客户端进程发送一段文本（处理结果）。

客户端 -> 第一部分：连接管理（处理连接）-> 第二部分：解析与优化（查询缓存 -> 语法解析 -> 查询优化） -> 第三部分：存储引擎 -> 文件系统

- 客户端程序
- 基础服务组件
- 连接池
- SQL 接口
- 解析器
- 优化器
- 查询缓存
- 插件式的存储引擎
- 文件系统
- 日志文件

### 1.2 Connectors

26:13

### 1.3 第1层：连接层

27:45

做的第一件事就是建立 `TCP` 连接。

MySQL 服务器里有专门的 TCP 连接池限制连接数，采用长连接模式复用 TCP 连接

连接管理的职责是负责认证、管理连接、获取权限信息。

### 1.4 第2层：服务层

29:24

- SQL Interface: SQL 接口
  - MySQL 支持 DML（数据操作语言）、DDL（数据定义语言）、存储过程、视图、触发器、自定义函数等多种 SQL 语言接口
- Parser: 解析器
- Optimizer：优化器
  - SQL 语句在语法解析之后，查询之前会使用查询优化器确定 SQL 语句的执行路径，生成一个**执行计划**。
  - 它使用“选取-投影-连接”策略进行查询
- Caches & Buffers：查询缓存组件
  - MySQL 5.7.20 开始不推荐使用查询缓存，并在 MySQL 8.0 中删除

### 1.5 第3层：引擎层

32:55

插件式存储引擎层（Storage Engines），真正的负责了 MySQL 中数据的存储和提取，对物理服务器级别维护的底层数据执行操作，服务器通过 API 与存储引擎进行通信。

### 1.6 存储层

### 1.7 小结

# P110 SQL 执行流程

## 2 SQL 执行流程

### 2.1 MySQL 中的 SQL 执行流程

MySQL 的查询流程：

1. 查询缓存

   查询缓存命中率不高

   总之，因为查询缓存往往弊大于利，查询缓存的失效非常频繁。

   一般建议大家在静态表里使用查询缓存。

   ```mysql
   # query_cache_type 有 3 个值：0 代表关闭查询缓存OFF,1 代表开启ON，2（DEMAND）
   query_cache_type=2
   ```

   你确定要使用查询缓存的语句，可以用 `SQL_CACHE` 显式指定

   监控查询缓存的命中率：`SHOW STATUS LIKE '%Qcache%';`

   - `Qcache_free_blocks` 表示查询缓存中还有多少剩余的 blocks，如果该值显示较大，则说明查询缓存中的内存碎片过多了，可能在一定的时间进行整理。
   - `Qcache_free_memory` 查询缓存的内存大小
   - `Qcache_hits` 表示有多少次命中缓存
   - `Qcache_inserts` 表示多少次未命中然后插入
   - `Qcache_lowmem_prunes` 该参数记录有多少条查询因为内存不足而被移除出查询缓存。
   - `Qcache_not_cached` 表示因为 query_cache_type 的设置而没有被缓存的查询数量
   - `Qcache_queries_in_cache` 当前缓存中缓存的查询数量
   - `Qcache_total_blocks` 当前缓存的 block 数量。

2. 解析器：在解析器中对 SQL 语句进行语法分析、语义分析。

3. 优化器：在优化器中会确定 SQL 语句的执行路径，比如是根据全表检索，还是根据索引检索等。

   逻辑查询优化和物理查询优化

4. 执行器

   在执行之前需要判断用户是否具备权限。

SQL 语句在 MySQL 中的流程是：**SQL 语句 -> 查询缓存 -> 解析器 -> 优化器 -> 执行器**

# P111 MySQL 8.0 和 5.7 中 SQL 执行流程的演示

```mysql
show profiles;
show profile;
show profile for query 7;
```

# P112 Oracle 中 SQL 执行流程、缓冲池的使用

### 2.5 Oracle 中的 SQL 执行流程（了解）

Oracle 中采用了共享池来判断 SQL 语句是否存在缓存和执行计划，通过这一步骤我们可以知道应该采用硬解析还是软解析。

1. 语法检查
2. 语义检查
3. 权限检查
4. 共享池检查：共享池（Shared Pool）是一块内存池，最主要的作用是缓存 SQL 语句和该语句的执行计划。
5. 优化器：如果要进行硬解析，也就是决定怎么做，比如创建解析树，生成执行计划
6. 执行器

## 3 数据库缓冲池（buffer pool）

06:10

InnoDB 存储引擎是以页为单位来管理存储空间的，我们进行的增删改查操作其实本质上都是在访问页面（包括读页面、写页面、创建新页面等操作）。而磁盘 I/O 需要消耗的时间很多，而在内存中进行操作，效率则会高很多，为了能让数据表或者索引中的数据随时被我们所用，DBMS 会申请占用内存来作为数据缓存池，在真正访问页面之前，需要把在磁盘上的页缓存到内存中的 Buffer Pool 之后才可以访问。

这样做的好处是可以让磁盘活动最小化，从而减少与磁盘直接进行 I/O 的时间。要知道，这种策略对提升 SQL 语句的查询性能来说至关重要。如果索引的数据在缓冲池里，那么访问的成本就会降低很多。

### 3.1 缓冲池 vs 查询缓存

缓冲池和查询缓存是一个东西吗？不是。

#### 1、缓冲池（Buffer Pool）

放在缓冲池里的：数据页、插入缓存、自适应索引哈希、索引页、锁信息、数据字典信息

缓冲池的预读特性：局部性原理

#### 2、查询缓存

### 3.2 缓冲池如何读取数据

12:35

缓冲池管理器会尽量将经常使用的数据保存起来，在数据库进行页面读操作的时候，首先会判断该页面是否在缓冲池中，如果存在就直接读取，如果不存在，就会通过内存或磁盘将页面存放到缓冲池中再进行读取。

**如果我们执行 SQL 语句的时候更新了缓冲池中的数据，那么这些数据会马上同步到磁盘上吗？**

实际上，当我们对数据库中的记录进行修改的时候，首先会修改缓冲池中页里面的记录信息，然后数据库会以一定的频率刷新到磁盘上。注意并不是每次发生更新操作，都会立刻进行磁盘回写。缓冲池会采用一种叫做 checkpoint 的机制将数据回写到磁盘上，这样做的好处就是提升了数据库的整体性能。

### 3.3 查看/设置缓冲池的大小

14:03

MyISAM 存储引擎，它只缓存索引，不缓存数据，对应的键缓存参数为 `key_buffer_size`

InnoDB 存储引擎，可以通过查看 `innodb_buffer_pool_size` 变量来查看缓冲池的大小。命令如下：

```mysql
SHOW VARIABLES LIKE 'innodb_buffer_pool_size'
```

我们可以修改缓冲池大小，比如改为 256 MB，方法如下：

```mysql
SET GLOBAL innodb_buffer_pool_size = 268435456;
```

或者

```mysql
[server]
innodb_buffer_pool_size = 268435456
```

### 3.4 多个 Buffer Pool 实例

15:20

Buffer Pool 本质是 InnoDB 向操作系统申请的一块连续的内存空间，在多线程环境下，访问 Buffer Pool 中的数据都需要加锁处理。在 Buffer Pool 特别大而且多线程并发访问特别高的情况下，单一的 Buffer Pool 可能会影响请求的处理速度。所以在 Buffer Pool 特别大的时候，我们可以把它们拆分成若干个小的 Buffer Pool，每个 Buffer Pool 都称为一个实例，它们都是独立的，独立的去申请内存空间，独立的管理各种链表。所以多线程并发访问时不会相互影响，从而提高并发处理能力。

```mysql
[server]
innodb_buffer_pool_instances = 2
```

查看缓冲池的个数，使用命令：

```mysql
SHOW VARIABLES LIKE 'innodb_buffer_pool_instances'
```

总大小除以实例个数，结果就是每个 Buffer Pool 实例占用的大小。

不过也不是说 Buffer Pool 实例创建的越多越好，分别管理各个 Buffer Pool 也是需要性能开销的，InnoDB 规定：当 innodb_buffer_pool_size 的值小于 1G 的时候设置多个实例是无效的，InnoDB 会默认把 innodb_buffer_pool_instances 的值修改为 1。而我们鼓励在 Buffer Pool 大于等于 1G 的时候设置多个 Buffer Pool 实例。

### 3.5 引申问题

18:15

Redo Log & Undo Log

# P113 设置表的存储引擎、InnoDB 与 MyISAM 的对比

MySQL 中提到了存储引擎的概念。简而言之，存储引擎就是指表的类型。其实存储引擎以前叫做表处理器，后来改名为存储引擎，它的功能就是接收上层传下来的指令，然后对表中的数据进行提取或写入操作。

## 1 查看存储引擎

03:53

- 查看 mysql 提供什么存储引擎：

  ```mysql
  SHOW ENGINES;
  ```

  `MEMORY`、`InnoDB`、`PERFORMANCE_SCHEMA`、`MyISAM`、`MRG_MYISAM`、`BLACKHOLE`、`CSV`、`ARCHIVE`

  - Engine 参数表示存储引擎名称
  - Support 参数表示 MySQL 数据库管理系统是否支持该存储引擎
  - DEFAULT 表示系统默认支持的存储引擎
  - Comment 参数表示对存储引擎的简介。
  - Transactions 参数表示存储引擎是否支持事务
  - XA 参数表示存储引擎所支持的分布式是否符合 XA 规范。代表着该存储引擎是否支持分布式事务。
  - Savepoints 参数表示存储引擎是否支持事务处理的保存点。也就是说，该存储引擎是否支持部分事务回滚。

## 2 设置系统默认的存储引擎

06:28

- 查看默认的存储引擎：

  ```mysql
  SHOW VARIABLES LIKE '%storage_engine%';
  # 或
  SELECT @@default_storage_engine;
  ```

- 修改默认的存储引擎

  ```mysql
  SET DEFAULT_STORAGE_ENGINE=MyISAM
  ```

## 3 设置表的存储引擎

16:26

### 3.1 创建表时指定存储引擎

```mysql
CREATE TABLE 表名(
	建表语句;
) ENGINE = 存储引擎名称;
```

### 3.2 修改表的存储引擎

```mysql
ALTER TABLE 表名 ENGINE = 存储引擎名称;
```

## 4 引擎介绍

14:35

### 4.1 InnoDB 引擎：具备外键支持功能的事务存储引擎

16:24

- MySQL 从 3.23.34a 开始就包含 InnoDB 存储引擎。大于等于 5.5 之后，默认采用 InnoDB 引擎。
- InnoDB 是 MySQL 的默认事务型引擎，它被设计用来处理大量的短期（short-lived）事务。可以确保事务的完整提交和回滚。
- 数据文件结构：
  - 表名.frm 存储表结构（MySQL 8.0 时，合并在表名.ibd 中）
  - 表名.ibd 存储数据和索引
- InnoDB 是为处理巨大数据量的最大性能设计。
- 对比 MyISAM 存储引擎，InnoDB 写的处理效率差一些，并且会占用更多的磁盘空间以保存索引和数据。
- MyISAM 只缓存索引，不缓存真实数据；InnoDB 不仅缓存索引还要缓存真实数据，对内存要求更高，而且内存大小对性能有决定性的影响。

**InnoDB 表的优势：**

19:56

- InnoDB 存储引擎在实际应用中拥有诸多优势，比如操作便利、提高了数据库的性能、维护成本低等。如果由于硬件或软件的原因导致服务器崩溃，那么在重启服务器之后不需要进行额外的操作。InnoDB 崩溃恢复功能自动将之前提交的内容定型，然后撤销没有提交的进程，重启之后继续从崩溃点开始执行。
- InnoDB 存储引擎在主内存中维护缓冲池，高频率使用的数据将在内存中直接被处理。这种缓存方式应用于多种信息加速了处理进程。

### 4.2 MyISAM 引擎：主要的非事务处理存储引擎

27:25

- MyISAM 提供了大量的特性，包括全文索引、压缩、空间函数（GIS）等，但 MyISAM 不支持事务、行级锁、外键，有一个毫无疑问的缺陷就是崩溃后无法安全恢复。
- 5.5 之前默认的存储引擎
- 优势是访问的速度快，对事务完整性没有要求或者以 SELECT、INSERT 为主的应用
- 针对数据统计有额外的常数存储。故而 count(*) 的查询效率很高
- 数据文件结构：
  - 表名.frm 存储表结构
  - 表名.MYD 存储数据（MYData）
  - 表名.MYI 存储索引（MYIndex）
- 应用场景：只读应用或者以读为主的业务

## 5 MyISAM 和 InnoDB

29:00

| 对比项         | MyISAM                                                   | InnoDB                                                       |
| -------------- | -------------------------------------------------------- | ------------------------------------------------------------ |
| 外键           | 不支持                                                   | 支持                                                         |
| 事务           | 不支持                                                   | 支持                                                         |
| 行表锁         | 表锁，即使操作一条记录也会锁住整个表，不适合高并发的操作 | 行锁，操作时只锁某一行，不对其他行有影响，适合高并发的操作   |
| 缓存           | 只缓存索引，不缓存真实数据                               | 不仅缓存索引还要缓存真实数据，对内存要求较高，而且内存大小对性能有决定性的影响 |
| 自带系统表使用 | Y                                                        | N                                                            |
| 关注点         | 性能：节省资源、消耗少、简单业务                         | 事务：并发写、事务、更大资源                                 |
| 默认安装       | Y                                                        | Y                                                            |
| 默认使用       | N                                                        | Y                                                            |

## 6 阿里巴巴、淘宝用哪个

30:30

- Percona
- Xtradb

# P114 Archive、CSV、Memory 等存储引擎的使用

## 4.3 Archive 引擎：用于数据存档

- archive 是归档的意思，仅仅支持插入和查询两种功能（行被插入后不能再修改）
- 在 MySQL 5.5 以后支持索引功能。
- 拥有很好的压缩机制，使用 zlib 压缩库，在记录请求的时候实时的进行压缩，经常被用来作为仓库使用。
- 创建 ARCHIVE 表时，存储引擎会创建名称以表名开头的文件。数据文件的扩展名为 `.ARZ`。
- 根据英文的测试结论来看，同样数据量下，Archive 表比 MyISAM 表要小大约 75%，比支持事务管理的 InnoDB 表小大约 83%。
- ARCHIVE 存储引擎采用了行级锁。

## 4.4 Blackhole 引擎：丢弃写操作，读操作会返回空内容

03:55

## 4.5 CSV 引擎：存储数据时，以逗号分隔各个数据项

04:25

所有字段必须非空

## 4.6 Memory 引擎：置于内存的表

09:34

- Memory 同时支持哈希索引和 B+ 树索引。
- Memory 表至少比 MyISAM 表快一个数量级。
- Memory 表的大小是受到限制的。
- 数据文件与索引文件分开存储

## 4.7 Federated 表：访问远程表

14:11

## 4.8 Merge 引擎：管理多个 MyISAM 表构成的表集合

14:29

## 4.9 NDB 引擎：MySQL 集群专用存储引擎

14:40

## 4.10 引擎对比

# P115 为什么使用索引及索引的优缺点

## 1 为什么使用索引

7:00

索引是存储引擎用于快速找到数据记录的一种数据结构

目的就是为了减少磁盘 I/O 次数，加快查询速率。

## 2 索引及其优缺点

15:10

### 2.1 索引概述

MySQL 官方对索引的定义为：索引（Index）是帮助 MySQL 高效获取数据的数据结构。

索引的本质：索引是数据结构。你可以简单理解为“排好序的快速查找数据结构”

索引是在存储引擎中实现的，因此每种存储引擎的索引不一定完全相同，并且每种存储引擎不一定支持所有索引类型。

### 2.2 优点

17:00

1. 提高数据检索效率，降低数据库的 IO 成本
2. 通过创建唯一索引，可以保证数据库表中每一行数据的唯一性
3. 在实现数据的参考完整性方面，可以加速表和表之间的连接。
4. 在使用分组和排序子句进行数据查询时，可以显著减少查询中分组和排序的时间，降低了 CPU 的消耗。

### 2.3 缺点

19:17

1. 创建索引和维护索引要耗费时间，并且随着数据量的增加，所耗费的时间也会增加。
2. 索引需要占磁盘空间，除了数据表占数据空间之外，每一个索引还要占一定的物理空间，存储在磁盘上，如果有大量的索引，索引文件就可能比数据文件更快达到最大文件尺寸。
3. 虽然索引大大提高了查询速度，同时却会降低更新表的速度。当对表中的数据进行增加、删除和修改的时候，索引也要动态地维护，这样就降低了数据的维护速度。

# P116 一个简单的索引设计方案

## 3 InnoDB 中索引的推演

1:20

### 3.1 索引之前的查找

#### 1、在一个页中的查找

- 以主键为搜索条件
- 以其他列为搜索条件

#### 2、在很多页中查找

1. 定位到记录所在的页
2. 从所在的页内中查找相应的记录

### 3.2 设计索引

9:50

#### 1、一个简单的索引设计方案

13:15

#### 2、InnoDB 中的索引方案

# P117 索引的迭代设计方案

## 2、InnoDB 中的索引方案

### 迭代1次：目录项记录的页

record_type

页目录（Page Directory）二分法

### 迭代2次：多个目录项记录的页

07:36

### 迭代3次：目录项记录页的目录页

09:54

### B+Tree

12:35

我们用到的 B+ 树都不会超过 4 层

# P118 聚簇索引、二级索引与联合索引的概念

## 3.3 常见索引概念

索引按照物理实现方式，索引可以分为 2 种：聚簇（聚集）和非聚簇（非聚集）索引。我们也把非聚簇索引称为二级索引或者辅助索引。

### 1、聚簇索引

1:50

聚簇索引并不是一种单独的索引类型，而是一种数据存储方式（所有用户记录都存储在了叶子节点），也就是所谓的索引即数据，数据即索引。

特点：

1. 使用记录主键值的大小进行记录和页的排序，这包括三方面的含义：

   - 页内的记录是按照主键的大小顺序排成一个单向链表。
   - 各个存放用户记录的页也是根据页中用户记录的主键大小顺序排成一个双向链表。
   - 存放目录项记录的页分为不同的层次，在同一层次中的页也是根据页中目录项记录的主键大小顺序排成一个双向链表。

2. B+树的叶子节点存储的是完整的用户记录。

   所谓完整的用户记录，就是指这个记录中存储了所有列的值（包括隐藏列）。

我们把具有这两种特性的 B+ 树称为聚簇索引。这种聚簇索引并不需要我们在 MySQL 语句中显式的使用 INDEX 语句去创建，InnoDB 存储引擎会自动的为我们创建聚簇索引。

优点：

- 数据访问更快，因为聚簇索引将索引和数据保存在同一个 B+ 树中
- 聚簇索引对于主键的排序查找和范围查找速度非常快。
- 按照聚簇索引排列顺序，查询显示一定范围数据的时候，由于数据都是紧密相连，数据库不用从多个数据块中提取数据，所以节省了大量的 IO 操作。

缺点：

- 插入速度严重依赖于插入顺序，按照主键的顺序插入是最快的方式，否则将会出现页分裂，严重影响性能。因此，对于 InnoDB 表，我们一般都会定义一个自增ID列为主键
- 更新主键的代价很高，因为将会导致被更新的行移动。因此，对于 InnoDB 表，我们一般定义主键为不可更新
- 二级索引访问需要两次索引查找，第一次找到主键值，第二次根据主键值找到行数据。

限制：

- 对于 MySQL 数据库目前只有 InnoDB 存储引擎支持聚簇索引，而 MyISAM 并不支持聚簇索引。
- 由于数据物理存储排序方式只能有一种，所以每个 MySQL 的表只能有一个聚簇索引。一般情况下就是该表的主键。
- 如果没有定义主键，InnoDB 会选择非空的唯一索引代替。如果没有这样的索引，InnoDB 会隐式的定义一个主键来作为聚簇索引。
- 为了充分利用聚簇索引的聚簇特性，所以 InnoDB 表的主键列尽量选用有序的顺序id，而不建议使用无序的 id，比如 UUID、MD5、HASH、字符串列作为主键无法保证数据的顺序增长。

### 2、二级索引（辅助索引、非聚簇索引）

12:40

- 使用记录 c2 列的大小进行记录和页的排序，这包括三个方面的含义：
  - 页内的记录是按照 c2 列的大小顺序排成一个单向链表。
  - 各个存放用户记录的页也是根据页中记录的 c2 列大小顺序排成一个双向链表。
  - 存放目录项记录的页分为不同层次，在同一层次中的页也是根据页中目录项的 c2 列大小顺序排成一个双向链表。
- B+ 树的叶子节点存储的并不是完整的用户记录，而只是 `c2 列+主键` 这两个列的值
- 目录项记录中不再是 `主键 + 页号` 的搭配，而变成了 `c2 列 + 页号` 的搭配。

概念：回表

我们根据这个以 c2 列大小排序的 B+ 树只能确定我们要查找记录的主键值，所以如果我们想根据 c2 列的值查找到完整的用户记录的话，仍然需要到聚簇索引中再查一遍，这个过程称为**回表**。也就是根据 c2 列的值查询一条完整的用户记录需要使用到 2 棵 B+ 树。

### 3、联合索引

20:00

我们也可以同时以多个列的大小作为排序规则，也就是同时为多个列建立索引，比方说我们想让 B+ 树按照 c2 和 c3 列的大小进行排序，这个包含两层含义：

- 先把各个记录和页按照 c2 列进行排序。
- 在记录的 c2 列相同的情况下，采用 c3 列进行排序

我们需要注意以下几点：

- 每条目录项记录都由 c2、c3、页号这三个部分组成，各条记录先按照 c2 列的值进行排序，如果记录的 c2 列相同，则按照 c3 列的值进行排序。
- B+ 树叶子节点处的用户记录由 c2、c3 和主键 c1 列组成。

注意一点，以 c2 和 c3 列的大小为排序规则建立的 B+ 树称为**联合索引**，本质上也是一个二级索引。它的意思与分别为 c2 和 c3 列分别建立索引的表述是不同的，不同点如下：

- 建立联合索引只会建立 1 棵 B+ 树。
- 为 c2 和 c3 列分别建立索引会分别以 c2 和 c3 列的大小为排序规则建立 2 棵 B+ 树。

# P119 InnoDB 中 B+ 树注意事项_MyISAM 的索引方案

### 3.4 InnoDB 的 B+ 树索引的注意事项

#### 1、根页面位置万年不动

我们前边介绍 B+ 树索引的时候，为了大家理解上的方便，先把存储用户记录的叶子节点都画出来，然后接着画存储目录项记录的内节点，实际上 B+ 树的形成过程是这样的：

- 每当为某个表创建一个 B+ 树索引（聚簇索引不是人为创建的，默认就有）的时候，都会为这个索引创建一个根节点页面。最开始表中没有数据的时候，每个 B+ 树索引对应的根节点中既没有用户记录，也没有目录项记录。
- 随后向表中插入用户记录时，先把用户记录存储到这个根节点中。
- 当根节点中的可用空间用完时继续插入记录，此时会将根节点中的所有记录复制到一个新分配的页，比如页a中，然后对这个新页进行页分裂的操作，得到另一个新页，比如页b。这是新插入的记录根据键值（也就是聚簇索引中的主键值，二级索引中对应的索引列的值）的大小就会被分配到页a或者页b中，而根节点便升级为存储目录项记录的页。

这个过程特别注意的是：一个 B+ 树索引的根节点自诞生之日起，便不会再移动。这样我们只要对某个表建立一个索引，那么它的根节点的页号便会被记录到某个地方，然后凡是 InnoDB 存储引擎需要用到这个索引的时候，都会从那个固定的地方取出根节点的页号，从而来访问这个索引。

#### 2、内节点中目录项记录的唯一性

我们知道 B+ 树索引中的内节点中目录项记录的内容是`索引列 + 页号`的搭配，但是这个搭配对于二级索引来说有点儿不严谨。

对于索引列数值一样的时候会无法判断位置

为了让新插入记录能找到自己在哪个页里，我们需要**保证在 B+ 树的同一层内节点的目录项记录除页号这个字段以外是唯一的。**所以对于二级索引的内节点的目录项记录的内容实际上是由三个部分构成的：

- 索引列的值
- 主键值
- 页号

也就是我们把主键值也添加到二级索引内节点中的目录项记录了，这样就能保证 B+ 树每一层节点中各条目录项记录除页号这个字段外是唯一的，所以我们为 c2 列建立二级索引后的示意图实际上应该是这样子的。

#### 3、一个页面最少存储 2 条记录

一个 B+ 树只需要很少的层级就可以轻松存储数亿条记录，查询速度相当不错！这是因为 B+ 树本质上就是一个大的多层级目录，每经过一个目录时都会过滤掉许多无效的子目录，直到最后访问到存储真实数据的目录。那如果一个大的目录中只存放一个子目录是啥效果呢？那就是目录层级非常非常多，而且最后的那个存放真实数据的目录中只能存放一条记录。废了半天劲只能存放一条真实的用户记录？所以 InnoDB 的一个数据页至少存放两条记录。

## 4、MyISAM 中的索引方案

B 树索引适用存储引擎如表所示：

| 索引/存储引擎 | MyISAM | InnoDB | Memory |
| ------------- | ------ | ------ | ------ |
| B-Tree 索引   | 支持   | 支持   | 支持   |

即使多个存储引擎支持同一种类型的索引，但是它们的实现原理也是不同的。InnoDB 和 MyISAM 默认的引擎是 Btree 索引；而 Memory 默认索引是 Hash 索引。

MyISAM 引擎使用 B+Tree 作为索引结构，叶子节点的 data 域存放的是数据记录的地址。

### 4.2 MyISAM 的原理

下图是 MyISAM 索引的原理图。

我们知道 InnoDB 中索引即数据，也就是聚簇索引的那棵 B+ 树的叶子节点中已经把所有完整的用户记录都包含了，而 MyISAM 的索引方案虽然也使用树形结构，但是却将索引和数据分开存储：

- 将表中的记录按照记录的插入顺序单独存储在一个文件中，称之为数据文件。这个文件并不划分为若干个数据页，有多少记录就往这个文件中塞多少记录就成了。由于在插入数据的时候并没有刻意按照主键大小排序，所以我们并不能在这些数据上使用二分法进行查找。
- 使用 MyISAM 存储引擎的表会把索引信息另外存储到一个称为索引文件的另一个文件中。MyISAM 会单独为表的主键创建一个索引，只不过在索引的叶子节点中存储的不是完整的用户记录，而是 `主键值 + 数据记录地址` 的组合。

MyISAM 的索引文件仅仅保存数据记录的地址。在 MyISAM 中，主键索引和二级索引没有任何区别，只是主键索引要求 key 是唯一的，而二级索引的 key 可以重复。

因此，MyISAM 中索引检索的算法为：首先按照 B+Tree 搜索算法搜索索引，如果指定的 Key 存在，则取出其 data 域的值，然后以 data 域的值为地址，读取相应数据记录。

### 4.3 MyISAM 与 InnoDB 对比

MyISAM 的索引方式都是“非聚簇”的，与 InnoDB 包含 1 个聚簇索引是不同的。小结两种引擎中索引的区别：

1. 在 InnoDB 存储引擎中，我们只需要根据主键值对聚簇索引进行一次查找就能找到对应记录，而在 MyISAM 中却需要进行一次回表操作，意味着 MyISAM 中建立的索引相当于全部都是二级索引。
2. InnoDB 的数据文件本身就是索引文件，而 MyISAM 索引文件和数据文件是分离的，索引文件仅保存数据记录的地址。
3. InnoDB 的非聚簇索引 data 域存储相应记录主键的值，而 MyISAM 索引记录的是地址。换句话说，InnoDB 的所有非聚簇索引都引用主键作为 data 域。
4. MyISAM 的回表操作是是否快速的，因为是拿着地址偏移量直接到文件中取数据的，反观 InnoDB 是通过获取主键之后再去聚簇索引里找记录，虽然说也不慢，但还是比不上直接用地址去访问。
5. InnoDB 要求表必须有主键（MyISAM 可以没有）。如果没有显式指定，则 MySQL 系统会自动选择一个可以非空且唯一标识数据记录的列作为主键。如果不存在这种列，则 MySQL 自动为 InnoDB 表生成一个隐含字段作为主键，这个字段长度为 6 个字节，类型为长整型。

## 5、索引的代价

索引是个好东西，可不能乱建，它在空间和时间上都会有消耗：

- 空间上的代价

  每建立一个索引都要为它建立一棵B+树，每一棵B+树的每一个节点都是一个数据页，一个页默认会占用 16KB 的存储空间，一棵很大的 B+ 树由许多数据页组成，那就是很大的一片存储空间。

- 时间上的代价

  每次对表中数据进行增、删、改操作时，都需要去修改各个 B+ 树索引。而且，B+ 树每层节点都是按照索引列的值从小到大的顺序排序而组成了双向链表。不论是叶子节点中的记录，还是内节点中的记录（也就是不论是用户记录还是目录项记录）都是按照索引列的值从小到大的顺序而形成了一个单向链表。而增、删、改操作可能会对节点和记录的排序造成破坏，所以存储引擎需要额外的时间进行一些记录移位，页面分裂、页面回收等操作来维护好节点和记录的排序。如果我们建了许多索引，每个索引对应的 B+ 树都要进行相关的维护操作，会给性能拖后腿。

# P120 Hash 索引、AVL 树、B 树和 B+ 树对比

## 6、MySQL 数据结构选择的合理性

从 MySQL 的角度来讲，不得不考虑一个现实问题就是磁盘 IO。如果我们能让索引的数据结构尽量减少硬盘的 I/O 操作，所消耗的时间也就越小。可以说，磁盘的 I/O 操作次数对索引的使用效率至关重要。

查找都是索引操作，一般来说索引非常大，尤其是关系型数据库，当数据量比较大的时候，索引的大小有可能几个 G 甚至更多，为了减少索引在内存的占用，数据库索引是存储在外部磁盘上的。当我们利用索引查询的时候，不可能把整个索引全部加载到内存，只能逐一加载，那么 MySQL 衡量查询效率的标准就是磁盘 IO 次数。

### 6.1 全表遍历



### 6.2 Hash 结构

Hash 本身是一个函数，又被称为散列函数，它可以帮助我们大幅提升检索数据的效率。

Hash 算法是通过某种确定性的算法（比如 MD5、SHA1、SHA2、SHA3）将输入转变为输出。相同的输入永远可以得到相同的输出，假设输入内容有微小偏差，在输出中通常会有不同的结果。

加速查找速度的数据结构，常见的有两类：

1. 树，例如平衡二叉搜索树，查询/插入/修改/删除的平均时间复杂度都是 `O(log2N)`
2. 哈希，例如 HashMap，查询/插入/修改/删除的平均时间复杂度都是 `O(1)`

采用 Hash 进行检索效率非常高，基本上一次检索就可以找到数据，而 B+ 树需要自顶而下依次查找，多次访问节点才能找到数据，中间需要多次 I/O 操作，从效率来说 Hash 比 B+ 树更快。

在哈希的方式下，一个元素 k 处于 h(k) 中，即利用哈希函数 h，根据关键字 k 计算出槽的位置。函数 h 将关键字域映射到哈希表 T[0...m-1]的槽位上。

碰撞，在数据库中一般采用链接法来解决。

Hash 结构效率高，那为什么索引结构要设计成树型呢？

1. Hash 索引仅能满足 `=` `<>` 和 IN 查询。如果进行范围查询，哈希型的索引，时间复杂度会退化为 O(n)；而树型的“有序”特性，依然能够保持 O(log2N) 的高效率。
2. Hash 索引还有一个缺陷，数据的存储是没有顺序的，在 ORDER BY 的情况下，使用 Hash 索引还需要对数据重新排序。
3. 对于联合索引的情况，Hash 值是将联合索引键合并后一起来计算的，无法对单独的一个键或者几个索引键进行查询。
4. 对于等值查询来说，通常 Hash 索引的效率更高，不过也存在一种情况，就是索引列的重复值如果很多，效率就会降低。这是因为遇到 Hash 冲突时，需要遍历桶中的行指针来进行比较，找到查询的关键字，非常耗时。所以，Hash 索引通常不会用到重复值多的列上，比如列为性别、年龄的情况等。

Hash 索引适用存储引擎如表所示：

| 索引/存储引擎 | MyISAM | InnoDB | Memory |
| ------------- | ------ | ------ | ------ |
| HASH 索引     | 不支持 | 不支持 | 支持   |

Hash 索引的适用性：

Hash 索引存在着很多限制，相比之下在数据库中 B+ 树索引的使用面会更广，不过也有一些场景采用 Hash 索引效率更高，比如在键值型（Key-Value）数据库中，Redis 存储的核心就是 Hash 表。

MySQL 中的 Memory 存储引擎支持 Hash 存储，如果我们需要用到查询的临时表时，就可以选择 Memory 存储引擎，把某个字段设置为 Hash 索引，比如字符串类型的字段，进行 Hash 计算之后长度可以缩短到几个字节。当字段的重复度低，而且经常需要进行等值查询的时候，采用 Hash 索引是个不错的选择。

另外，InnoDB 本身不支持 Hash 索引，但是提供**自适应 Hash 索引**（Adaptive Hash Index）。什么情况下才会使用自适应 Hash 索引呢？如果某个数据经常被访问，当满足一定条件的时候，就会将这个数据页的地址存放到 Hash 表中。这样下次查询的时候，就可以直接找到这个页面的所在位置。这样让 B+ 树也具备了 Hash 索引的优点。

采用自适应 Hash 索引目的是方便根据 SQL 的查询条件加速定位到叶子节点，特别是当 B+ 树比较深的时候，通过自适应 Hash 索引可以明显提高数据的检索效率。

我们可以通过 `innodb_adaptive_hash_index` 变量来查看是否开启了自适应 Hash，比如：

```mysql
show variables like '%adaptive_hash_index';
```

### 6.3 二叉搜索树

如果我们利用二叉树作为索引结构，那么磁盘 IO 次数和索引树的高度是相关的。

### 6.4 AVL 树

为了解决上面二叉查找树退化成链表的问题，人们提出了平衡二叉搜索树（Balanced Binary Tree），又称为 AVL 树（有别于 AVL 算法），它在二叉搜索树的基础上增加了约束，具有以下性质：

**它是一棵空树或它的左右两个子树的高度差的绝对值不超过1，并且左右两个子树都是一棵平衡二叉树。**

### 6.5 B-Tree

B 树的英文是 Balance Tree，也就是多路平衡查找树。简写为 B-Tree（注意横杠表示这两个单词连起来的意思，不是减号）。它的高度远小于平衡二叉树的高度。

B 树作为多路平衡查找树，它的每一个节点最多可以包括 M 个子节点，M 称为 B 树的阶。每个磁盘块中包括了关键字和子节点的指针。如果一个磁盘块中包括了 x 个关键字，那么指针数就是 x + 1。

一个 M 阶的 B 树（M > 2）有以下的特性：

1. 根节点的儿子数的范围是 [2, M]
2. 每个中间节点包含 k - 1 个关键字和 k 个孩子，孩子的数量 = 关键字的数量 + 1，k 的取值范围为 [ceil(M/2), M]。
3. 叶子节点包括 k-1 个关键字（叶子节点没有孩子），k 的取值范围为 [ceil(M/2), M]。
4. 假设中间节点的关键字为: Key[1], Key[2], ..., Key[k-1], 且关键字按照升序排序，即 Key[i] < Key[i + 1]。此时 k-1 个关键字相当于划分了 k 个范围，也就是对应着 k 个指针，即为：P[1], P[2], ..., P[k]，其中 P[1] 指向关键字小于 Key[1] 的子树，P[i] 指向关键字属于(Key[i-1], Key[i]) 的子树，P[k] 指向关键字大于 Key[k-1] 的子树。
5. 所有叶子节点位于同一层。

小结：

1. B 树在插入和删除时如果导致树不平衡，就通过自动调节节点位置来保持树的自平衡
2. 关键字集合分布在整个树中，即叶子节点和非叶子节点都存放数据。搜索有可能在非叶子节点结束。
3. 其搜索性能等价于在关键字全集内做一次二分查找

### 6.6 B+Tree

B+ 树也是一种多路搜索树，基于 B 树做出了改进，主流的 DBMS 都支持 B+ 树的索引方式，比如 MySQL。相比于 B-Tree，B+Tree 适合文件索引系统。

B+ 树和 B 树的差异在于以下几点：

1. 有 k 个孩子的节点就有 k 个关键字。也就是孩子数量 = 关键字数，而 B 树中，孩子数量 = 关键字数 + 1。
2. 非叶子节点的关键字也会同时存在于子节点中，并且是在子节点中所有关键字的最大（或最小）。
3. 非叶子节点仅用于索引，不保存数据记录，跟记录有关的信息都放在叶子节点中。而 B 树中，非叶子节点既保存索引，也保存数据记录。
4. 所有关键字都在叶子节点出现，叶子节点构成一个有序链表，而且叶子节点本身按照关键字的大小从小到大顺序链接。

B+ 树和 B 树有个根本的差异在于，B+ 树中间节点并不直接存储数据。这样的好处都有什么呢？

首先，**B+ 树查询效率更稳定**，因为 B+ 树每次只有访问到叶子节点才能找到对应的数据，而在 B 树中，非叶子节点也会存储数据，这样就会造成查询效率不稳定的情况，有时候访问到了非叶子节点就可以找到关键字，而有时需要访问到叶子节点才能找到关键字。

其次，**B+ 树的查询效率更高**。这是因为通常 B+ 树比 B 树更矮胖（阶数更大，深度更低），查询所需要的磁盘 I/O 也会更少。同样的磁盘页大小，B+ 树可以存储更多的节点关键字。

不仅是对单个关键字的查询上，**在查询范围上，B+ 树的效率也比 B 树高**。这是因为所有关键字都出现在 B+ 树的叶子节点中，叶子节点之间会有指针，数据又是递增的，这使得我们范围查找可以通过指针连接查找。而在 B 树中则需要通过中序遍历才能完成查询范围的查找，效率要低很多。

**思考题：为了减少 IO，索引树会一次性加载吗？**

1. 数据库索引是存储在磁盘上的，如果数据量很大，必然导致索引的大小也会很大，超过几个 G
2. 当我们利用索引查询的时候，是不可能将全部几个 G 的索引都加载进内存的，我们能做的只能是：逐一加载每个磁盘页，因为磁盘页对应着索引树的节点。

**思考题：B+ 树的存储能力如何？为何说一般查找行记录，最多只需 1~3 次磁盘 IO**

InnoDB 存储引擎中页的大小为 16KB，一般表的主键类型为 INT（占用 4 个字节）或 BIGINT（占用 8 个字节），指针类型也一般为 4 或 8 个字节，也就是说一个页（B+Tree 中的一个节点）中大概存储 16KB/(8B+8B)=1K 个键值（因为是估值。为方便计算，这里 K 取值为 10^3。也就是说一个深度为 3 的 B+Tree 索引可以维护 10^3 * 10^3 * 10^3 = 10 亿条记录。这里假定一个数据页也存储 10^3 条行记录数据了）

实际情况中每个节点可能不能填充满，因此在数据库中，B+Tree 的高度一般都在 2~4 层。MySQL 的 InnoDB 存储引擎在设计时是将根节点常驻内存的，也就是说查找某个键值的行记录时最多只需要 1 ~ 3 次磁盘 I/O 操作。

**思考题：为什么说 B+ 树比 B树更适合实际应用中操作系统的文件索引和数据库索引**

1. B+ 树的磁盘读写代价更低

   B+ 树的内部节点并没有指向关键字具体信息的指针。因此其内部节点相对于 B 树更小。如果把同一内部节点的关键字存放在同一盘块中，那么盘块所能容纳的关键字数量也越多。一次性读入内存中的需要查找的关键字也就越多。相对来说 IO 读写次数也就降低了。

2. B+ 树的查询效率更加稳定

   由于非终结点并不是最终指向文件内容的节点，而只是叶子节点中关键字的索引。所以任何关键字的查找必须走一条从根节点到叶子节点的路。所有关键字查询的路径长度相同，导致每个数据的查询效率相当。

**思考题：Hash 索引和 B+ 树索引的区别**

我们之前讲到过 B+ 树索引的结构，Hash 索引结构和 B+ 树的不同，因此在索引使用上也会有差别。

1. Hash 索引不能进行范围查询
2. Hash 索引不支持联合索引的最左侧原则（即联合索引的部分索引无法使用），而 B+ 树可以。
3. Hash 索引不支持 ORDER BY 排序
4. InnoDB 不支持哈希索引

**思考题：Hash 索引与 B+ 树索引是在建索引的时候手动指定吗？**

针对 InnoDB 和 MyISAM 存储引擎，都会默认采用 B+ 树索引，无法使用 Hash 索引。InnoDB 提供的自适应 Hash 是不需要手动指定的。如果是 Memory/Heap 和 NDB 存储引擎，是可以进行选择 Hash 索引的。

### 6.7 R 树

R-Tree 在 MySQL 很少使用，仅支持 geometry 数据类型，支持该类型的存储引擎只有 myisam、bdb、innodb、ndb、archive 几种。

R 树很好的解决了高维空间搜索问题。

### 6.8 小结
