# 1 序言

Spring Data JPA 提供了 Jakarta 持久层 API（JPA）的数据库支持。它减轻了连接 JPA 数据源的应用开发负担。

# 2 升级 Spring Data

# 3 依赖

因为各个 Spring Data 模块的起始日期不同，它们中的大多数都带有不同的主要版本号和次要版本号。找到兼容版本的最简单方法是依赖于我们随定义的兼容版本一起提供的 Spring Data Release Train BOM。在 Maven 项目中，您可以在 POM 的 `<dependencyManagement/>` 部分声明此依赖关系，如下所示：

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.data</groupId>
      <artifactId>spring-data-bom</artifactId>
      <version>2022.0.1</version>
      <scope>import</scope>
      <type>pom</type>
    </dependency>
  </dependencies>
</dependencyManagement>
```

目前发行的 train 版本是 `2022.0.1`。train 版本使用模式为 `YYYY.MINOR.MICRO` 的 calver。GA 版本和服务版本的版本名称遵循 `${calver}`，所有其他版本的版本名遵循以下模式：`${calver}-${modifier}`，其中 modifier 可以是以下之一：

- SNAPSHOT：当前快照
- M1、M2 等：里程碑
- RC1、RC2 等：发布候选项

您可以在我们的 Spring Data 示例仓库中找到使用 BOM 的工作示例。这样，您就可以在 `<dependencies/>` 块中没有版本的情况下声明要使用的 Spring Data 模块，如下所示：

```xml
<dependencies>
  <dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-jpa</artifactId>
  </dependency>
<dependencies>
```

## 3.1 Spring Boot 的依赖管理

Spring Boot 为你选择最新版本的 Spring Data 模块。如果你依然希望升级到一个更新的版本，将 `spring-data-releasetrain.version` 设置为你想要使用的 train 版本和迭代。

## 3.2 Spring 框架

当前版本的 Spring Data 模块需要 Spring Framework 6.0.4 或更高版本。这些模块还可以与该次要版本的较旧错误修复版本一起使用。但是，强烈建议在该代中使用最新版本。

# 4 使用 Spring Data 存储库

Spring Data 存储库抽象的目标是显著减少为各种持久性存储实现数据访问层所需的样板代码量。

> *Spring Data 存储库文档和你的模块*
>
> 本章解释了 Spring Data 存储库的核心概念和接口。本章中的信息来自 SpringDataCommons 模块。它使用 Jakarta 持久层 API（JPA）模块的配置和代码示例。如果要使用 XML 配置，则应将 XML 命名空间声明和要扩展的类型调整为所使用的特定模块的等效类型。“命名空间引用”涵盖 XML 配置，所有支持数据库 API 的 Spring Data 模块都支持该配置。“数据库查询关键字”通常涵盖数据库抽象支持的查询方法关键字。有关模块特定功能的详细信息，请参阅本文档中有关该模块的章节。

## 4.1 核心概念

Spring Data 数据存储库抽象中的中心接口是 `Repository`。它将要管理的域类（domain class）以及域类的 ID 类型作为类型参数。此接口主要用作标记接口，以捕获要使用的类型，并帮助您发现扩展此类型的接口。`CrudRepository` 和 `ListCrudRepoository` 接口为所管理的实体类提供了复杂的 CRUD 功能。

```java
public interface CrudRepository<T, ID> extends Repository<T, ID> {

  <S extends T> S save(S entity); // 保存指定实体

  Optional<T> findById(ID primaryKey); // 返回由给定 ID 标识的实体

  Iterable<T> findAll(); // 返回所有实体

  long count(); // 返回实体数

  void delete(T entity); // 删除给定实体

  boolean existsById(ID primaryKey); // 指示是否存在具有给定 ID 的实体

  // … 省略更多的功能
}
```

`ListCrudRepository` 提供了等效的方法，但它们返回 `List`，其中 `CrudRepoository` 方法返回 `Iterable`。

> 我们还提供了持久性技术特定的抽象，例如 `JpaRepository` 或 `MongoRepository`。这些接口扩展了 `CrudRepository`，并公开了底层持久性技术的功能，以及诸如 `CrudRepoository` 等相当通用的持久性技术无关接口。

除了 `CrudRepository` 之外，还有一个 `PagingAndSortingRepository` 抽象，它添加了其他方法来简化对实体的分页访问：

```java
public interface PagingAndSortingRepository<T, ID>  {

  Iterable<T> findAll(Sort sort);

  Page<T> findAll(Pageable pageable);
}
```

要以 20 的页面大小访问 User 的第二页，可以执行以下操作：

```java
PagingAndSortingRepository<User, Long> repository = // … get access to a bean
Page<User> users = repository.findAll(PageRequest.of(1, 20));
```

除了查询方法之外，还可以对 count 和 delete 查询进行查询派生。以下列表显示派生计数查询的接口定义：

```java
interface UserRepository extends CrudRepository<User, Long> {

  long countByLastname(String lastname);
}
```

以下列表显示了派生删除查询的接口定义：

```java
interface UserRepository extends CrudRepository<User, Long> {

  long deleteByLastname(String lastname);

