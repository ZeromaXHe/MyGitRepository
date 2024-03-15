# 第6章 接口与内部类

**接口（interface）**技术，这种技术主要用来描述类具有什么功能，而并不给出每个功能的具体实现。一个类可以实现（implement）一个或多个接口。克隆对象（有时称为深拷贝）。对象的克隆是指创建一个新对象，且新对象的状态与原始对象的状态相同。当对克隆的新对象进行修改时，不会影响原始对象的状态。

**内部类（inner class）**

**代理（proxy）**，这是一种是实现任意接口的对象。

## 6.1 接口

接口不是类，而是对类的一组需求描述。

Comparable接口 包含compareTo方法

*注释：在Java SE 5.0中，Comparable接口已经改进为泛型类型。*

接口中的所有方法自动地属于public。

接口决不能含有实例域，也不能在接口中实现方法。

为了让类实现一个接口，通常需要下面两个步骤：

1）将类声明为实现给定的接口

2）对接口中的所有方法进行定义。

关键字implements

*警告：在实现接口时，必须把方法声明为public;否则编译器将认为这个方法的访问属性是包可见性，即类的默认访问属性，之后编译器就会给出试图提供更弱的访问权限的警告信息。*

*提示：Comparable接口中的compareTo方法将返回一个整型数值*

Java是**强类型（strong typed）**语言。在调用方法时候，编译器会检查这个方法是否存在。

*注释：有人认为，将Arrays类中的sort方法定义为接受一个Comparable[]数组就可以在使用元素类型没有实现Comparable接口的数组作为参数调用sort方法时，由编译器给出错误报告。但事实并非如此。在这种情况下，sort方法可以接受一个Object[]数组，并对其进行笨拙的类型转换：*

```java
//Approach used in the standard library--not recommended
if(((Comparable)a[i]).compareTo(a[j])>0){
    //rearrange a[i] and a[j]
    ...
}
```

*如果a[i]不属于实现了Comparable接口的类，那么虚拟机就会抛出一个异常。*

【API】java.lang.Comparable\<T> 1.0 :

- int compareTo(T other)

【API】java.util.Arrays 1.2 :

- static void sort(Object[] a)

【API】java.lang.Integer 7 :

- static int compare(int x, int y)

*注释：语言标准规定：对于任意的x和y，实现必须能够保证sgn(x.compareTo(y))=-sgn(y.compareTo(x))。*

### 6.1.1 接口的特性

接口不是类，不能使用new实例化一个接口

能声明接口的变量。接口变量必须引用实现了接口的类对象。

也可以instanceof 检查一个对象是否实现了某个特定的接口

接口也可以被扩展。

虽然接口中不能包含实例域或静态方法，但却可以包含常量。

接口中的域将被自动设为public static final

*注释：可以将接口方法标记为public，域标记为public static final。有些程序员出于习惯或提高清晰度的考虑，愿意这样做。但Java语言规范却建议不要书写这些多余的关键字。*

有些接口只定义了常量而没有定义方法。例如，在标准库中有一个SwingConstants就是这样一个接口，其中只包含NORTH、SOUTH和HORIZONTAL等常量。实现了该接口的类自动地继承了这些常量，并可以在方法中直接引用NORTH，并不必采用SwingConstants.NORTH这样的繁琐书写形式。然而，这样的应用接口似乎有点偏离了接口概念的初衷，最好不要这样使用它。

每个只能拥有一个超类，却可以实现多个接口。

Cloneable接口

使用逗号将实现的各个接口分隔开。

### 6.1.2  接口与抽象类

抽象类表示通用属性存在这样一个问题：每个类只能扩展于一个类。

但每个类可以实现多个接口。

有些语言允许一个类有多个超类，例如C++。我们将此特性称为**多继承（multiple inheritance）**。Java的设计者选择了不支持多继承，主要原因多继承会让语言变得非常复杂（如同C++），效率也会降低（如同Eiffel）。

接口可以提供多重继承的大多数好处，同时还能避免多重继承的复杂性和低效性。

*C++注释：C++具有多继承，随之带来了诸如虚基类、控制规则和横向指针类型转换等复杂特性。C++中，“混合”类可以添加默认的行为，而Java接口不行。*

## 6.2 对象克隆

当拷贝一个变量时，原始变量与拷贝变量引用同一个对象。

对象包含了子对象的引用，拷贝的结果会使得两个域引用统一子对象。

默认的克隆操作是**浅拷贝**，它并没有克隆包含在对象中的内部对象。

