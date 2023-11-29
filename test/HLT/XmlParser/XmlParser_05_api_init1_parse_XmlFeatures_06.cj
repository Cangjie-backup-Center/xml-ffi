// 3rd_party_lib:xml4cj/build/xml4cj
//3rd_party_lib_ohos:xml4cj\build\aarch64-linux-ohos\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var xmlparser = XmlParser()
        var str = """
        <showList color="blue">
            <file color='blue2' size="180">
                <name>Rain2</name>
                <date>2020-01-03</date>
            </file>
        </showList>
        """
        var a = 0
        try {
            xmlparser.parse(str)
        } catch (e: XmlException) {
            a = a + 1
        }
        @Assert(a, 0)
    }
}
