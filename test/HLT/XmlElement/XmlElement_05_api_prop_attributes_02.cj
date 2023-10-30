// 3rd_party_lib:xml4cj/build/xml4cj
//3rd_party_lib_ohos:xml4cj\build\aarch64-linux-ohos\xml4cj
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
        var attrsOrigin = xmlelement.attributes
        @Assert(attrsOrigin.size, 1)
        var XmlAttr1 = XmlAttr("color", "red")
        var XmlAttr2 = XmlAttr("length", "18")
        var XmlAttr3 = XmlAttr("size", "256")
        var attrsAfter = ArrayList<XmlAttr>([XmlAttr1, XmlAttr2, XmlAttr3])
        xmlelement.attributes = attrsAfter
        @Assert(xmlelement.attributes[0].toString(), XmlAttr1.toString())
        @Assert(xmlelement.attributes[1].toString(), XmlAttr2.toString())
        @Assert(xmlelement.attributes[2].toString(), XmlAttr3.toString())
        @Assert(xmlelement.attributes.size, 3)
    }
}