常见的情况是子对象可变，因此必须重新定义clone方法，以便实现克隆子对象的**深拷贝**。

对于每一个类，都需要做出下列判断：

1. 默认的clone方法是否满足要求。
2. 默认的clone方法是否能够通过调用可变子对象的clone得到修补。
3. 是否不应该使用clone。

实际上，选项3是默认的。如果要选择1或2，类必须：

1. 实现Cloneable接口。
2. 使用public访问修饰符重新定义clone方法。

*注释：在Object类中，clone方法被声明为protected，因此无法直接调用anObject.clone()。为此必须重新定义clone方法，并将它声明为public，这样才能够让所有的方法克隆对象。*

Cloneable接口的出现与接口的正常使用没有任何关系。尤其是，他并没有指定clone方法，这个方法是从Object类继承而来的。接口在这里只是作为一个标记

*注释：Cloneable接口是Java提供的几个标记接口（tagging interface）之一（有些程序员称为marker interface）。使用它的唯一目的是可以用instanceof进行类型检查。建议在自己编写程序时不要使用这种技术。*

即使clone的默认实现能满足需求，也应该实现Cloneable接口，将clone重定义为public，并调用super.clone()

*注释：在Java SE 5.0 以前的版本中，clone方法总是返回Object类型，而现在协变返回类型允许克隆方法指定正确的返回类型。*

CloneNotSupportException异常

标准类库中，只有不到5%的类实现了clone

*注释：所有的数组类型都包含一个clone方法，这个方法被设为public，而不是protected。*

*注释：将在卷II第1章中介绍另一种克隆对象的机制，其中使用了Java的序列化功能。这种机制很容易实现并且也很安全，但效率较低。*

## 6.3 接口与回调

**回调（callback）**，可以指出某个特定事件发生时应该采取的动作。

java.swing包中有一个Timer类，可以使用它在到达给定的时间间隔时发出通告。

定时器需要知道调用哪一个方法，并要求传递的对象所属的类实现了java.awt.event包的ActionListener接口。

当到达指定的时间间隔时，定时器就调用actionPerformed方法。

*C++注释：在任何使用C++函数指针的地方，都应该考虑使用Java中的接口。*

程序清单6-5，这个程序除了导入javax.swing.\*和java.util.\*外，还通过类名导入了javax.swing.Timer。这就消除了javax.swing.Timer与java.util.Timer之间产生的二义性。这里的java.util.Timer是一个与本例无关的类，它主要用于调度后台任务。

【API】javax.swing.JOptionPane 1.2 :

- `static void showMessageDialog(Component parent, Object message)`

【API】javax.swing.Timer 1.2 :

- `Timer(int interval, ActionListener listener)`
- `void start()`
- `void stop()`

【API】java.awt.Toolkit 1.0 :

- `static Toolkit getDefaultToolkit()`
- `void beep()`

## 6.4 内部类

**内部类（inner class）**是定义在另一个类中的类。为什么需要使用内部类呢？主要原因有以下三点：

- 内部类方法可以访问该类定义所在的作用域中的数据，包括私有的数据。
- 内部类可以对同一个包中的其他类隐藏起来。
- 当想要定义一个回调函数且不想编写大量代码时，使用**匿名（anonymous）**内部类比较便捷。

*C++注释“”：C++有嵌套类。一个被嵌套的类包含在外围类的作用域内。嵌套是一种类之间的关系，而不是对象间的关系。嵌套类有两个好处：命名控制和访问控制。Java内部类还有一个功能，这使得它比C++嵌套类更加丰富，用途更加广泛。内部类的对象有一个隐式引用，它引用了实例化该内部对象的外围类对象。在Java中，static内部类没有这种附加指针，这样的内部类与C++的嵌套类很相似。*

### 6.4.1 使用内部类访问对象状态

内部类既可以访问自身的数据域，也可以访问创建它的外围类的对象的数据域。

为了能够运行这个程序，内部类的对象总有一个隐式引用，它指向创建它的外部类对象。这个引用在内部类的定义中是不可见的。

*注释：只有内部类可以是私有类，而常规类只可以具有包可见性，或公有可见性。*

### 6.4.2 内部类的特殊语法规则

事实上，使用外围类引用的正规语法还要复杂一些。表达式：`OuterClass.this`表示OuterClass引用。

```java
public void actionPerformed(ActionEvent event){
    ...
    if(TalkingClock.this.beep) Toolkit.getDefaultToolkit().beep();
}
```



反过来，可以采用下列语法格式更加明确地编写内部对象的构造器：`outerObject.new InnerClass(construction parameters)`例如，

