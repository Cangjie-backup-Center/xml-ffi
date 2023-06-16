/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 * Description: The file declares the class XmlParser.
 */

/**
 * @file The file declares the class XmlParser.
 */
package xml4cj

from std import collection.*
from std import math.*
from std import sync.*

public class XmlException <: Exception {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "XmlException"
    }
}

// Used to store error code and callback corresponding to `XmlUserData`(native).
@c
struct UserData {
    var errorCode: Int64 = XML_OK
}

type CPointerAddress = UIntNative
var SAX_HANDLER_MAP = HashMap<CPointerAddress, SaxHandler>()
var SAX_DATA_MAP = HashMap<CPointerAddress, String>()
let mtx = ReentrantMutex()

// For convenience, we return a SimpleSaxHandler if it was not registered.
@fastCall
func getSaxHandler(userData: CPointer<UserData>): SaxHandler {
    return SAX_HANDLER_MAP.get(userData.toUIntNative()) ?? SimpleSaxHandler()
}

@c
func start_doc_callback(ud: CPointer<Unit>): Unit {
    let userData = CPointer<UserData>(ud)
    let sax = getSaxHandler(userData)
    sax.startDocument()
}

@c
func end_doc_callback(ud: CPointer<Unit>): Unit {
    let userData = CPointer<UserData>(ud)
    let sax = getSaxHandler(userData)
    sax.endDocument()
}

func saxGetAttrs(attrs: CPointer<CString>, attrsNum: Int64): ArrayList<XmlAttr> {
    var attrList = ArrayList<XmlAttr>()

    // An array of attributes as name/content pairs.
    for (i in 0..attrsNum) {
        unsafe {
            // In SAX mode, all resource is well managed by SAX parser and no need to free.
            var name = attrs.read(i * 2)
            var content = attrs.read(i * 2 + 1)
            attrList.append(XmlAttr(name.toString(), content.toString(), checkWellFormed: false))
        }
    }
    return attrList
}

// SAX wrapper functions for passing callbacks to C.
// In SAX mode, all resource is well managed by SAX parser and no need to free,
// except for `userData`.
@c
func start_ele_callback(ud: CPointer<Unit>, name: CString, attrs: CPointer<CString>, attrsNum: UInt32): Unit {
    let userData = CPointer<UserData>(ud)
    let sax = getSaxHandler(userData)
    sax.startElement(name.toString(), saxGetAttrs(attrs, Int64(attrsNum)))
}

@c
func end_ele_callback(ud: CPointer<Unit>, name: CString): Unit {
    let userData = CPointer<UserData>(ud)
    let sax = getSaxHandler(userData)
    sax.endElement(name.toString())
}

@c
func characters_callback(ud: CPointer<Unit>, name: CString, len: UInt32): Unit {
    let userData = CPointer<UserData>(ud)
    let sax = getSaxHandler(userData)
    sax.characters(name.toString())
}

@c
func chunk_buffer_callback(
    ud: CPointer<Unit>,
    chunkPtr: CPointer<CString>,
    chunkSize: CPointer<UInt32>,
    endFlag: CPointer<UInt32>
): UInt32 {
    let userData = CPointer<UserData>(ud)
    let input = SAX_DATA_MAP.get(userData.toUIntNative()) ?? ""
    unsafe {
        let cph = input.getRaw()
        chunkPtr.write(CString(cph.pointer))
        input.releaseRaw(cph)

        chunkSize.write(UInt32(input.utf8View.size))
        endFlag.write(1)
    }
    return UInt32(XML_OK)
}

public interface SaxHandler {
    /*
     * Receive notification of the beginning of a document.
     */
    func startDocument(): Unit

    /*
     * Receive notification of the end of a document.
     */
    func endDocument(): Unit

    /*
     * Signals the start of an element in non-namespace mode.
     */
    func startElement(name: String, attrs: ArrayList<XmlAttr>): Unit

    /*
     * Signals the end of an element in non-namespace mode.
     */
    func endElement(name: String): Unit

    /*
     * Receive notification of character data.
     */
    func characters(content: String): Unit
}

// An simple SAX handler class used for default instantiation.
class SimpleSaxHandler <: SaxHandler {
    public func startDocument(): Unit {}
    public func endDocument(): Unit {}
    public func startElement(name: String, attrs: ArrayList<XmlAttr>): Unit {}
    public func endElement(name: String): Unit {}
    public func characters(content: String): Unit {}
}

/**
 * The input string may be Unicode characters, we have to build the substring
 * from its utf-8 view.
 */
func getSubString(str: String, u8Start: Int64, u8Len: Int64): String {
    if (u8Len == 0) {
        return ""
    }
    let u8Arr = str.utf8View.slice(u8Start, u8Len).toArray()
    return String.fromUtf8(u8Arr)
}

public class XmlParser {
    var isSax = false
    var sax: SaxHandler = SimpleSaxHandler()

    /*
     * Create a XML Parser with the Document Object Model (DOM) API
     *
     * @throws XmlException if failed to call CJ_XML_Init.
     */
    public init() {
        unsafe {
            var isSuc = CJ_XML_Init()
            if (!isSuc) {
                throw XmlException("XmlParser initialize failed.")
            }
        }
    }

