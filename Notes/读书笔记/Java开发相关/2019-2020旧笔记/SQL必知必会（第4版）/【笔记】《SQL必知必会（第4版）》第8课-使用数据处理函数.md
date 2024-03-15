# 第8课 使用数据处理函数

## 8.1 函数

### 函数带来的问题

SQL函数是不是可移植的。

可移植（portable）

提示：是否应该使用函数？

## 8.2 使用函数

### 8.2.1 文本处理函数

UPPER()函数	将文本转换为大写

LEFT()（或使用子字符串函数）	返回字符串左边的字符

LENGTH()（也使用DATALENGTH()或LEN()）	返回字符串的长度

LOWER()（Access使用LCASE()）	将字符串转换为小写

LTRIM()

RIGHT()（或使用子字符串函数）	返回字符串右边的字符

RTRIM()

SOUNDEX()	返回字符串的SOUNDEX值

UPPER()（Access使用UCASE()）	将字符串转换为大写

说明：SOUNDEX支持	Microsoft Access和PostgreSQL不支持SOUNDEX()	SQLite中SQLITE_SOUNDEX不是默认的编译时选项

### 8.2.2 日期和时间处理函数

MySQL和MariaDB	YEAR()

### 8.2.3 数值处理函数

ABS()	返回一个数的绝对值

COS()	返回一个角度的余弦

EXP()	返回一个数的指数值

PI()	返回圆周率

SIN()	返回一个数的正弦

SQRT()	返回一个数的平方根

TAN()	返回一个角度的正切

## 8.3 小结