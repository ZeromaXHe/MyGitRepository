# Java多线程编程实战指南（设计模式篇）

# 第1章 Java多线程编程实战基础

## 1.1 无处不在的线程

进程(Process)代表运行中的程序。一个运行的Java程序就是一个进程。从操作系统的角度来看，线程（Thread）是进程中可独立执行的子任务。一个进程可以包含多个线程，同一个进程中线程共享该进程所申请到的资源，如内存空间和文件句柄等。从JVM的角度来看，线程是进程中的一个组件（Component），它可以看作执行Java代码的最小单位。Java程序中任何一段代码总是执行某个确定的线程中的。JVM启动的时候会创建一个main线程，该线程负责执行Java程序的入口方法（main方法）。如清单1-1所示的代码展示了Java程序中的代码总是由某个确定的线程运行的。

清单1-1 Java代码的执行线程
~~~java
public class JavaThreadAnywhere {
    public static void main(String[] args){
        System.out.println("The main method was executed by thread:" 
            + Thread.currentThread().getName());
        Helper helper = new Helper("Java Thread Anywhere");
        helper.run();
    }

    static class Helper implements Runnable {
        private final String message;
    
        public Helper(String message){
            this.message = message;
        }

        private void doSomething(String message){
            System.out.println("The doSomething method was executed by thread:" 
                + Thread.currentThread().getName());
            System.out.println("Do something with " + message);
        }

        @Override
        public void run(){
            doSomething(message);
        }
    }
}
~~~

如清单1-1所示的程序运行时输出如下：
~~~
The main method was executed by thread:main
The doSomething method was executed by thread:main
Do something with Java Thread Anywhere
~~~

从上面的输出可以看出，类JavaThreadAnywhere的main方法以及类Helper的doSomething方法都是由main方法负责执行的。

在多线程编程中，弄清楚一段代码具体是由哪个（或者哪种）线程去负责执行的这点很重要，这关系到性能问题、线程安全问题等。

Java中的线程可以分为守护线程（Daemon Thread）和用户线程（User Thread）。用户线程阻止JVM的正常停止，即JVM正常停止前应用程序中的所有用户线程必须先停止完毕；否则JVM无法停止。而守护线程则不会影响JVM的正常停止，即应用程序中有守护线程在运行也不影响JVM的正常停止。因此，守护线程通常用于执行一些重要性不是很高的任务，例如用于监视其他线程的运行情况。

## 1.2 线程的创建与运行

在Java语言中，一个线程就是一个java.lang.Thread类的实例。因此，在Java语言中创建一个线程就是创建一个Thread类的实例，当然这离不开内存的分配。创建一个Thread实例与创建其他类的实例所不同的是，JVM会为一个Thread实例分配两个调用栈（Call Stack）所需的内存空间。这两个调用栈一个用于跟踪Java代码间的调用关系，另一个用于跟踪Java代码对本地代码（即Native代码，通常是C代码）的调用关系。

一个Thread实例通常对应两个线程。一个是JVM中的线程（或称之为Java线程），另一个是与JVM中的线程相对应的依赖于JVM宿主机操作系统的本地（Native）线程。启动一个Java线程只需要调用相应Thread实例的start方法即可。线程启动后，当相应的线程被JVM的线程调度器调度到运行时，相应Thread实例的run方法会被JVM调用，如清单1-2所示。

清单1-2 Java线程的创建与运行
~~~java
public class JavaThreadCreationAndRun {
    public static void main(String[] args) {
        System.out.println("The main method was executed by thread:" 
                    + Thread.currentThread().getName());
        Helper helper = new Helper("Java Thread Anywhere");

        // 创建一个线程
        Thread thread = new Thread(helper);
        
        // 设置线程名
        thread.setName("A-Worker-Thread");

        // 启动线程
        thread.start();
    }

    static class Helper implements Runnable {
        private final String message;
    
        public Helper(String message){
            this.message = message;
        }

        private void doSomething(String message){
            System.out.println("The doSomething method was executed by thread:" 
                + Thread.currentThread().getName());
            System.out.println("Do something with " + message);
        }

        @Override
        public void run(){
            doSomething(message);
        }
    }
}
~~~

清单1-2中，我们通过直接new一个Thread类实例来创建一个线程。Thread类的其中一个构造器支持传入一个java.lang.Runnable接口实例，当相应线程启动时该实例的run方法会被JVM调用。

如清单1-2所示的程序运行时输出如下：
~~~
The main method was executed by thread:main
The doSomething method was executed by thread:A-Worker-Thread
Do something with Java Thread Anywhere
~~~

与清单1-1所示的代码相比，同样的类Helper的同一个方法doSomething此时是由名为A-Worker-Thread的线程而非main线程负责执行。这是因为清单1-1中，类Helper的run方法由main线程所执行的main方法直接调用，而清单1-2中类Helper的run方法我们并没有在代码中直接对其进行调用，而是由JVM通过其创建的线程（线程名为A-Worker-Thread）进行调用。

清单1-2中，对线程对象的start方法的调用（thread.start()）这段代码时运行在main方法中的，而main方法是由main线程负责执行。因此，这里我们所创建的线程thread就可以看成是main线程的一个子线程，而main线程就是该线程的父线程。

Java语言中，子线程是否是一个守护线程取决于其父线程：默认情况下父线程是守护线程则子线程也是守护线程，父线程是用户线程则子线程也是用户线程。当然，父线程在创建子线程后，启动子线程之前可以调用Thread实例的setDaemon方法来修改线程的这一属性。

Thread类自身是一个实现java.lang.Runnable接口的对象，我们也可以通过定义一个Thread类的子类来创建线程，自定义的线程类要覆盖其父类的run方法，如清单1-3所示。

清单1-3 以创建Thread子类的方式创建线程
~~~java
public class ThreadCreationViaSubclass {
    public static void main(String[] args) {
        Thread thread = new CustomThread();
        thread.start();
    }

    static class CustomThread extends Thread {
        @Override
        public void run() {
            System.out.println("Running...");
        }
    }
}
~~~

## 1.3 线程的状态与上下文切换

Java语言中，一个线程从其创建、启动到其运行结束的整个生命周期可能经历若干个状态：

- new 
- runnable （从new进行Thread.start()进入）
    - ready （从running进行Thread.yield()、 suspended by Scheduler）
    - running （selected by Scheduler）
- blocked （request blocked I/O 、try to acquire a lock从runnable进入本状态；当I/O completed或lock acquired时返回runnable状态）
- waiting （Object.wait()、Thread.join()、LockSupport.park()时从runnable进入本状态；当Object.notify()、Object.notifyAll()、waited Thread terminated、LockSupport.unpark时返回runnable状态 ）
- timed_waiting (Thread.sleep(sleepTime)、Thread.wait(timeOut)、LockSupport.parkXXX时从runnable进入本状态；timeout elapsed时返回runnable状态)
- terminated （Thread.run() exits时从runnable转为本状态）

