# 第6章 访问权限控制

访问控制（或隐藏具体实现）与“最初的实现并不恰当”有关。

如果你把一个代码段放到了某个位置，等过一会儿回头再看时，有可能会发现有更好的方式去实现相同的功能。这正是重构的原动力之一，**重构**即重写代码，以使得它更可读、更易理解，并因此而更具可维护性。

但你想改变改变代码，而消费者（客户端程序员）需要你的代码在某些方面保持不变。因此你想改变代码，而他们却想让代码保持不变。由此而产生了在面向对象设计中需要考虑的一个基本问题：“如何把变动的事物与保持不变的事物区分开来”。

这对类库（library）而言尤为重要。该类库的消费者必须依赖他所使用的那部分类库，并且能够知道如果类库出现了新版本，他们并不需要改写代码。从另一方面来说，类库的开发者必须有权限进行修改和改进，并确保客户代码不会因为这些改动而受到影响。

这一目标可以通过约定来达到。例如，类库开发者必须同意在改动类库中的类时不得删除任何现有方法，因为那样会破坏客户端的代码。但是，与之相反的情况会更加棘手。在有域（即数据成员）存在的情况下，类库开发者要怎样才能知道究竟都有哪些域已经被客户端程序员所调用了呢？这对于方法仅为类的实现的一部分，因此并不想让客户端程序员直接使用的情况来说同样如此。如果程序开发者想要移除旧的实现而要添加新的实现时，结果将会怎样呢？改动任何一个成员都有可能破坏客户端程序员的代码。于是类库开发者会手脚被缚，无法对任何事物进行改动。

为了解决这一问题，Java提供了访问权限修饰词，以供类库开发人员向客户端程序员指明哪些是可用的，哪些是不可用的。访问权限控制的等级，从大权限到最小权限依次为：public、protected、包访问权限（没有关键词）和private。根据前述内容，读者可能会认为，作为一名类库设计员，你会尽可能将一切方法都定为private，而仅向客户端程序员公开你愿意让他们使用的方法。这样做是完全正确的，尽管对于那些经常使用别的语言（特别是C语言）编写程序并在访问事物时不受任何限制的人而言，这与它们的直觉相违背。

不过，构件类库的概念以及对于谁有权取用该类库构件的控制问题都还是不完善的。其中仍旧存在着如何将构件捆绑到一个内聚的类库单元中的问题。对于这一点，Java用关键字package加以控制，而访问权限修饰词会因类是存在于一个相同的包，还是存在于一个单独的包而受到影响。为此，要开始学习本章，首先要学习如何将类库构件置于包中，然后就会理解访问权限修饰词的全部含义。

## 6.1 包：库单元

我们之所以要导入，就是要提供一个管理名字空间的机制。由于名字之间的潜在冲突，在Java中对名称空间进行完全控制并为每个类创建唯一的标识符组合就成为了非常重要的事情。

书中大多数示例实际上已经位于包中了：即**未命名**包，或称为**默认包**。不过如果你正在准备编写对在同一台机器上共存的其他Java程序友好的类库或程序的话，就需要考虑如何防止类名称之间的冲突问题。

当编写一个Java源代码文件时，此文件通常被称为编译单元（有时也被称为转移单元）。每个编译单元都必须有一个后缀名.java，而在编译单元内则可以有一个public类，该类的名称必须与文件的名称相同（包括大小写，但不包括文件的后缀名.java）。每个编译单元只能有一个public类，否则编译器就不会接受。如果在该编译单元之中还有额外的类的话，那么在包之外的世界是无法看见这些类的，这是因为它们不是public类，而且它们主要用来为主public类提供支持。

### 6.1.1 代码组织

当编译一个.java 文件时，在 .java 文件中的每个类都会有一个输出文件，而该输出文件的名称与.java文件中每个类的名称相同，只是多了一个后缀名.class。因此，在编译少量.java文件之后，会得到大量的.class文件。如果用编译型语言编写过程序，那么对于编译器产生一个中间文件（通常是一个obj文件），然后再与通过链接器（用以创建一个可执行文件）或类库产生器（librarian, 用以创建一个类库）产生的其他同类文件捆绑在一起的情况，可能早已司空见惯。但这并不是Java的工作方式。Java可运行程序是一组可以打包并压缩为一个Java文档文件（JAR, 使用Java的jar文档生成器）的.class文件。Java解释器负责这些文件的查找、装载和解释。

