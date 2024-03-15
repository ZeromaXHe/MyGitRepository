# 导航表

| key          | value                |
| ------------ | -------------------- |
| **题目**     | finally 的实现原理？ |
| **同义题目** | （暂无）             |
| **主题**     | Java                 |
| **上推问题** | （暂无）             |
| **平行问题** | （暂无）             |
| **下切问题** | （暂无）             |

关于 Java 虚拟机是如何编译 finally 语句块的问题，有兴趣的读者可以参考《The Java(TM) Virtual Machine Specification, Second Edition》中 7.13 节 Compiling finally。那里详细介绍了 Java 虚拟机是如何编译 finally 语句块。

实际上，Java 虚拟机会把 finally 语句块作为 subroutine 直接插入到 try 语句块或者 catch 语句块的控制转移语句之前。但是，还有另外一个不可忽视的因素，那就是在执行 subroutine（也就是 finally 语句块）之前，try 或者 catch 语句块会保留其返回值到本地变量表（Local Variable Table）中。待 subroutine 执行完毕之后，再恢复保留的返回值到操作数栈中，然后通过 return 或者 throw 语句将其返回给该方法的调用者（invoker）。

# 1. try catch 的机制：异常表

Java 中的 finally 是不可以单独使用的，只能结合 try 使用，所以有必要先弄明白 try catch 的原理。

源代码如下

```java
public static void tryCatch() {
    try {
        test();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
```

使用命令 `javap -v -p Test.class` 反编译得到方法的字节码

```java
public static void tryCatch();
	descriptor: ()V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
    	stack=1, locals=1, args_size=0
    		0: invokestatic #5 // Method test:()V
    		3: goto 11
    		6: astore_0
    		7: aload_0
    		8: invokevirtual #7 // Method java/lang/Exception.printStackTrace:()V
    		11: return
    	Exception table:
    		from	to	target	type
    		0		3	6		Class java/lang/Exception
```

从字节码可以看出，方法 tryCatch 有一个**异常表**（Exception table），异常表解释为，从位置 from 的指令开始，此处 from = 0，表示 Code 中偏移量为 0 的指令，也就是 `invokestatic #5` 这个指令，到位置 to（不包括 to）的指令为止，这段指令执行期间如果发生异常且异常的类型 type 为 Class java.lang.Exception，程序就跳转到 target 处指令，这里 target = 6 处指令是 `astore_0`。异常表的一行数据，表示一个 catch 块，这里只有一个行，也就是只有一个 catch 块。

下面逐行解释一下该方法的指令：

- 偏移量 0 `invokestatic #5`，该指令则是调用静态方法 `test()`。
- 偏移量 3 `goto 11`，如果上一条指令发生异常，就执行该条指令，直接跳转到偏移量11的指令。
- 偏移量 6 `astore_0`，如果第一条指令发⽣异常，根据异常表，程序就会跳转到这条指令，6 ~ 8 三条指令就是 catch 块代码对应的指令了，astore_0 指令是将第⼀条指令的异常对象存储到局部变量表 slot = 1 的位置。
- 偏移量 7 `aload_0`，将局部变量表 slot = 1 的位置异常对象压入操作数栈。
- 偏移量 8 `invokevirtual #7`，调⽤ `java.lang.Excetion.printStackTrace()` 方法，调⽤对象就是上⼀个指令压入操作数栈的异常对象。
- 偏移量 9 `return`，不管是从 goto 11 这条指令跳转到这的，还是发生了异常，执行了 catch 块代码后到这的，方法最后需要执行的都是 return 指令，方法结束。

# 2. finally 机制：复制 finally 代码块到每个分支

做 Java 的都知道或者听说过 finally 块一定会执行，那么 Java 是如何保证 finally 块一定会执行的呢？

看源代码如下：

```java
public static void func1() {
    try {
        test();
    } catch (Exception e) {
        test1();
    } finally {
        test2();
    }
}
```

还是使用命令 `javap -v -p Test.class` 反编译得到方法的字节码如下：

