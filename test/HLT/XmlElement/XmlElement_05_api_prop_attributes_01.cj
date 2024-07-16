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
        @Assert(xmlelement.attributes.size, 0)
        xmlelement.attributes = attrs
        @Assert(xmlelement.attributes[0].toString(), XmlAttr1.toString())
        @Assert(xmlelement.attributes[1].toString(), XmlAttr2.toString())
        @Assert(xmlelement.attributes[2].toString(), XmlAttr3.toString())
        @Assert(xmlelement.attributes.size, 3)
    }
}
