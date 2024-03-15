# 第1章 Java SE 8的流库

在本章中，你将学习如何使用Java的流库，它是在Java SE 8中引入的，用来以“做什么而非怎么做”的方式处理集合。

## 1.1 从迭代到流的操作

流表明上看起来和集合很类似，都可以让我们转换和获取数据。但是，它们之间存在着显著的差异：

1. 流并不存储其元素。这些元素可能存储在底层的集合中，或者是按需生成的。
2. 流的操作不会修改其数据源。例如，filter方法不会从新的流中移除元素，而是会生成一个新的流，其中不包含被过滤掉的元素。
3. 流的操作是尽可能惰性执行的。这意味着直至需要其结果时，操作才会执行。

【API】java.util.stream.Stream\<T> 8 ：

- `Stream<T> filter(Predicate <? super T> p)`
  产生一个流，其中包含当前流中满足P的所有元素。
- `long count()`
  产生当前流中元素的数量。这是一个终止操作。

【API】java.util.Collection\<E> 1.2 :

- `default Stream<E> stream()`
- `default Stream<E> parallelStream()`
  产生当前集合中所有元素的顺序流或并行流。

## 1.2 流的创建

静态的stream.of方法

of方法具有可变长参数，因此我们可以构建具有任意数量引元的流

使用Array.stream(array,from,to)可以从数组中位于from(包括)和to(不包括)的元素中创建一个流。

为了创建不包含任何元素的流，可以使用静态的Stream.empty方法

Stream接口有两个用于创建无限流的静态方法。generate方法会接受一个不包含任何引元的函数（或者从技术上来讲，是一个Supplier\<T>接口的对象）。

*注意：Java API中有大量方法都可以产生流。例如，Pattern类有一个splitAsStream方法*

【API】java.util.stream.Stream 8 :

- `static <T> Stream<T> of(T... values)`
  产生一个元素为给定值的流。
- `static <T> Stream<T> empty()`
  产生一个不包含任何元素的流
- `static <T> Stream<T> generate(Supplier<T> s)`
  产生一个无限流，它的值是通过反复调用函数s而构建的。
- `static <T> Stream<T> iterate(T seed, UnaryOperator<T> f)`
  产生一个无限流，它的元素包含种子、在种子上调用f产生的值、在前一个元素上调用f产生的值，等等。

【API】java.util.Arrays 1.2 :

- `static <T> Stream<T> stream(T[] array, int startInclusive, int endExclusive) 8`
  产生一个流，它的元素是由数组指定范围内的元素构成的。

【API】java.util.regex.Pattern 1.4 :

- `Stream<String> splitAsStream(CharSequence input) 8`
  产生一个流，它的元素是输入中由该模式界定的部分。

【API】java.nio.file.Files 7：

- `static Stream<String> lines(Path path)` 8
- `static Stream<String> lines(Path path, Charset cs)` 8
  产生一个流，它的元素是指定文件中的行，该文件的字符集为UTF-8，或者为指定的字符集。

【API】java.util.function.Supplier\<T> 8 :

- `T get()`
  提供一个值。

## 1.3 filter、map和flatMap方法

filter转换会产生一个流，它的元素与某种条件相匹配。

filter的引元是Predicate\<T>,即从T到boolean的函数。

通常，我们想要按照某种方式来转换流中的值，此时，可以使用map方法并传递执行该转换的函数。

我们得到一个包含流的流，为了将其摊平为字母流，可以使用flatMap方法而不是map方法。

【API】java.util.stream.Stream 8 :

- `Stream<T> filter(Predicate<? super T> predicate)`
  产生一个流，它包含当前流中所有满足断言条件的元素。
- `<R> Stream<R> map(Function<? super T, ? extends R> mapper)`
  产生一个流，它包含将mapper应用于当前流中所有元素所产生的结果。
- `<R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends R>> mapper)`
  产生一个流，它是通过将mapper应用于当前流中所有元素所产生的结果连接到一起而获得的。（注意，这里的每一个结果都是一个流。）

## 1.4 抽取子流和连接流

调用stream.limit(n)会返回一个新的流，它在n个元素之后结束（如果原来的流更短，那么就会在流结束时结束）。这个方法对于裁剪无限流的尺寸会显得特别有用。

调用stream.skip(n)正好相反：它会丢弃前n个元素。

