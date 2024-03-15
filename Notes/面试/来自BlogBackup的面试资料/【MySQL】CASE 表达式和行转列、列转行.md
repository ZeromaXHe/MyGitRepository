# 简答

CASE 表达式的语法分为**简单 CASE 表达式**和**搜索 CASE 表达式**两种。

简单 CASE 表达式的语法如下所示：

```sql
CASE <表达式>
	WHEN <表达式> THEN <表达式>
	WHEN <表达式> THEN <表达式>
	WHEN <表达式> THEN <表达式>
	……
	ELSE <表达式>
END
```

搜索 CASE 表达式的语法如下：

```sql
CASE WHEN <求值表达式> THEN <表达式>
	WHEN <求值表达式> THEN <表达式>
	WHEN <求值表达式> THEN <表达式>
	……
	ELSE <表达式>
END
```

对于同一个语句的不同写法可以简单对比如下：

```sql
-- 简单 CASE 表达式
CASE sex
	WHEN '1' THEN '男'
    WHEN '2' THEN '女'
ELSE '其他' END

-- 搜索 CASE 表达式
CASE WHEN sex = '1' THEN '男'
	WHEN sex = '2' THEN '女'
ELSE '其他' END
```

我们在编写 SQL 语句的时候需要注意，在发现为真的 `WHEN` 子句时，`CASE` 表达式的真假值判断就会中止，而剩余的 `WHEN` 子句会被忽略。为了避免引起不必要的混乱，使用 `WHEN` 子句时要注意条件的排他性。

使用 CASE 表达式的时候，还需要注意以下几点：

1. **统一各分支返回的数据类型**。某个分支返回字符型，而其他分支返回数值型的写法是不正确的。
2. **不要忘了写 END**。使用 `CASE` 表达式的时候，最容易出现的语法错误是忘记写 `END`。
3. **养成写 ELSE 子句的习惯**。`ELSE` 子句是可选的，不写也不会出错。不写 `ELSE` 子句时，`CASE` 表达式的执行结果是 `NULL` 。但是不写可能会造成“语法没有错误，结果却不对”这种不易追查原因的麻烦。



行转列可以通过 `CASE` 表达式和 `MAX` 函数实现，列转行主要依赖于 `UNION` 实现。（SQL SERVER 还提供了专门的 `PIVOT` 和 `UNPIVOT` 函数，这里不做详细介绍）

详情参考文末的 “5 行转列” 和 “6 列转行” 两节。这里简单贴一下关键代码：

行转列

```sql
SELECT user_name ,
    MAX(CASE course WHEN '数学' THEN score ELSE 0 END ) 数学,
    MAX(CASE course WHEN '语文' THEN score ELSE 0 END ) 语文,
    MAX(CASE course WHEN '英语' THEN score ELSE 0 END ) 英语
FROM student
GROUP BY USER_NAME;
```

列转行

```sql
select user_name, '语文' COURSE , CN_SCORE as SCORE from grade
union select user_name, '数学' COURSE, MATH_SCORE as SCORE from grade
union select user_name, '英语' COURSE, EN_SCORE as SCORE from grade
order by user_name, COURSE;
```



# 详解

# 1 什么是 CASE 表达式

CASE 表达式是在区分情况时使用的，这种情况的区分在编程中通常称为**（条件）分支**。

# 2 CASE 表达式的语法

CASE 表达式的语法分为**简单 CASE 表达式**和**搜索 CASE 表达式**两种。

由于搜索 CASE 表达式包含了简单 CASE 表达式的全部功能，因此我们先介绍搜索 CASE 表达式。

## 2.1 搜索 CASE 表达式

搜索 CASE 表达式的语法如下：

```sql
CASE WHEN <求值表达式> THEN <表达式>
	WHEN <求值表达式> THEN <表达式>
	WHEN <求值表达式> THEN <表达式>
	……
	ELSE <表达式>
END
```

**WHEN 子句**中的“<求值表达式>”就是类似“列 = 值”这样，返回值为真值（`TRUE`/`FALSE`/`UNKNOWN`）的表达式。我们也可以将其看作使用 `=`、`!=` 或者 `LIKE`、`BETWEEN` 等谓词编写出来的表达式。

