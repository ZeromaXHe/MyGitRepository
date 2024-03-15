# 第1章 可伸展的语言

Scala语言的名称来自于“可伸展的语言”。之所以这样命名，是因为它被设计成可以随着使用者的需求而扩展。Scala的应用范围很广，从编写简单脚本，到建立大型系统。

## 1.1 与你一同成长的语言

## 1.2 是什么让Scala具有可扩展性？

与其他常见语言相比，Scala在把面向对象和函数式编程熔合为一体的语言设计方面要做得更多。比方说，其他语言或许分别有对象和方法这样两个不同的概念，而在Scala里，函数就是对象。函数类型是能够被子类继承的类。看上去这似乎只是出于学术美感的考虑，但它从深层次上影响了可扩展性。实际上，如果没有这种函数和对象的联合，前面演示的actor的设想也将无从实现。本节将浏览Scala融合面向对象和函数概念的方法。

### Scala是面向对象的

尽管面向对象编程已经在很长一段时间里成为主流，但仍然鲜有语言能在Smalltalk之后推动这种构造原则到逻辑结论的转化。举例来说，许多语言允许非对象值的存在，如Java里面的原始值。或者它们允许不隶属于任何对象的静态字段和方法。这些对纯理想化面向对象编程的背叛最初看起来完全无害，但令人头疼的事情还在后面，情况会变得复杂并限制了可扩展性。

相反，Scala是纯粹的面向对象语言：每个值都是对象，每个操作都是方法调用。

如果说到组装对象，Scala比多数别的语言更胜一筹。Scala的特质（trait）就是其中一例。特质就像Java的接口，但可以有方法实现及字段。可以通过混入组装（mixin composition）构造对象，从而带有了类的成员并加入了若干特质的成员。这样的构造方式，可以让不同用途的类包装不同的特质。这看上去有点儿像多重继承，但在细节上是有差异的。与类不同，特质可以把一些新的功能加入还未定义的超类中。这使得特质比类更具有“可加性”。尤为重要的是，它可以避免在多重继承里，通过若干不同渠道继承相同类时发生的经典的“菱形继承”问题。

### Scala是函数式的

函数式编程有两种指导理念，第一种理念是函数是头等值。

函数式编程的第二种理念是程序的操作应该把输入值映射为输出值而不是就地修改数据。Scala库在Java API之上定义了更多的不可变数据类型。例如，Scala有不可变的列表、元组、映射表和集。

函数式编程第二种理念的另一种解释是，方法不应有任何副作用（side effect）。方法与其所在环境交流的唯一方式应该是获得参数和返回结果。

函数式语言鼓励使用不可变数据结构和指称透明的方法。甚至有些函数式语言必须依赖于它们。Scala不强迫使用函数式的风格。必要的情况下，可以写成指令形式（imperative），用可变数据或有副作用的方法调用。但是Scala有更好的函数式编程方式做替代，因此通常可以轻松地避免使用它们。

## 1.3 为什么选择Scala？

本节将讨论其中最重要的四个：兼容性、简洁、高层抽象和高级的静态类型化。

### Scala是兼容的

Scala程序会被编译成JVM的字节码。Scala代码可以调用Java方法，访问Java字段，继承自Java类和实现Java接口。

与Java的全交互操作性的另一个方面是Scala大量重用了Java类型。

Scala代码同样可以由Java代码调用。

### Scala是简洁的

首先，Scala的语法避免了一些束缚Java程序的固定写法。例如，Scala里的分号是可选的，且通常不写。

另一个有助于Scala简洁性的因素是类型推断。重复的类型信息可以被忽略，因此程序变得更有条理和易读。

但减少代码的关键或许是现成的代码库。

### Scala是高级的

### Scala是静态类型的

静态类型系统可以根据保存和计算的值的类型认定变量和表达式类型。Scala是一种具有非常高级的静态类型系统的语言。它以Java的内嵌类型系统为基础，允许使用范型（generics）参数化类型，用交集（intersection）组合类型及抽象类型（abstract type）隐藏类型细节。这都为自建类型打下了坚实的基础，从而能够设计出即安全又能灵活使用的接口。

**可检验属性**。静态类型系统可以保证消除某些运行时的错误。例如可以保证：布尔型不会与整数型相加；私有变量不会从类的外部被访问；用正确数量的参数调用了函数；字符串集只能加入字符串。

**安全的重构**。静态类型系统让你可以非常有信心地去变动代码基础的安全网。试想一个给方法新增参数的重构实例。在静态类型语言中，你可以完成修改，重编译你的系统并简单地修改所有引起类型错误的代码行。一旦完成了这些，你可以确信已经发现了所有需要修改的地方。

**文档**。静态类型是被编译器检查过正确性的程序文档。

## 1.4 Scala的根源

在最表层，Scala采用了Java和C#语法的大部分，而它们大部分借自于对C和C++语法的改变。

Scala也从其他语言中借鉴了许多地方。它的统一对象模型由Smalltalk建立，后来又被Ruby发扬光大。他的通用嵌套的思想（几乎所有的Scala里的结构都能被嵌套进其他结构）还出现在Algol、Simula和最近的Beta和gbeta中。它的方法调用和字段选择的统一访问原则来自于Eiffel。它函数式编程的处理方式在骨子里与以SML、OCaml和F#为代表的ML家族语言很接近。许多Scala标准库里面的高阶函数同样也出现在ML或Haskell中。Scala的隐式参数灵感激发自Haskell的类型类；它们用一种更经典的面向对象设定获得了类似的结果。Scala基于actor的并发库几乎全是Erlang的思想。

# 第2章 Scala入门初探

## 2.1 第一步 学习使用Scala解释器

## 2.2 第二步 变量定义

scala有两种变量，val和var。val类似于Java里的final变量。一旦初始化了，val就不能再被赋值。相反，var如同Java里面的非final变量，可以在它的生命周期中被多次赋值。

Java的变量类型写在名称之前，相反，Scala的变量类型写在其名称之后，用冒号分隔。如：

~~~scala
scala> val msg2: java.lang.String = "Hello again, world!"
msg2: java.lang.String = Hello again, world!
~~~

想在解释器中跨行输入语句的话，只要一行行写进去即可。如果输到行尾还没结束，解释器将在下一行回应一个竖线。

如果你发现了一些错误而解释器仍在等着更多的输入，你可以通过按两次回车键取消掉

## 2.3 第三步 函数定义

我们已经学过了Scala变量的使用方法，接下来学习如何写Scala的函数。如下：

~~~scala
scala> 	def max(x: Int, y: Int): Int = {
    		if (x > y) x
    		else y
		}
max: (Int,Int)Int
~~~

Unit指的是函数没有有效的返回值。Scala的Unit类型比较类似于Java的void类型，而且实际上Java里返回void的方法都会被映射为返回Unit的Scala方法。因此，结果类型为Unit的方法，并非为了得到返回值，而是为了其他的运行效果（side effect）。

如果想要离开解释器，输入`:quit`或者`:q`

## 2.4 第四步 编写Scala脚本

Scala里数组steps的第一个元素是steps(0)，而不是像Java那样的steps[0]。现在，把以下内容写到新文件helloarg.scala中测试一下：

~~~scala
// 向第一个参数打问好
println("Hello, " + args(0) + "!")
~~~

然后运行：

~~~shell
$ scala helloarg.scala planet
~~~

这条命令里，命令行参数“planet”被传递给脚本，并通过访问args(0)获得。因此，你会看到：

~~~
Hello, planet!
~~~

## 2.5 第五步 用while做循环；用if做判断

~~~scala
var i = 0
while (i < args.length) {
    println(args(i))
    i += 1
}
~~~

~~~scala
var i = 0
while (i < args.length) {
	if (i != 0)
		print(" ")
	print(args(i))
	i += 1
}
println()
~~~

注意Scala和Java一样，必须把while或if的布尔表达式放在括号里。

## 2.6 第六步 用foreach和for做枚举

~~~scala
args.foreach(arg => println(arg))
~~~

~~~scala
args.foreach((arg: String) => println(arg))
~~~

~~~scala
args.foreach(println)
~~~

~~~scala
for (arg <- args)
	println(arg)
~~~

# 第3章 Scala入门再探

## 3.1 第七步 使用类型参数化数组（Array）

Scala里使用new实例化对象（或者叫类实例）。实例化过程中，可以用值和类型使对象参数化（parameterize）。参数化的意思是指在创建实例的同时完成对它的“设置”。使用值参数化实例可以通过把值传递给构造器的圆括号来实现。

~~~scala
val big = new java.math.BigInteger("12345")
~~~

使用类型参数化实例可以通过把一个或更多类型指定到基础类型后的方括号里来实现。

~~~scala
val greetStrings = new Array[String](3)

greetStrings(0) = "Hello"
greetStrings(1) = ", "
greetStrings(2) = "world!\n"

for(i <- 0 to 2)
	print(greetStrings(i))
~~~

这个for表达式的第一行代码说明了Scala的另一个基本规则：方法若只有一个参数，调用的时候就可以省略点及括号。本例中的to实际上是仅带一个Int参数的方法。代码`0 to 2`被转换成方法调用`(0).to(2)`（这个to方法实际上返回的不是数组而是包含了值0，1和2的，可以让for表达式遍历的序列。序列和其他集合类将在第17章描述）。请注意这个语法只有在明确指定方法调用的接收者时才有效。例如不可以写成“`println 10`”，但是可以写成“`Console println 10`”。

从技术层面上来说，Scala没有操作符重载，因为它根本没有传统意义上的操作符。取而代之的是，诸如`+`,`-`，`*`和`/`这样的字符，可以用来做方法名。因此，当我们在第一步往Scala解释器里输入`1 + 2`的时候，实际是在Int对象1上调用名为+的方法，并把2当作参数传给它。当然`1 + 2`更为传统的语法格式可以写成`(1).+(2)`。

这里要说明的另一问题是为什么在Scala里要用括号访问数组。与Java相比，Scala鲜有特例。与Scala其他的类一样，数组也只是类的实例。用括号传递给变量一个或多个值参数时，Scala会把它转换成对apply方法的调用。于是`greetStrings(i)`转换成`greetStrings.apply(i)`。所以Scala里访问数组的元素也只不过是跟其他的一样的方法调用。这个原则不是只对于数组：任何对于对象的值参数应用将都被转换为对apply方法的调用。当然前提是这个类型实际定义过apply方法。所以这不是特例，而是通用法则。

与之相似的是，当对带有括号并包括一到若干参数的变量赋值时，编译器将使用对象的update方法对括号里的参数（索引值）和等号右边的对象执行调用。例如

~~~scala
greetStrings(0) = "Hello"
~~~

将被转化为：

~~~scala
greetStrings.update(0, "Hello")
~~~

因此，下列Scala代码与清单3.1语义一致：

~~~scala
val greetStrings = new Array[String](3)

greetStrings.update(0, "Hello")
greetStrings.update(1, ", ")
greetStrings.update(2, "world!\n")

for(i <- 0 to 2)
	print(greetStrings.apply(i))
~~~

仅用一行代码就创建了长度为3的新数组，并用字符串"zero"，"one"和"two"实现初始化。编译器根据传递的值类型（字符串）推断数组的类型是Array[String]

~~~scala
val numNames = Array("zero", "one", "two")
~~~

