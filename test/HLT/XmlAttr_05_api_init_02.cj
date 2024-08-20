// 3rd_party_lib:xml-ffi/target/release/xml_ffi
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml_ffi
import xml_ffi.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01():Unit{ 
        var str = ##"<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>"##
        var xmlattr = XmlAttr(str, str)
        @Assert(xmlattr.toString(), "${str}=\"${str}\"")
    }
}