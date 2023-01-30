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

如何开始使用存储库接口有几个变体。

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

下面的例子展示了一个使用特定模块接口的存储库（此例中为 JPA）：

```java
interface MyRepository extends JpaRepository<User, Long> { }

@NoRepositoryBean
interface MyBaseRepository<T, ID> extends JpaRepository<T, ID> { … }

interface UserRepository extends MyBaseRepository<User, Long> { … }
```

`MyRepository` 和 `UserRepository` 在他们的类型层级结构中扩展了 `JpaRepository`。它们是 Spring Data JPA 模块的可用候选。

下面例子展示了使用通用接口的存储库：

```java
interface AmbiguousRepository extends Repository<User, Long> { … }

@NoRepositoryBean
interface MyBaseRepository<T, ID> extends CrudRepository<T, ID> { … }

interface AmbiguousUserRepository extends MyBaseRepository<User, Long> { … }
```

`AmbiguousRepository` 和 `AmbiguousUserRepository` 仅在它们类型层级结构中扩展 `Repository` 和 `CrudRepository`。虽然这在使用唯一的 Spring Data 模块时是可以的，但多个模块无法分辨这些存储库应该绑定到哪个特定 Spring Data。

下面例子展示了一个使用注解了的域类型的存储库：

```java
interface PersonRepository extends Repository<Person, Long> { … }

@Entity
class Person { … }

interface UserRepository extends Repository<User, Long> { … }

@Document
class User { … }
```

`PersonRepository` 引用了使用 JPA `@Entity` 注解的 `Person`，所以这个存储库显然属于 Spring Data JPA。`UserRepository` 引用了使用 Spring Data MongoDB 的 `@Document` 注解的 `User`。

下面的坏例子展示了使用混合注解的域类型的存储库：

```java
interface JpaPersonRepository extends Repository<Person, Long> { … }

interface MongoDBPersonRepository extends Repository<Person, Long> { … }

@Entity
@Document
class Person { … }
```

这个例子展示了一个同时使用了 JPA 和 Spring Data MongoDB 注解的域类型。它定义了两个存储库，`JpaPersonRepository` 和 `MongoDBPersonRepository`。一个给 JPA 使用，另一个给 MongoDB 使用。Spring Data 不再能够区分存储库，这将导致不确定的行为。

存储库类型细节和区分域类型注解用于严格的存储库配置，以识别特定 Spring Data 模块的候选存储库。在同一域类型上使用多个持久性技术特定的注解是可能的，并支持跨多个持久化技术重用域类型。然而，Spring Data 无法再确定绑定存储库的唯一模块。

区分存储库的最后一种方法是确定存储库基本包的范围。基本包定义了扫描存储库接口定义的起点，这意味着存储库定义位于适当的包中。默认情况下，注释驱动配置使用配置类的包。基于 XML 的配置中的基本包是必需的。

下面例子展示了基本包的注解驱动配置：

```java
@EnableJpaRepositories(basePackages = "com.acme.repositories.jpa")
@EnableMongoRepositories(basePackages = "com.acme.repositories.mongo")
class Configuration { … }
```

## 4.4 定义查询方法

存储库代理有两种方式来从方法名称派生特定于存储的查询：

- 通过直接从方法名派生查询。
- 通过使用手动定义的查询。

可用选项取决于实际存储。然而，必须有一种策略来决定实际创建的查询。下一节介绍可用选项。

### 4.4.1 查询查找策略

以下策略可用于存储库基础结构来解决查询。使用 XML 配置，您可以通过 `query-lookup-strategy` 属性在命名空间中配置策略。对于 Java 配置，可以使用 `EnableJpaRepositorys` 注解的 `queryLookupStrategy` 属性。某些策略可能不支持特定的数据存储。

- `CREATE` 尝试根据查询方法名称构造特定于存储的查询。一般的方法是从方法名中删除一组已知的前缀，并解析方法的其余部分。您可以在“创建查询”中阅读有关构造查询的更多信息。
- `USE_DECLARED_QUERY` 尝试查找声明的查询，如果找不到则抛出异常。查询可以由某处的注释定义，也可以通过其他方式声明。请参阅特定存储的文档以查找该存储的可用选项。如果存储库基础结构在引导时未找到该方法的声明查询，则会失败。
- `CREATE_IF_NOT_FOUND`（默认值）结合了 `CREATE` 和 `USE_DECLARED_QUERY`。它首先查找一个声明的查询，如果没有找到声明的查询则创建一个基于方法名的自定义查询。这是默认的查找策略，因此，如果未显式配置任何内容，则使用该策略。它允许通过方法名快速定义查询，但也可以根据需要引入声明的查询来定制这些查询。

### 4.4.2 创建查询

内置于 Spring Data 存储库基础结构中的查询构建器机制对于在存储库的实体上构建约束查询非常有用。

以下示例显示了如何创建多个查询：

```java
interface PersonRepository extends Repository<Person, Long> {

  List<Person> findByEmailAddressAndLastname(EmailAddress emailAddress, String lastname);

  // Enables the distinct flag for the query
  List<Person> findDistinctPeopleByLastnameOrFirstname(String lastname, String firstname);
  List<Person> findPeopleDistinctByLastnameOrFirstname(String lastname, String firstname);

  // Enabling ignoring case for an individual property
  List<Person> findByLastnameIgnoreCase(String lastname);
  // Enabling ignoring case for all suitable properties
  List<Person> findByLastnameAndFirstnameAllIgnoreCase(String lastname, String firstname);

  // Enabling static ORDER BY for a query
  List<Person> findByLastnameOrderByFirstnameAsc(String lastname);
  List<Person> findByLastnameOrderByFirstnameDesc(String lastname);
}
```

解析查询方法名分为主语和谓语。第一部分（`find…By`，`exists…By`）定义查询的主语，第二部分构成谓语。介绍子句（主语）可以包含其他表达式。`find`（或其他引入关键字）和 `By` 之间的任何文本都被认为是描述性的，除非使用结果限制关键字之一（如 `Distinct`）在要创建的查询上设置不同的标志，或使用 `Top`/`First` 限制查询结果。

附录包含查询方法主题关键字和查询方法谓词关键字的完整列表，包括排序和字母大小写修饰符。但是，第一个 `By` 充当分隔符，指示实际条件谓词的开始。在非常基础的程度上，您可以定义实体属性上的条件，并使用 `And` 和 `Or` 将它们连接起来。

解析方法的实际结果取决于为其创建查询的持久性存储。然而，有一些通用事情需要注意：

- 表达式通常是属性遍历和可以连接的运算符。可以将属性表达式与 `AND` 和 `OR` 组合。对于属性表达式，还可以支持 `Between`、`LessThan`、`GreaterThan` 和 `Like` 等运算符。支持的运算符可能因数据存储而异，因此请参阅参考文档的相应部分。
- 方法解析器支持为单个属性（例如，`findByLastnameIgnoreCase(…)`）或支持忽略大小写的类型的所有属性（通常为 `String` 实例——例如，`findByLastnameAndFirstnameAllIgnoreCase(…)`）。是否支持忽略案例可能因存储而异，因此请参阅参考文档中的相关章节以了解特定于存储的查询方法。
- 通过向引用属性的查询方法附加 `OrderBy` 子句并提供排序方向（`Asc` 或 `Desc`），可以应用静态排序。要创建支持动态排序的查询方法，请参阅“特殊参数处理”。

### 4.4.3 属性表达式

属性表达式只能引用托管实体的直接属性，如前一示例所示。在创建查询时，您已经确保解析的属性是托管域类的属性。但是，也可以通过遍历嵌套属性来定义约束。考虑以下方法签名：

```java
List<Person> findByAddressZipCode(ZipCode zipCode);
```

假设 `Person` 有一个带有 `ZipCode` 的 `Address`。在这种情况下，该方法创建`x.address.zipCode` 属性遍历。解析算法首先将整个部分（`AddressZipCode`）解释为属性，然后检查域类中具有该名称（未大写）的属性。如果算法成功，则使用该属性。如果没有，算法会将右侧驼峰式部分的源拆分为头部和尾部，并尝试找到相应的属性 — 在我们的示例中，`AddressZip` 和 `Code`。如果算法找到了具有该头部的属性，它将获取尾部并继续从那里向下构建树，以刚才描述的方式将尾部向上拆分。如果第一次拆分不匹配，则算法将拆分点向左移动（地址，ZipCode）并继续。

虽然这在大多数情况下都有效，但算法可能会选择错误的属性。假设 `Person` 类也具有 `addressZip` 属性。算法将在第一轮拆分中匹配，选择错误的属性，并失败（因为 `addressZip` 类型可能没有 `code` 属性）。

为了解决这种歧义，可以在方法名中使用 `_` 来手动定义遍历点。因此，我们的方法名称如下：

```java
List<Person> findByAddress_ZipCode(ZipCode zipCode);
```

因为我们将下划线字符视为保留字符，所以强烈建议遵循标准 Java 命名约定（即，不要在属性名称中使用下划线，而是使用驼峰大小写）。

### 4.4.4 特殊参数处理

为了处理你查询中的参数，请按前面例子定义方法参数。除此之外，基础结构还识别某些特定类型，如 `Pageable` 和 `Sort`，以动态地对查询应用分页和排序。以下示例演示了这些功能：

```java
Page<User> findByLastname(String lastname, Pageable pageable);

Slice<User> findByLastname(String lastname, Pageable pageable);

List<User> findByLastname(String lastname, Sort sort);

List<User> findByLastname(String lastname, Pageable pageable);
```

> 采用 `Sort` 和 `Pageable` 的 API 期望将非空值传递给方法。如果不想应用任何排序或分页，请使用 `Sort.unsorted()` 和 `Pageable.unpaged()`。

第一个方法允许您将 `org.springframework.data.domain.Pageable` 实例传递给查询方法，以动态地向静态定义的查询添加分页。`Page` 知道可用元素和页面的总数。它通过基础结构触发计数查询来计算总数。由于这可能很昂贵（取决于使用的存储），您可以改为返回一个 `Slice`。`Slice` 只知道下一个 `Slice` 是否可用，这在遍历较大的结果集时可能就足够了。

排序选项也通过 `Pageable` 实例处理。如果只需要排序，请在方法中添加 `org.springframework.data.domain.Sort` 参数。如您所见，返回 `List` 也是可能的。在这种情况下，没有创建构建实际 `Page` 实例所需的附加元数据（这反过来意味着没有发出本应需要的附加计数查询）。相反，它限制查询仅查找给定范围的实体。

> 要了解整个查询获得了多少页面，必须触发一个额外的计数查询。默认情况下，此查询是从实际触发的查询派生的。

#### 分页和排序

可以使用属性名称定义简单的排序表达式。可以连接表达式以将多个条件收集到一个表达式中。

```java
Sort sort = Sort.by("firstname").ascending()
  .and(Sort.by("lastname").descending());
```

要使用更安全的类型定义排序表达式，请从定义排序表达式的类型开始，并使用方法引用定义要排序的属性。

```java
TypedSort<Person> person = Sort.sort(Person.class);

Sort sort = person.by(Person::getFirstname).ascending()
  .and(person.by(Person::getLastname).descending());
```

> `TypedSort.by(…)` 通过（通常）使用 CGlib 来使用运行时代理，这可能会在使用 Graal VM Native 等工具时干扰本机镜像编译。

如果您的存储实现支持 Querydsl，您还可以使用生成的元模型类型来定义排序表达式：

```java
QSort sort = QSort.by(QPerson.firstname.asc())
  .and(QSort.by(QPerson.lastname.desc()));
```

### 4.4.5 限制查询结果

您可以通过使用 `first` 或 `top` 关键字来限制查询方法的结果，这两个关键字可以互换使用。您可以在 `top` 或 `first` 附加一个可选的数值，以指定要返回的最大结果大小。如果省略了该数字，则假定结果大小为 1。以下示例显示了如何限制查询大小：

```java
User findFirstByOrderByLastnameAsc();

User findTopByOrderByAgeDesc();

Page<User> queryFirst10ByLastname(String lastname, Pageable pageable);

Slice<User> findTop3ByLastname(String lastname, Pageable pageable);

List<User> findFirst10ByLastname(String lastname, Sort sort);

List<User> findTop10ByLastname(String lastname, Pageable pageable);
```

限制表达式还支持支持不同查询的数据存储的 `Distinct` 关键字。此外，对于将结果集限制为一个实例的查询，支持使用关键字 `Optional` 将结果包装为 `Optional`。

如果分页或切片应用于限制查询分页（以及可用页面数的计算），则在限制结果内应用。

> 通过使用 `Sort` 参数结合动态排序限制结果，可以表达“K”最小元素和“K”最大元素的查询方法。

### 4.4.6 存储库方法返回集合或迭代器

返回多个结果的查询方法可以使用标准的 Java `Iterable`、`List` 和 `Set`。除此之外，我们还支持返回 Spring Data 的 `Streamable`（`Iterable` 的自定义扩展）以及 Vavr 提供的集合类型。请参阅说明所有可能的查询方法返回类型的附录。

#### 使用 Steamable 作为查询方法返回值

你可以选择 `Streamable` 作为 `Iterable` 或任何集合类型的替代。它提供了访问非并行 `Stream` 的方便方法（`Iterable` 没有）和直接在元素上使用 `….filter(…)` 和 `….map(…)` 以及和其他 `Streamable` 连接的能力：

```java
interface PersonRepository extends Repository<Person, Long> {
  Streamable<Person> findByFirstnameContaining(String firstname);
  Streamable<Person> findByLastnameContaining(String lastname);
}

Streamable<Person> result = repository.findByFirstnameContaining("av")
  .and(repository.findByLastnameContaining("ea"));
```

#### 返回自定义 Steamable 包装器类型

为集合提供专用包装类型是一种常用的模式，用于为返回多个元素的查询结果提供API。通常，通过调用存储库方法返回类似集合的类型并手动创建包装器类型的实例来使用这些类型。您可以避免这一额外步骤，因为 Spring Data 允许您将这些包装器类型用作查询方法返回类型，如果它们满足以下条件：

- 该类型实现了 `Streamable`
- 该类型暴露了一个构造器或者一个名为 `of(…)` 或 `valueOf(…)` 接收 `Streamable` 作为入参的静态工厂方法。

下面展示一个例子：

```java
class Product {                                         (1)
  MonetaryAmount getPrice() { … }
}

@RequiredArgsConstructor(staticName = "of")
class Products implements Streamable<Product> {         (2)

  private final Streamable<Product> streamable;

  public MonetaryAmount getTotal() {                    (3)
    return streamable.stream()
      .map(Priced::getPrice)
      .reduce(Money.of(0), MonetaryAmount::add);
  }


  @Override
  public Iterator<Product> iterator() {                 (4)
    return streamable.iterator();
  }
}

interface ProductRepository implements Repository<Product, Long> {
  Products findAllByDescriptionContaining(String text); (5)
}
// (1) 一个公开了访问产品价格的 API 的 `Product` 实体
// (2) `Streamable<Product>` 的包装类可以使用 `Products.of(…)`（Lombok 注解创建的工厂方法）构造。一个使用 `Streamable<Product>` 标准构造器也可以
// (3) 包装类公开了一个额外的 API，计算 `Streamable<Product>` 的新值
// (4) 实现 `Streamable` 接口且委托给真正的结果
// (5) 包装类 `Products` 可以被直接使用为一个查询方法返回类型。你不需要返回 `Streamable<Product>` 和手动在查询存储库客户端后包装。
```

#### Vavr 集合的支持

Vavr 是一个 Java 中拥抱函数式编程概念的库。它附带了一组自定义集合类型，可以用作查询方法返回类型，如下表所示：

| Vavr 集合类型            | 使用的 Vavr 实现类型               | 可用的 Java 源类型   |
| ------------------------ | ---------------------------------- | -------------------- |
| `io.vavr.collection.Seq` | `io.vavr.collection.List`          | `java.util.Iterable` |
| `io.vavr.collection.Set` | `io.vavr.collection.LinkedHashSet` | `java.util.Iterable` |
| `io.vavr.collection.Map` | `io.vavr.collection.LinkedHashMap` | `java.util.Map`      |

根据实际查询结果的 Java 类型（第三列），您可以将第一列中的类型（或其子类型）用作查询方法返回类型，并获取第二列中用作实现类型的类型。或者，您可以声明 `Traversable`（Vavr `Iterable` 等价物），然后从实际返回值派生实现类。也就是说，`java.util.List` 变成 Vavr `List` 或 `Seq`，`java.util.Set` 变成 Vavr `LinkedHashSet` `Set`，依此类推。

### 4.4.7 存储库方法空处理

对于 Spring Data 2.0，返回单个聚合实例的存储库 CRUD 方法使用 Java 8 的 `Optional` 来说明可能值缺失。除此之外，Spring Data 支持在查询方法上返回下面包装类：

- `com.google.common.base.Optional`
- `scala.Option`
- `io.vavr.control.Option`

可选地，查询方法可以选择根本不使用包装类。查询结果的缺失会通过返回 `null` 来表示。返回集合、集合替代物、包装类以及 stream 的存储库方法会保证永远不返回 `null`，而是返回相应的空表示。有关详细信息，请参阅“存储库查询返回类型”。

#### 可空性注解

你可以通过使用 Spring 框架的可空性注解来为存储库方法表示可空性限制。他们提供一个工具友好的方式和运行时可选的 `null` 检查，如下所示：

- `@NonNullApi`：用在包级别上来分别声明参数和返回值的默认行为是既不接受也不生成 `null` 值。
- `@NonNull`：用于不能为 `null` 的参数或返回值（`@NonNullApi` 适用的参数和返回值不需要）。
- `@Nullable`：用于可以为 `null` 的参数或返回值。

