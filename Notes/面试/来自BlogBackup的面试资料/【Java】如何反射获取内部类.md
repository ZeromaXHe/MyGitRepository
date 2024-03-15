# 简答

简单来说，普通内部类和静态内部类可以直接通过外围类的 Class 对象的 `getDeclaredClasses` 方法获取，也可以通过 `外围类名$内部类名` 的方式使用 `Class.forName` 方法获取到。

而匿名内部类需要将其赋值给外围类的成员变量，然后通过成员变量来进行反射。（lambda 与其类似）

局部内部类则无法通过反射获取到。

# 详解

要解答这个问题，我们首先需要明确两个方面的定义：反射和内部类。

接下来我们先回答如何反射获取匿名内部类相关的问题（包括其他内部类的获取方法），如果对反射和内部类这两个概念不熟悉的读者，可以先看后面的两个概念的介绍，再回来看回答。

## 1 如何反射获取内部类

简单来说，普通内部类和静态内部类可以直接通过外围类的 Class 对象的 `getDeclaredClasses` 方法获取，也可以通过 `外围类名$内部类名` 的方式使用 `Class.forName` 方法获取到。而匿名内部类需要将其赋值给外围类的成员变量，然后通过成员变量来进行反射。

下面是一个测试程序，其中包括了普通内部类、局部内部类（反射访问不到）、匿名内部类、静态内部类、lambda 等：

~~~java
package com.zerox.javatest;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

/**
 * @Author: zeromax
 * @Time: 2022/3/29 10:08
 * @Description:
 * @ModifiedBy: zeromax
 */
public class ReflectOnInnerClassTest {
    static class InnerContainer {
        public void localInnerTest() {
            // 局部内部类
            class LocalInner {
                private String f = LocalInner.class.getSimpleName();

                public void test() {
                    System.out.println(f);
                }
            }

            new LocalInner().test();
        }

        // 普通内部类
        class Inner {
            private String f = Inner.class.getSimpleName();
        }

        // 静态内部类
        static class StaticInner {
            private String f = StaticInner.class.getSimpleName();
        }

        // 匿名内部类
        Runnable anonymousInner = new Runnable() {
            @Override
            public void run() {
                System.out.println("Method run of Runnable anonymousInner");
            }
        };

        Runnable lambda = () -> System.out.println("Method run of Runnable lambda");
    }

    public static void main(String[] args) throws ClassNotFoundException {
        printAllReflections("com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer");
        printAllReflections("com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer$Inner");
        printAllReflections("com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer$StaticInner");
    }

    public static void printAllReflections(String className) throws ClassNotFoundException {
        Class cl = Class.forName(className);
        Class superCl = cl.getSuperclass();
        String modifiers = Modifier.toString(cl.getModifiers());
        if (modifiers.length() > 0) {
            System.out.print(modifiers + " ");
        }
        System.out.print("class " + className);
        if (superCl != null && superCl != Object.class) {
            System.out.print(" extends " + superCl.getName());
        }
        System.out.print("\n{\n");
        printConstructors(cl);
        printMethods(cl);
        printFields(cl);
        printInner(cl);
        System.out.println("}");
    }

    public static void printConstructors(Class cl) {
        Constructor[] constructors = cl.getDeclaredConstructors();
        if (constructors.length > 0) {
            System.out.println("    构造方法：");
            for (Constructor c : constructors) {
                String name = c.getName();
                System.out.print("    ");
                String modifiers = Modifier.toString(c.getModifiers());
                if (modifiers.length() > 0) {
                    System.out.print(modifiers + " ");
                }
                System.out.print(name + "(");

                Class[] paramTypes = c.getParameterTypes();
                for (int i = 0; i < paramTypes.length; i++) {
                    if (i > 0) {
                        System.out.print(", ");
                    }
                    System.out.print(paramTypes[i].getName());
                }
                System.out.println(");");
            }
        }
    }

    public static void printMethods(Class cl) {
        Method[] methods = cl.getDeclaredMethods();
        if (methods.length > 0) {
            System.out.println("    方法：");
            for (Method m : methods) {
                Class retType = m.getReturnType();
                String name = m.getName();

                System.out.print("    ");
                String modifiers = Modifier.toString(m.getModifiers());
                if (modifiers.length() > 0) {
                    System.out.print(modifiers + " ");
                }
                System.out.print(retType.getName() + " " + name + "(");

                Class[] paramTypes = m.getParameterTypes();
                for (int i = 0; i < paramTypes.length; i++) {
                    if (i > 0) {
                        System.out.print(", ");
                    }
                    System.out.print(paramTypes[i].getName());
                }
                System.out.println(");");
            }
        }
    }

