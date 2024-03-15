在[序章](./函数式编程和设计模式（序章）.md)中，我们提到了策略模式、模板模式、观察者模式、责任链模式和工厂模式可以使用 Java 8 中的 Lambda 和方法引用来简化书写。这些都是在**《设计模式：可复用面向对象软件基础（Design Patterns: Elements of Reusable Object-Oriented Software）》**一书中最早提出的 23 个设计模式之中。因为该书的作者为四位，所以人称“四人组”即 **GoF**（Gang of Four）。接下来，我们将讨论其他的 GoF 设计模式中的几个也可以使用函数式编程简化或者优化的设计模式。

首先我们会详细介绍三个 GoF 设计模式：我们先看**装饰器模式**，然后将讨论**访问者模式**，最后会介绍**命令模式**。其中装饰器模式在 Java 8 和 Scala 中均可以简化，但 Scala 中书写较为简洁；访问者模式则是在 Java 和 Scala 语言中针对扩展问题提供相应方便扩展的实现，可以作为访问者模式的补充知识；命令模式则也是可以使用 Scala 和 Java 8 进行简化。

在文章末尾我们将对在函数式编程得到较多运用的现在，可以有新的实现的 GoF 设计模式们做一个整体的总结。

# 1 装饰器模式

## 1.1 装饰器模式简介

**装饰器模式**（Decorator Pattern），也称为装饰模式，其定义为：

> 动态地给一个对象添加一些额外的职责。就增加功能来说，装饰模式相比生成子类更为灵活。

装饰器模式中主要有四个角色：

- **Component 抽象构件**：Component 是一个接口或者是抽象类，就是定义我们最核心的对象，也就是最原始的对象。
- **ConcreteComponent 具体构件**：ConcreteComponent 是最核心、最原始、最基本的接口或抽象类的实现，你要装饰的就是它。
- **Decorator 装饰角色**：一般是一个抽象类，并维持一个指向 Component 对象的指针（在它的属性里必然有一个 private 变量指向 Component 抽象构件）。
- **ConcreteDecorator 具体装饰角色**：具体的装饰类，向组件添加职责。你要把你最核心的、最原始的、最基本的东西装饰成其他东西。

对应的 Java 代码如下：

```java
// 抽象构件
public abstract class Component {
    // 抽象方法
    public abstract void operate();
}

// 具体构件
public class ConcreteComponent extends Component {
    // 具体实现
    @Override
    public void operate() {
        System.out.println("do Something");
    }
}

// 抽象装饰者
public abstract class Decorator extends Component {
    private Component component = null;
    // 通过构造函数传递被修饰者
    public Decorator(Component _component) {
        this.component = _component;
    }
    // 委托给被修饰者执行
    @Override
    public void operate() {
        this.component.operate();
    }
}

// 具体装饰类
// 可以有多个，我们假设其类名为 ConcreteDecorator1\2\...
public class ConcreteDecorator extends Decorator {
    // 定义被修饰者
    public ConcreteDecorator(Component _component) {
        super(_component);
    }
    // 定义自己的修饰方法
    private void method1() {
        System.out.println("method1 修饰");
    }
    // 重写父类的 operate 方法
    @Override
    public void operate() {
        this.method1();
        super.operate();
    }
}

// 使用场景
public class void main(String[] args) {
    Component component = new ConcreteComponent();
    // 第一次修饰
    component = new ConcreteDecorator1(component);
    // 第二次修饰
    component = new ConcreteDecorator2(component);
    // 修饰后运行
    component.operate();
}
```

装饰模式降低了系统的耦合度，可以动态增加或删除对象的职责，并使得需要装饰的具体构件类和具体装饰类可以独立变化，以便增加新的具体构件类和具体装饰类。在软件开发中，装饰模式应用较为广泛，例如在 Java IO 中的输入流和输出流的设计、javax.swing 包中一些图形界面构件功能的增强等地方都运用了装饰模式。 

装饰模式的主要**优点**如下： 

