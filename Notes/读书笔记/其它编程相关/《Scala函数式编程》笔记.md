# 推荐序1

另一个对我代码品味影响很大的技术是Lua中的协程（coroutine）。Lua的作者Roberto Ierusalimschy把协程称为“单趟延续执行流”（One-shot continuation）。有了协程或延续执行流，程序员可以手动切换执行流，不再需要编写事件回调函数，而可以编写直接命令式风格代码但不阻塞真正的线程。

而在其他不支持协程或者延续执行流的语言中，程序员需要非阻塞或异步编程时，就必须采用层层嵌套回调函数的CPS(Continuation-Passing Style)风格。这种风格在逻辑复杂时，会陷入“回调地狱”（Callback Hell）的陷阱，使得代码很难读懂，维护起来很难。

Scala语言本书并不支持协程或者延续执行流。

# 第一部分 函数式编程介绍

我们以一个激进的前提开始读这本书——限制自己只用纯函数来构造程序，纯函数是没有副作用的，比如读取文件或修改内存时。这种函数式编程的理念，或许非常不同于你以往的编程方式。因此，我们从头开始，重新学习如何用函数式风格来写一些简单的程序。

# 1 什么是函数式编程

函数式编程（FP）基于一个简单又蕴意深远的前提：只用**纯函数**来构造程序——换句话说，函数没有**副作用**（side effects）。什么是副作用？一个带有副作用的函数不仅只是简单地返回一个值，还干了一些其他事情，比如：

- 修改一个变量
- 直接修改数据结构
- 设置一个对象的成员
- 抛出一个异常或以一个错误停止
- 打印到终端或读取用户的输入
- 读取或写入一个文件
- 在屏幕上绘画

函数式编程限制的是**怎样**写程序，而非表达**什么样**的程序。通过本书我们将学习到如何没有副作用地表达我们的程序，包括执行I/O、处理错误、修改数据。我们将学习到为什么遵循函数式编程的规范是极其有益的，因为用纯函数编程更加**模块化**。由于纯函数的模块化特性，它们很容易被测试、复用、并行化、泛化以及推导。此外，纯函数减少了产生bug的可能性。

## 1.1 函数式编程的好处：一个简单的例子

### 1.1.1 一段带有副作用的程序

假设我们要为一家咖啡店的购物编写一段程序，先用一段带有副作用的Scala程序（也称作**不纯的**的程序）来实现。

~~~scala
// 类似于java，关键字class表示一个类，类体用大括号包围起来。
class Cafe { 
    // 关键字def表示一个方法。
    // cc:CreditCard定义了参数名cc和类型CreditCard。
    // 在参数列表之后的Coffee是buyCoffee方法的返回值类型。
    // 等号之后的花括号里的代码块是方法体。
    def buyCoffee(cc: CreditCard): Coffee = { 
        // 不需要分号，语句之间通过换行符来界定。
        val cup = new Coffee()
        // 副作用。信用卡计费。
        cc.charge(cup.price)
        // 我们不需要声明return，因为cup是最后一条语句，会自动return。
        cup
    }
}
~~~

cc.charge(cup.price)这行是一个副作用的例子。信用卡的计费涉及与外部世界的一些交互——假设需要通过web service联系信用卡公司、授权交易、对卡片计费，并且（如果前边执行成功）持久化一些记录以便以后引用。我们的函数只不过返回一杯咖啡，这些其他行为也**额外**（on the side）发生了，因此也被称为“副作用”（我们将在本章后边正式定义副作用）。

副作用导致这段代码很难测试。我们不希望测试逻辑真的去联系信用卡公司并对卡片计费。缺乏可测试性预示着设计的修改：按理说CreditCard不应该知道如何联系信用卡实际执行一次计费，同样也不应该知道怎么把一次计费持久化到内部系统。我们可以让CreditCard忽略掉这些事情，通过传递一个Payments对象给buyCoffee函数，使代码更加模块化和可测化。

~~~scala
class Cafe {
    def buyCoffee(cc: CreditCard, p:Payments): Coffee = {
        val cup = new Coffee()
        p.charge(cc, cup.price)
        cup
    }
}
~~~

虽然当我们调用p.charge(cc, cup.price)的时候仍然有副作用发生，但至少恢复了一些可测试性。Payments可以是一个接口，我们可以写一个适合于测试的mock实现这个接口。但这也不够理想，即便用一个具体类可能更好，我们也不得不让Payments成为一个接口，否则，任何mock都很难被使用。举个例子，在调用完buyCoffee之后或许我们要检测一些内部状态，我们的测试不得不保证这些状态在调用charge后已经被适当修改。虽然可以使用一个mock框架或相似的东西来为我们处理这些细节，但这样有些小题大做了，我们只不过想测试一下buyCoffee产生的计费是否等于这杯咖啡的价格而已。

