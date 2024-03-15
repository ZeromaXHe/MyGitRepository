# 第5章 继承

继承（inheritance）

反射（reflection）

## 5.1 类、超类和子类

关键字extends表示继承。

*C++注释：Java与C++定义继承类的方式十分相似。Java用关键字extends代替了C++中的冒号（：）。在Java中，所有的继承都是共有继承，而没有C++中的私有继承和保护继承。*

关键字extends表明正在构造的新类派生于一个已存在的类。已存在的类称为**超类（superclass）**、**基类（base class）**或**父类（parent class）**；新类称为**子类(subclass)**、**派生类（derived class）**或**孩子类（child class）**。超类和子类是Java程序员最常用的两个术语，而了解其他语言的程序员可能更加偏爱使用父类和孩子类，这些都是继承时使用的术语。

*注释：前缀“超”和“子”来源于计算机科学和数学理论中的集合语言的术语。所有雇员组成的集合包含所有经理组成的集合。可以这样说，雇员集合是经理集合的超级，也可以说，经理级和是雇员集合的子集。*

在通过扩展超类定义子类的时候，仅需要指出子类与超类的不同之处。因此，在设计类的时候，应该将通用的方法放在超类中，而将特殊用途的方法放在子类中。

但，超类中的有些方法对子类不一定适用，为此需要提供一个新的方法来**覆盖（override）**超类中的这个方法。

子类方法不能够直接访问超类的私有域。一定要访问私有域的话，就必须借助于共有的接口，如getSalary()。我们希望调用超类的方法，而不是当前类的这个方法，可以适用关键字super解决这个问题。

*注释：有人认为super和this引用是类似的概念，实际上，这种比较并不太恰当。这是因为super不是一个对象的引用，不能将super赋给另一个对象变量，它只是一个指示编译器调用超类方法的特殊关键字。*

子类中可以增加域、增加方法或覆盖超类的方法，然而绝对不能删除继承的任何域和方法。

*C++注释：在Java中使用关键字super调用超类的方法，而在C++中则采用超类名加上`::`操作符的形式*

super在构造器中的应用：调用超类构造器。必须是子类构造器的第一条语句。

如果子类构造器没有显式地调用超类的构造器，则将自动地调用超类默认（没有参数）的构造器。如果超类没有不带参数的构造器，而子类构造器又没有显式地调用超类其他构造器，Java编译器将报告错误。

*注释：回忆一下，关键字this有两个用途：一是引用隐式参数，二是调用该类其他的构造器。同样，super关键字也有两个用途：一是调用超类的方法，二是调用超类的构造器。在调用构造器的时候，这两个关键字的使用方式很相似。调用构造器的语句只能作为另一个构造器的第一条语句出现。构造参数既可以传递给本类（this）的其他构造器，也可以传递给超类（super）的构造器。*

*C++注释：在C++的构造函数中，使用初始化列表语法调用超类的构造函数，而不调用super。*

一个对象变量（例如，变量e）可以指示多种实际类型的现象被称为**多态（polymorphism）**。在运行时能够自动地选择调用哪个方法的现象称为**动态绑定（dynamic binding）**。

*C++注释：在Java中，不需要将方法声明为虚拟方法。动态绑定是默认的处理方式。如果不希望让一个方法具有虚拟特征，可以将它标记为final（稍后介绍关键字final）。*

### 5.1.1 继承层次

由一个公共超类派生出来的所有类的集合被称为**继承层次（inheritance hierarchy）**。在继承层次中，从某个特定的类到其祖先的路径被称为该类的**继承链（inheritance chain）**。

*C++注释：Java不支持多继承。有关Java中多继承功能的实现方式，请参看下一章6.1节有关接口的讨论。*

### 5.1.2 多态

有一个用来判断是否应该设计为继承关系的简单规则，这就是"is-a"规则，它表明子类的每一个对象也是超类的对象。

"is-a"规则的另一种表述法是**置换法则**。它表明程序中出现超类对象的任何地方都可以用子类对象置换。

在Java中，对象变量是多态的。一个变量既可以引用本类的对象，也可以引用子类的对象。

``` java
Manager boss = new Manager(...);
Employee[] staff = new Employee[3];
staff[0]=boss;
```

在这个例子中，变量staff[0]与boss引用同一对象。但编译器将staff[0]看成Employee对象，所以不能调用Manager类的setBonus方法。而boss可以。