1. 对于扩展一个对象的功能，装饰模式比继承更加灵活性，不会导致类的个数急剧增加。 
2. 可以通过一种动态的方式来扩展一个对象的功能，通过配置文件可以在运行时选择不同的具体装饰类，从而实现不同的行为。 
3. 可以对一个对象进行多次装饰，通过使用不同的具体装饰类以及这些装饰类的排列组合，可以创造出很多不同行为的组合，得到功能更为强大的对象。
4. 具体构件类与具体装饰类可以独立变化，用户可以根据需要增加新的具体构件类和具体装饰类，原有类库代码无须改变，符合“开闭原则”。 

装饰模式的主要**缺点**如下： 

1) 使用装饰模式进行系统设计时将产生很多小对象，这些对象的区别在于它们之间相互连接的方式有所不同，而不是它们的类或者属性值有所不同，大量小对象的产生势必会占用更多的系统资源，在一定程序上影响程序的性能。 
2) 装饰模式提供了一种比继承更加灵活机动的解决方案，但同时也意味着比继承更加易于出错，排错也很困难，对于多次装饰的对象，调试时寻找错误可能需要逐级排查，较为繁琐。 

## 1.2 传统的 Java 实现示例：日志计算器

让我们考虑这样一个装饰模式的应用场景：

我们有一个处理四则运算计算器，该计算器有四个操作：`add()`、`substract()`、`multiply()` 和 `divide()`。我们将使用装饰器模式来给这个基础的计算器添加日志功能，它可以将我们的计算过程展示在控制台。

传统的 Java 实现：

```java
// 抽象构件
public interface Calculator {
    int add(int a, int b);
    int substract(int a, int b);
    int multiply(int a, int b);
    int divide(int a, int b);
}

// 具体构件
public class CalculatorImpl implements Calculator {
    @Override
    public int add(int a, int b) {
        return a + b;
    }
	@Override
    public int substract(int a, int b) {
        return a - b;
    }
	@Override
    public int multiply(int a, int b) {
        return a * b;
    }
	@Override
    public int divide(int a, int b) {
        return a / b;
    }
}

// 抽象装饰者
public abstract class LoggingCalculator implements Calculator {
    private Calculator calculator = null;

    public LoggingCalculator(Calculator _calculator) {
        this.calculator = _calculator;
    }

    @Override
    public int add(int a, int b) {
        return this.caculator.add(a, b);
    }
	@Override
    public int substract(int a, int b) {
        return this.caculator.substract(a, b);
    }
	@Override
    public int multiply(int a, int b) {
        return this.caculator.multiply(a, b);
    }
	@Override
    public int divide(int a, int b) {
        return this.caculator.divide(a, b);
    }
}

// 具体装饰类
public class LoggingCalculatorImpl extends LoggingCalculator {
    public LoggingCalculatorImpl(Calculator _calculator) {
        super(_calculator);
    }

    private void logging(int result) {
        System.out.println("Result is: " + result);
    }

    @Override
    public int add(int a, int b) {
        int result = super.add(a, b);
        logging(result);
        return result;
    }
	@Override
    public int substract(int a, int b) {
        int result = super.add(a, b);
        logging(result);
        return result;
    }
	@Override
    public int multiply(int a, int b) {
        int result = super.add(a, b);
        logging(result);
        return result;
    }
	@Override
    public int divide(int a, int b) {
        int result = super.add(a, b);
        logging(result);
        return result;
    }
}
```

可以看出重复代码还是挺多的。

## 1.3 使用函数式编程简化日志计算器的实现

我们可以考虑使用 Lambda 和方法引用，将四个四则运算方法直接作为方法引用参数，传递给日志记录的方法；通过这种方式，实现装饰器模式，代码如下：

