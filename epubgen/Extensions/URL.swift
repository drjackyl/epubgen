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
    
}






