*警告：在Java中，子类数组的引用可以转换成超类数组的引用，而不需要采用强制类型转换。下面是一个经理数组`Manager[] manager = new Manager[10];`将它转换成Employee[]数组是完全合法的：`Employee[] staff = managers;`。然而这样之后，manager和staff引用了同一数组。现在看这条语句：`staff[0] = new Employee("Harry Hacker", ...);` 编译器竟然接纳了这个赋值操作。但在这里，staff[0]与manager[0] 引用的是同一个对象，似乎我们把一个普通雇员擅自归入经理行列中了。这是一种很忌讳发生的情形，当调用managers[0].setBonus(1000)的时候，将会导致调用一个不存在的实例域，进而搅乱相邻存储空间的内容。*

*为了确保不发生这类错误，所有数组都要牢记创建它们的元素类型，并负责监督仅将类型兼容的引用存储到数组中。*

*如果试图存储一个Employee类型的引用就会引发ArrayStoreException异常*

### 5.1.3 动态绑定

调用过程的详细描述：

1） 编译器查看对象的声明类型和方法名。可能存在多个名字相同为f，参数类型不一样的方法。编译器将会一一列举所有C类中名为f的方法和其超类中访问属性为public且名为f的方法。

至此，编译器已获得所有可能被调用的候选方法。

2）接下来，编译器将查看调用方法时提供的参数类型。如果在所有名为f的方法中存在中存在一个与提供的参数类型完全匹配，就选择这个方法。这个过程被称为**重载解析（overloading resolution）**。由于允许类型转换，所以这个过程可能很复杂。如果编译器没有找到与参数类型匹配的方法，或者发现经过类型转换后有多个方法与之匹配，就会报告一个错误。

至此，编译器已获得需要调用的方法名字和参数类型。

*注释：前面曾经说过，方法的名字和参数列表称为方法的签名。如果在子类中定义了一个与超类签名相同的方法，那么子类中的这个方法就覆盖了超类中的这个相同签名的方法。*

*不过返回类型不是签名的一部分。因此，在覆盖方法时，一定要保证返回类型的兼容性。允许子类将覆盖方法的返回类型定义为原返回类型的子类型。我们说这两个方法具有可协变的返回类型。*

3） 如果是private方法、static方法、final方法（有关final修饰符的含义在下一章表述）或者构造器，那么编译器将可以准确地知道应该调用哪个方法，我们将这种调用方式称为**静态绑定（static binding）**。与此对应的是，调用的方法依赖于隐式参数的实际类型，并且在运行时实现动态绑定。在我们列举的示例中，编译器采用动态绑定的方式生成一条调用f(String)的指令。

4）当程序运行，并且采用动态绑定调用方法时，虚拟机一定调用与x所引用对象的实际类型最合适的那个类的方法。先在本类寻找，没有就去超类中寻找。

每次调用方法都要进行搜索，时间开销相当大。因此，虚拟机预先为每个类创建了一个**方法表（method table）**，其中列出了所有方法的签名和实际调用的方法。这样依赖，在真正调用方法的时候，虚拟机仅查找这个表就行了。这里要提醒一点，如果调用super.f(param)。编译器将对隐式参数超类方法表进行搜索。

动态绑定有一个非常重要的特性：无需对现存代码进行修改，就可以对程序进行扩展。

*警告：在覆盖一个方法的时候，子类方法不能低于超类方法的可见性。*

### 5.1.4 阻止继承：final类和方法

有时候，可能希望阻止人们利用某个类定义子类。不允许扩展的类被称为final类。如果在定义类的时候使用了final修饰符就表明这个类是final类。

*注释：前面曾经说过，域也可以被声明为final。对于final域来说，构造对象之后就不允许改变它们的值了。不过，如果将一个类声明为final，只有其中的方法自动地成为final，而不包括域。*

将方法或类声明为final主要目的是：确保它们不会在子类中改变语义。

**内联（inline）**：一个方法没被覆盖而且很短，编译器能够对它进行优化处理

### 5.1.5 强制类型转换

子类的引用赋给一个超类，编译器是允许的。但将一个超类的引用赋给一个子类变量，必须进行类型转换，这样才能通过运行时的检查。

instanceof运算符

*注释：x为null，x instanceof C不会产生异常，只是返回false*

尽量少用类型转换和instanceof运算符。

*C++注释：C++dynamic_cast操作*

### 5.1.6 抽象类

只将它作为派生其他类的基类，而不作为想使用的特定实例类。

包含一个或多个抽象方法的类本身必须被声明为抽象的。除了抽象方法之外，抽象类还可以包含具体数据和具体方法。

*提示：建议尽量将通用的域和方法（不管是否是抽象的）放在超类（不管是否是抽象类）中*

