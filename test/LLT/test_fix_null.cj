// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import xml_ffi.*
import std.unittest.*
import std.unittest.testmacro.*

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
        var str = ##"<co"##
        try {
            x.parse(str)
        } catch (e: XmlException) {
            @Assert(e.toString().contains("XmlException: xml parse failed"), true)
        }
    }

    @TestCase
    public func testXmlParser01(): Unit {
        let x: XmlParser = XmlParser()
        var str = ##"<-----------------666"##
        try {
            x.parse(str)
        } catch (e: XmlException) {
            @Assert(e.toString().contains("XmlException: xml parse failed"), true)
        }
    }
}

