// 3rd_party_lib:xml4cj/build/xml4cj
//3rd_party_lib_ohos:xml4cj\build\aarch64-linux-ohos\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var a = 0
        try {
            var xmlparser = XmlParser()
            var str1 = ##"<message>if 100 &apos; 1000</message>"##
            var str2 = ##"<message>if 100 &quot; 1000</message>"##
            var str3 = ##"<message>if 100 &lt;   1000</message>"##
            var str4 = ##"<message>if 100 &gt;   1000</message>"##
            var str5 = ##"<message>if 100 &amp; 1000</message>"##
            xmlparser.parse(str1).getOrThrow()
            xmlparser.parse(str2).getOrThrow()
            xmlparser.parse(str3).getOrThrow()
            xmlparser.parse(str4).getOrThrow()
            xmlparser.parse(str5).getOrThrow()
        } catch (e:Exception) {
            a = a + 1
        }
        @Assert(a, 0)
    }
}
