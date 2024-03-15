# 简答

**Java NIO 概述**

新 IO 和传统的 IO 有相同的目的，都是用于进行输入/输出，但新 IO 使用了不同的方式来处理输入/输出，新 IO 采用内存映射文件的方式来处理输入/输出，新 IO 将文件或文件的一段区域映射到内存中，这样就可以像访问内存一样来访问文件了（这种方式模拟了操作系统上的虚拟内存的概念），通过这种方式来进行输入/输出比传统的输入/输出要快得多。

Java 中与新 IO 相关的包如下。

- `java.nio` 包：主要包含各种与 Buffer 相关的类。
- `java.nio.channels` 包：主要包含与 Channel 和 Selector 相关的类。
- `java.nio.charset` 包：主要包含与字符集相关的类。
- `java.nio.channels.spi` 包：主要包含与 Channel 相关的服务提供者编程接口。
- `java.nio.charset.spi` 包：包含与字符集相关的服务提供者编程接口。

**Channel**（通道）和 **Buffer**（缓冲）是新 IO 中的两个核心对象，**Channel** 是对传统的输入/输出系统的模拟，在新 IO 系统中所有的数据都需要通过通道传输：Channel 与传统的 InputStream、OutputStream 最大的区别在于它提供了一个 map() 方法，通过该 map() 方法可以直接将“一块数据”映射到内存中。如果说传统的输入/输出系统是面向流的处理，则新 IO 则是面向块的处理。

**Buffer** 可以被理解成一个容器，它的本质是一个数组，发送到 Channel 中的所有对象都必须首先放到 Buffer 中，而从 Channel 中读取的数据也必须先放到 Buffer 中。此处的 Buffer 有点类似于前面介绍的“竹筒”，但该 Buffer 既可以像“竹筒”那样一次次去 Channel 中取水，也允许使用 Channel 直接将文件的某块数据映射成 Buffer。

除了 Channel 和 Buffer 之外，新 IO 还提供了用于将 Unicode 字符串映射成字节序列以及逆映射操作的 **Charset** 类，也提供了用于支持非阻塞式输入/输出的 **Selector** 类。



**Buffer**

在 Buffer 中有三个重要的概念：容量（capacity）、界限（limit）和位置（position）。

- **容量**（capacity）：缓冲区的容量（capacity）表示该 Buffer 的最大数据容量，即最多可以存储多少数据。缓冲区的容量不可能为负值，创建后不能改变。
- **界限**（limit）：第一个不应该被读出或者写入的缓冲区位置索引。也就是说，位于 limit 后的数据既不可被读，也不可被写。
- **位置**（position）：用于指明下一个可以被读出的或者写入的缓冲区位置索引（类似于 IO 流中的记录指针）。当使用 Buffer 从 Channel 中读取数据时，position 的值恰好等于已经读到了多少数据。当刚刚建立一个 Buffer 对象时，其 position 为 0；如果从 Channel 中读取了 2 个数据到该 Buffer 中，则 position 为 2，指向 Buffer 中第 3 个（第 1 个位置的索引为 0）位置。

除此之外，Buffer 里还支持一个可选的标记（mark，类似于传统 IO 流中的 mark），Buffer 允许直接将 position 定位到该 mark 处。这些值满足如下关系：

`0 ≤ mark ≤ position ≤ limit ≤ capacity`

Buffer 的主要作用就是装入数据，然后输出数据（其作用类似于前面介绍的取水的“竹筒”），开始时 Buffer 的 position 为 0，limit 为 capacity，程序可通过 `put()` 方法向 Buffer 中放入一些数据（或者从 Channel 中获取一些数据），每放入一些数据，Buffer 的 position 相应地向后移动一些位置。

当 Buffer 装入数据结束后，调用 Buffer 的 `flip()` 方法，该方法将 limit 设置为 position 所在的位置，并将 position 设为 0，这就使得 Buffer 的读写指针又移到了开始位置。也就是说，Buffer 调用 `flip()` 方法之后，Buffer 为输出数据做好准备；当 Buffer 输出数据结束后，Buffer 调用 `clear()` 方法，`clear()` 方法不是清空 Buffer 的数据，它仅仅将 position 置为 0，将 limit 置为 capacity，这样为再次向 Buffer 中装入数据做好准备。



**Channel**

Channel 类似于传统的流对象，但与传统的流对象有两个主要区别。

- Channel 可以直接将指定文件的部分或全部直接映射成 Buffer。
- 程序不能直接访问 Channel 中的数据，包括读取、写入都不行，Channel 只能与 Buffer 进行交互。也就是说，如果要从 Channel 中取得数据，必须先用 Buffer 从 Channel 中取出一些数据，然后让程序从 Buffer 中取出这些数据；如果要将程序中的数据写入 Channel，一样先让程序将数据放入 Buffer 中，程序再将 Buffer 里的数据写入 Channel 中。

Channel 中最常用的三类方法是 `map()`、`read()` 和 `write()`，其中 `map()` 方法用于将 Channel 对应的部分或全部数据映射成 ByteBuffer；而 `read()` 或 `write()` 方法都有一系列重载形式，这些方法用于从 Buffer 中读取数据或向 Buffer 中写入数据。



**NIO.2**

Java 7 对原有的 NIO 进行了重大改进，改进主要包括如下两方面的内容。

- 提供了全面的文件 IO 和文件系统访问支持。
- 基于异步 Channel 的 IO。

第一个改进表现为 Java 7 新增的 java.nio.file 包及各个子包；第二个改进表现为 Java 7 在 java.nio.channels 包下增加了多个以 Asychronous 开头的 Channel 接口和类。Java 7 把这种改进称为 NIO.2



**NIO 实现非阻塞 Socket 通信**

Java NIO 为非阻塞式 Socket 通信提供了如下几个特殊类。

- **Selector**：它是 SelectableChannel 对象的多路复用器，所有希望采用非阻塞方式进行通信的 Channel 都应该注册到 Selector 对象。可以通过调用此类的 `open()` 静态方法来创建 Selector 实例，该方法将使用系统默认的 Selector 来返回新的 Selector。

Selector 可以同时监控多个 SelectableChannel 的 IO 状况，是非阻塞 IO 的核心。一个 Selector 实例有三个 SelectionKey 集合。

- 所有的 SelectionKey 集合：代表了注册在该 Selector 上的 Channel，这个集合可以通过 `keys()` 方法返回。
- 被选择的 SelectionKey 集合：代表了所有可通过 `select()` 方法获取的、需要进行 IO 处理的 Channel，这个集合可以通过 `selectedKeys()` 返回。
- 被取消的 SelectionKey 集合：代表了所有被取消注册关系的 Channel，在下一次执行 `select()` 方法时，这些 Channel 对应的 SelectionKey 会被彻底删除，程序通常无须直接访问该集合。

应用程序可调用 SelectableChannel 的 `register()` 方法将其注册到指定 Selector 上，当该 Selector 上的某些 SelectableChannel 上有需要处理的 IO 操作时，程序可以调用 Selector 实例的 `select()` 方法获取它们的数量，并可以通过 `selectedKeys()` 方法返回它们对应的 SelectionKey 集合——通过该集合就可以获取所有需要进行 IO 处理的 SelectableChannel 集。

SelectableChannel 对象支持阻塞和非阻塞两种模式（所有的 Channel 默认都是阻塞模式），必须使用非阻塞模式才可以利用非阻塞 IO 操作。

在 NIO 的非阻塞式服务器上的所有 Channel（包括 ServerSocketChannel 和 SocketChannel）都需要向 Selector 注册，而该 Selector 则负责监视这些 Socket 的 IO 状态，当其中任意一个或多个 Channel 具有可用的 IO 操作时，该 Selector 的 `select()` 方法将会返回大于 0 的整数，该整数值就表示该 Selector 上有多少个 Channel 具有可用的 IO 操作，并提供了 `selectedKeys()` 方法来返回这些 Channel 对于的 SelectionKey 集合。正是通过 Selector，使得服务器端只需要不断地调用 Selector 实例的 select() 方法，即可知道当前的所有 Channel 是否有需要处理的 IO 操作。



**Java 7 的 AIO 实现非阻塞 Socket 通信**

Java 7 的 NIO.2 提供了异步 Channel 支持，这种异步 Channel 可以提供更高效的 IO，这种基于异步 Channel 的 IO 机制也被称为**异步 IO**（Asynchronous IO）。

NIO.2 提供了一系列以 Asynchronous 开头的 Channel 接口和类。具体来说，NIO.2 为 AIO 提供了两个接口（**AsynchronousChannel** 和继承前者的 **AsynchronousByteChannel**）和三个实现类（实现 AsynchronousChannel 的 **AsynchronousFileChannel** 和 **AsynchronousServerSocketChannel**；以及实现 AsynchronousByteChannel 的 **AsynchronousSocketChannel**），其中 AsynchronousSocketChannel、AsynchronousServerSocketChannel 是支持 TCP 通信的异步 Channel。



# 详解

# 1 NIO

BufferedReader 有一个特征——当 BufferedReader 读取输入流中的数据时，如果没有读到有效数据，程序将在此处阻塞该线程的执行（使用 InputStream 的 `read()` 方法从流中读取数据时，如果数据源中没有数据，它也会阻塞该线程），也就是**输入流、输出流都是阻塞式的输入、输出**。

