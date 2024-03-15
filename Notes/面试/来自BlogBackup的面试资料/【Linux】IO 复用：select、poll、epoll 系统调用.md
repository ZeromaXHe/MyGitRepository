# 等效面试题

谈一谈 I/O 多路复用机制

select、poll 与 epoll 的区别

# 简答

最传统的多进程并发模型是每进来一个新的 I/O 流会分配一个新的进程管理。

使用 I/O 多路复用的话，单个线程可以通过记录跟踪每个 I/O 流（socket）的状态，来同时管理多个 I/O 流 。I/O 复用使得程序能同时监听多个文件描述符，这对提高程序的性能至关重要。

| 系统调用                               | select                                                       | poll                                                         | epoll                                                        |
| -------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 事件集合                               | 用户通过 3 个参数分别传入感兴趣的可读、可写及异常等事件，内核通过对这些参数的在线修改来反馈其中的就绪事件。这使得用户每次调用 select 都要重置这 3 个参数 | 统一处理所有事件类型，因此只需要一个事件集参数。用户通过 pollfd.events 传入感兴趣的事件，内核通过修改 pollfd.revents 反馈其中就绪的事件 | 内核通过一个事件表直接管理用户感兴趣的所有事件。因此每次调用 epoll_wait 时，无须反复传入用户感兴趣的事件。epoll_wait 系统调用的参数 events 仅用来反馈就绪的事件 |
| 应用程序索引就绪文件描述符的时间复杂度 | O(n)                                                         | O(n)                                                         | O(1)                                                         |
| 最大支持文件描述符数                   | 一般有最大值限制（1024）                                     | 65535                                                        | 65535                                                        |
| 工作模式                               | LT                                                           | LT                                                           | 支持 ET 高效模式                                             |
| 内核实现和工作效率                     | 采用轮询方式来检测就绪事件，算法时间复杂度为 O(n)            | 采用轮询方式来检测就绪事件，算法时间复杂度为 O(n)            | 采用回调方式来检测就绪事件，算法时间复杂度为 O(1)            |

# 详解

最传统的多进程并发模型是每进来一个新的 I/O 流会分配一个新的进程管理。

使用 I/O 多路复用的话，单个线程可以通过记录跟踪每个 I/O 流（socket）的状态，来同时管理多个 I/O 流 。

I/O 复用使得程序能同时监听多个文件描述符，这对提高程序的性能至关重要。通常，网络程序在下列情况下需要使用 I/O 复用技术：

- 客户端程序要同时处理多个 socket。比如非阻塞 connect 技术。
- 客户端程序要同时处理用户输入和网络连接。比如聊天室程序。
- TCP 服务器要同时处理监听 socket 和连接 socket。这是 I/O 复用使用最多的场合。
- 服务器要同时处理 TCP 请求和 UDP 请求。比如回射服务器。
- 服务器要同时监听多个端口，或者处理多种服务。比如 xinetd 服务器。

需要指出的是，I/O 复用虽然能同时监听多个文件描述符，但它本身是阻塞的。并且当多个文件描述符同时就绪时，如果不采取额外的措施，程序就只能按顺序依次处理其中的每一个文件描述符，这使得服务器程序看起来像是串行工作的。如果要实现并发，只能使用多进程或多线程等编程手段。

Linux 下实现 I/O 复用的系统调用主要有 select、poll 和 epoll。

## 1 select 系统调用

select 系统调用的用途是：在一段指定时间内，监听用户感兴趣的文件描述符上的可读、可写和异常等事件。

### 1.1 select API

select 系统调用的原型如下：

~~~c
#include <sys/select.h>
int select(int nfds, fd_set* readfds, fd_set* writefds,
           fd_set* exceptfds, struct timeval* timeout);
~~~

1. nfds 参数指定被监听的文件描述符的总数。它通常被设置为 select 监听的所有文件描述符中的最大值加 1，因为文件描述符是从 0 开始计数的。

