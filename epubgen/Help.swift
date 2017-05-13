import Foundation





class Help {
    
    class func printShortHelp(executableName: String) {
        var help = ""
        
        help += "usage:\n"
        help += "    \(executableName) <config-file-name>\n"
        help += "    \n"
        help += "    \(executableName) --help\n"
        help += "\n"
        
        Output.printStdOut(message: help)
    }
    
    class func printHelp(executableName: String) {
        var help = ""
        
        help += "usage:\n"
        help += "    \(executableName) <config-file-name>\n"
        help += "    \n"
        help += "    \(executableName) --help\n"
        help += "\n"
        help += "## What \(executableName) Does\n"
        help += "\n"
        help += "1. Read the config-file containing metadata for the EPUB.\n"
        help += "2. Set the base-path for all operations to the folder containing the\n"
        help += "   config-file.\n"
        help += "3. Find all files within the base-path including files in subdirectories.\n"
        help += "4. If a file is a Markdown-file, convert it to XHTML.\n"
        help += "5. Put together an unzipped EPUB-package using the metadata and\n"
        help += "   found/converted files in a temporary-directory.\n"
        help += "\n"
        help += "\n"
        help += "\n"
        help += "## Config-files\n"
        help += "\n"
        help += "In the config-file, metadata for the EPUB is defined. \n"
        help += "\n"
        help += "* The format is a rather simple \"Key: Value\"-format.\n"
        help += "* Lines that don't begin with \"\\w\" are ignored. So you can for example use\n"
        help += "  the common \"#\" to start a comment-line.\n"
        help += "* Missing values in the config will be empty in the EPUB.\n"
        help += "* All content-files (.md or .xhtml) will be added to the spine in the order\n"
        help += "  of their filename.\n"
        help += "* Content-files without title-mapping in the config will not be added to the\n"
        help += "  ToC.\n"
        help += "\n"
        help += "An example with all keys:\n"
        help += "\n"
        help += "```\n"
        help += "# The author's name. Used in content.opf for <dc:creator>.\n"
        help += "author: Ted Tester\n"
        help += "\n"
        help += "# The language-code of the book's language. Used in content.opf\n"
        help += "# for <dc:language>.\n"
        help += "language: de-DE\n"
        help += "\n"
        help += "# The copyright-info for the book. Used in content.opf for <dc:rights>.\n"
        help += "copyright: A copyright-hint\n"
        help += "\n"
        help += "# The book's title. Used in content.opf for <dc:title> and in toc.xhtml\n"
        help += "# for <title>\n"
        help += "title: The Title Of The Book\n"
        help += "\n"
        help += "# The book's unique identifier. Used in content.opf for <dc:identifier>\n"
        help += "identifier: a.unique.identifier\n"
        help += "\n"
        help += "# The book's publication-date. Used in content.opf for <dc:date>.\n"
        help += "date: 2017-06-01T12:00:00Z\n"
        help += "\n"
        help += "# The description-text for the book. Used in content.opf for <dc:description>\n"
        help += "description: A description-text of the book.\n"
        help += "\n"
        help += "# The path (within the package) to the cover-image-file.\n"
        help += "cover: the-image-file-to-use-as-cover.jpg\n"
        help += "\n"
        help += "# An optional CSS-file to add to all generated XHTML-files.\n"
        help += "style: the-css-file-to-use-for-style.css\n"
        help += "\n"
        help += "# A list of mappings from content-files (.xhtml or .md) to titles in the\n"
        help += "# EPUB's table of contents (toc.xhtml)\n"
        help += "01-cover.md: Cover\n"
        help += "02-title.md: Title\n"
        help += "03-imprint.md: Imprint\n"
        help += "04-chapter1.md: Chaper 1\n"
        help += "05-chapter2.md: Chapter 2\n"
        help += "```\n"
        help += "\n"
        help += "You can copy/paste this block into a new text-file and save it to the folder\n"
        help += "containing your content-files. The name can be anything, as long as you can\n"
        help += "give it as an argument to \(executableName).\n"
        help += "\n"
        help += "\n"
        help += "## Todo / Known Issues\n"
        help += "\n"
        help += "* Support files in subdirectories in package-files.  \n"
        help += "  Currently, files in subdirectories are found and copied into the package,\n"
        help += "  but the package's files (content.opf and toc.xhtml) are put together only\n"
        help += "  using the filename.  \n"
        help += "  Workaround: All files need to be located in the base-path of the package,\n"
        help += "  so the hrefs in the package-files are correct.\n"
        help += "* Move the generated package somewhere convenient.\n"
        help += "  Currently the package is generated in a temporary-directory, which doesn't\n"
        help += "  get removed, so the user can access the result. The path is shown after\n"
        help += "  generating the package has finished.  \n"
        help += "  Instead, epubgen should provide a command-line-argument to define a\n"
        help += "  destination for the package. If the user doesn't provide a destination,\n"
        help += "  the generated package should be moved to the base-path.\n"
        help += "* Create an actual .epub-file from the generated package.\n"
        help += "* Command-line-arguments.\n"
        help += "  Extendible handling of command-line-arguments, so \(executableName) can be\n"
        help += "  extended with further options.\n"
        help += "\n"
        
        Output.printStdOut(message: help)
    }
    
}






























