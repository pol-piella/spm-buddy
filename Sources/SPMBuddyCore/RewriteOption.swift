public struct RewriteOption {
    public let executor: (String) -> String
}

public extension RewriteOption {
    static func toolsVersion(to version: String) -> RewriteOption {
        return .init { contents in
            let rePattern = #"(swift-tools-version:\s?)[0-9.]*"#
            
            return contents.replacingOccurrences(of: rePattern, with: "$1\(version)", options: .regularExpression)
        }
    }
}
