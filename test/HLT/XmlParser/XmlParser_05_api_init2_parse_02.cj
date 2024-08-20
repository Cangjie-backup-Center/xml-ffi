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
        var str =
            ##"<?xml version="1.0" encoding="utf-8"?><showList color="blue"><message>starting</message><movie><name>Rain</name><date>2020-01-02</date></movie><file color="blue2" size="180"><name>Rain2</name><date>2020-01-03</date></file><!-- This is a comment --><message>if salary &lt; 1000 then</message><message>ending</message></showList>"##
        xmlparser.parse(str)
        var a = 0
        if (saxxml.m != 1 || saxxml.n != 1 || saxxml.g != 10 || saxxml.h != 10 || saxxml.k != 9) {
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