类库实际上是一组类文件。其中每个文件都有一个public类，以及任意数量的非public类。因此每个文件都有一个构件。如果希望这些构件（每一个都有它们自己的独立的.java和.class文件）从属于同一个群组，就可以使用关键字package。

如果使用package语句，它必须是文件中除注释以外的第一句程序代码。在文件起始处写：

```java
package access;
```

就表示你在声明该编译单元是名为access的类库的一部分。或者换种说法，你在声明该编译单元中的public类名称是位于access名称的保护伞下。任何想要使用该名称的人都必须使用前面给出的选择，指定全名或者与access结合使用关键字import。（请注意，Java包的命名规则全部使用小写字母，包括中间的字也是如此。）

例如，假设文件的名称是MyClass.java,这就意味着在该文件中有且仅有一个public类，该类的名称必须是MyClass（注意大小写）：

```java
//:access/mypackage/MyClass.java
package access.mypackage;

public class MyClass{
    // ...
}///:~
```

现在，如果有人想用MyClass或者是access中的任何其他public类，就必须使用关键import来使access中的名称可用

。另一个选择是给出完整的名称：

```java
//:access/QualifiedMyClass.java
public class QualifiedMyClass{
    public static void main(String[] args){
        access.mypackage.MyClass m = new access.mypackage.MyClass();
    }
}///:~
```

关键字import可使之更加简洁：

```java
//:access/ImportedMyClass.java
import access.mypackage.*;

public class ImportedMyClass{
    public static void main(String[] args){
        MyClass m = new MyClass();
    }
}///:~
```

身为一名类库设计员，很有必要牢记：package和import关键字允许你做的，是做单一的全局名字空间分隔开，使得无论多少人使用Internet以及Java开始编写类，都不会出现名称冲突问题。

### 6.1.2 创建独一无二的包名

读者也许会发现，既然一个包从未真正将被打包的东西包装成单一的文件，并且一个包可以由许多.class文件构成，那么情况就有点复杂了。为了避免这种情况的发生，一种合乎逻辑的做法就是将特定包的所有.class文件都置于一个目录下。也就是说，利用操作系统的层次化的文件结构来解决这一问题。这是Java解决混乱问题的一种方式，读者还会在我们介绍jar工具的时候看到另一种方式。

将所有的文件收入一个子目录还可以解决另外两个问题：怎样创建独一无二的名称以及怎样查找有可能隐藏于目录结构中某处的类。这些任务是通过将.class文件所在的路径位置编码成域名。如果你遵照管理，Internet域名应是独一无二的，因此你的package名称也将是独一无二的，也就不会出现名称冲突的问题了（也就是说，只有在你将自己的域名给了别人，而他又以你曾经使用过的路径名称来编写Java程序代码时，才会出现冲突）。当然，如果你没有自己的域名，你就得构造一组不大可能与他人重复的组合（例如你的姓名），来创立独一无二的package名称。如果你打算发布你的Java程序代码，稍微花点力气去取得一个域名，还是很有必要的。

此技巧的第二部分是把package名称分解为你机器上的一个目录。所以当Java程序运行并且需要加载.class 文件的时候，它就可以确定.class文件在目录上所处的位置。

Java解释器的运行过程如下：首先，找出环境变量CLASSPATH（可以通过操作系统来设置，有时也可通过安装程序——用来在你的机器上安装Java或基于Java的工具——来设置）。CLASSPATH包含一个或多个目录，用做查找.class文件的根目录。从根目录开始，解释器获取包的名称并将每个句点替换成反斜杠，以从CLASSPATH根中产生一个路径名称（于是，package foo.bar.baz就变成为foo\bar\baz或foo/bar/baz或其他，这一切取决于操作系统）。得到的路径会与CLASSPATH中的各个不同的项相连接，解释器就在这些目录中查找与你所要创建的类名称相关的.class文件。（解释器还会去查找某些涉及Java解释器所在位置的标准目录。）

