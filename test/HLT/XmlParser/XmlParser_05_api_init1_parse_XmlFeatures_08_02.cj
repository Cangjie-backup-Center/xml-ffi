// 3rd_party_lib:xml-ffi/target/release/xml4cj
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml4cj
import xml4cj.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlparser = XmlParser()
        var str = ##"<message>star ting</message>"##
        var xmlelement = xmlparser.parse(str).getOrThrow()
        @Assert(xmlelement.content, "star ting")
        @Assert(xmlelement.toString(), ##"<message>star ting</message>"##)
        @Assert(xmlelement.toXmlString(), ##"<message>star ting</message>"##)
    }
}
