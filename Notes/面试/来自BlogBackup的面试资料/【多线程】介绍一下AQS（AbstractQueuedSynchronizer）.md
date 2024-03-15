# 介绍一下 AQS（AbstractQueuedSynchronizer）

# 简答

AQS 是一个用于构建锁和同步器的框架，许多同步器都可以通过 AQS 很容易并且高效地构造出来。不仅 ReentrantLock 和 Semaphore 是基于 AQS 构建的，还包括 CountDownLatch、ReentrantReadWriteLock、SynchronousQueue 和 FutureTask。

**AQS 核心思想**：

- 如果被请求的共享资源空闲，则将当前请求资源的线程设置为有效的工作线程，并且将共享资源设置为锁定状态。
- 如果被请求的共享资源被占用，那么就需要一套线程阻塞等待以及被唤醒时锁分配的机制，这个机制 AQS 是用 CLH 队列锁实现的，即将暂时获取不到锁的线程加入到队列中。

> CLH（Craig,Landin and Hagersten）队列是一个虚拟的双向队列（虚拟的双向队列即不存在队列实例，仅存在结点之间的关联关系）。AQS 是将每条请求共享资源的线程封装成一个 CLH 锁队列的一个结点（Node）来实现锁的分配。

AQS 使用一个 int 成员变量来表示同步状态，通过内置的 FIFO 队列来完成获取资源线程的排队工作。AQS 使用 CAS 对该同步状态进行原子操作实现对其值的修改。

~~~java
private volatile int state;//共享变量，使用volatile修饰保证线程可见性
~~~

状态信息通过 protected 类型的 getState，setState，compareAndSetState 方法进行操作

**AQS 定义两种资源共享方式**：

- **Exclusive**（独占）：只有一个线程能执行，如 `ReentrantLock` 等。又可分为公平锁和非公平锁：
  - *公平锁*：按照线程在队列中的排队顺序，先到者先拿到锁
  - *非公平锁*：当线程要获取锁时，无视队列顺序直接去抢锁，谁抢到就是谁的
- **Share**（共享）：多个线程可同时执行，如 ` CountDownLatch`、`Semaphore`、 `CyclicBarrier`、`ReadWriteLock` 等。

> `ReentrantReadWriteLock` 可以看成是组合式，因为 `ReentrantReadWriteLock` 也就是读写锁允许多个线程同时对某一资源进行读。

不同的自定义同步器争用共享资源的方式也不同。自定义同步器在实现时只需要实现共享资源 state 的获取与释放方式即可，至于具体线程等待队列的维护（如获取资源失败入队/唤醒出队等），AQS 已经在底层实现好了。

**AQS 使用了模板方法模式，自定义同步器时需要重写下面几个 AQS 提供的钩子方法**：

~~~java
//独占方式。尝试获取资源，成功则返回true，失败则返回false。
protected boolean tryAcquire(int);
//独占方式。尝试释放资源，成功则返回true，失败则返回false。
protected boolean tryRelease(int);
//共享方式。尝试获取资源。负数表示失败；0表示成功，但没有剩余可用资源；正数表示成功，且有剩余资源。
protected int tryAcquireShared(int);
//共享方式。尝试释放资源，成功则返回true，失败则返回false。
protected boolean tryReleaseShared(int);
//该线程是否正在独占资源。只有用到condition才需要去实现它。
protected boolean isHeldExclusively();
~~~

除了上面提到的钩子方法之外，AQS 类中的其他方法都是 `final` ，所以无法被其他类重写。

# 详解

## Synchronizer 剖析

在 ReentrantLock 和 Semaphore 这两个接口之间存在许多共同点。这两个类都可以用做一个“阀门”，即每次只允许一定量的线程通过，并当线程到达阀门时，可以通过（在调用 lock 或 acquire 时成功返回），也可以等待（在调用 lock 或 acquire 时阻塞），还可以取消（在调用 tryLock 或 tryAcquire 时返回“假”，表示在指定的时间内锁是不可用的或者无法获得许可）。而且，这两个接口都支持可中断的、不可中断的以及限时的获取操作，并且也都支持等待线程执行公平或非公平的队列操作。