2. readfds、writefds 和 exceptfds 参数分别指向可读、可写和异常等事件对应的文件描述符集合。应用程序调用 select 函数时，通过这 3 个参数传入自己感兴趣的文件描述符。 select 调用返回时，内核将修改它们来通知应用程序哪些文件描述符已经就绪。
   这三个参数是 fd_set 结构指针类型。fd_set 结构体的定义如下：

   ~~~c
   #include <typesizes.h>
   #define __FD_SETSIZE 1024
   
   #include <sys/select.h>
   #define DF_SETSIZE __FD_SETSIZE
   typedef long int __df_mask;
   #undef __NFDBITS
   #define __NFDBITS ( 8 * (int) sizeof (__fd_mask))
   typedef struct
   {
   #ifdef __USE_XOPEN
       __fd_mask fds_bits[__FD_SETSIZE / __NFDBITS];
   #define __FDS_BITS(set) ((set)->fds_bits)
   #else
       __fd_mask __fds_bits[__FD_SETSIZE / __NFDBITS];
   #define __FDS_BITS(set) ((set)->__fds_bits)
   #endif
   } fd_set;
   ~~~

   由以上定义可见，fd_set 结构体仅包含一个整形数组，该数组的每个元素的每一位（bit）标记一个文件描述符。fd_set 能容纳的文件描述符数量由 FD_SETSIZE 指定，这就限制了 select 能同时处理的文件描述符的总量。

   由于位操作过于烦琐，我们应该使用下面的一系列宏来访问 fd_set 结构体中的位：

   ~~~c
   #include <sys/select.h>
   FD_ZERO(fd_set *fdset);				 /* 清除 fdset 的所有位 */
   FD_SET(int fd, fd_set *fdset);		 /* 设置 fdset 的位 fd */
   FD_CLR(int fd, fd_set *fdset);		 /* 清除 fdset 的位 fd */
   int FD_ISSET(int fd, fd_set *fdset); /* 测试 fdset 的位 fd 是否被设置 */
   ~~~

3. timeout 参数用来设置 select 函数的超时时间。它是一个 timeval 结构类型的指针，采用指针参数是因为内核将修改它以告诉应用程序 select 等待了多久。不过我们不能完全信任 select 调用返回后的 timeout 值，比如调用失败时 timeout 值是不确定的。timeval 结构体的定义如下：

   ~~~c
   struct timeval
   {
       long tv_sec;  /* 秒数 */
       long tv_usec; /* 微秒数 */
   };
   ~~~

   由以上定义可见，select 给我们提供了一个微妙级的定时方式。如果给 timeout 变量的 tv_sec 成员和 tv_usec 成员都传递 0，则 select 将立即返回。如果给 timeout 传递 NULL，则 select 将一直阻塞，直到某个文件描述符就绪。

   select 成功时返回就绪（可读、可写和异常）文件描述符的总数。如果在超时时间内没有任何文件描述符就绪，select 将返回 0。select 失败时返回 -1 并设置 errno。如果在 select 等待期间，程序接收到信号，则 select 立即返回 -1，并设置 errno 为 EINTR。

### 1.2 文件描述符就绪条件

哪些情况下文件描述符可以被认为是可读、可写或者出现异常，对于 select 的使用非常关键。在网络编程中，下列情况下 socket 可读：

- socket 内核接收缓存区中的字节数大于或等于其低水位标记 `SO_RCVLOWAT`。此时我们可以无阻塞地读该 socket，并且读操作返回的字节数大于 0。
- socket 通信的对方关闭连接。此时对该 socket 的读操作将返回 0。
- 监听 socket 上有新的连接请求。
- socket 上有未处理的错误。此时我们可以使用 getsocketopt 来读取和清除该错误。

下列情况下 socket 可写：

- socket 内核发送缓存区中的可用字节数大于或等于其低水位 `SO_SNDLOWAT`。此时我们可以无阻塞地写该 socket，并且写操作返回的字节数大于 0。
- socket 的写操作被关闭。对写操作被关闭的 socket 执行写操作将触发一个 SIGPIPE 信号。
- socket 使用非阻塞 connect 连接成功或者失败（超时）之后。
- socket 上有未处理的错误。此时我们可以使用 getsocketopt 来读取和清除该错误。

网络程序中，select 能处理的异常情况只有一种：socket 上接收到带外数据。

