// 3rd_party_lib:xml-ffi/target/release/xml4cj
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml4cj
import xml4cj.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var saxxml = A()
        var xmlparser = XmlParser(saxxml)
        var str = ##"<message>star<ting</message>"##
        var a = 1
        try {
            xmlparser.parse(str).getOrThrow()
        } catch (e: NoneValueException) {
            if (saxxml.m != 1 || saxxml.n != 0 || saxxml.g != 1 || saxxml.h != 0 || saxxml.k != 1) {
                a = a + 1
            }
            if (e.toString().contains("XML text syntax error")) {
                @Assert(a, 0)
            }
        }
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
