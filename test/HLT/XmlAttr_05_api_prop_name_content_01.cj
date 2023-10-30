// 3rd_party_lib:xml4cj/build/xml4cj
//3rd_party_lib_ohos:xml4cj\build\aarch64-linux-ohos\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01():Unit{ 
        var xmlattr = XmlAttr("name", "content")
        @Assert(xmlattr.name, "name")
        @Assert(xmlattr.content, "content")
        xmlattr.name = "shanghai"
        xmlattr.content = "shanghai"
        @Assert(xmlattr.name, "shanghai")
        @Assert(xmlattr.content, "shanghai")
        @Assert(xmlattr.toString(), "shanghai=\"shanghai\"")
    }
}