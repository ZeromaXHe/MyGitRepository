#  int.class、Integer.TYPE 与 Integer.class

来源：https://blog.csdn.net/czh500/article/details/83759242

今天在看JDK中Integer.java的源码时,发现Integer.TYPE这么一个东西

~~~java
public static final Class TYPE = (Class ) Class.getPrimitiveClass("int");
~~~
 
根据JDK文档的描述,Class.getPrimitiveClass("int") 方法返回的是int类型的Class对象,可能很多人会疑惑,int不是基本数据类型吗?为什么还有Class对象啊?

然后在网上搜寻一番之后,总结一下搜寻的结果:

有9个预先定义好的Class对象代表8个基本类型和void,它们被java虚拟机创建,和基本类型有相同的名字boolean, byte, char, short, int, long, float, and double.

这8个基本类型的Class对象可以通过java.lang.Boolean.TYPE, java.lang.Integer.TYPE等来访问, 同样可以通过int.class,boolean.class等来访问.

int.class与Integer.TYPE是等价的,但是与Integer.class是不相等的,int.class指的是int的Class对象,Integer.class是Integer的Class的类对象. 
~~~java
public class IntClasses {
    public static void main(String[] args) {
        Class a = int.class;
        Class b = Integer.TYPE;
        Class c = Integer.class;
        System.out.println(System.identityHashCode(a));
        System.out.println(System.identityHashCode(b));
        System.out.println(System.identityHashCode(c));
    }
}
~~~
结果为:

~~~
366712642
366712642
1829164700
~~~
通过结果可以知道 第1,2行输出永远相等,并且和第3行的输出不同.

# str.matches(String regex) str中的\n无法被regex中的.匹配

今天在做正则匹配的时候，遇到了一个问题
~~~java
System.out.println("\n".matches(".*"));
~~~
这个输出的结果会是false，因为直接使用String.matches(String regex)的话，源码就是对应的是：
~~~java
// String类源码
public boolean matches(String regex) {
    return Pattern.matches(regex, this);
}
~~~
进一步点进去就是：
~~~java
// Pattern类源码
public static boolean matches(String regex, CharSequence input) {
    Pattern p = Pattern.compile(regex);
    Matcher m = p.matcher(input);
    return m.matches();
}
~~~
这里原规则使用：
~~~java
Pattern pattern = Pattern.compile(regex);
Matcher matcher = pattern.matcher(str);
return matcher.matches();
~~~
正常情况下不会匹配\r\n，需要将`Pattern.compile(regex);`改为`Pattern.compile(regex,Pattern.CASE_INSENSITIVE | Pattern.DOTALL);`
如下:
~~~java
Pattern pattern = Pattern.compile(regex,Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
Matcher matcher = pattern.matcher(str);
return matcher.matches();
~~~
测试后正常运行