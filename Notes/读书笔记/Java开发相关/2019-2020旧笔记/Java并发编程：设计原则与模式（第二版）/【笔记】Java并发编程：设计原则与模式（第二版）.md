# 第1章 面向对象的并发编程

# 第2章 独占

## 2.2 同步

### 2.2.1 机制

#### 2.2.1.1 对象和锁

不能把数组元素声明为volatile。

#### 2.2.1.2 同步方法和阻塞

`synchronized void f(){/*body*/}`和`void f(){synchronized(this){/*body*/}}`是等价的。

synchronized关键字不属于方法签名的一部分。所以当子类覆盖父类方法时，synchronized修饰符不会被继承。因此接口中的方法不能被声明为synchronized。同样地，构造函数不能被声明为synchronized（尽管构造函数中的程序块可以被声明为synchronized）。

### 2.2.7 Java存储模型

#### 2.2.7.4 volatile

把一个数据声明为volatile的区别（和同步相比——译者注）只是没有使用锁。尤其是对于复合读写操作，例如对volatile变量++操作在执行时**并不具有**原子性。

