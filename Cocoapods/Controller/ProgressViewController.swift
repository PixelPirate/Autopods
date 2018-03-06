import Cocoa

final class ProgressViewController: NSViewController {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet var errorView: ErrorView!
    var progressView: NSView!
    
    static func makeWindow() -> (controller: ProgressViewController, window: NSWindowController) {
        let window = NSStoryboard(name: NSStoryboard.progress, bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.progress) as! NSWindowController
        guard let viewController = window.contentViewController as? ProgressViewController else {
            fatalError()
        }

        return (controller: viewController, window: window)
    }

    func animate(toValue value: Double, completion: @escaping () -> Void) {
        let start = CFAbsoluteTimeGetCurrent()
        let end = CFAbsoluteTimeGetCurrent() + 1
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [unowned self] timer in
            let current = CFAbsoluteTimeGetCurrent()
            let percent = inverseLerp(from: start, to: end, value: current)
            guard percent <= 1 else {
                timer.invalidate()
                self.view.window?.fadeOut()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: completion)
//                NSAnimationContext.runAnimationGroup({ animationContext in
//                    animationContext.duration = 1
//                    self.progressIndicator.animator().controlTint = .blueControlTint
//                }, completionHandler: {
//                    completion()
//                })
                return
            }
            let value = lerp(from: self.progressIndicator.doubleValue, to: 100, percent: percent)
            self.progressIndicator.doubleValue = value
        }
    }

    var actions: [String: () -> Void] = [:]

    func presentError(title: String, message: String, actions: [String: () -> Void]) {
        progressView = view
        errorView.titleLabel.stringValue = title
        errorView.messageText.string = message
        errorView.messageText.textColor = #colorLiteral(red: 0.9254416823, green: 0.9255238175, blue: 0.925373137, alpha: 1)
        self.actions = actions
        for button in actionButtons {
            errorView.actionsStack.addArrangedSubview(button)
        }

        view = errorView

        if let screen = NSScreen.main {
            let visibleFrame = screen.visibleFrame
            let windowSize = view.window!.frame.size
            let origin = NSPoint(x: visibleFrame.origin.x + visibleFrame.size.width - windowSize.width - 20,
                                 y: visibleFrame.origin.y + visibleFrame.size.height - windowSize.height - 20)
            view.window!.setFrameOrigin(origin)
        }

        view.window?.backgroundColor = #colorLiteral(red: 0.832826674, green: 0.261818707, blue: 0.2293474078, alpha: 1)
    }

    var actionButtons: [NSButton] {
        return actions.map {
            return NSButton(title: $0.key, target: self, action: #selector(performAction))
        }
    }

    @objc
    func performAction(sender: NSButton) {
        actions.first(where: { $0.key == sender.title })?.value()
    }
}

final class ErrorView: NSView {
    @IBOutlet var titleLabel: NSTextField!
    @IBOutlet var messageText: NSTextView!
    @IBOutlet var actionsStack: NSStackView!
}
