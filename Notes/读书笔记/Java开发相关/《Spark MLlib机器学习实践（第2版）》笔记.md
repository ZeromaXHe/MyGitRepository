# 第1章 星星之火

## 1.1 大数据时代

飞速产生的数据构建了大数据， 海量数据的时代我们称为大数据时代。 但是， 简单地认为那些掌握了海量存储数据资料的人是大数据强者显然是不对的。 真正的强者是那些能够挖掘出隐藏在海量数据背后获取其中所包含的巨量数据信息与内容的人， 是那些掌握专门技能懂得怎样对数据进行有目的、 有方向地处理的人。   

## 1.2 大数据分析时代

一般来说， 大数据分析需要涉及以下5个方面

**1． 有效的数据质量**

任何数据分析都来自于真实的数据基础， 而一个真实数据是采用标准化的流程和工具对数据进行处理得到的， 可以保证一个预先定义好的高质量的分析结果。

**2． 优秀的分析引擎**

对于大数据来说， 数据的来源多种多样， 特别是非结构化数据来源的多样性给大数据分析带来了新的挑战。 因此， 我们需要一系列的工具去解析、 提取、 分析数据。 大数据分析引擎就是用于从数据中提取我们所需要的信息。

**3． 合适的分析算法**

采用合适的大数据分析算法能让我们深入数据内部挖掘价值。 在算法的具体选择上， 不仅仅要考虑能够处理的大数据的数量， 还要考虑到对大数据处理的速度。

**4． 对未来的合理预测**

数据分析的目的是对已有数据体现出来的规律进行总结， 并且将现象与其他情况紧密连接在一起， 从而获得对未来发展趋势的预测。 大数据分析也是如此。 不同的是， 在大数据分析中， 数据来源的基础更为广泛， 需要处理的方面更多。

**5． 数据结果的可视化**

大数据的分析结果更多是为决策者和普通用户提供决策支持和意见提示， 其对较为深奥的数学含义不会太了解。 因此必然要求数据的可视化能够直观地反映出经过分析后得到的信息与内容， 能够较为容易地被使用者所理解和接受。

因此可以说， 大数据分析是数据分析最前沿的技术。 这种新的数据分析是目标导向的， 不用关心数据的来源和具体格式， 能够根据我们的需求去处理各种结构化、 半结构化和非结构化的数据， 配合使用合适的分析引擎， 能够输出有效结果， 提供一定的对未来趋势的预测分析服务， 能够面向更广泛的用户快速部署数据分析应用。  

## 1.3 简单、优雅、有效——这就是Spark

Apache Spark是加州大学伯克利分校的AMPLabs开发的开源分布式轻量级通用计算框架。 与传统的数据分析框架相比， Spark在设计之初就是基于内存而设计， 因此其比一般的数据分析框架有着更高的处理性能， 并且对多种编程语言， 例如Java、 Scala及Python等提供编译支持，使得用户在使用传统的编程语言即可对其进行程序设计， 从而使得用户的学习和维护能力大大提高。

简单、 优雅、 有效——这就是Spark！

Spark是一个简单的大数据处理框架， 可以使程序设计人员和数据分析人员在不了解分布式底层细节的情况下， 就像编写一个简单的数据处理程序一样对大数据进行分析计算。

Spark是一个优雅的数据处理程序， 借助于Scala函数式编程语言，以前往往几百上千行的程序， 这里只需短短几十行即可完成。 Spark创新了数据获取和处理的理念， 简化了编程过程， 不再需要使用以往的建立索引来对数据分类， 通过相应的表链接将需要的数据匹配成我们需要的格式。 Spark没有臃肿， 只有优雅。

Spark是一款有效的数据处理工具程序， 充分利用集群的能力对数据进行处理， 其核心就是MapReduce数据处理。 通过对数据的输入、 分拆与组合， 可以有效地提高数据管理的安全性， 同时能够很好地访问管理的数据。

Spark是建立在JVM上的开源数据处理框架， 开创性地使用了一种从最底层结构上就与现有技术完全不同， 但是更加具有先进性的数据存储和处理技术， 这样使用Spark时无须掌握系统的底层细节， 更不需要购买价格不菲的软硬件平台， 借助于架设在普通商用机上的HDFS存储系统， 可以无限制地在价格低廉的商用PC上搭建所需要规模的评选数据分析平台。 即使从只有一台商用PC的集群平台开始， 也可以在后期任意扩充其规模。

Spark是基于MapReduce并行算法实现的分布式计算， 其拥有MapReduce的优点， 对数据分析细致而准确。 更进一步， Spark数据分析的结果可以保持在分布式框架的内存中， 从而使得下一步的计算不再频繁地读写HDFS， 使得数据分析更加快速和方便。  

> **提示**
>
> 需要注意的是， Spark并不是“仅”使用内存作为分析和处理的存储空间， 而是和HDFS交互使用， 首先尽可能地采用内存空间， 当内存使用达到一定阈值时， 仍会将数据存储在HDFS上。  

除此之外， Spark通过HDFS使用自带的和自定义的特定数据格式（RDD） ， Spark基本上可以按照程序设计人员的要求处理任何数据，不论这个数据类型是什么样的， 数据可以是音乐、 电影、 文本文件、Log记录等。 通过编写相应的Spark处理程序， 帮助用户获得任何想要的答案。

有了Spark后， 再没有数据被认为是过于庞大而不好处理或存储的了， 从而解决了之前无法解决的、 对海量数据进行分析的问题， 便于发现海量数据中潜在的价值。  

## 1.4 核心——MLlib

如果将Spark比作一个闪亮的星星的话， 那么其中最明亮最核心的部分就是MLlib。 MLlib是一个构建在Spark上的、 专门针对大数据处理的并发式高速机器学习库， 其特点是采用较为先进的迭代式、 内存存储的分析计算， 使得数据的计算处理速度大大高于普通的数据处理引擎。

MLlib机器学习库还在不停地更新中， Apache的相关研究人员仍在不停地为其中添加更多的机器学习算法。 目前MLlib中已经有通用的学习算法和工具类， 包括统计、 分类、 回归、 聚类、 降维等，如图1-2所示。

~~~
分类&回归：
	线性模型（线性支持向量机SVMs（分类）、逻辑回归（分类）、线性回归）
	朴素贝叶斯
	决策树
	RF&GBDT
推荐：
	ALS
关联规则：
	Fp-growth
聚类：
	K-means
	LDA
降维：
	SVD
	PCA
优化：
	随机梯度下降
	L-BFGS
特征抽取：
	TF-IDF
	StandardScaler
	Word2Vec
	Normalizer
	ChiSqSelector
统计：
	相关性
	分层抽样
	假设检验
算法评测：
	AUC
	准确率
	召回率
	F-measure
~~~

对预处理后的数据进行分析， 从而获得包含着数据内容的结果是MLlib的最终目的。 MLlib作为Spark的核心处理引擎， 在诞生之初就为了处理大数据而采用了“分治式”的数据处理模式， 将数据分散到各个节点中进行相应的处理。 通过数据处理的“依赖”关系从而使得处理过程层层递进。 这个过程可以依据要求具体编写， 好处是避免了大数据处理框架所要求进行的大规模数据传输， 从而节省了时间， 提高了处理效率。

同时， MLlib借助于函数式程序设计思想， 程序设计人员在编写程序的过程中只需要关注其数据， 而不必考虑函数调用顺序， 不用谨慎地设置外部状态。 所有要做的就是传递代表了边际情况的参数。

MLlib采用Scala语言编写， Scala语言是运行在JVM上的一种函数式编程语言， 特点就是可移植性强， “一次编写， 到处运行”是其最重要的特点。 借助于RDD数据统一输入格式， 让用户可以在不同的IDE上编写数据处理程序， 通过本地化测试后可以在略微修改运行参数后直接在集群上运行。 对结果的获取更为可视化和直观， 不会因为运行系统底层的不同而造成结果的差异与改变。

