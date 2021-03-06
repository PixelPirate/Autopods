import Cocoa

final class ProgressCoordinator {

    let controller: ProgressViewController
    let window: NSWindowController
    var progress: Progress

    init(controller: ProgressViewController, window: NSWindowController, progress: Progress) {
        self.controller = controller
        self.window = window
        self.progress = progress

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
                DispatchQueue.main.async {
                    controller.presentError(
                        title: "Es ist ein Fehler aufgetreten",
                        message: "\(path)\n\(error)",
                        actions: [
                            "Schließen": { [weak coordinator] in
                                coordinator?.ended?()
                            },
                            "Terminal": {
                                Services.userInterfaceService.openTerminal(onPath: path)
                            }
                        ]
                    )
                }
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
