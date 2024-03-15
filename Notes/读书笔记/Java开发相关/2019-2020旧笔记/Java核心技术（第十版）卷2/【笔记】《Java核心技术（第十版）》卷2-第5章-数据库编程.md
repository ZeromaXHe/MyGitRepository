# 第5章 数据库编程

JDBC的版本已更新过数次。作为Java SE 1.2的一部分，1998年发布了JDBC第2版。JDBC 3已经被囊括到了Java SE 1.4和5.0中，而在本书出版之际，最新版的JDBC 4.2也被囊括到了Java SE 8 中。

*注意：根据Oracle的声明，JDBC是一个注册了商标的术语，而并非Java Database Connectivity的首字母缩写。对它的命名体现了对ODBC的致敬，后者是微软开创的标准数据库API，并因此而并入了SQL标准中。*

## 5.1 JDBC的设计

这种接口组织方式遵循了微软公司非常成功的ODBC模式，ODBC为C语言访问数据库提供了一套编程接口。JDBC和ODBC都基于同一思想：根据API编写的程序都可以与驱动管理器进行通信，而驱动管理器通过驱动程序与实际的数据库进行通信。

所有这些都意味着JDBC API是大部分程序员不得不使用的接口。

### 5.1.1 JDBC驱动程序类型

JDBC规范将驱动程序归结为以下几类：

- 第1类驱动程序将JDBC翻译成ODBC，然后使用一个ODBC驱动程序与数据库进行通信。较早版本的Java包含了一个这样的驱动程序：JDBC/ODBC桥，不过在使用这个桥接器之前需要对ODBC进行相应的部署和正确的设置。在JDBC面世之初，桥接器可以方便地用于测试，却不太适用于产品的开发。Java 8 已经不再提供JDBC/ODBC桥了。
- 第2类驱动程序是由部分Java程序和部分本地代码组成的，用于与数据库的客户端API进行通信。在使用这种驱动程序之前，客户端不仅需要安装Java类库，还需要安装一些与平台相关的代码。
- 第3类驱动程序是纯Java客户端类库，它使用一种与具体数据库无关的协议将数据库请求发送给服务器构件，然后该构件再将数据库请求翻译成数据库相关协议。这简化了部署，因为平台相关的代码只位于服务器端。
- 第4类驱动程序是纯Java类库，它将JDBC请求直接翻译成数据库相关的协议。

总之，JDBC最终是为了实现以下目标：

- 通过使用标准的SQL语句，甚至是专门的SQL扩展，程序员就可以利用Java语言开发访问数据库的应用，同时还依旧遵守Java语言的相关协定。
- 数据库供应商和数据库工具开发商可以提供底层的驱动程序。因此，他们可以优化各自数据库产品的驱动程序。

### 5.1.2 JDBC的典型用法

在传统的客户端/服务端模型中，通常是在服务器端部署数据库，而这客户端安装富GUI程序。在此模型中，JDBC驱动程序应该部署在客户端。

但是，如今三层模型更加常见。在三层应用模型中，客户端不直接调用数据库，而是调用服务器上的中间件层，由中间件层完成数据库查询操作。这种三层模型有以下优点：它将可视化表示（位于客户端）从业务逻辑（位于中间层）和原始数据（位于数据库）中分离出来。因此，我们可以从不同的客户端，如Java桌面应用、浏览器或者移动App，来访问相同的数据和相同的业务规则。

客户端的中间层之间的通信在典型情况下是通过HTTP实现的。JDBC管理着中间层和后台数据库之间的通信。

## 5.2 结构化查询语言

SELECT语句相当灵活。仅使用下面这个查询语句，就可以查出Books表中的所有记录：

`SELECT * FROM Books`

在每一个SQL的SELECT语句中，FROM子句都是必不可少的。FROM子句用于告知数据库应该在哪些表上查询数据。

并且还可以在查询语句中使用WHERE子句来限定所要选择的行。