## 2 poll 系统调用

poll 系统调用和 select 类似，也是在指定时间内轮询一定数量的文件描述符，以测试其中是否有就绪者。poll 的原型如下：

~~~c
#include <poll.c>
int poll(struct pollfd* fds, nfds_t nfds, int timeout);
~~~

1. fd 参数是一个 pollfd 结构类型的数组，它指定所有我们感兴趣的文件描述符上发生的可读、可写和异常等事件。pollfd 结构体的定义如下：

   ~~~c
   struct pollfd
   {
       int fd;			/* 文件描述符 */
       short events;	/* 注册的事件 */
       short revents;	/* 实际发生的事件，由内核填充 */
   };
   ~~~

   其中，fd 成员指定文件描述符；events 成员告诉 poll 监听 fd 上的哪些事件，它是一系列事件的按位或；revents 成员则由内核修改，以通知应用程序 fd 上实际发生了哪些事件。poll 支持的事件类型如下表所示。

   | 事件       | 描述                                                         | 是否可作为输入 | 是否可作为输出 |
   | ---------- | ------------------------------------------------------------ | -------------- | -------------- |
   | POLLIN     | 数据（包括普通数据和优先数据）可读                           | 是             | 是             |
   | POLLRDNORM | 普通数据可读                                                 | 是             | 是             |
   | POLLRDBAND | 优先级带数据可读（Linux 不支持）                             | 是             | 是             |
   | POLLPRI    | 高优先级数据可读，比如 TCP 带外数据                          | 是             | 是             |
   | POLLOUT    | 数据（包括普通数据和优先数据）可写                           | 是             | 是             |
   | POLLWRNORM | 普通数据可写                                                 | 是             | 是             |
   | POLLWRBAND | 优先级带数据可写                                             | 是             | 是             |
   | POLLRDHUP  | TCP 连接被对方关闭，或者对方关闭了写操作。它由 GNU 引入      | 是             | 是             |
   | POLLERR    | 错误                                                         | 否             | 是             |
   | POLLHUP    | 挂起。比如管道的写端被关闭后，读端描述符上将收到 POLLHUP 事件 | 否             | 是             |
   | POLLNVAL   | 文件描述符没有打开                                           | 否             | 是             |

   表中，POLLRDNORM、POLLRDBAND、POLLWRNORM、POLLWRBAND 由 XOPEN 规范定义。它们实际上是将 POLLIN 事件和 POLLOUT 事件分得更细致，以区别对待普通数据和优先数据。但 Linux 并不完全支持它们。

   通常，应用程序需要根据 recv 调用的返回值来区分 socket 上接收到的是有效数据还是对方关闭连接的请求，并做相应的处理。不过，自 Linux 内核 2.6.17 开始，GNU 为 poll 系统调用增加了一个 POLLRDHUP 事件，它在 socket 上接收到对方关闭连接的请求之后触发。这为我们区分上述两种情况提供了一种更简单的方式。但使用 POLLRDHUP 事件时，我们需要在代码最开始处定义 `_GNU_SOURCE`。

2. nfds 参数指定被监听事件集合 fds 的大小。其类型 nfds_t 的定义如下：

   ~~~c
   typedef unsigned long int nfds_t;
   ~~~

3. timeout 参数指定 poll 的超时值，单位是毫秒。当 timeout 为 -1 时，poll 调用将永远阻塞，直到某个事件发生；当 timeout 为 0 时，poll 调用将立即返回。

poll 系统调用的返回值的含义与 select 相同。

## 3 epoll 系列系统调用

### 3.1 内核事件表

epoll 是 Linux 特有的 I/O 复用函数。它在实现和使用上与 select、poll 有很大差异。首先，epoll 使用一组函数来完成任务，而不是单个函数。其次，epoll 把用户关心的文件描述符上的事件放在内核里的一个事件表中，从而无须像 select 和 poll 那样每次调用都要重复传入文件描述符集或事件集。但 epoll 需要使用一个额外的文件描述符，来唯一标识内核中的这个事件表。这个文件描述符使用如下 epoll_create 函数创建：

