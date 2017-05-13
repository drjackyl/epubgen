import Foundation





class FileTypes {
    
    class func getMimeType(forPathExtension pathExtension: String) -> String {
        switch pathExtension {
        case FileExtensions.xhtml:
            return MimeTypes.xhtml
        case FileExtensions.css:
            return MimeTypes.css
        case FileExtensions.jpg:
            return MimeTypes.jpg
        default:
            return MimeTypes.binary
        }
    }
    
}

enum MimeTypes {
    static let xhtml = "application/xhtml+xml"
    static let css = "text/css"
    static let jpg = "image/jpeg"
    static let binary = "application/octet-stream"
}

enum FileExtensions {
    static let xhtml = "xhtml"
    static let css = "css"
    static let jpg = "jpg"
    static let binary = "binary"
}






