清单3.2实际就是调用了创造并返回新数组的apply工厂方法。apply方法可以有不定个数的参数，定义在Array的伴生对象（companion object）。第4.3节里会学到更多关于伴生对象的知识。对于Java程序员来说，可以把它理解为调用Array类的静态方法apply。完整的写法是：

~~~scala
val numNames2 = Array.apply("zero", "one", "two")
~~~

## 3.2 第八步 使用列表（List）

方法没有副作用是函数式风格编程的重要理念，计算并返回值应该是方法唯一的目的。这样做的好处之一是方法之间耦合度降低，因此更加可靠和易于重用；好处之二（在静态类型语言里）是方法的参数和返回值都经过类型检查器的检查，因此可以比较容易地根据类型错误推断其中隐含的逻辑错误。而这种函数式编程思想在面向对象编程中的应用也就意味着对象的不可改变性。

正如我们之前所见的，Scala数组是可变的同类对象序列，例如，Array[String]的所有对象都是String。而且尽管数组在实例化之后长度固定，但它的元素值却是可变的。所以说数组是可变的。

至于不可变的同类对象序列，Scala的列表类（List）才是。和数组一样，LIst[String]仅包含String。但Scala的scala.List不同于Java的java.util.List，一旦创建了就不可改变。实际上，Scala的列表是为了实现函数式风格的编程而设计的。创建的方法如清单3.3所示：

~~~scala
val oneTwoThree = List(1, 2, 3)
~~~

列表类定义了“`:::`”方法实现叠加功能。用法如下：

~~~scala
val oneTwo = List(1, 2)
val threeFour = List(3, 4)
val oneTwoThreeFour = oneTwo ::: threeFour
println("" + oneTwo + " and " + threeFour + " were not mutated.")
println("Thus," + oneTwoThreeFour + " is a new List.")
~~~

列表类最常用的操作符或许是‘`::`’，发音为“cons”。它可以把新元素组合到现有列表的最前端，然后返回作为执行结果的新列表。执行代码：

~~~scala
val twoThree = List(2, 3)
val oneTwoThree = 1 :: twoThree
println(onwTwoThree)
~~~

将得到

~~~
List(1, 2, 3)
~~~

> **注意**
>
> 表达式“`1 :: twoThree`”中，`::`是右操作数twoThree的方法。你或许会质疑是否`::`方法的关联性有错误，不过请记住这只是个简单的规则：如果方法使用操作符来标注，如 `a * b`，那么左操作数是方法的调用者，可以改写成`a.*(b)`——除非——方法名以冒号结尾。这种情况下，方法被右操作数调用。因此，`1 :: twoThree`里，`::`方法的调用者是twoThree，1是方法的传入参数，因此可以改写成：`twoThree.::(1)`。

因为Nil是空列表的简写，所以可以使用cons操作符把所有元素都串起来，并以Nil作结尾来定义新列表。例如可以用以下的方法产生与上文同样的输出，“List(1, 2, 3)”

~~~scala
val oneTwoThree = 1 :: 2 :: 3 :: Nil
println(oneTwoThree)
~~~

Scala的List类定义了很多有用的方法，其中的部分列举在表3.1中。完整说明请参见第16章。

| 方法名                                                       | 方法作用                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| List() 或 Nil                                                | 空List                                                       |
| List("Cool", "tools", "rule")                                | 创建带有三个值"Cool", "tools" 和 "rule"的新List[String]      |
| val thrill = "Will" :: "fill" :: "until" :: Nil              | 创建带有三个值"Will", "fill" 和 "until"的新List[String]      |
| List("a", "b") ::: List("c", "d")                            | 叠加两个列表（返回带"a", "b", "c", "d"的新List[String]）     |
| thrill(2)                                                    | 返回在thrill列表上索引为2（基于0）的元素（"until"）          |
| thrill.count(s => s.length == 4)                             | 计算长度为4的String元素个数（2）                             |
| thrill.drop(2)                                               | 返回去掉前两个元素的thrill列表（List("until")）              |
| thrill.dropRight(2)                                          | 返回去掉后两个元素的thrill列表(List("Will"))                 |
| thrill.exists(s => s == "until")                             | 判断是否有值为“until”的字符串元素在thrill里（true）          |
| thrill.filter(s => s.length == 4)                            | 返回长度为4的元素依次组成的新列表（List("Will", "fill")）    |
| thrill.forall(s => s.endsWith("l"))                          | 判断是否thrill列表里所有元素都以"l"结尾（true）              |
| thrill.foreach(s => print(s))                                | 对thrill列表每个字符串执行print语句（"Willfilluntil"）       |
| thrill.foreach(print)                                        | 与前相同，不过更简洁（同上）                                 |
| thrill.head                                                  | 返回thrill列表的第一个元素（"Will"）                         |
| thrill.init                                                  | 返回thrill列表除最后一个以外其他元素组成的列表（List("Will", "fill")） |
| thrill.isEmpty                                               | 返回thrill列表是否为空(false)                                |
| thrill.last                                                  | 返回thrill列表的最后一个元素（"until"）                      |
| thrill.length                                                | 返回thrill列表的元素数量（3）                                |
| thrill.map(s => s + "y")                                     | 返回由thrill列表里每个String元素都加了"y"构成的列表（List("Willy", "filly", "untily")） |
| thrill.mkString(", ")                                        | 返回用列表的元素组成的字符串（"Will, fill, until"）          |
| thrill.remove(s => s.length == 4)                            | 返回去除了thrill列表中长度为4的元素后的元素依此组成了新列表（List("until")） |
| thrill.reverse                                               | 返回由thrill列表的元素逆序组成的新列表（List("until", "fill", "Will")） |
| thrill.sort((s, t) => s.charAt(0).toLowerCase < t.charAt(0).toLowerCase) | 返回thrill列表元素按照第一个字符的字母排序之后依此组成的新列表（List("fill", "until", "Will")） |
| thrill.tail                                                  | 返回thrill列表中除第一个元素之外依此组成的新列表（List("fill", "until")） |

> **为什么列表不支持添加（append）操作？**
>
> List类没有提供append操作，因为随着列表变长，append的耗时将呈线性增长，而使用::做前缀则仅耗用固定的时间。如果你想通过添加元素来构造列表，你的选择是先把它们前缀进去，完成之后再调用reverse；或使用ListBuffer，一种提供append操作的可变列表，完成之后调用toList。ListBuffer将在22.2节中描述。

## 3.3 第九步 使用元组（Tuple）

元组也是很有用的容器对象。与列表一样，元组也是不可变的；但与列表不同，元组可以包含不同类型的元素。例如列表只能写成List[Int]或List[String]，但元组可以同时拥有Int和String。元组适用场景很多，比方说，如果需要在方法里返回多个对象。Java里的做法是创建JavaBean以包含多个返回值，Scala里可以仅返回元组。而且做起来也很简单：只要把元组实例化需要的对象放在括号里，并用逗号分隔即可。元组实例化之后，可以用点号、下划线和基于1的索引访问其中的元素。如清单3.4所示：

~~~scala
val pair = (99, "Luftballons")
println(pair._1)
println(pair._2)
~~~

Scala推断元组的类型为Tuple2[Int, String]，并赋给值pair。这段代码执行的结果为：

~~~
99
Luftballons
~~~

元组的实际类型取决于它含有的元素数量和这些元素的类型。因此，(99, "Luftballons")的类型是Tuple2[Int, String]。('u', 'r', 'the', 1, 4, "me")是Tuple6[Char, Char, String, Int, Int, String]。

> **访问元组的元素**
>
> 你或许想知道为什么不能用访问列表的方法来访问元组，如pair(0)。那是因为列表的apply方法始终返回同样的类型，但元组里的类型不尽相同。`_1`的结果类型可能与`_2`不一致，诸如此类，因此两者的访问方法也不一样。另外，这些`_N`的索引是基于1的，而不是基于0的，这是因为对于拥有静态类型元组的其他语言，如Haskell和ML，从1开始是传统的设定。

## 3.4 第十步 使用集（set）和映射（map）

Scala致力于充分利用函数式和指令式风格两方面的好处，因此它的集合（collection）库区分为可变类型和不可变类型。例如，array具有可变性，而list保持不变。对于set和map来说，Scala同样有可变的和不可变的，不过并非各提供两种类型，而是通过类继承的差别把可变性差异蕴含其中。

例如，Scala的API包含了set的基本特质（trait），特质这个概念接近于Java的接口（interface）（第12章有更多说明）。Scala还提供了两个子特质，分别为可变set和不可变set。如图3.2所示，这三个特质都共享同样的简化名，set。然而它们的全称不一样，每个特质都在不同的包里。Scala的API里具体的set类，如图3.2的HashSet类，各有一个扩展了可变的和另一个扩展不可变的Set特质。（Java里面称为“实现”了接口，而在Scala里面称为“扩展”或“混入（mix in）”了特质。）因此，使用HashSet的时候，可以根据需要选择可变的或不可变的类型。set的基本构造方法如清单3.5所示

~~~mermaid
graph BT
	scala.collection.immutable_HashSet --> scala.collection.immutable_Set_trait
	scala.collection.mutable_HashSet --> scala.collection.mutable_Set_trait
	scala.collection.immutable_Set_trait -->	scala.collection_Set_trait
	scala.collection.mutable_Set_trait -->	scala.collection_Set_trait
~~~

~~~scala
var jetSet = Set("Boeing", "Airbus")
jetSet += "Lear"
println(jetSet.contains("Cessna"))
~~~

第一行定义了名为jetSet的新变量，并初始化包含两个字符串"Boeing"和"Airbus"的不可变集。如代码所示，scala中创建set的方法与创建list和array的类似：通过调用Set伴生对象的apply工厂方法。在上面的例子里，对scala.collection.immutable.Set的伴生对象调用了apply方法，返回了默认的不可变Set的实例。Scala编译器推断其类型为不可变Set[String]。

要加入新变量，可以对jesSet调用+，并传入新元素。可变的和不可变的集都提供了+方法，但结果不同。可变集把元素加入自身，而不可变集则创建并返回包含了添加元素的新集。清单3.5中使用的是不可变集，因此+调用将产生一个全新集。所以只有可变集提供的才是真正的+=方法，不可变集不是。例子中的第二行，“jetSet += "Lear"”，实质上是下面写法的简写：

~~~scala
jetSet = jetSet + "Lear"
~~~

如果要定义可变Set，就需要加入引用（import），如清单3.6所示：

~~~scala
import scala.collection.mutable.Set

val movieSet = Set("Hitch", "Poltergeist")
movieSet += "Shrek"
println(movieSet)
~~~

第一行里引用了可变Set。所以，编译器知道第三行的Set是指scala.collection.mutable.Set。只有可变集提供的才是真正的+=方法。这行代码还可以写成movieSet.+=("Shrek")。

尽管对于大多数情况来说，使用可变或不可变的Set工厂方法构造对象就已经足够了，但偶尔也难免需要指定set的具体类型。幸运的是，构造的语法相同：只要引用所指定的类，并使用伴生对象的工厂方法即可。例如，要使用不可变的HashSet，可以这么做：

~~~scala
import scala.collection.immutable.HashSet

val hashSet = HashSet("Tomatoes", "Chilles")
println(hashSet + "Coriander")
~~~

