最近因为在学 Scala，所以又重新开始在力扣上打打周赛，一边练习练习。今天的周赛题目感觉还挺简单的，用 Scala 基本可以用 filter-map-reduce 的链式操作 API 在几行内搞定，所以分享一下。（以下所有题目原题版权归力扣所有，贴出来只是方便读者阅读。题目来源：https://leetcode.cn/contest/weekly-contest-302）

# 6120. 数组能形成多少数对

首先是第一题简单难度的 **6120. 数组能形成多少数对**。

题目如下：

> 给你一个下标从 **0** 开始的整数数组 `nums` 。在一步操作中，你可以执行以下步骤：
>
> - 从 `nums` 选出 **两个** **相等的** 整数
> - 从 `nums` 中移除这两个整数，形成一个 **数对**
>
> 请你在 `nums` 上多次执行此操作直到无法继续执行。
>
> 返回一个下标从 **0** 开始、长度为 `2` 的整数数组 `answer` 作为答案，其中 `answer[0]` 是形成的数对数目，`answer[1]` 是对 `nums` 尽可能执行上述操作后剩下的整数数目。
>
> **示例 1：**
>
> ```
> 输入：nums = [1,3,2,1,3,2,2]
> 输出：[3,1]
> 解释：
> nums[0] 和 nums[3] 形成一个数对，并从 nums 中移除，nums = [3,2,3,2,2] 。
> nums[0] 和 nums[2] 形成一个数对，并从 nums 中移除，nums = [2,2,2] 。
> nums[0] 和 nums[1] 形成一个数对，并从 nums 中移除，nums = [2] 。
> 无法形成更多数对。总共形成 3 个数对，nums 中剩下 1 个数字。
> ```
>
> **示例 2：**
>
> ```
> 输入：nums = [1,1]
> 输出：[1,0]
> 解释：nums[0] 和 nums[1] 形成一个数对，并从 nums 中移除，nums = [] 。
> 无法形成更多数对。总共形成 1 个数对，nums 中剩下 0 个数字。
> ```
>
> **示例 3：**
>
> ```
> 输入：nums = [0]
> 输出：[0,1]
> 解释：无法形成数对，nums 中剩下 1 个数字。
> ```
>
> **提示：**
>
> - `1 <= nums.length <= 100`
> - `0 <= nums[i] <= 100`

## 解题思路

遍历数组，把同一大小的数字数出有多少个，然后将这些个数除以2的商和余数求和即可

## 通过代码

不考虑为了阅读方便而添加的换行符的话，等效于一行搞定……

```scala
/**
 * 6120. 数组能形成多少数对 | 难度：简单
 *
 * @param nums
 * @return
 */
def numberOfPairs(nums: Array[Int]): Array[Int] = {
  nums.groupBy(identity)
    .values
    .map(arr => Array(arr.length / 2, arr.length % 2))
    .reduce((sum, a) => Array(sum(0) + a(0), sum(1) + a(1)))
}
```



# 6164. 数位和相等数对的最大和

第二题是中等难度的 **6164. 数位和相等数对的最大和**

## 题目

> 给你一个下标从 **0** 开始的数组 `nums` ，数组中的元素都是 **正** 整数。请你选出两个下标 `i` 和 `j`（`i != j`），且 `nums[i]` 的数位和 与 `nums[j]` 的数位和相等。
>
> 请你找出所有满足条件的下标 `i` 和 `j` ，找出并返回 `nums[i] + nums[j]` 可以得到的 **最大值** *。*
>
> **示例 1：**
>
> ```
> 输入：nums = [18,43,36,13,7]
> 输出：54
> 解释：满足条件的数对 (i, j) 为：
> - (0, 2) ，两个数字的数位和都是 9 ，相加得到 18 + 36 = 54 。
> - (1, 4) ，两个数字的数位和都是 7 ，相加得到 43 + 7 = 50 。
> 所以可以获得的最大和是 54 。
> ```
>
> **示例 2：**
>
> ```
> 输入：nums = [10,12,19,14]
> 输出：-1
> 解释：不存在满足条件的数对，返回 -1 。
> ```
>
> **提示：**
>
> - `1 <= nums.length <= 105`
> - `1 <= nums[i] <= 109`

