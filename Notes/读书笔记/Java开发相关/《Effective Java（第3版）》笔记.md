# Effective Java（第三版）笔记

## 第1章 引言

Java语言支持四种类型：接口（包括注释）、类（包括enum）、数组和基本类型。前三种类型通常被称为引用类型（reference type），类实例和数组是对象（object），而基本类型的值不是对象。

本书不再使用“接口继承”这种说法，而是简单地说，一个类实现（implement）了一个接口，或者一个接口扩展（extend）了另一个接口。

## 第2章 创建和销毁对象

### 第1条 用静态工厂方法代替构造器

对于类而言，为了让客户端获取它自身的一个实例，最传统的方法就是提供一个公有的构造器。还有一种方法，也应该在每个程序员的工具箱中占有一席之地。类可以提供一个共有的静态工厂方法（static factory method），它只是一个返回类的实例的静态方法。下面是一个来自Boolean（基本类型boolean的装箱类）的简单示例。这个方法将boolean基本类型值转换成了一个Boolean对象引用：

~~~java
public static Boolean valueOf(boolean b){
    return b? Boolean.TRUE: Boolean.FALSE;
}
~~~

注意，静态工厂方法与设计模式中的工厂方法（Factory Method）模式不同。本条目中所指的静态工厂方法并不直接对应于设计模式（Pattern Design）中的工厂方法。

如果不通过共有的构造器，或者说除了共有的构造器外，类还可以给它的客户端提供静态工厂方法。提供静态工厂方法而不是公有的构造器，这样做既有优势，也有劣势。

**静态工厂方法与构造器不同的第一大优势在于，它们有名称。** 如果构造器的参数本身没有确切地描述正被返回的对象，那么具有恰当名称的静态工厂会更容易使用，产生的客户端代码也更易阅读。例如，构造器BigInteger(int, int, Random)返回的BigInteger可能为素数，如果用名叫BigInteger.probablePrime的静态工厂方法来表示，显然更为清楚。（Java4版本中增加了这个方法。）

一个类只能有一个带有指定签名的构造器。编程人员通常知道如何避开这一限制：通过提供两个构造器，它们的参数列表只在参数类型的顺序上有所不同。实际上这并不是个好主意。面对这样的API，用户永远也记不住该用哪个构造器，结果常常会调用错误的构造器。并且在读到使用了这些构造器的代码时，如果没有参考类的文档，往往不知所云。

由于静态工厂方法有名称，所以它们不受上述限制。当一个类需要多个带有相同签名的构造器时，就用静态工厂方法代替构造器，并且仔细地选择名称以便突出静态工厂方法之间的区别。

**静态工厂方法与构造器不同的第二大优势在于，不必在每次调用它们的时候都创建一个新对象。** 这使得不可变类（详见第17条）可以使用预先构建好的实例，或者将构建好的实例缓存起来，进行重复利用，从而避免创建不必要的重复对象。Boolean.valueOf(boolean)方法说明了这项技术：它从来不创建对象。这种方法类似于享元（Flyweight）模式。如果程序经常请求创建相同的对象，并且创建对象的代价很高，则这项技术可以极大地提升性能。

静态工厂方法能够为重复的调用返回相同对象，这样有助于类总能严格控制在某个时刻哪些实例应该存在。这种类被称作*实例受控的类*（instance-controlled）。编写实例受控的类有几个原因。实例受控使得类可以确保它是一个Singleton（详见第3条）或者是不可实例化的（详见第4条）。它还使得不可变的值类（详见第17条）可以确保不会存在两个相等的实例，即当且仅当a==b时，a.equals(b)才为true。这是*享元*模式的基础。枚举（enum）类型（详见第34条）保证了这一点。

**静态工厂方法与构造器不同的第三大优势在于，它们可以返回原返回类型的任何子类型的对象。** 这样我们在选择返回对象的类时就有了更大的灵活性。

这种灵活性的一种应用是，API可以返回对象，同时又不会使对象的类变成公有的。以这种方式隐藏实现类会使API变得非常简洁。这项技术适用于*基于接口的框架*（interface based framework）（详见第20条），因为在这种框架中，接口为静态工厂方法提供了自然返回类型。

在Java 8之前，接口不能有静态方法，因此按照惯例，接口Type的静态工厂方法被放在一个名为Types的*不可实例化的伴生类*（详见第4条）中。例如，Java Collections Framework的集合接口有45个工具实现，分别提供了不可修改的集合、同步集合，等等。几乎所有这些实现都通过静态工厂方法在一个不可实例化的类（java.util.Collections）中导出。所有返回对象的类都是非共有的。

现在的Collections Framework API比导出45个独立共有类的那种实现方式要小得多，每种便利实现都对应一个类。这不仅仅是指API数量上的减少，也是*概念意义*上的减少：为了使用这个API，用户必须掌握的概念在数量和难度上都减少了。程序员知道，被返回的对象是由相关的接口精确指定的，所以他们不需要阅读有关的类文档。此外，使用这种静态工厂方法时，甚至要求客户端通过接口来引用被返回的对象，而不是通过它的实现类来引用被返回的对象，这是一种良好的习惯（详见64条）。

从Java 8版本开始，接口中不能包含静态方法的这一限制成为历史，因此一般没有任何理由给接口提供一个不可实例化的伴生类。已经被放在这种类中的许多公有的静态成员，应该被放到接口中去。但是要注意，仍然有必要将这些静态方法背后的大部分实现代码，单独放进一个包级私有的类中。这是因为在Java 8中仍要求接口的所有静态成员都必须是公有的。在Java 9中允许接口有私有的静态方法，但是静态域和静态成员类仍然需要是公有的。

**静态工厂的第四大优势在于，所返回的对象的类可以随着每次调用而发生变化，这取决于静态工厂方法的参数值。** 只要是已声明的返回类型的子类型，都是允许的。返回对象的类也可能随着发行版本的不同而不同。

EnumSet（详见第36条）没有公有的构造器，只有静态工厂方法。在OpenJDK实现中，它们返回两种子类之一的一个实例，具体则取决于底层枚举类型的大小：如果它的元素有64个或者更少，就像大多数枚举类型一样，静态工厂方法就会返回一个RegularEnumSet实例，用单个long进行支持；如果枚举类型有65个或者更多元素，工厂就返回JumboEnumSet实例，用一个long数组进行支持。

这两个实现类的存在对于客户端来说是不可见的。如果RegularEnumSet不能再给小的枚举类型提供性能优势，就可能从未来的发行版本中将它删除，不会造成任何负面的影响。同样地，如果事实证明对性能有好处，也可能在未来的发行版本中添加第三甚至第四个EnumSet实现。客户端永远不知道也不关心它们从工厂方法中得到的对象的类，它们只关心它是EnumSet的某个子类。

**静态工厂的第五大优势在于，方法返回的对象所属的类，在编写包含该静态工厂方法的类时可以不存在。** 这种灵活的静态工厂方法构成了*服务提供者框架*（Service Provider Framework）的基础，例如JDBC（Java数据库连接）API。服务提供者框架是指这样一个系统：多个服务提供者实现一个服务，系统为服务提供者的客户端提供多个实现，并把它们从多个实现中解耦出来。

服务提供者框架中有三个重要的组件：*服务接口*（Service Interface），这是提供者实现的；*提供者注册API*（Provider Registration API），这是提供者用来注册实现的；*服务访问API*（Service Access API），这是客户端用来获取服务的实例。服务访问API是客户端用来指定某种选择实现的条件。如果没有这样的规定，API就会返回默认实现的一个实例，或者允许客户端遍历所有可用的实现。服务访问API是“灵活的静态工厂”，它构成了服务提供者框架的基础。

服务提供者框架的第四个组件*服务提供者接口*（Service Provider Interface）是可选的，它表示产生服务接口之实例的工厂对象。如果没有服务提供者接口，实现就通过反射方式进行实例化（详见第65条）。对于JDBC来说，Connection就是其服务接口的一部分，DriverManager.registerDriver是提供者注册API，DriverManager.getConnection是服务访问API，Driver是服务提供者接口。

服务提供者框架模式有着无数种变体。例如，服务访问API可以返回比提供者需要的更丰富的服务接口。这就是*桥接*（Bridge）模式。依赖注入框架（详见第5条）可以被看做是一个强大的服务提供者。从Java 6版本开始，Java平台就提供了一个通用的服务提供者框架java.util.ServiceLoader，因此你不需要（一般来说也不应该）再自己编写了（详见第59条）。JDBC不用ServiceLoader，因此前者出现得比后者早。

**静态工厂方法的主要缺点在于，类如果不含公有的或者受保护的构造器，就不能被子类化。** 例如，要想将Collections Framework中的任何便利的实现类子类化，这是不可能的。但是这样也许会因祸得福，因为它鼓励程序员使用复合（composition），而不是继承（详见第18条），这正是不可变类型所需要的（详见第17条）。

**静态工厂方法的第二个缺点在于，程序员很难发现它们。** 在API文档中，它们没有像构造器那样在API文档中明确标识出来，因此，对于提供了静态工厂方法而不是构建器的类来说，要项查明如何实例化一个类是非常困难的。Javadoc工具总有一天会注意到静态工厂方法。同时，通过在类或者接口注释中关注静态工厂，并遵守标准的命名习惯，也可以弥补这一劣势。下面是静态工厂方法的一些惯用名称。这里只列出了其中的一小部分：

- from——类型转换方法，它只有单个参数，返回该类型的一个相对应得实例，例如：`Date d = Date.from(instant);`
- of——聚合方法，带有多个参数，返回该类型得一个实例，把它们合并起来，例如：`Set<Rank> faceCards = EnumSet.of(JACK, QUEEN, KING);`
- valueOf——比from和of更烦琐得一种替代方法，例如：`BigInteger prime = BigInteger.valueOf(Integer.MAX_VALUE);`
- instance或者getInstance——返回得实例是通过方法的（如有）参数来描述的，但是不能说与参数具有同样的值，例如：`StackWalker luke = StackWalker.getInstance(options);`
- create或者newInstance——像instance或者getInstance一样，但create或者newInstance能够确保每次调用都返回一个新的实例，例如：`Object newArray = Array.newInstance(classObject, arrayLen);`
- getType——像getInstance一样，但是在工厂方法处于不同的类中的时候使用。Type表示工厂方法所返回的对象类型，例如：`FileStore fs = Files.getFileStore(path);`
- newType——像newInstance一样，但是在工厂方法处于不同的类中的时候使用。Type表示工厂方法所返回的对象类型，例如：`BufferedReader br = Files.newBufferedReader(path);`
- type——getType和newType的简版，例如：`List<Complaint> litany = Collections.list(legacyLitany);`

简而言之，静态工厂方法和公有构造器都各有用处，我们需要理解它们各自的长处。静态工厂经常更加合适，因此切忌第一反应就是提供公有的构造器，而不先考虑静态工厂。

### 第2条：遇到多个构造器参数时要考虑使用构建器

静态工厂和构造器有个共同的局限性：它们都不能很好地扩展到大量的可选参数。比如用一个类表示包装食品外面显示的营养成分标签。这些标签中有几个域是必需的：每份的含量、每罐的含量以及每份的卡路里。还有超过20个的可选域：总脂肪量、饱和脂肪量、转化脂肪、胆固醇、钠，等等。大多数产品在某几个可选域中都会有非零的值。

对于这样的类，应该用哪种构造器或者静态工厂来编写呢？程序员一向习惯采用*重叠构造器*（ telescoping constructor ）模式，在这种模式下，提供的第一个构造器只有必要的参数，第二个构造器有一个可选参数，第三个构造器有两个可选参数，依此类推，最后一个构造器含所有可选的参数。下面有个示例，为了简单起见，它只显示四个可选域：

~~~java
// Telescoping constructor pattern - does not scale well! 
public class NutritionFacts { 
    private final int servingSize; // (mL〕required
    private final int servings; // (per container）required
    private final int calories; // (per serving) optional
    private final int fat; // (g/serving) optional 
    private final int sodium; // (mg/serving) optional
    private final int carbohydrate; // (g/serving) optional 
    public NutritionFacts (int servingSize int servings) { 
        this (servingSize, servings, 0); 
    }
    public NutritionFacts(int servingSize, int servings, int calories) { 
        this(servingSize, servings, calories, 0) ; 
    }
    public NutritionFacts(int servingSize, int servings, int calories, int fat) { 
        this(servingSize, servings, calories, fat , 0); 
    }
    public NutritionFacts(int servingSize, int servings, int calories, int fat, int sodium) { 
        this(servingSize, servings, calories, fat, sodium, 0);
    }
    public NutritionFacts(int servingSize, int servings, int calories , int fat, int sodium, int carbohydrate) { 
        this.servingSize = servingSize;
        this.servings = servings;
        this calories = calories; 
        this.fat = fat; 
        this.sodium = sodium; 
        this.carbohydrate = carbohydrate;
    }
}
~~~

当你想要创建实例的时候，就利用参数列表最短的构造器，但该列表中包含了要设置的所有参数

这个构造器调用通常需要许多你本不想设置的参数，但还是不得不为它们传递值这个例子中，我们给 fat 传递了一个值为0,如果“仅仅” 是这6个参数，看起来还不算太糟糕，问题是随着参数数目的增加，它很快就失去了控制。

**简而言之，重叠构造器模式可行，但是当有许多参数的时候，客户端代码会很难缩写，并且仍然较难以阅读**。如果读者想知道那些值是什么意思，必须很仔细地数着这些参数来探个究竟。一长串类型相同的参数会导致一些微妙的错误。如果客户端不小心颠倒了其中两个参数的顺序，编译器也不会出错，但是程序在运行时会出现错误的行为（详见第 51 条）。

遇到许多可选的构造器参数的时候，还有第二种代替办法，即 JavaBeans 模式，在这种模式下，先调用一个无参构造器来创建对象，然后再调用 setter 方法来设置每个必要的参数，以及每个相关的可选参数：
~~~java
// JavaBeans Pattern - allows inconsistency, mandates mutability 
public class NutritionFacts { 
    // Parameters initialized to default values (if any)
    private int servingSize = - 1 ; // Required; no default value
    private int servings = -1; // Required; no default value 
    private int calories = 0 ; 
    private int fat = 0; 
    private int sodium = 0; 
    private int carbohydrate = 0; 

    public NutriitionFacts() { } 
    // Setters
    public void setServingSize(int val) { servingSize = val; } 
    public void setServings(int val ) { servings = val; } 
    public void setCalories(int val ) { calories = val; } 
    public void setFat(int val) { fat = val;} 
    public void setSodium(int val) { sodium = val; } 
    public void setCarbohydrate(int val) { carbohydrate = val; } 
}
~~~
这种模式弥补了重叠构造器模式的不足。说得明白一点，就是创建实例很容易，这样产生的代码读起来也很容易：
~~~java
NutritionFacts cocaCola = new NutritionFacts();
cocaCola.setServingSize(240);
cocaCola.setServings(8);
cocaCola.setCalories(100);
cocaCola.setSodium(35);
cocaCola.setCarbohydrate(27);
~~~

