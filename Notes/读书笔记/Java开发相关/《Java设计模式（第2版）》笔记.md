# 第1章 绪论

## 为何需要模式

Christopher Alexander

## 为何需要设计模式

## 为何选择Java

## UML

统一建模语言（UML）

## 挑战

## 本书的组织

任何模式的核心要素还在于它的意图

1. 接口型模式
2. 职责型模式
3. 构造型模式
4. 操作型模式
5. 扩展型模式

## 欢迎来到Oozinoz公司

## 小结

# 第2章 接口型模式介绍

## 接口和抽象类

## 接口与职责

提供桩（stub），即提供空实现的接口实现类。	WindowAdapter

## 小结

## 超越普通接口

# 第2章 接口型模式介绍 挑战

## 挑战2.1

写出在Java中抽象类和接口的三点区别：

我的回答：

```
1.抽象类可以有实现方法，而接口不可以（除了8引入的默认方法和静态方法，9引入的私有方法，都必须是抽象方法）
2.抽象类只能继承一个，接口可以实现多个
3.想不到啦~
```

答案：

- 前两点同上
- 抽象类可以声明和使用字段（field）；接口则不能，但可以创建静态的final常量
- 抽象类方法可以是public、protected、private或者默认的包访问权限；接口的方法都是public。
- 抽象类可以定义构造函数；接口不能。

## 挑战2.2

下面的描述哪些是正确的？

A.三个方法都是抽象方法

B.三个都是公开方法

C.省略public的接口是公有的

D.可以创建另一个接口去扩展接口

E.每个接口必须至少包含一个方法

F.接口可以声明实例字段，实现该接口的类也必须声明该字段

G.接口可以定义构造函数

我的回答：

```
A.B.D.
```

答案：

A.B.D.

## 挑战2.3

请列举一个接口，它包含的方法并不要求实现该接口的类必须返回值，或者代表调用者执行若干操作。

我的回答：

```
Runnable:只需实现void run()方法,无返回值
Serializable
Cloneable
```

答案：

一个例子被当做一个类被注册为事件的侦听器时，这些侦听器类会收到它们关心的通知，而不是调用者。例如，我们需要在触发MouseListener.mouseDragged()方法时采取某个动作，但对于同一个侦听器而言，MouseListener.mouseMoved()方法却是一个空的实现。

# 第3章 适配器（Adapter）模式

## 接口适配

## 类与对象适配器

与实现RocketSim接口相比，运用了对象适配器的Skyrocket类存在更大的风险。但我们却不应该吹毛求疵，因为它仅仅是没有将方法标记为final，使得我们不能防止子类去重写它们。

## JTable对数据的适配

无论和是，只要我们需要使用的抽象类对要适配的接口提供支持，就必须使用对象适配器方式。

当适配类必须从多个对象处获得相关信息时，通常就应该使用对象的适配器。

注意区分：类的适配器继承自现有的类，同时实现目标接口；对象适配器继承自目标类，同时引用现有的类。

## 识别适配器

## 小结

# 第3章 适配器（Adapter）模式 挑战

## 挑战3.1

完成图3.3的类图,展现OozinozRocket类的设计

我的回答：

```
智商着急，没看懂……
```

答案：

time:double //(对应setSimTime？并且给父类getMass和getThrust传参)

------

OozinozRocket(

​	burnArea:double,

​	burnRate:double

​	fuelMass:double,

​	totalMass:double) //对应PhysicalRocket类中继承的方法和成员变量

getMass():double

getThrust():double

setSimTime(t:double) //实现三个RocketSim中的抽象方法

## 挑战 3.2

完成包括getMass()与getThrust()方法的OozinozRocket类的代码

我的回答：

```
getMass(): return totalMass-fuelMass;
getThrust(): return burnArea*burnRate;
```

感觉自己这一章挑战做得惨不忍睹

答案：

getMass(): return getMass(time);

getThrust(): return getThrust(time);

## 挑战3.3

(36/393)

完成图3.6所示的类图，使得OozinozRocket对象支持Skyrocket对象。

我的回答：

