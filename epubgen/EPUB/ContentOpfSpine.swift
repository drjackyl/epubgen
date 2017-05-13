import Foundation





class ContentOpfSpine : XmlNodeConvertible {
    
    fileprivate var itemrefs = [XMLNode]()
    
    
    
    
    // MARK: - Public
    
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
        return XMLElement(name: "spine", children: itemrefs, attributes: [])
    }
    
}






