不仅如此，传统的输入流、输出流都是通过字节的移动来处理的（即使不直接去处理字节流，但底层的实现还是依赖于字节处理），也就是说，**面向流的输入/输出系统一次只能处理一个字节**，因此面向流的输入/输出系统通常效率不高。

从 JDK 1.4 开始，Java 提供了一系列改进的输入/输出处理的新功能，这些功能被统称为新 IO（New IO，简称 NIO），新增了许多用于处理输入/输出的类，这些类都被放在 java.nio 包以及子包下，并且对原 java.io 包中的很多类都以 NIO 为基础进行了改写，新增了满足 NIO 的功能。

## 1.1 Java 新 IO 概述

新 IO 和传统的 IO 有相同的目的，都是用于进行输入/输出，但新 IO 使用了不同的方式来处理输入/输出，新 IO 采用内存映射文件的方式来处理输入/输出，新 IO 将文件或文件的一段区域映射到内存中，这样就可以像访问内存一样来访问文件了（这种方式模拟了操作系统上的虚拟内存的概念），通过这种方式来进行输入/输出比传统的输入/输出要快得多。

Java 中与新 IO 相关的包如下。

- `java.nio` 包：主要包含各种与 Buffer 相关的类。
- `java.nio.channels` 包：主要包含与 Channel 和 Selector 相关的类。
- `java.nio.charset` 包：主要包含与字符集相关的类。
- `java.nio.channels.spi` 包：主要包含与 Channel 相关的服务提供者编程接口。
- `java.nio.charset.spi` 包：包含与字符集相关的服务提供者编程接口。

Channel（通道）和 Buffer（缓冲）是新 IO 中的两个核心对象，Channel 是对传统的输入/输出系统的模拟，在新 IO 系统中所有的数据都需要通过通道传输：Channel 与传统的 InputStream、OutputStream 最大的区别在于它提供了一个 map() 方法，通过该 map() 方法可以直接将“一块数据”映射到内存中。如果说传统的输入/输出系统是面向流的处理，则新 IO 则是面向块的处理。

Buffer 可以被理解成一个容器，它的本质是一个数组，发送到 Channel 中的所有对象都必须首先放到 Buffer 中，而从 Channel 中读取的数据也必须先放到 Buffer 中。此处的 Buffer 有点类似于前面介绍的“竹筒”，但该 Buffer 既可以像“竹筒”那样一次次去 Channel 中取水，也允许使用 Channel 直接将文件的某块数据映射成 Buffer。

除了 Channel 和 Buffer 之外，新 IO 还提供了用于将 Unicode 字符串映射成字节序列以及逆映射操作的 Charset 类，也提供了用于支持非阻塞式输入/输出的 Selector 类。

## 1.2 使用 Buffer

从内部结构上来看，Buffer 就像一个数组，它可以保存多个类型相同的数据。Buffer 是一个抽象类，其最常用的子类是 ByteBuffer，它可以在底层字节数组上进行 get/set 操作。除了 ByteBuffer 之外，对应于其他基本数据类型（boolean 除外）都有相应的 Buffer 类：CharBuffer、ShortBuffer、IntBuffer、LongBuffer、FloatBuffer、DoubleBuffer。

上面这些 Buffer 类，除了 ByteBuffer 之外，它们都采用相同或相似的方法来管理数据，只是各自管理的数据类型不同而已。这些 Buffer 类都没有提供构造器，通过使用如下方法来得到一个 Buffer 对象。

- `static XxxBuffer allocate(int capacity)` ：创建一个容量为 capacity 的 XxxBuffer 对象。

但实际使用较多的是 ByteBuffer 和 CharBuffer，其他 Buffer 子类则较少用到。其中 ByteBuffer 类还有一个子类：MappedByteBuffer，它用于表示 Channel 将磁盘文件的部分或全部内容映射到内存中后得到的结果，通常 MappedByteBuffer 对象由 Channel 的 map() 方法返回。

在 Buffer 中有三个重要的概念：容量（capacity）、界限（limit）和位置（position）。

- **容量**（capacity）：缓冲区的容量（capacity）表示该 Buffer 的最大数据容量，即最多可以存储多少数据。缓冲区的容量不可能为负值，创建后不能改变。
- **界限**（limit）：第一个不应该被读出或者写入的缓冲区位置索引。也就是说，位于 limit 后的数据既不可被读，也不可被写。
- **位置**（position）：用于指明下一个可以被读出的或者写入的缓冲区位置索引（类似于 IO 流中的记录指针）。当使用 Buffer 从 Channel 中读取数据时，position 的值恰好等于已经读到了多少数据。当刚刚建立一个 Buffer 对象时，其 position 为 0；如果从 Channel 中读取了 2 个数据到该 Buffer 中，则 position 为 2，指向 Buffer 中第 3 个（第 1 个位置的索引为 0）位置。

除此之外，Buffer 里还支持一个可选的标记（mark，类似于传统 IO 流中的 mark），Buffer 允许直接将 position 定位到该 mark 处。这些值满足如下关系：

`0 ≤ mark ≤ position ≤ limit ≤ capacity`

Buffer 的主要作用就是装入数据，然后输出数据（其作用类似于前面介绍的取水的“竹筒”），开始时 Buffer 的 position 为 0，limit 为 capacity，程序可通过 `put()` 方法向 Buffer 中放入一些数据（或者从 Channel 中获取一些数据），每放入一些数据，Buffer 的 position 相应地向后移动一些位置。

当 Buffer 装入数据结束后，调用 Buffer 的 `flip()` 方法，该方法将 limit 设置为 position 所在的位置，并将 position 设为 0，这就使得 Buffer 的读写指针又移到了开始位置。也就是说，Buffer 调用 `flip()` 方法之后，Buffer 为输出数据做好准备；当 Buffer 输出数据结束后，Buffer 调用 `clear()` 方法，`clear()` 方法不是清空 Buffer 的数据，它仅仅将 position 置为 0，将 limit 置为 capacity，这样为再次向 Buffer 中装入数据做好准备。

> **提示**：Buffer 中包含两个重要的方法，即 `flip()` 和 `clear()`，`flip()` 为从 Buffer 中取出数据做好准备，而 clear() 为再次向 Buffer 中装入数据做好准备。

除此之外，Buffer 还包含如下一些常用的方法。

- `int capacity()`：返回 Buffer 的 capacity 大小。
- `boolean hasRemaining()`：判断当前位置（position）和界限（limit）之间是否还有元素可供处理。
- `int limit()`：返回 Buffer 的界限（limit）的位置。
- `Buffer limit(int newLt)`：重新设置界限（limit）的值，并返回一个具有新的 limit 的缓冲区对象。
- `Buffer mark()`：设置 Buffer 的 mark 位置，它只能在 0 和位置（position）之间做 mark。
- `int position()`：返回 Buffer 中的 position 值。
- `Buffer position(int newPs)`：设置 Buffer 的 position，并返回 position 被修改后的 Buffer 对象。
- `int remaining()`：返回当前位置和界限（limit）之间的元素个数。
- `Buffer reset()`：将位置（position）转到 mark 所在的位置。
- `Buffer rewind()`：将位置（position）设置成 0，取消设置的 mark。

除了这些移动 position、limit、mark 的方法之外，Buffer 的所有子类还提供了两个重要的方法：`put()` 和 `get()` 方法，用于向 Buffer 中放入数据和从 Buffer 中取出数据。当使用 `put()` 和 `get()` 方法放入、取出数据时，Buffer 既支持对单个数据的访问，也支持对批量数据的访问（以数组作为参数）。

当使用 `put()` 和 `get()` 来访问 Buffer 中的数据时，分为相对和绝对两种。

- **相对**（Relative）：从 Buffer 的当前 position 处开始读取或写入数据，然后将位置（position）的值按处理元素的个数增加。
- **绝对**（Absolute）：直接根据索引向 Buffer 中读取或写入数据，使用绝对方式访问 Buffer 里的数据时，并不会影响位置（position）的值。

下面程序示范了 Buffer 的一些常规操作：

```java
public class BufferTest {
    public static void main(String[] args) {
        // 创建 Buffer
        CharBuffer buff = CharBuffer.allocate(8); // ①
        System.out.println("capacity: " + buff.capacity());
        System.out.println("limit: " + buff.limit());
        System.out.println("position: " + buff.position());
        // 放入元素
        buff.put('a');
        buff.put('b');
        buff.put('c'); // ②
        System.out.println("加入三个元素后，position = " + buff.position());
        // 调用 flip() 方法
        buff.flip(); // ③
        System.out.println("执行 flip() 后，limit = " + buff.limit());
        System.out.println("position = " + buff.position());
        // 取出第一个元素
        System.out.println("第一个元素(position = 0): " + buff.get());
        System.out.println("取出一个元素后，position = " + buff.position());
        // 调用 clear() 方法
        buff.clear();
        System.out.println("执行 clear() 后, limit = " + buff.limit());
        System.out.println("执行 clear() 后, position = " + buff.position());
        System.out.println("执行 clear() 后, 缓冲区内容并没有被清除, 第三个元素为: " + buff.get(2));
        System.out.println("执行绝对读取后， position = " + buff.position());
    }
}
```

通过 `allocate()` 方法创建的 Buffer 对象是普通 Buffer，ByteBuffer 还提供了一个 `allocateDirect()` 方法来创建直接 Buffer。直接 Buffer 的创建成本比普通 Buffer 的创建成本高，但直接 Buffer 的读取效率更高。

