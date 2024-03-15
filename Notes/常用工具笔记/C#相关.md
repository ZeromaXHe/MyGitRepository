# 引用参数和输出参数

《C#入门经典》（第7版）6.1.2 参数

ref 和 out 关键字

# 变量作用域

《C#入门经典》（第7版）6.2.1 其他结构中变量的作用域

~~~c#
int i;
string text;
for(i = 0; i < 10; i++)
{
    text = "Line " + Convert.ToString(i);
    WriteLine($"{text}");
}
WriteLine($"Last text output in loop: {text}");
~~~

这段代码也会失败，原因是必须在使用变量前对其进行声明和初始化，但text只在for循环中初始化。由于没有在循环外进行初始化，赋给text的值在循环块退出时就丢失了。

# 委托

《C#入门经典》（第7版）6.6 委托

委托（delegate）是一种存储函数引用的类型。

~~~c#
class Program
{
    delegate double ProcessDelegate(double param1, double param2);
    static double Multiply(double param1, double param2) => param1 * param2;
    static double Divide(double param1, double param2) => param1 / param2;
    
    static void Main(String[] args)
    {
        ProcessDelegate process;
        WriteLine("Enter 2 numbers separated with a comma:");
        String input = ReadLine();
        int commaPos = input.IndexOf(',');
        double param1 = ToDouble(input.substring(0, commaPos));
        double param2 = ToDouble(input.substring(commaPos + 1, input.Length - commaPos - 1));
        WriteLine("Enter M to multiply or D to divide:");
        input = ReadLine();
        if (input == "M") 
            process = new ProcessDelegate(Multiply);
        else
            process = new ProcessDelegate(Divide);
        WriteLine($"Result: {process(param1, param2)}");
        ReadKey();
    }
}
~~~

这里可以使用略微简单的语法

~~~c#
if (input == "M") 
    process = Multiply;
else
    process = Divide;
~~~

# 密封类

《C#入门经典》（第7版） 9.1 C#中的类定义

~~~c#
public sealed class MyClass
{
    // class members.
}
~~~

# System.Object

《C#入门经典》（第7版） 9.2 System.Object

| 方法                                      | 返回类型    | 虚拟 | 静态 | 说明                                                         |
| ----------------------------------------- | ----------- | ---- | ---- | ------------------------------------------------------------ |
| Object()                                  | N/A         | 否   | 否   | System.Object类型的构造函数，由派生类型的构造函数自动调用    |
| ~Object()（也称为Finalize()，参见下一节） | N/A         | 否   | 否   | System.Object类型的析构函数，由派生类型的析构函数自动调用，不能手动调用 |
| Equals(object)                            | bool        | 是   | 否   | 把调用该方法的对象与另一个对象相比，如果它们相等，就返回true，默认的实现代码会查看其对象参数是否引用了同一个对象（因为对象是引用类型）。如果想以不同方式来比较对象，则可以重写该方法，例如，比较两个对象的状态 |
| Equals(object, object)                    | bool        | 否   | 是   | 这个方法比较传送给它的两个对象，看看它们是否相等。检查时使用了Equals(object)方法。注意，如果两个对象都是空引用，这个方法就返回true |
| ReferenceEquals(object, object)           | bool        | 否   | 是   | 这个方法比较传送给它的两个对象，看看它们是不是同一个实例的引用 |
| ToString()                                | String      | 是   | 否   | 返回一个对应于对象实例的字符串。默认情况下，这时一个类类型的限定名称，但可以重写它，给类类型提供合适的实现方式 |
| MemberwiseClone()                         | object      | 否   | 否   | 通过创建一个新对象实例并复制成员，以复制该对象。成员复制不会得到这些成员的新实例。新对象的任何引用类型成员都将引用与源类相同的对象，这个方法是受保护的，所以只能在类或派生的类中使用 |
| GetType()                                 | System.Type | 否   | 否   | 以System.Type对象的形式返回对象的类型                        |
| GetHashCode()                             | int         | 是   | 否   | 在需要此参数的地方，用作对象的散列函数，它返回一个以压缩形式标识对象状态的值 |

# 定义字段

《C#入门经典》（第7版） 10.1.1 定义字段

用标准的变量声明格式（可以进行初始化）和前面介绍的修饰符来定义字段，例如：

~~~c#
class MyClass
{
    public int MyInt;
}
~~~

> **注意**：.NET Framework 中的公共字段以 PascalCasing 形式来命名，而不是 camelCasing，这里使用的就是这种大小写形式，所以上面的字段称为 MyInt 而不是 myInt。这仅是推荐使用的一种名称大小写形式，但它的意义非常重大。私有字段没有推荐的名称大小写模式，它们通常使用 camelCasing 来命名。

字段也可以使用关键字readonly，表示这个字段只能在执行构造函数的过程中赋值，或由初始化赋值语句赋值。例如：

~~~c#
class MyClass
{
    public readonly int MyInt = 17;
}
~~~

可使用static关键字将字段声明为静态，例如：

~~~c#
class MyClass
{
    public static int MyInt;
}
~~~

静态字段必须通过定义它们的类来访问（在上面的示例中，是M有Class.MyInt），而不是通过这个类的对象实例来访问。另外，可使用关键字const来创建一个常量值。按照定义，const成员也是静态的，所以不需要使用static修饰符（实际上，使用static修饰符会产生一个错误）。

