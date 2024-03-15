# 如何使用IDEA将项目上传到自己的GitHub仓库？

参考文章：

https://blog.csdn.net/qq_38723394/article/details/80305245

https://blog.csdn.net/u012145252/article/details/80628451



1. Git下载及安装

2. GitHub注册账号

3. IDEA上创建Java项目

   a. 配置IDEA：

   - 第一步 file -> settings
   - 第二步 找到Git
   - 第三步 填写Path to Git executable（如果Git已安装，可以自动识别）
   - 第四步 点击Test进行测试

   b. IDEA上配置本地仓库

   - VCS -> Import into Version Control -> Create Git Repository...
   - 选你需要把本地仓库创建到哪里，这里就配置当前工作空间即可

   c. 上面配置好之后，你就会看到自己的项目变红，然后右键项目 Git -> Add

   d. c步操作完之后，你就会看到你的项目变绿了！（这里可以用Git -> Revert 把不需要的文件，例如.iml文件取消掉）然后再把项目提交到本地仓库 Git -> Commit Directory...

4. 配置Git

   a. 到我们刚刚创建本地仓库的目录下右键键–>Git Bash Here：先输入**ssh-keygen –t rsa –C “邮箱地址”**,注意ssh-keygen之间是没有空格的,其他的之间是有空格的，邮箱地址是咱们在注册GitHub的时候用的邮箱。 生成ssh密钥的过程可以一路enter，即无密码，且生成的密钥在 "C:/Users/当前用户名/.ssh" 路径下。

   b. 将id_rsa.pub这个文件打开，复制里面的内容，放在GitHub的SSH Keys：点击右上角头像 -> Settings -> SSH and GPG keys -> New SSH key, 然后填写Title（随便取个名字）和Key（生成的密钥拷贝在这里）

   c. ssh –T git@github.com 验证设置是否成功,在第4步的a步凑下的黑框输入ssh –T git@github.com 来验证。操作中会询问：“Are you sure you want to continue connecting (yes/no/[fingerprint])? ”，输入yes。然后看到出现successfully关键字（You've successfully authenticated, but GitHub does not provide shell access.），标识成功认证！

   d. 设置用户名，邮箱   【这里自己用的话，用户名我就设置为git官网登陆的用户名，邮箱也是git注册的时候绑定的邮箱】
   git config –global user.name “用户名” 
   git config –global user.email “邮箱” 

   e. GitHub上创建一个仓库【回到github首页，点击Start a project】

5. 将本地git项目上传到github上事先新建好的repository中：
   进入工程文件夹所在目录(即前面创建本地仓库的位置)，右键Git Init Here，出现.git文件，是有关配置等功能的，不用管。然后到git bash here，依次输入以下命令：

   git remote add origin git@github.com:github用户名/repository名.git

   git pull git@github.com:github用户名/repository名.git

   在这里可能会出现“fatal: refusing to merge unrelated histories”（拒绝合并不相关的历史），因为创建项目的时候勾选了生成README文件的话，会使得本地仓库和GitHub上的远程仓库实际上是独立的两个仓库。假如之前是直接clone的方式在本地建立起远程github仓库的克隆本地仓库就不会有这问题了
   查阅了一下资料，发现可以在pull命令后紧接着使用`--allow-unrelated-histories`(这里histories是复数，之前写错了)选项来解决问题（该选项可以合并两个独立启动仓库的历史）。

6. 输入命令 `git add .`  add后面加了一个点，是想要提交所有文件，如果想提交指定的文件，可以写文件名，执行完增加命令后，要执行提交命令，如下：

   commit： 
   输入命令：git commit –m “自定义项目名_v1.0版本”

   push： 
   输入命令：git push git@github.com:github用户名/自定义项目名.git


# IDEA Git 新建分支

右下角点击Git:master(没创建时是主分支master), 然后 new branch

# 开源协议

开源许可证GPL、BSD、MIT、Mozilla、Apache和LGPL的区别

来源：https://blog.csdn.net/mybwu_com/article/details/84624660

首先借用有心人士的一张相当直观清晰的图来划分各种协议：开源许可证GPL、BSD、MIT、Mozilla、Apache和LGPL的区别

