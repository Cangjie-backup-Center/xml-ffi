if (NOT CANGJIE_BUILD_LSP)        
        add_subdirectory(native)
endif()
set(XML_SRCS
        xml_parser.cj
        xml_element.cj
        native.cj
        CACHE INTERNAL ""
)