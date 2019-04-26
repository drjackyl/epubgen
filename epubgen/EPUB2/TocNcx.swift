import Foundation





/**
 Describes an NCX as required by EPUB2.
 
 - Important:
    The current implementation only supports a flat list navMap containing navPoints.
 */
class TocNcx : XmlDocumentConvertible {
    
    // A flat list of navPoint-elements.
    fileprivate var navPoints = [XMLNode]()
    
    
    
    
    
    // MARK: - Public
    
    let filename = "toc.ncx"
    
    var dtbUid = ""
    var title = ""
    var author = ""
    
    func addNavPoint(src: String, title: String) {
        let contentElement = XMLElement(name: "content", attributes: [XMLNode.attribute(name: "src", value: src)])
        
        let textElement = XMLElement(name: "text", stringValue: title)
        let navLabelElement = XMLElement(name: "navLabel", children: [textElement], attributes: [])
        
        let navPointAttributes: [XMLNode] = [
            XMLNode.attribute(name: "id", value: "id\(navPoints.count)"),
            XMLNode.attribute(name: "playOrder", value: "\(navPoints.count)")
        ]
        
        let navPointElement = XMLElement(name: "navPoint", children: [navLabelElement, contentElement], attributes: navPointAttributes)
        
        navPoints.append(navPointElement)
    }
    
    
    
    
    
    // MARK: - Private
    
    fileprivate func createNcxElement() -> XMLElement {
        let ncxAttributes = [
            XMLNode.attribute(name: "xmlns", value: "http://www.daisy.org/z3986/2005/ncx/"),
            XMLNode.attribute(name: "version", value: "2005-1")
        ]
        
        let ncxChildren = [
            createHeadElement(),
            createDocElement(name: "Title", text: title),
            createDocElement(name: "Author", text: author),
            createNavMapElement()
        ]
        
        return XMLElement(name: "ncx", children: ncxChildren, attributes: ncxAttributes)
    }
    
    fileprivate func createHeadElement() -> XMLNode {
        let metaAttributes = [
            XMLNode.attribute(name: "content", value: dtbUid),
            XMLNode.attribute(name: "name", value: "dtb:uid")
        ]
        
        let metaElement = XMLElement(name: "meta", children: [], attributes: metaAttributes)
        
        return XMLElement(name: "head", children: [metaElement], attributes: [])
    }
    
    fileprivate func createDocElement(name: String, text: String) -> XMLNode {
        let textElement = XMLElement(name: "text", stringValue: text)
        return XMLElement(name: "doc\(name)", children: [textElement], attributes: [])
    }
    
    fileprivate func createNavMapElement() -> XMLNode {
        return XMLElement(name: "navMap", children: navPoints, attributes: [])
    }

    
    
    
    
    // MARK: - XmlDocumentConvertible
    
    func convertToXmlDocument() -> XMLDocument {
        let ncxElement = createNcxElement()
        
        let tocNcx = XMLDocument(rootElement: ncxElement)
        tocNcx.version = "1.0"
        tocNcx.characterEncoding = "utf-8"
        
        return tocNcx
    }
    
    
}






























