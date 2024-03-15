# 第13章 字符串

## 13.1 不可变String

String类每一个看起来会修改String值的方法，实际上都是创建了一个全新的String对象，以包括修改后的字符串内容。

## 13.2 重载“+”与StringBuilder

不可变性会带来一定的效率问题。为String对象重载的“+”操作符就是一个例子。（用于String的“+”和“+=”是Java中仅有的两个重载过的操作符，而Java不允许程序员重载任何操作符）

JDK自带的工具javap来反编译

如果你要在toString()方法中使用循环，那么最好自己创建一个StringBuilder对象

StringBuilder是Java SE5引入的，在这之前Java用的是StringBuffer。后者是线程安全的，因此开销也要大写。

## 13.3 无意义的递归

打印对象的内存地址，应该调用Object.toString()方法。所以，你不该使用this，而是应该调用super.toString()方法

## 13.4 String上的操作

| 方法                        | 参数，重载版本                                               | 应用                                                         |
| --------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 构造器                      | 重载版本：默认版本，String，StringBuilder，StringBuffer，char数组，byte数组 | 创建String对象                                               |
| length()                    |                                                              | String中字符的个数                                           |
| charAt()                    | int索引                                                      | 取得String中该索引位置上的char                               |
| getChars(),getBytes()       | 要复制部分的起点和终点索引，复制的目标数组，目标数组的起始索引 | 复制char或byte到一个目标数组中                               |
| toCharArray()               |                                                              | 生成了一个char[]，包含String的所有字符                       |
| equals(),equalsIgnoreCase() | 与之进行比较的String                                         | 比较两个String的内容是否相同                                 |
| compareTo()                 | 与之进行比较的String                                         | 按词典顺序比较String的内容，比较结果为负数、零或正数。注意，大小写并不等价 |
| contains()                  | 要搜索的CharSequence                                         | 如果该String对象包含参数的内容，则返回true                   |
| contentEquals()             | 与之进行比较的CharSequence或StringBuffer                     | 如果该String与参数的内容完全一致，则返回true                 |
| equalsIgnoreCase()          | 与之进行比较的String                                         | 忽略大小写，如果两个String的内容相同，则返回true             |
| regionMatcher()             | 该String的索引偏移量，另一个String及其索引偏移量，要比较的长度。重载版本添加了“忽略大小写”功能 | 返回boolean结果，以表明所比较区域是否相等                    |
| startsWith()                | 可能的起始String。重载版本在参数中添加了偏移量               | 返回boolean结果，以表明该String是否以此参数起始              |
| endsWith()                  | 该String可能的后缀String                                     | 返回boolean结果，以表明此参数是否该字符串的后缀              |
| indexOf(),lastIndexOf()     | 重载版本包括：char, char与起始索引，String，String与起始索引 | 如果该String并不包含此参数，就返回-1，否则返回此参数在String中的起始索引。lastIndexOf()是从后往前搜索 |
| substring()(subSequence())  | 重载版本：起始索引; 起始索引+终点坐标                        | 返回一个新的String，以包含参数指定的子字符串                 |
| concat()                    | 要连接的String                                               | 返回一个新的String对象，内容为原始String连接上参数String     |
| replace()                   | 要替换的字符， 用来进行替换的新字符。也可以用一个CharSequence来替换另一个CharSequence | 返回替换字符后的新String对象，如果没有替换发生，则返回原始的String对象 |
| toLowerCase() toUpperCase() |                                                              | 将字符的大小写改变后，返回一个新String对象。如果没有改变发生，则返回原始的String对象 |
| trim()                      |                                                              | 将String两端的空白字符删除后，返回一个新的String对象。如果没有改变发生，则返回原始的String对象 |
| valueOf()                   | 重载版本：Object; char[]; char[], 偏移量, 与字符的个数; boolean; char; int; long; float; double | 返回一个表示参数内容的String                                 |
| intern()                    |                                                              | 为每个唯一的字符序列生成一个且仅生成一个String引用           |

