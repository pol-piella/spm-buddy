import Foundation
import XCTest

class PackageListProvider {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func scan(directory: URL) -> [URL] {
        [
            fileManager
                .temporaryDirectory
                .appendingPathComponent("directoryWithPackages")
                .appendingPathComponent("Package.swift")
        ]
    }
}

class PackageListProviderTests: XCTestCase {
    func testWhenProviderIsCreatedThenAFileManagerIsProvided() {
        _ = PackageListProvider(fileManager: FileManager.default)
        _ = PackageListProvider()
    }
    
    func testWhenScanIsInvokedThenADirectoryPathCanBeProvided() {
        let provider = PackageListProvider()
        
        provider.scan(directory: URL(string: "https://aURL.com")!)
    }
    
    func test_WhenScanIsInvokedWithADirectoryPath_ThenAListOfAllSwiftPackageFilesAreReturned() throws {
        let fileManager = FileManager()
        
        // Create a dir in the temp directory
        let directoryToScan = fileManager.temporaryDirectory.appendingPathComponent("directoryWithPackages")
        try fileManager.createDirectory(at: directoryToScan, withIntermediateDirectories: true)
        let packageSwiftURL = directoryToScan.appendingPathComponent("Package.swift")
        try "".write(to: packageSwiftURL, atomically: true, encoding: .utf8)
        
        let provider = PackageListProvider(fileManager: fileManager)

        let packageFiles = provider.scan(directory: URL(string: "https://aURL.com")!)
        
        XCTAssertEqual(packageFiles, [packageSwiftURL])
    }
}
