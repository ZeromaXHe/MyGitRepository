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
