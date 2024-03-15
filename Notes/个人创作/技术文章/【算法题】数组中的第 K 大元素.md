# 题目简介

【力扣第 **215** 题：**数组中的第K个最大元素**】难度：中等

给定整数数组 `nums` 和整数 `k`，请返回数组中第 `k` 个最大的元素。

请注意，你需要找的是数组排序后的第 `k` 个最大的元素，而不是第 `k` 个不同的元素。

**示例 1**:

```
输入: [3,2,1,5,6,4] 和 k = 2
输出: 5
```

**示例 2**:

```
输入: [3,2,3,1,2,4,5,5,6] 和 k = 4
输出: 4
```

**提示**：

- `1 <= k <= nums.length <= 10^4`
- `-10^4 <= nums[i] <= 10^4`

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/kth-largest-element-in-an-array

# 题目解析

# 1. 直接排序

最简单的思路就是使用 `Arrays.sort()` 直接排序，然后取第 k 大的元素就好了：

```java
public int findKthLargest_arraysSort(int[] nums, int k) {
    Arrays.sort(nums);
    return nums[nums.length - k];
}
```

但是我们查看源码（`DualPivotQuicksort` 类）可以知道 `Arrays.sort(int[])` 的底层实现是在数组分区长度小于 47 时使用插入排序，长度大于 286 时且随机性比较低时使用归并排序，其他情况下使用快速排序（具体来说是双基准快速排序法）。

所以以上代码的平均算法时间复杂度大概是在 $O(n \log n)$ （我们暂且不考虑插入排序的问题，这里 Java 源码中有很多特别的优化，具体可以看源码）

提交之后效果其实还不错，毕竟 Java 的类库效率还是相当优秀的：

```
执行用时： 2 ms , 在所有 Java 提交中击败了 81.66% 的用户
内存消耗： 41.7 MB , 在所有 Java 提交中击败了 16.30% 的用户
通过测试用例： 32 / 32
```

**优化思路**

但是毕竟这是一个算法题，只当一个 API 调用 boy / girl 是绝对不行的。那么我们能不能想到一个比暴力的直接排序思路的时间复杂度更低的方法来解决这个算法题呢？

熟悉数据结构和算法的同学应该很容易想到两个思路：使用**堆**和使用提前返回的**快速排序**。

下面我们将针对这两个思路进行详细介绍。

# 2. 堆

首先我们可以使用 Java 自带的 API `PriorityQueue` 进行思路上的介绍，一边熟悉一下 Java 类库的操作。

该题我们可以使用大小为 k 的大顶堆（也称为最大堆、大根堆）或小顶堆（也称为最小堆、小根堆）来处理数组。

- 使用**大顶堆**的话，就需要将所有数组加入到大顶堆，然后弹出 k 次后拿到第 k 大的数。
- 使用**小顶堆**的话，就需要先加入数组前k个数字，然后动态地将数组中所有大于小顶堆堆顶的数字替换掉小顶堆堆顶。最后小顶堆的堆顶就是我们要找的第 k 大元素。

代码如下：

```java
/**
 * 执行用时： 5 ms , 在所有 Java 提交中击败了 46.17% 的用户
 * 内存消耗： 41.9 MB , 在所有 Java 提交中击败了 5.05% 的用户
 * 通过测试用例： 32 / 32
 */
public int findKthLargest_maxHeap(int[] nums, int k) {
    // 大顶堆
    PriorityQueue<Integer> heap = new PriorityQueue<>(k, Comparator.reverseOrder());
    for (int num : nums) {
        heap.offer(num);
    }
    for (int i = 1; i < k; i++) {
        heap.poll();
    }
    return heap.poll();
}

/**
 * 执行用时： 4 ms , 在所有 Java 提交中击败了 53.61% 的用户
 * 内存消耗： 41.4 MB , 在所有 Java 提交中击败了 65.01% 的用户
 * 通过测试用例： 32 / 32
 */
public int findKthLargest_minHeap(int[] nums, int k) {
    // 小顶堆
    PriorityQueue<Integer> heap = new PriorityQueue<>(k);
    for (int num : nums) {
        if (heap.size() < k || num > heap.peek()) {
            if (heap.size() == k) {
                heap.poll();
            }
            heap.offer(num);
        }
    }
    return heap.poll();
}
```

