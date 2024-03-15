在 Scala 函数式编程的世界里，因为强调不可变性，所以我们需要尽量减少命令式编程的 while 循环的使用（即在可能的情况下尽量避免**迭代**。Scala 的 for 较为特殊，属于 Filter-Map-Reduce 模式的语法糖，以后有机会单独聊一聊）。

但是这样，熟悉 Java 的朋友们就马上想到一个问题——**栈溢出**。即对于需要循环大量次数的代码，如果换为递归实现，在 Java 中很容易就会导致栈溢出的 OOM 异常。

其原因就在于 Java 虚拟机中，对于执行的递归方法，会在 JVM 栈中保存之前每一级递归调用的方法栈帧。只有当递归走到最后一步时，才会开始一级一级地将栈帧弹出并返回值。那么在前面压栈的过程中，如果递归次数过于多，就会导致栈溢出的问题。

那么为了鼓励函数式编程的写法，Scala 必然需要解决递归栈溢出的问题。Scala 其实也并不能解决所有的递归栈溢出问题，只是针对其中一部分有优化。解决方式就是本文的主题：Scala 编译器针对尾递归的优化。

# 1 尾递归

**尾递归**（tail-recursive）指的就是递归方法里的最后一条指令是递归调用的情况。在 Scala 中，尾递归会被优化成类似 while 循环而不是一系列递归调用，这种方式可以对递归进行优化，从而在整个递归过程中只占用一个栈帧。该过程被称为“**尾部调用优化**（tail call optimization）”或简称 TCO。

考虑如下递归计算整数序列之和的方法：

```scala
def sum(xs: Seq[Int]): BigInt =
	if (xs.isEmpty) 0 else xs.head + sum(xs.tail)
```

该方法无法被优化，因为计算过程的最后一步是加法，而不是递归调用。不过稍微调整变换一下就可以被优化了：

```scala
def sum2(xs: Seq[Int], partial: BigInt): BigInt =
	if (xs.isEmpty) partial else sum2(xs.tail, xs.head + partial)
```

部分和（ partial sum ) 被作为参数传递，用 `sum2(xs, 0)` 的方式调用该方法。由于计算过程的最后一步是递归地调用同一个方法，因此它可以被变换成跳回到方法顶部的循环。Scala 编译器会自动对第二个方法应用“尾递归” 优化。

如果你调用 `sum(1 to 1000000)` 就会得到一个栈溢出错误（至少对于默认栈大小的 JVM 而言如此）；但，`sum2(1 to 1000000, 0)` 将返回序列之和 500000500000。

遗憾的是，JVM 并不能直接支持 TCO，所以 Scala 需要在编译期间采用一些技巧来将尾递归调用编译降级为与迭代相同的字节码。简单来说，那就是原本将使用 invokevirtual 指令调用自身的字节码，转变成了 goto 指令调回代码块头上，这样就避免了把对自身调用压栈。

Scala 还为尾递归编译期的优化提供了一个注解 `@scala.annotation.tailrec`，该注解可以置于打算采用尾递归方式调用的函数上。如果该函数的递归调用并没有发生在一个尾部位置，那么编译器将会产生一个错误。

比较典型的容易误认为可以优化，但其实不能优化的几个情况：

1. 两个不同方法相互在最后一条指令递归调用（后面会提到如何解决）
2. 非 public 方法（为了防止子类把父类的方法覆盖成非尾递归的版本）
3. 递归属于某个 try/catch 块

所以为了保证尾递归一定能在编译期得到优化的话，切记加上 `@scala.annotation.tailrec`。

有人可能会有这样的疑问：既然最终 Scala 编译器会在编译期将尾递归优化成 while 循环，那为什么我们鼓励在 Scala 中使用递归而不是直接使用 while 循环呢？其实这里主要的目的，还是为了更好地方便程序员使用函数式编程的方式书写代码，消除了语言中的可变性来源。一般情况下，递归可以将复杂的问题分解成较小的问题，使推理和解决变得容易。递归也和不变性配合默契，递归函数给我们提供了一种很好的方法来管理改变的状态而不使用可变数据结构或重新赋值变量。因此，引入尾递归优化和鼓励使用递归还是有意义的。（当然，最终选择使用迭代还是递归实现，还是取决于程序员自己和使用场景本身，Scala 只是丰富了选择的余地）

