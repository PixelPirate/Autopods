import Cocoa

final class ProgressCoordinator {

    let controller: ProgressViewController
    let window: NSWindowController
    var progress: Progress

    init(controller: ProgressViewController, window: NSWindowController, progress: Progress) {
        self.controller = controller
        self.window = window
        self.progress = progress

        // TODO: Add ability to `Progress` to emit errors and warnings.
        
        self.progress.changed = { [weak self] in
            guard let coordinator = self else {
                return
            }

            switch coordinator.progress.status {
            case .ended:
                DispatchQueue.main.async {
                    controller.animate(toValue: 1, completion: {
                        coordinator.ended?()
                    })
                }
            case .progress(let progress):
                controller.progressIndicator.doubleValue = progress * 100
            case .error(ProcessProgress.Error.processFailed(let path, let error)):
                // TODO: Make progress view larger, display output, provide button to launch terminal.
                print("Process (\(path)) failed with error:\n\(error)")
                break
            default: break
            }
        }
    }

    deinit {
        close()
    }

    func close() {
        window.close()
    }

    var ended: (() -> Void)? = nil
}