    ~init() {
        unsafe {
            CJ_XML_DeInit()
        }
    }

    /*
     * Create a XML Parser with the Simple API for XML (SAX) API
     *
     * @throws XmlException if failed to call CJ_XML_Init.
     */
    public init(handler: SaxHandler) {
        isSax = true
        sax = handler
        unsafe {
            var isSuc = CJ_XML_Init()
            if (!isSuc) {
                throw XmlException("XmlParser initialize failed.")
            }
        }
    }

    /**
     * @throws XmlException if failed to malloc or parse or null pointer.
     * @throws IllegalArgumentException if string contains null character.
     */
    public func parse(str: String): Option<XmlElement> {
        if (str.contains('\0')) {
            throw IllegalArgumentException("XML txt cannot contain null character.")
        }
        if (str.size > Int64(UInt32.Max)) {
            throw IllegalArgumentException("The maximum parsing length is the maximum value of UInt32.")
        }
        if (str.isEmpty()) {
            return Option<XmlElement>.None
        }
        unsafe {
            if (isSax) {
                // Create userData as a param of all callbacks and store in the global SAX_HANDLER_MAP.
                var userData = unsafe { CJ_XML_SAX_UserDataCreate() }
                if (userData.isNull()) {
                    throw XmlException("Failed malloc in C code!")
                }
                synchronized (mtx) {
                    SAX_HANDLER_MAP.put(userData.toUIntNative(), sax)
                    SAX_DATA_MAP.put(userData.toUIntNative(), str)
                    var handles = SAX_HandlesCreate(
                        start_doc_callback,
                        end_doc_callback,
                        start_ele_callback,
                        end_ele_callback,
                        characters_callback
                    )
                    var isSuc = CJ_XML_SAX_Parse(
                        handles, 
                        chunk_buffer_callback,
                        CPointer<Unit>(userData)
                    )
                    try {
                        if (!isSuc) {
                            let err = userData.read().errorCode
                            if (err == XML_SYNTAX_ERROR) {
                                throw XmlException("XML text syntax error.")
                            }
                            throw XmlException("XML SAX parse failed.")
                        }
                    } finally {
                        SAX_DATA_MAP.remove(userData.toUIntNative())
                        SAX_HANDLER_MAP.remove(userData.toUIntNative())
                        SAX_HandlesDestroy(handles)
                        CJ_XML_SAX_UserDataDestroy(userData)
                    }
                }
                return Option<XmlElement>.None
            }

            // Handle DOM parsing.
            var len = str.utf8View.size
            var cph = str.getRaw()
            var dom = CJ_XML_DOM_Parse(cph.pointer, len)
            str.releaseRaw(cph)
            if (dom.isNull()) {
                throw XmlException("Failed malloc in C code!")
            }

            let err = dom.read().errorCode
            let root: XmlElement
            try {
                if (err != XML_OK) {
                    if (err == XML_SYNTAX_ERROR) {
                        throw XmlException("XML text syntax error.")
                    }
                    throw XmlException("XML DOM parse failed.")
                }
                root = domGetElement(dom.read().doc.read().root)
            } finally {
                CJ_XML_DOM_Free(dom)
            }
            return root
        }
    }

    @fastCall
    private func domGetString(xmlStr: CPointer<CXmlString>): String {
        if (xmlStr.isNull()) {
            return ""
        }
        unsafe {
            // In DOM mode, CString points to the CPointer of input String and no need to free.
            var cStr: CString = xmlStr.read().buffer
            var u8Len = Int64(xmlStr.read().len)
            return getSubString(cStr.toString(), 0, u8Len)
        }
    }

    /**
     * @throws XmlException if cur is a null pointer.
     */
    private func domGetChildrenElements(first: CPointer<CXmlElement>, size: UInt32): ArrayList<XmlElement> {
        var childrenElements = ArrayList<XmlElement>()
        var cur = first
        for (i in 0..Int64(size)) {
            childrenElements.append(domGetElement(cur))
            cur = unsafe { cur.read().rightSibling }
        }
        return childrenElements
    }

    private func domGetAttributes(attrPairs: CPointer<CPointer<CXmlAttr>>, size: UInt32): ArrayList<XmlAttr> {
        var attrs = ArrayList<XmlAttr>()
        for (i in 0..Int64(size)) {
            unsafe {
                var attr = attrPairs.read(i).read()
                var name = domGetString(attr.name)
                var content = domGetString(attr.content)
                attrs.append(XmlAttr(name, content, checkWellFormed: false))
            }
        }
        return attrs
    }

    /**
     * @throws XmlException if eptr is a null pointer.
     */
    private func domGetElement(eptr: CPointer<CXmlElement>): XmlElement {
        if (eptr.isNull()) {
            throw XmlException("Empty XML String.")
        }
        var e = unsafe {
            eptr.read()
        }
        var name = domGetString(e.name)
        var content = domGetString(e.content)
        var xmlElement = XmlElement(name, content, checkWellFormed: false)
        xmlElement.childrenElements = domGetChildrenElements(e.firstChild, e.childCount)
        xmlElement.attributes = domGetAttributes(e.attributes, e.attributesNum)
        return xmlElement
    }
}
