// 3rd_party_lib:xml-ffi/target/release/xml_ffi
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml_ffi
import xml_ffi.*
import std.unittest.*
import std.collection.*

/* 
  public init(start: Int32, end: Int32, keyword: String)
  public func getKeyword(): String
 */

@Test
public class xml4cjparserTest {


  @TestCase
  func testparser_01():Unit{ 
        let x: XmlParser = XmlParser()

        var ret = x.parse("<myxml shelf=\"New Arrivals\">66<score>7.4<day>29<day>29<day>29<time>17<min>26</min></time></day></day></day><month>08</month></score><year>2023<day>29</day></year><month>08</month><da>09</da></myxml>")
        var elements = XmlElement("se","se")
        match (ret) {
            case Some(root) => 
                elements = root
            case None => println("XML Parse error.")
        }
        @Assert(elements.name, "myxml")
    }
}


