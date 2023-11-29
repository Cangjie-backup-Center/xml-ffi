// 3rd_party_lib:xml4cj/build/xml4cj
//3rd_party_lib_ohos:xml4cj\build\aarch64-linux-ohos\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlparser = XmlParser()
        var str = """
<?xml version="1.0" encoding="utf-8"?>
<message>starting</message>
"""
        try {
            xmlparser.parse(str).getOrThrow()
        } catch (e: XmlException) {
            @Assert(e.toString(), "XML text syntax error")
        }
    }
}
