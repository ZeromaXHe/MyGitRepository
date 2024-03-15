# 常用操作

`Alt` + `Enter` 显示建议操作

双击 `Shift` 全局搜索

# 快捷键

File -> Setting -> Keymap 中可以查看全部快捷键

## 主菜单

### 编辑（Edit）

`Ctrl` + `Z` 撤销

`Ctrl` + `Shift` + `Z` 重做



`Ctrl` + `X` 剪切

> `Ctrl` + `Y` 删除行

`Ctrl` + `C` 复制

`Ctrl` + `V` 粘贴

`Ctrl` + `Shift` + `V` 从历史记录中选择粘贴

`Ctrl` + `Alt` + `Shift` + `V` 粘贴纯文字



`Ctrl` + `F` 查找

`Ctrl` + `Shift` + `F` 在指定范围中文件查找

`Ctrl` + `R` 替换



`Alt` + `F7` 查看调用处



`Alt` + `Shift` + `Insert` 列选择模式（不清楚啥情况用的到，但是不小心按到了启动该模式后，会导致你点击一行后面的空间不会自动回到行最后，而是停在点击处）

`Ctrl` + `A` 全选



`Ctrl` + `W` 扩大选区

`Ctrl` + `Shift` + `W` 缩小选区



`Ctrl` + `Shift` + `U` 切换大小写

`Ctrl` + `Shift` + `J` 合并为一行（处理 JSON 时很有用）

`Ctrl` + `D` 复制一行



`Tab` 增加缩进

`Shift` + `Tab` 减少缩进



### 视图（View）

`Ctrl` + `Q` 快速查看文档



### 定位（Navigate）

`Ctrl` + `Alt` + `←` 回退上一处

`Ctrl` + `Alt` + `→` 前进下一处



`Ctrl` + `G` 定位到行和列



`F2` 定位到下一处错误

`Shift` + `F2` 定位到下一处错误



`Alt` + `↑` 上一个方法

`Alt` + `↓` 下一个方法



> `Ctrl` + `[` 定位到代码块开始
>
> `Ctrl` + `]` 定位到代码块结束

`Ctrl` + `Shift` + `M` 定位到匹配的括号



`Ctrl` + `B` 查看光标所在处的方法调用处（`Ctrl` + `鼠标左键` 作用类似）

`Ctrl` + `Alt` + `B` 查看方法实现处



`Ctrl` + `F12` 结构（打开后可以直接输入字符查找对应方法名、字段名等）



`Ctrl` + `H` 类型层级



`F11` 书签

`Ctrl` + `F11` 带助记符的书签（`Ctrl` + `对应数字助记符` 即可跳转，字母助记符不行）

`Shift` + `F11` 查看书签



### 代码（Code）

`Alt` + `Insert` 生成各种代码，包括构造方法、getter、setter、equals、toString、覆写方法等。（所以 `Ctrl` + `O` 用来覆写方法的快捷键可能少用一点，这里涵盖了）



`Ctrl` + `Alt` + `T` （使用 if-else、while、for、try-catch-finally 等）包裹代码



`Ctrl` + `+` 展开方法块

`Ctrl` + `-` 缩起方法块



`Ctrl` + `/` 单行注释（`//`）

`Ctrl` + `Shift` + `/` 多行注释（`/* */`）



`Ctrl` + `Alt` + `L` 按格式规整代码

`Ctrl` + `Alt` + `O` 优化 import



`Ctrl` + `Shift` + `↑` 将整段内容上移

`Ctrl` + `Shift` + `↓` 将整段内容下移

`Alt` + `Shift` + `↑` 将单行上移

`Alt` + `Shift` + `↓` 将单行下移



### 重构（Refactor）

`Shift` + `F6` 重命名



`Ctrl` + `Alt` + `V` 重构成变量（个人习惯用 `.var`）

`Ctrl` + `Alt` + `C` 重构成常量

`Ctrl` + `Alt` + `F` 重构成字段（可以用 `.field`）

`Ctrl` + `Alt` + `P` 重构成参数



`Ctrl` + `Alt` + `M` 重构成方法

`Ctrl` + `Alt` + `N` 内联方法

## 编辑器操作

`Alt` + `Shift` + `鼠标左键` 添加光标

`鼠标中键`（或 `Alt` + `鼠标左键`） 拖动后创建矩形选择区



`Ctrl` + `[` 定位到代码块开始

`Ctrl` + `Shift` + `[` 光标移到代码块开始并选中中间文字

`Ctrl` + `]` 定位到代码块结束

`Ctrl` + `Shift` + `]` 光标移到代码块结束并选中中间文字



`Ctrl` + `Y` 删除行

`Ctrl` + `Delete` 删除到词尾

`Ctrl` + `Backspace` 删除到词头



`Shift` + `↑` / `Shift` + `↓` / `Shift` + `←` / `Shift` + `→` 光标上下左右移并选中中间文字

`Shift` + `End` 光标移到行尾并选中中间文字

`Shift` + `Home` 光标移到行头并选中中间文字

`Shift` + `Page Down` 光标移到下一页并选中中间文字

`Shift` + `Page Up` 光标移到上一页并选中中间文字



`Ctrl` + `Page Down` 将光标移动到页底

`Ctrl` + `Shift` + `Page Down` 将光标移动到页底并选中

`Ctrl` + `Page Up` 将光标移动到页头

`Ctrl` + `Shift` + `Page Up` 将光标移动到页头并选中

`Ctrl` + `←` / `Ctrl` + `→` 将光标移动到上（下）一个词

`Ctrl` + `Shift` + `←` / `Ctrl` + `Shift` + `→` 将光标移动到上（下）一个词并选中



`Ctrl` + `Enter` 分行（光标后面内容切到新的一行，光标留在原位）

`Shift` + `Enter` 新行（光标后面内容不会切行，光标移至新起一行）

`Ctrl` + `Alt` + `Enter` 当前位置之上建立新行



## 官方插件

`Ctrl` + `Alt` + `U` 查看 UML 类图

# 模板和后缀补全

File -> Setting -> Editor -> Live Templates

File -> Setting -> Editor -> General -> Postfix Completion



`psvm` / `main` 快速生成 main 方法



`psf` 快速输入 private static final

`psfi` 快速输入 private static final int

`psfs` 快速输入 private static final String



`sout` 快速输入 `System.out.println()`

`soutp` 快速生成打印方法参数的代码

`soutm` 快速生成打印方法名的代码

`soutv` 快递生成打印变量的代码

`.sout` 生成打印点前面的变量的代码



`fori` 生成 从 int i = 0 开始，i++ 的基础 for 循环

`iter` 生成增强 for 循环（也叫 for-each 循环）

`.for` / `.iter` 生成点前面可遍历变量的增强 for 循环

`.fori` 生成点前面可遍历变量的基础 for 循环

`.forr` 生成点前面可遍历变量的倒序基础 for 循环



`.!` / `.not` 生成前面布尔值的非值

`ifn` 快速生成 null 的 if 判断

`inn` 快速生成非 null 的 if 判断

`.if` 生成点前面变量的 if 判断

`.else` 生成点前面变量的非值 if 判断

`.null` 生成点前面变量的 null 的 if 判断

`.nn` / `.notnull` 生成点前面变量的非 null 的 if 判断



`.inst` / `.instanceof` 快速生成 instanceof 判断三元表达式



`.par` 快速加小括号



`.stream` 在数组后输入可以自动生成 Arrays.stream(数组) 