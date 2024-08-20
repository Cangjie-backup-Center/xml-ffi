// 3rd_party_lib:xml-ffi/target/release/xml_ffi
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml_ffi
import xml_ffi.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var saxxml = A()
        var xmlparser = XmlParser(saxxml)
        var str = "<message size=\"128\">starting</message>"
        xmlparser.parse(str)
        @Assert(saxxml.m, 1)
        @Assert(saxxml.n, 1)
        @Assert(saxxml.g, 1)
        @Assert(saxxml.h, 1)
        @Assert(saxxml.k, 1)
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