为了理解这一点，以我的域名MindView.net为例。把它的顺序倒过来，并且将其全部转换为小写，net.mindview就成了我所创建的类的独一无二的全局名称。（com、edu、org等扩展名先前在Java包中都是大写的，但在Java2中一切都已改观，包的整个名称全都变成了小写。）若我决定再创建一个名为simple的类库，我可以将该名称进一步细分，于是我可以得到一个包的名称如下：

```java
package net.mindview.simple;
```

现在，这个包名称就可以用做下面两个文件的名字空间保护伞了：

```java
//:net/mindview/simple/Vector.java
//Creating a package.
package net.mindview.simple;

public class Vector{
    public Vector(){
        System.out.println("net.mindview.simple.Vector");
    }
}///:~
```

如前所述，package语句必须是文件中的第一行非注释程序代码，第二个文件看起来也极其相似：

```java
//:net/mindview/simple/list.java
//Creating a package.
package net.mindview.simple;

public class List{
    public List(){
        System.out.println("net.mindview.simple.List");
    }
}///:~
```

如果沿文件的路径往回看，可以看到包的名称com.bruceekel.simple，但此路径的第一部分怎样办呢？它将由环境变量CLASSPATH关照，在我的机器上是：

```
CLASSPATH=.;D:\JAVA\LIB;C:\DOC\JavaT
```

可以看到，CLASSPATH可以包含多个可供选择的查询路径。

但在使用JAR文件时会有一点变化。必须在类路径中将JAR文件的实际名称写清楚，而不仅是指明它所在位置的目录。因此，对于一个名为grape.jar的JAR文件，类路径应包括：

```
CLASSPATH=.;D\JAVA\LIB;C:\flavors\grape.jar
```

一旦类路径得以正确建立，下面的文件就可以放于任何目录之下：

```java
//:access/LibTest.java
// Uses the library.
import net.mindview.simple.*;

public class LibTest{
    public static void main(String[] args){
        Vector v = new Vector();
        List l = new List();
    }
}/*Output:
net.mindview.simple.Vector
net.mindview.simple.List
*///:~
```

当编译器碰到simple库的import语句时，就开始在CLASSPATH所指定的目录中查找，查找子目录net\mindview\simple，然后从以编译的文件中找出名称相符者（对Vector而言是Vector.class，对List而言是List.class）。请注意，Vector和List中的类以及要使用的方法都必须是public的。

对于使用Java的新手而言，设立CLASSPATH是很麻烦的一件事（我当初使用时就是这样的），为此，Sun将Java2中的JDK改造得更聪明了一些。在安装后你会发现，即使你未设立CLASSPATH，你也可以编译并运行基本的Java程序。然而，要编译的运行本书的源码包，就得向你的CLASSPATH中添加本书程序代码树中的基目录了。

### 冲突

如果将两个含有相同名称的类库以“*”形式同时导入，将会出现什么情况呢？例如，假设某程序这样写：

```java
import net.mindview.simple.*;
import java.util.*;
```

由于java.util.*也含有一个Vector类，这就存在潜在的冲突。但是只要你不写那些导致冲突的程序代码，就不会有什么问题——这样很好，否则就得做很多的类型检查工作来防止那些根本不会出现的冲突。

如果现在要创建一个Vector类的话，就会产生冲突；

```java
Vector v = new Vector();
```

这行到底取用的是哪个Vector类？编译器不知道，读者同样也不知道。于是编译器提出错误信息，强制你明确指明。举例说明，如果想要一个标准的Java Vector类，就得这样写：

```java
java.util.Vector v =new java.util.Vector();
```

或者，可以使用单个类导入的形式来防止冲突，只要你在同一个程序中没有使用有冲突的名字（在使用了有冲突名字的情况下，必须返回到指定全名的方式）。

### 6.1.3 定制工具库

具备这些知识以后，现在就可以创建自己的工具库来减少或消除重复的程序代码了。例如，我们已经用到的System.out.println()的别名也可以减少输入负担，这种机制可以用于名为Print的类中，这样，我们在使用该类时可以用一个更具可读性的静态import语句来导入：