> **提示**：
>
> 由于直接 Buffer 的创建成本很高，所以直接 Buffer 只适用于长生存期的 Buffer，而不适用于短生存期、一次用完就丢弃的 Buffer。而且只有 ByteBuffer 才提供了 allocateDirect() 方法，所以只能在 ByteBuffer 级别上创建直接 Buffer。如果希望使用其他类型，则应该将该 Buffer 转换成其他类型的 Buffer。

直接 Buffer 在编程上的用法与普通 Buffer 并没有太大的区别，故此处不再赘述。

## 1.3 使用 Channel

Channel 类似于传统的流对象，但与传统的流对象有两个主要区别。

- Channel 可以直接将指定文件的部分或全部直接映射成 Buffer。
- 程序不能直接访问 Channel 中的数据，包括读取、写入都不行，Channel 只能与 Buffer 进行交互。也就是说，如果要从 Channel 中取得数据，必须先用 Buffer 从 Channel 中取出一些数据，然后让程序从 Buffer 中取出这些数据；如果要将程序中的数据写入 Channel，一样先让程序将数据放入 Buffer 中，程序再将 Buffer 里的数据写入 Channel 中。

Java 为 Channel 接口提供了 DatagramChannel、FileChannel、Pipe.SinkChannel、Pipe.SourceChannel、Selectable Channel、Server Socket Channel、SocketChannel 等实现类，本节主要介绍 FileChannel 的用法。根据这些 Channel 的名字不难发现，新 IO 里的 Channel 是按功能来划分的，例如 Pipe.SinkChannel、Pipe.SourceChannel 是用于支持线程之间通信的管道 Channel；ServerSocketChannel、SocketChannel 是用于支持 TCP 网络通信的 Channel；而 DatagramChannel 则是用于支持 UDP 网络通信的 Channel。

所有的 Channel 都不应该通过构造器来直接创建，而是通过传统的节点 InputStream、OutputStream 的 `getChannel()` 方法来返回对应的 Channel，不同的节点流获得的 Channel 不一样。例如，FileInputStream、FileOutputStream 的 `getChannel()` 返回的是 FileChannel，而 PipedInputStream 和 PipedOutputStream 的 `getChannel()` 返回的是 Pipe.SinkChannel、Pipe.SourceChannel。

Channel 中最常用的三类方法是 `map()`、`read()` 和 `write()`，其中 `map()` 方法用于将 Channel 对应的部分或全部数据映射成 ByteBuffer；而 `read()` 或 `write()` 方法都有一系列重载形式，这些方法用于从 Buffer 中读取数据或向 Buffer 中写入数据。

`map()` 方法的方法签名为：`MappedByteBuffer map(FileChannel.MapMode mode, long position, long size)`，第一个参数执行映射时的模式，分别有只读、读写等模式；而第二个、第三个参数用于控制将 Channel 的哪些数据映射成 ByteBuffer。

下面程序示范了直接将 FileChannel 的全部数据映射成 ByteBuffer 的效果：

```java
public class FileChannelTest {
    public static void main(String[] args) {
        File f = new File("FileChannelTest.java");
        try (
            // 创建 FileInputStream，以该文件输入流创建 FileChannel
            FileChannel inChannel = new FileInputStream(f).getChannel();
            // 以文件输出流创建 FileChannel，用以控制输出
            FileChannel outChannel = new FileOutputStream("a.txt").getChannel())
        {
            // 将 FileChannel 里的全部数据映射成 ByteBuffer
            MappedByteBuffer buffer = inChannel.map(FileChannel.MapMode.READ_ONLY, 0, f.length()); // ①
            // 使用 GBK 的字符集来创建解码器
            Charset charset = Charset.forName("GBK");
            // 直接将 buffer 里的数据全部输出
            outChannel.write(buffer); // ②
            // 再次调用 buffer 的 clear() 方法，复原 limit、position 的位置
            buffer.clear();
            // 创建解码器（CharsetDecoder）对象
            CharsetDecoder decoder = charset.newDecoder();
            // 使用解码器将 ByteBuffer 转换成 CharBuffer
            CharBuffer charBuffer = decoder.decode(buffer);
            // CharBuffer 的 toString 方法可以获取对应的字符串
            System.out.println(charBuffer);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}
```

上面程序中的 try-with-resource 括号内的两行分别使用 FileInputStream、FileOutputStream 来获取 FileChannel，虽然 FileChannel 既可以读取也可以写入，但 FileInputStream 获取的 FileChannel 只能读，而 FileOutputStream 获取的 FileChannel 只能写。程序中 ① 号代码处直接将指定 Channel 中的全部数据映射成 ByteBuffer，然后程序中 ② 号代码处直接将整个 ByteBuffer 的全部数据写入一个输出 FileChannel 中，这就完成了文件的复制。

程序后面部分为了能将 FileChannelTest.java 文件里的内容打印出来，使用了 Charset 类和 CharsetDecoder 类将 ByteBuffer 转换成 CharBuffer。关于 Charset 和 CharsetDecorder 下一节将会有更详细的介绍。



不仅 InputStream、OutputStream 包含了 `getChannel()` 方法，在 RandomAccessFile 中也包含了一个 getChannel() 方法，RandomAccessFile 返回的 `FileChannel() ` 是只读的还是读写的，则取决于 RandomAccessFile 打开文件的模式。

例如，下面程序将会对 a.txt 文件的内容进行复制，追加在该文件后面。

```java
public class RandomFileChannelTest {
    public static void main(String[] args) throws IOException {
        File f = new File("a.txt");
        try (
            // 创建一个 RandomAccessFile 对象
            RandomAccessFile raf = new RandomAccessFile(f, "rw");
            // 获取 RandomAccessFile 对应的 Channel
            FileChannel randomChannel = raf.getChannel())
        {
            // 将 Channel 中的所有数据映射成 ByteBuffer
            ByteBuffer buffer = randomChannel.map(FileChannel.MapMode.READ_ONLY, 0, f.length());
            // 把 Channel 的记录指针移动到最后
            randomChannel.position(f.length());
            // 将 buffer 中的所有数据输出
            randomChannel.write(buffer);
        }
    }
}
```

上面程序中倒数第二行将 Channel 的记录指针移动到该 Channel 的最后，从而可以让程序将指定 ByteBuffer 的数据追加到该 Channel 的后面。每次运行上面程序，都会把 a.txt 文件的内容复制一份，并将全部内容追加到该文件的后面。

如果读者习惯了传统 IO 的“用竹筒多次重复取水”的过程，或者担心 Channel 对应的文件过大，使用 map() 方法一次将所有的文件内容映射到内存中引起性能下降，也可以使用 Channel 和 Buffer 传统的“用竹筒多次重复取水”的方式。如下程序所示：

```java
public class ReadFile {
    public static void main(String[] args) throws IOException {
        try (
            // 创建文件输入流
            FileInputStream fis = new FileInputStream("ReadFile.java");
            // 创建一个 FileChannel
            FileChannel fcin = fis.getChannel())
        {
            // 定义一个 ByteBuffer 对象，用于重复取水
            ByteBuffer bbuff = ByteBuffer.allocate(256);
            // 将 FileChannel 中的数据放入 ByteBuffer 中
            while (fcin.read(bbuff) != -1) {
                // 锁定 Buffer 的空白区
                bbuff.flip();
                // 创建 Charset 对象
                Charset charset = Charset.forName("GBK");
                // 创建解码器（CharsetDecoder）对象
                CharsetDecoder decoder = charset.newDecoder();
                // 将 ByteBuffer 的内容转码
                CharBuffer cbuff = decoder.decode(bbuff);
                System.out.print(cbuff);
                // 将 Buffer 初始化，为下一次读取数据做准备
                bbuff.clear();
            }
        }
    }
}
```

上面代码虽然使用 FileChannel 和 Buffer 来读取文件，但处理方式和使用 InputStream、byte[] 来读取文件的方式几乎一样，都是采用“用竹筒多次重复取水”的方式。但因为 Buffer 提供了 `flip()` 和 `clear()` 两个方法，所以程序处理起来比较方便，每次读取数据后调用 `flip()` 方法将没有数据的区域“封印”起来，避免程序从 Buffer 中取出 null 值；数据取出后立即调用 `clear()` 方法将 Buffer 的 position 设 0，为下一次读取数据做准备。

## 1.4 字符集和 Charset

前面已经提到：计算机里的文件、数据、图片文件只是一种表面现象，所有文件在底层都是二进制文件，即全部都是字节码。图片、音乐文件暂时先不说，对于文本文件而言，之所以可以看到一个个的字符，这完全是因为系统将底层的二进制序列转换成字符的缘故。在这个过程中涉及两个概念：**编码**（Encode）和**解码**（Decode），通常而言，把明文的字符序列转换成计算机理解的二进制序列（普通人看不懂）称为编码，把二进制序列转换成普通人能看懂的明文字符串称为解码。

Java 默认使用 Unicode 字符集，但很多操作系统并不使用 Unicode 字符集，那么当从系统中读取数据到 Java 程序中时，就可能出现乱码等问题。

JDK 1.4 提供了 Charset 来处理字节序列和字符序列（字符串）之间的转换关系，该类包含了用于创建解码器和编码器的方法，还提供了获取 Charset 所支持字符集的方法，Charset 类是不可变的。

Charset 类提供了一个 `availableCharsets()` 静态方法来获取当前 JDK 所支持的所有字符集。

每个字符集都有一个字符串名称，也被称为字符串别名。对于中国的程序员而言，下面几个字符串别名是常用的。