```java
ActionListener listener = this.new TimePrinter();
```

需要注意，在外围类的作用域外，可以这样引用内部类：`OuterClass.InnerClass`

### 6.4.3 内部类是否有用、必要和安全

内部类的语法很复杂。它与访问控制和安全性等其他的语言特性的没有明显的关联。

内部类是一种编译器现象，与虚拟机无关。编译器将会把内部类翻译成用\$（美元符号）分割外部类名与内部类名的常规类文件，而虚拟机对此一无所知。

javap -private ClassName

*注释：如果使用UNIX，并以命令行的方式提供类名，就需要记住将$字符进行转义。*

内部类拥有访问特权，所以比常规类比较起来更加强大。内部类管理那些额外访问特权的方法是：编译器在外围类添加静态方法access\$0。它将返回作为参数传递给它的对象域beep（方法名可能稍有不同，如access\$000，取决于你的编译器。）

内部类方法将调用那个方法。这样做存在安全风险，任何人都可以通过调用access\$0方法很容易地读取到私有域beep。当然，access\$0不是Java的合法方法名。但熟悉类文件结构的黑客可以使用十六进制编辑器轻松地创建一个用虚拟机指令调用那个方法的类文件。由于隐秘地访问方法需要拥有包可见性，所以攻击代码需要与被攻击类放在同一个包中。

总而言之，如果内部类访问了私有数据域，就有可能通过附加在外围类所在包中的其他类访问它们，但做这些事情需要高超的技巧和极大的决心。

*注释：合成构造器和方法是复杂令人费解的。*

### 6.4.4 局部内部类

类名字是在方法中创建这个类型的对象时使用了一次，当遇到这类情况时，可以在一个方法中定义局部类。

```java
public void start(){
    class TimePrinter implements ActionListener{
        public void actionPerformed(ActionEvent event){
            Date now = new Date();
            System.out.println("At the tone, the time is "+now);
            if(beep) Toolkit.getDefaultToolkit().beep();
        }
    }
    ActionListener Listener = new timePrinter();
    Timer t = new Timer(interval, listener);
    t.start();
}
```



局部类不能用public或private访问说明符进行声明。它的作用域被限定在这个局部类的块中。

局部类有一个优势，即对外部世界可以完全地隐藏起来。即使TalkingClock类中的其他代码也不能访问它。除start方法之外，没有任何方法知道TimePrinter类的存在。

### 6.4.5 由外部方法访问final变量

局部类不仅能够访问包含它们的外部类，还可以访问局部变量。不过那些局部变量必须被声明为final。

当创建一个对象的时候，编译器必须检测对局部变量的访问，为每一个变量建立相应的数据域，并将局部变量拷贝到构造器中，以便将这些数据域初始化为局部变量的副本。

从程序员的角度看，局部变量的访问非常容易。它减少了需要显式编写的实例域，从而使得内部类更加简单。

参数声明为final，对它进行初始化后不能够再进行修改。因此就使得局部变量与在局部类内建立的拷贝保持一致。

*注释：final关键字可以应用于局部变量、实例变量和静态变量。在所有这些情况下，它们的含义都是：在创建这个变量后，只能够为之赋值一次。此后，再也不能修改它的值了，这就是final。*

*定义final变量时，不必进行初始化。定义时没有初始化的final变量通常被称为空final（blank final）变量*

有时final限制显得并不太方便。==补救的方法是使用一个长度为一的数组。（数组变量仍然被声明为final，但是这仅仅表示不可以让它引用另外一个数组。数组中的数据元素可以自由地更改。）==

### 6.4.6 匿名内部类

将局部内部类的使用再深入一步。假如只创建这个类的一个对象，就不必命名了。这种类被称为**匿名内部类（anonymous inner class）**

它的含义是：创建一个实现ActionListener接口的类的新对象，需要实现的方法actionPerformed定义在括号｛｝内。

通常的语法格式为：

```java
new SuperType(construction parameters){
    innerclass methods and data
}
```

其中SuperType可以是ActionListener这样的接口，于是内部类就要实现这个接口。SuperType也可以是一个类，于是内部类就要扩展它。

由于构造器的名字必须与类名相同，而匿名类没有类名，所以匿名类不能有构造器。取而代之的是，将构造器参数传递给**超类（superclass）**构造器。尤其是在内部类实现接口的时候，不能有任何构造参数。

如果构造参数的闭圆括号跟一个开花括号，正在定义的就是匿名内部类。

