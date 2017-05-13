import Foundation





class TextFileReader {
    
    // MARK: - Public
    
    /**
     Reads a text-file at the given URL
     
     - Parameter fileURL: file-URL to the text-file.
     - Parameter completion: The completion-handler providing the text-file-string and an error.
     - Parameter textFileString: Contains the text-file as a String. Is an empty string, if an error occurred.
     - Parameter error: Has a value if a an error occurred.
     */
    func readTextFile(at fileURL: URL, completion: @escaping (_ textFileString: String, _ error: Error?) -> Void) {
        dispatchQueue.async {
            do {
                let textFileString = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
                completion(textFileString, nil)
            } catch let error {
                completion("", error)
            }
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "TextFileReader")
    let fileIO = FileManager()
    
}






























