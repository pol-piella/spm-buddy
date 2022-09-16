import Foundation
import XCTest

class PackageListProvider {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func scan(directory: URL) {
        
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
}
