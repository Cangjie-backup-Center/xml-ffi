// 3rd_party_lib:xml-ffi/target/release/xml4cj
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml4cj
import xml4cj.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlelement = XmlElement("name", "content")
        var XmlAttr1 = XmlAttr("color", "red")
        var XmlAttr2 = XmlAttr("length", "18")
        var XmlAttr3 = XmlAttr("size", "256")
        var attrs = ArrayList<XmlAttr>([XmlAttr1, XmlAttr2, XmlAttr3])
        xmlelement.attributes = attrs
        @Assert(xmlelement.attributesNum, 3)
    }
}
