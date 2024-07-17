// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import xml4cj.*
import std.unittest.*
import std.collection.*
import std.unittest.testmacro.*

main(): Int64 {
    let Xmlbom = XmlBOmTest01()

    Xmlbom.testXmlParser()
    Xmlbom.testXmlParser01()
    
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
        var str=##"<?xml version="1.0" encoding="utf-8"?><showList color="blue"><message>starting</message><movie><name>Rain</name><date>2020-01-02</date></movie><file color="blue2" size="180"><name>Rain2</name><date>2020-01-03</date></file><!-- This is acomment --><message>if salary &lt; 1000 then</message><message>ending</message></showList>"##
        let sax = ASaxHandler()
        let x: XmlParser = XmlParser()
        let src1 = x.parse(str).getOrThrow()
        @Assert(src1.name, "showList")
        
    }

   @TestCase
    public func testXmlParser01(): Unit {
        var str=##"<?xml version="1.0" encoding="utf-8"?><showList color="blue"><message>starting</message><movie><name>Rain</name><date>2020-01-02</date></movie><file color="blue2" size="180"><name>Rain2</name><date>2020-01-03</date></file><!-- This is acomment --><message>if salary &lt; 1000 then</message><message>ending</message></showList>"##
        let sax = ASaxHandler()
        let x: XmlParser = XmlParser(sax)
        let src1 = x.parse(str)
        @Assert(sax.m, 118)
        
    }
}

