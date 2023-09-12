// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*
from std import unittest.testmacro.*

main(): Int64 {
    let Xmlbom = XmlBOmTest01()

    Xmlbom.testXmlParser()

    return 0
}

@Test
public class XmlBOmTest01 {

    @TestCase
    public func testXmlParser(): Unit {
        let x: XmlParser = XmlParser()

        var elements = x.parse("<myxml shelf=\"New Arrivals\">66<score>year</score></myxml>").getOrThrow()
        @Assert(elements.isClosed, true)
        let src: ArrayList<XmlAttr> = ArrayList<XmlAttr>()
        let atr1 = XmlAttr("blue", "score")
        let atr2 = XmlAttr("time", "2023")
        src.append(atr1)
        src.append(atr2)
        elements.attributes = src
        @Assert(elements.attributes.size, 2)
    }

}

