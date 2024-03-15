# 起步

## 关于版本控制

### 本地版本控制系统

许多人习惯用复制整个项目目录的方式来保存不同的版本，或许还会改名加上备份时间以示区别。这么做唯一的好处就是简单，但是特别容易犯错。有时候会混淆所在的工作目录，一不小心会写错文件或者覆盖意想外的文件。

为了解决这个问题，人们很久以前就开发了许多种本地版本控制系统，大多都是采用某种简单的数据库来记录文件的历次更新差异。

其中最流行的一种叫做RCS，现今许多计算机系统上都还看得到它的踪影。甚至在流行的Mac OS X系统上安装了开发者工具包之后，也可以使用`rcs`命令。它的工作原理是在硬盘上保存补丁集（补丁是指文件修订前后的变化）；通过应用所有的补丁，可以重新计算出各个版本的文件内容。

### 集中化的版本控制系统

接下来人们又遇到一个问题，如何让在不同系统上的开发者协同工作？于是，集中化的版本控制系统（Centralized Version Control Systems，简称CVCS）应运而生。这类系统，诸如CVS、Subversion以及Perforce等，都有一个单一的集中管理的服务器，保存所有文件的修订版本，而协同工作的人们都通过客户端连到这台服务器，取出最新的文件或者提交更新。多年以来，这成为版本控制系统的标准做法。

这种做法带来了许多好处，特别是相较于老式的本地VCS来说。现在，每个人都可以在一定程度上看到项目中的其他人正在做些什么。而管理员也可以轻松掌控每个开发者的权限，并且管理一个CVCS要远比在各个客户端上维护本地数据库来得轻松容易。

事分两面，有好有坏。这么做最显而易见的缺点是中央服务器的单点故障。如果宕机一小时，那么在这一小时内，谁都无法提交更新，也就无法协同工作。如果中心数据库所在的磁盘发生损坏，又没有做恰当备份，毫无疑问你将丢失所有数据——包括项目的整个变更历史，只剩下人们在各自机器上保留的单独快照。本地版本控制系统也存在类似问题，只要整个项目的历史记录被保存在单一位置，就有丢失所有历史更新记录的风险。

### 分布式版本控制系统

于是分布式版本控制系统（Distributed Version Control System，简称DVCS）面世了。在这类系统中，像Git、Mercurial、Bazaar以及Darcs等，客户端并不只提取最新版本的文件快照，而是把代码仓库完整地镜像下来。这么一来，任何一处协同工作用的服务器发生故障，事后都可以用任何一个镜像出来的本地仓库恢复。因为每一次的克隆操作，实际上都是一次对代码仓库的完整备份。

更进一步，许多这类系统都可以指定和若干个不同的远端代码仓库进行交互。藉此，你就可以在同一个项目中，分别和不同工作小组的人相互协作。你可以根据需要设定不同的协作流程，比如层次模型式的工作流，而这在以前的集中式系统中是无法实现的。

## Git简史

同生活中的许多伟大事物一样，Git诞生于一个极富纷争、大举创新的年代。

Linux内核开源项目有着为数众多的参与者。绝大多数的Linux内核维护工作都花在了提交补丁和保存归档的繁琐事务上（1991-2002年间）。到2002年，整个项目组开始启用一个专有的分布式版本控制系统BitKeeper来管理和维护代码。

到了2005年，开发BitKeeper的商业公司同Linux内核开源社区的合作关系结束，他们收回了Linux内核社区免费使用BitKeeper的权力。这就迫使Linux开源社区（特别是Linux的缔造者Linux Torvalds）基于使用BitKeeper时的经验教训，开发出自己的版本系统。他们对新的系统制订了若干目标：

- 速度
- 简单的设计
- 对非线性开发模式的强力支持（允许成千上万个并行开发的分支）
- 完全分布式
- 有能力高效管理类似Linux内核一样的超大规模项目（速度和数据量）

自诞生于2005年以来，Git日臻成熟完善，在高度易用的同时，仍然保留着初期设定的目标。它的速度飞快，极其适合管理大项目，有着令人难以置信的非线性分支管理系统。

## Git基础

### 直接记录快照，而非差异比较

Git和其他版本控制系统（包括Subversion和近似工具）的主要差别在于Git对待数据的方法。概念上来区分，其他大部分系统以文件变更列表的方式存储信息。这类系统（CVS、Subversion、Perforce、Bazaar等等）将它们保存的信息看作是一组基本文件和每个文件随时间逐步累积的差异。

Git不按照以上方式对待或保存数据。反之，Git更像是把数据看作对小型文件系统的一组快照。每次你提交更新，或在Git中保存项目状态时，它主要对当时的全部文件制作一个快照并保存这个快照的索引。为了高效，如果文件没有修改，Git不再重新存储该文件，而是只保留一个链接指向之前存储的文件。Git对待数据更像是一个快照流。

这是Git与几乎所有其他版本控制系统的重要区别。因此Git重新考虑了以前每一代版本控制系统延续下来的诸多方面。Git更像是一个小型的文件系统，提供了许多以此为基础构建的超强工具，而不只是一个简单的VCS。稍后我们在Git分支讨论Git分支管理时，将探究这种方式对待数据所能获得的益处。

### 近乎所有操作都是本地执行

在Git中的绝大多数操作都只需要访问本地文件和资源，一般不需要来自网络上其它计算机的信息。如果你习惯于所有操作都有网络延时开销的集中式版本控制系统，Git 在这方面会让你感到速度之神赐给了 Git 超凡的能量。因为你在本地磁盘上就有项目的完整历史，所以大部分操作看起来瞬间完成。

举个例子，要浏览项目的历史，Git 不需外连到服务器去获取历史，然后再显示出来——它只需直接从本地数据库中读取。你能立即看到项目历史。如果你想查看当前版本与一个月前的版本之间引入的修改，Git会查找到一个月前的文件做一次本地的差异计算，而不是由远程服务器处理或从远程服务器拉回旧版本文件再来本地处理。

使用其它系统，做到如此是不可 能或很费力的。比如，用 Perforce，你没有连接服务器时几乎不能做什么事；用 Subversion 和 CVS，你能修改文件，但不能向数据库提交修改（因为你的本地数据库离线了）。

### Git保证完整性

Git 中所有数据在存储前都计算校验和，然后以校验和来引用。这意味着不可能在 Git 不知情时更改任何文件内容或目录内容。这个功能建构在 Git 底层，是构成 Git 哲学不可或缺的部分。若你在传送过程中丢失信息或损坏文件，Git 就能发现。

Git 用以计算校验和的机制叫做 SHA-1 散列（hash，哈希）。这是一个由 40 个十六进制字符（0-9 和 a-f）组成字符串，基于 Git 中文件的内容或目录结构计算出来。SHA-1 哈希看起来是这样：
~~~
24b9da6552252987aa493b52f8696cd6d3b00373
~~~
Git 中使用这种哈希值的情况很多，你将经常看到这种哈希值。实际上，Git 数据库中保存的信息都是以文件内容的哈希值来索引，而不是文件名。

### Git一般只添加数据

你执行的 Git 操作，几乎只往 Git 数据库中增加数据。很难让 Git 执行任何不可逆操作，或者让它以任何方式清 除数据。同别的 VCS 一样，未提交更新时有可能丢失或弄乱修改的内容；但是一旦你提交快照到 Git 中，就难以再丢失数据，特别是如果你定期的推送数据库到其它仓库的话。

这使得我们使用 Git 成为一个安心愉悦的过程，因为我们深知可以尽情做各种尝试，而没有把事情弄糟的危险。 更深度探讨 Git 如何保存数据及恢复丢失数据的话题，请参考撤消操作。

### 三种状态

好，请注意。如果你希望后面的学习更顺利，记住下面这些关于 Git 的概念。Git 有三种状态，你的文件可能处于其中之一：已提交（committed）、已修改（modified）和已暂存（staged）。已提交表示数据已经安全的保存在本地数据库中。已修改表示修改了文件，但还没保存到数据库中。已暂存表示对一个已修改文件的当前版本做了标记，使之包含在下次提交的快照中。

由此引入 Git 项目的三个工作区域的概念：Git 仓库、工作目录以及暂存区域。
~~~
Working Directory       Staging Area        .git directory(Repository)
        |                       |                   |
        |               Checkout the project        |
        |<------------------------------------------|
        |   Stage Fixes         |                   |
        |---------------------->|       Commit      |
        |                       |------------------>|
~~~

Git 仓库目录是 Git 用来保存项目的元数据和对象数据库的地方。这是 Git 中最重要的部分，从其它计算机克隆仓库时，拷贝的就是这里的数据。

工作目录是对项目的某个版本独立提取出来的内容。这些从 Git 仓库的压缩数据库中提取出来的文件，放在磁盘上供你使用或修改。

暂存区域是一个文件，保存了下次将提交的文件列表信息，一般在 Git 仓库目录中。有时候也被称作`‘索引’'，不过一般说法还是叫暂存区域。

基本的 Git 工作流程如下：

1. 在工作目录中修改文件。
2. 暂存文件，将文件的快照放入暂存区域。
3. 提交更新，找到暂存区域的文件，将快照永久性存储到 Git 仓库目录。 

如果 Git 目录中保存着的特定版本文件，就属于已提交状态。如果作了修改并已放入暂存区域，就属于已暂存状态。如果自上次取出后，作了修改但还没有放到暂存区域，就是已修改状态。在Git 基础一章，你会进一步了解这些状态的细节，并学会如何根据文件状态实施后续操作，以及怎样跳过暂存直接提交。

## 命令行

## 安装Git

### 在Linux上安装

### 在Mac上安装

### 在Windows上安装

### 从源代码安装

## 初次运行Git前的配置

Git 自带一个 `git config` 的工具来帮助设置控制 Git 外观和行为的配置变量。这些变量存储在三个不同的位置：

1. `/etc/gitconfig` 文件: 包含系统上每一个用户及他们仓库的通用配置。 如果使用带有 `--system` 选项的 `git config` 时，它会从此文件读写配置变量。
2. `~/.gitconfig` 或 `~/.config/git/config` 文件：只针对当前用户。 可以传递 `--global` 选项让 Git 读写此文件。
3. 当前使用仓库的 Git 目录中的 `config` 文件（就是 `.git/config`）：针对该仓库。

每一个级别覆盖上一级别的配置，所以 `.git/config` 的配置变量会覆盖 `/etc/gitconfig` 中的配置变量。

在 Windows 系统中，Git 会查找 `$HOME` 目录下（一般情况下是 C:\Users\$USER）的 `.gitconfig` 文件。Git 同样也会寻找 `/etc/gitconfig` 文件，但只限于 MSys 的根目录下，即安装 Git 时所选的目标位置。

### 用户信息

当安装完 Git 应该做的第一件事就是设置你的用户名称与邮件地址。这样做很重要，因为每一个 Git 的提交都会使用这些信息，并且它会写入到你的每一次提交中，不可更改：
~~~
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
~~~
再次强调，如果使用了 --global 选项，那么该命令只需要运行一次，因为之后无论你在该系统上做任何事情， Git 都会使用那些信息。当你想针对特定项目使用不同的用户名称与邮件地址时，可以在那个项目目录下运 行没有 --global 选项的命令来配置。

### 文本编辑器

既然用户信息已经设置完毕，你可以配置默认文本编辑器了，当 Git 需要你输入信息时会调用它。如果未配置，Git 会使用操作系统默认的文本编辑器，通常是 Vim。如果你想使用不同的文本编辑器，例如 Emacs，可以这样做：
~~~
$ git config --global core.editor emacs
~~~

### 检查配置信息

如果想要检查你的配置，可以使用 `git config --list` 命令来列出所有 Git 当时能找到的配置。
~~~
$ git config --list
user.name=John Doe
user.email=johndoe@example.com
color.status=auto
color.branch=auto
color.interactive=auto
color.diff=auto
...
~~~
你可能会看到重复的变量名，因为 Git 会从不同的文件中读取同一个配置（例如：`/etc/gitconfig` 与
`~/.gitconfig`）。这种情况下，Git 会使用它找到的每一个变量的最后一个配置。

你可以通过输入 `git config <key>`： 来检查 Git 的某一项配置
~~~
$ git config user.name
John Doe
~~~

## 获取帮助

若你使用 Git 时需要获取帮助，有三种方法可以找到 Git 命令的使用手册：
~~~
$ git help <verb>
$ git <verb> --help
$ man git-<verb>
~~~
例如，要想获得 config 命令的手册，执行
~~~
$ git help config
~~~
这些命令很棒，因为你随时随地可以使用而无需联网。如果你觉得手册或者本书的内容还不够用，你可以尝试在Freenode IRC 服务器（ irc.freenode.net ）的 #git 或 #github 频道寻求帮助。这些频道经常有上百人在线， 他们都精通 Git 并且乐于助人。

# Git基础

假如你只能阅读一章来学习 Git，本章就是你的不二选择。本章内容涵盖你在使用 Git 完成各种工作中将要使用的各种基本命令。在学习完本章之后，你应该能够配置并初始化一个仓库（repository）、开始或停止跟踪 （track）文件、暂存（stage）或提交（commit)更改。本章也将向你演示如何配置 Git 来忽略指定的文件和文件模式、如何迅速而简单地撤销错误操作、如何浏览你的项目的历史版本以及不同提交（commits）间的差异、如何向你的远程仓库推送（push）以及如何从你的远程仓库拉取（pull）文件。

## 获取Git仓库

有两种取得 Git 项目仓库的方法。第一种是在现有项目或目录下导入所有文件到 Git 中；第二种是从一个服务器克隆一个现有的 Git 仓库。

### 在现有目录中初始化仓库

如果你打算使用 Git 来对现有的项目进行管理，你只需要进入该项目目录并输入：
~~~
$ git init
~~~
该命令将创建一个名为 .git 的子目录，这个子目录含有你初始化的 Git 仓库中所有的必须文件，这些文件是Git 仓库的骨干。但是，在这个时候，我们仅仅是做了一个初始化的操作，你的项目里的文件还没有被跟踪。(参见 Git 内部原理 来了解更多关于到底 .git 文件夹中包含了哪些文件的信息。) 

如果你是在一个已经存在文件的文件夹（而不是空文件夹）中初始化 Git 仓库来进行版本控制的话，你应该开始跟踪这些文件并提交。你可通过 git add 命令来实现对指定文件的跟踪，然后执行 git commit 提交：
~~~
$ git add *.c
$ git add LICENSE
$ git commit -m 'initial project version'
~~~
稍后我们再逐一解释每一条指令的意思。现在，你已经得到了一个实际维护（或者说是跟踪）着若干个文件的Git 仓库。

### 克隆现有仓库

如果你想获得一份已经存在了的 Git 仓库的拷贝，比如说，你想为某个开源项目贡献自己的一份力，这时就要用到 `git clone` 命令。如果你对其它的 VCS 系统（比如说Subversion）很熟悉，请留心一下你所使用的命令是"clone"而不是"checkout"。这是 Git 区别于其它版本控制系统的一个重要特性，Git 克隆的是该 Git 仓库服务器上的几乎所有数据，而不是仅仅复制完成你的工作所需要文件。当你执行 `git clone` 命令的时候，默认配置 下远程 Git 仓库中的每一个文件的每一个版本都将被拉取下来。事实上，如果你的服务器的磁盘坏掉了，你通常 可以使用任何一个克隆下来的用户端来重建服务器上的仓库（虽然可能会丢失某些服务器端的挂钩设置，但是所有版本的数据仍在，详见 在服务器上搭建 Git ）。

克隆仓库的命令格式是 `git clone [url]` 。比如，要克隆 Git 的可链接库 libgit2，可以用下面的命令：
~~~
$ git clone https://github.com/libgit2/libgit2
~~~
这会在当前目录下创建一个名为 “libgit2” 的目录，并在这个目录下初始化一个 .git 文件夹，从远程仓库拉取下所有数据放入 `.git` 文件夹，然后从中读取最新版本的文件的拷贝。如果你进入到这个新建的 `libgit2` 文件夹，你会发现所有的项目文件已经在里面了，准备就绪等待后续的开发和使用。如果你想在克隆远程仓库的时候，自定义本地仓库的名字，你可以使用如下命令：
~~~
$ git clone https://github.com/libgit2/libgit2 mylibgit
~~~
这将执行与上一个命令相同的操作，不过在本地创建的仓库名字变为 `mylibgit`。

Git 支持多种数据传输协议。上面的例子使用的是 `https://` 协议，不过你也可以使用 `git://` 协议或者使用
SSH 传输协议，比如 `user@server:path/to/repo.git` 。在服务器上搭建 Git将会介绍所有这些协议在服务
器端如何配置使用，以及各种方式之间的利弊。