## 解题思路

1. 先求出每个数组元素的数位和
2. 再将数位和相等的元素组成相应的集合（这里如果集合大小均小于 2，即找不到相等数对的话，直接返回 -1）
3. 在各个集合内中找到最大的两个数求和，即得到每个集合的最大和
4. 各个集合的最大和再一起找到最大值就是题目要找到的解了

## 通过代码

```scala
/**
 * 6164. 数位和相等数对的最大和 | 难度：中等
 *
 * @param nums
 * @return
 */
def maximumSum(nums: Array[Int]): Int = {
  val map = nums.groupBy(sumDigit).filter(_._2.length >= 2)
  if (map.isEmpty) -1
  else map.values.map(_.sorted).map(arr => arr(arr.length - 1) + arr(arr.length - 2)).max
}

private def sumDigit(num: Int) = num.toString.map(_ - '0').sum
```

`sumDigit` 的实现不想使用 toString 的话（效率较低）可以换成 while 循环的实现：

```scala
private def sumDigit_while(num: Int) = {
  var n = num
  var sum = 0
  while (n > 0) {
    sum += n % 10
    n /= 10
  }
  sum
}
```



# 6121. 裁剪数字后查询第 K 小的数字

第三题是中等难度的 **6121. 裁剪数字后查询第 K 小的数字**

## 题目

> 给你一个下标从 **0** 开始的字符串数组 `nums` ，其中每个字符串 **长度相等** 且只包含数字。
>
> 再给你一个下标从 **0** 开始的二维整数数组 `queries` ，其中 `queries[i] = [ki, trimi]` 。对于每个 `queries[i]` ，你需要：
>
> - 将 `nums` 中每个数字 **裁剪** 到剩下 **最右边** `trimi` 个数位。
> - 在裁剪过后的数字中，找到 `nums` 中第 `ki` 小数字对应的 **下标** 。如果两个裁剪后数字一样大，那么下标 **更小** 的数字视为更小的数字。
> - 将 `nums` 中每个数字恢复到原本字符串。
>
> 请你返回一个长度与 `queries` 相等的数组 `answer`，其中 `answer[i]`是第 `i` 次查询的结果。
>
> **提示：**
>
> - 裁剪到剩下 `x` 个数位的意思是不断删除最左边的数位，直到剩下 `x` 个数位。
> - `nums` 中的字符串可能会有前导 0 。
>
> **示例 1：**
>
> ```
> 输入：nums = ["102","473","251","814"], queries = [[1,1],[2,3],[4,2],[1,2]]
> 输出：[2,2,1,0]
> 解释：
> 1. 裁剪到只剩 1 个数位后，nums = ["2","3","1","4"] 。最小的数字是 1 ，下标为 2 。
> 2. 裁剪到剩 3 个数位后，nums 没有变化。第 2 小的数字是 251 ，下标为 2 。
> 3. 裁剪到剩 2 个数位后，nums = ["02","73","51","14"] 。第 4 小的数字是 73 ，下标为 1 。
> 4. 裁剪到剩 2 个数位后，最小数字是 2 ，下标为 0 。
>    注意，裁剪后数字 "02" 值为 2 。
> ```
>
> **示例 2：**
>
> ```
> 输入：nums = ["24","37","96","04"], queries = [[2,1],[2,2]]
> 输出：[3,0]
> 解释：
> 1. 裁剪到剩 1 个数位，nums = ["4","7","6","4"] 。第 2 小的数字是 4 ，下标为 3 。
>    有两个 4 ，下标为 0 的 4 视为小于下标为 3 的 4 。
> 2. 裁剪到剩 2 个数位，nums 不变。第二小的数字是 24 ，下标为 0 。
> ```
>
> **提示：**
>
> - `1 <= nums.length <= 100`
> - `1 <= nums[i].length <= 100`
> - `nums[i]` 只包含数字。
> - 所有 `nums[i].length` 的长度 **相同** 。
> - `1 <= queries.length <= 100`
> - `queries[i].length == 2`
> - `1 <= ki <= nums.length`
> - `1 <= trimi <= nums[0].length`