遗憾的是， JavaBeans 模式自身有着很严重的缺点。因为构造过程被分到了几个调用中，**在构造过程中 JavaBean 可能处于不一致的状态**。类无法仅仅通过检验构造器参数的有效性来保证一致性。试图使用处于不一致状态的对象将会导致失败，这种失败与包含错误的代码大相径庭，因此调试起来十分困难。与此相关的另一点不足在于， **JavaBeans 模式使得把类做成不可变的可能性不复存在** （详见第 17 条），这就需要程序员付出额外的努力来确保它的线程安全。

当对象的构造完成，并且不允许在冻结之前使用时，通过手工“冻结”对象可以弥补这些不足，但是这种方式十分笨拙，在实践中很少使用。此外，它甚至会在运行时导致错误，因为编译器无法确保程序员会在使用之前先调用对象上的 freeze 方法进行冻结。

幸运的是，还有第三种替代方法，它既能保证像重叠构造器模式那样的安全性，也能保证像 JavaBeans 模式那么好的可读性。这就是*建造者*（Builder）模式的一种形式。它不直接生成想要的对象，而是让客户端利用所有必要的参数调用构造器（或者静态工厂），得到一个 builder 对象 然后客户端在 builder 对象上调用类似于setter的方法，来设置每个相关的可选参数。最后 客户端调用无参的 build 方法来生成通常是不可变的对象。这个 builder 通常是它构建的类的静态成员类（详见第 24 条） 下面就是它的示例：
~~~java
// Builder Pattern
public class NutritionFacts { 
    private final int servingSize; 
    private final int servings;
    private final int calories; 
    private final int fat;
    private final int sodium;
    private final int carbohydrate;

    public static class Builder{
        // Required parameters
        private final int servingSize; 
        private final int servings;

        // Optional parameters - initialized to default values
        private int calories = 0 ; 
        private int fat = 0; 
        private int sodium = 0; 
        private int carbohydrate = 0; 

        public Builder(int servingSize, int servings){
            this.servingSize = servingSize;
            this.servings = servings;
        }

        public Builder calories(int val){
            colories = val;
            return this;
        }
        public Builder fat(int val){
            fat = val;
            return this;
        }
        public Builder sodium(int val){
            sodium = val;
            return this;
        }
        public Builder carbohydrate(int val){
            carbohydrate = val;
            return this;
        }

        public NutritionFacts build() {
            return new NutritionFacts(this);
        }
    }

    private NutritionFacts(Builder builder){
        servingSize = builder.servingSize;
        servings = builder.servings;
        calories = builder.calories;
        fat = builder.fat;
        sodium = builder.sodium;
        carbohydrate = builder.carbohydrate;
    }
}
~~~

注意 NutritionFacts 是不可变的，所有的默认参数值都单独放在一个 builder 的设值方法返回 builder 本身，以便把调用链接起来，得到一个流式的 API。下面就是其客户端代码：
~~~java
NutritionFacts cocaCola = new NutritionFacts.Builder(240, 8)
    .calories(100).sodium(35).carbohydrate(27).build();
~~~

这样的客户端代码很容易编写，更为重要的是易于阅读。**Builder模式模拟了具名的可选参数**，就像 Python 和 Scala 编程语言中的一样。

为了简洁起见，示例中省略了有效性检查。 要想尽快侦测到无效的参数， 可以在 builder 构造器和方法中检查参数的有效性。查看不可变量，包括 build 方法调用的构造器中的多个参数。为了确保这些不变量免受攻击，从 builder 复制完参数之后，要检查对象域（详见第 50 条）。如果检查失败，就抛出 IllegalArgumentException（详见第72条），其中的详细信息会说明哪些参数是无效的（详见第 75 条）。

**Builder 模式也适用于类层次结构**。使用平行层次结构的 builder 时， 各自嵌套在相应的类中。抽象类有抽象的 builder ，具体类有具体的 builder。假设用类层次根部的一个抽象类表示各式各样的比萨：
~~~java
// Builder pattern for class hierarchies
public abstract class Pizza { 
    public enum Topping { HAM, MUSHROOM, ONION, PEPPER, SAUSAGE } 
    final Set<Topping> toppings; 
    abstract static class Builder<T extends Builder<T>>{
        EnumSet<Topping> toppings= EnumSet.noneOf(Topping.class); 
        public T addTopping(Topping topping) { 
            toppings.add(Objects.requieNonNull(topping)); 
            return self();
        } 
        abstact Pizza build() ; 
        // Subclasses must override this method to return ” this" 
        protected abstract T self(); 
    } 
    Pizza(Builder<?> builder){
        toppings = builder.toppings.clone(); // See Item 50
    }
}
~~~
注意， Pizza Builder 型是*泛型*（generic type ），带有一个*递归类型参数*（recursive type parameter ），详见第 30 条。它和抽象的 self 方法一样，允许在子类中适当地进行方法链接，不需要转换类型。这个针对 Java 缺乏 self 型的解决方案，被称作模拟的 self 类型（ simulated self-type)。

这里有两个具体的 Pizza 子类，其中一个表示经典纽约风味的比萨，另一个表示馅料内置的半月型（ calzone ）比萨。前者需要一个尺寸参数，后者则要你指定酱汁应该内置还是外置：

~~~java
public class NyPizza extends Pizza { 
    public enum Size { SMALL, MEDIUM, LARGE } 
    private final Size size;
 
    public static class Builder extends Pizza.Builder<Builder> {
        private final Size size; 

        public Builder(Size size){
            this.size = Objects.requireNonNull(size);
        }
        @Override public NyPizza build() { 
            return new NyPizza(this); 
        }
        @Override protected Builder self() { return this; } 
    }
    private NyPizza(Builder builder){
        super(builder);
        size = builder.size;
    }
}
public class Calzone extends Pizza { 
    private final boolean sauceInside; 
    public static class Builder extends Pizza.Builder<Builder>{
        private boolean sauceInside = false; // Default 
    
        public Builde sauceInside() { 
            sauceInside = true;
            return this; 
        }
        @Override public Calzone build() { 
            return new Calzone(this);
        }
        @Override protected Builder self(){ return this; } 
    }

    private Calzone(Builder builder){
        super(builder);
        sauceInside = builde.sauceInside;
    }
}
~~~

注意，每个子类的构建器中的 build 方法，都声明返回正确的子类： NyPizza.Builder 的 build 方法返回 NyPizza ，而 Calzone.Builder 中的则返回 Calzone。在该方法中，子类方法声明返回超级类中声明的返回类型的子类型，这被称作*协变返回类型*(covariant return type)。它允许客户端无须转换类型就能使用这些构建器。

这些“层次化构建器”的客户端代码本质上与简单的 NutritionFacts构建器一样。为了简洁起见，下列客户端代码示例假设是在枚举常量上静态导人：
~~~java
NyPizza pizza = new NyPizza.Builder(SMALL)
    .addTopping(SAUSAGE).addTopping(ONION).build(); 
Calzone calzone = new Calzone.Builder()
    .addTopping(HAM).sauceInside().build();
~~~
与构造器相比，builder的微略优势在于，它可以有多个可变（varargs）参数。因为 builder 是利用单独的方法来设置每一个参数。此外，构造器还可以将多次调用某一个方法而传人的参数集中到一个域中，如前面的调用了两次 addTopping 方法的代码所示。

Builder 模式十分灵活，可以利用单个 builder 构建多个对象。build 的参数可以在调用 build 方法来创建对象期间进行调整，也可以随着不同的对象而改变 builder 可以自动填充某些域，例如每次创建对象时自动增加序列号。

Builder 模式的确也有它自身的不足。为了创建对象，必须先创建它的构建器。虽然创建这个构建器的开销在实践中可能不那么明显，但是在某些十分注重性能的情况下，可能就成问题了。Builder 模式还比重叠构造器模式更加冗长，因此它只在有很多参数的时候才使用，比如4个或者更多个参数。但是记住，将来你可能需要添加参数。如果一开始就使用构造器或者静态工厂，等到类需要多个参数时才添加构造器，就会无法控制，那些过时的构造器或者静态工厂显得十分不协调。因此，通常最好一开始就使用构建器。

简而言之，**如果类的构造器或者静态工厂中具有多个参数，设计这种类时， Builder模式就是一种不错的选择**，特别是当大多数参数都是可选或者类型相同的时候。与使用重叠构造器模式相比，使用 Builder 模式的客户端代码将更易于阅读和编写，构建器也比 JavaBeans 更加安全。

### 第3条：用私有构造器或者枚举类型强化Singleton属性

Singleton 是指仅仅被实例化一次的类。Singleton通常被用来代表一个无状态的对象，如函数（详见第24条），或者那些本质上唯一的系统组件。**使类称为Singleton会使它的客户端测试变得十分困难**，因为不可能给Singleton替换模拟实现，除非实现一个充当其类型的接口。

实现 Singleton 有两种常见的方法。这两种方法都要保持构造器为私有的，并导出公有的静态成员，以便允许客户端能够访问该类的唯一实例。在第一种方法中，公有静态成员是个final域：
~~~java
// Singleton with public final field 
public class Elvis {
    public static final Elvis INSTANCE= new Elvis(); 
    private Elvis() { ... } 

    public void leaveTheBuilding() { ... }
}
~~~

私有构造器仅被调用一次，用来实例化公有的静态 final 域 Elvis.INSTANCE 由于缺少公有的或者受保护的构造器，所以保证了 Elvis 的全局唯一性; 一旦 Elvis 类被实例化，将只会存在一个 Elvis 实例，不多也不少。客户端的任何行为都不会改变这一点，但要提醒一点：享有特权的客户端可以借助 AccessibleObject.setAccessible 方法，通过反射机制（详见第 65 条）调用私有构造器。如果需要抵御这种攻击，可以修改构造器，让它在被要求创建第二个实例的时候抛出异常。

在实现 Singleton 的第二种方法中，公有的成员是个静态工厂方法：
~~~java
// Singleton with static factory
public class Elvis { 
    private static final Elvis INSTANCE = new Elvis(); 
    private Elvis() { ... } 
    public static Elvis getInstance() { return INSTANCE; } 

    public void leaveTheBuilding() { ... }
}
~~~

对于静态方法 Elvis.getInstance 的所有调用，都会返回同一个对象引用，所以，永远不会创建其 Elvis 实例（上述提醒依然适用）。

公有域方法的主要优势在于， API 很清楚地表明了这个类是一个 Singleton；公有的静态域是 final 的，所以该域总是包含相同的对象引用。第二个优势在于它更简单。

静态工厂方法的优势之一在于，它提供了灵活性：在不改变其 API 的前提下，我们可以改变该类是否应该为 Singleton 的想法。工厂方法返回该类的唯一实例，但是，它很容易被修改，比如改成为每个调用该方法的线程返回一个唯一的实例。第二个优势是，如果应用程序需要，可以编写一个*泛型 Singleton 工厂*(generic singleton factory) （详见第 30 条）。使用静态工厂的最后一个优势是，可以通过*方法引用*（method reference）作为提供者，比如Elvis::instance 就是 Supplier<Elvis>。除非满足以上任意一种优势，否则还是优先考虑公有域（public-field ）的方法。

为了将利用上述方法实现的 Singleton 类变成是可序列化（Serializable）（详见第 12 章），仅仅在声明中加上 implements Serializable 是不够的。为了维护并保证 Singleton, 必须声明所有实例域都是瞬时（transient）的，并提供一个 readResolve 方法（详见第89条）。否则，每次反序列化一个序列化的实例时，都会创建一个新的实例，比如，在我
们的例子中，会导致“假冒的 Elvis”。为了防止发生这种情况，要在 Elvis 类中加入如下 readResolve 方法：
~~~java
// readResolve method to preserve singleton property
private Object readResolve() { 
    // Return the one true Elvis and let the garbage collector
    // take care of the Elvis impersonator
    return INSTANCE;
}
~~~
实现Singleton的第三种方法是声明一个包含单个元素的枚举类型：
~~~java
// Enum singleton - the preferred approach 
public enum Elvis { 
    INSTANCE; 
    public void leaveTheBuilding() { ... }
}
~~~
这种方法在功能上与公有域方法相似，但更加简洁，无偿地提供了序列化机制，绝对防止多次实例化，即使是在面对复杂的序列化或者反射攻击的时候。虽然这种方法还没有广泛采用，但是**单元素枚举类型经常成为实现 Singleton 的最佳方法**。注意，如果 Singleton必须扩展一个超类，而不是扩展 Enum 的时候，则不宜使用这个方法（虽然可以声明枚举去实现接口）。

### 第4条：通过私有构造器强化不可实例化的能力

有时可能需要编写只包含静态方法和静态域的类。这些类的名声很不好，因为有些人在面向对象的语言中滥用这样的类来编写过程化的程序，但它们也确实有特别的用处。我们可以利用这种类，以 java.lang.Math 或者 java.util.Arrays 的方式，把基本类型的值或者数组类型上的相关方法组织起来 我们也可以通过 java.util.Collections 的方式，把实现特定接口的对象上的静态方法，包括工厂方法（详见第 1 条）组织起来 （从 Java 8 开始，也可以把这些方法放进接口中，假定这是你自己编写的接口可以进行修改。最后，还可以利用这种类把 final 类上的方法组织起来，因为不能把它们放在子类中。

这样的*工具类*（ utility class ）不希望被实例化，因为实例化对它没有任何意义。然而在缺少显式构造器的情况下，编译器会自动提供一个公有的、无参的*缺省构造器*（default constructor）。对于用户而言，这个构造器与其他的构造器没有任何区别。在已发行的 API 中常常可以看到一些被无意识地实例化的类。

**企图通过将类做成抽象类来强制该类不可被实例化是行不通的**。该类可以被子类化，并且该子类也可以被实例化。这样做甚至会误导用户，以为这种类是专门为了继承而设计的（详见第 19 条）。然而，有一些简单的习惯用法可以确保类不可被实例化。由于只有当类不包含显式的构造器时，编译器才会生成缺省的构造器，因此只要让这个类包含一个私有构造器，它就不能被实例化：
~~~java
// Noninstantiable utility class 
public class UtilityClass { 
    // Suppress default constructor for noninstantiability 
    private UtilityClass() { 
        throw new AssertionError();
    }
    ... // Remainder omitted
}
~~~