抽象方法充当着占位的角色，它们的具体实现在子类中。子类中定义部分抽象方法或抽象方法也不定义，则必须将子类标记为抽象类。全部定义抽象方法才不是抽象的。

类即使不含抽象方法，也可以将类声明为抽象类。

抽象类不能实例化。可以定义一个抽象类的对象变量，但是它只能引用非抽象子类的对象。

*C++注释：尾部用=0标记的抽象方法，称为纯虚函数。有一个纯虚函数，这个类就是抽象类。C++没有提供用于表示抽象类的特殊关键字。*

### 5.1.7 受保护访问

protected，允许子类访问。

*C++注释：Java中的protected概念要比C++中的安全性差。*

## 5.2 Object：所有类的超类

Object类是Java所有类的始祖，在Java中每个类都是由它扩展来的。

如果没有明确指明超类，Object就被认为是这个类的超类。

可以使用Object类型引用任何类型的对象。

在Java中，只有基本类型（primitive types）不是对象。==所有的数组类型，不管是对象数组还是基本类型数组都扩展于Object类。==

*C++注释：在C++中没有所有类的根类，不过每个指针都可以转换为void\*指针。*

### 5.2.1 equals方法

在Object类中，这个方法将判断两个对象是否具有相同的引用。

getClass方法返回一个对象所属的类。

*提示：为了防备.equals前的变量可能为null的情况，需要使用Object.equals(a, b)方法。*

### 5.2.2 相等测试与继承

如果隐式和显式的参数不属于同一个类，equals方法如何处理？类不匹配，返回false。许多程序员喜欢使用instanceof来进行检测，这样做不但没有解决otherObject是子类的情况，并且可能招致一些麻烦。所以不建议使用这种方式。

Java语言规范要求equals方法具有下面特性：

1）自反性

2）对称性

3）传递性

4）一致性

5）非空引用x.equals(null)应该返回false。

下面可以从两个截然不同的情况看一下这个问题：

- 如果子类能够拥有自己相等概念，则对称性需求将强制采用getClass进行检测。
- 如果超类决定相等概念，那么就可以使用instanceof进行检测，这样可以在不用子类对象之间进行相等的比较。

*注释：标准Java库中包含150多个equals方法实现，包括使用instanceof检测、调用getClass检测、捕获ClassCastException或者什么也不做。*

下面给出编写一个完美的equals方法的建议：

1. 显式参数命名为otherObject， 稍后需要将它转换成另一个叫做other的变量。
2. 检测this与otherObject是否引用同一个对象。
3. 检测otherObject是否为null，如果为null，返回false。
4. 比较this与otherObject是否属于同一类。如果equals的语义在每个子类中有所改变，就用getClass检测。如果都有子类都有统一的语义，就用instanceof检测。
5. 将otherObject转换为相应的类类型变量
6. 现在开始对所有需要比较的域进行比较了。使用==比较基本类型域，使用equals比较对象域。如果所有的域都匹配，就返回true；否则返回false。

如果在子类中重新定义equals，就要在其中包含调用super.equals(other)。

*提示：对于数组类型的域，可以使用静态的Arrays.equals方法检测相应的数组元素是否相等。*

*警告：可以使用@Override对覆盖超类的方法进行标记。*

【API】java.util.Arrays 1.2

- `static Boolean equals(type[] a, type[] b)` 5.0

【API】java.util.Objects 7

- `static boolean equals(Object a, Object b)`

### 5.2.3 hashCode方法

**散列码（hash code）**是由对象导出的一个整型值。

hashCode方法定义在Object类中，因此每个对象都有一个默认的散列码，其值为对象的存储地址。

字符串的散列码是由内容导出的。而没有定义hashCode方法的类的散列码是由Object类的默认hashCode方法导出的对象存储地址。

如果重新定义equals方法，就必须重新定义hashCode方法，以便用户可以将对象插入到散列表中。

hashCode方法应该返回一个整型数值（也可以是负数），并合理地组合实例域的散列码，以便能够让各个不同的对象产生的散列码更加均匀。

Java 7中可以做两个改进。首先，最好使用null安全的方法Objects.hashCode. 需要组合多个散列值时，可以调用Object.hash并提供多个参数。这个方法会对各个参数调用Object.hashCode，并组合这些散列值。

*提示：如果存在数组类型的域，那么可以使用静态的Arrays.hashCode方法计算一个散列码，这个散列码由数组元素的散列码组成。*

【API】java.lang.Object 1.0

- `int hashCode()`

【API】java.lang.Objects 7

- `int hash(Object... objects)`
- `static int hashCode(Object a)`

