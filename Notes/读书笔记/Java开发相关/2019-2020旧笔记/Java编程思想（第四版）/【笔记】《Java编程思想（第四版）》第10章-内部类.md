# 第10章 内部类

可以将一个类定义放在另一个类的定义内部，这就是内部类。

在最初，内部类看起来就像是一种代码隐藏机制：将类置于其他类的内部。但是，你将会了解到，内部类远不止如此，它了解外围类，并能与之通信；而且你用内部类写出的代码更加优雅而清晰，尽管并不总是这样。

## 10.1 创建内部类

创建内部类的方式就如同你想的一样——把类的定义置于外围类的里面。

```java
//:innerclasses/Parcel1.java
//Creating inner classes.
```



当我们在ship()方法里面使用内部类的时候，与使用普通类没什么不同。在这里，实际区别只是内部类的名字是嵌套在Parcel1里面的。不过你将会看到，这并不是唯一的区别。

更典型的情况是，外部类将有一个方法，该方法返回一个指向内部类的引用，就像在to()和contents()方法中看到的那样：

```java
//:inerclasses/Parcel2.java
//Returning a reference to an inner class.
```

如果想从外部类的非静态方法之外的任意位置创建某个内部类的对象，那么必须想在main()方法中那样，具体地指明这个对象的类型：OuterClassName.InnerClassName.

## 10.2 链接到外部类

到目前为止，内部类似乎还只是一种名字隐藏和组织代码的模式。这些是很有用，但还不是最引人注目的，它还有其他的用途。当生成一个内部类的对象时，此对象与制造它的**外围对象（enclosing object）**之间就有了一种联系，所以它能访问其外围对象的所有成员，而不需要任何条件。此外，内部类还拥有其外围类的所有元素的访问权。（这与C++的嵌套类的设计非常不同，在C++中只是单纯的名字隐藏机制，与外围对象没有联系，也没有隐含的访问权。）

``` java
//:innerclasses/Sequence.java
// Holds a sequence of Objects.

```

Sequence类只是一个固定大小的Object的数组，以类的形式包装了起来。可以调用add()在序列末添加新的Object（只要还有空间）。要获取Sequence中的每一个对象，可以使用Selector接口。这是“迭代器”设计模式的一个例子，在本书稍后的部分将更多地学习它。Selector允许你检查序列是否到末尾了（end()）,访问当前对象（current()），以及移到序列中的下一对象（next()）。因为Selector是一个接口，所以别的类可以按自己的方式来实现这个接口，并且另的方法能以此接口为参数，来生成更加通用的代码。

这里，SequenceSelector是提供Selector功能的private类。可以看到，在main()中创建了一个Sequence，并向其中添加了一些String对象。然后通过调用selector()获取一个Selector，并用它在Sequence中移动和选择某一个元素。

最初看到SequenceSelector，可能会觉得它只不过是另一个内部类罢了。但仔细观察它，注意方法end()、current()和next()都用到了objects，这是一个引用，它并不是SequenceSelector的一部分，而是外围类中的一个private字段。然而内部类可以访问其外围类的方法和字段，就像自己拥有它们似的，这带来了很大的方便，就如前面的例子所示。

==所以内部类自动拥有对其外围类的所有成员的访问权。==这是如何做到的呢？当某个外围类的对象创建了一个内部类对象时，此内部类对象必定会秘密地捕获一个指向那个外围类对象的引用。然后，在你访问此外围类的成员时，就是用那个引用来选择外围类的成员。幸运的是，编译器会帮你处理所有的细节，但你现在看到：内部类的对象只能在与其外围类的对象相关联的情况下才能被创建（就像你应该看到的，在内部类是非static类时）。构建内部类对象时，需要一个指向其外围类对象的引用，如果编译器访问不到这个引用就会报错。不过绝大多数时候这都无需程序员操心。

## 10.3 使用.this与.new

如果你需要生成对外部类对象的引用，可以使用外部类的名字后面紧跟圆点和this。这样产生的引用自动地具有正确的类型。这一点在编译期就被知晓并收到检查，因此没有任何运行时开销。

有时你可能想要告知某些其他对象，去创建其某个内部类的对象。要实现此目的，你必须在new表达式中提供对其他外部类对象的引用，这时需要使用.new语法。

要想直接创建内部类的对象，你不能按照你想象的方式，去引用外部类的名字DotNew，而是必须使用外部类的对象来创建该内部类对象，就像在上面的程序中所看到的那样。这也解决了内部类名字作用域的问题，因此你不必声明（实际上你不能声明） dn.new.DotNew.Inner().