由于显式的构造器是私有的，所以不可以在该类的外部访问它。AssertionError不是必需的，但是它可以避免不小心在类的内部调用构造器。它保证该类在任何情况下都不会被实例化。这种习惯用法有点违背直觉，好像构造器就是专门设计成不能被调用
此，明智的做法就是在代码中增加一条注释，如上所示。

这种习惯用法也有副作用，它使得一个类不能被子类化。所有的构造器都必须显式或隐式地调用超类（ superclass ）构造器，在这种情形下，子类就没有可访问的超类构造器可调用了。

### 第5条：优先考虑依赖注入来引用资源

有许多类会依赖一个或多个底层的资源。例如，拼写检查器需要依赖词典。因此，像下面这样把类实现为静态工具类的做法并不少见（详见第4条）：
~~~java
// Inappopriate use of static utility - inflexible & untestable! 
public class SpellChecker{
    private static final Lexicon dictionary = ...; 
    private SpellChecker(){} // Noninstantiable 
    public static boolean isValid(String Word) { ... }
    public static List<String> suggestions(String typo) { ... } 
}
~~~
同样地，将这些类实现为 Singleton 的做法也并不少见（详见第 3 条）
~~~java
// Inappropriate use of singleton - inflexible & untestable! 
public class SpellChecker{
    private final Lexicon dictionary = ... ; 
    private SpellChecker(...) {}
    public static INSTANCE = new SpellChecker(...);
    public boolean isValid(String Word) { ... } 
    public List<String> suggestions(String typo){...}
}
~~~
以上两种方法都不理想，因为它们都是假定只有一本词典可用。实际上，每一种语言都有自己的词典，特殊同汇还要使用特殊的词典 此外，可能还需要用特殊的词典进行测试。因此假定用一本词典，就能满足所有需求，这简直是痴心妄想。

建议尝试用 SpellChecker 来支持多词典，即在现有的拼写检查器中，设 dictionary 域为 nonfinal ，并添加一个方法用它来修改词典，但是这样的设置会显得很笨拙、容易出错，并且无法并行工作。**静态工具类和 Singleton 类不适合于需要引用底层资源的类**。

这里需要的是能够支持类的多个实例（在本例中是指 SpellChecker），每一个实例都使用客户端指定的资源（在本例中是指词典）。满足该需求的最简单的模式是，**当创建一个新的实例时，就将该资源传到构造器中。**这是依赖注入（dependency injection）的一种形式：词典（dictionary）是拼写检查器的一个依赖（ dependency ），在创建拼写检查器时就将词典注
入（ injected ）其中。
~~~java
// Dependency injection provides flexibility and testability 
public class SpellChecker{
    private final Lexicon dictionary;
    public SpellChecker(Lexicon dictionary) { 
        this.dictionary = Objects.requireNonNull(dictionary);
    }
    public boolean isValid(String word) { ... } 
    public List<String> suggestions(String typo) { ... }
}
~~~
依赖注入模式就是这么简单，因此许多程序员使用多年，却不知道它还有名字呢。虽然这个拼写检查器的范例中只有一个资源（词典），但是依赖注入却适用于任意数量的资源，以及任意的依赖形式。依赖注入的对象资源具有不可变性（详见第 17 条），因此多个客户端可以共享依赖对象（假设客户端们想要的是同一个底层资源）。依赖注入也同样适用于构造器、静态工厂（详见第1条）和构建器（详见第2条）.

这个程序模式的另一种有用的变体是，将资源工厂（factory）传给构造器。工厂是可以被重复调用来创建类型实例的一个对象。这类工厂具体表现为*工厂方法*（Factory Method) 模式。 Java8 中增加的接口 Supplier<T>，最适合用于表示工厂。带Supplier<T>的方法，通常应该限制输入工厂的类型参数使用*有限制的通配符类型*( bounded wildcard type），详见第 31 条，以便客户端能够传入一个工厂，来创建指定类型的任意子类型。例如，下面是一个生产马赛克的方法，它利用客户端提供的工厂来生产每一片马赛克：
~~~java
Mosaic create(Supplier<? extends Tile> tileFactory) { ... }
~~~
虽然依赖注人极大地提升了灵活性和可测试性，但它会导致大型项目凌乱不堪，因为它通常包含上千个依赖。不过这种凌乱用一个*依赖注入框架*（dependency injection framework)便可以终结，如 Dagger、Guice 或者 Spring。这些框架的用法超
了本书的讨论范畴，但是，请注意：设计成手动依赖注入的API，一般都适用于这些框架。

总而言之，不要用 Singleton 和静态工具类来实现依赖一个或多个底层资源的类，且该资源的行为会影响到该类的行为；也不要直接用这个类来创建这些资源。而应该将这些资源或者工厂传给构造器（或者静态工厂，或者构建器），通过它们来创建类。这个实践就被称作依赖注入，它极大地提升了类的灵活性、可重用性和可测试性。

### 第6条：避免创建不必要的对象

一般来说，最好能重用单个对象，而不是在每次需要的时候就创建一个相同功能的新对象。重用方式既快速，又流行。如果对象是不可变的（immutable）（详见第 17 条），它就始终可以被重用。

作为一个极端的反面例子，看看下面的语句：
~~~java
String s = new String("bikini");// DON'T DO THIS! 
~~~
该语句每次被执行的时候都创建一个新的 String 实例，但是这些创建对象的动作全都是不必要的。传递给 String 构造器的参数("bikini")本身就是 String 实例，功能方面等同于构造器创建的所有对象。如果这种用法是在一个循环中，或者是在一个被频
繁调用的方法中，就会创建出成千上万不必要的 String 实例。

改进后的版本如下所示：
~~~java
String s = "bikini";
~~~
这个版本只用了一个 String 实例，而不是每次执行的时候都创建一个新的实例。而且，它可以保证，对于所有在同一台虚拟机中运行的代码，只要它们包含相同的字符串字面常量，该对象就会被重用。

对于同时提供了静态工厂方法（static factory method) （详见第 1 条）和构造器的不可变类，通常优先使用静态工厂方法而不是构造器，以避免创建不必要的对象。例如，静态工厂方法 Boolean.valueOf(String)几乎总是优先于构造器 Boolean(String)，注意构造器 Boolean(String)在 Java 9 中已经被废弃了。构造器在每次被调用的时候都会创建一个新的对象，而静态工厂方法 从来不要求这样做，实际上也不会这样做。除了重用不可变的对象之外，也可以重用那些已知不会被修改的可变对象。

有些对象创建的成本比其他对象要高得多。如果重复地需要这类“昂贵的对象”，建议将它缓存下来重用。遗憾的是，在创建这种对象的时候，并非总是那么显而易见。假设想要编写一个方法，用它确定一个字符串是否为一个有效的罗马数字。下面介绍一种最容易的方
法，使用一个正则表达式：
~~~java
// Performance can be greatly imp oved!
static boolean isRomanNumeral(String s) { 
    return s.matches("^(?＝．)M*(C[MD]|D?C{0,3})"
        + "(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$");
}
~~~
这个实现的问题在于它依赖 String.matches 方法。**虽然 String.matches 方法最易于查看一个字符串是否与正则表达式相匹配，但并不适合在注重性能的情形中重复使用**。问题在于，它在内部为正则表达式创建了一个 Pattern 实例，却只用了一次，之后就可以进行垃圾回收了。创建 Pattern 实例的成本很高，因为需要将正则表达式编译成一个有限状
态机（finite state machine）。

为了提升性能，应该显式地将正则表达式编译成一个 Pattern 实例（不可变），让它成为类初始化的一部分，并将它缓存起来，每当调用 isRomanNumeral 方法的时候就重用同一个实例：
~~~java
// Reusing expensive object for improved performance 
public class RomanNumerals { 
    private static final Pattern ROMAN = Pattern.compile(
        "^(?＝．)M*(C[MD]|D?C{0,3})"
        + "(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$");

    static boolean isRomanNumeral (String s) { 
        return ROMAN.matcher(s).matches();
    }
}
~~~
改进后的 isRomanNumeral 方法如果被频繁地调用，会显示出明显的性能优势我的机器上，原来的版本在8字符的输入字符串上花了 1.1μs，而改进后的版本只花了0.17 µs，速度快了6.5倍。除了提高性能之外，可以说代码也更清晰了。将不可见的 Pattern 实例做成 final 静态域时，可以给它起个名字，这样会比正则表达式本身更有可读性。

如果包含改进后的 isRomanNumeral 方法的类被初始化了，但是该方法没有被调用，那就没必要初始化 ROMAN 域。通过在 isRomanNumeral 方法第一次被调用的时候延迟初始化（lazily initializing)（详见第 83 条）这个域，有可能消除这个不必要的初始化工作，但是不建议这样做。正如延迟初始化中常见的情况一样，这样做会使方法的实现更加复杂，从而无法将性能显著提高到超过已经达到的水平（详见第 67 条）。

如果一个对象是不变的，那么它显然能够被安全地重用，但其他有些情形则并不总是这么明显。考虑适配器（adapter）的情形，有时也叫作视图（view）。适配器是指这样一个对象：它把功能委托给一个后备对象（backing object），从而为后备对象提供一个可以替代的接口。由于适配器除了后备对象之外，没有其他的状态信息，所以针对某个给定对象的特定适配器而言，它不需要创建多个适配器实例。

例如 Map 接口 keySet 方法返回该 Map 对象的 Set 视图，其中包含 Map 中所有的键（key）。乍看之，好像每次调用 keySet 都应该创建一个新 Set 实例，但是，对于一个给定的 Map 对象，实际上每次调用 keySet 都返回同样的 Set 实例。虽然被返回 Set 实例一般是可改变的，但是所有返回的对象在功能上是等同的：当其中一个返回对象发生变化的时候，所有其他的返回对象也要发生变化，因为它们是由同一个 Map 实例支撑的。虽然创建 keySet 视图对象的多个实例并无害处，却是没有必要，也没有好处的。

另一种创建多余对象的方法，称作自动装箱（ autoboxing ），它允许程序员将基本类型和装箱基本类型（ Boxed Primitive Type ）混用，按需要自动装箱和拆箱。**自动装箱使得基本类型和装箱基本类型之间的差别变得模糊起来，但是并没有完全消除**。 在语义上还有着微妙的差别，在性能上也有着比较明显的差别（详见第 61 条）。请看下面的程序，它计算所有int正整数值的总和。为此，程序必须使用 long 算法，因为 int 不够大，无法容纳所有 int 正整数值的总和：
~~~java
// Hideously slow! Can you spot the object creation? 
private static long sum() { 
    Long sum = 0L ; 
    for (long i = 0; i <= Integer.MAX_VALUE; i++) 
        sum += i ; 
    return sum;
}
~~~
这段程序算出的答案是正确的，但是比实际情况要更慢一些，只因为打错了一个字符。变量 sum 被声明成 Long 而不是 long，意味着程序构造了大约 2^31 个多余的 Long 实例（大约每次往 Long sum 中增加 long 时构造一个实例）。将 sum 的声明从 Lo 改成 long ，在我的机器上使运行时间从 6.3 秒减少到了 0.59 秒。结论很明显：**要优先使用基本类型而不是装箱基本类型，要当心无意识的自动装箱**。

不要错误地认为本条目所介绍的内容暗示着“创建对象的代价非常昂贵，我们应该要尽可能地避免创建对象”。相反，由于小对象的构造器只做很少量的显式工作，所以小对象的创建和回收动作是非常廉价的，特别是在现代的 JVM 实现上更是如此。通过创建附加的
对象，提升程序的清晰性、简洁性和功能性，这通常是件好事。

反之，通过维护自己的对象池（ object pool ）来避免创建对象并不是一种好的做法，除非池中的对象是非常重量级的。正确使用对象池的典型对象示例就是数据库连接池。建立数据库连接的代价是非常昂贵的，因此重用这些对象非常有意义。而且，数据库的许可可能限制你只能使用一定数量的连接。但是，一般而言，维护自己的对象池必定会把代码弄得很乱，同时增加内存占用（ footprint ），并且还会损害性能。现代的 JVM 实现具有高度优化的垃圾回收器，其性能很容易就会超过轻量级对象池的性能。

与本条目对应的是第 50 条中有关“保护性拷贝”（ defensive copying ）的内容。本条目提及“当你应该重用现有对象的时候，请不要创建新的对象”，而第50条则说“当你应该创建新对象的时候，请不要重用现有的对象”。注意，在提倡使用保护性拷贝的时候，因重用对象而付出的代价要远远大于因创建重复对象而付出的代价。必要时如果没能实施保护性拷贝，将会导致潜在的 Bug 和安全漏洞；而不必要地创建对象则只会影响程序的风格和性能。

### 第7条：消除过期的对象引用

当你从手工管理内存的语言（比如 C或C++）转换到具有垃圾回收功能的比如 Java 语言时，程序员的工作会变得更加容易，因为当你用完了对象之后，它们会被自动回收。当你第一次经历对象回收功能的时候，会觉得这简直有点不可思议。它很容易给你留下这样的印
象， 认为自己不再需要考虑内存管理的事情了，其实不然。

请看下面这个简单的栈实现的例子：
~~~java
// Can you spot the ”memory leak”? 
public class Stack { 
    private Object[] elements; 
    private int size = 0; 
    private static final int DEFAULT_INITIAL_CAPACITY = 16; 
    
    public Stack() { 
        elements = new Object[DEFAULT_INITIAL_CAPACITY];
    }
 
    public void push(Object e){
        ensureCapacity(); 
        elements[size++] = e; 
    }

    public Object pop (){
        if (size == 0) 
            throw new EmptyStackException(); 
        return elements[--size];
    } 

    /**
    * Ensure space fo at least one more element, roughly
    * doubling the capacity each time the array needs to grow
    */
    private void ensureCapacity() { 
        if (elements.length == size)
            elements = Arrays.copyOf(elements, 2 * size+ 1) ; 
    }
}
~~~
这段程序（它的泛型版本请见第 29 条）中并没有很明显的错误。无论如何测试，它都会成功地通过每一项测试，但是这个程序中隐藏着一个问题。不严格地讲，这段程序有一个“内存泄漏”，随着垃圾回收器活动的增加，或者由于内存占用的不断增加，程序性能的降低
会逐渐表现出来。在极端的情况下，这种内存泄漏会导致磁盘交换（ Disk Paging ），甚至导致程序失败（ OutOfMemoryError 错误），但是这种失败情形相对比较少见。

