import Foundation





class ContentOpfEpub2 : XmlDocumentConvertible {
    
    let metadata = ContentOpfMetadataEpub2()
    let manifest = ContentOpfManifest()
    let spine = ContentOpfSpineEpub2()
    let guide = ContentOpfGuide()
    
    
    
    
    
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
            XMLNode.attribute(name: "version", value: "2.0")
        ]
        
        return XMLElement(name: "package",
                          children: [metadata.convertToXmlNode(),
                                     manifest.convertToXmlNode(),
                                     spine.convertToXmlNode(),
                                     guide.convertToXmlNode()],
                          attributes: packageAttributes)
    }
    
}






























