# Jackson 注解示例

# 1. 总览

在本教程中，我们将深入了解 **Jackson 注解**。

我们将看到如何使用现有注解，如何创建自定义注解，最后，如何禁用它们。

# 2. Jackson 序列化注解

首先，我们将了解序列化注解。

## 2.1 @JsonAnyGetter

`@JsonAnyGetter` 注解允许像标准属性那样使用 Map 字段的灵活性。

例如，`ExtendableBean` 实体具有 `name` 属性和一组在键值对中的可扩展属性：

```java
public class ExtendableBean {
    public String name;
    private Map<String, String> properties;

    @JsonAnyGetter
    public Map<String, String> getProperties() {
        return properties;
    }
}
```

当我们序列化此实体的实例时，我们将 `Map` 中的所有键值作为标准的普通属性：

```json
{
    "name":"My bean",
    "attr2":"val2",
    "attr1":"val1"
}
```

这是该实体的序列化在实战中使用的样子：

```java
@Test
public void whenSerializingUsingJsonAnyGetter_thenCorrect()
  throws JsonProcessingException {
 
    ExtendableBean bean = new ExtendableBean("My bean");
    bean.add("attr1", "val1");
    bean.add("attr2", "val2");

    String result = new ObjectMapper().writeValueAsString(bean);
 
    assertThat(result, containsString("attr1"));
    assertThat(result, containsString("val1"));
}
```

我们还可以使用启用为 `false` 的可选参数来禁用 `@JsonAnyGetter()`。在这种情况下，Map 将转换为 JSON，并在序列化后显示在 `properties` 变量下。

## 2.2 @JsonGetter

`@JsonGetter` 注解是 `@JsonProperty` 注解的一种替代方法，该注解将方法标记为 getter 方法。

在下面的示例中，我们将 `getTheName()` 方法指定为 `MyBean` 实体的 `name` 属性的 getter 方法：

```java
public class MyBean {
    public int id;
    private String name;

    @JsonGetter("name")
    public String getTheName() {
        return name;
    }
}
```

这是它在实战中使用的样子：

```java
@Test
public void whenSerializingUsingJsonGetter_thenCorrect()
  throws JsonProcessingException {
 
    MyBean bean = new MyBean(1, "My bean");

    String result = new ObjectMapper().writeValueAsString(bean);
 
    assertThat(result, containsString("My bean"));
    assertThat(result, containsString("1"));
}
```

## 2.3 @JsonPropertyOrder

我们可以使用 `@JsonPropertyOrder` 注解来指定**序列化时属性的顺序**。

让我们给 `MyBean` 实体设置一个属性自定义顺序：

```java
@JsonPropertyOrder({ "name", "id" })
public class MyBean {
    public int id;
    public String name;
}
```

这是序列化的输出：

```json
{
    "name":"My bean",
    "id":1
}
```

然后我们可以做一个简单测试：

```java
@Test
public void whenSerializingUsingJsonPropertyOrder_thenCorrect()
  throws JsonProcessingException {
 
    MyBean bean = new MyBean(1, "My bean");

    String result = new ObjectMapper().writeValueAsString(bean);
    assertThat(result, containsString("My bean"));
    assertThat(result, containsString("1"));
}
```

我们也可以使用 `@JsonPropertyOrder(alphabetic=true)` 让属性按字母表顺序排序。序列化输出将如下：

```json
{
    "id":1,
    "name":"My bean"
}
```

## 2.4 @JsonRawValue

`@JsonRawValue` 注解可以**指示 Jackson 按原样序列化属性**。

在以下示例中，我们使用 `@JsonRawValue` 嵌入一些自定义 JSON 作为实体的值：

```java
public class RawBean {
    public String name;

    @JsonRawValue
    public String json;
}
```

序列化该实体的输出如下：

```json
{
    "name":"My bean",
    "json":{
        "attr":false
    }
}
```

这是一个简单测试：

```java
@Test
public void whenSerializingUsingJsonRawValue_thenCorrect()
  throws JsonProcessingException {
 
    RawBean bean = new RawBean("My bean", "{\"attr\":false}");

    String result = new ObjectMapper().writeValueAsString(bean);
    assertThat(result, containsString("My bean"));
    assertThat(result, containsString("{\"attr\":false}"));
}
```

我们也可以使用可选的布尔参数 `value` 来决定这个注解是否激活。

## 2.5 @JsonValue

`@JsonValue` 表示库将用于序列化整个实例的单个方法。

例如，在枚举中，我们用 `@JsonValue` 注释 `getName`，以便通过其名称序列化任何此类实体：

```java
public enum TypeEnumWithValue {
    TYPE1(1, "Type A"), TYPE2(2, "Type 2");

    private Integer id;
    private String name;

    // standard constructors

    @JsonValue
    public String getName() {
        return name;
    }
}
```

这是我们的测试：

```java
@Test
public void whenSerializingUsingJsonValue_thenCorrect()
  throws JsonParseException, IOException {
 
    String enumAsString = new ObjectMapper()
      .writeValueAsString(TypeEnumWithValue.TYPE1);

    assertThat(enumAsString, is(""Type A""));
}
```

## 2.6 @JsonRootName

如果启用了包装，则使用 `@JsonRootName` 注解来指定要使用的根包装的名称。

包装意味着不将 `User` 序列化为以下内容：

```json
{
    "id": 1,
    "name": "John"
}
```

