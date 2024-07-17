// 3rd_party_lib:xml-ffi/target/release/xml4cj
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml4cj
import xml4cj.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var str = ##"<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>"##
        var xmlelement = XmlElement(str, str)
        @Assert(xmlelement.toString(),##"<<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>><message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message></<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>>"##)
        @Assert(xmlelement.toXmlString(),##"<<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>><message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message></<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>>"##)
    }
}