另一种Scala里常用的集合类是Map。和set一样，Scala采用了类继承机制提供了可变的和不可变的两种版本的Map，参见图3.3。map的类继承机制看上去和set的很像。scala.collection包里面有一个基础Map特质和两个子特质Map：可变的Map在scala.collection.mutable里，不可变的在scala.collection.immutable里。

~~~mermaid
graph BT
	scala.collection.immutable_HashMap --> scala.collection.immutable_Map_trait
	scala.collection.mutable_HashMap --> scala.collection.mutable_Map_trait
	scala.collection.immutable_Map_trait -->	scala.collection_Map_trait
	scala.collection.mutable_Map_trait -->	scala.collection_Map_trait
~~~

~~~scala
import scala.collection.mutable.Map

val treasureMap = Map[Int, String]()
treasureMap += (1 -> "Go to island.")
treasureMap += (2 -> "Find big X on ground")
treasureMap += (3 -> "Dig.")
println(treasureMap(2))
~~~

Scala编译器把二元操作符表达式`1 -> "Go to island."`转换为`(1).->("Go to island.")`。Scala的任何对象都能调用->方法，并返回包含键值对的二元组（任何对象都能调用->的机制被称为隐式转换，将在第21章里涉及）。然后这个二元组被交给treasureMap对象的+=方法。代码最终输出打印treasureMap中与键2对应的值。执行以上这段代码可以得到：

~~~
Find big X on ground
~~~

对于不可变map来说，不必引用任何类，因为不可变map是默认的，清单3.8展示了这个例子：

~~~scala
val romanNumeral = Map(
	1 -> "I", 2 -> "II", 3 -> "III", 4 -> "IV", 5 -> "V"
)
println(romanNumeral(4))
~~~

由于没有引用，因此代码第一行里使用了默认的Map：scala.collection.immutable.Map定义对象。并把五个键值元组传给工厂方法，得到返回包含这些键值对的不可变Map。执行以上代码，得到打印输出“IV”。

## 3.5 第十一步 学习识别函数式风格

我们的首要工作是识别这两种风格在代码上的差异。大致可以说，如果代码包含了任何var变量，那它可能就是指令式的风格。如果代码根本没有var——就是说仅仅包含val——那它或许是函数式的风格。因此向函数式风格转变的方式之一，就是尝试不用任何var编程。

下面是改编于第2章的while循环例子，它使用了var，因此属于指令式风格：

~~~scala
def printArgs(args: Array[String]): Unit = {
    var i = 0
    while (i < args.length) {
        println(args(i))
        i += 1
    }
}
~~~

你可以通过去掉var的办法把这个代码变得更函数式风格，例如，像这样：

~~~scala
def printArgs(args: Array[String]): Unit = {
    for (arg <- args)
    	println(arg)
}
~~~

或这样：

~~~scala
def printArgs(args: Array[String]): Unit = {
    args.foreach(println)
}
~~~

这个例子说明了减少使用var的一个好处。重构后（更函数式）的代码比原来（更指令式）的代码更简洁、明白，也更少有机会犯错。Scala鼓励函数式风格的原因，实际上也就是因为函数式风格可以帮助你写出更易读懂，同样也是更不易犯错的代码。

当然，这段代码仍有修改的余地。重构后的printArgs方法并不是纯函数式的，因为它有副作用——本例中的副作用就是打印到标准输出流。识别函数是否有副作用的地方就在于其结果类型是否为Unit。而函数风格的方式应该是定义对需打印的arg进行格式化的方法，不过仅返回格式化之后的字符串，如清单3.9所示：

~~~scala
def formatArgs(args: Array[String]) = args.mkString("\n")
~~~

现在才是真正函数式风格的了：完全没有副作用或var的mkString方法，能在任何可枚举的集合类型（包括数组，列表，集和映射）上调用，返回由每个数组元素调用toString，并把传入字符串做分隔符组成的字符串。当然，这个函数并不像printArgs方法那样能够实际完成打印输出，但可以简单地把它的结果传递给println来实现：

~~~scala
println(formatArgs(args))
~~~

每个有用的程序都会有某种形式的副作用，否则就不可能向程序之外提供什么有价值的东西。我们提倡无副作用的方法是为了鼓励你尽量设计出没有副作用代码的程序。这种方式的好处之一是可以有助于你的程序更容易测试。

说了这么多，不过还是请牢记：不管是var还是副作用都不是天生邪恶的。Scala不是只能使用函数式编程的纯函数式语言。它是这两种风格的混合式语言。甚至有时你会发现指令式风格能更有效地解决手中的问题，那就使用指令式风格，别犹豫。不过，为了帮助你学习如何不使用var编程，第7章中我们会演示若干把含有var的代码转换为val的特例。

> **Scala程序员的平衡感**
>
> 崇尚val，不可变对象和没有副作用的方法。
>
> 首先想到它们。只有在特定需要和并加以权衡之后才选择var，可变对象和有副作用的方法。

## 3.6 第十二步 从文件里读取文本行

清单3.10为第一个版本的实现：

~~~scala
import scala.io.Source
if (args.length > 0) {
    for (line <- Source.fromFile(args(0)).getLines)
    	print(line.length + " " + line)
}
else
	Console.err.println("Please enter filename")
~~~

全部的脚本在清单3.11中：

~~~scala
import scala.io.Source

def widthOfLength(s: String) = s.length.toString.length

if (args.length > 0) {
    val lines = Source.fromFile(args(0)).getLines.toList
    
    val longestLine = lines.reduceLeft(
    	(a, b) => if (a.length > b.length) a else b
    )
    val maxWidth = widthOfLength(longestLine)
    
    for (line <- lines) {
        val numSpaces = maxWidth widthOfLength(line)
        val padding = " " * numSpaces
        print(padding + line.length + " { " + line)
    }
}
else
	Console.err.println("Please enter filename")
~~~

# 第4章 类和对象

## 4.1 类、字段和方法

类定义可以放置字段和方法，这些被笼统地称为**成员**（member）。字段，不管是用val还是用var定义的，都是指向对象的变量。方法，用def定义，包含了可执行的代码。字段保留了对象的状态或数据，而方法使用这些数据执行对象的运算工作。

> **注意**
>
> 在Scala里把成员公开的方法是不显式地指定任何访问修饰符。换句话说，在Java里要写上“public”的地方，在Scala里只要什么都不要写就成。public是Scala的默认访问级别。

传递给方法的任何参数都可以在方法内部使用。Scala里方法参数的一个重要特征是它们都是val，不是var。如果你想在方法里给参数重新赋值，结果是编译失败：

~~~scala
def add(b: Byte): Unit = {
    b = 1 // 编译不过，因为b是val
    sum += b
}
~~~

如果没有发现任何显式的返回语句，Scala方法将返回方法中最后一次计算得到的值。

方法的推荐风格是尽量避免使用返回语句，尤其是多条返回语句。代之以把每个方法当作是创建返回值的表达式。这种逻辑鼓励你分层简化方法，把较大的方法分解为多个更小的方法。另一方面，内容决定形式，如果确实需要，Scala也能够很容易地编写具有多个显式的return的方法。

假如某个方法仅计算单个结果表达式，则可以去掉花括号。如果结果表达式很短，甚至可以把它放在def的同一行里。这样改动之后，类ChecksumAccumulator看上去像这样：

~~~scala
class checksumAccumulator {
    private var sum = 0
    def add(b: Byte): Unit = sum += b
    def checksum(): Int = ~(sum & 0xFF) + 1
}
~~~

对于像ChecksumAccumulator的add方法那样的结果类型为Unit的方法来说，执行的目的就是为了它的副作用。通常我们定义副作用为能够改变方法之外的某处状态或执行I/O活动的方法。比方说，在add这个例子里，副作用就是sum被重新赋值了。它的另一种表达方式是去掉结果类型和等号，把方法体放在花括号里。在这种形势下，方法看上去很像过程（procedure），一种仅为了副作用而执行的方法。清单4.1的add方法可以改写如下：

~~~scala
// 文件ChecksumAccumulator.scala
class checksumAccumulator {
    private var sum = 0
    def add(b: Byte) { sum += b }
    def checksum(): Int = ~(sum &0xFF) + 1
}
~~~

比较容易出错的地方是如果去掉方法体前面的等号，那么方法的结果类型就必定是Unit。这种说法不论方法体里面包含什么都成立，因为Scala编译器可以把任何类型转换为Unit。例如，如果方法的最后结果是String，但结果类型被声明为Unit，那么String将被转变为Unit并丢弃原值：

~~~scala
scala> def f(): Unit = "this String gets lost"
f: ()Unit
~~~

例子里，函数f声明了结果类型Unit，因此String被转变为Unit。Scala编译器会把定义的像过程的方法，就是说，带有花括号但没有等号的，本质上当作Unit结果类型的方法。例如：

~~~scala
scala> def g() { "this String gets lost too" }
g: ()Unit
~~~

因此，对于本想返回非Unit值的方法却忘记加等号时，错误就出现了。所以为了得到想要的结果，等号是必不可少的：

~~~scala
scala> def h() = { "this String gets returned!" }
h: ()java.lang.String

scala> h
res0: java.lang.String = this String gets returned!
~~~

## 4.2 分号推断

Scala程序里，语句末尾的分号通常是可选的。愿意可以加，若一行里仅有一个语句也可以不加。不过，如果一行包含多条语句时，分号则是必须的：

~~~scala
val s = "hello"; println(s)
~~~

输入跨越多行的语句时，多数情况无须特别处理，Scala将在正确的位置分隔语句。例如，下面的代码被当成跨四行的一条语句：

~~~scala
if (x < 2)
	println("too small")
else
	println("ok")
~~~

然而，偶尔Scala也许并不如你所愿，把句子分拆成两部分：

~~~scala
x
+ y
~~~

这会被当做两个语句x和+y。如果希望把它作为一个语句x+y，可以把它放在括号里：

~~~scala
(x
+ y)
~~~

或者也可以把 + 放在行末。也正源于此，串接类似于+这样的中缀操作符的时候，Scala通常的风格是把操作符放在行尾而不是行头：

~~~scala
x +
y +
z
~~~

> **分号推断的规则**
>
> 分割语句的具体规则既出人意料地简单又非常有效。那就是，除非以下情况的一种成立，否则行尾被认为是一个分号：
>
> 1. 疑问行由一个不能合法作为语句结尾的字结束，如句点或中缀操作符。
> 2. 下一行开始于不能作为语句开始的词。
> 3. 行结束于括号(...)或方框[...]内部，因为这些符号不可能容纳多个语句。

## 4.3 Singleton对象

第1章提到过，Scala比Java更为面向对象的特点之一是Scala不能定义静态成员，而是代之以定义单例对象（singleton object）。除了用object关键字替换了class关键字外，单例对象的定义看上去与类定义一致。参见清单4.2：

~~~scala
// 文件ChecksumAccumulator.scala
import scala.collection.mutable.Map

object ChecksumAccumulator {
    private val cache = Map[String, Int]()
    
    def calculate(s: String): Int = 
    	if (cache.contains(s))
    		cache(s)
    	else {
            val acc = new ChecksumAccumulator
            for (c <- s)
            	acc.add(c.toByte)
            val cs = acc.checksum()
            cache += (s -> cs)
            cs
        }
}
~~~

