# Typora行内LaTeX公式无效

## Question:

在Typora中输入$...$后，无法显示为公式。

## Solution:

> 找到Typora -> Preference -> Mardown -> Syntax Support -> 勾选Inline Math(e.g: $\LaTeX$)。
> 然后重启Typora编辑器，即可！

对于我目前使用的0.9.96(beta)版本，路径如下：

文件 -> 偏好设置 -> Markdown -> Markdown扩展语法 -> 内联公式



# 如何控制LaTeX下标出现在正下方

在用Latex输入数学公式时（特别是文字之间的公式），有时需要将公式的下标放在正下方。

比如Max函数下面的取值范围，需要放在Max的正下方。操作方法如下：

如果是数学符号，那么直接用**`\limits`命令**放在正下方，如:

`\sum\limits_{i=1}`

$ \sum\limits_{i=1} $
若是普通符号dao，那么要专**用`\mathop`**先转成数学符号再用\limits，如:

`\mathop{a}\limits_{i=1}`

$ \mathop{a}\limits_{i=1} $



其他相关（如箭头上下）：

**1、使用 `\xleftarrow` or `\xrightarrow`. 两者的用法相同。**

`a=b \xleftarrow[H]{\xi+a\times c} f=g`

$a=b \xleftarrow[H]{\xi+a\times c} f=g$

**2、使用 `\overset`**

`a=b \overset{F}{\longleftarrow}c=d`

$a=b \overset{F}{\longleftarrow}c=d$

**3、使用 `\stackrel`**

`a=b \stackrel{F}{\longleftrightarrow}c=d`

$a=b \stackrel{F}{\longleftrightarrow}c=d$

对于双美元符之间的公式，Latex默认下标是放在正下方。所以就不需要加\limits        

**4、使用 `\mathop`**

ab \mathop{\sum\sum\sum}_{a=\frac{1}{2}\times 100000}^{b=\frac{4}{5}}cd

$ab \mathop{\sum\sum\sum}_{a=\frac{1}{2}\times 100000}^{b=\frac{4}{5}}cd$

修改一下，有时候使用\mathop不成功，可改为\mathop{ }\limits_{ }^{ }

$ab \mathop{\sum\sum\sum}\limits_{a=\frac{1}{2}\times 100000}^{b=\frac{4}{5}}cd$



# LaTeX语法大全

https://blog.csdn.net/young951023/article/details/79601664

## 声调

| 语法           | 效果           | 语法           | 效果           | 语法             | 效果             |
| -------------- | -------------- | -------------- | -------------- | ---------------- | ---------------- |
| `\bar{x}`      | $\bar{x}$      | `\acute{\eta}` | $\acute{\eta}$ | `\check{\alpha}` | $\check{\alpha}$ |
| `\grave{\eta}` | $\grave{\eta}$ | `\breve{a}`    | $\breve{a}$    | `\ddot{y}`       | $\ddot{y}$       |
| `\dot{x}`      | $\dot{x}$      | `\hat{\alpha}` | $\hat{\alpha}$ | `\tilde{\iota}`  | $\tilde{\iota}$  |

## 运算符

| 名称     | 语法                 | 效果                 |
| -------- | -------------------- | -------------------- |
| 向量     | `\vec`               | $\vec c$             |
| 点乘     | `\cdot`              | $\cdot$              |
| 叉乘     | `\times`             | $\times$             |
| 除       | `\div`               | $\div$               |
| 求和     | `\sum_1^n`           | $\sum_1^n$           |
| 积分     | `\int_1^n`           | $\int_1^n$           |
| 极限     | `lim_{x \to \infty}` | $lim_{x \to \infty}$ |
| 分数     | `\frac{3}{8}`        | $\frac{3}{8}$        |
| 根号     | `\sqrt[n]{3}`        | $\sqrt[n]{3}$        |
| 复合函数 | `f \circ g`          | $f \circ g$          |

## 集合