Java线程的状态可以通过相应Thread实例的getState方法获取。该方法的返回值类型Thread.State是一个枚举类型（Enum）。Thread.State所定义的线程状态包括以下几种。

- NEW: 一个刚创建而未启动的线程处于该状态。由于一个线程实例只能够被启动一次，因此一个线程只可能有一次处于该状态。
- RUNNABLE：该状态可以看成是一个符合的状态。它包括两个子状态：READY和RUNNING。前者表示处于该状态的线程可以被JVM的线程调度器（Scheduler）进行调度而使之处于RUNNING状态。后者表示处于该状态的线程正在运行，即相应线程对象的run方法中的代码所对应的指令正在由CPU执行。当Thread实例的yield方法被调用时或者由于线程调度器的原因，相应线程的状态会由RUNNING转换为READY。
- BLOCKED：一个线程发起一个阻塞式I/O（Blocking I/O）操作后，或者试图去获得一个由其他线程持有的锁时，相应的线程会处于该状态。处于该状态的线程并不会占用CPU资源。当相应的I/O操作完成后，或者相应的锁被其他线程释放后，该线程的状态又可以转换为RUNNABLE。
- WAITING：一个线程执行了某些方法调用之后就会处于这种无限等待其他线程执行特定操作的状态。这些方法包括：Object.wait()、Thread.join()和LockSupport.park()。能够使相应线程从WAITING转换到RUNNABLE的相应方法包括：Object.notify()、Object.notifyAll()和LockSupport.unpark(thread)。
- TIMED_WAITING：该状态和WAITING类似，差别在于处于该状态的线程并非无限等待其他线程执行特定操作，而是处于带有时间限制的等待状态。当其他线程没有在指定时间内执行该线程所期望的特定操作时，该线程的状态自动转换为RUNNABLE。
- TERMINATED：已经执行结束的线程处于该状态。由于一个线程实例只能够被启动一次，因此一个线程也只可能有一次处于该状态。Thread实例的run方法正常返回或者由于抛出异常而提前终止都会导致相应线程处于该状态。

从上述描述可知，一个线程在其整个生命周期中，只可能一次处于NEW状态和TERMINATED状态。而一个线程的状态从RUNNABLE状态转换为BLOCKED、WAITING和TIMED_WAITING这几个状态中的任何一个状态都意味着上下文切换（Context Switch）的产生。

多线程环境中，当一个线程的状态由RUNNABLE转换为非RUNNABLE（BLOCKED、WAITING或者TIMED_WAITING）时，相应线程的上下文信息（即所谓的Context，包括CPU的寄存器和程序计数器在某一时间点的内容等）需要被保存，以便相应线程稍后再次进入RUNNABLE状态时能够在之前的执行进度的基础上继续前进。而一个线程的状态由非RUNNABLE状态进入RUNNABLE状态时可能涉及恢复之前保存的线程上下文信息并在此基础上前进。这个对线程的上下文信息进行保存和恢复的过程就被成为上下文切换。

上下文切换会带来额外的开销，这包括保存和恢复线程上下文信息的开销、对线程进行调度的CPU时间开销以及CPU缓存内容失效（即CPU的L1 Cache、L2 Cache等）的开销。

在Linux平台下，我们可以使用perf命令来监视Java程序运行过程中的上下文切换情况。例如，我们可以使用perf命令来监视如清单1-2所示的程序的运行，相应的命令如下：
~~~
perf stat -e cpu-clock,task-clock,cs,cache-references,cache-misses java JavaThreadCreationAndRun
~~~

上述命令中，参数e的值中的cs表示要监视被监视程序的上下文切换的数量。上述命令执行后输出的内容类似如下：

~~~
73.719681 cpu-clock(msec)
73.704906 task-clock(msec)      # 0.956 CPUs utilized
434 cs                          # 0.006 M/sec
2,361,905 cache-references      # 32.045 M/sec
419,134 cache-misses            # 17.746 % of all cache refs

0.077060925 seconds time elapsed
~~~

由此可见，如清单1-2所示的程序的这次运行一共产生了434次上下文切换。

Windows平台下，我们可以使用Windows自带的工具perfmon来监视Java程序运行过程中的上下文切换情况。

## 1.4 线程的监视

一个真实的Java系统运行时往往有上百个线程在运行，如果没有相应的工具可以对这些线程进行监视，那么这些线程对于我们来说就成了黑盒。而我们在开发过程中进行代码调试、定位问题，甚至是定位线上环境（生产环境）中的问题时往往都需要将线程变为白盒，即我们要能够知道系统中特定时刻存在哪些线程、这些线程处于什么状态以及这些线程具体是在做什么事情这些信息。

JDK自带的工具jvisualvm可以实现线程的监视，它适合于在开发和测试环境下监视Java系统中的线程情况。

当然，如果是线上环境，我们可能不便使用jvisualvm。此时可以使用JDK自带的另外一个工具jstack。jstack是一个命令行工具，通过它可以获取指定Java进程的线程信息。例如，假设某个运行的Eclipse实例对应的Java进程ID（PID）为11195，那么通过一下命令我们可以获取该Eclipse实例中的线程情况。
~~~
~/apps/java/jdk1.6.0_45/bin/jstack 11195
~~~

在Java8中，我们还可以使用Java Mission Control（JMC）这个工具来监视Java进程。

## 1.5 原子性、内存可见性和重排序——重新认识synchronized和volatile

原子（Atomic）操作指相应的操作是单一不可分割的操作。例如，对int型变量count执行counter++的操作就不是原子操作。这是因为counter++实际上可以分解为3个操作：1）读取变量counter的当前值，2）拿counter的当前值和1做加法运算，3）将counter的当前值增加1后的值赋值给counter变量。

在多线程环境中，非原子操作可能会受到其他线程的干扰。比如，上述例子如果没有对相应的代码进行同步（Synchronization）处理，则可能出现在执行第2个操作的时候counter的值已经被其他线程修改了，因此这一步的操作所使用的counter变量的“当前值”其实已经是过期的了。当然，synchronized关键字可以帮助我们实现操作的原子性，以避免这种线程间的干扰情况。

synchronized关键字可以实现操作的原子性，其本质是通过该关键字所包括的临界区（Critical Section）的排他性保证在任何一个时刻只有一个线程能够执行临界区中的代码，这使得临界区中的代码代表了一个原子操作。这一点，读者可能已经很清楚。但是，synchronized关键字所起的另外一个作用——保证内存的可见性（Memory Visibility），也是值得我们回顾的。

