## IDEA 2020.1 会导致tomcat加载不到maven的依赖

报错为找不到包，实际上maven已经装好了jar包依赖。

解决方法：换个版本的IDEA

## Tomcat网页乱码

Tomcat安装路径/conf/web.xml中添加fileEncoding UTF-8(110行左右)
~~~xml
<servlet>
    <servlet-name>default</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
    <init-param>
        <param-name>debug</param-name>
        <param-value>0</param-value>
    </init-param>
    <init-param>
        <param-name>fileEncoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
    <init-param>
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
~~~
修改tomcat的server.xml配置。添加 URIEncoding=“UTF-8”
~~~xml
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" URIEncoding="UTF-8" />
<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" URIEncoding="UTF-8"/>
~~~

在IDEA的tomcat edit configuration中加VM option：`-Dfile.encoding=UTF-8`

IDEA的help->Edit Custom VM Options也加：`-Dfile.encoding=UTF-8`,重启IDEA

IDEA settings里面搜file encoding，也将project encoding改为UTF-8

还是乱码的话，记得Shift+F5强制刷新（这个坑到我了，捂脸）

## IDEA tomcat控制台乱码

修改conf/logging.properties, 把UTF-8的几行注释掉

在IDEA的tomcat edit configuration中加VM option：`-Dfile.encoding=UTF-8`

## 查看Tomcat版本

使用 bin/version.sh（找到tomcat包下面的bin/目录，执行version.sh文件。）