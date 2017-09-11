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
            default:
                break
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

class Progress {

    enum Status {
        case pending
        case progress(Double)
        case ended
    }

    internal(set) var status: Status = .pending {
        didSet {
            changed?()
        }
    }

    var changed: (() -> Void)? = nil
}

extension Progress.Status: Equatable {

    static func ==(lhs: Progress.Status, rhs: Progress.Status) -> Bool {
        switch (lhs, rhs) {
        case (.pending, pending): return true
        case (.progress(let p1), .progress(let p2)) where p1 == p2: return true
        case (.ended, .ended): return true
        default: return false
        }
    }
}
