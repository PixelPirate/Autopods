import Foundation

final class FileWatchService {

    var fileWatchers: [FileWatcher] = []

    func start(watching url: URL, action: @escaping () -> Void) {
        let watcher = FileWatcher(target: url, action: action)
        fileWatchers.append(watcher)
    }

    func stop(watching url: URL) {
        guard let watcherIndex = fileWatchers.index(where: { $0.url == url }) else { return }
        fileWatchers.remove(at: watcherIndex)
    }
}
