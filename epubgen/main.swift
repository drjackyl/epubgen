import Foundation





let semaphore = DispatchSemaphore(value: 0)

let executableName = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent

Output.printStdOut(message: "\(executableName) \(Constants.version)")

guard CommandLine.argc == 2 else {
    Output.printStdOut(message: "usage:")
    Output.printStdOut(message: "    \(executableName) config-file-name")
    Output.printStdOut(message: "")
    exit(EXIT_SUCCESS)
}

//Output.debugOutputEnabled = true

let generator = epubgen()
let configFileURL = URL(fileURLWithPath: CommandLine.arguments[1])
generator.generateEpub(withConfig: configFileURL) { () in
    semaphore.signal()
}

semaphore.wait()
