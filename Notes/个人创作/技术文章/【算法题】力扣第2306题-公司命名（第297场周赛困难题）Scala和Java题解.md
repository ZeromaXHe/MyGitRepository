# 1 题目

题目来源于力扣第 297 场周赛的困难题，**2306. 公司命名**：

> 给你一个字符串数组 `ideas` 表示在公司命名过程中使用的名字列表。公司命名流程如下：
>
> 1. 从 `ideas` 中选择 2 个 **不同** 名字，称为 `ideaA` 和 `ideaB` 。
> 2. 交换 `ideaA` 和 `ideaB` 的首字母。
> 3. 如果得到的两个新名字 **都** 不在 `ideas` 中，那么 `ideaA ideaB`（**串联** `ideaA` 和 `ideaB` ，中间用一个空格分隔）是一个有效的公司名字。
> 4. 否则，不是一个有效的名字。
>
> 返回 **不同** 且有效的公司名字的数目。
>
>
>
> **示例 1**：
>
> ```
> 输入：ideas = ["coffee","donuts","time","toffee"]
> 输出：6
> 解释：下面列出一些有效的选择方案：
> - ("coffee", "donuts")：对应的公司名字是 "doffee conuts" 。
> - ("donuts", "coffee")：对应的公司名字是 "conuts doffee" 。
> - ("donuts", "time")：对应的公司名字是 "tonuts dime" 。
> - ("donuts", "toffee")：对应的公司名字是 "tonuts doffee" 。
> - ("time", "donuts")：对应的公司名字是 "dime tonuts" 。
> - ("toffee", "donuts")：对应的公司名字是 "doffee tonuts" 。
>   因此，总共有 6 个不同的公司名字。
> 
> 下面列出一些无效的选择方案：
> - ("coffee", "time")：在原数组中存在交换后形成的名字 "toffee" 。
> - ("time", "toffee")：在原数组中存在交换后形成的两个名字。
> - ("coffee", "toffee")：在原数组中存在交换后形成的两个名字。
> ```
>
> **示例 2**：
>
> ```
> 输入：ideas = ["lack","back"]
> 输出：0
> 解释：不存在有效的选择方案。因此，返回 0 。
> ```
>
> **提示**：
>
> - 2 <= ideas.length <= 5 * 104
> - 1 <= ideas[i].length <= 10
> - ideas[i] 由小写英文字母组成
> - ideas 中的所有字符串 互不相同
>
> 来源：力扣（LeetCode）
>
> 链接：https://leetcode.cn/problems/naming-a-company
>
> 著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。

# 2 思路

按照我做题的思路讲解一下整个过程吧，前面的几次代码无法通过，会超时，但是因为其简洁性可以方便大家理解思路。前面思路讲解部分代码示例使用的是 Scala。只会 Java 看不懂 Scala 的朋友或者想看最终代码的朋友，可以只看思路介绍或者跳到最后就好。

最终的代码分别基于 **Java** 和 **Scala** 两种语言的 **BitSet 类库**实现，没有使用力扣题解当中普遍使用的二维数组。个人感觉理解起来还是比较方便的，Java 代码**耗时也击败了 96.40%** （Scala 提交人数较少，耗时击败占比参考价值较低），说明性能也是相当不错的。

> 会 Java 的话，其实下面的 Scala 代码也不难理解（毕竟也不长），大概就是：
>
> 1. 链式调用中，`.groupBy(...)` 对应成 Java 的 `.collect(Collectors.groupingBy(...))`，其他按字面意思对应 Java 8 引入的 Streams API 即可。
> 2. for 循环中 `.indices` 对应全部遍历， `0 until i` 对应从 0 到 i（不包括 i）。`yield` 相当于是把 for 循环里面每一步的结果放到一个序列里面
> 3. Set 的 `diff` 方法就是求前面的 Set 去掉后面 Set 元素的差集

根据题意，我们可以发现**首字母**和**首字母以外的字符串**是本题中的关键。在本篇题解当中，我们将首字母以外的字符串简称为**后缀**。

我们可以分析**两个单词（单词 a 和单词 b）不可以组成公司名称的情况**有如下几个：