我们可以用Steam类的静态的concat方法将两个流连接起来。

当然，第一个流不应该是无限的，否则第二个流永远都不会得到处理的机会。

【API】java.util.stream.Stream 8 :

- `Stream<T> limit(long maxSize)`
  产生一个流，其中包含了当前流中最初的maxSize个元素。
- `Stream<T> skip(long n)`
  产生一个流，它的元素是当前流中除了前n个元素之外的所有元素。
- `static <T> Stream<T> concat(Stream<? extends T> a, Stream<? extends T> b)`
  产生一个流，它的元素是a的元素后面跟着b的元素。

## 1.5 其他的流转换

distinct方法会返回一个流，它的元素是从原有流中产生的，即原来的元素按照同样的顺序剔除重复元素后产生的。这个流显然能够记住它已经看到过的元素。

对于流的排序，有多种sorted方法的变体可用。其中一种用于操作Comparable元素的流，而另一种可以接受一个Comparator。

peek方法会产生另一个流，它的元素与原来的流中的元素相同，但是在每次获取一个元素时，都会调用一个函数。

对于调试，你可以让peek调用一个你设置了断点的方法。

【API】java.util.stream.Stream 8 :

- `Stream<T> distinct()`
  产生一个流，包含当前流中所有不同的元素。
- `Stream<T> sorted()`
- `Stream<T> sorted(Comparator<? super T> comparator)`
  产生一个流，它的元素是当前流中的所有元素按照顺序排列的。第一个方法要求元素是实现了Comparable的类的实例。
- `Stream<T> peek(Consumer<? super T> action)`
  产生一个流，它与当前流中的元素相同，在获取其中每个元素时，会将其传递给action。

## 1.6 简单约简

约简是一种终结操作（terminal operation），它们会将流约简为可以在程序中使用的非流值。

你已经看到过一种简单约简：count方法会返回流中元素的数量。

其他的简单约简还有max和min，它们会返回最大值和最小值。

findFirst返回的是非空集合中的第一个值。

如果不强调使用第一个匹配，而是使用任意的匹配都可以，那么就可以使用findAny方法。

如果只想知道是否存在匹配，那么可以使用anyMatch。这个方法接受一个断言引元，因此不需要使用filter。

还有allMatch和noneMatch方法，它们分别会在所有元素和没有任何元素匹配断言的情况下返回true。

【API】java.util.stream.Stream 8 :

- `Optional<T> max(Comparator<? super T> comparator)`
- `Optional<T> min(Comparator<? super T> comparator)`
  分别产生这个流的最大元素和最小元素，使用由给定比较器定义的排序规则，如果这个流为空，会产生一个空的Optional对象。这些操作都是终结操作。
- `Optional<T> findFirst()`
- `Optional<T> findAny()`
  分别产生这个流的第一个和任意一个元素，如果这个流为空，会产生一个空的Optional对象。这些操作都是终结操作。
- `boolean anyMatch(Predicate <? super T> predicate)`
- `boolean allMatch(Predicate <? super T> predicate)`
- `boolean noneMatch(Predicate<? super T> predicate)`
  分别在这个流中任意元素、所有元素和没有任何元素匹配给定断言时返回true。这些操作都是终结操作。

## 1.7 Optional类型

Optional\<T>对象是一种包装器对象，要么包装了类型T的对象，要么没有包装任何对象。

### 1.7.1 如何使用Optional值

有效地使用Optional的关键是要使用这样的方法：它在值不存在的情况下会产生一个可代替物，而只有在值存在的情况下才会使用这个值。

ifPresent方法会接受一个函数。如果该可选值存在，那么它会被传递给该函数。否则，不会发生任何事情。

【API】java.util.Optional 8 :

- `T orElse(T other)`
  产生这个Optional的值，或者在该Optional为空时，产生other。
- `T orElseGet(Supplier<? extends T> other)`
  产生这个Optional的值，或者在该Optional为空时，产生调用other的结果。
- `<X extends Throwable> T orElseThrow(Supplier<? extends X> exceptionSupplier)`
  产生这个Optional的值，或者在该Optional为空时，抛出调用exceptionSupplier的结果。
- `void ifPresent(Consumer<? super T> consumer)`
  如果该Optional不为空，那么就将它的值传递给consumer。
