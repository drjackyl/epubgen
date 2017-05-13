import Foundation





class FileFinder {
    
    // MARK: - Public
    
    /**
     Lists files at a given file-URL
     
     - Remark: As filters for the result `URLResourceKey.isRegularFileKey` and
         `FileManager.DirectoryEnumerationOptions.skipsHiddenFiles` is used, the result contains only regular
         files. No hidden files, symlinks, aliases, resource-forks or directories.
         
         The returned list of files does not contain files in subdirectories.
     
     - Parameter url: The url to a directory to list files of.
     - Parameter completion: An escaping completion-block providing the list of file-URLs. If an error occurred, an
         empty list of file-URLs is provided and the error has a value.
     - Parameter fileURLs: The list of file-URLs at the given directory.
     - Parameter error: Has a value, when an error occurred.
     */
    func listFiles(at url: URL, completion: @escaping (_ fileURLs: [URL], _ error: Error?) -> Void) {
        dispatchQueue.async {
            do {
                let urls = try self.fileIO.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                let fileURLs = self.filterFileURLs(urls: urls)
                completion(fileURLs, nil)
            } catch let error {
                completion([URL](), error)
            }
        }
    }
    
    /**
     Lists files at a given file-URL of a given type
     
     - Remark: As filters for the result URLResourceKey.isRegularFileKey and
         FileManager.DirectoryEnumerationOptions.skipsHiddenFiles is used, the result contains only
         regular files. No hidden files, symlinks, aliases, resource-forks or directories.
         
         The type-comparison uses lastPathComponent with a case-sensitive comparison.
     
         The returned list of files does not contain files in subdirectories.
     
     - Parameter url: The url to a directory to list files of.
     - Parameter type: The file-extension to include in the list of files.
     - Parameter completion: An escaping completion-block providing the list of file-URLs. If an error occurred, an
         empty list of file-URLs is provided and the error has a value.
     - Parameter fileURLs: The list of file-URLs at the given directory.
     - Parameter error: Has a value, when an error occurred.
     */
    func listFiles(at url: URL, ofType type: String, completion: @escaping (_ fileURLs: [URL], _ error: Error?) -> Void) {
        dispatchQueue.async {
            do {
                let urls = try self.fileIO.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                let fileURLs = self.filterFileURLs(urls: urls, ofType: type)
                completion(fileURLs, nil)
            } catch let error {
                completion([URL](), error)
            }
        }
    }
    
    /**
     Lists files at a given file-URL including files in subdirectories
     
     - Remark: As filters for the result URLResourceKey.isRegularFileKey and
         FileManager.DirectoryEnumerationOptions.skipsHiddenFiles is used, the result contains only
         regular files. No hidden files, symlinks, aliases, resource-forks or directories.
     
     - Parameter url: The url to a directory to list files of.
     - Parameter completion: An escaping completion-block providing the list of file-URLs. If an error occurred, an
         empty list of file-URLs is provided and the error has a value.
     - Parameter fileURLs: The list of file-URLs at the given directory.
     - Parameter error: Has a value, when an error occurred.
     */
    func listFilesIncludingSubdirectories(at url: URL, completion: @escaping (_ fileURLs: [URL], _ error: Error?) -> Void) {
        dispatchQueue.async {
            var urls = [URL]()
            guard let enumerator = self.fileIO.enumerator(at: url, includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) else {
                completion([URL](), nil)
                return
            }
            while let object = enumerator.nextObject() {
                guard let url = object as? URL else {
                    continue
                }
                guard let isFile = url.isRegularFileResourceValue, isFile else {
                    continue
                }
                urls.append(url)
            }
            completion(urls, nil)
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "FileFinder")
    let fileIO = FileManager()
    
    fileprivate func filterFileURLs(urls: [URL]) -> [URL] {
        return urls.filter({ (url) -> Bool in
            do {
                let resourceValues = try url.resourceValues(forKeys: [URLResourceKey.isRegularFileKey])
                guard let isRegularFile = resourceValues.isRegularFile else {
                    return false
                }
                return isRegularFile
            } catch {
                return false
            }
        })
    }
    
    fileprivate func filterFileURLs(urls: [URL], ofType type: String) -> [URL] {
        return urls.filter({ (url) -> Bool in
            do {
                let resourceValues = try url.resourceValues(forKeys: [URLResourceKey.isRegularFileKey])
                guard let isRegularFile = resourceValues.isRegularFile else {
                    return false
                }
                return isRegularFile && url.lastPathComponent.hasSuffix(type)
            } catch {
                return false
            }
        })
    }
    
}






