撇开对测试的担心，这里还有另一个问题：buyCoffee方法很难被复用。假设一个叫Alice的顾客，要订购12杯咖啡。最理想的情况是只要复用这个方法，通过循环来调用12次buyCoffee。但是基于当前的程序，会陷入12次对支付系统的调用，对Alice的信用卡执行12次计费！

### 1.1.2 函数式的解法：去除副作用

函数式的解法是消除副作用，通过让buyCoffee方法在返回咖啡（Coffee）的时候把费用（Charge）也作为值一并返回。计费的处理包括发送到信用卡公司、持久化这条记录等，这些过程将在其他地方来做。下面是这段函数式解法的大致样子（先别太注重Scala的语法，下一章会详细讲解）：

~~~scala
class Cafe {
    // buyCoffee方法返回一对儿包含Coffee和Charge的值，使用类型(Coffee, Charge)来表示。这里不涉及支付相关的任何处理。
    def buyCoffee(cc:CreditCard) : (Coffee, Charge) = {
        val cup = new Coffee()
        // 用小括号创建一个cup和Charge的数据“对”，之间用逗号间隔。
        (cup, Charge(cc, cup.price))
    }
}
~~~

我们把费用的创建过程跟它的执行过程分离。buyCoffee函数现在的返回值里除了Coffee还有一个费用的值。我们很快就会看到如何更方便地在一个事务里复用这个函数来买多杯咖啡。不过先看看“Charge”怎么定义？我们所构造的这个数据类型由信用卡（CreditCard）和金额（amount）组成，并提供了一个combine函数，以便对同一张信用卡合并费用：

~~~scala
// case类只有一个主构造器，构造参数紧跟着类名后边（这里类名是Charge）。
// 这个列表中参数都是public的、不可修改的，访问时使用面向对象的方式，中间用点来标注，如other.cc。
case class Charge(cc:CreditCard, amount:Double) {
    def combine(other:Charge): Charge = 
    	// if表达式跟java里的语法一样，但它也会返回其中一个分支结果的值。
    	// 如果 cc == other.cc，那么combine将返回Charge(..);
    	// 否则在else分支会抛出异常。
    	if (cc == other.cc) 
    		// case类可以不通过new关键字创建。
    		// 我们只需要在类名后面传递一组参数到主构造器。
    		Charge(cc, amount + other.amount)
    	else
    		// 抛出异常的语法也和Java或其他语言相似。
    		// 我们在后续章节会讨论更多用函数式来处理错误条件的方法。
    		throw new Exception("Can't combine charges to different cards")
}
~~~

现在我们来看看buyCoffees方法如何实现购买n杯咖啡。与之前不同，现在可以利用buyCoffee方法实现，这正是我们所希望的。

~~~scala
class Cafe {
    def buyCoffee(cc:CreditCard): (Coffee, Charge) = ...
    // List[Coffee]是一个承载Coffee的不可变的单向链表。
    // 我们将在第3章讨论数据类型的更多细节。
    def buyCoffees(cc:CreditCard, n:Int): (List[Coffee], Charge) = {
        // List.fill(n)(x)创建一个对x复制n份的列表。
        // 我们将在后续章节解释这个有趣的函数调用语法。
        val purchases: List[(Coffee, Charge)] = List.fill(n)(buyCoffee(cc))
        // unzip将数值对儿列表，分成一对儿（pair）列表。
        // 这里我们用一行代码对这个pair解构成2个值（coffee列表和charge列表）
        // charges.reduce对整个charge列表规约成一个charge，每次使用combine来组合两个charge。
        // reduce是一个高阶函数的例子，我们将在下一章做适当的介绍。
        val (coffees, charges) = purchases.unzip(coffees, charges.reduce((c1, c2) => c1.combine(c2)))
    }
}
~~~

总体上看，这个解决方案有显著的改善，现在我们可以直接复用buyCoffee来定义buyCoffee函数，这两个函数都很简单并容易测试，不需要实现一些Payments接口来进行复杂的mock！事实上，Cafe现在完全忽略了计费是如何处理的。当然我们可以用一个Payments类来做付款处理，但Cafe并不需要了解它。

让Charge成为一等（first-class）值，还有一些我们没有预期到的好处：我们能更容易地组装业务逻辑。因为Charge是一等值，我们可以用下面的函数把同一张信用卡的费用合并为一个List[Charge]:

