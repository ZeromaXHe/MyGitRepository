# 一、MLlib基本指南

http://spark.apache.org/docs/2.4.8/ml-guide.html

MLlib是Spark的机器学习（ML）库。它的目标是使得机器学习实践变得可扩展和容易。在高层次上，它提供了以下工具：

- ML 算法：常见的学习算法，如分类、回归、聚类和协同过滤
- 特征化：特征提取、变换、降维和选择
- 管道：用于构建、评估和调整 ML 管道的工具
- 持久性：保存和加载算法、模型和管道
- 实用工具：线性代数、统计、数据处理等。

## 声明：基于DataFrame的API是主要API

**基于 MLlib RDD 的 API 现在处于维护模式。**

从 Spark 2.0 开始，`spark.mllib` 包中基于 RDD 的 API 已进入维护模式。 Spark 的主要机器学习 API 现在是 `spark.ml` 包中基于 DataFrame 的 API。

### 有什么影响？

- MLlib 仍将支持 spark.mllib 中基于 RDD 的 API，并修复了错误。
- MLlib 不会向基于 RDD 的 API 添加新功能。
- 在 Spark 2.x 版本中，MLlib 将向基于 DataFrames 的 API 添加功能，以达到与基于 RDD 的 API 相同的功能。
- 在达到功能等价（粗略估计为 Spark 2.3）后，基于 RDD 的 API 将被弃用。
- 预计将在 Spark 3.0 中删除基于 RDD 的 API。

### 为什么 MLlib 切换到基于 DataFrame 的 API？

- DataFrames 提供了比 RDDs 更用户友好的 API。 DataFrames 的许多优点包括 Spark 数据源、SQL/DataFrame 查询、Tungsten 和 Catalyst 优化以及跨语言的统一 API。
- MLlib 的基于 DataFrame 的 API 提供了跨 ML 算法和跨多种语言的统一 API。
- DataFrames 促进了实用的 ML Pipelines，特别是特征转换。 有关详细信息，请参阅管道指南。

### 什么是“Spark ML”？

“Spark ML”不是官方名称，但偶尔用于指代基于 MLlib DataFrame 的 API。 这主要是由于基于 DataFrame 的 API 使用的 `org.apache.spark.ml` Scala 包名称，以及我们最初用来强调管道概念的“Spark ML Pipelines”术语。

### MLlib 已弃用了吗？

不。MLlib 包括基于 RDD 的 API 和基于 DataFrame 的 API。 基于 RDD 的 API 现在处于维护模式。 但是 API 和 MLlib 都没有被弃用。

## 1.1 基础统计

### 1.1.1 相关性

计算两组数据之间的相关性是统计的常见操作。在`spark.ml`中，我们提供了计算多组数据之间成对相关性的灵活手段。支持的相关方法目前有Pearson和Spearman相关。

Correlation类会对输入的Vectors数据组使用特定方法计算相关矩阵。输出包含由向量列组成的相关矩阵的DataFrame对象

~~~java
import java.util.Arrays;
import java.util.List;

import org.apache.spark.ml.linalg.Vectors;
import org.apache.spark.ml.linalg.VectorUDT;
import org.apache.spark.ml.stat.Correlation;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.types.*;

List<Row> data = Arrays.asList(
  RowFactory.create(Vectors.sparse(4, new int[]{0, 3}, new double[]{1.0, -2.0})),
  RowFactory.create(Vectors.dense(4.0, 5.0, 0.0, 3.0)),
  RowFactory.create(Vectors.dense(6.0, 7.0, 0.0, 8.0)),
  RowFactory.create(Vectors.sparse(4, new int[]{0, 3}, new double[]{9.0, 1.0}))
);

StructType schema = new StructType(new StructField[]{
  new StructField("features", new VectorUDT(), false, Metadata.empty()),
});

Dataset<Row> df = spark.createDataFrame(data, schema);
Row r1 = Correlation.corr(df, "features").head();
System.out.println("Pearson correlation matrix:\n" + r1.get(0).toString());

Row r2 = Correlation.corr(df, "features", "spearman").head();
System.out.println("Spearman correlation matrix:\n" + r2.get(0).toString());
~~~

### 1.1.2 假设检验

假设检验是统计中的强大工具，可以用来决定结果是否统计显著，或者说结果是否碰巧发生。`spark.ml`现在支持Pearson卡方检验独立性测试。

ChiSquareTest 针对标签对每个特征进行 Pearson 独立性测试。对于每个特征，（特征，标签）对被转换为权变矩阵，计算卡方统计量。所有标签和特征值必须是类别型的

~~~java
import java.util.Arrays;
import java.util.List;

import org.apache.spark.ml.linalg.Vectors;
import org.apache.spark.ml.linalg.VectorUDT;
import org.apache.spark.ml.stat.ChiSquareTest;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.types.*;

List<Row> data = Arrays.asList(
  RowFactory.create(0.0, Vectors.dense(0.5, 10.0)),
  RowFactory.create(0.0, Vectors.dense(1.5, 20.0)),
  RowFactory.create(1.0, Vectors.dense(1.5, 30.0)),
  RowFactory.create(0.0, Vectors.dense(3.5, 30.0)),
  RowFactory.create(0.0, Vectors.dense(3.5, 40.0)),
  RowFactory.create(1.0, Vectors.dense(3.5, 40.0))
);

StructType schema = new StructType(new StructField[]{
  new StructField("label", DataTypes.DoubleType, false, Metadata.empty()),
  new StructField("features", new VectorUDT(), false, Metadata.empty()),
});

Dataset<Row> df = spark.createDataFrame(data, schema);
Row r = ChiSquareTest.test(df, "features", "label").head();
System.out.println("pValues: " + r.get(0).toString());
System.out.println("degreesOfFreedom: " + r.getList(1).toString());
System.out.println("statistics: " + r.get(2).toString());
~~~

### 1.1.3 Summarizer

我们通过Summarizer为Dataframe向量列提供汇总统计。支持的方法有列维度的最大值、最小值、平均值、方差、非零数量和总数。

下面是使用Summarizer计算输入dataframe向量列的平均值和方差。

~~~java
import java.util.Arrays;
import java.util.List;

import org.apache.spark.ml.linalg.Vector;
import org.apache.spark.ml.linalg.Vectors;
import org.apache.spark.ml.linalg.VectorUDT;
import org.apache.spark.ml.stat.Summarizer;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.Metadata;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.sql.types.StructType;

List<Row> data = Arrays.asList(
  RowFactory.create(Vectors.dense(2.0, 3.0, 5.0), 1.0),
  RowFactory.create(Vectors.dense(4.0, 6.0, 7.0), 2.0)
);

StructType schema = new StructType(new StructField[]{
  new StructField("features", new VectorUDT(), false, Metadata.empty()),
  new StructField("weight", DataTypes.DoubleType, false, Metadata.empty())
});

Dataset<Row> df = spark.createDataFrame(data, schema);

Row result1 = df.select(Summarizer.metrics("mean", "variance")
  .summary(new Column("features"), new Column("weight")).as("summary"))
  .select("summary.mean", "summary.variance").first();
System.out.println("with weight: mean = " + result1.<Vector>getAs(0).toString() +
  ", variance = " + result1.<Vector>getAs(1).toString());

Row result2 = df.select(
  Summarizer.mean(new Column("features")),
  Summarizer.variance(new Column("features"))
).first();
System.out.println("without weight: mean = " + result2.<Vector>getAs(0).toString() +
  ", variance = " + result2.<Vector>getAs(1).toString());
~~~

## 1.2 数据源

这一节，我们将介绍如何使用ML中的数据源来加载数据。除了一些常见的数据源例如Parquet、CSV、JSON和JDBC，我们也为ML提供一些特别的数据源

### 1.2.1 图片数据源

## 1.3 ML流水线

这一节，我们介绍ML流水线的概念。ML流水线提供一组统一的基于DataFrames构建的高级API，以帮助用户创建和调试实用的机器学习流水线。

