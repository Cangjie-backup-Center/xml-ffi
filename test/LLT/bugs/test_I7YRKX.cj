// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import xml_ffi.*
import std.unittest.*
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
        let x: XmlParser = XmlParser()
        var str = "<collection shelf=\"New Arrivals\"></collection>"
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

