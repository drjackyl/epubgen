import Foundation





class ConfigFileParser {
    
    // MARK: - Public
    
    /**
     Parses a config-file-string into a Config-instance
     
     - Parameter contents: The contents of a config-file.
     - Parameter completion: The completion-handler providing a Config-instance.
     - Parameter config: The Config-instance initialized with the parsed data.
     */
    func parse(configFile contents: String, completion: @escaping (_ config: Config) -> Void) {
        dispatchQueue.async {
            let configDictionary = self.parse(configString: contents)
            completion(Config(configDictionary: configDictionary))
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    let dispatchQueue = DispatchQueueFactory.CreateDispatchQueue(component: "ConfigFileParser")
    let fileIO = FileManager()
    
    fileprivate func parse(configString: String) -> [String: String] {
        var configDictionary = [String: String]()
        configString.enumerateLines { (line: String, stop: inout Bool) in
            guard let match = RegEx.configKeyValueRegex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.count)) else {
                return
            }
            
            let key = line.substring(with: match.range(at: 1))
            let value = line.substring(with: match.range(at: 2))
            configDictionary[key] = value
        }
        return configDictionary
    }
    
}






























