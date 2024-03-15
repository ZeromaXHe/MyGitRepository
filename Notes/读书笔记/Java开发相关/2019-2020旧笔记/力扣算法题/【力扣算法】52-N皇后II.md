# 题目

n 皇后问题研究的是如何将 n 个皇后放置在 n×n 的棋盘上，并且使皇后彼此之间不能相互攻击。

![img](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/10/12/8-queens.png)

上图为 8 皇后问题的一种解法。

给定一个整数 n，返回 n 皇后不同的解决方案的数量。

示例:
~~~
输入: 4
输出: 2
解释: 4 皇后问题存在如下两个不同的解法。
[
 [".Q..",  // 解法 1
  "...Q",
  "Q...",
  "..Q."],

 ["..Q.",  // 解法 2
  "Q...",
  "...Q",
  ".Q.."]
]
~~~
来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/n-queens-ii
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。

# 题解

官方题解前半部分和上一题差不多，懒得复制了。主要是用位图那个方法值得看看：

## 方法 2：使用 bitmap 回溯

如果你是在面试中 - 使用方法 1。

下面的算法有着相同的时间复杂度 $\mathcal{O}(N!)$。但是由于使用了位运算，可以运行得更快。

感谢这个算法的提出者 takaken.

为了便于理解该算法，下面的代码进行了逐步解释。

~~~java
class Solution {
  public int backtrack(int row, int hills, int next_row, int dales, int count, int n) {
    /** 
     row: 当前放置皇后的行号
     hills: 主对角线占据情况 [1 = 被占据，0 = 未被占据]
     next_row: 下一行被占据的情况 [1 = 被占据，0 = 未被占据]
     dales: 次对角线占据情况 [1 = 被占据，0 = 未被占据]
     count: 所有可行解的个数
     */

    // 棋盘所有的列都可放置，
    // 即，按位表示为 n 个 '1'
    // bin(cols) = 0b1111 (n = 4), bin(cols) = 0b111 (n = 3)
    // [1 = 可放置]
    int columns = (1 << n) - 1;
    
    if (row == n)   // 如果已经放置了 n 个皇后
      count++;  // 累加可行解
    else {
      // 当前行可用的列
      // ! 表示 0 和 1 的含义对于变量 hills, next_row and dales的含义是相反的
      // [1 = 未被占据，0 = 被占据]
      int free_columns = columns & ~(hills | next_row | dales);
    
      // 找到可以放置下一个皇后的列
      while (free_columns != 0) {
        // free_columns 的第一个为 '1' 的位
        // 在该列我们放置当前皇后
        int curr_column = - free_columns & free_columns;
    
        // 放置皇后
        // 并且排除对应的列
        free_columns ^= curr_column;
    
        count = backtrack(row + 1,
                (hills | curr_column) << 1,
                next_row | curr_column,
                (dales | curr_column) >> 1,
                count, n);
      }
    }
    
    return count;
  }
  public int totalNQueens(int n) {
    return backtrack(0, 0, 0, 0, 0, n);
  }
}
~~~
### 复杂度分析

时间复杂度：$\mathcal{O}(N!)$.
空间复杂度：$\mathcal{O}(N)$.

作者：LeetCode
链接：https://leetcode-cn.com/problems/two-sum/solution/nhuang-hou-ii-by-leetcode/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

# 感想

把上一题代码改一改就好了

执行用时 :6 ms, 在所有Java提交中击败了43.76%的用户

内存消耗 :33.3 MB, 在所有Java提交中击败了54.69%的用户

~~~java
class Solution {
    boolean[][] chessboard;
    int count = 0;
    public int totalNQueens(int n) {
        chessboard = new boolean[n][n];
        placeQueen(0);
        return count;
    }
    private boolean isLegal(int x, int y){
        int n=chessboard.length;
        for(int i=1;i<=x&&y>=i;i++){
            if(chessboard[x-i][y-i]) return false;
        }
        for(int i=1;i<=x&&n-y>i;i++){
            if(chessboard[x-i][y+i]) return false;
        }
        for(int i=0;i<x;i++){
            if(chessboard[i][y]) return false;
        }
        return true;
    }
    private void placeQueen(int x){
        int n = chessboard.length;
        for(int i=0;i<n;i++){
            if(isLegal(x,i)) {
                if(x<n-1){
                    chessboard[x][i]=true;
                    placeQueen(x+1);
                    chessboard[x][i]=false;  
                } 
                else {
                    count++;
                }
            }
        }
    }
}
~~~

