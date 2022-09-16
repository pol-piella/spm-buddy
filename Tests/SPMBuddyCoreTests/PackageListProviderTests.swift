import Foundation
import XCTest
import SPMBuddyCore

class PackageListProviderTests: XCTestCase {
    func testWhenProviderIsCreatedThenAFileManagerIsProvided() {
        _ = PackageListProvider(fileManager: FileManager.default)
        _ = PackageListProvider()
    }
    
    func testWhenScanIsInvokedThenADirectoryPathCanBeProvided() {
        let provider = PackageListProvider()
        
        _ = provider.scan(directory: URL(string: "https://aURL.com")!)
    }
    
    func test_WhenScanIsInvokedWithADirectoryPath_ThenAListOfAllSwiftPackageFilesAreReturned() throws {
        let fileManager = FileManager()
        
        // Create a dir in the temp directory
        let directoryToScan = try createDirectoryWithPackageFile(fileManager: fileManager)
        let packageSwiftURL = directoryToScan.appendingPathComponent("Package.swift")
        let provider = PackageListProvider(fileManager: fileManager)

        let packageFiles = provider.scan(directory: directoryToScan)
        
        XCTAssertEqual(packageFiles, [packageSwiftURL])
    }
    
    // MARK: - Helpers
    
    private func createDirectoryWithPackageFile(fileManager: FileManager = .default) throws -> URL {
        // Create a dir in the temp directory
        let directory = fileManager
            .temporaryDirectory
            .appendingPathComponent("directoryWithPackages")
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        
        // Create an empty `Package.swift` file
        let packageSwiftURL = directory.appendingPathComponent("Package.swift")
        try "".write(to: packageSwiftURL, atomically: true, encoding: .utf8)
        
        // Ensure the directory is removed after the test finishes
        addTeardownBlock { [weak fileManager] in
            try? fileManager?.removeItem(at: directory)
        }
        
        return directory
    }
}