  List<User> removeByLastname(String lastname);
}
```

## 4.2 查询方法

标准 CRUD 功能存储库通常对底层数据存储进行查询。使用 Spring Data，声明这些查询将成为一个四步过程：

1. 声明一个扩展 Repository 或其子接口之一的接口，并将其键入其应处理的域类和 ID 类型，如下例所示：
   ```java
   interface PersonRepository extends Repository<Person, Long> { … }
   ```

2. 在接口上声明查询方法。
   ```java
   interface PersonRepository extends Repository<Person, Long> {
     List<Person> findByLastname(String lastname);
   }
   ```

3. 设置 Spring 以使用 JavaConfig 或 XML 配置为这些接口创建代理实例。
   ```java
   import org.springframework.data.….repository.config.EnableJpaRepositories;
   
   @EnableJpaRepositories
   class Config { … }
   ```

   本例中使用了 JPA 名称空间。如果您将存储库抽象用于任何其他存储，则需要将其更改为存储模块的适当名称空间声明。换言之，您应该交换 `jpa` 以支持例如 `mongodb`。

   注意，JavaConfig 变量没有显式配置包，因为默认情况下使用带注解类的包。要自定义要扫描的包，请使用数据存储特定存储库的 `@EnableJpaRepositorys` 注解的 `basePackage…` 属性之一。

4. 注入存储库实例并使用它，如下例所示：

   ```java
   class SomeClient {
   
     private final PersonRepository repository;
   
     SomeClient(PersonRepository repository) {
       this.repository = repository;
     }
   
     void doSomething() {
       List<Person> persons = repository.findByLastname("Matthews");
     }
   }
   ```

以下章节详细解释了每个步骤：

- 定义存储库接口
- 定义查询方法
- 创建存储库实例
- Spring Data 存储库的自定义实现

## 4.3 定义存储库接口

要定义存储库接口，首先需要定义特定于域类的存储库接口。接口必须扩展 `Repository`，并键入域类和 ID 类型。如果要公开该域类型的 CRUD 方法，可以扩展 `CrudRepository` 或其变体之一而不是 `Repository`。

### 4.3.1 微调存储库定义

如何开始使用存储库界面有几个变体。

典型的方法是扩展 `CrudRepository`，它为 CRUD 功能提供了方法。CRUD 代表创建、读取、更新和删除。在 3.0 版本中，我们还引入了 `ListCrudRepository`，它与 `CrudRepoository` 非常相似，但对于那些返回多个实体的方法，它返回的是 `List` 而不是 `Iterable`，这可能更容易使用。

如果您使用的是反应式存储，您可以选择 `ReactiveCrudRepository` 或 `RxJava3CrudRepository`，具体取决于您使用的反应式框架。

如果您使用的是 Kotlin，您可以选择使用 Kotlin 协同例程的 `CoroutineCrudRepository`。

此外，如果您需要允许指定排序抽象或在第一种情况下指定可分页抽象的方法，则可以扩展 `PagingAndSortingRepository`、`ReactiveSortingRepository`、`RxJava3SortingRepository` 或 `CoroutineSortingRepository`。注意，不同的排序存储库不再像 Spring Data 3.0 版本之前那样扩展各自的 CRUD 存储库。因此，如果您希望两个接口都具有功能，则需要扩展这两个接口。

如果不想扩展 Spring Data 接口，还可以使用 `@RepositoryDefinition` 注解存储库接口。扩展其中一个 CRUD 存储库接口将公开一整套操作实体的方法。如果您希望对公开的方法有所选择，请将要公开的方法从CRUD存储库复制到域存储库中。执行此操作时，可以更改方法的返回类型。如果可能，Spring Data 将采用返回类型。例如，对于返回多个实体的方法，可以选择 `Iterable<T>`、`List<T>`，`Collection<T>` 或 VAVR 列表。

如果应用程序中的许多存储库应该具有相同的方法集，则可以定义自己的基本接口以从中继承。这样的接口必须用 `@NoRepositoryBean` 注解。这防止了 Spring Data 尝试直接创建它的实例并失败，因为它无法确定该存储库的实体，因为它仍然包含泛型类型变量。

以下示例显示了如何选择性地公开 CRUD 方法（本例中为 `findById` 和 `save`）：

```java
@NoRepositoryBean
interface MyBaseRepository<T, ID> extends Repository<T, ID> {

  Optional<T> findById(ID id);

  <S extends T> S save(S entity);
}

interface UserRepository extends MyBaseRepository<User, Long> {
  User findByEmailAddress(EmailAddress emailAddress);
}
```

在前面的示例中，您为所有域存储库定义了一个公共的基本接口，并公开了 `findById(…)` 和 `save(…)`。这些方法被路由到 Spring Data 提供的您选择的存储库的基本存储库实现中（例如，如果您使用 JPA，则实现为 `SimpleJpaRepository`），因为它们与 `CrudRepository` 中的方法签名匹配。因此，`UserRepository` 现在可以保存用户，按 ID 查找单个用户，并触发查询以按电子邮件地址查找 `Users`。

> 中间存储库接口用 `@NoRepositoryBean` 注解。确保将该注解添加到所有存储库接口，Spring Data 不应在运行时为其创建实例。

### 4.3.2 使用具有多个 Spring Data 模块的存储库

在应用程序中使用唯一的 Spring Data 模块使事情变得简单，因为定义范围内的所有存储库接口都绑定到 Spring Data 模块。有时，应用程序需要使用多个 Spring Data 模块。在这种情况下，存储库定义必须区分持久性技术。当它在类路径上检测到多个存储库工厂时，Spring Data 进入严格的存储库配置模式。严格配置使用存储库或域类的详细信息来决定存储库定义的 Spring Data 模块绑定：

1. 如果存储库定义扩展了特定于模块的存储库，则它是特定 Spring Data 模块的有效候选。
2. 如果域类使用模块特定的类型注解进行了注解，则它是特定 Spring Data 模块的有效候选。Spring Data 模块接受第三方注解（如 JPA 的 `@Entity`）或提供自己的注解（如 Spring Data MongoDB 和 Spring Data Elasticsearch 的 `@Document`）。

