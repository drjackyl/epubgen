import Foundation





class epubgen {
    
    // MARK: - Public
    
    func generateEpub(withConfig configFileURL: URL, completion: @escaping (Void) -> Void) {
        self.completion = completion
        self.sourceDirectory = configFileURL.deletingLastPathComponent()
        self.configFilename = configFileURL.lastPathComponent
        configFileReader.readConfigFile(at: configFileURL) { (configString: String?, error: Error?) in
            guard let configString = configString else {
                Output.printStdErr(message: "Failed reading config: \(error)")
                Output.printStdErr(message: "Aborting.")
                return
            }
            
            Output.printStdOut(message: "Config read")
            self.parseConfig(configString: configString)
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "generator")
    let configFileReader = ConfigFileReader()
    let configFileParser = ConfigFileParser()
    let fileFinder = FileFinder()
    
    var sourceDirectory = URL(fileURLWithPath: Constants.bundleId, relativeTo: URL(fileURLWithPath: NSTemporaryDirectory()))
    var configFilename = "epubgen.cfg"
    var config = Config()
    var filesToProcess = [URL]()
    var completion: ((Void) -> Void)?
    
    fileprivate func parseConfig(configString: String) {
        configFileParser.parse(configFile: configString) { (config: Config) in
            Output.printStdOut(message: "Config parsed")
            Output.printStdOut(message: "\(config)")
            self.config = config
            self.findFiles(at: self.sourceDirectory)
        }
    }
    
    fileprivate func findFiles(at fileURL: URL) {
        fileFinder.listFiles(at: fileURL, completion: { (fileURLs, error) in
            if error != nil {
                self.finish()
                return
            }
            
            self.filesToProcess = fileURLs
            self.generateEpub()
        })
    }
    
    fileprivate func generateEpub() {
        dispatchQueue.async {
            let epub = Epub()
            
            self.processMetadata(config: self.config, epub: epub)
            self.processFiles(files: self.filesToProcess, tocEntries: self.config.tocEntries, epub: epub)
            
            let tocXhtmlId = ContentOpf.ItemUUID()
            epub.contentOpf.manifest.addNavItem(id: tocXhtmlId, href: "toc.xhtml", mediaType: MimeTypes.xhtml)
            
            let contentOpfXml = epub.contentOpf.convertToXmlDocument().xmlString(withOptions: Int(XMLNode.Options.nodePrettyPrint.rawValue))
            Output.printStdOut(message: contentOpfXml)
            
            let tocXhtml = epub.tocXhtml.convertToXmlDocument().xmlString(withOptions: Int(XMLNode.Options.nodePrettyPrint.rawValue))
            Output.printStdOut(message: tocXhtml)
            
            self.finish()
        }
    }
    
    fileprivate func processMetadata(config: Config, epub: Epub) {
        epub.contentOpf.metadata.dcCreator = config.author
        epub.contentOpf.metadata.dcDate = config.date
        epub.contentOpf.metadata.dcDescription = config.bookDescription
        epub.contentOpf.metadata.dcIdentifier = config.identifier
        epub.contentOpf.metadata.dcLanguage = config.language
        epub.contentOpf.metadata.dcRights = config.copyright
        epub.contentOpf.metadata.dcTitle = config.title
        epub.tocXhtml.title = config.title
    }
    
    fileprivate func processFiles(files: [URL], tocEntries: [String: String], epub: Epub) {
        let sortedFiles = files.sorted(by: { (url1, url2) -> Bool in
            return url1.lastPathComponent.localizedStandardCompare(url2.lastPathComponent) == ComparisonResult.orderedAscending
        })
        
        for fileURL in sortedFiles {
            guard fileURL.lastPathComponent != self.configFilename else {
                continue
            }
            
            let fileName = fileURL.lastPathComponent
            let fileExtension = fileURL.pathExtension
            let itemId = ContentOpf.ItemUUID()
            
            if fileExtension == FileExtensions.xhtml {
                epub.contentOpf.spine.addItemref(idref: itemId)
                
                if let tocEntry = tocEntries[fileName] {
                    epub.tocXhtml.addTocEntry(name: tocEntry, fileName: fileName)
                }
            }
            
            epub.contentOpf.manifest.addItem(id: itemId, href: fileName, mediaType: FileTypes.getMimeType(forPathExtension: fileExtension))
        }
    }
    
    fileprivate func finish() {
        completion?()
    }
    
}