    public static void printFields(Class cl) {
        Field[] fields = cl.getDeclaredFields();
        if (fields.length > 0) {
            System.out.println("    成员变量：");
            for (Field f : fields) {
                Class type = f.getType();
                String name = f.getName();
                System.out.print("    ");
                String modifiers = Modifier.toString(f.getModifiers());
                if (modifiers.length() > 0) {
                    System.out.print(modifiers + " ");
                }
                System.out.println(type.getName() + " " + name + ";");
            }
        }
    }

    private static void printInner(Class cl) {
        Class[] innerClazz = cl.getDeclaredClasses();
        if (innerClazz.length > 0) {
            System.out.println("    内部类：");
            for (Class cls : innerClazz) {
                System.out.print("    ");
                String modifiers = Modifier.toString(cls.getModifiers());
                if (modifiers.length() > 0) {
                    System.out.print(modifiers + " ");
                }
                System.out.println(cls.getName());
            }
        }
    }
}
~~~

调用 main 方法后，可以看到：

~~~
static class com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer
{
    构造方法：
    com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer();
    方法：
    private static void lambda$new$0();
    public void localInnerTest();
    成员变量：
    java.lang.Runnable anonymousInner;
    java.lang.Runnable lambda;
    内部类：
    static com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer$StaticInner
    com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer$Inner
}
class com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer$Inner
{
    构造方法：
    com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer$Inner(com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer);
    成员变量：
    private java.lang.String f;
    final com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer this$0;
}
static class com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer$StaticInner
{
    构造方法：
    com.zerox.javatest.ReflectOnInnerClassTest$InnerContainer$StaticInner();
    成员变量：
    private java.lang.String f;
}
~~~

## 2 反射

**反射库**（reflection library）提供了一个丰富且精巧的工具集，可以用来编写能够动态操纵 Java 代码的程序。使用反射，Java 可以支持用户界面生成器、对象关系映射器以及很多其他需要动态查询类能力的开发工具。

能够分析类能力的程序称为**反射**（reflective）。反射机制的功能极其强大，反射机制可以用来：

- 在运行时分析类的能力。
- 在运行时检查对象，例如，编写一个适用于所有类的 toString 方法。
- 实现范型数组操作代码。
- 利用 Method 对象，这个对象很像 C++ 中的函数指针。

### 2.1 Class 类

在程序运行期间，Java 运行时系统始终为所有对象维护一个**运行时类型标识**。这个信息会跟踪每个对象所属的类。虚拟机利用运行时类型信息选择要执行的正确的方法。

不过，可以使用一个特殊的 Java 类访问这些信息。保存这些信息的类名为 Class，这个名字有些让人困惑。Object 类中的 `getClass()` 方法将会返回一个 Class 类型的实例。

Class 对象会描述一个特定类的属性。可能最常用的 Class 方法就是 `getName`，这个方法将返回类的名字。如果类在一个包里，包的名字也作为类名的一部分，例如 `java.util.Random`。



还可以使用静态方法 `forName` 获得类名对应的 Class 对象，例如 `Class.forName(className)`。如果传入的 className 是一个类名或接口名，这个方法可以正常执行。否则，`forName` 方法将抛出一个**检查型异常**（checked exception）。无论何时使用这个方法，都应该提供一个**异常处理器**（exception handler）。



获得 Class 类对象的第三种方法是一个很方便的快捷方式。如果 T 是任意的 Java 类型（或 void 关键字），`T.class` 将代表匹配的类对象。

请注意，一个 Class 对象实际上表示的是一个**类型**，这可能是类，有可能不是类。例如，int 不是类，但 `int.class` 是一个 Class 类型的对象。

> **注释**：Class 类实际上是一个泛型类。例如，`Employee.class` 的类型是 `Class<Employee>`。在大多数实际问题中，可以忽略类型参数，而使用原始的 Class 类。

> **警告**：鉴于历史原因，`getName` 方法在应用于数组类型的时候会返回有些奇怪的名字：
>
> - `Double[].class.getName()` 返回 "`[Ljava.lang.Double`"
> - `int[].class.getName()` 返回 “`[I`”

如果有一个 Class 类型的对象，可以用它构造类的实例。调用 `getConstructor` 方法将得到一个 Constructor 类型的对象，然后使用 `newInstance` 方法来构造一个实例。

~~~java
String className = "java.util.Random";
Class cl = Class.forName(className);
Object obj = cl.getConstructor().newInstance();
~~~

