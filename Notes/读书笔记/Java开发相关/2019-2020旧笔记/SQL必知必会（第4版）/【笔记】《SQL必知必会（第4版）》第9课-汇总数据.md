# 第9课 汇总数据

## 9.1 聚集函数

聚集函数（aggregate function）

AVG()

COUNT()

MAX()

MIN()

SUM()

### 9.1.1 AVG()函数

平均值

注意：只用于单个列

说明：NULL值	忽略

### 9.1.2 COUNT()函数

计数

COUNT（*）	不管包含NULL还是非空值

COUNT（column）	忽略NULL

说明: NULL值

### 9.1.3 MAX()函数

最大值	要求指定列名

提示：对非数值数据使用MAX()	最后一行

说明：NULL值	忽略

### 9.1.4 MIN()函数

最小值	要求指定列名

提示：对非数值数据使用MIN()	最前面的行

说明：NULL值	忽略

### 9.1.5 SUM()函数

和（总计）

提示：在多个列上进行计算

说明：NULL值	忽略

## 9.2 聚集不同值

提示：ALL为默认

说明：不要在Access中使用	不支持DISTINCT

注意：DISTINCT不能用于COUNT(*)

提示：将DISTINCT用于MIN()和MAX()

说明：其他聚集参数

## 9.3 组合聚集函数

注意：取别名

## 9.4 小结