```java
public class Example {
    public static int add(int a, int b) {
        return a + b;
    }

    public static int substract(int a, int b) {
        return a - b;
    }

    public static int multiply(int a, int b) {
        return a * b;
    }

    public static int divide(int a, int b) {
        return a / b;
    }

    public static BiFunction<Integer, Integer, Integer> makeLogger(BiFunction<Integer, Integer, Integer> calcFn){
        return (a, b) -> {
            Integer result = calcFn.apply(a, b);
            System.out.println("Result is: " + result);
            return result;
        };
    }
}

// 使用场景
BiFunction<Integer, Integer, Integer> loggingAdd = Example.makeLogger(Example::add);
        BiFunction<Integer, Integer, Integer> loggingSubstract = Example.makeLogger(Example::substract);
        BiFunction<Integer, Integer, Integer> loggingMultiply = Example.makeLogger(Example::multiply);
        BiFunction<Integer, Integer, Integer> loggingDivide = Example.makeLogger(Example::divide);

loggingAdd.apply(1, 2);
loggingSubstract.apply(1, 2);
```

使用 Scala 实现的代码将更加简洁，主要体现在 Java 中的 `BiFunction<Integer, Integer, Integer>` 可以直接简写为 Scala 的 `(Int, Int) => Int`，以及 Java 的 `apply` 也可以在 Scala 调用时省略掉：

```scala
object Example {
    def add(a: Int, b: Int) = a + b
    def substract(a: Int, b: Int) = a - b
    def multiply(a: Int, b: Int) = a * b
    def divide(a: Int, b: Int) = a / b

    def makeLogger(calcFn: (Int, Int) => Int) =
        (a: Int, b: Int) => {
            val result = calcFn(a, b)
            println("Result is: " + result)
            result
        }
}

// 使用场景
val loggingAdd: (Int, Int) => Int = Example.makeLogger(Example.add)
val loggingSubstract: (Int, Int) => Int = Example.makeLogger(Example.substract)
val loggingMultiply: (Int, Int) => Int = Example.makeLogger(Example.multiply)
val loggingDivide: (Int, Int) => Int = Example.makeLogger(Example.divide)

loggingAdd(1, 2)
loggingSubstract(1, 2)
```

# 2 访问者模式

下面我们还是先回顾一下访问者模式，然后结合案例具体介绍 Scala 和 Java 中方便扩展的实现方法。

## 2.1 访问者模式简介

**访问者模式**（Visitor Pattern）是一个相对简单的模式，其定义如下：

> 封装一些作用于某种数据结构中的各元素的操作，它可以在不改变数据结构的前提下定义作用于这些元素的新的操作。

访问者模式具有以下几个角色：

- **Visitor 抽象访问者**：抽象类或者接口，声明访问者可以访问哪些元素，具体到程序中就是visit方法的参数定义哪些对象是可以被访问的。
- **ConcreteVisitor 具体访问者**：它影响访问者访问到一个类后该怎么干，要做什么事情。 
- **Element 抽象元素**：接口或者抽象类，声明接受哪一类访问者访问，程序上是通过accept方法中的参数来定义的。
- **ConcreteElement 具体元素**：实现 accept 方法，通常是 visitor.visit(this)，基本上都形成了一种模式了。
- **ObjectStruture 结构对象**：元素产生者，一般容纳在多个不同类、不同接口的容器，如List、Set、Map等，在项目中，一般很少抽象出这个角色。 

对应的 Java 代码如下：

```java
// 抽象元素
public abstract class Element {
    // 定义业务逻辑
    public abstract void doSomething();
    // 允许谁来访问
    public abstract void accept(IVisitor visitor);
}

// 具体元素
// 可以有多个实现类: ConcreteElement1/2/...
public class ConcreteElement extends Element {
    @Override
    public void doSomething() {
        // 业务处理
    }
    @Override
    public void accept(IVisitor visitor) {
        visitor.visit(this);
    }
}

// 抽象访问者
public interface IVisitor {
    // 可以访问哪些对象
    public void visit(ConcreteElement el);
    // ... 可以有多个 visit 方法，对应不同的 ConcreteElement1/2/...
}

// 具体访问者
public class Vistor implements IVisitor {
    // 访问 el 元素
    @Override
    public void visit(ConcreteElement el) {
        el.doSomething();
    }
    // ... 同样可能有多个实现方法
}

// 结构对象
public class ObjectStructure {
    // 对象生成器
    public static Element createElement() {
        // ...
    }
}

// 使用场景
Element el = ObjectStructure.createElement();
el.accept(new Visitor());
```

