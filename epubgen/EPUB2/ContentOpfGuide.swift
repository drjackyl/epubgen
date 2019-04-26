import Foundation





class ContentOpfGuide : XmlNodeConvertible {
    
    fileprivate var references = [XMLNode]()
    
    
    
    
    
    // MARK: - Public
    
    /**
     Adds an itemref-element
     
     - Attention: The function appends a new reference-element without checking of any value.
     
     ````
     <reference type="" title="" href=""></reference>
     ````
     
     - Parameter href: The href as used in the manifest.
     - Parameter type: The type of the reference, see `ReferenceType`.
     - Parameter title: The reference's title.
     */
    func addReference(href: String, type: ReferenceType, title: String) {
        let attributes: [XMLNode] = [
            XMLNode.attribute(name: "type", value: type.toString()),
            XMLNode.attribute(name: "title", value: title),
            XMLNode.attribute(name: "href", value: href)
        ]
        let referenceElement = XMLElement(name: "reference", attributes: attributes)
        references.append(referenceElement)
    }
    
    enum ReferenceType {
        case cover, title, toc, index, glossary, acknowledgements, bibliography, colophon, copyright, dedication, epigraph, foreword, loi, lot, notes, preface, text
        case other(name: String)
        
        func toString() -> String {
            switch self {
            case .cover: return "cover"
            case .title: return "title"
            case .toc: return "toc"
            case .index: return "index"
            case .glossary: return "glossary"
            case .acknowledgements: return "acknowledgements"
            case .bibliography: return "bibliography"
            case .colophon: return "colophon"
            case .copyright: return "copyright"
            case .dedication: return "dedication"
            case .epigraph: return "epigraph"
            case .foreword: return "foreword"
            case .loi: return "loi"
            case .lot: return "lot"
            case .notes: return "notes"
            case .preface: return "preface"
            case .text: return "text"
            case .other(let name): return "other.\(name)"
            }
        }
    }
    
    
    
    
    
    // MARK: - XmlNodeConvertible
    
    func convertToXmlNode() -> XMLNode {
        return XMLElement(name: "guide", children: references, attributes: [])
    }
}






























