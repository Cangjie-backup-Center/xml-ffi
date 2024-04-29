// 3rd_party_lib:xml4cj/target/release/xml4cj
//3rd_party_lib_ohos:xml4cj\target\aarch64-linux-ohos\release\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlelement = XmlElement("bark1", "")
        @Assert(xmlelement.toString(), "<bark1></bark1>")
        @Assert(xmlelement.toXmlString(), "<bark1></bark1>")
    }
}