那么，程序中哪里发生了内存泄漏呢？ 如果一个栈先是增长，然后再收缩，那么，从栈中弹出来的对象将不会被当作垃圾回收，即使使用栈的程序不再引用这些对象，它们也不会被回收。这是因为栈内部维护着对这些对象的过期引用（obsolete reference）。所谓的过期引用，是指永远也不会再被解除的引用。在本例中，凡是在 elements 数组的“活动部分”(active portion）之外的任何引用都是过期的。活动部分是指 elements 中下标小于 size 的那些元素。

在支持垃圾回收的语言中，内存泄漏是很隐蔽的（称这类内存泄漏为“无意识的对象保持”（unintentional object retention）更为恰当）。如果一个对象引用被无意识地保留起来了，那么垃圾回收机制不仅不会处理这个对象，而且也不会处理被这个对象所引用的所有其他对象。即使只有少量的几个对象引用被无意识地保留下来，也会有许许多多的对象被排除在垃圾回收机制之外，从而对性能造成潜在的重大影响。

这类问题的修复方法很简单：一旦对象引用已经过期，只需清空这些引用即可。对于上述例子中的 Stack 类而言，只要一个单元被弹出栈，指向它的引用就过期了。pop 方法的修订版本如下所示：
~~~java
public Object pop() { 
    if (size == 0) 
        throw new EmptyStackException(); 
    Object result = elements[--size]; 
    elements[size] =null; // Eliminate obsolete reference
    return result;
}
~~~
清空过期引用的另一个好处是，如果它们以后又被错误地解除引用，程序就会立即抛出 NullPointerException 异常，而不是悄悄地错误运行下去。尽快地检测出程序中的错误总是有益的。

当程序员第一次被类似这样的问题困扰的时候，他们往往会过分小心。对于每一个对象引用，一旦程序不再用到它，就把它清空。其实这样做既没必要，也不是我们所期望的，因为这样做会把程序代码弄得很乱。**清空对象引用应该是一种例外，而不是一种规范行为。** 消除过期引用最好的方法是让包含该引用的变量结束其生命周期。如果你是在最紧凑的作用域范围内定义每一个变量（详见第 57 条），这种情形就会自然而然地发生。

那么，何时应该清空引用呢？ Stack 类的哪方面特性使它易于遭受内存泄漏的影响呢？简而言之，问题在于， Stack 类自己管理内存。存储池（ storage pool ）包含了 elements数组（对象引用单元，而不是对象本身）的元素。数组活动区域（同前面的定义）中的元素是己分配的（ allocated ），而数组其余部分的元素则是自由的（free）。但是垃圾回收器并不知道这一点；对于垃圾回收器而言， elements 数组中的所有对象引用都同等有效。只有程序员知道数组的非活动部分是不重要的。程序员可以把这个情况告知垃圾回收器，做法很简单：一旦数组元素变成了非活动部分的一部分，程序员就手工清空这些数组元素。

一般来说，**只要类是自己管理内存，程序员就应该警惕内存泄漏问题**。一旦元素被释放掉，则该元素中包含的任何对象引用都应该被清空。

**内存泄漏的另一个常见来源是缓存**。一旦你把对象引用放到缓存中，它就很容易被遗忘掉，从而使得它不再有用之后很长一段时间内仍然留在缓存中。对于这个问题，有几种可能的解决方案。如果你正好要实现这样的缓存：只要在缓存之外存在对某个项的键的引用，该项就有意义，那么就可以用 WeakHashMap 代表缓存；当缓存中的项过期之后，它们就会自动被删除。记住只有当所要的缓存项的生命周期是由该键的外部引用而不是由值决定时， WeakHashMap 才有用处。

更为常见的情形则是，“缓存项的生命周期是否有意义”并不是很容易确定，随着时间的推移，其中的项会变得越来越没有价值。在这种情况下，缓存应该时不时地清除掉没用的项。这项清除工作可以由一个后台线程（可能是 ScheduledThreadPoolExecutor）来完成，或者也可以在给缓存添加新条目的时候顺便进行清理 LinkedHashMap 类利用它 removeEldestEntry 方法可以很容易地实现后一种方案。对于更复杂的缓存，必须直接使用 java.lang.ref。

**内存泄漏的第三个常见来源是监听器和其他回调。** 如果你实现了一个API，客户端在这个 API 中注册回调，却没有显式地取消注册，那么除非你采取某些动作，否则它们就会不断地堆积起来。确保回调立即被当作垃圾回收的最佳方法是只保存它们的弱引用（wea
reference），例如，只将它们保存成 WeakHashMap 中的键。

由于内存泄漏通常不会表现成明显的失败，所以它们可以在一个系统中存在很多年。往往只有通过仔细检查代码，或者借助于Heap剖析工具（ Heap Profiler ）才能发现内存泄漏问题。因此，如果能够在内存泄漏发生之前就知道如何预测此类问题，并阻止它们发生，那是最好不过的了。

### 第8条：避免使用终结方法和清除方法

**终结方法（finalizer）通常是不可预测的，也是很危险的，一般情况下是不必要的**。用终结方法会导致行为不稳定、性能降低，以及可移植性问题。当然，终结方法也有其可用之处，我们将在本条目的最后再做介绍；但是根据经验，应该避免使用终结方法。Java 9 中用清除方法（ cleaner ）代替了终结方法。**清除方法没有终结方法那么危险，但仍然是不可预测、运行缓慢，一般情况下也是不必要的**。

C++的程序员被告知“不要把终结方法当作是C++中析构器（ destructors ）的对应物”。在C++中，析构器是回收一个对象所占用资源的常规方法，是构造器所必需的对应物。在 Java 中，当一个对象变得不可到达的时候，垃圾回收器会回收与该对象相关联的存储空间，并不需要程序员做专门的工作。C++的析构器也可以被用来回收其他的非内存资源。而在 Java 中，一般用 try-finally 块来完成类似的工作（详见第 9 条）。

终结方法和清除方法的缺点在于不能保证会被及时执行 JLS . 12.6 ］。 从一个对象变得不可到达开始，到它的终结方法被执行，所花费的这段时间是任意长的。这意味着，**注重时间（time-critical）的任务不应该由终结方法或者清除方法来完成**。例如，用终结方法或者清除方法来关闭已经打开的文件，就是一个严重的错误，因为打开文件的描述符是一种很有限的资源。如果系统无法及时运行终结方法或者清除方法就会导致大量的文件仍然保留在打开状态，于是当一个程序再也不能打开文件的时候，它可能会运行失败。

及时地执行终结方法和清除方法正是垃圾回收算法的一个主要功能，这种算法在不同 JVM 实现中会大相径庭。如果程序依赖于终结方法或者清除方法被执行的时间点，那么这个程序的行为在不同的 JVM 中运行的表现可能就会截然不同。一个程序在你测试用的 JVM 平台上运行得非常好，而在你最重要顾客的 JVM 平台上却根本无法运行，这是完全有可能的。

延迟终结过程并不只是一个理论问题。在很少见的情况下，为类提供终结方法，可能会随意地延迟其实例的回收过程。一位同事最近在调试一个长期运行的 GUI 应用程序的时候，该应用程序莫名其妙地出现 OutOfMemoryError 错误而死掉。分析表明，该应用程序死掉的时候，其终结方法队列中有数千个图形对象正在等待被终结和回收。遗憾的是，终结方法线程的优先级比该应用程序的其他线程的优先级要低得多，所以，图形对象的终结速度达不到它们进入队列的速度。Java 语言规范并不保证哪个线程将会执行终结方法，所以，除了不使用终结方法之外，并没有很轻便的办法能够避免这样的问题。在这方面，清除方法比终结方法稍好一些，因为类的设计者可以控制自己的清除线程， 但清除方法仍然在后台运行，处于垃圾回收器的控制之下，因此不能确保及时清除。

Java 语言规范不仅不保证终结方法或者清除方法会被及时地执行，而且根本就不保证它们会被执行。当一个程序终止的时候，某些已经无法访问的对象上的终结方法却根本没有被执行，这是完全有可能的。结论是：**永远不应该依赖终结方法或者清除方法来更新重要的持久状态**。例如，依赖终结方法或者清除方法来释放共享资源（比如数据库）上的永久锁，这很容易让整个分布式系统垮掉。

不要被 System.gc 和 System.runFinalization 这两个方法所诱惑，它们确实增加了终结方法或者清除方法被执行的机会，但是它们并不保证终结方法或者清除方法会被执行。唯一声称保证它们会被执行的两个方法是 System.runFinalizersOnExit,及其臭名昭著的孪生兄弟 Runtime.runFinalizersOnExit。这两个方法都有致命的缺陷，井且已经被废弃很久了。

使用终结方法的另一个问题是：如果忽略在终结过程中被抛出来的未被捕获的异常，该对象的终结过程也会终止。未被捕获的异常会使对象处于破坏的状态（corrupt state），如果另一个线程企图使用这种被破坏的对象，则可能发生任何不确定的行为。正常情况下，未被捕获的异常将会使线程终止，并打印出栈轨迹（Stack Trace），但是，如果异常发生在终结方法之中，则不会如此，甚至连警告都不会打印出来。清除方法没有这个问题，因为使用清除方法的一个类库在控制它的线程。

**使用终结方法和清除方法有一个非常严重的性能损失**。在我的机器上，创建一个简单AutoCloseable 对象，用 try-with-resources 将它关闭，再让垃圾回收器将它回收，完成这些工作花费的时间大约为 12ns。增加一个终结方法使时间增加到了 550ns。换句话说，用终结方法创建和销毁对象慢了大约 50倍。这主要是因为终结方法阻止了有效的垃圾回收。如果用清除方法来清除类的所有实例，它的速度比终结方法会稍微快一些（在我的机器上大约是每个实例花 500ns ），但如果只是把清除方法作为一道安全网（safety net），下面将会介绍，那么清除方法的速度还会更快一些。在这种情况下，创建、清除和销毁对象，在我的机器上花了大约 66ns ，这意味着，如果没有使用它，为了确保安全网多花了5倍（而不是 50 倍）的代价。

**终结方法有一个严重的安全问题**：它们为终结方法攻击（finalizer attack）**打开了类的大门**。终结方法攻击背后的思想很简单：如果从构造器或者它的序列化对等体（ readObject和readResolve 方法，详见第 12 章）抛出异常，恶意子类的终结方法就可以在构造了一部分的应该已经半途夭折的对象上运行。这个终结方法会将对该对象的引用记录在一个静态域中，阻止它被垃圾回收。一旦记录到异常的对象，就可以轻松地在这个对象上调用任何原本永远不允许在这里出现的方法。**从构造器抛出的异常，应该足以防止对象继续存在；有了终结方法的存在，这一点就做不到了**。这种攻击可能造成致命的后果。final类不会受到终结方法攻击，因为没有人能够编写出 final 类的恶意子类。**为了防止非 final 类受到终结方法攻击，要编写一个空的 final的 finalize 方法**。

那么，如果类的对象中封装的资源（例如文件或者线程）确实需要终止，应该怎么做才能不用编写终结方法或者清除方法呢？只需**让类实现 AutoCloseable** ，并要求其客户端在每个实例不再需要的时候调用 close 方法，一般是利用 try-with-resources 确保终止，即使遇到异常也是如此（详见第9条）。值得提及的一个细节是，该实例必须记录下自己是否已经被关闭了： close 方法必须在一个私有域中记录下“该对象已经不再有效”。如果这些方法是在对象已经终止之后被调用，其他的方法就必须检查这个域，并抛出 IllegalStateException 异常。

那么终结方法和清除方法有什么好处呢？它们有两种合法用途。第一种用途是，当资源的所有者忘记调用它的 close 方法时，终结方法或者清除方法可以充当“安全网”。虽然这样做井不能保证终结方法或者清除方法会被及时地运行，但是在客户端无法正常结束操作的情况下，迟一点释放资源总比永远不释放要好。如果考虑编写这样的安全网终结方法，就要认真考虑清楚，这种保护是否值得付出这样的代价。有些 Java 类（如 FileinputStream、FileOutputStream、ThreadPoolExecutor和java.sql.Connection ）都具有能充当安全网的终结方法。

清除方法的第二种合理用途与对象的本地对等体（ native peer ）有关。本地对等体是一个本地（非 Java 的）对象（ native object ），普通对象通过本地方法（ native method ）委托给个本地对象。因为本地对等体不是一个普通对象，所以垃圾回收器不会知道它，当它的 Java 对等体被回收的时候，它不会被回收。如果本地对等体没有关键资源，并且性能也可以接受的话，那么清除方法或者终结方法正是执行这项任务最合适的工具。如果本地对等体拥有必须被及时终止的资源，或者性能无法接受，那么该类就应该具有一个 close 方法，如前所述。

清除方法的使用有一定的技巧。下面以一个简单的 Room 类为例。假设房间在收回之前必须进行清除。Room类实现了 AutoCloseable ；它利用清除方法自动清除安全网的过程只不过是一个实现细节。与终结方法不同的是，清除方法不会污染类的公有 API:
~~~java
// An autocloseable class using a cl eaner as a safety net 
public class Room implements AutoCloseable { 
    private static final Cleaner cleaner = Cleaner.create();
    
    // Resouce that requires cleaning. Must not refer to Room! 
    private static class State implements Runnable { 
        int numJunkPiles ; // number of junk piles in this room

        State(int numJunkPiles){
            this.numJunkPiles = numJunkPiles; 
        }
 
        // Invoked by close method or cleaner
        @Override public void run() { 
            System.out.println("Cleaning room");
            numJunkPiles = 0;
        }
    }
 
    // The state of this room, shared with our cleanable
    private final State state;
 
    // Our cleanable.Cleans the room when it's eligible for gc
    private final Cleaner.Cleanable cleanable;
 
    public Room(int numJunkPiles) { 
        state = new State(numJunkPiles);
        cleanable = cleaner.register(this, state); 
    }

    @Override public void close (){
        cleanable.clean();
    }
}
~~~
内嵌的静态 State 保存清除方法清除房间所需的资源。在这个例子中，就是 numJunkPiles 域，表示房间的杂乱度。更现实地说，它可以是final的long，含一个指向本地对等体的指针。State 实现了 Runnable 接口，它的 run 方法最多被 Cleanable调用一次 ，后者是我们在 Room 构造器中用清除器注册 State 实例时获得的。以下两种情况之一会触发 run 方法的调用：通常是通过调用 Room close 方法触发的，后者又调用Cleanable 的清除方法。如果到了 Room 应该被垃圾回收时，客户端还没有调用close 方法，清除方法就会（希望如此）调用 State的run 方法。

关键是 State 实例没有引用它的 Room 实例。如果它引用了，会造成循环，阻止 Room实例被垃圾回收 （以及防止被自动清除）。State 必须是一个静态的嵌套类，因为非静态的嵌套类包含了对其外围实例的引用（详见第 24 条）。同样地，也不建议使用lambda,因为它们很容易捕捉到对外围对象的引用。

如前所述，Room 的清除方法只用作安全网。如果客户端将所有的 Room 实例化都包在 try-with-resource 块中 ，将永远不会请求到自动清除。用下面这个表现良好的客户端代码示范一下：
~~~java
public class Adult { 
    public static void main (String[] args) { 
        try (Room myRoom = new Room(7)){
            System.out.println("Goodbye");
        }
    }
}
~~~
正如所期待的一样，运行 Adult 程序会打印出 Goodbye ，接着是 Cleaning room。但是下面这个表现糟糕的程序又如何呢？一个将永远不会清除它的房间？
~~~java
public class Teenager{
    public static void main(String[] args) { 
        new Room(99); 
        System.out.println("Peace out");
    }
}
~~~
你可能期望打印出 Peace out，然后是 Cleaning room ，但是在我的机器上，它没有打印出 Cleaning room ，就退出程序了。这就是我们之前提到过的不可预见性。Cleaner 规范指出：“清除方法在 System.exit 期间的行为是与实现相关的。不确保清
除动作是否会被调用。”虽然规范没有指明，其实对于正常的程序退出也是如此。在我的机器上，只要在 Teenager的main方法上添加代码行`System.gc()`，就足以让它在退出之前打印出 Cleaning room ，但是不能保证在你的机器上也能看到相同的行为。

总而言之，除非是作为安全网，或者是为了终止非关键的本地资源，否则请不要使用清除方法，对于在 Java 9 之前的发行版本，则尽量不要使用终结方法。使用了终结方法或者清除方法，则要注意它的不确定性和性能后果。

### 第9条：try-catch-resources优先于try-finally

Java 类库中包括许多必须通过调用 close 方法来手工关闭的资源 例如 InputStream、OutputStream和java.sql.Connection 客户端经常会忽略资源，造成严重的性能后果也就可想而知了。虽然这其中的许多资源都是用终结方法作为安全网，但是效果并不理想（详见第8条）。

根据经验， try finally 语句是确保资源会被适时关闭的最佳方法，就算发生异常或者返回也一样：
~~~java
// try-finally - No longer the best way to close resources!
static String firstlineOfFile(String path) throws IOException { 
    BufferedReader br = new BufferedReader(new FileReader(path));
    try {
        return br.readline();
    } finally { 
        br.close();
    }
}
~~~
这看起来好像也不算太坏，但是如果再添加第二个资源，就会一团糟了:
~~~java
// try-finally is ugly when used with more than one resource!
static void copy(String src, String dst) throws IOException { 
    InputStream in = new FileinputStream(src);
    try { 
        OutputStream out = new FileOutputStream(dst);
        try { 
            byte[] buf = new byte[BUFFER_SIZE]; 
            int n; 
            while ((n = in.read(buf)) >= 0)
                out.write(buf, 0, n); 
        } finally { 
            out.close ();
        } 
    } finally { 
        in.close();
    }
}
~~~
即使用 try-finally 语句正确地关闭了资源，如前两段代码范例所示，它也存在着些许不足。因为在 try 块和 finally 块中的代码，都会抛出异常 例如在 firstLineOfFile方法中，如果底层的物理设备异常，那么调用 readLine 就会抛出异常，基于同样的原因，调用 close 也会出现异常。在这种情况下，第二个异常完全抹除了第一个异常。在异常堆栈轨迹中，完全没有关于第一个异常的记录，这在现实的系统中会导致调试变得非常复杂，因为通常需要看到第一个异常才能诊断出问题何在 虽然可以通过编写代码来禁止第二个异常，保留第一个异常，但事实上没有人会这么做，因为实现起来太烦琐了。

当Java 7引入 try-with-sources 语句时，所有这些问题一下子就全部解决了。要使用这个构造的资源，必须先实现 AutoCloseable 接口，其中包含了单个返回 void 的 close 方法。Java 类库与第三方类库中的许多类和接口，现在都实现或扩展了 AutoCloseable 接口。如果编写了一个类，它代表的是必须被关闭的资源，那么这个类也应该实现 AutoCloseable。

以下就是使用 try-with-resources 的第一个范例：
~~~java
// try-with-resources - the the best way to close resources! 
static String firstlineOfFile(String path) throws IOException { 
    try(BufferedReader = new BufferedReader(new FileReader(path))){
        return br.readline();
    }
}
~~~
以下是使用 try-with-resources 的第二个范例：
~~~java
// try-with-resources on multiple resources - short and sweet 
static void copy(String src, String dst) throws IOException { 
    try(InputStream in = new FileinputStream(src);
        OutputStream out = new FileOutputStream(dst)) {
            byte[] buf =new byte[BUFFER_SIZE]; 
            int n; 
            while ((n = in.read(buf)) >= 0)
                out.write(buf, 0, n);
        }
}
~~~
使用 try-with-resources 不仅使代码变得更简洁易懂，也更容易进行诊断 firstLineOfFile 方法为例，如果调用 readLine 和（不可见的） close 方法都抛出异常，后一个异常就会被禁止，以保留第一个异常。事实上，为了保留你想要看到的那个异常，即便多个异常都可以被禁止。这些被禁止的异常并不是简单地被抛弃了，而是会被打印在堆栈轨迹中，并注明它们是被禁止的异常。通过编程调用 getSuppressed 方法还可以访问到它们， getsuppressed 方法也已经添加在 Java7的 Throwable 中了。

try-with-resources 语句中还可以使用 catch 子句，就像在平时的 try-finally 语句中一样。这样既可以处理异常，又不需要再套用一层代码。下面举一个稍费了点心思的范例，这个 firstLineOfFile 方法没有抛出异常，但是如果它无法打开文件，或者无法从中读取，就会返回一个默认值：
~~~java
// try-with-resources with a catch clause 
static String firstLineOfFile(String path, String defaultVal) { 
    try (BufferedReade br = new BufferedReader(new FileReader(path))){
        return br.readline();
    } catch (IOException e) { 
        return defaultVal; 
    }
}
~~~
结论很明显:在处理必须关闭的资源时，始终要优先考虑用 try-with-resources ，而不是try-finally。这样得到的代码将更加简洁、清晰，产生的异常也更有价值。有了 trywith resources 语句，在使用必须关闭的资源时，就能更轻松地正确编写代码了。实践证明，这个用 try-finally 是不可能做到的。

## 第3章 对于所有对象都通用的方法

尽管 Object 是一个具体类，但设计它主要是为了扩展。它所有的非 final 方法（equals、hashCode、toString、clone和finalize）都有明确的通用约定（general contract),因为它们设计成是要被覆盖（override）的。任何一个类，它在覆盖这些方法的时候，都有责任遵守这些通用约定；如果不能做到这一点，其他依赖于这些约定的类（例如 HashMap和HashSet）就无法结合该类一起正常运作。

