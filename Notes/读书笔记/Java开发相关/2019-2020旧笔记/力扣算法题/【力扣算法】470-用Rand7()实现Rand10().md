# 题目

已有方法 `rand7` 可生成 1 到 7 范围内的均匀随机整数，试写一个方法 `rand10` 生成 1 到 10 范围内的均匀随机整数。

不要使用系统的 `Math.random()` 方法。

**示例 1:**

```
输入: 1
输出: [7]
```

**示例 2:**

```
输入: 2
输出: [8,4]
```

**示例 3:**

```
输入: 3
输出: [8,1,10]
```

 

**提示:**

1. `rand7` 已定义。
2. 传入参数: `n` 表示 `rand10` 的调用次数。

 

**进阶:**

1. `rand7()`调用次数的 [期望值](https://en.wikipedia.org/wiki/Expected_value) 是多少 ?
2. 你能否尽量少调用 `rand7()` ?

# 题解

无官方题解

# 感想

自己倒是想到了怎么去解这道题，大致就是说去用多个叠加后让其概率从1\~7的均匀分布转化为1\~10的均匀分布。但是具体的实现自己折腾了很久，一开始想的是用乘法，累进地用10次rand7()，然后取除10的余数。后来发现这样并不能均匀，要这样用这样的思路，也应该是累加rand7()-1五次然后取余。

执行用时 : 16 ms, 在Implement Rand10() Using Rand7()的Java提交中击败了19.19% 的用户

内存消耗 : 43.9 MB, 在Implement Rand10() Using Rand7()的Java提交中击败了53.57% 的用户

```java
/**
 * The rand7() API is already defined in the parent class SolBase.
 * public int rand7();
 * @return a random integer in the range 1 to 7
 */
class Solution extends SolBase {
    public int rand10() {
        int sum = 0;
        for(int i=0;i<5;i++)
            sum+=rand7()-1;
        return sum%10+1;
    }
}
```

之前这个方法用了五次rand7()，感觉还是太多了，后来看到[评论区大佬的方法](https://leetcode-cn.com/problems/implement-rand10-using-rand7/comments/5024),感觉还是比较6的:

执行用时 : 10 ms, 在Implement Rand10() Using Rand7()的Java提交中击败了78.79% 的用户

内存消耗 : 43.7 MB, 在Implement Rand10() Using Rand7()的Java提交中击败了69.05% 的用户

```java
/**
 * The rand7() API is already defined in the parent class SolBase.
 * public int rand7();
 * @return a random integer in the range 1 to 7
 */
class Solution extends SolBase {
    public int rand10() {
        int a=rand7();  
        int b=rand7();
        
        if(a>4&&b<4)  return rand10();
        else          return (a+b)%10+1;
    }
}
```

类似的还有rand7()*7+rand7(),然后当它大于40的时候重新算，其他时候%10+1返回。这两种方法都是有9/49的概率递归，所以感觉效率差不多吧。