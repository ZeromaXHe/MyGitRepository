# Typora 页内跳转

先定义要跳转的锚点
~~~markdown
 <span id = "anchor">锚点</span>
~~~
注: id是您随意取的,当然必须是唯一的.

跳转链接处这样写
~~~markdown
[锚点](#anchor)
~~~
注: []内是要填转的按钮显示的文字,小括号内#后面是跟的id值.因为跳转是根据id跳的.