| 语法        | 效果        | 语法          | 效果          | 语法        | 效果        | 语法        | 效果        | 语法          | 效果          |
| ----------- | ----------- | ------------- | ------------- | ----------- | ----------- | ----------- | ----------- | ------------- | ------------- |
| `\forall`   | $\forall$   | `\exists`     | $\exists$     | `\empty`    | $\empty$    | `\emptyset` | $\emptyset$ | `\varnothing` | $\varnothing$ |
| `\in`       | $\in$       | `\ni`         | $\ni$         | `\not\in`   | $\not\in$   | `\notin`    | $\notin$    | `\subset`     | $\subset$     |
| `\subseteq` | $\subseteq$ | `\supset`     | $\supset$     | `\supseteq` | $\supseteq$ | `\cap`      | $\cap$      | `\bigcap`     | $\bigcap$     |
| `\cup`      | $\cup$      | `\bigcup`     | $\bigcup$     | `\biguplus` | $\biguplus$ | `\sqsubset` | $\sqsubset$ | `\sqsubseteq` | $\sqsubseteq$ |
| `\sqsupset` | $\sqsupset$ | `\sqsupseteq` | $\sqsupseteq$ | `\sqcap`    | $\sqcap$    | `\sqcup`    | $\sqcup$    | `\bigsqcup`   | $\bigsqcup$   |

## 空格和换行

**1.使用`\ ` 表示空格**

以及调整空格的大小

| quad空格 | a \qquad b | $a\qquad b$ | 两个*m*的宽度  |
| -------- | ---------- | ----------- | -------------- |
| quad空格 | a \quad b  | $a\quad b$  | 一个*m*的宽度  |
| 大空格   | a\ b       | $a\ b$      | 1/3*m*宽度     |
| 中等空格 | a\;b       | $a\;b$      | 2/7*m*宽度     |
| 小空格   | a\,b       | $a\,b$      | 1/6*m*宽度     |
| 没有空格 | ab         | $ab$        |                |
| 紧贴     | a\!b       | $a\!b$      | 缩进1/6*m*宽度 |

 \quad、1em、em、m代表当前字体下接近字符‘M’的宽度。

 **2.使用`\\`表示换行**

## 关系符号

| 名称         | 语法                                      | 效果                                      |
| ------------ | :---------------------------------------- | ----------------------------------------- |
| 相似         | `\Delta ABC\sim\Delta XYZ`                | $\Delta ABC\sim\Delta XYZ$                |
| 约等于       | `\sqrt{3}\approx1.732050808\ldots`        | $\sqrt{3}\approx1.732050808\ldots$        |
|              | \simeq                                    | $\simeq$                                  |
| 全等         | \cong                                     | $\cong$                                   |
|              | \dot=                                     | $\dot=$                                   |
| 偏序小于     | \prec                                     | $\prec$                                   |
| 偏序小于等于 | \preceq                                   | $\preceq$                                 |
| 偏序大于     | \succ                                     | $\succ$                                   |
| 偏序大于等于 | \succeq                                   | $\succeq$                                 |
|              | `\ggg`                                    | $\ggg$                                    |
| 远大于       | `\gg`                                     | $\gg$                                     |
| 大于         | `>`                                       | $>$                                       |
| 大于等于     | `\ge`                                     | $\ge$                                     |
|              | `\geqq`                                   | $\geqq$                                   |
| 等于         | `=`                                       | $=$                                       |
|              | `\gtrless`                                | $\gtrless$                                |
| 小于等于     | `\leq`                                    | $\leq$                                    |
|              | `\leqq`                                   | $\leqq$                                   |
| 小于         | `<`                                       | $<$                                       |
| 远小于       | `\ll`                                     | $\ll$                                     |
|              | `\lll`                                    | $\lll$                                    |
| 恒等于       | `(x-y)^2\equiv(-x+y)^2\equiv x^2-2xy+y^2` | $(x-y)^2\equiv(-x+y)^2\equiv x^2-2xy+y^2$ |
|              | x\not\equiv N                             | $x\not\equiv N$                           |
|              | x\ne A                                    | $x\ne A$                                  |
|              | x\neq C                                   | $x\neq C$                                 |
|              | t\propto v                                | $t\propto v$                              |
|              | \pm                                       | $\pm$                                     |
|              | \mp                                       | $\mp$                                     |
| 因为         | `\because`                                | $\because$                                |
| 所以         | `\therefore`                              | $\therefore$                              |

## 几何符号