MLlib是Spark的核心内容， 也是其中最闪耀的部分。 对数据的分析和处理是Spark的精髓， 也是挖掘大数据这座宝山的金锄头， 本书的内容也是围绕MLlib进行的。  

## 1.5 星星之火，可以燎原



# 第2章 Spark安装和开发环境配置

本章将介绍Spark的单机版安装方法和开发环境配置。 MLlib是Spark数据处理框架的一个主要组件， 因此其运行必须要有Spark的支持。 本书以讲解和演示MLlib原理和示例为主， 因此在安装上将详细介绍基于Intellij IDEA的在Windows操作系统上的单机运行环境， 这也是MLlib学习和调试的最常见形式， 以便更好地帮助读者学习和掌握MLlib编写精髓。  

## 2.1 Windows单机模式Spark安装和配置

### 2.1.1 Windows 7安装Java

### 2.1.2 Windows 7安装Scala

### 2.1.3 Intellij IDEA下载和安装

### 2.1.4 Intellij IDEA中Scala插件的安装

Scala是一种把面向对象和函数式编程理念加入到静态类型语言中的语言， 可以把Scala应用在很大范围的编程任务上， 无论是小脚本或是大系统都可以用Scala实现。 Scala运行在标准的Java平台上（JVM） ， 可以与所有的Java库实现无缝交互。

而Spark MLlib是基于Java平台的大数据处理框架， 因此在语言的选择上， 可以自由选择最方便的语言进行编译处理。 而Scala天生具有的简洁性和性能上的优势， 以及可以在JVM上直接使用的特点， 使其成为Spark官方推荐的首选程序语言， 因此本书笔者也推荐使用Scala语言作为Spark MLlib学习的首选语言。

Intellij IDEA本身并没有安装Scala编译插件， 因此在使用Intellij IDEA编译Scala语言编写的Spark MLlib语言之前， 需要安装Scala编译插件  

### 2.1.5 HelloJava——使用Intellij IDEA创建Java程序

### 2.1.6 HelloScala——使用Intellij IDEA创建Scala程序

~~~scala
class helloScala { 
    def main(args: Array[String]): Unit = { 
        print("helloScala") 
    } 
}
~~~

### 2.1.7 最后一脚——Spark单机版安装

## 2.2 经典的WordCount

### 2.2.1 Spark实现WordCount

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object wordCount {
    def main(args: Array[String]) { 
        val conf = new SparkConf()
        				.setMaster("local")
        				.setAppName("wordCount") //创建环境变量 
        val sc = new SparkContext(conf) //创建环境变量实例 
        val data = sc.textFile("c://wc.txt") //读取文件 
        data.flatMap(_.split(" "))
            .map((_,1))
            .reduceByKey(_+_)
            .collect()
            .foreach(println) //word 计数 
    } 
}
~~~

下面是对程序进行分析。

（1） 首先笔者new了一个SparkConf()， 目的是创建了一个环境变量实例， 告诉系统开始Spark计算。 之后的setMaster("local")启动了本地化运算， setAppName("wordCount")是设置本程序名称。

（2） new SparkContext(conf)的作用是创建环境变量实例， 准备开始任务。

（3） sc.textFile("c://wc.txt")的作用是读取文件， 这里的文件是在C盘上， 因此路径目录即为c: //wc.txt。 顺便提一下， 此时的文件读取是按正常的顺序读取， 本书后面章节会介绍如何读取特定格式的文件。

（4） 第4行是对word进行计数。 flatMap()是Scala中提取相关数据按行处理的一个方法， _.split(" ")中， 下划线_是一个占位符， 代表传送进来的任意一个数据， 对其进行按" "分割。 map((_, 1))是对每个字符开始计数， 在这个过程中， 并不涉及合并和计算， 只是单纯地将每个数据行中单词加1。 最后的reduceByKey()方法是对传递进来的数据按key值相加， 最终形成wordCount计算结果。  

（5） collect()是对程序的启动， 因Spark编程的优化， 很多方法在计算过程中属于lazy模式， 因此需要一个显性启动支持。 foreach(println)是打印的一个调用方法， 打印出数据内容。  

### 2.2.2 MapReduce实现WordCount

与Spark对比的是MapReduce中wordCount程序的设计， 如程序2-4所示， 在这里笔者只是为了做对比， 如果有读者想深入学习MapReduce程序设计， 请参考相关的专业书籍。  

~~~java
import java.io.IOException; 
import java.util.Iterator;
import java.util.StringTokenizer;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.Mapper;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reducer;
import org.apache.hadoop.mapred.Reporter;
import org.apache.hadoop.mapred.TextInputFormat;
import org.apache.hadoop.mapred.TextOutputFormat; 

