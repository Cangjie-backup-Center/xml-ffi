// 3rd_party_lib:xml4cj/build/xml4cj
//3rd_party_lib_ohos:xml4cj\build\aarch64-linux-ohos\xml4cj
from xml4cj import xml4cj.*
from std import unittest.*
from std import collection.*

@Test
public class xml4cjparserTest {
    @TestCase
    func testparser_01(): Unit {
        var saxxml = A()
        var xmlparser = XmlParser(saxxml)
        var xmlStringExp =
            #"<message attr1="123" attr1="123" attr2="126">starting
            <ele1 attr1="123" attr2="126">content1
                <ele21 attr1="123" attr2="126">content21
                    <ele321 attr1="123" attr1="123">content321</ele321>
                    <ele321 attr1="123" attr1="123">content321</ele321>
                    <ele321 attr1="123" attr1="123">content321</ele321>
                </ele21>
                <ele21 attr1="123" attr2="126">content21
                    <ele321 attr1="123" attr1="123">content321</ele321>
                    <ele321 attr1="123" attr1="123">content321</ele321>
                    <ele321 attr1="123" attr1="123">content321</ele321>
                </ele21>
                <ele21 attr1="123" attr2="126">content21
                    <ele321 attr1="123" attr1="123">content321</ele321>
                    <ele321 attr1="123" attr1="123">content321</ele321>
                    <ele321 attr1="123" attr1="123">content321</ele321>
                </ele21>
            </ele1>
            <ele21 attr1="123" attr2="126">content21
                <ele321 attr1="123" attr1="123">content321</ele321>
                <ele321 attr1="123" attr1="123">content321</ele321>
                <ele321 attr1="123" attr1="123">content321</ele321>
            </ele21>
            <ele321 attr1="123" attr1="123">content321</ele321>
        </message>"#
        try {
            xmlparser.parse(xmlStringExp).getOrThrow()
        } catch (e: NoneValueException) {
            @Assert(e.toString(), "NoneValueException")
        }
    }
}

class A <: SaxHandler {
    public var m = 0
    public func startDocument(): Unit {
        m += 1
    }
    public func endDocument(): Unit {
        m += 2
    }
    public func startElement(_: String, _: ArrayList<XmlAttr>): Unit {
        m += 3
    }
    public func endElement(_: String): Unit {
        m += 4
    }
    public func characters(_: String): Unit {
        m += 5
    }
}