- GBK：简体中文字符集。
- BIG5：繁体中文字符集。
- ISO-8859-1：ISO 拉丁字母表 No.1，也叫做 ISO-LATIN-1。
- UTF-8：8 位 UCS 转换格式。
- UTF-16BE：16 位 UCS 转换格式，Big-endian（最低地址存放高位字节）字节顺序。
- UTF-16LE：16 位 UCS 转换格式，Little-endian（最高地址存放高位字节）字节顺序。
- UTF-16：16 位 UCS 转换格式，字节顺序由可选的字节顺序标记来标识。

> **提示**：可以使用 System 类的 getProperties() 方法来访问本地系统的文件编码格式，文件编码格式的属性名为 file.encoding。

获得了 Charset 对象之后，就可以通过该对象的 `newDecoder()`、`newEncoder()` 这两个方法分别返回 CharsetDecoder 和 CharsetEncoder 对象，代表该 Charset 的解码器和编码器。调用 CharsetDecoder 的 `decode()` 方法就可以将 ByteBuffer（字节序列）转换成 CharBuffer（字符序列），调用 CharsetEncoder 的 `encode()` 方法就可以将 CharBuffer 或 String（字符序列）转换成 ByteBuffer（字节序列）。

实际上，Charset 类也提供了如下三个方法。

- `CharBuffer decode(ByteBuffer bb)`：将 ByteBuffer 中的字节序列转换成字符序列的便捷方法。
- `ByteBuffer encode(CharBuffer bb)`：将 CharBuffer 中的字符序列转换成字节序列的便捷方法。
- `ByteBuffer encode(String str)`：将 String 中的字符序列转换成字节序列的便捷方法。

也就是说，获取了 Charset 对象后，如果仅仅需要进行简单的编码、解码操作，其实无须创建 CharsetEncoder 和 CharsetDecoder 对象，直接调用 Charset 的 `encode()` 和 `decode()` 方法进行编码、解码即可。

> **提示**：在 String 类里也提供了一个 `getBytes(String charset)` 方法，该方法返回 byte[]，该方法也是使用指定的字符集将字符串转换成字节序列。

## 1.5 文件锁

文件锁在操作系统中是很平常的事情，如果多个运行的程序需要并发修改同一个文件时，程序之间需要某种机制来进行通信，使用文件锁可以有效地阻止多个进程并发修改同一个文件，所以现在的大部分操作系统都提供了文件锁的功能。

文件锁控制文件的全部或部分字节的访问，但文件锁在不同的操作系统中差别较大，所以早期的 JDK 版本并为提供文件锁的支持。从 JDK 1.4 的 NIO 开始，Java 开始提供文件锁的支持。

在 NIO 中，Java 提供了 FileLock 来支持文件锁定功能，在 FileChannel 中提供的 `lock()` / `tryLock()` 方法可以获得文件锁 FileLock 对象，从而锁定文件。`lock()` 和 `tryLock()` 方法存在区别：当 `lock()` 试图锁定某个文件时，如果无法得到文件锁，程序将一直阻塞；而 `tryLock()` 是尝试锁定文件，它将直接返回而不是阻塞，如果获得了文件锁，该方法则返回该文件锁，否则将返回 null。

如果 FileChannel 只想锁定文件的部分内容，而不是锁定全部内容，则可以使用如下的 `lock()` 或 `tryLock()` 方法。

- `lock(long position, long size, boolean shared)`：对文件从 position 开始，长度为 size 的内容加锁，该方法是阻塞式的。
- `tryLock(long position, long size, boolean shared)`：非阻塞式的加锁方法。参数的作用与上一个方法类似。

当参数 shared 为 true 时，表明该锁是一个共享锁，它将允许多个进程来读取该文件，但阻止其他进程获得该文件的排他锁。当 shared 为 false 时，表明该锁是一个排他锁，它将锁住对该文件的读写。程序可以通过调用 FileLock 的 isShared 来判断它获得的锁是否为共享锁。

> **注意**：直接使用 `lock()` 或 `tryLock()` 方法获取的文件锁是排他锁。

处理完文件后通过 FileLock 的 `release()` 方法释放文件锁。

> **注意**：文件锁虽然可以用于控制并发访问，但对于高并发访问的情形，还是推荐使用数据库来保存程序信息，而不是使用文件。

关于文件锁还需要指出如下几点。

- 在某些平台上，文件锁仅仅是建议性的，并不是强制性的。这意味着即使一个程序不能获得文件锁，它也可以对该文件进行读写。
- 在某些平台上，不能同步地锁定一个文件并把它映射到内存中。
- 文件锁是由 Java 虚拟机所持有的，如果两个 Java 程序使用同一个 Java 虚拟机运行，则它们不能对同一个文件进行加锁。
- 在某些平台上关闭 FileChannel 时，会释放 Java 虚拟机在该文件上的所有锁，因此应该避免对同一个被锁定的文件打开多个 FileChannel。

# 2 Java 7 的 NIO.2

Java 7 对原有的 NIO 进行了重大改进，改进主要包括如下两方面的内容。

- 提供了全面的文件 IO 和文件系统访问支持。
- 基于异步 Channel 的 IO。

第一个改进表现为 Java 7 新增的 java.nio.file 包及各个子包；第二个改进表现为 Java 7 在 java.nio.channels 包下增加了多个以 Asychronous 开头的 Channel 接口和类。Java 7 把这种改进称为 NIO.2，本章先详细介绍 NIO 的第二个改进。

## 2.1 Path、Paths 和 Files 核心 API

早期的 Java 只提供了一个 File 类来访问文件系统，但 File 类的功能比较有限，它不能利用特定文件系统的特性，File 所提供的方法的性能也不高。而且，其大多数方法在出错时仅返回失败，并不会提供异常信息。

NIO.2 为了弥补这种不足，引入了一个 Path 接口，Path 接口代表一个平台无关的平台路径。除此之外，NIO.2 还提供了 Files、Paths 两个工具类，其中 Files 包含了大量静态的工具方法来操作文件：Paths 则包含了两个返回 Path 的静态工厂方法。

下面程序简单示范了 Path 接口的功能和用法。

```java
public class PathTest {
    public static void main(String[] args) throws Exception {
        // 以当前路径来创建 Path 对象
        Path path = Paths.get(".");
        System.out.println("path 里包含的路径数量：" + path.getNameCount());
        System.out.println("path 的根路径：" + path.getRoot());
        // 获取 path 对应的绝对路径
        Path absolutePath = path.toAbsolutePath();
        System.out.println(absolutePath);
        // 获取绝对路径的根路径
        System.out.println("absolutePath 的根路径：" + absolutePath.getRoot());
        // 获取绝对路径所包含的路径数量
        System.out.println("absolutePath 里包含的路径数量：" + absolutePath.getNameCount());
        System.out.println(absolutePath.getName(3));
        // 以多个 String 来构建 Path 对象
        Path path2 = Paths.get("g:", "publish", "codes");
        System.out.println(path2);
    }
}
```

从上面程序可以看出，Paths 提供了 `get(String first, String... more)` 方法来获取 Path 对象，Paths 会将给定的多个字符串连缀成路径，比如 `Paths.get("g:", "publish", "codes")` 就返回 `g:\publish\codes` 路径。

`getNameCount()` 方法会返回 Path 路径所包含的路径名的数量，例如 `g:\publish\codes` 调用该方法就会返回 3。



Files 是一个操作文件的工具类，它提供了大量便捷的工具方法，下面程序简单示范了 Files 类的用法。

```java
public class FilesTest {
    public static void main(String[] args) throws Exception {
        // 复制文件
        Files.copy(Paths.get("FilesTest.java"), new FileOutputStream("a.txt"));
        // 判断 FilesTest.java 文件是否为隐藏文件
        System.out.println("FilesTest.java 是否为隐藏文件：" + Files.isHidden(Paths.get("FilsTest.java")));
        // 一次性读取 FilesTest.java 文件的所有行
        List<String> lines = Files.readAllLines(Paths.get("FilesTest.java"), Charset.forName("gbk"));
        System.out.println(lines);
        // 判断指定文件的大小
        System.out.println("FilesTest.java 的大小为：" + Files.size(Paths.get("FilesTest.java")));
        
        List<String> poem = new ArrayList<>();
        poem.add("水晶潭底银鱼跃");
        poem.add("清徐风中碧杆横");
        // 直接将多个字符串内容写入指定文件中
        Files.write(Paths.get("poem.txt"), poem, Charset.forName("gbk"));
        
        // 使用 Java 8 新增的 Stream API 列出当前目录下所有文件和子目录
        Files.list(Paths.get(".")).forEach(path -> System.out.println(path)); // ①
        // 使用 Java 8 新增的 Stream API 读取文件内容
        Files.lines(Path.get("FilesTest.java"), Charset.forName("gbk")).forEach(line -> System.out.println(line)); // ②
        
        FileStore cStore = Files.getFileStore(Paths.get("C:"));
        // 判断 C 盘的总空间、可用空间
        System.out.println("C:共有空间：" + cStore.getTotalSpace());
        System.out.println("C:可用空间：" + cStore.getUsableSpace());
    }
}
```

上面程序中的粗体字代码简单示范了 Files 工具类的用法。从上面程序不难看出，Files 类是一个高度封装的工具类，它提供了大量的工具方法来完成文件复制、读取文件内容、写入文件内容等功能 —— 这些原本需要程序员通过 IO 操作才能完成的功能，现在 Files 类只要一个工具方法即可。

