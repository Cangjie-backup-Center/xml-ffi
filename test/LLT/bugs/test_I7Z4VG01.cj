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
    Xmlbom.testXmlParser02()
    Xmlbom.testXmlParser03()
    return 0
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

@Test
public class XmlBOmTest01 {

    @TestCase
    public func testXmlParser(): Unit {
        let sax = ASaxHandler()
        let x: XmlParser = XmlParser(sax)
        var str = """
        <message>Starting</message><?xml version="1.0" encoding="utf-8"?>
        """
        try {
            x.parse(str).getOrThrow()
        }catch(e: NoneValueException) {
            println(sax.m)
            @Assert(sax.m, 15)
        }
    }

    @TestCase
    public func testXmlParser01(): Unit {
        let sax = ASaxHandler()
        let x: XmlParser = XmlParser(sax)
        var str = ##"<message>st开始ar~! ~@@#%^.......*()--+-.{}【】;;;：“.《》ting</message>"##
        try {
            x.parse(str).getOrThrow()
        }catch(e: NoneValueException) {
            @Assert(sax.m, 20)
        }
    }

    @TestCase
    public func testXmlParser02(): Unit {
        let x: XmlParser = XmlParser()
        var str = ##"<message>if100 &quot;1000</message>"##
        
        let src = x.parse(str).getOrThrow()
        @Assert(src.content, "if100 \"1000")
    }

    @TestCase
    public func testXmlParser03(): Unit {
        let x: XmlParser = XmlParser()
        var str = ##"<message>if100 &gt;1000</message>"##
        
        let src = x.parse(str).getOrThrow()
        @Assert(src.content, "if100 >1000")
    }
}