CPU在执行代码的时候，为了减少变量访问的时间消耗可能将代码中访问的变量的值缓存到该CPU的缓存区（如L1 Cache、L2 Cache等）中。因此相应代码再次访问某个变量时，相应的值可能是从CPU缓存区而不是主内存中读取的。同样地，代码对这些被缓存过的变量的值的修改也可能仅是被写入CPU缓存区，而没有被写回主内存。由于每个CPU都有自己的缓存区，因此一个CPU缓存区中的内容对于其他CPU而言是不可见的。这就导致了在其他CPU上运行的其他线程可能无法“看到”该线程对某个变量值所做的更改。这就是所谓的内存可见性。

synchronized关键字的另外一个作用就是它保证了一个线程执行临界区中的代码时所修改的变量值对于稍后执行该临界区中的代码的线程来说是可见的。这对于保证多线程代码的正确性来说非常重要。

而volatile关键字也能够保证内存可见性。即一个线程对一个采用volatile关键字修饰的变量的值的更改对于其他访问该变量的线程而言总是可见的。也就是说，其他线程不会读到一个“过期”的变量值。因此，有人将volatile关键字与synchronized关键字所代表的内部锁作比较，将其称为轻量级的锁。这种称呼其实并不恰当，volatile关键字只能保证内存可见性，它并不能像synchronized关键字所代表的内部锁那样能够保证操作的原子性。volatile关键字实现内存可见性的核心机制是当一个线程修改了一个volatile修饰的变量的值时，该值会被写入主内存（即RAM）而不仅仅是当前线程所在的CPU的缓存区，而其他CPU的缓存区中存储的该变量的值也会因此而失效（从而得以更新为主内存中该变量的相应值）。这就保证了其他线程访问该volatile修饰的变量时总是可以获取该变量的最新值。

volatile关键字的另外一个作用是它禁止了指令重排序（Re-order）。编译器和CPU为了提高指令的执行效率可能会进行指令重排序，这使得代码的实际执行方式可能不是按照我们所认为的方式进行的。例如下面的实例变量初始化语句：
~~~java
private SomeClass someObject = new SomeClass();
~~~

上述语句所做的事情非常简单：1）创建类SomeClass的实例， 2）将类SomeClass的实例的引用赋值给变量someObject。但是由于指令重排序的作用，这段代码的实际执行顺序可能是：1）分配一段用于存储SomeClass实例的内存空间，2）将对该内存空间的引用赋值给变量someObject，3）创建类SomeClass的实例。因此当其他线程访问someObject变量的值时，其得到的仅是指向一段存储SomeClass实例的内存空间的引用而已，而该内存空间相应的SomeClass实例的初始化可能尚未完成，这就可能导致一些意想不到的结果。而禁止指令重排序则可以使得上述代码按照我们所期望的顺序（正如代码所表达的顺序）来执行。

禁止指令重排序虽然导致编译器和CPU无法对一些指令进行可能的优化，但是它某种程度上让代码的执行看起来更符合我们的期望。

本书涉及的代码也有不少地方使用了volatile关键字。读者需要注意这个关键字对多线程代码的正确性所起的作用。

与synchronized相比，前者既能保证操作的原子性，又能保证内存可见性。而volatile仅能保证内存可见性。但是，前者会导致上下文切换，而后者不会。

## 1.6 线程的优势和风险

多线程编程具有以下优势。

- 提高系统的吞吐率（Throughput）。多线程编程使得一个线程中可以有多个并发（Concurrent，即同时进行的）的操作。例如，当一个线程因为I/O操作而处于等待时，其他线程仍然可以执行其操作。
- 提高响应性（Responsiveness）。使用多线程编程的情况下，对于GUI软件（如桌面应用程序）而言，一个慢的操作（比如从服务器上下载一个大的文件）并不会导致软件的界面出现被“冻住”的现象而无法想要用户的其他操作；对于Web应用程序而言，一个请求的处理慢了并不会影响其他请求的处理。
- 充分利用多核（Multicore）CPU资源。如今多核CPU的设备越来越普及，就算是手机这样的消费类设备也普遍使用多核CPU。实施恰当的多线程编程有助于我们充分利用设备的多核CPU资源，从而避免了资源浪费。
- 最小化对系统资源的使用。一个进程中的多个线程可以共享其所在进程所申请的资源（如内存空间），因此使用多个线程相比于使用多个进程进行编程来说，节约了对系统资源的使用。
- 简化程序的结构。线程可以简化复杂应用程序的结构。

多线程编程也有自身的问题与风险，包括：

- 线程安全（Thread Safe）问题。多个线程共享数据的时候，如果没有采取相应的并发访问控制措施，那么就可能产生数据一致性问题，如读取脏数据（过期的数据）、丢失更新（某些线程所作的更新被其他线程所作的更新覆盖）等。使用锁（包括synchronized关键字和ReentrantLock等）能够保证线程安全是大家所熟知的，本书后续章节则会提供一些不借助锁而实现线程安全的方案。
- 线程的生命特征（Thread Liveness）问题。一个线程从其创建到运行结束的整个生命周期会经历若干个状态。从单个线程的角度来看，RUNNABLE状态是我们所期望的状态。但实际上，代码编写不适当可能导致某些线程一直处于等待其他线程释放锁的状态（BLOCK状态），即产生了死锁（Dead Lock）。例如，线程T1拥有锁L1，并试图去获得锁L2，而此时线程T2拥有锁L2而试图去获得锁L1，这就导致线程T1和T2一直处于等待对方释放锁而一直又得不到锁的状态。当然，一直忙碌的线程也可能会出现问题，它可能面临活锁（Live Lock）问题，即一个线程一直在尝试某个操作但就是无法进展。另外，线程是一种稀缺的计算资源，一个系统所拥有的CPU数量相比于该系统中存在的线程数量而言总是少之又少的。某些情况可能出现线程饥饿（Starvation）的问题，即某些线程永远无法获取CPU执行的机会而永远处于RUNNABLE状态的READY子状态。
- 上下文切换。由于CPU资源的稀缺性，上下文切换可以看作是多线程编程的必然副产物，它增加了系统的消耗，不利于系统的吞吐率。
- 可靠性。多线程编程一方面可以有利于可靠性，例如某个线程意外提前终止了，但这并不影响其他线程继续其处理。另一方面，线程是进程的一个组件，它总是存在于特定的进程中的，如果这个进程由于某种原因意外提前终止了，比如某个Java进程由于内存泄露导致JVM奔溃而意外终止了，那么该进程中所有的线程也就随之而无法继续运行。因此，从提高软件可靠性的角度来看，某些情况下可能要考虑多进程多线程的编程方式，而非简单的单进程多线程方式。

