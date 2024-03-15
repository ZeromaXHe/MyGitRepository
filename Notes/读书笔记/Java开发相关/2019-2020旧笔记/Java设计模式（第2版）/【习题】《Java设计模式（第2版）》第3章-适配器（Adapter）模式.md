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

