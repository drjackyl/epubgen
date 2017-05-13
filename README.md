# epubgen

A Swift 3-based command-line generator for EPUBs.

## About

With epubgen you can generate EPUB-files from a folder containing Markdown, a cover image file a config file and optionally a CSS-file for the rendered Markdown-files.

The config file contains metadata for the EPUB. A sample file can be created using `epubgen --create-configfile`.

Read the help using `epubgen --help` for more information about the config-file and limitations of the tool.

By running `epubgen [path-to-config-file]` epubgen will start to generate the EPUB.

Currently, binaries are not available. To use the tool, you need to build it yourself.

## Building

**Requirements:**

* macOS 10.12
* Xcode 8.3, Swift 3

**Steps:**

* Clone the repository.
* Open `epubgen.xcodeproj` in Xcode.
* Archive a build using *Product → Archive*.
* Export the build-products and move the binary to an appropriate location.

## Limitations

* Currently subfolders are not supported. Even though files in subfolders are copied and included in the package, they won't be included in the content.opf correctly. An epubcheck will fail.
* Filenames of content-files must match the RegEx `[\w-_.]`, so they can have toc-entries in the config-file.

## ToDos

* Support files in subdirectories in package-files.  
  Currently, files in subdirectories are found and copied into the package, but the package's files (content.opf and toc.xhtml) are put together only using the filename.  
  Workaround: All files need to be located in the base-path of the package, so the hrefs in the package-files are correct.
* Provide a command-line-argument to ommit packing, but copy the unzipped
  package instead.
* Refine key-value-RegEx: `^\s*([\w-_.]+) *: *(.*)`m
* Command-line-arguments.  
  Extendible handling of command-line-arguments, so epubgen can be
  extended with further options.

Any other ideas?

The tool currently fits our production process. As my time is quite limited and I have another project pending, further development is going to pause until October 2017.

## History & Credits

epubgen started as a script to automate the process of creating EPUBs for my Mom's ebooks. Over time, this has become a command line tool capable of creating an EPUB-file from a folder containing Markdown-files.

As some private data was part of the repository I was developing with, I imported the releases to include some code-history here on GitHub.

First of all, I want to thank my Mom for writing books and willing to publish them as DRM-free EPUBs on several platforms. Nobody needs DRM-poisoned golden cages, like iBooks or Kindle. The work on your ebooks was a delightful experience and gave me the opportunity to write this nice little tool.

Further, I want to thank:

* The guys from [commonmark.org](http://commonmark.org) and [John MacFarlane](https://github.com/jgm) for providing [cmark](https://github.com/jgm/cmark).
* [Rob Phillips](https://github.com/iwasrobbed) for providing [Down](https://github.com/iwasrobbed/Down), a framework for "blazing fast Markdown rendering in Swift, built upon cmark."
* [Glen Low](https://github.com/pixelglow) for providing [ZipZap](https://github.com/pixelglow/ZipZap), a library to handle zip-files including the rare combination of being able to add single archive-entries with different copressions - which is needed for creating valid EPUB-files.

## Disclaimer

I am not responsible for any problems resulting from using this tool. What you get here is code. Building and executing it is your responsibility.