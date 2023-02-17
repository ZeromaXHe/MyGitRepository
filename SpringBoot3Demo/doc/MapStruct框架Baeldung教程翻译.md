https://www.baeldung.com/mapstruct

# MapStruct 快速指南

# 1. 总览

在这个教程，我们将探索 MapStruct 的使用，简单来说也就是一个 Java Bean 映射工具。

这个 API 包括自动在两个 Java Bean 之间映射的函数。通过 MapStruct，我们只需要创建接口，库将在编译期自动创建具体实现。

# 2. MapStruct 和传输对象模式

对于大多数应用程序，您会注意到许多将 POJO 转换为其他 POJO 的样板代码。

例如，一种常见类型的转换发生在持久层支持的实体和到达客户端的 DTO 之间。

因此，这就是 MapStruct 解决的问题：手动创建 bean 映射器非常耗时。但是库**可以自动生成 bean 映射器类**。

# 3. Maven

让我们添加以下依赖到我们 Maven `pom.xml`：

```xml
<dependency>
    <groupId>org.mapstruct</groupId>
    <artifactId>mapstruct</artifactId>
    <version>1.5.3.Final</version> 
</dependency>
```

MapStruct 及其处理器的最新稳定版本均可从 Maven Central Repository 获得。

让我们将 `annotationProcessorPaths` 部分添加到 maven 编译器插件的配置部分。
`mapstruct-processor` 用于在生成过程中生成映射器实现：

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.5.1</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <annotationProcessorPaths>
            <path>
                <groupId>org.mapstruct</groupId>
                <artifactId>mapstruct-processor</artifactId>
                <version>1.5.3.Final</version>
            </path>
        </annotationProcessorPaths>
    </configuration>
</plugin>
```

# 4. 基本映射

## 4.1 创建 POJO

让我们首先创建一个简单的 Java POJO：

```java
public class SimpleSource {
    private String name;
    private String description;
    // getters and setters
}
 
public class SimpleDestination {
    private String name;
    private String description;
    // getters and setters
}
```

## 4.2 Mapper 接口

```java
@Mapper
public interface SimpleSourceDestinationMapper {
    SimpleDestination sourceToDestination(SimpleSource source);
    SimpleSource destinationToSource(SimpleDestination destination);
}
```

注意，我们没有为 `SimpleSourceDestinationMapper` 创建实现类，因为 MapStruct 为我们创建了它。

## 4.3 新 Mapper

我们可以通过执行 `mvn clean install` 来触发 MapStruct 处理。

这将在 `/target/generated sources/annotations/` 下生成实现类。

以下是 MapStruct 自动为我们创建的类：

```java
public class SimpleSourceDestinationMapperImpl
  implements SimpleSourceDestinationMapper {
    @Override
    public SimpleDestination sourceToDestination(SimpleSource source) {
        if ( source == null ) {
            return null;
        }
        SimpleDestination simpleDestination = new SimpleDestination();
        simpleDestination.setName( source.getName() );
        simpleDestination.setDescription( source.getDescription() );
        return simpleDestination;
    }
    @Override
    public SimpleSource destinationToSource(SimpleDestination destination){
        if ( destination == null ) {
            return null;
        }
        SimpleSource simpleSource = new SimpleSource();
        simpleSource.setName( destination.getName() );
        simpleSource.setDescription( destination.getDescription() );
        return simpleSource;
    }
}
```

## 4.4 测试案例

最后，在生成所有内容后，让我们编写一个测试用例，显示 `SimpleSource` 中的值与 `SimpleDestination` 中的值匹配：

```java
public class SimpleSourceDestinationMapperIntegrationTest {
    private SimpleSourceDestinationMapper mapper
      = Mappers.getMapper(SimpleSourceDestinationMapper.class);
    @Test
    public void givenSourceToDestination_whenMaps_thenCorrect() {
        SimpleSource simpleSource = new SimpleSource();
        simpleSource.setName("SourceName");
        simpleSource.setDescription("SourceDescription");
        SimpleDestination destination = mapper.sourceToDestination(simpleSource);
 
        assertEquals(simpleSource.getName(), destination.getName());
        assertEquals(simpleSource.getDescription(), 
          destination.getDescription());
    }
    @Test
    public void givenDestinationToSource_whenMaps_thenCorrect() {
        SimpleDestination destination = new SimpleDestination();
        destination.setName("DestinationName");
        destination.setDescription("DestinationDescription");
        SimpleSource source = mapper.destinationToSource(destination);
        assertEquals(destination.getName(), source.getName());
        assertEquals(destination.getDescription(),
          source.getDescription());
    }
}
```

# 5. 通过依赖注入的映射

接下来，让我们通过调用 `Mappers.getMapper(YourClass.class)` 来获取 MapStruct 中的映射器实例。

当然，这是一种非常手动的获取实例的方法。然而，更好的选择是直接在需要的地方注入映射器（如果我们的项目使用任何依赖注入解决方案）。

**幸运的是，MapStruct 支持 Spring 和 CDI**（上下文和依赖注入）。

要在映射器中使用 Spring IoC，我们需要将 `componentModel` 属性添加到 `@Mapper` 中，值为 `spring`，而对于 CDI，值为 `cdi`。

## 5.1 修改 Mapper

添加下面代码到 `SimpleSourceDestinationMapper`：

```java
@Mapper(componentModel = "spring")
public interface SimpleSourceDestinationMapper
```

## 5.2 将 Spring 组件注入到 Mapper

有时，我们需要在映射逻辑中使用其他 Spring 组件。在这种情况下，**我们必须使用抽象类而不是接口**：

```java
@Mapper(componentModel = "spring")
public abstract class SimpleDestinationMapperUsingInjectedService
```

然后，我们可以使用众所周知的 `@Autowired` 注解轻松地注入所需的组件，并在代码中使用它：

```java
@Mapper(componentModel = "spring")
public abstract class SimpleDestinationMapperUsingInjectedService {