~~~c
#include <sys/epoll.h>
int epoll_create(int size)
~~~

size 参数现在并不起作用，只是给内核一个提示，告诉它事件表需要多大。该函数返回的文件描述符将用作其他所有 epoll 系统调用的第一个参数，以指定要访问的内核事件表。

下面的函数用来操作 epoll 的内核事件表：

~~~c
#include <sys/epoll.h>
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
~~~

fd 参数是要操作的文件描述符，op 参数则指定操作类型。操作类型有如下 3 种：

- EPOLL_CTL_ADD，往事件表中注册 fd 上的事件。
- EPOLL_CTL_MOD，修改 fd 上的注册事件。
- EPOLL_CTL_DEL，删除 fd 上的注册事件。

event 参数指定事件，它是 epoll_event 结构指针类型。epoll_event 的定义如下：

~~~c
struct epoll_event
{
    __uint32_t events; /* epoll 事件 */
    epoll_data_t data; /* 用户数据 */
};
~~~

其中 events 成员描述事件类型。epoll 支持的事件类型和 poll 基本相同。表示 poll 事件类型的宏是在 poll 对应的宏前加上 “E”，比如 epoll 的数据可读事件是 EPOLLIN。但 epoll 有两个额外的事件类型——EPOLLET 和 EPOLLONESHOT。它们对于 epoll 的高效运作非常关键。

data 成员用于存储用户数据，其类型 epoll_data_t 的定义如下：

~~~c
typedef union epoll_data
{
    void* ptr;
    int fd;
    uint32_t u32;
    uint64_t u64;
} epoll_data_t;
~~~

epoll_data_t 是一个联合体，其 4 个成员中使用最多的是 fd，它指定事件所从属的目标文件描述符。ptr 成员可用来指定与 fd 相关的用户数据。但由于 epoll_data_t 是一个联合体，我们不能同时使用其 ptr 成员和 fd 成员，因此，如果要将文件描述符和用户数据关联起来，以实现快速的数据访问，只能使用其他手段，比如放弃使用 epoll_data_t 的 fd 成员，而在 ptr 指向的用户数据中包含 fd。

epoll_ctl 成功时返回 0，失败则返回 -1 并设置 errno。

### 3.2 epoll_wait 函数

epoll 系列系统调用的主要接口是 epoll_wait 函数。它在一段超时时间内等待一组文件描述符上的事件，其原型如下：

~~~c
#include <sys/epoll.h>
int epoll_wait(int epfd, struct epoll_event* events,
               int maxevents, int timeout);
~~~

该函数成功时返回就绪的文件描述符的个数，失败时返回 -1 并设置 errno。

关于该函数的参数，我们从后往前讨论。timeout 参数的含义与 poll 接口的 timeout 参数相同。maxevents 参数指定最多监听多少个事件，它必须大于 0。

epoll_wait 函数如果检测到事件，就将所有就绪的事件从内核事件表（由 epfd 参数指定）中复制到它的第二个参数 events 指向的数组中。这个数组只用于输出 epoll_wait 检测到的就绪事件，而不像 select 和 poll 数组参数那样既用于传入用户注册的事件，又用于输出内核检测到的就绪事件。这就极大地提高了应用程序索引就绪文件描述符的效率。

~~~c
/* 如何索引 poll 返回的就绪文件描述符 */
int ret = poll(fds, MAX_EVENT_NUMBER, -1);
/* 必须遍历所有已注册文件描述符并找到其中的就绪者（当然，可以利用 ret 来稍微优化） */
for (int i = 0; i < MAX_EVENT_NUMBER; ++i)
{
    if (fds[i].revents & POLLIN) /* 判断第 i 个文件描述符是否就绪 */
    {
        int sockfd = fds[i].fd;
        /* 处理 sockfd */
	}
}
/* 如何索引 epoll 返回的就绪文件描述符 */
int ret = epoll_wait(epollfd, events, MAX_EVENT_NUMBER, -1);
/* 仅遍历就绪的 ret 个文件描述符 */
for (int i = 0; i < ret; i++)
{
    int sockfd = events[i].data.fd;
    /* sockfd 肯定就绪，直接处理 */
}
~~~