请小心使用"相等"这个比较操作。与Java编程语言不同，SQL使用=和<>而非==和！=来进行相等比较。

*注意：有些数据库供应商的产品支持在进行不等于比较时使用！=。这不符合标准SQL的语法，所以我们建议不要使用这种方法。*

WHERE子句也可以使用LIKE操作符来实现模式匹配。不过，这里的通配符并不是通常使用的`*`和`?`，而是用`%`表示0或多个字符，用下划线表示单个字符。

请注意，字符串都是用单引号括起来的，而非双引号。字符串中的单引号则需要一对单引号代替。

每当查询语句涉及多个表时，相同的列名可能会出现在两个不同的地方。	当出现歧义时，可以在每个列名前添加它所在表的表名作为前缀，比如Books/Publishers。

也可以使用SQL来改变数据库中的数据。例如，假设现在要将所有书名中包含“C++”的图书降价5美元，可以执行以下语句：

```sql
UPDATE Books
SET Price = Price - 5.00
WHERE Title LIKE '%C++%'
```

类似地要删除所有的C++图书，可以使用下面的DELETE查询：

```sql
DELETE FROM Books
WHERE Title LIKE '%C++%'
```

此外，SQL还有许多内置函数，用于对某一列计算平均值、查找最大值和最小值以及其他许多功能。在此我们就不讨论了。

通常，可以使用INSERT语句向表中插入值：

```sql
INSERT INTO Books
VALUES ('A Guide to the SQL Standard', '0-201-96426-0', '0201', 47.95)
```

我们必须为每一条插入到表中的记录使用一次INSERT语句。

当然，在查询、修改和插入数据之前，必须要有存储数据的位置。可以使用CREATE TABLE语句创建一个新表，还可以为每一列指定列名和数据类型。

```sql
CREATE TABLE Books
(
	Title CHAR(60),
    ISBN CHAR(13),
    Publisher_Id CHAR(6),
    Price DECIMAL(10,2)
)
```

最常见的SQL数据类型

| 数据类型                               | 说明                                   |
| -------------------------------------- | -------------------------------------- |
| INTEGER或INT                           | 通常为32位的整数                       |
| SMALLINT                               | 通常为16位的整数                       |
| NUMERIC(m,n), DECIMAL(m,n) or DEC(m,n) | m位长的定点十进制数，其中小数点后为n位 |
| FLOAT(n)                               | 运算精度为n位二进制数的浮点数          |
| REAL                                   | 通常为32位浮点数                       |
| DOUBLE                                 | 通常为64位浮点数                       |
| CHARACTER(n) or CHAR(n)                | 固定长度为n的字符串                    |
| VARCHAR(n)                             | 最大长度为n的可变长字符串              |
| BOOLEAN                                | 布尔值                                 |
| DATE                                   | 日历日期（与具体实现有关）             |
| TIME                                   | 当前时间（与具体实现相关）             |
| TIMESTAMP                              | 当前日期和时间（与具体实现相关）       |
| BLOB                                   | 二进制大对象                           |
| CLOB                                   | 字符大对象                             |

在本书中，我们不再介绍更多的子句，比如可以应用于CREATE TABLE语句的主键语句和约束子句。

## 5.3 JDBC配置

当然，你需要有一个可获得其JDBC驱动程序的数据库程序。目前这方面有许多出色的程序可供选择，比如IBM DB2、Microsoft SQL Server、MySQL、 Oracle和PostgreSQL。

### 5.3.1 数据库URL

JDBC使用了一种与普通URL相类似的语法来描述数据源。下面是这种语法的两个实例：

`jdbc:derby://localhost:1527/COREJAVA;create=true`

`jdbc:postgresql:COREJAVA`

上述JDBC URL指定了名为COREJAVA的一个Derby数据库和一个PostgreSQL数据库。JDBC URL的一般语法为：

`jdbc:subprotocol:otherstuff`

其中subprotocol用于选择连接到数据库的具体驱动程序。

otherstuff参数的格式随所使用的的subprotocol不同而不同。