它将像这样被包装：

```json
{
    "User": {
        "id": 1,
        "name": "John"
    }
}
```

所以让我们看这个例子。**我们将使用 `@JsonRootName` 注解来指示这个潜在包装类实体的名称**：

```json
@JsonRootName(value = "user")
public class UserWithRoot {
    public int id;
    public String name;
}
```

默认地，包装类的名字将是类名——`UserWithRoot`。使用该注解，我们可以获得 更整洁的 `user`：

```java
@Test
public void whenSerializingUsingJsonRootName_thenCorrect()
  throws JsonProcessingException {
 
    UserWithRoot user = new User(1, "John");

    ObjectMapper mapper = new ObjectMapper();
    mapper.enable(SerializationFeature.WRAP_ROOT_VALUE);
    String result = mapper.writeValueAsString(user);

    assertThat(result, containsString("John"));
    assertThat(result, containsString("user"));
}
```

这是序列化的输出：

```json
{
    "user":{
        "id":1,
        "name":"John"
    }
}
```

从 Jackson 2.4 开始，一个可选的参数 `namespace` 可用于 XML 等数据格式。如果我们添加它，它将成为完全限定名称的一部分：

```java
@JsonRootName(value = "user", namespace="users")
public class UserWithRootNamespace {
    public int id;
    public String name;

    // ...
}
```

如果我们使用 `XmlMapper` 序列化它，输出将是：

```xml
<user xmlns="users">
    <id xmlns="">1</id>
    <name xmlns="">John</name>
    <items xmlns=""/>
</user>
```

## 2.7 @JsonSerialize

`@JsonSerialize` 指示编组实体时要使用的自定义序列化器。

让我们看一个简单的例子。我们将使用 `@JsonSerialize` 使用 `CustomDateSerializer` 序列化 `eventDate` 属性：

```java
public class EventWithSerializer {
    public String name;

    @JsonSerialize(using = CustomDateSerializer.class)
    public Date eventDate;
}
```

这是简单的自定义 Jackson 序列化器：

```java
public class CustomDateSerializer extends StdSerializer<Date> {

    private static SimpleDateFormat formatter 
      = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");

    public CustomDateSerializer() { 
        this(null); 
    } 

    public CustomDateSerializer(Class<Date> t) {
        super(t); 
    }

    @Override
    public void serialize(
      Date value, JsonGenerator gen, SerializerProvider arg2) 
      throws IOException, JsonProcessingException {
        gen.writeString(formatter.format(value));
    }
}
```

现在让我们在测试中使用这些：

```java
@Test
public void whenSerializingUsingJsonSerialize_thenCorrect()
  throws JsonProcessingException, ParseException {
 
    SimpleDateFormat df
      = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");

    String toParse = "20-12-2014 02:30:00";
    Date date = df.parse(toParse);
    EventWithSerializer event = new EventWithSerializer("party", date);

    String result = new ObjectMapper().writeValueAsString(event);
    assertThat(result, containsString(toParse));
}
```

# 3. Jackson 反序列化注解

接下来让我们探索 Jackson 反序列化注解。

## 3.1 @JsonCreator

**我们可以使用 `@JsonCreator` 注解来微调反序列化的构造器/工厂**。

这在我们需要反序列化一些不精确匹配我们需要获得的目标实体的 JSON 时非常有用。

让我们看一个例子。假如我们需要反序列化下面 JSON：

```json
{
    "id":1,
    "theName":"My bean"
}
```

然而，在我们的模板实体中没有 `theName` 字段，只有一个 `name` 字段。现在我们不想改变实体本身，我们只需要通过用 `@JsonCreator` 注解构造器并同时使用 `@JsonProperty` 注解来对解组过程进行多一点控制：

```java
public class BeanWithCreator {
    public int id;
    public String name;

    @JsonCreator
    public BeanWithCreator(
      @JsonProperty("id") int id, 
      @JsonProperty("theName") String name) {
        this.id = id;
        this.name = name;
    }
}
```

我们看看这在实际的情况：

```java
@Test
public void whenDeserializingUsingJsonCreator_thenCorrect()
  throws IOException {
 
    String json = "{\"id\":1,\"theName\":\"My bean\"}";

    BeanWithCreator bean = new ObjectMapper()
      .readerFor(BeanWithCreator.class)
      .readValue(json);
    assertEquals("My bean", bean.name);
}
```

## 3.2 @JacksonInject

**`@JacksonInject` 表示属性将从注入而不是从 JSON 数据中获取其值。**

在以下示例中，我们使用 `@JacksonInject` 注入属性 `id`：

```java
public class BeanWithInject {
    @JacksonInject
    public int id;
    
    public String name;
}
```

这是它工作的样子：

```java
@Test
public void whenDeserializingUsingJsonInject_thenCorrect()
  throws IOException {
 
    String json = "{\"name\":\"My bean\"}";
    
    InjectableValues inject = new InjectableValues.Std()
      .addValue(int.class, 1);
    BeanWithInject bean = new ObjectMapper().reader(inject)
      .forType(BeanWithInject.class)
      .readValue(json);
    
    assertEquals("My bean", bean.name);
    assertEquals(1, bean.id);
}
```

## 3.3 @JsonAnySetter

`@JsonAnySetter` 允许我们灵活地使用 Map 作为标准财产。在反序列化时，JSON 中的财产将简单地添加到映射中。