- `<U> Optional<U> map(Function<? super T, ? extends U> mapper)`
  产生将该Optional的值传递给mapper后的结果，只要这个Optional不为空且结果不为null，否则产生一个空Optional。

### 1.7.2 不适合使用Optional值的方式

get方法会在Optional值存在的情况下获得其中包装的元素，或者在不存在的情形下抛出一个NoSuchElementException对象。

isPresent方法会报告某个Optional\<T>对象是否具有一个值。

【API】java.util.Optional 8 :

- `T get()`
  产生这个Optional的值，或者在该Optional为空时，抛出一个NoSuchElementException对象。
- `boolean isPresent()`
  如果该Optional不为空，则返回true。

### 1.7.3 创建Optional值

ofNullable方法被用来作为可能出现的null值和可选值之间的桥梁。

【API】java.util.Optional 8 :

- `static <T> Optional<T> of(T value)`
- `static <T> Optional<T> ofNullable(T value)`
  产生一个具有给定值的Optional。如果value为null，那么第一个方法会抛出一个NullPointerException对象，而第二个方法会产生一个空Optional。
- `static <T> Optional<T> empty()`
  产生一个空Optional。

### 1.7.4 用flatMap来构建Optional值的函数

【API】java.util.Optional 8 :

- `<U> Optional<U> flatMap(Function<? super T, Optional<U>> mapper)`
  产生将mapper应用于当前的Optional值所产生的结果，或者在当前Optional为空时，返回一个空Optional。

## 1.8 收集结果

调用iterator方法，它会产生可以用来访问元素的旧式风格的迭代器。

调用forEach方法，将某个函数应用于每个元素。

在并行流上，forEach方法会以任意顺序遍历各个元素。如果想要按照流中的顺序来处理它们，可以调用forEachOrdered方法。

调用toArray方法，获得由流的元素构成的数组。

因为无法在运行时创建泛型数组，所以表达式stream.toArray()会返回一个Object[]数组。如果想要让数组具有正确的类型，可以将其传递到数组构造器中。

collect方法，它会接受一个Collector接口的实例。Collectors类提供了大量应用于生成公共收集器的工厂方法。

如果想要将流的结果约简为总和、平均值、最大值或最小值，可以使用summarizing（Int| Long| Double）方法中的某一个。

【API】java.util.stream.BaseStream 8 :

- `Iterator<T> iterator()`
  产生一个用于获取当前流中各个元素的迭代器。这是一种终结操作。

【API】java.util.stream.Stream 8 :

- `void forEach(Consumer<? super T> action)`
  在流的每个元素上调用action。这是一种终结操作。
- `Object[] toArray()`
- `<A> A[] toArray(IntFunction<A[]> generator)`
  产生一个对象数组，或者在将引用A[]::new传递给构造器时，返回一个A类型的数组。这些操作都是终结操作。
- `<R,A> R collect(Collector<? super T,A,R> collector)`
  使用给定的收集器来收集当前流中的元素。Collectors类有用于多种收集器的工厂方法。

【API】java.util.stream.Collectors 8 :

- `static <T> Collector<T,?,List<T>> toList()`
- `static <T> Collector<T,?,Set<T>> toSet()`
  产生一个将元素收集到列表或集中的收集器。
- `static <T,C extends Collection<T>> Collector<T,?,C> toCollection(Supplier<C> collectionFactory)`
  产生一个将元素收集到任意集合中的收集器。可以传递一个诸如TreeSet::new的构造器引用。
- `static Collector<CharSequence,?,String> joining()`
- `static Collector<CharSequence,?,String> joining(CharSequence delimiter)`
- `static Collector<CharSequence,?,String> joining(CharSequence delimiter, CharSequence prefix, CharSequence suffix)`
  产生一个连接字符串的收集器。分隔符会置于字符串之间，而第一个字符串之前可以有前缀，最后一个字符串后可以有后缀。如果没有指定，那么它们都为空。
- `static <T> Collector<T,?,IntSummaryStatistics> summarizingInt(ToIntFunction<? super T> mapper)`
- `static<T> Collector<T,?,LongSummaryStatistics> summarizingLong(ToLongFunction<? super T> mapper)`
- `static<T> Collector<T,?,DoubleSummaryStatistics> summarizingDouble(ToDoubleFunction<? super T> mapper)`
  产生能够生成（Int| Long| Double）SummaryStatistics对象的收集器，通过它可以获得将mapper应用于每个元素后所产生的结果的个数、总和、平均值、最大值和最小值。

