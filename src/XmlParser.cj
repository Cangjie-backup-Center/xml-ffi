/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * The file declars the XmlParser class.
 */
package xml4cj

from std import io.*
from std import fs.*
from std import os.posix.*
from std import sync.*
from std import math.*
from std import collection.*

var SAXArray = ArrayList<SaxHandler>()
public class XmlParser {
    
    private let mtx = ReentrantMutex()
    private var isSax = false
    private var sax: SaxHandler = SimpleSaxHandler()

    private var xmlDocPtr: Int64 = 0

    private var xmlNodePtr: Int64 = 0

    public init(){}


    public init(handler: SaxHandler){
        this.isSax = true
        this.sax = handler
    }


    public func parse(str: String): Option<XmlElement> {
        if (!str.contains('<')) {
            throw XmlException("XML txt syntax error.")
        }
        if (str.contains('\0')) {
            throw XmlException("XML txt cannot contain null character.")
        }
        if (str.size > Int64(UInt32.Max)) {
            throw XmlException("The maximum parsing length is the maximum value of UInt32.")
        }
        if (str.isEmpty()) {
            return Option<XmlElement>.None
        }
        if (isSax) {
            synchronized (mtx) {
                SAXArray.append(sax)
                
                var s = unsafe { LibC.mallocCString(str) }
                try {
                    unsafe { SAX_HandlesCreate(start_doc_callback,
                        end_doc_callback,
                        start_ele_callback,
                        end_ele_callback,
                        characters_callback,
                        s) 
                        }
                }finally {
                    unsafe { LibC.free(s) }
                    SAXArray.remove(0)
                }
            }
            return Option<XmlElement>.None
        }
        var params_str =  parserString_DocPtr(str)
        var node_ptr =  getRoot_NodePtr(params_str)
        var node_names = getxmlNode_name(node_ptr)
        var content = getxmlNode_content(params_str,node_ptr)
        return XmlElement(node_names, content, params_str, node_ptr)
    }
}


func checkXmlName(name: String) {
    if (name.isEmpty()) {
        throw XmlException("XML Name is not well-formed.")
    }
    if (name[0] == '-' || name[0] == '.' || name[0] == '\u{00B7}') {
        throw XmlException("XML Name is not well-formed.")
    }
    if (name[0] >= '0' && name[0] <= '9') {
        throw XmlException("XML Name is not well-formed.")
    }
}

public class XmlElement {

    public var eleName: String

    public var eleContent: String

    private var xmlDocPtr: Int64 = 0

    private var xmlNodePtr: Int64 = 0

    private var eleIsClosed: Bool

    private var eleChildrenElements: ArrayList<XmlElement> = ArrayList<XmlElement>()

    private var eleAttributes: ArrayList<XmlAttr> = ArrayList<XmlAttr>()

    init(name: String, content: String, xmlDocPtr: Int64, xmlNodePtr: Int64){
        this(name, content)
        this.eleChildrenElements = checkXmlElement(xmlDocPtr, xmlNodePtr)
        this.eleAttributes = checkXmlAttribute(xmlNodePtr)
        this.xmlDocPtr = xmlDocPtr
        this.xmlNodePtr = xmlNodePtr
    }

    ~init() {
        unsafe { 
            DocPtr_free(xmlDocPtr) 
            NodePtr_free(xmlNodePtr) 
        }
    }

    public init(name: String, content: String){
        checkXmlName(name)
        eleIsClosed = true
        this.eleName = name
        this.eleContent = content
    }

    public mut prop name: String {
        get() {
            eleName
        }
        set(v) {
            checkXmlName(name)
            eleName = v
        }
    }

    public mut prop content: String {
        get() {
            eleContent
        }
        set(v) {
            checkXmlName(name)
            eleContent = v
        }
    }

    public prop isClosed: Bool {
        get() {
            eleIsClosed
        }
    }

    public prop childrenNum: Int64 {
        get() {
            eleChildrenElements.size
        }
    }