```java
//:net/mindview/util/print.java
//print methods that can be used without qualifiers.
//using Java SE5 static imports:
package net.mindview.util;
import java.io.*;

public class Print{
    //Print with a new line:
    public static void print(Object obj){
        System.out.println(obj);
    }
    //Print a newline by itself;
    public static void print(){
        System.out.println();
    }
    //Print with no line break;
    public static void printnb(Object obj){
        System.out.print(obj);
    }
    //The new Java SE5 printf()(from C):
    public static PrintStream
        printf(String format, Object... args){
        return System.out.printf(format, args);
    }
}///:~
```

可以使用打印便捷工具来打印String，无论是需要换行(print())还是不需要换行(printnb())。

可以猜到，这个文件的位置一定是在某个以一个CLASSPATH位置开始，然后接着是net/mindview的目录下。编译完之后，就可以用import static语句在你的系统上使用静态的print()和printnb()方法了。

这个类库的第二个构件可以是在第4章引入的range()方法，它使得foreach语法可以用于简单的整数序列：

```java
//:net/mindview/util/Range.java
//Array creation methods that can be used without qualifiers.
//using Java SE5 static imports:
package net.mindview.util;

public class Range{
    //Produce a sequence [0..n)
    public static int[] range(int n){
        int[] result = new int[n];
        for(int i=0;i<n;i++)
            result[i]=i;
        return result;
    }
    //Produce a sequence[start..end)
    public static int[] range(int start,int end){
        int sz = end - start;
        int[] result = new int[sz];
        for(int i=0;i<sz;i++)
            result[i] = start + i;
        return result;
    }
    //Produce a sequence [start..end) increamenting by step
    public static int[] range(int start, int end , int step){
        int sz=(end-start)/step;
        int[] result = new int[sz];
        for(int i=0;i<sz;i++)
            result[i] = start+(i*step);
        return result;
    }
}///:~
```

从现在开始，你无论何时创建了有用的新工具，都可以将其添加到你自己的类库中。你将看到在本书中还有更多的构件添加到了net.mindview.util类库中。

### 6.1.4 用import改变行为

Java没有C的条件编译功能，该功能可以使你不必更改任何程序代码，就能够切换开关并产生不同的行为。Java去掉此功能的原因可能是因为C在绝大多数情况下是用此功能来解决跨平台问题的，即程序代码的不同部分是根据不同的平台来编译的。由于Java本身可以自动跨越不同的平台，因此这个功能对Java而言是没有必要的。

条件编译还有其他一些有价值的用途。调试就是一个很常见的用途。调试功能在开发过程中是开启的，而在发布的产品中是禁用的。可以通过修改被导入的package的方法来实现这一目的，修改的方法是将你程序中用到的方法从调试版改为发布版。这一技术可以适用于任何种类的条件代码。

### 6.1.5 对使用包的忠告

务必记住，无论何时创建包，都已经在给定包的名称的时候隐含地指定了目录结构。这个包必须位于其名称所指定的目录之中，而该目录必须在以CLASSPATH开始的目录中可以查询到的。最初使用关键字package，有可能会有一点不顺，因为除非遵守“包的名称对应目录路径”的规则，否则将会收到许多出乎意料的运行时信息，告知无法找到特定的类，哪怕是这个类就位于同一个目录中。如果你收到类似信息，就用注释掉package语句的方法试一下，如果这样程序就能运行的话，你就可以知道问题出在哪里了。

注意，编译过的代码通常放置在与源代码的不同目录中，但是必须保证JVN使用CLASSPATH可以找到该路径。

## 6.2 Java访问权限修饰词

### 6.2.1 包访问权限

默认访问权限没有任何关键字，但通常是指包访问权限（有时也表示称为friendly）。由于一个编译单元（即一个文件），只能隶属于一个包，所以经由包访问权限，处于同一个编译单元中的所有类彼此之间都是自动可访问的。

取得对某成员的访问权的唯一途径是：

1. 使该成员成为public。
2. 通过不加访问权限修饰词并将其他类放置于同一个包内的方式给成员赋予包访问权。
3. 在第7章将会介绍继承技术，届时读者将会看到继承而来的类既可以访问public成员也可以访问protected成员。
4. 提供访问器（accessor）和变异器（mutator）方法（也称作get/set方法），以读取和改变数值。正如将在第22章中看到的，对OOP而言，这是最优雅的方式，而且这也是JavaBeans的基本原理。