首先，我们将使用 `@JsonAnySetter` 反序列化实体 `ExtendedBean`：

```java
public class ExtendableBean {
    public String name;
    private Map<String, String> properties;

    @JsonAnySetter
    public void add(String key, String value) {
        properties.put(key, value);
    }
}
```

这是我们需要反序列化的 JSON：

```json
{
    "name":"My bean",
    "attr2":"val2",
    "attr1":"val1"
}
```

这是所有连接到一起的样子：

```java
@Test
public void whenDeserializingUsingJsonAnySetter_thenCorrect()
  throws IOException {
    String json
      = "{\"name\":\"My bean\",\"attr2\":\"val2\",\"attr1\":\"val1\"}";

    ExtendableBean bean = new ObjectMapper()
      .readerFor(ExtendableBean.class)
      .readValue(json);
    
    assertEquals("My bean", bean.name);
    assertEquals("val2", bean.getProperties().get("attr2"));
}
```

## 3.4 @JsonSetter

`@JsonSetter` 是 `@JsonProperty` 的替代品，它将该方法标记为 setter 方法。

当我们需要读取一些 JSON 数据时，这非常有用，**但目标实体类与该数据不完全匹配**，因此我们需要调整流程以使其适合。
在下面的示例中，我们将指定方法 `setTheName()` 作为 `MyBean` 实体中 `name` 属性的 setter：

```java
public class MyBean {
    public int id;
    private String name;

    @JsonSetter("name")
    public void setTheName(String name) {
        this.name = name;
    }
}
```

现在当我们需要解组一些 JSON 数据，这将完美地工作：

```java
@Test
public void whenDeserializingUsingJsonSetter_thenCorrect()
  throws IOException {
 
    String json = "{\"id\":1,\"name\":\"My bean\"}";

    MyBean bean = new ObjectMapper()
      .readerFor(MyBean.class)
      .readValue(json);
    assertEquals("My bean", bean.getTheName());
}
```

## 3.5 @JsonDeserialize

**`@JsonDeserialize` 表示使用自定义反序列化程序。**

首先，我们将使用 `@JsonDeserialize` 用 `CustomDateDeserializer` 反序列化 `eventDate` 属性：

```java
public class EventWithSerializer {
    public String name;

    @JsonDeserialize(using = CustomDateDeserializer.class)
    public Date eventDate;
}
```

这是自定义的反序列化器：

```java
public class CustomDateDeserializer
  extends StdDeserializer<Date> {

    private static SimpleDateFormat formatter
      = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");

    public CustomDateDeserializer() { 
        this(null); 
    } 

    public CustomDateDeserializer(Class<?> vc) { 
        super(vc); 
    }

    @Override
    public Date deserialize(
      JsonParser jsonparser, DeserializationContext context) 
      throws IOException {
        
        String date = jsonparser.getText();
        try {
            return formatter.parse(date);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }
}
```

接下来这是 back-to-back 测试：

```java
@Test
public void whenDeserializingUsingJsonDeserialize_thenCorrect()
  throws IOException {
 
    String json
      = "{"name":"party","eventDate":"20-12-2014 02:30:00"}";

    SimpleDateFormat df
      = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
    EventWithSerializer event = new ObjectMapper()
      .readerFor(EventWithSerializer.class)
      .readValue(json);
    
    assertEquals(
      "20-12-2014 02:30:00", df.format(event.eventDate));
}
```

## 3.6 @JsonAlias

**`@JsonAlias` 在反序列化期间为属性定义了一个或多个替代名称。**

让我们通过一个简单的例子来看看这个注解是如何工作的：

```java
public class AliasBean {
    @JsonAlias({ "fName", "f_name" })
    private String firstName;   
    private String lastName;
}
```

这里我们有一个 POJO，我们希望用 `fName`、`f_name` 和 `firstName` 等值将 JSON 反序列化为 POJO 的 `firstName` 变量。

下面是一个测试，确保此注解按预期工作：

```java
@Test
public void whenDeserializingUsingJsonAlias_thenCorrect() throws IOException {
    String json = "{\"fName\": \"John\", \"lastName\": \"Green\"}";
    AliasBean aliasBean = new ObjectMapper().readerFor(AliasBean.class).readValue(json);
    assertEquals("John", aliasBean.getFirstName());
}
```

# 4. Jackson 属性包括性注解

## 4.1 @JsonIgnoreProperties

**`@JsonIgnoreProperties` 是一个类级注解，用于标记 Jackson 将忽略的一个属性或一组属性列表。**

让我们看一个忽略序列化中的属性 `id` 的快速示例：

```java
@JsonIgnoreProperties({ "id" })
public class BeanWithIgnore {
    public int id;
    public String name;
}
```

这是确保忽略的测试：

```java
@Test
public void whenSerializingUsingJsonIgnoreProperties_thenCorrect()
  throws JsonProcessingException {
 
    BeanWithIgnore bean = new BeanWithIgnore(1, "My bean");

    String result = new ObjectMapper()
      .writeValueAsString(bean);
    
    assertThat(result, containsString("My bean"));
    assertThat(result, not(containsString("id")));
}
```

为了在 JSON 输入中无异常地忽略任意未知属性，我们可以将 `@JsonIgnoreProperties` 注解设置为 `ignoreUnknown=true`。

## 4.2 @JsonIgnore

**相反，`@JsonIgnore` 注解用于标记要在字段级别忽略的属性。**