【API】java.util.Arrays 1.2

- static int hashCode(type[] a) 5.0

### 5.2.4 toString方法

在Object中还有一个重要的方法，就是toString方法，它用于返回表示对象值的字符串。下面是一个典型的例子。Point类的toString方法将返回下面这样的字符串：

`java.awt.Point[x=10,y=20]`

绝大多数（但不是全部）的toString方法都遵循这样的格式：类的名字，随后是一对方括号括起来的域值。

随处可见toString方法的主要原因是：只要对象与一个字符串通过操作符"+"连接起来，Java编译就会自动地调用toString方法，以便获得这个对象的字符串描述。

*提示：在调用x.toString()的地方可以用""+x替代。与toString不同的是，如果x是基本类型，这条语句照样能够执行。*

Object类定义了toString方法，用来打印输出对象所属的类名和散列码。

*警告：数组继承了Object类的toString方法。修正的方式是调用静态方法Arrays.toString。要想打印多维数组（即，数组的数组）则需要调用Arrays.deepToString方法。*

toString方法是一种非常有用的调试工具。读者在第11章将可以看到，更好的解决方法是：`Logger.global.info("Current position = "+position);`

*提示：强烈建议为自定义的每一个类增加toString方法。这样做不仅自己受益，而且所有使用这个类的程序员也会从这个日志记录支持中受益匪浅。*

【API】java.lang.Object 1.0：

- `Class getClass()`
- `boolean equals (Object otherObject)`
- `String toString()`

【API】java.lang.Class 1.0 ：

- `String getName()`
- `Class getSuperClass()`

## 5.3 泛型数组列表

C语言中必须在编译时就确定整个数组的大小。

Java中，允许在运行时确定数组的大小。

一旦确定了数组的大小，改变它就太不容易了。在Java中，解决这个问题的最简单方法是使用Java中另外一个被称为ArrayList的类。它添加或删除元素时，具有自动调节数组容量的功能，而不需要为此编写任何代码。

ArrayList是一个采用类型参数（type parameter）的泛型类（generic class）。为了指定数组列表保存的元素对象类型，需要用一对尖括号将类名括起来加在后面，例如，ArrayList\<Employee>。在第13章将可以看到如何自定义一个泛型类。

Java7中，可以省去右边的类型参数：`ArrayList<Employee> staff = new ArrayList<>();`

这被称为"菱形"语法，因为空尖括号\<>就像一个菱形。

*注释：Java SE 5.0以前的版本没有提供泛型类，而是有一个ArrayList类，其中保存类型为Object的元素，它是"自适应大小"的集合。在Java SE 5.0以后的版本中，没有后缀\<...> 仍然可以使用ArrayList，它将被认为是一个删去了类型参数的"原始"类型。*

*注释：在Java老版本中，程序员使用Vector类实现动态数组。不过ArrayList类更加有效，没有任何理由一定要用Vector类。*

使用add方法可以将元素添加到ArrayList中。

ArrayList管理着对象引用的一个内部数组。如果调用add且内部数组已经满了，ArrayList将自动地创建一个更大的数组，并将所有对象拷贝到较大数组中。

如果已经清楚或能估计出数组可能存储的元素数量，就可以在填充数组之前调用ensureCapacity方法。

另外还可以把初始容量传递给ArrayList构造器：`ArrayList<Employee> staff = new ArrayList<>(100);`

*警告：数组列表和数组大小有一个非常重要的区别。如果为数组分配100个元素的存储空间，数组就有100个空位置可以使用。而容量为100个元素的数组列表只是拥有保存100个元素的潜力（实际上，重新分配空间的话，将会超过100），但是在最初，甚至完成初始化构造之后，数组列表根本就不含有任何元素。*

size方法将返回数组列表中包含的实际元素数目。它等价于数组a的a.length。

一旦能够确认数组列表的大小不再发生变化，就可以调用trimToSize方法。这个方法将存储区域的大小调整为当前元素数量所需要的存储空间数目。垃圾回收器将回收多余的存储空间。

*C++注释：ArrayList类似于C++的vector模板。ArrayList与vector都是泛型类型。但是C++的vector模板为了便于访问元素重载了[ ]运算符。由于Java没有运算符重载，所以必须调用显示的方法。此外，C++向量是值拷贝，a=b会构造一个和b长度一样的新向量a。而在Java中，让a和b引用同一个数组列表。*

【API】java.util.ArrayList\<T> 1.2：

- `ArrayList<T>()`
- `ArrayList<T>(int initialCapacity)`
- `boolean add(T obj)`
- `int size()`
- `void ensureCapacity(int capacity)`
- `void trimToSize()`

