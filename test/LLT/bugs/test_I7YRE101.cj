// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import xml_ffi.*
import std.unittest.*
import std.collection.*
import std.unittest.testmacro.*

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
        var str = ##"<message>st开始ar~! ~@@#%%......* ()————+-=.{}【】; ': “, 。《》ting</message>"##
        var elements = x.parse(str)
        @Assert(sc.m, 20)
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
