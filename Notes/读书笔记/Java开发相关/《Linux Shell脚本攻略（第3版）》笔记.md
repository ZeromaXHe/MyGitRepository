# 第1章 小试牛刀

## 1.1 简介

当贝尔实验室为全新的Unix操作系统创建了交互式用户界面之后，计算机便拥有了一项独有的特性。它可以从文本文件（称为shell脚本）中读取并执行命令，就好像这些命令是在终端中输入的一样。

这种能力是生产力上的一次巨大飞跃。程序员们再也不用输入一堆命令来执行一系列操作，只需要把这些命令保存在文件中，随后轻敲几次按键运行这个文件就可以了。 shell脚本不仅节省了时间，而且清楚明白地表明了所执行的操作。

Unix刚开始只支持一种交互式shell，它是由Stephen Bourne所编写的Bourne Shell（ sh）。

1989年， GNU项目的Brian Fox吸收了大量其他用户界面的特性，编写出了一种全新的shell：Bourne Again Shell（ bash）。 bash shell与Bourne Shell完全兼容，同时又增添了一些来自csh、 ksh等的功能。

随着Linux成为最流行的类Unix操作系统实现， bash shell也变成了Unix和Linux中既成事实的标准shell。

本书关注的是Linux和bash。即便如此，书中的大部分脚本都可以运行在使用了bash、 sh、 ash、dash、 ksh或其他sh风格shell的Linux和Unix系统中。

本章将带领读者熟悉shell环境并演示一些基本的shell特性。

## 1.2 在终端中显示输出

用户是通过终端会话同shell环境打交道的。如果你使用的是基于图形用户界面的系统，这指的就是终端窗口。如果没有图形用户界面（生产服务器或SSH会话），那么登录后你看到的就是shell提示符。

在终端中显示文本是大多数脚本和实用工具经常需要执行的任务。 shell可以使用多种方法和格式显示文本。

### 1.2.1 预备知识

命令都是在终端会话中输入并执行的。打开终端时会出现一个提示符。有很多方法可以配置提示符，不过其形式通常如下：

`username@hostname$`

或者也可以配置成root@hostname #，或者简单地显示为$或#。

$表示普通用户， #表示管理员用户root。 root是Linux系统中权限最高的用户。

> 以root用户（管理员）的身份直接使用shell来执行任务可不是个好主意。因为如果shell具备较高的权限，命令中出现的输入错误有可能造成更严重的破坏， 所以推荐使用普通用户（ shell会在提示符中以$来表明这种身份）登录系统，然后借助sudo这类工具来运行特权命令。使用sudo <command> <arguments>执行命令的效果和root一样。

shell脚本通常以shebang①起始：

```shell script
#!/bin/bash
```

> shebang这个词其实是两个字符名称（ sharp-bang）的简写。在Unix的行话里，用sharp或hash（有时候是mesh）来称呼字符“#”，用bang来称呼惊叹号“!”，因而shebang合起来就代表了这两个字符。详情请参考：http://en.wikipedia.org/wiki/Shebang_(Unix)。（注：书中脚注均为译者注。）

shebang是一个文本行， 其中#!位于解释器路径之前。 /bin/bash是Bash的解释器命令路径。 bash将以#符号开头的行视为注释。脚本中只有第一行可以使用shebang来定义解释该脚本所使用的解释器。

脚本的执行方式有两种。

(1) 将脚本名作为命令行参数：
`bash myScript.sh`

(2) 授予脚本执行权限，将其变为可执行文件：
`chmod 755 myScript.sh`
`./myScript.sh.`

如果将脚本作为bash的命令行参数来运行，那么就用不着使用shebang了。可以利用shebang来实现脚本的独立运行。可执行脚本使用shebang之后的解释器路径来解释脚本。

使用chmod命令赋予脚本可执行权限：
`$ chmod a+x sample.sh`

该命令使得所有用户可以按照下列方式执行该脚本：
`$ ./sample.sh #./表示当前目录`
或者
`$ /home/path/sample.sh #使用脚本的完整路径`

内核会读取脚本的首行并注意到shebang为#!/bin/bash。它会识别出/bin/bash并执行该脚本：
`$ /bin/bash sample.sh`

当启动一个交互式shell时，它会执行一组命令来初始化提示文本、颜色等设置。这组命令来自用户主目录中的脚本文件~/.bashrc（对于登录shell则是~/.bash_profile）。 Bash shell还维护了一个历史记录文件~/.bash_history，用于保存用户运行过的命令。

> ~表示主目录，它通常是/home/user，其中user是用户名，如果是root用户， 则为/root。登录shell是登录主机后创建的那个shell。但登录图形化环境（比如GNOME、 KDE等）后所创建的终端会话并不是登录shell。使用GNOME或KDE这类显示管理器登录后并不会读取.profile或.bash_profile（绝大部分情况下不会），而使用ssh登录远程系统时则会读取.profile。 shell使用分号或换行符来分隔单个命令或命令序列。比如：
  $ cmd1 ; cmd2
  这等同于：
>
> $ cmd1
>
> $ cmd2

注释部分以#为起始，一直延续到行尾。注释行通常用于描述代码或是在调试期间禁止执行某行代码（ shell不执行脚本中的任何注释部分。）：
~~~shell script
# sample.sh - echoes "hello world"
echo "hello world"
~~~
现在让我们继续讨论基本特性。

### 1.2.2 实战演练

echo是用于终端打印的最基本命令。

默认情况下， echo在每次调用后会添加一个换行符：
~~~shell script
$ echo "Welcome to Bash"
Welcome to Bash
~~~
只需要将文本放入双引号中， echo命令就可以将其中的文本在终端中打印出来。类似地，不使用双引号也可以得到同样的输出结果：
~~~shell script
$ echo Welcome to Bash
Welcome to Bash
~~~
实现相同效果的另一种方式是使用单引号：
~~~shell script
$ echo 'text in quotes'
~~~
这些方法看起来相似，但各有特定的用途及副作用。双引号允许shell解释字符串中出现的特殊字符。单引号不会对其做任何解释。

思考下面这行命令：

~~~shell script
$ echo "cannot include exclamation - ! within double quotes"
~~~

命令输出如下：
~~~
bash: !: event not found error
~~~

如果需要打印像!这样的特殊字符，那就不要将其放入双引号中，而是使用单引号，或是在特殊字符之前加上一个反斜线（\）：
~~~shell script
$ echo Hello world !
~~~
或者
~~~shell script
$ echo 'Hello world !'
~~~
或者
~~~shell script
$ echo "Hello world \!" #将转义字符放在前面
~~~
如果不使用引号，我们无法在echo中使用分号，因为分号在Bash shell中用作命令间的分隔符：
~~~shell script
echo hello; hello
~~~
对于上面的命令，Bash将echo hello作为一个命令，将hello作为另外一个命令。

在下一条攻略中将讨论到的变量替换不会在单引号中执行。

另一个可用于终端打印的命令是printf。该命令使用的参数和C语言中的printf函数一样。例如：
~~~shell script
$ printf "Hello world"
~~~

printf命令接受引用文本或由空格分隔的参数。我们可以在printf中使用格式化字符串来指定字符串的宽度、左右对齐方式等。默认情况下，printf并不会自动添加换行符，我们必须在需要的时候手动指定，比如在下面的脚本中：
~~~shell script
#!/bin/bash 
#文件名: printf.sh 
printf "%-5s %-10s %-4s\n" No Name Mark 
printf "%-5s %-10s %-4.2f\n" 1 Sarath 80.3456 
printf "%-5s %-10s %-4.2f\n" 2 James 90.9989 
printf "%-5s %-10s %-4.2f\n" 3 Jeff 77.564
~~~
可以得到如下格式化的输出：
~~~
No   Name      Mark 
1    Sarath    80.35 
2    James     91.00 
3    Jeff      77.56
~~~

### 1.2.3 工作原理

%s、%c、%d和%f都是格式替换符（format substitution character），它们定义了该如何打印后续参数。%-5s指明了一个格式为左对齐且宽度为5的字符串替换（-表示左对齐）。如果不指明-，字符串就采用右对齐形式。宽度指定了保留给某个字符串的字符数量。对Name而言，其保留宽度是10。因此，任何Name字段的内容都会被显示在10字符宽的保留区域内，如果内容不足10个
字符，余下的则以空格填充。

对于浮点数，可以使用其他参数对小数部分进行舍入（round off）。

对于Mark字段，我们将其格式化为%-4.2f，其中.2指定保留两位小数。注意，在每行的格式字符串后都有一个换行符（`\n`）

### 1.2.4 补充内容

使用echo和printf的命令选项时，要确保选项出现在命令中的所有字符串之前，否则Bash会将其视为另外一个字符串。

#### 1. 在echo中转义换行符

默认情况下，echo会在输出文本的尾部追加一个换行符。可以使用选项-n来禁止这种行为。echo同样接受双包含转义序列的双引号字符串作为参数。在使用转义序列时，需要使用echo -e "包含转义序列的字符串"这种形式。例如：
~~~shell script
echo -e "1\t2\t3"
~~~
~~~ 
1 2 3
~~~

#### 2. 打印彩色输出

脚本可以使用转义序列在终端中生成彩色文本。

文本颜色是由对应的色彩码来描述的。其中包括：重置=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，洋红=35，青色=36，白色=37。

