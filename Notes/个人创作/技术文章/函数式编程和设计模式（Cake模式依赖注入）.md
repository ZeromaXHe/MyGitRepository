在本篇中，我们会介绍 Scala 中如何使用 **Cake 模式**实现与传统的依赖注入框架相同的功能。该模式使用了 Scala 的**特质**和**自身类型标注**（self-type annotation），从而在无需容器的情况下实现了与依赖注入提供的相同的组成和结构。

我们将先回顾一下依赖注入的概念，然后再介绍 Cake 模式。

# 1 依赖注入

**依赖注入**，即 Dependency Injection，简称 DI。想必熟悉 Spring 的朋友们应该都见过这个概念，毕竟 Spring 面试题绕不过的**控制反转**（Inverse of Control, IoC）就和依赖注入密切相关。两者的关系，大致可以理解为通过依赖注入的手段实现了控制反转。

依赖注入的**目的**就是：采用外部的配置或代码来组合对象，而不是让对象自行初始化其依赖——这样做让我们对象注入不同的依赖实现变得非常简单，并为我们理解给定对象有哪些依赖提供了一个集中的管理场所。

简单理解，那就是将软件中某一接口具体实现类的选择控制权从调用对象中转移出来，交给外部第三方的配置来决定。对于 Spring 来说，就是交给了 Spring 容器的 Bean 配置（可以是 XML，也可以是纯注解的配置类）来进行控制。这个目的，就是我们常常说的“控制反转”。

依赖注入本身则是由软件界泰斗级人物 **Martin Fowler** （也是《重构》一书作者）提出的概念，用以代替 IoC。依赖注入即让调用类对某一接口实现类的依赖关系由第三方（容器或协作类）注入，以移除调用类对某一接口实现类的依赖。

这样，通过依赖注入，也就使得调用类和接口实现类之间实现了解耦。这使得替换给定依赖的实现变得更简单。尤其是因此在单元测试中允许使用 Stub 或 Mock 实现来替代实际的依赖，使得代码更容易被测试。

依赖注入主要就是通过构造器或 setter 方法将依赖注入对象。

> 顺便吐槽一下，网上有各种错误的关于 Spring Bean 依赖注入方式有多少种的回答，数字可以从三种开始一直往上加……
>
> 但其实就只有我们提到的：**构造器**和 **setter** 两种。具体可以参考 Spring 官方文档：[**1.4.1. Dependency Injection**: https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-collaborators](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-collaborators) 文档中可以看到：“DI exists in two major variants: [Constructor-based dependency injection](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-constructor-injection) and [Setter-based dependency injection](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-setter-injection).”，即“DI 存在两种：基于构造函数的依赖注入和基于 Setter 的依赖注入。”
>
> 网上大多数错误的文章是把 Bean 相关的一些 Spring 使用方式单独作为一种来和这两种注入方式并列，个人认为其实并不合适。一种错误是把 xml、注解实现这些具体的配置写法作为单独的一种分离出来，这种错误较为明显。还有一种错误是误把 `@Autowired` 或工厂方式作为单独的种类，其实前者是把自动装配功能错误理解成了注入方式的一种，而后者是将 Bean 的生成与注入本身混淆了。
>
> 个人认为以官方文档为准即可，分享一下相关思考供大家参考。

## 代码示例

使用代码举个例子会更加清晰。下面的类粗略地描述了一个电影服务，该服务可以返回用户收藏的电影。它依赖于一个收藏服务和一个电影的 DAO（数据访问对象），前者用来获取收藏的电影列表，后者可以获取每部电影的详情：

```java
public class MovieService {
    private MovieDao movieDao;
    private FavoritesService favoritesService;
    public MovieService(MovieDao movieDao, FavoritesService favoritesService) {
        this.movieDao = movieDao;
        this.favoritesService = favoritesService;
    }
}
```

此处使用的是传统的基于构造器的依赖注入。当该服务被创建时，MovieService 类必须将它依赖的内容以入参的方式传入构造器。这项工作可以手动完成，但是通常我们会选择一个依赖注入框架来替我们完成工作。