让我们使用 `@JsonIgnore` 忽略序列化中的属性 `id`：

```java
public class BeanWithIgnore {
    @JsonIgnore
    public int id;

    public String name;
}
```

接下来我们将测试以确保 `id` 成功被忽略：

```java
@Test
public void whenSerializingUsingJsonIgnore_thenCorrect()
  throws JsonProcessingException {
 
    BeanWithIgnore bean = new BeanWithIgnore(1, "My bean");

    String result = new ObjectMapper()
      .writeValueAsString(bean);
    
    assertThat(result, containsString("My bean"));
    assertThat(result, not(containsString("id")));
}
```

## 4.3 @JsonIgnoreType

**`@JsonIgnoreType` 将注解类型的所有属性标记为忽略。**

我们可以使用注解将 `Name` 类型的所有属性标记为忽略：

```java
public class User {
    public int id;
    public Name name;

    @JsonIgnoreType
    public static class Name {
        public String firstName;
        public String lastName;
    }
}
```

我们也可以测试以确保忽略功能正常工作：

```java
@Test
public void whenSerializingUsingJsonIgnoreType_thenCorrect()
  throws JsonProcessingException, ParseException {
 
    User.Name name = new User.Name("John", "Doe");
    User user = new User(1, name);

    String result = new ObjectMapper()
      .writeValueAsString(user);

    assertThat(result, containsString("1"));
    assertThat(result, not(containsString("name")));
    assertThat(result, not(containsString("John")));
}
```

## 4.4 @JsonInclude

**我们可以使用 `@JsonInclude` 排除具有 empty/null/默认值的属性。**

让我们看一个从序列化中排除 null 的示例：

```java
@JsonInclude(Include.NON_NULL)
public class MyBean {
    public int id;
    public String name;
}
```

这是完整测试：

```java
public void whenSerializingUsingJsonInclude_thenCorrect()
  throws JsonProcessingException {
 
    MyBean bean = new MyBean(1, null);

    String result = new ObjectMapper()
      .writeValueAsString(bean);
    
    assertThat(result, containsString("1"));
    assertThat(result, not(containsString("name")));
}
```

## 4.5 @JsonAutoDetect

`@JsonAutoDetect` 可以**覆盖属性可见和不可见**的默认语义。

首先，让我们通过一个简单的例子来看看注解是如何非常有用的；让我们启用序列化私有属性：

```java
@JsonAutoDetect(fieldVisibility = Visibility.ANY)
public class PrivateBean {
    private int id;
    private String name;
}
```

然后测试：

```java
@Test
public void whenSerializingUsingJsonAutoDetect_thenCorrect()
  throws JsonProcessingException {
 
    PrivateBean bean = new PrivateBean(1, "My bean");

    String result = new ObjectMapper()
      .writeValueAsString(bean);
    
    assertThat(result, containsString("1"));
    assertThat(result, containsString("My bean"));
}
```

# 5. Jackson 多态类型处理注解

接下来，让我们看看 Jackson 多态类型处理注解：

- `@JsonTypeInfo`——指明要在序列化中包含的类型信息的详细信息
- `@JsonSubTypes`——指示注解类型的子类型
- `@JsonTypeName`——定义用于注解类的逻辑类型名称

让我们研究一个更复杂的示例，并使用所有三个——`@JsonTypeInfo`、`@JsonSubTypes` 和 `@JsonType` ——来序列化/反序列化实体 `Zoo`：

```java
public class Zoo {
    public Animal animal;

    @JsonTypeInfo(
      use = JsonTypeInfo.Id.NAME, 
      include = As.PROPERTY, 
      property = "type")
    @JsonSubTypes({
        @JsonSubTypes.Type(value = Dog.class, name = "dog"),
        @JsonSubTypes.Type(value = Cat.class, name = "cat")
    })
    public static class Animal {
        public String name;
    }

    @JsonTypeName("dog")
    public static class Dog extends Animal {
        public double barkVolume;
    }

    @JsonTypeName("cat")
    public static class Cat extends Animal {
        boolean likesCream;
        public int lives;
    }
}
```

当我们序列化的时候：

```java
@Test
public void whenSerializingPolymorphic_thenCorrect()
  throws JsonProcessingException {
    Zoo.Dog dog = new Zoo.Dog("lacy");
    Zoo zoo = new Zoo(dog);

    String result = new ObjectMapper()
      .writeValueAsString(zoo);

    assertThat(result, containsString("type"));
    assertThat(result, containsString("dog"));
}
```

这是序列化具有 `Dog` 的 `Zoo` 实例的结果：

```json
{
    "animal": {
        "type": "dog",
        "name": "lacy",
        "barkVolume": 0
    }
}
```

现在是反序列化。让我们使用下面的 JSON 输入：

```json
{
    "animal":{
        "name":"lacy",
        "type":"cat"
    }
}
```

然后让我们看看解组出来的 `Zoo` 实例：

```java
@Test
public void whenDeserializingPolymorphic_thenCorrect()
throws IOException {
    String json = "{\"animal\":{\"name\":\"lacy\",\"type\":\"cat\"}}";

    Zoo zoo = new ObjectMapper()
      .readerFor(Zoo.class)
      .readValue(json);

    assertEquals("lacy", zoo.animal.name);
    assertEquals(Zoo.Cat.class, zoo.animal.getClass());
}
```

