// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from xml4cj import xml4cj.*
from std import unittest.*
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
        var str = ##"<collection version="1.0" encoding="utf-8"><day>?29</day><min>26</min></collection>"##
        var ret = x.parse(str)
        var elements = XmlElement("se","se")
        match (ret) {
            case Some(root) => 
                elements = root
            case None => println("XML Parse error.")
        }
        @Assert(elements.name, "collection")
        @Assert(elements.content, "")
    }


}