Spring 注解使用 JSR 305 注解（一种休眠但广泛使用的 JSR）。JSR 305 元注解使得工具供应商（如 IDEA、Eclipse 和 Kotlin）可以以通用方式提供空安全支持，而无须对 Spring 注解进行硬编码支持。要启用查询方法的可空性约束的运行时检查，需要在 `package-info.java` 中使用 Spring 的 `@NonNullApi` 在包级别激活不可空性，如下例所示：

```java
@org.springframework.lang.NonNullApi
package com.acme;
```

一旦设置了非空默认值，存储库查询方法调用将在运行时验证可空性约束。如果查询结果违反了已定义的约束，则会引发异常。当方法返回 `null` 但声明为不可为空时（默认情况下，在存储库所在的包上定义了注解），就会发生这种情况。如果您想再次选择可为空的结果，请在单个方法上选择性地使用 `@Nullable`。使用本节开头提到的结果包装器类型继续按预期工作：将空结果转换为表示缺席的值。

下面例子展示了刚刚描述的一些技术：

```java
package com.acme;                                                       (1)

import org.springframework.lang.Nullable;

interface UserRepository extends Repository<User, Long> {

  User getByEmailAddress(EmailAddress emailAddress);                    (2)

  @Nullable
  User findByEmailAddress(@Nullable EmailAddress emailAdress);          (3)

  Optional<User> findOptionalByEmailAddress(EmailAddress emailAddress); (4)
}
// (1) 存储库位于我们为其定义了非空行为的包（或子包）中。
// (2) 当查询未生成结果时，引发 `EmptyResultDataAccessException`。当传递给方法的 `emailAddress` 为空时，引发 `IllegalArgumentException`。
// (3) 当查询不产生结果时，返回 `null`。还接受 `null` 作为 `emailAddress` 的值。
// (4) 当查询不产生结果时，返回 `Optional.empty()`。当传递给方法的 `emailAddress` 为 `null` 时，引发 `IllegalArgumentException`。
```

#### 在基于 Kotlin 的存储库中的可空性

Kotlin 在语言中定义了可空性的约束。Kotlin 代码编译成字节码，字节码不通过方法签名来表达可空性约束，而是通过编译的元数据来表达。确保在您的项目中包含 `kotlin-reflect` JAR，以便能够对 Kotlin 的可空性约束进行内省。Spring Data 存储库使用语言机制来定义这些约束，以应用相同的运行时检查，如下所示：

```kotlin
interface UserRepository : Repository<User, String> {

  fun findByUsername(username: String): User     (1)

  fun findByFirstname(firstname: String?): User? (2)
}

// (1) 该方法将参数和结果都定义为不可为空（Kotlin 默认值）。Kotlin 编译器拒绝向方法传递 `null` 的方法调用。如果查询产生空结果，则引发 `EmptyResultDataAccessException`。
// (2) 此方法接受 `firstname` 参数的 `null`，如果查询未生成结果，则返回 `null`。
```

### 4.4.8 流查询结果

通过使用 Java 8 `Stream<T>` 作为返回类型，可以增量处理查询方法的结果。不是将查询结果包装在 `Stream` 中，而是使用特定于数据存储的方法来执行流，如以下示例所示：

```java
@Query("select u from User u")
Stream<User> findAllByCustomQueryAndStream();

Stream<User> readAllByFirstnameNotNull();

@Query("select u from User u")
Stream<User> streamAllPaged(Pageable pageable);
```

> `Stream` 可能会包装底层数据存储特定的资源，因此在使用后必须关闭。您可以使用 `close()` 方法或使用 Java 7 `try-with-resources` 块手动关闭 `Stream`，如下例所示：
>
> ```java
> try (Stream<User> stream = repository.findAllByCustomQueryAndStream()) {
>   stream.forEach(…);
> }
> ```

> 不是所有 Spring Data 模块现在都支持 `Stream<T>` 作为返回值。

### 4.4.9 异步查询结果

你可以通过 Spring 的异步方法运行功能异步运行存储库查询。这意味着当实际查询发生在已提交给 Spring `TaskExecutor` 的任务中时，方法在调用时立即返回。异步查询不同于反应式查询，不应混合使用。有关反应式支持的更多详细信息，请参阅特定于存储的文档。以下示例显示了许多异步查询：

```java
@Async
Future<User> findByFirstname(String firstname);               (1)

@Async
CompletableFuture<User> findOneByFirstname(String firstname); (2)

// (1) 使用 `java.util.concurrent.Future` 作为返回类型。
// (2) 使用一个 Java 8 `java.util.concurrent.CompletableFuture` 作为返回类型。
```

## 4.5 创建存储库实例

这一节介绍如何为已定义的存储库接口创建实例和 bean 定义。

### 4.5.1 Java 配置

在 Java 配置类上使用特定于存储的 `@EnableJpaRepositorys` 注解来定义存储库激活的配置。有关 Spring 容器基于 Java 的配置的介绍，请参阅 Spring 参考文档中的 JavaConfig。

启用 Spring Data 存储库的示例配置如下所示：

```java
@Configuration
@EnableJpaRepositories("com.acme.repositories")
class ApplicationConfiguration {

  @Bean
  EntityManagerFactory entityManagerFactory() {
    // …
  }
}
```

> 前面的示例使用特定于 JPA 的注解，您可以根据实际使用的存储模块进行更改。这同样适用于 `EntityManagerFactory` bean 的定义。请参阅涵盖特定于存储的配置的部分。

### 4.5.2 XML 配置

每个 Spring Data 模块都包含一个存储库元素，允许您定义 Spring 为您扫描的基本包，如下例所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans:beans xmlns:beans="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.springframework.org/schema/data/jpa"
  xsi:schemaLocation="http://www.springframework.org/schema/beans
    https://www.springframework.org/schema/beans/spring-beans.xsd
    http://www.springframework.org/schema/data/jpa
    https://www.springframework.org/schema/data/jpa/spring-jpa.xsd">

  <jpa:repositories base-package="com.acme.repositories" />

</beans:beans>
```

在前面的示例中，指示 Spring 扫描 `com.acme.resources` 及其所有子包以查找扩展 `Repository` 或其子接口之一的接口。对于找到的每个接口，基础结构都注册特定于持久性技术的 `FactoryBean`，以创建处理查询方法调用的适当代理。每个 bean 都注册在从接口名称派生的 bean 名称下，因此 `UserRepository` 的接口将注册在 `userRepository` 下。嵌套存储库接口的 Bean 名称以其封闭类型名称为前缀。基本包属性允许通配符，以便您可以定义扫描包的模式。

### 4.5.3 使用过滤器

默认情况下，基础结构会选择每个扩展位于配置的基本包下的持久性技术特定的 `Repository` 子接口的接口，并为其创建一个 bean 实例。但是，您可能需要对哪些接口创建了 bean 实例进行更细粒度的控制。为此，请在存储库声明中使用过滤器元素。语义完全等同于 Spring 组件过滤器中的元素。有关详细信息，请参阅这些元素的 Spring 参考文档。

例如，要将某些接口从实例化中排除为存储库 bean，可以使用以下配置：

```java
@Configuration
@EnableJpaRepositories(basePackages = "com.acme.repositories",
    includeFilters = { @Filter(type = FilterType.REGEX, pattern = ".*SomeRepository") },
    excludeFilters = { @Filter(type = FilterType.REGEX, pattern = ".*SomeOtherRepository") })
class ApplicationConfiguration {

  @Bean
  EntityManagerFactory entityManagerFactory() {
    // …
  }
}
```

前面的示例排除了以 `SomeRepository` 结尾的所有接口，而且包括以 `SomeOtherRepository` 结尾。

### 4.5.4 独立使用

您还可以在 Spring 容器之外使用存储库基础结构——例如在 CDI 环境中。在类路径中仍然需要一些 Spring 库，但通常，您也可以以编程方式设置存储库。提供存储库支持的 Spring Data 模块附带了一个持久性技术特定的 `RepositoryFactory`，您可以使用它，如下所示：

```java
RepositoryFactorySupport factory = … // Instantiate factory here
UserRepository repository = factory.getRepository(UserRepository.class);
```

## 4.6 Spring Data 存储库的自定义实现

Spring Data 提供了各种选项来创建代码少的查询方法。但当这些选项不符合您的需要时，您也可以为存储库方法提供自己的自定义实现。本节介绍如何做到这一点。

### 4.6.1 自定义独立存储库

要使用自定义功能让存储库功能更丰富，必须首先定义自定义功能的片段（fragment）接口和实现，如下所示：

```java
interface CustomizedUserRepository {
  void someCustomMethod(User user);
}
```

```java
class CustomizedUserRepositoryImpl implements CustomizedUserRepository {

  public void someCustomMethod(User user) {
    // Your custom implementation
  }
}
```

> 与片段接口对应的类名中最重要的部分是 `Impl` 后缀。

实现本身不依赖于 Spring Data，可以是一个普通的 Spring bean。因此，您可以使用标准依赖注入行为来注入对其他 bean（例如 `JdbcTemplate`）的引用，参与切面，等等。

然后，您可以让存储库接口扩展片段接口，如下所示：

```java
interface UserRepository extends CrudRepository<User, Long>, CustomizedUserRepository {

  // Declare query methods here
}
```

使用存储库接口扩展片段接口结合了 CRUD 和自定义功能，使其可供客户端使用。

Spring Data 存储库是通过使用组成存储库组合的片段来实现的。片段是基本存储库、功能切面（如 QueryDsl）和自定义接口及其实现。每次向存储库接口添加接口时，都会通过添加片段来增强组合。基础存储库和存储库切面的实现由每个 Spring Data 模块提供。

以下示例显示了自定义接口及其实现：

```java
interface HumanRepository {
  void someHumanMethod(User user);
}

class HumanRepositoryImpl implements HumanRepository {

  public void someHumanMethod(User user) {
    // Your custom implementation
  }
}

interface ContactRepository {

  void someContactMethod(User user);

  User anotherContactMethod(User user);
}

class ContactRepositoryImpl implements ContactRepository {

  public void someContactMethod(User user) {
    // Your custom implementation
  }

  public User anotherContactMethod(User user) {
    // Your custom implementation
  }
}
```

以下示例显示了扩展 `CrudRepository` 的自定义存储库的接口：

```java
interface UserRepository extends CrudRepository<User, Long>, HumanRepository, ContactRepository {

  // Declare query methods here
}
```

存储库可以由多个自定义实现组成，这些实现按照声明的顺序导入。自定义实现的优先级高于基本实现和存储库切面。这种排序允许您重写基本存储库和切面方法，并在两个片段提供相同的方法签名时解决歧义。存储库片段不限于在单个存储库接口中使用。多个存储库可以使用片段接口，允许您在不同的存储库中重用自定义项。

```java
interface CustomizedSave<T> {
  <S extends T> S save(S entity);
}

class CustomizedSaveImpl<T> implements CustomizedSave<T> {

  public <S extends T> S save(S entity) {
    // Your custom implementation
  }
}
```

以下示例显示了使用前面存储库片段的存储库：

```java
interface UserRepository extends CrudRepository<User, Long>, CustomizedSave<User> {
}

interface PersonRepository extends CrudRepository<Person, Long>, CustomizedSave<Person> {
}
```

#### 配置

存储库基础设施尝试通过扫描它找到存储库的包下的类来自动检测自定义实现片段。这些类需要遵循添加默认后缀 `Impl` 的命名规范。

下面的例子展示了一个使用默认后缀的存储库和一个设置自定义后缀值的存储库：

```java
@EnableJpaRepositories(repositoryImplementationPostfix = "MyPostfix")
class Configuration { … }
```

前一个示例中的第一个配置尝试查找一个名为 `com.acme.repository.CustomizedUserRepositoryImpl` 的类，以充当自定义存储库实现。第二个示例尝试查找 `com.acme.restory.CustomizedUserRepositoryMyPostfix`。

##### 模糊性的解决

如果在不同的包中找到多个具有匹配类名的实现，Spring Data 将使用 bean 名称来确定要使用哪个。

假定前面展示的 `CustomizedUserRepository` 有以下两个自定义实现，将使用第一个实现。它的 bean 名称是 `customizedUserRepositoryImpl`，它与片段接口（`CustomizedUserRepository`）加上后缀 `Impl` 的名称相匹配。

```java
package com.acme.impl.one;

class CustomizedUserRepositoryImpl implements CustomizedUserRepository {

  // Your custom implementation
}
```

```java
package com.acme.impl.two;

@Component("specialCustomImpl")
class CustomizedUserRepositoryImpl implements CustomizedUserRepository {

  // Your custom implementation
}
```

如果您使用 `@Component(“specialCustom”)` 注解 `UserRepository` 接口，那么 bean 名称加上 `Impl` 将与 `com.acme.Impl.two` 中为存储库实现定义的名称相匹配，并使用它来代替第一个。

##### 手动匹配

如果您的自定义实现仅使用基于注解的配置和自动匹配，则前面所示的方法效果很好，因为它被视为任何其他 Spring bean。如果您的实现片段 bean 需要特殊的匹配，您可以声明 bean 并根据前面一节中描述的约定对其进行命名。然后，基础结构通过名称引用手动定义的 bean 定义，而不是自己创建。以下示例显示了如何手动匹配自定义实现：

```java
class MyClass {
  MyClass(@Qualifier("userRepositoryImpl") UserRepository userRepository) {
    …
  }
}
```

### 4.6.2 自定义基本存储库

当您想要定制基本存储库行为以使所有存储库都受到影响时，上一节中描述的方法需要定制每个存储库接口。为了改变所有存储库的行为，您可以创建一个扩展特定于持久性技术存储库基类的实现。然后，该类充当给存储库代理使用的自定义基类，如下例所示：

```java
class MyRepositoryImpl<T, ID>
  extends SimpleJpaRepository<T, ID> {

  private final EntityManager entityManager;

  MyRepositoryImpl(JpaEntityInformation entityInformation,
                          EntityManager entityManager) {
    super(entityInformation, entityManager);

    // Keep the EntityManager around to used from the newly introduced methods.
    this.entityManager = entityManager;
  }

  @Transactional
  public <S extends T> S save(S entity) {
    // implementation goes here
  }
}
```

> 该类需要有一个特定于存储的存储库工厂实现所使用的超类的构造函数。如果存储库基类有多个构造函数，请重写采用 `EntityInformation` 加上特定于存储的基础结构对象（例如 `EntityManager` 或模板类）的构造函数。

最后一步是让 Spring Data 基础设施知道定制的存储库基类。在配置中，可以通过使用 `repositoryBaseClass` 来执行此操作，如下例所示：

```java
@Configuration
@EnableJpaRepositories(repositoryBaseClass = MyRepositoryImpl.class)
class ApplicationConfiguration { … }
```

## 4.7 从聚合根发布事件

由存储库管理的实体是聚合根。在域驱动设计应用程序中，这些聚合根通常发布域事件。Spring Data 提供了一个名为 `@DomainEvents` 的注释，您可以在聚合根的方法上使用该注释，以使发布尽可能简单，如下例所示：

```java
class AnAggregateRoot {

    @DomainEvents (1)
    Collection<Object> domainEvents() {
        // … return events you want to get published here
    }

    @AfterDomainEventPublication (2)
    void callbackMethod() {
       // … potentially clean up domain events list
    }
}

// (1) 使用 `@DomainEvents` 的方法可以返回单个事件实例或事件集合。它不能有任何参数。
// (2) 发布所有事件后，我们有一个用 `@AfterDomainEventPublication` 注解的方法。您可以使用它清除要发布的事件列表（以及其他用途）。
```

每次调用 Spring Data 存储库的 `save(…)`、`saveAll(…)` 或 `delete(…)` 方法之一时，都会调用这些方法。

## 4.8 Spring Data 扩展

本节介绍了一组 Spring Data 扩展，这些扩展支持在各种上下文中使用 Spring Data。目前，大多数集成都针对 SpringMVC。

### 4.8.1 Querydsl 扩展

Querydsl 是一个框架，可以通过其流式 API 构建静态类型的类似 SQL 的查询。

几个 Spring Data 模块通过 `QuerydslPredicateExecutor` 提供与 Querydsl 的集成，如下例所示：

```java
public interface QuerydslPredicateExecutor<T> {

  Optional<T> findById(Predicate predicate);  (1)

  Iterable<T> findAll(Predicate predicate);   (2)

  long count(Predicate predicate);            (3)

  boolean exists(Predicate predicate);        (4)

  // … more functionality omitted.
}

// (1) 查找并返回与 `Predicate` 匹配的单个实体。
// (2) 查找并返回与 `Predicate` 匹配的所有实体。
// (3) 返回与 `Predicate` 匹配的实体数。
// (4) 返回是否存在与 `Predicate` 匹配的实体。
```

要使用 Querydsl 支持，请在存储库接口上扩展 `QuerydslPredicateExecutor`，如下例所示：

```java
interface UserRepository extends CrudRepository<User, Long>, QuerydslPredicateExecutor<User> {
}
```

前面的示例允许您使用 Querydsl `Predicate` 实例编写类型安全查询，如下例所示：

```java
Predicate predicate = user.firstname.equalsIgnoreCase("dave")
	.and(user.lastname.startsWithIgnoreCase("mathews"));