## 13.5 格式化输出

Java SE 5推出了C语言中printf()风格的格式化输出这一功能。

### 13.5.1 printf()

格式占位符

### 13.5.2 System.out.format()

JavaSE5引入的format方法可以用于PrintStream或PrintWriter对象，其中也包括System.out对象。format()方法模仿自C的printf()

可以看到，format()与printf()是等价的。

### 13.5.3 Formatter类

在Java中，所有新的格式化功能都有java.util.Formatter类处理。可以将Formatter看做一个翻译器，它将你的格式化字符串与数据翻译成需要的结果。

### 13.5.4 格式化说明符

其抽象的语法：`%[argument_index$][flags][width][.precision]conversion`

使用“-”标志来改变对齐方向。

precision应用于String时，它表示打印String时输出字符的最大数量。而在将precision应用于浮点数时，它表示小数部分要显示出来的位数（默认为6位小数），如果小数位数过多则舍入，太少则在尾部补零。precision无法应用于整数，如果你对整数应用precision，则会触发异常。

### 13.5.5 Formatter转换

| 类型转换字符 | 意义               |
| ------------ | ------------------ |
| d            | 整数型（十进制）   |
| c            | Unicode字符        |
| b            | Boolean值          |
| s            | String             |
| f            | 浮点数（十进制）   |
| e            | 浮点数（科学计数） |
| x            | 整数（十六进制）   |
| h            | 散列码（十六进制） |
| %            | 字符“%”            |

程序中每个变量都用到了b转换，虽然它对各种类型都是合法的，但其行为却不一定与你想象的一致。对于boolean基本类型或Boolean对象，其转换结果是对应的true或false。但是，对于其他类型的参数，只要该参数不为null，那转换的结果就永远都是true。即使是数字0，转换结果依然为true，而在其他语言中（包括C），往往转化为false。

还有些不常用的类型转换与格式修饰符选项，你可以在JDK文档中Formatter类部分找到它们。

### 13.5.6 String.format()

Java SE 5也参考了C中的printf()方法，以生成格式化的String对象。String.format()是一个static方法，它接受与Formatter.format()方法一样的参数，但返回一个String对象。

### 一个十六进制转储（dump）工具

## 13.6 正则表达式

### 13.6.1 基础

例如要找一个数字，它可能有一个符号在最前面，那你就写一个负号加上一个问号，就像：`-?`

在正则表达式中，用`\d`表示一位数字。如果在其他语言中使用过正则表达式，那你立刻就能发现Java对反斜线\的不同处理。在其他语言中，`\\`表示“我想要在正则表达式中插入一个普通的（字面上的）反斜线，请不要给它任何特殊的意义。”而在Java中，`\\`的意思是“我要插入一个正则表达式的反斜线，所以其后的字符具有特殊的意义。”例如，如果你想表示一位数字，那么正则表达式应该是`\\d`。如果你想插入一个普通的反斜线，则应该写成这样`\\\\`。不过换行和制表符之类的东西只需使用单反斜线：`\n\t`

要表示“一个或多个之前的表达式”，应该使用+。所以，如果要表示“可能有一个负号，后面跟着一位或多位数字”，可以这样：`-?\\d+`

应用正则表达式的最简单的途径，就是利用String类的内建的功能。matches()方法

在正则表达式中，括号有着将表达式分组的效果，而竖直线`|`则表示或操作。

因为字符+在正则表达式中有特殊意义，所以必须使用`\\`将其转移，使之称为表达式中的一个普通字符。

String类还自带了一个非常有用的正则表达式工具——split()方法，其功能是“将字符串从正则表达式匹配的地方切开。”

`\W`,意思是非单词字符（如果W小写，`\w`，则表示一个单词字符）。

在原始字符串中，与正则表达式匹配的部分，在split()结果中都不存在了。

