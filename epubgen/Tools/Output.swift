//
//  Output.swift
//  epubgen
//
//  Created by Felix Lieb on 10.03.17.
//  Copyright © 2017 drjackyl.de. All rights reserved.
//

import Foundation





class Output {
    static func printStdOut(message: String, addNewLine shouldAddNewLine: Bool = true) {
        var message = message
        
        if shouldAddNewLine {
            message.append("\n")
        }
        
        guard let data = message.data(using: String.Encoding.utf8) else {
            return
        }
        
        FileHandle.standardOutput.write(data)
    }
    
    static func printStdErr(message: String, addNewLine shouldAddNewLine: Bool = true) {
        var message = message
        
        if shouldAddNewLine {
            message.append("\n")
        }
        
        guard let data = message.data(using: String.Encoding.utf8) else {
            return
        }
        
        FileHandle.standardError.write(data)
    }
}

extension Output {
    
    static var debugOutputEnabled = false
    
    static func printDebug(message: String, addNewLine shouldAddNewLine: Bool = true) {
        guard debugOutputEnabled else {
            return
        }
        
        var message = "[DEBUG] \(message)"
        
        if shouldAddNewLine {
            message.append("\n")
        }
        
        guard let data = message.data(using: String.Encoding.utf8) else {
            return
        }
        
        FileHandle.standardOutput.write(data)
    }
}






























