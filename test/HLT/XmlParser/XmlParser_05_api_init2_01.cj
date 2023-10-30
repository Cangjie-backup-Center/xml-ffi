// 3rd_party_lib:xml4cj/build/xml4cj
//3rd_party_lib_ohos:xml4cj\build\aarch64-linux-ohos\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var a = 0
        try{
            XmlParser(A())
        }catch (e:XmlException) {
            a++
        }
        
        @Assert(a, 0)
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
