import Foundation





class ContentOpf : XmlDocumentConvertible {
    
    let metadata = ContentOpfMetadata()
    let manifest = ContentOpfManifest()
    let spine = ContentOpfSpine()
    
    
    
    
    
    // MARK: - XmlDocumentConvertible
    
    func convertToXmlDocument() -> XMLDocument {
        let packageElement = createPackageElement()
        
        let configOpf = XMLDocument(rootElement: packageElement)
        configOpf.version = "1.0"
        configOpf.characterEncoding = "utf-8"
        
        return configOpf
    }
    
    fileprivate func createPackageElement() -> XMLElement {
        let packageAttributes = [
            XMLNode.attribute(name: "xmlns", value: "http://www.idpf.org/2007/opf"),
            XMLNode.attribute(name: "unique-identifier", value: "bookid"),
            XMLNode.attribute(name: "version", value: "3.0"),
            XMLNode.attribute(name: "prefix", value: "rendition: http://www.idpf.org/vocab/rendition/#")
        ]
        
        return XMLElement(name: "package",
                          children: [metadata.convertToXmlNode(),
                                     manifest.convertToXmlNode(),
                                     spine.convertToXmlNode()],
                          attributes: packageAttributes)
    }
    
}





extension ContentOpf {
    
    class func ItemUUID() -> String {
        return "id-" + UUID().uuidString
    }
    
}






























