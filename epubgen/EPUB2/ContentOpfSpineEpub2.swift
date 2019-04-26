import Foundation





class ContentOpfSpineEpub2 : XmlNodeConvertible {
    
    fileprivate var itemrefs = [XMLNode]()
    
    
    
    
    // MARK: - Public
    
    /// The id of the manifest item, that references the toc.ncx-file.
    var tocNcxManifestId = ""
    
    /**
     Adds an itemref-element
     
     - Attention: The function appends a new itemref-element without checking of any value.
     
     ````
     <itemref idref=""></itemref>
     ````
     
     - Parameter idref: The value for the idref-attribute.
     */
    func addItemref(idref: String) {
        let itemElement = XMLElement(name: "itemref", attributes: [XMLNode.attribute(name: "idref", value: idref)])
        itemrefs.append(itemElement)
    }
    
    
    
    
    
    // MARK: - XmlNodeConvertible
    
    func convertToXmlNode() -> XMLNode {
        let attributes: [XMLNode] = [
            XMLNode.attribute(name: "toc", value: tocNcxManifestId)
        ]
        return XMLElement(name: "spine", children: itemrefs, attributes: attributes)
    }
    
}






























