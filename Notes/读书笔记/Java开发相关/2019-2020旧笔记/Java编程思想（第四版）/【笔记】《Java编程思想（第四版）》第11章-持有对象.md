# 第11章 持有对象

如果一个程序只包含固定数量的且其生命期都是已知的对象，那么这时一个非常简单的程序。

List、Set、Queue和Map。这些对象类型也称为**集合类**。但由于Java的类库使用了Collection这个名字指代该类库的一个特殊自己，所以我使用了范围更广的术语**“容器”**称呼它们。

Set对于每个值只保存一个对象，Map是允许你将某些对象与其他一些对象关联起来的**关联数组**，Java容器类都可以自动地调整自己的尺寸。

## 11.1 泛型和类型安全的容器

Java SE 5之前的容器一个主要问题就是编译器允许你向容器中插入不正确的类型。	ArrayList：	add()插入对象	get()访问这些对象	size()，查看多少元素添加了进来

@SuppressWarnings注解及其参数（“unchecked”）表示只有有关“不受检查的异常”的警告信息应该被抑制

尖括号括起来的是**类型参数**（可以有多个），它指定了这个容器实例可以保存的类型。通过使用泛型，就可以在编译期防止将错误类型的对象放置到容器中。

向上转型也可以像作用于其他类型一样作用于泛型

## 11.2 基本概念

Java容器类类库的用途是“保存对象”，并将其划分为两个不同的概念：

1. Collection。 一个独立元素的序列，这些元素都服从一条或多条规则。List必须按照插入顺序保存元素，而Set不能有重复元素。Queue按照排队规则来确定对象产生的顺序（通常与它们被插入的顺序相同）。
2. Map。一组成对的“键值对”对象，允许你使用键来查找值。ArrayList允许你使用数字来查找值，因此某种意义上来讲，它将数字与对象关联在了一起。**映射表**允许我们使用另一个对象来查找某个对象，它也被称为**“关联数组”**；或者被称为**“字典”**，因为你可以使用键对象来查找值对象。Map是强大的编程工具。

Collection接口概括了**序列**的概念——一种存放一组对象的方式。

所有的Collection都可以用foreach遍历。

## 11.3 添加一组元素

Arrays.asList()方法接受一个数组或是一个逗号分隔的元素列表（使用可变参数），并将其转换为一个List对象。Collection==s==.addAll()方法接受一个Collection对象，以及一个数组或是一个用逗号分割的列表，将元素添加到Collection中。

Collection的构造器可以接受另一个Collection，用它来将自身初始化，因此你可以使用Array.List()来为这个构造器产生输入。==但是Collection.addAll()方法运行起来要快得多，而且构建一个不包含元素的Collection，然后调用Collections.addAll()这种方式很方便，所以它是首选方式==。

Collection.addAll()成员方法只能接受另一个Collection对象作为参数，因此它不如Array==s==.asList()或Collection==s==.addAll() 灵活，这两个方法使用的都是可变参数列表。

你也可以直接使用Arrays.asList()的输出，将其当做List，但是这种情况下，底层表示的是数组，因此不能调整尺寸。

**显式类型参数说明**

Map更加复杂，除了用另一个Map之外，Java标准类库没有提供其他任何自动初始化它们的方式。

## 11.4 容器的打印

Arrays.toString()来产生数组的可打印表示

Collection每个槽中只能保存一个元素。此类容器包括：List，Set，Queue。Map在每个槽内保存了两个对象，即键和与之相关联的值。

ArrayList和LinkedList都是List类型，不同之处不仅在于执行某些类型的操作时的性能，而且LinkedList包含的操作也多于ArrayList。

HashSet、TreeSet和LinkedHashSet都是Set类型，输出显示在Set中，每个相同的项只有保存一次，但是输出也显示了不同Set实现存储元素的方式也不同。	HashSet是最快的获取元素方式，因此，存储顺序看起来并无实际意义。如果存储顺序很重要，那么可以使用TreeSet，它按照比较结果的升序保存对象；或者使用LinkedHashSet，它按照被添加的顺序保存对象。

Map（也被称为关联数组）使得你可以用键来查找对象，就像一个简单的数据库。键所关联的对象称为值。

