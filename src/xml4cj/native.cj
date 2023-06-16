/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 * Description: The file declares the class XmlElement.
 */
package xml4cj

let XML_OK = 0
let XML_SYNTAX_ERROR = 0xA05_0007

type StartDocumentFunc = CFunc<(CPointer<Unit>) -> Unit>
type EndDocumentFunc = CFunc<(CPointer<Unit>) -> Unit>
type StartElementFunc = CFunc<(CPointer<Unit>, CString, CPointer<CString>, UInt32) -> Unit>
type EndElementFunc = CFunc<(CPointer<Unit>, CString) -> Unit>
type CharactersFunc = CFunc<(CPointer<Unit>, CString, UInt32) -> Unit>
type ChunkBufferFunc = CFunc<(CPointer<Unit>, CPointer<CString>, CPointer<UInt32>, CPointer<UInt32>) -> UInt32>

// Anyxml lib structs mirror.
@c
struct CXmlString {
    var buffer: CString = CString(CPointer<UInt8>())
    var len: UInt32 = 0
    var reserved: UInt32 = 0
}

@c
struct CXmlAttr {
    var name: CPointer<CXmlString> = CPointer<CXmlString>()
    var content: CPointer<CXmlString> = CPointer<CXmlString>()
}

@c
struct CXmlElement {
    var name: CPointer<CXmlString> = CPointer<CXmlString>()
    var content: CPointer<CXmlString> = CPointer<CXmlString>()
    var attributes: CPointer<CPointer<CXmlAttr>> = CPointer<CPointer<CXmlAttr>>()
    var firstChild: CPointer<CXmlElement> = CPointer<CXmlElement>()
    var rightSibling: CPointer<CXmlElement> = CPointer<CXmlElement>()
    var childCount: UInt32 = 0
    var attributesNum: UInt32 = 0
    var parentIndex: UInt32 = 0
    var isClosed: UInt32 = 0
}

@c
struct CXmlDocument {
    var root: CPointer<CXmlElement> = CPointer<CXmlElement>()
    var parser: CPointer<Unit> = CPointer<Unit>()
}

@c
struct DomHandle {
    var doc: CPointer<CXmlDocument> = CPointer<CXmlDocument>()
    var errorCode: Int64 = 0
}

@c
func CFuncNullTypeI(ptr: CPointer<Unit>): Unit {}

@c
func CFuncNullTypeII(uintptr: CPointer<Unit>, cstring: CString, cstringptr: CPointer<CString>, uint32: UInt32): Unit {}

@c
func CFuncNullTypeIII(ptr: CPointer<Unit>, cstring: CString): Unit {}

@c
func CFuncNullTypeIV(ptr: CPointer<Unit>, cstring: CString, uint32: UInt32): Unit {}

@c
struct SAXHandle {
    var sd: StartDocumentFunc = CFuncNullTypeI
    var ed: EndDocumentFunc = CFuncNullTypeI
    var se: StartElementFunc = CFuncNullTypeII
    var ee: EndElementFunc = CFuncNullTypeIII
    var chars: CharactersFunc = CFuncNullTypeIV
}

@fastNative
foreign func CJ_XML_Init(): Bool

@fastNative
foreign func CJ_XML_DeInit(): Unit

foreign func CJ_XML_DOM_Parse(str: CPointer<UInt8>, len: Int64): CPointer<DomHandle>

foreign func CJ_XML_DOM_Free(doc: CPointer<DomHandle>): Unit

foreign func CJ_XML_SAX_Parse(handles: CPointer<SAXHandle>, chunk: ChunkBufferFunc, userData: CPointer<Unit>): Bool

foreign func CJ_XML_SAX_UserDataCreate(): CPointer<UserData>

foreign func CJ_XML_SAX_UserDataDestroy(userData: CPointer<UserData>): Unit

foreign func SAX_HandlesCreate(sd: StartDocumentFunc, ed: EndDocumentFunc, se: StartElementFunc, ee: EndElementFunc, chars: CharactersFunc): CPointer<SAXHandle>

foreign func SAX_HandlesDestroy(SAXHandle: CPointer<SAXHandle>): Unit