# Thrift教程
翻译自官方文档：[https://gitbox.apache.org/repos/asf?p=thrift.git;a=blob;f=tutorial/tutorial.thrift;hb=HEAD](https://gitbox.apache.org/repos/asf?p=thrift.git;a=blob;f=tutorial/tutorial.thrift;hb=HEAD)
原作者：Mark Slee


这篇文档致力于教你如何使用Thrift，使用的是.thrift文件的格式。好耶~
第一件需要注意的事是.thrift文件支持标准shell注释。(#开头的注释) 这使你可以让你的thrift文件可执行，并且在首行包含你的Thrift编译步骤。你可以在你想要的地方任意的放置注释。

在运行这个文件前，你需要在/usr/local/bin中安装thrift编译器

第一件需要了解的事就是类型。Thrift中可用的类型有：

|类型|英文描述|中文描述|
|----------|----------------------------------|-----------------------|
|bool      |Boolean, one byte                 |布尔值，一个字节|
|i8 (byte) |Signed 8-bit integer              |有符号 8比特 整型|
|i16       |Signed 16-bit integer             |有符号 16比特 整型|
|i32       |Signed 32-bit integer             |有符号 32比特 整型|
|i64       |Signed 64-bit integer             |有符号 64比特 整型|
|double    |64-bit floating point value       |64比特 浮点型|
|string    |String                            |字符串|
|binary    |Blob (byte array)                 |BLOB大对象数据类型（字节数组）|
|map<t1,t2>|Map from one type to another      |Map映射 从一种类型到另一种类型|
|list<t1>  |Ordered list of one type          |一种类型的有序列表|
|set<t1>   |Set of unique elements of one type|一种类型的不重复元素的集合|


你是否注意到Thrift支持C风格的注释？（`/**`和`*/`）

我们也支持简单C注释。（`//`）

Thrift文件可以引用其他Thrift文件来包含基本结构和服务定义。这些可以通过当前路径找到，或者通过使用 -I 编译器标志来在任意指定路径下搜索相关的。

被包含的对象可以使用.thrift文件的名字作为前缀来访问，例如shared.SharedObject

```c
include "shared.thrift"
```


Thrift文件可以使用多种目标语言的命名空间，包，或者前缀来处理他们的输出。

```c
namespace cl tutorial
namespace cpp tutorial
namespace d tutorial
namespace dart tutorial
namespace java tutorial
namespace php tutorial
namespace perl tutorial
namespace haxe tutorial
namespace netstd tutorial
```


Thrift允许你使用typedef来为你的类型命名。使用标准的C语言风格。

```c
typedef i32 MyInteger
```


Thrift也允许你为跨语言使用而定义常量。复杂的类型和结构使用JSON符号来标记。

```c
const i32 INT32CONSTANT = 9853
const map<string,string> MAPCONSTANT = {'hello':'world', 'goodnight':'moon'}
```


你能定义枚举类型，其实就是32比特整型。它们的值是可选的，如果没有提供的话则从1开始，也是C语言风格。

```c
enum Operation {
  ADD = 1,
  SUBTRACT = 2,
  MULTIPLY = 3,
  DIVIDE = 4
}
```


struct是基本的复杂数据结构。它们由字段（field）组成，每个都有一个整型标识符，一个类型，一个标志性的名称，和可选择的默认值。
which each have an integer identifier, a type, a symbolic name, and an


字段可以被声明为optional，以确保它们在没有设值的时候不会被包含在序列化的输出中。注意这在某些语言中需要某些手动的管理。

```c
struct Work {
    1: i32 num1 = 0,
    2: i32 num2,
    3: Operation op,
    4: optional string comment,
}
```


那些"脏脏的"struct也可以作为异常exception。

```c
exception InvalidOperation {
    1: i32 whatOp,
    2: string why
}
```


啊，现在进入酷的部分，定义一个服务。服务只需要一个名字，并且可以选择使用extends关键字继承其他服务。
 and can optionally inherit from another service using the extends keyword.


service Calculator extends shared.SharedService {


一个类似于C代码的方法声明。它有返回类型、参数和可选的它会抛出的异常列表。注意参数列表和异常列表是使用和struct、exception声明中字段列表完全一样的语法。

void ping(),


i32 add(1:i32 num1, 2:i32 num2),


i32 calculate(1:i32 logid, 2:Work w) throws (1:InvalidOperation ouch),


这个方法有一个oneway修饰符。这说明客户端只做请求且根本不收听任何响应。Oneway方法必须是void类型。
This method has a oneway modifier. That means the client only makes a request and does not listen for any response at all. Oneway methods must be void.


oneway void zip()


}

这只是覆盖了基础。查看test/folder以获得更多详细的例子。在你运行这个文件后，你生成的代码会在名字为gen-<语言名>的文件夹中出现。生成的代码并不太难看。它甚至有漂亮的缩进。
That just about covers the basics. Take a look in the test/ folder for more detailed examples. After you run this file, your generated code shows up in folders with names `gen-<language>`. The generated code isn't too scary to look at. It even has pretty indentation.

# Windows 下 Thrift 的安装及使用

版权声明：本文为CSDN博主「彼得 潘」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_43112019/article/details/92800422

## 一.  Thrift 简介

Thrift是一种接口描述语言和二进制通讯协议，它被用来定义和创建跨语言的服务。它被当作一个远程过程调用（RPC）框架来使用，是由Facebook为“大规模跨语言服务开发”而开发的。

它通过一个代码生成引擎联合了一个软件栈，来创建不同程度的、无缝的跨平台高效服务，可以使用C#、C++（基于POSIX兼容系统）、Cappuccino、Cocoa、Delphi、Erlang、Go、Haskell、Java、Node.js、OCaml、Perl、PHP、Python、Ruby和Smalltalk。虽然它以前是由Facebook开发的，但它现在是Apache软件基金会的开源项目了。

## 二. Windows 下安装

1. thrift-0.12.0.exe下载地址：http://mirror.bit.edu.cn/apache/thrift/0.12.0/thrift-0.12.0.exe
2. 将thrift-0.10.0.exe放到一个文件下，如下图。将其重命名为thrift.exe。方便调用thrift命令。
3. 配置环境变量
   向 Path 中添加变量值，值为 thrift.exe 的地址，如 F:\学习资料\thrift。
4. 测试
   命令行输入 `thrift -version`，如果输出 thrift 的版本即表明安装成功。

## 三. Windows 下 thrift 的使用

1. 编写 IDL 接口（新建 demo.thrift 文件，在 demo.thrift 中复制以下代码）

~~~thrift
namespace java com.imooc.thrift.demo
namespace py thrift.demo

service DemoService { 
	void sayHello(1:string name);
}
~~~

2. 编译

在该文件下地址栏输入 cmd，弹出命令框，再输入 `thrift --gen java demo.thrift`，编译之后会生成类DemoService.java。

提示：用 thrift 命令，生成对应语言的文件（一个文件可以编译成多种语言），能生成这些文件，说明 thrift 已经可以工作了。

