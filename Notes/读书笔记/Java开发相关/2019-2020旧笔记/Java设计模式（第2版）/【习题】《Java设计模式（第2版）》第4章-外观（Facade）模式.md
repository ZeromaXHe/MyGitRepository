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