1. a 和 b 后缀一致
2. a 的首字母可以和 b 的后缀组成另一个 `ideas` 中的单词
3. b 的首字母可以和 a 的后缀组成另一个 `ideas` 中的单词

那么我们就可以考虑：将**后缀相同**的单词分别按照后缀聚合起来，处理成其**首字母**的集合，方便我们后续的计算。例如 `ideas = ["coffee", "donuts", "time", "toffee", "koffee", "dime", "conuts"]`, 将被处理成:

- "offee": ['c','k','t']
- "onuts": ['c','d']
- "ime": ['d','t']

观察两个集合之间能够组成公司的名称的选择，比如 "offee" 和 "onuts" 后缀。我们最终选出来的是 "offee" 中的 'k','t' 和 "onuts" 的 'd'，他们可以搭配成 `["koffee","donuts"]` 组合与 `["toffee","donuts"]` 组合（当然，还有它们的反序组合，一共四个）。其特点就是在后缀 "offee" 的首字符集合和后缀 "onuts" 首字符集合中把都出现过的 'c' 去掉，然后两个集合就可以两两组合成公司名称了。那么个数就是两个集合的个数分别减去交集个数，然后乘起来，也就是 `(3 - 1) * (2 - 1) = 2`（因为反序也可以，再乘以 2，得到 **4** 个）。

按照同样的逻辑两两计算，最后我们得到 `4 ("offee" 和 "onuts") + 2 ("onuts" 和 "ime") + 4 ("offee" 和 "ime") = 10`。符合我们示例的对应结果（不信的话，你可以直接在力扣测试里面试，啊哈哈）。

那么问题就转化为如下思路：将单词处理成**首字母**和**后缀**；然后以其中之一为聚合项（这里我们选择的是**后缀**），把另一项聚合在集合里；再把集合相互之间求差，然后相乘。把结果加起来就是要求的个数。

> 需要注意的是，选择**首字母**作为聚合项也是可以的。后面优化会用到这一点。

那么最简单的实现如下：

```scala
// 别提交，会超时
def distinctNames(ideas: Array[String]): Long = {
  val sets = ideas.groupBy(_.substring(1)).values.map(_.map(_ (0)).toSet).toArray

  (for (i <- sets.indices; j <- 0 until i)
    yield (sets(i) diff sets(j)).size.toLong * (sets(j) diff sets(i)).size).sum * 2
}
```

这里因为 i 和 j 的差集相乘计算会等同于 j 和 i 的差集相乘计算，所以我们用限制 `j < i` 和最后对结果 `* 2` 略微优化了一下。

可惜上述代码将在最后几个数据量较大的测试用例超时。

那么我们有什么办法来优化耗时呢？很显然上述操作当中，val sets 的计算过程时间复杂度就是 $O(n * m)$, n 是不同首字母以外字符串的个数，m 是首字母位集的大小。这里也没有太多的优化空间。

但是后面的 for 循环时间复杂度是 $O(n^2 * m)$，其中 $O(n^2)$ 的时间复杂度是 for 循环本身引入的，$O(m)$ 是由 Set diff 操作引入的。这个时间复杂度更高，我们需要重点关注这里能如何优化。

Set 的 diff 操作会比较耗时，因为这里面会涉及到 Set 的遍历和重建。那么我们就可以考虑使用位集的思想来优化。这里因为前面我们建立的集合是**首字符**的集合，位集的位数不会超过 26（小写英文字母的个数），所以位集的实现就更加简单了，我们暂时可以使用自行实现的位集逻辑而无须使用类库中的 BitSet。

使用位运算优化集合求差的操作的实现代码如下：

```scala
// 别提交，会超时
def distinctNames(ideas: Array[String]): Long = {
  val bitsets = ideas.groupBy(_.substring(1)).values.map(v => toMyBitSet(v.map(_ (0)))).toArray

  (for (i <- bitsets.indices; j <- 0 until i)
    yield Integer.bitCount(bitsets(i) & ~bitsets(j)).toLong * Integer.bitCount(bitsets(j) & ~bitsets(i)))
    .sum * 2
}

private def toMyBitSet(cs: Array[Char]): Int = {
  var result = 0
  for (c <- cs) {
    result |= (1 << (c - 'a'))
  }
  result
}
```