~~~java
if (他人修改源码后可以闭源()){
    if(每一个修改过的文件都必须放置版权说明()){
        Apache许可证();
    } else {
        if(衍生软件的广告可以用你的名字促销()){
            MIT许可证();
        } else {
            BSD许可证();
        }
    }   
} else {
    if(新增代码采用同样许可证()){
        GPL许可证();
    } else {
        if(需要对源码的修改之处提供说明文档) {
            Mozilla许可证();
        } else {
            LGPL许可证();
        }
    }
}
~~~

以下是上述协议的简单介绍：

**BSD开源协议**

BSD开源协议是一个给于使用者很大自由的协议。基本上使用者可以”为所欲为”,可以自由的使用，修改源代码，也可以将修改后的代码作为开源或者专有软件再发布。

但”为所欲为”的前提当你发布使用了BSD协议的代码，或则以BSD协议代码为基础做二次开发自己的产品时，需要满足三个条件：

如果再发布的产品中包含源代码，则在源代码中必须带有原来代码中的BSD协议。
如果再发布的只是二进制类库/软件，则需要在类库/软件的文档和版权声明中包含原来代码中的BSD协议。
不可以用开源代码的作者/机构名字和原来产品的名字做市场推广。

BSD 代码鼓励代码共享，但需要尊重代码作者的著作权。BSD由于允许使用者修改和重新发布代码，也允许使用或在BSD代码上开发商业软件发布和销售，因此是对商业集成很友好的协议。而很多的公司企业在选用开源产品的时候都首选BSD协议，因为可以完全控制这些第三方的代码，在必要的时候可以修改或者二次开发。

**Apache Licence 2.0**

Apache Licence是著名的非盈利开源组织Apache采用的协议。该协议和BSD类似，同样鼓励代码共享和尊重原作者的著作权，同样允许代码修改，再发布（作为开源或商业软件）。需要满足的条件也和BSD类似：

需要给代码的用户一份Apache Licence
如果你修改了代码，需要再被修改的文件中说明。
在延伸的代码中（修改和有源代码衍生的代码中）需要带有原来代码中的协议，商标，专利声明和其他原来作者规定需要包含的说明。
如果再发布的产品中包含一个Notice文件，则在Notice文件中需要带有Apache Licence。你可以在Notice中增加自己的许可，但不可以表现为对Apache Licence构成更改。

Apache Licence也是对商业应用友好的许可。使用者也可以在需要的时候修改代码来满足需要并作为开源或商业产品发布/销售。

**GPL**

我们很熟悉的Linux就是采用了GPL。GPL协议和BSD, Apache Licence等鼓励代码重用的许可很不一样。GPL的出发点是代码的开源/免费使用和引用/修改/衍生代码的开源/免费使用，但不允许修改后和衍生的代码做为闭源的商业软件发布和销售。这也就是为什么我们能用免费的各种linux，包括商业公司的linux和linux上各种各样的由个人，组织，以及商业软件公司开发的免费软件了。

GPL协议的主要内容是只要在一个软件中使用(”使用”指类库引用，修改后的代码或者衍生代码)GPL 协议的产品，则该软件产品必须也采用GPL协议，既必须也是开源和免费。这就是所谓的”传染性”。GPL协议的产品作为一个单独的产品使用没有任何问题，还可以享受免费的优势。

由于GPL严格要求使用了GPL类库的软件产品必须使用GPL协议，对于使用GPL协议的开源代码，商业软件或者对代码有保密要求的部门就不适合集成/采用作为类库和二次开发的基础。

其它细节如再发布的时候需要伴随GPL协议等和BSD/Apache等类似。

**LGPL**

LGPL是GPL的一个为主要为类库使用设计的开源协议。和GPL要求任何使用/修改/衍生之GPL类库的的软件必须采用GPL协议不同。LGPL 允许商业软件通过类库引用(link)方式使用LGPL类库而不需要开源商业软件的代码。这使得采用LGPL协议的开源代码可以被商业软件作为类库引用并发布和销售。