String.split()还有一个重载的版本，它允许你限制字符串分割的次数。

String类自带的最后一个正则表达式工具是“替换”。你可以只替换正则表达式第一个匹配的子串，或是替换所有匹配的地方。

稍后你会看到，String之外的正则表达式还有更强大的替换工具，例如可以通过方法调用执行替换。而且，如果正则表达式不是只使用一次的话，非String对象的正则表达式明显具备更佳的性能。

### 13.6.2 创建正则表达式

正则表达式的完整构造子列表，请参考JDK文档java.util.regex包的Pattern类。

| 字符   | 意义                              |
| ------ | --------------------------------- |
| B      | 指定字符B                         |
| \xhh   | 十六进制值为0xhh的字符            |
| \uhhhh | 十六进制表示为0xhhhh的Unicode字符 |
| \t     | 制表符Tab                         |
| \n     | 换行符                            |
| \r     | 回车                              |
| \f     | 换页                              |
| \e     | 转义（Escape）                    |

当你学会使用字符类（character class）之后，正则表达式的威力才能真正显现出来。以下是一些创建字符类的典型方式，以及一些预定义的类：

| 字符类       | 意义                                                         |
| ------------ | ------------------------------------------------------------ |
| .            | 任意字符                                                     |
| [abc]        | 包含a、b和c的任何字符（和a\|b\|c作用相同）                   |
| [^abc]       | 除了a、b和c之外的任何字符（否定）                            |
| [a-zA-Z]     | 从a到z或从A到Z的任何字符（范围）                             |
| [abc[hij]]   | 任意a、b、c、h、i 和 j 字符（与a\|b\|c\|h\|i\|j作用相同）（合并） |
| [a-z&&[hij]] | 任意h、i 或 j（交）                                          |
| \s           | 空白符（空格、tab、换行、换页和回车）                        |
| \S           | 非空白符(`[^\s]`)                                            |
| \d           | 数字[0-9]                                                    |
| \D           | 非数字`[^0-9]`                                               |
| \w           | 词字符[a-zA-Z0-9]                                            |
| \W           | 非词字符`[^\w]`                                              |

逻辑操作符

XY	Y跟在X后面

X|Y	X或Y

（X）	捕获组（capturing group），可以在表达式中用`\i`引用第i个捕获组

边界匹配符

`^`	一行的起始

`$`	一行的结束

`\b`	词的边界

`\B`	非词的边界

`\G`	前一个匹配的结束

### 13.6.3 量词

量词描述了一个模式吸收文本的方式：

- 贪婪型：量词总是贪婪的，除非有其他选项被设置。贪婪表达式会为所有可能的模式发现尽可能多的匹配。导致此问题的一个典型理由就是假定我们的模式仅能匹配第一个可能的字符组，如果它是贪婪的，那么它就会继续往下匹配。
- 勉强型：用问号来指定，这个量词匹配满足模式所需的最少字符数。因此也称为懒惰的，最少匹配的、非贪婪的、或不贪婪的。
- 占有型：目前，这种类型的量词只有在Java语言中才可用（其他语言中不可用），并且也更高级，因此我们大概不会立刻用到它。当正则表达式被应用于字符串时，它会产生相当多的状态，以便在匹配失效时可以回溯。而“占有的”量词并不保存这些中间状态，因此它们可以防止回溯。它们常常用于防止正则表达式失控，因此可以使正则表达式执行起来更有效。

| 贪婪型 | 勉强型  | 占有型  | 如何匹配              |
| ------ | ------- | ------- | --------------------- |
| X?     | X??     | X?+     | 一个或零个X           |
| X*     | X*?     | X*+     | 零个或多个X           |
| X+     | X+?     | X++     | 一个或多个X           |
| X{n}   | X{n}?   | X{n}+   | 恰好n次X              |
| X{n,}  | X{n,}?  | X{n,}+  | 至少n次X              |
| X{n,m} | X{n,m}? | X{n,m}+ | X至少n次，且不超过m次 |