当我们以更具函数式的风格进行编程时，对依赖注入模式的需求将不会这么强烈。函数式编程本身就包含对函数的组合能力，由于这里所设计的函数组合能力与依赖注入对类的组合能力非常类似，所以我们无须任何代价就可以直接从函数组合中获得与依赖注入相似的好处。

然而，简单的函数组合并不能解决所有依赖注入所能处理的问题。由于 Scala 是一门混血语言，所以这一点尤为突出。较大的代码段通常会被组织为对象。

那么我们一起来看看依赖注入在 Scala 中的实现。

# 2 Scala 中实现依赖注入

传统的依赖注入自然也可以在 Scala 中使用，甚至可以使用像 Spring 或 Guice 这样为业界所熟知的 Java 框架。然而，在不使用任何框架的情况下也能达到许多同样的目标。这就是我们文章开头提到的使用了 Scala 的**特质**和**自身类型标注**（self-type annotation）实现的 **Cake 模式**。

其大致思想就是将需要注入到顶层特质的依赖进行封装，它们代表了可注入的组件。我们不会在特质的内部直接初始化依赖，而是在对它们进行装配的时候，创建抽象的 val 字段来保持对它们的引用。

然后，我们将会利用 Scala 的自身类型标注和混入继承，以一种类型安全的方式来指定装配。最后，采用一个简单的 Scala 对象作为我们的组件注册表。我们会将所有的依赖混入到该容器对象中并对它们进行初始化，然后采用前面提到的抽象 val 字段来保持对它们的引用。

这种方式具备了一些不错的特性。正如前面所提到的，它并不需要使用外部的容器。此外，在将事物装配起来的同时还维持了静态类型的安全。

让我们介绍一下即将在示例代码中出现的数据：我们拥有三个样本类——`Movie`、`Video` 和 `DecoratedMovie`（配备了视频的电影）。

```scala
case class Movie(movieId: String, title: String)
case class Video(movieId: String)
case class DecoratedMovie(movie: Movie, video: Video) 
```

现在定义一些特质作为接口，并将它们作为依赖：`FavoritesService` 和 `MovieDao`。我们会将这些特质嵌入到另一组用于表示可注入组件的特质中。

```scala
trait MovieDaoComponent {
  trait MovieDao {
    def getMovie(id: String): Movie
  }
}

trait FavoritesServiceComponent {
  trait FavoritesService {
    def getFavoriteVideos(id: String): Vector[Video]
  }
}
```

接下来，完成对刚才所引入的组件的实现。我们将通过实现这些接口来为 `MovieDao` 和 `FavoritesService` 生成测试 Stub，从而返回静态的响应。请注意，此外还需要对这些包装进来的组件特质进行扩展。

```scala
trait MovieDaoComponentImpl extends MovieDaoComponent {
  class MovieDaoImpl extends MovieDao {
    override def getMovie(id: String): Movie = Movie("42", "A Movie")
  }
}

trait FavoritesServiceComponentImpl extends FavoritesServiceComponent {
  class FavoritesServiceImpl extends FavoritesService {
    override def getFavoriteVideos(id: String): Vector[Video] = Vector(Video("1"))
  }
}
```

现在来看看 `MovieServiceImpl`，它依赖于前面定义的 `FavoritesService` 和 `MovieDao`。该类就实现了一个方法：`getFavoriteDecoratedMovies()`，该方法以用户 ID 为入参，并返回用户收藏的电影，这些电影都配备了相关联的视频。

`MovieServiceImpl` 的全部代码包装在一个顶层的 `MovieServiceComponentImpl` 特质中，如下所示：

```scala
trait MovieServiceComponentImpl {
  this: MovieDaoComponent with FavoritesServiceComponent =>

  val favoritesService: FavoritesService
  val movieDao: MovieDao

  class MovieServiceImpl {
    def getFavoriteDecoratedMovies(userId: String): Vector[DecoratedMovie] =
      for (
        favoriteVideo <- favoritesService.getFavoriteVideos(userId);
        movie = movieDao.getMovie(favoriteVideo.movieId)
      ) yield DecoratedMovie(movie, favoriteVideo)
  }
}
```