# 2 相互递归

前面提到 Scala 中的尾递归优化是比较受限的，比如两个相互递归的函数，Scala 就没办法直接优化它们。例如：

```scala
def isEven(x: Int): Boolean =
	if (x == 0) true else isOdd(x - 1)

def isOdd(x: Int): Boolean =
	if (x == 0) false else isEven(x - 1)
```

但是，其实在 Scala 中，我们仍然可以通过使用特定方式来重写方法来使得编译器可以优化该相互递归。具体来说，就是 `scala.util.control.TailCalls` 中提供了 `tailcall()` 方法和 `done()` 方法，前者会产生相互递归的调用，而后者供我们在完成递归时调用。这个优化技巧也被称为蹦床（trampoline）。

听起来很玄乎，看上去却很简单。我们可以将上面的代码改成如下：

```scala
def isOddTrampoline(n: Long): TailRec[Boolean] =
	if (n == 0) done(false) else tailcall(isEvenTrampoline(n - 1))

def isEvenTrampoline(n: Long): TailRec[Boolean] =
	if (n == 0) done(true) else tailcall(isOddTrampoline(n - 1))
```

这样处理后，尾递归函数的结果不再是直接返回的，而是被包装在一个 `TailRec` 类型中。为了在最后取得结果，我们可以在最后返回上调用 `result()` 函数：

```scala
println(isEvenTrampoline(100001).result)
```

这样，在处理大型数字时也不会出现栈溢出的错误。



通过阅读源码，我们可以看出，实际上主要被优化了的逻辑是在 `TailRec` 中的  `result()` 方法中。利用 `TailCalls` 的 `tail()` 和 `done()` 方法转换的样本类 `Call` 和 `Done`，将相互调用转换成了可以被编译器优化的尾递归：

```scala
abstract class TailRec[+A] {
  // ...
    
  /** Returns the result of the tailcalling computation.
   */
  @annotation.tailrec final def result: A = this match {
    case Done(a) => a
    case Call(t) => t().result
    case Cont(a, f) => a match {
      case Done(v) => f(v).result
      case Call(t) => t().flatMap(f).result
      case Cont(b, g) => b.flatMap(x => g(x) flatMap f).result
    }
  }
}

/** Performs a tailcall
 *  @param rest  the expression to be evaluated in the tailcall
 *  @return a `TailRec` object representing the expression `rest`
 */
def tailcall[A](rest: => TailRec[A]): TailRec[A] = Call(() => rest)

/** Used to return final result from tailcalling computation
 *  @param  `result` the result value
 *  @return a `TailRec` object representing a computation which immediately
 *          returns `result`
 */
def done[A](result: A): TailRec[A] = Done(result)
```

具体原理，大家可以参考源码自行阅读（上面贴出来的代码没有 `TailRec` 的 `flatMap`、`map` 方法等。其还提供了一个获取是否有下一步递归的方法 `resume`，这里也没有贴出来）。

源码中还提供了一个利用蹦床实现的斐波那契数列示例：

```scala
def fib(n: Int): TailRec[Int] =
  if (n < 2) done(n) else for {
    x <- tailcall(fib(n - 1))
    y <- tailcall(fib(n - 2))
  } yield (x + y)

fib(40).result
```



![GitHub](https://img.shields.io/badge/GitHub-ZeromaXHe-lightgrey?style=flat-square&logo=GitHub)![Gitee](https://img.shields.io/badge/Gitee-zeromax-red?style=flat-square&logo=Gitee)![LeetCodeCN](https://img.shields.io/badge/LeetCodeCN-ZeromaX-orange?style=flat-square&logo=LeetCode)![Weixin](https://img.shields.io/badge/%E5%85%AC%E4%BC%97%E5%8F%B7-ZeromaX%E8%A8%B8%E7%9A%84%E6%97%A5%E5%B8%B8-brightgreen?style=flat-square&logo=WeChat)![Zhihu](https://img.shields.io/badge/%E7%9F%A5%E4%B9%8E-maX%20Zero-blue?style=flat-square&logo=Zhihu)![Bilibili](https://img.shields.io/badge/Bilibili-ZeromaX%E8%A8%B8-lightblue?style=flat-square&logo=Bilibili)![CSDN](https://img.shields.io/badge/CSDN-SquareSquareHe-red?style=flat-square)