### 3.3 LT 和 ET 模式

epoll 对文件描述符的操作有两种模式：LT（Level Trigger，电平触发）模式和 ET（Edge Trigger，边沿触发）模式。LT 模式是默认的工作模式，这种模式下 epoll 相当于一个效率较高的 poll。当往 epoll 内核事件表中注册一个文件描述符上的 EPOLLET 事件时，epoll 将以 ET 模式来操作该文件描述符。ET 模式是 epoll 的高效工作模式。

对于采用 LT 工作模式的文件描述符，当 epoll_wait 检测到其上有事件发生并将此事件通知应用程序后，应用程序可以不立即处理该事件。这样，当应用程序下一次调用 epoll_wait 时，epoll_wait 还会再次向应用程序通告此事件，直到该事件被处理。

而对于采用 ET 工作模式的文件描述符，当 epoll_wait 检测到其上有事件发生并将此事件通知应用程序后，应用程序必须立即处理该事件，因为后续的 epoll_wait 调用将不再向应用程序通知这一事件。可见，ET 模式在很大程度上降低了同一个 epoll 事件被重复触发的次数，因此效率要比 LT 模式高。

> **注意**
>
> 每个使用 ET 模式的文件描述符都应该是非阻塞的。如果文件描述符是阻塞的，那么读或写操作将会因为没有后续的事件而一直处于阻塞状态（饥渴状态）。

### 3.4 EPOLLONESHOT 事件

即使我们使用 ET 模式，一个 socket 上的某个事件还是可能被触发多次。这在并发程序中就引起一个问题。比如一个线程（或进程，下同）在读取完某个 socket 上的数据后开始处理这些数据，而在数据的处理过程中该 socket 上又有新数据可读（EPOLLIN 再次被触发），此时另外一个线程被唤醒来读取这些新的数据。于是就出现了两个线程同时操作一个 socket 的局面。这当然不是我们期望的。我们期望的是一个 socket 连接在任一时刻都只被一个线程处理。这一点可以使用 epoll 的 EPOLLONESHOT 事件实现。

对于注册了 EPOLLONESHOT 事件的文件描述符，操作系统最多触发其上注册的一个可读、可写或者异常事件，且只触发一次，除非我们使用 epoll_ctl 函数重置该文件描述符上注册的 EPOLLONESHOT 事件。这样，当一个线程在处理某个 socket 时，其他线程是不可能有机会操作该 socket 的。

但反过来思考，注册了 EPOLLONESHOT 事件的 socket 一旦被某个线程处理完毕，该线程就应该立即重置这个 socket 上的 EPOLLONESHOT 事件，以确保这个 socket 下一次可读时，其 EPOLLIN 事件能被触发，进而让其他工作线程有机会继续处理这个 socket。

由此看来，尽管一个 socket 在不同时间可能被不同的线程处理，但同一时刻肯定只有一个线程在为它服务。这就保证了连接的完整性，从而避免了很多可能的竞态条件。

## 4 三组 I/O 复用函数的比较

前面我们讨论了 select、poll 和 epoll 三组 I/O 复用系统调用，这 3 组系统调用都能同时监听多个文件描述符。它们将等待由 timeout 参数指定的超时时间，直到一个或者多个文件描述符上有事件发生时返回，返回值是就绪的文件描述符的数量。返回 0 表示没有事件发生。

现在我们从事件集、最大支持文件描述符数、工作模式和具体实现等四个方面进一步比较它们的异同，以明确在实际应用中应该选择使用哪个（或哪些）。

**事件集**：

这 3 组函数都通过某种结构体变量来告诉内核监听哪些文件描述符上的哪些事件，并使用该结构体类型的参数来获取内核处理的结果。

