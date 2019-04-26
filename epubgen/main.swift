import Foundation





let semaphore = DispatchSemaphore(value: 0)

let executableName = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent

Output.printStdOut(message: "\(executableName) \(Constants.version)")

guard CommandLine.argc >= 2 else {
    Help.printShortHelp(executableName: executableName)
    exit(EXIT_SUCCESS)
}

if CommandLine.arguments[1] == "--help" {
    Help.printHelp(executableName: executableName)
    exit(EXIT_SUCCESS)
}

if CommandLine.arguments[1] == "--create-configfile" {
    let sampleConfig = Config.createSampleConfig()
    let destinationUrl = URL(fileURLWithPath: "epubgen.cfg")
    if FileManager.default.fileExists(atPath: destinationUrl.path) {
        Output.printStdErr(message: "File already exists")
        exit(EXIT_FAILURE)
    }
    
    do {
        try sampleConfig.write(to: destinationUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch let error {
        var errorMessage = ""
        errorMessage += "Failed to create config-file at\n"
        errorMessage += "    \(destinationUrl.path)\n"
        errorMessage += "\(error)"
        Output.printStdErr(message: errorMessage)
        exit(EXIT_FAILURE)
    }
    
    Output.printStdOut(message: "Configfile epubgen.cfg created")
    exit(EXIT_SUCCESS)
}

//Output.debugOutputEnabled = true

let generator: epubgen
let configFileURL: URL
if CommandLine.arguments[1] == "--epub2" {
    if CommandLine.arguments.count == 2 {
        var errorMessage = ""
        errorMessage += "Config file not defined"
        exit(EXIT_FAILURE)
    }
    generator = epub2gen()
    configFileURL = URL(fileURLWithPath: CommandLine.arguments[2])
} else {
    generator = epub3gen()
    configFileURL = URL(fileURLWithPath: CommandLine.arguments[1])
}

generator.generateEpub(withConfig: configFileURL) { () in
    semaphore.signal()
}

semaphore.wait()