    @Autowired
    protected SimpleService simpleService;

    @Mapping(target = "name", expression = "java(simpleService.enrichName(source.getName()))")
    public abstract SimpleDestination sourceToDestination(SimpleSource source);
}
```

**我们必须记住不要将注入的 bean 私有化！**这是因为 MapStruct 必须访问生成的实现类中的对象。

# 6. 映射不同名字的字段

在前面的示例中，MapStruct 能够自动映射 bean，因为它们具有相同的字段名。那么，如果我们要映射的 bean 具有不同的字段名呢？

在本例中，我们将创建一个名为 `Employee` 和 `EmployeeDTO` 的新 bean

## 6.1 新的 POJO

```java
public class EmployeeDTO {
    private int employeeId;
    private String employeeName;
    // getters and setters
}
```

```java
public class Employee {
    private int id;
    private String name;
    // getters and setters
}
```

## 6.2 Mapper 接口

当映射不同的字段名时，我们需要将其源字段配置为目标字段，为此，我们需要为每个字段添加 `@Mapping` 注解。

在 MapStruct 中，我们还可以使用点符号来定义 bean 的成员：

```java
@Mapper
public interface EmployeeMapper {
    
    @Mapping(target="employeeId", source="entity.id")
    @Mapping(target="employeeName", source="entity.name")
    EmployeeDTO employeeToEmployeeDTO(Employee entity);

