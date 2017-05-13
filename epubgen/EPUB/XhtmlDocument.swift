import Foundation





/**
 Represents content as an XHTML-document
 
 ## The minimum viable XHTML for EPUBs
 
 ````
 <?xml version="1.0" encoding="utf-8" standalone="no"?>
 <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
 <head>
     <title></title>
     <meta charset="UTF-8" />
 </head>
 <body>
 </body>
 </html>
 ````
 
 Optional style-attribute in the head-section:
 
 ````
 <link rel="stylesheet" type="text/css" href="[path-to-css-file]" />
 ````
 */
class XhtmlDocument: XmlDocumentConvertible {
    
    // MARK: - Private Properties
    
    fileprivate let title: String
    fileprivate let styleHref: String?
    fileprivate let body: String
    
    
    
    
    
    // MARK: - Public Properties
    
    let filename: String
    
    
    
    
    // MARK: - Initializers
    
    /**
     Initializes the XHTML-Document with the given data
     
     - Important: The body-string must be valid XHTML, so the conversion to NSXML works. If the conversion fails, the
       body will be empty in the XMLDocument, as the conversion-method doesn't throw.
     
     - Parameter filename: The filename of the XHTML-document within the EPUB
     - Parameter title: The string used as value for the title-tag in the head-section.
     - Parameter styleHref: The string used as value for the href-value of a stylesheet-link-element.
     - Parameter body: The body-content.
     */
    init(filename: String, title: String, styleHref: String?, body: String) {
        self.filename = filename
        self.title = title
        self.styleHref = styleHref
        self.body = body
    }
    
    
    
    
    
    // MARK: - XmlDocumentConvertible
    
    func convertToXmlDocument() -> XMLDocument {
        let htmlElement = createHtmlElement()
        
        let xhtmlDocument = XMLDocument(rootElement: htmlElement);
        xhtmlDocument.version = "1.0"
        xhtmlDocument.characterEncoding = "utf-8"
        xhtmlDocument.isStandalone = false
        
        return xhtmlDocument
    }
    
    fileprivate func createHtmlElement() -> XMLElement {
        let htmlAttributes = [
            XMLNode.attribute(name: "xmlns", value: "http://www.w3.org/1999/xhtml"),
            XMLNode.attribute(name: "xmlns:epub", value: "http://www.idpf.org/2007/ops")
        ]
        
        let htmlChildren = [
            createHeadElement(),
            createBodyElement()
        ]
        
        return XMLElement(name: "html", children: htmlChildren, attributes: htmlAttributes)
    }
    
    fileprivate func createHeadElement() -> XMLElement {
        var headChildren = [
            XMLElement(name: "title", stringValue: title),
            XMLElement(name: "meta", attributes: [
                XMLNode.attribute(name: "charset", value: "utf-8")
            ])
        ]
        
        if let style = styleHref {
            let styleElement = XMLElement(name: "link",
                                          attributes: [
                                              XMLNode.attribute(name: "rel", value: "stylesheet"),
                                              XMLNode.attribute(name: "type", value: "text/css"),
                                              XMLNode.attribute(name: "href", value: style)
                                          ])
            headChildren.append(styleElement)
        }
        
        return XMLElement(name: "head", children: headChildren, attributes: [])
    }
    
    fileprivate func createBodyElement() -> XMLElement {
        do {
            return try XMLElement(xmlString: "<body>\(body)</body>")
        } catch {
            return XMLElement(name: "body")
        }
    }
    
}






























