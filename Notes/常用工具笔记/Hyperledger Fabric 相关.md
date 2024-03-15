# Ubuntu 安装 Git

1. 打开终端，输入 `sudo apt update` 命令。
2. 输入密码，确认授权。
3. 输入 `sudo apt install git` 命令。
4. 输入 `y`，确认命令执行。
5. 输入 `git --version` 命令，查看安装版本。
6. Git当前版本为【2.34.1】，就此安装完成。

# Ubuntu 安装 curl

1. `sudo apt-get update`
2. `sudo apt install curl`
3. `curl` 验证是否安装成功。成功时显示为：“curl: try 'curl --help' or 'curl --manual' for more information”

> Ubuntu 使用 sudo apt install安装时，提示：`正在等待缓存锁：无法获得锁 /var/lib/dpkg/lock-frontend。锁正由进程 4860（unattended-upgr）持有`
>
> 1. 终端输入 `ps aux` ，列出进程。找到含有 apt-get 的进程，直接 `sudo kill PID`。
> 2. 强制解锁,命令
>    `sudo rm /var/cache/apt/archives/lock`
>    `sudo rm /var/lib/dpkg/lock`
>
> 上面都没有用，最后还是 `sudo rm /var/lib/dpkg/lock-frontend` 解决了。

# Ubuntu 安装 Docker

1. `sudo apt-get install -y docker.io`
2. `docker --version` 确认安装成功，显示版本
3. 确保 docker daemon 是在运行着的: `sudo systemctl start docker`
4. 安装 docker-compose: `sudo apt-get -y install docker-compose`
5. 检查 docker-compose 是否安装: `docker-compose --version`

# 安装 fabric-samples 示例

`sudo curl -sSL https://bit.ly/2ysbOFE | bash -s`

> 短链对应 https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh ，国内可能需要替换成对应镜像
>
> 前面需要加 sudo，不然后面安装 docker 镜像时会报：Got permission denied while trying to connect to the Docker daemon socket
>
> 但是 bootstrap.sh 脚本里面其实还是用的 github.com 去 clone git 和获取 releases，可以把脚本下下来，用镜像站改掉里面的地址，这样下载会快些。

# 使用 Fabric 的测试网络

## 启动测试网络

参考 https://hyperledger-fabric.readthedocs.io/zh_CN/latest/test_network.html

1. `cd fabric-samples/test-network`
2. 在`test-network`目录中，运行以下命令删除先前运行的所有容器或工程: `sudo ./network.sh down`
3. 然后，您可以通过执行以下命令来启动网络: `sudo ./network.sh up`

## 创建一个通道

您也可以使用channel标志创建具有自定义名称的通道。 作为一个例子，以下命令将创建一个名为 `channel1` 的通道（不加 -c 与其后的内容，则为默认名称 `mychannel`）：

`sudo ./network.sh createChannel -c channel1`

## 在通道启动一个链码

使用 `network.sh` 创建频道后，您可以使用以下命令在通道上启动链码：

`./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go`

`deployCC` 子命令将在 `peer0.org1.example.com` 和 `peer0.org2.example.com` 上安装 **asset-transfer (basic)** 链码。 然后在使用通道标志（或 `mychannel` 如果未指定通道）的通道上部署指定的通道的链码。 如果您第一次部署一套链码，脚本将安装链码的依赖项。默认情况下，脚本安装 Go 版本的 asset-transfer (basic) 链码。 但是您可以使用语言便签 `-l`，用于安装 Java 或 javascript 版本的链码。 您可以在 `fabric-samples` 目录的 `asset-transfer-basic` 文件夹中找到 asset-transfer (basic) 链码。 此目录包含作为案例和用来突显 Fabric 特征的样本链码。

> 需要安装 go
>
> 1. `go version` 检查是否安装
> 2. `sudo apt install golang-go`
>
> 启动链码时，go 依赖下载会被拒绝：`go: github.com/golang/protobuf@v1.3.2: Get "https://proxy.golang.org/github.com/golang/protobuf/@v/v1.3.2.mod": dial tcp 172.217.160.113:443: connect: connection refused`
>
> 解决方案，打开 GO111MODULE 工具，更换 Go 代理，命令行输入：
>
> `go env -w GOPROXY=https://goproxy.io,direct`
>
> `go env -w GO111MODULE=on`
>
> 整了半天，还是不行…… 根本不熟悉 Go 的生态，各种问题只能上网搜，搜索还解决不了…… 放弃了官方文档里的示例，自己改用了 java 链码
>
> （后来发现换 七牛 的源就好了：`go env -w GOPROXY=https://goproxy.cn,direct`，详情看后面使用 couchDB 测试过程的记录——那个没有 Java 代码……）



### java 链码：

`sudo ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-java -ccl java -c channel1`

> 安装 java
>
> 1. `sudo apt install openjdk-8-jdk`
> 2. `java -version`
>
> 
>
> scripts/ccutils.sh: 行 9: jq：未找到命令
>
> 需要安装 jq：
>
> `sudo apt-get install jq`
>
> 
>
> 必须加 sudo，否则报错：`KeyMaterial not found in SigningIdentityInfo`
>
> 
>
> `-c channel1` 指定通道，否则默认为 mychannel，没有建立的话会报 `Error: proposal failed with status: 500 - channel 'mychannel' not found`



## 与网络交互

确保您正在从 `test-network` 目录进行操作。您可以在 `fabric-samples` 代码库的 `bin` 文件夹中找到 `peer` 二进制文件。 使用以下命令将这些二进制文件添加到您的 CLI 路径：

`export PATH=${PWD}/../bin:$PATH` 

> `${PWD}` 表示当前路径
>
> 需要使用 `sudo bash` 指令后再 export， 不然后面指令没办法在 sudo 下执行。
>
> 其实本章内容都需要在 `sudo bash` 中完成再 `exit` 退出。不然 peer 直接执行的话，会报 `KeyMaterial not found in SigningIdentityInfo`

您还需要将 `fabric-samples` 代码库中的 `FABRIC_CFG_PATH` 设置为指向其中的 `core.yaml` 文件：

`export FABRIC_CFG_PATH=$PWD/../config/`

现在，您可以设置环境变量，以允许您作为 Org1 操作 `peer` CLI：

```sh
# Environment variables for Org1

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
```

`CORE_PEER_TLS_ROOTCERT_FILE` 和 `CORE_PEER_MSPCONFIGPATH` 环境变量指向 Org1 的 `organizations` 文件夹中的的加密材料。

如果您使用 `./network.sh deployCC -ccl go` 安装和启动 asset-transfer (basic) 链码，您可以调用链码（Go）的 `InitLedger` 方法来赋予一些账本上的初始资产（如果使用 typescript 或者 javascript，例如 `./network.sh deployCC -l javascript`，你会调用相关链码的 `initLedger` 功能； Java 直接使用下面代码即可）。运行以下命令用一些资产来初始化账本：运行以下命令用一些资产来初始化账本：

```sh
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C channel1 -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"InitLedger","Args":[]}'
```

如果命令成功，您将观察到类似以下的输出：

```
-> INFO 001 Chaincode invoke successful. result: status:200
```

现在你可以用你的 CLI 工具来查询账本。运行以下指令来获取添加到通道账本的资产列表：

```sh
peer chaincode query -C channel1 -n basic -c '{"Args":["GetAllAssets"]}'
```

如果成功，您将看到以下输出：

```
[
  {"ID": "asset1", "color": "blue", "size": 5, "owner": "Tomoko", "appraisedValue": 300},
  {"ID": "asset2", "color": "red", "size": 5, "owner": "Brad", "appraisedValue": 400},
  {"ID": "asset3", "color": "green", "size": 10, "owner": "Jin Soo", "appraisedValue": 500},
  {"ID": "asset4", "color": "yellow", "size": 10, "owner": "Max", "appraisedValue": 600},
  {"ID": "asset5", "color": "black", "size": 15, "owner": "Adriana", "appraisedValue": 700},
  {"ID": "asset6", "color": "white", "size": 15, "owner": "Michel", "appraisedValue": 800}
]
```