    @Mapping(target="id", source="dto.employeeId")
    @Mapping(target="name", source="dto.employeeName")
    Employee employeeDTOtoEmployee(EmployeeDTO dto);
}
```

## 6.3 测试用例

同样，我们需要测试源和目标对象值是否匹配：

```java
@Test
public void givenEmployeeDTOwithDiffNametoEmployee_whenMaps_thenCorrect() {
    EmployeeDTO dto = new EmployeeDTO();
    dto.setEmployeeId(1);
    dto.setEmployeeName("John");

    Employee entity = mapper.employeeDTOtoEmployee(dto);

    assertEquals(dto.getEmployeeId(), entity.getId());
    assertEquals(dto.getEmployeeName(), entity.getName());
}
```

更多测试用例可以在 GitHub 项目中找到。

# 7. 映射具有子 Bean 的 Bean

接下来，我们将展示如何将一个 bean 映射到其他 bean 的引用。

## 7.1 修改 POJO

让我们给 `Employee` 对象添加一个新的 bean 引用：

```java
public class EmployeeDTO {
    private int employeeId;
    private String employeeName;
    private DivisionDTO division;
    // getters and setters omitted
}
```

```java
public class Employee {
    private int id;
    private String name;
    private Division division;
    // getters and setters omitted
}
```

```java
public class Division {
    private int id;
    private String name;
    // default constructor, getters and setters omitted
}
```

## 7.2 修改 Mapper

这里我们需要添加一种方法，将 `Division` 转换为 `DivisionDTO`，反之亦然；如果 MapStruct 检测到需要转换对象类型，并且要转换的方法存在于同一类中，它将自动使用它。

让我们将其添加到映射器中：

```java
DivisionDTO divisionToDivisionDTO(Division entity);

Division divisionDTOtoDivision(DivisionDTO dto);
```

## 7.3 修改测试用例

让我们修改并添加一些测试用例到之前已存在的测试：

```java
@Test
public void givenEmpDTONestedMappingToEmp_whenMaps_thenCorrect() {
    EmployeeDTO dto = new EmployeeDTO();
    dto.setDivision(new DivisionDTO(1, "Division1"));
    Employee entity = mapper.employeeDTOtoEmployee(dto);
    assertEquals(dto.getDivision().getId(), 
      entity.getDivision().getId());
    assertEquals(dto.getDivision().getName(), 
      entity.getDivision().getName());
}
```

# 8. 具有类型转换的映射

MapStruct 还提供了一些现成的隐式类型转换，对于我们的示例，我们将尝试将 String 日期转换为实际的 `Date` 对象。

有关隐式类型转换的更多详细信息，请查看 [MapStruct 参考指南](https://mapstruct.org/documentation/stable/reference/html/)。

## 8.1 修改 Bean

我们为我们的职员添加一个开始日期：

```java
public class Employee {
    // other fields
    private Date startDt;
    // getters and setters
}
```

```java
public class EmployeeDTO {
    // other fields
    private String employeeStartDt;
    // getters and setters
}
```

## 8.2 修改 Mapper

我们修改映射器并提供 `dataFormat` 给我们的开始日期。

```java

  @Mapping(target="employeeId", source = "entity.id")
  @Mapping(target="employeeName", source = "entity.name")
  @Mapping(target="employeeStartDt", source = "entity.startDt",
           dateFormat = "dd-MM-yyyy HH:mm:ss")
EmployeeDTO employeeToEmployeeDTO(Employee entity);

  @Mapping(target="id", source="dto.employeeId")
  @Mapping(target="name", source="dto.employeeName")
  @Mapping(target="startDt", source="dto.employeeStartDt",
           dateFormat="dd-MM-yyyy HH:mm:ss")
Employee employeeDTOtoEmployee(EmployeeDTO dto);
```

## 8.3 修改测试用例

让我们添加更多一些测试用例来验证转换是否正确：

```java
private static final String DATE_FORMAT = "dd-MM-yyyy HH:mm:ss";
@Test
public void givenEmpStartDtMappingToEmpDTO_whenMaps_thenCorrect() throws ParseException {
    Employee entity = new Employee();
    entity.setStartDt(new Date());
    EmployeeDTO dto = mapper.employeeToEmployeeDTO(entity);
    SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT);
 
    assertEquals(format.parse(dto.getEmployeeStartDt()).toString(),
      entity.getStartDt().toString());
}
@Test
public void givenEmpDTOStartDtMappingToEmp_whenMaps_thenCorrect() throws ParseException {
    EmployeeDTO dto = new EmployeeDTO();
    dto.setEmployeeStartDt("01-04-2016 01:00:00");
    Employee entity = mapper.employeeDTOtoEmployee(dto);
    SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT);
 
    assertEquals(format.parse(dto.getEmployeeStartDt()).toString(),
      entity.getStartDt().toString());
}
```

# 9. 抽象类的映射

有时，我们可能希望以超出 `@Mapping` 功能的方式自定义映射器。

例如，除了类型转换之外，我们可能还希望以某种方式转换值，如下面的示例所示。

在这种情况下，我们可以创建一个抽象类并实现我们想要定制的方法，并将那些应该由 MapStruct 生成的方法保留为抽象类。

## 9.1 基本模型

在这个例子中，我们将使用如下类：

```java
public class Transaction {
    private Long id;
    private String uuid = UUID.randomUUID().toString();
    private BigDecimal total;