但是如果修改LGPL协议的代码或者衍生，则所有修改的代码，涉及修改部分的额外代码和衍生的代码都必须采用LGPL协议。因此LGPL协议的开源代码很适合作为第三方类库被商业软件引用，但不适合希望以LGPL协议代码为基础，通过修改和衍生的方式做二次开发的商业软件采用。

GPL/LGPL都保障原作者的知识产权，避免有人利用开源代码复制并开发类似的产品

**MIT**

MIT是和BSD一样宽范的许可协议,作者只想保留版权,而无任何其他了限制.也就是说,你必须在你的发行版里包含原许可协议的声明,无论你是以二进制发布的还是以源代码发布的.

**MPL**

MPL是The Mozilla Public License的简写，是1998年初Netscape的 Mozilla小组为其开源软件项目设计的软件许可证。MPL许可证出现的最重要原因就是，Netscape公司认为GPL许可证没有很好地平衡开发者对源代码的需求和他们利用源代码获得的利益。同著名的GPL许可证和BSD许可证相比，MPL在许多权利与义务的约定方面与它们相同（因为都是符合OSIA 认定的开源软件许可证）。但是，相比而言MPL还有以下几个显著的不同之处:

◆ MPL虽然要求对于经MPL许可证发布的源代码的修改也要以MPL许可证的方式再许可出来，以保证其他人可以在MPL的条款下共享源代码。但是，在MPL 许可证中对“发布”的定义是“以源代码方式发布的文件”，这就意味着MPL允许一个企业在自己已有的源代码库上加一个接口，除了接口程序的源代码以MPL 许可证的形式对外许可外，源代码库中的源代码就可以不用MPL许可证的方式强制对外许可。这些，就为借鉴别人的源代码用做自己商业软件开发的行为留了一个豁口。
◆ MPL许可证第三条第7款中允许被许可人将经过MPL许可证获得的源代码同自己其他类型的代码混合得到自己的软件程序。
◆ 对软件专利的态度，MPL许可证不像GPL许可证那样明确表示反对软件专利，但是却明确要求源代码的提供者不能提供已经受专利保护的源代码（除非他本人是专利权人，并书面向公众免费许可这些源代码），也不能在将这些源代码以开放源代码许可证形式许可后再去申请与这些源代码有关的专利。
◆ 对源代码的定义
而在MPL（1.1版本）许可证中，对源代码的定义是:“源代码指的是对作品进行修改最优先择取的形式，它包括:所有模块的所有源程序，加上有关的接口的定义，加上控制可执行作品的安装和编译的‘原本’（原文为‘Script’），或者不是与初始源代码显著不同的源代码就是被源代码贡献者选择的从公共领域可以得到的程序代码。”
◆ MPL许可证第3条有专门的一款是关于对源代码修改进行描述的规定，就是要求所有再发布者都得有一个专门的文件就对源代码程序修改的时间和修改的方式有描述。

英文原文：http://www.mozilla.org/MPL/MPL-1.1.html

# 将本地Git仓库传到远程Git仓库

GitHub的介绍：

…or create a new repository on the command line
~~~shell script
echo "# LeetCodeSolver" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/ZeromaXHe/LeetCodeSolver.git
git push -u origin main             
~~~

…or push an existing repository from the command line
~~~shell script
git remote add origin https://github.com/ZeromaXHe/LeetCodeSolver.git
git branch -M main
git push -u origin main
~~~

…or import code from another repository
You can initialize this repository with code from a Subversion, Mercurial, or TFS project.

# 将git上多模块的项目的子模块拆分为独立项目

项目一开始把很多模块都放在一个git库里面。后续需要将某个目录单独出一个项目来开发，此时就可以利用这个subtree的功能分离里。使用subtree的方式可以将源码子目录作为一个新的仓库，并且需要保留和子目录相关的log记录。

假设父目录为 folder-parent

两个子模块为
- module-a
- module-b

目录结构为
- /folder-parent/module-a
- /folder-parent/module-b

## 拆分项目的方式

git subtree split 的-P参数后面跟着拆分模块所在的相对路径

