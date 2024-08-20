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
            ##"<?xml version="1.0" encoding="utf-8"?><showList color="blue"><message>starting</message><movie><name>Rain</name><date>2020-01-02</date></movie><file color="blue2" size="180"><name>Rain2</name><date>2020-01-03</date></file><!-- This is a comment --><message>if salary &lt; 1000 then</message><message>ending</message></showList>"##
        var xmlparser = XmlParser()
        var xmlelement = xmlparser.parse(str).getOrThrow()
        @Assert(xmlelement.isClosed, true)
    }
}