### 6.2.2 public：接口访问权限

使用关键字public，就意味着public之后紧跟着的成员声明自己对每个人都是可用的，尤其是使用类库的客户程序员更是如此。

不要错误地认为Java总是将当前目录视作是查找行为的起点之一。如果你的CLASSPATH之中缺少一个“.”作为路径之一的话，Java就不会查找那里。

### 默认包

令人吃惊的是，下面的程序代码虽然看起来破坏了上述规则，但它仍可以编译：

```java
//:access/Cake.java
//Accesses a class in a separate compilation unit.

class Cake{
    public static void main(String[] args){
        Pie x = new Pie();
        x.f();
    }
}/* Output:
Pie.f()
*///:~
```

在第二个处于相同目录的文件中：

```java
//:access/Pie.java
//The other class.
class Pie{
    void f(){
        System.out.println("Pie.f()");
    }
}///:~
```

最初或许会认为两个文件毫不相关，但Cake却可以创建一个Pie对象并调用它的f()方法！通常会认为Pie和f()享有包访问权限，因而是不可以为Cake所用的。它们的确享有包访问权限，但这只是部分正确的。Cake.java 可以访问它们的原因是因为它们同处于相同的目录并且没有给自己设定任何包名称。Java将这样的文件自动看做是隶属于该目录的默认包之中，于是它们为该目录中所有的文件都提供了包访问权限。

### 6.2.3 private：你无法访问

关键字private的意思是，除了包含该成员的类之外，其他任何类都无法访问这个成员。由于处于统一个包内的其他类是不以访问private成员的，因此这等于说是自己隔离了自己。从另一方面说，让许多人共同合作来创建一个包也是不大可能的，为此private就允许你随意改变该成员，而不必考虑这样做是否会影响到包内的其他的类。

默认的包访问权限通常已经提供了充足的隐藏措施。请记住，使用类的客户端程序员是无法访问包访问权限成员的。然而，事实很快就会证明，对private的使用多么的重要，在多线程环境下更是如此（正如将在第21章看到的）。

此处有一个使用private的示例。

```java
//:access/IceCream.java
//Demonstrates "private" keyword.
class Sundae{
    private Sundae(){}
    static Sundae makeASundae(){
        return new Sundae();
    }
    
}
public class IceCream{
    public static void main(String[] args){
        //!Sundae x = new Sundae();
        Sundae x = Sundae.makeASundae();
    }
}///:~
```

这是一个说明private终有其用武之地的示例：可能想控制如何创建对象，并组织别人直接访问某个特定的构造器（或全部构造器）。在上面的例子中，不能通过构造器来创建Sundae对象，而必须调用makeASundae()方法来达到此目的（此例还有一个效果：既然默认构造器是唯一定义的构造器，并且它是private的，那么它将阻碍对此类的继承（我们将在后面介绍这个问题））。

任何可以肯定只是该类的一个“助手”方法的方法，都可以把它指定为private，以确保不会在包内的其他地方误用到它，于是也就放置了你会去改变或删除这个方法。将方法指定为private确保了你有这种选择权。

这对于类中的private域同样使用。除非必须公开底层实现细目（此种情况很少见），否则就应该将所有的域指定为private。然而不能因为在类中某个对象的引用是private，就认为其他的对象无法拥有该对象的public引用（参见本书的在线补充材料以了解有关别名机制的话题）。

### 6.2.4 protected：继承访问权限

关键字protected处理的是继承的概念，通过继承可以利用一个现有类——我们将其称为基类，然后将新成员添加到该现有类中而不必碰该现有类。还可以改变该类的现有成员的行为。为了从现有类中继承，需要声明新类extends（扩展）了一个现有类，就像这样：

```java
class Foo extends Bar{
```

类定义中其他部分看起来都是一样的。

如果创建了一个新包，并自另一个包中继承类，那么唯一可以访问的成员就是源包的public成员。（当然，如果在统一个包内执行继承工作，就可以操纵所有的拥有包访问权限的成员。）有时，基类的创建者会希望有某个特定成员，把它的访问权限赋予派生类而不是所有类。这就需要protected来完成这一工作。protected也提供包访问权限，也就是说，相同包内的其他类可以访问protected元素。