Map.put(key, value)方法将增加一个值（你想要增加的对象），并将它与某个键（你用来查找这个值的对象）关联起来。Map.get(key)方法将产生与这个键相关联的值。上面的示例只添加了键-值对，并没有执行查找。

键和值在Map中保存顺序并不是它们的插入顺序，因为HashMap实现使用的是一种非常快的算法来控制顺序。

本例使用了三种基本风格的Map：HashMap、TreeMap和LinkedHashMap。与HashSet一样，HashMap也提供了最快的查找技术，也没有按照任何明显的顺序来保存其元素。TreeMap按照比较结果的升序保存键，而LinkedHashMap则按照插入顺序保存键，同时还保留了HashMap的查询速度。

## 11.5 List

List承诺可以将元素维护在特定的序列中。List接口在Collection的基础上添加了大量方法，使得可以在List的中间插入和移除元素。

有两种类型的List：

- 基本的ArrayList，它长于随机访问元素，但是在List的中间插入和移除元素时较慢。
- LinkedList， 它通过代价较低的在List中间进行的插入和删除操作，提供了优化的顺序访问。LinkedList在随机访问方面相对比较慢，但是它的特性集较ArrayList更大。

contains()方法来确定某个对象是否在列表中。如果你想移除一个对象，则可以将这个对象的引用传递给remove()方法。同样，如果你有一个对象的引用，则可以使用IndexOf()来发现该对象在List中所处位置的索引编号。

当确定一个元素是否属于某个List，发现某个元素的索引，以及从某个List中移除一个元素时，都会用到equals()方法（它是根类Object的一部分）。==因此为了防止以外，就必须意识到List的行为根据equals()的行为而有所变化==

subList()方法允许你很容易地从较大的列表中创建出一个片断，而将其结果传递给这个较大的列表的containsAll()方法时，很自然地会得到true。还有一点也很有趣，那就是我们注意到顺序并不重要，在sub上调用名字很直观的Collections.sort()和Collections.shuffle()方法，不会影响containsAll()的结果。==subList()所产生的的列表的幕后就是初始列表，因此，对返回的列表的修改都会反映到初始列表中，反之亦然==。（***笔记注解***：这里会有一点歧义，或者说逻辑上的小bug——因为修改subList()赋值的sub会改变原List，所以感觉这个例子就不能说明顺序不重要了，虽然经过测试其实顺序的确不重要……）

retainAll()方法是一种有效的“交集”操作，它保留两个List中同时存在的元素。请再次注意，所产生的行为依赖于equals()方法。

remove()可以使用索引值来移除元素。不必担心equals()的行为。

removeAll()方法的行为也是基于equals()方法的。它将从List中移除在List中的所有元素。

set()方法的命名显得很不合时宜，因为它与Set类存在潜在冲突。它的功能是在指定索引处（第一个参数），用第二个参数替换那个位置的元素。

对于List，有一个重载的addAll()方法使得我们可以在初始List的中间插入新的列表，而不仅仅只能用Collection中的addAll()方法将其追加到表尾。

isEmpty()和clear()方法

toArray()方法，将任意的Collection转换为一个数组。这是一个重载方法，其无参数版本返回的是Object数组，但是如果你向这个重载版本传递目标类型的数据，那么它将产生指定类型的数据（假设它能通过类型检查）。如果参数数组太小，存放不下List的所有元素，toArray()方法将创建一个具有合适尺寸的数组。

## 11.6 迭代器

任何容器类，都必须有某种方式可以插入元素并将它们再次取回。对于List，add()是插入元素的方法之一，而get()是取出元素的方法之一。

**迭代器**（也是一种设计模式）的概念可以用于达成此目的。迭代器是一个对象，它的工作是遍历并选择序列中的对象，而客户端程序员不必知道或关心该序列底层的结构。此外，迭代器通常被称为**轻量级对象**：创建它的代价小。因此，经常可以见到对迭代器有些奇怪的限制，例如，Java的Iterator只能单向移动，这个Iterator只能用来：

1. 使用方法Iterator()要求容器返回一个Iterator。Iterator将准备好返回序列的第一个元素。
2. 使用next()获得序列中的下一个元素。
3. 使用hasNext()检查序列中是否还有元素。
4. 使用remove()将迭代器新近返回的元素删除。

