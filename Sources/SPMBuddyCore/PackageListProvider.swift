import Foundation

public class PackageListProvider {
    private let fileManager: FileManager
    
    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func scan(directory: URL) -> [URL] {
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
