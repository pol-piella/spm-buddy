import Foundation
import XCTest

class PackageListProvider {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func scan(directory: URL) -> [URL] {
        var files = [URL]()
        
        if let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! && fileURL.path.hasSuffix("Package.swift") {
                        files.append(fileURL.resolvingSymlinksInPath())
                    }
                } catch { print(error, fileURL) }
            }
        }

        return files
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
        let directoryToScan = fileManager
            .temporaryDirectory
            .appendingPathComponent("directoryWithPackages")
        try fileManager.createDirectory(at: directoryToScan, withIntermediateDirectories: true)
        let packageSwiftURL = directoryToScan.appendingPathComponent("Package.swift")
        try "".write(to: packageSwiftURL, atomically: true, encoding: .utf8)
        
        let provider = PackageListProvider(fileManager: fileManager)

        let packageFiles = provider.scan(directory: directoryToScan)
        
        XCTAssertEqual(packageFiles, [packageSwiftURL])
    }
}
// file:///private/var/folders/5w/n55lt3mj7_lghr_2hrckk4fw0000gn/T/directoryWithPackages/Package.swift
// file:///var/folders/5w/n55lt3mj7_lghr_2hrckk4fw0000gn/T/directoryWithPackages/Package.swift