Java 8 进一步增强了 Files 工具类的功能，允许开发者使用 Stream API 来操作文件目录和文件内容。

## 2.2 使用 FileVisitor 遍历文件和目录

在以前的 Java 版本中，如果程序要遍历指定目录下的所有文件和子目录，则只能使用递归进行遍历，但这种方式不仅复杂，而且灵活性也不高。

有了 Files 工具类的帮助，现在可以用更优雅的方式来遍历文件和子目录。Files 类提供了如下两个方法来遍历文件和子目录。

- `walkFileTree(Path start, FileVisitor<? super Path> visitor)`：遍历 start 路径下的所有文件和子目录。
- `walkFileTree(Path start, Set<FileVisitOption> options, int maxDepth, FileVisitor<? super Path> visitor)`：与上一个方法的功能类似。该方法最多遍历 maxDepth 深度的文件。

上面两个方法都需要 FileVisitor 参数，FileVisitor 代表一个文件访问器，`walkFileTree()` 方法会自动遍历 start 路径下所有文件和子目录，遍历文件和子目录都会“触发” FileVisitor 中相应的方法。FileVisitor 中定义了如下 4 个方法。

- `FileVisitResult postVisitDirectory(T dir, IOException exc)`：访问子目录之后触发该方法。
- `FileVisitResult preVisitDirectory(T dir, BasicFileAttribute attrs)`：访问子目录之前触发该方法。
- `FileVisitResult visitFile(T dir, BasicFileAttribute attrs)`：访问 file 文件时触发该方法。
- `FileVisitResult visitFileFailed(T dir, IOException exc)`：访问 file 文件失败时触发该方法。

上面 4 个方法都返回一个 FileVisitResult 对象，它是一个枚举类，代表了访问之后的后续行为。FileVisitResult 定义了如下几种后续行为。

- **CONTINUE**：代表“继续访问”的后续行为。
- **SKIP_SIBLINGS**：代表“继续访问”的后续行为，但不访问该文件或目录的兄弟文件或目录。
- **SKIP_SUBTREE**：代表“继续访问”的后续行为，但不访问该文件或目录的子目录树。
- **TERMINATE**：代表“中止访问”的后续行为。

实际编程时没必要为 FileVisitor 的 4 个方法都提供实现，可以通过继承 SimpleFileVisitor（FileVisitor 的实现类）来实现自己的“文件访问器”，这样就根据需要、选择性地重写指定方法了。

如下程序示范了使用 FileVisitor 来遍历文件和子目录。

```java
public class FileVisitorTest {
    public static void main(String[] args) throws Exception {
        // 遍历 g:\public\codes\15 目录下的所有文件和子目录
        Files.walkFileTree(Paths.get("g:", "publish", "codes", "15"), new SimpleFileVisitor<Path>() {
            // 访问文件时触发该方法
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                System.out.println("正在访问" + file + "文件");
                // 找到了 FileVisitorTest.java 文件
                if (file.endsWith("FileVisitorTest.java")) {
                    System.out.println("--已经找到目标文件--");
                    return FileVisitResult.TERMINATE;
                }
                return FileVisitResult.CONTINUE;
            }
            // 开始访问目录时触发该方法
            @Override
            public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
                System.out.println("正在访问：" + dir + "路径");
                return FileVisitResult.CONTINUE;
            }
        });
    }
}
```

上面程序中使用了 Files 工具类的 `walkFileTree()` 方法来遍历 `g:\publish\codes\15` 目录下的所有文件和子目录，如果找到的文件以 “FileVisitorTest.java” 结尾，则程序停止遍历——这就实现了对指定目录进行搜索，直到找到指定文件为止。

## 2.3 使用 WatchService 监控文件变化

在以前的 java 版本中，如果程序需要监控文件的变化，则可以考虑启动一条后台线程，这条后台线程每隔一段时间去“遍历”一次指定目录的文件，如果发现此次遍历结果与上次遍历结果不同，则认为文件发生了变化。但这种方式不仅烦琐，而且性能也不好。

NIO.2 的 Path 类提供了如下一个方法来监听文件系统的变化。

- `register(WatchService watcher, WatchEvent.Kind<?>... events)`：用 watcher 监听该 path 代表的目录下的文件变化。events 参数指定要监听哪些类型的事件。

在这个方法中 WatchService 代表一个文件系统监听服务，它负责监听 path 代表的目录下的文件变化。一旦使用 `register()` 方法完成注册之后，接下来就可调用 WatchService 的如下三个方法来获取被监听目录的文化变化事件。

- `WatchKey poll()`：获取下一个 WatchKey，如果没有 WatchKey 发生就立即返回 null。
- `WatchKey poll(long timeout, TimeUnit unit)`：尝试等待 timeout 时间去获取下一个 WatchKey。
- `WatchKey take()`：获取下一个 WatchKey，如果没有 WatchKey 发生就一直等待。

如果程序需要一直监控，则应该选择使用 `take()` 方法；如果程序只需要监控指定时间，则可考虑使用 poll() 方法。下面程序示范了使用 WatchService 来监控 C: 盘根路径下文件的变化。

```java
public class WatchServiceTest {
    public static void main(String[] args) throws Exception {
        // 获取文件系统的 WatchService 对象
        WatchService watchService = FileSystems.getDefault().newWatchService();
        // 为 C: 盘根路径注册监听
        Paths.get("C:/").register(watchService,
                                 StandardWatchEventKinds.ENTRY_CREATE,
                                 StandardWatchEventKinds.ENTRY_MODIFY,
                                 StandardWatchEventKinds.ENTRY_DELETE);
        while (true) {
            // 获取下一个文件变化事件
            WatchKey key = watchService.take(); // ①
            for (WatchEvent<?> event : key.pollEvents()) {
                System.out.println(event.context() + " 文件发生了 " + event.kind() + "事件！");
            }
            // 重设 WatchKey
            boolean valid = key.reset();
            // 如果重设失败，退出监听
            if (!valid) {
                break;
            }
        }
    }
}
```

## 2.4 访问文件属性

早期的 Java 提供的 File 类可以访问一些简单的文件属性，比如文件大小、修改时间、文件是否隐藏、是文件还是目录等。如果程序需要获取或修改更多的文件属性，则必须利用运行所在平台的特定代码来实现，这是一件非常困难的事情。

Java 7 的 NIO.2 在 Java.nio.file.attribute 包下提供了大量的工具类，通过这些工具类，开发者可以非常简单地读取、修改文件属性。这些工具类主要分为如下两类。

- XxxAttributeView：代表某种文件属性的“视图”。
- XxxAttributes：代表某种文件属性的“集合”，程序一般通过 XxxAttributeView 对象来获取 XxxAttributes。

在这些工具类中，FileAttributeView 是其他 XxxAttributeView 的父接口，下面简单介绍一下这些 XxxAttributeView。

- **AclFileAttributeView**：通过 AclFileAttributeView，开发者可以为特定文件设置 ACL（Access Control List）及文件所有者属性。它的 `getAcl()` 方法返回 `List<AclEntry>` 对象，该返回值代表了该文件的权限集。通过 `setAcl(List)` 方法可以修改该文件的 ACL。
- **BasicFileAttributeView**：它可以获取或修改文件的基本属性，包括文件的最后修改时间、最后访问时间、创建时间、大小、是否为目录、是否为符号链接等。它的 `readAttributes()` 方法返回一个 BasicFileAttributes 对象，对文件夹基本属性的修改是通过 BasicFileAttributes 对象完成的。
- **DosFileAttributeView**：它主要用于获取或修改文件 DOS 相关属性，比如文件是否只读、是否隐藏、是否为系统文件、是否为存档文件等。它的 `readAttributes()` 方法返回一个 DosFileAttribute 对象，对这些属性的修改其实是由 DosFileAttributes 对象来完成的。
- **FileOwnerAttributeView**：它主要用于获取或修改文件的所有者。它的 `getOwner()` 方法返回一个 UserPrincipal 对象来代表文件所有者；也可调用 `setOwner(UserPrincipal owner)` 方法来改变文件的所有者。
- **PosixFileAttributeView**：它主要用于获取或修改 POSIX（Portable Operating System Interface of INIX）属性，它的 `readAttributes()` 方法返回一个 PosixFileAttributes 对象，该对象可用于获取或修改文件的所有者、组所有者、访问权限信息（就是 UNIX 的 chmod 命令负责干的事情）。这个 View 只在 UNIX、Linux 等系统上有用。
- **UserDefinedFileAttributeView**：它可以让开发者为文件设置一些自定义属性。

下面程序示范了如何读取、修改文件的属性：