要打印彩色文本，可输入如下命令：
~~~shell script
echo -e "\e[1;31m This is red text \e[0m"
~~~
其中\e[1;31m是一个转义字符串，可以将颜色设为红色，\e[0m将颜色重新置回。只需要将31替换成想要的色彩码就可以了。

对于彩色背景，经常使用的颜色码是：重置=0，黑色=40，红色=41，绿色=42，黄色=43，蓝色=44，洋红=45，青色=46，白色=47。

要设置彩色背景的话，可输入如下命令：
~~~shell script
echo -e "\e[1;42m Green Background \e[0m"
~~~
这些例子中包含了一些转义序列。可以使用man console_codes来查看相关文档。

## 1.3 使用变量与环境变量

所有的编程语言都利用变量来存放数据，以备随后使用或修改。和编译型语言不同，大多数脚本语言不要求在创建变量之前声明其类型。用到什么类型就是什么类型。在变量名前面加上一个美元符号就可以访问到变量的值。shell定义了一些变量，用于保存用到的配置信息，比如可用的打印机、搜索路径等。这些变量叫作环境变量。

### 1.3.1 预备知识

变量名由一系列字母、数字和下划线组成，其中不包含空白字符。常用的惯例是在脚本中使用大写字母命名环境变量，使用驼峰命名法或小写字母命名其他变量。

所有的应用程序和脚本都可以访问环境变量。可以使用env或printenv命令查看当前shell中所定义的全部环境变量：
~~~
$> env 
PWD=/home/clif/ShellCookBook 
HOME=/home/clif 
SHELL=/bin/bash 
# …… 其他行
~~~

要查看其他进程的环境变量，可以使用如下命令：
~~~shell script
cat /proc/$PID/environ
~~~
其中，PID是相关进程的进程ID（PID是一个整数）。

假设有一个叫作gedit的应用程序正在运行。我们可以使用pgrep命令获得gedit的进程ID：
~~~shell script
$ pgrep gedit 
~~~
~~~
12501
~~~
那么，你就可以执行以下命令来查看与该进程相关的环境变量：
~~~shell script
$ cat /proc/12501/environ
~~~
~~~ 
GDM_KEYBOARD_LAYOUT=usGNOME_KEYRING_PID=1560USER=slynuxHOME=/home/slynux
~~~

> 注意，实际输出的环境变量远不止这些，只是考虑到页面篇幅的限制，这里删除了不少内容。
>
> 特殊文件/proc/PID/environ是一个包含环境变量以及对应变量值的列表。每一个变量以name=value的形式来描述，彼此之间由null字符（\0）分隔。形式上确实不太易读。

要想生成一份易读的报表，可以将cat命令的输出通过管道传给tr，将其中的\0替换成\n：
~~~shell script
$ cat /proc/12501/environ | tr '\0' '\n'
~~~

### 1.3.2 实战演练

可以使用等号操作符为变量赋值：
~~~shell script
varName=value 
~~~
varName是变量名，value是赋给变量的值。如果value不包含任何空白字符（例如空格），那么就不需要将其放入引号中，否则必须使用单引号或双引号。

>注意，var = value不同于var=value。把var=value写成var = value是一个常见的错误。两边没有空格的等号是赋值操作,加上空格的等号表示的是等量关系测试。

在变量名之前加上美元符号（$）就可以访问变量的内容。
~~~shell script
var="value" #将"value"赋给变量var 
echo $var 
~~~
也可以这样写：
~~~shell script
echo ${var} 
~~~
输出如下：
~~~
value
~~~
我们可以在printf、echo或其他命令的双引号中引用变量值：
~~~shell script
#!/bin/bash 
#文件名:variables.sh 
fruit=apple 
count=5 
echo "We have $count ${fruit}(s)"
~~~
输出如下：
~~~
We have 5 apple(s)
~~~

因为shell使用空白字符来分隔单词，所以我们需要加上一对花括号来告诉shell这里的变量名是fruit，而不是fruit(s)。

环境变量是从父进程中继承而来的变量。例如环境变量HTTP_PROXY，它定义了Internet连接应该使用哪个代理服务器。

该环境变量通常被设置成：
~~~shell script
HTTP_PROXY=192.168.1.23:3128 
export HTTP_PROXY
~~~
export命令声明了将由子进程所继承的一个或多个变量。这些变量被导出后，当前shell脚本所执行的任何应用程序都会获得这个变量。shell创建并用到了很多标准环境变量，我们也可以导出自己的环境变量。

例如，PATH变量列出了一系列可供shell搜索特定应用程序的目录。一个典型的PATH变量包含如下内容:

~~~
$ echo $PATH 
/home/slynux/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
~~~

各目录路径之间以:分隔。$PATH通常定义在/etc/environment、/etc/profile或~/.bashrc中。

如果需要在PATH中添加一条新路径，可以使用如下命令：
~~~shell script
export PATH="$PATH:/home/user/bin"
~~~
也可以使用
~~~
$ PATH="$PATH:/home/user/bin" 
$ export PATH 
$ echo $PATH 
/home/slynux/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/home/user/bin
~~~
这样，我们就将/home/user/bin添加到了PATH中。

另外还有一些众所周知的环境变量：HOME、PWD、USER、UID、SHELL等。

> 使用单引号时，变量不会被扩展（expand），仍依照原样显示。这意味着$ echo '$var'会显示$var。
>
> 但如果变量$var已经定义过，那么$ echo "$var"会显示出该变量的值；如果没有定义过，则什么都不显示。

### 1.3.3 补充内容

shell还有很多内建特性。下面就是其中一些。

#### 1.获得字符串的长度

可以用下面的方法获得变量值的长度：
~~~shell script
length=${#var} 
~~~
考虑这个例子：
~~~
$ var=12345678901234567890 
$ echo ${#var} 
20 
~~~
length就是字符串所包含的字符数。

#### 2.识别当前所使用的shell

可以通过环境变量SHELL获知当前使用的是哪种shell：
~~~shell script
echo $SHELL 
~~~
也可以用
~~~shell script
echo $0 
~~~
例如：
~~~
$ echo $SHELL 
/bin/bash
~~~
执行echo $0命令也可以得到同样的输出：
~~~
$ echo $0 
/bin/bash
~~~

#### 3.检查是否为超级用户

环境变量UID中保存的是用户ID。它可以用于检查当前脚本是以root用户还是以普通用户的身份运行的。例如：

~~~shell script
If [ $UID -ne 0 ]; then 
 echo Non root user. Please run as root. 
else 
 echo Root user 
fi 
~~~

注意，[实际上是一个命令，必须将其与剩余的字符串用空格隔开。上面的脚本也可以写成：
~~~shell script
If test $UID -ne 0:1 
 then 
  echo Non root user. Please run as root. 
 else
  echo Root user 
fi 
~~~
root用户的UID是0。

#### 4.修改Bash的提示字符串（username@hostname:~$）

当我们打开终端或是运行shell时，会看到类似于user@hostname:/home/$的提示字符串。不同的GNU/Linux发布版中的提示字符串及颜色各不相同。我们可以利用PS1环境变量来定义主提示字符串。默认的提示字符串是在文件~/.bashrc中的某一行设置的。

 查看设置变量PS1的那一行：
~~~
$ cat ~/.bashrc | grep PS1 
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
~~~
 如果要修改提示字符串，可以输入：
~~~
slynux@localhost: ~$ PS1="PROMPT>" #提示字符串已经改变
PROMPT> Type commands here.
~~~
 我们可以利用类似于\e[1;31的特定转义序列来设置彩色的提示字符串（参考1.2节的内
容）。

还有一些特殊的字符可以扩展成系统参数。例如：\u可以扩展为用户名，\h可以扩展为主
机名，而\w可以扩展为当前工作目录。

## 1.4 使用函数添加环境变量

环境变量通常保存了可用于搜索可执行文件、库文件等的路径列表。例如$PATH和$LD_LIBRARY_PATH，它们通常看起来像这样：
~~~
PATH=/usr/bin; /bin 
LD_LIBRARY_PATH=/usr/lib; /lib
~~~
这意味着只要shell执行应用程序（二进制文件或脚本）时，它就会首先查找/usr/bin，然后查找/bin。

当你使用源代码构建并安装程序时，通常需要为新的可执行文件和库文件添加特定的路径。假设我们要将myapp安装到/opt/myapp，它的二进制文件在/opt/myapp/bin目录中，库文件在/opt/ myapp /lib目录中。

### 1.4.1 实战演练

这个例子展示了如何将新的路径添加到环境变量的起始部分。第一个例子利用我们目前所讲过的知识来实现，第二个例子创建了一个函数来简化修改操作。本章随后会讲到函数。

~~~shell script
export PATH=/opt/myapp/bin:$PATH 
export LD_LIBRARY_PATH=/opt/myapp/lib; $LD_LIBRARY_PATH
~~~
PATH和LD_LIBRARY_PATH现在看起来应该像这样：
~~~
PATH=/opt/myapp/bin:/usr/bin:/bin 
LD_LIBRARY_PATH=/opt/myapp/lib:/usr/lib; /lib
~~~
我们可以在.bashrc文件中定义如下函数，简化路径添加操作：
~~~shell script
prepend() { [ -d "$2" ] && eval $1=\"$2':'\$$1\" && export $1; }
~~~
该函数用法如下：
~~~shell script
prepend PATH /opt/myapp/bin 
prepend LD_LIBRARY_PATH /opt/myapp/lib
~~~

### 1.4.2 工作原理

函数prepend()首先确认该函数第二个参数所指定的目录是否存在。如果存在，eval表达式将第一个参数所指定的变量值设置成第二个参数的值加上`:`（路径分隔符），随后再跟上第一个参数的原始值。

在进行添加时，如果变量为空，则会在末尾留下一个`:`。要解决这个问题，可以对该函数再做一些修改：

~~~shell script
prepend() { [ -d "$2" ] && eval $1=\"$2\$\{$1:+':'\$$1\}\" && export $1 ; }
~~~

> 在这个函数中，我们引入了一种shell参数扩展的形式：`${parameter:+expression}`
> 如果parameter有值且不为空，则使用`expression`的值。通过这次修改，在向环境变量中添加新路径时，当且仅当旧值存在，才会增加`:`。

## 1.5 使用shell进行数学运算

Bash shell使用let、(( ))和[]执行基本的算术操作。工具expr和bc可以用来执行高级操作。

### 实战演练

(1) 可以像为变量分配字符串值那样为其分配数值。这些值会被相应的操作符视为数字。
~~~shell script
#!/bin/bash 
no1=4; 
no2=5;
~~~

(2) let命令可以直接执行基本的算术操作。当使用let时，变量名之前不需要再添加$，例如：
~~~shell script
let result=no1+no2 
echo $result 
~~~
let命令的其他用法如下：

 自加操作
~~~shell script
$ let no1++
~~~
 自减操作
~~~shell script
$ let no1--
~~~
 简写形式
~~~shell script
let no+=6 
let no-=6
~~~
它们分别等同于`let no=no+6`和`let no=no-6`。 

 其他方法

操作符[]的使用方法和let命令一样：
~~~shell script
result=$[ no1 + no2 ]
~~~
在[]中也可以使用$前缀，例如：
~~~shell script
result=$[ $no1 + 5 ]
~~~
也可以使用操作符(())。出现在(())中的变量名之前需要加上$：
~~~shell script
result=$(( no1 + 50 ))
~~~
expr同样可以用于基本算术操作：
~~~shell script
result=`expr 3 + 4` 
result=$(expr $no1 + 5)
~~~
以上这些方法不支持浮点数，只能用于整数运算。

(3) bc是一个用于数学运算的高级实用工具，这个精密的计算器包含了大量的选项。我们可以借助它执行浮点数运算并使用一些高级函数：
~~~
echo "4 * 0.56" | bc 
2.24 
no=54; 
result=`echo "$no * 1.5" | bc` 
echo $result 
81.0
~~~
bc可以接受操作控制前缀。这些前缀之间使用分号分隔。

 设定小数精度。在下面的例子中，参数scale=2将小数位个数设置为2。因此，bc将会输出包含两个小数位的数值：
~~~
echo "scale=2;22/7" | bc 
3.14
~~~
 进制转换。用bc可以将一种进制系统转换为另一种。来看看下面的代码是如何在十进制与二进制之间相互转换的：
~~~
#!/bin/bash 
用途：数字转换
no=100 
echo "obase=2;$no" | bc 
1100100 
no=1100100 
echo "obase=10;ibase=2;$no" | bc 
100 
~~~
 计算平方以及平方根。
~~~
echo "sqrt(100)" | bc #Square root 
echo "10^10" | bc #Square
~~~

## 1.6 玩转文件描述符与重定向

文件描述符是与输入和输出流相关联的整数。最广为人知的文件描述符是stdin、stdout和stderr。我们可以将某个文件描述符的内容重定向到另一个文件描述符中。下面展示了一些文件描述符操作和重定向的例子。

### 1.6.1 预备知识

在编写脚本的时候会频繁用到标准输入（stdin）、标准输出（stdout）和标准错误（stderr）。脚本可以使用大于号将输出重定向到文件中。命令产生的文本可能是正常输出，也可能是错误信息。默认情况下，正常输出（stdout）和错误信息（stderr）都会显示在屏幕上。我们可以分别为其指定特定的文件描述符来区分两者。

文件描述符是与某个打开的文件或数据流相关联的整数。文件描述符0、1以及2是系统预留的。

 0 —— stdin （标准输入）。

 1 —— stdout（标准输出）。

 2 —— stderr（标准错误）

### 1.6.2 实战演练

(1) 使用大于号将文本保存到文件中：
~~~
$ echo "This is a sample text 1" > temp.txt
~~~
该命令会将输出的文本保存在temp.txt中。如果temp.txt已经存在，大于号会清空该文件中先前的内容。

(2) 使用双大于号将文本追加到文件中：
~~~
$ echo "This is sample text 2" >> temp.txt
~~~
(3) 使用cat查看文件内容：
~~~
$ cat temp.txt 
This is sample text 1 
This is sample text 2
~~~
接着来看看如何重定向stderr。当命令产生错误信息时，该信息会被输出到stderr流。考虑下面的例子：
~~~
$ ls + 
ls: cannot access +: No such file or directory
~~~
这里，+是一个非法参数，因此会返回错误信息。

> TIP: 
> 成功和不成功的命令
> 当一个命令发生错误并退回时，它会返回一个非0的退出状态；而当命令成功完成后，它会返回为0的退出状态。退出状态可以从特殊变量$?中获得（在命令结束之后立刻运行echo $?，就可以打印出退出状态）。

下面的命令会将stderr文本打印到屏幕上，而不是文件中（因为stdout并没有输出，所以out.txt的内容为空）：
~~~
$ ls + > out.txt 
ls: cannot access +: No such file or directory
~~~
在下面的命令中，我们使用2>（数字2以及大于号）将stderr重定向到out.txt：
~~~
$ ls + 2> out.txt #没有问题
~~~
你可以将stderr和stdout分别重定向到不同的文件中：
~~~
$ cmd 2>stderr.txt 1>stdout.txt
~~~

下面这种更好的方法能够将stderr转换成stdout，使得stderr和stdout都被重定向到同一个文件中：
~~~
$ cmd 2>&1 alloutput.txt 
~~~
或者这样
~~~
$ cmd &> output.txt
~~~

如果你不想看到或保存错误信息，那么可以将stderr的输出重定向到/dev/null，保证一切都
会被清除得干干净净。假设我们有3个文件，分别是a1、a2、a3。但是普通用户对文件a1没有“读
-写-执行”权限。如果需要打印文件名以a起始的所有文件的内容，可以使用cat命令。来设置
一些测试文件：
~~~
$ echo A1 > a1 
$ echo A2 > a2 
$ echo A3 > a3 
$ chmod 000 a1 #清除所有权限
~~~
使用通配符（a*）显示这些文件内容的话，系统会显示出错信息，因为文件a1没有可读权限：
~~~
$ cat a* 
cat: a1: Permission denied 
A2 
A3 
~~~
其中，cat: a1: Permission denied属于stderr信息。我们可以将其重定向到一个文件中，同时将stdout信息发送到终端。
~~~
$ cat a* 2> err.txt # stderr被重定向到err.txt 
A2 
A3 
$ cat err.txt 
cat: a1: Permission denied
~~~
我们在处理一些命令输出的同时还想将其保存下来，以备后用。stdout作为单数据流（single stream），可以被重定向到文件或是通过管道传入其他程序，但是无法两者兼得。

有一种方法既可以将数据重定向到文件，还可以提供一份重定向数据的副本作为管道中后续命令的stdin。tee命令从stdin中读取，然后将输入数据重定向到stdout以及一个或多个文件中。
~~~
command | tee FILE1 FILE2 | otherCommand
~~~
在下面的代码中，tee命令接收到来自stdin的数据。它将stdout的一份副本写入文件out.txt，同时将另一份副本作为后续命令的stdin。命令cat -n为从stdin中接收到的每一行数据前加上行号并将其写入stdout：
~~~
$ cat a* | tee out.txt | cat -n 
cat: a1: Permission denied 
 1 A2 
 2 A3
~~~
使用cat查看out.txt的内容：
~~~
$ cat out.txt 
A2 
A3
~~~

> 注意，cat: a1: Permission denied 并没有在文件内容中出现，因为这些信息被发送到了stderr，而tee只能从stdin中读取。

默认情况下，tee命令会将文件覆盖，但它提供了一个-a选项，可用于追加内容。
~~~
$ cat a* | tee -a out.txt | cat –n
~~~
带有参数的命令可以写成：command FILE1 FILE2 ...，或者就简单地使用command FILE。

要发送输入内容的两份副本给stdout，使用-作为命令的文件名参数即可：
~~~
$ cmd1 | cmd2 | cmd -
~~~
例如：
~~~
$ echo who is this | tee - 
who is this 
who is this
~~~
也可以将/dev/stdin作为输出文件名来代替stdin。类似地，使用/dev/stderr代表标准错误，/dev/stdout代表标准输出。这些特殊的设备文件分别对应stdin、stderr和stdout。

### 1.6.3 工作原理

重定向操作符（>和>>）可以将输出发送到文件中，而不是终端。>和>>略有差异。尽管两者都可以将文本重定向到文件，但是前者会先清空文件，然后再写入内容，而后者会将内容追加到现有文件的尾部。

默认情况下，重定向操作针对的是标准输出。如果想使用特定的文件描述符，你必须将描述符编号置于操作符之前。

`>`等同于`1>`；对于`>>`来说，情况也类似（即`>>`等同于`1>>`）。

处理错误时，来自stderr的输出被倾倒入文件/dev/null中。`./dev/null`是一个特殊的设备文件，它会丢弃接收到的任何数据。null设备通常也被称为黑洞，因为凡是进入其中的数据都将一去不返。

### 1.6.4 补充内容

从stdin读取输入的命令能以多种方式接收数据。可以用cat和管道来指定我们自己的文件描述符。考虑下面的例子：
~~~
$ cat file | cmd 
$ cmd1 | cmd2
~~~
1. 将文件重定向到命令

借助小于号（<），我们可以像使用stdin那样从文件中读取数据：
~~~
$ cmd < file
~~~
2. 重定向脚本内部的文本块

可以将脚本中的文本重定向到文件。要想将一条警告信息添加到自动生成的文件顶部，可以使用下面的代码：
~~~shell script 
#!/bin/bash 
cat<<EOF>log.txt 
This is a generated file. Do not edit. Changes will be overwritten. 
EOF 
~~~
出现在cat <<EOF>log.txt与下一个EOF行之间的所有文本行都会被当作stdin数据。log.txt文件的内容显示如下：
~~~
$ cat log.txt 
This is a generated file. Do not edit. Changes will be overwritten.
~~~
3. 自定义文件描述符

文件描述符是一种用于访问文件的抽象指示器（abstract indicator）。存取文件离不开被称为“文件描述符”的特殊数字。0、1和2分别是stdin、stdout和stderr预留的描述符编号。

exec命令创建全新的文件描述符。如果你熟悉其他编程语言中的文件操作，那么应该对文件打开模式也不陌生。常用的打开模式有3种。

 只读模式。

 追加写入模式。

 截断写入模式。

`<`操作符可以将文件读入stdin。`>`操作符用于截断模式的文件写入（数据在目标文件内容被截断之后写入）。`>>`操作符用于追加模式的文件写入（数据被追加到文件的现有内容之后，而且该目标文件中原有的内容不会丢失）。文件描述符可以用以上3种模式中的任意一种来创建。

创建一个用于读取文件的文件描述符：
~~~
$ exec 3<input.txt #使用文件描述符3打开并读取文件
~~~

我们可以这样使用它：
~~~
$ echo this is a test line > input.txt 
$ exec 3<input.txt
~~~
现在你就可以在命令中使用文件描述符3了。例如：
~~~
$ cat<&3 
this is a test line
~~~
如果要再次读取，我们就不能继续使用文件描述符3了，而是需要用exec重新创建一个新的文件描述符（可以是4）来从另一个文件中读取或是重新读取上一个文件。

创建一个用于写入（截断模式）的文件描述符：
~~~
$ exec 4>output.txt #打开文件进行写入
~~~
例如：
~~~
$ exec 4>output.txt 
$ echo newline >&4 
$ cat output.txt 
newline
~~~
创建一个用于写入（追加模式）的文件描述符：
~~~
$ exec 5>>input.txt
~~~
例如：
~~~
$ exec 5>>input.txt 
$ echo appended line >&5 
$ cat input.txt 
newline 
appended line
~~~

## 1.7 数组与关联数组

数组允许脚本利用索引将数据集合保存为独立的条目。Bash支持普通数组和关联数组，前者使用整数作为数组索引，后者使用字符串作为数组索引。当数据以数字顺序组织的时候，应该使用普通数组，例如一组连续的迭代。当数据以字符串组织的时候，关联数组就派上用场了，例如主机名称。本节会介绍普通数组和关联数组的用法。

### 1.7.1 预备知识

Bash从4.0版本才开始支持关联数组。

### 1.7.2 实战演练

定义数组的方法有很多种。

(1) 可以在单行中使用数值列表来定义一个数组：
~~~
array_var=(test1 test2 test3 test4) 
#这些值将会存储在以0为起始索引的连续位置上
~~~
另外，还可以将数组定义成一组“索引-值”：
~~~
array_var[0]="test1" 
array_var[1]="test2" 
array_var[2]="test3" 
array_var[3]="test4" 
array_var[4]="test5" 
array_var[5]="test6"
~~~
(2) 打印出特定索引的数组元素内容：
~~~
echo ${array_var[0]} 
test1 
index=5 
echo ${array_var[$index]} 
test6
~~~
(3) 以列表形式打印出数组中的所有值：
~~~
$ echo ${array_var[*]} 
test1 test2 test3 test4 test5 test6
~~~
也可以这样使用：
~~~
$ echo ${array_var[@]} 
test1 test2 test3 test4 test5 test6
~~~
(4) 打印数组长度（即数组中元素的个数）：
~~~
$ echo ${#array_var[*]}
6
~~~

### 1.7.3 补充内容

关联数组从Bash 4.0版本开始被引入。当使用字符串（站点名、用户名、非顺序数字等）作为索引时，关联数组要比数字索引数组更容易使用。

1. 定义关联数组

在关联数组中，我们可以用任意的文本作为数组索引。首先，需要使用声明语句将一个变量定义为关联数组：
~~~
$ declare -A ass_array 
~~~
声明之后，可以用下列两种方法将元素添加到关联数组中。

 使用行内“索引-值”列表：
~~~
$ ass_array=([index1]=val1 [index2]=val2)
~~~
 使用独立的“索引值”进行赋值：
~~~
$ ass_array[index1]=val1 
$ ass_array[index2]=val2
~~~
举个例子，试想如何用关联数组为水果制定价格：
~~~
$ declare -A fruits_value 
$ fruits_value=([apple]='100 dollars' [orange]='150 dollars')
~~~
用下面的方法显示数组内容：
~~~
$ echo "Apple costs ${fruits_value[apple]}" 
Apple costs 100 dollars
~~~
2. 列出数组索引

每一个数组元素都有对应的索引。普通数组和关联数组的索引类型不同。我们可以用下面的方法获取数组的索引列表：
~~~
$ echo ${!array_var[*]}
~~~
也可以这样
~~~
$ echo ${!array_var[@]}
~~~
以先前的fruits_value数组为例，运行如下命令：
~~~
$ echo ${!fruits_value[*]} 
orange apple
~~~
对于普通数组，这个方法同样可行。

## 1.8 别名

别名就是一种便捷方式，可以为用户省去输入一长串命令序列的麻烦。下面我们会看到如何使用alias命令创建别名。

### 1.8.1 实战演练

你可以执行多种别名操作。

（1）创建别名。
~~~
$ alias new_command='command sequence'
~~~
下面的命令为apt-get install创建了一个别名：
~~~
$ alias install='sudo apt-get install'
~~~
定义好别名之后，我们就可以用install来代替sudo apt-get install了。

(2) alias命令的效果只是暂时的。一旦关闭当前终端，所有设置过的别名就失效了。为了使别名在所有的shell中都可用，可以将其定义放入`~/.bashrc`文件中。每当一个新的交互式shell进程生成时，都会执行 `~/.bashrc`中的命令。
~~~
$ echo 'alias cmd="command seq"' >> ~/.bashrc
~~~
(3) 如果需要删除别名，只需将其对应的定义（如果有的话）从~/.bashrc中删除，或者使用unalias命令。也可以使用`alias example=`，这会取消别名example。

(4) 我们可以创建一个别名rm，它能够删除原始文件，同时在backup目录中保留副本。
~~~
alias rm='cp $@ ~/backup && rm $@'
~~~

> 创建别名时，如果已经有同名的别名存在，那么原有的别名设置将被新的设置取代。

# 1.8.2 补充内容

如果身份为特权用户，别名也会造成安全问题。为了避免对系统造成危害，你应该将命令转义。

1. 对别名进行转义

创建一个和原生命令同名的别名很容易，你不应该以特权用户的身份运行别名化的命令。我们可以转义要使用的命令，忽略当前定义的别名：
~~~
$ \command
~~~
字符\可以转义命令，从而执行原本的命令。在不可信环境下执行特权命令时，在命令前加上\来忽略可能存在的别名总是一种良好的安全实践。这是因为攻击者可能已经将一些别有用心的命令利用别名伪装成了特权命令，借此来盗取用户输入的重要信息。

2. 列举别名

alias命令可以列出当前定义的所有别名：
~~~
$ aliasalias lc='ls -color=auto' 
alias ll='ls -l' 
alias vi='vim'
~~~

## 1.9 采集终端信息

编写命令行shell脚本时，总是免不了处理当前终端的相关信息，比如行数、列数、光标位置、遮盖的密码字段等。这则攻略将帮助你学习如何采集并处理终端设置。

### 1.9.1 预备知识

tput和stty是两款终端处理工具。

### 1.9.2 实战演练

下面是一些tput命令的功能演示。

 获取终端的行数和列数：
~~~shell script
tput cols 
tput lines 
~~~
 打印出当前的终端名：
~~~shell script
tput longname
~~~
 将光标移动到坐标(100,100)处：
~~~shell script
tput cup 100 100
~~~
 设置终端背景色：
~~~shell script
tput setb n
~~~
其中，n可以在0到7之间取值。

 设置终端前景色：
~~~shell script
tput setf n 
~~~
其中，n可以在0到7之间取值。

> 包括常用的color ls在内的一些命令可能会重置前景色和背景色。

 设置文本样式为粗体：
~~~shell script
tput bold
~~~
 设置下划线的起止：
~~~shell script
tput smul 
tput rmul 
~~~
 删除从当前光标位置到行尾的所有内容：
~~~shell script
tput ed 
~~~
 输入密码时，脚本不应该显示输入内容。在下面的例子中，我们将看到如何使用stty来实现这一需求：
~~~shell script
#!/bin/sh 
#Filename: password.sh 
echo -e "Enter password: " 
# 在读取密码前禁止回显
stty -echo 
read password 
# 重新允许回显
stty echo 
echo 
echo Password read.
~~~

> stty命令的选项-echo禁止将输出发送到终端，而选项echo则允许发送输出。

# 1.10 获取并设置日期及延时

延时可以用来在程序执行过程中等待一段时间（比如1秒），或是每隔几秒钟（或是几个月）监督某项任务。与时间和日期打交道需要理解如何描述并处理这两者。这则攻略会告诉你怎样使用日期以及延时。

### 1.10.1 预备知识

日期能够以多种格式呈现。在系统内部，日期被存储成一个整数，其取值为自1970年1月1 日0时0分0秒①起所流逝的秒数。这种计时方式称为纪元时或Unix时间。

可以在命令行中设置系统日期。下面来看看对其进行读取和设置的方法。

> ① Unix认为UTC 1970年1月1日0点是纪元时间。POSIX标准推出后，这个时间也被称为POSIX时间。

### 1.10.2 实战演练

可以以不同的格式来读取、设置日期。

(1) 读取日期：
~~~
$ date 
Thu May 20 23:09:04 IST 2010
~~~
(2) 打印纪元时：
~~~
$ date +%s 
1290047248
~~~
data命令可以将很多不同格式的日期转换成纪元时。这就允许你使用多种日期格式作为输入。如果要从系统日志中或者其他标准应用程序生成的输出中获取日期信息，就完全不用烦心日期的格式问题。

将日期转换成纪元时：
~~~
$ date --date "Wed mar 15 08:09:16 EDT 2017" +%s 
1489579718
~~~
选项`--date`指定了作为输入的日期。我们可以使用任意的日期格式化选项来打印输出。

date命令可以根据指定的日期找出这一天是星期几：
~~~
$ date --date "Jan 20 2001" +%A 
Saturday
~~~
1.10.3节中的表1-1是一份日期格式字符串列表。

(3) 用带有前缀+的格式化字符串作为date命令的参数，可以按照你的选择打印出相应格式的日期。例如：
~~~
$ date "+%d %B %Y" 
20 May 2010
~~~
(4) 设置日期和时间：
~~~
# date -s "格式化的日期字符串"
~~~
例如：
~~~
# date -s "21 June 2009 11:01:22"
~~~

> 如果系统已经联网，可以使用ntpdate来设置日期和时间：
> /usr/sbin/ntpdate -s time-b.nist.gov

(5) 要优化代码，首先得先进行测量。date命令可以用于计算一组命令所花费的执行时间：
~~~shell script
#!/bin/bash 
#文件名: time_take.sh 
start=$(date +%s) 
commands; 
statements; 
end=$(date +%s) 
difference=$(( end - start)) 
echo Time taken to execute commands is $difference seconds.
~~~

> date命令的最小精度是秒。对命令计时的另一种更好的方式是使用time命令：
> time commandOrScriptName.

### 1.10.3 工作原理

Unix纪元时被定义为从世界标准时间（Coordinated Universal Time，UTC）① 1970年1月1日0 时0分0秒起至当前时刻的总秒数，不包括闰秒②。当计算两个日期或两段时间的差值时，需要用到纪元时。将两个日期转换成纪元时并计算出两者之间的差值。下面的命令计算了两个日期之间相隔了多少秒：
~~~shell script
secs1=`date -d "Jan 2 1970" 
secs2=`date -d "Jan 3 1970" 
echo "There are `expr $secs2 - $secs1` seconds between Jan 2 and Jan 3" 
There are 86400 seconds between Jan 2 and Jan 3
~~~

> ① UTC（Coordinated Universal Time），又称世界标准时间或世界协调时间。UTC是以原子时秒长为基础，在时刻上尽量接近于世界时的一种时间计量系统。
> ② 闰秒是指为保持协调世界时接近于世界时时刻，由国际计量局统一规定在年底或年中（也可能是季末）对协调世界时增加或减少1秒的调整。

对用户而言，以秒为单位显示从1970年1月1日午夜截止到当前的秒数，实在是不太容易读懂。date命令支持以用户易读的格式输出日期。

表1-1列出了date命令所支持的格式选项。

|日期内容 |格式|
|------|------|
|工作日（weekday）|%a（例如：Sat）<br/>%A（例如：Saturday）|
|月 |%b（例如：Nov）<br/>%B（例如：November）|
|日 |%d（例如：31）|
|特定格式日期（mm/dd/yy） |%D（例如：10/18/10）|
|年 |%y（例如：10）<br/>%Y（例如：2010）|
|小时 |%I或%H（例如：08）|
|分钟 |%M（例如：33）|
|秒 |%S（例如：10）|
|纳秒 |%N（例如：695208515）|
|Unix纪元时（以秒为单位） |%s（例如：1290049486）|

### 1.10.4 补充内容

编写以循环方式运行的监控脚本时，设置时间间隔是必不可少的。让我们来看看如何生成延时。

在脚本中生成延时

sleep命令可以延迟脚本执行一段时间（以秒为单位）。下面的脚本使用tput和sleep从0开始计时到40秒：
~~~shell script
#!/bin/bash 
#文件名: sleep.sh 
echo Count: 
tput sc 
# 循环40秒
for count in `seq 0 40` 
do 
 tput rc 
 tput ed 
 echo -n $count 
 sleep 1 
done 
~~~
在上面的例子中，变量依次使用了由seq命令生成的一系列数字。我们用tput sc存储光标位置。在每次循环中，通过tput rc恢复之前存储的光标位置，在终端中打印出新的count值，然后使用tputs ed清除从当前光标位置到行尾之间的所有内容。行被清空之后，脚本就可以显示出新的值。sleep可以使脚本在每次循环迭代之间延迟1秒钟。

## 1.11 调试脚本

调试脚本所花费的时间常常比编写代码还要多。所有编程语言都应该实现的一个特性就是在出现始料未及的情况时，能够生成跟踪信息。调试信息可以帮你弄清楚是什么原因使得程序行为异常。每位系统程序员都应该了解Bash提供的调试选项。这则攻略为你展示了这些选项的用法。

### 1.11.1 实战演练

我们可以利用Bash内建的调试工具或者按照易于调试的方式编写脚本，方法如下所示。

(1) 使用选项-x，启用shell脚本的跟踪调试功能：
~~~
$ bash -x script.sh
~~~
运行带有-x选项的脚本可以打印出所执行的每一行命令以及当前状态。

> 你也可以使用sh -x script。

(2) 使用set -x和set +x对脚本进行部分调试。例如：
~~~shell script
#!/bin/bash 
#文件名: debug.sh 
for i in {1..6}; 
do 
 set -x 
 echo $i 
 set +x 
done 
echo "Script executed"
~~~
在上面的脚本中，只会打印出echo $i的调试信息，因为使用-x和+x对调试区域进行了限制。

该脚本并没有使用上例中的seq命令，而是用{start..end}来迭代从start到end之间的值。这个语言构件（construct）在执行速度上要比seq命令略快。

(3) 前面介绍的调试方法是Bash内建的。它们以固定的格式生成调试信息。但是在很多情况下，我们需要使用自定义的调试信息。可以通过定义 _DEBUG环境变量来启用或禁止调试及生成特定形式的信息。

请看下面的代码：
~~~shell script
#!/bin/bash 
function DEBUG() 
{ 
 [ "$_DEBUG" == "on" ] && $@ || : 
} 
for i in {1..10} 
do 
 DEBUG echo "I is $i" 
done 
~~~
可以将调试功能设置为on来运行上面的脚本：
~~~
$ _DEBUG=on ./script.sh
~~~
我们在每一条需要打印调试信息的语句前加上DEBUG。如果没有把 `_DEBUG=on`传递给脚本，那么调试信息就不会打印出来。在Bash中，命令:告诉shell不要进行任何操作。

### 1.11.2 工作原理

-x选项会输出脚本中执行过的每一行。不过，我们可能只关注其中某一部分代码。针对这种情况，可以在脚本中使用set builtin来启用或禁止调试打印。

 set -x：在执行时显示参数和命令。

 set +x：禁止调试。

 set -v：当命令进行读取时显示输入。

 set +v：禁止打印输入。

### 1.11.3 补充内容

还有其他脚本调试的便捷方法，我们甚至可以巧妙地利用shebang来进行调试。

shebang的妙用

把shebang从#!/bin/bash改成 #!/bin/bash -xv，这样一来，不用任何其他选项就可以启用调试功能了。

如果每一行前面都加上+，那么就很难在默认输出中跟踪执行流程了。可以将环境变量PS4设置为'`$LINENO:`'，显示出每行的行号：
~~~
PS4='$LINENO: '
~~~
调试的输出信息可能会很长。如果使用了-x或set -x，调试输出会被发送到stderr。可以使用下面的命令将其重定向到文件中：
~~~
sh -x testScript.sh 2> debugout.txt
~~~
Bash 4.0以及后续版本支持对调试输出使用自定义文件描述符：
~~~
exec 6> /tmp/debugout.txt 
BASH_XTRACEFD=6
~~~

## 1.12 函数和参数

函数和别名乍一看很相似，不过两者在行为上还是略有不同。最大的差异在于函数参数可以在函数体中任意位置上使用，而别名只能将参数放在命令尾部。

### 1.12.1 实战演练

函数的定义包括function命令、函数名、开/闭括号以及包含在一对花括号中的函数体。 

(1) 函数可以这样定义：
~~~shell script 
function fname() 
{ 
 statements; 
} 
~~~
或者
~~~
fname() 
{ 
 statements; 
} 
~~~
甚至是这样（对于简单的函数）：
~~~
fname() { statement; }
~~~
(2) 只需使用函数名就可以调用函数：
~~~
$ fname ; #执行函数
~~~
(3) 函数参数可以按位置访问，$1是第一个参数，$2是第二个参数，以此类推：
~~~
fname arg1 arg2 ; #传递参数
~~~
以下是函数fname的定义。在函数fname中，包含了各种访问函数参数的方法。
~~~shell script
fname() 
{ 
 echo $1, $2; #访问参数1和参数2 
 echo "$@"; #以列表的方式一次性打印所有参数
 echo "$*"; #类似于$@，但是所有参数被视为单个实体
 return 0; #返回值
} 
~~~
传入脚本的参数可以通过下列形式访问。

 $0是脚本名称。

 $1是第一个参数。

 $2是第二个参数。

 $n是第n个参数。

 "$@"被扩展成"$1" "$2" "$3"等。

 "$*"被扩展成"$1c$2c$3"，其中c是IFS的第一个字符。

 "$@"要比"$*"用得多。由于"$*"将所有的参数当作单个字符串，因此它很少被使用。

比较别名与函数

 下面的这个别名通过将ls的输出传入grep来显示文件子集。别名的参数添加到命令的尾部，因此`lsg txt`就被扩展成了`ls | grep txt`：
~~~
$> alias lsg='ls | grep' 
$> lsg txt 
 file1.txt 
 file2.txt 
 file3.txt
~~~
 如果想获得/sbin/ifconfig文件中设备对应的IP地址，可以尝试这样做：
~~~
$> alias wontWork='/sbin/ifconfig | grep' 
$> wontWork eth0 
eth0 Link encap:Ethernet HWaddr 00:11::22::33::44:55
~~~
 grep命令找到的是字符串eth0，而不是IP地址。如果我们使用函数来实现的话，可以将设备名作为参数传入ifconfig，不再交给grep：
~~~
$> function getIP() { /sbin/ifconfig $1 | grep 'inet '; } 
$> getIP eth0 
inet addr:192.168.1.2 Bcast:192.168.255.255 Mask:255.255.0.0
~~~

### 1.12.2 补充内容

让我们再研究一些Bash函数的技巧。

1. 递归函数

在Bash中，函数同样支持递归调用（可以调用自身的函数）。例如，`F() { echo $1; F hello; sleep 1; }`。

> Fork炸弹：
> 递归函数是能够调用自身的函数。这种函数必须有退出条件，否则就会不断地生成自身，直到系统耗尽所有的资源或是崩溃。
> :(){ :|:& };:
> 这个函数会一直地生成新的进程，最终形成拒绝服务攻击。
> 函数调用前的&将子进程放入后台。这段危险的代码能够不停地衍生出进程，因而被称为Fork炸弹。
> 上面这段代码要理解起来可不容易。请参阅维基百科http://en.wikipedia.org/wiki/Fork_bomb，那里给出了有关Fork炸弹的更多细节以及解释。
> 可以通过修改配置文件/etc/security/limits.conf中的nproc来限制可生成的最大进程数，进而阻止这种攻击。
> 下面的语句将所有用户可生成的进程数限制为100：
> hard nproc 100

2. 导出函数

函数也能像环境变量一样用export导出，如此一来，函数的作用域就可以扩展到子进程中：
~~~
export -f fname 
$> function getIP() { /sbin/ifconfig $1 | grep 'inet '; } 
$> echo "getIP eth0" >test.sh 
$> sh test.sh 
 sh: getIP: No such file or directory 
$> export -f getIP 
$> sh test.sh 
 inet addr: 192.168.1.2 Bcast: 192.168.255.255 Mask:255.255.0.0
~~~
3. 读取命令返回值（状态）

命令的返回值被保存在变量$?中。
~~~shell script
cmd; 
echo $?;
~~~
返回值被称为退出状态。它可用于确定命令执行成功与否。如果命令成功退出，那么退出状态为0，否则为非0。

下面的脚本可以报告命令是否成功结束：
~~~shell script
#!/bin/bash 
#文件名: success_test.sh 
#对命令行参数求值，比如success_test.sh ‘ls | grep txt’ 
eval $@ 
if [ $? -eq 0 ]; 
then 
 echo "$CMD executed successfully" 
else 
 echo "$CMD terminated unsuccessfully" 
fi 
~~~
4. 向命令传递参数

大多数应用都能够接受不同格式的参数。假设-p、-v是可用选项，-k N是另一个可以接受数字的选项，同时该命令还要求使用一个文件名作为参数。那么，它有如下几种执行方式：

 $ command -p -v -k 1 file

 $ command -pv -k 1 file

 $ command -vpk 1 file

 $ command file -pvk 1

在脚本中，命令行参数可以依据其在命令行中的位置来访问。第一个参数是$1，第二个参数是$2，以此类推。

下面的语句可以显示出前3个命令行参数：
~~~shell script
echo $1 $2 $3 
~~~
更为常见的处理方式是迭代所有的命令行参数。shift命令可以将参数依次向左移动一个位置，让脚本能够使用$1来访问到每一个参数。下面的代码显示出了所有的命令行参数：
~~~
$ cat showArgs.sh 
for i in `seq 1 $#` 
do 
echo $i is $1 
shift 
done 
$ sh showArgs.sh a b c 
1 is a 
2 is b 
3 is c
~~~

## 1.13 将一个命令的输出发送给另一个命令

Unix shell脚本最棒的特性之一就是可以轻松地将多个命令组合起来生成输出。一个命令的输出可以作为另一个命令的输入，而这个命令的输出又会传递至下一个命令，以此类推。这种命令组合的输出可以被存储在变量中。这则攻略将演示如何组合多个命令并读取其输出。

### 1.13.1 预备知识

命令输入通常来自于stdin或参数。输出可以发送给stdout或stderr。当我们组合多个命令时，通常将stdin用于输入，stdout用于输出。

在这种情况下，这些命令被称为过滤器（filter）。我们使用管道（pipe）连接每个过滤器，管道操作符是|。例如：
~~~
$ cmd1 | cmd2 | cmd3
~~~
这里我们组合了3个命令。cmd1的输出传递给cmd2，cmd2的输出传递给cmd3，最终的输出（来自cmd3）会出现在显示器中或被导入某个文件。

### 1.13.2 实战演练

我们通常使用管道并配合子shell的方式来组合多个命令的输出。

(1) 先从组合两个命令开始：
~~~
$ ls | cat -n > out.txt
~~~
ls（列出当前目录内容）的输出被传给cat -n，后者为通过stdin所接收到的输入内容加上行号，然后将输出重定向到文件out.txt。

(2) 将命令序列的输出赋给变量：
~~~
cmd_output=$(COMMANDS)
~~~
这种方法叫作子shell法。例如：
~~~shell script
cmd_output=$(ls | cat -n) 
echo $cmd_output
~~~
另一种方法叫作反引用（有些人也称它为反标记），也可以用于存储命令输出：
~~~
cmd_output=`COMMANDS`
~~~
例如：
~~~shell script
cmd_output=`ls | cat -n` 
echo $cmd_output
~~~
反引用与单引号可不是一回事，该字符位于键盘的 ~ 键上。

### 1.13.3 补充内容

命令分组的方法不止一种。

1. 利用子shell生成一个独立的进程

子shell本身就是独立的进程。可以使用()操作符来定义一个子shell。

 pwd命令可以打印出工作目录的路径。

 cd命令可以将当前目录修改成指定的目录。
~~~
$> pwd 
/ 
$> (cd /bin; ls) 
awk bash cat... 
$> pwd 
/
~~~
当命令在子shell中执行时，不会对当前shell造成任何影响；所有的改变仅限于该子shell内。例如，当用cd命令改变子shell的当前目录时，这种变化不会反映到主shell环境中。

2. 通过引用子shell的方式保留空格和换行符

假设我们使用子shell或反引用的方法将命令的输出保存到变量中，为了保留输出的空格和换行符（\n），必须使用双引号。例如：
~~~
$ cat text.txt 
1 
2 
3 
$ out=$(cat text.txt) 
$ echo $out 
1 2 3 # 丢失了1、2、3中的\n 
$ out="$(cat text.txt)" 
$ echo $out 
1 
2 
3
~~~

## 1.14 在不按下回车键的情况下读入n个字符

Bash命令read能够从键盘或标准输入中读取文本。我们可以使用read以交互的形式读取用户输入，不过read能做的可远不止这些。编程语言的大多数输入库都是从键盘读取输入，当回车键按下的时候，标志着输入完毕。但有时候是没法按回车键的，输入结束与否是由读取到的字符数或某个特定字符来决定的。例如在交互式游戏中，当按下 + 键时，小球就会向上移动。那么若每次都要按下 + 键，然后再按回车键来确认已经按过 + 键，这就显然太低效了。

read命令提供了一种不需要按回车键就能够搞定这个任务的方法。

### 实战演练

你可以借助read命令的各种选项来实现不同的效果，如下所示。

(1) 下面的语句从输入中读取n个字符并存入变量variable_name：
~~~shell script
read -n number_of_chars variable_name
~~~
例如：
~~~
$ read -n 2 var 
$ echo $var
~~~
(2) 用无回显的方式读取密码：
~~~shell script
read -s var 
~~~
(3) 使用read显示提示信息：
~~~shell script
read -p "Enter input:" var
~~~
(4) 在给定时限内读取输入：
~~~shell script
read -t timeout var
~~~
例如：
~~~
$ read -t 2 var 
#在2秒内将键入的字符串读入变量var
~~~
(5) 用特定的定界符作为输入行的结束：
~~~shell script
read -d delim_char var
~~~
例如：
~~~
$ read -d ":" var 
hello: #var被设置为hello
~~~

## 1.15 持续运行命令直至执行成功

有时候命令只有在满足某些条件时才能够成功执行。例如，在下载文件之前必须先创建该文件。这种情况下，你可能希望重复执行命令，直到成功为止。

### 1.15.1 实战演练

定义如下函数：
~~~shell script
repeat() 
{ 
 while true 
 do 
 $@ && return 
 done 
} 
~~~
或者把它放入shell的rc文件，更便于使用：
~~~shell script
repeat() { while true; do $@ && return; done }
~~~

### 1.15.2 工作原理

函数repeat()中包含了一个无限while循环，该循环执行以函数参数形式（通过$@访问）传入的命令。如果命令执行成功，则返回，进而退出循环。

### 1.15.3 补充内容

我们已经知道了用于重复执行命令，直到其执行成功的基本做法。接着来看看更高效的方式。

1. 一种更快的做法

在大多数现代系统中，true是作为/bin中的一个二进制文件来实现的。这就意味着每执行一次之前提到的while循环，shell就不得不生成一个进程。为了避免这种情况，可以使用shell的内建命令:，该命令的退出状态总是为0：
~~~shell script
repeat() { while :; do $@ && return; done }
~~~
尽管可读性不高，但是肯定比第一种方法快。

2. 加入延时

假设你要用repeat()从Internet上下载一个暂时不可用的文件，不过这个文件只需要等一会就能下载。一种方法如下：
~~~shell script
repeat wget -c http://www.example.com/software-0.1.tar.gz
~~~
如果采用这种形式，会产生很多发往www.example.com的流量，有可能会对服务器造成影响。（可能也会牵连到你自己；如果服务器认为你是在向其发起攻击，就会把你的IP地址列入黑名单。）要解决这个问题，我们可以修改函数，加入一段延时：
~~~shell script
repeat() { while :; do $@ && return; sleep 30; done }
~~~
这样命令每30秒才会运行一次。

## 1.16 字段分隔符与迭代器

内部字段分隔符（Internal Field Separator，IFS）是shell脚本编程中的一个重要概念。在处理文本数据时，它的作用可不小。

作为分隔符，IFS有其特殊用途。它是一个环境变量，其中保存了用于分隔的字符。它是当前shell环境使用的默认定界字符串。

考虑一种情形：我们需要迭代一个字符串或逗号分隔型数值（Comma Separated Value，CSV）中的单词。如果是前者，可以使用IFS=" "；如果是后者，则使用IFS=","。

### 1.16.1 预备知识

考虑CSV数据的情况：
~~~csv
data="name, gender,rollno,location"
~~~
我们可以使用IFS读取变量中的每一个条目。
~~~shell script
oldIFS=$IFS 
IFS=, #IFS现在被设置为, 
for item in $data; 
do 
 echo Item: $item 
done 
IFS=$oldIFS
~~~
输出如下：
~~~
Item: name 
Item: gender 
Item: rollno 
Item: location
~~~
IFS的默认值为空白字符（换行符、制表符或者空格）。

当IFS被设置为逗号时，shell将逗号视为一个定界符，因此变量$item在每次迭代中读取由逗号分隔的子串作为变量值。

如果没有把IFS设置成逗号，那么上面的脚本会将全部数据作为单个字符串打印出来。

### 1.16.2 实战演练

让我们以/etc/passwd为例，看看IFS的另一种用法。在文件/etc/passwd中，每一行包含了由冒号分隔的多个条目。该文件中的每行都对应着某个用户的相关属性。

考虑这样的输入：root:x:0:0:root:/root:/bin/bash。每行的最后一项指定了用户的默认shell。

可以按照下面的方法巧妙地利用IFS打印出用户以及他们默认的shell：
~~~shell script
#!/bin/bash 
#用途: 演示IFS的用法
line="root:x:0:0:root:/root:/bin/bash" 
oldIFS=$IFS; 
IFS=":" 
count=0 
for item in $line; 
do
  [ $count -eq 0 ] && user=$item; 
  [ $count -eq 6 ] && shell=$item; 
  let count++ 
done; 
IFS=$oldIFS 
echo $user's shell is $shell;
~~~
输出为：
~~~
root's shell is /bin/bash
~~~
循环在对一系列值进行迭代时非常有用。Bash提供了多种类型的循环。

 面向列表的for循环
~~~shell script
for var in list; 
do 
 commands; #使用变量$var 
done 
~~~
list可以是一个字符串，也可以是一个值序列。

我们可以使用echo命令生成各种值序列：
~~~shell script
echo {1..50}; #生成一个从1~50的数字序列
echo {a..z} {A..Z}; #生成大小写字母序列
~~~
同样，我们可以将这些方法结合起来对数据进行拼接（concatenate）。

下面的代码中，变量i在每次迭代的过程里都会保存一个范围在a到z之间的字符：
~~~shell script
for i in {a..z}; do actions; done;
~~~
 迭代指定范围的数字
~~~shell script
for((i=0;i<10;i++)) 
{ 
 commands; #使用变量$i 
} 
~~~
 循环到条件满足为止

当条件为真时，while循环继续执行；当条件不为真时，until循环继续执行。
~~~shell script
while condition 
do 
 commands; 
done 
~~~
用true作为循环条件能够产生无限循环。

 until循环

在Bash中还可以使用一个特殊的循环until。它会一直循环，直到给定的条件为真。例如：
~~~shell script
x=0; 
until [ $x -eq 9 ]; #条件是[$x -eq 9 ] 
do 
 let x++; echo $x; 
done
~~~

## 1.17 比较与测试

程序中的流程控制是由比较语句和测试语句处理的。Bash能够执行各种测试。我们可以用if、if else以及逻辑运算符来测试，用比较运算符来比较数据项。除此之外，还有一个test命令也可以用于测试。

### 实战演练

来看看用于比较和测试的各种方法：

 if条件
~~~shell script
if condition; 
then 
 commands; 
fi 
~~~
 else if和else
~~~shell script
if condition; 
then 
 commands; 
else if condition; then 
 commands; 
else 
 commands; 
fi
~~~

> if和else语句能够嵌套使用。if的条件判断部分可能会变得很长，但可以用逻辑运算符将它变得简洁一些：
>  `[ condition ] && action;` # 如果condition为真，则执行action
>  `[ condition ] || action;` # 如果condition为假，则执行action
> &&是逻辑与运算符，||是逻辑或运算符。编写Bash脚本时，这是一个很有用的技巧。

现在来了解一下条件和比较操作。

 算术比较

比较条件通常被放置在封闭的中括号内。一定要注意在`[`或`]`与操作数之间有一个空格。

如果忘记了这个空格，脚本就会报错。
~~~
[$var -eq 0 ] or [ $var -eq 0]
~~~
对变量或值进行算术条件测试：
~~~
[ $var -eq 0 ] #当$var等于0时，返回真
[ $var -ne 0 ] #当$var不为0时，返回真
~~~
其他重要的操作符如下。

● -gt：大于。

● -lt：小于。

● -ge：大于或等于。

● -le：小于或等于。

-a是逻辑与操作符，-o是逻辑或操作符。可以按照下面的方法结合多个条件进行测试：
~~~
[ $var1 -ne 0 -a $var2 -gt 2 ] #使用逻辑与-a 
[ $var1 -ne 0 -o $var2 -gt 2 ] #逻辑或-o
~~~

 文件系统相关测试

我们可以使用不同的条件标志测试各种文件系统相关的属性。

● `[ -f $file_var ]`：如果给定的变量包含正常的文件路径或文件名，则返回真。

● `[ -x $var ]`：如果给定的变量包含的文件可执行，则返回真。

● `[ -d $var ]`：如果给定的变量包含的是目录，则返回真。

● `[ -e $var ]`：如果给定的变量包含的文件存在，则返回真。

● `[ -c $var ]`：如果给定的变量包含的是一个字符设备文件的路径，则返回真。

● `[ -b $var ]`：如果给定的变量包含的是一个块设备文件的路径，则返回真。

● `[ -w $var ]`：如果给定的变量包含的文件可写，则返回真。

● `[ -r $var ]`：如果给定的变量包含的文件可读，则返回真。

● `[ -L $var ]`：如果给定的变量包含的是一个符号链接，则返回真。

考虑下面的例子：
~~~shell script
fpath="/etc/passwd" 
if [ -e $fpath ]; then 
 echo File exists; 
else 
 echo Does not exist; 
fi
~~~

 字符串比较

进行字符串比较时，最好用双中括号，因为有时候采用单个中括号会产生错误。

> 注意，双中括号是Bash的一个扩展特性。如果出于性能考虑，使用ash或dash来运行脚本，那么将无法使用该特性。

测试两个字符串是否相同。

● `[[ $str1 = $str2 ]]`：当str1等于str2时，返回真。也就是说，str1和str2包含的文本是一模一样的。

● `[[ $str1 == $str2 ]]`：这是检查字符串是否相同的另一种写法。

测试两个字符串是否不同。

● `[[ $str1 != $str2 ]]`：如果str1和str2不相同，则返回真。

找出在字母表中靠后的字符串。

字符串是依据字符的ASCII值进行比较的。例如，A的值是0x41，a的值是0x61。因此，A小于a，AAa小于Aaa。 

● `[[ $str1 > $str2 ]]`：如果str1的字母序比str2大，则返回真。

● `[[ $str1 < $str2 ]]`：如果str1的字母序比str2小，则返回真。

> 注意在=前后各有一个空格。如果忘记加空格，那就不是比较关系了，而是变成了赋值语句。

测试空串。

● `[[ -z $str1 ]]`：如果str1为空串，则返回真。

● `[[ -n $str1 ]]`：如果str1不为空串，则返回真。

使用逻辑运算符 && 和 || 能够很容易地将多个条件组合起来：
~~~shell script
if [[ -n $str1 ]] && [[ -z $str2 ]] ; 
 then 
 commands; 
 fi 
~~~
例如：
~~~shell script
str1="Not empty " 
str2="" 
if [[ -n $str1 ]] && [[ -z $str2 ]]; 
then 
 echo str1 is nonempty and str2 is empty string. 
fi
~~~

输出如下：
~~~
str1 is nonempty and str2 is empty string.
~~~
test命令可以用来测试条件。用test可以避免使用过多的括号，增强代码的可读性。之前讲过的`[]`中的测试条件同样可以用于test命令。例如：
~~~shell script
if [ $var -eq 0 ]; then echo "True"; fi
~~~
也可以写成：
~~~shell script
if test $var -eq 0 ; then echo "True"; fi
~~~
> 注意，test是一个外部程序，需要衍生出对应的进程，而 [ 是Bash的一个内部函数，因此后者的执行效率更高。test兼容于Bourne shell、ash、dash等。

## 1.18 使用配置文件定制bash

你在命令行中输入的绝大部分命令都可以放置在一个特殊的文件中，留待登录或启动新的bash会话时执行。将函数定义、别名以及环境变量设置放置在这种特殊文件中，是一种定制shell的常用方法。

放入配置文件中的常见命令如下：
~~~shell script
# 定义ls命令使用的颜色
LS_COLORS='no=00:di=01;46:ln=00;36:pi=40;33:so=00;35:bd=40;33;01' 
export LS_COLORS 
# 主提示符
PS1='Hello $USER'; export PS1 
# 正常路径之外的个人应用程序安装目录
PATH=$PATH:/opt/MySpecialApplication/bin; export PATH 
# 常用命令的便捷方式
function lc () {/bin/ls -C $* ; }
~~~
应该使用哪些定制文件？

Linux和Unix中能够放置定制脚本的文件不止一个。这些配置文件分为3类：登录时执行的、启动交互式shell时执行的以及调用shell处理脚本文件时执行的。

### 实战演练

当用户登录shell时，会执行下列文件：
/etc/profile, $HOME/.profile, $HOME/.bash_login, $HOME/.bash_profile /

> 注意，如果你是通过图形化登录管理器登入的话，是不会执行/etc/profile、$HOME/.profile和$HOME/.bash_profile这3个文件的。这是因为图形化窗口管理器并不会启动shell。当你打开终端窗口时才会创建shell，但这个shell也不是登录shell。

如果.bash_profile或.bash_login文件存在，则不会去读取.profile文件。

交互式shell（如X11终端会话）或ssh执行单条命令（如ssh 192.168.1.1 ls /tmp）时，会读取并执行以下文件：
/etc/bash.bashrc $HOME/.bashrc 

如果运行如下脚本：
~~~
$> cat myscript.sh 
#!/bin/bash 
echo "Running"
~~~
不会执行任何配置文件，除非定义了环境变量BASH_ENV：
~~~
$> export BASH_ENV=~/.bashrc 
$> ./myscript.sh
~~~
使用ssh运行下列命令时：
~~~
ssh 192.168.1.100 ls /tmp
~~~
会启动一个bash shell，读取并执行/etc/bash.bashrc和$HOME/.bashrc，但不包括/etc/profile或.profile。

如果调用ssh登录会话：
~~~
ssh 192.168.1.100
~~~
这会创建一个新的登录bash shell，该shell会读取并执行以下文件：
/etc/profile 
/etc/bash.bashrc 
$HOME/.profile or .bashrc_profile 

> 危险：像传统的Bourne shell、ash、dash以及ksh这类shell，也会读取配置文件。但是这些shell并不支持线性数组（列表）和关联数组。因此要避免在/etc/profile或$HOME/.profile中使用这类不支持的特性。

可以使用这些文件定义所有用户所需要的非导出项（如别名）。例如：
~~~
alias l "ls -l" 
/etc/bash.bashrc /etc/bashrc
~~~
也可以用来保存个人配置，比如设置需要由其他bash实例继承的路径信息，就像下面这样：
~~~
CLASSPATH=$CLASSPATH:$HOME/MyJavaProject; export CLASSPATH 
$HOME/.bash_login $HOME/.bash_profile $HOME/.profile
~~~
> 如果.bash_login或.bash_profile存在，则不会读取.profile。不过其他shell可能会读取该文件。

另外还可以保存一些需要在新shell创建时定义的个人信息。如果你希望在X11终端会话中能够使用别名和函数的话，可以将其定义在$HOME/.bashrc和/etc/bash.bashrc中。

> 导出变量和函数会传递到子shell中，但是别名不会。你必须将BASH_ENV的值设置为.bashrc或.profile，然后在其中定义别名，这样就可以在shell脚本中使用这些别名了。

当用户登出会话时，会执行下列文件：
$HOME/.bash_logout 

例如，远程登录的用户需要在登出的时候清屏：
~~~
$> cat ~/.bash_logout 
# 远程登出之后清屏
Clear
~~~

# 第2章 命令之乐

## 2.1 简介

类Unix系统享有最棒的命令行工具。这些命令的功能并不复杂，都能够简化我们的工作。简单的功能可以通过相互结合来解决复杂的问题。简单命令的组合是一门艺术，实践得越多，收益就越大。本章将为你介绍一些最值得关注同时也最实用的命令，其中包括grep、awk、sed和find。

## 2.2 用 cat 进行拼接

cat命令能够显示或拼接文件内容，不过它的能力远不止如此。比如说，cat能够将标准输入数据与文件数据组合在一起。通常的做法是将stdin重定向到一个文件，然后再合并两个文件。而cat命令一次就能搞定这些操作。接下来你会看到该命令的基本用法和高级用法。

### 2.2.1 实战演练

cat命令是一个经常会用到的简单命令，它本身表示conCATenate（拼接）。

用cat读取文件内容的一般语法是：
~~~
$ cat file1 file2 file3 ...
~~~
该命令将作为命令行参数的文件内容拼接在一起并将结果发送到stdout。 

 打印单个文件的内容
~~~
$ cat file.txt 
This is a line inside file.txt 
This is the second line inside file.txt
~~~
 打印多个文件的内容
~~~
$ cat one.txt two.txt 
This line is from one.txt 
This line is from two.txt
~~~
cat命令不仅可以读取文件、拼接数据，还能够从标准输入中读取。

管道操作符可以将数据作为cat命令的标准输入：
~~~shell script
OUTPUT_FROM_SOME COMMANDS | cat
~~~
cat也可以将文件内容与终端输入拼接在一起。

下面的命令将stdin和另一个文件中的数据组合在一起：
~~~
$ echo 'Text through stdin' | cat - file.txt
~~~
在上例中，-被作为stdin文本的文件名。

### 2.2.2 补充内容

cat命令还有一些用于文件查看的选项。可以在终端会话中输入man cat来查看完整的选项列表。

1. 去掉多余的空白行

有时候文本文件中可能包含多处连续的空白行。如果你想删除这些额外的空白行，可以这样做：
~~~
$ cat -s file
~~~
考虑下面的例子:
~~~
$ cat multi_blanks.txt 
line 1
line2 



line3
 
line4 
$ cat -s multi_blanks.txt #压缩相邻的空白行
line 1 
line 2 
line 3
 
line 4
~~~
另外也可以用tr删除所有的空白行，我们会在2.6节详细讨论。

2. 将制表符显示为^I

单从视觉上很难将制表符同连续的空格区分开。对于Python而言，制表符和空格是区别对待的。在文本编辑器中，两者看起来差不多，但是解释器将其视为不同的缩进。仅仅在文本编辑器中进行观察是很难发现这种错误的。cat有一个特性，可以将制表符识别出来。这有助于排查缩进错误。

用cat命令的`-T`选项能够将制表符标记成^I。例如：
~~~
$ cat file.py 
def function(): 
 var = 5 
 next = 6 
 third = 7 
$ cat -T file.py 
def function(): 
^Ivar = 5 
^I^Inext = 6 
^Ithird = 7^I
~~~
3. 行号

cat命令的-n选项会在输出的每一行内容之前加上行号。例如：
~~~
$ cat lines.txt 
line 
line 
line 
$ cat -n lines.txt 
 1 line 
 2 line 
 3 line
~~~
> 别担心，cat命令绝不会修改你的文件，它只是根据用户提供的选项在stdout中生成一个修改过的输出而已。可别尝试用重定向来覆盖输入文件。shell在打开输入文件之前会先创建新的输出文件。cat命令不允许使用相同的文件作为输入和重定向后的输出。利用管道并重定向输出会清空输入文件。
> $> echo "This will vanish" > myfile
> $> cat -n myfile >myfile 
> cat: myfile: input file is output file 
> $> cat myfile | cat -n >myfile 
> $> ls -l myfile 
> -rw-rw-rw-. 1 user user 0 Aug 24 00:14 myfile ; # myfile为空文件

> 选项-n会为包括空行在内的所有行生成行号。如果你想跳过空白行，可以使用选项-b。

## 2.3 录制并回放终端会话

将屏幕会话录制成视频肯定有用，不过对于调试终端会话或是提供shell教程来说，视频有些“杀鸡用牛刀”了。

shell给出了另一种选择。script命令能够录制你的击键以及击键时机，并将输入和输出结果保存在对应的文件中。scriptreplay 命令可以回放会话。

### 2.3.1 预备知识

script和scriptreplay命令在绝大多数GNU/Linux发行版上都可以找到。你可以通过录制终端会话来制作命令行技巧视频教程，也可以与他人分享会话记录文件，研究如何使用命令行完成某项任务。你甚至可以调用其他解释器并录制发送给该解释器的击键。但你无法记录vi、emacs或其他将字符映射到屏幕特定位置的应用程序。

### 2.3.2 实战演练

开始录制终端会话：
~~~
$ script -t 2> timing.log -a output.session
~~~
完整的录制过程如下：
~~~
$ script -t 2> timing.log -a output.session 
# 演示tclsh 
$ tclsh 
% puts [expr 2 + 2]
4 
% exit 
$ exit
~~~

> 注意，该攻略不适用于不支持单独将stderr重定向到文件的shell，比如csh shell。

可以指定一个文件名作为script命令的参数。该文件将保存击键及命令结果。如果指定了-t选项，script命令会把时序数据发送到stdout。可以将这些数据重定向到其他文件中（timing.log），这样该文件中就记录了每次击键的时机以及输出信息。上面的例子中使用2>将stderr重定向到了文件timing.log。

利用文件timing.log和output.session，可以按照下面的方法回放命令执行过程：
~~~
$ scriptreplay timing.log output.session 
# 播放命令序列及输出
~~~

### 2.3.3 工作原理

我们通常会录制桌面环境视频来作为教程使用。但是视频需要大量的存储空间，而终端脚本文件仅仅是一个文本文件，其文件大小不过是KB级别。

你可以把timing.log和output.session文件分享给任何想在自己的终端上回放这段终端会话的人。

## 2.4 查找并列出文件

find是Unix/Linux命令行工具箱中最棒的工具之一。该命令在命令行和shell脚本编写方面都能发挥功效。同cat和ls一样，find也包含大量特性，多数用户都没有发挥出它的最大威力。这则攻略讨论了find的一些常用的查找功能。

### 2.4.1 预备知识

find命令的工作方式如下：沿着文件层次结构向下遍历，匹配符合条件的文件，执行相应的操作。默认的操作是打印出文件和目录，这也可以使用-print选项来指定。

### 2.4.2 实战演练

要列出给定目录下所有的文件和子目录，可以采用下面的语法：
~~~
$ find base_path
~~~
bash_path可以是任意位置（例如/home/slynux），find会从该位置开始向下查找。例如：
~~~
$ find . -print 
.history 
Downloads 
Downloads/tcl.fossil 
Downloads/chapter2.doc
…
~~~
. 指定当前目录，.. 指定父目录。这是Unix文件系统中的约定用法。

print选项使用\n（换行符）分隔输出的每个文件或目录名。而-print0选项则使用空字符'\0'来分隔。-print0的主要用法是将包含换行符或空白字符的文件名传给xargs命令。随后会详细讨论xargs命令：
~~~
$> echo "test" > "file name" 
$> find . -type f -print | xargs ls -l 
ls: cannot access ./file: No such file or directory 
ls: cannot access name: No such file or directory 
$> find . -type f -print0 | xargs -0 ls -l 
-rw-rw-rw-. 1 user group 5 Aug 24 15:00 ./file name
~~~

### 2.4.3 补充内容

上面的例子演示了如何使用find列出文件层次中所有的文件和目录。find命令能够基于通配符或正则表达式、目录树深度、文件日期、文件类型等条件查找文件。

1. 根据文件名或正则表达式进行搜索

-name选项指定了待查找文件名的模式。这个模式可以是通配符，也可以是正则表达式。在下面的例子中，'*.txt'能够匹配所有名字以.txt结尾的文件或目录。

> 注意*.txt两边的单引号。shell会扩展没有引号或是出现在双引号（"）中的通配符。单引号能够阻止shell扩展*.txt，使得该字符串能够原封不动地传给find命令。
> $ find /home/slynux -name '*.txt' -print

find命令有一个选项-iname（忽略字母大小写），该选项的作用和-name类似，只不过在匹配名字时会忽略大小写。例如：
~~~
$ ls 
example.txt EXAMPLE.txt file.txt 
$ find . -iname "example*" -print 
./example.txt 
./EXAMPLE.txt
~~~

find命令支持逻辑操作符。-a和-and选项可以执行逻辑与（AND）操作，-o和-or选项可以执行逻辑或（OR）操作。
~~~
$ ls 
new.txt some.jpg text.pdf stuff.png 
$ find . \( -name '*.txt' -o -name '*.pdf' \) -print 
./text.pdf 
./new.txt
~~~
上面的命令会打印出所有的.txt和.pdf文件，因为这个find命令能够匹配所有这两类文件。\（以及\）用于将 -name '*.txt' -o -name '*.pdf'视为一个整体。

下面的命令演示了如何使用-and操作符选择名字以s开头且其中包含e的文件：
~~~
$ find . \( -name '*e*' -and -name 's*' \) 
./some.jpg
~~~
-path选项可以限制所匹配文件的路径及名称。例如，`$ find /home/users -path '*/slynux/*' -name '*.txt' –print`能够匹配文件/home/users/slynux/readme.txt，但无法匹配/home/users/slynux.txt。

> -regex选项和-path类似，只不过前者是基于正则表达式来匹配文件路径的。

正则表达式比通配符更复杂，能够更精确地进行模式匹配。使用正则表达式进行文本匹配的一个典型例子就是识别E-mail地址。E-mail地址通常采用name@host.root这种形式，所以可以将其一般化为`[a-z0-9]+@[a-z0-9]+\.[a-z0-9]+`。中括号中的字符表示的是一个字符组。在这个例子中，该字符组中包含a-z和0-9。符号+指明在它之前的字符组中的字符可以出现一次或多次。点号是一个元字符（就像通配符中的?），因此必须使用反斜线对其转义，这样才能匹配到E-mail地址中实际的点号。这个正则表达式可以理解为：一系列字母或数字，然后是一个@，接着是一系列字母和数字，再跟上一个点号，最后以一系列字母和数字结尾。我们会在4.2节中详细讲述正则表达式。

下面的命令可以匹配.py或.sh文件：
~~~
$ ls 
new.PY next.jpg test.py script.sh 
$ find . -regex '.*\.(py\|sh\)$'
./test.py 
script.sh
~~~
-iregex选项可以让正则表达式在匹配时忽略大小写。例如：
~~~
$ find . -iregex '.*\(\.py\|\.sh\)$'
./test.py 
./new.PY 
./script.sh
~~~

2. 否定参数

find也可以用!排除匹配到的模式：
~~~
$ find . ! -name "*.txt" -print
~~~
上面的find命令能够匹配所有不以.txt结尾的文件。该命令的运行结果如下：
~~~
$ ls 
list.txt new.PY new.txt next.jpg test.py 
$ find . ! -name "*.txt" -print 
. 
./next.jpg 
./test.py 
./new.PY
~~~
3. 基于目录深度的搜索

find命令在查找时会遍历完所有的子目录。默认情况下，find命令不会跟随符号链接。`-L`选项可以强制其改变这种行为。但如果碰上了指向自身的链接，find命令就会陷入死循环中。

`-maxdepth`和`–mindepth`选项可以限制find命令遍历的目录深度。这可以避免find命令没完没了地查找。
/proc文件系统中包含了系统与当前执行任务的信息。特定任务的目录层次相当深，其中还有一些绕回到自身（loop back on themselves）的符号链接。系统中运行的每个进程在proc中都有对应的子目录，其名称就是该进程的进程ID。这个目录下有一个叫作cwd的链接，指向进程的当前工作目录。

下面的例子展示了如何列出运行在含有文件bundlemaker.def的目录下的所有任务：
~~~
$ find -L /proc -maxdepth 1 -name 'bundlemaker.def' 2>/dev/null
~~~
 -L选项告诉find命令跟随符号链接

 从/proc目录开始查找

 -maxdepth 1将搜索范围仅限制在当前目录

 -name 'bundlemaker.def'指定待查找的文件

 2>/dev/null将有关循环链接的错误信息发送到空设备中

-mindepth选项类似于-maxdepth，不过它设置的是find开始进行查找的最小目录深度。这个选项可以用来查找并打印那些距离起始路径至少有一定深度的文件。例如，打印出深度距离当前目录至少两个子目录的所有名字以f开头的文件：
~~~
$ find . -mindepth 2 -name "f*" -print 
./dir1/dir2/file1 
./dir3/dir4/f2
~~~
即使当前目录或dir1和dir3中包含以f开头的文件，它们也不会被打印出来。

> -maxdepth和-mindepth应该在find命令中及早出现。如果作为靠后的选项，有可能会影响到find的效率，因为它不得不进行一些不必要的检查。例如，如果-maxdepth出现在-type之后，find首先会找出-type所指定的文件，然后再在匹配的文件中过滤掉不符合指定深度的那些文件。但是如果反过来，在-type之前指定目录深度，那么find就能够在找到所有符合指定深度的文件后，再检查这些文件的类型，这才是最有效的搜索之道。

4. 根据文件类型搜索

类Unix系统将一切都视为文件。文件具有不同的类型，例如普通文件、目录、字符设备、块设备、符号链接、硬链接、套接字以及FIFO等。

find命令可以使用-type选项对文件搜索进行过滤。借助这个选项，我们可以告诉find命
令只匹配指定类型的文件。

只列出所有的目录（包括子目录）：
~~~
$ find . -type d -print
~~~
将文件和目录分别列出可不是件容易事。不过有了find就好办了。例如，只列出普通文件：
~~~
$ find . -type f -print
~~~
只列出符号链接：
~~~
$ find . -type l -print
~~~
表2-1列出了find能够识别出的类型与参数。

|文件类型 |类型参数|
|------|------|
|普通文件 |f|
|符号链接 |l|
|目录 |d |
|字符设备 |c |
|块设备 |b|
|套接字 |s |
|FIFO |p|

5. 根据文件的时间戳进行搜索

Unix/Linux文件系统中的每一个文件都有3种时间戳，如下所示。

 访问时间（-atime）：用户最近一次访问文件的时间。

 修改时间（-mtime）：文件内容最后一次被修改的时间。

 变化时间（-ctime）：文件元数据（例如权限或所有权）最后一次改变的时间。

> Unix默认并不保存文件的创建时间。但有一些文件系统（ufs2、ext4、zfs、btrfs、jfs）会选择这么做。可以使用stat命令访问文件创建时间。
> 鉴于有些应用程序通过先创建一个新文件，然后再删除原始文件的方法来修改文件，文件创建时间未必准确。
> -atime、-mtime和-ctime可作为find的时间选项。它们可以用整数值来指定天数。这些数字前面可以加上-或+。-表示小于，+表示大于。

考虑下面的例子。

 打印出在最近7天内被访问过的所有文件。
~~~
$ find . -type f -atime -7 -print
~~~
 打印出恰好在7天前被访问过的所有文件。
~~~
$ find . -type f -atime 7 -print
~~~
 打印出访问时间超过7天的所有文件。
~~~
$ find . -type f -atime +7 -print
~~~
-mtime选项会根据修改时间展开搜索，-ctime会根据变化时间展开搜索。

-atime、-mtime以及-ctime都是以“天”为单位来计时的。find命令还支持以“分钟”为计时单位的选项。这些选项包括：

 -amin（访问时间）；

 -mmin（修改时间）；

 -cmin（变化时间）。

打印出7分钟之前访问的所有文件：
~~~
$ find . -type f -amin +7 -print
~~~
–newer选项可以指定一个用于比较修改时间的参考文件，然后找出比参考文件更新的（更近的修改时间）所有文件。

例如，找出比file.txt修改时间更近的所有文件：
~~~
$ find . -type f -newer file.txt -print
~~~
find命令的时间戳处理选项有助于编写系统备份和维护脚本。

6. 基于文件大小的搜索

可以根据文件的大小展开搜索：
~~~
# 大于2KB的文件
$ find . -type f -size +2k 
# 小于2KB的文件
$ find . -type f -size -2k 
# 大小等于2KB的文件
$ find . -type f -size 2k
~~~
除了k之外，还可以用其他文件大小单位。

 b：块（512字节）。

 c：字节。

 w：字（2字节）。

 k：千字节（1024字节）。

 M：兆字节（1024K字节）。

 G：吉字节（1024M字节）。

7. 基于文件权限和所有权的匹配

也可以根据文件权限进行文件匹配。列出具有特定权限的文件：
~~~
$ find . -type f -perm 644 -print 
# 打印出权限为644的文件
~~~
-perm选项指明find应该只匹配具有特定权限值的文件。文件权限会在3.5节进行讲解。

以Apache Web服务器为例。Web服务器上的PHP文件需要具有合适的执行权限。我们可以用下面的方法找出那些没有设置好执行权限的PHP文件：
~~~
$ find . -type f -name "*.php" ! -perm 644 –print 
PHP/custom.php 
$ ls -l PHP/custom.php 
-rw-rw-rw-. root root 513 Mar 13 2016 PHP/custom.php
~~~
我们也可以根据文件的所有权进行搜索。用选项 -user USER就能够找出由某个特定用户所拥有的文件。

参数USER可以是用户名或UID。

例如，可以使用下面的命令打印出用户slynux拥有的所有文件：
~~~
$ find . -type f -user slynux -print
~~~

8. 利用find执行相应操作

find命令能够对其所查找到的文件执行相应的操作。无论是删除文件或是执行任意的Linux命令都没有问题。

(1) 删除匹配的文件

find命令的-delete选项可以删除所匹配到的文件。下面的命令能够从当前目录中删除.swp文件：
~~~
$ find . -type f -name "*.swp" -delete
~~~
(2) 执行命令

利用-exec选项，find命令可以结合其他命令使用。

在上一个例子中，我们用-perm找出了所有权限不当的PHP文件。这次的任务也差不多，我们需要将某位用户（比如root）所拥有的全部文件的所有权更改成另一位用户（比如Web服务器默认的Apache用户www-data），那么可以用-user找出root拥有的所有文件，然后用-exec更改所有权。

> TIP:你必须以root用户的身份执行find命令才能够更改文件或目录的所有权。

find命令使用一对花括号{}代表文件名。在下面的例子中，对于每一个匹配的文件，find命令会将{}替换成相应的文件名并更改该文件的所有权。如果find命令找到了root所拥有的两个文件，那么它会将其所有者改为slynux：
~~~
# find . -type f -user root -exec chown slynux {} \;
~~~
> 注意该命令结尾的\;。必须对分号进行转义，否则shell会将其视为find命令的结束，而非chown命令的结束。

为每个匹配到的文件调用命令可是个不小的开销。如果指定的命令接受多个参数（如chown），你可以换用加号（+）作为命令的结尾。这样find会生成一份包含所有搜索结果的列表，然后将其作为指定命令的参数，一次性执行。

另一个例子是将给定目录中的所有C程序文件拼接起来写入单个文件all_c_files.txt。各种实现方法如下：
~~~
$ find . -type f -name '*.c' -exec cat {} \;>all_c_files.txt 
$ find . -type f -name '*.c' -exec cat {} > all_c_files.txt \; 
$ fine . -type f -name '*.c' -exec cat {} >all_c_files.txt +
~~~
我们使用 > 操作符将来自find的数据重定向到all_c_files.txt文件，没有使用>>（追加）的原因是find命令的全部输出就只有一个数据流（stdin），而只有当多个数据流被追加到单个文件中时才有必要使用>>。

下列命令可以将10天前的 .txt文件复制到OLD目录中：
~~~
$ find . -type f -mtime +10 -name "*.txt" -exec cp {} OLD \;
~~~
find命令还可以采用类似的方法与其他命令结合使用。

> 我们无法在-exec选项中直接使用多个命令。该选项只能够接受单个命令，不过我们可以耍一个小花招。把多个命令写到一个 shell脚本中（例如command.sh），然后在-exec中使用这个脚本：
> -exec ./commands.sh {} \; 

-exec可以同printf搭配使用来生成输出信息。例如：
~~~
$ find . -type f -name "*.txt" -exec printf "Text file: %s\n" {} \; 
Config file: /etc/openvpn/easy-rsa/openssl-1.0.0.cnf 
Config file: /etc/my.cnf
~~~

9. 让find跳过特定的目录

在find的执行过程中，跳过某些子目录能够提升性能。例如，在版本控制系统（如Git）管理的开发源代码树中查找特定文件时，文件系统的每个子目录里都会包含一个目录，该目录中保存了和版本控制相关的信息。这些目录通常跟我们没什么关系，所以没必要去搜索它们。

在搜索时排除某些文件或目录的技巧叫作修剪。下面的例子演示了如何使用-prune选项排除某些符合条件的文件：
~~~
$ find devel/source_path -name '.git' -prune -o -type f -print
~~~
`-name ".git" –prune`是命令中负责进行修剪的部分，它指明了.git目录应该被排除在外。`-type f –print`描述了要执行的操作。

## 2.5 玩转xargs

## 2.15 交互输入自动化

我们知道命令可以接受命令行参数。Linux也支持很多交互式应用程序，如passwd和ssh。

我们可以创建自己的交互式shell脚本。对于普通用户而言，相较于记忆命令行参数及其正确的顺序，同一系列提示信息打交道要更容易。例如，一个备份用户工作成果的脚本看起来应该像这样：

~~~
$ backupWork.sh 
 What folder should be backed up? notes
 What type of files should be backed up? .docx
~~~

如果你需要返回到同一交互式应用，实现交互式应用自动化能够节省大量的时间；如果你正在开发此类应用，这也可以避免你陷入重复输入的挫折感中。

### 2.15.1 预备知识

任务自动化的第一步就是运行程序，然后注意需要执行什么操作。之前讲过的脚本命令可能会派上用场。

### 2.15.2 实战演练

观察交互式输入的顺序。参照上面的代码，我们可以将涉及的步骤描述如下：

notes[Return]docx[Return] 

输入notes，按回车键，然后输入docx，再按回车键。这一系列操作可以被转换成下列字符串：

**"notes\ndocx\n"** 

按下回车键时会发送\n。添加\n后，就生成了发送给stdin的字符串。

通过发送与用户输入等效的字符串，我们就可以实现在交互过程中自动发送输入。

### 2.15.3 工作原理

先写一个读取交互式输入的脚本，然后用这个脚本做自动化演示：

~~~shell
#!/bin/bash 
# backup.sh 
# 使用后缀备份文件。不备份以~开头的临时文件
read -p " What folder should be backed up: " folder 
read -p " What type of files should be backed up: " suffix 
find $folder -name "*.$suffix" -a ! -name '~*' -exec cp {} \ 
 $BACKUP/$LOGNAME/$folder 
echo "Backed up files from $folder to $BACKUP/$LOGNAME/$folder"
~~~

按照下面的方法向脚本发送自动输入：

~~~shell
$ echo -e "notes\ndocx\n" | ./backup.sh 
Backed up files from notes to /BackupDrive/MyName/notes
~~~

像这样的交互式脚本自动化能够在开发和调试过程中节省大量输入。另外还可以确保每次测试都相同，不会出现由于输入错误导致的bug假象。

我们用echo -e来生成输入序列。-e选项表明echo会解释转义序列。如果输入内容比较多，可以用单独的输入文件结合重定向操作符来提供输入：

~~~shell
$ echo -e "notes\ndocx\n" > input.data 
$ cat input.data 
notes 
docx
~~~

你也可以选择手动构造输入文件，不使用echo命令：

~~~shell
$ ./interactive.sh < input.data
~~~

这种方法是从文件中导入交互式输入数据。

如果你是一名逆向工程师，那可能免不了要同缓冲区溢出攻击打交道。要实施攻击，我们需要将十六进制形式的shellcode（例如\xeb\x1a\x5e\x31\xc0\x88\x46）进行重定向。这些字符没法直接输入，因为键盘上并没有其对应的按键。因此，我们需要使用：

~~~shell
echo -e "\xeb\x1a\x5e\x31\xc0\x88\x46" 
~~~

这条命令会将这串字节序列重定向到有缺陷的可执行文件中。

echo命令和重定向可以实现交互式输入的自动化。但这种技术存在问题，因为输入内容没有经过验证，我们认定目标应用总是以相同的顺序接收数据。但如果程序要求的输入顺序不同，或是对某些输入内容不做要求，那就要出岔子了。

expect程序能够执行复杂的交互操作并适应目标应用的变化。该程序在世界范围内被广泛用于控制硬件测试、验证软件构建、查询路由器统计信息等。

### 2.15.4 补充内容

expect是一个和shell类似的解释器。它基于TCL语言。我们将讨论如何使用spawn、expect和send命令实现简单的自动化。借助于TCL语言的强大功能，expect能够完成更为复杂的任务。你可以通过网站http://www.tcl.tk学到有关TCL语言的更多内容。

**用expect实现自动化**

Linux发行版默认并不包含expect。你得用软件包管理器（apt-get或yum）手动进行安装。

expect有3个主要命令，见表2-2。

| 命令   | 描述                   |
| ------ | ---------------------- |
| spawn  | 允许新的目标应用       |
| expect | 关注目标应用发送的模式 |
| send   | 向目标应用发送字符串   |

下面的例子会先执行备份脚本，然后查找模式`*folder*`或`*file*`，以此确定备份脚本是否要求输入目录名或文件名并作出相应的回应。如果重写备份脚本，要求先输入备份文件类型，后输入备份目录，这个自动化脚本依然能够应对。

~~~shell
#!/usr/bin/expect 
#文件名: automate_expect.tcl 
spawn ./backup .sh 
expect { 
    "*folder*" { 
        send "notes\n" 
        exp_continue 
    } 
    "*type*" { 
        send "docx\n" 
        exp_continue 
    }
}
~~~

运行该脚本：

~~~shell
$ ./automate_expect.tcl
~~~

spawn命令的参数是需要自动化运行的应用程序及其参数。

expect命令接受一组模式以及匹配模式时要执行的操作。操作需要放入花括号中。

send命令是要发送的信息。和echo -n -e类似，send不会自动添加换行符，也能够理解转义字符。

## 2.16 利用并行进程加速命令执行

# 第4章 让文本飞

## 4.6 使用awk进行高级文本处理

awk命令可以处理数据流。它支持关联数组、递归函数、条件语句等功能。

### 4.6.1 预备知识

awk脚本的结构如下：

~~~shell
awk 'BEGIN{ print "start" } pattern { commands } END{ print "end" }' file
~~~

awk命令也可以从stdin中读取输入。

awk脚本通常由3部分组成：BEGIN、END和带模式匹配选项的公共语句块（common statement block）。这3个部分都是可选的，可以不用出现在脚本中。

awk以逐行的形式处理文件。BEGIN之后的命令会先于公共语句块执行。对于匹配PATTERN 的行，awk会对其执行PATTERN之后的命令。最后，在处理完整个文件之后，awk会执行END之后的命令。

### 4.6.2 实战演练

简单的awk脚本可以放在单引号或双引号中：

~~~shell
awk 'BEGIN { statements } { statements } END { end statements }'
~~~

或者

~~~shell
awk "BEGIN { statements } { statements } END { end statements }"
~~~

下面的命令会输出文件行数：

~~~shell
$ awk 'BEGIN { i=0 } { i++ } END { print i}' filename
~~~

或者

~~~shell
$ awk "BEGIN { i=0 } { i++ } END { print i }" filename
~~~

### 4.6.3 工作原理

awk命令的工作方式如下。

(1) 首先执行BEGIN { commands } 语句块中的语句。

(2) 接着从文件或stdin中读取一行，如果能够匹配pattern，则执行随后的commands语句块。重复这个过程，直到文件全部被读取完毕。

(3) 当读至输入流末尾时，执行END { commands } 语句块。

BEGIN语句块在awk开始从输入流中读取行之前被执行。这是一个可选的语句块，诸如变量初始化、打印输出表格的表头等语句通常都可以放在BEGIN语句块中。

END语句块和BEGIN语句块类似。它在awk读取完输入流中所有的行之后被执行。像打印所有行的分析结果这种常见任务都是在END语句块中实现的。

最重要的部分就是和pattern关联的语句块。这个语句块同样是可选的。如果不提供，则默认执行{ print }，即打印所读取到的每一行。awk对于读取到的每一行都会执行该语句块。这就像一个用来读取行的while循环，在循环体中提供了相应的语句。

每读取一行，awk就会检查该行是否匹配指定的模式。模式本身可以是正则表达式、条件语句以及行范围等。如果当前行匹配该模式，则执行{ }中的语句。

模式是可选的。如果没有提供模式，那么awk就认为所有的行都是匹配的：

~~~shell
$ echo -e "line1\nline2" | awk 'BEGIN { print "Start" } { print }  END { print "End" } ' 
Start 
line1 
line2 
End
~~~

当使用不带参数的print时，它会打印出当前行。

print能够接受参数。这些参数以逗号分隔，在打印参数时则以空格作为参数之间的分隔符。在awk的print语句中，双引号被当作拼接操作符（concatenation operator）使用。例如：

~~~shell
$ echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1,var2,var3 ; }'
~~~

echo命令向标准输出写入一行，因此awk的 { } 语句块中的语句只被执行一次。如果awk的输入中包含多行，那么 { } 语句块中的语句也就会被执行相应的次数。

拼接的使用方法如下：

~~~shell
$ echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1 "-" var2 "-" var3 ; }'
~~~

该命令输出如下：

~~~
v1-v2-v3
~~~

{ }就像一个循环体，对文件中的每一行进行迭代。

> **TIP**: 
>
> 我们通常将变量初始化语句（如var=0;）放入BEGIN语句块中。在END{} 语句块中，往往会放入用于打印结果的语句。

### 4.6.4 补充内容

awk命令与诸如grep、find和tr这类命令不同，它功能众多，而且拥有很多能够更改命令行为的选项。awk命令是一个解释器，它能够解释并执行程序，和shell一样，它也包括了一些特殊变量。

#### 1. 特殊变量

以下是awk可以使用的一些特殊变量。

- NR：表示记录编号，当awk将行作为记录时，该变量相当于当前行号。
- NF：表示字段数量，在处理当前记录时，相当于字段数量。默认的字段分隔符是空格。
- $0：该变量包含当前记录的文本内容。
- $1：该变量包含第一个字段的文本内容。
- $2：该变量包含第二个字段的文本内容。

例如：

~~~shell
$ echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | \ 
awk '{ \
 print "Line no:"NR",No of fields:"NF, "$0="$0, \
 "$1="$1,"$2="$2,"$3="$3 \
}' 
Line no:1,No of fields:3 $0=line1 f2 f3 $1=line1 $2=f2 $3=f3 
Line no:2,No of fields:3 $0=line2 f4 f5 $1=line2 $2=f4 $3=f5 
Line no:3,No of fields:3 $0=line3 f6 f7 $1=line3 $2=f6 $3=f7
~~~

我们可以用`print $NF`打印一行中最后一个字段，用 ​`$(NF-1)`打印倒数第二个字段，其他字段以此类推。awk也支持printf()函数，其语法和C语言中的同名函数一样。

下面的命令会打印出每一行的第二和第三个字段：

~~~shell
$awk '{ print $3, $2 }' file
~~~

我们可以使用NR统计文件的行数：

~~~shell
$ awk 'END{ print NR }' file
~~~

这里只用到了END语句块。每读入一行，awk都会更新NR。当到达文件末尾时，NR中的值就是最后一行的行号。你可以将每一行中第一个字段的值按照下面的方法累加：

~~~shell
$ seq 5 | awk 'BEGIN { sum=0; print "Summation:" } { print $1"+"; sum+=$1 } END { print "=="; print sum }' 
Summation: 
1+ 
2+ 
3+ 
4+ 
5+ 
== 
15
~~~

#### 2. 将外部变量值传递给awk

借助选项-v，我们可以将外部值（并非来自stdin）传递给awk：

~~~shell
$ VAR=10000 
$ echo | awk -v VARIABLE=$VAR '{ print VARIABLE }' 
10000
~~~

还有另一种灵活的方法可以将多个外部变量传递给awk。例如：

~~~shell
$ var1="Variable1" ; var2="Variable2" 
$ echo | awk '{ print v1,v2 }' v1=$var1 v2=$var2 
Variable1 Variable2
~~~

在上面的方法中，变量以键值对的形式给出，使用空格分隔（`v1=$var1 v2=$var2`），作为awk的命令行参数紧随在BEGIN、{}和END语句块之后。

#### 3. 用getline读取行

awk默认读取文件中的所有行。如果只想读取某一行，可以使用getline函数。它可以用于在BEGIN语句块中读取文件的头部信息，然后在主语句块中处理余下的实际数据。

该函数的语法为：getline var。变量var中包含了特定行。如果调用时不带参数，我们可以用 `$0`、`$1`和`$2`访问文本行的内容。例如：

~~~shell
$ seq 5 | awk 'BEGIN { getline; print "Read ahead first line", $0 } 
{ print $0 }' 
Read ahead first line 1 
2 
3 
4 
5
~~~

#### 4. 使用过滤模式对awk处理的行进行过滤

我们可以为需要处理的行指定一些条件：

~~~shell
$ awk 'NR < 5' # 行号小于5的行
$ awk 'NR==1,NR==4' # 行号在1到5之间的行
$ awk '/linux/' # 包含模式为linux的行（可以用正则表达式来指定模式）
$ awk '!/linux/' # 不包含模式为linux的行
~~~

#### 5. 设置字段分隔符

默认的字段分隔符是空格。我们也可以用选项-F指定不同的分隔符：

~~~shell
$ awk -F: '{ print $NF }' /etc/passwd
~~~

或者

~~~shell
awk 'BEGIN { FS=":" } { print $NF }' /etc/passwd
~~~

在BEGIN语句块中可以用OFS="delimiter"设置输出字段分隔符。

#### 6. 从awk中读取命令输出

awk可以调用命令并读取输出。把命令放入引号中，然后利用管道将命令输出传入getline：

~~~shell
"command" | getline output ;
~~~

下面的代码从/etc/passwd文件中读入一行，然后显示出用户登录名及其主目录。在BEGIN语句块中将字段分隔符设置为:，在主语句块中调用了grep。

~~~shell
$ awk 'BEGIN {FS=":"} { "grep root /etc/passwd" | getline; \ 
 print $1,$6 }' 
root /root
~~~

#### 7. awk的关联数组

除了数字和字符串类型的变量，awk还支持关联数组。关联数组是一种使用字符串作为索引的数组。你可以通过中括号中索引的形式来分辨出关联数组：

~~~shell
arrayName[index] 
~~~

就像用户定义的简单变量一样，你也可以使用等号为数组元素赋值：

~~~shell
myarray[index]=value 
~~~

#### 8. 在awk中使用循环

在awk中可以使用for循环，其格式与C语言中的差不多： 

~~~shell
for(i=0;i<10;i++) { print $i ; }
~~~

另外awk还支持列表形式的for循环，也可以显示出数组的内容：

~~~shell
for(i in array) { print array[i]; }
~~~

下面的例子展示了如何将收集到的数据存入数组并显示出来。这个脚本从/etc/password中读取文本行，以:作为分隔符将行分割成字段，然后创建一个关联数组，数组的索引是登录ID，对应的值是用户名：

~~~shell
$ awk 'BEGIN {FS=":"} {nam[$1]=$5} END {for {i in nam} {print i,nam[i]}}' /etc/passwd 
root root 
ftp FTP User 
userj Joe User
~~~

#### 9. awk内建的字符串处理函数

awk有很多内建的字符串处理函数。

- length(string)：返回字符串string的长度。
- index(string, search_string)：返回search_string在字符串string中出现的位置。
- split(string, array, delimiter)：以delimiter作为分隔符，分割字符串string，将生成的字符串存入数组array。 
- substr(string, start-position, end-position) ：返回字符串 string 中 以start-position和end-position作为起止位置的子串。
- sub(regex, replacement_str, string)：将正则表达式regex匹配到的第一处内容替换成replacment_str。 
- gsub(regex, replacement_str, string)：和sub()类似。不过该函数会替换正则表达式regex匹配到的所有内容。
- match(regex, string)：检查正则表达式regex是否能够在字符串string中找到匹配。如果能够找到，返回非0值；否则，返回0。match()有两个相关的特殊变量，分别是RSTART和RLENGTH。变量RSTART包含了匹配内容的起始位置，而变量RLENGTH包含了匹配内容的长度。

## 4.7 统计特定文件中的词频

计算机善于计数。我们经常要进行各种统计，例如发送垃圾邮件的站点数、不同页面的下载量或是文本中单词出现的频率。这则攻略将展示如何统计文本中的单词词频。其中用到的技术也可以应用于日志文件、数据库输出等方面。

### 4.7.1 预备知识

我们可以使用awk的关联数组来解决这个问题，而且实现方法还不止一种。单词是由空格或点号分隔的字母组合。首先，我们需要解析出给定文件中出现的所有单词，然后统计每个单词的出现次数。单词解析可以用正则表达式配合sed、awk或grep等工具来完成。

### 4.7.2 实战演练

我们已经了解了实现原理。现在来动手创建如下的脚本：

~~~shell
#!/bin/bash 
# 文件名：word_freq.sh 
# 用途: 计算文件中单词的词频
if [ $# -ne 1 ]; 
then 
    echo "Usage: $0 filename"; 
    exit -1 
fi 
filename=$1 
egrep -o "\b[[:alpha:]]+\b" $filename | awk '{ count[$0]++ } END{ printf("%-14s%s\n","Word","Count") ; \
	for(ind in count) { \
		printf("%-14s%d\n",ind,count[ind]); \
	} \
}'
~~~

输出如下

~~~
$ ./word_freq.sh words.txt 
Word Count 
used 1 
this 2 
counting 1
~~~

### 4.7.3 工作原理

egrep命令将文本文件转换成单词流，每行一个单词。模式\b[[:alpha:]]+\b能够匹配每个单词并去除空白字符和标点符号。选项-o打印出匹配到的单词，一行一个。

awk命令统计每个单词。它针对每一行文本执行{}语句块中的语句，因此我们不需要再专门为此写一个循环。`count[$0]++`命令负责计数，其中`$0`是当前行，count是关联数组。所有的行处理完毕后，END{}语句块打印出各个单词及其数量。

整个处理过程也能够使用我们学过的其他工具来改写。可以利用tr命令将大写单词和非大写单词合计为一个单词，然后用sort命令排序输出：

~~~shell
egrep -o "\b[[:alpha:]]+\b" $filename | tr [A-Z] [a-z] | \ 
 awk '{ count[$0]++ } \
 END{ printf("%-14s%s\n","Word","Count") ; \
 for(ind in count) \
 { printf("%-14s%d\n",ind,count[ind]); \
 } \
 }' | sort
~~~

### 4.7.4 参考

- 1.7节讲解了Bash中的数组。
- 4.6节讲解了awk命令。

## 4.8 压缩或解压缩JavaScript