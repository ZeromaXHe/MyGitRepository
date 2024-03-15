# Linux指令列表

mkdir 创建目录

vim 创建/查看文件

mv 改名/移动

env 查看环境变量

chmod 修改权限：例如`chmod 777 a.txt`（其中777是代表所有用户：文件所有者（Owner）、用户组（Group）、其它用户（Other Users）拥有全部权限（读、写、执行））

# Linux指令详解

日志是系统运行的重要文件，当系统发生错误，查看日志文件是非常有必要的。但是，当文件过大时，就不能用vi 进行全部查看，需要相应的日志查看命令。如果想查看日志中的某几行，可以使用tail 、head、sed命令，如果想在日志中匹配关键字内容，可以使用grep命令,如果想让日志文件进行创建、整合添加、显示整个文件内容可以使用cat命令，cat从第一行开始开始正向显示日志内容，与此相反有个tac命令，可以从最后一行开始显示内容。

下面详细介绍一下各命令具体使用情况：

## tail

参数： tail [ -f ] [ -c Number | -n Number | -m Number | -b Number | -k Number ] [ File ] 

参数说明： 

-f 该参数用于监视File文件增长。 
-c Number 从 Number 字节位置读取指定文件 
-n Number 从 Number 行位置读取指定文件。 
-m Number 从 Number 多字节字符位置读取指定文件，比方你的文件假设包括中文字，假设指定-c参数，可能导致截断，但使用-m则会避免该问题。 
-b Number 从 Number 表示的512字节块位置读取指定文件。 
-k Number 从 Number 表示的1KB块位置读取指定文件。 
File 指定操作的目标文件名称 

上述命令中，都涉及到number，假设不指定，默认显示10行。Number前面可使用正负号，表示该偏移从顶部还是从尾部開始计算。

tail可运行文件一般在/usr/bin/以下。

## head

head 仅仅显示前面几行

示例：
head -n 10 test.log 查询日志文件中的头10行日志;
head -n -10 test.log 查询日志文件除了最后10行的其他所有日志;

## grep

grep（global search regular expression(RE) and print out the line，全面搜索正则表达式并把行打印出来）是一种强大的文本搜索工具，它能使用正则表达式搜索文本，并把匹配的行打印出来。

grep [options] 主要参数:

－c：只输出匹配行的计数。

－I：不区分大小写(只适用于单字符)。

－h：查询多文件时不显示文件名。

－l：查询多文件时只输出包含匹配字符的文件名。

－n：显示匹配行及行号。

－s：不显示不存在或无匹配文本的错误信息。

－v：显示不包含匹配文本的所有行。

pattern正则表达式主要参数

：忽略正则表达式中特殊字符的原有含义。

^：匹配正则表达式的开始行。

$: 匹配正则表达式的结束行。

`<`：从匹配正则表达 式的行开始。

`>`：到匹配正则表达式的行结束。

[ ]：单个字符，如[A]即A符合要求 。

[-]：范围，如[A-Z]，即A、B、C一直到Z都符合要求 。

`.`：所有的单个字符。

`*` ：有字符，长度可以为0。

## sed

sed -n '5,10p' filename 说明：只查看文件的第5行到第10行。

## cat

cat主要有三大功能：

1.一次显示整个文件。$ cat filename
2.从键盘创建一个文件。$ cat > filename 只能创建新文件,不能编辑已有文件.
3.将几个文件合并为一个文件： $cat file1 file2 > file

参数：

-n 或 --number 由 1 开始对所有输出的行数编号 

-b 或 --number-nonblank 和 -n 相似，只不过对于空白行不编号

-s 或 --squeeze-blank 当遇到有连续两行以上的空白行，就代换为一行的空白行

-v 或 --show-nonprinting

tac 是将 cat 反写过来，所以他的功能就跟 cat 相反， cat 是由第一行到最后一行连续显示在萤幕上， 而 tac 则是由最后一行到第一行反向在萤幕上显示出来！

日志最常使用的三种操作命令

第一种:查看实时变化的日志(比较吃内存)

最常用的:

tail -f filename (默认最后10行,相当于增加参数 -n 10)

Ctrl+c 是退出tail命令

其他情况:

tail -n 20 filename (显示filename最后20行)

tail -n +5 filename (从第5行开始显示文件) 

第二种:搜索关键字附近的日志

最常用的:cat -n filename |grep "关键字"

其他情况:

cat filename | grep -C 5 '关键字' (显示日志里匹配字串那行以及前后5行)
cat filename | grep -B 5 '关键字' (显示匹配字串及前5行)
cat filename | grep -A 5 '关键字' (显示匹配字串及后5行)
第三种:进入编辑查找:vi(vim) 

1、进入vim编辑模式:vim filename

2、输入“/关键字”,按enter键查找

3、查找下一个,按“n”即可

退出:按ESC键后,接着再输入 :号 时,vi会在屏幕的最下方等待我们输入命令

wq! 保存退出;

q! 不保存退出;

 

其他情况:

/关键字   注:正向查找,按n键把光标移动到下一个符合条件的地方
?关键字   注:反向查找,按shift+n 键,把光标移动到下一个符合条件的


# Linux

## 出现Permission denied的解决办法

解决的办法：
~~~
$ sudo chmod -R 777 某一目录
~~~
其中
- `-R` 是指级联应用到目录里的所有子目录和文件
- `777` 是所有用户都拥有最高权限


# XShell

## 上传和下载本地文件

不确定这个指令是来自哪的，好像是得在Linux先装个东西。

~~~shell
yum install lrzsz
~~~

上传本地文件 rz

下载到本地 sz

(sz后面要加文件名，rz直接回车)

# Vim

## 快捷键

`:q` 退出（如有修改会退不出去）

`:q!` 强制退出不保存

`:wq` 保存并退出

`Shift + G` 跳到文件最后

## vim报错 E37: No write since last change (add ! to override)

故障现象：

使用vim修改文件报错，系统提示如下：

E37: No write since last change (add ! to override)

故障原因：

文件为只读文件，无法修改。

解决办法：

使用命令:w!强制存盘即可，在vim模式下，键入以下命令：

:w！

存盘后在使用vim命令检查是否保存，如未保存，编辑后重复以上操作。（不想保存就:q!）

# 环境变量

编辑/etc/profile文件 vim /etc/profile

文件末尾添加需要的环境变量 export PATH = "/usr/local/nginx/sbin/:$PATH"

source /etc/profile