```java
public class AttributeViewTest {
    public static void main(String[] args) throws Exception {
        // 获取将要操作的文件
        Path testPath = Paths.get("AttributeViewTest.java");
        
        // 获取访问基本属性的 BasicFileAttributeView
        BasicFileAttributeView basicView = Files.getFileAttributeView(testPath, BasicFileAttributeView.class);
        // 获取访问基本属性的 BasicFileAttributes
        BasicFileAttributes basicAttribs = basicView.readAttributes();
        // 访问文件的基本属性
        System.out.println("创建时间：" + new Date(basicAttribs.creationTime().toMillis()));
        System.out.println("最后访问时间：" + new Date(basicAttribs.lastAccessTime().toMillis()));
        System.out.println("最后修改时间：" + new Date(basicAttribs.lastModifiedTime().toMillis()));
        System.out.println("文件大小：" + basicAttribs.size()));
        
        // 获取访问文件属主信息的 FileOwnerAttributeView
        FileOwnerAttributeView ownerView = Files.getFileAttributeView(testPath, FileOwnerAttributeView.class);
        // 获取该文件所属用户
        System.out.println(ownerView.getOwner());
        // 获取系统中 guest 对应的用户
        UserPrincipal user = FileSystems.getDefault()
            .getUserPrincipalLookupService()
            .lookupPrincipalByName("guest");
        // 修改用户
        ownerView.setOwner(user);
        
        // 获取访问自定义属性的 UserDefinedFileAttributeView
        UserDefinedFileAttributeView userView = Files.getFileAttributeView(testPath, UserDefinedFileAttributeView.class);
        List<String> attrNames = userView.list();
        // 遍历所有的自定义属性
        for (Stirng name : attrNames) {
            ByteBuffer buf = ByteBuffer.allocate(userView.size(name));
            userView.read(name, buf);
            buf.flip();
            String value = Charset.defaultCharset().decode(buf).toString();
            System.out.println(name + "--->" + value);
        }
        // 添加一个自定义属性
        userView.write("发行者", Charset.defaultCharset().encode("疯狂 Java 联盟"));

        // 获取访问 DOS 属性的 DosFileAttributeView
        DosFileAttributeView dosView = Files.getFileAttributeView(testPath, DosFileAttributeView.class);
        // 将文件设置隐藏、只读
        dosView.setHidden(true);
        dosView.setReadOnly(true);
    }
}
```

# 3 NIO 实现非阻塞 Socket 通信

从 JDK 1.4 开始，Java 提供了 NIO API 来开发高性能的网络服务器，之前的网络通信程序是基于阻塞式 API 的 —— 即当程序执行输入、输出操作后，在这些操作返回之前会一直阻塞该线程，所以服务器端必须为每个客户端都提供一个独立线程进行处理，当服务器端需要同时处理大量客户端时，这种做法会导致性能下降。使用 NIO API 则可以让服务器端使用一个或有限几个线程来同时处理连接到服务器端的所有客户端。

Java NIO 为非阻塞式 Socket 通信提供了如下几个特殊类。

- **Selector**：它是 SelectableChannel 对象的多路复用器，所有希望采用非阻塞方式进行通信的 Channel 都应该注册到 Selector 对象。可以通过调用此类的 `open()` 静态方法来创建 Selector 实例，该方法将使用系统默认的 Selector 来返回新的 Selector。

Selector 可以同时监控多个 SelectableChannel 的 IO 状况，是非阻塞 IO 的核心。一个 Selector 实例有三个 SelectionKey 集合。

- 所有的 SelectionKey 集合：代表了注册在该 Selector 上的 Channel，这个集合可以通过 `keys()` 方法返回。
- 被选择的 SelectionKey 集合：代表了所有可通过 `select()` 方法获取的、需要进行 IO 处理的 Channel，这个集合可以通过 `selectedKeys()` 返回。
- 被取消的 SelectionKey 集合：代表了所有被取消注册关系的 Channel，在下一次执行 `select()` 方法时，这些 Channel 对应的 SelectionKey 会被彻底删除，程序通常无须直接访问该集合。

除此之外，Selector 还提供了一系列和 `select()` 相关的方法，如下所示。

- `int select()`：监控所有注册的 Channel，当它们中间有需要处理的 IO 操作时，该方法返回，并将对应的 SelectionKey 加入被选择的 SelectionKey 集合中，该方法返回这些 Channel 的数量。
- `int select(long timeout)`：可以设置超时时长的 `select()` 操作。
- `int selectNow()`：执行一个立即返回的 `select()` 操作，相对于无参数的 select() 方法而言，该方法不会阻塞线程。
- `Selector wakeup()`：使一个还未返回的 `select()` 方法立刻返回。
- `SelectableChannel`：它代表可以支持非阻塞 IO 操作的 Channel 对象，它可被注册到 Selector 上，这种注册关系由 SelectionKey 实例表示。Selector 对象提供了一个 `select()` 方法，该方法允许应用程序同时监控多个 IO Channel。

应用程序可调用 SelectableChannel 的 `register()` 方法将其注册到指定 Selector 上，当该 Selector 上的某些 SelectableChannel 上有需要处理的 IO 操作时，程序可以调用 Selector 实例的 `select()` 方法获取它们的数量，并可以通过 `selectedKeys()` 方法返回它们对应的 SelectionKey 集合——通过该集合就可以获取所有需要进行 IO 处理的 SelectableChannel 集。

SelectableChannel 对象支持阻塞和非阻塞两种模式（所有的 Channel 默认都是阻塞模式），必须使用非阻塞模式才可以利用非阻塞 IO 操作。SelectableChannel 提供了如下两个方法来设置和返回该 Channel 的模式状态。

- `SelectableChannel configureBlocking(boolean block)`：设置是否采用阻塞模式。
- `boolean isBlocking()`：返回该 Channel 是否是阻塞模式。

不同的 SelectableChannel 所支持的操作不一样，例如 ServerSocketChannel 代表一个 ServerSocket，它就只支持 OP_ACCEPT 操作。SelectableChannel 提供了如下方法来返回它支持的所有操作。

- `int validOps()`：返回一个整数值，表示这个 Channel 所支持的 IO 操作。

> **提示**：
>
> 在 SelectionKey 中，用静态常量定义了 4 种 IO 操作：OP_READ（1）、OP_WRITE（4）、OP_CONNECT（8）、OP_ACCEPT（16），这个值任意 2 个、3 个、4 个进行按位或的结果和相加的结果相等，而且它们任意 2 个、3 个、4 个相加的结果总是互不相同，所以系统可以根据 validOps() 方法的返回值确定该 SelectableChannel 支持的操作。例如返回 5，即可知道它支持读（1）和写（4）。

除此之外，SelectableChannel 还提供了如下几个方法来获取它的注册状态。

- `boolean isRegistered()`：返回该 Channel 是否已注册在一个或多个 Selector 上。
- `SelectionKey keyFor(Selector sel)`：返回该 Channel 和 sel Selector 之间的注册关系，如果不存在注册关系，则返回 null。
- `SelectionKey`：该对象代表 SelectableChannel 和 Selector 之间的注册关系。
- `ServerSocketChannel`：支持非阻塞操作，对于 java.net.ServerSocket 这个类，只支持 OP_ACCEPT 操作。该类也提供了 `accept()` 方法，功能相当于 ServerSocket 提供的 accept() 方法。
- `SocketChannel`：支持非阻塞操作，对应于 java.net.Socket 这个类，支持 OP_CONNECT、OP_READ 和 OP_WRITE 操作。这个类还实现了 ByteChannel 接口、ScatteringByteChannel 接口和 GatheringByteChannel 接口，所以可以直接通过 SocketChannel 来读写 ByteBuffer 对象。

在 NIO 的非阻塞式服务器上的所有 Channel（包括 ServerSocketChannel 和 SocketChannel）都需要向 Selector 注册，而该 Selector 则负责监视这些 Socket 的 IO 状态，当其中任意一个或多个 Channel 具有可用的 IO 操作时，该 Selector 的 `select()` 方法将会返回大于 0 的整数，该整数值就表示该 Selector 上有多少个 Channel 具有可用的 IO 操作，并提供了 `selectedKeys()` 方法来返回这些 Channel 对于的 SelectionKey 集合。正是通过 Selector，使得服务器端只需要不断地调用 Selector 实例的 select() 方法，即可知道当前的所有 Channel 是否有需要处理的 IO 操作。

> **提示**：当 Selector 上注册的所有 Channel 都没有需要处理的 IO 操作时，`select()` 方法将被阻塞，调用该方法的线程被阻塞。

本实例程序使用 NIO 实现了多人聊天室的功能，服务器端使用循环不断地获取 Selector 的 `select()` 方法返回值，当该返回值大于 0 时就处理该 Selector 上被选择的 SelectionKey 所对应的 Channel。

服务器端需要使用 ServerSocket Channel 来监听客户端的连接请求，Java 对该类的设计比较难用：它不像 ServerSocket 可以直接指定监听某个端口：而且不能使用已有的 ServerSocket 的 `getChannel()` 方法来获取 ServerSocket Channel 实例。程序必须先调用它的 `open()` 静态方法返回一个 ServerSocketChannel 实例，再使用它的 `bind()` 方法指定它在某个端口监听。创建一个可用的 Server SocketChannel 需要采用如下代码片段：

```java
// 通过 open 方法来打开一个未绑定的 ServerSocketChannel 实例
ServerSocketChannel server = ServerSocketChannel.open();
InetSocketAddress isa = new InetSocketAddress("127.0.0.1", 30000);
// 将该 ServerSocketChannel 绑定到指定 IP 地址
server.bind(isa);
```

> **提示**：在 Java 7 以前，ServerSocketChannel 的设计更糟糕——要让 ServerSocketChannel 监听指定端口，必须先调用它的 `socket()` 方法获取它关联的 ServerSocket 对象，再调用 ServerSocket 的 `bind()` 方法去监听指定端口。Java 7 为 ServerSocketChannel 新增了 `bind()` 方法，因此稍微简单了一些。

如果需要使用非阻塞方式来处理该 ServerSocketChannel，还应该设置它的非阻塞模式，并将其注册到指定的 Selector。如下代码片段所示。

