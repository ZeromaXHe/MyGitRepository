# 第1章 什么是MySQL

2（25/685）

## 1.1 什么是数据库

### 1.1.1 关系、数据库系统、服务器和客户

数据库（database）

数据表（table）

关系（relation）

关系（型）数据库系统（relational database system）

数据库服务器（database server）

数据库客户（database client）

### 1.1.2 关系数据库系统与面向对象数据库系统

### 1.1.3 数据表、记录、字段、查询、SQL、索引和键

数据记录（data record）

字段（field）

数据库模型（database model）

查询（query）

索引（index）	经常被人们称为键字或键（key）

主索引（primary index）或主键（primary key）

## 1.2 MySQL

4(27/685)

### MySQL的功能

- 关系数据库系统
- 客户/服务器体系    与它们形成对照的是文件服务器系统（file-server system）,如Microsoft Access
- SQL兼容性
- 子查询    4.1版开始
- 视图    5.0开始
- 存储过程（stored procedure，简称SP）    5.0开始
- 触发器    5.0开始支持
- Unicode    4.1开始支持所有常用的字符集
- 用户操作界面
- 全文搜索（full-text search）
- 镜像复制（replication）
- 事务（transaction）     InnoDB
- 外键约束    InnoDB
- GIS函数     4.1版本开始    GIS(Geographic Information System, 地理信息系统)
- 程序设计语言
- ODBC
- 平台独立性
- 速度

## 1.3 MySQL的不足

- 在对默认格式（即MyISAM格式）的数据表进行处理时，MySQL的锁定机制——即暂时禁止对数据库信息的访问或修改——将对整个数据表起作用（数据表锁定）。	InnoDB绕过锁定问题
- 热备份
- 不支持用户自定义数据类型
- 对XML视若无睹
- 不能提供任何OLAP（online analytical processing，实时分析处理）    支持OLAP的数据库系统通常被称为数据仓库（data warehouse）
- 5.0版本开始支持存储过程和触发器，但功能不算成熟
- 4.1.0开始的GIS功能也有同样问题

## 1.4 MySQL的版本编号

### 1.4.1 Alpha、Beta、Gamma、Production（Generally Available）

### 1.4.2 按版本编号排列的MySQL功能表

## 1.5 MySQL的许可证

### 1.5.1 GPL许可证下的权利和义务

GPL软件为基础开发出来的每一个程序都必须沿用GPL许可证（换句话说，GPL许可证的约束力是可传递的）

### 1.5.2 开源许可证下的MySQL软件

### 1.5.3 商用许可证下的MySQL软件

### 1.5.4 MySQL客户软件开发库（Connector/ODBC、Connector/J等）的商用许可证

Connector/J:与Java语言配合使用的驱动程序。

Connector/MXJ: 与Java语言配合使用的J2EE MBean驱动程序

这些驱动程序也是采用GPL许可证发行的。

### 1.5.5 PHP项目的客户许可证问题——F(L)OSS特例

### 1.5.6 MySQL软件的版本名称

SHOW VARIABLE命令来查看自己MySQL版本都支持哪些功能。

### 1.5.7 MySQL软件的技术支持合同

## 1.6 MySQL软件的替代品

## 1.7 小结