userRepository.findAll(predicate);
```

### 4.8.2 Web 支持

支持存储库编程模型的 Spring Data 模块附带各种 web 支持。web 相关组件要求 Spring MVC JAR 位于 classpath 中。其中一些甚至提供了与 Spring HATEOAS 的集成。通常，通过在 JavaConfig 配置类中使用 `@EnableSpringDataWebSupport` 注释来启用集成支持，如下例所示：

```java
@Configuration
@EnableWebMvc
@EnableSpringDataWebSupport
class WebConfiguration {}
```

`@EnableSpringDataWebSupport` 注解注册了一些组件。我们将在本节稍后讨论这些问题。它还检测类路径上的 Spring HATEOAS，并为其注册集成组件（如果存在）。

#### 基本 Web 支持

上一节中显示的配置注册了一些基本组件：

- 一个使用 `DomainClassConverter` 类让 Spring MVC 从请求参数或路径变量解析存储库管理的域类的实例。
- `HandlerMethodArgumentResolver` 的实现，让 Spring MVC 从请求参数解析 `Pageable` 和 `Sort` 实例。
- Jackson 模块可以对 `Point` 和 `Distance` 等类型进行序列化和反序列化或存储特定类型，具体取决于所使用的 Spring 数据模块。

##### 使用 DomainClassConverter 类

`DomainClassConverter` 类允许您直接在 Spring MVC 控制器方法签名中使用域类型，因此您不需要通过存储库手动查找实例，如下例所示：

```java
@Controller
@RequestMapping("/users")
class UserController {

  @RequestMapping("/{id}")
  String showUserForm(@PathVariable("id") User user, Model model) {

    model.addAttribute("user", user);
    return "userForm";
  }
}
```

该方法直接接收 `User` 实例，无需进一步查找。该实例可以通过让 Spring MVC 首先将路径变量转换为域类的 id 类型，然后通过调用为域类型注册的存储库实例上的 `findById(…)` 来最终访问该实例来解决。

> 目前，存储库必须实现 `CrudRepository` 才能被发现以进行转换。

##### Pageable 和 Sort 的 HandlerMethodArgumentResolvers

上一节中显示的配置片段还注册了 `PageableHandlerMethodArgumentResolver` 以及 `SortHandlerMethodargumentResolve` 的实例。这些注册启用了 `Pageable` 和 `Sort` 作为有效的控制器方法参数，如下例所示：

```java
@Controller
@RequestMapping("/users")
class UserController {

  private final UserRepository repository;

  UserController(UserRepository repository) {
    this.repository = repository;
  }

  @RequestMapping
  String showUsers(Model model, Pageable pageable) {

    model.addAttribute("users", repository.findAll(pageable));
    return "users";
  }
}
```

前面的方法签名导致 Spring MVC 尝试使用以下默认配置从请求参数派生 `Pageable` 实例：

|        |                                                              |
| ------ | ------------------------------------------------------------ |
| `page` | 你想要获取的页。索引从 0 开始且默认为 0。                    |
| `size` | 你想要获取的页面尺寸。默认为 20。                            |
| `sort` | 需要排序的属性，格式为 `property,property(,ASC|DESC)(,IgnoreCase)`。默认排序方向是大小写敏感的升序。如果你想要切换方向或大小写敏感，可以使用多个 `sort` 参数，例如， `?sort=firstname&sort=lastname,asc&sort=city,ignorecase`. |

要自定义此行为，请分别注册一个实现 `PageableHandlerMethodArgumentResolverCustomizer` 接口或 `SortHandlerMethodargumentResolveCustomizer` 接口的 bean。它的 `customize()` 方法被调用，允许您更改设置，如下例所示：

```java
@Bean SortHandlerMethodArgumentResolverCustomizer sortCustomizer() {
    return s -> s.setPropertyDelimiter("<-->");
}
```

如果设置现有 `MethodArgumentResolver` 的属性不足以满足您的需要，请扩展 `SpringDataWebConfiguration` 或启用 HATEOAS 的等效方法，重写 `pageableResolver()` 或 `sortResolver()` 方法，并导入自定义配置文件，而不是使用 `@Enable` 注解。

如果需要从请求中解析多个 `Pageable` 或 `Sort` 实例（例如，对于多个表），可以使用 Spring 的 `@Qualifier` 注解来区分它们。然后，请求参数必须以 `${qualifier}_` 作为前缀。以下示例显示了生成的方法签名：

```java
String showUsers(Model model,
      @Qualifier("thing1") Pageable first,
      @Qualifier("thing2") Pageable second) { … }
```

您必须填充 `thing1_page`、`thing2_page` 等。

传递到方法中的默认 `Pageable` 相当于 `PageRequest.of(0，20)`，但您可以通过在 `Pageable` 参数上使用 `@PageableDefault` 注解来自定义它。

#### 对 Pageable 的超媒体支持

Spring HATEOAS 附带了一个表示模型类（`PagedResources`），该类允许使用必要的 `Page` 元数据以及链接来丰富 `Page` 实例的内容，从而让客户端轻松浏览页面。`Page` 到 `PagedResources` 的转换是通过 Spring HATEOAS `ResourceAssembler` 接口的实现完成的，该接口称为 `PagedResosourcesAssembler`。以下示例显示如何将 `PagedResourcesAssembler` 用作控制器方法参数：

```java
@Controller
class PersonController {

  @Autowired PersonRepository repository;

  @RequestMapping(value = "/persons", method = RequestMethod.GET)
  HttpEntity<PagedResources<Person>> persons(Pageable pageable,
    PagedResourcesAssembler assembler) {

    Page<Person> persons = repository.findAll(pageable);
    return new ResponseEntity<>(assembler.toResources(persons), HttpStatus.OK);
  }
}
```

如前一个示例所示，启用该配置可以将 `PagedResourcesAssembler` 用作控制器方法参数。对其调用 `toResources(…)` 具有以下效果：

- `Page` 的内容成为 `PagedResources` 实例的内容。
- `PagedResources` 对象获取附加的 `PageMetadata` 实例，并使用来自 `Page` 和底层 `PageRequest` 的信息填充该实例。
- `PagedResources` 可能会附加 `prev` 和 `next` 链接，具体取决于页面的状态。链接指向方法映射到的 URI。添加到方法中的分页参数与 `PageableHandlerMethodArgumentResolver` 的设置相匹配，以确保以后可以解析链接。

假设数据库中有 30 个 `Person` 实例。您现在可以触发请求（`GET http://localhost:8080/persons`)并看到类似于以下内容的输出：

```json
{ "links" : [ { "rel" : "next",
                "href" : "http://localhost:8080/persons?page=1&size=20" }
  ],
  "content" : [
     … // 20 Person instances rendered here
  ],
  "pageMetadata" : {
    "size" : 20,
    "totalElements" : 30,
    "totalPages" : 2,
    "number" : 0
  }
}
```

汇编器生成了正确的 URI，并选择了默认配置，以将参数解析为即将到来的请求的 `Pageable`。这意味着，如果您更改了配置，链接将自动遵守更改。默认情况下，汇编器指向在其中调用的控制器方法，但您可以通过传递自定义 `Link` 来自定义该方法，该链接将用作构建分页链接的基础，从而重载 `PagedResourcesAssembler.toResource(…)` 方法。

#### Spring Data Jackson 模块

核心模块和一些特定于存储的模块附带一组 Jackson 模块，用于 Spring Data 域使用的类型，如 `org.springframework.data.geo.Distance` 和 `org.springfframework.data.geo.Point`。一旦启用了 web 支持，并且 `com.fasterxml.jackson.databind.ObjectMapper` 可用，就会导入这些模块。

在初始化过程中，`SpringDataJacksonModules`（如 `SpringDataJacksonConfiguration`）会被基础结构获取，因此声明的 `com.fasterxml.jackson.databind.Modules` 可用于 jackson `ObjectMapper`。

以下域类型的数据绑定混合由公共基础结构注册。

```
org.springframework.data.geo.Distance
org.springframework.data.geo.Point
org.springframework.data.geo.Box
org.springframework.data.geo.Circle
org.springframework.data.geo.Polygon
```

> 单个模块可以提供额外的 `SpringDataJacksonModules`。
>
> 有关详细信息，请参阅存储特定部分。

#### Web 数据绑定支持

通过使用 JSONPath 表达式（需要 Jayway JSONPath）或 XPath 表达式（需要 XmlBeam），可以使用 Spring Data 投影（在 projections 中描述）绑定传入的请求负载，如下例所示：

```java
@ProjectedPayload
public interface UserPayload {

  @XBRead("//firstname")
  @JsonPath("$..firstname")
  String getFirstname();

  @XBRead("/lastname")
  @JsonPath({ "$.lastname", "$.user.lastname" })
  String getLastname();
}
```

您可以将上一个示例中显示的类型用作 Spring MVC 处理程序方法参数，或者在 `RestTemplate` 的一个方法上使用 `ParameterizedTypeReference`。前面的方法声明将尝试在给定文档中的任何位置查找 `firstname`。`lastname` XML 查找是在传入文档的顶层执行的。JSON 变体首先尝试顶级 `lastname`，但如果前者没有返回值，则也尝试 `user` 子文档中嵌套的 `lastname`。这样，可以很容易地减轻源文档结构的更改，而无需客户端调用公开的方法（通常是基于类的负载绑定的缺点）。

嵌套投射受支持，如“投射”中所述。如果该方法返回复杂的非接口类型，则使用Jackson `ObjectMapper` 映射最终值。

对于 Spring MVC，只要 `@EnableSpringDataWebSupport` 处于活动状态，并且所需的依赖项在类路径上可用，就自动注册必要的转换器。要使用 `RestTemplate`，请手动注册 `ProjectingJackson2HttpMessageConverter`（JSON）或 `XmlBeamHttpMessageConverter`。

有关更多信息，请参阅规范的 Spring Data Examples 库中的web投射示例。

#### Querydsl Web 支持

对于那些集成了 QueryDSL 的存储，您可以从请求查询字符串中包含的属性派生查询。

考虑以下查询字符串：

```java
?firstname=Dave&lastname=Matthews
```

给定前面示例中的 `User` 对象，可以使用 `QuerydslPredicateArgumentResolver` 将查询字符串解析为以下值，如下所示：

```java
QUser.user.firstname.eq("Dave").and(QUser.user.lastname.eq("Matthews"))
```

> 当在类路径上找到 Querydsl 时，该功能会自动启用，同时还会启用 `@EnableSpringDataWebSupport`。

向方法签名中添加 `@QuerydslPredicate` 提供了一个随时可用的 `Predicate`，您可以使用 `QuerydslPredicateExecutor` 来运行它。

> 类型信息通常从方法的返回类型解析。由于该信息不一定与域类型匹配，因此使用 `QuerydslPredicate` 的根属性可能是一个好主意。

以下示例显示了如何在方法签名中使用 `@QuerydslPredicate`：

```java
@Controller
class UserController {

  @Autowired UserRepository repository;

  @RequestMapping(value = "/", method = RequestMethod.GET)
  String index(Model model, @QuerydslPredicate(root = User.class) Predicate predicate,    (1)
          Pageable pageable, @RequestParam MultiValueMap<String, String> parameters) {

    model.addAttribute("users", repository.findAll(predicate, pageable));

    return "index";
  }
}

// (1) 解析查询字符串参数来为 `User` 匹配 `Predicate`
```

默认绑定如下：

- 简单属性上的 `Object`，例如 `eq`。
- 集合类属性上的 `Object`，例如 `contains`。
- 简单属性的 `Collection`，例如 `in`。

您可以通过 `@QuerydslPredicate` 的 `bindings` 属性或通过使用 Java 8 `default methods` 并将 `QuerydslBinderCustomizer` 方法添加到存储库接口来自定义这些绑定，如下所示：

```java
interface UserRepository extends CrudRepository<User, String>,
                                 QuerydslPredicateExecutor<User>,                (1)
                                 QuerydslBinderCustomizer<QUser> {               (2)

  @Override
  default void customize(QuerydslBindings bindings, QUser user) {

    bindings.bind(user.username).first((path, value) -> path.contains(value))    (3)
    bindings.bind(String.class)
      .first((StringPath path, String value) -> path.containsIgnoreCase(value)); (4)
    bindings.excluding(user.password);                                           (5)
  }
}

// (1) `QuerydslPredicateExecutor` 提供对 `Predicate` 特定查找器方法的访问。
// (2) 在存储库接口上定义的 `QuerydslBinderCustomizer` 将被自动拾取，以及快捷方式 `@QuerydslPredicate(bindings=…)`.
// (3) 将 `username` 属性的绑定定义为简单的 `contains` 绑定。
// (4) 将 `String` 属性的默认绑定定义为不区分大小写的 `contains` 匹配。
// (5) 从 `Predicate` 解析中排除 `password` 属性。
```

在从存储库或 `@QuerydslPredicate` 应用特定绑定之前，您可以注册保存默认 Querydsl 绑定的 `QuerydslBinderCustomizerDefaults` bean。

### 4.8.3 存储库填充器

如果您使用 Spring JDBC 模块，您可能熟悉使用 SQL 脚本填充 `DataSource` 的支持。在存储库级别也有类似的抽象，尽管它不使用 SQL 作为数据定义语言，因为它必须独立于存储。因此，填充器支持 XML（通过 Spring 的 OXM 抽象）和 JSON（通过 Jackson）来定义用于填充存储库的数据。

假设您有一个名为 `data.json` 的文件，其内容如下：

```json
[ { "_class" : "com.acme.Person",
 "firstname" : "Dave",
  "lastname" : "Matthews" },
  { "_class" : "com.acme.Person",
 "firstname" : "Carter",
  "lastname" : "Beauford" } ]
```

您可以使用 Spring Data Commons 中提供的存储库名称空间的 populator 元素来填充存储库。要将前面的数据填充到 `PersonRepository`，请声明一个类似于以下内容的填充器：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:repository="http://www.springframework.org/schema/data/repository"
  xsi:schemaLocation="http://www.springframework.org/schema/beans
    https://www.springframework.org/schema/beans/spring-beans.xsd
    http://www.springframework.org/schema/data/repository
    https://www.springframework.org/schema/data/repository/spring-repository.xsd">

  <repository:jackson2-populator locations="classpath:data.json" />

</beans>
```

前面的声明导致 Jackson `ObjectMapper` 读取和反序列化 `data.json` 文件。

通过检查 JSON 文档的 `_class` 属性来确定 JSON 对象的解组类型。基础结构最终选择适当的存储库来处理反序列化的对象。

要使用 XML 来定义存储库应该填充的数据，可以使用 `unmarshaller-populator` 元素。您可以将其配置为使用 Spring OXM 中可用的 XML 编组器选项之一。有关详细信息，请参阅 Spring 参考文档。以下示例显示了如何使用 JAXB 解组存储库填充器：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:repository="http://www.springframework.org/schema/data/repository"
  xmlns:oxm="http://www.springframework.org/schema/oxm"
  xsi:schemaLocation="http://www.springframework.org/schema/beans
    https://www.springframework.org/schema/beans/spring-beans.xsd
    http://www.springframework.org/schema/data/repository
    https://www.springframework.org/schema/data/repository/spring-repository.xsd
    http://www.springframework.org/schema/oxm
    https://www.springframework.org/schema/oxm/spring-oxm.xsd">

  <repository:unmarshaller-populator locations="classpath:data.json"
    unmarshaller-ref="unmarshaller" />

  <oxm:jaxb2-marshaller contextPath="com.acme" />

</beans>
```

# 5 参考文档

## 5.1 JPA 存储库

本章指出了 JPA 存储库支持的特殊性。这建立在“使用 Spring Data 存储库”中解释的核心存储库支持之上。确保您对那里解释的基本概念有充分的理解。

### 5.1.1 导论

本节介绍通过以下任一方式配置 Spring Data JPA 的基础知识：

- “Spring 命名空间”（XML 配置）
- “基于注解的配置”（Java 配置）

#### 基于注解的配置

Spring Data JPA 存储库支持可以通过 JavaConfig 和一个自定义 XML 命名空间来激活，就像下面例子所示：

```java
@Configuration
@EnableJpaRepositories
@EnableTransactionManagement
class ApplicationConfig {

  @Bean
  public DataSource dataSource() {

    EmbeddedDatabaseBuilder builder = new EmbeddedDatabaseBuilder();
    return builder.setType(EmbeddedDatabaseType.HSQL).build();
  }

  @Bean
  public LocalContainerEntityManagerFactoryBean entityManagerFactory() {

    HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
    vendorAdapter.setGenerateDdl(true);

    LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();
    factory.setJpaVendorAdapter(vendorAdapter);
    factory.setPackagesToScan("com.acme.domain");
    factory.setDataSource(dataSource());
    return factory;
  }

  @Bean
  public PlatformTransactionManager transactionManager(EntityManagerFactory entityManagerFactory) {

    JpaTransactionManager txManager = new JpaTransactionManager();
    txManager.setEntityManagerFactory(entityManagerFactory);
    return txManager;
  }
}
```

> 您必须直接创建 `LocalContainerEntityManagerFactoryBean` 而不是 `EntityManagerFactory`，因为前者除了创建 `EntityManagerFactory` 之外，还参与异常转换机制。

前面的配置类通过使用 `spring-jdbc` 的 `EmbeddedDatabaseBuilder` API 来设置嵌入式 HSQL 数据库。然后 Spring Data 设置 `EntityManagerFactory`，并使用 Hibernate 作为示例持久性提供程序。这里声明的最后一个基础结构组件是 `JpaTransactionManager`。最后，该示例通过使用 `@EnableJpaRepositorys` 注解激活 Spring Data JPA 存储库，该注解本质上具有与 XML 名称空间相同的属性。如果未配置基本包，则使用配置类所在的包。

#### Spring 命名空间

