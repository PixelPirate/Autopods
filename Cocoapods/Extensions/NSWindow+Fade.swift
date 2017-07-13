import AppKit

extension NSWindow {

    func fadeIn() {
        self.alphaValue = 0
        self.makeKeyAndOrderFront(nil)
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.2
        animator().alphaValue = 1
        NSAnimationContext.endGrouping()
    }

    func fadeOut() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.2
        NSAnimationContext.current.completionHandler = { [weak self] in
            self?.orderOut(nil)
            self?.alphaValue = 1
            
        }
        animator().alphaValue = 0
        NSAnimationContext.endGrouping()
    }
}