> 实际的数据略有差异：
>
> [{"appraisedValue":300,"assetID":"asset1","color":"blue","owner":"Tomoko","size":5},{"appraisedValue":400,"assetID":"asset2","color":"red","owner":"Brad","size":5},{"appraisedValue":500,"assetID":"asset3","color":"green","owner":"Jin Soo","size":10},{"appraisedValue":600,"assetID":"asset4","color":"yellow","owner":"Max","size":10},{"appraisedValue":700,"assetID":"asset5","color":"black","owner":"Adrian","size":15},{"appraisedValue":700,"assetID":"asset6","color":"white","owner":"Michel","size":15}]

当一个网络成员希望在账本上转一些或者改变一些资产，链码会被调用。使用以下的指令来通过调用 asset-transfer (basic) 链码改变账本上的资产所有者：

```sh
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C channel1 -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"TransferAsset","Args":["asset6","Christopher"]}'
```

> 每次 sudo bash 都需要重新 export：
>
> ```sh
> export PATH=${PWD}/../bin:$PATH
> export FABRIC_CFG_PATH=$PWD/../config/
> ```
>
> 当然，还有 Org1 的一些变量
>
> ```sh
> export CORE_PEER_TLS_ENABLED=true
> export CORE_PEER_LOCALMSPID="Org1MSP"
> export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
> export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
> export CORE_PEER_ADDRESS=localhost:7051
> ```

如果命令成功，您应该看到类似以下响应：

```
2019-12-04 17:38:21.048 EST [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 001 Chaincode invoke successful. result: status:200
```

> 实际响应：
>
> `2022-09-21 17:44:40.016 CST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 payload:"Michel"`

因为 asset-transfer (basic) 链码的背书策略需要交易同时被 Org1 和 Org2 签名，链码调用指令需要使用 `--peerAddresses` 标签来指向 `peer0.org1.example.com` 和 `peer0.org2.example.com`。因为网络的 TLS 被开启，指令也需要用 `--tlsRootCertFiles` 标签指向每个 peer 节点的 TLS 证书。

调用链码之后，我们可以使用另一个查询来查看调用如何改变了区块链账本的资产。因为我们已经查询了 Org1 的 peer，我们可以把这个查询链码的机会通过 Org2 的 peer 来运行。设置以下的环境变量来操作 Org2：

```sh
# Environment variables for Org2

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
```

你可以查询运行在 `peer0.org2.example.com` asset-transfer (basic) 链码

```sh
peer chaincode query -C channel1 -n basic -c '{"Args":["ReadAsset","asset6"]}'
```

结果显示 `"asset6"` 转给了 Christopher:

```
{"ID":"asset6","color":"white","size":15,"owner":"Christopher","appraisedValue":800}
```

> 实际结果：`{"owner":"Christopher","color":"white","size":15,"appraisedValue":700,"assetID":"asset6"}`

## 关停网络

使用完测试网络后，您可以使用以下命令关闭网络：

```sh
sudo ./network.sh down
```

该命令将停止并删除节点和链码容器，删除组织加密材料，并从Docker Registry移除链码镜像。 该命令还删除之前运行的通道项目和docker卷。如果您遇到任何问题，还允许您再次运行`./ network.sh up`。

# 将智能合约部署到通道

## 启动网络

使用以下命令导航到 `fabric-samples` 存储库本地克隆中的测试网络目录：

```sh
cd fabric-samples/test-network
```

为了本教程的目的，我们希望从已知的初始状态进行操作。以下命令将杀死任何活动或陈旧的 docker 容器并删除以前生成的工件。

```sh
sudo ./network.sh down
```

然后，您可以使用以下命令启动测试网络：

```sh
sudo ./network.sh up createChannel
```

该 `createChannel` 命令创建一个以 `mychannel` 两个通道成员 Org1 和 Org2 命名的通道。该命令还将属于每个组织的对等方加入通道。如果网络和通道创建成功，您可以在日志中看到以下消息：

```
========= Channel successfully joined ===========
```

> 实际为：`Channel 'mychannel' joined`

## 设置 Logspout（可选）

Fabric 示例 `monitordocker.sh` 中的示例中已经包含一个用于安装和配置 Logspout 的脚本。`commercial-paper` 我们也将在本教程中使用相同的脚本。Logspout 工具会不断地将日志流式传输到您的终端，因此您需要使用新的终端窗口。打开一个新终端并导航到该 `test-network` 目录。

```sh
cd fabric-samples/test-network
```

您可以从任何目录运行脚本 `monitordocker.sh`。为了方便使用，我们将`monitordocker.sh` 脚本从 `commercial-paper` 示例复制到您的工作目录

```sh
cp ../commercial-paper/organization/digibank/configuration/cli/monitordocker.sh .
# if you're not sure where it is
find . -name monitordocker.sh
```

> 实际上好像该目录下已经有了 `monitordocker.sh`，无须复制

然后，您可以通过运行以下命令来启动 Logspout：

```sh
sudo ./monitordocker.sh net_test
```

> docker: Error response from daemon: network net_test not found.

## 打包智能合约

在打包链码之前，我们需要安装链码依赖项。导航到包含 Fabcar 链代码的 Java 版本的文件夹。

```sh
cd fabric-samples/chaincode/fabcar/java
```

`fabcar/java` 要安装智能合约依赖项，请从目录运行以下命令

```sh
./gradlew installDist
```

如果命令成功，您将能够在 `build` 文件夹中找到构建的智能合约。

现在我们已经安装了依赖并构建了智能合约，我们可以创建链码包。导航回 `test-network` 文件夹中的工作目录，以便我们可以将链代码与其他网络工件打包在一起。

```sh
cd ../../../test-network
```

您可以使用 `peer` CLI 创建所需格式的链代码包。`peer` 二进制文件位于存储库的 `bin` 文件夹中。`fabric-samples` 使用以下命令将这些二进制文件添加到您的 CLI 路径：(同之前使用 Fabric 的测试网络过程中一样，使用 `sudo bash`)

```sh
export PATH=${PWD}/../bin:$PATH
```

您还需要设置 `FABRIC_CFG_PATH` 指向存储库中的 `core.yaml` 文件 `fabric-samples`：

```sh
export FABRIC_CFG_PATH=$PWD/../config/
```

要确认您可以使用 `peer`CLI，请检查二进制文件的版本。二进制文件需要是版本 `2.0.0` 或更高版本才能运行本教程。

```sh
peer version
```

您现在可以使用 peer 生命周期链码包命令创建链码包：

```sh
peer lifecycle chaincode package fabcar.tar.gz --path ../chaincode/fabcar/java/build/install/fabcar --lang java --label fabcar_1
```

此命令将在您的当前目录中创建一个名为 `fabcar.tar.gz` 的包。`--lang` 标志用于指定链代码语言，`--path` 标志提供您的智能合约代码的位置。`--label` 标志用于指定链码标签，该标签将在安装后识别您的链码。建议您的标签包含链码名称和版本。

现在我们创建了链码包，我们可以在测试网络的对等点上安装链码。

## 安装链码包

在我们打包 Fabcar 智能合约之后，我们可以在我们的对等节点上安装链码。链码需要安装在每个将支持交易的对等方上。因为我们要将背书策略设置为需要来自 Org1 和 Org2 的背书，所以我们需要在两个组织运营的对等节点上安装链码：

- peer0.org1.example.com
- peer0.org2.example.com

让我们先在 Org1 peer 上安装链码。设置以下环境变量，以 Org1 管理员用户身份操作 `peer` CLI。将 `CORE_PEER_ADDRESS` 设置为指向 Org1 对等点，`peer0.org1.example.com`.

（`sudo bash` 下操作）

```sh
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
```

发出对等生命周期链代码安装命令以在对等上安装链代码：

```sh
peer lifecycle chaincode install fabcar.tar.gz
```

如果命令成功，对端将生成并返回包标识符。此包 ID 将用于在下一步中批准链码。您应该会看到类似于以下内容的输出：

```
2020-02-12 11:40:02.923 EST [cli.lifecycle.chaincode] submitInstallProposal -> INFO 001 Installed remotely: response:<status:200 payload:"\nIfabcar_1:69de748301770f6ef64b42aa6bb6cb291df20aa39542c3ef94008615704007f3\022\010fabcar_1" >
2020-02-12 11:40:02.925 EST [cli.lifecycle.chaincode] submitInstallProposal -> INFO 002 Chaincode code package identifier: fabcar_1:69de748301770f6ef64b42aa6bb6cb291df20aa39542c3ef94008615704007f3
```