列出了这种共性后，你或许会认为 Semaphore 是基于 ReentrantLock 实现的，或者认为 ReentrantLock 实际上是带有一个许可的 Semaphore。这些实现方式都是可行的，一个很常见的练习就是，证明可以通过锁来实现计数信号量（如程序清单中的 SemaphoreOnLock 所示），以及可以通过计数信号量来实现锁。

~~~java
// 并非 java.util.concurrent.Semaphore的真实实现方式
@ThreadSafe
public class SemaphoreOnLock {
    private final Lock lock = new ReentrantLock();
    // 条件谓词：permitsAvailable(permits > 0)
    private final Condition permitsAvailable = lock.newCondition();
    @GuardedBy("lock")
    private int permits;
    
    SemaphoreOnLock(int initialPermits) {
        lock.lock();
        try {
            permits = initialPermits;
        } finally {
            lock.unlock();
        }
    }
    
    // 阻塞并直到：permitsAvailable
    public void acquire() throws InterruptedException {
        lock.lock();
        try {
            while(permits <= 0){
                permitsAvailable.await();
            }
            --permits;
        } finally {
            lock.unlock();
        }
    }
    
    public void release() {
        lock.lock();
        try {
            ++permits;
            permitsAvailable.signal();
        } finally {
            lock.unlock();
        }
    }
}
~~~

事实上，它们在实现时都使用了一个共同的基类，即 AbstractQueuedSynchronizer（AQS），这个类也是其他许多同步类的基类。AQS 是一个用于构建锁和同步器的框架，许多同步器都可以通过 AQS 很容易并且高效地构造出来。不仅 ReentrantLock 和 Semaphore 是基于 AQS 构建的，还包括 CountDownLatch、ReentrantReadWriteLock、SynchronousQueue 和 FutureTask。

AQS 解决了在实现同步器时涉及的大量细节问题，例如等待线程采用 FIFO 队列操作顺序。在不同的同步器中还可以定义一些灵活的标准来判断某个线程是应该通过还是需要等待。

基于 AQS 来构建同步器能带来许多好处。它不仅能极大地减少实现工作，而且也不必处理在多个位置上发生的竞争问题（这是在没有使用 AQS 来构建同步器时的情况）。在 SemaphoreOnLock 中，获取许可的操作可能在两个时刻阻塞——当锁保护信号量状态时，以及当许可不可用时。在基于 AQS 构建的同步器中，只可能在一个时刻发生阻塞，从而降低上下文切换的开销，并提高吞吐量。在设计 AQS 时充分考虑了可伸缩性，因此 java.util.concurrent 中所有基于 AQS 构建的同步器都能获得这个优势。

## AbstractQueuedSynchronizer

大多数开发者都不会直接使用 AQS，标准同步器类的集合能够满足绝大多数情况的需求。但如果能了解标准同步器类的实现方式，那么对于理解它们的工作原理是非常有帮助的。

在基于 AQS 构建的同步器类中，最基本的操作包括各种形式的**获取操作**和**释放操作**。

- 获取操作是一种依赖状态的操作，并且通常会阻塞。当使用锁或信号量时，“获取”操作的含义就很直观，即获取的是锁或者许可，并且调用者可能会一直等到直到同步器类处于可被获取的状态。在使用 CountDownLatch 时，“获取”操作意味着“等待并直到闭锁达到结束状态”，而使用 FutureTask 时，则意味着“等待并直到任务已经完成”。
- “释放”并不是一个可阻塞的操作，当执行“释放”操作时，所有在请求时被阻塞的线程都会开始执行。

如果一个类想成为状态依赖的类，那么它必须拥有一些状态。AQS 负责管理同步器类中的状态，它管理了一个**整数状态信息**，可以通过 getState，setState 以及 compareAndSetState 等 protected 类型方法来进行操作。

这个整数可以用于表示任意状态。例如，ReentrantLock 用它来表示所有者线程已经重复获取该锁的次数，Semaphore 用它来表示剩余的许可数量，FutureTask 用它来表示任务的状态（尚未开始、正在运行、已完成以及已取消）。