# 6. Jackson 通用注解

接下来让我们讨论一些 Jackson 的更普遍的注解。

## 6.1 @JsonProperty

我们可以添加 **`@JsonProperty` 注解以指示JSON中的属性名称**。

在处理非标准 getter 和 setter 时，让我们使用 `@JsonProperty` 来序列化/反序列化属性 `name`：

```java
public class MyBean {
    public int id;
    private String name;

    @JsonProperty("name")
    public void setTheName(String name) {
        this.name = name;
    }

    @JsonProperty("name")
    public String getTheName() {
        return name;
    }
}
```

接下来是我们的测试：

```java
@Test
public void whenUsingJsonProperty_thenCorrect()
  throws IOException {
    MyBean bean = new MyBean(1, "My bean");

    String result = new ObjectMapper().writeValueAsString(bean);
    
    assertThat(result, containsString("My bean"));
    assertThat(result, containsString("1"));

    MyBean resultBean = new ObjectMapper()
      .readerFor(MyBean.class)
      .readValue(result);
    assertEquals("My bean", resultBean.getTheName());
}
```

## 6.2 @JsonFormat

**`@JsonFormat` 注解指定序列化日期/时间值时的格式。**

在以下示例中，我们使用 `@JsonFormat` 控制属性 `eventDate` 的格式：

```java
public class EventWithFormat {
    public String name;

    @JsonFormat(
      shape = JsonFormat.Shape.STRING,
      pattern = "dd-MM-yyyy hh:mm:ss")
    public Date eventDate;
}
```

这是测试：

```java
@Test
public void whenSerializingUsingJsonFormat_thenCorrect()
  throws JsonProcessingException, ParseException {
    SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
    df.setTimeZone(TimeZone.getTimeZone("UTC"));

    String toParse = "20-12-2014 02:30:00";
    Date date = df.parse(toParse);
    EventWithFormat event = new EventWithFormat("party", date);
    
    String result = new ObjectMapper().writeValueAsString(event);
    
    assertThat(result, containsString(toParse));
}
```

## 6.3 @JsonUnwrapped

`@JsonUnwrapped` 定义了序列化/反序列化时应展开/展平的值。

让我们来看看这是如何工作的；我们将使用注解展开属性 `name`：

```java
public class UnwrappedUser {
    public int id;

    @JsonUnwrapped
    public Name name;

    public static class Name {
        public String firstName;
        public String lastName;
    }
}
```

现在让我们序列化这个类的实例：

```java
@Test
public void whenSerializingUsingJsonUnwrapped_thenCorrect()
  throws JsonProcessingException, ParseException {
    UnwrappedUser.Name name = new UnwrappedUser.Name("John", "Doe");
    UnwrappedUser user = new UnwrappedUser(1, name);

    String result = new ObjectMapper().writeValueAsString(user);
    
    assertThat(result, containsString("John"));
    assertThat(result, not(containsString("name")));
}
```

最后，这是输出的样子——静态嵌套类的字段与其他字段一起展开：

```json
{
    "id":1,
    "firstName":"John",
    "lastName":"Doe"
}
```

## 6.4 @JsonView

**`@JsonView` 表示将在其中包含属性以进行序列化/反序列化的视图。**

例如，我们使用 `@JsonView` 来序列化一个 `Item` 实体的实例。

首先，让我们从视图开始：

```java
public class Views {
    public static class Public {}
    public static class Internal extends Public {}
}
```

下一步这里是使用视图的 `Item` 实体：

```java
public class Item {
    @JsonView(Views.Public.class)
    public int id;

    @JsonView(Views.Public.class)
    public String itemName;

    @JsonView(Views.Internal.class)
    public String ownerName;
}
```

最后，完整测试：

```java
@Test
public void whenSerializingUsingJsonView_thenCorrect()
  throws JsonProcessingException {
    Item item = new Item(2, "book", "John");

    String result = new ObjectMapper()
      .writerWithView(Views.Public.class)
      .writeValueAsString(item);

    assertThat(result, containsString("book"));
    assertThat(result, containsString("2"));
    assertThat(result, not(containsString("John")));
}
```

## 6.5 @JsonManagedReference，@JsonBackReference

`@JsonManagedReference` 和 `@JsonBackReference` 注解可以处理父/子关系和循环。

在以下示例中，我们使用 `@JsonManagedReference` 和 `@JsonBackReference` 序列化 `ItemWithRef` 实体：

```java
public class ItemWithRef {
    public int id;
    public String itemName;

    @JsonManagedReference
    public UserWithRef owner;
}
```

我们的 `UserWithRef` 实体：

```java
public class UserWithRef {
    public int id;
    public String name;

    @JsonBackReference
    public List<ItemWithRef> userItems;
}
```

然后测试：

```java
@Test
public void whenSerializingUsingJacksonReferenceAnnotation_thenCorrect()
  throws JsonProcessingException {
    UserWithRef user = new UserWithRef(1, "John");
    ItemWithRef item = new ItemWithRef(2, "book", user);
    user.addItem(item);

    String result = new ObjectMapper().writeValueAsString(item);

    assertThat(result, containsString("book"));
    assertThat(result, containsString("John"));
    assertThat(result, not(containsString("userItems")));
}
```

## 6.6 @JsonIdentityInfo

