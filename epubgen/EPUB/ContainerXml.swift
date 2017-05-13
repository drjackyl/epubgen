import Foundation





/**
 Represents the container.xml-file in the META-INF-directory of an EPUB
 */
class ContainerXml : XmlDocumentConvertible {
    
    let packageFilePath: String
    
    
    
    
    
    init(packageFilePath: String) {
        self.packageFilePath = packageFilePath
    }
    
    
    
    
    
    // MARK: - XmlDocumentConvertible
    
    func convertToXmlDocument() -> XMLDocument {
        let containerElement = createContainerElement()
        
        let containerXml = XMLDocument(rootElement: containerElement)
        containerXml.version = "1.0"
        
        return containerXml
    }
    
    fileprivate func createContainerElement() -> XMLElement {
        let rootfileAttributes = [
            XMLNode.attribute(name: "full-path", value: packageFilePath),
            XMLNode.attribute(name: "media-type", value: "application/oebps-package+xml")
        ]
        let rootfileElement = XMLElement(name: "rootfile", attributes: rootfileAttributes)
        
        let rootfilesElement = XMLElement(name: "rootfiles", children: [rootfileElement], attributes: [])
        
        let containerAttributes = [
            XMLNode.attribute(name: "version", value: "1.0"),
            XMLNode.attribute(name: "xmlns", value: "urn:oasis:names:tc:opendocument:xmlns:container")
        ]
        let containerElement = XMLElement(name: "container", children: [rootfilesElement], attributes: containerAttributes)
        
        return containerElement
    }
    
}






























