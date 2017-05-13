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
        help += "4. Put together an unzipped EPUB-package using the metadata and found files\n"
        help += "   in a temporary-directory.\n"
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






