    public mut prop childrenElements: ArrayList<XmlElement> {
        get() {
            eleChildrenElements
        }
        set(v) {
            eleChildrenElements = v
        }
    }

    public prop attributesNum: Int64 {
        get() {
            eleAttributes.size
        }
    }

    public mut prop attributes: ArrayList<XmlAttr> {
        get() {
            return eleAttributes
        }
        set(attrs) {
            var attrNameSet = HashSet<String>(eleAttributes.size)
            eleAttributes.clear()
            for (a in attrs) {
                if (attrNameSet.contains(a.name)) {
                    throw XmlException(
                        "An attribute name must not appear more than once in the same start-tag or empty-element tag.")
                }
                eleAttributes.append(XmlAttr(a.name, a.content))
                attrNameSet.put(a.name)
            }
        }
    }    

    public func toString(): String {
        var childrenBuilder = StringBuilder()
        for (child in eleChildrenElements) {
            childrenBuilder.append(child.toString())
        }

        var attrsBuilder = StringBuilder()
        for (attr in eleAttributes) {
            attrsBuilder.append(' ')
            attrsBuilder.append(attr.toString())
        }

        return String.join( [
                "<",
                eleName,
                attrsBuilder.toString(),
                ">",
                eleContent,
                childrenBuilder.toString(),
                "</",
                eleName,
                ">"
            ])
    }

    private func appendTabs(builder: StringBuilder, tabStop: Int64, level: Int64): Unit {
        for (_ in 0..level) {
            for (_ in 0..tabStop) {
                builder.append(' ')
            }
        }
    }

    private func toXmlString(e: XmlElement, tabStop: Int64, level: Int64): StringBuilder {
        var xmlStr = StringBuilder()
        var attrsBuilder = StringBuilder()
        for (attr in e.attributes) {
            attrsBuilder.append(' ')
            attrsBuilder.append(attr.toString())
        }
        appendTabs(xmlStr, tabStop, level)
        xmlStr.append('<')
        xmlStr.append(e.eleName)
        xmlStr.append(attrsBuilder)
        xmlStr.append('>')
        xmlStr.append(e.eleContent)
        if (e.childrenNum > 0) {
            xmlStr.append('\n')
            if (!e.eleContent.isEmpty()) {
                xmlStr.append('\n')
            }
        }

        for (child in e.childrenElements) {
            xmlStr.append(toXmlString(child, tabStop, level + 1))
        }

        if (e.childrenNum > 0) {
            appendTabs(xmlStr, tabStop, level)
        }
        xmlStr.append('<')
        xmlStr.append('/')
        xmlStr.append(e.eleName)
        xmlStr.append('>')
        xmlStr.append('\n')
        return xmlStr
    }

    public func toXmlString(): String {
        let tabStop = 4
        var xmlStr = toXmlString(this, tabStop, 0)
        xmlStr.removeLast()
        return xmlStr.toString()
    }

}

func checkXmlElement(xmlDocPtr: Int64, xmlNodePtr: Int64): ArrayList<XmlElement> {
    var arrayElement: ArrayList<XmlElement> = ArrayList<XmlElement>()
    var childnode = getChildrenNodes(xmlNodePtr)
    if(parserNodePtr_isNull(childnode)){
        return arrayElement
    }
    var node_names = getxmlNode_name(childnode)
    if (!node_names.isEmpty()) {
        var content = getxmlNode_content(xmlDocPtr,childnode)
        arrayElement.append(XmlElement(node_names, content, xmlDocPtr, childnode))
    }

    while(true) {
        var nextnode = getnextNode(childnode)
        if (parserNodePtr_isNull(nextnode)) {
             break
        }
        var nextnode_names = getxmlNode_name(nextnode)
        if (!nextnode_names.isEmpty()) {
            var nextcontent = getxmlNode_content(xmlDocPtr,nextnode)
            arrayElement.append(XmlElement(nextnode_names, nextcontent, xmlDocPtr, nextnode))
        }
        childnode = nextnode
    }
    return arrayElement
}