> 实际返回:
>
> `2022-09-22 11:06:35.561 CST 0001 INFO [cli.lifecycle.chaincode] submitInstallProposal -> Installed remotely: response:<status:200 payload:"\nIfabcar_1:ceae1b53d5fbbd6bacae7afe89541e430c25d92ec5372fe25da0ddf7d021efe2\022\010fabcar_1" >`
>
> `2022-09-22 11:06:35.563 CST 0002 INFO [cli.lifecycle.chaincode] submitInstallProposal -> Chaincode code package identifier: fabcar_1:ceae1b53d5fbbd6bacae7afe89541e430c25d92ec5372fe25da0ddf7d021efe2`

我们现在可以在 Org2 peer 上安装链码。设置以下环境变量以作为 Org2 管理员和目标目标 Org2 对等方运行，`peer0.org2.example.com`.

```sh
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
```

发出以下命令来安装链码：

```sh
peer lifecycle chaincode install fabcar.tar.gz
```

链码是在安装链码时由对等方构建的。如果智能合约代码有问题，安装命令将从链码返回任何构建错误。

## 批准链码定义

安装链码包后，您需要为您的组织批准链码定义。该定义包括链码治理的重要参数，例如名称、版本和链码背书策略。

在部署链码之前需要批准链码的通道成员集由该 `Application/Channel/lifeycleEndorsement` 策略管理。默认情况下，此策略要求大多数通道成员需要批准链码才能在通道上使用。因为我们在通道上只有两个组织，并且 2 的大多数是 2，所以我们需要作为 Org1 和 Org2 批准 Fabcar 的链码定义。

如果组织已在其对等节点上安装了链码，则他们需要在其组织批准的链码定义中包含 packageID。包 ID 用于将安装在对等节点上的链码与批准的链码定义相关联，并允许组织使用链码来背书交易。您可以使用 `peer lifecycle chaincode queryinstalled` 命令查询您的对等点来查找链代码的包 ID。

```sh
peer lifecycle chaincode queryinstalled
```

包 ID 是链码标签和链码二进制文件哈希的组合。每个对等点都将生成相同的包 ID。您应该会看到类似于以下内容的输出：

```sh
Installed chaincodes on peer:
Package ID: fabcar_1:69de748301770f6ef64b42aa6bb6cb291df20aa39542c3ef94008615704007f3, Label: fabcar_1
```

当我们批准链码时，我们将使用包 ID，所以让我们继续将其保存为环境变量。将返回的包 ID 粘贴到下面的命令中。**注意：**并非所有用户的包 ID 都相同，因此您需要使用上一步命令窗口返回的包 ID 完成此步骤。

```sh
export CC_PACKAGE_ID=fabcar_1:69de748301770f6ef64b42aa6bb6cb291df20aa39542c3ef94008615704007f3
```

因为环境变量已经设置为 `peer` 以 Org2 admin 身份运行 CLI，所以我们可以作为 Org2 批准 Fabcar 的链码定义。链码在组织级别获得批准，因此该命令只需要针对一个节点。使用 gossip 将批准分发给组织内的其他对等方。使用 `peer lifecycle chaincode approveformyorg` 命令批准链代码定义：

```sh
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name fabcar --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

上面的命令使用 `--package-id` 标志将包标识符包含在链码定义中。`--sequence` 参数是一个整数，用于跟踪链码已定义或更新的次数。因为链码是第一次部署到通道，所以序列号是 1。升级 Fabcar 链码时，序列号会递增到 2。如果您使用的是Fabric Chaincode Shim API 提供的低级 API，您可以将 `--init-required` 标志传递给上面的命令以请求执行 Init 函数来初始化链码。链代码的第一次调用需要以 Init 函数为目标并包含 `--isInit` 标志，然后您才能使用链代码中的其他函数与分类帐交互。

我们可以给 `approveformyorg` 命令提供 `--signature-policy` 或 `--channel-config-policy` 参数来指定链码背书策略。背书策略指定了需要多少个属于不同通道成员的对等方来针对给定的链码验证交易。因为我们没有设置策略，所以 Fabcar 的定义会使用默认的背书策略，即交易提交时需要得到在场的大多数通道成员的背书。这意味着，如果从频道中添加或删除新组织，则背书策略会自动更新以需要更多或更少的背书。在本教程中，默认策略将需要 2 的多数也就是 2，因此交易需要由 Org1 和 Org2 的对等方背书。如果要指定自定义背书策略，可以使用[背书策略](https://hyperledger-fabric.readthedocs.io/zh_CN/latest/endorsement-policies.html)操作指南以了解策略语法。

您需要批准具有管理员角色身份的链码定义。因此，`CORE_PEER_MSPCONFIGPATH` 变量需要指向包含管理员身份的 MSP 文件夹。您不能批准客户端用户的链代码定义。需要将批准提交给排序服务，该服务将验证管理员签名，然后将批准分发给您的对等方。

我们仍然需要批准链码定义为 Org1。设置以下环境变量以作为 Org1 管理员运行：

```sh
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051
```

您现在可以作为 Org1 批准链码定义：

```sh
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name fabcar --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

我们现在拥有将 Fabcar 和链码部署到通道所需的大多数的批准。虽然只需要大多数组织即可批准链码定义（使用默认策略），但所有组织都需要批准链码定义才能在其对等方上启动链码。如果您在通道成员批准链码之前提交定义，则组织将无法为交易背书。因此，建议所有通道成员在提交链码定义之前批准链码。

## 将链码定义提交到通道

在足够数量的组织批准链码定义后，一个组织可以将链码定义提交给通道。如果大多数通道成员都批准了定义，则提交事务将成功，链码定义中约定的参数将在通道上实现。

您可以使用 `peer lifecycle chaincode checkcommitreadiness` 命令检查通道成员是否批准了相同的链码定义。用于 `checkcommitreadiness` 命令的标志与用于批准您的组织的链代码的标志相同。但是，您不需要包含 `--package-id` 标志。

```sh
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name fabcar --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json
```

该命令将生成一个 JSON 映射，显示通道成员是否已批准`checkcommitreadiness`命令中指定的参数：

```
{
	"Approvals": {
		"Org1MSP": true,
		"Org2MSP": true
	}
}
```

由于作为通道成员的两个组织都批准了相同的参数，因此链码定义已准备好提交给通道。您可以使用 `peer lifecycle chaincode commit` 命令将链代码定义提交到通道。提交命令还需要由组织管理员提交。

```sh
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name fabcar --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
```

上面的事务使用 `--peerAddresses` 标志来定位 `peer0.org1.example.com` Org1 和 `peer0.org2.example.com` Org2。`commit` 交易被提交给加入通道的对等点，以查询操作对等点的组织批准的链码定义。该命令需要针对来自足够数量的组织的对等方，以满足部署链代码的策略。由于批准分布在每个组织内，因此您可以针对属于渠道成员的任何对等方。

通道成员对链码定义的背书提交给排序服务，以添加到块中并分发到通道。然后通道上的对等点验证是否有足够数量的组织批准了链码定义。`peer lifecycle chaincode commit` 命令将在返回响应之前等待对等方的验证。

您可以使用 `peer lifecycle chaincode querycommitted` 命令来确认链代码定义已提交到通道。

