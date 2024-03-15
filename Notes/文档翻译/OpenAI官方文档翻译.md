# 入门

## 简介

### 总览

OpenAI API 几乎可以应用于任何涉及理解或生成自然语言或代码的任务。我们提供许多适合不同任务的模型，以及精调您自己定制模型的能力。这些模型可以用于从内容生成到语义搜索和分类的所有方面。

### 关键概念

我们建议完成我们的快速入门教程，通过一个实际的交互式示例熟悉关键概念。

#### 提示和补全

补全端点位于 API 的中心。它为我们的模型提供了一个非常灵活和强大的简单界面。您输入一些文本作为**提示**，模型将生成一个文本**补全**，该文本完成符将尝试匹配您提供的任何上下文或模式。例如，如果您向 API 提供提示，“为冰淇淋店写一条标语”，它将返回一个补全，如“我们为每一勺冰淇淋提供微笑！”

设计提示本质上是如何“编程”模型，通常通过提供一些说明或一些示例。这与大多数其他为单个任务设计的 NLP 服务不同，例如情感分类或命名实体识别。相反，补全端点实际上可以用于任何任务，包括内容或代码生成、摘要、扩展、对话、创意写作、风格转换等。

#### 标记（Tokens）

我们的模型通过将文本分解为标记来理解和处理文本。标记可以是单词，也可以是字符块。例如，“汉堡（hamburger）”一词被分解为“ham”、“bur”和“ger”，而像“pear”这样的简短而常见的词是一个单一的标记。许多标记以空格开头，例如“ hello”和“ bye”。

给定 API 请求中处理的标记数取决于输入和输出的长度。作为一个粗略的经验法则，对于英语文本，1 个标记大约是 4 个字符或 0.75 个单词。要记住的一个限制是，文本提示和生成的补全组合必须不超过模型的最大上下文长度（对于大多数模型，这是 2048 个标记，或大约 1500 个单词）。查看我们的标记工具，了解更多有关文本如何转换为标记的信息。

#### 模型

API 由一组具有不同功能和价位的模型提供支持。我们的 GPT-3 基础模型称为 Davinci、Curie、Babbage 和 Ada。我们的 Codex 系列是 GPT-3 的后代，它接受了自然语言和代码的训练。要了解更多信息，请访问我们的模型文档。

### 下一步

- 在您开始构建应用程序时，请记住我们的使用策略。
- 探索我们的示例库以获得灵感。
- 跳到我们的一个指南中开始构建。

## 快速开始

OpenAI 已经培养了非常善于理解和生成文本的尖端语言模型。我们的 API 提供了对这些模型的访问，可用于解决几乎任何涉及处理语言的任务。

在本快速入门教程中，您将构建一个简单的示例应用程序。在此过程中，您将学习对将 API 用于任何任务至关重要的关键概念和技术，包括：

- 内容生成
- 总结
- 分类（Classification）、分种（categorization）和情感分析
- 数据提取
- 翻译
- 更多！

### 简介

completions 端点是我们 API 的核心，它提供了一个非常灵活和强大的简单接口。您输入一些文本作为提示，API 将返回一个文本补全，该补全尝试匹配您给出的任何指令或上下文。

```
Prompt: Write a tagline for an ice cream shop.
↓
Completion: We serve up smiles with every scoop!
```

您可以认为这是一个非常高级的自动完成——模型处理您的文本提示，并尝试预测接下来最可能发生的事情。

### 从一个指令开始

假设你想创建一个宠物名字生成器。从头开始想名字很难！

首先，你需要一个提示（prompt），明确你想要什么。让我们从一个指令开始。**提交此提示**以生成第一个补全。

```
Suggest one name for a horse.
```

不错！现在，尝试让您的指令更具体。

```
Suggest one name for a black horse.
```

如您所见，在提示中添加一个简单的形容词会改变结果完成。设计提示实质上是对应你如何“编程”模型。

### 添加一些例子

制定好的指示对于获得好的结果很重要，但有时还不够。让我们尝试让您的指令更加复杂。

```
Suggest three names for a horse that is a superhero.
```

这个完成不是我们想要的。这些名字都很通用，而且我们的指导中似乎没有提到这个模型。让我们看看能否让它提出一些更相关的建议。

在很多情况下，展示和告诉模特你想要什么是很有帮助的。在提示中添加示例可以帮助沟通模式或细微差别。尝试提交包含几个示例的提示。

```
Suggest three names for an animal that is a superhero.

Animal: Cat
Names: Captain Sharpclaw, Agent Fluffball, The Incredible Feline
Animal: Dog
Names: Ruff the Protector, Wonder Canine, Sir Barks-a-Lot
Animal: Horse
Names:
```

很好！添加给定输入的输出示例有助于模型提供所需的名称类型。

### 调整你的设置

即时设计不是您可以使用的唯一工具。您还可以通过调整设置来控制补全。最重要的设置之一是**温度**。

您可能已经注意到，如果在上面的示例中多次提交相同的提示，那么模型将始终返回相同或非常相似的完成。这是因为您的温度设置为 **0**。

尝试在温度设置为 **1** 的情况下多次重新提交相同的提示。

```
Suggest three names for an animal that is a superhero.

Animal: Cat
Names: Captain Sharpclaw, Agent Fluffball, The Incredible Feline
Animal: Dog
Names: Ruff the Protector, Wonder Canine, Sir Barks-a-Lot
Animal: Horse
Names:
```

看到发生了什么吗？当温度高于 0 时，每次提交相同的提示会导致不同的补全。

请记住，模型预测哪个文本最有可能跟在前面的文本后面。温度是一个介于 0 和 1 之间的值，基本上可以让您控制模型在进行这些预测时的自信程度。降低温度意味着风险更小，补全将更加准确和确定。温度升高将导致更多样的补全。

> **理解 token 和概率**
>
> 我们的模型通过将文本分解为称为**标记**（token）的较小单元来处理文本。标记可以是单词、单词块或单个字符。编辑下面的文本，看看它是如何标记的。
>
> ```
> I have an orange cat named Butterscotch.
> I| have| an| orange| cat| named| But|ters|cot|ch|.
> ```
>
> 像“cat”这样的常见单词是一个标记，而不太常见的单词通常被分解为多个标记。例如，“奶油糖果(Butterscotch)”翻译为四个标记：“But”、“ters”、“cot” 和 “ch”。许多标记以空格开头，例如 “hello” 和 “bye”。
>
> 给定一些文本，模型确定下一个最可能出现的标记。例如，文本“马是我的最爱”后面最有可能是标记“动物”。
>
> ```
> Horses are my favorite
> animal		49.65%
> animals		42.58%
> \n			3.49%
> !			0.91%
> ```
>
> 这就是**温度**发挥作用的地方。如果您在温度设置为 0 的情况下提交此提示 4 次，则模型将始终返回“animal”，因为它的概率最高。如果你提高温度，它将承担更多风险，并考虑概率较低的标记。
>
> 通常最好为目标输出明确的任务设置较低的温度。更高的温度可能对需要多样性或创造力的任务有用，或者如果您想生成一些变体供最终用户或人类专家选择。