由于访问者模式的使用条件较为苛刻，本身结构也较为复杂，因此在实际应用中使用频率不是特别高。当系统中存在一个较为复杂的对象结构，且不同访问者对其所采取的操作也不相同时，可以考虑使用访问者模式进行设计。在XML文档解析、编译器的设计、复杂集合对象的处理等领域访问者模式得到了一定的应用。

访问者模式的主要**优点**如下： 

1) 增加新的访问操作很方便。使用访问者模式，增加新的访问操作就意味着增加一个新的具体访问者类，实现简单，无须修改源代码，符合“开闭原则”。 
2) 将有关元素对象的访问行为集中到一个访问者对象中，而不是分散在一个个的元素类中。类的职责更加清晰，有利于对象结构中元素对象的复用，相同的对象结构可以供多个不同的访问者访问。
3) 让用户能够在不修改现有元素类层次结构的情况下，定义作用于该层次结构的操作。 

访问者模式的主要**缺点**如下： 

1) 增加新的元素类很困难。在访问者模式中，每增加一个新的元素类都意味着要在抽象访问者角色中增加一个新的抽象操作，并在每一个具体访问者类中增加相应的具体操作，这违背了“开闭原则”的要求。
2) 破坏封装。访问者模式要求访问者对象访问并调用每一个元素对象的操作，这意味着元素对象有时候必须暴露一些自己的内部操作和内部状态，否则无法供访问者访问。

## 2.2 Scala 中的扩展访问者模式示例：可扩展的几何形状

上面可以看出，访问者模式面对的缺点有一点就是：增加新的元素类和新的操作很困难。如果是直接去修改原有的类，就违反了“开闭原则”。

> **开闭原则**(Open-Closed Principle, OCP)：一个软件实体应当对扩展开放，对修改关闭。即软件实体应尽量在不修改原有代码的情况下进行扩展。 

这一点在 Scala 中，通过特质（trait）可以较好的解决。

下面我们举的示例将先定义两个形状：圆形和矩形，以及计算它们周长的操作。然后将展示如何为既有的周长计算操作添加新的可支持的形状，以及如何为既有的形状添加新的操作。最后将这两种类型的扩展合并起来。

首先，最初的 Shape 特质和两个实现的 Scala 代码如下：

```scala
trait PerimeterShapes {
  trait Shape {
    def perimeter: Double
  }

  class Circle(radius: Double) extends Shape {
    override def perimeter: Double = 2 * Math.PI * radius
  }

  class Rectangle(width: Double, height: Double) extends Shape {
    override def perimeter: Double = 2 * width + 2 * height
  }
}
```

为了扩展求面积的操作，我们可以这样使用特质来扩展：创建顶层的特质 AreaShapes 扩展于 PerimeterShapes。内部创建了一个新的 Shape 特质，并让它扩展了 PerimeterShapes 中那个老的 Shape 特质。

然后再扩展老的 Circle 和 Rectangle 类，将它们混入新的 Shape 特质，该特质拥有新的 `area()` 方法

```scala
trait AreaShapes extends PerimeterShapes {
  trait Shape extends super.Shape {
    def area: Double
  }

  class Circle(radius: Double) extends super.Circle(radius) with Shape {
    override def area: Double = Math.PI * radius * radius
  }

  class Rectangle(width: Double, height: Double) extends super.Rectangle(width, height) with Shape {
    override def area: Double = width * height
  }
}
```

然后假如我们要添加新的图形——正方形 Square 类的话，也可以按照类似的逻辑扩展：