`CASE` 表达式会从对最初的 `WHEN` 子句中的“<求值表达式>”进行求值开始执行。所谓**求值**，就是要调查该表达式的真值是什么。如果结果为真（`TRUE`），那么就返回 **THEN 子句**中的表达式，`CASE` 表达式的执行到此为止。如果结果不为真，那么就跳转到下一条 `WHEN` 子句的求值之中。如果直到最后的 `WHEN` 子句为止返回结果都不为真，那么就会返回 **ELSE** 中的表达式，执行终止。

从 `CASE` 表达式名称中的“表达式”我们也能看出来，上述这些整体构成了一个表达式。并且由于表达式最终会返回一个值，因此 `CASE` 表达式在 SQL 语句执行时，也会转化为一个值。

## 2.2 简单 CASE 表达式

简单 CASE 表达式比搜索 CASE 表达式简单，但是会受到条件的约束，因此通常情况下都会使用搜索 CASE 表达式。

简单 CASE 表达式的语法如下所示：

```sql
CASE <表达式>
	WHEN <表达式> THEN <表达式>
	WHEN <表达式> THEN <表达式>
	WHEN <表达式> THEN <表达式>
	……
	ELSE <表达式>
END
```

与搜索 CASE 表达式一样，简单 CASE 表达式也是从最初的 WHEN 子句开始进行，逐一判断每个 WHEN 子句直到返回真值为止。此外，没有能够返回真值的 WHEN 子句时，也会返回 ELSE 子句指定的表达式。两者的不同之处在于，简单 CASE 表达式最初的“CASE <表达式>”也会作为求值的对象。

# 3 CASE 表达式的使用方法

CASE 表达式有简单 CASE 表达式（simple case expression）和搜索 CASE 表达式（searched case expression）两种写法，它们分别如下所示：

```sql
-- 简单 CASE 表达式
CASE sex
	WHEN '1' THEN '男'
    WHEN '2' THEN '女'
ELSE '其他' END

-- 搜索 CASE 表达式
CASE WHEN sex = '1' THEN '男'
	WHEN sex = '2' THEN '女'
ELSE '其他' END
```

这两种写法的执行结果是相同的，“sex”列（字段）如果是 '1' ，那么结果为男；如果是 '2' ，那么结果为女。简单 `CASE` 表达式正如其名，写法简单，但能实现的事情比较有限。简单 `CASE` 表达式能写的条件，搜索 `CASE` 表达式也能写，所以基本上采用搜索 `CASE` 表达式的写法。 

我们在编写 SQL 语句的时候需要注意，在发现为真的 `WHEN` 子句时，`CASE` 表达式的真假值判断就会中止，而剩余的 `WHEN` 子句会被忽略。为了避免引起不必要的混乱，使用 `WHEN` 子句时要注意条件的排他性。

使用 CASE 表达式的时候，还需要注意以下几点：

1. **统一各分支返回的数据类型**。某个分支返回字符型，而其他分支返回数值型的写法是不正确的。
2. **不要忘了写 END**。使用 `CASE` 表达式的时候，最容易出现的语法错误是忘记写 `END`。
3. **养成写 ELSE 子句的习惯**。`ELSE` 子句是可选的，不写也不会出错。不写 `ELSE` 子句时，`CASE` 表达式的执行结果是 `NULL` 。但是不写可能会造成“语法没有错误，结果却不对”这种不易追查原因的麻烦。

## 3.1 商品表示例

例如，现在 Product （商品）表中包含衣服、办公用品和厨房用具 3 种商品类型，如何得到如下结果：

```
A:衣服
B:办公用品
C:厨房用具
```

因为表中的记录并不包含 "A:" 或者 "B:" 这样的字符串，所以需要在 SQL 中进行添加。我们可以使用字符串连接函数“||”来完成这项工作。

剩下的问题就是怎样正确地将“A:”、“B:”、“C:”与记录结合起来。这时就可以使用 CASE 表达式来实现了。

```sql
SELECT product_name
	CASE WHEN product_type = '衣服'
		THEN 'A:' || product_type
		WHEN product_type = '办公用品'
		THEN 'B:' || product_type
		WHEN product_type = '厨房用具'
		THEN 'C:' || product_type
		ELSE NULL
	END AS abc_product_type
FROM Product;
```

执行结果：

```
product_name | abc_product_type
-------------+------------------
T恤衫         | A:衣服
打孔器        | B:办公用品
运动T恤       | A:衣服
菜刀          | C:厨房用具
高压锅        | C:厨房用具
叉子          | C:厨房用具
擦菜板        | C:厨房用具
圆珠笔        | B:办公用品
```