本章将讲述何时以及如何覆盖这些非final的 Object 方法。本章不再讨论 finalize 方法，因为第8条已经讨论过这个方法了。 而Comparable.compareTo 虽然不是 Object 方法，但是本章也将对它进行讨论，因为它具有类似的特征。

### 第10条：覆盖equals时请遵守通用约定

覆盖 equals 方法看起来似乎很简单，但是有许多覆盖方式会导致错误，并且后果非常严重。最容易避免这类问题的办法就是不覆盖 equals 方法，在这种情况下，类的每个实例都只与它自身相等。如果满足了以下任何一个条件，这就正是所期望的结果：
- **类的每个实例本质上都是唯一的**。对于代表活动实体而不是值（value）的类来说确实如此，例如 Thread。Object 提供的 equals 对于这些类来说正是正确的行为。
- **类没有必要提供“逻辑相等”（ logical equality ）的测试功能**。例如， java.util.regex.Pattern 可以覆盖 equals ，以检查两个 Pattern 实例是否代表同一个正则表达式，但是设计者并不认为客户需要或者期望这样的功能。在这类情况之下，从Object继承得到的equals实现已经足够了。
- **超类已经覆盖 equals，超类的行为对于这个类也是合适的**。例如，大多数的Set 实现都从 Abstract Set 继承 equals 实现， List 实现从 AbstractList 继承 equals 实现， Map 实现从 AbstractMap 继承 equals 实现。
- **类是私有的，是包级私有的，可以确定它的 equals 方法永远不会被调用**。如果你非常想要规避风险，可以覆盖 equals 方法，以确保它不会被意外调用：
~~~java
@Override public boolean equals(Object o) { 
    throw new AssertionError(); // Method is never called
}
~~~
那么，什么时候应该覆盖 equals 方法呢？如果类具有自己特有的“逻辑相等”（logical equality）概念（不同于对象等同的概念），而且超类还没有覆盖 equals。这通常属于“值类”（ value class ）的情形。值类仅仅是一个表示值的类，例如 Integer 或者 String。程序员在利用 equals 方法来比较值对象的引用时，希望知道它们在逻辑上是否相等，而不是想了解它们是否指向同一个对象。为了满足程序员的要求，不仅必须覆盖 equals 方法，而且这样做也使得这个类的实例可以被用作映射表（ map ）的键（ key ），或者集合（ set ）的元素，使映射或者集合表现出预期的行为。

有一种“值类”不需要覆盖 equals 方法，即用实例受控（详见第1条）确保“每个值至多只存在一个对象”的类。枚举类型（详见第 34 条）就属于这种类。对于这样的类而言，逻辑相同与对象等同是一回事，因此 Object 的 equals 方法等同于逻辑意义上的
equals 方法。

在覆盖 equals 方法的时候，必须要遵守它的通用约定。下面是约定的内容，来自 Object 的规范。

equals 方法实现了等价关系（ equivalence relation ），其属性如下：
- 自反性（reflexive）：对于任何非 null 的引用值x，x.equals(x）必须返回 true。
- 对称性（symmetric）：对于任何非 null 的引用值x和y，当且仅当 y.equals(x）返回 true 时， x.equals(y)必须返回 true。
- 传递性（transitive）：对于任何非 null 的引用值x，y和z，如果 x.equals(y)返回true，并且 y.equals(z)也返回 true ，那么 x.equals(z)也必须返回 true。
- 一致性（consistent）：对于任何非 null 引用值x和y，只要 equals 的比较操作在对象中所用的信息没有被修改，多次调用 x.equals(y)就会一致地返回 true,或者一致地返回 false。
- 对于任何非 null 的引用值 x, x.equals(null)必须返回 false。

除非你对数学特别感兴趣，否则这些规定看起来可能有点让人感到恐惧，但是绝对不要忽视这些规定！如果违反了，就会发现程序将会表现得不正常，甚至崩溃，而且很难找到失败的根源。John Donne的话说，没有哪个类是孤立的。一个类的实例通常会被频繁地传递给另一个类的实例。有许多类，包括所有的集合类（collection class）在内，都依赖于传递给它们的对象是否遵守了 equals 约定。

现在你已经知道了违反 equals 约定有多么可怕，下面将更细致地讨论这些约定。值得欣慰的是，这些约定虽然看起来很吓人，实际上并不十分复杂。一旦理解了这些约定，要遵守它们并不困难。

那么什么是等价关系呢？不严格地说，它是一个操作符，将一组元素划分到其元素与另一个元素等价的分组中。这些分组被称作等价类（equivalence class）。从用户的角度来看，对于有用的 equals 方法，每个等价类中的所有元素都必须是可交换的。现在我们按照顺序逐一查看以下5个要求。

**自反性 Reflexivity** 一一第一个要求仅仅说明对象必须等于其自身。很难想象会无意识地违反这一条。假如违背了这一条，然后把该类的实例添加到集合中，该集合的 contains 方法将果断地告诉你，该集合不包含你刚刚添加的实例。

**对称性 Symmetry** 一一第二个要求是说，任何两个对象对于“它们是否相等”的问题都必须保持一致。与第一个要求不同，若无意中违反这一条，这种情形倒是不难想象。例如下面的类，它实现了一个区分大小写的字符串。字符串由 toString 保存，但在 equals 操作中被忽略。
~~~java
// Broken - violates symmetry ! 
public final class CaseInsensitiveString { 
    private final String s; 

    public CaseinsensitiveString(String s) { 
        this.s = Objects.requireNonNull(s);
    }

    // Broken - violates symmetry ! 
    @Override public boolean equals(Object o) { 
        if (o instanceof CaseInsensitiveString)
            return s.equalsIgnoreCase((CaseinsensitiveString)o).s);
        if (o instanceof String) // One-way interoperability! 
            return s.equalsIgnoreCase((String) o) ; 
        return false;
    }
    ... // Remainde omitted
}
~~~
在这个类中， equals 方法的意图非常好，它企图与普通的字符串对象进行互操作。假设我们有一个不区分大小写的字符串和一个普通的字符串：
~~~java
CaseinsensitiveString cis =new CaseinsensitiveString("Polish");
String s = "polish";
~~~
不出所料，cis.equals(s)返回 true。问题在于，虽然 CaseInsensitiveString 类中的 equals 方法知道普通的字符串对象，但是，String 类中的 equals 方法却并不知道不区分大小写的字符串。因此 s.equals(cis)返回 false ，显然违反了对称性。假设你把不区分大小写的字符串对象放到一个集合中：
~~~java
List<CaseInsensitiveString> list = new ArrayList<>(); 
list.add(cis);
~~~
此时 list.contains(s)会返回什么结果呢？没人知道。在当前的 OpenJDK 实现中，它碰巧返回 false，但这只是这个特定实现得出的结果而已。在其他的实现中，它有可能返回 true，或者抛出一个运行时异常。一旦违反了 equals 约定，当其他对象面对你的对象时，你完全不知道这些对象的行为会怎么样。

为了解决这个问题，只需把企图与 String 互操作的这段代码从 equals 方法中去掉就可以了。这样做之后，就可以重构该方法，使它变成一条单独的返回语句：
~~~java
@Override public boolean equals(Object o) { 
    return o instanceof CaseInsensitiveString && 
        ((CaseInsensitiveString) o).s.equalsIgnoreCase(s);
}
~~~
**传递性 Transitivity** ——equals 约定的第三个要求是，如果一个对象等于第二个对象，而第二个对象又等于第三个对象，则第一个对象一定等于第三个对象。同样地，无意识地违反这条规则的情形也不难想象。用子类举个例子。假设它将一个新的值组件（value component）添加到了超类中。换句话说，子类增加的信息会影响 equals 的比较结果。我们首先以一个简单的不可变的二维整数型 Point 类作为开始：
~~~java
public class Point { 
    private final int x ; 
    private final int y; 
    
    public Point (int x, int y) { 
        this.x = x; 
        this.y = y; 
    }

    @Override public boolean equals(Object o) {
        if(!(o istanceof Point))
            return false; 
        Point p = (Point)o; 
        return p.x == x && p.y == y;
    } 
    ... // Remainde omitted
}
~~~
假设你想要扩展这个类，为一个点添加颜色信息:
~~~java
public class ColorPoint extends Point { 
    private final Color color;

    public ColorPoint(int x, int y, Color color) {
        super(x, y); 
        this color = color;
    }

    ... // Remainde omitted
}
~~~
equals 方法会是什么样的呢？如果完全不提供 equals 方法，而是直接从 Point 继承过来，在 equals 做比较的时候颜色信息就被忽略掉了。虽然这样做不会违反 equals 约定，但很明显这是无法接受的。假设编写了 equals 方法，只有当它的参数是另一个有色点，并且具有同样的位置和颜色时，它才会返回 true：
~~~java
// Broken - violates symmetry!
@Override public boolean equals(Object o) {
    if (!(o instanceof ColorPoint))
        return false; 
    return super.equals(o) && ((ColorPoint) o).color == color;
}
~~~
这个方法的问题在于，在比较普通点和有色点，以及相反的情形时，可能会得到不同的结果。前一种比较忽略了颜色信息，而后一种比较则总是返回 false ，因为参数的类型不正确。为了直观地说明问题所在，我们创建一个普通点和一个有色点：
~~~java
Point p =new Point(1, 2); 
ColorPoint cp = new ColorPoint(1, 2, Color.RED);
~~~
然后，equals(cp)返回 true, cp.equals(p)则返回 false。你可以做这样的尝试来修正这个问题，让 ColorPoint.equals 在进行“混合比较”时忽略颜色信息：
~~~java
// Broken - violates transitivity!
@Override public boolean equals(Object o) {
    if (!(o instanceof Point))
        return false;
    // If o is a normal Point, do a color－blind comparison 
    if (!(o instanceof ColorPoint))
        return o.equals(this);
 
    // o is a ColorPoint; do a fu11 comparison
    return super.equals(o) && (ColorPoint) o).color == color;
}
~~~
这种方法确实提供了对称性，但是却牺牲了传递性：
~~~java
ColorPoint p1 = new ColorPoint(1, Color.RED); 
Point p2 = new Point(1, 2); 
ColorPoint p3 = new ColorPoint(1, 2, Color.BLUE);
~~~
此时，p1.equals(p2)和 p2.equals(p3)都返回 true ，但是 p1.equals(p3) 则返回 false ，很显然这违反了传递性。前两种比较不考虑颜色信息（“色盲”），而第三种比较则考虑了颜色信息。

