// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from xml4cj import xml4cj.*
from std import unittest.*
from std import unittest.testmacro.*

main(): Int64 {
    let Xmlbom = XmlBOmTest01()

    Xmlbom.testXmlParser()
    Xmlbom.testXmlParser1()
    return 0
}

@Test
public class XmlBOmTest01 {

    @TestCase
    public func testXmlParser(): Unit {
        let x: XmlParser = XmlParser()
        var str = ##"<sode/>"##
        var ret = x.parse(str)
        var elements = XmlElement("se","se")
        match (ret) {
            case Some(root) => 
                elements = root
            case None => println("XML Parse error.")
        }
        @Assert(elements.name, "sode")
        @Assert(elements.content, "")
    }

    @TestCase
    public func testXmlParser1(): Unit {
        let x: XmlParser = XmlParser()
        var str = "dsdsads"
        try {
            x.parse(str)
        }catch (e: XmlException) {
            @Assert(e.toString(), "XmlException: xml txt syntax error.")
        }
    }
}

