# IDEA 常用快捷键

| 快捷键                         | 作用                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| `Ctrl + /`或`Ctrl + shift + /` | 注释（`//`或`/*...*/`）                                      |
| `Ctrl + D`                     | 复制行                                                       |
| `Ctrl + X`                     | 剪切行                                                       |
| `Ctrl + Y`                     | 删除行                                                       |
| `Ctrl + R`                     | 替换文本                                                     |
| `Ctrl + F`                     | 查找文本                                                     |
| `Ctrl + G`                     | 定位某一行（输入对应行号直接跳转，快速移动光标至指定行数列数） |
| `Ctrl + H`                     | Hierarchy界面（查看类的继承层级关系）                        |
| `Ctrl + I`                     | 实现方法                                                     |
| `Ctrl + O`                     | 覆盖/重写方法                                                |
| `Ctrl + Q`                     | 查看方法说明javadoc注释                                      |
| `Ctrl + J`                     | 自动代码，插入代码模板（类似psvm这些）                       |
| `Ctrl + W`                     | 扩大被选择代码范围（可以用来找对应的括号位置，也可以用来选中当前词汇（类似鼠标双击）） |
| `Ctrl + Shift + W`             | 缩小被选择代码范围                                           |
| `Ctrl + F12`                   | structure视图（列出当前类中的所有方法纲要，直接打字可以进行方法的搜索） |
| `Ctrl + Home`                  | 文件开始的位置                                               |
| `Ctrl + End`                   | 文件末尾的位置                                               |
| `Alt + Enter`                  | 快速修复（导包等）                                           |
| `Alt + /`                      | 代码提示                                                     |
| `Alt + Insert`                 | 生成代码(如GET,SET方法,构造函数等)                           |
| `Alt + ←/→`                    | 切换代码视图                                                 |
| `Alt + ↑/↓`                    | 在方法间快速移动定位(上一个/下一个方法)                      |
| `Ctrl + Alt + L`               | 格式化代码（==会和网易云音乐全局快捷键冲突。。。==）         |
| `Ctrl + Alt + T`               | Surround With ...（用try/catch、if、for、synchronized等等语句块包住选择的语句） |
| `Ctrl + Alt + M`               | 重构方法                                                     |
| `Ctrl + Alt + I`               | 自动缩进本行或本块代码                                       |
| `Ctrl + Alt + O`               | 格式化import列表，优化导入的类和包（删除多余import）         |
| `Ctrl + Alt + S`               | 设置                                                         |
| `Ctrl + Alt + U`               | 查看类继承关系类图（在图中选中类按`Ctrl + Alt + B`可以列出实现类，然后全选后回车，可以把继承类加入类图） |
| `Ctrl + Alt + ←`               | 返回上一级代码（==会和网易云音乐全局快捷键冲突。。。==）     |
| `Ctrl + Shift + ↑或↓`          | 向上/下移动代码块                                            |
| `Ctrl + Shift + Space`         | 智能代码提示                                                 |
| `Ctrl + Shift + J`             | 合并多行为一行                                               |
| `Alt + Shift + ↑或↓`           | 向上/下移动代码行                                            |
| `Shift + (Fn) + F6`            | 重构-重命名                                                  |
| `F2`                           | 下一处错误                                                   |
| `Shift + F2`                   | 上一处错误                                                   |

常用的有`fori/sout/psvm + Tab`即可生成循环、System.out、main方法等boilerplate样板代码

for(User user : users)只需输入`user.for + Tab`。再比如，要输入Date birthday = user.getBirthday();只需输入`user.getBirthday().var + Tab`即可

# intellij idea如何取消import合并成*

打开intellij idea开发工具

点击工具栏【File】-【Settings】按钮

打开intellij idea设置界面，点击【Editor】-【Code style】-【java】,在右侧切换到【Imports】选项卡

设置"Class count to use import with *"这个数字调整的大些，就不会出现import * 的问题了

# IDEA 类的默认注释设置

点击settings --> editor --> file and code templates

可以在class的模板上面添加：
~~~java
/**
 * @Author: ${USER}
 * @Time: ${DATE} ${TIME}
 * @Description: 
 * @Modified By: ${USER}
 */
~~~

# IDEA 自动生成序列化ID（SerialVersionUID）

点击settings --> editor --> Inspections。搜索`Serializable class without serialVersionUID`,勾选上设置成warning以后，在对应的没有序列化ID的类上面按`Alt + Enter`就可以选择自动生成序列化UID了。

# IDEA Plugins 搜不出来

修改 Plugins右上角齿轮->HTTP Proxy Settings （也可以从Appearance & Behavior -> System Settings -> HTTP Proxy),勾选 Auto-detect proxy settings，再勾选下面的 Automatic proxy configuration URL，填入`https://plugins.jetbrains.com`



# IDEA GUI form

参考：

版权声明：本文为CSDN博主「wsy2846513」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/wsy2846513/article/details/78946008

## swing代码显示方式

显示为java代码：
  File -> settings -> GUI designer，Generate GUI into : Java source code

直接以class形式插入到文件中：
  File -> settings -> GUI designer，Generate GUI into : Binary class files

局部/全局
  在File -> settings 中设置的是当前project的，在File -> other settings -> default setting中设置的是全局变量。无论是局部还是全局设置，都需要再编译一次才会显示/隐藏swing代码。

## 构造顺序

  通过java代码格式下进行单步调试可以得出结论：在进入构造函数的第一步，就会生成各个控件，例如下述代码中，在第一局globalProperties = inputGlobalProperties;执行之前，各个控件就已经生成了。

~~~java
public MainForm(GlobalProperties inputGlobalProperties, SettingForm inputSettingForm) {
        globalProperties = inputGlobalProperties;         //1
        settingForm = inputSettingForm;
        frame = new JFrame("");
        this.propertiesFilePath = globalProperties.getPropertiesFilePath();
        this.iconPath = globalProperties.getIconPath();
        this.startManualImport = globalProperties.getStartManualImport();
 }
~~~

## 报错

### Form main()报错

设计完成之后，可以在java类里面按下alt+insert键进行代码的自动插入，选择Form main()即可

此时会报错`The form bound to the class does not have a valid binding for the root component`，原因是没有给Jpanel命名，返回form页面左侧选中Jpanel输入名称后再次操作即可成功。

### 运行main函数报错

用IDEA自带的生成jar方式不会出现错误
MAVEN编译或生成的JAR包运行错误

java.lang.NoClassDefFoundError:com/intellij/uiDesigner/core/GridLayoutManager

原因：

​		由于这些控件是由idea生成的，因此
    1.当控件使用class文件方式创建时，需要用idea自带的生成jar方法才能将控件生成，若直接用maven编译不会报错，但当生成jar时，会由于没有将控件对应的class文件编写的普通的class文件中导致错误，如jar运行时提示找不到控件，或控件为null等；
    2.当控件使用java代码方式生成时，需要引入相应的idea的jar包，若未引入则maven编译报错。

解决方案
  可以参考https://stackoverflow.com/questions/19049253/intellij-idea-gui-designer-maven，目前使用的方式是
    1.首先将控件以java形式写入到源码中；
    2在pom.xml中加入依赖：

```xml
<dependency>
  <groupId>com.intellij</groupId>
  <artifactId>forms_rt</artifactId>
  <version>7.0.3</version>
</dependency>
```

# IntelliJ IDEA 出现 "cannot access class"错误的解决方法

如果明明有这个类存在但仍然提示cannot access，这可能是IDE的bug，可以清除缓存并重启：

尝试 File->Invalidate Caches /Restart ...