### 1.3.1 流水线的主要概念

MLlib为机器学习算法提供了标准化的API，使得将组合多种算法成一个流水线或工作流的工作变得简单。这节包括了流水线API引入的关键概念，这些流水线概念大部分受到了scikit-learn项目的启发。

- DataFrame：ML API使用Spark SQL的DataFrame类作为一个ML的数据集，它可以存储多样化的数据类型。例如，一个DataFrame能够拥有不同的列分别存储文本，特征向量，真实标签和预测结果。
- Transformer：一个Transformer是能将一个DataFrame转换成另一个DataFrame的算法。例如，一个ML模型是一个将包含特征信息的DataFrame转换为包含预测信息的DataFrame的Transformer。
- Estimator：一个Estimator是能够匹配DataFrame来生成Transformer的算法。例如，一个学习算法是一个基于DataFrame训练并制造出模型的Estimator。
- Pipeline：Pipeline将多个Transformer和Estimator连接起来，来指定一个ML工作流。
- Parameter：所有的Transformer和Estimator现在共享了一套通用API来指定参数。

#### DataFrame

机器学习可以被应用到非常广范围的数据类型上，例如向量、文本、图片和结构化数据。这个API采用来自Spark SQL中的DataFrame来支持多样的数据类型。

DataFrame支持很多基础和结构化数据，可以参考[Spark SQL数据类型](http://spark.apache.org/docs/2.4.8/sql-reference.html#data-types)。除了在Spark SQL指南中列出的数据类型，DataFrame还可以使用ML的Vector类型。

DataFrame能显式或隐式地通过RDD创建。在Java API中，用户需要使用`Dataset<Row>`来表示一个DataFrame。参见[Spark SQL 编程指南](http://spark.apache.org/docs/2.4.8/sql-programming-guide.html)。

DataFrame中的列是被命名的。下面的代码用例中使用类似"text", "features"和"label"的名字。

#### Pipeline 组件

##### Transformers

Transformer是一种类如特征转换器或学习出的模型这些东西的抽象。技术层面而言，Transformer实现了transform()方法，这个方法将一个DataFrame转换为另一个，一般是增加一个或更多列。例如：

- 一个特征转换器可能将获取一个DataFrame，读一列（例如文本），将其映射到一个新的列（例如特征向量），然后输出一个包含了新增映射列的新DataFrame。
- 一个学习模型可能获取一个DataFrame，读取包含特征向量的列，为每个特征向量预测标签，然后输出一个包含预测标签新增列的新DataFrame。

##### Estimators

Estimator抽象了学习算法或任何基于数据匹配/训练算法的概念。技术层面而言，Estimator实现了fit()方法，这个方法接收一个DataFrame返回一个Model，Model即一个Transformer。例如，一个学习算法例如LogisticRegression，是一个Estimator。调用fit()方法训练一个LogisticRegressionModel，它是一个Model，因此也是一个Transformer。

##### 流水线组件的属性

Transformer.transform() 和 Estimator.fit() 都是无状态的。将来，有状态算法可能通过其他概念来支持。

每个Transformer或Estimator实例都有一个独一无二的ID，这在指定参数的时候非常有用。

#### Pipeline

在机器学习中，普遍需要跑一系列的算法来处理和学习数据。例如，简单的文本文件处理工作流可能包含以下步骤：

- 将每个文件的文本分割为词。
- 将每个文本中的词转换为数字特征向量。
- 使用特征向量和标签学习一个预测模型。

MLlib使用Pipeline来表示这样的工作流，包含了一系列的按指定顺序排列的要运行的PipelineStage（Transformer和Estimator）。本节中，我们将使用这个简单的工作流作为一个例子。

##### 运行原理

Pipeline是一系列的步骤组成的，每个步骤要么是Transformer要么是Estimator。这些步骤按顺序运行，输入的DataFrame传递过每一个步骤并被转换。对于Transformer步骤，在DataFrame上transform()方法被调用。对于Estimator步骤，为了生成一个Transformer（它成为PipelineModel或合适的Pipeline的一部分），fit()方法被调用。生成的Transformer的transform()方法在DataFrame上被调用。

我们为前面提到的简单文本文档工作流做下阐述。下图表现的是在训练阶段使用Pipeline。

~~~mermaid
graph LR
	subgraph Pipeline.fit
		rt(Raw text) --> w(Words)
		w --> fv(Feature vectors)
		fv --> lrm[LogisticRegressionModel]
	end
	
	subgraph Pipeline-Estimator
		t[Tokenizer] --> h[HashingTF] 
		h --> lr[LogisticRegression]
	end
	
	style t fill:#FFF,stroke:#00F,stroke-width:3px
	style h fill:#FFF,stroke:#00F,stroke-width:3px
	style lr fill:#FFF,stroke:#F00,stroke-width:3px
	style lrm fill:#FFF,stroke:#00F,stroke-width:3px
~~~

上面可以看到，上面一行表示一个三阶段的Pipeline。前两个（Tokenizer和HashingTF）是Transformer（蓝色的），第三个（LogisticRegression）是一个Estimator（红色）。下面一行表示流水线中的数据流，紫色圆角框代表的是DataFrame。Pipeline.fit()方法调用在最初的包含原始文本文件和标签的DataFrame上。Tokenizer.transform()方法将原始文本文档分割为词，为DataFrame添加一个新的词列。HashingTF.transform()方法将词列转换为特征向量，为DataFrame添加一个新的包含这些向量的列。现在，因为LogisticRegression是一个Estimator，Pipeline首先调用LogisticRegression.fit()来生成一个LogisticRegressionModel。如果Pipeline有更多Estimator，它将在传递DataFrame到下一个步骤前，在DataFrame上调用LogisticRegressionModel的transform()方法。

Pipeline是一个Estimator。因此，在Pipeline.fit()方法运行后，它将产生一个PipelineModel，这是一个Transformer。这个PipelineModel是在测试阶段使用，下图阐释了这个用法。

~~~mermaid
graph LR
	subgraph PipelineModel.transform
		rt(Raw text) --> w(Words)
		w --> fv(Feature vectors)
		fv --> p(Predictions)
	end
	
	subgraph PipelineModel-Transformer
		t[Tokenizer] --> h[HashingTF] 
		h --> lrm[LogisticRegression]
	end
	
	style t fill:#FFF,stroke:#00F,stroke-width:3px
	style h fill:#FFF,stroke:#00F,stroke-width:3px
	style lrm fill:#FFF,stroke:#00F,stroke-width:3px
~~~

上图中，PipelineModel和最初的Pipeline拥有相同数量的步骤，但在原来Pipeline中所有Estimator已经被转换为Transformer。当对测试数据集调用PipelineModel的tranform()方法时，数据将按顺序在合适的流水线间传递。每个阶段的transform()方法更新了数据集，并将其传递给下一个阶段。

Pipeline和PipelineModel有助于确保训练和测试数据经过相同的特征处理步骤。

##### 细节

DAG Pipeline：一个Pipeline的多个阶段是按有序数组指定的。这里给出的示例是针对线性Pipeline的，也就是说，每个阶段使用上一个阶段生成数据的Pipeline。只要数据流图构造的是一个有向无环图（DAG），那么就可以创建一个非线性的Pipeline。该图目前是根据每个阶段的输入和输出列名称隐式指定的（一般指定为参数）。如果流水线形成 DAG，则必须按拓扑顺序指定阶段。

运行时检查：由于Pipeline可以对具有不同类型的 DataFrame 进行操作，因此它们不能使用编译时类型检查。因此，Pipeline和PipelineModel在实际运行流水线之前进行运行时检查。 这种类型检查是使用 DataFrame 模式完成的，这是对 DataFrame 中列的数据类型的描述。

独特的Pipeline阶段：Pipeline的阶段应该是唯一的实例。 例如，同一个实例 myHashingTF 不应两次插入Pipeline，因为Pipeline阶段必须具有唯一的 ID。 但是，不同的实例 myHashingTF1 和 myHashingTF2（都是 HashingTF 类型）可以放入同一个管道中，因为不同的实例将使用不同的 ID 创建。

#### Parameters

MLlib Estimator 和 Transformer 使用统一的 API 来指定参数。

Param 是具有独立文档的命名参数。 ParamMap 是一组（参数，值）对。

向算法传递参数有两种主要方式：

1. 为实例设置参数。 例如，如果 lr 是 LogisticRegression 的一个实例，则可以调用 lr.setMaxIter(10) 使 lr.fit() 最多使用 10 次迭代。 此 API 类似于 spark.mllib 包中使用的 API。
2. 将 ParamMap 传递给 fit() 或 transform()。 ParamMap 中的任何参数都将覆盖先前通过 setter 方法指定的参数。

参数属于 Estimators 和 Transformers 的特定实例。 例如，如果我们有两个 LogisticRegression 实例 lr1 和 lr2，那么我们可以构建一个 ParamMap，同时指定两个 maxIter 参数：ParamMap(lr1.maxIter -> 10, lr2.maxIter -> 20)。 如果流水线中有两种带有 maxIter 参数的算法，这将很有用。

### 1.3.2 ML持久化：保存和加载流水线

通常，将模型或流水线保存到磁盘以备后用是值得的。 在 Spark 1.6 中，Pipeline API 中添加了模型导入/导出功能。 从 Spark 2.3 开始，spark.ml 和 pyspark.ml 中基于 DataFrame 的 API 已完全覆盖。

ML 持久性适用于 Scala、Java 和 Python。 但是，R 目前使用的是修改过的格式，因此保存在 R 中的模型只能在 R 中加载回来。

#### ML 持久性的向后兼容性

通常，MLlib 维护 ML 持久性的向后兼容性。即，如果您将 ML 模型或 Pipeline 保存在一个版本的 Spark 中，那么您应该能够重新加载它并在未来版本的 Spark 中使用它。但是，也有少数例外，如下所述。

模型持久性：在 Spark 版本 X 中使用 Apache Spark ML 持久性保存的模型或 Pipeline 是否可由 Spark 版本 Y 加载？

- 主要版本：没有保证，但尽力而为。
- 次要版本和补丁版本：是；这些是向后兼容的。
- 关于格式的注意事项：无法保证稳定的持久性格式，但模型加载本身旨在向后兼容。

模型行为：Spark 版本 X 中的模型或 Pipeline 在 Spark 版本 Y 中的行为是否相同？

- 主要版本：没有保证，但尽力而为。
- 次要版本和补丁版本：相同的行为，除了错误修复。

对于模型持久性和模型行为，小版本或补丁版本中的任何重大更改都会在 Spark 版本发行说明中报告。如果发行说明中未报告损坏，则应将其视为要修复的bug。

### 1.3.3 代码示例

这一节的代码示例展示了上面讨论过的功能。

#### 示例：Estimator，Transformer和Param

~~~java
import java.util.Arrays;
import java.util.List;

import org.apache.spark.ml.classification.LogisticRegression;
import org.apache.spark.ml.classification.LogisticRegressionModel;
import org.apache.spark.ml.linalg.VectorUDT;
import org.apache.spark.ml.linalg.Vectors;
import org.apache.spark.ml.param.ParamMap;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.Metadata;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.sql.types.StructType;

// Prepare training data.
List<Row> dataTraining = Arrays.asList(
    RowFactory.create(1.0, Vectors.dense(0.0, 1.1, 0.1)),
    RowFactory.create(0.0, Vectors.dense(2.0, 1.0, -1.0)),
    RowFactory.create(0.0, Vectors.dense(2.0, 1.3, 1.0)),
    RowFactory.create(1.0, Vectors.dense(0.0, 1.2, -0.5))
);
StructType schema = new StructType(new StructField[]{
    new StructField("label", DataTypes.DoubleType, false, Metadata.empty()),
    new StructField("features", new VectorUDT(), false, Metadata.empty())
});
Dataset<Row> training = spark.createDataFrame(dataTraining, schema);

// Create a LogisticRegression instance. This instance is an Estimator.
LogisticRegression lr = new LogisticRegression();
// Print out the parameters, documentation, and any default values.
System.out.println("LogisticRegression parameters:\n" + lr.explainParams() + "\n");

// We may set parameters using setter methods.
lr.setMaxIter(10).setRegParam(0.01);

// Learn a LogisticRegression model. This uses the parameters stored in lr.
LogisticRegressionModel model1 = lr.fit(training);
// Since model1 is a Model (i.e., a Transformer produced by an Estimator),
// we can view the parameters it used during fit().
// This prints the parameter (name: value) pairs, where names are unique IDs for this
// LogisticRegression instance.
System.out.println("Model 1 was fit using parameters: " + model1.parent().extractParamMap());

// We may alternatively specify parameters using a ParamMap.
ParamMap paramMap = new ParamMap()
    .put(lr.maxIter().w(20))  // Specify 1 Param.
    .put(lr.maxIter(), 30)  // This overwrites the original maxIter.
    .put(lr.regParam().w(0.1), lr.threshold().w(0.55));  // Specify multiple Params.

// One can also combine ParamMaps.
ParamMap paramMap2 = new ParamMap()
    .put(lr.probabilityCol().w("myProbability"));  // Change output column name
ParamMap paramMapCombined = paramMap.$plus$plus(paramMap2);

// Now learn a new model using the paramMapCombined parameters.
// paramMapCombined overrides all parameters set earlier via lr.set* methods.
LogisticRegressionModel model2 = lr.fit(training, paramMapCombined);
System.out.println("Model 2 was fit using parameters: " + model2.parent().extractParamMap());

// Prepare test documents.
List<Row> dataTest = Arrays.asList(
    RowFactory.create(1.0, Vectors.dense(-1.0, 1.5, 1.3)),
    RowFactory.create(0.0, Vectors.dense(3.0, 2.0, -0.1)),
    RowFactory.create(1.0, Vectors.dense(0.0, 2.2, -1.5))
);
Dataset<Row> test = spark.createDataFrame(dataTest, schema);

// Make predictions on test documents using the Transformer.transform() method.
// LogisticRegression.transform will only use the 'features' column.
// Note that model2.transform() outputs a 'myProbability' column instead of the usual
// 'probability' column since we renamed the lr.probabilityCol parameter previously.
Dataset<Row> results = model2.transform(test);
Dataset<Row> rows = results.select("features", "label", "myProbability", "prediction");
for (Row r: rows.collectAsList()) {
    System.out.println("(" + r.get(0) + ", " + r.get(1) + ") -> prob=" + r.get(2)
                       + ", prediction=" + r.get(3));
}
~~~

#### 示例：Pipeline

~~~java
import java.util.Arrays;

import org.apache.spark.ml.Pipeline;
import org.apache.spark.ml.PipelineModel;
import org.apache.spark.ml.PipelineStage;
import org.apache.spark.ml.classification.LogisticRegression;
import org.apache.spark.ml.feature.HashingTF;
import org.apache.spark.ml.feature.Tokenizer;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;

// Prepare training documents, which are labeled.
Dataset<Row> training = spark.createDataFrame(Arrays.asList(
    new JavaLabeledDocument(0L, "a b c d e spark", 1.0),
    new JavaLabeledDocument(1L, "b d", 0.0),
    new JavaLabeledDocument(2L, "spark f g h", 1.0),
    new JavaLabeledDocument(3L, "hadoop mapreduce", 0.0)
), JavaLabeledDocument.class);

// Configure an ML pipeline, which consists of three stages: tokenizer, hashingTF, and lr.
Tokenizer tokenizer = new Tokenizer()
    .setInputCol("text")
    .setOutputCol("words");
HashingTF hashingTF = new HashingTF()
    .setNumFeatures(1000)
    .setInputCol(tokenizer.getOutputCol())
    .setOutputCol("features");
LogisticRegression lr = new LogisticRegression()
    .setMaxIter(10)
    .setRegParam(0.001);
Pipeline pipeline = new Pipeline()
    .setStages(new PipelineStage[] {tokenizer, hashingTF, lr});

// Fit the pipeline to training documents.
PipelineModel model = pipeline.fit(training);

// Prepare test documents, which are unlabeled.
Dataset<Row> test = spark.createDataFrame(Arrays.asList(
    new JavaDocument(4L, "spark i j k"),
    new JavaDocument(5L, "l m n"),
    new JavaDocument(6L, "spark hadoop spark"),
    new JavaDocument(7L, "apache hadoop")
), JavaDocument.class);

// Make predictions on test documents.
Dataset<Row> predictions = model.transform(test);
for (Row r : predictions.select("id", "text", "probability", "prediction").collectAsList()) {
    System.out.println("(" + r.get(0) + ", " + r.get(1) + ") --> prob=" + r.get(2)
                       + ", prediction=" + r.get(3));
}
~~~

### 1.3.4 模型选择（超参数调试）

使用ML流水线的一大好处是超参数优化。

## 1.4 提取，转换和选择特征

这一节介绍特征相关的算法，简单分为下面的几组：

- 提取：从“原始”数据中提取特征
- 转换：缩放，转换，或者修改特征
- 选择：从一大组特征中选择一个子集
- 局部敏感哈希（Locality Sensitive Hashing, LSH）：这类算法将特征转换的各个方面与其他算法相结合。

### 1.4.1 特征提取器

#### TF-IDF

词频-逆文档频率（TF-IDF）是一种广泛用于文本挖掘的特征向量化方法，用于反映词条对语料库中文档的重要性。

#### Word2Vec

#### CountVectorizer

#### FeatureHasher

特征散列将一组分类或数字特征投影到指定维度的特征向量中（通常比原始特征空间小得多）。这是使用散列技巧来把特征映射到特征向量中的索引来完成的。

FeatureHasher转换器在多列上进行操作。每列可能包含数字或分类特征。列数据类型的行为和处理如下：

- 数字列：对于数字特征，列名的哈希值用于将特征值映射到其在特征向量中的索引。 默认情况下，数字特征不被视为分类特征（即使它们是整数）。 要将它们视为分类的，请使用 categoricalCols 参数指定相关列。
- 字符串列：对于分类特征，使用字符串“column_name=value”的哈希值映射到向量索引，指标值为1.0。 因此，分类特征是“one-hot”编码的（类似于使用带有 dropLast=false 的 OneHotEncoder）。
- 布尔列：布尔值的处理方式与字符串列相同。 即布尔特征表示为“column_name=true”或“column_name=false”，指标值为1.0。

null（缺失）值被忽略（在结果特征向量中隐式为零）。

这里使用的哈希函数也是HashingTF中使用的MurmurHash 3。 由于散列值的简单模数用于确定向量索引，因此建议使用 2 的幂作为 numFeatures 参数； 否则特征将不会被均匀地映射到向量索引。

##### 示例

假设我们有一个包含 4 个输入列 real、bool、stringNum 和 string 的 DataFrame。 这些作为输入的不同数据类型将说明转换的行为以产生一列特征向量。

~~~
real| bool|stringNum|string
----|-----|---------|------
 2.2| true|        1|   foo
 3.3|false|        2|   bar
 4.4|false|        3|   baz
 5.5|false|        4|   foo
~~~

那么 FeatureHasher.transform 在这个 DataFrame 上的输出是：

~~~
real|bool |stringNum|string|features
----|-----|---------|------|-------------------------------------------------------
2.2 |true |1        |foo   |(262144,[51871, 63643,174475,253195],[1.0,1.0,2.2,1.0])
3.3 |false|2        |bar   |(262144,[6031,  80619,140467,174475],[1.0,1.0,1.0,3.3])
4.4 |false|3        |baz   |(262144,[24279,140467,174475,196810],[1.0,1.0,4.4,1.0])
5.5 |false|4        |foo   |(262144,[63643,140467,168512,174475],[1.0,1.0,1.0,5.5])
~~~

然后可以将生成的特征向量传递给学习算法。

~~~java
import java.util.Arrays;
import java.util.List;

import org.apache.spark.ml.feature.FeatureHasher;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.Metadata;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.sql.types.StructType;

List<Row> data = Arrays.asList(
  RowFactory.create(2.2, true, "1", "foo"),
  RowFactory.create(3.3, false, "2", "bar"),
  RowFactory.create(4.4, false, "3", "baz"),
  RowFactory.create(5.5, false, "4", "foo")
);
StructType schema = new StructType(new StructField[]{
  new StructField("real", DataTypes.DoubleType, false, Metadata.empty()),
  new StructField("bool", DataTypes.BooleanType, false, Metadata.empty()),
  new StructField("stringNum", DataTypes.StringType, false, Metadata.empty()),
  new StructField("string", DataTypes.StringType, false, Metadata.empty())
});
Dataset<Row> dataset = spark.createDataFrame(data, schema);

FeatureHasher hasher = new FeatureHasher()
  .setInputCols(new String[]{"real", "bool", "stringNum", "string"})
  .setOutputCol("features");

Dataset<Row> featurized = hasher.transform(dataset);

featurized.show(false);
~~~

### 1.4.2 特征转换器

#### Tokenizer

#### StopWordsRemover

#### n-gram

#### Binarizer

#### PCA

#### PolynomialExpansion

#### Discrete Cosine Transform (DCT)

#### StringIndexer

StringIndexer 将标签字符串列编码为标签索引列。 索引在 [0, numLabels) 中，支持四种排序选项（默认 = “frequencyDesc”）：

- “frequencyDesc”：按标签频率降序排列（最频繁的标签分配为 0），
- “frequencyAsc”：按标签频率升序（分配最少的标签为 0） , 
- “alphabetDesc”：字母降序，
- “alphabetAsc”：字母升序

如果用户选择保留看不见的标签，它们将放在索引 numLabels 处。 如果输入列是数字，我们将其转换为字符串并索引字符串值。 当 Estimator 或 Transformer 等下游管道组件使用此字符串索引标签时，您必须将组件的输入列设置为此字符串索引列名称。 在很多情况下，您可以使用 setInputCol 设置输入列。

##### 示例

假设我们有以下的数据帧的列ID和类别：

~~~
 id | category
----|----------
 0  | a
 1  | b
 2  | c
 3  | a
 4  | a
 5  | c
~~~

category 是一个字符串列，带有三个标签：“a”、“b”和“c”。 应用以 category 作为输入列和 categoryIndex 作为输出列的 StringIndexer，我们应该得到以下结果：

~~~
 id | category | categoryIndex
----|----------|---------------
 0  | a        | 0.0
 1  | b        | 2.0
 2  | c        | 1.0
 3  | a        | 0.0
 4  | a        | 0.0
 5  | c        | 1.0
~~~

“a”得到索引 0，因为它是最常见的，其次是“c”的索引 1 和“b”的索引 2。

此外，当您在一个数据集上拟合 StringIndexer 然后使用它来转换另一个数据集时，关于 StringIndexer 如何处理看不见的标签，有三种策略：

- 抛出异常（这是默认值）
- 完全跳过包含不可见标签的行
- 将看不见的标签放在一个特殊的附加桶中，在索引 numLabels

##### 示例2

让我们回到之前的示例，但这次在以下数据集上重用我们之前定义的 StringIndexer：

~~~
 id | category
----|----------
 0  | a
 1  | b
 2  | c
 3  | d
 4  | e
~~~

如果您没有设置 StringIndexer 如何处理看不见的标签或将其设置为“错误”，则会抛出异常。 但是，如果您调用了 setHandleInvalid("skip")，则会生成以下数据集：

~~~
 id | category | categoryIndex
----|----------|---------------
 0  | a        | 0.0
 1  | b        | 2.0
 2  | c        | 1.0
~~~

请注意，没有出现包含“d”或“e”的行。

如果调用 setHandleInvalid("keep")，将生成以下数据集：

~~~
 id | category | categoryIndex
----|----------|---------------
 0  | a        | 0.0
 1  | b        | 2.0
 2  | c        | 1.0
 3  | d        | 3.0
 4  | e        | 3.0
~~~

请注意，包含“d”或“e”的行被映射到索引“3.0”

~~~java
import java.util.Arrays;
import java.util.List;

import org.apache.spark.ml.feature.StringIndexer;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.sql.types.StructType;

import static org.apache.spark.sql.types.DataTypes.*;

List<Row> data = Arrays.asList(
  RowFactory.create(0, "a"),
  RowFactory.create(1, "b"),
  RowFactory.create(2, "c"),
  RowFactory.create(3, "a"),
  RowFactory.create(4, "a"),
  RowFactory.create(5, "c")
);
StructType schema = new StructType(new StructField[]{
  createStructField("id", IntegerType, false),
  createStructField("category", StringType, false)
});
Dataset<Row> df = spark.createDataFrame(data, schema);

StringIndexer indexer = new StringIndexer()
  .setInputCol("category")
  .setOutputCol("categoryIndex");

Dataset<Row> indexed = indexer.fit(df).transform(df);
indexed.show();
~~~



#### IndexToString

#### OneHotEncoder (从2.3.0起废弃)

#### OneHotEncoderEstimator

One-Hot 编码将一个表示为一个标签索引的种类特征映射到一个最多一维为1（表示特定特征值的存在）的二进制向量。 这种编码允许期望连续特征的算法（例如逻辑回归）使用分类特征。对于字符串类型的输入数据，是很常见的编码分类首先使用StringIndexer功能。

OneHotEncoderEstimator可以变换多列，对于每一个输入列返回一个One-Hot的编码输出向量列。这是常见的这些载体合并成使用VectorAssembler单个特征向量。

OneHotEncoderEstimator支持handleInvalid参数选择如何将数据在处理无效的输入。可用的选项包括“keep”（任何无效的输入被分配到一个额外的分类指数）和“error”（抛出一个错误）。

~~~java
import java.util.Arrays;
import java.util.List;

import org.apache.spark.ml.feature.OneHotEncoderEstimator;
import org.apache.spark.ml.feature.OneHotEncoderModel;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.Metadata;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.sql.types.StructType;

List<Row> data = Arrays.asList(
  RowFactory.create(0.0, 1.0),
  RowFactory.create(1.0, 0.0),
  RowFactory.create(2.0, 1.0),
  RowFactory.create(0.0, 2.0),
  RowFactory.create(0.0, 1.0),
  RowFactory.create(2.0, 0.0)
);

StructType schema = new StructType(new StructField[]{
  new StructField("categoryIndex1", DataTypes.DoubleType, false, Metadata.empty()),
  new StructField("categoryIndex2", DataTypes.DoubleType, false, Metadata.empty())
});

Dataset<Row> df = spark.createDataFrame(data, schema);

OneHotEncoderEstimator encoder = new OneHotEncoderEstimator()
  .setInputCols(new String[] {"categoryIndex1", "categoryIndex2"})
  .setOutputCols(new String[] {"categoryVec1", "categoryVec2"});

OneHotEncoderModel model = encoder.fit(df);
Dataset<Row> encoded = model.transform(df);
encoded.show();
~~~



#### VectorIndexer

#### Interaction

#### Normalizer

#### StandardScaler

#### MinMaxScaler

#### MaxAbsScaler

#### Bucketizer

#### ElementwiseProduct

#### SQLTransformer

#### VectorAssembler

#### VectorSizeHint

#### QuantileDiscretizer

#### Imputer

### 1.4.3 特征选择器

#### VectorSlicer

#### RFormula

#### ChiSqSelector

### 1.4.4 局部敏感哈希（LSH）

#### LSH操作

#### LSH算法

## 1.5 分类和回归

### 1.5.1 分类

#### 逻辑回归

逻辑回归是一种流行的预测分类响应的方法。 它是广义线性模型的一个特例，可以预测结果的概率。 在 spark.ml 逻辑回归中，可以使用二项逻辑回归来预测二元结果，也可以使用多项逻辑回归来预测多类结果。 使用 `family` 参数在这两种算法之间进行选择，或者不设置它，Spark 将推断出正确的变体。

> 通过将 `family` 参数设置为“multinomial”，多项逻辑回归可用于二元分类。 它将产生两组系数和两个截距。
>
> 在对具有常数非零列的数据集进行无截距拟合 LogisticRegressionModel 时，Spark MLlib 为常量非零列输出零系数。 此行为与 R glmnet 相同，但与 LIBSVM 不同。

##### 二项逻辑回归

以下示例展示了如何使用弹性网络正则化训练二项式和多项式逻辑回归模型以进行二元分类。`elasticNetParam` 相当于 α ，`regParam` 相当于 λ。

~~~java
import org.apache.spark.ml.classification.LogisticRegression;
import org.apache.spark.ml.classification.LogisticRegressionModel;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;

// Load training data
Dataset<Row> training = spark.read().format("libsvm")
    .load("data/mllib/sample_libsvm_data.txt");

LogisticRegression lr = new LogisticRegression()
    .setMaxIter(10)
    .setRegParam(0.3)
    .setElasticNetParam(0.8);

// Fit the model
LogisticRegressionModel lrModel = lr.fit(training);

// Print the coefficients and intercept for logistic regression
System.out.println("Coefficients: "
                   + lrModel.coefficients() + " Intercept: " + lrModel.intercept());

// We can also use the multinomial family for binary classification
LogisticRegression mlr = new LogisticRegression()
    .setMaxIter(10)
    .setRegParam(0.3)
    .setElasticNetParam(0.8)
    .setFamily("multinomial");

// Fit the model
LogisticRegressionModel mlrModel = mlr.fit(training);

// Print the coefficients and intercepts for logistic regression with multinomial family
System.out.println("Multinomial coefficients: " + lrModel.coefficientMatrix()
                   + "\nMultinomial intercepts: " + mlrModel.interceptVector());
~~~

`spark.ml`的逻辑回归实现也支持从训练集中提取出模型的摘要。请注意，在 LogisticRegressionSummary 中存储为 DataFrame 的预测和指标带有 @transient 注释，因此仅在驱动程序上可用。

LogisticRegressionTrainingSummary 提供 LogisticRegressionModel 的摘要。 在二元分类的情况下，某些额外的指标是可用的，例如 ROC 曲线。 可以通过 binarySummary 方法访问二进制摘要。 请参阅 BinaryLogisticRegressionTrainingSummary。

继续前面的例子：

~~~java
import org.apache.spark.ml.classification.BinaryLogisticRegressionTrainingSummary;
import org.apache.spark.ml.classification.LogisticRegression;
import org.apache.spark.ml.classification.LogisticRegressionModel;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.functions;

// Extract the summary from the returned LogisticRegressionModel instance trained in the earlier
// example
BinaryLogisticRegressionTrainingSummary trainingSummary = lrModel.binarySummary();

// Obtain the loss per iteration.
double[] objectiveHistory = trainingSummary.objectiveHistory();
for (double lossPerIteration : objectiveHistory) {
    System.out.println(lossPerIteration);
}

// Obtain the receiver-operating characteristic as a dataframe and areaUnderROC.
Dataset<Row> roc = trainingSummary.roc();
roc.show();
roc.select("FPR").show();
System.out.println(trainingSummary.areaUnderROC());

// Get the threshold corresponding to the maximum F-Measure and rerun LogisticRegression with
// this selected threshold.
Dataset<Row> fMeasure = trainingSummary.fMeasureByThreshold();
double maxFMeasure = fMeasure.select(functions.max("F-Measure")).head().getDouble(0);
double bestThreshold = fMeasure.where(fMeasure.col("F-Measure").equalTo(maxFMeasure))
    .select("threshold").head().getDouble(0);
lrModel.setThreshold(bestThreshold);
~~~

##### 多项逻辑回归

通过多项逻辑 (softmax) 回归支持多类分类。 在多项逻辑回归中，该算法生成 $K$ 组系数，或维度为 $K\times J$ 的矩阵，其中 $K$ 是结果类别的数量，$J$ 是特征的数量。 如果算法符合截距项，则长度为 $K$ 的截距向量可用。

> 多项式系数可用作 `coefficientMatrix`，截距可用作 `interceptVector`。
>
> 不支持使用多项族训练的逻辑回归模型的 `coefficient` 和 `intercept` 方法。 改用 `coefficientMatrix` 和 `interceptVector`。

结果类 $k\in 1,2,\dots,K$ 的条件概率使用 softmax 函数建模。
$$
P(Y=k|X,\beta_k,\beta_{0k}) = \frac{e^{\beta_k X}+\beta_{0k}}{\sum^{K-1}_{k'=0}e^{\beta_{k'}\cdot X + \beta_{0k'}}}
$$
我们使用多项响应模型最小化加权负对数似然，并使用弹性网络惩罚来控制过度拟合。
$$
\min_{\beta,\beta_0} - [\sum^L_{i=1} \omega_i \cdot \log P(Y=y_i|X_i)] + \lambda[\frac{1}{2}(1-\alpha)||\beta||^2_2 + \alpha||\beta||_1]
$$
以下示例展示了如何使用弹性网络正则化训练多类逻辑回归模型，以及提取多类训练摘要以评估模型。

~~~java
import org.apache.spark.ml.classification.LogisticRegression;
import org.apache.spark.ml.classification.LogisticRegressionModel;
import org.apache.spark.ml.classification.LogisticRegressionTrainingSummary;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;

// Load training data
Dataset<Row> training = spark.read().format("libsvm")
    .load("data/mllib/sample_multiclass_classification_data.txt");

LogisticRegression lr = new LogisticRegression()
    .setMaxIter(10)
    .setRegParam(0.3)
    .setElasticNetParam(0.8);

// Fit the model
LogisticRegressionModel lrModel = lr.fit(training);

// Print the coefficients and intercept for multinomial logistic regression
System.out.println("Coefficients: \n"
                   + lrModel.coefficientMatrix() + " \nIntercept: " + lrModel.interceptVector());
LogisticRegressionTrainingSummary trainingSummary = lrModel.summary();

// Obtain the loss per iteration.
double[] objectiveHistory = trainingSummary.objectiveHistory();
for (double lossPerIteration : objectiveHistory) {
    System.out.println(lossPerIteration);
}

// for multiclass, we can inspect metrics on a per-label basis
System.out.println("False positive rate by label:");
int i = 0;
double[] fprLabel = trainingSummary.falsePositiveRateByLabel();
for (double fpr : fprLabel) {
    System.out.println("label " + i + ": " + fpr);
    i++;
}

System.out.println("True positive rate by label:");
i = 0;
double[] tprLabel = trainingSummary.truePositiveRateByLabel();
for (double tpr : tprLabel) {
    System.out.println("label " + i + ": " + tpr);
    i++;
}

System.out.println("Precision by label:");
i = 0;
double[] precLabel = trainingSummary.precisionByLabel();
for (double prec : precLabel) {
    System.out.println("label " + i + ": " + prec);
    i++;
}

System.out.println("Recall by label:");
i = 0;
double[] recLabel = trainingSummary.recallByLabel();
for (double rec : recLabel) {
    System.out.println("label " + i + ": " + rec);
    i++;
}

System.out.println("F-measure by label:");
i = 0;
double[] fLabel = trainingSummary.fMeasureByLabel();
for (double f : fLabel) {
    System.out.println("label " + i + ": " + f);
    i++;
}

double accuracy = trainingSummary.accuracy();
double falsePositiveRate = trainingSummary.weightedFalsePositiveRate();
double truePositiveRate = trainingSummary.weightedTruePositiveRate();
double fMeasure = trainingSummary.weightedFMeasure();
double precision = trainingSummary.weightedPrecision();
double recall = trainingSummary.weightedRecall();
System.out.println("Accuracy: " + accuracy);
System.out.println("FPR: " + falsePositiveRate);
System.out.println("TPR: " + truePositiveRate);
System.out.println("F-measure: " + fMeasure);
System.out.println("Precision: " + precision);
System.out.println("Recall: " + recall);
~~~

### 1.5.2 回归

### 1.5.3 线性方法

我们实现了流行的线性方法，例如逻辑回归和具有 L1 或 L2 正则化的线性最小二乘法。有关实现和调优的详细信息，请参阅基于 RDD 的 API 的线性方法指南；这些信息仍然具有相关性。

我们还纳入了一个用于弹性网络的 DataFrame API，即L1 和 L2 正则化的混合（Zou 等人提出的《通过弹性网络的正则化和变量选择》）。在数学上，它被定义为 L1 和 L2 正则化项的凸组合：

$$
\alpha(\lambda||w||_1) + (1+\alpha)(\frac{\lambda}{2}||w||^2_2), \qquad \alpha\in[0,1],\lambda\ge 0
$$
通过适当设置 α，弹性网络同时包含 L1 和 L2 正则化作为特殊情况。例如，如果在弹性网络参数 α 设置为 1 的情况下训练线性回归模型，则它等效于 Lasso 模型。另一方面，如果 α 设置为 0，则训练模型将简化为岭回归模型。我们使用弹性网络正则化为线性回归和逻辑回归实现了流水线 API。

## 1.6 聚类

## 1.7 协同过滤

## 1.8 频繁模式挖掘

## 1.9 ML 调优：模型选择和超参数调优

本节介绍如何使用 MLlib 的工具来调整 ML 算法和流水线。 内置的交叉验证和其他工具使用户可以优化算法和流水线中的超参数。

### 1.9.1 模型选择（或超参数调优）

# 二、MLlib 基于RDD的API指南

## 2.1 数据类型

## 2.2 基础统计

## 2.3 分类和回归

## 2.9 评估指标

spark.mllib 附带了许多机器学习算法，可用于从数据中学习和预测数据。 当这些算法应用于构建机器学习模型时，需要根据某些标准评估模型的性能，这取决于应用程序及其要求。 spark.mllib 还提供了一套用于评估机器学习模型性能的指标。

特定的机器学习算法属于更广泛类型的机器学习应用程序，如分类、回归、聚类等。这些类型中的每一种都有完善的性能评估指标，本节详细介绍了目前在 spark.mllib 中可用的指标。

### 2.9.1 分类模型评估

虽然分类算法有很多种，但对分类模型的评估都有相似的原则。在监督分类问题中，每个数据点都存在真实输出和模型生成的预测输出。因此，可以将每个数据点的结果分配到以下四个类别之一：

- 真阳性（True Positive，TP） - 标签为正，预测也为正
- 真阴性（True Negative，TN） - 标签为负，预测也为负
- 假阳性（False Positive，FP）- 标签为负但预测为正
- 假阴性（False Negative，FN） - 标签为正但预测为负

这四个数字是大多数分类器评估指标的构建块。考虑分类器评估时的一个基本观点是，纯粹的准确性（即预测是正确还是错误）通常不是一个好的度量标准。这样做的原因是因为数据集可能高度不平衡。例如，如果一个模型被设计为从一个数据集预测欺诈，其中 95% 的数据点不是欺诈，5% 的数据点是欺诈，那么无论输入如何，预测非欺诈的朴素分类器将是 95 ％ 准确的。出于这个原因，通常使用精度和召回率等指标，因为它们考虑了错误的类型。在大多数应用中，精确率和召回率之间存在某种期望的平衡，可以通过将两者组合成一个单一的度量标准来实现，称为 F 度量。

#### 二分类

二元分类器用于将给定数据集的元素分成两个可能的组之一（例如欺诈或非欺诈），并且是多类分类的特例。 大多数二元分类指标可以推广到多类分类指标。

##### 阈值调整

了解到许多分类模型实际上是为每个类别输出一个“分数”（通常是概率）这一点很重要，其中分数越高表示可能性越高。在二元情况下，模型可能会输出每个类别的概率：P(Y=1|X) 和 P(Y=0|X)。不是简单地采用更高的概率，在某些情况下可能需要调整模型，以便仅在概率非常高时预测一个类别（例如，仅阻止信用卡交易模型预测欺诈概率大于 90%的情况）。因此，存在一个预测阈值，它根据模型输出的概率确定预测的类别。

调整预测阈值会改变模型的准确率和召回率，是模型优化的重要部分。为了可视化精度、召回率和其他指标如何作为阈值的函数而变化，通常的做法是绘制相互竞争的指标，由阈值参数化。 P-R 曲线绘制不同阈值的（精确度、召回率）点，而接收者操作特征或 ROC 曲线绘制（召回率、假阳性率）点。

##### 可用指标

| 指标                | 定义                                                         |
| ------------------- | ------------------------------------------------------------ |
| 精度（正预测值）    | $PPV=\frac{TP}{TP+FP}$                                       |
| 召回率（真阳性率）  | $TPR=\frac{TP}{P}=\frac{TP}{TP+FN}$                          |
| F-度量              | $F(\beta)=(1+\beta^2)\cdot(\frac{PPV \cdot TPR}{\beta^2 \cdot PPV + TPR})$ |
| 接收器工作特性(ROC) | $FPR(T) = \int^\infin_T P_0(T) dT \\ TPR(T) = \int^\infin_T P_1(T) dT$ |
| ROC曲线下面积       | $AUROC = \int^1_0 \frac{TP}{P}d(\frac{FP}{N})$               |
| 精确召回曲线下面积  | $AUPRC = \int^1_0 \frac{TP}{TP+FP}d(\frac{TP}{P})$           |

##### 示例

以下代码片段说明了如何加载示例数据集、对数据训练二进制分类算法，并通过多个二进制评估指标评估算法的性能。

有关 API 的详细信息，请参阅 LogisticRegressionModel Java 文档和 LogisticRegressionWithLBFGS Java 文档。

~~~java
import scala.Tuple2;

import org.apache.spark.api.java.*;
import org.apache.spark.mllib.classification.LogisticRegressionModel;
import org.apache.spark.mllib.classification.LogisticRegressionWithLBFGS;
import org.apache.spark.mllib.evaluation.BinaryClassificationMetrics;
import org.apache.spark.mllib.regression.LabeledPoint;
import org.apache.spark.mllib.util.MLUtils;

String path = "data/mllib/sample_binary_classification_data.txt";
JavaRDD<LabeledPoint> data = MLUtils.loadLibSVMFile(sc, path).toJavaRDD();

// Split initial RDD into two... [60% training data, 40% testing data].
JavaRDD<LabeledPoint>[] splits =
  data.randomSplit(new double[]{0.6, 0.4}, 11L);
JavaRDD<LabeledPoint> training = splits[0].cache();
JavaRDD<LabeledPoint> test = splits[1];

// Run training algorithm to build the model.
LogisticRegressionModel model = new LogisticRegressionWithLBFGS()
  .setNumClasses(2)
  .run(training.rdd());

// Clear the prediction threshold so the model will return probabilities
model.clearThreshold();

// Compute raw scores on the test set.
JavaPairRDD<Object, Object> predictionAndLabels = test.mapToPair(p ->
  new Tuple2<>(model.predict(p.features()), p.label()));

// Get evaluation metrics.
BinaryClassificationMetrics metrics =
  new BinaryClassificationMetrics(predictionAndLabels.rdd());

// Precision by threshold
JavaRDD<Tuple2<Object, Object>> precision = metrics.precisionByThreshold().toJavaRDD();
System.out.println("Precision by threshold: " + precision.collect());

// Recall by threshold
JavaRDD<?> recall = metrics.recallByThreshold().toJavaRDD();
System.out.println("Recall by threshold: " + recall.collect());

// F Score by threshold
JavaRDD<?> f1Score = metrics.fMeasureByThreshold().toJavaRDD();
System.out.println("F1 Score by threshold: " + f1Score.collect());

JavaRDD<?> f2Score = metrics.fMeasureByThreshold(2.0).toJavaRDD();
System.out.println("F2 Score by threshold: " + f2Score.collect());

// Precision-recall curve
JavaRDD<?> prc = metrics.pr().toJavaRDD();
System.out.println("Precision-recall curve: " + prc.collect());

// Thresholds
JavaRDD<Double> thresholds = precision.map(t -> Double.parseDouble(t._1().toString()));

// ROC Curve
JavaRDD<?> roc = metrics.roc().toJavaRDD();
System.out.println("ROC curve: " + roc.collect());

// AUPRC
System.out.println("Area under precision-recall curve = " + metrics.areaUnderPR());

// AUROC
System.out.println("Area under ROC = " + metrics.areaUnderROC());

// Save and load model
model.save(sc, "target/tmp/LogisticRegressionModel");
LogisticRegressionModel.load(sc, "target/tmp/LogisticRegressionModel");
~~~

#### 多分类

多类分类描述了一个分类问题，其中每个数据点有 M>2 个可能的标签（M=2 的情况是二元分类问题）。例如，将手写样本分类为数字 0 到 9，有 10 个可能的类别。

对于多类指标，正面和负面的概念略有不同。预测和标签仍然可以是正面的或负面的，但必须在特定类别的上下文中考虑它们。每个标签和预测都采用多个类之一的值，因此它们被称为对其特定类为正，对所有其他类为负。因此，只要预测和标签匹配，就会出现真阳性，而当预测和标签都不采用给定类的值时，就会出现真阴性。按照这个约定，给定的数据样本可以有多个真阴性。从以前的正面和负面标签的定义扩展假阴性和假阳性很简单。

##### 基于标签的指标

与只有两个可能标签的二元分类相反，多类分类问题有许多可能的标签，因此引入了基于标签的度量的概念。 准确度衡量所有标签的准确度 - 任何类别被正确预测（真阳性）的次数，由数据点的数量归一化。 标签精度只考虑一个类别，并通过标签在输出中出现的次数来衡量正确预测特定标签的次数。

##### 可用指标

定义分类集或者说标签集：
$$
L = \{l_0,l_1,\cdots,l_{M-1}\}
$$
真正的输出向量 y 由 N 个元素组成
$$
\bold y_0,\bold y_1,\cdots,\bold y_{N-1}\in L
$$
多类预测算法生成拥有N 个元素的预测向量 $\hat{\bold y}$
$$
\hat{\bold y}_0,\hat{\bold y}_1,\cdots,\hat{\bold y}_{N-1}\in L
$$
对于本节，修改后的 delta 函数 $\hat\delta(x)$​​ 将证明是有用的
$$
\hat\delta(x) = \begin{cases}  1,  & \mbox{if }x = 0 \\ 0, & \mbox{otherwise} \end{cases}
$$

##### 示例

~~~java
import scala.Tuple2;

import org.apache.spark.api.java.*;
import org.apache.spark.mllib.classification.LogisticRegressionModel;
import org.apache.spark.mllib.classification.LogisticRegressionWithLBFGS;
import org.apache.spark.mllib.evaluation.MulticlassMetrics;
import org.apache.spark.mllib.regression.LabeledPoint;
import org.apache.spark.mllib.util.MLUtils;
import org.apache.spark.mllib.linalg.Matrix;

String path = "data/mllib/sample_multiclass_classification_data.txt";
JavaRDD<LabeledPoint> data = MLUtils.loadLibSVMFile(sc, path).toJavaRDD();

// Split initial RDD into two... [60% training data, 40% testing data].
JavaRDD<LabeledPoint>[] splits = data.randomSplit(new double[]{0.6, 0.4}, 11L);
JavaRDD<LabeledPoint> training = splits[0].cache();
JavaRDD<LabeledPoint> test = splits[1];

// Run training algorithm to build the model.
LogisticRegressionModel model = new LogisticRegressionWithLBFGS()
    .setNumClasses(3)
    .run(training.rdd());

// Compute raw scores on the test set.
JavaPairRDD<Object, Object> predictionAndLabels = test.mapToPair(p -> new Tuple2<>(model.predict(p.features()), p.label()));

// Get evaluation metrics.
MulticlassMetrics metrics = new MulticlassMetrics(predictionAndLabels.rdd());

// Confusion matrix
Matrix confusion = metrics.confusionMatrix();
System.out.println("Confusion matrix: \n" + confusion);

// Overall statistics
System.out.println("Accuracy = " + metrics.accuracy());

// Stats by labels
for (int i = 0; i < metrics.labels().length; i++) {
    System.out.format("Class %f precision = %f\n", metrics.labels()[i],metrics.precision(
        metrics.labels()[i]));
    System.out.format("Class %f recall = %f\n", metrics.labels()[i], metrics.recall(
        metrics.labels()[i]));
    System.out.format("Class %f F1 score = %f\n", metrics.labels()[i], metrics.fMeasure(
        metrics.labels()[i]));
}

//Weighted stats
System.out.format("Weighted precision = %f\n", metrics.weightedPrecision());
System.out.format("Weighted recall = %f\n", metrics.weightedRecall());
System.out.format("Weighted F1 score = %f\n", metrics.weightedFMeasure());
System.out.format("Weighted false positive rate = %f\n", metrics.weightedFalsePositiveRate());

// Save and load model
model.save(sc, "target/tmp/LogisticRegressionModel");
LogisticRegressionModel sameModel = LogisticRegressionModel.load(sc, "target/tmp/LogisticRegressionModel");
~~~





# 三、Spark SQL 指南

Spark SQL 是一个用于结构化数据处理的 Spark 模块。 与基本的 Spark RDD API 不同，Spark SQL 提供的接口为 Spark 提供有关数据结构和正在执行的计算的更多信息。 在内部，Spark SQL 使用这些额外的信息来执行额外的优化。 有多种与 Spark SQL 交互的方式，包括 SQL 和数据集 API。 计算结果时，使用相同的执行引擎，与您使用哪种 API/语言来表达计算无关。 这种统一意味着开发人员可以轻松地在不同的 API 之间来回切换，这提供了表达给定转换的最自然的方式。

此页面上的所有示例都使用 Spark 发行版中包含的示例数据，并且可以在 spark-shell、pyspark shell 或 sparkR shell 中运行。

### SQL

Spark SQL 的一种用途是执行 SQL 查询。 Spark SQL 也可用于从现有的 Hive 安装中读取数据。 有关如何配置此功能的更多信息，请参阅 Hive 表部分。 从另一种编程语言中运行 SQL 时，结果将作为数据集/数据帧返回。 您还可以使用命令行或通过 JDBC/ODBC 与 SQL 界面进行交互。

### DateSet 和 DataFrame

数据集是数据的分布式集合。 Dataset 是 Spark 1.6 中添加的一个新接口，它提供了 RDD 的优点（强类型、使用强大 lambda 函数的能力）以及 Spark SQL 优化执行引擎的优点。数据集可以从 JVM 对象构建，然后使用函数转换（map、flatMap、filter 等）进行操作。数据集 API 在 Scala 和 Java 中可用。 Python 不支持 Dataset API。但是由于 Python 的动态特性，Dataset API 的许多好处已经可用（即您可以自然地通过名称访问行的字段 row.columnName）。 R 的情况类似。

DataFrame 是组织成命名列的数据集。它在概念上等同于关系数据库中的表或 R/Python 中的数据框，但在幕后进行了更丰富的优化。 DataFrames 可以从多种来源构建，例如：结构化数据文件、Hive 中的表、外部数据库或现有 RDD。 DataFrame API 在 Scala、Java、Python 和 R 中可用。在 Scala 和 Java 中，DataFrame 由行数据集表示。在 Scala API 中，DataFrame 只是 Dataset[Row] 的类型别名。而在 Java API 中，用户需要使用 `Dataset<Row>` 来表示一个 DataFrame。

在本文档中，我们经常将 Scala/Java 行数据集称为数据帧（DataFrame）。

# 四、Spark Java API 文档

## 4.1 DataSet

DataSet是特定领域对象的强类型集合，可以使用函数或关系操作并行转换。每个 Dataset 也有一个无类型视图，称为 DataFrame，它是一个 Dataset of Row。
DataSet上可用的操作分为转换和操作。转换是产生新数据集的那些，而动作是触发计算和返回结果的那些。示例转换包括映射（map）、过滤器（filter）、选择（select）和聚合 (groupBy)。示例操作计数、显示或将数据写入文件系统。

DataSet数据集是“惰性的”，即只有在调用操作时才会触发计算。在内部，数据集表示描述生成数据所需的计算的逻辑计划。当一个动作被调用时，Spark 的查询优化器会优化逻辑计划并生成一个物理计划，以便以并行和分布式的方式高效执行。要探索逻辑计划以及优化的物理计划，请使用解释功能。

为了有效地支持特定于域的对象，需要一个Encoder编码器。Encoder将域特定类型 T 映射到 Spark 的内部类型系统。例如，给定一个具有两个字段 name（string）和 age（int）的类 Person，编码器用于告诉 Spark 在运行时生成代码以将 Person 对象序列化为二进制结构。这种二进制结构通常具有低得多的内存占用，并且针对数据处理的效率进行了优化（例如以列格式）。要了解数据的内部二进制表示，请使用 schema 函数。

通常有两种方法可以创建数据集。最常见的方法是使用 SparkSession 上可用的读取功能将 Spark 指向存储系统上的某些文件。

~~~scala
val people = spark.read.parquet("...").as[Person]  // Scala
~~~

~~~java
Dataset<Person> people = spark.read().parquet("...").as(Encoders.bean(Person.class)); // Java
~~~

也可以通过现有数据集上可用的转换来创建数据集。 例如，以下内容通过对现有数据集应用过滤器来创建新数据集：

~~~scala
val names = people.map(_.name)  // in Scala; names is a Dataset[String]
~~~

~~~java
Dataset<String> names = people.map((Person p) -> p.name, Encoders.STRING));
~~~

数据集操作也可以是无类型的，通过以下定义的各种领域特定语言 (DSL) 函数：数据集（此类）、列和函数。 这些操作与 R 或 Python 中数据框抽象中可用的操作非常相似。

要从数据集中选择一列，请在 Scala 中使用 apply 方法，在 Java 中使用 col。

~~~scala
val ageCol = people("age")  // in Scala
~~~

~~~java
Column ageCol = people.col("age"); // in Java
~~~

请注意，Column 类型也可以通过其各种功能进行操作。

~~~scala
// The following creates a new column that increases everybody's age by 10.
people("age") + 10  // in Scala
~~~

~~~java
people.col("age").plus(10);  // in Java
~~~

Scala 中更具体的示例：

~~~scala
// To create Dataset[Row] using SparkSession
val people = spark.read.parquet("...")
val department = spark.read.parquet("...")

people.filter("age > 30")
    .join(department, people("deptId") === department("id"))
    .groupBy(department("name"), people("gender"))
    .agg(avg(people("salary")), max(people("age")))
~~~

Java的：

~~~java
// To create Dataset<Row> using SparkSession
Dataset<Row> people = spark.read().parquet("...");
Dataset<Row> department = spark.read().parquet("...");

people.filter(people.col("age").gt(30))
    .join(department, people.col("deptId").equalTo(department.col("id")))
    .groupBy(department.col("name"), people.col("gender"))
    .agg(avg(people.col("salary")), max(people.col("age")));
~~~