```java
public static void func1();
	descriptor: ()V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
		stack=1, locals=2, args_size=0
            0: invokestatic #5	// Method test:()V
            3: invokestatic #8	// Method test2:()V
            6: goto 25
            9: astore_0
            10: invokestatic #9	// Method test1:()V
            13: invokestatic #8	// Method test2:()V
            16: goto 25
            19: astore_1
            20: invokestatic #8	// Method test2:()V
            23: aload_1
            24: athrow
            25: return
        Exception table:
        	from	to	target	type
        	0		3	9		Class java/lang/Exception
        	0		3	19		any
        	9		13	19		any
```

先看最后异常表，结合刚刚讲解的异常表知识，我们可以知道 func1 方法有三个 catch 块，但是我们的代码里明明只有一个 catch 块啊？解释就是编译器添加了两个 catch 块。第一行表示指令 0 发生 Exception 类型异常跳转到指令 9。第二行表示指令 0 发生任何类型异常（也就是 Throwable 类型）跳转到指令 19，前提是前面没有捕获该异常。第三行表示指令 9 ~ 10 发生任何类型异常则跳转到指令 19。

现在来看方法字节码指令：

- 0：`invokestatic #5` 调用静态方法 test()，结合异常表可知，test 若发生 Exception 类型异常，程序跳转到指令 9，若发生 Throwable 类型异常，程序跳转到指令 19，若没有发生异常，则顺序往下执行。
- 3：`invokestatic #8` 调用静态方法 test2()。这是在 try 块中调用 test2()。
- 6：`goto 25` 跳转到 25 指令 return，将会结束方法。
- 9：`astore_0` 将异常对象存储到局部变量表 slot=0 的位置
- 10：`invokestatic #9` 调用静态方法 test1()，这是第一个 catch 块的代码
- 13：`invokestatic #8` 调用静态方法 test2()。这是在第一个 catch 块中调用 test2()。
- 16：`goto 25` 同 6。
- 19：`astore_1` 将异常对象存储到局部变量表 slot=1 的位置，这是第二、三个 catch 块。
- 20：`invokestatic #8` 调用 test2()。
- 23 ~ 24：将异常重新抛出。
- 25：return 方法结束。

通过解析字节码，可以知道编译后的 func1 相当于这样

```java
public static void func1() {
    try {
        test();
        test2(); // 编译器添加的 finally 块代码
    } catch (Exception e) {
        try {
            test1();
            test2(); // 编译器添加的 finally 块代码
        } catch (Throwable t) { // 编译器添加的 Throwable 类型的 catch 分支
            test2(); // 添加这个分支的目的就是为了确保 test1() 方法发生异常后 finally 块还会被执行
            throw t;
        }
    } catch (Throwable t) { // 这个也是编译器添加的 Throwable 类型的 catch 分支，目的还是为了确保 finally 块一定执行
        test2(); // 编译器复制的 finally 块代码
        throw t; // 抛出异常
    }
}
```

至此，我们可以回答“ Java 是如何保证 finally 块一定会执行的呢？”这个问题了：编译器将 finally 块代码复制到每个分支，并且编译器还会为每个分支添加一个 Throwable 类型的 catch 分支，然后再这个 catch 分支里，先添加 finally 块的代码，再将异常对象原样抛出。finally 是通过复制代码块到每个分支最后，而不是在每个分支最后跳转到 finally 块。

# 3. 当 finally 遇到 return，return 的表现会有什么不一样呢？

我们先单独看 return 的字节码是怎样的，下面是源代码

```java
public static int returnFunc() {
    return 1;
}
```

javap 反编译后的字节码指令如下

```java
public static int returnFunc();
	descriptor:()I
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
		stack=1, locals=0, args_size=0
            0: iconst_1
            1: ireturn
```

总共就两个指令，`iconst_1`，将 int 型常量 1 压入操作数栈，ireturn，将操作数栈顶的 int 型变量返回并结束方法。所以，通常来说代码 return i 被编译为两个指令，第一个指令，将需要返回的值压入栈顶，第二个指令，将栈顶变量作为方法返回值并结束方法。

然后让我们来看 finally 和 return 一起使用时，return 会有什么不一样呢？源代码如下，这也是一个经典的面试题。

