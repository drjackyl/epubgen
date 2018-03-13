import Foundation





/**
 Capable of writing EPUB-data to the filesystem.
 */
class EpubWriter {
    
    fileprivate let epub: Epub
    fileprivate let destination: URL
    fileprivate let packageFolderUrl: URL
    fileprivate var filesToInclude: [EpubFileInclude]
    
    
    
    
    
    /**
     Initialize the writer with the given Epub, destination and optionally files to include in the EPUB
     
     The EpubWriter will create an EPUB-conform structure with metadata-files. The inclusion of existing files into the
     created package can optionally be induced by providing an array of `EpubFileInclude`s. If provided, the EpubWriter
     will copy these files to the destination.
     
     - Important: Providing an array of `EpubFileInclude`s will not automatically add these files to the EPUB's
       metadata (manifest and/or spine of content.opf, toc.xhtml).
     
       Furthermore the EpubWriter will not validate, whether all referenced files are present in the manifest. The user
       of the writer has to make sure, the EPUB's metadata and provided files are arranged correctly.
     
     - Parameter epub: The Epub-instance to write.
     - Parameter destination: The URL to write the EPUB to.
     - Parameter filesToInclude: Optional files to include in the EPUB.
     */
    init(epub: Epub, destination: URL, filesToInclude: [EpubFileInclude] = [EpubFileInclude]()) {
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
    
    let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "EpubWriter")
    let fileIO = FileManager()
    
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
        
        let tocXhtmlUrl = packageFolderUrl.appendingPathComponent(epub.contentOpf.manifest.navItemHref)
        let tocXhtmlData = epub.tocXhtml.convertToXmlDocument().xmlData(options: XMLNode.Options(rawValue: XMLNode.Options.RawValue(Int(XMLNode.Options.nodePrettyPrint.rawValue))))
        try tocXhtmlData.write(to: tocXhtmlUrl, options: Data.WritingOptions.atomic)
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





/**
 Provides the url of a file to include in the EPUB at the given path in the package.
 */
struct EpubFileInclude {
    
    /// The url of the file to include in the package.
    let fileUrl: URL
    
    /// The path in the package to copy the file to.
    let pathInPackage: String
    
    /**
     Initializes the include with the given URL and path in the package
     
     The path in the package is the path relative to the folder containing the OEBPS-package-file (content.opf).
     
     - Parameter url: The URL of the file to include in the packge.
     - Parameter path: The path in the package to copy the file to.
     */
    init(fileAt url: URL, pathInPackage path: String) {
        self.fileUrl = url
        self.pathInPackage = path
    }
    
}






























