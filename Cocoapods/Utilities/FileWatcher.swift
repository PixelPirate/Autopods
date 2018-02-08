import Foundation

final class FileWatcher {

    let url: URL
    let action: () -> Void
    var fileWatch: FileWatch!

    init(target url: URL, action: @escaping () -> Void) {
        self.url = FileWatcher.gitURL(from: url)
        self.action = action
        fileWatch = try! FileWatch(paths: [self.url.path],
                                   createFlag: [.UseCFTypes, .FileEvents],
                                   runLoop: RunLoop.current,
                                   latency: 0,
                                   eventHandler: { event in
            self.action()
        })
    }

    static func gitURL(from url: URL) -> URL {
        func hasGit(at url: URL) -> Bool {
            let url = url.appendingPathComponent(".git")
            return FileManager.default.fileExists(atPath: url.path)
        }

        func findGit(at url: URL, maxDepth: Int = 4) -> URL {
            if hasGit(at: url) {
                return url
            } else {
                let depth = maxDepth - 1
                guard depth > 0 else {
                    return url
                }
                return findGit(at: url.deletingLastPathComponent(), maxDepth: depth)
            }
        }

        let gitURL = findGit(at: url).appendingPathComponent(".git").appendingPathComponent("HEAD")
        return gitURL
    }
}
