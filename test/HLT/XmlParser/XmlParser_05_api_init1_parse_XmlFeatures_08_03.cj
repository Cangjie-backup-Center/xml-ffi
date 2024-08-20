// 3rd_party_lib:xml-ffi/target/release/xml_ffi
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml_ffi
import xml_ffi.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlparser = XmlParser()
        var str = ##"<message>starting </message>"##
        var xmlelement = xmlparser.parse(str).getOrThrow()
        @Assert(xmlelement.content, "starting ")
        @Assert(xmlelement.toString(), ##"<message>starting </message>"##)
        @Assert(xmlelement.toXmlString(), ##"<message>starting </message>"##)
    }
}
