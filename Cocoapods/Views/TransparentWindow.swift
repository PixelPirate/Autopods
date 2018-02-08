import Cocoa

class TransparentWindowController: NSWindowController {

    @IBInspectable var closeButton: Bool = false

    override func windowDidLoad() {
        guard let window = window else {
            fatalError()
        }

        window.isOpaque = false
        window.styleMask = NSWindow.StyleMask([
            .nonactivatingPanel,
            .titled,
            .fullSizeContentView,
            .unifiedTitleAndToolbar
        ])

        if closeButton {
            window.styleMask = window.styleMask.union(.closable)
        }

        window.isMovableByWindowBackground = false
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.showsToolbarButton = false
        window.isMovable = false
        window.standardWindowButton(NSWindow.ButtonType.fullScreenButton)?.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
        window.level = .floating

        window.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        window.contentView?.wantsLayer = true
        window.invalidateShadow()

        //.screens()[0] is the screen with the menu bar.
        if let screen = NSScreen.main {
            let visibleFrame = screen.visibleFrame
            let windowSize = window.frame.size
            let origin = NSPoint(x: visibleFrame.origin.x + visibleFrame.size.width - windowSize.width - 20,
                                 y: visibleFrame.origin.y + visibleFrame.size.height - windowSize.height - 20)
            window.setFrameOrigin(origin)
        }
        window.makeKeyAndOrderFront(self)
    }
}