~~~scala
def coalesce(charges: List[Charge]): List[Charge] = 
	charges.groupBy(_.cc).values.map(_.reduce(_ combine _)).toList
~~~

我们像传值一样传递函数给groupBy、map和reduce方法。在接下来的几章，你将学会读和写类似这样的一行程序。`_.cc` 和`_ combine _`是匿名函数的语法，在后边的章节会讲到。

> **现实世界是如何的？**
>
> 对函数式程序员而言，程序的实现，应该有一个纯的内核和一层很薄的外围来处理副作用。
>
> 但即便如此，某些时候我们不得不面对现实情况产生的副作用，并通过一些外部系统提交费用处理。通过本书，我们将发现很多看似必须存在副作用的程序都有对应的函数式实现。如果不存在对应的函数式实现，我们会找到一种方式构造代码让副作用发生但不可见（例如，可以在一些函数体里声明局部变量，或者当没有外围函数可以观察到这种情况时，写入一个文件）。

## 1.2 （纯）函数究竟是什么

我们之前说过函数式编程意味着使用纯函数，纯函数是没有副作用的。纯函数更容易推理。

换言之，一个函数在程序的执行过程中除了根据输入参数给出运算结果之外没有其他的影响，就可以说是没有副作用的。我们有时更加明确地把这一类函数称为“纯函数”，但这有点多余，除非我们额外声明，否则函数就是指那些没有副作用的。

我们可以使用**引用透明**（referential transparency）的概念对纯函数进行形式化。这不仅仅是函数的属性，而且是一般表达式的属性。

这意味着任何程序中符合引用透明的表达式都可以由它的结果所取代，而不改变该程序的含义。当调用一个函数时传入的参数是引用透明的，并且函数调用也是引用透明的，那么这个函数是一个纯函数。

> **引用透明与纯粹度**
>
> 对于程序p，如果它包含的表达式e满足引用透明，所有的e都可以替换为它的运算结果而不会改变程序p的含义。假设存在一个函数f，若表达式f(x)对所有引用透明的表达式x也是引用透明的，那么这个f是一个纯函数。

## 1.3 引用透明、纯粹度以及替代模型

引用透明要求函数不论进行了任何操作都可以用它的返回值（value）来代替。这种限制使得推导一个程序的求值（evaluation）变得简单而自然，我们称之为**代替模型**（substitution model）。如果表达式是引用透明的，可以想象计算过程就像在解代数方程。展开表达式的每一部分，使用指示对象替代变量，然后归约到最简单的形式。在这一过程中，每一项都被等价值所替代，计算的过程就是被一个又一个**等价值**（equal）所替代的过程。换句话说，引用透明使得程序具备了**等式推理**（equational reasoning）的能力。

替代模型则很容易推理，因为对运算的影响纯粹是局部的（只对那些赋值表达式产生影响），不需要先在内心模拟一系列状态的更新才理解这一段代码。只需要理解**局部的推理**(local reasoning)，不必费心地跟踪函数执行前后的状态变化，只用简单地看一下函数的定义，把它替换成一个参数。即使没有用过“替代模型”这一名词，你也一定用过这种方式来推理程序。

对纯粹度的概念进行形式化，有助于我们深入了解函数式编程为什么更加模块化。模块化程序是由组件组成的，这些组件又是可理解、可复用，并独立于整体存在的。整体程序只取决于组件和它们组成的规则，也就是说它们是可组合的（composable）。纯函数是模块化的、可组合的

# 2 在Scala中使用函数式编程

## 2.1 Scala语言介绍：一个例子

~~~scala
// 一行注释
/* 另一行注释 */
/** 文档说明 */
object MyModule {
    // abs方法接收一个integer并返回一个integer
    def abs(n: Int): Int = 
    	// 如果n小于0，返回-n
    	if (n < 0) -n
    	else n
    
    // 一个私有方法只能被MyModule里的其他成员调用
    private def formatAbs(x: Int) = {
        // 字符串里有2个的占位符，%d代表数字
        val msg = "The absolute value of %d is %d"
        // 在字符串里将两个%d占位符分别替换为x和abs(x)。
        msg.format(x, abs(x))
    }
    
    // Unit类似于Java或C语言里的void
    def main(args: Array[String]): Unit = 
    	println(formatAbs(-42))
}
~~~

我们声明了一个名为MyModule的单例对象（也称为模块）。只是简单地封装一段代码，随后可以通过名字来引用。Scala代码必须放在一个单例对象（object）或一个类（class）中，出于简单，这里使用一个单例对象，把代码放在花括号间。

