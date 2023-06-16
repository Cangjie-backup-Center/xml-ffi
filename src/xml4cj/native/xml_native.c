/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 * Description: This file provides XML related native C funcitons.
 */

#include <stdbool.h>
#include <stdint.h>

#include "anyxml.h"
#include "anyxml_dom.h"
#include "anyxml_sax.h"
#include "anyxml_errno.h"
#include "securec.h"

typedef struct PartSAXHandle {
    StartDocumentSAXFunc startDocument;  /**< startDocument callback */
    EndDocumentSAXFunc   endDocument;    /**< endDocument callback */
    StartElementSAXFunc  startElement;   /**< startElement callback */
    EndElementSAXFunc    endElement;     /**< endElement callback */
    CharactersSAXFunc    characters;     /**< characters callback */
} SAXHandle;

typedef struct XmlUserData {
    int64_t errorCode;
} UserData;

extern bool CJ_XML_Init(void)
{
    static bool isInitialized = false;
    if (isInitialized) {
        return true;
    }

    if (AnyXmlInit(NULL, NULL) == ANYXML_OK) {
        isInitialized = true;
        return true;
    }
    return false;
}

extern void CJ_XML_DeInit(void)
{
    return;
}

typedef struct XmlDomHandle {
    XmlDocument* doc;
    int64_t errorCode;
} DomHandle;

extern DomHandle* CJ_XML_DOM_Parse(const uint8_t* buf, int64_t len)
{
    DomHandle* handle = (DomHandle*)malloc(sizeof(DomHandle));
    if (handle == NULL) {
        return NULL;
    }
    XmlDocument* doc = AnyXmlStringParse((const char*)buf, (uint32_t)len);
    handle->doc = doc;
    handle->errorCode = ANYXML_OK;
    if (doc == NULL) {
        handle->errorCode = AnyXmlLastErrorGet();
    }
    return handle;
}

extern void CJ_XML_DOM_Free(DomHandle* dom)
{
    AnyXmlFileFree(dom->doc);
    free(dom);
}

// Corresponding to `UserData`(@c).
extern bool CJ_XML_SAX_Parse(
    const SAXHandle* saxhandles, ChunkBufferSAXFunc chunkBuffer, UserData* userData)
{
    XmlSAXHandle handles = {saxhandles->startDocument, saxhandles->endDocument, saxhandles->startElement,
        saxhandles->endElement, saxhandles->characters, chunkBuffer};
    int32_t ret = AnyXmlSAXChunkParse(&handles, userData);
    if (ret != ANYXML_OK) {
        int32_t err = AnyXmlLastErrorGet();
        ((UserData*)userData)->errorCode = err;
        return false;
    }
    return true;
}

extern UserData* CJ_XML_SAX_UserDataCreate(void)
{
    UserData* data = (UserData*)malloc(sizeof(UserData));
    if (data == NULL) {
        return NULL;
    }
    data->errorCode = ANYXML_OK;
    return data;
}

extern void CJ_XML_SAX_UserDataDestroy(UserData* userData)
{
    free(userData);
}

extern SAXHandle* SAX_HandlesCreate(StartDocumentSAXFunc startDocument, EndDocumentSAXFunc endDocument,
    StartElementSAXFunc startElement, EndElementSAXFunc endElement, CharactersSAXFunc characters)
{
    SAXHandle* saxhandles = (SAXHandle*)malloc(sizeof(SAXHandle));
    if (saxhandles == NULL) {
        return NULL;
    }
    saxhandles->startDocument = startDocument;
    saxhandles->endDocument = endDocument;
    saxhandles->startElement = startElement;
    saxhandles->endElement = endElement;
    saxhandles->characters = characters;
    return saxhandles;
}

extern void SAX_HandlesDestroy(SAXHandle* saxhandles)
{
    free(saxhandles);
}