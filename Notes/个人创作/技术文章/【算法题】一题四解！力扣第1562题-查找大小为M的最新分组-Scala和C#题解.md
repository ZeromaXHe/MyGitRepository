今天做力扣学习计划的“二分查找基础”的时候，碰到一道有意思的题目：**[1562. 查找大小为 M 的最新分组](https://leetcode.cn/problems/find-latest-group-of-size-m/)** ，可以使用四种不同的思路（单调栈、模拟、二分查找、并查集）进行解答，非常适合学习与练习，在此给大家分享一下。

> 话说最近一直没有更新文章，主要就是因为力扣上面不小心开了好几个学习计划同时进行，一天得写十几道题，都快写吐了。不过这周估计可以全部解决掉，以后再也不这样搞了。主要都是中等和简单题，新手用来学习不错，我这样刷起来有点费时间了。（不过倒是顺便练了练 Kotlin 和 C#）
>
> 如果你要练学习计划的话，可以提醒一下，其实当天没写完也是可以的，可以后面补（如果到了时间还没写完那就不知道是否可以了），而且可以提前写后面未解锁的题目，提交通过的话，后面也是不需要重复写的。

# 1 题目

**1562. 查找大小为 M 的最新分组** 难度：中等

给你一个数组 `arr` ，该数组表示一个从 `1` 到 `n` 的数字排列。有一个长度为 `n` 的二进制字符串，该字符串上的所有位最初都设置为 `0` 。

在从 `1` 到 `n` 的每个步骤 `i` 中（假设二进制字符串和 `arr` 都是从 `1` 开始索引的情况下），二进制字符串上位于位置 `arr[i]` 的位将会设为 `1` 。

给你一个整数 `m` ，请你找出二进制字符串上存在长度为 `m` 的一组 `1` 的最后步骤。一组 `1` 是一个连续的、由 `1` 组成的子串，且左右两边不再有可以延伸的 `1` 。

返回存在长度 **恰好** 为 `m` 的 **一组** `1`  的最后步骤。如果不存在这样的步骤，请返回 `-1` 。



**示例 1**：

```
输入：arr = [3,5,1,2,4], m = 1
输出：4
解释：
步骤 1："00100"，由 1 构成的组：["1"]
步骤 2："00101"，由 1 构成的组：["1", "1"]
步骤 3："10101"，由 1 构成的组：["1", "1", "1"]
步骤 4："11101"，由 1 构成的组：["111", "1"]
步骤 5："11111"，由 1 构成的组：["11111"]
存在长度为 1 的一组 1 的最后步骤是步骤 4 。
```

**示例 2**：

```
输入：arr = [3,1,5,4,2], m = 2
输出：-1
解释：
步骤 1："00100"，由 1 构成的组：["1"]
步骤 2："10100"，由 1 构成的组：["1", "1"]
步骤 3："10101"，由 1 构成的组：["1", "1", "1"]
步骤 4："10111"，由 1 构成的组：["1", "111"]
步骤 5："11111"，由 1 构成的组：["11111"]
不管是哪一步骤都无法形成长度为 2 的一组 1 。
```

**示例 3**：

```
输入：arr = [1], m = 1
输出：1
```

**示例 4**：

```
输入：arr = [2,1], m = 2
输出：2
```



**提示**：

- `n == arr.length`
- `1 <= n <= 10^5`
- `1 <= arr[i] <= n`
- `arr` 中的所有整数 **互不相同**
- `1 <= m <= arr.length`

来源：力扣（LeetCode）
链接：https://leetcode.cn/problems/find-latest-group-of-size-m
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。



# 2 时间顺序单调栈法

首先介绍一个相对冷门的 *[单调栈的题解：https://leetcode.cn/problems/find-latest-group-of-size-m/solution/er-fen-zhen-bu-shou-huan-shi-dan-diao-zh-375g/](https://leetcode.cn/problems/find-latest-group-of-size-m/solution/er-fen-zhen-bu-shou-huan-shi-dan-diao-zh-375g/)* ，感觉这个思路确实和其他模拟思路题解相比挺新颖的，除了这一篇，基本就没有提到的了。只是原题解代码写的有点冗杂了，遮蔽了其思路主旨。我使用 Scala 一边重构了一下代码，一边理解思路，终于看懂了。感觉最后的成品代码更方便大家理解，就也分享一下吧~ （用 C# 也补了一份实现，方便熟悉 C++ 或 Java 的同学阅读）

具体思路可以参考注释，还是不懂的话，大致介绍一下：
- 首先将 arr 处理为存储对应索引的 1 的插入时间的数组 t。这里有个特殊处理的 `t[0]` 和 `t[arr.length + 1]` 取值 Int 最大值，简化后续处理。
- 然后按照时间顺序递增（对应变量 `i`，范围为 `[0, arr.length + 1]`）检查单调栈，如果栈里非空且 `t[栈顶] < t[i]` 说明在 i 左侧的 1 插入时间早于 i 处的 1，所以我们就可以把这个连接在一起的时间点算出来。我们的目的是找到最晚的一个连接长度为 m 的时间点。
- 长度就是对应 `i - 下一个栈顶 - 1`，因为下一个栈顶的右侧就是相当于当前连接的全 1 序列最左端。当长度等于 m 时我们可以计算出来目前全 1 序列首次出现的时间，即 `t[下一个栈顶], t[i] 的最小值`
- 重复以上逻辑就可以将最大的结果找出来。

看懂了就不禁感叹：“妙啊，妙啊……”，只是理解起来没有模拟始末节点数组法直观。代码如下：

**Scala**

```scala
/**
 * 执行用时：864 ms, 在所有 Scala 提交中击败了 100.00% 的用户
 * 内存消耗：82.3 MB, 在所有 Scala 提交中击败了 100.00% 的用户
 * 通过测试用例：114 / 114
 *
 * @param arr
 * @param m
 * @return
 */
def findLatestStep(arr: Array[Int], m: Int): Int = {
  // t 数组存储对应索引的 1 的插入时间
  val t = new Array[Int](arr.length + 2)
  t(0) = Int.MaxValue
  for (i <- arr.indices) {
    t(arr(i)) = i
  }
  t(arr.length + 1) = Int.MaxValue
  val stack = new scala.collection.mutable.Stack[Int]
  var ans = -1
  for (i <- t.indices) {
    if (stack.nonEmpty) {
      // 代表前面栈顶对应的 1 的插入时间比现在第 i 个位置上的 1 插入时间早
      while (t(stack.top) < t(i)) {
        stack.pop()
        // 直接弹出，使用下一个栈顶的位置（对应之前连续 1 的左端）来计算连续的 1 长度
        if (i - stack.top - 1 == m) {
          if (stack.top == 0 && i == arr.length + 1) return arr.length
          val min = math.min(t(stack.top), t(i))
          if (min != Int.MaxValue && min > ans) ans = min
        }
      }
    }
    stack.push(i)
  }
  ans
}
```
**C#**

```c#
/// <summary>
/// 执行用时：220 ms, 在所有 C# 提交中击败了 75.00% 的用户
/// 内存消耗：54.3 MB, 在所有 C# 提交中击败了 50.00% 的用户
/// 通过测试用例：114 / 114
/// </summary>
/// <param name="arr"></param>
/// <param name="m"></param>
/// <returns></returns>
public int FindLatestStep(int[] arr, int m)
{
    // t 数组存储对应索引的 1 的插入时间
    var t = new int[arr.Length + 2];
    t[0] = int.MaxValue;
    for (int i = 0; i < arr.Length; i++)
    {
        t[arr[i]] = i;
    }

    t[arr.Length + 1] = int.MaxValue;
    var stack = new Stack<int>();
    var ans = -1;
    for (int i = 0; i < t.Length; i++)
    {
        if (stack.Count > 0)
        {
            // 代表前面栈顶对应的 1 的插入时间比现在第 i 个位置上的 1 插入时间早
            while (t[stack.Peek()] < t[i])
            {
                stack.Pop();
                // 直接弹出，使用下一个栈顶的位置（对应之前连续 1 的左端）来计算连续的 1 长度
                if (i - stack.Peek() - 1 == m)
                {
                    if (stack.Peek() == 0 && i == arr.Length + 1) return arr.Length;
                    var min = Math.Min(t[stack.Peek()], t[i]);
                    if (min != int.MaxValue && min > ans) ans = min;
                }
            }
        }

        stack.Push(i);
    }

    return ans;
}
```

# 3 模拟始末节点数组法

给官方题解的方法起了一个这个名字，感觉应该比较好理解吧。具体原理可以看 *[官方题解：https://leetcode.cn/problems/find-latest-group-of-size-m/solution/cha-zhao-da-xiao-wei-m-de-zui-xin-fen-zu-by-leetco/](https://leetcode.cn/problems/find-latest-group-of-size-m/solution/cha-zhao-da-xiao-wei-m-de-zui-xin-fen-zu-by-leetco/)*，Scala 的实现的话直接看代码吧：

```Scala
/**
 * 执行用时：856 ms, 在所有 Scala 提交中击败了 100.00% 的用户
 * 内存消耗：75.5 MB, 在所有 Scala 提交中击败了 100.00% 的用户
 * 通过测试用例：114 / 114
 *
 * 参考题解做的，这里没用到二分查找，还是挺妙的
 *
 * @param arr
 * @param m
 * @return
 */
def findLatestStep(arr: Array[Int], m: Int): Int = {
  val n = arr.length
  val range = Array.fill(n + 1)(Array.fill(2)(-1))
  var count = 0
  var res = -1
  for (i <- arr.indices) {
    var l = arr(i)
    var r = arr(i)
    if (arr(i) > 1) {
      val lRange = range(l - 1)
      if (lRange(0) != -1) {
        l = lRange(0)
        if (lRange(1) - lRange(0) + 1 == m) count -= 1
      }
    }
    if (arr(i) < n) {
      val rRange = range(r + 1)
      if (rRange(0) != -1) {
        r = rRange(1)
        if (rRange(1) - rRange(0) + 1 == m) count -= 1
      }
    }
    if (r - l + 1 == m) count += 1
    if (count > 0) res = i + 1
    range(l)(0) = l
    range(r)(0) = l
    range(l)(1) = r
    range(r)(1) = r
  }
  res
}
```

# 4 题外话

这道题目我是从“二分查找基础”的学习计划过来的，但是包括官方题解在内的大多数题解没用到二分查找，真是笑死……

顺便提一下，其实是有**二分查找**的思路的，具体来说就是对应这篇 *[Java用到了TreeSet的题解：https://leetcode.cn/problems/find-latest-group-of-size-m/solution/fan-xiang-qjing-wei-shen-sui-ran-wo-yun-xing-shi-j/](https://leetcode.cn/problems/find-latest-group-of-size-m/solution/fan-xiang-qjing-wei-shen-sui-ran-wo-yun-xing-shi-j/)* 以及这篇 *[C++用到了set的题解：https://leetcode.cn/problems/find-latest-group-of-size-m/solution/zheng-xiang-si-wei-by-sui-xin-yuan-oaiv/](https://leetcode.cn/problems/find-latest-group-of-size-m/solution/zheng-xiang-si-wei-by-sui-xin-yuan-oaiv/)* ，逆向从全 1 的时间往回查的思路也还是挺妙的。我就先懒得自己用 Scala 试了，看懂单调栈的那篇原题解耗费太多脑细胞，让我缓缓。（笑）

另外，其实**并查集**显然也可以做，合并集合（全为 1 的序列）并计数统计集合大小，典型并查集题目嘛。并查集不清楚的话，可以参考上面 [C++二分的那篇题解](https://leetcode.cn/problems/find-latest-group-of-size-m/solution/zheng-xiang-si-wei-by-sui-xin-yuan-oaiv/)，也提到了并查集。（其实我自己首先想到就是这个思路，但自己是二分查找进来的，就感觉套并查集套模板有点没意思了，后来就看题解去看二分咋写了。看到逆向基本就懂了二分是啥思路，就感觉没啥必要自己写了，就去学习前面分享的这两种写法了）

顺便分享一下自己简单的并查集的 Java、Scala、Kotlin 模板吧，套起来用还是很方便的：

**Java**

```java
public class UnionSet {
    /**
     * 当前结点的父亲结点
     */
    private int[] parent;
    /**
     * 以当前结点为根结点的子树的结点总数
     */
    private int[] size;

    public UnionSet(int n) {
        parent = new int[n];
        size = new int[n];
        for (int i = 0; i < n; i++) {
            parent[i] = i;
            size[i] = 1;
        }
    }

    /**
     * 路径压缩，只要求每个不相交集合的「根结点」的子树包含的结点总数数值正确即可，因此在路径压缩的过程中不用维护数组 size
     *
     * @param x
     * @return
     */
    public int find(int x) {
        if (x != parent[x]) parent[x] = find(parent[x]);
        return parent[x];
    }

    public void union(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        if (rootX == rootY) return;
        parent[rootX] = rootY;
        // 在合并的时候维护数组 size
        size[rootY] += size[rootX];
    }

    /**
     * @param x
     * @return x 在并查集的根结点的子树包含的结点总数
     */
    public int getSize(int x) {
        int root = find(x);
        return size[root];
    }
}
```
**Scala**

```scala
class UnionSet(n: Int) {
  private val parent = new Array[Int](n)
  private val size = Array.fill(n)(1)

  for (i <- 0 until n) {
    parent(i) = i
  }

  def find(x: Int): Int = {
    if (x != parent(x)) parent(x) = find(parent(x))
    parent(x)
  }

  def union(x: Int, y: Int): Unit = {
    val rootX = find(x)
    val rootY = find(y)
    if (rootX == rootY) return
    val big = if (size(rootX) < size(rootY)) rootY else rootX
    val small = if (size(rootX) < size(rootY)) rootX else rootY
    parent(small) = big
    size(big) += size(small)
  }

  def getSize(x: Int): Int = {
    size(find(x))
  }
}
```

**Kotlin**

```kotlin
class UnionSet(n: Int) {
    /**
     * 当前结点的父亲结点
     */
    private val parent = IntArray(n) { i -> i }

    /**
      * 以当前结点为根结点的子树的结点总数
      */
    private val size = IntArray(n) { 1 }

    /**
     * 路径压缩，只要求每个不相交集合的「根结点」的子树包含的结点总数数值正确即可，因此在路径压缩的过程中不用维护数组 size
     *
     * @param x
     * @return
     */
    fun find(x: Int): Int {
        if (x != parent[x]) parent[x] = find(parent[x])
        return parent[x]
    }

    fun union(x: Int, y: Int) {
        val rootX = find(x)
        val rootY = find(y)
        if (rootX == rootY) return
        parent[rootX] = rootY
        // 在合并的时候维护数组 size
        size[rootY] += size[rootX]
    }

    /**
      * @param x
      * @return x 在并查集的根结点的子树包含的结点总数
      */
    fun getSize(x: Int): Int {
        val root = find(x)
        return size[root]
    }
}
```