## 解题思路

周赛的时候，看题目一开始没看懂，看了老半天…… 其实题目不难。

其实题目意思就是对于每一个 `queries` 数组里面的元素（我们后续称元素为 `arr`, 对应结构为 `Array(arr(0), arr(1))`） 对应一次查询，需要对 `nums` 数组执行**操作**，然后把操作的结果按照 `queries` 的顺序返回。

而上面所说的操作，其实就是对于 `nums` 数组的每一个元素，取它的后 `arr(1)` 位，然后找到第 `arr(0)` 小（注意这里是从 1 开始的，因为这个我错误提交了一次）的数的索引，返回即可

## 通过代码

还是相当于一行秒了……

```scala
/**
 * 6121. 裁剪数字后查询第 K 小的数字 | 难度：中等
 *
 * @param nums
 * @param queries
 * @return
 */
def smallestTrimmedNumbers(nums: Array[String], queries: Array[Array[Int]]): Array[Int] = {
  queries.map(arr => nums.map(str => str.substring(str.length - arr(1)))
              .zipWithIndex
              .sortBy(_._1).map(_._2)
              .apply(arr(0) - 1))
}
```



# 6122. 使数组可以被整除的最少删除次数

最后一题是困难难度的 **6122. 使数组可以被整除的最少删除次数**

## 题目

> 给你两个正整数数组 `nums` 和 `numsDivide` 。你可以从 `nums` 中删除任意数目的元素。
>
> 请你返回使 `nums` 中 **最小** 元素可以整除 `numsDivide` 中所有元素的 **最少** 删除次数。如果无法得到这样的元素，返回 `-1` 。
>
> 如果 `y % x == 0` ，那么我们说整数 `x` 整除 `y` 。
>
> **示例 1：**
>
> ```
> 输入：nums = [2,3,2,4,3], numsDivide = [9,6,9,3,15]
> 输出：2
> 解释：
> [2,3,2,4,3] 中最小元素是 2 ，它无法整除 numsDivide 中所有元素。
> 我们从 nums 中删除 2 个大小为 2 的元素，得到 nums = [3,4,3] 。
> [3,4,3] 中最小元素为 3 ，它可以整除 numsDivide 中所有元素。
> 可以证明 2 是最少删除次数。
> ```
>
> **示例 2：**
>
> ```
> 输入：nums = [4,3,6], numsDivide = [8,2,6,10]
> 输出：-1
> 解释：
> 我们想 nums 中的最小元素可以整除 numsDivide 中的所有元素。
> 没有任何办法可以达到这一目的。
> ```
>
> **提示：**
>
> - `1 <= nums.length, numsDivide.length <= 105`
> - `1 <= nums[i], numsDivide[i] <= 109`

## 解题思路

1. 求出 `numsDivide` 所有元素的最大公约数（greatest common divisor，简写为 gcd）。这是可以整除 `numsDivide` 所有元素的最大值。
2. 将 `nums` 中小于等于最大公约数的数字排序，从小到大寻找可以整除最大公约数的数字（如果可以整除最大公约数，即可整除所有 `numsDivide` 的元素）
3. 如果找到，返回相应的未过滤未排序的原数组索引，否则返回 -1

## 通过代码

```scala
/**
 * 6122. 使数组可以被整除的最少删除次数 | 难度：困难
 *
 * @param nums
 * @param numsDivide
 * @return
 */
def minOperations(nums: Array[Int], numsDivide: Array[Int]): Int = {
  val gcdRes = gcd(numsDivide)
  nums.filter(_ <= gcdRes).sorted.zipWithIndex.find(gcdRes % _._1 == 0).getOrElse((-1, -1))._2
}

private def gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)

private def gcd(arr: Array[Int]): Int = arr.reduce((res, next) => gcd(res, next))
```

