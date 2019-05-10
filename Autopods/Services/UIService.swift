import Cocoa

final class UIService {

    func show(_ progress: Progress) -> ProgressCoordinator {
        let (controller, window) = ProgressViewController.makeWindow()
        let coordinator = ProgressCoordinator(controller: controller, window: window, progress: progress)
        return coordinator
    }

    func openTerminal(onPath path: String) {
        guard let url = Bundle.main.url(forResource: "OpenTerminal", withExtension: "applescript"), let template = try? String(contentsOf: url) else {
            return
        }

        let source = template.replacingOccurrences(of: "PATH", with: path)
        guard let script = NSAppleScript(source: source) else {
            return
        }

        script.executeAndReturnError(nil)
    }
}