表中的单例对象叫做ChecksumAccumulator，与前一个例子里的类同名。当单例对象与某个类共享同一个名称时，它就被称为是这个类的伴生对象（companion object）。类和它的伴生对象必须定义在一个源文件里。类被称为是这个单例对象的伴生类（companion class）。类和它的伴生对象可以相互访问其私有成员。

对于Java程序员来说，可以把单例对象当作是Java中可能会用到的静态方法工具类。也可以用类似的语法做方法调用：单例对象名，点，方法名。

然而单例对象不只是静态方法的工具类。它同样是头等的对象。因此单例对象的名字可以被看作是贴在对象上的“名签”

定义单例对象并没有定义类型（在Scala的抽象层次上说）。如果只有ChecksumAccumulator对象的定义，就不能建立ChecksumAccumulator类型的变量。或者可以认为，ChecksumAccumulator类型是由单例对象的伴生类定义的。然而，单例对象扩展了父类并可以混入特质。因此，可以使用类型调用单例对象的方法，或者用类型的实例变量指代单例对象，并把它传递给需要类型参数的方法。我们将在第12章展示一些继承自类和特质的单例对象的例子。

类和单例对象间的差别是，单例对象不带参数，而类可以。因为单例对象不是用new关键字实例化的，所以没机会传递给它实例化参数。每个单例对象都被实现为虚构类（synthetic class）的实例，并指向静态的变量，因此它们与Java静态类有着相同的初始化语义。特别要指出的是，单例对象在第一次被访问的时候才会被初始化。

不与伴生类共享名称的单例对象被称为独立对象（standalone object）。它可以用在很多地方，例如作为相关功能方法的工具类，或者定义Scala应用的入口点。下面会说明这种用法。

## 4.4 Scala程序

想要编写能够独立运行的Scala程序，就必须创建有main方法（仅带一个参数Array[String]，且结果类型为Unit）的单例对象。任何拥有合适签名的main方法的单例对象都可以用来作为程序的入口点。示例参见清单4.3：

~~~scala
// 文件 Summer.scala
import ChecksumAccumulator.calculate

object Summer {
    def main(args: Array[String]) {
        for (arg <- args)
        	println(arg + ": " + calculate(arg))
    }
}
~~~

文件中的第一个语句是对定义在前面ChecksumAccumulator对象中calculate方法的引用。它允许你在后面的文件里使用方法的简化名。（对于Java程序员来说，可以认为这种引用类似于Java 5引入的静态引用特性。然而Scala里的不同点在于，任何成员引用可以来自于任何对象，而不只是单例对象。）

> **注意**
>
> Scala的每个源文件都隐含了对包java.lang、包scala，以及单例对象Predef的成员引用。包Scala中的Predef对象包含了许多有用的方法。例如，Scala源文件中写下println语句，实际调用的是Predef的println（Predef.println转而调用Console.println，完成真正的工作）。写下assert，实际是在调用Predef.assert。

要执行Summer应用程序，需要把以上的代码写入文件Summer.scala中。因为Summer使用了ChecksumAccumulator，所以还要把ChecksumAccumulator的代码，包括清单4.1的类和清单4.2里它的伴生对象，放在文件ChecksumAccumulator.scala中。

Scala和Java之间有一点不同，Java需要你把公共类放在以这个类命名的源文件中——如类SpeedRacer要放在SpeedRacer.java里——Scala对于源文件的命名没有硬性规定。然而通常情况下如果不是脚本，推荐的风格是像在Java里那样按照所包含的类名来命名文件，这样程序员就可以比较容易地根据文件名找到类。本例中我们对文件ChecksumAccumulator.scala和Summer.scala使用这一原则命名。

ChecksumAccumulator.scala和Summer.scala都不是脚本，因为它们都以定义结尾。反过来说，脚本必须以结果表达式结束。你需要用Scala编译器真正地编译这些文件，然后执行输出的类文件。方式之一是使用Scala的基本编译器，scalac。输入：

~~~shell
$ scalac ChecksumAccumulator.scala Summer.scala
~~~

开始编译源文件，不过在编译完成之前或许会稍微停顿一下。这是因为每次编译器启动时，都要花一些时间扫描jar文件内容，并在开始编译你提交的源文件之前完成更多其他的初始化工作。因此，Scala的发布包里还包括了一个叫做fsc（快速Scala编译器，fast Scala compiler）的Scala编译器后台服务（daemon）。使用方法如下：

~~~shell
$ fsc ChecksumAccumulator.scala Summer.scala
~~~

第一次执行fsc时，会创建一个绑定在你计算机端口上的本地服务器后台进程。然后它就会把文件列表通过端口发送给后台进程，由后台进程完成编译。下一次执行fsc时，检测到后台进程已经在运行了，于是fsc将只把文件列表发给后台进程，它会立刻开始编译文件。使用fsc，只须在首次运行的时候等待Java运行时环境的启动。如果想停止fsc后台进程，可以执行fsc -shutdown。

## 4.5 Application特质

Scala提供了特质scala.Application，可以减少一些输入工作。参见清单4.4：

~~~scala
import ChecksumAccumulator.calculate

object FallWinterSpringSummer extends Application {
    for (season <- List("fall", "winter", "spring"))
    	println(season + ": " + calculate(season))
}
~~~

使用方法是，首先在单例对象名后面写上“extends Application”。然后代之以main方法，你可以把想要执行的代码直接放在单例对象的花括号之间。如此而已。之后可以正常的编译和运行。

能这么做，是因为特质Application声明了带有合适签名的main方法，并被你写的单例对象继承，使它可以像Scala程序那样。花括号之间的代码被收集进了单例对象的主构造器（primary constructor），并在类被初始化时执行。如果你暂时不能明白所有这些指的什么也不用着急。之后的章节会解释，目前只要知道有这种做法即可。

继承自Application比编写完整的main方法要方便，不过它也有缺点。首先，如果想访问命令行参数的话就不能用它，因为args数组不可访问。第二，因为某些JVM线程模型里的局限，如对于多线程的程序需要自行编写main方法；最后，某些JVM的实现没有优化被Application特质执行的对象的初始化代码。因此只有当程序相当简单并且是单线程的情况下才可以继承Application特质。

# 第5章 基本类型和操作

## 5.1 基本类型

表5.1显示了Scala的基本类型和实例值域范围。总体来说，类型Byte、Short、Int、Long和Char被称为整数类型（integral type）。整数类型加上Float和Double被称为数类型（numeric type）。

| 值类型  | 范围                               |
| ------- | ---------------------------------- |
| Byte    | 8位有符号补码整数（-2^7~2^7-1）    |
| Short   | 16位有符号补码整数（-2^15~2^15-1） |
| Int     | 32位有符号补码整数（-2^31~2^31-1） |
| Long    | 64位有符号补码整数（-2^63~2^63-1） |
| Char    | 16位无符号Unicode字符（0~2^16-1）  |
| String  | char序列                           |
| Float   | 32位IEEE754单精度浮点数            |
| Double  | 64位IEEE754单精度浮点数            |
| Boolean | true或false                        |

除了String归于java.lang包之外，其余所有的基本类型都是包scala的成员。如，Int的全名是scala.Int。然而，由于包scala和java.lang的所有成员都被每个Scala源文件自动引用，因此可以在任何地方只用简化名（就是说，直接写成Boolean、Char或String）。

> **注意**
>
> 目前实际上Scala值类型可以使用与Java的原始类型一致的小写化名称。比如，Scala程序里可以用int替代Int。但请记住它们都是一回事：scala.Int。Scala社区实践提出的推荐风格是一直使用大写形式，这也是我们在这本书里做的。为了纪念这个社区推动的选择，将来Scala的版本可能不再支持乃至移除小写化名称，因此跟随社区的趋势，在Scala代码中使用Int而非int才是明智之举。

敏锐的Java开发者会注意到Scala的基本类型与Java的对应类型范围完全一样。这样可以让Scala编译器直接把Scala的值类型（value type）实例，如Int或Double，对应转译为Java原始类型。

## 5.2 字面量

所有在表5.1里列出的基本类型都可以写成字面量（literal）。字面量就是直接写在代码里的常量值。

> **Java程序员的快速通道**
>
> 本节里多数字面量的语法和在Java里完全一致，因此对于Java达人来说，可以安心地跳过本节的多数内容。唯一需要关注的两个差异分别是Scala的原字符串和符号字面量。

### 整数字面量

如果数开始于0x或0X，那它是十六进制（基于16）

如果数开始于零，就是八进制（基于8）的

如果数开始于非零数字，并且没有被修饰过，就是十进制（基于10）的。

如果整数字面量结束于L或者l，就是long类型，否则就是Int类型。

### 浮点数字面量

浮点数字面量是由十进制数字、可选的小数点、可选的E或e及指数部分组成的。

请注意指数部分表示的是乘上以10为底的幂级数。因此，1.2345e1就是1.2345乘以10^1，等于12.345。如果浮点数字面量以F或f结束，就是Float类型的，否则就是Double类型的。可选的，Double浮点数字面量也可以D或d结尾。

### 字符字面量

字符字面量可以是在单引号之间的任何Unicode字符，如：

~~~scala
scala> val a = 'A'
a: Char = A
~~~

单引号之间除了可以摆放字符之外，还可以提供一个前缀反斜杠的八进制或十六进制的表示字符编码号的数字。八进制数必须在'\0'和'\377'之间。例如字母A的Unicode字符编码是八进制101。因此：

~~~scala
scala> val c = '\101'
c: Char = A
~~~

字符字面量同样可以以前缀\u的四位十六进制数字的通用Unicode字符方式给出

~~~scala
scala> val d = '\u0041'
d: Char = A
scala> val f = '\u0044'
f: Char = D
~~~

实际上这种unicode字符可以出现在Scala程序的任何地方。例如你可以这样写一个标识符：

~~~scala
scala> val B\u0041\u0044 = 1
BAD: Int = 1
~~~

这个标识符被当作BAD，这是上面代码里的两个unicode字符转义（expand）之后的结果。通常，这样命名标识符是个坏主意，因为它太难读。然而，这种语法能够允许含有非ASCII的Unicode字符的Scala源文件用ASCII来代表。

最后，还有一些字符字面量被表示成特殊的转义序列，参见表5.2。例如：

| 字面量 | 含义             |
| ------ | ---------------- |
| `\n`   | 换行（\u000A）   |
| `\b`   | 回退（\u0008）   |
| `\t`   | 制表符（\u0009） |
| `\f`   | 换页（\u000C）   |
| `\r`   | 回车（\u000D）   |
| `\"`   | 双引号（\u0022） |
| `\'`   | 单引号（\u0027） |
| `\\`   | 反斜杠（\u005C） |

### 字符串字面量

字符串字面量是由双引号（"）包括的字符组成

引号内的字符语法与字符字面量相同

