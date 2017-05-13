import Foundation





extension URL {
    
    /**
     A save convenience-property to access the resource-value for `URLResourceKey.isRegularFileKey`.
     
     When an error occurs while trying to get the resource-values, nil is returned as well.
     
     - Remark: Only use this property as convenient one-time-access to this information.
     */
    var isRegularFileResourceValue: Bool? {
        do {
            let resourceValues = try self.resourceValues(forKeys: [URLResourceKey.isRegularFileKey])
            return resourceValues.isRegularFile
        } catch {
            return nil
        }
    }
    
    /**
     A save convenience-property to access the resource-value for `URLResourceKey.isDirectory`.
     
     When an error occurs while trying to get the resource-values, nil is returned as well.
     
     - Remark: Only use this property as convenient one-time-access to this information.
     */
    var isDirectoryResourceValue: Bool? {
        do {
            let resourceValues = try self.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
            return resourceValues.isDirectory
        } catch {
            return nil
        }
    }
    
    /**
     Determines, whether self has the given base-URL.
     
     - Important: If both URLs are equal, false is returned. The URL must point to a children of the base-URL.
     - Parameter baseUrl: The base-URL to check.
     - Returns: True, if the url has the given base-URL, false otherwise.
     */
    func has(baseUrl: URL) -> Bool {
        let baseComponents = baseUrl.pathComponents
        let urlComponents = self.pathComponents
        
        guard urlComponents.count > baseComponents.count else {
            return false
        }
        
        for i in 0..<baseComponents.count {
            guard baseComponents[i] == urlComponents[i] else {
                return false
            }
        }
        
        return true
    }
    
    /**
     Returns a URL relative to the given base-URL, so the path within the base-URL can be accessed via URL.relativePath.
     
     - Important: The URL must point to a children of the given base-URL.
     - Parameter baseUrl: The base-URL the children are relative to.
     - Returns: A new URL with the given base-URL and the child-components in URL.relativePath, or nil, if self is not
       a child of base-URL.
     */
    func relativeTo(baseUrl: URL) -> URL? {
        guard self.has(baseUrl: baseUrl) else {
            return nil
        }
        
        let numberOfBaseComponents = baseUrl.pathComponents.count
        let urlComponents = self.pathComponents
        var relativeUrl = URL(fileURLWithPath: urlComponents[numberOfBaseComponents], relativeTo: baseUrl.standardizedFileURL)
        if urlComponents.count > numberOfBaseComponents + 1 {
            for i in numberOfBaseComponents + 1..<urlComponents.count {
                relativeUrl.appendPathComponent(urlComponents[i])
            }
        }
        return relativeUrl
    }
    
}






























