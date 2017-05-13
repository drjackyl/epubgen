import Foundation





/**
 Provides temporary directories for the bundle
 
 - Remark: The initializer is not accessible. Use the class-function create() instead!
 */
class TemporaryDirectory {
    
    // MARK: - Public
    
    let url: URL
    
    class func create() throws -> TemporaryDirectory {
        let tmpUrl = URL(fileURLWithPath: Constants.bundleId, relativeTo: temporaryDirectory).appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tmpUrl, withIntermediateDirectories: true, attributes: [:])
        return TemporaryDirectory(url: tmpUrl)
    }
    
    func deleteContents() throws {
        let contents = try FileManager.default.contentsOfDirectory(at: self.url, includingPropertiesForKeys: [], options: [])
        for item in contents {
            try FileManager.default.removeItem(at: item)
        }
    }
    
    /**
     Deletes the the temporary directory
     
     - Remark: When this function has been used, the instance should be abandoned, as the instance-methos would throw.
     */
    func delete() throws {
        try FileManager.default.removeItem(at: self.url)
    }
    
    
    
    
    
    // MARK: - Private
    
    fileprivate init(url: URL) {
        self.url = url
    }
    
    /**
     Convenience-property for the temporary directory
     */
    fileprivate class var temporaryDirectory: URL {
        get {
            return FileManager.default.temporaryDirectory.standardizedFileURL
        }
    }
    
}






























