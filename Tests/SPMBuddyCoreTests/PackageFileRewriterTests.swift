import XCTest
import Foundation

enum RewriteOption {
    case toolsVersion(to: String)
}

struct PackageFileRewriter {
    func execute(on file: URL, changing: [RewriteOption]) {
        
    }
}

class PackageFileRewriterTests: XCTestCase {
    func test_GivenPackageFileRewriterIsInitialised_WhenPackageFileIsPassedIn_ThenToolsVersionCanBeUpdated() throws {
        let packageFile = try createDummyPackageFile()
        let rewriter = PackageFileRewriter()
        
        rewriter.execute(on: packageFile, changing: [.toolsVersion(to: "5.7")])
    }
    
    private func createDummyPackageFile() throws -> URL {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(#function)-Package.swift")
        try """
        // swift-tools-version: 5.6

        import PackageDescription

        let package = Package(
            name: "SPMBuddy",
            dependencies: [
                .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.4")
            ],
            targets: [
                .executableTarget(
                    name: "SPMBuddy",
                    dependencies: [
                        .product(name: "ArgumentParser", package: "swift-argument-parser")
                    ]
                ),
                .target(
                    name: "SPMBuddyCore"
                ),
                .testTarget(
                    name: "SPMBuddyCoreTests",
                    dependencies: ["SPMBuddyCore"]
                )
            ]
        )
        """.write(to: fileURL, atomically: true, encoding: .utf8)
        
        addTeardownBlock {
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        return fileURL
    }
}