时间复杂度分析的话，`heap.offer()` 和 `heap.poll()` 的平均时间复杂度均为 $O(\log k)$，所以最后总的平均时间复杂度为 $O(n\log k)$。相比于之前直接排序的思路，平均时间复杂度是下降了；但是从结果的执行耗时来看，使用 Java 的 `PriorityQueue` 实现我们的思路的话，耗时明显较长。主要原因就是整个 `PriorityQueue` 的底层维护过程需要新建一个 `Object[]` 数组，然后在此基础上实现堆的逻辑。

那么我们能不能在题目中的数组内部直接原地实现堆的逻辑呢？这样上面提到的这部分时间就能优化出来了。按照这个思路，我们可以写出以下原地实现堆逻辑的代码：

```java
/**
 * 执行用时： 1 ms , 在所有 Java 提交中击败了 98.59% 的用户
 * 内存消耗： 41.5 MB , 在所有 Java 提交中击败了 42.17% 的用户
 * 通过测试用例： 32 / 32
 */
public int findKthLargest(int[] nums, int k) {
    for (int i = (k - 2) / 2; i >= 0; i--) {
        heapify(nums, i, k);
    }
    for (int i = k; i < nums.length; ++i) {
        // 看 k 大小的堆外的数组元素是否有大于小顶堆堆顶的，有的话替换掉堆顶，然后重新维护最小堆的状态
        if (nums[0] >= nums[i])
            continue;
        // 异或 swap
        nums[i] ^= nums[0] ^= nums[i];
        nums[0] ^= nums[i];
        heapify(nums, 0, k);
    }
    return nums[0];
}

private int heapify(int[] nums, int i, int k) {
    // i 的左子节点索引为 i * 2 + 1，右子节点索引为 i * 2 + 2
    int left = i * 2 + 1;
    // 循环去重建子树，保持最小堆的状态
    while (left < k) {
        // min 为较小的子节点索引
        int min = left + 1 < k && nums[left] > nums[left + 1] ? left + 1 : left;
        if (nums[i] <= nums[min]) {
            break;
        }
        // 异或方式 swap
        nums[min] ^= nums[i] ^= nums[min];
        nums[i] ^= nums[min];
        i = min;
        left = i * 2 + 1;
    }
    return i;
}
```

可以看到最终的耗时优化到了 1ms，相比 `PriorityQueue` 提升显著。

> 其中交换的逻辑，我们使用了**异或**的方式进行交换。相比一般使用的引入一个 temp 变量来交换的方式，该方法不需要引入新的变量，大家也可以了解一下。（不过实际写代码过程中，这个方法只能算是奇技淫巧，并不能优化什么效率，反而丢失了可读性。使用 temp 变量交换，耗时基本一致。这里权且写出来让大家了解一下有这么一种方法）
>
> 需要注意的是，在 Java 中，这里绝对**不可以将异或 swap 写法简写为一行，例如 a ^= b ^= a ^= b 的格式**。（这种格式在 C 语言应该是可以的，但要求两个数字不能相等，否则会变成两个 0）
>
> 这样的话，如果我们用 IDEA 查看，会发现第二个 a 是灰色的（表示其实没有用到）。再看 IDEA 中的 class 反编译文件，可以发现 java 实际的实现方式等同于 a = a ^ (b = b ^ a ^ b)。意味着第一次赋值操作 a ^= b 并没有赋值给 a（正因为此，第二个 a 是灰色的）, 导致结果就是相当于 b = a, a = 0（字节码的详情分析可以参考：https://blog.csdn.net/baisedeqingting/article/details/89178198）
>
> 相关的测试代码如下（需要使用 JUnit）：
>
> ```java
> @Test
> public void swapTest() {
>     int a = 1;
>     int b = 2;
>     // 最原始的异或 swap 写法
>     a ^= b;
>     b ^= a;
>     a ^= b;
>     Assert.assertEquals(a, 2);
>     Assert.assertEquals(b, 1);
>     a = 1;
>     b = 2;
>     // 略微简写
>     b ^= a ^= b;
>     a ^= b;
>     Assert.assertEquals(a, 2);
>     Assert.assertEquals(b, 1);
>     a = 1;
>     b = 2;
>     // 失败的写法
>     a ^= b ^= a ^= b;
>     Assert.assertEquals(a, 0);
>     Assert.assertEquals(b, 1);
>     a = 1;
>     b = 2;
>     // 失败写法的等效 class 反编译
>     b = b ^ a ^ b;
>     a = a ^ b;
>     Assert.assertEquals(a, 0);
>     Assert.assertEquals(b, 1);
> }
> ```

