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
        var str = """
        <movie>
            <name>Rain</name>
            <date>2020-01-02</date>
            <file color="blue2" size="180">
                <name>Rain2</name>
                <date>2020-01-03</date>
            </movie></file>
        """
        try {
            xmlparser.parse(str)
        } catch (e: XmlException) {
            @Assert(e.toString().contains("XML text syntax error"), true)
        }
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