此外，这种方法还可能导致无限递归问题。假设 Point 有两个子类，如 ColorPoint和SmellPoint ，它们各自都带有这种 equals 方法 那么对 myColorPoint.equals(mySmellPoint ）的调用将会抛出 StackOverflowError 异常。

那该怎么解决呢？事实上，这是面向对象语言中关于等价关系的一个基本问题。**我们无法在扩展可实例化的类的同时，既增加新的值组件，同时又保留 equals约定**，除非愿意放弃面向对象的抽象所带来的优势。

你可能听说过，在 equals 方法中用 getClass 测试代替 instanceof 测试，可以扩展可实例化的类和增加新的值组件，同时保留 equals 约定：
~~~java
// Broken - violates Liskov substitution principle (page 43) 
@Override public boolean equals(Object o) { 
    if (o == null || o.getClass() != getClass()) 
        return false; 
    Point p = (Point) o; 
    return p.x == x && p.y == y; 
}
~~~
这段程序只有当对象具有相同的实现类时，才能使对象等同。虽然这样也不算太糟糕，结果却是无法接受的：Point子类的实例仍然是一个 Point，它仍然需要发挥作用，但是如果采用了这种方法，它就无法完成任务！假设我们要编写一个方法，以检验某个点是否处在单位圆中。下面是可以采用的其中一种方法：
~~~java
// Initialize unitCircle to contain all Points on the unit circle 
private static final Set<Point> unitCircle = Set.of( 
    new Point( 1, 0), new Point( 0, 1), 
    new Point(-1, 0), new Point( 0, -1)); 
public static boolean onUnitCircle(Point p){
    return unitCircle.contains(p);
}
~~~
虽然这可能不是实现这种功能的最快方式，不过它的效果很好。但是假设你通过某种不添加值组件的方式扩展了Point，例如让它的构造器记录创建了多少个实例：
~~~java
public class CounterPoint extends Point { 
    private static final AtomicInteger counter = new AtomicInteger();

    public CounterPoint(int x, int y) { 
        super(x, y); 
        counter.incrementAndGet();
    }
    public static int numberCreated() {
        return counter.get();
    } 
} 
~~~
里氏替换原则（Liskov substitution principle）认为，一个类型的任何重要属性也将适用于它的子类型，因此为该类型编写的任何方法，在它的子类型上也应该同样运行得很好。针对上述 Point 的子类（CounterPoint）仍然是Point，并且必须发挥作用的例子，这个就是它的正式语句。但是假设我们将 CounterPoint 实例传给了onUnitCircle方法。如 Point 类使用了基于 getClass 的 equals 方法，无论 CounterPoint 实例的x和y值是什么， onUnitCircle 方法都会返回 false。这是因为像 onUnitCircle 方法所用的 HashSet 这样的集合，利用 equals 方法检验包含条件，没有任何 CounterPoint 实例与任何 Point 对应。但是，如果在 Point 上使用适当的基于 instanceof 的 equals方法，当遇到 CounterPoint 时，相同的 onUnitCircle 方法就会工作得很好。

虽然没有一种令人满意的办法可以既扩展不可实例化的类，又增加值组件，但还是有种不错的权宜之计：遵从第 18 条“复合优先于继承”的建议 我们不再让 ColorPoint 扩展 Point ，而是在 ColorPoint 中加入一个私有的 Point 域，以及一个公有的视图(view）方法（详见第6条），此方法返回一个与该有色点处在相同位置的普通 Point 对象：
~~~java
// Adds a value component without violating the equals contract
public class ColorPoint { 
    private final Point point; 
    private final Color color;
    public ColorPoint(int x, int Color color) {
        point = new Point(x, y);
        this.color = Objects.requireNonNull(color);
    }

    /**
     * Returns the point-view of this color point.
     */
    public Point asPoint() { 
        return point;
    }
 
    @Override public boolean equals(Object o) { 
        if (!(o instanceof ColorPoint))
            return false; 
        ColorPoint cp = (ColorPoint) o; 
        return cp.point.equals(point) && cp.color.equals(color);
    }
    ... // Remainder omitted
}
~~~
Java 平台类库中，有一些类扩展了可实例化的类，并添加了新的值组件。例如， java.sql.Timestamp 对java.util.Date 进行了扩展，并增加了 nanoseconds 域。Timestamp 的 equals 实现确实违反了对称性，如果 Timestamp 和 Date 对象用于同一个集合中，或者以其他方式被混合在一起，则会引起不正确的行为。 Timestamp 类有一个免责声明，告诫程序员不要混合使用 Date 和 timestamp 对象。只要你不把它们混合在一起，就不会有麻烦，除此之外没有其他的措施可以防止你这么做，而且结果导致的错误将很难调试。Timestamp 类的这种行为是个错误，不值得仿效。

注意，你可以在一个抽象（abstract）类的子类中增加新的值组件且不连反 equals 约定。对于根据第 23 条的建议而得到的那种类层次结构来说，这一点非常重要。例如，你可能有一个抽象的 Shape 类，它没有任何值组件， Circle 子类添加了一个 radius 域，Reetangle 子类添加了 length和width域。只要不可能直接创建超类的实例，前面所述的种种问题就都不会发生。

**一致性 Consistency** ——equals 约定的第四个要求是，如果两个对象相等，它们就必须始终保持相等，除非它们中有一个对象（或者两个都）被修改了。换句话说，可变对象在不同的时候可以与不同的对象相等，而不可变对象则不会这样。当你在写 个类的时候，应该仔细考虑它是否应该是不可变的（详见第 17 条）。如果认为它应该是不可变的，就必须保证 equals 方法满足这样的限制条件：相等的对象永远相等，不相等的对象永远不相等。

无论类是否是不可变的，都**不要使 equals 方法依赖于不可靠的资源**。如果违反了这条禁令，要想满足一致性的要求就十分困难了。例如，java.net.URL的equals 方法依赖于对URL中主机地址的比较。将一个主机名转变成IP地址可能需要访问网络，随着时间的推移，就不能确保会产生相同的结果，即有可能地址发生了改变。这样会导致 URL equals 方法违反 equals 约定，在实践中有可能引发一些问题。URL equals 方法的行为是一个大错误并且不应被模仿。遗憾的是，因为兼容性的要求，这一行为无法被改变。为了避免发生这种问题，equals 方法应该对驻留在内存中的对象执行确定性的计算。

**非空性 Non-nullity** 一一最后一个要求没有正式名称，我姑且称它为“非空性”，意思是指所有的对象都不能等于 null。尽管很难想象在什么情况下 o.equals(null)调用会意外返回 true, 但是意外抛出 NullPointerException 异常的情形却不难想象。通用约定不允许抛出 NullPointerException 异常。许多类的 equals 方法都通过一个显式的 null 测试来防止这种情况：
~~~java
@Override public boolean equals(Object o) { 
    if (o == null)
        return false;
    ...
}
~~~
这项测试是不必要的。为了测试其参数的等同性， equals方法必须先把参数转换成适当的类型，以便可以调用它的访问方法，或者访问它的域。在进行转换之前，equals 方法必须使用instanceof 操作符，检查其参数的类型是否正确：
~~~java
@Override public boolean equals(Object o){
    if (!(o instanceof MyType)) 
        return false; 
    MyType mt = (MyType) o;
    ...
} 
~~~
如果漏掉了这一步的类型检查，并且传递给 equals 方法的参数又是错误的类型，那equals方法将会抛出 ClassCastException 异常，这就违反了 equals 约定。但是，如果 instanceof 的第一个操作数为 null ，那么，不管第二个操作数是哪种类型，instanceof 操作符都指定应该返回 false。因此，如果把 null 传给
equals 方法，类型检查就会返回 false ，所以不需要显式的 null 检查。

结合所有这些要求，得出了以下实现高质量 equals 方法的诀窍：
1. **使用==操作符检查“参数是否为这个对象的引用”**。如果是，则返回 true。这只不过是一种性能优化，如果比较操作有可能很昂贵，就值得这么做。
2. **使用instanceof 操作符检查“参数是否为正确的类型”**。如果不是，则返回 false。一般说来，所谓“正确的类型”是指 equals 方法所在的那个类。某些情况下，是指该类所实现的某个接口。如果类实现的接口改进了 equals 约定，允许在实现了该接口的类之间进行比较，那么就使用接口。集合接口如 Set、List、Map和Map.Entry 具有这样的特性。
3. **把参数转换成正确的类型**。因为转换之前进行过 instanceof 测试，所以确保会成功。
4. **对于该类中的每个“关键”（significant）域，检查参数中的域是否与该对象中对应的域相匹配**。如果这些测试全部成功，返回 true；否则返回 false。如果第2步中的类型是个接口，就必须通过接口方法访问参数中的域；如果该类型是个类，也许就能够直接访问参数中的域，这要取决于它们的可访问性。

对于既不是 float 也不是 double 类型的基本类型域，可以使用==操作符进行比较；对于对象引用域，可以递归地调用 equals 方法；对于 float 域，可以使用静态、 Float.compare(float, float)方法；对于 double 域，则使用 Double.compare(double, double)。对float 和 double 域进行特殊的处理是有必要的，因为存在着 Float.NaN、 -0.0f 以及类似的 double 常量；详细信息请参考 JLS 15.21.1 或者 Float.equals 的文档。虽然可以用静态方法 Float.equals和Double.equals对float和double域进行比较，但是每次比较都要进行自动装箱，这会导致性能下降。对于数组域，则要把以上这些指导原则应用到每一个元素上。如果数组域中的每个元素都很重要，就可以使用其中 Arrays.equals 方法。

有些对象引用域包含null可能是合法的，所以，为了避免可能导致 NullPointerException 异常，则使用静态方法 Objects.equals(Object, Object) 来检查这类域的等同性。

对于有些类，比如前面提到的 CaseInsensitiveString 类，域的比较要比简单同性测试复杂得多。如果是这种情况，可能希望保存该域的一个“范式”（canonical form），这样 equals 方法就可以根据这些范式进行低开销的精确比较，而不是高开销的非精确比较。这种方法对于不可变类（详见第 17 条）是最为合适的；如果对象可能发生变化，就必须使其范式保持最新。

域的比较顺序可能会 equals 方法的性能。为了获得最佳的性能，应该最先比较最有可能不一致的域，或者是开销最低的域，最理想的情况是两个条件同时满足的域。不应该比较那些不属于对象逻辑状态的域，例如用于同步操作的Lock域。也不需要比较衍生域(derived field），因为这些域可以由“关键域”（significant field）计算获得，但是这样做有可能提高 equals 方法的性能。如果衍生域代表了整个对象的综合描述，比较这个域可以节省在比较失败时去比较实际数据所需要的开销。例如，假设有一个 Polygon 类，并缓存了该面积。如果两个多边形有着不同的面积，就没有必要去比较它们的边和顶点。

**在编写完 equals 方法之后，应该问自己三个问题：它是否是对称的、传递的、一致的？** 并且不要只是自问，还要编写单元测试来检验这些特性，除非用 AutoValue （后面会讲到）生成 equals 方法，在这种情况下就可以放心地省略测试。如果答案是否定的，就要找出原因，再相应地修改 equals 方法的代码。当然，equals 方法也必须满足其他两个特性（自反性和非空性），但是这两种特性通常会自动满足。

根据上面的诀窍构建 equals 方法的具体例子，请看下面这个简单的 PhoneNumber 类：
~~~java
// Class with a typical equals method 
public final class PhoneNumber {
    private final short areaCode, prefix, lineNum; 
    public PhoneNumbe(int areaCode, int prefix , int lineNum) {
        this.areaCode = rangeCheck(areaCode, 999, "area code"); 
        this.prefix = rangeCheck(prefix, 999, "prefix"); 
        this.lineNum = rangeCheck(lineNum, 9999, "line num"); 
    }
    private static short rangeCheck(int val, int max, String arg) { 
        if (val < 0 || val > max) 
            throw new IllegalArgumentException(arg + ":" + val);
        return (short) val; 
    }

    @Override public boolean equals(Object o) { 
        if (o == this) 
            return true;
        if (!(o instanceof PhoneNumber))
            return false; 
        PhoneNumber pn = (PhoneNumber) o;
        return pn.lineNum == lineNum && pn.prefix == prefix
            && pn.areaCode == areaCode;
    } 
    ... // Remainder omitted
}
~~~
下面是最后的一些告诫:
- **覆盖 equals 时总要覆盖 hashCode** （详见第11条）
- **不要企图让 equals 方法过于智能**。如果只是简单地测试域中的值是否相等，则不做到遵守 equals 约定。如果想过度地去寻求各种等价关系，很容易陷入麻烦之中。把任何一种别名形式考虑到等价的范围内，往往不会是个好主意。例如，File类不应该试图把指向同一个文件的符号链接（symboli link）当作相等的对象来看待。所幸 File 类没有这样做。
- **不要将 equals 声明中的 Object 对象替换为其他的类型**。程序员编写出下面这样的 equals 方法并不鲜见，这会使程序员花上数个小时都搞不清为什么它不能正常工作：
~~~java
// Broken - parameter type must be Object! 
public boolean equals(MyClass o) { 
    ...
}
~~~
问题在于，这个方法并没有覆盖(override) Object.equals，因为它的参数应该是 Object 类型，相反，它重载（overload）了 Object.equals（详见第 52 条）。在正常 equals 方法的基础上，再提供一个“强类型”（strongly typed）的 equals 方法，这是无法接受的，因为会导致子类中的 Override 注解产生错误的正值，带来错误的安全感。

@Override 注解的用法一致，就如本条目中所示，可以防止犯这种错误（详见第 40 条）。这个 equal 方法不能编译，错误消息会告诉你到底哪里出了问题：
~~~java
// Still broken , but won't compile 
@Override public boolean equals(MyClass o) {
    ...
}
~~~
编写和测试 equals（及 hashCode）方法都是十分烦琐的，得到的代码也很琐碎。代替于手工编写和测试这些方法的最佳途径，是使用 Google 开源的 AutoValue 框架，它会自动替你生成这些方法，通过类中的单个注解就能触发。在大多数情况下，AutoValue 生成的方法本质上与你亲自编写的方法是一样的。

IDE 也有工具可以生成 equals 和 hashCode 方法，但得到的源代码比使用 AutoValue 更加冗长，可读性也更差，它无法自动追踪类中变化，因此需要进行测试。也就是说，让 IDE 生成 equals（及 hashCode）方法，通常优于手工实现它们，因为 IDE不会犯粗心的错误，但是程序员会犯错。

总而言之，不要轻易覆盖 equals 方法，除非迫不得已。因为在许多情况下，从Object 处继承的实现正是你想要的。如果覆盖 equals ，一定要比较这个类的所有关键域，并且查看它们是否遵守 equals 合约的所有五个条款。

### 第11条：覆盖equals时总要覆盖hashCode

在每个覆盖了 equals 方法的类中，都必须覆盖 hashCode 方法。 如果不这样做的话，就会违反 hashCode 的通用约定，从而导致该类无法结合所有基于散列的集合一起正常运作，这类集合包括 HashMap和HashSet。下面是约定的内容，摘自 Object 规范：
- 在应用程序的执行期间，只要对象的 equals 方法的比较操作所用到的信息没有被修改，那么对同一个对象的多次调用， hashCode 方法都必须始终返回同一个值。在一个应用程序与另一个程序的执行过程中，执行 hashCode 方法所返回的值可以
不一致。
- 如果两个对象根据 equals(Object)方法比较是相等的，那么调用这两个对象中的 hashCode 方法都必须产生同样的整数结果。
- 如果两个对象根据 equals(Object)方法比较是不相等的，那么调用这两个对象中的 hashCode 方法，则不一定要求 hashCode 方法必须产生不同的结果。但是程序员应该知道，给不相等的对象产生截然不同的整数结果，有可能提高散列表（ hashtable）的性能。

**因没有 hashCode 而违反的关键约定是第二条：相等的对象必须具有相等的散列码（hash code）**。根据类的 equals 方法，两个截然不同的实例在逻辑上有可能是相等的，但是根据 Object 类的 hashCode 方法，它们仅仅是两个没有任何共同之处的对象。因此，对象的hashCode方法返回两个看起来是随机的整数，而不是根据第二个约定所要求的那样，返回两个相等的整数。

假设在 HashMap 中用第 10 条中出现过的 PhoneNumber 类的实例作为键：
~~~java
Map<PhoneNumber, String> m = new HashMap<>();
m.put(new PhoneNumber(707, 867, 5309), "Jenny");
~~~
此时，你可能期望 m.get(new PhoneNumber(707, 867, 5309))会返回＂Jenny＂，但它实际上返回的是null。注意，这里涉及两个 PhoneNumber 实例 第一个被插入 HashMap 中，第二个实例与第一个相等，用于从 Map 中根据 PhoneNumber 去获取用户名字。由于PhoneNumber 类没有覆盖 hashCode 方法，从而导致两个相等的实例具有不相等的散列码，违反了 hashCode 的约定。因此， put方法把电话号码对象存放在一个散列桶（hash bucket）中， get方法却在另一个散列桶中查找这个电话号码。即使这两个实例正好被放到同一个散列桶中， get方法也必定会返回 null，因为 HashMap有一项优化，可以将与每个项相关联的散列码缓存起来，如果散列码不匹配，也就不再去检验对象的等同性。

修正这个问题非常简单，只需为 PhoneNumber类提供一个适当的hashCode方法即可。那么， hashCode 方法应该是什么样的呢？编写一个合法但并不好用的 hashCode 法没有任何价值。例如，下面这个方法总是合法的，但是它永远都不应该被正式使用
~~~java
// The worst possible legal hashCode implementation - never use! 
@Override public int hashCode() { return 42; }
~~~
上面这个 hashCode 方法是合法的，因为它确保了相等的对象总是具有同样的散列码。但它也极为恶劣，因为它使得每个对象都具有同样的散列码。因此，每个对象都被映射到同个散列桶中，使散列表退化为链表（linked list）。它使得本该线性时间运行的程序变成了以平方级时间在运行。对于规模很大的散列表而言，这会关系到散列表能否正常工作。

一个好的散列函数通常倾向于“为不相等的对象产生不相等的散列码”。这正是 hashCode 约定中第三条的含义。理想情况下，散列函数应该把集合中不相等的实例均匀地分布到所有可能的 int 值上。要想完全达到这种理想的情形是非常困难的。幸运的是，
相对接近这种理想情形则并不太困难。下面给出一种简单的解决办法：
~~~
1. 声明一个 int 变量并命名为 result ，将它初始化为对象中第一个关键域的散列码c，如步骤 2.a 中计算所示（如第 10 条所述，关键域是指影响equals 比较的域）。
2. 对象中剩下的每一个关键域f都完成以下步骤：
    a. 为该域计算 int 类型的散列码 C
        I. 如果该域是基本类型，则计算 Type.hashCode(f)，这里的 Type 是装箱基本类型的类，与f的类型相对应
        II. 如果该域是一个对象引用，并且该类的 equals 方法通过递归地调用 equals 的方式来比较这个域，则同样为这个域递归地调用 hashCode。如果需要更复杂的比较，则为这个域计算一个“范式”（canonical representation），然后针对这个范式调用 hashCode 如果这个域的值为 null 返回 （或者其他某个常数，但通常是0）。
        III． 如果该域是一个数组，则要把每一个元素当作单独的域来处理。就是说，递归地应用上述规则，对每个重要的元素计算一个散列码，然后根据步骤 2.b中的做法把这些散列值组合起来。如果数组域中没有重要的元素，可以使用一个常量，但最好不要用0。如果数组域中的所有元素都很重要，可以使用Arrays.hashCode 方法。
    b. 按照下面的公式，把步骤2.a中计算得到的散列码 c 合并到 result中：
        result = 31 * result + c; 
3. 返回 result。
~~~
写完了 hashCode 方法之后，问问自己“相等的实例是否都具有相等的散列码”。要编写单元测试来验证你的推断（除非利用AutoValue 生成 equals 和 hashCode 方法，这样你就可以放心地省略这些测试）。如果相等的实例有着不相等的散列码， 要找出原因，并修正错误。

在散列码的计算过程中，可以把衍生域（derived field）排除在外。换句话说，如果一个域的值可以根据参与计算的其他域值计算出来，则可以把这样的域排除在外。必须排除 equals 比较计算中没有用到的任何域，否则很有可能违反 hashCode 约定的第二条。

步骤 2.b 中的乘法部分使得散列值依赖于域的顺序，如果一个类包含多个相似的域，这样的乘法运算就会产生一个更好的散列函数。例如，如果 String 散列函数省略了这个乘法部分，那么只是字母顺序不同的所有字符串将都会有相同的散列码。之所以选择 31，是因为它是一个奇素数。如果乘数是偶数，并且乘法溢出的话，信息就会丢失，因为与2相乘等价于移位运算。使用素数的好处并不很明显，但是习惯上都使用素数来计算散列结果。31有个很好的特性，即用移位和减法来代替乘法，可以得到更好的性能： 31 * i == ( i < < 5 ) - i。现代的虚拟机可以自动完成这种优化。

现在我们要把上述解决办法用到 PhoneNumber 类中：
~~~java
// Typical hashCode method 
@Override public int hashCode() { 
    int result = Short.hashCode(areaCode);
    result = 31 * result + Short.hashCode(prefix); 
    result = 31 * result + Short.hashCode(lineNum);
    return result;
}
~~~
因为这个方法返回的结果是一个简单、确定的计算结果，它的输入只是 PhoneNumber 实例中的三个关键域，因此相等的 PhoneNumber 实例显然都会有相等的散列码。实际上，对于 PhoneNumber 的 hashCode 实现而言，上面这个方法是非常合理的，相当于 Java 平台类库中的实现。它的做法非常简单，也相当快捷，恰当地把不相等的电话号码分散到不同的散列桶中。

虽然本条目中前面给出的 hashCode 实现方法能够获得相当好的散列函数，但它们并不是最先进的。它们的质量堪 Java 平台类库的值类型中提供的散列函数，这些方法对于绝大多数应用程序而言已经足够了。如果执意想让散列函数尽可能地不会造成冲突，请
参阅 Guava’s com.google.common.hash.Hashing。

Objects 类有一个静态方法，它带有任意数量的对象，并为它们返回一个散列码。这个方法名为 hash，是让你只需要编写一行代码的 hashCode 方法，与根据本条目前面介绍过的解决方案编写出来的相比，它的质量是与之相当的。遗憾的是，运行速度更慢一些，因为它们会引发数组的创建，以便传入数目可变的参数，如果参数中有基本类型，还需要装箱和拆箱。建议只将这类散列函数用于不太注重性能的情况。下面就是用这种方法为 PhoneNumber 编写的散列函数：
~~~java
// One-line hashCode method - mediocre performance 
@Override public int hashCode() { 
    return Objects.hash(lineNum, prefix, areaCode);
}
~~~
如果一个类是不可变的，并且计算散列码的开销也比较大，就应该考虑把散列码缓存在对象内部，而不是每次请求的时候都重新计算散列码。如果你觉得这种类型的大多数对象会被用作散列键（hash keys），就应该在创建实例的时候计算散列码。否则，可以选择“延迟初始化”（lazily initialize）散列码，即一直到 hashCode 被第一次调用的时候才初始化（见第 83 条）。虽然我们的 PhoneNumber 类不值得这样处理，但是可以通过它来说明这种方法该如何实现。注意 hashCode 域的初始值（在本例中是0）一般不能成为创建的实例的散列码：
~~~java
// hashCode method with lazily initialized cached hash code 
private int hashCode; // Automatically initialized to 0 

@Override public int hashCode() { 
    int result = hashCode; 
    if (result == 0) { 
        result = Short.hashCode(areaCode);
        result = 31 * result + Short.hashCode(prefix);
        result = 31 * result + Short.hashCode(lineNum);
        hashCode = result;
    }
    return result;
}
~~~

**不要试图从散列码计算中排除掉一个对象的关键域来提高性能**。虽然这样得到的散列函数运行起来可能更快，但是它的效果不见得会好，可能会导致散列表慢到根本无法使用。特别是在实践中，散列函数可能面临大量的实例，在你选择忽略的区域之中，这些实例仍然区别非常大。如果是这样，散列函数就会把所有这些实例映射到极少数的散列码上，原本应该以线性级时间运行的程序，将会以平方级的时间运行。

这不只是一个理论问题。Java2 发行版本之前，一个String 列函数最多只能使16 个字符，若长度少于16个字符就计算所有的字符，否则就从第一个字符开始，在整个字符串中间隔均匀地选取样本进行计算。对于像 URL 这种层次状名称的大型集合，该散列
函数正好表现出了这里所提到的病态行为。

**不要对 hashCode 方法的返回值做出具体的规定，因此客户端无法理所当然地依赖它；这样可以为修改提供灵活性**。Java 类库中的许多类，比如 String 和 Integer，都可以把它们的 hashCode 方法返回的确切值规定为该实例值的一个函数。一般来说，这并不是个好主意，因为这样做严格地限制了在未来的版本中改进散列函数的能力。如果没有规定散列函数的细节，那么当你发现了它的内部缺陷时，或者发现了更好的散列函数时，就可以在后面的发行版本中修正它。

总而言之，每当覆盖 equals 方法时都必须覆盖 hashCode ，否则程序将无法正确运行。hashCode 方法必须遵守 Object 规定的通用约定，并且必须完成一定的工作，将不相等的散列码分配给不相等的实例。这个很容易实现，但是如果不想那么费力，也可以使用前文建议的解决方法。如第 10 条所述，AutoValue 框架提供了很好的替代方法，可以不必手工编写 equals 和 hashCode 方法，并且现在的集成开发环境 IDE 也提供了类似的部分功能。

### 第12条：始终要覆盖toString

虽然 Object 提供了 toString 方法的一个实现，但它返回的字符串通常并不是类的用户所期望看到的。它包含类的名称，以及一个“＠”符号，接着是散列码的无符号十六进制表示法，例如 `PhoneNumber@163b91`。toString 的通用约定指出，被返回的字符串应该是一个“简洁的但信息丰富，并且易于阅读的表达形式”。toString 约定进一步指出，“建议所有的子类都覆盖这个方法。“

遵守 toString 约定并不像遵守 equals hashCode 的约定（见第 10 条和第 11 条）那么重要，但是， **提供好的 String 实现可以便类用起来更加舒适，使用了这个类的系统也更易于调试。**当对象被传递给 println、 printf 、字符串联操作符（＋）以及 assert ，或者被调试器打印出来时， toString 方法会被自动调用。即使你永远不调用对象的 toString 方法，但是其他人也许可能需要。例如，带有对象引用的一个组件，在它记录的错误消息中，可能包含该对象的字符串表示法 如果你没有覆盖 toString ，这条消息可能就毫无用处。

提供好的 toString 方法，不仅有益于这个类的实例，同样也有益于那些包含这些实例的引用的对象，特别是集合对象。打印Map 时会看到消息｛Jenny= Phon Number@l63b91 ｝或 {Jenny = 707-867-5309 ｝，你更愿意看到哪一个？

**在实际应用中， toString 方法应该返回对象中包含的所有值得关注的信息**， 例如上述电话号码例子那样 如果对象太大，或者对象中包含的状态信息难以用字符串来表达，这样做就有点不切实际。在这种情况下， toString 应该返回一个摘要信息，例如“Manhattan residential phone directory ( 1487536 listings ）”或者“ Thread [main , 5 , main ］” 。理想情况下，字符串应该是 自描述的（ self-explanatory）。（ Thread 例子不满足这样的要求 ）

在实现 toString 的时候，必须要做出一个很重要的决定 ：是否在文档中指定返回值的格式。对于值类（ value class ）， 比如电话号码类、矩阵类 ，建议这么做 指定格式的好处是，它可以被用作一种标准的 、明确的、适合人阅读的对象表示法。这种表示法可以用于输入和输出，以及用在永久适合人类阅读的数据对象中 ，例如 csv 文档。如果你指定了格式，通常最好再提供一个相匹配的静态工厂或者构造器，以便程序员可以很容易地在对象及其字符串表示法之间来回转换。Java 平台类库中的许多值类都采用了这种做法，包括 Biginteger, BigDecimal 和绝大多数的基本类型包装类（ boxed primitive class）。

指定 toString 返回值的格式也有不足之处：如果这个类已经被广泛使用，一旦指定格式，就必须始终如 地坚持这种格式 程序员将会编写出相应的代码来解析这种字符串表示法、产生字符串表示法，以及把字符串表示法嵌入持久的数据中。如果将来的发行版本中改变了这种表示法，就会破坏他们的代码和数据，他们当然会抱怨。如果不指定格式，就可以保留灵活性，便于在将来的发行版本中增加信息，或者改进格式。

**无论是否决定指定格式，都应该在文档中明确地表明你的意图。**如果要指定格式，则应该严格地这样去做。

如果你决定不指定格式，那么文档注释部分也应该有指示信息。

对于那些依赖于格式的细节进行编程或者产生永久数据的程序员，在读到这段注释之后，一旦格式被改变， 只能自己承担后果

无论是否指定格式， 都为 toString 返回值中包含的所有信息提供一种可以通过编程访问之的途径。如果不这么做，就会迫使需要这些信息的程序员不得不自己去解析这些字符串。除了降低了程序的性能，使得程序员们去做这些不必要的工作之外，这个解析过程也很容易出错，会导致系统不稳定，如果格式发生变化，还会导致系统崩溃。如果没有提供这些访问方法，即使你已经指明了字符串的格式是会变化的，这个字符串格式也成了事实上的 API。

在静态工具类（详见第 条）中编写 toString 方法是没有意义的。也不要在大多数枚举类型（详见第 34 条）中编写 toString 方法，因为 Java 已经为你提供了非常完美的方法。但是，在所有其子类共享通用字符串表示法的抽象类中，一定要编写一个 toString 方法。例如，大多数集合实现中的 toString 方法都是继承自抽象的集合类。

总而言之，要在你编写的每一个可实例化的类中覆盖 Object 的 toString 实现，除非已经在超类中这么做了。这样会使类使用起来更加舒适，也更易于调试。 toString 方法应该以美观的格式返回一个关于对象的简洁、有用的描述。

### 第13条：谨慎地覆盖clone

Cloneable 接口的目的是作为对象的一个 mixin 接口（mixin interface ) （详见第20条），表明这样的对象允许克隆（ clone）。遗憾的是，它并没有成功地达到这个目的。它的主要缺陷在于缺少一个 clone 方法，而Object 的 clone 方法是受保护的。如果不借助于反射( reflection) （详见第65条），就不能仅仅因为一个对象实现了 Cloneable ，就调用 clone 方法。即使是反射调用也可能会失败，因为不能保证该对象一定具有可访问的 clone 方法。尽管存在这样或那样的缺陷，这项设施仍然被广泛使用，因此值得我们进一步了解条目将告诉你如何实现一个行为良好的 clone 方法，并讨论何时适合这样做，同时也简单地讨论了其他的可替代做法。

既然 Cloneable 接口并没有包含任何方法，那么它到底有什么作用呢？它决定了 Object 中受保护的 clone 方法实现的行为：如果一个类实现了 Cloneable, Object clone 方法就返回该对象的逐域拷贝，否则就会抛出 CloneNotSupportedException 异常。这是接口的一种极端非典型的用法，也不值得仿效。通常情况下，实现接口是为了表明类可以为它的客户做些什么。然而，对于 Cloneable 接口，它改变了超类中受保护的方法的行为。

虽然规范中没有明确指出， **事实上，实现 Cloneable 接口的类是为了提供一个功能适当的公有的 clone 方法**。为了达到这个目的，类及其所有超类都必须遵守一个相当复杂的、不可实施的，并且基本上没有文档说明的协议。由此得到一种语言之外的（ extralinguistic) 机制：它无须调用构造器就可以创建对象。

clone 方法的通用约定是非常弱的，下面是来自 Object 规范中的约定内容：

创建和返回该对象的一个拷贝。这个“拷贝”的精确含义取决于该对象的类一般的含义是

- 对于任何对象 ，表达式`x.clone() != x `将会返回结果 true 
- 并且表达式`x.clone().getζlass() == x.getClass() `将会返回结果 true ，但这些都不是绝对的要求。
- 虽然通常情况下，表达式`x.clone() .equals(x) `将会返回结果 true ，但是，这也不是一个绝对的要求。

按照约定，这个方法返回的对象应该通过调用 super.clone 获得。如果类及其超类（ Object 除外）遵守这一约定，那么：`x.clone() .getClass() == x.getClass()` . 按照约定，返回的对象应该不依赖于被克隆的对象。为了成功地实现这种独立性，可能需要在 super.clone 返回对象之前，修改对象的一个或更多个域。







为继承（详见第四条）设计类有两种选择，但是无论选择其中的哪一种方法，这个类都不应该实现 Cloneable 接口。你可以选择模拟 Object 的行为：实现一个功能适当的受保护的 clone 方法，它应该被声明抛出 CloneNotSupportedException 异常。这样可以使子类具有实现或不实现 Cloneable 接口的自由，就仿佛它们直接扩展了 Object一样。或者，也可以选择不去实现一个有效的 clone 方法，并防止子类去实现它，只需要提供下列退化了的 clone 实现即可：

~~~java
// clone method fo extendable class not supporting Cloneable 
@Override
protected final Object clone() throws CloneNotSupportedException { 
	throw new CloneNotSupportedException();
}
~~~

还有一点值得注意，如果你编写线程安全的类准备实现 Cloneable 接口，要记住它的 clone 方法必须得到严格的同步，就像任何其他方法一样（详见第 78 条） Object 的 clone 方法没有同步，即使很满意也可能也必须编写同步的 clone 方法来调用 super.clone()，即实现 synchronized clone() 方法。

简而言之，所有实现了 Cloneable 接口的类都应该覆盖 clone 方法，并且是公有的方法，它的返回类型为类本身 该方法应该先调用 super.clone 方法，然后修正任何需要修正的域。一般情况下，这意味着要拷贝任何包含内部“深层结构”的可变对象，并用指向新对象的引用代替原来指向这些对象的引用。虽然，这些内部拷贝操作往往可以通过递归地调用 clone 来完成，但这通常并不是最佳方法。如果该类只包含基本类型的域，或者指向不可变对象的引用，那么多半的情况是没有域需要修正。这条规则也有例外。例如，代表序列号或其他唯一 ID 值的域，不管这些域是基本类型还是不可变的，它们也都需要被修正。

如果你扩展一个实现了 Cloneable 接口的类，那么你除了实现一个行为良好的 clone 方法外，没有别的选择。否则，最好提供某些其他的途径来代替对象拷贝。**对象拷贝的更好的办法是提供一个拷贝构造器（ copy constructor）或拷贝工厂（ copy factory）**。 拷贝构造器只是一个构造器，它唯一的参数类型是包含该构造器的类，例如：

~~~java
// Copy constructor 
public Yum(Yum yum){...}
~~~

拷贝工厂是类似于拷贝构造器的静态工厂（详见第1条）：

~~~java
// Copy factory 
public static Yum newInstance(Yum yum){ ... }
~~~

拷贝构造器的做法，及其静态工厂方法的变形，都比 Cloneable/clone 方法具有更多的优势：它们不依赖于某一种很有风险的、语言之外的对象创建机制；它们不要求遵守尚未制定好文档的规范；它们不会与 final 域的正常使用发生冲突；它们不会抛出不必要的受检异常；它们不需要进行类型转换。

既然所有的问题都与 Cloneable 接口有关，新的接口就不应该扩展这个接口，新的可扩展的类也不应该实现这个接口。虽然 final 类实现 Cloneable 口没有太大的危害，这个应该被视同性能优化，留到少数必要的情况下才使用（详见第 67 条）。总之，复制功能最好由构造器或者工厂提供 这条规则最绝对的例外是数组，最好利用 clone 方法复制数组。

### 第14条：考虑实现Comparable接口

总而言之，每当实现一个对排序敏感的类时，都应该让这个类实现 Comparable 接口，以便其实例可以轻松地被分类、搜索，以及用在基于比较的集合中。每当在 compareTo 方法的实现中比较域值时，都要避免使用`<` 和`>`操作符，而应该在装箱基本类型的类中使用静态的 compare 方法，或者在 Comparator 接口中使用比较器构造方法。

## 第4章 类和接口

### 第15条：使类和成员的可访问性最小化

区分一个组件设计得好不好，唯一重要的因素在于，它对于外部的其他组件而言，是否隐藏了其内部数据和其他实现细节。设计良好的组件会隐藏所有的实现细节，把API与实现清晰地隔离开来。然后，组件之间只通过API进行通信，一个模块不需要知道其他模块的内部工作情况。这个概念被称为**信息隐藏**（ infomation hiding ）或封装（ encapsulation ), 是软件设计的基本原则之一。

规则很简单：**尽可能地使每个类或者成员不被外界访问**。换句话说，应该使用与你正在编写的软件的对应功能相一致的、尽可能最小的访问级别。

对于成员（域、方法、嵌 类和嵌套接口）有四种可能的访问级别，下面按照可访问性的递增顺序罗列出来：

- 私有的 （private） ——只有在声明该成员的顶层类内部才可以访问这个成员。
- 包级私有的 （package-private） 一一声明该成员的包内部的任何类都可以访问这个成员。从技术上讲，它被称为“缺省”（ default ）访问级别，如果没有为成员指定访问修饰符，就采用这个访问级别（当然，接口成员除外，它们默认的访问级别是公有的）
- 受保护的 （protected） 一一声明该成员的类的子类可以访问这个成员（但有一些限制 [ JLS. 6.6]），并且声明该成员的包内部的任何类也可以访问这个成员
- 公有的 （public） ——在任何地方都可以访问该成员

### 第16条：要在公有类而非公有域中使用访问方法

毫无疑问，说到公有类的时候，坚持面向对象编程思想的看法是正确的；**如果类可以在它所在的包之外进行访问，就提供访问方法**， 以保留将来改变该类的 内部表示法的灵活性。如果公有类暴露了它的数据域 ，要想在将来改变其内部表示法是不可能的，因为公有类户端代码已经遍布各处了。

然而，**如果类是包级私有的，或者是私有的嵌套类， 直接暴露它的数据域并没有本质的错误**——假设这些数据域确实描述了该类所提供的抽象。无论是在类定义中，还是在使用该类的客户端代码中，这种方法比访问方法的做法更不容易产生视觉混乱。虽然客户端代码与该类的内部表示法紧密相连，但是这些代码被限定在包含该类的包中 如有必要，也可以不改变包之外的任何代码，而只改变内部数据表示法。在私有嵌套类的情况下，改变的范围被进一步限制在外围类中

简而言之，公有类永远都不应该暴露可变的域。虽然还是有问题，但是让公有类暴露不可变的域，其危害相对来说比较小。但有时候会需要用包级私有的或者私有的嵌套类来暴露域，无论这个类是可变的还是不可变的。

### 第17条：使可变性最小化

不可变类是指其实例不能被修改的类。每个实例中包含的所有信息都必须在创建该实例的时候就提供，并在对象的整个生命周期（ lifetime ）内固定不变 。Java 平台类库中包含许多不可变的类，其中有 String 、基本类型的包装类、 Biginteger 和 BigDecimal。存在不可变的类有许多理由：不可变的类比可变类更加易于设计、实现和使用。它们不容易出错，且更加安全。

为了使类成为不可变，要遵循下面五条规则：

1. **不要提供任何会修改对象状态的方法**（也称为设值方法）
2. **保证类不会被扩展**。这样可以防止粗心或者恶意的子类假装对象的状态已经改变，从而破坏该类的不可变行为。为了防止子类化，一般做法是声明这个类成为 final ，但是后面我们还会讨论到其他的做法。
3. **声明所有的域都是 final**。 通过系统的强制方式可以清楚地表明你的意图。而且，如果一个指向新创建实例的引用在缺乏同步机制的情况下，从一个线程被传递到另一个线程，就必须确保正确的行为，正如内存模型（ memory model ）中所述［ JLS, 17.5; Goetz06 16]。
4. **声明所有的域都为私有的**。 这样可以防止客户端获得访问被域引用的可变对象的权限，井防止客户端直接修改这些对象。虽然从技术上讲，允许不可变的类具有公有的 final域，只要这些域包含基本类型的值或者指向不可变对象的引用，但是不建议这样做，因为这样会使得在以后的版本中无法再改变内部的表示法（详见第 15 条和第 16 条）。
5. **确保对子任何可变组件的互斥访问**。如果类具有指向可变对象的域，则必须确保该类的客户端无法获得指向这些对象的引用。并且，永远不要用客户端提供的对象引用来初始化这样的域，也不要从任何访问方法（ accessor ）中返回该对象引用。在构造器、访问方法和 readObject 方法（详见第 88 条）中请使用保护性拷贝（ defensive cop ）技术（详见第 50 条）。

**不可变对象本质上是线程安全的，它们不要求同步**。当多个线程并发访问这样的对象时，它们不会遭到破坏。这无疑是获得线程安全最容易的办法。实际上，没有任何线程会注意到其他线程对于不可变对象的影响。所以， **不可变对象可以被自由地共享**。不可变类应该充分利用这种优势，鼓励客户端尽可能地重用现有的实例。要做到这一点，一个很简便的办法就是：对于频繁用到的值，为它们提供公有的静态 final 常量。

### 第18条：复合优先于继承