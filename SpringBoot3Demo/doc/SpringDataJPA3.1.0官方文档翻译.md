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

要自定义此行为，请分别注册一个实现 `PageableHandlerMethodArgumentResolverCustomizer` 接口或 `SortHandlerMethodargumentResolveCustomizer` 界面的 bean。它的 `customize()` 方法被调用，允许您更改设置，如下例所示：

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