Spring Data 的 JPA 模块包含一个自定义命名空间，允许定义存储库 bean。它还包含 JPA 特有的某些特性和元素属性。通常，可以使用 `repositories` 元素设置 JPA 存储库，如下例所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:jpa="http://www.springframework.org/schema/data/jpa"
  xsi:schemaLocation="http://www.springframework.org/schema/beans
    https://www.springframework.org/schema/beans/spring-beans.xsd
    http://www.springframework.org/schema/data/jpa
    https://www.springframework.org/schema/data/jpa/spring-jpa.xsd">

  <jpa:repositories base-package="com.acme.repositories" />

</beans>
```

> JavaConfig 和 XML 哪个更好？XML 是很久以前 Spring 的配置方式。在当今Java、记录类型、注解等快速增长的时代，新项目通常使用尽可能多的纯Java。虽然目前还没有删除 XML 支持的计划，但一些最新功能可能无法通过 XML 获得。

使用 `repositories` 元素查找 Spring Data 存储库，如“创建存储库实例”中所述。除此之外，它还为所有用 `@Repository` 注解的 bean 激活持久性异常转换，以将 JPA 持久性提供程序抛出的异常转换为 Spring 的 `DataAccessException` 层次结构。

##### 自定义命名空间属性

除了 `repositories` 元素的默认属性之外，JPA 名称空间还提供了其他属性，让您可以更详细地控制存储库的设置：

|                              |                                                              |
| ---------------------------- | ------------------------------------------------------------ |
| `entity-manager-factory-ref` | 显式连接 `EntityManagerFactory`，以便与 `repositories` 元素检测到的存储库一起使用。通常在应用程序中使用多个 `EntityManagerFactory` bean 时使用。如果未配置，Spring Data 会自动在 `ApplicationContext` 中查找名为 `entityManagerFactory` 的 `EntityManagerFactory` bean。 |
| `transaction-manager-ref`    | 显式连接 `PlatformTransactionManager` 以与 `repositories` 元素检测到的存储库一起使用。通常只有在配置了多个事务管理器或 `EntityManagerFactory` bean 时才需要。默认为当前 `ApplicationContext` 中单个定义的 `PlatformTransactionManager`。 |

> 如果未定义显式 `transaction-manager-ref`，Spring Data JPA 要求存在名为 `transactionManager` 的 `PlatformTransactionManager` bean。

#### 引导（Bootstrap）模式

默认情况下，Spring Data JPA 存储库是默认的 Spring bean。它们是单例作用域的，并且被热切地初始化。在启动期间，它们已经与 JPA `EntityManager` 进行了交互，用于验证和元数据分析。Spring Framework 支持在后台线程中初始化 JPA `EntityManagerFactory`，因为该过程通常会占用 Spring 应用程序中大量的启动时间。为了有效地利用后台初始化，我们需要确保尽可能晚地初始化 JPA 存储库。

从 Spring Data JPA 2.1 开始，您现在可以配置 `BootstrapMode`（通过 `@EnableJpaRepositorys` 注解或 XML 命名空间），该模式采用以下值：

- `DEFAULT`（默认） — 除非用 `@Lazy` 明确注解，否则存储库会被实例化。只有当没有客户端 bean 需要存储库实例时（因为这需要初始化存储库 bean），延迟化才有效。
- `LAZY` — 隐式地将所有存储库 bean 声明为 lazy，并将创建的懒初始化代理注入到客户端 bean 中。这意味着，如果客户端 bean 只是将实例存储在字段中，而在初始化期间不使用存储库，那么存储库将不会被实例化。存储库实例将在首次与存储库交互时进行初始化和验证。
- `DEFERRED` — 基本上与 `LAZY` 的操作模式相同，但会响应 `ContextRefreshedEvent` 触发存储库初始化，以便在应用程序完全启动之前验证存储库。

##### 建议

如果您没有使用异步 JPA 引导，请使用默认的引导模式。

在异步引导 JPA 的情况下，`DEFERRED` 是一个合理的默认值，因为它将确保 Spring Data JPA 引导仅等待 `EntityManagerFactory` 设置，如果这本身比初始化所有其他应用程序组件花费的时间更长。尽管如此，它确保在应用程序发出启动信号之前正确初始化和验证了存储库。

`LAZY` 是测试场景和本地开发的理想选择。一旦您非常确定存储库可以正确引导，或者在测试应用程序其他部分的情况下，对所有存储库运行验证可能会不必要地增加启动时间。这同样适用于本地开发，在本地开发中，您只访问可能需要初始化单个存储库的应用程序部分。

### 5.1.2 持久化实体

这一节描述了如何使用 Spring Data JPA 持久化（保存）实体。

#### 保存实体

可以使用 `CrudRepository.save(…)` 方法保存实体。它使用底层 JPA `EntityManager` 持久化或合并给定实体。如果实体尚未持久化，Spring Data JPA 将通过调用 `entityManager.persist(…)` 方法保存实体。否则，它将调用 `entityManager.merge(…)` 方法。

##### 实体状态检测策略

Spring Data JPA 提供以下策略来检测实体是否为新实体：

- Version-Property 和 Id-Property 检查（默认）：默认情况下，Spring Data JPA 首先检查是否存在非基本类型的版本属性。如果存在，则如果该属性的值为 `null`，则该实体被视为新实体。如果没有这样的版本属性，Spring Data JPA 将检查给定实体的标识符属性。如果标识符属性为 `null`，则假定该实体是新的。否则，假设它不是新的。
- 实现 `Persistable`：如果实体实现 `Persistable`，Spring Data JPA 将新的检测委托给实体的 `isNew(…)` 方法。有关详细信息，请参阅 JavaDoc。
- 实现 `EntityInformation`：通过创建 `JpaRepositoryFactory` 的子类并相应地重写 `getEntityInformation(…)` 方法，可以自定义 `SimpleJpaRepository` 实现中使用的 `EntityInformation` 抽象。然后，您必须将 `JpaRepositoryFactory` 的自定义实现注册为 Spring bean。请注意，这应该很少必要。有关详细信息，请参阅 JavaDoc。

对于使用手动分配的标识符且没有版本属性的实体，选项1不是一个选择，因为标识符将始终为非 `null`。该场景中的一种常见模式是使用一个公共基类，该基类带有一个临时标志，默认情况下指示一个新实例，并使用 JPA 生命周期回调在持久性操作上翻转该标志：

```java
@MappedSuperclass
public abstract class AbstractEntity<ID> implements Persistable<ID> {

  @Transient
  private boolean isNew = true; (1)

  @Override
  public boolean isNew() {
    return isNew; (2)
  }

  @PrePersist (3)
  @PostLoad
  void markNotNew() {
    this.isNew = false;
  }

  // More code…
}

// (1) 声明一个标志以保持新状态。暂时的，所以它不会持久化到数据库中。
// (2) 返回 `Persistable.isNew()` 实现中的标志，以便 Spring 数据存储库知道是调用 `EntityManager.persist()` 还是 `….merge()`。
// (3) 使用 JPA 实体回调声明一个方法，以便在存储库调用save（…）或持久性提供程序创建实例后切换标志以指示现有实体。
```

### 5.1.3 查询方法

这一节描述了通过 Spring Data JPA 创建查询的不同方式。

#### 查询查找策略

JPA 模块支持将查询手动定义为字符串或从方法名派生。

带有谓词 `IsStartingWith`, `StartingWith`, `StartsWith`, `IsEndingWith`, `EndingWith`, `EndsWith`，`IsNotContaining`, `NotContained`, `NotContain`, `IsContaining`, `Containing`, `Contains` 的派生查询的相应参数将被清除。这意味着，如果参数实际上包含 `LIKE` 识别为通配符的字符，这些字符将被转义，以便它们仅作为文本匹配。可以通过设置 `@EnableJpaRepositorys` 注解的 `escapeCharacter` 来配置使用的转义符。可以与使用SpEL表达式进行比较。

##### 声明查询

虽然从方法名派生的查询非常方便，但可能会遇到这样的情况：方法名解析器不支持要使用的关键字，或者方法名会变得不必要地难看。因此，您可以通过命名约定使用 JPA 命名查询（有关详细信息，请参阅使用 JPA 名称查询），也可以使用`@Query` 注解查询方法（有关详细内容，请参见使用 `@Query`）。

#### 创建查询

通常，JPA 的查询创建机制如“查询方法”中所述。下面的示例显示了 JPA 查询方法转换成什么：

```java
public interface UserRepository extends Repository<User, Long> {

  List<User> findByEmailAddressAndLastname(String emailAddress, String lastname);
}
```

我们从中使用 JPA 标准 API 创建一个查询，但本质上，这转化为以下查询：`select u from User u where u.emailAddress = ?1 and u.lastname = ?2`。Spring Data JPA 执行属性检查并遍历嵌套属性，如“属性表达式”中所述。

下表描述了 JPA 支持的关键字以及包含该关键字的方法翻译成什么：

| 关键字                 | 示例                                                         | JPQL 片段                                                    |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `Distinct`             | `findDistinctByLastnameAndFirstname`                         | `select distinct … where x.lastname = ?1 and x.firstname = ?2` |
| `And`                  | `findByLastnameAndFirstname`                                 | `… where x.lastname = ?1 and x.firstname = ?2`               |
| `Or`                   | `findByLastnameOrFirstname`                                  | `… where x.lastname = ?1 or x.firstname = ?2`                |
| `Is`, `Equals`         | `findByFirstname`,`findByFirstnameIs`,`findByFirstnameEquals` | `… where x.firstname = ?1`                                   |
| `Between`              | `findByStartDateBetween`                                     | `… where x.startDate between ?1 and ?2`                      |
| `LessThan`             | `findByAgeLessThan`                                          | `… where x.age < ?1`                                         |
| `LessThanEqual`        | `findByAgeLessThanEqual`                                     | `… where x.age <= ?1`                                        |
| `GreaterThan`          | `findByAgeGreaterThan`                                       | `… where x.age > ?1`                                         |
| `GreaterThanEqual`     | `findByAgeGreaterThanEqual`                                  | `… where x.age >= ?1`                                        |
| `After`                | `findByStartDateAfter`                                       | `… where x.startDate > ?1`                                   |
| `Before`               | `findByStartDateBefore`                                      | `… where x.startDate < ?1`                                   |
| `IsNull`, `Null`       | `findByAge(Is)Null`                                          | `… where x.age is null`                                      |
| `IsNotNull`, `NotNull` | `findByAge(Is)NotNull`                                       | `… where x.age not null`                                     |
| `Like`                 | `findByFirstnameLike`                                        | `… where x.firstname like ?1`                                |
| `NotLike`              | `findByFirstnameNotLike`                                     | `… where x.firstname not like ?1`                            |
| `StartingWith`         | `findByFirstnameStartingWith`                                | `… where x.firstname like ?1` (parameter bound with appended `%`) |
| `EndingWith`           | `findByFirstnameEndingWith`                                  | `… where x.firstname like ?1` (parameter bound with prepended `%`) |
| `Containing`           | `findByFirstnameContaining`                                  | `… where x.firstname like ?1` (parameter bound wrapped in `%`) |
| `OrderBy`              | `findByAgeOrderByLastnameDesc`                               | `… where x.age = ?1 order by x.lastname desc`                |
| `Not`                  | `findByLastnameNot`                                          | `… where x.lastname <> ?1`                                   |
| `In`                   | `findByAgeIn(Collection<Age> ages)`                          | `… where x.age in ?1`                                        |
| `NotIn`                | `findByAgeNotIn(Collection<Age> ages)`                       | `… where x.age not in ?1`                                    |
| `True`                 | `findByActiveTrue()`                                         | `… where x.active = true`                                    |
| `False`                | `findByActiveFalse()`                                        | `… where x.active = false`                                   |
| `IgnoreCase`           | `findByFirstnameIgnoreCase`                                  | `… where UPPER(x.firstname) = UPPER(?1)`                     |

> `In` 和 `NotIn` 还将 `Collection` 的任何子类以及数组或 varargs 作为参数。对于同一逻辑运算符的其他语法版本，请查看“存储库查询关键字”。

> `DISTINCT` 可能很棘手，并不总是产生您期望的结果。例如，`select distinct u from User u` 将产生与 `select distinct u.lastname from User u` 完全不同的结果。
>
> 然而，后一个查询将焦点缩小到仅 `User.lastname`，并查找该表的所有唯一姓氏。这还将生成一个 `List<String>` 结果集，而不是 `List<User>` 结果集。
>
> `countDistinctByLastname(String lastname)` 也可能产生意外的结果。Spring Data JPA 将推导出 `select count(distinct u.id) from User u where u.lastname = ?1`。同样，由于 `u.id` 不会命中任何重复项，因此该查询将对具有绑定姓氏的所有用户进行计数。这将与 `countByLastname(String lastname)` 相同！
>
> 无论如何，这个查询的意义是什么？查找具有给定姓氏的人数？查找具有该绑定姓氏的不同人员的数量？要查找不同姓氏的数量？（最后一个是完全不同的查询！）使用 `distinct` 有时需要手动编写查询，并使用 `@Query` 来最佳地捕获所需的信息，因为您可能还需要投射来捕获结果集。

##### 基于注解的配置

基于注解的配置的优点是不需要编辑另一个配置文件，从而降低了维护工作量。您需要为每一个新的查询声明重新编译域类，从而获得这一好处。

```java
@Entity
@NamedQuery(name = "User.findByEmailAddress",
  query = "select u from User u where u.emailAddress = ?1")
public class User {

}
```

#### 使用 JPA 命名查询

> 示例使用 `<NamedQuery/>` 元素和 `@NamedQuery` 注解。这些配置元素的查询必须用 JPA 查询语言来定义。当然，您也可以使用 `<named-native-query/>` 或 `@NamedNativeQuery`。这些元素使您可以通过失去数据库平台独立性来在本机 SQL 中定义查询。

##### XML 命名的查询定义

要使用 XML 配置，请将必需的 `<named-query/>` 元素添加到位于类路径 `META-INF` 文件夹中的 `orm.xml` JPA 配置文件中。通过使用某些定义的命名约定，可以自动调用命名查询。有关详细信息，请参阅下文。

```xml
<named-query name="User.findByLastname">
  <query>select u from User u where u.lastname = ?1</query>
</named-query>
```

查询有一个特殊的名称，用于在运行时解析它。

##### 声明接口

要允许这些命名查询，请按如下方式指定 `UserRepositoryWithRewriter`：

```java
public interface UserRepository extends JpaRepository<User, Long> {

  List<User> findByLastname(String lastname);

  User findByEmailAddress(String emailAddress);
}
```

Spring Data 尝试将对这些方法的调用解析为命名查询，从配置的域类的简单名称开始，然后是用点分隔的方法名称。因此，前面的示例将使用前面定义的命名查询，而不是尝试从方法名称创建查询。

#### 使用 @Query

使用命名查询来声明实体的查询是一种有效的方法，对少量查询很有效。由于查询本身与运行它们的 Java 方法绑定，因此实际上可以使用 Spring Data JPA `@Query` 注解直接绑定它们，而不是将它们注释到域类。这将域类从持久性特定信息中解放出来，并将查询定位到存储库接口。

注解到查询方法的查询优先于使用 `@NamedQuery` 定义的查询或在 `orm.xml` 中声明的命名查询。

以下示例显示了使用 `@Query` 注解创建的查询：

```java
public interface UserRepository extends JpaRepository<User, Long> {

  @Query("select u from User u where u.emailAddress = ?1")
  User findByEmailAddress(String emailAddress);
}
```

##### 应用 QueryRewriter

有时，无论您尝试应用多少功能，在将查询发送到 `EntityManager` 之前，似乎都不可能让 Spring Data JPA 将您想要的所有内容应用于查询。

您可以在将查询发送到 `EntityManager` 并“重写”它之前立即着手处理它。也就是说，您可以在最后一刻进行任何更改。

```java
public interface MyRepository extends JpaRepository<User, Long> {

		@Query(value = "select original_user_alias.* from SD_USER original_user_alias",
                nativeQuery = true,
				queryRewriter = MyQueryRewriter.class)
		List<User> findByNativeQuery(String param);

		@Query(value = "select original_user_alias from User original_user_alias",
                queryRewriter = MyQueryRewriter.class)
		List<User> findByNonNativeQuery(String param);
}
```

此示例显示了本机（纯 SQL）重写器和 JPQL 查询，两者都利用了相同的 `QueryRewriter`。在这个场景中，Spring Data JPA 将查找在相应类型的应用程序上下文中注册的 bean。

您可以像这样编写查询重写器：

```java
public class MyQueryRewriter implements QueryRewriter {

     @Override
     public String rewrite(String query, Sort sort) {
         return query.replaceAll("original_user_alias", "rewritten_user_alias");
     }
}
```

您必须确保 `QueryRewriter` 在应用程序上下文中注册，无论是通过应用 Spring Framework 的基于 `@Component` 的注解，还是将其作为 `@Configuration` 类中 `@Bean` 方法的一部分。

另一种选择是让存储库本身实现接口。

```java
public interface MyRepository extends JpaRepository<User, Long>, QueryRewriter {

		@Query(value = "select original_user_alias.* from SD_USER original_user_alias",
                nativeQuery = true,
				queryRewriter = MyRepository.class)
		List<User> findByNativeQuery(String param);

		@Query(value = "select original_user_alias from User original_user_alias",
                queryRewriter = MyRepository.class)
		List<User> findByNonNativeQuery(String param);

		@Override
		default String rewrite(String query, Sort sort) {
			return query.replaceAll("original_user_alias", "rewritten_user_alias");
		}
}
```

根据您使用 `QueryRewriter` 所做的操作，建议使用多个，每个都在应用程序上下文中注册。

> 在基于 CDI 的环境中，Spring Data JPA 将在 `BeanManager` 中搜索 `QueryRewriter` 实现的实例。

##### 使用高级 LIKE 表达式

使用 `@Query` 创建的手动定义查询的查询运行机制允许在查询定义中定义高级 LIKE 表达式，如下例所示：

```java
public interface UserRepository extends JpaRepository<User, Long> {