与商品种类（`product_type`）的名称相对应，`CASE` 表达式中包含了 3 条 `WHEN` 子句分支。最后的 `ELSE NULL` 是“上述情况之外时返回 `NULL`” 的意思。`ELSE` 子句指定了应该如何处理不满足 `WHEN` 子句中的条件的记录，`NULL` 之外的其他值或者表达式也都可以写在 `ELSE` 子句之中。

`ELSE` 子句也可以省略不写，这时会被默认为 `ELSE NULL`。但为了防止有人漏读，还是希望大家能够显式地写出 `ELSE` 子句。

此外，`CASE` 表达式最后的 "END" 是不能省略的。忘记书写 `END` 会发生语法错误。



下面我们看一看搜索 `CASE` 表达式和简单 `CASE` 表达式是如何实现相同含义的 SQL 语句的。将上面代码清单的搜索 `CASE` 表达式的 SQL 改写为简单 `CASE` 表达式，结果如下所示：

```sql
-- 使用搜索CASE表达式的情况
SELECT product_name,
	CASE WHEN product_type = '衣服' 
		THEN 'A ：' || product_type
		WHEN product_type = '办公用品' 
		THEN 'B ：' || product_type
		WHEN product_type = '厨房用具' 
		THEN 'C ：' || product_type
		ELSE NULL
	END AS abc_product_type
FROM Product;
-- 使用简单CASE表达式的情况
SELECT product_name,
	CASE product_type
		WHEN '衣服' THEN 'A ：' || product_type
		WHEN '办公用品' THEN 'B ：' || product_type
		WHEN '厨房用具' THEN 'C ：' || product_type
		ELSE NULL
	END AS abc_product_type
FROM Product;
```

像“`CASE product_type`”这样，简单 `CASE` 表达式在将想要求值的表达式（这里是列）书写过一次之后，就无需在之后的 `WHEN` 子句中重复书写 “product_type” 了。虽然看上去简化了书写，但是想要在 `WHEN` 子句中指定不同列时，简单 `CASE` 表达式就无能为力了。

## 3.2 将已有编号方式转换为新的方式并统计

在进行非定制化统计时，我们经常会遇到将已有编号方式转换为另外一种便于分析的方式并进行统计的需求。 

例如，现在有一张按照“‘1：北海道’、‘2：青森’、……、‘47：冲绳’”这种编号方式来统计都道府县人口的表，我们需要以东北、关 东、九州等地区为单位来分组，并统计人口数量。具体来说，就是统计下表 PopTbl 中的内容，得出如下表“统计结果”所示的结果。 

**统计数据源表 PopTbl**

| pref_name（县名） | population（人口） |
| ----------------- | ------------------ |
| 德岛              | 100                |
| 香川              | 200                |
| 爱媛              | 150                |
| 高知              | 200                |
| 福冈              | 300                |
| 佐贺              | 100                |
| 长崎              | 200                |
| 东京              | 400                |
| 群马              | 50                 |

**统计结果**

| 地区名 | 人口 |
| ------ | ---- |
| 四国   | 650  |
| 九州   | 600  |
| 其他   | 450  |

在“统计结果”这张表中，“四国”对应的是表 PopTbl 中的“德岛、香川、爱媛、高知”，“九州”对应的是表 PopTbl 中的“福冈、佐贺、长崎”。

而如果使用 `CASE` 表达式，则用如下所示的一条 SQL 语句就可以完成。为了便于理解，这里用县名（pref_name）代替编号作为 `GROUP BY` 的列。

```sql
-- 把县编号转换成地区编号(1)
SELECT CASE pref_name
		WHEN '德岛' THEN '四国'
    	WHEN '香川' THEN '四国'
    	WHEN '爱媛' THEN '四国'
    	WHEN '高知' THEN '四国'
    	WHEN '福冈' THEN '九州'
    	WHEN '佐贺' THEN '九州'
    	WHEN '长崎' THEN '九州'
    ELSE '其他' END AS district,
    SUM(population)
FROM PopTbl
GROUP BY CASE pref_name
		WHEN '德岛' THEN '四国'
        WHEN '香川' THEN '四国'
        WHEN '爱媛' THEN '四国'
        WHEN '高知' THEN '四国'
        WHEN '福冈' THEN '九州'
        WHEN '佐贺' THEN '九州'
        WHEN '长崎' THEN '九州'
    ELSE '其他' END;
```

