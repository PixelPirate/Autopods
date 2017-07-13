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
        var git = url.deletingLastPathComponent()
        git.deleteLastPathComponent()
        git.appendPathComponent(".git")
        git.appendPathComponent("HEAD")
        return git
    }
}