有了Iterator就不必为容器中元素的数量操心了，那是由hasNext()和next()关心的事情。

如果你只是向前遍历List，不打算修改List对象本身，那么foreach会显得更加简介。

Iterator还可以移除由next()产生的最后一个元素，这意味着在调用remove()之前必须先调用next()。

（remove()是所谓的“可选”方法（还有一些其他的这种方法），即不是所有的Iterator实现都必须实现该方法。这个问题将在第17章中介绍。但是，标准java类库实现了remove()，因此直至17章前，你都不用担心这个问题。）

==Iterator的真正威力：能够将遍历序列的操作与序列底层的结构分离。==正由于此，我们有时会说：迭代器统一了对容器的访问方式。

### 11.6.1 ListIterator

ListIterator是一个更加强大的Iterator的子类型，它只能用于各种List类的访问。尽管Iterator只能向前移动，但是ListIterator可以双向移动。（***笔记注解***：使用hasPrevious()、previous()）

它还可以产生相对于迭代器在列表中指向的当前位置的前一个和后一个元素的索引，并且可以使用set()方法替换它访问过的最后一个元素。你可以通过调用listIterator()方法产生一个指向List开始处的ListIterator，并且还可以通过调用listIterator(n)方法创建一个一开始就指向列表索引为n的元素处的ListIterator。

## 11.7 LinkedList

LinkedList也像ArrayList一样实现了基本的List接口，但是它执行某些操作（在List的中间插入和移除）时比ArrayList更高效，但在随机访问操作方面却要逊色一些。

LinkedList还添加了可以使其用作栈、队列或双端队列的方法。

这些方法中有些彼此之间只是名称有所差异，或者只存在些许差异，以使得这些名字在特定用法的上下文环境中更加适用（特别是在Queue中）。例如，getFirst()和element()完全一样，都返回列表的头（第一个元素），而并不移除它，如果List为空，则抛出NoSuchElementException，peek()方法与这两个方法只是稍有差异，在列表为空时返回null。

removeFirst()与remove()也是完全一样的，它们移除并返回列表的头，而在列表为空时抛出NoSuchElementException，poll()稍有差异，它在列表为空时返回null。

addFirst()与add()和addLast()相同，它们都将某个元素插入到列表的尾（端）部。

removeLast()移除并返回列表的最后一个元素。

如果你浏览一下Queue接口就会发现，它在LinkedList的基础上添加了element(), offer(), peek(), poll()和remove()方法，以使其可以成为一个Queue实现。

## 11.8 Stack

栈通常是指“后进先出”（LIFO）的容器。有时栈也被称为叠加栈，因为最后压入栈的元素，第一个弹出栈。

LinkedList具有能够直接实现栈的所有功能的方法，因此可以直接将LinkedList作为栈使用。不过，有时一个真正的“栈”更能把事情讲清楚：

```java
//:net/mindview/util/Stack.java
//Making a stack from a LinkedList.
package net.mindview.util;
import java.util.LinkedList;

public class Stack<T>{
    private LinkedList<T> storage = new LinkedList<T>();
    public void push(T v){storage.addFirst(v);}
    public T peek(){return storage.getFirst();}
    public T pop(){return storage.removeFirst();}
    public boolean empty(){return storage.isEmpty();}
    public String toString(){return storage.toString();}
}///:~
```

这里通过使用泛型，引入了在栈的类定义中最简单的可行示例。peek()方法提供栈顶元素，但不是将其从栈顶移除，而pop()将移除并返回栈顶元素。

如果你只需要栈的行为，这里使用继承就不合适了，因为这样会产生具有LinkedList的其他所有方法的类（就像你将在第17章看到的，Java 1.0的设计者在创建java.util.Stack时，就犯了这个错误）。

## 11.9 Set

Set不保存重复的元素(至于如何判断元素相同则较为复杂，稍后便会看到)。如果你试图将相同对象的多个实例添加到Set中，那么它就会阻止这种重复现象。Set最长被使用的是测试归属性，你可以很容易地询问某个对象是否在某个Set中。因此你通常会选择一个HashSet的实现，它专门对快速查找进行了优化。