```scala
trait MorePerimeterShapes extends PerimeterShapes {
  class Square(side: Double) extends Shape {
    override def perimeter: Double = 4 * side
  }
}

trait MoreAreaShapes extends AreaShapes with MorePerimeterShapes {
  class Square(side: Double) extends super.Square(side) with Shape {
    def area = side * side
  }
}
```

这样，我们就可以为 Shape 添加新的实现和新的操作，而且我们所采用的是一种类型安全的方式。

## 2.3 Java 中的扩展访问者模式示例

针对上面的例子，我们也可以很容易得到对应的 Java 代码：

```java
interface PerimeterShapes {
    interface Shape {
        double perimeter();
    }

    class Circle implements Shape {
        private double radius;

        public Circle(double radius) {
            this.radius = radius;
        }

        @Override
        public double perimeter() {
            return 2 * Math.PI * radius;
        }
    }

    class Rectangle implements Shape {
        private double width;
        private double height;

        public Rectangle(double width, double height) {
            this.width = width;
            this.height = height;
        }

        @Override
        public double perimeter() {
            return 2 * width + 2 * height;
        }
    }
}

interface AreaShapes extends PerimeterShapes {
    interface Shape extends PerimeterShapes.Shape {
        double area();
    }

    class Circle extends PerimeterShapes.Circle implements Shape{

        public Circle(double radius) {
            super(radius);
        }

        @Override
        public double area() {
            return Math.PI * super.radius * super.radius;
        }
    }

    class Rectangle extends PerimeterShapes.Rectangle implements Shape{

        public Rectangle(double width, double height) {
            super(width, height);
        }

        @Override
        public double area() {
            return super.width * super.height;
        }
    }
}

interface MorePerimeterShapes extends PerimeterShapes {
    class Square implements Shape {
        private double side;

        public Square(double side) {
            this.side = side;
        }

        @Override
        public double perimeter() {
            return 4 * side;
        }
    }
}

interface MoreAreaShapes extends AreaShapes, MorePerimeterShapes {
    class Square extends MorePerimeterShapes.Square implements Shape {
        public Square(double side) {
            super(side);
        }

        @Override
        public double area() {
            return super.side * super.side;
        }
    }
}
```

本来希望可以使用 Java 16 正式引入的 record 新特性来简化书写的，但是发现 record 无法继承，只能还是使用 class 的语法啦。

> 需要注意的一个细节是，Java 的接口是可以 extends 多个接口的，是多继承的，和类不太一样。

通过这种方式去使用访问者模式，我们就可以保证访问者模式在不违反开闭原则的情况下进行扩展了。

# 3 命令模式

## 3.1 命令模式简介

**命令模式**（Command Pattern）是一个高内聚的模式，其定义为：

> 将一个请求封装成一个对象，从而让你使用不同的请求把客户端参数化，对请求排队或者记录请求日志，可以提供命令的撤销和恢复功能。

命令模式有三个角色：

- **Receive 接收者角色**：该角色就是干活的角色，命令传递到这里是应该被执行的。
- **Command 命令角色**：需要执行的所有命令都在这里声明。
- **Invoker 调用者角色**：接收到命令，并执行命令。

对应 Java 代码如下：

```java
// 通用接收者
public abstract class Receiver {
    // 抽象接收者，定义每个接收者都必须完成的业务
    public abstract void doSomething();
}

// 具体的接收者（可以有多个：ConcreteReceiver1/2/...）
public class ConcreteReceiver extends Receiver {
    // 每个接收者都必须处理一定的业务逻辑
    public void doSomething() {
        // ...
    }
}

// 抽象的命令
public abstract class Command {
    // 每个命令类都必须有一个执行命令的方法
    public abstract void execute();
}

// 具体的命令（有多个：ConcreteCommand1/2/...）
public class ConcreteCommand extends Command {
    // 对哪个 Receiver 类进行命令处理
    private Receiver receiver;
    // 构造函数传递接收者
    public ConcreteCommand(Receiver _receiver) {
        this.receiver = _receiver;
    }
    // 必须实现一个命令
    public void execute() {
        // 业务处理
        this.receiver.doSomething();
    }
}

// 调用者
public class Invoker {
    private Command command;
    // 接受命令
    public void setCommand(Command _command) {
        this.command = _command;
    }
    // 执行命令
    public void action() {
        this.command.execute();
    }
}

// 使用场景
Invoker invoker = new Invoker();
Receiver receiver = new ConcreteReceiver();
Command command = new ConcreteCommand(receiver);
invoker.setCommand(command);
invoker.action();
```

