# 导航表

| key          | value                                            |
| ------------ | ------------------------------------------------ |
| **题目**     | 为什么从 Java 9 开始 String 基于 byte 数组实现？ |
| **同义题目** | （暂无）                                         |
| **主题**     | Java                                             |
| **上推问题** | （暂无）                                         |
| **平行问题** | （暂无）                                         |
| **下切问题** | （暂无）                                         |

该改动对应于 [JEP 254：紧凑字符串](http://openjdk.java.net/jeps/254)

# 1. 为什么有这个改动？char -> byte

主要还是节省空间。

JDK9 之前的库的 String 类的实现使用了 char 数组来存放字符串，char 占用16位，即两字节。

```csharp
private final char value[];
```

这种情况下，如果我们要存储字符A，则为`0x00 0x41`，此时前面的一个字节空间浪费了。但如果保存中文字符则不存在浪费的情况，也就是说如果保存 `ISO-8859-1`（即 `Latin-1`）编码内的字符则浪费，之外的字符则不会浪费。

而 JDK9 后 String 类的实现使用了 byte 数组存放字符串，每个 byte 占用8位，即1字节。

```java
private final byte[] value;
```


但是如果遇到 `ISO-8859-1` 编码外的字符串呢？比如中文咋办？

# 2. Java9 之后 String 的新属性，coder 编码格式

Java String 的演进:

| 版本       | 成员变量                    |
| ---------- | --------------------------- |
| Java 6     | char[]、hash、offset、count |
| Java 7 / 8 | char[]、hash                |
| Java 9     | byte[]、hash、coder         |



```java
private final byte coder;
static final boolean COMPACT_STRINGS;
static {
    COMPACT_STRINGS = true;
}
byte coder() {
    return COMPACT_STRINGS ? coder : UTF16;
}
@Native static final byte LATIN1 = 0;
@Native static final byte UTF16  = 1;
```

coder 是编码格式的标识，在计算字符串长度或者调用 `indexOf()` 函数时，需要根据这个字段，判断如何计算字符串长度。

coder 属性默认有 0 和 1 两个值。如果 String判断字符串只包含了 `Latin-1`，则 coder 属性值为 0 ，反之则为 1

- 0 代表 Latin-1（单字节编码）
- 1 代表 UTF-16 编码。

Java9 默认打开 `COMPACT_STRINGS`, 而如果想要取消紧凑的布局可以通过配置 VM 参数 `-XX:-CompactStrings` 实现。

## 2.1 压缩后的长度处理

**JDK 8**

```java
public int length() {
    return value.length;
}
```
直接返回的 char 数组的长度

**JDK 9**

```java
public int length() {
    return value.length >> coder();
}
```
将 byte 数组的长度向右位移 `coder()`。

我们可以看到 `coder()` 返回的值，如果是 LATIN-1 就是右移 0 位，如果是 UTF-16 就右移 1 位，这样就能返回正确的字符串长度，默认的 COMPACT_STRINGS 是开启的，因为在静态域里面优先于类加载。

# 3. 用了 byte 后的连锁反应

由于 byte 数组的使用方式，引申出了两个类 StringLatin1 和 StringUTF16 两个类，分担 String 类的操作，包括 StingBuilder 等，跟 String 有关的都得到了这方面的优化

# 参考文档

- [Java9 后String 为什么使用byte[]而不是char?](https://www.jianshu.com/p/9043243df546)
- [JAVA9 String新特性，说说你不知道的东西](https://blog.csdn.net/qq_41376740/article/details/80143215)