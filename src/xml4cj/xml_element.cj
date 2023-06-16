/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 * Description: The file declares the class XmlElement.
 */

/**
 * @file The file declares the class XmlElement.
 */
package xml4cj

/**
 * According to [Extensible Markup Language (XML) 1.0 (Fifth Edition)](https://www.w3.org/TR/xml/#NT-seq),
 * Names are defined:
 * [4]   	NameStartChar   ::=   	
 *                                  ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] |
 *                                  [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D] |
 *                                  [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] |
 *                                  [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
 * [4a]   	NameChar        ::=   	NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
 * [5]   	Name            ::=   	NameStartChar (NameChar)*
 * We check a part of the rule for `XmlElement` and `XMlAttr` initialization.
 *
 * @throws XmlException if name does not conform to the naming rules.
 */
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

public class XmlAttr <: ToString {
    private var attrName: String
    private var attrContent: String

    /**
     * Create a XmlAttr object
     * @param name - Attribute name
     * @param content - Attribute value
     * @throws XmlException if name does not conform to the naming rules.
     */
    public init(name: String, content: String) {
        this(name, content, checkWellFormed: true)
    }

    /**
     * @throws XmlException if name does not conform to the naming rules.
     */
    init(name: String, content: String, checkWellFormed!: Bool) {
        attrName = name
        attrContent = content
        if (checkWellFormed) {
            checkXmlName(name)
        }
    }

    /**
     * @throws XmlException if name does not conform to the naming rules.
     */
    public prop var name: String {
        get() {
            attrName
        }
        set(v) {
            checkXmlName(name)
            attrName = v
        }
    }

    public prop var content: String {
        get() {
            attrContent
        }
        set(v) {
            attrContent = v
        }
    }

    public func toString() {
        return String.join([attrName, "=\"", attrContent, "\""])
    }
}

/**
 * @throws XmlException if name does not conform to the naming rules.
 */
public class XmlElement <: ToString {
    private var eleName: String
    private var eleContent: String
    private var eleIsClosed: Bool
    private var eleChildrenElements: ArrayList<XmlElement>
    private var eleAttributes: ArrayList<XmlAttr>

    public init(name: String, content: String) {
        this(name, content, checkWellFormed: true)
    }

    init(name: String, content: String, checkWellFormed!: Bool) {
        eleName = name
        eleContent = content
        eleIsClosed = true
        eleChildrenElements = ArrayList<XmlElement>()
        eleAttributes = ArrayList<XmlAttr>()
        if (checkWellFormed) {
            checkXmlName(name)
        }
    }

    /**
     * @throws XmlException if name does not conform to the naming rules.
     */
    public prop var name: String {
        get() {
            eleName
        }
        set(v) {
            checkXmlName(name)
            eleName = v
        }
    }

    public prop var content: String {
        get() {
            eleContent
        }
        set(v) {
            eleContent = v
        }
    }

    public prop let isClosed: Bool {
        get() {
            eleIsClosed
        }
    }

    public prop let childrenNum: Int64 {
        get() {
            eleChildrenElements.size
        }
    }

    public prop var childrenElements: ArrayList<XmlElement> {
        get() {
            eleChildrenElements
        }
        set(v) {
            eleChildrenElements = v
        }
    }

    public prop let attributesNum: Int64 {
        get() {
            eleAttributes.size
        }
    }

    public prop var attributes: ArrayList<XmlAttr> {
        get() {
            return eleAttributes.clone()
        }

        /**
         * @throws XmlException if some attribute is repeated in attrs.
         */
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
        var attrsBuilder = StringBuilder()
        for (attr in eleAttributes) {
            attrsBuilder.append(' ')
            attrsBuilder.append(attr.toString())
        }

        var childrenBuilder = StringBuilder()
        for (child in eleChildrenElements) {
            childrenBuilder.append(child.toString())
        }
        return String.join(
            [
                "<",
                eleName,
                attrsBuilder.toString(),
                ">",
                eleContent,
                childrenBuilder.toString(),
                "</",
                eleName,
                ">"
            ]
        )
    }

    private func appendTabs(builder: StringBuilder, tabStop: Int64, level: Int64): Unit {
        for (i in 0..level) {
            for (j in 0..tabStop) {
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

            // If there are content and children elements meanwhile, add an empty line.
            if (!e.eleContent.isEmpty()) {
                xmlStr.append('\n')
            }
        }

        // Iterate children elements.
        for (child in e.childrenElements) {
            xmlStr.append(toXmlString(child, tabStop, level + 1))
        }

        // If there are children elements, it starts from a new line.
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