### 5.3.1 访问数组列表元素

使用get和set方法实现访问或改变数组元素的操作，而不使用人们喜爱的[]语法格式。

`staff.set(i,harry);`等价于数组a的元素赋值（下表从0开始）：`a[i]=harry;`

*警告：只有i小于或等于数组列表的大小时，才能够调用list.set(i,x)。使用add方法为数组添加新元素，而不要使用set方法，它只能替换数组中已经存在的元素内容。*

`Employee e = staff.get(i);`等价于`Employee e =a[i];`

*注释：没有泛型类时，原始的ArrayList类提供的get方法别无选择只能返回Object，因此，get方法的调用者必须对返回值进行类型转换。*

*原始的ArrayList存在一定的危险性。它的add和set方法允许接受任意类型的对象。*

toArray方法将数组元素拷贝到一个数组中。

带索引参数的add方法，可以在数组列表中间插入元素。为了插入一个新元素，位于n之后的所有元素都要向后移动一个位置。如果插入新元素后，数组列表的大小超过了容量，数组列表就会被重新分配存储空间。

同样的可从数组列表中间删除一个元素。`Employee e = staff.remove(n);`位于这个位置之后的所有元素都向前移动一个位置，并且数组的大小减1。

对数组实施插入和删除元素的操作效率比较低。考虑使用链表，有关链表操作的实现方式将在第13章中讲述。

可以使用“for each”循环遍历数组列表。`for(Employee e : staff)`

【API】java.util.ArrayList\<T> 1.2：

- `void set(int index, T obj)`
- `T get(int index)`
- `void add(int index, T obj)`
- `T remove(int index)`

### 5.3.2 类型化与原始数组列表的兼容性

可以将一个类型化的数组列表传递给参数是原始类型的方法，而不需要进行任何类型转换。

*警告：尽管编译器没有给出任何错误信息或警告，但是这样的调用并不安全。这与在Java中增加泛型之前是一样的。既没降低安全性，也没受益于编译时的检查。*

相反的，将一个原始ArrayList赋给一个类型化ArrayList会得到一个警告。

*注释：为了能够看到警告性错误文字信息，要将编译选项置为-Xlint:unchecked。*

使用类型转换并不能避免出现警告。这样会得到另一个警告信息，被告知类型转换有误。

鉴于兼容性的考虑，编译器在对类型转换进行检查之后，如果没有违反规则的现象，就将所有的类型化数组列表转换成原始ArrayList对象。在程序运行时，所有的数组列表都是一样的，即没有虚拟机中的类型参数。

一旦能确保不会造成严重的后果，可以用@SuppressWarnings("unchecked")标注来标记这个变量能够接受类型转换。

## 5.4 对象包装器与自动装箱

**包装器（wrapper）**：对象包装器类——Integer、Long、Float、Double、Short、Byte、Character、Void和Boolean（前面6个类派生于公共的超类Number）。对象包装器类是不可变的，即一旦构造了包装器，就不允许更改包装在其中的值。同时，对象包装器还是final，因此不能定义它们的子类。

假设想定义一个整型数组列表。而尖括号中的类型参数不允许是基本类型，也就是说，不允许写成ArrayList\<int>。这里就用到了Integer对象包装器类。。我们可以声明一个Integer对象的数组列表。`ArrayList<Integer> list = new ArrayList<>();`

*警告：由于每个值分别包装在对象中，所以ArrayList\<Integer>的效率远远低于int[]数组。因此，应该用它构造小型集合，其原因是此时程序员操作的方便性要比执行效率更加重要。*

Java SE 5.0 的另一个改进之处是更加便于添加或获得数组元素。下面这个调用`list.add(3);`将自动地变换成`list.add(Integer,valueOf(3));`这种变换被称为自动装箱（autoboxing）。

*注释：大家可能认为自动打包（autowrapping）更加合适，而"装箱（boxing）"这个词源自于C#。*

相反地，当将一个Integer对象赋给一个int值时，将会自动地拆箱。也就是说，编译器将下列语句：`int n = list.get(i);`翻译成`int n = list.get(i).intValue();`甚至在算术表达式中也能够自动地装箱和拆箱。

在很多情况下，容易有一种假象，即基本类型和它们的对象包装器是一样的，只是它们相等性不同。解决这个问题的方法是在两个包装器对象比较时调用equals方法。

*注释：自动装箱规范要求boolean、byte、char<=127，介于-128~127之间的short和int被包装到固定对象中。例如，如果在前面的例子中将a和b初始化为100，对它们进行比较的结果一定成立*