```sh
peer lifecycle chaincode querycommitted --channelID mychannel --name fabcar --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

如果链码成功提交到通道，`querycommitted` 命令将返回链码定义的序列和版本：

```
Committed chaincode definition for chaincode 'fabcar' on channel 'mychannel':
Version: 1, Sequence: 1, Endorsement Plugin: escc, Validation Plugin: vscc, Approvals: [Org1MSP: true, Org2MSP: true]
```

## 调用链码

将链码定义提交到通道后，链码将在加入安装链码的通道的对等节点上启动。Fabcar 链代码现在已准备好由客户端应用程序调用。使用以下命令在账本上创建一组初始汽车。请注意，invoke 命令需要针对足够数量的对等方以满足链码背书策略。

```sh
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n fabcar --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"initLedger","Args":[]}'
```

> 如果有如下报错信息，可能是链码没有在通道中被成功定义，关闭测试网络后，重新执行启动网络操作：
>
> `Error: endorsement failure during invoke. response: status:500 message:"make sure the chaincode fabcar has been successfully defined on channel mychannel and try again: chaincode definition for 'fabcar' exists, but chaincode is not installed"`

如果命令成功，您应该能够得到类似于以下内容的响应：

```
2020-02-12 18:22:20.576 EST [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 001 Chaincode invoke successful. result: status:200
```

我们可以使用查询函数来读取由链码创建的汽车集合：

```sh
peer chaincode query -C mychannel -n fabcar -c '{"Args":["queryAllCars"]}'
```

对查询的响应应该是以下汽车列表：

```json
[{"Key":"CAR0","Record":{"make":"Toyota","model":"Prius","colour":"blue","owner":"Tomoko"}},
{"Key":"CAR1","Record":{"make":"Ford","model":"Mustang","colour":"red","owner":"Brad"}},
{"Key":"CAR2","Record":{"make":"Hyundai","model":"Tucson","colour":"green","owner":"Jin Soo"}},
{"Key":"CAR3","Record":{"make":"Volkswagen","model":"Passat","colour":"yellow","owner":"Max"}},
{"Key":"CAR4","Record":{"make":"Tesla","model":"S","colour":"black","owner":"Adriana"}},
{"Key":"CAR5","Record":{"make":"Peugeot","model":"205","colour":"purple","owner":"Michel"}},
{"Key":"CAR6","Record":{"make":"Chery","model":"S22L","colour":"white","owner":"Aarav"}},
{"Key":"CAR7","Record":{"make":"Fiat","model":"Punto","colour":"violet","owner":"Pari"}},
{"Key":"CAR8","Record":{"make":"Tata","model":"Nano","colour":"indigo","owner":"Valeria"}},
{"Key":"CAR9","Record":{"make":"Holden","model":"Barina","colour":"brown","owner":"Shotaro"}}]
```

## 清理

使用完链码后，还可以使用以下命令删除 Logspout 工具。

```sh
docker stop logspout
docker rm logspout
```

然后，您可以通过从 `test-network` 目录发出以下命令来关闭测试网络：

```sh
./network.sh down
```

# 编写你的第一个应用

## 智能合约代码

### FabCar.java

```java
/*
 * SPDX-License-Identifier: Apache-2.0
 */

package org.hyperledger.fabric.samples.fabcar;

import java.util.ArrayList;
import java.util.List;

import org.hyperledger.fabric.contract.Context;
import org.hyperledger.fabric.contract.ContractInterface;
import org.hyperledger.fabric.contract.annotation.Contact;
import org.hyperledger.fabric.contract.annotation.Contract;
import org.hyperledger.fabric.contract.annotation.Default;
import org.hyperledger.fabric.contract.annotation.Info;
import org.hyperledger.fabric.contract.annotation.License;
import org.hyperledger.fabric.contract.annotation.Transaction;
import org.hyperledger.fabric.shim.ChaincodeException;
import org.hyperledger.fabric.shim.ChaincodeStub;
import org.hyperledger.fabric.shim.ledger.KeyValue;
import org.hyperledger.fabric.shim.ledger.QueryResultsIterator;

import com.owlike.genson.Genson;

/**
 * Java implementation of the Fabric Car Contract described in the Writing Your
 * First Application tutorial
 */
@Contract(
        name = "FabCar",
        info = @Info(
                title = "FabCar contract",
                description = "The hyperlegendary car contract",
                version = "0.0.1-SNAPSHOT",
                license = @License(
                        name = "Apache 2.0 License",
                        url = "http://www.apache.org/licenses/LICENSE-2.0.html"),
                contact = @Contact(
                        email = "f.carr@example.com",
                        name = "F Carr",
                        url = "https://hyperledger.example.com")))
@Default
public final class FabCar implements ContractInterface {

    private final Genson genson = new Genson();

    private enum FabCarErrors {
        CAR_NOT_FOUND,
        CAR_ALREADY_EXISTS
    }

    /**
     * Retrieves a car with the specified key from the ledger.
     *
     * @param ctx the transaction context
     * @param key the key
     * @return the Car found on the ledger if there was one
     */
    @Transaction()
    public Car queryCar(final Context ctx, final String key) {
        ChaincodeStub stub = ctx.getStub();
        String carState = stub.getStringState(key);

        if (carState.isEmpty()) {
            String errorMessage = String.format("Car %s does not exist", key);
            System.out.println(errorMessage);
            throw new ChaincodeException(errorMessage, FabCarErrors.CAR_NOT_FOUND.toString());
        }

        Car car = genson.deserialize(carState, Car.class);

        return car;
    }

    /**
     * Creates some initial Cars on the ledger.
     *
     * @param ctx the transaction context
     */
    @Transaction()
    public void initLedger(final Context ctx) {
        ChaincodeStub stub = ctx.getStub();

        String[] carData = {
                "{ \"make\": \"Toyota\", \"model\": \"Prius\", \"color\": \"blue\", \"owner\": \"Tomoko\" }",
                "{ \"make\": \"Ford\", \"model\": \"Mustang\", \"color\": \"red\", \"owner\": \"Brad\" }",
                "{ \"make\": \"Hyundai\", \"model\": \"Tucson\", \"color\": \"green\", \"owner\": \"Jin Soo\" }",
                "{ \"make\": \"Volkswagen\", \"model\": \"Passat\", \"color\": \"yellow\", \"owner\": \"Max\" }",
                "{ \"make\": \"Tesla\", \"model\": \"S\", \"color\": \"black\", \"owner\": \"Adrian\" }",
                "{ \"make\": \"Peugeot\", \"model\": \"205\", \"color\": \"purple\", \"owner\": \"Michel\" }",
                "{ \"make\": \"Chery\", \"model\": \"S22L\", \"color\": \"white\", \"owner\": \"Aarav\" }",
                "{ \"make\": \"Fiat\", \"model\": \"Punto\", \"color\": \"violet\", \"owner\": \"Pari\" }",
                "{ \"make\": \"Tata\", \"model\": \"nano\", \"color\": \"indigo\", \"owner\": \"Valeria\" }",
                "{ \"make\": \"Holden\", \"model\": \"Barina\", \"color\": \"brown\", \"owner\": \"Shotaro\" }"
        };

        for (int i = 0; i < carData.length; i++) {
            String key = String.format("CAR%d", i);

            Car car = genson.deserialize(carData[i], Car.class);
            String carState = genson.serialize(car);
            stub.putStringState(key, carState);
        }
    }

    /**
     * Creates a new car on the ledger.
     *
     * @param ctx the transaction context
     * @param key the key for the new car
     * @param make the make of the new car
     * @param model the model of the new car
     * @param color the color of the new car
     * @param owner the owner of the new car
     * @return the created Car
     */
    @Transaction()
    public Car createCar(final Context ctx, final String key, final String make, final String model,
            final String color, final String owner) {
        ChaincodeStub stub = ctx.getStub();

        String carState = stub.getStringState(key);
        if (!carState.isEmpty()) {
            String errorMessage = String.format("Car %s already exists", key);
            System.out.println(errorMessage);
            throw new ChaincodeException(errorMessage, FabCarErrors.CAR_ALREADY_EXISTS.toString());
        }

        Car car = new Car(make, model, color, owner);
        carState = genson.serialize(car);
        stub.putStringState(key, carState);

        return car;
    }

    /**
     * Retrieves all cars from the ledger.
     *
     * @param ctx the transaction context
     * @return array of Cars found on the ledger
     */
    @Transaction()
    public String queryAllCars(final Context ctx) {
        ChaincodeStub stub = ctx.getStub();

        final String startKey = "CAR1";
        final String endKey = "CAR99";
        List<CarQueryResult> queryResults = new ArrayList<CarQueryResult>();

        QueryResultsIterator<KeyValue> results = stub.getStateByRange(startKey, endKey);

        for (KeyValue result: results) {
            Car car = genson.deserialize(result.getStringValue(), Car.class);
            queryResults.add(new CarQueryResult(result.getKey(), car));
        }

        final String response = genson.serialize(queryResults);

        return response;
    }

    /**
     * Changes the owner of a car on the ledger.
     *
     * @param ctx the transaction context
     * @param key the key
     * @param newOwner the new owner
     * @return the updated Car
     */
    @Transaction()
    public Car changeCarOwner(final Context ctx, final String key, final String newOwner) {
        ChaincodeStub stub = ctx.getStub();

        String carState = stub.getStringState(key);

        if (carState.isEmpty()) {
            String errorMessage = String.format("Car %s does not exist", key);
            System.out.println(errorMessage);
            throw new ChaincodeException(errorMessage, FabCarErrors.CAR_NOT_FOUND.toString());
        }

        Car car = genson.deserialize(carState, Car.class);

        Car newCar = new Car(car.getMake(), car.getModel(), car.getColor(), newOwner);
        String newCarState = genson.serialize(newCar);
        stub.putStringState(key, newCarState);

        return newCar;
    }
}
```

`queryAllCars` 这段代码展示了如何使用 `getStateByRange` 在一个 key 范围内从账本中检索所有的汽车。 给出的空 startKey 和 endKey 将被解释为从起始到结束的所有 key。 另一个例子是，如果您使用 `startKey = 'CAR0', endKey = 'CAR999'` ， 那么 `getStateByRange` 将以字典顺序检索在 `CAR0`(包括自身) 和 `CAR999`(不包括自身)之间 key 的汽车。 其余代码遍历查询结果，并将结果封装为 JSON，以供示例应用程序使用。

### Car.java

```java
/*
 * SPDX-License-Identifier: Apache-2.0
 */

package org.hyperledger.fabric.samples.fabcar;

import java.util.Objects;

import org.hyperledger.fabric.contract.annotation.DataType;
import org.hyperledger.fabric.contract.annotation.Property;

import com.owlike.genson.annotation.JsonProperty;

@DataType()
public final class Car {

    @Property()
    private final String make;

    @Property()
    private final String model;

    @Property()
    private final String color;

    @Property()
    private final String owner;

    public String getMake() {
        return make;
    }

    public String getModel() {
        return model;
    }

    public String getColor() {
        return color;
    }

    public String getOwner() {
        return owner;
    }

    public Car(@JsonProperty("make") final String make, @JsonProperty("model") final String model,
            @JsonProperty("color") final String color, @JsonProperty("owner") final String owner) {
        this.make = make;
        this.model = model;
        this.color = color;
        this.owner = owner;
    }

    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        }

        if ((obj == null) || (getClass() != obj.getClass())) {
            return false;
        }

        Car other = (Car) obj;

        return Objects.deepEquals(new String[] {getMake(), getModel(), getColor(), getOwner()},
                new String[] {other.getMake(), other.getModel(), other.getColor(), other.getOwner()});
    }

    @Override
    public int hashCode() {
        return Objects.hash(getMake(), getModel(), getColor(), getOwner());
    }

    @Override
    public String toString() {
        return this.getClass().getSimpleName() + "@" + Integer.toHexString(hashCode()) + " [make=" + make + ", model="
                + model + ", color=" + color + ", owner=" + owner + "]";
    }
}
```

### CarQueryResult.java

```java
/*
 * SPDX-License-Identifier: Apache-2.0
 */