> **object关键字**
>
> object关键字创建一个新的单例类型，就像一个class只有一个被命名的实例。如果你熟悉Java，在Scala中声明一个object有些像创建了一个匿名类的实例。Scala没有等同于Java中static关键字的概念，object在Scala中经常用到，就像你在Java中用一个带有静态成员的class一样。

formatAbs方法是另一个纯函数

这个方法定义为private，意味着无法在MyModule对象之外调用。它接收一个Int类型，返回一个String。注意返回值类型没有声明，因为Scala有能力推断一个方法的返回值类型，所以我们省略了，但是通常考虑到与他人协作和保持良好的代码风格，最好还是显示地声明返回值类型。

代码块地第一行声明使用val关键字定义了一个字符串，命名为msg。只是简单地给一个名字以便引用。val表示不可变变量，所以formatAbs方法体中msg会一直引用同一个字符串值。如果你在方法体中将msg重新赋值了一个值，编译器将会报错。

记住，一个方法只是简单地返回它右手边的值。所以不必需要return 关键字。这个例子中右手边是一个代码块。在Scala中，一段包含在大括号里的多行声明（multistatement）代码块的值等于它最后一个表达式的返回值。因此，formatAbs方法的值就是msg。format(x, abs(x))的返回值。

最后，main方法是一个调用纯函数内核的外壳，并打印结果到终端。有时我们称这样的方法为“过程”（或非纯函数）而非函数，以突出它们是带有副作用的。

以main命名的方法是一个特殊方法。当程序运行时Scala会查找以main命名的特定签名的方法。它接收一个字符串数组作为参数，返回值类型是Unit。

参数数组包含了从命令行传递过来的参数，我们在这里并没有使用。

Unit与C或Java编程语言中的void有相似的目的。在Scala中只要没有引起程序崩溃或挂住，每个方法都会返回值。但main方法的返回值没有任何意义。它是一个特殊的类型Unit，该类型只有唯一的值，文法上写为()，一对小括号，发音为“unit”。通常返回Unit类型的方法暗示它包含副作用。

main方法体把调用formatAbs返回的结果字符串打印到终端，注意println方法的返回值是Unit，也正是main方法需要返回值的类型。

## 2.2 运行程序

Scala解释器——REPL（read-evaluate-print loop）。

也可以在REPL中复制粘贴一段代码。它甚至有一个专为粘贴多行代码设计的粘贴模式（以:paste命令开启）。

## 2.3 模块、对象和命名空间

为了引用abs方法，我们必须用MyModule.abs的方式，因为abs定义在MyModule对象中。MyModule可以说是它的命名空间。抛开技术层面的细节，Scala中的每一个值都可以当成一个**对象**（object）（出于讨论的目的，像Int这样的基础类型的值也被认为是对象，不同于Java），每个对象都有零个或多个成员。对象的主要目的是给成员一个命名空间，有时我们也称为**模块**。一个成员可以是一个以def关键字声明的方法，或另一个以val或object声明的对象。对象还可以有其他类型的成员，我们现在先忽略。

注意，即使2+1这样的表达式也是调用对象成员。这里是对对象2调用其+方法成员。它是表达式2.+(1)的语法糖，把1传给对象2的+方法。Scala没有**操作符**（operator）的概念。+在Scala里是一个方法。若方法只包含一个参数，可以使用中缀方法来调用，即省略了点和小括号。比如MyModule.abs(42)可以写为MyModule abs 42，结果是一样的，用哪种方式都行。

可以将一个对象的成员导入到当前作用域，这样就可以不受约束地使用它们：

~~~scala
import MyModule.abs
~~~

也可以使用下划线语法来导入一个对象的所有成员（非私有）：

~~~java
import MyModule._
~~~

## 2.4 高阶函数：把函数传给函数

现在掌握了Scala的一些基础语法，我们将继续学习一些函数编程基础。你需要了解的第一个新概念：**函数也是值**，就像其他类型的值，比如整型、字符串、列表；函数也可以赋值给一个变量、存储在一个数据结构里、像参数一样传递给另一个函数。

把一个函数当作参数传递给另一个函数在纯函数式编程里很有用，它被称为**高阶函数**（higher-order function，缩写为HOF）。接下来将通过一些例子来阐明。

### 2.4.1 迂回做法：使用循环方式

首先，我们来写一个阶乘：

~~~scala
def factorial(n: Int): Int = {
    // 一个内部函数，或局部定义函数。
    // 在Scala中把一个函数定义在另一个函数体内很常见。
    // 在函数式编程中，我们不应该认为它跟一个局部整数或局部的字符串有什么不同。
    def go(n: Int, acc: Int): Int = 
    	if (n <= 0) acc
    	else go(n-1, n*acc)
    
    go(n, 1)
}
~~~

