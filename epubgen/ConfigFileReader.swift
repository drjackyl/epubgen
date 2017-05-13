import Foundation





class ConfigFileReader {
    
    // MARK: - Public
    
    /**
     Reads an epubgen config-file at the given URL
     
     - Parameter fileURL: file-URL to the config-file.
     
     - Parameter completion: The completion-handler providing the config-file-string and an error.
     
     - Parameter configFileString: Contains the config-file as a String. Is an empty string, if an error occurred.
     
     - Parameter error: Has a value if a an error occurred.
     */
    func readConfigFile(at fileURL: URL, completion: @escaping (_ configFileString: String, _ error: Error?) -> Void) {
        dispatchQueue.async {
            do {
                let configFileString = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
                completion(configFileString, nil)
            } catch let error {
                completion("", error)
            }
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "ConfigFileReader")
    let fileIO = FileManager()
    
}






























