// 3rd_party_lib:xml4cj/target/release/xml4cj
//3rd_party_lib_ohos:xml4cj\target\aarch64-linux-ohos\release\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var str =
            ##"<?xml version="1.0" encoding="utf-8"?><showList color="blue"><message>starting</message><movie><name>Rain</name><date>2020-01-02</date></movie><file color="blue2" size="180"><name>Rain2</name><date>2020-01-03</date></file><!-- This is a comment --><message>if salary &lt; 1000 then</message><message>ending</message></showList>"##
        var xmlparser = XmlParser()
        var xmlelement = xmlparser.parse(str).getOrThrow()
        var xmlelement2 = XmlElement("name", "content")
        var xmlelement3 = XmlElement("name", "content")
        var xmlelement4 = XmlElement("name", "content")
        var elements = ArrayList<XmlElement>([xmlelement2, xmlelement3, xmlelement4])
        @Assert(xmlelement.childrenElements.size, 5)
        xmlelement.childrenElements = elements
        @Assert(xmlelement.childrenElements[0].toString(), xmlelement2.toString())
        @Assert(xmlelement.childrenElements[1].toString(), xmlelement3.toString())
        @Assert(xmlelement.childrenElements[2].toString(), xmlelement4.toString())
        @Assert(xmlelement.childrenElements.size, 3)
        @Assert(xmlelement.toString(), "<showList color=\"blue\"><name>content</name><name>content</name><name>content</name></showList>")
        var xmlstrExp =
            #"<showList color="blue">
    <name>content</name>
    <name>content</name>
    <name>content</name>
</showList>"#
        @Assert(xmlelement.toXmlString(), xmlstrExp)
    }
}