想不通过修改一个循环变量而实现循环功能，可以借助递归函数。我们在阶乘函数体内部定义了一个辅助的递归函数。这种辅助函数习惯上被称为go或loop。在Scala中函数可以定义在任何代码块中，包括在另一个函数内部。就像一个局部变量，go函数只能被factorial函数内部引用。fatcorial函数的定义最终不过只是以循环的初始条件不断地调用go。

传给go的参数是循环的状态。在这个例子中包含n和一个当前阶乘的累计值acc。为进行下一次迭代，只需用新的循环状态递归调用go函数（这里是go(n-1, n*acc)），要退出循环，返回一个不继续进行调用的值（这个例子中是 n<=0）。Scala会检测到这种**自递归**（self-recursion），只要递归调用发生在尾部（tail position），编译器优化成类似while循环的字节码（我们可以在Scala里手动写while循环，但非得这样做的情况很少，这是一种不好的方式，因为对于更好的组合风格来说它是一种阻碍）。可以参考注释里关于这种技术的细节。基本思路是当递归调用后没有其他额外调用时，会应用这种优化（称为**尾调用消除**）。

> **Scala的尾调用**
>
> 我们说的尾调用是指调用者在一个递归调用之后不做其他事，只是返回这个调用结果。比如之前讨论的递归调用`go(n-1, n*acc)`，它是一个尾调用，因为它没有做其他事情，直接返回了这个递归调用的结果。另一种情况：`1 + go(n-1, n*acc)`，这里go不再是尾部，因为这个方法的结果还要参与其他运算（即结果还要再与1相加）。
>
> 如果递归调用是在一个函数的尾部位置，Scala会自动把递归编译为循环迭代，这样不会每次都进行栈的操作。默认情况下Scala不会告诉你尾调用是否消除成功，可以通过tailrec注释来告诉编译器，如果编译不能消除尾部调用会给出编译错误。语法如下：
>
> ~~~scala
> def factorial(n: Int): Int = {
>     @annotation.tailrec
>     def go(n:Int, acc: Int): Int = 
>     	if (n <= 0) acc
>     	else go(n-1, n*acc)
>     go(n, 1)
> }
> ~~~
>
> 关于注释（annotation）我们在这本书里不想谈论太多，不过@annotation.tailrec注释将会被我们广泛应用。

### 2.4.2 第一个高阶函数

现在我们已经有了阶乘函数，让我们编辑一下之前的程序把它也引入进去。

~~~scala
object MyModule {
    ... // 这里是abs和factorial的定义。
    private def formatAbs(x: Int) = {
        val msg = "The absolute value of %d is %d."
        msg.format(x, abs(x))
    }
    
    private def formatFactorial(n: Int) = {
        val msg = "The factorial of %d is %d."
        msg.format(n, factorial(n))
    }
    
    def main(args: Array[String]): Unit = {
        println(formatAbs(-42))
        println(formatFactorial(7))
    }
}
~~~

formatAbs和formatFactorial这两个函数几乎是相同的，可以将它们泛化为一个formatResult函数，它接收一个函数参数。

~~~scala
def formatResult(name: String, n: Int, f: Int => Int) = {
    val msg = "The %s of %d is %d."
    msg.format(name, n, f(n))
}
~~~

formatResult是一个高阶函数（HOF），它接收一个函数f为参数。我们给f参数声明一个类型，就像其他参数那样，它的类型是 Int => Int（读作 int to int或int 箭头 int），表示f接收一个整型参数并返回一个整型结果。

abs函数与这个类型匹配，它接收Int并返回Int。同样，factorial也与这个类型匹配。因此我们可以把abs或factorial当参数传给formatResult

> **变量命名约定**
>
> 对于高阶函数的参数，以f、g或h来命名是一种习惯做法。在函数式编程中，我们倾向于使用短的变量名，甚至单个字母命名。因为高阶函数的参数通常没法表示参数到底执行什么，无法体现它们的含义。许多函数式程序员觉得短名称让代码更易读，因为代码结构第一眼看上去更简单。

## 2.5 多态函数：基于类型的抽象

目前我们定义的函数都是**单态的**（monomorphic）：函数只操作一种数据类型，比如abs和factorial的指定参数类型是Int。高阶函数formatResult也是固定的操作Int=>Int类型的函数。通常，特别是在写高阶函数时，希望写出的这段代码能够适用于任何类型，它们被称为“**多态函数**”。这里先介绍一下它的概念，在本章的后边会有更多的应用。

### 2.5.1 一个多态函数的例子