由于这种语法对于包含大量转义序列或跨越若干行的字符串很笨拙。因此Scala为原始字符串（raw string）引入了一种特殊的语法。它以同一行里的三个引号（"""）作为开始和结束。内部的原始字符串可以包含无论何种任意字符串，包括新行、引号和特殊字符，当然同一行的三个引号除外。举例来说，下面的程序使用原始字符串打印输出了一条消息：

~~~scala
println("""Welcome to Ultamix 3000.
		   Type "HELP" for help.""")
~~~

运行这段代码不会产生完全符合所需的东西，而是：

~~~
Welcome to Ultamix 3000.
		   Type "HELP" for help.
~~~

原因是第二行的前导的空格被包含在了字符串里。为了解决这个常见情况，字符串类引入了stripMargin方法。使用的方式是，把管道符号（|）放在每行前面，然后对整个字符串调用stripMargin：

~~~scala
println("""|Welcome to Ultamix 3000.
		   |Type "HELP" for help.""".stripMargin)
~~~

这样，输出结果就令人满意了：

~~~
Welcome to Ultamix 3000.
Type "HELP" for help.
~~~

### 符号字面量

符号字面量被写成`'<标识符>`，这里<标识符>可以是任何字母或数字的标识符。这种字面量被映射成预定义类scala.Symbol的实例。具体地说，就是字面量'cymbal将被编译器扩展为工厂方法调用：Symbol("cymbal")。符号字面量典型的应用场景是在动态类型语言中使用一个标识符。

符号字面量除了显式名字之外，什么都不能做：

~~~scala
scala> val s = 'aSymbol
s: Symbol = 'aSymbol

scala> s.name
res20: String = aSymbol
~~~

还有就是符号是被限定（interned）的。如果同一个符号字面量出现两次，那么两个字面量指向的是同一个Symbol对象。

### 布尔型字面量

布尔类型有两个字面量，true和false

## 5.3 操作符和方法

Scala为基本类型提供了丰富的操作符集。如前几章里描述的，这些操作符实际只是普通方法调用的另一种表现形式。例如，1 + 2与(1).+(2)其实是一回事。换句话说，就是Int类包含了叫做+的方法，它传入了Int参数并返回一个Int结果，在两个Int值相加时被调用

实际上，Int包含了+的各种类型参数的重载（overload）方法。例如，另一个也叫+的方法的参数和返回类型都是Long。如果把Long加到Int上，就将转而调用这个+方法

符号+是操作符——更明确地说，是中缀操作符。操作符标注不仅限于像+这种其他语言里看上去像操作符的东西，任何方法都可以被当作操作符来标注。例如，类String 有个带 Char 参数的方法 indexOf。它搜索 String 里第一次出现的指定字符，并返回它的索引；如果没有找到就返回-1。indexOf可以被当成中缀操作符使用，就像这样：

~~~scala
scala> val s = "Hello, world!"
s: java.lang.String = Hello, world!

scala> s indexOf 'o' // Scala调用了s.indexOf('o')
res0: Int = 4
~~~

另外，String还提供了重载的indexOf方法，带两个参数，分别是要搜索的字符和从哪个索引开始搜索（前一个indexOf方法开始于索引零，也就是String开始的地方）。尽管这个indexOf方法带两个参数，你仍然可以用操作符标注的方式使用它。不过这样用的时候，这些参数必须放在括号内。例如，以下是把另一种形式的indexOf当作操作符使用的例子（接前例）：

~~~scala
scala> s indexOf ('o', 5) // Scala调用了s.indexOf('o', 5)
res1: Int = 8
~~~

> **任何方法都可以是操作符**
>
> Scala里的操作符不是特殊的语法：任何方法都可以是操作符。到底是方法还是操作符取决于你如何使用它。

到目前为止，你已经看到了中缀（infix）操作符标注的例子，也就是说调用的方法位于对象和传递给方法的参数或若干参数之间，如“7 + 2”。Scala还有另外两种操作符标注方式，分别是前缀标注和后缀标注。前缀标注中，方法名被放在调用的对象之前，如，-7 里的“-”。后缀标注中，方法放在对象之后，如，“7 toLong”里的“toLong”。

与中缀操作符——两个操作数，分别在操作符的左右两侧——相反，前缀和后缀操作符都是一元（unary）的：它们仅有一个操作数。前缀方式中，操作数在操作符的右边。前缀操作符的例子有 -2.0、!found和~0xFF。这些前缀操作符与中缀操作符一致，是值类型对象调用方法的简写形式。然而这种情况下，方法名在操作符字符上前缀“`unary_`”。例如，Scala会把表达式-2.0转换成方法调用“`(2.0).unary_-`”。

标识符中能作为前缀操作符用的只有+、-、!和~。因此，如果对类型定义了名为`unary_!`的方法，就可以对值或变量用!p这样的前缀操作符方式调用方法。但是即使定义了名为`unary_*`的方法，也没办法将其用成前缀操作符了，因为`*`不是四种可以当作前缀操作符用的标识符之一。你可以像平常那样调用它，如`p.unary_*`，但如果尝试像`*p`这么调用，Scala就会把它理解为`*.p`，这或许就不是你说期望的了！

后缀操作符是不用点或括号调用的不带任何参数的方法。在Scala里，方法调用的空括号可以省略。惯例是如果方法带有副作用就加上括号，如println()；如果没有副作用就去掉括号，如String的toLowerCase方法

由此可知，想要知道Scala的值类型有哪些操作符，只要在Scala的API文档里查询定义在值类型上的方法即可。

> **Java程序员的快速通道**
>
> 本章后续部分描述的Scala很多方面与Java相同。对于只想一探究竟的Java专家来说，可以安心地跳到5.7节，那里描述了在对象相等性方面Scala与Java的差异。

## 5.4 数学运算

用%符号得到的浮点数余数并不遵循IEEE754标准的定义。IEEE754在计算余数时使用四舍五入除法，而不是截尾除法，因此余数的计算与整数的余数操作会有很大的不同。如果想要得到符合IEEE754标准的余数，可以调用scala.Math里面的IEEEremainder

## 5.5 关系和逻辑操作

与Java里一样，逻辑与和逻辑或都有短路（short-circuit）的概念

> **注意**
>
> 或许你会想知道如果操作符都只是方法的话短路机制是怎么工作的呢。通常，进入方法之前会评估所有的参数，因此方法怎么可能选择不评估它的第二个参数呢？答案是因为所有的Scala方法都有延迟其参数评估乃至取消评估的机制，被称为传名参数（by-name parameter），将在9.5节中讨论。

## 5.6 位操作符

## 5.7 对象相等性

==已经被仔细地加工过，因此在多数情况下都可以实现合适的相等性比较。这种比较遵循一种非常简单的原则：首先检查左侧是否为null，如果不是，调用左操作数的equals方法。而精确的比较却决于左操作数的equals方法定义。由于有了自动的null检查，因此不需要手动再检查一次了。

> **Scala的==与Java的有何差别**
>
> Java里==既可以比较原始类型也可以比较引用类型。对于原始类型，Java的==比较值的相等性，与Scala一致。而对于引用类型，Java的==比较了引用相等性（reference equality），也就是说比较的是这两个变量是否都指向JVM堆里的同一个对象。Scala也提供了这种机制，名字是eq。不过，eq和它的反义词ne，仅仅应用于可以直接映射到Java的对象。eq和ne将在11.1节和11.2节说明。还有，可以看一下第28章，了解如何编写好的equals方法。

## 5.8 操作符的优先级和关联性

由于Scala没有操作符，实际上，操作符只是方法的一种表达方式，你或许想知道操作符优先级是怎么做到的。对于以操作符形式使用的方法，Scala根据操作符的第一个字符判断方法的优先级（这个规则有个例外，稍后再说）。

| 表5.3 操作符优先级     |
| ---------------------- |
| （所有其他的特殊字符） |
| * / %                  |
| + -                    |
| :                      |
| = !                    |
| <>                     |
| &                      |
| ^                      |
| \|                     |
| （所有字母）           |
| （所有赋值操作符）     |

表5.3 以降序的方式列举了以方法第一个字符判定的优先级，同一行的字符具有同样的优先级。表中字符的位置越高，以这个字符开始的方法具有的优先级就越高。

当同样优先级的多个操作符并列出现在表达式里时，操作符的关联性（associativity）决定了操作符分组的方式。Scala里操作符的关联性取决于它的最后一个字符。正如第3章里提到的，任何以“:”字符结尾的方法由它的右操作数调用，并传入左操作数。以其他字符结尾的方法与之相反。它们都是被左操作数调用，并传入右操作数的。因此`a * b`变成`a.*(b)`，但是`a:::b`变成`b.:::(a)`。

然而，不论操作符具有什么样的关联性，它的操作数总是从左到右评估的。因此如果b是一个表达式而不仅仅是一个不可变值的引用，那么更精确的意义上说，`a:::b`将会被当作是：

~~~scala
{val x = a; b.:::(x)}
~~~

这个代码块中，a仍然在b之前被评估，然后评估结果被当作操作数传给b的:::方法。

这种关联性规则在同时使用多个具有同优先级的操作符时也会起作用。如果方法结束于`:`，它们就被自右向左分组；反过来，就是自左向右分组。例如，`a:::b:::c`会被当作`a:::(b:::c)`。而`a * b * c`被当作`(a * b) * c`。

## 5.9 富包装器

Scala基本类型的可调用的方法远多于前几段里面讲到的。表5.4 里罗列了几个例子。这些方法的使用要通过隐式转换（implicit conversion），一种在第21章才会提到的技术。现在所有要知道的就是本章介绍过的每个基本类型，都对应着一个“富包装器”提供许多额外的方法。这些类可参见表5.5。

| 代码               | 结果           |
| ------------------ | -------------- |
| 0 max 5            | 5              |
| 0 min 5            | 0              |
| -2.7 abs           | 2.7            |
| -2.7 round         | -3L            |
| 1.5 isInfinity     | false          |
| (1.0/0) isInfinity | true           |
| 4 to 6             | Range(4, 5, 6) |
| "bob" capitalize   | "Bob"          |
| "robert" drop 2    | "bert"         |

| 基本类型 | 富包装                    |
| -------- | ------------------------- |
| Byte     | scala.runtime.RichByte    |
| Short    | scala.runtime.RichShort   |
| Int      | scala.runtime.RichInt     |
| Long     | scala.runtime.RichLong    |
| Char     | scala.runtime.RichChar    |
| String   | scala.runtime.RichString  |
| Float    | scala.runtime.RichFloat   |
| Double   | scala.runtime.RichDouble  |
| Boolean  | scala.runtime.RichBoolean |

# 第6章 函数式对象

有了从前几章获得的Scala基础知识，你已经为探索如何在Scala里设计出拥有更全面特征的对象做好了准备。本章的重点在于定义函数式对象，也就是说，不具有任何可改变状态的对象的类。为了便于说明和演示，我们将创造若干以有理数作为不可变对象来建模的类版本。在此过程中，我们会学习Scala面向对象编程的更多知识：类参数和构造函数，方法和操作符，私有成员，子类方法重载，先决条件检查，同类方法重载和自指向。

## 6.2 创建Rational

~~~scala
class Rational(n:Int, d:Int)
~~~

这行代码里首先应当注意到的是如果类没有主体，就不需要指定一对空的花括号（你想的话亦可以）

类名Rational之后的括号里的n和d，被称为类参数（class parameter）

Scala编译器会收集这两个类参数并创造出带同样的两个参数的主构造器（primary constructor）

## 6.3 重新实现toString方法

方法定义前的override修饰符说明这是对原方法定义的重载

## 6.4 检查先决条件

先决条件是对传递给方法或构造器的值的限制，是调用者必须满足的需求。

一种方法是使用require方法实现：

require方法带一个布尔型参数。如果传入的值为真，require将正常返回。反之，require将抛出IllegalArgumentException阻止对象被构造。

## 6.5 添加字段

方法仅能访问调用对象自身的类参数

## 6.6 自指向

this

## 6.7 辅助构造器

Scala的辅助构造器定义开始于 def this (...)。

Scala中的每个辅助构造器的第一个动作都是调用同类的别的构造器。

因此主构造器是类的唯一入口点。
    

## 6.8 私有字段和方法

## 6.9 定义操作符

5.8节中曾经说过的Scala的操作符优先规则，*方法要比+方法优先级更高

## 6.10 Scala的标识符

- 字母数字标识符（alphanumeric identifier）
  以字母或下划线开始，之后可以跟字母、数字或下划线。
  '`$`'字符也被当作是字母，但被保留作为Scala编译器产生的标识符之用。
- 操作符标识符（operator identifier）
  由一个或多个操作符字符组成
  Scala编译器将在内部“粉碎”操作符标识符以转换成合法的内嵌'`$`​'的Java标识符。
- 混合标识符（mixed identifier）
  由字母数字组成，后面跟着下划线和一个操作符标识符
- 字面量标识符（literal identifier）
  用反引号\`...\`包括的任意字符串，结果总被当作Scala标识符
  例如，Thread.\`yield\`()。yield是Scala的保留字
       

## 6.11 方法重载

## 6.12 隐式转换

~~~scala
implicit def intToRational(x:Int) = new Rational(x)
~~~

方法前面的implicit修饰符告诉编译器可以在一些情况下自动调用。

请注意要隐式转换起作用，需要定义在作用范围之内。

# 第7章 内建控制结构

## 7.1 If表达式

指令式风格

~~~scala
var filename = "default.txt"
if (!args.isEmpty)
	filename = args(0)
~~~

这段代码还有优化的余地，Scala的if是能返回值的表达式。

~~~scala
val filename = 
	if (!args.isEmpty) args(0)
	else "default.txt"
~~~



使用val而不是var的第二点好处是它能更好地支持等效推论（equational reasoning）。

## 7.2 While循环

while和do-while结构之所以被称为“循环”，而不是表达式，是因为它们不能产生有意义的结果。结果的类型是Unit

存在并且唯一存在类型为Unit的值，称为unit value，写成`()`。

对var再赋值等式本身也是unit值

while循环和var经常是结对出现的。审慎地使用while循环。

## 7.3 For表达式

### 枚举集合类

~~~scala
for (file <- filesHere)
~~~

~~~scala
for (i <- 1 to 4)
~~~

不想包括被枚举的Range上边界

~~~scala
for (i <- 1 until 4)
~~~

### 过滤

~~~scala
for (file <- filesHere if file.getName.endsWith(".scala"))
~~~

你可以包含更多的过滤器

~~~scala
for {
	file <- filesHere
    if file.isFile;
    if file.getName.endsWith(".scala")
} println(file)
~~~

> **注意**
>
> 如果在发生器加入超过一个过滤器，if子句必须用分号分隔。

### 嵌套枚举

~~~scala
for {
    file <- filesHere
    if file.getName.endsWith(".scala")
    line <- fileLines(file)
    if line.trim.matches(pattern)
} println(file + ": " + line.trim)
~~~

### 流间（mid-stream）变量绑定

绑定的变量被当作val引入和使用，不过不带关键字val

~~~scala
for {
    file <- filesHere
    if file.getName.endsWith(".scala")
    line <- fileLines(file)
    trimmed = line.trim
    if trimmed.matches(pattern)
} println(file + ": " + trimmed)
~~~

### 制造新集合

~~~scala
for {
    file <- filesHere
    if file.getName.endsWith(".scala")
    line <- fileLines(file)
    trimmed = line.trim
    if trimmed.matches(pattern)
} yield trimmed.length
~~~

## 7.4 使用try表达式处理异常



# 第14章 断言和单元测试

## 14.1 断言

~~~scala
def above(that:Element): Element = {
    val this1 = this widen that.width
    val that1 = that widen this.width
    assert(this1.width == that1.width)
    elem(this1.contents ++ that1.contents)
}
~~~

可以使用Predef里的名为ensuring的方法来简化这些操作

~~~scala
private def widen(w:Int): Element = 
	if (w <= width)
		this
	else {
        val left = elem(' ', (w - width) / 2, height)
        var right = elem(' ', w - width - left.width, height)
        left beside this beside right
    } ensuring (w <= _.width)
~~~

## 14.2 Scala里的单元测试

Scala的单元测试可以有许多选择，从Java实现的工具，如JUnit和TestNG，到Scala编写的新工具，如ScalaTest、specs，还有ScalaCheck。

ScalaTest提供了若干编写测试的方法，最简单的就是创建扩展org.scalatest.Suite的类并在这些类中定义测试方法。Suite代表一个测试集。测试方法以“test”开头

尽管ScalaTest包含了Runner应用，你也还是可以直接在Scala解释器中通过execute方法运行Suite。特质Suite的execute方法使用反射发现测试方法并调用它们。

由于execute可以在Suite子类型中重载，因此ScalaTest为不同风格的测试提供了遍历。比方说，ScalaTest提供了名为FunSuite的特质，重载了execute，从而可以让你以函数值的方式而不是方法定义测试。

## 14.3 翔实的失败报告

你可以在断言中放一个包含了两个值的字符串信息得到这两个值，不过还有一种更清晰的方式，就是使用三等号操作符，这是ScalaTest为了这个目的专门提供的：

~~~scala
assert(ele.width === 2)
~~~

如果断言失败了，你会在失败报告中看到“3 did not equal 2”这样的信息。

如果你希望区分实际结果和希望结果，可以改用ScalaTest的expect方法

~~~scala
expect(2) {
    ele.width
}
~~~

测试失败报告中看到“Expected 2, but got 3”的消息

是否抛出了期待的异常，可以使用ScalaTest的intercept方法，如下：

~~~scala
intercept(classOf(IllegalArgumentException)) {
    elem('x', -2, 3)
}
~~~

## 14.4 使用JUnit和TestNG

## 14.5 规格测试

行为驱动开发（behavior-driven development, BDD）测试风格中，重点放在了编写人类可读的预期代码行为的规格说明上，并辅以验证代码具有规定行为的测试。ScalaTest包含了特质Spec，以便于进行这种风格的测试。

## 14.6 基于属性的测试

## 14.7 组织和运行测试

# 第15章 样本类和模式匹配

## 15.1 简单例子

~~~scala
abstract class Expr
case class Var(name: String) extends Expr
case class Number(num: Double) extends Expr
case class UnOp(operator: String, arg: Expr) extends Expr
case class BinOp(operator: String, left: Expr, right: Expr) extends Expr
~~~

层级包括一个抽象基类Expr和四个子类，每个代表一种表达式。所有的五个类都没有类结构体。就像之前提到的，Scala里可以去掉围绕空类结构体的花括号，因此class C与 class C {}相同。

### 样本类

带有case修饰符的类被称为样本类(case class)。这种修饰符可以让Scala编译器自动给你的类添加一些句法上的便携设定。

首先，它会添加与类名一致的工厂方法。

第二个句法便捷设定是样本类参数列表中的所有参数隐式获得了val前缀，因此它被当作字段维护

第三个，是编译器为你的类添加了方法toString、hashCode和equals的“自然”实现。

样本类的最大的好处还在于它们能够支持模式匹配。

### 模式匹配

~~~scala
def simplifyTop (expr: Expr): Expr = expr match {
    case UnOp("-", UnOp("-", e)) => e // 双重负号
    case BinOp("+", e, Number(0)) => e // 加0
    case BinOp("*", e, Number(1)) => e // 乘1
    case _ => expr
}
~~~

### match与switch的比较

匹配表达式可以被看做Java风格switch的泛化。不过有三点不同要牢记在心。

首先， match是Scala的表达式，也就是说，它始终以值作为结果；

第二，Scala的备选项表达式永远不会“掉到”下一个case；

第三，如果没有模式匹配，MatchError异常会被抛出。

## 15.2 模式的种类

### 通配模式

通配模式（_）匹配任意对象

### 常量模式

常量模式仅匹配自身。

### 变量模式

变量模式类似于通配符，可以匹配任意对象。不过与通配符不同的地方在于，Scala把变量绑定在匹配的对象上。因此之后你可以使用这个变量操作对象。

用小写字母开始的简单名被当作是模式变量；所有其他的引用被认为是常量

可以通过以下两种手法之一给模式常量使用小写字母名，首先，如果常量是某个对象的字段，可以在其之上用限定符前缀。如果这不起作用（比如说，因为pi是本地变量），还可以用反引号包住变量名

### 构造器模式

构造器（模式）的存在使得模式匹配真正变得强大。假如这个名称指定了一个样本类，那么这个模式就是表示首先检查对象是该名称的样本类的成员，然后检查对象的构造器参数是符合额外提供的模式的。

这些额外的模式意味着Scala模式支持深度匹配（deep match）。这种模式不只检查顶层对象是否一致，还会检查对象的内容是否匹配内层的模式。

### 序列模式

你也可以像匹配样本类那样匹配如List或Array这样的序列类型。

~~~scala
expr match {
    case List(0, _, _) => println("found it")
    case _ =>
}
~~~

如果你想匹配一个不指定长度的序列，可以指定_*作为模式的最后元素。

### 元组模式

你还可以匹配元组。类似（a, b, c）这样的模式可以匹配任意的3-元组

### 类型模式

你可以把类型模式（typed pattern）当作类型测试和类型转换的简易替代。

~~~scala
def generalSize(x: Any) = x match {
    case s: String => s.length
    case m: Map[_, _] => m.size
    case _ => 1
}
~~~

为了测试表达式expr是String类型的，你得这么写：

~~~scala
expr.isInstanceOf[String]
~~~

要转换同样的表达式为类型String，你要写成：

~~~scala
expr.asInstanceOf[String]
~~~

#### 类型擦除

Scala使用了泛型的擦除（erasure）模式，就如Java那样。也就是说类型参数信息没有保留到运行期。

擦除规则的唯一例外就是数组，因为在Scala里和Java里，它们都被特殊处理了。数组的元素类型与数组值保存在一起，因此它可以做模式匹配。

### 变量绑定

除了独立的变量模式之外，你还可以对任何其他模式添加变量。只要简单地写上变量名、一个@符号，以及这个模式。这种写法创造了变量绑定模式。这种模式的意义在于它能像通常的那样做模式匹配，并且如果匹配成功，则把变量设置成匹配的对象，就像使用简单的变量模式那样。

举个例子，寻找一行中使用了两遍绝对值操作符的模式匹配，这样的表达式可以被简化为仅使用一次绝对值操作：

~~~scala
expr match {
    case UnOp("abs", e @ UnOp("abs", _)) => e
    case _ =>
}
~~~

## 15.3 模式守卫

模式变量仅允许在模式中出现一次。不过你可以使用模式守卫（pattern guard）重新指定这个匹配规则

~~~scala
def simplifyAdd(e: Expr) = e match {
    case BinOp("+", x, y) if x == y => BinOp("*", x, Number(2))
    case _ => e
}
~~~

模式守卫接在模式之后，开始于if。守卫可以是任意的引用模式中变量的布尔表达式。如果存在模式守卫，那么只有在守卫返回true的时候匹配才成功。

## 15.4 模式重叠

~~~scala
def simplifyAll(expr: Expr): Expr = expr match {
    case UnOp("-", UnOp("-", e)) => simplifyAll(e)
    case BinOp("+", e, Number(0)) => simplifyAll(e)
    case BinOp("*", e, Number(1)) => simplifyAll(e)
    case UnOp(op, e) => UnOp(op, simplifyAll(e))
    case BinOp(op, l, r) => BinOp(op, simplifyAll(l), simplifyAll(r))
    case _ => expr
}
~~~

全匹配的样本要跟在更具体地简化方法之后

## 15.5 封闭类

可选方案就是让样本类的超类被封闭（sealed）。封闭类除了类定义所在的文件之外不能再添加任何新的子类。

如果你使用继承自封闭类的样本类做匹配，编译器将通过警告信息标志出缺失的模式组合。

因此，如果要写打算做模式匹配的类层级，你应当考虑封闭它们。只要把关键字sealed放在最顶类的前边即可。

有时编译器弹出太过挑剔的警告。轻量级的做法是给匹配的选择器表达式添加@unchecked注解。如下：

~~~scala
def describe(e: Expr): String = (e: @unchecked) match {
    case Number(_) => "a number"
    case Var(_) => "a variable"
}
~~~

## 15.6 Option类型

分离可选值最通常的办法是通过模式匹配。例如：

~~~scala
def show(x: Option[String]) = x match {
    case Some(s) => s
    case None => "?"
}
~~~

## 15.7 模式无处不在

### 模式在变量定义中

### 用作偏函数的样本序列

### for表达式里的模式

## 15.8 一个更大的例子

# 第16章 使用列表

## 16.1 列表字面量

首先，列表是不可变的。

其次，列表具有递归结构，而数组是连续的。

## 16.2 List类型

就像数组一样，列表是同质（homogeneous）的：列表的所有元素都具有相同的类型。

Scala里的列表类型是协变（covariant）的。这意味着对于每一对类型S和T来说，如果S是T的子类型，那么List[S]是List[T]的子类型。

注意空列表的类型为List[Nothing]。你应该在11.3节看到过Nothing是Scala的类层级的底层类型。它是每个Scala类型的子类。因为列表是协变的，所以对于任意类型T的List[T]来说，List[Nothing]都是其子类。

## 16.3 构造列表

所有的列表都是由两个基础构造块Nil和::（发音为“cons”）构造出来的。

由于以冒号结尾，::操作遵循右结合规则：`A::B::C`等同于`A::(B::C)`。

## 16.4 列表的基本操作

head 返回列表的第一个元素。

tail 返回除第一个之外所有元素组成的列表。

isEmpty 如果列表为空，则返回真。

## 16.5 列表模式

你既可以用List(...)形式的模式对列表所有的元素做匹配，也可以用::操作符和Nil常量组成的模式逐位拆分列表。

## 16.6 List类的一阶方法

一阶方法是指不以函数做入参的方法。

### 连接列表

连接操作是与::接近的一种操作，写做“:::”。不过不像::，:::的两个操作元都是列表。

与cons一样，列表的连接操作也是右结合的。

### 分治原则

append

### 计算列表的长度：length方法

length方法能够计算列表的长度。

### 访问列表的尾部：init方法和last方法

last返回（非空）列表的最后一个元素，init返回除了最后一个元素之外余下的列表。

和head和tail一样的地方是，对空列表调用这些方法的时候，会抛出异常

不一样的是，head和tail运行的时间都是常量，但init和last需要遍历整个列表以计算结果。因此所耗的时间与列表的长度成正比。

### 反转列表：reverse方法

reverse创建了新的列表而不是就地改变被操作列表。

### 前缀与后缀：drop、take和splitAt

drop和take操作泛化了tail和init，它们可以返回列表任意长度的前缀或后缀。表达式“xs take n”返回xs列表的前n个元素。如果n大于xs.length，则返回整个xs。操作“xs drop n”返回xs列表除了前n个元素之外的所有元素。如果n大于xs.length，则返回空列表。

splitAt操作在指定位置拆分列表，并返回对偶（pair）列表。它的定义符合以下等式：

~~~scala
xs splitAt n 等价于 (xs take n, xs drop n)
~~~

然而，splitAt避免了对列表xs的二次遍历。

### 元素选择：apply方法和indices方法

apply方法实现了随机元素的选择；不过与数组中的同名方法相比，它使用得并不广泛。

~~~scala
abcde apply 2 // Scala中罕见
~~~

与其他类型一样，当对象出现在应该是方法调用的函数位置上时，就会隐式地插入apply方法，因此上面的代码可以缩写为：

~~~scala
abcde(2) // Scala中罕见
~~~

在列表中使用随机元素访问比在数组中要少得多，原因之一在于xs(n)花费的时间与索引值n成正比。实际上，apply仅简单定义为drop和head的组合：

~~~scala
xs apply n 等价于 (xs drop n).head
~~~

这个定义同时也说明了列表的索引范围是从0到列表长度减一。indices方法可以返回指定列表的所有有效索引值组成的列表。

### 啮合列表：zip

zip操作可以把两个列表组成一个对偶列表

如果两个列表的长度不一致，那么任何不能匹配的元素将被丢掉

常用到的情况是把列表元素与索引值啮合在一起，这时使用zipWithIndex方法会更为有效，它能把列表的每个元素与元素在列表中的位置值组成一对。

### 显示列表：toString方法和mkString方法

toString操作返回列表的标准字符串表达形式

如果你需要其他表达方式，可以使用mkString方法。xs mkString(pre, sep, post)操作有四个操作元：待显示的列表xs，需要显示在所有元素之前的前缀字符串pre，需要显示在两个元素之间的分隔符字符串sep，以及显示在最后面的后缀字符串post。

mkString方法有两个重载变体以便让你可以忽略部分乃至全部参数。第一个变体仅带有分隔符字符串：

~~~scala
xs mkString sep 等价于 xs mkString ("", sep, "")
~~~

第二个变体让你可以忽略所有的参数：

~~~scala
xs.mkString 等价于 xs mkString ""
~~~

mkString方法还有名为addString的变体，它可以把构建好的字符串添加到StringBuilder对象中，而不是作为结果返回

mkString和addString方法都继承自List的超特质Iterable，因此它们可以应用到各种可枚举的集合类上。

### 转换列表：elements、toArray、copyToArray

想要让数据存储格式在连续存放的数组和递归存放的列表之间进行转换，可以使用List类的toArray方法和Array类的toList方法

另外还有一个方法叫copyToArray，可以把列表元素复制到目标数组的一段连续空间。操作如下：

~~~scala
xs copyToArray (arr, start)
~~~

这将把列表xs的所有元素复制到数组arr中，填入位置开始为start。必须确保目标数组arr有足够的空间可以放下列表元素。

最后，如果你需要枚举器访问列表元素，可以使用elements方法

### 举例：归并排序

~~~scala
def msort[T](less: (T, T) => Boolean)(xs: List[T]): List[T] = {
    def merge(xs: List[T], ys: List[T]): List[T] = (xs, ys) match {
        case (Nil, _) => ys
        case (_, Nil) => xs
        case (x::xs1, y::ys1) => 
        	if (less(x, y)) x :: merge(xs1, ys)
        	else y :: merge(xs, ys1)
    }
    
    val n = xs.length / 2
    if (n == 0) xs
    else {
        val (ys, zs) = xs splitAt n
        merge(msort(less)(ys), msort(less)(zs))
    }
}
~~~

## 16.7 List类的高阶方法

### 列表间映射：map、flatMap和foreach

### 列表过滤：filter、partition、find、takeWhile、dropWhile和span

partition方法与filter类似，不过返回的是列表对。其中一个包含所有论断为真的元素，另一个包含所有论断为假的元素。

~~~scala
xs partition p 等价于 (xs filter p, xs filter(!p(_)))
~~~

span方法把takeWhile和dropWhile组合成一个操作，就好像splitAt组合了take和drop一样。

### 列表的论断：forall和exists

### 折叠列表：/:和:\

左折叠（fold left）操作“(z /: xs) (op)”与三个对象有关：开始值z，列表xs，以及二元操作op。折叠的结果是op 应用到前缀值z及每个相邻元素上，如下：

~~~scala
(z :/ List(a, b, c)) (op) 等价于 op(op(op(z, a), b), c)
~~~

/: 操作符产生向左侧倾斜的操作树（语法中反斜杠“/”的前进方向也有意反映了这一点）。与之相类似，操作符:\产生向右倾斜的操作树。如：

~~~scala
(List(a, b, c) :\ z) (op) 等价于 op(a, op(b, op(c, z)))
~~~

:\ 操作符被称为右折叠（fold right）。与左折叠一样带有三个操作元，不过前两个的出现次序相反：第一个操作元是待折叠的列表，第二个是开始值。

如果你喜欢，也可以使用名为foldLeft和foldRight方法，它们同样定义在List类中。

### 例子：使用折叠操作完成列表反转

### 列表排序：sort

## 16.8 List对象的方法

### 通过元素创建列表：List.apply

### 创建数值范围：List.range

List.range(from, until)，可以创建从from开始到until减一的所有数值的列表。因此尾部值until不在范围之内。

还有另外一个版本的range可以带step值作为第三参数。

### 创建统一的列表：List.make

make方法创建由相同元素的零份或多份拷贝组成的列表。

### 解除啮合列表：List.unzip

### 连接列表：List.flatten、List.concat

### 映射及测试配对列表：List.map2、List.forall2、List.exists2

## 16.9 了解Scala的类型推断算法

# 第17章 集合类型

## 17.1 集合库概览

Iterable是主要特质，它同时还是可变和不可变序列（Seq）、集（Set），以及映射（Map）的超特质。

Iterator

## 17.2 序列

### 列表

List

### 数组

Array

### 列表缓存

ListBuffer是可变对象，它可以更高效地通过添加元素的方式构建列表。ListBuffer能够支持常量时间的添加和前缀操作。元素的添加使用+=操作符，前缀使用+:操作符。完成之后，可以通过对ListBuffer调用toList方法获得List。

使用ListBuffer替代List的另一个理由是为了避免栈溢出的风险。

### 数组缓存

ArrayBuffer

### 队列（Queue）

### 栈

### 字符串（经RichString隐式转换）

RichString也是应该知道的序列，它的类型是Seq[Char]。

## 17.3 集（Set）和映射（Map）

### 使用集

### 使用映射

### 默认的（Default）集和映射

| 元素数量 | 实现                                |
| -------- | ----------------------------------- |
| 0        | scala.collection.immutable.EmptySet |
| 1        | scala.collection.immutable.Set1     |
| 2        | scala.collection.immutable.Set2     |
| 3        | scala.collection.immutable.Set3     |
| 4        | scala.collection.immutable.Set4     |
| 5或更多  | scala.collection.immutable.HashSet  |

| 元素数量 | 实现                                |
| -------- | ----------------------------------- |
| 0        | scala.collection.immutable.EmptyMap |
| 1        | scala.collection.immutable.Map1     |
| 2        | scala.collection.immutable.Map2     |
| 3        | scala.collection.immutable.Map3     |
| 4        | scala.collection.immutable.Map4     |
| 5或更多  | scala.collection.immutable.HashMap  |

### 有序的（Sorted）集和映射

有时，可能你需要集或映射的枚举器能够返回按特定顺序排列的元素。为此，Scala的集合库提供了SortedSet和SortedMap特质。

这两个特质分别由类TreeSet和TreeMap实现，它们都使用了红黑树有序地保存元素（TreeSet类）或键（TreeMap类）

### 同步的（Synchronized）集和映射

如果你需要线程安全的映射，可以把SynchronizedMap特质混入到你想要的特定类实现中。

## 17.4 可变（mutable）集合 vs. 不可变（immutable）集合

## 17.5 初始化集合

### 数组与列表之间的互转

### 集和映射的可变与不可变互转

## 17.6 元组

# 第18章 有状态的对象

## 18.1 什么让对象具有状态？

## 18.2 可重新赋值的变量和属性

Scala里，对象的每个非私有的var类型成员变量都隐含定义了getter和setter的方法。然而这些getter和setter方法的命名方式并没有沿袭Java的约定。var变量x的getter方法命名为“x”，它的setter方法命名为“x_=”。

请注意，Scala中不可以随意省略“= _”初始化器。如果写成：

~~~scala
var celsius: Float
~~~

这将定义为抽象变量，而不是未初始化的变量。

## 18.3 案例研究：离散事件模拟

## 18.4 为数字电路定制的语言

## 18.5 Simulation API

## 18.6 电路模拟

# 第19章 类型参数化

## 19.1 queues函数式队列

## 19.2 信息隐藏

### 私有构造器及工厂方法

Java中，你可以把构造器声明为私有的使其不可见。Scala中，主构造器无须明确定义；不过虽然它的定义隐含于类参数及类方法体中，还是可以通过把private修饰符添加在类参数列表的前边把主构造器隐藏起来，如清单19.2所示：

~~~scala
class Queue[T] private (
	private val leading: List[T],
    private val trailing: List[T]
)
~~~

夹在类名与其参数之间的private修饰符表明Queue的构造器是私有的：它只能被类本身及伴生对象访问。

### 可选方案：私有类

私有构造器和私有成员是隐藏类的初始化代码和表达代码的一种方式。另一种更为彻底的方式是直接把类本身隐藏掉，仅提供能够暴露类公共接口的特质。

## 19.3 变化型注解

在Scala中，泛型类型缺省的是非协变的（nonvariant）（或称为“严谨的”）子类型化。

然而，可以用如下方式改变Queue类定义的第一行，以要求队列协变（弹性）的子类型化：

~~~scala
trait Queue[+T] {...}
~~~

在正常的类型参数前加上+号表面这个参数的子类型化是协变（弹性）的。

除了+号以外，还可以前缀加上-号，这表明是需要逆变的（contravariant）子类型化。如果Queue定义如下：

~~~scala
trait Queue[-T] {...}
~~~

那么如果T是类型S的子类型，这将隐含Queue[S]是Queue[T]的子类型。

无论类型参数是协变的，逆变的，还是非协变的，都被称为参数的变化型。可以放在类型参数前的+号和-号被称为变化型注解。

### 变化型和数组

Java中数组被认为是协变的。

数组的协变被用来确保任意参考类型的数组都可以传入排序方法。当然，随着Java引入了泛型，这种排序方法现在可以带有类型参数，因此数组的协变不再有用。只是考虑到兼容的原因，直到今天它都存在于Java中。

Scala不认为数组是协变的，以尝试保持比Java更高的纯粹性。

然而，有时需要使用对象数组作为模拟泛型数组的手段与Java的遗留方法执行交互。为了满足这种情况，Scala允许你把T类型的数组造型为任意T的超类型数组：

~~~scala
val a2: Array[Object] = a1.asInstanceOf[Array[Object]]
~~~

编译时的造型始终合法，并且将在运行时永远成功，因为JVM的内含运行时模型与Java语言一致，把数组当作是协变的。

## 19.4 检查变化型注解

为了核实变化型注解的正确性，Scala编译器会把类或特质结构体的所有位置分类为正，负，或中立。所谓的“位置”是指类（或特质，但从此开始为我们只用“类”代表）的结构体内可能会用到类型参数的地方。例如，任何方法的值参数都是这种位置，因为方法值参数具有类型，所以类型参数可以出现在这个位置上。

## 19.5 下界

语法“U >: T”，定义了T为U的下界

## 19.6 逆变

## 19.7 对象私有数据

## 19.8 上界

使用“T <: Ordered[T]”语法，你指明了类型参数T具有上界，Ordered[T]。

# 第20章 抽象成员

Java允许你声明抽象方法。Scala也可以让你声明这种方法，但不仅限于此，而是在更一般性的场合实现了这一思想：除了方法之外，你还可以声明抽象字段乃至抽象类型为类和特质的成员。

## 20.1 抽象成员的快速浏览

下面的特质对每种抽象成员各声明了一个例子，它们分别是，类型（T），方法（transform），val（initial），以及var（current）：

~~~scala
trait Abstract {
    type T
    def transform(x: T): T
    val initial: T
    var current: T
}
~~~

Abstract的具体实现需要对每种抽象成员填入定义。下面的例子是提供这些定义的实现：

~~~scala
class Concrete extends Abstract {
    type T = String
    def transform(x: String) = x + x
    val initial = "hi"
    var current = initial
}
~~~

## 20.2 类型成员

使用类型成员的理由之一是为类型定义短小的、具有说明性的别名，因为类型的实际名称可能比别名要更冗长，或语义不清。

类型成员的另一种主要用途是声明必须被定义为子类的抽象类型。

## 20.3 抽象val

抽象的val限制了合法的实现方式：任何实现都必须是val类型的定义；不可以是var或def。

## 20.4 抽象var

## 20.5 初始化抽象val

抽象val有时会扮演类似于超类的参数这样的角色：它们能够让你在子类中提供超类缺少的细节信息。这对于特质来说尤其重要，因为特质缺少能够用来传递参数的构造器。因此通常参数化特质的方式就是通过需要在子类中实现的抽象val完成。

### fields预初始化字段

第一种解决方案，预初始化字段，可以让你在调用超类之前初始化子类的字段。操作的方式是把字段定义加上花括号，放在超类构造器调用之前。

### 懒加载val

这一目的可以通过让你的val定义变成懒惰的（lazy）来达成。如果你把lazy修饰符前缀在val定义上，那么右侧的初始化表达式将直到val第一次被使用的时候才计算。

## 20.6 抽象类型

## 20.7 路径依赖类型

## 20.8 枚举

Scala不需要关于枚举的特别语法，而是代之以标准库中的类，scala.Enumeration。想要创建新的枚举，只需定义扩展这个类的对象即可，下面的例子定义了新的Color枚举：

~~~scala
object Color extends Enumeration {
    val Red = Value
    val Green = Value
    val Blue = Value
}
~~~

Scala还能让你简化掉若干右侧一致的相连val或var定义。与上面等价，你也可以写成：

~~~scala
object Color extends Enumeration {
    val Red, Green, Blue = Value
}
~~~

Enumeration定义了内部类，名为Value，以及同名的无参方法Value返回该类的新对象。

## 20.9 案例研究：货币

# 第21章 隐式转换和参数

你的代码与其他人的库函数之间有项根本的差别：你可以随意改变或者扩展自己的代码，但如果你想要使用别人的库函数，通常只能原封不动。

为了缓解这一问题，各种编程语言中涌现除了许多灵感：Ruby引入了模块，Smalltalk让不同的包能够加入各自的类中。这些都很有好处，但也非常危险，因为你改变了整个程序中类的行为，其中可能有你想不到的问题。C#3.0有静态扩展方法，它更为本地化，同时也更为局限，你只能对类添加方法，而不能添加字段，并且不能让类实现新的接口。

Scala的办法是隐式转换和隐式参数。

## 21.1 隐式转换

为了让String表现为RandomAccessSeq的子类，你需要定义从String到实际为RandomAccessSeq子类的适配类隐式转换。

~~~scala
implicit def stringWrapper(s: String) =
	new RandomAccessSeq[Char] {
        def length = s.length
        def apply(i:Int) = s.charAt(i)
    }
~~~

## 21.2 隐式操作规则

隐式转换由以下通用规则掌控：

标记规则：只有标记为implicit的定义才是可用的。implicit关键字被用来标记编译器可以用于隐式操作的声明。你可以使用它标记任何变量，函数，或对象定义。

作用域规则：插入的隐式转换必须以单一标识符的形式处于作用域中，或与转换的源或目标类型关联在一起。

“单一标识符”规则有一个例外。编译器还将在原类型或转换的期望目标类型的伴生对象中寻找隐式定义。

无歧义规则：隐式转换唯有不存在其他可插入转换的前提下才能插入。

单一调用规则：只会尝试一个隐式操作。编译器将不会把x+y重写成convert1(convert2(x))+y。

显式操作先行规则：若编写的代码类型检查无误，则不会尝试任何隐式操作。

命名隐式转换。隐式转换可以任意命名。

隐式操作在哪里尝试。Scala语言中能用到隐式操作的有三个地方：转换为期望类型、指定（方法）调用者的转换、隐式参数。

## 21.3 隐式转换为期望类型

## 21.4 转换（方法调用的）接收者

### 与新类型的交互操作

### 模拟新的语法

## 21.5 隐式参数

## 21.6 视界

可以认为“T <% Ordered[T]”是在说，“任何的T都好，只要T能被当作Ordered[T]即可。”

## 21.7 隐式操作调试

把这些转换明确写出来有助于发现问题。

调试程序的时候，如果能看到编译器正在插入的隐式转换可能会有一些帮助。编译器的-Xprint:typer选项可以用于这一目的。

# 第22章 实现列表

## 22.1 List类原理

列表并非Scala的“内建”语言结构，它们由List抽象类定义在Scala包之中，并且包含了两个子类——::和Nil。

### Nil对象

Nil对象定义了空列表。Nil对象继承自List[Nothing]类型。

### ::类

::类，发音为“cons”，意为“构造”，代表非空列表。如此命名是为了能够用中缀::支持模式匹配。

### 更多的类方法

### 列表构建

## 22.2 ListBuffer类

## 22.3 实际的List类

## 22.4 外在的函数式（风格）

# 第23章 重访For表达式

实际上，Scala编译器根本就是把第二个查询转译成了第一个。更为一般的说法是，所有的能够yield（产生）结果的for表达式都会被编译器转译为高阶方法map、flatMap及filter的组合调用。所有的不带yield的for循环都会被转译为仅对高阶函数filter和foreach的调用。

## 23.1 For表达式

通常，for表达式的形式如下：

~~~scala
for ( seq ) yield expr
~~~

这里，seq由生成器、定义及过滤器组成序列，以分号分隔。

生成器的形式如下：

~~~scala
pat <- expr
~~~

定义的形式如下：

~~~scala
pat = expr
~~~

过滤器的形式如下：

~~~scala
if expr
~~~

所有的for表达式都以生成器开始。如果for表达式中有若干生成器，那么后面的生成器比前面的变化的更快。（即前面的每变化一次，后面的变化一轮）

## 23.2 皇后问题

