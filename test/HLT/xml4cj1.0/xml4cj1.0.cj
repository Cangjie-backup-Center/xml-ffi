// 3rd_party_lib:xml-ffi/target/release/xml4cj
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml4cj
import xml4cj.*
import std.unittest.*
import std.collection.*

//包含有标签
@Test
public class xml4cjparserTest {
    @TestCase
    func testxml_01(): Unit {
        var str =
            ##"<?xml version="1.0" encoding="UTF-8"?>
<site>
  <name>RUNOOB</name>
  <url>https:111111</url>
  <logo>runoob-logo.png</logo>
  <desc>仓颉</desc>
</site>"##
        var xmlparser = XmlParser()
        var xmlelement = xmlparser.parse(str).getOrThrow()
        var attrs = xmlelement.childrenElements
        @Assert(xmlelement.childrenNum,4)
        @Assert(attrs[0].toString(), "<name>RUNOOB</name>")
        @Assert(attrs[1].toString(), "<url>https:111111</url>")
        @Assert(attrs[2].toString(), "<logo>runoob-logo.png</logo>")
        @Assert(attrs[3].toString(), "<desc>仓颉</desc>")
    }

    //具有文档类型声明的 XML 文档
    @TestCase
    func testxml_02(): Unit {
        var str = ##"<?xml version="1.0"?>
<!DOCTYPE greeting SYSTEM "hello.dtd">
<greeting>Hello, world!</greeting> "##
        var xmlparser = XmlParser()
        var xmlelement = xmlparser.parse(str).getOrThrow()
        @Assert(xmlelement.childrenNum,0)
        @Assert(xmlelement.name, "greeting")
    }

    //属性值必须加引号
    @TestCase
    func testxml_03(): Unit {
        var str =
            ##"<?xml version="1.0" encoding="UTF-8"?>
<note date="12/11/2007">
<to>Tove</to>
<from>Jani</from>
</note> "##
        var xmlparser = XmlParser()
        var xmlelement = xmlparser.parse(str).getOrThrow()
        @Assert(xmlelement.childrenNum,2)
        @Assert(xmlelement.name, "note")
    }

    //对大小写敏感
    @TestCase
    func testxml_04(): Unit {
        var str =
            ##"<?xml version="1.0" encoding="UTF-8"?>
<site>
  <name>RUNOOB</name>
  <Name>https:111111</Name>
</site>"##
        var xmlparser = XmlParser()
        var xmlelement = xmlparser.parse(str).getOrThrow()
        var attrs = xmlelement.childrenElements
        @Assert(attrs[0].toString(), "<name>RUNOOB</name>")
        @Assert(attrs[1].toString(), "<Name>https:111111</Name>")
    }

    //空元素
    @TestCase
    func testxml_05(): Unit {
        var str =
            ##"<?xml version="1.0" encoding="UTF-8"?>
<site>
  <name> </name>
  <Name>https:111111</Name>
</site>"##
        var xmlparser = XmlParser()
        var xmlelement = xmlparser.parse(str).getOrThrow()
        var attrs = xmlelement.childrenElements
        @Assert(attrs[0].toString(), "<name> </name>")
        @Assert(attrs[1].toString(), "<Name>https:111111</Name>")
    }

    @TestCase
    func testxml_06(): Unit {
        var str =
            ##"<?xml version="1.0" encoding="utf-8"?><showList color="blue"><message>starting</message><movie><name>Rain</name><date>2020-01-02</date></movie><file color="blue2" size="180"><name>Rain2</name><date>2020-01-03</date></file><!-- This is a comment --><message>if salary &lt; 1000 then</message><message>ending</message></showList>"##
        var xmlparser = XmlParser()
        var xmlelement = xmlparser.parse(str).getOrThrow()
        var attrs = xmlelement.attributes
        @Assert(attrs.size, 1)
        attrs[0].content = "shanghai"
        @Assert(attrs[0].content, "shanghai")
        @Assert(attrs[0].toString(), #"color="shanghai""#)
    }

    @TestCase
    func testxml_07(): Unit {
        var saxxml = A()
        var xmlparser = XmlParser(saxxml)
        var str =
            ##"<?xml version="1.0" encoding="utf-8"?><showList color="blue"><message>starting</message><movie><name>Rain</name><date>2020-01-02</date></movie><file color="blue2" size="180"><name>Rain2</name><date>2020-01-03</date></file><!-- This is a comment --><message>if salary &lt; 1000 then</message><message>ending</message></showList>"##
        xmlparser.parse(str)
        var a = 0
        if (saxxml.m != 1 || saxxml.n != 1 || saxxml.g != 10 || saxxml.h != 10 || saxxml.k != 9) {
            a = a + 1
        }
        @Assert(a, 0)
    }

    @TestCase
    func testxml_09(): Unit {
        var saxxml = A()
        var xmlparser = XmlParser(saxxml)
        var str = ##"<?xml version="1.0"?>
<!DOCTYPE greeting SYSTEM "hello.dtd">
<greeting>Hello, world!</greeting> "##
        xmlparser.parse(str)
        var a = 0
        if (saxxml.m != 1 || saxxml.n != 1 || saxxml.g != 1 || saxxml.h != 1 || saxxml.k != 1) {
            a = a + 1
        }
        @Assert(a, 0)
    }

    @TestCase
    func testxml_10(): Unit {
        var saxxml = A()
        var xmlparser = XmlParser(saxxml)
        var str =
            ##"<?xml version="1.0" encoding="UTF-8"?>
<note date="12/11/2007">
<to>Tove</to>
<from>Jani</from>
</note> "##
        xmlparser.parse(str)
        var a = 0
        if (saxxml.m != 1 || saxxml.n != 1 || saxxml.g != 3 || saxxml.h != 3 || saxxml.k != 5) {
            a = a + 1
        }
        @Assert(a, 0)
    }

    @TestCase
    func testxml_11(): Unit {
        var saxxml = A()
        var xmlparser = XmlParser(saxxml)
        var str =
            ##"<?xml version="1.0" encoding="UTF-8"?>
<site>
  <name> </name>
  <Name>https:111111</Name>
</site>"##
        xmlparser.parse(str)
        var a = 0
        if (saxxml.m != 1 || saxxml.n != 1 || saxxml.g != 3 || saxxml.h != 3 || saxxml.k != 5) {
            a = a + 1
        }
        @Assert(a, 0)
    }
}

class A <: SaxHandler {
    public var m = 0
    public var n = 0
    public var g = 0
    public var h = 0
    public var k = 0
    public func startDocument(): Unit {
        m += 1
    }
    public func endDocument(): Unit {
        n += 1
    }
    public func startElement(_: String, _: ArrayList<XmlAttr>): Unit {
        g += 1
    }
    public func endElement(_: String): Unit {
        h += 1
    }
    public func characters(_: String): Unit {
        k += 1
    }
}