最后强调一下，装箱和拆箱是编译器认可的，而不是虚拟机。编译器在生成类的字节码时，插入必要的方法调用。虚拟机只是执行这些字节码。

使用数值对象包装器还有另外 一个好处。Java设计这发现，可以将某些基本方法放置在包装器中，例如Integer.parseInt(s)将字符串转换成整型。这里与Integer对象没有任何关系，parseInt是一个静态方法。但Integer类是放置这个方法的好地方。

*警告：有些人认为包装器类可以用来实现修改数值参数的方法，然而这是错误的。Integer对象是不可变的。*

【API】java.lang.Integer 1.0：

- `int intValue()`
- `static String toString(int i)`
- `static String toString(int i, int radix)`
- `static int parseInt(String s)`
- `static int parseInt(String s, int radix)`
- `static Integer valueOf(String s)`
- `static Integer valueOf(String s, int radix)`

【API】java.text.NumberFormat 1.1：

- `Number parse(String s)`

## 5.5 参数数量可变的方法

在Java SE 5.0以前的版本中，每个Java方法都有固定数量的参数。然而现在的版本提供了可以用可变参数数量调用的方法（有时称为"变参"方法）。

... 是Java代码的一部分，它表明这个方法可以接收任意数量的对象。

对于printf的实现者来说，Object...参数类型与Object[]完全一样。

*注释：允许将一个数组传递给可变参数方法的最后一个参数。因此可以将已经存在且最后一个参数是数组的方法重新定义为可变参数的方法，而不会破坏任何已经存在的代码。例如，MassageFormat.format在Java SE 5.0就采用了这种方式。甚至可以将main方法声明为String... args形式*

## 5.6 枚举类

比较两个枚举类型的值时，永远不需要调用equals，而直接使用“==”就可以了。

如果需要的话，可以在枚举类型中添加一些构造器、方法和域。当然，构造器只是在构造枚举常量的时候被调用。下面是一个示例：

``` java
public enum Size{
    SMALL("S"),MEDIUM("M"),LARGE("L"),EXTRA_LARGE("XL");
    private String abbreviation;
    private Size(String abbreviation){this.abbreviation = abbreviation;}
    public String getAbbreviation(){return abbreviation;}
}
```

所有的枚举类型都是Enum类的子类。它们继承了这个类的许多方法。其中最有用的一个是toString，这个方法能够返回枚举常量名。例如，Size.SMALL.toString()将返回字符串“SMALL”。

toString的逆方法是静态方法valueOf。例如，语句：`Size s = Enum.valueOf(Size.class, "CLASS");`将s设置成Size.SMALL。

每个枚举类型都有一个静态的values方法，它返回一个包含全部枚举值的数组。例如，如下调用`Size[] values = Size.values();`返回包含元素Size.SMALL，Size.MEDIUM，Size.LARGE 和 Size.EXTRA_LARGE的数组。

ordinal方法返回enum声明中枚举常量的位置，位置从0开始计数。例如Size.MEDIUM.ordinal()返回1。

*注释：如图Class类一样，鉴于简化的考虑，Enum类省略了一个类型参数，例如实际上，应该将枚举类型Size扩展为Enum\<Size>。类型参数在compareTo方法中使用（compareTo方法在第6章中介绍，类型参数在第12章中介绍）。*

【API】java.lang.Enum \<E> 5.0：

- `static Enum valueOf(Class enumClass, String name)`
- `String toString()`
- `int ordinal()`
- `int compareTo(E other)`

## 5.7 反射

**反射库（reflection library）**提供了一个非常丰富且精心设计的工具集，以便编写能够动态操纵Java代码的程序。这项功能被大量应用于JavaBeans中，它是Java组件的体系结构（有关JavaBeans的详细内容在卷II中阐述）。

能够分析类能力的程序称为**反射（reflective）**。反射机制可以用来：

- 在运行中分析类的能力
- 在运行中查看对象，例如，编写一个toString方法供所有类使用。
- 实现通用的数组操作代码。
- 利用Method对象，这个对象很像C++中的函数指针。

反射是一种功能强大且复杂的机制。使用它的主要人员是工具构造者，而不是应用程序员。如果仅对设计应用程序感兴趣，而对构造工具不感兴趣，可以跳过本章的剩余部分，稍后再回来学习。

### 5.7.1 Class类

程序运行期间，Java运行时系统始终为所有的对象维护一个被称为运行时的类型标识。

保存这些信息的类被称为Class。Object类中的getClass()方法将会返回一个Class类型的实例。

