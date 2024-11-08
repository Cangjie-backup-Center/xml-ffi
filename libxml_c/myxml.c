/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 * Description: XML for Cangjie API
 * Author: cwl1097228
 * Create: 2023-09-1
 * Notes: 2023-09-1 Create
 */
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <stdarg.h>
#include <stddef.h>
#include "parser.h"

char *print_element_names(xmlNode *a_node)
{
    if (a_node == NULL) {
        return NULL;
    }
    if (a_node -> type == XML_ELEMENT_NODE) {
        return a_node -> name;
    } else {
        return "";
    }
}

char *query_xmlNode_name(const long long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    return print_element_names(cur);
}

char *query_xmlNode_content(const long long ptr, const long long ptr1)
{
    xmlDocPtr doc;
    xmlNodePtr cur;
    doc = (xmlDocPtr) ptr;
    cur = (xmlNodePtr) ptr1;
    if (doc == NULL || cur == NULL) {
        return NULL;
    }
    xmlChar* key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
    return key;
}

long long query_DocPtr(const char *file_name)
{
    xmlDocPtr doc;
    doc = xmlParseMemory(file_name, strlen(file_name));
    if (doc == NULL) {
        return NULL;
    }
    return (long long)(doc);
}

long long query_Root_NodePtr(const long long ptr)
{
    xmlDocPtr doc;
    xmlNodePtr cur;
    doc = (xmlDocPtr) ptr;
    if (doc == NULL) {
        return NULL;
    }
    cur = xmlDocGetRootElement(doc);
    return (long long)(cur);
}

void xmlAttrPtr_free(const long long ptr)
{
    xmlAttrPtr prop;
    prop = (xmlAttrPtr) ptr;
    if (prop == NULL) {
        return;
    }
    xmlFreeProp(prop);
}


long long query_ChildrenNodes(const long long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    if (cur == NULL) {
        return NULL;
    }
    cur = cur -> xmlChildrenNode;
    return (long long)(cur);
}

long long query_nextNode(const long long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    if (cur == NULL) {
        return NULL;
    }
    cur = cur -> next;
    return (long long)(cur);
}

long long query_ChildrenProps(const long long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    if (cur == NULL) {
        return NULL;
    }
    xmlAttrPtr attribute = cur -> properties;
    return (long long)(attribute);
}

long long query_nextProp(const long long ptr)
{
    xmlAttrPtr attribute;
    attribute = (xmlAttrPtr) ptr;
    if (attribute == NULL) {
        return NULL;
    }
    attribute = attribute -> next;
    return (long long)(attribute);
}

char *query_Propattribute_name(const long long ptr)
{
    xmlAttrPtr attribute;
    attribute = (xmlAttrPtr) ptr;
    if (attribute == NULL) {
        return NULL;
    }
    return attribute -> name;
}

char *query_Propattribute_contxt(const long long ptr, const long long ptr1)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    xmlAttrPtr attribute;
    attribute = (xmlAttrPtr) ptr1;
    if (cur == NULL || attribute == NULL) {
        return NULL;
    }
    return xmlGetProp(cur, attribute -> name);
}

void SAX_HandlesCreate(startDocumentSAXFunc sd, endDocumentSAXFunc ed, startElementSAXFunc se, endElementSAXFunc ee,
    charactersSAXFunc charsse, const char *file_name)
{
    xmlSAXHandlerPtr handler = calloc(5, sizeof(xmlSAXHandler));
    if (handler == NULL) {
        return;
    }
    handler -> startDocument = sd;
    handler -> endDocument = ed;
    handler -> startElement = se;
    handler -> endElement = ee;
    handler -> characters = charsse;
    xmlSAXUserParseMemory(handler, NULL, file_name, strlen(file_name));
    xmlCleanupParser();
}

#define bottom_parser
#include "elfgcchack.h"