func checkXmlAttribute(xmlNodePtr: Int64): ArrayList<XmlAttr> {
    var arrayAttr: ArrayList<XmlAttr> = ArrayList<XmlAttr>()
    var childpro = getChildrenProps(xmlNodePtr)
    if(parserAttrPtr_isNull(childpro)){
        AttrPtr_free(childpro)
        return arrayAttr
    }
    var Attrnames = getPropattribute_name(childpro)
    var content = getPropattribute_content(xmlNodePtr,childpro)
    arrayAttr.append(XmlAttr(Attrnames, content))
    var nextpro: Int64 = 0
    while(true) {
        var nextpro = getnextProp(childpro)
        if (parserAttrPtr_isNull(nextpro)) {
            break
        }
        var Attrpronames = getPropattribute_name(nextpro)
        var contentpro = getPropattribute_content(xmlNodePtr,nextpro)
        arrayAttr.append(XmlAttr(Attrpronames, contentpro))
        childpro = nextpro
    }

    AttrPtr_free(nextpro)
    AttrPtr_free(childpro)
    return arrayAttr
}

public class XmlAttr <: ToString {

    public var attrName: String

    public var attrContent: String

    public init(name: String, content: String){
        checkXmlName(name)
        this.attrName = name
        this.attrContent = content
    }

    public mut prop name: String {
        get() {
            attrName
        }
        set(v) {
            checkXmlName(name)
            attrName = v
        }
    }

    public mut prop content: String {
        get() {
            attrContent
        }
        set(v) {
            attrContent = v
        }
    }

    public func toString(): String {
        return String.join([attrName, "=\"", attrContent, "\""])
    }
}

public class XmlException <: Exception {

    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

}

public interface SaxHandler {

    func startDocument(): Unit


    func endDocument(): Unit


    func startElement(name: String, attrs: ArrayList<XmlAttr>): Unit


    func endElement(name: String): Unit

 
    func characters(content: String): Unit
}

class SimpleSaxHandler <: SaxHandler {
    public func startDocument(): Unit {}
    public func endDocument(): Unit {}
    public func startElement(name: String, attrs: ArrayList<XmlAttr>): Unit {}
    public func endElement(name: String): Unit {}
    public func characters(content: String): Unit {}
}

func saxGetAttrs(attrs: CPointer<CPointer<UInt8>>): ArrayList<XmlAttr> {
    var attrList = ArrayList<XmlAttr>()

    // An array of attributes as name/content pairs.
    var i = 0
    while (true) {
        if (attrs.isNull()) {
            return attrList
        }
        unsafe {
            // In SAX mode, all resource is well managed by SAX parser and no need to free.
            var name = CString(attrs.read(i * 2)).toString()
            if (name.isEmpty()) {
                return attrList
            }
            var content = CString(attrs.read(i * 2 + 1)).toString()
            attrList.append(XmlAttr(name.toString(), content.toString()))
        }
        i++
    }
    return attrList
}

@C
func start_doc_callback(ud: CPointer<Unit>): Unit {
    SAXArray[0].startDocument()
}

@C
func end_doc_callback(ud: CPointer<Unit>): Unit {
    SAXArray[0].endDocument()
}

@C
func start_ele_callback(ud: CPointer<Unit>, name: CString, atts: CPointer<CPointer<UInt8>>): Unit {
    SAXArray[0].startElement(name.toString(),saxGetAttrs(atts))
}

@C
func end_ele_callback(ud: CPointer<Unit>, name: CString): Unit {
    
    SAXArray[0].endElement(name.toString())
}

@C
func characters_callback(ud: CPointer<Unit>, name: CString, len: UInt32): Unit {
    let src = name.toString().toUtf8Array()
    let sc = String.fromUtf8(src.slice(0,Int64(len)))
    SAXArray[0].characters(sc)
}