这里的关键在于将 `SELECT` 子句里的 `CASE` 表达式复制到 `GROUP BY` 子句里。需要注意的是，如果对转换前的列“pref_name”进行 `GROUP BY` ，就得不到正确的结果（因为这并不会引起语法错误，所以容易被忽视）。 

这个技巧非常好用。不过，必须在 `SELECT` 子句和 `GROUP BY` 子句这两处写一样的 `CASE` 表达式，这有点儿麻烦。后期需要修改的时候， 很容易发生只改了这一处而忘掉改另一处的失误。 

所以，如果我们可以像下面这样写，那就方便多了。

```mysql
-- 把县编号转换成地区编号(2) ：将CASE 表达式归纳到一处
SELECT CASE pref_name
		WHEN '德岛' THEN '四国'
        WHEN '香川' THEN '四国'
        WHEN '爱媛' THEN '四国'
        WHEN '高知' THEN '四国'
        WHEN '福冈' THEN '九州'
        WHEN '佐贺' THEN '九州'
        WHEN '长崎' THEN '九州'
    ELSE '其他' END AS district,
    SUM(population)
FROM PopTbl GROUP BY district; -- GROUP BY 子句里引用了 SELECT 子句中定义的别名
```

没错，这里的 `GROUP BY` 子句使用的正是 `SELECT` 子句里定义的列的别称——district 。但是严格来说，这种写法是违反标准 SQL 的规则的。因为 `GROUP BY` 子句比 `SELECT` 语句先执行，所以在 `GROUP BY` 子句中引用在 `SELECT` 子句里定义的别称是不被允许的。事实上，在 Oracle、DB2、SQL Server 等数据库里采用这种写法时就会出错。

不过也有支持这种 SQL 语句的数据库，例如在 PostgreSQL 和 MySQL 中，这个查询语句就可以顺利执行。这是因为，这些数据库在执行查询语句时，会先对 `SELECT` 子句里的列表进行扫描，并对列进行计算。不过因为这是违反标准的写法，所以这里不强烈推荐大家使用。但是，这样写出来的 SQL 语句确实非常简洁，而且可读性也很好。 

## 3.3 CASE 表达式的书写位置

`CASE` 表达式的便利之处就在于它是一个表达式。之所以这么说，是因为表达式可以书写在任意位置。例如，我们可以利用 `CASE` 表达式将下述 `SELECT` 语句结果中的行和列进行互换。

通常我们将商品种类列作为 `GROUP BY` 子句的聚合键来使用，但是这样得到的结果会以“行”的形式输出，而无法以列的形式进行排列

```sql
SELECT product_type,
	SUM(sale_price) AS sum_price
FROM Product
GROUP BY product_type;
```

执行结果

```
product_type  | sum_price
--------------+----------
衣服           | 5000
办公用品        | 600
厨房用具        | 11180
```

我们可以像如下代码清单那样在 `SUM` 函数中使用 `CASE` 表达式来获得一个 3 列的结果

```sql
-- 对按照商品种类计算出的销售单价合计值进行行列转换
SELECT SUM(CASE WHEN product_type = '衣服' 
           THEN sale_price ELSE 0 END) AS sum_price_clothes,
       SUM(CASE WHEN product_type = '厨房用具'
           THEN sale_price ELSE 0 END) AS sum_price_kitchen,
       SUM(CASE WHEN product_type = '办公用品' 
           THEN sale_price ELSE 0 END) AS sum_price_office
FROM Product;
```

执行结果

```
sum_price_clothes | sum_price_kitchen | sum_price_office
------------------+-------------------+-----------------
             5000 |             11180 |              600
```

在满足商品种类（`product_type`）为“衣服”或者“办公用品”等特定值时，上述 `CASE` 表达式输出该商品的销售单价（`sale_price`），不满足时输出 0。对该结果进行汇总处理，就能够得到特定商品种类的销售单价合计值了。

在对 `SELECT` 语句的结果进行编辑时，`CASE` 表达式能够发挥较大作用。

# 4 特定的 CASE 表达式

