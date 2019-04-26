import Foundation





/**
 Capable of writing EPUB2-data to the filesystem.
 */
class Epub2Writer {
    
    /**
     Initialize the writer with the given Epub, destination and optionally files to include in the EPUB
     
     The Epub2Writer will create an EPUB2-conform structure with metadata-files. The inclusion of existing files into
     the created package can optionally be induced by providing an array of `EpubFileInclude`s. If provided, the
     Epub2Writer will copy these files to the destination.
     
     - Important: Providing an array of `EpubFileInclude`s will not automatically add these files to the EPUB's
       metadata (manifest, spine and/or guide of content.opf, toc.ncx).
     
       Furthermore the Epub2Writer will not validate, whether all referenced files are present in the manifest. The user
       of the writer has to make sure, the EPUB's metadata and provided files are arranged correctly.
     
     - Parameter epub: The Epub2-instance to write.
     - Parameter destination: The URL to write the EPUB to.
     - Parameter filesToInclude: Optional files to include in the EPUB.
     */
    init(epub: Epub2, destination: URL, filesToInclude: [EpubFileInclude] = [EpubFileInclude]()) {
        self.epub = epub
        self.destination = destination
        self.packageFolderUrl = destination.appendingPathComponent(epub.containerXml.packageFilePath).deletingLastPathComponent()
        self.filesToInclude = filesToInclude
    }
    
    
    
    
    
    // MARK: - Public
    
    /**
     Writes the epub asynchronously
     
     - Parameter completion: The completion-block being executed, when the write-operation has been completed.
     - Parameter error: Has a value if an error occurred.
     */
    func write(completion: @escaping (_ error: Error?) -> Void) {
        dispatchQueue.async {
            do {
                try self.createEpubScaffolding()
                try self.writeMetaData()
                try self.writeContentFiles()
                try self.copyFilesToInclude()
                completion(nil)
            } catch let error {
                completion(error)
            }
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    fileprivate let epub: Epub2
    fileprivate let destination: URL
    fileprivate let packageFolderUrl: URL
    fileprivate var filesToInclude: [EpubFileInclude]
    
    fileprivate let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "\(Epub2Writer.self)")
    fileprivate let fileIO = FileManager()
    
    fileprivate func createEpubScaffolding() throws {
        let metaInfUrl = destination.appendingPathComponent("META-INF")
        try fileIO.createDirectory(at: metaInfUrl, withIntermediateDirectories: false, attributes: [:])
        
        let containerXmlUrl = metaInfUrl.appendingPathComponent("container.xml")
        let containerXmlData = epub.containerXml.convertToXmlDocument().xmlData(options: XMLNode.Options(rawValue: XMLNode.Options.RawValue(Int(XMLNode.Options.nodePrettyPrint.rawValue))))
        try containerXmlData.write(to: containerXmlUrl, options: Data.WritingOptions.atomic)
        
        try fileIO.createDirectory(at: packageFolderUrl, withIntermediateDirectories: false, attributes: [:])
        
        let mimetypeUrl = destination.appendingPathComponent("mimetype")
        try "application/epub+zip".write(to: mimetypeUrl, atomically: true, encoding: String.Encoding.utf8)
    }
    
    fileprivate func writeMetaData() throws {
        let contentOpfUrl = destination.appendingPathComponent(epub.containerXml.packageFilePath)
        let contentOpfData = epub.contentOpf.convertToXmlDocument().xmlData(options: XMLNode.Options(rawValue: XMLNode.Options.RawValue(Int(XMLNode.Options.nodePrettyPrint.rawValue))))
        try contentOpfData.write(to: contentOpfUrl, options: Data.WritingOptions.atomic)
        
        let tocNcxUrl = packageFolderUrl.appendingPathComponent(epub.tocNcx.filename)
        let tocNcxData = epub.tocNcx.convertToXmlDocument().xmlData(options: XMLNode.Options(rawValue: XMLNode.Options.RawValue(Int(XMLNode.Options.nodePrettyPrint.rawValue))))
        try tocNcxData.write(to: tocNcxUrl, options: Data.WritingOptions.atomic)
    }
    
    fileprivate func writeContentFiles() throws {
        for xhtmlDocument in epub.xhtmlDocuments {
            let xmlDocument = xhtmlDocument.convertToXmlDocument()
            let xmlData = xmlDocument.xmlData(options: XMLNode.Options(rawValue: XMLNode.Options.RawValue(Int(XMLNode.Options.nodePrettyPrint.rawValue))))
            let destinationUrl = self.packageFolderUrl.appendingPathComponent(xhtmlDocument.filename)
            try xmlData.write(to: destinationUrl, options: Data.WritingOptions.atomic)
        }
    }
    
    fileprivate func copyFilesToInclude() throws {
        for fileToInclude in filesToInclude {
            let destinationUrl = self.packageFolderUrl.appendingPathComponent(fileToInclude.pathInPackage)
            try self.createParentFolderIfNeeded(url: destinationUrl)
            try self.fileIO.copyItem(at: fileToInclude.fileUrl, to: destinationUrl)
        }
    }
    
    fileprivate func createParentFolderIfNeeded(url: URL) throws {
        let parentFolderUrl = url.deletingLastPathComponent()
        if self.fileIO.fileExists(atPath: parentFolderUrl.path) {
            // If the parent exists, it doesn't have to be created. If the parrent is a file, the copy itself will fail.
            // Hence no need to throw here.
            return
        }
        
        try self.fileIO.createDirectory(at: parentFolderUrl, withIntermediateDirectories: true, attributes: nil)
    }
    
}






























