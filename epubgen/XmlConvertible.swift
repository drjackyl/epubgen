import Foundation





protocol XmlDocumentConvertible {
    
    /**
     The implementation shall convert the implementing type to an XMLDocument
     
     - Returns: An XMLDocument representing the implementing type's instance.
     */
    func convertToXmlDocument() -> XMLDocument
    
}

protocol XmlNodeConvertible {
    
    /**
     The implementation shall convert the implementing type to an XMLNode
    
     - Returns: An XMLNode representing the implementing type's instance
     */
    func convertToXmlNode() -> XMLNode
    
}






























