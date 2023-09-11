// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*
from std import unittest.testmacro.*

main(): Int64 {
    let Xmlbom = XmlBOmTest01()

    Xmlbom.testXmlParser()
    Xmlbom.testXmlParser01()

    return 0
}

@Test
public class XmlBOmTest01 {

    @TestCase
    public func testXmlParser(): Unit {
        let x: XmlParser = XmlParser()

        var ret = x.parse("<myxml shelf=\"New Arrivals\">66<score>7.4<day>29<day>29<day>29<time>17<min>26</min></time></day></day></day><month>08</month></score><year>2023<day>29</day></year><month>08</month><da>09</da></myxml>")
        var elements = XmlElement("se","se")
        match (ret) {
            case Some(root) => 
                elements = root
            case None => println("XML Parse error.")
        }
        @Assert(elements.toXmlString().size, 399)
    }

    @TestCase
    public func testXmlParser01(): Unit {
        let x: XmlParser = XmlParser()

        var ret = x.parse("<myxml shelf=\"New Arrivals\" time=\"2023-8-31\">66<month>08</month></myxml>")
        var elements = XmlElement("se","se")
        match (ret) {
            case Some(root) => 
                elements = root
            case None => println("XML Parse error.")
        }
        @Assert(elements.toXmlString().size, 79)
    }
}

