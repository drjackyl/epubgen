import Foundation





/**
 TBD
 
 - Attention:
    Limitations: The keys can only contain \w, -, _ and .
 */
class Config: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: Config-Properties
    
    /// The author's name. Used in content.opf for <dc:creator>.
    var author = ""
    
    /// The book's title. Used in content.opf for <dc:title> and in toc.xhtml for <title>
    var title = ""
    
    /// The description-text for the book. Used in content.opf for <dc:description>
    ///
    /// - Remark: As "description" is occupied by Swift's CustomStringConvertible, this is "bookDescription", while the
    ///           related key in the config-file is "description".
    var bookDescription = ""
    
    /// The language-code of the book's language. Used in content.opf for <dc:language>.
    ///
    /// - Remark: This is expected to be an RFC5646 language-code.
    var language = ""
    
    /// The copyright-info for the book. Used in content.opf for <dc:rights>.
    var copyright = ""
    
    /// The book's publication-date. Used in content.opf for <dc:date>.
    ///
    /// - Remark: This is expected to be an ISO8601 date-string.
    var date = ""
    
    /// The book's unique identifier. Used in content.opf for <dc:identifier>
    var identifier = ""
    
    /// The path (within the package) to the cover-image-file
    var coverImageFilePath = ""
    
    /// An optional CSS-file to add to generated XHTML-files
    var style: String? = nil
    
    /// A dictionary mapping content-filenames to toc-entries
    var tocEntries = [String: String]()
    
    
    
    
    
    // MARK: - Public
    
    init() {}
    
    init(configDictionary: [String: String]) {
        process(configDictionary: configDictionary)
    }
    
    
    
    
    
    // MARK: - Private
    
    func process(configDictionary: [String: String]) {
        if let author = configDictionary["author"] {
            self.author = author
        }
        
        if let title = configDictionary["title"] {
            self.title = title
        }
        
        if let description = configDictionary["description"] {
            self.bookDescription = description
        }
        
        if let language = configDictionary["language"] {
            self.language = language
        }
        
        if let copyright = configDictionary["copyright"] {
            self.copyright = copyright
        }
        
        if let date = configDictionary["date"] {
            self.date = date
        }
        
        if let identifier = configDictionary["identifier"] {
            self.identifier = identifier
        }
        
        if let cover = configDictionary["cover"] {
            self.coverImageFilePath = cover
        }
        
        if let style = configDictionary["style"] {
            self.style = style
        }
        
        configDictionary.keys.forEach { (key) in
            if key.hasSuffix(".\(FileExtensions.xhtml)") || key.hasSuffix(".\(FileExtensions.md)") {
                self.tocEntries.updateValue(configDictionary[key]!, forKey: key)
            }
        }
    }
    
    
    
    
    
    // MARK: - CustomStringConvertible
    public var description: String {
        get {
            return "Config:\n" +
                "    author: \"\(author)\"\n" +
                "    title: \"\(title)\"\n" +
                "    description: \"\(bookDescription)\"\n" +
                "    language: \"\(language)\"\n" +
                "    copyright: \"\(copyright)\"\n" +
                "    date: \"\(date)\"\n" +
                "    identifier: \"\(identifier)\"\n" +
                "    cover: \"\(coverImageFilePath)\"\n" +
                "    style: \"\(style ?? "<not configured>")" +
                tocEntries.reduce("    tocEntries:\n") { (current, element: (key: String, value: String)) -> String in
                    return current + "        \(element.key): \(element.value)\n"
            }
        }
    }
    
    // MARK: - CustomDebugStringConvertible
    public var debugDescription: String {
        get {
            return "Config:\n" +
                "    author: \"\(author)\"\n" +
                "    title: \"\(title)\"\n" +
                "    description: \"\(bookDescription)\"\n" +
                "    language: \"\(language)\"\n" +
                "    copyright: \"\(copyright)\"\n" +
                "    date: \"\(date)\"\n" +
                "    identifier: \"\(identifier)\"\n" +
                "    cover: \"\(coverImageFilePath)\"\n" +
                "    style: \"\(style ?? "<not configured>")" +
                tocEntries.reduce("    tocEntries:\n") { (current, element: (key: String, value: String)) -> String in
                    return current + "        \(element.key): \(element.value)\n"
            }
        }
    }
}






