Set具有Collection完全一样的接口，因此没有任何额外的功能，不像前面有两个不同的List。实际上Set就是Collection，只是行为不同。（这是继承与多态思想的典型应用：表现不同的行为）Set是基于对象的值来确定归属性的，而更加复杂的问题我们将在第17章中介绍。

HashSet使用了散列，HashSet所维护的顺序与TreeSet或LinkedHashSet都不同，因为它们的实现具有不同的元素存储方式。TreeSet将元素存储在红黑树数据结构中，而HashSet使用的是散列函数。LinkedHashSet（***笔记注解：***这里原文貌似有误，写的是LinkedHashList）因为查询速度的原因也使用了散列，但是看起来它使用了链表来维护元素的插入顺序。

如果你想对结果排序，一种方式是使用TreeSet代替HashSet。

contains()测试Set的归属性

## 11.10 Map

将对象映射到其他对象的能力是一种解决编程问题的杀手锏。

自动包装机制可以将int转换为HashMap可以使用的Integer引用（不能使用基本类型的容器）。如果键不再容器中，get()方法将返回null（这表示该数字第一次被找到）。否则，get()方法将产生与该键相关联的Integer值。

containsKey()和containsValue()测试一个Map，以便查看它是否包含某个键或某个值。

Map与数组和其他Collection一样可以很容易扩展到多维，而我们只需将其值设置为Map（这些Map的值可以是其他容器，甚至是其他Map）。

Map可以返回它的键的Set，它的值的Collection，或者它的键值对的Set。keySet()方法产生了由在petPeople中的所有键组成的Set，它在foreach语句中被用来迭代遍历该Map。

## 11.11 Queue

队列是一个典型的先进先出（FIFO）的容器。队列在并发编程中特别重要，就像你将在21章中所看到的，因为它们可以安全地将对象从一个任务传输给另一个任务。

LinkedList提供了方法以支持队列的行为，并且它实现了Queue接口，因此LinkedList可以用做Queue的一种实现。通过将LinkedList向上转型为Queue。

offer()方法是与Queue相关方法之一，它在允许的情况下，将一个元素插入到队尾，或者返回false，peek()和element()都将在不移除的情况下返回队头，但是peek()方法在队列为空时返回null，而element()会抛出NoSuchElementException异常。poll()和remove()方法将移除并返回队头，但是poll()在队列为空时返回null,而remove()会抛出NoSuchElementException异常。

自动包装机制会自动地将nextInt()方法的int结果转换为queue所需的Integer对象，将char c转换为qc所需的Character对象，Queue接口窄化了对LinkedList的方法的访问权限，以使得只有恰当的方法才可以使用，因此，你能够访问的LinkedList方法会变少（这里你实际上可以将queue转型回LinkedList，但是至少我们不鼓励这么做）。

注意，与Queue相关的方法提供了完整而独立的功能。即，对于Queue所继承的Collection，在不需要使用它的任何方法的情况下，就可以拥有一个可用的Queue。

### 11.11.1 PriorityQueue

先进先出描述了最典型的队列规则。队列规则是指在给定一组队列中的元素的情况下，确定下一个弹出队列的元素的规则。先进先出声明的是下一个元素应该是等待时间最长的元素、

优先级队列声明下一个弹出元素是最需要的元素（具有最高优先级）

offer()	Comparator	peek()	poll()	remove()

## 11.12 Collection和Iterator

Java中，遵循C++的方式看起来似乎很明智，即用迭代器而不是Collection来表示容器之间的共性。但是两种方法绑定到了一起，因为实现Collection就意味着需要提供Iterator()方法。

生成Iterator是将队列与消费队列的方法链接在一起耦合度最小的方式，并且与实现Collection相比，它在序列类上所施加的约束也少得多。

## 11.13 Foreach与迭代器

foreach语法主要用于数组，但是它也可以应用于任何Collection对象的特性。

称为Iterable的接口

System.getenv()返回一个Map，entrySet()产生一个由Map.Entry的元素构成的Set，并且这个Set是一个Iterable，因此它可以用于foreach循环。

不存在任何从数组到Iterable的自动转换

### 11.13.1 适配器方法惯用法

“适配器”部分来自于设计模式，因为你必须提供特定接口以满足foreach语句。