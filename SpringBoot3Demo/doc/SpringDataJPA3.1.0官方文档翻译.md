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