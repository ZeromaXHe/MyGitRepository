# Mybatis Generator 使用教程

参考：
https://blog.csdn.net/qq_40307945/article/details/81351302
https://blog.csdn.net/AOBO516/article/details/90245203

一、简介

mybatis-geneator是一款mybatis自动代码生成工具，可以通过配置，快速生成mapper和xml文件。

二、配置方法

在项目的pom文件中添加插件配置。plugin放在<build>下的<plugins>中
~~~xml
<plugin>
    <groupId>org.mybatis.generator</groupId>
    <artifactId>mybatis-generator-maven-plugin</artifactId>
    <version>1.3.2</version>
    <configuration>
        <verbose>true</verbose>
        <overwrite>true</overwrite>
    </configuration>
</plugin>
~~~
在main的resource目录下创建generatorConfig.xml文件

配置文件中的内容如下，可根据需要自行修改
~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
 
<generatorConfiguration>
    <!--导入属性配置-->
    <properties resource="datasource.properties"></properties>
 
    <!-- 指定数据库驱动的jdbc驱动jar包的位置 -->
    <classPathEntry location="${db.driverLocation}" />
 
    <!-- context 是逆向工程的主要配置信息 -->
    <!-- id：起个名字 -->
    <!-- targetRuntime：设置生成的文件适用于那个 mybatis 版本 -->
    <context id="default" targetRuntime="MyBatis3">
 
        <!--optional,旨在创建class时，对注释进行控制-->
        <commentGenerator>
            <property name="suppressDate" value="true" />
            <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
            <property name="suppressAllComments" value="true" />
        </commentGenerator>
 
        <!--jdbc的数据库连接-->
        <jdbcConnection driverClass="${db.driverClassName}"
                        connectionURL="${db.url}"
                        userId="${db.username}"
                        password="${db.password}">
        </jdbcConnection>
 
        <!--非必须，类型处理器，在数据库类型和java类型之间的转换控制-->
        <javaTypeResolver>
            <!-- 默认情况下数据库中的 decimal，bigInt 在 Java 对应是 sql 下的 BigDecimal 类 -->
            <!-- 不是 double 和 long 类型 -->
            <!-- 使用常用的基本类型代替 sql 包下的引用类型 -->
            <property name="forceBigDecimals" value="false" />
        </javaTypeResolver>
 
        <!-- targetPackage：生成的实体类所在的包 -->
        <!-- targetProject：生成的实体类所在的硬盘位置 -->
        <javaModelGenerator targetPackage="com.mall.pojo"
                            targetProject=".\src\main\java">
            <!-- 是否允许子包 -->
            <property name="enableSubPackages" value="false" />
            <!-- 是否对modal添加构造函数 -->
            <property name="constructorBased" value="true" />
            <!-- 是否清理从数据库中查询出的字符串左右两边的空白字符 -->
            <property name="trimStrings" value="true" />
            <!-- 建立modal对象是否不可改变 即生成的modal对象不会有setter方法，只有构造方法 -->
            <property name="immutable" value="false" />
        </javaModelGenerator>
 
        <!-- targetPackage 和 targetProject：生成的 mapper 文件的包和位置 -->
        <sqlMapGenerator targetPackage="mappers"
                         targetProject=".\src\main\resource">
            <!-- 针对数据库的一个配置，是否把 schema 作为字包名 -->
            <property name="enableSubPackages" value="false" />
        </sqlMapGenerator>
 
        <!-- targetPackage 和 targetProject：生成的 interface 文件的包和位置 -->
        <javaClientGenerator type="XMLMAPPER"
                             targetPackage="com.mall.dao" targetProject=".\src\main\java">
            <!-- 针对 oracle 数据库的一个配置，是否把 schema 作为字包名 -->
            <property name="enableSubPackages" value="false" />
        </javaClientGenerator>
        <table tableName="user" domainObjectName="User"
               enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false">
        </table>
    </context>
</generatorConfiguration>
~~~
generatorConfig.xml文件中的一些配置信息需要在配置文件中添加

在同一目录下创建datasource.properties文件

~~~properties
db.driverLocation=C:/Users/mysql/mysql-connector-java/5.1.6/mysql-connector-java-5.1.6.jar
db.driverClassName=com.mysql.jdbc.Driver
db.url=jdbc:mysql://192.168.199.193:3306/mall?characterEncoding=utf-8
db.username=root
db.password=123456
~~~

配置的三行的192.168.199.193需要替换成所在主机的IP，mall替换成数据库名称

配置第四行和第五行分别配置为数据库连接的用户名和密码

在generatorConfig.xml文件中添加完需要生成的表的配置后



双击右侧maven里的plugins -> mybatis-generator:generate，就可以自动生成mapper和xml文件了