最常用的Class方法是getName()。这个方法将返回类的名字。如果类在一个包里，包的名字也作为类名的一部分。

还可以调用静态方法forName获得类名对应的Class对象。当然，这个方法只有在className是类名或接口名时才能够执行。否则，forName方法将抛出一个checked exception（已检查异常）。无论何时使用这个方法，都应该提供一个**异常处理器（exception handler）**。如何提供一个异常处理器，请参看下一节。

*提示：使用下面这个技巧给用户一种启动速度比较快的幻觉。要确保包含main方法的类没有显式地引用其他的类。首先，显式一个启动画面；然后通过调用Class.forName手工地加载其他的类。*

获得Class类对象的第三种方法非常简单。如果T是任意的Jave类型，T.class将代表匹配的类对象。

请注意，一个Class对象实际上表示的是一个类型，而这个类型未必一定是一种类。例如，int不是类，但int.class是一个Class类型的对象。

*注释：从Java SE 5.0 开始，Class类已参数化。例如，Class\<Employee>的类型是Employee.class。没有说明这个问题的原因是，它将已经抽象的概念复杂化了。在大多数实际问题中，可以忽略类型参数，而使用原始的Class类。有关这个问题更详细的论述请参看第13章。*

*警告：鉴于历史原因，getName方法在应用于数组类型的时候会返回一个很奇怪的名字：`Double[].class.getName()`返回"[Ljava.lang.Double;"。`int[].class.getName`返回"[I"。*

虚拟机为每个类型管理一个Class对象。因此，可以利用==运算符实现两个类对象比较的操作。

还有一个很有用的方法newInstance()，可以用来快速地创建一个类的实例。newInstance调用默认的构造器初始化新构件的对象，如果这个类没有默认的构造器，就会抛出一个异常。

*注释：如果需要以这种方式向希望按名称创建的类的构造器提供参数，就必须使用Constructor类中的newInstance方法。*

*C++注释：newInstance方法对应C++虚拟构造器的习惯用法。然而C++中的虚拟构造器不是一种语言特性，需要由专门的库支持。Class类与C++中的type_info类相似，getClass方法与C++中的type_info只能以字符串的形式显示一个类型的名字，而不能创建那个类型的对象。*

### 5.7.2 捕获异常

第11章 异常处理机制

抛出异常 “捕获”异常的**处理器（handler）**

没有提供处理器，程序就会终止，并在控制台上打印出一条信息，其中给出了异常的类型。例如，null引用或者数组越界等。

异常有两种类型：未检查异常和已检查异常。对于已检查异常，编译器会检查是否提供了处理器。

Throwable类 printStackTrace方法打印出栈的轨迹。Throwable是Exception类的超类

调用了一个抛出已检查异常的方法，而又没有提供处理器，编译器就会给出错误报告。

【API】java.lang.Class 1.0：

- `static Class forName(String className)`

- `Object newInstance()`

【API】java.lang.reflect.Constructor 1.1：

- `Object newInstance(Object[] args)`

【API】java.lang.Throwable 1.0：

- `void printStackTrace()`

### 5.7.3 利用反射分析类的能力

反射机制最重要的内容——检查类的结构。

在java.lang.reflect包中有三个类Field、Method和Constructor分别用于描述类的域、方法和构造器。这三个类都有一个叫做getName的方法，用来返回项目的名称。Field类有一个getType方法，用来返回描述域所属类型的Class对象。Method和Constructor类有能够报告参数类型的方法，Method类还有一个可以报告返回类型的方法。这三个类还有一个叫getModifiers的方法，它将返回一个整型数值，用不同的位开关描述public和static这样的修饰符使用情况。另外，还可以利用java.lang.reflect包中的Modifier类的静态方法分析getModifiers返回的整型数值。例如可以使用Modifier类中的isPublic、isPrivate或isFinal判断方法或构造器是否是public、private或final。还可以利用Modifier.toString方法将修饰符打印出来。

Class类中的getFields、getMethods和getConstructors方法将分别返回类提供的public域、方法和构造器数组，其中包括超类的公有成员。Class类的getDeclareFields、getDeclareMethods和getDeclaredConstructors方法将分别返回类中声明的全部域、方法和构造器，其中包括私有和受保护成员，但不包括超类的成员。

【API】java.lang.Class 1.0

- `Field[] getFields()` 1.1
- `Field[] getDeclaredFields()` 1.1
- `Method[] getMethods()` 1.1
- `Method[] getDeclareMethods()` 1.1
- `Constructor[] getConstructors()` 1.1
- `Constructor[] getDeclaredConstructors()` 1.1