我们经常是先注意到若干个单态函数有相似的结构，才发现应该用一个多态函数来解决问题。比如，下面的单态函数findFirst返回数组里第一个匹配到key的索引，或在匹配不到的情况下返回-1。它是从一个字符串数组里查找一个字符串的特例。

~~~scala
def findFirst(ss: Array[String], key: String): Int = {
    @annotation.tailrec
    def loop(n: Int): Int = 
    	// 如果n到了数组的结尾，返回-1，表示这个key在数组里不存在。
    	if (n >= ss.length) -1
    	// ss(n)抽取数组ss里的第n个元素。
    	// 如果第n个元素等于key返回n，表示这个元素出现在数组的索引。
    	else if (ss(n) == key) n 
    	// 否则，传入n加1，继续查找
    	else loop(n + 1)
    // 从数组的第一个元素开始启动loop
    loop(0)
}
~~~

这段代码的细节不是我们关注的重点，重要的是不管是从Array[String]中查找一个String，还是从Array[Int]中查找一个Int，或从任何Array[A]中查找一个A，它们看起来几乎都是相同的。我们可以写一个更泛化的适用任何类型A的findFirst函数，它接收一个函数参数，用来对A进行判定。

~~~scala
// 用类型A做参数替代掉String类型的硬编码，并且用一个对数组里每个元素进行测试的函数替代掉之前用于判断元素是否与给定key相等的硬编码。
def findFirst[A](as: Array[A], p: A => Boolean): Int = {
    @annotation.tailrec
    def loop(n: Int): Int = 
    	if (n >= ss.length) -1
    	// 如果函数p匹配当前元素，就找到了相匹配的元素，返回数组当前索引值。
    	else if (p(as(n)) n 
    	else loop(n + 1)

    loop(0)
}
~~~

这是一个多态函数的例子，有时也称作“**泛型函数**”。我们对数组和用于查找的函数，**基于类型**进行了抽象化。要写一个多态函数，我们引入了一种使用逗号分隔的类型参数（type parameter）。紧跟在函数名称后使用中括号括起来（这里是单个类型参数[A]）。可以给类型参数起任何名字，不过习惯上通常用短的、单个大写的字母来命名类型参数，比如[A, B, C]。

在类型参数列表中引入的**类型变量**，可在其他类型签名中引用（类似于参数列表中的参数变量可在函数体中引用）。在findFirst函数中类型变量A被两个地方引用：一处是数组元素要求是类型A（声明为Array[A]），另一处是函数P必须接收类型A（声明为A=>Boolean）。这两处类型签名中引用相同的类型变量，意味着它们的类型必须相同。当我们调用findFirst时编译器会强制检测，如果在Array[Int]中查找一个String，可能会造成类型匹配错误。

### 2.5.2 对高阶函数传入匿名函数

在使用高阶函数时，不必非要提供一些有名函数，可以传入**匿名函数**或**函数字面量**。这一点很方便，举例来说，我们可以在REPL中用下面的方式测试findFirst函数：

~~~scala
scala> findFirst(Array(7,9,13), (x: Int) => x == 9)
res2: Int = 1
~~~

这里有一些新语法，表达式Array(7, 9, 13)是一段“数组字面量”，它用3个整数构造一个数组。注意构造数组时并没有使用new关键字。

语法`(x: Int) => x == 9`是一段“函数字面量”或“匿名函数”。不必先定义一个有名称的方法，可以利用语法的便利，在调用时再定义。这个特定的函数接收一个Int类型参数x，并返回一个Boolean类型的值，表示x是否等于9。

通常函数的参数声明在=>箭头的左边，可以在箭头右边的函数体内使用它们。比如写一个比较两个整数是否相等的函数：

~~~scala
scala> (x: Int, y: Int) => x == y
res3: (Int, Int) => Boolean = <function2>
~~~

在REPL结果中的`<function2>`符号表示res3是一个接收2个参数的函数。如果Scala可以从上下文推断输入参数的类型，函数参数可以省略掉类型符号。例如，(x, y) => x < y。

> **在Scala中函数也是值**
>
> 当我们定义一个函数字面量的时候，实际上定义了一个包含一个apply方法的Scala对象。Scala对这个方法名有特别的规则，一个有apply方法的对象可以把它当成方法一样调用。我们定义一个函数字面量(a, b) => a < b，它其实是一段创建函数对象的语法糖：
>
> ~~~scala
> val lessThan = new Function2[Int, Int, Boolean] {
>     def apply(a: Int, b: Int) = a < b
> }
> ~~~
>
> lessThan的类型是Function2[Int, Int, Boolean]，通常写成(Int, Int) => Boolean。注意Function2接口（在Scala中是trait）包含一个apply方法，当我们以lessThan(10, 20)的方式调用函数lessThan时它实际是对apply调用的语法糖：
>
> ~~~scala
> scala> val b = lessThan.apply(10, 20)
> b: Boolean = true
> ~~~
>
> Function2 只是一个由Scala标准库提供的普通的特质（接口），代表接收两个参数的函数对象。同样在标准库里还提供了Function1、Function3等其他函数对象，接收的参数个数从名称里能看出来。因为这些函数在Scala中就是普通对象，所以它们也是一等值。通常我们说“函数”这个名词时是指一等函数对象还是一个方法，取决于上下文。

## 2.6 通过类型来实现多态

或许在前面写isSorted函数时你已注意到实现一个多态函数时，各种可能的实现方式明显减少了。针对某种类型A的多态函数，唯一可以对A进行操作的方式是传入一个函数参数（或按照给出的操作来定义一个函数）。在某些例子里你会发现对一个多态类型的实现可能被限制为只有一种实现方式。

我们看一个例子，这个函数签名表示它只有一种实现方式。它是执行“部分应用”的高阶函数。函数partial1接收一个值和一个带有两个参数的函数，并返回一个带有一个参数的函数。**部分应用**（partial application）这个名词，表示函数被应用的参数不是它所需要的完整的参数：

~~~scala
def partial1[A, B, C](a: A, f: (A, B) => C): B => C
~~~

函数partial1有三个类型参数：A、B和C。它带有两个参数，参数f本身是一个有两个类型分别为A和B的参数、返回值为C的函数。函数partial1的返回值也是一个函数，类型为B=>C。

~~~scala
def partial1[A, B, C](a: A, f: (A, B) => C): B => C = 
	(b: B) => f(a, b)
~~~

完成！结果是一个高阶函数接收一个带有两个参数的函数，进行部分应用。即我们有一个A和一个需要A和B产生C的函数，可以得到一个只需要B就可以产生C的函数（因为我们已经有A了）。

**练习2.3**

我们看另一个柯里化（currying）的例子，把带有两个参数的函数f转换为只有一个参数的部分应用函数f。这里只有实现可编译通过。

~~~scala
def curry[A,B,C](f: (A, B) => C): A => (B => C)
~~~

**练习2.4**

实现反柯里化（uncurry），与柯里化正相反。注意，因为右箭头=>是右结合的，A => (B => C) 可以写为 A => B => C。

~~~scala
def uncurry[A,B,C](f: A => B => C): (A, B) => C
~~~

看最后一个例子——函数组合，也就是把一个函数的输出结果当作输入提供给另一个函数。实现这个函数完全取决于它的类型签名。

**练习2.5**

实现一个高阶函数，可以组合两个函数为一个函数。

~~~scala
def compose[A,B,C](f: B => C, g: A => B): A => C
~~~

这是一个常见的行为，所以Scala标准库中的Function1（带有一个参数的函数接口）提供了Compose方法。要对函数f和g进行组合，只需要简单地写成 f compose g。同时还提供了andThen方法，f andThen g 等价于 g compose f：

~~~scala
scala> val f = (x: Double) => math.Pi / 2 - x
f: Double => Double = <function1>

scala> val cos = f andThen math.sin
cos: Double => Double = <function1>
~~~

对于像这样小的一行程序，还不算困难，但对于真实世界中的大型代码呢？在函数式编程中，被证明是一样的。多态高阶函数的适用范围极其广泛，因为它们不是面向特定领域，而是对发生在很多上下文里的通用模式的抽象。正因为这样，编写大型程序与编写小型程序时的“味道”非常相似。本书将会写很多这种广泛适用的函数。本章给出的练习尝试说服你在写这一类函数时应该采取这种风格。

# 3 函数式数据结构

我们在引言里提到函数式编程不会更新变量，或修改可变的数据结构。这会导致一个紧迫的问题：在函数式编程中可以用哪种数据结构？怎么在Scala中定义和操作它们？在这一章，我们将学习并应用**函数式数据结构**的概念，借用这个机会介绍在函数式编程中如何定义数据类型，了解与之相关的“**模式匹配**”，并练习编写或泛化一些纯函数。

## 3.1 定义函数式数据结构

函数式数据结构，只能被纯函数操作。记住，纯函数一定不能修改原始数据或产生副作用。**因此，函数式数据结构被定义为不可变的**。

这是否意味着我们要对数据做很多额外的复制？或许会让你吃惊，答案是否定的。首先让我们先检验一下或许是最普遍存在的函数式数据结构：单向链表。这里定义在本质上与Scala标准库中的List数据类型相同，这段代码所引入的新语法和概念我们会通过细节来讨论。

~~~scala
package fpinscala.datastructures

// List是一个泛型的数据类型，类型参数用A表示。
sealed trait List[+A]
// 用于表现空List的List数据构造器
case object Nil extends List[Nothing]
// 另一个数据构造器，呈现非空List。
// 注意尾部是另一个List[A],当然这个尾部也可能为Nil或另一个Cons。
case class Cons[+A](head: A, tail: List[A]) extends List[A]

// List伴生对象。包含创建List和对List操作的一些函数。
object List {
    // 利用模型匹配对一个整数型List进行合计
    def sum(ints: List[Int]): Int = ints match {
        // 空列表的累加值为0
        case Nil => 0
        // 对一个头部是x的列表表示累加，这个过程是用x加上该列表剩余部分的累加值
        case Cons(x,xs) => x + sum(xs)
    }
    
    def product(ds: List[Double]): Double = ds match {
        case Nil => 1.0
        case Cons(0.0, _) => 0.0
        case Cons(x,xs) => x * product(xs)
    }
    
    // 可变参数（译注：可以是一个或多个该类型的参数）函数语法
    def apply[A](as: A*): List[A] = 
    	if (as.isEmpty) Nil
    	else Cons(as.head, apply(as.tail: _*))
}
~~~

先看一下数据类型的定义，以sealed trait关键字开头。通常我们使用trait关键字引入一种数据类型，trait是一种可以包含一些具体方法（可选）的抽象接口。这里我们定义了一个没有任何方法的List特质，前边的sealed关键字意味着这个特质的所有实现都必须定义在这个文件里。（这里也可以用抽象类代替trait，它们两个的区别对我们目前的目的并不重要。）

List有两种实现，或者说构造器（每种都由case关键字引入），表示List有两种可能的形式。如顶部所示，List如果为空，使用数据构造器Nil表示，如果非空，使用数据构造器Cons（Construct的缩写）表示。一个非空List由初始元素head和后续紧跟的也是List结构（可能为空）的tail组成。

~~~scala
case object Nil extends List[Nothing]
case class Cons[+A](head: A, tail: List[A]) extends List[A]
~~~

~~~scala
// 这两个是相同的
List("a", "b")
Cons("a", Cons("b", Nil))
~~~

正如函数可以是多态的，数据类型也可以。通过在sealed trait List之后添加类型参数[+A]，然后在Cons数据构造器内部使用A，我们定义List数据类型所包含的元素类型是多态的，也就意味着对于Int元素（用List[Int]表示）、Double元素（用List[Double]表示）、String元素（用List[String]表示）等，可以用同样的定义（类型参数A前面+表示A是发生协变的）。

一个数据构造器声明，给我们一个函数来构造那种类型的数据类型。下面是一个例子：

~~~scala
val ex1: List[Double] = Nil
val ex2: List[Int] = Cons(1, Nil)
val ex3: List[String] = Cons("a", Cons("b", Nil))
~~~

case object Nil 让我们用Nil来构造一个空List，case class Cons 让我们用 Cons(1, Nil)、Cons("a", Cons("b", Nil)) 等方式来构造任意长度的单向链表。因为List是多态函数，参数化的类型A可以实例化为不同的类型。这里ex2例子中将类型参数A实例化为Int，而ex3例子中实例化为String。ex1例子很有趣，Nil可以是一个List[Double]类型的实例。之所以允许这样，因为空List中无元素，可以认为是任何类型的List。

每一种数据构造器同时也引入一种可用于模式匹配的模式，如同函数里的sum和product，接下来会通过更多细节来检验模式匹配。

> **关于型变（variance）**
>
> 在trait List[+A] 声明里，类型参数A前边的+是一个型变的符号，标志着A是协变的或正向（positive）的参数。意味着假设Dog是Animal的子类，那么List[Dog]是List[Animal]的子类。（多数情况下，所有类型X和Y，如果X是Y的子类型，那么List[X]是List[Y]的子类型）。我们可以在A的前面去掉+号，那样会标记List的参数类型是非型变的（invariant）。
>
> 但注意Nil继承List[Nothing]，Nothing是所有类型的子类型，也就是说使用型变符号后Nil可以当成是List[Int]或List[Double]等任何List的具体类型。
>
> 先别太担心型变的概念，当前讨论的重点更多在于工件是如何用Scala子类型编写数据构造器的，所以不必担心现在没有彻底搞清楚。当然可能写的代码根本不会使用型变注释，函数签名也会更简单（然而类型接口通常更糟）。本书会在方便使用的地方使用型变注释，但你可以随便使用哪种方式。

## 3.2 模式匹配