`@JsonIdentityInfo` 表示在序列化/反序列化值时应使用 Object Identity，例如在处理无限递归类型的问题时。
在以下示例中，我们有一个 `ItemWithIdentity` 实体，它与 `UserWithIdentity` 实体具有双向关系：

```java
@JsonIdentityInfo(
  generator = ObjectIdGenerators.PropertyGenerator.class,
  property = "id")
public class ItemWithIdentity {
    public int id;
    public String itemName;
    public UserWithIdentity owner;
}
```

`UserWithIdentity` 实体：

```java
@JsonIdentityInfo(
  generator = ObjectIdGenerators.PropertyGenerator.class,
  property = "id")
public class UserWithIdentity {
    public int id;
    public String name;
    public List<ItemWithIdentity> userItems;
}
```

现在，**让我们看看如何处理无限递归问题**：

```java
@Test
public void whenSerializingUsingJsonIdentityInfo_thenCorrect()
  throws JsonProcessingException {
    UserWithIdentity user = new UserWithIdentity(1, "John");
    ItemWithIdentity item = new ItemWithIdentity(2, "book", user);
    user.addItem(item);

    String result = new ObjectMapper().writeValueAsString(item);

    assertThat(result, containsString("book"));
    assertThat(result, containsString("John"));
    assertThat(result, containsString("userItems"));
}
```

这是序列化 item 和 user 后的完整输出：

```json
{
    "id": 2,
    "itemName": "book",
    "owner": {
        "id": 1,
        "name": "John",
        "userItems": [
            2
        ]
    }
}
```

## 6.7 @JsonFilter

`@JsonFilter` 注解指定要在序列化期间使用的筛选器。

首先，我们定义实体并指向过滤器：

```java
@JsonFilter("myFilter")
public class BeanWithFilter {
    public int id;
    public String name;
}
```

现在在完整测试中，我们定义了过滤器，它将 `name` 以外的所有其他属性从序列化中排除：

```java
@Test
public void whenSerializingUsingJsonFilter_thenCorrect()
  throws JsonProcessingException {
    BeanWithFilter bean = new BeanWithFilter(1, "My bean");

    FilterProvider filters 
      = new SimpleFilterProvider().addFilter(
        "myFilter", 
        SimpleBeanPropertyFilter.filterOutAllExcept("name"));

    String result = new ObjectMapper()
      .writer(filters)
      .writeValueAsString(bean);

    assertThat(result, containsString("My bean"));
    assertThat(result, not(containsString("id")));
}
```

# 7. 自定义 Jackson 注解

接下来，让我们看看如何创建一个自定义 Jackson 注解。**我们可以使用 `@JacksonAnnotationsInside` 注解**：

```java
@Retention(RetentionPolicy.RUNTIME)
    @JacksonAnnotationsInside
    @JsonInclude(Include.NON_NULL)
    @JsonPropertyOrder({ "name", "id", "dateCreated" })
    public @interface CustomAnnotation {}
```

现在如果我们在一个实体上使用新注解：

```java
@CustomAnnotation
public class BeanWithCustomAnnotation {
    public int id;
    public String name;
    public Date dateCreated;
}
```

我们可以看到它将已存在的注解组合到一个我们可以快速使用的简单自定义注解：

```java
@Test
public void whenSerializingUsingCustomAnnotation_thenCorrect()
  throws JsonProcessingException {
    BeanWithCustomAnnotation bean 
      = new BeanWithCustomAnnotation(1, "My bean", null);

    String result = new ObjectMapper().writeValueAsString(bean);

    assertThat(result, containsString("My bean"));
    assertThat(result, containsString("1"));
    assertThat(result, not(containsString("dateCreated")));
}
```

序列化过程的输出：

```json
{
    "name":"My bean",
    "id":1
}
```

# 8. Jackson 混合注解

接下来让我们看看如何使用 Jackson 混合注解。

例如，让我们使用混合注解来忽略 `User` 类型的属性：

```java
public class Item {
    public int id;
    public String itemName;
    public User owner;
}
```

```java
@JsonIgnoreType
public class MyMixInForIgnoreType {}
```

然后让我们看看实战：

```java
@Test
public void whenSerializingUsingMixInAnnotation_thenCorrect() 
  throws JsonProcessingException {
    Item item = new Item(1, "book", null);

    String result = new ObjectMapper().writeValueAsString(item);
    assertThat(result, containsString("owner"));

    ObjectMapper mapper = new ObjectMapper();
    mapper.addMixIn(User.class, MyMixInForIgnoreType.class);

    result = mapper.writeValueAsString(item);
    assertThat(result, not(containsString("owner")));
}
```

# 9. 停用 Jackson 注解

最后，让我们看看如何**禁用所有 Jackson 注解**。我们可以通过禁用`MapperFeature.USE_ANNOTATIONS` 来实现这一点，如下例所示：

```java
@JsonInclude(Include.NON_NULL)
@JsonPropertyOrder({ "name", "id" })
public class MyBean {
    public int id;
    public String name;
}
```

现在，在禁用注解后，这些应该无效，库的默认应适用：

```java
@Test
public void whenDisablingAllAnnotations_thenAllDisabled()
  throws IOException {
    MyBean bean = new MyBean(1, null);

    ObjectMapper mapper = new ObjectMapper();
    mapper.disable(MapperFeature.USE_ANNOTATIONS);
    String result = mapper.writeValueAsString(bean);
    
    assertThat(result, containsString("1"));
    assertThat(result, containsString("name"));
}
```