# 3. 快速排序

使用快速排序解决这个问题的思路也很简单。

快速排序自身的基本思路是基于分治的：

1. 首先对区域进行 partition （分区）操作。这里会选择一个元素作为**主元**（pivot element），围绕它来划分子数组，比主元小的元素和比主元大的元素被主元分隔开来。
2. 然后对分出来的比主元小的元素子数组与比主元大的元素子数组分别再次执行快速排序逻辑，直到数组只有一个元素。

简单的实现代码如下：

```java
public static int[] quickSort(int arr[], int left, int right) {
    // 主元
    int pivot = arr[left];
    // 左指针
    int l = left;
    // 右指针
    int r = right;
    while (l < r) {
        // 在右边找到一个比中值小或者相等的值
        while (l < r && arr[r] > pivot) {
            r--;
        }
        // 在左边找到一个比中值大或者相等的值
        while (l < r && arr[l] < pivot) {
            l++;
        }
        if (arr[l] == arr[r] && l < r) {
            // 在 l 和 r 没有相遇时，如果 arr[l] == arr[r]，说明它们也都等于 pivot，没必要交换
            l++;
        } else {
            // 交换
            int temp = arr[l];
            arr[l] = arr[r];
            arr[r] = temp;
        }
    }
    // 左子数组继续快排
    if (l - 1 > left) {
        arr = quickSort(arr, left, l - 1);
    }
    // 右子数组继续快排
    if (r + 1 < right) {
        arr = quickSort(arr, r + 1, right);
    }
    return arr;
}
```

以上最基础的快速排序代码有很多可以优化的细节：

- **pivot 的选择**：固定选择最左元素可能导致在数组较为有序时时间复杂度退化到 $O(n^2)$。这里我们可以选择三数取中的办法，也可以采用随机采样的办法。
- **pivot 相等元素的处理**：我们没有处理和 pivot 相等的元素，这些元素将散布在数组各处。
- **数组较小时可以使用插入排序**：前面我们提到，Java 的 `Arrays.sort(int[])` 底层其实就用到这一点来进行优化

然后针对这道题目，我们又可以进行针对性的优化。（因为不需要完全排序，我们只需要找到第 k 大的元素，一旦找到就可以直接返回了）：

- **快速排序需要对两个子数组进行递归，而本题可以只针对第 k 大的元素所在的子数组去进行下一个快排循环**。因此递归也将退化为尾递归，我们也可以使用循环来代替它。（其实原始快速排序的第二个递归也可以使用循环进行尾递归优化，有些编译器能够自动优化尾递归）
- **对于 pivot 相等的元素，快速排序需要移动到中间，而本题我们可以不移动**。pivot 和与它相等的元素都将留在数组的一侧。
- **当 left 或 right 刚好就是索引 k 的情况下，问题退化为求极值问题**。时间复杂度退化到 $O(n) $

采用以上优化，我们最终实现代码如下：

