import Foundation





/**
 A wrapper-class for whatever markdown-renderer is used
 */
class PlainMarkdown: MarkdownConverter {
    
    // MARK: - MarkdownConverter
    
    func convertMarkdownToHtml(markdown: String) -> String {
        let escapedMarkdown = markdown.replacingOccurrences(of: "<", with: "&lt;")
        return "<pre>\(escapedMarkdown)</pre>"
    }
    
}






























