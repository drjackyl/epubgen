import Foundation





protocol MarkdownConverter {
    
    /**
     Converts the given Markdown-string to HTML
     
     - Parameter markdown: Text formatted in Markdown
     - Returns: HTML converted from the given Markdown-string
     */
    func convertMarkdownToHtml(markdown: String) -> String
    
}






























