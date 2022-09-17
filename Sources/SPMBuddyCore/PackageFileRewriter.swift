import Foundation

public struct PackageFileRewriter {
    public init() {}
    
    public func execute(on file: URL, changing: [RewriteOption]) throws {
        let fileContents = try! String(contentsOf: file, encoding: .utf8)
        
        try changing.forEach { try $0.executor(fileContents).write(to: file, atomically: true, encoding: .utf8) }
    }
}
