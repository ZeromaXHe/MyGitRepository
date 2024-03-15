# 题目

实现 [strStr()](https://baike.baidu.com/item/strstr/811469) 函数。

给定一个 haystack 字符串和一个 needle 字符串，在 haystack 字符串中找出 needle 字符串出现的第一个位置 (从0开始)。如果不存在，则返回  **-1**。

**示例 1:**

```
输入: haystack = "hello", needle = "ll"
输出: 2
```

**示例 2:**

```
输入: haystack = "aaaaa", needle = "bba"
输出: -1
```

**说明:**

当 `needle` 是空字符串时，我们应当返回什么值呢？这是一个在面试中很好的问题。

对于本题而言，当 `needle` 是空字符串时我们应当返回 0 。这与C语言的 [strstr()](https://baike.baidu.com/item/strstr/811469) 以及 Java的 [indexOf()](https://docs.oracle.com/javase/7/docs/api/java/lang/String.html#indexOf(java.lang.String)) 定义相符。

# 题解

无官方题解

直接去找java的源码，java.lang.String下面的`static int indexOf(char[] source, int sourceOffset, int sourceCount, char[] target, int targetOffset, int targetCount, int fromIndex)` 把fromIndex和两个Offset改成0，source改成haystack.toCharArray()，target改成needle.toCharArray()，然后改改就好了。

看源码中：

```java
public int indexOf(String str) {
        return indexOf(str, 0);
    }
```

```java
public int indexOf(String str, int fromIndex) {
        return indexOf(value, 0, value.length,
                str.value, 0, str.value.length, fromIndex);
    }
```

可以看出IndexOf几个参数比较简单的方法，底层实现还是依靠`static int indexOf(char[] source, int sourceOffset, int sourceCount, char[] target, int targetOffset, int targetCount, int fromIndex)`

而从下面的源码可以看出`static int indexOf(char[] source, int sourceOffset, int sourceCount, char[] target, int targetOffset, int targetCount, int fromIndex)`中并没有使用KMP算法，而是使用的最朴素的匹配方法。



执行用时 : 1 ms, 在Implement strStr()的Java提交中击败了99.89% 的用户

内存消耗 : 35.7 MB, 在Implement strStr()的Java提交中击败了85.25% 的用户

```java
class Solution {
    public int strStr(String haystack, String needle) {
        char[] source = haystack.toCharArray();
        char[] target = needle.toCharArray();
        int sourceCount = source.length;
        int targetCount = target.length;
        if (0 >= sourceCount) {
            return (targetCount == 0 ? sourceCount : -1);
        }
        
        if (targetCount == 0) {
            return 0;
        }

        char first = target[0];
        int max = sourceCount - targetCount;

        for (int i = 0; i <= max; i++) {
            /* Look for first character. */
            if (source[i] != first) {
                while (++i <= max && source[i] != first);
            }

            /* Found first character, now look at the rest of v2 */
            if (i <= max) {
                int j = i + 1;
                int end = j + targetCount - 1;
                for (int k = 1; j < end && source[j]
                        == target[k]; j++, k++);

                if (j == end) {
                    /* Found whole string. */
                    return i;
                }
            }
        }
        return -1;
    }
}
```



# 感想

学习学习Java源码还是不错的~