| 特征            | 语法                                                       | 效果                                                       |
| :-------------- | :--------------------------------------------------------- | ---------------------------------------------------------- |
| 菱形            | \Diamond 和 \diamond                                       | $\Diamond$和$\diamond$                                     |
| 正方形          | \Box                                                       | $\Box$                                                     |
| 三角形（Delta） | `\Delta`                                                   | $\Delta$                                                   |
| 三角形（图型）  | `\triangle`                                                | $\triangle$                                                |
| 角名            | `\angle\Alpha\Beta\Gamma`                                  | $\angle\Alpha\Beta\Gamma$                                  |
| 角度            | `\sin\!\frac{\pi}{3}=\sin60^{\omicron}=\frac{\sqrt{3}}{2}` | $\sin\!\frac{\pi}{3}=\sin60^{\omicron}=\frac{\sqrt{3}}{2}$ |
| 垂直            | \perp                                                      | $\perp$                                                    |

## 微积分

| 名称           | 语法                                              | 效果                                |
| :------------- | :------------------------------------------------ | :---------------------------------- |
|                | \nabla                                            | $\nabla$                            |
|                | \dot x                                            | $\dot x$                            |
|                | \ddot y                                           | $\ddot y$                           |
|                | \partial x                                        | $\partial x$                        |
|                | \mathrm{d}x                                       | $\mathrm{d}x$                       |
| 积分           | \int_{-N}^{N} e^x\, dx                            | $\int_{-N}^{N} e^x\, dx$            |
| 双重积分       | \iint_{D}^{W} \, dx\,dy                           | $\iint_{D}^{W} \, dx\,dy$           |
| 三重积分       | \iiint_{E}^{V} \, dx\,dy\,dz                      | $\iiint_{E}^{V} \, dx\,dy\,dz$      |
| 四重积分       | \iiiint_{F}^{U} \, dx\,dy\,dz\,dt                 | $\iiiint_{F}^{U} \, dx\,dy\,dz\,dt$ |
| 闭合的曲线积分 | \oint_{C} x^3\, dx + 4y^2\, dy                    | $\oint_{C} x^3\, dx + 4y^2\, dy$    |
| 闭合的曲面积分 | \oiint                                            | $\oiint$                            |
| 极限           | \lim_\limits{n \to \infty}x_n （`\limits`可忽略） | $\lim_\limits{n \to \infty}x_n$     |



## 括号

| 功能   | 语法                       | 显示                         |
| :----- | :------------------------- | ---------------------------- |
| 不好看 | ( \frac{1}{2} )            | $( \frac{1}{2} )$            |
| 好看了 | \left( \frac{1}{2} \right) | $\left( \frac{1}{2} \right)$ |

您可以使用 `\left` 和 `\right` 来显示不同的括号：

