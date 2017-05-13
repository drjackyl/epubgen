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
            print("\(error)")
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
            print("\(error)")
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
            print("\(error)")
        }
    }
    
}






























