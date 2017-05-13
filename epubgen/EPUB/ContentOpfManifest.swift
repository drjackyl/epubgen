import Foundation





class ContentOpfManifest : XmlNodeConvertible {
    
    fileprivate var items = [XMLNode]()
    
    
    
    
    // MARK: - Public
    
    /**
     Adds an item-element
     
     - Attention: The function appends a new item-element without checking of any value.
     
     ````
     <item id="" href="" media-type=""></item>
     ````
     
     - Parameter id: The value for the id-attribute.
     - Parameter href: The value for the href-attribtue.
     - Parameter mediaType: The value for the media-type-attribute
     */
    func addItem(id: String, href: String, mediaType: String) {
        let itemElement = XMLElement(name: "item",
                                     attributes: [XMLNode.attribute(name: "id", value: id),
                                                  XMLNode.attribute(name: "href", value: href),
                                                  XMLNode.attribute(name: "media-type", value: mediaType)])
        items.append(itemElement)
    }
    
    /**
     Adds a navigational item-element
     
     - Attention: The function appends a new item-element without checking of any value.
     
     ````
     <item id="" href="" media-type="" properties="nav"></item>
     ````
     
     - Parameter id: The value for the id-attribute.
     - Parameter href: The value for the href-attribtue.
     - Parameter mediaType: The value for the media-type-attribute
     */
    func addNavItem(id: String, href: String, mediaType: String) {
        let itemElement = XMLElement(name: "item",
                                     attributes: [XMLNode.attribute(name: "id", value: id),
                                                  XMLNode.attribute(name: "href", value: href),
                                                  XMLNode.attribute(name: "media-type", value: mediaType),
                                                  XMLNode.attribute(name: "properties", value: "nav")])
        items.append(itemElement)
    }
    
    
    
    
    
    // MARK: - XmlNodeConvertible
    
    func convertToXmlNode() -> XMLNode {
        return XMLElement(name: "manifest", children: items, attributes: [])
    }
    
}






