package org.hyperledger.fabric.samples.fabcar;

import java.util.Objects;

import org.hyperledger.fabric.contract.annotation.DataType;
import org.hyperledger.fabric.contract.annotation.Property;

import com.owlike.genson.annotation.JsonProperty;

/**
 * CarQueryResult structure used for handling result of query
 *
 */
@DataType()
public final class CarQueryResult {
    @Property()
    private final String key;

    @Property()
    private final Car record;

    public CarQueryResult(@JsonProperty("Key") final String key, @JsonProperty("Record") final Car record) {
        this.key = key;
        this.record = record;
    }

    public String getKey() {
        return key;
    }

    public Car getRecord() {
        return record;
    }

    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        }

        if ((obj == null) || (getClass() != obj.getClass())) {
            return false;
        }

        CarQueryResult other = (CarQueryResult) obj;

        Boolean recordsAreEquals = this.getRecord().equals(other.getRecord());
        Boolean keysAreEquals = this.getKey().equals(other.getKey());

        return recordsAreEquals && keysAreEquals;
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.getKey(), this.getRecord());
    }

    @Override
    public String toString() {
        return this.getClass().getSimpleName() + "@" + Integer.toHexString(hashCode()) + " [key=" + key + ", record="
                + record + "]";
    }
}
```

## 应用程序代码

### 登记管理员用户（EnrollAdmin.java）

当我们创建网络的时候，一个管理员用户（ `admin`）被证书授权服务器（CA）创建成了 **注册员** 。我们第一步要使用 `EnrollAdmin` 程序为 `admin` 生成私钥、公钥和 x.509 证书。这个程序使用一个 **证书签名请求** （CSR）——现在本地生成公钥和私钥，然后把公钥发送到 CA ，CA 会发布会一个让应用程序使用的证书。这三个证书会保存在钱包中，以便于我们以管理员的身份使用 CA 。

```java
/*
SPDX-License-Identifier: Apache-2.0
*/

package org.example;

import java.nio.file.Paths;
import java.util.Properties;

import org.hyperledger.fabric.gateway.Wallet;
import org.hyperledger.fabric.gateway.Wallets;
import org.hyperledger.fabric.gateway.Identities;
import org.hyperledger.fabric.gateway.Identity;
import org.hyperledger.fabric.sdk.Enrollment;
import org.hyperledger.fabric.sdk.security.CryptoSuite;
import org.hyperledger.fabric.sdk.security.CryptoSuiteFactory;
import org.hyperledger.fabric_ca.sdk.EnrollmentRequest;
import org.hyperledger.fabric_ca.sdk.HFCAClient;

public class EnrollAdmin {

	static {
		System.setProperty("org.hyperledger.fabric.sdk.service_discovery.as_localhost", "true");
	}

	public static void main(String[] args) throws Exception {

		// Create a CA client for interacting with the CA.
		Properties props = new Properties();
		props.put("pemFile",
			"../../test-network/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem");
		props.put("allowAllHostNames", "true");
		HFCAClient caClient = HFCAClient.createNewInstance("https://localhost:7054", props);
		CryptoSuite cryptoSuite = CryptoSuiteFactory.getDefault().getCryptoSuite();
		caClient.setCryptoSuite(cryptoSuite);

		// Create a wallet for managing identities
		Wallet wallet = Wallets.newFileSystemWallet(Paths.get("wallet"));

		// Check to see if we've already enrolled the admin user.
		if (wallet.get("admin") != null) {
			System.out.println("An identity for the admin user \"admin\" already exists in the wallet");
			return;
		}

		// Enroll the admin user, and import the new identity into the wallet.
		final EnrollmentRequest enrollmentRequestTLS = new EnrollmentRequest();
		enrollmentRequestTLS.addHost("localhost");
		enrollmentRequestTLS.setProfile("tls");
		Enrollment enrollment = caClient.enroll("admin", "adminpw", enrollmentRequestTLS);
		Identity user = Identities.newX509Identity("Org1MSP", enrollment);
		wallet.put("admin", user);
		System.out.println("Successfully enrolled user \"admin\" and imported it into the wallet");
	}
}
```

### 注册和登记应用程序用户（RegisterUser.java）

既然我们的 `admin` 是用来与CA一起工作的。 我们也已经在钱包中有了管理员的凭据， 那么我们可以创建一个新的应用程序用户，它将被用于与区块链交互。 运行以下命令注册和记录一个名为 `appUser` 的新用户：

与admin注册类似，该程序使用CSR注册 `appUser` 并将其凭证与 `admin` 凭证一起存储在钱包中。 现在，我们有了两个独立用户的身份—— `admin` 和 `appUser` ——它们可以被我们的应用程序使用。

```java
/*
SPDX-License-Identifier: Apache-2.0
*/

package org.example;

import java.nio.file.Paths;
import java.security.PrivateKey;
import java.util.Properties;
import java.util.Set;

