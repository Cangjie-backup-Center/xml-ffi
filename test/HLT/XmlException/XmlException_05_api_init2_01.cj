// 3rd_party_lib:xml-ffi/target/release/xml4cj
//3rd_party_lib_ohos:xml-ffi\target\aarch64-linux-ohos\release\xml4cj
import xml4cj.*
import std.unittest.*
import std.collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        try {
            test(15)
        } catch (e: XmlException) {
            @Assert(e.toString(), "XmlException: number > 10")
        }
    }
    public func test(m: Int64) {
        if (m > 10) {
            throw XmlException("number > 10")
        }
    }
}