public class WordCount { 
    //创建固定 Map 格式
    public static class Map extends MapReduceBase implements Mapper<LongWritable, Text, Text, IntWritable> { 
        //创建数据1格式
        private final static IntWritable one = new IntWritable(1); 
        //设定输入格式 
        private Text word = new Text(); 
        //开始 map 程序 
        public void map(LongWritable key, Text value, OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException { 
            //将传入值定义为 line
            String line = value.toString(); 
            //格式化传入值
            StringTokenizer tokenizer = new StringTokenizer(line); 
            //开始迭代计算 
            while(tokenizer.hasMoreTokens()) { 
                //设置输入值
                word.set(tokenizer.nextToken()); 
                //写入输出值
                output.collect(word, one); 
            } 
        } 
    } 
    //创建固定 Reduce 格式
    public static class Reduce extends MapReduceBase implements Reducer<Text, IntWritable, Text, IntWritable> { 
        //开始 Reduce 程序 
        public void reduce(Text key, Iterator<IntWritable> values, OutputCollector<Text, IntWritable> output, Reporter
                           reporter) throws IOException { 
            //初始化计算器 
            int sum = 0; 
            //开始迭代计算输入值 
            while (values.hasNext()) {
                sum += values.next().get(); 
                //计数器计算 
            } 
            //创建输出结果 
            output.collect(key, new IntWritable(sum)); 
        } 
    }
    //开始主程序 
    public static void main(String[] args) throws Exception { 
        //设置主程序 
        JobConf conf = new JobConf(WordCount.class); 
        //设置主程序名
        conf.setJobName("wordcount"); 
        //设置输出 Key 格式
        conf.setOutputKeyClass(Text.class); 
        //设置输出 Vlaue 格式
        conf.setOutputValueClass(IntWritable.class); 
        //设置主 
        Map conf.setMapperClass(Map.class); 
        //设置第一次 Reduce 方法
        conf.setCombinerClass(Reduce.class);
        //设置主 Reduce 方法
        conf.setReducerClass(Reduce.class); 
        //设置输入格式
        conf.setInputFormat(TextInputFormat.class); 
        //设置输出格式
        conf.setOutputFormat(TextOutputFormat.class);
        //设置输入文件路径
        FileInputFormat.setInputPaths(conf, new Path(args[0])); 
        //设置输出路径
        FileOutputFormat.setOutputPath(conf, new Path(args[1])); 
        //开始主程序 
        JobClient.runJob(conf);
    } 
}
~~~

从程序2-3和程序2-4的对比可以看到， 采用了Scala的Spark程序设计能够简化程序编写的过程与步骤， 同时在后端， Scala对编译后的文件有较好的优化性， 这些都是目前使用Java语言所欠缺的。

这里顺便提一下， 可能有部分使用者在使用Scala时感觉较为困难，但实际上， Scala在使用中主要将其进行整体化考虑， 而非Java的面向对象的思考方法， 这点请读者注意。  

# 第3章 RDD详解

本章将着重介绍Spark最重要的核心部分RDD， 整个Spark的运行和计算都是围绕RDD进行的。 RDD可以看成一个简单的“数组”， 对其进行操作也只需要调用有限的数组中的方法即可。 它与一般数组的区别在于： RDD是分布式存储， 可以更好地利用现有的云数据平台， 并在内存中运行。

本章笔者将详细介绍RDD的基本原理， 讲原理的时候总是感觉很沉闷， 笔者尽量使用图形方式向读者展示RDD的基本原理。 本章也向读者详细介绍RDD的常用方法， 介绍这些方法时与编程实战结合起来， 为后续的各种编程实战操作奠定基础。  

## 3.1 RDD是什么

RDD是Resilient Distributed Datasets的简称， 翻译成中文为“弹性分布式数据集”， 这个语义揭示了RDD实质上是存储在不同节点计算机中的数据集。 分布式存储最大的好处是可以让数据在不同的工作节点上并行存储， 以便在需要数据的时候并行运算， 从而获得最迅捷的运行效率。  

### 3.1.1 RDD名称的秘密

Resilient是弹性的意思。 在Spark中， 弹性指的是数据的存储方式，即数据在节点中进行存储时候， 既可以使用内存也可以使用磁盘。 这为使用者提供了很大的自由， 提供了不同的持久化和运行方法， 有关这点， 我们会在后面详细介绍。

除此之外， 弹性还有一个意思， 即RDD具有很强的容错性。 这里容错性指的是Spark在运行计算的过程中， 不会因为某个节点错误而使得整个任务失败。 不同节点中并发运行的数据， 如果在某一个节点发生错误时， RDD会自动将其在不同的节点中重试。 关于RDD的容错性， 这里尽量避免理论化探讨， 尽量讲解得深入一些， 毕竟这本书是以实战为主。

关于分布式数据的容错性处理是涉及面较广的问题， 较为常用的方法主要是两种：  

- 检查节点
- 更新记录

检查节点的方法是对每个数据节点逐个进行检测， 随时查询每个节点的运行情况。 这样做的好处是便于操作主节点随时了解任务的真实数据运行情况， 而坏处在于由于系统进行的是分布式存储和运算， 节点检测的资源耗费非常大， 而且一旦出现问题， 需要将数据在不同节点中搬运， 反而更加耗费时间从而极大地拉低了执行效率。

更新记录指的是运行的主节点并不总是查询每个分节点的运行状态， 而是将相同的数据在不同的节点（一般情况下是3个） 中进行保存， 各个工作节点按固定的周期更新在主节点中运行的记录， 如果在一定时间内主节点查询到数据的更新状态超时或者有异常， 则在存储相同数据的不同节点上重新启动数据计算工作。 其缺点在于如果数据量过大， 更新数据和重新启动运行任务的资源耗费也相当大。  

### 3.1.2 RDD特性

前面已经介绍， RDD是一种分布式弹性数据集， 将数据分布存储在不同节点的计算机内存中进行存储和处理。 每次RDD对数据处理的最终结果， 都分布存放在不同的节点中。 这样的话， 在进行到下一步数据处理工作时， 数据可以直接从内存中提取， 从而省去了大量的IO操作， 这对于传统的MapReduce操作来说， 更便于使用迭代运算提升效率。

RDD的另外一大特性是延迟计算， 即一个完整的RDD运行任务被分成两部分： Transformation和Action。  

**1. Transformation**

Transformation 用于对RDD的创建。 在Spark中， RDD只能使 Transformation 来创建， 同时Transformation还提供了大量的操作方法，例如map、 filter、 groupBy、 join等操作来对RDD进行处理。 除此之外 RDD可以利用Transformation来生成新的RDD， 这样可以在有限的内存空间中生成尽可能多的数据对象。 但是有一点请读者牢记， 无论发生了多少次Transformation， 在RDD中真正数据计算运行的操作Action都不可能真正运行。

**2． Action**

Action是数据的执行部分， 其通过执行count、 reduce、 collect等方法去真正执行数据的计算部分。 实际上， RDD中所有的操作都是使用的Lazy模式进行， Lazy是一种程序优化的特殊形式。 运行在编译的过程中不会立刻得到计算的最终结果， 而是记住所有的操作步骤和方法， 只有显式地遇到启动命令才进行计算。这样做的好处在于大部分的优化和前期工作在Transformation中已经执行完毕， 当Action进行工作时， 只需要利用全部自由完成业务的核心工作。   

### 3.1.3 与其他分布式共享内存的区别

可能有读者在以前的学习或工作中了解到， 分布式共享内存（Distributed Shared Memory， 简称DSM） 系统是一种较为常用的分布式框架。 在架构完成的DSM系统中， 用户可以向框架内节点的任意位置进行读写操作。 这样做有非常大的便捷性， 可以使得数据脱离本地单节点束缚， 但是在进行大规模计算时， 对容错性容忍程度不够， 常常因为一个节点产生错误而使得整个任务失败。

RDD与一般DSM有很大的区别， 首先RDD在框架内限制了批量读写数据的操作， 有利于整体的容错性提高。 此外， RDD并不单独等待某个节点任务完成， 而是使用“更新记录”的方式去主动性维护任务的运行， 在某一个节点中任务失败， 而只需要在存储数据的不同节点上重新运行即可。  

> **提示**
> 建议读者将RDD与DSM异同点列出做个对比查阅。 因为不是本章重点， 请读者自行完成。  

### 3.1.4 RDD缺陷

在前面已经说过， RDD相对于一般的DSM， 更加注重与批量数据的读写， 并且将优化和执行进行分类。 通过Transformation生成多个RDD， 当其在执行Action时， 主节点通过“记录查询”的方式去确保任务的政策执行。

但是由于这些原因， 使得RDD并不适合作为一个数据的存储和抓取框架， 因为RDD主要执行在多个节点中的批量操作， 即一个简单的写操作也会分成两个步骤进行， 这样反而会降低运行效率。 例如一般网站中的日志文件存储， 更加适合使用一些传统的MySQL数据库进行存储，而不适合采用RDD。  

## 3.2 RDD工作原理

RDD是一个开创性的数据处理模式， 其脱离了单纯的MapReduce的分布设定、 整合、 处理的模式， 而采用了一个新颖的、 类似一般数组或集合的处理模式， 对存储在分布式存储空间上的数据进行操作。 

### 3.2.1 RDD工作原理图 

前面笔者已经说了很多次， RDD可以将其看成一个分布在不同节点
中的分布式数据集， 并将数据以数据块（Block） 的形式存储在各个节
点的计算机中， 整体布局如图3-2所示。  

~~~mermaid
graph RL
    BlockSlave1 --- BlockMaster
    BlockSlave2 --- BlockMaster
    BlockSlave3 --- BlockMaster
	