  @Query("select u from User u where u.firstname like %?1")
  List<User> findByFirstnameEndsWith(String firstname);
}
```

在前面的示例中，识别 `LIKE` 分隔符（`%`），并将查询转换为有效的 JPQL 查询（删除 `%`）。在运行查询时，传递给方法调用的参数将使用先前识别的 LIKE 模式进行扩充。

##### 原生查询

`@Query` 注解允许通过将 `nativeQuery` 标志设置为 true 来运行原生查询，如下例所示：

```java
public interface UserRepository extends JpaRepository<User, Long> {

  @Query(value = "SELECT * FROM USERS WHERE EMAIL_ADDRESS = ?1", nativeQuery = true)
  User findByEmailAddress(String emailAddress);
}
```

> Spring Data JPA 目前不支持对原生查询进行动态排序，因为它必须处理实际声明的查询，而这对于原生 SQL 来说是不可靠的。但是，您可以通过自己指定 count 查询来使用本机查询进行分页，如下例所示：
>
> ```java
> public interface UserRepository extends JpaRepository<User, Long> {
> 
>   @Query(value = "SELECT * FROM USERS WHERE LASTNAME = ?1",
>     countQuery = "SELECT count(*) FROM USERS WHERE LASTNAME = ?1",
>     nativeQuery = true)
>   Page<User> findByLastname(String lastname, Pageable pageable);
> }
> ```

类似的方法也适用于命名的原生查询，方法是在查询副本中添加 `.count` 后缀。不过，您可能需要为计数查询注册一个结果集映射。

#### 使用排序

排序可以通过提供 `PageRequest` 或直接使用 `Sort` 来完成。排序的 `Order` 实例中实际使用的属性需要与域模型匹配，这意味着它们需要解析为查询中使用的属性或别名。JPQL 将其定义为状态字段路径表达式。

> 使用任何不可引用的路径表达式都会导致 `Exception`。

但是，将 `Sort` 与 `@Query` 一起使用可以让您潜入包含 `ORDER BY` 子句中函数的非路径检查 `Order` 实例。这是可能的，因为 `Order` 被附加到给定的查询字符串。默认情况下，Spring Data JPA 拒绝任何包含函数调用的 `Order` 实例，但您可以使用 `JpaSort.unsafe` 添加潜在不安全的排序。

以下示例使用 `Sort` 和 `JpaSort`，包括 `JpaSort` 上的不安全选项：

```java
public interface UserRepository extends JpaRepository<User, Long> {

  @Query("select u from User u where u.lastname like ?1%")
  List<User> findByAndSort(String lastname, Sort sort);

  @Query("select u.id, LENGTH(u.firstname) as fn_len from User u where u.lastname like ?1%")
  List<Object[]> findByAsArrayAndSort(String lastname, Sort sort);
}

repo.findByAndSort("lannister", Sort.by("firstname"));                (1)
repo.findByAndSort("stark", Sort.by("LENGTH(firstname)"));            (2)
repo.findByAndSort("targaryen", JpaSort.unsafe("LENGTH(firstname)")); (3)
repo.findByAsArrayAndSort("bolton", Sort.by("fn_len"));               (4)

// (1) 指向域模型中属性的有效排序表达式。
// (2) 包含函数调用的排序无效。引发异常。
// (3) 包含显式不安全顺序的有效排序。
// (4) 指向别名函数的有效排序表达式。
```

#### 使用命名参数

默认情况下，Spring Data JPA 使用基于位置的参数绑定，如前面所有示例中所述。这使得查询方法在重构参数位置时有点容易出错。要解决此问题，可以使用 `@Param` 注解为方法参数指定具体名称，并在查询中绑定该名称，如下例所示：

```java
public interface UserRepository extends JpaRepository<User, Long> {

  @Query("select u from User u where u.firstname = :firstname or u.lastname = :lastname")
  User findByLastnameOrFirstname(@Param("lastname") String lastname,
                                 @Param("firstname") String firstname);
}
```

> 方法参数根据其在定义的查询中的顺序进行切换。

> 从版本 4 开始，Spring 完全支持基于 `-parameters` 编译器标志的 Java 8 的参数名称发现。通过在构建中使用此标志作为调试信息的替代，可以省略命名参数的 `@Param` 注解。

#### 使用 SpEL 表达式

从 Spring Data JPA 1.4 版开始，我们支持在使用 `@Query` 定义的手动定义查询中使用受限的 SpEL 模板表达式。在运行查询时，将根据预定义的一组变量对这些表达式进行求值。Spring Data JPA 支持名为 `entityName` 的变量。它的用法是 `select x from #{#entityName} x`。它插入与给定存储库关联的域类型的 `entityName`。`entityName` 解析如下：如果域类型在 `@Entity` 注解上设置了 name 属性，则使用该属性。否则，将使用域类型的简单类名。

以下示例演示了查询字符串中的 `#{#entityName}` 表达式的一个用例，其中您希望使用查询方法和手动定义的查询定义存储库接口：

```java
@Entity
public class User {

  @Id
  @GeneratedValue
  Long id;

  String lastname;
}

public interface UserRepository extends JpaRepository<User,Long> {

  @Query("select u from #{#entityName} u where u.lastname = ?1")
  List<User> findByLastname(String lastname);
}
```

为了避免在 `@Query` 注解的查询字符串中声明实际的实体名称，可以使用 `#{#entityName}` 变量。

> 可以使用 `@Entity` 注解自定义 `entityName`。SpEL 表达式不支持 `orm.xml` 中的自定义设置。

当然，您可以直接在查询声明中使用 `User`，但这也需要您更改查询。对 `#entityName` 的引用获取了 `User` 类将来可能重新映射到另一个实体名称（例如，通过使用 `@entity(name = "MyUser")`）。

查询字符串中 `#{#entityName}` 表达式的另一个用例是，如果要为特定域类型定义具有专用存储库接口的通用存储库接口。要不在具体接口上重复自定义查询方法的定义，可以在通用存储库接口的 `@Query` 注解的查询字符串中使用实体名称表达式，如以下示例所示：

```java
@MappedSuperclass
public abstract class AbstractMappedType {
  …
  String attribute
}

@Entity
public class ConcreteType extends AbstractMappedType { … }

@NoRepositoryBean
public interface MappedTypeRepository<T extends AbstractMappedType>
  extends Repository<T, Long> {

  @Query("select t from #{#entityName} t where t.attribute = ?1")
  List<T> findAllByAttribute(String attribute);
}

public interface ConcreteRepository
  extends MappedTypeRepository<ConcreteType> { … }
```

在前面的示例中，`MappedTypeRepository` 接口是一些扩展 `AbstractMappedType` 的域类型的公共父接口。它还定义了通用的 `findAllByAttribute(…)` 方法，该方法可用于专用存储库接口的实例。如果现在在 `ConcreteRepository` 上调用 `findByAllAttribute(…)`，则查询变为 `select t from ConcreteType t where t.attribute = ?1`。

用于操纵参数的 SpEL 表达式也可以用于操纵方法参数。在这些 SpEL 表达式中，实体名称不可用，但参数可用。可以通过名称或索引访问它们，如下例所示。

```java
@Query("select u from User u where u.firstname = ?1 and u.firstname=?#{[0]} and u.emailAddress = ?#{principal.emailAddress}")
List<User> findByFirstnameAndCurrentUserWithCustomQuery(String firstname);
```

对于 `like` 的条件，人们通常希望将 `%` 附加到字符串值参数的开头或结尾。这可以通过在绑定参数标记或 SpEL 表达式中添加 `%` 来完成。下面的示例再次证明了这一点。

```java
@Query("select u from User u where u.lastname like %:#{[0]}% and u.lastname like %:lastname%")
List<User> findByLastnameWithSpelExpression(@Param("lastname") String lastname);
```

当对来自非安全源的值使用 `like` 条件时，应对值进行净化，使其不能包含任何通配符，从而允许攻击者选择超出其能力范围的数据。为此，在 SpEL 上下文中提供了 `escape(String)` 方法。它在第一个参数中的 `_` 和 `%` 的所有实例前面加上第二个参数的单个字符。结合 JPQL 和标准 SQL 中类似表达式的转义子句，可以轻松清理绑定参数。

```java
@Query("select u from User u where u.firstname like %?#{escape([0])}% escape ?#{escapeCharacter()}")
List<User> findContainingEscaped(String namePart);
```

给定存储库接口中的此方法声明，`findContainingEscaped("Peter_")` 将找到 `Peter_Parker`，而不是 `Peter Parker`。可以通过设置 `@EnableJpaRepositorys` 注解的 `escapeCharacter` 来配置使用的转义符。请注意，SpEL 上下文中可用的方法 `escape(String)` 将仅转义 SQL 和 JPQL 标准通配符 `_` 和 `%`。如果基础数据库或 JPA 实现支持其他通配符，则不会转义这些通配符。

#### 修改查询

前面的所有部分都描述了如何声明查询以访问给定实体或实体集合。您可以使用“Spring 数据存储库的自定义实现”中描述的自定义方法工具添加自定义修改行为。由于此方法对于全面的自定义功能是可行的，因此可以通过使用 `@Modifying` 注解查询方法来修改仅需要参数绑定的查询，如下例所示：

```java
@Modifying
@Query("update User u set u.firstname = ?1 where u.lastname = ?2")
int setFixedFirstnameFor(String firstname, String lastname);
```

这样做会触发注释到方法的查询，作为更新查询而不是选择查询。由于在执行修改查询后，`EntityManager` 可能包含过时的实体，因此我们不会自动清除它（有关详细信息，请参阅 `EntityManager.clear()` 的 JavaDoc），因为这实际上会删除 `EntityManager` 中仍然挂起的所有未刷新的更改。如果希望自动清除 `EntityManager`，可以将 `@Modifying` 注解的 `clearAutomatically` 属性设置为 `true`。

`@Modifying` 注解仅与 `@Query` 注解结合使用。派生查询方法或自定义方法不需要此注解。

##### 派生删除查询

Spring Data JPA 还支持派生的删除查询，这样您就可以避免显式声明 JPQL 查询，如下例所示：

```java
interface UserRepository extends Repository<User, Long> {

  void deleteByRoleId(long roleId);

  @Modifying
  @Query("delete from User u where u.role.id = ?1")
  void deleteInBulkByRoleId(long roleId);
}
```

尽管 `deleteByRoleId(…)` 方法看起来基本上产生了与 `deleteInBulkByRoleId(…)` 相同的结果，但两个方法声明在运行方式方面有着重要的区别。顾名思义，后一种方法针对数据库发出一个 JPQL 查询（注解中定义的查询）。这意味着即使当前加载的 `User` 实例也不会看到调用的生命周期回调。

为了确保实际调用了生命周期查询，调用 `deleteByRoleId(…)` 将运行一个查询，然后逐个删除返回的实例，以便持久性提供程序可以在这些实体上实际调用 `@PreRemove` 回调。

事实上，派生的删除查询是运行查询然后对结果调用 `CrudRepository.delete(Iterable<User> User)`，并保持行为与 `CrudRepository` 中其他 `delete(…)` 方法的实现同步的快捷方式。

#### 应用查询提示

要将 JPA 查询提示应用于存储库接口中声明的查询，可以使用 `@QueryHints` 注解。它需要一个 JPA `@QueryHint` 注解数组加上一个布尔标志，以潜在地禁用应用于应用分页时触发的附加计数查询的提示，如下例所示：

```java
public interface UserRepository extends Repository<User, Long> {

  @QueryHints(value = { @QueryHint(name = "name", value = "value")},
              forCounting = false)
  Page<User> findByLastname(String lastname, Pageable pageable);
}
```

前面的声明将为实际查询应用已配置的 `@QueryHint`，但忽略将其应用于为计算总页数而触发的计数查询。

##### 向查询添加注释

有时，您需要根据数据库性能调试查询。您的数据库管理员显示的查询可能与您使用 `@Query` 编写的查询非常不同，或者它可能与您假设的 Spring Data JPA 生成的关于自定义查找器的查询完全不同，或者您使用了查询作为示例。

为了简化这个过程，您可以通过应用 `@Meta` 注解将自定义注解插入到几乎任何 JPA 操作中，无论是查询还是其他操作。

```java
public interface RoleRepository extends JpaRepository<Role, Integer> {

	@Meta(comment = "find roles by name")
	List<Role> findByName(String name);

	@Override
	@Meta(comment = "find roles using QBE")
	<S extends Role> List<S> findAll(Example<S> example);

	@Meta(comment = "count roles for a given name")
	long countByName(String name);

	@Override
	@Meta(comment = "exists based on QBE")
	<S extends Role> boolean exists(Example<S> example);
}
```

此示例存储库混合了自定义查找器，并覆盖了从 `JpaRepository` 继承的操作。无论哪种方式，`@Meta` 注解都允许您添加一个 `comment`，该注释将在发送到数据库之前插入到查询中。

还需要注意的是，此功能并不仅仅局限于查询。它扩展到 `count` 和 `exists` 操作。虽然未显示，但它也扩展到某些 `delete` 操作。

> 虽然我们已经尝试尽可能地应用此功能，但底层 `EntityManager` 的某些操作不支持注释。例如，`entityManager.createQuery()` 被明确记录为支持注释，但 `entityManager.find()` 操作不支持。

JPQL 日志记录和 SQL 日志记录都不是 JPA 中的标准，因此每个提供程序都需要自定义配置，如下所示。

**激活 Hibernate 注释**

要在 Hibernate 中激活查询注释，必须将 `hibernate.use_sql_comments` 设置为 `true`。

如果您使用基于 Java 的配置设置，可以这样做：

```java
@Bean
public Properties jpaProperties() {

	Properties properties = new Properties();
	properties.setProperty("hibernate.use_sql_comments", "true");
	return properties;
}
```

如果您有一个 `persistence.xml` 文件，可以在那里应用它：

```xml
<persistence-unit name="my-persistence-unit">

   ...registered classes...

	<properties>
		<property name="hibernate.use_sql_comments" value="true" />
	</properties>
</persistence-unit>
```

最后，如果您使用的是Spring Boot，那么可以在 `application.properties` 文件中进行设置：

```properties
spring.jpa.properties.hibernate.use_sql_comments=true
```

**激活 EclipseLink 注释**

要激活 EclipseLink 中的查询注释，必须将 `eclipseLink.logging.level.sql` 设置为 `FINE`。

如果您使用基于 Java 的配置设置，可以这样做：

```java
@Bean
public Properties jpaProperties() {

	Properties properties = new Properties();
	properties.setProperty("eclipselink.logging.level.sql", "FINE");
	return properties;
}
```

如果您有一个 `persistence.xml` 文件，可以在那里应用它：

```xml
<persistence-unit name="my-persistence-unit">

   ...registered classes...

	<properties>
		<property name="eclipselink.logging.level.sql" value="FINE" />
	</properties>
</persistence-unit>
```

最后，如果您使用的是 Spring Boot，那么可以在 `application.properties` 文件中进行设置：

```properties
spring.jpa.properties.eclipselink.logging.level.sql=FINE
```

#### 配置 Fetch- 和 LoadGraphs

JPA 2.1 规范引入了对指定 Fetch- 和 LoadGraphs 的支持，我们也支持 `@EntityGraph` 注解，它允许您引用 `@NamedEntityGraph` 定义。您可以在实体上使用该注解来配置结果查询的提取计划。可以通过使用 `@EntityGraph` 注解上的 `type` 属性来配置获取的类型（`Fetch` 或 `Load`）。更多参考请参见 JPA 2.1 规范 3.7.4。

以下示例显示了如何在实体上定义命名实体图：

```java
@Entity
@NamedEntityGraph(name = "GroupInfo.detail",
  attributeNodes = @NamedAttributeNode("members"))
public class GroupInfo {

  // default fetch mode is lazy.
  @ManyToMany
  List<GroupMember> members = new ArrayList<GroupMember>();

  …
}
```

以下示例显示了如何在存储库查询方法上引用命名实体图：

```java
public interface GroupRepository extends CrudRepository<GroupInfo, String> {

  @EntityGraph(value = "GroupInfo.detail", type = EntityGraphType.LOAD)
  GroupInfo getByGroupName(String name);

}
```

还可以使用 `@EntityGraph` 定义特殊实体图。提供的 `attributePaths` 被转换为相应的 `EntityGraph`，无需将 `@NamedEntityGraph` 显式添加到域类型中，如下例所示：

```java
public interface GroupRepository extends CrudRepository<GroupInfo, String> {

  @EntityGraph(attributePaths = { "members" })
  GroupInfo getByGroupName(String name);

}
```

#### 投射

Spring Data 查询方法通常返回由存储库管理的聚合根的一个或多个实例。然而，有时可能需要基于这些类型的某些属性创建投射。Spring Data 允许对专用返回类型进行建模，以更有选择地检索托管聚合的部分视图。

设想一个存储库和聚合根类型，例如以下示例：

```java
class Person {

  @Id UUID id;
  String firstname, lastname;
  Address address;

  static class Address {
    String zipCode, city, street;
  }
}

interface PersonRepository extends Repository<Person, UUID> {

  Collection<Person> findByLastname(String lastname);
}
```

现在想象一下，我们只想检索人名属性。Spring Data 提供了什么手段来实现这一点？本章的其余部分将回答这个问题。

##### 基于接口的投射

将查询结果限制为仅名称属性的最简单方法是声明一个接口，该接口公开要读取的属性的访问器方法，如下例所示：