在停用注解前的序列化结果：

```json
{"id":1}
```

在停用注解后的序列化结果：

```json
{
    "id":1,
    "name":null
}
```

# 10. 结论

在本文中，我们检查了 Jackson 注解，只是触及了通过正确使用它们可以获得的灵活性的表面。

所有这些示例和代码片段的实现都可以在 GitHub 上找到。

# 介绍 Jackson ObjectMapper

# 1. 总览

本教程侧重于了解 Jackson `ObjectMapper` 类以及如何将 Java 对象序列化为 JSON 并将 JSON 字符串反序列化为 Java 对象。

要了解更多关于 Jackson 库的信息，Jackson 教程是一个很好的开始。

# 2. 依赖

首先在 `pom.xml` 中添加如下依赖：

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.13.3</version>
</dependency>
```

该依赖将传递性地将以下库添加到类路径：

1. jackson-annotations
2. jackson-core

对于 jackson-databind，请始终使用 Maven 中央存储库中的最新版本。

# 3. 使用 ObjectMapper 读写

让我们从基本的读写操作开始。

**ObjectMapper 的简单 readValue API 是一个很好的切入点**。我们可以使用它将 JSON 内容解析或反序列化为 Java 对象。

此外，在写端，**我们可以使用 writeValue API 将任何 Java 对象序列化为 JSON 输出**。

在本文中，我们将使用以下具有两个字段的 Car 类作为对象来序列化或反序列化：

```java
public class Car {

    private String color;
    private String type;

    // standard getters setters
}
```

## 3.1 Java 对象转 JSON

让我们看看第一个例子，使用 `ObjectMapper` 类的 `writeValue` 方法将一个 Java 对象序列化为 JSON：

```java
ObjectMapper objectMapper = new ObjectMapper();
Car car = new Car("yellow", "renault");
objectMapper.writeValue(new File("target/car.json"), car);
```

上面文件的输出将是：

```json
{"color":"yellow","type":"renault"}
```

`ObjectMapper` 类的 `writeValueAsString` 和 `writeValueAsBytes` 方法从 Java 对象生成 JSON，并将生成的 JSON 作为字符串或字节数组返回：

```java
String carAsString = objectMapper.writeValueAsString(car);
```

## 3.2 JSON 转 Java 对象

下面是使用 `ObjectMapper` 类将 JSON 字符串转换为 Java 对象的简单示例：

```java
String json = "{ \"color\" : \"Black\", \"type\" : \"BMW\" }";
Car car = objectMapper.readValue(json, Car.class);	
```

`readValue()` 函数还接受其他形式的输入，例如包含 JSON 字符串的文件：

```java
Car car = objectMapper.readValue(new File("src/test/resources/json_car.json"), Car.class);
```

或者 URL：

```java
Car car = 
  objectMapper.readValue(new URL("file:src/test/resources/json_car.json"), Car.class);
```

## 3.3 JSON 转 Jackson JsonNode

或者，可以将 JSON 解析为 `JsonNode` 对象，并用于从特定节点检索数据：

```java
String json = "{ \"color\" : \"Black\", \"type\" : \"FIAT\" }";
JsonNode jsonNode = objectMapper.readTree(json);
String color = jsonNode.get("color").asText();
// Output: color -> Black
```

## 3.4 从 JSON 数组字符串创建 Java List

我们可以使用 `TypeReference` 将数组形式的 JSON 解析为 Java 对象列表：

```java
String jsonCarArray = 
  "[{ \"color\" : \"Black\", \"type\" : \"BMW\" }, { \"color\" : \"Red\", \"type\" : \"FIAT\" }]";
List<Car> listCar = objectMapper.readValue(jsonCarArray, new TypeReference<List<Car>>(){});
```

## 3.5 从 JSON 字符串中创建 Java Map

相似地，我们可以将 JSON 解析为 Java Map：

```java
String json = "{ \"color\" : \"Black\", \"type\" : \"BMW\" }";
Map<String, Object> map 
  = objectMapper.readValue(json, new TypeReference<Map<String,Object>>(){});
```

# 4. 进阶特性

Jackson 库的最大优点之一是高度可定制的序列化和反序列化过程。

在本节中，我们将介绍一些高级特性，其中输入或输出 JSON 响应可能与生成或使用响应的对象不同。

## 4.1 配置序列化或反序列化特性

将 JSON 对象转换为 Java 类时，如果 JSON 字符串包含一些新字段，则默认过程将导致异常：

```java
String jsonString 
  = "{ \"color\" : \"Black\", \"type\" : \"Fiat\", \"year\" : \"1970\" }";
```

在 `Class Car` 的 Java 对象的默认解析过程中，上述示例中的 JSON 字符串将导致 `UnrecognizedPropertyException` 异常。

**通过 `configure` 方法，我们可以扩展默认过程以忽略新字段**：

```java
objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
Car car = objectMapper.readValue(jsonString, Car.class);