【API】IntSummaryStatistics 8
LongSummaryStatistics 8
DoubleSummaryStatistics 8：

- `long getCount()`
  产生汇总后的元素的个数。
- `(int|long|double) getSum()`
- `double getAverage()`
  产生汇总后的元素的总和或平均值，或者在没有任何元素时返回0。
- `(int|long|double) getMax()`
- `(int|long|double) getMin()`
  产生汇总后元素的最大值和最小值，或者在没有任何元素时，产生(Integer|Long|Double).(MAX|MIN)\_VALUE。

## 1.9 收集到映射表中

*注意：对于每一个toMap方法，都有一个等价的可以产生并发映射表的toConcurrentMap方法。*

【API】java.util.stream.Colletor 8 :

- `static<T,K,U> Collector<T,?,Map<K,U>> toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper)`
- `static<T,K,U> Collector<T,?,Map<K,U>> toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper, BinaryOperator<U> mergeFunction)`
- `static<T,K,U,M extends Map<K,U> Collector<T,?,M> toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper, BinaryOperator<U> mergeFunction, Supplier<M> mapSupplier)`
- `static<T,K,U> Collector<T,?,ConcurrentMap<K,U>> toConcurrentMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper)`
- `static<T,K,U> Collector<T,?,ConcurrentMap<K,U>> toConcurrentMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper, BinaryOperator<U> mergeFunction)`
- `static<T,K,U,M extends ConcurrentMap<K,U>> Collector<T,?,M> toConcurrentMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper, BinaryOperator<U> mergeFunction, Supplier<M> mapSupplier)`
  产生一个收集器，它会产生一个映射表或并发映射表。keyMapper和valueMapper函数会应用于每个收集到的元素上，从而在所产生的映射表中生成一个键/值项。默认情况下，当两个元素产生相同的键时，会抛出一个IllegalStateException异常。你可以提供一个mergeFunction来合并具有相同键的值。默认情况下，其结果是一个HashMap或ConcurrentHashMap。你可以提供一个mapSupplier，它会产生所期望的映射表实例。

## 1.10 群组和分区

【API】java.util.stream.Collector 8 :

- `static<T,K> Colletor<T,?,Map<K,List<T>>> groupingBy(Function<? super T,? extends K> classifier)`
- `static<T,K> Colletor<T,?,ConcurrentMap<K,List<T>>> groupingByConcurrent(Function<? super T,? extends K> classifier)`
  产生一个收集器，它会产生一个映射表或并发映射表，其键是将classifier应用于所有收集到的元素上所产生的结果，而值是由具有相同键的元素构成的一个个列表。
- `static <T> Colletor<T,?,Map<Boolean,List<T>>> partitioningBy(Predicate<? super T> predicate)`
  产生一个收集器，它会产生一个映射表，其键是true/false，而值是有满足/不满足断言的元素构成的列表。

## 1.11 下游收集器

groupingBy方法会产生一个映射表，它的每个值都是一个列表。如果想要以某种方式来处理这些列表，就需要提供一个“下游收集器”。例如，如果想要获得集而不是列表，那么可以使用Colletor.toSet收集器。

Java提供了多种可以将群组元素约简为数字的收集器：

- counting会产生收集到的元素的个数。
- summing（Int|Long|Double）会接受一个函数作为引元，将该函数应用到下游元素中，并产生它们的和。
- maxBy和minBy会接受一个比较器，并产生下游元素中的最大值和最小值。

mapping方法会产生将函数应用到下游结果上的收集器，并将函数值传递给另一个收集器。

【API】java.util.stream.Collection 8 :

- `static <T> Collector<T,?,Long> counting()`
  产生一个可以对收集到的元素进行计数的收集器。
- `static <T> Collector<T,?,Integer> summingInt(ToIntFunction<? super T> mapper)`
- `static <T> Collector<T,?,Long> summingLong(ToLongFunction<? super T> mapper)`
- `static <T> Collector<T,?,Double> summingDouble(ToIntFunction<? super T> mapper)`
  产生一个收集器，对将mapper应用到收集到的元素上之后产生的值计算总和。
