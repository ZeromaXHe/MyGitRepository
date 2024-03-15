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