| 功能                         | 语法                                                      | 显示                                                |
| :--------------------------- | :-------------------------------------------------------- | --------------------------------------------------- |
| 圆括号，小括号               | \left**(** \frac{a}{b} \right**)**                        | $\left( \frac{a}{b} \right)$                        |
| 方括号，中括号               | \left**[** \frac{a}{b} \right**]**                        | $\left[ \frac{a}{b} \right]$                        |
| 花括号，大括号               | `\left \{ \frac{a}{b} \right \} `                         | $\left\{\frac{a}{b}\right\}$                        |
| 角括号                       | \left **\langle** \frac{a}{b} \right **\rangle**          | $\left \langle \frac{a}{b} \right \rangle$          |
| 单竖线，绝对值               | \left**\|** \frac{a}{b} \right**\|**                      | $\left | \frac{a}{b} \right |$                      |
| 双竖线，范                   | `\left \| \frac{a}{b} \right \|`                          | $\left \| \frac{a}{b} \right \|$                    |
| 取整函数 （Floor function）  | \left **\lfloor** \frac{a}{b} \right **\rfloor**          | $\left \lfloor \frac{a}{b} \right \rfloor$          |
| 取顶函数 （Ceiling function) | \left **\lceil** \frac{c}{d} \right **\rceil**            | $\left \lceil \frac{c}{d} \right \rceil$            |
| 斜线与反斜线                 | \left **/** \frac{a}{b} \right **\backslash**             | $\left / \frac{a}{b} \right \backslash$             |
| 上下箭头                     | \left **\uparrow** \frac{a}{b} \right **\downarrow**      | $\left \uparrow \frac{a}{b} \right \downarrow$      |
|                              | \left **\Uparrow** \frac{a}{b} \right **\Downarrow**      | $\left \Uparrow \frac{a}{b} \right \Downarrow$      |
|                              | \left **\updownarrow** \frac{a}{b} \right**\Updownarrow** | $\left \updownarrow \frac{a}{b} \right\Updownarrow$ |
| 混合括号                     | \left [ 0,1 \right ) \left \langle \psi \right \|         | $\left [ 0,1 \right ) \left \langle \psi \right |$  |
| 单左括号                     | \left \{ \frac{a}{b} **\right .**                         | $\left \{ \frac{a}{b} \right .$                     |
| 单右括号                     | **\left .** \frac{a}{b} \right \}                         | $\left . \frac{a}{b} \right \}$                     |

备注：

- 可以使用 `\big, \Big, \bigg, \Bigg` 控制括号的大小，比如代码

`\Bigg ( \bigg [ \Big \{\big\langle \left | \| \frac{a}{b} \| \right | \big \rangle\Big\}\bigg ] \Bigg )`

　显示︰
$$
\Bigg ( \bigg [ \Big \{\big\langle \left | \| \frac{a}{b} \| \right | \big \rangle\Big\}\bigg ] \Bigg )
$$

## 希腊字母

- 拉丁字母是26个，希腊（Greek）字母是24个
- 发音即是它们各自的latex形式，
- **大写字母的是其小写latex首字母大写后的形式**，如（Δ：\Delta）
- notation: 西方的数学家们在推导数学定理时，仍然沿用并不好写也不好记的希腊字母，可见文艺复兴，可见希腊数学对后世的巨大影响。
- 注意区分Δ（发音为delta，表示增量）与∇（发音为nabla，表示微分，不属于希腊字母，只是一个记号，用来表示微分算子）
- 若要使用斜体，在`\`后面加var即可，例如 $\varGamma$ `\varGamma`、$\varepsilon$ `\varepsilon`

| 小写 | 大写 | 英语读法国际音标        | 中文发音      | latex                  | 显示                                |
| ---- | ---- | ----------------------- | ------------- | ---------------------- | ----------------------------------- |
| α    | A    | /'ælfə/                 | 阿尔法        | \alpha                 | $\alpha \Alpha$                     |
| β    | B    | /'bi:tə/                | 贝塔          | \beta                  | $\beta \Beta$                       |
| γ    | Γ    | /'gæmə/                 | 伽马          | \gamma                 | $\gamma \Gamma \varGamma$           |
| δ    | Δ    | /ˈdeltə/                | 德尔塔        | \delta                 | $\delta \Delta \varDelta$           |
| ϵ    | E    | /'epsɪlɒn/              | 艾普西隆      | \epsilon               | $\epsilon \varepsilon \Epsilon$     |
| ζ    | Z    | /'zi:tə/                | 泽塔          | \zeta                  | $\zeta \Zeta$                       |
| η    | H    | /'i:tə/                 | 伊塔          | \eta                   | $\eta \Eta $                        |
| θ    | Θ    | /'θi:tə/                | 西塔          | \theta                 | $\theta \vartheta \Theta \varTheta$ |
| ι    | I    | /aɪ'əʊtə/               | 约（yao）塔   | \iota                  | $\iota \Iota$                       |
| κ    | K    | /'kæpə/                 | 卡帕          | \kappa                 | $\kappa \varkappa \Kappa$           |
| λ    | Λ    | /'læmdə/                | 拉姆达        | \lambda                | $\lambda \Lambda \varLambda$        |
| μ    | M    | /mju:/                  | 谬            | \mu                    | $\mu \Mu$                           |
| ν    | N    | /nju:/                  | 纽            | \nu                    | $\nu \Nu$                           |
| ξ    | Ξ    | /ksaɪ/                  | 克西          | \xi                    | $\xi \Xi \varXi$                    |
| ο    | O    | /əuˈmaikrən/            | 奥米克戎      | \omicron               | $\omicron \Omicron$                 |
| π    | Π    | /paɪ/                   | 派            | \pi                    | $\pi \varpi \Pi \varPi$             |
| ρ    | P    | /rəʊ/                   | 柔            | \rho                   | $\rho \varrho \Rho$                 |
| σ    | Σ    | /'sɪɡmə/                | 西格玛        | \sigma                 | $\sigma \varsigma \Sigma \varSigma$ |
| τ    | T    | /taʊ/                   | 陶            | \tau                   | $\tau \Tau$                         |
| υ    | Υ    | /ˈipsɪlon/或 /ˈʌpsɪlɒn/ | 阿普西隆      | \upsilon               | $\upsilon \Upsilon \varUpsilon$     |
| ϕ    | Φ    | /faɪ/                   | 斐            | \phi，（φ：`\varphi`） | $\phi \varphi \Phi \varPhi$         |
| χ    | X    | /kaɪ/                   | 恺            | \chi                   | $\chi \Chi$                         |
| ψ    | Ψ    | /psai/                  | 普西          | \psi                   | $\psi \Psi \varPsi$                 |
| ω    | Ω    | /'əʊmɪɡə/               | 奥米加/欧米伽 | \omega                 | $\omega \Omega \varOmega$           |

## 花体

`\mathcal X`: $\mathcal X$

例如：$X\in \mathcal X \subseteq \bold R^n$

## 上标和下标

| 名称                                                         | 写法                                                         | 效果                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 导数点                                                       | `\dot{x}`                                                    | $\dot{x}$                                                    |
|                                                              | `\ddot{y}`                                                   | $\ddot {y}$                                                  |
| 向量                                                         | `\vec{c}`                                                    | $\vec{c}$                                                    |
|                                                              | `\overleftarrow{a b}`                                        | $\overleftarrow{a b}$                                        |
|                                                              | `\overrightarrow{c d}`                                       | $\overrightarrow{c d}$                                       |
|                                                              | `\widehat{e f g}`                                            | $\widehat{e f g}$                                            |
| 上波浪线                                                     | `\widetilde p`                                               | $\widetilde p$                                               |
| 上弧 (注: 正确应该用 \overarc, 但在这里行不通。要用建议的语法作为解决办法) | `\overset{\frown} {AB}`                                      | $\overset{\frown} {AB}$                                      |
| 上划线                                                       | `\overline{h i j}`                                           | $\overline{h i j}$                                           |
| 下划线                                                       | `\underline{k l m}`                                          | $\underline{k l m}$                                          |
| 上括号                                                       | `\overbrace{1+2+\cdots+100}`                                 | $\overbrace{1+2+\cdots+100}$                                 |
|                                                              | `\begin{matrix} 5050 \\ \overbrace{ 1+2+\cdots+100 }\end{matrix}` | $\begin{matrix} 5050 \\ \overbrace{ 1+2+\cdots+100 }\end{matrix}$ |
| 下括号                                                       | `\underbrace{a+b+\cdots+z}`                                  | $\underbrace{a+b+\cdots+z}$                                  |
|                                                              | `\begin{matrix} \underbrace{ a+b+\cdots+z } \\ 26\end{matrix}` | $\begin{matrix} \underbrace{ a+b+\cdots+z } \\ 26\end{matrix}$ |

## 分数、矩阵和多行列式

| 功能                                                  | 语法                                                         | 效果                                                         |
| :---------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| 分数                                                  | `\frac{2}{4}=0.5`                                            | $\frac{2}{4}=0.5$                                            |
| 小型分数                                              | `\tfrac{2}{4} = 0.5`                                         | $\tfrac{2}{4} = 0.5$                                         |
| 大型分数（嵌套）                                      | `\cfrac{2}{c + \cfrac{2}{d + \cfrac{2}{4}}} =a`              | $\cfrac{2}{c + \cfrac{2}{d + \cfrac{2}{4}}} =a$              |
| 大型分数（不嵌套）                                    | `\dfrac{2}{4} = 0.5 \qquad \dfrac{2}{c + \dfrac{2}{d +\dfrac{2}{4}}} = a` | $\dfrac{2}{4} = 0.5 \qquad \dfrac{2}{c + \dfrac{2}{d +\dfrac{2}{4}}} = a$ |
| [二项式](http://zh.wikipedia.org/wiki/二项式)系数     | `\dbinom{n}{r}=\binom{n}{n-r}=C^n_r=C^n_{n-r}`               | $\dbinom{n}{r}=\binom{n}{n-r}=C^n_r=C^n_{n-r}$               |
| 小型[二项式](http://zh.wikipedia.org/wiki/二项式)系数 | `\tbinom{n}{r}=\tbinom{n}{n-r}=C^n_r=C^n_{n-r}`              | $\tbinom{n}{r}=\tbinom{n}{n-r}=C^n_r=C^n_{n-r}$              |
| 大型[二项式](http://zh.wikipedia.org/wiki/二项式)系数 | `\binom{n}{r}=\dbinom{n}{n-r}=C^n_r=C^n_{n-r}`               | $\binom{n}{r}=\dbinom{n}{n-r}=C^n_r=C^n_{n-r}$               |
| 矩阵                                                  | `\begin{matrix} x & y \\ z & v \end{matrix} `                | $\begin{matrix} x & y \\ z & v \end{matrix} $                |
|                                                       | `\begin{vmatrix} x & y \\ z & v \end{vmatrix} `              | $\begin{vmatrix} x & y \\ z & v \end{vmatrix} $              |
|                                                       | `\begin{Vmatrix} x & y \\ z & v \end{Vmatrix} `              | $\begin{Vmatrix} x & y \\ z & v \end{Vmatrix} $              |
|                                                       | `\begin{bmatrix} 0      & \cdots & 0      \\ \vdots & \ddots & \vdots \\ 0      & \cdots & 0 \end{bmatrix} ` | $\begin{bmatrix} 0      & \cdots & 0      \\ \vdots & \ddots & \vdots \\ 0      & \cdots & 0 \end{bmatrix} $ |
|                                                       | `\begin{Bmatrix} x & y \\ z & v \end{Bmatrix} `              | $\begin{Bmatrix} x & y \\ z & v \end{Bmatrix} $              |
|                                                       | `\begin{pmatrix} x & y \\ z & v \end{pmatrix} `              | $\begin{pmatrix} x & y \\ z & v \end{pmatrix} $              |
|                                                       | `\bigl( \begin{smallmatrix} a&b\\ c&d \end{smallmatrix} \bigr) ` | $\bigl( \begin{smallmatrix} a&b\\ c&d \end{smallmatrix} \bigr) $ |
| 条件定义                                              | `f(n) = \begin{cases}  n/2,  & \mbox{if }n\mbox{ is even} \\ 3n+1, & \mbox{if }n\mbox{ is odd} \end{cases} ` | $f(n) = \begin{cases}  n/2,  & \mbox{if }n\mbox{ is even} \\ 3n+1, & \mbox{if }n\mbox{ is odd} \end{cases} $ |
| 多行等式                                              | `\begin{align} f(x) & = (m+n)^2 \\ & = m^2+2mn+n^2 \\ \end{align} ` | $\begin{align} f(x) & = (m+n)^2 \\ & = m^2+2mn+n^2 \\ \end{align} $ |
|                                                       | `\begin{alignat}{2} f(x) & = (m-n)^2 \\ f(x) & = (-m+n)^2 \\ & = m^2-2mn+n^2 \\ \end{alignat} ` | $\begin{alignat}{2} f(x) & = (m-n)^2 \\ f(x) & = (-m+n)^2 \\ & = m^2-2mn+n^2 \\ \end{alignat} $ |
| 多行等式（左对齐）                                    | `\begin{array}{lcl} z        & = & a \\ f(x,y,z) & = & x + y + z  \end{array} ` | $\begin{array}{lcl} z        & = & a \\ f(x,y,z) & = & x + y + z  \end{array} $ |
| 多行等式（右对齐）                                    | `\begin{array}{lcr} z        & = & a \\ f(x,y,z) & = & x + y + z     \end{array} ` | $\begin{array}{lcr} z        & = & a \\ f(x,y,z) & = & x + y + z     \end{array} $ |
| 长公式换行                                            | `<math>f(x) \,\!</math> <math>= \sum_{n=0}^\infty a_n x^n </math> <math>= a_0+a_1x+a_2x^2+\cdots</math> ` | $<math>f(x) \,\!</math>$ <br />$<math>= \sum_{n=0}^\infty a_n x^n </math>$<br /> $<math>= a_0+a_1x+a_2x^2+\cdots</math>$ |
| 方程组                                                | `\begin{cases} 3x + 5y +  z \\ 7x - 2y + 4z \\ -6x + 3y + 2z \end{cases} ` | $\begin{cases} 3x + 5y +  z \\ 7x - 2y + 4z \\ -6x + 3y + 2z \end{cases} $ |
| 数组                                                  | `\begin{array}{|c|c||c|} a & b & S \\ \hline 0&0&1\\ 0&1&1\\ 1&0&1\\ 1&1&0\\ \end{array} ` | $\begin{array}{|c|c||c|} a & b & S \\ \hline 0&0&1\\ 0&1&1\\ 1&0&1\\ 1&1&0\\ \end{array}$ |

# Letex综合运用实例

https://blog.csdn.net/happyday_d/article/details/83715440

## 分段函数

```latex
$$
f(n)=
	\begin{cases}
		n/2, & \text{if $n$ is even}\\
		3n+1,& \text{if $n$ is odd}
	\end{cases}
$$
```

$$
f(n)=
	\begin{cases}
		n/2, & \text{if $n$ is even}\\
		3n+1,& \text{if $n$ is odd}
	\end{cases}
$$

## 方程组

~~~latex
$$
\left\{
	\begin{array}{c}
		a_1x+b_1y+c_1z=d_1\\
		a_2x+b_2y+c_2z=d_2\\
		a_3x+b_3y+c_3z=d_3
	\end{array}
\right.
$$
~~~

$$
\left\{
	\begin{array}{c}
		a_1x+b_1y+c_1z=d_1\\
		a_2x+b_2y+c_2z=d_2\\
		a_3x+b_3y+c_3z=d_3
	\end{array}
\right.
$$

## 行列式

~~~latex
$$
X=\left|
	\begin{matrix}
		x_{11} & x_{12} & \cdots & x_{1d}\\
		x_{21} & x_{22} & \cdots & x_{2d}\\
		\vdots & \vdots & \ddots & \vdots \\
		x_{11} & x_{12} & \cdots & x_{1d}\\
	\end{matrix}
\right|
$$
~~~

$$
X=\left|
	\begin{matrix}
		x_{11} & x_{12} & \cdots & x_{1d}\\
		x_{21} & x_{22} & \cdots & x_{2d}\\
		\vdots & \vdots & \ddots & \vdots \\
		x_{11} & x_{12} & \cdots & x_{1d}\\
	\end{matrix}
\right|
$$

## 矩阵

~~~latex
$$
	\begin{matrix}
	1 & x & x^2\\
	1 & y & y^2\\
	1 & z & z^2\\
	\end{matrix}
$$
~~~

$$
\begin{matrix}
	1 & x & x^2\\
	1 & y & y^2\\
	1 & z & z^2\\
	\end{matrix}
$$

## 推导过程

~~~latex
$$
\begin{align}
	\frac{\partial J(\theta)}{\partial\theta_j}
	& = -\frac1m\sum_{i=0}^m(y^i - h_\theta(x^i)) \frac{\partial}{\partial\theta_j}(y^i-h_\theta(x^i))\\
	& = -\frac1m\sum_{i=0}^m(y^i-h_\theta(x^i)) \frac{\partial}{\partial\theta_j}(\sum_{j=0}^n\theta_j x^i_j-y^i)\\
	&=-\frac1m\sum_{i=0}^m(y^i -h_\theta(x^i)) x^i_j
\end{align}
$$
~~~

$$
\begin{align}
	\frac{\partial J(\theta)}{\partial\theta_j}
	& = -\frac1m\sum_{i=0}^m(y^i - h_\theta(x^i)) \frac{\partial}{\partial\theta_j}(y^i-h_\theta(x^i))\\
	& = -\frac1m\sum_{i=0}^m(y^i-h_\theta(x^i)) \frac{\partial}{\partial\theta_j}(\sum_{j=0}^n\theta_j x^i_j-y^i)\\
	&=-\frac1m\sum_{i=0}^m(y^i -h_\theta(x^i)) x^i_j
\end{align}
$$

