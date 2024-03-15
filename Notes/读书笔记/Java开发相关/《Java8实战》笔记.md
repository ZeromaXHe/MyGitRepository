# 第一部分 基础知识

# 第1章 为什么要关心Java8

## 1.1 Java怎么还在变

### 1.1.2 流处理

Java8可以透明地把输入的不相关部分拿到几个CPU内核上去分别执行你的Stream操作流水线——这几乎免费的并行，用不着去费劲搞Thread了。

# 第3章 Lambda表达式

## 3.2 在哪里以及如何使用Lambda

### 3.2.2 函数描述符

@FunctionalInterface又是怎么一回事？

这个标注用于表示该接口会设计成一个函数式接口。如果你用@FunctionalInterface定义了一个接口，而它却不是函数式接口的话，编译器将返回一个提示原因的错误。例如，错误信息可能是“Multiple non-overriding abstract methods found in interface Foo”，表明存在多个抽象方法。请注意，@FunctionalInterface不是必需的，但对于为此设计的接口而言，使用它是比较好的做法。它就像是@Override标注表示方法被重写了。

## 3.4 使用函数式接口

### 3.4.3 Function

异常、Lambda，还有函数式接口又是怎么回事呢？

请注意，任何函数式接口都不允许抛出受检异常（checked exception）。如果你需要Lambda表达式来抛出异常，有两种办法：定义一个自己的函数式接口，并声明受检异常，或者把Lambda包在一个try/catch块中。

## 3.5 类型检查、类型推断以及限制

### 3.5.4 使用局部变量

尽管如此，还有一点点小麻烦：关于能对这些变量做什么有一些限制。 Lambda可以没有限制地捕获（也就是在其主体中引用）实例变量和静态变量。但局部变量必须显式声明为final，或事实上是final。换句话说， Lambda表达式只能捕获指派给它们的局部变量一次。（注：捕获实例变量可以被看作捕获最终局部变量this。） 例如，下面的代码无法编译，因为portNumber变量被赋值两次：

~~~ java
int portNumber = 1337;
Runnable r = () -> System.out.println(portNumber);
portNumber = 31337;
~~~

对局部变量的限制

你可能会问自己，为什么局部变量有这些限制。第一，实例变量和局部变量背后的实现有一个关键不同。实例变量都存储在堆中，而局部变量则保存在栈上。如果Lambda可以直接访问局部变量，而且Lambda是在一个线程中使用的，则使用Lambda的线程，可能会在分配该变量的线程将这个变量收回之后，去访问该变量。因此， Java在访问自由局部变量时，实际上是在访问它的副本，而不是访问原始变量。如果局部变量仅仅赋值一次那就没有什么区别了——因此就有了这个限制。

第二，这一限制不鼓励你使用改变外部变量的典型命令式编程模式（我们会在以后的各章中解释，这种模式会阻碍很容易做到的并行处理）。

## 3.6 方法引用

### 3.6.2 构造方法引用

对于一个现有构造函数，你可以利用它的名称和关键字new来创建它的一个引用：`ClassName::new`。它的功能与指向静态方法的引用类似。例如，假设有一个构造函数没有参数。它适合Supplier的签名`() -> Apple`。你可以这样做：

```java
Supplier<Apple> c1 = Apple::new;
Apple a1 = c1.get();
```
这就等价于：

```java
Supplier<Apple> c1 = () -> new Apple();
Apple a1 = c1.get();
```

如果你的构造函数的签名是Apple(Integer weight)，那么它就适合Function接口的签名，于是你可以这样写：

```java
Function<Integer, Apple> c2 = Apple::new;
Apple a2 = c2.apply(110);
```

这就等价于：

```java
Function<Integer, Apple> c2 = (weight) -> new Apple(weight);
Apple a2 = c2.apply(110);
```

如果你有一个具有两个参数的构造函数Apple(String color, Integer weight)，那么它就适合BiFunction接口的签名，于是你可以这样写：

```java
BiFunction<String, Integer, Apple> c3 = Apple::new;
Apple a3 = c3.apply("green", 110);
```

这就等价于：

~~~java
BiFunction<String, Integer, Apple> c3 =
    (color, weight) -> new Apple(color, weight);
Apple a3 = c3.apply("green", 110);
~~~

测验3.7：构造函数引用

你已经看到了如何将有零个、一个、两个参数的构造函数转变为构造函数引用。那要怎么样才能对具有三个参数的构造函数，比如Color(int, int, int)， 使用构造函数引用呢？

答案：你看，构造函数引用的语法是ClassName::new，那么在这个例子里面就是Color::new。但是你需要与构造函数引用的签名匹配的函数式接口。但是语言本身并没有提供这样的函数式接口，你可以自己创建一个：
~~~java
public interface TriFunction<T, U, V, R>{
    R apply(T t, U u, V v);
}
~~~
现在你可以像下面这样使用构造函数引用了：
~~~java
TriFunction<Integer, Integer, Integer, Color> colorFactory = Color::new;
~~~

## 3.8 复合Lambda表达式的有用方法

### 3.8.1 比较器复合

我们前面看到，你可以使用静态方法Comparator.comparing，根据提取用于比较的键值的Function来返回一个Comparator，如下所示：
~~~java
Comparator<Apple> c = Comparator.comparing(Apple::getWeight);
~~~
1.逆序

如果你想要对苹果按重量递减排序怎么办？用不着去建立另一个Comparator的实例。接口有一个默认方法reversed可以使给定的比较器逆序。因此仍然用开始的那个比较器，只要修改一下前一个例子就可以对苹果按重量递减排序：
~~~java
inventory.sort(comparing(Apple::getWeight).reversed());
~~~
2.比较器链

上面说得都很好，但如果发现有两个苹果一样重怎么办？哪个苹果应该排在前面呢？你可能需要再提供一个Comparator来进一步定义这个比较。比如，在按重量比较两个苹果之后，你可能想要按原产国排序。 thenComparing方法就是做这个用的。它接受一个函数作为参数（就像comparing方法一样），如果两个对象用第一个Comparator比较之后是一样的，就提供第二个Comparator。你又可以优雅地解决这个问题了：
~~~java
inventory.sort(comparing(Apple::getWeight)
    .reversed()
    .thenComparing(Apple::getCountry));
~~~

### 3.8.2 谓词复合

谓词接口包括三个方法： negate、 and和or，让你可以重用已有的Predicate来创建更复杂的谓词。比如，你可以使用negate方法来返回一个Predicate的非，比如苹果不是红的：
~~~java
Predicate<Apple> notRedApple = redApple.negate();
~~~
你可能想要把两个Lambda用and方法组合起来，比如一个苹果既是红色又比较重：
~~~java
Predicate<Apple> redAndHeavyApple =
    redApple.and(a -> a.getWeight() > 150);
~~~
你可以进一步组合谓词，表达要么是重（ 150克以上）的红苹果，要么是绿苹果：
~~~java
Predicate<Apple> redAndHeavyAppleOrGreen =
    redApple.and(a -> a.getWeight() > 150)
    .or(a -> "green".equals(a.getColor()));
~~~
这一点为什么很好呢？从简单Lambda表达式出发，你可以构建更复杂的表达式，但读起来仍然和问题的陈述差不多！请注意， and和or方法是按照在表达式链中的位置，从左向右确定优先级的。因此， a.or(b).and(c)可以看作(a || b) && c。

### 3.8.3 函数复合

最后，你还可以把Function接口所代表的Lambda表达式复合起来。 Function接口为此配了andThen和compose两个默认方法，它们都会返回Function的一个实例。

andThen方法会返回一个函数，它先对输入应用一个给定函数，再对输出应用另一个函数。

你也可以类似地使用compose方法，先把给定的函数用作compose的参数里面给的那个函数，然后再把函数本身用于结果。比如在上一个例子里用compose的话，它将意味着f(g(x))，而andThen则意味着g(f(x))

# 第二部分 函数式数据处理

# 第4章 引入流

## 4.3 流与集合

### 4.3.1 只能遍历一次

请注意，和迭代器类似，流只能遍历一次。遍历完之后，我们就说这个流已经被消费掉了。你可以从原始数据源那里再获得一个新的流来重新遍历一遍，就像迭代器一样（这里假设它是集合之类的可重复的源，如果是I/O通道就没戏了）。例如，以下代码会抛出一个异常，说流已被消费掉了：
~~~java
List<String> title = Arrays.asList("Java8", "In", "Action");
Stream<String> s = title.stream();
s.forEach(System.out::println);
s.forEach(System.out::println); // java.lang.IllegalStateException: 流已被操作或关闭
~~~
所以要记得，流只能消费一次！

# 第5章 使用流

## 5.1 筛选和切片

### 5.1.1 用谓词筛选

Streams接口支持filter方法（你现在应该很熟悉了）。该操作会接受一个谓词（一个返回boolean的函数）作为参数，并返回一个包括所有符合谓词的元素的流。

### 5.1.2 筛选各异的元素

流还支持一个叫作distinct的方法，它会返回一个元素各异（根据流所生成元素的 hashCode和equals方法实现）的流。

### 5.1.3 截短流

流支持limit(n)方法，该方法会返回一个不超过给定长度的流。所需的长度作为参数传递给limit。如果流是有序的，则最多会返回前n个元素。请注意limit也可以用在无序流上，比如源是一个Set。这种情况下， limit的结果不会以任何顺序排列。

### 5.1.4 跳过元素

流还支持skip(n)方法，返回一个扔掉了前n个元素的流。如果流中元素不足n个，则返回一个空流。请注意， limit(n)和skip(n)是互补的！

## 5.2 映射

### 5.2.1 对流中每一个元素应用函数

流支持map方法，它会接受一个函数作为参数。这个函数会被应用到每个元素上，并将其映射成一个新的元素（使用映射一词，是因为它和转换类似，但其中的细微差别在于它是“创建一个新版本”而不是去“修改”）

如果你要找出每道菜的名称有多长，怎么做？你可以像下面这样，再链接上一个map：

~~~java
List<Integer> dishNameLengths = menu.stream()
    .map(Dish::getName)
    .map(String::length)
    .collect(toList());
~~~

### 5.2.2 流的扁平化

使用flatMap方法的效果是，各个数组并不是分别映射成一个流，而是映射成流的内容。所有使用map(Arrays::stream)时生成的单个流都被合并起来，即扁平化为一个流。

## 5.3 查找和匹配

### 5.3.1 检查谓词是否至少匹配一个元素

anyMatch方法可以回答“流中是否有一个元素能匹配给定的谓词”。

### 5.3.2 检查谓词是否匹配所有元素

allMatch方法的工作原理和anyMatch类似，但它会看看流中的元素是否都能匹配给定的谓词。和allMatch相对的是noneMatch。它可以确保流中没有任何元素与给定的谓词匹配。

anyMatch、 allMatch和noneMatch这三个操作都用到了我们所谓的短路，这就是大家熟悉的Java中&&和||运算符短路在流中的版本。

### 5.3.3 查找元素

findAny方法将返回当前流中的任意元素。它可以与其他流操作结合使用。

~~~java
Optional<Dish> dish =
    menu.stream()
    .filter(Dish::isVegetarian)
    .findAny();
~~~
Optional\<T>类（ java.util.Optional）是一个容器类，代表一个值存在或不存在。在上面的代码中， findAny可能什么元素都没找到。 Java 8的库设计人员引入了Optional\<T>，这样就不用返回众所周知容易出问题的null了。

Optional里面几种可以迫使你显式地检查值是否存在或处理值不存在的情形的方法也不错。

- isPresent()将在Optional包含值的时候返回true, 否则返回false。
- ifPresent(Consumer\<T> block)会在值存在的时候执行给定的代码块。我们在第3章介绍了Consumer函数式接口；它让你传递一个接收T类型参数，并返回void的Lambda表达式。
- T get()会在值存在时返回值，否则抛出一个NoSuchElement异常。
- T orElse(T other)会在值存在时返回值，否则返回一个默认值。