# 定义方法

《C#入门经典》（第7版） 10.1.2 定义方法

- virtual——方法可以重写
- abstract——方法必须在非抽象的派生类中重写（只用于抽象类中）。
- override——方法重写了一个基类方法（如果方法被重写，就必须使用该关键字）。
- extern——方法定义放在其他地方。

如果使用了override，也可以使用sealed来指定在派生类中不能对这个方法做进一步修改，即这个方法不能由派生类重写。

# 定义属性

《C#入门经典》（第7版） 10.1.3 定义属性

属性的基本结构包括标准的可访问修饰符（public、private等），后跟类名、属性名和get块（或set块），或者get块和set块，其中包含属性处理代码），例如：

~~~c#
public int MyIntProp
{
    get
    {
        // Property get code.
    }
    set
    {
        // Property set code.
    }
}
~~~

> **注意**：.NET中的公共属性也以PascalCasing方式来命名，而不是camelCasing方式命名，与字段和方法一样，这里使用PascalCasing方式。

定义代码中的第一行非常类似于定义字段的代码。区别在于行末没有分号，而是一个包含嵌套 get 和 set 块的代码块。

get 块必须有一个属性类型的返回值，简单属性一般与私有字段相关联，以控制对这个字段的访问，此时 get 块可以直接返回该字段的值。set函数把一个值赋给字段。这里可使用关键字value表示用户提供的属性值：

~~~c#
// Field used by property.
private int myInt;
// Property.
public int MyIntProp
{
    get { return myInt; }
    set { myInt = value; }
}
~~~

属性可以使用 virtual、override 和 abstract 关键字，就像方法一样，但这几个关键字不能用于字段。最后，如上所述，访问器可以有自己的可访问性。

访问器可以使用的访问修饰符取决于属性的可访问性，访问器的可访问性不能高于它所属的属性，也就是说，私有属性对它的访问器不能包含任何可访问修饰符，而公共属性可以对其访问器使用所有的可访问修饰符。

C# 6 引入了一个名为“基于表达式的属性”的功能。类似于第6章讨论的基于表达式的方法，这个功能可以把属性的定义减少为一行代码。例如，下面的属性对一个值进行数学计算，可以使用Lambda箭头后跟等式来定义：

~~~c#
// Field used by property.
private int myDoubledInt = 5;
// Property.
public int MyDoubledIntProp => (myDoubledInt * 2);
~~~

# 自动属性

《C#入门经典》（第7版） 10.1.5 自动属性

对于自动属性，可以用简化的语法声明属性，C#编译器会自动添加未键入的内容。确切地讲，编译器会声明一个用于存储属性的私有字段，并在属性的get和set块中使用该字段，我们不必考虑细节。

~~~c#
public int MyIntProp
{
    get;
    set;
}
~~~

甚至可以在一行代码上定义自动属性，以便节省空间，而不会过度地降低属性的可读性：

~~~c#
public int MyIntProp { get; set; }
~~~

C# 引入了两个与自动属性相关的新概念：只有get存取器的自动属性，和自动属性的初始化器。

# 隐藏基类方法

《C#入门经典》（第7版） 10.2.1 隐藏基类方法 10.2.2 调用重写或隐藏的基类方法

如果确实要隐藏该成员，就可以使用new关键字显式地表明意图：

~~~c#
public class MyDerivedClass : MyBaseClass
{
    new public void DoSomething()
    {
        // Derived class implementation, hides base implementation.
    }
}
~~~

可以使用base关键字，它表示包含在派生类中的基类的实现代码（在控制构造函数时，其用法是类似的，如第9章所述），例如：

~~~c#
public class MyBaseClass
{
    public virtual void DoSomething()
    {
        // Base implementation.
    }
}
public class MyDerivedClass : MyBaseClass
{
    public override void DoSomething()
    {
        // Derived class implementation, extends base class implementation.
        base.DoSomething();
        // More derived class implementation.
    }
}
~~~

因为base使用的是对象实例，所以在静态成员中使用它会产生错误。

this关键字引用的是当前的对象实例（即不能在静态成员中使用this关键字，因为静态成员不是对象实例的一部分）。

# 嵌套类

《C#入门经典》（第7版） 10.2.3 嵌套的类型定义

~~~c#
public class MyClass
{
    public class MyNestedClass
    {
        public int NestedClassField;
    }
}
~~~

嵌套类可以访问其包含类的私有和受保护成员。

# 代码分组

《C#入门经典》（第7版） 10.4 部分类定义

#region XXX

#endregion

# 部分类

《C#入门经典》（第7版） 10.4 部分类定义

使用部分类定义，把类的定义放在多个文件中。例如，可将字段、属性和构造函数放在一个文件中，而把方法放在另一个文件中。为此，在包含部分类定义的每个文件中对类使用partial关键字即可

# 部分方法

《C#入门经典》（第7版） 10.5 部分方法定义

部分类也可以定义部分方法（partial method）。部分方法在一个部分类中定义（没有方法体），在另一个部分类中实现。在这两个部分类中，都要使用partial关键字。

部分方法也可以是静态的，但它们总是私有的，且不能有返回值。它们使用的任何参数都不能是out参数，但可以是ref参数。部分方法也不能使用virtual、abstract、override、new、sealed和extern修饰符。