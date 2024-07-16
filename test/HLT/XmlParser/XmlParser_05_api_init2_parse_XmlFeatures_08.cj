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
        var str1 = ##"<message>starting</message>"##
        var str2 = ##"< message>starting</message>"##
        var str3 = ##"<message >starting</message>"##
        var str4 = ##"<message>starting< /message>"##
        var str5 = ##"<message>starting</ message>"##
        var str6 = ##"<message>starting</message >"##
        var Flag1 = 0
        var Flag2 = 0
        var Flag3 = 0
        var Flag4 = 0
        var Flag5 = 0
        var Flag6 = 0
        try {
            xmlparser.parse(str1)
        } catch (e: XmlException) {
            Flag1 += 1
        }

        try {
            xmlparser.parse(str2)
        } catch (e: XmlException) {
            Flag2 += 1
        }

        try {
            xmlparser.parse(str3)
        } catch (e: XmlException) {
            Flag3 += 1
        }

        try {
            xmlparser.parse(str4)
        } catch (e: XmlException) {
            Flag4 += 1
        }

        try {
            xmlparser.parse(str5)
        } catch (e: XmlException) {
            Flag5 += 1
        }

        try {
            xmlparser.parse(str6)
        } catch (e: XmlException) {
            Flag6 += 1
        }

        var a = 0
        if (Flag1 != 0 || Flag2 != 0 || Flag3 != 0 || Flag4 != 0 || Flag5 != 0 || Flag6 != 0) {
            a = a + 1
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