很遗憾，这个代码还是超时了，那么说明 set 的 diff 还不是最耗时的瓶颈，毕竟时间复杂度本身的量级并没有改变。

继续观察，可以发现选择**后缀**来作为聚合项可能并不是一个好的选择，这样导致后续两两对**首字母**位集做处理的时间复杂度是 $O(n^2 * m)$，n 是不同首字母以外字符串的个数，m 是首字母位集的大小。这里 m 小于 26，但是 n 在单词特别多时，却可以没有上限地上涨。那么我们可以把 m 理解为常数项，时间复杂度为 $O(n^2)$。
那么我们就可以想到：**应该选择首字母作为聚合项，而将聚合的后缀的集合处理成位集**。这样处理的话，时间复杂度可以下降为 $O(n)$ （这里还是把 m 视为常数了，如果要视为变量的话，就乘个 m 平方）

因为后缀个数是没有上限的，所以我们不能继续使用我们自定义的位集了，这里我们应该使用类库提供的 BitSet。而为了将字符串转换为位数，我们需要存储一个映射保留这个信息。

最终的思路就是：

1. 把相同首字母的单词收集到 Map 里，key 是首字母，value 是这些单词去掉首字母后的字符串组成的 List。
2. 将 value List 处理成对应的位集（BitSet）List。为了达到这个目的，我们需要维护一个 `hash` 映射表，里面存储的是字符串和它对应的bitSet 索引（即第几位用来表示该字符串是否存在）
3. 经过上面的处理的 BitSet List，我们两两计算其 `bitset(i)` 去除 `bitset(j)` 中元素后的元素数量(即 Scala 的 &~（Java 的 andNot）操作求差集)乘以 `bitset(j)` 去除 `bitset(i)` 中元素后的元素数量的积。这里是对应首字母不同的情况处理出来的 BitSet 两两之间。

# 3 通过代码

最后通过的代码：

**Java**

```Java
import java.util.Collection;

class Solution {
    private int hashIndex = 0;

    /**
     * 执行用时：73 ms, 在所有 Java 提交中击败了 96.40% 的用户
     * 内存消耗：59.1 MB, 在所有 Java 提交中击败了 16.85% 的用户
     * 通过测试用例：89 / 89
     *
     * @param ideas
     * @return
     */
    public long distinctNames(String[] ideas) {
        hashIndex = 0;
        HashMap<String, Integer> hash = new HashMap<>();
        List<BitSet> bitsets = getBitSets(ideas, hash);
        long sum = 0;
        for (int i = 0; i < bitsets.size(); i++) {
            for (int j = 0; j < i; j++) {
                BitSet cloneI = (BitSet) bitsets.get(i).clone();
                cloneI.andNot(bitsets.get(j));
                BitSet cloneJ = (BitSet) bitsets.get(j).clone();
                cloneJ.andNot(bitsets.get(i));
                sum += (long) cloneI.cardinality() * cloneJ.cardinality();
            }
        }
        return sum * 2;
    }

    private List<BitSet> getBitSets(String[] ideas, HashMap<String, Integer> hash) {
        HashMap<Character, List<String>> startCharMap = new HashMap<>();
        for (String idea : ideas) {
            startCharMap.putIfAbsent(idea.charAt(0), new LinkedList<>());
            startCharMap.get(idea.charAt(0)).add(idea.substring(1));
        }
        Collection<List<String>> values = startCharMap.values();
        List<BitSet> result = new ArrayList<>(values.size());
        for (List<String> suffixes : values) {
            result.add(toBitSet(hash, suffixes));
        }
        return result;
        /**
         * 使用注释的 Streams 代码实现本方法的话，结果如下：
         * 执行用时：90 ms, 在所有 Java 提交中击败了 92.91% 的用户
         * 内存消耗：56.7 MB, 在所有 Java 提交中击败了 23.74% 的用户
         * 通过测试用例：89 / 89
         */
//        return Arrays.stream(ideas)
//                .collect(Collectors.groupingBy(s -> s.charAt(0)))
//                .values()
//                .stream()
//                .map(v -> toBitSet(hash, v.stream().map(s -> s.substring(1)).collect(Collectors.toList())))
//                .collect(Collectors.toList());
    }

    private BitSet toBitSet(HashMap<String, Integer> hash, List<String> strs) {
        BitSet result = new BitSet();
        for (String s : strs) {
            int digit = hash.containsKey(s) ? hash.get(s) : hashIndex;
            if (digit == hashIndex) {
                hash.put(s, hashIndex);
                hashIndex++;
            }
            result.set(digit);
        }
        return result;
    }
}
```

