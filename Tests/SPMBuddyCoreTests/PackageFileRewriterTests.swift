import XCTest
import Foundation

enum RewriteOption {
    case toolsVersion(to: String)
}

struct PackageFileRewriter {
    func execute(on file: URL, changing: [RewriteOption]) throws {
        let fileContents = try! String(contentsOf: file, encoding: .utf8)
        let rePattern = #"(swift-tools-version:\s?)[0-9.]*"#
        
        var modifiedContent: String = ""
        for change in changing {
            switch change {
            case let .toolsVersion(toolsVersion):
                modifiedContent = fileContents.replacingOccurrences(of: rePattern, with: "$1\(toolsVersion)", options: .regularExpression)
            }
        }
        
        try modifiedContent.write(to: file, atomically: true, encoding: .utf8)
    }
}

class PackageFileRewriterTests: XCTestCase {
    func test_GivenPackageFileRewriterIsInitialised_WhenPackageFileIsPassedIn_ThenToolsVersionCanBeUpdated() throws {
        let packageFile = try createDummyPackageFile(withVersion: "5.6")
        let rewriter = PackageFileRewriter()
        
        try rewriter.execute(on: packageFile, changing: [.toolsVersion(to: "5.7")])
        
        XCTAssertTrue(try String(contentsOf: packageFile, encoding: .utf8).contains("// swift-tools-version: 5.7"))
    }
    
    private func createDummyPackageFile(withVersion version: String) throws -> URL {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(#function)-Package.swift")
        try """
        // swift-tools-version: \(version)

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
