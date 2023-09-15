

#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <stdarg.h>
#include <stddef.h>
#include "parser.h"

char *print_element_names(xmlNode *a_node)
{
    if (a_node == NULL) {
        return "";
    }
    if (a_node -> type == XML_ELEMENT_NODE) {
        return a_node -> name;
    } else {
        return "";
    }
}

char *query_xmlNode_name(const long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    return print_element_names(cur);
}

char *query_xmlNode_content(const long ptr, const long ptr1)
{
    xmlDocPtr doc;
    xmlNodePtr cur;
    doc = (xmlDocPtr) ptr;
    cur = (xmlNodePtr) ptr1;
    xmlChar* key = xmlNodeListGetString(doc, cur -> xmlChildrenNode, 1);
    if (key == NULL) {
        return "";
    }
    return key;
}

long query_DocPtr(const char *file_name)
{
    xmlDocPtr doc;  
    doc = xmlParseMemory(file_name, strlen(file_name));  
    return (long)(doc);
}

long query_Root_NodePtr(const long ptr)
{
    xmlDocPtr doc;
    xmlNodePtr cur;
    doc = (xmlDocPtr) ptr;
    cur = xmlDocGetRootElement(doc);
    return (long)(cur);
}

int xmlNodePtr_isNull(const long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    if (cur == NULL){
        return 1;
    }
    return 0;
}

int xmlDocPtr_isNull(const long ptr)
{
    xmlDocPtr doc;
    doc = (xmlDocPtr) ptr;
    if (doc == NULL){
        return 1;
    }
    return 0;
}

int xmlAttrPtr_isNull(const long ptr)
{
    xmlAttrPtr prop;
    prop = (xmlAttrPtr) ptr;
    if (prop == NULL){
        return 1;
    }
    return 0;
}

void xmlDocPtr_free(const long ptr)
{
    xmlDocPtr doc;
    doc = (xmlDocPtr) ptr;
    xmlFreeDoc(doc);
}

void xmlNodePtr_free(const long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    xmlFreeNode(cur);
}

void xmlNodePtrList_free(const long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    xmlFreeNodeList(cur);
}

void xmlAttrPtr_free(const long ptr)
{
    xmlAttrPtr prop;
    prop = (xmlAttrPtr) ptr;
    xmlFreeProp(prop);
}

void xmlAttrPtrList_free(const long ptr)
{
    xmlAttrPtr prop;
    prop = (xmlAttrPtr) ptr;
    xmlFreePropList(prop);
}

long query_ChildrenNodes(const long ptr)
{
    
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    cur = cur -> xmlChildrenNode; 
    return (long)(cur);
}

long query_nextNode(const long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    cur = cur -> next;
    return (long)(cur);
}

long query_ChildrenProps(const long ptr)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    xmlAttrPtr attribute = cur -> properties;
    return (long)(attribute);
}

long query_nextProp(const long ptr)
{
    xmlAttrPtr attribute;
    attribute = (xmlAttrPtr) ptr;
    attribute = attribute -> next;
    return (long)(attribute);
}

char *query_Propattribute_name(const long ptr)
{
    xmlAttrPtr attribute;
    attribute = (xmlAttrPtr) ptr;
    return attribute -> name;
}

char *query_Propattribute_contxt(const long ptr, const long ptr1)
{
    xmlNodePtr cur;
    cur = (xmlNodePtr) ptr;
    xmlAttrPtr attribute;
    attribute = (xmlAttrPtr) ptr1;
    return xmlGetProp(cur, attribute -> name);
}

void SAX_HandlesCreate(startDocumentSAXFunc sd, endDocumentSAXFunc ed, startElementSAXFunc se, endElementSAXFunc ee,
    charactersSAXFunc charsse, const char *file_name)
{
    xmlSAXHandlerPtr handler = calloc(5, sizeof(xmlSAXHandler));
    handler -> startDocument = sd;
    handler -> endDocument = ed;
    handler -> startElement = se;
    handler -> endElement = ee;
    handler -> characters = charsse;
    xmlSAXUserParseMemory(
        handler,
        NULL,
        file_name,
        strlen(file_name)
    );
    xmlCleanupParser();
}

#define bottom_parser
#include "elfgcchack.h"