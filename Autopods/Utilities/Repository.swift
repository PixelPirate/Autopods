import Foundation

struct Repository {
    let url: URL

    init?(url: URL) {
        guard let gitURL = Repository.gitRootURL(from: url) else {
            return nil
        }
        self.url = gitURL
    }

    var name: String {
        return url.lastPathComponent
    }

    var headURL: URL {
        return Repository.gitHeadURL(fromRoot: url)
    }

    private static func gitHeadURL(fromRoot url: URL) -> URL {
        return url.appendingPathComponent(".git").appendingPathComponent("HEAD")
    }

    static func gitHeadURL(from url: URL) -> URL? {
        return gitRootURL(from: url).map(Repository.gitHeadURL(fromRoot:))
    }

    static func gitRootURL(from url: URL) -> URL? {
        func hasGit(at url: URL) -> Bool {
            let url = url.appendingPathComponent(".git")
            return FileManager.default.fileExists(atPath: url.path)
        }

        func findGit(at url: URL, maxDepth: Int = 4) -> URL? {
            if hasGit(at: url) {
                return url
            } else {
                let depth = maxDepth - 1
                guard depth > 0 else {
                    return nil
                }
                return findGit(at: url.deletingLastPathComponent(), maxDepth: depth)
            }
        }

        guard let gitURL = findGit(at: url) else {
            return nil
        }

        return gitURL
    }
}