对于你的宠物名字生成器，你可能希望能够生成很多名字想法。0.6 的中等温度应该很好。

### 构建你的应用

现在，您已经找到了一个良好的提示和设置，您可以开始构建您的宠物名称生成器了！我们已经编写了一些代码让您开始——按照以下说明下载代码并运行应用程序。

#### 安装程序

如果没有安装 Node.js，请从这里安装。然后通过克隆此存储库下载代码。

```shell
git clone https://github.com/openai/openai-quickstart-node.git
```

如果您不想使用 git，也可以使用这个 zip 文件下载代码。

#### 添加你的 API key

要使应用程序正常工作，您需要一个 API 密钥。您可以通过注册帐户并返回此页面获得一个。

#### 运行应用

在项目目录中运行以下命令以安装依赖项并运行应用程序。

```shell
npm install
npm run dev
```

在你的浏览器中打开 http://localhost:3000，你应该会看到宠物名字生成器！

#### 理解代码

在 `openai-quickstart-node/pages/api` 文件夹中打开 `generate.js`。在底部，您将看到生成上面使用的提示的函数。由于用户将输入其宠物的动物类型，因此它会动态地替换提示中指定动物的部分。

```javascript
function generatePrompt(animal) {
  const capitalizedAnimal = animal[0].toUpperCase() + animal.slice(1).toLowerCase();
  return `Suggest three names for an animal that is a superhero.

Animal: Cat
Names: Captain Sharpclaw, Agent Fluffball, The Incredible Feline
Animal: Dog
Names: Ruff the Protector, Wonder Canine, Sir Barks-a-Lot
Animal: ${capitalizedAnimal}
Names:`;
}
```

在 `generate.js` 的第 9 行，您将看到发送实际 API 请求的代码。如上所述，它使用温度为 0.6 的补全端点。

```javascript
const completion = await openai.createCompletion({
  model: "text-davinci-003",
  prompt: generatePrompt(req.body.animal),
  temperature: 0.6,
});
```

就这样！你现在应该完全了解你的（超级英雄）宠物名字生成器是如何使用 OpenAI API 的！

### 结束

这些概念和技术将在很大程度上帮助您构建自己的应用程序。也就是说，这个简单的例子只展示了一点点可能！补全端点非常灵活，几乎可以解决任何语言处理任务，包括内容生成、摘要、语义搜索、主题标记、情感分析等等。

要记住的一个限制是，对于大多数模型，单个 API 请求在提示和补全之间最多只能处理 2048 个标记（约 1500 个单词）。

> **模型和价格**
>
> 我们提供一系列具有不同功能和价位的型号。在本教程中，我们使用了 `text-davinci-003`，这是我们最强大的自然语言模型。我们建议在实验时使用此模型，因为它将产生最佳结果。一旦你完成了工作，你就可以看到其他模型是否可以以更低的延迟和成本产生相同的结果。
>
> 单个请求中处理的标记总数（提示和补全）不能超过模型的最大上下文长度。对于大多数模型，这是 2048 个标记或大约 1500 个单词。作为一个粗略的经验法则，对于英语文本，1 个标记大约是 4 个字符或 0.75 个单词。
>
> 定价为每 1000 个标记按需付费，前 3 个月可使用 18 美元的免费额度。了解更多信息。

对于更高级的任务，您可能会发现自己希望提供比单个提示中所能容纳的更多的示例或上下文。精调 API 是类似这样的高级任务的一个很好的选择。精调允许您提供数百甚至数千个示例，以定制特定用例的模型。

### 下一步

要获得灵感并了解有关为不同任务设计提示的更多信息，请执行以下操作：

- 阅读我们的补全指南。
- 浏览我们的示例提示库。
- 开始在 Playground 上试验。
- 在您开始构建时，请记住我们的使用策略。

## 库

### Python 库

我们提供了一个 Python 库，您可以按如下方式安装：

```shell
$ pip install openai
```

安装后，可以使用绑定和密钥运行以下操作：

```python
import os
import openai

# Load your API key from an environment variable or secret management service
openai.api_key = os.getenv("OPENAI_API_KEY")

response = openai.Completion.create(model="text-davinci-003", prompt="Say this is a test", temperature=0, max_tokens=7)
```

绑定还将安装一个命令行实用程序，您可以按如下方式使用：

```shell
$ openai api completions.create -m text-davinci-003 -p "Say this is a test" -t 0 -M 7 --stream
```

### Node.js 库

我们还有一个 Node.js 库，您可以通过在 Node.js 项目目录中运行以下命令来安装它：

```shell
$ npm install openai
```

安装后，您可以使用库和密钥运行以下操作：

```javascript
const { Configuration, OpenAIApi } = require("openai");
const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);
const response = await openai.createCompletion({
  model: "text-davinci-003",
  prompt: "Say this is a test",
  temperature: 0,
  max_tokens: 7,
});
```

### 社区库

下面的库由更广泛的开发人员社区构建和维护。如果您想在这里添加一个新的库，请按照帮助中心关于添加社区库的文章中的说明进行操作。

请注意，OpenAI 不会验证这些项目的正确性或安全性。

#### C# / .NET

