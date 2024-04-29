// 3rd_party_lib:xml4cj/target/release/xml4cj
//3rd_party_lib_ohos:xml4cj\target\aarch64-linux-ohos\release\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var str = ##"<message><title lenth='256'>内容</message></title>"##
        var xmlelement = XmlElement("bark1", str)
        @Assert(xmlelement.toString(), "<bark1>" + #"<message><title lenth='256'>内容</message></title>"# + "</bark1>")
        var xmlstrExp = "<bark1>" + #"<message><title lenth='256'>内容</message></title>"# + "</bark1>"
        @Assert(xmlelement.toXmlString(), xmlstrExp)
    }
}