```java
interface NamesOnly {

  String getFirstname();
  String getLastname();
}
```

这里重要的一点是这里定义的属性与聚合根中的属性完全匹配。这样做可以添加如下查询方法：

```java
interface PersonRepository extends Repository<Person, UUID> {

  Collection<NamesOnly> findByLastname(String lastname);
}
```

查询执行引擎在运行时为返回的每个元素创建该接口的代理实例，并将对公开方法的调用转发给目标对象。

> 在 `Repository` 中声明重写基方法的方法（例如在 `CrudRepository`、特定于存储库的存储库接口或 `Simple…Repository` 中所声明的方法）会导致对基方法的调用，而不管声明的返回类型如何。确保使用兼容的返回类型，因为基本方法不能用于投射。一些存储模块支持 `@Query` 注解，以将重写的基方法转换为可用于返回投射的查询方法。

投射可以递归使用。如果还想包含一些 `Address` 信息，请为其创建一个投射接口，并从 `getAddress()` 声明中返回该接口，如下例所示：

```java
interface PersonSummary {

  String getFirstname();
  String getLastname();
  AddressSummary getAddress();

  interface AddressSummary {
    String getCity();
  }
}
```

在方法调用时，获取目标实例的地址属性，然后将其包装到投射代理中。

**闭合投射**

其访问器方法都与目标聚合的属性匹配的投射接口被视为闭合投射。以下示例（我们在本章前面也使用过）是闭合投射：

```java
interface NamesOnly {

  String getFirstname();
  String getLastname();
}
```

如果使用闭合投射，Spring Data 可以优化查询执行，因为我们知道支持投射代理所需的所有属性。有关详细信息，请参阅参考文档的模块特定部分。

**开放投射**

投射接口中的访问器方法也可以用于通过使用 `@Value` 注解来计算新值，如下例所示：

```java
interface NamesOnly {

  @Value("#{target.firstname + ' ' + target.lastname}")
  String getFullName();
  …
}
```

支持投射的聚合根在目标变量中可用。使用 `@Value` 的投射接口是开放投射。在这种情况下，Spring Data 无法应用查询执行优化，因为 SpEL 表达式可以使用聚合根的任何属性。

`@Value` 中使用的表达式不应太复杂 — 您希望避免在 `String` 变量中编程。对于非常简单的表达式，一种选择可能是使用默认方法（在 Java 8 中引入），如下例所示：

```java
interface NamesOnly {

  String getFirstname();
  String getLastname();

  default String getFullName() {
    return getFirstname().concat(" ").concat(getLastname());
  }
}
```

这种方法要求您能够完全基于投射接口上公开的其他访问器方法来实现逻辑。第二个更灵活的选项是在 Spring bean 中实现自定义逻辑，然后从 SpEL 表达式调用该逻辑，如下例所示：

```java
@Component
class MyBean {

  String getFullName(Person person) {
    …
  }
}

interface NamesOnly {

  @Value("#{@myBean.getFullName(target)}")
  String getFullName();
  …
}
```

请注意，SpEL 表达式如何引用 `myBean` 并调用 `getFullName(…)` 方法，并将投射目标作为方法参数转发。由 SpEL 表达式求值支持的方法也可以使用方法参数，然后可以从表达式中引用这些参数。方法参数可通过名为 `args` 的 `Object` 数组获得。以下示例显示如何从 `args` 数组中获取方法参数：

```java
interface NamesOnly {

  @Value("#{args[0] + ' ' + target.firstname + '!'}")
  String getSalutation(String prefix);
}
```

同样，对于更复杂的表达式，应该使用 Spring bean 并让表达式调用方法，如前所述。

**可为空的包装**

投射接口中的获取器可以使用可空包装器来提高空安全性。当前支持的包装类型有：

- java.util.Optional
- com.google.common.base.Optional
- scala.Option
- io.vavr.control.Option

```java
interface NamesOnly {

  Optional<String> getFirstname();
}
```

如果基础投射值不为 `null`，则使用包装类型的当前表示返回值。如果返回值为 `null`，则 getter 方法返回所用包装器类型的空表示。

##### 基于类的投射（DTOs）

定义投射的另一种方法是使用值类型 DTO（数据传输对象），这些 DTO 保存应该检索的字段的属性。这些 DTO 类型的使用方式与投射接口的使用方式完全相同，只是不发生代理，也不应用嵌套投射。

如果存储通过限制要加载的字段来优化查询执行，则要加载的域将根据公开的构造函数的参数名称来确定。

以下示例显示了投射 DTO：

```java
class NamesOnly {

  private final String firstname, lastname;

  NamesOnly(String firstname, String lastname) {

    this.firstname = firstname;
    this.lastname = lastname;
  }

  String getFirstname() {
    return this.firstname;
  }

  String getLastname() {
    return this.lastname;
  }

  // equals(…) and hashCode() implementations
}
```

> **避免投影DTO的样板代码**
>
> 通过使用 Project Lombok，您可以极大地简化 DTO 的代码，它提供了 `@Value` 注解（不要与前面接口示例中显示的 Spring 的 `@Value` 注释混淆）。如果使用 Project Lombok 的 `@Value` 注解，前面显示的示例 DTO 将变成以下内容：
>
> ```java
> @Value
> class NamesOnly {
> 	String firstname, lastname;
> }
> ```
>
> 默认情况下，字段是 `private final`，并且类公开一个构造函数，该构造函数接受所有字段并自动获取 `equals(…)` 和 `hashCode()` 方法。

> JPQL 的基于类的投射仅限于 JPQL 表达式中的**构造函数表达式**，例如，`SELECT new com.example.NamesOnly(u.firstname, u.lastname) from User u`（请注意 DTO 类型的 FQDN 用法！）该 JPQL 表达式也可以用于 `@Query` 注解中，您可以在其中定义任何命名查询。需要指出的是，基于类的投射根本不适用于原生查询。作为解决方法，您可以将命名查询与 `ResultSetMapping` 或 Hibernate 特定的 `ResultTransformer` 一起使用

##### 动态投射

到目前为止，我们已经将投射类型用作集合的返回类型或元素类型。但是，您可能希望选择在调用时使用的类型（这使其成为动态的）。要应用动态投射，请使用以下示例中所示的查询方法：

```java
interface PersonRepository extends Repository<Person, UUID> {

  <T> Collection<T> findByLastname(String lastname, Class<T> type);
}
```

通过这种方式，可以使用该方法按原样或应用投射获得聚合，如下例所示：

```java
void someMethod(PersonRepository people) {

  Collection<Person> aggregates =
    people.findByLastname("Matthews", Person.class);

  Collection<NamesOnly> aggregates =
    people.findByLastname("Matthews", NamesOnly.class);
}
```

> 检查 `Class` 类型的查询参数是否符合动态投影参数。如果查询的实际返回类型等于 `Class` 参数的泛型参数类型，则匹配的 `Class` 参数在查询或 SpEL 表达式中不可用。如果要将 `Class` 参数用作查询参数，请确保使用其他泛型参数，例如 `Class<?>`。

### 5.1.4 存储过程

JPA 2.1 规范引入了对使用 JPA 标准查询 API 调用存储过程的支持。我们引入了 `@Procedure` 注解，用于在存储库方法上声明存储过程元数据。

下面的示例使用以下存储过程：

```sql
/;
DROP procedure IF EXISTS plus1inout
/;
CREATE procedure plus1inout (IN arg int, OUT res int)
BEGIN ATOMIC
 set res = arg + 1;
END
/;
```

可以通过对实体类型使用 `NamedStoredProcedureQuery` 注解来配置存储过程的元数据。

```java
@Entity
@NamedStoredProcedureQuery(name = "User.plus1", procedureName = "plus1inout", parameters = {
  @StoredProcedureParameter(mode = ParameterMode.IN, name = "arg", type = Integer.class),
  @StoredProcedureParameter(mode = ParameterMode.OUT, name = "res", type = Integer.class) })
public class User {}
```

请注意，`@NamedStoredProcedureQuery` 有两个不同的存储过程名称。`name` 是 JPA 使用的名称。`procedureName` 是存储过程在数据库中的名称。

您可以通过多种方式引用存储库方法中的存储过程。要调用的存储过程可以使用 `@Procedure` 注解的 `value` 或 `procedureName` 属性直接定义。这直接引用数据库中的存储过程，并通过 `@NamedStoredProcedureQuery` 忽略任何配置。

或者，您可以将 `@NamedStoredProcedureQuery.name` 属性指定为 `@Procedure.name` 属性。如果未配置 `value`、`procedureName` 或 `name`，则存储库方法的名称将用作 `name` 属性。

以下示例显示了如何引用显式映射过程：

```java
@Procedure("plus1inout")
Integer explicitlyNamedPlus1inout(Integer arg);
```

以下示例与前面的示例等效，但使用 `procedureName` 别名：

```java
@Procedure(procedureName = "plus1inout")
Integer callPlus1InOut(Integer arg);
```

以下内容同样与前两个等效，但使用了方法名而不是显式注释属性。

```java
@Procedure
Integer plus1inout(@Param("arg") Integer arg);
```

以下示例显示了如何通过引用 `@NamedStoredProcedureQuery.name` 属性来引用存储过程。

```java
@Procedure(name = "User.plus1IO")
Integer entityAnnotatedCustomNamedProcedurePlus1IO(@Param("arg") Integer arg);
```

如果被调用的存储过程具有单个输出参数，则该参数可以作为方法的返回值返回。如果在 `@NamedStoredProcedureQuery` 注解中指定了多个 out 参数，则这些参数可以作为 `Map` 返回，其中键是 `@NamedSstoredProcedurequery` 注解中给定的参数名称。

### 5.1.5 规范(Specifications)

JPA 2 引入了一个标准 API，您可以使用它以编程方式构建查询。通过编写 `criteria`，可以定义域类查询的 where 子句。再退一步，这些标准可以被视为 JPA 标准 API 约束所描述的实体的谓词。

Spring Data JPA 采用了 Eric Evans 的书“领域驱动设计”中的规范概念，遵循相同的语义，并提供了一个 API 来使用 JPA 标准 API 定义此类规范。为了支持规范，可以使用 `JpaSpecificationExecutor` 接口扩展存储库接口，如下所示：

```java
public interface CustomerRepository extends CrudRepository<Customer, Long>, JpaSpecificationExecutor<Customer> {
 …
}
```

附加的接口具有允许您以各种方式运行规范的方法。例如，`findAll` 方法返回符合规范的所有实体，如下例所示：

```java
List<T> findAll(Specification<T> spec);
```

`Specification` 接口定义如下：

```java
public interface Specification<T> {
  Predicate toPredicate(Root<T> root, CriteriaQuery<?> query,
            CriteriaBuilder builder);
}
```

规范可以很容易地用于在实体之上构建一组可扩展的谓词，然后可以与 `JpaRepository` 组合使用，而无需为每个所需的组合声明查询（方法），如下例所示：

```java
public class CustomerSpecs {


  public static Specification<Customer> isLongTermCustomer() {
    return (root, query, builder) -> {
      LocalDate date = LocalDate.now().minusYears(2);
      return builder.lessThan(root.get(Customer_.createdAt), date);
    };
  }

  public static Specification<Customer> hasSalesOfMoreThan(MonetaryAmount value) {
    return (root, query, builder) -> {
      // build query here
    };
  }
}
```

`Customer_` 类型是使用 JPA 元模型生成器生成的元模型类型（有关示例，请参阅 Hibernate 实现的文档）。因此，表达式 `Customer_.createdAt` 假定 `Customer` 具有 `Date` 类型的 `createdAt` 属性。除此之外，我们在业务需求抽象级别上表达了一些标准，并创建了可执行 `Specifications`。因此，客户可以使用 `Specification` 如下：

```java
List<Customer> customers = customerRepository.findAll(isLongTermCustomer());
```

为什么不为这种数据访问创建查询？与普通查询声明相比，使用单一规范并不能获得很多好处。当您将规范结合起来创建新的规范对象时，规范的力量真的很强大。您可以通过我们提供的规范的默认方法来实现这一点，以构建类似于以下内容的表达式：

```java
MonetaryAmount amount = new MonetaryAmount(200.0, Currencies.DOLLAR);
List<Customer> customers = customerRepository.findAll(
  isLongTermCustomer().or(hasSalesOfMoreThan(amount)));
```

`Specification` 提供了一些“粘合代码”默认方法来链接和组合 `Specification` 实例。这些方法允许您通过创建新的 `Specification` 实现并将其与现有实现结合来扩展数据访问层。

在 JPA 2.1 中，`CriteriaBuilder` API 引入了 `CriteriaDelete`。这是通过 `JpaSpecificationExecutor` 的 `delete(Specification)` API 提供的。

```java
Specification<User> ageLessThan18 = (root, query, cb) -> cb.lessThan(root.get("age").as(Integer.class), 18)

userRepository.delete(ageLessThan18);
```

该 `Specification` 建立了 `age` 字段（以整数表示）小于 `18` 的标准。传递给 `userRepository` 后，它将使用 JPA 的 `CriteriaDelete` 功能生成正确的 `DELETE` 操作。然后返回删除的实体数。

### 5.1.6 按示例查询

#### 导言

本章介绍“按示例查询”，并解释如何使用它。

按示例查询（Query by Example, QBE）是一种用户友好的查询技术，具有简单的界面。它允许动态创建查询，不需要编写包含字段名的查询。事实上，按示例查询根本不要求您使用特定于存储的查询语言编写查询。

#### 用法

按示例查询 API 由四部分组成：

- 探针（Probe）：具有填充字段的域对象的实际示例。
- `ExampleMatcher`: `ExampleMatcher` 包含如何匹配特定字段的详细信息。它可以在多个示例中重复使用。
- `Example`：`Example` 由探针和 `ExampleMatcher` 组成。它用于创建查询。
- `FetchableFluentQuery`：`FetchableFluentQuery` 提供了一个流式 API，允许进一步自定义从 `Example` 派生的查询。使用流式 API可以指定查询的排序投射和结果处理。

按示例查询对一些使用场景很合适：

- 使用一组静态或动态约束查询数据存储。
- 频繁重构域对象，而不用担心破坏现有查询。
- 独立于底层数据存储 API 工作。

按示例查询也有几个限制：

- 不支持嵌套或分组的属性约束，例如 `firstname = ?0 or (firstname = ?1 and lastname = ?2)`。
- 仅支持字符串的 starts/contains/ends/regex 匹配和其他属性类型的精确匹配。

在开始使用按示例查询之前，您需要有一个域对象。要开始，请为存储库创建一个接口，如下例所示：

```java
public class Person {

  @Id
  private String id;
  private String firstname;
  private String lastname;
  private Address address;

  // … getters and setters omitted
}
```

前面的示例显示了一个简单的域对象。您可以使用它创建 `Example`。默认情况下，忽略具有 `null` 值的字段，并使用特定于存储的默认值匹配字符串。

> 将属性包含在“按示例查询”条件中是基于可为空性的。除非 `ExampleMatcher` 忽略属性路径，否则始终包含使用基元类型（`int`、`double`、…）的属性。

可以通过使用工厂方法 `of` 或使用 `ExampleMatcher` 来构建示例。`Example` 是不可变的。下面的列表显示了一个简单的示例：

```java
Person person = new Person();                         (1)
person.setFirstname("Dave");                          (2)

Example<Person> example = Example.of(person);         (3)

// (1) 创建域对象的新实例。
// (2) 设置要查询的属性。
// (3) 创建 `Example`。
```

您可以使用存储库运行示例查询。为此，让存储库接口扩展`QueryByExampleExecutor<T>`。以下列表显示了 `QueryByExampleExecutor` 接口的摘录：

```java
public interface QueryByExampleExecutor<T> {

  <S extends T> S findOne(Example<S> example);

  <S extends T> Iterable<S> findAll(Example<S> example);

  // … more functionality omitted.
}
```

#### 示例匹配器

示例不限于默认设置。您可以使用 `ExampleMatcher` 为字符串匹配、空处理和特定于属性的设置指定自己的默认值，如下例所示：

```java
Person person = new Person();                          (1)
person.setFirstname("Dave");                           (2)

ExampleMatcher matcher = ExampleMatcher.matching()     (3)
  .withIgnorePaths("lastname")                         (4)
  .withIncludeNullValues()                             (5)
  .withStringMatcher(StringMatcher.ENDING);            (6)

Example<Person> example = Example.of(person, matcher); (7)

// (1) 创建域对象的新实例。
// (2) 设置属性。
// (3) 创建 `ExampleMatcher` 以期望所有值都匹配。即使没有进一步的配置，它也可以在这个阶段使用。
// (4) 构造一个新的 `ExampleMatcher` 以忽略 `lastname` 属性路径。
// (5) 构造一个新的 `ExampleMatcher` 以忽略 `lastname` 属性路径并包含空值。
// (6) 构造一个新的 `ExampleMatcher` 来忽略 `lastname` 属性路径，包括空值，并执行后缀字符串匹配。
// (7) 基于域对象和配置的 `ExampleMatcher` 创建一个新的 `Example`。
```

默认情况下，`ExampleMatcher` 期望探针上设置的所有值都匹配。如果希望获得与隐式定义的任何谓词匹配的结果，请使用 `ExampleMatcher.matchingAny()`。

您可以为单个属性指定行为（例如 “firstname” 和 “lastname”，或者为嵌套属性指定 “address.city”）。您可以使用匹配的选项和区分大小写对其进行调整，如下例所示：

```java
ExampleMatcher matcher = ExampleMatcher.matching()
  .withMatcher("firstname", endsWith())
  .withMatcher("lastname", startsWith().ignoreCase());
}
```

