import Foundation





class FileTypes {
    
    class func getMimeType(forPathExtension pathExtension: String) -> String {
        switch pathExtension {
        case FileExtensions.xhtml: return MimeTypes.xhtml
        case FileExtensions.css: return MimeTypes.css
        case FileExtensions.jpg: return MimeTypes.jpg
        case FileExtensions.png: return MimeTypes.png
        case FileExtensions.md: return MimeTypes.md
        case FileExtensions.ncx: return MimeTypes.ncx
        default: return MimeTypes.binary
        }
    }
    
}

enum MimeTypes {
    static let xhtml = "application/xhtml+xml"
    static let css = "text/css"
    static let jpg = "image/jpeg"
    static let png = "image/png"
    static let md = "text/plain"
    static let ncx = "application/x-dtbncx+xml"
    static let binary = "application/octet-stream"
}

enum FileExtensions {
    static let xhtml = "xhtml"
    static let css = "css"
    static let jpg = "jpg"
    static let png = "png"
    static let md = "md"
    static let ncx = "ncx"
    static let binary = "binary"
}






























