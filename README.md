<div align="center">
<h1>xml4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.39.7-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-87.5%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

一个标准的 XML 文本处理的工具。    
参考地址: https://github.com/GNOME/libxml2 版本2.9.14

### 特性

- 🚀 支持Xml DOM 解析模式

- 🚀 支持Xml SAX 解析模式


## 软件架构

### 架构图

<p align="center">
<img src="./doc/assets/readme_framework.png" width="60%" >
</p>

### 源码目录

```shell
.
├── README.md
├── doc
│   ├── assets
│   └── feature_api.md
├── lib
├── src
│   ├── native.cj  
│   └── XmlParser.cj    
│       
└── test
    ├── HLT
    ├── LLT
    └── UT
```

- `doc` 文档目录，用于存API接口文档
- `src` 是库源码目录
- `test` 存放 HLT 测试用例、LLT 自测用例

### 接口说明

主要是核心类和成员函数说明,详情见 [API](./doc/feature_api.md)

## <img alt="" src="./doc/assets/readme-icon-compile.png" style="display: inline-block;" width=3%/> 使用说明

### 编译

1. 本项目编译运行方式

-  引入 testJekins 包

    ```
    git clone https://gitee.com/HW-PLLab/testJekins
    ```

    将 src 下 ci_test 放入 xml4cj 根目录下,执行：

    ```
    cjpm clean
    cjpm update
    python3 ci_test/main.py build    ---> 编译
    python3 ci_test/main.py test     ---> 执行 test/LLT 用例
    ```
    test/LLT 用例书写参考：https://gitee.com/HW-PLLab/cangjie-library-pages/wikis 的门禁测试脚本使用方式

- 重复本项目编译运行方式的第二步

### Xml BOM 解析模式功能示例

```cangjie

from libxml4cj import libxml4cj.*

main() {
    let x: XmlParser = XmlParser()

    var ret = x.parse("<myxml>Some data </myxml>")
    match (ret) {
        case Some(root) => println(root.name)
        case None => println("XML Parse error.")
    }
    return 0
}
```

执行结果如下：

```shell
myxml
```

### Xml SAX 解析模式功能示例

```cangjie

from libxml4cj import libxml4cj.*

let latestMovie = """
<collection shelf="New Arrivals">
<movie title="Movie 2021">
   <score>7.4</score>
   <year>2021-3</year>
   <description>This is a virtual film released in 2021 for testing.</description>
</movie>
<movie title="Movie 2022">
   <type>Anime, Science Fiction</type>
   <score>7</score>
   <year>2022-2</year>
   <description>This is a virtual film released in 2022 for testing.</description>
</movie>
<movie title="Movie 2023">
   <score>6.5</score>
   <year>2023-4</year>
   <description>This is a virtual film released in 2023 for testing.</description>
</movie>
</collection>
"""
class MovieHandler <: SaxHandler {
    private var curTag: String
    private var title: String
    private var score: String
    private var year: String

    init() {
        curTag = ""
        title = ""
        score = ""
        year = ""
    }

    public func startDocument(): Unit {
        println("Start Parsing.")
    }
    public func endDocument(): Unit {
        println("End Parsing.")
    }
    public func startElement(name: String, attrs: ArrayList<XmlAttr>): Unit {
        curTag = name
        if (name == "movie") {
            title = attrs[0].content
            println("Title: ${title}")
        }
    }
    public func endElement(name: String): Unit {
        if (curTag == "score") {
            println("Score: ${score}")
        } else if (curTag == "year") {
            println("Year: ${year}")
        }
    }
    public func characters(content: String): Unit {
        if (curTag == "score") {
            score = content
        } else if (curTag == "year") {
            year = content
        }
    }
}
main() {
    var handler = MovieHandler()
    let x: XmlParser = XmlParser(handler)

    x.parse(latestMovie)
    return 0
}
```

执行结果如下：

```shell
Start Parsing.
Title: Movie 2021
Score: 7.4
Year: 2021-3
Title: Movie 2022
Score: 7
Year: 2022-2
Title: Movie 2023
Score: 6.5
Year: 2024-4
End Parsing.
```

## <img alt="" src="./doc/assets/readme-icon-contribute.png" style="display: inline-block;" width=3%/> 参与贡献

欢迎给我们提交 PR，欢迎给我们提交 issue，欢迎参与任何形式的贡献。