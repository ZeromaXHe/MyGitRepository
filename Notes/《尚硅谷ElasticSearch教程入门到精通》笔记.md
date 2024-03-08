【尚硅谷】ElasticSearch教程入门到精通（基于ELK技术栈elasticsearch 7.x+8.x新特性）

https://www.bilibili.com/video/BV1hh411D7sb

2021-04-07 08:30:17

# P1 开篇

结构化数据

非结构化数据

半结构化数据

# P2 技术选型

## 第 1 章 Elasticsearch 概述

### 1.1 Elasticsearch 是什么

（0:10）

The Elastic Stack, 包括 Elasticsearch、Kibana、Beats 和 Logstash（也称为 ELK Stack）。

### 1.2 全文搜索引擎

（1:10）

### 1.3 Elasticsearch And Solr

（1:42）

Lucene 是 Apache 软件基金会 Jakarta 项目组的一个子项目

### 1.4 Elasticsearch Or Solr

（2:02）

# P3 教学大纲

第1章 Elasticsearch 概述

第2章 Elasticsearch 入门

第3章 Elasticsearch 环境

第4章 Elasticsearch 进阶

第5章 Elasticsearch 集成

第6章 Elasticsearch 优化

第7章 Elasticsearch 面试题

# P4 入门-环境准备

## 第 2 章 Elasticsearch 入门

### 2.1  Elasticsearch 安装

#### 2.1.1 下载软件

（1:37）

#### 2.1.2 安装软件

（1:38）

#### 2.1.3 问题解决

（2:31）

# P5 入门-RESTful & JSON

# P6 入门-Postman 客户端工具

#### 2.2.2 客户端安装

（1:05）

# P7 倒排索引

#### 2.2.3 数据格式

（4:48）

Elasticsearch 是面向文档型数据库，一条数据在这里就是一个文档。为了方便大家理解，我们将 Elasticsearch 里存储文档数据和关系型数据库 MySQL 存储数据的概念进行一个类比

ES 里的 Index 可以看作一个库，而 Types 相当于表，Documents 则相当于表的行。这里 Types 的概念已经被逐渐弱化，Elasticsearch 6.X 中，一个 index 下已经只能包含一个 type，Elasticsearch 7.X 中，Type 的概念已经被删除了。

# P8 入门-HTTP-索引-创建

##### 2.2.4.1 索引操作

**1）创建索引**

对比关系型数据库，创建索引就等同于创建数据库

在 Postman 中，向 ES 服务器发 **PUT** 请求：http://127.0.0.1:9200/shopping

请求后，服务器返回响应

# P9 入门-HTTP-查询 & 删除

GET

DELETE

# P10 入门-HTTP-文档-创建（Put & Post）

##### 2.2.4.2 文档操作

**1）创建文档**

索引已经创建好了，接下来我们来创建文档。并添加数据。这里的文档可以类比为关系型数据库中的表数据，添加的数据格式为 JSON 格式

在 Postman 中，向 ES 服务器发 POST 请求：http://127.0.0.1:9200/shopping/_doc

请求体内容为：

```json
{
    "title": "小米手机",
    "category": "小米",
    "images": "http://www.gulixueyuan.com/xm.jpg",
    "price": 3999.00
}
```

# P11 入门-HTTP-查询-主键查询 & 全查询

# P12 入门-HTTP-全量修改 & 局部修改 & 删除