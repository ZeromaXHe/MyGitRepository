# 解决fastjson、Jackson、Gson解析Json数据时，key为Java中关键字无法解析的问题

参考：https://wuyongshi.top/articles/2017/01/03/1483428139532.html

无论我们在使用fastjson、Jackson还是Gson，我们在用json转换为实体类时，都是根据json数据建立对应实体类，但比较恶心的是，有时，有些服务商返回的json报文中，key值为java中的关键字，我们没法用关键字，当做一个类的成员变量，不过不代表我们就没有其他的办法解决了；

先给个测试实体类：
~~~java
public class ClientInfoEntity  {
    private Long id;

    // 客户编号
    @SerializedName("abstract")
    @JSONField(name="abstract")
    private String abstract_;

    @Override
    public String toString() {
        return "ClientInfoEntity [id=" + id + ", abstract_=" + abstract_ + "]";
    }
    
    public String getAbstract_() {
        return abstract_;
    }
    
    public void setAbstract_(String abstract_) {
        this.abstract_ = abstract_;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
}
~~~
解决方案如下：

①使用fastjson：
则在实体类中的对应成员变量中加上以下注解：
~~~java
@JSONField(name="abstract")
	private String abstract_;
~~~

②使用gson
则在实体类中的对应成员变量中加上以下注解：
~~~java
@SerializedName("abstract")
private String abstract_;
~~~
③使用jackson
则在实体类中的对应成员变量中加上以下注解：
~~~java
@JsonProperty("abstract")
private String abstract_;
~~~
当然了，三种注解是不冲突的，如果项目中使用多种方式解析，可以将对应的注解都加上，如给的测试实体类，我就加了fastjson和gson的两种注解

单元测试方法：
~~~java
@org.junit.Test
 public void testGson(){
	 String json = "{id:1,abstract:231}";
	 ClientInfoEntity clientInfoEntity =  new Gson().fromJson(json, ClientInfoEntity.class);
	 System.out.println(clientInfoEntity);
	 System.out.println(JSON.parseObject(json, ClientInfoEntity.class));
 }
~~~

# gson 存在 int自动变成double的问题

需要注意转换Integer需要特殊处理



# FastJSON内部类反序列化问题(fastjson exception: create instance error)

## 一、问题

项目开发过程中遇到了JSON反序列化问题(JSONException: create instance error)，问题如下：

~~~
...
com.alibaba.fastjson.JSONException: create instance error, class com.test.xiaofan.test.ClassA$ClassB
...
~~~

由问题可见，fastjson反序列化时尝试创建ClassA的内部内ClassB失败。测试内部类声明如下：

```java
@Data
public class ClassA {
    private String filedA1;

    private String fieldA2;

    private List<ClassB> fieldA3s;

    @Data
    public class ClassB {

        private String fieldB1;

        private String filedB2;
    }
}
```

测试代码如下：

```java
public class TestA {
    @Test
    public void testParseA(){
        String str = "{\"fieldA2\":\"test field A2\",\"fieldA3s\":[{\"fieldB1\":\"test field B1\",\"filedB2\":\"test "
            + "field B2\"}],\"filedA1\":\"test field A1\"}\n";

        ClassA classA = JSON.parseObject(str, ClassA.class);

        System.out.println(JSON.toJSONString(classA));
    }

    @Test
    public void testParseB() {
        String str = "{\"fieldB1\":\"test field B1\",\"filedB2\":\"test field B2\"}";

        ClassB classB = JSON.parseObject(str, ClassB.class);

        System.out.println(JSON.toJSONString(classB));
    }
}
```
## 二、嵌套类与内部类

查看了fastjson官方问题解释：[点击查看](https://github.com/alibaba/fastjson/issues/302)，问题本质为内部类无法实例化，导致fastjson反序列化失败。

点击查看：[《Java嵌套类与内部类》](http://blog.csdn.net/xktxoo/article/details/78175909)

## 三、解决方案

由Java嵌套类与内部类一文分析可知，非静态成员嵌套类的实例化依赖于外部类实例，而静态嵌套类的实例化不依赖于外部类，将内部类改为静态嵌套类即可。
————————————————
版权声明：本文为CSDN博主「Jerry的技术博客」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/xktxoo/article/details/78175997