- select 的参数类型 fd_set 没有将文件描述符和事件绑定，它仅仅是一个文件描述符集合，因此 select 需要提供 3 个这种类型的参数来分别传入和输出可读、可写及异常等事件。这一方面使得 select 不能处理更多类型的事件，另一方面由于内核对 fd_set 集合的在线修改，应用程序下次调用 select 前不得不重置这 3 个 fd_set 集合。
- poll 的参数类型 pollfd 则多少“聪明”一些。它把文件描述符和事件都定义其中，任何事件都被统一处理，从而使得编程接口简洁得多。并且内核每次修改的是 pollfd 结构体的 revents 成员，而 events 成员保持不变，因此下次调用 poll 时应用程序无需重置 pollfd 类型的事件集参数。由于每次 select 和 poll 调用都返回整个用户注册的事件集合（其中包括就绪的和未就绪的），所以应用程序索引就绪文件描述符的时间复杂度为 O(n)。
- epoll 则采用与 select 和 poll 完全不同的方式来管理用户注册的事件。它在内核中维护一个事件表，并提供了一个独立的系统调用 epoll_ctl 来控制往其中添加、删除、修改事件。这样，每次 epoll_wait 调用都直接从该内核事件表中取得用户注册的事件，而无须反复从用户空间读入这些事件。epoll_wait 系统调用的 events 参数仅用来返回就绪的事件，这使得应用程序索引就绪文件描述符的时间复杂度达到 O(1)。

**最大支持文件描述符数**：

- poll 和 epoll_wait 分别用 nfds 和 maxevents 参数指定最多监听多少个文件描述符和事件。这两个数值都能达到系统允许打开的最大文件描述符数目，即 65535 （cat/proc/sys/fs/file-max）。
- 而 select 允许监听的最大文件描述符数量通常有限制。虽然用户可以修改这个限制，但这可能导致不可预期的后果。

**工作模式**：

- select 和 poll 都只能工作在相对低效的 LT 模式
- 而 epoll 则可以工作在 ET 高效模式。并且 epoll 还支持 EPOLLONESHOT 事件。该事件能进一步减少可读、可写和异常等事件被触发的次数。

从**实现原理**上来说：

- select 和 poll 采用的都是轮询的方式，即每次调用都要扫描整个注册文件描述符集合，并将其中就绪的文件描述符返回给用户程序，因此它们检测就绪事件的算法的事件复杂度是 O(n)。
- epoll_wait 则不同，它采用的是回调的方式。内核检测到就绪的文件描述符时，将触发回调函数，回调函数就将该文件描述符上对应的事件插入内核就绪事件队列。内核最后在适当的时机将该就绪事件队列中的内容拷贝到用户空间。因此 epoll_wait 无须轮询整个文件描述符集合来检测哪些事件已经就绪，其算法时间复杂度是 O(1)。但是，当活动连接比较多的时候，epoll_wait 的效率未必比 select 和 poll 高，因为此时回调函数被触发得过于频繁。所以 epoll_wait 适用于连接数量多，但活动连接较少的情况。

| 系统调用                               | select                                                       | poll                                                         | epoll                                                        |
| -------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 事件集合                               | 用户通过 3 个参数分别传入感兴趣的可读、可写及异常等事件，内核通过对这些参数的在线修改来反馈其中的就绪事件。这使得用户每次调用 select 都要重置这 3 个参数 | 统一处理所有事件类型，因此只需要一个事件集参数。用户通过 pollfd.events 传入感兴趣的事件，内核通过修改 pollfd.revents 反馈其中就绪的事件 | 内核通过一个事件表直接管理用户感兴趣的所有事件。因此每次调用 epoll_wait 时，无须反复传入用户感兴趣的事件。epoll_wait 系统调用的参数 events 仅用来反馈就绪的事件 |
| 应用程序索引就绪文件描述符的时间复杂度 | O(n)                                                         | O(n)                                                         | O(1)                                                         |
| 最大支持文件描述符数                   | 一般有最大值限制（1024）                                     | 65535                                                        | 65535                                                        |
| 工作模式                               | LT                                                           | LT                                                           | 支持 ET 高效模式                                             |
| 内核实现和工作效率                     | 采用轮询方式来检测就绪事件，算法时间复杂度为 O(n)            | 采用轮询方式来检测就绪事件，算法时间复杂度为 O(n)            | 采用回调方式来检测就绪事件，算法时间复杂度为 O(1)            |



# 参考文档

- 《Linux 高性能服务器编程》 第 9 章 I/O 复用