**Scala**

```scala
var hashIndex = 0

/**
 * 执行用时：1024 ms, 在所有 Scala 提交中击败了 100.00% 的用户
 * 内存消耗：72.6 MB, 在所有 Scala 提交中击败了 33.33% 的用户
 * 通过测试用例：89 / 89
 *
 * @param ideas
 * @return
 */
def distinctNames(ideas: Array[String]): Long = {
  hashIndex = 0
  val hash = new scala.collection.mutable.HashMap[String, Int]
  val bitsets = ideas.groupBy(_ (0)).values.map(v => toBitSet(hash, v.map(_.substring(1)))).toArray

  (for (i <- bitsets.indices; j <- 0 until i)
    yield (bitsets(i) &~ bitsets(j)).size.toLong * (bitsets(j) &~ bitsets(i)).size)
    .sum * 2
}

private def toBitSet(hash: scala.collection.mutable.HashMap[String, Int],
                     strs: Array[String]): scala.collection.mutable.BitSet = {
  val result = new scala.collection.mutable.BitSet
  for (s <- strs) {
    val digit = if (hash.contains(s)) hash(s) else {
      hash(s) = hashIndex
      hashIndex += 1
      hashIndex - 1
    }
    result += digit
  }
  result
}
```

# 4 题外话

> **吐槽一下**：
> 一开始自己按C(2,n)的组合数减掉不可以组合的思路整了半天整不出来，想看题解了解一下别人的思路，可能是各种没注释的缩写变量名看得我脑壳疼，也可能是我太蠢了或者没耐心，所有的那种建个二维数组的方法我看了大半个小时也没看懂……
> 那就只能自己整了，好歹最后还是做出来了，方法和一般的题解不太一样，直接用到了 BitSet 优化集合求差的耗时。
> 我看好像 Java 那么多提交里面也没怎么看到类似的实现，分享一下供大家参考，耗时排名其实也挺能打的，Java 击败 96.40%。
>
> 后来回过头还是模模糊糊看懂了二维数组的方法：
> 1. 其中也会维护一个 ideas 按后缀聚合的存储首字母集合的 Map——也有的题解中用位集思想优化了。
> 2. 只是在这里还引入了一个二维数组存储整个 ideas 当中首字母有 i 无 j 的个数，然后就可以在遍历 ideas 的过程中对所有的 26 个字母查 Map 确认当前后缀是否已经有过同后缀的其他首字母，然后维护这个二维数组（i 无法与多少个 j 开头的字符串交换，以及反之）。
>
> 虽然看懂了，但是感觉这个思维模式还是和我自己冲突，有点打脑袋…… 要是你也有类似感觉的话，希望我这个思路可以帮到你，我自己感觉我的思路还是理解起来更直观一点的。



![GitHub](https://img.shields.io/badge/GitHub-ZeromaXHe-lightgrey?style=flat-square&logo=GitHub)![Gitee](https://img.shields.io/badge/Gitee-zeromax-red?style=flat-square&logo=Gitee)![LeetCodeCN](https://img.shields.io/badge/LeetCodeCN-ZeromaX-orange?style=flat-square&logo=LeetCode)![Weixin](https://img.shields.io/badge/%E5%85%AC%E4%BC%97%E5%8F%B7-ZeromaX%E8%A8%B8%E7%9A%84%E6%97%A5%E5%B8%B8-brightgreen?style=flat-square&logo=WeChat)![Zhihu](https://img.shields.io/badge/%E7%9F%A5%E4%B9%8E-maX%20Zero-blue?style=flat-square&logo=Zhihu)![Bilibili](https://img.shields.io/badge/Bilibili-ZeromaX%E8%A8%B8-lightblue?style=flat-square&logo=Bilibili)![CSDN](https://img.shields.io/badge/CSDN-SquareSquareHe-red?style=flat-square)