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
        var str1 = ##"<message>if100 &apos; 1000</message>"##
        var str2 = ##"<message>if100 &quot; 1000</message>"##
        var str3 = ##"<message>if100 &lt; 1000</message>"##
        var str4 = ##"<message>if100 &gt; 1000</message>"##
        var str5 = ##"<message>if100 &amp;; 1000</message>"##
        let src1 = x.parse(str1)
        let src2 = x.parse(str2)
        let src3 = x.parse(str3)
        let src4 = x.parse(str4)
        let src5 = x.parse(str5)
        @Assert(sax.m, 125)
        
    }

   
}

