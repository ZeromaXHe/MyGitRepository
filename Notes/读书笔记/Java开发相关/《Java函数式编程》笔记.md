# 序言

大多数命令式程序无法被证明是正确的。测试只允许我们在测试失败时证明程序不正确。成功的测试说明不了什么问题。你无法证明发布的程序是不正确的。就单线程程序而言，大量的测试也许能够说明你的代码大部分是正确的。但是对于多线程应用程序，条件组合的数量使测试成为不可能。显然，我们需要另一种不同的方式来编写程序。在理想情况下，这种方法将允许我们证明程序是正确的。因为这一般不是完全可能的，所以一个很好的折中是明确分离程序中可以被证明为正确的部分和不能证明为正确的部分。这就函数式编程技术所能提供的。

可以采用许多种技术来实现这一目标。使用不可变数据虽然不仅限于函数式编程，但却是这样一种技术。如果数据不能更改，你将不会有任何（不良的）意外，数据不会过期或损坏，没有竞争条件，无须锁住并发访问，也不会有死锁的风险。可以毫无风险地共享不可变数据。你不需要生成防御性副本，那就没有了忘记这样做的风险。另一种技术是抽象控制结构，因此你不必冒着混淆循环索引和退出条件的风险一次又一次地编写相同的结构。完全删除使用 null 引用（无论是隐式还是显式）将把你从臭名昭著的 NPE （空指针异常， NullPointerException ）中解放出来。通过所有这些技术（还有更多），你可以确信：如果程序通过编译，那它就是正确的（也就是说，它的实现没有 bug ）。虽然这样做并不能消除所有可能的 bug 但它更加安全。

在 Java 中使用函数式编程技术往往会导致你反对所谓的“最佳实践”。实际上，这些实践中有许多都没有用，有些还确实是非常糟糕的做法。从不捕获错误就是其中之一。 作为 Java 程序员，你可能已经了解到不应该捕获 OOME （内存不足的错误Out Of Memory Error ）或是你无法处理的其他类型错误。 也许你甚至知道不应该捕NPE （空指针异常， NullPointerExceptions ），因为它们表示有 bug ，你应该让应用程序崩溃并修复它。不幸的是， OOME 和 NPE 都不会使应用程序崩溃。它们只会使所在的线程崩渍，并留下处于某种不确定状态的应用程序。即使它们发生在线程中，如果某些非后台线程正在运行，它们也可能无法使应用程序崩憬。当所有的应用程序都是单线程时，这种“最佳实践”是正确的。而现在它是一个非常糟糕的实践。你应该捕获所有的异常，尽管可能不在一个 try... catch 块中。函数式编程的真言是“始终捕获，绝不抛出”。

# 1 什么是函数式编程

并不是所有人都在函数式编程（functional programming，即FP）的定义上达成了共识。一般来说，函数式编程是用函数来编程的一种编程范式。但这个定义并不能解释最重要的一点： 函数式编程和其他编程范式的区别，以及究竟是什么让它（可能）成为编程的更佳方式。在 1990 年出版的 *Why Functional Programming Matters* 一书中， John Hughes 写道：

> 函数式编程中没有赋值语句，因此变量一旦有了值，就不会再改变了。更通俗地说，函数式编程完全没有副作用。除了计算结果，调用函数没有别的作用。这样便消除了 bug 的一个主要来源，也使得执行顺序变得无关紧要一一因为没有能够改变表达式值的副作用，可以在任何时候对它求值。这样便把程序员从处理控制流程的负担中解脱出来。由于能够在任何时候对表达式求佳，所以可以用变量的值来自由替换表达式，反之亦然一一即程序是“引用透明”的。这样的自由度让函数式的程序比它们的一般对手在数学上更易驾驭。

在本章的其余内容中，我会简要地展示引用透明和代换模型的概念，还有函数式编程的其他精华概念。你将会在其他章节中多次应用这些概念。

## 1.1 函数式编程是什么

理解事物是什么与不是什么往往都很重要。如果函数式编程是一种编程范式，那么显然还会有其他不同的编程范式。与一些人预料的可能相反，函数式编程与面向对象编程（OOP）并不是非此即彼。有些函数式编程语言是面向对象的，有些不是。

函数式编程有时被认为是一系列可以补充或替代其他编程范式的技术，例如

- 函数是一等公民
- 匿名函数
- 闭包
- 柯里化
- 惰性求值
- 参数多态
- 代数数据类型

尽管大部分的函数式编程语言确实使用了一些这样的技术，但是对于每一种技术，你也都可以找到函数式编程语言不支持的例子。同样的，非函数式编程语言也会支持一些这样的技术。你会看到在本书中学习这些技术的时候，让程序更加函数化的并非是编程语言，而是你写代码的方式。话虽如此，有些语言会对函数更加友好一些。

与函数式编程相对的应该算是命令式编程范式。在命令式编程的风格里，程序由“做”事情的要素构成。“做”事情意味着一个初始状态、 一个转换过程和一个终止状态。有时这被称为**状态改变**（ state mutation ）。传统的命令式风格的程序通常描述了一系列由条件判断区分的改变。

另一方面，函数式编程由“是”什么的元素组成，而不是“做”什么。a与b的和并不会“造”出一个结果。例如2与3的和，并不会造出5。它就是5。

在求和的例子里，你可以清楚地看到这两个变量被程序破坏掉了。这就是程序除了返回一个结果以外的作用， 因而被称为副作用 。（发生在 Java 方法中的计算还不太一样，因为变量 a 和 b 可能是传进来的值，仅在当前作用域里发生变化，在方法外面并不可见。）

命令式编程和函数式编程的一个最大的不同是，函数式编程没有副作用。这意味着其中

- 没有变量改变。
- 没有打印到控制台或其他设备。
- 没有写入文件、数据库、网络或其他什么。
- 没有抛出异常。

当我说“没有副作用”的时候，我是指没有可观测到的副作用。函数式的程序是由接收参数并返回值的函数复合而成的，仅此而己。你并不关心函数内部发生了什么，因为在理论上，什么都没有发生。但是在实际上，程序是为完全不函数式的计算机而编写的。所有的计算机都基于相同的命令式范式，所以函数就是如下黑盒：

- 接收一个参数（一个单独的参数，一会儿你就会看到）。
- 内部做一些神秘的事情，例如改变变量的值，还有许多命令式风格的东西，但是在外界来看并没有什么作用。
- 返回一个（单独的）值。

这只是理论。实际上，函数不可能完全没有副作用。函数会在某个时候返回一个值，而这个值可能是变化的。这就是一个副作用。它可能会造成一个内存耗尽的错误，或者是堆栈溢出的错误，导致应用程序崩惯，这在某种意义上就是一个可观测到的副作用 。并且它还会造成写内存、寄存器变化、加载线程、上下文切换和其他确实会影响外界观测的这类事情。

所以函数式编程其实是编写非故意的副作用的程序，我的意思是，副作用是程序预期结果的一部分。非故意的副作用也应该越少越好。

## 1.2 编写没有副作用的程序

你可能想知道如何才能编写出既没有副作用又有用的程序。显然这不太可能。函数式编程并非关于编写没有可观测结果的程序。它是关于编写除了返回值以外没有可观测结果的程序。但如果这就是程序能做的全部，那就没有多大的用处。最后，函数式编程需要有可观测的作用，例如把结果显示在屏幕上，写到文件或数据库里，或者通过网络发送出去。与外界的这种交互不会发生在计算过程中，而只会发生在计算完成后。换句话说，将会推迟副作用并单独应用。

以图1.1的加法为例。虽然描述的是命令式的风格，但程序也可能是函数式的，取决于如何实现。想象一下用 Java 实现的以下代码：

~~~java
public static int add(int a, int b) {
    while (b > 0) {
        a++;
        b--;
    }
    return a;
}
~~~

这段程序是彻头彻尾的函数式。它接收一对整型a和b为参，并返回一个值，完全没有其他可观测的作用。它改变了变量，但事实上与需求并不矛盾，因为 Java 的参数是值传递的，所以参数的变化在外界不可见。接下来你就可以选择应用一个作用，例如显示结果或是用结果做其他运算。

请注意，虽然结果可能不正确（在溢出的情况下），但是与没有副作用并不矛盾。如果a和b太大了，程序可能默默地溢出并返回一个错误的结果，但是这仍然是函数式的。另一方面，以下程序就不是函数式的：

~~~java
public static int div(int a, int b){
    return a / b;
}
~~~

虽然这段程序并不改变任何变量，但是当b等于0的时候，它会抛出异常。抛出异常就是一个副作用。与此相反，接下来的实现虽然有一点笨拙，但它却是函数式的：

~~~java
public static int div(int a, int b){
    return (int)(a / (float)b);
}
~~~

即使b为0，这样的实现也不会抛出异常，但是它会返回一个特殊的值。由你自行决定你的函数用返回特殊值来代表除数为零的做法是否可行。（很可能不行！）

无论抛异常是有意为之或是无意的，它终归是一个副作用 。 尽管在命令式编程
里，副作用一般正是我们想要的。最简单的形式可能看起来如下：  

~~~java
public static void add(int a, int b) {
    while(b > 0) {
        a++;
        b--;
    }
    System.out.println(a);
}
~~~

这段程序并不返回值，而是把它打印到了控制台上。这就是期望的副作用。

请注意如下程序，既返回了值又有意加上了副作用：  

~~~java
public static void add(int a, int b) {
    log(String.format("Adding %s and %s", a, b));
    while(b > 0) {
        a++;
        b--;
    }
    log(String.format("Returning %s", a));
    return a;
}
~~~

由于日志的副作用，上面这段代码并不是函数式的。

## 1.3 引用透明如何让程序更安全

没有副作用（所以并不会改变外界的什么）并不足以让程序变成函数式的。同样，函数式编程也不能被外界所影响。换句话说，函数式程序的输出只能取决于自己的参数。这就意味着函数式代码不能从控制台、文件、远程 URL、数据库甚至是系统里读取数据。不被外界所影响的代码就是引用透明的。  

引用透明的代码有一些性质对程序员而言很有意思：

