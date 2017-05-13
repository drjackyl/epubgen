import Foundation





class DispatchQueueFactory {
    fileprivate static let baseName = Constants.bundleId
    
    /**
     Creates a DispatchQueue with a fix base-name and the appended component-name as label.
     
     The label is bing created by appending the given componente-name to the base-name:
     <base-name>.<component-name>
     
     - parameter name: The name being appended to the base-name.
     */
    static func CreateDispatchQueue(component name: String) -> DispatchQueue {
        let label = "\(baseName).\(name)"
        return DispatchQueue(label: label)
    }
}






























