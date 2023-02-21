# Redis 简介

学习 Redis 开源项目

Redis 是一个开源（BSD 许可）的内存数据结构存储，用作数据库、缓存、消息代理和流引擎。Redis 提供了字符串、哈希、列表、集合、带范围查询的排序集合、位图、超日志、地理空间索引和流等数据结构。Redis 具有内置复制、Lua 脚本、LRU 逐出、事务和不同级别的磁盘持久性，并通过 Redis Sentinel 和 Redis Cluster 自动分区提供高可用性。

您可以对这些类型运行**原子操作**，如附加到字符串；增加哈希中的值；将元素推送到列表；计算集合交集、并集和差集；或者获得排序集合中排名最高的成员。

为了获得最佳性能，Redis 使用**内存数据集**。根据您的使用情况，Redis 可以通过定期将数据集转储到磁盘或将每个命令附加到基于磁盘的日志中来持久化数据。如果您只需要功能丰富的网络内存缓存，也可以禁用持久性。

Redis 支持异步复制，具有快速的非阻塞同步和自动重新连接，并在网络拆分时进行部分重新同步。

Redis 也包括：

- 事务
- 发布/订阅
- Lua 脚本
- 生存时间有限的键
- 键的 LRU 淘汰
- 自动故障降级

您可以从大多数编程语言中使用 Redis。

Redis 是用 ANSI C 编写的，可以在大多数 POSIX 系统上运行，如 Linux、*BSD 和 Mac OS X，无需外部依赖。Linux 和 OS X 是 Redis 开发和测试最多的两个操作系统，我们建议使用 Linux 进行部署。Redis 可以在 Solaris 衍生系统（如 SmartOS）中工作，但支持是最好的选择。Windows 版本没有官方支持。

## 谁在使用 Redis？

一些正在使用 Redis 的知名公司列表：

- Twitter
- GitHub
- Snapchat
- Craigslist
- StackOverflow

以及**很多其他的**！techstacks.io 维护了一组使用 Redis 的流行网站。

# Redis 入门

这是 Redis 入门指南。您将学习如何安装、运行和试验 Redis 服务器进程。

## 安装 Redis

如何安装 Redis 取决于您的操作系统，以及您是否希望将其与 Redis Stack 和 Redis UI 捆绑安装。请参阅以下最适合您需求的指南：

- 从源代码安装 Redis
- 在 Linux 上安装 Redis
- 在 macOS 上安装 Redis
- 在 Windows 上安装 Redis
- 使用 Redis Stack 和 RedisInsight 安装 Redis

一旦安装并运行了 Redis，并且可以使用 `redis-cli` 进行连接，就可以继续执行以下步骤。

## 使用 CLI 探索 Redis

外部程序使用 TCP 套接字和特定于 Redis 的协议与 Redis 通信。该协议在不同编程语言的 Redis 客户端库中实现。然而，为了简化 Redis 的黑客攻击，Redis 提供了一个命令行实用程序，可用于向 Redis 发送命令。此程序称为 **redis-cli**。

要检查 Redis 是否正常工作，首先要使用 redis-cli 发送 **PING** 命令：

```shell
$ redis-cli ping
PONG
```

运行 **redis-cli**，后跟命令名及其参数，会将此命令发送到在本地主机 6379 端口上运行的 redis 实例。您可以更改 `redis-cli` 使用的主机和端口——只需尝试 `--help` 选项来检查用法信息。

运行 `redis-cli` 的另一个有趣的方法是不带参数：程序将以交互模式启动。您可以键入不同的命令并查看其答复。

```shell
$ redis-cli
redis 127.0.0.1:6379> ping
PONG
redis 127.0.0.1:6379> set mykey somevalue
OK
redis 127.0.0.1:6379> get mykey
"somevalue"
```

此时，您可以与 Redis 进行对话。现在是暂停本教程的适当时间，开始 15 分钟的 Redis 数据类型介绍，以便学习一些 Redis 命令。除非你已经知道一些基本的 Redis 命令，那么你可以继续阅读。

## 保护 Redis

默认情况下，Redis 绑定到所有接口，根本没有身份验证。如果你在一个非常受控的环境中使用 Redis，与外部互联网隔离，通常与攻击者隔离，那就没问题了。然而，如果未经加固的 Redis 暴露在互联网上，这是一个很大的安全问题。如果您不能 100% 确定您的环境是否安全，请检查以下步骤以使 Redis 更安全，这些步骤是按安全性增加的顺序排列的。