~~~shell script
# 进入父目录
cd folder-parent 
#为模块b的目录创建一个新的分支名为 module-b-branch
git subtree split -P module-b -b module-b-branch 
#退到和父目录同级的目录
cd ..
#为模块b新建一个和父目录同级的目录module-b-dir
mkdir module-b-dir 
#进入新建的目录
cd module-b-dir
#初始化git
git init
# 将分离出来的分支pull到新建的文件目录下
git pull ../folder-parent module-b-branch 

git remote add origin XXXXXXXXX.git
git push -u origin master
~~~

# GitHub现在push不能使用密码登录，只能使用token

版权声明：本文为CSDN博主「smileNicky」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。

原文链接：https://blog.csdn.net/u014427391/article/details/119913677



最近在写一个项目提交到github，一直提示如下

~~~
remote: Support for password authentication was removed on August 13, 2021. Please use a personal access token instead.
remote: Please see https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/ for more information.
~~~

刚开始没注意看提示，一直因为是网速问题，因为github是国外网站，速度一直比较慢，所以没注意到，后面重复好几次，发现都提交不上去，马上去github看一下，发现也是正常，那就不是网速问题了，然后认证看了一下错误提示？其意思就是github从2021.08.13开始就不支持账号密码方式提交代码，详情github官网也给出如下链接
https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations

然后可以用什么方法处理？网上不少地方是有用ssh key方式，不过我觉得太麻烦了，所以直接使用access Token的方式

## 1、生成AccessToken

在个人中心，点击setting

选择Developer settings

选择Personal access tokens，然后点击generate new Token


Note，可以自己做个标记，这个Expiration是token的过期时间，根据自己项目需要设置

`select scopes`这里是权限设置，因为是自己项目，那就全选了也无所谓


点击Generate Token之后，就会生成token，同时给你邮箱发一份邮件

## 2、github项目设置

token生成之后，对原来项目进行远程链接修改，然后重新更新项目即可

~~~shell
# 移除原来的远程链接
git remote remove origin
# 查看git的远程链接
git remote -v
# 重新新增git远程链接
git remote add origin https://<your token>@github.com/<your account>/<your repository>.git
# 下拉master分支
git push origin master -u
~~~

如果是git客户端的，比如smartgit，重新设置github链接即可

## 3、IDEA

idea提交的时候，原来密码的地方填token就可以了

# git删除远程仓库的某个标签或分支

版权声明：本文为CSDN博主「benben_2015」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。

原文链接：https://blog.csdn.net/benben_2015/article/details/102762921

————————————————

例如你远程仓库有标签v1.0，你现在想在本地删除它，怎么做呢？很简单，只需要下面两个命令：

~~~shell
git tag -d v1.0
git push origin :refs/tags/v1.0
~~~

这两条命令分别的作用是：先在本地删除想删除的标签，然后再将其推送到关联的远程仓库。

## Git相关原理——Refspec

`Refspec`用来定义本地仓库和远程哪个仓库进行关联。`Refspec`的格式是一个可选的`+`号，接着是`<src>:<dst>`的格式。`<src>`是远程仓库的引用格式，`<dst>`是本地仓库的引用格式。
git remote add命令会自动生成refspec，Git会拉取远程仓库上refs/heads/下面的所有引用，并将它写入到本地的refs/remotes/origin/。

例如，你想查看master分支的提交记录，下面三个命令都是等价的。

~~~shell
git log origin/master
git log remotes/origin/master
git log refs/remotes/origin/master
~~~

Git会将前两个命令扩展成refs/remotes/origin/master，例如你想让Git每次只拉取远程的master分支，而不是远程的所有分支，你可以在定义fetch为如下的格式：

~~~shell
fetch = +refs/heads/master:refs/remotes/origin/master
~~~

再比如，拉取远程master分支到本地的mymaster分支，其命令如下：

~~~shell
git fetch origin master:refs/remotes/origin/mymaster
~~~

你可以使用refspec来删除远程的引用，通过把`<src>`部分留空的方式，表示把本地对应的远程分支变为空，即删除它。
例如删除远程仓库的develop分支，命令可以如下：

~~~shell
git push origin :develop
~~~