```
PhysicalRocket pr;
#simTime:double
------
OozinozSkyrocket:(
	mass:double
	thrust:double
	burnTime:double)
```

答案：（317/393）

rocket:PhysicalRocket

------

OozinozRocket(

​	r:PhysicalRocket)

getMass():double

getThrust():double

## 挑战3.4

（37/393）

分析为何OozinozSkyrocket类使用的对象适配器设计要比类的适配器方式更加脆弱。

我的回答：

```
OozinozSkyrocket和超类将耦合度较高，超类Skyrocket的改变将会给OozinozSkyrocket带来潜在危险。
```

答案：（318/393）

- 对象适配器使得OozinozSkyrocket类所提供的接口规范。由于Skyrocket的变化，可能在运行时出现编译时无法检测到的问题。
- OozinozSkyrocket需要借助于访问其超类的simTime变量，但我们却无法保证该变量被声明为protected，也不能保证处于Skyrocket类中的这一字段符合子类的意图。（我们不能期望提供者不会修改我们所依赖的Skyrocket代码，换言之，很难约束和控制它们所要做的事情）

## 挑战3.5

（40/393）

完成RocketTableModel方法中的代码，使其能够将Rocket对象数据适配为TableModel。

我的回答：

```
getColumnCount(): return columnNames.length;
getColumnName(int i): return columnNames[i];
getRowCount(): return rockets.length;
getValueAt(int row, int col): 
switch(col){
	case 0: return rockets[row].getName();
	case 1: return rockets[row].getPrice();
	case 2: return rockets[row].getApogee();
}
```

答案：（318/393）

getValueAt的case2: return new Double(rockets[row].getApogee());

后面加上default: return null;

## 挑战3.6

（42/393）

在使用MouseAdapter类时，你是否运用了适配器模式？请阐述其原理（如果没有运用，请给出理由）。

答案：(319/393)

- 一种观点：当用户单击鼠标时，我需要将Swing调用的结果转换或适配给对应的动作。换言之，当需要将GUI事件适配给应用程序的接口时，我使用了Swing的适配器类。我将一个接口转换成为另一个，从而实现了适配器模式的意图。
- 一种争论：Swing中的“适配器”类是桩（Stub），它们并没有真正转换或适配。在定义这些类的子类时，重写了你需要的方法。这些重写方法和类才是适配器的例子。如果将“Adapter”改名为DefaultMouseListener，就不会出现这样的争论了。

# 第4章 外观（Facade）模式

外观模式的意图是为子系统提供一个接口，便于它的使用。

## 外观类、工具类和示例类

外观类可能全是静态方法，在UML中，这样的类被称为Utility（工具）。

示例类（Demo）则用于展示如何使用类或子系统。

## 重构到外观模式

# 第4章 外观（Facade）模式 挑战

## 挑战4.1

（45/393）

写出示例类和外观类的两点区别。

答案：（320/393）

- 示例通常是一个单独运行的应用程序，而外观不是。
- 示例通常包含了样本数据，而外观则没有。
- 外观通常是可配置的，示例不是。
- 外观的意图是为了重用，示例不是。
- 外观用在产品代码中，示例不是。

## 挑战4.2

（46/393）

JOptionPane类让对话框的显示变得简单，那么，该类是一个外观类、工具类还是示例类？给出答案，并阐述你的理由。

我的回答：

```
工具类
```

答案：（320/393）

JOptionPane类是Java类库中少有的几个运用了外观模式的类。它属于产品代码，可配置，设计的目的是为了重用。除此之外，JOptionPane类通过提供了一个简单的接口使得对JDialog类的使用变得简单，满足外观模式的意图。你可能会认为该类是一个简化了的“子系统”，但事实上，一个独立的JDialog类并不能认为是子系统。但确切地讲，该类提供的丰富特性体现了外观类的价值。

Sun公司在JDK中提供了多个示例程序。然而，这些类都不是Java类库的一部分。也就是说，它们并没有被放在java包中。外观属于Java类库，但示例不是。

JOptionPane有多个静态方法，这使得它成为了外观模式的工具类。严格地讲，这样的类并不符合UML中工具类的定义，因为UML要求工具类只能处理静态方法。