命令模式是一种使用频率非常高的设计模式，它可以将请求发送者与接收者解耦，请求发送者通过命令对象来间接引用请求接收者，使得系统具有更好的灵活性和可扩展性。在基于 GUI 的软件开发，无论是在电脑桌面应用还是在移动应用中，命令模式都得到了广泛的应用。 

命令模式的主要**优点**如下： 

1. 降低系统的耦合度。由于请求者与接收者之间不存在直接引用，因此请求者与接收者之间实现完全解耦，相同的请求者可以对应不同的接收者，同样，相同的接收者也可以供不同的请求者使用，两者之间具有良好的独立性。 
2. 新的命令可以很容易地加入到系统中。由于增加新的具体命令类不会影响到其他类，因此增加新的具体命令类很容易，无须修改原有系统源代码，甚至客户类代码，满足“开闭原则”的要求。
3. 可以比较容易地设计一个命令队列或宏命令（组合命令）。
4. 为请求的撤销（Undo）和恢复（Redo）操作提供了一种设计和实现方案。 

命令模式的主要**缺点**如下： 

使用命令模式可能会导致某些系统有过多的具体命令类。因为针对每一个对请求接收者的调用操作都需要设计一个具体命令类，因此在某些系统中可能需要提供大量的具体命令类，这将影响命令模式的使用。 

## 3.2 传统的 Java 实现示例：现金出纳机

我们将先使用传统的 Java 面向对象方式实现一个简单的现金出纳机。这个出纳机的功能非常简单：它只处理整额的美元，同时包含了一定总量的现金，并且只允许将现金增加到出纳机。我们将保存一份事务日志，以方便对操作进行重放。

代码如下：

```java
// 具体的接收者
public class CashRegister {
    private int total;

    public void addCash(int toAdd) {
        total += toAdd;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }
}

// 抽象的命令
public abstract class Command {
    public abstract void execute();
}

// 具体的命令
public class Purchase extends Command {
    private final CashRegister register;
    private final int amount;

    public Purchase(CashRegister register, int amount) {
        this.register = register;
        this.amount = amount;
    }

    @Override
    public void execute() {
        System.out.println("Purchase in amount: " + amount);
        this.register.addCash(amount);
    }
}

// 调用者
public class PurchaseInvoker {
    private List<Command> purchases = new LinkedList<>();

    public void executePurchase(Command purchase) {
        purchases.add(purchase);
        purchase.execute();
    }

    public List<Command> getPurchases() {
        return purchases;
    }
}

// 应用场景
CashRegister register = new CashRegister();
Purchase purchaseOne = new Purchase(register, 100);
Purchase purchaseTwo = new Purchase(register, 50);
PurchaseInvoker invoker = new PurchaseInvoker();
invoker.executePurchase(purchaseOne);
invoker.executePurchase(purchaseTwo);
System.out.println(register.getTotal());
register.setTotal(0);
for (Command purchase : invoker.getPurchases()) {
    purchase.execute();
}
System.out.println(register.getTotal());
```

## 3.3 使用函数式编程简化现金出纳机的实现

在 Java 中，我们可以考虑使用 Lambda 函数式编程省略掉中间的 Command 抽象类的声明。CashRegister 类依然保持不变，Command 抽象类、Purchase 实现类和 PurchaseInvoker 调用类则都被简略成了方法。具体代码如下：