- 它是独立的。它并不依赖于任何外部的设备来工作。你可以在任何上下文中使用它——你需要做的一切就是提供一个有效的参数。
- 它是确定的，意味着相同的参数总是返回相同的结果 。在 引用透明的代码中，不会有意外发生。它可能返回一个错误的结果，可至少结果对于相同的参数而言是绝对不会变化的。
- 它绝对不会抛出任何种类的 Exception。它可能抛出错误，例如 OOME( out-of-memory error ， 即内存耗尽）或是 SOE (stack-overflow error，即堆栈溢出），但是这些错误表示代码有 bug，并不是作为程序员的你或是你 API 的用户应该处理的（除了让应用程序崩溃井最终修复 bug）。
- 任何时候它都不会导致其他代码意外失败。例如，它不会改变参数或是外界的数据 ， 从而导致调用者发现自己的数据过期或者并发访问异常。  
- 它不会由于外部设备（数据库、文件系统或网络）不可用、太慢或坏掉而崩溃 。  

一个引用透明的程序除了获取输入参数和输出结果以外，并不会影响外界。它的结果只是取决于参数。

一个非引用透明的程序可能会从外界读写数据、写日志、改变外界对象、读取键盘输入、输出到屏幕等。结果是不可预测的。

## 1.4 函数式编程的优势

从我刚刚说的那些，你应该可以猜到函数式编程的诸多优势 ：  

- 函数式程序更加易于推断，因为它们是确定性（ deterministic ）的 。 对于一个特定的输入总会给出相同的输出。在许多情况下，你都可以证明程序是正确的，而不是在大量的测试后仍然不确定程序是否会在意外的情况下出错。  
- 函数式程序更加易于测试。因为没有副作用，所以你不需要那些经常用于在测试里隔离程序及外界的 mock。
- 函数式程序更加模块化，因为它们是由只有输入和输出的函数构建的。我们不必处理副作用，不必捕获异常，不必处理上下文变化，不必共享变化的状态，也没有并发的修改。
- 函数式编程让复合和重新复合更加简单。为了编写函数式程序，你需要开始编写各种必要的基础函数，并把它们复合为更高级别的函数，重复这个过程直到你拥有了一个与你打算构建的程序一致的函数。因为所有的函数都是引用透明的，它们无须修改便可以为其他程序所重用。  

函数式的程序天生就是线程安全的，因为它们防止了共享状态的变化。再重复一遍，这并不意味着所有数据都需要不可变 ， 只有共享的数据才需要。但是函数式程序员很快就会认识到不可变的数据总是更安全的，即使在外界观测不到这种变化。  

## 1.5 用代换模型来推断程序

请记住一个函数什么事情都不做。它只是有一值，依赖于参数而已。因此，永远都可以用其值来替换一个函数调用或是任何引用透明的表达式。

当应用函数时，代换模型允许你将任何函数调用替换为它的返回值。思考如下代码：

~~~java
public static void main(String[] args) {
    int x = add(mult(2, 3), mult(4, 5));
}
public static int add(int a, int b) {
    log(String.format("Returning %s as the result of %s + %s", a + b, a, b));
    return a + b;
}
public static int mult(int a, int b) {
    return a * b;
}
public static void log(String m) {
    System.out.println(m);
}
~~~

将mult(2, 3) 和 mult(4, 5) 替换为它们各自的返回值并不会改变程序的含义。

~~~java
int x = add(6, 20);
~~~

相比之下，将调用add函数替换为返回值就改变了程序的含义，因为log方法将不再被调用，从而不会记录任何日志。这可能很重要，可也能不是。总而言之，它改变了程序的结果。

## 1.6 将函数式原则应用于一个简单的例子

作为一个将命令式程序转换为函数式程序的示例，我们将思考一个非常简单的程序：用信用卡购买一个甜甜圈，参见清单1.1

~~~java
public class DonutShop {
    public static Donut buyDonut(CreditCard creditCard) {
        Donut donut = new Donut();
        creditCard.charge(Donut.price);
        return donut;
    }
}
~~~

在这段代码中，信用卡支付是一个副作用。

这种代码的问题在于难以测试。

如果你想在无须接触银行或是mock的情况下测试代码，那就应该移除副作用。由于你仍然想要用信用卡支付，唯一的解决方案就是往返回值里加个什么东西来表示这个操作。你的buyDonut方法将返回甜甜圈和表示支付的这个东西。

你可以使用一个Payment类来表示支付，如清单1.2所示

~~~java
public class Payment {
    public final CreditCard creditCard;
    public final int amount;
    
    public Payment(CreditCard creditCard, int amount) {
        this.creditCard = creditCard;
        this.amount = amount;
    }
}
~~~

这个类包含了表示支付的必要数据，由一张信用卡和支付金额组成。由于buyDonut方法需要返回Donut和Payment两个对象，你需要为此创建一个专门的类，如Purchase：

~~~java
public class Purchase {
    public Donut donut;
    public Payment payment;
    
    public Purchase(Donut donut, Payment payment) {
        this.donut = donut;
        this.payment = payment;
    }
}
~~~

你经常会需要一个类来容纳两个（或以上的）值，因为函数式编程替换副作用的方式就是将其返回。

你可以使用被称为Tuple（元组）的通用类，而不必创建一个特定的Purchase类。这个类将会由两种类型的参数组成（Donut和Payment）。清单1.3展示了它的实现，以及它在DonutShop类里的使用方法。

~~~java
public class Tuple<T, U> {
    public final T _1;
    public final U _2;
    
    public Tuple(T t, U u) {
        this._1 = t;
        this._2 = u;
    }
}

public class DonutShop {
    public static Tuple<Donut, Payment> buyDonut(CreditCard creditCard) {
        Donut donut = new Donut();
        Payment payment = new Payment(creditCard, Donut.price);
        return new Tuple<>(donut, payment);
    }
}
~~~

请注意，你不必顾虑（在这个时候〉如何真正地用信用卡支付，这样可以给你构建程序带来一些自由。你仍然可以接着立即支付 ， 也可以将它保存起来以便后续支付，甚至还可以将一张信用卡里保存的多份待支付记录合并起来，在一个操作里处理完成。这样便可以通过减少调用信用卡服务的次数来节省你的开销。  

清单 1.4 里的 combine 方法允许你合并支付 。请注意 ，如果信用卡不一致，将会抛出异常。这与我说的函数式编程不抛出异常并不矛盾。在这里，试图合并两张不同信用卡的两份待支付记录，被视为一个 bug，所以必须使应用程序崩溃。（这样做并不明智。你要到第 7 章之后才能学到如何用不抛出异常的方式来处理这种状况。）  

~~~java
public class Payment {
    public final CreditCard creditCard;
    public final int amount;
    
    public Payment(CreditCard creditCard, int amount) {
        this.creditCard = creditCard;
        this.amount = amount;
    }
    
    public Payment combine(Payment payment) {
        if (creditCard.equals(payment.creditCard)) {
            return new Payment(creditCard, amount + payment.amount);
        } else {
            throw new IllegalStateException("cards don't match.");
        }
    }
}
~~~

当然，用 combine 方法一次购买多份甜甜圈的效率并不高。在这种情况下，你可以用 buyDonuts (int n , CreditCard creditCard）方法来简单地代替 buyDonut 方法，如清单 1.5 所示。该方法返回一个 `Tuple<List<Donut>, Payment＞`。  

~~~java
import static com.fpinjava.common.List.fill;
import com.fpinjava.common.List;
import com.fpinjava.common.Tuple;

public class DonutShop {
    public static Tuple<Donut, Payment> buyDonut(final CreditCard cCard) {
        return new Tuple<>(new Donut(), new Payment(cCard, Donut.price));
    }
    
    public static Tuple<List<Donut>, Payment> buyDonuts(final int quantity, final CreditCard cCard) {
        return new Tuple<>(fill(quantity, () -> new Donut()), new Payment(cCard, Donut.price * quantity));
    }
}
~~~

请注意 ，这个方法没有用标准的 Java.util.List 类，因为这个类并没有提供你需要的一些函数式方法。在第 3 章中，你将会看到如何函数式地使用 java.util.List 类来编写一个小函数式库。然后在第 5 章 ， 你将会开发一个全新的函数式 List ，也就是这里所用的列表。这个 fill 方法与使用标准 Java 列表 的以下代码有几分相似之处 ：  

~~~java
public static Tuple<List<Donut>, Payment> buyDonuts(final int quantity, final CreditCard cCard) {
    return new Tuple<>(Collections.nCopies(quantity, () -> new Donut()), 
                       new Payment(cCard, Donut.price * quantity));
}
~~~

由于很快将会需要额外的函数式方法 ， 你就别用 Java 的列表了。目前你只需知道 `static List<A> fill(int n , Supplier<A> s)`方法通过一个特殊的对象 `Supplier<A>`创建了包含 n 个实例的一个集合。正如其名所示，一个 `Supplier<A>`是一个对象 ， 当其 get() 方法被调用时能够提供一个 A。用 `Supplier<A>` 代替 A 可以允许惰性求值，你会在后面的章节中学到。当下，你可以认为这是一种直到真正需要时才创建一个 A 的办法。  

现在，你的程序不需要 mock 就可以测试了。例如，以下是一个 buyDonuts 方法的测试：

~~~java
@Test
public void testBuyDonuts() {
    CreditCard creditCard = new CreditCard() ;
    Tuple<List<Donut>, Payment> purchase= DonutShop.buyDonuts(5 , creditCard) ;
    assertEquals(Donut.price * 5 , purchase._2.amount);
    assertEquals(creditCard, purchase._2.creditCard);
}
~~~

让你的程序成为函数式的另外一个好处是它更容易被复合。如果同一个人用的初始代码购买多份，你只能一次次地调用银行（并付账）。通过新的函数式版本，你可以选择是每次购买立即支付还是为同一张信用卡合并支付。  

为了把支付分组，你将需要函数式 List 类的附加方法（现在并不需要知道这些方法是怎么工作的，你将在第 5 章和第 8 章中详细地学习它们）：  

~~~java
public <B> Map<B , List<A> groupBy(Function<A , B> f)
~~~

这个 List 类的实例方法接收一个从 A 到 B 的函数并返回 一个 map，它由键值对组成，其中键的类型为 B，值的类型为 `List<A>`。换句话说，它通过信用卡把支付分组 ：  

~~~java
List<A> values()
~~~

这是 map 的实例方法，返回 map 里所有值的集合：  

~~~java
<B> List<B> map(Function<A , B> f)
~~~

这是 List 的实例方法，接收一个从 A 到 B 的函数井应用于 A 集合里的所有元素，从而得到一个 B 集合 ：  

~~~java
Tuple<List<Al>, List<A2> unzip(Function<A, Tuple<Al, A2 > f)
~~~

这是 List 类的方法，接收一个从 A 到元组的函数 。 例如，可以是一个这样的函数 ：通过电子邮件地址，返回名称和域名组成的元组。在这个例子里的 unzip 方法，可以返回一个名称列表和域名列表组成的元组。  

~~~java
A reduce(Function<A, Function<A, A> f)
~~~

这个 List 的方法用了 一个把列表化简（ reduce ）为单值的操作。这个操作表示为 `Function<A, Function<A, A>> f`。这个记号看起来似乎有点怪异，但是你将在第2章中学习它的含义。例如，它可以是一个加法。在这种情况下，它简单地表示为一个如 f(a, b) = a + b 的函数。

通过这些方法 ， 你现在可以创建出一个通过信用卡把支付分组的全新方法 ， 如清单1.6所示

~~~java
import com.fpinjava.common.List;

public class Payment {
    public final CreditCard creditCard;
    public final int amount;
    
    public Payment(CreditCard creditCard, int amount) {
        this.creditCard = creditCard;
        this.amount = amount;
    }
    
    public Payment combine(Payment payment) {
        if (creditCard.equals(payment.creditCard)) {
            return new Payment(creditCard, amount + payment.amount);
        } else {
            throw new IllegalStateException("Cards don't match.");
        }
    }
    
    public static List<Payment> groupByCard(List<Payment> payments) {
        return payments
            // 将一个 List<Payment> 转换为一个 Map<CreditCard, List<Payment>>，在这个map中每个list都会包含特定信用卡的所有支付
            .groupyBy(x -> x.creditCard)
            // 将 Map<CreditCard, List<Payment>> 转换为一个 List<List<Payment>>
            .values()
            // 将每个 List<Payment> 化简为单值，生成一个最终的 List<Payment>
            .map(x -> x.reduce(c1 -> c2 -> c1.combine(c2)));
    }
}
~~~

请注意，你可以在groupByCard的最后一行使用方法引用，但是我使用了lambda，因为它可能更易读。如果你喜欢方法引用，可以将那行代码替换为下面这行：

~~~java
.map(x -> x.reduce(c1 -> c1::combine));
~~~

在清单1.6里，`c1 ->`后面的部分是一个接收单参并将传给`c1.combine()`的函数。而那其实就是`c1::combine`——一个接收单参的函数。方法引用一般都会比lambda更加易读，但并不绝对。

## 1.7 抽象到极致

如你所见，函数式编程包含了通过复合没有副作用的纯函数来编写代码。这些函数可能表示为方法，也可能是一等公民（first-class）的函数，如上例中的groupBy、map 和 reduce 方法的参数 。一等公民的函数与方法不同，可以由程序来操作 。在大多数情况下，它们被用作其他函数或方法的参数 。 你会在第 2 章中学到这是如何实现的 。  

函数式编程的一个非常重要的部分就是将抽象推到极致 。 在本书的剩余部分，你将会学到如何抽象许多东西，以至于再也不需要定义它们了 。  

# 2 在Java中使用函数

## 2.1 什么是函数

虽然函数的概念在生活中无所不在，但是我们一般都把其当作一个数学上的对象 。 不幸的是，在日常生活中，我们经常混淆了函数和作用（ effect ） 。 更不幸的是，在许多编程语言中我们仍然会犯这个错误。  

### 2.1.1 现实世界里的函数

在现实世界里，函数主要是数学上的概念。它是被称为函数定义域（ function domain ）的源集（ source set ）和被称为函数陪域（也nction codomain ）的目标集（ target set ）之间的关系 。定义域和陪域无须完全不同。例如，一个函数的定义域和陪域可以有相同的整数集。  

**如何让两个集之间的关系成为函数**

为了成为函数，关系需要满足一个条件 ： 定义域内的所有元素都必须在陪域内有且仅有一个对应元素  

这个条件有一些有趣的含义：

- 定义域里不存在在陪域里没有对应值的元素。
- 定义域里的一个元素在陪域里不会有两个对应的元素。
- 陪域里的元素可能在源集里没有相对应的元素。
- 陪域里的元素可能在源集里有多个相对应的元素。
- 在定义域里存在对应元素的陪域元素集被称为函数的像（ image of the function ）。  

**逆函数**

函数未必会有逆函数 (inverse function) 。 如果 f(x) 是一个从 A 到 B(A 为定义域，B 为陪域）的函数，它的逆函数为 $f^{-1}(x)$, B 为定义域而 A 为陪域。如果你用A -> B来表示函数，那逆函数（如果存在的话）就是 B -> A 。  

**偏函数**

没有在定义域中定义所有元素但是满足其他需求（定义域里不存在任何在陪域里有多个元素与之相对应的元素）的关系一般称为偏函数（partial function）。关系 predecessor(x) 在 N（包含 0 的正整数集）上是一个偏函数，但是在 N* （不包含 0 的正整数集）上是一个全函数（ total function ），其陪域为 N 。  

你将会看到把偏函数转换成全函数是函数式编程里的一个重要组成部分 。  

**复合函数**

函数就像积木，可以复合为其他函数。函数f和g的复合函数标记为 $f \circ g$，读作 f round g。 如果 f(x) = x + 2 并且 g(x) = x * 2，可得
$$
f \circ g \ (x) = f(g(x)) = f(x * 2) = (x * 2) + 2
$$
请注意 $f\circ g\ (x)$ 和 $f(g(x))$ 是等价的。但是写成复合函数 f(g(x)) 指出了用x来表示参数的占位符。使用 $f \circ g$ 来表示复合函数的话，可以省略这个占位符。

有意思的是， $f\circ g$ 一般与 $g \circ f$ 不同，虽然它们有时是等价的。

请注意，应用函数的顺序与写函数的顺序正好相反。如果你写 $f \circ g$，首先应用g，然后才是f。标准的Java8函数定义了compose()和andThen() 方法来表示这两个例子（顺便提一句，它们是冗余的，因为f.andThen(g) 与 g.compose(f) 或 $g \circ f$ 等价）

**多参函数**

迄今为止 ， 我们只是讨论了单参函数 。 如果函数有多个参数会如何？简单来说 ，并没有多参函数这回事 。 还记得函数的定义吗？ 一个函数是源集和目标集之间的关系。它并不是多个源集与一个目标集之间的关系。 一个函数不允许有多个参数 。  

但是两个集的乘积本身是一个集，所以这样的函数可能确实有多个参数。  让我们看看下面的函数 ：f(x , y) = x + y  

这似乎是一个 $N \times N$ 与 N 之间的关系，在这种情况下，它是一个函数。但是它只有一个参数，即 $N\times N$的元素。

$N \times N$ 是所有可能的整数对的集。这个集的元素就就是一对整数，更通用的元组（tuple）表示多个元素的组合，而一对整数其实就是元组的一个特例。一对就是持有两个元素的元组。

**函数柯里化**

元组函数可以用另一种方式来思考。可以认为函数f(3,5)是一个从N到N的函数集的函数。所以先前的例子可以这样重写
$$
f(x)(y) = g(y) \\
其中 g(y)=x+y
$$
在这种情况下，可以这样写 `f(x) = g`

它的意思是将函数f应用于参数x，结果是一个新的函数g。将函数g应用于y将会得到：`g(y) = x + y`

这里唯一的新知识就是 f 的陪域现在不是数字集了 ，而是函数集。将 f 应用于一个整数的结果是一个函数 。 将这个新函数应用 于一个整数的结果是一个整数。  

函数 f ( x ) ( y ）是 f ( x , y ）的柯里化形式。对一个元组函数（如果你喜欢可以称为多参函数）应用这种转换就称为柯里化（currying），源于数学家 Haskell Curry （虽然他并非是这种转换的发明者）。  

**偏应用函数**

加法函数的柯里化形式可能看起来不那么自然，而且你可能会疑惑它是否对应着现实世界里的什么 东西。  

现在思考一个接收一对值的新函数：

f (rate, price) = price / 100 * (100 + rate)

这个函数看起来跟以下函数等价 ：

g (price, rate) = price / 100 * (100 + rate)  

现在让我们思考一下这两个函数的柯里化版本：

f (rate) (price)
g (price) (rate)  

f(rate) 是接收一个价格并返回一个价格的函数 。 如果 rate = 9 ，这个函数对一个价格应用 9% 的税，得到一个新价格 。   

另一方面， q (price) 是一个接收税率并返回一个价格的函数 。 如果价格是 100 美元，它的新函数就是对 100 应用一个可变税率。 你会如何命名这个函数呢？如果你想不出来一个有意义的名字，通常就意味着它没有什么用，虽然这取决于我们要解决的实际问题。   

诸如 f(rate) 和 q (price) 这样的函数有时被称为偏应用函数，与 f (rate, price) 和 g (price, rate) 的形式有关。视参数的值而定，偏应用函数可能会有非常庞大的结果 。 我们会在后续章节再回到这个主题 。  

**没有作用的函数**

请记住，纯函数只会返回一个值，不会做任何其他事情 。它不会改变外界（外界是相对函数本身而言）的任何元素，不会改变自己的参数，也不会在出错时爆发（或者抛出异常等）。它可以返回一个异常或者其他的什么东西，例如一个错误消息，但必须将其返回，而不是将其抛出，不是写日志，也不是打印 。  

## 2.2 Java中的函数

在第 1 章中，你用了我称之为函数的东西，但实际上它们是方法 。方法是一种在传统的 Java 里在某种程度上表示函数的方式。  

### 2.2.1 函数式的方法

一个方法可以是函数式的，只要它满足纯函数的要求：  

- 它不能修改函数外的任何东西。外部观测不到内部的任何变化 。
- 它不能修改自己的参数 。
- 它不能抛出错误或异常 。
- 它必须返回一个值 。
- 只要调用它的参数相同，结果也必须相同。  

**对象标记与函数标记**

你己经看到了，实例方法访问类属性可以视为一个外围类实例的隐式参数。可以把不访问外围类实例的方法安全地标记为静态方法。访问外围类实例的那些方法也可以被标记为静态方法，只需显式地标记它们的隐式参数（外围类实例）。  

思考一下第1章的Payment类：

~~~java
public class Payment {
    public final CreditCard cc;
    public final int amount;

    public Payment(CreditCard cc, int amount) {
        this.cc = cc;
        this.amount= amount;
    }
    public Payment combine(Payment other) {
        if (cc.equals(other.cc)) {
            return new Payment(cc, amount + other.amount);
        } else {
            throw new IllegalStateException("Can't combine payments to different cards");
        }
    }
}
~~~

combine方法访问了外围类的cc和amount字段。结果就是它不能成为静态方法。这个方法将外围类视为一个隐式参数。

你可以将其变为显式参数，这样便可以使这个方法成为静态方法 ：  

~~~java
public class Payment {
    public final CreditCard cc;
    public final int amount;

    public Payment(CreditCard cc, int amount) {
        this.cc = cc;
        this.amount= amount;
    }
    public static Payment combine(Payment payment1, Payment payment2) {
        if (payment1.cc.equals(payment2.cc)) {
            return new Payment(payment1.cc, payment1.amount + payment2.amount);
        } else {
            throw new IllegalStateException("Can't combine payments to different cards");
        }
    }
}
~~~

你可以确定静态方法没有对外围作用域进行多余访问，但是它改变了方法的使用方式 。

静态方法可以从类的内部被调用，只需传入 this 引用即可 ：  

~~~java
Payment newPayment = combine (this, otherPayment) ;
~~~

如果从类的外部调用方法，你需要使用类名 ：  

~~~java
Payment newPayment = Payment.combine(paymentl, payment2) ;
~~~

这么做有少许不同，但是如果你需要复合方法调用，它们全都需要改变 。 如果你需要合并多个支付，以下是一个实例方法  

~~~java
public Payment combine(Payment payment) {
    if (this.cc.equals(payment.cc)) {
        return new Payment(this.cc, this.amount + payment.amount);
    } else {
        throw new IllegalStateException("Can't combine payments to different cards");
    }
}
~~~

可以使用对象标记：

~~~java
Payment newPayment = p0.combine(p1).combine(p2).combine(p3);
~~~

它应该比这样要易读得多 ：

~~~java
Payment newPayment = combine(combine(combine (p0, p1), p2), p3);
~~~

在前一个例子里合并更多支付也更简单 。  

### 2.2.2 Java的函数式接口与匿名类

### 2.2.4 多态函数

> **复合函数的问题**
>
> 复合函数是一个非常强大的概念，但是如果用Java来实现，会有一个大隐患。复合几个函数没什么问题。但是思考一下，构建10000个函数并把它们复合成一个。（可以通过折叠来完成，你将在第3章中学习这个操作。）
>
> 在命令式编程里，每个函数都在计算之后才把结果传递给下一个函数当作输入 。 但是在函数式编程里，复合函数意味着无须计算便直接构建结果函数。 复合函数非常强大，因为函数无须计算就可以被复合。 但是结果就是，在大量内嵌的方法调用中应用复合函数最终会导致栈溢出 。   

## 2.3 高级函数特性

你己经看过了如何创建 apply 和 compose 函数，也学过了函数可以表示为方法或对象。可是你还没有回答一个基础 问题 ： 为什么需要函数对象？不能只使用方法吗？在回答这个问题之前，你需要思考一下多参方法表示为函数式的问题。  

### 2.3.1 多参函数怎么样

在 2.1.1 节中 ， 我说过没有多参函数这回事，只有参数为元组的函数 。 元组的基数（ cardinality）可以是任何你所需的东西 。有几种元组拥有自己的特定名称 ： 二元组 (pair)、 三元组 (triplet) 、四元组(quartet)等 。 它们还有其他名称 ， 有些人喜欢称它们为 tuple2 、 tuple3 、tuple4 等。不过我也说过，参数可以一个接一个地应用 ，除了最后一个参数以外 ， 每个参数的应用都会返回 一个全新的函数。  

让我们来定义一个函数，用于对两个整数求和 。 你会把函数应用于第一个参数并返回一个函数。类型如下 ：  

`Function<Integer , Function<Integer , Integer>>`

它似乎有点儿复杂，尤其是当你认为可以这么写的时候 ：  

`Integer -> Integer -> Integer`

请注意，由于结合律，它等价于 

`Integer -> (Integer -> Integer) `

Java 编写函数类型的方式确实有点累赘，但并不复杂 。  

你会发现一行的长度很快就不够用了 ！ Java 不支持类型别名，但是你可以通过继承来达到相同的效果。如果有许多相同类型的函数 ， 你可以用一个更简短的标识来继承 ， 就像下面这样 ：  

~~~java
public interface BinaryOperator extends Function<Integer, Function<Integer, Integer>{}
BinaryOperator add = x - > y - > x + y ;
BinaryOperator mult = x - > y -> x * y;
~~~

参数的数量没有限制，你可以定义接收任意数量参数的函数。正如我在本章的开始部分所说的，你在上面定义的 add 或 mult 函数，等价于接收元组为参数的函数的柯里化形式。  

### 2.3.2 应用柯里化函数

例如，你可以将 add 函数应用于 3 和 5 :

~~~java
System.out.println(add.apply(3).apply(5));
8
~~~

你在此又错过了一些语法糖。如果可以只写函数名和参数就好了。 Scala 就可以这么干 ：

~~~scala
add(3)(5)
~~~

Haskell 更好 ：

~~~haskell
add 3 5
~~~

也许 Java 的未来版本也会支持这样的写法。  

### 2.3.3 高阶函数

这个特殊版本的函数，接收函数为参数并返回函数，被称为高阶函数（ higher-order function ，即 HOF ） 。  

**练习 2.4**

编写一个函数，用于复合在练习 2.2 里用过的 square 和 triple 这两个函数 。

**答案 2.4**

如果你的步骤正确，这个练习还是比较容易的。要做的第一件事就是编写类型。这个函数会有两个参数，所以它将是一个柯里化函数。  

~~~java
Function<Function<Integer, Integer>, 
	Function<Function<Integer, Integer>,
		Function<Integer, Integer>> compose =
			x - > y - > z - > x.apply(y.apply(z));
~~~

你可以在一行内写完代码！让我们用 square 和 triple 函数来测试这段代码：  

~~~java
Function<Integer, Integer> triple = x - > x * 3;
Function<Integer, Integer> square = x - > x * x;
Function<Integer, Integer> f = compose.apply(square).apply(triple) ;
~~~

### 2.3.4 多态高阶函数

**练习 2.5 （难）**

编写一个 compose 函数的多态版本 。

**提示**

你可能会在解答这道题时遇到两个问题 。第一个是 Java 缺少对多态属性的支持 。在 Java 中，你可以创建多态类、接口和方法，但是无法定义多态属性 。 解决办法就是将函数存储在方法、类或接口中，而非存储在属性中。

第二个问题是 Java 并不处理变体（variance）， 所以你可能会发现自己在尝试把 `Function<Integer, Integer>`强制转换为 `Function<Object , Object>` 时发生编译错误。在这种情况下，只能显式地为 Java 指定类型。  

> **变体**
>
> 变体描述了类型参数和子类型之间的行为方式 。 协变（ covariance ）就是当 Red 是 Color 的子类时， `Matcher<Red>`也被当作 `Matcher<Color>`的子类 。在这种情况下， `Matcher<T>`就是对 T 的协变 。 如果反过来，`Matcher<Color>`被当作 `Matcher<Red>`的子类，那么 `Matcher<T>`就是对 T 的逆变（ contravariant ）。在 Java 里，虽然 Integer 是 Object 的子类，但是 `List <Integer>`并不是 `List<Object>` 的子类 。 你可能会觉得奇怪，但是 `List<Integer>`是 一个 Object，而不是一个 `List<Object>`。还有，`Function<Integer, Integer>`并不是 `Function<Object, Object>`。（这个就没那么奇怪了吧！）
>
> 在 Java 里，所有的类型参数的参数都是不可变（ invariant ）的 。

**答案 2.5**

似乎第一步应该把练习 2.4 的例子“泛型化（ generify)" :  

~~~java
<T, U, V> Function<Function<T, U>,
	Function<Function<V, T>,
		Function<V, U>> higherCompose =
			f -> g > x -> f.apply(g.apply(x));
~~~

但它办不到，因为 Java 不允许单独的泛型属性。为了成为泛型 ，必须在定义类型参数的一个作用域里创建一个属性。只有类、接口和方法才能定义类型参数，所以你只能在它们内部定义属性。最现实的就是一个静态方法：  

~~~java
static <T, U, V> Function<Function<T, U>,
	Function<Function<V, T>,
		Function<V, U>> higherCompose() {
			return f -> g -> x -> f.apply(g.apply(x)) ;
       	}
~~~

可能你现在想这样来使用此函数：  

~~~java
Integer x = Function.higherCompose().apply(square).apply(triple).apply(2);
~~~

可惜编译失败。

编译器提示它无法从 T, U 和 V 这些类型参数中推断出真正的类型，所以给这三个都用上了 Object。但是 square 和 triple 函数的类型都是 `Function<Integer, Integer>`。 如果你认为通过这些信息足以推断出 T 、 U 和 V 的类型，那说明你比Java还聪明！请注意 ， higherCompose() 方法没有参数，井总是返回相同的值。它相当于是一个常量。它被定义成为一个方法事实上与这个观点无关。它并不是用于复合函数的方法，它只是一个返回函数的方法，返回的函数将会用于复合函数 。 

Java 试着用另一种办法来解决，将 `Function<Integer, Integer>` 强制转换为 `Function<Object , Object>`。虽然 Integer 是 Object，但是`Function<Integer, Integer>`并不是 `Function<Object, Object>` ， 这两种类型之间没有任何联系，因为 Java 的类型是不可变的。为了让强制转换能够生效 ，类型需要协变 ， 可惜 Java 并不知道变体。  

解决办法是回到原来的问题上，告诉编译器 T 、 U 和 V 的真正类型是什么。可以通过在点和方法名之间插入类型信息来完成：

~~~java
Integer x = Function.<Integer, Integer, Integer>higherCompose().apply( ...
~~~

这多少有些不切实际，但是这并不是主要问题。更多时候，你会把一组像 higherCompose 这样的函数放到一个类库里去 ， 并且通过静态引用（ static import ) 来简化代码 ：  

~~~java
import static com.fpinjava. ... .Function.*;
Integer x =<Integer, Integer, Integer>higherCompose().apply(... ;
~~~

不幸的是，编译失败 ！  

**练习 2.6 （这回容易了！）**

编写用于反向复合函数的 higherAndThen 函数，也就是说 ， higherCompose(f, g) 相当于 higherAndThen(g , f)。

**答案 2.6**

~~~java
public static <T, U, V> Function<Function<T, U>, Function<Function<U, V>, Function<T, V>> higherAndThen() {
	return f -> g - > x -> g.apply(f.apply(x));
}
~~~

> **测试函数参数**
>
> 如果你对参数的顺序有任何疑惑，应该用不同类型的函数来测试这些高阶函数。 测试从 Integer 到 Integer 的函数确实有一些模棱两可，因为从正反两边来复合函数都是可行的，所以不容易发现错误 。 这里有一个使用不同类型函数的测试：  
>
> ~~~java
> public void TestHigherCompose() {
>     Function<Double, Integer> f = a -> (int) (a * 3);
>     Function<Long, Double> g = a -> a + 2.0;
>     
>     assertEquals(Integer.valueOf(9), f.apply((g.apply(1L))));
>     assertEquals(Integer.valueOf(9), Function.<Long, Double, Integer>higherCompose().apply(f).apply(g).apply(1L));
> }
> ~~~
>
> 请注意，Java无法推断类型，所以你需要在调用higherCompose函数时提供类型。

### 2.3.5 使用匿名函数

无须如此编写 ：  

~~~java
Function<Double, Double> f = x - >Math.PI / 2 - x;
Function<Double, Double> sin = Math::sin;
Double cos = Function.compose(f, sin).apply(2.0);
~~~

你可以使用匿名函数：

~~~java
Double cos = Function.compose(x -> Math.PI / 2 - x, Math::sin).apply(2.0);
~~~

你在此使用了 Function 类里定义的静态 compose 方法 。 不过这也适用于高阶函数：  

~~~java
Double cos= Function.<Double, Double, Double>higherCompose().apply(z -> Math.PI / 2 - z).apply(Math::sin).apply(2.0);
~~~

**应该用匿名函数还是命名函数**

除了那些用不了匿名函数的特殊场合外，你可以自行决定是用匿名函数还是命名函数。有一个基本规则 ： 仅使用一次的函数可以被定义为匿名实例。但是只用一次，就意味着你只编写函数一次，并不意味着仅仅实例化一次。  

在以下例子里，定义一个方法来计算 Double 值的余弦。这个方法使用两个匿名函数实现 ， 因为你用了 一个 lambda 表达式和一个方法引用 ：  

~~~java
Double cos (Double arg) {
	return Function.compose(z -> Math.PI / 2 - z, Math::sin).apply(arg);
}
~~~

不必担心创建匿名实例 。 Java 不会在每次调用函数时都创建新的对象。另 外，实例化这样的对象代价很低。相反 ， 你只应该从考虑代码的整洁性和可维护性的角度上决定是使用匿名函数还是命名函数。如果你考虑的是性能与重用性，那就应该尽量使用方法引用 。  

**类型推断**

匿名函数的类型推断也可能是一个问题。在上一个例子里 ， 编译器可以推断出两个匿名函数的类型，是因为它知道 compose 方法接收两个函数为参数 ：  

~~~java
static <T, U, V> Function<V, U> compose (Function<T, U> f , Function<V, T> g)
~~~

但这样并不总能工作 。 如果你把第二个参数从方法引用替换为 lambda ,  

~~~java
Double cos (Double arg) {
	return Function.compose(z -> Math.PI / 2 - z, 
                            a -> Math.sin(a)).apply(arg);
}
~~~

迷茫的编译器就会显示错误消息  

编译器是如此困惑， 甚至还在第 44 列找到了一个根本不存在的错误！而实际上错误应该在第 63 列 。 虽然看起来很奇怪，但是 Java 无法猜出第二个参数的类型。为了让这段代码能够通过编译，你需要加上类型标记：  

~~~java
Double cos (Double arg) {
	return Function.compose(z -> Math.PI / 2 - z, 
                            (Function<Double, Double>)(a) -> Math.sin(a)).apply(arg);
}
~~~

这是使用方法引用的一个绝佳理由 。  

### 2.3.6 局部函数

你方才看到了可以在方法内部定义函数，但是不能在方法内部定义方法 。

另一方面，函数可以用 lambda 的形式完美地定义在函数内部 。 嵌入 lambda 是最常见的例子，如下所示 ：  

~~~java
public <T> Result<T> ifElse (List<Boolean> conditions, List<T> ifTrue) {
    return conditions.zip(ifTrue)
        .flatMap(x -> x.first(y -> y._1))
        .map(x - > x._2);
}
~~~

如果你看不懂这段代码，无须担心 。 你将会在余下的章节中学到这类代码 。 请注意 ， flatMap 方法接收一个函数为参数（以 lambda 的形式），而这个函数（`->`后面的代码）的实现定义了 一个新的 lambda，与局部嵌入函数相对应 。

局部函数并不总是匿名的 。 当作为辅助函数（ helper function）使用时，它们一般都会被命名 。 在传统的 Java 中，使用辅助函数是一个常用的实践 。 这些方法可以让你通过抽象部分代码来简化它 。 相同的技术也可以用于函数，虽然隐式地使用匿名 lambda 可能并不能让你注意到这一点。但是显式地声明局部函数总是可行的，正如以下示例，它基本上等价于上一个示例  

~~~java
public <T> Result<T> ifElse (List<Boolean> conditions, List<T> ifTrue) {
    Function<Tuple<Boolean, T>, Boolean> f1 = y -> y._1;
    Function<List<Tuple<Boolean, T>>, Result<Tuple<Boolean, T>>> f2 = x -> x.first(f1);
    
    Function<Tuple<Boolean, T>, T> f3 = x -> x._2;
    return conditions.zip(ifTrue)
        .flatMap (f2)
        .map(f3);
}
~~~

正如先前所说，这两种形式（即是否使用局部命名函数）有一点不同可能有时候会很重要。当涉及类型推断时，使用命名函数意味着需要显式地指定类型，这样在编译器无法正确推断的时候是非常有必要的 。

它不仅对编译器有用，对那些在类型方面不擅长的程序员来说也是一个莫大的帮助。显式地编写期望的类型有助于定位到与预期不符的地方。  

### 2.3.7 闭包

你己经知道纯函数计算的返回值不应该依赖于参数以外的东西。 Java 方法经常访问类成员，不仅会读取，甚至还会写入。方法也会访问其他类的静态成员。我已经说过，函数式方法是遵守引用透明性的方法，这意味着它们除了返回 一个值以外不会有其他可观测到的作用。函数亦如是。函数只在没有可观测到的副作用时才是纯函数。  

可是如果函数（还有方法）的返回结果不仅依赖于它们的参数，还依赖于外围作用域的元素呢？你己经看过了这样的例子，这些外围作用域里的元素可以被视为函数或方法的隐式参数。  

lambda 还有附加要求： 一个 lambda 访问的局部变量必须是 final 的 。这并不是lambda 的新要求 ， 而是 Java 8 以前的版本对 匿名类的要求，而 lambda 也 需要遵守相同的约定，虽然它并没有那么严格。自 Java 8 起，从匿名类或是 lambda 访问的元素都是隐式 final 的：它们无须被声明为 final 来表明它们是不会被改变的。  让我们来看看这个例子 ：  

~~~java
public void aMethod() {
    double taxRate = 0.09;
    Function<Double, Double> addTax = price -> price * taxRate;
    ...
}
~~~

在本例中，函数 addTax“封闭”了 taxRate 局部变量。只要变量 taxRate 不变 ，就能通过编译，没有必要显式地把变量声明为 final 。

以下示例由于变量 taxRate 不再是隐式的 final 而不能通过编译：  

~~~java
public void aMethod() {
    double taxRate = 0.09;
    Function<Double, Double> addTax = price -> price * taxRate;
    ...
    taxRate = 0.13;
    ...
}
~~~

请注意，这个要求只适用于局部变量。以下代码可以顺利编译 ：  

~~~java
double taxRate = 0.09;

public void aMethod() {
    Function<Double, Double> addTax = price -> price * taxRate;
    taxRate = 0.13;
    ...
}
~~~

在这个例子里有一点很重要 ： addTax 并不是 price 的函数，因为它不会为相同的参数返回相同的结果。然而，它可以被视为一个元组（price, taxRate）的函数。

如果你把它们当作附加的隐式参数，那么闭包与纯函数可相互兼容。然而，它们可能会在重构代码，或是作为参数传递给其他函数时带来问题。这样会导致程序不易读并且不好维护。  

用元组作为函数的参数是让程序更加模块化的一种方式：  

~~~java
double taxRate = 0.09;

Function<Tuple<Double, Double>, Double> addTax = tuple -> tuple._2 + tuple._2 * tuple._1;

System.out.println(addTax.apply(new Tuple<>(taxRate, 12.0)));
~~~

但是使用元组有些笨拙，因为 Java 并没有为此提供一个简单的语法，只是函数的参数里可以用括号而己 。 你只能为元组函数定义一个指定的接口，如下所示：  

~~~java
interface Function2<T, U, V> {
	V apply(T t , U u);
}
~~~

这个接口可以用于 lambda:  

~~~java
Function2<Double, Double, Double> addTax = (taxRate, price) -> price + price * taxRate;
double priceIncludingTax = addTax.apply(0.09, 12.0);
~~~

请注意， Java 中只有 lambda 才是允许你为元组使用（ x , y ）标记的唯一位置。可惜它无法用于其他场合，例如从函数中返回一个元组。  

你也可以用 Java 8 定义的 BiFunction 类，它模拟了接收二元组参数的函数。还有 BinaryOperator，相当于类型相同的二元组参数的函数，还有 DoubleBinaryOperator ，接收的都是 double 原始类型的二元组。所有这些备选都挺好，但如果需要三个或更多的参数，那该怎么办呢？可以定义 Function3 、Function4 ，如此这般。但是柯里化是一个更棒的解决方案。这就是为什么学习使用柯里化非常有必要，而且正如你所见，它非常简单：  

~~~java
double tax = 0.09;

Function<Double, Function<Double, Double> addTax = taxRate -> price -> price + price * taxRate;

System.out.println(addTax.apply(tax).apply(12.00));
~~~

### 2.3.8 部分函数应用和自动柯里化

上一个例子中的闭包和柯里化版本都可以得到相同的结果，可以认为它们等价。可事实上，它们在“语义上”有所不同。正如我所说，这两个参数的作用截然不同。税率并不会经常变化，而价格很可能在每次调用时会变化。在闭包版本中尤其如此。函数封闭了一个不会变化（因为它是 final 的）的参数。在柯里化版本中，两个参数都可能会随每次调用而变化，虽然税率并不会比闭包版本变化更频繁。  

改变税率的需求还是挺常见的，例如当产品类别或运输目的地不同时通常有几种税率。在传统的 Java 中，这是通过把类转换成一个参数化的“税计算器”来实现的  

~~~java
public class TaxComputer {
	private final double rate;
    
    public TaxComputer(double rate) {
		this.rate = rate;
    }
    
	public double compute(double price) {
		return price * rate + price;
    }
}
~~~

这个类允许你为多种税率实例化多个 TaxComputer，并且能够随时重用这些实例

~~~java
TaxComputer tc9 =new TaxComputer(0.09);
double price= tc9.compute(12);
~~~

可以通过部分应用 一个函数来达到同样的效果：  

~~~java
Function<Double, Double> tc9 = addTax.apply(0.09);
double price = tc9.apply(12.0);
~~~

这里的 addTax 是 2.3.7 小节最后的那个函数 。  

你可以看到柯里化和部分应用紧密地联系着。 柯里化包括了把接收元组的函数替换为可以部分应用各个参数的函数 。 这是柯里化函数和元组函数最主要的区别 。使用元组函数，所有的参数都在调用函数之前就计算出来了 。 使用柯里化版本，所有的参数都必须在完全应用函数之前确定，但是每个单独的参数都可以在函数部分应用它之前才计算 。 你不必将函数完全柯里化。一个接收三个参数的函数可以被柯里化为一个生成单参函数的二元组函数 。  

在函数式编程里，柯里化和部分应用函数用得如此频繁，抽象这些操作以允许自动使用便显得非常有帮助 。 在前面的章节中 ， 只用了柯里化函数而非元组函数 。这显示出了 一大优势：部分应用函数绝对非常直观 。  

**练习 2.7 （非常简单）**

编写一个函数式方法来部分应用一个双参柯里化函数的第一个参数 。

**答案 2.7**

你没什么可做的！ 方法的签名如下所示 ：

~~~java
<A, B, C> Function<B, C> partialA(A a, Function<A, Function<B, c> f)
~~~

你立即就能看到部分应用第一个参数与应用第二个参数（ 一个函数）都同样简单 ：  

~~~java
<A, B, C> Function<B, C> partialA(A a, Function<A, Function<B, C> f) {
	return f.apply(a);
}
~~~

（如果你想看一个如何使用 partialA 的示例，请参考随书附带代码中本练习的单元测试。）

你可能注意到原来的函数是 Function<A , Function<B, C＞＞类型，表示 A → B → C 。如果打算部分应用第二个参数将会如何？  

**练习 2.8**

编写一个方法来部分应用一个双参柯里化函数的第二个参数。

**答案 2.8**

有了上一个函数 ， 这个问题的答案就是以下签名的方法 ：  

~~~java
<A, B, C> Function<A, C> partialB(B b, Function<A, Function<B, C> f)
~~~

本练习稍微有点难度，但是如果你仔细思考了类型，那就还算简单。记住，你应该永远信任类型 ！ 不是所有的情况下它们都能立即给你一个方案，但是它们将把你引导至答案。这个函数只有一个可能的实现，所以如果你找到了一个可以成功编译的实现，你就可以确定它是正确的 ！  

你知道你需要返回一个从 A 到 c 的函数。所以你可以开始这样编写实现 ：  

~~~java
<A, B, C> Function<A, C> partialB(B b, Function<A, Function<B, C> f ) {
	return a ->
~~~

这里的 a 是类型 A 的一个变量。在右箭头后面，你需要编写一个由函数 f 和变量 a、b 组成的表达式，并且它的值必须是从 A 到 c 的函数。函数 f 是一个从 A 到 B -> C 的函数。所以你可以从应用 A 开始 ：  

~~~java
<A, B, C> Function<A, C> partialB(B b, Function<A, Function<B, C> f) {
	return a -> f.apply(a)
~~~

这样你就得到了 一个从 B 到 C 的函数 。 你需要一个 c，而你己经拥有了 一个 B, 所以再来一次，答案非常直观：  

~~~java
<A, B, C> Function<A, C> partialB(B b, Function<A, Function<B, C> f) {
	return a -> f.apply(a).apply(b);
}
~~~

就是它了 ！ 其实你只要紧跟类型的步伐就可以了，几乎没有什么要做的。

正如我所说，最重要的事情是你有一个函数的柯里化版本 。 你很可能迅速学会如何直接编写一个柯里化函数 。 刚开始编写 Java 函数式程序时， 一个常见的任务就是把多参方法转换为柯里化函数。这很简单。  

**练习 2.9 （非常简单）**

将以下函数转换为一个柯里化函数 ：  

~~~java
<A, B, C, D> String func (A a, B b, C c, D d) {
	return String.format("%s, %s, %s, %s", a, b, c, d);
}
~~~

（我承认这个方法一点儿用也没有 ， 它就是一个练习而己 。）

**答案 2.9**

除了将逗号替换为右箭头以外 ， 你还是没有什么好做的 。 尽管如此， 谨记你需要把这个函数定义在接受类型参数的作用域里，还不能使用属性。你需要把它和所有需要的类型参数都定义在一个类、 一个接口或一个方法里 。

你会用方法来做。首先 ，编写方法的类型参数 ：  

~~~java
<A, B, C, D>
~~~

接下来，增加返回类型。刚开始似乎很难 ， 但它只是难以阅读。  

~~~java
<A, B, C, D> Function<A, Function<B, Function<C, Function<D , String>>>>
~~~

对于实现来说 ， 列出所需的尽量多的参数，用右箭头将它们分开（最后再加一个箭头） ：  

~~~java
<A, B, C, D> Function<A, Function<B, Function<C, Function<D, String>>>> f () {
	return a -> b -> c -> d ->
}
~~~

最后 ， 增加实现 ， 它和原来的方法是一样的：  

~~~java
<A, B, C, D> Function<A, Function<B, Function<C, Function<D, String>>>> f () {
	return a -> b -> c -> d -> String.format("%s, %s, %s, %s", a, b, c, d);
}
~~~

柯里化一个元组函数也可以用同样的原则 。  

**练习 2.10**

编写一个从 Tuple<A , B＞到 C 的柯里化函数。

**答案 2.10**

你只要再次跟随类型就可以了。你知道方法会接收一个 `Function<Tuple<A, B> , C>`类型为参数并返回 `Function<A, Function<B, C>>`

现在，你需要在实现中返回一个双参的柯里化函数 

最终，你需要对返回类型求值。可以将函数 f 应用于一个用参数 a 和 b 构建的新 Tuple :

~~~java
<A, B, C> Function<A, Function<B, C> curry(Function<Tuple<A, B>, C> f) {
	return a -> b -> f.apply(new Tuple<>(a , b));
}
~~~

只要能够编译就还是不会出错。这种信心就是函数式编程的诸多优势之一 ！ （并不总是这样，你将在下一章学习如何让它更经常发生。）  

### 2.3.9 交换部分应用函数的参数

**练习 2.11**

编写一个方法来交换柯里化函数的参数。

**答案 2.11**

以下方法返回了 一个参数反序的柯里化函数 。 它可以泛化为任何数量和任何顺序的参数：  

~~~java
public static <T, U, V> Function<U, Function<T, V> reverseArgs(Function<T, Function<U , V> f) {
	return u -> t -> f.apply(t).apply(u);
}
~~~

### 2.3.10 递归函数

在诸多函数式编程语言中，递归函数是一项必备功能，虽然递归和函数式编程没有什么关系。有些函数式程序员甚至认为递归是函数式编程的 goto 功能，应该尽量避免使用。然而作为函数式程序员，必须掌握递归，哪怕你最终决定不去使用 。  

如你所知， Java 在递归上的能力有限。方法可以递归地调用自己，但是这也意味着每次递归调用时，计算的状态都被压入战中，直至满足终止条件为止 。 此时所有先前的计算状态都被弹出栈， 一个接一个地被赋值 。栈的大小是可配置的，不过所有的线程都会使用相同的大小。默认的大小取决于 Java 的实现，从 32 位版本的320KB 到 64 位实现的 1064KB ，与存储对象的堆的大小相比，它们实在是微不足道。这样导致的结果就是递归的次数有限。  

确定 Java 能处理多少次递归有些困难，因为它取决于入栈数据的大小，以及在递归处理开始时梭的状态。 一般来说 ， Java 可以处理 5000 到 6000 次递归 。  

由于 Java 内部使用了记忆化（memoization ），因此使得人为挑战这个极限成为可能。这个技术包括将函数或方法的返回结果存放在内存中以便加快未来的访问 。如果先前存放过， Java 无须重新计算便可以直接从内存中获取结果 。 除了加快访问速度，这么做还能更快地找到终止状态，从而在一定程度上避免递归。我们将会在第 4 章再回到这个主题 ， 你将在那里学到如何在 Java 里创建基于堆的递归 。 在本节的剩余部分，暂且认为 Java 的标准递归不会出问题 。  

~~~java
public int factorial(int n) {
	return n == 0 ? 1 : n * factorial(n - 1);
}
~~~

**练习 2.12**

编写一个递归的 factorial 函数。  

**提示**

你不要试图编写一个匿名的递归函数，因为函数若要调用它自己，就必须有一个名字，而且必须在调用自己之前定义好那个名字 。 由于它调用自己时应该己经被定义好了，那就说明在你尝试定义它之前它就应该己经被定义好了！  

**答案 2.12**

暂且放下这个先有鸡还是先有蛋的问题 。 把一个单参方法转换为函数是很直截了当的 。 类型为 `Function<Integer, Integer>` ，实现应该与方法相同：  

~~~java
Function<Integer, Integer> factorial = n -> n <= 1 ? n : n * factorial.apply(n - 1);
~~~

现在是最棘手的部分 。 代码编译出错是因为编译器会抱怨 `Illegal self reference` （非法引用自己）。这是什么意思？简单来说，当编译器读到这段代码时，它正在定义 factorial 函数 。 在这个过程中，它遇到了对 factorial 函数的调用，可它却还未被定义好。  

结果就是，不可能定义一个本地的递归函数 。 但是你能将这个函数声明为成员变量或静态变量吗？这并不能解决引用自己的问题，因为它等价于如下定义一个数字变量：  

~~~java
int x = x + 1;
~~~

这个问题可以通过先声明变量，再改变其值来解决 。 改变值可以在构造函数或者其他方法里实现，但是相比起来在初始化程序（ initializer）里做要方便得多。如下所示 ：  

~~~java
int x;
{
    x = x + 1;
}
~~~

由于在初始化程序执行以前就已经定义好了成员变量，所以这段代码是可以工作的。 一开始，变量会被初始化为默认值（ int 为 0 ，函数为 null ）。变量有时为null 并不算是一个问题，因为初始化程序会在构造函数之前被执行，所以除非其他的初始化程序也用这个变量，否则就是安全的。这个小技巧可以用于定义函数：  

~~~java
public Function<Integer, Integer> factorial;
{
   factorial = n -> n <= 1 ? n : n * factorial.apply(n - 1);
}
~~~

也可以用于定义静态函数：

~~~java
public static Function<Integer, Integer> factorial;
static {
   factorial = n -> n <= 1 ? n : n * factorial.apply(n - 1);
}
~~~

这个小技巧的唯一问题就是宇段无法被声明为 final ，因为函数式程序员偏爱不可变性，所以有点儿讨厌。幸好还有另一个可用于这种场合的小技巧 ：

~~~java
public final Function<Integer, Integer> factorial = n -> n <= 1 ? n : n * this.factorial.apply(n - 1);
~~~

通过在变量名前面增加 this . ，就可以在 final 的同时引用自己。对于 static 的实现来说，只用把 this 替换为类名即可 ：  

~~~java
public static final Function<Integer, Integer> factorial = n -> n <= 1 ? n : n * FunctionExamples.factorial.apply(n - 1);
~~~

### 2.3.11 恒等函数

~~~java
static <T> Function<T, T> identity() {
	return t -> t ;
}
~~~

通过这个附加方法，我们的 Function 接口现在就完整了，如清单 2.2 所示 。  

~~~java
public interface Function<T, U> {
    U apply (T arg);
	default <V> Function<V, U> compose(Function<V, T> f ) {
        return x -> apply(f . apply(x));
    }
	default <V> Function<T, V> andThen(Function<U, V> f) {
		return x -> f.apply(apply(x));
    }
	static <T> Function<T , T> identity () {
		return t -> t ;
    }
	static <T, U, V> Function<V, U> compose(Function<T, U> f, Function<V, T> g) {
		return x -> f.apply(g.apply(x));
    }
	static <T, U, V> Function<T, V> andThen(Function<T, U> f, Function<U, V> g) {
		return x -> g.apply(f.apply(x);
    }
	static <T, U, V> Function<Function<T, U>, Function<Function<U, V>, Function<T, V>> compose() {
		return x -> y -> y.compose(x);
    }
	static <T, U, V> Function<Function<T, U>, Function<Function<V, T>, Function<V, U>> andThen() {
		return x -> y -> y.andThen(x);
    }
	static <T, U, V> Function<Function<T, U>, Function<Function<U, V>, Function<T, V>> higherAndThen() {
		return x -> y -> z -> y.apply(x.apply(z));
    }
	static <T, U, V> Function<Function<U, V>, Function<Function<T, U>, Function<T, V>> higherCompose() {
		return (Function<U, V> x) -> (Function<T, U> y) -> (T z) -> x.apply(y.apply(z));
}
~~~

## 2.4 Java 8的函数式接口

lambda 被用于接收特定接口的地 方， Java 正是以此来决定调用哪个方法的。Java 并不对命名加以限制，有些语 言则不然 。 唯一 的限制是所用的接口必须要明确，这通常意味着它应该有且仅有一个抽象方法。（实际上会更复杂一些，因为有些方法不算在内 。 ）这样的接口就是 SAM（single abstract method ， 单一抽象方法）类型 ，被称为**函数式接口** （functional interface ） 。  

请注意 lambda 井不仅仅用于函数，在标准 Java 8 中可以使用许多函数式接口，虽然它们并不都与函数相关 。 以下是一些比较重要的接口 。  

- java.util.function.Function 与本章开发的 Function 很相似 。 为了让方法更有用，方法的参数中加了一个通配符 。
- java.util.function.Supplier 等价于无参函数。在函数式编程里，就是一个常量，所以一开始你可能会觉得它没那么有用，但是它有两个特定的用途 ： 首先，如果它不是引用透明的（不是一个纯函数），便可以用于提供可变数据，例如时间或者随机数。（ 我们才不用这么不函数式的东西！）第二个用途更有意思，它允许惰性求值 。 我们会在后续的章节中频繁探讨这个主题。
- java.util.function.Consumer 并不是函数，而是作用。（ 这里并不是指副作用。使用 Consumer 的唯一结果就是作用，因为它什么东西也不返回。）
- java.lang.Runnable 也可以用于不接收任何参数的作用 。一般最好为其创建一个指定的接口，因为 Runnabl e 应该用于线程，并且大多数语法检测工具都会在它被挪作他用时向你投诉 。  

Java 定义了许多其他的函数式接口（在 java.util.function 包里有 43 个），对于函数式编程而言大都没有什么用。其中有许多处理原始类型和其他的双参函数，还有用于操作（接收两个类型相同参数的函数〉的特定版本 。  

我并不会在本书中讲解太多标准的 Java 8 函数，我是有意而为之的。本书并不是一本关于 Java 8 的书，而是一本关于函数式编程，正好以 Java 为例的书 。 你要学的是如何构造东西而非使用己经提供的组件。一旦掌握了这些概念，你便可以自行决定是使用自己的函数还是使用标准的 Java 8 函数 。 我们的 Function 与 Java 8 中的 Function 相似 。 为了简化本书所示的代码，它并没有为参数使用通配符 。   另一方面， Java 8 的 Function 也没有定义 compose 和 andThen 这样的高阶函数 ， 它只有方法。除了这些不同以外，这些 Function 实现都是可互换的。  

## 2.5 调试 lambda

lambda 的使用推动了一种写代码的新风格。曾经写成许多小短行的代码现在经常被替换为如下的一行代码 ：  

~~~java
public <T> T ifElse(List<Boolean> conditions, List<T> ifTrue, T ifFalse) {
	return conditions.zip(ifTrue).flatMap(x -> x.first(y -> y._1)).map(x -> x._2).getOrElse(ifFalse);
}
~~~

在 Java 5 到 7 中，这段代码只能用非 lambda 的方式编写，如清单 2.3 所示 。  

~~~java
public <T> T ifElse(List<Boolean> conditions , List<T> ifTrue , T ifFalse) {
    Function<Tuple<Boolean, T>, Boolean> fl = 
    	new Function<Tuple<Boolean, T>, Boolean>() {
    		public Boolean apply(Tuple<Boolean, T> y) {
    			return y._1;
            }
    	};
    Function<List<Tuple<Boolean, T>, Result<Tuple<Boolean, T>> f2 =
    	new Function<List<Tuple<Boolean, T>, Result<Tuple<Boolean, T>> () {
    		public Result<Tuple<Boolean, T> apply(List<Tuple<Boolean, T> x) {
    			return x.first(f1);
    		}
    	};
    Function<Tuple<Boolean, T>, T> f3 =
    	new Function<Tuple<Boolean, T>, T>() {
    		public T apply(Tuple<Boolean , T> x) {
    			return x._2;
    		}
    	};
    Result<List<Tuple<Boolean, T>> temp1 = conditions.zip(ifTrue);
    Result<Tuple<Boolean, T> temp2 = temp1.flatMap(f2);
    Result<T> temp3 = temp2.map(f3) ;
    T result= temp3.getOrElse(ifFalse);
    return result;
}
~~~

显然， lambda 版本更加易读也容易修改。 一般都认为 Java 8 之前的版本复杂得无法令人接受。但是当调试的时候， lambda 的版本问题更多。如果一行相当于原本的 20 行代码，那么如何才能有效地设置断点以找到潜在的错误呢？问题在于井非所有的调试器都强大到可以轻松应付 lambda o 虽然问题总会随时间慢慢被解决，但同时你也需要找出其他的方案。一个简单的方案就是把单行的版本拆分为多行，如下所示 ：  

~~~java
public <T> T ifElse(List<Boolean> conditions, List<T> ifTrue, T ifFalse) {
	return conditions.zip(ifTrue)
        .flatMap(x -> x.first(y -> y._1))
        .map(x -> x._2)
        .getOrElse(ifFalse);
}
~~~

这样你就可以为每一行设置断点。不仅非常实用，而且让代码更易读（还让书的排版更加容易） 。 但是它并不能解决我们的问题，因为每一行仍然有许多传统调试器不能完全理解的内容 。  

为了降低这个问题的严重程度，对每个组件进行全面的单元测试非常重要，这里的组件指的是每个方法，以及作为参数传递给方法的每个函数。这很容易。使用过的方法（按出现的顺序）有 List.zip 、 Option.flatMap 、 List.first 、Option.map 和 Option.getOrElse 。不管这些方法都是做什么的 ， 它们都可以被全面测试。虽然现在你还不太了解它们，但是在后续章节中构建 Option 和 List组件时 ， 还会编写 map 、 flatMap 、 first 和 zip 的实现，还有 getOrElse 方法（以及许多其他方法）。正如你即将看到的那样 ， 这些方法都是纯函数式的 。 它们不能抛出任何异常并且总是返回预期的结果 ， 仅此而己。所以，当完全测试过它们之后，就再也不会有什么坏事发生了。  

先前的例子使用了以下三个函数：  

- x -> x.first
- y -> y._1
- x -> x._2

第一个无法抛出任何异常，因为 x 不能为 null （你将在第 5 章中了解到原因），  井且 first 方法也不会抛出异常 。

第二个和第三个函数无法抛出 NullPointerExcepti on，因为你确定 Tuple 不能通过 null 参数构建 。 （回顾第1章中 Tuple 类的代码 。）

# 3 让Java更加函数式

## 3.1 使标准控制结构具有函数式风格

清单3.1展示了电子邮件地址验证的基本示例。

~~~java
final Pattern emailPattern = Pattern.compile("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$");

void testMail(String email) {
    if (emailPattern.matcher(email).matches()) {
        sendVerificationMail(email);
    } else {
        logError("email" + email + "is invalid.");
    }
}

void sendVerificationEmail(String s){
    // 模拟发送电子邮件
    System.out.println("Verification mail sent to " + s);
}

private static void logError(String s){
    // 模拟记录消息
    System.err.println("Error message logged: " + s);
}
~~~



## 3.2 抽象控制结构

清单 3.1 中的代码是纯命令式风格 。 你永远不会在函数式编程中找到这样的代码。  

为了处理这些问题 ， 首先你要定义一个特殊的组件来处理计算结果 ， 如清单 3.3所示。  

~~~java
public interface Result {
    public class Success implements Result {}
    
	public class Failure implements Result {
		private final String errorMessage;
        
		public Failure(String s) {
			this.errorMessage = s;
        }
		public String getMessage() {
			return errorMessage;
        }
    }
}
~~~

你可以轻松地修改程序，如清单 3.5 所示 。  

~~~java
public class EmailValidation {
	static Pattern emailPattern = Pattern.compile("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$");
    
	static Function<String, Result> emailChecker = s -> 
        s == null
			? new Result.Failure("email must not be null")
			: s.length() == 0
				? new Result.Failure("email must not be empty")
				: emailPattern.matcher(s).matches()
					? new Result.Success()
					: new Result.Failure("email " + s + " is invalid.");
    
	public static void main(String... args) {
        validate("this.is@my.email").exec();
		validate(null).exec();
        validate("").exec();
        validate("john.doe@acme.com").exec();
    }
    
	private static void logError(String s) {
		System.err.println("Error message logged:" + s);
    }
    
	private static void sendVerificationMail(String s) {
		System.out.println("Mail sent to "+ s);
    }
    
	static Executable validate(String s) {
        Result result = emailChecker.apply(s);
        return (result instanceof Result.Success)
            ? () -> sendVerificationMail(s)
            : () -> logError(((Result. Failure) result).getMessage());
    }
}
~~~

你还用三目运算符代替了 if … else 控制结构。这是一个喜好的问题。三目运算符是函数式的，因为它返回一个值并且没有副作用 。相 比之下， if … else 结构可以通过使它只改变局部变量来使其变成函数式，但是它仍然还可能会有副作用。  

### 3.2.1 清理代码

你的 validate 方法现在是函数式的了，但它并不整洁。使用 instanceof 运算符经常是烂代码的代名词。另一个问题是可重用性较低。当 validate 方法返回一个值时，你没有执行与否以外的其他选择 。 如果打算重用验证部分井生成一个不同的作用那该怎么办？

validate 方法不应该依赖于 sendVerificationMail 或 logError 。 它应该只返回一个结果，表示电子邮件是否有效 ， 而你应该能够选择成功或失败所需的作用。也许你可能不希望应用该作用，而是想要复合其他的处理 。  

**练习 3.1 （难）**

尝试将验证逻辑从应用的作用中解祸 。

**提示**

首先，你需要一个单一方法的接口，其方法表示一个作用。其次，由于 emailChecker 函数返回 一 个 Result ，那么 validate 方法可以返回这个 Result 。在这种情况下 ， 你就不再需要 validate 方法了。第三 ，你需要将一个作用“绑定”到 Result 上。但是因为结果可能是成功或是失败，因此最好绑定两个作用并让 Result 类选择应用哪一个。  

**答案 3.1**

首先要做的是创建一个表示作用的接口，如下所示 ：  

~~~java
public interface Effect<T> {
    void apply(T t);
}
~~~

也许你更喜欢用 Java 8 中的 Consumer 接口 。 虽然类名起得不太好，但是做事情都一样。

然后你需要修改 Result 接口  

清单3.6展示了Result类修改后的版本。

~~~java
public interface Result<T> {
    // Effect 由 bind 方法处理
    void bind(Effect<T> success, Effect<String> failure);
    
    public static <T> Result<T> failure(String message) {
        return new Failure<>(message);
    }
    
    public static <T> Result<T> success(T value) {
        return new Success<>(value);
    }
    
    public class Success<T> implements Result<T> {
        private final T value;
        
        private Success(T t) {
            value = t;
        }
        
        @Override
        public void bind(Effect<T> success, Effect<String> failure) {
            success.apply(value);
        }
    }
    
    public class Failure<T> implements Result<T> {
        private final String errorMessage;
        
        private Failure(String s) {
            this.errorMessage = s;
        }
        
        @Override
        public void bind(Effect<T> success, Effect<String> failure) {
            failure.apply(errorMessage);
        }
    }
}
~~~

可以为 bind 方法选择任何你想要的名称。可以称它为 ifSuccess 或者 forEach 。只有类型才重要。  

现在你可以通过使用新的 Effect 和 Result 接口来清理程序，如清单 3.7 所示。  

~~~java
public class EmailValidation {
	static Pattern emailPattern = Pattern.compile("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$");
    
	static Function<String, Result<String>> emailChecker = s -> {
        if (s == null) {
            return new Result.Failure("email must not be null");
        } else if (s.length() == 0) {
            return new Result.Failure("email must not be empty");
        } else if (emailPattern.matcher(s).matches()) {
            return new Result.Success(s);
        } else {
            return new Result.Failure("email " + s + " is invalid.");
        }
    };
    
	public static void main(String... args) {
        emailChecker.apply("this.is@my.email").bind(success, failure);
		emailChecker.apply(null).bind(success, failure);
        emailChecker.apply("").bind(success, failure);
        emailChecker.apply("john.doe@acme.com").bind(success, failure);
    }
    
    static Effect<String> success = s -> System.out.println("Mail sent to "+ s);
    
    static Effect<String> failure = s -> System.err.println("Error message logged:" + s);
}
~~~

### 3.2.2 if … else 的另一种方式

**练习 3.2**

编写一个表示条件的 Case 类和相应的结果 。 条件由 `Supplier<Boolean>`表示，其中 Supplier 是一个函数式接口，如下所示：  

~~~java
interface Supplier<T> {
    T get();
}
~~~

你可以使用 Java 8 或自己的 Supplier 实现。与条件相应的结果由 `Supplier<Result<T>>`表示。为了持有它们，你可以用 一个 `Tuple <Supplier<Boolean> , Supplier<Result<T>>>`。  

Case 类应该定义三个方法：  

~~~java
public static <T> Case<T> mcase (Supplier<Boolean> condition, Supplier<Result<T> value)
public static <T> DefaultCase<T> mcase(Supplier<Result<T> value)
public static <T> Result<T> match(DefaultCase<T> defaultCase, Case<T>... matchers)
~~~

我用了 mcase 作为方法名，因为 case 是 Java 的关键字 ， m 表示匹配（ match ） 。当然，你可以选择任何名称 。  

第一个 mcase 方法定义了一种正常情况，接收一个条件和一个结果 。 第二个 mcase 方法定义了一种默认情况（ default case ），由一个子类表示。第三个 match 方法，选择一种情况。由于这个方法使用了一个变长参数（ vararg ），所以默认情况最先被传入，但却最后才被使用！  

另外， Case 类里应该用以下签名来定义私有的 DefaultCase 子类 ：  

~~~java
private static class DefaultCase<T> extends Case<T>
~~~

**答案 3.2**

我说过，类必须要有一个表示条件的 `Supplier<Boolean>`和一个表示结果的 `Supplier<Result<T>>>`。最简单的方式定义如下 ：  

~~~java
public class Case<T> extends Tuple<Supplier<Boolean>, Supplier<Result<T>>{
    private Case(Supplier<Boolean> booleanSupplier, Supplier<Result<T>> resultSupplier) {
        super(booleanSupplier, resultSupplier);
    }
}
~~~

mcase 方法非常简单。第一个方法接收两个参数并创建一个新实例。第二个方法只接收第二个参数（表示值的 Supplier ），并创建始终返回 true 的 Supplier 作为默认条件 ：  

~~~java
public static <T> Case<T> mcase(Supplier<Boolean> condition, Supplier<Result<T>> value) {
	return new Case<>(condition, value);
}

public static <T> DefaultCase<T> mcase(Supplier<Result<T> value) {
	return new DefaultCase<> ( () -> true , value);
}
~~~

DefaultCase 类简单得不能再简单了。它只是一个标记类 ， 所以你只需创建一个调用 super 的构造函数即可   

~~~java
private static class DefaultCase<T> extends Case<T> {
	private DefaultCase(Supplier<Boolean> booleanSupplier, Supplier<Result<T>> resultSupplier) {
		super(booleanSupplier, resultSupplier) ;
    }
}
~~~

match 方法更加复杂 ， 不过有些言过其实，因为它只有三行代码 ：  

~~~java
@SafeVarargs
public static <T> Result<T> match (DefaultCase<T> defaultCase, Case<T>... matchers) {
	for (Case<T> aCase : matchers) {
		if (aCase._1.get()) return aCase._2.get() ;
    }
	return defaultCase._2.get();
}
~~~

正如我先前所说，由于第二个参数是变长参数，所以默认情况必须排在参数列表的首位，但是直到最后才被使用 。通过逐个调用 get 方法进行计算来测试所有的情况 。如果结果为 true，则在求值之后返回相应的值 。 如果都不匹配，则使用默认情况 。

请注意 ，计算意味着对返回值求值。这次并不会应用任何作用。清单 3.8 展示了完整的类。  

~~~java
public class Case<T> extends Tuple<Supplier<Boolean>, Supplier<Result<T>>> {
    private Case(Supplier<Boolean> booleanSupplier, Supplier<Result<T>> resultSupplier) {
        super(booleanSupplier, resultSupplier);
    }
    
    public static <T> Case<T> mcase(Supplier<Boolean> condition, Supplier<Result<T>> value) {
        return new Case<>(condition, value);
    }

    public static <T> DefaultCase<T> mcase(Supplier<Result<T>> value) {
        return new DefaultCase<> (() -> true , value);
    }
    
    private static class DefaultCase<T> extends Case<T> {
        private DefaultCase(Supplier<Boolean> booleanSupplier, Supplier<Result<T>> resultSupplier) {
            super(booleanSupplier, resultSupplier) ;
        }
    }
    
    @SafeVarargs
    public static <T> Result<T> match (DefaultCase<T> defaultCase, Case<T>... matchers) {
        for (Case<T> aCase : matchers) {
            if (aCase._1.get()) return aCase._2.get() ;
        }
        return defaultCase._2.get();
    }
}
~~~

现在可以大大简化电子邮件验证应用程序的代码了。正如你在清单 3.9 中所见，它绝对没有包含控制结构。（请注意对 Case 和 Result 方法的静态导入。）  

~~~java
import java.util.regex.Pattern;
import static emailvalidation4.Case.*;
import static emailvalidation4.Result.*;

public class EmailValidation {
	static Pattern emailPattern = Pattern.compile("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$");
    
    static Effect<String> success = s -> System.out.println("Mail sent to "+ s);
    
    static Effect<String> failure = s -> System.err.println("Error message logged:" + s);
    
	public static void main(String... args) {
        validate("this.is@my.email").bind(success, failure);
		validate(null).bind(success, failure);
        validate("").bind(success, failure);
        validate("john.doe@acme.com").bind(success, failure);
    }
    
	static Function<String, Result<String>> emailChecker = s -> match(
        mcase(() -> success(s)),
        mcase(() -> s == null, () -> failure("email must not be null")),
        mcase(() -> s.length() == 0, () -> failure("email must not be empty")),
        mcase(() -> !emailPattern.matcher(s).matches(), () -> failure("email " + s + " is invalid."))
    );
}
~~~

可是等等。这是一个障眼法！你看不到任何控制结构是因为它们已经被隐藏在 Case 类中了，它包含了一个 if 指令甚至还有一个 for 循环。所以你是在作弊吗？并非如此。首先，你有一个整洁的循环和一个整洁的 if。不再有那些内嵌的 if 语句。其次，你已经抽象了这些结构。你现在可以编写许多条件应用程序，而无须写上一个 if 或者 for 。但最重要的是，这才是你函数式编程之旅的起点 。在第 5 章 中，你将学习如何完全删除这两个结构。  

## 3.3 抽象迭代

### 3.3.1 使用映射抽象列表操作

~~~java
<T, U> List<U> map(List<T> list, Function<T, U> f) {
    List<U> newList = new ArrayList<>();
    for (T value : list) {
        newList.add(f.apply(value));
    }
    return newList;
}
~~~

### 3.3.2 创建列表

**练习3.3** 

编写方法来创建一个空列表、包含一个元素的列表、包含一个集合里所有元素的列表，以及一个从变长参数列表里创建列表的方法。所有的这些列表都是不可变的。

**答案3.3**

~~~java
public class CollectionUtilities {
    public static <T> List<T> list() {
        return Collections.emptyList();
    }

    public static <T> List<T> list(T t) {
        return Collections.singletonList(t);
    }

    public static <T> List<T> list(List<T> ts) {
        return Collections.unmodifiableList(new ArrayList<>(ts));
    }

    @SafeVarargs
    public static <T> List<T> list(T... t) {
        return Collections.unmodifiableList(Arrays.asList(Arrays.copyOf(t, t.length)));
    }
}
~~~

### 3.3.3 使用 head 和 tail 操作

**练习 3.4**

创建两个方法分别返回列表的头部（head）和尾部（ tail) 。不允许修改作为参数传递的列表。由于你需要创建列表的副本，所以还需要定义一个 copy 方法。tail 返回的列表必须是不可变的。

**答案 3.4**

head() 方法很简单。如果列表为空，则抛出异常。否则，读取索引 0 处的元素并将其返回。

copy 方法也很基本。它与创建列表的方法相同，以一个列表为参数。

tail 方法稍微复杂一些。它必须创建其参数的副本，删除第一个元素，并返回结果：

~~~java
public static <T> T head(List<T> list) {
    if (list.size() == 0) {
        throw new IllegalStateException("head of empty list");
    }
    return list.get(0);
}

private static <T> List<T> copy(List<T> ts) {
    return new ArrayList<>(ts);
}

public static <T> List<T> tail(List<T> list) {
    if (list.size() == 0) {
        throw new IllegalStateException("tail of empty list");
    }
    List<T> workList = copy(list);
    workList.remove(0);
    return Collections.unmodifiableList(workList);
}
~~~

### 3.3.4 函数式地添加列表元素

~~~java
public static <T> List<T> append(List<T> list, T t) {
    List<T> ts = copy(list);
    ts.add(t);
    return Collections.unmodifiableList(ts);
}
~~~

append 方法创建其第一个参数的防御性副本（通过调用先前已经定义好的 copy 方法），向其添加第二个参数，然后返回包装在不可变视图中的己修改列表。你很快就会有机会在无法使用 add 的地方使用这个 append 方法。  

### 3.3.5 化简和折叠列表

列表**折叠**（fold）通过使用一个特定操作来将列表转换为单值。结果可以是任何类型——不必与列表的元素类型相同。折叠的结果类型若是与列表元素相同，则是一种称为**化简**（ reduce）的特殊情况。对整型列表的元素进行求和是化简的一种简单情况。 

折叠操作需要一个起始值，即操作的中性元素或单位元（ identity element ） ， 元素作为**累加器**（ accumulator）的起始值。   

在这种情况下，字符被前置 （prepend ）到字符串上，而非后置（ append ）。第一个折叠称为**左折叠**（ left fold ） ，意味着累加器在操作的左侧。当累加器在右侧时，它是一个**右折叠**（ right fold ）。  

因此 foldLeft 和 foldRight 具有以下关系，其中 operation1 和 operation2 在运算对象相同、顺序相反时得到相同的结果：  

`foldLeft(list, acc, x -> y -> operation1)  `

等价于

`foldRight(reverse(list), acc, y -> x ->operation2)  `

如果操作是可交换的， operation1 和 operation2 就是相同的。否则，如果 operation1 是 `x -> y -> compute (x, y)`，则 operation2 就是 `x -> y -> compute(y, x)`。  

**练习 3.5**

创建一个用于折叠整型列表的方法，例如对列表的元素求和。该方法将接收一个整型列表、一个整型初始值和一个函数为参数。

**答案 3.5**

初始值取决于应用的操作。该值必须是**中性的**，或者说是操作的单位**元**。该操作表示为一个柯里化函数，如你在第2章中所学：

~~~java
public static Integer fold(List<Integer> is, Integer identity, Function<Integer, Function<Integer, Integer>> f) {
    int result = identity;
    for (Integer i : is) {
        result = f.apply(result).apply(i);
    }
    return result;
}
~~~

**练习 3.6**

将fold方法归纳为foldLeft，以便它可以应用左折叠于任意类型的元素列表

**答案 3.6**

命令式的实现相当简单：

~~~java
public static <T, U> U foldLeft(List<T> ts, U identity, Function<U, Function<T, U>> f) {
    U result = identity;
    for (T t : ts) {
        result = f.apply(result).apply(t);
    }
    return result;
}
~~~

**练习 3.7**

编写一个 foldRight 方法的命令式版本。

**答案 3.7**

右折叠是 个递归操作 为了用命令式的循环来实现它，你需要反序处理列表：

~~~java
public static <T, U> U foldRight(List<T> ts, U identity, Function<T, Function<U, U>> f) {
    U result = identity;
    for (int i = ts.size(); i > 0; i--) {
        result = f.apply(ts.get(i - 1)).apply(result);
    }
    return result;
}
~~~

**练习 3.8**

编写 foldRight 的递归版本。注意，一个初始递归的版本并不能在 Java 中工作得天衣无缝，因为它使用栈来累积中间计算。在第 4 章中 ，你将学习如何创建栈安全的递归（ stack-safe recursion ）。

**提示**

你应该将该函数应用于列表的 head 和折叠 tail 的结果。

**答案 3.8**

初始版本至少能处理 5000 个元素，对于练习来说已经足矣：

~~~java
public static <T, U> U foldRight(List<T> ts, U identity, 
                                 Function<T, Function<U, U>> f) {
    return ts.isEmpty() 
        ? identity 
        : f.apply(head(ts)).apply(foldRight(tail(ts), identity, f));
}
~~~

**基于堆的递归** 答案 3.8 并不是尾递归，因此它不适用于以堆替栈的优化。我们将在第5章讨论基于堆的实现。

**反转列表**

反转列表有时挺实用的，但是这个操作的性能不太好。最好能找到其他不需要反转列表的办法，但并不总能找到。

用命令式的实现来定义 reverse 方法很容易通过反向遍历列表实现。但是，你要小心别把索引搞乱：

~~~java
public static <T> List<T> reverse_imperative(List<T> list) {
    List<T> result = new ArrayList<>();
    for (int i = list.size() - 1; i >= 0; i--) {
        result.add(list.get(i));
    }
    return Collections.unmodifiableList(result);
}
~~~

**练习 3.9（难）**

定义不用循环的 reverse 方法。改为用你迄今为止开发过的方法。

**提示**

用到的方法是 foldLeft append 。一开始定义 prepend 方法可能会有用，它按照 append 来定义，往列表的最前面添加一个元素。

**答案 3.9**

你可以先定义一个 prepend 的函数式方法，它允许在列表前添加一个元素。可以通过左折叠列表来完成，用一个包含了待添加元素的累加器而非空列表：

~~~java
public static <T> List<T> prepend(T t, List<T> list) {
    return foldLeft(list, list(t), a -> b -> append(a, b));
}
~~~

然后可以将 reverse 方法定义为左折叠，始于空列表并以 prepend 方法为操作：

~~~java
public static <T> List<T> reverse(List<T> list) {
    return foldLeft(list, list(), x -> y -> prepend(y, x));
}
~~~

完成以后，你可以用对应的实现替换对 prepend 的调用：

~~~java
public static <T> List<T> reverse(List<T> list) {
    return foldLeft(list, list(), x -> y -> 
                    foldLeft(x, list(y), a -> b -> append(a, b)));
}
~~~

**警告** 不要在生产代码中使用答案 3.9 reverse 和 prepend 的实现。它们都悄悄地遍历了整个列表好几次，所以很慢。在第5章中，你将学习如何创建在所有场合都表现良好的函数式不可变列表。

**练习 3.10（难）**

在 3.10 节中，你通过对每个元素应用一个操作定义了一个映射列表的方法。这个操作的实现包括了一个折叠。用 foldLeft 或 foldRight 重写 map 方法。

**提示**

要解决这个问题，应该使用刚定义的 append 或 prepend 方法。

**答案 3.10**

以下是一个使用 append 和 foldLeft 方法的实现：

~~~java
public static <T, U> List<U> mapViaFoldLeft(List<T> list, Function<T, U> f) {
    return foldLeft(list, list(), x -> y -> append(x, f.apply(y)));
}
~~~

以下实现使用 foldRight 和 prepend:

~~~java
public static <T, U> List<U> mapViaFoldRight(List<T> list, Function<T, U> f) {
    return foldRight(list, list(), x -> y -> prepend(f.apply(x), y));
}
~~~

### 3.3.6 复合映射和映射复合

一个更好的办法是复合函数而不是复合映射，或者换句话说，映射复合而不是复合映射

### 3.3.7 对列表应用作用  

### 3.3.8 处理函数式的输出

### 3.3.9 构建反递归列表  

## 3.4 使用正确的类型

# 4 递归、反递归和记忆化

在本章中，你将学习如何将基于栈的函数转换为基于堆的函数 。 因为栈是一块有限的内存区域，所以很有必要这么做。为了让递归函数更加安全，你需要实现让它们使用堆（主存储器区域）以代替有限的栈空间 。 要完全理解这个问题，首先需要了解递归和反递归之间的差异 。  

## 4.1 理解反递归和递归  

反递归从第一步开始，使用每一步的输出作为下一步的输入，以复合计算步骤。递归的操作相同，但它是从最后一步开始。在递归中，你必须延迟赋值，直至遇到基本条件（对应于反递归的第一步）为止。  

### 4.1.1 探讨反递归和递归的加法例子

### 4.1.2 在 Java 中实现递归  

方法调用可能被深度嵌套，而嵌套的深度有一个限制，那就是栈的大小 。 在当前情况下，这个限制大约是几千，并且可以通过配置栈的大小来增加这个限制值 。但是由于所有线程都会使用相同的栈，增加栈的大小通常只是浪费空间 。 默认栈空间从 320 KB 到 1024 KB 不等 ， 具体取决于 Java 版本和所用的系统 。 对于栈使用率最低的 64 位 Java 8 程序来说，嵌套方法调用的最大数量约为 7000。一般来说，除了某些特定情况外，不需要更多 。 递归方法调用就是这么一种特定的情况 。  

### 4.1.3 使用尾调用消除  

为了在方法调用返回之后恢复计算， 一般来说将环境推入枝栈内很有必要，但并不总是如此 。 如果方法调用做的最后一件事是调用某一个方法，当此方法返回时并没有什么可以恢复，所以应该可以直接恢复为当前方法的调用者而不是当前方法自己 。 在尾部位置发生的方法调用，意味着它是返回之前要做的最后一件事，称为**尾调用**（ tail call ） 。 避免将环境推入栈内以在尾调用之后继续方法处理，是称为**尾调用消除**（ tail call elimination, TCE ）的优化技术。不幸的是 ， Java 不用 TCE 。  

尾调用消除有时被称为**尾调用优化**（ tail call optimization, TCO ） 。一般来说 ，TCE 只是一个优化，没有它你也可以过得好好的 。 但是当涉及递归函数调用时，TCE 就不再只是优化了 ，而是一个必备特性。这就是为什么在处理递归时， TCE 这个术语比 TCO 更好。  

### 4.1.4 使用尾递归方法和函数  

大多数函数式编程语言都有 TCE 。 但是 TCE 并不足以应付每一个递归调用 。要成为 TCE 的候选者，递归调用必须是方法所做的最后一件事 。  

### 4.1.5 抽象递归  

问题是 Java 对递归和反递归都用了线程栈，并且其容量有限。通常，栈会在6000 到 7000 步之后溢出。你要做的是创建一个返回未计算步骤的函数或方法。为了表示计算中的一个步骤，你要用一个名为 TailCall 的抽象类（因为你想要表示调用出现在尾部位置的方法）。  

这个 Tail Call 抽象类有两个子类。一个表示中间调用，即暂停某一步的处理以再次调用该方法对下一步求值。它由一个名为 Suspend 的子类表示。它实例化了 `Supplier<TailCall>>`，表示下一个递归调用 。这样的话，不必将所有的TailCall 都放在一个列表中，你可以用把每个尾调用链接到下一个的办法来构造一个链表。这个办法的好处在于链表是一个栈，提供常数级别的插入时间以及对最后插入的元素的常数级访问时间，它是对 LIFO 结构的优化。  

第二个子类表示最后一个调用 ，它应该返回结果，所以称它为 Return 。它不会持有到下一个 TailCall 的链接，因为并没有下一个，但是它将持有结果。  你将得到如下所示的程序 ：  

~~~java
public abstract class TailCall<T> {
    public static class Return<T> extends TailCall<T> {
        private final T t;
        public Return(T t) {
        	this.t = t;
        }
    }
    
    public static class Suspend<T> extends TailCall<T> {
        private final Supplier<TailCall<T> resume ;
        private Suspend(Supplier<TailCall<T> resume) {
        	this.resume = resume;
        }
    }
}
~~~

你需要一些方法来处理这些类： 一个返回结果， 一个返回下一个调用，还有一个决定 TailCall 是 Suspend 还是 Return 的辅助方法。可以不用最后一个方法，但这样你就不得不使用丑陋的 instanceof 来做这件事 。 

Return 并没有实现 resume 方法 ， 并且会抛出运行时异常。你的 API 的用户不应该在同一个情况下调用这个方法，所以如果最后它被调用了，那就是一个 bug, 你要停止应用程序。在 Suspend 类中 ， 这个方法将会返回下一个 TailCall.  

eval 方法返回存储在 Return 类中的结果。在第一个版本中，如果在Suspend 类上调用，它将抛出一个运行时异常 。

isSuspend 方法在 Suspend 中返回 true ，在 Return 中返回 false。清单 4. 1展示了第一个版本。  

~~~java
public abstract class TailCall<T> {
    public abstract TailCall<T> resume();
	public abstract T eval() ;
	public abstract boolean isSuspend() ;
    
    public static class Return<T> extends TailCall<T> {
        private final T t;
        public Return(T t) {
        	this.t = t;
        }
        
        @Override
        public T eval() {
        	return t;
        }
        
        @Override
        public boolean isSuspend() {
	        return false;
        }
        
        @Override
        public TailCall<T> resume() {
        	throw new IllegalStateException("Return has no resume");
        }
    }
    
    public static class Suspend<T> extends TailCall<T> {
        private final Supplier<TailCall<T>> resume ;
        public Suspend(Supplier<TailCall<T>> resume) {
        	this.resume = resume;
        }
        
        @Override
        public T eval() {
        	throw new IllegalStateException("Suspend has no value");
        }
        
        @Override
        public boolean isSuspend() {
	        return true;
        }
        
        @Override
        public TailCall<T> resume() {
        	return resume.get();
        }
    }
}
~~~

为了让递归方法 add 能够用于任意数量的步骤上（在可用的内存限制之内），需要做一些更改。从你原来的方法开始，  

~~~java
static int add(int x, int y) {
	return y == 0
		? x
		: add(++x, --y);
}
~~~

你需要按清单 4.2 中展示的进行修改。  

~~~java
static TailCall<Integer> add(int x, int y) {
    return y == 0
        ? new TailCall.Return<>(x)
        : new TailCall.Suspend<>(() -> add(x + 1, y - 1));
}
~~~

### 4.1.6 为基于栈的递归方法使用一个直接替代品  

在上一节 的开始我曾说过，使用你递归 API 的用户没有机会通过调用 Return 的 resume 或是 Suspend 的 eval 来把 TailCall 实例搞砸。这很容易就能通过将计算代码放在 Suspend 类的 eval 方法中来实现 

~~~java
public static class Suspend<T> extends TailCall<T> {
    ...

    @Override
    public T eval() {
        TailCall<T> tailRec = this;
        while(tailRec.isSuspend()) {
            tailRec = tailRec.resume();
        }
        return tailRec.eval();
    }
}
~~~

你现在可以用更简单井更安全的方式来获取递归调用的结果了：  

~~~java
add(3, 100000000).eval()
~~~

但这不是你想要的，你不想调用 eval 方法。可以通过一个辅助方法来完成：  

~~~java
public static TailCall<Integer> add(int x, int y) {
    return addRec(x, y).eval();
}

private static TailCall<Integer> addRec(int x, int y) {
    return y == 0
        ? ret(x)
        : sus(() -> addRec(x + 1, y - 1));
}
~~~

现在你可以像原来那样调用 add 方法了。可以通过用静态工厂方法实例化Return 和 Suspend 来使你的递归 API 更容易使用，这 也允许你将 Return 和Suspend 内部子类设置为私有类型  

清单 4.3 展示了完整的 Tail Call 类。它增加了一个私有的无参构造函数来防止被其他类继承。  

~~~java
public abstract class TailCall<T> {
    public abstract TailCall<T> resume();
	public abstract T eval() ;
	public abstract boolean isSuspend() ;
    
    private TailCall() {}
    
    private static class Return<T> extends TailCall<T> {
        private final T t;
        public Return(T t) {
        	this.t = t;
        }
        
        @Override
        public T eval() {
        	return t;
        }
        
        @Override
        public boolean isSuspend() {
	        return false;
        }
        
        @Override
        public TailCall<T> resume() {
        	throw new IllegalStateException("Return has no resume");
        }
    }
    
    private static class Suspend<T> extends TailCall<T> {
        private final Supplier<TailCall<T>> resume ;
        private Suspend(Supplier<TailCall<T>> resume) {
        	this.resume = resume;
        }
        
        @Override
        public T eval() {
        	TailCall<T> tailRec = this;
            while(tailRec.isSuspend()) {
                tailRec = tailRec.resume();
            }
            return tailRec.eval();
        }
        
        @Override
        public boolean isSuspend() {
	        return true;
        }
        
        @Override
        public TailCall<T> resume() {
        	return resume.get();
        }
    }
    
    public static <T> Return<T> ret(T t) {
        return new Return<>(t);
    }
    
    public static <T> Suspend<T> sus(Supplier<TailCall<T>> s) {
        return new Suspend<>(s);
    } 
}
~~~

## 4.2 使用递归函数

理论上，如果按照匿名类中的方法来实现函数，创建递归函数不应该比创建递归方法更难。但是 lambda 并没有实现为匿名类中的方法。  

第一个问题是， lambda 在理论上无法递归。但这只是理论。事实上，你在第 2 章学到了绕过这个问题的一个技巧。  

但是，你在此有着与 add 方法相同的问题，必须在结果上调用 eval 。可以使用辅助方法加上递归实现的相同技巧，但你更应该让整件事情能够自包含。在其他语言中 ，例如 Scala，你可以在主函数内部定义局部辅助函数。在 Java 中可以吗？  

### 4.2.1 使用局部定义的函数

在 Java 中不能直接在函数内部定义函数。但是写成 lambda 的 函数是一个类。你能在该类中定义一个局部函数吗？实际上不能。你不能使用静态函数，因为局部类不能拥有静态成员，它们没有名字。你能使用实例函数吗？不能，因为需要一个对 this 的引用。 lambda 和匿名类的区别之一就是 this 引用。在 lambda 中使用的this 引用指向的是外围实例，而非指向匿名类实例。  

解决办法是声明一个包含实例函数的局部类 ，如清单 4.4 所示。  

~~~java
static Function<Integer , Function<Integer , Integer> add = x -> y - > {
	class AddHelper {
		Function<Integer, Function<I nteger , TailCall<Integer>> addHelper = 
            a -> b -> b == 0
				? ret(a)
            	: sus(() -> this.addHelper.apply(x + 1).apply(y - 1));
    }
    return new AddHelper().addHelper.apply(x).apply(y).eval();
};
~~~

### 4.2.2 使函数成为尾递归

先前我说过，由于对列表中元素求和的一个简单的函数式递归方法不是尾递归，因此不能安全地处理它 ：  

~~~java
static Integer sum(List<Integer> list) {
	return list.isEmpty()
		? 0
		: head(list) + sum(tail(list));
}
~~~

你也看到了不得不像下面这样改变方法 ：  

~~~java
static Integer sum(List<Integer> list) {
	return sumTail(list, 0);
}

static Integer sumTail(List<Integer> list , int acc) {
	return list.isEmpty()
		? acc
		: sumTail(tail(list), acc + head(list));
}
~~~

原则很简单，就是有时候难以应用。它包括了使用持有计算结果的累加器。这个累加器被添加到方法的参数中。然后函数被转换为一个辅助方法 ， 由原来的函数传入累加器的初值来调用。重要的是让这个过程更加自然，因为每当你编写一个递归方法或函数时都需要使用。

可以将一个方法变成两个方法。毕竟方法又不会旅行，所以你只需要使主方法公有、辅助方法（真正｛故事的方法）私有即可。对于函数同样如此，因为主函数对辅助函数的调用是一个闭包。局部定义的辅助函数优先于私有辅助方法的主要原因是避免命名冲突。

在允许局部定义函数的语言中 ， 使用一个名称调用所有的辅助函数，是现今的一个实践，例如，go 或 process 。这不能用非局部函数完成（除非你的每个类中只有一个函数〉 。在上面的示例中， sum 的辅助函数被称为 `sumTail` 。 另 一个现今的实践是调用与主函数同名的辅助函数，并加上下画线，如 `sum_`。无论你选择什么体系，最好保持一致。在本书的剩余部分，我将使用下画线来表示尾递归辅助函数。  

### 4.2.3 双递归函数：斐波那契数列示例

要创建可用的斐波那契函数 ， 必须将其更改为用单一的尾递归调用 。还有另外一个问题：结果是如此之大，很快就会算术溢出，以至于得到一个负数 。  

**练习 4.1**

创建一个尾递归版本的斐波那契函数式方法 。

**提示**

正确的解决方案是使用累加器。但是由于有两个递归调用，所以你需要两个累加器。  

**答案 4.1**

让我们先编写辅助方法的签名。它接收两个作为累加器的 Biglnteger 实例，还有一个原来的参数 ， 并返回一个 Biglnteger 

你需要处理终止条件。如果参数为 0，则返回 0  

如果参数为 1 ，则返回两个累加器之和   

最后要处理递归 。你必须执行以下操作：

- 接收累加器 2 ，并使其成为累加器 1 。
- 通过对两个上一步的累加器求和来创建新的累加器 2。
- 把参数减 1。
- 递归调用函数并以这三个计算后的值为参数。  

合并之后的代码如下：

~~~java
private static BigInteger fib_(BigInteger accl, BigInteger acc2, BigInteger x) {
    if (x.equals(Biginteger.ZERO)) {
    	return BigInteger.ZERO ;
    } else if (x.equals(BigInteger.ONE)) {
    	return acc1.add(acc2);
    } else {
    	return fib_(acc2 , acc1.add(acc2), x.subtract(BigIntege.ONE));
    }
}
~~~

最后要做的是创建主方法，它调用这个辅助方法并传入累加器的初始值：  

~~~java
public static BigInteger fib(int x) {
	return fib_(BigInteger.ONE, BigInteger.ZERO, BigInteger.valueOf(x)) ;
}
~~~

无论是计算结果（ 1,045 位数字 ！ 〉还是由于将双递归调用转换为单递归调用所增加的速度，都令人刮目相看 。 但是你仍然不能用这个方法处理 7500 以上的值 。  

**练习 4.2**

将这个方法转换为核安全的递归方法。

**答案 4.2**

这应该很容易。以下代码展示了所需的修改 ：  

~~~java
BigInteger fib(int x) {
	return fib_(BigInteger.ONE, BigInteger.ZERO, BigInteger.valueOf(x).eval()) ;
}

TailCall<BigInteger> fib_(BigInteger accl, BigInteger acc2, BigInteger x) {
    if (x.equals(Biginteger.ZERO)) {
    	return ret(BigInteger.ZERO);
    } else if (x.equals(BigInteger.ONE)) {
    	return ret(acc1.add(acc2));
    } else {
    	return sus(() -> fib_(acc2 , acc1.add(acc2), x.subtract(BigIntege.ONE)));
    }
}
~~~

你现在可以计算 fib (10000 ），然后数一数结果的位数 ！  

### 4.2.4 让列表的方法变成核安全的递归

在第 3 章中，你开发了用于列表的函数式方法。其中的一些方法是简单递归，因而不能用于生产环境。现在到了解决这个问题的时候了。  

**练习 4.3**

创建 foldLeft 方法的战安全递归版本 。

**答案 4.3**

foldLeft 方法的简单递归版本是尾递归：  

~~~java
public static <T , U> U foldLeft(List<T> ts , U identity, Function <U, Function<T, U> f) {
	return ts.isEmpty()
		? identity
		: foldLeft(tail(ts), f.apply(identity).apply(head(ts)), f);
}
~~~

可以很容易地把它转换成完全递归的方法 ：  

~~~java
public static <T, U> U foldLeft(List<T> ts, U identity, Function<U, Function<T, U> f) {
	return foldLeft_(ts, identity, f).eval();
}

private static <T, U> TailCall<U> foldLeft_(List<T> ts, U identity, Function<U, Function<T, U> f) {
	return ts.isEmpty()
		? ret(identity)
		: sus(() -> foldLeft_(tail(ts, f.apply(identity).apply(head(ts)), f));
~~~

**练习 4.4**

创建 range 递归方法的完全递归版本 。

**提示**

注意构造列表的方向（后置或前置〉。

**答案 4.4**

range 方法不是尾递归 ：  

~~~java
public static List<Integer> range(Integer start, Integer end) {
	return end <= start
		? list()
		: prepend(start, range(start + 1, end));
}
~~~

首先需要使用累加器来创建一个尾递归版本。你需要在这里返回一个列表，因此累加器就是一个列表，一开始要传入一个空列表。但是必须以相反的顺序构建列表：  

~~~java
public static List<Integer> range(List<Integer> acc, Integer start, Integer end) {
	return end <= start
		? acc
		: range(append(acc, start), start + 1, end) ;
}
~~~

然后你需要通过使用真正的递归将此方法转换为一个主方法和一个辅助方法：  

~~~java
public static List<Integer> range(Integer start, Integer end) {
	return range_(list(), start, end).eval();
}

private static TailCall<List<Integer>> range_(List<Integer> ace, Integer start, Integer end) {
	return end <= start
		? ret(acc)
		: sus(() -> range(append(ace, start), start + 1 , end));
}
~~~

事实上，你需要的反转操作是非常重要的。知道为什么吗？如果不知道，请尝试下一个练习 。  

**练习 4.5 （难）**

创建 foldRight 方法的枝安全递归版本。

**答案 4.5**

foldRight 方法基于榜的递归版本 ， 如下所示 ：  

~~~java
public static <T, U> U foldRight(List<T> ts, u identity, Function<T, Function<U, U> f) {
	return ts.isEmpty()
		? identity
		: f.apply(head(ts)).apply(foldRight(tail(ts), identity, f));
}
~~~

这个方法不是尾递归，所以我们先来创建一个尾递归版本。你可能会得到这样的结果 ：  

~~~java
public static <T, U> U foldRight(U acc, List<T> ts, U identity, Function<T, Function<U, U> f) {
	return ts.isEmpty()
		? acc
		: foldRight(f.apply(head(ts)).apply(acc), tail(ts), identity, f) ;
}
~~~

不幸的是，这行不通 ！ 知道为什么吗？如果不知道， i青测试该版本并比较标准版本的结果。你可以用上一章 中设计的测试来比较这两个版本：  

~~~java
public static String addIS (Integer i , String s) {
	return "(" + i + " + " + s + ")";
}
    
List<Integer> list = list(1, 2, 3, 4, 5);
System.out.println(foldRight(list, "0", x -> y -> addIS(x, y)));
System.out.println(foldRightTail("0", list, "0", x -> y -> addIS(x, y)));
~~~

你将得到以下结果 ：  

~~~java
(1 + (2 + (3 + (4 + (5 + 0)))))
(5 + (4 + (3 + (2 + (1 + 0)))))
~~~

这表明了列表以相反的顺序处理。 一个简单的办法是在调用辅助方法之前在主方法中反转列表。如果在使方法枝安全和递归时用了这个技巧，你会得到以下结果 ：  

~~~java
public static <T, U> U foldRight(List<T> ts, U identity, Function<T, Function<U, U> f) {
	return foldRight_(identity, reverse(ts), f).eval();
}

private static <T, U> TailCall<U> foldRight_(U acc, List<T> ts, Function<T, Function<U, U> f) {
    return ts.isEmpty()
		? ret(acc)
		: sus(() -> foldRight_(f.apply(head(ts)).apply(acc), tail(ts), identity, f));
}
~~~

在第5章中，你将会通过foldRight实现foldLeft，并通过foldLeft实现foldRight，以此来开发反转列表的流程。因为reverse是一个O(n)操作；由于需要遍历列表，执行它所需的时间与列表中的元素数量成正比，因此foldRight的递归实现性能不会太好。反转列表操作，由于遍历了列表两次而使耗时加倍。结论就是， 当考虑使用 foldRight 时，你应该在以下操作中任选其一 ：  

- 无视性能
- 修改函数（如果可能的话）以使用 foldLeft
- 仅对小列表使用 foldRight
- 使用命令式实现  

## 4.3 复合大量函数