import org.hyperledger.fabric.gateway.Wallet;
import org.hyperledger.fabric.gateway.Wallets;
import org.hyperledger.fabric.gateway.Identities;
import org.hyperledger.fabric.gateway.Identity;
import org.hyperledger.fabric.gateway.X509Identity;
import org.hyperledger.fabric.sdk.Enrollment;
import org.hyperledger.fabric.sdk.User;
import org.hyperledger.fabric.sdk.security.CryptoSuite;
import org.hyperledger.fabric.sdk.security.CryptoSuiteFactory;
import org.hyperledger.fabric_ca.sdk.HFCAClient;
import org.hyperledger.fabric_ca.sdk.RegistrationRequest;

public class RegisterUser {

	static {
		System.setProperty("org.hyperledger.fabric.sdk.service_discovery.as_localhost", "true");
	}

	public static void main(String[] args) throws Exception {

		// Create a CA client for interacting with the CA.
		Properties props = new Properties();
		props.put("pemFile",
			"../../test-network/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem");
		props.put("allowAllHostNames", "true");
		HFCAClient caClient = HFCAClient.createNewInstance("https://localhost:7054", props);
		CryptoSuite cryptoSuite = CryptoSuiteFactory.getDefault().getCryptoSuite();
		caClient.setCryptoSuite(cryptoSuite);

		// Create a wallet for managing identities
		Wallet wallet = Wallets.newFileSystemWallet(Paths.get("wallet"));

		// Check to see if we've already enrolled the user.
		if (wallet.get("appUser") != null) {
			System.out.println("An identity for the user \"appUser\" already exists in the wallet");
			return;
		}

		X509Identity adminIdentity = (X509Identity)wallet.get("admin");
		if (adminIdentity == null) {
			System.out.println("\"admin\" needs to be enrolled and added to the wallet first");
			return;
		}
		User admin = new User() {

			@Override
			public String getName() {
				return "admin";
			}

			@Override
			public Set<String> getRoles() {
				return null;
			}

			@Override
			public String getAccount() {
				return null;
			}

			@Override
			public String getAffiliation() {
				return "org1.department1";
			}

			@Override
			public Enrollment getEnrollment() {
				return new Enrollment() {

					@Override
					public PrivateKey getKey() {
						return adminIdentity.getPrivateKey();
					}

					@Override
					public String getCert() {
						return Identities.toPemString(adminIdentity.getCertificate());
					}
				};
			}

			@Override
			public String getMspId() {
				return "Org1MSP";
			}

		};

		// Register the user, enroll the user, and import the new identity into the wallet.
		RegistrationRequest registrationRequest = new RegistrationRequest("appUser");
		registrationRequest.setAffiliation("org1.department1");
		registrationRequest.setEnrollmentID("appUser");
		String enrollmentSecret = caClient.register(registrationRequest, admin);
		Enrollment enrollment = caClient.enroll("appUser", enrollmentSecret);
		Identity user = Identities.newX509Identity("Org1MSP", enrollment);
		wallet.put("appUser", user);
		System.out.println("Successfully enrolled user \"appUser\" and imported it into the wallet");
	}

}
```

### ClientApp.java

```java
/*
SPDX-License-Identifier: Apache-2.0
*/

package org.example;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.Gateway;
import org.hyperledger.fabric.gateway.Network;
import org.hyperledger.fabric.gateway.Wallet;
import org.hyperledger.fabric.gateway.Wallets;

public class ClientApp {

	static {
		System.setProperty("org.hyperledger.fabric.sdk.service_discovery.as_localhost", "true");
	}

	public static void main(String[] args) throws Exception {
		// Load a file system based wallet for managing identities.
		Path walletPath = Paths.get("wallet");
		Wallet wallet = Wallets.newFileSystemWallet(walletPath);
		// load a CCP
		Path networkConfigPath = Paths.get("..", "..", "test-network", "organizations", "peerOrganizations", "org1.example.com", "connection-org1.yaml");

		Gateway.Builder builder = Gateway.createBuilder();
		builder.identity(wallet, "appUser").networkConfig(networkConfigPath).discovery(true);

		// create a gateway connection
		try (Gateway gateway = builder.connect()) {

			// get the network and contract
			Network network = gateway.getNetwork("mychannel");
			Contract contract = network.getContract("fabcar");

			byte[] result;

			result = contract.evaluateTransaction("queryAllCars");
			System.out.println(new String(result));

			contract.submitTransaction("createCar", "CAR10", "VW", "Polo", "Grey", "Mary");

			result = contract.evaluateTransaction("queryCar", "CAR10");
			System.out.println(new String(result));

			contract.submitTransaction("changeCarOwner", "CAR10", "Archie");

			result = contract.evaluateTransaction("queryCar", "CAR10");
			System.out.println(new String(result));
		}
	}

}
```

`evaluateTransaction` 方法代表了一种区块链网络中和智能合约最简单的交互。它只是的根据配置文件中的定义连接一个节点，然后向节点发送请求，请求内容将在节点中执行。智能合约查询节点账本上的所有汽车，然后把结果返回给应用程序。这次交互没有导致账本的更新。

`submitTransaction` 比 `evaluateTransaction` 更加复杂。除了跟一个单独的 peer 进行互动外，SDK 会将 `submitTransaction` 提案发送给在区块链网络中的每个需要的组织的 peer。其中的每个 peer 将会使用这个提案来执行被请求的智能合约，以此来产生一个建议的回复，它会为这个回复签名并将其返回给 SDK。SDK 搜集所有签过名的交易反馈到一个单独的交易中，这个交易会被发送给排序节点。排序节点从每个应用程序那里搜集并将交易排序，然后打包进一个交易的区块中。接下来它会将这些区块分发给网络中的每个 peer，在那里每笔交易会被验证并提交。最后，SDK 会被通知，这允许它能够将控制返回给应用程序。



# 使用 CouchDB

## 启动网络

```shell
cd fabric-samples/test-network
./network.sh down

# 如果你之前从没运行过这个教程，在我们部署链码到网络之前你需要使用 vendor 来安装链码的依赖文件。
cd ../chaincode/marbles02/go
GO111MODULE=on go mod vendor
cd ../../../test-network

./network.sh up createChannel -s couchdb
```

`GO111MODULE=on go mod vendor` 这一步报 `connect: connection refused` 的话，可以尝试换一下源

旧版 GO111MODULE 不支持换源是导致他下载非常麻烦的一大因素,在国内我们无论是使用 Python 的 pip,还是 nodejs 的 npm,甚至是很多 Linux 发行版都会优先换个源在使用。GO111MODULE 首先解决了这个不能换源的问题。所以在使用新版包管理器前建议你先进行一下换源。

- 七牛 CDN
  `go env -w GOPROXY=https://goproxy.cn,direct`
- 阿里云
  `go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct`
- 官方
  `go env -w GOPROXY=https://goproxy.io,direct`
  网上比较流行使用的多的是七牛的,三选一即可,可以都试试看在你的网络环境下谁快
  这个换源命令只有在使用新的包管理器时才会生效

## 安装和定义链码

```shell
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

peer lifecycle chaincode package marbles.tar.gz --path ../chaincode/marbles02/go --lang golang --label marbles_1

peer lifecycle chaincode install marbles.tar.gz

# peer lifecycle chaincode queryinstalled
# 将上面命令返回的结果 package ID 声明成环境变量：格式如下 export CC_PACKAGE_ID=marbles_1:60ec9430b221140a45b96b4927d1c3af736c1451f8d432e2a869bdbf417f9787
export CC_PACKAGE_ID={将packageID声明为一个环境变量}

# 批准链码定义
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name marbles --version 1.0 --signature-policy "OR('Org1MSP.member','Org2MSP.member')" --init-required --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name marbles --version 1.0 --signature-policy "OR('Org1MSP.member','Org2MSP.member')" --init-required --sequence 1 --tls --cafile $ORDERER_CA

# 提交链码定义到通道
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name marbles --version 1.0 --sequence 1 --signature-policy "OR('Org1MSP.member','Org2MSP.member')" --init-required --tls --cafile $ORDERER_CA --peerAddresses localhost:7051 --tlsRootCertFiles $ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $ORG2_CA

# 调用链码的 Init() 初始化函数
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name marbles --isInit --tls --cafile $ORDERER_CA --peerAddresses localhost:7051 --tlsRootCertFiles $ORG1_CA -c '{"Args":["Init"]}'
```

新建一个终端窗口来验证部署的索引

```shell
# 验证部署的索引
docker logs peer0.org1.example.com  2>&1 | grep "CouchDB index"
```