例如，在前面的代码中你需要显式地检查Optional对象中是否存在一道菜可以访问其名称：
~~~java
menu.stream()
    .filter(Dish::isVegetarian)
    .findAny()
    .ifPresent(d -> System.out.println(d.getName());
~~~

### 5.3.4 查找第一个元素

有些流有一个出现顺序（ encounter order）来指定流中项目出现的逻辑顺序（比如由List或排序好的数据列生成的流）。对于这种流，你可能想要找到第一个元素。为此有一个findFirst方法，它的工作方式类似于findAny。

何时使用findFirst和findAny

你可能会想，为什么会同时有findFirst和findAny呢？答案是并行。找到第一个元素在并行上限制更多。如果你不关心返回的元素是哪个，请使用findAny，因为它在使用并行流时限制较少。

## 5.4 规约

到目前为止，你见到过的终端操作都是返回一个boolean（ allMatch之类的）、 void（ forEach）或Optional对象（ findAny等）。你也见过了使用collect来将流中的所有元素组合成一个List。

在本节中，你将看到如何把一个流中的元素组合起来，使用reduce操作来表达更复杂的查询，比如“计算菜单中的总卡路里”或“菜单中卡路里最高的菜是哪一个”。此类查询需要将流中所有元素反复结合起来，得到一个值，比如一个Integer。这样的查询可以被归类为归约操作（将流归约成一个值）。用函数式编程语言的术语来说，这称为折叠(fold），因为你可以将这个操作看成把一张长长的纸（你的流）反复折叠成一个小方块，而这就是折叠操作的结果。

你可以像下面这样对流中所有的元素求和：
~~~java
int sum = numbers.stream().reduce(0, (a, b) -> a + b);
~~~
你也很容易把所有的元素相乘，只需要将另一个Lambda： (a, b) -> a * b传递给reduce操作就可以了：
~~~java
int product = numbers.stream().reduce(1, (a, b) -> a * b);
~~~
你可以使用方法引用让这段代码更简洁。在Java 8中， Integer类现在有了一个静态的sum方法来对两个数求和，这恰好是我们想要的，用不着反复用Lambda写同一段代码了：
~~~java
int sum = numbers.stream().reduce(0, Integer::sum);
~~~
reduce还有一个重载的变体，它不接受初始值，但是会返回一个Optional对象：
~~~java
Optional<Integer> sum = numbers.stream().reduce((a, b) -> (a + b));
~~~
为什么它返回一个Optional\<Integer>呢？考虑流中没有任何元素的情况。 reduce操作无法返回其和，因为它没有初始值。这就是为什么结果被包裹在一个Optional对象里，以表明和可能不存在。

你可以像下面这样使用reduce来计算流中的最大值:
~~~java
Optional<Integer> max = numbers.stream().reduce(Integer::max);
~~~
要计算最小值，你需要把Integer.min传给reduce来替换Integer.max：
~~~java
Optional<Integer> min = numbers.stream().reduce(Integer::min);
~~~

**归约方法的优势与并行化**

相比于前面写的逐步迭代求和，使用reduce的好处在于，这里的迭代被内部迭代抽象掉了，这让内部实现得以选择并行执行reduce操作。而迭代式求和例子要更新共享变量sum，这不是那么容易并行化的。如果你加入了同步，很可能会发现线程竞争抵消了并行本应带来的性能提升！这种计算的并行化需要另一种办法：将输入分块，分块求和，最后再合并起来。但这样的话代码看起来就完全不一样了。你在第7章会看到使用分支/合并框架来做是什么样子。但现在重要的是要认识到，可变的累加器模式对于并行化来说是死路一条。你需要一种新的模式，这正是reduce所提供的。你还将在第7章看到，使用流来对所有的元素并行求和时，你的代码几乎不用修改： stream()换成了parallelStream()。
~~~java
int sum = numbers.parallelStream().reduce(0, Integer::sum);
~~~
但要并行执行这段代码也要付一定代价，我们稍后会向你解释：传递给reduce的Lambda不能更改状态（如实例变量），而且操作必须满足结合律才可以按任意顺序执行。

**流操作：无状态和有状态**

你已经看到了很多的流操作。乍一看流操作简直是灵丹妙药，而且只要在从集合生成流的时候把Stream换成parallelStream就可以实现并行。

当然，对于许多应用来说确实是这样，就像前面的那些例子。你可以把一张菜单变成流，用filter选出某一类的菜肴，然后对得到的流做map来对卡路里求和，最后reduce得到菜单的总热量。这个流计算甚至可以并行进行。但这些操作的特性并不相同。它们需要操作的内部状态还是有些问题的。

诸如map或filter等操作会从输入流中获取每一个元素，并在输出流中得到0或1个结果。这些操作一般都是**无状态**的：它们没有内部状态（假设用户提供的Lambda或方法引用没有内部可变状态）。

但诸如reduce、 sum、 max等操作需要内部状态来累积结果。在上面的情况下，内部状态很小。在我们的例子里就是一个int或double。不管流中有多少元素要处理，内部状态都是有界的。

相反，诸如sort或distinct等操作一开始都和filter和map差不多——都是接受一个流，再生成一个流（中间操作），但有一个关键的区别。从流中排序和删除重复项时都需要知道先前的历史。例如，排序要求所有元素都放入缓冲区后才能给输出流加入一个项目，这一操作的存储要求是无界的。要是流比较大或是无限的，就可能会有问题（把质数流倒序会做什么呢？它应当返回最大的质数，但数学告诉我们它不存在）。我们把这些操作叫作**有状态操作**。

| 操作      | 类型              | 返回类型    | 使用的类型/函数式接口  | 函数描述符     |
| --------- | ----------------- | ----------- | ---------------------- | -------------- |
| filter    | 中间              | Stream\<T>   | Predicate\<T>           | T -> boolean   |
| distinct  | 中间(有状态-无界) | Stream\<T>   |                        |                |
| skip      | 中间(有状态-有界) | Stream\<T>   | long                   |                |
| limit     | 中间(有状态-有界) | Stream\<T> | long                   |                |
| map       | 中间              | Stream\<R>  | Function\<T, R>         | T -> R         |
| flatMap   | 中间              | Stream\<R>  | Function\<T, Stream\<R>> | T -> Stream\<R> |
| sorted    | 中间(有状态-无界) | Stream\<T>  | Comparator\<T>          | (T, T) -> int  |
| anyMatch  | 终端              | boolean     | Predicate\<T>           | T -> boolean   |
| noneMatch | 终端              | boolean     | Predicate\<T>           | T -> boolean   |
| allMatch  | 终端              | boolean     | Predicate\<T>           | T -> boolean   |
| findAny   | 终端              | Optional\<T> |                        |                |
| findFirst | 终端              | Optional\<T> |                        |                |
| forEach   | 终端              | void        | Consumer\<T>            | T -> void      |
| collect   | 终端              | R           | Collector\<T, A, R>     |                |
| reduce    | 终端(有状态-有界) | Optional\<T> | BinaryOperator\<T>      | (T, T) -> T    |
| count     | 终端              | long        |                        |                |

## 5.6 数值流

我们在前面看到了可以使用reduce方法计算流中元素的总和。例如，你可以像下面这样计算菜单的热量：
~~~java
int calories = menu.stream()
    .map(Dish::getCalories)
    .reduce(0, Integer::sum);
~~~
这段代码的问题是，它有一个暗含的装箱成本。每个Integer都必须拆箱成一个原始类型，再进行求和。

但不要担心， Stream API还提供了原始类型流特化，专门支持处理数值流的方法。

### 5.6.1 原始类型流特化

Java 8引入了三个原始类型特化流接口来解决这个问题： IntStream、 DoubleStream和LongStream，分别将流中的元素特化为int、 long和double，从而避免了暗含的装箱成本。每个接口都带来了进行常用数值归约的新方法，比如对数值流求和的sum，找到最大元素的max。此外还有在必要时再把它们转换回对象流的方法。要记住的是，这些特化的原因并不在于流的复杂性，而是装箱造成的复杂性——即类似int和Integer之间的效率差异。

**1. 映射到数值流**

将流转换为特化版本的常用方法是mapToInt、 mapToDouble和mapToLong。这些方法和前面说的map方法的工作方式一样，只是它们返回的是一个特化流，而不是Stream\<T>。例如，你可以像下面这样用mapToInt对menu中的卡路里求和：
~~~java
int calories = menu.stream()
    .mapToInt(Dish::getCalories)
    .sum();
~~~
这里， mapToInt会从每道菜中提取热量（用一个Integer表示），并返回一个IntStream（而不是一个Stream\<Integer>）。然后你就可以调用IntStream接口中定义的sum方法，对卡路里求和了！请注意，如果流是空的， sum默认返回0。 IntStream还支持其他的方便方法，如max、 min、 average等。

**2. 转换回对象流**

同样，一旦有了数值流，你可能会想把它转换回非特化流。例如， IntStream上的操作只能产生原始整数：IntStream 的 map 操作接受的Lambda必须接受int并返回 int（一个IntUnaryOperator）。但是你可能想要生成另一类值，比如Dish。为此，你需要访问Stream接口中定义的那些更广义的操作。要把原始流转换成一般流（每个int都会装箱成一个Integer），可以使用boxed方法，如下所示：

~~~java
IntStream intStream = menu.stream().mapToInt(Dish::getCalories);
Stream<Integer> stream = intStream.boxed();
~~~

在下一节中会看到，在需要将数值范围装箱成为一个一般流时， boxed尤其有用。  

**3. 默认值OptionalInt  **

求和的那个例子很容易，因为它有一个默认值： 0。但是，如果你要计算IntStream中的最大元素，就得换个法子了，因为0是错误的结果。如何区分没有元素的流和最大值真的是0的流呢？前面我们介绍了Optional类，这是一个可以表示值存在或不存在的容器。 Optional可以用Integer、 String等参考类型来参数化。对于三种原始流特化，也分别有一个Optional原始类型特化版本： OptionalInt、 OptionalDouble和OptionalLong。

例如，要找到IntStream中的最大元素，可以调用max方法，它会返回一个OptionalInt：

~~~java
OptionalInt maxCalories = menu.stream()
	.mapToInt(Dish::getCalories)
	.max();
~~~

现在，如果没有最大值的话，你就可以显式处理OptionalInt去定义一个默认值了：

~~~java
int max = maxCalories.orElse(1);  
~~~

### 5.6.2 数值范围

和数字打交道时，有一个常用的东西就是数值范围。比如，假设你想要生成1和100之间的所有数字。 Java 8引入了两个可以用于IntStream和LongStream的静态方法，帮助生成这种范围：range和rangeClosed。这两个方法都是第一个参数接受起始值，第二个参数接受结束值。但range是不包含结束值的，而rangeClosed则包含结束值。  

~~~java
IntStream evenNumbers = IntStream.rangeClosed(1, 100)
	.filter(n -> n % 2 == 0);
System.out.println(evenNumbers.count());
~~~

这里我们用了rangeClosed方法来生成1到100之间的所有数字。它会产生一个流，然后你可以链接filter方法，只选出偶数。到目前为止还没有进行任何计算。最后，你对生成的流调用count。因为count是一个终端操作，所以它会处理流，并返回结果50，这正是1到100（包括两端）中所有偶数的个数。请注意，比较一下，如果改用IntStream.range(1, 100)，则结果将会是49个偶数，因为range是不包含结束值的。

### 5.6.3 数值流应用：勾股数

~~~java
Stream<int[]> pythagoreanTriples =
    IntStream.rangeClosed(1, 100).boxed()
        .flatMap(a ->
            IntStream.rangeClosed(a, 100)
                .filter(b -> Math.sqrt(a*a + b*b) % 1 == 0)
                .mapToObj(b ->
                    new int[]{a, b, (int)Math.sqrt(a * a + b * b)})
        );
~~~

更好的方法：

~~~java
Stream<double[]> pythagoreanTriples2 =
    IntStream.rangeClosed(1, 100).boxed()
        .flatMap(a ->
            IntStream.rangeClosed(a, 100)
                .mapToObj(
                    b -> new double[]{a, b, Math.sqrt(a*a + b*b)})
                .filter(t -> t[2] % 1 == 0));
~~~

## 5.7 构建流

### 5.7.1 由值创建流

你可以使用静态方法Stream.of，通过显式值创建一个流。它可以接受任意数量的参数。
~~~java
Stream<String> stream = Stream.of("Java 8 ", "Lambdas ", "In ", "Action");
stream.map(String::toUpperCase).forEach(System.out::println);
~~~

你可以使用empty得到一个空流，如下所示：
~~~java
Stream<String> emptyStream = Stream.empty();
~~~

### 5.7.2 由数组创建流

你可以使用静态方法Arrays.stream从数组创建一个流。它接受一个数组作为参数。例如，你可以将一个原始类型int的数组转换成一个IntStream，如下所示：
~~~java
int[] numbers = {2, 3, 5, 7, 11, 13};
int sum = Arrays.stream(numbers).sum();
~~~

### 5.7.3 由文件生成流

Java中用于处理文件等I/O操作的NIO API（非阻塞 I/O）已更新，以便利用Stream API。java.nio.file.Files中的很多静态方法都会返回一个流。例如，一个很有用的方法是Files.lines，它会返回一个由指定文件中的各行构成的字符串流。使用你迄今所学的内容，你可以用这个方法看看一个文件中有多少各不相同的词：
~~~java
long uniqueWords = 0;
try(Stream<String> lines =
    Files.lines(Paths.get("data.txt"), Charset.defaultCharset())){
uniqueWords = lines.flatMap(line -> Arrays.stream(line.split(" ")))
    .distinct()
    .count();
}
catch(IOException e){
}
~~~

### 5.7.4 由函数生成流：创建无限流

Stream API提供了两个静态方法来从函数生成流： Stream.iterate和Stream.generate。这两个操作可以创建所谓的无限流：不像从固定集合创建的流那样有固定大小的流。由iterate和generate产生的流会用给定的函数按需创建值，因此可以无穷无尽地计算下去！一般来说，应该使用limit(n)来对这种流加以限制，以避免打印无穷多个值。

1. 迭代

我们先来看一个iterate的简单例子，然后再解释：
~~~java
Stream.iterate(0, n -> n + 2)
.limit(10)
.forEach(System.out::println);
~~~
iterate方法接受一个初始值（在这里是0），还有一个依次应用在每个产生的新值上的Lambda（ UnaryOperator<t>类型）。

测验5.4：斐波那契元组序列：
~~~java
Stream.iterate(new int[]{0, 1},
        t -> new int[]{t[1], t[0]+t[1]})
    .limit(20)
    .forEach(t -> System.out.println("(" + t[0] + "," + t[1] +")"));
~~~

2. 生成

与iterate方法类似， generate方法也可让你按需生成一个无限流。但generate不是依次对每个新生成的值应用函数的。它接受一个Supplier<T>类型的Lambda提供新的值。我们先来看一个简单的用法：
~~~java
Stream.generate(Math::random)
    .limit(5)
    .forEach(System.out::println);
~~~

下面的代码就是如何创建一个在调用时返回下一个斐波纳契项的IntSupplier：
~~~java
IntSupplier fib = new IntSupplier(){
    private int previous = 0;
    private int current = 1;
    public int getAsInt(){
        int oldPrevious = this.previous;
        int nextValue = this.previous + this.current;
        this.previous = this.current;
        this.current = nextValue;
        return oldPrevious;
    }
};
IntStream.generate(fib).limit(10).forEach(System.out::println);
~~~
前面的代码创建了一个IntSupplier的实例。此对象有可变的状态：它在两个实例变量中记录了前一个斐波纳契项和当前的斐波纳契项。 getAsInt在调用时会改变对象的状态，由此在每次调用时产生新的值。相比之下， 使用iterate的方法则是纯粹不变的：它没有修改现有状态，但在每次迭代时会创建新的元组。你将在第7章了解到，你应该始终采用不变的方法，以便并行处理流，并保持结果正确。

# 第6章 用流收集数据

## 6.2 规约和汇总

我们先来举一个简单的例子，利用counting工厂方法返回的收集器，数一数菜单里有多少种菜：
~~~java
long howManyDishes = menu.stream().collect(Collectors.counting());
~~~
这还可以写得更为直接：
~~~java
long howManyDishes = menu.stream().count();
~~~

### 6.2.1 查找流中的最大值和最小值

你可以使用两个收集器， Collectors.maxBy和Collectors.minBy，来计算流中的最大或最小值。这两个收集器接收一个Comparator参数来比较流中的元素。你可以创建一个Comparator来根据所含热量对菜肴进行比较，并把它传递给Collectors.maxBy：
~~~java
Comparator<Dish> dishCaloriesComparator =
    Comparator.comparingInt(Dish::getCalories);
Optional<Dish> mostCalorieDish =
    menu.stream()
        .collect(maxBy(dishCaloriesComparator));
~~~

### 6.2.2 汇总

Collectors类专门为汇总提供了一个工厂方法： Collectors.summingInt。它可接受一个把对象映射为求和所需int的函数，并返回一个收集器；该收集器在传递给普通的collect方法后即执行我们需要的汇总操作。举个例子来说，你可以这样求出菜单列表的总热量：
~~~java
int totalCalories = menu.stream().collect(summingInt(Dish::getCalories));
~~~
Collectors.summingLong和Collectors.summingDouble方法的作用完全一样，可以用于求和字段为long或double的情况。

但汇总不仅仅是求和；还有Collectors.averagingInt，连同对应的averagingLong和averagingDouble可以计算数值的平均数：
~~~java
double avgCalories =
    menu.stream().collect(averagingInt(Dish::getCalories));
~~~

不过很多时候，你可能想要得到两个或更多这样的结果，而且你希望只需一次操作就可以完成。在这种情况下，你可以使用summarizingInt工厂方法返回的收集器。例如，通过一次summarizing操作你可以就数出菜单中元素的个数，并得到菜肴热量总和、平均值、最大值和最小值：
~~~java
IntSummaryStatistics menuStatistics =
    menu.stream().collect(summarizingInt(Dish::getCalories));
~~~
这个收集器会把所有这些信息收集到一个叫作IntSummaryStatistics的类里，它提供了方便的取值（ getter）方法来访问结果。打印menuStatisticobject会得到以下输出：
~~~java
IntSummaryStatistics{count=9, sum=4300, min=120,
                     average=477.777778, max=800}
~~~
同样，相应的summarizingLong和summarizingDouble工厂方法有相关的LongSummaryStatistics和DoubleSummaryStatistics类型，适用于收集的属性是原始类型long或double的情况

### 6.2.3 连接字符串

joining工厂方法返回的收集器会把对流中每一个对象应用toString方法得到的所有字符串连接成一个字符串。这意味着你把菜单中所有菜肴的名称连接起来，如下所示：
~~~java
String shortMenu = menu.stream().map(Dish::getName).collect(joining());
~~~
请注意， joining在内部使用了StringBuilder来把生成的字符串逐个追加起来。此外还要注意，如果Dish类有一个toString方法来返回菜肴的名称，那你无需用提取每一道菜名称的函数来对原流做映射就能够得到相同的结果：
~~~java
String shortMenu = menu.stream().collect(joining());
~~~
二者均可产生以下字符串：
`porkbeefchickenfrench friesriceseason fruitpizzaprawnssalmon`
但该字符串的可读性并不好。幸好， joining工厂方法有一个重载版本可以接受元素之间的分界符，这样你就可以得到一个逗号分隔的菜肴名称列表：
~~~java
String shortMenu = menu.stream().map(Dish::getName).collect(joining(", "));
~~~
正如我们预期的那样，它会生成：
`pork, beef, chicken, french fries, rice, season fruit, pizza, prawns, salmon`

### 6.2.4 广义的规约汇总

事实上，我们已经讨论的所有收集器，都是一个可以用reducing工厂方法定义的归约过程的特殊情况而已。 Collectors.reducing工厂方法是所有这些特殊情况的一般化。可以说，先前讨论的案例仅仅是为了方便程序员而已。（但是，请记得方便程序员和可读性是头等大事！ ）例如，可以用reducing方法创建的收集器来计算你菜单的总热量，如下所示：
~~~java
int totalCalories = menu.stream().collect(reducing(
                                    0, Dish::getCalories, (i, j) -> i + j));
~~~
它需要三个参数。

- 第一个参数是归约操作的起始值，也是流中没有元素时的返回值，所以很显然对于数值
  和而言0是一个合适的值。
- 第二个参数就是你在6.2.2节中使用的函数，将菜肴转换成一个表示其所含热量的int。
- 第三个参数是一个BinaryOperator，将两个项目累积成一个同类型的值。这里它就是
  对两个int求和。

同样，你可以使用下面这样单参数形式的reducing来找到热量最高的菜，如下所示：
~~~java
Optional<Dish> mostCalorieDish =
    menu.stream().collect(reducing(
        (d1, d2) -> d1.getCalories() > d2.getCalories() ? d1 : d2));
~~~
你可以把单参数reducing工厂方法创建的收集器看作三参数方法的特殊情况，它把流中的第一个项目作为起点，把恒等函数（即一个函数仅仅是返回其输入参数）作为一个转换函数。这也意味着，要是把单参数reducing收集器传递给空流的collect方法，收集器就没有起点；正如我们在6.2.1节中所解释的，它将因此而返回一个`Optional<Dish>`对象。

## 6.3 分组

假设你要把菜单中的菜按照类型进行分类，有肉的放一组，有鱼的放一组，其他的都放另一组。用Collectors.groupingBy工厂方法返回的收集器就可以轻松地完成这项任务，如下所示：
~~~java
Map<Dish.Type, List<Dish>> dishesByType =
    menu.stream().collect(groupingBy(Dish::getType));
~~~
其结果是下面的Map：
`{FISH=[prawns, salmon], OTHER=[french fries, rice, season fruit, pizza],MEAT=[pork, beef, chicken]}`

这里，你给groupingBy方法传递了一个Function（以方法引用的形式），它提取了流中每一道Dish的Dish.Type。我们把这个Function叫作分类函数，因为它用来把流中的元素分成不同的组。如图6-4所示，分组操作的结果是一个Map，把分组函数返回的值作为映射的键，把流中所有具有这个分类值的项目的列表作为对应的映射值。

但是，分类函数不一定像方法引用那样可用，因为你想用以分类的条件可能比简单的属性访问器要复杂。例如，你可能想把热量不到400卡路里的菜划分为“低热量”（ diet），热量400到700卡路里的菜划为“普通”（ normal），高于700卡路里的划为“高热量”（ fat）。由于Dish类的作者没有把这个操作写成一个方法，你无法使用方法引用，但你可以把这个逻辑写成Lambda表达式：
~~~java
public enum CaloricLevel { DIET, NORMAL, FAT }
Map<CaloricLevel, List<Dish>> dishesByCaloricLevel = menu.stream().collect(
    groupingBy(dish -> {
        if (dish.getCalories() <= 400) return CaloricLevel.DIET;
        else if (dish.getCalories() <= 700) return CaloricLevel.NORMAL;
        else return CaloricLevel.FAT;
} ));
~~~

### 6.3.1 多级分组

要实现多级分组，我们可以使用一个由双参数版本的Collectors.groupingBy工厂方法创建的收集器，它除了普通的分类函数之外，还可以接受collector类型的第二个参数。那么要进行二级分组的话，我们可以把一个内层groupingBy传递给外层groupingBy，并定义一个为流中项目分类的二级标准
~~~java
Map<Dish.Type, Map<CaloricLevel, List<Dish>>> dishesByTypeCaloricLevel =
    menu.stream().collect(
        groupingBy(Dish::getType,
            groupingBy(dish -> {
                if (dish.getCalories() <= 400) return CaloricLevel.DIET;
                else if (dish.getCalories() <= 700) return CaloricLevel.NORMAL;
                else return CaloricLevel.FAT;
            } )
        )
    );
~~~

### 6.3.2 按子组收集数据

在上一节中，我们看到可以把第二个groupingBy收集器传递给外层收集器来实现多级分组。但进一步说，传递给第一个groupingBy的第二个收集器可以是任何类型，而不一定是另一个groupingBy。例如，要数一数菜单中每类菜有多少个，可以传递counting收集器作为groupingBy收集器的第二个参数：
~~~java
Map<Dish.Type, Long> typesCount = menu.stream().collect(
    groupingBy(Dish::getType, counting()));
~~~
其结果是下面的Map：
`{MEAT=3, FISH=2, OTHER=4}`

还要注意，普通的单参数groupingBy(f)（其中f是分类函数）实际上是groupingBy(f,toList())的简便写法。

再举一个例子，你可以把前面用于查找菜单中热量最高的菜肴的收集器改一改，按照菜的类型分类：
~~~java
Map<Dish.Type, Optional<Dish>> mostCaloricByType =
    menu.stream()
        .collect(groupingBy(Dish::getType,
                            maxBy(comparingInt(Dish::getCalories))));
~~~
这个分组的结果显然是一个map，以Dish的类型作为键，以包装了该类型中热量最高的Dish的Optional<Dish>作为值：
`{FISH=Optional[salmon], OTHER=Optional[pizza], MEAT=Optional[pork]}`

**1. 把收集器的结果转换为另一种类型**

因为分组操作的Map结果中的每个值上包装的Optional没什么用，所以你可能想要把它们去掉。要做到这一点，或者更一般地来说，把收集器返回的结果转换为另一种类型，你可以使用Collectors.collectingAndThen工厂方法返回的收集器

~~~java
Map<Dish.Type, Dish> mostCaloricByType =
    menu.stream()
        .collect(groupingBy(Dish::getType,
            collectingAndThen(
                maxBy(comparingInt(Dish::getCalories)),
                Optional::get)));
~~~
这个工厂方法接受两个参数——要转换的收集器以及转换函数，并返回另一个收集器。这个收集器相当于旧收集器的一个包装， collect操作的最后一步就是将返回值用转换函数做一个映射。在这里，被包起来的收集器就是用maxBy建立的那个，而转换函数Optional::get则把返回的Optional中的值提取出来。前面已经说过，这个操作放在这里是安全的，因为reducing收集器永远都不会返回Optional.empty()。其结果是下面的Map：
`{FISH=salmon, OTHER=pizza, MEAT=pork}`

**2. 与groupingBy联合使用的其他收集器的例子**

一般来说，通过groupingBy工厂方法的第二个参数传递的收集器将会对分到同一组中的所有流元素执行进一步归约操作。例如，你还重用求出所有菜肴热量总和的收集器，不过这次是对每一组Dish求和：
~~~java
Map<Dish.Type, Integer> totalCaloriesByType =
    menu.stream().collect(groupingBy(Dish::getType,
                                summingInt(Dish::getCalories)));
~~~
然而常常和groupingBy联合使用的另一个收集器是mapping方法生成的。这个方法接受两个参数：一个函数对流中的元素做变换，另一个则将变换的结果对象收集起来。其目的是在累加之前对每个输入元素应用一个映射函数，这样就可以让接受特定类型元素的收集器适应不同类型的对象。我们来看一个使用这个收集器的实际例子。比方说你想要知道，对于每种类型的Dish，菜单中都有哪些CaloricLevel。 我们可以把groupingBy和mapping收集器结合起来，如下所示：
~~~java
Map<Dish.Type, Set<CaloricLevel>> caloricLevelsByType =
    menu.stream().collect(
        groupingBy(Dish::getType, mapping(
            dish -> { if (dish.getCalories() <= 400) return CaloricLevel.DIET;
                    else if (dish.getCalories() <= 700) return CaloricLevel.NORMAL;
                    else return CaloricLevel.FAT; },
            toSet() )));
~~~
这里，就像我们前面见到过的，传递给映射方法的转换函数将Dish映射成了它的CaloricLevel：生成的CaloricLevel流传递给一个toSet收集器，它和toList类似，不过是把流中的元素累积到一个Set而不是List中，以便仅保留各不相同的值。如先前的示例所示，这个映射收集器将会收集分组函数生成的各个子流中的元素，让你得到这样的Map结果：
`{OTHER=[DIET, NORMAL], MEAT=[DIET, NORMAL, FAT], FISH=[DIET, NORMAL]}`

由此你就可以轻松地做出选择了。如果你想吃鱼并且在减肥，那很容易找到一道菜；同样，如果你饥肠辘辘，想要很多热量的话，菜单中肉类部分就可以满足你的饕餮之欲了。请注意在上一个示例中，对于返回的Set是什么类型并没有任何保证。但通过使用toCollection，你就可以有更多的控制。例如，你可以给它传递一个构造函数引用来要求HashSet
~~~java
Map<Dish.Type, Set<CaloricLevel>> caloricLevelsByType =
    menu.stream().collect(
        groupingBy(Dish::getType, mapping(
            dish -> { if (dish.getCalories() <= 400) return CaloricLevel.DIET;
                    else if (dish.getCalories() <= 700) return CaloricLevel.NORMAL;
                    else return CaloricLevel.FAT; },
            toCollection(HashSet::new) )));
~~~

## 6.4 分区

分区是分组的特殊情况：由一个谓词（返回一个布尔值的函数）作为分类函数，它称分区函数。分区函数返回一个布尔值，这意味着得到的分组Map的键类型是Boolean，于是它最多可以分为两组——true是一组， false是一组。
~~~java
Map<Boolean, List<Dish>> partitionedMenu =
    menu.stream().collect(partitioningBy(Dish::isVegetarian));
~~~

### 6.4.1 分区的优势

而且就像你在分组中看到的， partitioningBy工厂方法有一个重载版本，可以像下面这样传递第二个收集器：
~~~java
Map<Boolean, Map<Dish.Type, List<Dish>>> vegetarianDishesByType =
    menu.stream().collect(
        partitioningBy(Dish::isVegetarian,
        groupingBy(Dish::getType)));
~~~

| 工厂方法          | 返回类型               | 用于                                                         |
| ----------------- | ---------------------- | ------------------------------------------------------------ |
| toList            | List\<T>               | 把流中所有项目收集到一个List                                 |
| toSet             | Set\<T>                | 把流中所有项目收集到一个Set，删除重复项                      |
| toCollection      | Collection\<T>         | 把流中所有项目收集到给定的供应源创建的集合                   |
| counting          | Long                   | 计算流中元素的个数                                           |
| summingInt        | Integer                | 对流中项目的一个整数属性求和                                 |
| averagingInt      | Double                 | 计算流中项目Integer属性的平均值                              |
| summarizingInt    | IntSummaryStatistics   | 收集关于流中项目Integer属性的统计值，例如最大、最小、总和与平均值 |
| joining           | String                 | 连接对流中每个项目调用toString方法所生成的字符串             |
| maxBy             | Optional\<T>           | 一个包裹了流中按照给定比较器选出的最大元素的Optional，或如果流为空则为Optional.empty() |
| minBy             | Optional\<T>           | 一个包裹了流中按照给定比较器选出的最小元素的Optional，或如果流为空则为Optional.empty() |
| reducing          | 规约操作产生的类型     | 从一个作为累加器的初始值开始，利用BinaryOperator与流中的元素逐个结合，从而将流规约为单个值 |
| collectingAndThen | 转换函数返回的类型     | 包裹另一个收集器，对其结果应用转换函数                       |
| groupingBy        | Map\<K, List\<T>>      | 根据项目的一个属性的值对流中的项目作问组，并将属性值作为结果Map的键 |
| partitioningBy    | Map\<Boolean,List\<T>> | 根据对流中每个项目应用谓词的结果来对项目进行分区             |


## 6.5 收集器接口

首先让我们在下面的列表中看看Collector接口的定义，它列出了接口的签名以及声明的五个方法。
~~~java
public interface Collector<T, A, R> {
    Supplier<A> supplier();
    BiConsumer<A, T> accumulator();
    Function<A, R> finisher();
    BinaryOperator<A> combiner();
    Set<Characteristics> characteristics();
}
~~~
本列表适用以下定义。

- T是流中要收集的项目的泛型。
- A是累加器的类型，累加器是在收集过程中用于累积部分结果的对象。
- R是收集操作得到的对象（通常但并不一定是集合）的类型。

### 6.5.1 理解Collector接口

现在我们可以一个个来分析Collector接口声明的五个方法了。通过分析，你会注意到，前四个方法都会返回一个会被collect方法调用的函数，而第五个方法characteristics则提供了一系列特征，也就是一个提示列表，告诉collect方法在执行归约操作的时候可以应用哪些优化（比如并行化）。

**1. 建立新的结果容器： supplier方法**

supplier方法必须返回一个结果为空的Supplier，也就是一个无参数函数，在调用时它会创建一个空的累加器实例，供数据收集过程使用。很明显，对于将累加器本身作为结果返回的收集器，比如我们的ToListCollector，在对空流执行操作的时候，这个空的累加器也代表了收集过程的结果。在我们的ToListCollector中， supplier返回一个空的List

**2. 将元素添加到结果容器： accumulator方法**

accumulator方法会返回执行归约操作的函数。当遍历到流中第n个元素时，这个函数执行时会有两个参数：保存归约结果的累加器（已收集了流中的前 n1 个项目）， 还有第n个元素本身。该函数将返回void，因为累加器是原位更新，即函数的执行改变了它的内部状态以体现遍历的元素的效果。对于ToListCollector，这个函数仅仅会把当前项目添加至已经遍历过的项目的列表

**3. 对结果容器应用最终转换： finisher方法**

在遍历完流后， finisher方法必须返回在累积过程的最后要调用的一个函数，以便将累加器对象转换为整个集合操作的最终结果。通常，就像ToListCollector的情况一样，累加器对象恰好符合预期的最终结果，因此无需进行转换。所以finisher方法只需返回identity函数

这三个方法已经足以对流进行顺序归约，至少从逻辑上看可以按图6-7进行。实践中的实现细节可能还要复杂一点，一方面是因为流的延迟性质，可能在collect操作之前还需要完成其他中间操作的流水线，另一方面则是理论上可能要进行并行归约。

**4. 合并两个结果容器： combiner方法**

四个方法中的最后一个——combiner方法会返回一个供归约操作使用的函数，它定义了对流的各个子部分进行并行处理时，各个子部分归约所得的累加器要如何合并。对于toList而言，这个方法的实现非常简单，只要把从流的第二个部分收集到的项目列表加到遍历第一部分时得到的列表后面就行了

有了这第四个方法，就可以对流进行并行归约了。它会用到Java 7中引入的分支/合并框架和Spliterator抽象，我们会在下一章中讲到。

- 原始流会以递归方式拆分为子流，直到定义流是否需要进一步拆分的一个条件为非（如果分布式工作单位太小，并行计算往往比顺序计算要慢，而且要是生成的并行任务比处理器内核数多很多的话就毫无意义了）。
- 现在，所有的子流都可以并行处理，即对每个子流应用图6-7所示的顺序归约算法。
- 最后，使用收集器combiner方法返回的函数，将所有的部分结果两两合并。这时会把原始流每次拆分时得到的子流对应的结果合并起来。

**5. characteristics方法**
最后一个方法——characteristics会返回一个不可变的Characteristics集合，它定义了收集器的行为——尤其是关于流是否可以并行归约，以及可以使用哪些优化的提示。Characteristics是一个包含三个项目的枚举。

- UNORDERED——归约结果不受流中项目的遍历和累积顺序的影响。
- CONCURRENT——accumulator函数可以从多个线程同时调用，且该收集器可以并行归约流。如果收集器没有标为UNORDERED，那它仅在用于无序数据源时才可以并行归约。
- IDENTITY_FINISH——这表明完成器方法返回的函数是一个恒等函数，可以跳过。这种情况下，累加器对象将会直接用作归约过程的最终结果。这也意味着，将累加器A不加检查地转换为结果R是安全的。

我们迄今开发的ToListCollector是IDENTITY_FINISH的，因为用来累积流中元素的List已经是我们要的最终结果，用不着进一步转换了，但它并不是UNORDERED，因为用在有序流上的时候，我们还是希望顺序能够保留在得到的List中。最后，它是CONCURRENT的，但我们刚才说过了，仅仅在背后的数据源无序时才会并行处理。

### 6.5.2 全部融合到一起

前一小节中谈到的五个方法足够我们开发自己的ToListCollector了。你可以把它们都融合起来，如下面的代码清单所示。
~~~java
import java.util.*;
import java.util.function.*;
import java.util.stream.Collector;
import static java.util.stream.Collector.Characteristics.*;

public class ToListCollector<T> implements Collector<T, List<T>, List<T>> {
    @Override
    public Supplier<List<T>> supplier() {
        return ArrayList::new;
    }
    @Override
    public BiConsumer<List<T>, T> accumulator() {
        return List::add;
    }
    @Override
    public Function<List<T>, List<T>> finisher() {
        return Function.indentity();
    }
    @Override
    public BinaryOperator<List<T>> combiner() {
        return (list1, list2) -> {
            list1.addAll(list2);
            return list1;
        };
    }
    @Override
    public Set<Characteristics> characteristics() {
        return Collections.unmodifiableSet(EnumSet.of(
                            IDENTITY_FINISH, CONCURRENT));
    }
}
~~~
请注意，这个实现与Collectors.toList方法并不完全相同，但区别仅仅是一些小的优化。这些优化的一个主要方面是Java API所提供的收集器在需要返回空列表时使用了Collections.emptyList()这个单例（ singleton）。这意味着它可安全地替代原生Java，来收集菜单流中的所有Dish的列表：
`List<Dish> dishes = menuStream.collect(new ToListCollector<Dish>());`
这个实现和标准的
`List<Dish> dishes = menuStream.collect(toList());`
构造之间的其他差异在于toList是一个工厂，而ToListCollector必须用new来实例化。

**进行自定义收集而不去实现Collector**

对于IDENTITY_FINISH的收集操作，还有一种方法可以得到同样的结果而无需从头实现新的Collectors接口。Stream有一个重载的collect方法可以接受另外三个函数——supplier、accumulator和combiner，其语义和Collector接口的相应方法返回的函数完全相同。
~~~java
List<Dish> dishes = menuStream.collect(
                        ArrayList::new,
                        List::add,
                        List::addAll);
~~~
我们认为，这第二种形式虽然比前一个写法更为紧凑和简洁，却不那么易读。此外，以恰当的类来实现自己的自定义收集器有助于重用并可避免代码重复。另外值得注意的是，这第二个collect方法不能传递任何Characteristics，所以它永远都是一个IDENTITY_FINISH和CONCURRENT但并非UNORDERED的收集器。

# 第7章 并行数据处理和性能

## 7.1 并行流

### 7.1.1 将顺序流转换为并行流

你可以把流转换成并行流，从而让前面的函数归约过程（也就是求和）并行运行——对顺序流调用parallel方法
~~~java
public static long parallelSum(long n) {
    return Stream.iterate(1L, i -> i + 1)
                .limit(n)
                .parallel()
                .reduce(0L, Long::sum);
}
~~~
在上面的代码中，对流中所有数字求和的归纳过程的执行方式和5.4.1节中说的差不多。不同之处在于Stream在内部分成了几块。因此可以对不同的块独立并行进行归纳操作，如图7-1所示。最后，同一个归纳操作会将各个子流的部分归纳结果合并起来，得到整个原始流的归纳结果。

请注意，在现实中，对顺序流调用parallel方法并不意味着流本身有任何实际的变化。它在内部实际上就是设了一个boolean标志，表示你想让调用parallel之后进行的所有操作都并行执行。类似地，你只需要对并行流调用sequential方法就可以把它变成顺序流。请注意，你可能以为把这两个方法结合起来，就可以更细化地控制在遍历流时哪些操作要并行执行，哪些要顺序执行。

**配置并行流使用的线程池**

并行流内部使用了默认的ForkJoinPool（ 7.2节会进一步讲到分支/合并框架），它默认的线程数量就是你的处理器数量，这个值是由Runtime.getRuntime().availableProcessors()得到的。但是你可以通过系统属性java.util.concurrent.ForkJoinPool.common.parallelism来改变线程池大小，如下所示：
`System.setProperty("java.util.concurrent.ForkJoinPool.common.parallelism","12");`

这是一个全局设置，因此它将影响代码中所有的并行流。反过来说，目前还无法专为某个并行流指定这个值。一般而言，让ForkJoinPool的大小等于处理器数量是个不错的默认值，除非你有很好的理由，否则我们强烈建议你不要修改它。

### 7.1.2 测量流性能

那到底要怎么利用多核处理器，用流来高效地并行求和呢？我们在第5章中讨论了一个叫LongStream.rangeClosed的方法。这个方法与iterate相比有两个优点。

- LongStream.rangeClosed直接产生原始类型的long数字，没有装箱拆箱的开销。
- LongStream.rangeClosed会生成数字范围， 很容易拆分为独立的小块。例如，范围1~20可分为1~5、 6~10、 11~15和16~20。

### 7.1.4 高效使用并行流

- 如果有疑问，测量。把顺序流转成并行流轻而易举，但却不一定是好事。我们在本节中已经指出，并行流并不总是比顺序流快。此外，并行流有时候会和你的直觉不一致，所以在考虑选择顺序流还是并行流时，第一个也是最重要的建议就是用适当的基准来检查其性能。
- 留意装箱。自动装箱和拆箱操作会大大降低性能。 Java 8中有原始类型流（ IntStream、LongStream、 DoubleStream）来避免这种操作，但凡有可能都应该用这些流。
- 有些操作本身在并行流上的性能就比顺序流差。特别是limit和findFirst等依赖于元素顺序的操作，它们在并行流上执行的代价非常大。例如， findAny会比findFirst性能好，因为它不一定要按顺序来执行。你总是可以调用unordered方法来把有序流变成无序流。那么，如果你需要流中的n个元素而不是专门要前n个的话，对无序并行流调用limit可能会比单个有序流（比如数据源是一个List）更高效。
- 还要考虑流的操作流水线的总计算成本。设N是要处理的元素的总数， Q是一个元素通过流水线的大致处理成本，则N*Q就是这个对成本的一个粗略的定性估计。 Q值较高就意味着使用并行流时性能好的可能性比较大。
- 对于较小的数据量，选择并行流几乎从来都不是一个好的决定。并行处理少数几个元素的好处还抵不上并行化造成的额外开销。
- 要考虑流背后的数据结构是否易于分解。例如， ArrayList的拆分效率比LinkedList高得多，因为前者用不着遍历就可以平均拆分，而后者则必须遍历。另外，用range工厂方法创建的原始类型流也可以快速分解。最后，你将在7.3节中学到，你可以自己实现Spliterator来完全掌控分解过程。
- 流自身的特点，以及流水线中的中间操作修改流的方式，都可能会改变分解过程的性能。例如，一个SIZED流可以分成大小相等的两部分，这样每个部分都可以比较高效地并行处理，但筛选操作可能丢弃的元素个数却无法预测，导致流本身的大小未知。
- 还要考虑终端操作中合并步骤的代价是大是小（例如Collector中的combiner方法）。如果这一步代价很大，那么组合每个子流产生的部分结果所付出的代价就可能会超出通过并行流得到的性能提升。

流的数据源和可分解性

| 源              | 可分解性 |
| --------------- | -------- |
| ArrayList       | 极佳     |
| LinkedList      | 差       |
| IntStream.range | 极佳     |
| Stream.iterate  | 差       |
| HashSet         | 好       |
| TreeSet         | 好       |

## 7.2 分支合并框架

分支/合并框架的目的是以递归方式将可以并行的任务拆分成更小的任务，然后将每个子任务的结果合并起来生成整体结果。它是ExecutorService接口的一个实现，它把子任务分配给线程池（称为ForkJoinPool）中的工作线程。  

### 7.2.1 使用RecursiveTask

要把任务提交到这个池，必须创建`RecursiveTask<R>`的一个子类，其中R是并行化任务（以及所有子任务）产生的结果类型，或者如果任务不返回结果，则是RecursiveAction类型（当然它可能会更新其他非局部机构）。要定义RecursiveTask， 只需实现它唯一的抽象方法compute：
`protected abstract R compute();`

这个方法同时定义了将任务拆分成子任务的逻辑，以及无法再拆分或不方便再拆分时，生成单个子任务结果的逻辑。  正由于此，这个方法的实现类类似于下面的伪代码：

~~~
if (任务足够小或不可分) { 
	顺序计算该任务 
} else { 
	将任务分成两个子任务
	递归调用本方法，拆分每个子任务，等待所有子任务完成
	合并每个子任务的结果
}
~~~

一般来说并没有确切的标准决定一个任务是否应该再拆分，但有几种试探方法可以帮助你做出这一决定。我们会在7.2.1节中进一步澄清。

你可能已经注意到，这只不过是著名的分治算法的并行版本而已。

请注意在实际应用时，使用多个ForkJoinPool是没有什么意义的。正是出于这个原因，一般来说把它实例化一次，然后把实例保存在静态字段中，使之成为单例，这样就可以在软件中任何部分方便地重用了。这里创建时用了其默认的无参数构造函数，这意味着想让线程池使用JVM能够使用的所有处理器。

### 7.2.2 使用分支/合并框架的最佳做法

虽然分支/合并框架还算简单易用，不幸的是它也很容易被误用。以下是几个有效使用它的最佳做法。

- 对一个任务调用join方法会阻塞调用方，直到该任务做出结果。因此，有必要在两个子任务的计算都开始之后再调用它。否则，你得到的版本会比原始的顺序算法更慢更复杂，因为每个子任务都必须等待另一个子任务完成才能启动。
- 不应该在RecursiveTask内部使用ForkJoinPool的invoke方法。相反，你应该始终直接调用compute或fork方法，只有顺序代码才应该用invoke来启动并行计算。
- 对子任务调用fork方法可以把它排进ForkJoinPool。同时对左边和右边的子任务调用它似乎很自然，但这样做的效率要比直接对其中一个调用compute低。这样做你可以为其中一个子任务重用同一线程，从而避免在线程池中多分配一个任务造成的开销。
- 调试使用分支/合并框架的并行计算可能有点棘手。特别是你平常都在你喜欢的IDE里面看栈跟踪（stack trace）来找问题，但放在分支-合并计算上就不行了，因为调用compute的线程并不是概念上的调用方，后者是调用fork的那个。
- 和并行流一样，你不应理所当然地认为在多核处理器上使用分支/合并框架就比顺序计算快。我们已经说过，一个任务可以分解成多个独立的子任务，才能让性能在并行化时有所提升。所有这些子任务的运行时间都应该比分出新任务所花的时间长；一个惯用方法是把输入/输出放在一个子任务里，计算放在另一个里，这样计算就可以和输入/输出同时进行。此外，在比较同一算法的顺序和并行版本的性能时还有别的因素要考虑。就像任何其他Java代码一样，分支/合并框架需要“预热”或者说要执行几遍才会被JIT编译器优化。这就是为什么在测量性能之前跑几遍程序很重要，我们的测试框架就是这么做的。同时还要知道，编译器内置的优化可能会为顺序版本带来一些优势（例如执行死码分析——删去从未被使用的计算）。

对于分支/合并拆分策略还有最后一点补充：你必须选择一个标准，来决定任务是要进一步拆分还是已小到可以顺序求值。我们会在下一节中就此给出一些提示。

### 7.2.3 工作窃取

但分出大量的小任务一般来说都是一个好的选择。这是因为，理想情况下，划分并行任务时，应该让每个任务都用完全相同的时间完成，让所有的CPU内核都同样繁忙。不幸的是，实际中，每个子任务所花的时间可能天差地别，要么是因为划分策略效率低，要么是有不可预知的原因，比如磁盘访问慢，或是需要和外部服务协调执行。

分支/合并框架工程用一种称为**工作窃取**（work stealing）的技术来解决这个问题。在实际应用中，这意味着这些任务差不多被平均分配到ForkJoinPool中的所有线程上。每个线程都为分配给它的任务保存一个双向链式队列，每完成一个任务，就会从队列头上取出下一个任务开始执行。基于前面所述的原因，某个线程可能早早完成了分配给它的所有任务，也就是它的队列已经空了，而其他的线程还很忙。这时，这个线程并没有闲下来，而是随机选了一个别的线程，从队列的尾巴上“偷走”一个任务。这个过程一直继续下去，直到所有的任务都执行完毕，所有的队列都清空。这就是为什么要划成许多小任务而不是少数几个大任务，这有助于更好地在工作线程之间平衡负载。

一般来说，这种工作窃取算法用于在池中的工作线程之间重新分配和平衡任务。

本节中我们分析了一个例子，你明确地指定了将数字数组拆分成多个任务的逻辑。但是，使用本章前面讲的并行流时就用不着这么做了，这就意味着，肯定有一种自动机制来为你拆分流。这种新的自动机制称为Spliterator，我们会在下一节中讨论。

## 7.3 Spliterator

Spliterator是Java 8中加入的另一个新接口；这个名字代表“可分迭代器”（splitable iterator）。和Iterator一样，Spliterator也用于遍历数据源中的元素，但它是为了并行执行而设计的。虽然在实践中可能用不着自己开发Spliterator，但了解一下它的实现方式会让你对并行流的工作原理有更深入的了解。Java 8已经为集合框架中包含的所有数据结构提供了一个默认的Spliterator实现。集合实现了Spliterator接口，接口提供了一个spliterator方法。这个接口定义了若干方法，如下面的代码清单所示。

~~~java
public interface Spliterator<T> { 
	boolean tryAdvance(Consumer<? super T> action); 
	Spliterator<T> trySplit(); 
	long estimateSize(); 
	int characteristics(); 
}
~~~

与往常一样，T是Spliterator遍历的元素的类型。

- tryAdvance方法的行为类似于普通的Iterator，因为它会按顺序一个一个使用Spliterator中的元素，并且如果还有其他元素要遍历就返回true。
- trySplit是专为Spliterator接口设计的，因为它可以把一些元素划出去分给第二个Spliterator（由该方法返回），让它们两个并行处理。
- Spliterator还可通过estimateSize方法估计还剩下多少元素要遍历，因为即使不那么确切，能快速算出来是一个值也有助于让拆分均匀一点。

重要的是，要了解这个拆分过程在内部是如何执行的，以便在需要时能够掌控它。因此，我们会在下一节中详细地分析它。

### 7.3.1 拆分过程

将Stream拆分成多个部分的算法是一个递归过程。第一步是对第一个Spliterator调用trySplit，生成第二个Spliterator。第二步对这两个Spliterator调用trysplit，这样总共就有了四个Spliterator。这个框架不断对Spliterator调用trySplit直到它返回null，表明它处理的数据结构不能再分割，如第三步所示。最后，这个递归拆分过程到第四步就终止了，这时所有的Spliterator在调用trySplit时都返回了null。

**Spliterator的特性**

Spliterator接口声明的最后一个抽象方法是characteristics，它将返回一个int，代表Spliterator本身特性集的编码。使用Spliterator的客户可以用这些特性来更好地控制和优化它的使用。表7-2总结了这些特性。（不幸的是，虽然它们在概念上与收集器的特性有重叠，编码却不一样。）

| 特性       | 含义                                                         |
| ---------- | ------------------------------------------------------------ |
| ORDERED    | 元素有既定的顺序（例如List），因此Spliterator在遍历和划分时也会遵循这一顺序 |
| DISTINCT   | 对于任意一对遍历过的元素x和y，x.equals(y)返回false           |
| SORTED     | 遍历的元素按照一个预定义的顺序排序                           |
| SIZED      | 该Spliterator由一个已知大小的源建立（例如Set），因此estimatedSize()返回的是准确值 |
| NONNULL    | 保证遍历的元素不会为null                                     |
| IMMUTABLE  | Spliterator的数据源不能修改。这意味着在遍历时不能添加、删除或修改任何元素 |
| CONCURRENT | 该Spliterator的数据源可以被其他线程同时修改而无需同步        |
| SUBSIZED   | 该Spliterator和所有从它拆分出来的Spliterator都是SIZED        |

### 7.3.2 实现你自己的Spliterator

# 第三部分 高效Java 8编程

# 第8章 重构、测试和调试

## 8.1 为改善可读性和灵活性重构代码

### 8.1.1 改善代码的可读性

跟之前的版本相比较，Java 8的新特性也可以帮助提升代码的可读性：

- 使用Java 8，你可以减少冗长的代码，让代码更易于理解 
- 通过方法引用和Stream API，你的代码会变得更直观

这里我们会介绍三种简单的重构，利用Lambda表达式、方法引用以及Stream改善程序代码的可读性：

- 重构代码，用Lambda表达式取代匿名类
- 用方法引用重构Lambda表达式
- 用Stream API重构命令式的数据处理

### 8.1.2 从匿名类到Lambda表达式的转换

你值得尝试的第一种重构，也是简单的方式，是将实现单一抽象方法的匿名类转换为Lambda表达式。为什么呢？前面几章的介绍应该足以说服你，因为匿名类是极其繁琐且容易出错的。采用Lambda表达式之后，你的代码会更简洁，可读性更好。

但是某些情况下，将匿名类转换为Lambda表达式可能是一个比较复杂的过程。首先，匿名类和Lambda表达式中的this和super的含义是不同的。在匿名类中，this代表的是类自身，但是在Lambda中，它代表的是包含类。其次，匿名类可以屏蔽包含类的变量，而Lambda表达式不能（它们会导致编译错误）。譬如下面这段代码：

~~~java
int a = 10;
Runnable r1 = () -> {
    // 编译错误
    int a = 2;
    System.out.println(a);
}
Runnable r2 = new Runnable(){
    public void run(){
        // 一切正常
        int a = 2;
        System.out.println(a);
    }
}
~~~

最后，在涉及重载的上下文里，将匿名类转换为Lambda表达式可能导致最终的代码更加晦涩。实际上，匿名类的类型是在初始化时确定的，而Lambda的类型取决于它的上下文。

通过下面这个例子，我们可以了解问题是如何发生的。我们假设你用与Runnable同样的签名声明了一个函数接口，我们称之为Task（你希望采用与你的业务模型更贴切的接口名时，就可能做这样的变更）：

~~~java
interface Task{ 
	public void execute(); 
} 
public static void doSomething(Runnable r){ 
    r.run(); 
} 
public static void doSomething(Task a){ 
    a.execute(); 
}
~~~

现在，你再传递一个匿名类实现的Task，不会碰到任何问题：

~~~java
doSomething(new Task() { 
	public void execute() { 
		System.out.println("Danger danger!!"); 
	} 
});
~~~

但是将这种匿名类转换为Lambda表达式时，就导致了一种晦涩的方法调用，因为Runnable和Task都是合法的目标类型：

~~~java
// 麻烦来了：doSomething(Runnable)和doSomething(Task)都匹配该类型
doSomething(() -> System.out.println("Danger danger!!"));
~~~

你可以对Task尝试使用显式的类型转换来解决这种模棱两可的情况：

~~~java
doSomething((Task)() -> System.out.println("Danger danger!!"));
~~~

但是不要因此而放弃对Lambda的尝试。好消息是，目前大多数的集成开发环境，比如NetBeans和IntelliJ都支持这种重构，它们能自动地帮你检查，避免发生这些问题。

### 8.1.3 从Lambda表达式到方法引用的转换

Lambda表达式非常适用于需要传递代码片段的场景。不过，为了改善代码的可读性，也请尽量使用方法引用。因为方法名往往能更直观地表达代码的意图。

你可以将Lambda表达式的内容抽取到一个单独的方法中，将其作为参数传递给groupingBy方法。变换之后，代码变得更加简洁，程序的意图也更加清晰了

除此之外，我们还应该尽量考虑使用静态辅助方法，比如comparing、maxBy。这些方法设计之初就考虑了会结合方法引用一起使用。

此外，很多通用的归约操作，比如sum、maximum，都有内建的辅助方法可以和方法引用结合使用。比如，在我们的示例代码中，使用Collectors接口可以轻松得到和或者最大值，与采用Lambada表达式和底层的归约操作比起来，这种方式要直观得多。

### 8.1.4 从命令式的数据处理切换到 Stream 

我们建议你将所有使用迭代器这种数据处理模式处理集合的代码都转换成Stream API的方式。为什么呢？Stream API能更清晰地表达数据处理管道的意图。除此之外，通过短路和延迟载入以及利用第7章介绍的现代计算机的多核架构，我们可以对Stream进行优化。

替代方案使用Stream API，采用这种方式编写的代码读起来更像是问题陈述，并行化也非常容易

不幸的是，将命令式的代码结构转换为Stream API的形式是个困难的任务，因为你需要考虑控制流语句，比如break、continue、return，并选择使用恰当的流操作。好消息是已经有一些工具可以帮助我们完成这个任务

### 8.1.5 增加代码的灵活性

#### 1. 采用函数接口

首先，你必须意识到，没有函数接口，你就无法使用Lambda表达式。因此，你需要在代码中引入函数接口。听起来很合理，但是在什么情况下使用它们呢？这里我们介绍两种通用的模式，你可以依照这两种模式重构代码，利用Lambda表达式带来的灵活性，它们分别是：**有条件的延迟执行**和**环绕执行**。除此之外，在下一节，我们还将介绍一些基于面向对象的设计模式，比如策略模式或者模板方法，这些在使用Lambda表达式重写后会更简洁。

#### 2. 有条件的延迟执行

如果你发现你需要频繁地从客户端代码去查询一个对象的状态（比如前文例子中的日志器的状态），只是为了传递参数、调用该对象的一个方法（比如输出一条日志），那么可以考虑实现一个新的方法，以Lambda或者方法表达式作为参数，新方法在检查完该对象的状态之后才调用原来的方法。你的代码会因此而变得更易读（结构更清晰），封装性更好（对象的状态也不会暴露给客户端代码了）

#### 3. 环绕执行

第3章中，我们介绍过另一种值得考虑的模式，那就是环绕执行。如果你发现虽然你的业务代码千差万别，但是它们拥有同样的准备和清理阶段，这时，你完全可以将这部分代码用Lambda实现。这种方式的好处是可以重用准备和清理阶段的逻辑，减少重复冗余的代码。下面这段代码你在第3章中已经看过，我们再回顾一次。它在打开和关闭文件时使用了同样的逻辑，但在处理文件时可以使用不同的Lambda进行参数化。

## 8.2 使用 Lambda 重构面向对象的设计模式

新的语言特性常常让现存的编程模式或设计黯然失色。比如， Java 5中引入了for-each循环，由于它的稳健性和简洁性，已经替代了很多显式使用迭代器的情形。Java 7中推出的菱形操作符（<>）让大家在创建实例时无需显式使用泛型，一定程度上推动了Java程序员们采用类型接口（type interface）进行程序设计。

对设计经验的归纳总结被称为**设计模式**。设计软件时，如果你愿意，可以复用这些方式方法来解决一些常见问题。这看起来像传统建筑工程师的工作方式，对典型的场景（比如悬挂桥、拱桥等）都定义有可重用的解决方案。例如，**访问者模式**常用于分离程序的算法和它的操作对象。**单例模式**一般用于限制类的实例化，仅生成一份对象。

Lambda表达式为程序员的工具箱又新添了一件利器。它们为解决传统设计模式所面对的问题提供了新的解决方案，不但如此，采用这些方案往往更高效、更简单。使用Lambda表达式后，很多现存的略显臃肿的面向对象设计模式能够用更精简的方式实现了。这一节中，我们会针对五个设计模式展开讨论，它们分别是：

- 策略模式
- 模板方法
- 观察者模式
- 责任链模式
- 工厂模式

我们会展示Lambda表达式是如何另辟蹊径解决设计模式原来试图解决的问题的。

### 8.2.1 策略模式

策略模式代表了解决一类算法的通用解决方案，你可以在运行时选择使用哪种方案。

策略模式包含三部分内容，如图8-1所示。

- 一个代表某个算法的接口（它是策略模式的接口）。
- 一个或多个该接口的具体实现，它们代表了算法的多种实现（比如，实体类ConcreteStrategyA或者ConcreteStrategyB）。
- 一个或多个使用策略对象的客户。

~~~mermaid
classDiagram
	class Strategy{
		+ execute()
	}
	客户--|>Strategy
	Strategy<|..ConcreteStragegyA
	Strategy<|..ConcreteStragegyB
~~~

我们假设你希望验证输入的内容是否根据标准进行了恰当的格式化（比如只包含小写字母或数字）。你可以从定义一个验证文本（以String的形式表示）的接口入手

**使用Lambda表达式**

到现在为止，你应该已经意识到ValidationStrategy是一个函数接口了（除此之外，它还与`Predicate<String>`具有同样的函数描述）。这意味着我们不需要声明新的类来实现不同的策略，通过直接传递Lambda表达式就能达到同样的目的，并且还更简洁

~~~java
Validator numericValidator = new Validator((String s) -> s.matches("[a-z]+")); 
boolean b1 = numericValidator.validate("aaaa"); 
Validator lowerCaseValidator = new Validator((String s) -> s.matches("\\d+")); 
boolean b2 = lowerCaseValidator.validate("bbbb");
~~~

正如你看到的，Lambda表达式避免了采用策略设计模式时僵化的模板代码。如果你仔细分析一下个中缘由，可能会发现，Lambda表达式实际已经对部分代码（或策略）进行了封装，而这就是创建策略设计模式的初衷。因此，我们强烈建议对类似的问题，你应该尽量使用Lambda表达式来解决。

### 8.2.2 模板方法

如果你需要采用某个算法的框架，同时又希望有一定的灵活度，能对它的某些部分进行改进，那么采用模板方法设计模式是比较通用的方案。好吧，这样讲听起来有些抽象。换句话说，模板方法模式在你“希望使用这个算法，但是需要对其中的某些行进行改进，才能达到希望的效果”时是非常有用的。

让我们从一个例子着手，看看这个模式是如何工作的。假设你需要编写一个简单的在线银行应用。通常，用户需要输入一个用户账户，之后应用才能从银行的数据库中得到用户的详细信息，最终完成一些让用户满意的操作。不同分行的在线银行应用让客户满意的方式可能还略有不同，比如给客户的账户发放红利，或者仅仅是少发送一些推广文件。你可能通过下面的抽象类方式来实现在线银行应用：

~~~java
abstract class OnlineBanking { 
	public void processCustomer(int id){ 
        Customer c = Database.getCustomerWithId(id); 
        makeCustomerHappy(c); 
    }
    abstract void makeCustomerHappy(Customer c); 
}
~~~

processCustomer方法搭建了在线银行算法的框架：获取客户提供的ID，然后提供服务让用户满意。不同的支行可以通过继承OnlineBanking类，对该方法提供差异化的实现。

**使用Lambda表达式**

使用你偏爱的Lambda表达式同样也可以解决这些问题（创建算法框架，让具体的实现插入某些部分）。你想要插入的不同算法组件可以通过Lambda表达式或者方法引用的方式实现。

这里我们向processCustomer方法引入了第二个参数，它是一个`Consumer<Customer>`类型的参数，与前文定义的makeCustomerHappy的特征保持一致：

~~~java
public void processCustomer(int id, Consumer<Customer> makeCustomerHappy){ 
	Customer c = Database.getCustomerWithId(id); 
	makeCustomerHappy.accept(c); 
} 
~~~

现在，你可以很方便地通过传递Lambda表达式，直接插入不同的行为，不再需要继承OnlineBanking类了：

~~~java
new OnlineBankingLambda().processCustomer(1337, (Customer c) -> System.out.println("Hello " + c.getName()); 
~~~

这是又一个例子，佐证了Lamba表达式能帮助你解决设计模式与生俱来的设计僵化问题。

### 8.2.3 观察者模式

观察者模式是一种比较常见的方案，某些事件发生时（比如状态转变），如果一个对象（通常我们称之为主题）需要自动地通知其他多个对象（称为观察者），就会采用该方案。创建图形用户界面（GUI）程序时，你经常会使用该设计模式。

~~~mermaid
classDiagram
	class Subject{
		+ notifyObserver()
	}
	class Observer {
		+ notify()
	}
	Subject o--|> Observer
	Observer <|.. ConconreteObserverA
	Observer <|.. ConconreteObserverB
~~~

让我们写点儿代码来看看观察者模式在实际中多么有用。你需要为Twitter这样的应用设计并实现一个定制化的通知系统。想法很简单：好几家报纸机构，比如《纽约时报》《卫报》以及《世界报》都订阅了新闻，他们希望当接收的新闻中包含他们感兴趣的关键字时，能得到特别通知。

首先，你需要一个观察者接口，它将不同的观察者聚合在一起。它仅有一个名为notify的方法，一旦接收到一条新的新闻，该方法就会被调用：

~~~java
interface Observer { 
	void notify(String tweet); 
}
~~~

现在，你可以声明不同的观察者（比如，这里是三家不同的报纸机构），依据新闻中不同的关键字分别定义不同的行为：

~~~java
class NYTimes implements Observer{ 
 	public void notify(String tweet) { 
 		if(tweet != null && tweet.contains("money")){ 
 			System.out.println("Breaking news in NY! " + tweet); 
		} 
	} 
} 
class Guardian implements Observer{ 
	public void notify(String tweet) { 
		if(tweet != null && tweet.contains("queen")){ 
			System.out.println("Yet another news in London... " + tweet); 
		} 
	} 
} 
class LeMonde implements Observer{ 
	public void notify(String tweet) { 
		if(tweet != null && tweet.contains("wine")){ 
			System.out.println("Today cheese, wine and news! " + tweet); 
		} 
	} 
}
~~~

你还遗漏了最重要的部分：Subject！让我们为它定义一个接口：

~~~java
interface Subject{ 
 	void registerObserver(Observer o); 
 	void notifyObservers(String tweet); 
}
~~~

Subject使用registerObserver方法可以注册一个新的观察者，使用notifyObservers方法通知它的观察者一个新闻的到来。让我们更进一步，实现Feed类：

~~~java
class Feed implements Subject{ 
 	private final List<Observer> observers = new ArrayList<>(); 
 	public void registerObserver(Observer o) { 
 		this.observers.add(o); 
 	} 
 	public void notifyObservers(String tweet) { 
 		observers.forEach(o -> o.notify(tweet)); 
 	} 
}
~~~

这是一个非常直观的实现：Feed类在内部维护了一个观察者列表，一条新闻到达时，它就进行通知。

~~~java
Feed f = new Feed(); 
f.registerObserver(new NYTimes()); 
f.registerObserver(new Guardian()); 
f.registerObserver(new LeMonde()); 
f.notifyObservers("The queen said her favourite book is Java 8 in Action!");
~~~

**使用Lambda表达式**

你可能会疑惑Lambda表达式在观察者设计模式中如何发挥它的作用。不知道你有没有注意到，Observer接口的所有实现类都提供了一个方法：notify。新闻到达时，它们都只是对同一段代码封装执行。Lambda表达式的设计初衷就是要消除这样的僵化代码。使用Lambda表达式后，你无需显式地实例化三个观察者对象，直接传递Lambda表达式表示需要执行的行为即可

~~~java
f.registerObserver((String tweet) -> { 
	if(tweet != null && tweet.contains("money")){ 
		System.out.println("Breaking news in NY! " + tweet); 
	} 
}); 
f.registerObserver((String tweet) -> { 
	if(tweet != null && tweet.contains("queen")){ 
		System.out.println("Yet another news in London... " + tweet); 
	} 
});
~~~

那么，是否我们随时随地都可以使用Lambda表达式呢？答案是否定的！我们前文介绍的例子中，Lambda适配得很好，那是因为需要执行的动作都很简单，因此才能很方便地消除僵化代码。但是，观察者的逻辑有可能十分复杂，它们可能还持有状态，抑或定义了多个方法，诸如此类。在这些情形下，你还是应该继续使用类的方式。

### 8.2.4 责任链模式

责任链模式是一种创建处理对象序列（比如操作序列）的通用方案。一个处理对象可能需要在完成一些工作之后，将结果传递给另一个对象，这个对象接着做一些工作，再转交给下一个处理对象，以此类推。

通常，这种模式是通过定义一个代表处理对象的抽象类来实现的，在抽象类中会定义一个字段来记录后续对象。一旦对象完成它的工作，处理对象就会将它的工作转交给它的后继。代码中，这段逻辑看起来是下面这样：

~~~java
public abstract class ProcessingObject<T> { 
	protected ProcessingObject<T> successor; 
	public void setSuccessor(ProcessingObject<T> successor){ 
		this.successor = successor;
    }
    public T handle(T input){ 
		T r = handleWork(input); 
		if(successor != null){ 
			return successor.handle(r); 
		} 
		return r; 
	} 
	abstract protected T handleWork(T input); 
}
~~~

~~~mermaid
classDiagram
	class ProcessingObject{
		+ handle()
	}
	ConcreteProcessingObject o--|> ProcessingObject : successor
	ConcreteProcessingObject ..|> ProcessingObject
	客户 ..|> ProcessingObject
~~~

可能你已经注意到，这就是8.2.2节介绍的模板方法设计模式。handle方法提供了如何进行工作处理的框架。不同的处理对象可以通过继承ProcessingObject类，提供handleWork方法来进行创建。

下面让我们看看如何使用该设计模式。你可以创建两个处理对象，它们的功能是进行一些文本处理工作。

~~~java
public class HeaderTextProcessing extends ProcessingObject<String> { 
	public String handleWork(String text){ 
		return "From Raoul, Mario and Alan: " + text; 
	} 
} 
public class SpellCheckerProcessing extends ProcessingObject<String> { 
	public String handleWork(String text){ 
        // 糟糕，我们漏掉了Lambda中的m字符
		return text.replaceAll("labda", "lambda"); 
	} 
}
~~~

现在你就可以将这两个处理对象结合起来，构造一个操作序列！

~~~java
ProcessingObject<String> p1 = new HeaderTextProcessing(); 
ProcessingObject<String> p2 = new SpellCheckerProcessing(); 
// 将两个处理对象链接起来
p1.setSuccessor(p2);
String result = p1.handle("Aren't labdas really sexy?!!"); 
// 打印输出“From Raoul, Mario and Alan: Aren't lambdas really sexy?!!”
System.out.println(result);
~~~

**使用Lambda表达式**

稍等！这个模式看起来像是在链接（也即是构造）函数。第3章中我们探讨过如何构造Lambda表达式。你可以将处理对象作为函数的一个实例，或者更确切地说作为`UnaryOperator<String>`的一个实例。为了链接这些函数，你需要使用andThen方法对其进行构造。

~~~java
// 第一个处理对象
UnaryOperator<String> headerProcessing = (String text) -> "From Raoul, Mario and Alan: " + text;
// 第二个处理对象
UnaryOperator<String> spellCheckerProcessing = (String text) -> text.replaceAll("labda", "lambda"); 
// 将两个方法结合起来，结果就是一个操作链
Function<String, String> pipeline = headerProcessing.andThen(spellCheckerProcessing); 
String result = pipeline.apply("Aren't labdas really sexy?!!")
~~~

### 8.2.5 工厂模式

使用工厂模式，你无需向客户暴露实例化的逻辑就能完成对象的创建。比如，我们假定你为一家银行工作，他们需要一种方式创建不同的金融产品：贷款、期权、股票，等等。

通常，你会创建一个工厂类，它包含一个负责实现不同对象的方法，如下所示：

~~~java
public class ProductFactory { 
	public static Product createProduct(String name){ 
        switch(name){ 
            case "loan": return new Loan(); 
            case "stock": return new Stock(); 
            case "bond": return new Bond(); 
            default: throw new RuntimeException("No such product " + name); 
		} 
	} 
}
~~~

这里贷款（Loan）、股票（Stock）和债券（Bond）都是产品（Product）的子类。createProduct方法可以通过附加的逻辑来设置每个创建的产品。

但是带来的好处也显而易见，你在创建对象时不用再担心会将构造函数或者配置暴露给客户，这使得客户创建产品时更加简单：

~~~java
Product p = ProductFactory.createProduct("loan"); 
~~~

**使用Lambda表达式**

第3章中，我们已经知道可以像引用方法一样引用构造函数。比如，下面就是一个引用贷款（Loan）构造函数的示例：

~~~java
Supplier<Product> loanSupplier = Loan::new; 
Loan loan = loanSupplier.get();
~~~

通过这种方式，你可以重构之前的代码，创建一个Map，将产品名映射到对应的构造函数：

~~~java
final static Map<String, Supplier<Product>> map = new HashMap<>(); 
static { 
    map.put("loan", Loan::new); 
    map.put("stock", Stock::new); 
	map.put("bond", Bond::new); 
}
~~~

现在，你可以像之前使用工厂设计模式那样，利用这个Map来实例化不同的产品。

~~~java
public static Product createProduct(String name){ 
    Supplier<Product> p = map.get(name); 
    if(p != null) return p.get(); 
	throw new IllegalArgumentException("No such product " + name); 
}
~~~

这是个全新的尝试，它使用Java 8中的新特性达到了传统工厂模式同样的效果。但是，如果工厂方法createProduct需要接收多个传递给产品构造方法的参数，这种方式的扩展性不是很好。你不得不提供不同的函数接口，无法采用之前统一使用一个简单接口的方式。比如，我们假设你希望保存具有三个参数（两个参数为Integer类型，一个参数为String类型）的构造函数；为了完成这个任务，你需要创建一个特殊的函数接口TriFunction。最终的结果是Map变得更加复杂。

~~~java
public interface TriFunction<T, U, V, R>{ 
	R apply(T t, U u, V v); 
} 
Map<String, TriFunction<Integer, Integer, String, Product>> map = new HashMap<>();
~~~

你已经了解了如何使用Lambda表达式编写和重构代码。接下来，我们会介绍如何确保新编写代码的正确性。

## 8.3 测试Lambda表达式

现在你的代码中已经充溢着Lambda表达式，看起来不错，也很简洁。但是，大多数时候，我们受雇进行的程序开发工作的要求并不是编写优美的代码，而是编写正确的代码。

通常而言，好的软件工程实践一定少不了单元测试，借此保证程序的行为与预期一致。你编写测试用例，通过这些测试用例确保你代码中的每个组成部分都实现预期的结果。

### 8.3.1 测试可见 Lambda 函数的行为

但是Lambda并无函数名（毕竟它们都是匿名函数），因此要对你代码中的Lambda函数进行测试实际上比较困难，因为你无法通过函数名的方式调用它们。

有些时候，你可以借助某个字段访问Lambda函数，这种情况，你可以利用这些字段，通过它们对封装在Lambda函数内的逻辑进行测试。比如，我们假设你在Point类中添加了静态字段compareByXAndThenY，通过该字段，使用方法引用你可以访问Comparator对象：

~~~java
public class Point{ 
	public final static Comparator<Point> compareByXAndThenY = comparing(Point::getX).thenComparing(Point::getY); 
	... 
}
~~~

还记得吗，Lambda表达式会生成函数接口的一个实例。由此，你可以测试该实例的行为。这个例子中，我们可以使用不同的参数，对Comparator对象类型实例compareByXAndThenY的compare方法进行调用，验证它们的行为是否符合预期：

~~~java
@Test 
public void testComparingTwoPoints() throws Exception { 
    Point p1 = new Point(10, 15); 
    Point p2 = new Point(10, 20); 
    int result = Point.compareByXAndThenY.compare(p1 , p2); 
    assertEquals(-1, result); 
}
~~~

### 8.3.2 测试使用 Lambda 的方法的行为

但是Lambda的初衷是将一部分逻辑封装起来给另一个方法使用。从这个角度出发，你不应该将Lambda表达式声明为public，它们仅是具体的实现细节。相反，我们需要对使用Lambda表达式的方法进行测试。

### 8.3.3 将复杂的 Lambda 表达式分到不同的方法

可能你会碰到非常复杂的Lambda表达式，包含大量的业务逻辑，比如需要处理复杂情况的定价算法。你无法在测试程序中引用Lambda表达式，这种情况该如何处理呢？一种策略是将Lambda表达式转换为方法引用（这时你往往需要声明一个新的常规方法），我们在8.1.3节详细讨论过这种情况。这之后，你可以用常规的方式对新的方法进行测试。

### 8.3.4 高阶函数的测试

接受函数作为参数的方法或者返回一个函数的方法（所谓的“高阶函数”，higher-order function，我们在第14章会深入展开介绍）更难测试。如果一个方法接受Lambda表达式作为参数，你可以采用的一个方案是使用不同的Lambda表达式对它进行测试。比如，你可以使用不同的谓词对第2章中创建的filter方法进行测试。

如果被测试方法的返回值是另一个方法，该如何处理呢？你可以仿照我们之前处理Comparator的方法，把它当成一个函数接口，对它的功能进行测试。

然而，事情可能不会一帆风顺，你的测试可能会返回错误，报告说你使用Lambda表达式的方式不对。因此，我们现在进入调试的环节。

## 8.4 调试

### 8.4.1 查看栈跟踪

**Lambda表达式和栈跟踪**

不幸的是，由于Lambda表达式没有名字，它的栈跟踪可能很难分析。

这些表示错误发生在Lambda表达式内部。由于Lambda表达式没有名字，所以编译器只能为它们指定一个名字。这个例子中，它的名字是`lambda$main$0`，看起来非常不直观。如果你使用了大量的类，其中又包含多个Lambda表达式，这就成了一个非常头痛的问题。

即使你使用了方法引用，还是有可能出现栈无法显示你使用的方法名的情况。

注意，如果方法引用指向的是同一个类中声明的方法，那么它的名称是可以在栈跟踪中显示的。

### 8.4.2 使用日志调试

假设你试图对流操作中的流水线进行调试，该从何入手呢？

不幸的是，一旦调用forEach，整个流就会恢复运行。到底哪种方式能更有效地帮助我们理解Stream流水线中的每个操作（比如map、filter、limit）产生的输出？

这就是流操作方法peek大显身手的时候。peek的设计初衷就是在流的每个元素恢复运行之前，插入执行一个动作。但是它不像forEach那样恢复整个流的运行，而是在一个元素上完成操作之后，它只会将操作顺承到流水线中的下一个操作。图8-4解释了peek的操作流程。下面的这段代码中，我们使用peek输出了Stream流水线操作之前和操作之后的中间值：

~~~java
List<Integer> result = 
    numbers.stream() 
    	// 输出来自数据源的当前元素值
        .peek(x -> System.out.println("from stream: " + x))
        .map(x -> x + 17) 
    	// 输出map操作的结果
        .peek(x -> System.out.println("after map: " + x)) 
        .filter(x -> x % 2 == 0) 
    	// 输出经过filter操作之后，剩下的元素个数
        .peek(x -> System.out.println("after filter: " + x))
        .limit(3) 
    	// 输出经过limit操作之后，剩下的元素个数
        .peek(x -> System.out.println("after limit: " + x))
        .collect(toList());
~~~

通过peek操作我们能清楚地了解流水线操作中每一步的输出结果

# 第9章 默认方法

传统上，Java程序的接口是将相关方法按照约定组合到一起的方式。实现接口的类必须为接口中定义的每个方法提供一个实现，或者从父类中继承它的实现。但是，一旦类库的设计者需要更新接口，向其中加入新的方法，这种方式就会出现问题。

且慢，其实你不必惊慌。Java 8为了解决这一问题引入了一种新的机制。Java 8中的接口现在支持在声明方法的同时提供实现，这听起来让人惊讶！通过两种方式可以完成这种操作：

- 其一，Java 8允许在接口内声明静态方法。
- 其二，Java 8引入了一个新功能，叫默认方法，通过默认方法你可以指定接口方法的默认实现。换句话说，接口能提供方法的具体实现。

因此，实现接口的类如果不显式地提供该方法的具体实现，就会自动继承默认的实现。这种机制可以使你平滑地进行接口的优化和演进。

喔噢！这些接口现在看起来像抽象类了吧？是，也不是。它们有一些本质的区别，我们在这一章中会针对性地进行讨论。但更重要的是，你为什么要在乎默认方法？默认方法的主要目标用户是类库的设计者啊。正如我们后面所解释的，默认方法的引入就是为了以兼容的方式解决像Java API这样的类库的演进问题的

简而言之，向接口添加方法是诸多问题的罪恶之源；一旦接口发生变化，实现这些接口的类往往也需要更新，提供新添方法的实现才能适配接口的变化。如果你对接口以及它所有相关的实现有完全的控制，这可能不是个大问题。但是这种情况是极少的。这就是引入默认方法的目的：它让类可以自动地继承接口的一个默认实现。

>**静态方法及接口**
>
>同时定义接口以及工具辅助类（companion class）是Java语言常用的一种模式，工具类定义了与接口实例协作的很多静态方法。比如，Collections就是处理Collection对象的辅助类。由于静态方法可以存在于接口内部，你代码中的这些辅助类就没有了存在的必要，你可以把这些静态方法转移到接口内部。为了保持后向的兼容性，这些类依然会存在于Java应用程序的接口之中。

## 9.1 不断演进的 API 

### 9.1.2 第二版API

对Resizable接口的更新导致了一系列的问题。首先，接口现在要求它所有的实现类添加setRelativeSize方法的实现。但是用户最初实现的Ellipse类并未包含setRelativeSize方法。向接口添加新方法是二进制兼容的，这意味着如果不重新编译该类，即使不实现新的方法，现有类的实现依旧可以运行。不过，用户可能修改他的游戏，在他的Utils.paint方法中调用setRelativeSize方法，因为paint方法接受一个Resizable对象列表作为参数。如果传递的是一个Ellipse对象，程序就会抛出一个运行时错误，因为它并未实现setRelativeSize方法：

~~~
Exception in thread "main" java.lang.AbstractMethodError: 
 lambdasinaction.chap9.Ellipse.setRelativeSize(II)V
~~~

其次，如果用户试图重新编译整个应用（包括Ellipse类），他会遭遇下面的编译错误

~~~
lambdasinaction/chap9/Ellipse.java:6: error: Ellipse is not abstract and does not override abstract method setRelativeSize(int,int) in Resizable
~~~

最后，更新已发布API会导致后向兼容性问题。这就是为什么对现存API的演进，比如官方发布的Java Collection API，会给用户带来麻烦。当然，还有其他方式能够实现对API的改进，但是都不是明智的选择。比如，你可以为你的API创建不同的发布版本，同时维护老版本和新版本，但这是非常费时费力的，原因如下。其一，这增加了你作为类库的设计者维护类库的复杂度。其次，类库的用户不得不同时使用一套代码的两个版本，而这会增大内存的消耗，延长程序的载入时间，因为这种方式下项目使用的类文件数量更多了。

这就是默认方法试图解决的问题。它让类库的设计者放心地改进应用程序接口，无需担忧对遗留代码的影响，这是因为实现更新接口的类现在会自动继承一个默认的方法实现。

> 不同类型的兼容性：二进制、源代码和函数行为 
>
> 变更对Java程序的影响大体可以分成三种类型的兼容性，分别是：二进制级的兼容、源代码级的兼容，以及函数行为的兼容。
>
> 刚才我们看到，向接口添加新方法是二进制级的兼容， 但最终编译实现接口的类时却会发生编译错误。了解不同类型兼容性的特性是非常有益的，下面我们会深入介绍这部分的内容。
>
> 二进制级的兼容性表示现有的二进制执行文件能无缝持续链接（包括验证、准备和解析）和运行。比如，为接口添加一个方法就是二进制级的兼容，这种方式下，如果新添加的方法不被调用，接口已经实现的方法可以继续运行，不会出现错误。
>
> 简单地说，源代码级的兼容性表示引入变化之后，现有的程序依然能成功编译通过。比如， 向接口添加新的方法就不是源码级的兼容，因为遗留代码并没有实现新引入的方法，所以它们无法顺利通过编译。
>
> 最后，函数行为的兼容性表示变更发生之后，程序接受同样的输入能得到同样的结果。比 如，为接口添加新的方法就是函数行为兼容的，因为新添加的方法在程序中并未被调用（抑或该接口在实现中被覆盖了）。

## 9.2 概述默认方法

经过前述的介绍，我们已经了解了向已发布的API添加方法，对现存代码实现会造成多大的损害。默认方法是Java 8中引入的一个新特性，希望能借此以兼容的方式改进API。现在，接口包含的方法签名在它的实现类中也可以不提供实现。那么，谁来具体实现这些方法呢？实际上，缺失的方法实现会作为接口的一部分由实现类继承（所以命名为默认实现），而无需由实现类提供。

那么，我们该如何辨识哪些是默认方法呢？其实非常简单。默认方法由default修饰符修饰，并像类中声明的其他方法一样包含方法体。比如，你可以像下面这样在集合库中定义一个名为Sized的接口，在其中定义一个抽象方法size，以及一个默认方法isEmpty：

~~~java
public interface Sized { 
    int size(); 
    // 默认方法
    default boolean isEmpty() { 
    	return size() == 0; 
    } 
}
~~~

这样任何一个实现了Sized接口的类都会自动继承isEmpty的实现。因此，向提供了默认实现的接口添加方法就不是源码兼容的。

由于接口现在可以提供带实现的方法，是否这意味着Java已经在某种程度上实现了多继承？如果实现类也实现了同样的方法，这时会发生什么情况？默认方法会被覆盖吗？现在暂时无需担心这些，Java 8中已经定义了一些规则和机制来处理这些问题。详细的内容，我们会在9.5节进行介绍。

你可能已经猜到，默认方法在Java 8的API中已经大量地使用了。本章已经介绍过我们前一章中大量使用的Collection接口的stream方法就是默认方法。List接口的sort方法也是默认方法。第3章介绍的很多函数式接口，比如Predicate、Function以及Comparator也引入了新的默认方法，比如Predicate.and或者Function.andThen（记住，函数式接口只包含一个抽象方法，默认方法是种非抽象方法）。

> **Java 8中的抽象类和抽象接口**
>
> 那么抽象类和抽象接口之间的区别是什么呢？它们不都能包含抽象方法和包含方法体的实现吗？
>
> - 首先，一个类只能继承一个抽象类，但是一个类可以实现多个接口。
> - 其次，一个抽象类可以通过实例变量（字段）保存一个通用状态，而接口是不能有实例变量的。

## 9.3 默认方法的使用模式

### 9.3.1 可选方法

你很可能也碰到过这种情况，类实现了接口，不过却刻意地将一些方法的实现留白。我们以Iterator接口为例来说。Iterator接口定义了hasNext、next，还定义了remove方法。Java 8之前，由于用户通常不会使用该方法，remove方法常被忽略。因此，实现Interator接口的类通常会为remove方法放置一个空的实现，这些都是些毫无用处的模板代码。

采用默认方法之后，你可以为这种类型的方法提供一个默认的实现，这样实体类就无需在自己的实现中显式地提供一个空方法。比如，在Java 8中，Iterator接口就为remove方法提供了一个默认实现，如下所示：

~~~java
interface Iterator<T> { 
    boolean hasNext(); 
    T next(); 
    default void remove() { 
    	throw new UnsupportedOperationException(); 
    } 
}
~~~

通过这种方式，你可以减少无效的模板代码。实现Iterator接口的每一个类都不需要再声明一个空的remove方法了，因为它现在已经有一个默认的实现。

### 9.3.2 行为的多继承

默认方法让之前无法想象的事儿以一种优雅的方式得以实现，即行为的多继承。这是一种让类从多个来源重用代码的能力

**1. 类型的多继承**

这个例子中ArrayList继承了一个类，实现了六个接口。因此ArrayList实际是七个类型的直接子类，分别是：AbstractList、List、RandomAccess、Cloneable、Serializable、Iterable和Collection。所以，在某种程度上，我们早就有了类型的多继承。

由于Java 8中接口方法可以包含实现，类可以从多个接口中继承它们的行为（即实现的代码）。让我们从一个例子入手，看看如何充分利用这种能力来为我们服务。保持接口的精致性和正交性能帮助你在现有的代码基上最大程度地实现代码复用和行为组合。

**2. 利用正交方法的精简接口**

**3. 组合接口**

> **关于继承的一些错误观点**
>
> 继承不应该成为你一谈到代码复用就试图倚靠的万精油。比如，从一个拥有100个方法及字段的类进行继承就不是个好主意，因为这其实会引入不必要的复杂性。你完全可以使用**代理**有效地规避这种窘境，即创建一个方法通过该类的成员变量直接调用该类的方法。这就是为什么有的时候我们发现有些类被刻意地声明为final类型：声明为final的类不能被其他的类继承，避免发生这样的反模式，防止核心代码的功能被污染。注意，有的时候声明为final的类都会有其不同的原因，比如，String类被声明为final，因为我们不希望有人对这样的核心功能产生干扰。
>
> 这种思想同样也适用于使用默认方法的接口。通过精简的接口，你能获得最有效的组合，因为你可以只选择你需要的实现。

## 9.4 解决冲突的规则

我们知道Java语言中一个类只能继承一个父类，但是一个类可以实现多个接口。随着默认方法在Java 8中引入，有可能出现一个类继承了多个方法而它们使用的却是同样的函数签名。这种情况下，类会选择使用哪一个函数？在实际情况中，像这样的冲突可能极少发生，但是一旦发生这样的状况，必须要有一套规则来确定按照什么样的约定处理这些冲突。这一节中，我们会介绍Java编译器如何解决这种潜在的冲突。

此外，你可能早就对C++语言中著名的菱形继承问题有所了解，菱形继承问题中一个类同时继承了具有相同函数签名的两个方法。到底该选择哪一个实现呢？ Java 8也提供了解决这个问题的方案。

### 9.4.1 解决问题的三条规则

如果一个类使用相同的函数签名从多个地方（比如另一个类或接口）继承了方法，通过三条规则可以进行判断。

1. 类中的方法优先级最高。类或父类中声明的方法的优先级高于任何声明为默认方法的优先级。
2. 如果无法依据第一条进行判断，那么子接口的优先级更高：函数签名相同时，优先选择拥有最具体实现的默认方法的接口，即如果B继承了A，那么B就比A更加具体。
3. 最后，如果还是无法判断，继承了多个接口的类必须通过显式覆盖和调用期望的方法，显式地选择使用哪一个默认方法的实现。

### 9.4.2 选择提供了最具体实现的默认方法的接口

这个例子中C类同时实现了B接口和A接口，而这两个接口恰巧又都定义了名为hello的默认方法。另外，B继承自A。

~~~mermaid
classDiagram
	class A {
		+ void hello()
	}
	class B {
		+ void hello()
	}
	A <|-- B
	A <|.. C
	B <|.. C
~~~

编译器会使用声明的哪一个hello方法呢？按照规则(2)，应该选择的是提供了最具体实现的默认方法的接口。由于B比A更具体，所以应该选择B的hello方法。

现在，我们看看如果C像下面这样继承自D，会发生什么情况：

~~~mermaid
classDiagram
	class A {
		+ void hello()
	}
	class B {
		+ void hello()
	}
	A <|-- B
	D <|-- C
	A <|.. D
	A <|.. C
	B <|.. C
~~~

依据规则(1)，类中声明的方法具有更高的优先级。D并未覆盖hello方法，可是它实现了接口A。所以它就拥有了接口A的默认方法。规则(2)说如果类或者父类没有对应的方法，那么就应该选择提供了最具体实现的接口中的方法。因此，编译器会在接口A和接口B的hello方法之间做选择。由于B更加具体，所以程序会再次打印输出“Hello from B”。

> **测验9.2：牢记这些判断的规则**
>
> 我们在这个测验中继续复用之前的例子，唯一的不同在于D现在显式地覆盖了从A接口中继承的hello方法。你认为现在的输出会是什么呢？
>
> 答案：由于依据规则(1)，父类中声明的方法具有更高的优先级，所以程序会打印输出“Hello from D”。
>
> 注意，D的声明如下：
>
> ~~~java
> public abstract class D implements A { 
> 	public abstract void hello(); 
> }
> ~~~
>
> 这样的结果是，虽然在结构上，其他的地方已经声明了默认方法的实现，C还是必须提供自己的hello方法。

### 9.4.3 冲突及如何显式地消除歧义

到目前为止，你看到的这些例子都能够应用前两条判断规则解决。让我们更进一步，假设B不再继承A

~~~mermaid
classDiagram
	class A {
		+ void hello()
	}
	class B {
		+ void hello()
	}
	A <|.. C
	B <|.. C
~~~

这时规则(2)就无法进行判断了，因为从编译器的角度看没有哪一个接口的实现更加具体，两个都差不多。A接口和B接口的hello方法都是有效的选项。所以，Java编译器这时就会抛出一个编译错误，因为它无法判断哪一个方法更合适：“Error: class C inherits unrelated defaults for hello() from types B and A.”

**冲突的解决**

解决这种两个可能的有效方法之间的冲突，没有太多方案；你只能显式地决定你希望在C中使用哪一个方法。为了达到这个目的，你可以覆盖类C中的hello方法，在它的方法体内显式地调用你希望调用的方法。Java 8中引入了一种新的语法X.super.m(…)，其中X是你希望调用的m方法所在的父接口。举例来说，如果你希望C使用来自于B的默认方法，它的调用方式看起来就如下所示：

~~~java
public class C implements B, A { 
    void hello(){ 
        B.super.hello(); 
    } 
}
~~~

>**测验9.3：几乎完全一样的函数签名**
>
>这个测试中，我们假设接口A和B的声明如下所示：
>
>~~~java
>public interface A{ 
>    default Number getNumber(){ 
>    	return 10; 
>    } 
>} 
>public interface B{ 
>    default Integer getNumber(){ 
>	    return 42; 
>    } 
>}
>~~~
>
>类C的声明如下：
>
>~~~java
>public class C implements B, A { 
>    public static void main(String... args) { 
>	    System.out.println(new C().getNumber()); 
>    } 
>}
>~~~
>
>这个程序的会打印输出什么呢？
>
>答案：类C无法判断A或者B到底哪一个更加具体。这就是类C无法通过编译的原因。

### 9.4.4 菱形继承问题

让我们考虑最后一种场景，它亦是C++里中最令人头痛的难题。

图9-8以UML图的方式描述了出现这种问题的场景。这种问题叫“菱形问题”，因为类的继承关系图形状像菱形。这种情况下类D中的默认方法到底继承自什么地方 ——源自B的默认方法，还是源自C的默认方法？实际上只有一个方法声明可以选择。只有A声明了一个默认方法。由于这个接口是D的父接口，代码会打印输出“Hello from A”。

~~~mermaid
classDiagram
	class A {
		+ void hello()
	}
	A <|-- B
	A <|-- C
	B <|.. D
	C <|.. D
~~~

现在，我们看看另一种情况，如果B中也提供了一个默认的hello方法，并且函数签名跟A中的方法也完全一致，这时会发生什么情况呢？根据规则(2)，编译器会选择提供了更具体实现的接口中的方法。由于B比A更加具体，所以编译器会选择B中声明的默认方法。如果B和C都使用相同的函数签名声明了hello方法，就会出现冲突，正如我们之前所介绍的，你需要显式地指定使用哪个方法。

顺便提一句，如果你在C接口中添加一个抽象的hello方法（这次添加的不是一个默认方法），会发生什么情况呢？你可能也想知道答案。

这个新添加到C接口中的抽象方法hello比由接口A继承而来的hello方法拥有更高的优先级，因为C接口更加具体。因此，类D现在需要为hello显式地添加实现，否则该程序无法通过编译。

> **C++语言中的菱形问题**
>
> C++语言中的菱形问题要复杂得多。
>
> - 首先，C++允许类的多继承。默认情况下，如果类D继承了类B和类C，而类B和类C又都继承自类A，类D实际直接访问的是B对象和C对象的副本。最后的结果是，要使用A中的方法必须显式地声明：这些方法来自于B接口，还是来自于C接口。
> - 此外，类也有状态，所以修改B的成员变量不会在C对象的副本中反映出来。

现在你应该已经了解了，如果一个类的默认方法使用相同的函数签名继承自多个接口，解决冲突的机制其实相当简单。你只需要遵守下面这三条准则就能解决所有可能的冲突。

- 首先，类或父类中显式声明的方法，其优先级高于所有的默认方法。
- 如果用第一条无法判断，方法签名又没有区别，那么选择提供最具体实现的默认方法的接口。
- 最后，如果冲突依旧无法解决，你就只能在你的类中覆盖该默认方法，显式地指定在你的类中使用哪一个接口中的方法。

# 第10章 用Optional取代null

## 10.1 如何为缺失的值建模

假设你需要处理下面这样的嵌套对象，这是一个拥有汽车及汽车保险的客户。

~~~java
public class Person { 
    private Car car; 
    public Car getCar() { return car; } 
} 
public class Car { 
    private Insurance insurance; 
    public Insurance getInsurance() { return insurance; } 
} 
public class Insurance { 
    private String name; 
    public String getName() { return name; } 
}
~~~

那么，下面这段代码存在怎样的问题呢？

~~~java
public String getCarInsuranceName(Person person) { 
	return person.getCar().getInsurance().getName(); 
}
~~~

这段代码看起来相当正常，但是现实生活中很多人没有车。所以调用getCar方法的结果会怎样呢？在实践中，一种比较常见的做法是返回一个null引用，表示该值的缺失，即用户没有车。而接下来，对getInsurance的调用会返回null引用的insurance，这会导致运行时出现一个NullPointerException，终止程序的运行。但这还不是全部。如果返回的person值为null会怎样？如果getInsurance的返回值也是null，结果又会怎样？

### 10.1.1 采用防御式检查减少 NullPointerException

怎样做才能避免这种不期而至的NullPointerException呢？通常，你可以在需要的地方添加null的检查（过于激进的防御式检查甚至会在不太需要的地方添加检测代码），并且添加的方式往往各有不同。下面这个例子是我们试图在方法中避免NullPointerException的第一次尝试。

~~~java
// 代码清单10-2 null-安全的第一种尝试：深层质疑
public String getCarInsuranceName(Person person) { 
    // 每个null检查都会增加调用链上剩余代码的嵌套层数
	if (person != null) { 
		Car car = person.getCar(); 
		if (car != null) { 
			Insurance insurance = car.getInsurance(); 
			if (insurance != null) { 
				return insurance.getName();
			} 
		} 
	} 
	return "Unknown"; 
}
~~~

这个方法每次引用一个变量都会做一次null检查，如果引用链上的任何一个遍历的解变量值为null，它就返回一个值为“Unknown”的字符串。唯一的例外是保险公司的名字，你不需要对它进行检查，原因很简单，因为任何一家公司必定有个名字。注意到了吗，由于你掌握业务领域的知识，避免了最后这个检查，但这并不会直接反映在你建模数据的Java类之中。

我们将代码清单10-2标记为“深层质疑”，原因是它不断重复着一种模式：每次你不确定一个变量是否为null时，都需要添加一个进一步嵌套的if块，也增加了代码缩进的层数。很明显，这种方式不具备扩展性，同时还牺牲了代码的可读性。面对这种窘境，你也许愿意尝试另一种方案。下面的代码清单中，我们试图通过一种不同的方式避免这种问题。

~~~java
// 代码清单10-3 null-安全的第二种尝试：过多的退出语句
public String getCarInsuranceName(Person person) { 
    // 每个null检查都会添加新的退出点
    if (person == null) { 
    	return "Unknown"; 
    } 
    Car car = person.getCar(); 
    if (car == null) { 
    	return "Unknown"; 
    } 
    Insurance insurance = car.getInsurance(); 
    if (insurance == null) { 
    	return "Unknown"; 
    } 
    return insurance.getName(); 
}
~~~

第二种尝试中，你试图避免深层递归的if语句块，采用了一种不同的策略：每次你遭遇null变量，都返回一个字符串常量“Unknown”。然而，这种方案远非理想，现在这个方法有了四个截然不同的退出点，使得代码的维护异常艰难。更糟的是，发生null时返回的默认值，即字符串“Unknown”在三个不同的地方重复出现——出现拼写错误的概率不小！当然，你可能会说，我们可以用把它们抽取到一个常量中的方式避免这种问题。

进一步而言，这种流程是极易出错的；如果你忘记检查了那个可能为null的属性会怎样？

### 10.1.2 null 带来的种种问题

- 它是错误之源。
  NullPointerException是目前Java程序开发中最典型的异常。
- 它会使你的代码膨胀。
  它让你的代码充斥着深度嵌套的null检查，代码的可读性糟糕透顶。
- 它自身是毫无意义的。
  null自身没有任何的语义，尤其是，它代表的是在静态类型语言中以一种错误的方式对缺失变量值的建模。
- 它破坏了Java的哲学。
  Java一直试图避免让程序员意识到指针的存在，唯一的例外是：null指针。
- 它在Java的类型系统上开了个口子。
  null并不属于任何类型，这意味着它可以被赋值给任意引用类型的变量。这会导致问题，原因是当这个变量被传递到系统中的另一个部分后，你将无法获知这个null变量最初的赋值到底是什么类型。

为了解业界针对这个问题给出的解决方案，我们一起简单看看其他语言提供了哪些功能。

### 10.1.3 其他语言中 null 的替代品

近年来出现的语言，比如Groovy，通过引入**安全导航操作符**（Safe Navigation Operator，标记为?）可以安全访问可能为null的变量。为了理解它是如何工作的，让我们看看下面这段Groovy代码，它的功能是获取某个用户替他的车保险的保险公司的名称：

~~~groovy
def carInsuranceName = person?.car?.insurance?.name 
~~~

这段代码的表述相当清晰。person对象可能没有car对象，你试图通过赋一个null给Person对象的car引用，对这种可能性建模。类似地，car也可能没有insurance。Groovy的安全导航操作符能够避免在访问这些可能为null引用的变量时抛出NullPointerException，在调用链中的变量遭遇null时将null引用沿着调用链传递下去，返回一个null。

关于Java 7的讨论中曾经建议过一个类似的功能，不过后来又被舍弃了。不知道为什么，我们在Java中似乎并不特别期待出现一种安全导航操作符，几乎所有的Java程序员碰到NullPointerException时的第一冲动就是添加一个if语句，在调用方法使用该变量之前检查它的值是否为null，快速地搞定问题。如果你按照这种方式解决问题，丝毫不考虑你的算法或者你的数据模型在这种状况下是否应该返回一个null，那么你其实并没有真正解决这个问题，只是暂时地掩盖了问题，使得下次该问题的调查和修复更加困难，而你很可能就是下个星期或下个月要面对这个问题的人。刚才的那种方式实际上是掩耳盗铃，只是在清扫地毯下的灰尘。而Groovy的null安全解引用操作符也只是一个更强大的扫把，让我们可以毫无顾忌地犯错。你不会忘记做这样的检查，因为类型系统会强制你进行这样的操作。

另一些函数式语言，比如Haskell、Scala，试图从另一个角度处理这个问题。Haskell中包含了一个Maybe类型，它本质上是对optional值的封装。Maybe类型的变量可以是指定类型的值，也可以什么都不是。但是它并没有null引用的概念。Scala有类似的数据结构，名字叫Option[T]，它既可以包含类型为T的变量，也可以不包含该变量，我们在第15章会详细讨论这种类型。要使用这种类型，你必须显式地调用Option类型的available操作，检查该变量是否有值，而这其实也是一种变相的“null检查”。

好了，我们似乎有些跑题了，刚才这些听起来都十分抽象。你可能会疑惑：“那么Java 8提供了什么呢？”嗯，实际上Java 8从“optional值”的想法中吸取了灵感，引入了一个名为`java.util.Optional<T>`的新的类。这一章里，我们会展示使用这种方式对可能缺失的值建模，而不是直接将null赋值给变量所带来的好处。我们还会阐释从null到Optional的迁移，你需要反思的是：如何在你的域模型中使用optional值。最后，我们会介绍新的Optional类提供的功能，并附几个实际的例子，展示如何有效地使用这些特性。最终，你会学会如何设计更好的API——用户只需要阅读方法签名就能知道它是否接受一个optional的值。

## 10.2 Optional 类入门

汲取Haskell和Scala的灵感，Java 8中引入了一个新的类`java.util.Optional<T>`。这是一个封装Optional值的类。举例来说，使用新的类意味着，如果你知道一个人可能有也可能没有车，那么Person类内部的car变量就不应该声明为Car，遭遇某人没有车时把null引用赋值给它，而是应该像图10-1那样直接将其声明为`Optional<Car>`类型。

变量存在时，Optional类只是对类简单封装。变量不存在时，缺失的值会被建模成一个“空”的Optional对象，由方法Optional.empty()返回。Optional.empty()方法是一个静态工厂方法，它返回Optional类的特定单一实例。

你可能还有疑惑，null引用和Optional.empty()有什么本质的区别吗？从语义上，你可以把它们当作一回事儿，但是实际中它们之间的差别非常大：如果你尝试解引用一个 null ，一定会触发 NullPointerException ，不过使用Optional.empty()就完全没事儿，它是Optional类的一个有效对象，多种场景都能调用，非常有用。关于这一点，接下来的部分会详细介绍。

使用Optional而不是null的一个非常重要而又实际的语义区别是，第一个例子中，我们在声明变量时使用的是`Optional<Car>`类型，而不是Car类型，这句声明非常清楚地表明了这里发生变量缺失是允许的。与此相反，使用Car这样的类型，可能将变量赋值为null，这意味着你需要独立面对这些，你只能依赖你对业务模型的理解，判断一个null是否属于该变量的有效范畴。

牢记上面这些原则，你现在可以使用Optional类对代码清单10-1中最初的代码进行重构，结果如下。

~~~java
//代码清单10-4 使用Optional重新定义Person/Car/Insurance的数据模型
public class Person { 
    // 人可能有车，也可能没有车，因此将这个字段声明为Optional
    private Optional<Car> car; 
    public Optional<Car> getCar() { return car; } 
}
public class Car { 
    // 车可能进行了保险，也可能没有保险，所以将这个字段声明为Optional
    private Optional<Insurance> insurance; 
    public Optional<Insurance> getInsurance() { return insurance; } 
} 
public class Insurance { 
    // 保险公司必须有名字
    private String name; 
    public String getName() { return name; }
}
~~~

发现Optional是如何丰富你模型的语义了吧。代码中person引用的是`Optional<Car>`， 而car引用的是`Optional<Insurance>`，这种方式非常清晰地表达了你的模型中一个person可能拥有也可能没有car的情形，同样，car可能进行了保险，也可能没有保险。

与此同时，我们看到insurance公司的名称被声明成String类型，而不是`Optional<String>`，这非常清楚地表明声明为insurance公司的类型必须提供公司名称。使用这种方式，一旦解引用insurance公司名称时发生NullPointerException，你就能非常确定地知道出错的原因，不再需要为其添加null的检查，因为null的检查只会掩盖问题，并未真正地修复问题。insurance公司必须有个名字，所以，如果你遇到一个公司没有名称，你需要调查你的数据出了什么问题，而不应该再添加一段代码，将这个问题隐藏。

在你的代码中始终如一地使用Optional，能非常清晰地界定出变量值的缺失是结构上的问题，还是你算法上的缺陷，抑或是你数据中的问题。另外，我们还想特别强调，引入Optional类的意图并非要消除每一个null引用。与此相反，它的目标是帮助你更好地设计出普适的API，让程序员看到方法签名，就能了解它是否接受一个Optional的值。这种强制会让你更积极地将变量从Optional中解包出来，直面缺失的变量值。

## 10.3 应用 Optional 的几种模式

### 10.3.1 创建 Optional 对象

使用Optional之前，你首先需要学习的是如何创建Optional对象。完成这一任务有多种方法。

#### 1. 声明一个空的Optional

正如前文已经提到，你可以通过静态工厂方法Optional.empty，创建一个空的Optional对象：

~~~java
Optional<Car> optCar = Optional.empty(); 
~~~

#### 2. 依据一个非空值创建Optional

你还可以使用静态工厂方法Optional.of，依据一个非空值创建一个Optional对象：

~~~java
Optional<Car> optCar = Optional.of(car); 
~~~

如果car是一个null，这段代码会立即抛出一个NullPointerException，而不是等到你试图访问car的属性值时才返回一个错误。

#### 3. 可接受null的Optional

最后，使用静态工厂方法Optional.ofNullable，你可以创建一个允许null值的Optional对象：

~~~java
Optional<Car> optCar = Optional.ofNullable(car); 
~~~

如果car是null，那么得到的Optional对象就是个空对象。

你可能已经猜到，我们还需要继续研究“如何获取Optional变量中的值”。尤其是，Optional提供了一个get方法，它能非常精准地完成这项工作，我们在后面会详细介绍这部分内容。不过get方法在遭遇到空的Optional对象时也会抛出异常，所以不按照约定的方式使用它，又会让我们再度陷入由null引起的代码维护的梦魇。因此，我们首先从无需显式检查的Optional值的使用入手，这些方法与Stream中的某些操作极其相似。

### 10.3.2 使用 map 从 Optional 对象中提取和转换值

从对象中提取信息是一种比较常见的模式。比如，你可能想要从insurance公司对象中提取公司的名称。提取名称之前，你需要检查insurance对象是否为null，代码如下所示：

~~~java
String name = null; 
if(insurance != null){ 
	name = insurance.getName(); 
}
~~~

为了支持这种模式，Optional提供了一个map方法。它的工作方式如下（这里，我们继续借用了代码清单10-4的模式）

~~~java
Optional<Insurance> optInsurance = Optional.ofNullable(insurance); 
Optional<String> name = optInsurance.map(Insurance::getName);
~~~

从概念上，这与我们在第4章和第5章中看到的流的map方法相差无几。map操作会将提供的函数应用于流的每个元素。你可以把Optional对象看成一种特殊的集合数据，它至多包含一个元素。如果Optional包含一个值，那函数就将该值作为参数传递给map，对该值进行转换。如果Optional为空，就什么也不做。

这看起来挺有用，但是你怎样才能应用起来，重构之前的代码呢？前文的代码里用安全的方式链接了多个方法。

~~~java
public String getCarInsuranceName(Person person) { 
	return person.getCar().getInsurance().getName(); 
}
~~~

为了达到这个目的，我们需要求助Optional提供的另一个方法flatMap。

### 10.3.3 使用 flatMap 链接 Optional 对象

由于我们刚刚学习了如何使用map，你的第一反应可能是我们可以利用map重写之前的代码，如下所示：

~~~java
Optional<Person> optPerson = Optional.of(person); 
Optional<String> name = 
	optPerson.map(Person::getCar) 
		.map(Car::getInsurance) 
		.map(Insurance::getName);
~~~

不幸的是，这段代码无法通过编译。为什么呢？optPerson是`Optional<Person>`类型的变量， 调用map方法应该没有问题。但getCar返回的是一个`Optional<Car>`类型的对象（如代码清单10-4所示），这意味着map操作的结果是一个`Optional<Optional<Car>>`类型的对象。因此，它对getInsurance的调用是非法的，因为最外层的optional对象包含了另一个optional对象的值，而它当然不会支持getInsurance方法。

所以，我们该如何解决这个问题呢？让我们再回顾一下你刚刚在流上使用过的模式：flatMap方法。使用流时，flatMap方法接受一个函数作为参数，这个函数的返回值是另一个流。这个方法会应用到流中的每一个元素，最终形成一个新的流的流。但是flagMap会用流的内容替换每个新生成的流。换句话说，由方法生成的各个流会被合并或者扁平化为一个单一的流。这里你希望的结果其实也是类似的，但是你想要的是将两层的optional合并为一个。

#### 1. 使用Optional获取car的保险公司名称

相信现在你已经对Optional的map和flatMap方法有了一定的了解，让我们看看如何应用。

代码清单10-2和代码清单10-3的示例用基于Optional的数据模式重写之后，如代码清单10-5所示。

~~~java
// 代码清单10-5 使用Optional获取car的Insurance名称
public String getCarInsuranceName(Optional<Person> person) { 
	return person.flatMap(Person::getCar) 
        .flatMap(Car::getInsurance) 
        .map(Insurance::getName) 
        // 如果Optional的结果值为空，设置默认值
        .orElse("Unknown"); 
}
~~~

通过比较代码清单10-5和之前的两个代码清单，我们可以看到，处理潜在可能缺失的值时，使用Optional具有明显的优势。这一次，你可以用非常容易却又普适的方法实现之前你期望的效果——不再需要使用那么多的条件分支，也不会增加代码的复杂性。

从具体的代码实现来看，首先我们注意到你修改了代码清单10-2和代码清单10-3中的getCarInsuranceName方法的签名，因为我们很明确地知道存在这样的用例，即一个不存在的Person被传递给了方法，比如，Person是使用某个标识符从数据库中查询出来的，你想要对数据库中不存在指定标识符对应的用户数据的情况进行建模。你可以将方法的参数类型由Person改为`Optional<Person>`，对这种特殊情况进行建模。

我们再一次看到这种方式的优点，它通过类型系统让你的域模型中隐藏的知识显式地体现在你的代码中，换句话说，你永远都不应该忘记语言的首要功能就是沟通，即使对程序设计语言而言也没有什么不同。声明方法接受一个Optional参数，或者将结果作为Optional类型返回，让你的同事或者未来你方法的使用者，很清楚地知道它可以接受空值，或者它可能返回一个空值。

#### 2. 使用Optional解引用串接的Person/Car/Insurance对象

由`Optional<Person>`对象，我们可以结合使用之前介绍的map和flatMap方法，从Person中解引用出Car，从Car中解引用出Insurance，从Insurance对象中解引用出包含insurance公司名称的字符串。

这里，我们从以Optional封装的Person入手，对其调用flatMap(Person::getCar)。如前所述，这种调用逻辑上可以划分为两步。

第一步，某个Function作为参数，被传递给由Optional封装的Person对象，对其进行转换。这个场景中，Function的具体表现是一个方法引用，即对Person对象的getCar方法进行调用。由于该方法返回一个`Optional<Car>`类型的对象，Optional内的Person也被转换成了这种对象的实例，结果就是一个两层的Optional对象，最终它们会被flagMap操作合并。

从纯理论的角度而言，你可以将这种合并操作简单地看成把两个Optional对象结合在一起，如果其中有一个对象为空，就构成一个空的Optional对象。如果你对一个空的Optional对象调用flatMap，实际情况又会如何呢？结果不会发生任何改变，返回值也是个空的Optional对象。与此相反，如果Optional封装了一个Person对象，传递给flapMap的Function，就会应用到Person上对其进行处理。这个例子中，由于Function的返回值已经是一个Optional对象，flapMap方法就直接将其返回。

第二步与第一步大同小异，它会将`Optional<Car>`转换为`Optional<Insurance>`。第三步则会将`Optional<Insurance>`转化为`Optional<String>`对象，由于Insurance.getName()方法的返回类型为String，这里就不再需要进行flapMap操作了。

截至目前为止，返回的Optional可能是两种情况：如果调用链上的任何一个方法返回一个空的Optional，那么结果就为空，否则返回的值就是你期望的保险公司的名称。那么，你如何读出这个值呢？毕竟你最后得到的这个对象还是个Optional<String>，它可能包含保险公司的名称，也可能为空。代码清单10-5中，我们使用了一个名为orElse的方法，当Optional的值为空时，它会为其设定一个默认值。除此之外，还有很多其他的方法可以为Optional设定默认值，或者解析出Optional代表的值。

> **在域模型中使用Optional，以及为什么它们无法序列化**
>
> 在代码清单10-4中，我们展示了如何在你的域模型中使用Optional，将允许缺失或者暂无定义的变量值用特殊的形式标记出来。然而，Optional类设计者的初衷并非如此，他们构思时怀揣的是另一个用例。这一点，Java语言的架构师Brian Goetz曾经非常明确地陈述过，Optional的设计初衷仅仅是要支持能返回Optional对象的语法。
>
> 由于Optional类设计时就没特别考虑将其作为类的字段使用，所以它也并未实现Serializable接口。由于这个原因，如果你的应用使用了某些要求序列化的库或者框架，在域模型中使用Optional，有可能引发应用程序故障。然而，我们相信，通过前面的介绍，你已经看到用Optional声明域模型中的某些类型是个不错的主意，尤其是你需要遍历有可能全部或部分为空，或者可能不存在的对象时。如果你一定要实现序列化的域模型，作为替代方案，我们建议你像下面这个例子那样，提供一个能访问声明为Optional、变量值可能缺失的接口，代码清单如下：
>
> ~~~java
> public class Person { 
>     private Car car; 
>     public Optional<Car> getCarAsOptional() { 
>     	return Optional.ofNullable(car); 
>     } 
> }
> ~~~

### 10.3.4 默认行为及解引用 Optional 对象

我们决定采用orElse方法读取这个变量的值，使用这种方式你还可以定义一个默认值，遭遇空的Optional变量时，默认值会作为该方法的调用返回值。Optional类提供了多种方法读取Optional实例中的变量值。

- get()是这些方法中最简单但又最不安全的方法。如果变量存在，它直接返回封装的变量值，否则就抛出一个NoSuchElementException异常。所以，除非你非常确定Optional变量一定包含值，否则使用这个方法是个相当糟糕的主意。此外，这种方式即便相对于嵌套式的null检查，也并未体现出多大的改进。
- orElse(T other)是我们在代码清单10-5中使用的方法，正如之前提到的，它允许你在Optional对象不包含值时提供一个默认值。
- orElseGet(Supplier<? extends T> other)是orElse方法的延迟调用版，Supplier方法只有在Optional对象不含值时才执行调用。如果创建默认值是件耗时费力的工作，你应该考虑采用这种方式（借此提升程序的性能），或者你需要非常确定某个方法仅在Optional为空时才进行调用，也可以考虑该方式（这种情况有严格的限制条件）。
- orElseThrow(Supplier<? extends X> exceptionSupplier)和get方法非常类似，它们遭遇Optional对象为空时都会抛出一个异常，但是使用orElseThrow你可以定制希望抛出的异常类型。
- ifPresent(Consumer<? super T>)让你能在变量值存在时执行一个作为参数传入的方法，否则就不进行任何操作。

Optional类和Stream接口的相似之处，远不止map和flatMap这两个方法。还有第三个方法filter，它的行为在两种类型之间也极其相似，我们会在10.3.6节做进一步的介绍。

### 10.3.5 两个 Optional 对象的组合

现在，我们假设你有这样一个方法，它接受一个Person和一个Car对象，并以此为条件对外部提供的服务进行查询，通过一些复杂的业务逻辑，试图找到满足该组合的最便宜的保险公司

我们还假设你想要该方法的一个null-安全的版本，它接受两个Optional对象作为参数，返回值是一个`Optional<Insurance>`对象，如果传入的任何一个参数值为空，它的返回值亦为空。Optional类还提供了一个isPresent方法，如果Optional对象包含值，该方法就返回true，所以你的第一想法可能是通过下面这种方式实现该方法：

~~~java
public Optional<Insurance> nullSafeFindCheapestInsurance(Optional<Person> person, Optional<Car> car) { 
	if (person.isPresent() && car.isPresent()) {
		return Optional.of(findCheapestInsurance(person.get(), car.get())); 
	} else { 
		return Optional.empty(); 
	} 
}
~~~

这个方法具有明显的优势，我们从它的签名就能非常清楚地知道无论是person还是car，它的值都有可能为空，出现这种情况时，方法的返回值也不会包含任何值。不幸的是，该方法的具体实现和你之前曾经实现的null检查太相似了：方法接受一个Person和一个Car对象作为参数，而二者都有可能为null。利用Optional类提供的特性，有没有更好或更地道的方式来实现这个方法呢? 花几分钟时间思考一下测验10.1，试试能不能找到更优雅的解决方案。

> **测验10.1：以不解包的方式组合两个Optional对象**
>
> 结合本节中介绍的map和flatMap方法，用一行语句重新实现之前出现的nullSafeFindCheapestInsurance()方法。
>
> 答案：你可以像使用三元操作符那样，无需任何条件判断的结构，以一行语句实现该方法，代码如下。
>
> ~~~java
> public Optional<Insurance> nullSafeFindCheapestInsurance(Optional<Person> person, Optional<Car> car) { 
> 	return person.flatMap(p -> car.map(c -> findCheapestInsurance(p, c))); 
> }
> ~~~
>
> 这段代码中，你对第一个Optional对象调用flatMap方法，如果它是个空值，传递给它的Lambda表达式不会执行，这次调用会直接返回一个空的Optional对象。反之，如果person对象存在，这次调用就会将其作为函数Function的输入，并按照与flatMap方法的约定返回一个`Optional<Insurance>`对象。
>
> 这个函数的函数体会对第二个Optional对象执行map操作，如果第二个对象不包含car，函数Function就返回一个空的Optional对象，整个nullSafeFindCheapestInsuranc方法的返回值也是一个空的Optional对象。
>
> 最后，如果person和car对象都存在，作为参数传递给map方法的Lambda表达式能够使用这两个值安全地调用原始的findCheapestInsurance方法，完成期望的操作。

### 10.3.6 使用 filter 剔除特定的值

你经常需要调用某个对象的方法，查看它的某些属性。比如，你可能需要检查保险公司的名称是否为“Cambridge-Insurance”。为了以一种安全的方式进行这些操作，你首先需要确定引用指向的Insurance对象是否为null，之后再调用它的getName方法，如下所示：

~~~java
Insurance insurance = ...; 
if(insurance != null && "CambridgeInsurance".equals(insurance.getName())){ 
	System.out.println("ok");
}
~~~

使用Optional对象的filter方法，这段代码可以重构如下：

~~~java
Optional<Insurance> optInsurance = ...; 
optInsurance.filter(insurance -> "CambridgeInsurance".equals(insurance.getName()))
    .ifPresent(x -> System.out.println("ok"));
~~~

filter方法接受一个谓词作为参数。如果Optional对象的值存在，并且它符合谓词的条件，filter方法就返回其值；否则它就返回一个空的Optional对象。如果你还记得我们可以将Optional看成最多包含一个元素的Stream对象，这个方法的行为就非常清晰了。如果Optional对象为空，它不做任何操作，反之，它就对Optional对象中包含的值施加谓词操作。如果该操作的结果为true，它不做任何改变，直接返回该Optional对象，否则就将该值过滤掉，将Optional的值置空。

> **测验10.2：对Optional对象进行过滤**
>
> 假设在我们的Person/Car/Insurance 模型中，Person还提供了一个方法可以取得Person对象的年龄，请使用下面的签名改写代码清单10-5中的getCarInsuranceName方法：
>
> ~~~java
> public String getCarInsuranceName(Optional<Person> person, int minAge) 
> ~~~
>
> 找出年龄大于或者等于minAge参数的Person所对应的保险公司列表。
>
> 答案：你可以对Optional封装的Person对象进行filter操作，设置相应的条件谓词，即如果person的年龄大于minAge参数的设定值，就返回该值，并将谓词传递给filter方法，代码如下所示。
>
> ~~~java
> public String getCarInsuranceName(Optional<Person> person, int minAge) { 
> 	return person.filter(p -> p.getAge() >= minAge) 
>         .flatMap(Person::getCar) 
>         .flatMap(Car::getInsurance) 
>         .map(Insurance::getName) 
>         .orElse("Unknown"); 
> }
> ~~~

| 方法        | 描述                                                         |
| ----------- | ------------------------------------------------------------ |
| empty       | 返回一个空的Optional实例                                     |
| filter      | 如果值存在并且满足提供的谓词，就返回包含该值的Optional对象；否则返回一个空的Optional对象 |
| flatMap     | 如果值存在，就对该值执行提供的 mapping 函数调用，返回一个 Optional 类型的值，否则就返回一个空的 Optional 对象 |
| get         | 如果该值存在，将该值用 Optional 封装返回，否则抛出一个 NoSuchElementException 异常 |
| ifPresent   | 如果值存在，就执行使用该值的方法调用，否则什么也不做         |
| isPresent   | 如果值存在就返回 true，否则返回 false                        |
| map         | 如果值存在，就对该值执行提供的 mapping 函数调用              |
| of          | 将指定值用 Optional 封装之后返回，如果该值为 null，则抛出一个 NullPointerException异常 |
| ofNullable  | 将指定值用 Optional 封装之后返回，如果该值为 null，则返回一个空的 Optional 对象 |
| orElse      | 如果有值则将其返回，否则返回一个默认值                       |
| orElseGet   | 如果有值则将其返回，否则返回一个由指定的 Supplier 接口生成的值 |
| orElseThrow | 如果有值则将其返回，否则抛出一个由指定的 Supplier 接口生成的异常 |

## 10.4 使用 Optional 的实战示例

实际上，我们相信如果Optional类能够在这些API创建之初就存在的话，很多API的设计编写可能会大有不同。为了保持后向兼容性，我们很难对老的Java API进行改动，让它们也使用Optional，但这并不表示我们什么也做不了。你可以在自己的代码中添加一些工具方法，修复或者绕过这些问题，让你的代码能享受Optional带来的威力。我们会通过几个实际的例子讲解如何达到这样的目的。

### 10.4.1 用 Optional 封装可能为 null 的值

现存Java API几乎都是通过返回一个null的方式来表示需要值的缺失，或者由于某些原因计算无法得到该值。比如，如果Map中不含指定的键对应的值，它的get方法会返回一个null。但是，正如我们之前介绍的，大多数情况下，你可能希望这些方法能返回一个Optional对象。你无法修改这些方法的签名，但是你很容易用Optional对这些方法的返回值进行封装。

我们接着用Map做例子，假设你有一个Map<String, Object>方法，访问由key索引的值时，如果map中没有与key关联的值，该次调用就会返回一个null。

~~~java
Object value = map.get("key");
~~~

使用Optional封装map的返回值，你可以对这段代码进行优化。要达到这个目的有两种方式：你可以使用笨拙的if-then-else判断语句，毫无疑问这种方式会增加代码的复杂度；或者你可以采用我们前文介绍的Optional.ofNullable方法：

~~~java
Optional<Object> value = Optional.ofNullable(map.get("key"));
~~~

每次你希望安全地对潜在为null的对象进行转换，将其替换为Optional对象时，都可以考虑使用这种方法。

### 10.4.2 异常与 Optional 的对比

由于某种原因，函数无法返回某个值，这时除了返回null，Java API比较常见的替代做法是抛出一个异常。这种情况比较典型的例子是使用静态方法Integer.parseInt(String)，将String转换为int。在这个例子中，如果String无法解析到对应的整型，该方法就抛出一个NumberFormatException。最后的效果是，发生String无法转换为int时，代码发出一个遭遇非法参数的信号，唯一的不同是，这次你需要使用try/catch 语句，而不是使用if条件判断来控制一个变量的值是否非空。

你也可以用空的Optional对象，对遭遇无法转换的String时返回的非法值进行建模，这时你期望parseInt的返回值是一个optional。我们无法修改最初的Java方法，但是这无碍我们进行需要的改进，你可以实现一个工具方法，将这部分逻辑封装于其中，最终返回一个我们希望的Optional对象，代码如下所示。

~~~java
// 代码清单10-6 将String转换为Integer，并返回一个Optional对象
public static Optional<Integer> stringToInt(String s) { 
    try { 
        // 如果String能转换为对应的Integer，将其封装在Optioal对象中返回
    	return Optional.of(Integer.parseInt(s)); 
    } catch (NumberFormatException e) {
        // 否则返回一个空的Optional对象
    	return Optional.empty(); 
    } 
}
~~~

我们的建议是，你可以将多个类似的方法封装到一个工具类中，让我们称之为OptionalUtility。通过这种方式，你以后就能直接调用OptionalUtility.stringToInt方法，将String转换为一个`Optional<Integer>`对象，而不再需要记得你在其中封装了笨拙的try/catch的逻辑了。

**基础类型的Optional对象，以及为什么应该避免使用它们**

不知道你注意到了没有，与 Stream对象一样，Optional也提供了类似的基础类型——OptionalInt、OptionalLong以及OptionalDouble——所以代码清单10-6中的方法可以不返回`Optional<Integer>`，而是直接返回一个OptionalInt类型的对象。第5章中，我们讨论过使用基础类型Stream的场景，尤其是如果Stream对象包含了大量元素，出于性能的考量，使用基础类型是不错的选择，但对Optional对象而言，这个理由就不成立了，因为Optional对象最多只包含一个值。

我们不推荐大家使用基础类型的Optional，因为基础类型的Optional不支持map、flatMap以及filter方法，而这些却是Optional类最有用的方法（正如我们在10.2节所看到的那样）。此外，与Stream一样，Optional对象无法由基础类型的Optional组合构成，所以，举例而言，如果代码清单10-6中返回的是OptionalInt类型的对象，你就不能将其作为方法引用传递给另一个Optional对象的flatMap方法。

### 10.4.3 把所有内容整合起来

为了展示之前介绍过的Optional类的各种方法整合在一起的威力，我们假设你需要向你的程序传递一些属性。为了举例以及测试你开发的代码，你创建了一些示例属性，如下所示

~~~java
Properties props = new Properties(); 
props.setProperty("a", "5"); 
props.setProperty("b", "true"); 
props.setProperty("c", "-3");
~~~

现在，我们假设你的程序需要从这些属性中读取一个值，该值是以秒为单位计量的一段时间。由于一段时间必须是正数，你想要该方法符合下面的签名

~~~java
public int readDuration(Properties props, String name)
~~~

即，如果给定属性对应的值是一个代表正整数的字符串，就返回该整数值，任何其他的情况都返回0。为了明确这些需求，你可以采用JUnit的断言，将它们形式化

~~~java
assertEquals(5, readDuration(param, "a")); 
assertEquals(0, readDuration(param, "b")); 
assertEquals(0, readDuration(param, "c")); 
assertEquals(0, readDuration(param, "d"));
~~~

这些断言反映了初始的需求：如果属性是a，readDuration方法返回5，因为该属性对应的字符串能映射到一个正数；对于属性b，方法的返回值是0，因为它对应的值不是一个数字；对于c，方法的返回值是0，因为虽然它对应的值是个数字，不过它是个负数；对于d，方法的返回值是0，因为并不存在该名称对应的属性。让我们以命令式编程的方式实现满足这些需求的方法，代码清单如下所示。

~~~java
public int readDuration(Properties props, String name) { 
    String value = props.getProperty(name); 
    if (value != null) { 
        try { 
            int i = Integer.parseInt(value); 
            if (i > 0) { 
            	return i; 
        	} 
        } catch (NumberFormatException nfe) { }
    } 
    return 0; 
}
~~~

你可能已经预见，最终的实现既复杂又不具备可读性，呈现为多个由if语句及try/catch块儿构成的嵌套条件。花几分钟时间思考一下测验10.3，想想怎样使用本章内容实现同样的效果。

> **测验10.3：使用Optional从属性中读取duration**
>
> 请尝试使用Optional类提供的特性及代码清单10-6中提供的工具方法，通过一条精炼的语句重构代码清单10-7中的方法。
>
> 答案：如果需要访问的属性值不存在，Properties.getProperty(String)方法的返回值就是一个null，使用ofNullable工厂方法非常轻易地就能把该值转换为Optional对象。
>
> 接着，你可以向它的flatMap方法传递代码清单10-6中实现的OptionalUtility.stringToInt方法的引用，将Optional<String>转换为`Optional<Integer>`。
>
> 最后，你非常轻易地就可以过滤掉负数。
>
> 这种方式下，如果任何一个操作返回一个空的Optional对象，该方法都会返回orElse方法设置的默认值0；否则就返回封装在Optional对象中的正整数。
>
> 下面就是这段简化的实现：
>
> ~~~java
> public int readDuration(Properties props, String name) { 
>     return Optional.ofNullable(props.getProperty(name)) 
>         .flatMap(OptionalUtility::stringToInt) 
>         .filter(i -> i > 0) 
>         .orElse(0); 
> }
> ~~~

# 第11章 CompletableFuture：组合式异步编程

# 第12章 新的日期和时间API

在Java 1.0中，对日期和时间的支持只能依赖java.util.Date类。正如类名所表达的，这个类无法表示日期，只能以毫秒的精度表示时间。更糟糕的是它的易用性，由于某些原因未知的设计决策，这个类的易用性被深深地损害了，比如：年份的起始选择是1900年，月份的起始从0开始。这意味着，如果你想要用Date表示Java 8的发布日期，即2014年3月18日，需要创建下面这样的Date实例：

~~~java
Date date = new Date(114, 2, 18);
~~~

它的打印输出效果为：

~~~
Tue Mar 18 00:00:00 CET 2014
~~~

看起来不那么直观，不是吗？此外，甚至Date类的toString方法返回的字符串也容易误导人。以我们的例子而言，它的返回值中甚至还包含了JVM的默认时区CET，即中欧时间（Central Europe Time）。但这并不表示Date类在任何方面支持时区。

随着Java 1.0退出历史舞台，Date类的种种问题和限制几乎一扫而光，但很明显，这些历史旧账如果不牺牲前向兼容性是无法解决的。所以，在Java 1.1中，Date类中的很多方法被废弃了，取而代之的是java.util.Calendar类。很不幸，Calendar类也有类似的问题和设计缺陷，导致使用这些方法写出的代码非常容易出错。比如，月份依旧是从0开始计算（不过，至少Calendar类拿掉了由1900年开始计算年份这一设计）。更糟的是，同时存在Date和Calendar这两个类，也增加了程序员的困惑。到底该使用哪一个类呢？此外，有的特性只在某一个类有提供，比如用于以语言无关方式格式化和解析日期或时间的DateFormat方法就只在Date类里有。

DateFormat方法也有它自己的问题。比如，它不是线程安全的。这意味着两个线程如果尝试使用同一个formatter解析日期，你可能会得到无法预期的结果。

最后，Date和Calendar类都是可以变的。能把2014年3月18日修改成4月18日意味着什么呢？这种设计会将你拖入维护的噩梦，接下来的一章，我们会讨论函数式编程，你在该章中会了解到更多的细节。

所有这些缺陷和不一致导致用户们转投第三方的日期和时间库，比如Joda-Time。为了解决这些问题，Oracle决定在原生的Java API中提供高质量的日期和时间支持。所以，你会看到Java 8在java.time包中整合了很多Joda-Time的特性。

## 12.1 LocalDate、LocalTime、Instant、Duration以及Period

让我们从探索如何创建简单的日期和时间间隔入手。java.time包中提供了很多新的类可以帮你解决问题，它们是LocalDate、LocalTime、Instant、Duration和Period。

### 12.1.1 使用LocalDate和LocalTime

开始使用新的日期和时间API时，你最先碰到的可能是LocalDate类。该类的实例是一个不可变对象，它只提供了简单的日期，并不含当天的时间信息。另外，它也不附带任何与时区相关的信息。

你可以通过静态工厂方法of创建一个LocalDate实例。LocalDate实例提供了多种方法来读取常用的值，比如年份、月份、星期几等，如下所示。

~~~java
// 2014-03-18
LocalDate date = LocalDate.of(2014, 3, 18); 
// 2014
int year = date.getYear(); 
// MARCH
Month month = date.getMonth();
// 18
int day = date.getDayOfMonth(); 
// TUESDAY
DayOfWeek dow = date.getDayOfWeek(); 
// 31 (days in March)
int len = date.lengthOfMonth();
// false (not a leap year)
boolean leap = date.isLeapYear();
~~~

你还可以使用工厂方法从系统时钟中获取当前的日期：

~~~java
LocalDate today = LocalDate.now();
~~~

本章剩余的部分会探讨所有日期-时间类，这些类都提供了类似的工厂方法。你还可以通过传递一个TemporalField参数给get方法拿到同样的信息。TemporalField是一个接口，它定义了如何访问temporal对象某个字段的值。ChronoField枚举实现了这一接口，所以你可以很方便地使用get方法得到枚举元素的值，如下所示。

~~~java
int year = date.get(ChronoField.YEAR); 
int month = date.get(ChronoField.MONTH_OF_YEAR); 
int day = date.get(ChronoField.DAY_OF_MONTH);
~~~

类似地，一天中的时间，比如13:45:20，可以使用LocalTime类表示。你可以使用of重载的两个工厂方法创建LocalTime的实例。第一个重载函数接收小时和分钟，第二个重载函数同时还接收秒。同LocalDate一样，LocalTime类也提供了一些getter方法访问这些变量的值，如下所示。

~~~java
// 13:45:20
LocalTime time = LocalTime.of(13, 45, 20); 
// 13
int hour = time.getHour(); 
// 45
int minute = time.getMinute(); 
// 20
int second = time.getSecond();
~~~

LocalDate和LocalTime都可以通过解析代表它们的字符串创建。使用静态方法parse，你可以实现这一目的：

~~~java
LocalDate date = LocalDate.parse("2014-03-18"); 
LocalTime time = LocalTime.parse("13:45:20");
~~~

你可以向parse方法传递一个DateTimeFormatter。该类的实例定义了如何格式化一个日期或者时间对象。正如我们之前所介绍的，它是替换老版java.util.DateFormat的推荐替代品。我们会在12.2节展开介绍怎样使用DateTimeFormatter。同时，也请注意，一旦传递的字符串参数无法被解析为合法的LocalDate或LocalTime对象，这两个parse方法都会抛出一个继承自RuntimeException的DateTimeParseException异常。

### 12.1.2 合并日期和时间

这个复合类名叫LocalDateTime，是LocalDate和LocalTime的合体。它同时表示了日期和时间，但不带有时区信息，你可以直接创建，也可以通过合并日期和时间对象构造，如下所示。

~~~java
// 2014-03-18T13:45:20 
LocalDateTime dt1 = LocalDateTime.of(2014, Month.MARCH, 18, 13, 45, 20); 
LocalDateTime dt2 = LocalDateTime.of(date, time); 
LocalDateTime dt3 = date.atTime(13, 45, 20); 
LocalDateTime dt4 = date.atTime(time); 
LocalDateTime dt5 = time.atDate(date);
~~~

注意，通过它们各自的atTime或者atDate方法，向LocalDate传递一个时间对象，或者向LocalTime传递一个日期对象的方式，你可以创建一个LocalDateTime对象。你也可以使用toLocalDate或者toLocalTime方法，从LocalDateTime中提取LocalDate或者LocalTime组件：

~~~java
// 2014-03-18
LocalDate date1 = dt1.toLocalDate(); 
// 13:45:20
LocalTime time1 = dt1.toLocalTime();
~~~

### 12.1.3 机器的日期和时间格式

作为人，我们习惯于以星期几、几号、几点、几分这样的方式理解日期和时间。毫无疑问，这种方式对于计算机而言并不容易理解。从计算机的角度来看，建模时间最自然的格式是表示一个持续时间段上某个点的单一大整型数。这也是新的java.time.Instant类对时间建模的方式，基本上它是以Unix元年时间（传统的设定为UTC时区1970年1月1日午夜时分）开始所经历的秒数进行计算。

你可以通过向静态工厂方法ofEpochSecond传递一个代表秒数的值创建一个该类的实例。静态工厂方法ofEpochSecond还有一个增强的重载版本，它接收第二个以纳秒为单位的参数值，对传入作为秒数的参数进行调整。重载的版本会调整纳秒参数，确保保存的纳秒分片在0到999 999 999之间。这意味着下面这些对ofEpochSecond工厂方法的调用会返回几乎同样的Instant对象：

~~~java
Instant.ofEpochSecond(3);
Instant.ofEpochSecond(3, 0);
// 2秒之后再加上100万纳秒（1秒）
Instant.ofEpochSecond(2, 1_000_000_000); 
// 4秒之前的100万纳秒（1秒）
Instant.ofEpochSecond(4, -1_000_000_000);
~~~

正如你已经在LocalDate及其他为便于阅读而设计的日期时间类中所看到的那样，Instant类也支持静态工厂方法now，它能够帮你获取当前时刻的时间戳。我们想要特别强调一点，Instant的设计初衷是为了便于机器使用。它包含的是由秒及纳秒所构成的数字。所以，它无法处理那些我们非常容易理解的时间单位。比如下面这段语句：

~~~java
int day = Instant.now().get(ChronoField.DAY_OF_MONTH);
~~~

它会抛出下面这样的异常：

~~~
java.time.temporal.UnsupportedTemporalTypeException: Unsupported field: DayOfMonth
~~~

但是你可以通过Duration和Period类使用Instant，接下来我们会对这部分内容进行介绍。

### 12.1.4 定义Duration或Period

目前为止，你看到的所有类都实现了Temporal接口，Temporal接口定义了如何读取和操纵为时间建模的对象的值。之前的介绍中，我们已经了解了创建Temporal实例的几种方法。很自然地你会想到，我们需要创建两个Temporal对象之间的duration。Duration类的静态工厂方法between就是为这个目的而设计的。你可以创建两个LocalTimes对象、两个LocalDateTimes对象，或者两个Instant对象之间的duration，如下所示：

~~~java
Duration d1 = Duration.between(time1, time2); 
Duration d1 = Duration.between(dateTime1, dateTime2); 
Duration d2 = Duration.between(instant1, instant2);
~~~

由于LocalDateTime和Instant是为不同的目的而设计的，一个是为了便于人阅读使用，另一个是为了便于机器处理，所以你不能将二者混用。如果你试图在这两类对象之间创建duration，会触发一个DateTimeException异常。此外，由于Duration类主要用于以秒和纳秒衡量时间的长短，你不能仅向between方法传递一个LocalDate对象做参数。

如果你需要以年、月或者日的方式对多个时间单位建模，可以使用Period类。使用该类的工厂方法between，你可以使用得到两个LocalDate之间的时长，如下所示：

~~~java
Period tenDays = Period.between(LocalDate.of(2014, 3, 8), 
                                LocalDate.of(2014, 3, 18));
~~~

最后，Duration和Period类都提供了很多非常方便的工厂类，直接创建对应的实例；换句话说，就像下面这段代码那样，不再是只能以两个temporal对象的差值的方式来定义它们的对象。

~~~java
Duration threeMinutes = Duration.ofMinutes(3); 
Duration threeMinutes = Duration.of(3, ChronoUnit.MINUTES); 

Period tenDays = Period.ofDays(10); 
Period threeWeeks = Period.ofWeeks(3); 
Period twoYearsSixMonthsOneDay = Period.of(2, 6, 1);
~~~

Duration类和Period类共享了很多相似的方法，参见表12-1所示。

| 方法名        | 是否是静态方法 | 方法描述                                                 |
| ------------- | -------------- | -------------------------------------------------------- |
| between       | 是             | 创建两个时间点之间的interval                             |
| from          | 是             | 由一个临时时间点创建interval                             |
| of            | 是             | 由它的组成部分创建interval的实例                         |
| parse         | 是             | 由字符串创建interval的实例                               |
| addTo         | 否             | 创建该interval的副本，并将其叠加到某个指定的temporal对象 |
| get           | 否             | 读取该interval的状态                                     |
| isNegative    | 否             | 检查该interval是否为负值，不包含零                       |
| isZero        | 否             | 检查该interval的时长是否为零                             |
| minus         | 否             | 通过减去一定的时间创建该interval的副本                   |
| multipliedBy  | 否             | 将interval的值乘以某个标量创建该interval的副本           |
| negated       | 否             | 以忽略某个时长的方式创建该interval的副本                 |
| plus          | 否             | 以增加某个指定的时长的方式创建该interval的副本           |
| substractFrom | 否             | 从指定的temporal对象中减去该interval                     |

截至目前，我们介绍的这些日期-时间对象都是不可修改的，这是为了更好地支持函数式编程，确保线程安全，保持领域模式一致性而做出的重大设计决定。当然，新的日期和时间API也提供了一些便利的方法来创建这些对象的可变版本。比如，你可能希望在已有的LocalDate实例上增加3天。我们在下一节中会针对这一主题进行介绍。除此之外，我们还会介绍如何依据指定的模式，比如dd/MM/yyyy，创建日期-时间格式器，以及如何使用这种格式器解析和输出日期。

## 12.2 操纵、解析和格式化日期

如果你已经有一个LocalDate对象，想要创建它的一个修改版，最直接也最简单的方法是使用withAttribute方法。withAttribute方法会创建对象的一个副本，并按照需要修改它的属性。注意，下面的这段代码中所有的方法都返回一个修改了属性的对象。它们都不会修改原来的对象！

~~~java
// 2014-03-18
LocalDate date1 = LocalDate.of(2014, 3, 18); 
// 2011-03-18
LocalDate date2 = date1.withYear(2011); 
// 2011-03-25
LocalDate date3 = date2.withDayOfMonth(25); 
// 2011-09-25
LocalDate date4 = date3.with(ChronoField.MONTH_OF_YEAR, 9);
~~~

采用更通用的with方法能达到同样的目的，它接受的第一个参数是一个TemporalField对象，格式类似代码清单12-6的最后一行。最后这一行中使用的with方法和代码清单12-2中的get方法有些类似。它们都声明于Temporal接口，所有的日期和时间API类都实现这两个方法，它们定义了单点的时间，比如LocalDate、LocalTime、LocalDateTime以及Instant。更确切地说，使用get和with方法，我们可以将Temporal对象值的读取和修改区分开。如果Temporal对象不支持请求访问的字段，它会抛出一个UnsupportedTemporalTypeException异常，比如试图访问Instant对象的ChronoField.MONTH_OF_YEAR字段，或者LocalDate对象的ChronoField.NANO_OF_SECOND字段时都会抛出这样的异常。

它甚至能以声明的方式操纵LocalDate对象。比如，你可以像下面这段代码那样加上或者减去一段时间。

~~~java
// 2014-03-18
LocalDate date1 = LocalDate.of(2014, 3, 18); 
// 2014-03-25
LocalDate date2 = date1.plusWeeks(1); 
// 2011-03-25
LocalDate date3 = date2.minusYears(3); 
// 2011-09-25
LocalDate date4 = date3.plus(6, ChronoUnit.MONTHS);
~~~

与我们刚才介绍的get和with方法类似，代码清单12-7中最后一行使用的plus方法也是通用方法，它和minus方法都声明于Temporal接口中。通过这些方法，对TemporalUnit对象加上或者减去一个数字，我们能非常方便地将Temporal对象前溯或者回滚至某个时间段，通过ChronoUnit枚举我们可以非常方便地实现TemporalUnit接口。

大概你已经猜到，像LocalDate、LocalTime、LocalDateTime以及Instant这样表示时间点的日期-时间类提供了大量通用的方法，表12-2对这些通用的方法进行了总结。

| 方法名   | 是否是静态方法 | 描述                                                         |
| -------- | -------------- | ------------------------------------------------------------ |
| from     | 是             | 依据传入的Temporal对象创建对象实例                           |
| now      | 是             | 依据系统时钟创建Temporal对象                                 |
| of       | 是             | 由Temporal对象的某个部分创建该对象的实例                     |
| parse    | 是             | 由字符串创建Temporal对象的实例                               |
| atOffset | 否             | 将Temporal对象和某个时区偏移相结合                           |
| atZone   | 否             | 将Temporal对象和某个时区相结合                               |
| format   | 否             | 使用某个指定的格式器将Temporal对象转换为字符串（Instant类不提供该方法） |
| get      | 否             | 读取Temporal对象的某一部分的值                               |
| minus    | 否             | 创建Temporal对象的一个副本，通过将当前Temporal对象的值减去一定的时长创建该副本 |
| plus     | 否             | 创建Temporal对象的一个副本，通过将当前Temporal对象的值加上一定的时长创建该副本 |
| with     | 否             | 以该Temporal对象为模板，对某些状态进行修改创建该对象的副本   |

### 12.2.1 使用TemporalAdjuster

截至目前，你所看到的所有日期操作都是相对比较直接的。有的时候，你需要进行一些更加复杂的操作，比如，将日期调整到下个周日、下个工作日，或者是本月的最后一天。这时，你可以使用重载版本的with方法，向其传递一个提供了更多定制化选择的TemporalAdjuster对象，更加灵活地处理日期。对于最常见的用例，日期和时间API已经提供了大量预定义的TemporalAdjuster。你可以通过TemporalAdjuster类的静态工厂方法访问它们，如下所示。

~~~java
import static java.time.temporal.TemporalAdjusters.*; 

// 2014-03-18
LocalDate date1 = LocalDate.of(2014, 3, 18); 
// 2014-03-03
LocalDate date2 = date1.with(nextOrSame(DayOfWeek.SUNDAY)); 
// 2014-03-31
LocalDate date3 = date2.with(lastDayOfMonth());
~~~

表12-3提供了TemporalAdjuster中包含的工厂方法列表。

| 方法名                    | 描述                                                         |
| ------------------------- | ------------------------------------------------------------ |
| dayOfWeekInMonth          | 创建一个新的日期，它的值为同一个月中每一周的第几天           |
| firstDayOfMonth           | 创建一个新的日期，它的值为当月的第一天                       |
| firstDayOfNextMonth       | 创建一个新的日期，它的值为下月的第一天                       |
| firstDayOfNextYear        | 创建一个新的日期，它的值为明年的第一天                       |
| firstDayOfYear            | 创建一个新的日期，它的值为当年的第一天                       |
| firstInMonth              | 创建一个新的日期，它的值为同一个月中，第一个符合星期几要求的值 |
| lastDayOfMonth            | 创建一个新的日期，它的值为当月的最后一天                     |
| lastDayOfNextMonth        | 创建一个新的日期，它的值为下月的最后一天                     |
| lastDayOfNextYear         | 创建一个新的日期，它的值为明年的最后一天                     |
| lastDayOfYear             | 创建一个新的日期，它的值为今年的最后一天                     |
| lastInMonth               | 创建一个新的日期，它的值为同一个月中，最后一个符合星期几要求的值 |
| next/previous             | 创建一个新的日期，并将其值设定为日期调整后或者调整前，第一个符合指定星期几要求的日期 |
| nextOrSame/previousOrSame | 创建一个新的日期，并将其值设定为日期调整后或者调整前，第一个符合指定星期几要求的日期，如果该日期已经符合要求，直接返回该对象 |

正如我们看到的，使用TemporalAdjuster我们可以进行更加复杂的日期操作，而且这些方法的名称也非常直观，方法名基本就是问题陈述。此外，即使你没有找到符合你要求的预定义的TemporalAdjuster，创建你自己的TemporalAdjuster也并非难事。实际上，TemporalAdjuster接口只声明了单一的一个方法（这使得它成为了一个函数式接口），定义如下。

~~~java
@FunctionalInterface 
public interface TemporalAdjuster { 
    Temporal adjustInto(Temporal temporal); 
}
~~~

这意味着TemporalAdjuster接口的实现需要定义如何将一个Temporal对象转换为另一个Temporal对象。你可以把它看成一个`UnaryOperator<Temporal>`。花几分钟时间完成测验12.2，练习一下我们到目前为止所学习的东西，请实现你自己的TemporalAdjuster。

> **测验12.2 实现一个定制的TemporalAdjuster**
>
> 请设计一个NextWorkingDay类，该类实现了TemporalAdjuster接口，能够计算明天的日期，同时过滤掉周六和周日这些节假日。格式如下所示：
>
> ~~~java
> date = date.with(new NextWorkingDay());
> ~~~
>
> 如果当天的星期介于周一至周五之间，日期向后移动一天；如果当天是周六或者周日，则返回下一个周一。
>
> 答案：下面是参考的NextWorkingDay类的实现。
>
> ~~~java
> public class NextWorkingDay implements TemporalAdjuster { 
>     @Override 
>     public Temporal adjustInto(Temporal temporal) { 
>         // 读取当前日期
>         DayOfWeek dow = 
>             DayOfWeek.of(temporal.get(ChronoField.DAY_OF_WEEK));
>         // 正常情况，增加1天
>         int dayToAdd = 1;
>         // 如果当天是周五，增加3天
>         if (dow == DayOfWeek.FRIDAY) dayToAdd = 3; 
>         // 如果当天是周六，增加2天
>         else if (dow == DayOfWeek.SATURDAY) dayToAdd = 2;
>         // 增加恰当的天数后，返回修改的日期
>         return temporal.plus(dayToAdd, ChronoUnit.DAYS);
>     } 
> }
> ~~~
>
> 该TemporalAdjuster通常情况下将日期往后顺延一天，如果当天是周六或者周日，则依据情况分别将日期顺延3天或者2天。注意，由于TemporalAdjuster是一个函数式接口，你只能以Lambda表达式的方式向该adjuster接口传递行为：
>
> ~~~java
> date = date.with(temporal -> { 
>     DayOfWeek dow = 
>         DayOfWeek.of(temporal.get(ChronoField.DAY_OF_WEEK)); 
>     int dayToAdd = 1; 
>     if (dow == DayOfWeek.FRIDAY) dayToAdd = 3; 
>     else if (dow == DayOfWeek.SATURDAY) dayToAdd = 2; 
>     return temporal.plus(dayToAdd, ChronoUnit.DAYS); 
> });
> ~~~
>
> 你大概会希望在你代码的多个地方使用同样的方式去操作日期，为了达到这一目的，我们建议你像我们的示例那样将它的逻辑封装到一个类中。对于你经常使用的操作，都应该采用类似的方式，进行封装。最终，你会创建自己的类库，让你和你的团队能轻松地实现代码复用。
>
> 如果你想要使用Lambda表达式定义TemporalAdjuster对象，推荐使用TemporalAdjusters类的静态工厂方法ofDateAdjuster，它接受一个`UnaryOperator<LocalDate>`类型的参数，代码如下：
>
> ~~~java
> TemporalAdjuster nextWorkingDay = TemporalAdjusters.ofDateAdjuster( 
>     temporal -> { 
>         DayOfWeek dow = 
>             DayOfWeek.of(temporal.get(ChronoField.DAY_OF_WEEK)); 
>         int dayToAdd = 1; 
>         if (dow == DayOfWeek.FRIDAY) dayToAdd = 3; 
>         if (dow == DayOfWeek.SATURDAY) dayToAdd = 2; 
>         return temporal.plus(dayToAdd, ChronoUnit.DAYS); 
>     }); 
> date = date.with(nextWorkingDay);
> ~~~

你可能希望对你的日期时间对象进行的另外一个通用操作是，依据你的业务领域以不同的格式打印输出这些日期和时间对象。类似地，你可能也需要将那些格式的字符串转换为实际的日期对象。接下来的一节，我们会演示新的日期和时间API提供那些机制是如何完成这些任务的。

### 12.2.2 打印输出及解析日期-时间对象

处理日期和时间对象时，格式化以及解析日期时间对象是另一个非常重要的功能。新的java.time.format包就是特别为这个目的而设计的。这个包中，最重要的类是DateTimeFormatter。创建格式器最简单的方法是通过它的静态工厂方法以及常量。像BASIC_ISO_DATE 和 ISO_LOCAL_DATE 这样的常量是 DateTimeFormatter 类的预定义实例。所有的DateTimeFormatter实例都能用于以一定的格式创建代表特定日期或时间的字符串。比如，下面的这个例子中，我们使用了两个不同的格式器生成了字符串：

~~~java
LocalDate date = LocalDate.of(2014, 3, 18);
// 20140318
String s1 = date.format(DateTimeFormatter.BASIC_ISO_DATE); 
// 2014-03-18
String s2 = date.format(DateTimeFormatter.ISO_LOCAL_DATE);
~~~

你也可以通过解析代表日期或时间的字符串重新创建该日期对象。所有的日期和时间API都提供了表示时间点或者时间段的工厂方法，你可以使用工厂方法parse达到重创该日期对象的目的：

~~~java
LocalDate date1 = LocalDate.parse("20140318", DateTimeFormatter.BASIC_ISO_DATE); 
LocalDate date2 = LocalDate.parse("2014-03-18", DateTimeFormatter.ISO_LOCAL_DATE);
~~~

和老的java.util.DateFormat相比较，所有的DateTimeFormatter实例都是线程安全的。所以，你能够以单例模式创建格式器实例，就像DateTimeFormatter所定义的那些常量，并能在多个线程间共享这些实例。DateTimeFormatter类还支持一个静态工厂方法，它可以按照某个特定的模式创建格式器，代码清单如下。

~~~java
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
LocalDate date1 = LocalDate.of(2014, 3, 18); 
String formattedDate = date1.format(formatter); 
LocalDate date2 = LocalDate.parse(formattedDate, formatter);
~~~

这段代码中，LocalDate的formate方法使用指定的模式生成了一个代表该日期的字符串。紧接着，静态的parse方法使用同样的格式器解析了刚才生成的字符串，并重建了该日期对象。ofPattern方法也提供了一个重载的版本，使用它你可以创建某个Locale的格式器，代码清单如下所示。

~~~java
DateTimeFormatter italianFormatter = 
 DateTimeFormatter.ofPattern("d. MMMM yyyy", Locale.ITALIAN); 
LocalDate date1 = LocalDate.of(2014, 3, 18); 
String formattedDate = date.format(italianFormatter); // 18. marzo 2014 
LocalDate date2 = LocalDate.parse(formattedDate, italianFormatter);
~~~

最后，如果你还需要更加细粒度的控制，DateTimeFormatterBuilder类还提供了更复杂的格式器，你可以选择恰当的方法，一步一步地构造自己的格式器。另外，它还提供了非常强大的解析功能，比如区分大小写的解析、柔性解析（允许解析器使用启发式的机制去解析输入，不精确地匹配指定的模式）、填充，以及在格式器中指定可选节。比如，你可以通过 DateTimeFormatterBuilder自己编程实现我们在代码清单12-11中使用的italianFormatter，代码清单如下。

~~~java
DateTimeFormatter italianFormatter = new DateTimeFormatterBuilder() 
    .appendText(ChronoField.DAY_OF_MONTH) 
    .appendLiteral(". ") 
    .appendText(ChronoField.MONTH_OF_YEAR) 
    .appendLiteral(" ") 
    .appendText(ChronoField.YEAR) 
    .parseCaseInsensitive() 
    .toFormatter(Locale.ITALIAN);
~~~

目前为止，你已经学习了如何创建、操纵、格式化以及解析时间点和时间段，但是你还不了解如何处理日期和时间之间的微妙关系。比如，你可能需要处理不同的时区，或者由于不同的历法系统带来的差异。接下来的一节，我们会探究如何使用新的日期和时间API解决这些问题。

## 12.3 处理不同的时区和历法

之前你看到的日期和时间的种类都不包含时区信息。时区的处理是新版日期和时间API新增加的重要功能，使用新版日期和时间API时区的处理被极大地简化了。新的java.time.ZoneId 类是老版java.util.TimeZone的替代品。它的设计目标就是要让你无需为时区处理的复杂和繁琐而操心，比如处理日光时（Daylight Saving Time，DST）这种问题。跟其他日期和时间类一样，ZoneId类也是无法修改的。

时区是按照一定的规则将区域划分成的标准时间相同的区间。在ZoneRules这个类中包含了40个这样的实例。你可以简单地通过调用ZoneId的getRules()得到指定时区的规则。每个特定的ZoneId对象都由一个地区ID标识，比如：

~~~java
ZoneId romeZone = ZoneId.of("Europe/Rome");
~~~

地区ID都为“{区域}/{城市}”的格式，这些地区集合的设定都由英特网编号分配机构（IANA）的时区数据库提供。你可以通过Java 8的新方法toZoneId将一个老的时区对象转换为ZoneId：

~~~java
ZoneId zoneId = TimeZone.getDefault().toZoneId();
~~~

一旦得到一个ZoneId对象，你就可以将它与LocalDate、LocalDateTime或者是Instant对象整合起来，构造为一个ZonedDateTime实例，它代表了相对于指定时区的时间点，代码清单如下所示。

~~~java
LocalDate date = LocalDate.of(2014, Month.MARCH, 18); 
ZonedDateTime zdt1 = date.atStartOfDay(romeZone); 

LocalDateTime dateTime = LocalDateTime.of(2014, Month.MARCH, 18, 13, 45); 
ZonedDateTime zdt2 = dateTime.atZone(romeZone); 

Instant instant = Instant.now(); 
ZonedDateTime zdt3 = instant.atZone(romeZone);
~~~

通过ZoneId，你还可以将LocalDateTime转换为Instant：

~~~java
LocalDateTime dateTime = LocalDateTime.of(2014, Month.MARCH, 18, 13, 45); 
Instant instantFromDateTime = dateTime.toInstant(romeZone);
~~~

你也可以通过反向的方式得到LocalDateTime对象：

~~~java
Instant instant = Instant.now(); 
LocalDateTime timeFromInstant = LocalDateTime.ofInstant(instant, romeZone);
~~~

### 12.3.1 利用和UTC/格林尼治时间的固定偏差计算时区

另一种比较通用的表达时区的方式是利用当前时区和UTC/格林尼治的固定偏差。比如，基于这个理论，你可以说“纽约落后于伦敦5小时”。这种情况下，你可以使用ZoneOffset类，它是ZoneId的一个子类，表示的是当前时间和伦敦格林尼治子午线时间的差异：

~~~java
ZoneOffset newYorkOffset = ZoneOffset.of("-05:00");
~~~

“05:00”的偏差实际上对应的是美国东部标准时间。注意，使用这种方式定义的ZoneOffset并未考虑任何日光时的影响，所以在大多数情况下，不推荐使用。由于ZoneOffset也是ZoneId，所以你可以像代码清单12-13那样使用它。你甚至还可以创建这样的OffsetDateTime，它使用ISO-8601的历法系统，以相对于UTC/格林尼治时间的偏差方式表示日期时间。

~~~java
LocalDateTime dateTime = LocalDateTime.of(2014, Month.MARCH, 18, 13, 45); 
OffsetDateTime dateTimeInNewYork = OffsetDateTime.of(date, newYorkOffset);
~~~

新版的日期和时间API还提供了另一个高级特性，即对非ISO历法系统（non-ISO calendaring）的支持。

### 12.3.2 使用别的日历系统

ISO-8601日历系统是世界文明日历系统的事实标准。但是，Java 8中另外还提供了4种其他的日历系统。这些日历系统中的每一个都有一个对应的日志类，分别是ThaiBuddhistDate、MinguoDate 、 JapaneseDate 以 及 HijrahDate 。所有这些类以及 LocalDate 都实现了ChronoLocalDate接口，能够对公历的日期进行建模。利用LocalDate对象，你可以创建这些类的实例。更通用地说，使用它们提供的静态工厂方法，你可以创建任何一个Temporal对象的实例，如下所示：

~~~java
LocalDate date = LocalDate.of(2014, Month.MARCH, 18); 
JapaneseDate japaneseDate = JapaneseDate.from(date);
~~~

或者，你还可以为某个Locale显式地创建日历系统，接着创建该Locale对应的日期的实例。新的日期和时间API中，Chronology接口建模了一个日历系统，使用它的静态工厂方法ofLocale，可以得到它的一个实例，代码如下：

~~~java
Chronology japaneseChronology = Chronology.ofLocale(Locale.JAPAN); 
ChronoLocalDate now = japaneseChronology.dateNow();
~~~

日期及时间API的设计者建议我们使用LocalDate，尽量避免使用ChronoLocalDate，原因是开发者在他们的代码中可能会做一些假设，而这些假设在不同的日历系统中，有可能不成立。比如，有人可能会做这样的假设，即一个月天数不会超过31天，一年包括12个月，或者一年中包含的月份数目是固定的。由于这些原因，我们建议你尽量在你的应用中使用LocalDate，包括存储、操作、业务规则的解读；不过如果你需要将程序的输入或者输出本地化，这时你应该使用ChronoLocalDate类。

#### 伊斯兰教日历

在Java 8新添加的几种日历类型中，HijrahDate（伊斯兰教日历）是最复杂一个，因为它会发生各种变化。Hijrah日历系统构建于农历月份继承之上。Java 8提供了多种方法判断一个月份，比如新月，在世界的哪些地方可见，或者说它只能首先可见于沙特阿拉伯。withVariant方法可以用于选择期望的变化。为了支持HijrahDate这一标准，Java 8中还包括了乌姆库拉（Umm Al-Qura）变量。

下面这段代码作为一个例子说明了如何在ISO日历中计算当前伊斯兰年中斋月的起始和终止日期：

~~~java
// 取得当前的Hijrah日期，紧接着对其进行修正，得到斋月的第一天，即第9个月
HijrahDate ramadanDate = 
    HijrahDate.now().with(ChronoField.DAY_OF_MONTH, 1)
    				.with(ChronoField.MONTH_OF_YEAR, 9); 

System.out.println("Ramadan starts on " + 
                   // IsoChronology.INSTANCE是IsoChronology类的一个静态实例
                   IsoChronology.INSTANCE.date(ramadanDate) + 
                   " and ends on " + 
                   // 斋月始于2014-06-28，止于2014-07-27
                   IsoChronology.INSTANCE.date( 
                       ramadanDate.with( 
                           TemporalAdjusters.lastDayOfMonth())));
~~~

# 第四部分 超越Java8

# 第13章 函数式的思考



# 附录B 类库的更新

## B.2 并发

Java 8中引入了多个与并发相关的更新。首当其冲的当然是并行流，我们在第7章详细讨论过。另外一个就是第11章中介绍的CompletableFuture类。

除此之外，还有一些值得注意的更新。比如，Arrays类现在支持并发操作了。我们会在B.3节讨论这些内容。

这一节，我们想要围绕java.util.concurrent.atomic包的更新展开讨论。这个包的主要功能是处理原子变量（atomic variable）。除此之外，我们还会讨论ConcurrentHashMap类的更新，它现在又新增了几个方法。

### B.2.1 原子操作

java.util.concurrent.atomic包提供了多个对数字类型进行操作的类，比如AtomicInteger和AtomicLong，它们支持对单一变量的原子操作。这些类在Java 8中新增了更多的方法支持。

- getAndUpdate——以原子方式用给定的方法更新当前值，并返回变更之前的值。
- updateAndGet——以原子方式用给定的方法更新当前值，并返回变更之后的值。 
- getAndAccumulate——以原子方式用给定的方法对当前及给定的值进行更新，并返回变更之前的值。
- accumulateAndGet——以原子方式用给定的方法对当前及给定的值进行更新，并返回变更之后的值。

下面的例子向我们展示了如何以原子方式比较一个现存的原子整型值和一个给定的观测值（比如10），并将变量设定为二者中较小的一个。

~~~java
int min = atomicInteger.accumulateAndGet(10, Integer::min); 
~~~

#### Adder和Accumulator

多线程的环境中，如果多个线程需要频繁地进行更新操作，且很少有读取的动作（比如，在统计计算的上下文中），Java API文档中推荐大家使用新的类LongAdder、LongAccumulator、Double-Adder以及DoubleAccumulator，尽量避免使用它们对应的原子类型。这些新的类在设计之初就考虑了动态增长的需求，可以有效地减少线程间的竞争。

LongAddr和DoubleAdder类都支持加法操作，而LongAccumulator和DoubleAccumulator可以使用给定的方法整合多个值。比如，可以像下面这样使用LongAdder计算多个值的总和。

~~~java
// 使用默认构造器，初始的sum被置为0
LongAdder adder = new LongAdder();
// 在多个不同的线程中进行加法运算
adder.add(10); 
// ...
// 到某个时刻得出sum的值
long sum = adder.sum();
~~~

或者，你也可以像下面这样使用LongAccumulator实现同样的功能。

~~~java
// 在几个不同的线程中累计计算值
LongAccumulator acc = new LongAccumulator(Long::sum, 0); 
acc.accumulate(10); 
// ...
// 在某个时刻得出结果
long result = acc.get();
~~~

### B.2.2 ConcurrentHashMap

# 附录C 如何以并发方式在同一个流上执行多种操作