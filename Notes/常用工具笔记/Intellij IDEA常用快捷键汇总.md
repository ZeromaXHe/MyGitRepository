| 快捷键                   | 作用                                                     |
| ------------------------ | -------------------------------------------------------- |
| `Ctrl+/`或`Ctrl+shift+/` | 注释（`//`或`/*...*/`）                                  |
| `Ctrl+D`                 | 复制行                                                   |
| `Ctrl+X`                 | 剪切行                                                   |
| `Ctrl+Y`                 | 删除行                                                   |
| `Ctrl+R`                 | 替换文本                                                 |
| `Ctrl+F`                 | 查找文本                                                 |
| `Ctrl+G`                 | 定位某一行                                               |
| `Ctrl+I`                 | 实现方法                                                 |
| `Ctrl+O`                 | 覆盖/重写方法                                            |
| `Ctrl+J`                 | 自动代码，插入代码模板（类似psvm这些）                   |
| `Ctrl+W`                 | 扩大被选择代码范围                                       |
| `Ctrl+Shift+W`           | 缩小被选择代码范围                                       |
| `Alt+Enter`              | 快速修复（导包等）                                       |
| `Alt+/`                  | 代码提示                                                 |
| `Alt+Insert`             | 生成代码(如GET,SET方法,构造函数等)                       |
| `Alt+←/→`                | 切换代码视图                                             |
| `Alt+↑/↓`                | 在方法间快速移动定位(上一个/下一个方法)                  |
| `Ctrl+Alt+L`             | 格式化代码（==会和网易云音乐全局快捷键冲突。。。==）     |
| `Ctrl+Alt+T`             | Surround With ...                                        |
| `Ctrl+Alt+I`             | 自动缩进本行或本块代码                                   |
| `Ctrl+Alt+O`             | 格式化import列表，优化导入的类和包                       |
| `Ctrl+Alt+←`             | 返回上一级代码（==会和网易云音乐全局快捷键冲突。。。==） |
| `Ctrl+Shift+↑或↓`        | 向上/下移动代码块                                        |
| `Ctrl+Shift+Space`       | 智能代码提示                                             |
| `Alt+Shift+↑或↓`         | 向上/下移动代码行                                        |
| `Shift+(Fn)+F6`          | 重构-重命名                                              |

常用的有`fori/sout/psvm+Tab`即可生成循环、System.out、main方法等boilerplate样板代码

for(User user : users)只需输入`user.for+Tab`。再比如，要输入Date birthday = user.getBirthday();只需输入`user.getBirthday().var+Tab`即可