	BlockNode1 --> BlockSlave1
	BlockNode2 --> BlockSlave1
	BlockNode3 --> BlockSlave2
	BlockNode4 --> BlockSlave2
	BlockNode5 --> BlockSlave3
	BlockNode6 --> BlockSlave3
~~~

从图上可以看到， 每个BlockMaster管理着若干个BlockSlave， 而每个BlockSlave又管理着若干个BlockNode。 当BlockSlave获得了每个Node节点的地址， 会又反向BlockMaster注册每个Node的基本信息， 这样形成分层管理。

而对于某个节点中存储的数据， 如果使用频率较多， 则BlockMaster会将其缓存在自己的内存中， 这样如果以后需要调用这些数据， 则可以直接从BlockMaster中读取。 对于不再使用的数据， BlcokMaster会向BlockSlave发送一组命令予以销毁。

### 3.2.2 RDD的相互依赖

不知道读者在看图3-1的时候有没有注意到， Transformation在生成RDD的时候， 生成的是多个RDD， 这里的RDD的生成方式并不是一次性生成多个， 而是由上一级的RDD依次往下生成， 我们将其称为依赖。

RDD依赖生成的方式也不尽相同， 在实际工作中， RDD一般由两种方式生成： 宽依赖（wide dependency） 和窄依赖（narrow dependency） ， 两者区别请参考图3-3所示。  

RDD作为一个数据集合， 可以在数据集之间逐次生成， 这种生成关系称为依赖关系。 从图3-3可以看到， 如果每个RDD的子RDD只有一个父RDD， 而同时父RDD也只有一个子RDD时， 这种生成关系称之为窄依赖。 而多个RDD相互生成， 则称之为宽依赖。

宽依赖和窄依赖在实际应用中有着不同的作用。 窄依赖便于在单一节点上按次序执行任务， 使任务可控。 而宽依赖更多的是考虑任务的交互和容错性。 这里没有好坏之分， 具体选择哪种方式需要根据具体情况处理。  

## 3.3 RDD应用API详解

本书的目的是教会读者在实际运用中使用RDD去解决相关问题， 因此笔者建议读者更多地将注重点转移到真实的程序编写上。

本节将带领大家学习RDD的各种API用法， 读者尽量掌握这些RDD的用法。 当然本节的内容可能有点多， 读者至少要对这些API有个印象， 在后文的数据分析时需要查询某个具体方法的用法时再回来查看。  

### 3.3.1 使用aggregate方法对给定的数据集进行方法设定

RDD中比较常见的一种方式是aggregate方法， 其功能是对给定的数据集进行方法设定， 源码如下：

~~~scala
def aggregate[U: ClassTag](zeroValue: U)(seqOp:
(U, T) => U, combOp: (U, U) =>U): U
~~~

从源码可以看到， aggregate定义了几个泛型参数。 U是数据类型，可以传入任意类型的数据。 seqOp是给定的计算方法， 输出结果要求也是U类型， 而第二个combOp是合并方法， 将第一个计算方法得出的结果与源码中zeroValue进行合并。 需要指出的是： zeroValue并不是一个固定的值， 而是一个没有实际意义的“空值”， 它没有任何内容， 而是确认传入的结果。具体程序编写如程序3-1所示。

~~~scala
import org.apache.spark.{SparkContext, SparkConf} 
object testRDDMethod { 
    def main(args: Array[String]) { 
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理
        .setAppName("testRDDMethod") //设定名称 
        val sc = new SparkContext(conf) //创建环境变量实例 
        val arr = sc.parallelize(Array(1,2,3,4,5,6)) //输入数组数据集 
        val result = arr.aggregate(0)(math.max(_, _), _ + _)//使用 aggregate 方法 
        println(result) //打印结果 
    } 
}
~~~

RDD工作在Spark上，因此，parallelize方法是将内存数据读入Spark系统中，作为一个整体数据集。下面的math.max方法用于比较数据集中数据的大小，第二个“`_+_`”方法是对传递的第一个比较方法结果进行处理。

### 3.3.2 提前计算的cache方法

cache方法的作用是将数据内容计算并保存在计算节点的内存中。这个方法的使用是针对Spark的Lazy数据处理模式。

在Lazy模式中， 数据在编译和未使用时是不进行计算的， 而仅仅保存其存储地址， 只有在Action方法到来时才正式计算。 这样做的好处在于可以极大地减少存储空间， 从而提高利用率， 而有时必须要求数据进行计算， 此时就需要使用cache方法， 其使用方法如程序3-4所示。  

~~~scala
import org.apache.spark.{SparkContext, SparkConf} 
object CacheTest { 
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理
        .setAppName("CacheTest ") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        val arr = sc.parallelize(Array("abc","b","c","d","e","f")) // 设定数据集 
        println(arr) //打印结果 
        println("————————————————") //分隔符 
        println(arr.cache()) //打印结果 
    } 
}
~~~

这里分隔符分割了相同的数据，分别是未使用cache方法进行处理的数据和使用cache方法进行处理的数据，其结果如下：

~~~
ParallelCollectionRDD[0] at parallelize at CacheTest.scala：12 
———————————————— 
abc,b,c,d,e,f
~~~

从结果中可以看到，第一行打印结果是一个RDD存储格式，而第二行打印结果是真正的数据结果。

需要说明的是：除了使用cache方法外，RDD还有专门的采用迭代形式打印数据的专用方法

`arr.foreach(println)`是一个专门用来打印未进行Action操作的数据的专用方法，可以对数据进行提早计算。

### 3.3.3 笛卡尔操作的cartesian方法

此方法是用于对不同的数组进行笛卡尔操作， 要求是数据集的长度必须相同， 结果作为一个新的数据集返回。 其使用方法如程序3-6所示。  

~~~scala
import org.apache.spark.{SparkContext, SparkConf} 
object Cartesian{ 
    def main(args: Array[String]) { 
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理
        .setAppName("Cartesian ") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        var arr = sc.parallelize(Array(1,2,3,4,5,6)) //创建第一个数组
        var arr2 = sc.parallelize(Array(6,5,4,3,2,1)) //创建第二个数据
        val result = arr.cartesian(arr2) //进行笛卡尔计算
        result.foreach(print) //打印结果 
    } 
}
~~~

打印结果如下： 

~~~
(1,6)(1,5)(1,4)(1,3)(1,2)(1,1)(2,6)(2,5)(2,4)(2,3)(2,2)(2,1)(3,6)(3,5)(3,4)(3,3)(3,2)(3,1)(4,6)(4,5)(4,4)(4,3)(4,2)(4,1)(5,6)(5,5)(5,4)(5,3)(5,2)(5,1)(6,6)(6,5)(6,4)(6,3)(6,2)(6,1) 
~~~

### 3.3.4 分片存储的coalesce方法

Coalesce方法是将已经存储的数据重新分片后再进行存储， 其源码如下：

~~~scala
def coalesce(numPartitions: Int, shuffle: Boolean = false)(implicit ord: Ordering[T] = null): RDD[T]
~~~

这里的第一个参数是将数据重新分成的片数， 布尔参数指的是将数据分成更小的片时使用， 举例中将其设置为true， 程序代码如3-7所示。  

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object Coalesce{
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量 
        .setMaster("local") //设置本地化处理
        .setAppName("Coalesce ") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        val arr = sc.parallelize(Array(1,2,3,4,5,6)) //创建数据集
        val arr2 = arr.coalesce(2,true) //将数据重新分区
        val result = arr.aggregate(0)(math.max(_, _), _ + _) // 计算数据值
        println(result) //打印结果
        //计算重新分区数据值
        val result2 = arr2.aggregate(0)(math.max(_, _), _ + _) 
        println(result2) //打印结果 
    } 
}
~~~

除此之外，RDD中还有一个repartition方法与这个coalesce方法类似，均是将数据重新分区组合，其使用方法如程序3-8所示。 

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object Repartition {
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量 
        .setMaster("local") //设置本地化处理
        .setAppName("Repartition") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        val arr = sc.parallelize(Array(1,2,3,4,5,6)) //创建数据集
        arr = arr.repartition(3) //重新分区
        println(arr.partitions.length) //打印分区数
    }
}
~~~

### 3.3.5 以value计算的countByValue方法

countByValue方法是计算数据集中某个数据出现的个数， 并将其以map的形式返回。   

~~~scala
import org.apache.spark.{SparkContext, SparkConf} 
object countByValue{
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量 
        .setMaster("local") //设置本地化处理 
        .setAppName("countByValue") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        val arr = sc.parallelize(Array(1,2,3,4,5,6)) //创建数据集 val
        result = arr.countByValue() //调用方法计算个数 
        result.foreach(print) //打印结果
    }
}
~~~