【API】java.lang.reflect.Field 1.1：

【API】java.lang.reflect.Method 1.1 :

【API】java.lang.reflect.Constructor 1.1 :

- `Class getDeclaringClass()`
- `Class[] getExceptionTypes()`（在Constructor和Method类中）
- `int getModifiers()`
- `String getName()`
- `Class[] getParameterTypes()`（在Constructor和Method类中）
- `Class getReturnType()`（在Method类中）

【API】java.lang.reflect.Modifier 1.1 :

- `static String toString(int modifiers)`
- `static boolean isAbstract(int modifiers)`
- `static boolean isFinal(int modifiers)`
- `static boolean isInterface(int modifiers)`
- `static boolean isNative(int modifiers)`
- `static boolean isPrivate(int modifiers)`
- `static boolean isProtected(int modifiers)`
- `static boolean isPublic(int modifiers)`
- `static boolean isStatic(int modifiers)`
- `static boolean isStrict(int modifiers)`
- `static boolean isSynchronized(int modifiers)`
- `static boolean isVolatile(int modifiers)`

### 5.7.4 在运行时使用反射分析对象

如何查看任意对象的数据域名称和类型：

- 获得对应的Class对象。
- 通过Class对象调用getDeclaredFields。

查看对象域的关键方法是Field类的get方法。如果f是一个Field类型的对象（例如，通过getDeclaredFields得到的对象），obj是某个包含f域的类的对象，f.get(obj)将返回一个对象，其值为obj域的当前值。

反射机制的默认行为受限于Java的访问控制。Field、Method或Constructor对象的setAccessable方法

setAccessable方法是AccessibleObject类的一个方法，它是Field、Method和Constructor类的公共超类。这个特性是为调试、持久存储和相似机制提供的。本书稍后将利用它编写一个通用的toString方法。

Field类中的getDouble方法，也可以调用get方法，此时反射机制会自动地将这个域值打包到相应的对象包装器中。

f.set(obj, value)可以将obj对象的f域设置成新值。

【API】java.lang.reflect.AccessibleObject 1.2 :

- `void setAccessible(boolean flag)`
- `boolean isAccessible()`
- `static void setAccessible(AccessibleObject[] array, boolean flag)`

【API】java.lang.Class 1.1 :

- `Field getField(String name)`
- `Field[] getField()`
- `Field[] getDeclaredField(String name)`
- `Field[] getDeclaredFields()`

【API】java.lang.reflect.Field 1.1 :

- `Object get(Object obj)`
- `void set(Object obj, Object newValue)`

### 5.7.5 使用反射编写泛型数组代码

Array类中的copyOf方法实现

需要java.lang.reflect包中Array类的一些方法。Array类中的静态方法newInstance

Array.getLength(a)获得数组的长度，也可以通过Array类的静态getLength方法的返回值得到任意数组的长度。

Class类的getComponentType方法确定数组对应的类型。

【API】java.lang.reflect.Array 1.1 :

- `static Object get(Object array, int index)`
- `static xxx getXxx(Object array, int index)`
- `static void set(Object array, int index, Object newValue)`
- `static setXxx(Object array, int index, xxx newValue)`
- `static int getLength(Object array)`
- `static Object newInstance(Class componentType, int length)`
- `static Object newInstance(Class componentType, iny[] lengths)`

### 5.7.6 调用任意方法

Java没有提供方法指针

Java设计者认为接口是一种更好的解决方案。然而，反射机制允许你调用任意方法。

*注释：J++（以及后来的C#）委托（delegate），它与本节讨论的Method类不同。内部类比委托更加有用*

Method类invoke方法，允许调用包装在当前Method对象中的方法。

如何得到Method对象？getDeclaredMethods方法，然后对返回的Method对象数组进行查找，知道发现想要的方法为止。也可以通过调用Class类中的getMethod方法得到想要的方法。

设计风格不太简便，出错可能性也较大。参数和返回值必须是Object类型的。比仅仅直接调用方法明显慢一些。

有鉴于此，建议仅在必要时候才使用Method对象。建议不要使用Method对象的回调功能。

【API】java.lang.reflect.Method 1.1 :

- `public Object invoke(Object implicitParameter, Object[] explicitParameters)`

## 5.8 继承设计的技巧

1）将公共操作和域放在超类

2）不要使用受保护的域

3）使用继承实现“is-a”关系

4）除非所有继承方法都有意义，否则不要使用继承。

5）在覆盖方法时，不要改变预期的行为。

6）使用多态，而非类型信息。

7）不要过多地使用反射。

