import XCTest
import Foundation





/**
 These tests don't really test anything. Rather they are for playing with the code.
 */
class FileFinder_tests: XCTestCase {

    func testFileFinder() {
        let fileFinder = FileFinder()
        
        let asyncExpectation = expectation(description: "listFilesCompletion")
        fileFinder.listFiles(at: Bundle.main.bundleURL) { (fileURLs, error) in
            print("\(fileURLs)")
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            print("\(error as Optional)")
        }
        
    }
    
    func testFileFinderInUserDirectory() {
        let fileFinder = FileFinder()
        
        let asyncExpectation = expectation(description: "listFilesInUserDirCompletion")
        
        let url = URL(fileURLWithPath: NSHomeDirectory())
        fileFinder.listFiles(at: url) { (fileURLs, error) in
            let listOfFileURLs = fileURLs.reduce("", { (result: String, url) -> String in
                return result + "\(url)\n"
            })
            print("\(listOfFileURLs)")
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            print("\(error as Optional)")
        }
    }
    
    func testFileFinderWithGivenType()
    {
        let fileFinder = FileFinder()
        
        let asyncExpectation = expectation(description: "listFilesInBundle")
        
        let url = URL(fileURLWithPath: NSHomeDirectory())
        fileFinder.listFiles(at: url, ofType: "md", completion: { (fileURLs, error) in
            let listOfFileURLs = fileURLs.reduce("", { (result: String, url) -> String in
                return result + "\(url)\n"
            })
            print("\(listOfFileURLs)")
            asyncExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 1) { (error) in
            print("\(error as Optional)")
        }
    }
    
    func testDirectoryEnumerator() {
        let url = URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub")
        let enumerator = FileManager.default.enumerator(at: url,
                                                          includingPropertiesForKeys: [URLResourceKey.isRegularFileKey, URLResourceKey.isDirectoryKey],
                                                          options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles,
                                                          errorHandler: nil)
        while let object = enumerator?.nextObject() {
            guard let url = object as? URL else {
                print("Guard failed, SKIPPING")
                continue
            }
            guard let isFile = url.isRegularFileResourceValue, isFile else {
                continue
            }
            print("\(url)")
        }
    }
    
}






























