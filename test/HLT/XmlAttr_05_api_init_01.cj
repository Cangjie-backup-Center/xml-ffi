// 3rd_party_lib:xml-ffi/target/release/xml4cj
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml4cj
import xml4cj.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var str =
            ##"< me中文ssa ge> st 开始ar~！~@@# ￥ %······&*（）————+-=·{}【】;:“,。《》ting </message >"##
        var xmlattr = XmlAttr(str, str)
        @Assert(xmlattr.toString(), "${str}=\"${str}\"")
    }
}