## 记录每次更新到仓库

现在我们手上有了一个真实项目的 Git 仓库，并从这个仓库中取出了所有文件的工作拷贝。接下来，对这些文件做些修改，在完成了一个阶段的目标之后，提交本次更新到仓库。 

请记住，你工作目录下的每一个文件都不外乎这两种状态：已跟踪或未跟踪。已跟踪的文件是指那些被纳入了版本控制的文件，在上一次快照中有它们的记录，在工作一段时间后，它们的状态可能处于未修改，已修改或已放 入暂存区。工作目录中除已跟踪文件以外的所有其它文件都属于未跟踪文件，它们既不存在于上次快照的记录中，也没有放入暂存区。初次克隆某个仓库的时候，工作目录中的所有文件都属于已跟踪文件，并处于未修改状态。

编辑过某些文件之后，由于自上次提交后你对它们做了修改，Git 将它们标记为已修改文件。我们逐步将这些修改过的文件放入暂存区，然后提交所有暂存了的修改，如此反复。所以使用 Git 时文件的生命周期如下：
~~~
Untracked           Unmodified          Modified            Staged
    |                   |                   |                   |
    |                   Add the file                            |
    |---------------------------------------------------------->|
    |                   |                   |                   |
    |                   |   Edit the file   |   Stage the file  |
    |                   |------------------>|------------------>|
    |   Remove the file |               Commit                  |
    |<------------------|<--------------------------------------|
~~~

### 检查当前文件状态

要查看哪些文件处于什么状态，可以用 `git status` 命令。如果在克隆仓库后立即使用此命令，会看到类似这样的输出：
~~~
$ git status
On branch master
nothing to commit, working directory clean
~~~
这说明你现在的工作目录相当干净。换句话说，所有已跟踪文件在上次提交后都未被更改过。此外，上面的信息 还表明，当前目录下没有出现任何处于未跟踪状态的新文件，否则 Git 会在这里列出来。最后，该命令还显示了当前所在分支，并告诉你这个分支同远程服务器上对应的分支没有偏离。现在，分支名是 “master”,这是默认 的分支名。我们在 Git 分支 会详细讨论分支和引用。

现在，让我们在项目下创建一个新的 README 文件。如果之前并不存在这个文件，使用 `git status` 命令，你将看到一个新的未跟踪文件：
~~~
$ echo 'My Project' > README
$ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
    README
nothing added to commit but untracked files present (use "git add" to
track)
~~~
在状态报告中可以看到新建的 README 文件出现在 `Untracked files` 下面。未跟踪的文件意味着 Git 在之前的快照（提交）中没有这些文件；Git 不会自动将之纳入跟踪范围，除非你明明白白地告诉它“我需要跟 踪该文件”，这样的处理让你不必担心将生成的二进制文件或其它不想被跟踪的文件包含进来。不过现在的例子中，我们确实想要跟踪管理 README 这个文件。

### 跟踪新文件

使用命令 `git add` 开始跟踪一个文件。所以，要跟踪 README 文件，运行：
~~~
$ git add README
~~~
此时再运行 `git status` 命令，会看到 README 文件已被跟踪，并处于暂存状态：
~~~
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    new file: README
~~~
只要在 `Changes to be committed` 这行下面的，就说明是已暂存状态。如果此时提交，那么该文件此时此刻的版本将被留存在历史记录中。你可能会想起之前我们使用 `git init` 后就运行了 `git add (files)` 命令，开始跟踪当前目录下的文件。`git add` 命令使用文件或目录的路径作为参数；如果参数是目录的路径，该命令将递归地跟踪该目录下的所有文件。

### 暂存已修改文件

现在我们来修改一个已被跟踪的文件。如果你修改了一个名为 CONTRIBUTING.md 的已被跟踪的文件，然后运行 `git status` 命令，会看到下面内容：
~~~
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    new file: README
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working
directory)
    modified: CONTRIBUTING.md
~~~

文件 `CONTRIBUTING.md` 出现在 `Changes not staged for commit` 这行下面，说明已跟踪文件的内容发生了变化，但还没有放到暂存区。要暂存这次更新，需要运行 git add 命令。这是个多功能命令：可以用它开始跟踪新文件，或者把已跟踪的文件放到暂存区，还能用于合并时把有冲突的文件标记为已解决状态等。将这个命令理解为“添加内容到下一次提交中”而不是“将一个文件添加到项目中”要更加合适。现在让我们运行 `git add` 将"CONTRIBUTING.md"放到暂存区，然后再看看 `git status` 的输出：
~~~
$ git add CONTRIBUTING.md
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    new file: README
    modified: CONTRIBUTING.md
~~~
现在两个文件都已暂存，下次提交时就会一并记录到仓库。假设此时，你想要在 `CONTRIBUTING.md` 里再加条注释，重新编辑存盘后，准备好提交。不过且慢，再运行 `git status` 看看：
~~~
$ vim CONTRIBUTING.md
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    new file: README
    modified: CONTRIBUTING.md
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working
directory)
    modified: CONTRIBUTING.md
~~~
怎么回事？现在 `CONTRIBUTING.md` 文件同时出现在暂存区和非暂存区。这怎么可能呢？好吧，实际上 Git 只过暂存了你运行 git add 命令时的版本，如果你现在提交，`CONTRIBUTING.md` 的版本是你最后一次运行 `git add` 命令时的那个版本，而不是你运行 `git commit` 时，在工作目录中的当前版本。所以，运行了 `git add` 之后又作了修订的文件，需要重新运行 `git add` 把最新版本重新暂存起来：
~~~
$ git add CONTRIBUTING.md
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    new file: README
    modified: CONTRIBUTING.md
~~~

### 状态简览

`git status` 命令的输出十分详细，但其用语有些繁琐。如果你使用 `git status -s` 命令或 `git status --short` 命令，你将得到一种更为紧凑的格式输出。运行 `git status -s` ，状态报告输出如下：
~~~
$ git status -s
 M README
MM Rakefile
A lib/git.rb
M lib/simplegit.rb
?? LICENSE.txt
~~~
新添加的未跟踪文件前面有 `??` 标记，新添加到暂存区中的文件前面有 `A` 标记，修改过的文件前面有 `M` 标记。你 可能注意到了 `M` 有两个可以出现的位置，出现在右边的 `M` 表示该文件被修改了但是还没放入暂存区，出现在靠左
边的 `M` 表示该文件被修改了并放入了暂存区。例如，上面的状态报告显示： `README` 文件在工作区被修改了但是
还没有将修改后的文件放入暂存区,`lib/simplegit.rb` 文件被修改了并将修改后的文件放入了暂存区。而
`Rakefile` 在工作区被修改并提交到暂存区后又在工作区中被修改了，所以在暂存区和工作区都有该文件被修改
了的记录。

### 忽略文件

一般我们总会有些文件无需纳入 Git 的管理，也不希望它们总出现在未跟踪文件列表。通常都是些自动生成的文 件，比如日志文件，或者编译过程中创建的临时文件等。在这种情况下，我们可以创建一个名为 `.gitignore` 的文件，列出要忽略的文件模式。来看一个实际的例子：
~~~
$ cat .gitignore
*.[oa]
*~
~~~
第一行告诉 Git 忽略所有以 .o 或 .a 结尾的文件。一般这类对象文件和存档文件都是编译过程中出现的。第二行 告诉 Git 忽略所有以波浪符（~）结尾的文件，许多文本编辑软件（比如 Emacs）都用这样的文件名保存副本。此外，你可能还需要忽略 log，tmp 或者 pid 目录，以及自动生成的文档等等。要养成一开始就设置好 .gitignore 文件的习惯，以免将来误提交这类无用的文件。

文件 `.gitignore` 的格式规范如下： 

- 所有空行或者以 `＃` 开头的行都会被 Git 忽略。 
- 可以使用标准的 glob 模式匹配。 
- 匹配模式可以以（`/`）开头防止递归。 
- 匹配模式可以以（`/`）结尾指定目录。 
- 要忽略指定模式以外的文件或目录，可以在模式前加上惊叹号（`!`）取反。 

所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。星号（`*`）匹配零个或多个任意字符；`[abc]` 匹配任 何一个列在方括号中的字符（这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）；问号（`?`）只匹配
一个任意字符；如果在方括号中使用短划线分隔两个字符，表示所有在这两个字符范围内的都可以匹配（比如 
`[0-9]` 表示匹配所有 0 到 9 的数字）。使用两个星号（`*`) 表示匹配任意中间目录，比如`a/**/z` 可以匹配 `a/z`,
`a/b/z` 或 `a/b/c/z`等。

我们再看一个 .gitignore 文件的例子：
~~~gitignore
# no .a files
*.a
# but do track lib.a, even though you're ignoring .a files above
!lib.a
# only ignore the TODO file in the current directory, not subdir/TODO
/TODO
# ignore all files in the build/ directory
build/
# ignore doc/notes.txt, but not doc/server/arch.txt
doc/*.txt
# ignore all .pdf files in the doc/ directory
doc/**/*.pdf
~~~

> TIP: GitHub 有一个十分详细的针对数十种项目及语言的 .gitignore 文件列表，你可以在 https://github.com/github/gitignore 找到它.

### 查看已暂存和未暂存的修改

你想知道具体修改了什么地方，可以用 `git diff` 命令。

假如再次修改 README 文件后暂存，然后编辑 `CONTRIBUTING.md` 文件后先不暂存

要查看尚未暂存的文件更新了哪些部分，不加参数直接输入 `git diff`：
~~~
$ git diff
diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 8ebb991..643e24f 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -65,7 +65,8 @@ branch directly, things can get messy.
 Please include a nice description of your changes when you submit your
PR;
 if we have to read the whole diff to figure out why you're contributing
 in the first place, you're less likely to get feedback and have your
change
-merged in.
+merged in. Also, split your changes into comprehensive chunks if your
patch is
+longer than a dozen lines.
 If you are starting to work on a particular area, feel free to submit a
