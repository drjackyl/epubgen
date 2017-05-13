import Foundation





class TocXhtml : XmlDocumentConvertible {
    
    fileprivate var tocListItems = [XMLNode]()
    
    
    
    
    
    // MARK: - Public
    
    var title = ""
    
    func addTocEntry(name: String, fileName: String) {
        let aElement = XMLElement(name: "a",
                                  stringValue: name,
                                  attributes: [XMLNode.attribute(name: "href", value: fileName)])
        let liElement = XMLElement(name: "li", children: [aElement], attributes: [])
        tocListItems.append(liElement)
    }
    
    
    
    
    
    // MARK: - Private
    
    fileprivate func createHtmlElement() -> XMLElement {
        let htmlAttributes = [
            XMLNode.attribute(name: "xmlns", value: "http://www.w3.org/1999/xhtml"),
            XMLNode.attribute(name: "xmlns:epub", value: "http://www.idpf.org/2007/ops"),
            XMLNode.attribute(name: "xmlns:ibooks", value: "http://vocabulary.itunes.apple.com/rdf/ibooks/vocabulary-extensions-1.0"),
            XMLNode.attribute(name: "epub:prefix", value: "ibooks: http://vocabulary.itunes.apple.com/rdf/ibooks/vocabulary-extensions-1.0")
        ]
        
        return XMLElement(name: "html",
                          children: [createHeadElement(), createBodyElement()],
                          attributes: htmlAttributes)
    }
    
    fileprivate func createHeadElement() -> XMLNode {
        let titleElement = XMLElement(name: "title", stringValue: title)
        return XMLElement(name: "head", children: [titleElement], attributes: [])
    }
    
    fileprivate func createBodyElement() -> XMLNode {
        let olElement = XMLElement(name: "ol", children: tocListItems, attributes: [])
        let navElement = XMLElement(name: "nav",
                                    children: [olElement],
                                    attributes: [XMLNode.attribute(name: "epub:type", value: "toc")])
        return XMLElement(name: "body", children: [navElement], attributes: [])
    }

    
    
    
    
    // MARK: - XmlDocumentConvertible
    
    func convertToXmlDocument() -> XMLDocument {
        let htmlElement = createHtmlElement()
        
        let tocXhtml = XMLDocument(rootElement: htmlElement)
        tocXhtml.version = "1.0"
        tocXhtml.characterEncoding = "utf-8"
        
        return tocXhtml
    }
    
    
}






























