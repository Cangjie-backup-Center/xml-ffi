// 3rd_party_lib:xml4cj/build/xml4cj
//3rd_party_lib_ohos:xml4cj\build\aarch64-linux-ohos\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

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
