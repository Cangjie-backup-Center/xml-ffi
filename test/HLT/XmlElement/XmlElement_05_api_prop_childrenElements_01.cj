// 3rd_party_lib:xml-ffi/target/release/xml_ffi
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml_ffi
import xml_ffi.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlelement1 = XmlElement("name", "content")
        var xmlelement2 = XmlElement("name", "content")
        var xmlelement3 = XmlElement("name", "content")
        var xmlelement4 = XmlElement("name", "content")
        var elements = ArrayList<XmlElement>([xmlelement2, xmlelement3, xmlelement4])
        @Assert(xmlelement1.childrenElements.size, 0)
        xmlelement1.childrenElements = elements
        @Assert(xmlelement1.childrenElements[0].toString(), xmlelement2.toString())
        @Assert(xmlelement1.childrenElements[1].toString(), xmlelement3.toString())
        @Assert(xmlelement1.childrenElements[2].toString(), xmlelement4.toString())
        @Assert(xmlelement1.toString(), "<name>content<name>content</name><name>content</name><name>content</name></name>")
    }
}