PR
 that highlights your work in progress (and note in the PR title that it's
~~~
此命令比较的是工作目录中当前文件和暂存区域快照之间的差异，也就是修改之后还没有暂存起来的变化内容。

若要查看已暂存的将要添加到下次提交里的内容，可以用 `git diff --cached` 命令。（Git 1.6.1 及更高版本还允许使用 `git diff --staged`，效果是相同的，但更好记些。）
~~~
$ git diff --staged
diff --git a/README b/README
new file mode 100644
index 0000000..03902a1
--- /dev/null
+++ b/README
@@ -0,0 +1 @@
+My Project
~~~

请注意，`git diff` 本身只显示尚未暂存的改动，而不是自上次提交以来所做的所有改动。所以有时候你一下子暂 存了所有更新过的文件后，运行 `git diff` 后却什么也没有，就是这个原因。

> NOTE: Git Diff 的插件版本
> 在本书中，我们使用 git diff 来分析文件差异。但是，如果你喜欢通过图形化的方式或其 它格式输出方式的话，可以使用 git difftool 命令来用 Araxis ，emerge 或 vimdiff 等软件输出 diff 分析结果。使用 git difftool --tool-help 命令来看你的系统支持哪些 Git Diff 插件。

### 提交更新

现在的暂存区域已经准备妥当可以提交了。在此之前，请一定要确认还有什么修改过的或新建的文件还没有 `git
add` 过，否则提交的时候不会记录这些还没暂存起来的变化。这些修改过的文件只保留在本地磁盘。所以，每次
准备提交前，先用 `git status` 看下，是不是都已暂存起来了，然后再运行提交命令 `git commit`：
~~~
$ git commit
~~~
这种方式会启动文本编辑器以便输入本次提交的说明。(默认会启用 shell 的环境变量 `$EDITOR` 所指定的软件， 一般都是 vim 或 emacs。当然也可以按照 起步 介绍的方式，使用 `git config --global core.editor` 命 令设定你喜欢的编辑软件。）

编辑器会显示类似下面的文本信息（本例选用 Vim 的屏显方式展示）：
~~~
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Changes to be committed:
#	new file: README
#	modified: CONTRIBUTING.md
#
~
~
~
".git/COMMIT_EDITMSG" 9L, 283C
~~~
可以看到，默认的提交消息包含最后一次运行 `git status` 的输出，放在注释行里，另外开头还有一空行，供你输入提交说明。你完全可以去掉这些注释行，不过留着也没关系，多少能帮你回想起这次更新的内容有哪些。(如果想要更详细的对修改了哪些内容的提示，可以用 `-v` 选项，这会将你所做的改变的 diff 输出放到编辑器中从而使你知道本次提交具体做了哪些修改。）退出编辑器时，Git 会丢掉注释行，用你输入提交附带信息生成一次提交。

另外，你也可以在 commit 命令后添加 -m 选项，将提交信息与命令放在同一行，如下所示：
~~~
$ git commit -m "Story 182: Fix benchmarks for speed"
[master 463dc4f] Story 182: Fix benchmarks for speed
 2 files changed, 2 insertions(+)
 create mode 100644 README
~~~
好，现在你已经创建了第一个提交！可以看到，提交后它会告诉你，当前是在哪个分支（`master`）提交的，本次提交的完整 SHA-1 校验和是什么（`463dc4f`），以及在本次提交中，有多少文件修订过，多少行添加和删改过。

请记住，提交时记录的是放在暂存区域的快照。任何还未暂存的仍然保持已修改状态，可以在下次提交时纳入版本管理。每一次运行提交操作，都是对你项目作一次快照，以后可以回到这个状态，或者进行比较。

### 跳过使用暂存区域

尽管使用暂存区域的方式可以精心准备要提交的细节，但有时候这么做略显繁琐。Git 提供了一个跳过使用暂存区域的方式，只要在提交的时候，给 `git commit` 加上 `-a` 选项，Git 就会自动把所有已经跟踪过的文件暂存起来一并提交，从而跳过 `git add` 步骤：
~~~
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working
directory)
    modified: CONTRIBUTING.md
no changes added to commit (use "git add" and/or "git commit -a")
$ git commit -a -m 'added new benchmarks'
[master 83e38c7] added new benchmarks
 1 file changed, 5 insertions(+), 0 deletions(-)
~~~
看到了吗？提交之前不再需要 `git add` 文件“CONTRIBUTING.md”了。

### 移除文件

要从 Git 中移除某个文件，就必须要从已跟踪文件清单中移除（确切地说，是从暂存区域移除），然后提交。可以用 `git rm` 命令完成此项工作，并连带从工作目录中删除指定的文件，这样以后就不会出现在未跟踪文件清单中了。

如果只是简单地从工作目录中手工删除文件，运行 `git status` 时就会在 “Changes not staged for commit” 部分（也就是 未暂存清单）看到：
~~~
$ rm PROJECTS.md
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working
directory)
        deleted: PROJECTS.md
no changes added to commit (use "git add" and/or "git commit -a")
~~~
然后再运行 `git rm` 记录此次移除文件的操作：
~~~
$ git rm PROJECTS.md
rm 'PROJECTS.md'
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    deleted: PROJECTS.md
~~~
下一次提交时，该文件就不再纳入版本管理了。如果删除之前修改过并且已经放到暂存区域的话，则必须要用强制删除选项 `-f`（译注：即 force 的首字母）。这是一种安全特性，用于防止误删还没有添加到快照的数据，这样的数据不能被 Git 恢复。

另外一种情况是，我们想把文件从 Git 仓库中删除（亦即从暂存区域移除），但仍然希望保留在当前工作目录中。换句话说，你想让文件保留在磁盘，但是并不想让 Git 继续跟踪。当你忘记添加 `.gitignore` 文件，不小心把一个很大的日志文件或一堆 `.a` 这样的编译生成文件添加到暂存区时，这一做法尤其有用。为达到这一目的，使用 `--cached` 选项：
~~~
$ git rm --cached README
~~~
`git rm` 命令后面可以列出文件或者目录的名字，也可以使用 `glob` 模式。比方说：
~~~
$ git rm log/\*.log
~~~
注意到星号 `*` 之前的反斜杠 `\`，因为 Git 有它自己的文件模式扩展匹配方式，所以我们不用 shell 来帮忙展开。
此命令删除 `log/` 目录下扩展名为 `.log` 的所有文件。类似的比如：
~~~
$ git rm \*~
~~~
该命令为删除以 ~ 结尾的所有文件。

### 移动文件

不像其它的 VCS 系统，Git 并不显式跟踪文件移动操作。如果在 Git 中重命名了某个文件，仓库中存储的元数据并不会体现出这是一次改名操作。不过 Git 非常聪明，它会推断出究竟发生了什么，至于具体是如何做到的，我们稍后再谈。 既然如此，当你看到 Git 的 `mv` 命令时一定会困惑不已。要在 Git 中对文件改名，可以这么做：
~~~
$ git mv file_from file_to
~~~
它会恰如预期般正常工作。实际上，即便此时查看状态信息，也会明白无误地看到关于重命名操作的说明：
~~~
$ git mv README.md README
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    renamed: README.md -> README
~~~
其实，运行 `git mv` 就相当于运行了下面三条命令：
~~~
$ mv README.md README
$ git rm README.md
$ git add README
~~~
如此分开操作，Git 也会意识到这是一次改名，所以不管何种方式结果都一样。两者唯一的区别是，`mv` 是一条命令而另一种方式需要三条命令，直接用 `git mv` 轻便得多。不过有时候用其他工具批处理改名的话，要记得在提 交前删除老的文件名，再添加新的文件名。

## 查看提交历史

在提交了若干更新，又或者克隆了某个项目之后，你也许想回顾下提交历史.完成这个任务最简单而又有效的工具是 `git log` 命令。

接下来的例子会用我专门用于演示的 simplegit 项目，运行下面的命令获取该项目源代码：
~~~
git clone https://github.com/schacon/simplegit-progit
~~~
然后在此项目中运行 `git log`，应该会看到下面的输出：
~~~
$ git log
commit ca82a6dff817ec66f44342007202690a93763949
Author: Scott Chacon <schacon@gee-mail.com>
Date: Mon Mar 17 21:52:11 2008 -0700
    changed the version number
commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
Author: Scott Chacon <schacon@gee-mail.com>
Date: Sat Mar 15 16:40:33 2008 -0700
    removed unnecessary test
commit a11bef06a3f659402fe7563abf99ad00de2209e6
Author: Scott Chacon <schacon@gee-mail.com>
Date: Sat Mar 15 10:31:28 2008 -0700
    first commit
~~~

默认不用任何参数的话，`git log` 会按提交时间列出所有的更新，最近的更新排在最上面。正如你所看到的，这个命令会列出每个提交的 SHA-1 校验和、作者的名字和电子邮件地址、提交时间以及提交说明。

`git log` 有许多选项可以帮助你搜寻你所要找的提交，接下来我们介绍些最常用的。

一个常用的选项是 `-p`，用来显示每次提交的内容差异。你也可以加上 `-2` 来仅显示最近两次提交.

该选项除了显示基本信息之外，还在附带了每次 commit 的变化。当进行代码审查，或者快速浏览某个搭档提交的 commit 所带来的变化的时候，这个参数就非常有用了。你也可以为 `git log` 附带一系列的总结性选项。比如说，如果你想看到每次提交的简略的统计信息，你可以使用 `--stat` 选项

~~~
$ git log --stat
commit ca82a6dff817ec66f44342007202690a93763949
Author: Scott Chacon <schacon@gee-mail.com>
Date: Mon Mar 17 21:52:11 2008 -0700
    changed the version number
 Rakefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
Author: Scott Chacon <schacon@gee-mail.com>
Date: Sat Mar 15 16:40:33 2008 -0700
    removed unnecessary test
 lib/simplegit.rb | 5 -----
 1 file changed, 5 deletions(-)
commit a11bef06a3f659402fe7563abf99ad00de2209e6
Author: Scott Chacon <schacon@gee-mail.com>
Date: Sat Mar 15 10:31:28 2008 -0700
    first commit
 README             | 6 ++++++
 Rakefile           | 23 +++++++++++++++++++++++
 lib/simplegit.rb   | 25 +++++++++++++++++++++++++
 3 files changed, 54 insertions(+)
~~~

正如你所看到的，--stat 选项在每次提交的下面列出额所有被修改过的文件、有多少文件被修改了以及被修改过的文件的哪些行被移除或是添加了。在每次提交的最后还有一个总结。

另外一个常用的选项是 --pretty。这个选项可以指定使用不同于默认格式的方式展示提交历史。这个选项有一些内建的子选项供你使用。比如用 oneline 将每个提交放在一行显示，查看的提交数很大时非常有用。另外还有 short，full 和 fuller 可以用，展示的信息或多或少有些不同，请自己动手实践一下看看效果如何。

但最有意思的是 format，可以定制要显示的记录格式。这样的输出对后期提取分析格外有用——因为你知道 输出的格式不会随着Git的更新而发生改变

`git log --pretty=format 常用的选项` 列出了常用的格式占位符写法及其代表的意义。

|选项 |说明|
|----|----------------|
|%H |提交对象（commit）的完整哈希字串|
|%h |提交对象的简短哈希字串|
|%T |树对象（tree）的完整哈希字串|
|%t |树对象的简短哈希字串|
|%P |父对象（parent）的完整哈希字串|
|%p |父对象的简短哈希字串|
|%an |作者（author）的名字|
|%ae |作者的电子邮件地址|
|%ad |作者修订日期（可以用 --date= 选项定制格式）|
|%ar |作者修订日期，按多久以前的方式显示|
|%cn |提交者(committer)的名字|
|%ce |提交者的电子邮件地址|
|%cd |提交日期|
|%cr |提交日期，按多久以前的方式显示|
|%s |提交说明|

你一定奇怪 作者 和 提交者 之间究竟有何差别，其实作者指的是实际作出修改的人，提交者指的是最后将此工作成果提交到仓库的人。所以，当你为某个项目发布补丁，然后某个核心成员将你的补丁并入项目时，你就是作者，而那个核心成员就是提交者。我们会在 分布式 Git 再详细介绍两者之间的细微差别。

当 oneline 或 format 与另一个 `log` 选项 `--graph` 结合使用时尤其有用。这个选项添加了一些ASCII字符串来形象地展示你的分支、合并历史：

~~~
$ git log --pretty=format:"%h %s" --graph
* 2d3acf9 ignore errors from SIGCHLD on trap
* 5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
|\
| * 420eac9 Added a method for getting the current branch.
* | 30e367c timeout code and tests
* | 5a09431 add timeout protection to grit
* | e1193f8 support for heads with slashes in them
|/
* d6016bc require time for xmlschema
* 11d191e Merge branch 'defunkt' into local
~~~

这种输出类型会在我们下一张学完分支与合并以后变得更加有趣。

以上只是简单介绍了一些 `git log` 命令支持的选项。`git log 的常用选项` 列出了我们目前涉及到的和没涉及到的选项，已经它们是如何影响 log 命令的输出的

|选项 |说明|
|------|-----------------|
|-p |按补丁格式显示每个更新之间的差异。|
|--stat |显示每次更新的文件修改统计信息。|
|--shortstat |只显示 --stat 中最后的行数修改添加移除统计。|
|--name-only |仅在提交信息后显示已修改的文件清单。|
|--name-status |显示新增、修改、删除的文件清单。|
|--abbrev-commit |仅显示 SHA-1 的前几个字符，而非所有的 40 个字符。|
|--relative-date |使用较短的相对时间显示（比如，“2 weeks ago”）。|
|--graph |显示 ASCII 图形表示的分支合并历史。|
|--pretty |使用其他格式显示历史提交信息。可用的选项包括 oneline，short，full，fuller 和 format（后跟指定格式）。|

### 限制输出长度

除了定制输出格式的选项之外，`git log` 还有许多非常实用的限制输出长度的选项，也就是只输出部分提交信 息。之前你已经看到过 `-2` 了，它只显示最近的两条提交，实际上，这是 `-<n>` 选项的写法，其中的 n 可以是任何整数，表示仅显示最近的若干条提交。不过实践中我们是不太用这个选项的，Git 在输出所有提交时会自动调 用分页程序，所以你一次只会看到一页的内容。

另外还有按照时间作限制的选项，比如 `--since` 和 `--until` 也很有用。例如，下面的命令列出所有最近两周内的提交：
~~~
$ git log --since=2.weeks
~~~

这个命令可以在多种格式下工作，比如说具体的某一天 "`2008-01-15`"，或者是相对地多久以前 "`2 years 1 day 3 minutes ago`"。 还可以给出若干搜索条件，列出符合的提交。用 `--author` 选项显示指定作者的提交，用 `--grep` 选项搜索提 交说明中的关键字。（请注意，如果要得到同时满足这两个选项搜索条件的提交，就必须用 `--all-match` 选项。否则，满足任意一个条件的提交都会被匹配出来）

另一个非常有用的筛选选项是 `-S`，可以列出那些添加或移除了某些字符串的提交。比如说，你想找出添加或移 除了某一个特定函数的引用的提交，你可以这样使用：
~~~
$ git log -S function_name
~~~
最后一个很实用的 `git log` 选项是路径(path)，如果只关心某些文件或者目录的历史提交，可以在 git log 选项 的最后指定它们的路径。因为是放在最后位置上的选项，所以用两个短划线（--）隔开之前的选项和后面限定的路径名。

限制 git log 输出的选项

|选项 |说明|
|------|--------|
|-(n) |仅显示最近的 n 条提交|
|--since, --after |仅显示指定时间之后的提交。|
|--until, --before |仅显示指定时间之前的提交。|
|--author |仅显示指定作者相关的提交。|
|--committer |仅显示指定提交者相关的提交。|
|--grep |仅显示含指定关键字的提交|
|-S |仅显示添加或移除了某个关键字的提交|

来看一个实际的例子，如果要查看 Git 仓库中，2008 年 10 月期间，Junio Hamano 提交的但未合并的测试文 件，可以用下面的查询命令
~~~
$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" --before="2008-11-01" --no-merges -- t/
~~~

## 撤销操作

在任何一个阶段，你都有可能想要撤消某些操作。这里，我们将会学习几个撤消你所做修改的基本工具。注意，有些撤消操作是不可逆的。这是在使用 Git 的过程中，会因为操作失误而导致之前的工作丢失的少有的几个地方之一。

有时候我们提交完了才发现漏掉了几个文件没有添加，或者提交信息写错了。此时，可以运行带有 `--amend` 选项的提交命令尝试重新提交：
~~~
$ git commit --amend
~~~
这个命令会将暂存区中的文件提交。如果自上次提交以来你还未做任何修改（例如，在上次提交后马上执行了此命令），那么快照会保持不变，而你所修改的只是提交信息。 文本编辑器启动后，可以看到之前的提交信息。编辑后保存会覆盖原来的提交信息。

例如，你提交后发现忘记了暂存某些需要的修改，可以像下面这样操作：

~~~
$ git commit -m 'initial commit'
$ git add forgotten_file
$ git commit --amend
~~~

最终你只会有一个提交 - 第二次提交将代替第一次提交的结果。

### 取消暂存的文件

接下来的两个小节演示如何操作暂存区域与工作目录中已修改的文件。这些命令在修改文件状态的同时，也会提示如何撤消操作。例如，你已经修改了两个文件并且想要将它们作为两次独立的修改提交，但是却意外地输入了`git add *` 暂存了它们两个。如何只取消暂存两个中的一个呢？`git status` 命令提示了你：

在 “Changes to be committed” 文字正下方，提示使用 `git reset HEAD <file>...` 来取消暂存。所以，我们可以这样来取消暂存 `CONTRIBUTING.md` 文件

这个命令有点儿奇怪，但是起作用了。`CONTRIBUTING.md` 文件已经是修改未暂存的状态了。

> NOTE: 虽然在调用时加上 --hard 选项可以令 git reset 成为一个危险的命令（译注：可能导致工作目录中所有当前进度丢失！），但本例中工作目录内的文件并不会被修改。不加选项地调用 git reset 并不危险 — 它只会修改暂存区域。

到目前为止这个神奇的调用就是你需要对 git reset 命令了解的全部。我们将会在 重置揭密 中了解 reset 的更多细节以及如何掌握它做一些真正有趣的事。

### 撤销对文件的修改

如果你并不想保留对 `CONTRIBUTING.md` 文件的修改怎么办？你该如何方便地撤消修改 - 将它还原成上次提交时的样子（或者刚克隆完的样子，或者刚把它放入工作目录时的样子）？幸运的是，`git status` 也告诉了你应该如何做。在最后一个例子中，未暂存区域是这样：

~~~
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working
directory)
    modified: CONTRIBUTING.md
~~~

它非常清楚地告诉了你如何撤消之前所做的修改。让我们来按照提示执行：

~~~
$ git checkout -- CONTRIBUTING.md
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    renamed: README.md -> README
~~~
可以看到那些修改已经被撤消了。

> IMPORTANT: 你需要知道 `git checkout -- [file]` 是一个危险的命令，这很重要。你对那个文件做的任何修改都会消失 - 你只是拷贝了另一个文件来覆盖它。除非你确实清楚不想要那个文件了，否则不要使用这个命令。

如果你仍然想保留对那个文件做出的修改，但是现在仍然需要撤消，我们将会在 Git 分支 介绍保存进度与分支；这些通常是更好的做法。

记住，在 Git 中任何 已提交的 东西几乎总是可以恢复的。甚至那些被删除的分支中的提交或使用 `--amend` 选项覆盖的提交也可以恢复（阅读 数据恢复 了解数据恢复）。然而，任何你未提交的东西丢失后很可能再也找不到了。

## 远程仓库的使用

### 查看远程仓库

如果想查看你已经配置的远程仓库服务器，可以运行 `git remote` 命令。它会列出你指定的每一个远程服务器 的简写。如果你已经克隆了自己的仓库，那么至少应该能看到 origin - 这是 Git 给你克隆的仓库服务器的默认名字

~~~
$ git clone https://github.com/schacon/ticgit
Cloning into 'ticgit'...
remote: Reusing existing pack: 1857, done.
remote: Total 1857 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (1857/1857), 374.35 KiB | 268.00 KiB/s, done.
Resolving deltas: 100% (772/772), done.
Checking connectivity... done.
$ cd ticgit
$ git remote
origin
~~~

你也可以指定选项 `-v`，会显示需要读写远程仓库使用的 Git 保存的简写与其对应的 URL。
~~~
$ git remote -v
origin	https://github.com/schacon/ticgit (fetch)
origin	https://github.com/schacon/ticgit (push)
~~~

如果你的远程仓库不止一个，该命令会将它们全部列出。例如，与几个协作者合作的，拥有多个远程仓库的仓库

这样我们可以轻松拉取其中任何一个用户的贡献。此外，我们大概还会有某些远程仓库的推送权限，虽然我们目前还不会在此介绍。

注意这些远程仓库使用了不同的协议；我们将会在 在服务器上搭建 Git 中了解关于它们的更多信息。

### 添加远程仓库

我在之前的章节中已经提到并展示了如何添加远程仓库的示例，不过这里将告诉你如何明确地做到这一点。运行 `git remote add <shortname> <url>` 添加一个新的远程 Git 仓库，同时指定一个你可以轻松引用的简写
~~~
$ git remote
origin
$ git remote add pb https://github.com/paulboone/ticgit
$ git remote -v
origin	https://github.com/schacon/ticgit (fetch)
origin	https://github.com/schacon/ticgit (push)
pb	https://github.com/paulboone/ticgit (fetch)
pb	https://github.com/paulboone/ticgit (push)
~~~
现在你可以在命令行中使用字符串 `pb` 来代替整个 URL。例如，如果你想拉取 Paul 的仓库中有但你没有的信
息，可以运行 `git fetch pb`：

现在 Paul 的 master 分支可以在本地通过 pb/master 访问到 - 你可以将它合并到自己的某个分支中，或者如果你想要查看它的话，可以检出一个指向该点的本地分支。（我们将会在 Git 分支 中详细介绍什么是分支以及如何使用分支。）

### 从远程仓库中抓取与拉取

就如刚才所见，从远程仓库中获得数据，可以执行：
~~~
$ git fetch [remote-name]
~~~
这个命令会访问远程仓库，从中拉取所有你还没有的数据。执行完成后，你将会拥有那个远程仓库中所有分支的
引用，可以随时合并或查看。 

如果你使用 `clone` 命令克隆了一个仓库，命令会自动将其添加为远程仓库并默认以 “origin” 为简写。所以，`git fetch origin` 会抓取克隆（或上一次抓取）后新推送的所有工作。必须注意 git fetch 命令会将数据拉取到你的本地仓库 - 它并不会自动合并或修改你当前的工作。当准备好时你必须手动将其合并入你的工作。

如果你有一个分支设置为跟踪一个远程分支（阅读下一节与 Git 分支 了解更多信息），可以使用 `git pull` 命令来自动的抓取然后合并远程分支到当前分支。这对你来说可能是一个更简单或更舒服的工作流程；默认情况下，`git clone` 命令会自动设置本地 master 分支跟踪克隆的远程仓库的 master 分支（或不管是什么名字的默 认分支）。运行 `git pull` 通常会从最初克隆的服务器上抓取数据并自动尝试合并到当前所在的分支。

### 推送到远程仓库

当你想分享你的项目时，必须将其推送到上游。这个命令很简单：`git push [remote-name] [branch-name]`。当你想要将 master 分支推送到 `origin` 服务器时（再次说明，克隆时通常会自动帮你设置好那两个名字），那么运行这个命令就可以将你所做的备份到服务器：
~~~
$ git push origin master
~~~
只有当你有所克隆服务器的写入权限，并且之前没有人推送过时，这条命令才能生效。当你和其他人在同一时间克隆，他们先推送到上游然后你再推送到上游，你的推送就会毫无疑问地被拒绝。你必须先将他们的工作拉取下来并将其合并进你的工作后才能推送。阅读 Git 分支 了解如何推送到远程仓库服务器的详细信息。

### 查看远程仓库

如果想要查看某一个远程仓库的更多信息，可以使用 `git remote show [remote-name]` 命令。如果想以一个特定的缩写名运行这个命令，例如 `origin`，会得到像下面类似的信息：

~~~
$ git remote show origin
* remote origin
  Fetch URL: https://github.com/schacon/ticgit
  Push URL: https://github.com/schacon/ticgit
  HEAD branch: master
  Remote branches:
    master tracked
    dev-branch tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (up to date)
~~~

它同样会列出远程仓库的 URL 与跟踪分支的信息。这些信息非常有用，它告诉你正处于 master 分支，并且如果运行 git pull，就会抓取所有的远程引用，然后将远程 master 分支合并到本地 master 分支。它也会列出拉取到的所有远程引用。

这是一个经常遇到的简单例子。如果你是 Git 的重度使用者，那么还可以通过 git remote show 看到更多的
信息。

这个命令列出了当你在特定的分支上执行 `git push` 会自动地推送到哪一个远程分支。它也同样地列出了哪些远程分支不在你的本地，哪些远程分支已经从服务器上移除了，还有当你执行 `git pull` 时哪些分支会自动合并。

### 远程仓库的移除与重命名

如果想要重命名引用的名字可以运行 `git remote rename` 去修改一个远程仓库的简写名。例如，想要将 `pb` 重命名为 `paul`，可以用 `git remote rename` 这样做
~~~
$ git remote rename pb paul
$ git remote
origin
paul
~~~
值得注意的是这同样也会修改你的远程分支名字。那些过去引用 `pb/master` 的现在会引用 `paul/master`。 

如果因为一些原因想要移除一个远程仓库 - 你已经从服务器上搬走了或不再想使用某一个特定的镜像了，又或者 某一个贡献者不再贡献了 - 可以使用 `git remote rm` ：
~~~
$ git remote rm paul
$ git remote
origin
~~~

## 打标签

像其他版本控制系统（VCS）一样，Git 可以给历史中的某一个提交打上标签，以示重要。比较有代表性的是人们会使用这个功能来标记发布结点（v1.0 等等）。在本节中，你将会学习如何列出已有的标签、如何创建新标签、以及不同类型的标签分别是什么。

### 列出标签

在 Git 中列出已有的标签是非常简单直观的。只需要输入 git tag：
~~~
$ git tag
v0.1
v1.3
~~~
这个命令以字母顺序列出标签；但是它们出现的顺序并不重要。

你也可以使用特定的模式查找标签。例如，Git 自身的源代码仓库包含标签的数量超过 500 个。如果只对 1.8.5 系列感兴趣，可以运行：
~~~
$ git tag -l 'v1.8.5*'
v1.8.5
v1.8.5-rc0
v1.8.5-rc1
v1.8.5-rc2
v1.8.5-rc3
v1.8.5.1
v1.8.5.2
v1.8.5.3
v1.8.5.4
v1.8.5.5
~~~

### 创建标签

Git 使用两种主要类型的标签：轻量标签（lightweight）与附注标签（annotated）。

一个轻量标签很像一个不会改变的分支 - 它只是一个特定提交的引用。

然而，附注标签是存储在 Git 数据库中的一个完整对象。它们是可以被校验的；其中包含打标签者的名字、电子邮件地址、日期时间；还有一个标签信息；并且可以使用 GNU Privacy Guard（GPG）签名与验证。通常建议创建附注标签，这样你可以拥有以上所有信息；但是如果你只是想用一个临时的标签，或者因为某些原因不想要保存那些信息，轻量标签也是可用的。

### 附注标签

在 Git 中创建一个附注标签是很简单的。最简单的方式是当你在运行 tag 命令时指定 -a 选项：
~~~
$ git tag -a v1.4 -m 'my version 1.4'
$ git tag
v0.1
v1.3
v1.4
~~~
`-m` 选项指定了一条将会存储在标签中的信息。如果没有为附注标签指定一条信息，Git 会运行编辑器要求你输入信息。 

通过使用 `git show` 命令可以看到标签信息与对应的提交信息：
~~~
$ git show v1.4
tag v1.4
Tagger: Ben Straub <ben@straub.cc>
Date: Sat May 3 20:19:12 2014 -0700
my version 1.4
commit ca82a6dff817ec66f44342007202690a93763949
Author: Scott Chacon <schacon@gee-mail.com>
Date: Mon Mar 17 21:52:11 2008 -0700
    changed the version number
~~~
输出显示了打标签者的信息、打标签的日期时间、附注信息，然后显示具体的提交信息。

### 轻量标签

另一种给提交打标签的方式是使用轻量标签。轻量标签本质上是将提交校验和存储到一个文件中——没有保存任何其他信息。创建轻量标签，不需要使用 `-a`、`-s` 或 `-m` 选项，只需要提供标签名字：
~~~
$ git tag v1.4-lw
$ git tag
v0.1
v1.3
v1.4
v1.4-lw
v1.5
~~~
这时，如果在标签上运行 git show，你不会看到额外的标签信息。命令只会显示出提交信息：
~~~
$ git show v1.4-lw
commit ca82a6dff817ec66f44342007202690a93763949
Author: Scott Chacon <schacon@gee-mail.com>
Date: Mon Mar 17 21:52:11 2008 -0700
    changed the version number
~~~

### 后期打标签

现在，假设在 v1.2 时你忘记给项目打标签，也就是在 “updated rakefile” 提交。你可以在之后补上标签。要在那个提交上打标签，你需要在命令的末尾指定提交的校验和（或部分校验和）:
~~~
$ git tag -a v1.2 9fceb02
~~~
可以看到你已经在那次提交上打上标签了

### 共享标签

默认情况下，git push 命令并不会传送标签到远程仓库服务器上。在创建完标签后你必须显式地推送标签到共
享服务器上。这个过程就像共享远程分支一样 - 你可以运行 `git push origin [tagname]`。
~~~
$ git push origin v1.5
Counting objects: 14, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (12/12), done.
Writing objects: 100% (14/14), 2.05 KiB | 0 bytes/s, done.
Total 14 (delta 3), reused 0 (delta 0)
To git@github.com:schacon/simplegit.git
 * [new tag] v1.5 -> v1.5
~~~
如果想要一次性推送很多标签，也可以使用带有 `--tags` 选项的 `git push` 命令。这将会把所有不在远程仓库服务器上的标签全部传送到那里。
~~~
$ git push origin --tags
Counting objects: 1, done.
Writing objects: 100% (1/1), 160 bytes | 0 bytes/s, done.
Total 1 (delta 0), reused 0 (delta 0)
To git@github.com:schacon/simplegit.git
 * [new tag] v1.4 -> v1.4
 * [new tag] v1.4-lw -> v1.4-lw
~~~
现在，当其他人从仓库中克隆或拉取，他们也能得到你的那些标签。

### 检出标签

在 Git 中你并不能真的检出一个标签，因为它们并不能像分支一样来回移动。如果你想要工作目录与仓库中特定的标签版本完全一样，可以使用 `git checkout -b [branchname] [tagname]` 在特定的标签上创建一个新分支：
~~~
$ git checkout -b version2 v2.0.0
Switched to a new branch 'version2'
~~~
当然，如果在这之后又进行了一次提交，`version2` 分支会因为改动向前移动了，那么 `version2` 分支就会和 `v2.0.0` 标签稍微有些不同，这时就应该当心了。

## Git别名

在我们结束本章 Git 基础之前，正好有一个小技巧可以使你的 Git 体验更简单、容易、熟悉：别名。我们不会在之后的章节中引用到或假定你使用过它们，但是你大概应该知道如何使用它们。

Git 并不会在你输入部分命令时自动推断出你想要的命令。如果不想每次都输入完整的 Git 命令，可以通过 `git config` 文件来轻松地为每一个命令设置一个别名。这里有一些例子你可以试试：
~~~
$ git config --global alias.co checkout
$ git config --global alias.br branch
$ git config --global alias.ci commit
$ git config --global alias.st status
~~~
这意味着，当要输入 `git commit`时，只需要输入 `git ci`。随着你继续不断地使用 Git，可能也会经常使
用其他命令，所以创建别名时不要犹豫。 在创建你认为应该存在的命令时这个技术会很有用。例如，为了解决取消暂存文件的易用性问题，可以向 Git 中 添加你自己的取消暂存别名：
~~~
$ git config --global alias.unstage 'reset HEAD --'
~~~
这会使下面的两个命令等价：
~~~
$ git unstage fileA
$ git reset HEAD -- fileA
~~~
这样看起来更清楚一些。通常也会添加一个 `last` 命令，像这样：
~~~
$ git config --global alias.last 'log -1 HEAD'
~~~
这样，可以轻松地看到最后一次提交：
~~~
$ git last
commit 66938dae3329c7aebe598c2246a8e6af90d04646
Author: Josh Goebel <dreamer3@example.com>
Date: Tue Aug 26 19:48:51 2008 +0800
    test for current head
    Signed-off-by: Scott Chacon <schacon@example.com>
~~~
可以看出，Git 只是简单地将别名替换为对应的命令。然而，你可能想要执行外部命令，而不是一个 Git 子命
令。如果是那样的话，可以在命令前面加入 ! 符号。如果你自己要写一些与 Git 仓库协作的工具的话，那会很有
用。我们现在演示将 `git visual` 定义为 `gitk` 的别名：
~~~
$ git config --global alias.visual '!gitk'
~~~

# Git分支

几乎所有的版本控制系统都以某种形式支持分支。使用分支意味着你可以把你的工作从开发主线上分离开来，以免影响开发主线。在很多版本控制系统中，这是一个略微低效的过程——常常需要完全创建一个源代码目录的副本。对于大项目来说，这样的过程会耗费很多时间。

Git 处理分支的方式可谓是难以置信的轻量，创建新分支这一操作几乎能在瞬间完成，并且在不同分支之间的切换操作也是一样便捷。与许多其它版本控制系统不同，Git 鼓励在工作流 程中频繁地使用分支与合并，哪怕一天之内进行许多次。理解和精通这一特性，你便会意识到 Git 是如此的强大而又独特，并且从此真正改变你的开发方式。

## 分支简介

为了真正理解 Git 处理分支的方式，我们需要回顾一下 Git 是如何保存数据的。

或许你还记得 起步 的内容，Git 保存的不是文件的变化或者差异，而是一系列不同时刻的文件快照。

在进行提交操作时，Git 会保存一个提交对象（commit object）。知道了 Git 保存数据的方式，我们可以很自然的想到——该提交对象会包含一个指向暂存内容快照的指针。但不仅仅是这样，该提交对象还包含了作者的姓 名和邮箱、提交时输入的信息以及指向它的父对象的指针。首次提交产生的提交对象没有父对象，普通提交操作 产生的提交对象有一个父对象，而由多个分支合并产生的提交对象有多个父对象，

为了说得更加形象，我们假设现在有一个工作目录，里面包含了三个将要被暂存和提交的文件。暂存操作会为每一个文件计算校验和（使用我们在 起步 中提到的 SHA-1 哈希算法），然后会把当前版本的文件快照保存到 Git 仓库中（Git 使用 blob 对象来保存它们），最终将校验和加入到暂存区域等待提交：
~~~
$ git add README test.rb LICENSE
$ git commit -m 'The initial commit of my project'
~~~
当使用 git commit 进行提交操作时，Git 会先计算每一个子目录（本例中只有项目根目录）的校验和，然后在 Git 仓库中这些校验和保存为树对象。随后，Git 便会创建一个提交对象，它除了包含上面提到的那些信息外，还包含指向这个树对象（项目根目录）的指针。如此一来，Git 就可以在需要的时候重现此次保存的快照。

现在，Git 仓库中有五个对象：三个 blob 对象（保存着文件快照）、一个树对象（记录着目录结构和 blob 对象 索引）以及一个提交对象（包含着指向前述树对象的指针和所有提交信息）。

首次提交对象及其树结构
~~~
98ca9
-------------------------------------
|commit     size                    |
|tree       92ec2                   |
|author     Scott                   |
|commiter   Scott                   |
|The initial commit of my project   |
-------------------------------------
↓
92ec2
-----------------------------
|tree       size            |
|blob       5b1d3   README  |
|blob       911e7   LICENSE |
|blob       cba0a   test.rb |
-----------------------------
↓               ↓               ↓
5b1d3           911e7           cba0a
-------------   -------------   -------------
|blob   size|   |blob   size|   |blob   size|
|   ...     |   |   ...     |   |   ...     |
-------------   -------------   -------------
~~~

做些修改后再提交，那么这次产生的提交对象会包含一个指向上次提交对象（父对象）的指针。

提交对象及其父对象
~~~
98ca9                                   34ac2                   f30ab
-------------------------------------   ---------------------   ---------------------
|commit     size                    |   |commit     size    |   |commit     size    |
|tree       92ec2                   |   |tree       34ac2   |   |tree       f30ab   |
|parent                             |   |parent     98ca9   |   |parent     34ac2   |
|author     Scott                   |<--|author     Scott   |<--|author     Scott   |
|committer  Scott                   |   |committer  Scott   |   |committer  Scott   |
|The initial commit of my project   |   |Fixed bug #1328    |   |add feature #32    |
-------------------------------------   ---------------------   ---------------------
↓                                               ↓                       ↓
-----------------                       -----------------       -----------------
|   Snapshot A  |                       |   Snapshot B  |       |   Snapshot C  |
-----------------                       -----------------       -----------------
~~~
Git 的分支，其实本质上仅仅是指向提交对象的可变指针。Git 的默认分支名字是 master。在多次提交操作之后，你其实已经有一个指向最后那个提交对象的 master 分支。它会在每次的提交操作中自动向前移动。

> NOTE: Git 的 “master” 分支并不是一个特殊分支。它就跟其它分支完全没有区别。之所以几乎每一个仓库都有 master 分支，是因为 git init 命令默认创建它，并且大多数人都懒得去改动它。

分支及其提交历史
~~~
                                        -------------
                                        |   HEAD    |
                                        -------------
                                            ↓
                        -------------   -------------
                        |   v1.0    |   |   master  |
                        -------------   -------------
                                ↓           ↓
-------------   -------------   -------------
|   98ca9   |<--|   34ac2   |<--|   f30ab   |
-------------   -------------   -------------
    ↓               ↓               ↓
-------------   -------------   -------------
|Snapshot A |   |Snapshot B |   |Snapshot C |
-------------   -------------   -------------
~~~

### 分支创建

Git 是怎么创建新分支的呢？很简单，它只是为你创建了一个可以移动的新的指针。比如，创建一个 testing 分支，你需要使用 `git branch` 命令：
~~~
$ git branch testing
~~~
这会在当前所在的提交对象上创建一个指针

那么，Git 又是怎么知道当前在哪一个分支上呢？也很简单，它有一个名为 `HEAD` 的特殊指针。请注意它和许多其它版本控制系统（如 Subversion 或 CVS）里的 `HEAD` 概念完全不同。在 Git 中，它是一个指针，指向当前所在的本地分支（译注：将 `HEAD` 想象为当前分支的别名）。在本例中，你仍然在 master 分支上。因为 `git branch` 命令仅仅 创建 一个新分支，并不会自动切换到新分支中去。

你可以简单地使用 `git log` 命令查看各个分支当前所指的对象。提供这一功能的参数是 `--decorate`。

### 分支切换

要切换到一个已存在的分支，你需要使用 `git checkout` 命令。我们现在切换到新创建的 `testing` 分支去：
~~~
$ git checkout testing
~~~
这样 `HEAD` 就指向 `testing` 分支了

那么，这样的实现方式会给我们带来什么好处呢？现在不妨再提交一次：
~~~
$ vim test.rb
$ git commit -a -m 'made a change'
~~~
如图所示，你的 `testing` 分支向前移动了，但是 `master` 分支却没有，它仍然指向运行 `git checkout` 时所指的对象。这就有意思了，现在我们切换回 master 分支看看
~~~
$ git checkout master
~~~
这条命令做了两件事。一是使 HEAD 指回 master 分支，二是将工作目录恢复成 master 分支所指向的快照内容。也就是说，你现在做修改的话，项目将始于一个较旧的版本。本质上来讲，这就是忽略 testing 分支所做 的修改，以便于向另一个方向进行开发。

> NOTE: 分支切换会改变你工作目录中的文件
>在切换分支时，一定要注意你工作目录里的文件会被改变。如果是切换到一个较旧的分支，你的工作目录会恢复到该分支最后一次提交时的样子。如果 Git 不能干净利落地完成这个任 务，它将禁止切换分支。

我们不妨再稍微做些修改并提交：
~~~
$ vim test.rb
$ git commit -a -m 'made other changes'
~~~
现在，这个项目的提交历史已经产生了分叉（参见 项目分叉历史）。因为刚才你创建了一个新分支，并切换过去进行了一些工作，随后又切换回 master 分支进行了另外一些工作。上述两次改动针对的是不同分支：你可以在不同分支间不断地来回切换和工作，并在时机成熟时将它们合并起来。而所有这些工作，你需要的命令只有 `branch`、`checkout` 和 `commit`。

你可以简单地使用 git log 命令查看分叉历史。运行 `git log --oneline --decorate --graph --all` ，它会输出你的提交历史、各个分支的指向以及项目的分支分叉情况。

由于 Git 的分支实质上仅是包含所指对象校验和（长度为 40 的 SHA-1 值字符串）的文件，所以它的创建和销毁都异常高效。创建一个新分支就像是往一个文件中写入 41 个字节（40 个字符和 1 个换行符），如此的简单能不快吗？

这与过去大多数版本控制系统形成了鲜明的对比，它们在创建分支时，将所有的项目文件都复制一遍，并保存到一个特定的目录。完成这样繁琐的过程通常需要好几秒钟，有时甚至需要好几分钟。所需时间的长短，完全取决于项目的规模。而在 Git 中，任何规模的项目都能在瞬间创建新分支。同时，由于每次提交都会记录父对象，所以寻找恰当的合并基础（译注：即共同祖先）也是同样的简单和高效。这些高效的特性使得 Git 鼓励开发人员频 繁地创建和使用分支。

## 分支的新建与合并

### 新建分支

现在，你已经决定要解决你的公司使用的问题追踪系统中的 #53 问题。想要新建一个分支并同时切换到那个分支上，你可以运行一个带有 `-b` 参数的 `git checkout` 命令：
~~~
$ git checkout -b iss53
Switched to a new branch "iss53"
~~~
它是下面两条命令的简写：
~~~
$ git branch iss53
$ git checkout iss53
~~~
你继续在 #53 问题上工作，并且做了一些提交。在此过程中，iss53 分支在不断的向前推进，因为你已经检出 到该分支（也就是说，你的 HEAD 指针指向了 iss53 分支）
~~~
$ vim index.html
$ git commit -a -m 'added a new footer [issue 53]'
~~~
现在你接到那个电话，有个紧急问题等待你来解决。有了 Git 的帮助，你不必把这个紧急问题和 `iss53` 的修改混在一起，你也不需要花大力气来还原关于 `53#` 问题的修改，然后再添加关于这个紧急问题的修改，最后将这个修改提交到线上分支。你所要做的仅仅是切换回 `master` 分支。

但是，在你这么做之前，要留意你的工作目录和暂存区里那些还没有被提交的修改，它可能会和你即将检出的分支产生冲突从而阻止 Git 切换到该分支。最好的方法是，在你切换分支之前，保持好一个干净的状态。有一些方法可以绕过这个问题（即，保存进度（stashing） 和 修补提交（commit amending）），我们会在 储藏与清理 中看到关于这两个命令的介绍。现在，我们假设你已经把你的修改全部提交了，这时你可以切换回 `master` 分支了：
~~~
$ git checkout master
Switched to branch 'master'
~~~
这个时候，你的工作目录和你在开始 #53 问题之前一模一样，现在你可以专心修复紧急问题了。请牢记：当你切换分支的时候，Git 会重置你的工作目录，使其看起来像回到了你在那个分支上最后一次提交的样子。Git 会自动添加、删除、修改文件以确保此时你的工作目录和这个分支最后一次提交时的样子一模一样。

接下来，你要修复这个紧急问题。让我们建立一个针对该紧急问题的分支（hotfix branch），在该分支上工作直到问题解决：
~~~
$ git checkout -b hotfix
Switched to a new branch 'hotfix'
$ vim index.html
$ git commit -a -m 'fixed the broken email address'
[hotfix 1fb7853] fixed the broken email address
 1 file changed, 2 insertions(+)
~~~

你可以运行你的测试，确保你的修改是正确的，然后将其合并回你的 `master` 分支来部署到线上。你可以使用 `git merge` 命令来达到上述目的：
~~~
$ git checkout master
$ git merge hotfix
Updating f42c576..3a0874c
Fast-forward
 index.html | 2 ++
 1 file changed, 2 insertions(+)
~~~
在合并的时候，你应该注意到了"快进（fast-forward）"这个词。由于当前 `master` 分支所指向的提交是你当前提交（有关 hotfix 的提交）的直接上游，所以 Git 只是简单的将指针向前移动。换句话说，当你试图合并两个分支时，如果顺着一个分支走下去能够到达另一个分支，那么 Git 在合并两者的时候，只会简单的将指针向前推进 （指针右移），因为这种情况下的合并操作没有需要解决的分歧——这就叫做 “快进（fast-forward）”。

现在，最新的修改已经在 `master` 分支所指向的提交快照中，你可以着手发布该修复了

关于这个紧急问题的解决方案发布之后，你准备回到被打断之前时的工作中。然而，你应该先删除 `hotfix` 分支，因为你已经不再需要它了 —— `master` 分支已经指向了同一个位置。你可以使用带 `-d` 选项的 `git branch` 命令来删除分支：
~~~
$ git branch -d hotfix
Deleted branch hotfix (3a0874c).
~~~
现在你可以切换回你正在工作的分支继续你的工作，也就是针对 #53 问题的那个分支（iss53 分支）。
~~~
$ git checkout iss53
Switched to branch "iss53"
$ vim index.html
$ git commit -a -m 'finished the new footer [issue 53]'
[iss53 ad82d7a] finished the new footer [issue 53]
1 file changed, 1 insertion(+)
~~~

你在 `hotfix` 分支上所做的工作并没有包含到 `iss53` 分支中。如果你需要拉取 `hotfix` 所做的修改，你可以使用 `git merge master` 命令将 `master` 分支合并入 `iss53` 分支，或者你也可以等到 `iss53` 分支完成其使命，再将其合并回 `master` 分支。

### 分支的合并

假设你已经修正了 #53 问题，并且打算将你的工作合并入 `master` 分支。为此，你需要合并 `iss53` 分支到 `master` 分支，这和之前你合并 `hotfix` 分支所做的工作差不多。你只需要检出到你想合并入的分支，然后运行 `git merge` 命令：
~~~
$ git checkout master
Switched to branch 'master'
$ git merge iss53
Merge made by the 'recursive' strategy.
index.html | 1 +
1 file changed, 1 insertion(+)
~~~
这和你之前合并 `hotfix` 分支的时候看起来有一点不一样。在这种情况下，你的开发历史从一个更早的地方开始
分叉开来（diverged）。因为，`master` 分支所在提交并不是 `iss53` 分支所在提交的直接祖先，Git 不得不做一 些额外的工作。出现这种情况的时候，Git 会使用两个分支的末端所指的快照（`C4` 和 `C5`）以及这两个分支的工
作祖先（`C2`），做一个简单的三方合并。

和之间将分支指针向前推进所不同的是，Git 将此次三方合并的结果做了一个新的快照并且自动创建一个新的提交指向它。这个被称作一次合并提交，它的特别之处在于他有不止一个父提交。

需要指出的是，Git 会自行决定选取哪一个提交作为最优的共同祖先，并以此作为合并的基础；这和更加古老的 CVS 系统或者 Subversion （1.5 版本之前）不同，在这些古老的版本管理系统中，用户需要自己选择最佳的合 并基础。Git 的这个优势使其在合并操作上比其他系统要简单很多。

既然你的修改已经合并进来了，你已经不再需要 `iss53` 分支了。现在你可以在任务追踪系统中关闭此项任务， 并删除这个分支。
~~~
$ git branch -d iss53
~~~

### 遇到冲突时的分支合并

有时候合并操作不会如此顺利。如果你在两个不同的分支中，对同一个文件的同一个部分进行了不同的修改，Git 就没法干净的合并它们。如果你对 #53 问题的修改和有关 `hotfix` 的修改都涉及到同一个文件的同一处，在合并它们的时候就会产生合并冲突

~~~
$ git merge iss53
Auto-merging index.html
CONFLICT (content): Merge conflict in index.html
Automatic merge failed; fix conflicts and then commit the result.
~~~
此时 Git 做了合并，但是没有自动地创建一个新的合并提交。Git 会暂停下来，等待你去解决合并产生的冲突。你可以在合并冲突后的任意时刻使用 `git status` 命令来查看那些因包含合并冲突而处于未合并 （unmerged）状态的文件：
~~~
$ git status
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")
Unmerged paths:
  (use "git add <file>..." to mark resolution)
    both modified: index.html
no changes added to commit (use "git add" and/or "git commit -a")
~~~
任何因包含合并冲突而有待解决的文件，都会以未合并状态标识出来。Git 会在有冲突的文件中加入标准的冲突解决标记，这样你可以打开这些包含冲突的文件然后手动解决冲突。出现冲突的文件会包含一些特殊区段，看起来像下面这个样子：
~~~
<<<<<<< HEAD:index.html
<div id="footer">contact : email.support@github.com</div>
=======
<div id="footer">
 please contact us at support@github.com
</div>
>>>>>>> iss53:index.html
~~~
这表示 `HEAD` 所指示的版本（也就是你的 `master` 分支所在的位置，因为你在运行 merge 命令的时候已经检出
到了这个分支）在这个区段的上半部分（`=======` 的上半部分），而 `iss53` 分支所指示的版本在 `=======` 的 下半部分。为了解决冲突，你必须选择使用由 `=======` 分割的两部分中的一个，或者你也可以自行合并这些内
容。例如，你可以通过把这段内容换成下面的样子来解决冲突：
~~~
<div id="footer">
please contact us at email.support@github.com
</div>
~~~

上述的冲突解决方案仅保留了其中一个分支的修改，并且 `<<<<<<<` , `=======` , 和 `>>>>>>>` 这些行被完全删除了。在你解决了所有文件里的冲突之后，对每个文件使用 `git add` 命令来将其标记为冲突已解决。一旦暂存这 些原本有冲突的文件，Git 就会将它们标记为冲突已解决。 

如果你想使用图形化工具来解决冲突，你可以运行 `git mergetool`，该命令会为你启动一个合适的可视化合并工具，并带领你一步一步解决这些冲突：

如果你想使用除默认工具（在这里 Git 使用 `opendiff` 做为默认的合并工具，因为作者在 Mac 上运行该程序） 外的其他合并工具，你可以在 “下列工具中（one of the following tools）” 这句后面看到所有支持的合并工具。然后输入你喜欢的工具名字就可以了。

> NOTE: 如果你需要更加高级的工具来解决复杂的合并冲突，我们会在 高级合并 介绍更多关于分支合并的内容。

等你退出合并工具之后，Git 会询问刚才的合并是否成功。如果你回答是，Git 会暂存那些文件以表明冲突已解决：你可以再次运行 `git status` 来确认所有的合并冲突都已被解决：

如果你对结果感到满意，并且确定之前有冲突的的文件都已经暂存了，这时你可以输入 `git commit` 来完成合 并提交。

## 分支管理

现在已经创建、合并、删除了一些分支，让我们看看一些常用的分支管理工具。

`git branch` 命令不只是可以创建与删除分支。如果不加任何参数运行它，会得到当前所有分支的一个列表：
~~~
$ git branch
  iss53
* master
  testing
~~~
注意 `master` 分支前的 `*` 字符：它代表现在检出的那一个分支（也就是说，当前 `HEAD` 指针所指向的分支）。这意味着如果在这时候提交，`master` 分支将会随着新的工作向前移动。如果需要查看每一个分支的最后一次提交，可以运行 `git branch -v` 命令：
~~~
$ git branch -v
  iss53 93b412c fix javascript issue
* master 7a98805 Merge branch 'iss53'
  testing 782fd34 add scott to the author list in the readmes
~~~
`--merged` 与 `--no-merged` 这两个有用的选项可以过滤这个列表中已经合并或尚未合并到当前分支的分支。如果要查看哪些分支已经合并到当前分支，可以运行 `git branch --merged`：
~~~
$ git branch --merged
  iss53
* master
~~~
因为之前已经合并了 `iss53` 分支，所以现在看到它在列表中。在这个列表中分支名字前没有 `*` 号的分支通常可以使用 `git branch -d` 删除掉；你已经将它们的工作整合到了另一个分支，所以并不会失去任何东西。

查看所有包含未合并工作的分支，可以运行 `git branch --no-merged`：
~~~
$ git branch --no-merged
  testing
~~~
这里显示了其他分支。因为它包含了还未合并的工作，尝试使用 `git branch -d` 命令删除它时会失败：
~~~
$ git branch -d testing
error: The branch 'testing' is not fully merged.
If you are sure you want to delete it, run 'git branch -D testing'.
~~~
如果真的想要删除分支并丢掉那些工作，如同帮助信息里所指出的，可以使用 `-D` 选项强制删除它。

## 分支开发工作流

在本节，我们会介绍一些常见的利用 分支进行开发的工作流程。而正是由于分支管理的便捷，才衍生出这些典型的工作模式，你可以根据项目实际情况选择一种用用看。

### 长期分支

因为 Git 使用简单的三方合并，所以就算在一段较长的时间内，反复把一个分支合并入另一个分支，也不是什么难事。也就是说，在整个项目开发周期的不同阶段，你可以同时拥有多个开放的分支；你可以定期地把某些特性分支合并入其他分支中。

许多使用 Git 的开发者都喜欢使用这种方式来工作，比如只在 `master` 分支上保留完全稳定的代码——有可能仅仅是已经发布或即将发布的代码。他们还有一些名为 `develop` 或者 `next` 的平行分支，被用来做后续开发或者 测试稳定性——这些分支不必保持绝对稳定，但是一旦达到稳定状态，它们就可以被合并入 `master` 分支了。这样，在确保这些已完成的特性分支（短期分支，比如之前的 `iss53` 分支）能够通过所有测试，并且不会引入更多 bug 之后，就可以合并入主干分支中，等待下一次的发布。

事实上我们刚才讨论的，是随着你的提交而不断右移的指针。稳定分支的指针总是在提交历史中落后一大截，而前沿分支的指针往往比较靠前

通常把他们想象成流水线（work silos）可能更好理解一点，那些经过测试考验的提交会被遴选到更加稳定的流水线上去。

你可以用这种方法维护不同层次的稳定性。一些大型项目还有一个 `proposed`（建议） 或 `pu: proposed updates`（建议更新）分支，它可能因包含一些不成熟的内容而不能进入 `next` 或者 `master`分支。这么做的目的是使你的分支具有不同级别的稳定性；当它们具有一定程度的稳定性后，再把它们合并入具有更高级别稳定性的分支中。再次强调一下，使用多个长期分支的方法并非必要，但是这么做通常很有帮助，尤其是当你在一个非常庞大或者复杂的项目中工作时。

### 特性分支

特性分支对任何规模的项目都适用。特性分支是一种短期分支，它被用来实现单一特性或其相关工作。也许你从来没有在其他的版本控制系统（`VCS`）上这么做过，因为在那些版本控制系统中创建和合并分支通常很费劲。然而，在 Git 中一天之内多次创建、使用、合并、删除分支都很常见。 

你已经在上一节中你创建的 `iss53` 和 `hotfix` 特性分支中看到过这种用法。你在上一节用到的特性分支 （`iss53` 和 `hotfix` 分支）中提交了一些更新，并且在它们合并入主干分支之后，你又删除了它们。这项技术能使你快速并且完整地进行上下文切换（context-switch）——因为你的工作被分散到不同的流水线中，在不同 的流水线中每个分支都仅与其目标特性相关，因此，在做代码审查之类的工作的时候就能更加容易地看出你做了 哪些改动。你可以把做出的改动在特性分支中保留几分钟、几天甚至几个月，等它们成熟之后再合并，而不用在乎它们建立的顺序或工作进度。

考虑这样一个例子，你在 `master` 分支上工作到 `C1`，这时为了解决一个问题而新建 `iss91` 分支，在 `iss91` 分
支上工作到 `C4`，然而对于那个问题你又有了新的想法，于是你再新建一个 `iss91v2` 分支试图用另一种方法解决
那个问题，接着你回到 `master` 分支工作了一会儿，你又冒出了一个不太确定的想法，你便在 `C10` 的时候新建
一个 `dumbidea` 分支，并在上面做些实验。你的提交历史看起来像下面这个样子：

~~~
（dumbidea）
C13
↓               (master)    (iss91)     (iss91v2)
C12 --------->  C10         C6          C11
                ↓           ↓           ↓
                C9          C5          C8
                ↓           ↓           ↓
                C3          C4  <-----  C7
                ↓           ↓
                C1  <-----  C2
                ↓
                C0
~~~

现在，我们假设两件事情：你决定使用第二个方案来解决那个问题，即使用在 `iss91v2` 分支中方案；另外，你将 `dumbidea` 分支拿给你的同事看过之后，结果发现这是个惊人之举。这时你可以抛弃 `iss91` 分支（即丢弃 `C5` 和 `C6` 提交），然后把另外两个分支合并入主干分支。最终你的提交历史看起来像下面这个样子:

~~~
(master)
C14 -------------
↓               ↓
(dumbidea)  (iss91v2)
C13         C11
↓           ↓
C12         C8
↓           ↓
C10         C7
↓           ↓
C9          C4
↓           ↓
C3          C2
↓           |
C1  <--------
↓
C0
~~~

我们将会在 分布式 Git 中向你揭示更多有关分支工作流的细节，因此，请确保你阅读完那个章节之后，再来决定你的下个项目要使用什么样的分支策略（branching scheme）。

请牢记，当你做这么多操作的时候，这些分支全部都存于本地。当你新建和合并分支的时候，所有这一切都只发生在你本地的 Git 版本库中 —— 没有与服务器发生交互。

## 远程分支

远程引用是对远程仓库的引用（指针），包括分支、标签等等。你可以通过 `git ls-remote (remote)` 来显式地获得远程引用的完整列表，或者通过 `git remote show (remote)` 获得远程分支的更多信息。然而，一个更常见的做法是利用远程跟踪分支。

远程跟踪分支是远程分支状态的引用。它们是你不能移动的本地引用，当你做任何网络通信操作时，它们会自动移动。远程跟踪分支像是你上次连接到远程仓库时，那些分支所处状态的书签。

### 推送

当你想要公开分享一个分支时，需要将其推送到有写入权限的远程仓库上。本地的分支并不会自动与远程仓库同步 - 你必须显式地推送想要分享的分支。这样，你就可以把不愿意分享的内容放到私人分支上，而将需要和别人 协作的内容推送到公开分支。

> NOTE：如何避免每次输入密码
> 如果你正在使用 HTTPS URL 来推送，Git 服务器会询问用户名与密码。默认情况下它会在终 端中提示服务器是否允许你进行推送。 
> 如果不想在每一次推送时都输入用户名与密码，你可以设置一个 “credential cache”。最简单的方式就是将其保存在内存中几分钟，可以简单地运行 `git config --global credential.helper cache` 来设置它。
> 想要了解更多关于不同验证缓存的可用选项，查看 凭证存储。

### 跟踪分支

从一个远程跟踪分支检出一个本地分支会自动创建一个叫做 “跟踪分支”（有时候也叫做 “上游分支”）。跟踪分支是与远程分支有直接关系的本地分支。如果在一个跟踪分支上输入 `git pull`，Git 能自动地识别去哪个服务器上抓取、合并到哪个分支。

### 拉取

当 `git fetch` 命令从服务器上抓取本地没有的数据时，它并不会修改工作目录中的内容。它只会获取数据然后让你自己合并。然而，有一个命令叫作 `git pull` 在大多数情况下它的含义是一个 `git fetch` 紧接着一个 `git merge` 命令。如果有一个像之前章节中演示的设置好的跟踪分支，不管它是显式地设置还是通过 `clone` 或 `checkout` 命令为你创建的，`git pull` 都会查找当前分支所跟踪的服务器与分支，从服务器上抓取数据然后尝试合并入那个远程分支。

由于 `git pull` 的魔法经常令人困惑所以通常单独显式地使用 `fetch` 与 `merge` 命令会更好一些。

### 删除远程分支

假设你已经通过远程分支做完所有的工作了 - 也就是说你和你的协作者已经完成了一个特性并且将其合并到了远
程仓库的 `master` 分支（或任何其他稳定代码分支）。可以运行带有 `--delete` 选项的 `git push` 命令来删除
一个远程分支。如果想要从服务器上删除 `serverfix` 分支，运行下面的命令：
~~~
$ git push origin --delete serverfix
To https://github.com/schacon/simplegit
 - [deleted] serverfix
~~~
基本上这个命令做的只是从服务器上移除这个指针。Git 服务器通常会保留数据一段时间直到垃圾回收运行，所以如果不小心删除掉了，通常是很容易恢复的。

## 变基

在 Git 中整合来自不同分支的修改主要有两种方法：`merge` 以及 `rebase`。在本节中我们将学习什么是“变 基”，怎样使用“变基”，并将展示该操作的惊艳之处，以及指出在何种情况下你应避免使用它。

### 变基的基本操作

请回顾之前在 分支的合并 中的一个例子，你会看到开发任务分叉到两个不同分支，又各自提交了更新。

之前介绍过，整合分支最容易的方法是 `merge` 命令。它会把两个分支的最新快照（`C3` 和 `C4`）以及二者最近的 共同祖先（`C2`）进行三方合并，合并的结果是生成一个新的快照（并提交）。

其实，还有一种方法：你可以提取在 `C4` 中引入的补丁和修改，然后在 `C3` 的基础上再应用一次。在 Git 中，这种操作就叫做 变基。你可以使用 `rebase` 命令将提交到某一分支上的所有修改都移至另一分支上，就好像“重新播放”一样。

在上面这个例子中，运行：
~~~
$ git checkout experiment
$ git rebase master
First, rewinding head to replay your work on top of it...
Applying: added staged command
~~~

它的原理是首先找到这两个分支（即当前分支 `experiment`、变基操作的目标基底分支 `master`）的最近共同祖先 `C2`，然后对比当前分支相对于该祖先的历次提交，提取相应的修改并存为临时文件，然后将当前分支指向目标基底 `C3`, 最后以此将之前另存为临时文件的修改依序应用。（译注：写明了 commit id，以便理解，下同）

现在回到 master 分支，进行一次快进合并。
~~~
$ git checkout master
$ git merge experiment
~~~
此时，`C4` 指向的快照就和上面使用 `merge` 命令的例子中 `C5` 指向的快照一模一样了。这两种整合方法的最终结果没有任何区别，但是变基使得提交历史更加整洁。你在查看一个经过变基的分支的历史记录时会发现，尽管实际的开发工作是并行的，但它们看上去就像是先后串行的一样，提交历史是一条直线没有分叉。

一般我们这样做的目的是为了确保在向远程分支推送时能保持提交历史的整洁——例如向某个别人维护的项目贡献代码时。在这种情况下，你首先在自己的分支里进行开发，当开发完成时你需要先将你的代码变基到 `origin/master` 上，然后再向主项目提交修改。这样的话，该项目的维护者就不再需要进行整合工作，只需要快进合并便可。

请注意，无论是通过变基，还是通过三方合并，整合的最终结果所指向的快照始终是一样的，只不过提交历史不 同罢了。变基是将一系列提交按照原有次序依次应用到另一分支上，而合并是把最终结果合在一起。

### 更有趣的变基例子

在对两个分支进行变基时，所生成的“重演”并不一定要在目标分支上应用，你也可以指定另外的一个分支进行应用。就像 从一个特性分支里再分出一个特性分支的提交历史 中的例子这样。你创建了一个特性分支 `server`，为服务端添加了一些功能，提交了 `C3` 和 `C4`。然后从 `C3` 上创建了特性分支 `client`，为客户端添加了一些功能，提交了 `C8` 和 `C9`。最后，你回到 `server` 分支，又提交了 `C10`。

假设你希望将 client 中的修改合并到主分支并发布，但暂时并不想合并 server 中的修改，因为它们还需要经过更全面的测试。这时，你就可以使用 `git rebase` 命令的 `--onto` 选项，选中在 `client` 分支里但不在 `server` 分支里的修改（即 `C8` 和 `C9`），将它们在 `master` 分支上重演：
~~~
$ git rebase --onto master server client
~~~
以上命令的意思是：“取出 `client` 分支，找出处于 `client` 分支和 `server` 分支的共同祖先之后的修改，然
后把它们在 `master` 分支上重演一遍”。这理解起来有一点复杂，不过效果非常酷。

现在可以快进合并 `master` 分支了。（如图 快进合并 master 分支，使之包含来自 client 分支的修改）：
~~~
$ git checkout master
$ git merge client
~~~

接下来你决定将 server 分支中的修改也整合进来。使用 `git rebase [basebranch] [topicbranch]` 命令可以直接将特性分支（即本例中的 `server`）变基到目标分支（即 `master`）上。这样做能省去你先切换到 `server` 分支，再对其执行变基命令的多个步骤。
~~~
$ git rebase master server
~~~
如图 将 server 中的修改变基到 master 上 所示，`server` 中的代码被“续”到了 `master` 后面。

然后就可以快进合并主分支 `master` 了：
~~~
$ git checkout master
$ git merge server
~~~
至此，`client` 和 `server` 分支中的修改都已经整合到主分支里去了，你可以删除这两个分支

### 变基的风险

呃，奇妙的变基也并非完美无缺，要用它得遵守一条准则：

**不要对在你的仓库外有副本的分支执行变基。**

变基操作的实质是丢弃一些现有的提交，然后相应地新建一些内容一样但实际上不同的提交。如果你已经将提交推送至某个仓库，而其他人也已经从该仓库拉取提交并进行了后续工作，此时，如果你用 `git rebase` 命令重新整理了提交并再次推送，你的同伴因此将不得不再次将他们手头的工作与你的提交进行整合，如果接下来你还要拉取并整合他们修改过的提交，事情就会变得一团糟。

### 用变基解决变基

如果你 真的 遭遇了类似的处境，Git 还有一些高级魔法可以帮到你。如果团队中的某人强制推送并覆盖了一些你所基于的提交，你需要做的就是检查你做了哪些修改，以及他们覆盖了哪些修改。

实际上，Git 除了对整个提交计算 SHA-1 校验和以外，也对本次提交所引入的修改计算了校验和——即 “patch-id”。 

如果你拉取被覆盖过的更新并将你手头的工作基于此进行变基的话，一般情况下 Git 都能成功分辨出哪些是你的 修改，并把它们应用到新分支上。

举个例子，如果遇到前面提到的 有人推送了经过变基的提交，并丢弃了你的本地开发所基于的一些提交 那种情境，如果我们不是执行合并，而是执行 `git rebase teamone/master`, Git 将会：

- 检查哪些提交是我们的分支上独有的（C2，C3，C4，C6，C7） 
- 检查其中哪些提交不是合并操作的结果（C2，C3，C4）
- 检查哪些提交在对方覆盖更新时并没有被纳入目标分支（只有 C2 和 C3，因为 C4 其实就是 C4'）
- 把查到的这些提交应用在 `teamone/master` 上面

从而我们将得到与 你将相同的内容又合并了一次，生成了一个新的提交 中不同的结果，如图 在一个被变基然后强制推送的分支上再次执行变基 所示。

要想上述方案有效，还需要对方在变基时确保 C4' 和 C4 是几乎一样的。否则变基操作将无法识别，并新建另一 个类似 C4 的补丁（而这个补丁很可能无法整洁的整合入历史，因为补丁中的修改已经存在于某个地方了）。

在本例中另一种简单的方法是使用 `git pull --rebase` 命令而不是直接 `git pull`。又或者你可以自己手动 完成这个过程，先 `git fetch`，再 `git rebase teamone/master`。 

如果你习惯使用 `git pull` ，同时又希望默认使用选项 `--rebase`，你可以执行这条语句 `git config --global pull.rebase true` 来更改 `pull.rebase` 的默认配置。

只要你把变基命令当作是在推送前清理提交使之整洁的工具，并且只在从未推送至共用仓库的提交上执行变基命令，你就不会有事。假如你在那些已经被推送至共用仓库的提交上执行变基命令，并因此丢弃了一些别人的开发所基于的提交，那你就有大麻烦了，你的同事也会因此鄙视你。 

如果你或你的同事在某些情形下决意要这么做，请一定要通知每个人执行 `git pull --rebase` 命令，这样尽管不能避免伤痛，但能有所缓解。

### 变基 vs. 合并

至此，你已在实战中学习了变基和合并的用法，你一定会想问，到底哪种方式更好。在回答这个问题之前，让我们退后一步，想讨论一下提交历史到底意味着什么。

有一种观点认为，仓库的提交历史即是 记录实际发生过什么。它是针对历史的文档，本身就有价值，不能乱改。从这个角度看来，改变提交历史是一种亵渎，你使用_谎言_掩盖了实际发生过的事情。如果由合并产生的 提交历史是一团糟怎么办？既然事实就是如此，那么这些痕迹就应该被保留下来，让后人能够查阅。 

另一种观点则正好相反，他们认为提交历史是 项目过程中发生的故事。没人会出版一本书的第一批草稿，软件维护手册也是需要反复修订才能方便使用。持这一观点的人会使用 rebase 及 filter-branch 等工具来编写故事，怎么方便后来的读者就怎么写。

现在，让我们回到之前的问题上来，到底合并还是变基好？希望你能明白，并没有一个简单的答案。Git 是一个非常强大的工具，它允许你对提交历史做许多事情，但每个团队、每个项目对此的需求并不相同。既然你已经分别学习了两者的用法，相信你能够根据实际情况作出明智的选择。 

总的原则是，只对尚未推送或分享给别人的本地修改执行变基操作清理历史，从不对已推送至别处的提交执行变基操作，这样，你才能享受到两种方式带来的便利。

# 服务器上的Git

到目前为止，你应该已经有办法使用 Git 来完成日常工作。然而，为了使用 Git 协作功能，你还需要有远程的 Git 仓库。尽管在技术上你可以从个人仓库进行推送（push）和拉取（pull）来修改内容，但不鼓励使用这种方 法，因为一不留心就很容易弄混其他人的进度。此外，你希望你的合作者们即使在你的电脑未联机时亦能存取仓库 — 拥有一个更可靠的公用仓库十分有用。因此，与他人合作的最佳方法即是建立一个你与合作者们都有权利访问，且可从那里推送和拉取资料的共用仓库。

一个远程仓库通常只是一个裸仓库（bare repository）— 即一个没有当前工作目录的仓库。因为该仓库仅仅作 为合作媒介，不需要从磁碟检查快照；存放的只有 Git 的资料。简单的说，裸仓库就是你专案目录内的 `.git` 子 目录内容，不包含其他资料。

## 协议

Git 可以使用四种主要的协议来传输资料：本地协议（Local），HTTP 协议，SSH（Secure Shell）协议及 Git 协议。在此，我们将会讨论那些协议及哪些情形应该使用（或避免使用）他们。

### 本地协议

### HTTP协议

Git 通过 HTTP 通信有两种模式。在 Git 1.6.6 版本之前只有一个方式可用，十分简单并且通常是只读模式的。Git 1.6.6 版本引入了一种新的、更智能的协议，让 Git 可以像通过 SSH 那样智能的协商和传输数据。之后几年，这个新的 HTTP 协议因为其简单、智能变的十分流行。新版本的 HTTP 协议一般被称为“智能” HTTP 协议，旧版本的一般被称为“哑” HTTP 协议。

### SSH协议

### Git协议

## 在服务器上搭建Git

## 生成SSH公钥

## 配置服务器

## Git守护进程

## Smart HTTP

## GitWeb

## Gitlab

## 第三方托管的选择

# 分布式Git

# GitHub

# Git工具

## 子模块

有种情况我们经常会遇到：某个工作中的项目需要包含并使用另一个项目。也许是第三方库，或者你独立开发的，用于多个父项目的库。现在问题来了：你想要把它们当做两个独立的项目，同时又想在一个项目中使用另一个。

我们举一个例子。假设你正在开发一个网站然后创建了 Atom 订阅。你决定使用一个库，而不是写自己的 Atom生成代码。你可能不得不通过 CPAN 安装或 Ruby gem 来包含共享库中的代码，或者将源代码直接拷贝到自己的项目中。如果将这个库包含进来，那么无论用何种方式都很难定制它，部署则更加困难，因为你必须确保每一个客户端都包含该库。如果将代码复制到自己的项目中，那么你做的任何自定义修改都会使合并上游的改动变得困难。

Git 通过子模块来解决这个问题。子模块允许你将一个 Git 仓库作为另一个 Git 仓库的子目录。它能让你将另一 个仓库克隆到自己的项目中，同时还保持提交的独立。

### 开始使用子模块

我们将要演示如何在一个被分成一个主项目与几个子项目的项目上开发。

我们首先将一个已存在的 Git 仓库添加为正在工作的仓库的子模块。你可以通过在 `git submodule add` 命令后面加上想要跟踪的项目 URL 来添加新的子模块。在本例中，我们将会添加一个名为 “DbConnector” 的库。

~~~shell
$ git submodule add https://github.com/chaconinc/DbConnector
Cloning into 'DbConnector'...
remote: Counting objects: 11, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 11 (delta 0), reused 11 (delta 0)
Unpacking objects: 100% (11/11), done.
Checking connectivity... done.
~~~

默认情况下，子模块会将子项目放到一个与仓库同名的目录中，本例中是 “DbConnector”。如果你想要放到 其他地方，那么可以在命令结尾添加一个不同的路径。 

如果这时运行 `git status`，你会注意到几件事。

~~~shell
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
new file: .gitmodules
new file: DbConnector
~~~

首先应当注意到新的 `.gitmodules` 文件。该置文件保存了项目 URL 与已经拉取的本地目录之间的映射：

~~~shell
$ cat .gitmodules
[submodule "DbConnector"]
path = DbConnector
url = https://github.com/chaconinc/DbConnector
~~~

如果有多个子模块，该文件中就会有多条记录。要重点注意的是，该文件也像 .gitignore 文件一样受到（通过）版本控制。它会和该项目的其他部分一同被拉取推送。这就是克隆该项目的人知道去哪获得子模块的原因。

> NOTE: 由于 .gitmodules 文件中的 URL 是人们首先尝试克隆/拉取的地方，因此请尽可能确保你使用的URL 大家都能访问。例如，若你要使用的推送 URL 与他人的拉取 URL 不同，那么请使用他人能访问到的 URL。你也可以根据自己的需要，通过在本地执行 git config submodule.DbConnector.url <私有URL> 来覆盖这个选项的值。如果可行的话，一个相对路径会很有帮助。

在 `git status` 输出中列出的另一个是项目文件夹记录。如果你运行 `git diff`，会看到类似下面的信息：

~~~shell
$ git diff --cached DbConnector
diff --git a/DbConnector b/DbConnector
new file mode 160000
index 0000000..c3f01dc
--- /dev/null
+++ b/DbConnector
@@ -0,0 +1 @@
+Subproject commit c3f01dc8862123d317dd46284b05b6892c7b29bc
~~~

虽然 DbConnector 是工作目录中的一个子目录，但 Git 还是会将它视作一个子模块。当你不在那个目录中时，Git 并不会跟踪它的内容，而是将它看作该仓库中的一个特殊提交。 

如果你想看到更漂亮的差异输出，可以给 `git diff` 传递 `--submodule` 选项。

~~~shell
$ git diff --cached --submodule
diff --git a/.gitmodules b/.gitmodules
new file mode 100644
index 0000000..71fc376
--- /dev/null
+++ b/.gitmodules
@@ -0,0 +1,3 @@
+[submodule "DbConnector"]
+ 		path = DbConnector
+ 		url = https://github.com/chaconinc/DbConnector
Submodule DbConnector 0000000...c3f01dc (new submodule)
~~~

当你提交时，会看到类似下面的信息:

~~~shell
$ git commit -am 'added DbConnector module'
[master fb9093c] added DbConnector module
 2 files changed, 4 insertions(+)
 create mode 100644 .gitmodules
 create mode 160000 DbConnector
~~~

注意 DbConnector 记录的 `160000` 模式。这是 Git 中的一种特殊模式，它本质上意味着你是将一次提交记作一

项目录记录的，而非将它记录成一个子目录或者一个文件。

### 克隆含有子模块的项目

接下来我们将会克隆一个含有子模块的项目。当你在克隆这样的项目时，默认会包含该子模块目录，但其中还没有任何文件：

~~~shell
$ git clone https://github.com/chaconinc/MainProject
Cloning into 'MainProject'...
remote: Counting objects: 14, done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 14 (delta 1), reused 13 (delta 0)
Unpacking objects: 100% (14/14), done.
Checking connectivity... done.
$ cd MainProject
$ ls -la
total 16
drwxr-xr-x 9 schacon staff 306 Sep 17 15:21 .
drwxr-xr-x 7 schacon staff 238 Sep 17 15:21 ..
drwxr-xr-x 13 schacon staff 442 Sep 17 15:21 .git
-rw-r--r-- 1 schacon staff 92 Sep 17 15:21 .gitmodules
drwxr-xr-x 2 schacon staff 68 Sep 17 15:21 DbConnector
-rw-r--r-- 1 schacon staff 756 Sep 17 15:21 Makefile
drwxr-xr-x 3 schacon staff 102 Sep 17 15:21 includes
drwxr-xr-x 4 schacon staff 136 Sep 17 15:21 scripts
drwxr-xr-x 4 schacon staff 136 Sep 17 15:21 src
$ cd DbConnector/
$ ls
$
~~~

其中有 DbConnector 目录，不过是空的。你必须运行两个命令：`git submodule init` 用来初始化本地配置文件，而 `git submodule update` 则从该项目中抓取所有数据并检出父项目中列出的合适的提交。

~~~shell
$ git submodule init
Submodule 'DbConnector' (https://github.com/chaconinc/DbConnector)
registered for path 'DbConnector'
$ git submodule update
Cloning into 'DbConnector'...
remote: Counting objects: 11, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 11 (delta 0), reused 11 (delta 0)
Unpacking objects: 100% (11/11), done.
Checking connectivity... done.
Submodule path 'DbConnector': checked out
'c3f01dc8862123d317dd46284b05b6892c7b29bc'
~~~

现在 DbConnector 子目录是处在和之前提交时相同的状态了。

不过还有更简单一点的方式。如果给 git clone 命令传递 --recursive 选项，它就会自动初始化并更新仓库中的每一个子模块。

~~~shell
$ git clone --recursive https://github.com/chaconinc/MainProject
Cloning into 'MainProject'...
remote: Counting objects: 14, done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 14 (delta 1), reused 13 (delta 0)
Unpacking objects: 100% (14/14), done.
Checking connectivity... done.
Submodule 'DbConnector' (https://github.com/chaconinc/DbConnector)
registered for path 'DbConnector'
Cloning into 'DbConnector'...
remote: Counting objects: 11, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 11 (delta 0), reused 11 (delta 0)
Unpacking objects: 100% (11/11), done.
Checking connectivity... done.
Submodule path 'DbConnector': checked out
'c3f01dc8862123d317dd46284b05b6892c7b29bc'
~~~

### 在包含子模块的项目上工作

现在我们有一份包含子模块的项目副本，我们将会同时在主项目和子模块项目上与队员协作。

#### 拉取上游修改

在项目中使用子模块的最简模型，就是只使用子项目并不时地获取更新，而并不在你的检出中进行任何更改。我们来看一个简单的例子。 

如果想要在子模块中查看新工作，可以进入到目录中运行 `git fetch` 与 `git merge`，合并上游分支来更新本地代码。

~~~shell
$ git fetch
From https://github.com/chaconinc/DbConnector
   c3f01dc..d0354fc master -> origin/master
$ git merge origin/master
Updating c3f01dc..d0354fc
Fast-forward
 scripts/connect.sh | 1 +
 src/db.c | 1 +
 2 files changed, 2 insertions(+)
~~~

如果你现在返回到主项目并运行 `git diff --submodule`，就会看到子模块被更新的同时获得了一个包含新添加提交的列表。如果你不想每次运行 `git diff` 时都输入 `--submodle`，那么可以将 `diff.submodule` 设置为 “log” 来将其作为默认行为。

~~~shell
$ git config --global diff.submodule log
$ git diff
Submodule DbConnector c3f01dc..d0354fc:
  > more efficient db routine
  > better connection routine
~~~

如果在此时提交，那么你会将子模块锁定为其他人更新时的新代码。 

如果你不想在子目录中手动抓取与合并，那么还有种更容易的方式。运行 git submodule update --remote，Git 将会进入子模块然后抓取并更新。

~~~shell
$ git submodule update --remote DbConnector
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 4 (delta 2), reused 4 (delta 2)
Unpacking objects: 100% (4/4), done.
From https://github.com/chaconinc/DbConnector
   3f19983..d0354fc master -> origin/master
Submodule path 'DbConnector': checked out
'd0354fc054692d3906c85c3af05ddce39a1c0644'
~~~

此命令默认会假定你想要更新并检出子模块仓库的 `master` 分支。不过你也可以设置为想要的其他分支。例如，你想要 DbConnector 子模块跟踪仓库的 “stable” 分支，那么既可以在 `.gitmodules` 文件中设置（这样其他人也可以跟踪它），也可以只在本地的 `.git/config` 文件中设置。让我们在 `.gitmodules` 文件中设置它：

~~~shell
$ git config -f .gitmodules submodule.DbConnector.branch stable
$ git submodule update --remote
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 4 (delta 2), reused 4 (delta 2)
Unpacking objects: 100% (4/4), done.
From https://github.com/chaconinc/DbConnector
   27cf5d3..c87d55d stable -> origin/stable
Submodule path 'DbConnector': checked out
'c87d55d4c6d4b05ee34fbc8cb6f7bf4585ae6687'
~~~

如果不用` -f .gitmodules` 选项，那么它只会为你做修改。但是在仓库中保留跟踪信息更有意义一些，因为其他人也可以得到同样的效果。

这时我们运行 `git status`，Git 会显示子模块中有 “新提交”。

~~~shell
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working
directory)
  modified: .gitmodules
  modified: DbConnector (new commits)
no changes added to commit (use "git add" and/or "git commit -a")
~~~

如果你设置了配置选项 `status.submodulesummary`，Git 也会显示你的子模块的更改摘要：

~~~shell
$ git config status.submodulesummary 1
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working
directory)
modified: .gitmodules
modified: DbConnector (new commits)
Submodules changed but not updated:
* DbConnector c3f01dc...c87d55d (4):
  > catch non-null terminated lines
~~~

这时如果运行 `git diff`，可以看到我们修改了 .gitmodules 文件，同时还有几个已拉取的提交需要提交到我们自己的子模块项目中。

~~~shell
$ git diff
diff --git a/.gitmodules b/.gitmodules
index 6fc0b3d..fd1cc29 100644
--- a/.gitmodules
+++ b/.gitmodules
@@ -1,3 +1,4 @@
 [submodule "DbConnector"]
        path = DbConnector
        url = https://github.com/chaconinc/DbConnector
+ branch = stable
 Submodule DbConnector c3f01dc..c87d55d:
  > catch non-null terminated lines
  > more robust error handling
  > more efficient db routine
  > better connection routine
~~~

这非常有趣，因为我们可以直接看到将要提交到子模块中的提交日志。提交之后，你也可以运行 `git log -p`查看这个信息。

~~~shell
$ git log -p --submodule
commit 0a24cfc121a8a3c118e0105ae4ae4c00281cf7ae
Author: Scott Chacon <schacon@gmail.com>
Date: Wed Sep 17 16:37:02 2014 +0200
    updating DbConnector for bug fixes
diff --git a/.gitmodules b/.gitmodules
index 6fc0b3d..fd1cc29 100644
--- a/.gitmodules
+++ b/.gitmodules
@@ -1,3 +1,4 @@
 [submodule "DbConnector"]
        path = DbConnector
        url = https://github.com/chaconinc/DbConnector
+ branch = stable
Submodule DbConnector c3f01dc..c87d55d:
  > catch non-null terminated lines
  > more robust error handling
  > more efficient db routine
  > better connection routine
~~~

当运行 `git submodule update --remote` 时，Git 默认会尝试更新**所有**子模块，所以如果有很多子模块的 话，你可以传递想要更新的子模块的名字。

#### 在子模块上工作

你很有可能正在使用子模块，因为你确实想在子模块中编写代码的同时，还想在主项目上编写代码（或者跨子模块工作）。否则你大概只能用简单的依赖管理系统（如 Maven 或 Rubygems）来替代了。

现在我们将通过一个例子来演示如何在子模块与主项目中同时做修改，以及如何同时提交与发布那些修改。

到目前为止，当我们运行 `git submodule update` 从子模块仓库中抓取修改时，Git 将会获得这些改动并更新子目录中的文件，但是会将子仓库留在一个称作 “游离的 HEAD” 的状态。这意味着没有本地工作分支（例如“master”）跟踪改动。所以你做的任何改动都不会被跟踪。

为了将子模块设置得更容易进入并修改，你需要做两件事。首先，进入每个子模块并检出其相应的工作分支。接着，若你做了更改就需要告诉 Git 它该做什么，然后运行 `git submodule update --remote` 来从上游拉取新工作。你可以选择将它们合并到你的本地工作中，也可以尝试将你的工作变基到新的更改上。

首先，让我们进入子模块目录然后检出一个分支。

~~~shell
$ git checkout stable
Switched to branch 'stable'
~~~

然后尝试用 “merge” 选项。为了手动指定它，我们只需给 `update` 添加 `--merge` 选项即可。这时我们将会看到服务器上的这个子模块有一个改动并且它被合并了进来。

~~~shell
$ git submodule update --remote --merge
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 4 (delta 2), reused 4 (delta 2)
Unpacking objects: 100% (4/4), done.
From https://github.com/chaconinc/DbConnector
   c87d55d..92c7337 stable -> origin/stable
Updating c87d55d..92c7337
Fast-forward
 src/main.c | 1 +
 1 file changed, 1 insertion(+)
Submodule path 'DbConnector': merged in
'92c7337b30ef9e0893e758dac2459d07362ab5ea'
~~~

如果我们进入 DbConnector 目录，可以发现新的改动已经合并入本地 stable 分支。现在让我们看看当我们对库做一些本地的改动而同时其他人推送另外一个修改到上游时会发生什么。

如果我们现在更新子模块，就会看到当我们在本地做了更改时上游也有一个改动，我们需要将它并入本地。

如果你忘记 `--rebase` 或 `--merge`，Git 会将子模块更新为服务器上的状态。并且会将项目重置为一个游离的HEAD 状态。

即便这真的发生了也不要紧，你只需回到目录中再次检出你的分支（即还包含着你的工作的分支）然后手动地合并或变基 `origin/stable`（或任何一个你想要的远程分支）就行了。

如果你没有提交子模块的改动，那么运行一个子模块更新也不会出现问题，此时 Git 会只抓取更改而并不会覆盖子模块目录中未保存的工作。

如果你做了一些与上游改动冲突的改动，当运行更新时 Git 会让你知道。

你可以进入子模块目录中然后就像平时那样修复冲突。

#### 发布子模块改动

现在我们的子模块目录中有一些改动。其中有一些是我们通过更新从上游引入的，而另一些是本地生成的，由于我们还没有推送它们，所以对任何其他人都不可用。

如果我们在主项目中提交并推送但并不推送子模块上的改动，其他尝试检出我们修改的人会遇到麻烦，因为他们无法得到依赖的子模块改动。那些改动只存在于我们本地的拷贝中。

为了确保这不会发生，你可以让 Git 在推送到主项目前检查所有子模块是否已推送。`git push` 命令接受可以设置为 “check” 或 “on-demand” 的 `--recurse-submodules` 参数。如果任何提交的子模块改动没有推送那么 “check” 选项会直接使 `push` 操作失败。

如你所见，它也给我们了一些有用的建议，指导接下来该如何做。最简单的选项是进入每一个子模块中然后手动推送到远程仓库，确保它们能被外部访问到，之后再次尝试这次推送。 

另一个选项是使用 “on-demand” 值，它会尝试为你这样做。

如你所见，Git 进入到 DbConnector 模块中然后在推送主项目前推送了它。如果那个子模块因为某些原因推送失败，主项目也会推送失败。

#### 合并子模块改动

如果你其他人同时改动了一个子模块引用，那么可能会遇到一些问题。也就是说，如果子模块的历史已经分叉并且在父项目中分别提交到了分叉的分支上，那么你需要做一些工作来修复它。

如果一个提交是另一个的直接祖先（一个快进式合并），那么 Git会简单地选择之后的提交来合并，这样没什么问题。

不过，Git 甚至不会尝试去进行一次简单的合并。

所以本质上 Git 在这里指出了子模块历史中的两个分支记录点已经分叉并且需要合并。它将其解释为 “merge following commits not found”（未找到接下来需要合并的提交），虽然这有点令人困惑，不过之后我们会解释为什么是这样。

为了解决这个问题，你需要弄清楚子模块应该处于哪种状态。奇怪的是，Git 并不会给你多少能帮你摆脱困境的信息，甚至连两边提交历史中的 SHA-1 值都没有。幸运的是，这很容易解决。如果你运行 `git diff`，就会得到试图合并的两个分支中记录的提交的 SHA-1 值。

所以，在本例中，`eb41d76` 是我们的子模块中大家共有的提交，而 `c771610` 是上游拥有的提交。如果我们进入子模块目录中，它应该已经在`eb41d76` 上了，因为合并没有动过它。如果不是的话，无论什么原因，你都可以简单地创建并检出一个指向它的分支。

来自另一边的提交的 SHA-1 值比较重要。它是需要你来合并解决的。你可以尝试直接通过 SHA-1 合并，也可以为它创建一个分支然后尝试合并。我们建议后者，哪怕只是为了一个更漂亮的合并提交信息。

所以，我们将会进入子模块目录，基于 `git diff` 的第二个 SHA 创建一个分支然后手动合并。

~~~shell
$ cd DbConnector
$ git rev-parse HEAD
eb41d764bccf88be77aced643c13a7fa86714135
$ git branch try-merge c771610
(DbConnector) $ git merge try-merge
Auto-merging src/main.c
CONFLICT (content): Merge conflict in src/main.c
Recorded preimage for 'src/main.c'
Automatic merge failed; fix conflicts and then commit the result.
~~~

我们在这儿得到了一个真正的合并冲突，所以如果想要解决并提交它，那么只需简单地通过结果来更新主项目。

~~~shell
$ vim src/main.c ①
$ git add src/main.c
$ git commit -am 'merged our changes'
Recorded resolution for 'src/main.c'.
[master 9fd905e] merged our changes
$ cd .. ②
$ git diff ③
diff --cc DbConnector
index eb41d76,c771610..0000000
--- a/DbConnector
+++ b/DbConnector
@@@ -1,1 -1,1 +1,1 @@@
- Subproject commit eb41d764bccf88be77aced643c13a7fa86714135
 -Subproject commit c77161012afbbe1f58b5053316ead08f4b7e6d1d
++Subproject commit 9fd905e5d7f45a0d4cbc43d1ee550f16a30e825a
$ git add DbConnector ④
$ git commit -m "Merge Tom's Changes" ⑤
[master 10d2c60] Merge Tom's Changes
~~~

① 首先解决冲突

② 然后返回到主项目目录中 

③ 再次检查 SHA-1 值 

④ 解决冲突的子模块记录

⑤ 提交我们的合并 

这可能会让你有点儿困惑，但它确实不难。

有趣的是，Git 还能处理另一种情况。如果子模块目录中存在着这样一个合并提交，它的历史中包含了的两边的提交，那么 Git 会建议你将它作为一个可行的解决方案。它看到有人在子模块项目的某一点上合并了包含这两次提交的分支，所以你可能想要那个。

这就是为什么前面的错误信息是 “merge following commits not found”，因为它不能**这样**做。它让人困惑是因为**谁能想到它会尝试这样做**？

如果它找到了一个可以接受的合并提交，它会建议你更新索引，就像你运行了 `git add` 那样，这样会清除冲突然后提交。不过你可能不应该这样做。你 

可以轻松地进入子模块目录，查看差异是什么，快进到这次提交，恰当地测试，然后提交它。

~~~shell
$ cd DbConnector/
$ git merge 9fd905e
Updating eb41d76..9fd905e
Fast-forward
$ cd ..
$ git add DbConnector
$ git commit -am 'Fast forwarded to a common submodule child'
~~~

这些命令完成了同一件事，但是通过这种方式你至少可以验证工作是否有效，以及当你在完成时可以确保子模块目录中有你的代码。 

### 子模块技巧

你可以做几件事情来让用子模块工作轻松一点儿。

#### 子模块遍历

有一个 `foreach` 子模块命令，它能在每一个子模块中运行任意命令。如果项目中包含了大量子模块，这会非常有用。

#### 有用的别名

你可能想为其中一些命令设置别名，因为它们可能会非常长而你又不能设置选项作为它们的默认选项。

### 子模块的问题

然而使用子模块还是有一些小问题。 

例如在有子模块的项目中切换分支可能会造成麻烦。如果你创建一个新分支，在其中添加一个子模块，之后切换到没有该子模块的分支上时，你仍然会有一个还未跟踪的子模块目录。

另一个主要的告诫是许多人遇到了将子目录转换为子模块的问题。如果你在项目中已经跟踪了一些文件，然后想要将它们移动到一个子模块中，那么请务必小心，否则 Git 会对你发脾气。假设项目内有一些文件在子目录中，你想要将其转换为一个子模块。如果删除子目录然后运行 `submodule add`，Git 会朝你大喊：

~~~shell
$ rm -Rf CryptoLibrary/
$ git submodule add https://github.com/chaconinc/CryptoLibrary
'CryptoLibrary' already exists in the index
~~~

你必须要先取消暂存 `CryptoLibrary` 目录。然后才可以添加子模块：

~~~shell
$ git rm -r CryptoLibrary
$ git submodule add https://github.com/chaconinc/CryptoLibrary
Cloning into 'CryptoLibrary'...
remote: Counting objects: 11, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 11 (delta 0), reused 11 (delta 0)
Unpacking objects: 100% (11/11), done.
Checking connectivity... done.
~~~

现在假设你在一个分支下做了这样的工作。如果尝试切换回的分支中那些文件还在子目录而非子模块中时 - 你会得到这个错误：

~~~shell
$ git checkout master
error: The following untracked working tree files would be overwritten by
checkout:
  CryptoLibrary/Makefile
  CryptoLibrary/includes/crypto.h
  ...
Please move or remove them before you can switch branches.
Aborting
~~~

你可以通过 `check -f` 来强制切换，但是要小心，如果其中还有未保存的修改，这个命令会把它们覆盖掉。

当你切换回来之后，因为某些原因你得到了一个空的 `CryptoLibrary` 目录，并且 `git submodule update`也无法修复它。你需要进入到子模块目录中运行 `git checkout` . 来找回所有的文件。你也可以通过 `submodule foreach` 脚本来为多个子模块运行它。

要特别注意的是，近来子模块会将它们的所有 Git 数据保存在顶级项目的 `.git` 目录中，所以不像旧版本的Git，摧毁一个子模块目录并不会丢失任何提交或分支。

拥有了这些工具，使用子模块会成为可以在几个相关但却分离的项目上同时开发的相当简单有效的方法。 

# 自定义Git

## Git钩子

和其它版本控制系统一样，Git 能在特定的重要动作发生时触发自定义脚本。有两组这样的钩子：客户端的和服务器端的。客户端钩子由诸如提交和合并这样的操作所调用，而服务器端钩子作用于诸如接收被推送的提交这样的联网操作。你可以随心所欲地运用这些钩子。

# Git与其他系统

## 作为客户端的Git

### Git和Subversion

很大一部分开源项目与相当多的企业项目使用 Subversion 来管理它们的源代码。而且在大多数时间里，它已经是开源项目VCS选择的 事实标准。它在很多方面都与曾经是源代码管理世界的大人物的 CVS 相似。

Git 中最棒的特性就是有一个与 Subversion 的双向桥接，它被称作 `git svn`。这个工具允许你使用 Git 作为连接到 Subversion 有效的客户端，这样你可以使用 Git 所有本地的功能然后如同正在本地使用 Subversion 一样推送到 Subversion 服务器。这意味着你可以在本地做新建分支与合并分支、使用暂存区、使用变基与拣选等等的事情，同时协作者还在继续使用他们黑暗又古老的方式。当你试图游说公司将基础设施修改为完全支持 Git 的 过程中，一个好方法是将 Git 偷偷带入到公司环境，并帮助周围的开发者提升效率。Subversion 桥接就是进入 DVCS 世界的诱饵。

`git svn`

在 Git 中所有 Subversion 桥接命令的基础命令是 `git svn`。它可以跟很多命令，所以我们会通过几个简单的工
作流程来为你演示最常用的命令。

需要特别注意的是当你使用 git svn 时，就是在与 Subversion 打交道，一个与 Git 完全不同的系统。尽管 可以 在本地新建分支与合并分支，但是你最好还是通过变基你的工作来保证你的历史尽可能是直线，并且避免做类似同时与 Git 远程服务器交互的事情。

不要重写你的历史然后尝试再次推送，同时也不要推送到一个平行的 Git 仓库来与其他使用 Git 的开发者协作。Subversion 只能有一个线性的历史，弄乱它很容易。如果你在一个团队中工作，其中有一些人使用 SVN 而 另一些人使用 Git，你需要确保每个人都使用 SVN 服务器来协作 - 这样做会省去很多麻烦。

## 迁移到Git

### Subversion

如果你阅读过前面关于 `git svn` 的章节，可以轻松地使用那些指令来 `git svn clone` 一个仓库，停止使用Subversion 服务器，推送到一个新的 Git 服务器，然后就可以开始使用了。如果你想要历史，可以从Subversion 服务器上尽可能快地拉取数据来完成这件事（这可能会花费一些时间）。

然而，导入并不完美；因为花费太长时间了，你可能早已用其他方法完成导入操作。导入产生的第一个问题就是
作者信息。在 Subversion 中，每一个人提交时都需要在系统中有一个用户，它会被记录在提交信息内。在之前
章节的例子中几个地方显示了 `schacon`，比如 `blame` 输出与 `git svn log`。如果想要将上面的 Subversion
用户映射到一个更好的 Git 作者数据中，你需要一个 Subversion 用户到 Git 用户的映射。

# Git内部原理

首先要弄明白一点，从根本上来讲 Git 是一个内容寻址（content-addressable）文件系统，并在此之上提供了一个版本控制系统的用户界面。马上你就会学到这意味着什么。

早期的 Git（主要是 1.5 之前的版本）的用户界面要比现在复杂的多，因为它更侧重于作为一个文件系统，而不是一个打磨过的版本控制系统。不时会有一些陈词滥调抱怨早期那个晦涩复杂的 Git 用户界面；不过最近几年来，它已经被改进到不输于任何其他版本控制系统地清晰易用了。

内容寻址文件系统层是一套相当酷的东西，所以在本章我们会先讲解这部分内容。随后我们会学习传输机制和版 本库管理任务——你迟早会和它们打交道。

## 底层命令和高层命令

本书旨在讨论如何通过 checkout、branch、remote 等大约 30 个诸如此类动词形式的命令来玩转 Git。然而，由于 Git 最初是一套面向版本控制系统的工具集，而不是一个完整的、用户友好的版本控制系统，所以它还包含了一部分用于完成底层工作的命令。这些命令被设计成能以 UNIX 命令行的风格连接在一起，抑或藉由脚本 调用，来完成工作。这部分命令一般被称作“底层（plumbing）”命令，而那些更友好的命令则被称作“高层 （porcelain）”命令。

本书前九章专注于探讨高层命令。然而在本章，我们将主要面对底层命令。因为，底层命令得以让你窥探 Git 内部的工作机制，也有助于说明 Git 是如何完成工作的，以及它为何如此运作。多数底层命令并不面向最终用户：它们更适合作为新命令和自定义脚本的组成部分。

当在一个新目录或已有目录执行 `git init` 时，Git 会创建一个 `.git` 目录。这个目录包含了几乎所有 Git 存储 和操作的对象。如若想备份或复制一个版本库，只需把这个目录拷贝至另一处即可。本章探讨的所有内容，均位于这个目录内。该目录的结构如下所示：
~~~
$ ls -F1
HEAD
config*
description
hooks/
info/
objects/
refs/
~~~

该目录下可能还会包含其他文件，不过对于一个全新的 `git init` 版本库，这将是你看到的默认结 构。`description` 文件仅供 GitWeb 程序使用，我们无需关心。`config` 文件包含项目特有的配置选项。`info`目录包含一个全局性排除（global exclude）文件，用以放置那些不希望被记录在 .gitignore文件中的忽略模式（ignored patterns）。`hooks` 目录包含客户端或服务端的钩子脚本（hook scripts），在 Git 钩子 中这部分话题已被详细探讨过。

剩下的四个条目很重要：`HEAD` 文件、（尚待创建的）`index` 文件，和 `objects` 目录、`refs` 目录。这些条目是 Git 的核心组成部分。`objects` 目录存储所有数据内容；`refs` 目录存储指向数据（分支）的提交对象的指 针；`HEAD` 文件指示目前被检出的分支；`index` 文件保存暂存区信息。我们将详细地逐一检视这四部分，以期理解 Git 是如何运转的。

## Git对象

Git 是一个内容寻址文件系统。看起来很酷，但这是什么意思呢？这意味着，Git 的核心部分是一个简单的键值对数据库（key-value data store）。你可以向该数据库插入任意类型的内容，它会返回一个键值，通过该键值 可以在任意时刻再次检索（retrieve）该内容。可以通过底层命令 `hash-object` 来演示上述效果——该命令可将任意数据保存于 `.git` 目录，并返回相应的键值。

## Git引用

## 传输协议

## 维护与数据恢复

## 环境变量

# Appendix A:其他环境中的Git

# Appendix B:将Git嵌入你的应用

# Appendix C:Git命令