```java
// 省略 CashRegister 的定义，和之前一致

public Runnable makePurchase(CashRegister register, int amount) {
    return () -> {
        System.out.println("Purchase in amount: " + amount);
        register.addCash(amount);
        // Runnable 改为 Supplier<Void> 的话，这里要加 return null;
    };
}

final List<Runnable> purchases = new LinkedList<>();

public void executePurchase(Runnable purchase) {
    purchases.add(purchase);
    purchase.run();
}

// 应用场景
CashRegister register = new CashRegister();
Runnable purchaseOne = makePurchase(register, 100);
Runnable purchaseTwo = makePurchase(register, 50);
executePurchase(purchaseOne);
executePurchase(purchaseTwo);
System.out.println(register.getTotal());
register.setTotal(0);
for (Runnable purchase : purchases) {
    purchase.run();
}
System.out.println(register.getTotal());
```

这里因为 Java 并没有自带表示 void -> void 方法的类型，我们使用 `Runnable` 代表（你用 `Callable` 之类的满足 @FunctionalInterface 注解条件的单个 void -> void 抽象方法的接口也可以啦，只是不管哪种方式，可读性上都会比较迷惑。也可以使用 `Supplier<Void>` 的方式，但这样我们需要多加一行 `return null;` 的代码）。

对应到 Scala 中，我们就没有这么多阅读语义上纠结的问题了，代码如下：

```scala
class CashRegister(var total: Int) {
  def addCash(toAdd: Int) = total += toAdd
}

def makePurchase(register: CashRegister, amount: Int) = () => {
  println("Purchase in amount: " + amount)
  register.addCash(amount)
}

var purchases: Vector[() => Unit] = Vector()

def executePurchase(purchase: () => Unit): Unit = {
  purchases = purchases :+ purchase
  purchase()
}

// 应用场景
val register = new CashRegister(0)
val purchaseOne = makePurchase(register, 100)
val purchaseTwo = makePurchase(register, 50)
executePurchase(purchaseOne)
executePurchase(purchaseTwo)
println(register.total)
register.total = 0
for (purchase <- purchases) purchase()
println(register.total)
```

其中 `purchase()` 就代表了对 purchase 这个 `() => Unit` 的方法引用执行 `purchase.apply()`。而 `() => Unit` 也就表达了 Java 中的 `void -> void` 的语义。

# 4 总结

经过以上三个示例，以及之前序章中的五个示例，我们可以大概观察到一些特点。本质上，这些简化其实就是通过方法引用本身的抽象，来代替了许多设计模式中声明的抽象类/接口。从而我们省去了声明新的类型的烦琐工作。

这里我们使用函数式编程的方式简化设计模式有可能带来的问题是：代码运行时的语义上可能相对模糊了一些，因为无法再通过类名来判断设计模式了。但是我们仍然可以通过变量名称等方式保证程序员阅读时的可读性。

经过这么两篇文章的介绍，我们可以了解到一些传统 GoF 设计模式在函数式编程中的新实践。接下来，我将给大家介绍依赖注入在 Scala 中的 Cake 模式实现以及一些函数式编程独有的设计模式，敬请期待。




![GitHub](https://img.shields.io/badge/GitHub-ZeromaXHe-lightgrey?style=flat-square&logo=GitHub)![Gitee](https://img.shields.io/badge/Gitee-zeromax-red?style=flat-square&logo=Gitee)![LeetCodeCN](https://img.shields.io/badge/LeetCodeCN-ZeromaX-orange?style=flat-square&logo=LeetCode)![Weixin](https://img.shields.io/badge/%E5%85%AC%E4%BC%97%E5%8F%B7-ZeromaX%E8%A8%B8%E7%9A%84%E6%97%A5%E5%B8%B8-brightgreen?style=flat-square&logo=WeChat)![Zhihu](https://img.shields.io/badge/%E7%9F%A5%E4%B9%8E-maX%20Zero-blue?style=flat-square&logo=Zhihu)![Bilibili](https://img.shields.io/badge/Bilibili-ZeromaX%E8%A8%B8-lightblue?style=flat-square&logo=Bilibili)![CSDN](https://img.shields.io/badge/CSDN-SquareSquareHe-red?style=flat-square)