1. 确保 Redis 用于监听连接的端口（默认情况下为 6379，如果在集群模式下运行 Redis，则为 16379，如果为 Sentinel，则为 26379）已防火墙，因此无法从外部联系 Redis。
2. 使用设置了 `bind` 指令的配置文件，以确保 Redis 仅侦听您正在使用的网络接口。例如，如果您仅从同一台计算机本地访问 Redis，则仅使用环回接口（127.0.0.1），依此类推。
3. 使用 `requirepass` 选项添加额外的安全层，以便客户端需要使用 `AUTH` 命令进行身份验证。
4. 如果您的环境需要加密，请使用 spiped 或其他 SSL 隧道软件来加密 Redis 服务器和 Redis 客户端之间的流量。

请注意，在没有任何安全性的情况下暴露在互联网上的 Redis 实例很容易被利用，因此请确保您了解以上内容并至少应用防火墙层。防火墙就位后，尝试从外部主机连接 `redis-cli`，以证明该实例实际上不可访问。

## 从你的应用中使用 Redis

当然，仅从命令行界面使用 Redis 是不够的，因为目标是从应用程序中使用它。为了做到这一点，您需要下载并安装适合您编程语言的 Redis 客户端库。您将在此页面中找到不同语言的客户机的完整列表。

例如，如果您碰巧使用 Ruby 编程语言，我们最好的建议是使用 Redis-rb 客户端。您可以使用命令 **gem install redis** 安装它。
这些指令是特定于 Ruby 的，但实际上许多流行语言的库客户端看起来非常相似：创建一个 Redis 对象并执行调用方法的命令。使用 Ruby 的简短交互示例：

```ruby
>> require 'rubygems'
=> false
>> require 'redis'
=> true
>> r = Redis.new
=> #<Redis client v4.5.1 for redis://127.0.0.1:6379/0>
>> r.ping
=> "PONG"
>> r.set('foo','bar')
=> "OK"
>> r.get('foo')
=> "bar"
```

## Redis 持久化

您可以在此页面上了解 Redis 持久性是如何工作的，但快速入门需要了解的是，默认情况下，如果您使用默认配置启动 Redis，Redis 会自动保存数据集（例如，如果您的数据至少有 100 次更改，则至少在 5 分钟后），因此，如果您希望数据库持久化并在重新启动后重新加载，请确保在每次强制创建数据集快照时手动调用 **SAVE** 命令。否则，请确保使用 **SHUTDOWN** 命令关闭数据库：

```shell
$ redis-cli shutdown
```

这样，Redis 将确保在退出之前将数据保存在磁盘上。强烈建议阅读持久化页面，以便更好地理解 Redis 持久性的工作原理。

## 更合理地安装 Redis

从命令行运行 Redis 是很好的，只是为了黑客一点或用于开发。然而，在某个时刻，您将有一些实际的应用程序在真正的服务器上运行。对于这种用法，您有两种不同的选择：

- 使用屏幕运行 Redis。
- 使用 init 脚本以正确的方式在 Linux box 中安装 Redis，以便在重新启动后一切都能正常启动。

强烈建议使用 init 脚本进行正确安装。以下说明可用于在基于 Debian 或 Ubuntu 的发行版中使用 Redis 2.4 或更高版本附带的 init 脚本执行正确的安装。

我们假设您已经在 /usr/local/bin 下复制了 **redis-server** 和 **redis-cli** 可执行文件。

- 创建一个存储你的 Redis 配置文件和数据的目录：
  ```shell
  sudo mkdir /etc/redis
  sudo mkdir /var/redis
  ```

- 将在 Redis 发行版的 **utils** 目录下找到的 init 脚本复制到 `/etc/init.d` 中。我们建议使用运行此 Redis 实例的端口名来调用它。例如：
  ```shell
  sudo cp utils/redis_init_script /etc/init.d/redis_6379
  ```

- 编辑 init 脚本。
  ```shell
  sudo vi /etc/init.d/redis_6379
  ```

确保根据您使用的端口修改 **REDISPORT**。pid 文件路径和配置文件名都取决于端口号。

- 使用端口号作为名称，将在 Redis 发行版的根目录中找到的模板配置文件复制到 `/etc/redis/` 中，例如：
  ```shell
  sudo cp redis.conf /etc/redis/6379.conf
  ```