## 挑战4.3

（46/393）

Java类库中很少有外观类，为什么？

答案：（320/393）

Java类库之所以较少运用外观模式，可能存在如下几个合理但观点截然对立的理由：

- 作为Java开发者，通常要求对库中工具做整体的了解。外观模式可能会限制这种运用系统的方式。它们可能会分散开发人员的注意力，并对类库提供的功能产生误解。
- 外观类介于丰富的工具包和特定应用程序之间。为了创建外观类，需要了解它所支持的应用程序类型。然而Java类库的用户如此之多，这种预先支持是不可能的。
- Java类库提供的外观类过少，这是一个缺陷。应该加入更多的外观类，提供更好的支持。

## 挑战4.4

（52/393）

完成图4.5所示的类图，用以展示将showFlight重构为三个类的代码：Function类、实现两个参数功能的PlotPanel类和一个UI外观类。在你的重新设计中，让类ShowFight2为获取y值创建一个Function，并让main()方法启动程序。

我的回答：

```
ShowFlight2:
main()
showFlight()

PlotPanel:
createTitledPanel(title:String,p:JPanel):JPanel

UI:
getStandardFont():Font
createTitledBorder(:String)

Function:
paintComponent(:Graphics)
```

答案：（321/393）

showFlight2：main(:String[])

PlotPanel: PlotPanel(nPoint:int, xFunc:Function, yFunc:Function)

​				PaintComponent(:Graphics)

UI: NORMAL:UI

-------

createTitlePanel(title:String,panel:JPanel)

Function: f(t:double):double

# 第5章 合成（Composite）模式

合成模式的意图是为了保证客户端调用对象与组合对象的一致性。

## 常规组合

## 合成模式中的递归行为

## 组合、树和环

# 第5章 合成（Composite）模式 挑战

## 挑战5.1

（57/393）

在图5.1中，为何Composite类维持了包含Component对象的集合，而不是仅包含叶子对象？

我的回答：

```
因为Component存在多态？
```

答案：(322/393)

设计合成类可用于维护合成对象的集合，使得合成对象既可以支持叶子对象，又能支持组合对象。

换言之，合成模式的设计使得我们能够将一种分组建模为另一种分组的集合。例如，我们可以将用户的系统权限定义为特定权限的集合以及其他进程。合成模式的另一个例子是对工作进程的定义，可以将其定义为进程步骤的集合以及其他进程。相比于将其定义为叶子对象集合的合成对象，这样的定义更为灵活。

若只支持叶子对象的集合，则合成对象只能有一层的深度。

## 挑战5.2

（58/393）

写出Machine与MachineComposite中getMachineCount()方法的实现代码。

我的回答：

```
Machine: return 1;

MachineComposite: 
int count = 0;
for(MachineComponent mc: components){
	count+=mc.getMatchCount();
}
return count;
```

答案：（322/393）

JDK5之前使用iterator，其他一样。

## 挑战5.3

（58/393）

为MachineComponent声明的每个方法，写出表5.1中MachineComposite中的递归定义与Machine中的非递归定义。

我的回答：

```
Machine:
	isCompletelyUp(): return state==true;
	stopAll(): state=false;
	getOwners(): return owners;
	getMaterial(): return material;
MachineComposite:
	isCompletelyUp(): 
		for(MachineComponent mc:components){
			if(!mc.isCompletelyUp()) return false;
		}
		return true;
	stopAll():
		for(MachineComponent mc:components){
			mc.stopAll();
		}
	getOweners(): 
		Set<String> set = new HashSet<>();
		for(MachineComponent mc:components){
			for(String owner: mc.getOwners()) set.add(owner);
		}
		return set;
	getMaterial(): 
		Set<String> set = new HashSet<>();
		for(MachineComponent mc:components){
			for(String material: mc.getMaterial()) set.add(material);
		}
		return set;
```

答案：（323/393）

答案写的是文字。。。不想抄了，基本细节都是一样的。

## 挑战 5.4

（62/393）

下面的程序将会输出什么？

我的回答：

```

```

答案：（）