最终结果如下： 

~~~
(5,1)(1,1)(6,1)(2,1)(3,1)(4,1) 
~~~

### 3.3.6 以key计算的countByKey方法

countByKey方法与countByValue方法有本质的区别。 countByKey是计算数组中元数据键值对key出现的个数， 具体见程序3-10所示。

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object countByKey{
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理 
        .setAppName("countByKey") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        //创建数据集
        var arr = sc.parallelize(Array((1, "cool"), (2, "good"), (1, "bad"), (1,"fine")))
        val result = arr.countByKey() //进行计数
        result.foreach(print) // 打印结果
    }
}
~~~

打印结果如下： 

~~~
(1,3)(2,1) 
~~~

从打印结果可以看到，这里计算了数据键值对的key出现的个数， 即1出现了3次，2出现了1次。 

### 3.3.7 除去数据集中重复项的distinct方法

distinct方法的作用是去除数据集中重复的项， 如程序3-11所示。

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object distinct{
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理
        .setAppName("distinct") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        var arr = sc.parallelize(Array(("cool"), ("good"), ("bad"), ("fine"),("good"),("cool"))) //创建数据集
        val result = arr.distinct() //进行去重操作 
        result.foreach(println) //打印最终结果
    }
}
~~~

打印结果如下： 

~~~
cool fine bad good 
~~~

### 3.3.8 过滤数据的filter方法

filter方法是一个比较常用的方法， 它用来对数据集进行过滤， 如程序3-12所示。

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object filter{
    def main(args： Array[String]) {
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理
        .setAppName("filter ") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        var arr = sc.parallelize(Array(1,2,3,4,5)) //创建数据集
        val result = arr.filter(_ >= 3) //进行筛选工作 
        result.foreach(println) //打印最终结果
    }
}
~~~

这里需要说明的是，在filter方法中，使用的方法是“`_ >= 3`”，这里调用了Scala编程中的编程规范，下划线`_`的作用是作为占位符标记所有的传过来的数据。在此方法中，数组的数据（1,2,3,4,5）依次传进来替代了占位符。 

### 3.3.9 以行为单位操作数据的flatMap方法

flatMap方法是对RDD中的数据集进行整体操作的一个特殊方法，因为其在定义时就是针对数据集进行操作， 因此最终返回的也是一个数据集。 flatMap方法应用程序如3-13所示。  

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object filter{
    def main(args： Array[String]) {
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理
        .setAppName("filter ") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        var arr = sc.parallelize(Array(1,2,3,4,5)) //创建数据集
        val result = arr.filter(_ >= 3) //进行筛选工作
        result.foreach(println) //打印最终结果
    }
}
~~~

### 3.3.10 以单个数据为目标进行操作的map方法

map方法可以对RDD中的数据集中的数据进行逐个操作， 它与flatmap不同之处在于， flatmap是将数据集中的数据作为一个整体去处理， 之后再对其中的数据做计算。 而map方法直接对数据集中的数据做单独的处理。 map方法应用程序如3-14所示。  

~~~scala
import org.apache.spark.{SparkContext, SparkConf} 
object flatMap{ 
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量 
        .setMaster("local") //设置本地化处理
        .setAppName("flatMap") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        var arr = sc.parallelize(Array(1,2,3,4,5)) //创建数据集
        val result = arr.flatMap(x => List(x + 1)).collect() // 进行数据集计算
        result.foreach(println) //打印结果
    }
}
~~~

### 3.3.11 分组数据的groupBy方法

groupBy方法是将传入的数据进行分组， 其分组的依据是作为参数传入的计算方法。 groupBy方法的程序代码如3-15所示。

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object groupBy{
    def main(args： Array[String]) {
        val conf = new SparkConf() //创建环境变量 
        .setMaster("local") //设置本地化处理
        .setAppName("groupBy") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        var arr = sc.parallelize(Array(1,2,3,4,5)) //创建数据集
        arr.groupBy(myFilter(_), 1) //设置第一个分组
        arr.groupBy(myFilter2(_), 2) //设置第二个分组
    }
    def myFilter(num：Int)：Unit = { //自定义方法
        num >=3 // 条件
    } 
    def myFilter2(num：Int)：Unit = { //自定义方法
        num <3 //条件 
    }
}
~~~

在程序3-15中，笔者采用了两个自定义的方法，即myFilter和 myFilter2作为分组条件。然后将分组条件的方法作为一个整体传入 groupBy中。 

groupBy的第一个参数是传入的方法名，而第二个参数是分组的标签值。

### 3.3.12 生成键值对的keyBy方法

keyBy方法是为数据集中的每个个体数据增加一个key， 从而可以与原来的个体数据形成键值对。 keyBy方法程序代码如3-16所示。

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object keyBy{
    def main(args： Array[String]) {
        val conf = new SparkConf() //创建环境变量 
        .setMaster("local") //设置本地化处理
        .setAppName("keyBy") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        //创建数据集
        var str = sc.parallelize(Array("one","two","three","four","five")) 
        val str2 = str.keyBy(word => word.size) //设置配置方法
        str2.foreach(println) //打印结果
    }
}
~~~

最终打印结果如下： 

~~~
(3,one)(3,two)(5,three)(4,four)(4,five) 
~~~

这里可以很明显地看出，每个数据（单词）与自己的字符长度形成一个数字键值对。 

### 3.3.13 同时对两个数据进行处理的reduce方法

reduce方法是RDD中一个较为重要的数据处理方法， 与map方法不同之处在于， 它在处理数据时需要两个参数。 reduce方法演示如程序3-17所示。  

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object testReduce {
    def main(args： Array[String]) {
        val conf = new SparkConf() //创建环境变量 
        .setMaster("local") //设置本地化处理 
        .setAppName("testReduce") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        var str =
sc.parallelize(Array("one","two","three","four","five"))// 创建数据集
        val result = str.reduce(_ + _) //进行数据拟合 
        result.foreach(print) //打印数据结果
    }
}
~~~

打印结果如下： 

~~~
onetwothreefourfive
~~~

从结果上可以看到，reduce方法主要是对传入的数据进行合并处理。它的两个下划线分别代表不同的内容，第一个下划线代表数据集的第一个数据，而第二个下划线在第一次合并处理时代表空集，即以下方式进行：

~~~
null + one -> one + two -> onetwo + three -> onetwothree + four -> onetwothreefour+ five 
~~~

除此之外，reduce方法还可以传入一个已定义的方法作为数据处理方法，程序3-18中演示了一种寻找最长字符串的一段代码。 

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object testRDDMethod {
    def main(args： Array[String]) {
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理
        .setAppName("testReduce2") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        //创建数据集
        var str = sc.parallelize(Array("one","two","three","four","five"))
        val result = str.reduce(myFun) //进行数据拟合
        result.foreach(print) //打印结果
    }
    def myFun(str1： String,str2：String)：String = { //创建方法
        var str = str1 //设置确定方法
        if(str2.size >= str.size){ //比较长度
            str = str2 //替换
        }
        return str //返回最长的那个字符串
    }
}
~~~

### 3.3.14 对数据进行重新排序的sortBy方法

sortBy方法也是一个常用的排序方法， 其主要功能是对已有的RDD重新排序， 并将重新排序后的数据生成一个新的RDD， 其源码如下：  

~~~scala
sortBy[K](f: (T) ? K, ascending: Boolean = true, numPartitions: Int = this.partitions.size)
~~~

