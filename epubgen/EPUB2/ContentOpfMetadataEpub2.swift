import Foundation





class ContentOpfMetadataEpub2 : XmlNodeConvertible {
    
    var dcTitle = ""
    var dcIdentifier = ""
    var dcLanguage = ""
    
    var dcCreator = ""
    var dcDescription = ""
    var dcRights = ""
    var dcDate = ""
    
    var coverItemRef = ""
    
    
    
    
    
    // MARK: - XmlNodeConvertible
    
    func convertToXmlNode() -> XMLNode {
        let metadataChildren: [XMLNode] = [
            // Any of these is required in EPUB2
            XMLElement(name: "dc:title", stringValue: dcTitle),
            XMLElement(name: "dc:identifier",
                       stringValue: dcIdentifier,
                       attributes: [XMLNode.attribute(name: "id", value: ContentOpf.uniqueIdentifier)]),
            XMLElement(name: "dc:language", stringValue: dcLanguage),
            
            // Additional Dublin Core fields (not all)
            XMLElement(name: "dc:creator", stringValue: dcCreator),
            XMLElement(name: "dc:description", stringValue: dcDescription),
            XMLElement(name: "dc:rights", stringValue: dcRights),
            XMLElement(name: "dc:date", stringValue: dcDate),
            
            // Additional meta-element describing the cover
            XMLElement(name: "meta",
                       attributes: [XMLNode.attribute(name: "name", value: "cover"),
                                    XMLNode.attribute(name: "content", value: coverItemRef)])
        ]
        
        let metadataAttributes: [XMLNode] = [
            XMLNode.attribute(name: "xmlns:dc", value: "http://purl.org/dc/elements/1.1/"),
            XMLNode.attribute(name: "xmlns:opf", value: "http://www.idpf.org/2007/opf")
        ]
        
        return XMLElement(name: "metadata",
                          children: metadataChildren,
                          attributes: metadataAttributes)
    }
    
}






























