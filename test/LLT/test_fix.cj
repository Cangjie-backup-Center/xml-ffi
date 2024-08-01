// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import xml4cj.*
import std.unittest.*
import std.collection.*
import std.unittest.testmacro.*
import std.io.*
import std.sync.*
import std.runtime.*
main(): Int64 {
    for (i  in 0..1000) {
        spawn {
            let data1 = "<XMLBODY><Map id = \"opdata\"><Field id = \"page\">1</Field><Field id = \"unRegData\">1</Field><Field id = \"mulCardFlag\">1</Field></Map></XMLBODY>"
            getAResult(data1)
        }
        spawn {
             let data2 = "<XMLBODY><Map id = \"opdata\"><Field id = \"page\">1</Field><Field id = \"unRegData\">1</Field><Field id = \"mulCardFlag\">1</Field></Map></XMLBODY>"
             getBResult(data2)
        }
    }
    println(
        "---- max:${MemoryInfo.maxHeapSize>>20} used:${MemoryInfo.allocatedHeapSize>>20} Physical:${MemoryInfo.heapPhysicalMemory>>20}"
    )
    return 0
}

func getElementByAttr(expected: XmlAttr, elements: ArrayList<XmlElement>): ArrayList<XmlElement> {
    let res: ArrayList<XmlElement> = ArrayList<XmlElement>()
    for (element in elements) {
        for(attr in element.attributes) {
            if (attr.name == expected.name && attr.content == expected.content) {
                res.append(element)
            }
        }
    }
    return res

}

func getAResult(data: String) {
    let parser = XmlParser()
    let ret = parser.parse(data)
    if (let Some(root) <- ret) {
        let opData = getElementByAttr(XmlAttr("id", "opdata"),root.childrenElements)
        if(opData.size > 0) {
            let tmp = getElementByAttr(XmlAttr("id", "data"),opData[0].childrenElements)
        }
    }

}

func getBResult(data: String) {
    let parser = XmlParser()
    let ret = parser.parse(data)
    if (let Some(root) <- ret) {
        let opData = getElementByAttr(XmlAttr("id", "opdata"),root.childrenElements)
        if(opData.size > 0) {
            let tmp = getElementByAttr(XmlAttr("id","page"), opData[0].childrenElements)
        }
        let unRegData = getElementByAttr(XmlAttr("id", "unRegData"),opData[0].childrenElements)
        let mulCardData = getElementByAttr(XmlAttr("id", "mulCardFlag"),opData[0].childrenElements)
    }
}