*注释：下面的技巧称为"双括号初始化（double brace initialization）"，这里利用了内部类语法。外层括号建立了匿名子类，内层括号则是一个对象构造块。*

*警告：建立一个超类大体类似（但不完全相同）的匿名子类通常会很方便。不过，对于equals方法要特别当心。*

*提示：生成日志或调试信息时，通常希望包含当前类的类名，如getClass()。不过这对于静态方法不奏效。毕竟调用getClass时调用的是this.getClass()，而静态方法没有this。所以应该使用一下表达式：`new Object(){}.getClass().getEnclosingClass()//get class of static method`在这里，new Object(){}会建立一个匿名子类的匿名对象，getEnclosingClass则得到其外围类，也就是包含这个静态方法的类。*

### 6.4.7 静态内部类

有时候，使用内部类只是为了把一个类隐藏在另外一个类的内部，并不需要内部类引用外围类对象。为此，可以将内部类声明为static，以便取消产生的引用。

当然，只有内部类可以声明为static。静态内部类的对象出了没有对生成它的外围类对象的引用特权外，与其他所有内部类完全一样。

*注释：在内部类不需要访问外围类对象的时候，应该使用静态内部类。有些程序员用嵌套类（nested class）表示静态内部类。*

*注释：声明在接口中的内部类自动称为static和public类。*

## 6.5 代理

**代理（proxy）**是Java SE 1.3 新增加的特性。利用代理可以在运行时创建一个实现了一组给定接口的新类。==这种功能只有在编译时无法确定需要实现哪个接口时才有必要使用。==对于应用程序设计人员来说，遇到这种情况的机会很少。然而对于系统程序设计人员来说，代理带来的灵活性却十分重要。

代理类可以在运行时创建全新的类。这样的代理类能够实现指定的接口。尤其是，它具有下列方法：

- 指定接口所需要的全部方法。
- Object类中的全部方法，例如，toString，equals等。

然而不能在运行时定义这些方法的新代码。而是要提供一个**调用处理器（invocation handler）**。调用处理器是实现了InvocationHandler接口的类对象。在这个接口中只有一个方法：`Object invoke(Object proxy, Method method, Object[] args)`

无论何时调用代理对象的方法，调用处理器的invoke方法都会被调用，并向其传递Method对象和原始的调用参数。调用处理器必须给出调用处理的方式。

要想创建一个代理对象，需要使用Proxy类的newInstance方法。这个方法有三个参数：

- 一个**类加载器（class loader）**。作为Java安全模型的一部分，对于系统类和从因特网上下载下来的类，可以使用不同的类加载器。有关类加载器的详细内容将在卷II第9章中讨论。目前，用null表示使用默认的类加载器。
- 一个Class对象数组，每个元素都是需要实现的接口。
- 一个调用处理器。

代理对象属于在运行时定义的类（它有一个名字，如\$Proxy0）。

### 代理类的特性

代理类是在程序运行过程中创建的。然而，一旦被创建，就变成了常规类，与虚拟机中的任何其他类没有什么区别。

所有的代理类都扩展于Proxy类。一个代理类只有一个实例域——调用处理器，它定义在Proxy的超类中。为了履行代理对象的职责，所需要的任何附加数据都必须存储在调用处理器中。

所有代理类都覆盖了Object类中的方法toString、equals和hashCode。如同所有的代理方法一样，这些方法仅仅调用了调用处理器的invoke。Object类中的其他方法（如clone和getClass）没有被重新定义。

没有定义代理类的名字，Sun虚拟机中Proxy将生成一个以字符串\$Proxy开头的类名。

对于特定的类加载器和预设的一组接口来说，只能有一个代理类。也就是说如果使用同一个类加载器和接口数组调用两次newProxyInstance方法，那么只能够得到同一个类的两个对象，也可以利用getProxyClass方法获得这个类。

代理类一定是public和final。如果代理类实现的所有接口都是public，代理类就不属于某个特定的包；否则，所有非公有的接口都必须属于同一个包，同时，代理类也属于这个包。

可以通过调用Proxy类中的isProxyClass方法检测一个特定的Class对象是否代表一个代理类。

【API】java.lang.reflect.InvocationHandler 1.3 :

- `Object invoke (Object proxy, Method method, Object[] args)`

【API】java.lang.reflect.Proxy 1.3 :

- `static Class getProxyClass(ClassLoader loader, Class[] interfaces)`
- `static Object newProxyInstance(ClassLoader loader, Class[] interfaces, InvocationHandler handler)`

- `static boolean isProxyClass(Class c)`

