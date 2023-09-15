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
        let sc = ASaxHandler()
        let x: XmlParser = XmlParser(sc)
        var str = ##"<showList color="blue"><file color="blue2" size="180"><name>Rain2</name><date>2020-01-03</date></file></showList>"##
        var elements = x.parse(str)
        @Assert(sc.m, 41)
    }


}
public class ASaxHandler <: SaxHandler {
    public var m = 0

    public init() {}

    public func startDocument(): Unit {
        m+=1
    }
    public func endDocument(): Unit {
        m+=2
    }
    public func startElement(name: String, attrs: ArrayList<XmlAttr>): Unit {
        m+=3
    }
    public func endElement(name: String): Unit {
        m+=4
    }
    public func characters(content: String): Unit {
        m+=5
    }
}