    //standard getters
}
```

和一个对应的 DTO：

```java
public class TransactionDTO {

    private String uuid;
    private Long totalInCents;

    // standard getters and setters
}
```

这里的棘手部分是将 `BigDecimal` `total` 的美元总额转换为 `Long` `totalInCents`。

## 9.2 定义 Mapper

我们可以通过将我们的 Mapper 创建为抽象类来实现这个目标：

```java
@Mapper
abstract class TransactionMapper {

    public TransactionDTO toTransactionDTO(Transaction transaction) {
        TransactionDTO transactionDTO = new TransactionDTO();
        transactionDTO.setUuid(transaction.getUuid());
        transactionDTO.setTotalInCents(transaction.getTotal()
          .multiply(new BigDecimal("100")).longValue());
        return transactionDTO;
    }

    public abstract List<TransactionDTO> toTransactionDTO(
      Collection<Transaction> transactions);
}
```

在这里，我们已经为单个对象转换实现了完全定制的映射方法。

另一方面，我们留下了方法，这意味着将 `Collection` 映射到 `List` 抽象，因此 MapStruct 将为我们实现它。

## 9.3 生成的结果

由于我们已经实现了将单个 `Transaction` 映射到 `TransactionDTO` 的方法，因此我们希望 MapStruct 在第二个方法中使用它。

将生成以下内容：

```java
@Generated
class TransactionMapperImpl extends TransactionMapper {

    @Override
    public List<TransactionDTO> toTransactionDTO(Collection<Transaction> transactions) {
        if ( transactions == null ) {
            return null;
        }

        List<TransactionDTO> list = new ArrayList<>();
        for ( Transaction transaction : transactions ) {
            list.add( toTransactionDTO( transaction ) );
        }

        return list;
    }
}
```

我们可以在第 12 行中看到，MapStruct 在生成的方法中使用了我们实现。

# 10. Mapping 前后注解

这里有另一种使用 `@BeforeMapping` 和 `@AfterMapping` 注解自定义 `@Mapping` 功能的方法。**该注解用于标记映射逻辑前后调用的方法**。

它们在我们可能希望将此**行为应用于所有映射的超类型**的场景中非常有用。

让我们看一个将 `Car` `ElectricCar` 和 `BioDieselCar` 的子类型映射到 `CarDTO` 的示例。

在映射时，我们希望将类型的概念映射到 DTO 中的 `FuelType` 枚举字段。映射完成后，我们希望将 DTO 的名称更改为大写。

## 10.1 基本模型

我们将使用下面类：

```java
public class Car {
    private int id;
    private String name;
}
```

`Car` 的子类：

```java
public class BioDieselCar extends Car {
}
```

```java
public class ElectricCar extends Car {
}
```

具有枚举类型 `FuelType` 的 `CarDTO`：

```java
public class CarDTO {
    private int id;
    private String name;
    private FuelType fuelType;
}
```

```java
public enum FuelType {
    ELECTRIC, BIO_DIESEL
}
```

## 10.2 定义 Mapper

让我们继续编写我们的抽象 mapper 类来映射 `Car` 到 `CarDTO`：

```java
@Mapper
public abstract class CarsMapper {
    @BeforeMapping
    protected void enrichDTOWithFuelType(Car car, @MappingTarget CarDTO carDto) {
        if (car instanceof ElectricCar) {
            carDto.setFuelType(FuelType.ELECTRIC);
        }
        if (car instanceof BioDieselCar) { 
            carDto.setFuelType(FuelType.BIO_DIESEL);
        }
    }