在同步器类中还可以自行管理一些额外的状态变量，例如，ReentrantLock 保存了锁的当前所有者的信息，这样就能区分某个获取操作是重入的还是竞争的。

下面程序清单给出了 AQS 中的获取操作与释放操作的形式。根据同步器的不同，获取操作可以是一种独占操作（例如 ReentrantLock），也可以是一个非独占操作（例如 Semaphore 和 CountDownLatch）。一个获取操作包括两部分。首先，同步器判断当前状态是否允许获得操作，如果是，则允许线程执行，否则获取操作将阻塞或失败。这种判断是由同步器的语义决定的。例如，对于锁来说，如果它没有被某个线程持有，那么就能被成功地获取，而对于闭锁来说，如果它处于结束状态，那么也能被成功地获取。

~~~java
boolean acquire() throws InterruptedException {
    while(当前状态不允许获取操作) {
        if(需要阻塞获取请求) {
            如果当前线程不在队列中，则将其插入队列;
            阻塞当前线程;
        } else {
            返回失败;
        }
    }
    可能更新同步器的状态;
    如果线程位于队列中，则将其移出队列;
    返回成功;
}

void release() {
    更新同步器的状态;
    if(新的状态允许某个被阻塞的线程获取成功) {
        解除队列中一个或多个线程的阻塞状态
    }
}
~~~

其次，就是更新同步器的状态，获取同步器的某个线程可能会对其他线程能否也获取该同步器造成影响。例如，当获取一个锁后，锁的状态将从“未被持有”变成“已被持有”，而从 Semaphore 中获取一个许可后，将把剩余许可的数量减 1。然而，当一个线程获取闭锁时，并不会影响其他线程能否获取它，因此获取闭锁的操作不会改变闭锁的状态。

如果某个同步器支持**独占的获取**操作，那么需要实现一些保护方法，包括 tryAcquire、tryRelease 和 isHeldExclusively 等，而对于支持**共享获取**的同步器，则应该实现 tryAcquireShared 和 tryReleaseShared 等方法。

AQS 中的 acquire、acquireShared、release 和 releaseShared 等方法都将调用这些方法在子类中带有前缀 try 的版本来判断某个操作是否能执行。

在同步器的子类中，可以根据其获取操作和释放操作的语义，使用 getState、setState 以及 compareAndSetState 来检查和更新状态，并通过返回的状态值来告知基类“获取”或“释放”同步器的操作是否成功。例如，如果 tryAcquireShared 返回一个负值，那么表示获取操作失败，返回零值表示同步器通过独占方式被获取，返回正值则表示同步器通过非独占方式被获取。对于 tryRelease 和 tryReleaseShared 方法来说，如果释放操作使得所有在获取同步器时被阻塞的线程恢复执行，那么这两个方法应该返回 true。

为了使支持条件队列的锁（例如 ReentrantLock）实现起来更简单，AQS 还提供了一些机制来构造与同步器相关联的条件变量。

### 一个简单的闭锁

下面程序清单中的 OneShotLatch 是一个使用 AQS 实现的二元闭锁。它包含两个共有方法： await 和 signal，分别对应获取操作和释放操作。起初，闭锁是关闭的，任何调用 await 的线程都将阻塞并直到闭锁被打开。当通过调用 signal 打开闭锁时，所有等待中的线程都将被释放，并且随后到达闭锁的线程也被允许执行。

~~~java
@ThreadSafe
public class oneShotLatch {
    private final Sync sync = new Sync();
    
    public void signal() {
        sync.releaseShared(0);
    }
    
    public void await() throws InterruptedException {
        sync.acquireSharedInterruptibly(0);
    }
    
    private class Sync extends AbstractQueuedSynchronizer {
        protected int tryAcquireShared(int ignored) {
            // 如果闭锁是开的（state == 1），那么这个操作将成功，否则将失败
            return (getState() == 1) ? 1: -1;
        }
        
