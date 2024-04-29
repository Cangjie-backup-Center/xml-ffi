// 3rd_party_lib:xml4cj/target/release/xml4cj
//3rd_party_lib_ohos:xml4cj\target\aarch64-linux-ohos\release\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var saxxml = A()
        var xmlparser = XmlParser(saxxml)
        var str1 = ##"<message>if 100 ' 1000</message>"##
        var str2 = ##"<message>if 100 " 1000</message>"##
        var str3 = ##"<message>if 100 < 1000</message>"##
        var str4 = ##"<message>if 100 > 1000</message>"##
        var str5 = ##"<message>if 100 & 1000</message>"##
        xmlparser.parse(str1)
        xmlparser.parse(str2)
        xmlparser.parse(str3)
        xmlparser.parse(str4)
        xmlparser.parse(str5)
        @Assert(saxxml.m, 77)
    }
}

class A <: SaxHandler {
    public var m = 0
    public func startDocument(): Unit {
        m += 1
    }
    public func endDocument(): Unit {
        m += 2
    }
    public func startElement(_: String, _: ArrayList<XmlAttr>): Unit {
        m += 3
    }
    public func endElement(_: String): Unit {
        m += 4
    }
    public func characters(_: String): Unit {
        m += 5
    }
}
