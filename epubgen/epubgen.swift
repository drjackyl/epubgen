import Foundation





class epubgen {
    
    // MARK: - Public
    
    func generateEpub(withConfig configFileURL: URL, completion: @escaping () -> Void) {
        self.completion = completion
        self.sourceDirectory = configFileURL.deletingLastPathComponent()
        self.configFilename = configFileURL.lastPathComponent
        textFileReader.readTextFile(at: configFileURL) { (configString: String?, error: Error?) in
            guard let configString = configString else {
                Output.printStdErr(message: "Failed reading config: \(error as Optional)")
                Output.printStdErr(message: "Aborting.")
                return
            }
            
            Output.printStdOut(message: "Config read")
            self.parseConfig(configString: configString)
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "generator")
    let textFileReader = TextFileReader()
    let configFileParser = ConfigFileParser()
    let fileFinder = FileFinder()
    
    var sourceDirectory = URL(fileURLWithPath: Constants.bundleId, relativeTo: URL(fileURLWithPath: NSTemporaryDirectory()))
    var configFilename = "epubgen.cfg"
    var config = Config()
    var filesToProcess = [URL]()
    var filesToInclude = [EpubFileInclude]()
    var workingDirectory: TemporaryDirectory? = nil
    var completion: (() -> Void)?
    
    fileprivate func parseConfig(configString: String) {
        configFileParser.parse(configFile: configString) { (config: Config) in
            Output.printStdOut(message: "Config parsed")
            self.config = config
            self.findFiles(at: self.sourceDirectory)
        }
    }
    
    fileprivate func findFiles(at fileURL: URL) {
        fileFinder.listFilesIncludingSubdirectories(at: fileURL, completion: { (fileURLs, error) in
            if error != nil {
                self.finish()
                return
            }
            
            Output.printStdOut(message: "Found \(fileURLs.count) files")
            self.filesToProcess = fileURLs
            self.generatePackage()
        })
    }
    
    fileprivate func generatePackage() {
        Output.printStdOut(message: "Generating package")
        dispatchQueue.async {
            let epub = Epub()
            
            self.processMetadata(config: self.config, epub: epub)
            self.processFiles(files: self.filesToProcess, tocEntries: self.config.tocEntries, epub: epub)
            
            let tocXhtmlId = ContentOpf.createItemUUID()
            epub.contentOpf.manifest.addNavItem(id: tocXhtmlId, href: "toc.xhtml", mediaType: MimeTypes.xhtml)
            
            do {
                self.workingDirectory = try TemporaryDirectory.create()
                let writer = EpubWriter(epub: epub, destination: self.workingDirectory!.url, filesToInclude: self.filesToInclude)
                writer.write(completion: { (error) in
                    if let error = error {
                        Output.printStdErr(message: "Failed to write package:\n    \(error)")
                        Output.printStdErr(message: "aborting.")
                        self.finish()
                    } else {
                        Output.printStdOut(message: "Created package at \(self.workingDirectory!.url.path)")
                        self.packEpub()
                    }
                })
            } catch {
                Output.printStdErr(message: "\(error)")
                self.finish()
            }
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
    
    /**
     Processes the files found by FileFinder and adds them to the package
     
     - ToDo: Support for files in subfolders of the package. Currently the file-name (lastPathComponent) is used as the
         item's href-value. If a file is located in a subfolder, the href will be broken.
     */
    fileprivate func processFiles(files: [URL], tocEntries: [String: String], epub: Epub) {
        let sortedFiles = files.sorted(by: { (url1, url2) -> Bool in
            return url1.lastPathComponent.localizedStandardCompare(url2.lastPathComponent) == ComparisonResult.orderedAscending
        })
        
        for fileURL in sortedFiles {
            guard fileURL.lastPathComponent != self.configFilename else {
                continue
            }
            
            var includeFile = true
            
            let fullFileName = fileURL.lastPathComponent
            let fileName = fileURL.deletingPathExtension().lastPathComponent
            let fileExtension = fileURL.pathExtension
            let itemId = ContentOpf.createItemUUID()
            
            if fileExtension == FileExtensions.xhtml {
                epub.contentOpf.spine.addItemref(idref: itemId)
                
                if let tocEntry = tocEntries[fullFileName] {
                    epub.tocXhtml.addTocEntry(name: tocEntry, fileName: fullFileName)
                }
            }
            
            if fileExtension == FileExtensions.md {
                includeFile = false
                
                do {
                    let markdown = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
                    let html = Markdown.converter.convertMarkdownToHtml(markdown: markdown)
                    let xhtmlTitle = tocEntries[fullFileName] ?? fileName
                    let xhtmlDocument = XhtmlDocument(filename: "\(fileName).xhtml", title: xhtmlTitle, styleHref: config.style, body: html)
                    Output.printStdOut(message: "Converted \(fullFileName)")
                    epub.add(xhtmlDocument: xhtmlDocument, tocTitle: tocEntries[fullFileName])
                } catch let error {
                    Output.printStdErr(message: "Failed to convert Markdown-file at\n    \(fileURL)\n\(error)")
                    continue
                }
            }
            
            if fullFileName == config.coverImageFilePath {
                epub.contentOpf.metadata.coverItemRef = itemId;
            }
            
            if includeFile {
                epub.contentOpf.manifest.addItem(id: itemId, href: fullFileName, mediaType: FileTypes.getMimeType(forPathExtension: fileExtension))
                filesToInclude.append(EpubFileInclude(fileAt: fileURL, pathInPackage: fullFileName))
            }
        }
    }
    
    fileprivate func packEpub() {
        let destinationUrl = getDestinationUrlForEpubFile()
        Packer.epub.packPackage(at: self.workingDirectory!.url, to: destinationUrl, completion: { (error) in
            if let error = error {
                Output.printStdErr(message: "Failed to create epub\n    \(error)")
                Output.printStdErr(message: "aborting.")
                self.finish()
            } else {
                Output.printStdOut(message: "Created epub at \(destinationUrl.path)")
                self.finish()
            }
        })
    }
    
    fileprivate func getDestinationUrlForEpubFile() -> URL {
        if let filenameInConfig = config.epubFilename {
            return URL(fileURLWithPath: filenameInConfig, relativeTo: self.sourceDirectory)
        } else {
            return URL(fileURLWithPath: "\(UUID().uuidString).epub", relativeTo: self.sourceDirectory)
        }
    }
    
    fileprivate func finish() {
        if let workingDir = self.workingDirectory {
            if FileManager.default.fileExists(atPath: workingDir.url.path) {
                do {
                    try workingDir.delete()
                    Output.printStdOut(message: "Temporary files deleted")
                } catch let error {
                    var errorMessage = ""
                    errorMessage += "Failed to delete temporary files at\n"
                    errorMessage += "    \(workingDir.url.path)\n"
                    errorMessage += "\(error)\n"
                    errorMessage += "\n"
                    errorMessage += "Those files will be deleted by macOS after three days."
                    Output.printStdErr(message: errorMessage)
                }
            }
        }
        completion?()
    }
    
}