- 在 `/var/redis` 中创建一个目录，作为此 redis 实例的数据和工作目录：
  ```shell
  sudo mkdir /var/redis/6379
  ```

- 编辑配置文件，确保执行以下更改：

  - 将 **daemonize** 设置为 yes（默认设置为no）。
  - 将 **pidfile** 设置为 `/var/run/redis_6379.pid`（如果需要，请修改端口）。
  - 相应地更改 **port**。在我们的示例中，不需要它，因为默认端口已经是6379。
  - 设置您的首选 **loglevel**。
  - 将 **logfile** 设置为 `/var/log/redis_6379.log`
  - 将 **dir** 设置为 `/var/redis/6379`（非常重要的一步！）

- 最后，使用以下命令将新的 Redis init 脚本添加到所有默认运行级别：
  ```shell
  sudo update-rc.d redis_6379 defaults
  ```

完成了！现在你可以尝试运行你的实例：

```shell
sudo /etc/init.d/redis_6379 start
```

确保一切按预期工作：

- 尝试使用 redis-cli ping 实例。
- 使用 `redis-cli` `save` 执行测试保存，并检查转储文件是否正确存储在 `/var/redis/6379/` 中（您应该找到一个名为 `dump.rdb` 的文件）。
- 检查 Redis 实例是否正确登录到日志文件中。
- 如果这是一台新机器，你可以毫无问题地尝试它，请确保在重新启动后一切都正常。

注意：上面的说明不包括所有可以更改的 Redis 配置参数，例如，使用 AOF 持久性而不是 RDB 持久性，或者设置复制等等。确保阅读示例 `redis.conf` 文件（注释较多）。

# 用户界面

Redis 命令行接口（redis-cli）是一个终端程序，用于向 Redis 服务器发送命令和读取回复。它有两种主要模式：一种是交互式 Read Eval 打印循环（REPL）模式，用户在该模式下键入 Redis 命令并接收回复；另一种是命令模式，在该模式中使用附加参数执行 redis-cli 并将回复打印到标准输出。

RedisInsight 将图形用户界面与 Redis CLI 相结合，让您可以使用任何 Redis 部署。您可以直观地浏览数据并与数据交互，利用诊断工具，通过示例学习，等等。最重要的是，RedisInsight 是免费的。

## Redis CLI

在交互模式下，`redis-cli` 具有基本的行编辑功能，可以提供熟悉的打字体验。

要在特殊模式下启动程序，可以使用几个选项，包括：

- 模拟复制副本并打印它从主副本接收的复制流。
- 检查 Redis 服务器的延迟并显示统计信息。
- 请求延迟样本和频率的 ASCII 艺术谱图。

本主题涵盖 `redis-cli` 的不同方面，从最简单的功能开始，到更高级的功能结束。

### 命令行用法

要在终端运行 Redis 命令并返回标准输出，请将要执行的命令作为 `redis-cli` 的单独参数：

```shell
$ redis-cli INCR mycounter
(integer) 7
```

命令的回复是“7”。由于 Redis 回复是类型化的（字符串、数组、整数、nil、错误等），所以您可以在括号中看到回复的类型。当 `redis-cli` 的输出必须用作另一个命令的输入或重定向到文件中时，此附加信息可能不理想。

`redis-cli` 仅在检测到标准输出是 tty 或终端时，才显示用于人类可读性的附加信息。对于所有其他输出，它将自动启用 `raw` 输出模式，如下例所示：

```shell
$ redis-cli INCR mycounter > /tmp/output.txt
$ cat /tmp/output.txt
8
```

注意，输出中省略了 `(integer)`，因为 `redis-cli` 检测到输出不再写入终端。您甚至可以使用 `--raw` 选项在终端上强制原始输出：

```shell
$ redis-cli --raw INCR mycounter
9
```

在向文件或管道中写入其他命令时，可以使用 `--no-raw` 强制人类可读输出。

### 字符串引号和转义

`redis-cli` 解析命令时，空格字符会自动分隔参数。在交互模式下，换行符发送用于解析和执行的命令。要输入包含空格或不可打印字符的字符串值，可以使用引号和转义字符串。

带引号的字符串值用双（`"`）或单（`'`）引号括起来。转义序列用于在字符和字符串文本中放置不可打印的字符。