## 查询 CouchDB 状态数据库

使用 peer 命令运行查询

```shell
# 使用 Org1 创建一个拥有者是 “tom” 的 marble
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n marbles -c '{"Args":["initMarble","marble1","blue","35","tom"]}'

peer chaincode query -C mychannel -n marbles -c '{"Args":["queryMarbles", "{\"selector\":{\"docType\":\"marble\",\"owner\":\"tom\"}, \"use_index\":[\"_design/indexOwnerDoc\", \"indexOwner\"]}"]}'
```

# network.sh 脚本阅读

## pushd、popd、trap 和 /dev/null

```shell
# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT
```

**pushd 的功能是创建一个目录栈**，你可以把你目前常见的几个目录压入栈中，并可以迅速地进行切换，非常方便。

`>` 为重定向符号

`> /dev/null` 是一个特殊的设备文件，这个文件接收到任何数据都会被丢弃，俗称“黑洞”

至于 popd，作用则是与 pushd 相反，将栈顶的目录弹出，此时除非再一次使用 pushd 压栈，否则 pushd 无法再找到已弹出的目录。

`trap "commands" signals` 接收到 signals 指定的信号时，执行 commands 命令(这里其实就是退出前把目录栈弹空)

## . + 空格 + sh 脚本

```shell
. scripts/utils.sh
```

`. scripts/utils.sh` 相当于 `source scripts/utils.sh`，即这里"."相当于 source 命令。关于 shell scripts 描述如下：

> source命令用法：
>
> `source FileName`
> 作用:在当前bash环境下读取并执行FileName中的命令。
>
> 注：该命令通常用命令“.”来替代。
>
> 如：`source .bash_rc` 与 `. .bash_rc` 是等效的。
>
> 注意：source 命令与 shell scripts 的区别是，source 在当前 bash 环境下执行命令，而 scripts 是启动一个子 shell 来执行命令。这样如果把设置环境变量（或 alias 等等）的命令写进 scripts 中，就只会影响子 shell,无法改变当前的 BASH,所以通过文件（命令列）设置环境变量时，要用 source 命令。


链接：https://blog.csdn.net/chenyixuan0923_yp/article/details/101075425

其实后面出现的那些 infoln、warnln 之类的就是从这里导入的。

## : ${VAR:=DEFAULT}

```shell
: ${CONTAINER_CLI:="docker"}
: ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI}-compose"}
```

`: ${VAR:=DEFAULT}` 当变量 VAR 没有声明或者为 NULL 时，将 VAR 设置为默认值 DEFAULT。如果不在前面加上 `:` 命令，那么就会把 `${VAR:=DEFAULT}` 本身当做一个命令来执行，报错是肯定的。

空命令[冒号]. 这个命令意思是空操作(即什么操作也不做). 它一般被认为是和 shell 的内建命令 true 是一样的。冒号 ":" 命令是 Bash 自身内建的, 它的退出状态码是真(即 0)。

## $()、docker rm、docker ps

```shell
# Obtain CONTAINER_IDS and remove them
# This function is called when you bring a network down
function clearContainers() {
  infoln "Removing remaining containers"
  ${CONTAINER_CLI} rm -f $(${CONTAINER_CLI} ps -aq --filter label=service=hyperledger-fabric) 2>/dev/null || true
  ${CONTAINER_CLI} rm -f $(${CONTAINER_CLI} ps -aq --filter name='dev-peer*') 2>/dev/null || true
}
```

在 bash 中，`$( )` 与 ` `` `（反引号）都是用来作命令替换的。
命令替换是用来重组命令行的，先完成引号里的命令行，然后将其结果替换出来，再重组成新的命令行。

注意：`$( )` 的弊端是，并不是所有的类 unix 系统都支持这种方式，但反引号是肯定支持的

**docker rm ：**删除一个或多个容器。

OPTIONS 说明：

- **-f、--force:** 通过 SIGKILL 信号强制删除一个运行中的容器。
- **-l、--link:** 移除容器间的网络连接，而非容器本身。
- **-v、--volumes:** 删除与容器关联的卷。

**docker ps :** 列出容器

OPTIONS 说明：

- **-a、--all:**显示所有的容器，包括未运行的。
- **-f、--filter:**根据条件过滤显示的内容。
- **--format :**指定返回值的模板文件。
- **-l、--latest:**显示最近创建的容器。
- **-n、--last:**列出最近创建的n个容器。
- **--no-trunc :**不截断输出。
- **-q、--quiet:**静默模式，只显示容器编号。
- **-s、--size:**显示总的文件大小。

## docker images、docker image rm

```shell
# Delete any images that were generated as a part of this setup
# specifically the following images are often left behind:
# This function is called when you bring the network down
function removeUnwantedImages() {
  infoln "Removing generated chaincode docker images"
  ${CONTAINER_CLI} image rm -f $(${CONTAINER_CLI} images -aq --filter reference='dev-peer*') 2>/dev/null || true
}
```

**docker images :** 列出本地镜像。

OPTIONS 说明：

- **-a、--all :**列出本地所有的镜像（含中间映像层，默认情况下，过滤掉中间映像层）；
- **--digests :**显示镜像的摘要信息；
- **-f、--filter :**显示满足条件的镜像；
- **--format :**指定返回值的模板文件；
- **--no-trunc :**显示完整的镜像信息；
- **-q、--quiet :**只显示镜像ID。

**docker image rm :** 命令用于删除一个或多个映像。

OPTIONS 说明：

- **--force、-f :** 强制删除映像
- **--no-prune :** 不要删除未标记的父映像

## > /dev/null 2>&1

```shell
# Do some basic sanity checking to make sure that the appropriate versions of fabric
# binaries/images are available. In the future, additional checking for the presence
# of go or other items could be added.
function checkPrereqs() {
  ## Check if your have cloned the peer binaries and configuration files.
  peer version > /dev/null 2>&1
```

`command >/dev/null 2>&1 &`  == `command 1>/dev/null 2>&1 &`

1. `command`: 表示shell命令或者为一个可执行程序
2. `>`: 表示重定向到哪里
3. `/dev/null`: 表示Linux的空设备文件
4. `2`:表示标准错误输出
5. `&1`: &表示等同于的意思,`2>&1`,表示 2 的输出重定向等于于 1
6. `&`:表示后台执行,即这条指令执行在后台运行

 

`1>/dev/null`: 表示标准输出重定向到空设备文件,也就是不输出任何信息到终端,不显示任何信息。
`2>&1`: 表示标准错误输出重定向等同于标准输出,因为之前标准输出已经重定向到了空设备文件,所以标准错误输出也重定向到空设备文件。

这条命令的意思就是在后台执行这个程序,并将错误输出 2 重定向到标准输出 1,然后将标准输出 1 全部放到 /dev/null 文件,也就是清空.
所以可以看出 ">/dev/null 2>&1" 常用来避免 shell 命令或者程序等运行中有内容输出。

## $? -ne 0、! -d

```shell
  if [[ $? -ne 0 || ! -d "../config" ]]; then
    errorln "Peer binary and configuration files not found.."
    errorln
    errorln "Follow the instructions in the Fabric docs to install the Fabric Binaries:"
    errorln "https://hyperledger-fabric.readthedocs.io/en/latest/install.html"
    exit 1
  fi
```

`$?` 是 shell 变量,表示"最后一次执行命令"的退出状态.0 为成功,非 0 为失败.

整数比较

`-eq`   等于,如: `if ["$a" -eq "$b" ]`

`-ne`   不等于,如: `if ["$a" -ne "$b" ]`

`-gt`   大于,如: `if ["$a" -gt "$b" ]`

`-ge`  大于等于,如: `if ["$a" -ge "$b" ]`

`-lt`   小于,如: `if ["$a" -lt "$b" ]`

`-le`   小于等于,如: `if ["$a" -le "$b" ]`

`<=` 小于等于(需要双括号),如: `(("$a" <= "$b"))`

`>` 大于(需要双括号),如: `(("$a" > "$b"))`

`>=` 大于等于(需要双括号),如: `(("$a" >= "$b"))`



- 第1步: ` !` 一般在 shell 脚本中表示取反
- 第2步: `[]` 这个叫条件表达式，简易版的 if
  `-n` 用于判断变量是否为空,注意只要有一个符号就不为空,空格也不行
  `-d` directory意思 用于判断目录是否存在