接口CharSequence从CharBuffer、String、StringBuffer、StringBuilder类中抽象出了字符序列的一般化定义。因此，这些类都实现了该接口。多数正则表达式操作都接受CharSequence类型的参数。

### 13.6.4 Pattern和Matcher

static Pattern.compile()方法编译你的正则表达式。它会根据你的String类型的正则表达式生成一个Pattern对象。接下来，把你想要检索的字符串传入Pattern对象的matcher()方法。matcher()方法会生成一个Matcher对象，它有很多功能可用。例如它的replaceAll()方法能将所有匹配的部分都替换成你传入的参数。

Pattern类提供了static方法：`static boolean matches(String regex, CharSequence input)` 该方法用以检查regex是否匹配整个CharSequence类型的input参数。编译后的Pattern对象还提供了split()方法，它从匹配了regex的地方分割输入字符串，返回分割后的子字符串String数组。

通过调用Pattern.matcher()方法，并传入一个字符串参数，我们得到了一个Matcher对象，使用Matcher上的方法，我们将能够判断各种不同类型的匹配是否成功。

其中matches()方法用来判断整个输入字符串是否匹配正则表达式模式，而lookingAt()则用来判断该字符串（不必是整个字符串）的始部分是否能够匹配模式。

Matcher.find()方法可用来CharSequence中查找多个匹配。

组（groups）是用括号划分的正则表达式。

Matcher对象提供了一系列方法，用以获取与组相关的信息：public int groupCount()返回该匹配器的模式中的分组数目，第0组不包括在内。public String group()返回前一次匹配操作（例如find(）)的第0组（整个匹配）。public String group(int i) 返回在前一次匹配期间指定的组号，如果匹配成功，但是指定的组没有匹配输入字符串的任何部分，则会返回null。public int start(int group)返回在前一次匹配操作中寻找到的组的起始索引。public int end(int group)返回在前一次匹配操作中寻找到的组的最后一个字符索引加一的值。

Pattern标记

在这些标记中，Pattern.CASE_INSENSITIVE,Patten.MULTILINE以及Pattern.COMMENTS（对声明或文档有用）特别有用。

### 13.6.5 split()

split()方法将输入字符串断开成字符串对象数组，断开边界由下列正则表达式确定。

### 13.6.6 替换操作

replaceFirst(String replacement)

replaceAll(String replacement)

appendReplacement(StringBuffer sbuf, String replacement)

appendTail(StringBuffer sbuf)

### 13.6.7 reset()

### 13.6.8 正则表达式与Java I/O

## 13.7 扫描输入

StringReader将String转化为可读的流对象，然后用这个对象来构造BufferedReader对象，因为我们要用BufferReader的readLine()方法。

Java SE 5 新增了Scanner类

Scanner的构造器可以接受任何类型的输入对象，包括File对象、InputStream、String或者Readable对象。Readable是Java SE 5中新加入的接口，表示“具有read()方法的某种东西”。BufferdReader也归于此类。有了Scanner，所有的输入、分词以及翻译的操作都隐藏在不同类型的next方法中。	Scanner还有相应的hasNext方法，用以判断下一个输入分词是否所需的类型。

Scanner有一个假设，在输入结束时会抛出IOException，所以Scanner会把IOException吞掉。不过通过ioException()方法，你可以找到最近发生的异常，因此，你可以在必要时检查它。

### 13.7.1 Scanner定界符

默认情况下，Scanner根据空白字符对输入进行分词，但是你可以用正则表达式指定自己所需的定界符。

useDelimiter()设置定界符，同时还有一个delimiter()方法用来返回当前正在作为定界符使用的Pattern对象。

### 13.7.2 用正则表达式扫描

## 13.8 StringTokenizer

基本上，我们可以放心地说，StringTokenizer已经可以废弃不用了。