从源码上可以看到， sortBy方法主要有3个参数， 第一个为传入方法， 用以计算排序的数据。 第二个是指定排序的值按升序还是降序显示。 第三个是分片的数量。  程序3-19中演示了分别根据不同的数据排序方法对数据集进行排序的代码。  

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object sortBy {
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量
        .setMaster("local") //设置本地化处理
        .setAppName("sortBy") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        //创建数据集
        var str =sc.parallelize(Array((5,"b"),(6,"a"),(1,"f"), (3,"d"),(4,"c"),(2,"e")))
        str = str.sortBy(word => word._1,true) //按第一个数据排序
        val str2 = str.sortBy(word => word._2,true) //按第二个数据排序
        str.foreach(print) //打印输出结果
        str2.foreach(print) //打印输出结果
    }
}
~~~

从程序3-19可以看到，在程序的排序部分，分别使用了按元组第一个字符排序和按第二个字符排序的方法。这里需要说明的是，“`._1`”的格式是元组中数据符号的表示方法，意思是使用当前元组中第一个数据， 同样的表示，“`._2`”是使用元组中第二个数据。 

最终显示结果如下： 

~~~
(1,f)(2,e)(3,d)(4,c)(5,b)(6,a) //第一个输出结果
(6,a)(5,b)(4,c)(3,d)(2,e)(1,f) //第二个输出结果
~~~

从结果可以很清楚地看到，第一个输出结果以数字为顺序进行排序，第二个输出结果以字母为顺序进行排序。 

### 3.3.15 合并压缩的zip方法

zip方法是常用的合并压缩算法， 它可以将若干个RDD压缩成一个新的RDD， 进而形成一系列的键值对存储形式的新RDD。具体程序见3-20。

~~~scala
import org.apache.spark.{SparkContext, SparkConf}
object testZip{
    def main(args: Array[String]) {
        val conf = new SparkConf() //创建环境变量 
        .setMaster("local") //设置本地化处理
        .setAppName("testZip") //设定名称
        val sc = new SparkContext(conf) //创建环境变量实例
        val arr1 = Array(1,2,3,4,5,6) //创建数据集1
        val arr2 = Array("a","b","c","d","e","f") //创建数据集2
        val arr3 = Array("g","h","i","j","k","l") //创建数据集3
        val arr4 = arr1.zip(arr2).zip(arr3) //进行压缩算法
        arr4.foreach(print) //打印结果
    }
}
~~~

最终结果如下： 

~~~
((1,a),g)((2,b),h)((3,c),i)((4,d),j)((5,e),k) ((6,f),l)
~~~

从结果可以看到，这里数据被压缩成一个双重的键值对形式的数据

# 第4章 MLlib基本概念

## 4.1 MLlib基本数据类型

RDD是MLlib专用的数据格式， 它参考了Scala函数式编程思想， 并大胆引入统计分析概念， 将存储数据转化成向量和矩阵的形式进行存储和计算， 这样将数据定量化表示， 能更准确地整理和分析结果。 本节将研究介绍这些基本的数据类型和使用方法。  

### 4.1.1 多种数据类型

MLlib先天就支持较多的数据格式， 从最基本的Spark数据集RDD到部署在集群中的向量和矩阵。 同样， MLlib还支持部署在本地计算机中的本地化格式。 表4-1给出了MLlib支持的数据类型。  

| 类型名称           | 释义                                                 |
| ------------------ | ---------------------------------------------------- |
| Local vector       | 本地向量集。主要向Spark提供一组可进行操作的数据集合  |
| Labeled point      | 向量标签。让用户能够分类不同的数据集合               |
| Local matrix       | 本地矩阵。将数据集合以矩阵形式存储在本地计算机中     |
| Distributed matrix | 分布式矩阵。将数据集合以矩阵形式存储在分布式计算机种 |

以上就是MLlib支持的数据类型， 其中分布式矩阵根据不同的作用和应用场景， 又分为四种不同的类型（在4.1.5小节介绍） 。 下面笔者将带领大家对每个数据类型进行分析。  

### 4.1.2 从本地向量集起步

# 第6章 MLlib线性回归理论与实战

回归分析（regression analysis） 是一种用来确定两种或两种以上变量间相互依赖的定量关系的统计分析方法， 运用十分广泛。 回归分析可以按以下要素分类：

- 按照涉及的自变量的多少， 分为回归和多重回归分析；
- 按照自变量的多少， 可分为一元回归分析和多元回归分析；
- 按照自变量和因变量之间的关系类型， 可分为线性回归分析和非线性回归分析。

如果在回归分析中， 只包括一个自变量和一个因变量， 且二者的关系可用一条直线近似表示， 这种回归分析称为一元线性回归分析。 如果回归分析中包括两个或两个以上的自变量， 且因变量和自变量之间是线性关系， 则称为多重线性回归分析。

回归分析是最常用的机器学习算法之一， 可以说回归分析理论与实际研究的建立使得机器学习作为一门系统的计算机应用学科得以确认。

MLlib中， 线性回归是一种能够较为准确预测具体数据的回归方法， 它通过给定的一系列训练数据， 在预测算法的帮助下预测未知的数据。

本章将向读者介绍线性回归的基本理论与MLlib中使用的预测算法， 以及为了防止过度拟合而进行的正则化处理， 这些不仅仅是回归算法的核心， 也是MLlib的最核心部分。  

本章主要知识点：

- 随机梯度下降算法详解
- MLlib回归的过拟合
- MLlib线性回归实战  

## 6.1 随机梯度下降算法详解

机器学习中回归算法的种类有很多， 例如神经网络回归算法、 蚁群回归算法、 支持向量机回归算法等， 这些都可以在一定程度上达成回归拟合的目的。

MLlib中使用的是较为经典的随机梯度下降算法， 它充分利用了Spark框架的迭代计算特性， 通过不停地判断和选择当前目标下的最优路径， 从而能够在最短路径下达到最优的结果， 继而提高大数据的计算效率。  

### 6.1.1 道士下山的故事

如果想以最快的速度下山， 那么最快的办法就是顺着坡度最陡峭的地方走下去。 但是由于不熟悉路， 道士在下山的过程中， 每走过一段路程需要停下来观望， 从而选择最陡峭的下山路线。 这样一路走下来的话， 可以在最短时间内走到山脚。  

随机梯度下降算法和这个类似， 如果想要使用最迅捷的方法， 那么最简单的办法就是在下降一个梯度的阶层后， 寻找一个当前获得的最大坡度继续下降。 这就是随机梯度算法的原理。  

### 6.1.2 随机梯度下降算法的理论基础

从上一小节的例子可以看到， 随机梯度下降算法就是不停地寻找某个节点中下降幅度最大的那个趋势进行迭代计算， 直到将数据收缩到符合要求的范围为止。 它可以用数学公式表达如下：
$$
f(\theta) = \theta_0x_0 + \theta_1x_1 + \dots + \theta_nx_n = \sum \theta_ix_i
$$
在上一章介绍最小二乘法的时候， 笔者通过最小二乘法说明了直接求解最优化变量的方法， 也介绍了在求解过程中的前提条件是要求计算值与实际值的偏差的平方最小。

但是在随机梯度下降算法中， 对于系数需要通过不停地求解出当前位置下最优化的数据。 这句话通过数学方式表达的话就是不停地对系数θ求偏导数。 即公式如下：  
$$
\frac {\partial}{\partial\theta} f(\theta) = \frac{\partial}{\partial\theta}\frac{1}{2} \sum(f(\theta)-y_i)2 = (f(\theta) - y)x_i
$$
公式中θ会向着梯度下降的最快方向减少， 从而推断出θ的最优解。因此可以说随机梯度下降算法最终被归结为通过迭代计算特征值从而求出最合适的值。 θ求解的公式如下：  
$$
\theta = \theta - \alpha(f(\theta) - y_i)x_i
$$
公式中$\alpha$是下降系数， 用较为通俗的话来说就是用以计算每次下降的幅度大小。 系数越大则每次计算中差值越大， 系数越小则差值越小，但是计算时间也相对延长。  