如果这个类没有无参数的构造器，`getConstructor` 方法会抛出一个异常。可以参见“调用任意方法和构造器”一节了解如何调用其他构造器。

> **注释**：有一个已经废弃的 `Class.toInstance` 方法，它也可以用无参数构造器构造一个实例。不过，如果构造器抛出一个检查型异常，这个异常将不做出任何检查重新抛出。这违反了编译时异常检查的原则。与之不同，Constructor.newInstance 会把所有构造器异常包装到一个 InvocationTargetException 中。

### 2.2 利用反射分析类的能力

下面简要介绍反射机制最重要的内容——检查类的结构。

在 `java.lang.reflect` 包中有三个类 `Field`、`Method` 和 `Constructor` 分别用于描述类的字段、方法和构造器。这三个类都有一个叫作 `getName` 的方法，用来返回字段、方法或构造器的名称。

`Field` 类有一个 `getType` 方法，用来返回描述字段类型的一个对象，这个对象的类型同样是 `Class`。`Method` 和 `Constructor` 类有报告参数类型的方法，`Method` 类还有一个报告返回类型的方法。这三个类都有一个名为 `getModifiers` 的方法，它将返回一个整数，用不同的 0/1 位描述所使用的修饰符，如 `public ` 和 `static`。

另外，还可以利用 `java.lang.reflect` 包中 `Modifier` 类的静态方法分析 `getModifiers` 返回的这个整数。例如，可以使用 `Modifier` 类中的 `isPublic`、`isPrivate` 或 `isFinal` 判断方法或构造器是 `public`、`private` 还是 `final`。我们需要做的就是在 `getModifiers` 返回的整数上调用 `Modifier` 类中适当的方法，另外，还可以利用 `Modifier.toString` 方法将修饰符打印出来。

`Class` 类中的 `getFields`、`getMethods` 和 `getConstructors` 方法将分别返回这个类支持的公共字段、方法和构造器的数组，其中包括超类的公共成员。`Class` 类的 `getDeclareFields`、`getDeclareMethods` 和 `getDeclaredConstructors` 方法将分别返回类中声明的全部字段、方法和构造器的数组，其中包括私有成员、包成员和受保护成员，但不包括超类的成员。

### 2.3 使用反射在运行时分析对象

在编写程序时，如果想要查看的字段名和类型，查看对象中指定字段的内容是一件很容易的事情。而利用反射机制可以查看在编译时还不知道的对象字段。

要做到这一点，关键方法是 `Field` 类中的 `get` 方法。如果 `f` 是一个 `Field` 类型的对象（例如，通过 `getDeclaredFields` 得到的对象），`obj` 是某个包含 `f` 字段的类的对象，`f.get(obj)` 将返回一个对象，其值为 `obj` 的当前字段值。

当然，不仅可以获得值，也可以设置值。调用 `f.set(obj, value)` 将把对象 `obj` 的 `f` 表示的字段设置为新值。

如果是一个私有字段，`get` 和 `set` 方法会抛出一个 `IllegalAccessException`。只能对可以访问的字段使用 `get` 和 `set` 方法。Java 安全机制允许查看一个对象有哪些字段，但是除非拥有访问权限，否则不允许读写那些字段的值。

反射机制的默认行为受限于 Java 的访问控制。不过，可以调用 `Field`、`Method` 或 `Constructor` 对象的 `setAccessible` 方法覆盖 Java 的访问控制。

`setAccessible` 方法是 `AccessibleObject` 类中的一个方法，它是 `Field`、`Method` 和 `Constructor` 类的公共超类。这个特性是为调试、持久存储和类似机制提供的。

如果不允许访问，`setAccessible` 调用会抛出一个异常。访问可以被模块系统或安全管理器拒绝。安全管理器并不常用。不过，在 Java 9 中，由于 Java API 是模块化的，每个程序都包含模块。

### 2.4 调用任意方法和构造器

在 C 和 C++ 中，可以通过一个函数指针执行任意函数。从表面上看，Java 没有提供方法指针，也就是说，Java 没有提供途径将一个方法的存储地址传给另外一个方法，以便第二个方法以后调用。事实上，Java 的设计者曾说过：方法指针是很危险的，而且很容易出错。他们认为 Java 的接口（interface）和 lambda 表达式是一种更好的解决方案。不过，反射机制允许你调用任意的方法。

回想一下，可以用 Field 类的 `get` 方法查看一个对象的字段。与之类似，Method 类有一个 `invoke` 方法，允许你调用包装在当前 Method 对象中的方法。`invoke` 方法的签名是：

~~~java
Object invoke(Object obj, Object... args)
~~~

