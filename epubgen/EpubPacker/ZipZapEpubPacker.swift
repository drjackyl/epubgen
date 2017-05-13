/**
 A wrapper-class for a ZipZap-based EPUB-packer
 */
class ZipZapEpubPacker: EpubPacker {
    
    // MARK: - EpubPacker
    
    /**
     Packs the epub-package at the given packageUrl to the given destination-URL
     
     - Parameter packageUrl: The url to the directory containing the EPUB-package.
     - Parameter destination: The url of the EPUB-file to create.
     - Parameter completion: Will be executed after packing or in case of error.
     - Parameter error: Contains an error, if any error occurred while packing.
     */
    func packPackage(at packageUrl: URL, to destination: URL, completion: @escaping (_ error: Error?) -> Void) {
        dispatchQueue.async {
            do {
                let zipArchive = try ZZArchive(url: destination, options: [ZZOpenOptionsCreateIfMissingKey: true])
                let mimetypeEntry = try self.createArchiveEntryForMimetypeFileOfPackage(at: packageUrl)
                self.createArchiveEntriesForFilesInPackage(at: packageUrl, completion: { (archiveEntries, error) in
                    if let error = error {
                        completion(error)
                    } else {
                        var allEntries = [ZZArchiveEntry]()
                        allEntries.append(mimetypeEntry)
                        allEntries.append(contentsOf: archiveEntries)
                        self.update(archive: zipArchive, with: allEntries, completion: completion)
                    }
                })
            } catch let error {
                completion(error);
            }
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "ZipZapEpubPacker")
    
    fileprivate func createArchiveEntryForMimetypeFileOfPackage(at packageUrl: URL) throws -> ZZArchiveEntry {
        let mimetypeUrl = packageUrl.appendingPathComponent("mimetype")
        let mimetypeData = try Data(contentsOf: mimetypeUrl)
        let archiveEntry = ZZArchiveEntry(fileName: mimetypeUrl.lastPathComponent, compress: false, dataBlock: { (nsErrorPointer) -> Data? in
                                            return mimetypeData
        })
        return archiveEntry
    }
    
    fileprivate func createArchiveEntriesForFilesInPackage(at packageUrl: URL, completion: @escaping (_ archiveEntries: [ZZArchiveEntry], _ error: Error?) -> Void) {
        let fileFinder = FileFinder()
        fileFinder.listFilesIncludingSubdirectories(at: packageUrl) { (fileUrls, error) in
            self.createArchiveEntries(for: fileUrls, completion: completion)
        }
    }
    
    fileprivate func createArchiveEntries(for fileUrls: [URL], completion: (_ archiveEntries: [ZZArchiveEntry], _ error: Error?) -> Void) {
        var archiveEntries = [ZZArchiveEntry]()
        do {
            for fileUrl in fileUrls {
                if fileUrl.lastPathComponent == "mimetype" {
                    continue
                }
                let fileData =  try Data(contentsOf: fileUrl)
                let archiveEntry = ZZArchiveEntry(fileName: fileUrl.relativePath, compress: true, dataBlock: { (nsErrorPointer) -> Data? in
                    return fileData
                })
                archiveEntries.append(archiveEntry)
            }
            completion(archiveEntries, nil)
        } catch let error {
            completion([], error)
        }
    }
    
    fileprivate func update(archive: ZZArchive, with entries: [ZZArchiveEntry], completion: (_ error: Error?) -> Void) {
        do {
            try archive.updateEntries(entries)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
}






























