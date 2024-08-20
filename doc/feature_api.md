## xml_ffi 库

### 介绍
该库提供基于标准的 XML 文本处理,目前支持两种模式：文档对象模型（DOM）模式和 XML 简单 API（SAX）模式，暂不支持外部实体功能

### 1 支持Xml DOM 模式使用

前置条件：NA
场景：
根据基于标准的 XML 文本处理
约束：NA 
性能： 支持版本几何性能持平
可靠性： NA

#### 1.1 主要接口

供 XML 解析功能
class XmlParser

```cangjie

    /**
    * 默认无参构造函数,创建 XML 文档对象模型（DOM）模式解析器
    * 
    */
    public init()

    /**
    * 解析字符串类型的 XML 文本
    *
    * @param text - 传入的XML文本,文本节点名称不支持'#'、'？'
    * @exception 传入的XML文本,文本节点名称'<'、'\0'，文本长度大于UInt32最大值，抛出异常XmlException
    * @return - DOM模式下解析成功则返回 Option<XmlElement>.Some(element),失败则返回 Option<XmlElement>.None
    */
    public func parse(str: String): Option<XmlElement>

```

存储 XML 元素节点属性，并提供查询其内容的函数
class XmlAttr

```cangjie

    /**
    * 默认无参构造函数,创建新的 XmlAttr 对象
    * 
    * @param name - 属性名称，如果名称为空会抛异常
    * @exception 传入的name，不能为空，首字母不能是（'-'、'.'、'\u{00B7}'），首字母不能是数字(0-9)，抛出异常XmlException
    * @param content - 属性值
    */
    public init(name: String, content: String)

    /*
     * 获取或设置属性名称，设置名称时，如果名称为空会抛异常
    */
    public mut prop name: String

    /*
     * 获取或设置属性值,当名称为空会抛异常
    */
    public mut prop content: String

    /**
    * 将 XmlAttr 转换成字符串
    *   
    * @return 转换后的字符串
    */
    public func toString(): String

```

存储 XML 元素节点，并提供查询其内容的函数
class XmlElement

```cangjie

    /**
    * 默认无参构造函数,创建新的 XmlElement 对象
    * 
    * @param name - 节点名称，如果名称为空,会抛异常
    * @exception 传入的name，不能为空，首字母不能是（'-'、'.'、'\u{00B7}'），首字母不能是数字(0-9)，抛出异常XmlException
    * @param content - 节点文本内容
    */
    public init(name: String, content: String)

    /**
    * 获取或设置节点名称，设置名称时，如果名称为空,会抛异常
    */
    public mut prop name: String

    /**
    * 获取或设置节点文本内容,当名称为空会抛异常
    */
    public mut prop content: String

    /**
    * 获取节点是否闭合
    */
    public prop isClosed: Bool

    /**
    * 获取节点的子节点个数
    */
    public prop childrenNum: Int64

    /**
    * 获取或设置节点所有子节点
    */
    public mut prop childrenElements: ArrayList<XmlElement>

    /**
    * 获取节点属性个数
    */
    public prop attributesNum: Int64

    /**
    * 获取节点的属性，返回节点属性列表
    */
    public mut prop attributes: ArrayList<XmlAttr>

    /**
    * 将返回 XML 字符串，该字符串会在一行显示，其中的实体引用将会被解析
    *   
    * @return 解析后的字符串
    */
    public func toString(): String

    /**
    * 返回格式化后的 XML 字符串，该字符串会以 XML 的格式体现，
    *   
    * @return 解析并且格式化后的字符串
    */
    public func toXmlString(): String

```

XML 异常类
class XmlException

```cangjie

    /**
    * 默认无参构造函数
    * 
    */
    public init()

    /**
    * 创建XmlElement 对象
    * 
    * @param messages - 异常内容
    * 
    */
    public init(messages: String)

    /**
    * 获取异常内容
    * 
    * @return 异常内容
    * 
    */
    public func getMessage(): String 
    
    /**
    * 获取异常信息字符串
    * 
    * @return 异常信息字符串
    * 
    */
    public func toString(): String 

```

#### 1.2 示例

```cangjie
import xml_ffi.*

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

执行结果如下:

```shell
myxml
```

### 2 支持Xml SAX 解析模式

前置条件：NA
场景：
通过SAX 解析模式处理xml。
约束：NA 
性能： 支持版本几何性能持平
可靠性： NA

#### 2.1 主要接口

供 XML 解析功能
class XmlParser

```cangjie

    /**
    * 默认无参构造函数,创建 XML 文档对象模型（SAX）模式解析器
    * 
    * @param handler - 实现了 SaxHandler 的一组回调函数
    * 
    */
    public init(handler: SaxHandler)

    /**
    * 解析字符串类型的 XML 文本
    *
    * @param text - 传入的XML文本，文本内容不支持'&'
    *
    * @return - SAX模式下返回 Option<XmlElement>.None
    */
    public func parse(str: String): Option<XmlElement>

```

提供 SAX 模式的回调函数接口
interface SaxHandler

```cangjie

    /**
    *
    * 开始解析 XML 文本时执行的回调函数
    *
    */
    func startDocument(): Unit

    /**
    *
    * 结束解析 XML 文本时执行的回调函数
    *
    */
    func endDocument(): Unit

    /**
    * 开始解析 XML 元素时执行的回调函数
    *
    * @param name - 元素名称
    * @param attrs - 元素属性列表
    *
    */
    func startElement(name: String, attrs: ArrayList<XmlAttr>): Unit

    /**
    * 结束解析 XML 元素时执行的回调函数
    *
    * @param name - 元素名称
    *
    */
    func endElement(name: String): Unit

    /**
    * 解析得到 XML 字符数据时执行的回调函数
    *
    * @param content - 元素文本内容
    *
    */
    func characters(content: String): Unit

```

#### 2.2 示例

```cangjie
import xml_ffi.*
from std import collection.*

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
