import Foundation





class FileFinder {
    
    // MARK: - Public
    
    /**
     Lists files at a given file-URL
     
     - Remark:
         As filters for the result URLResourceKey.isRegularFileKey and 
         FileManager.DirectoryEnumerationOptions.skipsHiddenFiles is used. Hence the result contains only
         regular files. No hidden files, symlinks, aliases, resource-forks or directories.
     
     - Parameter fileURL: The file-URL (file://) to a directory to list files of.
     
     - Parameter completion:
     An escaping completion-block providing the list of file-URLs. If an error occurred, an empty list of file-URLs
     is provided and the error has a value.
     
     - Parameter fileURLs: The list of file-URLs at the given directory.
     
     - Parameter error: Has a value, when an error occurred.
     */
    func listFiles(at fileURL: URL, completion: @escaping (_ fileURLs: [URL], _ error: Error?) -> Void) {
        dispatchQueue.async {
            do {
                let urls = try self.fileIO.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                let fileURLs = self.filterFileURLs(urls: urls)
                completion(fileURLs, nil)
            } catch let error {
                completion([URL](), error)
            }
        }
    }
    
    /**
     Lists files at a given file-URL of a given type
     
     - Remark:
         As filters for the result URLResourceKey.isRegularFileKey and
         FileManager.DirectoryEnumerationOptions.skipsHiddenFiles is used. Hence the result contains only
         regular files. No hidden files, symlinks, aliases, resource-forks or directories.
         
         The type-comparison uses lastPathComponent with a case-sensitive comparison.
     
     - Parameter fileURL: The file-URL (file://) to a directory to list files of.
     
     - Parameter completion:
         An escaping completion-block providing the list of file-URLs. If an error occurred, an empty list of file-URLs
         is provided and the error has a value.
     
     - Parameter fileURLs: The list of file-URLs at the given directory.
     
     - Parameter error: Has a value, when an error occurred.
     */
    func listFiles(at fileURL: URL, ofType type: String, completion: @escaping (_ fileURLs: [URL], _ error: Error?) -> Void) {
        dispatchQueue.async {
            do {
                let urls = try self.fileIO.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                let fileURLs = self.filterFileURLs(urls: urls, ofType: type)
                completion(fileURLs, nil)
            } catch let error {
                completion([URL](), error)
            }
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






