代码中 `gcd(arr: Array[Int])` 方法按 while 循环迭代可以写成：

```scala
private def gcd_while(arr: Array[Int]): Int = {
  var res = arr(0)
  for (i <- 0 until (arr.length - 1)) {
    var tmp = 0
    while (arr(i + 1) != 0) {
      tmp = arr(i + 1)
      arr(i + 1) = res % arr(i + 1)
      res = tmp
    }
  }
  res
}
```

可以看出，递归的写法简洁很多。

# 总结

可以看出，使用 filter-map-reduce 的链式操作的方式编写代码，可以大大减轻我们的书写量，让我们的编程重点放在算法本身而不是编写繁复的 for、while 循环的具体逻辑上。对于主要逻辑都是集中于遍历操作内，不涉及一些高级数据结构或算法的题目，这种处理方式往往可以在几行之内把问题解决。

顺便贴一道这周刷题做的一道简单题 **[剑指 Offer 06. 从尾到头打印链表](https://leetcode.cn/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof/)** 的代码，也可以展示出 Scala 链式操作结合 Stream 的方便简洁

```scala
/**
 * 单链表的定义：
 * class ListNode(var _x: Int = 0) {
 *   var next: ListNode = null
 *   var x: Int = _x
 * }
 *
 * @param head
 * @return
 */
def reversePrint(head: ListNode): Array[Int] = {
  (Stream.iterate(head)(_.next) takeWhile (_ != null)).map(_.x).reverse.toArray
}
```

这里也顺便吐槽一下，有些人习惯于写 Java、Scala 的时候用 for、while 循环，这本无可厚非。但是动不动就是链式操作 API 可读性差，不得不说那就是不学无术还自欺欺人了。硬要说缺点，那 Stream 确实也有它的缺点 —— 运行时间相对较慢（但其实并没有像有些人说的那样慢特别多，网上很多自己测试的微基准测试代码不写预热测试的我也是醉了），以及无法运行调试（好像最近看到有文章说最近的 IDEA 版本已经有相应功能了，不过我还没有试过）。但这些就是属于你了解它的优缺点后再来取舍使用范围的考虑了。还没有了解过就固步自封，我个人觉得这种态度是不可取的。

单就力扣刷题而言，链式操作就展现出了它优秀的一面，耗时差不多，而书写简洁不少。这在周赛的限时环境下就更显重要了。这次因为题目相对容易，所以也是我用 Scala 做力扣周赛以来第一次四道题全部完成（之前参加过三次）。如果之前没学习过链式操作的读者，希望我这篇文章能让你对 Scala 链式操作的编程有所兴趣。了解的话，希望能有所帮助。谢谢大家~

（对于 Java 的链式操作感兴趣的话，可以阅读**《Java 8 实战》**一书，了解相关的 Stream API）



![GitHub](https://img.shields.io/badge/GitHub-ZeromaXHe-lightgrey?style=flat-square&logo=GitHub)![Gitee](https://img.shields.io/badge/Gitee-zeromax-red?style=flat-square&logo=Gitee)![LeetCodeCN](https://img.shields.io/badge/LeetCodeCN-ZeromaX-orange?style=flat-square&logo=LeetCode)![Weixin](https://img.shields.io/badge/%E5%85%AC%E4%BC%97%E5%8F%B7-ZeromaX%E8%A8%B8%E7%9A%84%E6%97%A5%E5%B8%B8-brightgreen?style=flat-square&logo=WeChat)![Zhihu](https://img.shields.io/badge/%E7%9F%A5%E4%B9%8E-maX%20Zero-blue?style=flat-square&logo=Zhihu)![Bilibili](https://img.shields.io/badge/Bilibili-ZeromaX%E8%A8%B8-lightblue?style=flat-square&logo=Bilibili)![CSDN](https://img.shields.io/badge/CSDN-SquareSquareHe-red?style=flat-square)