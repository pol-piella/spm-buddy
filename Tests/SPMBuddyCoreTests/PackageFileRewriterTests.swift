import XCTest
import Foundation

struct RewriteOption {
    let executor: (String) -> String
}

extension RewriteOption {
    static func toolsVersion(to version: String) -> RewriteOption {
        return .init { contents in
            let rePattern = #"(swift-tools-version:\s?)[0-9.]*"#
            
            return contents.replacingOccurrences(of: rePattern, with: "$1\(version)", options: .regularExpression)
        }
    }
}

struct PackageFileRewriter {
    func execute(on file: URL, changing: [RewriteOption]) throws {
        let fileContents = try! String(contentsOf: file, encoding: .utf8)
        
        try changing.forEach { try $0.executor(fileContents).write(to: file, atomically: true, encoding: .utf8) }
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
