// 3rd_party_lib:xml-ffi/target/release/xml_ffi
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml_ffi
import xml_ffi.*
import std.unittest.*
import std.collection.*

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