```java
public static int func2() {
    int i = 0;
    try {
        return i;
    } catch (Exception e) {
        return i;
    } finally {
        i++;
    }
}
```

javap 反编译后的字节码如下

```java
public static int func2();
	descriptor: ()I
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
		stack=1, locals=4, args_size=0
            0: iconst_0
            1: istore_0
            2: iload_0
            3: istore_1
            4: iinc 0, 1
            7: iload_1
            8: ireturn
            9: astore_1
            10: iload_0
            11: istore_2
            12: iinc 0, 1
            15: iload_2
            16: ireturn
            17: astore_3
            18: iinc 0, 1
            21: aload_3
            22: athrow
        Exception table:
			from	to	target	type
            2		4	9		Class java/lang/Exception
            2		4	17		any
            9		12	17		any
```

0 ~ 1：两个指令为局部变量 i 赋值 0，也就是 int i = 0。

2 ~ 3：`iload_0` 将局部变量 i 的值压入栈顶，`istore_1` 将栈顶变量存储到局部变量表 slot = 1 的位置。这是代码 return i 对应的指令。这里好像跟上一个例子中的 return 1 表现不一样，上一个例子中，return 1 是将常量压入栈顶，然后返回 1 并结束方法，而这里 return i 将 i 的值压入栈顶后，并没有返回 1 然后结束方法，而是将栈顶变量又存到了局部变量表中，而且和原来局部变量 i 的位置不一样，这里的不一样就是因为 finally，从这里可以看到 finally 将原来 return 的两个指令分成了多个指令。

4：`iinc 0, 1` 就是对局部变量表中 slot = 0 的局部变量，也就是变量 i，自增 1，这对应着 finally 的代码 i++。

7 ~ 8：`iload_1` 将局部变量表中 slot = 1 的局部变量压入栈顶，这里并不是局部变量 i，变量 i 在局部变量表中 slot = 0 的位置，slot = 1 的位置是指令 3 存储的值，也就是 try 中 return 准备返回的值，ireturn 则是以栈顶变量作为返回值并结束方法。

如果不发生异常，方法就到此结束了。剩下的代码就和上面 finally 的例子一样，就不另行分析了。

由此可知，当 return 后还有 finally 代码需要执行，return 拆分成四个指令，前两个指令，将原本需要返回的变量存储为一个局部变量，当执行完 finally 代码后，再由后两个指令，将刚刚存储的局部变量加载到栈顶并返回。所以方法返回值 0。

伪代码如下：

```java
int tmp = returnValue; // return i 在执行 finally 代码前会先将 i 的存为一个临时局部变量
doFinally(); // 执行 finally 块代码
return tmp; // 执行完 finally 后，return i 会取出刚刚存储的局部变量并返回
```

# 4. finally 遇到 return 的另一种情况

再来看 finally 和 return 相遇的另一种情况，finally 中有 return 语句。这同样是一个经典面试题。

```java
public static int func3() {
    try {
        return 1;
    } catch (Exception e) {
        return 2;
    } finally {
        return 3;
    }
}
```

javap 反编译字节码如下：

```java
public static int func3();
	descriptor:()I
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
		stack=1, locals=3, args_size=0
            0: iconst_1
            1: istore_0
            2: iconst_3
            3: ireturn
            4: astore_0
            5: iconst_2
            6: istore_1
            7: iconst_3
            8: ireturn
            9: astore_2
            10: iconst_3
            11: ireturn
        Exception table:
			from	to	target	type
            0		2	4		Class java/lang/Exception
            0		2	9		any
            4		7	9		any
```

0 ~ 1：`iconst_1` 将常量 1 压入操作数栈顶，`istore_0` 将栈顶变量存储到局部变量表 slot = 0 的位置。这就是代码 return 1 在 finally 块执行之前将需要返回的值 0 存为一个局部变量，同时这也印证了上一个例子对 return 的分析。

2 ~ 3：`iconst_3` 将常量 3 压入操作数栈顶，ireturn 返回栈顶的值并结束方法。这就是 finally 块中的代码 return 3，因为这个 return 3 之后没有 finally 代码需要再执行了，所以此处的 return 3 就只有两个指令，同样，这也印证了上上个例子对 return 的分析。