转义序列包含一个反斜杠（`\`）符号，后跟一个转义序列字符。

双引号字符串支持以下转义序列：

- `\"` —— 双引号
- `\n` —— 换行
- `\r` —— 回车
- `\t` —— 水平制表符
- `\b` —— 退格
- `\a` —— 警报
- `\\` —— 反斜杠
- `\xhh` —— 任意通过十六进制数(`hh`)表示的 ASCII 字符

单引号假定字符串是文本，并且只允许以下转义序列：

- `\'` —— 单引号
- `\\` —— 反斜杠

例如，将 `Hello World` 在两行里返回：

```shell
127.0.0.1:6379> SET mykey "Hello\nWorld"
OK
127.0.0.1:6379> GET mykey
Hello
World
```

例如，当您输入包含单引号或双引号的字符串时，例如，在密码中，请转义字符串，如下所示：

```shell
127.0.0.1:6379> AUTH some_admin_user ">^8T>6Na{u|jp>+v\"55\@_;OU(OR]7mbAYGqsfyu48(j'%hQH7;v*f1H${*gD(Se'"
```

### 主机、端口、密码和数据库

默认情况下，`redis-cli` 通过端口 6379 连接到地址为 127.0.0.1 的服务器。可以使用多个命令行选项更改端口。要指定不同的主机名或 IP 地址，请使用 `-h` 选项。要设置不同的端口，请使用 `-p`。

```shell
$ redis-cli -h redis15.localnet.org -p 6390 PING
PONG
```

如果实例受密码保护，`-a <password>` 项将执行身份验证，无需显式使用 `AUTH` 命令：

```shell
$ redis-cli -a myUnguessablePazzzzzword123 PING
PONG
```

**注意**：出于安全原因，请通过 **REDISCLI_AUTH** 环境变量自动为 `redis-cli` 提供密码。

最后，可以使用 `-n <dbnum>`选项发送一个对默认数字零以外的数据库编号进行操作的命令：

```shell
$ redis-cli FLUSHALL
OK
$ redis-cli -n 1 INCR a
(integer) 1
$ redis-cli -n 1 INCR a
(integer) 2
$ redis-cli -n 2 INCR a
(integer) 1
```

还可以通过使用 `-u <uri>` 选项和 URI 模式来提供这些信息的部分或全部 `redis://user:password@host:port/dbnum`:

```shell
$ redis-cli -u redis://LJenkins:p%40ssw0rd@redis-16379.hosted.com:16379/0 PING
PONG
```

### SSL/TLS

默认情况下，`redis-cli` 使用普通 TCP 连接连接到 Redis。您可以使用 `--tls` 选项以及 `--cacert` 或 `--cacertdir` 来启用 SSL/TLS，以配置受信任的根证书捆绑包或目录。

如果目标服务器需要使用客户端证书进行身份验证，则可以使用 `--cert` 和 `--key` 指定证书和相应的私钥。

### 从其他程序中获得输入

有两种方法可以使用 `redis-cli` 通过标准输入从其他命令接收输入。一种是使用目标负载作为 *stdin* 的最后一个参数。例如，要将 Redis 密钥 `net_services` 设置为本地文件系统中 `/etc/services` 文件的内容，请使用 `-x` 选项：

```shell
$ redis-cli -x SET net_services < /etc/services
OK
$ redis-cli GETRANGE net_services 0 50
"#\n# Network services, Internet style\n#\n# Note that "
```

在上述会话的第一行中，使用 `-x` 选项执行 `redis-cli`，并将一个文件重定向到 CLI 的标准输入，作为满足 `SET net_services` 命令短语的值。这对于编写脚本非常有用。

另一种方法是向 `redis-cli` 提供一系列在文本文件中编写的命令：

```shell
$ cat /tmp/commands.txt
SET item:3374 100
INCR item:3374
APPEND item:3374 xxx
GET item:3374
$ cat /tmp/commands.txt | redis-cli
OK
(integer) 101
(integer) 6
"101xxx"
```

`commands.txt` 中的所有命令都由 `redis-cli` 连续执行，就像用户在交互模式下键入的一样。如果需要，可以在文件中引用字符串，这样就可以使用带空格、换行符或其他特殊字符的单个参数：

```shell
$ cat /tmp/commands.txt
SET arg_example "This is a single argument"
STRLEN arg_example
$ cat /tmp/commands.txt | redis-cli
OK
(integer) 25
```

