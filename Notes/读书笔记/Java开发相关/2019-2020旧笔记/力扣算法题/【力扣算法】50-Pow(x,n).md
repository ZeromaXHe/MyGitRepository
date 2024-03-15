# 题目



# 题解

## 方法 1：蛮力

### 直观想法

直接模拟该过程，将 x 连乘 n 次。

如果 n < 0n<0，我们可以用$\dfrac{1}{x}$, -n 代替 x, n 来保证 $n \ge 0$ 。这个限制可以简化我们下面的讨论。

但是我们仍需关注边界条件，尤其是正整数和负整数的不同范围限制。

### 算法

我们使用一个直接的循环来计算结果。

~~~java
class Solution {
    public double myPow(double x, int n) {
        long N = n;
        if (N < 0) {
            x = 1 / x;
            N = -N;
        }
        double ans = 1;
        for (long i = 0; i < N; i++)
            ans = ans * x;
        return ans;
    }
};
~~~
### 复杂度分析

时间复杂度：O(n). 我们需要将 x 连乘 n 次。

空间复杂度：O(1). 我们只需要一个变量来保存最终 x 的连乘结果。 

## 方法2：快速幂算法（递归）

### 直观想法

假定我们已经得到了 $x ^ n$ 的结果，我们如何得到 $x ^ {2 * n}$ 的结果？很明显，我们不需要将 x 再乘 n 次。使用公式 $(x ^ n) ^ 2 = x ^ {2 * n}$，我们可以在一次计算内得到 $x ^ {2 * n}$  的值。使用该优化方法，我们可以降低算法的时间复杂度。

### 算法

假定我们已经得到了 $x ^ {n / 2}$  的结果，并且我们现在想得到 $x ^ n$ 的结果。我们令 A 是 $x ^ {n / 2}$ 的结果，我们可以根据 n 的奇偶性来分别讨论 $x ^ n$ 的值。如果 n 为偶数，我们可以用公式 $(x ^ n) ^ 2 = x ^ {2 * n}$ 来得到 $x ^ n = A * A$ 。如果 n 为奇数，那么 $A * A = x ^ {n - 1}$。直观上看，我们需要再乘一次 x ，即 $x ^ n = A * A * x$。该方法可以很方便的使用递归实现。我们称这种方法为 "快速幂"，因为我们只需最多 $O(\log n)$ 次运算来得到 $x ^ n$ 。

~~~java
class Solution {
    private double fastPow(double x, long n) {
        if (n == 0) {
            return 1.0;
        }
        double half = fastPow(x, n / 2);
        if (n % 2 == 0) {
            return half * half;
        } else {
            return half * half * x;
        }
    }
    public double myPow(double x, int n) {
        long N = n;
        if (N < 0) {
            x = 1 / x;
            N = -N;
        }

        return fastPow(x, N);
    }
};
~~~
### 复杂度分析

时间复杂度：$O(\log n)$. 每一次我们使用公式 $(x ^ n) ^ 2 = x ^ {2 * n}$
 , n 都变为原来的一半。因此我们需要至多 $O(\log n)$ 次操作来得到结果。

空间复杂度：$O(\log n)$. 每一次计算，我们需要存储 $x ^ {n / 2}$  的结果。 我们需要计算 $O(\log n)$ 次，所以空间复杂度为 $O(\log n)$ 。



## 方法 3：快速幂算法（循环）

### 直观想法

使用公式 $x ^ {a + b} = x ^ a * x ^ b$，我们可以将 n 看做一系列正整数之和，$n = \sum_i b_i$ 。如果我们可以很快得到 $x ^ {b_i}$ 的结果，计算 $x ^ n$  的总时间将被降低。

### 算法

我们可以使用 n 的二进制表示来更好的理解该问题。使 n 的二进制从最低位 (LSB) 到最高位 (MSB) 表示为$b_1, b_2, ..., b_{length\_limit}$  。对于第 i 位为，如果 $b_i = 1$，意味着我们需要将结果累乘上 $x ^ {2 ^ i}$。

这似乎不能有效率上的提升，因为 $\sum_i b_i * 2 ^ i = n$ 。但是使用上面提到的公式 $(x ^ n) ^ 2 = x ^ {2 * n}$ ，我们可以进行改进。初始化 $x ^ 1 = x$ ，对于每一个 $ i > 1$ ，我们可以在一步操作中使用 $x ^ {2 ^ {i - 1}}$ 来得到 $x ^ {2 ^ i}$ 。由于 $b_i$  的个数最多为 $O(\log n)$ ，我们可以在 $O(\log n)$ 的时间内得到所有的 $x ^ {2 ^ i}$ 。在那之后，对于所有满足 $b_i = 1$ 的 i，我们可以用结果累乘 $x ^ {2 ^ i}$ 。这也只需要 $O(\log n)$ 的时间。

使用快速幂的递归或循环方法是采用不同的方式但是实现了同样的目标。对于更多快速幂方法的介绍，可以查阅相关资料。

~~~java
class Solution {
    public double myPow(double x, int n) {
        long N = n;
        if (N < 0) {
            x = 1 / x;
            N = -N;
        }
        double ans = 1;
        double current_product = x;
        for (long i = N; i > 0; i /= 2) {
            if ((i % 2) == 1) {
                ans = ans * current_product;
            }
            current_product = current_product * current_product;
        }
        return ans;
    }
};
~~~
复杂度分析

时间复杂度：$O(\log n)$. 对每一个 n 的二进制位表示，我们都至多需要累乘 1 次，所以总的时间复杂度为 $O(\log n)$ 。
空间复杂的：O(1). 我们只需要用到 2 个变量来保存当前的乘积和最终的结果 x 。

作者：LeetCode
链接：https://leetcode-cn.com/problems/two-sum/solution/powx-n-by-leetcode/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

# 感想

一开始自己倒是直接就想到了题解的最后一个方法，就是感觉代码比较难写（自己没想到边算边加，而是打算先跑一遍算出2进制的各个1的位置然后再加），有点蠢了。