### 5.3.2 驱动程序JAR文件

在运行访问数据库的程序时，需要将驱动程序的JAR文件包括到类路径中（编译时并不需要这个JAR文件）。

### 5.3.3 启动数据库

### 5.3.4 注册驱动器类

### 5.3.5 连接到数据库

【API】java.sql.DriverManager 1.1 :

- `static Connection getConnection(String url, String user, String password)`

## 5.4 使用JDBC语句

### 5.4.1 执行SQL语句

在执行SQL语句之前，首先需要创建一个Statement对象。要创建Statement对象，需要使用调用DriverManager.getConnection方法所获得的Connection对象。

接着，把要执行的SQL语句放入字符串中。

然后，调用Statement接口中的executeUpdate方法。	executeUpdate方法将返回受SQL语句影响的行数，或者对不返回行数的语句返回0。

executeUpdate方法既可以执行诸如INSERT、UPDATE和DELETE之类的操作，也可以执行诸如CREATE TABLE和DROP TABLE之类的数据定义语句。但是，执行SELECT查询时必须使用executeQuery方法。另外还有一个execute语句可以执行任意的SQL语句，此方法通常只用于由用户提供的交互式查询。

当我们执行查询操作时，通常感兴趣的是查询结果。executeQuery方法会返回一个ResultSet类型的对象，可以通过它来每次一行地迭代遍历所有查询结果。

*警告：ResultSet接口的迭代协议与java.util.Iterator接口稍有不同。对于ResultSet接口，迭代器初始化时被设定在第一行之前的位置，必须调用next方法将它移动到第一行。另外，它没有hasNext方法，我们需要不断调用next，直至该方法返回false*

结果集中行的顺序是任意排列的。除非使用ORDER BY子句指定行的顺序，否则不能为行序强加任何意义。

查看每一行时，可能希望知道其中每一列的内容，有许多访问器（accessor）方法可以用于获取这些信息。

不同的数据类型有不同的访问器，比如getString和getDouble。每个访问器都有两种形式，一种接受数字型参数，另一种接受字符串参数。当使用数字型参数时，我们指的是该数字所对应的列。

*==警告：与数组的索引不同，数据库的列序号是从1开始计算的。==*

当使用字符串参数时，指的是结果集中以该字符串为列名的列。	使用数字型参数效率更高一些，但是使用字符串参数可以使代码易于阅读和维护。

当get方法的类型和列的数据类型不一致时，每个get方法都会进行合理的类型转换。

【API】java.sql.Connection 1.1 :

- `Statement createStatement()`
- `void close()`

【API】java.sql.Statement 1.1 :

- `ResultSet executeQuery(String sqlQuery)`
- `int executeUpdate(String sqlStatement)`
- `long executeLargeUpdate(String sqlStatement)` 8
- `boolean execute(String sqlStatement)`
- `ResultSet getResultSet()`
- `int getUpdateCount()`
- `long getLargeUpdateCount()` 8
- `void close()`
- `boolean isClosed()` 6
- `void closeOnCompletion()` 7

【API】java.sql.ResultSet 1.1 :

- `boolean next()`
- `Xxx getXxx(int columnNumber)`
- `Xxx getXxx(String columnLabel)`
- `<T> T getObject(int columnIndex, Class<T> type)` 7
- `<T> T getObject(String columnLabel, Class<T> type)` 7
- `void updateObject(int columnIndex, Object x, SQLType targetSqlType)` 8
- `void updateObject(String columnLabel, Object x, SQLType targetSqlType)` 8
- `int findColumn(String columnName)`
- `void close()`
- `boolean isClosed()` 6

### 5.4.2 管理连接、语句和结果集

每个Connection对象都可以创建一个或多个Statement对象。同一个Statement对象可以用于多个不相关的命令和查询。但是，一个Statement对象最多只能有一个打开的结果集。如果需要执行多个查询操作，且需要同时分析查询结果，那么必须创建多个Statement对象。