### 6.1.3 随机梯度下降算法实战

实现随机梯度下降算法的关键是拟合算法的实现。 而本例的拟合算法实现较为简单， 通过不停地修正数据值从而达到数据的最优值。 具体实现代码如程序6-1所示：    

~~~scala
import scala.collection.mutable.HashMap 
object SGD { 
    val data = HashMap[Int,Int]() //创建数据集 def
    getData()： HashMap[Int,Int] = { 
        //生成数据集内容
        for(i <- 1 to 50){ //创建50个数据 
            data += (i -> (12*i)) //写入公式
            y=2x 
        } 
        data //返回数据集 
    } 
    var θ ： Double = 0 //第一步假设 θ 为0 
    var α ： Double = 0.1 //设置步进系数 
    def sgd(x： Double,y： Double) = {
        //设置迭代公式 
        θ = θ - α * ( (θ *x) - y) //迭代公式
	} 
    def main(args： Array[String]) {
        val dataSource = getData() //获取数据集 
        dataSource.foreach(myMap =>{
            //开始迭代 
            sgd(myMap._1,myMap._2) //输入数据 
        })
		println("最终结果 θ 值为" + θ ) //显示结果 
    } 
}
~~~

## 6.2 MLlib回归的过拟合

有计算就有误差， 误差不可怕， 我们需要的是采用何种方法消除误差。

回归分析在计算过程中， 由于特定分析数据和算法选择的原因， 结果会对分析数据产生非常强烈的拟合效果； 而对于测试数据， 却表现得不理想， 这种效果和原因称为过拟合。 本节将分析过拟合产生的原因和效果， 并给出一个处理手段供读者学习和掌握。  

### 6.2.1 过拟合产生的原因

在上一节的最后， 我们建议和鼓励读者对数据的量进行调整从而获得更多的拟合修正系数。 相信读者也发现， 随着数据量的增加， 拟合的系数在达到一定值后会发生较大幅度的偏转。 在上一节程序6-1的例子中， 步进系数在0.1的程度下， 数据量达到70以后就发生偏转。 产生这样原因就是MLlib回归会产生过拟合现象。  

如果测试数据过于侧重某些具体的点， 则会对整体的曲线形成构成很大的影响， 从而影响到待测数据的测试精准度。 这种对于测试数据过于接近而实际数据拟合程度不够的现象称为过拟合， 而解决办法就是对数据进行处理， 而处理过程称为回归的正则化。  

正则化使用较多的一般有两种方法， lasso回归（L1回归） 和岭回归（L2回归） 。 其目的是通过对最小二乘估计加入处罚约束， 使某些系数的估计为0。  

更加直观的理解就是， 防止通过拟合算法最后计算出的回归公式比较大地响应和依赖某些特定的特征值， 从而影响回归曲线的准确率。  

### 6.2.2 lasso回归与岭回归

