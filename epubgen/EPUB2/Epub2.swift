import Foundation




/**
 The model of an EPUB2 consisting of in-memory-data.
 
 Additional files can be added to the metadata, but are not managed by an Epub-instance.
 */
class Epub2 {
    
    // MARK: - Metadata
    
    let containerXml = ContainerXml(packageFilePath: "OEBPS/content.opf")
    let contentOpf = ContentOpfEpub2()
    let tocNcx = TocNcx()
    
    
    
    
    
    // MARK: - Content
    
    /**
     The list of XHTML-documents, that belong to the EPUB
     */
    fileprivate(set) var xhtmlDocuments = [XhtmlDocumentEpub2]()
    
    /**
     Adds the given XHTML-document to the EPUB
     
     All XHTML-documents are added to the spine.
     
     - Parameter xhtmlDocument: The XHTML-document to add to the EPUB.
     - Parameter tocTitle: If not nil, the entry is added to the toc.ncx.
     */
    func add(xhtmlDocument: XhtmlDocumentEpub2, tocTitle: String?, guideType: ContentOpfGuide.ReferenceType? = nil) {
        let itemId = ContentOpf.createItemUUID()
        contentOpf.manifest.addItem(id: itemId, href: xhtmlDocument.filename, mediaType: MimeTypes.xhtml)
        contentOpf.spine.addItemref(idref: itemId)
        if let tocTitle = tocTitle {
            tocNcx.addNavPoint(src: xhtmlDocument.filename, title: tocTitle)
        }
        if let guideType = guideType {
            // TODO: EPUB2: Guide reference title not supported
            contentOpf.guide.addReference(href: xhtmlDocument.filename, type: guideType, title: "")
        }
        xhtmlDocuments.append(xhtmlDocument)
    }
    
}






