## 1.7 多线程编程常用术语

|术语    |释义   |备注     |
|-------|-------|--------|
|任务（Task）|把线程比作公司员工的话，那么任务就可以被看作员工所要完成的工作内容。<br/>任务与线程并非一一对应的，通常一个线程可以用来执行多个任务。<br/>任务是一个相对的概念。<br/>一个文件可以被看作一个任务，一个文件中的多个记录可以被看作一个任务，多个文件也可以被看作一个任务||
|并发（Concurrent）|表示多个任务在同一时间段内被执行。<br/>这些任务并不是顺序执行的，而往往是以交替的方式被执行||
|并行（Parallel）|表示多个任务在同一时刻被执行||
|客户端编程（Client Thread）|从面向对象编程的角度来看，一个类总是对外提供某些服务（这也是这个类存在的意义）。<br/>其他类是通过调用该类的相应方法来使用这些服务的。<br/>因此，一个类的方法的调用方代码就被称为该类的客户端代码。<br/>相应地，执行客户端代码的线程就被称为客户端线程。<br/>因此，客户端线程也是一个相对的概念，某个类的客户端线程随着执行该方法调用方代码的线程的变化而变化|清单1-2中，类Helper的doSomething方法的客户端线程就是名为A-Worker-Thread的线程|
|工作者线程（Worker Thread）|工作者线程是相对于客户端线程而言的。<br/>它表示客户端线程之外的用于特定用途的其他线程|清单1-4展示了一个工作者线程的实例代码|
|上下文切换（Context Switch）|多线程环境中，当一个线程的状态由RUNNABLE转换为非RUNNABLE(BLOCKED、WAITING或者TIMED_WAITING)时，相应线程的上下文信息（即所谓的Context，包括CPU的寄存器和程序计数器在某一时间点的内容等）需要被保存以便相应线程稍后再次进入。<br/>RUNNABLE状态时能够在之前的执行进度的基础上继续前进。<br/>而一个线程的状态由非RUNNABLE状态进入RUNNABLE状态时也就可能涉及恢复之前保存的线程上下文信息并在此基础上前进。<br/>这个对线程的上下文信息进行保存和恢复的过程就被称为上下文切换||
|显式锁（Explicit Lock）|指在Java代码中可以使用和控制的锁，即不是编译器和CPU内部使用的锁。<br/>包括synchronized关键字和java.util.concurrent.locks.Lock接口的所有实现类||
|线程安全（Thread Safe）|一段操纵共享数据的代码能够保证在同一时间内被多个线程执行而仍然保持其正确性的，就被称为是线程安全的|清单1-5展示了一个非线程安全的计数器类。<br/>该类的increment方法被多个线程同时调用的话可能导致计数器的计数结果不正确。<br/>而清单1-6展示了线程安全的计数器类，该类可以由多个线程同时使用而不影响其计数的正确性|

清单1-4 工作者线程示例代码
~~~java
public class WorkerThread {
    public static void main(String[] args) {
        Helper helper = new Helper();
        helper.init();

        // 此处，helper的客户端线程为main线程
        helper.submit("Something...");
    }

    static class Helper {
        private final BlockingQueue<String> workQueue = new ArrayBlockingQueue<String>(100);

        // 用于处理队列workQueue中的任务的工作者线程
        private final Thread workerThread = new Thread(){
            @Override
            public void run(){
                String task = null;
                while(true){
                    try{
                        task = workQueue.take();
                    } catch (InterruptedException e) {
                        break;
                    }
                    System.out.println(doProcess(task));
                }
            }
        };
 
        public void init(){
            workerThread.start();
        }

        protected String doProcess(String task){
            return task + "->processed.";
        }

