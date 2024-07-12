/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

/**
 * @file
 * 
 */
package xml4cj


foreign {

    func query_xmlNode_name(ptr: Int64): CString

    func query_xmlNode_content(ptr: Int64, ptr1: Int64): CString

    func query_DocPtr(file_name: CString): Int64

    func query_Root_NodePtr(ptr: Int64): Int64

    func xmlNodePtr_isNull(ptr: Int64): Int32

    func xmlDocPtr_isNull(ptr: Int64): Int32

    func xmlAttrPtr_isNull(ptr: Int64): Int32

    func xmlDocPtr_free(ptr: Int64): Unit

    func xmlNodePtr_free(ptr: Int64): Unit

    func xmlAttrPtr_free(ptr: Int64): Unit

    func query_ChildrenNodes(ptr: Int64): Int64

    func query_nextNode(ptr: Int64): Int64

    func query_ChildrenProps(ptr: Int64): Int64

    func query_nextProp(ptr: Int64): Int64

    func query_Propattribute_name(ptr: Int64): CString

    func query_Propattribute_contxt(ptr: Int64, ptr1: Int64): CString
}

public func getxmlNode_name(Nodestr: Int64): String {
    return unsafe { query_xmlNode_name(Nodestr).toString() }
}

public func getxmlNode_content(DocPtr: Int64 , Nodestr: Int64): String {
    var ret = unsafe { query_xmlNode_content(DocPtr, Nodestr).toString() }
    return ret
}

public func parserString_DocPtr(buffer: String): Int64 {
    var s = unsafe { LibC.mallocCString(buffer) }
    var ret = unsafe { query_DocPtr(s) }
    unsafe { LibC.free(s) }
    return ret
}

public func getRoot_NodePtr(str: Int64): Int64 {
    var ret = unsafe { query_Root_NodePtr(str) }
    return ret
}

public func parserNodePtr_isNull(str: Int64): Bool {
    var ret = unsafe { xmlNodePtr_isNull(str) }
    if (ret == 1) {
        return true
    }else {
        return false
    }
    
}

public func parserDocPtr_isNull(str: Int64): Bool {
    var ret = unsafe { xmlDocPtr_isNull(str) }
    if (ret == 1) {
        return true
    }else {
        return false
    }
    
}

public func parserAttrPtr_isNull(str: Int64): Bool {
    var ret = unsafe { xmlAttrPtr_isNull(str) }
    if (ret == 1) {
        return true
    }else {
        return false
    }
    
}

public func DocPtr_free(str: Int64): Unit {
    unsafe { xmlDocPtr_free(str) }
}

public func NodePtr_free(str: Int64): Unit {
    unsafe { xmlNodePtr_free(str) }
}


public func AttrPtr_free(str: Int64): Unit {
    unsafe { xmlAttrPtr_free(str) }
}


public func getPropattribute_name(AttrPtr: Int64): String {
    return unsafe { query_Propattribute_name(AttrPtr).toString() }
}

public func getPropattribute_content(Nodestr: Int64 , AttrPtr: Int64): String {
    var ret = unsafe { query_Propattribute_contxt(Nodestr, AttrPtr).toString() }
    return ret
}

public func getChildrenNodes(NodePtr: Int64): Int64 {
    var ret = unsafe { query_ChildrenNodes(NodePtr) }
    return ret
}

public func getnextNode(NodePtr: Int64): Int64 {
    var ret = unsafe { query_nextNode(NodePtr) }
    return ret
}

public func getChildrenProps(NodePtr: Int64): Int64 {
    var ret = unsafe { query_ChildrenProps(NodePtr) }
    return ret
}

public func getnextProp(AttrPtr: Int64): Int64 {
    var ret = unsafe { query_nextProp(AttrPtr) }
    return ret
}

type StartDocumentFunc = CFunc<(CPointer<Unit>) -> Unit>
type EndDocumentFunc = CFunc<(CPointer<Unit>) -> Unit>
type StartElementFunc = CFunc<(CPointer<Unit>, CString, CPointer<CPointer<UInt8>>) -> Unit>
type EndElementFunc = CFunc<(CPointer<Unit>, CString) -> Unit>
type CharactersFunc = CFunc<(CPointer<Unit>, CString, UInt32) -> Unit>

foreign func SAX_HandlesCreate(sd: StartDocumentFunc, ed: EndDocumentFunc, se: StartElementFunc, ee: EndElementFunc, chars: CharactersFunc, buff: CString): Unit