JsonNode jsonNodeRoot = objectMapper.readTree(jsonString);
JsonNode jsonNodeYear = jsonNodeRoot.get("year");
String year = jsonNodeYear.asText();
```

还有一个选项基于 `FAIL_ON_NULL_FOR_PRIMITIVES`，它定义了是否允许原始类型的 `null` 值：

```java
objectMapper.configure(DeserializationFeature.FAIL_ON_NULL_FOR_PRIMITIVES, false);
```

类似的，`FAIL_ON_NUMBERS_FOR_ENUM` 控制了枚举值是否允许被序列化/反序列化为数字：

```java
objectMapper.configure(DeserializationFeature.FAIL_ON_NUMBERS_FOR_ENUMS, false);
```

您可以在官方网站上找到序列化和反序列化功能的综合列表。

## 4.2 创建自定义序列化器或反序列化器

`ObjectMapper` 类的另一个基本特性是能够注册自定义序列化器和反序列化器。

自定义序列化器和反序列化器在输入或输出 JSON 响应的结构与必须将其序列化或反序列化到的 Java 类不同的情况下非常有用。

**以下是自定义 JSON 序列化器的示例**：

```java
public class CustomCarSerializer extends StdSerializer<Car> {
    
    public CustomCarSerializer() {
        this(null);
    }

    public CustomCarSerializer(Class<Car> t) {
        super(t);
    }

    @Override
    public void serialize(
      Car car, JsonGenerator jsonGenerator, SerializerProvider serializer) {
        jsonGenerator.writeStartObject();
        jsonGenerator.writeStringField("car_brand", car.getType());
        jsonGenerator.writeEndObject();
    }
}
```

自定义序列化器可以按这样调用：

```java
ObjectMapper mapper = new ObjectMapper();
SimpleModule module = 
  new SimpleModule("CustomCarSerializer", new Version(1, 0, 0, null, null, null));
module.addSerializer(Car.class, new CustomCarSerializer());
mapper.registerModule(module);
Car car = new Car("yellow", "renault");
String carJson = mapper.writeValueAsString(car);
```

这是 `Car` （作为 JSON 输出）在客户端的样子：

```javascript
var carJson = {"car_brand":"renault"}
```

这是一个**自定义 JSON 反序列化器**的例子：

```java
public class CustomCarDeserializer extends StdDeserializer<Car> {
    
    public CustomCarDeserializer() {
        this(null);
    }

    public CustomCarDeserializer(Class<?> vc) {
        super(vc);
    }

    @Override
    public Car deserialize(JsonParser parser, DeserializationContext deserializer) {
        Car car = new Car();
        ObjectCodec codec = parser.getCodec();
        JsonNode node = codec.readTree(parser);
        
        // try catch block
        JsonNode colorNode = node.get("color");
        String color = colorNode.asText();
        car.setColor(color);
        return car;
    }
}
```

自定义反序列化通过这样的方式调用：

```java
String json = "{ \"color\" : \"Black\", \"type\" : \"BMW\" }";
ObjectMapper mapper = new ObjectMapper();
SimpleModule module =
  new SimpleModule("CustomCarDeserializer", new Version(1, 0, 0, null, null, null));
module.addDeserializer(Car.class, new CustomCarDeserializer());
mapper.registerModule(module);
Car car = mapper.readValue(json, Car.class);
```

## 4.3 处理日期格式

`java.util.Date` 的默认序列化产生一个数字，即时间戳（自 1970 年 1 月 1 日以来的毫秒数，UTC）。但这不是很容易被人类阅读，需要进一步的转换才能以人类可读的格式显示。

让我们将至今使用的 `Car` 实例和 `datePurchased` 属性一起包装在 `Request` 类中：

```java
public class Request 
{
    private Car car;
    private Date datePurchased;

    // standard getters setters
}
```

要控制日期的字符串格式并将其设置，例如 `yyyy-MM-dd HH:MM a z`，请考虑以下代码段：

```java
ObjectMapper objectMapper = new ObjectMapper();
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm a z");
objectMapper.setDateFormat(df);
String carAsString = objectMapper.writeValueAsString(request);
// output: {"car":{"color":"yellow","type":"renault"},"datePurchased":"2016-07-03 11:43 AM CEST"}
```

要了解更多关于 Jackson 序列化日期的内容，请阅读我们更深入的文章。

## 4.4 处理集合

通过 `DeserializationFeature` 类提供的另一个小但有用的功能是能够从 JSON 数组响应生成所需的集合类型。

例如，我们可以将结果生成为数组：

```java
String jsonCarArray = 
  "[{ \"color\" : \"Black\", \"type\" : \"BMW\" }, { \"color\" : \"Red\", \"type\" : \"FIAT\" }]";
ObjectMapper objectMapper = new ObjectMapper();
objectMapper.configure(DeserializationFeature.USE_JAVA_ARRAY_FOR_JSON_ARRAY, true);
Car[] cars = objectMapper.readValue(jsonCarArray, Car[].class);
// print cars
```

或者作为 List：

```java
String jsonCarArray = 
  "[{ \"color\" : \"Black\", \"type\" : \"BMW\" }, { \"color\" : \"Red\", \"type\" : \"FIAT\" }]";
ObjectMapper objectMapper = new ObjectMapper();
List<Car> listCar = objectMapper.readValue(jsonCarArray, new TypeReference<List<Car>>(){});
// print cars
```

关于使用 Jackson 处理集合的更多信息，可以参考这里。

# 5. 结论

Jackson 是一个可靠且成熟的 Java JSON 序列化/反序列化库。`ObjectMapper` API 提供了一种简单的方法来解析和生成 JSON 响应对象，具有很大的灵活性。本文讨论了使该库如此流行的主要特性。

本文附带的源代码可以在 GitHub 上找到。

# Jackson 在编组时忽略属性

# 1. 总览