由前面对过拟合产生的原因分析来看， 如果能够消除拟合公式中多余的拟合系数， 那么产生的曲线可以较好地对数据进行拟合处理。 因此可以认为对拟合公式过拟合的消除最直接的办法就是去除其多余的公式， 那么通过数学公式表达如下：
$$
f(B') = f(B) + J(\theta)
$$
从公式可以看到， f(B')是f(B)的变形形式， 其通过增加一个新的系数公式J(θ)从而使原始数据公式获得了正则化表达。 这里J(θ)又称为损失函数， 它通过回归拟合曲线的范数L1和L2与一个步进数α相乘得到。

范数L1和范数L2是两种不同的系数惩罚项， 首先来看L1范数。L1范数指的是回归公式中各个元素的绝对值之和， 其又称为“稀疏规则算子（Lasso regularization） ”。 其一般公式如下：  
$$
J(\theta) = \alpha \times ||x||
$$
即可以通过这个公式计算使得f(B')能够取得最小化。

而L2范数指的是回归公式中各个元素的平方和， 其又称为“岭回归（Ridge Regression） ”可以用公式表示为：  
$$
J(\theta) = \alpha \sum x^2
$$

> **提示**
> MLlib中SGD算法支持L1和L2正则化方法， 而LBFGS只支持L2正则化， 不支持L1正则化。  

L1范数和L2范数相比较而言， L1能够在步进系数α在一定值的情况下将回归曲线的某些特定系数修正为0。 而L1回归由于其平方的处理方法从而使得回归曲线获得较高的计算精度。  

## 6.3 MLlib线性回归实战

### 6.3.1 MLlib线性回归基本准备

### 6.3.2 MLlib线性回归实战： 商品价格与消费者收入之间的关系

### 6.3.3 对拟合曲线的验证

# 第7章 MLlib分类实战

本章开始进入MLlib算法中的一个新的领域——分类算法。 分类算法又称为分类器， 是数据挖掘和机器学习领域中的一个非常重要的分支和方向， 它原本是统计分析中的一个工具， 而近年来随着统计学应用的广泛推进， 分类算法得到越来越多的应用， 大数据的分类是分类算法的未来应用趋势。

目前， MLlib中分类算法在全部算法中占据了非常重要的部分， 其中包括逻辑回归、 支持向量机（SVM） 、 贝叶斯分类器等， 它们包含的一些基本理论和算法， 将在本章着重进行介绍。

本章有些算法理论部分较为深奥， 我们将侧重于在工程应用方面为读者做通俗易懂的解释， 希望能够帮助读者在掌握算法使用方法的情况下了解其背后的原理。

本章主要知识点：

- 逻辑回归
- 支持向量机
- 朴素贝叶斯  

## 7.1 逻辑回归详解

逻辑回归和线性回归类似， 但它不属于回归分析家族， 差异主要是在于变量不同， 因此其解法和生成曲线也不尽相同。

MLlib中将逻辑回归归类在分类算法中， 也是无监督学习的一个重要算法， 本节将主要介绍其基本理论和算法示例。  

### 7.1.1 逻辑回归不是回归算法

逻辑回归并不是回归算法， 而是分类算法。

逻辑回归是目前数据挖掘和机器学习领域中使用较为广泛的一种对数据进行处理的算法， 一般用于对某些数据或事物的归属及可能性进行评估。 目前较为广泛地应用在流行病学中， 比较常用的情形是探索某疾病的危险因素， 根据危险因素预测某疾病发生的概率等。

例如， 想探讨胃癌发生的危险因素， 可以选择两组人群， 一组是胃癌组， 一组是非胃癌组， 两组人群肯定有不同的体征和生活方式等。 这里的因变量就是是否胃癌， 即“是”或“否”， 为两分类变量， 自变量就可以包括很多了， 例如年龄、 性别、 饮食习惯、 幽门螺杆菌感染等。 自变量既可以是连续的， 也可以是分类的。

再一次提醒， 逻辑回归并不是回归算法， 而是用来分类的一种算法， 特别是用在二分分类中。

在上一章中， 笔者向读者演示了使用线性回归对某个具体数据进行预测的方法， 虽然可以看到， 在二元或者多元的线性回归计算中， 最终结果与实际相差较大， 但是其能够返回一个具体的预测数据。

但是现实生活中， 某些问题的研究却没有正确的答案。

在前面讨论的胃癌例子中， 尽管收集到了各种变量因素， 但是在胃癌被确诊定性之前， 任何人都无法对某人是否将来会诊断出胃癌做出断言， 而只能说“有可能”患有胃癌。 这个就是逻辑回归， 他不会直接告诉你结果的具体数据而会告诉你可能性是在哪里。  

### 7.1.2 逻辑回归的数学基础

前面的讲解已经知道， 逻辑回归实际上就是对已有数据进行分析从而判断其结果可能是多少， 它可以通过数学公式来表达。  

如果使用传统的(x,y)值的形式标示， 则y为0或者1， x为数据集中数据的特征向量。  

逻辑回归的具体公式如下：  
$$
f(x) = \frac{1}{1+e^{-\theta^Tx}}
$$
与线性回归相同， 这里的θ是逻辑回归的参数， 即回归系数， 如果再将其进一步变形， 使其能够反映二元分类问题的公式， 则公式为：  
$$
f(y=1|x,\theta) = \frac{1}{1+e^{-\theta^Tx}}
$$
这里y值是由已有的数据集中数据和θ共同决定。 实际上这个公式求计算是在满足一定条件下， 最终取值的对数机率， 即由数据集的可能性的比值的对数变换得到。 通过公式表示为 :
$$
log(x) = \ln\frac{f(y=1|x,\theta)}{f(y=0|x,\theta)} = \theta_0 + \theta_1x_1 + \theta_2x_2 + \dots + \theta_nx_n
$$
通过这个逻辑回归倒推公式可以看到， 最终逻辑回归的计算可以转化成数据集的特征向量与系数θ共同完成， 然后求得其加权和作为最终的判断结果。  

由前面数学分析来看， 最终逻辑回归问题又称为对系数θ的求值问题。 回忆本书在讲解线性回归算法求最优化θ值的时候， 通过随机梯度算法能够较为准确和方便地求得其最优值。 这点请读者自行复习一下上一章讲解的内容。  

### 7.1.3 一元逻辑回归示例

~~~scala
import org.apache.spark.mllib.classification.LogisticRegressionWith
import org.apache.spark.mllib.linalg.Vectors 
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.{SparkConf, SparkContext}

object LogisticRegression{
    val conf = new SparkConf() //创建环境变量
    .setMaster("local") //设置本地化处理 
    .setAppName("LogisticRegression ") //设定名称 
    val sc = new SparkContext(conf) //创建环境变量实例 
    def main(args： Array[String]) { 
        val data = sc.textFile("c： /u.txt") //获取数据集路径
        val parsedData = data.map { 
            line => //开始对数据集处理
            val parts = line.split('|') //根据逗号进行分区
            LabeledPoint(parts(0).toDouble, Vectors.dense(parts(1).split("").map(_.toDouble)))
        }.cache() //转化数据格式 
        val model = LogisticRegressionWithSGD.train(parsedData,50) //建立模型 
        val target = Vectors.dense(-1) //创建测试值
        val resulet = model.predict(target) //根据模型计算结果 
        println(resulet) //打印结果 
    } 
}
~~~

Spark的初始化数据读取这里就不再重复， parsedData最终形成了一个LabeledPoint[RDD]形式的数据集， 而model是通过随机梯度下降算法迭代形成的逻辑回归模型， target是待测试数据， result是根据模型求出的结果。  

### 7.1.4 多元逻辑回归示例

在本章开头的胃癌可能性例子中， 对胃癌的影响因素很多， 例如年龄、 性别、 饮食习惯、 幽门螺杆菌感染等。 而在判断其可能性的时候，需要综合考虑多种因素， 因此在进行数据回归分析时， 并不能简单地使用一元逻辑回归。

本小节采用的例子是MLlib中自带的数据集sample_libsvm_data.txt，其内容格式如图7-1所示。  

在这里首先介绍一下libSVM的数据格式：

~~~
Label 1： value 2： value ...
~~~

Label是类别的标识， 比如图中的0或者1， 可根据需要自己随意定， 比如100， 20， 13。 本例子由于是做的回归分析， 那么其定义为0或者1。

Value是要训练的数据， 从分类的角度来说就是特征值， 数据之间使用空格隔开。 而每个“： ”用于标注向量的序号和向量值。 例如数据：

~~~
1 1:12 3:7 4:1
~~~

指的是表示为1的那组数据集， 第1个数据值为12， 第3个数据值为7， 第4个数据值为1， 第2个数据缺失。 特征冒号前面的（姑且称做序号） 可以不连续。 这样做的好处可以减少内存的使用， 并提高计算矩阵内积时的运算速度。

线性回归处理完整代码如程序7-2所示。  

~~~scala
import
org.apache.spark.mllib.classification.LogisticRegressionWith
import org.apache.spark.mllib.util.MLUtils 
import org.apache.spark.{SparkConf, SparkContext} 
object LogisticRegression2 { 
    val conf = new SparkConf() //创建环境变量
    .setMaster("local") //设置本地化处理
    .setAppName("LogisticRegression2 ") //设定名称 
    val sc = new SparkContext(conf) //创建环境变量实例 
    def main(args: Array[String]) {
        val data = MLUtils.loadLibSVMFile(sc, "c://sample_libsvm_data.txt") // 读取数据文件 
        val model = LogisticRegressionWithSGD.train(data, 50) //训练数据模型 
        println(model.weights.size) //打印θ 值
        println(model.weights) //打印θ 值个数
        println(model.weights.toArray.filter(_！ = 0).size)
        //打印θ 中不为0的数 
    } 
}
~~~

其中为了更加便于显示， 分别打印了θ中包含0和不包含0的个数，打印结果如下：

~~~
692 418
~~~

692为θ中包含0值的个数， 418为不包含0的个数。  

### 7.1.5 MLlib逻辑回归验证

7.1.4小节中， 笔者使用了自带的例子进行逻辑回归曲线的处理。 根据计算， 获得了θ的个数在不包含0的情况下达到418个， 如此多的数据通过人工手动进行验证是不可能的。 因此需要一个可以自动对其进行验证的功能。

MLlib中MulticlassMetrics类是对数据进行分类的类， 其中包括各种方法。 通过调用其中的precision方法可以对验证数据进行验证。 全部代码如程序7-3所示。  

~~~scala
import
org.apache.spark.mllib.classification.LogisticRegressionWith
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.util.MLUtils 
import org.apache.spark.{SparkConf, SparkContext} 
import org.apache.spark.mllib.evaluation.MulticlassMetrics

object LinearRegression3{
    val conf = new SparkConf()//创建环境变量 
    .setMaster("local") //设置本地化处理
    .setAppName("LogisticRegression3") //设定名称 
    val sc = new SparkContext(conf) //创建环境变量实例 
    def main(args: Array[String]) { 
        val data = MLUtils.loadLibSVMFile(sc, "c://sample_libsvm_data.txt") // 读取数据集 
        val splits = data.randomSplit(Array(0.6, 0.4), seed =
11L)//对数据集切分 
        val parsedData = splits(0) //分割训练数据 
        val parseTtest = splits(1) //分割测试数据
        val model = LogisticRegressionWithSGD.train(parsedData,50)//训练模型
        println(model.weights) //打印θ 值 
        val predictionAndLabels = parseTtest.map { 
            //计算测试值
            case LabeledPoint(label, features) => //计算测试值
            val prediction = model.predict(features) //计算测试值 
            (prediction, label) //存储测试和预测值 
        } 
        val metrics = new MulticlassMetrics(predictionAndLabels)//创建验证类 
        val precision = metrics.precision //计算验证值
        println("Precision = " + precision) //打印验证值 
    } 
}
~~~

从上面代码中可以看到， data.randomSplit将数据集切分为60％的parsedData和40％的parseTtest两部分， 分别用作训练数据集和测试数据集。 之后使用训练数据集对模型进行训练。

通过使用训练结束后的模型对测试机进行实际测试，predictionAndLabels是一个预测值与实际值的RDD向量。 之后再建立MulticlassMetrics类验证测试值和实际值之间的差异。  

### 7.1.6 MLlib逻辑回归实例： 肾癌的转移判断

## 7.2 支持向量机详解