- `static <T> Collector<T,?,Optional<T>> maxBy(Comparator<? super T> comparator)`
- `static <T> Collector<T,?,Optional<T>> minBy(Comparator<? super T> comparator)`
  产生一个收集器，使用comparator指定的排序方法，计算收集到的元素中的最大和最小值。
- `static <T,U,A,R> Collector<T,?,R> mapping(Function<? super T, ? extends U> mapper, Colletor<? super U, A, R> downstream)`
  产生一个收集器，它会产生一个映射表，其键是将mapper应用到收集到的数据上而产生的，其值是使用downstream收集器收集到的具有相同键的元素。

## 1.12 约简操作

reduce方法是一种用于从流中计算某个值的通用机制，其最简单的形式将接受一个二元函数，并从前两个元素开始持续应用它。

【API】java.util.Stream 8 :

- `Optional<T> reduce(BinaryOperator<T> accumulator)`
- `T reduce(T identity, BinaryOperator<T> accumulator)`
- `<U> U reduce(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner)`
  用给定的accumulator函数产生流中元素的累积总和。如果提供了幺元，那么第一个被累计的元素就是该幺元。如果提供了组合器，那么它可以用来将分别累积的各个部分整合成总和。
- `<R> Rcollect(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R,R> combiner)`
  将元素收集到类型R的结果中。在每个部分上，都会调用supplier来提供初始结果，调用accumulator来交替地将元素添加到结果中，并调用combiner来整合两个结果。

## 1.13 基本类型流

流库中具有专门的类型IntStream、LongStream和DoubleStream，用来直接存储基本类型值，而无需使用包装器。如果想要存储short、char、byte和boolean，可以使用IntStream，而对于float，可以使用DoubleStream。

为了创建IntStream，需要调用IntStream.of 和 Arrays.stream方法

与对象流一样，我们还可以使用静态的generate 和 iterate 方法。此外，IntStream 和 LongStream有静态方法range和rangeClosed，可以生成步长为1的整数范围。

CharSequence接口拥有codePoints和chars方法，可以生成由字符的Unicode码或由UTF-16编码机制的码元构成的IntStream。

当你有一个对象流时，可以用mapToInt、mapToLong和mapToDouble将其转换为基本类型流。

为了将基本类型流转换为对象流，需要使用boxed方法。

通常，基本类型流上的方法与对象流上的方法类似。下面是最主要的差异：

- toArray方法会返回基本类型数组。
- 产生可选结果的方法会返回一个OptionalInt、OptionalLong或OptionalDouble。这些类与Optional类类似，但是具有getAsInt、getAsLong和getAsDouble方法，而不是get方法。
- 具有返回总和、平均值、最大值和最小值的sum、average、max和min方法。对象流没有定义这些方法。
- summaryStatistics 方法会产生一个类型为IntSummaryStatistics、LongSummaryStatistics或DoubleSummaryStatistics的对象，它们可以同时报告流的总和、平均值、最大值和最小值。

*注意：Random类具有ints、longs和doubles方法，它们会返回由随机数构成的基本类型流。*

【API】java.util.stream.Stream 8 :

-  `static IntStream range(int startInclusive, int endExclusive)`
- `static IntStream rangeClosed(int startInclusive, int endExclusive)`
  产生一个由给定范围内的整数构成的IntStream。
- `static IntStream of(int... values)`
  产生一个由给定元素构成的IntStream。
- `int[] toArray()`
  产生一个由当前流中的元素构成的数组。
- `int sum()`
- `OptionalDouble average()`
- `OptionalInt max()`
- `OptionalInt min()`
- `IntSummaryStatistics summaryStatistics()`
  产生当前流中元素的总和、平均值、最大值和最小值，或者从中可以获得这些结果的所有四种值的对象。
- `Stream<Integer> boxed`
  产生用于当前流中的元素的包装器对象流。

【API】java.util.stream.LongStream 8 :

- `static LongStream range(long startInclusive, long endExclusive)`
- `static LongStream rangeClosed(long startInclusive, long endExclusive)`
  用给定范围内的整数产生一个LongStream。
- `static LongStream of(long... values)`
  用给定元素产生一个LongStream。
- `long[] toArray()`
  用当前流中的元素产生一个数组。