        protected boolean tryReleaseShared(int ignored) {
            setState(1); // 现在打开闭锁
            return true; // 现在其他的线程可以获取该闭锁
        }
    }
}
~~~

在 OneShotLatch 中，AQS 状态用来表示闭锁状态——关闭（0）或者打开（1）。

- await 方法调用 AQS 的 acquireSharedInterruptibly，然后接着调用 OneShotLatch 中的 tryAcquireShared 方法。
  在 tryAcquireShared 的实现中必须返回一个值来表示该获取操作能否执行。如果之前已经打开了闭锁，那么 tryAcquireShared 将返回成功并允许线程通过，否则就会返回一个表示获取操作失败的值。
  acquireSharedInterruptibly 方法在处理失败的方式，是把这个线程放入等待队列中。
- 类似地，signal 将调用 releaseShared，接下来又会调用 tryReleaseShared。
  在 tryReleaseShared 中将无条件地把闭锁的状态设置为打开，（通过返回值）表示该同步器处于完全被释放的状态。因为 AQS 让所有等待中的线程都尝试重新请求该同步器，并且由于 tryAcquireShared 将返回成功，因此现在的请求操作将成功。

OneShotLatch 是一个功能全面的、可用的、性能较好的同步器，并且仅使用了大约 20 多行代码就实现了。当然，它缺少了一些有用的特性，例如限时的请求操作以及检查闭锁的状态，但这些功能实现起来同样很容易，因为 AQS 提供了限时版本的获取方法，以及一些在常见检查中使用的辅助方法。

OneShotLatch 也可以通过扩展 AQS 来实现，而不是将一些功能委托给 AQS，但这种做法并不合理，原因有很多。这样做将破坏 OneShotLatch 接口（只有两个方法）的简洁性，并且虽然 AQS 的公共方法不允许调用者破坏闭锁的状态，但调用者仍可以很容易地误用它们。java.util.concurrent 中的所有同步器类都没有直接扩展 AQS，而是都将它们的相应功能委托给私有的 AQS 子类来实现。

## java.util.concurrent 同步器类中的 AQS

java.util.concurrent 中的许多可阻塞类，例如 ReentrantLock、Semaphore、ReentrantReadWriteLock、CountDownLatch、SynchronousQueue 和 FutureTask等，都是基于 AQS 构建的。我们快速地浏览一下每个类是如何使用 AQS 的，不需要过于地深入了解细节（在 JDK 的下载包中包含了源代码）。

### ReentrantLock

ReentrantLock 只支持独占方式的获取操作，因此它实现了 tryAcquire、tryRelease 和 isHeldExclusively，下面程序清单给出了非公平版本的 tryAcquire。

ReentrantLock 将同步状态用于保存锁获取操作的次数，并且还维护一个 owner 变量来保存当前所有者线程的标识符，只有在当前线程刚刚获取到锁，或者正要释放锁的时候，才会修改这个变量。在 tryRelease 中检查 owner 域，从而确保当前线程在执行 unlock 操作之前已经获取了锁：在 tryAcquire 中将使用这个域来区分获取操作是重入的还是竞争的。

~~~java
protected boolean tryAcquire(int ignored) {
    final Thread current = Thread.currentThread();
    int c = getState();
    if (c == 0) {
        if (compareAndSetState(0, 1)) {
            owner = current;
            return true;
        }
    } else if (current == owner) {
        setState(c + 1);
        return true;
    }
    return false;
}
~~~

当一个线程尝试获取锁时，tryAcquire 将首先检查锁的状态。如果锁未被持有，那么它将尝试更新锁的状态以表示锁已经被持有。由于状态可能在检查后被立即修改，因此 tryAcquire 使用compareAndSetState 来原子地更新状态，表示这个锁已经被占有，并确保状态在最后一次检查以后就没有被修改过（CAS）。如果锁状态表明它已经被持有，并且如果当前线程是锁的拥有者，那么获取计数会递增，如果当前线程不是锁的拥有者，那么获取操作将失败。