第一个参数是隐式参数，其余的对象提供了显式参数。

对于静态方法，第一个参数可以忽略，即可以将它设置为 null。

例如，假设用 ml 表示 Employee 类的 `getName` 方法，下面这条语句显示了如何调用这个方法：

~~~java
String n = (String) ml.invoke(harry);
~~~

如果返回类型是基本类型，invoke 方法会返回其包装器类型。

~~~java
double s = (Double) m2.invoke(harry);
~~~

如何得到 `Method` 对象呢？当然，可以调用 `getDeclareMethods` 方法，然后搜索返回的 Method 对象数组，直到发现想要的方法为止。也可以调用 Class 类的 `getMethod` 方法得到想要的方法。它与 `getField` 方法类似。`getField` 方法根据表示字段名的字符串，返回一个 Field 对象。不过，有可能存在若干个同名的方法，因此要准确地得到想要的那个方法必须格外小心。有鉴于此，还必须提供想要的方法的参数类型。`getMethod` 的签名是：

~~~java
Method getMethod(String name, Class... parameterTypes)
~~~

可以使用类似的方法调用任意的构造器。将构造器的参数类型提供给 `Class.getConstructor` 方法，并把参数值提供给 `Constructor.newInstance` 方法。

利用 Method 对象可以实现 C 语言中函数指针（或 C# 中的委托）所能完成的所有操作。同 C 中一样，这种编程风格不是很简便，而且总是很容易出错。如果在调用方法的时候提供了错误的参数会发生什么？`invoke` 方法将会抛出一个异常。

另外，`invoke` 的参数和返回值必须是 `Object` 类型。这就意味着必须来回进行多次强制类型转换。这样一来，编译器会丧失检查代码的机会，以至于等到测试阶段才会发现错误，而这个时候查找和修正错误会麻烦得多。不仅如此，使用反射获得方法指针的代码要比直接调用方法的代码慢得多。

有鉴于此，建议仅在绝对必要的时候才在你自己的程序中使用 `Method` 对象。通常更好的做法是使用接口以及 Java 8 引入的 lambda 表达式。特别要强调：我们建议 Java 开发者不要使用回调函数的 `Method` 对象。可以使用回调的接口，这样不仅代码的执行速度更快，也更易于维护。

## 3 内部类

**内部类**（inner class）是定义在另一个类中的类。为什么需要使用内部类呢？主要有两个原因：

- 内部类可以对同一个包中的其他类隐藏。
- 内部类方法可以访问定义这个类的作用域中的数据，包括原本私有的数据。

内部类原先对于简洁地实现回调非常重要，不过如今 lambda 表达式在这方面可以做得更好。但内部类对于构建代码还是很有用的。

### 3.1 使用内部类访问对象状态

一个内部类方法可以访问自身的数据字段，也可以访问创建它的外围类对象的数据字段。

为此，内部类的对象总有一个隐式引用，指向创建它的外部类对象。这个引用在内部类的定义中是不可见的。

外围类的引用在构造器中设置。编译器会修改所有的内部类构造器，添加一个对应外围类引用的参数。

### 3.2 内部类的特殊语法规则

表达式 `OuterClass.this` 表示外围类引用。

在外围类的作用域之外，可以这样引用内部类：`OuterClass.InnerClass`

### 3.3 内部类是否有用、必要和安全

当 Java 语言在 Java 1.1 中增加内部类时，很多程序员都认为这是一项很重要的新特性，但这违背了 Java 要比 C++ 更加简单的设计理念。不能否认，内部类的语法很复杂。它与访问控制和安全性等其他语言特性没有明显的关联。

需要指出，内部类是一个**编译器**现象，与虚拟机无关。编译器将会把内部类转换为常规的类文件，用 `$`（美元符号）分隔外部类名与内部类名，而虚拟机则对此一无所知。

使用 javap 工具，如下所示：

~~~sh
javap -private ClassName
~~~

ClassName 传入一个内部类，则可以在结果中清楚地看到，编译器生成了一个额外的实例字段 `this$0`，对应外围类的引用。（名字 `this$0` 是编译器合成的，在你自己编写的代码中不能引用这个字段。）

内部类可以访问外围类的私有数据，但我们的外部类则不行。

可见，由于内部类拥有更大的访问权限，所以天生就比常规类功能更加强大。

既然内部类会转换成名字古怪的常规类（而虚拟机对此一点也不了解），内部类又如何得到那些额外的访问权限呢？我们可以使用反射程序查看一下外围类，会发现编译器在外围类添加了一个静态方法 `access$0`。它将返回作为参数传递的那个对象的 `beep` 字段。（方法名可能稍有不同，如可能是 `access$000`，这取决于你的编译器。）内部类方法将调用那个方法。