    @AfterMapping
    protected void convertNameToUpperCase(@MappingTarget CarDTO carDto) {
        carDto.setName(carDto.getName().toUpperCase());
    }

    public abstract CarDTO toCarDto(Car car);
}
```

`@MappingTarget` 是一个参数注解，在 `@BeforeMapping` 的情况下在执行映射逻辑之前，在 `@AfterMapping` 注解方法的情况下在执行之后，填充目标映射 DTO。

## 10.3 结果

**上面的 `CarsMapper` 定义生成了实现：**

```java
@Generated
public class CarsMapperImpl extends CarsMapper {

    @Override
    public CarDTO toCarDto(Car car) {
        if (car == null) {
            return null;
        }

        CarDTO carDTO = new CarDTO();

        enrichDTOWithFuelType(car, carDTO);

        carDTO.setId(car.getId());
        carDTO.setName(car.getName());

        convertNameToUpperCase(carDTO);

        return carDTO;
    }
}
```

注意在实现中**注解方法调用如何围绕映射逻辑**。

# 11. Lombok 支持

在 MapStruct 的最新版本中，宣布了对 Lombok 的支持。**因此，我们可以使用 Lombok 轻松地映射源实体和目标。**

要启用 Lombok 支持，我们需要在注解处理器路径中添加依赖项。从 Lombok 版本 1.18.16 开始，我们还必须添加对 `lombok-mapstruct-binding` 的依赖。现在我们在 Maven 编译器插件中有了 `mapstruct-processor` 和 Lombok：

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.5.1</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <annotationProcessorPaths>
            <path>
                <groupId>org.mapstruct</groupId>
                <artifactId>mapstruct-processor</artifactId>
                <version>1.5.3.Final</version>
            </path>
            <path>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
	        <version>1.18.4</version>
            </path>
            <path>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok-mapstruct-binding</artifactId>
	        <version>0.2.0</version>
            </path>
        </annotationProcessorPaths>
    </configuration>
</plugin>
```

让我们使用 Lombok 注解定义源实体：

```java
@Getter
@Setter
public class Car {
    private int id;
    private String name;
}
```

和目标数据转换对象：

```java
@Getter
@Setter
public class CarDTO {
    private int id;
    private String name;
}
```

用于此的映射器接口与前面的示例类似：

```java
@Mapper
public interface CarMapper {
    CarMapper INSTANCE = Mappers.getMapper(CarMapper.class);
    CarDTO carToCarDTO(Car car);
}
```

# 12. defaultExpression 支持

从 1.3.0 版开始，如果源字段为空，我们可以使用 `@Mapping` 注解的 `defaultExpression` 属性来指定一个表达式，该表达式确定目标字段的值。这是对现有 `defaultValue` 属性功能的补充。

源实体：

```java
public class Person {
    private int id;
    private String name;
}
```

目标数据传输对象：

```java
public class PersonDTO {
    private int id;
    private String name;
}
```

如果源实体的 `id` 字段为 `null`，我们希望生成一个随机 `id` 并将其分配给目标，保持其他属性值不变：

```java
@Mapper
public interface PersonMapper {
    PersonMapper INSTANCE = Mappers.getMapper(PersonMapper.class);
    
    @Mapping(target = "id", source = "person.id", 
      defaultExpression = "java(java.util.UUID.randomUUID().toString())")
    PersonDTO personToPersonDTO(Person person);
}
```

让我们添加一个测试用例来验证表达式的执行：

```java
@Test
public void givenPersonEntitytoPersonWithExpression_whenMaps_thenCorrect() 
    Person entity  = new Person();
    entity.setName("Micheal");
    PersonDTO personDto = PersonMapper.INSTANCE.personToPersonDTO(entity);
    assertNull(entity.getId());
    assertNotNull(personDto.getId());
    assertEquals(personDto.getName(), entity.getName());
}
```

# 13. 结论

本文介绍了 MapStruct。我们已经介绍了 Mapping 库的大部分基础知识以及如何在应用程序中使用它。

这些示例和测试的实现可以在 GitHub 项目中找到。这是一个 Maven 项目，因此应该很容易导入并按原样运行。