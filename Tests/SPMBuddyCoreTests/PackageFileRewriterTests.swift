import XCTest
import Foundation
import SPMBuddyCore

class PackageFileRewriterTests: XCTestCase {
    func test_GivenPackageFileRewriterIsInitialised_WhenPackageFileIsPassedIn_ThenToolsVersionCanBeUpdated() throws {
        let packageFile = try createDummyPackageFile(withVersion: "5.6")
        let rewriter = PackageFileRewriter()
        
        try rewriter.execute(on: packageFile, changing: [.toolsVersion(to: "5.7")])
        
        XCTAssertTrue(try String(contentsOf: packageFile, encoding: .utf8).contains("// swift-tools-version: 5.7"))
    }
    
    func test_GivenPackageFileRewriterIsInitialised_WhenPackageFileIsPassedIn_ThenToolsVersionCanBeDowngraded() throws {
        let packageFile = try createDummyPackageFile(withVersion: "5.6")
        let rewriter = PackageFileRewriter()
        
        try rewriter.execute(on: packageFile, changing: [.toolsVersion(to: "5.3")])
        
        XCTAssertTrue(try String(contentsOf: packageFile, encoding: .utf8).contains("// swift-tools-version: 5.3"))
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