```java
/**
 * 执行用时： 1 ms , 在所有 Java 提交中击败了 98.59% 的用户
 * 内存消耗： 41.8 MB , 在所有 Java 提交中击败了 6.95% 的用户
 * 通过测试用例： 32 / 32
 */
public int findKthLargest_quickSort(int[] nums, int k) {
    int left = 0;
    int right = nums.length;
    while (left < right) {
        // 如果左边界就是第 k 个数字，那么直接找区间的最大值即可
        if (left == k - 1) {
            int max = nums[left];
            for (int i = left + 1; i < right; i++) {
                if (nums[i] > max) {
                    max = nums[i];
                }
            }
            return max;
        }
        // 如果右边界就是第 k 个数字，那么直接找区间内最小值即可
        if (right == k) {
            int min = nums[left];
            for (int i = left + 1; i < right; i++) {
                if (nums[i] < min) {
                    min = nums[i];
                }
            }
            return min;
        }
        // 否则既然左右边界都不是第 k 个数字，那么第 k 位就在 left 和 right 中间，在中间尝试使用类似快速排序的思想进行寻找。
        // 随机取 pivot
        int pivot = left + (int) (Math.random() * (right - left));
        // 异或 swap，交换 pivot 和 left
        if (nums[pivot] != nums[left]) {
            nums[pivot] ^= nums[left] ^= nums[pivot];
            nums[left] ^= nums[pivot];
        }
        int l = left + 1;
        int r = right;
        int countEqual = 1;
        while (l < r) {
            if (nums[l] >= nums[left]) {
                if (nums[l] == nums[left]) {
                    // 相等值都移到区间最左边，和 pivot 在一起
                    if (nums[l] != nums[left + countEqual]) {
                        nums[l] ^= nums[left + countEqual] ^= nums[l];
                        nums[left + countEqual] ^= nums[l];
                    }
                    countEqual++;
                }
                l++;
            } else {
                if (nums[l] != nums[r - 1]) {
                    nums[r - 1] ^= nums[l] ^= nums[r - 1];
                    nums[l] ^= nums[r - 1];
                }
                r--;
            }
        }
        if (k > l) {
            // k 落在了比 pivot 小的区域（右侧）
            left = l;
            continue;
        }
        if (k > l - countEqual) {
            // k 落在了和 pivot 大小一致的区域
            return nums[left];
        }
        // k 落在了比 pivot 大的区域（左侧）
        // 这时因为我们相等值都放在了最左边，所以为了免除移动这部分相等值的耗时，我们直接修改 k 来使下个循环在比 pivot 大的区域中寻找。
        k += countEqual;
        left += countEqual;
        right = r;
    }
    return nums[left];
}
```

该方法的平均时间复杂度依然是 $O(n \log n)$，但因为细节得到较多优化，实际耗时较低。不过因为过程代码被压缩在了同一个方法内，相对复杂，可维护性较低。在实际题目解决过程中，遇到 bug 较难修改，其实略显过度优化。

参考力扣结果详情时间分布中 0ms 的示例代码，可以发现仅使用三数取中优化的快排代码，也能达到较好的效果（代码可读性却好了不少）：

```java
/**
 * 执行用时：1 ms, 在所有 Java 提交中击败了 98.59% 的用户
 * 内存消耗：41.6 MB, 在所有 Java 提交中击败了 32.05% 的用户
 * 通过测试用例：32 / 32
 */
public int findKthLargest(int[] nums, int k) {
    return Qsort(nums, 0, nums.length - 1, nums.length - k + 1);
}

public int Qsort(int[] nums, int low, int high, int k) {
    int pivot = Partition(nums, low, high);
    if (pivot == k - 1) {
        return nums[pivot];
    }
    return pivot >= k ? Qsort(nums, low, pivot - 1, k) : Qsort(nums, pivot + 1, high, k);
}

public int Partition(int[] nums, int low, int high) {
    // 三个数 low、mid、high 取中间值，简称三数取中优化
    int mid = low + (high - low) / 2;
    if (nums[low] > nums[high]) {
        swap(nums, low, high);
    }
    if (nums[mid] > nums[high]) {
        swap(nums, mid, high);
    }
    if (nums[mid] > nums[low]) {
        swap(nums, low, mid);
    }
    // 经过以上变换，nums[low] 中就是中间值
    int key = nums[low];
    while (low < high) {
        while (low < high && nums[high] >= key) {
            high--;
        }
        swap(nums, low, high);
        while (low < high && nums[low] <= key){
            low++;
        }
        swap(nums, low, high);
    }
    return low;
}

public void swap(int[] nums, int i, int j) {
    int temp = nums[i];
    nums[i] = nums[j];
    nums[j] = temp;
}
```

