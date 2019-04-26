# epubgen

A Swift 4-based command-line generator for EPUBs.

## About

With epubgen you can generate EPUB-files (v2 and v3) from a folder containing Markdown, a cover image file a config file and optionally a CSS-file for the rendered Markdown-files.

The config file contains metadata for the EPUB. A sample file can be created using `epubgen --create-configfile`.

Read the help using `epubgen --help` for more information about the config-file and limitations of the tool.

By running `epubgen [path-to-config-file]` epubgen will start to generate the EPUB. By default an EPUB3 is being generated. By using the option `--epub2` an EPUB2 is being generated.

Currently, binaries are not available. To use the tool, you need to build it yourself.

## Building

**Requirements:**

* macOS 10.12
* Xcode 9, Swift 4

**Steps:**

* Clone the repository.
* Open `epubgen.xcodeproj` in Xcode.
* Archive a build using *Product → Archive*.
* Export the build-products and move the binary to an appropriate location.

## Limitations

* Currently subfolders are not entirely supported. Files in subfolders are copied and included in the package, but the folder structure is lost, will be flat, ie all files will be in the OEBPS-folder. So if you want to use subfolders to structure your data, make sure to use unique filenames.
* Filenames of content-files must match the RegEx `[\w-_.]` (no space), so they can have toc-entries in the config-file.

## ToDos

* Entirely support subfolders, to improve the user's freedom of how to structure the data.
* Provide a command-line-argument to ommit packing, but copy the unzipped package instead.
* Refine key-value-RegEx: `^\s*([\w-_.]+) *: *(.*)`
* Command-line-arguments.  
  Extendible handling of command-line-arguments, so epubgen can be extended with further options.

Any other ideas?

The tool currently fits our production process. As my time is quite limited, further development is very demand-driven. Nice-to-haves will probably not be implemented ;-)

## History & Credits

epubgen started as a script to automate the process of creating EPUBs for my Mom's ebooks. Over time, this has become a command line tool capable of creating an EPUB-file from a folder containing Markdown-files.

As some private data was part of the repository I was developing with, I imported the releases to include some code-history here on GitHub.

First of all, I want to thank my Mom for writing books and willing to publish them as DRM-free EPUBs on several platforms. Nobody needs DRM-poisoned golden cages, like iBooks or Kindle. The work on your eBooks was a delightful experience and gave me the opportunity to write this nice little tool.

Further, I want to thank:

* The guys from [commonmark.org](http://commonmark.org) and [John MacFarlane](https://github.com/jgm) for providing [cmark](https://github.com/jgm/cmark).
* [Rob Phillips](https://github.com/iwasrobbed) for providing [Down](https://github.com/iwasrobbed/Down), a framework for "blazing fast Markdown rendering in Swift, built upon cmark."
* [Glen Low](https://github.com/pixelglow) for providing [ZipZap](https://github.com/pixelglow/ZipZap), a library to handle zip-files including the rare combination of being able to add single archive-entries with different copressions - which is needed for creating valid EPUB-files.

## Disclaimer

I am not responsible for any problems resulting from using this tool. What you get here is code. Building and executing it is your responsibility.