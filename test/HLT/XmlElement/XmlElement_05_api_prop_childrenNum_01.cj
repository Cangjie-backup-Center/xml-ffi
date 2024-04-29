// 3rd_party_lib:xml4cj/target/release/xml4cj
//3rd_party_lib_ohos:xml4cj\target\aarch64-linux-ohos\release\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlelement1 = XmlElement("name", "content")
        var xmlelement2 = XmlElement("name", "content")
        var xmlelement3 = XmlElement("name", "content")
        var xmlelement4 = XmlElement("name", "content")
        var elements = ArrayList<XmlElement>([xmlelement2, xmlelement3, xmlelement4])
        @Assert(xmlelement1.childrenNum, 0)
        xmlelement1.childrenElements = elements
        @Assert(xmlelement1.childrenNum, 3)
    }
}