在拥有外部类对象之前不可能创建内部类对象的。这是因为内部类对象会暗暗地链接到它的外部类对象上。但是，如果你创建的是**嵌套类（静态内部类）**，那么它就不需要对外部类的引用。

## 10.4 内部类与向上转型

当将内部类向上转型为其基类，尤其是转型为一个接口的时候，内部类就有了用武之地。（从实现了某个接口的对象，得到对此接口的引用，与向上转型为这个对象的基类，实质上效果是一样的。）这是因为此内部类——某个接口的实现——能够完全不可见，并且不可用。所得到的只是指向基类或接口的引用，所以能够很方便地隐藏实现细节。

当取得了一个指向基类或接口的引用时，甚至可能无法找出它确切的类型，看下面的例子：

``` java
//: innerclasses/TestParcel.java
```

Parcel4中增加了一些新东西：内部类PContents是private，所以除了Parcel4，没有人能访问它。PDestination是protected，所以只有Parcel4及其子类，还有与Parcel4同一个包中的类（因为protected也给予了包访问权）能访问PDestination，其他类都不能访问PDestination。这意味着，如果客户端程序员想了解或访问这些成员，那是要受到限制的。实际上，甚至不能向下转型成private内部类（或protected内部类，除非是继承自它的子类），因为不能访问其名字，就像在TestParcel类中看到的那样。于是，private内部类给类的设计者提供了一种途径，通过这种方式可以完全阻止任何依赖于类型的编码，并且完全隐藏了实现的细节。此外，从客户端程序员的角度来看，由于不能访问任何新增加的、原本不属于公共接口的方法，所以扩展接口是没有价值的。这也给Java编译器提供了生成更高效代码的机会。

## 10.5 在方法和作用域内的内部类

可以在一个方法里面或者在任意的作用域内定义内部类。这么做有两个理由：

1. 如前所示，你实现某类型的接口，于是可以创建并返回对其的引用。
2. 你要解决一个复杂的问题，想创建一个类来辅助你的解决方案，但是又不希望这个类是公共可用的。

在后面的例子中，先前的代码将被修改，以用来实现：

1. 一个定义在方法中的类。
2. 一个定义在作用域内的类，此作用域在方法的内部。
3. 一个实现了接口的匿名类。
4. 一个匿名类，它拓展了有非默认构造器的类。
5. 一个匿名类，它执行字段初始化。
6. 一个匿名类，它通过实例初始化实现构造（匿名类不可能有构造器）。

第一个例子展示了在方法的作用域内（而不是在其他类的作用域内）创建一个完整的类，这被称作**局部内部类**：

```java
//:innerclasses/Parcel5.java
// Nesting a class within a method.
public class Parcel5{
    public Destination destination(String s){
        class PDestination implements Destination{
            private String label;
            public PDestination(String whereTo){
                label = whereTo;
            }
            public String readLabel(){
                return label;
            }
        }
        return new PDestination(s);
    }
    public static void main(String[] args){
        Parcel5 P =new Parcel5();
        Destination d=p.destination("Tasmania");
    }
}///:~
```

PDestination类是destination()方法的一部分，而不是Parcel5的 一部分。所以，在destination()之外不能访问PDestination。注意出现在return语句中的向上转型——返回的是Destination的引用，它是PDestination的基类。当然，在destination()中定义了内部类PDestination，并不意味着一旦dest()方法执行完毕，PDestination就不可用了。

你可以在同一个子目录下的任意类中对某个内部类使用类标识符PDestination，这并不会有命名冲突。

下面的例子展示了如何在任意的作用域内嵌入一个内部类：

``` java
//: innerclasses/Parcel6.java
//Nesting a class within a scope.
```

TrackingSlip类被嵌入在if语句的作用域内，这并不是说该类的创建是有条件的，它其实与别的类一起编译过了。然而，在定义TrackingSlip的作用域之外，它是不可用的；除此之外，它与普通类一样。

## 10.6 匿名内部类

下面的例子看起来有点奇怪

```java
//:innerclasses/Parcel7.java
// Returning an instance of an anonymous inner class.
public class Parcel7{
    public Contents contents(){
        return new Constents(){//Insert a class defination
            private int i = 11;
            public int value(){
                return i;
            }
        };//Semicolon required in this case
    }
    public static void main(String[] args){
        Parcel7 p = new Parcel7();
        Contents c = p.contents();
    }
}///:~
```

contents()方法将返回值的生成与表示这个返回值的类的定义结合在一起！另外，这个类是匿名的，它没有名字。更糟的是，看起来似乎是你正要创建一个Constents对象。但是然后（在到达语句结束的分号之前）你却说："等一等，我想在这里插入一个类的定义。"

