//
//  EpubWriter_tests.swift
//  epubgen
//
//  Created by Felix Lieb on 14.04.17.
//  Copyright © 2017 drjackyl.de. All rights reserved.
//

import XCTest

class EpubWriter_tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEpubWriter() {
        let epub = Epub()
        let dummyId = ContentOpf.createItemUUID()
        epub.contentOpf.manifest.addItem(id: dummyId, href: "dummy.xhtml", mediaType: FileTypes.getMimeType(forPathExtension: "xhtml"))
        epub.contentOpf.spine.addItemref(idref: dummyId)
        let tocId = ContentOpf.createItemUUID()
        epub.contentOpf.manifest.addNavItem(id: tocId, href: "toc.xhtml", mediaType: FileTypes.getMimeType(forPathExtension: "xhtml"))
        epub.tocXhtml.addTocEntry(name: "Dummy", fileName: "dummy.xhtml")
        
        let temporaryDir = try! TemporaryDirectory.create()
        
        let completionHandlerExpectation = expectation(description: "writeCompletionHandlerCalled")
        let epubWriterUnderTest = EpubWriter(epub: epub, destination: temporaryDir.url)
        epubWriterUnderTest.write { (error) in
            XCTAssertNil(error)
            NSLog("EpubWriter finished writing to \(temporaryDir.url). Removing temporary directory...")
            try! temporaryDir.delete()
            completionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testEpubWriterWithFileInclusions() {
        /* Disabled because of dependency on specific paths 
         *
        let epub = Epub()
        let dummyId = ContentOpf.createItemUUID()
        epub.contentOpf.manifest.addItem(id: dummyId, href: "dummy.xhtml", mediaType: FileTypes.getMimeType(forPathExtension: "xhtml"))
        epub.contentOpf.spine.addItemref(idref: dummyId)
        let tocId = ContentOpf.createItemUUID()
        epub.contentOpf.manifest.addNavItem(id: tocId, href: "toc.xhtml", mediaType: FileTypes.getMimeType(forPathExtension: "xhtml"))
        epub.tocXhtml.addTocEntry(name: "Dummy", fileName: "dummy.xhtml")
        
        let filesToInclude = [
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/01-Cover.css"), pathInPackage: "styles/01-Cover.css"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/01-Cover.xhtml"), pathInPackage: "01-Cover.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/02-Inhalt.xhtml"), pathInPackage: "02-Inhalt.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/03-Titel.xhtml"), pathInPackage: "03-Titel.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/04-Impressum.xhtml"), pathInPackage: "04-Impressum.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/05-Zitat.xhtml"), pathInPackage: "05-Zitat.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/06-Prolog.xhtml"), pathInPackage: "06-Prolog.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/07-Kapitel-1.xhtml"), pathInPackage: "07-Kapitel-1.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/08-Kapitel-2.xhtml"), pathInPackage: "08-Kapitel-2.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/09-Kapitel-3.xhtml"), pathInPackage: "09-Kapitel-3.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/10-Kapitel-4.xhtml"), pathInPackage: "10-Kapitel-4.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/11-Kapitel-5.xhtml"), pathInPackage: "11-Kapitel-5.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/12-Kapitel-6.xhtml"), pathInPackage: "12-Kapitel-6.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/13-Kapitel-7.xhtml"), pathInPackage: "13-Kapitel-7.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/14-Kapitel-8.xhtml"), pathInPackage: "14-Kapitel-8.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/15-Kapitel-9.xhtml"), pathInPackage: "15-Kapitel-9.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/16-Kapitel-10.xhtml"), pathInPackage: "16-Kapitel-10.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/17-Kapitel-11.xhtml"), pathInPackage: "17-Kapitel-11.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/18-Kapitel-12.xhtml"), pathInPackage: "18-Kapitel-12.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/19-Kapitel-13.xhtml"), pathInPackage: "19-Kapitel-13.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/20-Kapitel-14.xhtml"), pathInPackage: "20-Kapitel-14.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/21-Kapitel-15.xhtml"), pathInPackage: "21-Kapitel-15.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/22-Kapitel-16.xhtml"), pathInPackage: "22-Kapitel-16.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/23-Kapitel-17.xhtml"), pathInPackage: "23-Kapitel-17.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/24-Kapitel-18.xhtml"), pathInPackage: "24-Kapitel-18.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/25-Kapitel-19.xhtml"), pathInPackage: "25-Kapitel-19.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/26-Kapitel-20.xhtml"), pathInPackage: "26-Kapitel-20.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/27-Kapitel-21.xhtml"), pathInPackage: "27-Kapitel-21.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/28-Kapitel-22.xhtml"), pathInPackage: "28-Kapitel-22.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/29-Kapitel-23.xhtml"), pathInPackage: "29-Kapitel-23.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/30-Kapitel-24.xhtml"), pathInPackage: "30-Kapitel-24.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/31-Epilog.xhtml"), pathInPackage: "31-Epilog.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/32-Hinweise.xhtml"), pathInPackage: "32-Hinweise.xhtml"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/cover.jpg"), pathInPackage: "images/cover.jpg"),
            EpubFileInclude(fileAt: URL(fileURLWithPath: "/Users/felix/Entwicklung/Owen/Xcode/epubgen/Resources/epub/OEBPS/style.css"), pathInPackage: "styles/style.css")
        ]
        
        let temporaryDir = try! TemporaryDirectory.create()
        
        let completionHandlerExpectation = expectation(description: "writeCompletionHandlerCalled")
        let epubWriterUnderTest = EpubWriter(epub: epub, destination: temporaryDir.url, filesToInclude: filesToInclude)
        epubWriterUnderTest.write { (error) in
            XCTAssertNil(error)
            NSLog("EpubWriter finished writing to \(temporaryDir.url). Removing temporary directory...")
//            try! temporaryDir.delete()
            completionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60)
         */
    }

}






