由于 `CASE` 表达式是标准 SQL 所承认的功能，因此在任何 DBMS 中都可以执行。但是，有些 DBMS 还提供了一些特有的 `CASE` 表达式的简化函数，例如 Oracle 中的 **DECODE**、MySQL 中的 **IF** 等。

使用 Oracle 中的`DECODE` 和 MySQL 中的 `IF` 将字符串 A ～ C 添加到商品种类（product_type）中的 SQL 语句请参考下面代码清单：

```sql
-- Oracle中使用DECODE代替CASE表达式
SELECT product_name,
	DECODE(product_type, 
		'衣服', 'A ：' | | product_type,
		'办公用品', 'B ：' | | product_type,
		'厨房用具', 'C ：' | | product_type,
		NULL) AS abc_product_type
FROM Product;

-- MySQL中使用IF代替CASE表达式
SELECT product_name,
	IF( IF( IF(product_type = '衣服', 
				CONCAT('A ：', product_type), NULL)
			IS NULL AND product_type = '办公用品', 
				CONCAT('B ：', product_type), 
		IF(product_type = '衣服',
            CONCAT('A ：', product_type), NULL))
       			IS NULL AND product_type = '厨房用具', 
					CONCAT('C ：', product_type), 
				IF( IF(product_type = '衣服', 
					CONCAT('A：', product_type), NULL)
			IS NULL AND product_type = '办公用品', 
				CONCAT('B ：', product_type), 
		IF(product_type = '衣服', 
           	CONCAT('A ：', product_type), 
	NULL))) AS abc_product_type
FROM Product;
```

但上述函数只能在特定的 DBMS 中使用，并且能够使用的条件也没有 `CASE` 表达式那么丰富，因此并没有什么优势。希望大家尽量不要使用这些特定的 SQL 语句。

# 5 行转列

建表

```sql
CREATE TABLE `student` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `USER_NAME` varchar(20) DEFAULT NULL,
  `COURSE` varchar(20) DEFAULT NULL,
  `SCORE` float DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
```

新增数据

```sql
insert into student(USER_NAME, COURSE, SCORE) values
("张三", "数学", 34),
("张三", "语文", 58),
("张三", "英语", 58),
("李四", "数学", 45),
("李四", "语文", 87),
("李四", "英语", 45),
("王五", "数学", 76),
("王五", "语文", 34),
("王五", "英语", 89);
```

行转列

```sql
SELECT user_name ,
    MAX(CASE course WHEN '数学' THEN score ELSE 0 END ) 数学,
    MAX(CASE course WHEN '语文' THEN score ELSE 0 END ) 语文,
    MAX(CASE course WHEN '英语' THEN score ELSE 0 END ) 英语
FROM student
GROUP BY USER_NAME;
```

结果

| user_name | 数学 | 语文 | 英语 |
| --------- | ---- | ---- | ---- |
| 张三      | 34   | 58   | 58   |
| 李四      | 45   | 87   | 45   |
| 王五      | 76   | 34   | 89   |

# 6 列转行

建表

```sql
CREATE TABLE `grade` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `USER_NAME` varchar(20) DEFAULT NULL,
  `CN_SCORE` float DEFAULT NULL,
  `MATH_SCORE` float DEFAULT NULL,
  `EN_SCORE` float DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

新增数据

```sql
insert into grade(USER_NAME, CN_SCORE, MATH_SCORE, EN_SCORE) values
("张三", 34, 58, 58),
("李四", 45, 87, 45),
("王五", 76, 34, 89);
```

列转行

```sql
select user_name, '语文' COURSE , CN_SCORE as SCORE from grade
union select user_name, '数学' COURSE, MATH_SCORE as SCORE from grade
union select user_name, '英语' COURSE, EN_SCORE as SCORE from grade
order by user_name, COURSE;
```

结果

| user_name | COURSE | SCORE |
| --------- | ------ | ----- |
| 张三      | 数学   | 58    |
| 张三      | 英语   | 58    |
| 张三      | 语文   | 34    |
| 李四      | 数学   | 87    |
| 李四      | 英语   | 45    |
| 李四      | 语文   | 45    |
| 王五      | 数学   | 34    |
| 王五      | 英语   | 89    |
| 王五      | 语文   | 76    |



# 参考文档

- 《SQL 基础教程（第 2 版）》6-3 CASE 表达式
- 《SQL 进阶教程》1-1 CASE 表达式
- https://www.jianshu.com/p/5a2dae144238