        public void submit(String task){
            try {
                workQueue.put(task);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}
~~~

清单1-5 非线程安全的计数器
~~~java
public class NonThreadSafeCounter {
    private int counter = 0;

    public void increment() {
        counter++;
    }

    public int get() {
        return counter;
    }
}
~~~

清单1-6 线程安全的计数器
~~~java
public class ThreadSafeCounter {
    private int counter = 0;

    public void increment() {
        synchronized(this){
            counter++;
        }
    }

    public int get() {
        synchronized(this){
            return counter;
        }        
    }
}
~~~

# 第2章 设计模式简介

## 2.1 设计模式及其作用

设计模式（Design Pattern）是软件设计中给定背景（Context）下普遍存在的问题一般性可复用的解决方案。

设计模式是一种可复用的设计方案，它并不是可以直接使用的代码。因此，这就涉及设计模式的实现问题，即如何将设计方案转化为可执行的代码。

设计模式可以为我们解决设计问题提高可借鉴的成熟解决方案。设计模式是在广泛实践的基础上提炼出来的设计方案。这也就意味着，许多设计模式已经被广泛运用在许多软件的设计之中。例如Java标准库API的设计就运用了许多设计模式。

设计模式为软件开发人员之间阐述和沟通设计方案提供了共用的词汇。团队开发中，软件的设计必然涉及涉及方案的讨论与沟通。一方面，负责涉及的人员之间需要进行方案的沟通。另一方面，最终负责落实设计方案的人员（编码人员）也需要理解设计方案，这当然也涉及相应的阐述和沟通。而设计模式为开发人员之间阐述和沟通设计方案提供了一个统一的基础，即大家都能理解且理解一致的词汇。

## 2.2 多线程设计模式简介

随着CPU的生产工艺从提高CPU主频频率转向多核化，以往那种靠CPU主频频率提升所带来的软件性能提升的“免费午餐”不复存在。这使得多线程编程在充分发挥系统的CPU资源以及提升软件性能方面起到了越来越重要的作用。然而，多线程编程本身又会引入开销及其他问题，如较之单线程顺序编程的复杂性、线程安全问题、死锁、活锁以及上下文切换开销等。多线程设计模式是多线程编程领域的设计模式，它可以帮助我们解决多线程编程中的许多问题。本书介绍的多线程设计模式在按其有助于解决的多线程编程问题可粗略分类如下。

- 不使用锁的情况下保证线程安全： Immutable Object（不可变对象）模式（第3章）、Thread Specific Storage（线程特有存储）模式（第10章）、Serial Thread Confinement(串行线程封闭)模式（第11章）。
- 优雅地停止线程：Two-phase Termination（两阶段终止）模式（第5章）。
- 线程协作：Guarded Suspension（保护性暂挂）模式（第4章）、Producer-Consumer（生产者/消费者）模式（第7章）。
- 提高并发性（Concurrency）、减少等待：Promise（承诺）模式（第6章）、Active Object（主动对象）模式（第8章）、Pipeline（流水线）模式（第13章）。
- 提高响应性（Responsiveness）：Master-Slave（主仆）模式（第12章）、Half-sync/Half-async（半同步/半异步）模式（第14章）。
- 减少资源消耗：Thread Pool（线程池）模式（第9章）、Serial Thread Confinement（串行线程封闭）模式（第11章）。

## 2.3 设计模式的描述

设计的模式通常都有形式化的格式来描述。但不管采用哪些格式，其表达的内容都脱离不了上述设计模式的几个要素。

描述设计模式的一种常见格式包含以下几个方面。

- 别名（Alias）。该部分指出相应模式的其他名字。
- 背景（Context）。该部分列出相应设计模式所要解决的问题所产生的背景，或者应用相应设计模式的情景。
- 问题（Problem）。该部分指出相应设计模式索要解决的问题。
- 解决方案（Solution）。该部分描述了设计模式对相应问题所提出的解决方案。
- 结果（Consequences）。该部分对设计模式进行评价，主要描述了使用相应模式会带来哪些好处以及可能存在哪些弊端。
- 相关模式（Related Patterns）。该部分描述相应模式与其他模式之间的关系。

本书第15章就是采用这种格式对本书所介绍的12个多线程方面的设计模式进行描述。不过，这一章采用这种格式进行描述的目的是方便读者在需要时进行快速参考。而为了方便讲解各个设计模式，本书在其他章中使用了以下格式进行描述。

- 模式简介。该部分主要对相应模式的核心思想和本质进行描述，以便读者对其形成基本的认识。
- 模式架构。该部分会描述相应模式设计哪些类（参与者）以及这些类之间的关系，并在此基础上描述这些类之间是如何协作从而解决相应模式所要解决的问题。也就是说，该部分从静态（类及类与类之间的关系）和动态（类之间的协作）两个角度描述了解决方案，因此被称为模式架构。
- 实战案例解析。该部分以笔者实际工作经历中应用相应模式所解决过的问题为例子，讲解了应用相应设计模式的典型场景（背景）以及相应设计模式是如何解决相应问题的。
- 模式的评价与考量。该部分会对相应设计模式进行评价，分析其优势和弊端，并对其实现和运用过程中需要注意的一些事项、重要问题及解决方法进行描述。例如，第10章介绍的Thread Specific Storage（线程特有存储）模式可以在不引入锁的情况下实现线程安全。但是其在实际使用过程中却可能导致内存泄漏这样严重的问题。
- 可复用实现代码。该部分会给出相应模式的可复用实现代码。编写模式的可复用代码可以帮助读者进一步理解相应的设计模式及其实现时需要注意的问题。另一方面，也便于读者在实际工作中运用相应的设计模式。
- Java标准库实例。该部分描述了Java标准库对相应设计模式的使用情况。Java标准库已经实现了本书介绍的部分设计模式，如Promise（承诺）模式（第6章）和Thread Specific Storage（线程特有存储）模式（第10章）。该部分重点讲解的是Java标准库对相应设计模式的使用而不是实现情况。
- 相关模式。该部分描述相应模式与其他模式之间的关系。

# 第3章 Immutable Object（不可变对象）模式

## 3.1 Immutable Object模式简介

多线程共享变量的情况下，为了保证数据一致性，往往需要对这些变量的访问进行加锁。而锁本身又会带来一些问题和开销。Immutable Object模式使得我们可以在不使用锁的情况下，既保证共享变量访问的线程安全，又能避免引入锁可能带来的问题和开销。

多线程环境中，一个对象常常会被多个线程共享。这种情况下，如果存在多个线程并发地修改该对象地状态或者一个线程访问该对象地状态而另外一个线程试图修改该对象的状态，我们不得不做一些同步访问控制以保证数据一致性。而这些同步访问控制，如显式锁（Explicit Lock）和CAS（Compare and Swap）操作，会带来额外的开销和问题，如上下文切换，等待时间和ABA问题等。Immutable Object模式的意图是通过使用对外可见的状态不可变的对象（即Immutable Object），使得被共享对象“天生”具有线程安全性，而无需额外地同步访问控制。从而既保证了数据一致性，又避免了同步访问控制所产生的额外开销和问题，也简化了编程。

所谓的状态不可变的对象，即对象一经创建，其对外可见的状态就保持不变，例如Java中的String和Integer。这点固然容易理解，但还不足以指导我们在实际工作中运用Immutable Object模式。下面我们看一个典型应用场景，一个车辆管理系统要对车辆的位置信息进行跟踪，我们可以对车辆的位置信息建立如清单3-1所示的模型。

清单3-1 状态可变的位置信息模型（非线程安全）
~~~java
public class Location{
    private double x;
    private double y;

    public Location (double x, double y){
        this.x = x;
        this.y = y;
    }

    public double getX() {
        return x;
    }
    
    public double getY() {
        return y;
    }

    public void setXY(double x, double y) {
        this.x = x;
        this.y = y;
    }
}
~~~

当系统接收到新的车辆坐标数据时，需要调用Location的setXY方法来更新位置信息。显然，清单3-1中的setXY是非线程安全的，因为对坐标数据x和y的写操作不是一个原子操作。setXY被调用，如果在x写入完毕，而y开始写之前有其他线程来读取位置信息，则该线程可能读到一个被追踪车辆根本不曾经过的位置。为了使setXY方法具备线程安全性，我们需要借助锁进行访问控制。虽然被追踪车辆的位置信息总是在变化，但是我们也可以将位置信息建模为状态不可变的对象，如清单3-2所示。

清单3-2 状态不可变的位置信息模型
~~~java
public final class Location {
    public final double x;
    public final double y;

    public Location (double x, double y) {
        this.x = x;
        this.y = y;
    }
}
~~~

使用状态不可变的位置信息模型时，如果车辆的位置发生变动，则更新车辆的位置信息时通过替换整个表示位置信息的对象（即Location实例）来实现的，如清单3-3所示。

清单3-3 在使用不可变对象的情况下更新车辆的位置信息
~~~java
public class VehicleTracker {
    private Map<String, Location> locMap = new ConcurrentHashMap<String, Location>();
    
    public void updateLocation(String vehicleId, Location newLocation) {
        locMap.put(vehicleId, newLocation);
    }
}
~~~

因此，所谓状态不可变的对象并非指被建模的现实世界的状态不可变，而是我们在建模的时候的一种决策：现实世界实体的状态总是在变化的，但我们可以用状态不可变的对象来对这些实体进行建模。

## 3.2 Immutable Object模式的架构

Immutable Object模式将现实世界中可变的实体建模为状态不可变对象，并通过创建不同的状态不可变的对象来反映实现世界实体的状态变更。

Immutable Object模式的主要参与者有以下几种。

- ImmutableObject：负责存储一组不可变状态。该参与者不对外暴露任何可以修改其状态的方法，其主要方法及职责如下。
    - getStateX, getStateN: 这些getter方法返回其所属ImmutableObject实例所维护的状态相关变量的值。这些变量在对象实例化时通过其构造器的参数获得值。
    - getStateSnapshot: 返回其所属ImmutableObject实例维护的一组状态的快照。
- Manipulator：负责维护ImmutableObject所建模的现实世界实体状态的变更。当相应的现实实体状态变更时，该参与者负责生成新的ImmutableObject的实例，以反映新的状态。
    - changeStateTo: 根据新的状态值生成新的ImmutableObject的实例。

不可变对象的使用主要包括以下几种类型。
- 获取单个状态的值：调用不可变对象的相关getter方法即可实现。
- 获取一组状态的快照：不可变对象可以提供一个getter方法，该方法需要对其返回值做防御性复制或者返回一个只读的对象，以避免其状态对外泄露而被改变。
- 生成新的不可变对象实例：当被建模对象的状态发生变化的时候，创建新的不可变对象实例来反映这种变化。

Immutable Object模式的典型交互场景的序列图如图3-2所示。

第1~4步：客户端代码获取当前ImmutableObject实例的各个状态值。

第5步：客户端代码调用Manipulator的changeStateTo方法来更新应用的状态。

第6、7步：changeStateTo方法创建新的ImmutableObject实例以反映应用的新状态，并返回。

第8、9步：客户端代码获取新的ImmutableObject实例的状态快照。

一个严格意义上不可变对象要满足以下所有条件。

1. 类本身使用final修饰：防止其子类改变其定义的行为。
2. 所有字段都是用final修饰的：使用final修饰不仅仅是从语义上说明被修饰字段的引用不可改变。更重要的是这个语义在多线程环境下由JMM（Java Memory Model）保证了被修饰字段所引用对象的初始化安全，即final修饰的字段在其他线程可见时，它必定是初始化完成的。相反，非final修饰的字段由于缺少这种保证，可能导致一个线程“看到”一个字段的时候，它还未被初始化完成，从而可能导致一些不可预料的结果。
3. 在对象的创建过程中，this关键字没有泄露给其他类：防止其他类（如该类的内部匿名类）在对象创建过程中修改其状态。
4. 任何字段，若其引用了其他状态可变的对象（如集合、数组等），则这些字段必须是private修饰的，并且这些字段值不能对外暴露。若有相关方法要返回这些字段值，应该进行防御性复制（Defensive Copy）。

## 3.3 Immutable Object模式实战案例解析

某彩信网关系统在处理增值业务提供商（VASP， Value-Added Service Provider）下发给手机终端用户的彩信消息时，需要根据彩信接收方号码的前缀（如1381234）选择对应的彩信中心（MMSC，Multimedia Messaging Service Center），然后转发消息给选中的彩信中心，由其负责对接电信网络将彩信消息下发给手机终端用户。彩信中心相对于彩信网关系统而言，它是一个独立的部件，二者通过网络进行交互。这个选择彩信中心的过程，我们称之为路由（Routing）。而手机号前缀和彩信中心的这种对应关系，被称为路由表。路由表在软件运维过程中可能发生变化。例如，业务扩容带来的新增彩信中心、为某个号码前缀指定新的彩信中心等。虽然路由表在该系统中是由多线程共享的数据，但是这些数据的变化频率并不高。因此，即使是为了保证线程安全，我们也不希望对这些数据的访问进行加锁等并发访问控制，以免产生不必要的开销和问题。这时，Immutable Object模式就派上用场了。

维护路由表可以被建模为一个不可变对象，如清单3-4所示。

清单3-4 使用不可变对象维护路由表
~~~java
/**
 * 彩信中心路由规则管理器
 * 模式角色：ImmutableObject.ImmutableObject
 */
public final class MMSCRouter {
    //用volatile修饰，保证多线程环境下该变量的可见性
    private static volatile MMSCRouter instance = new MMSCRouter();
    //维护手机号码前缀到彩信中心之间的映射关系
    private final Map<String, MMSCInfo> routeMap;

    public MMSCRouter() {
        //将数据库表中的数据加载到内存，存为Map
        this.routeMap = MMSCRouter.retrieveRouteMapFromDB();
    }

    private static Map<String, MMSCInfo> retrieveRouteMapFromDB() {
        Map<String, MMSCInfo> map = new HashMap<String, MMSCInfo>();
        //省略其他代码
        return map;
    }
    
    public static MMSCRouter getInstance() {
        return instance;
    }

    /**
     * 根据手机号码前缀获取对应的彩信中心信息
     *
     * @param msisdnPrefix 手机号码前缀
     * @return 彩信中心信息
     */
    public MMSCInfo getMMSC(String msisdnPrefix) {
        return routeMap.get(msisdnPrefix);
    }

    /**
     * 将当前MMSCRouter的实例更新为指定的新实例
     *
     * @param newInstance 新的MMSCRouter实例
     */
    public static void setInstance(MMSCRouter newInstance) {
        instance = newInstance;
    }

    private static Map<String, MMSCInfo> deepCopy(Map<String, MMSCInfo> m) {
        Map<String, MMSCInfo> result = new HashMap<String, MMSCInfo>();
        for(String key: m.keySet()){
            result.put(key, new MMSCInfo(m.get(key)));
        }
        return result;
    }

    public Map<String, MMSCInfo> getRouteMap(){
        //做防御性复制
        return Collections.unmodifiableMap(deepCopy(routeMap));
    }
}
~~~

而彩信中心的相关数据，如彩信中心设备编号、URL、支持的最大附件尺寸也被建模为一个不可变对象，如清单3-5所示。

清单3-5 使用不可变对象表示彩信中心信息
~~~java
/**
 * 彩信中心信息
 *
 * 模式角色：ImmutableObject.ImmutableObject
 */
public final class MMSCInfo {
    /**
     * 设备编号
     */
    private final String deviceID;
    /**
     * 彩信中心URL
     */
    private final String url;
    /**
     * 该彩信中心允许的最大附件大小
     */
    private final int maxAttachmentSizeInBytes;

    public MMSCInfo(String deviceID, String url, int maxAttachmentSizeInBytes){
        this.deviceID = deviceID;
        this.url = url;
        this.maxAttachmentSizeInBytes = maxAttachmentSizeInBytes;
    }

    public MMSCInfo(MMSCInfo prototype) {
        this.deviceID = prototype.deviceID;
        this.url = prototype.url;
        this.maxAttachmentSizeInBytes = prototype.maxAttachmentSizeInBytes;
    }

    public String getDeviceID() {
        return deviceID;
    }

    public String getUrl() {
        return url;
    }

    public int getMaxAttachmentSizeInBytes() {
        return maxAttachmentSizeInBytes;
    }
}
~~~

彩信中心信息变更的频率也同样不高。因此，当彩信网关系统通过网络（Socket连接）被通知到这种彩信中心信息本身或者路由表变更时，网关系统会重新生成新的MMSCInfo和MMSCRouter来反映这种变更，如清单3-6所示。

~~~java
/**
 * 与运维中心（Operation and Maintenance Center）对接的类
 * 模式角色：ImmutableObject.Manipulator
 */
public class OMCAgent extends Thread {
    @Override
    public void run(){
        boolean isTableModificationMsg = false;
        String updateTableName = null;
        while(true){
            //省略其他代码
            /*
             * 从与OMC连接的Socket中读取消息并进行解析，
             * 解析到数据表更新消息后，重置MMSCRouter实例。
             */
            if(isTableModificationMsg) {
                if("MMSCInfo".equals(updateTableName)) {
                    MMSCRouter.setInstance(new MMSCRouter());
                }
            }
            //省略其他代码
        }
    }
}
~~~

上述代码会调用MMSCRouter的setInstance方法来替换MMSCRouter的实例为新创建的实例。而新创建的MMSCRouter实例通过其构造器会生成多个新的MMSCInfo的实例。

本案例中，MMSCInfo是一个严格意义上的不可变对象。虽然MMSCRouter对外提供了setInstance方法用于改变其静态字段instance的值，但它仍然可被视作一个等效的不可变对象。这是因为setInstance方法仅仅改变instance变量指向的对象，而instance变量采用volatile修饰保证了其在多线程之间的内存可见性，所以这意味着setInstance对instance变量的改变无须加锁也能保证线程安全。而其他代码在调用MMSCRouter的相关方法获取路由信息时也无须加锁。

从图3-1的类图上看，OMCAgent类（见清单3-6）是一个Manipulator参与者实例，而MMSCInfo、MMSCRouter是一个ImmutableObject参与者实例。通过使用不可变对象，我们既可以应对路由表、彩信中心这些不是非常频繁的变更，又可以使系统中使用路由表的代码免于并发访问控制的开销和问题。

## 3.4 Immutable Object模式的评价与实现考量

不可变对象具有天生的线程安全性，多个线程共享一个不可变对象的时候无需使用额外的并发访问控制，这使得我们可以避免显式锁等并发访问控制的开销和问题，简化了多线程编程。

Immutable Object模式特别适用于以下场景：

- 被建模对象的状态变化不频繁：正如本章案例所展示的，这种场景下可以设置一个专门的线程（Manipulator参与者所在的线程）用于在被建模对象状态变化时创建新的不可变对象。而其他线程则只是读取不可变对象的状态。此场景下的一个小技巧是Manipulator对不可变对象的引用采用volatile关键字修饰，既可以避免使用显式锁（如synchronized），又可以保证多线程间的内存可见性。
- 同时对一组相关的数据进行写操作，因此需要保证原子性：此场景为了保证操作的原子性，通常的做法是使用显式锁。但若采用Immutable Object模式，将这一组相关的数据“组合”成一个不可变对象，则对这一组数据的操作就可以无需加显式锁也能保证原子性，这既简化了编程，又提高了代码运行效率。本章开头所举的车辆位置跟踪的例子正是这种场景。
- 使用某个对象作为安全的HashMap的key：我们知道，一个对象作为HashMap的Key被“放入”HashMap之后，若该对象状态变化导致了其Hash Code的变化，则会导致后面在同样的对象作为Key去get的时候无法获取关联的值，尽管该HashMap中的确存在以该对象为Key的条目。相反，由于不可变对象的状态不变，因此其Hash Code也不变。这使得不可变对象非常适于用作HashMap的Key。

Immutable Object模式实现时需要注意以下几个问题。

- 被建模对象的状态变更比较频繁：此时也不见得不能使用Immutable Object模式。只是这意味着频繁创建新的不可变对象，因此会增加JVM垃圾回收（Garbage Collection）的负担和CPU消耗，我们需要综合考虑：被建模对象的规模、代码目标运行环境的JVM内存分配情况、系统对吞吐率和响应性的要求。若这几个方面因素综合考虑都能满足要求，那么使用不可变对象建模也未尝不可。
- 使用等效或者近似的不可变对象：有时创建严格意义上的不可变对象比较难，但是尽量向严格意义上的不可变对象靠拢也有利于发挥不可变对象的好处。
- 防御性复制：如果不可变对象本身包含一些状态需要对外暴露，而相应的字段本身又是可变的（如HashMap），那么返回这些字段的方法还是需要做防御性复制，以避免外部代码修改了其内部状态。正如清单3-4的代码中的getRouteMap方法所展示的。

## 3.5 Immutable Object模式的可复用实现代码

Immutable Object模式不便于实现可复用的代码。我们需要根据实际应用具体实现。

## 3.6 Java标准库实例

在多线程环境中，遍历一个集合（Collection，如java.util.Vector）对象时，即便被遍历的对象本身是线程安全的，开发人员仍然不得不引入锁，以防止遍历过程中该集合的内部结构被其他线程改变（如删除或者插入了一个新的元素）而导致出错，如清单3-7所示。

清单3-7 遍历线程安全的集合时加锁
~~~java
Vector vector = null;

//此处以vector本身为锁，防止遍历过程中的其他线程改变其内部结构
synchronized (vector) {
    for(int i = 0; i < vector.size(); i++){
        doSomethingWith(vector.get(i));
    }
}
~~~

为了保证线程安全而在遍历时对集合对象进行加锁，但这在某些情形下可能并不合适，比如系统中对该集合的插入和删除操作的频率远比遍历操作的频率要高。JDK1.5中引入的类java.util.concurrent.CopyOnWriteArrayList应用了Immutable Object模式，使得对CopyOnWriteArrayList实例进行遍历时不用加锁也能保证线程安全。当然，CopyOnWriteArrayList也不是“万能”的，它是专门针对遍历操作的频率比添加和删除操作更加频繁的场景设计的。CopyOnWriteArrayList的源码（骨架）如清单3-8所示。

清单3-8 JDK类CopyOnWriteArrayList的源码（骨架）
~~~java

~~~

CopyOnWriteArrayList内部维护一个名为array的实例变量用于存储集合的各个元素。

## 3.7 相关模式

### 3.7.1 Thread Specific Storage 模式（第10章）

Immutable Object模式使得我们可以在不使用显式锁的情况下保证线程安全。Thread Specific Storage（线程特有存储）模式也可以帮我们达到相同的效果，只不过二者的具体实现方式不同。

### 3.7.2 Serial Thread Confinement模式（第11章）

Serial Thread Confinement模式也可以使我们在不使用显式锁的情况下保证线程安全。只不过在使用Serial Thread Confinement 模式来实现线程安全的时候，Serial Thread Confinement模式用到的队列本身实际上涉及了显式锁。因此，使用Serial Thread Confinement模式来保证线程安全实际上是试图用一种更小的锁开销去（队列所涉及的锁开销）替代另外一种可能更大的锁开销（工作者线程如果采用锁带来的开销）。

# 第4章 Guarded Suspension（保护性暂挂）模式

## 4.1 Guarded Suspension模式简介

多线程编程中，为了提高并发性，往往将一个任务分解为不同的部分，将其交由不同的线程来执行。这些线程间相互协作时，仍然可能会出现一个线程去等待另一个线程完成一定的操作，其自身才能继续运行的情形。这好比汽车行驶过程中油量不足时，司机只好到加油站等工作人员将油加满才能继续行驶。

Guarded Suspension模式可以帮助我们解决上述的等待问题。该模式的核心思想是如果某个线程执行特定的操作前需要满足一定的条件，则在该条件未满足时将该线程暂停运行（即暂挂线程，使其处于等待（WAITING）状态，直到该条件满足时才继续该线程的运行）。这里，读者可能会想到wait/notify。的确，wait/notify可以用来实现Guarded Suspension模式。但是，Guarded Suspension模式还要解决wait/notify所解决的问题之外的问题。

## 4.2 Guarded Suspension模式的架构

## 4.3 Guarded Suspension模式实战案例解析

## 4.4 Guarded Suspension模式的评价与实现考量

Guarded Suspension模式使应用程序避免了样板式代码。Guarded Suspension模式的Blocker参与者所实现的线程挂起与唤醒功能固然可以由应用代码直接使用wait/notify或者java.util.concurrent.locks.Condition来实现，但是这里面涉及几个比较容易犯错的重要技术细节（下文会提到）。这些细节如果散落在应用代码中，则会增加出错的概率。另外，应用直接编写代码来正确实现这些技术细节往往导致许多样板式代码。这不仅增加了代码编写的工作量，而且也增加了出错的概率。相反，Guarded Suspension模式的Blocker参与者封装了这些易错的技术细节，从而减少了应用代码的编写量和出错的概率。

关注点分离（Separation Of Concern）。

可能增加JVM垃圾回收的负担。

可能增加上下文切换（Context Switch）。

Blocker实现类中封装的几个易错的重要技术细节介绍如下。

### 4.4.1 内存可见性和锁泄漏（Lock Leak）

保护条件中涉及的变量牵涉读线程和写线程进行共享访问。保护方法的执行线程是读线程，它读取这些变量以判断保护条件是否成立。而写线程是受保护对象实例的stateChanged方法的执行线程，它会去更改这些变量的值。因此，对保护条件涉及的变量的访问应该使用锁进行保护，以保证写线程对这些变量所做的更改，读线程能够“看到”相应的值。从清单4-5的代码可以看出，这点已经被封装在Blocker实例的几个方法中了。应用代码只需要在创建Blocker实例时在其构造器中指定恰当的锁实例即可。

ConditionVarBlocker类（代码见清单4-5）为了保证保护条件中涉及的变量的内存可见性而引入ReentrantLock锁。使用该锁时需要注意临界区中的代码无论是执行正常还是出现异常，进入临界区前获得的锁实例都应该被释放。否则，就会出现锁泄漏现象：锁对象被某个线程获得，但永远不会被该线程释放，导致其他线程无法获得该锁。为了避免锁泄漏，使用ReentrantLock的临界区代码总是需要按照如下格式来编写：

~~~java
//获得锁
lock.lockInterruptibly();
try {
    //临界区代码
} finally {
    //在finally块中释放锁，保证锁总是会被释放的
    lock.unlock();
}
~~~

### 4.4.2 线程过早被唤醒

### 4.4.3 嵌套监视器锁死

## 4.5 Guarded Suspension模式的可复用实现代码

## 4.6 Java标准库实例

JDK1.5开始提供的阻塞队列类java.util.concurrent.LinkedBlockingQueue就使用了Guarded Suspension模式。该类的take方法用于从队列中取出一个元素。如果take方法被调用时，队列是空的，则当前线程会被阻塞；直到队列不为空时，该方法才返回一个出队列的元素。只不过LinkedBlockingQueue在实现Guarded Suspension模式时，直接使用了java.concurrent.locks.Condition。

## 4.7 相关模式

Guarded Suspension模式时多线程设计模式中的一个基础模式，不仅在应用程序中使用频繁，而且也有其他模式会用到它。

### 4.7.1 Promise模式（第6章）

Promise模式中，客户端代码调用Promise实例的getResult方法时，如果异步任务尚未执行完毕，则getResult方法会使当前线程阻塞，直到异步任务处理完毕或者出现异常。

### 4.7.2 Producer-Consumer模式（第7章）

Producer-Consumer模式中，当消费者线程所需的“产品”暂时没有时，消费者线程会等待直到生产者线程“生产”了新的“产品”。

# 第5章 Two-phase Termination（两阶段终止）模式

## 5.1 Two-phase Termination模式简介

停止线程是一个目标简单而实现却不那么简单的任务。首先，Java没有提供直接的API用于停止线程。此外，停止线程还有一些额外的细节需要考虑，如待停止的线程处于阻塞（如等待锁）或者等待状态（等待其他线程）、尚有未处理完的任务等。

Two-phase Termination模式通过将停止线程这个动作分解为准备阶段和执行阶段这两个阶段，提供了一种通用的用于优雅地停止线程的方法。

## 5.2 Two-phase termination模式的架构

## 5.3 Two-phase Termination模式实战案例解析

## 5.4 Two-phase Termination模式的评价与实现考量

Two-phase Termination模式使得我们可以对各种形式的目标线程进行优雅的停止。如目标线程调用了能够对interrupt方法调用做出响应的阻塞方法、目标线程调用了不能对interrupt方法调用做出响应的阻塞方法、目标线程作为消费者处理其他线程生产的“产品”在其停止前需要处理完现有“产品”等。Two-phase Termination模式实现的线程停止可能出现延迟，即客户端代码调用完ThreadOwner.shutdown后，该线程可能仍在运行。

本章案例展示了一个可复用的Two-phase Termination模式实现代码。读者若要加深对该模式的理解或者自行实现该模式，需要注意以下几个问题。

### 5.4.1 线程停止标志