这样做不是存在安全风险吗？这种担心是很有道理的。任何人都可以通过调用 `access$0` 方法很容易地读取到私有字段 `beep`。当然，`access$0` 不是 Java 的合法方法名。但熟悉类文件结构的黑客可以使用十六进制编辑器轻松地创建一个类文件，其中利用虚拟机指令调用那个方法。由于隐秘方法需要拥有包可见性，所以攻击代码需要与被攻击类放在同一个包中。

总而言之，如果内部类访问了私有数据字段，就有可能通过外围类所在包中增加的其他类访问那些字段，但做这些事情需要技巧和决心。程序员不可能无意之中就获得对类的访问权限，而必须刻意地构建或修改类文件才有可能达到这个目的。

### 3.4 局部内部类

如果在外部类中，仅仅在某个方法创建的内部类对象时使用了一次内部类；在遇到这种情况时，可以在**一个方法中局部地**定义这个类。

声明局部类时不能有访问说明符（即 `public` 或 `private`）。局部类的作用域被限定在声明这个局部类的块中。

局部类有一个很大的优势，即对外部世界完全隐藏，甚至外围类中的其他代码也不能访问它。除所在方法之外，没有任何方法知道局部内部类的存在。

### 3.5 由外部方法访问变量

与其他内部类相比较，局部类还有一个优点。它们不仅能够访问外部类的字段，还可以访问局部变量！不过，那些局部变量必须是**事实最终**变量（effectively final）。这说明，它们一旦赋值就绝不会改变。

编译器检测对局部变量的访问，为每一个变量建立相应的实例字段，并将局部变量复制到构造器，从而能初始化这些实例字段。

### 3.6 匿名内部类

使用局部内部类时，通常还可以再进一步。假如只想创建这个类的一个对象，甚至不需要为类指定名字。这样一个类被称为**匿名内部类**（anonymous inner class）。

一般地，语法如下：

~~~java
new 超类型(构造参数) {
    内部类方法和数据
}
~~~

其中，超类型可以是接口，如果是这样，内部类就要实现这个接口。超类型也可以是一个类，如果是这样，内部类就要扩展这个类。

由于构造器的名字必须与类名相同，而匿名内部类没有类名，所以，匿名内部类不能有构造器。实际上，构造参数要传递给**超类**（superclass）构造器。具体地，只要内部类实现一个接口，就不能有任何构造参数。不过，仍然要提供一组小括号，如下所示：

~~~java
new InterfaceType() {
    方法和数据
}
~~~

> **注释**：尽管匿名类不能有构造器，但可以提供一个对象初始化块

必须仔细研究构造一个类的新对象与构造一个扩展了那个类的匿名内部类的对象之间有什么差别。如果构造参数列表的结束小括号后面跟一个开始大括号，就是在定义匿名内部类。

多年来，Java 程序员习惯的做法是用匿名内部类实现事件监听器和其他回调。如今最好还是使用 lambda 表达式。

> **注释**：下面的技巧称为“**双括号初始化**”（double brace initialization），这里利用了内部类语法。假设你想构造一个数组列表，并将它传递到一个方法：
>
> ~~~java
> var friends = new ArrayList<String>();
> friends.add("Harry");
> friends.add("Tony");
> invite(friends);
> ~~~
>
> 如果不再需要这个数组列表，最好让它作为一个匿名列表。
>
> ~~~java
> invite(new ArrayList<String>(){{ add("Harry"); add("Tony"); }});
> ~~~
>
> 注意这里的双括号。外层括号建立了一个 ArrayList 的一个匿名子类。内层括号则是一个对象初始化块。
>
> 在实际中，这个技巧很少使用。大多数情况下，invite 方法会接受任何 `List<String>`，所以可以直接传入 `List.of("Harry", "Tony")`。

### 3.7 静态内部类

有时候，使用内部类只是为了把一个类隐藏在另外一个类的内部，并不需要内部类有外围类对象的一个引用。为此，可以将内部类声明为 `static`，这样就不会生成那个引用。

> **注释**：只要内部类不需要访问外围类对象，就应该使用静态内部类。有些程序员用**嵌套类**（nested class）表示静态内部类。

> **注释**：与常规内部类不同，静态内部类可以有静态字段和方法。

> **注释**：在接口中声明的内部类自动是 `static` 和 `public`。

# 参考文档

- 《Java 核心技术 卷一：基础知识》（原书第11版）5.7 反射、6.3 内部类