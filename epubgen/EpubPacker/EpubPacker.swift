protocol EpubPacker {
    
    /**
     Packs the epub-package at the given packageUrl to the given destination-URL
     
     - Parameter packageUrl: The url to the directory containing the EPUB-package.
     - Parameter destination: The url of the EPUB-file to create.
     - Throws: Any error that occurrs while packing.
     */
    func packPackage(at packageUrl: URL, to destination: URL, completion: @escaping (_ error: Error?) -> Void)
    
}






