ReentrantLock 还利用了 AQS 对多个条件变量和多个等待线程集的内置支持。Lock.newCondition 将返回一个新的 ConditionObject 实例，这是 AQS 的一个内部类。

### Semaphore 与 CountDownLatch

Semaphore将AQS的同步状态用于保存当前可用许可的数量。tryAcquireShared 方法（请参考下面的程序清单）首先计算剩余许可的数量，如果没有足够的许可，那么会返回一个值表示获取操作失败。如果还有剩余的许可，那么 tryAcquireShared 会通过 compareAndSetState 以原子方式来降低许可的计数。如果这个操作成功（这意味着许可的计数自从上一次读取后就没有被修改过），那么将返回一个值表示获取操作成功。在返回值中还包含了表示其他共享获取操作能否成功的信息，如果成功，那么其他等待的线程同样会解除阻塞。

~~~java
protected int tryAcquireShared(int acquires) {
    while (true) {
        int available = getState();
        int remaining = available - acquires;
        if (remaining < 0 || compareAndSetState(avaliable, remaining))
            return remaining;
    }
}

protected boolean tryReleaseShared(int releases) {
    while (true) {
        int p = getState();
        if (compareAndSetState(p, p + releases))
            return true;
    }
}
~~~

当没有足够的许可，或者当 tryAcquireShared 可以通过原子方式来更新许可的计数以响应获取操作时，while 循环将终止。虽然对 compareAndSetState 的调用可能由于与另一个线程发生竞争而失败，并使其重新尝试，但在经过了一定次数的重试操作以后，在这两个结束条件中有一个会变为真。同样，tryReleaseShared 将增加许可计数，这可能会解除等待中线程的阻塞状态，并且不断地重试直到更新操作成功。tryReleaseShared 的返回值表示在这次释放操作中解除了其他线程的阻塞。

CountDownLatch 使用 AQS 的方式与 Semaphore 很相似：在同步状态中保存的是当前的计数值。countDown 方法调用 release，从而导致计数值递减，并且当计数值为零时，解除所有等待线程的阻塞。await 调用 acquire，当计数器为零时，acquire 将立即返回，否则将阻塞。

### FutureTask

初看上去，FutureTask 甚至不像一个同步器，但 Future.get 的语义非常类似于闭锁的语义——如果发生了某个事件（由 FutureTask 表示的任务执行完成或被取消），那么线程就可以恢复执行，否则这些线程将停留在队列中并直到该事件发生。

在FutureTask 中，AQS 同步状态被用来保存任务的状态，例如，正在运行、已完成或已取消。FutureTask 还维护一些额外的状态变量，用来保存计算结果或者抛出的异常。此外，它还维护了一个引用，指向正在执行计算任务的线程（如果它当前处于运行状态），因此如果任务取消，该线程就会中断。

### ReentrantReadWriteLock

ReadWriteLock 接口表示存在两个锁：一个读取锁和一个写入锁，但在基于 AQS 实现的ReentrantReadWriteLock 中，单个 AQS 子类将同时管理读取加锁和写入加锁。ReentrantReadWriteLock 使用了一个 16 位的状态来表示写入锁的计数，并且使用了另一个 16 位的状态来表示读取锁的计数。在读取锁上的操作将使用共享的获取方法和释放方法，在写入锁的操作将使用独占的获取方法与释放方法。

AQS 在内部维护一个等待线程队列，其中记录了某个线程请求的是独占访问还是共享访问。在 ReentrantReadWriteLock 中，当锁可用时，如果位于队列头部的线程执行写入操作，那么线程会得到这个锁，如果位于队列头部的线程执行读取访问，那么队列中在第一个写入线程之前的所有线程都将获得这个锁。

# 参考文档

- 《Java 并发编程实战》14.4 Synchronizer 剖析、14.5 AbstractQueuedSynchronizer、14.6 java.util.concurrent 同步器类中的 AQS
- JavaGuide AQS：https://javaguide.cn/java/concurrent/java-concurrent-questions-02.html#_6-2-aqs-%E5%8E%9F%E7%90%86%E5%88%86%E6%9E%90