- `long sum()`
- `OptionalDouble average()`
- `OptionalLong max()`
- `OptionalLong min()`
- `LongSummaryStatistics summaryStatistics()`
  产生当前流中元素的总和、平均值、最大值和最小值，或者从中可以获得这些结果的所有四种值的对象。
- `Stream<Long> boxed()`
  产生用于当前流中的元素的包装器对象流。

【API】java.util.stream.DoubleStream 8 :

- `static DoubleStream of(double... values)`
  用给定元素产生一个DoubleStream。
- `double[] toArray()`
  用当前流中的元素产生了一个数组。
- `double sum()`
- `OptionalDouble average()`
- `OptionalDouble max()`
- `OptionalDouble min()`
- `DoubleSummaryStatistics summaryStatistics()`
  产生当前流中元素的总和、平均值、最大值和最小值，或者从中可以获得这些结果的所有四种值的对象。
- `Stream<Double> boxed()`
  产生用于当前流中的元素的包装器对象流。

【API】java.lang.CharSequence 1.0 :

- `IntStream codePoints()` 8
  产生由当前字符串的所有Unicode码点构成的流。

【API】java.util.Random 1.0 :

- `IntStream ints()`
- `IntStream ints(int randomNumberOrigin, int randomNumberBound)` 8
- `IntStream ints(long streamSize)` 8
- `IntStream ints(long streamSize, int randomNumberOrigin, int randomNumberBound)` 8
- `LongStream longs()` 8
- `LongStream longs(long randomNumberOrigin, long randomNumberBound)` 8
- `LongStream longs(long streamSize)` 8
- `LongStream longs(long streamSize, long randomNumberOrigin, long randomNumberBound)` 8
- `DoubleStream doubles()` 8
- `DoubleStream doubles(double randomNumberOrigin, double randomNumberBound)` 8
- `DoubleStream doubles(long streamSize)` 8
- `DoubleStream doubles(long streamSize, double randomNumberOrigin, double randomNumberBound)` 8
  产生随机数流。如果提供了streamSize，这个流就是具有给定数量元素的有限流。当提供了边界时，其元素将位于randomNumberOrigin（包含）和randomNumberBound（不包含）的区间内。

【API】java.util.Optional(Int|Long|Double) 8 :

- `static Optional(Int|Long|Double) of((int|long|double) value)`
  用所提供的基本类型值产生一个可选对象。
- `(int|long|double) getAs(Int|Long|Double)()`
  产生当前可选对象的值，或者在其为空时抛出一个NoSuchElementException异常。
- `(int|long|double) orElse((int|long|double) other)`
- `(int|long|double) orElseGet((int|long|double) Supplier other)`
  产生当前可选对象的值，或者在这个对象为空时产生可替代的值。
- `void ifPresent((Int|Long|Double)Consumer consumer)`
  如果当前可选对象不为空，则将其值传递给consumer。

【API】java.util.(Int|Long|Double) SummaryStatistics 8 :

- `long getCount()`
- `(int|long|double) getSum()`
- `double getAverage()`
- `(int|long|double) getMax()`
- `(int|long|double) getMin()`
  产生收集到的元素的个数、总和、平均值、最大值和最小值。

## 1.14 并行流

流使得并行处理块操作变得很容易。这个过程几乎是自动的，但是需要遵守一些规则。首先，必须有一个并行流。可以用Collection.parallelStream()方法从任何集合中获取一个并行流。

为了让并行流正常工作，需要满足大量的条件：

- 数据应该在内存中。必须等到数据到达是非常低效的。
- 流应该可以被高效地分成若干个子部分。由数组或平衡二叉树支撑的流都可以工作得很好，但是Stream.iterate返回的结果不行。
- 流操作的工作量应该具有较大的规模。如果总工作负载并不是很大，那么搭建并行计算时所付出的代价就没有什么意义。
- 流操作不应该被阻塞。

换句话说，不要将所有的流都转换为并行流。只有在对已经位于内存中的数据执行大量计算操作时，才应该使用并行流。

【API】java.util.stream.BaseStream<T,S extends BaseStream<T,S>> 8 :

- `S parallel()`
  产生一个与当前流中元素相同的并行流。
- `S unordered()`
  产生一个与当前流中元素相同的无序流。

【API】java.util.Collection\<E> 1.2 :

- `Stream<E> parallelStream()` 8
  用当前集合中的元素产生一个并行流。