- [Betalgo.OpenAI.GPT3](https://github.com/betalgo/openai) by [Betalgo](https://github.com/betalgo)

#### Crystal

- [openai-crystal](https://github.com/sferik/openai-crystal) by [sferik](https://github.com/sferik)

#### Go

- [go-gpt3](https://github.com/sashabaranov/go-gpt3) by [sashabaranov](https://github.com/sashabaranov)

#### Java

- [openai-java](https://github.com/TheoKanning/openai-java) by [Theo Kanning](https://github.com/TheoKanning)

#### Kotlin

- [openai-kotlin](https://github.com/Aallam/openai-kotlin) by [Mouaad Aallam](https://github.com/Aallam)

#### Node.js

- [openai-api](https://www.npmjs.com/package/openai-api) by [Njerschow](https://github.com/Njerschow)
- [openai-api-node](https://www.npmjs.com/package/openai-api-node) by [erlapso](https://github.com/erlapso)
- [gpt-x](https://www.npmjs.com/package/gpt-x) by [ceifa](https://github.com/ceifa)
- [gpt3](https://www.npmjs.com/package/gpt3) by [poteat](https://github.com/poteat)
- [gpts](https://www.npmjs.com/package/gpts) by [thencc](https://github.com/thencc)
- [@dalenguyen/openai](https://www.npmjs.com/package/@dalenguyen/openai) by [dalenguyen](https://github.com/dalenguyen)
- [tectalic/openai](https://github.com/tectalichq/public-openai-client-js) by [tectalic](https://tectalic.com/)

#### PHP

- [orhanerday/open-ai](https://packagist.org/packages/orhanerday/open-ai) by [orhanerday](https://github.com/orhanerday)
- [tectalic/openai](https://github.com/tectalichq/public-openai-client-php) by [tectalic](https://tectalic.com/)

#### Python

- [chronology](https://github.com/OthersideAI/chronology) by [OthersideAI](https://www.othersideai.com/)

#### R

- [rgpt3](https://github.com/ben-aaron188/rgpt3) by [ben-aaron188](https://github.com/ben-aaron188)

#### Ruby

- [openai](https://github.com/nileshtrivedi/openai/) by [nileshtrivedi](https://github.com/nileshtrivedi)
- [ruby-openai](https://github.com/alexrudall/ruby-openai) by [alexrudall](https://github.com/alexrudall)

#### Scala

- [openai-scala-client](https://github.com/cequence-io/openai-scala-client) by [cequence-io](https://github.com/cequence-io)

#### Swift

- [OpenAIKit](https://github.com/dylanshine/openai-kit) by [dylanshine](https://github.com/dylanshine)

#### Unity

- [OpenAi-Api-Unity](https://github.com/hexthedev/OpenAi-Api-Unity) by [hexthedev](https://github.com/hexthedev)

#### Unreal Engine

- [OpenAI-Api-Unreal](https://github.com/KellanM/OpenAI-Api-Unreal) by [KellanM](https://github.com/KellanM)

## 模型

### 总览

OpenAI API 由一系列具有不同功能和价位的模型提供支持。您还可以通过精调为您的特定用例定制我们的基础模型。

| 模型                                                         | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [GPT-3](https://platform.openai.com/docs/models/gpt-3)       | 一组可以理解并生成自然语言的模型                             |
| [Codex](https://platform.openai.com/docs/models/codex)（Limited beta） | 一组可以理解并生成代码的模型，包括将自然语言翻译成代码的功能 |
| [内容过滤器](https://platform.openai.com/docs/models/content-filter) | 一个精调过的模型，可以检测文本是否敏感或不安全               |

> 我们计划随着时间的推移不断改进我们的模型。为了实现这一点，我们可能使用您向我们提供的数据来提高其准确性、功能和安全性。了解更多信息。

访问我们的给研究人员的模型索引，了解更多关于我们的研究论文中使用了哪些模型以及 InstructionGPT 和 GPT-3.5 等模型系列之间的差异。

### GPT-3

我们的 GPT-3 模型可以理解并生成自然语言。我们提供四种主要型号，具有适合不同任务的不同功率级别。Davinci 是最能干的模型，Ada 是最快的。

| 最新模型           | 描述                                                         | 最大请求     | 训练数据        |
| :----------------- | :----------------------------------------------------------- | :----------- | :-------------- |
| `text-davinci-003` | 最强大的 GPT-3 模型。可以完成其他模型可以完成的任何任务，通常具有更高的质量、更长的输出和更好的指令遵从性。还支持[插入](https://platform.openai.com/docs/guides/completion/inserting-text)文本中的补全。 | 4,000 个标记 | 截止到 Jun 2021 |
| `text-curie-001`   | 非常能干，但比 Davanci 更快，成本更低。                      | 2,048 个标记 | 截止到 Oct 2019 |
| `text-babbage-001` | 能够完成简单的任务，速度快，成本低。                         | 2,048 个标记 | 截止到 Oct 2019 |
| `text-ada-001`     | 能够执行非常简单的任务，通常是 GPT-3 系列中速度最快的机型，并且成本最低。 | 2,048 个标记 | 截止到 Oct 2019 |

虽然 Davinci 通常是最有能力的，但其他型号可以非常好地执行某些任务，具有显著的速度或成本优势。例如，Curie 可以执行许多与 Davinci 相同的任务，但速度更快，成本仅为 Davinci 的 1/10。

我们建议在实验时使用 Davinci，因为它会产生最好的结果。一旦你完成了工作，我们鼓励你尝试其他模型，看看你是否能以更低的延迟获得同样的结果。您还可以通过在特定任务上对其他模型进行精调来提高它们的性能。

#### 特定特征的模型

主要 GPT-3 模型用于文本补全端点。我们还提供了专门用于其他端点的模型。

我们的 GPT-3 模型的旧版本有 `davinci`、`curie`、`babbage` 和 `ada`。这些将用于我们的精调端点。了解更多信息。

我们用于创建嵌入和编辑文本的端点使用自己的专用模型集。

#### Davinci

Davinci 是最能干的模型家族，可以完成其他模型所能完成的任何任务，而且通常只需要很少的指导。对于需要大量理解内容的应用程序，如针对特定受众的摘要和创造性内容生成，Davinci 将产生最佳结果。这些增加的功能需要更多的计算资源，因此 Davinci 每次 API 调用的成本更高，而且速度不如其他模型。

Davinci 的另一个亮点是理解文本的意图。达文西非常擅长解决各种逻辑问题，并解释人物的动机。达文西已经能够解决一些涉及因果关系的最具挑战性的人工智能问题。

擅长：**复杂的意图、因果关系、观众总结**

#### Curie

Curie 非常强大，但速度非常快。虽然 Davinci 在分析复杂的文本时更为强大，但 Curie 在情感分类和总结等许多细致入微的任务上却很有能力。Curie 还非常擅长回答问题和执行问答，以及作为一个通用服务聊天机器人。

擅长：**语言翻译、复杂分类、文本情感、摘要**

#### Babbage

Babbage 可以执行简单的分类等直接任务。当涉及到语义搜索时，它也很有能力对文档与搜索查询的匹配程度进行排名。

擅长：**中等分类、语义搜索分类**

#### Ada

Ada 通常是速度最快的模型，可以执行解析文本、地址更正和某些类型的分类任务，这些任务不需要太多细微差别。Ada 的性能通常可以通过提供更多上下文来提高。

擅长：**解析文本、简单分类、地址更正、关键字**

注：任何由像 Ada 这样的更快的模型执行的任务都可以由像 Curie 或 Davinci 这样的更强大的模型执行。

> OpenAI 模型是非确定性的，这意味着相同的输入可以产生不同的输出。将温度设置为 0 将使输出大部分具有确定性，但仍可能存在少量可变性。

### 找到正确的模型

使用 Davinci 进行实验是了解 API 功能的一个好方法。当你有了想要完成的目标后，如果你不担心成本和速度，那么你可以留在 Davinci；或者选择 Curie 或其他模型，并尝试围绕其功能进行优化。

您可以使用 GPT 比较工具，该工具允许您并行运行不同的模型来比较输出、设置和响应时间，然后将数据下载到 `.xls` Excel 电子表格中。

#### 考虑语义搜索

对于涉及分类的任务，当您试图找到最适合文本选择的标签时，您通常可以使用语义搜索从不同的模型中获得出色的性能。语义搜索使用模型为不同的文本块提供分数，以确定它们与查询的关联程度。通过将模型的范围集中于评估查询与不同文本块的关系，在许多情况下，与作为生成任务呈现给他们的任务相比，更快的模型可以表现得更好。

### Codex

Codex 模型是 GPT-3 模型的后代，可以理解和生成代码。他们的训练数据包含自然语言和来自 GitHub 的数十亿行公共代码。了解更多信息。

他们精通 Python，精通十几种语言，包括 JavaScript、Go、Perl、PHP、Ruby、Swift、TypeScript、SQL，甚至 Shell。

我们目前提供两种 Codex 模型：

| 最新模型           | 描述                                                         | 最大请求           | 训练数据        |
| :----------------- | :----------------------------------------------------------- | :----------------- | :-------------- |
| `code-davinci-002` | 最强大的 Codex 模型。特别擅长将自然语言翻译成代码。除了完成代码，还支持[插入](https://platform.openai.com/docs/guides/code/inserting-code)代码内的完成。 | 8,000 个标记       | 截止到 Jun 2021 |
| `code-cushman-001` | 几乎与 Davinci Codex 一样强大，但速度稍快。这种速度优势可使其更适合于实时应用。 | 最多  2,048 个标记 |                 |

有关更多信息，请访问我们的 Codex 工作指南。

### 内容过滤器

# 指南

## 文本补全

学习如何生成或操作文本。

### 简介

补全端点可用于各种任务。它为我们的任何模型提供了一个简单但强大的接口。您输入一些文本作为提示，模型将生成一个文本补全，该补全尝试匹配您给它的任何上下文或模式。例如，如果您给 API 提示“正如笛卡尔所说，我思故”，它将很可能返回补全“我在”。

开始探索补全的最佳方式是通过我们的 Playground。它只是一个文本框，您可以在其中提交提示以生成补全。您可以从以下示例开始：

```
Write a tagline for an ice cream shop.
```

提交后，您将看到以下内容：

```
Write a tagline for an ice cream shop.
We serve up smiles with every scoop!
```

您看到的实际完成情况可能有所不同，因为默认情况下 API 是不确定的。这意味着，即使提示保持不变，每次调用它时，可能会得到稍微不同的完成。将温度设置为 0 将使输出大部分具有确定性，但仍可能存在少量可变性。

这个简单的文本输入、文本输出界面意味着你可以通过提供指令或一些你希望它做什么的例子来“编程”模型。它的成功通常取决于任务的复杂性和提示的质量。一个很好的经验法则是思考如何为一个中学生写一道单词题来解决。一个写得很好的提示为模型提供了足够的信息，以了解您需要什么以及它应该如何响应。

本指南涵盖一般提示设计最佳实践和示例。要了解有关使用 Codex 模型处理代码的更多信息，请访问我们的代码指南。

> 请记住，默认模型的训练数据截止于 2021，因此他们可能不了解当前事件。我们计划在未来增加更多的持续训练。

### 提示设计

#### 基础

我们的模型可以做任何事情，从生成原始故事到执行复杂的文本分析。因为他们可以做很多事情，你必须明确地描述你想要什么。展示，而不仅仅是告诉，往往是一个好的提示的秘诀。

创建提示有三个基本原则：

**展示和讲述**。通过说明、示例或两者的结合，明确您想要什么。如果你想让模型按照字母顺序对一系列项目进行排序，或者按照情感对一个段落进行分类，那么向它展示你想要的东西。

**提供质量数据**。如果您试图构建分类器或使模型遵循某个模式，请确保有足够的示例。一定要校对你的例子——这个模型通常足够聪明，能够识破基本的拼写错误，并给你一个答案，但它也可能会假设这是故意的，它会影响你的答案。

**检查您的设置**。温度和 top_p 设置控制模型在生成响应时的确定性。如果你要求它给出一个只有一个正确答案的答案，那么你应该把这些设置得更低。如果您正在寻找更多样的答案，那么您可能希望将其设置得更高。人们在这些设置中使用的第一个错误是假设它们是“聪明”或“创造性”控件。

#### 故障排除

如果无法使 API 按预期执行，请遵循以下检查表：

1. 是否清楚预期的生成应该是什么？
2. 有足够的例子吗？
3. 你有没有检查你的例子中的错误？（API 不会直接告诉您）
4. 你正确使用了温度和 top_p 吗？

#### 分类

为了使用 API 创建文本分类器，我们提供了任务描述和几个示例。在这个例子中，我们展示了如何对推特的情感进行分类。

```
Decide whether a Tweet's sentiment is positive, neutral, or negative.

Tweet: I loved the new Batman movie!
Sentiment:
```

值得注意的是本示例中的几个功能：

1. **用通俗易懂的语言描述输入和输出**。我们对输入“推特”和预期输出“情感”使用简单的语言。作为最佳实践，从简单的语言描述开始。虽然您通常可以使用速记词或关键字来指示输入和输出，但最好从尽可能描述开始，然后反向删除多余的单词，看看性能是否保持一致。
2. **演示 API 如何响应任意情况**。在本例中，我们在说明中包含了可能的情绪标签。中立的标签很重要，因为在很多情况下，即使是人类也很难确定某件事是积极的还是消极的，而这两者都不是。
3. **熟悉的任务需要更少的示例**。对于这个分类器，我们不提供任何示例。这是因为API已经理解了情感和推特的概念。如果您正在为 API 可能不熟悉的内容构建分类器，则可能需要提供更多示例。

#### 提高分类的效率

现在我们已经掌握了如何构建分类器，让我们以该示例为例，使其更加高效，以便我们可以使用它从一个 API 调用中获取多个结果。

```
Classify the sentiment in these tweets:

1. "I can't stand homework"
2. "This sucks. I'm bored 😠"
3. "I can't wait for Halloween!!!"
4. "My cat is adorable ❤️❤️"
5. "I hate chocolate"

Tweet sentiment ratings:
```

我们提供了一个推特的编号列表，因此 API 可以在一次 API 调用中对五个（甚至更多）推特进行评级。

需要注意的是，当你要求 API 创建列表或评估文本时，你需要特别注意你的概率设置（Top P 或 Temperature），以避免漂移。

1. 通过运行多个测试，确保正确校准了概率设置。
2. 不要列出太长的列表，否则 API 可能会漂移。

#### 生成

使用 API 可以完成的最强大但最简单的任务之一是生成新的想法或输入版本。你可以要求任何东西，从故事构思，到商业计划，到人物描述和营销口号。在本例中，我们将使用 API 创建在健身中使用虚拟现实的想法。

```
Brainstorm some ideas combining VR and fitness:
```

如果需要，可以通过在提示中包含一些示例来提高响应的质量。

#### 对话

API 非常擅长与人类甚至自己进行对话。只需几行指令，我们就可以看到 API 作为一个客服聊天机器人，智能地回答问题，而不会慌乱，或者是一个聪明的聊天伙伴，会讲笑话和双关语。关键是告诉 API 应该如何操作，然后提供一些示例。

下面是 API 扮演 AI 回答问题的角色的示例：

```
The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.

Human: Hello, who are you?
AI: I am an AI created by OpenAI. How can I help you today?
Human:
```

这就是创建一个能够进行对话的聊天机器人所需要的一切。在其简单的背后，有几件事值得注意：

1. **我们告诉 API 意图，但也告诉它如何行为**。就像其他提示一样，我们向 API 提示示例所代表的内容，但我们还添加了另一个关键细节：我们向它提供了关于如何与短语“助手很有帮助、很有创造力、很聪明、很友好”交互的明确指示
   如果没有这个指令，API 可能会偏离并模仿它正在与之交互的人，变得讽刺或其他我们想要避免的行为。
2. **我们给 API 一个标识**。一开始，我们让 API 作为 AI 助手进行响应。虽然 API 没有固有的身份，但这有助于它以尽可能接近真实的方式进行响应。你可以用其他方式使用身份来创建其他类型的聊天机器人。如果你让 API 作为一名从事生物学研究的女性来回应，你会从 API 中得到明智而周到的评论，这与你期望的具有这种背景的人的评论类似。

在本例中，我们创建了一个有点讽刺的聊天机器人，并勉强回答了问题：

```
Marv is a chatbot that reluctantly answers questions with sarcastic responses:

You: How many pounds are in a kilogram?
Marv: This again? There are 2.2 pounds in a kilogram. Please make a note of this.
You: What does HTML stand for?
Marv: Was Google too busy? Hypertext Markup Language. The T is for try to ask better questions in the future.
You: When did the first airplane fly?
Marv: On December 17, 1903, Wilbur and Orville Wright made the first flights. I wish they’d come and take me away.
You: What is the meaning of life?
Marv: I’m not sure. I’ll ask my friend Google.
You: Why is the sky blue?
```

为了创建一个有趣且有帮助的聊天机器人，我们提供了几个问题和答案的示例，展示了 API 如何回复。它所需要的只是一些讽刺性的回应，而 API 能够抓住这种模式并提供无穷无尽的讽刺性回应。

#### 变换（Transformation）

API 是一种语言模型，它熟悉单词和字符表达信息的各种方式。这包括自然语言文本、代码和英语以外的语言。API 还能够在某种程度上理解内容，从而允许它以不同的方式总结、转换和表达内容。

##### 翻译

在本例中，我们展示了 API 如何从英语转换为法语、西班牙语和日语：

```
Translate this into French, Spanish and Japanese:

What rooms do you have available?
```

这个示例之所以有效，是因为 API 已经掌握了这些语言，所以没有必要尝试教授它们。

如果你想把英语翻译成 API 不熟悉的语言，你需要提供更多的例子，甚至可以精调一个模型，使其流畅。

##### 转换（Conversion）

在本例中，我们将电影名称转换为表情符号。这显示了 API 对获取模式和处理其他字符的适应性。

```
Convert movie titles into emoji.

Back to the Future: 👨👴🚗🕒 
Batman: 🤵🦇 
Transformers: 🚗🤖 
Star Wars:
```

##### 总结

API 能够掌握文本的上下文并以不同的方式重新表述。在本例中，我们从更长、更复杂的文本段落中创建了一个儿童可以理解的解释。这说明 API 对语言有很深的理解。

```
Summarize this for a second-grade student:

Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass one-thousandth that of the Sun, but two-and-a-half times that of all the other planets in the Solar System combined. Jupiter is one of the brightest objects visible to the naked eye in the night sky, and has been known to ancient civilizations since before recorded history. It is named after the Roman god Jupiter.[19] When viewed from Earth, Jupiter can be bright enough for its reflected light to cast visible shadows,[20] and is on average the third-brightest natural object in the night sky after the Moon and Venus.
```

#### 补全

虽然所有提示都会导致补全，但在您希望 API 从您停止的地方继续执行的情况下，将文本完成视为自己的任务可能会有所帮助。例如，如果给出此提示，API 将继续思考垂直农业。您可以降低温度设置以使 API 更专注于提示的意图，或者增加温度设置以让其沿切线移动。

```
Vertical farming provides a novel solution for producing food locally, reducing transportation costs and
```

下一个提示显示如何使用补全帮助编写 React 组件。我们向 API 发送了一些代码，因为它了解 React 库，所以可以继续执行剩下的代码。我们建议在涉及理解或生成代码的任务中使用 Codex 模型。要了解更多信息，请访问我们的代码指南。

```
import React from 'react';
const HeaderComponent = () => (
```

#### 事实反应

API 有很多知识是从它接受过训练的数据中学到的。它还能够提供听起来很真实但实际上是虚构的响应。有两种方法可以限制 API 给出答案的可能性。

1. **为 API 提供基本事实。**如果你向 API 提供了一系列文本来回答有关的问题（比如维基百科条目），那么它就不太可能会做出否定答复。
2. **使用低概率，向 API 展示如何说“我不知道”。**如果 API 明白，在对回答不太确定的情况下，说“我不知道”或一些变化是合适的，那么它将不太倾向于编造答案。

在这个示例中，我们给出了它知道的问题和答案的 API 示例，然后给出了它不知道的事情的示例，并提供了问号。我们还将概率设置为零，因此如果有任何疑问，API更有可能以“？”响应。

```
Q: Who is Batman?
A: Batman is a fictional comic book character.

Q: What is torsalplexity?
A: ?

Q: What is Devz9?
A: ?

Q: Who is George Lucas?
A: George Lucas is American film director and producer famous for creating Star Wars.

Q: What is the capital of California?
A: Sacramento.

Q: What orbits the Earth?
A: The Moon.

Q: Who is Fred Rickerson?
A: ?

Q: What is an atom?
A: An atom is a tiny particle that makes up everything.

Q: Who is Alvan Muntz?
A: ?

Q: What is Kozar-09?
A: ?

Q: How many moons does Mars have?
A: Two, Phobos and Deimos.

Q:
```

### 插入文本

## 图片生成

了解如何使用我们的 DALL·E 模型生成或操作图像

### 简介

Images API 提供了三种与图像交互的方法：

- 基于文本提示从头开始创建图像
- 基于新文本提示创建对现有图像的编辑
- 创建现有图像的变体

本指南介绍了使用这三个 API 端点的基础知识和有用的代码示例。要查看他们的行动，请查看我们的 DALL·E 预览应用程序。

### 使用

#### 生成

图像生成端点允许您在文本提示下创建原始图像。生成的图像大小可以为256x256、512x512 或 1024x1024 像素。更小的尺寸生成速度更快。您可以使用 n 参数一次请求 1-10 个图像。

```shell
curl https://api.openai.com/v1/images/generations \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "prompt": "a white siamese cat",
    "n": 1,
    "size": "1024x1024"
  }'
```

描述越详细，就越有可能获得您或最终用户想要的结果。您可以在 DALL·E 预览应用程序中探索示例，以获得更多启发。下面是一个快速示例：

| 提示                                                         | 生成                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| a white siamese cat                                          | ![img](https://cdn.openai.com/API/images/guides/image_generation_simple.webp) |
| a close up, studio photographic portrait of a white siamese cat that looks curious, backlit ears | ![img](https://cdn.openai.com/API/images/guides/image_generation_detailed.webp) |

使用 response_format 参数，可以将每个图像作为 URL 或 Base64 数据返回。URL 将在一小时后过期。

#### 编辑

图像编辑端点允许您通过上载遮罩来编辑和扩展图像。遮罩的透明区域指示应编辑图像的位置，提示应描述完整的新图像，而不仅仅是擦除区域。该端点可以在我们的 DALL·E 预览应用程序中实现类似编辑器的体验。

```shell
curl https://api.openai.com/v1/images/edits \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -F image='@sunlit_lounge.png' \
  -F mask='@mask.png' \
  -F prompt="A sunlit indoor lounge area with a pool containing a flamingo" \
  -F n=1 \
  -F size="1024x1024"
```

| 图片                                                         | 遮罩                                                         | 输出                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| ![img](https://cdn.openai.com/API/images/guides/image_edit_original.webp) | ![img](https://cdn.openai.com/API/images/guides/image_edit_mask.webp) | ![img](https://cdn.openai.com/API/images/guides/image_edit_output.webp) |

提示: a sunlit indoor lounge area with a pool containing a flamingo

上传的图像和遮罩必须都是大小小于 4MB 的方形 PNG 图像，并且必须具有彼此相同的尺寸。生成输出时不使用遮罩的非透明区域，因此它们不必像上面的示例那样与原始图像匹配。

#### 变体

图像变体端点允许您生成给定图像的变体。

```shell
curl https://api.openai.com/v1/images/variations \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -F image='@corgi_and_cat_paw.png' \
  -F n=1 \
  -F size="1024x1024"
```

| 图片                                                         | 输出                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| ![img](https://cdn.openai.com/API/images/guides/image_variation_original.webp) | ![img](https://cdn.openai.com/API/images/guides/image_variation_output.webp) |

与编辑端点类似，输入图像必须是大小小于 4MB 的方形 PNG 图像。

#### 内容适度

提示和图像是根据我们的内容策略过滤的，当提示或图像被标记时会返回错误。如果您对误报或相关问题有任何反馈，请通过我们的帮助中心与我们联系。

### 特定语言的提示

## 精调

了解如何为应用程序定制模型。

### 简介

通过提供以下功能，精调可以让您从 API 提供的模型中获得更多信息：

1. 比快速设计更高质量的结果
2. 能够针对比提示中所能容纳的更多示例进行训练
3. 由于提示更短而节省令牌
4. 更低的延迟请求

GPT-3 已经对来自开放互联网的大量文本进行了预训练。当给出一个只有几个例子的提示时，它通常可以直观地知道你正在尝试执行什么任务，并产生一个合理的完成。这通常被称为“少量学习”。

精调通过对比提示中更多的示例进行训练，改善了少数镜头学习，让您在大量任务中获得更好的结果。**一旦对模型进行了精调，就不再需要在提示中提供示例。**这节省了成本并实现了较低的延迟请求。

在高级别上，精调包括以下步骤：

1. 准备并上传培训数据
2. 训练新的精调模型
3. 使用您的精调模型

访问我们的定价页面，了解有关如何对精调模型训练和使用进行计费的更多信息。

### 什么模型可以被精调？

精调目前仅适用于以下基本型号：`davinci`、`curie`、`babbage` 和 `ada`。这些是原始模型，在训练后没有任何说明（例如 `text-davinci-003`）。您还可以继续精调精调模型以添加其他数据，而无需从头开始。

### 安装

我们建议使用 OpenAI 命令行界面（CLI）。要安装它，请运行：

```shell
pip install --upgrade openai
```

（以下说明适用于 **0.9.4** 及更高版本。此外，OpenAI CLI 需要 python 3。）

通过将以下行添加到 shell 初始化脚本（例如 .bashrc、zshrc 等）或在精调命令之前的命令行中运行，设置 `OPENAI_API_KEY` 环境变量：

```shell
export OPENAI_API_KEY="<OPENAI_API_KEY>"
```

### 准备训练数据

训练数据是你教 GPT-3 你想说什么的方式。

您的数据必须是 JSONL 文档，其中每一行都是与培训示例相对应的提示完成对。您可以使用我们的 CLI 数据准备工具轻松地将数据转换为此文件格式。

```json
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
...
```

设计用于精调的提示和完成与设计用于我们的基础模型（Davinci、Curie、Babbage、Ada）的提示不同。特别是，虽然基本模型的提示通常由多个示例组成（“少镜头学习”），但为了进行精调，每个训练示例通常由单个输入示例及其相关输出组成，无需给出详细说明或在同一提示中包含多个示例。

有关如何为各种任务准备培训数据的详细指导，请参阅我们准备数据集的最佳实践。

训练示例越多越好。我们建议至少有几百个例子。一般来说，我们发现数据集大小每增加一倍，模型质量就会线性增加。

#### CLI 数据准备工具

我们开发了一个工具，用于验证、提供建议并重新格式化您的数据：

```shell
openai tools fine_tunes.prepare_data -f <LOCAL_FILE>
```

该工具接受不同的格式，唯一的要求是它们包含提示和完成列/键。您可以传递一个**CSV**、**TSV**、**XLSX**、**JSON** 或 **JSONL** 文件，在指导您完成建议的更改过程后，它将把输出保存到一个 JSONL 中，以便进行精调。

### 创建一个精调模型

以下假设您已经按照上述说明准备了训练数据。

使用 OpenAI CLI 启动精调作业：

```shell
openai api fine_tunes.create -t <TRAIN_FILE_ID_OR_PATH> -m <BASE_MODEL>
```

其中 `BASE_MODEL` 是您开始使用的基础模型的名称（ada、babbage、curie 或 davinci）。您可以使用后缀参数自定义精调模型的名称。

运行上述命令可以执行以下几项操作：

1. 使用文件 API 上载文件（或使用已上载的文件）
2. 创建精调作业
3. 流式传输事件，直到作业完成（这通常需要几分钟，但如果队列中有许多作业或数据集很大，则可能需要数小时）

每个微调工作都从默认为 curie 的基本模型开始。模型的选择会影响模型的性能和运行精调模型的成本。你的模型可以是：`ada`、`babbage`、`curie` 或 `davinci`。有关精调费率的详细信息，请访问我们的定价页面。

在您开始一项精调工作后，可能需要一些时间才能完成。在我们的系统中，您的作业可能排在其他作业之后，训练我们的模型可能需要几分钟或几小时，具体取决于模型和数据集的大小。如果事件流因任何原因中断，可以通过运行以下命令恢复：

```shell
openai api fine_tunes.follow -i <YOUR_FINE_TUNE_JOB_ID>
```

作业完成后，应该显示精调模型的名称。

除了创建精调作业外，还可以列出现有作业、检索作业状态或取消作业。

```shell
# List all created fine-tunes
openai api fine_tunes.list

# Retrieve the state of a fine-tune. The resulting object includes
# job status (which can be one of pending, running, succeeded, or failed)
# and other information
openai api fine_tunes.get -i <YOUR_FINE_TUNE_JOB_ID>

# Cancel a job
openai api fine_tunes.cancel -i <YOUR_FINE_TUNE_JOB_ID>
```

### 使用精调模型



# API 参考

## 简介

您可以通过任何语言的 HTTP 请求，通过我们的官方 Python 绑定、官方 Node.js 库或社区维护的库，与 API 进行交互。

要安装官方 Python 绑定，请运行以下命令：

```shell
pip install openai
```

要安装官方 Node.js 库，请在 Node.js 项目目录中运行以下命令：

```shell
npm install openai
```

## 验证

OpenAI API 使用 API 密钥进行身份验证。访问您的 API 密钥页面以获取您将在请求中使用的 API 密钥。

请记住，您的 API 密钥是一个秘密！不要与他人共享或在任何客户端代码（浏览器、应用程序）中公开它。生产请求必须通过您自己的后端服务器路由，在那里可以从环境变量或密钥管理服务安全地加载 API 密钥。

所有 API 请求都应在授权 HTTP 标头中包含 API 密钥，如下所示：

```
Authorization: Bearer YOUR_API_KEY
```

## 请求组织

对于属于多个组织的用户，可以传递一个标头来指定用于 API 请求的组织。这些 API 请求的使用将计入指定组织的订阅配额。

curl 命令示例：

```shell
curl https://api.openai.com/v1/models \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -H 'OpenAI-Organization: YOUR_ORG_ID'
```

使用 `openai` Python 包的例子：

```python
import os
import openai
openai.organization = "YOUR_ORG_ID"
openai.api_key = os.getenv("OPENAI_API_KEY")
openai.Model.list()
```

使用 `openai` Node.js 包的例子：

```javascript
import { Configuration, OpenAIApi } from "openai";
const configuration = new Configuration({
    organization: "YOUR_ORG_ID",
    apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);
const response = await openai.listEngines();
```

可以在**组织设置**页面上找到组织 ID。

## 提出请求

您可以将下面的命令粘贴到终端中，以运行第一个 API 请求。确保用您的秘密 API 密钥替换 `YOUR_API_KEY`。

```shell
curl https://api.openai.com/v1/completions \
-H "Content-Type: application/json" \
-H "Authorization: Bearer YOUR_API_KEY" \
-d '{"model": "text-davinci-003", "prompt": "Say this is a test", "temperature": 0, "max_tokens": 7}'
```

该请求查询 Davinci 模型以补全文本，并提示“说这是一个测试”。`max_tokens` 参数设置 API 将返回多少**标记**的上限。您应该得到类似以下内容的回复：

```json
{
    "id": "cmpl-GERzeJQ4lvqPk8SkZu4XMIuR",
    "object": "text_completion",
    "created": 1586839808,
    "model": "text-davinci:003",
    "choices": [
        {
            "text": "\n\nThis is indeed a test",
            "index": 0,
            "logprobs": null,
            "finish_reason": "length"
        }
    ],
    "usage": {
        "prompt_tokens": 5,
        "completion_tokens": 7,
        "total_tokens": 12
    }
}
```

现在，您已经完成了第一次补全。如果将提示和补全文本连接起来（如果将 `echo` 参数设置为 `true`，API 将为您执行此操作），则生成的文本为“说这是测试。这确实是测试。”您还可以将参数 `stream` 设置为 `true`，以便 API 流式返回文本（作为仅数据的服务器发送的事件）。

## 模型

列出并描述 API 中可用的各种模型。您可以参考模型文档来了解可用的模型以及它们之间的差异。

### 列出模型

`GET https://api.openai.com/v1/models`

列出当前可用的型号，并提供每种型号的基本信息，如所有者和可用性。

```shell
curl https://api.openai.com/v1/models \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

```json
{
  "data": [
    {
      "id": "model-id-0",
      "object": "model",
      "owned_by": "organization-owner",
      "permission": [...]
    },
    {
      "id": "model-id-1",
      "object": "model",
      "owned_by": "organization-owner",
      "permission": [...]
    },
    {
      "id": "model-id-2",
      "object": "model",
      "owned_by": "openai",
      "permission": [...]
    },
  ],
  "object": "list"
}
```

### 获取模型

`GET https://api.openai.com/v1/models/{model}`

获取模型实例，提供有关模型的基本信息，如所有者和权限。

#### 路径参数

`model` string 必需

用于此请求的模型的ID

```shell
curl https://api.openai.com/v1/models/text-davinci-003 \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

```json
{
  "id": "text-davinci-003",
  "object": "model",
  "owned_by": "openai",
  "permission": [...]
}
```

## 补全

给出提示后，模型将返回一个或多个预测补全，并且还可以返回每个位置的替代标记的概率。

### 创建补全

`POST https://api.openai.com/v1/completions`

为提供的提示和参数创建补全

#### 请求体

`model` string 必需

要使用的模型的 ID。您可以使用**列出模型** API 查看所有可用的模型，或查看我们的**模型概述**以了解它们的描述。

---

`prompt` string 或 array 可选 默认为 <|endoftext|>

生成补全的提示，编码为字符串、字符串数组、标记数组或标记数组的数组。

请注意，`<|endoftext|>` 是模型在训练过程中看到的文档分隔符，因此如果未指定提示，则模型将从新文档的开头生成。

---

`suffix` string 可选 默认为 null

插入文本补全后出现的后缀。

---

`max_tokens` integer 可选 默认为 16

补全时要生成的最大**标记**数。

提示的令牌计数加上 `max_tokens` 不能超过模型的上下文长度。大多数型号的上下文长度为 2048 个令牌（最新型号除外，支持 4096 个）。

---

`temperature` number 可选 默认为 1

使用什么样的采样温度，介于 0 和 2 之间。较高的值（如 0.8）将使输出更加随机，而较低的值（例如 0.2）将使其更加集中和确定。

我们通常建议要么更改这个要么更改 `top_p`，但不能同时更改两者。

---

`top_p` number 可选 默认为 1

使用温度采样的另一种方法称为核采样（nucleus sampling），其中模型考虑具有 top_p 概率质量的标记的结果。因此，0.1 意味着只考虑包含最高 10% 概率质量的标记。

我们通常建议要么改变这个要么改变 `temperature`，但不能同时改变两者。

---

`n` integer 可选 默认为 1

每个提示要生成多少个补全。

**注意**：由于此参数会生成许多补全，因此它会快速消耗标记配额。小心使用并确保您对 `max_tokens` 和 `stop` 进行了合理的设置。

---

`stream` boolean 可选 默认为 false

是否流式返回部分进度。如果设置，标记将在可用时作为仅数据的**服务器发送的事件**（data-only [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format)）发送，流以 `data:[DONE]` 消息终止。

---

`logprobs` integer 可选 默认为 null

包括 `logprobs` 最可能的标记上的日志概率，以及所选标记。例如，如果 `logprobs` 为 5，则 API 将返回 5 个最可能的标记的列表。API 将始终返回 `logprob` 个采样标记，因此响应中可能有多达 `logprobs+1` 个元素。

`logprobs` 的最大值为 5。如果您需要更多信息，请通过我们的帮助中心与我们联系，并描述您的用例。

---

`echo` boolean 可选 默认为 false

除了补全之外，回显提示

---

`stop` string 或 array 可选 默认为 null

最多 4 个序列，API 将停止生成更多标记。返回的文本将不包含停止序列。

---

`presence_penalty` number 可选 默认为 0

数字介于 -2.0 和 2.0 之间。正值根据到目前为止是否出现在文本中来惩罚新标记，从而增加模型谈论新主题的可能性。

查看有关频率和在场惩罚的更多信息。

---

`frequency_penalty` number 可选 默认为 0

数字介于 -2.0 和 2.0 之间。正值根据文本中的现有频率惩罚新标记，从而降低模型逐字重复同一行的可能性。

查看有关频率和在场惩罚的更多信息。

---

`best_of` integer 可选 默认为 1

在服务器端生成 `best_of` 个补全，并返回“最佳”（在每个标记中日志概率最高的）。结果无法流式传输。

与 `n` 一起使用时，`best_of` 控制候选补全的数量，`n` 指定要返回的数量 —— `best_of` 必须大于 `n`。

**注意**：由于此参数会生成许多补全，因此它会快速消耗令牌配额。小心使用并确保您对 `max_tokens` 和 `stop` 进行了合理的设置。

---

`logit_bias` map 可选 默认为 null

修改完成时出现指定标记的可能性。

接受一个 json 对象，该对象将标记（由 GPT 标记化器中的标记 ID 指定）映射到 -100 到 100 之间的相关偏差值。您可以使用此标记化工具（适用于 GPT-2 和 GPT-3）将文本转换为标记 ID。在数学上，在采样之前，将偏差添加到模型生成的逻辑中。每个模型的确切效果会有所不同，但介于 -1 和 1 之间的值应该会降低或增加选择的可能性；像 -100 或 100 这样的值应该会导致相关标记的禁止或独占选择。

例如，可以传递 `{"50256": -100}` 以防止生成 `<|endoftext|>` 标记。

---

`user` string 可选

代表最终用户的唯一标识符，可帮助 OpenAI 监控和检测滥用。了解更多信息。



实例请求

```shell
curl https://api.openai.com/v1/completions \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -d '{
  "model": "text-davinci-003",
  "prompt": "Say this is a test",
  "max_tokens": 7,
  "temperature": 0
}'
```

参数

```json
{
  "model": "text-davinci-003",
  "prompt": "Say this is a test",
  "max_tokens": 7,
  "temperature": 0,
  "top_p": 1,
  "n": 1,
  "stream": false,
  "logprobs": null,
  "stop": "\n"
}
```

响应

```json
{
  "id": "cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7",
  "object": "text_completion",
  "created": 1589478378,
  "model": "text-davinci-003",
  "choices": [
    {
      "text": "\n\nThis is indeed a test",
      "index": 0,
      "logprobs": null,
      "finish_reason": "length"
    }
  ],
  "usage": {
    "prompt_tokens": 5,
    "completion_tokens": 7,
    "total_tokens": 12
  }
}
```

## 编辑

给定一个提示和一条指令，模型将返回该提示的编辑版本。

### 创建编辑

`POST https://api.openai.com/v1/edits`

为提供的输入、指令和参数创建新的编辑。

#### 请求体

`model` string 必需

要使用的模型的 ID。您可以将 `text-davinci-edit-001` 或 `code-davinci-edit-001` 模型用于此端点。

---

`input` string 可选 默认为 ''

要用作编辑起点的输入文本。

---

`instruction` string 必须

告诉模型如何编辑提示的指令。

---

`n` integer 可选 默认为 1

要为输入和指令生成多少编辑。

---

`temperature` number 可选 默认为 1

使用什么样的采样温度，介于 0 和 2 之间。较高的值（如 0.8）将使输出更加随机，而较低的值（例如 0.2）将使其更加集中和确定。

我们通常建议要么更改这个要么 `top_p`，但不能同时更改两者。

---

`top_p` number 可选 默认为 1

使用温度采样的另一种方法称为核采样，其中模型考虑具有 top_p 概率质量的标记的结果。因此，0.1 意味着只考虑包含最高 10% 概率质量的标记。

我们通常建议要么改变这个要么 `temperature`，但不能同时改变两者。



示例请求

```shell
curl https://api.openai.com/v1/edits \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -d '{
  "model": "text-davinci-edit-001",
  "input": "What day of the wek is it?",
  "instruction": "Fix the spelling mistakes"
}'
```

参数

```json
{
  "model": "text-davinci-edit-001",
  "input": "What day of the wek is it?",
  "instruction": "Fix the spelling mistakes",
}
```

响应

```json
{
  "object": "edit",
  "created": 1589478378,
  "choices": [
    {
      "text": "What day of the week is it?",
      "index": 0,
    }
  ],
  "usage": {
    "prompt_tokens": 25,
    "completion_tokens": 32,
    "total_tokens": 57
  }
}
```