配置匹配器选项的另一种方法是使用 lambda（在 Java 8 中引入）。这种方法创建一个回调，要求实现者修改匹配器。您不需要返回匹配器，因为配置选项保存在匹配器实例中。以下示例显示了使用 lambda 的匹配器：

```java
ExampleMatcher matcher = ExampleMatcher.matching()
  .withMatcher("firstname", match -> match.endsWith())
  .withMatcher("firstname", match -> match.startsWith());
}
```

`Example` 创建的查询使用配置的合并视图。默认匹配设置可以在 `ExampleMatcher` 级别设置，而单独的设置可以应用于特定的属性路径。在 `ExampleMatcher` 上设置的设置由属性路径设置继承，除非明确定义。属性修补程序上的设置具有比默认设置更高的优先级。下表描述了各种 `ExampleMatcher` 设置的作用域：

| 设置       | 作用域                      |
| ---------- | --------------------------- |
| 空处理     | `ExampleMatcher`            |
| 字符串匹配 | `ExampleMatcher` 和属性路径 |
| 忽略属性   | 属性路径                    |
| 大小写敏感 | `ExampleMatcher` 和属性路径 |
| 值转换     | 属性路径                    |

#### 流式 API

`QueryByExampleExecutor` 提供了另外一种方法，我们到目前为止还没有提到：`<S extends T, R> R findBy(Example<S> example, Function<FluentQuery.FetchableFluentQuery<S>, R> queryFunction)`。与其他方法一样，它执行从 `Example` 派生的查询。然而，使用第二个参数，您可以控制执行的某些方面，否则无法动态控制这些方面。通过在第二个参数中调用 `FetchableFluentQuery` 的各种方法来实现。`sortBy` 允许您为结果指定排序。`as` 允许您指定要将结果转换为的类型。`project` 限制了查询的属性。`first`、`firstValue`、`one`、`oneValue`、`all`、`page`、`stream`、`count` 和 `exists` 定义了当可用的结果数超过预期数时，获得的结果类型以及查询的行为。

```java
Optional<Person> match = repository.findBy(example,
    q -> q
        .sortBy(Sort.by("lastname").descending())
        .first()
);
```

#### 运行一个示例

在 Spring Data JPA 中，可以对存储库使用按示例查询，如下例所示：

```java
public interface PersonRepository extends JpaRepository<Person, String> { … }

public class PersonService {

  @Autowired PersonRepository personRepository;

  public List<Person> findPeople(Person probe) {
    return personRepository.findAll(Example.of(probe));
  }
}
```

> 当前，只有 `SingularAttribute` 属性可用于属性匹配。

属性说明符接受属性名称（例如 `firstname` 和 `lastname`）。您可以通过将属性与点（`address.city`）链接在一起进行导航。您还可以使用匹配选项和区分大小写对其进行调整。

下表显示了可以使用的各种 `StringMatcher` 选项，以及在名为 `firstname` 的字段上使用这些选项的结果：

| 匹配                        | 逻辑结果                                      |
| --------------------------- | --------------------------------------------- |
| `DEFAULT` (大小写敏感)      | `firstname = ?0`                              |
| `DEFAULT` (大小写不敏感)    | `LOWER(firstname) = LOWER(?0)`                |
| `EXACT` (大小写敏感)        | `firstname = ?0`                              |
| `EXACT` (大小写不敏感)      | `LOWER(firstname) = LOWER(?0)`                |
| `STARTING` (大小写敏感)     | `firstname like ?0 + '%'`                     |
| `STARTING` (大小写不敏感)   | `LOWER(firstname) like LOWER(?0) + '%'`       |
| `ENDING` (大小写敏感)       | `firstname like '%' + ?0`                     |
| `ENDING` (大小写不敏感)     | `LOWER(firstname) like '%' + LOWER(?0)`       |
| `CONTAINING` (大小写敏感)   | `firstname like '%' + ?0 + '%'`               |
| `CONTAINING` (大小写不敏感) | `LOWER(firstname) like '%' + LOWER(?0) + '%'` |

### 5.1.7 事务性

默认情况下，从 `SimpleJpaRepository` 继承的存储库实例上的 CRUD 方法是事务性的。对于读取操作，事务配置 `readOnly` 标志设置为 `true`。所有其他的都配置了一个普通的 `@Transactional`，以便应用默认的事务配置。由事务性存储库片段支持的存储库方法从实际的片段方法继承事务性属性。

如果需要调整存储库中声明的方法之一的事务配置，请在存储库接口中重新声明该方法，如下所示：

```java
public interface UserRepository extends CrudRepository<User, Long> {

  @Override
  @Transactional(timeout = 10)
  public List<User> findAll();

  // Further query method declarations
}
```

这样做会导致 `findAll()` 方法在超时限制为 10 秒的情况下运行，并且没有 `readOnly` 标志。

另一种改变事务行为的方法是使用覆盖多个存储库的外观（facade）或服务实现。其目的是为非 CRUD 操作定义事务边界。以下示例显示了如何对多个存储库使用这样的外观：

```java
@Service
public class UserManagementImpl implements UserManagement {

  private final UserRepository userRepository;
  private final RoleRepository roleRepository;

  public UserManagementImpl(UserRepository userRepository,
    RoleRepository roleRepository) {
    this.userRepository = userRepository;
    this.roleRepository = roleRepository;
  }

  @Transactional
  public void addRoleToAllUsers(String roleName) {

    Role role = roleRepository.findByName(roleName);

    for (User user : userRepository.findAll()) {
      user.addRole(role);
      userRepository.save(user);
    }
  }
}
```

此示例导致对 `addRoleToAllUsers(…)` 的调用在事务内运行（参与现有事务或创建新事务，如果没有正在运行的事务）。然后忽略存储库中的事务配置，因为外部事务配置决定了实际使用的事务配置。请注意，您必须激活 `<tx:annotation-driven/>` 或显式使用 `@EnableTransactionManagement` 来获得基于注释的外观配置。本示例假设您使用组件扫描。

请注意，从 JPA 的角度来看，调用 `save` 并不是绝对必要的，但为了保持与 Spring Data 提供的存储库抽象一致，它应该仍然存在。

#### 事务的查询方法

要使查询方法具有事务性，请在定义的存储库界面使用 `@transactional`，如下例所示：

```java
@Transactional(readOnly = true)
interface UserRepository extends JpaRepository<User, Long> {

  List<User> findByLastname(String lastname);

  @Modifying
  @Transactional
  @Query("delete from User u where u.active = false")
  void deleteInactiveUsers();
}
```

通常，您希望将 `readOnly` 标志设置为 `true`，因为大多数查询方法只读取数据。与此相反，`deleteInactiveUsers()` 使用 `@Modifying` 注解并重写事务配置。因此，该方法在 `readOnly` 标志设置为 `false` 的情况下运行。

> 您可以将事务用于只读查询，并通过设置 `readOnly` 标志将其标记为只读查询。然而，这样做并不能作为检查您是否触发操作查询（尽管某些数据库拒绝只读事务中的 `INSERT` 和 `UPDATE` 语句）。`readOnly` 标志作为提示传播到底层 JDBC 驱动程序，以进行性能优化。此外，Spring 对底层 JPA 提供程序执行一些优化。例如，当与 Hibernate 一起使用时，当您将事务配置为 `readOnly` 时，刷新模式设置为 `NEVER`，这会导致 Hibernate 跳过脏检查（这对大型对象树有明显的改进）。

### 5.1.8 锁

为了指定使用的锁模式，你可以在查询方法上使用 `@Lock` 注解，如下所示：

```java
interface UserRepository extends Repository<User, Long> {

  // Plain query method
  @Lock(LockModeType.READ)
  List<User> findByLastname(String lastname);
}
```

此方法声明导致被触发的查询配备了 `READ` 的 `LockModeType`。您还可以通过在存储库接口中重新定义 CRUD 方法并添加 `@Lock` 注解来定义 CRUD 的锁，如下例所示：

```java
interface UserRepository extends Repository<User, Long> {

  // Redeclaration of a CRUD method
  @Lock(LockModeType.READ)
  List<User> findAll();
}
```

### 5.1.9 审计

#### 基础

Spring Data 提供了复杂的支持，以透明地跟踪谁创建或更改了实体以及更改发生的时间。要从该功能中获益，您必须为实体类配备审计元数据，这些元数据可以使用注释或通过实现接口来定义。此外，必须通过注解配置或 XML 配置启用审计，以注册所需的基础结构组件。有关配置示例，请参阅存储特定部分。

> 只跟踪创建和修改日期的应用程序不需要使其实体实现 `AuditorAware`。

##### 基于注解的审计元数据

我们提供 `@CreatedBy` 和 `@LastModifiedBy` 来捕获创建或修改实体的用户，以及 `@CreatedDate` 和 `@LastModifiedDate` 来捕获更改发生的时间。

```java
class Customer {

  @CreatedBy
  private User user;

  @CreatedDate
  private Instant createdDate;

  // … further properties omitted
}
```

正如您所看到的，可以根据要捕获的信息选择性地应用注释。可以在 JDK8 日期和时间类型、`long`、`Long` 和传统 Java `Date` 和 `Calendar` 的属性上使用注解，以指示何时进行更改。

审计元数据不一定需要存在于根级实体中，但可以添加到嵌入式实体中（取决于实际使用的存储），如下面的代码段所示。

```java
class Customer {

  private AuditMetadata auditingMetadata;

  // … further properties omitted
}

class AuditMetadata {

  @CreatedBy
  private User user;

  @CreatedDate
  private Instant createdDate;

}
```

##### 基于接口的审计元数据

如果不想使用注解来定义审计元数据，可以让域类实现 `Auditable` 接口。它公开了所有审计属性的 setter 方法。

**AuditorAware**

在使用 `@CreatedBy` 或 `@LastModifiedBy` 的情况下，审计基础结构需要了解当前主体。为此，我们提供了 `AuditorAware<T>` SPI 接口，您必须实现该接口来告诉基础结构当前与应用程序交互的用户或系统是谁。通用类型 `T` 定义了用 `@CreatedBy` 或 `@LastModifiedBy` 注解的属性必须是什么类型。

以下示例显示了使用 Spring Security 的 `Authentication` 对象的接口的实现：

```java
class SpringSecurityAuditorAware implements AuditorAware<User> {

  @Override
  public Optional<User> getCurrentAuditor() {

    return Optional.ofNullable(SecurityContextHolder.getContext())
            .map(SecurityContext::getAuthentication)
            .filter(Authentication::isAuthenticated)
            .map(Authentication::getPrincipal)
            .map(User.class::cast);
  }
}
```

该实现访问 Spring Security 提供的 `Authentication` 对象，并查找您在 `UserDetailsService` 实现中创建的自定义 `UserDetails` 实例。我们在这里假设您通过 `UserDetails` 实现公开域用户，但根据找到的身份验证，您也可以在任何地方查找它。

**ReactiveAuditorAware**

使用反应式基础设施时，您可能希望利用上下文信息来提供 `@CreatedBy` 或 `@LastModifiedBy` 信息。我们提供了一个 `ReactiveAuditorAware<T>` SPI 接口，您必须实现该接口来告诉基础结构当前与应用程序交互的用户或系统是谁。通用类型 `T` 定义了用 `@CreatedBy` 或 `@LastModifiedBy` 注解的属性必须是什么类型。

以下示例显示了使用反应式 Spring Security 的 Authentication 对象的接口的实现：

```java
class SpringSecurityAuditorAware implements ReactiveAuditorAware<User> {

  @Override
  public Mono<User> getCurrentAuditor() {

    return ReactiveSecurityContextHolder.getContext()
                .map(SecurityContext::getAuthentication)
                .filter(Authentication::isAuthenticated)
                .map(Authentication::getPrincipal)
                .map(User.class::cast);
  }
}
```

该实现访问 Spring Security 提供的 `Authentication` 对象，并查找您在 `UserDetailsService` 实现中创建的自定义 `UserDetails` 实例。我们在这里假设您通过 `UserDetails` 实现公开域用户，但根据找到的 `Authentication` 您也可以在任何地方查找它。

还有一个方便的基类 `AbstractAuditable`，您可以对其进行扩展，以避免手动实现接口方法。这样做会增加域类与 Spring Data 的耦合，这可能是您需要避免的。通常，基于注解的定义审计元数据的方式是首选的，因为它侵入性较小，而且更灵活。

### 5.1.10 JPA 审计

#### 普通审计配置

Spring Data JPA 附带了一个实体监听器，可以用来触发审计信息的捕获。首先，您必须在 `orm.xml` 文件中注册 `AuditingEntityListener`，以用于持久性上下文中的所有实体，如下例所示：

```xml
<persistence-unit-metadata>
  <persistence-unit-defaults>
    <entity-listeners>
      <entity-listener class="….data.jpa.domain.support.AuditingEntityListener" />
    </entity-listeners>
  </persistence-unit-defaults>
</persistence-unit-metadata>
```

您还可以使用 `@EntityListeners` 注解按每个实体启用 `AuditingEntityListener`，如下所示：

```java
@Entity
@EntityListeners(AuditingEntityListener.class)
public class MyEntity {

}
```

> 审计功能要求 `spring-aspects.jar` 位于类路径中。

通过适当修改 `orm.xml` 并在类路径上使用 `spring-aspects.jar`，激活审计功能只需将 Spring Data JPA 审计命名空间元素添加到配置中，如下所示：

```xml
<jpa:auditing auditor-aware-ref="yourAuditorAwareBean" />
```

从 Spring Data JPA 1.5 开始，您可以通过使用 `@EnableJpaAuditing` 注解来注解配置类来启用审计。您仍然必须修改 `orm.xml` 文件，并在类路径上具有 `spring-aspects.jar`。以下示例显示了如何使用 `@EnableJpaAuditing` 注解：

```java
@Configuration
@EnableJpaAuditing
class Config {

  @Bean
  public AuditorAware<AuditableUser> auditorProvider() {
    return new AuditorAwareImpl();
  }
}
```

如果您向 `ApplicationContext` 公开 `AuditorAware` 类型的 bean，审计基础结构会自动选择它并使用它来确定要在域类型上设置的当前用户。如果在 `ApplicationContext` 中注册了多个实现，则可以通过显式设置 `@EnableJpaAuditing` 的 `auditorAwareRef` 属性来选择要使用的实现。

## 5.2 其他注意事项

### 5.2.1 在自定义实现中使用 JpaContext

使用多个 `EntityManager` 实例和自定义存储库实现时，需要将正确的 `EntityManager` 连接到存储库实现类中。您可以通过在 `@PersistenceContext` 注解中显式命名 `EntityManager`，或者如果 `EntityManager` 是 `@Autowired`，则使用 `@Qualifier`。

从 Spring Data JPA 1.9 开始，Spring Data JPA 包含一个名为 `JpaContext` 的类，该类允许您通过托管域类获取 `EntityManager`，假设它仅由应用程序中的一个 `EntityManager` 实例管理。以下示例显示如何在自定义存储库中使用 `JpaContext`：

```java
class UserRepositoryImpl implements UserRepositoryCustom {

  private final EntityManager em;

  @Autowired
  public UserRepositoryImpl(JpaContext context) {
    this.em = context.getEntityManagerByManagedType(User.class);
  }

  …
}
```

这种方法的优点是，如果将域类型分配给不同的持久性单元，则不必使用存储库来更改对持久性单元的引用。

### 5.2.2 合并持久层单位

Spring 支持具有多个持久性单元。然而，有时，您可能希望将应用程序模块化，但仍然要确保所有这些模块都在一个持久性单元中运行。为了实现这种行为，Spring Data JPA 提供了一个 `PersistenceUnitManager` 实现，该实现根据持久性单元的名称自动合并持久性单元，如下例所示：

```xml
<bean class="….LocalContainerEntityManagerFactoryBean">
  <property name="persistenceUnitManager">
    <bean class="….MergingPersistenceUnitManager" />
  </property>
</bean>
```

#### @Entity 类和 JPA 映射文件的 Classpath 扫描

普通的 JPA 设置要求在 `orm.xml` 中列出所有注释映射的实体类。这同样适用于 xml 映射文件。Spring Data JPA 提供了一个 `ClasspathScanningPersistenceUnitPostProcessor`，它配置了一个基本包，并可选地采用映射文件名模式。然后，它扫描给定的包，查找用 `@Entity` 或 `@MappedSuperclass` 注解的类，加载与文件名模式匹配的配置文件，并将它们交给 JPA 配置。后置处理器必须配置如下：

```xml
<bean class="….LocalContainerEntityManagerFactoryBean">
  <property name="persistenceUnitPostProcessors">
    <list>
      <bean class="org.springframework.data.jpa.support.ClasspathScanningPersistenceUnitPostProcessor">
        <constructor-arg value="com.acme.domain" />
        <property name="mappingFileNamePattern" value="**/*Mapping.xml" />
      </bean>
    </list>
  </property>
</bean>
```

> 从 Spring 3.1 开始，可以在 `LocalContainerEntityManagerFactoryBean` 上直接配置要扫描的包，以启用实体类的类路径扫描。有关详细信息，请参阅 JavaDoc。

### 5.2.3 CDI 整合

存储库接口的实例通常由一个容器创建，因此在使用 Spring Data 时，Spring 是最自然的选择。Spring 为创建 bean 实例提供了复杂的支持，如创建存储库实例中所述。从 1.1.0 版开始，Spring Data JPA 附带了一个自定义 CDI 扩展，允许在 CDI 环境中使用存储库抽象。该扩展是 JAR 的一部分。要激活它，请在类路径中包含Spring Data JPA JAR。

现在，您可以通过为 `EntityManagerFactory` 和 `EntityManager` 实现 CDI Producer 来设置基础结构，如下例所示：