```java
// 设置 ServerSocket 以非阻塞方式工作
server.configureBlocking(false);
// 将 server 注册到指定的 Selector 对象
server.register(selector, SelectionKey.OP_ACCEPT);
```

经过上面步骤后，该 ServerSocketChannel 可以接收客户端的连接请求，还需要调用 Selector 的 `select()` 方法来监听所有 Channel 上的 IO 操作。

```java
public class NServer {
    // 用于检测所有 Channel 状态的 Selector
    private Selector selector = null;
    static final int PORT = 30000;
    // 定义实现编码、解码的字符集对象
    private Charset charset = Charset.forName("UTF-8");
    public void init() throws IOException {
        selector = Selector.open();
        // 通过 open 方法来打开一个未绑定的 ServerSocketChannel 实例
        ServerSocketChannel server = ServerSocketChannel.open();
        InetSocketAddress isa = new InetSocketAddress("127.0.0.1", PORT);
		// 将该 ServerSocketChannel 绑定到指定 IP 地址
		server.bind(isa);
        // 设置 ServerSocket 以非阻塞方式工作
        server.configureBlocking(false);
        // 将 server 注册到指定的 Selector 对象
        server.register(selector, SelectionKey.OP_ACCEPT);
        while (selector.select() > 0) {
            // 依次处理 selector 上的每个已选择的 SelectionKey
            selector.selectedKeys().remove(sk); // ①
            // 如果 sk 对应的 Channel 包含客户端的连接请求
            if (sk.isAcceptable()) { // ②
                // 调用 accept 方法接收连接，产生服务器端的 SocketChannel
                SocketChannel sc = server.accept();
                // 设置采用非阻塞模式
                sc.configureBlocking(false);
                // 将该 SocketChannel 也注册到 selector
                sc.register(selector, SelectionKey.OP_READ);
                // 将 sk 对应的 Channel 设置成准备接收其他请求
                sk.interestOps(SelectionKey.OP_ACCEPT);
            }
            // 如果 sk 对应的 Channel 有数据需要读取
            if (sk.isReadable()) { // ③
                // 获取 SelectionKey 对应的 Channel，该 Channel 中有可读的数据
                SocketChannel sc = (SocketChannel)sk.channel();
                // 定义准备执行读取数据的 ByteBuffer
                ByteBuffer buff = ByteBuffer.allocate(1024);
                String content = "";
                // 开始读取数据
                try {
                    while (sc.read(buff) > 0) {
                        buff.flip();
                        content += charset.decode(buff);
                    }
                    // 打印从该 sk 对应的 Channel 里读取到的数据
                    System.out.println("读取的数据：" + content);
                    // 将 sk 对应的 Channel 设置成准备下一次读取
                    sk.interestOps(SelectionKey.OP_READ);
                } catch (IOException ex) {
                    // 如果捕获到该 sk 对应的 Channel 出现了异常，即表明该 Channel
                    // 对应的 Client 出现了问题，所以从 Selector 中取消 sk 的注册
                    
                    // 从 Selector 中删除指定的 Selection Key
                    sk.cancel();
                    if (sk.channel() != null) {
                        sk.channel().close();
                    }
                }
                // 如果 content 的长度大于 0，即聊天信息不为空
                if (content.length() > 0) {
                    // 遍历该 selector 里注册的所有 SelectionKey
                    for (SelectionKey key : selector.keys()) {
                        // 获取该 key 对应的 Channel
                        Channel targetChannel = key.channel();
                        // 如果该 Channel 是 SocketChannel 对象
                        if (targetChannel instanceof SocketChannel) {
                            // 将读到的内容写入该 Channel 中
                            SocketChannel dest = (SocketChannel)targetChannel;
                            dest.write(charset.encode(content));
                        }
                    }
                }
            }
        }
    }
    
    public static void main(String[] args) throws IOException {
        new NServer().init();
    }
}
```

上面程序启动时即建立了一个可监听连接请求的 ServerSocketChannel，并将该 Channel 注册到指定的 Selector，接着程序直接采用循环不断地监控 Selector 对象的 select() 方法返回值，当该返回值大于 0 时，处理该 Selector 上所有被选择的 SelectionKey。

开始处理指定的 SelectionKey 之后，立即从该 Selector 上被选择的 SelectionKey 集合中删除该 SelectionKey，如程序中 ① 号代码所示。

服务器端的 Selector 仅需要监听两种操作：连接和读数据，所以程序中分别处理了这两种操作，如程序中 ② 和 ③ 代码所示——处理连接操作时，系统只需将连接完成后产生的 SocketChannel 注册到指定的 Selector 对象即可；处理读数据操作时，系统先从该 Socket 中读取数据，再将数据写入 Selector 上注册的所有 Channel 中。

> **提示**：使用 NIO 来实现服务器端时，无须使用 List 来保存服务器端所有的 SocketChannel，因为所有的 SocketChannel 都已注册到指定的 Selector 对象。除此之外，当客户端关闭时会导致服务器端对应的 Channel 也抛出异常，而且本程序只有一个线程，如果该异常得不到处理将会导致整个服务器端退出，所以程序捕获了这种异常，并在处理异常时从 Selector 中删除异常 Channel 的注册。



本示例程序的客户端程序需要两个线程，一个线程负责读取用户键盘输入，并将输入的内容写入 SocketChannel 中；另一个线程则不断地查询 Selector 对象的 `select() ` 方法的返回值，如果该方法的返回值大于 0，那就说明程序需要对相应的 Channel 执行 IO 处理。

```java
public class NClient {
    // 定义检测 SocketChannel 的 Selector 对象
    private Selector selector = null;
    static final int PORT = 30000;
    // 定义处理编码和解码的字符集
    private Charset charset = Charset.forName("UTF-8");
    // 客户端 SocketChannel
    private SocketChannel sc = null;
    
    public void init() throws IOException {
        selector = Selector.open();
        InetSocketAddress isa = new InetSocketAddress("127.0.0.1", PORT);
        // 调用 open 静态方法创建连接到指定主机的 SocketChannel
        sc = SocketChannel.open(isa);
        // 设置该 sc 以非阻塞方式工作
        sc.configureBlocking(false);
        // 将 SocketChannel 对象注册到指定的 Selector
        sc.register(selector, SelectionKey.OP_READ);
        // 启动读取服务器端数据的线程
        new ClientThread().start();
        // 创建键盘输入流
        Scanner scan = new Scanner(System.in);
        while (scan.hasNextLine()) {
            // 读取键盘输入
            String line = scan.nextLine();
            // 将键盘输入的内容输出到 SocketChannel 中
            sc.write(charset.encode(line));
        }
    }
    
    // 定义读取服务器端数据的线程
    private class ClientThread extends Thread {
        public void run() {
            try {
                while (selector.select() > 0) { // ①
                    // 遍历每个有可用 IO 操作的 Channel 对应的 SelectionKey
                    for (SelectionKey sk : selector.selectionKeys()) {
                        // 删除正在处理的 SelectionKey
                        selector.selectedKeys().remove(sk);
                        // 如果该 SelectionKey 对应的 Channel 中有可读的数据
                        if (sk.isReadable()) {
                            // 使用 NIO 读取 Channel 中的数据
                            SocketChannel sc = (SocketChannel) sk.channel();
                            ByteBuffer buff = ByteBuffer.allocate(1024);
                            String content = "";
                            while (sc.read(buff) > 0) {
                                sc.read(buff);
                                buff.flip();
                                content += charset.decode(buff);
                            }
                            // 打印输出读取的内容
                            System.out.println("聊天信息： " + content);
                            // 为下一次读取做准备
                            sk.interestOps(SelectionKey.OP_READ);
                        }
                    }
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    public static void main(String[] args) throws IOException {
        new NClient().init();
    }
}
```

相比之下，客户端程序比服务器端程序要简单多了，客户端只有一个 SocketChannel，将该 SocketChannel 注册到指定的 Selector 后，程序启动另一个线程来监听该 Selector 即可。如果程序监听到该 Selector 的 `select()` 方法返回值大于 0（如上面程序中 ① 号代码），就表明该 Selector 上有需要进行 IO 处理的 Channel，接着程序取出该 Channel，并使用 NIO 读取该 Channel 中的数据。

# 4 Java 7 的 AIO 实现非阻塞 Socket 通信

Java 7 的 NIO.2 提供了异步 Channel 支持，这种异步 Channel 可以提供更高效的 IO，这种基于异步 Channel 的 IO 机制也被称为**异步 IO**（Asynchronous IO）。

> **提示**：
>
> 如果按 POSIX 的标准来划分 IO，可以把 IO 分为两类：同步 IO 和异步 IO。
>
> 对于 IO 操作可以分成两步：①程序发出 IO 请求；②完成实际的 IO 操作。
>
> 阻塞 IO、非阻塞 IO 都是针对第一步来划分的，如果发出 IO 请求会阻塞线程，就是阻塞 IO；如果发出 IO 请求没有阻塞线程，就是非阻塞 IO。
>
> 但同步 IO 和异步 IO 的区别在第二步——如果实际的 IO 操作由操作系统完成，再将结果返回给应用程序，这就是异步 IO；如果实际的 IO 需要应用程序本身去执行，会阻塞线程，那就是同步 IO。Java 的传统 IO、基于 Channel 的非阻塞 IO 其实都是同步 IO。