## 6.3 接口和实现

访问权限的控制常被称为是具体实现的隐藏。把数据和方法包装进类中，以及具体实现的隐藏，常共同被称为是**封装**（然而，人们经常只单独将具体实现的隐藏称为封装）。其结果是一个同时带有特征和行为的数据类型。

出于两个很重要的原因，访问权限控制将权限的边界花在了数据类型的内部。第一个原因是要设定客户端程序员可以使用和不可以使用的界限。可以在结构中建立自己的内部机制，而不必担心客户端程序员会偶然地将内部机制当作是他们可以使用的接口的一部分。

这个原因直接引出了第二个原因，即将接口和具体实现进行分离。

为了清楚起见，可能会采用一种将public成员置于开头，后面跟着protected、包访问权限和private成员的创建类的形式。主要做的好处是类的使用者可以从头读起，首先阅读对他们而言最为重要的部分，等到遇见作为内部实现细节的非public成员时停止阅读。

这样做仅能使程序阅读起来稍微容易一些，因为接口和具体实现仍旧混在一起。也就是说，仍能看到源代码——实现部分，因为它就在类中。另外，javadoc所提供的注释文档功能降低了程序代码的可读性对客户端程序员的重要性。将接口展现给某个类的使用者实际上是类浏览器的任务。类浏览器是一种以非常有用的方式来查阅所有可用的类，并告诉你用它们可以做些什么（也就是显示出可用成员）的工具。在Java中，用Web浏览器浏览JDK文档可以得到使用类浏览器的相同效果。

## 6.4 类的访问权限

在Java中，访问权限修饰词也可以用于确定库中的哪些类对于该库的使用者是可用的。如果希望某个类可以为某个客户端程序员所用，就可以通过把关键字public作用于整个类的定义来达到目的。这样做甚至可以控制客户端程序员是否能创建一个该类的对象。

为了控制某个类的访问权限，修饰词必须出现于关键字class之前。因此可以像下面这样声明：

```java
public class Widget{
```

现在如果库的名字是access，那么任何客户端程序员都可以通过下面的声明访问Widget；

```java
import access.Widget;
```

或

```java
import access.*;
```

然而，这里还有一些额外的限制：

1. 每个编译单元（文件）都只能有一个public类。这表示，每个编译单元都有单一的公共接口，用public类来表现。该接口可以按要求包含众多的支持包访问权限的类。如果在某个编译单元内有一个以上的public类，编译器就会给出出错信息。
2. public类的名称必须完全与含有该编译单元的文件名相匹配，包括大小写。
3. 虽然不是很常用，但编译单元内完全不带public类也是可能的。在这种情况下，可以随意对文件命名。（尽管随意命名会使得人们在阅读和维护代码时产生混淆。）

在创建一个包访问权限的类时，仍旧是在将该类的域声明为private时才有意义——应尽可能地总是将域指定为私有的，但是通常来说，将与类（包访问权限）相同的访问权限赋予方法也是很合理的。既然一个有包访问权限的类通常只能被用于包内，那么如果对你有强制要求，在此种情况下，编译器会告诉你，你只需要将这样的类的方法设定为public就可以了。

请注意，类既不可以是private的（这样会使得除该类之外，其他任何类都不可以访问它），也不可以是protected的。（事实上，一个内部类可以是private或是protected的，但那是一个特例。这将在第10章中介绍到）所以对于类的访问权限，仅有两个选择：包访问权限或public。如果不希望其他任何人对该类拥有访问权限，可以把所有的构造器都指定为private，从而组织任何人创建该类的对象，但有一个例外，就是你在该类的static成员内部可以创建。

如果把构造器指定为private，那么别人该如何使用这个类呢？1.创建一个static方法，它创建一个新的对象并返回一个对它的引用。2.用到了所谓的单例(singleton)设计模式，这是因为你始终只能创建它的一个对象。

如果包访问权限的类的某个static成员是public的话，则客户端程序员仍旧可以调用该static成员，尽管他们并不能生成该类的对象。