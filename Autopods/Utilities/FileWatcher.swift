import Foundation

final class FileWatcher {

    let url: URL
    let action: () -> Void
    var fileWatch: FileWatch!

    init(target url: URL, action: @escaping () -> Void) {
        self.url = url
        self.action = action
        fileWatch = try! FileWatch(
            paths: [self.url.path],
            createFlag: [.UseCFTypes, .FileEvents],
            runLoop: RunLoop.current,
            latency: 0,
            eventHandler: { event in
                if Services.configuration.isTrackingFiles {
                    self.action()
                }
        })
    }
}
