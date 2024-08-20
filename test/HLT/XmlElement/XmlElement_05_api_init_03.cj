// 3rd_party_lib:xml-ffi/target/release/xml_ffi
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml_ffi
import xml_ffi.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlelement = XmlElement("dog1", "bark1")
        @Assert(xmlelement.toString(), "<dog1>bark1</dog1>")
        @Assert(xmlelement.toXmlString(), "<dog1>bark1</dog1>")
    }
}