如果没有发生异常，方法就到这里结束，所以返回值 3。由此可知，当 return 后的 finally 中有 return 语句，则第一个 return 只是将返回值存为一个局部变量，而第二个的 return 会结束方法，而且第一个 return 存储的返回值也不会被使用。

这段逻辑用伪代码表示就是这样：

```java
int tmp = returnValue1; // 第一个 return 1 在执行 finally 代码之前将返回值存为一个局部变量
finally... // finally 里的其他代码
return 3; // finally 里最后有一个 return 语句，这个 return 会返回 3 并结束方法，所以前一个 return 的返回值也没有用了
```

# 5. 当 finally 遇到 Throwable 异常和 return

源代码是这样子的，没有 catch、try 块中发生了异常，finally 里有 return 语句。我们知道 Java 中 throw 异常会结束方法，return 也会结束方法，所以这个方法会有返回值吗？会抛出异常吗？

```java
public static int func4() {
    try {
        throw new Exception();
    } finally {
        return 2;
    }
}
```

同样通过字节码来分析：

```java
public static int func4();
	descriptor: ()I
	flags: ACC_PUBLIC, ACC_STATIC
	Code:
    	stack=2, locals=1, args_size=0
			0: new #6 // class java/lang/Exception
			3: dup
			4: invokespecial #10 // Method java/lang/Exception."<init>":()V
			7: athrow
			8: astore_0
			9: iconst_2
			10: ireturn
		Exception table:
			from	to	target	type
			0		9	8		any
```

0 ~ 4：`new`、`dup`、`invokespecial #10` 这三个指令，熟悉字节码指令的人就会知道这是创建 Exception 对象，并将这个异常对象的引用压入操作数栈顶。

7：athrow 抛出操作数栈顶的异常对象。本来程序到这里就应该结束了，结合第二节，有 finally 的代码，编译器会为代码添加 catch 块，并将 finally 的代码复制到 catch 块中，以此确保 finally 一定会被执行。再仔细看方法的字节码，编译器为 func4 生成了一个异常表，所以该方法就相当于下面这样：

```java
public static int func4() {
    try {
        throw new Exception();
    } catch(Throwable t) {
        return 2;
    }
}
```

8：指令 7 抛出了异常，被编译器生成的异常表捕获，并将异常对象放在操作数栈顶，`astore_0` 会将这个异常对象存到局部变量表 slot=0 的位置。

9 ~ 10：`iconst_2`、`ireturn` 返回 int 2，并结束方法。

由此可知，即使没有 catch 块，因为 finally 的存在，编译器也会为 try 添加一个 catch 块，捕获所有类型的异常（Throwable），然后将 finally 代码复制到 catch 块中，以确保 finally 一定被执行。所以这个方法并不会抛出异常，会返回 int 型的 2。

# 6. 总结

1. try catch 是通过**异常表**实现的
2. Java 确保 finally 一定会被执行，是通过复制 finally 代码块到每个分支实现的。
3. 通常 return 会被编译成 2 个指令，当 return 后还有 finally，return 就会被编译成 4 个指令。
4. return 后还有 finally，return 会将返回值存储起来，finally 中并不能改变返回值（当返回值是引用类型是另外一种情况，自行研究下）。
5. return 后的 finally 里有 return，则 finally 里的 return 会结束方法。
6. try 中抛出异常后，finally 里有 return，则方法并不会抛出异常，会正常返回。



最后留一道面试题，func2 返回值 A 的属性 aInt 会是多少？这和上面的 func2 有什么区别呢？

```java
public static A func2() {
    A a = new A();
    a.aInt = 0;
    try {
        return a;
    } catch(Exception e) {
        return a;
    } finally {
        a.aInt = a.aInt + 1;
    }
}

public static class A {
    public int aInt;
}
```

答案：返回的 A 中的 aInt 为 1。

# 参考文档

- [完全解析Java编程中finally语句的执行原理](https://max.book118.com/html/2021/0602/5130043204003234.shtm)
- [字节码层面理解--java中的finally是如何执行的](https://wenku.baidu.com/view/5246e922eb7101f69e3143323968011ca300f778.html)