### 连续运行相同命令

用户可以在执行之间选择暂停，执行指定次数的单个命令。这在不同的上下文中很有用-例如，当我们想要连续监视一些关键内容或 `INFO` 字段输出时，或者当我们想要模拟一些重复的写入事件时，例如每 5 秒将一个新项目推到列表中。

此功能由两个选项控制：`-r <count>` 和 `-i <delay>`。`-r` 选项表示运行命令的次数，`-i` 以秒为单位设置不同命令调用之间的延迟（可以指定 0.1 等值表示 100 毫秒）。

默认情况下，间隔（或延迟）设置为 0，因此命令只会尽快执行：

```shell
$ redis-cli -r 5 INCR counter_value
(integer) 1
(integer) 2
(integer) 3
(integer) 4
(integer) 5
```

要无限期运行同一命令，请使用 `-1` 作为计数值。要随时间监控 RSS 内存大小，可以使用以下命令：

```shell
$ redis-cli -r -1 -i 1 INFO | grep rss_human
used_memory_rss_human:2.71M
used_memory_rss_human:2.73M
used_memory_rss_human:2.73M
used_memory_rss_human:2.73M
... a new line will be printed each second ...
```

### 使用 redis-cli 大规模插入数据

使用 `redis-cli` 的大规模插入在单独的页面中介绍，因为它本身就是一个有价值的主题。请参阅我们的大批量插入指南。

### CSV 输出

`redis-cli` 中有一个 CSV（逗号分隔值）输出功能，用于将数据从 Redis 导出到外部程序。

```shell
$ redis-cli LPUSH mylist a b c d
(integer) 4
$ redis-cli --csv LRANGE mylist 0 -1
"d","c","b","a"
```

请注意，`--csv` 标志仅适用于单个命令，而不适用于作为导出的整个DB。

### 运行 Lua 脚本

`redis-cli` 对使用 Lua 脚本的调试功能提供了广泛的支持，该功能可用于 redis 3.2 及更高版本。有关此功能，请参阅 Redis Lua 调试器文档。

即使不使用调试器，`redis-cli` 也可以作为参数从文件运行脚本：

```shell
$ cat /tmp/script.lua
return redis.call('SET',KEYS[1],ARGV[1])
$ redis-cli --eval /tmp/script.lua location:hastings:temp , 23
OK
```

Redis `EVAL` 命令将脚本使用的键列表和其他非键参数作为不同的数组。调用 `EVAL` 时，您需要按数字格式提供键的数量。

使用上面的 `--eval` 选项调用 `redis-cli` 时，无需显式指定键的数量。相反，它使用逗号分隔键和参数的约定。这就是为什么在上面的调用中，您可以看到 `location:hastings:temp, 23` 作为参数。

因此 `location:hastings:temp` 将填充 `KEYS` 数组，`23` 填充 `ARGV` 数组。

`--eval` 选项在编写简单脚本时非常有用。对于更复杂的工作，建议使用 Lua 调试器。这两种方法可以混合使用，因为调试器也可以从外部文件执行脚本。

### 互动模式

我们已经探讨了如何将 Redis CLI 用作命令行程序。这对于脚本和某些类型的测试非常有用，但是大多数人都会在 `redis-cli` 中使用它的交互模式。

在交互模式下，用户在提示符处键入 Redis 命令。命令被发送到服务器并进行处理，然后将回复解析回来，并呈现为更简单的形式进行读取。

在交互模式下运行 `redis-cli` 不需要任何特殊功能——只需在没有任何参数的情况下执行它

```shell
$ redis-cli
127.0.0.1:6379> PING
PONG
```

字符串 `127.0.0.1:6379>` 是提示。它显示连接的 Redis 服务器实例的主机名和端口。

当连接的服务器发生更改或在与数据库编号 0 不同的数据库上操作时，提示将更新：

```shell
127.0.0.1:6379> SELECT 2
OK
127.0.0.1:6379[2]> DBSIZE
(integer) 1
127.0.0.1:6379[2]> SELECT 0
OK
127.0.0.1:6379> DBSIZE
(integer) 503
```

### 处理连接和重连

在交互模式下使用 **CONNECT** 命令，通过指定要连接到的主机名和端口，可以连接到不同的实例：

```shell
127.0.0.1:6379> CONNECT metal 6379
metal:6379> PING
PONG
```