- 第3步: `[ ! -n ]` `[ ! -d ]` 的意思你应该懂了
  `[ ! -n ]` 判断变量如果不为空则条件成立
  `[ ! -d ]` 判断变量如果不是目录则条件成立

## sed、docker run

```shell
  # use the fabric tools container to see if the samples and binaries match your
  # docker images
  LOCAL_VERSION=$(peer version | sed -ne 's/^ Version: //p')
  DOCKER_IMAGE_VERSION=$(${CONTAINER_CLI} run --rm hyperledger/fabric-tools:latest peer version | sed -ne 's/^ Version: //p')

  infoln "LOCAL_VERSION=$LOCAL_VERSION"
  infoln "DOCKER_IMAGE_VERSION=$DOCKER_IMAGE_VERSION"

  if [ "$LOCAL_VERSION" != "$DOCKER_IMAGE_VERSION" ]; then
    warnln "Local fabric binaries and docker images are out of  sync. This may cause problems."
  fi
```

sed 命令是利用 script 来处理文本文件。

sed 可依照 script 的指令，来处理、编辑文本文件。

sed 主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。

**语法**

`sed [-hnV][-e<script>][-f<script文件>][文本文件]`

**参数说明**：

- `-e<script>` 或 `--expression=<script>` 以选项中指定的 script 来处理输入的文本文件。
- `-f<script文件>` 或 `--file=<script文件>` 以选项中指定的script文件来处理输入的文本文件。
- `-h` 或 `--help` 显示帮助。
- `-i` ：直接修改文件内容;
- `-r` ：支持扩展表达式;
- `-n` 或 `--quiet` 或 `--silent` 仅显示script处理后的结果。
- `-V` 或 `--version` 显示版本信息。

**动作说明**：

- a ：新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)
- c ：取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
- d 删除，删除选择的行;
- D 删除模板块的第一行;
- i ：插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
- p ：列印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行
- s ：取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦！
- h 拷贝模板块的内容到内存中的缓冲区;
- H 追加模板块的内容到内存中的缓冲区;
- g 获得内存缓冲区的内容，并替代当前模板块中的文本;
- G 获得内存缓冲区的内容，并追加到当前模板块文本的后面;
- l 列表不能打印字符的清单;
- n 读取下一个输入行，用下一个命令处理新的行而不是用第一个命令;
- N 追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码;
- p 打印模板块的行。 P(大写) 打印模板块的第一行;
- q 退出Sed;
- b lable 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾;
- r file 从file中读行;
- t label if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾;
- T label 错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾;
- w file 写并追加模板块到file末尾;
- W file 写并追加模板块的第一行到file末尾;
- `!` 表示后面的命令对所有没有被选定的行发生作用;
- `=` 打印当前行号;
- `#` 把注释扩展到下一个换行符以前;

**sed 元字符集**

- `^` 匹配行开始，如：`/^sed/` 匹配所有以 sed 开头的行;

- `$` 匹配行结束，如：`/sed$/` 匹配所有以 sed 结尾的行;

- `.` 匹配一个非换行符的任意字符，如：`/s.d/` 匹配 s 后接一个任意字符，最后是 d;

- `*` 匹配 0 个或多个字符，如：`/*sed/` 匹配所有模板是一个或多个空格后紧跟 sed 的行;

- `[]` 匹配一个指定范围内的字符，如/[ss]ed/匹配sed和Sed;

- `[^]` 匹配一个不在指定范围内的字符，如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行;

- `\(..\)` 匹配子串，保存匹配的字符，如 `s/\(love\)able/\1rs`，loveable被替换成lovers;

- `&` 保存搜索字符用来替换其他字符，如 `s/love/**&**/`，`love` 这成`**love**`;

- `\<` 匹配单词的开始 `\>` 匹配单词的结束，如 `/love\>/` 匹配包含以 love 结尾的单词的行;

- `x\{m\}` 重复字符x，m次，如：`/0\{5\}/` 匹配包含5个0的行;

  `x\{m,\}` 重复字符x，至少m次，如：`/0\{5,\}/` 匹配至少有5个0的行;

  `x\{m,n\}` 重复字符x，至少m次，不多于n次，如：`/0\{5,10\}/` 匹配5~10个0的行;

**docker run ：**创建一个新的容器并运行一个命令

语法

`docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`

OPTIONS 说明：

- **-a stdin:** 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
- **-d:** 后台运行容器，并返回容器ID；
- **-i:** 以交互模式运行容器，通常与 -t 同时使用；
- **-P:** 随机端口映射，容器内部端口**随机**映射到主机的端口
- **-p:** 指定端口映射，格式为：**主机(宿主)端口:容器端口**
- **-t:** 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
- **--name="nginx-lb":** 为容器指定一个名称；
- **--dns 8.8.8.8:** 指定容器使用的DNS服务器，默认和宿主一致；
- **--dns-search example.com:** 指定容器DNS搜索域名，默认和宿主一致；
- **-h "mars":** 指定容器的hostname；
- **-e username="ritchie":** 设置环境变量；
- **--env-file=[]:** 从指定文件读入环境变量；
- **--cpuset="0-2" or --cpuset="0,1,2":** 绑定容器到指定CPU运行；
- **-m :**设置容器使用内存最大值；
- **--net="bridge":** 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；
- **--link=[]:** 添加链接到另一个容器；
- **--expose=[]:** 开放一个端口或一组端口；
- **--volume , -v:** 绑定一个卷
- **--rm:** 自动在退出时删除容器

## set -x

```shell
    set -x
    cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="organizations"
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
      fatalln "Failed to generate certificates..."
    fi
```

set -x 一句话总结：显示脚本运行是的冗余输出，在 set 命令之后执行的每一条命令以及加载命令行中的任何参数都会显示出来，每一行都会加上加号（+），提示它是跟踪输出的标识。

**set -x 开启**

**set +x 关闭**

## docker-compose -f

```shell
  # Create crypto material using Fabric CA
  if [ "$CRYPTO" == "Certificate Authorities" ]; then
    infoln "Generating certificates using Fabric CA"
    ${CONTAINER_CLI_COMPOSE} -f compose/$COMPOSE_FILE_CA -f compose/$CONTAINER_CLI/${CONTAINER_CLI}-$COMPOSE_FILE_CA up -d 2>&1

    . organizations/fabric-ca/registerEnroll.sh

    while :
    do
      if [ ! -f "organizations/fabric-ca/org1/tls-cert.pem" ]; then
        sleep 1
      else
        break
      fi
    done

    infoln "Creating Org1 Identities"

    createOrg1

    infoln "Creating Org2 Identities"

    createOrg2

    infoln "Creating Orderer Org Identities"

    createOrderer

  fi

  infoln "Generating CCP files for Org1 and Org2"
  ./organizations/ccp-generate.sh
```

`docker-compose -f xxx -f xxxx` :会将多个 `compose.yaml` 文件合并到一起。当指定了多个文件时(包括没指定 `-f` 但同时存在 `docker-compose.yml` 和 `docker-compose.override.yml` 文件)，Compose 会将多个文件合并成一个配置文件，合并的结果与指定文件的顺序有关。合并有两种操作，没有的添加，相同的覆盖。

**`docker-compose up` 与 `docker-compose up -d` 用法和区别**

两者都是创建或者重新创建容器，附加给当前服务器，除此之外，除非服务已经运行，否则启动所有链接服务。

`docker-compose up` 本质是 `docker-compose logs -f`，它会收集所有容器的日志输出直到退出命令，或者容器都停止运行。

`docker-compose up -d` 以后台的方式运行容器。不会在终端上打印运行日志

## docker 的 /var/run/docker.sock 参数

```shell
# Get docker sock path from environment variable
SOCK="${DOCKER_HOST:-/var/run/docker.sock}"
DOCKER_SOCK="${SOCK##unix://}"
```

Docker Daemon 的配置参数默认监听的是 /var/run/docker.sock 这个文件，所以 docker 客户端只要把请求发往这里，daemon 就能收到并且做出响应。

我们也可以向 /var/run/docker.sock 发送请求，也能达到 docker ps、docker images 这样的效果