这里首行的 `this: MovieDaoComponent with FavoritesServiceComponent =>` 就是所说的自身类型标注，它可以确保 Cake 模式的类型安全。该自身类型标注确保了不管在何时，只要某个对象或类混入了 `MovieServiceComponentImpl`，那么该对象的引用都会拥有类型 `MovieDaoComponent with FavoritesServiceComponent`。换句话说，它确保了每当某些对象或类混入 `MovieServiceComponentImpl` 时，`MovieDaoComponent` 和 `FavoritesServiceComponent` 抑或是它们的子类也都将会混入该对象或类。

> 维持静态类型的安全，意味着如果下文中的对象注册表 `ComponentRegistry` 只扩展 `MovieServiceComponentImpl` 的话，会导致编译器错误。编译器会告诉我们，该注册表不符合我们为 `MovieServiceComponentImpl` 所声明的自身类型，即我们没有为其混入 `MovieDaoComponent` 和 `FavoritesServiceComponent`。

接下来声明的显式 val 字段存储了依赖的引用，这些能确保每当我们将 `MovieServiceComponentImpl` 混入容器对象时，都需要将它们分配给抽象的 val 字段。

> 这里确保分配 val 字段的对象是指：如果下文中的注册表 `ComponentRegistry` 没有实现成员 `favoritesService` 和 `movieDao`，会编译报错。

最后，创建作为组件注册表的对象：`ComponentRegistry`。该注册表扩展了我们所有的依赖实现，并对它们进行了初始化，然后将它们的引用存储在前面定义的 val 字段中：

```scala
object ComponentRegistry extends MovieServiceComponentImpl with FavoritesServiceComponentImpl with MovieDaoComponentImpl {
  val favoritesService = new FavoritesServiceImpl
  val movieDao = new MovieDaoImpl

  val movieService = new MovieServiceImpl
}
```

完成以上代码后，我们就可以在使用场景下从注册表中获取装配完整的 `MovieService` 了：

```scala
val movieService = ComponentRegistry.movieService
println(movieService.getFavoriteDecoratedMovies(""))
```

如果需要在单元测试中注入依赖的测试 Stub，则可以按照如下方式操作（可以看出，代码是类似的，只是实现变换了）：

```scala
trait MovieDaoComponentTestImpl extends MovieDaoComponent {
  class MovieDaoTestImpl extends MovieDao {
    override def getMovie(id: String): Movie = Movie("43", "A Test Movie")
  }
}

trait FavoriteServiceComponentTestImpl extends FavoritesServiceComponent {
  class FavoriteServiceTestImpl extends FavoritesService {
    override def getFavoriteVideos(id: String): Vector[Video] = Vector(Video("2"))
  }
}

object TestComponentRegistry extends MovieServiceComponentImpl with FavoriteServiceComponentTestImpl with MovieDaoComponentTestImpl {
  val favoritesService = new FavoriteServiceTestImpl
  val movieDao = new MovieDaoTestImpl

  val movieSerive = new MovieServiceImpl
}

println(TestComponentRegistry.movieSerive.getFavoriteDecoratedMovies(""))
```

由于 Cake 模式使用了 Scala 的自身类型标注，Java 中无法复刻该模式。



![GitHub](https://img.shields.io/badge/GitHub-ZeromaXHe-lightgrey?style=flat-square&logo=GitHub)![Gitee](https://img.shields.io/badge/Gitee-zeromax-red?style=flat-square&logo=Gitee)![LeetCodeCN](https://img.shields.io/badge/LeetCodeCN-ZeromaX-orange?style=flat-square&logo=LeetCode)![Weixin](https://img.shields.io/badge/%E5%85%AC%E4%BC%97%E5%8F%B7-ZeromaX%E8%A8%B8%E7%9A%84%E6%97%A5%E5%B8%B8-brightgreen?style=flat-square&logo=WeChat)![Zhihu](https://img.shields.io/badge/%E7%9F%A5%E4%B9%8E-maX%20Zero-blue?style=flat-square&logo=Zhihu)![Bilibili](https://img.shields.io/badge/Bilibili-ZeromaX%E8%A8%B8-lightblue?style=flat-square&logo=Bilibili)![CSDN](https://img.shields.io/badge/CSDN-SquareSquareHe-red?style=flat-square)