正如您所看到的，当连接到不同的服务器实例时，提示会相应地更改。如果尝试连接到无法访问的实例，`redis-cli` 将进入断开连接模式，并尝试重新连接每个新命令：

```shell
127.0.0.1:6379> CONNECT 127.0.0.1 9999
Could not connect to Redis at 127.0.0.1:9999: Connection refused
not connected> PING
Could not connect to Redis at 127.0.0.1:9999: Connection refused
not connected> PING
Could not connect to Redis at 127.0.0.1:9999: Connection refused
```

通常在检测到断开连接后，`redis-cli` 总是尝试透明地重新连接；如果尝试失败，则显示错误并进入断开连接状态。以下是断开和重新连接的示例：

```shell
127.0.0.1:6379> INFO SERVER
Could not connect to Redis at 127.0.0.1:6379: Connection refused
not connected> PING
PONG
127.0.0.1:6379> 
(now we are connected again)
```

重新连接时，`redis-cli` 会自动重新选择上次选择的数据库编号。但是，有关连接的所有其他状态都会丢失，例如在 MULTI/EXEC 事务中：

```shell
$ redis-cli
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> PING
QUEUED

( here the server is manually restarted )

127.0.0.1:6379> EXEC
(error) ERR EXEC without MULTI
```

在交互模式下使用 `redis-cli` 进行测试时，这通常不是问题，但应该知道这一限制。

### 编辑，历史，自动补全和提示

因为 `redis-cli` 使用 linenoise 行编辑库，所以它始终具有行编辑功能，而不依赖于 `libreadline` 或其他可选库。

可以通过按下箭头键（上下）访问命令执行历史，以避免重新键入命令。根据 `HOME` 环境变量的指定，历史记录将在 CLI 重新启动之间保存在用户主目录中名为 `.rediscli_history` 的文件中。可以通过设置 `REDISCLI_HISTFILE` 环境变量来使用不同的历史文件名，并通过将其设置为 `/dev/null` 来禁用它。

`redis-cli` 还可以通过按 TAB 键执行命令名完成，如下例所示：

```shell
127.0.0.1:6379> Z<TAB>
127.0.0.1:6379> ZADD<TAB>
127.0.0.1:6379> ZCARD<TAB>
```

在提示符处输入 Redis 命令名后，`redis-cli` 将显示语法提示。与命令历史记录类似，可以通过 `redis-cli` 首选项打开和关闭此行为。

### 首选项

有两种方法可以自定义 `redis-cli` 行为。启动时，CLI 会加载主目录中的 `.redisclirc`文件。通过将 `REDISCLI_RCFILE` 环境变量设置为替代路径，可以覆盖文件的默认位置。也可以在 CLI 会话期间设置首选项，在这种情况下，首选项将仅持续会话的持续时间。

要设置首选项，请使用特殊的 `:set` 命令。可以通过在 CLI 中键入命令或将其添加到 `.rediclic` 文件来设置以下首选项：

- `:set hints` —— 启用语法提示
- `:set nohints` —— 停用语法提示

### 运行相同命令 N 次

通过在命令名称前面加上数字，可以在交互模式下多次运行同一命令：

```shell
127.0.0.1:6379> 5 INCR mycounter
(integer) 1
(integer) 2
(integer) 3
(integer) 4
(integer) 5
```

### 显示 Redis 命令的帮助

`redis-cli` 使用 `HELP` 命令为大多数 Redis 命令提供联机帮助。该命令可以两种形式使用：

- `HELP @<category>` 显示有关给定类别的所有命令。类别包括：
  - `@generic`
  - `@string`
  - `@list`
  - `@set`
  - `@sorted_set`
  - `@hash`
  - `@pubsub`
  - `@transactions`
  - `@connection`
  - `@server`
  - `@scripting`
  - `@hyperloglog`
  - `@cluster`
  - `@geo`
  - `@stream`
- `HELP <commandname>` 显示作为参数给出的命令的特定帮助。

例如，为了显示 `PFADD` 命令的帮助，请使用：

```shell
127.0.0.1:6379> HELP PFADD

PFADD key element [element ...]
summary: Adds the specified elements to the specified HyperLogLog.
since: 2.8.9
```

### 清理终端屏幕

在互动模式使用 `CLEAR` 命令清理终端屏幕。

### 特殊操作模式