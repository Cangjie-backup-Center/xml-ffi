// 3rd_party_lib:xml4cj/target/release/xml4cj
//3rd_party_lib_ohos:xml4cj\target\aarch64-linux-ohos\release\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlparser = XmlParser()
        var str = ##"<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>"##
        var xmlelement = xmlparser.parse(str).getOrThrow()
        @Assert(xmlelement.name, "message")
        var contentExp = ##"star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g"##
        @Assert(xmlelement.content, contentExp)
        @Assert(xmlelement.isClosed, true)
        @Assert(xmlelement.childrenNum, 0)
        @Assert(xmlelement.childrenElements.size, 0)
        @Assert(xmlelement.attributesNum, 0)
        @Assert(xmlelement.attributes.size, 0)
        var toStringExp = ##"<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>"##
        @Assert(xmlelement.toString(), toStringExp)
        var afterToXmlStr = ##"<message>star~!@#@$%$%^*()_+{}|\":?tin().,';[]=>-g</message>"##
        @Assert(xmlelement.toXmlString(), afterToXmlStr)
    }
}
