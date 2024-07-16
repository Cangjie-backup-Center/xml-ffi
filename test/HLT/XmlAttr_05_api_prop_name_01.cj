// 3rd_party_lib:xml-ffi/target/release/xml4cj
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml4cj
import xml4cj.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01():Unit{ 
        var xmlattr = XmlAttr("name", "content")
        @Assert(xmlattr.name, "name")
        xmlattr.name = "shanghai"
        @Assert(xmlattr.name, "shanghai")
        @Assert(xmlattr.toString(), "shanghai=\"content\"")

    }
}