```java
class EntityManagerFactoryProducer {

  @Produces
  @ApplicationScoped
  public EntityManagerFactory createEntityManagerFactory() {
    return Persistence.createEntityManagerFactory("my-persistence-unit");
  }

  public void close(@Disposes EntityManagerFactory entityManagerFactory) {
    entityManagerFactory.close();
  }

  @Produces
  @RequestScoped
  public EntityManager createEntityManager(EntityManagerFactory entityManagerFactory) {
    return entityManagerFactory.createEntityManager();
  }

  public void close(@Disposes EntityManager entityManager) {
    entityManager.close();
  }
}
```

所需的设置可能因 JavaEE 环境而异。您可能只需要将 `EntityManager` 重新声明为 CDI bean，如下所示：

```java
class CdiConfig {

  @Produces
  @RequestScoped
  @PersistenceContext
  public EntityManager entityManager;
}
```

在前面的示例中，容器必须能够创建 JPA `EntityManagers` 本身。所有的配置都是将 JPA `EntityManager` 重新导出为 CDI bean。

Spring Data JPA CDI 扩展将所有可用的 `EntityManager` 实例作为 CDI bean，并在容器请求存储库类型的 bean 时为 Spring Data 存储库创建代理。因此，获取 Spring Data 存储库的实例需要声明 `@Injected` 属性，如下例所示：

```java
class RepositoryClient {

  @Inject
  PersonRepository repository;

  public void businessMethod() {
    List<Person> people = repository.findAll();
  }
}
```

## 5.3 Spring Data Envers

### 5.3.1 什么是 Spring Data Envers？

Spring Data Envers 使典型的 Envers 查询在 Spring Data JPA 的存储库中可用。它与其他 Spring Data 模块的不同之处在于，它总是与另一个 Spring Data 模块结合使用：Spring Data JPA。

### 5.3.2 什么是 Envers？

Envers 是一个 Hibernate 模块，它为 JPA 实体添加了审计功能。本文档假设您熟悉Envers，因为 Spring Data Envers 依赖于正确配置 Envers 一样。

### 5.3.3 配置

作为使用 Spring Data Envers 的一个起点，您需要一个在类路径上具有 Spring Data JPA 的项目，以及一个附加的 `spring-data-envers` 依赖项：

```xml
<dependencies>

  <!-- other dependency elements omitted -->

  <dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-envers</artifactId>
    <version>3.0.1</version>
  </dependency>

</dependencies>
```

这也将 `hibernate-envers` 作为暂时依赖项引入项目。

要启用 Spring Data Envers 和 Spring Data JPA，我们需要配置两个 bean 和一个特殊的 `repositoryFactoryBeanClass`：

```java
@Configuration
@EnableEnversRepositories
@EnableTransactionManagement
public class EnversDemoConfiguration {

	@Bean
	public DataSource dataSource() {

		EmbeddedDatabaseBuilder builder = new EmbeddedDatabaseBuilder();
		return builder.setType(EmbeddedDatabaseType.HSQL).build();
	}

	@Bean
	public LocalContainerEntityManagerFactoryBean entityManagerFactory() {

		HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
		vendorAdapter.setGenerateDdl(true);

		LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();
		factory.setJpaVendorAdapter(vendorAdapter);
		factory.setPackagesToScan("example.springdata.jpa.envers");
		factory.setDataSource(dataSource());
		return factory;
	}

	@Bean
	public PlatformTransactionManager transactionManager(EntityManagerFactory entityManagerFactory) {

		JpaTransactionManager txManager = new JpaTransactionManager();
		txManager.setEntityManagerFactory(entityManagerFactory);
		return txManager;
	}
}
```

要实际使用 Spring Data Envers，请将一个或多个存储库作为扩展接口添加到{springdata-commonsjavadoc-base}/org/springframework/Data/resources/history/RevisionRepository.html[`RevisionRepository`]中：

```java
interface PersonRepository
    extends CrudRepository<Person, Long>,
    RevisionRepository<Person, Long, Long> (1)
{}

// (1) 第一个类型参数（`Person`）表示实体类型，第二个参数（`Long`）表示 id 属性的类型，最后一个参数（`Long`）表示修订号的类型。对于默认配置中的 Envers，修订号参数应为 `Integer` 或 `Long`。
```

该存储库的实体必须是启用了 Envers 审核的实体（即，必须具有 `@Audited` 注解）：

```java
@Entity
@Audited
class Person {

	@Id @GeneratedValue
	Long id;
	String name;
	@Version Long version;
}
```

### 5.3.4 使用

现在，您可以使用 `RevisionRepository` 中的方法来查询实体的修订号，如下测试用例所示：

```java
@ExtendWith(SpringExtension.class)
@Import(EnversDemoConfiguration.class) (1)
class EnversIntegrationTests {

	final PersonRepository repository;
	final TransactionTemplate tx;

	EnversIntegrationTests(@Autowired PersonRepository repository, @Autowired PlatformTransactionManager tm) {
		this.repository = repository;
		this.tx = new TransactionTemplate(tm);
	}

	@Test
	void testRepository() {

		Person updated = preparePersonHistory();

		Revisions<Long, Person> revisions = repository.findRevisions(updated.id);

		Iterator<Revision<Long, Person>> revisionIterator = revisions.iterator();

		checkNextRevision(revisionIterator, "John", RevisionType.INSERT);
		checkNextRevision(revisionIterator, "Jonny", RevisionType.UPDATE);
		checkNextRevision(revisionIterator, null, RevisionType.DELETE);
		assertThat(revisionIterator.hasNext()).isFalse();

	}

	/**
    * Checks that the next element in the iterator is a Revision entry referencing a Person
    * with the given name after whatever change brought that Revision into existence.
    * <p>
    * As a side effect the Iterator gets advanced by one element.
    *
    * @param revisionIterator the iterator to be tested.
    * @param name the expected name of the Person referenced by the Revision.
    * @param revisionType the type of the revision denoting if it represents an insert, update or delete.
    */
	private void checkNextRevision(Iterator<Revision<Long, Person>> revisionIterator, String name,
			RevisionType revisionType) {

		assertThat(revisionIterator.hasNext()).isTrue();
		Revision<Long, Person> revision = revisionIterator.next();
		assertThat(revision.getEntity().name).isEqualTo(name);
		assertThat(revision.getMetadata().getRevisionType()).isEqualTo(revisionType);
	}

	/**
    * Creates a Person with a couple of changes so it has a non-trivial revision history.
    * @return the created Person.
    */
	private Person preparePersonHistory() {

		Person john = new Person();
		john.setName("John");

		// create
		Person saved = tx.execute(__ -> repository.save(john));
		assertThat(saved).isNotNull();

		saved.setName("Jonny");

		// update
		Person updated = tx.execute(__ -> repository.save(saved));
		assertThat(updated).isNotNull();

		// delete
		tx.executeWithoutResult(__ -> repository.delete(updated));
		return updated;
	}
}

// (1) 这引用了前面介绍的应用程序上下文配置（在配置部分）。
```

### 5.3.5 其他资源

您可以在 Spring Data Examples 仓库中下载 Spring Data Envers 示例并使用来了解库的工作方式。

您还应该查看 {springdata-commonsjavadoc-base}.org/springframework/data/resources/history/RevisionRepository.html[`RevisionStore` Javadoc] 和相关类。

您可以使用 `spring-data-envers` 标签在 Stacksoverflow 中提问。

Spring Data Envers 的源代码和问题跟踪器托管在 GitHub 上。

# 6 附录

## 附录 A：命名空间引用

### `<repositories/>` 元素

`<repositions/>` 元素触发 Spring Data 存储库基础设施的设置。最重要的属性是 `base-package`，它定义了要扫描 Spring Data 存储库接口的包。请参阅“XML 配置”。下表描述了 `<repositories/>` 元素的属性：

| 名字                           | 描述                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| `base-package`                 | 定义要扫描的包，以查找在自动检测模式下扩展 `*repository`（实际接口由特定的 Spring Data 模块确定）的存储库接口。也会扫描配置包下的所有包。允许使用通配符。 |
| `repository-impl-postfix`      | 定义后缀以自动检测自定义存储库实现。名称以配置的后缀结尾的类被视为候选类。默认为 `Impl`。 |
| `query-lookup-strategy`        | 确定用于创建查找器查询的策略。有关详细信息，请参阅“查询查找策略”。默认为 `create-if-not-found`。 |
| `named-queries-location`       | 定义搜索包含外部定义查询的属性文件的位置。                   |
| `consider-nested-repositories` | 是否应考虑嵌套存储库接口定义。默认为 `false`。               |

## 附录 B：填充器命名空间引用

### `<populator/>` 元素

`<populator/>` 元素允许通过 Spring Data 存储库基础结构填充数据存储。

| 名字        | 描述                                               |
| ----------- | -------------------------------------------------- |
| `locations` | 查找从应填充的存储库中要读取的的对象的文件的位置。 |

## 附录C：存储库查询关键字

### 支持的查询方法主题关键字

下表列出了 Spring Data 存储库查询派生机制通常支持的主题关键字，以表示谓词。有关支持的关键字的确切列表，请参阅特定于存储的文档，因为此处列出的某些关键字可能在特定存储中不受支持。

| 关键字                                                       | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `find…By`, `read…By`, `get…By`, `query…By`, `search…By`, `stream…By` | 常规查询方法通常返回存储库类型、`Collection `或 `Streamable` 子类型或结果包装器，如 `Page`、`GeoResults` 或任何其他特定于存储的结果包装器。可以用作 `findBy…`、`findMyDomainTypeBy…` 或与其他关键字组合使用。 |
| `exists…By`                                                  | 存在投射，通常返回 `boolean` 结果。                          |
| `count…By`                                                   | 返回数字结果的计数投射。                                     |
| `delete…By`, `remove…By`                                     | 删除查询方法不返回结果（`void`）或返回删除计数。             |
| `…First<number>…`, `…Top<number>…`                           | 将查询结果限制为第一个 `<number>` 结果。此关键字可以出现在主题的 `find`（以及其他关键字）和 `by` 之间的任何位置。 |
| `…Distinct…`                                                 | 使用 distinct 查询只返回独特各异的结果。是否支持该功能，请查阅特定于存储的文档。此关键字可以出现在主题的 `find`（以及其他关键字）和 `by` 之间的任何位置。 |

### 支持的查询方法谓词关键字和修饰符

下表列出了 Spring Data 存储库查询派生机制通常支持的谓词关键字。但是，请查阅特定于存储的文档以获取支持的关键字的确切列表，因为此处列出的某些关键字可能在特定存储中不受支持。

| 逻辑关键字            | 关键字表达式                                   |
| :-------------------- | :--------------------------------------------- |
| `AND`                 | `And`                                          |
| `OR`                  | `Or`                                           |
| `AFTER`               | `After`, `IsAfter`                             |
| `BEFORE`              | `Before`, `IsBefore`                           |
| `CONTAINING`          | `Containing`, `IsContaining`, `Contains`       |
| `BETWEEN`             | `Between`, `IsBetween`                         |
| `ENDING_WITH`         | `EndingWith`, `IsEndingWith`, `EndsWith`       |
| `EXISTS`              | `Exists`                                       |
| `FALSE`               | `False`, `IsFalse`                             |
| `GREATER_THAN`        | `GreaterThan`, `IsGreaterThan`                 |
| `GREATER_THAN_EQUALS` | `GreaterThanEqual`, `IsGreaterThanEqual`       |
| `IN`                  | `In`, `IsIn`                                   |
| `IS`                  | `Is`, `Equals`, (or no keyword)                |
| `IS_EMPTY`            | `IsEmpty`, `Empty`                             |
| `IS_NOT_EMPTY`        | `IsNotEmpty`, `NotEmpty`                       |
| `IS_NOT_NULL`         | `NotNull`, `IsNotNull`                         |
| `IS_NULL`             | `Null`, `IsNull`                               |
| `LESS_THAN`           | `LessThan`, `IsLessThan`                       |
| `LESS_THAN_EQUAL`     | `LessThanEqual`, `IsLessThanEqual`             |
| `LIKE`                | `Like`, `IsLike`                               |
| `NEAR`                | `Near`, `IsNear`                               |
| `NOT`                 | `Not`, `IsNot`                                 |
| `NOT_IN`              | `NotIn`, `IsNotIn`                             |
| `NOT_LIKE`            | `NotLike`, `IsNotLike`                         |
| `REGEX`               | `Regex`, `MatchesRegex`, `Matches`             |
| `STARTING_WITH`       | `StartingWith`, `IsStartingWith`, `StartsWith` |
| `TRUE`                | `True`, `IsTrue`                               |
| `WITHIN`              | `Within`, `IsWithin`                           |

除了筛选器谓词，还支持以下修饰符列表：

| 关键字                             | 描述                                                         |
| :--------------------------------- | :----------------------------------------------------------- |
| `IgnoreCase`, `IgnoringCase`       | 与谓词关键字一起用于不区分大小写的比较。                     |
| `AllIgnoreCase`, `AllIgnoringCase` | 忽略所有适用属性的大小写。在查询方法谓词的某处使用。         |
| `OrderBy…`                         | 指定静态排序顺序，后跟属性路径和方向（例如`OrderByFirstnameAscLastnameDesc`）。 |

## 附录 D：存储库查询返回类型

### 支持的查询返回类型

下表列出了 Spring Data 存储库通常支持的返回类型。但是，请查阅特定于存储的文档，以获得支持的返回类型的确切列表，因为此处列出的某些类型可能在特定存储中不受支持。

> 地理空间类型（如 `GeoResult`、`GeoResults` 和 `GeoPage`）仅适用于支持地理空间查询的数据存储。一些存储模块可以定义自己的结果包装器类型。

| 返回类型                                                     | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `void`                                                       | 表示无返回值。                                               |
| 基本类型                                                     | Java 基本类型.                                               |
| 包装类型                                                     | Java 包装类型.                                               |
| `T`                                                          | 唯一的实体。要求查询方法最多返回一个结果。如果未找到结果，则返回 `null`。多个结果触发 `IncorrectResultSizeDataAccessException`。 |
| `Iterator<T>`                                                | 一个 `Iterator`.                                             |
| `Collection<T>`                                              | 一个 `Collection`.                                           |
| `List<T>`                                                    | 一个 `List`.                                                 |
| `Optional<T>`                                                | Java 8 或 Guava `Optional`。要求查询方法最多返回一个结果。如果未找到结果，则返回 `Optional.empty()` 或 `Optional.absent()`。多个结果触发 `IncorrectResultSizeDataAccessException`。 |
| `Option<T>`                                                  | Scala 或 Vavr `Option` 类型。在语义上与前面描述的 Java 8 的 `Optional` 行为相同。 |
| `Stream<T>`                                                  | 一个 Java 8 `Stream`.                                        |
| `Streamable<T>`                                              | `Iterable` 的一个方便扩展，它直接将方法公开给流、映射和过滤结果，并将它们连接起来。 |
| 实现 `Streamable` 并采用 `Streamable` 构造函数或工厂方法参数的类型 | 公开构造函数或以 `Streamable` 为参数的 `….of(…)`/`….valueOf(…)`工厂方法的类型。请参阅[返回自定义可流式包装类型](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#repositories.collections-和iterables.streamablewrapper)获取详细信息。 |
| Vavr `Seq`, `List`, `Map`, `Set`                             | Vavr 集合类型。参见[支持Vavr集合](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#repositories.collections-and-iterables.vavr)获取详细信息。 |
| `Future<T>`                                                  | 一个 `Future`。要求使用 `@Async` 注解方法，并要求启用 Spring 的异步方法执行功能。 |
| `CompletableFuture<T>`                                       | Java 8 `CompletableFuture`。要求使用 `@Async` 注解方法，并要求启用 Spring 的异步方法执行功能。 |
| `Slice<T>`                                                   | 带有是否有更多可用数据指示的大小数据块。需要 `Pageable` 方法参数。 |
| `Page<T>`                                                    | 带有附加信息（如结果总数）的 `Slice`。需要 `Pageable` 方法参数。 |
| `GeoResult<T>`                                               | 带有附加信息的结果条目，例如到参考位置的距离。               |
| `GeoResults<T>`                                              | `GeoResult<T>` 列表，其中包含其他信息，例如到参考位置的平均距离。 |
| `GeoPage<T>`                                                 | 带有 `GeoResult<T>` 的 `Page`，例如到参考位置的平均距离。    |
| `Mono<T>`                                                    | 一个使用反应性存储库发射零个或一个元素的 Project Reactor `Mono`。要求查询方法最多返回一个结果。如果未找到结果，则返回 `Mono.empty()`。多个结果触发 `IncorrectResultSizeDataAccessException`。 |
| `Flux<T>`                                                    | 使用反应性储存库排放零、一或多个元素的 Project Reactor `Flux`。返回 `Flux` 的查询还可以发出无限数量的元素。 |
| `Single<T>`                                                  | 使用反应式存储库发出单个元素的 RxJava `Single`。要求查询方法最多返回一个结果。如果未找到结果，则返回 `Mono.empty()`。多个结果触发 `IncorrectResultSizeDataAccessException`。 |
| `Maybe<T>`                                                   | 使用反应式存储库发射零个或一个元素的 RxJava `Maybe`。要求查询方法最多返回一个结果。如果未找到结果，则返回 `Mono.empty()`。多个结果触发 `IncorrectResultSizeDataAccessException`。 |
| `Flowable<T>`                                                | 使用反应式存储库发射零个、一个或多个元素的 RxJava `Flowable`。返回 `Flowable` 的查询还可以发出无限数量的元素。 |

## 附录 E：经常问的问题

## 附录 F：术语表