这种奇怪的语法指的是：“创建一个继承自Constents的匿名类的对象。”通过new表达式返回的引用被自动向上转型为对Contents的引用。上述匿名内部类的语法是下述形式的简化形式：

```java
//:innerclasses/Parcel7b.java
// Expanded version of Parcel7.java
public class Parcel7b{
    class MyContents implements Contents{
        private int i=11;
        public int value(){return i;}
    }
    public Contents contents(){return new MyContents();}
    public static void main(String[] args){
        Parcel7b p =new Parcel7b();
        Contents c = p.contents();
    }
}///:~
```

在这个匿名内部类中，使用了默认的构造器来生成Contents。下面的代码展示的是，如果你的基类需要一个有参数的构造器，应该怎么办：

```java
//: innerclasses/Parcel8.java
// Calling the base-class constructor.
public class Parcel8{
    public Wrapping wrapping(int x){
        //Base constructor call;
        return new Wrapping(x){//Pass constuct arguments
            public int value(){
                return super.value()*47;
            }
        };//Semicolon required
    }
    public static void main(String[] args){
        Parcel8 p =new Parcel8();
        Wrapping w = p.wrapping(10);
    }
}///:~
```

只需简单地传递合适的参数给基类的构造器即可，这里是将x传进new Wrapping(x).尽管Wrapping只是一个具有具体实现的普通类，但它还是被其导出类当作公共“接口”来使用。

匿名内部类末尾的分号

在匿名类中定义字段时，还能够对其执行初始化操作。

如果定义一个匿名内部类，并且希望它使用一个其外部定义的对象，那么编译器会要求其参数引用是final的，就像你在destination()的参数中看到的那样。如果你忘记了，将会的得到一个编译时错误消息。

如果只是简单地给一个字段赋值，那么此例中的方法是很好的。但是，如果想做一些类似构造器的行为，该怎么办呢？在匿名内部类中不可能有命名构造器（因为它根本没名字！），但通过**实例初始化**，就能够达到为匿名内部类创建一个构造器的效果。就像这样：

```java
//: innerclasses/AnonymousConstructor.java
// Creating a constructor for an anonymous inner class.
import static net.mindView.util.Print.*;

abstract class Base{
    public Base(int i){
        print("Base constructor, i = " + i);
    }
    public abstract void f();
}
public class AnonymousConstructor{
    public static Base getBase(int i){
        return new Base(i){
            {print("Inside instance initializer");}
            public void f(){
                print("In anonymous f()");
            }
        };
    }
    public static void main(String[] args){
        Base base = getBase(47);
        base.f();
    }
}/* Output:
Base constructor, i = 47
Inside instance initializer
In anonymous f()
*///:~
```

在此例中，不要求变量i一定是final的。因为i被传递给匿名类的基类的构造器，它并不会在匿名类内部被直接使用。

下例是带实例初始化的"parcel"形式。注意destination()的参数必须是final的，因为它们是匿名类内部使用的。

``` java
//: innerclasses/Parcel10.java
// Using "instance initialization" to perform
// construction on an anonymous inner class.

```



在实例初始化操作的内部，可以看到有一段代码，它们不能作为字段初始化动作的一部分来执行（就是if语句）。所以对于匿名类而言，实例初始化的实际效果就是构造器。当然它受到了限制——你不能重载实例初始化方法，所以你仅有一个这样的构造器。

==匿名内部类与正规的继承相比有些受限，因为匿名内部类既可以扩展类，也可以实现接口，但是不能两者兼备。而且如果是实现接口，也只能实现一个接口。==

### 10.6.1 再访工厂方法

interfaces/Factories.java示例使用匿名内部类变得多么美妙

interfaces/Games.java示例也可以通过使用匿名内部类来改进。

请记住在第9章最后给出的建议：优先使用类而不是接口。如果你的设计中需要某个接口，你必须了解它。否则，不到迫不得已，不要将其放到你的设计中。

## 10.7 嵌套类

如果不需要内部类对象与其外围类对象之间有联系，那么可以将内部类声明为static。这通常称为**嵌套类**。（与C++嵌套类大致相似，只不过在C++中那些类不能访问私有成员，而在Java中可以访问）想要理解static应用于内部类时的含义，就必须记住，普通的内部类对象隐式地保存了一个引用，指向创建它的外围类对象。然而，当内部类是static的时，就不是这样了。嵌套类意味着：

1. 要创建嵌套类的对象，并不需要其外围类的对象。
2. 不能从嵌套类的对象中访问非静态的外围类对象。

