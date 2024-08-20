// 3rd_party_lib:xml-ffi/target/release/xml_ffi
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml_ffi
import xml_ffi.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var str =
            ##"< me中文ssa ge> st 开始ar~!~@@# ￥ %······&*（）————+-=·{}【】;":“,。《》ting </message >"##
        var xmlelement = XmlElement(str, str)
        let sc = 
            ##"<< me中文ssa ge> st 开始ar~!~@@# ￥ %······&*（）————+-=·{}【】;":“,。《》ting </message >>< me中文ssa ge> st 开始ar~!~@@# ￥ %······&*（）————+-=·{}【】;":“,。《》ting </message ></< me中文ssa ge> st 开始ar~!~@@# ￥ %······&*（）————+-=·{}【】;":“,。《》ting </message >>"##
        @Assert(xmlelement.toString(),sc)
        let sc1 = 
            ##"<< me中文ssa ge> st 开始ar~!~@@# ￥ %······&*（）————+-=·{}【】;":“,。《》ting </message >>< me中文ssa ge> st 开始ar~!~@@# ￥ %······&*（）————+-=·{}【】;":“,。《》ting </message ></< me中文ssa ge> st 开始ar~!~@@# ￥ %······&*（）————+-=·{}【】;":“,。《》ting </message >>"##
        @Assert(xmlelement.toXmlString(), sc1)
    }
}