NIO.2 提供了一系列以 Asynchronous 开头的 Channel 接口和类。具体来说，NIO.2 为 AIO 提供了两个接口（**AsynchronousChannel** 和继承前者的 **AsynchronousByteChannel**）和三个实现类（实现 AsynchronousChannel 的 **AsynchronousFileChannel** 和 **AsynchronousServerSocketChannel**；以及实现 AsynchronousByteChannel 的 **AsynchronousSocketChannel**），其中 AsynchronousSocketChannel、AsynchronousServerSocketChannel 是支持 TCP 通信的异步 Channel，这也是本节要重点介绍的两个实现类。

AsynchronousServerSocketChannel 是一个负责监听的 Channel，与 ServerSocketChannel 相似，创建可用的 AsynchronousServerSocketChannel 需要如下两步：

- 调用它的 `open()` 静态方法创建一个未监听端口的 AsynchronousServerSocketChannel。
- 调用 AsynchronousServerSocketChannel 的 `bind()` 方法指定该 Channel 在指定地址、指定端口监听。

AsynchronousServerSocketChannel 的 `open()` 方法有以下两个版本：

- `open()`：创建一个默认的 AsynchronousServerSocketChannel。
- `open(AsynchronousChannelGroup group)`：使用指定的 AsynchronousChannelGroup 来创建 AsynchronousServerSocketChannel。

上面方法中的 AsynchronousChannelGroup 是异步 Channel 的分组管理器，它可以实现资源共享。创建 AsynchronousChannelGroup 时需要传入一个 ExecutorService，也就是说，它会绑定一个线程池，该线程池负责两个任务：处理 IO 事件和触发 CompletionHandler。

> **提示**：AIO 的 AsynchronousServerSocketChannel、AsynchronousSocketChannel 都允许使用线程池进行管理，因此创建 AsynchronousSocketChannel 时也可以传入 AsynchronousChannelGroup 对象进行分组管理。

直接创建 AsynchronousServerSocketChannel 的代码片段如下：

```java
// 以指定线程池来创建一个 AsynchronousServerSocketChannel
serverChannel = AsynchronousServerSocketChannel.open().bind(new InetSocketAddress(PORT));
```

使用 AsynchronousChannelGroup 创建 AsynchronousServerSocketChannel 的代码片段如下：

```java
// 创建一个线程池
ExecutorService executor = Executors.newFixedThreadPool(80);
// 以指定线程池来创建一个 AsynchronousChannelGroup
AsynchronousChannelGroup channelGroup = AsynchronousChannelGroup.withThreadPool(executor);
// 以指定线程池来创建一个 AsynchronousServerSocketChannel
serverChannel = AsynchronousServerSocketChannel.open(channelGroup).bind(new InetSocketAddress(PORT));
```

AsynchronousServerSocketChannel 创建成功之后，接下来可调用它的 accept() 方法来接受来自客户端的连接，由于异步 IO 的实际 IO 操作是交给操作系统来完成的，因此程序并不清楚异步 IO 操作什么时候完成——也就是说，程序调用 AsynchronousServerSocketChannel 的 `accept()` 方法之后，当前线程不会阻塞，而程序也不知道 `accept()` 方法什么时候会接收到客户端的请求。为了解决这个异步问题，AIO 为 `accept()` 方法提供了如下两个版本。

- `Future<AsynchronousSocketChannel> accept()`：接受客户端的请求。如果程序需要获得连接成功后返回的 AsynchronousSocketChannel，则应该调用该方法返回的 Future 对象的 `get()` 方法——但 `get()` 方法会阻塞线程，因此这种方式依然会阻塞当前线程。
- `<A> void accept(A attachment, CompletionHandler<AsynchronousSocketChannel, ? super A> handler)`：接受来自客户端的请求，连接成功或连接失败都会触发 CompletionHandler 对象里相应的方法。其中 AsynchronousSocketChannel 就代表连接成功后返回的 AsynchronousSocketChannel。

CompletionHandler 是一个接口，该接口中定义了如下两个方法。

- `completed(V result, A attachment)`：当 IO 操作完成时触发该方法。该方法的第一个参数代表 IO 操作所返回的对象；第二个参数代表发起 IO 操作时传入的附加参数。
- `failed(Throwable exc, A attachment)`：当 IO 操作失败时触发该方法。该方法的第一个参数代表 IO 操作失败引发的异常或错误；第二个参数代表发起 IO 操作时传入的附加参数。

通过上面的介绍不难看出，使用 AsynchronousServerSocketChannel 只要三步。

1. 调用 `open()` 静态方法创建 AsynchronousServerSocketChannel。
2. 调用 AsynchronousServerSocketChannel 的 `bind()` 方法让它在指定 IP 地址、端口监听。
3. 调用 AsynchronousServerSocketChannel 的 `accept()` 方法接受连接请求。

下面使用最简单、最少的步骤来实现一个基于 AsynchronousServerSocketChannel 的服务器端。

```java
public class SimpleAIOServer {
    static final int PORT = 30000;
    public static void main(String[] args) throws Exception {
        try (
            // ① 创建 AsynchronousServerSocketChannel 对象
            AsynchronousServerSocketChannel serverChannel = AsynchronousServerSocketChannel.open())
        {
            // ② 指定在指定地址、端口监听
            serverChannel.bind(new InetSocketAddress(PORT));
            while (true) {
                // ③ 采用循环接受来自客户端的连接
                Future<AsynchronousSocketChannel> future = serverChannel.accept();
                // 获取连接完成后返回的 AsynchronousSocketChannel
                AsynchronousSocketChannel socketChannel = future.get();
                // 执行输出
                socketChannel.write(ByteBuffer.wrap("欢迎你来到 AIO 的世界！".getBytes("UTF-8"))).get();
            }
        }
    }
}
```

上面程序中 ①②③ 号代码就代表了使用 AsynchronousServerSocketChannel 的三个基本步骤，由于该程序力求简单，因此程序并未使用 CompletionHandler 监听器。当程序接收到来自客户端的连接之后，服务器端产生了一个与客户端对应的 AsynchronousSocketChannel，它就可以执行实际的 IO 操作了。

最后一行是使用 AsynchronousSocketChannel 写入数据的代码，下面详细介绍该类的功能和用法。

AsynchronousSocketChannel 的用法也分为三步。

1. 调用 `open()` 静态方法创建 AsynchronousSocketChannel。调用 `open()` 方法时同样可指定一个 AsynchronousChannelGroup 作为分组管理器。
2. 调用 AsynchronousSocketChannel 的 `connect()` 方法连接到指定 IP 地址、指定端口的服务器。
3. 调用 AsynchronousSocketChannel 的 `read()`、`write()` 方法进行读写。

AsynchronousSocketChannel 的 `connect()`、`read()`、`write()` 方法都有两个版本：一个返回 Future 对象的版本，一个需要传入 CompletionHandler 参数的版本。对于返回 Future 对象的版本，必须等到 Future 对象的 `get()` 方法返回时 IO 操作才真正完成；对于需要传入 CompletionHandler 参数的版本，则可通过 CompletionHandler 在 IO 操作完成时触发相应的方法。

下面先用返回 Future 对象的 `read()` 方法来读取服务器端响应数据。

```java
public class SimpleAIOClient {
    static final int PORT = 30000;
    public static void main(String[] args) throws Exception {
        // 用于读取数据的 ByteBuffer
        ByteBuffer buff = ByteBuffer.allocate(1024);
        Charset utf = Charset.forName("utf-8");
        try (
            // ① 创建 AsynchronousSocketChannel 对象
            AsynchronousSocketChannel clientChannel = AsynchronousSocketChannel.open())
        {
            // ② 连接远程服务器
            clientChannel.connect(new InetSocketAddress("127.0.0.1", PORT)).get(); // ④
            buff.clear();
            // ③ 从 clientChannel 中读取数据
            clientChannel.read(buff).get(); // ⑤
            buff.flip();
            // 将 buff 中的内容转换为字符串
            String content = utf.decode(buff).toString();
            System.out.println("服务器信息: " + content);
        }
    }
}
```

上面程序中 ①②③ 号代码就代表了使用 AsynchronousSocketChannel 的三个基本步骤，当程序获得连接好的 AsynchronousSocketChannel 之后，就可通过它来执行实际的 IO 操作了。

> **上面程序中没有用到 ④⑤ 号代码的 `get()` 方法的返回值，这两个地方不调用 `get()` 方法行吗？**
>
> 程序确实没用到 ④⑤ 号代码的 `get()` 方法的返回值，但这两个地方必须调用 `get()` 方法！因为程序在连接远程服务器、读取服务器端数据时，都没有传入 CompletionHandler——因此程序无法通过该监听器在 IO 操作完成时触发待定的动作，程序必须调用 Future 返回值的 `get()` 方法，并等到 `get()` 方法完成才能确定异步 IO 操作已经执行完成。

先运行上面程序的服务端，再运行客户端，将可以看到每个客户端都可以接收到来自于服务器端的欢迎信息。上面基于 AIO 的应用程序非常简单，还没有充分利用 Java AIO 的优势，如果要充分挖掘 Java AIO 的优势，则应该考虑使用线程池来管理异步 Channel，并使用 CompletionHandler 来监听异步 IO 操作。

# 参考文档

- 《疯狂 Java 讲义》（第 3 版）15.9 NIO、15.10 Java 7 的 NIO.2、17.3.7 使用 NIO 实现非阻塞 Socket 通信、17.3.8 使用 Java 7 的 AIO 实现非阻塞通信