嵌套类与普通的内部类还有一个区别。普通内部类的字段与方法，只能放在类的外部层次上，所以普通的内部类不能有static数据和static字段，也不能包含嵌套类。但是嵌套类可以包含所有这些东西。

嵌套类没有链接到其外围对象的特殊的this引用

### 10.7.1 接口内部的类

正常情况下，不能在接口内部放置任何代码，但嵌套类可以作为接口的一部分。你放到接口中的任何类都自动地是public和static的。因为类是static的，只是将嵌套类置于接口的命名空间内，这并不违反接口规则。你甚至可以在内部类中实现其外围接口。

如果你想要创建某些公共代码，使得它们可以被某个接口的所有不同实现所共用，那么使用接口内部的嵌套类会显得很方便。

我曾经在本书中建议过，在每个类中都写一个main()方法，用来测试这个类。==这样做有一个缺点，那就是必须带着那些已编译过的额外代码。如果这对你是个麻烦，那就可以使用嵌套类来放置测试代码==。

### 10.7.2 从多层嵌套类中访问外部类的成员

一个内部类被嵌套多少层并不重要——它能透明地访问所有它所嵌入的外围类的所有成员。

```java
//:innerclasses/MultiNestingAccess.java
//Nested classes can access all members of all
//levels of the classes they are nested within.
class MNA{
	private void f(){}
	class A{
		private void g(){}
		public class B{
			void h(){
				g();
				f();
			}
		}
	}
}
public class MultiNestingAccess {
	public static void main(String[] args) {
		MNA mna = new MNA();
		MNA.A mnaa = mna.new A();
		MNA.A.B mnaab = mnaa.new B();
		mnaab.h();
	}
}///:~
```

这个例子同时展示了如何从不同的类里创建多层嵌套的内部类对象的基本语法。“.new”语法能产生正确的作用域，所以不必在调用构造器时限定类名。

## 10.8 为什么需要内部类

使用内部类最吸引人的原因是：==每个内部类都能独立地继承自一个（接口的）实现，所以无论外围类是否已经继承了某个（接口的）实现，对于内部类都没有影响。==

如果没有内部类提供的、可以继承多个具体的或抽象的类的能力，一些设计与编程问题就很难解决。从这个角度看，内部类使得多重继承的解决方案变得完整。接口解决了部分问题，而内部类有效地实现了“多重继承”。也就是说，内部类允许继承多个非接口类型（译注：类或抽象类）。

如果拥有的是抽象的类或具体的类，而不是接口，那就只能使用内部类才能实现多重继承。

使用内部类，还可以获得其他的一些特性：

1. 内部类可以有多个实例，每个实例都有自己的状态信息，并且与其外围类对象的信息相互独立。
2. 在单个外围类中，可以让多个内部类以不同方式实现同一个接口，或继承同一个类。
3. 创建内部类对象的时刻并不依赖于外围类对象的创建。
4. 内部类并没有令人迷惑的“is-a”关系，它就是一个独立的实体。

### 10.8.1 闭包与回调

**闭包（closure）**是一个可调用的对象，它记录了一些信息，这些信息来自于创建它的作用域。通过这个定义，可以看出内部类是面向对象的闭包，因为它不仅包含外围类对象（创建内部类的作用域）的信息，还自动拥有一个指向此外围类对象的引用，在此作用域内，内部类有权操作所有的成员，包括private成员。

Java最引人争议的问题之一就是，人们认为Java应该包含某种类似指针的机制，以允许**回调（callback）**。通过回调，对象能够携带一些信息，这些信息允许它在稍后的某个时刻调用初始的对象。稍后将会看到这是一个非常有用的概念。如果回调是通过指针实现的，那么就只能寄希望于程序员不会误用该指针。然而回调是通过指针实现的，那么就只能寄希望于程序员不会误用该指针。然而，读者应该已经了解到，Java更小心仔细，所以没有在语言中包括指针。

通过内部类提供的闭包功能是优良的解决方案，它比指针更灵活，更安全。

### 10.8.2 内部类与控制框架

**控制框架（control framework）**

**应用程序框架（application framework）**就是被设计用以解决某些特定问题的一个类或一组类。要运用某个应用程序框架，通常是继承一个或多个类，并覆盖某些方法。在覆盖后的方法中，编写代码定制应用程序框架提供的通用解决方案，已解决你的特定问题。模块方法包含算法的基本结构，并且会调用一个或多个可覆盖的方法，以完成算法的动作。设计模式总是将变化的事物与保持不变的事物分离开，在这个模式中，模板方法是保持不变的事物，而可覆盖的方法就是变化的事物。

