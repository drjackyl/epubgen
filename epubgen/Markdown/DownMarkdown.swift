/**
 A wrapper-class for the "Down" Markdown-renderer
 */
class DownMarkdown: MarkdownConverter {
    
    // MARK: - MarkdownConverter
    
    func convertMarkdownToHtml(markdown: String) -> String {
        do {
            return try Down(markdownString: markdown).toHTML()
        } catch let error {
            Output.printStdErr(message: "Failed to render Markdown using 'Down': \(error)")
            return PlainMarkdown().convertMarkdownToHtml(markdown:markdown)
        }
    }
    
}






























