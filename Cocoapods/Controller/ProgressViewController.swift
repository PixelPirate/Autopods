import Cocoa

final class ProgressViewController: NSViewController {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
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
}