控制框架是一类特殊的应用程序框架，它用来解决响应时间的需求。主要用来响应时间的系统被称作**事件驱动系统**。应用程序设计中常见的问题之一是图形用户接口（GUI），它几乎完全是事件驱动的系统。

要理解内部类是如何允许简单的创建过程以及如何使用控制框架的，请考虑这样一个控制框架，它的工作就是在事件“就绪”的时候执行事件。虽然“就绪”可以指任何事，但在本例中是指基于时间触发的事件。接下来的问题就是，对于要控制什么，控制框架并不包含任何具体的信息。那些信息是在实现算法的action()部分时，通过继承来提供的。

首先，接口描述了要控制的时间。因为其默认的行为是基于时间去执行控制，所以使用抽象类代替实际的接口。

内部类允许：

1. 控制框架的完整实现是由单个的类创建的，从而使得实现的细节被封装了起来。内部类用来表示解决问题所必需的各种不同的action().
2. 内部类能够很容易地访问外围类的任意成员，所以可以避免这种实现变得笨拙。如果没有这种能力，代码将变得令人讨厌，以至于你肯定会选择其他方法。

## 10.9 内部类的继承

因为内部类的构造器必须连接到指向其外围类对象的引用，所以在继承内部类的时候，事情会变得有点复杂。问题在于，那个指向外围类对象的“秘密的”引用必须被初始化，而在导出类中不再存在可连接的默认对象。要解决这个问题，必须使用特殊的语法来明确说清它们之间的关联：

```java
//:innerclasses/InheritInner.java
//Inheriting an inner class.
class WithInner{
    class Inner {}
}
public class InheritInner extends WithInner, Inner{
    //! InheritInner(){}//Won't compile
    InheritInner(WithInner wi){
        wi.super();
    }
    public static void main(String[] args){
        WithInner wi = new WithInner();
        InheritInner ii = new InheritInner(wi);
    }
}
```

可以看到，InheritInner只继承自内部类，而不是外围类。但是当要生成一个构造器时，默认的构造器并不算好，而且不能只是传递一个指向外围类对象的引用。此外，必须在构造器内使用如下语法：

```java
enclosingClassReference.super();
```

这样才提供了必要的引用，然后程序才能编译通过。

## 10.10 内部类可以被覆盖吗

“覆盖”内部类就好像它是外围类的一个方法，其实并不起什么作用。

```java
//:innerclasses/BigEgg.java
//An inner class cannot be overriden like a method.
import static net.mindView.util.Print.*;
class Egg{
    private Yolk y;
    protected class Yolk {
        public Yolk(){print("Egg.Yolk()");}
    }
    public Egg(){
        print("New Egg()");
        y = new Yolk();
    }
}
public class BigEgg extends Egg{
    public class Yolk{
        public Yolk(){print("BigEgg.Yolk()");}
    }
    public static void main(String[] args){
        new BigEgg();
    }
}/* Output:
New Egg()
Egg.Yolk()
*///:~
```



默认的构造器是编译器自动生成的，这里是调用基类的默认构造器。你可能认为既然创建了BigEgg的对象，那么所使用的应该是“覆盖后”的Yolk版本，但从输出中可以看到实际情况并不是这样的。

这个例子说明，当继承了某个外围类的时候，内部类并没有发生什么特别神奇的变化。这两个内部类是完全独立的两个实体，各自在自己的命名空间内。当然，明确地继承某个内部类也是可以的：

```java
//:innerclasses/BigEgg2.java
// Proper inheirtance of an inner class.
```

## 10.11 局部内部类

前面提到过，可以在代码块里创建内部类，典型的方式是在一个方法体的里面创建。局部内部类不能有访问说明符，因为它不是外围类的一部分；但是它可以访问当前代码块内的常量，以及此外围类的所有成员。下面的例子对局部内部类与匿名内部类的创建进行了比较。

```java
//:innerclasses/LocalInnerClass.java
// Holds a sequence of Objects.
```

既然局部内部类的名字在方法外是不可见的，那为什么我们仍然使用局部内部类而不是匿名内部类呢？唯一的理由是，我们需要一个已命名的构造器，或者需要重载构造器，而匿名内部类只能用于实例初始化。

所以使用局部内部类而不使用匿名内部类的另一个理由就是，需要不止一个该内部类的对象。

## 10.12 内部类标识符

这些类文件的命名有严格的规则：外围类的名字，加上"\$"，再加上内部类的名字。

如果内部类是匿名的，编译器会简单地产生一个数字作为其标识符。如果内部类是嵌套在别的内部类之中，只需直接将它们的名字加在其外围类标识符与"\$"的后面。

