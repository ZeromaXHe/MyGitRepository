# Spring Cloud Alibaba 官方网站

[GitHub Release](https://github.com/alibaba/spring-cloud-alibaba/releases)

[2021.0.5.0 官方中文文档](https://spring-cloud-alibaba-group.github.io/github-pages/2021/zh-cn/2021.0.5.0/index.html)

[Nacos 快速开始文档](https://nacos.io/zh-cn/docs/quick-start.html)

# 过程中碰到的问题

官方文档里面的 `@Autowired private LoadBalancerClient loadBalancerClient;` 根本就注入不进去，参考下面的文章引入 `spring-cloud-loadbalancer` 依赖才解决。

[关于SpringCloud H版 使用SpringCloudAlibaba nacos注册中心时出现spring-cloud-loadbalancer的错误](https://blog.csdn.net/lovemzy_27/article/details/114086241)

IDEA properties 默认 ISO-8859-1 编码，中文麻烦

[IDEA设置Properties配置文件的编码](https://blog.csdn.net/weixin_64353239/article/details/131795141)

“3.5 如何开启权重路由”里面第一行的 ribbon 相关的配置貌似都没了，文档不知道是不是又没更新…… 吐了，官方文档写的和坨大便一样……

