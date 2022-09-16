import Foundation
import XCTest

class PackageListProvider {
    let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
}

class PackageListProviderTests: XCTestCase {
    func testWhenProviderIsCreatedThenAFileManagerIsProvided() {
        let provider = PackageListProvider(fileManager: FileManager.default)
    }
}
