import Cocoa

final class UIService {

    func show(_ progress: Progress) -> ProgressCoordinator {
        let (controller, window) = ProgressViewController.makeWindow()
        let coordinator = ProgressCoordinator(controller: controller, window: window, progress: progress)
        return coordinator
    }
}
